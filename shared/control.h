#ifndef EIWD_CONTROL_PROTOCOL_H
#define EIWD_CONTROL_PROTOCOL_H

/*
 * One request a connection, answered by packets of text each ended by a NUL,
 * and a packet with nothing in it to end the answer. A request's words are
 * separated by a tab, so a network's name may hold spaces.
 *
 *   ping!                           pong!
 *   device list                     a wireless interface a packet
 *   status                          "state ssid signal" of the first one,
 *                                   state being connected, connecting,
 *                                   disconnecting, roaming or disconnected,
 *                                   signal in dBm, ssid empty when none
 *   networks                        "ssid security signal flag" a packet,
 *                                   strongest first; security is open, wep,
 *                                   psk or 8021x, flag connected, known or
 *                                   empty
 *   connect <ssid> [passphrase]     ok, or "error why". a passphrase is
 *                                   kept as the network's own once it works
 *   disconnect                      ok, or "error why"
 */
#define CONTROL_PING "ping!"
#define CONTROL_PONG "pong!"
#define CONTROL_DEVICE_LIST "device list"
#define CONTROL_STATUS "status"
#define CONTROL_NETWORKS "networks"
#define CONTROL_CONNECT "connect"
#define CONTROL_DISCONNECT "disconnect"
#define CONTROL_REQUEST_MAX 512
#define CONTROL_REPLY_MAX 256

#endif
