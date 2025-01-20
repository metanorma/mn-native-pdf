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
	$(patsubst mn-samples-m3aawg/documents/best-practice/%,sources/m3aawg-bp-%,$(wildcard mn-samples-m3aawg/documents/best-practice/*.xml)) \
	$(patsubst mn-samples-m3aawg/documents/policy/%,sources/m3aawg-p-%,$(wildcard mn-samples-m3aawg/documents/policy/*.xml)) \
	$(patsubst mn-samples-m3aawg/documents/report/%,sources/m3aawg-r-%,$(wildcard mn-samples-m3aawg/documents/report/*.xml)) \
	$(patsubst mn-samples-cc/documents/%,sources/%,$(wildcard mn-samples-cc/documents/*.xml)) \
	$(patsubst mn-samples-gb/documents/%,sources/gb-%,$(wildcard mn-samples-gb/documents/*.xml)) \
	$(patsubst mn-samples-iho/documents/%,sources/iho-%,$(wildcard mn-samples-iho/documents/*.xml)) \
	$(patsubst mn-samples-mpfa/documents/mpfa-%,sources/mpfa-%,$(wildcard mn-samples-mpfa/documents/*.xml))

 
PDF := $(patsubst sources/%,documents/%,$(patsubst %.xml,%.pdf,$(SRC)))
HTML := $(patsubst sources/%,documents/%,$(patsubst %.xml,%.html,$(SRC)))
DOC := $(patsubst sources/%,documents/%,$(patsubst %.xml,%.doc,$(SRC)))
RXL := $(patsubst sources/%,documents/%,$(patsubst %.xml,%.rxl,$(SRC)))
XSLT_PATH_BASE := ${CURDIR}/xslt
XSLT_GENERATED := xslt/iec.international-standard.xsl \
	xslt/ieee.standard.xsl \
	xslt/ieee.amendment.xsl \
	xslt/iso.international-standard.xsl \
	xslt/iso.amendment.xsl \
	xslt/itu.recommendation.xsl \
	xslt/itu.recommendation-annex.xsl \
	xslt/itu.recommendation-supplement.xsl \
	xslt/itu.technical-report.xsl \
	xslt/itu.technical-paper.xsl \
	xslt/itu.implementers-guide.xsl \
	xslt/itu.resolution.xsl \
	xslt/itu.service-publication.xsl \
	xslt/itu.in-force.xsl \
	xslt/jis.international-standard.xsl \
	xslt/ogc.abstract-specification-topic.xsl \
	xslt/ogc.best-practice.xsl \
	xslt/ogc.change-request-supporting-document.xsl \
	xslt/ogc.community-practice.xsl \
	xslt/ogc.community-standard.xsl \
	xslt/ogc.discussion-paper.xsl \
	xslt/ogc.draft-standard.xsl \
	xslt/ogc.engineering-report.xsl \
	xslt/ogc.other.xsl \
	xslt/ogc.policy.xsl \
	xslt/ogc.reference-model.xsl \
	xslt/ogc.release-notes.xsl \
	xslt/ogc.standard.xsl \
	xslt/ogc.test-suite.xsl \
	xslt/ogc.user-guide.xsl \
	xslt/ogc.white-paper.xsl \
	xslt/plateau.international-standard.xsl \
	xslt/un.plenary.xsl \
	xslt/un.plenary-attachment.xsl \
	xslt/un.recommendation.xsl \
	xslt/cc.standard.xsl \
	xslt/csa.standard.xsl \
	xslt/ribose.standard.xsl \
	xslt/m3aawg.report.xsl \
	xslt/m3aawg.policy.xsl \
	xslt/gb.recommendation.xsl \
	xslt/iho.specification.xsl \
	xslt/iho.standard.xsl \
	xslt/mpfa.standards.xsl \
	xslt/mpfa.circular.xsl \
	xslt/mpfa.compliance-standards-for-mpf-trustees.xsl \
	xslt/mpfa.guidelines.xsl \
	xslt/mpfa.supervision-of-mpf-intermediaries.xsl \
	xslt/bipm.brochure.xsl \
	xslt/bipm.mise-en-pratique.xsl \
	xslt/bipm.guide.xsl \
	xslt/bipm.rapport.xsl \
	xslt/jcgm.standard.xsl

MN2PDF_DOWNLOAD_PATH := https://github.com/metanorma/mn2pdf/releases/download/v2.13/mn2pdf-2.13.jar
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

sources/m3aawg-bp-%: mn-samples-m3aawg/documents/best-practice/%
	cp $< $@

sources/m3aawg-p-%: mn-samples-m3aawg/documents/policy/%
	cp $< $@

sources/m3aawg-r-%: mn-samples-m3aawg/documents/report/%
	cp $< $@

sources/gb-%: mn-samples-gb/documents/%
	cp $< $@

sources/iho-%: mn-samples-iho/documents/%
	cp $< $@

sources/mpfa-%: mn-samples-mpfa/documents/mpfa-%
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


documents/%.presentation.pdf: sources/%.presentation.xml $(MN2PDF_EXECUTABLE) | documents
ifeq ($(OS),Windows_NT)
	powershell -Command "Write-Host $(word 1,$(subst -, ,$(notdir $<)))" > MN_FLAVOR.txt
	powershell -Command "$$doc = [xml](Get-Content $<); $$doc.SelectNodes(\"//*[local-name()='doctype']\").'#text'" > DOCTYPE.txt
	cmd /V /C "set /p MN_FLAVOR=<MN_FLAVOR.txt & set /p DOCTYPE=<DOCTYPE.txt & java -Xss5m -Xmx1024m -jar $(MN2PDF_EXECUTABLE) --xml-file $< --xsl-file ${XSLT_PATH_BASE}/!MN_FLAVOR!.!DOCTYPE!.xsl --pdf-file $@ --font-manifest $(FONT_MANIFEST_PATH) "
else
	MN_FLAVOR=$(word 1,$(subst -, ,$(notdir $<))); \
	DOCTYPE=$$(xmllint --huge --xpath "(//*[local-name()='doctype'])[1]/text()" $<); \
	XSLT_PATH=${XSLT_PATH_BASE}/$${MN_FLAVOR}.$${DOCTYPE}.xsl; \
	java -Xss5m -Xmx1024m -jar $(MN2PDF_EXECUTABLE) --xml-file $< --xsl-file $$XSLT_PATH --pdf-file $@ --font-manifest $(FONT_MANIFEST_PATH) 
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
ifeq ($(OS),Windows_NT)
	java -jar xalan/xalan.jar -IN $< -XSL xslt_src/merge.xsl -OUT $@ -PARAM xslfile $<
	powershell -Command "$$doc = [xml](Get-Content $<); $$doc.SelectNodes(\"/*/namespace::*[starts-with(.,'https://www.metanorma.org/ns/')]\").'#text'" > XMLNS.txt
	cmd /V /C "set /p XMLNS=<XMLNS.txt & echo ^<?xml version="1.0" encoding="UTF-8"?^>^<empty xmlns="!XMLNS!"^>^</empty^> > empty.xml"
	java -jar xalan/xalan.jar -IN empty.xml -XSL $@ >result.txt -PARAM output_path %cd%/ > nul 2>result.txt
	more result.txt
	for %%I in (result.txt) do (if %%~zI gtr 0 exit 1)
else
	java -jar xalan/xalan.jar -IN $< -XSL xslt_src/merge.xsl -OUT $@ -PARAM xslfile $<; \
	XMLNS=$$(xmllint --xpath "name(/*/namespace::*[starts-with(.,'https://www.metanorma.org/ns/')])" $<); \
	echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?><empty xmlns=\"https://www.metanorma.org/ns/$${XMLNS}\"></empty>" > empty.xml; \
	java -jar xalan/xalan.jar -IN empty.xml -XSL $@ >result.txt -PARAM output_path ${CURDIR}/ > nul 2>result.txt; \
	cat result.txt; \
	test `wc -c <result.txt` -eq 0
endif
	

documents.rxl: $(HTML) $(DOC) $(RXL) $(PDF) | bundle
#	echo "### skipping step 'documents.rxl'"
	bundle exec relaton concatenate \
	  -t "mn2pdf samples" \
		-g "Metanorma" \
		documents $@

bundle:
	bundle

documents.html: documents.rxl
#	echo "### skipping step 'documents.html'"
	bundle exec relaton xml2html documents.rxl

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
	git submodule foreach "git checkout origin/gh-pages"
	git submodule foreach "git reset --hard origin/gh-pages"
else
	git submodule foreach "git fetch origin gh-pages"; \
	git submodule foreach "git checkout origin/gh-pages"; \
	git submodule foreach "git reset --hard origin/gh-pages"
endif

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

MN_PROCR ?= iso
XSLT_PREFIX ?= $(MN_PROCR)
update-xslts-in-processor:
	$(eval PROCR_REPO := processor/$(MN_PROCR))
	[ -d $(PROCR_REPO) ] || git clone https://$${GIT_CREDS}github.com/metanorma/metanorma-$(MN_PROCR) $(PROCR_REPO)
	rsync xslt/$(XSLT_PREFIX).*.xsl $(PROCR_REPO)/lib/isodoc/$(MN_PROCR)/
	git -C $(PROCR_REPO) add lib/isodoc/$(MN_PROCR)/*.xsl
	git -C $(PROCR_REPO) commit -m "xslt update based on metanorma/mn-native-pdf@$(shell git rev-parse --short HEAD)" || git -C $(PROCR_REPO) --no-pager show --name-only
	git -C $(PROCR_REPO) push

update-xslts-in-processor-all:
	$(MAKE) update-xslts-in-processor MN_PROCR=bipm XSLT_PREFIX="{bipm,jcgm}"
	$(MAKE) update-xslts-in-processor MN_PROCR=csa
	$(MAKE) update-xslts-in-processor MN_PROCR=cc
	$(MAKE) update-xslts-in-processor MN_PROCR=iec
	$(MAKE) update-xslts-in-processor MN_PROCR=ieee
	$(MAKE) update-xslts-in-processor MN_PROCR=iho
	$(MAKE) update-xslts-in-processor MN_PROCR=iso
	$(MAKE) update-xslts-in-processor MN_PROCR=itu
	$(MAKE) update-xslts-in-processor MN_PROCR=iec
	$(MAKE) update-xslts-in-processor MN_PROCR=jis
	$(MAKE) update-xslts-in-processor MN_PROCR=ogc
	$(MAKE) update-xslts-in-processor MN_PROCR=plateau
	$(MAKE) update-xslts-in-processor MN_PROCR=ribose

# stop updating the XSLT for GB and MPFA, those gems have been frozen, https://github.com/metanorma/mn-native-pdf/issues/610
# 	$(MAKE) update-xslts-in-processor MN_PROCR=gb
# 	$(MAKE) update-xslts-in-processor MN_PROCR=mpfa
# stop updating the XSLT for M3A and UN,  https://github.com/metanorma/mn-native-pdf/issues/754
#	$(MAKE) update-xslts-in-processor MN_PROCR=m3aawg
#	$(MAKE) update-xslts-in-processor MN_PROCR=un

.PHONY: all clean update-init update-modules bundle publish xslts update-xslts-in-processor update-xslts-in-processor-all
