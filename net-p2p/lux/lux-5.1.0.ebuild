# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools bash-completion-r1 db-use user

#BASEPNAME="vivo"

DESCRIPTION="lux coin crypto-currency wallet"
HOMEPAGE="https://github.com/216k155/lux/"
SRC_URI="https://github.com/216k155/lux/archive/v${PV}.tar.gz -> ${PN}-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux ~arm ~arm64 ~mips ~ppc ~x86 ~x86-linux"
DEPEND=""
RDEPEND="${DEPEND}"
#S="${WORKDIR}/${BASEPNAME}-${PV}"
src_configure() {
    ./autogen.sh || die "autogen failed" 
    econf
}
src_install() {
    dobin src/${PN}d
    dobin src/${PN}-cli
    dobin src/${PN}-tx
    dobin src/qt/${PN}-qt
}

