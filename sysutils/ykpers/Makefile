# $OpenBSD: Makefile,v 1.12 2014/03/12 11:22:03 sthen Exp $

COMMENT=	library and tools to program YubiKeys

DISTNAME=	ykpers-1.15.1

SHARED_LIBS +=	ykpers-1                  0.3 # 16.1

CATEGORIES=	sysutils security

HOMEPAGE=	http://yubico.github.io/yubikey-personalization/

MAINTAINER=	Stuart Henderson <sthen@openbsd.org>

# BSD
PERMIT_PACKAGE_CDROM=	Yes

WANTLIB += c json-c pthread usb-1.0 yubikey

MASTER_SITES=	http://yubico.github.io/yubikey-personalization/releases/

LIB_DEPENDS=	devel/json-c \
		devel/libusb1>=1.0.9p1 \
		devel/libyubikey \

SEPARATE_BUILD=	Yes
CONFIGURE_STYLE= gnu
CONFIGURE_ARGS=	${CONFIGURE_SHARED}

.include <bsd.port.mk>
