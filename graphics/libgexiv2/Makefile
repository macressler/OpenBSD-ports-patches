# $OpenBSD: Makefile,v 1.16 2014/04/26 05:42:59 ajacoutot Exp $

COMMENT=	GObject wrapper around exiv2

GNOME_VERSION=	0.10.1
GNOME_PROJECT=	gexiv2
PKGNAME=	lib${DISTNAME}

CATEGORIES=	graphics

SHARED_LIBS +=  gexiv2               2.0      # 2.0

# GPLv2
PERMIT_PACKAGE_CDROM=	Yes

WANTLIB += exiv2 expat ffi glib-2.0 gobject-2.0 m pcre pthread
WANTLIB += stdc++ z

MODULES=	devel/gettext \
		x11/gnome

MODGNOME_TOOLS=	gobject-introspection

LIB_DEPENDS=	graphics/exiv2 \
		devel/glib2

CONFIGURE_STYLE=gnu

.include <bsd.port.mk>
