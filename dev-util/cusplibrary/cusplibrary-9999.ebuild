# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4
inherit git-2


DESCRIPTION="cusplibrary"
EGIT_REPO_URI="git://github.com/cusplibrary/cusplibrary https://github.com/cusplibrary/cusplibrary"
EGIT_COMMIT="master"

#SRC_URI="https://github.com/cusplibrary/cusplibrary/archive/v${PV}.zip"
#SRC_URI="https://github.com/cusplibrary/cusplibrary/releases/download/v${PV}/${P}.zip"

LICENSE="|| ( LGPL-2.1 BSD )"
SLOT="0"

KEYWORDS="~x86 ~amd64"

src_install() {
	insinto /opt/cuda/include/
	doins -r cusp
}

