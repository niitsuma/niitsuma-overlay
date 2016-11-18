# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
#inherit autotools eutils multilib git-2

#MY_P="${P/_}"

DESCRIPTION="redpen"

SRC_URI="https://github.com/redpen-cc/redpen/releases/download/${P}/${P}.tar.gz"
#https://github.com/redpen-cc/redpen/releases/download/redpen-1.7.6/redpen-1.7.6.tar.gz

#EGIT_REPO_URI="https://github.com/redpen-cc/redpen"

LICENSE="|| ( LGPL-2.1 BSD )"
SLOT="0"

KEYWORDS="-* amd64 x86"

# S="${WORKDIR}/redpen-distribution-${PN}"

src_unpack() {
    unpack ${A}
    mv -f "${PN}-distribution-${PV}" "${P}" || die
}

src_install() {
    into /opt/${PN}
    dobin bin/*
    #dolib lib/*

    insinto /opt/${PN}
    doins -r lib
    doins -r conf
    doins -r js
    doins -r sample-doc
    
}

