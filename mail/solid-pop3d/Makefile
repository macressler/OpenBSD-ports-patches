# $OpenBSD: Makefile,v 1.28 2013/04/27 15:44:21 ajacoutot Exp $

COMMENT=	flexible POP3 server

VERSION=	0.15
DISTNAME=	solid-pop3d-${VERSION}
REVISION =	6
CATEGORIES=	mail
MASTER_SITES=	ftp://dione.ids.pl/pub/solidpop3d/

HOMEPAGE=	http://solidpop3d.pld.org.pl/

PERMIT_PACKAGE_CDROM=   Yes
WANTLIB=		c

FLAVORS=	apop 
FLAVOR?=

LOCALSTATEDIR=	${BASELOCALSTATEDIR}/spool/spop3d

SEPARATE_BUILD= Yes
CONFIGURE_STYLE= gnu
CONFIGURE_ARGS+= --mandir="${PREFIX}/man" \
		 --enable-last --enable-bulletins --enable-nonip \
		 --enable-ipv6 --enable-resolve --enable-connect \
		 --enable-logextend --enable-statistics 
USE_GROFF =	Yes
NO_TEST=	Yes

# enable support for APOP authentication.
.if ${FLAVOR:Mapop}
CONFIGURE_ARGS+= --enable-userconfig --enable-apop
.else
CONFIGURE_ARGS+= --disable-userconfig --disable-apop
.endif

.include <bsd.port.mk>
