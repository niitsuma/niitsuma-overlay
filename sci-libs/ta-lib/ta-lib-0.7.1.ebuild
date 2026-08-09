# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Technical Analysis Library for analyzing financial markets trends"
HOMEPAGE="https://ta-lib.org/ https://github.com/TA-Lib/ta-lib"
SRC_URI="https://github.com/TA-Lib/ta-lib/releases/download/v${PV}/${P}-src.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# ::gentoo は 0.4.0 (2013 年の SourceForge 版) で止まっている。PyPI の
# TA-Lib >= 0.6.1 は共有ライブラリ名が libta_lib -> libta-lib に変わった
# 前提でリンクするため、dev-python/ta-lib を使うにはこちらが必要。
# 上流は GitHub の TA-Lib/ta-lib へ移り、0.7.x が現行。

src_prepare() {
	default
	eautoreconf
}

src_test() {
	src/tools/ta_regtest/ta_regtest || die
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
