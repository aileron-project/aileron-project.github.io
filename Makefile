
# See the package.json of the docsy to check minimum hugo version.
# https://github.com/google/docsy/blob/main/package.json
HUGO_VERSION:=0.145.0
DOCSY_VERSION:=v0.11.0

.PHONY: install-tools
install-tools:
	wget -O hugo.deb https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-amd64.deb
	sudo dpkg -i hugo.deb
	sudo snap install dart-sass

.PHONY: install-npm-packages
install-npm-packages:
	# Install required https://www.docsy.dev/docs/get-started/docsy-as-module/installation-prerequisites/.
	# npm install --save-dev autoprefixer
	# npm install --save-dev postcss-cli
	# npm install --save-dev postcss
	npm install
	cd themes/docsy/ && git fetch --tags && git checkout tags/$(DOCSY_VERSION)
	cd themes/docsy/ && npm install


################################################################################
################################################################################
################################################################################

# TEST

PRJ:=aileron-test
TAG=v0.0.1

ADOC_CMD ?= asciidoctor
ADOC_CMD_PDF ?= asciidoctor-pdf
ADOC_CMD_EPUB ?= asciidoctor-epub3
ADOC_TARGET ?= $(shell find ./docs/ -maxdepth 2 -mindepth 2 -type f -name '*.adoc' 2>/dev/null)
ADOC_TARGET ?= 'docs/*/*.adoc'
ADOC_OPTION ?=

# :experimental:
# :icons: font
# :reproducible:
# :listing-caption: Listing
# :source-highlighter: highlightjs
# :toc: top
# :sectnums:
# :toc-title: FOOBARBAZ
# :chapter-label:
# :company: MyCompany
# :doctype: book

ADOC_ATTRS += experimental reproducible data-uri stem=asciimath toc=none sectnums doctype=book source-highlighter=highlightjs
ADOC_ATTRS += imagesoutdir=_output/tmp/
ADOC_ATTRS += cachedir=_output/.asciidoctor/
ADOC_ATTRS += diagram-cachedir=_output/.asciidoctor/
# ADOC_ATTRS += stylesheet=/scss/main.css linkcss
ADOC_ATTRS := $(addprefix --attribute=,$(ADOC_ATTRS))
# ADOC_EPUB_REQS ?= asciidoctor-diagram asciidoctor-lists asciidoctor-mathematical

ADOC_REQS ?= asciidoctor-diagram asciidoctor-lists asciidoctor-mathematical
ADOC_REQS := $(addprefix --require=,$(ADOC_REQS))

.PHONY: asciidoc-html
asciidoc-html:
	$(ADOC_CMD) $(ADOC_OPTION) $(ADOC_ATTRS) $(ADOC_REQS) $(ADOC_TARGET)

.PHONY: asciidoc-pdf
asciidoc-pdf:
	$(ADOC_CMD_PDF) $(ADOC_OPTION) $(ADOC_ATTRS) $(ADOC_REQS) $(ADOC_TARGET)

.PHONY: asciidoc-epub
asciidoc-epub:
	$(ADOC_CMD_EPUB) $(ADOC_OPTION) $(ADOC_ATTRS) $(ADOC_REQS) $(ADOC_TARGET)

# FILES=$(shell find ./docs/adoc/ -maxdepth 2 -mindepth 2 -type f -name '*.adoc' 2>/dev/null)
FILES_ADOC:=$(shell ls ./docs/adoc/*.adoc 2>/dev/null)
FILES_PLAIN:=$(subst ./docs/adoc/,,$(basename $(FILES_ADOC)))
FILES_HTML:=$(addsuffix .html, $(addprefix ./static/$(PRJ)/$(TAG)/,$(FILES_PLAIN)))
FILES_PDF:=$(addsuffix .pdf, $(addprefix ./static/$(PRJ)/$(TAG)/,$(FILES_PLAIN)))
FILES_EPUB:=$(addsuffix .epub, $(addprefix ./static/$(PRJ)/$(TAG)/,$(FILES_PLAIN)))

FILES:=$(basename $(FILES))
FILES:=$(subst ./docs/adoc/,,$(FILES))

.PHONY: test
test: $(FILES_PLAIN)
	# $(FILES_ADOC)
	# $(FILES_PLAIN)
	# $(FILES_HTML)
	# $(FILES_PDF)
	# $(FILES_EPUB)
	# $(FILES)
	@for target in $(FILES); do \
	echo ""; \
	echo "INFO: processing $$target"; \
	OUT=$(subst ./docs/adoc/,./static/$(PRJ)/$(TAG)/,$$target); \
	MD=$$target.md; \
	PDF=$$OUT.pdf; \
	EPUB=$$OUT.epub; \
	HTML=$$OUT.html; \
	echo $$MD $$PDF $$HTML $$EPUB; \
	done

.PHONY: $(FILES_PLAIN)
$(FILES_PLAIN):
	$(ADOC_CMD) $(ADOC_OPTION) $(ADOC_ATTRS) $(ADOC_REQS) -o ./static/$(PRJ)/$(TAG)/$@.html ./docs/adoc/$@.adoc
	$(ADOC_CMD_PDF) $(ADOC_OPTION) $(ADOC_ATTRS) $(ADOC_REQS) -o ./static/$(PRJ)/$(TAG)/$@.pdf ./docs/adoc/$@.adoc
	$(ADOC_CMD_EPUB) $(ADOC_OPTION) $(ADOC_ATTRS) $(ADOC_REQS) -o ./static/$(PRJ)/$(TAG)/$@.epub ./docs/adoc/$@.adoc
	mkdir -p ./content/$(PRJ)/$(TAG)/
	export DATE=$(shell git for-each-ref --format="%(taggerdate:short)" refs/tags/$(TAG)) ;\
	export PRJ=$(PRJ) ;\
	export TAG=$(TAG) ;\
	export STATUS=$(STATUS) ;\
	export URL_HTML=/$(PRJ)/$(TAG)/$@.html ;\
	export URL_PDF=/$(PRJ)/$(TAG)/$@.pdf ;\
	export URL_EPUB=/$(PRJ)/$(TAG)/$@.epub ;\
	export PATH_HTML=static/$(PRJ)/$(TAG)/$@.html ;\
	export PATH_PDF=static/$(PRJ)/$(TAG)/$@.pdf ;\
	export PATH_EPUB=static/$(PRJ)/$(TAG)/$@.epub ;\
	envsubst < ./template.md > ./content/$(PRJ)/$(TAG)/$@.md
