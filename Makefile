#!make
SHELL := /bin/bash
SRCDIR := sources
DESTDIR := documents
SRC := $(patsubst mn-samples-iso/documents/%,sources/%,$(wildcard mn-samples-iso/documents/*.xml)) \
	$(patsubst mn-samples-iec/documents/%,sources/%,$(wildcard mn-samples-iec/documents/*.xml)) \
	$(patsubst mn-samples-itu/documents/%,sources/itu-%,$(wildcard mn-samples-itu/documents/*.xml))
PDF := $(patsubst sources/%,documents/%,$(patsubst %.xml,%.pdf,$(SRC)))
XSLT_PATH_BASE := $(shell pwd)/xslt/mn-FOO.xsl
XML2PDF_PATH :=  $(shell pwd)/xml2pdf

ifdef MN_PDF_FONT_PATH
	MN_PDF_FONT_PATH := $(MN_PDF_FONT_PATH)
else
	MN_PDF_FONT_PATH := $(pwd)/fonts
endif

all: $(PDF)

documents:
	mkdir -p $@

sources/iso-%.xml: mn-samples-iso/documents/iso-%.xml
	cp $< $@

sources/itu-%.xml: mn-samples-itu/documents/%.xml
	cp $< $@

sources/iec-%.xml: mn-samples-iso/documents/iec-%.xml
	cp $< $@

documents/%.pdf: sources/%.xml pdf_fonts_config.xml documents
	FILENAME=$<; \
	OUTFILE=$@; \
	MN_FLAVOR=$$(grep -o '<[a-z]*-standard' $$FILENAME | tr -d '<' | cut -d '-' -f 1); \
	XSLT_PATH_BASE=${XSLT_PATH_BASE}; \
	XSLT_PATH=$${XSLT_PATH_BASE/FOO/$${MN_FLAVOR}}; \
  (cd ${XML2PDF_PATH} && mvn clean compile exec:java -Dexec.args="../pdf_fonts_config.xml ../$$FILENAME $$XSLT_PATH ../$$OUTFILE")
#  fop -c pdf_fonts_config.xml -xml $$FILENAME -xsl $$XSLT_PATH -foout $$OUTFILE.xml; \
#  fop -c pdf_fonts_config.xml -fo $$OUTFILE.xml -out application/pdf $$OUTFILE

pdf_fonts_config.xml: pdf_fonts_config.xml.in
	MN_PDF_FONT_PATH=${MN_PDF_FONT_PATH}; \
	envsubst < pdf_fonts_config.xml.in > pdf_fonts_config.xml

clean:
	rm -f pdf_fonts_config.xml
	rm -rf documents

update-init:
	git submodule update --init

update-modules:
	git submodule foreach git pull origin gh-pages

.PHONY: all clean update-init update-modules
