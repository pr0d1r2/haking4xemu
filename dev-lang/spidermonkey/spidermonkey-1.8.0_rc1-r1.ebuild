# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/spidermonkey/spidermonkey-1.7.0.ebuild,v 1.7 2007/12/29 16:58:01 ranger Exp $
EAPI=2

inherit eutils toolchain-funcs multilib

MY_PV=${PV/_rc/-rc}
MY_P="js-${MY_PV}"
DESCRIPTION="Stand-alone JavaScript C library"
HOMEPAGE="http://www.mozilla.org/js/spidermonkey/"
SRC_URI="http://ftp.mozilla.org/pub/mozilla.org/js/${MY_P}.tar.gz"

LICENSE="NPL-1.1"
SLOT="0"
KEYWORDS="alpha amd64 hppa ppc ppc64 sparc x86 ~x86-fbsd ~x64-macos"
IUSE="threadsafe nls"

S="${WORKDIR}/js/src"

RDEPEND="nls? ( virtual/libintl )
	threadsafe? ( dev-libs/nspr )"

DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

src_prepare() {
	epatch "${FILESDIR}/${P}"-{build,nls,header}.diff
	epatch "${FILESDIR}/${PN}-1.7.0-threadsafe.diff"
	epatch "${FILESDIR}/linker_hardened.patch"
	if [[ ${CHOST} == *-freebsd* ]]; then
		# Don't try to be smart, this does not work in cross-compile anyway
		ln -s "${S}/config/Linux_All.mk" "${S}/config/$(uname -s)$(uname -r).mk"
	fi
}

src_compile() {
	tc-export CC LD AR
	if use nls; then
		JS_NLS=1
	else
		JS_NLS=0
	fi
	if use threadsafe; then
		emake -j1 -f Makefile.ref LIBDIR="$(get_libdir)" JS_THREADSAFE=1 \
		JS_NLS=${JS_NLS} || die "emake with threadsafe enabled failed";
	else
		emake -j1 -f Makefile.ref LIBDIR="$(get_libdir)" JS_NLS=${JS_NLS} \
		|| die "emake without threadsafe enabled failed";
	fi
}

src_install() {
	emake -f Makefile.ref install DESTDIR="${D}" LIBDIR="$(get_libdir)" || die
	dodoc ../jsd/README
	dohtml README.html
}
