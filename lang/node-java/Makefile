# $OpenBSD: Makefile,v 1.2 2013/12/17 10:17:28 jasper Exp $

COMMENT =	bridge API connect to Java for Node.js

NPM_VERSION =	0.2.9
NPM_NAME =	java
REVISION =	0
CATEGORIES =	lang

MAINTAINER =	Roman Kravchuk <kravchuk.kp@gmail.com>

HOMEPAGE =	https://github.com/nearinfinity/node-java/

# MIT
PERMIT_PACKAGE_CDROM = Yes

MODULES =	lang/node \
		java

MODJAVA_VER ?=	1.7+

MODNODE_DEPENDS = node-gyp

CONFIGURE_STYLE = npm ext

NO_TEST =	Yes

pre-configure:
	@perl -pi -e 's,<!\(echo \$$JAVA_HOME\),${JAVA_HOME},' ${WRKSRC}/binding.gyp
	@rm -rf ${WRKSRC}/projectFilesBackup*

.include <bsd.port.mk>
