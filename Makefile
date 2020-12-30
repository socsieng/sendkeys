prefix ?= /usr/local
bindir ?= $(prefix)/bin

.PHONY: build
build:
	@swift build -c release --disable-sandbox

.PHONY: install
install: build
	@install ".build/release/sendkeys" "$(bindir)"

.PHONY: uninstall
uninstall:
	rm -rf "$(bindir)/sendkeys"

.PHONY: clean
clean:
	rm -rf .build/release
