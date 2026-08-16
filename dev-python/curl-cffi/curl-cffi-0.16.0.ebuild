# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit python-r1

# yfinance 等が要求する、ブラウザ偽装対応の curl バインディング。
# ソースビルドは patched libcurl (curl-impersonate) をビルド時に取得する
# 作りでサンドボックスと相性が悪い。上流の abi3 ホイール (cp310 以降共通、
# manylinux2014) を展開して入れる。ホイールには libcurl-impersonate が
# 同梱されており、システムの libcurl とは独立。
MY_WHL="curl_cffi-${PV}-cp310-abi3-manylinux2014_x86_64.manylinux_2_17_x86_64.whl"

DESCRIPTION="Python binding for curl-impersonate (browser-impersonating HTTP)"
HOMEPAGE="https://github.com/lexiforest/curl_cffi https://pypi.org/project/curl_cffi/"
SRC_URI="https://files.pythonhosted.org/packages/e4/45/9208864ec429558efac168088e50f8a91b947f742ee128cff55b88c7b635/${MY_WHL} -> ${P}.whl"
S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="-* ~amd64"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	dev-python/cffi[${PYTHON_USEDEP}]
	dev-python/certifi[${PYTHON_USEDEP}]
"
BDEPEND="app-arch/unzip"

# ビルド済みバイナリ (同梱 .so) なので strip しない
RESTRICT="strip"
QA_PREBUILT="usr/lib/python*/site-packages/curl_cffi/*"

src_unpack() {
	# ホイールは zip。DISTDIR から直接展開する
	mkdir -p "${S}" || die
	unzip -qo "${DISTDIR}/${P}.whl" -d "${S}" || die
}

src_install() {
	install_one() {
		# dist-info も入れる: yfinance などが importlib.metadata で版を見る
		python_moduleinto .
		python_domodule curl_cffi
		python_domodule curl_cffi-${PV}.dist-info
	}
	python_foreach_impl install_one
}
