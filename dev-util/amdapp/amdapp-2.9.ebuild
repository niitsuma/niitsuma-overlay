# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit multilib

X86_AT="AMD-APP-SDK-v${PV}-lnx32.tgz"
AMD64_AT="AMD-APP-SDK-v${PV}-lnx64.tgz"

MY_P="AMD-APP-SDK-v2.9-RC-lnx64"

DESCRIPTION="AMD Accelerated Parallel Processing (APP) SDK"
HOMEPAGE="http://developer.amd.com/tools/heterogeneous-computing/\
amd-accelerated-parallel-processing-app-sdk"
SRC_URI="
	amd64? ( ${AMD64_AT} )
"

#x86? ( ${X86_AT} )

LICENSE="AMD"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="examples"

RDEPEND="

	!<dev-util/amdstream-2.6
	sys-devel/llvm
	sys-devel/gcc
	"	

#	app-admin/eselect-opengl
#	media-libs/mesa
#	media-libs/freeglut
#	app-admin/eselect-opencl

#	|| ( dev-util/opencl-headers dev-util/nvidia-cuda-toolkit
#		>=x11-drivers/ati-drivers-11.12[opencl] )
#	examples? ( media-libs/glew )


DEPEND="
	${RDEPEND}
	dev-lang/perl
	dev-util/patchelf
	sys-apps/fakeroot"

RESTRICT="mirror strip"

S="${WORKDIR}/${MY_P}"

pkg_nofetch() {
	einfo "AMD doesn't provide direct download links. Please download"
	einfo "${ARCHIVE} from ${HOMEPAGE}"
}

src_unpack() {
	default
	unpack ./${MY_P}.tgz
	unpack ./icd-registration.tgz
}

src_prepare() {
	AMD_CL=usr/$(get_libdir)/OpenCL/vendors/amd/
}

#src_compile() {
	#MAKEOPTS+=" -j1"
	#use examples && cd samples/opencl && emake
	#emake
#}

src_install() {
	dodir /opt/AMDAPP
	cp -R "${S}/"* "${ED}/opt/AMDAPP" || die "Install failed!"

	dodir "${AMD_CL}"
	#dosym "/opt/AMDAPP/lib/`arch`/libOpenCL.so"   "${AMD_CL}"
	dosym "/opt/AMDAPP/lib/`arch`/libOpenCL.so.1" "${AMD_CL}"/libOpenCL.so.1.2

	### may need?
	#dosym "/opt/AMDAPP/lib/`arch`/libamdocl64.so" "${AMD_CL}"

	#dosym "/opt/AMDAPP/lib/`arch`/libOpenCL.so"   usr/$(get_libdir)/
	dosym "/opt/AMDAPP/lib/`arch`/libOpenCL.so.1" usr/$(get_libdir)/libOpenCL.so.1.2
	#dosym "/opt/AMDAPP/lib/`arch`/libamdocl64.so" usr/$(get_libdir)/



	insinto /etc/OpenCL/vendors/
	doins ../etc/OpenCL/vendors/*

	#dodir /etc/OpenCL/vendors/
	#echo "/opt/AMDAPP/lib/x86_64/libamdocl64.so" > "${ED}/etc/OpenCL/vendors/amdocl64.icd"


	dodir /etc/ld.so.conf.d/
	echo "/opt/AMDAPP/lib/x86_64" > "${ED}/etc/ld.so.conf.d/amdapp_x86_64.conf"
	echo "/opt/AMDAPP/lib/x86" >  "${ED}/etc/ld.so.conf.d/amdapp_x86.conf"

}
