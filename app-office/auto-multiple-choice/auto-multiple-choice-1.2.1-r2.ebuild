# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils toolchain-funcs

SLOT="0"

DESCRIPTION="Create and manage multiple choice questionnaries (MCQ), including automated marking."
HOMEPAGE="http://project.auto-multiple-choice.net/projects/auto-multiple-choice/"
SRC_URI="http://download.gna.org/auto-qcm/${PN}_${PV}_sources.tar.gz"
LICENSE="GPL-2+"
KEYWORDS="~x86 ~amd64"
IUSE="msmtp"

DEPEND="virtual/tex-base
		virtual/latex-base
		app-text/texlive[dvi2tty,extra,graphics,png,pstricks,science,truetype,xml,X,luatex,xetex,humanities,omega,publishers,linguas_fr]
		app-text/poppler
		media-libs/netpbm
		app-text/dblatex
		app-text/docbook-xml-simple-dtd
		app-text/docbook-xsl-stylesheets
		media-libs/opencv"

RDEPEND="${DEPEND}
		dev-lang/perl
		dev-perl/gtk2-perl
		dev-perl/Gtk2-Notify
		media-gfx/imagemagick
		dev-perl/XML-Writer
		dev-perl/Archive-Zip
		dev-perl/DBI
		dev-perl/Text-CSV
		dev-perl/DBD-SQLite
		dev-perl/Net-CUPS
		dev-perl/Email-Address
		dev-perl/Email-MIME
		dev-perl/Email-Sender
		msmtp? ( mail-mta/msmtp )"


src_prepare() {
	# Apply patch on desktop file
	epatch "${FILESDIR}/${PN}-1.2-desktop.patch"

	# Patch Makefile.conf with a valid local PERLDIR
	PERL_LOCAL_DIR=$(perl -e 'print "$_\n" for @INC' | grep '/local/' | sort | head -n1)
	sed -i s?'^PERLDIR=.*$'?'PERLDIR='${PERL_LOCAL_DIR}?g Makefile.conf
}

src_compile() {
	export TEXINPUTS=":/usr/share/dblatex/latex/style:/usr/share/dblatex/latex/misc:/usr/share/dblatex/latex/graphics:"
	emake \
			GCC_NETPBM="-I/usr/include/netpbm/ -lnetpbm" \
			GCC="$(tc-getCC)" \
			GCC_PP="$(tc-getCXX)"	
}

pkg_postinst()
{
	elog "Running 'texhash' to add 'automultiplechoice.sty'."
	texhash || die 'An error occured while running texhash'
}

pkg_postrm()
{
	elog "Running 'texhash' to remove 'automultiplechoice.sty'."
	texhash || die 'An error occured while running texhash'
}
