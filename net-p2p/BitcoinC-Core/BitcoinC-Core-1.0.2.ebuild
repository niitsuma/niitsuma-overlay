# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools bash-completion-r1 db-use user


DESCRIPTION="Bitcoin Confidential wallet"
HOMEPAGE="https://github.com/Bitcoin-Confidential/BitcoinC-Core/"
SRC_URI="https://github.com/Bitcoin-Confidential/BitcoinC-Core/archive/v${PV}.tar.gz -> ${PN}-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux ~arm ~arm64 ~mips ~ppc ~x86 ~x86-linux"

# DEPEND=""
# RDEPEND="${DEPEND}"


IUSE="+asm +bip70 dbus +libevent knots libressl +qrcode -test -bench upnp +wallet zeromq"

RDEPEND="
	>=dev-libs/boost-1.52.0:=[threads(+)]
	>=dev-libs/libsecp256k1-0.0.0_pre20151118:=[recovery]
	dev-libs/univalue:=
	dev-qt/qtcore
	dev-qt/qtgui
	dev-qt/qtnetwork
	dev-qt/qtwidgets
	virtual/bitcoin-leveldb
	bip70? ( dev-libs/protobuf:= )
	dbus? (
		dev-qt/qtdbus
	)
	libevent? ( dev-libs/libevent:= )
	!libressl? ( dev-libs/openssl:0=[-bindist] )
	libressl? ( dev-libs/libressl:0= )
	qrcode? (
		media-gfx/qrencode:=
	)
	upnp? ( >=net-libs/miniupnpc-1.9.20150916:= )
	wallet? ( sys-libs/db:$(db_ver_to_slot "${DB_VER}")=[cxx] )
	zeromq? ( net-libs/zeromq:= )
"

DEPEND="${RDEPEND}
	dev-qt/linguist-tools
	knots? (
		gnome-base/librsvg
		media-gfx/imagemagick[png]
	)
"


#S="${WORKDIR}/${BASEPNAME}-${PV}"
src_configure() {
    ./autogen.sh || die "autogen failed" 
    econf
}
src_install() {
    dobin src/bitcoincd
    dobin src/bitcoinc-cli
    dobin src/bitcoinc-tx
    dobin src/qt/bitcoinc-qt
}

