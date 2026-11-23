#include "config.h"
#include "shared/control.h"

#include <ell/ell.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/time.h>
#include <sys/un.h>
#include <unistd.h>

static void
usage(void)
{
	l_error("usage: iwctl [device list | status | networks | "
		"connect SSID [PASSPHRASE] | disconnect]");
}

/* the request the words make: tabs between them, but "device list", which
 * is one word of the protocol written as two */
static bool
make_request(int argc, char **argv, char *request, size_t size)
{
	int n;

	if (argc == 1) {
		snprintf(request, size, "%s", CONTROL_PING);
		return true;
	}
	if (argc == 3 && !strcmp(argv[1], "device") && !strcmp(argv[2], "list")) {
		snprintf(request, size, "%s", CONTROL_DEVICE_LIST);
		return true;
	}
	if ((argc == 2 && (!strcmp(argv[1], CONTROL_STATUS) ||
				!strcmp(argv[1], CONTROL_NETWORKS) ||
				!strcmp(argv[1], CONTROL_DISCONNECT))) ||
			((argc == 3 || argc == 4) && !strcmp(argv[1], CONTROL_CONNECT))) {
		n = snprintf(request, size, "%s", argv[1]);
		for (int i = 2; i < argc && n > 0 && (size_t)n < size; i++)
			n += snprintf(request + n, size - n, "\t%s", argv[i]);
		return n > 0 && (size_t)n < size;
	}
	return false;
}

int
main(int argc, char **argv)
{
	struct sockaddr_un address = { .sun_family = AF_UNIX };
	struct timeval timeout = { .tv_sec = 5 };
	const char *path = getenv("IWD_CONTROL_SOCKET");
	char request[CONTROL_REQUEST_MAX], reply[CONTROL_REPLY_MAX];
	bool ping = argc == 1, failed = false;
	ssize_t len;
	int fd = -1;

	l_log_set_stderr();
	l_log_set_ident("iwctl");
	if (!make_request(argc, argv, request, sizeof(request))) {
		usage();
		return EXIT_FAILURE;
	}
	if (!path)
		path = CONTROL_SOCKET_PATH;
	if (!*path || strlen(path) >= sizeof(address.sun_path)) {
		l_error("Invalid socket path");
		return EXIT_FAILURE;
	}
	memcpy(address.sun_path, path, strlen(path) + 1);
	fd = socket(AF_UNIX, SOCK_SEQPACKET | SOCK_CLOEXEC, 0);
	if (fd < 0)
		goto error;
	if (setsockopt(fd, SOL_SOCKET, SO_RCVTIMEO, &timeout, sizeof(timeout)) < 0 ||
			setsockopt(fd, SOL_SOCKET, SO_SNDTIMEO, &timeout, sizeof(timeout)) < 0 ||
			connect(fd, (struct sockaddr *)&address, sizeof(address)) < 0)
		goto error;
	if (L_TFR(send(fd, request, strlen(request), MSG_NOSIGNAL)) < 0)
		goto error;
	for (;;) {
		len = L_TFR(recv(fd, reply, sizeof(reply) - 1, MSG_TRUNC));
		if (len < 0)
			goto error;
		if (len == 0)
			break;
		if ((size_t)len >= sizeof(reply) || reply[len - 1]) {
			errno = EPROTO;
			goto error;
		}
		if (ping && !strcmp(reply, CONTROL_PONG)) {
			puts("ping! pong!");
			break;
		}
		if (!reply[0])
			break;
		if (!strncmp(reply, "error ", 6))
			failed = true;
		if (puts(reply) == EOF)
			break;
	}
	close(fd);
	return fflush(stdout) || ferror(stdout) || failed ? EXIT_FAILURE : EXIT_SUCCESS;

error:
	l_error("%s: %s", path, strerror(errno));
	if (fd >= 0)
		close(fd);
	return EXIT_FAILURE;
}
