# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI="2"

inherit eutils flag-o-matic autotools

SLOT=0

DESCRIPTION="A collection of file system and media management forensic analysis tools"
HOMEPAGE="http://www.sleuthkit.org/sleuthkit/"
SRC_URI="mirror://sourceforge/sleuthkit/${P}.tar.gz"

LICENSE="GPL-2 IBM"
KEYWORDS="~amd64 ~arm ~hppa ~s390 ~sparc ~x86 ~x86-macos ~x64-macos"

DEPEND="ewf? ( app-forensics/libewf )
	qcow? ( dev-libs/libqcow )
	aff? ( app-forensics/afflib )"
RDEPEND="${DEPEND}
	dev-perl/DateManip"

IUSE="aff ewf qcow"

src_prepare() {
	epatch ${FILESDIR}/${P}-qcow.patch
	eautoreconf
}

src_configure() {
	econf\
		$(use_with aff afflib) \
		$(use_with ewf libewf) \
		$(use_with qcow libqcow) \
	|| die "configure failed"
}

src_install() {
	emake install DESTDIR="${D}" || die
	dodoc README.txt NEWS.txt
}
