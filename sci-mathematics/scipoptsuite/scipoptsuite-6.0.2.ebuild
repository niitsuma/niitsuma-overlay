EAPI=6

inherit eutils cmake-utils
#inherit autotools

DESCRIPTION="Solving Constraint Integer Programs "
HOMEPAGE="https://scip.zib.de/"
SRC_URI="https://scip.zib.de/download.php?fname=${PN}-${PV}.tgz  -> ${PN}-${PV}.tgz"

LICENSE="MIT"
SLOT="0"

#KEYWORDS="~amd64 ~amd64-linux ~arm ~arm64 ~mips ~ppc ~x86 ~x86-linux"
KEYWORDS="~amd64 ~amd64-linux "

DEPEND="dev-libs/gmp"
RDEPEND="${DEPEND}"

#CMAKE_PREFIX_PATH=/usr

#src_configure() {
#    econf
#}
