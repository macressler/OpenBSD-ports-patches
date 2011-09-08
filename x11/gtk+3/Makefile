# $OpenBSD: Makefile,v 1.18 2011/07/28 06:51:16 ajacoutot Exp $

SHARED_ONLY=	Yes

COMMENT-main=	multi-platform graphical toolkit
COMMENT-docs=	gtk+3 documentation
COMMENT-cups=	gtk+3 CUPS print backend

V=		3.0.12
DISTNAME=	gtk+-${V}

PKGNAME-main=	gtk+3-${V}
PKGNAME-docs=	gtk+3-docs-${V}
PKGNAME-cups=	gtk+3-cups-${V}

CATEGORIES=	x11 devel

SHARED_LIBS +=  gdk-3                0.0      # 0.4
SHARED_LIBS +=  gtk-3                0.0      # 0.4
SHARED_LIBS +=  gailutil-3           0.0      # 0.0

HOMEPAGE=	http://www.gtk.org/

MAINTAINER=	Antoine Jacoutot <ajacoutot@openbsd.org>

# LGPLv2
PERMIT_PACKAGE_CDROM=	Yes
PERMIT_PACKAGE_FTP=	Yes
PERMIT_DISTFILES_CDROM=	Yes
PERMIT_DISTFILES_FTP=	Yes

WANTLIB += X11 Xau Xcomposite Xcursor Xdamage Xdmcp Xext Xfixes Xi
WANTLIB += Xinerama Xrandr Xrender cairo expat fontconfig freetype
WANTLIB += gthread-2.0 m pcre pixman-1 pthread-stubs xcb gio-2.0
WANTLIB += xcb-render z gdk_pixbuf-2.0 GL Xxf86vm drm xcb-shm png
WANTLIB += gmodule-2.0 gobject-2.0 atk-1.0 cairo-gobject glib-2.0
WANTLIB += pango-1.0 pangocairo-1.0 pangoft2-1.0

MASTER_SITES=	${MASTER_SITE_GNOME:=sources/gtk+/${V:C/^([0-9]+\.[0-9]+).*/\1/}/}
EXTRACT_SUFX=	.tar.bz2

MULTI_PACKAGES=	-main -docs -cups

MODULES=	devel/gettext \
		devel/dconf

BUILD_DEPENDS=	devel/gobject-introspection

RUN_DEPENDS-main= ${RUN_DEPENDS} \
		x11/hicolor-icon-theme \
		misc/shared-mime-info

LIB_DEPENDS-main= ${LIB_DEPENDS} \
		devel/glib2>=2.28.0 \
		devel/pango>=1.28.4p0 \
		devel/atk>=2.0.0p0 \
		graphics/gdk-pixbuf2

WANTLIB-main += ${WANTLIB}
WANTLIB-main += c pthread

LIB_DEPENDS-docs= # empty
RUN_DEPENDS-docs= # empty
WANTLIB-docs +=	# empty
PKG_ARCH-docs=	*

RUN_DEPENDS-cups= # empty
LIB_DEPENDS-cups= ${LIB_DEPENDS} \
		print/cups \
		STEM->=${V}:${BASE_PKGPATH},-main

WANTLIB-cups += ${WANTLIB}
WANTLIB-cups += asn1 crypto cups gdk-3 gssapi gtk-3 krb5 ssl

USE_GMAKE=	Yes
USE_LIBTOOL=	Yes
REGRESS_IS_INTERACTIVE= x11

CONFIGURE_STYLE= gnu
CONFIGURE_ENV=	CPPFLAGS="-I${X11BASE}/include/freetype2/ \
			-I${LOCALBASE}/include \
			-I${LOCALBASE}/include/libpng" \
		LDFLAGS="-L${LOCALBASE}/lib"
CONFIGURE_ARGS=	${CONFIGURE_SHARED} \
		--disable-gtk-doc \
		--disable-man \
		--disable-papi \
		--disable-packagekit \
		--enable-introspection \
		--without-xml-catalog

# Do not build gtk-update-icon-cache and other shared tools.
CONFIGURE_ARGS += --enable-gtk2-dependency
BUILD_DEPENDS += ${RUN_DEPENDS}
RUN_DEPENDS +=	x11/gtk+2

FAKE_FLAGS=	sysconfdir=${PREFIX}/share/examples/gtk+3

.include <bsd.port.mk>