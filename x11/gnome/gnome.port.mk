# $OpenBSD: gnome.port.mk,v 1.60 2012/03/29 16:34:43 ajacoutot Exp $
#
# Module for GNOME related ports

.if (defined(GNOME_PROJECT) && defined(GNOME_VERSION))
DISTNAME=		${GNOME_PROJECT}-${GNOME_VERSION}
VERSION=		${GNOME_VERSION}
MASTER_SITES?=		${MASTER_SITE_GNOME:=sources/${GNOME_PROJECT}/${GNOME_VERSION:C/^([0-9]+\.[0-9]+).*/\1/}/}
EXTRACT_SUFX?=		.tar.xz
CATEGORIES+=		x11/gnome
.endif

.if ${NO_BUILD:L} == "no"
USE_LIBTOOL?=		Yes
MODULES+=		textproc/intltool
.   if defined(CONFIGURE_STYLE) && ${CONFIGURE_STYLE:Mgnu}
        CONFIGURE_ARGS += ${CONFIGURE_SHARED}
        # If a port needs extra CPPFLAGS, they can just set MODGNOME_CPPFLAGS
        # to the desired value, like -I${X11BASE}/include
        _MODGNOME_cppflags ?= CPPFLAGS="-I${LOCALBASE}/include ${MODGNOME_CPPFLAGS}"
        _MODGNOME_ldflags ?= LDFLAGS="-L${LOCALBASE}/lib ${MODGNOME_LDFLAGS}"
        CONFIGURE_ENV += ${_MODGNOME_cppflags} \
                         ${_MODGNOME_ldflags}
        # Older versions of glib-gettext.m4 used to set DATADIRNAME to
        # "lib" which resulted in locale files being installed under the
        # wrong directory.
        CONFIGURE_ENV += DATADIRNAME=share
        # If one of these tools is found at configure stage, it might be used, no
        # matter whether we use --disable-gtk-doc or not.
.       if !defined(MODGNOME_TOOLS) || defined(MODGNOME_TOOLS) && ! ${MODGNOME_TOOLS:Mgtk-doc}
            CONFIGURE_ENV += ac_cv_path_GTKDOC_CHECK="" \
                             ac_cv_path_GTKDOC_REBASE="" \
                             ac_cv_path_GTKDOC_MKPDF=""
.       endif
.   endif
.endif

# Set to 'yes' if there are .desktop files under share/applications/.
.if defined(MODGNOME_DESKTOP_FILE) && ${MODGNOME_DESKTOP_FILE:L} == "yes"
MODGNOME_RUN_DEPENDS+=	devel/desktop-file-utils
.endif

# Set to 'yes' if there are icon files under share/icons/.
.if defined(MODGNOME_ICON_CACHE) && ${MODGNOME_ICON_CACHE:L} == "yes"
MODGNOME_RUN_DEPENDS+=	x11/gtk+2,-guic
.endif

USE_GMAKE?=		Yes

# Use MODGNOME_TOOLS to indicate certain tools are needed for building bindings
# or for ensuring documentation is available. If an option is not set, it's
# explicitly disabled.
# Currently supported tools are:
# * goi:  Build and enable GObject Introspection data.
# * gtk-doc: Enable to build the included docs.
# * vala: Enable vala bindings.
# * yelp: Use this if there are any files under share/gnome/help/
#         or "page" files under share/help/ in the PLIST that are opened
#         with yelp -- gnome-doc-utils is here to make sure we have a
#         dependency on rarian (and legacy scrollkeeper-*) and have
#         access to the gnome-doc-* tools (not always needed but easier);
#         same goes with itstool.
# Please note that if you're using multi-packages, you have to use the
# MODGNOME_RUN_DEPENDS_${tool} in your multi package RUN_DEPENDS.

MODGNOME_CONFIGURE_ARGS_gtkdoc=--disable-gtk-doc
MODGNOME_CONFIGURE_ARGS_goi=--disable-introspection
MODGNOME_CONFIGURE_ARGS_vala=--disable-vala --disable-vala-bindings

.if defined(MODGNOME_TOOLS)
.   if ${MODGNOME_TOOLS:Mgoi}
        MODGNOME_CONFIGURE_ARGS_goi=--enable-introspection
        MODGNOME_BUILD_DEPENDS+=devel/gobject-introspection>=1.32.0
.   endif

.   if ${MODGNOME_TOOLS:Mgtk-doc}
        MODGNOME_CONFIGURE_ARGS_gtkdoc=--enable-gtk-doc
        MODGNOME_BUILD_DEPENDS+=textproc/gtk-doc
.   endif

.   if ${MODGNOME_TOOLS:Mvala}
        MODGNOME_CONFIGURE_ARGS_vala=--enable-vala --enable-vala-bindings
        MODGNOME_BUILD_DEPENDS+=lang/vala>=0.16.0
.   endif

.   if ${MODGNOME_TOOLS:Myelp}
        MODGNOME_BUILD_DEPENDS+=textproc/itstool
        MODGNOME_BUILD_DEPENDS+=x11/gnome/doc-utils>=0.20.10
        _yelp_depend=x11/gnome/yelp
        MODGNOME_RUN_DEPENDS+=${_yelp_depend}
        MODGNOME_RUN_DEPENDS_yelp=${_yelp_depend}
.   endif
.endif

CONFIGURE_ARGS+=${MODGNOME_CONFIGURE_ARGS_goi} \
		${MODGNOME_CONFIGURE_ARGS_gtkdoc} \
		${MODGNOME_CONFIGURE_ARGS_vala}

.if defined(MODGNOME_BUILD_DEPENDS)
BUILD_DEPENDS+=		${MODGNOME_BUILD_DEPENDS}
.endif

.if defined(MODGNOME_RUN_DEPENDS)
RUN_DEPENDS+=		${MODGNOME_RUN_DEPENDS}
.endif
