# $OpenBSD: Makefile,v 1.13 2013/03/11 10:50:06 espie Exp $

COMMENT =		meta-object system for Haskell based on Perl 6

DISTNAME =		MetaObject-0.0.6.20110925
REVISION =		1
CATEGORIES =		devel

# BSD3
PERMIT_PACKAGE_CDROM =	Yes

MODULES =		lang/ghc
MODGHC_BUILD =		cabal hackage haddock register

BUILD_DEPENDS =		${RUN_DEPENDS}
RUN_DEPENDS =		devel/hs-stringtable-atom>=0.0.6

.include <bsd.port.mk>
