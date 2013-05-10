# $OpenBSD: Makefile,v 1.1.1.1 2013/04/24 18:36:33 zhuk Exp $

COMMENT =	vocabulary trainer for KDE
DISTNAME =	parley-${MODKDE4_VERSION}

# XXX Sometimes crashes, possibly due KHotNewStuff bugs.

WANTLIB =  c m pthread stdc++
WANTLIB += ICE SM X11 Xext Xrender
WANTLIB += lib/qt4/QtDBus lib/qt4/QtGui lib/qt4/QtNetwork
WANTLIB += lib/qt4/QtScript lib/qt4/QtSvg lib/qt4/QtXml
WANTLIB += ${KDE4LIB}/kcmutils ${KDE4LIB}/kdeui ${KDE4LIB}/keduvocdocument
WANTLIB += ${KDE4LIB}/khtml ${KDE4LIB}/kio ${KDE4LIB}/kjs
WANTLIB += ${KDE4LIB}/knewstuff3 ${KDE4LIB}/kparts ${KDE4LIB}/krosscore
WANTLIB += ${KDE4LIB}/krossui ${KDE4LIB}/nepomuk ${KDE4LIB}/nepomukutils
WANTLIB += ${KDE4LIB}/plasma
WANTLIB += soprano xml2 xslt

MODULES =	multimedia/phonon

LIB_DEPENDS = 	textproc/libxml \
		textproc/libxslt \
		${MODKDE4_DEP_DIR}/libkdeedu>=${MODKDE4_DEP_VERSION}

RUN_DEPENDS =	${MODKDE4_DEP_DIR}/kross-interpreters>=${MODKDE4_DEP_VERSION}

KROSS_SCRIPTS = plugins/test.py \
		plugins/leo-dict.py \
		plugins/example.py \
		plugins/google_images.py \
		plugins/wiktionary/wiktionary_sound.py \
		plugins/google_dictionary.py

post-patch:
.for _f in ${KROSS_SCRIPTS}
	perl -pi -e '$$. == 1 and s@.*@#!${LOCALBASE}/bin/kross@' ${WRKSRC}/${_f}
.endfor

.include <bsd.port.mk>