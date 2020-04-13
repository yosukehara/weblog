#======================================================================
#
# Lions Data, Ltd.
#
#======================================================================
.PHONY: all build serve

all: build

build:
	rm -rf site/ && mkdocs build
serve: build
	mkdocs serve --dev-addr 0.0.0.0:8000
