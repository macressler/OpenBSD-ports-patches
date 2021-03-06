# $OpenBSD: Makefile,v 1.134 2014/05/08 17:51:57 zhuk Exp $

# XXX gcm-dmi.c:141:2: warning: #warning Please add dmi support for your OS

SHARED_ONLY=		Yes

COMMENT=		GNOME settings daemon

GNOME_PROJECT=		gnome-settings-daemon
GNOME_VERSION=		3.12.2
REVISION=		0

# GPLv3
PERMIT_PACKAGE_CDROM=	Yes

WANTLIB += FLAC ICE SM X11 X11-xcb Xcomposite Xcursor Xdamage
WANTLIB += Xext Xfixes Xi Xinerama Xrandr Xrender Xtst atk-1.0
WANTLIB += atk-bridge-2.0 atspi avahi-client avahi-common c cairo
WANTLIB += cairo-gobject canberra canberra-gtk3 colord colordprivate
WANTLIB += crypto cups dbus-1 execinfo expat ffi fontconfig freetype
WANTLIB += gdbm gdk-3 gdk_pixbuf-2.0 geocode-glib gio-2.0 glib-2.0
WANTLIB += gmodule-2.0 gnome-desktop-3 gobject-2.0 graphite2 gthread-2.0
WANTLIB += gtk-3 gweather-3 harfbuzz ibus-1.0 json-c json-glib-1.0
WANTLIB += lcms2 ltdl m notify nspr4 nss3 nssutil3 ogg pango-1.0
WANTLIB += pangocairo-1.0 pangoft2-1.0 pcre pixman-1 plc4 plds4
WANTLIB += png polkit-gobject-1 pthread pthread-stubs pulse pulse-mainloop-glib
WANTLIB += smime3 sndfile softokn3 soup-2.4 sqlite3 ssl ssl3 upower-glib
WANTLIB += vorbis vorbisenc vorbisfile xcb xcb-render xcb-shm
WANTLIB += xkbfile xml2 z

MODULES=		devel/dconf \
			devel/gettext \
			x11/gnome

LIB_DEPENDS=		audio/libcanberra,-gtk3 \
			audio/pulseaudio \
			devel/libnotify \
			inputmethods/ibus \
			geo/geocode-glib \
			graphics/colord \
			print/cups,-libs \
			security/nss \
			sysutils/upower \
			x11/gnome/desktop \
			x11/gnome/libgweather

BUILD_DEPENDS=		devel/gsettings-desktop-schemas
RUN_DEPENDS=		devel/gsettings-desktop-schemas

# share/polkit-1/actions/org.gnome.settings-daemon.plugins.power.policy
RUN_DEPENDS +=		sysutils/polkit

# polkit(8) almost always needs to know the "active" session
RUN_DEPENDS +=		sysutils/consolekit

# plugins/mouse/gsd-mouse-manager.c
RUN_DEPENDS +=		x11/gnome/mousetweaks

# plugins/datetime/geoclue.c
BUILD_DEPENDS +=	geo/geoclue2
RUN_DEPENDS +=		geo/geoclue2

# plugins/power/gsd-power-manager.c; optional dependency
# cyclic dep: gnome-session -> gnome-settings-daemon -> gnome-session
#RUN_DEPENDS +=		x11/gnome/session

MODGNOME_TOOLS += desktop-file-utils docbook gtk-update-icon-cache

MODGNOME_CPPFLAGS=	-I${X11BASE}/include
MODGNOME_LDFLAGS=	-L${X11BASE}/lib

CONFIGURE_ARGS= 	--disable-gudev \
			--disable-rfkill

FAKE_FLAGS=		desktopdir=${PREFIX}/share/examples/gnome-settings-daemon/xdg/autostart \
			sysconfdir=${PREFIX}/share/examples/gnome-settings-daemon \
			DBUS_SYS_DIR=${PREFIX}/share/examples/gnome-settings-daemon/dbus-1/system.d

pre-configure:
	perl -pi -e 's,/etc/xdg,${SYSCONFDIR}/xdg,g;' \
		-e 's,/usr/share,${LOCALBASE}/share,g' \
		${WRKSRC}/man/gnome-settings-daemon.xml

post-install:
	${INSTALL_DATA} ${FILESDIR}/*.gschema.override \
		${PREFIX}/share/glib-2.0/schemas
	rm ${PREFIX}/lib/gnome-settings-daemon-3.0/*.{a,la}

.include <bsd.port.mk>
