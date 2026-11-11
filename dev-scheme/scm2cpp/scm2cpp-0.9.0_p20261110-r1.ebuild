# Distributed under the terms of the GNU General Public License v2

EAPI=8

# 上流にはリリースが無い (CITATION.cff の version が 0.9.0 のまま) ので、
# master のコミットを固定したスナップショットとして入れる。
COMMIT="d5a9726cf3befcbd8fc5eec3fec9ca51cfe6805b"

DESCRIPTION="Scheme to readable C++ translator (BLAS/cuBLAS/CUDA aware)"
HOMEPAGE="https://github.com/niitsuma/scm2cpp"
# type-infer-util.scm は PLaneT の wmfarr/amb (McCarthy の amb、GPL-3+) を
# (require (planet ...)) で読み、初回コンパイル時にネットから落とそうとする。
# サンドボックスでは落とせないので PLaneT サーバの配布物を distfile として取り、
# vendor/amb/ に展開してローカルの相対 require に書き換える。
AMB_PLT_URI='https://planet.racket-lang.org/servlets/planet-servlet.ss?lang=%22300%22&name=%22amb.plt%22&maj=1&min-lo=0&min-hi=%23f&path=%28%22wmfarr%22%29'
SRC_URI="
	https://github.com/niitsuma/scm2cpp/archive/${COMMIT}.tar.gz -> ${P}.tar.gz
	${AMB_PLT_URI} -> wmfarr-amb-1.0.plt
"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="MIT GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

# 翻訳器は Racket で動く。生成した C++ をそのままビルドするには boost の
# ヘッダが要り、astyle が無いと出力が1行に詰まる (docs/translator.md)。
# miniKanren は vendor/rkanren に同梱されているので別途は要らない。
RDEPEND="
	dev-scheme/racket
	dev-libs/boost
	dev-util/astyle
"
BDEPEND="dev-scheme/racket"

src_unpack() {
	unpack ${P}.tar.gz
}

src_prepare() {
	default

	mkdir -p vendor/amb || die
	PLTUSERHOME="${T}/plt" raco planet open \
		"${DISTDIR}"/wmfarr-amb-1.0.plt vendor/amb >/dev/null || die
	sed -i 's|(require (planet "amb.scm" ("wmfarr" "amb.plt" 1 0)))|(require "vendor/amb/amb.scm")|' \
		type-infer-util.scm || die
	grep -q '"vendor/amb/amb.scm"' type-infer-util.scm || die "amb の require を置き換えられなかった"
}

src_compile() {
	# 起動を速くするために Racket モジュールを .zo へ前もってコンパイルする。
	# raco link --user の代わりに PLTCOLLECTS で同梱の vendor/ を見せる
	# (末尾の ':' は既定のコレクションも残すために必要)。
	local -x PLTUSERHOME="${T}/plt" PLTCOLLECTS="${S}/vendor:"
	raco make -v scm2cpp-file.scm || die
}

src_install() {
	insinto /usr/share/${PN}
	doins -r *.scm *.rkt *.typ *.hpp bindings cuda vendor compiled

	# 生成コードは "scm2cpp.hpp" などを include するので、-I 無しで
	# 見つかるようにランタイムヘッダは /usr/include にも置く。
	doheader scm2cpp*.hpp

	# このスナップショットの翻訳器は、-t が無いと型定義ファイル scm2c.typ を
	# カレントディレクトリから読む。インストール先のものを既定として渡す。
	# -t は後に書いたものが優先されるので、利用者が付けた -t がそのまま効く。
	# (上流は -t 無しでも scm2cpp-file.scm の隣の scm2c.typ を読むように
	# 直してある。それを含むスナップショットに上げたら、この -t は外してよい。)
	newbin - scm2cpp <<-EOT
	#!/bin/sh
	# racket scm2cpp-file.scm と同じ。オプションは docs/translator.md を参照。
	PLTCOLLECTS="${EPREFIX}/usr/share/${PN}/vendor:\${PLTCOLLECTS}" \\
		exec racket "${EPREFIX}/usr/share/${PN}/scm2cpp-file.scm" \\
		-t "${EPREFIX}/usr/share/${PN}/scm2c.typ" "\$@"
	EOT

	dodoc README.md README.ja.md CHANGES.ja.md FILES.md
	dodoc -r docs
	docinto examples
	dodoc -r examples/.
}
