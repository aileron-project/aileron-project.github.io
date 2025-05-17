PRJ ?= aileron-test
TAG ?= v0.0.1
DATE ?= 2025-05-13

# Resource directories.
STATIC_DIR := static/$(PRJ)/$(TAG)/
CONTENT_DIR := content/$(PRJ)/$(TAG)/
WEBSITE_DIR := $(PRJ)/docs/website/

# Generate file paths.
WD_MDs := $(shell find $(WEBSITE_DIR) -type f -name '*.md' 2>/dev/null)
CD_MDs := $(patsubst $(WEBSITE_DIR)%,$(CONTENT_DIR)%,$(WD_MDs))
WD_IMGs := $(shell find $(WEBSITE_DIR) -type f -name '*.svg' -or -name '*.png' 2>/dev/null)
SD_IMGs := $(patsubst $(WEBSITE_DIR)%,$(STATIC_DIR)%,$(WD_IMGs))
WD_INDEXs := $(shell find $(WEBSITE_DIR) -maxdepth 1 -type f -name '*.md' 2>/dev/null)
CD_INDEXs := $(patsubst $(WEBSITE_DIR)%,$(CONTENT_DIR)%,$(WD_INDEXs))

.PHONY: init
init:
	mkdir -p $(CONTENT_DIR)
	mkdir -p $(STATIC_DIR)

.PHONY: clear
clear:
	rm -rf $(CONTENT_DIR)
	rm -rf $(STATIC_DIR)

.DEFAULT_GOAL:=build
.PHONY: build
build: init $(CD_MDs) $(SD_IMGs)
	# ${CD_INDEXs}
	@for index in ${CD_INDEXs}; do \
	echo "substitute env $$index"; \
	DATE=$(DATE) PRJ=$(PRJ) TAG=$(TAG) envsubst < $$index > subst.tmp; \
	mv subst.tmp $$index; \
	done

$(CONTENT_DIR)%.md: $(WEBSITE_DIR)%.md
	@mkdir -p $(dir $@)
	cp $< $@

$(STATIC_DIR)%.svg: $(WEBSITE_DIR)%.svg
	@mkdir -p $(dir $@)
	cp $< $@

$(STATIC_DIR)%.png: $(WEBSITE_DIR)%.png
	@mkdir -p $(dir $@)
	cp $< $@
