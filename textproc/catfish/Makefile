# $OpenBSD: Makefile,v 1.17 2014/03/14 17:26:18 ajacoutot Exp $

COMMENT =	versatile file searching tool

DISTNAME =	catfish-search-0.4.0.1
PKGNAME =	${DISTNAME:S/-search//}
CATEGORIES =	textproc
EXTRACT_SUFX =	.tar.bz2
REVISION =	4

HOMEPAGE =	http://www.twotoasts.de/index.php?/pages/catfish_summary.html

MAINTAINER =	Landry Breuil <landry@openbsd.org>

# GPLv2
PERMIT_PACKAGE_CDROM=	Yes

MASTER_SITES =	https://launchpad.net/catfish-search/0.4/0.4.0.1/+download/

MODULES=	lang/python
CONFIGURE_STYLE=none
USE_GMAKE=	Yes

RUN_DEPENDS =	devel/py-gobject3 \
		x11/dbus-python \
		devel/desktop-file-utils \
		devel/py-xdg \
		x11/gtk+2,-guic

# pygobject GTK3 introspection (not provided by indirect dependencies)
RUN_DEPENDS +=	x11/gtk+3

pre-configure:
	cd ${WRKSRC} && ${SUBST_CMD} -c Makefile.in Makefile
	cd ${WRKSRC} && ${SUBST_CMD} -c catfish.in catfish

.include <bsd.port.mk>
