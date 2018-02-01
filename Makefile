# Copyright (c) 2003 Maxim Sobolev <sobomax@FreeBSD.org>
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.
#
# $Id: Makefile,v 1.3 2004/07/19 05:19:55 sobomax Exp $
#
# Linux Makefile by Matt Smith <mcs@darkregion.net>, 2011/01/04

CC ?= clang
AR ?= ar
EXECINFO_CFLAGS=$(CFLAGS) -O2 -pipe -fno-strict-aliasing -std=gnu99 -fstack-protector -c
EXECINFO_LDFLAGS=$(LDFLAGS)

INCLUDEDIR ?= /usr/include
LIBDIR ?= /usr/lib

all: libexecinfo.a libexecinfo.so.1

libexecinfo.a:
	$(CC) $(EXECINFO_CFLAGS) $(EXECINFO_LDFLAGS) stacktraverse.c
	$(CC) $(EXECINFO_CFLAGS) $(EXECINFO_LDFLAGS) execinfo.c
	$(AR) rcs libexecinfo.a stacktraverse.o execinfo.o

libexecinfo.so.1:
	$(CC) -fpic -DPIC $(EXECINFO_CFLAGS) $(EXECINFO_LDFLAGS) stacktraverse.c -o stacktraverse.So
	$(CC) -fpic -DPIC $(EXECINFO_CFLAGS) $(EXECINFO_LDFLAGS) execinfo.c -o execinfo.So
	$(CC) -shared -Wl,-soname,libexecinfo.so.1 -o libexecinfo.so.1 stacktraverse.So execinfo.So

install: libexecinfo.a libexecinfo.so.1
	install -d $(DESTDIR)$(INCLUDEDIR)
	install -m 755 execinfo.h       $(DESTDIR)$(INCLUDEDIR)
	install -m 755 stacktraverse.h  $(DESTDIR)$(INCLUDEDIR)
	
	install -d $(DESTDIR)$(LIBDIR)
	install -m 755 libexecinfo.a    $(DESTDIR)$(LIBDIR)
	install -m 755 libexecinfo.so.1 $(DESTDIR)$(LIBDIR)
	
	ln -s /usr/lib/libexecinfo.so.1 $(DESTDIR)$(LIBDIR)/libexecinfo.so
clean:
	rm -rf *.o *.So *.a *.so *.so.1

.PHONY: all
.PHONY: install
.PHONY: clean
