# $OpenBSD: Makefile,v 1.5 2014/05/11 19:48:19 juanfra Exp $

COMMENT=		GUI for managing virtual machines through libvirt

DISTNAME=		virt-manager-1.0.1
CATEGORIES=		sysutils x11
REVISION=		1

HOMEPAGE=		http://virt-manager.org/

MAINTAINER=		Jasper Lievisse Adriaanse <jasper@openbsd.org>

# GPLv2+
PERMIT_PACKAGE_CDROM=	Yes

MASTER_SITES=		${HOMEPAGE}/download/sources/virt-manager/

MODULES=		devel/dconf \
			lang/python \
			textproc/intltool

RUN_DEPENDS=		devel/libvirt-glib \
			devel/py-gobject3 \
			devel/vte3 \
			net/py-ipaddr \
			sysutils/libvirt-python \
			textproc/libxml,-python \
			www/py-urlgrabber \
			x11/spice-gtk

# pygobject GTK3 introspection (not provided by indirect dependencies)
RUN_DEPENDS +=		x11/gtk+3

NO_BUILD=		Yes

RUN_DEPENDS +=		devel/desktop-file-utils \
			x11/gtk+2,-guic

MODPY_ADJ_FILES=	virt-clone virt-convert virt-image virt-install \
			virt-manager virt-xml

pre-configure:
	${SUBST_CMD} ${WRKSRC}/virtcli/cliconfig.py

do-test:
	@${MODPY_TEST_TARGET}

.include <bsd.port.mk>
