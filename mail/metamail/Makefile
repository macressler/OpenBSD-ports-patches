# $OpenBSD: Makefile,v 1.29 2013/11/30 15:13:06 jca Exp $

COMMENT=	MIME implementation

DISTNAME=	mm2.7
PKGNAME=	metamail-2.7
REVISION=	4
CATEGORIES=	mail

MASTER_SITES=	http://www.guppylake.com/~nsb/metamail/
EXTRACT_SUFX=	.tar.Z

PERMIT_PACKAGE_CDROM=	Yes

WANTLIB=	c termcap
# mkfontdir & friends
USE_X11 =	Yes

WRKSRC=		${WRKDIST}/src
MAKE_FLAGS=	CC="${CC}" CFLAGS="-DHAVE_TCGETATTR ${CFLAGS}"
NO_TEST=	Yes

post-configure:
	@${SUBST_CMD} ${WRKSRC}/config.h

pre-install:
	@cd ${WRKSRC}/bin && rm -f *.orig

.include <bsd.port.mk>
