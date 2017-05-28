# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit git-2

#EGIT_REPO_URI="https://github.com/dilawar/boost-numeric-bindings.git"
EGIT_REPO_URI="http://git.tiker.net/trees/boost-numeric-bindings.git"

DESCRIPTION="Boost UBLAS numeric bindings"
HOMEPAGE="http://mathema.tician.de/software/"

LICENSE="MIT"

SLOT="0"
KEYWORDS="~x86 ~amd64"

#IUSE=""
#DEPEND=">=dev-libs/boost-1.35.0 "
#RDEPEND="${DEPEND}"

src_configure() {
    if [[ -x ${ECONF_SOURCE:-.}/configure ]] ; then
        echo "Done"
    fi
    }

src_install() {
	insinto /usr/include/
	doins -r boost
}

