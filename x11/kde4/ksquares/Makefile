# $OpenBSD: Makefile,v 1.4 2014/07/09 20:03:27 zhuk Exp $

COMMENT =	Dots-and-Boxes-like game for KDE
DISTNAME =	ksquares-${MODKDE4_VERSION}

WANTLIB =  c m pthread
WANTLIB += lib/qt4/QtDBus lib/qt4/QtGui lib/qt4/QtSvg
WANTLIB += ${KDE4LIB}/kdeui

MODKDE4_USE =	games

RUN_DEPENDS =	devel/desktop-file-utils \
		x11/gtk+2,-guic

.include <bsd.port.mk>
