SOURCE = sample-markdown

TARGETS = \
	$(SOURCE).html \
	$(SOURCE).odt \
	$(SOURCE).docx \
	$(SOURCE).pdf \
	$(SOURCE).epub

TARGETS_TO_BUILD = $(filter %.html %.pdf %.odt, $(TARGETS))

ODT_TEMPLATE = custom-reference.odt

PANDOC_MARKDOWN_EXTENSIONS = --from markdown+smart+fenced_divs+smart+escaped_line_breaks+blank_before_header+header_attributes+blank_before_blockquote+line_blocks+fancy_lists+task_lists+yaml_metadata_block+strikeout+superscript+subscript+inline_code_attributes+bracketed_spans

all:
	docker run -it --rm --volume $(PWD):/data writing-tools make docker-all

docker-all:	$(TARGETS_TO_BUILD)

clean:
	rm -f $(TARGETS) *~ .*~

headings $(SOURCE).headings.md: $(SOURCE).md
	grep '^\s*#' < $< > $(SOURCE).headings.md

odt:	$(filter %.odt, $(TARGETS))
pdf:	$(filter %.pdf, $(TARGETS))
epub:	$(filter %.epub, $(TARGETS))
azw3:	$(filter %.azw3, $(TARGETS))

# %.html:	%.md %.css
# 	markdown_py $< \
# 		--extension=attr_list --extension=smarty \
# 		--extension=fenced_code --extension=sane_lists \
# 		--output_format=html5 \
# 	| perl -pe 's{<hr */>}{<div class="hr">&larr; &rarr;</div>};s{<!--.*--> *\n+'}{} > $@

%.html:	%.md %.css
	pandoc --standalone --self-contained \
		$(PANDOC_MARKDOWN_EXTENSIONS) \
		--to html5 -o $@ --css ./$*.css $<

%.odt:	%.md %.css $(ODT_TEMPLATE)
	pandoc \
		$(PANDOC_MARKDOWN_EXTENSIONS) \
		--to odt -o $@ --reference-doc $(ODT_TEMPLATE) $<

%.epub:	%.html %.css %.opf
	ebook-convert $< $@ \
		--output-profile=ipad \
		--read-metadata-from-opf=$*.opf \
		--chapter='//h:h1' \
		--chapter-mark=pagebreak \
		--start-reading-at='//*[@id="start-reading"]' \
		--level1-toc='//h:h1' \
		--smarten-punctuation \
		--disable-font-rescaling \
		--embed-font-family=Alegreya \
		--embed-all-fonts \
		--subset-embedded-fonts \
		--disable-markup-chapter-headings \
		--disable-italicize-common-cases \
		--disable-dehyphenate \
		--extra-css=$*.css \
		--language=English \
		--cover=$*-cover.png \
		--no-default-epub-cover \
		--preserve-cover-aspect-ratio \
		--pretty-print \
		--toc-title='Table of Contents' \
		--extract-to=epub

%-synopsis.pdf:	%-synopsis.md %.opf
	ebook-convert $< $@ \
		--prefer-metadata-cover \
		--remove-first-image \
		--insert-metadata \
		--read-metadata-from-opf=$*.opf \
		--markdown-extensions=meta \
		--unsmarten-punctuation \
		--disable-font-rescaling \
		--embed-font-family=Alegreya \
		--embed-all-fonts \
		--paper-size=letter \
		--minimum-line-height=140 \
		--disable-markup-chapter-headings \
		--disable-italicize-common-cases \
		--disable-dehyphenate \
		--pdf-header-template='<div style="font-size:x-small"><p style="float:left"><i>_TITLE_ </i>(Synopsis)</p><p style="float:right;"><i>_AUTHOR_</i></p></div>' \
		--pdf-footer-template='<div style="font-size:x-small"><p style="text-align: center">Page _PAGENUM_</p></div>' \
		--margin-bottom=30 \
		--margin-top=50 \
		--margin-left=60 --margin-right=60

%.pdf:	%.html %.css %.opf
	ebook-convert $< $@ \
		--output-profile=$(if $($*-OUTPUT-PROFILE),$($*-OUTPUT-PROFILE),kindle_fire) \
		--read-metadata-from-opf=$*.opf \
		--chapter='//h:h1' \
		--chapter-mark=pagebreak \
		--start-reading-at='//*[@id="start-reading"]' \
		--level1-toc='//h:h1' \
		--insert-metadata \
		--smarten-punctuation \
		--disable-font-rescaling \
		--embed-font-family=Alegreya \
		--embed-all-fonts \
		--paper-size=letter \
		--minimum-line-height=240 \
		--disable-markup-chapter-headings \
		--disable-italicize-common-cases \
		--disable-dehyphenate \
		--extra-css=$*.css \
		--cover=$*-cover.png \
		--pretty-print \
		--toc-title='Table of Contents' \
		--pdf-header-template='<div style="font-size:x-small"><p style="float:left"><i>_TITLE_ </i>(REVIEW DRAFT)</p><p style="float:right;"><i>_AUTHOR_</i></p></div>' \
		--pdf-footer-template='<div style="font-size:x-small"><p style="text-align: center">Page _PAGENUM_</p></div>' \
		--margin-bottom=30 \
		--margin-top=50 \
		--margin-left=60 --margin-right=60


