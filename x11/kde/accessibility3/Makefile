# $OpenBSD: Makefile,v 1.54 2013/12/22 19:24:34 zhuk Exp $

COMMENT-main = 		X11 toolkit, accessibility aids
COMMENT-mono = 		one-colour KDE icon theme
CATEGORIES =		x11 x11/kde
VERSION =		3.5.10
DISTNAME =		kdeaccessibility-${VERSION}
PKGNAME-main =		${DISTNAME}
PKGNAME-mono =		mono-icon-theme-${VERSION}
PKG_ARCH-mono =		*
MODKDE_VERSION ?=	3.5.8
SHARED_LIBS +=	KTTSD_Lib            1.0      # .0.1
SHARED_LIBS +=	kttsd                2.0      # .1.0

MULTI_PACKAGES =	-main -mono

MODULES =	x11/kde devel/gettext

RUN_DEPENDS-mono =	x11/gtk+2,-guic
RUN_DEPENDS-main =	${RUN_DEPENDS} \
			devel/desktop-file-utils \
			x11/gtk+2,-guic

LIB_DEPENDS-main =	x11/kde/libs3 
LIB_DEPENDS-mono =

SEPARATE_BUILD =	flavored

REVISION-main =	17

WANTLIB =	GL FLAC ICE SM X11 Xcursor Xdamage Xext Xfixes Xft Xi
WANTLIB +=	Xinerama Xmu Xrandr Xrender Xt Xtst Xxf86vm art_lgpl_2
WANTLIB +=	artsflow artsflow_idl audiofile c drm expat fam fontconfig
WANTLIB +=	freetype glib-2.0 gmodule-2.0 gthread-2.0 idn jpeg
WANTLIB +=	kmedia2_idl lcms lib/kde3/DCOP lib/kde3/artskde
WANTLIB +=	lib/kde3/kabc lib/kde3/kdecore>=6 lib/kde3/kdefx
WANTLIB +=	lib/kde3/kdeprint lib/kde3/kdesu lib/kde3/kdeui lib/kde3/kio
WANTLIB +=	lib/kde3/kparts lib/kde3/kresources lib/kde3/kspell
WANTLIB +=	lib/kde3/ktexteditor lib/kde3/kutils lib/kde3/kwalletclient
WANTLIB +=	lib/kde3/vcard m mad mcop mng ogg pcre png pthread
WANTLIB +=	pthread-stubs qtmcop sndio soundserver_idl stdc++ util
WANTLIB +=	vorbis vorbisenc vorbisfile xcb z
WANTLIB-mono =

post-install:
	${INSTALL_DATA_DIR} ${PREFIX}/${MODKDE_HTML_SUBDIR}/en/common

.include <bsd.port.mk>
