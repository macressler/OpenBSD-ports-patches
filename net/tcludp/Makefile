# $OpenBSD: Makefile,v 1.2 2010/07/28 18:09:10 sebastia Exp $

SHARED_ONLY =	Yes

COMMENT =	Tcl UDP extension

DISTNAME =	tcludp-1.0.8
SHARED_LIBS =	udp108 0.0
CATEGORIES =	net

HOMEPAGE = 	http://tcludp.sourceforge.net/

MAINTAINER =	Sebastian Reitenbach <sebastia@openbsd.org>

# BSD
PERMIT_PACKAGE_CDROM =		Yes
PERMIT_PACKAGE_FTP =		Yes
PERMIT_DISTFILES_CDROM =	Yes
PERMIT_DISTFILES_FTP =		Yes

MASTER_SITES =	${MASTER_SITE_SOURCEFORGE:=tcludp/}

MODULES =		lang/tcl
BUILD_DEPENDS =		${MODTCL_BUILD_DEPENDS}
RUN_DEPENDS =		${MODTCL_RUN_DEPENDS}

SEPARATE_BUILD =	simple
CONFIGURE_STYLE =	gnu
CONFIGURE_ARGS =	--with-tcl=${MODTCL_LIBDIR} \
			--datadir=${PREFIX}/share/examples
REGRESS_TARGET =	test
CONFIGURE_ENV =		LIBudp108_VERSION=${LIBudp108_VERSION}

.include <bsd.port.mk>