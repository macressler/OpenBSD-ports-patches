# $OpenBSD: Makefile,v 1.4 2014/07/09 20:03:24 zhuk Exp $

COMMENT =	KDE screenreader and focus tracking
DISTNAME =	kaccessible-${MODKDE4_VERSION}

WANTLIB =  c m pthread
WANTLIB += ICE SM X11 Xext
WANTLIB += lib/qt4/QtDBus lib/qt4/QtGui lib/qt4/QtSvg
WANTLIB += ${KDE4LIB}/kdeui
WANTLIB += speechd

LIB_DEPENDS =	audio/speech-dispatcher

.include <bsd.port.mk>
