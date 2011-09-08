# $OpenBSD: Makefile,v 1.3 2011/06/22 08:19:12 ajacoutot Exp $

COMMENT=		server of the Tryton application platform

DISTNAME=		trytond-${MODPY_EGG_VERSION}
REVISION=		0

CATEGORIES=		www

RUN_DEPENDS=		textproc/py-lxml \
			devel/py-dateutil \
			devel/py-simplejson \
			databases/py-psycopg2 \
			devel/py-tz \
			print/py-relatorio \
			security/py-openssl \
			www/py-webdav

pre-configure:
	perl -pi -e 's,/var/lib,/var/db,,' ${WRKSRC}/trytond/config.py

post-install:
	${INSTALL_DATA_DIR} ${PREFIX}/share/examples/trytond
	${INSTALL_DATA} ${WRKSRC}/etc/trytond.conf \
		${PREFIX}/share/examples/trytond/trytond.conf

.include <bsd.port.mk>