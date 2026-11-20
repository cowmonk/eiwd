#include "config.h"
#include "shared/control.h"

#include <ell/ell.h>
#include <errno.h>
#include <net/if.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/time.h>
#include <sys/un.h>
#include <unistd.h>

int
main(int argc, char **argv)
{
	struct sockaddr_un address = { .sun_family = AF_UNIX };
	struct timeval timeout = { .tv_sec = 3 };
	const char *path = getenv("IWD_CONTROL_SOCKET");
	bool list = argc == 3 && !strcmp(argv[1], "device") && !strcmp(argv[2], "list");
	const char *request = list ? CONTROL_DEVICE_LIST : CONTROL_PING;
	char reply[IF_NAMESIZE];
	ssize_t len;
	int fd;

	l_log_set_stderr();
	l_log_set_ident("iwctl");
	if (argc != 1 && !list) {
		l_error("usage: iwctl [device list]");
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
		len = L_TFR(recv(fd, reply, sizeof(reply), MSG_TRUNC));
		if (len < 0)
			goto error;
		if (!list && len == sizeof(CONTROL_PONG) - 1 &&
				!memcmp(reply, CONTROL_PONG, len)) {
			puts("ping! pong!");
			break;
		}
		if (!list || len < 1 || (size_t)len > sizeof(reply) ||
				strnlen(reply, len) != (size_t)len - 1) {
			errno = EPROTO;
			goto error;
		}
		if (!reply[0])
			break;
		if (puts(reply) == EOF)
			break;
	}
	close(fd);
	return fflush(stdout) || ferror(stdout) ? EXIT_FAILURE : EXIT_SUCCESS;

error:
	l_error("%s: %s", path, strerror(errno));
	if (fd >= 0)
		close(fd);
	return EXIT_FAILURE;
}
