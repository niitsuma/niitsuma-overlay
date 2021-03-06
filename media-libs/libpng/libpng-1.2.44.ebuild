# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libpng/libpng-1.2.44.ebuild,v 1.6 2010/07/19 01:06:05 josejx Exp $

# this ebuild is only for the libpng12.so.0 SONAME for ABI compat

EAPI=3
inherit multilib libtool

DESCRIPTION="Portable Network Graphics library"
HOMEPAGE="http://www.libpng.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.xz"

LICENSE="as-is"
SLOT="1.2"
KEYWORDS="~alpha amd64 ~arm hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh ~sparc x86 ~sparc-fbsd ~x86-fbsd"
IUSE=""

RDEPEND="sys-libs/zlib
	!=media-libs/libpng-1.2*:0"
DEPEND="${RDEPEND}
	app-arch/xz-utils"

pkg_setup() {
	if [[ -e ${ROOT}/usr/$(get_libdir)/libpng12$(get_libname 0) ]]; then
		rm -f "${ROOT}"/usr/$(get_libdir)/libpng12$(get_libname 0)
	fi
}

src_prepare() {
	elibtoolize
}

src_configure() {
	econf \
		--disable-dependency-tracking \
		--disable-static
}

src_install() {
	exeinto /usr/$(get_libdir)
	doexe .libs/libpng12$(get_libname 0) || die
}
