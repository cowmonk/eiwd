#include "config.h"
#include "src/control.h"
#include "shared/control.h"

#include <ell/ell.h>
#include <errno.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <sys/un.h>
#include <unistd.h>

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
client_read(struct l_io *io, void *data)
{
	char request[sizeof(CONTROL_PING)];
	ssize_t len;
	int fd = l_io_get_fd(io);

	len = recv(fd, request, sizeof(request), MSG_TRUNC);
	if (len < 0 && (errno == EINTR || errno == EAGAIN))
		return true;
	if (len == sizeof(CONTROL_PING) - 1 &&
			!memcmp(request, CONTROL_PING, len)) {
		do {
			len = send(fd, CONTROL_PONG, sizeof(CONTROL_PONG) - 1,
					MSG_NOSIGNAL);
		} while (len < 0 && errno == EINTR);
	}

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
