# $OpenBSD: Makefile,v 1.15 2013/01/27 03:56:06 abieber Exp $

# XXX:
# - Needs __ARM_NR_cacheflush (or the like) to work on arm-based ports.
# - Needs bundled libcares as arpa/nameser.h does not include ns_t_a.

ONLY_FOR_ARCHS=	amd64 i386

COMMENT=	V8 JavaScript for clients and servers

NODE_VERSION=	v0.8.18

DISTNAME=	node-${NODE_VERSION}
PKGNAME=	${DISTNAME:S/v//g}

CATEGORIES=	lang devel

HOMEPAGE=	http://nodejs.org/

MAINTAINER=	Aaron Bieber <abieber@openbsd.org>

# MIT
PERMIT_PACKAGE_CDROM=	Yes
PERMIT_PACKAGE_FTP=	Yes
PERMIT_DISTFILES_CDROM=	Yes
PERMIT_DISTFILES_FTP=	Yes

MASTER_SITES=	${HOMEPAGE}dist/${NODE_VERSION}/

MODULES=	lang/python

VMEM_WARNING=	Yes

WANTLIB +=	c crypto execinfo kvm m pthread ssl stdc++ util v8 z

LIB_DEPENDS=	devel/libexecinfo \
		lang/libv8

USE_GMAKE=	Yes

BUILD_DEPENDS=	sysutils/flock

# node-gyp uses it at runtime
RUN_DEPENDS=	devel/gmake \
		sysutils/flock

MODPY_ADJ_FILES= tools/node-waf \
		tools/waf-light

REGRESS_TARGET= test
CONFIGURE_STYLE= simple
CONFIGURE_ARGS= --openssl-use-sys \
		--shared-zlib \
		--shared-v8

SUBST_VARS+=	CFLAGS
SUBST_VARS+= 	PREFIX
SUBST_VARS+= 	LOCALBASE
SUBST_VARS+= 	DISTFILES

MAKE_ENV+=	V=1 CXX=c++ CCFLAGS+="${CFLAGS}" CXXFLAGS="${CXXFLAGS}"

NO_CCACHE=	Yes

pre-configure:
	@# Bad practice, but prevents a whole stack of patches.
	ln -sf ${LOCALBASE}/bin/python${MODPY_VERSION} ${WRKDIR}/bin/python
	${SUBST_CMD} ${WRKDIST}/lib/module.js \
		${WRKDIST}/deps/npm/node_modules/node-gyp/lib/configure.js \
		${WRKDIST}/deps/npm/node_modules/node-gyp/lib/install.js \
		${WRKDIST}/common.gypi

post-install:
	${MODPY_BIN} ${MODPY_LIBDIR}/compileall.py \
		${PREFIX}/lib/node/wafadmin
	${INSTALL_DATA} ${FULLDISTDIR}/${DISTFILES} \
		${PREFIX}/lib/node/${DISTFILES}
	ln -s ${TRUEPREFIX}/lib/node_modules/npm/bin/node-gyp-bin/node-gyp \
		${PREFIX}/bin/node-gyp;
	cd ${PREFIX}/lib/node_modules/npm/node_modules && for x in *; do \
		mv $$x ../..; \
		ln -s ../../$$x $$x; \
	done


.include <bsd.port.mk>