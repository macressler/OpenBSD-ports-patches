# $OpenBSD: Makefile,v 1.5 2011/01/06 20:15:22 jeremy Exp $

COMMENT=		DataObjects driver for PostgreSQL

DISTNAME=		do_postgres-0.10.2
REVISION=		2
CATEGORIES=		databases

# MIT
PERMIT_PACKAGE_CDROM=	Yes
PERMIT_PACKAGE_FTP=	Yes
PERMIT_DISTFILES_CDROM=	Yes
PERMIT_DISTFILES_FTP=	Yes

MODULES=		lang/ruby

CONFIGURE_STYLE=	ruby gem ext

# databases/postgresql,-server needed for include files
BUILD_DEPENDS=		${RUN_DEPENDS} \
			databases/postgresql,-server
RUN_DEPENDS=		databases/ruby-data_objects,${MODRUBY_FLAVOR}

WANTLIB=		pq
LIB_DEPENDS=		databases/postgresql,-main

# Requires running PostgreSQL database
REGRESS_IS_INTERACTIVE = Yes
REGRESS_DEPENDS =	${FULLPKGNAME}:${BUILD_PKGPATH} \
			devel/ruby-bacon,${MODRUBY_FLAVOR}
do-regress:
	cd ${WRKSRC} && bacon${GEM_BIN_SUFFIX} spec/*_spec.rb

.include <bsd.port.mk>