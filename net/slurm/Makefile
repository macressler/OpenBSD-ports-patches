# $OpenBSD: Makefile,v 1.7 2013/03/11 11:35:56 espie Exp $

COMMENT =	network traffic monitor and statistics
DISTNAME =	slurm-0.3.3
REVISION =	1
CATEGORIES =	net

HOMEPAGE =	http://www.wormulon.net/slurm/

MAINTAINER =	Ryan Freeman <ryan@slipgate.org>

# GPLv2+
PERMIT_PACKAGE_CDROM =	Yes

WANTLIB =	c ncurses

MASTER_SITES =	${HOMEPAGE}

CONFIGURE_STYLE =	gnu
USE_GROFF =	Yes

pre-configure:
	@${SUBST_CMD} ${WRKSRC}/theme.c ${WRKSRC}/slurm.1

do-install:
	${INSTALL_PROGRAM} ${WRKBUILD}/slurm ${PREFIX}/bin/
	${INSTALL_DATA_DIR} ${PREFIX}/share/doc/slurm/
	${INSTALL_DATA_DIR} ${PREFIX}/share/slurm/
.for i in COPYRIGHT FAQ THANKS COPYING
	${INSTALL_DATA} ${WRKBUILD}/$i ${PREFIX}/share/doc/slurm/
.endfor
	${INSTALL_DATA} ${WRKBUILD}/themes/*.theme ${PREFIX}/share/slurm/
	${INSTALL_MAN} ${WRKBUILD}/slurm.1 ${PREFIX}/man/man1/

.include <bsd.port.mk>
