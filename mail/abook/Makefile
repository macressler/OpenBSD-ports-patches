# $OpenBSD: Makefile,v 1.29 2013/03/11 11:23:50 espie Exp $

COMMENT=	addressbook program with mutt support

DISTNAME=	abook-0.5.6
REVISION=	1
CATEGORIES=	mail

HOMEPAGE=	http://abook.sourceforge.net/

# GPLv2
PERMIT_PACKAGE_CDROM=	Yes

WANTLIB += c ncursesw readline

MASTER_SITES=	${MASTER_SITE_SOURCEFORGE:=abook/}

MODULES=	devel/gettext

CONFIGURE_STYLE=gnu

EXAMPLESDIR=	${PREFIX}/share/examples/abook
WHITELIST=README abook2whitelist.sh mutt.whitelist whitelist.rc
USE_GROFF =	Yes

post-install:
	${INSTALL_DATA_DIR} ${EXAMPLESDIR}/whitelist
	${INSTALL_DATA} ${WRKSRC}/contrib/mail2abook.py ${EXAMPLESDIR}
	${INSTALL_DATA} ${WRKSRC}/contrib/vcard2abook.pl ${EXAMPLESDIR}
	cd ${WRKSRC}/contrib/whitelist && \
		${INSTALL_DATA} ${WHITELIST} ${EXAMPLESDIR}/whitelist
	${INSTALL_DATA} ${WRKSRC}/sample.abookrc ${EXAMPLESDIR}

.include <bsd.port.mk>
