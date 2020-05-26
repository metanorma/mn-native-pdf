#!make
ifeq ($(OS),Windows_NT)
SHELL := cmd
else
SHELL := /bin/bash
endif
SRCDIR := sources
DESTDIR := documents
SRC := $(patsubst mn-samples-iso/documents/amendment/%,sources/iso-%,$(wildcard mn-samples-iso/documents/amendment/*.xml)) \
	$(patsubst mn-samples-iso/documents/international-standard/%,sources/%,$(wildcard mn-samples-iso/documents/international-standard/*.xml)) \
	$(patsubst mn-samples-itu/documents/%,sources/itu-%,$(wildcard mn-samples-itu/documents/*.xml)) \
	$(patsubst mn-samples-iec/documents/%,sources/%,$(wildcard mn-samples-iec/documents/*.xml)) \
	$(patsubst mn-samples-ogc/documents/%,sources/ogc-%,$(wildcard mn-samples-ogc/documents/*.xml)) \
	$(patsubst mn-samples-un/documents/%,sources/un-%,$(wildcard mn-samples-un/documents/*.xml)) \
	$(patsubst mn-samples-cc/documents/%,sources/%,$(wildcard mn-samples-cc/documents/*.xml)) \
	$(patsubst mn-samples-m3aawg/documents/%,sources/m3a-%,$(wildcard mn-samples-m3aawg/documents/*.xml)) \
	$(patsubst mn-samples-cc/documents/%,sources/%,$(wildcard mn-samples-cc/documents/*.xml)) \
	$(patsubst mn-samples-gb/documents/%,sources/gb-%,$(wildcard mn-samples-gb/documents/*.xml))

PDF := $(patsubst sources/%,documents/%,$(patsubst %.xml,%.pdf,$(SRC)))
HTML := $(patsubst sources/%,documents/%,$(patsubst %.xml,%.html,$(SRC)))
DOC := $(patsubst sources/%,documents/%,$(patsubst %.xml,%.doc,$(SRC)))
RXL := $(patsubst sources/%,documents/%,$(patsubst %.xml,%.rxl,$(SRC)))
XSLT_PATH_BASE := ${CURDIR}/xslt
XSLT_GENERATED := xslt/iec.international-standard.xsl \
	xslt/iso.international-standard.xsl \
	xslt/itu.recommendation.xsl \
	xslt/itu.recommendation-annex.xsl \
	xslt/itu.resolution.xsl \
	xslt/ogc.abstract-specification-topic.xsl \
	xslt/ogc.best-practice.xsl \
	xslt/ogc.change-request-supporting-document.xsl \
	xslt/ogc.community-practice.xsl \
	xslt/ogc.community-standard.xsl \
	xslt/ogc.discussion-paper.xsl \
	xslt/ogc.engineering-report.xsl \
	xslt/ogc.other.xsl \
	xslt/ogc.policy.xsl \
	xslt/ogc.reference-model.xsl \
	xslt/ogc.release-notes.xsl \
	xslt/ogc.standard.xsl \
	xslt/ogc.test-suite.xsl \
	xslt/ogc.user-guide.xsl \
	xslt/ogc.white-paper.xsl \
	xslt/un.plenary.xsl \
	xslt/un.plenary-attachment.xsl \
	xslt/un.recommendation.xsl \
	xslt/csd.standard.xsl \
	xslt/csa.standard.xsl \
	xslt/rsd.standard.xsl \
	xslt/m3d.report.xsl \
	xslt/gb.recommendation.xsl

MN2PDF_DOWNLOAD_PATH := https://github.com/metanorma/mn2pdf/releases/download/v1.16/mn2pdf-1.16.jar
# MN2PDF_DOWNLOAD_PATH := https://maven.pkg.github.com/metanorma/mn2pdf/com/metanorma/fop/mn2pdf/1.7/mn2pdf-1.7.jar

all: xslts documents.html

xslts: $(XSLT_GENERATED)

mn2pdf.jar:
	curl -sSL --user ${GITHUB_USERNAME}:${GITHUB_TOKEN} ${MN2PDF_DOWNLOAD_PATH} -o mn2pdf.jar

xalan/xalan.jar:
ifeq ($(OS),Windows_NT)
	curl -sSL http://archive.apache.org/dist/xalan/xalan-j/binaries/xalan-j_2_7_2-bin-2jars.zip -o $(TMP)/xalan.zip
	unzip -p $(TMP)/xalan.zip xalan-j_2_7_2/serializer.jar > xalan\serializer.jar
	unzip -p $(TMP)/xalan.zip xalan-j_2_7_2/xalan.jar > xalan\xalan.jar
	unzip -p $(TMP)/xalan.zip xalan-j_2_7_2/xercesImpl.jar > xalan\xercesImpl.jar
	unzip -p $(TMP)/xalan.zip xalan-j_2_7_2/xml-apis.jar > xalan\xml-apis.jar
	unzip -p $(TMP)/xalan.zip xalan-j_2_7_2/xsltc.jar > xalan\xsltc.jar
else
	pushd xalan; \
	TMPDIR=$$(mktemp -d); \
	curl -sSL http://archive.apache.org/dist/xalan/xalan-j/binaries/xalan-j_2_7_2-bin-2jars.tar.gz -o $$TMPDIR/xalan.tar.gz; \
	tar xz --strip-components=1 -f $$TMPDIR/xalan.tar.gz xalan-j_2_7_2/{serializer,xalan,xercesImpl,xml-apis,xsltc}.jar; \
	popd
endif

sources/iso-%: mn-samples-iso/documents/international-standard/iso-% mn-samples-iso/documents/amendment/%
	cp $< $@

sources/iec-%: mn-samples-iec/documents/iec-%
	cp $< $@

sources/itu-%: mn-samples-itu/documents/%
	cp $< $@

sources/un-%: mn-samples-un/documents/%
	cp $< $@

sources/ogc-%: mn-samples-ogc/documents/%
	cp $< $@

sources/cc-%: mn-samples-cc/documents/cc-%
	cp $< $@

sources/m3a-%: mn-samples-m3aawg/documents/%
	cp $< $@

sources/gb-%: mn-samples-gb/documents/%
	cp $< $@

documents:
	mkdir -p $@

documents/%.html: sources/%.html | documents
	cp $< $@

documents/%.doc: sources/%.doc | documents
	cp $< $@

documents/%.rxl: sources/%.rxl | documents
	cp $< $@

documents/%.xml: sources/%.xml | documents
	cp $< $@


#documents/itu-T-REC-A.8-200810-I!!MSW-E.pdf:
#	echo "### skipping $@"

# This document is currently broken
#un.agenda.xsl required
documents/un-ECE_AGAT_2020_INF1.pdf:
	echo "### skipping $@"

#documents/itu-Z.100-201811-AnnF1.pdf:
#	echo "### skipping $@"

documents/%.pdf: sources/%.xml mn2pdf.jar | documents
ifeq ($(OS),Windows_NT)
	powershell -Command "$$doc = [xml](Get-Content $<); $$doc.SelectNodes(\"*\").get_name()" | cut -d "-" -f 1 > MN_FLAVOR.txt
	powershell -Command "$$doc = [xml](Get-Content $<); $$doc.SelectNodes(\"//*[local-name()='doctype']\").'#text'" > DOCTYPE.txt
	cmd /V /C "set /p MN_FLAVOR=<MN_FLAVOR.txt & set /p DOCTYPE=<DOCTYPE.txt & java -Xss5m -Xmx1024m -jar mn2pdf.jar --xml-file $< --xsl-file ${XSLT_PATH_BASE}/!MN_FLAVOR!.!DOCTYPE!.xsl --pdf-file $@"
else
	FILENAME=$<; \
	MN_FLAVOR=$$(xmllint --xpath 'name(*)' $${FILENAME} | cut -d '-' -f 1); \
	DOCTYPE=$$(xmllint --xpath "//*[local-name()='doctype']/text()" $${FILENAME}); \
	XSLT_PATH=${XSLT_PATH_BASE}/$${MN_FLAVOR}.$${DOCTYPE}.xsl; \
	java -Xss5m -Xmx1024m -jar mn2pdf.jar --xml-file $$FILENAME --xsl-file $$XSLT_PATH --pdf-file $@
endif

xslt/%.xsl: xslt_src/%.core.xsl xslt_src/merge.xsl xalan/xalan.jar
	java -jar xalan/xalan.jar -IN $< -XSL xslt_src/merge.xsl -OUT $@

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
	rm -f $(XSLT_GENERATED)
	rm -rf documents

update-init:
	git submodule update --init

update-modules:
	git submodule foreach git fetch origin gh-pages
	git submodule foreach git reset --hard origin/gh-pages

publish: published
published: documents.html
	mkdir published && \
	cp -a documents $@/ && \
	cp $< published/index.html
ifeq ($(OS),Windows_NT)
	if exist "images" ( cp -a images published )
else
	if [ -d "images" ]; then cp -a images published; fi
endif

.PHONY: all clean update-init update-modules bundle publish xslts
