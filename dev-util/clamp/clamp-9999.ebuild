# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit multilib base git-2 cmake-utils

DESCRIPTION="Clamp : An open source C++ compiler for heterogeneous devices"
HOMEPAGE="https://bitbucket.org/multicoreware/cppamp-driver-ng/wiki/Home"

#SRC_URI="https://bitbucket.org/multicoreware/cppamp-driver-ng/downloads/clamp-0.2.0-milestone5-135-g2580-Linux.tar.gz"
#SRC_URI="https://bitbucket.org/multicoreware/cppamp-driver-ng/downloads/${P}-hsa-milestone4-Linux.tar.gz "
SRC_URI=""
EGIT_REPO_URI="https://bitbucket.org/multicoreware/cppamp-driver-ng.git"

#EGIT_BRANCH="milestone4"

#X86_AT="AMD-APP-SDK-v${PV}-lnx32.tgz"
#AMD64_AT="AMD-APP-SDK-v${PV}-lnx64.tgz"
#X86_AT="clamp-0.2.0-milestone5-135-g2580-Linux.tar.gz"
#AMD64_AT="clamp-0.2.0-milestone5-135-g2580-Linux.tar.gz"

#MY_P="AMD-APP-SDK-v2.9-RC-lnx64"

#MY_P="clamp-0.2.0-milestone5-135-g2580-Linux"
#MY_P="${P}-hsa-milestone4-Linux"


# SRC_URI="
# 	amd64? ( ${AMD64_AT} )
# "

#x86? ( ${X86_AT} )

#LICENSE="AMD"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE="cuda"
#IUSE="examples"

#	dev-util/libcxxamp	

RDEPEND="
	cuda? ( dev-util/nvidia-cuda-toolkit )
	"
	
DEPEND="
	${RDEPEND}
	"

#RESTRICT="mirror strip"

#S="${WORKDIR}/${MY_P}"
#S="${WORKDIR}"
S="${WORKDIR}/cppamp-driver-ng"


# pkg_nofetch() {
# 	einfo "AMD doesn't provide direct download links. Please download"
# 	einfo "${ARCHIVE} from ${HOMEPAGE}"
# }

# src_unpack() {
# 	default
# 	#unpack ./${MY_P}.tgz
# 	unpack ./${MY_P}.tar.gz
# 	#unpack ./icd-registration.tgz
# }

#src_prepare() {
#	AMD_CL=usr/$(get_libdir)/OpenCL/vendors/amd/
#}


src_configure() {
		PREFIX="/opt/clamp"
		local mycmakeargs=(
		      #-DCMAKE_BUILD_TYPE=Release
		      -DCXXAMP_ENABLE_BOLT=OFF
		      #-DCMAKE_INSTALL_PREFIX=/opt/clamp
		)
		
		cmake-utils_src_configure
		
}

# src_compile() {
# 	MAKEOPTS+=" -j1"
# #	use examples && cd samples/opencl && emake
# #	#emake
# }



# src_install() {

#  	dodir /opt/clamp

# 	cp -R "${S}/"* "${ED}/" || die "Install failed!"

# 	#dodir "${AMD_CL}"
# 	#dosym "/opt/AMDAPP/lib/`arch`/libOpenCL.so"   "${AMD_CL}"
# 	#dosym "/opt/AMDAPP/lib/`arch`/libOpenCL.so.1" "${AMD_CL}"

# 	#insinto /etc/OpenCL/vendors/
# 	#doins ../etc/OpenCL/vendors/*
#}
