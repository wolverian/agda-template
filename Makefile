SRC_DIR := src
OUTPUT_DIR := html

AGDA := agda
AGDA_FLAGS := \
	--html \
	--html-highlight=auto \
	--highlight-occurrences \
	--html-dir=$(OUTPUT_DIR)

PANDOC := pandoc
PANDOC_FLAGS := \
	--to=html5 \
	--standalone \
	--section-divs \
	--katex \
	--css=pandoc.css \
	--css=style.css \
	--include-in-header=header.html

FONTS_SRC := $(wildcard fonts/*.otf)
FONTS_DST := $(foreach font,$(FONTS_SRC),$(OUTPUT_DIR)/fonts/$(notdir $(font)))

STYLES_SRC := $(wildcard styles/*.css)
STYLES_DST := $(foreach style,$(STYLES_SRC),$(OUTPUT_DIR)/$(notdir $(style)))

.PHONY: all
all: \
	$(OUTPUT_DIR)/index.html \
	$(OUTPUT_DIR)/header.html \
	$(OUTPUT_DIR)/UCC.html \
	$(STYLES_DST) \
	$(FONTS_DST)

$(OUTPUT_DIR)/%.md: $(SRC_DIR)/%.lagda.md
	$(AGDA) $(AGDA_FLAGS) $<

$(OUTPUT_DIR)/%.html: $(OUTPUT_DIR)/%.md $(STYLES_DST) $(FONTS_DST)
	$(PANDOC) $(PANDOC_FLAGS) -o $@ $<

$(OUTPUT_DIR)/fonts/%.otf: fonts/%.otf
	@mkdir -p $(OUTPUT_DIR)/fonts
	cp $< $@

$(OUTPUT_DIR)/%.css: styles/%.css
	@mkdir -p $(OUTPUT_DIR)
	cp $< $@

$(OUTPUT_DIR)/header.html: header.html
	@mkdir -p $(OUTPUT_DIR)
	cp $< $@

$(OUTPUT_DIR)/index.html: index.md
	@mkdir -p $(OUTPUT_DIR)
	$(PANDOC) $(PANDOC_FLAGS) -o $@ $<
