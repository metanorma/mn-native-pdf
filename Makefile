#!make
SHELL := /bin/bash
SRCDIR := sources
DESTDIR := documents
SRC := $(patsubst mn-samples-iso/documents/%,sources/%,$(wildcard mn-samples-iso/documents/*.xml)) \
	$(patsubst mn-samples-itu/documents/%,sources/itu-%,$(wildcard mn-samples-itu/documents/*.xml)) \
	$(patsubst mn-samples-iec/documents/%,sources/%,$(wildcard mn-samples-iec/documents/*.xml)) \
	$(patsubst mn-samples-ogc/documents/%,sources/ogc-%,$(wildcard mn-samples-ogc/documents/*.xml)) \
	$(patsubst mn-samples-un/documents/%,sources/un-%,$(wildcard mn-samples-un/documents/*.xml))
PDF := $(patsubst sources/%,documents/%,$(patsubst %.xml,%.pdf,$(SRC)))
HTML := $(patsubst sources/%,documents/%,$(patsubst %.xml,%.html,$(SRC)))
DOC := $(patsubst sources/%,documents/%,$(patsubst %.xml,%.doc,$(SRC)))
RXL := $(patsubst sources/%,documents/%,$(patsubst %.xml,%.rxl,$(SRC)))
XSLT_PATH_BASE := $(shell pwd)/xslt
XSLT_GENERATED := xslt/iec.international-standard.xsl \
	xslt/iso.international-standard.xsl \
	xslt/itu.recommendation.xsl \
	xslt/itu.resolution.xsl \
	xslt/ogc.community-standard.xsl \
	xslt/ogc.engineering-report.xsl \
	xslt/ogc.policy.xsl \
	xslt/ogc.reference-model.xsl \
	xslt/ogc.release-notes.xsl \
	xslt/ogc.standard.xsl \
	xslt/ogc.user-guide.xsl \
	xslt/ogc.test-suite.xsl \
	xslt/un.plenary.xsl \
	xslt/un.recommendation.xsl

MN2PDF_DOWNLOAD_PATH := https://github.com/metanorma/mn2pdf/releases/download/v1.4/mn2pdf-1.4.jar

#ifdef MN_PDF_FONT_PATH
#	MN_PDF_FONT_PATH := $(MN_PDF_FONT_PATH)
#else
#	MN_PDF_FONT_PATH := $(pwd)/fonts
#endif

all: xslts documents.html

xslts: $(XSLT_GENERATED)

mn2pdf.jar:
	curl -sSL ${MN2PDF_DOWNLOAD_PATH} -o mn2pdf.jar

xalan/xalan.jar:
	pushd xalan; \
	TMPDIR=$$(mktemp -d); \
	curl -sSL http://archive.apache.org/dist/xalan/xalan-j/binaries/xalan-j_2_7_2-bin-2jars.tar.gz -o $$TMPDIR/xalan.tar.gz; \
	tar xz --strip-components=1 -f $$TMPDIR/xalan.tar.gz xalan-j_2_7_2/{serializer,xalan,xercesImpl,xml-apis,xsltc}.jar; \
	popd

sources/iso-%: mn-samples-iso/documents/iso-%
	cp $< $@

sources/iec-%: mn-samples-iec/documents/iec-%
	cp $< $@

sources/itu-%: mn-samples-itu/documents/%
	cp $< $@

sources/un-%: mn-samples-un/documents/%
	cp $< $@

sources/ogc-%: mn-samples-ogc/documents/%
	cp $< $@

documents:
	mkdir -p $@

documents/%: sources/% | documents
	cp $< $@

# This document is currently broken
documents/itu-D-REC-D.19-201003-E.pdf:
	echo "### skipping $@"

documents/itu-T-Editing-Guidelines-201602.pdf:
	echo "### skipping $@"

documents/itu-T-REC-A.8-200810-I!!MSW-E.pdf:
	echo "### skipping $@"

documents/itu-Z.100-201811-AnnF1.pdf:
	echo "### skipping $@"

documents/%.pdf: sources/%.xml mn2pdf.jar | documents
	FILENAME=$<; \
	OUTFILE=$@; \
	MN_FLAVOR=$$(xmllint --xpath 'name(*)' $${FILENAME} | cut -d '-' -f 1); \
	DOCTYPE=$$(xmllint --xpath "//*[local-name()='doctype']/text()" $${FILENAME}); \
	XSLT_PATH=${XSLT_PATH_BASE}/$${MN_FLAVOR}.$${DOCTYPE}.xsl; \
  java -jar mn2pdf.jar --xml-file $$FILENAME --xsl-file $$XSLT_PATH --pdf-file $$OUTFILE

xslt/%.xsl: xslt_src/%.core.xsl xslt_src/merge.xsl xalan/xalan.jar
	XSLT_PATH_CORE=$<; \
	XSLT_PATH_MERGE=xslt_src/merge.xsl; \
	java -jar xalan/xalan.jar -IN $$XSLT_PATH_CORE -XSL $$XSLT_PATH_MERGE -OUT $@

documents.rxl: $(HTML) $(DOC) $(RXL) $(PDF) | bundle
	bundle exec relaton concatenate \
	  -t "mn2pdf samples" \
		-g "Metanorma" \
		documents $@

bundle:
	bundle

documents.html: documents.rxl
	bundle exec relaton xml2html documents.rxl

distclean: clean
	rm -rf xalan
	rm -f mn2pdf.jar

clean:
	rm -f xslt/*
	rm -rf documents

update-init:
	git submodule update --init

update-modules:
	git submodule foreach git pull origin gh-pages

publish: published
published: documents.html
	mkdir -p published && \
	cp -a documents $@/ && \
	cp $< published/index.html; \
	if [ -d "images" ]; then cp -a images published; fi

.PHONY: all clean update-init update-modules bundle publish xslts
