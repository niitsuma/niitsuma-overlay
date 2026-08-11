# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop unpacker xdg

# 上流は Debian の .deb しか出していない。バージョン番号のあとに続く
# 数字はビルド番号で、リリースごとに変わる。公式サイトは HTML から
# リンクを取り出せない作りなので、AUR の webull-desktop が使っている
# 配布 URL を追う形にしている。
MY_BUILD="9100000072"
DESCRIPTION="Webull Desktop - stock/options/ETF trading terminal"
HOMEPAGE="https://www.webull.com/trading-platforms/desktop-app"
SRC_URI="https://u1sweb.webullfintech.com/us/Webull%20Desktop_${PV}_${MY_BUILD}_global_x64signed.deb
	-> ${P}.deb"
S="${WORKDIR}"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64"

# 再配布不可のプロプライエタリ。ミラーもしない。
# ビルド済みバイナリなので strip も debug 情報の分離もしない。
RESTRICT="bindist mirror strip"

# 同梱されていない共有ライブラリだけを挙げる。Qt5 一式や
# QtWebEngine は .deb の中に入っているので依存に書かない
# (システム側の Qt と混ざるほうが危険)。
RDEPEND="
	dev-libs/libthai
	net-misc/curl
	media-libs/fontconfig
	media-libs/freetype
	sys-libs/zlib
	x11-libs/libX11
	x11-libs/libxcb
"
BDEPEND="dev-util/patchelf"

INSTALL_DIR="/opt/${PN}"

QA_PREBUILT="opt/${PN}/*"

src_prepare() {
	default

	# 上流のバイナリは RUNPATH が /usr/local/WebullDesktop で固定されている。
	# Portage が /usr/local に入れるのは規約違反なので /opt へ移すが、
	# そのままだと同梱ライブラリを見つけられない。41 個の ELF を書き換える。
	local f n=0
	while IFS= read -r -d '' f; do
		# ELF かどうかを見てから触る。png や js を patchelf に渡さない。
		[[ $(head -c4 "${f}" 2>/dev/null) == $'\x7fELF' ]] || continue
		if patchelf --print-rpath "${f}" 2>/dev/null | grep -q '/usr/local/WebullDesktop'; then
			patchelf --set-rpath "${INSTALL_DIR}" "${f}" || die "patchelf failed on ${f}"
			n=$(( n + 1 ))
		fi
	done < <(find usr/local/WebullDesktop -type f -print0)
	einfo "RUNPATH を ${INSTALL_DIR} に書き換えた ELF: ${n} 個"
	[[ ${n} -gt 0 ]] || die "RUNPATH を書き換えた対象が 0 個。上流の構成が変わった可能性がある"
}

src_install() {
	dodir "${INSTALL_DIR}"
	cp -a usr/local/WebullDesktop/. "${ED}${INSTALL_DIR}/" || die

	# libcurl-gnutls.so.4 は Debian 固有の SONAME。Gentoo の net-misc/curl は
	# 同じ ABI を libcurl.so.4 として出しているので橋渡しする。
	# /usr/lib64 にではなくアプリのディレクトリに置くのは、他のソフトへ
	# 影響させないため。RUNPATH がここを見るので解決できる。
	dosym ../../usr/$(get_libdir)/libcurl.so.4 "${INSTALL_DIR}/libcurl-gnutls.so.4"

	fperms 0755 "${INSTALL_DIR}/WebullDesktop"
	fperms 0755 "${INSTALL_DIR}/QtWebEngineProcess"
	dosym "${INSTALL_DIR}/WebullDesktop" /usr/bin/webull-desktop

	# 上流の .desktop は Exec が /usr/local を指しており、行末に空白が付く。
	make_desktop_entry "${INSTALL_DIR}/WebullDesktop" "Webull Desktop" \
		"WebullDesktop" "Finance;Office;"

	local s
	for s in 16 32 48 64 128 256; do
		if [[ -f usr/share/icons/hicolor/${s}x${s}/apps/WebullDesktop.png ]]; then
			newicon -s "${s}" \
				"usr/share/icons/hicolor/${s}x${s}/apps/WebullDesktop.png" \
				WebullDesktop.png
		fi
	done
}

pkg_postinst() {
	xdg_pkg_postinst
	elog "設定は ~/.config/Webull Desktop/ と ~/.local/share/Webull Desktop/ に書かれる。"
	elog "アンインストールしても消えないので、必要なら手で消すこと。"
	elog ""
	elog "上流はバージョンごとにビルド番号 (現在 ${MY_BUILD}) が変わる。"
	elog "更新時は ebuild 内の MY_BUILD も直す必要がある。"
}
