# $OpenBSD: Makefile,v 1.19 2014/04/01 14:52:09 ajacoutot Exp $

COMMENT=		python bindings for libnotify

V=			0.1.1
DISTNAME=		notify-python-${V}
PKGNAME=		py-notify-${V}
REVISION =		11
CATEGORIES=		devel

HOMEPAGE=		http://www.galago-project.org/

# LGPL
PERMIT_PACKAGE_CDROM=	Yes

WANTLIB += GL X11 Xau Xcomposite Xcursor Xdamage Xdmcp Xext Xfixes
WANTLIB += Xi Xinerama Xrandr Xrender Xxf86vm atk-1.0 cairo drm
WANTLIB += expat ffi fontconfig freetype gdk-x11-2.0 gdk_pixbuf-2.0
WANTLIB += gio-2.0 glib-2.0 gmodule-2.0 gobject-2.0 gthread-2.0
WANTLIB += gtk-x11-2.0 m notify pango-1.0 pangocairo-1.0 pangoft2-1.0
WANTLIB += pcre pixman-1 png pthread-stubs xcb xcb-render xcb-shm
WANTLIB += z

MASTER_SITES=		${HOMEPAGE}/files/releases/source/notify-python/
EXTRACT_SUFX=		.tar.bz2

MODULES=		devel/gettext \
			lang/python

BUILD_DEPENDS=		${RUN_DEPENDS}
RUN_DEPENDS=		x11/py-gtk2
LIB_DEPENDS=		devel/libnotify>=0.7.2 \
			x11/gtk+2 \
			devel/libffi

USE_GMAKE=		Yes

CONFIGURE_STYLE=	gnu
CONFIGURE_ENV=		CPPFLAGS="-I${LOCALBASE}/include" \
			LDFLAGS="-L${LOCALBASE}/lib"

# Force regen of pynotify.c to include missing functions.
# See http://trac.galago-project.org/ticket/121
post-extract:
	rm ${WRKSRC}/src/pynotify.c

post-install:
	rm ${PREFIX}/lib/python${MODPY_VERSION}/site-packages/gtk-2.0/pynotify/*.{a,la}

.include <bsd.port.mk>
