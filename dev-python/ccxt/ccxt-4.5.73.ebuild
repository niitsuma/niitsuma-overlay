# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

# 暗号資産取引所の統一 API。btcbothy / tdb など trade 系スクリプトが使う。
# ~/src/trade/lib/myccxt (自前フォーク) とは別物で、こちらは本家。
#
# 上流の requires_dist はすべて == でピン留めされているが、Gentoo では
# システムの版を使う。実行時に版チェックは走らないので実害はない。
DESCRIPTION="CryptoCurrency eXchange Trading library"
HOMEPAGE="https://github.com/ccxt/ccxt https://pypi.org/project/ccxt/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/certifi[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/typing-extensions[${PYTHON_USEDEP}]
	dev-python/aiohttp[${PYTHON_USEDEP}]
	dev-python/yarl[${PYTHON_USEDEP}]
	dev-python/aiodns[${PYTHON_USEDEP}]
"

# 試験は同梱されていない (別リポジトリ構成)
RESTRICT="test"
