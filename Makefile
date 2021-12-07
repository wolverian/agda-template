SRC_DIR := src
OUT_DIR := html

html_src := index.html header.html
html_dst := $(foreach html,$(html_src),$(OUT_DIR)/$(notdir $(html)))

js_src := highlight-hover.js
js_dst := $(foreach $(js),$(js_src),$(OUT_DIR)/$(js))

agda_src := $(wildcard $(SRC_DIR)/*.lagda.md)
agda_dst := $(patsubst $(SRC_DIR)/%.lagda.md,$(OUT_DIR)/%.md,$(agda_src))

md_src := $(agda_dst)
md_dst := $(patsubst %.md,%.html,$(md_src))

fonts_src := $(wildcard fonts/*.otf)
fonts_dst := $(foreach font,$(fonts_src),$(OUT_DIR)/fonts/$(notdir $(font)))

styles_src := $(wildcard styles/*.css)
styles_dst := $(foreach style,$(styles_src),$(OUT_DIR)/$(notdir $(style)))

AGDA := agda
AGDA_FLAGS := \
	--html \
	--html-highlight=auto \
	--highlight-occurrences \
	--html-dir=$(OUT_DIR)

PANDOC := pandoc
PANDOC_FLAGS := \
	--to=html5 \
	--standalone \
	--section-divs \
	--katex \
	$(foreach s,$(styles_src),--css=$(notdir $(s))) \
	--include-in-header=header.html

.PHONY: all
all: $(md_dst) $(html_dst) $(js_dst) $(agda_dst) $(styles_dst) $(fonts_dst)

$(OUT_DIR)/%.md: $(SRC_DIR)/%.lagda.md
	$(AGDA) $(AGDA_FLAGS) $<

$(OUT_DIR)/%.html: $(OUT_DIR)/%.md $(styles_dst) $(fonts_dst)
	$(PANDOC) $(PANDOC_FLAGS) -o $@ $<

$(OUT_DIR)/fonts/%.otf: fonts/%.otf
	@mkdir -p $(OUT_DIR)/fonts
	cp $< $@

$(OUT_DIR)/%.css: styles/%.css
	@mkdir -p $(OUT_DIR)
	cp $< $@

$(OUT_DIR)/header.html: header.html
	@mkdir -p $(OUT_DIR)
	cp $< $@

$(OUT_DIR)/index.html: index.md
	@mkdir -p $(OUT_DIR)
	$(PANDOC) $(PANDOC_FLAGS) -o $@ $<

$(OUT_DIR)/%.js: %.js
	@mkdir -p $(OUT_DIR)
	cp $< $@
