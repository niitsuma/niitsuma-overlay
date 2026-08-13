# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd udev

# USB 接続の IPP 対応プリンタ/複合機を、ローカルの IPP サーバとして
# 見せるデーモン。これがあると:
#   * 印刷は IPP Everywhere でドライバ不要 (URF を正しくネゴシエートする)
#   * スキャンも eSCL でドライバ不要 (sane-airscan から見える)
#
# なぜ必要だったか (2026-08-13, Brother MFC-J6583CDW):
#   CUPS の usb:// バックエンド + 汎用 pwgrast PPD では、データは USB へ
#   届くのに1枚も印刷されなかった。この機種の usb_CMD は HBP,PJL,URF で、
#   要求しているのは URF (AirPrint ラスタ) だが、汎用 PPD が送るのは
#   PWG Raster で別形式のため。ipp-usb を挟むと本来の IPP 交渉が働く。

DESCRIPTION="Daemon that exposes USB IPP printers/MFPs as local IPP/eSCL services"
HOMEPAGE="https://github.com/OpenPrinting/ipp-usb"

EGO_SUM=(
	"github.com/OpenPrinting/goipp v1.2.0"
	"github.com/OpenPrinting/goipp v1.2.0/go.mod"
)
go-module_set_globals

SRC_URI="https://github.com/OpenPrinting/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
	${EGO_SUM_SRC_URI}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	dev-libs/libusb:1
	net-dns/avahi
"
RDEPEND="${DEPEND}"

src_compile() {
	ego build -o "${PN}" .
}

src_install() {
	# 上流の Makefile は /usr/sbin へ入れる。IPP 用の状態は /var/ipp-usb。
	dosbin "${PN}"

	insinto /etc/ipp-usb
	doins ipp-usb.conf

	# service も udev ルールも systemd-udev/ 配下にある (systemd/ ではない)
	systemd_dounit systemd-udev/ipp-usb.service
	udev_dorules systemd-udev/71-ipp-usb.rules

	# 機種ごとの既知の癖を吸収する定義集。これが無いと動かない機種がある。
	insinto /usr/share/ipp-usb/quirks
	doins ipp-usb-quirks/*.conf

	keepdir /var/ipp-usb
	dodoc README.md
}

pkg_postinst() {
	udev_reload
	elog "有効化:"
	elog "    systemctl enable --now ipp-usb"
	elog ""
	elog "USB 機器を挿すと udev 経由で起動し、ローチカルの IPP として現れる。"
	elog "CUPS からは次のように登録する (ドライバ不要):"
	elog "    lpadmin -p <名前> -E -v ipp://localhost:60000/ipp/print -m everywhere"
	elog ""
	elog "スキャナは media-gfx/sane-airscan があれば自動で見える:"
	elog "    scanimage -L"
	elog ""
	elog "avahi-daemon が動いている必要がある。"
}
