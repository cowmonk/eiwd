#include "config.h"
#include "src/control.h"
#include "shared/control.h"

#include <ell/ell.h>
#include <errno.h>
#include <stdio.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <sys/un.h>
#include <unistd.h>

#ifndef CONTROL_SOCKET_GID
#define CONTROL_SOCKET_GID 10
#endif

#include "src/common.h"
#include "src/netdev.h"
#include "src/network.h"
#include "src/station.h"

struct ControlClient {
	struct l_io *io;
	struct l_timeout *timeout;
};

static struct l_io *listener;
static struct l_queue *clients;
static char *socket_path;

static void
client_free(void *data)
{
	struct ControlClient *client = data;

	l_io_set_disconnect_handler(client->io, NULL, NULL, NULL);
	l_io_destroy(client->io);
	l_timeout_remove(client->timeout);
	l_free(client);
}

static void
client_disconnect(struct l_io *io, void *data)
{
	l_queue_remove(clients, data);
	client_free(data);
}

static void
client_timeout(struct l_timeout *timeout, void *data)
{
	l_queue_remove(clients, data);
	client_free(data);
}

static bool
send_text(int fd, const char *text)
{
	size_t size = strlen(text) + 1;

	return L_TFR(send(fd, text, size, MSG_NOSIGNAL)) == (ssize_t)size;
}

static bool
send_name(const char *name, void *data)
{
	return send_text(*(int *)data, name);
}

/* every request is answered for the first wireless interface there is */
static void
first_station_cb(struct station *station, void *data)
{
	struct station **first = data;

	if (!*first)
		*first = station;
}

static struct station *
first_station(void)
{
	struct station *station = NULL;

	station_foreach(first_station_cb, &station);
	return station;
}

static const char *
state_name(enum station_state state)
{
	switch (state) {
	case STATION_STATE_CONNECTED:
	case STATION_STATE_NETCONFIG:
		return "connected";
	case STATION_STATE_CONNECTING:
	case STATION_STATE_CONNECTING_AUTO:
		return "connecting";
	case STATION_STATE_DISCONNECTING:
		return "disconnecting";
	case STATION_STATE_ROAMING:
	case STATION_STATE_FT_ROAMING:
	case STATION_STATE_FW_ROAMING:
		return "roaming";
	default:
		return "disconnected";
	}
}

static const char *
security_name(enum security security)
{
	switch (security) {
	case SECURITY_NONE:
		return "open";
	case SECURITY_WEP:
		return "wep";
	case SECURITY_PSK:
		return "psk";
	default:
		return "8021x";
	}
}

static void
send_status(int fd, struct station *station)
{
	char line[CONTROL_REPLY_MAX];
	struct network *network = station_get_connected_network(station);

	snprintf(line, sizeof(line), "%s\t%s\t%d",
			state_name(station_get_state(station)),
			network ? network_get_ssid(network) : "",
			network ? network_get_signal_strength(network) / 100 : 0);
	send_text(fd, line);
}

struct list_state {
	int fd;
	struct network *connected;
};

static void
send_network(struct network *network, void *data)
{
	struct list_state *list = data;
	char line[CONTROL_REPLY_MAX];

	snprintf(line, sizeof(line), "%s\t%s\t%d\t%s",
			network_get_ssid(network),
			security_name(network_get_security(network)),
			network_get_signal_strength(network) / 100,
			network == list->connected ? "connected" :
			network_get_settings(network) ? "known" : "");
	send_text(list->fd, line);
}

struct find_state {
	const char *ssid;
	struct network *found;
};

static void
find_network(struct network *network, void *data)
{
	struct find_state *find = data;

	if (!find->found && !strcmp(network_get_ssid(network), find->ssid))
		find->found = network;
}

/* connect <ssid> [passphrase] */
static void
do_connect(int fd, struct station *station, char *args)
{
	struct find_state find = { .ssid = args };
	char *passphrase = strchr(args, '\t');
	struct scan_bss *bss;

	if (passphrase)
		*passphrase++ = '\0';
	station_foreach_network(station, find_network, &find);
	if (!find.found) {
		send_text(fd, "error no such network");
		return;
	}
	if (network_get_security(find.found) == SECURITY_8021X ||
			network_get_security(find.found) == SECURITY_WEP) {
		send_text(fd, "error that kind of security is not supported");
		return;
	}
	if (passphrase && *passphrase &&
			network_get_security(find.found) == SECURITY_PSK &&
			!network_set_passphrase(find.found, passphrase)) {
		send_text(fd, "error not a usable passphrase");
		return;
	}
	if (network_get_security(find.found) == SECURITY_PSK &&
			!network_get_settings(find.found) &&
			(!passphrase || !*passphrase)) {
		send_text(fd, "error that network needs a passphrase");
		return;
	}
	bss = network_bss_select(find.found, true);
	if (!bss) {
		send_text(fd, "error the network is not in range");
		return;
	}
	station_connect_network(station, find.found, bss, NULL);
	send_text(fd, "ok");
}

static bool
client_read(struct l_io *io, void *data)
{
	char request[CONTROL_REQUEST_MAX + 1];
	ssize_t len;
	int fd = l_io_get_fd(io);
	struct station *station;

	len = recv(fd, request, CONTROL_REQUEST_MAX, MSG_TRUNC);
	if (len < 0 && (errno == EINTR || errno == EAGAIN))
		return true;
	if (len < 0 || len > CONTROL_REQUEST_MAX)
		goto done;
	request[len] = '\0';
	station = first_station();
	if (!strcmp(request, CONTROL_PING)) {
		send_text(fd, CONTROL_PONG);
		goto done;
	}
	if (!strcmp(request, CONTROL_DEVICE_LIST)) {
		if (!netdev_foreach_name(send_name, &fd))
			goto done;
	} else if (!station) {
		send_text(fd, "error no wireless interface");
	} else if (!strcmp(request, CONTROL_STATUS)) {
		send_status(fd, station);
	} else if (!strcmp(request, CONTROL_NETWORKS)) {
		struct list_state list = { fd, station_get_connected_network(station) };

		station_foreach_network(station, send_network, &list);
	} else if (!strncmp(request, CONTROL_CONNECT "\t",
				sizeof(CONTROL_CONNECT))) {
		do_connect(fd, station, request + sizeof(CONTROL_CONNECT));
	} else if (!strcmp(request, CONTROL_DISCONNECT)) {
		int err = station_disconnect(station);

		send_text(fd, err < 0 && err != -ENOTCONN ? "error not connected" : "ok");
	} else {
		send_text(fd, "error unknown request");
	}
	send_text(fd, "");

done:
	/* Let the disconnect handler release this client's watch. */
	shutdown(fd, SHUT_RDWR);
	return false;
}

static bool
accept_client(struct l_io *io, void *data)
{
	struct ControlClient *client;
	int fd;

	fd = accept4(l_io_get_fd(io), NULL, NULL, SOCK_CLOEXEC | SOCK_NONBLOCK);
	if (fd < 0)
		return true;
	if (l_queue_length(clients) >= 16) {
		close(fd);
		return true;
	}

	client = l_new(struct ControlClient, 1);
	client->io = l_io_new(fd);
	if (!client->io) {
		close(fd);
		l_free(client);
		return true;
	}
	l_io_set_close_on_destroy(client->io, true);
	if (!l_io_set_read_handler(client->io, client_read, client, NULL)) {
		client_free(client);
		return true;
	}
	l_io_set_disconnect_handler(client->io, client_disconnect, client, NULL);
	client->timeout = l_timeout_create(5, client_timeout, client, NULL);
	if (!client->timeout) {
		client_free(client);
		return true;
	}
	l_queue_push_tail(clients, client);
	return true;
}

int
control_init(const char *path)
{
	struct sockaddr_un address = { .sun_family = AF_UNIX };
	mode_t mask;
	int fd, err;

	if (listener)
		return -EALREADY;
	if (!*path)
		return -EINVAL;
	if (strlen(path) >= sizeof(address.sun_path))
		return -ENAMETOOLONG;
	memcpy(address.sun_path, path, strlen(path) + 1);
	fd = socket(AF_UNIX, SOCK_SEQPACKET | SOCK_CLOEXEC | SOCK_NONBLOCK, 0);
	if (fd < 0)
		return -errno;

	mask = umask(0177);
	err = bind(fd, (struct sockaddr *)&address, sizeof(address));
	if (err < 0)
		err = -errno;
	umask(mask);
	if (err < 0)
		goto close_fd;
	/*
	 * Whoever may use the network is whoever is in the group that runs the
	 * machine, wheel (10) by default: the socket is root's alone only
	 * until here.
	 */
	if (chown(path, (uid_t)-1, CONTROL_SOCKET_GID) == 0)
		chmod(path, 0660);
	if (listen(fd, 16) < 0) {
		err = -errno;
		goto unlink_socket;
	}
	listener = l_io_new(fd);
	if (!listener) {
		err = -EIO;
		goto unlink_socket;
	}
	l_io_set_close_on_destroy(listener, true);
	if (!l_io_set_read_handler(listener, accept_client, NULL, NULL)) {
		l_io_destroy(listener);
		listener = NULL;
		unlink(path);
		return -EIO;
	}
	clients = l_queue_new();
	socket_path = l_strdup(path);
	return 0;

unlink_socket:
	unlink(path);
close_fd:
	close(fd);
	return err;
}

void
control_exit(void)
{
	l_io_destroy(listener);
	listener = NULL;
	l_queue_destroy(clients, client_free);
	clients = NULL;
	if (socket_path)
		unlink(socket_path);
	l_free(socket_path);
	socket_path = NULL;
}
