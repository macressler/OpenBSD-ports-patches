# $OpenBSD: Makefile,v 1.6 2013/03/11 11:42:46 espie Exp $

COMMENT=		show differences between XML files/DOM trees

MODPY_EGG_VERSION=	0.6.10
DISTNAME=		xmldiff-${MODPY_EGG_VERSION}
PKGNAME=		py-xmldiff-${MODPY_EGG_VERSION}
REVISION=		2
CATEGORIES=		textproc

HOMEPAGE=		http://www.logilab.org/859/

# GPLv2
PERMIT_PACKAGE_CDROM=	Yes

MODULES=		lang/python

MASTER_SITES=		http://ftp.logilab.org/pub/xmldiff/

RUN_DEPENDS=		shells/bash \
			textproc/py-xml

WANTLIB +=		${MODPY_WANTLIB}

pre-configure:
	${SUBST_CMD} ${WRKSRC}/bin/{xmldiff,xmlrev}

do-test:
	@cd ${WRKSRC}/test/ && \
		${MODPY_BIN} runtests.py

.include <bsd.port.mk>
