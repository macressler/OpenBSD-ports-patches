# $OpenBSD: Makefile,v 1.8 2013/03/11 10:50:25 espie Exp $

COMMENT=		add support for i18n, documentation and icons to distutils

MODPY_EGG_VERSION=	2.36
DISTNAME=		python-distutils-extra-${MODPY_EGG_VERSION}
PKGNAME=		py-distutils-extra-${MODPY_EGG_VERSION}

CATEGORIES=		devel

HOMEPAGE=		http://www.glatzor.de/projects/python-distutils-extra/

# GPLv2
PERMIT_PACKAGE_CDROM=	Yes

MASTER_SITES=		https://launchpad.net/python-distutils-extra/trunk/${MODPY_EGG_VERSION}/+download/

MODULES=		lang/python
MODPY_SETUPTOOLS=	Yes

.include <bsd.port.mk>
