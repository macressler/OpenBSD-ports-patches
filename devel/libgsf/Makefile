# $OpenBSD: Makefile,v 1.81 2014/04/02 09:36:10 jasper Exp $

COMMENT=		GNOME Structured File library

GNOME_PROJECT=		libgsf
GNOME_VERSION=		1.14.30

CATEGORIES=		devel

SHARED_LIBS +=  gsf-1                114.12   # 114.27

MAINTAINER=		Jasper Lievisse Adriaanse <jasper@openbsd.org>, \
			Antoine Jacoutot <ajacoutot@openbsd.org>

# LGPL 2.1
PERMIT_PACKAGE_CDROM=	Yes

WANTLIB += bz2 c ffi gdk_pixbuf-2.0 gio-2.0 glib-2.0 gmodule-2.0
WANTLIB += gobject-2.0 m pcre png pthread xml2 z

MODULES=		devel/gettext \
			x11/gnome

MODGNOME_TOOLS +=	gobject-introspection

LIB_DEPENDS=		archivers/bzip2 \
			graphics/gdk-pixbuf2 \
			textproc/libxml

CONFIGURE_STYLE=	gnu

.include <bsd.port.mk>
