# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit git-2 cmake-utils
inherit cmake-utils

#EGIT_REPO_URI="https://github.com/viennacl/viennacl-dev.git"
EGIT_REPO_URI="file:///home/niitsumalocal/Documents/src/cpp/viennacl-dev"

DESCRIPTION="ViennaCL - A Linear algebra library for computations on GPUs and multi-core CPUs"
HOMEPAGE="http://viennacl.sourceforge.net"
#SRC_URI="mirror://sourceforge/viennacl/ViennaCL-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc cuda opencl +openmp +ublas"

RDEPEND="
	cuda? ( dev-util/nvidia-cuda-toolkit )
	opencl? ( virtual/opencl )
"

DEPEND="${RDEPEND}"


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

