ver = 1.2.1

.SILENT:
.PHONY: test release crawl

test:
	swift test

release:
	scripts/release.sh ${ver}

crawl:
	swift run

lint:
	swift package swiftlint --quiet | grep -v '^warning: ' || [ $$? == 1 ]

format:
	swift package swiftlint --quiet --fix | grep -v '^warning: ' || [ $$? == 1 ]
