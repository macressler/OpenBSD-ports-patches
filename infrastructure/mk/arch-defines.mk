# $OpenBSD: arch-defines.mk,v 1.13 2013/02/10 20:27:42 miod Exp $
#
# ex:ts=4 sw=4 filetype=make:
#
#	derived from bsd.port.mk in 2011
#	This file is in the public domain.
#	It is actually a part of bsd.port.mk that won't be included manually.
#

# architecture constants

ARCH ?!= uname -m

ALL_ARCHS = alpha amd64 arm armish aviion hp300 hppa hppa64 i386 landisk \
	loongson luna88k m68k m88k macppc mips64 mips64el \
	mvme68k mvme88k palm sgi socppc sparc sparc64 vax zaurus
# not all powerpc have apm(4), hence the use of macppc
APM_ARCHS = amd64 arm i386 loongson macppc sparc sparc64 zaurus
BE_ARCHS = hppa hppa64 m68k m88k mips64 powerpc sparc sparc64
LE_ARCHS = alpha amd64 arm i386 mips64el sh vax
LP64_ARCHS = alpha amd64 hppa64 sparc64 mips64 mips64el
NO_SHARED_ARCHS = vax
GCC4_ARCHS = alpha amd64 arm armish beagle gumstix i386 hppa hppa64 \
	landisk loongson macppc mips64 \
	mips64el mvmeppc palm powerpc sgi sh socppc sparc sparc64 zaurus
GCC3_ARCHS = aviion hp300 luna88k m68k m88k mvme68k mvme88k
GCC2_ARCHS = vax
# XXX easier for ports that depend on mono
MONO_ARCHS = amd64 i386
LLVM_ARCHS = amd64 i386 powerpc mips64 mips64el sparc sparc64
OCAML_NATIVE_ARCHS = i386 sparc amd64 powerpc
OCAML_NATIVE_DYNLINK_ARCHS = i386 amd64


.for PROP in ALL APM BE LE LP64 NO_SHARED GCC4 GCC3 GCC2 MONO LLVM \
                               OCAML_NATIVE OCAML_NATIVE_DYNLINK
.  for A B in ${MACHINE_ARCH} ${ARCH}
.    if !empty(${PROP}_ARCHS:M$A) || !empty(${PROP}_ARCHS:M$B)
PROPERTIES += ${PROP:L}
.    endif
.  endfor
.endfor
.if ${ELF_TOOLCHAIN:L} == "yes"
PROPERTIES += elf
.endif
