# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/cabocha/Attic/cabocha-0.66.ebuild,v 0.1 2013/11/20 12:24:15 tove dead $

inherit autotools eutils multilib

MY_P="${P/_}"
DESCRIPTION="Yet Another Japanese Dependency Structure Analyzer"
HOMEPAGE="http://code.google.com/p/cabocha/"
SRC_URI="http://cabocha.googlecode.com/files/${MY_P}.tar.bz2"

# SRC_URI="http://cabocha.googlecode.com/files/cabocha-0.66.tar.bz2"
# mirror://sourceforge/cabocha/${MY_P}.tar.bz2

LICENSE="|| ( LGPL-2.1 BSD )"
SLOT="0"
KEYWORDS="~amd64 ~x86"

#IUSE="java perl python ruby unicode"
IUSE="unicode"

DEPEND="app-text/crf++
	app-text/mecab"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i -e "/^modeldir/s|lib|$(get_libdir)|" model/Makefile.am || die
	eautoreconf
}

src_compile() {
	local myconf
	use unicode && myconf="${myconf} --with-charset=UTF8"

	econf ${myconf} || die
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die

	dodoc AUTHORS ChangeLog README TODO
}

