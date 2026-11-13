# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit cuda distutils-r1 pypi

DESCRIPTION="scikit-learn estimators translated from Scheme to C++ by scm2cpp"
HOMEPAGE="https://github.com/niitsuma/scm2cpp https://pypi.org/project/scm2cpp-learn/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cuda mkl +openmp"

# sdist にはコミット済みの生成 C++ が入っていて、ビルドに Racket や
# 翻訳器 (dev-scheme/scm2cpp) は要らない。共有ライブラリは ctypes で読む。
# setup.py は MKL / OpenBLAS / OpenMP / nvcc を自動で探すので、
# 環境変数 SCM2CPP_NO_* で USE に合わせて明示的に切る。
RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	cuda? ( dev-util/nvidia-cuda-toolkit )
	mkl? ( sci-libs/mkl )
	!mkl? ( sci-libs/openblas )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

python_compile() {
	local -x SCM2CPP_NO_CUDA SCM2CPP_NO_MKL SCM2CPP_NO_OPENMP
	use cuda || SCM2CPP_NO_CUDA=1
	use mkl || SCM2CPP_NO_MKL=1
	use openmp || SCM2CPP_NO_OPENMP=1
	if use cuda; then
		# nvcc -arch=native が GPU を問い合わせるので /dev/nvidia* を開けるようにする
		cuda_add_sandbox -w
		local -x PATH="${EPREFIX}/opt/cuda/bin:${PATH}"
	fi
	distutils-r1_python_compile
}
