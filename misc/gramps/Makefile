# $OpenBSD: Makefile,v 1.33 2014/07/03 11:20:06 ajacoutot Exp $

COMMENT=		Genealogical Research Analysis Management Programming System

MODPY_EGG_VERSION=	4.1.0
DISTNAME=		gramps-${MODPY_EGG_VERSION}

CATEGORIES=		misc x11

HOMEPAGE=		http://www.gramps-project.org/

# GPLv2
PERMIT_PACKAGE_CDROM=	Yes

MASTER_SITES=		${MASTER_SITE_SOURCEFORGE:=gramps/}

MODULES=		lang/python \
			textproc/intltool

RUN_DEPENDS=		devel/desktop-file-utils \
			devel/py-gobject3 \
			devel/xdg-utils \
			geo/osm-gps-map \
			graphics/goocanvas \
			graphics/libgexiv2 \
			graphics/py-Pillow \
			${MODPY_RUN_DEPENDS},-bsddb \
			math/graphviz \
			misc/shared-mime-info \
			textproc/gtkspell3 \
			textproc/py-ICU \
			www/webkit,gtk3 \
			x11/gtk+2,-guic

MODPY_DISTUTILS_BUILD=	build
NO_TEST=		Yes

pre-configure:
	perl -pi -e 's,/usr/share,${PREFIX}/share,g' ${WRKSRC}/data/gramps.keys.in
	perl -pi -e 's,share/man,man,g' ${WRKSRC}/setup.py

post-install:
	echo -n '${TRUEPREFIX}/share' \
		>${PREFIX}/lib/python${MODPY_VERSION}/site-packages/gramps/gen/utils/resource-path
	gunzip ${PREFIX}/man/*/{,*}/*.gz

.include <bsd.port.mk>
