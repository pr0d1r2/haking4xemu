# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

MY_P=${P/${PN}/${PN}-alpha}
DESCRIPTION="Library providing device abstraction"
HOMEPAGE="http://www.sourceforge.net/projects/libsmio"
SRC_URI="mirror://sourceforge/libsmio/${PN}-alpha/${MY_P}/${MY_P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~x64-macos ~x86-macos"
IUSE="debug nls unicode"

DEPEND="dev-libs/libuna
	nls? (
		virtual/libintl
		virtual/libiconv
	)"

src_configure() {
	econf --disable-rpath \
		$(use_enable nls) \
		$(use_with nls libiconv-prefix) \
		$(use_with nls libintl-prefix) \
		$(use_enable unicode wide-character-type) \
		$(use_enable debug verbose-output) \
		$(use_enable debug debug-output)
}
