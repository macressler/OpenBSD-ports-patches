# $OpenBSD: Makefile,v 1.27 2013/08/23 16:57:23 naddy Exp $

COMMENT=	ls that can use color to display file attributes

DISTNAME=	ls-5.4
PKGNAME=	color${DISTNAME}
REVISION=	0
CATEGORIES=	sysutils

MAINTAINER=	Christian Weisgerber <naddy@openbsd.org>

# BSD
PERMIT_PACKAGE_CDROM=	Yes

MASTER_SITES=	http://shell.uugrn.org/~naddy/

WRKDIST=	${WRKDIR}/ls
NO_TEST=	Yes

# copy file and substitute a string near a CVS keyword
pre-patch:
	sed 's/^\.Dt LS/.Dt COLORLS/' ${WRKSRC}/ls.1 >${WRKSRC}/colorls.1

.include <bsd.port.mk>
