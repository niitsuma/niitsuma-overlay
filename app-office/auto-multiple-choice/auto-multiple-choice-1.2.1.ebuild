# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils

SLOT="1.2"

DESCRIPTION="Create and manage multiple choice questionnaries (MCQ), including automated marking."
HOMEPAGE="http://project.auto-multiple-choice.net/projects/auto-multiple-choice/"
SRC_URI="http://download.gna.org/auto-qcm/auto-multiple-choice_1.2.1_sources.tar.gz"
LICENSE="MIT"
KEYWORDS="amd64"
IUSE="msmtp"

DEPEND="virtual/tex-base
		virtual/latex-base
		>=app-text/texlive-2012[doc,dvi2tty,dvipdfm,extra,graphics,png,pstricks,science,truetype,xml,X,luatex,xetex,detex,humanities,omega,pdfannotextractor,publishers,tex4ht,xindy]
		>=app-text/poppler-0.24.5
		>=media-libs/netpbm-10.51.00
		>=app-text/dblatex-0.3.4
		>=app-text/docbook-xml-simple-dtd-4.1.2.5:4.1.2.5
		>=app-text/docbook-xsl-stylesheets-1.78.0
		>=media-libs/opencv-2.4.5"

RDEPEND=">=dev-perl/gtk2-perl-1.247.0
		>=media-gfx/imagemagick-6.8.8.10
		>=dev-perl/XML-Writer-0.623.0
		>=dev-perl/Archive-Zip-1.300.0
		>=dev-perl/DBI-1.623.0
		>=dev-perl/Text-CSV-1.320.0
		>=dev-perl/DBD-SQLite-1.350.0
		>=dev-lang/perl-5.18:0/5.18
		>=dev-perl/DBD-mysql-4.20.0
		>=dev-perl/Net-CUPS-0.610.0
		>=dev-perl/Email-Address-1.905.0
		>=dev-perl/Email-MIME-1.924.0
		>=dev-perl/Email-Sender-0.120.2
		msmtp? ( >=mail-mta/msmtp-1.4.31 )"

src_prepare() {
	# Apply patch on make files
	epatch "${FILESDIR}/${PN}-1.2-makefiles.patch"
}

src_configure() {
	# No configuration...
	true
}

src_compile() {
	export TEXINPUTS=":/usr/share/dblatex/latex/style:/usr/share/dblatex/latex/misc:/usr/share/dblatex/latex/graphics:"
	make
}

pkg_postinst()
{
	elog "Running 'texhash' to add 'automultiplechoice.sty'."
    texhash
}

pkg_postrm()
{
	elog "Running 'texhash' to remove 'automultiplechoice.sty'."
    texhash
}
