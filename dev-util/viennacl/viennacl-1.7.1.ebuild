# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

#inherit git-2 cmake-utils
inherit cmake-utils

#EGIT_REPO_URI="https://github.com/viennacl/viennacl-dev.git"

DESCRIPTION="ViennaCL - A Linear algebra library for computations on GPUs and multi-core CPUs"
HOMEPAGE="http://viennacl.sourceforge.net"
SRC_URI="mirror://sourceforge/viennacl/ViennaCL-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc cuda opencl +openmp +ublas"

#DEPEND="virtual/opencl dev-libs/pugixml"
#RDEPEND="${DEPEND}"
RDEPEND="
	cuda? ( dev-util/nvidia-cuda-toolkit:0= )
	opencl? ( virtual/opencl )
"

DEPEND="${RDEPEND}"

src_unpack() {
    unpack ${A}
    mv -f "ViennaCL-${PV}" "${P}" || die

    #git-2_src_unpack
    #cd "${S}"
    #epatch "${FILESDIR}"/pugixml.patch
}

src_configure() {
    local mycmakeargs=(
	-DWITH_OPENCL=$(usex opencl)
	-DENABLE_OPENCL=$(usex opencl)
	-DWITH_OPENMP=$(usex openmp)
	-DENABLE_OPENMP=$(usex openmp)
	-DWITH_CUDA=$(usex cuda)
	-DENABLE_CUDA=$(usex cuda)
	-DWITH_UBLAS=$(usex ublas)
	-DENABLE_UBLAS=$(usex ublas)
	)
    cmake-utils_src_configure
}

# src_compile() {
# 	cmake-utils_src_compile
# }

# src_install() {
# 	cmake-utils_src_install
# }


# src_install() {
# 	insinto /usr/include
# 	doins -r viennacl
# 	doins -r ${CMAKE_BUILD_DIR}/viennacl
# 	if use doc; then
# 		dodoc doc/viennacl.pdf
# 	fi
# }

