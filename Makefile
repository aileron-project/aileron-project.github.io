
# See the package.json of the docsy to check minimum hugo version.
# https://github.com/google/docsy/blob/main/package.json
HUGO_VERSION:=0.147.3
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


PRJ:=aileron-test
TAG=v0.0.1
DATE=$(shell git for-each-ref --format="%(taggerdate:short)" refs/tags/$(TAG))
STATIC_DIR := static/$(PRJ)/$(TAG)/
CONTENT_DIR := content/$(PRJ)/$(TAG)/
WEBSITE_DIR := $(PRJ)/docs/website/

WD_MDS := $(shell find $(WEBSITE_DIR) -maxdepth 1 -type f -name '*.md' 2>/dev/null)
CD_MDS := $(patsubst $(WEBSITE_DIR)%,$(CONTENT_DIR)%,$(WD_MDS))

WD_ADOCS := $(shell find $(WEBSITE_DIR) -maxdepth 1 -type f -name '*.adoc' 2>/dev/null)
WD_HTMLS := $(WD_ADOCS:.adoc=.html)
WD_PDFS := $(WD_ADOCS:.adoc=.pdf)
WD_EPUBS := $(WD_ADOCS:.adoc=.epub)
SD_ADOCS := $(patsubst $(WEBSITE_DIR)%,$(STATIC_DIR)%,$(WD_ADOCS))
SD_HTMLS := $(patsubst $(WEBSITE_DIR)%,$(STATIC_DIR)%,$(WD_HTMLS))
SD_PDFS := $(patsubst $(WEBSITE_DIR)%,$(STATIC_DIR)%,$(WD_PDFS))
SD_EPUBS := $(patsubst $(WEBSITE_DIR)%,$(STATIC_DIR)%,$(WD_EPUBS))
CD_ADOCS := $(patsubst $(WEBSITE_DIR)%,$(CONTENT_DIR)%,$(WD_ADOCS))
CD_GEN_MDS := $(CD_ADOCS:.adoc=.md)

ADOC_OPTION ?=
ADOC_ATTRS += experimental reproducible data-uri stem=asciimath toc=none sectnums doctype=book source-highlighter=highlightjs
ADOC_ATTRS += imagesoutdir=_output/tmp/
ADOC_ATTRS += cachedir=_output/.asciidoctor/
ADOC_ATTRS += diagram-cachedir=_output/.asciidoctor/
# ADOC_ATTRS += stylesheet=/scss/main.css linkcss
ADOC_ATTRS := $(addprefix --attribute=,$(ADOC_ATTRS))
# ADOC_EPUB_REQS ?= asciidoctor-diagram asciidoctor-lists asciidoctor-mathematical

ADOC_REQS ?= asciidoctor-diagram asciidoctor-lists asciidoctor-mathematical
ADOC_REQS := $(addprefix --require=,$(ADOC_REQS))

.PHONY: init
init:
	mkdir -p $(CONTENT_DIR)
	mkdir -p $(STATIC_DIR)

.PHONY: clear
clear:
	rm -rf $(CONTENT_DIR)
	rm -rf $(STATIC_DIR)

.PHONY: build
build: init $(CD_GEN_MDS) $(SD_HTMLS) $(SD_PDFS) $(SD_EPUBS) $(CD_MDS)
	rm -rf $(STATIC_DIR)images $(CONTENT_DIR)_index.*.md
	test -e $(WEBSITE_DIR)images && cp -r $(WEBSITE_DIR)images $(STATIC_DIR)images
	DATE=$(DATE) PRJ=$(PRJ) TAG=$(TAG) envsubst < ./template._index.md > $(CONTENT_DIR)_index.en.md
	DATE=$(DATE) PRJ=$(PRJ) TAG=$(TAG) envsubst < ./template._index.md > $(CONTENT_DIR)_index.ja.md

$(CONTENT_DIR)%.md: $(WEBSITE_DIR)%.adoc
	@echo ""
	export DATE=$(DATE) ;\
	export PRJ=$(PRJ) ;\
	export TAG=$(TAG) ;\
	export TITLE=$(basename $(basename $(notdir $@))) ;\
	export URL_HTML=/$(PRJ)/$(TAG)/$(basename $(notdir $@)).html ;\
	export URL_PDF=/$(PRJ)/$(TAG)/$(basename $(notdir $@)).pdf ;\
	export URL_EPUB=/$(PRJ)/$(TAG)/$(basename $(notdir $@)).epub ;\
	export PATH_HTML=$(STATIC_DIR)$(basename $(notdir $@)).html ;\
	envsubst < ./template.md > $@

$(CONTENT_DIR)%.md: $(WEBSITE_DIR)%.md
	cp $< $@

$(WEBSITE_DIR)%.html: $(WEBSITE_DIR)%.adoc
	@echo ""
	asciidoctor $(ADOC_OPTION) $(ADOC_ATTRS) $(ADOC_REQS) -o $@ $<

$(STATIC_DIR)%.html: $(WEBSITE_DIR)%.html
	cp $< $@

$(WEBSITE_DIR)%.pdf: $(WEBSITE_DIR)%.adoc
	@echo ""
	asciidoctor-pdf $(ADOC_OPTION) $(ADOC_ATTRS) $(ADOC_REQS) -o $@ $<

$(STATIC_DIR)%.pdf: $(WEBSITE_DIR)%.pdf
	cp $< $@

$(WEBSITE_DIR)%.epub: $(WEBSITE_DIR)%.adoc
	@echo ""
	asciidoctor-epub3 $(ADOC_OPTION) $(ADOC_ATTRS) $(ADOC_REQS) -o $@ $<

$(STATIC_DIR)%.epub: $(WEBSITE_DIR)%.epub
	cp $< $@
