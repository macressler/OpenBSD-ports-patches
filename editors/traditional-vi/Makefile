# $OpenBSD: Makefile,v 1.2 2013/03/11 11:02:50 espie Exp $

COMMENT =		traditional vi and ex

DISTNAME =		ex-050325
PKGNAME =		traditional-vi-20050325

CATEGORIES =		editors

HOMEPAGE =		http://ex-vi.sourceforge.net/

MAINTAINER =		Pascal Stumpf <Pascal.Stumpf@cubes.de>

# BSD-style, libuxre is LGPLv2.1
PERMIT_PACKAGE_CDROM =	Yes

WANTLIB =		c ncurses

MASTER_SITES =		${MASTER_SITE_SOURCEFORGE:=ex-vi/}
EXTRACT_SUFX =		.tar.bz2

USE_GROFF =		Yes

MAKE_FLAGS =		PREFIX="${PREFIX}"

NO_TEST =		Yes

do-install:
	${INSTALL_PROGRAM} ${WRKSRC}/ex ${PREFIX}/bin/traditional-ex
.for _l in edit vedit vi view
	cd ${PREFIX}/bin && ln traditional-ex ${PREFIX}/bin/traditional-${_l}
.endfor
	${INSTALL_PROGRAM} ${WRKSRC}/exrecover ${PREFIX}/libexec
	${INSTALL_PROGRAM} ${WRKSRC}/expreserve ${PREFIX}/libexec
	${INSTALL_MAN} ${WRKSRC}/vi.1 ${PREFIX}/man/man1/traditional-vi.1
	${INSTALL_MAN} ${WRKSRC}/ex.1 ${PREFIX}/man/man1/traditional-ex.1
	cd ${PREFIX}/man/man1 && ln traditional-ex.1 \
		${PREFIX}/man/man1/traditional-edit.1
	cd ${PREFIX}/man/man1 && ln traditional-vi.1 \
		${PREFIX}/man/man1/traditional-vedit.1
	cd ${PREFIX}/man/man1 && ln traditional-vi.1 \
		${PREFIX}/man/man1/traditional-view.1

.include <bsd.port.mk>
