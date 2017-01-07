# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2


EAPI=5

inherit autotools eutils multilib git-2 cmake-utils

#MY_P="${P/_}"

DESCRIPTION=""
HOMEPAGE="https://github.com/fcitx/fcitx-skk.git"
SRC_URI=""

EGIT_REPO_URI="https://github.com/fcitx/fcitx-skk git://github.com/fcitx/${PN}.git"

LICENSE="|| ( LGPL-2.1 BSD )"
SLOT="0"
KEYWORDS="~amd64 ~x86"

#IUSE="java perl python ruby unicode"
#IUSE="+unicode static-libs"

RDEPEND="
        app-i18n/fcitx
        app-i18n/libskk
        app-i18n/skk-jisyo
	"
	
DEPEND="${RDEPEND}"

# S="${WORKDIR}/${MY_P}"
# S="${WORKDIR}/${PN}"



