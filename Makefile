.POSIX:

all: src/iwd ctl/iwctl

include config.mk
include mk/sources.mk

BUILD_CPPFLAGS = -I$(ELL_DIR) -I. -DHAVE_CONFIG_H \
	-Dtypeof=__typeof__ \
	-DVERSION='"$(VERSION)"' -DDAEMON_CONFIGDIR='"$(CONFIGDIR)"' \
	-DDAEMON_STORAGEDIR='"$(STORAGEDIR)"' \
	-DCONTROL_SOCKET_PATH='"$(CONTROLSOCKET)"' \
	-DUNITDIR='"unit/"' -DCERTDIR='"unit/"' $(CPPFLAGS)
BUILD_CFLAGS = -std=c99 -fvisibility=hidden $(OPT) $(CFLAGS)
IWD_OBJ = $(IWD_SRC:.c=.o) src/control.o
CTL_OBJ = ctl/main.o
MONITOR_OBJ = $(MONITOR_SRC:.c=.o)
MANPAGES = src/iwd.8 src/iwd.debug.7 src/iwd.config.5 \
	src/iwd.network.5 src/iwd.ap.5 monitor/iwmon.1
CERTS = unit/cert-ca.pem unit/cert-server.pem \
	unit/cert-server-key-pkcs8.pem unit/cert-client.pem \
	unit/cert-client-key-pkcs8.pem unit/tls-settings.8021x

.SUFFIXES: .c .o .rst .1 .5 .7 .8

.c.o:
	$(CC) $(BUILD_CPPFLAGS) $(BUILD_CFLAGS) -c -o $@ $<

$(IWD_OBJ) $(CTL_OBJ) $(MONITOR_OBJ) $(TEST_OBJ): Makefile config.h config.mk mk/sources.mk $(HEADERS) $(ELL_HEADERS) $(ELL_DIR)/ell/ell.h

src/main.o src/control.o ctl/main.o: src/control.h shared/control.h

$(ELL_OBJ): Makefile config.h config.mk mk/sources.mk $(ELL_HEADERS) $(ELL_DIR)/ell/ell.h
	mkdir -p build/ell
	source=$(ELL_DIR)/ell/$$(basename "$@" .o).c; \
	$(CC) $(BUILD_CPPFLAGS) $(BUILD_CFLAGS) -c -o $@ "$$source"

libell.a: $(ELL_OBJ)
	rm -f $@
	$(AR) rcs $@ $(ELL_OBJ)

src/iwd: $(IWD_OBJ) libell.a
	$(CC) $(LDFLAGS) -o $@ $(IWD_OBJ) libell.a $(LDLIBS)

ctl/iwctl: $(CTL_OBJ) libell.a
	$(CC) $(LDFLAGS) -o $@ $(CTL_OBJ) libell.a $(LDLIBS)

monitor: monitor/iwmon

monitor/iwmon: $(MONITOR_OBJ) libell.a
	$(CC) $(LDFLAGS) -o $@ $(MONITOR_OBJ) libell.a $(LDLIBS)

check: $(TESTS)
	sh scripts/check-tests $(TESTS)

unit/test-eapol: $(CERTS)

unit/tls-settings.8021x: unit/gencerts.cnf scripts/test-certs
	sh scripts/test-certs

# Keep certificate generation in one recipe when building with make -j.
unit/cert-ca.pem unit/cert-server.pem unit/cert-server-key-pkcs8.pem \
unit/cert-client.pem unit/cert-client-key-pkcs8.pem: unit/tls-settings.8021x
	@test -f $@ || { printf 'Missing $@; run make clean first.\n' >&2; exit 1; }

.rst.1:
	$(RST2MAN) --strict --no-raw --no-generator --no-datestamp $< $@
.rst.5:
	$(RST2MAN) --strict --no-raw --no-generator --no-datestamp $< $@
.rst.7:
	$(RST2MAN) --strict --no-raw --no-generator --no-datestamp $< $@
.rst.8:
	$(RST2MAN) --strict --no-raw --no-generator --no-datestamp $< $@

man: $(MANPAGES)

install: all
	mkdir -p $(DESTDIR)$(BINDIR) $(DESTDIR)$(CONFIGDIR) $(DESTDIR)$(STORAGEDIR)
	cp src/iwd $(DESTDIR)$(BINDIR)/iwd
	cp ctl/iwctl $(DESTDIR)$(BINDIR)/iwctl
	chmod 755 $(DESTDIR)$(BINDIR)/iwd $(DESTDIR)$(BINDIR)/iwctl
	chmod 700 $(DESTDIR)$(STORAGEDIR)

install-monitor: monitor
	mkdir -p $(DESTDIR)$(BINDIR)
	cp monitor/iwmon $(DESTDIR)$(BINDIR)/iwmon
	chmod 755 $(DESTDIR)$(BINDIR)/iwmon

install-man: man
	for page in $(MANPAGES); do \
		section=$$(printf '%s\n' "$$page" | sed 's/.*\.//'); \
		name=$$(basename "$$page"); \
		mkdir -p $(DESTDIR)$(MANDIR)/man$$section; \
		cp $$page $(DESTDIR)$(MANDIR)/man$$section/$$name || exit 1; \
		chmod 644 $(DESTDIR)$(MANDIR)/man$$section/$$name || exit 1; \
	done

uninstall:
	rm -f $(DESTDIR)$(BINDIR)/iwd $(DESTDIR)$(BINDIR)/iwctl $(DESTDIR)$(BINDIR)/iwmon
	for page in $(MANPAGES); do \
		section=$$(printf '%s\n' "$$page" | sed 's/.*\.//'); \
		name=$$(basename "$$page"); \
		rm -f $(DESTDIR)$(MANDIR)/man$$section/$$name; \
	done

clean:
	rm -f $(IWD_OBJ) $(CTL_OBJ) $(MONITOR_OBJ) $(TEST_OBJ) $(ELL_OBJ) libell.a \
		src/iwd ctl/iwctl monitor/iwmon $(TESTS) $(MANPAGES) \
		unit/cert-*.pem unit/cert-*.csr unit/cert-*.srl unit/tls-settings.8021x
