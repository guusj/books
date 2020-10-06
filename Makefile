# Makefile for creating EPUB, MOBI, PDF and DOCX versions from a markdown original.
# The conversion is performed by Calibre's ebook-convert program. You may prefer other programs like pandoc.
#
# Options (usage eg "make COVERFILE=mycover.jpg"):
#  REVISION=rev1            Define revision number (default: retrieve from VERSION, otherwise rev1)
#  COVERFILE=file.jpg       Define cover picture, either picture file or none
#                           (default: Warbreaker_BrandonSanderson_cover.jpg if present)
#
# Notes:
# - For some reason the temporary files are not always removed reliably (Windows 10, MSYS2). This is 
#   a minor annoyance so it is not fixed yet. Just type "make cleantmp" to remove these files.

ifeq (,$(REVISION))
ifeq (,$(wildcard VERSION))
REVISION := rev1
else
REVISION := $(strip $(shell cat VERSION))
endif
endif
ORGNAME := Warbreaker_hardcover_1st_ed.pdf
BOOKNAME := Warbreaker_BrandonSanderson
IMGFILES := warbreaker-map.png
DEFAULTCOVER := $(BOOKNAME)_cover.jpg
EBOOKCNV := ebook-convert
INMARKDOWN := $(BOOKNAME).md
OUTEPUB := $(BOOKNAME)-$(REVISION).epub
OUTMOBI := $(BOOKNAME)-$(REVISION).mobi
OUTLIT := $(BOOKNAME)-$(REVISION).lit
OUTDOCX := $(BOOKNAME)-$(REVISION).docx
OUTRTF := $(BOOKNAME)-$(REVISION).rtf
OUTPDF := $(BOOKNAME)-$(REVISION).pdf
OUTHTML := $(BOOKNAME)-html-$(REVISION).zip
METADATAOPTS := --title "Warbreaker" --authors "Brandon Sanderson" --author-sort "Sanderson, Brandon" --isbn 9780765320308 --language en --publisher "Tor Books" --pubdate "june 2009" --tags "Fiction, Fantasy, Epic, Action & Adventure, General" --max-toc-links 0
INMDOPTS := --input-encoding utf-8 --formatting-type markdown --paragraph-type off --markdown-extensions footnotes,nl2br,tables,toc
OUTEPUBOPTS := --epub-version 2
OUTMOBIOPTS := 
OUTLITOPTS := 
OUTDOCXOPTS := --docx-page-size a4 --docx-no-toc --docx-no-cover
OUTRTFOPTS :=
OUTPDFOPTS := --paper-size a4 --pdf-footer-template '<p style="text-align:center">Page _PAGENUM_</p>' --pdf-header-template '<div style="font-size:x-small"><p style="float:left">_TITLE_</p><p style="float:right;"><i>_AUTHOR_</i></p></div>' --pdf-hyphenate --preserve-cover-aspect-ratio
OUTHTMLOPTS :=
INORGOPTS := 
OUTMDOPTS := --keep-image-references --keep-links --max-line-length 0 --newline unix --txt-output-encoding utf-8 --txt-output-formatting markdown
ifeq (,$(COVERFILE))
COVERFILE := $(DEFAULTCOVER)
endif
ifeq (none,$(COVERFILE))
COVERFILE :=
endif
ifneq (,$(COVERFILE))
METADATAOPTS += --cover $(COVERFILE)
TMPFILES = $(wildcard index-*.html) $(wildcard $(addsuffix -*.*,$(basename $(IMGFILES)))) $(wildcard $(basename $(COVERFILE))-*.*)
else
TMPFILES = $(wildcard index-*.html) $(wildcard $(addsuffix -*.*,$(basename $(IMGFILES))))
endif

all: $(OUTEPUB) $(OUTMOBI) $(OUTDOCX) $(OUTPDF) $(OUTHTML)

epub: $(OUTEPUB)

mobi: $(OUTMOBI)

lit: $(OUTLIT)

docx: $(OUTDOCX)

rtf: $(OUTRTF)

pdf: $(OUTPDF)

html: $(OUTHTML)

$(OUTEPUB): $(INMARKDOWN)
	$(EBOOKCNV) $< $@ $(METADATAOPTS) $(INMDOPTS) $(OUTEPUBOPTS)
	@rm -f $(TMPFILES)

$(OUTMOBI): $(INMARKDOWN)
	$(EBOOKCNV) $< $@ $(METADATAOPTS) $(INMDOPTS) $(OUTMOBIOPTS)
	@rm -f $(TMPFILES)

$(OUTLIT): $(INMARKDOWN)
	$(EBOOKCNV) $< $@ $(METADATAOPTS) $(INMDOPTS) $(OUTLITOPTS)
	@rm -f $(TMPFILES)

$(OUTDOCX): $(INMARKDOWN)
	$(EBOOKCNV) $< $@ $(METADATAOPTS) $(INMDOPTS) $(OUTDOCXOPTS)
	@rm -f $(TMPFILES)

# RTF seems quite useless: worse than DOCX, even for eg LibreOffice
$(OUTRTF): $(INMARKDOWN)
	$(EBOOKCNV) $< $@ $(METADATAOPTS) $(INMDOPTS) $(OUTRTFOPTS)
	@rm -f $(TMPFILES)

$(OUTPDF): $(INMARKDOWN)
	$(EBOOKCNV) $< $@ $(METADATAOPTS) $(INMDOPTS) $(OUTPDFOPTS)
	@rm -f $(TMPFILES)

# Note: HTML output is a ZIP file, not the expected HTML file(s)
$(OUTHTML): $(INMARKDOWN)
	$(EBOOKCNV) $< $@ $(METADATAOPTS) $(INMDOPTS) $(OUTHTMLOPTS)
	@rm -f $(TMPFILES)

# This can be used as the first step for converting the original file to markdown.
# Expect that serious editing will be needed before the generated markdown file is 
# useful as an original for the destined output files.
test.md: $(ORGNAME)
	$(EBOOKCNV) $< $(addsuffix .txt,$(basename $@)) $(INORGOPTS) $(OUTMDOPTS)
	mv -f $(addsuffix .txt,$(basename $@)) $@

# This can be used to retrieve the images from the original file.
test.zip: $(ORGNAME)
	$(EBOOKCNV) $< $@ $(INORGOPTS) $(OUTHTMLOPTS)

releasebin: $(OUTEPUB) $(OUTMOBI) $(OUTDOCX) $(OUTPDF) $(OUTHTML)
	zip -9 $(BOOKNAME)-$(REVISION).zip $^ LICENSE README.md Changelog

releasesrc:
	zip -9 $(BOOKNAME)-$(REVISION)-src.zip $(INMARKDOWN) $(IMGFILES) $(DEFAULTCOVER) LICENSE README.md Makefile Changelog VERSION

release: releasebin releasesrc

cleantmp:
	rm -f $(TMPFILES)

clean: cleantmp
	rm -f $(OUTEPUB) $(OUTMOBI) $(OUTLIT) $(OUTDOCX) $(OUTRTF) $(OUTPDF) $(OUTHTML)

cleanall: clean
	rm -f $(BOOKNAME)-$(REVISION).zip $(BOOKNAME)-$(REVISION)-src.zip

