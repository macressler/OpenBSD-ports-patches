# $OpenBSD: Makefile,v 1.4 2014/07/11 15:16:09 bentley Exp $

COMMENT =		convert POD data to mdoc input

DISTNAME =		pod2mdoc-0.0.12

CATEGORIES =		textproc

HOMEPAGE =		http://mdocml.bsd.lv/pod2mdoc/

MAINTAINER =		Anthony J. Bentley <anthony@cathet.us>

# ISC
PERMIT_PACKAGE_CDROM =	Yes

WANTLIB += c

MASTER_SITES =		http://mdocml.bsd.lv/pod2mdoc/snapshots/
EXTRACT_SUFX =		.tgz

MAKE_FLAGS =		CC="${CC}" \
			CFLAGS="${CFLAGS}"

NO_TEST =		Yes

ALL_TARGET =		pod2mdoc

do-install:
	${INSTALL_PROGRAM} ${WRKDIST}/pod2mdoc ${PREFIX}/bin
	${INSTALL_MAN} ${WRKDIST}/pod2mdoc.1 ${PREFIX}/man/man1

.include <bsd.port.mk>
