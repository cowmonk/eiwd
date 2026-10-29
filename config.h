/* Linux with musl or glibc; no configure-time probes. */
#ifndef EIWD_CONFIG_H
#define EIWD_CONFIG_H

#ifndef _GNU_SOURCE
#define _GNU_SOURCE
#endif
#ifndef _FILE_OFFSET_BITS
#define _FILE_OFFSET_BITS 64
#endif

#include <features.h>

#define HAVE_LINUX_TYPES_H 1
#define HAVE_LINUX_IF_ALG_H 1
#define HAVE_EXPLICIT_BZERO 1
#define HAVE_REALLOCARRAY 1

#ifdef __GLIBC__ /* Disgusting */
#define HAVE_RAWMEMCHR 1
#endif

#endif
