prefix ?= /usr/local
bindir ?= $(prefix)/bin

.PHONY: build
build:
	@scripts/update-version.sh
	@swift build -c release --disable-sandbox

.PHONY: verify
verify:
	@swift test
	@scripts/verify-output.sh

.PHONY: install
install: build
	@install -d "$(bindir)"
	@install ".build/release/sendkeys" "$(bindir)/sendkeys"

.PHONY: uninstall
uninstall:
	@rm -rf "$(bindir)/sendkeys"

.PHONY: clean
clean:
	@rm -rf .build
