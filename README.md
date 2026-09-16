# argvus-terminal

Kitty terminal integration and ARGVUS configuration layer.

[![CI](https://github.com/argvus/argvus-terminal/actions/workflows/ci.yml/badge.svg)](https://github.com/argvus/argvus-terminal/actions/workflows/ci.yml)
[![Release](https://github.com/argvus/argvus-terminal/actions/workflows/release.yml/badge.svg)](https://github.com/argvus/argvus-terminal/actions/workflows/release.yml)
[![License](https://img.shields.io/badge/License-GPL--3.0-blue.svg)](LICENSE)

This repository builds the `argvus-terminal` Arch Linux package. It provides
the ARGVUS Kitty launcher and its configuration, themes, desktop entry, and
localized documentation.

## Build and install

On Arch Linux or a compatible distribution:

```sh
sudo pacman -S --needed base-devel git shellcheck
make validate
make build
make install
```

`make build` creates a deterministic source archive in `build/artifacts/` and
the package in `build/dist/`. `make install` requires `sudo`.

For package metadata only:

```sh
makepkg -p packaging/arch/ci/PKGBUILD --printsrcinfo
makepkg -p packaging/arch/local/PKGBUILD --printsrcinfo
```

See [packaging/arch/README.md](packaging/arch/README.md) for the local and
release packaging layout.

## Documentation

- [DEVELOPMENT.md](DEVELOPMENT.md) — layout, checks, and releases
- [CONTRIBUTING.md](CONTRIBUTING.md) — contribution workflow
- [SECURITY.md](SECURITY.md) — private vulnerability reports

## License

SPDX: `GPL-3.0-only`. See [LICENSE](LICENSE).
