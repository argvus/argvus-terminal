PREFIX ?= /usr
DESTDIR ?=
INSTALL ?= install
RM ?= rm -f

.DEFAULT_GOAL := help

.PHONY: help install uninstall validate build clean

help:
	@echo "Available targets:"
	@echo "  make build"
	@echo "  make install"
	@echo "  make uninstall"
	@echo "  make validate"

install:
	$(INSTALL) -Dm755 src/usr/bin/argvus-terminal \
		"$(DESTDIR)$(PREFIX)/bin/argvus-terminal"
	$(INSTALL) -Dm644 src/usr/share/applications/argvus-terminal.desktop \
		"$(DESTDIR)$(PREFIX)/share/applications/argvus-terminal.desktop"
	$(INSTALL) -dm755 "$(DESTDIR)$(PREFIX)/share/argvus-terminal"
	cp -R --no-preserve=ownership src/usr/share/argvus-terminal/. "$(DESTDIR)$(PREFIX)/share/argvus-terminal/"
	$(INSTALL) -Dm644 LICENSE \
		"$(DESTDIR)$(PREFIX)/share/licenses/argvus-terminal/LICENSE"

uninstall:
	$(RM) "$(DESTDIR)$(PREFIX)/bin/argvus-terminal"
	$(RM) "$(DESTDIR)$(PREFIX)/share/applications/argvus-terminal.desktop"
	rm -rf "$(DESTDIR)$(PREFIX)/share/argvus-terminal"
	$(RM) "$(DESTDIR)$(PREFIX)/share/licenses/argvus-terminal/LICENSE"

validate:
	@set -eu; \
	test -x src/usr/bin/argvus-terminal; \
	test -f src/usr/share/applications/argvus-terminal.desktop; \
	test -f src/usr/share/argvus-terminal/kitty/kitty.conf; \
	test -f src/usr/share/argvus-terminal/kitty-tui/kitty.conf; \
	for theme in src/usr/share/argvus-terminal/kitty/themes/*/theme.conf; do test -f "$$theme"; done; \
	sh -n src/usr/bin/argvus-terminal; \
	if command -v shellcheck >/dev/null 2>&1; then \
		shellcheck -e SC1090 -e SC1091 src/usr/bin/argvus-terminal; \
	else \
		echo "shellcheck not found; skipped"; \
	fi; \
	if command -v desktop-file-validate >/dev/null 2>&1; then \
		desktop-file-validate src/usr/share/applications/argvus-terminal.desktop; \
	else \
		echo "desktop-file-validate not found; skipped"; \
	fi; \
	! find src/usr -path '*/bin/kitty' -o -path '*/applications/kitty.desktop' -o -path '*/etc/xdg/kitty/*' | grep -q .
	@echo "argvus-terminal validation ok"

build:
	@tools/build-local-package.sh

clean:
	rm -rf dist
	rm -f *.pkg.tar* packaging/arch/*.zst packaging/arch/*.tar.gz
