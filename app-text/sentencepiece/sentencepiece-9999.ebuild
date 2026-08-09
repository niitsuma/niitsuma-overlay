# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/cabocha/Attic/cabocha-0.66.ebuild,v 0.1 2013/11/20 12:24:15 tove dead $

EAPI=5

inherit autotools eutils multilib git-2

#MY_P="${P/_}"

DESCRIPTION="Unsupervised text tokenizer for Neural Network-based text generation"
HOMEPAGE="https://github.com/google/sentencepiece"
SRC_URI=""
# mirror://sourceforge/cabocha/${MY_P}.tar.bz2

EGIT_REPO_URI="https://github.com/google/sentencepiece"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"

#IUSE="java perl python ruby unicode"
#IUSE="+unicode static-libs"
IUSE=""



RDEPEND="dev-libs/protobuf
	"
	
DEPEND="${RDEPEND}
	"

src_prepare() {
    ./autogen.sh
}
