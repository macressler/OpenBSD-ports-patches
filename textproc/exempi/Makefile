# $OpenBSD: Makefile,v 1.9 2013/07/04 09:07:23 ajacoutot Exp $

COMMENT =		implementation of XMP
DISTNAME =		exempi-2.2.1

CATEGORIES =		textproc

SHARED_LIBS +=  exempi               1.1      # 5.3

HOMEPAGE =		http://libopenraw.freedesktop.org/wiki/Exempi

# BSD
PERMIT_PACKAGE_CDROM =	Yes

WANTLIB += c expat m pthread stdc++ z

# configure checks for libiconv but it's unused
BUILD_DEPENDS =		converters/libiconv

MASTER_SITES =		http://libopenraw.freedesktop.org/download/

CONFIGURE_STYLE =	gnu
CONFIGURE_ARGS +=	${CONFIGURE_SHARED} \
			--enable-unittest=no
CONFIGURE_ENV =		CPPFLAGS="-I${LOCALBASE}/include" \
			LDFLAGS="-L${LOCALBASE}/lib -pthread"

# XXX remove when we have thread local storage
CONFIGURE_ENV +=	ac_cv_tls=none

.include <bsd.port.mk>
