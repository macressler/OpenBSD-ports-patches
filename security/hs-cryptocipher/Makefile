# $OpenBSD: Makefile,v 1.8 2013/03/11 11:41:25 espie Exp $

COMMENT=		symmetrical block and stream ciphers

DISTNAME=		cryptocipher-0.2.8
REVISION=		3
CATEGORIES=		security

MAINTAINER=		Jasper Lievisse Adriaanse <jasper@openbsd.org>

# 3-clause BSD
PERMIT_PACKAGE_CDROM =	Yes

MODULES=		lang/ghc

MODGHC_BUILD =          cabal hackage haddock register

RUN_DEPENDS =		devel/hs-mtl \
			devel/hs-vector \
			security/hs-crypto-api>=0.5
BUILD_DEPENDS = 	${RUN_DEPENDS}

.include <bsd.port.mk>
