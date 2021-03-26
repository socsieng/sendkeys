prefix ?= /usr/local
bindir ?= $(prefix)/bin

.PHONY: build
build:
	@scripts/update-version.sh
	@swift build -c release --disable-sandbox --triple x86_64-apple-macosx
	@swift build -c release --disable-sandbox --triple arm64-apple-macosx
	@lipo -create -output .build/sendkeys .build/arm64-apple-macosx/release/sendkeys .build/x86_64-apple-macosx/release/sendkeys

.PHONY: verify
verify:
	@swift test
	@scripts/verify-output.sh

.PHONY: install
install: build
	@install -d "$(bindir)"
	@install ".build/sendkeys" "$(bindir)/sendkeys"

.PHONY: uninstall
uninstall:
	@rm -rf "$(bindir)/sendkeys"

.PHONY: clean
clean:
	@rm -rf .build
