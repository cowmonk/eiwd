# Installation paths. MICE uses PREFIX=/ and BINDIR=/bin.
PREFIX = /usr/local
BINDIR = $(PREFIX)/bin
MANDIR = $(PREFIX)/share/man
CONFIGDIR = /etc/iwd
STORAGEDIR = /var/lib/iwd
CONTROLSOCKET = /run/eiwd.sock

# Command-line assignments override these settings. CFLAGS, CPPFLAGS and
# LDFLAGS can also be supplied through the environment.
CC = clang
AR = ar
# These flags precede CFLAGS, so caller-supplied optimization flags win.
OPT = -O2
# CFLAGS, CPPFLAGS and LDFLAGS are intentionally not assigned here.
LDLIBS = -ldl
ELL_DIR = ell-src
RST2MAN = rst2man
