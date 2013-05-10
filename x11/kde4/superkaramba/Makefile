# $OpenBSD: Makefile,v 1.1.1.1 2013/04/24 19:06:51 zhuk Exp $

COMMENT =	interactive desktop widgets for KDE
DISTNAME =	superkaramba-${MODKDE4_VERSION}

SHARED_LIBS =	superkaramba	0.0 # 4.7

WANTLIB =  c m pthread stdc++ util 
WANTLIB += ICE SM X11 Xext Xrender
WANTLIB += lib/qt4/QtDBus lib/qt4/QtGui lib/qt4/QtNetwork lib/qt4/QtScript
WANTLIB += lib/qt4/Qt3Support lib/qt4/QtSvg lib/qt4/QtXml
WANTLIB += ${KDE4LIB}/kde3support ${KDE4LIB}/kdeui ${KDE4LIB}/kio
WANTLIB += ${KDE4LIB}/knewstuff2 ${KDE4LIB}/kpty ${KDE4LIB}/krosscore
WANTLIB += ${KDE4LIB}/plasma
WANTLIB += qimageblitz ${MODPY_WANTLIB}

MODULES =	lang/python

RUN_DEPENDS =	devel/desktop-file-utils \
		x11/gtk+2,-guic

LIB_DEPENDS =	graphics/qimageblitz

.include <bsd.port.mk>