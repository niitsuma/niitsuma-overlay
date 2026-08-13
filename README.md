# niitsuma-overlay

Personal Gentoo ebuild repository (overlay).

Two kinds of package live here:

- **Packages that are not in `::gentoo` at all** — mostly Japanese NLP tooling
  and numerical/optimisation libraries.
- **Fixed copies of `::gentoo` ebuilds** that do not build as shipped. These are
  temporary by nature; each one carries a comment saying what is wrong and, where
  one exists, the Gentoo bug number. **Delete them once `::gentoo` is fixed** —
  a stale local copy silently pins you to an old version.

## Installing

`layman` was removed from `::gentoo`, and `PORTDIR_OVERLAY` in `make.conf` is
long gone. Use `repos.conf`:

```sh
cat > /etc/portage/repos.conf/niitsuma-overlay.conf <<'EOF'
[niitsuma-overlay]
location = /var/db/repos/niitsuma-overlay
sync-type = git
sync-uri = https://github.com/niitsuma/niitsuma-overlay.git
masters = gentoo
priority = 100
auto-sync = yes
EOF

emerge --sync niitsuma-overlay
```

Or, if you keep a working copy elsewhere (e.g. a git checkout in `~/Documents`),
point `location` at it and set `auto-sync = no`.

`app-eselect/eselect-repository` can do the same thing:

```sh
eselect repository add niitsuma-overlay git https://github.com/niitsuma/niitsuma-overlay.git
```

Most packages here are `~amd64` or have no keywords at all, so they need
`/etc/portage/package.accept_keywords/` entries.

## Working on an ebuild

```sh
cd <category>/<package>
ebuild <package>-<version>.ebuild manifest     # after any change to SRC_URI
emerge -q =<category>/<package>-<version>
```

## Packages

### Not in `::gentoo`

| Package | What it is | Note |
| --- | --- | --- |
| `app-text/afterthedeadline` | English grammar/style checker server | EAPI 6 |
| `app-office/webull-desktop` | Webull Securities trading terminal | Repacks upstream's Debian `.deb`. EAPI 8 |
| `net-misc/futu-opend` | moomoo/Futu OpenAPI gateway daemon | Upstream ships Ubuntu/CentOS tarballs only. RUNPATH starts with `$ORIGIN` so it relocates cleanly |
| `dev-python/moomoo-api` | Python SDK for the above | Not in `::gentoo`; system Python is PEP 668 managed so pip is not an option |
| `net-print/ipp-usb` | Exposes a USB IPP printer/MFP as a local IPP+eSCL service | Needed for driverless printing **and** ADF scanning over USB. See `private/machines.md` |

### Fixed copies of `::gentoo` ebuilds

| Package | Why it is here |
| --- | --- |
| `sci-ml/pytorch-2.13.0-r3` | Three build failures with CUDA. See the comments in the ebuild: `TORCH_CUDA_ARCH_LIST` substring-expansion typo (Gentoo bug #980415), empty bundled `cudnn_frontend` include dir (unreported), and `-lhttplib` on a `-distributed` build (bug #980468). |

### Newer than `::gentoo`

| Package | Why it is here |
| --- | --- |
| `sci-libs/ta-lib-0.7.1` | `::gentoo` carries 0.4.0, the 2013 SourceForge release. Upstream moved to <https://github.com/TA-Lib/ta-lib> and renamed the shared library `libta_lib` → `libta-lib` in 0.6.1. |
| `dev-python/ta-lib-0.7.1` | The Python wrapper is not packaged in `::gentoo` at all, and links against the new library name — so it needs the 0.7.x C library above. `DOCS=()` because it shares its `PF` with `sci-libs/ta-lib`. |

## History

This overlay began as a fork of
[kiyoya-overlay](https://github.com/kiyoya/kiyoya-overlay).

In August 2026 it was cut down from 50 packages to the list above. A second
pass on 2026-08-13 removed six more that current Portage cannot even read:
they `inherit` eclasses that no longer exist (`cmake-utils`, `git-2`, `eutils`,
`base`) or declare EAPI 5. Checked by running `ebuild ... clean` on every
package rather than by eye. None were installed; `sentencepiece` is now in
`::gentoo` as `sci-ml/sentencepiece`. Removed were:
altcoin wallets and GPU miners from the 2017–2019 era; packages that `::gentoo`
has since absorbed (`auto-multiple-choice`, `cutlass`, `petsc`, `wwwoffle`,
`ufconfig`, and `scipy` which moved to `dev-python/`); and ebuilds written for
EAPI 4 or older, which current Portage cannot use. Everything removed is still
in the git history.
