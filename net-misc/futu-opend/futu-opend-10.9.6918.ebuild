# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

# moomoo / Futu OpenAPI のゲートウェイ。取引アプリ本体ではなく、
# moomoo-api (Python 等の SDK) と moomoo のサーバの間を中継する常駐
# プログラム。SDK は localhost:11111 でこれに繋ぐ。
#
# 上流の配布は Ubuntu 18.04 / CentOS 7 向けのビルド。glibc を静的に
# 抱えてはいないが、必要な .so は同梱されていて RUNPATH の先頭が
# $ORIGIN なので、置き場所を選ばない。
MY_P="Futu_OpenD_${PV}_Ubuntu18.04"
# 書庫の中は CLI と GUI で並びが違う:
#   Futu_OpenD_<版>_Ubuntu18.04/Futu_OpenD_<版>_Ubuntu18.04       (CLI)
#   Futu_OpenD_<版>_Ubuntu18.04/Futu_OpenD-GUI_<版>_Ubuntu18.04   (GUI)
# GUI は "OpenD-GUI_<版>" であって "OpenD_<版>-GUI" ではない。
MY_P_GUI="Futu_OpenD-GUI_${PV}_Ubuntu18.04"

DESCRIPTION="moomoo/Futu OpenD - OpenAPI gateway daemon for moomoo securities"
HOMEPAGE="https://openapi.moomoo.com/moomoo-api-doc/en/"
# www.futunn.com/download/fetch-lasted-link?name=opend-ubuntu が最新版へ
# 転送する。転送先は版番号入りの安定 URL なのでそちらを直接使う。
SRC_URI="https://softwaredownload.futunn.com/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}/${MY_P}"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64"

# プロプライエタリ。再配布不可。ビルド済みなので strip しない。
RESTRICT="bindist mirror strip"

IUSE="+cli gui"
REQUIRED_USE="|| ( cli gui )"

RDEPEND="
	sys-libs/glibc
	sys-libs/zlib
	gui? (
		media-libs/fontconfig
		x11-libs/libX11
		x11-libs/libxcb
	)
"

QA_PREBUILT="opt/${PN}/*"

src_unpack() {
	default
	# 書庫の中は <名前>/<名前>/ と <名前>/<名前>-GUI/ の二重構造。
	# S は CLI 版を指してある。
}

src_install() {
	local dir="/opt/${PN}"

	if use cli; then
		insinto "${dir}"
		doins -r "${WORKDIR}/${MY_P}/${MY_P}"/*
		fperms 0755 "${dir}/FutuOpenD"
		# 同梱ライブラリと補助実行ファイルにも実行権を戻す。
		# doins は 0644 で入れてしまうため。
		local f
		for f in FTUpdate FTWebSocket F3CChart; do
			[[ -e ${ED}${dir}/${f} ]] && fperms 0755 "${dir}/${f}"
		done
		dosym "${dir}/FutuOpenD" /usr/bin/futu-opend
	fi

	if use gui; then
		# GUI 版の中身は単体の AppImage。CLI 版のような
		# ディレクトリ一式ではない。
		local gdir="/opt/${PN}"
		insinto "${gdir}"
		doins "${WORKDIR}/${MY_P}/${MY_P_GUI}/${MY_P_GUI}.AppImage"
		fperms 0755 "${gdir}/${MY_P_GUI}.AppImage"
		dosym "${gdir}/${MY_P_GUI}.AppImage" /usr/bin/futu-opend-gui
	fi

	# 設定は書き換える前提のものなので、/opt に置いた原本には触らせず
	# ユーザが自分のコピーを -cfg_file で指すのが安全。その旨は
	# pkg_postinst で案内する。
	dodoc "${WORKDIR}/${MY_P}/README.txt"
}

pkg_postinst() {
	elog "OpenD は取引アプリ本体ではなく、moomoo-api (SDK) と moomoo の"
	elog "サーバを中継する常駐プログラム。SDK は既定で localhost:11111 に繋ぐ。"
	elog ""
	elog "起動:"
	elog "    futu-opend -login_account=<口座> -login_pwd=<パスワード> -lang=jp"
	elog ""
	elog "設定ファイルの原本は /opt/${PN}/FutuOpenD.xml にあるが、"
	elog "/opt 配下は Portage が管理するので直接書き換えないこと。複製して"
	elog "    futu-opend -cfg_file=~/.config/futu-opend/FutuOpenD.xml"
	elog "のように指定する。"
	elog ""
	elog "既定ポート: API 11111 / telnet 22222 / websocket 33333"
	elog ""
	elog "Python から使うには SDK が別途必要:"
	elog "    pip install --user moomoo-api"
	elog ""
	elog "⚠ 起動パラメータにパスワードを平文で渡すと ps や履歴に残る。"
	elog "  login_pwd_md5 (32桁の MD5) を使うか、設定ファイルに書くこと。"
}
