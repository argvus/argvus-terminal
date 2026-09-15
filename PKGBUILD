# Maintainer: William C. Canin
pkgname=argvus-terminal
pkgver=0.1.0
pkgrel=1
pkgdesc="Kitty terminal integration and ARGVUS configuration layer."
arch=('any')
url="https://github.com/argvus/argvus-terminal"
license=('GPL-3.0-only')
depends=(
  'argvus-session'
  'argvus-i18n'
  'kitty'
)
makedepends=()
options=('!debug')
source=()
sha256sums=()

package() {
  cd "${startdir}"
  make DESTDIR="${pkgdir}" PREFIX=/usr install
}
