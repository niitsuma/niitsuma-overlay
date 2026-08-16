# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )
inherit distutils-r1 pypi

# yfinance の依存。::gentoo に無い純 Python の小物。
DESCRIPTION="multitasking (yfinance dependency)"
HOMEPAGE="https://pypi.org/project/multitasking/"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"
