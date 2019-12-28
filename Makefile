#!make
SHELL := /bin/bash
SRCDIR := sources
DESTDIR := documents
SRC := $(patsubst mn-samples-iso/documents/%,sources/%,$(wildcard mn-samples-iso/documents/*.xml)) \
	$(patsubst mn-samples-itu/documents/%,sources/itu-%,$(wildcard mn-samples-itu/documents/*.xml)) \
	$(patsubst mn-samples-un/documents/%,sources/un-%,$(wildcard mn-samples-un/documents/*.xml))
PDF := $(patsubst sources/%,documents/%,$(patsubst %.xml,%.pdf,$(SRC)))
XSLT_PATH_BASE := $(shell pwd)/xslt
MN2PDF_DOWNLOAD_PATH := https://github.com/metanorma/mn2pdf/releases/download/v1.0.0/mn2pdf-1.0.jar

ifdef MN_PDF_FONT_PATH
	MN_PDF_FONT_PATH := $(MN_PDF_FONT_PATH)
else
	MN_PDF_FONT_PATH := $(pwd)/fonts
endif

all: $(PDF)

mn2pdf.jar:
	curl -sSL ${MN2PDF_DOWNLOAD_PATH} -o mn2pdf.jar

documents:
	mkdir -p $@

sources/iso-%.xml: mn-samples-iso/documents/iso-%.xml
	cp $< $@

sources/itu-%.xml: mn-samples-itu/documents/%.xml
	cp $< $@

sources/un-%.xml: mn-samples-un/documents/%.xml
	cp $< $@

documents/%.pdf: sources/%.xml pdf_fonts_config.xml mn2pdf.jar | documents
	FILENAME=$<; \
	OUTFILE=$@; \
	MN_FLAVOR=$$(xmllint --xpath 'name(*)' $${FILENAME} | cut -d '-' -f 1); \
	DOCTYPE=$$(xmllint --xpath "//*[local-name()='doctype']/text()" $${FILENAME}); \
	XSLT_PATH=${XSLT_PATH_BASE}/$${MN_FLAVOR}.$${DOCTYPE}.xsl; \
  java -jar mn2pdf.jar pdf_fonts_config.xml $$FILENAME $$XSLT_PATH $$OUTFILE

# This document is currently broken
documents/itu-D-REC-D.19-201003-E.pdf:

pdf_fonts_config.xml: pdf_fonts_config.xml.in
	MN_PDF_FONT_PATH=${MN_PDF_FONT_PATH}; \
	envsubst < pdf_fonts_config.xml.in > pdf_fonts_config.xml

clean:
	rm -f mn2pdf.jar pdf_fonts_config.xml
	rm -rf documents

update-init:
	git submodule update --init

update-modules:
	git submodule foreach git pull origin gh-pages

.PHONY: all clean update-init update-modules
