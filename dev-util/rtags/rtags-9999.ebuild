# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit cmake-utils
inherit git-r3

EGIT_REPO_URI="https://github.com/Andersbakken/rtags.git"
EGIT_OPTIONS="--recursive"
DESCRIPTION="A c/c++ client/server indexer for c/c++/objc[++] with integration for Emacs based on clang. http://www.rtags.net"
HOMEPAGE="https://github.com/Andersbakken/rtags"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="sys-devel/clang"

DEPEND="${RDEPEND}"


