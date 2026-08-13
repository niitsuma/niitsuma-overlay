# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

# moomoo (Futu) OpenAPI の Python SDK。単体では何もできず、
# net-misc/futu-opend (ゲートウェイ) が localhost で待ち受けている
# 必要がある。SDK -> OpenD -> moomoo のサーバ、という三段構成。
DESCRIPTION="Python SDK for the moomoo (Futu) OpenAPI"
HOMEPAGE="https://openapi.moomoo.com/moomoo-api-doc/en/
	https://pypi.org/project/moomoo-api/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/pandas[${PYTHON_USEDEP}]
	dev-python/simplejson[${PYTHON_USEDEP}]
	>=dev-python/protobuf-3.20.0[${PYTHON_USEDEP}]
	dev-python/pycryptodome[${PYTHON_USEDEP}]
"

# 上流は試験を同梱していない。
RESTRICT="test"

pkg_postinst() {
	elog "この SDK は単体では動かない。ゲートウェイが要る:"
	elog "    emerge net-misc/futu-opend"
	elog "    futu-opend -login_account=<口座> -login_pwd_md5=<MD5>"
	elog ""
	elog "SDK は既定で localhost:11111 の OpenD に接続する:"
	elog "    from moomoo import OpenQuoteContext"
	elog "    ctx = OpenQuoteContext(host='127.0.0.1', port=11111)"
}
