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

int
main(void)
{
	struct sockaddr_un address = { .sun_family = AF_UNIX };
	struct timeval timeout = { .tv_sec = 3 };
	const char *path = getenv("IWD_CONTROL_SOCKET");
	char reply[sizeof(CONTROL_PONG)];
	ssize_t len;
	int fd;

	l_log_set_stderr();
	l_log_set_ident("iwctl");
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
	do {
		len = send(fd, CONTROL_PING, sizeof(CONTROL_PING) - 1, MSG_NOSIGNAL);
	} while (len < 0 && errno == EINTR);
	if (len < 0)
		goto error;
	do {
		len = recv(fd, reply, sizeof(reply), MSG_TRUNC);
	} while (len < 0 && errno == EINTR);
	if (len < 0)
		goto error;
	if (len != sizeof(CONTROL_PONG) - 1 ||
			memcmp(reply, CONTROL_PONG, sizeof(CONTROL_PONG) - 1)) {
		errno = EPROTO;
		goto error;
	}
	close(fd);
	return puts("ping! pong!") == EOF ? EXIT_FAILURE : EXIT_SUCCESS;

error:
	l_error("%s: %s", path, strerror(errno));
	if (fd >= 0)
		close(fd);
	return EXIT_FAILURE;
}
