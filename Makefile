ver = 1.0.0

.SILENT:
.PHONY: test release crawl

test:
	swift test

release:
	scripts/release.sh ${ver}

crawl:
	swift run
