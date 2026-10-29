# Imported by scripts/import-upstream; review changes when updating iwd.
VERSION = 3.12

ELL_SRC = \
	$(ELL_DIR)/ell/util.c \
	$(ELL_DIR)/ell/test.c \
	$(ELL_DIR)/ell/test-dbus.c \
	$(ELL_DIR)/ell/strv.c \
	$(ELL_DIR)/ell/utf8.c \
	$(ELL_DIR)/ell/queue.c \
	$(ELL_DIR)/ell/hashmap.c \
	$(ELL_DIR)/ell/string.c \
	$(ELL_DIR)/ell/settings.c \
	$(ELL_DIR)/ell/main.c \
	$(ELL_DIR)/ell/idle.c \
	$(ELL_DIR)/ell/signal.c \
	$(ELL_DIR)/ell/timeout.c \
	$(ELL_DIR)/ell/io.c \
	$(ELL_DIR)/ell/ringbuf.c \
	$(ELL_DIR)/ell/log.c \
	$(ELL_DIR)/ell/checksum.c \
	$(ELL_DIR)/ell/netlink.c \
	$(ELL_DIR)/ell/genl.c \
	$(ELL_DIR)/ell/rtnl.c \
	$(ELL_DIR)/ell/dbus.c \
	$(ELL_DIR)/ell/dbus-message.c \
	$(ELL_DIR)/ell/dbus-util.c \
	$(ELL_DIR)/ell/dbus-service.c \
	$(ELL_DIR)/ell/dbus-client.c \
	$(ELL_DIR)/ell/dbus-name-cache.c \
	$(ELL_DIR)/ell/dbus-filter.c \
	$(ELL_DIR)/ell/gvariant-util.c \
	$(ELL_DIR)/ell/siphash.c \
	$(ELL_DIR)/ell/hwdb.c \
	$(ELL_DIR)/ell/cipher.c \
	$(ELL_DIR)/ell/random.c \
	$(ELL_DIR)/ell/uintset.c \
	$(ELL_DIR)/ell/base64.c \
	$(ELL_DIR)/ell/pem.c \
	$(ELL_DIR)/ell/tls.c \
	$(ELL_DIR)/ell/tls-record.c \
	$(ELL_DIR)/ell/tls-suites.c \
	$(ELL_DIR)/ell/tls-extensions.c \
	$(ELL_DIR)/ell/uuid.c \
	$(ELL_DIR)/ell/key.c \
	$(ELL_DIR)/ell/file.c \
	$(ELL_DIR)/ell/dir.c \
	$(ELL_DIR)/ell/net.c \
	$(ELL_DIR)/ell/dhcp.c \
	$(ELL_DIR)/ell/dhcp-transport.c \
	$(ELL_DIR)/ell/dhcp-lease.c \
	$(ELL_DIR)/ell/dhcp-util.c \
	$(ELL_DIR)/ell/dhcp-server.c \
	$(ELL_DIR)/ell/cert.c \
	$(ELL_DIR)/ell/cert-crypto.c \
	$(ELL_DIR)/ell/ecc-external.c \
	$(ELL_DIR)/ell/ecc.c \
	$(ELL_DIR)/ell/ecdh.c \
	$(ELL_DIR)/ell/time.c \
	$(ELL_DIR)/ell/path.c \
	$(ELL_DIR)/ell/dhcp6.c \
	$(ELL_DIR)/ell/icmp6.c \
	$(ELL_DIR)/ell/dhcp6-lease.c \
	$(ELL_DIR)/ell/dhcp6-transport.c \
	$(ELL_DIR)/ell/acd.c \
	$(ELL_DIR)/ell/netconfig.c \
	$(ELL_DIR)/ell/sysctl.c \
	$(ELL_DIR)/ell/notifylist.c \
	$(ELL_DIR)/ell/minheap.c

ELL_HEADERS = \
	$(ELL_DIR)/ell/util.h \
	$(ELL_DIR)/ell/test.h \
	$(ELL_DIR)/ell/strv.h \
	$(ELL_DIR)/ell/utf8.h \
	$(ELL_DIR)/ell/queue.h \
	$(ELL_DIR)/ell/hashmap.h \
	$(ELL_DIR)/ell/string.h \
	$(ELL_DIR)/ell/settings.h \
	$(ELL_DIR)/ell/main.h \
	$(ELL_DIR)/ell/idle.h \
	$(ELL_DIR)/ell/signal.h \
	$(ELL_DIR)/ell/timeout.h \
	$(ELL_DIR)/ell/io.h \
	$(ELL_DIR)/ell/ringbuf.h \
	$(ELL_DIR)/ell/log.h \
	$(ELL_DIR)/ell/checksum.h \
	$(ELL_DIR)/ell/netlink.h \
	$(ELL_DIR)/ell/genl.h \
	$(ELL_DIR)/ell/dbus.h \
	$(ELL_DIR)/ell/rtnl.h \
	$(ELL_DIR)/ell/dbus-service.h \
	$(ELL_DIR)/ell/dbus-client.h \
	$(ELL_DIR)/ell/hwdb.h \
	$(ELL_DIR)/ell/cipher.h \
	$(ELL_DIR)/ell/random.h \
	$(ELL_DIR)/ell/uintset.h \
	$(ELL_DIR)/ell/base64.h \
	$(ELL_DIR)/ell/pem.h \
	$(ELL_DIR)/ell/tls.h \
	$(ELL_DIR)/ell/uuid.h \
	$(ELL_DIR)/ell/key.h \
	$(ELL_DIR)/ell/file.h \
	$(ELL_DIR)/ell/dir.h \
	$(ELL_DIR)/ell/net.h \
	$(ELL_DIR)/ell/dhcp.h \
	$(ELL_DIR)/ell/cert.h \
	$(ELL_DIR)/ell/ecc.h \
	$(ELL_DIR)/ell/ecdh.h \
	$(ELL_DIR)/ell/time.h \
	$(ELL_DIR)/ell/path.h \
	$(ELL_DIR)/ell/icmp6.h \
	$(ELL_DIR)/ell/dhcp6.h \
	$(ELL_DIR)/ell/acd.h \
	$(ELL_DIR)/ell/cleanup.h \
	$(ELL_DIR)/ell/netconfig.h \
	$(ELL_DIR)/ell/sysctl.h \
	$(ELL_DIR)/ell/notifylist.h \
	$(ELL_DIR)/ell/minheap.h \
	$(ELL_DIR)/ell/private.h \
	$(ELL_DIR)/ell/missing.h \
	$(ELL_DIR)/ell/test-private.h \
	$(ELL_DIR)/ell/main-private.h \
	$(ELL_DIR)/ell/netlink-private.h \
	$(ELL_DIR)/ell/rtnl-private.h \
	$(ELL_DIR)/ell/dbus-private.h \
	$(ELL_DIR)/ell/gvariant-private.h \
	$(ELL_DIR)/ell/siphash-private.h \
	$(ELL_DIR)/ell/asn1-private.h \
	$(ELL_DIR)/ell/pem-private.h \
	$(ELL_DIR)/ell/tls-private.h \
	$(ELL_DIR)/ell/net-private.h \
	$(ELL_DIR)/ell/dhcp-private.h \
	$(ELL_DIR)/ell/cert-private.h \
	$(ELL_DIR)/ell/ecc-private.h \
	$(ELL_DIR)/ell/time-private.h \
	$(ELL_DIR)/ell/dhcp6-private.h \
	$(ELL_DIR)/ell/icmp6-private.h \
	$(ELL_DIR)/ell/useful.h

IWD_SRC = \
	src/main.c \
	src/netdev.c \
	src/wiphy.c \
	src/device.c \
	src/station.c \
	src/ie.c \
	src/dbus.c \
	src/mpdu.c \
	src/eapol.c \
	src/eapolutil.c \
	src/handshake.c \
	src/scan.c \
	src/common.c \
	src/agent.c \
	src/storage.c \
	src/network.c \
	src/wsc.c \
	src/backtrace.c \
	src/knownnetworks.c \
	src/rfkill.c \
	src/ft.c \
	src/ap.c \
	src/adhoc.c \
	src/sae.c \
	src/nl80211util.c \
	src/nl80211cmd.c \
	src/owe.c \
	src/blacklist.c \
	src/manager.c \
	src/erp.c \
	src/fils.c \
	src/anqp.c \
	src/anqputil.c \
	src/netconfig.c \
	src/netconfig-commit.c \
	src/resolve.c \
	src/hotspot.c \
	src/p2p.c \
	src/p2putil.c \
	src/module.c \
	src/rrm.c \
	src/frame-xchg.c \
	src/eap-wsc.c \
	src/wscutil.c \
	src/diagnostic.c \
	src/ip-pool.c \
	src/band.c \
	src/sysfs.c \
	src/offchannel.c \
	src/dpp-util.c \
	src/json.c \
	src/dpp.c \
	src/udev.c \
	src/pmksa.c \
	src/vendor_quirks.c \
	src/eap.c \
	src/eap-md5.c \
	src/eap-tls.c \
	src/eap-ttls.c \
	src/eap-mschapv2.c \
	src/eap-sim.c \
	src/eap-aka.c \
	src/eap-peap.c \
	src/eap-gtc.c \
	src/eap-pwd.c \
	src/util.c \
	src/crypto.c \
	src/simutil.c \
	src/simauth.c \
	src/watchlist.c \
	src/eap-tls-common.c \
	src/mschaputil.c

MONITOR_SRC = \
	monitor/main.c \
	monitor/nlmon.c \
	monitor/pcap.c \
	monitor/display.c \
	src/ie.c \
	src/wscutil.c \
	src/mpdu.c \
	src/util.c \
	src/crypto.c \
	src/watchlist.c \
	src/eapolutil.c \
	src/nl80211cmd.c \
	src/p2putil.c \
	src/anqputil.c \
	src/band.c

HEADERS = \
	linux/nl80211.h \
	src/iwd.h \
	src/missing.h \
	src/defs.h \
	src/netdev.h \
	src/wiphy.h \
	src/station.h \
	src/ie.h \
	src/dbus.h \
	src/mpdu.h \
	src/eapol.h \
	src/eapolutil.h \
	src/handshake.h \
	src/scan.h \
	src/common.h \
	src/agent.h \
	src/storage.h \
	src/network.h \
	src/wsc.h \
	src/backtrace.h \
	src/knownnetworks.h \
	src/rfkill.h \
	src/ft.h \
	src/ap.h \
	src/sae.h \
	src/nl80211util.h \
	src/nl80211cmd.h \
	src/owe.h \
	src/blacklist.h \
	src/erp.h \
	src/fils.h \
	src/auth-proto.h \
	src/anqp.h \
	src/anqputil.h \
	src/netconfig.h \
	src/resolve.h \
	src/p2p.h \
	src/p2putil.h \
	src/module.h \
	src/frame-xchg.h \
	src/eap-wsc.h \
	src/wscutil.h \
	src/diagnostic.h \
	src/ip-pool.h \
	src/band.h \
	src/sysfs.h \
	src/offchannel.h \
	src/dpp-util.h \
	src/json.h \
	src/pmksa.h \
	src/vendor_quirks.h \
	src/eap.h \
	src/eap-private.h \
	src/eap-mschapv2.h \
	src/util.h \
	src/crypto.h \
	src/simutil.h \
	src/simauth.h \
	src/watchlist.h \
	src/eap-tls-common.h \
	src/mschaputil.h \
	monitor/nlmon.h \
	monitor/pcap.h \
	monitor/display.h

ELL_OBJ = \
	build/ell/util.o \
	build/ell/test.o \
	build/ell/test-dbus.o \
	build/ell/strv.o \
	build/ell/utf8.o \
	build/ell/queue.o \
	build/ell/hashmap.o \
	build/ell/string.o \
	build/ell/settings.o \
	build/ell/main.o \
	build/ell/idle.o \
	build/ell/signal.o \
	build/ell/timeout.o \
	build/ell/io.o \
	build/ell/ringbuf.o \
	build/ell/log.o \
	build/ell/checksum.o \
	build/ell/netlink.o \
	build/ell/genl.o \
	build/ell/rtnl.o \
	build/ell/dbus.o \
	build/ell/dbus-message.o \
	build/ell/dbus-util.o \
	build/ell/dbus-service.o \
	build/ell/dbus-client.o \
	build/ell/dbus-name-cache.o \
	build/ell/dbus-filter.o \
	build/ell/gvariant-util.o \
	build/ell/siphash.o \
	build/ell/hwdb.o \
	build/ell/cipher.o \
	build/ell/random.o \
	build/ell/uintset.o \
	build/ell/base64.o \
	build/ell/pem.o \
	build/ell/tls.o \
	build/ell/tls-record.o \
	build/ell/tls-suites.o \
	build/ell/tls-extensions.o \
	build/ell/uuid.o \
	build/ell/key.o \
	build/ell/file.o \
	build/ell/dir.o \
	build/ell/net.o \
	build/ell/dhcp.o \
	build/ell/dhcp-transport.o \
	build/ell/dhcp-lease.o \
	build/ell/dhcp-util.o \
	build/ell/dhcp-server.o \
	build/ell/cert.o \
	build/ell/cert-crypto.o \
	build/ell/ecc-external.o \
	build/ell/ecc.o \
	build/ell/ecdh.o \
	build/ell/time.o \
	build/ell/path.o \
	build/ell/dhcp6.o \
	build/ell/icmp6.o \
	build/ell/dhcp6-lease.o \
	build/ell/dhcp6-transport.o \
	build/ell/acd.o \
	build/ell/netconfig.o \
	build/ell/sysctl.o \
	build/ell/notifylist.o \
	build/ell/minheap.o

build/ell/util.o: $(ELL_DIR)/ell/util.c
build/ell/test.o: $(ELL_DIR)/ell/test.c
build/ell/test-dbus.o: $(ELL_DIR)/ell/test-dbus.c
build/ell/strv.o: $(ELL_DIR)/ell/strv.c
build/ell/utf8.o: $(ELL_DIR)/ell/utf8.c
build/ell/queue.o: $(ELL_DIR)/ell/queue.c
build/ell/hashmap.o: $(ELL_DIR)/ell/hashmap.c
build/ell/string.o: $(ELL_DIR)/ell/string.c
build/ell/settings.o: $(ELL_DIR)/ell/settings.c
build/ell/main.o: $(ELL_DIR)/ell/main.c
build/ell/idle.o: $(ELL_DIR)/ell/idle.c
build/ell/signal.o: $(ELL_DIR)/ell/signal.c
build/ell/timeout.o: $(ELL_DIR)/ell/timeout.c
build/ell/io.o: $(ELL_DIR)/ell/io.c
build/ell/ringbuf.o: $(ELL_DIR)/ell/ringbuf.c
build/ell/log.o: $(ELL_DIR)/ell/log.c
build/ell/checksum.o: $(ELL_DIR)/ell/checksum.c
build/ell/netlink.o: $(ELL_DIR)/ell/netlink.c
build/ell/genl.o: $(ELL_DIR)/ell/genl.c
build/ell/rtnl.o: $(ELL_DIR)/ell/rtnl.c
build/ell/dbus.o: $(ELL_DIR)/ell/dbus.c
build/ell/dbus-message.o: $(ELL_DIR)/ell/dbus-message.c
build/ell/dbus-util.o: $(ELL_DIR)/ell/dbus-util.c
build/ell/dbus-service.o: $(ELL_DIR)/ell/dbus-service.c
build/ell/dbus-client.o: $(ELL_DIR)/ell/dbus-client.c
build/ell/dbus-name-cache.o: $(ELL_DIR)/ell/dbus-name-cache.c
build/ell/dbus-filter.o: $(ELL_DIR)/ell/dbus-filter.c
build/ell/gvariant-util.o: $(ELL_DIR)/ell/gvariant-util.c
build/ell/siphash.o: $(ELL_DIR)/ell/siphash.c
build/ell/hwdb.o: $(ELL_DIR)/ell/hwdb.c
build/ell/cipher.o: $(ELL_DIR)/ell/cipher.c
build/ell/random.o: $(ELL_DIR)/ell/random.c
build/ell/uintset.o: $(ELL_DIR)/ell/uintset.c
build/ell/base64.o: $(ELL_DIR)/ell/base64.c
build/ell/pem.o: $(ELL_DIR)/ell/pem.c
build/ell/tls.o: $(ELL_DIR)/ell/tls.c
build/ell/tls-record.o: $(ELL_DIR)/ell/tls-record.c
build/ell/tls-suites.o: $(ELL_DIR)/ell/tls-suites.c
build/ell/tls-extensions.o: $(ELL_DIR)/ell/tls-extensions.c
build/ell/uuid.o: $(ELL_DIR)/ell/uuid.c
build/ell/key.o: $(ELL_DIR)/ell/key.c
build/ell/file.o: $(ELL_DIR)/ell/file.c
build/ell/dir.o: $(ELL_DIR)/ell/dir.c
build/ell/net.o: $(ELL_DIR)/ell/net.c
build/ell/dhcp.o: $(ELL_DIR)/ell/dhcp.c
build/ell/dhcp-transport.o: $(ELL_DIR)/ell/dhcp-transport.c
build/ell/dhcp-lease.o: $(ELL_DIR)/ell/dhcp-lease.c
build/ell/dhcp-util.o: $(ELL_DIR)/ell/dhcp-util.c
build/ell/dhcp-server.o: $(ELL_DIR)/ell/dhcp-server.c
build/ell/cert.o: $(ELL_DIR)/ell/cert.c
build/ell/cert-crypto.o: $(ELL_DIR)/ell/cert-crypto.c
build/ell/ecc-external.o: $(ELL_DIR)/ell/ecc-external.c
build/ell/ecc.o: $(ELL_DIR)/ell/ecc.c
build/ell/ecdh.o: $(ELL_DIR)/ell/ecdh.c
build/ell/time.o: $(ELL_DIR)/ell/time.c
build/ell/path.o: $(ELL_DIR)/ell/path.c
build/ell/dhcp6.o: $(ELL_DIR)/ell/dhcp6.c
build/ell/icmp6.o: $(ELL_DIR)/ell/icmp6.c
build/ell/dhcp6-lease.o: $(ELL_DIR)/ell/dhcp6-lease.c
build/ell/dhcp6-transport.o: $(ELL_DIR)/ell/dhcp6-transport.c
build/ell/acd.o: $(ELL_DIR)/ell/acd.c
build/ell/netconfig.o: $(ELL_DIR)/ell/netconfig.c
build/ell/sysctl.o: $(ELL_DIR)/ell/sysctl.c
build/ell/notifylist.o: $(ELL_DIR)/ell/notifylist.c
build/ell/minheap.o: $(ELL_DIR)/ell/minheap.c

TESTS = \
	unit/test-eap-sim \
	unit/test-cmac-aes \
	unit/test-arc4 \
	unit/test-hmac-md5 \
	unit/test-hmac-sha1 \
	unit/test-hmac-sha256 \
	unit/test-prf-sha1 \
	unit/test-kdf-sha256 \
	unit/test-ie \
	unit/test-band \
	unit/test-crypto \
	unit/test-mpdu \
	unit/test-eapol \
	unit/test-util \
	unit/test-ssid-security \
	unit/test-wsc \
	unit/test-eap-mschapv2 \
	unit/test-sae \
	unit/test-p2p \
	unit/test-dpp \
	unit/test-json \
	unit/test-nl80211util \
	unit/test-pmksa \
	unit/test-storage

unit_test_eap_sim_OBJ = \
	unit/test-eap-sim.c \
	src/crypto.c \
	src/simutil.c \
	src/ie.c \
	src/watchlist.c \
	src/eapol.c \
	src/eapolutil.c \
	src/handshake.c \
	src/pmksa.c \
	src/eap.c \
	src/util.c \
	src/simauth.c \
	src/erp.c \
	src/band.c \
	src/eap-sim.c

unit/test-eap-sim: $(unit_test_eap_sim_OBJ:.c=.o) libell.a
	$(CC) $(LDFLAGS) -o $@ $(unit_test_eap_sim_OBJ:.c=.o) libell.a $(LDLIBS)

unit_test_cmac_aes_OBJ = \
	unit/test-cmac-aes.c \
	src/crypto.c

unit/test-cmac-aes: $(unit_test_cmac_aes_OBJ:.c=.o) libell.a
	$(CC) $(LDFLAGS) -o $@ $(unit_test_cmac_aes_OBJ:.c=.o) libell.a $(LDLIBS)

unit_test_arc4_OBJ = \
	unit/test-arc4.c \
	src/crypto.c

unit/test-arc4: $(unit_test_arc4_OBJ:.c=.o) libell.a
	$(CC) $(LDFLAGS) -o $@ $(unit_test_arc4_OBJ:.c=.o) libell.a $(LDLIBS)

unit_test_hmac_md5_OBJ = \
	unit/test-hmac-md5.c \
	src/crypto.c

unit/test-hmac-md5: $(unit_test_hmac_md5_OBJ:.c=.o) libell.a
	$(CC) $(LDFLAGS) -o $@ $(unit_test_hmac_md5_OBJ:.c=.o) libell.a $(LDLIBS)

unit_test_hmac_sha1_OBJ = \
	unit/test-hmac-sha1.c \
	src/crypto.c

unit/test-hmac-sha1: $(unit_test_hmac_sha1_OBJ:.c=.o) libell.a
	$(CC) $(LDFLAGS) -o $@ $(unit_test_hmac_sha1_OBJ:.c=.o) libell.a $(LDLIBS)

unit_test_hmac_sha256_OBJ = \
	unit/test-hmac-sha256.c \
	src/crypto.c

unit/test-hmac-sha256: $(unit_test_hmac_sha256_OBJ:.c=.o) libell.a
	$(CC) $(LDFLAGS) -o $@ $(unit_test_hmac_sha256_OBJ:.c=.o) libell.a $(LDLIBS)

unit_test_prf_sha1_OBJ = \
	unit/test-prf-sha1.c \
	src/crypto.c

unit/test-prf-sha1: $(unit_test_prf_sha1_OBJ:.c=.o) libell.a
	$(CC) $(LDFLAGS) -o $@ $(unit_test_prf_sha1_OBJ:.c=.o) libell.a $(LDLIBS)

unit_test_kdf_sha256_OBJ = \
	unit/test-kdf-sha256.c \
	src/crypto.c

unit/test-kdf-sha256: $(unit_test_kdf_sha256_OBJ:.c=.o) libell.a
	$(CC) $(LDFLAGS) -o $@ $(unit_test_kdf_sha256_OBJ:.c=.o) libell.a $(LDLIBS)

unit_test_ie_OBJ = \
	unit/test-ie.c \
	src/ie.c

unit/test-ie: $(unit_test_ie_OBJ:.c=.o) libell.a
	$(CC) $(LDFLAGS) -o $@ $(unit_test_ie_OBJ:.c=.o) libell.a $(LDLIBS)

unit_test_band_OBJ = \
	unit/test-band.c \
	src/band.c \
	src/ie.c

unit/test-band: $(unit_test_band_OBJ:.c=.o) libell.a
	$(CC) $(LDFLAGS) -o $@ $(unit_test_band_OBJ:.c=.o) libell.a $(LDLIBS)

unit_test_crypto_OBJ = \
	unit/test-crypto.c \
	src/crypto.c

unit/test-crypto: $(unit_test_crypto_OBJ:.c=.o) libell.a
	$(CC) $(LDFLAGS) -o $@ $(unit_test_crypto_OBJ:.c=.o) libell.a $(LDLIBS)

unit_test_mpdu_OBJ = \
	unit/test-mpdu.c \
	src/mpdu.c \
	src/ie.c

unit/test-mpdu: $(unit_test_mpdu_OBJ:.c=.o) libell.a
	$(CC) $(LDFLAGS) -o $@ $(unit_test_mpdu_OBJ:.c=.o) libell.a $(LDLIBS)

unit_test_eapol_OBJ = \
	unit/test-eapol.c \
	src/crypto.c \
	src/ie.c \
	src/watchlist.c \
	src/eapol.c \
	src/eapolutil.c \
	src/handshake.c \
	src/pmksa.c \
	src/eap.c \
	src/eap-tls.c \
	src/eap-ttls.c \
	src/eap-md5.c \
	src/util.c \
	src/eap-tls-common.c \
	src/erp.c \
	src/band.c \
	src/mschaputil.c

unit/test-eapol: $(unit_test_eapol_OBJ:.c=.o) libell.a
	$(CC) $(LDFLAGS) -o $@ $(unit_test_eapol_OBJ:.c=.o) libell.a $(LDLIBS)

unit_test_util_OBJ = \
	src/util.c \
	src/band.c \
	unit/test-util.c

unit/test-util: $(unit_test_util_OBJ:.c=.o) libell.a
	$(CC) $(LDFLAGS) -o $@ $(unit_test_util_OBJ:.c=.o) libell.a $(LDLIBS)

unit_test_ssid_security_OBJ = \
	unit/test-ssid-security.c \
	src/ie.c \
	src/common.c

unit/test-ssid-security: $(unit_test_ssid_security_OBJ:.c=.o) libell.a
	$(CC) $(LDFLAGS) -o $@ $(unit_test_ssid_security_OBJ:.c=.o) libell.a $(LDLIBS)

unit_test_wsc_OBJ = \
	unit/test-wsc.c \
	src/wscutil.c \
	src/crypto.c \
	src/ie.c \
	src/watchlist.c \
	src/eapol.c \
	src/eapolutil.c \
	src/handshake.c \
	src/pmksa.c \
	src/eap.c \
	src/util.c \
	src/erp.c \
	src/band.c \
	src/eap-wsc.c

unit/test-wsc: $(unit_test_wsc_OBJ:.c=.o) libell.a
	$(CC) $(LDFLAGS) -o $@ $(unit_test_wsc_OBJ:.c=.o) libell.a $(LDLIBS)

unit_test_eap_mschapv2_OBJ = \
	src/eap-mschapv2.c \
	src/eap.c \
	src/mschaputil.c \
	unit/test-eap-mschapv2.c

unit/test-eap-mschapv2: $(unit_test_eap_mschapv2_OBJ:.c=.o) libell.a
	$(CC) $(LDFLAGS) -o $@ $(unit_test_eap_mschapv2_OBJ:.c=.o) libell.a $(LDLIBS)

unit_test_sae_OBJ = \
	unit/test-sae.c \
	src/sae.c \
	src/crypto.c \
	src/ie.c \
	src/handshake.c \
	src/pmksa.c \
	src/erp.c \
	src/band.c \
	src/util.c \
	src/mpdu.c

unit/test-sae: $(unit_test_sae_OBJ:.c=.o) libell.a
	$(CC) $(LDFLAGS) -o $@ $(unit_test_sae_OBJ:.c=.o) -Wl,-wrap,l_ecc_supported_ike_groups libell.a $(LDLIBS)

unit_test_p2p_OBJ = \
	unit/test-p2p.c \
	src/wscutil.c \
	src/crypto.c \
	src/ie.c \
	src/util.c \
	src/p2putil.c \
	src/band.c

unit/test-p2p: $(unit_test_p2p_OBJ:.c=.o) libell.a
	$(CC) $(LDFLAGS) -o $@ $(unit_test_p2p_OBJ:.c=.o) libell.a $(LDLIBS)

unit_test_dpp_OBJ = \
	unit/test-dpp.c \
	src/dpp-util.c \
	src/band.c \
	src/util.c \
	src/crypto.c \
	src/json.c

unit/test-dpp: $(unit_test_dpp_OBJ:.c=.o) libell.a
	$(CC) $(LDFLAGS) -o $@ $(unit_test_dpp_OBJ:.c=.o) libell.a $(LDLIBS)

unit_test_json_OBJ = \
	unit/test-json.c \
	src/json.c

unit/test-json: $(unit_test_json_OBJ:.c=.o) libell.a
	$(CC) $(LDFLAGS) -o $@ $(unit_test_json_OBJ:.c=.o) libell.a $(LDLIBS)

unit_test_nl80211util_OBJ = \
	unit/test-nl80211util.c \
	src/nl80211util.c \
	src/band.c \
	src/ie.c \
	src/util.c

unit/test-nl80211util: $(unit_test_nl80211util_OBJ:.c=.o) libell.a
	$(CC) $(LDFLAGS) -o $@ $(unit_test_nl80211util_OBJ:.c=.o) libell.a $(LDLIBS)

unit_test_pmksa_OBJ = \
	unit/test-pmksa.c \
	src/pmksa.c

unit/test-pmksa: $(unit_test_pmksa_OBJ:.c=.o) libell.a
	$(CC) $(LDFLAGS) -o $@ $(unit_test_pmksa_OBJ:.c=.o) libell.a $(LDLIBS)

unit_test_storage_OBJ = \
	unit/test-storage.c \
	src/storage.c \
	src/crypto.c \
	src/common.c

unit/test-storage: $(unit_test_storage_OBJ:.c=.o) libell.a
	$(CC) $(LDFLAGS) -o $@ $(unit_test_storage_OBJ:.c=.o) libell.a $(LDLIBS)

TEST_OBJ = \
	$(unit_test_eap_sim_OBJ:.c=.o) \
	$(unit_test_cmac_aes_OBJ:.c=.o) \
	$(unit_test_arc4_OBJ:.c=.o) \
	$(unit_test_hmac_md5_OBJ:.c=.o) \
	$(unit_test_hmac_sha1_OBJ:.c=.o) \
	$(unit_test_hmac_sha256_OBJ:.c=.o) \
	$(unit_test_prf_sha1_OBJ:.c=.o) \
	$(unit_test_kdf_sha256_OBJ:.c=.o) \
	$(unit_test_ie_OBJ:.c=.o) \
	$(unit_test_band_OBJ:.c=.o) \
	$(unit_test_crypto_OBJ:.c=.o) \
	$(unit_test_mpdu_OBJ:.c=.o) \
	$(unit_test_eapol_OBJ:.c=.o) \
	$(unit_test_util_OBJ:.c=.o) \
	$(unit_test_ssid_security_OBJ:.c=.o) \
	$(unit_test_wsc_OBJ:.c=.o) \
	$(unit_test_eap_mschapv2_OBJ:.c=.o) \
	$(unit_test_sae_OBJ:.c=.o) \
	$(unit_test_p2p_OBJ:.c=.o) \
	$(unit_test_dpp_OBJ:.c=.o) \
	$(unit_test_json_OBJ:.c=.o) \
	$(unit_test_nl80211util_OBJ:.c=.o) \
	$(unit_test_pmksa_OBJ:.c=.o) \
	$(unit_test_storage_OBJ:.c=.o)

