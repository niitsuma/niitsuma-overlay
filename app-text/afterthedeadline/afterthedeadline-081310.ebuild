# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6


DESCRIPTION="after the deadline"

SRC_URI="http://www.polishmywriting.com/download/atd_distribution081310.tgz"

LICENSE="|| ( GPL-2 )"
SLOT="0"

KEYWORDS="-* amd64 x86"

src_unpack() {
    unpack ${A}
    mv -f "atd" "${P}" || die
}

src_install() {
    into /opt/${PN}
    dobin bin/*
    
    #dolib lib/*
    insinto /opt/${PN}
    doins CREDITS.rules.txt  CREDITS.txt  LICENSE.txt README.txt build.log mime.types run-lowmem.bat  run-lowmem.sh run.sh
    #doins -r bin data  lib  logs    models    service  utils
    doins -r data lib logs models service utils
    #doins CREDITS.rules.txt  CREDITS.txt  LICENSE.txt README.txt atdconfig.sl build.log mime.types run-lowmem.bat  run-lowmem.sh  run.sh
    #doins -r *
    doins "${FILESDIR}/atdconfig.sl"
    
    newinitd "${FILESDIR}/${PN}.initd" afterthedeadlined

    into /opt
    dobin "${FILESDIR}/afterthedeadlined"

}

