# $OpenBSD: Makefile,v 1.13 2013/03/11 11:35:55 espie Exp $

COMMENT=	Internet Relay Chat (IRC) protocol client library for Python

DISTNAME=	python-irclib-0.4.6
PKGNAME=	${DISTNAME:S/python/py/g}
REVISION =	4
CATEGORIES=	net

HOMEPAGE=	http://python-irclib.sourceforge.net/

# LGPL
PERMIT_PACKAGE_CDROM=	Yes

MASTER_SITES=	${MASTER_SITE_SOURCEFORGE:=python-irclib/}

MODULES=	lang/python

NO_TEST=	Yes

EXAMPLES=	dccreceive dccsend irccat irccat2 servermap testbot.py
EXAMPLESDIR=	${PREFIX}/share/examples/py-irclib

post-install:
	${INSTALL_DATA_DIR} ${EXAMPLESDIR}
.for f in ${EXAMPLES}
	${INSTALL_DATA} ${WRKSRC}/${f} ${EXAMPLESDIR}
.endfor

.include <bsd.port.mk>
