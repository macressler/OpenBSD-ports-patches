# $OpenBSD: Makefile,v 1.5 2014/07/09 20:03:25 zhuk Exp $

COMMENT =	geography learning tool for KDE
DISTNAME =	kgeography-${MODKDE4_VERSION}

WANTLIB =  c m pthread
WANTLIB += lib/qt4/QtDBus lib/qt4/QtGui lib/qt4/QtSvg lib/qt4/QtXml
WANTLIB += ${KDE4LIB}/kdeui

RUN_DEPENDS =	devel/desktop-file-utils \
		x11/gtk+2,-guic

.include <bsd.port.mk>
