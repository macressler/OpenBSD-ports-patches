# $OpenBSD: Makefile,v 1.4 2014/05/07 15:42:16 kurt Exp $

COMMENT=		open source alternative to Microsoft Project

DISTNAME=		projectlibre-1.5.7
CATEGORIES=		productivity
REVISION=		0

MAINTAINER=		Jasper Lievisse Adriaanse <jasper@openbsd.org>

HOMEPAGE=		http://www.projectlibre.org/

# Common Public Attribution License
PERMIT_PACKAGE_CDROM=   Yes

MASTER_SITES=	${MASTER_SITE_SOURCEFORGE:=projectlibre/}

MODULES=	java
MODJAVA_VER=	1.6+
MODJAVA_JRERUN=	Yes

RUN_DEPENDS=	java/javaPathHelper

NO_BUILD=       Yes
NO_TEST=	Yes

PKG_ARCH=       *

do-install:
	@${SUBST_CMD} -o ${BINOWN} -g ${BINGRP} -c \
		${FILESDIR}/projectlibre \
		${PREFIX}/bin/projectlibre
	chmod +x ${PREFIX}/bin/projectlibre
	${INSTALL_DATA_DIR} ${PREFIX}/lib/projectlibre/lib/
	${INSTALL_DATA} ${WRKSRC}/projectlibre.jar ${PREFIX}/lib/projectlibre/
	${INSTALL_DATA} ${WRKSRC}/lib/* ${PREFIX}/lib/projectlibre/lib/

.include <bsd.port.mk>
