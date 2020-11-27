#!make
ifeq ($(OS),Windows_NT)
SHELL := cmd
else
SHELL := /bin/bash
endif
SRCDIR := sources
DESTDIR := documents
SRC := $(patsubst mn-samples-iso/documents/international-standard/%,sources/iso-is-%,$(wildcard mn-samples-iso/documents/international-standard/*.xml)) \
	$(patsubst mn-samples-iso/documents/amendment/%,sources/iso-amendment-%,$(wildcard mn-samples-iso/documents/amendment/*.xml)) \
	$(patsubst mn-samples-itu/documents/%,sources/itu-%,$(wildcard mn-samples-itu/documents/*.xml)) \
	$(patsubst mn-samples-iec/documents/%,sources/%,$(wildcard mn-samples-iec/documents/*.xml)) \
	$(patsubst mn-samples-ogc/documents/%,sources/ogc-%,$(wildcard mn-samples-ogc/documents/*.xml)) \
	$(patsubst mn-samples-un/documents/%,sources/un-%,$(wildcard mn-samples-un/documents/*.xml)) \
	$(patsubst mn-samples-cc/documents/%,sources/%,$(wildcard mn-samples-cc/documents/*.xml)) \
	$(patsubst mn-samples-m3aawg/documents/best-practice/%,sources/m3d-bp-%,$(wildcard mn-samples-m3aawg/documents/**/*.xml)) \
	$(patsubst mn-samples-cc/documents/%,sources/%,$(wildcard mn-samples-cc/documents/*.xml)) \
	$(patsubst mn-samples-gb/documents/%,sources/gb-%,$(wildcard mn-samples-gb/documents/*.xml)) \
	$(patsubst mn-samples-iho/documents/%,sources/iho-%,$(wildcard mn-samples-iho/documents/*.xml)) \
	$(patsubst mn-samples-mpfa/documents/%,sources/%,$(wildcard mn-samples-mpfa/documents/*.xml))
 
PDF := $(patsubst sources/%,documents/%,$(patsubst %.xml,%.pdf,$(SRC)))
HTML := $(patsubst sources/%,documents/%,$(patsubst %.xml,%.html,$(SRC)))
DOC := $(patsubst sources/%,documents/%,$(patsubst %.xml,%.doc,$(SRC)))
RXL := $(patsubst sources/%,documents/%,$(patsubst %.xml,%.rxl,$(SRC)))
XSLT_PATH_BASE := ${CURDIR}/xslt
XSLT_GENERATED := xslt/iec.international-standard.xsl \
	xslt/iec.international-standard.presentation.xsl \
	xslt/iso.international-standard.xsl \
	xslt/iso.international-standard.presentation.xsl \
	xslt/iso.amendment.xsl \
	xslt/iso.amendment.presentation.xsl \
	xslt/itu.recommendation.xsl \
	xslt/itu.recommendation.presentation.xsl \
	xslt/itu.recommendation-annex.xsl \
	xslt/itu.recommendation-annex.presentation.xsl \
	xslt/itu.technical-report.presentation.xsl \
	xslt/itu.technical-paper.presentation.xsl \
	xslt/itu.implementers-guide.presentation.xsl \
	xslt/itu.resolution.xsl \
	xslt/itu.resolution.presentation.xsl \
	xslt/ogc.abstract-specification-topic.xsl \
	xslt/ogc.abstract-specification-topic.presentation.xsl \
	xslt/ogc.best-practice.xsl \
	xslt/ogc.best-practice.presentation.xsl \
	xslt/ogc.change-request-supporting-document.xsl \
	xslt/ogc.change-request-supporting-document.presentation.xsl \
	xslt/ogc.community-practice.xsl \
	xslt/ogc.community-practice.presentation.xsl \
	xslt/ogc.community-standard.xsl \
	xslt/ogc.community-standard.presentation.xsl \
	xslt/ogc.discussion-paper.xsl \
	xslt/ogc.discussion-paper.presentation.xsl \
	xslt/ogc.engineering-report.xsl \
	xslt/ogc.engineering-report.presentation.xsl \
	xslt/ogc.other.xsl \
	xslt/ogc.other.presentation.xsl \
	xslt/ogc.policy.xsl \
	xslt/ogc.policy.presentation.xsl \
	xslt/ogc.reference-model.xsl \
	xslt/ogc.reference-model.presentation.xsl \
	xslt/ogc.release-notes.xsl \
	xslt/ogc.release-notes.presentation.xsl \
	xslt/ogc.standard.xsl \
	xslt/ogc.standard.presentation.xsl \
	xslt/ogc.test-suite.xsl \
	xslt/ogc.test-suite.presentation.xsl \
	xslt/ogc.user-guide.xsl \
	xslt/ogc.user-guide.presentation.xsl \
	xslt/ogc.white-paper.xsl \
	xslt/ogc.white-paper.presentation.xsl \
	xslt/un.plenary.xsl \
	xslt/un.plenary.presentation.xsl \
	xslt/un.plenary-attachment.xsl \
	xslt/un.plenary-attachment.presentation.xsl \
	xslt/un.recommendation.xsl \
	xslt/un.recommendation.presentation.xsl \
	xslt/csd.standard.xsl \
	xslt/csd.standard.presentation.xsl \
	xslt/csa.standard.xsl \
	xslt/csa.standard.presentation.xsl \
	xslt/rsd.standard.xsl \
	xslt/rsd.standard.presentation.xsl \
	xslt/m3d.report.xsl \
	xslt/m3d.report.presentation.xsl \
	xslt/gb.recommendation.xsl \
	xslt/gb.recommendation.presentation.xsl \
	xslt/iho.specification.xsl \
	xslt/iho.specification.presentation.xsl \
	xslt/iho.standard.xsl \
	xslt/iho.standard.presentation.xsl \
	xslt/mpfd.standards.xsl \
	xslt/mpfd.standards.presentation.xsl \
	xslt/mpfd.circular.xsl \
	xslt/mpfd.circular.presentation.xsl \
	xslt/mpfd.compliance-standards-for-mpf-trustees.xsl \
	xslt/mpfd.compliance-standards-for-mpf-trustees.presentation.xsl \
	xslt/mpfd.guidelines.xsl \
	xslt/mpfd.guidelines.presentation.xsl \
	xslt/mpfd.supervision-of-mpf-intermediaries.xsl \
	xslt/mpfd.supervision-of-mpf-intermediaries.presentation.xsl \
	xslt/bipm.brochure.presentation.xsl \
	xslt/bipm.mise-en-pratique.presentation.xsl \
	xslt/bipm.guide.presentation.xsl \
	xslt/bipm.rapport.presentation.xsl 

MN2PDF_DOWNLOAD_PATH := https://github.com/metanorma/mn2pdf/releases/download/v1.23/mn2pdf-1.23.jar
# MN2PDF_DOWNLOAD_PATH := https://maven.pkg.github.com/metanorma/mn2pdf/com/metanorma/fop/mn2pdf/1.7/mn2pdf-1.7.jar
MN2PDF_EXECUTABLE := $(notdir $(MN2PDF_DOWNLOAD_PATH))

FONT_MANIFEST_PATH := ${CURDIR}/fonts/manifest.paths.yml

all: xslts documents.html

targets:
	echo "$(PDF)"

xslts: xsltsclean $(XSLT_GENERATED)

$(MN2PDF_EXECUTABLE):
	curl -sSL ${MN2PDF_DOWNLOAD_PATH} -o $(MN2PDF_EXECUTABLE)

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

sources/iso-is-%: mn-samples-iso/documents/international-standard/%
	cp $< $@

sources/iso-amendment-%: mn-samples-iso/documents/amendment/%
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

sources/m3d-bp-%: mn-samples-m3aawg/documents/best-practice/%
	cp $< $@

sources/gb-%: mn-samples-gb/documents/%
	cp $< $@

sources/iho-%: mn-samples-iho/documents/%
	cp $< $@

sources/mpfd-%: mn-samples-mpfa/documents/mpfd-%
	cp $< $@

documents:
	mkdir -p $@

documents/%.presentation.html:
	echo "### skipping $@"

documents/%.sts.html:
	echo "### skipping $@"

documents/%.presentation.doc:
	echo "### skipping $@"

documents/%.sts.doc:
	echo "### skipping $@"

documents/%.presentation.rxl:
	echo "### skipping $@"

documents/%.sts.rxl:
	echo "### skipping $@"

#documents/%.presentation.xml:
#	echo "### skipping $@"

#documents/%.presentation.pdf:
#	echo "### skipping $@"

documents/%.sts.pdf:
	echo "### skipping $@"

documents/%.html: sources/%.html | documents
	cp $< $@

documents/%.doc: sources/%.doc | documents
	cp $< $@

documents/%.rxl: sources/%.rxl | documents
	cp $< $@

documents/%.xml: sources/%.xml | documents
	cp $< $@


# This document is currently broken
#un.agenda.xsl required
documents/un-ECE_AGAT_2020_INF1.pdf:
	echo "### skipping $@"

documents/un-ECE_AGAT_2020_INF1.presentation.pdf:
	echo "### skipping $@"

#mn-samples-cc repository issue
documents/cc-18011.html:
	echo "### skipping $@"

documents/cc-18011.doc:
	echo "### skipping $@"

documents/cc-18011.rxl:
	echo "### skipping $@"

documents/m3d-bp-document.html:
	echo "### skipping $@"

documents/m3d-bp-document.doc:
	echo "### skipping $@"

documents/m3d-bp-document.rxl:
	echo "### skipping $@"


documents/%.presentation.pdf: sources/%.presentation.xml $(MN2PDF_EXECUTABLE) | documents
ifeq ($(OS),Windows_NT)
	powershell -Command "$$doc = [xml](Get-Content $<); $$doc.SelectNodes(\"*\").get_name()" | cut -d "-" -f 1 > MN_FLAVOR.txt
	powershell -Command "$$doc = [xml](Get-Content $<); $$doc.SelectNodes(\"//*[local-name()='doctype']\").'#text'" > DOCTYPE.txt
	cmd /V /C "set /p MN_FLAVOR=<MN_FLAVOR.txt & set /p DOCTYPE=<DOCTYPE.txt & java -Xss5m -Xmx1024m -jar $(MN2PDF_EXECUTABLE) --font-manifest $(FONT_MANIFEST_PATH) --xml-file $< --xsl-file ${XSLT_PATH_BASE}/!MN_FLAVOR!.!DOCTYPE!.presentation.xsl --pdf-file $@"
else
	FILENAME=$<; \
	MN_FLAVOR=$$(xmllint --huge --xpath 'name(*)' $${FILENAME} | cut -d '-' -f 1); \
	DOCTYPE=$$(xmllint --huge --xpath "(//*[local-name()='doctype'])[1]/text()" $${FILENAME}); \
	XSLT_PATH=${XSLT_PATH_BASE}/$${MN_FLAVOR}.$${DOCTYPE}.presentation.xsl; \
	java -Xss5m -Xmx1024m -jar $(MN2PDF_EXECUTABLE) --font-manifest $(FONT_MANIFEST_PATH) --xml-file $$FILENAME --xsl-file $$XSLT_PATH --pdf-file $@	
endif

documents/%.pdf: sources/%.xml $(MN2PDF_EXECUTABLE) | documents
	echo "### skipping non-presentation pdf processing"
#ifeq ($(OS),Windows_NT)
#	powershell -Command "$$doc = [xml](Get-Content $<); $$doc.SelectNodes(\"*\").get_name()" | cut -d "-" -f 1 > MN_FLAVOR.txt
#	powershell -Command "$$doc = [xml](Get-Content $<); $$doc.SelectNodes(\"//*[local-name()='doctype']\").'#text'" > DOCTYPE.txt
#	cmd /V /C "set /p MN_FLAVOR=<MN_FLAVOR.txt & set /p DOCTYPE=<DOCTYPE.txt & java -Xss5m -Xmx1024m -jar $(MN2PDF_EXECUTABLE) --xml-file $< --xsl-file ${XSLT_PATH_BASE}/!MN_FLAVOR!.!DOCTYPE!.xsl --pdf-file $@"
#else
#	FILENAME=$<; \
#	MN_FLAVOR=$$(xmllint --huge --xpath 'name(*)' $${FILENAME} | cut -d '-' -f 1); \
#	DOCTYPE=$$(xmllint --huge --xpath "(//*[local-name()='doctype'])[1]/text()" $${FILENAME}); \
#	XSLT_PATH=${XSLT_PATH_BASE}/$${MN_FLAVOR}.$${DOCTYPE}.xsl; \
#	java -Xss5m -Xmx1024m -jar $(MN2PDF_EXECUTABLE) --xml-file $$FILENAME --xsl-file $$XSLT_PATH --pdf-file $@	
#endif

xslt/%.xsl: xslt_src/%.core.xsl xslt_src/merge.xsl xalan/xalan.jar
	java -jar xalan/xalan.jar -IN $< -XSL xslt_src/merge.xsl -OUT $@ -PARAM xslfile $<

documents.rxl: $(HTML) $(DOC) $(RXL) $(PDF) | bundle
	echo "### skipping step 'documents.rxl'"
#	bundle exec relaton concatenate \
#	  -t "mn2pdf samples" \
#		-g "Metanorma" \
#		documents $@

bundle:
	bundle

documents.html: documents.rxl
	echo "### skipping step 'documents.html'"
#	bundle exec relaton xml2html documents.rxl

distclean: clean
	rm -rf xalan/*
	rm -f $(MN2PDF_EXECUTABLE)

clean: xsltsclean
	rm -rf documents

xsltsclean:
	rm -f $(XSLT_GENERATED)

update-init:
	git submodule update --init

update-modules:
ifeq ($(OS),Windows_NT)
	git submodule foreach "git fetch origin gh-pages"
	git submodule foreach "git checkout gh-pages"
	git submodule foreach "git reset --hard origin/gh-pages"
else
	git submodule foreach "git fetch origin gh-pages"; \
	git submodule foreach "git checkout gh-pages"; \
	git submodule foreach "git reset --hard origin/gh-pages"
endif

publish: published
published: documents.html
	mkdir published && \
	cp -a documents $@/
#	 && \
#	cp $< published/index.html
ifeq ($(OS),Windows_NT)
	if exist "images" ( cp -a images published )
else
	if [ -d "images" ]; then cp -a images published; fi
endif

.PHONY: all clean update-init update-modules bundle publish xslts
