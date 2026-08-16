# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )
PYPI_PN="tradingview_ta"
inherit distutils-r1 pypi

# myccxt (crawl-binance.py) が使う TradingView テクニカル分析クライアント。
DESCRIPTION="TradingView technical analysis API client"
HOMEPAGE="https://pypi.org/project/tradingview-ta/"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
RDEPEND="dev-python/requests[${PYTHON_USEDEP}]"
RESTRICT="test"
