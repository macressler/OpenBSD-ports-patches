# $OpenBSD: Makefile,v 1.6 2014/07/10 19:55:27 zhuk Exp $

COMMENT =	KDE interactive physics simulator
DISTNAME =	step-${MODKDE4_VERSION}
REVISION =	0

WANTLIB =  c m pthread
WANTLIB += lib/qt4/QtDBus lib/qt4/QtGui lib/qt4/QtNetwork
WANTLIB += lib/qt4/QtOpenGL lib/qt4/QtSvg lib/qt4/QtXml
WANTLIB += ${KDE4LIB}/kdeui ${KDE4LIB}/khtml ${KDE4LIB}/kio ${KDE4LIB}/kjs
WANTLIB += ${KDE4LIB}/knewstuff3 ${KDE4LIB}/kparts ${KDE4LIB}/nepomuk
WANTLIB += ${KDE4LIB}/nepomukutils
WANTLIB += cln glib-2.0 gsl gslcblas qalculate soprano xml2

MODULES =	devel/gettext multimedia/phonon

BUILD_DEPENDS =	math/eigen2

RUN_DEPENDS =	devel/desktop-file-utils \
		x11/gtk+2,-guic

LIB_DEPENDS = 	devel/gsl \
		math/libqalculate

CONFIGURE_ARGS =	-DSTEPCORE_TESTS:Bool=True

.include <bsd.port.mk>
