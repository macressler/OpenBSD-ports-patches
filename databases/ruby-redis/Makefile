# $OpenBSD: Makefile,v 1.17 2014/07/11 21:58:14 dcoppa Exp $

COMMENT =	client library for the Redis key-value store

VERSION =	3.1.0
EPOCH =		0
DISTNAME =	redis-${VERSION}
CATEGORIES =	databases

HOMEPAGE =	http://redis-rb.keyvalue.org/

MAINTAINER =	David Coppa <dcoppa@openbsd.org>

# BSD
PERMIT_PACKAGE_CDROM =	Yes

MODULES =		lang/ruby

CONFIGURE_STYLE =	ruby gem

MODRUBY_TEST =		rake

MODRUBY_TEST_ENV +=	LC_CTYPE="en_US.UTF-8"

TEST_DEPENDS =		databases/redis

# Be sure to have a redis server running with the command:
# cd $(make show=WRKBUILD) && redis-server ./test/test.conf
TEST_IS_INTERACTIVE =	Yes

post-install:
	@find ${PREFIX}/${GEM_LIB}/ -name '.git*' -print0 | xargs -0 rm

.include <bsd.port.mk>
