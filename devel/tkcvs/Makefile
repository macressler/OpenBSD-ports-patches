# $OpenBSD: Makefile,v 1.32 2014/02/08 14:57:35 espie Exp $

COMMENT=	graphical frontend to CVS
DISTNAME=	tkcvs-6.0
REVISION =	5
CATEGORIES=	devel

MAINTAINER=	Todd T. Fries <todd@openbsd.org>

PERMIT_PACKAGE_CDROM=	Yes

MASTER_SITES=	http://www.neosoft.com/tcl/ftparchive/sorted/packages-7.6/apps/tkcvs-6.0/

MODULES=	x11/tk
RUN_DEPENDS=	${MODTK_RUN_DEPENDS}
BUILD_DEPENDS=	${RUN_DEPENDS}

USE_GROFF =	Yes
NO_BUILD=	Yes
NO_TEST=	Yes

pre-configure:
	@${MODTCL_TCLSH_ADJ} ${WRKSRC}/tkcvs/cvscheck.blank
	@${SUBST_CMD} ${WRKSRC}/tkcvs/doinstall

do-install:
	cd $(WRKSRC)/tkcvs; ./doinstall

.include <bsd.port.mk>
