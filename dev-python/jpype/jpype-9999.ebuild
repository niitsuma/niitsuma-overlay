# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

#inherit distutils
inherit multilib base git-2 distutils

DESCRIPTION="Allow python programs full access to java class libraries"
HOMEPAGE="http://jpype.sourceforge.net"

#SRC_URI="mirror://sourceforge/${PN}/${MY_P}.zip"
SRC_URI=""
EGIT_REPO_URI="https://github.com/originell/jpype git://github.com/originell/${PN}.git"

# SUPPORT_PYTHON_ABIS=1
# PYTHON_DEPEND=2
# RESTRICT_PYTHON_ABIS='3.*'

#MY_PN=JPype
#MY_P=${MY_PN}-${PV}


LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="examples"

RDEPEND=""
DEPEND="app-arch/unzip"

#S="${WORKDIR}"/${MY_P}
S="${WORKDIR}/${PN}"

src_install() {
	distutils_src_install

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r {examples,test} || die
	fi
}
