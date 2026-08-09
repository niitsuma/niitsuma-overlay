# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Python wrapper for TA-Lib (Technical Analysis Library)"
HOMEPAGE="https://github.com/TA-Lib/ta-lib-python https://pypi.org/project/TA-Lib/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# ::gentoo には Python バインディングが無いためローカルで用意している。
# sci-libs/ta-lib は 0.6.1 以降でライブラリ名が libta_lib -> libta-lib に
# 変わっており、この版はその新しい名前を前提にリンクする。::gentoo の
# 0.4.0 では -lta-lib が解決できないので、同じくローカルの 0.7.1 が必要。
RDEPEND="
	>=sci-libs/ta-lib-0.6.1
	dev-python/numpy[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
"

# sci-libs/ta-lib と PF が同一 (どちらも ta-lib-0.7.1) なので、既定の
# /usr/share/doc/${PF}/ が衝突する。C ライブラリ側の README を正とし、
# こちらは docs をインストールしない。
DOCS=()

distutils_enable_tests pytest

python_test() {
	# tests/ はインストール済みの talib を import する。ビルドツリー内から
	# 走らせると拡張モジュールが見つからないため、作業ディレクトリを移す。
	cd "${T}" || die
	epytest "${S}"/tests
}
