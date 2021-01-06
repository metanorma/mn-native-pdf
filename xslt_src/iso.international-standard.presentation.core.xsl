<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
											xmlns:fo="http://www.w3.org/1999/XSL/Format" 
											xmlns:iso="https://www.metanorma.org/ns/iso" 
											xmlns:jcgm="https://www.metanorma.org/ns/bipm" 
											xmlns:mathml="http://www.w3.org/1998/Math/MathML" 
											xmlns:xalan="http://xml.apache.org/xalan" 
											xmlns:fox="http://xmlgraphics.apache.org/fop/extensions" 
											xmlns:java="http://xml.apache.org/xalan/java" 
											exclude-result-prefixes="java"
											version="1.0">

	<xsl:output method="xml" encoding="UTF-8" indent="no"/>
	
	<xsl:param name="svg_images"/>
	<xsl:variable name="images" select="document($svg_images)"/>
	
	<xsl:include href="./common.xsl"/>

	<xsl:key name="kfn" match="*[local-name()='p']/*[local-name()='fn']" use="@reference"/>
	
	<xsl:variable name="namespace">iso</xsl:variable>
	
	<xsl:variable name="template_namespace">
		<xsl:choose>
			<xsl:when test="namespace-uri(//*[contains(local-name(), '-standard')]) = 'https://www.metanorma.org/ns/iso'">iso</xsl:when>
			<xsl:when test="namespace-uri(//*[contains(local-name(), '-standard')]) = 'https://www.metanorma.org/ns/bipm'">jcgm</xsl:when><!-- //bibdata/ext/editorialgroup/committee/@acronym = "JCGM" -->
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="debug">true</xsl:variable>
	<xsl:variable name="pageWidth" select="'210mm'"/>
	<xsl:variable name="pageHeight" select="'297mm'"/>

	<xsl:variable name="docidentifierISO" select="/iso:iso-standard/iso:bibdata/iso:docidentifier[@type = 'iso'] | /iso:iso-standard/iso:bibdata/iso:docidentifier[@type = 'ISO']"/>

	<xsl:variable name="all_rights_reserved">
		<xsl:call-template name="getLocalizedString">
			<xsl:with-param name="key">all_rights_reserved</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="copyrightText">
		<xsl:choose>
			<xsl:when test="$template_namespace = 'iso'">
				<xsl:value-of select="concat('© ISO ', /iso:iso-standard/iso:bibdata/iso:copyright/iso:from ,' – ', $all_rights_reserved)"/>
			</xsl:when>
			<xsl:when test="$template_namespace = 'jcgm'">
				<xsl:value-of select="concat('© ', /jcgm:bipm-standard/jcgm:bibdata/jcgm:ext/jcgm:editorialgroup/jcgm:committee/@acronym, ' ', /jcgm:bipm-standard/jcgm:bibdata/jcgm:copyright/jcgm:from, ' — ', $all_rights_reserved)"/>
			</xsl:when>
		</xsl:choose>
	</xsl:variable>
  
	<xsl:variable name="lang-1st-letter_tmp" select="substring-before(substring-after(/iso:iso-standard/iso:bibdata/iso:docidentifier[@type = 'iso-with-lang'], '('), ')')"/>
	<xsl:variable name="lang-1st-letter" select="concat('(', $lang-1st-letter_tmp , ')')"/>
  
	<!-- <xsl:variable name="ISOname" select="concat(/iso:iso-standard/iso:bibdata/iso:docidentifier, ':', /iso:iso-standard/iso:bibdata/iso:copyright/iso:from , $lang-1st-letter)"/> -->
	<xsl:variable name="ISOname" select="/iso:iso-standard/iso:bibdata/iso:docidentifier[@type = 'iso-reference']"/>

	<!-- Information and documentation — Codes for transcription systems  -->
	<xsl:variable name="title-intro" select="/iso:iso-standard/iso:bibdata/iso:title[@language = 'en' and @type = 'title-intro']"/>
	<xsl:variable name="title-intro-fr" select="/iso:iso-standard/iso:bibdata/iso:title[@language = 'fr' and @type = 'title-intro']"/>
	<xsl:variable name="title-main" select="/iso:iso-standard/iso:bibdata/iso:title[@language = 'en' and @type = 'title-main']"/>
	<xsl:variable name="title-main-fr" select="/iso:iso-standard/iso:bibdata/iso:title[@language = 'fr' and @type = 'title-main']"/>
	<xsl:variable name="part" select="/iso:iso-standard/iso:bibdata/iso:ext/iso:structuredidentifier/iso:project-number/@part"/>
	
	<xsl:variable name="doctype" select="/iso:iso-standard/iso:bibdata/iso:ext/iso:doctype"/>	 
	<xsl:variable name="doctype_uppercased" select="java:toUpperCase(java:java.lang.String.new(translate($doctype,'-',' ')))"/>
	 	
	<xsl:variable name="stage" select="number(/iso:iso-standard/iso:bibdata/iso:status/iso:stage)"/>
	<xsl:variable name="substage" select="number(/iso:iso-standard/iso:bibdata/iso:status/iso:substage)"/>	
	<xsl:variable name="stagename" select="normalize-space(/iso:iso-standard/iso:bibdata/iso:ext/iso:stagename)"/>
	<xsl:variable name="abbreviation" select="normalize-space(/iso:iso-standard/iso:bibdata/iso:status/iso:stage/@abbreviation)"/>
		
	<xsl:variable name="stage-abbreviation">
		<xsl:choose>
			<xsl:when test="$abbreviation != ''">
				<xsl:value-of select="$abbreviation"/>
			</xsl:when>
			<xsl:when test="$stage = 0 and $substage = 0">PWI</xsl:when>
			<xsl:when test="$stage = 0">NWIP</xsl:when> <!-- NWIP (NP) -->
			<xsl:when test="$stage = 10">AWI</xsl:when>
			<xsl:when test="$stage = 20">WD</xsl:when>
			<xsl:when test="$stage = 30">CD</xsl:when>
			<xsl:when test="$stage = 40">DIS</xsl:when>
			<xsl:when test="$stage = 50">FDIS</xsl:when>
			<xsl:when test="$stage = 60 and $substage = 0">PRF</xsl:when>
			<xsl:when test="$stage = 60 and $substage = 60">IS</xsl:when>
			<xsl:when test="$stage &gt;=60">published</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="stage-fullname-uppercased">
		<xsl:choose>
			<xsl:when test="$stagename != ''">				
				<xsl:value-of select="java:toUpperCase(java:java.lang.String.new($stagename))"/>
			</xsl:when>
			<xsl:when test="$stage-abbreviation = 'NWIP' or
															$stage-abbreviation = 'NP'">NEW WORK ITEM PROPOSAL</xsl:when>
			<xsl:when test="$stage-abbreviation = 'PWI'">PRELIMINARY WORK ITEM</xsl:when>
			<xsl:when test="$stage-abbreviation = 'AWI'">APPROVED WORK ITEM</xsl:when>
			<xsl:when test="$stage-abbreviation = 'WD'">WORKING DRAFT</xsl:when>
			<xsl:when test="$stage-abbreviation = 'CD'">COMMITTEE DRAFT</xsl:when>
			<xsl:when test="$stage-abbreviation = 'DIS'">DRAFT INTERNATIONAL STANDARD</xsl:when>
			<xsl:when test="$stage-abbreviation = 'FDIS'">FINAL DRAFT INTERNATIONAL STANDARD</xsl:when>
			<xsl:otherwise><xsl:value-of select="$doctype_uppercased"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="stagename-header-firstpage">
		<xsl:choose>
			<!-- <xsl:when test="$stage-abbreviation = 'PWI' or 
														$stage-abbreviation = 'NWIP' or 
														$stage-abbreviation = 'NP'">PRELIMINARY WORK ITEM</xsl:when> -->
			<xsl:when test="$stage-abbreviation = 'PRF'"><xsl:value-of select="$doctype_uppercased"/></xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$stage-fullname-uppercased"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="stagename-header-coverpage">
		<xsl:choose>
			<xsl:when test="$stage-abbreviation = 'DIS'">DRAFT</xsl:when>
			<xsl:when test="$stage-abbreviation = 'FDIS'">FINAL DRAFT</xsl:when>
			<xsl:when test="$stage-abbreviation = 'PRF'"></xsl:when>
			<xsl:when test="$stage-abbreviation = 'IS'"></xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$stage-fullname-uppercased"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<!-- UPPERCASED stage name -->	
	<!-- <item name="NWIP" show="true" header="PRELIMINARY WORK ITEM" shortname="NEW WORK ITEM PROPOSAL">NEW WORK ITEM PROPOSAL</item>
	<item name="PWI" show="true" header="PRELIMINARY WORK ITEM" shortname="PRELIMINARY WORK ITEM">PRELIMINARY WORK ITEM</item>		
	<item name="NP" show="true" header="PRELIMINARY WORK ITEM" shortname="NEW WORK ITEM PROPOSAL">NEW WORK ITEM PROPOSAL</item>
	<item name="AWI" show="true" header="APPROVED WORK ITEM" shortname="APPROVED WORK ITEM">APPROVED WORK ITEM</item>
	<item name="WD" show="true" header="WORKING DRAFT" shortname="WORKING DRAFT">WORKING DRAFT</item>
	<item name="CD" show="true" header="COMMITTEE DRAFT" shortname="COMMITTEE DRAFT">COMMITTEE DRAFT</item>
	<item name="DIS" show="true" header="DRAFT INTERNATIONAL STANDARD" shortname="DRAFT">DRAFT INTERNATIONAL STANDARD</item>
	<item name="FDIS" show="true" header="FINAL DRAFT INTERNATIONAL STANDARD" shortname="FINAL DRAFT">FINAL DRAFT INTERNATIONAL STANDARD</item>
	<item name="PRF">PROOF</item> -->
	
	
	<!-- 
		<status>
    <stage>30</stage>
    <substage>92</substage>
  </status>
	  The <stage> and <substage> values are well defined, 
		as the International Harmonized Stage Codes (https://www.iso.org/stage-codes.html):
		stage 60 means published, everything before is a Draft (90 means withdrawn, but the document doesn't change anymore) -->
	<xsl:variable name="isPublished">
		<xsl:choose>
			<xsl:when test="string($stage) = 'NaN'">false</xsl:when>
			<xsl:when test="$stage &gt;=60">true</xsl:when>
			<xsl:when test="normalize-space($stage-abbreviation) != ''">true</xsl:when>
			<xsl:otherwise>false</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="document-master-reference">
		<xsl:choose>
			<xsl:when test="$stage-abbreviation != ''">-publishedISO</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="force-page-count-preface">
		<xsl:choose>
			<xsl:when test="$document-master-reference != ''">end-on-even</xsl:when>
			<xsl:otherwise>no-force</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="proof-text">PROOF/ÉPREUVE</xsl:variable>
	
	<!-- Example:
		<item level="1" id="Foreword" display="true">Foreword</item>
		<item id="term-script" display="false">3.2</item>
	-->
	<xsl:variable name="contents">
		<contents>
			<xsl:call-template name="processPrefaceSectionsDefault_Contents"/>
			<xsl:call-template name="processMainSectionsDefault_Contents"/>
		</contents>
	</xsl:variable>
	
	<xsl:variable name="lang">
		<xsl:call-template name="getLang"/>
	</xsl:variable>
	
	<xsl:template match="/">
		<xsl:choose>
			<xsl:when test="$template_namespace = 'jcgm'"><xsl:apply-templates select="." mode="jcgm"/></xsl:when>
			<xsl:otherwise><xsl:apply-templates select="." mode="iso"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="/" mode="iso">
		<xsl:call-template name="namespaceCheck"/>
		<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format" font-family="Cambria, Times New Roman, Cambria Math, Source Han Sans" font-size="11pt" xml:lang="{$lang}"> <!--   -->
			<xsl:if test="$lang = 'zh'">
				<xsl:attribute name="font-family">Source Han Sans, Times New Roman, Cambria Math</xsl:attribute>
			</xsl:if>
			<fo:layout-master-set>
				
				<!-- cover page -->
				<fo:simple-page-master master-name="cover-page" page-width="{$pageWidth}" page-height="{$pageHeight}">
					<fo:region-body margin-top="25.4mm" margin-bottom="25.4mm" margin-left="31.7mm" margin-right="31.7mm"/>
					<fo:region-before region-name="cover-page-header" extent="25.4mm" />
					<fo:region-after/>
					<fo:region-start region-name="cover-left-region" extent="31.7mm"/>
					<fo:region-end region-name="cover-right-region" extent="31.7mm"/>
				</fo:simple-page-master>
				
				<fo:simple-page-master master-name="cover-page-published" page-width="{$pageWidth}" page-height="{$pageHeight}">
					<fo:region-body margin-top="12.7mm" margin-bottom="40mm" margin-left="78mm" margin-right="18.5mm"/>
					<fo:region-before region-name="cover-page-header" extent="12.7mm" />
					<fo:region-after region-name="cover-page-footer" extent="40mm" display-align="after" />
					<fo:region-start region-name="cover-left-region" extent="78mm"/>
					<fo:region-end region-name="cover-right-region" extent="18.5mm"/>
				</fo:simple-page-master>
				
				
				<fo:simple-page-master master-name="cover-page-publishedISO-odd" page-width="{$pageWidth}" page-height="{$pageHeight}">
					<fo:region-body margin-top="12.7mm" margin-bottom="40mm" margin-left="25mm" margin-right="12.5mm"/>
					<fo:region-before region-name="cover-page-header" extent="12.7mm" />
					<fo:region-after region-name="cover-page-footer" extent="40mm" display-align="after" />
					<fo:region-start region-name="cover-left-region" extent="25mm"/>
					<fo:region-end region-name="cover-right-region" extent="12.5mm"/>
				</fo:simple-page-master>
				<fo:simple-page-master master-name="cover-page-publishedISO-even" page-width="{$pageWidth}" page-height="{$pageHeight}">
					<fo:region-body margin-top="12.7mm" margin-bottom="40mm" margin-left="12.5mm" margin-right="25mm"/>
					<fo:region-before region-name="cover-page-header" extent="12.7mm" />
					<fo:region-after region-name="cover-page-footer" extent="40mm" display-align="after" />
					<fo:region-start region-name="cover-left-region" extent="12.5mm"/>
					<fo:region-end region-name="cover-right-region" extent="25mm"/>
				</fo:simple-page-master>
				<fo:page-sequence-master master-name="cover-page-publishedISO">
					<fo:repeatable-page-master-alternatives>
						<fo:conditional-page-master-reference odd-or-even="even" master-reference="cover-page-publishedISO-even"/>
						<fo:conditional-page-master-reference odd-or-even="odd" master-reference="cover-page-publishedISO-odd"/>
					</fo:repeatable-page-master-alternatives>
				</fo:page-sequence-master>


				<!-- contents pages -->
				<!-- odd pages -->
				<fo:simple-page-master master-name="odd" page-width="{$pageWidth}" page-height="{$pageHeight}">
					<fo:region-body margin-top="27.4mm" margin-bottom="13mm" margin-left="19mm" margin-right="19mm"/>
					<fo:region-before region-name="header-odd" extent="27.4mm"/> <!--   display-align="center" -->
					<fo:region-after region-name="footer-odd" extent="13mm"/>
					<fo:region-start region-name="left-region" extent="19mm"/>
					<fo:region-end region-name="right-region" extent="19mm"/>
				</fo:simple-page-master>
				<!-- even pages -->
				<fo:simple-page-master master-name="even" page-width="{$pageWidth}" page-height="{$pageHeight}">
					<fo:region-body margin-top="27.4mm" margin-bottom="13mm" margin-left="19mm" margin-right="19mm"/>
					<fo:region-before region-name="header-even" extent="27.4mm"/> <!--   display-align="center" -->
					<fo:region-after region-name="footer-even" extent="13mm"/>
					<fo:region-start region-name="left-region" extent="19mm"/>
					<fo:region-end region-name="right-region" extent="19mm"/>
				</fo:simple-page-master>
				<fo:page-sequence-master master-name="preface">
					<fo:repeatable-page-master-alternatives>
						<fo:conditional-page-master-reference odd-or-even="even" master-reference="even"/>
						<fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd"/>
					</fo:repeatable-page-master-alternatives>
				</fo:page-sequence-master>
				<fo:page-sequence-master master-name="document">
					<fo:repeatable-page-master-alternatives>
						<fo:conditional-page-master-reference odd-or-even="even" master-reference="even"/>
						<fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd"/>
					</fo:repeatable-page-master-alternatives>
				</fo:page-sequence-master>
				
				
				<!-- first page -->
				<fo:simple-page-master master-name="first-publishedISO" page-width="{$pageWidth}" page-height="{$pageHeight}">
					<fo:region-body margin-top="27.4mm" margin-bottom="13mm" margin-left="25mm" margin-right="12.5mm"/>
					<fo:region-before region-name="header-first" extent="27.4mm"/> <!--   display-align="center" -->
					<fo:region-after region-name="footer-odd" extent="13mm"/>
					<fo:region-start region-name="left-region" extent="25mm"/>
					<fo:region-end region-name="right-region" extent="12.5mm"/>
				</fo:simple-page-master>
				<!-- odd pages -->
				<fo:simple-page-master master-name="odd-publishedISO" page-width="{$pageWidth}" page-height="{$pageHeight}">
					<fo:region-body margin-top="27.4mm" margin-bottom="13mm" margin-left="25mm" margin-right="12.5mm"/>
					<fo:region-before region-name="header-odd" extent="27.4mm"/> <!--   display-align="center" -->
					<fo:region-after region-name="footer-odd" extent="13mm"/>
					<fo:region-start region-name="left-region" extent="25mm"/>
					<fo:region-end region-name="right-region" extent="12.5mm"/>
				</fo:simple-page-master>
				<!-- even pages -->
				<fo:simple-page-master master-name="even-publishedISO" page-width="{$pageWidth}" page-height="{$pageHeight}">
					<fo:region-body margin-top="27.4mm" margin-bottom="13mm" margin-left="12.5mm" margin-right="25mm"/>
					<fo:region-before region-name="header-even" extent="27.4mm"/>
					<fo:region-after region-name="footer-even" extent="13mm"/>
					<fo:region-start region-name="left-region" extent="12.5mm"/>
					<fo:region-end region-name="right-region" extent="25mm"/>
				</fo:simple-page-master>
				<fo:simple-page-master master-name="blankpage" page-width="{$pageWidth}" page-height="{$pageHeight}">
					<fo:region-body margin-top="27.4mm" margin-bottom="13mm" margin-left="12.5mm" margin-right="25mm"/>
					<fo:region-before region-name="header" extent="27.4mm"/>
					<fo:region-after region-name="footer" extent="13mm"/>
					<fo:region-start region-name="left" extent="12.5mm"/>
					<fo:region-end region-name="right" extent="25mm"/>
				</fo:simple-page-master>
				<fo:page-sequence-master master-name="preface-publishedISO">
					<fo:repeatable-page-master-alternatives>
						<fo:conditional-page-master-reference master-reference="blankpage" blank-or-not-blank="blank" />
						<fo:conditional-page-master-reference odd-or-even="even" master-reference="even-publishedISO"/>
						<fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd-publishedISO"/>
					</fo:repeatable-page-master-alternatives>
				</fo:page-sequence-master>
				
				
				<fo:page-sequence-master master-name="document-publishedISO">
					<fo:repeatable-page-master-alternatives>
						<fo:conditional-page-master-reference master-reference="first-publishedISO" page-position="first"/>
						<fo:conditional-page-master-reference odd-or-even="even" master-reference="even-publishedISO"/>
						<fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd-publishedISO"/>
					</fo:repeatable-page-master-alternatives>
				</fo:page-sequence-master>
				
				<fo:simple-page-master master-name="last-page" page-width="{$pageWidth}" page-height="{$pageHeight}">
					<fo:region-body margin-top="27.4mm" margin-bottom="13mm" margin-left="12.5mm" margin-right="25mm"/>
					<fo:region-before region-name="header-even" extent="27.4mm"/>
					<fo:region-after region-name="last-page-footer" extent="13mm"/>
					<fo:region-start region-name="left-region" extent="12.5mm"/>
					<fo:region-end region-name="right-region" extent="25mm"/>
				</fo:simple-page-master>
				
			</fo:layout-master-set>

			<xsl:call-template name="addPDFUAmeta"/>
			
			<xsl:call-template name="addBookmarks">
				<xsl:with-param name="contents" select="$contents"/>
			</xsl:call-template>
			
			<!-- cover page -->
			<xsl:choose>
				<xsl:when test="$stage-abbreviation != ''">
					<fo:page-sequence master-reference="cover-page-publishedISO" force-page-count="no-force">
						<fo:static-content flow-name="cover-page-footer" font-size="10pt">
							<fo:table table-layout="fixed" width="100%">
								<fo:table-column column-width="52mm"/>
								<fo:table-column column-width="7.5mm"/>
								<fo:table-column column-width="112.5mm"/>
								<fo:table-body>
									<fo:table-row>
										<fo:table-cell font-size="6.5pt" text-align="justify" display-align="after" padding-bottom="8mm"><!-- before -->
											<!-- margin-top="-30mm"  -->
											<fo:block margin-top="-100mm">
												<xsl:if test="$stage-abbreviation = 'DIS' or 
																					$stage-abbreviation = 'NWIP' or 
																					$stage-abbreviation = 'NP' or 
																					$stage-abbreviation = 'PWI' or 
																					$stage-abbreviation = 'AWI' or 
																					$stage-abbreviation = 'WD' or 
																					$stage-abbreviation = 'CD'">
													<fo:block margin-bottom="1.5mm">
														<xsl:text>THIS DOCUMENT IS A DRAFT CIRCULATED FOR COMMENT AND APPROVAL. IT IS THEREFORE SUBJECT TO CHANGE AND MAY NOT BE REFERRED TO AS AN INTERNATIONAL STANDARD UNTIL PUBLISHED AS SUCH.</xsl:text>
													</fo:block>
												</xsl:if>
												<xsl:if test="$stage-abbreviation = 'FDIS' or 
																					$stage-abbreviation = 'DIS' or 
																					$stage-abbreviation = 'NWIP' or 
																					$stage-abbreviation = 'NP' or 
																					$stage-abbreviation = 'PWI' or 
																					$stage-abbreviation = 'AWI' or 
																					$stage-abbreviation = 'WD' or 
																					$stage-abbreviation = 'CD'">
													<fo:block margin-bottom="1.5mm">
														<xsl:text>RECIPIENTS OF THIS DRAFT ARE INVITED TO
																			SUBMIT, WITH THEIR COMMENTS, NOTIFICATION
																			OF ANY RELEVANT PATENT RIGHTS OF WHICH
																			THEY ARE AWARE AND TO PROVIDE SUPPORTING
																			DOCUMENTATION.</xsl:text>
													</fo:block>
													<fo:block>
														<xsl:text>IN ADDITION TO THEIR EVALUATION AS
																BEING ACCEPTABLE FOR INDUSTRIAL, TECHNOLOGICAL,
																COMMERCIAL AND USER PURPOSES,
																DRAFT INTERNATIONAL STANDARDS MAY ON
																OCCASION HAVE TO BE CONSIDERED IN THE
																LIGHT OF THEIR POTENTIAL TO BECOME STANDARDS
																TO WHICH REFERENCE MAY BE MADE IN
																NATIONAL REGULATIONS.</xsl:text>
													</fo:block>
												</xsl:if>
											</fo:block>
										</fo:table-cell>
										<fo:table-cell>
											<fo:block>&#xA0;</fo:block>
										</fo:table-cell>
										<fo:table-cell>
											<xsl:if test="$stage-abbreviation = 'DIS'">
												<fo:block-container margin-top="-15mm" margin-bottom="7mm" margin-left="1mm">
													<fo:block font-size="9pt" border="0.5pt solid black" fox:border-radius="5pt" padding-left="2mm" padding-top="2mm" padding-bottom="2mm">
														<xsl:text>This document is circulated as received from the committee secretariat.</xsl:text>
													</fo:block>
												</fo:block-container>
											</xsl:if>
											<fo:block>
												<fo:table table-layout="fixed" width="100%" border-top="1mm double black" margin-bottom="3mm">
													<fo:table-column column-width="50%"/>
													<fo:table-column column-width="50%"/>
													<fo:table-body>
														<fo:table-row height="34mm">
															<fo:table-cell display-align="center">
																<fo:block text-align="left" margin-top="2mm">
																	<xsl:variable name="docid" select="substring-before(/iso:iso-standard/iso:bibdata/iso:docidentifier, ' ')"/>
																	<xsl:for-each select="xalan:tokenize($docid, '/')">
																		<xsl:choose>
																			<xsl:when test=". = 'ISO'">
																				<fo:external-graphic src="{concat('data:image/png;base64,', normalize-space($Image-ISO-Logo))}" width="21mm" content-height="21mm" content-width="scale-to-fit" scaling="uniform" fox:alt-text="Image {@alt}"/>
																			</xsl:when>
																			<xsl:when test=". = 'IEC'">
																				<fo:external-graphic src="{concat('data:image/png;base64,', normalize-space($Image-IEC-Logo))}" width="19.8mm" content-height="19.8mm" content-width="scale-to-fit" scaling="uniform" fox:alt-text="Image {@alt}"/>
																			</xsl:when>
																			<xsl:otherwise></xsl:otherwise>
																		</xsl:choose>
																		<xsl:if test="position() != last()">
																			<fo:inline padding-right="1mm">&#xA0;</fo:inline>
																		</xsl:if>
																	</xsl:for-each>
																</fo:block>
															</fo:table-cell>
															<fo:table-cell  display-align="center">
																<fo:block text-align="right">																	
																	<!-- Reference number -->
																	<fo:block>
																		<xsl:call-template name="getLocalizedString">
																			<xsl:with-param name="key">reference_number</xsl:with-param>																			
																		</xsl:call-template>
																	</fo:block>
																	<fo:block>
																		<xsl:value-of select="$ISOname"/>																		
																	</fo:block>
																	<fo:block>&#xA0;</fo:block>
																	<fo:block>&#xA0;</fo:block>
																	<fo:block><fo:inline font-size="9pt">©</fo:inline><xsl:value-of select="concat(' ISO ', iso:iso-standard/iso:bibdata/iso:copyright/iso:from)"/></fo:block>
																</fo:block>
															</fo:table-cell>
														</fo:table-row>
													</fo:table-body>
												</fo:table>
											</fo:block>
										</fo:table-cell>
									</fo:table-row>
								</fo:table-body>
							</fo:table>
						</fo:static-content>
						
						<xsl:choose>
							<!-- COVER PAGE for DIS document only -->
							<xsl:when test="$stage-abbreviation = 'DIS'">
								<fo:flow flow-name="xsl-region-body">
									<fo:block-container>
										<fo:block margin-top="-1mm" font-size="20pt" text-align="right">
											<xsl:value-of select="$stage-fullname-uppercased"/>
											<!-- <xsl:if test="$doctype = 'amendment'">
												<xsl:variable name="title-amendment">
													<xsl:call-template name="getTitle">
														<xsl:with-param name="name" select="'title-amendment'"/>
													</xsl:call-template>
												</xsl:variable>
												<xsl:text> </xsl:text><xsl:value-of select="$title-amendment"/>
											</xsl:if> -->
										</fo:block>
										<fo:block font-size="20pt" font-weight="bold" text-align="right">
											<xsl:value-of select="$docidentifierISO"/>
										</fo:block>
										
										
										<fo:table table-layout="fixed" width="100%" margin-top="18mm">
											<fo:table-column column-width="59.5mm"/>
											<fo:table-column column-width="52mm"/>
											<fo:table-column column-width="59mm"/>
											<fo:table-body>
												<fo:table-row>
													<fo:table-cell>
														<fo:block>&#xA0;</fo:block>
													</fo:table-cell>
													<fo:table-cell>
														<fo:block margin-bottom="3mm">ISO/TC <fo:inline font-weight="bold"><xsl:value-of select="/iso:iso-standard/iso:bibdata/iso:ext/iso:editorialgroup/iso:technical-committee/@number"/></fo:inline>
														</fo:block>
													</fo:table-cell>
													<fo:table-cell>
														<fo:block>Secretariat: <fo:inline font-weight="bold"><xsl:value-of select="/iso:iso-standard/iso:bibdata/iso:ext/iso:editorialgroup/iso:secretariat"/></fo:inline></fo:block>
													</fo:table-cell>
												</fo:table-row>
												<fo:table-row>
													<fo:table-cell>
														<fo:block>&#xA0;</fo:block>
													</fo:table-cell>
													<fo:table-cell>
														<fo:block>Voting begins on:</fo:block>
													</fo:table-cell>
													<fo:table-cell>
														<fo:block>Voting terminates on:</fo:block>
													</fo:table-cell>
												</fo:table-row>
												<fo:table-row>
													<fo:table-cell>
														<fo:block>&#xA0;</fo:block>
													</fo:table-cell>
													<fo:table-cell>
														<fo:block font-weight="bold">
															<xsl:choose>
																<xsl:when test="/iso:iso-standard/iso:bibdata/iso:date[@type = 'vote-started']/iso:on">
																	<xsl:value-of select="/iso:iso-standard/iso:bibdata/iso:date[@type = 'vote-started']/iso:on"/>
																</xsl:when>
																<xsl:otherwise>YYYY-MM-DD</xsl:otherwise>
															</xsl:choose>
														</fo:block>
													</fo:table-cell>
													<fo:table-cell>
														<fo:block font-weight="bold">
															<xsl:choose>
																<xsl:when test="/iso:iso-standard/iso:bibdata/iso:date[@type = 'vote-ended']/iso:on">
																	<xsl:value-of select="/iso:iso-standard/iso:bibdata/iso:date[@type = 'vote-ended']/iso:on"/>
																</xsl:when>
																<xsl:otherwise>YYYY-MM-DD</xsl:otherwise>
															</xsl:choose>
														</fo:block>
													</fo:table-cell>
												</fo:table-row>
											</fo:table-body>
										</fo:table>
										
										<fo:block-container border-top="1mm double black" line-height="1.1" margin-top="3mm">
											<fo:block margin-right="5mm">
												<fo:block font-size="18pt" font-weight="bold" margin-top="6pt">
													<xsl:if test="normalize-space($title-intro) != ''">
														<xsl:value-of select="$title-intro"/>
														<xsl:text> — </xsl:text>
													</xsl:if>
													
													<xsl:value-of select="$title-main"/>

													<xsl:call-template name="printTitlePartEn"/>
													
													<xsl:variable name="title-amd" select="/iso:iso-standard/iso:bibdata/iso:title[@language = 'en' and @type = 'title-amd']"/>
													<xsl:if test="$doctype = 'amendment' and normalize-space($title-amd) != ''">
														<fo:block margin-top="12pt">
															<xsl:call-template name="printAmendmentTitle"/>
														</fo:block>
													</xsl:if>
													
												</fo:block>
															
												<fo:block font-size="9pt"><xsl:value-of select="$linebreak"/></fo:block>
												<fo:block font-size="11pt" font-style="italic" line-height="1.5">
													
													<xsl:if test="normalize-space($title-intro-fr) != ''">
														<xsl:value-of select="$title-intro-fr"/>
														<xsl:text> — </xsl:text>
													</xsl:if>
													
													<xsl:value-of select="$title-main-fr"/>

													<xsl:call-template name="printTitlePartFr"/>
													
													<xsl:variable name="title-amd" select="/iso:iso-standard/iso:bibdata/iso:title[@language = 'fr' and @type = 'title-amd']"/>
														<xsl:if test="$doctype = 'amendment' and normalize-space($title-amd) != ''">
															<fo:block margin-top="6pt">
																<xsl:call-template name="printAmendmentTitle">
																	<xsl:with-param name="lang" select="'fr'"/>
																</xsl:call-template>
															</fo:block>
														</xsl:if>
													
												</fo:block>
											</fo:block>
											<fo:block margin-top="10mm">
												<xsl:for-each select="/iso:iso-standard/iso:bibdata/iso:ext/iso:ics/iso:code">
													<xsl:if test="position() = 1"><fo:inline>ICS: </fo:inline></xsl:if>
													<xsl:value-of select="."/>
													<xsl:if test="position() != last()"><xsl:text>; </xsl:text></xsl:if>
												</xsl:for-each>
											</fo:block>
										</fo:block-container>
										
										
									</fo:block-container>
								</fo:flow>
							
							</xsl:when>
							<xsl:otherwise>
						
								<!-- COVER PAGE  for all documents except DIS -->
								<fo:flow flow-name="xsl-region-body">
									<fo:block-container>
										<fo:table table-layout="fixed" width="100%" font-size="24pt" line-height="1"> <!-- margin-bottom="35mm" -->
											<fo:table-column column-width="59.5mm"/>
											<fo:table-column column-width="67.5mm"/>
											<fo:table-column column-width="45.5mm"/>
											<fo:table-body>
												<fo:table-row>
													<fo:table-cell>
														<fo:block font-size="18pt">
															
															<xsl:value-of select="translate($stagename-header-coverpage, ' ', $linebreak)"/>
															
															<!-- if there is iteration number, then print it -->
															<xsl:variable name="iteration" select="number(/iso:iso-standard/iso:bibdata/iso:status/iso:iteration)"/>	
															
															<xsl:if test="number($iteration) = $iteration and 
																																							($stage-abbreviation = 'NWIP' or 
																																							$stage-abbreviation = 'NP' or 
																																							$stage-abbreviation = 'PWI' or 
																																							$stage-abbreviation = 'AWI' or 
																																							$stage-abbreviation = 'WD' or 
																																							$stage-abbreviation = 'CD')">
																<xsl:text>&#xA0;</xsl:text><xsl:value-of select="$iteration"/>
															</xsl:if>
															<!-- <xsl:if test="$stage-name = 'draft'">DRAFT</xsl:if>
															<xsl:if test="$stage-name = 'final-draft'">FINAL<xsl:value-of select="$linebreak"/>DRAFT</xsl:if> -->
														</fo:block>
													</fo:table-cell>
													<fo:table-cell>
														<fo:block text-align="left">
															<xsl:choose>
																<xsl:when test="$doctype = 'amendment'">
																	<xsl:value-of select="java:toUpperCase(java:java.lang.String.new(translate(/iso:iso-standard/iso:bibdata/iso:ext/iso:updates-document-type,'-',' ')))"/>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:value-of select="$doctype_uppercased"/>
																</xsl:otherwise>
															</xsl:choose>
														</fo:block>
													</fo:table-cell>
													<fo:table-cell>
														<fo:block text-align="right" font-weight="bold" margin-bottom="13mm">
															<xsl:value-of select="$docidentifierISO"/>
														</fo:block>
													</fo:table-cell>
												</fo:table-row>
												<fo:table-row height="42mm">
													<fo:table-cell number-columns-spanned="3" font-size="10pt" line-height="1.2">
														<fo:block text-align="right">
															<xsl:if test="$stage-abbreviation = 'PRF' or 
																								$stage-abbreviation = 'IS' or 
																								$stage-abbreviation = 'D' or 
																								$stage-abbreviation = 'published'">
																<xsl:call-template name="printEdition"/>
															</xsl:if>
															<xsl:choose>
																<xsl:when test="$stage-abbreviation = 'IS' and /iso:iso-standard/iso:bibdata/iso:date[@type = 'published']">
																	<xsl:value-of select="$linebreak"/>
																	<xsl:value-of select="/iso:iso-standard/iso:bibdata/iso:date[@type = 'published']"/>
																</xsl:when>
																<xsl:when test="($stage-abbreviation = 'IS' or $stage-abbreviation = 'D') and /iso:iso-standard/iso:bibdata/iso:date[@type = 'created']">
																	<xsl:value-of select="$linebreak"/>
																	<xsl:value-of select="/iso:iso-standard/iso:bibdata/iso:date[@type = 'created']"/>
																</xsl:when>
																<xsl:when test="$stage-abbreviation = 'IS' or $stage-abbreviation = 'published'">
																	<xsl:value-of select="$linebreak"/>
																	<xsl:value-of select="substring(/iso:iso-standard/iso:bibdata/iso:version/iso:revision-date,1, 7)"/>
																</xsl:when>
															</xsl:choose>
														</fo:block>
														<!-- <xsl:value-of select="$linebreak"/>
														<xsl:value-of select="/iso:iso-standard/iso:bibdata/iso:version/iso:revision-date"/> -->
														<xsl:if test="$doctype = 'amendment'">
															<fo:block text-align="right" margin-right="0.5mm">
																<fo:block font-weight="bold" margin-top="4pt">
																	<xsl:variable name="title-amendment">
																		<xsl:call-template name="getTitle">
																			<xsl:with-param name="name" select="'title-amendment'"/>
																		</xsl:call-template>
																	</xsl:variable>
																	<xsl:value-of select="$title-amendment"/><xsl:text> </xsl:text>
																	<xsl:variable name="amendment-number" select="/iso:iso-standard/iso:bibdata/iso:ext/iso:structuredidentifier/iso:project-number/@amendment"/>
																	<xsl:if test="normalize-space($amendment-number) != ''">
																		<xsl:value-of select="$amendment-number"/><xsl:text> </xsl:text>
																	</xsl:if>
																</fo:block>
																<fo:block>
																	<xsl:if test="/iso:iso-standard/iso:bibdata/iso:date[@type = 'updated']">																		
																	<xsl:value-of select="/iso:iso-standard/iso:bibdata/iso:date[@type = 'updated']"/>
																	</xsl:if>
																</fo:block>
															</fo:block>
														</xsl:if>
													</fo:table-cell>
												</fo:table-row>
												
											</fo:table-body>
										</fo:table>
										
										
										<fo:table table-layout="fixed" width="100%">
											<fo:table-column column-width="52mm"/>
											<fo:table-column column-width="7.5mm"/>
											<fo:table-column column-width="112.5mm"/>
											<fo:table-body>
												<fo:table-row> <!--  border="1pt solid black" height="150mm"  -->
													<fo:table-cell font-size="11pt">
														<fo:block>
															<xsl:if test="$stage-abbreviation = 'FDIS'">
																<fo:block-container border="0.5mm solid black" width="51mm">
																	<fo:block margin="2mm">
																			<fo:block margin-bottom="8pt">ISO/TC <fo:inline font-weight="bold"><xsl:value-of select="/iso:iso-standard/iso:bibdata/iso:ext/iso:editorialgroup/iso:technical-committee/@number"/></fo:inline></fo:block>
																			<fo:block margin-bottom="6pt">Secretariat: <xsl:value-of select="/iso:iso-standard/iso:bibdata/iso:ext/iso:editorialgroup/iso:secretariat"/></fo:block>
																			<fo:block margin-bottom="6pt">Voting begins on:<xsl:value-of select="$linebreak"/>
																				<fo:inline font-weight="bold">
																					<xsl:choose>
																						<xsl:when test="/iso:iso-standard/iso:bibdata/iso:date[@type = 'vote-started']/iso:on">
																							<xsl:value-of select="/iso:iso-standard/iso:bibdata/iso:date[@type = 'vote-started']/iso:on"/>
																						</xsl:when>
																						<xsl:otherwise>YYYY-MM-DD</xsl:otherwise>
																					</xsl:choose>
																				</fo:inline>
																			</fo:block>
																			<fo:block>Voting terminates on:<xsl:value-of select="$linebreak"/>
																				<fo:inline font-weight="bold">
																					<xsl:choose>
																						<xsl:when test="/iso:iso-standard/iso:bibdata/iso:date[@type = 'vote-ended']/iso:on">
																							<xsl:value-of select="/iso:iso-standard/iso:bibdata/iso:date[@type = 'vote-ended']/iso:on"/>
																						</xsl:when>
																						<xsl:otherwise>YYYY-MM-DD</xsl:otherwise>
																					</xsl:choose>
																				</fo:inline>
																			</fo:block>
																	</fo:block>
																</fo:block-container>
															</xsl:if>
														</fo:block>
													</fo:table-cell>
													<fo:table-cell>
														<fo:block>&#xA0;</fo:block>
													</fo:table-cell>
													<fo:table-cell>
														<fo:block-container border-top="1mm double black" line-height="1.1">
															<fo:block margin-right="5mm">
																<fo:block font-size="18pt" font-weight="bold" margin-top="12pt">
																	
																	<xsl:if test="normalize-space($title-intro) != ''">
																		<xsl:value-of select="$title-intro"/>
																		<xsl:text> — </xsl:text>
																	</xsl:if>
																	
																	<xsl:value-of select="$title-main"/>
																	
																	<xsl:call-template name="printTitlePartEn"/>
																	<!-- <xsl:if test="normalize-space($title-part) != ''">
																		<xsl:if test="$part != ''">
																			<xsl:text> — </xsl:text>
																			<fo:block font-weight="normal" margin-top="6pt">
																				<xsl:text>Part </xsl:text><xsl:value-of select="$part"/>
																				<xsl:text>:</xsl:text>
																			</fo:block>
																		</xsl:if>
																		<xsl:value-of select="$title-part"/>
																	</xsl:if> -->
																	<xsl:variable name="title-amd" select="/iso:iso-standard/iso:bibdata/iso:title[@language = 'en' and @type = 'title-amd']"/>
																	<xsl:if test="$doctype = 'amendment' and normalize-space($title-amd) != ''">
																		<fo:block margin-right="-5mm" margin-top="12pt">
																			<xsl:call-template name="printAmendmentTitle"/>
																		</fo:block>
																	</xsl:if>
																</fo:block>
																			
																<fo:block font-size="9pt"><xsl:value-of select="$linebreak"/></fo:block>
																<fo:block font-size="11pt" font-style="italic" line-height="1.5">
																	
																	<xsl:if test="normalize-space($title-intro-fr) != ''">
																		<xsl:value-of select="$title-intro-fr"/>
																		<xsl:text> — </xsl:text>
																	</xsl:if>
																	
																	<xsl:value-of select="$title-main-fr"/>
																	
																	<xsl:call-template name="printTitlePartFr"/>
																	
																	<xsl:variable name="title-amd" select="/iso:iso-standard/iso:bibdata/iso:title[@language = 'fr' and @type = 'title-amd']"/>
																	<xsl:if test="$doctype = 'amendment' and normalize-space($title-amd) != ''">
																		<fo:block margin-right="-5mm" margin-top="6pt">
																			<xsl:call-template name="printAmendmentTitle">
																				<xsl:with-param name="lang" select="'fr'"/>
																			</xsl:call-template>
																		</fo:block>
																	</xsl:if>
																	
																</fo:block>
															</fo:block>
														</fo:block-container>
													</fo:table-cell>
												</fo:table-row>
											</fo:table-body>
										</fo:table>
									</fo:block-container>
									<fo:block-container position="absolute" left="60mm" top="222mm" height="25mm" display-align="after">
										<fo:block>
											<xsl:if test="$stage-abbreviation = 'PRF'">
												<fo:block font-size="39pt" font-weight="bold"><xsl:value-of select="$proof-text"/></fo:block>
											</xsl:if>
										</fo:block>
									</fo:block-container>
								</fo:flow>
						</xsl:otherwise>
						</xsl:choose>
						
						
					</fo:page-sequence>
				</xsl:when>
					
				<xsl:when test="$isPublished = 'true'">
					<fo:page-sequence master-reference="cover-page-published" force-page-count="no-force">
						<fo:static-content flow-name="cover-page-footer" font-size="10pt">
							<fo:table table-layout="fixed" width="100%" border-top="1mm double black" margin-bottom="3mm">
								<fo:table-column column-width="50%"/>
								<fo:table-column column-width="50%"/>
								<fo:table-body>
									<fo:table-row height="32mm">
										<fo:table-cell display-align="center">
											<fo:block text-align="left">
												<fo:external-graphic src="{concat('data:image/png;base64,', normalize-space($Image-ISO-Logo2))}" width="21mm" content-height="21mm" content-width="scale-to-fit" scaling="uniform" fox:alt-text="Image {@alt}"/>
											</fo:block>
										</fo:table-cell>
										<fo:table-cell  display-align="center">
											<fo:block text-align="right">												
												<fo:block>
													<xsl:call-template name="getLocalizedString">
														<xsl:with-param name="key">reference_number</xsl:with-param>																			
													</xsl:call-template>
												</fo:block>
												<fo:block><xsl:value-of select="$ISOname"/></fo:block>
												<fo:block>&#xA0;</fo:block>
												<fo:block>&#xA0;</fo:block>
												<fo:block><fo:inline font-size="9pt">©</fo:inline><xsl:value-of select="concat(' ISO ', iso:iso-standard/iso:bibdata/iso:copyright/iso:from)"/></fo:block>
											</fo:block>
										</fo:table-cell>
									</fo:table-row>
								</fo:table-body>
							</fo:table>
						</fo:static-content>
						<fo:flow flow-name="xsl-region-body">
							<fo:block-container>
								<fo:table table-layout="fixed" width="100%" font-size="24pt" line-height="1" margin-bottom="35mm">
									<fo:table-column column-width="60%"/>
									<fo:table-column column-width="40%"/>
									<fo:table-body>
										<fo:table-row>
											<fo:table-cell>
												<fo:block text-align="left">
													<xsl:value-of select="$doctype_uppercased"/>
												</fo:block>
											</fo:table-cell>
											<fo:table-cell>
												<fo:block text-align="right" font-weight="bold" margin-bottom="13mm">
													<xsl:value-of select="$docidentifierISO"/>
												</fo:block>
											</fo:table-cell>
										</fo:table-row>
										<fo:table-row>
											<fo:table-cell number-columns-spanned="2" font-size="10pt" line-height="1.2">
												<fo:block text-align="right">
													<xsl:call-template name="printEdition"/>
													<xsl:value-of select="$linebreak"/>
													<xsl:value-of select="/iso:iso-standard/iso:bibdata/iso:version/iso:revision-date"/></fo:block>
											</fo:table-cell>
										</fo:table-row>
									</fo:table-body>
								</fo:table>
								
								<fo:block-container border-top="1mm double black" line-height="1.1">
									<fo:block margin-right="40mm">
									<fo:block font-size="18pt" font-weight="bold" margin-top="12pt">
									
										<xsl:if test="normalize-space($title-intro) != ''">
											<xsl:value-of select="$title-intro"/>
											<xsl:text> — </xsl:text>
										</xsl:if>
										
										<xsl:value-of select="$title-main"/>
										
										<xsl:call-template name="printTitlePartEn"/>
										<!-- <xsl:if test="normalize-space($title-part) != ''">
											<xsl:if test="$part != ''">
												<xsl:text> — </xsl:text>
												<fo:block font-weight="normal" margin-top="6pt">
													<xsl:text>Part </xsl:text><xsl:value-of select="$part"/>
													<xsl:text>:</xsl:text>
												</fo:block>
											</xsl:if>
											<xsl:value-of select="$title-part"/>
										</xsl:if> -->
									</fo:block>
												
									<fo:block font-size="9pt"><xsl:value-of select="$linebreak"/></fo:block>
									<fo:block font-size="11pt" font-style="italic" line-height="1.5">
										
										<xsl:if test="normalize-space($title-intro-fr) != ''">
											<xsl:value-of select="$title-intro-fr"/>
											<xsl:text> — </xsl:text>
										</xsl:if>
										
										<xsl:value-of select="$title-main-fr"/>

										<xsl:call-template name="printTitlePartFr"/>
										
									</fo:block>
									</fo:block>
								</fo:block-container>
							</fo:block-container>
						</fo:flow>
					</fo:page-sequence>
				</xsl:when>
				<xsl:otherwise>
					<fo:page-sequence master-reference="cover-page" force-page-count="no-force">
						<fo:static-content flow-name="cover-page-header" font-size="10pt">
							<fo:block-container height="24mm" display-align="before">
								<fo:block padding-top="12.5mm">
									<xsl:value-of select="$copyrightText"/>
								</fo:block>
							</fo:block-container>
						</fo:static-content>
						<fo:flow flow-name="xsl-region-body">
							<fo:block-container text-align="right">
								<xsl:choose>
									<xsl:when test="/iso:iso-standard/iso:bibdata/iso:docidentifier[@type = 'iso-tc']">
										<!-- 17301  -->
										<fo:block font-size="14pt" font-weight="bold" margin-bottom="12pt">
											<xsl:value-of select="/iso:iso-standard/iso:bibdata/iso:docidentifier[@type = 'iso-tc']"/>
										</fo:block>
										<!-- Date: 2016-05-01  -->
										<fo:block margin-bottom="12pt">
											<xsl:text>Date: </xsl:text><xsl:value-of select="/iso:iso-standard/iso:bibdata/iso:version/iso:revision-date"/>
										</fo:block>
									
										<!-- ISO/CD 17301-1(E)  -->
										<fo:block margin-bottom="12pt">
											<xsl:value-of select="concat(/iso:iso-standard/iso:bibdata/iso:docidentifier, $lang-1st-letter)"/>
										</fo:block>
									</xsl:when>
									<xsl:otherwise>
										<fo:block font-size="14pt" font-weight="bold" margin-bottom="12pt">
											<!-- ISO/WD 24229(E)  -->
											<xsl:value-of select="concat(/iso:iso-standard/iso:bibdata/iso:docidentifier, $lang-1st-letter)"/>
										</fo:block>
										
									</xsl:otherwise>
								</xsl:choose>
								
								<!-- ISO/TC 46/WG 3  -->
										<!-- <fo:block margin-bottom="12pt">
											<xsl:value-of select="concat('ISO/', /iso:iso-standard/iso:bibdata/iso:ext/iso:editorialgroup/iso:technical-committee/@type, ' ',
																																				/iso:iso-standard/iso:bibdata/iso:ext/iso:editorialgroup/iso:technical-committee/@number, '/', 
																																				/iso:iso-standard/iso:bibdata/iso:ext/iso:editorialgroup/iso:workgroup/@type, ' ',
																																				/iso:iso-standard/iso:bibdata/iso:ext/iso:editorialgroup/iso:workgroup/@number)"/>
								 -->
								<!-- ISO/TC 34/SC 4/WG 3 -->
								<fo:block margin-bottom="12pt">
									<xsl:text>ISO</xsl:text>
									<xsl:for-each select="/iso:iso-standard/iso:bibdata/iso:ext/iso:editorialgroup/iso:technical-committee[@number]">
										<xsl:text>/TC </xsl:text><xsl:value-of select="@number"/>
									</xsl:for-each>
									<xsl:for-each select="/iso:iso-standard/iso:bibdata/iso:ext/iso:editorialgroup/iso:subcommittee[@number]">
										<xsl:text>/SC </xsl:text>
										<xsl:value-of select="@number"/>
									</xsl:for-each>
									<xsl:for-each select="/iso:iso-standard/iso:bibdata/iso:ext/iso:editorialgroup/iso:workgroup[@number]">
										<xsl:text>/WG </xsl:text>
										<xsl:value-of select="@number"/>
									</xsl:for-each>
								</fo:block>
								
								<!-- Secretariat: AFNOR  -->
								
								<fo:block margin-bottom="100pt">
									<xsl:text>Secretariat: </xsl:text>
									<xsl:value-of select="/iso:iso-standard/iso:bibdata/iso:ext/iso:editorialgroup/iso:secretariat"/>
									<xsl:text>&#xA0;</xsl:text>
								</fo:block>
									
								
								
								</fo:block-container>
							<fo:block-container font-size="16pt">
								<!-- Information and documentation — Codes for transcription systems  -->
									<fo:block font-weight="bold">
									
										<xsl:if test="normalize-space($title-intro) != ''">
											<xsl:value-of select="$title-intro"/>
											<xsl:text> — </xsl:text>
										</xsl:if>
										
										<xsl:value-of select="$title-main"/>
										
										<xsl:call-template name="printTitlePartEn"/>
										<!-- <xsl:if test="normalize-space($title-part) != ''">
											<xsl:if test="$part != ''">
												<xsl:text> — </xsl:text>
												<fo:block font-weight="normal" margin-top="6pt">
													<xsl:text>Part </xsl:text><xsl:value-of select="$part"/>
													<xsl:text>:</xsl:text>
												</fo:block>
											</xsl:if>
											<xsl:value-of select="$title-part"/>
										</xsl:if> -->
									</fo:block>
									
									<fo:block font-size="12pt"><xsl:value-of select="$linebreak"/></fo:block>
									<fo:block>
										<xsl:if test="normalize-space($title-intro-fr) != ''">
											<xsl:value-of select="$title-intro-fr"/>
											<xsl:text> — </xsl:text>
										</xsl:if>
										
										<xsl:value-of select="$title-main-fr"/>
										
										<xsl:variable name="part-fr" select="/iso:iso-standard/iso:bibdata/iso:title[@language = 'fr' and @type = 'title-part']"/>
										<xsl:if test="normalize-space($part-fr) != ''">
											<xsl:if test="$part != ''">
												<xsl:text> — </xsl:text>
												<fo:block margin-top="6pt" font-weight="normal">
													<xsl:value-of select="java:replaceAll(java:java.lang.String.new($titles/title-part[@lang='fr']),'#',$part)"/>
													<!-- <xsl:value-of select="$title-part-fr"/><xsl:value-of select="$part"/>
													<xsl:text>:</xsl:text> -->
												</fo:block>
											</xsl:if>
											<xsl:value-of select="$part-fr"/>
										</xsl:if>
									</fo:block>
							</fo:block-container>
							<fo:block font-size="11pt" margin-bottom="8pt"><xsl:value-of select="$linebreak"/></fo:block>
							<fo:block-container font-size="40pt" text-align="center" margin-bottom="12pt" border="0.5pt solid black">
								<xsl:variable name="stage-title" select="substring-after(substring-before($docidentifierISO, ' '), '/')"/>
								<fo:block padding-top="2mm"><xsl:value-of select="$stage-title"/><xsl:text> stage</xsl:text></fo:block>
							</fo:block-container>
							<fo:block><xsl:value-of select="$linebreak"/></fo:block>
							
							<xsl:if test="/iso:iso-standard/iso:boilerplate/iso:license-statement">
								<fo:block-container font-size="10pt" margin-top="12pt" margin-bottom="6pt" border="0.5pt solid black">
									<fo:block padding-top="1mm">
										<xsl:apply-templates select="/iso:iso-standard/iso:boilerplate/iso:license-statement"/>
									</fo:block>
								</fo:block-container>
							</xsl:if>
						</fo:flow>
					</fo:page-sequence>
				</xsl:otherwise>
			</xsl:choose>	
			
			<fo:page-sequence master-reference="preface{$document-master-reference}" format="i" force-page-count="{$force-page-count-preface}">
				<xsl:call-template name="insertHeaderFooter">
					<xsl:with-param name="font-weight">normal</xsl:with-param>
				</xsl:call-template>
				<fo:flow flow-name="xsl-region-body" line-height="115%">
					<xsl:if test="/iso:iso-standard/iso:boilerplate/iso:copyright-statement">
					
						<fo:block-container height="252mm" display-align="after">
							<!-- <fo:block margin-bottom="3mm">
								<fo:external-graphic src="{concat('data:image/png;base64,', normalize-space($Image-Attention))}" width="14mm" content-height="13mm" content-width="scale-to-fit" scaling="uniform" fox:alt-text="Image {@alt}"/>								
								<fo:inline padding-left="6mm" font-size="12pt" font-weight="bold"></fo:inline>
							</fo:block> -->
							<fo:block line-height="90%">
								<fo:block font-size="9pt" text-align="justify">
									<xsl:apply-templates select="/iso:iso-standard/iso:boilerplate/iso:copyright-statement"/>
								</fo:block>
							</fo:block>
						</fo:block-container>						
					</xsl:if>
					
					
					<xsl:choose>
						<xsl:when test="$doctype = 'amendment'"></xsl:when><!-- ToC shouldn't be generated in amendments. -->
						
						<xsl:otherwise>
							<xsl:if test="/iso:iso-standard/iso:boilerplate/iso:copyright-statement">
								<fo:block break-after="page"/>
							</xsl:if>
							<fo:block-container font-weight="bold">
								
								<fo:block text-align-last="justify" font-size="16pt" margin-top="10pt" margin-bottom="18pt">
									<xsl:variable name="title-toc">
										<xsl:call-template name="getTitle">
											<xsl:with-param name="name" select="'title-toc'"/>
										</xsl:call-template>
									</xsl:variable>
									<fo:inline font-size="16pt" font-weight="bold"><xsl:value-of select="$title-toc"/></fo:inline>
									<fo:inline keep-together.within-line="always">
										<fo:leader leader-pattern="space"/>
										<xsl:variable name="title-page">
											<xsl:call-template name="getTitle">
												<xsl:with-param name="name" select="'title-page'"/>
											</xsl:call-template>
										</xsl:variable>
										<fo:inline font-weight="normal" font-size="10pt"><xsl:value-of select="$title-page"/></fo:inline>
									</fo:inline>
								</fo:block>
								
								<xsl:if test="$debug = 'true'">
									<xsl:text disable-output-escaping="yes">&lt;!--</xsl:text>
										DEBUG
										contents=<xsl:copy-of select="xalan:nodeset($contents)"/>
									<xsl:text disable-output-escaping="yes">--&gt;</xsl:text>
								</xsl:if>
								
								<xsl:variable name="margin-left">12</xsl:variable>
								<xsl:for-each select="xalan:nodeset($contents)//item[@display = 'true']"><!-- [not(@level = 2 and starts-with(@section, '0'))] skip clause from preface -->
									
									<fo:block>
										<xsl:if test="@level = 1">
											<xsl:attribute name="margin-top">5pt</xsl:attribute>
										</xsl:if>
										<xsl:if test="@level = 3">
											<xsl:attribute name="margin-top">-0.7pt</xsl:attribute>
										</xsl:if>
										<fo:list-block>
											<xsl:attribute name="margin-left"><xsl:value-of select="$margin-left * (@level - 1)"/>mm</xsl:attribute>
											<xsl:if test="@level &gt;= 2 or @type = 'annex'">
												<xsl:attribute name="font-weight">normal</xsl:attribute>
											</xsl:if>
											<xsl:attribute name="provisional-distance-between-starts">
												<xsl:choose>
													<!-- skip 0 section without subsections -->
													<xsl:when test="@level &gt;= 3"><xsl:value-of select="$margin-left * 1.2"/>mm</xsl:when>
													<xsl:when test="@section != ''"><xsl:value-of select="$margin-left"/>mm</xsl:when>
													<xsl:otherwise>0mm</xsl:otherwise>
												</xsl:choose>
											</xsl:attribute>
											<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
													<fo:block>														
															<xsl:value-of select="@section"/>														
													</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()">
													<fo:block text-align-last="justify" margin-left="12mm" text-indent="-12mm">
														<fo:basic-link internal-destination="{@id}" fox:alt-text="{title}">
														
															<xsl:apply-templates select="title"/>
															
															<fo:inline keep-together.within-line="always">
																<fo:leader font-size="9pt" font-weight="normal" leader-pattern="dots"/>
																<fo:inline><fo:page-number-citation ref-id="{@id}"/></fo:inline>
															</fo:inline>
														</fo:basic-link>
													</fo:block>
												</fo:list-item-body>
											</fo:list-item>
										</fo:list-block>
									</fo:block>
									
								</xsl:for-each>
							</fo:block-container>
						</xsl:otherwise>
					</xsl:choose>
					
					<!-- Foreword, Introduction -->					
					<xsl:call-template name="processPrefaceSectionsDefault"/>
						
				</fo:flow>
			</fo:page-sequence>
			
			<!-- BODY -->
			<fo:page-sequence master-reference="document{$document-master-reference}" initial-page-number="1" force-page-count="no-force">
				<fo:static-content flow-name="xsl-footnote-separator">
					<fo:block>
						<fo:leader leader-pattern="rule" leader-length="30%"/>
					</fo:block>
				</fo:static-content>
				<xsl:call-template name="insertHeaderFooter"/>
				<fo:flow flow-name="xsl-region-body">
				
					
					<fo:block-container>
						<!-- Information and documentation — Codes for transcription systems -->
						<!-- <fo:block font-size="16pt" font-weight="bold" margin-bottom="18pt">
							<xsl:value-of select="$title-en"/>
						</fo:block>
						 -->
						<fo:block font-size="18pt" font-weight="bold" margin-top="40pt" margin-bottom="20pt" line-height="1.1">
						
							<xsl:variable name="title-part-doc-lang" select="/iso:iso-standard/iso:bibdata/iso:title[@language = $lang and @type = 'title-part']"/>
							
							<xsl:variable name="title-intro-doc-lang" select="/iso:iso-standard/iso:bibdata/iso:title[@language = $lang and @type = 'title-intro']"/>
							
							<fo:block>
								<xsl:if test="normalize-space($title-intro-doc-lang) != ''">
									<xsl:value-of select="$title-intro-doc-lang"/>
									<xsl:text> — </xsl:text>
								</xsl:if>
								
								<xsl:variable name="title-main-doc-lang" select="/iso:iso-standard/iso:bibdata/iso:title[@language = $lang and @type = 'title-main']"/>
								
								<xsl:value-of select="$title-main-doc-lang"/>
								
								<xsl:if test="normalize-space($title-part-doc-lang) != ''">
									<xsl:if test="$part != ''">
										<xsl:text> — </xsl:text>
										<fo:block font-weight="normal" margin-top="12pt" line-height="1.1">											
											<xsl:value-of select="java:replaceAll(java:java.lang.String.new($titles/title-part[@lang=$lang]),'#',$part)"/>											
											<!-- <xsl:value-of select="$title-part-en"/>
											<xsl:value-of select="$part"/>
											<xsl:text>:</xsl:text> -->
										</fo:block>
									</xsl:if>
								</xsl:if>
							</fo:block>
							<fo:block>
								<xsl:value-of select="$title-part-doc-lang"/>
							</fo:block>
							
							<xsl:variable name="title-amd" select="/iso:iso-standard/iso:bibdata/iso:title[@language = $lang and @type = 'title-amd']"/>
							<xsl:if test="$doctype = 'amendment' and normalize-space($title-amd) != ''">
								<fo:block margin-top="12pt">
									<xsl:call-template name="printAmendmentTitle"/>
								</fo:block>
							</xsl:if>
						
						</fo:block>
					
					</fo:block-container>
					<!-- Clause(s) -->
					<fo:block>
						
						<xsl:choose>
							<xsl:when test="$doctype = 'amendment'">
								<xsl:apply-templates select="/iso:iso-standard/iso:sections/*"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="processMainSectionsDefault"/>
							</xsl:otherwise>
						</xsl:choose>
						
						<fo:block id="lastBlock" font-size="1pt">&#xA0;</fo:block>
					</fo:block>
					
				</fo:flow>
			</fo:page-sequence>
			
			<xsl:if test="$isPublished = 'true'">
				<fo:page-sequence master-reference="last-page" force-page-count="no-force">
					<xsl:call-template name="insertHeaderEven"/>
					<fo:static-content flow-name="last-page-footer" font-size="10pt">
						<fo:table table-layout="fixed" width="100%">
							<fo:table-column column-width="33%"/>
							<fo:table-column column-width="33%"/>
							<fo:table-column column-width="34%"/>
							<fo:table-body>
								<fo:table-row>
									<fo:table-cell display-align="center">
										<fo:block font-size="9pt"><xsl:value-of select="$copyrightText"/></fo:block>
									</fo:table-cell>
									<fo:table-cell>
										<fo:block font-size="11pt" font-weight="bold" text-align="center">
											<xsl:if test="$stage-abbreviation = 'PRF'">
												<xsl:value-of select="$proof-text"/>
											</xsl:if>
										</fo:block>
									</fo:table-cell>
									<fo:table-cell>
										<fo:block>&#xA0;</fo:block>
									</fo:table-cell>
								</fo:table-row>
							</fo:table-body>
						</fo:table>
					</fo:static-content>
					<fo:flow flow-name="xsl-region-body">
						<fo:block-container height="252mm" display-align="after">
							<fo:block-container border-top="1mm double black">
								<fo:block font-size="12pt" font-weight="bold" padding-top="3.5mm" padding-bottom="0.5mm">
									<xsl:for-each select="/iso:iso-standard/iso:bibdata/iso:ext/iso:ics/iso:code">
										<xsl:if test="position() = 1"><fo:inline>ICS&#xA0;&#xA0;</fo:inline></xsl:if>
										<xsl:value-of select="."/>
										<xsl:if test="position() != last()"><xsl:text>; </xsl:text></xsl:if>
									</xsl:for-each>&#xA0;
									<!-- <xsl:choose>
										<xsl:when test="$stage-name = 'FDIS'">ICS&#xA0;&#xA0;01.140.30</xsl:when>
										<xsl:when test="$stage-name = 'PRF'">ICS&#xA0;&#xA0;35.240.63</xsl:when>
										<xsl:when test="$stage-name = 'published'">ICS&#xA0;&#xA0;35.240.30</xsl:when>
										<xsl:otherwise>ICS&#xA0;&#xA0;67.060</xsl:otherwise>
									</xsl:choose> -->
									</fo:block>
								<xsl:if test="/iso:iso-standard/iso:bibdata/iso:keyword">
									<fo:block font-size="9pt" margin-bottom="6pt">
										<xsl:variable name="title-descriptors">
											<xsl:call-template name="getTitle">
												<xsl:with-param name="name" select="'title-descriptors'"/>
											</xsl:call-template>
										</xsl:variable>
										<fo:inline font-weight="bold"><xsl:value-of select="$title-descriptors"/>: </fo:inline>
										<xsl:call-template name="insertKeywords">
											<xsl:with-param name="sorting">no</xsl:with-param>
										</xsl:call-template>
									</fo:block>
								</xsl:if>
								<xsl:variable name="countPages"></xsl:variable>
								<xsl:variable name="price_based_on">
									<xsl:call-template name="getLocalizedString">
										<xsl:with-param name="key">price_based_on</xsl:with-param>
									</xsl:call-template>
								</xsl:variable>
								<xsl:variable name="price_based_on_items">
									<xsl:call-template name="split">
										<xsl:with-param name="pText" select="$price_based_on"/>
										<xsl:with-param name="sep" select="'%'"/>
										<xsl:with-param name="normalize-space">false</xsl:with-param>
									</xsl:call-template>
								</xsl:variable>
								<!-- Price based on ... pages -->
								<fo:block font-size="9pt">
									<xsl:for-each select="xalan:nodeset($price_based_on_items)/item">
										<xsl:value-of select="."/>
										<xsl:if test="position() != last()">
											<fo:page-number-citation ref-id="lastBlock"/>
										</xsl:if>										
									</xsl:for-each>
								</fo:block>
							</fo:block-container>
						</fo:block-container>
					</fo:flow>
				</fo:page-sequence>
			</xsl:if>
		</fo:root>
	</xsl:template> 


	<xsl:template match="node()">		
		<xsl:apply-templates />			
	</xsl:template>
	
	<xsl:template name="printAmendmentTitle">
		<xsl:param name="lang" select="'en'"/>
		<xsl:variable name="title-amd" select="/iso:iso-standard/iso:bibdata/iso:title[@language = $lang and @type = 'title-amd']"/>
		<xsl:if test="$doctype = 'amendment' and normalize-space($title-amd) != ''">
			<fo:block font-weight="normal" line-height="1.1">
				<xsl:variable name="title-amendment">
					<xsl:call-template name="getTitle">
						<xsl:with-param name="name" select="'title-amendment'"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:value-of select="$title-amendment"/>
				<xsl:variable name="amendment-number" select="/iso:iso-standard/iso:bibdata/iso:ext/iso:structuredidentifier/iso:project-number/@amendment"/>
				<xsl:if test="normalize-space($amendment-number) != ''">
					<xsl:text> </xsl:text><xsl:value-of select="$amendment-number"/>
				</xsl:if>
				<xsl:text>: </xsl:text>
				<xsl:value-of select="$title-amd"/>
			</fo:block>
		</xsl:if>
	</xsl:template>
	
	<!-- ============================= -->
	<!-- CONTENTS                                       -->
	<!-- ============================= -->
	<xsl:template match="node()" mode="contents">		
		<xsl:apply-templates mode="contents" />			
	</xsl:template>

	<!-- element with title -->
	<xsl:template match="*[*[local-name()='title']]" mode="contents"> <!-- iso:title -->
		<xsl:variable name="level">
			<xsl:call-template name="getLevel">
				<xsl:with-param name="depth" select="*[local-name()='title']/@depth"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="section">
			<xsl:call-template name="getSection"/>
		</xsl:variable>
		
		<xsl:variable name="type">
			<xsl:value-of select="local-name()"/>
		</xsl:variable>
			
		<xsl:variable name="display">
			<xsl:choose>				
				<xsl:when test="ancestor-or-self::*[local-name()='annex'] and $level &gt;= 2">false</xsl:when>
				<xsl:when test="$section = '' and $type = 'clause'">false</xsl:when>
				<xsl:when test="$level &lt;= 3">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="skip">
			<xsl:choose>
				<xsl:when test="ancestor-or-self::*[local-name()='bibitem']">true</xsl:when>
				<xsl:when test="ancestor-or-self::*[local-name()='term']">true</xsl:when>				
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		
		<xsl:if test="$skip = 'false'">		
		
			<xsl:variable name="title">
				<xsl:call-template name="getName"/>
			</xsl:variable>
			
			<xsl:variable name="root">
				<xsl:if test="ancestor-or-self::*[local-name()='preface']">preface</xsl:if>
				<xsl:if test="ancestor-or-self::*[local-name()='annex']">annex</xsl:if>
			</xsl:variable>
			
			<item id="{@id}" level="{$level}" section="{$section}" type="{$type}" root="{$root}" display="{$display}">
				<title>
					<xsl:apply-templates select="xalan:nodeset($title)" mode="contents_item"/>
				</title>
				<xsl:apply-templates  mode="contents" />
			</item>
		</xsl:if>
	</xsl:template>
	


	<xsl:template name="getListItemFormat">
		<xsl:choose>
			<xsl:when test="local-name(..) = 'ul'">&#x2014;</xsl:when> <!-- dash -->
			<xsl:otherwise> <!-- for ordered lists -->
				<xsl:choose>
					<xsl:when test="../@type = 'arabic'">
						<xsl:number format="1." lang="en"/>
					</xsl:when>
					<xsl:when test="../@type = 'alphabet'">
						<xsl:number format="a)" lang="en"/>
					</xsl:when>
					<xsl:when test="../@type = 'alphabet_upper'">
						<xsl:number format="A." lang="en"/>
					</xsl:when>
					<xsl:when test="../@type = 'roman'">
						<xsl:number format="i)"/>
					</xsl:when>
					<xsl:when test="../@type = 'roman_upper'">
						<xsl:number format="I."/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:number format="a)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	
	<!-- ============================= -->
	<!-- ============================= -->
	
	
	<xsl:template match="iso:license-statement//iso:title">
		<fo:block text-align="center" font-weight="bold">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="iso:license-statement//iso:p">
		<fo:block margin-left="1.5mm" margin-right="1.5mm">
			<xsl:if test="following-sibling::iso:p">
				<xsl:attribute name="margin-top">6pt</xsl:attribute>
				<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<!-- <fo:block margin-bottom="12pt">© ISO 2019, Published in Switzerland.</fo:block>
			<fo:block font-size="10pt" margin-bottom="12pt">All rights reserved. Unless otherwise specified, no part of this publication may be reproduced or utilized otherwise in any form or by any means, electronic or mechanical, including photocopying, or posting on the internet or an intranet, without prior written permission. Permission can be requested from either ISO at the address below or ISO’s member body in the country of the requester.</fo:block>
			<fo:block font-size="10pt" text-indent="7.1mm">
				<fo:block>ISO copyright office</fo:block>
				<fo:block>Ch. de Blandonnet 8 • CP 401</fo:block>
				<fo:block>CH-1214 Vernier, Geneva, Switzerland</fo:block>
				<fo:block>Tel.  + 41 22 749 01 11</fo:block>
				<fo:block>Fax  + 41 22 749 09 47</fo:block>
				<fo:block>copyright@iso.org</fo:block>
				<fo:block>www.iso.org</fo:block>
			</fo:block> -->
	
	<xsl:template match="iso:copyright-statement/iso:clause[1]/iso:title">
		<fo:block margin-bottom="3mm">
				<fo:external-graphic src="{concat('data:image/png;base64,', normalize-space($Image-Attention))}" width="14mm" content-height="13mm" content-width="scale-to-fit" scaling="uniform" fox:alt-text="Image {@alt}"/>
				<!-- <fo:inline padding-left="6mm" font-size="12pt" font-weight="bold">COPYRIGHT PROTECTED DOCUMENT</fo:inline> -->
				<fo:inline padding-left="6mm" font-size="12pt" font-weight="bold"><xsl:apply-templates /></fo:inline>
			</fo:block>
	</xsl:template>
	
	<xsl:template match="iso:copyright-statement//iso:p">
		<fo:block>
			<xsl:if test="preceding-sibling::iso:p">
				<!-- <xsl:attribute name="font-size">10pt</xsl:attribute> -->
			</xsl:if>
			<xsl:if test="following-sibling::iso:p">
				<!-- <xsl:attribute name="margin-bottom">12pt</xsl:attribute> -->
				<xsl:attribute name="margin-bottom">3pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="contains(@id, 'address')"> <!-- not(following-sibling::iso:p) -->
				<!-- <xsl:attribute name="margin-left">7.1mm</xsl:attribute> -->
				<xsl:attribute name="margin-left">4mm</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	


	
	<!-- ====== -->
	<!-- title      -->
	<!-- ====== -->
	
	<xsl:template match="iso:annex/iso:title">
		<xsl:choose>
			<xsl:when test="$doctype = 'amendment'">
				<xsl:call-template name="titleAmendment"/>				
			</xsl:when>
			<xsl:otherwise>
				<fo:block font-size="16pt" text-align="center" margin-bottom="48pt" keep-with-next="always">
					<xsl:apply-templates />
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- Bibliography -->
	<xsl:template match="iso:references[not(@normative='true')]/iso:title">
		<xsl:choose>
			<xsl:when test="$doctype = 'amendment'">
				<xsl:call-template name="titleAmendment"/>				
			</xsl:when>
			<xsl:otherwise>
				<fo:block font-size="16pt" font-weight="bold" text-align="center" margin-top="6pt" margin-bottom="36pt" keep-with-next="always">
					<xsl:apply-templates />
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="iso:title">
	
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		
		<xsl:variable name="font-size">
			<xsl:choose>
				<xsl:when test="ancestor::iso:annex and $level = 2">13pt</xsl:when>
				<xsl:when test="ancestor::iso:annex and $level = 3">12pt</xsl:when>
				<xsl:when test="ancestor::iso:preface">16pt</xsl:when>
				<xsl:when test="$level = 2">12pt</xsl:when>
				<xsl:when test="$level &gt;= 3">11pt</xsl:when>
				<xsl:otherwise>13pt</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="element-name">
			<xsl:choose>
				<xsl:when test="../@inline-header = 'true'">fo:inline</xsl:when>
				<xsl:otherwise>fo:block</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="$doctype = 'amendment' and not(ancestor::iso:preface)">
				<fo:block font-size="11pt" font-style="italic" margin-bottom="12pt" keep-with-next="always">
					<xsl:apply-templates />
				</fo:block>
			</xsl:when>
			
			<xsl:otherwise>
				<xsl:element name="{$element-name}">
					<xsl:attribute name="font-size"><xsl:value-of select="$font-size"/></xsl:attribute>
					<xsl:attribute name="font-weight">bold</xsl:attribute>
					<xsl:attribute name="margin-top"> <!-- margin-top -->
						<xsl:choose>
							<xsl:when test="ancestor::iso:preface">8pt</xsl:when>
							<xsl:when test="$level = 2 and ancestor::iso:annex">18pt</xsl:when>
							<xsl:when test="$level = 1">18pt</xsl:when>
							<xsl:when test="$level &gt;= 3">3pt</xsl:when>
							<xsl:when test="$level = ''">6pt</xsl:when><!-- 13.5pt -->
							<xsl:otherwise>12pt</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="margin-bottom">
						<xsl:choose>
							<xsl:when test="ancestor::iso:preface">18pt</xsl:when>
							<!-- <xsl:otherwise>12pt</xsl:otherwise> -->
							<xsl:otherwise>8pt</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="keep-with-next">always</xsl:attribute>		
					<xsl:if test="$element-name = 'fo:inline'">
						<xsl:choose>
							<xsl:when test="$lang = 'zh'">
								<xsl:value-of select="$tab_zh"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="padding-right">2mm</xsl:attribute>
							</xsl:otherwise>
						</xsl:choose>						
					</xsl:if>
					<xsl:apply-templates />
				</xsl:element>
				
				<xsl:if test="$element-name = 'fo:inline' and not(following-sibling::iso:p)">
					<fo:block > <!-- margin-bottom="12pt" -->
						<xsl:value-of select="$linebreak"/>
					</fo:block>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
	<xsl:template name="titleAmendment">
		<!-- <xsl:variable name="id">
			<xsl:call-template name="getId"/>
		</xsl:variable> id="{$id}"  -->
		<fo:block font-size="11pt" font-style="italic" margin-bottom="12pt" keep-with-next="always">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<!-- ====== -->
	<!-- ====== -->

	
	<xsl:template match="*[local-name()='p']">
		<xsl:param name="inline" select="'false'"/>
		<xsl:variable name="previous-element" select="local-name(preceding-sibling::*[1])"/>
		<xsl:variable name="element-name">
			<xsl:choose>
				<xsl:when test="$inline = 'true'">fo:inline</xsl:when>
				<xsl:when test="../@inline-header = 'true' and $previous-element = 'title'">fo:inline</xsl:when> <!-- first paragraph after inline title -->
				<xsl:when test="local-name(..) = 'admonition'">fo:inline</xsl:when>
				<xsl:otherwise>fo:block</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:element name="{$element-name}">
			<xsl:attribute name="text-align">
				<xsl:choose>
					<!-- <xsl:when test="ancestor::iso:preface">justify</xsl:when> -->
					<xsl:when test="@align"><xsl:value-of select="@align"/></xsl:when>
					<xsl:when test="ancestor::*[local-name()='td']/@align"><xsl:value-of select="ancestor::*[local-name()='td']/@align"/></xsl:when>
					<xsl:when test="ancestor::*[local-name()='th']/@align"><xsl:value-of select="ancestor::*[local-name()='th']/@align"/></xsl:when>
					<xsl:otherwise>justify</xsl:otherwise><!-- left -->
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="margin-bottom">
				<xsl:choose>
					<xsl:when test="$template_namespace = 'iso'">8pt</xsl:when>
					<xsl:otherwise>12pt</xsl:otherwise> <!-- jcgm -->
				</xsl:choose>
			</xsl:attribute>
			<xsl:apply-templates />
		</xsl:element>
		<xsl:if test="$element-name = 'fo:inline' and not($inline = 'true') and not(local-name(..) = 'admonition')">
			<fo:block margin-bottom="12pt">
				 <xsl:if test="ancestor::*[local-name()='annex'] or following-sibling::*[local-name()='table']">
					<xsl:attribute name="margin-bottom">0</xsl:attribute>
				 </xsl:if>
				<xsl:value-of select="$linebreak"/>
			</fo:block>
		</xsl:if>
		<xsl:if test="$inline = 'true'">
			<fo:block>&#xA0;</fo:block>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="iso:li//iso:p//text()">
		<xsl:choose>
			<xsl:when test="contains(., '&#x9;')">
				<fo:inline white-space="pre"><xsl:value-of select="."/></fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
	<!--
	<fn reference="1">
			<p id="_8e5cf917-f75a-4a49-b0aa-1714cb6cf954">Formerly denoted as 15 % (m/m).</p>
		</fn>
	-->
	
	<xsl:variable name="p_fn">
		<xsl:for-each select="//*[local-name()='p']/*[local-name()='fn'][generate-id(.)=generate-id(key('kfn',@reference)[1])]">
			<!-- copy unique fn -->
			<fn gen_id="{generate-id(.)}">
				<xsl:copy-of select="@*"/>
				<xsl:copy-of select="node()"/>
			</fn>
		</xsl:for-each>
	</xsl:variable>
	
	<xsl:template match="*[local-name()='p']/*[local-name()='fn']" priority="2">
		<xsl:variable name="gen_id" select="generate-id(.)"/>
		<xsl:variable name="reference" select="@reference"/>
		<xsl:variable name="number">
			<!-- <xsl:number level="any" count="iso:p/iso:fn"/> -->
			<xsl:value-of select="count(xalan:nodeset($p_fn)//fn[@reference = $reference]/preceding-sibling::fn) + 1" />
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="xalan:nodeset($p_fn)//fn[@gen_id = $gen_id]">
				<fo:footnote>
					<fo:inline font-size="80%" keep-with-previous.within-line="always" vertical-align="super">
						<fo:basic-link internal-destination="footnote_{@reference}_{$number}" fox:alt-text="footnote {@reference} {$number}">
							<!-- <xsl:value-of select="@reference"/> -->
							<xsl:value-of select="$number + count(//*[local-name()='bibitem'][ancestor::*[local-name()='references'][@normative='true']]/*[local-name()='note'])"/><xsl:text>)</xsl:text>
						</fo:basic-link>
					</fo:inline>
					<fo:footnote-body>
						<fo:block font-size="10pt" margin-bottom="12pt">
							<fo:inline id="footnote_{@reference}_{$number}" keep-with-next.within-line="always" padding-right="3mm"> <!-- font-size="60%"  alignment-baseline="hanging" -->
								<xsl:value-of select="$number + count(//*[local-name()='bibitem'][ancestor::*[local-name()='references'][@normative='true']]/*[local-name()='note'])"/><xsl:text>)</xsl:text>
							</fo:inline>
							<xsl:for-each select="*[local-name()='p']">
									<xsl:apply-templates />
							</xsl:for-each>
						</fo:block>
					</fo:footnote-body>
				</fo:footnote>
			</xsl:when>
			<xsl:otherwise>
				<fo:inline font-size="60%" keep-with-previous.within-line="always" vertical-align="super">
					<fo:basic-link internal-destination="footnote_{@reference}_{$number}" fox:alt-text="footnote {@reference} {$number}">
						<xsl:value-of select="$number + count(//*[local-name()='bibitem']/*[local-name()='note'])"/>
					</fo:basic-link>
				</fo:inline>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*[local-name()='p']/*[local-name()='fn']/*[local-name()='p']">
		<xsl:apply-templates />
	</xsl:template>
	
	
	
	<xsl:template match="*[local-name()='bibitem']">
		<fo:block id="{@id}" margin-bottom="6pt"> <!-- 12 pt -->
			<xsl:variable name="docidentifier">
				<xsl:if test="*[local-name()='docidentifier']">
					<xsl:choose>
						<xsl:when test="*[local-name()='docidentifier']/@type = 'metanorma'"/>
						<xsl:otherwise><xsl:value-of select="*[local-name()='docidentifier']"/></xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</xsl:variable>
			<xsl:value-of select="$docidentifier"/>
			<xsl:apply-templates select="*[local-name()='note']"/>			
			<xsl:if test="normalize-space($docidentifier) != ''">, </xsl:if>
			<fo:inline font-style="italic">
				<xsl:choose>
					<xsl:when test="*[local-name()='title'][@type = 'main' and @language = $lang]">
						<xsl:value-of select="*[local-name()='title'][@type = 'main' and @language = $lang]"/>
					</xsl:when>
					<xsl:when test="*[local-name()='title'][@type = 'main' and @language = 'en']">
						<xsl:value-of select="*[local-name()='title'][@type = 'main' and @language = 'en']"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="*[local-name()='title']"/>
					</xsl:otherwise>
				</xsl:choose>
			</fo:inline>
		</fo:block>
	</xsl:template>
	
	
	<xsl:template match="*[local-name()='bibitem']/*[local-name()='note']" priority="2">
		<fo:footnote>
			<xsl:variable name="number">
				<xsl:number level="any" count="*[local-name()='bibitem']/*[local-name()='note']"/>
			</xsl:variable>
			<fo:inline font-size="8pt" keep-with-previous.within-line="always" baseline-shift="30%"> <!--85% vertical-align="super"-->
				<fo:basic-link internal-destination="{generate-id()}" fox:alt-text="footnote {$number}">
					<xsl:value-of select="$number"/><xsl:text>)</xsl:text>
				</fo:basic-link>
			</fo:inline>
			<fo:footnote-body>
				<fo:block font-size="10pt" margin-bottom="4pt" start-indent="0pt">
					<fo:inline id="{generate-id()}" keep-with-next.within-line="always" alignment-baseline="hanging" padding-right="3mm"><!-- font-size="60%"  -->
						<xsl:value-of select="$number"/><xsl:text>)</xsl:text>
					</fo:inline>
					<xsl:apply-templates />
				</fo:block>
			</fo:footnote-body>
		</fo:footnote>
	</xsl:template>
	
	
	
	<xsl:template match="*[local-name()='ul'] | *[local-name()='ol']" mode="ul_ol">
		<fo:list-block provisional-distance-between-starts="7mm" margin-top="8pt"> <!-- margin-bottom="8pt" -->
			<xsl:apply-templates />
		</fo:list-block>
		<xsl:for-each select="./*[local-name()='note']">
			<xsl:call-template name="note"/>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="*[local-name()='ul']//*[local-name()='note'] |  *[local-name()='ol']//*[local-name()='note']" priority="2"/>
	
	<xsl:template match="*[local-name()='li']">
		<fo:list-item id="{@id}">
			<fo:list-item-label end-indent="label-end()">
				<fo:block>
					<xsl:call-template name="getListItemFormat"/>
				</fo:block>
			</fo:list-item-label>
			<fo:list-item-body start-indent="body-start()">
				<fo:block>
					<xsl:apply-templates />
					<xsl:apply-templates select=".//*[local-name()='note']" mode="process"/>
				</fo:block>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>
	
	<xsl:template match="*[local-name()='note']" mode="process">
		<xsl:call-template name="note"/>
	</xsl:template>
	
	<xsl:template match="iso:preferred">		
		<fo:block line-height="1.1">
			<fo:block font-weight="bold" keep-with-next="always">
				<xsl:apply-templates select="ancestor::iso:term/iso:name" mode="presentation"/>				
			</fo:block>
			<fo:block font-weight="bold" keep-with-next="always">
				<xsl:apply-templates />
			</fo:block>
		</fo:block>
	</xsl:template>
	

	<xsl:template match="*[local-name()='references'][@normative='true']">
		<fo:block id="{@id}">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<!-- <xsl:template match="iso:references[@id = '_bibliography']"> -->
	<xsl:template match="*[local-name()='references'][not(@normative='true')]">
		<fo:block break-after="page"/>
		<fo:block id="{@id}">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>


	<!-- Example: [1] ISO 9:1995, Information and documentation – Transliteration of Cyrillic characters into Latin characters – Slavic and non-Slavic languages -->
	<!-- <xsl:template match="iso:references[@id = '_bibliography']/iso:bibitem"> -->
	<xsl:template match="*[local-name()='references'][not(@normative='true')]/*[local-name()='bibitem']">
		<fo:list-block margin-bottom="6pt" provisional-distance-between-starts="12mm">
			<fo:list-item>
				<fo:list-item-label end-indent="label-end()">
					<fo:block>
						<fo:inline id="{@id}">
							<xsl:number format="[1]"/>
						</fo:inline>
					</fo:block>
				</fo:list-item-label>
				<fo:list-item-body start-indent="body-start()">
					<fo:block>
						<xsl:variable name="docidentifier">
							<xsl:if test="*[local-name()='docidentifier']">
								<xsl:choose>
									<xsl:when test="*[local-name()='docidentifier']/@type = 'metanorma'"/>
									<xsl:otherwise><xsl:value-of select="*[local-name()='docidentifier']"/></xsl:otherwise>
								</xsl:choose>
							</xsl:if>
						</xsl:variable>
						<xsl:value-of select="$docidentifier"/>
						<xsl:apply-templates select="*[local-name()='note']"/>
						<xsl:if test="normalize-space($docidentifier) != ''">, </xsl:if>
						<xsl:choose>
							<xsl:when test="*[local-name()='title'][@type = 'main' and @language = $lang]">
								<xsl:apply-templates select="*[local-name()='title'][@type = 'main' and @language = $lang]"/>
							</xsl:when>
							<xsl:when test="*[local-name()='title'][@type = 'main' and @language = 'en']">
								<xsl:apply-templates select="*[local-name()='title'][@type = 'main' and @language = 'en']"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates select="*[local-name()='title']"/>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:apply-templates select="*[local-name()='formattedref']"/>
					</fo:block>
				</fo:list-item-body>
			</fo:list-item>
		</fo:list-block>
	</xsl:template>
	
	<!-- <xsl:template match="iso:references[@id = '_bibliography']/iso:bibitem" mode="contents"/> -->
	<!-- <xsl:template match="iso:references[not(@normative='true')]/iso:bibitem" mode="contents"/> -->
	<xsl:template match="*[local-name()='references']/*[local-name()='bibitem']" mode="contents"/>
	
	<!-- <xsl:template match="iso:references[@id = '_bibliography']/iso:bibitem/iso:title"> -->
	<xsl:template match="*[local-name()='references'][not(@normative='true')]/*[local-name()='bibitem']/*[local-name()='title']">
		<fo:inline font-style="italic">
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>

	
	<xsl:template match="mathml:math" priority="2">
		<fo:inline font-family="Cambria Math">
			<xsl:variable name="mathml">
				<xsl:apply-templates select="." mode="mathml"/>
			</xsl:variable>
			<fo:instream-foreign-object fox:alt-text="Math">
				<!-- <xsl:copy-of select="."/> -->
				<xsl:copy-of select="xalan:nodeset($mathml)"/>
			</fo:instream-foreign-object>
		</fo:inline>
	</xsl:template>
	

	
	<xsl:template match="iso:admonition">
		<fo:block margin-bottom="12pt" font-weight="bold"> <!-- text-align="center"  -->			
			<xsl:variable name="type">
				<xsl:call-template name="getLocalizedString">
					<xsl:with-param name="key">admonition.<xsl:value-of select="@type"/></xsl:with-param>
				</xsl:call-template>
			</xsl:variable>			
			<xsl:value-of select="java:toUpperCase(java:java.lang.String.new($type))"/>
			<xsl:text> — </xsl:text>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	

	<xsl:template match="*[local-name()='formula']/*[local-name()='stem']">
		<fo:block margin-top="6pt" margin-bottom="12pt">
			<fo:table table-layout="fixed" width="100%">
				<fo:table-column column-width="95%"/>
				<fo:table-column column-width="5%"/>
				<fo:table-body>
					<fo:table-row>
						<fo:table-cell display-align="center">
							<fo:block text-align="left" margin-left="5mm">
								<xsl:if test="$template_namespace = 'jcgm'">
									<xsl:attribute name="margin-left">25mm</xsl:attribute>
								</xsl:if>
								<xsl:apply-templates />
							</fo:block>
						</fo:table-cell>
						<fo:table-cell display-align="center">
							<fo:block text-align="right">
								<xsl:apply-templates select="../*[local-name()='name']" mode="presentation"/>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</fo:table-body>
			</fo:table>			
		</fo:block>
	</xsl:template>
	

	
	<xsl:template name="insertHeaderFooter">
		<xsl:param name="font-weight" select="'bold'"/>
		<xsl:call-template name="insertHeaderEven"/>
		<fo:static-content flow-name="footer-even">
			<fo:block-container> <!--  display-align="after" -->
				<fo:table table-layout="fixed" width="100%">
					<fo:table-column column-width="33%"/>
					<fo:table-column column-width="33%"/>
					<fo:table-column column-width="34%"/>
					<fo:table-body>
						<fo:table-row>
							<fo:table-cell display-align="center" padding-top="0mm" font-size="11pt" font-weight="{$font-weight}">
								<fo:block><fo:page-number/></fo:block>
							</fo:table-cell>
							<fo:table-cell display-align="center">
								<fo:block font-size="11pt" font-weight="bold" text-align="center">
									<xsl:if test="$stage-abbreviation = 'PRF'">
										<xsl:value-of select="$proof-text"/>
									</xsl:if>
								</fo:block>
							</fo:table-cell>
							<fo:table-cell display-align="center" padding-top="0mm"  font-size="9pt">
								<fo:block text-align="right"><xsl:value-of select="$copyrightText"/></fo:block>
							</fo:table-cell>
						</fo:table-row>
					</fo:table-body>
				</fo:table>
			</fo:block-container>
		</fo:static-content>
		<fo:static-content flow-name="header-first">
			<fo:block-container margin-top="13mm" height="9mm" width="172mm" border-top="0.5mm solid black" border-bottom="0.5mm solid black" display-align="center" background-color="white">
				<fo:block text-align-last="justify" font-size="12pt" font-weight="bold">
					
					<xsl:value-of select="$stagename-header-firstpage"/>
					
					<fo:inline keep-together.within-line="always">
						<fo:leader leader-pattern="space"/>
						<fo:inline><xsl:value-of select="$ISOname"/></fo:inline>
					</fo:inline>
				</fo:block>
			</fo:block-container>
		</fo:static-content>
		<fo:static-content flow-name="header-odd">
			<fo:block-container height="24mm" display-align="before">
				<fo:block  font-size="12pt" font-weight="bold" text-align="right" padding-top="12.5mm"><xsl:value-of select="$ISOname"/></fo:block>
			</fo:block-container>
		</fo:static-content>
		<fo:static-content flow-name="footer-odd">
			<fo:block-container> <!--  display-align="after" -->
				<fo:table table-layout="fixed" width="100%">
					<fo:table-column column-width="33%"/>
					<fo:table-column column-width="33%"/>
					<fo:table-column column-width="34%"/>
					<fo:table-body>
						<fo:table-row>
							<fo:table-cell display-align="center" padding-top="0mm" font-size="9pt">
								<fo:block><xsl:value-of select="$copyrightText"/></fo:block>
							</fo:table-cell>
							<fo:table-cell display-align="center">
								<fo:block font-size="11pt" font-weight="bold" text-align="center">
									<xsl:if test="$stage-abbreviation = 'PRF'">
										<xsl:value-of select="$proof-text"/>
									</xsl:if>
								</fo:block>
							</fo:table-cell>
							<fo:table-cell display-align="center" padding-top="0mm" font-size="11pt" font-weight="{$font-weight}">
								<fo:block text-align="right"><fo:page-number/></fo:block>
							</fo:table-cell>
						</fo:table-row>
					</fo:table-body>
				</fo:table>
			</fo:block-container>
		</fo:static-content>
	</xsl:template>
	<xsl:template name="insertHeaderEven">
		<fo:static-content flow-name="header-even">
			<fo:block-container height="24mm" display-align="before">
				<fo:block font-size="12pt" font-weight="bold" padding-top="12.5mm"><xsl:value-of select="$ISOname"/></fo:block>
			</fo:block-container>
		</fo:static-content>
	</xsl:template>
	

	<xsl:variable name="Image-ISO-Logo2">
		<xsl:text>iVBORw0KGgoAAAANSUhEUgAAAPoAAADsCAIAAADSASzsAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAC6PSURBVHhe7Z13XBTX18Y3iYolCmrsAZWIxo7EglEjEjWJisTYezSiYMTeYu+9R7FExCj2ghULqJGoYI3YEHuvQTEa7OZ93p3j/IbZ3dmZ3VnYZe73Dz84t8zMzjP3njP3nnt1/zEYmoHJnaEhSO6nT5/ex2BkUBISEjidk9x79+5dkcHIoAwfPpzTOTNmGBqCyZ2hIZjcGRqCyZ2hIZjcGRqCyZ2hIZjcGRqCyZ2hIUjuEyZM8GcwMiizZ8/mdE5yj4uLi2AwMijHjx/ndM6MGYaGYHJnaAgmd4aGYHJnaAgmd4aGYHJnaAgmd4aGILlfuXLlLwYjg3L9+nVO5yR3FrzHyMCw4D2GFmFyZ2gIJneGhmByZ2gIJneGhmByZ2gIJneGhmByZ2gIkrsGg/eaNGkSHh7+5s0b7hdQnadPnyYmJu7fv3/dunVhYWHz58+fOXPmuHHjRuqZPHky/rt48WIkbdmyJTY29vr16y9fvqTCapOUlDR69Gi6c+3BgvciLly4wN279UBMMTExixYt6tWr1zfffFOyZMkcOXLoLOKTTz4pX748XsXhw4evWLHir7/+SklJodNYzZ9//kk3rzFY8J5VoBlGAzF9+vRmzZoVLlyYpGobPvjgg9KlSwcEBCxZsuT8+fPv3r2ji2Aoh8ldAfHx8RMnTvzqq6+cnJxIjApxdnZ20WNx8583b160/aGhoXfu3KHLYsiGyd0Mr1692rp1a2BgoKurKynONPny5atVq1anTp3Gjx8PRW7fvv3IkSMwypOTk6m61KDyR48ewaw6ePDghg0bYN8PHTq0efPmlSpVypkzJ1VqGi8vL9g8fE/NMAuTu0kOHTrUvXt3tKYkLgM+/PBDmBkdOnSYM2cO9PrkyRMqqRJov/HCjBkzpnHjxkWKFKGzGuPzzz/HC3bt2jUqyTABk7uYu3fvjho1qkSJEiQl08Al3b9/PxWzJbDX586dK8f+gaEFE//58+dUkpEaJvf/AcOjXbt2mTNnJu0IgL/45ZdfTpkyZfTo0WjU6aj+eMeOHW/cuEFV2AC8UVWrVqXz6fHw8Ni5c+fkyZOrV68uvBge2FTDhg27desWVcF4D5P7f2/fvl2zZg2kQ2JJDY6HhITcu3ePcuv1V6xYMUrWkyVLll69el29epVyqARO9O2339I53gPH4OnTp5RDb/DMnj1b9D5w4L1t3br1iRMnKCuDl3vGCN67fPkydzsygZEQERFRoUIFEoiATz/9dMSIEaYqXLBgAeUTgIa2SZMm8GutHC1KSkpC/Z6enlSvALgKpnqSxMTEIUOG5M+fn7IK8Pf3P3nyJOWTB34ZFKGf1fERB+8FBAQUdXB8fHzw0nK3YxZO6EYl9c033yDp9evXlDU1aMKRgbKaIE+ePPBfly1bdvv2bSpmDlzP6dOnZ86cicqNWlM8H3/8MZpz9EhUMjWvXr1CT1WrVi3K/R4YXS1btjx79izlk0FkZGSpUqXox3Vw+vXrx92UFo2Zw4cPG5ouEFn79u1PnTpFmQyAIhcuXCjyF4sUKTJ9+nQ4iPR/AwoWLAiDJDg4GKb28uXLN23aBLMbPcDGjRsXL148duxYNDTwCiBiKpAaFxeXX375BX4qXiE6pKdGjRoXL16kKzMG7rFZs2Yiyx6i/+mnn+CLUybtoS25wwSHM0oP/z0Qerdu3fj+zihop0WN+kcffYQ2459//uEyHD16tHPnztmzZ6dkq4GJBZ+Br//Bgwc//vgj9ErJOh3OhQxcqikuXbqEd1gkerxaePfQD1AmLaEVuaP3RxuZK1cueuZ6INmuXbtKCx1s27btk08+oTJ6KlaseOzYMUp+DxQpymYNaPWpXgFRUVHFixenHHoaN278999/U7IJzp0716JFC+GrAuAGpM1XVLtCE3JPSEiAwUDP+T2wMc6cOUM5TIAmsHfv3lRAT6ZMmUaOHGm0aYTxQJl0usDAQHhI8+bNw+sEw6NQoUIitQG8bAUKFKhatWrbtm0nTpy4e/fu5ORk3uxGfhyhqgU8e/ase/fuwtpgUMkRblxcnKEJh+tUfXTMnsngckejPm3aNNEUl5IlS8KAphymgQEjeklQ8MiRI5ScmrVr11Imna5YsWLCb4Ucb968QfPPD44GBQVRQmpgkfPugZubG2/MiNixYwdeIS4bwEuI26Q0SVatWiWa0+bq6rpnzx5KzuhkZLnfvHnTx8eHnqqeLFmyoG1+8eIF5TDNgQMH0PRSMT1w8v79919KTo3QjEG7GxMTQwkGFC1alMuGToMOGYA+gcsDjJo0HLBhvvvuO8qnB92LqSsUgleoR48eosEy+CFyfhZHJ8PKfcuWLaKvGWiqExMTKVmSsLAw4ddANLfLly+nNGO0adOGsup0vXr1oqPGkCN34Ovry2WDEPfu3UtHjTFp0iQ07VxmUKlSJZlDvPCtP//8cyqmx8vLC64tJWdQMqDcYTYMHDiQnqEeNOqTJ0+WE7j07t07UVkPDw/pz9V//PEHZdXp3N3dpaMxZMod3jP/kadMmTKmBgE4YLgLO6KCBQsautFGQXPet29fYTMPV37jxo2UnBEhuTtE8N7hw4e5q5UAXfzXX39NT+89fn5+hsa0IS9fvmzVqhWV0dOwYcPHjx9TsjEgxLJly1JunQ4mNSWYQKbcAZptLieYOnUqHTUBzLbKlStTbv03yu3bt1OaJA8fPhQW5Bg6dKicpmHx4sX0YOwecfAenBX04PbMtm3buEuV4Ny5c6LvdDxodyVMapCcnMybEBz9+/c3NXjJM336dMqtN53pqGnkyx0vEtp1LnPOnDnNDtCiVxF+Gvroo48gR0ozARryfPnyUYHUNG7c2GwDgdZh2bJl9Hjsmz///JO75oxjzERFRTk7O9Pj0umcnJzwzOg/7+nWrZvRSAs0csJZVtDKggULKM00d+/e5YMwPv74YzSxlGAa+XIHMJP4D47oduioJIMGDeLyA5TF20gJqcGVN23alPLpgX+Croz+o8fT01POHTkWGUTu4eHhQueycOHC3BfDzZs3i4Z+YNridRc22w8ePChXrhwl63TZsmWTaQkEBARQGZ1O5ndARXIH7du35/JDu3JsOTB37ly8rlwpMGLECErQ8+rVqxkzZgjbBYBXnQtUDwkJEf6Mrq6u6DC5ghmDjCB3PD96PnqqVKkinBYCNTdv3pzS3vPFF19wHZxI6y4uLgcPHuQKSpOQkMCrqkSJEjJnQSqV+61bt/D6cUVq165NR82xdu1aeOdcKTB48GDuOAzCkiVL0lE96APhtgldYXQpwi9a+DsuLo7SHB+Hl/v48ePpyeiBAWP023NERMSnn35Kmd4DC0GodfQDElPERDRp0oSK6XTr1q2jo+ZQKncAx5ErAmR2OyAyMlI4gad79+6GEzlr1qyJl5YKCMBB4YT+XLlyZZhxKMeWu9BUBbAuJD4p/PPPP/369RN29EIKFSokX+uHDh2iYjqdt7f3O9mLYVgg9ydPnvAOZYUKFeSfa+/evaamrKHCpUuXSlR17949Ly8vyq038DKG4h1Y7qJ2HdKnBElgjIoGIzkaNGhgdgoND+wKKqbT8V6/HCyQO/j111+5UuD333+no+Y4duyYYZQTTHO889JfVzng0wvnUGQMxTuq3KdOnUrPQc+4ceMoQQboAWC7U8nUQPRRUVHSLWhMTAzl1ttOdFQelskd/qW7uztXsEyZMtKXh9StW7fWqVOHyy+Ct+PlALNQWA/6Cke340nudhW8ZzaQPjQ0lJ6AnokTJ1KCPIKCgqikCT777DO8Tg8fPqQCqREawTLHL3kskzsQhguuWbOGjqbmzp07Y8eO5U9hlA8//HDTpk1UQAYixefNm9dsHwhDiB6k3WC/wXs//PCD9OAO3DXhuLdMG4ZH2C2gZ4+Ojt6wYYOp0GY03qtXrxbOC4C+KVkf5kdHZYMb5MoqlTsaeDc3N65spUqV6KieZ8+erVixAhaa8BsiBxwVuON43kJ/F2bJ0aNHqbAMoHih8QaPX3qNg9u3b5ctW5Z7mnaCowbvHT9+XBg+FxwcTAny2Lx5Mz9wA1auXEkJesfOz89PmMqTM2fOFi1aQFIwZ/39/emoThcbG0uFZYOfniurVO5AOFNy27ZtsL9xSc2bNzca+Idr7tGjBx9aDgunY8eOlKbTFShQQNGyHLhxYVwv/jY1M9nOcSS5o7MWztXGkzY7yC8kISFBuBLdpEmTKEHA1atX0V2YCkrKlCkT/z7UrVuXyijBGrnDxuPnuOfOnduwLedAyyqM+uN5+fIlrpky6YeWFM34vXv3Lu8/gEaNGin68e0Eh5E7nk21atXox9Yvl6VofQs8fuF81/bt21OCMVBzRETE999/LxysEYFOxtfXF+/Gxo0b5a84YIHc79+/j7Z82LBh9evXF/ZsIvCKojmXHnl99OiRh4cHFdDP4KcEeVy4cEE4AjVkyBBKcBwcRu5dunShn1k/38tsgKYIuARUWKfDayOzYUtKSlq8eHHDhg0ldM+B5rZGjRqdOnWCb4BXBbLDO2A4cVda7pDjuXPndu7cOWfOnJ9//hmvk9nVtKHyzp07b9261Wg8oSHo4oQBu2ankYnYt2+fsFeB20MJDoJjyH3p0qX0A+utUqUTOYRWL8xWC1aeQOfQtm1bqkI2cKkLFixYqlQpLy8veHvwDfgZAWXKlEGF6EB8fHyqVKlSokQJPkk+EKucmboitmzZQuX1bqv80QaOhQsXUmH9gKv0+h/2hgPIHeIWjg4qjT+Ij4/nY1WhP+ngIAn4ee3o0BcsWADPTxQNZFPQvXh7e6NPEA6u9e/fny5OIcLR6HLlyindIEQ4Nw5uqwNF/dm73PFTCr8JDBgwgBLk8e+//wpFCa1QgkJiY2OpitTheTA/duzYAQMGZgxsJNFMQ2uAGQPPMjg4eP78+XFxcUJJ8dO80FPJtGFEoE8QLgUVGBhICfKA0yycYsB/5rN/7F3u+CnpR9UHm0qHsRkCaVJhnQ6msPR4pATw6qgWnU46lg+W0pEjRzZt2hQSEvLLL7+gYIsWLWD9w5jBe8sbvrD1K1euDEvG398fVk23bt3Gjh0L4wQvz+nTp6UXw5g2bRpXCbA41u7WrVtCv3PXrl2UII8rV64IfYCoqChKsG9I7rNnz0bvnPaEhYVxF2CUmJgY/sMfflylS+wKi0NeFi8A/fTpU/7bds2aNemoRfCuKu6dDinn4cOHvOuMF4mOKmfdunVcJcDV1VXpgjPLly+nwuaKo5Xp06cP98TThd9++427EpJ7egXvSYTNoyFHbw59cAiHhOSAXl5YXP4cXUMiIiKolqJFV61aRUctokaNGlw9VhoAMD+4etzd3ZOSkuiocn7++WeuHjBq1Cg6KpsuXbpQ4aJFR48eTUeNcejQIXrk6UEGDN5jMMzC5M7QEEzuDA3B5M7QEEzuDA3B5M7QEEzuDA1Bcr9///5Vc5iKqXv58iXlsDOUDsEa5dWrV/Hx8StXrhwzZky3bt38/Pxq165duXLlinq8vb3r1avXunXrfv36zZ07d/fu3RbMP7NPkpKS9u3bN2/evN69ezdt2rRq1aolSpTImzevcP5StmzZnJ2d8+fPX7p06Vq1auF3GDp0aFhY2PHjx63cyvjNmzf0FNWAj8MkucsJ3jMVvPPXX3/R3dsZuE+6RIVA4hDuoEGDqlWrZiqKQoLChQtDH7/++uv58+epRgcBv9iCBQugWjmbhkuTKVMmvCF9+vSJjIw0uvKPWRYuXFi8eHESn3WoGbyXkeR+8uTJrl275s6dm6qwmlKlSg0ePNjUJNuJEyeidZTPihUrqKSqJCYmjhgxAi00XbTaODk5NWrUaNmyZem+MQ6TO4H+1+j6M2qBpi40NFQUgTVy5EhKlgfsBCqpBriY8PBwYYyYrYEh1LlzZwtifNWCyf3/l+kSbd5iOwoUKIAWnV9LOr3knpKSMm3aNLOhUrajZs2aW7dutXiCqsVoXe6wXoQRx2kDHL7Zs2fDQ0h7ucMFnD9/fsGCBanGdAW+fhqvTKZpua9evdqCkDm1gK2s1HyyUu6HDh0SxsrYCf7+/vJ397cS7co9JCQkbQwYFbFY7s+fPw8ODja6io49kCNHjkWLFtG12hKNyh3tut0+ewksk3t8fDy/740907BhQ2vm7stBi3KPjY01u5CGfWKB3FeuXJmOBptS4EdJx0ZaCcldTvCe0aXvgWPJ/fHjx4b7GjgKSuUuXBrSUciZM6fZPc0jIiJIlPKwJHjP1PC4Y8lduDyTw4GnQLchA+HqGo4FuqN9+/bRbRjjyZMnnCZlombwngPJXbjlryOCJ0d3Yg7R+vcOR65cuZQuJi4Hbck9LUcQbYFMuW/dupUKODJubm6mlti3GA3JfceOHZTgsMiR++XLl53VW90pffH19bVgVUAJNCR3w63nHA6zcoc4hBsqZQCmTJlC96YGWpH7nTt31B1UKlq0aNeuXadNmxYaGjpz5swRI0a0a9fO09PTpp/zzcpdtMVsBsDJySkxMZFuz2q0Ivf58+fTUaspVarU5s2bTU1vSkpKWrlyJXoSWwzZSssdr7TRnTwcHZg0dIdWoxW5N23alI5aR+fOnWUueHvx4sX27dur29hLyx3XRvkyHJGRkXST1kFytyZ47/z581wkmwTqzjXNkSMH1SuJcFMNV1dXKmwFPj4+SuesxsXFqRg2ISF3vF2mdkhWC7y61atXHzJkyOrVq6Ojo3fu3AlDLjAwsHjx4pTDZkjvn3z37l3SqAnEwXtt2rTh4mUkULRfrghYt3ThalC7dm2qVx7Pnj2jktYxefJkqlEJaCY6dOhAVViHhNyFa66rTqZMmVD/pUuX6GQG7Nmzp2bNmpTbNkg08N27dyeNmiAoKIjLqYIxI4f0lfu5c+eopHXAGaUalTN37lzr566YkvujR4+yZs1KmdTGw8PjxIkTdCZJlixZIrF7lJVYsK2nIZqQ++HDh6mkdaA3h2ot3nEuISGhUqVKVJdFmJL777//TjnUplatWooCTOPj4/Ply0eF1Uaie5GJJuS+b98+KqkGsCPXr19vmehTUlJatWpFFSnHlNxbtGhBOVTF09NT6T42AF2BjeZgKt0e3RDWuluIu7v7yJEj+X165QOXS2nMHo9Rub9+/RrmKeVQD5glFm8zJtyuTEW8vLzoBJaiCbmjE6SSNqBKlSrjxo07efIknUweaKiovBKMyl3dvotHensCs1SuXJkqUpU7d+7QCSxCE3L/999/qaQtcXNz6969e3R0tMztwYR76MnEqNxtMandycmJXy7BMjZs2EB1qYqVu6doQu4gLUM6cufO3blz58jISLMDUkFBQVRGHkblXq9ePUpWDz8/P6rdUp4/fy5cXk8tlG4SKEIrcq9fvz4VTkNy5crVsWPHnTt3mprWxy2DgR9HJoaBbfAEbGG4L1u2jE5gBWqNZAuxcis4krsqO+9JjEPhUdH1qoEFcrfYO1SF/Pnz9+jRIzY2VumgrFkSEhLoHKpy7949OoEVLFq0iKpTj7x581LtBuzZs4eEaIA4eG/Lli1c+2ENEkG1SKXrVQML5A6TmgqnKyVKlIDJfvPmTbosq7HFF3d3d3eq3TrUGt0TYWq1ggsXLnA6NITfNVYrxgzcRxcXFyqf3nzwwQcwuFeuXGn99urDhg2jStXDmsFjIejKVFxclkc6jFUarcgdtG/fnsrbDfny5Rs8eLA1H9esGbQyxdSpU6l2qxFuRa8Wc+bModqVoyG5R0VFUXk7I2vWrMHBwZbtg2CLz9sbNmyg2q3mxx9/pErVo1evXlS7cjQk97dv3xZ9v0e7HZIjR44xY8Yo3fTCFtbCX3/9RbVbzdixY6lS9fD396falaMhuYPQ0FCqwl7x8PDYu3cvXa45UlJSqJiqCOMErMQWH2eqVKlCtStHW3KH81SrVi2qxY5Bfy2nmYfRTwVUJTk5mU5gNeHh4VSpeljz4Uhbcgc3b960k9XNpfH09DQ7/8xGH92pdjXYtGkTVaoezs7OVLty6N6ePXv22GpEO7EIsR+5g1OnTn3yySdUlx3j4uISHR1NF22M2NhYyqoqVLsa2ELuOXPmpNoNQJdIWkwNvxca3Zuc4D2zSGyUZVdyBxcuXLDdzlsqkjlz5qVLl9JFG7B7927KpypUuxrYQu6AajfA1NZu2greMwo6NEcJ3Q8JCaGLTk1MTAzlUBWqXQ1sIfesWbNS7crRrtw5Vq5cic6R6rVjQkND6YoFxMfHU7KqUO1qYKe2u62xW7mDS5cu2SgWQUVg1Rw6dIiu+D3Xr1+nZFVBv0cnsJo1a9ZQpepRuHBhql05TO7/D5zsfv36Ue32SrFixUQhF0+ePKE0VXnw4AGdwGrCwsKoUvWoUKEC1a4cJvf/sWPHjgIFCtA57JLevXvTtb7HycmJ0tRDxTUZbbHMfP369al25TC5p+Lx48fwX226rKk1wKQRfYy3xR5jZveKkU+PHj2oUvUICAig2pXD5G6EEydO2O3q2KKH7efnRwnqMW/ePKrdamyx7/6ECROoduUwuZskPj6+U6dOuXLlorPaB9myZXv06BFd4n//wbyhBPXo2bMn1W418DeoUvXYvHkz1a4ckvvixYt7Wc3hw4e52gxxRLlzpKSkrF+/vkOHDnnz5qXTpzd4WHRx+rX46Kh6VK1alWq3jnv37lGNqnI19S4VPAkJCSREA/gBUJJ7hg/ei42N5S7SLMePH6cyqXnz5s2BAwcGDRqU7sOxDRo0oGv677+DBw/SUfXIlCmTBYuHGbJx40aqUT3QuZmK9z1//jw9QgM0F7wnPzS7VKlSEpN/OC5duoQ78vX1hTKoWBqSM2dOfmkD6NIW1yA9V0cmtvBTK1asSLVbBJO7EcaMGUPFzJGcnLxmzZp27drlyZOHCqcJZ86coSuwTUCTlcu5cNhibZ9WrVpR7RbB5G4EtJcSfohR0NzGxMQMGDAgbUydiIgIOrF+dXM6qh4FChSwco2QuLg4qktVfv31VzqBRTC5G8fNzc3itVbgwwwePNim65YJw5NXr15NR1XFyohVW0SpglOnTtEJLILJ3STe3t78PGkLeP36dVhYmCqb5Bgyfvx4Oo1+LwNbbFPj4eGhNHCWB+6+LXZiy58/v8WL63MwuUtRp04daxQPULx///6qD9PidugEemyxvgXo0qULnUAJT58+xatCVagKfF86h6UwuZsBjqBlS2II2bVrl7q+rGgpmClTplCC2kyaNInOIY+UlBRfX18qrDbwjug0lkJylxO8h96Zy2wBjit3ACv8wIEDVJGlJCYmFilShGq0mgULFlC9es6fP08JNgBtqtkvsxxXr16tWrUqFVMb9BimLBlcHmnUBJYE7znuznvAGrkDWKJDhgyxcvAFildrF5dt27ZRpe+B3UVpNqBcuXLS88ZevXo1ffp0my5LKLF4mKmYPR41g/eSk5MjzKFumFzZsmWpXkmEZreVcucoVqzYqlWrrPGW1Gr8DDfl2rFjB6XZjPLly8OIOnr0KN/Yo+GEndanTx/bbT/GgRfJyu0VOFSQu0Psmq2K3DlKly49d+7cv//+m6qWDX6ozJkzUy1WkDt3bqOvnLe3N+WwPTlz5rTRfmNGUWvZSiZ3C8mSJct33303e/bs06dPm9qtgCcpKWnevHlqTa40tWocrE3KkbFwdXVVZQ4PYHJXgezZs1euXLlFixZ9+/bFiaZMmYJ/+/XrFxAQAJNaRQ+VY+HChXRXBrRr144yZSBUXKKVyd3BgDlkaj1/8ODBA4dYMUo+zZo1o3tTAyZ3B6N169Z0SybYsmULZXV8ChYsqGKcOGBydzDwa9MtmaZ///6U25FBP2b9cIcIJndHonnz5nQ/ksB1/vbbb6mMwzJ37ly6H/UgucsJ3jO1ZTiTe9qQLVs24R1J8/TpU9sNcKYBw4cPpzsxxrt370aNGkW6lIE4eG/VqlUQhDSmfmsm97RB6QIBycnJnp6eVNihMFxOR8TNmzc5Tcok4n14ADNmHAN/f38L4i2ePXtmi718bcdHH300e/ZsunobwOTuAHh5eVm8biPX79ti9rnq5MmTJyoqiq7bNjC52zvlypWz/mNcTEyMLZZ8UZEGDRpYs+GmTJjc7RofH5/Hjx/TPVgHnNfAwEA7bOZz5869aNEiK0NjZcLkbpzMmTNnz56d/pNO9OrV69WrV3QDKnHy5MnatWvTCdIbWOrBwcESg8Sqw+RunKJFi6bo1w9r2bJljhw56GhaUaRIke3bt9Ol24DIyMj03YEQrUnnzp3Pnz9PF5RWMLkbB3KnkvoNrrZs2dKuXbs0WC8yS5Ysffv2ffLkCZ3blhw6dKhFixY4I507TciXL9/AgQNv3bpFF5G2kNytCd7L8HLnefHixa5du3r06GGL3bezZs3arVu369ev08nSiocPH86YMaNatWp0HbYBd/fDDz+gt1RknkFyJD7rEAfv+fv703WZZt++fVxmEadOnaIYKTtDKB2z8V0iypcvTyVNgLseP3589erVrV9lAFKbNWtWWpqwRrlx48aCBQugBBVj8IoVK/bTTz9t2LDBglikK1eueHl5UUXW0bFjR65OFYwZjfPgwYN169ahg/b19ZW5lBJM86+//rpfv37QQRp8fVPK27dvz5w589tvv/Xs2dPHx8fV1VXm95xs2bKVLl0aL8zw4cPRkKu42bxaMLmrDMzChISEP/74Y+PGjWECIiIicBDOmSoxl2kMLBC0/cePH9+zZ48+DJjYuXMn+nz4AImJiRZEM6Y9TO4MDcHkztAQTO4MDcHkztAQTO4MDWG/cn/79i0NEuhROoXIyuJCnj9/TrVYt1AmePLkCVePlQsLCy/J7Co3EghXV/znn3/oqGysLJ72kNxV2XnPAk6cOMFdgCF4isKhvokTJ1KCPETFZ8yYQQnKWb9+PdWi01kZfMAPx/IDH5bB71fq5OQEqdFRhaAJqFevHlcPGDFiBCXIAw2Kj48PFTZYg1tEeHg4PfL0wJLgPVsAJXEXYJSEhAR+E/RMmTIdO3aMEuQhLI4/4uPjKUEhr1694tdALFeuHB21CFXkfu3aNX4ot23btnRUOcJ1aitWrKh09iUaICpsrjjeq0mTJtEjTw8iVAzesylolekX1elKliypdIxGuPB5+fLlLd6Ool+/flSLTnfw4EE6asDdu3f37du3fPlySCE4OLhp06Y1a9aEFIoXL44XRjSj2NnZuXDhwh4eHp6enr6+vq1btx44cOCsWbPWrFlz9OhRiVliw4YNoyp0uj179tBRhZw6dUrYlPwlYz0PIYcPH+Z3/MuSJcvJkycpwb6xd7mjYahfvz73swKZK0/woMMVTu/u2rUrJSjk3LlzVIWgYX7x4kVsbCwE2qlTpy+//BLypRwq4erqWrduXfTFYWFh58+f59wPGGmFChXiMri7u1vmk6DV+Pzzz7lKgHDrGzkkJSW5ublRYesMxTTG3uUO7ty5kz9/fvppdTrIixLkcfPmTeGG12h6KUEhEDRXAxrp3r17e3t7p/HUWRcXl2+//Va4xde4cePo4hSCnoSq0Om+/vprNAqUIANk/uabb6iwTodLsuyVSxccQO4gOjqan6WEPlRpDy5cRw5iPX36NCXIBl2/n58fVSGPHDlywPr66quv/P3927dvHxgYCIuI7wHQ54waNWrAgAHdu3dHd9GgQQMvL68CBQooml85evRoCzbSEe4rDxNL6Ry1X375hQrr+5+HDx9SgiPgGHIHY8eOpd9YH9144cIFSpAH2mMqrNPBkpY5nwnOcf/+/WEzUEkT5MqVC20/TJqpU6fi1YKLbOqrHO+qmlpK5fXr19evX4+KipozZw7eBNj00ps64fXAqadNmyYzYAKuBb/GPFoQ6T05DFm2bBlXFqAe2HKU4CA4jNzRY/7www/0S+u3clc0BQ8yEn41q1OnjsSXBNg/EyZMkN4QGMINCgpaunQpzHr5xoBZuRvl4sWLK1asgO8rNOpEQPf16tWDHCWW6Lh69arQrlNqsv/5559C+23RokWU4Dg4jNwBHKwKFSrQj63TVa9eXdFgzYMHD4Tz0Q3dVrxRu3fvhu1hano3+m6+afT09LTAZrVM7hzJycl84IWHhwcuhvtbBLqanj17ooehYu9B8bJly1Imna5JkyaKrv/MmTPCsI+ff/6ZEhwKR5I7uHHjBv9dAjRs2FDRmOKRI0eEW6zAQOKOp6SkhISElChRghJSU65cuZEjR3IjYgEBAXRUp9u0aRNXXD7WyB22PlcWxMXF4QguacSIEaZ6IfigvK3y8uVLYedWpkwZRYOg+NmFmzJ899131gzlpiMkdznBe2lDxYoVpb+O4xl//PHHlFuna9OmjaKffv369UJ3EH4b+nSjRgIe8MCBA0WDU7Ar+C2qq1WrRkdlY7Hc0bPxjSsMejr6Hvwmffv2LViwIJdBCHqhVatWCT/FwCG+du0alZQBTLvPPvuMCusrlB79gFufNWtWym0fOHbwXnR0NG9UAKWKh2NHJY0BS6ZRo0bwOE3VidNRVp1ux44ddFQeFst90qRJXEFgKmgY/smGDRtgwUt83kHnpmhwGhYg3CQqrNNB9/fv36c0B8Qh5Q7QSAstbEWKh5NaqVIlKikAnQbaSLMt39mzZ3k9KW3gLZM7WlN+Cxpvb286apoLFy4EBgYa3RkP/RVlkgHadZg9VFLf3V25coXSHBNHlTsIDw8XKv7777/n9/uUAM12yZIlqYyAFi1awJmjTOYQLquraKMsy+Q+fPhwrhSQ/+nw77//Nrpfe4MGDeSsZ3T58mWhDQOtm1rg34FwYLkDkeLr168vMdUEzw9PmrIagLZQ/ugV5MJb8B4eHvJnBVsg9zt37vDLmNWpU4eOymD+/PmmrJpMmTINGjRI4rsW7G+hbwpz34KxOTvEseUO4IcJ7Xg4UobrPUCO8EdF/hP0PXLkSOHe6jgif6m6rl27UjEl26pYIPcuXbpwRaDdI0eO0FFzhISE8FrHm7lw4UKcUfhDATc3t8jISCogICoqSrheWsZo1zkcXu4A9onQTnV1dRXO78PfX3zxBaW9B7Y+DFOkooUTKh6CWLlyJVdQGjS6/AzHfPnyyfyup1TuZ86c4Sceyt9yccyYMVwRAK3zs70TEhL4ifI8HTt2FK7oFBoaKnwr0Hcp+oxj52QEuYMDBw4IB9shxDVr1rx9+3bSpEmiiVyVK1cWzeCF4oVznoDMGI6hQ4dSAZ2uf//+dFQSpXLnwy8gejlN7Lt373r27MkVASjFa51nx44dwo8tAO13dHQ0+sDg4GA6pKdKlSrq7vOY7mQQuYNz584VL16cHpQe4RxXAAt41qxZRj/gwMcVberSq1cvs5960KIXLlyYyw9hybFuFcl99erVXGbQt29fOmqalJQU4TwLJycn9HuUlpoXL14MGzZMZNuI3oHGjRtbGWFoh5Dc0yuaST6wj80Oej98+LBmzZr0uFLj4+Mj3SlD3J06daLcevz8/KTHUwB+N8qt0+HUZq9QvtzxLvHjx/jDrLF07949NMZcfuDs7Gzq8zzPyZMn4epQgdQMGDDA7NuOhn/UqFH0eOwbcTST/csdyGk+0U4HBQXRQ3sPWm6Z80NwFiqjp2zZspcvX6Y0EwhN/7CwMDpqAvlyR/fC5QSGBomIw4cPCz+k4G+ZkYpo5kX7UcKhX7ZsGSVLsm7dOu652D8OE7xnGUuWLBF9h/nxxx9lLpqOssJePnfu3NKfus+ePct7k/BZped/y5T7iRMn+Dpr165NR02AC+bD8EDFihU5L9wst2/fbtiwIRXT4+7urjSKz7HImHIHp06dEs2dcnV1lTlGs3//fn4UE3zwwQfwSiU6d+Gm7NLfT+TIHR1UuXLluGx48c6cOUMJBsC2FgY3AX9/f5l79C1fvlw4GRigD5Q/0OagZFi5Azx44ddxjpYtW8qJALp69apwsjH46quvTLWakJ1wNiVcTEowQI7chwwZwuUBMI7pqAF4DYQTevFOSu80zXPx4sW6detSMT1w4h1x8roFZGS5c2zdurVAgQL0YPXkypVr5syZZteZSElJ6dChA5XR4+LiAieHklMTExPDD+vkyZNH9EbBRMb7Exsby19J27Zt4TobznqIi4vjx2vhR5oar501a5bQWoPFhdukNNPgtYQhKzLzatSokWFGkcyS8eUOHj161LFjR3q87/Hw8Ni8eTPlMM3ChQtF+mjdurVRA13oXMImxosRHByMPkFoFxkCi6JSpUq4vDlz5kDr/MdTmDFGV7O4fv26qG2uUqWKWX8anvrSpUuF7ixAo47XXlFctqOjCblzREVFiT4tA8jR7Ac7mA28Mc0BBa9du5aS34O2k7dVrMfoml7z5s0TzvVHfzJgwACzM3Y2bdpkOAO0UaNGwr2rNIKG5A5gVIwfP56fccVTu3ZtadE/f/4cjTdvrnA0aNCAa1Zhk/z++++wCihBDWARwb7npy7Gx8dXr16d0vS4ublFR0dzqabYvn274QQKd3d3Od1ahkRbcue4fft2p06dRNoFsArWrVsn0bnv3btXtNU67JyAgABTWzLBSfDx8YFq58+fD9v62LFjZ8+ehckOYKjAlF+zZs306dM7d+7s5eVldNWaDz/8sEmTJjCK+O+SHNLfVeGW4PUT9UjA2dl5ypQphg6DdiC520/wnsXAMIW/yN2OHKC8li1bGooegp44caKpmJ2nT59CvsJZx4agQUUfcvToUUVmMWyhyMjIPn368BMTjILLk/icijd51KhRIhsd4MWDkyp/8VTY+jNmzBDNMnBcHDt4T0Ug+mbNmtGvIgBPGi8D9GfUMkarTPkEwOkcPHiw0gVwDIHU9u/f36pVK0O1wZE1OpsAFwn75Pvvvxd1AgCW26BBgxxr8SPboXW5c8AyhnkjHJvkyZcvX8+ePdFv8MNMoaGhIuu/UKFCISEhFq+3ago01ehJRFdVs2ZN3sVE74EXIygoSDRgxFGwYMHRo0czoQthcv8fDx48GDdunClbArqHkY1Gl/6vJ3v27LB8VBe6kBs3brRr147Opyd37tzcOqymPnHCCQkPD9eyjW4KJncx8PPWrl3boEEDQ8NARKlSpdJsgGbDhg18NIkpXFxcunbt6nAL2aUlTO4mQWM/Z84c0YRBEbA00JQGBgYuWbIEvqnFG2kYcvPmzX379sFfbNu2Ld4rQ5eaJ0uWLLDa8T68ePGCCjNMwORunsuXL8+cObNu3bpyVriGGe3t7Q3zY+DAgVOnTl2+fPmuXbuOHz9+8uTJK1euXLt27dGjR3iR8EdiYiIOHj58eOvWrb/99tuECRPgJDRt2rRixYpG18wQkSdPHrwJK1asEIbeMaRhclfA06dPIyIiAgICpFdLtR3oTKpXrz506NADBw6YDb9gGMLkbiFopCMjI6E8X19f6Vkx1gAbplixYmjyp02bdujQIeZ9WgnJ3SGimdQFJoTMECc5PHz4cP/+/QsWLOjVq5efnx8M+kKFCpl1doVkzZr1s88++/LLL5s3b463KDw8HCbQv+pFiz579gyXRzevMcTRTOm10WT6grs2O7/KGvA63bt379SpUzDQ4XeiN8DvvmzZMjQu+GP37t04eOLEiYSEBFvHVdy/f3/s2LF029qDj35kxgxDQzC5MzQEkztDQzC5MzQEkztDQzC5MzQEkztDQzC5MzQEyb1NmzbODEYGJSgoiNM5yf3Zs2ePGYwMCj8XgxkzDA3B5M7QEEzuDA3B5M7QEEzuDA3B5M7QEEzuDA1Bct+yZctMBiODsmvXLk7nJHdtBu8xNAIL3mNoESZ3hoZgcmdoCCZ3hoZgcmdoCCZ3hoZgcmdoCCZ3hoYgubPgPUYGhgXvMTQEC95jaBEmd4aGYHJnaIb//vs/Lj82bN4l+u8AAAAASUVORK5CYII=</xsl:text>
	</xsl:variable>
	
	<xsl:variable name="Image-ISO-Logo">
		<xsl:text>iVBORw0KGgoAAAANSUhEUgAAAPcAAADiCAYAAACSl1F7AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAABT9pVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNi1jMDE0IDc5LjE1Njc5NywgMjAxNC8wOC8yMC0wOTo1MzowMiAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wUmlnaHRzPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvcmlnaHRzLyIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtbG5zOmRjPSJodHRwOi8vcHVybC5vcmcvZGMvZWxlbWVudHMvMS4xLyIgeG1wUmlnaHRzOk1hcmtlZD0iVHJ1ZSIgeG1wUmlnaHRzOldlYlN0YXRlbWVudD0iaHR0cDovL3d3dy5pc28ub3JnL2lzby9ob21lL3BvbGljaWVzLmh0bSIgeG1wTU06T3JpZ2luYWxEb2N1bWVudElEPSJ4bXAuZGlkOjNjZGZlYTk5LWYzY2QtNDcyYS1hNGVmLWQ4ZmY5MDQ4YTk0NSIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDozRjU0RkYwNTc5OTIxMUVBQjEyNkEyOUU0MUE2ODdFNCIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDozRjU0RkYwNDc5OTIxMUVBQjEyNkEyOUU0MUE2ODdFNCIgeG1wOkNyZWF0b3JU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</xsl:text>
	</xsl:variable>
	
	<xsl:variable name="Image-IEC-Logo">
		<xsl:text>iVBORw0KGgoAAAANSUhEUgAAAOwAAADlCAYAAABQ3BvcAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA39pVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNi1jMDE0IDc5LjE1Njc5NywgMjAxNC8wOC8yMC0wOTo1MzowMiAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6QUZCNjhDNjM3QTUxMTFFQUE0MDdDNjQ1OTIxQjc1Q0IiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6QUZCNjhDNjI3QTUxMTFFQUE0MDdDNjQ1OTIxQjc1Q0IiIHhtcDpDcmVhdG9yVG9vbD0iTW96aWxsYS81LjAgKE1hY2ludG9zaDsgSW50ZWwgTWFjIE9TIFggMTBfMTRfNikgQXBwbGVXZWJLaXQvNTM3LjM2IChLSFRNTCwgbGlrZSBHZWNrbykgQ2hyb21lLzc3LjAuMzg2NS45MCBTYWZhcmkvNTM3LjM2Ij4gPHhtcE1NOkRlcml2ZWRGcm9tIHN0UmVmOmluc3RhbmNlSUQ9InV1aWQ6OGRjOTFlYTktMGJlYy00YjJiLWI5ZjctYTNlMjA3ZTBiM2RjIiBzdFJlZjpkb2N1bWVudElEPSJ1dWlkOmZmYjEyOTA0LTcyNWItNGRlOS1iNTYxLWU3YmY0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</xsl:text>
	</xsl:variable>
	
	<xsl:variable name="Image-Attention">
		<xsl:text>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</xsl:text>
	</xsl:variable>
	
		<xsl:template name="number-to-words">
		<xsl:param name="number" />
		<xsl:variable name="words">
			<words>
				<word cardinal="1">One-</word>
				<word ordinal="1">First </word>
				<word cardinal="2">Two-</word>
				<word ordinal="2">Second </word>
				<word cardinal="3">Three-</word>
				<word ordinal="3">Third </word>
				<word cardinal="4">Four-</word>
				<word ordinal="4">Fourth </word>
				<word cardinal="5">Five-</word>
				<word ordinal="5">Fifth </word>
				<word cardinal="6">Six-</word>
				<word ordinal="6">Sixth </word>
				<word cardinal="7">Seven-</word>
				<word ordinal="7">Seventh </word>
				<word cardinal="8">Eight-</word>
				<word ordinal="8">Eighth </word>
				<word cardinal="9">Nine-</word>
				<word ordinal="9">Ninth </word>
				<word ordinal="10">Tenth </word>
				<word ordinal="11">Eleventh </word>
				<word ordinal="12">Twelfth </word>
				<word ordinal="13">Thirteenth </word>
				<word ordinal="14">Fourteenth </word>
				<word ordinal="15">Fifteenth </word>
				<word ordinal="16">Sixteenth </word>
				<word ordinal="17">Seventeenth </word>
				<word ordinal="18">Eighteenth </word>
				<word ordinal="19">Nineteenth </word>
				<word cardinal="20">Twenty-</word>
				<word ordinal="20">Twentieth </word>
				<word cardinal="30">Thirty-</word>
				<word ordinal="30">Thirtieth </word>
				<word cardinal="40">Forty-</word>
				<word ordinal="40">Fortieth </word>
				<word cardinal="50">Fifty-</word>
				<word ordinal="50">Fiftieth </word>
				<word cardinal="60">Sixty-</word>
				<word ordinal="60">Sixtieth </word>
				<word cardinal="70">Seventy-</word>
				<word ordinal="70">Seventieth </word>
				<word cardinal="80">Eighty-</word>
				<word ordinal="80">Eightieth </word>
				<word cardinal="90">Ninety-</word>
				<word ordinal="90">Ninetieth </word>
				<word cardinal="100">Hundred-</word>
				<word ordinal="100">Hundredth </word>
			</words>
		</xsl:variable>

		<xsl:variable name="ordinal" select="xalan:nodeset($words)//word[@ordinal = $number]/text()"/>

		<xsl:choose>
			<xsl:when test="$ordinal != ''">
				<xsl:value-of select="$ordinal"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$number &lt; 100">
						<xsl:variable name="decade" select="concat(substring($number,1,1), '0')"/>
						<xsl:variable name="digit" select="substring($number,2)"/>
						<xsl:value-of select="xalan:nodeset($words)//word[@cardinal = $decade]/text()"/>
						<xsl:value-of select="xalan:nodeset($words)//word[@ordinal = $digit]/text()"/>
					</xsl:when>
					<xsl:otherwise>
						<!-- more 100 -->
						<xsl:variable name="hundred" select="substring($number,1,1)"/>
						<xsl:variable name="digits" select="number(substring($number,2))"/>
						<xsl:value-of select="xalan:nodeset($words)//word[@cardinal = $hundred]/text()"/>
						<xsl:value-of select="xalan:nodeset($words)//word[@cardinal = '100']/text()"/>
						<xsl:call-template name="number-to-words">
							<xsl:with-param name="number" select="$digits"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="printEdition">
		<xsl:variable name="edition" select="normalize-space(//*[local-name()='bibdata']/*[local-name()='edition'])"/>
		<xsl:text>&#xA0;</xsl:text>
		<xsl:choose>
			<xsl:when test="number($edition) = $edition">
				<xsl:call-template name="number-to-words">
					<xsl:with-param name="number" select="$edition"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$edition != ''">
				<xsl:value-of select="$edition"/>
			</xsl:when>
		</xsl:choose>
		<xsl:variable name="title-edition">
			<xsl:call-template name="getTitle">
				<xsl:with-param name="name" select="'title-edition'"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:if test="$edition != ''"><xsl:text> </xsl:text><xsl:value-of select="java:toLowerCase(java:java.lang.String.new($title-edition))"/></xsl:if>
	</xsl:template>

	<xsl:template name="printTitlePartFr">
		<xsl:variable name="part-fr" select="/iso:iso-standard/iso:bibdata/iso:title[@language = 'fr' and @type = 'title-part']"/>
		<xsl:if test="normalize-space($part-fr) != ''">
			<xsl:if test="$part != ''">
				<xsl:text> — </xsl:text>
				<xsl:value-of select="java:replaceAll(java:java.lang.String.new($titles/title-part[@lang='fr']),'#',$part)"/>
				<!-- <xsl:value-of select="$title-part-fr"/>
				<xsl:value-of select="$part"/>
				<xsl:text>:</xsl:text> -->
			</xsl:if>
			<xsl:value-of select="$part-fr"/>
		</xsl:if>
	</xsl:template>

	<xsl:template name="printTitlePartEn">
		<xsl:variable name="part-en" select="/iso:iso-standard/iso:bibdata/iso:title[@language = 'en' and @type = 'title-part']"/>
		<xsl:if test="normalize-space($part-en) != ''">
			<xsl:if test="$part != ''">
				<xsl:text> — </xsl:text>
				<fo:block font-weight="normal" margin-top="6pt">
					<xsl:value-of select="java:replaceAll(java:java.lang.String.new($titles/title-part[@lang='en']),'#',$part)"/>
					<!-- <xsl:value-of select="$title-part-en"/>
					<xsl:value-of select="$part"/>
					<xsl:text>:</xsl:text> -->
				</fo:block>
			</xsl:if>
			<xsl:value-of select="$part-en"/>
		</xsl:if>
	</xsl:template>

	<!-- ================ -->
	<!-- JCGM specific templates -->
	<!-- ================ -->
	<xsl:template match="/" mode="jcgm">
		<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format" font-family="Times New Roman, Cambria Math, Source Han Sans" font-size="11pt" xml:lang="{$lang}">
			<fo:layout-master-set>
				<!-- cover page -->
				<fo:simple-page-master master-name="cover-page-jcgm" page-width="{$pageWidth}" page-height="{$pageHeight}">
					<fo:region-body margin-top="85mm" margin-bottom="30mm" margin-left="100mm" margin-right="19mm"/>
					<fo:region-before extent="85mm"/>
					<fo:region-after  region-name="cover-page-jcgm-footer" extent="30mm"/>
					<fo:region-start extent="100mm"/>
					<fo:region-end extent="19mm"/>
				</fo:simple-page-master>
				<!-- internal cover page -->
				<fo:simple-page-master master-name="internal-cover-page-jcgm" page-width="{$pageWidth}" page-height="{$pageHeight}">
					<fo:region-body margin-top="11mm" margin-bottom="21mm" margin-left="25mm" margin-right="19mm"/>
					<fo:region-before extent="11mm"/>
					<fo:region-after region-name="internal-cover-page-jcgm-footer" extent="21mm"/>
					<fo:region-start extent="25mm"/>
					<fo:region-end extent="19mm"/>
				</fo:simple-page-master>
				
				<fo:simple-page-master master-name="odd-jcgm" page-width="{$pageWidth}" page-height="{$pageHeight}">
					<fo:region-body margin-top="29.5mm" margin-bottom="23.5mm" margin-left="25mm" margin-right="15mm"/>
					<fo:region-before region-name="header-odd-jcgm" extent="29.5mm"/> <!--   display-align="center" -->
					<fo:region-after region-name="footer-odd-jcgm" extent="23.5mm"/>
					<fo:region-start region-name="left-region" extent="25mm"/>
					<fo:region-end region-name="right-region" extent="15mm"/>
				</fo:simple-page-master>
				<fo:simple-page-master master-name="even-jcgm" page-width="{$pageWidth}" page-height="{$pageHeight}">
					<fo:region-body margin-top="29.5mm" margin-bottom="23.5mm" margin-left="15mm" margin-right="25mm"/>
					<fo:region-before region-name="header-even-jcgm" extent="29.5mm"/> <!--   display-align="center" -->
					<fo:region-after region-name="footer-even-jcgm" extent="23.5mm"/>
					<fo:region-start region-name="left-region" extent="15mm"/>
					<fo:region-end region-name="right-region" extent="25mm"/>
				</fo:simple-page-master>
				<fo:page-sequence-master master-name="document-jcgm">
					<fo:repeatable-page-master-alternatives>
						<fo:conditional-page-master-reference odd-or-even="even" master-reference="even-jcgm"/>
						<fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd-jcgm"/>
					</fo:repeatable-page-master-alternatives>
				</fo:page-sequence-master>
			</fo:layout-master-set>
			
			<xsl:call-template name="addPDFUAmeta"/>
				
			<xsl:call-template name="addBookmarks">
				<xsl:with-param name="contents" select="$contents"/>
			</xsl:call-template>
			
			<fo:page-sequence master-reference="cover-page-jcgm" font-family="Arial" font-size="10.5pt" force-page-count="no-force">
				<fo:static-content flow-name="cover-page-jcgm-footer" font-size="10pt">
					<fo:block font-size="10pt" border-bottom="0.5pt solid black" padding-bottom="2.5mm"  margin-left="-1mm" space-after="4mm">
						<!-- Example: First edition  July 2009 -->
						<xsl:call-template name="printEdition"/>
						<xsl:text>&#xa0;&#xa0;</xsl:text>
						<xsl:call-template name="convertDate">
							<xsl:with-param name="date" select="'2009-07-01'"/>
						</xsl:call-template>
					</fo:block>
					<!-- Example © JCGM 2009 -->
					<fo:block font-size="11pt">
						<fo:inline font-family="Times New Roman" font-size="12pt"><xsl:text>© </xsl:text></fo:inline>
						<xsl:value-of select="/jcgm:bipm-standard/jcgm:bibdata/jcgm:ext/jcgm:editorialgroup/jcgm:committee/@acronym"/>
						<xsl:text> </xsl:text>
						<xsl:value-of select="/jcgm:bipm-standard/jcgm:bibdata/jcgm:copyright/jcgm:from"/>
					</fo:block>
				</fo:static-content>
				<fo:flow flow-name="xsl-region-body">
					<xsl:call-template name="insert_Logo-BIPM-Metro"/>
					<fo:block-container font-weight="bold">
						<fo:block font-size="16.5pt"  space-after="24.5mm">
							<xsl:value-of select="//jcgm:bibdata/jcgm:ext/jcgm:editorialgroup/jcgm:committee/@acronym"/>
							<xsl:text> </xsl:text>
							<xsl:value-of select="//jcgm:bibdata/jcgm:docnumber"/>
							<fo:inline font-weight="normal">:</fo:inline>
							<xsl:value-of select="//jcgm:bipm-standard/jcgm:bibdata/jcgm:copyright/jcgm:from"/>
						</fo:block>
						<fo:block border-bottom="1pt solid black">&#xa0;</fo:block>
						<fo:block font-size="16.5pt" margin-left="-0.5mm"  padding-top="3.5mm" space-after="7mm" margin-right="7mm" line-height="105%">
							<xsl:apply-templates select="/jcgm:bipm-standard/jcgm:bibdata/jcgm:title[@language = $lang and @type = 'main']" mode="title"/>
							<xsl:variable name="title_part">
								<xsl:apply-templates select="/jcgm:bipm-standard/jcgm:bibdata/jcgm:title[@language = $lang and @type = 'part']" mode="title"/>
							</xsl:variable>
							<xsl:if test="normalize-space($title_part) != ''">
								<xsl:text> — </xsl:text>
								<xsl:copy-of select="$title_part"/>
							</xsl:if>
						</fo:block>
						<fo:block font-size="12pt" font-style="italic" line-height="140%">
							<xsl:variable name="secondLang" select="/jcgm:bipm-standard/jcgm:bibdata/jcgm:title/@language[. != $lang]"/>
							<xsl:apply-templates select="/jcgm:bipm-standard/jcgm:bibdata/jcgm:title[@language = $secondLang and @type = 'main']" mode="title"/>
							<xsl:variable name="title_part">
								<xsl:apply-templates select="/jcgm:bipm-standard/jcgm:bibdata/jcgm:title[@language = $secondLang and @type = 'part']" mode="title"/>
							</xsl:variable>
							<xsl:if test="normalize-space($title_part) != ''">
								<xsl:text> — </xsl:text>
								<xsl:copy-of select="$title_part"/>
							</xsl:if>
						</fo:block>
					</fo:block-container>
				</fo:flow>
			</fo:page-sequence>
			
			<fo:page-sequence master-reference="internal-cover-page-jcgm" force-page-count="no-force">
				<fo:static-content flow-name="internal-cover-page-jcgm-footer" font-size="9pt">
					<!-- example: (c) JCGM 2009— All rights reserved -->
					<fo:block text-align="right">
						<xsl:value-of select="$copyrightText"/>
					</fo:block>
				</fo:static-content>
				<fo:flow flow-name="xsl-region-body">
					<fo:table table-layout="fixed" width="100%" font-size="13pt">
						<fo:table-column column-width="134mm"/>
						<fo:table-column column-width="30mm"/>
						<fo:table-body>
							<fo:table-row>
								<fo:table-cell>
									<fo:block><xsl:value-of select="/jcgm:bipm-standard/jcgm:bibdata/jcgm:ext/jcgm:editorialgroup/jcgm:committee"/></fo:block>
								</fo:table-cell>
								<fo:table-cell line-height="140%">
									<fo:block><xsl:value-of select="/jcgm:bipm-standard/jcgm:bibdata/jcgm:ext/jcgm:editorialgroup/jcgm:committee/@acronym"/></fo:block>
									<fo:block><xsl:value-of select="/jcgm:bipm-standard/jcgm:bibdata/jcgm:docnumber"/></fo:block>
									<fo:block><xsl:value-of select="/jcgm:bipm-standard/jcgm:bibdata/jcgm:copyright/jcgm:from"/></fo:block>
								</fo:table-cell>
							</fo:table-row>
						</fo:table-body>
					</fo:table>
					<fo:block font-size="18pt" space-before="70mm">
						<xsl:apply-templates select="/jcgm:bipm-standard/jcgm:bibdata/jcgm:title[@language = $lang and @type = 'main']" mode="title"/>
						<xsl:variable name="title_part">
							<xsl:apply-templates select="/jcgm:bipm-standard/jcgm:bibdata/jcgm:title[@language = $lang and @type = 'part']" mode="title"/>
						</xsl:variable>
						<xsl:if test="normalize-space($title_part) != ''">
							<xsl:text> — </xsl:text>
							<xsl:copy-of select="$title_part"/>
						</xsl:if>
					</fo:block>
					<fo:block font-size="13pt" space-before="35mm">
						<xsl:variable name="secondLang" select="/jcgm:bipm-standard/jcgm:bibdata/jcgm:title/@language[. != $lang]"/>
						<xsl:apply-templates select="/jcgm:bipm-standard/jcgm:bibdata/jcgm:title[@language = $secondLang and @type = 'main']" mode="title"/>
						<xsl:variable name="title_part">
							<xsl:apply-templates select="/jcgm:bipm-standard/jcgm:bibdata/jcgm:title[@language = $secondLang and @type = 'part']" mode="title"/>
						</xsl:variable>
						<xsl:if test="normalize-space($title_part) != ''">
							<xsl:text> — </xsl:text>
							<xsl:copy-of select="$title_part"/>
						</xsl:if>
					</fo:block>
				</fo:flow>
			</fo:page-sequence>
			
			
			<fo:page-sequence master-reference="document-jcgm" format="i" initial-page-number="2" force-page-count="odd">
				<xsl:call-template name="insertHeaderFooter_JCGM"/>
					
				<fo:flow flow-name="xsl-region-body" line-height="115%">
					<!-- Table of Contents -->
					<fo:block-container>
						<fo:block text-align-last="justify">
							<fo:inline font-size="15pt" font-weight="bold">
								<xsl:call-template name="getLocalizedString">
									<xsl:with-param name="key">table_of_contents</xsl:with-param>
								</xsl:call-template>
							</fo:inline>
							<fo:inline keep-together.within-line="always">
								<fo:leader leader-pattern="space"/>
								<xsl:call-template name="getLocalizedString">
									<xsl:with-param name="key">Page.sg</xsl:with-param>
								</xsl:call-template>
							</fo:inline>
						</fo:block>
						
						<xsl:if test="$debug = 'true'">
							<xsl:text disable-output-escaping="yes">&lt;!--</xsl:text>
								DEBUG
								contents=<xsl:copy-of select="xalan:nodeset($contents)"/>
							<xsl:text disable-output-escaping="yes">--&gt;</xsl:text>
						</xsl:if>
						
						<xsl:variable name="annexes_title">
							<xsl:call-template name="getLocalizedString">
								<xsl:with-param name="key">Annex.pl</xsl:with-param>
							</xsl:call-template>
						</xsl:variable>
						
						<xsl:for-each select="xalan:nodeset($contents)//item[@display = 'true']"> <!-- and not (@type = 'annex') and not (@type = 'references') -->
							<xsl:if test="@type = 'annex' and not(preceding-sibling::item[@display = 'true' and @type = 'annex'])">
								<fo:block font-size="12pt" space-before="16pt" font-weight="bold">
									<xsl:value-of select="$annexes_title"/>
								</fo:block>
							</xsl:if>
							<xsl:call-template name="print_JCGN_toc_item"/>
						</xsl:for-each>	
					</fo:block-container>
					
					<!-- Foreword, Introduction -->					
					<xsl:call-template name="processPrefaceSectionsDefault"/>
					
				</fo:flow>
			</fo:page-sequence>
			
			
			<!-- JCGM BODY -->
			<fo:page-sequence master-reference="document-jcgm" initial-page-number="1" force-page-count="no-force">
				<fo:static-content flow-name="xsl-footnote-separator">
					<fo:block>
						<fo:leader leader-pattern="rule" leader-length="30%"/>
					</fo:block>
				</fo:static-content>
				<xsl:call-template name="insertHeaderFooter_JCGM"/>
				
				<fo:flow flow-name="xsl-region-body" line-height="115%">
					
					<fo:block-container>
						<!-- Show title -->
						<!-- Example: Evaluation of measurement data — An introduction to the `Guide to the expression of uncertainty in measurement' and related documents -->
						
						<fo:block font-size="20pt" font-weight="bold" margin-bottom="20pt" line-height="1.1">
						
							<xsl:variable name="title-main">
								<xsl:apply-templates select="//*[contains(local-name(), '-standard')]/*[local-name() = 'bibdata']/*[local-name() = 'title'][@language = $lang and @type = 'main']" mode="title"/>
							</xsl:variable> 
							<xsl:variable name="title-part">
								<xsl:apply-templates select="//*[contains(local-name(), '-standard')]/*[local-name() = 'bibdata']/*[local-name() = 'title'][@language = $lang and @type = 'part']" mode="title"/>
							</xsl:variable>
							
							<fo:block>
								<xsl:copy-of select="$title-main"/>
								<xsl:if test="normalize-space($title-main) != '' and normalize-space($title-part) != ''">
									<xsl:text> — </xsl:text>
								</xsl:if>
								<xsl:copy-of select="$title-part"/>
							</fo:block>
							
						</fo:block>
					
					</fo:block-container>
					<!-- Clause(s) -->
					<fo:block>
						<xsl:call-template name="processMainSectionsDefault"/>
					</fo:block>
				</fo:flow>
			</fo:page-sequence>
			
		</fo:root>
	</xsl:template>
	

	<xsl:template name="print_JCGN_toc_item">
		<xsl:variable name="margin-left">5</xsl:variable>
		<fo:block>
			<xsl:if test="@level = 1">
				<xsl:attribute name="margin-top">12pt</xsl:attribute>
			</xsl:if>
			<fo:list-block>
				<xsl:attribute name="margin-left"><xsl:value-of select="$margin-left * (@level - 1)"/>mm</xsl:attribute>
				<xsl:attribute name="provisional-distance-between-starts">
					<xsl:choose>
						<!-- skip 0 section without subsections -->
						<xsl:when test="@level = 2"><xsl:value-of select="$margin-left * 1.6"/>mm</xsl:when>
						<xsl:when test="@level &gt;= 3"><xsl:value-of select="$margin-left * 1.8"/>mm</xsl:when>
						<xsl:when test="@section != ''"><xsl:value-of select="$margin-left"/>mm</xsl:when>
						<xsl:otherwise>0mm</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<fo:list-item>
					<fo:list-item-label end-indent="label-end()">
						<fo:block font-weight="bold">														
								<xsl:value-of select="@section"/>
						</fo:block>
					</fo:list-item-label>
					<fo:list-item-body start-indent="body-start()">
						<fo:block text-align-last="justify" margin-left="12mm" text-indent="-12mm">
							<fo:basic-link internal-destination="{@id}" fox:alt-text="{title}">
								<fo:inline>
									<xsl:if test="@level = 1">
										<xsl:attribute name="font-weight">bold</xsl:attribute>
									</xsl:if>
									<xsl:apply-templates select="title"/>
								</fo:inline>
								<xsl:text> </xsl:text>
								<fo:inline keep-together.within-line="always" font-weight="normal">
									<fo:leader font-size="9pt" leader-pattern="dots"/>
									<fo:inline><fo:page-number-citation ref-id="{@id}"/></fo:inline>
								</fo:inline>
							</fo:basic-link>
						</fo:block>
					</fo:list-item-body>
				</fo:list-item>
			</fo:list-block>
		</fo:block>
	</xsl:template>

	<xsl:template name="insertHeaderFooter_JCGM">
		<xsl:variable name="header_text">
			<xsl:value-of select="/jcgm:bipm-standard/jcgm:bibdata/jcgm:ext/jcgm:editorialgroup/jcgm:committee/@acronym"/>
			<xsl:text> </xsl:text>
			<xsl:value-of select="/jcgm:bipm-standard/jcgm:bibdata/jcgm:docnumber"/>
			<xsl:text>:</xsl:text>
			<xsl:value-of select="/jcgm:bipm-standard/jcgm:bibdata/jcgm:copyright/jcgm:from"/>
		</xsl:variable>
		<fo:static-content flow-name="header-even-jcgm">
			<fo:block-container height="98%">
				<fo:block font-size="13pt" font-weight="bold" padding-top="12mm">
					<xsl:value-of select="$header_text"/>
				</fo:block>
			</fo:block-container>
		</fo:static-content>
		<fo:static-content flow-name="footer-even-jcgm">
			<fo:block-container height="98%">
				<fo:block text-align-last="justify" >
					<fo:inline font-size="12pt" font-weight="bold"><fo:page-number/></fo:inline>
					<fo:inline keep-together.within-line="always">
						<fo:leader leader-pattern="space"/>
						<fo:inline font-size="10pt"><xsl:value-of select="$copyrightText"/></fo:inline>
					</fo:inline>
				</fo:block>
			</fo:block-container>
		</fo:static-content>
		<fo:static-content flow-name="header-odd-jcgm">
			<fo:block-container height="98%" >
				<fo:block font-size="13pt" font-weight="bold" text-align="right" padding-top="12mm">
					<xsl:value-of select="$header_text"/>
				</fo:block>
			</fo:block-container>
		</fo:static-content>
		<fo:static-content flow-name="footer-odd-jcgm">
			<fo:block-container height="98%">
				<fo:block text-align-last="justify" >
					<fo:inline font-size="10pt"><xsl:value-of select="$copyrightText"/></fo:inline>
					<fo:inline keep-together.within-line="always">
						<fo:leader leader-pattern="space"/>
						<fo:inline font-size="12pt" font-weight="bold"><fo:page-number/></fo:inline>
					</fo:inline>
				</fo:block>
				
			</fo:block-container>
		</fo:static-content>
	</xsl:template>
	
	<xsl:template match="jcgm:title">
	
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		
		<xsl:variable name="font-size">
			<xsl:choose>
				<xsl:when test="ancestor::jcgm:preface">15pt</xsl:when>
				<xsl:when test="../@inline-header = 'true'">10.5pt</xsl:when>
				<xsl:when test="$level = 2">11.5pt</xsl:when>
				<xsl:when test="$level &gt;= 3">10.5pt</xsl:when>
				<xsl:otherwise>13pt</xsl:otherwise><!-- level 1 -->
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="element-name">
			<xsl:choose>
				<xsl:when test="../@inline-header = 'true'">fo:inline</xsl:when>
				<xsl:otherwise>fo:block</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
			<xsl:element name="{$element-name}">
				<xsl:attribute name="font-size"><xsl:value-of select="$font-size"/></xsl:attribute>
				<xsl:attribute name="font-weight">bold</xsl:attribute>
				<xsl:attribute name="space-before"> <!-- margin-top -->
					<xsl:choose>
						
						<xsl:when test="$level = 1">36pt</xsl:when>
						<xsl:when test="$level = 2">18pt</xsl:when>
						<xsl:when test="$level &gt;= 3">3pt</xsl:when>
						<xsl:when test="$level = ''">6pt</xsl:when><!-- 13.5pt -->
						<xsl:otherwise>12pt</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:attribute name="space-after">
					<xsl:choose>
						<xsl:when test="ancestor::jcgm:preface">12pt</xsl:when>
						<!-- <xsl:otherwise>12pt</xsl:otherwise> -->
						<xsl:otherwise>12pt</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:attribute name="keep-with-next">always</xsl:attribute>		
				<xsl:if test="$element-name = 'fo:inline'">
					<xsl:attribute name="padding-right">
						<xsl:choose>
							<xsl:when test="$level = 3">6.5mm</xsl:when>
							<xsl:otherwise>4mm</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
				</xsl:if>
				<xsl:apply-templates />
			</xsl:element>
			
			<xsl:if test="$element-name = 'fo:inline' and not(following-sibling::jcgm:p)">
				<fo:block > <!-- margin-bottom="12pt" -->
					<xsl:value-of select="$linebreak"/>
				</fo:block>
			</xsl:if>
			
		
	</xsl:template>
	
	<xsl:template name="insert_Logo-BIPM-Metro">
		<fo:block-container absolute-position="fixed" left="21mm" top="52mm">
			<fo:block>
				<fo:instream-foreign-object content-width="170mm" fox:alt-text="Image Logo">								
					<svg xmlns="http://www.w3.org/2000/svg" height="547.66" width="547.66" version="1.0">
						<path id="path4" d="m543.54 276.94a276.23 276.23 0 1 1 -552.47 0 276.23 276.23 0 1 1 552.47 0z" transform="matrix(.95831 0 0 .95831 17.669 8.4373)" fill="#fff"/>
						 <path id="path6" d="m382 55.094c-2.56 0-7.13 3.091-7.91 5.344-1.88 5.447-2.31 5.759-1.81 1.312 0.32-2.85 0.14-4.688-0.47-4.688-2.15 0-6.03 2.346-6.03 3.657 0 0.988-0.64 1.191-2.22 0.687-4.12-1.314-5.15-0.987-5.47 1.75-0.16 1.461 0.23 3.597 0.85 4.75 0.92 1.723 0.79 2.38-0.69 3.5-0.99 0.75-2.98 1.358-4.44 1.375-3.34 0.04-4.08 1.18-2.28 3.563 1.98 2.616 1.81 4.344-0.44 4.344-1.05 0-2.17 0.416-2.5 0.937-0.36 0.596-33.67 0.916-90.06 0.844-82.35-0.106-89.47-0.26-89.47-1.75 0-1.939-1.85-3.969-3.62-3.969-0.71 0-1.31 0.772-1.32 1.719 0 0.947-0.37 2.298-0.84 3.031-0.49 0.774-0.64-1.666-0.34-5.812 0.5-6.969 0.47-7.112-1.63-6.563-1.78 0.467-2.29 0.077-2.78-2.375-1.05-5.272-5.15-4.555-5.19 0.906-0.01 2.427-1.12 2.744-4.03 1.188-1.33-0.711-2.52-0.695-3.93 0.062l-2.04 1.063 1.97 3.312c2.08 3.518 1.88 4.438-1 4.438-2.27 0-2.32 1.74-0.09 4.281 1.61 1.837 1.61 1.92 0.03 1.344-1.57-0.571-4.73 1.495-4.69 3.062 0.01 0.367 1.42 1.65 3.13 2.844l3.12 2.156-2.59 0.969c-2.98 1.134-4.92 4.21-4.06 6.437 0.76 1.988 5.9 2.038 6.65 0.063 0.81-2.113 2.25-1.806 2.88 0.594 0.4 1.561 1.05 1.891 2.59 1.411 1.47-0.47 2.03-0.24 2.03 0.87 0 0.85 0.59 1.56 1.31 1.56 2.14 0 4.64-3.438 5.26-7.216 0.71-4.436 3.15-5.477 5.62-2.438 1.02 1.251 2.55 3.165 3.44 4.25 0.88 1.085 2.71 2.704 4.09 3.594 3 1.93 4.29 6.75 6.38 23.94 0.79 6.5 2.47 14.74 3.71 18.34 2.3 6.64 7.35 15.6 8.79 15.6 0.43 0 0.75 0.48 0.75 1.09s0.79 1.84 1.75 2.72c2.04 1.88 7.53 9.13 7.71 10.19 0.07 0.4 0.27 5.06 0.41 10.34l0.25 9.59 0.72-7.12c0.85-8.07 1.56-10.46 2.81-9.69 0.48 0.29 1.2 1.98 1.6 3.75 1.61 7.17 2.93 36.36 1.43 31.75-0.52-1.62-0.85-4.58-0.75-6.59 0.11-2.02-0.12-3.97-0.5-4.35-1.93-1.93-0.29 22.53 1.94 28.85 0.48 1.35 0.35 1.49-0.56 0.65-0.66-0.6-1.81-6.12-2.59-12.28-2.86-22.5-2.99-23.12-3.85-21.19-0.48 1.08 0.02 7.74 1.19 16.22 1.09 7.93 1.83 14.58 1.66 14.78-0.18 0.2-2.01 0.05-4.07-0.37-3.7-0.77-3.71-0.81-0.9-1.38l2.81-0.56-4.28-4.66c-5.51-5.94-10.39-8-16.75-7.12l-4.78 0.66v-4.04c0-2.21 0.4-4.03 0.9-4.03s2.31-1.2 4.03-2.65c2.79-2.35 3.09-3.05 2.63-6.5-0.35-2.57-1.6-4.97-3.69-7.13l-3.12-3.28 3.06-3.91c3.29-4.15 3.83-6.44 1.84-7.71-2.35-1.51-8.11-3.24-10.84-3.25-3.68-0.02-7.98 4.18-7.1 6.96 0.58 1.8 0.42 1.95-1.34 1-2.83-1.51-6.21-1.31-8.81 0.5-2.11 1.48-2.41 1.41-4.81-1-1.4-1.4-3.51-2.53-4.72-2.53-8.22 0-17.78 11.67-10.32 12.6 1.35 0.17 4.34 1.01 6.66 1.87 4.2 1.56 4.22 1.57 2.34 3.63-3 3.3-4.29 6.47-3.65 9 0.81 3.21 6.27 9.28 8.37 9.28 1.57 0 4.94 2.84 4.94 4.15 0 0.31-1.2 0.86-2.69 1.22-4.9 1.21-11.85 6.72-13.75 10.88-0.98 2.16-3.11 6.27-4.72 9.12-2.38 4.25-3.36 5.14-5.37 5-2.59-0.17-5.55 0.81-7.66 2.54-0.69 0.56-1.84 1.49-2.53 2.03-0.68 0.54-2.64 2.28-4.34 3.84l-3.1 2.81-6.09-5.28c-4.892-4.24-6.849-6.83-9.842-13.16-2.583-5.45-4.963-8.9-7.719-11.15-2.288-1.87-3.969-4.1-3.969-5.25 0-1.19-0.819-2.22-2-2.53-1.382-0.36-1.825-1.06-1.438-2.28 0.308-0.97 0.127-2.06-0.437-2.41-0.599-0.37-0.815-2.15-0.469-4.31 0.402-2.52 0.143-4.21-0.781-5.16-0.87-0.89-1.324-3.59-1.313-7.5 0.022-7.2-1.811-9.49-6.937-8.62-2.025 0.34-3.481 0.05-4.281-0.91-1.067-1.29-1.505-1.31-3.594 0.06-1.303 0.86-2.375 2.4-2.375 3.41s-1.116 2.55-2.469 3.44c-1.612 1.05-2.425 2.52-2.406 4.21 0.036 3.2 4.833 8.68 8.375 9.57 1.719 0.43 3.11 1.76 4.031 3.97 0.768 1.83 2.635 4.13 4.156 5.06 1.522 0.93 2.587 2.18 2.376 2.81-0.212 0.63 0.247 1.75 1.031 2.47 1.028 0.95 1.3 2.72 0.937 6.28-0.425 4.18-0.11 5.6 2.188 9.41 1.494 2.47 3.954 5.32 5.468 6.34 1.68 1.13 3.554 3.92 4.782 7.13 2.146 5.6 4.968 10.29 4.968 8.25 0.001-0.68-1.116-3.49-2.5-6.22-1.383-2.73-2.312-5.46-2.093-6.1 0.337-0.97 4.593 7.05 4.593 8.66 0.001 0.31 0.943 2.55 2.094 5 2.328 4.95 1.909 7.13-0.531 2.75l-1.563-2.81 0.25 3.93c0.205 3.26-0.134 4.1-1.968 4.91-1.218 0.54-2.219 1.34-2.219 1.75s-0.684 0.72-1.531 0.72c-2.435 0-7.956 4.71-9.282 7.91-1.519 3.66-0.294 5.42 4.469 6.31 3.207 0.6 4.862 2.52 2.188 2.53-1.81 0.01-5.807 6.32-5.125 8.09 0.679 1.77 4.408 3.3 8.656 3.57 1.268 0.08 1.676 0.79 1.469 2.37-0.335 2.56 3.4 9.09 5.687 9.97 1.669 0.64-0.08 2.88-7.718 10.13-4.699 4.45-5.423 7.06-6.25 21.84-0.39 6.96-1.275 13.29-2.032 14.75-0.729 1.41-4.971 7-9.437 12.47-6.854 8.38-10.685 12.09-17.969 17.34-0.541 0.39-2.246 1.85-3.812 3.22-1.567 1.37-2.966 2.47-3.094 2.47-0.063 0-0.337-0.44-0.75-1.22l0.531 7.94 4.937 2.87c-0.651-1.08 0.805-1.44 5-1.44 4.263 0 6.007-0.53 8.876-2.71 1.958-1.5 3.562-3.13 3.562-3.63s1.116-2.1 2.469-3.56c1.352-1.46 2.437-3.19 2.437-3.84 0-0.66 1.468-2.56 3.219-4.19l3.156-2.94 1.188 2.25c1.015 1.94 0.694 3.19-2.188 9.06-1.842 3.75-3.358 7.8-3.375 9-0.019 1.43-1.049 2.74-3 3.75-3.26 1.69-5.038 5.05-4.25 8.07 0.437 1.67 0.104 1.85-2.75 1.46-2.273-0.31-2.996-0.12-2.312 0.6 0.541 0.57 3.181 1.17 5.844 1.34 2.762 0.18 4.987 0.83 5.218 1.53 0.223 0.68-0.334 1.25-1.281 1.25s-1.434 0.29-1.063 0.66c0.967 0.97 9.794 0.39 10.907-0.72 0.587-0.58-0.241-0.94-2.219-0.94-1.731 0-3.156-0.38-3.156-0.87 0-0.5 3.12-0.84 6.906-0.75 3.786 0.08 6.874 0.5 6.875 0.9 0.001 0.41 1.949 0.72 4.313 0.72 5.443 0 20.842 2.68 23.432 4.06 2.75 1.48 17.39 1.13 27.35-0.62 4.6-0.81 10.13-1.47 12.31-1.47s5.03-0.72 6.31-1.62l2.35-1.66-0.6 3.63c-0.7 4.31-0.01 4.46 7.28 1.59 3.16-1.24 6.15-1.8 7.82-1.44 2.52 0.55 2.6 0.8 1.59 3.47-1.49 3.96-0.34 4.6 5.03 2.78 3.75-1.27 6.93-1.45 16.91-0.9 6.76 0.37 13.05 0.32 13.94-0.1 0.88-0.42 2.89-0.78 4.43-0.75 1.55 0.03 4.79 0.07 7.22 0.06 7.22-0.01 23.66 4.03 20.25 4.82l4.94 4.93 8.34-5.9c-0.23-0.08-0.37-0.13-0.28-0.22 0.85-0.84 5.83-1.52 14.75-1.97 7.42-0.37 17.25-0.99 21.85-1.34 4.63-0.36 10.21-0.2 12.53 0.34 2.44 0.57 4.43 0.61 4.75 0.09 0.3-0.48 2.2-0.87 4.25-0.87 2.24 0 5.8-1.15 8.9-2.85 4.65-2.53 5.94-2.8 13.07-2.56 5.77 0.2 9.37-0.22 13.34-1.59 6.9-2.37 10.77-2.37 12.84 0 1.82 2.07 9 3.56 9 1.87 0-0.67 0.53-0.6 1.44 0.16 2.03 1.69 18.25-0.15 18.25-2.06 0-0.47 1.66-0.85 3.66-0.85 3.94 0 3.48-1.44-0.72-2.31-1.35-0.28-0.7-0.34 1.47-0.12 5.01 0.5 7.91 1.04 12.69 2.28 2.23 0.58 5.93 0.67 8.87 0.22 2.77-0.43 8.02-0.66 11.69-0.5 4.31 0.18 7.93-0.21 10.22-1.16 2.5-1.05 3.84-1.18 4.59-0.44 1.29 1.3 6.53 1.4 6.53 0.13 0-0.51-1.43-1.13-3.19-1.35l-3.18-0.37 3.53-0.16c2.89-0.13 3.71 0.27 4.62 2.28 1.11 2.43 1.35 2.47 12.88 2.47 6.43 0 13.04 0.27 14.68 0.6l2.76 0.59 7.21-2.59 5.13-17.63c-2.18 3.66-3.05 3.89-5.78 4.09-6.24 0.48-8.37-3.32-11.5-20.46-0.94-5.14-2.33-11.35-3.06-13.78-1.2-3.95-2.51-11.38-3.85-21.63-0.66-5.08-2.05-11.56-3.94-18.22-0.91-3.24-2.07-8.53-2.56-11.78s-1.35-7.91-1.87-10.34c-0.53-2.44-0.95-8.45-0.97-13.35-0.03-4.89-0.45-9.33-0.91-9.84-0.76-0.85-2.08-5.49-3.53-12.44-0.87-4.17 0.46-10.41 3-13.87 2.99-4.08 3.76-5.83 5.81-13.13 1.36-4.82 2.69-6.96 6.47-10.62 3.7-3.59 4.87-5.49 5.35-8.69 1.49-9.97-0.81-15.22-5.6-12.66-8.57 4.58-10.26 5.94-12.09 9.75-1.08 2.24-2.87 4.34-3.97 4.63-4.51 1.17-11.34 9.84-11.34 14.4-0.01 1.79-2.28 4.16-3.16 3.29-0.3-0.3-2.08 1.04-3.94 2.96-2.45 2.53-3.72 5.06-4.62 9.16-1.94 8.75-2.09 8.88-9.63 9.34-3.89 0.24-9.34 1.44-13.12 2.91-5.51 2.14-7.21 2.38-11.6 1.69-2.83-0.45-5.92-1.05-6.84-1.35-2.21-0.71-8.22-13.57-8.81-18.84l-0.47-4.13 3.78-0.53c2.09-0.3 6.93-0.86 10.72-1.21 3.78-0.36 7.33-0.96 7.87-1.35s2.74-1.22 4.91-1.84c2.16-0.63 5.18-2.14 6.72-3.38 2.47-1.99 2.91-3.24 3.78-10.62 0.54-4.59 0.68-14.75 0.34-22.6-0.57-13.08-0.84-14.77-3.5-20.34-5.49-11.5-20.47-24.43-25.9-22.34-1.57 0.6-1.57 0.76 0 2.5 0.91 1.01 2.18 1.84 2.84 1.84s1.73 0.6 2.34 1.34c0.86 1.03 0.72 1.68-0.5 2.69-1.26 1.05-1.45 2.38-0.97 6.5 0.73 6.2-0.04 7.8-6.81 14.41-6.03 5.89-13.39 10.69-18.78 12.25-5.68 1.64-5.63 1.67-4.94-3.41 0.52-3.76 0.18-5.52-1.97-9.91-1.43-2.92-3.97-6.32-5.65-7.56-3.93-2.9-10.69-5.5-14.28-5.5-4.8 0-12.93 3.17-16.19 6.32-2.96 2.85-2.97 3-0.94 3.31 1.17 0.18 2.36 1.01 2.69 1.87 0.68 1.77-2.01 5.22-4.06 5.22-0.75 0-1.6 0.66-1.91 1.47-0.76 1.97-2.31 1.89-2.31-0.13 0-1.93 2.76-4.2 5.15-4.24 0.95-0.02 1.72-0.52 1.72-1.1 0-0.59-0.82-0.77-1.87-0.44-1.32 0.42-2.02 0.05-2.28-1.18-0.3-1.4-0.8-1.04-2.5 1.68-1.47 2.35-2.19 5.03-2.19 8.38 0 5.38 3.29 15.28 5.5 16.53 2.08 1.18 1.66 3.62-0.97 5.69-1.8 1.41-2.41 3.02-2.75 7.09-0.3 3.64-1.12 6.01-2.59 7.59-1.18 1.27-2.16 3.02-2.16 3.88s-0.58 2.43-1.31 3.5-2.78 5.71-4.53 10.31-3.54 9.13-4.03 10.07c-0.5 0.93-0.96 2.71-1 3.93-0.04 1.23-0.93 3.57-1.97 5.19s-2.74 4.71-3.78 6.88c-1.6 3.3-1.91 3.56-1.97 1.59-0.04-1.29 0.82-3.83 1.94-5.63 1.81-2.93 1.97-4.36 1.53-14.12-0.53-11.61 0.39-16.32 3.31-17.25 3.39-1.08 6.74-7.7 9.22-18.22 3.95-16.74 4.56-22.39 4.56-40.78v-17.47l6-6.09c6.7-6.86 8.44-10.16 11.69-22.22 2.75-10.21 3.97-17.17 4.59-25.57 0.47-6.3 0.59-6.45 6.1-11.53 3.07-2.828 5.88-5.144 6.24-5.152 0.37-0.009 0.98-2.577 1.38-5.688 0.65-5.09 0.8-5.393 1.5-2.812 1.07 3.911 4.81 6.298 4.81 3.062 0-1.654 2.5-2.02 3.44-0.5 0.33 0.541 1.48 0.969 2.53 0.969 2.66 0 2.48-3.649-0.31-6.688l-2.22-2.406 2.22 1.344c1.22 0.742 2.22 1.665 2.22 2.062 0 0.825 5.3 3.719 6.81 3.719 0.55 0 1.5-0.934 2.12-2.094 0.98-1.828 0.69-2.519-2.03-5.062-2.4-2.249-3.01-3.457-2.56-5.25 0.45-1.783 0.2-2.344-1.09-2.344-1.32 0-1.42-0.238-0.5-1.156 0.65-0.649 1.18-2.026 1.18-3.063 0-1.513 0.42-1.767 2.19-1.187 1.22 0.397 3.57 0.803 5.19 0.875 2.78 0.122 2.94-0.083 2.94-3.594 0-2.175 0.58-4.115 1.4-4.625 2.04-1.257-0.4-3.969-3.56-3.969-1.96 0-2.29-0.367-1.78-1.969 0.45-1.429 0.19-1.968-1-1.968zm-2.31 2.156c0.8-0.108 0.85 1.148-0.5 3.219-0.9 1.369-2.04 2.5-2.57 2.5-1.42 0-1.16-1.206 0.94-3.938 0.9-1.169 1.64-1.716 2.13-1.781zm-10.94 2.781c0.54 0 0.98 0.543 0.97 1.219s-0.45 1.907-0.97 2.719c-0.74 1.15-0.96 0.858-0.97-1.25-0.01-1.488 0.43-2.688 0.97-2.688zm15.69 1.344c0.29-0.018 0.54-0.015 0.75 0.063 0.84 0.324 1.33 0.79 1.09 1.031-1.16 1.164-7.72 3.367-7.72 2.593 0-1.319 3.84-3.56 5.88-3.687zm-23.66 1.719c0.44-0.019 1.21 0.547 2.34 1.687 1.88 1.877 1.96 2.323 0.69 3.125-2.24 1.426-2.65 1.184-3.22-1.75-0.39-2.053-0.37-3.038 0.19-3.062zm-204.72 3.281c0.07-0.016 0.11-0.016 0.19 0.031 0.54 0.335 1 2.598 1 5 0 2.403-0.46 4.344-1 4.344s-0.97-2.232-0.97-4.969c0-2.684 0.3-4.294 0.78-4.406zm225.66 0.719c1.32-0.047 2.75 0.724 2.75 1.75 0 1.227-1.95 1.316-3.78 0.156-0.98-0.617-1.05-1.05-0.22-1.562 0.35-0.218 0.81-0.329 1.25-0.344zm-12.97 2.844c0.81-0.03 2.13 0.381 2.94 0.906 1.8 1.162 0.23 1.162-2.47 0-1.3-0.558-1.44-0.871-0.47-0.906zm-221.22 0.937c0.57 0.001 1.66 0.356 3.28 1.094 1.38 0.628 2.5 1.973 2.5 2.969 0 2.4-0.31 2.299-4.09-1.157-2.1-1.915-2.63-2.908-1.69-2.906zm13.13 1.5c0.36-0.043 0.52 1.09 0.53 3.625 0.01 2.57-0.13 4.688-0.31 4.688-1.77 0-2.26-5.45-0.69-7.876 0.17-0.266 0.34-0.423 0.47-0.437zm195.28 1.406c2.58 0 6.99 2.538 5.78 3.313-0.2 0.127-1.12 0.806-2.06 1.531-0.95 0.725-1.75 0.948-1.75 0.469s-0.95-1.341-2.13-1.875c-3.46-1.562-3.38-3.438 0.16-3.438zm13.22 0c0.23 0 0.72 0.459 1.06 1 0.33 0.541 0.13 0.969-0.44 0.969s-1.03-0.428-1.03-0.969 0.17-1 0.41-1zm2.03 3.969c1.96 0.016 1.96 0.054 0 1.219-2.56 1.512-6.38 2.031-6.38 0.875 0-1.005 3.36-2.119 6.38-2.094zm-223.63 1.125c0.33-0.012 0.67-0.006 1.06 0.031 1.76 0.17 3.22 0.74 3.22 1.282 0 1.1-3.29 1.604-5.18 0.812-2.15-0.897-1.4-2.043 0.9-2.125zm18.03 2.437c0.33 0.009 0.56 0.835 0.91 2.688 0.7 3.744 1.43 4.289 3.25 2.469 0.6-0.602 1.61-0.768 2.25-0.375 0.78 0.481 0.47 1.091-1.03 1.844-2.45 1.23-4.07 4.241-1.78 3.312 4.83-1.964 5.29-1.89 2.81 0.312-2.3 2.044-2.32 2.125-0.31 1.5 1.99-0.619 2.07-0.507 1 1.813-0.64 1.372-1.41 2.527-1.72 2.531-1.05 0.015-5.96-8.222-6.5-10.906-0.3-1.47-0.09-3.438 0.44-4.375 0.29-0.53 0.49-0.818 0.68-0.813zm207.72 0.844c0.09-0.012 0.18-0.004 0.28 0 0.23 0.011 0.5 0.076 0.82 0.188 2.18 0.775 5.15 3.288 5.15 4.375 0 1.281-2.23 0.897-4.68-0.813-2.19-1.521-2.81-3.562-1.57-3.75zm-221.53 0.719c3.12-0.082 5.7 0.327 6.28 1.031 0.76 0.914-0.27 1.188-4.4 1.188-7.32 0-9.03-2.031-1.88-2.219zm31.13 0.75c3.19 0 3.84 0.336 3.84 1.969 0 1.729-0.65 1.968-5.41 1.968-3.96 0-5.4-0.369-5.4-1.374 0-1.77 2.16-2.563 6.97-2.563zm103.59 0c5.33 0 7.42 0.364 7.81 1.375 0.29 0.759 0.26 1.645-0.06 1.969-0.32 0.323-3.84 0.593-7.81 0.593-6.56 0-7.22-0.18-7.22-1.968 0-1.79 0.66-1.969 7.28-1.969zm64.28 0c1.22-0.008 2.22 0.459 2.22 1 0 1.232-1.03 1.232-2.94 0-1.19-0.771-1.07-0.988 0.72-1zm-85.03 0.125c0.9-0.008 2.04 0.029 3.5 0.094 5.28 0.233 6.58 0.604 6.84 2 0.29 1.515-0.52 1.718-7 1.718-6.92 0-7.37-0.108-6.87-2 0.35-1.355 0.84-1.788 3.53-1.812zm-73.78 0.438c0.15-0.016 0.3-0.006 0.47 0 11.3 0.361 12.03 0.477 12.03 1.843 0 1.951-0.55 2.052-8.19 1.719-5.7-0.248-6.62-0.545-6.34-1.969 0.17-0.884 0.95-1.487 2.03-1.593zm23.72 0.437c5.37 0 7.42 0.346 7.81 1.375 0.29 0.767-0.15 1.653-0.97 1.969-0.82 0.315-4.34 0.562-7.81 0.562-5.66 0-6.31-0.174-6.31-1.937 0-1.79 0.66-1.969 7.28-1.969zm18.28 0c5.46 0 6.91 0.298 6.91 1.469s-1.45 1.468-6.91 1.468c-5.47 0-6.88-0.297-6.88-1.468s1.41-1.469 6.88-1.469zm16.72 0c5.46 0 6.9 0.298 6.9 1.469s-1.44 1.468-6.9 1.468c-5.47 0-6.88-0.297-6.88-1.468s1.41-1.469 6.88-1.469zm74.84 0c4.55 0 7.78 0.396 7.78 0.969 0 0.579-3.45 1-8.4 1-5.37 0-8.2-0.374-7.82-1 0.34-0.541 4.14-0.969 8.44-0.969zm14.75 0c2.41 0 3.74 0.375 3.38 0.969-0.34 0.541-2.14 1-4 1-1.87 0-3.38-0.459-3.38-1s1.81-0.969 4-0.969zm25.81 0.375c0.36-0.067 1.08 0.515 2.38 1.812 1.46 1.46 2.43 2.882 2.15 3.157-0.9 0.901-4.84-2.475-4.84-4.157 0-0.482 0.1-0.772 0.31-0.812zm-60.5 0.062c4.08-0.069 8.12 0.264 8.32 1.032 0.14 0.584-3.3 1.08-8.47 1.25-6.77 0.222-8.58 0.018-8.25-0.969 0.26-0.775 4.33-1.243 8.4-1.313zm49.82 0c0.47 0.033 0.53 0.614 0.53 1.969 0 4.746-4.95 12.24-9.91 14.939-5.56 3.02-6.77 5.42-7.78 15.59-1.5 15.08-6.35 32.05-8.75 30.56-0.44-0.27-2.07 0.92-3.59 2.63-1.72 1.93-2.32 3.26-1.6 3.5 0.75 0.25 0.23 1.67-1.47 4-2.96 4.09-8.22 8.68-8.22 7.19 0.01-0.55 1.35-1.97 2.97-3.13 1.63-1.15 2.94-2.51 2.94-3.03s-1.29 0.02-2.91 1.22c-3.28 2.43-3.92 2.23-3.96-1.22-0.07-5.98 1.51-10.52 4.65-13.16 1.76-1.47 3.22-3.29 3.22-4.06 0-0.76 0.46-1.37 1.03-1.37 0.58 0 0.8-0.45 0.47-0.97-0.32-0.53-1.88 0.48-3.47 2.22-3.95 4.35-3.7 1.83 0.72-6.53 3.65-6.92 4.52-8.28 6.91-10.94 0.67-0.76 1.22-1.77 1.22-2.28 0-0.52 0.68-1.52 1.53-2.22 0.84-0.7 2.22-2.52 3-4.03 1.24-2.41 1.22-2.67-0.03-2.19-1.22 0.47-1.25 0.07-0.25-2.72 1.5-4.2 3.19-6.04 8.15-8.87 5.07-2.905 10.22-7.264 10.22-8.629 0-0.576-0.92-1.062-2.03-1.062-1.22 0-1.74-0.414-1.34-1.063 0.36-0.593 1.94-0.916 3.5-0.687s2.84 0.098 2.84-0.313c0-1.242-3.77-2.058-6.12-1.312-1.97 0.622-2.1 0.563-0.91-0.875 0.74-0.89 2.23-1.625 3.28-1.625s2.77-0.471 3.81-1.032c0.62-0.33 1.06-0.519 1.35-0.5zm-211.29 0.532c1.07 0 2.77 0.589 3.76 1.312 2.85 2.089 1.38 3.506-1.69 1.625-3.86-2.364-4.27-2.937-2.07-2.937zm218.54 0.406c0.06 0.011 0.11 0.051 0.18 0.094 0.54 0.334 0.97 1.45 0.97 2.5s-0.43 1.906-0.97 1.906-1-1.115-1-2.5c0-1.071 0.27-1.815 0.63-1.969 0.06-0.025 0.13-0.042 0.19-0.031zm-208.13 0.594c2.43 0.011 2.84 0.245 1.72 0.968-1.93 1.25-4.91 1.25-4.91 0 0-0.541 1.43-0.977 3.19-0.968zm149.47 6.031c31.7-0.018 35.18 0.524 32.44 2.219-0.47 0.289-0.68 1.576-0.44 2.812 0.28 1.459-0.47 3.244-2.12 5.154-1.41 1.62-2.8 4.06-3.1 5.41s-0.98 3.64-1.53 5.09c-0.55 1.46-0.69 3.19-0.28 3.85 0.42 0.68 0.33 0.96-0.22 0.62-0.53-0.32-2.24 1.92-3.78 5-1.55 3.08-3.03 5.82-3.35 6.1-0.31 0.27-1.8 2.93-3.28 5.9-3.21 6.47-11.09 13.68-19.56 17.91-3.26 1.63-6.18 3.59-6.47 4.34-0.3 0.79-1.91 1.35-3.84 1.35-1.84-0.01-3.35 0.45-3.35 1 0.01 1.39-7.2 1.23-8.62-0.19-0.65-0.65-1.22-2.02-1.22-3.07 0-2.35 5.43-13.25 7.97-16 2.56-2.77 2.39-4.85-1.06-11.93-1.91-3.91-3.77-6.31-5.19-6.75-1.21-0.38-3.44-1.72-4.97-3s-3.19-2.35-3.69-2.35-1.82-0.88-2.9-1.97c-1.48-1.47-1.86-2.88-1.53-5.53 0.81-6.52-2.44-8.801-8.29-5.78-2.87 1.49-3.02 2.16-1.59 8.38 0.23 0.98-4.12 5.87-5.22 5.87-1.75 0-7.89 4.33-7.9 5.56-0.01 0.62-0.72 1.41-1.53 1.72-0.82 0.32-1.47 1.36-1.47 2.38 0 1.01-0.68 3.28-1.53 5-2.6 5.2 0.43 16.84 4.37 16.84 0.98 0 2.34 1.05 3.03 2.35 1.04 1.94 1.01 3.1-0.16 6.59-0.77 2.33-1.7 3.77-2.06 3.19s-2.44-1.37-4.65-1.72c-2.45-0.39-6.08-2.16-9.22-4.53-2.85-2.15-5.71-3.91-6.35-3.91-0.63 0-1.93-0.43-2.87-0.94-0.94-0.5-2.38-1.15-3.19-1.47-0.81-0.31-2.64-1.34-4.06-2.28s-3.98-2.61-5.69-3.68c-1.72-1.08-3.32-3.08-3.59-4.44s-0.92-3.81-1.44-5.47-0.96-3.63-0.97-4.41c-0.01-2.37-11.79-24.93-13.87-26.56-1.49-1.16-1.82-2.173-1.32-4.186 0.37-1.463 1.12-2.903 1.63-3.219s34.73-0.812 76.09-1.063c17.66-0.106 31.37-0.181 41.94-0.187zm-156.12 0.094c0.07-0.001 0.15 0.03 0.18 0.062 0.29 0.287-0.4 1.436-1.53 2.563-1.74 1.746-6 2.924-6 1.656 0-0.752 6.15-4.271 7.35-4.281zm193.59 0c0.72 0.037 1.48 0.418 2.19 1.125 2 2.008 1.92 2.23-1.63 4-3.92 1.955-3.66 2.031-3.56-1.406 0.07-2.372 1.42-3.801 3-3.719zm-184.28 0.25c0.71-0.117 1.03 0.479 1.03 1.812 0 2.856-2.38 6.289-3.31 4.781-0.97-1.571 0.31-5.875 1.93-6.5 0.12-0.045 0.25-0.077 0.35-0.093zm21.72 1c0.98-0.125 2.93 1.434 2.93 2.562 0 0.475-0.88 0.875-1.96 0.875-1.9 0-2.66-1.903-1.32-3.25 0.1-0.093 0.21-0.169 0.35-0.187zm-27.07 1.469c0.82 0 1.47 0.253 1.47 0.562s-0.65 1.22-1.47 2.031c-1.31 1.312-1.46 1.249-1.46-0.562-0.01-1.156 0.63-2.031 1.46-2.031zm26.57 6.002 2.43 0.56c3.38 0.79 6.72 4.75 8 9.56 1.03 3.85 2.84 8.29 6.88 16.75 2.28 4.77 2.44 7.89 0.37 7.1-0.9-0.35-1.47-0.01-1.47 0.87 0 0.8 0.43 1.44 0.94 1.44s1.65 1.23 2.53 2.72c0.89 1.49 3.35 3.94 5.47 5.47 3.98 2.85 5.07 5.59 2.25 5.59-1.21 0-1.32 0.29-0.5 1.28 0.6 0.72 0.91 3.49 0.72 6.16-0.19 2.66 0.08 5.68 0.59 6.65 2.14 4.08-0.02 3-5.31-2.59-3.1-3.28-5.91-5.68-6.22-5.38-0.3 0.31 0.98 2.25 2.88 4.32s3.25 3.97 2.97 4.25c-0.87 0.87-7.26-7.23-6.78-8.6 0.25-0.71-1.09-2.94-2.97-4.93-1.89-1.99-3.4-4.11-3.41-4.72 0-0.61-0.66-1.63-1.4-2.25-1.68-1.39-2.38-4.56-4.07-17.78-1.23-9.65-2.05-14.21-3.87-20.97-0.71-2.64-0.65-2.72 2.06-2.06l2.81 0.65-2.47-2.03-2.43-2.06zm79.87 1.87c2.07 0.04 3.43 1.87 2.81 3.81-0.76 2.41-3.29 2.77-4.12 0.6-0.65-1.68 0.16-4.43 1.31-4.41zm0.06 9.81c0.74-0.03 2.31 0.58 4.25 1.72 3.04 1.8 3.83 4.19 1.38 4.19-0.81 0-1.47 0.52-1.47 1.13 0 0.66-1.05 0.87-2.66 0.56-1.46-0.28-3.61-0.14-4.81 0.31-1.97 0.75-2.17 0.55-2.03-2.22 0.09-1.68 0.7-3.24 1.38-3.47 0.76-0.25 1.04 0.19 0.68 1.13-0.49 1.28-0.23 1.34 1.88 0.34 1.83-0.86 2.2-1.51 1.44-2.43-0.67-0.81-0.61-1.22-0.04-1.26zm0.69 4.41c-0.69 0-1.44 0.45-1.44 1.09 0 0.24 0.69 0.41 1.53 0.41 0.85 0 1.25-0.45 0.91-1-0.21-0.34-0.58-0.5-1-0.5zm-12.34 2.31c0.7-0.11 1.55 0.87 3.43 3.6 2.15 3.1 3.74 4.46 5.35 4.47 1.39 0 2.12 0.47 1.87 1.21-0.24 0.74-2.14 1.22-4.75 1.22-3.21 0-4.54 0.45-5.06 1.72-0.77 1.89-3.23 2.31-4.22 0.72-0.34-0.55-0.35-2.33 0-3.94 0.51-2.3 1.2-2.9 3.16-2.9h2.47l-2.28-1.85c-1.98-1.59-2.09-2.11-0.94-3.5 0.37-0.44 0.65-0.7 0.97-0.75zm20.22 1.32c0.88-0.05 2.05 0.28 4.15 0.93 5.03 1.57 6.83 3.85 3.03 3.85-1.29 0-2.85 0.43-3.5 0.97-0.85 0.71-0.93 0.67-0.21-0.19 1.54-1.86 1.14-3.47-1-4.03-1.99-0.52-2.37 0.14-2 3.59 0.1 1.02-0.38 2.26-1.1 2.72-2.42 1.53-5.75 0.51-5.75-1.78 0-1.01-0.62-1.34-1.91-1-1.05 0.28-2.71-0.18-3.68-0.97-1.64-1.33-1.57-1.39 0.87-0.87 1.46 0.3 2.9 0.17 3.22-0.35s1.25-0.72 2.06-0.41c0.82 0.32 2.37-0.21 3.44-1.18 0.9-0.81 1.49-1.24 2.38-1.28zm6.31 7.72c0.84-0.09 2.04 0.45 2.4 1.4 0.31 0.8 1.35 1.18 2.41 0.91 1.02-0.27 2.39 0.21 3.09 1.06 1.18 1.41 0.18 2.3-1.12 1-0.31-0.31-1.18-0.73-1.91-0.91-3.68-0.88-5.75-1.81-5.75-2.59 0-0.53 0.37-0.82 0.88-0.87zm-33.56 1.71c0.68 0.03 1.42 0.79 2.12 2.25 0.78 1.61 1.78 2.91 2.22 2.91s0.78 0.69 0.78 1.5c0 0.82-0.87 1.47-1.97 1.47-1.15 0-1.93-0.66-1.93-1.6 0-1.12-0.61-1.44-2.07-1.06-1.81 0.48-1.98 0.22-1.4-2.09 0.57-2.27 1.37-3.41 2.25-3.38zm20.18 0.85c1.95-0.19 4.45 1.08 6.32 3.34 0.85 1.03 1.19 1.11 1.22 0.25 0.04-1.8 2.46-1.48 4.31 0.56 2.71 3 1.2 14.29-2.66 19.72-3.39 4.78-6.39 6.33-10.19 5.38-1.63-0.41-2.31-0.25-1.9 0.4 0.34 0.56 1.85 1.22 3.34 1.47 1.5 0.26 3.59 0.84 4.63 1.28 1.33 0.57 1.66 0.44 1.15-0.37-0.39-0.63-0.26-1.16 0.32-1.16 0.57 0 1.03 0.71 1.03 1.53 0 0.83 1.11 1.98 2.47 2.6 2.36 1.07 3.35 2.78 1.62 2.78-0.46 0-2.54 1.69-4.66 3.75-4.47 4.35-7.36 4.44-10.96 0.34-3.59-4.06-5.19-8.73-5.19-15.31 0-3.98-0.52-6.85-1.57-8.34-0.91-1.32-1.64-4.35-1.68-7.22-0.07-4.25 0.34-5.29 2.65-7.28 1.49-1.28 3.57-2.35 4.66-2.35s2.84-0.44 3.87-1c0.38-0.2 0.78-0.33 1.22-0.37zm15.44 2.34c0.54 0 1 0.46 1 1s-0.46 0.97-1 0.97-0.97-0.43-0.97-0.97 0.43-1 0.97-1zm-6.28 2.97c-3.67 0-6.17 3.28-5.22 6.91 0.4 1.5-0.18 2.84-1.97 4.5l-2.53 2.37h3.1c2.87 0 3.06-0.27 3.06-3.44 0-3.38 2.34-5.8 5-5.18 0.62 0.14 1.26-0.98 1.44-2.47 0.29-2.47 0.04-2.69-2.88-2.69zm-14.59 0.16c-2.06 0.1-2.6 1.32-2.07 4.03 0.47 2.38 1 2.68 4.25 2.68 2.98 0 3.84-0.43 4.29-2.15 0.76-2.92 0.17-3.55-3.88-4.31-1.04-0.2-1.91-0.29-2.59-0.25zm-16.13 1.15c0.32-0.06 1 0.41 1.6 1.13 0.77 0.93 0.83 1.5 0.18 1.5-1.19 0-2.55-1.88-1.87-2.57 0.03-0.03 0.05-0.05 0.09-0.06zm70.13 11.56c0.29 0.01 0.31 2.27 0 5.32-0.33 3.24-0.93 11.34-1.29 17.97-0.35 6.62-1 12.03-1.46 12.03-0.47 0-0.76 3-0.66 6.65l0.16 6.63 0.37-5.66c0.2-3.11 0.8-5.65 1.31-5.65 0.52 0 0.91-1.98 0.91-4.41 0-2.6 0.45-4.44 1.09-4.44 0.69 0 0.9 1.04 0.54 2.72-0.32 1.49-0.89 10.2-1.26 19.41-0.57 14.49-0.43 17.19 0.97 19.9 2.01 3.89 2.03 5.19 0.13 5.19-0.81 0-1.48-0.11-1.5-0.25-0.02-0.13-0.31-2.03-0.63-4.19-0.31-2.16-1.15-4.8-1.9-5.87-1.22-1.74-1.36-1.27-1.35 4.44 0.02 7.38 0.74 10.76 2.32 10.81 0.61 0.02 1.89 0.66 2.87 1.4 0.98 0.75 1.44 1.53 1 1.76-1.59 0.8-5.2-1.72-6.31-4.41-1.62-3.92-1.8-16.21-0.25-18.25 1.77-2.34 1.63-10.14-0.28-13.97-1.59-3.19-1.59-9.11 0.06-30.5 0.32-4.22 3.74-15.32 5.09-16.59 0.03-0.02 0.05-0.04 0.07-0.04zm-95.53 0.63c0.07-0.01 0.14 0 0.21 0 0.35 0.02 0.64 0.25 0.72 0.75 0.09 0.54-0.03 0.59-0.28 0.12-0.24-0.46-0.86-0.23-1.37 0.5-0.64 0.91-0.84 0.96-0.63 0.13 0.22-0.84 0.81-1.4 1.35-1.5zm51.06 1.47c-2.16-0.07-5.38 1.09-5.38 2.34 0 1.67 1.18 1.8 2.66 0.32 0.77-0.78 1.27-0.78 1.75 0 0.37 0.59-0.05 1.06-0.91 1.06-1.83 0-2.05 1.61-0.31 2.31 2.27 0.92 2.75 0.66 3.75-1.97 0.62-1.63 0.67-2.96 0.09-3.53-0.33-0.33-0.93-0.51-1.65-0.53zm-44.75 1.37c0.47-0.02 1.13 0.03 2 0.16 2.78 0.41 4.78 2 8.43 6.63 1.44 1.82 1.53 1.81 0.97 0.09-0.5-1.58-0.37-1.65 0.91-0.59 0.83 0.68 2.92 1.52 4.62 1.87 3.62 0.74 4.24 2.76 2.16 6.94-0.92 1.84-1.96 2.69-2.87 2.34-0.79-0.3-1.44 0.03-1.44 0.72s-0.27 0.95-0.59 0.63c-0.33-0.33 0.13-2.02 1-3.76 1.96-3.93 2-3.66-0.91-3.5-2.26 0.14-2.44 0.56-2.44 4.85 0 2.57-0.46 4.65-1 4.65-1.08 0-1.22-0.51-1.09-3.43 0.05-1.08-0.18-1.46-0.47-0.81-0.29 0.64-1.16 0.95-1.94 0.65-0.9-0.35-1.42 0.11-1.47 1.28-0.04 1.09-0.61 0.43-1.4-1.62-1.62-4.21-1.81-6.22-0.5-5.41 1.55 0.96 1.16-1.12-0.47-2.47-0.91-0.75-1.23-2.08-0.88-3.5 0.42-1.65-0.04-2.63-1.53-3.56-2.16-1.35-2.51-2.09-1.09-2.16zm-3.91 0.38c0.53 0 1.24 1.23 1.6 2.72 0.35 1.49 0.95 3.14 1.31 3.69 0.36 0.54 0.57 3.47 0.5 6.56-0.07 3.08 0.27 5.4 0.72 5.12 0.44-0.27 0.82-1.7 0.87-3.15l0.1-2.63 0.84 2.75c1.77 5.9 2.78 23.44 2.16 37.56-0.66 14.76-0.66 14.77-1.32 6.41-0.36-4.6-0.73-13.78-0.78-20.41-0.06-7.31-0.5-12.06-1.09-12.06-0.97 0-1.15 4.45-1.47 33.44-0.16 14.42-0.84 19.25-3.19 21.91-0.83 0.94-1.81 1.71-2.15 1.71-1.02 0-3.01-2.24-2.97-3.37 0.04-1.33 4.87-4.92 4.87-3.63 0 0.54-0.43 1.26-0.97 1.6-1.19 0.73-1.31 3.43-0.15 3.43 1.19 0.01 3.19-6.7 3.37-11.31 0.5-12.61-0.38-43.78-1.25-43.78-0.62 0-1.06 7.9-1.16 21.41l-0.15 21.37-0.69-13.75c-0.38-7.57-1.03-21.1-1.44-30.03-0.4-8.93-0.93-16.55-1.18-16.97s-0.14-2.19 0.25-3.94c0.61-2.77 0.82-2.94 1.5-1.21 0.67 1.71 0.78 1.63 0.84-0.72 0.04-1.49 0.5-2.72 1.03-2.72zm85.97 0c0.91 0 0.46 11.8-0.47 12.37-0.48 0.3-0.9 1.8-0.9 3.35-0.01 1.54-0.45 2.96-1.04 3.15-0.58 0.2-1.41 2.79-1.84 5.75s-0.87 4.13-0.94 2.57c-0.06-1.57-0.73-3.34-1.5-3.94-1.06-0.83-1.22-2.23-0.65-5.81 0.77-4.88-0.26-7.31-1.47-3.47-0.38 1.2-1.34 2.83-2.13 3.62-1.23 1.23-1.55 1.23-2.34 0.03-0.51-0.76-0.76-2.6-0.56-4.09 0.22-1.71-0.12-2.72-0.91-2.72-2.51 0-2.41-1.99 0.16-2.97 1.78-0.68 3.03-0.67 3.84 0 0.87 0.72 1.51 0.32 2.31-1.43 0.73-1.59 1.65-2.23 2.63-1.85 0.96 0.37 1.5 0.02 1.5-0.97 0-1.33 2.7-3.59 4.31-3.59zm-53.78 1.41c0.14-0.1 0.05 0.88-0.22 3.03-0.27 2.16-0.52 5.15-0.5 6.65 0.03 2.86-4.01 7.6-6.5 7.6-0.73 0-1.34 0.48-1.34 1.03 0 0.56 1 0.7 2.31 0.37 3.23-0.81 3.97 1.73 1.84 6.25-0.94 2-2.49 3.79-3.44 3.97-1.49 0.29-1.71-0.5-1.71-5.9 0-5.04 0.48-6.96 2.47-9.88 1.35-1.99 2.43-3.92 2.43-4.31s0.64-1.4 1.38-2.25c0.74-0.86 1.83-2.91 2.43-4.53 0.47-1.26 0.74-1.96 0.85-2.03zm79.94 2.81c0.02 0 0.03 0.04 0.03 0.06 0 0.19-0.89 1.15-1.97 2.13-1.08 0.97-1.97 1.36-1.97 0.87s0.89-1.48 1.97-2.16c0.95-0.59 1.75-0.95 1.94-0.9zm-17.79 4.25c0.39 0.06 0.54 2.48 0.35 5.62-0.54 9.12-1 9.91-1.13 1.97-0.06-3.89 0.25-7.29 0.69-7.56 0.03-0.02 0.07-0.04 0.09-0.03zm-39.84 0.68c0.27-0.07 0.66 0.43 0.94 1.16 0.66 1.73 0.09 2.01-0.88 0.44-0.35-0.58-0.44-1.27-0.18-1.53 0.03-0.03 0.08-0.05 0.12-0.07zm26.69 1.35c-0.2 0.17-0.48 2.01-0.81 5.5-0.25 2.57-0.07 4.65 0.4 4.65 0.48 0 0.86-2.54 0.82-5.65-0.05-3.17-0.21-4.67-0.41-4.5zm-17.09 0.41c0.91-0.12 2.34 0.66 4.09 2.28 1.95 1.8 2.45 3 2.06 5.12-0.28 1.53-1.04 3.12-1.69 3.53-2.58 1.65-3.62 0.74-3.62-3.15 0-2.17-0.46-3.94-1-3.94s-0.97-0.89-0.97-1.97c0-1.16 0.41-1.79 1.13-1.87zm40.87 0.5c0.17-0.04 0.28-0.02 0.28 0.09 0 1.44-5.46 7.26-6.15 6.56-1.23-1.22-0.79-2.05 2.71-4.72 1.42-1.08 2.64-1.82 3.16-1.93zm84.53 2.37c0.85 0 11.19 10.66 11.19 11.53 0 0.26 0.94 1.79 2.09 3.41 1.15 1.61 2.49 4.51 3 6.5 1.24 4.84 1.89 32.64 0.82 35.12-0.83 1.92-0.84 1.93-0.91 0.07-0.09-2.52-1.61-0.9-2.44 2.62-0.63 2.67 0.73 3.88 1.69 1.5 0.27-0.68 0.55-0.28 0.59 0.91 0.08 2.28-5.06 6.95-8.4 7.62-1.01 0.2-3.08 0.83-4.57 1.41-1.69 0.65-2.72 0.69-2.72 0.09 0-0.53-0.45-0.94-1.03-0.94-0.57 0-0.77 0.43-0.43 0.97 0.33 0.54-0.55 1.43-1.97 1.97-3.56 1.35-4.45 1.23-3.78-0.5 0.46-1.21-0.49-1.47-5.25-1.47-6.02 0-8.19-1.08-8.19-4.12 0-0.98-0.43-1.78-0.97-1.78s-1-0.37-1-0.85c0-0.47 1.97-1.36 4.38-1.97 5.31-1.34 6.43-1.37 4.5-0.12-2.09 1.35 2.93 1.32 6.5-0.03 1.97-0.75 2.86-0.71 3.4 0.15 0.54 0.88 1.16 0.75 2.38-0.46 2.08-2.09 3.36-2.06 5.09 0.09 1.24 1.55 1.35 1.4 0.81-1.38-0.36-1.86 0.02-4.55 0.94-6.75 0.84-2 1.32-3.96 1.06-4.37-0.25-0.41 0.41-1.58 1.5-2.56 1.09-0.99 1.75-2.37 1.47-3.1-0.49-1.29-0.19-2.17 2.35-7.03 0.74-1.42 0.8-2.06 0.15-1.66-1.29 0.8-1.35-0.4-0.12-2.34 0.49-0.78 0.58-1.9 0.21-2.47-1.16-1.79-0.79-5.47 0.54-5.47 2.44 0 1.26-2.73-1.72-3.96-1.65-0.69-3.68-2.55-4.5-4.13-1.16-2.24-2.07-2.8-4.06-2.56-1.42 0.17-2.74-0.23-2.97-0.91s0.27-1.25 1.09-1.25 1.8-0.5 2.19-1.12c0.48-0.78-0.12-0.98-1.94-0.63-2.61 0.5-2.61 0.49-1-1.97 1.49-2.27 1.49-2.43 0.03-1.87-2.1 0.8-2.04-0.26 0.1-1.82 1.42-1.04 1.45-1.47 0.34-2.81-0.72-0.87-0.9-1.56-0.44-1.56zm-138.5 0.25c-0.6 0.09-1.26 0.62-1.56 1.53-0.22 0.64 0.3 1.16 1.16 1.16 0.85 0 1.53-0.71 1.53-1.57s-0.52-1.21-1.13-1.12zm-61.5 2.12c0.44 0.02 1.52 0.85 2.63 2.04 1.26 1.35 1.89 2.46 1.34 2.46-1.26 0-4.75-3.78-4.09-4.43 0.03-0.04 0.06-0.07 0.12-0.07zm71.06 0.13c0.3-0.02 0.54 0 0.69 0.09 1.52 0.92 0.64 1.98-3.03 3.6-4.61 2.03-6.18 2.09-5.47 0.25 0.51-1.34 5.72-3.82 7.81-3.94zm-27.12 1.44c0.53 0 1.74 1.2 2.69 2.69 0.94 1.48 2 2.94 2.34 3.21s1.14 1.47 1.78 2.69 1.93 2.22 2.91 2.22c0.97 0 2.27 1.09 2.87 2.41 0.97 2.13 0.81 2.48-1.4 3.21l-2.47 0.85 2.06 1.84c1.81 1.64 2.03 1.63 2.03 0.19 0-1.89 1.51-2.14 2.56-0.44 0.4 0.65 0.18 1.35-0.47 1.56-0.64 0.22-1.76 1.02-2.53 1.79-0.76 0.76-1.6 1.06-1.84 0.65s-2.35-4.29-4.66-8.62c-2.3-4.33-4.76-8.59-5.5-9.44-1.54-1.8-1.78-4.81-0.37-4.81zm-13.44 1.72c1.22-0.17 1.64 2.13 1.1 6.71-0.48 3.99-0.28 5.36 1.09 6.72 1.64 1.64 2.82 1.65 6.59 0.1 1.26-0.52 1.99 0.01 2.91 2.03 0.98 2.16 1 2.8 0.03 3.12-0.67 0.23-1.22 1.25-1.22 2.25 0 1.01-0.46 2.08-1 2.41-1.24 0.77-1.28 2.47-0.06 2.47 0.96 0 2.59-3.83 2.22-5.22-0.12-0.45 0.22-0.53 0.78-0.19 1.25 0.78 1.34 3.72 0.12 4.97-0.5 0.52-1.22 2.71-1.62 4.88-0.62 3.34-0.54 3.73 0.66 2.75 1.18-0.98 1.37-0.54 1.06 2.71-0.68 7.14 1.41 3.97 2.62-3.96 1.35-8.83 0.44-14.51-2.9-17.85-2.1-2.09-1.86-3.25 1-4.78 1.52-0.82 2.18-0.26 4.22 3.69 11.7 22.64 14.52 28.48 14.53 29.97 0 0.94 0.45 1.72 0.97 1.72 0.51 0 1.2 1.53 1.56 3.43 0.35 1.9 1.05 3.71 1.53 4 0.48 0.3 0.87 1.65 0.87 2.97s0.35 2.38 0.78 2.38c0.44 0 1.64 1.89 2.63 4.19 0.99 2.29 2.51 4.9 3.37 5.78 0.87 0.88 2.34 2.48 3.22 3.56 0.89 1.08 2.2 2.21 2.94 2.47s1.11 0.73 0.81 1.06c-0.71 0.79-8.84-3.2-8.84-4.34 0-0.49-0.83-1.74-1.84-2.75-2.07-2.07-7.05-12.31-8.91-18.32-0.67-2.16-2.07-5.8-3.12-8.06-1.06-2.26-2.17-5.34-2.44-6.87-0.28-1.53-0.9-2.93-1.38-3.1-0.47-0.17-1.63-2.6-2.56-5.4s-2.4-6.28-3.28-7.72c-1.53-2.52-1.59-2.11-1.56 9.03 0.01 6.39 0.12 11.5 0.25 11.37s0.88-1.94 1.62-4.06l1.35-3.87 1.03 8.34 1.06 8.38-0.25-6.66c-0.23-6.94 0.32-8.13 2.03-4.41 3.87 8.46 6.32 14.62 7.28 18.44 0.61 2.43 1.4 4.64 1.75 4.91s1.41 2.15 2.34 4.18c1.59 3.43 1.6 3.69 0.07 3.69-1.43 0-1.41 0.21 0.25 1.53 1.66 1.33 1.47 1.3-1.35-0.06-1.77-0.86-2.99-1.91-2.71-2.34 0.6-0.98-2.94-10.89-4.41-12.35-0.77-0.75-0.79-0.28-0.06 1.66 0.56 1.48 0.77 3.35 0.47 4.15-0.31 0.81 0.13 2.14 1 3 0.86 0.87 1.56 2.05 1.56 2.6 0 1.86-2.44 0.2-3.78-2.56-1.12-2.29-1.1-2.89 0-3.57 0.72-0.44 0.95-1.14 0.53-1.56s-1.18-0.12-1.66 0.66c-0.71 1.14-1.34 0.86-3.37-1.5-3.17-3.68-3.33-1.96-0.19 1.97 1.9 2.38 2.07 3.11 1.03 4.15-1.8 1.8-2.72 1.6-5.72-1.19-1.45-1.34-2.96-2.34-3.34-2.24-1.77 0.44-6.99-1.44-7.47-2.69-0.3-0.77-1.16-1.18-1.94-0.88-0.8 0.31-2.07-0.43-2.97-1.72-1.54-2.2-1.59-2.21-1.59-0.18 0 3.1-3.63 3.69-5.47 0.87-1.13-1.72-1.35-3.89-0.91-9.03 0.94-10.76 3.56-26.32 4.66-27.69 0.56-0.69 0.69-1.56 0.31-1.94-0.37-0.37-1.09-0.01-1.59 0.79-0.64 1-0.9-0.1-0.91-3.6-0.01-3.3 0.48-5.48 1.44-6.28 0.81-0.67 1.47-1.68 1.47-2.22 0-0.55-0.65-0.43-1.47 0.25-2.18 1.82-1.76-0.3 0.66-3.37 0.87-1.12 1.57-1.71 2.12-1.78zm-63.56 1.53c0.75-0.02 1.65 0.08 2.69 0.25 8.14 1.34 10.2 4.34 3 4.34-2.44 0-4.41-0.43-4.41-0.97s-0.43-0.97-0.94-0.97-1.05 1.66-1.22 3.69l-0.31 3.69-1.31-3.72c-1.5-4.23-0.78-6.22 2.5-6.31zm69.16 0.68c-0.55 0-1 0.43-1 0.97s0.45 1 1 1c0.54 0 0.96-0.46 0.96-1s-0.42-0.97-0.96-0.97zm34.9 0.13c1.23-0.03 1.47 0.62 1.47 1.91 0 1.78 0.39 2 2.72 1.37 5.37-1.46 9.09-1.26 9.09 0.47 0 2.01 3.8 12.94 5 14.41 0.92 1.11 3.13 31.96 2.35 32.75-0.25 0.24-0.47-0.64-0.47-1.97 0-1.34-0.49-2.96-1.1-3.57-1.52-1.52-2.77-9.01-1.62-9.71 0.51-0.32 0.64-1.3 0.28-2.19s-0.86-2.51-1.09-3.6c-1.78-8.18-2.18-8.73-1.82-2.46 0.98 16.78 2.11 26.18 3.53 28.84 0.53 0.97 0.83 2.95 0.66 4.41-0.24 2.11-0.49 2.36-1.25 1.18-0.91-1.4-1.52-4.7-3.37-18.34-0.45-3.31-1.18-6.59-1.63-7.31-0.44-0.72-0.91-3.65-1.06-6.53-0.51-9.51-2-9.04-2.63 0.84-0.55 8.75-2.14 14.61-4 14.63-0.47 0-0.54-1.01-0.15-2.22 1.44-4.56 1.64-7.42 0.59-8.07-0.65-0.4-1.06 0.15-1.06 1.41 0 1.3-0.43 1.84-1.13 1.41-1.12-0.7-0.79-6.02 1.07-18.13 0.45-2.97 0.51-5.76 0.12-6.19-0.39-0.42-0.78-0.19-0.87 0.5-0.8 6.08-1.4 9.38-1.88 10.63-0.31 0.81-0.46 2.45-0.34 3.66 0.35 3.61-0.9 4.5-2.97 2.12-1.19-1.37-1.81-3.48-1.72-5.72 0.12-2.97 0.19-3.08 0.53-0.81 0.74 4.89 2.39 2.88 2.09-2.56-0.21-3.97-0.65-5.23-1.78-5.16-0.82 0.05-1.78 0.75-2.15 1.56-0.49 1.07-0.67 0.88-0.72-0.72-0.04-1.21-0.58-2.21-1.16-2.21-0.57 0-0.75-0.46-0.43-0.97 0.31-0.52 1.33-0.66 2.21-0.32 1.18 0.46 1.43 0.22 1-0.9-0.32-0.85 0.08-2.45 0.88-3.6 0.8-1.14 1.04-2.09 0.53-2.09s-1.64 1.12-2.53 2.47-2.26 2.44-3.06 2.44c-2.02 0-1.83-0.98 0.75-3.72l2.22-2.31-2.97 0.65c-1.63 0.39-3.17 0.73-3.44 0.72-3.99-0.08-3.88-1.4 0.25-3.13 6.27-2.61 9.48-3.83 11.06-3.87zm43.56 1.84c1.12 0 0.52 20.14-0.81 27.53-0.63 3.52-1.63 6.72-2.25 7.13-0.82 0.54-0.78 0.97 0.19 1.59 1.36 0.88 0.99 5.24-0.81 9.47-0.46 1.08-1.08 2.74-1.38 3.69s-0.94 1.72-1.4 1.72c-1.19 0-0.15-6.23 1.18-7.1 0.71-0.46 0.23-1.28-1.31-2.37l-2.34-1.69 2.12-0.75c2.06-0.76 2.12-1.32 2.19-17.31 0.04-9.08 0.44-17.39 0.9-18.47 0.73-1.68 0.85-1.72 0.91-0.25 0.11 2.71 2.03 2 2.03-0.75 0-1.35 0.37-2.44 0.78-2.44zm-173.81 1.94c3.47 0 4.21 1.23 3.41 5.5-0.68 3.63-2.5 4.65-2.5 1.41 0-2.98-5.95-3.12-9.22-0.22-1.85 1.64-1.86 1.59-0.78-0.47 1.72-3.28 6.03-6.22 9.09-6.22zm202.03 1.97c2.18 0 1.85 1.73-0.47 2.47-1.08 0.34-1.97 1.21-1.97 1.94 0 0.72-1.31 1.77-2.93 2.34-1.63 0.57-2.97 1.49-2.97 2.06s-0.77 1.02-1.72 1c-1.36-0.03-1.14-0.5 1-2.25 1.49-1.22 2.69-2.72 2.69-3.31 0-1.35 4.35-4.25 6.37-4.25zm-186.37 1.09c1.17-0.09 1.97 0.15 1.97 0.88 0 0.54-0.89 1-1.97 1-3.75 0-1.96 1.87 2.43 2.53 4.68 0.7 5.16 2.36 0.69 2.38-1.45 0-4.63 0.65-7.06 1.4-2.43 0.76-5.32 1.66-6.41 2.03-1.66 0.58-1.58 0.41 0.41-1.22 1.63-1.33 1.97-2.12 1.16-2.62-0.89-0.55-0.89-1.06-0.03-2.09 1.79-2.17 6.22-4.08 8.81-4.29zm156.4 0.88c-0.54 0-1 0.92-1 2.03s0.46 1.77 1 1.44c0.54-0.34 0.97-1.25 0.97-2.03s-0.43-1.44-0.97-1.44zm19.32 0c0.81 0 1.17 0.46 0.84 1s-1.28 0.97-2.09 0.97c-0.82 0-1.18-0.43-0.85-0.97 0.34-0.54 1.28-1 2.1-1zm17.47 0.09c0.66 0 1.24 0.19 1.68 0.63 0.46 0.45-0.36 0.91-1.81 1.03-3.21 0.26-5.51 2.16-2.66 2.19 1.57 0.01 1.65 0.22 0.47 0.97-2.14 1.35-0.54 2.33 1.78 1.09 2.5-1.34 5.37-1.4 4.57-0.09-0.34 0.54-1.68 1-3 1s-2.41 0.42-2.41 0.96 0.54 1 1.22 1c0.82 0.01 0.76 0.34-0.22 0.97-2.77 1.79-6.91 0.16-6.91-2.75 0-3.25 4.39-6.98 7.29-7zm-180 2.22c0.35-0.06 0.56 0.17 0.56 0.6 0 0.57-0.43 1.03-0.97 1.03s-0.97-0.17-0.97-0.41 0.43-0.73 0.97-1.06c0.13-0.09 0.29-0.14 0.41-0.16zm-33.85 0.66c0.54 0 0.97 0.43 0.97 0.97s-0.43 1-0.97 1-1-0.46-1-1 0.46-0.97 1-0.97zm263.72 0c2.69 0 2.78 1.14 0.5 6.37-0.71 1.63-1.91 4.38-2.66 6.13-1.27 3-3.54 4.86-4.62 3.78-0.27-0.27 0.08-1.19 0.78-2.03s1.05-1.77 0.75-2.07c-0.3-0.29-1.96 1.52-3.69 4.04-4.26 6.19-13.5 15.15-16.37 15.87-1.29 0.32-2.97 0.33-3.75 0.03s-1.61-0.02-1.88 0.63c-0.37 0.9-0.47 0.91-0.53 0-0.04-0.65 1.53-1.94 3.5-2.88 3.16-1.49 11.86-7.51 14.6-10.06 0.54-0.5 2.08-2.34 3.43-4.06 1.36-1.73 3.36-4.15 4.44-5.41 3.95-4.6 5.41-6.85 5.41-8.31 0-1.8-7.8 5.71-7.85 7.56-0.02 0.68-0.46 1.22-1 1.22s-1 0.5-1 1.13c0 1.83-7.31 8.01-12.97 10.93-6.04 3.12-7.49 3.37-5.59 1.03 1.16-1.42 1.14-1.55-0.13-1.09-5.02 1.84-5.87 1.91-5.31 0.44 0.31-0.82 1.98-1.77 3.69-2.13 1.71-0.35 5.03-1.78 7.38-3.12 2.34-1.35 4.41-2.27 4.62-2.06 0.21 0.2-1.59 1.46-4 2.78-3.72 2.03-5.62 3.9-3.94 3.9 2.04 0 13.32-7.65 13.32-9.03-0.01-0.61-0.71-0.51-1.72 0.28-0.95 0.74 1.73-2.06 5.96-6.25 4.24-4.19 8.13-7.62 8.63-7.62zm-176.53 1.84c0.14-0.11 0.15 1.36 0.22 4.78 0.07 3.38-0.01 6.16-0.22 6.16-0.94 0-1.24-3.89-0.6-7.91 0.31-1.9 0.49-2.94 0.6-3.03zm-84.25 0.13c0.54 0 1 0.2 1 0.43 0 0.24-0.46 0.7-1 1.04-0.54 0.33-0.97 0.13-0.97-0.44 0-0.58 0.43-1.03 0.97-1.03zm268.72 0.53c0.09 0 0.19 0 0.28 0.03 2.94 1.13 2.03 13.28-1.72 23.53-0.79 2.17-1.71 5.8-2.09 8.06-0.75 4.45-1.84 5.06-10.32 5.69-2.09 0.16-4.27 0.57-4.87 0.94s-1.13 0.4-1.13 0.09c0-1.11 2.48-4.98 3.69-5.75 0.68-0.43 1.25-1.43 1.25-2.22 0-0.78 0.37-1.4 0.84-1.4 0.48 0 1.44-1.43 2.1-3.19s1.98-4.76 2.97-6.66c2.01-3.86 4.94-11.5 5.25-13.75 0.34-2.48 2.11-5.08 3.47-5.34 0.09-0.02 0.18-0.04 0.28-0.03zm-344.19 1.53c0.28 0.04 0.677 0.45 1.312 1.31 0.773 1.05 1.376 2.71 1.376 3.69-0.001 0.98-0.447 1.78-0.969 1.78-1.496 0-3.173-3.93-2.469-5.75 0.288-0.74 0.47-1.07 0.75-1.03zm248.59 0.87c-1.1 0-1.3 3.26-0.28 4.28 1.09 1.09 1.28 0.77 1.28-1.81 0-1.35-0.46-2.47-1-2.47zm-161.31 1c0.54 0 0.97 0.17 0.97 0.41s-0.43 0.73-0.97 1.06c-0.54 0.34-1 0.14-1-0.43 0-0.58 0.46-1.04 1-1.04zm134.38 0c-1.58 0-3.77 2.4-2.94 3.22 0.87 0.87 3.11-0.22 3.72-1.81 0.3-0.78-0.04-1.41-0.78-1.41zm-216.47 0.32c0.152 0.02 0.338 0.15 0.562 0.37 1.215 1.22-0.372 7.48-2.562 10.13-0.673 0.81-1.483 2.12-1.782 2.93-0.357 0.97-0.542 1.06-0.594 0.22-0.042-0.7 0.793-3 1.876-5.12 1.082-2.12 1.968-5.08 1.968-6.57 0-1.23 0.126-1.83 0.406-1.93 0.043-0.02 0.075-0.04 0.126-0.03zm288.22 0.12c1.71-0.13 2.4 0.52 2.4 2.06 0 1.69-2.65 1.8-5.37 0.22-1.85-1.07-1.79-1.15 0.9-1.87 0.81-0.22 1.49-0.36 2.07-0.41zm-17.88 0.75c2.02-0.04 3.69 0.16 4.03 0.72 0.35 0.57 1.4 1.03 2.32 1.03 0.91 0 3.62 1.67 6 3.72 3.71 3.2 4.15 4.03 3.24 5.72-0.95 1.78-0.42 5.47 2.54 17.37 0.1 0.41 0.18 1.47 0.18 2.35 0 1.22 0.65 1.46 2.72 1.03 1.49-0.31 4.15-0.85 5.91-1.22 2.57-0.53 3.19-0.38 3.19 0.91 0 0.88-0.49 1.51-1.1 1.37-0.61-0.13-1.3 0.25-1.53 0.88-0.23 0.62 1.54 1.89 3.94 2.81 4.78 1.82 7.8 6.01 5.41 7.53-2.05 1.29-2.8 1-5.72-2.13-1.52-1.62-3.48-2.96-4.35-2.96-2.22 0-1.98 0.87 1.07 3.68l2.68 2.47-3.62 3.31c-3.82 3.5-7.51 4.25-9.78 1.97-0.75-0.74-2.71-2.04-4.38-2.9s-3.31-2.3-3.66-3.19c-0.34-0.91-1.25-1.37-2.06-1.06-0.79 0.3-1.71 0.14-2.03-0.38-0.32-0.51-1.53-0.89-2.72-0.84-1.84 0.07-1.73 0.24 0.85 1.37 3.26 1.44 7.04 5.01 4.09 3.88-1.13-0.43-1.51-0.05-1.41 1.37 0.12 1.54 1.08 2.1 4.38 2.6 4.49 0.67 4.87 2.47 0.53 2.47-1.41 0-2.26 0.33-1.87 0.71 0.38 0.39 2.48 0.57 4.62 0.41 2.3-0.16 3.88 0.16 3.88 0.78 0 0.6-1.93 1.07-4.41 1.07-3.39-0.01-4.63-0.46-5.44-1.97-0.58-1.09-1.47-1.97-2-1.97s-1.7 0.88-2.62 1.97c-1.99 2.32-6.19 2.66-6.19 0.5 0-0.82-0.46-1.5-1-1.5s-0.97 0.42-0.97 0.93 0.43 1.2 0.97 1.54c0.54 0.33 1 1.02 1 1.53 0 1.87-1.68 0.84-2.91-1.79-1.18-2.53-1.31-2.56-2.06-0.71-0.99 2.45-1.19-6.06-0.28-11.57 0.71-4.29 5.18-9.2 9.22-10.09 1.91-0.42 2.87-1.38 3.28-3.25 0.34-1.6 2.14-3.74 4.53-5.41 2.18-1.52 3.94-3.21 3.94-3.75 0-0.53-1.51 0.2-3.38 1.63-2.5 1.91-3.99 2.4-5.65 1.87-6.86-2.17-12.59-9.92-12.57-16.96 0.01-2.55 0.37-5.25 0.85-6 0.66-1.05 4.98-1.79 8.34-1.85zm-78.69 0.41c0.3 0.02 0.51 0.22 0.72 0.56 0.94 1.52 0.19 2.75-1.65 2.75-0.78 0-1.41 0.46-1.41 1s0.66 0.97 1.47 0.97 1.47-0.43 1.47-0.97 0.46-1 1-1 0.97 0.66 0.97 1.47-0.38 1.5-0.88 1.5-1.59 0.22-2.41 0.53c-0.9 0.35-1.9-0.24-2.59-1.53-0.95-1.78-0.77-2.41 1.09-4.03 1.04-0.9 1.72-1.29 2.22-1.25zm-104.87 0.44c2.05 0.05 1.66 0.34-1.75 1.28-2.44 0.66-6.41 2.46-8.84 4-2.44 1.54-4.73 3.31-5.13 3.9-0.52 0.78-0.74 0.78-0.75-0.03-0.05-3.49 10.39-9.31 16.47-9.15zm-98.658 0.28c0.209-0.01 0.492 0.18 0.907 0.53 0.753 0.62 1.597 2.03 1.875 3.09 0.278 1.07 0.153 2.13-0.25 2.38-1.246 0.77-3-1.68-3-4.19 0-1.2 0.121-1.8 0.468-1.81zm115.53 0.62c0.58 0 1.07 0.46 1.07 1s-0.2 0.97-0.44 0.97-0.7-0.43-1.03-0.97c-0.34-0.54-0.17-1 0.4-1zm99.82 0.19c-0.21 0.07-0.32 0.6-0.28 1.37 0.04 1.15 0.24 1.38 0.56 0.6 0.28-0.71 0.26-1.55-0.06-1.88-0.09-0.08-0.16-0.12-0.22-0.09zm-219.13 0.09c0.256-0.12 0.328 0.46 0.344 1.88 0.03 2.64 1.638 4.85 4.75 6.59 2.331 1.31 1.163 1.88-1.406 0.69-3.151-1.46-5.619-6.09-4.375-8.22 0.325-0.56 0.534-0.86 0.687-0.94zm178.59 0.38c-0.92 0.08-0.93 0.56-0.56 1.75 0.35 1.11 1.03 2.19 1.5 2.37s0.85 1.36 0.85 2.63c0 3.1 2.58 15.47 4.56 21.97 1.1 3.61 1.89 4.89 2.59 4.18 0.7-0.7 0.56-2.33-0.53-5.25-0.86-2.32-1.85-5.99-2.15-8.15-0.46-3.18 0.05-2.43 2.65 3.94 1.77 4.32 3.59 8.48 4.06 9.21 0.56 0.86 0.37 1.64-0.5 2.19-0.74 0.47-0.88 0.88-0.34 0.88 2.95 0 3.1-1.64 0.69-6.88-2.6-5.64-3.96-10.08-4.82-15.47-0.27-1.75-0.88-2.97-1.34-2.69-1.1 0.69-2.28-5.75-1.5-8.21 0.52-1.65 0.1-1.97-2.84-2.32-0.79-0.09-1.39-0.14-1.85-0.15-0.17-0.01-0.33-0.01-0.47 0zm-66.21 0.68-2.6 2.26c-2.15 1.85-2.55 2.95-2.31 6.28 0.16 2.21-0.26 4.65-0.91 5.43-0.93 1.13-0.91 1.4 0.16 1.41 1.1 0.01 1.09 0.21-0.06 0.94-1.17 0.74-1.19 1.15-0.13 2.44 1.42 1.7 5.97 2.13 5.97 0.56 0-0.54-0.54-0.96-1.22-0.97-0.82-0.01-0.73-0.35 0.25-1 1.06-0.7 1.13-1.19 0.32-1.72-0.63-0.41-1.29-2.29-1.47-4.19-0.31-3.12-0.08-3.47 2.37-3.75 3.25-0.37 3.63-2.09 0.5-2.25-1.59-0.08-1.73-0.24-0.53-0.56 0.92-0.24 1.95-1.3 2.28-2.34 1.07-3.39 2.19-2.03 2.88 3.46 0.76 6.09-0.54 9.71-5.38 15.04-1.6 1.75-3.01 3.18-3.15 3.12-0.15-0.05-1.77-0.47-3.6-0.9-7.12-1.69-11.27-7.03-11.37-14.66-0.06-3.82 0.29-4.51 2.93-6 1.65-0.93 5.71-1.92 9.04-2.16l6.03-0.44zm160.75 0.97c0.22-0.04 0.41 0.01 0.53 0.13 0.26 0.26-0.58 2.03-1.88 3.94-2.64 3.88-3.84 4.36-3.84 1.56 0-1.63 3.64-5.35 5.19-5.63zm15.84 0.66c-4.78 0-8.29 3.24-4.56 4.22 2.93 0.76 3.2 0.72 5.68-0.91 2.85-1.86 2.35-3.31-1.12-3.31zm15.53 0.06c0.92-0.04 1.95 0.37 2.28 0.91 0.7 1.13 0.67 1.13-1.97 0-1.6-0.69-1.66-0.85-0.31-0.91zm-180.81 0.1c0.07-0.03 0.17 0.01 0.25 0.09 0.33 0.33 0.35 1.16 0.06 1.88-0.31 0.78-0.55 0.58-0.59-0.57-0.03-0.78 0.08-1.33 0.28-1.4zm135.03 0.18c-0.44-0.09-0.6 0.72-0.56 2.66 0.06 3.19 0.14 3.23 1.15 1.13 0.8-1.67 0.79-2.53-0.06-3.38-0.22-0.22-0.38-0.37-0.53-0.41zm-33.84 1.07c-0.07 0-0.15 0.02-0.22 0.06-0.54 0.33-1 1.71-1 3.06 0 1.39 0.44 2.19 1 1.84 0.54-0.33 0.97-1.7 0.97-3.06 0-1.21-0.3-1.96-0.75-1.9zm-57.1 1.75c0.2-0.08 0.53 0.12 0.97 0.56 0.64 0.64 0.94 1.38 0.66 1.65-0.28 0.28-0.77 0.24-1.13-0.12s-0.69-1.13-0.69-1.69c0-0.23 0.07-0.36 0.19-0.4zm75.13 0.34c0.05-0.11 0.12 0.24 0.18 1.13 0.2 2.82 0.2 7.68 0 10.81-0.19 3.13-0.37 0.82-0.37-5.13 0-4.09 0.08-6.57 0.19-6.81zm-142.5 0.41c-2.56 0-4.63 0.48-4.63 1.06 0 0.61 1.62 0.87 3.94 0.66 5.63-0.53 6.11-1.72 0.69-1.72zm179.15 0c-0.99-0.01-1.81 0.81-1.81 2.46 0 1.98 0.51 2.47 2.5 2.47 1.75 0 2.75 0.75 3.41 2.47 1.07 2.81 2.2 3.1 3.93 1 1.01-1.21 0.77-1.65-1.37-2.47-1.42-0.54-3.07-2.07-3.69-3.43-0.75-1.66-1.97-2.5-2.97-2.5zm-68.21 0.12c0.91 0 1.59 1.25 2.68 4.06 0.89 2.3 2.51 6.43 3.6 9.19l1.96 5.06-2.87-0.12c-3.44-0.12-3.75-1.29-0.69-2.59 2.05-0.88 2.03-0.91-0.62-0.69-3.38 0.28-4.77-2.1-1.69-2.91 2.11-0.55 2.61-1.45 1.44-2.62-0.36-0.37-1.44 0.05-2.38 0.9-2.45 2.22-3.23 0.12-0.93-2.53 2.28-2.63 1.77-3.94-1.54-3.94-2.75 0-2.94-0.52-0.96-2.5 0.81-0.82 1.45-1.31 2-1.31zm-35.94 1.41c-0.44 0.03-0.92 1-1.13 2.4-0.34 2.34-0.16 2.68 0.88 1.82 1.49-1.24 1.72-3.4 0.43-4.19-0.06-0.04-0.12-0.04-0.18-0.03zm164.09 0.65c1.56-0.2-5.23 9.87-10.03 14.32-4.29 3.96-6.47 5.09-6.47 3.4 0-0.42 3.12-3.6 6.91-7.09 3.78-3.49 6.87-6.85 6.87-7.47s0.66-1.7 1.47-2.38c0.59-0.49 1.03-0.75 1.25-0.78zm-237.34 0.13c-0.57-0.1-1.66 0.25-3.1 1.03l-2.78 1.5 2.63 0.06c1.45 0.02 2.98-0.45 3.34-1.03 0.57-0.93 0.48-1.46-0.09-1.56zm170.12 0.06c0.47-0.01 0.57 1.09 0.57 4.03 0 4.1 0.43 5.19 2.71 7.06 3.39 2.77 2.43 3.03-1.06 0.29-3.38-2.67-5.12-8.69-3.09-10.72 0.4-0.41 0.66-0.65 0.87-0.66zm69.13 1.72c0.21-0.04 0.27 0.3 0.28 0.97 0.02 0.88-0.66 2.14-1.47 2.81-1.89 1.57-1.91-0.01-0.03-2.5 0.61-0.8 1-1.24 1.22-1.28zm-173.41 0.34 0.5 9.85c0.3 5.41 0.28 17.13-0.06 26.06s-0.9 24.66-1.25 34.94-1.05 21.54-1.56 25.06c-1.94 13.24-1.9 15.68 0.25 17.19 1.19 0.83 1.73 2.01 1.37 2.93-0.32 0.85-0.17 1.54 0.31 1.54 0.49 0 1.02-1.23 1.19-2.72 0.57-4.97 7.69-3.53 7.69 1.56 0 1.08-0.47 2.11-1.06 2.31-0.6 0.2-1.1 2.04-1.1 4.07 0 2.55-0.55 3.98-1.81 4.65-2.54 1.36-3.02 1.2-3.59-1-0.28-1.06-1.25-2.18-2.16-2.47s-1.73-1.45-1.81-2.59c-0.09-1.14-0.85-2.82-1.69-3.75-2.07-2.28-2.11-28.15-0.06-42.72 0.81-5.78 1.51-14.14 1.56-18.59 0.05-4.46 0.74-14.3 1.5-21.88 0.76-7.57 1.46-18.41 1.56-24.09l0.22-10.35zm-77.28 0.57c0.28-0.06 0.52-0.01 0.72 0.18 0.25 0.25 0.18 1.18-0.16 2.07-0.76 1.99-2.37 2.14-2.37 0.21 0-1.1 0.98-2.28 1.81-2.46zm88.13 0.09c-0.4 0.13-1.09 1.74-2.19 5.16-1.21 3.74-2.19 7.6-2.19 8.59 0 3.04 0.85 2.05 1.97-2.34 0.58-2.3 1.53-5.12 2.09-6.25 0.57-1.14 0.89-3.14 0.69-4.44-0.08-0.54-0.2-0.78-0.37-0.72zm-164.29 0.28c0.065 0.01 0.142 0.09 0.218 0.28 0.273 0.68 0.273 1.79 0 2.47-0.272 0.68-0.499 0.14-0.5-1.22 0-0.84 0.087-1.38 0.219-1.5 0.02-0.01 0.041-0.03 0.063-0.03zm-3 2.38c0.294 0.01 0.781 0.65 1.25 1.65 0.635 1.36 0.734 2.41 0.218 2.41-1.093 0-2.169-2.48-1.687-3.88 0.047-0.13 0.121-0.19 0.219-0.18zm278.29 1.34c-1.22-0.03-4.22 1.72-4.22 2.66 0 1.07 3.78 0.16 4.56-1.1 0.32-0.51 0.34-1.16 0.06-1.43-0.08-0.09-0.23-0.13-0.4-0.13zm-13.66 0.09c0.35-0.06 1 0.58 1.53 1.57 1.29 2.4 0.83 2.69-0.94 0.56-0.68-0.83-1.02-1.76-0.72-2.06 0.04-0.04 0.08-0.06 0.13-0.07zm-258.6 1.07c0.1-0.03 0.206-0.02 0.281 0.06 0.303 0.3 0.016 1.11-0.656 1.78-0.972 0.96-1.096 0.84-0.562-0.56 0.277-0.73 0.637-1.21 0.937-1.28zm291.88 0c0.45-0.1 0.75 0.49 0.75 1.43 0 1.09-0.43 2.26-0.97 2.6-0.54 0.33-1-0.26-1-1.35 0-1.08 0.46-2.26 1-2.59 0.07-0.04 0.16-0.08 0.22-0.09zm-115.31 0.59c-0.54 0-1 0.89-1 1.97s0.46 1.97 1 1.97 0.97-0.89 0.97-1.97-0.43-1.97-0.97-1.97zm143.19 0.25c0.28-0.02 0.11 0.44-0.47 1.53-0.6 1.12-1.57 2.32-2.16 2.69-0.77 0.48-0.78 0.11 0-1.35 0.6-1.11 1.6-2.32 2.19-2.68 0.19-0.12 0.34-0.18 0.44-0.19zm-48.38 2.06c-0.12 0.02-0.24 0.04-0.38 0.13-0.54 0.33-1 0.82-1 1.06s0.46 0.44 1 0.44c0.55 0 0.97-0.49 0.97-1.06 0-0.43-0.24-0.63-0.59-0.57zm67.88 0c-0.12 0.02-0.24 0.04-0.38 0.13-0.54 0.33-1 0.82-1 1.06s0.46 0.44 1 0.44 0.97-0.49 0.97-1.06c0-0.43-0.24-0.63-0.59-0.57zm65 0.16 0.78 5.25c0.83 5.77-1.18 11.94-3.88 11.94-1.19 0-1.13-0.28 0.19-1.6 0.87-0.87 1.29-1.86 0.97-2.18-0.33-0.33-0.99 0.07-1.5 0.87-0.82 1.27-1.07 1.26-1.97-0.03-0.85-1.23-0.99-1.14-0.75 0.47 0.19 1.29-0.37 2.02-1.69 2.25-1.62 0.27-1.71 0.15-0.5-0.69 1-0.69 1.08-1.05 0.25-1.06-0.69-0.01-1.22-1.21-1.22-2.75 0-1.52 0.54-3.34 1.22-4.06 1.01-1.09 0.94-1.25-0.47-0.76-2.47 0.88-2.23-1.93 0.28-3.28 1.12-0.59 2.55-0.92 3.16-0.72 0.61 0.21 2.02-0.54 3.13-1.65l2-2zm-295.41 1.03c0.09-0.02 0.29 0 0.65 0.09 0.73 0.19 1.96 0.35 2.72 0.35 2.56 0 1.43 1.9-1.93 3.31-1.83 0.76-3.64 1.9-4 2.5-0.84 1.35-3.5 1.42-3.5 0.09 0-0.54 0.59-1 1.31-1 1.65 0 6.02-4.53 4.94-5.12-0.23-0.12-0.28-0.2-0.19-0.22zm210.22 2.72c0.07 0.01 0.1 0.09 0.09 0.22-0.02 0.51-0.67 1.79-1.47 2.84-0.79 1.05-1.42 1.48-1.4 0.97 0.01-0.51 0.67-1.76 1.47-2.81 0.59-0.79 1.1-1.26 1.31-1.22zm-4.07 0.19c0.16-0.01 0.26 0.08 0.26 0.28 0 0.51-0.66 1.48-1.47 2.15-0.82 0.68-1.47 0.94-1.47 0.57 0-0.38 0.65-1.38 1.47-2.19 0.5-0.51 0.95-0.8 1.21-0.81zm-230.62 1.9c3.48-0.07 8.56 1.25 8.56 2.53 0 0.52-1.77 0.94-3.94 0.94-2.16 0-3.93-0.43-3.93-0.97s-0.43-0.97-0.97-0.97-1 0.66-1 1.47c0 0.84-0.88 1.47-2.03 1.47-2.95 0-2.02-3.07 1.25-4.16 0.54-0.18 1.26-0.29 2.06-0.31zm28.81 0.57c0.15-0.01 0.28-0.02 0.41 0 0.61 0.06 1 0.36 1 0.87 0 0.5-0.57 1.15-1.25 1.47-0.98 0.46-0.98 0.7 0 1.16 2.16 1 1.33 2.37-1.47 2.4-2.59 0.03-2.61 0.09-0.78 1.47 1.79 1.36 1.68 1.44-1.66 1.44-1.95 0-4.12 0.15-4.84 0.34-2.09 0.55-21.5-1.45-21.5-2.22 0-1.1 8.72-2.94 16.72-3.53 4.04-0.3 8.32-1.21 9.53-2 1.35-0.89 2.82-1.37 3.84-1.4zm152.19 0.03c0.5 0.03-0.27 1.3-2.53 3.5-2.01 1.95-3.66 3.95-3.66 4.43s-0.44 0.85-1 0.85c-1.49 0 0.71-3.77 3.81-6.5 1.83-1.61 2.99-2.31 3.38-2.28zm-147.69 0.15c0.19-0.08 0.61 0.2 1.31 0.78 0.82 0.68 1.5 1.59 1.5 2.07 0 1.46-1.71 0.96-2.34-0.69-0.52-1.35-0.71-2.05-0.47-2.16zm29 0.78c0.21 0 0.35 1.32 0.35 2.94s-0.34 2.94-0.78 2.94c-0.45 0-0.65-1.32-0.41-2.94s0.63-2.94 0.84-2.94zm54.35 0c0.84-0.04 2.1 1.14 3 3.19 1.85 4.25 7.73 13.35 10.78 16.72 1.34 1.49 3.44 2.72 4.65 2.72 2.31 0 6.29-4.18 6.29-6.59-0.01-0.78 0.42-1.15 0.96-0.82 0.54 0.34 1 0.05 1-0.65 0.01-0.71 0.98-0.13 2.19 1.31 1.22 1.43 2.91 2.81 3.72 3.09 0.95 0.33 0.68 0.55-0.72 0.6-1.24 0.04-2.61-0.78-3.22-1.91-1.41-2.63-3.11-1.5-2.34 1.56 0.45 1.8 0.18 2.41-1 2.41-0.87 0-1.59 0.69-1.59 1.56-0.01 1-0.54 1.39-1.47 1.03-0.89-0.34-1.47-0.01-1.47 0.82 0 2.07-1.59 2.68-2.91 1.09-0.64-0.77-2.46-1.69-4.03-2.03-3.35-0.74-11.3-9.19-13.47-14.28-0.8-1.9-1.86-4.21-2.34-5.16-0.55-1.08-0.5-1.72 0.12-1.72 0.55 0 0.97-0.66 0.97-1.47 0-0.99 0.37-1.44 0.88-1.47zm53.43 0.1c0.57-0.09 0.81 0.29 0.6 0.94-0.24 0.71-1.01 1.48-1.72 1.71-0.74 0.25-1.09-0.1-0.85-0.84 0.24-0.71 1.01-1.51 1.72-1.75 0.1-0.03 0.17-0.05 0.25-0.06zm-138.47 0.87c0.24 0 0.7 0.43 1.04 0.97 0.33 0.54 0.16 1-0.41 1s-1.06-0.46-1.06-1 0.2-0.97 0.43-0.97zm-44.24 1.07c0.36 0.05 0.25 0.49-0.07 1.31-0.58 1.53-5.31 2.78-5.31 1.4 0-0.48 1.14-1.31 2.53-1.84 1.63-0.62 2.48-0.93 2.85-0.87zm91.4 0c-0.22-0.08-0.14 0.31 0.19 1.18 0.37 0.97 0.91 1.52 1.22 1.22 0.3-0.3 0.01-1.11-0.66-1.78-0.36-0.36-0.61-0.58-0.75-0.62zm-24.56 0.28c0.35 0.01 0.59 0.43 0.59 1.06 0 0.84-0.46 1.53-1 1.53s-0.97-0.43-0.97-0.94 0.43-1.19 0.97-1.53c0.14-0.08 0.29-0.13 0.41-0.12zm-63.34 0.62c0.54 0 0.96 0.43 0.96 0.97s-0.42 1-0.96 1c-0.55 0-1-0.46-1-1s0.45-0.97 1-0.97zm-66.818 1.97c0.445-0.09 1.434 0.21 2.844 0.97 2.394 1.28 5.906 7.07 5.906 9.72 0.001 1.15-0.395 2.09-0.906 2.09-1.459 0-4-4.14-4-6.53 0-1.19-1.168-3.1-2.594-4.22-1.5-1.18-1.821-1.92-1.25-2.03zm213.5 0.13c0.14-0.07 0.46 0.28 0.97 1.15 0.58 0.99 0.85 2.03 0.59 2.28-0.25 0.26-0.75-0.24-1.09-1.12-0.53-1.39-0.65-2.23-0.47-2.31zm53.19 0.09c-0.12 0.04-0.19 0.17-0.19 0.41 0 0.55 0.3 1.32 0.66 1.68s0.88 0.41 1.16 0.13c0.27-0.28-0.02-1.02-0.66-1.66-0.44-0.44-0.77-0.63-0.97-0.56zm116.22 0.19c0.23 0.06 0.43 0.74 0.78 2.06 0.9 3.36 0.59 4-1 2.09-0.63-0.75-0.82-2.19-0.44-3.19 0.22-0.57 0.41-0.87 0.57-0.93 0.03-0.02 0.06-0.04 0.09-0.03zm-389.5 0.12c0.079 0.04 0.168 0.25 0.281 0.69 0.409 1.57 1.519 2.16 3.5 1.84 0.406-0.06 0.75 0.34 0.75 0.88s-0.428 0.97-0.969 0.97c-1.75 0-1.06 1.98 0.719 2.06 1.028 0.05 1.235 0.26 0.5 0.56-1.74 0.7-1.52 2.31 0.312 2.31 0.918 0 1.237 0.44 0.813 1.13-0.415 0.67 0.471 2.09 2.125 3.4 1.554 1.24 2.604 2.49 2.344 2.76-0.602 0.6-6.209-4.36-7.156-6.32-0.393-0.81-1.374-2.58-2.157-3.94-0.782-1.35-1.367-3.55-1.312-4.9 0.042-1.04 0.117-1.51 0.25-1.44zm68.281 2.1c1.8-0.12 3.97 1.38 9.53 5.71 5.13 4 13.99 9.37 15.53 9.41 0.67 0.02 2.96 0.86 5.13 1.91 2.16 1.04 4.72 1.92 5.68 1.93 1.35 0.03 1.67 0.68 1.38 2.75-0.35 2.47-0.69 2.71-4.19 2.5-2.11-0.12-5.32 0.02-7.15 0.32-3.13 0.5-3.27 0.61-1.72 2.15 1.28 1.28 3.5 1.66 9.9 1.66 6.99 0 8.41 0.32 9.38 1.87 0.82 1.32 0.86 2.12 0.09 2.88-0.76 0.76-1.06 0.58-1.06-0.66 0-2.47-1.63-1.12-2.19 1.81-0.36 1.9-0.09 2.47 1.25 2.47 0.96 0 1.95-0.54 2.19-1.21 0.24-0.68 0.8-0.89 1.25-0.47s-1.41 3.08-4.16 5.9c-2.74 2.83-5.51 6.12-6.12 7.31-0.77 1.51-1.63 1.96-2.81 1.5-1.61-0.61-1.62-0.49-0.07 1.88 1.33 2.03 1.48 3.31 0.72 6.69-1.03 4.6-3.88 8.32-4.62 6.09-0.3-0.89-0.9-0.56-1.97 0.97-1.12 1.6-1.22 2.31-0.38 2.59 1.44 0.48 1.61 11.66 0.19 12.54-1.16 0.71-1.33 3.43-0.22 3.43 0.42 0 1.49-2.31 2.38-5.15 1.31-4.2 1.65-4.64 1.72-2.32 0.08 3.18-4.02 10.87-6.25 11.72-2.23 0.86-3.88-1.77-2.07-3.28 0.82-0.68 1.48-1.93 1.47-2.81 0-1.03-0.7-0.56-1.97 1.34-1.07 1.63-1.74 3.5-1.5 4.16 0.25 0.66-0.29 1.65-1.21 2.19-1.55 0.9-1.53 0.97 0.15 1 1.5 0.02 1.27 0.5-1.15 2.62-3.14 2.75-17.82 9.65-18.69 8.78-0.29-0.28 1.2-1.23 3.31-2.09 7.46-3.05 14.09-6.34 14.69-7.31 0.84-1.37 0.11-1.23-4.07 0.75-2.68 1.27-3.73 1.41-4.03 0.53-0.41-1.22-0.64-1.14-6.68 1.94-1.63 0.82-4.49 1.79-6.38 2.18-1.89 0.4-3.9 1.09-4.44 1.5-1.06 0.81-8.35 2.5-14.87 3.47-3.01 0.45-5.25 1.73-8.6 4.94-2.49 2.39-4.56 4.49-4.56 4.65 0 0.17 0.91 0.36 2 0.44 1.1 0.08 1.73-0.29 1.41-0.81s-0.04-0.84 0.65-0.69c0.7 0.15 1.29-0.21 1.32-0.84 0.05-1.46 4.86-5.25 6.65-5.25 0.76 0 1.83-0.48 2.41-1.06s2.52-0.93 4.31-0.75c3.23 0.31 3.25 0.35 0.88 1.5-1.32 0.63-3.67 1.42-5.19 1.75-2.88 0.62-14.44 11.2-14.44 13.21 0 0.64-2.89 4.06-6.4 7.6-3.52 3.53-6.379 6.64-6.379 6.94 0 0.29 1.085 0.32 2.438 0.06 1.352-0.26 2.471-0.12 2.471 0.28 0 1.15-4.792 1.79-5.159 0.69-0.18-0.54-2.509 0.61-5.187 2.62-7.641 5.73-8.438 6.47-7.875 7.38 0.29 0.47-0.195 1.11-1.031 1.43-1.02 0.4-1.274 0.23-0.813-0.59 0.527-0.93 0.39-0.97-0.563-0.09-0.683 0.63-1.747 2.17-2.374 3.44-0.628 1.26-2.12 2.45-3.313 2.62-1.571 0.23-2.487 1.39-3.344 4.25-1.009 3.37-1.525 3.87-3.469 3.5-1.253-0.24-2.281-0.06-2.281 0.41 0 0.46 0.428 0.87 0.969 0.87 1.817 0 1.012 1.61-1.469 2.94-1.352 0.72-2.468 1.87-2.469 2.53 0 0.66-1.084 1.4-2.437 1.66-1.649 0.31-2.469 0.02-2.469-0.88 0-0.74-0.427-1.34-0.968-1.34-0.542 0-1 0.88-1 1.97 0 1.08-0.428 1.97-0.969 1.97s-1.015-0.78-1.031-1.72c-0.029-1.64-0.046-1.64-1 0-1.41 2.42-3.836 2.23-3.188-0.25 0.283-1.09 1.127-1.97 1.875-1.97s1.375-0.43 1.375-0.97c0-1.79-2.819-1.04-4.375 1.19-1.696 2.42-2.097 1.65-0.594-1.16 1.346-2.52 15.913-13.09 19.657-14.28 1.442-0.46 1.935-1.2 1.562-2.38-0.361-1.13 0.883-3.28 3.656-6.31 5.035-5.49 5.546-6.12 8.625-10.53 1.322-1.89 5.128-6.1 8.469-9.34 3.341-3.25 7.48-8.54 9.219-11.78 3.161-5.91 11.801-15.26 19.161-20.72 2.14-1.6 4.7-3.69 5.68-4.66 0.99-0.97 2.81-2.17 4-2.69 1.2-0.52 2.82-1.33 3.63-1.81s2.58-1.35 3.93-1.88c1.36-0.52 4.02-1.59 5.91-2.4s7.37-2.07 12.16-2.78c5.51-0.82 9.51-1.95 10.84-3.1l2.06-1.81-2.84 0.66c-2.02 0.46-2.65 0.33-2.16-0.47 0.42-0.67 0.08-1.16-0.87-1.16-1.48 0-1.47-0.12 0-1.59 2.69-2.69 0.65-2.86-2.22-0.19-5.06 4.71-12.02 4.37-10.47-0.53 0.55-1.73 0.46-1.91-0.75-0.91-1.14 0.95-1.94 0.87-3.84-0.43-3.19-2.18-3.83-3.23-3.85-6.29-0.02-3.69 3.41-7.56 7.38-8.31 1.86-0.35 3.12-1.03 2.81-1.53s-2.12-0.64-4.03-0.28c-3.27 0.61-3.36 0.55-2.34-1.34 0.59-1.11 1.52-2.19 2.09-2.38s1.46-3.15 1.94-6.56c1.07-7.58 2.13-9 6.84-9 4.22 0 9.88-1.73 9.88-3.03 0-1.21-4.65-1.13-5.41 0.09-0.8 1.29-4.44 1.26-4.44-0.03 0-0.55-1.24-0.9-2.75-0.78-4.03 0.31-4.99-0.73-5.68-6-0.56-4.22-0.9-4.75-3.04-4.75-1.83 0-2.25 0.37-1.75 1.59 1.78 4.3 1.67 4.94-1.15 5.57-4.63 1.01-5.32 1.35-5.32 2.53 0 0.62 0.85 0.89 1.88 0.62 2.32-0.6 4.78 0.7 3.19 1.69-0.6 0.37-1.13 0.17-1.13-0.44s-2.66 1.46-5.9 4.66c-3.25 3.19-5.88 6.22-5.88 6.68 0 0.47 1.32-0.44 2.94-2 1.62-1.55 2.94-2.39 2.94-1.84s-2.11 2.72-4.72 4.84c-2.62 2.13-4.6 4.46-4.38 5.13 0.4 1.19-2.8 1.76-3.87 0.69-0.69-0.69 2.85-13.74 4.69-17.28 0.79-1.53 2.89-4.22 4.71-6 1.83-1.79 3.66-4.34 4.07-5.69 1.62-5.43 5.75-10.91 10.62-14.06 0.95-0.62 1.65-0.98 2.47-1.03zm52.34 0.34c1.16 0 2.75 0.34 3.97 1 1.04 0.55 2.42 1.98 3.06 3.19 1.06 1.98 1.02 2.06-0.46 0.84-0.9-0.74-1.66-0.99-1.66-0.56s-1.12-0.26-2.47-1.53c-1.97-1.85-2.47-1.99-2.47-0.72 0 0.87 0.46 1.85 1 2.18 0.54 0.34 0.97 1.03 0.97 1.54 0 0.9-2.18 1.31-3 0.56-0.22-0.21-6.41-0.72-13.72-1.1-7.3-0.37-15.71-1.32-18.69-2.15-6.47-1.81-8.99-3.68-3.93-2.91 9.2 1.41 13.66 1.74 21.03 1.56 4.4-0.1 9.71-0.13 11.78-0.06 2.36 0.09 3.52-0.21 3.12-0.84-0.4-0.66 0.32-1 1.47-1zm264.5 0c0.87 0 1.1 0.52 0.69 1.59-0.35 0.91-0.06 2.01 0.63 2.44 1 0.62 0.97 1.03 0 2-0.68 0.67-1.22 1.93-1.22 2.75 0 1.05 0.46 0.81 1.53-0.72 1.83-2.61 4.34-2.87 4.5-0.47 0.06 0.95 0.26 3 0.44 4.53 0.24 2.09-0.05 2.65-1.1 2.25-0.77-0.29-1.75 0.15-2.22 0.97-1.07 1.92-5.32 2.42-7.43 0.88-1.73-1.27-2.17-3.44-0.72-3.44 0.48 0 1.13-0.8 1.47-1.75 0.33-0.95 0.84-2.26 1.15-2.94 0.33-0.69-0.06-1.22-0.9-1.22-0.82 0-1.79 0.89-2.13 1.97s-1.29 1.97-2.12 1.97c-1.06 0-1.31-0.52-0.82-1.72 0.39-0.94 0.95-2.53 1.22-3.47s0.87-1.45 1.35-1.15c0.47 0.29 0.54-0.23 0.18-1.16-0.5-1.31-0.25-1.57 1.07-1.06 0.93 0.36 1.45 0.26 1.15-0.22-0.29-0.48 0.15-1.14 1-1.47 0.99-0.38 1.76-0.56 2.28-0.56zm-242.87 0.97c0.54 0 0.97 0.65 0.97 1.47 0 0.81-0.43 1.46-0.97 1.46s-0.97-0.65-0.97-1.46c0-0.82 0.43-1.47 0.97-1.47zm-66.13 0.28c0.54 0.02 1.63 0.4 3.16 1.19 4.97 2.57 21.54 5.36 32.47 5.5 4.81 0.06 9.5 1.25 14.5 3.62 3.56 1.7 4.39 3.67 1.09 2.63-1.76-0.56-1.98-0.38-1.43 1.15 0.55 1.55 0.36 1.5-1.1-0.28-1.24-1.5-2.3-1.89-3.69-1.37-1.07 0.39-3.5 0.38-5.4-0.07-4.45-1.03-4.94-1.03-4.94 0 0 0.48 1.68 1.12 3.72 1.44 3.98 0.64 13 5.84 13 7.5 0 1.32-1.03 1.24-3.44-0.37-1.87-1.26-11.03-3.98-21.65-6.41-5.08-1.16-21.16-8.6-21.16-9.78 0-0.37-1.34-1.49-3-2.47-2.44-1.44-3.03-2.32-2.13-2.28zm177.63 0.19c0.29-0.04 0.24 0.42-0.03 1.46-0.65 2.47-2.28 3.67-2.28 1.69 0-0.77 0.63-1.95 1.4-2.59 0.43-0.36 0.74-0.54 0.91-0.56zm-102.19 0.81c0.07-0.11 0.47 0.26 1.22 0.94 1.17 1.05 3.49 1.71 6 1.71 3.66 0.01 4.16 0.27 4.69 2.69 1.13 5.18 1.69 5.81 2.44 2.72 0.53-2.21 0.72-1.29 0.81 3.69 0.06 3.65 0 6.62-0.16 6.62-0.96 0-2.65-2.59-2.65-4.09 0-0.97-0.45-1.78-0.97-1.78-1.67 0-7.68-5.84-9.91-9.63-1.08-1.84-1.56-2.74-1.47-2.87zm193.85 0.65c0.33 0.01 0.39 0.32-0.04 1-0.33 0.54-1.56 1.48-2.75 2.1-2.14 1.12-2.14 1.16-0.28-0.94 1.18-1.32 2.5-2.17 3.07-2.16zm-126.16 0.44c0.21 0.02 0.61 0.3 1.22 0.91 0.81 0.81 1.47 1.75 1.47 2.06 0 0.77-1.48 0.71-2.29-0.09-0.36-0.36-0.68-1.3-0.68-2.06 0-0.58 0.06-0.83 0.28-0.82zm30.28 2.72c1.19 0.03 1.25 3.44-0.06 4.25-0.54 0.34-0.97 1.45-0.97 2.47 0 2.96-2.2 6.98-3.53 6.47-0.73-0.28-1.9 1.2-2.88 3.65-1.43 3.57-2.09 6.39-3.94 16.91-0.19 1.08-1.05 5.67-1.93 10.19-1.5 7.67-1.46 10.27 0.15 8.66 0.38-0.38 1.26-4.33 1.94-8.79 1.06-6.89 1.15-7.12 0.66-1.68-0.32 3.51-0.74 10.94-0.88 16.53-0.14 5.58-0.43 10.37-0.68 10.62-0.26 0.26-0.67-2.29-0.91-5.65-0.41-5.65-0.75-6.34-4.22-9.25-3.46-2.91-3.7-3.46-3.22-7.07 0.29-2.15 1.2-5.41 2.03-7.25 0.84-1.83 2.24-5.55 3.13-8.25 0.88-2.69 1.96-5.35 2.4-5.9 0.44-0.56 1.57-3.43 2.47-6.41 1.93-6.35 8.49-18.9 10.19-19.47 0.09-0.03 0.17-0.03 0.25-0.03zm89.91 0.88c0.56-0.03 0.39 0.4-0.44 1.4-1.36 1.64-2.97 1.96-2.97 0.6 0-0.49 0.71-1.18 1.56-1.5 0.9-0.35 1.51-0.49 1.85-0.5zm-86.75 1.9c0.12 0 0.08 6.27-0.1 13.97-0.38 16.47 0.31 22.86 2.38 22.06 1.82-0.7 1.95 6.79 0.15 8.69-0.67 0.71-1.95 2.17-2.84 3.25-0.89 1.09-2.42 2.44-3.37 2.97-2.15 1.2-3.41 12-1.41 12 0.85 0 1.03-1.02 0.59-3.38-0.36-1.95-0.21-3.6 0.38-3.96 0.59-0.37 1 0.42 1 1.93 0 1.47 0.44 2.32 1 1.97 0.54-0.33 0.97-1.71 0.97-3.06 0-1.39 0.44-2.19 1-1.84 0.54 0.33 0.97 2.28 0.97 4.34 0 5.21 1.06 9.91 2.21 9.91 0.56 0 0.74-1.36 0.41-3.19-1.69-9.37-1.55-11.69 0.28-4.69 1.06 4.06 2.13 8.49 2.41 9.85 0.3 1.46 2.52 3.99 5.5 6.21 2.74 2.05 4.72 4.17 4.37 4.72-0.34 0.56-2.35 0.9-4.44 0.75-2.08-0.15-4.08 0.03-4.46 0.41-0.87 0.87-1.34 0.79-3.82-0.63-3.82-2.19-6.04-4.12-8.28-7.18-2.05-2.82-2.28-4.23-2.4-15.44-0.13-11.28 0.02-12.5 1.81-13.81 1.34-0.99 2.18-1.07 2.62-0.35 0.45 0.72 1.13 0.6 2.1-0.37 2.01-2.01 2.8-5.04 1.75-6.72-0.74-1.18-1.35-1.23-3.56-0.22-4.23 1.92-4.87 0.42-3.57-8.41 0.62-4.2 1.42-10.54 1.78-14.06 0.37-3.52 0.73-6.83 0.85-7.37 0.27-1.3 3.42-8.35 3.72-8.35zm-120.85 0.32c0.36-0.07 0.57 0.12 0.57 0.53 0 0.54-0.43 1.26-0.97 1.59s-1 0.2-1-0.34 0.46-1.29 1-1.63c0.13-0.08 0.28-0.13 0.4-0.15zm39.31 0.46c0.29-0.06 0.61 0.01 1.04 0.16 1.69 0.6 1.72 0.72 0.25 1.28-1.14 0.44-1.66 1.79-1.66 4.28 0 4.23 0.9 3.88 1.94-0.78 0.6-2.71 0.86-1.91 1.5 4.88 1.05 11.17 2.74 11.65 1.97 0.56-0.47-6.62-0.34-8.3 0.5-6.97 0.6 0.96 1.37 7.22 1.68 13.91 0.63 13.36 0.74 12.97-5.96 20.22-1.97 2.12-3.59 4.68-3.6 5.65-0.05 4.19-4.44 10.99-11.37 17.66-9.69 9.32-9.61 11.33 0.5 12.47 6.95 0.78 8.51 2.3 7 6.72-1.07 3.1-7.94 8.83-7.94 6.62 0-0.54 1.35-1.7 2.97-2.62 3.36-1.92 3.88-5.09 0.97-5.85-1.09-0.28-1.97-0.82-1.97-1.19s-2.22-1.45-4.94-2.43l-4.97-1.79 0.56-19.34c0.32-10.62 0.8-21.97 1.03-25.22 0.24-3.24 0.74-10.88 1.1-16.97 0.66-11.18 1.9-15.43 1.72-5.9-0.08 4.24-0.02 4.43 0.31 1 0.57-6.04 3.22-4.96 3.22 1.31 0 1.46 0.56 2.38 1.47 2.38 1.29-0.01 1.43 2.71 0.87 21.62-0.47 15.97-0.33 21.66 0.5 21.66 0.81 0 1.1-5.44 1.1-19.19 0-11.2 0.4-19.19 0.93-19.19 0.55 0 0.77 6.24 0.57 15.25-0.2 8.62 0.05 15.5 0.56 15.81 0.53 0.33 0.91-5.69 0.91-14.75 0-9.54 0.35-15.31 0.96-15.31 0.54 0 1.02 2.32 1.07 5.16 0.04 2.84 0.45 7.39 0.87 10.09 0.72 4.59 0.78 4.37 0.91-3.37 0.09-5.95 0.43-8.04 1.19-7.28 0.58 0.58 1.29 2.89 1.59 5.12s0.94 4.03 1.44 4.03c0.49 0 0.83-0.54 0.75-1.22-0.09-0.67-0.12-1.87-0.04-2.69 0.12-1.16 0.38-1.12 1.19 0.29 0.77 1.32 0.66 2.38-0.5 4.15-1.78 2.72-2.02 4.41-0.59 4.41 0.54 0 0.97-0.66 0.97-1.47s0.42-1.5 0.9-1.5c0.49 0 1.15-1.14 1.5-2.56 0.48-1.92-0.03-3.65-2.06-6.66-5.6-8.33-5.89-9.35-4.78-16.44 0.68-4.35 1.03-5.8 1.87-6zm98.97 0.19c-0.54 0-0.97 0.49-0.97 1.06 0 0.58 0.43 0.74 0.97 0.41s1-0.79 1-1.03-0.46-0.44-1-0.44zm45.25 0.13c0.63 0 1.25 0.06 1.72 0.18 0.95 0.25 0.18 0.47-1.72 0.47-1.89 0-2.66-0.22-1.72-0.47 0.48-0.12 1.1-0.18 1.72-0.18zm-16.72 0.87c1.62 0 1.15 3.64-1 7.47-1.1 1.97-1.81 3.78-1.53 4.06 0.76 0.76 3.63-1.81 4.57-4.12 0.77-1.91 0.81-1.88 0.87 0.28 0.04 1.35-1.23 3.42-3.12 5.16-1.75 1.59-2.75 2.93-2.22 3 0.52 0.06 1.62 0.17 2.43 0.24 0.88 0.08 1.63 1.32 1.82 3.07 0.45 4.19 1.9 5.23 2.72 1.97l0.65-2.72 1.28 2.34c1.17 2.17 1 2.36-2.37 3.53-4.81 1.68-4.66 1.76-4.53-2.15 0.07-2.27-0.33-3.44-1.19-3.44-0.72 0-1.3 0.54-1.31 1.22-0.01 0.82-0.27 0.89-0.75 0.18-0.4-0.58-1.52-1.33-2.47-1.68-1.26-0.47-1.72-1.75-1.72-4.69 0-2.22-0.44-4.89-1-5.94-0.85-1.58-0.69-1.9 0.94-1.9 3.26 0 6.97-2.15 6.97-4.07 0-0.99 0.42-1.81 0.96-1.81zm13.72 0.97c0.58 0 1.04 0.46 1.04 1s-0.2 0.97-0.44 0.97-0.7-0.43-1.03-0.97c-0.34-0.54-0.14-1 0.43-1zm75.25 0.31c-0.53 0.09-1.28 1.15-1.68 2.69-0.44 1.67-0.31 1.83 0.84 0.88 0.77-0.64 1.41-1.82 1.41-2.6 0-0.74-0.25-1.02-0.57-0.97zm-371.46 0.72c0.579 0.03 1.413 0.54 2.187 1.47 0.685 0.82 0.942 1.78 0.594 2.12-0.347 0.35-0.625 0.1-0.625-0.53s-0.657-1.12-1.469-1.12c-0.811 0-1.5-0.46-1.5-1 0.001-0.55 0.246-0.83 0.594-0.91 0.073-0.01 0.136-0.03 0.219-0.03zm366.5 1.28c-0.11 0.02-0.23 0.08-0.37 0.16-0.54 0.33-1 0.79-1 1.03s0.46 0.44 1 0.44 0.97-0.46 0.97-1.03c0-0.43-0.24-0.66-0.6-0.6zm-7.15 0.57c0.49-0.09 1.31 0.73 2.53 2.53 3.15 4.63 2.43 6.69-0.88 2.47-1.4-1.8-2.31-3.91-2.03-4.66 0.09-0.23 0.22-0.32 0.38-0.34zm-193.91 0.15c0.5-0.05 1.05 0.98 1.13 3.13 0.23 6.67 1.04 7.84 1.84 2.68 0.61-3.91 0.68-3.53 0.81 3.22 0.09 4.2-0.07 7.63-0.34 7.63s-0.47-1.12-0.47-2.47-0.39-2.47-0.84-2.47c-1.35 0-3.1-4.76-3.1-8.41 0-2.15 0.47-3.26 0.97-3.31zm-36.15 0.13-0.63 4.59c-0.36 2.51-1.08 9.57-1.62 15.69-0.55 6.11-1.43 12.2-1.94 13.56-0.52 1.36-0.97 5.68-0.97 9.62 0 3.95-0.28 9.9-0.63 13.22-0.56 5.42-0.84 6.07-2.81 6.07-1.21 0-2.76 0.65-3.43 1.47-0.68 0.81-1.62 1.5-2.1 1.5-1.12-0.01-1.12-2.33 0-3.54 1.55-1.67 3.99-15.42 4.63-26 0.34-5.68 0.94-10.77 1.28-11.31s0.82-6.27 1.09-12.75l0.5-11.78 3.31-0.19 3.32-0.15zm-95.03 0.15c0.8 0.03 1.34 0.22 1.34 0.6 0 0.55-0.11 1-0.25 1s-1.68 0.43-3.44 0.93c-3 0.86-4.4-0.03-2.19-1.4 1.18-0.73 3.2-1.17 4.54-1.13zm80.21 0.03c0.17-0.05 0.52 0.53 0.91 1.5 0.52 1.3 0.75 2.51 0.53 2.72-0.49 0.5-1.64-2.43-1.56-3.97 0.01-0.15 0.07-0.23 0.12-0.25zm260.29 0.66c0.28-0.1 0.01 0.4-0.66 1.66-1.22 2.29-2.06 2.84-2.06 1.34 0-0.47 0.75-1.44 1.65-2.19 0.56-0.46 0.9-0.75 1.07-0.81zm-377.16 1c0.134 0.05 0.385 0.26 0.75 0.62 0.672 0.67 0.959 1.48 0.656 1.79-0.303 0.3-0.849-0.25-1.219-1.22-0.333-0.88-0.411-1.27-0.187-1.19zm356.31 0.38c0.06-0.01 0.11-0.02 0.16 0 0.2 0.07 0.27 0.47 0.28 1.09 0.01 1.56 0.16 1.62 0.91 0.44 0.5-0.8 1.26-1.11 1.65-0.72s-0.26 1.72-1.44 2.97c-2.14 2.28-2.88 5.59-1.25 5.59 0.49 0 1.15-1.02 1.47-2.31 0.84-3.34 3.53-4.23 3.53-1.16 0 1.3-0.42 2.67-0.96 3-0.55 0.34-1 3.63-1 7.34-0.01 7.13-0.56 9.85-2.1 9.85-0.51 0-0.64-0.46-0.28-1.03 0.86-1.4-0.43-7.82-1.56-7.82-0.49 0-0.83 2.62-0.82 5.82 0.02 3.85-0.55 6.69-1.65 8.37-0.92 1.4-2.05 2.53-2.53 2.53-1.33 0-1.04-1.11 0.78-3.12 1.21-1.34 1.66-3.77 1.72-9.19 0.04-4.5-0.34-7.23-0.94-7.03-0.54 0.18-1.12 1.14-1.31 2.12-0.19 0.99-0.75 2.29-1.25 2.88-0.51 0.59-1.55 1.95-2.32 3.03-1.26 1.79-1.33 1.65-0.5-1.47 0.51-1.89 1.61-6.26 2.44-9.72 1.04-4.31 2.45-7.21 4.47-9.28 1.39-1.42 2.11-2.12 2.5-2.18zm-352.25 1.28c0.427-0.03 1.697 1.08 4.313 3.62 2.756 2.67 5.286 4.56 5.626 4.22s-0.53-1.69-1.94-3c-3.723-3.45-3.18-4.16 0.84-1.09 4.1 3.12 4.28 4.27 1 7.12-1.35 1.18-2.81 2.16-3.21 2.16-0.91 0-5.627-8.47-6.598-11.81-0.224-0.78-0.287-1.21-0.031-1.22zm25.279 0.68c0.88-0.15-4.22 5.72-7.87 9-5.91 5.31-7.07 6.54-7.07 7.38 0 0.48 0.22 0.87 0.5 0.87 0.74 0 7.13-5.78 10.72-9.71 5.16-5.65 5.59-6.04 7.28-6.04 1.15 0 0.56 1-1.9 3.22-2.55 2.3-4.72 6.03-7.72 13.28-2.3 5.56-4.58 10.32-5.03 10.6s-1.3-0.42-1.91-1.56c-0.93-1.74-0.63-2.75 1.69-6.16 4.53-6.65 4.68-7.24 1.13-3.88-3.87 3.66-6.32 4.1-7.22 1.25-0.42-1.3 0.14-2.93 1.62-4.71 2.31-2.8 12.71-11.81 15.5-13.44 0.11-0.07 0.22-0.09 0.28-0.1zm262.91 0.88c0.04-0.01 0.07-0.01 0.12 0 0.14 0.03 0.34 0.18 0.53 0.37 0.78 0.78 0.79 1.58 0.04 2.88-0.93 1.59-1.1 1.48-1.13-1.06-0.01-1.39 0.13-2.1 0.44-2.19zm-115.25 0.03c0.21-0.05 0.56 0.37 1.16 1.16 1.42 1.88 1.43 1.88 1.59-0.07 0.08-1.08 0.51 0.92 0.97 4.44 0.92 7.18 2.89 12.03 3.81 9.41 0.5-1.42 0.78-1.4 2.78 0 1.21 0.84 2.17 2.27 2.16 3.19-0.03 1.45-0.24 1.42-1.5-0.26-1.43-1.89-1.43-1.89-1.44 0-0.01 1.62-0.17 1.69-1.03 0.44-0.84-1.21-0.98-1.12-0.72 0.5 0.23 1.43 1.06 1.98 3.12 2 2.02 0.03 3.12 0.68 3.69 2.22 0.45 1.2 1.23 2.16 1.72 2.16 0.5 0 1.12 0.88 1.41 1.97 0.28 1.08 0.95 1.97 1.53 1.97 1.2 0 0.53-2.14-2-6.38-2.21-3.71-4.75-9.33-4.75-10.47 0-0.47-0.44-0.84-0.97-0.84-1.14 0-3.98-6.43-3.87-8.75 0.04-0.88 0.61-0.25 1.24 1.37 1.2 3.07 3.64 7.09 6.88 11.31 1.75 2.28 1.83 2.29 1.22 0.29-0.64-2.1-0.58-2.12 2.22-0.72 2.49 1.24 2.99 2.16 3.56 6.75 0.36 2.92 0.36 6.9 0 8.84-0.46 2.44-0.31 3.53 0.5 3.53 0.78 0 1 1.06 0.62 3.19l-0.56 3.19 1.47-3.19c2.29-4.99 3.43-3.76 1.66 1.78-1.55 4.86-1.55 5.11 0.69 9.6 2.67 5.36 3.57 7.47 5.03 11.46 0.82 2.27 1.25 2.6 1.93 1.5 0.98-1.58 0.84-1.89 2.91 5.72 0.66 2.43 0.85 6.08 0.47 8.63-0.5 3.34-0.29 4.73 0.81 5.62 1.8 1.46 2.97 4.63 1.72 4.63-0.51 0-1.39-0.89-1.97-1.97s-1.56-1.97-2.19-1.97c-0.85 0-0.84 0.28 0.03 1.16 0.65 0.65 1.19 3.19 1.19 5.65 0 2.69 0.79 5.75 1.94 7.63 1.05 1.72 2.19 4.76 2.56 6.75 0.48 2.52 0.91 3.21 1.5 2.28 0.68-1.07 0.87-1.01 0.88 0.22 0.01 0.84-0.5 2.02-1.13 2.65-0.86 0.87-0.87 2.07-0.03 4.88 0.61 2.05 1.4 6.21 1.75 9.25 0.41 3.46 0.27 5.73-0.37 6.12-1.12 0.69-7.1-5.94-7.1-7.87 0-0.65-0.57-1.8-1.25-2.53-2.33-2.54-12.3-21.26-12.87-24.16-0.19-0.93-0.67-2.42-1.07-3.34-0.39-0.92-0.44-2.15-0.09-2.72s-0.05-1.06-0.87-1.06c-0.99 0-2.05-1.96-3.13-5.66-0.9-3.1-2-6.31-2.41-7.13-0.4-0.81-1.51-4.78-2.46-8.84s-2.01-7.83-2.38-8.37c-1.17-1.74-2.98-8.98-2.97-11.91 0.01-2.19 0.23-2.52 0.97-1.38 0.53 0.82 0.96 2.48 0.97 3.69 0.01 1.22 0.38 2.22 0.81 2.22 0.44 0 1.61 2.93 2.63 6.47 1.01 3.54 2.23 6.67 2.72 6.97 1.76 1.09 1.87-0.57 0.25-4.25-2.32-5.26-3.74-9.14-7.13-19.5-0.88-2.71-2.08-5.22-2.62-5.6-1.31-0.89-1.82-8.68-0.57-8.68 0.54 0 1 0.77 1 1.72 0.03 2.99 5.3 18.51 9.28 27.31 0.74 1.62 2.73 6.06 4.44 9.84 5.95 13.14 9.08 19.19 9.91 19.19 0.46 0-0.65-3-2.47-6.66-5.87-11.74-9.21-19.35-9.81-22.37-0.55-2.74-0.54-2.8 0.53-0.75 0.63 1.22 1.47 2.22 1.84 2.22 0.38 0 1.55 1.89 2.56 4.18 1.02 2.3 2.12 4.39 2.44 4.66 0.33 0.27 1.46 2.05 2.5 3.94 2.76 5 5.34 8.35 5.25 6.78-0.04-0.75-0.93-2.69-1.97-4.31-1.03-1.63-2.45-4.06-3.12-5.41s-1.51-2.67-1.88-2.94c-0.36-0.27-1.75-2.93-3.09-5.9-1.34-2.98-3.15-6.3-4-7.38-1.48-1.87-1.56-1.87-1.59-0.12-0.06 3.23-2.4 0.15-3.82-5-0.72-2.61-1.9-6.07-2.62-7.69-1.49-3.36-4.39-12.95-4.44-14.63-0.02-0.61-0.63-1.91-1.4-2.93-1.28-1.68-1.38-1.5-0.85 1.97 0.33 2.1 0.32 3.57 0 3.28s-0.8-3.15-1.09-6.32c-0.3-3.16-1.22-7.05-2.03-8.68-0.82-1.63-1.5-4.56-1.5-6.47 0-1.84 0.04-2.66 0.31-2.72zm78.5 0.59c0.56-0.02 0.87 0.2 0.87 0.69 0 1.27-3.77 5.22-5 5.22-0.55 0-1.68 0.66-2.5 1.47-0.81 0.81-2.04 1.5-2.75 1.5-0.7 0-1.85-0.69-2.53-1.5-0.84-1.02-0.89-1.47-0.12-1.47 0.6 0 1.13 0.57 1.15 1.25 0.03 0.68 1.49-0.42 3.25-2.41 2.27-2.55 5.94-4.68 7.63-4.75zm-111.78 0.5c-0.17 0.02-0.27 0.76-0.25 1.97 0.02 1.63 0.22 2.15 0.47 1.19s0.23-2.27-0.04-2.94c-0.06-0.16-0.13-0.22-0.18-0.22zm87.18 0c0.36-0.06 0.47 0.53 0.22 1.47-0.6 2.3-1.31 2.6-1.31 0.57 0-0.78 0.42-1.67 0.91-1.97 0.06-0.04 0.13-0.06 0.18-0.07zm35.38 0.57c2.08 0 4.41 1.57 7.75 4.97 2.74 2.77 4.97 5.57 4.97 6.18s1.16 2.3 2.53 3.78c2.16 2.33 3.27 2.69 8.13 2.69 5.82 0 17.52 2.01 21.81 3.72 1.35 0.54 5.78 1.3 9.84 1.69 4.43 0.42 9.41 1.64 12.47 3.06 2.81 1.3 5.65 2.38 6.28 2.38s2.46 1.08 4.06 2.43c2.71 2.28 2.4 2.99-1.06 2.5-0.86-0.12-1.13 0.39-0.75 1.38s0.04 1.56-0.94 1.56c-0.96 0-1.42 0.77-1.31 2.19 0.1 1.21 0.12 2.79 0.06 3.47-0.21 2.45-2.66 1.17-2.62-1.38 0.03-2.02-0.5-2.67-2.41-2.97-1.34-0.21-4.01-1.51-5.93-2.84-1.93-1.34-4.14-2.41-4.88-2.41s-2.16-0.72-3.16-1.62c-1.59-1.45-2.11-1.48-4.4-0.25-3.14 1.68-24.07 1.82-26.1 0.18-0.71-0.57-2.8-1.38-4.65-1.78-3.99-0.85-9.42-3.72-9.44-5-0.02-1.19-3.64-5.31-4.66-5.31-0.44 0-0.33 0.89 0.25 1.97 1.75 3.26 0.1 2.25-5.18-3.19-2.76-2.84-4.69-4.61-4.28-3.93 0.4 0.67 0.29 1.21-0.26 1.21-1.44 0-1.98-1.23-2.18-5-0.24-4.46 0.23-5.97 2.47-8.03 1.19-1.09 2.34-1.66 3.59-1.65zm-73.53 0.62c0.58-0.03 0.69 0.46 0.69 1.66 0 1.18 0.71 3.12 1.56 4.34 1.79 2.56 1.52 4.87-0.34 3-0.67-0.67-1.24-1.68-1.26-2.25-0.01-0.57-0.74-1.92-1.59-3-1.51-1.92-1.53-1.94-0.84 0.34 0.43 1.46 0.35 2.13-0.25 1.76-2.13-1.32-1.91-4.16 0.4-5.26 0.78-0.36 1.28-0.57 1.63-0.59zm-18.47 0.5c0.05 0.04 0.13 0.23 0.19 0.53 0.23 1.22 0.23 3.22 0 4.44-0.24 1.22-0.44 0.22-0.44-2.22 0-1.82 0.1-2.87 0.25-2.75zm120.69 1.53c0.3-0.13 0.68 0.82 1.47 3.16 1.58 4.69 1.26 5.76-1.07 3.44-1.78-1.79-1.84-1.98-0.97-5.25 0.22-0.79 0.38-1.27 0.57-1.35zm-176.38 0.22c0.58 0 1.07 0.46 1.07 1s-0.2 0.97-0.44 0.97-0.73-0.43-1.06-0.97c-0.34-0.54-0.14-1 0.43-1zm63.94 0c0.45 0 1.09 1.23 1.37 2.72 0.58 2.97 0.26 3.91-0.74 2.28-1.08-1.74-1.5-5-0.63-5zm185.78 0c0.42 0 0.86 1.12 0.97 2.47 0.23 2.8-0.25 3.2-1.12 0.91-0.82-2.12-0.77-3.38 0.15-3.38zm-285.25 0.1c1.94-0.06 3.02 0.31 2.66 0.9-0.34 0.54-0.71 0.93-0.82 0.88-0.1-0.06-1.27-0.45-2.62-0.88-2.31-0.74-2.28-0.81 0.78-0.9zm19.25 0.03c0.73-0.07 1.85 0.04 3.59 0.21 8.5 0.85 10.44 5.73 9.54 24.26-0.6 12.18-3.86 25.92-8.04 33.96-0.76 1.47-1.15 3.22-0.9 3.88s-0.25 1.77-1.1 2.47c-1.19 0.99-1.27 1.58-0.37 2.65 0.87 1.05 0.86 1.67 0 2.54-0.63 0.62-1.13 1.74-1.13 2.46 0 0.73-0.83 2.23-1.87 3.35-2.07 2.22-1.73 4.98 0.5 4.12 0.77-0.29 1.37-0.03 1.37 0.57 0 1.96-4.08 1.16-4.62-0.91-0.28-1.08-0.9-1.97-1.38-1.97-1.13 0-1.12 0.7 0.13 3.03 0.78 1.47 0.7 1.88-0.37 1.88-0.77 0-1.73-0.97-2.13-2.19l-0.72-2.22-0.44 2.22c-0.54 2.74-2.28 2.93-2.28 0.25 0-1.09-0.65-1.97-1.47-1.97-0.91 0-1.46 0.91-1.46 2.44 0 1.35-0.46 2.47-1 2.47-2.77 0 0.84-7.21 6.78-13.57 1.65-1.77 3.51-5.09 4.09-7.37 0.58-2.29 1.25-4.74 1.5-5.47s0.68-6.27 0.97-12.28c0.33-6.79 1.26-13.11 2.44-16.69l1.87-5.75-2.44-9.03c-1.33-4.97-2.4-10.08-2.4-11.34 0-1.36 0.12-1.9 1.34-2zm-52.75 1.84c0.11 0-0.06 0.49-0.37 1.47-0.35 1.08-2.24 3.67-4.19 5.75-4.37 4.64-8.97 8.04-8.97 6.62 0-0.57 0.42-1.06 0.91-1.06 0.87 0 8.44-7.52 11.37-11.31 0.76-0.98 1.14-1.47 1.25-1.47zm159.72 0c2.14 0 2.17 0.1 0.97 3.25-0.51 1.34-0.51 2.94-0.03 3.72 0.59 0.96 1.03 0.12 1.5-2.78 0.36-2.28 0.94-3.95 1.31-3.72 0.92 0.57 0.08 7.3-1 7.97-0.48 0.29-0.91 1.61-0.91 2.93 0 1.33-0.46 2.41-1.06 2.41-0.64 0-0.86-0.92-0.53-2.25 0.34-1.37-0.19-3.5-1.34-5.4-2.15-3.54-1.69-6.13 1.09-6.13zm46.31 0c2.28 0 2.21 1.22-0.56 10.84-1.93 6.7-2 10.85-0.22 13.29 1.14 1.55 1.61 1.64 2.88 0.59 0.83-0.7 1.33-1.77 1.09-2.41-0.24-0.63 0.71-1.67 2.09-2.31 2.48-1.15 2.54-1.11 1.88 1.97-0.37 1.72-1.11 3.67-1.66 4.34-1.41 1.76-5.25 1.53-7.22-0.44-2.1-2.1-4.39-7.35-3.68-8.5 0.76-1.24 0.9-9.5 0.15-9.5-0.34 0.01-0.94 1.66-1.34 3.69l-0.75 3.69-1.28-2.94c-2.26-5.12-1.79-7.33 1.97-8.9 1.85-0.78 3.66-1.86 4-2.41s1.54-1 2.65-1zm-133.62 1.19c0.06-0.03 0.17 0.01 0.25 0.09 0.32 0.33 0.34 1.17 0.06 1.88-0.31 0.78-0.52 0.55-0.56-0.6-0.03-0.78 0.05-1.3 0.25-1.37zm-76.28 0.28c0.36 0 0.35 0.46-0.25 1.44-0.36 0.57-1.63 1.54-2.82 2.15-2.05 1.07-2.05 0.97 0.22-1.5 1.28-1.38 2.38-2.09 2.85-2.09zm182.53 0.69c0.06-0.03 0.17 0.01 0.25 0.09 0.32 0.33 0.34 1.16 0.06 1.88-0.31 0.78-0.55 0.55-0.59-0.6-0.04-0.78 0.08-1.3 0.28-1.37zm-85.06 0.81c-0.89 0-1.99 5.88-1.32 6.97 0.94 1.51 1.21 1.03 1.6-3.03 0.2-2.17 0.07-3.94-0.28-3.94zm-71.16 0.47c-0.41 0.12-1.21 0.72-2.5 1.81-1.72 1.45-3.67 2.62-4.38 2.62-0.7 0-1.85 0.66-2.53 1.47-1.58 1.92-0.57 1.86 3.28-0.15 1.71-0.89 3.79-1.9 4.6-2.28 0.81-0.39 1.65-1.52 1.84-2.5 0.15-0.74 0.1-1.1-0.31-0.97zm169.09 0.34c0.02-0.01 0.04-0.01 0.07 0 0.05 0.03 0.09 0.17 0.15 0.41 0.25 0.94 0.25 2.49 0 3.44-0.25 0.94-0.44 0.17-0.44-1.72 0-1.25 0.09-2.02 0.22-2.13zm-72.15 0.72c0.89 0.01 1.55 13.99 1 21.91-0.13 1.8 0.29 3.88 0.9 4.62 0.62 0.74 0.84 2.2 0.5 3.25-0.33 1.05-0.12 4.97 0.47 8.66s0.84 7.59 0.56 8.69c-0.76 3.05-5.5 9.12-5.5 7.06 0-0.94 0.61-1.94 1.35-2.22 1.56-0.6 4.21-7.95 3.22-8.94-1.9-1.9-6.69-0.97-9.75 1.91-4.03 3.78-8.89 4.92-15.57 3.65-2.84-0.53-5.31-1.12-5.5-1.31-0.77-0.78 0.98-3.56 2.25-3.56 0.76 0 1.38-0.49 1.38-1.06 0-0.6 0.84-0.8 1.97-0.44 1.56 0.5 1.83 0.3 1.31-1.06-0.4-1.05-0.28-1.45 0.34-1.07 0.56 0.35 2.03-0.47 3.29-1.81 2.94-3.13 4.08-3.09 2.87 0.09s-1.25 9.29-0.06 9.29c0.49 0 1.09-2.55 1.31-5.66 0.3-4.21 0.01-5.99-1.09-6.91-0.94-0.78-1.03-1.22-0.29-1.22 0.65 0.01 1.16-1.08 1.16-2.4s0.35-2.61 0.78-2.88c0.43-0.26 0.59 1.02 0.38 2.88-0.24 2.05 0.05 3.37 0.72 3.37 0.62 0 1.13-1.97 1.22-4.65 0.1-3.31 0.29-3.81 0.59-1.72 0.85 5.99 2.24 4.81 2.41-2.03 0.09-4.01 0.3-5.29 0.53-3.13 0.21 2.03 0.82 3.69 1.34 3.69 0.56 0 0.73-1.83 0.37-4.44-0.39-2.89-0.25-4.43 0.44-4.43 0.7 0 1.06 3.74 1.06 10.96 0.01 6.05 0.27 10.74 0.6 10.41s0.61-6.03 0.62-12.69c0.02-9.06 0.23-11 0.82-7.68 0.42 2.43 0.8 7.83 0.84 12.03 0.04 4.37 0.5 7.62 1.06 7.62 1.2 0 1.21-0.25 0-21.06-0.64-11.08-0.65-17.04 0-17.69 0.03-0.03 0.07-0.03 0.1-0.03zm192.96 0.59c0.16 0.04 0.42 0.39 0.85 1.13 0.57 0.99 0.85 1.99 0.62 2.22-0.69 0.69-1.75-0.78-1.71-2.44 0.01-0.64 0.09-0.94 0.24-0.91zm-161.18 0.19c0.35 0.02 0.56 0.43 0.56 1.06 0 0.85-0.43 1.53-0.97 1.53s-1-0.39-1-0.9 0.46-1.23 1-1.56c0.14-0.09 0.29-0.13 0.41-0.13zm64.47 0.63c-1.4 0-1.13 1.33 0.78 3.72 1.83 2.29 3.19 2.82 3.19 1.21-0.01-0.54-0.41-1-0.91-1-0.51 0-1.19-0.88-1.53-1.97-0.35-1.08-1.03-1.96-1.53-1.96zm-258.19 0.31c0.07-0.06 0.236 0.03 0.437 0.15 1.037 0.65 9.384 17.59 10.434 21.19 0.4 1.36 1.17 3.03 1.72 3.72s0.78 1.47 0.5 1.75c-0.27 0.28-1.17-0.97-2-2.75s-3.44-7.19-5.78-12.06c-4.448-9.25-5.616-11.75-5.311-12zm67.811 1.09c-0.13 0.06 0.07 0.66 0.47 1.72 0.54 1.45 1.54 3.54 2.22 4.63 0.68 1.08 1.6 1.73 2.03 1.47 1.26-0.78 0.87-1.63-2.28-5.29-1.54-1.78-2.26-2.6-2.44-2.53zm100.5 0.06 0.72 11.82c0.39 6.49 1.13 15.36 1.66 19.68 1.87 15.48 1.96 17.34 0.97 16.72-0.54-0.33-0.97-2.1-0.97-3.93s-0.38-3.56-0.85-3.85c-0.46-0.28-0.65 3.77-0.44 9.03 0.55 13.44 1.29 20 2.26 19.41 0.45-0.28 0.71-1.64 0.56-3.03s0.05-2.16 0.47-1.72c0.41 0.44 0.9 2.9 1.09 5.47 0.37 4.95-0.11 5.66-2.19 3.16-0.7-0.86-2.92-2.41-4.93-3.44-4.1-2.09-5.48-5.59-4.32-11.03 1.48-6.91 4.41-7.04 4.41-0.22 0 2.37 0.43 4.57 0.97 4.9 1.18 0.74 1.19 0.24 0.03-14.75-1.17-15.14-1.22-28.2-0.22-39.34l0.78-8.88zm-125.12 0.5c1.13 0 0.52 1.8-3.85 11.66l-3.62 8.22 1.78 4.06c0.97 2.25 2.71 5.44 3.87 7.06 2.41 3.35 3.65 7.38 2.32 7.38-0.49 0-0.88-0.74-0.88-1.66 0-1.72-4.66-7.22-6.12-7.22-0.46 0 0.04 1.24 1.09 2.72 3.31 4.69 3.42 6.71 0.5 9-3.86 3.04-4.67 2.64-3.94-1.93 0.57-3.52 0.29-4.5-2.44-7.94-2.88-3.64-3.07-4.32-2.59-9.66 0.36-4 1.31-6.89 3.13-9.53 2.56-3.71 2.6-3.73 1.93-0.84-0.37 1.62-1.1 3.73-1.59 4.68-0.55 1.07-0.49 2.39 0.12 3.44 0.9 1.53 0.98 1.51 1-0.4 0.02-1.18 0.73-3.38 1.54-4.91s2.15-4.36 3-6.25c2.59-5.82 3.85-7.88 4.75-7.88zm41.9 0c-0.54 0-0.97 0.46-0.97 1 0 0.55 0.43 0.97 0.97 0.97s1-0.42 1-0.97c0-0.54-0.46-1-1-1zm25.69 0c0.49 0 0.88 0.89 0.88 1.97 0 1.09-0.17 1.97-0.38 1.97s-0.59-0.88-0.88-1.97c-0.28-1.08-0.11-1.97 0.38-1.97zm247.38 2.13c0.28-0.07 0.69 0.42 1 1.22 0.35 0.91 0.42 1.88 0.15 2.15-0.27 0.28-0.8-0.24-1.15-1.15-0.36-0.91-0.37-1.89-0.1-2.16 0.04-0.03 0.05-0.05 0.1-0.06zm-130.82 0.19c-0.32 0.12-0.59 1.8-0.59 4.09 0 2.62 0.18 4.54 0.41 4.31 0.76-0.78 1.01-7.67 0.31-8.37-0.05-0.05-0.08-0.05-0.13-0.03zm-164.94 0.9c-0.34 0.01-0.68 0.09-1 0.28-0.75 0.47-0.68 0.95 0.26 1.54 1.75 1.11 2.78 1.08 2.78-0.07 0-1.02-1-1.76-2.04-1.75zm293.1 1.22 0.06 2.82c0.04 1.61-0.68 3.41-1.66 4.15-2.29 1.74-4.18 1.72-4.18-0.06 0-0.8 0.57-1.21 1.28-0.94 0.75 0.29 1.97-0.86 2.9-2.75l1.6-3.22zm-356 0.1c1.016 0.04 1.64 0.71 2.5 2.37 1.871 3.61 1.851 6.75-0.031 7.47-0.812 0.31-1.469 1.13-1.469 1.75s-1.03 2.21-2.281 3.56c-1.252 1.35-2.743 3.33-3.344 4.41-0.965 1.72-1.125 1.49-1.406-1.97-0.247-3.03-0.699-3.87-1.969-3.66-0.906 0.15-1.938-0.16-2.281-0.71-0.344-0.56-1.91-1.04-3.469-1.04s-3.061-0.35-3.344-0.81c-1.13-1.83 10.041-9.71 15.906-11.22 0.44-0.11 0.849-0.17 1.188-0.15zm19.311 0.31c0.37 0.01 0.43 0.69-0.06 2.28-0.38 1.22-0.93 3.22-1.22 4.44-0.29 1.21-0.9 2.22-1.37 2.22-0.48 0-0.91 0.65-0.91 1.47 0 0.81-0.43 1.46-0.97 1.46-1.46 0-1.22-1.55 1.09-6.93 1.31-3.03 2.82-4.95 3.44-4.94zm181.38 0.06c1.46 0 1.18 3.55-0.38 4.85-0.75 0.61-1.6 2.33-1.91 3.81-0.53 2.59-3.53 7.44-3.59 5.81-0.02-0.44 1.09-3.23 2.44-6.19 1.35-2.95 2.47-6.01 2.47-6.81s0.43-1.47 0.97-1.47zm-35.19 0.5 0.87 3.85c0.91 3.86 0.81 5.08-0.4 3.87-0.36-0.36-0.65-2.25-0.6-4.19l0.13-3.53zm-71.91 0.09c0.07-0.01 0.15-0.01 0.19 0.04 0.34 0.34-0.66 2.48-2.22 4.75-3.2 4.65-5.97 7.27-5.97 5.65 0-0.58 0.67-1.41 1.44-1.84s2.44-2.7 3.75-5c1.14-2.01 2.31-3.48 2.81-3.6zm238.66 0.41c2.74 0.01 3.32 0.26 2.22 0.97-1.94 1.25-5.91 1.25-5.91 0 0-0.54 1.66-0.98 3.69-0.97zm-80 1.35c0.35 0 0.59 0.36 0.59 0.96 0 0.8 0.54 1.63 1.19 1.85 0.92 0.3 0.92 0.55 0 1.12-0.65 0.4-1.19 0.23-1.19-0.37 0-0.61-0.46-0.81-1-0.47-0.54 0.33-0.97-0.06-0.97-0.88 0-0.81 0.43-1.76 0.97-2.09 0.14-0.08 0.29-0.13 0.41-0.12zm92.47 0.12c0.02-0.01 0.04-0.01 0.06 0 0.11 0.05 0.24 0.34 0.34 0.84 0.22 1.01-0.07 2.26-0.59 2.78-0.62 0.62-0.74-0.04-0.37-1.84 0.22-1.12 0.4-1.7 0.56-1.78zm-233.1 0.34c0.35-0.05 0.73 0.47 1.16 1.6 0.8 2.09-2.56 25.12-4.16 28.47-0.75 1.57-1.37 3.46-1.37 4.18 0 0.73-0.46 1.32-1 1.32-1.25 0-1.26-2.43-0.03-4.66 2-3.65 4.17-15.81 4.12-23.09-0.03-4.85 0.52-7.7 1.28-7.82zm70.75 0.25c-0.22-0.08-0.14 0.28 0.19 1.16 0.37 0.97 0.92 1.55 1.22 1.25s0.02-1.11-0.66-1.78c-0.36-0.36-0.61-0.58-0.75-0.63zm-125.5 0.16c-0.32 0-0.61 0.01-0.87 0.03-5.95 0.56-5.74 1.69 0.31 1.69 3.55 0 5.86 0.48 6.63 1.41 0.8 0.96 3.08 1.4 7.09 1.34 3.35-0.05 5.49-0.45 5-0.94-1.31-1.31-13.27-3.57-18.16-3.53zm217.29 0.72c-0.71 0.01-0.58 0.43 0.31 1 1.89 1.22 2.22 1.22 1.47 0-0.34-0.54-1.14-1.01-1.78-1zm-93.94 0.12c-0.17 0.04-0.19 0.55-0.19 1.63 0 1.21 0.44 2.97 0.94 3.9 0.5 0.94 1.14 2.53 1.43 3.47 0.3 0.95 0.79 1.72 1.1 1.72 0.95 0-0.67-7.24-2.1-9.31-0.65-0.95-1.01-1.44-1.18-1.41zm179.62 0.03c0.18 0.01 0.39 0.01 0.6 0.04 1.79 0.25 2.11 1.05 2.37 5.65 0.17 2.95 0.06 6.38-0.25 7.63-0.31 1.24-1.07 2.28-1.66 2.28-0.58 0-0.76-0.7-0.43-1.56 1.46-3.8 1.72-6.32 0.69-6.32-0.6 0-1.09 1.23-1.1 2.72-0.01 2.02-0.26 2.35-0.94 1.28-0.54-0.86-0.52-2.08 0.04-3.12 0.5-0.94 0.87-3.21 0.81-5-0.07-2.07-0.33-2.53-0.63-1.28-0.8 3.32-1.91 3.69-1.44 0.47 0.32-2.13 0.72-2.81 1.94-2.79zm-26.34 0.97c0.44 0 0.88 0.09 1.22 0.22 0.67 0.28 0.13 0.47-1.22 0.47s-1.93-0.19-1.25-0.47c0.34-0.13 0.8-0.22 1.25-0.22zm-93 0.1c0.22-0.23 0.88 1.52 1.5 3.87 3.2 12.2 14.82 29.35 19.84 29.35 0.96 0 3.35 1.11 5.35 2.47l3.62 2.46h-4.44c-2.75 0-4.93-0.58-5.68-1.5-1.57-1.89-4.91-1.91-4.91-0.03 0 2.54 3.18 3.28 14.97 3.44 10.28 0.14 12.23-0.14 18.19-2.44 9.18-3.54 16.95-7.33 20.62-10.06 1.7-1.26 4.04-2.46 5.22-2.69s3.11-0.71 4.28-1.06c1.63-0.48 1.32 0.1-1.31 2.41-1.89 1.65-3.99 2.8-4.69 2.56s-1.55 0.34-1.9 1.28c-0.73 1.9-4.2 5.04-5.6 5.09-0.5 0.02-1.61 0.65-2.47 1.41-2.16 1.91-13.45 7.73-18.78 9.69-2.43 0.89-7.07 2.08-10.28 2.65-7.82 1.4-9.13 1.39-7.63-0.12 2.07-2.06 1.33-2.47-5.71-3.13-5.22-0.48-7.8-1.3-10.75-3.34-2.15-1.48-3.95-3.08-3.97-3.56s-1.08-1.83-2.35-3c-2.51-2.33-4.44-11.38-2.43-11.38 0.59 0 0.84-0.88 0.56-1.97-0.28-1.08-0.15-1.97 0.34-1.97 0.49 0.01 0.91 0.69 0.91 1.54 0 0.84 1.11 3.95 2.47 6.9 1.35 2.96 2.43 5.75 2.43 6.19 0 1 3.47 5.03 4.32 5.03 1.33 0 0.51-2.3-1.82-5.06-1.33-1.59-2.92-4.73-3.53-7-0.6-2.28-1.5-4.65-2-5.25-0.49-0.6-1.32-4.38-1.84-8.38-0.52-3.99-1.39-8.76-1.94-10.62s-0.82-3.56-0.59-3.78zm-153.16 0.31c0.05 0 0.1 0 0.13 0.03 0.26 0.26-0.31 1.22-1.28 2.16-1.7 1.62-1.75 1.6-0.5-0.47 0.62-1.04 1.32-1.73 1.65-1.72zm253.75 0.56c0.36-0.11 0.35 0.31 0.16 1.32-0.2 1.02-0.92 2.02-1.59 2.24-1.76 0.59-1.54-1.22 0.34-2.78 0.51-0.42 0.88-0.71 1.09-0.78zm-282.69 1c-0.83 0.08-1.69 0.94-1.81 2.56-0.11 1.55 0.4 2.22 1.66 2.22 1.28 0 1.78-0.7 1.78-2.5 0-1.61-0.79-2.35-1.63-2.28zm-28.71 0.85c0.4 0 0.24 1.46-0.35 3.21-1.6 4.81-2.66 5.41-1.44 0.82 0.59-2.21 1.39-4.03 1.79-4.03zm249.78 1.09c-0.76 0.01-0.93 0.26-0.63 0.75 0.38 0.61 2.09 1.16 3.82 1.22 1.72 0.05 4.24 0.44 5.59 0.87 3.37 1.08 9.84 1.19 9.84 0.16 0-0.46-3-1.14-6.65-1.5-3.66-0.36-8.14-0.92-9.97-1.25-0.89-0.16-1.55-0.26-2-0.25zm-187.72 0.03c0.48 0 0.17 0.79-0.85 2.19-1.02 1.41-2.24 2.54-2.71 2.56-1.22 0.05 1.76-4.17 3.31-4.69 0.1-0.03 0.18-0.06 0.25-0.06zm177.91 0.13c0.03-0.06 0.56 0.17 1.62 0.68 1.22 0.59 2.22 1.28 2.22 1.54 0 0.75-0.53 0.54-2.53-1.07-0.92-0.73-1.35-1.09-1.31-1.15zm-206.19 0.4c-1.63 0.03-1.88 0.6-0.81 1.66 0.9 0.91 3.51 0.77 5.12-0.25 0.93-0.59 0.25-0.99-2.22-1.28-0.85-0.1-1.55-0.14-2.09-0.13zm-59.5 1.32c1.84 0 4.95 3.68 5.5 6.5 0.48 2.52 0.06 3.59-2.41 6.12-1.65 1.69-3.3 4.66-3.66 6.56-0.35 1.9-1.014 3.44-1.495 3.44s-0.906 1.31-0.906 2.94c0 2.26-0.441 2.97-1.907 2.97-2.482 0-3.336-1.5-3.968-6.91-0.487-4.17-0.687-4.41-3.594-4.5-6.712-0.21-8.173-2.99-3.781-7.16 3.048-2.89 3.216-1.59 0.219 1.66l-2.219 2.38 2.469-0.72c1.352-0.41 3.003-1.17 3.656-1.69 0.652-0.52 1.573-0.72 2.031-0.44 1.313 0.81 7.917-5.8 8.625-8.62 0.35-1.4 1.02-2.53 1.44-2.53zm181.97 0c-0.54 0-0.97 0.42-0.97 0.96s0.43 1 0.97 1 1-0.46 1-1-0.46-0.96-1-0.96zm168.37 0c0.5 0 0.43 0.88-0.15 1.96-0.58 1.09-1.21 1.97-1.41 1.97s-0.13-0.88 0.15-1.97c0.29-1.08 0.91-1.96 1.41-1.96zm-92.69 0.43c1.81 0 3.56 0.65 4.94 2.03 1.28 1.29 1.24 1.48-0.47 1.57-1.06 0.05-0.24 0.48 1.81 0.97 2.06 0.48 6.27 2.07 9.35 3.53l5.59 2.65-5.65 1.69c-4.13 1.22-6.65 1.41-9.35 0.78-4.8-1.11-5.42-1.09-4.68 0.09 0.33 0.55 1.92 1 3.53 1 2.57 0.01 2.86 0.3 2.47 2.47-0.4 2.16-0.11 2.44 2.37 2.44 3.25 0 4.84-1.57 2.25-2.25-1.08-0.28-0.75-0.49 0.94-0.56 1.58-0.07 2.72-0.68 2.72-1.47s1.51-1.58 3.68-1.94c5.67-0.93 20.87-0.72 25.82 0.38 6.79 1.51 7.4 1.82 6.12 3.09-0.82 0.82-1.47 0.83-2.47 0-1.82-1.51-14.68-3.28-19.19-2.62-2 0.29-5.16 0.7-7.03 0.87-4.56 0.43-4.94 2.21-0.56 2.72 2.82 0.33 3.42 0.12 2.97-1.06-0.41-1.07-0.02-0.95 1.44 0.37 1.95 1.77 2 1.76 2.03-0.06 0.03-1.83 0.06-1.83 1.47 0.03 0.79 1.05 1.44 1.33 1.44 0.66 0-0.68 0.52-0.91 1.12-0.53 0.6 0.37 1.47 0.05 1.94-0.69 0.72-1.15 0.86-1.14 0.87 0 0.01 1.04 0.32 1.1 1.38 0.22s1.75-0.78 2.97 0.43c0.87 0.87 1.56 1.08 1.56 0.5 0-0.57 0.66-1.03 1.47-1.03s1.47 0.47 1.47 1.07 0.73 0.83 1.59 0.5 1.97-0.33 2.5 0c1.84 1.13-11.36 7.02-16.19 7.22-1.08 0.04-1.52 0.52-1.09 1.21 0.5 0.82-0.43 0.97-3.41 0.57-3.66-0.49-4-0.39-2.87 0.96 1.11 1.34 0.95 1.43-1.19 0.76-1.35-0.43-3.13-0.99-3.94-1.29-1.26-0.46-1.25-0.33-0.09 1.1 2.61 3.21-4.73 1.96-10.66-1.81-2.95-1.88-5.95-3.41-6.69-3.41-0.73 0-1.04-0.45-0.68-1.03s-0.29-1.96-1.44-3.03-3.44-4.77-5.12-8.22l-3.1-6.28 2.84-2.53c1.55-1.39 3.42-2.06 5.22-2.07zm-240.25 0.22c1.91 0.01 3.25 2.54 3.25 7.09 0 2.56-0.53 5.2-1.18 5.85-1.77 1.76-3.45 1.41-5.16-1.03-1.59-2.28-2.03-7.42-0.78-9.13 1.39-1.89 2.73-2.79 3.87-2.78zm50.66 1.69c-0.07 0.02-0.12 0.05-0.19 0.09-0.54 0.34-1 1.06-1 1.57 0 0.5 0.46 0.9 1 0.9s0.97-0.69 0.97-1.53c0-0.63-0.24-1.02-0.59-1.03-0.06 0-0.12-0.02-0.19 0zm12.87 0.06c0.29-0.12 0.23 0.59-0.03 2.34-0.25 1.71-0.86 3.13-1.34 3.13-1.3 0-1.07-2.34 0.44-4.41 0.45-0.61 0.77-0.99 0.93-1.06zm193.6 0.66c0.34-0.02 0.71 0.04 1.06 0.18 0.79 0.32 0.58 0.55-0.56 0.6-1.04 0.04-1.64-0.17-1.31-0.5 0.16-0.16 0.47-0.27 0.81-0.28zm18.59 1.97c0.63 0 1.25 0.06 1.72 0.18 0.95 0.25 0.18 0.47-1.72 0.47-1.89 0-2.66-0.22-1.72-0.47 0.48-0.12 1.1-0.18 1.72-0.18zm-289.65 0.21c-1.45 0.11-8.41 5.58-8.41 6.76 0 1.09 5.52-2.06 7.63-4.38 0.86-0.95 1.32-1.99 1-2.31-0.05-0.05-0.13-0.07-0.22-0.07zm342.46 0.94c2.02-0.1 4.19 0.61 6.72 2.1 3.23 1.88 4.41 3.24 4.41 4.87 0 3.19-1 3.83-3.09 1.94-2.6-2.35-3.46-0.79-1.44 2.62 1.46 2.48 1.48 2.81 0.19 2.32-0.84-0.33-1.57-0.06-1.57 0.56 0 0.61 0.71 1.37 1.54 1.69 1.1 0.42 1.21 0.9 0.43 1.84-0.75 0.91-0.77 1.46 0 1.94 0.72 0.44 0.78 1.06 0.13 1.84-0.61 0.73-0.63 1.73-0.06 2.63 0.5 0.79 0.9 2.75 0.9 4.37 0 2.71-0.2 2.53-2.56-2.22-1.42-2.84-2.96-5.15-3.44-5.15s-0.35 1 0.28 2.21c2.45 4.73 2.78 5.71 2.78 7.57 0 1.05 0.46 2.19 1 2.53 1.24 0.76 1.32 4.4 0.1 4.4-0.5 0.01-1.5 0.19-2.22 0.41-1.61 0.5-5.58-0.66-8.47-2.47-1.75-1.09-2.77-1.11-5.31-0.15-1.74 0.65-3.29 1.05-3.47 0.87-0.57-0.57 5.01-5.76 7.06-6.56 1.9-0.74 1.93-0.78 0.13-1.5-1.27-0.51-2.26-0.2-3.07 0.9-2.9 3.98-4.43 0.26-4.43-10.84 0-7.14 0.66-8.81 5.75-14.22 2.74-2.91 5.13-4.37 7.71-4.5zm-306.18 0.03c-0.12 0.03-0.27 0.08-0.41 0.16-0.54 0.33-1 1.08-1 1.63 0 0.54 0.46 0.67 1 0.34 0.54-0.34 0.97-1.05 0.97-1.6 0-0.4-0.21-0.59-0.56-0.53zm158.75 0.66c0.43 0 0.77 1.18 0.75 2.63-0.03 1.44-0.68 2.83-1.44 3.09-0.97 0.32-1.21-0.03-0.75-1.22 0.36-0.93 0.66-2.36 0.66-3.13 0-0.76 0.35-1.37 0.78-1.37zm113.75 0.13c0.44 0 0.56 0.29 0.56 0.74 0 0.47-1.9 1.56-4.22 2.44-6.29 2.4-7.83 1.79-2.19-0.87 3.44-1.62 5.1-2.32 5.85-2.31zm-131.32 0.87c-0.57 0-0.77 0.43-0.43 0.97 0.33 0.54 0.79 1 1.03 1s0.44-0.46 0.44-1-0.46-0.97-1.04-0.97zm77.47 0c-3.22-0.03-0.78 1.66 3.5 2.44 2.32 0.42 4.5 0.73 4.91 0.65s0.75 0.28 0.75 0.82 0.25 1 0.56 1c0.32 0 0.42-0.47 0.22-1.07-0.4-1.2-7.14-3.82-9.94-3.84zm43.85 0.13c0.52 0 0.72 0.26 0.72 0.84 0 0.54-1.23 0.97-2.72 0.94-2.4-0.07-2.46-0.19-0.72-0.94 1.34-0.58 2.19-0.84 2.72-0.84zm-11.1 0.96c0.45 0 0.92 0.09 1.25 0.22 0.68 0.28 0.11 0.5-1.25 0.5-1.35 0-1.89-0.22-1.22-0.5 0.34-0.13 0.78-0.22 1.22-0.22zm-117.65 0.07c0.06-0.03 0.13 0.01 0.22 0.09 0.32 0.33 0.34 1.16 0.06 1.88-0.32 0.78-0.52 0.55-0.56-0.6-0.04-0.78 0.08-1.3 0.28-1.37zm141.93 0.15c0.28 0 0.54 0.18 0.76 0.53 0.34 0.57-0.7 1.7-2.32 2.53-3.63 1.89-4.03 1.88-4.03 0.04 0-0.82 0.81-1.47 1.78-1.47 0.98 0 2.26-0.48 2.85-1.07 0.36-0.36 0.69-0.55 0.96-0.56zm-227.34 1.28c0.79 0.02 0.93 2.74 0.63 11-0.23 6.3-0.78 11.93-1.19 12.47-0.42 0.54-1.05 2.37-1.41 4.07-0.36 1.69-1.76 4.12-3.15 5.4-4.08 3.77-7.23 9.39-7.88 14.13-0.65 4.76 0.29 5.62 3.13 2.78 1.38-1.39 2.28-1.48 5.59-0.6 3.21 0.86 4.47 0.73 6.72-0.56 2.86-1.64 5.84-6.71 5.84-9.91 0-2.42 1-2.61 11.1-2.21l8.59 0.34v5.87 5.85l-3.69-0.66c-2.03-0.37-3.91-1.01-4.18-1.4-0.28-0.39-1.52-1.05-2.79-1.44-1.7-0.53-2.79-0.13-4.25 1.44-1.08 1.16-4.35 3.14-7.28 4.43-2.93 1.3-5.34 2.74-5.34 3.22s-1.12 1.47-2.47 2.19-2.47 1.72-2.47 2.19-0.87 1.79-1.94 2.94c-1.06 1.14-2.28 3.88-2.72 6.09-0.61 3.15-1.3 4.09-3.06 4.34-1.23 0.18-2.45 0.95-2.75 1.72-0.68 1.78-1.75 1.7-7.09-0.47-5.02-2.03-7.22-4.5-6.81-7.81 0.22-1.85 1.29-2.68 4.97-3.84 2.56-0.82 4.65-2.07 4.65-2.75 0-0.69 0.5-1.41 1.06-1.6 0.67-0.22 0.49-1.61-0.5-3.97-0.9-2.16-1.32-5.01-1-7.03 0.61-3.84-0.52-5.02-3.97-4.15-1.74 0.43-2.45 1.5-2.93 4.28-0.36 2.03-1.65 4.94-2.91 6.5-2.14 2.65-2.39 2.73-3.28 1-0.66-1.28-0.47-3.45 0.59-6.97 1.72-5.71 4.78-8.04 13.19-10.16 2.57-0.64 4.66-1.58 4.66-2.06s0.69-0.88 1.5-0.88c0.81 0.01 1.47-0.36 1.47-0.84s0.94-1.14 2.06-1.44c1.12-0.29 2.24-1.44 2.53-2.56s1.02-2.03 1.56-2.03 0.72-0.89 0.44-1.97-0.13-1.74 0.31-1.47c1.56 0.97 2.87-5.97 2.47-13.09-0.43-7.66-0.08-9.6 1.84-10.34 0.06-0.03 0.11-0.04 0.16-0.04zm255.63 0.41c-0.48 0.04-1.31 0.38-2.82 1.06-1.37 0.63-2.53 1.48-2.53 1.91 0 0.42 1.35 0.35 2.97-0.22s2.94-1.42 2.94-1.91c0-0.57-0.09-0.88-0.56-0.84zm-126.57 0.56c0.51-0.31 1.23 4.42 1.6 10.88 0.63 11.05 0.38 14.18-0.75 10.43-1.05-3.46-1.74-20.76-0.85-21.31zm138 0.35c-0.2-0.02-0.4 0.06-0.62 0.28-0.33 0.32-0.27 1.12 0.16 1.81 0.61 1 0.85 1 1.18 0 0.36-1.07-0.1-2.03-0.72-2.09zm-36.34 0.5c0.53-0.06 0.88 0.13 0.88 0.53 0 0.52-0.66 0.93-1.47 0.93-0.82 0-1.47-0.16-1.47-0.37s0.65-0.66 1.47-0.97c0.2-0.08 0.41-0.1 0.59-0.12zm-240.31 0.5c0.12 0 0.15 0.31 0.12 0.96-0.03 0.82-0.47 2.39-0.93 3.47-0.85 1.97-0.83 1.97-0.88 0-0.03-1.08 0.35-2.65 0.88-3.47 0.42-0.65 0.68-0.96 0.81-0.96zm-29.07 1.37c-0.15 0.01-0.37 0.08-0.65 0.19-0.78 0.3-1.64 1.17-1.94 1.94-0.82 2.13 1.16 1.68 2.35-0.54 0.62-1.17 0.71-1.62 0.24-1.59zm145.91 0.06c0.03-0.01 0.06 0 0.09 0 0.18 0.03 0.45 0.24 0.88 0.6 0.77 0.64 1.41 1.55 1.41 2.03 0 1.71-1.74 0.79-2.25-1.19-0.24-0.91-0.31-1.36-0.13-1.44zm-170.97 0.19 2.66 2.88c2.26 2.43 2.55 3.41 2.03 6.65-0.57 3.57-2.58 6.19-6.66 8.57-1.35 0.78-1.58 0.67-1.12-0.54 0.49-1.28 0.11-1.25-2.47 0.22-2.01 1.14-2.59 1.86-1.62 2.06 0.8 0.18 1.5 0.63 1.5 1 0 1.26-3.85 3.1-5.32 2.54-0.8-0.31-2.27-0.14-3.25 0.43-1.59 0.93-1.51 1.07 0.66 1.1 2.3 0.03 2.34 0.12 0.72 1.75-0.94 0.94-2.48 1.71-3.41 1.72-0.93 0-1.72 0.68-1.72 1.53 0 1.96-3.11 5.18-4.31 4.43-0.5-0.3-2.17-0.07-3.688 0.5-1.688 0.65-2.31 1.3-1.624 1.72 0.806 0.5 0.616 2.11-0.688 5.82-2.386 6.77-6.636 12.56-10.625 14.46-1.777 0.86-3.366 1.54-3.531 1.54-0.66 0 0.625-21.17 1.312-21.63 0.406-0.27 1.029-1.61 1.375-2.97 0.551-2.15 17.349-20.65 18.749-20.65 0.29 0 2.81-2.15 5.56-4.79 3.26-3.1 6.83-5.4 10.22-6.56l5.25-1.78zm-15.53 0.44c0.53-0.03 1 0.5 1.41 1.56 0.42 1.1-0.38 2.55-2.38 4.38-3.36 3.07-3.98 1.7-1.47-3.16 0.96-1.84 1.76-2.75 2.44-2.78zm44.63 0.22c-0.48 0-1.19 0.37-1.85 1.03-1.73 1.73-0.88 2.12 1.44 0.65 0.8-0.5 1.18-1.19 0.81-1.56-0.09-0.09-0.24-0.12-0.4-0.12zm-48.91 0.09c0.21-0.04 0.34 0.03 0.34 0.22 0 0.5-0.88 1.67-1.97 2.59-1.08 0.93-1.96 1.33-1.96 0.88s0.88-1.65 1.96-2.63c0.68-0.61 1.28-0.98 1.63-1.06zm69.84 0.97c0.25 0.05 0.34 0.76 0.35 2.25 0.01 1.73-0.46 3.42-1 3.75-1.26 0.78-1.26-3.46 0-5.41 0.27-0.42 0.51-0.62 0.65-0.59zm5.63 0.44c0.29 0.11 0.14 3.1-0.56 7.09-0.62 3.49-1.49 6.74-1.94 7.25-1.12 1.28-1.05-2.04 0.12-5.78 0.53-1.66 1.25-4.26 1.57-5.81 0.35-1.75 0.58-2.59 0.75-2.72 0.02-0.02 0.04-0.04 0.06-0.03zm241.4 0.28c0.19 0.03 0.22 0.39 0.22 1.12 0 0.93-0.33 1.69-0.75 1.69-0.69 0-5.54 6.71-9.12 12.63-0.84 1.37-2.12 2.68-2.88 2.93-1.24 0.42 8.2-14.07 11.41-17.5 0.59-0.63 0.94-0.91 1.12-0.87zm-70.96 0.69c0.18-0.02 0.76 0.46 1.75 1.56 1.41 1.57 2.53 3 2.53 3.19 0 0.73-0.72 0.26-2.13-1.38-1.67-1.95-2.45-3.34-2.15-3.37zm-48.6 1.15c0.95 0 1.87 1.91 2.69 5.6 1.22 5.43 1.3 5.51 2.59 3.18 1.47-2.64 1.7-1.74 0.78 2.85-0.33 1.65-1.24 3.26-2.03 3.56-1.01 0.39-1.25 0.03-0.87-1.19 0.61-1.93-1.77-10.64-3.47-12.68-0.85-1.03-0.79-1.32 0.31-1.32zm156.56 0.19c0.07-0.02 0.14 0.01 0.22 0.09 0.33 0.33 0.35 1.17 0.07 1.88-0.32 0.78-0.52 0.55-0.57-0.6-0.03-0.77 0.08-1.3 0.28-1.37zm-120.5 0.78c-1.13 0-1.1 0.71 0.19 3.13 0.59 1.09 1.27 1.8 1.47 1.59 0.67-0.67-0.76-4.72-1.66-4.72zm-183.09 0.09c3.29 0.09 3.41 0.21 1.22 0.91-3.52 1.13-4.94 1.13-4.94 0 0-0.54 1.69-0.96 3.72-0.91zm270.72 0.79c0.35 0-0.47 1.24-2.63 4.15-2.16 2.93-4.67 6.63-5.59 8.25-2.18 3.85-6.08 9.28-8.75 12.13-1.67 1.78-1.84 2.42-0.81 3.06 0.91 0.57 0.98 1 0.22 1.47-0.6 0.37-1.1 0.17-1.1-0.47 0-0.82-0.48-0.77-1.68 0.19-1.6 1.26-1.61 1.18-0.16-1.13 5.33-8.49 5.3-8.46 9.03-13.28 1.26-1.62 3.49-4.94 5-7.37 1.51-2.44 3.91-5.28 5.28-6.32 0.63-0.46 1.03-0.69 1.19-0.68zm-99.31 0.12c-1.39 0-1.25 5.96 0.22 9.13 0.67 1.45 1.57 2.68 2 2.68 0.42 0.01 0.34-0.86-0.22-1.9-0.56-1.05-1.03-3.71-1.03-5.91s-0.43-4-0.97-4zm102.72 1.97c1.3 0 0.4 2.64-1.69 4.91-3.25 3.52-13.92 20.85-16.06 26.06-1.01 2.43-2.22 4.43-2.66 4.44-1.01 0 0.15-3.8 1.94-6.38 0.74-1.07 1.31-2.7 1.31-3.62 0-0.93 0.63-2.26 1.38-3 0.74-0.74 1.59-2.23 1.93-3.32 0.35-1.08 2.63-5.04 5.07-8.75 2.43-3.7 4.4-7.09 4.4-7.53 0-0.76 3.2-2.81 4.38-2.81zm30.43 0.41c0.15-0.04 0.36 0.14 0.63 0.56 0.52 0.81 0.96 2.27 0.97 3.22 0.01 0.94-0.43 1.72-0.97 1.72s-0.98-1.46-0.97-3.22c0.01-1.52 0.1-2.22 0.34-2.28zm-159.75 0.56c0.53 0 0.72 0.66 0.41 1.47s-0.76 1.5-0.97 1.5-0.4-0.69-0.4-1.5c-0.01-0.81 0.44-1.47 0.96-1.47zm141.35 1c-1.69 0-6.57 3.72-6.57 5.03 0.01 0.54 1.78 0 3.94-1.22 3.98-2.23 5.09-3.81 2.63-3.81zm9.19 0c-0.55 0-1 0.46-1 1.03-0.01 0.57 0.45 0.77 1 0.44 0.54-0.34 0.96-0.83 0.96-1.06 0-0.24-0.42-0.41-0.96-0.41zm-177.16 0.97c0.41 0 1.25 1.89 1.84 4.18 0.6 2.3 1.93 6.85 3 10.1 1.08 3.24 2.73 8.53 3.66 11.78 3.13 10.91 12.31 29.52 22.4 45.47 2.92 4.61 13.88 16.19 16.82 17.75 1.82 0.97 1.81 1.03-0.22 2.12-1.76 0.94-2.04 0.88-1.56-0.37 0.31-0.83 0.16-1.5-0.38-1.5-0.53 0-3.11-2.01-5.75-4.44-2.63-2.43-5.11-4.43-5.53-4.44-1.41-0.02 2.19 4.44 5.62 6.91 3.84 2.77 4.43 3.98 1.54 3.22-2.67-0.7-10.68-9.57-17.16-19-4.51-6.57-4.53-6.53-4.53-4.69 0 0.82 1.15 2.74 2.53 4.31 1.38 1.58 3.13 4.29 3.88 6.04 0.74 1.74 4.66 6.52 8.71 10.59 6.04 6.05 7.03 7.41 5.25 7.41-5.77 0-24.32-16.82-34.31-31.1-1.85-2.65-4.69-7.16-6.28-10s-3.25-5.15-3.69-5.16c-0.44 0-0.6 0.35-0.37 0.76 4.48 8.09 9.79 16.67 13.15 21.24 2.34 3.18 4.25 6.11 4.25 6.54 0 1.18 5.01 6.19 8.85 8.84 1.89 1.31 3.66 2.66 3.94 3 0.27 0.34 2.5 1.78 4.93 3.22 2.44 1.44 3.88 2.65 3.19 2.66-0.69 0-2.89-1.03-4.91-2.29-6.28-3.91-8.06-4.2-4.75-0.75 1.59 1.66 3.63 3.04 4.5 3.04 0.88 0 2.45 0.64 3.5 1.43 1.05 0.8 2.8 1.43 3.88 1.44 1.59 0.01 1.67-0.13 0.5-0.87-2.34-1.49-0.75-1.79 1.94-0.38 1.35 0.71 1.89 1.3 1.18 1.31-0.7 0.01-1.02 0.43-0.68 0.97 0.33 0.54 0.07 1-0.57 1-0.86 0-0.85 0.37 0.07 1.47 1.43 1.73 1.28 1.71-1.97-0.09-1.36-0.75-3.21-1.37-4.16-1.38s-1.72-0.46-1.72-1-0.52-0.97-1.12-0.97c-2.05 0-12.11-6.71-18.72-12.47-6.26-5.45-16.43-16.75-21.31-23.72-1.44-2.04-2.17-4.31-1.97-6.15 0.29-2.83 0.44-2.73 4.47 3.25 2.28 3.38 5.17 7.24 6.4 8.59 1.24 1.36 3.94 4.56 6 7.13 2.07 2.56 4.2 4.68 4.75 4.68 0.96 0-1.73-3.85-6.03-8.59-1.09-1.2-2-2.46-2-2.81s-2.2-3.43-4.9-6.88c-2.71-3.44-4.94-6.54-4.94-6.87 0-0.34-0.82-1.78-1.82-3.22-1.95-2.81-3.3-7.05-2.24-7.03 0.35 0 1.51 1.83 2.56 4.03 1.75 3.66 6.44 10.68 6.44 9.66-0.01-0.24-1.53-3.53-3.41-7.32-1.89-3.78-3.43-7.19-3.44-7.56-0.02-0.99 3.89-2.08 7.81-2.19 3.3-0.08 3.58 0.2 7.63 7.78 2.31 4.33 4.53 8.54 4.94 9.35 2.7 5.41 12.61 20.86 15.47 24.12 1.89 2.17 3.45 4.25 3.46 4.66 0.03 0.97 1.97 0.97 1.97 0 0-0.41-0.99-1.84-2.22-3.19-2.08-2.3-4.84-6.07-7.12-9.72-0.55-0.87-1.87-2.87-2.91-4.4-3.26-4.85-5.4-8.78-8.97-16.38-1.9-4.06-4.29-9.15-5.31-11.31-1.01-2.16-2.11-5.71-2.44-7.87l-0.59-3.94 2.44 4.94c1.35 2.7 2.48 5.67 2.5 6.62 0.03 1.63 2 2.59 2 0.97 0-0.42-1.58-4.52-3.5-9.06-1.92-4.55-3.31-9.17-3.1-10.29 0.31-1.6 0.56-1.36 1.16 1.16 0.42 1.76 1.15 3.22 1.63 3.22 1.1 0 1.1-1.51 0-3.69-1.53-3-2.93-6.6-3.44-8.93-0.41-1.88-0.22-2.06 0.94-1.1 1.78 1.48 1.74 1.28-0.54-6.94-1.04-3.78-1.54-6.9-1.12-6.9zm-60.28 3.94c3.13 0 2.95 0.68-1.06 4.59-3.29 3.19-7.44 4.4-7.44 2.19 0-1.94 6.08-6.78 8.5-6.78zm196.22 0c0.9 0-2.94 6.6-5.91 10.15-1.21 1.45-1.24 1.91-0.19 2.56 0.91 0.57 0.98 1.03 0.22 1.5-0.6 0.37-1.14 0.09-1.16-0.62-0.05-2.44-4.87 4.23-4.87 6.75 0 2 0.27 2.3 1.31 1.44 2.37-1.97 2.64 0.05 0.41 3.18-1.2 1.69-2.06 3.72-1.91 4.54 0.25 1.29 0.17 1.3-0.68 0.03-0.7-1.03-0.53-1.95 0.59-3.19 0.87-0.96 1.31-2.06 0.97-2.41-0.79-0.78-4.45 3.69-4.16 5.07 0.12 0.55 0.01 0.68-0.22 0.28-0.67-1.21-3.22-0.87-3.75 0.5-0.27 0.69-1.48 1.35-2.69 1.43l-2.15 0.13 2.22-1.81c1.22-1.01 2.8-2.01 3.47-2.25s0.95-0.69 0.68-0.97c-0.6-0.64-13.13 5.17-13.59 6.31-0.18 0.45-0.98 0.81-1.75 0.81s-3.27 0.87-5.56 1.94c-2.3 1.07-6.1 2.64-8.47 3.47-4.76 1.66-10.25 2.11-6.53 0.53 1.08-0.46 4.19-1.41 6.87-2.09 3.45-0.89 5.84-2.35 8.28-5 1.9-2.07 4.06-3.75 4.75-3.75 0.7 0 1.25-0.41 1.25-0.88s2.62-2 5.82-3.44c6.84-3.07 16.45-11.2 14.97-12.68-0.65-0.65-2.47-0.27-5.44 1.12-2.46 1.16-4.79 2.09-5.16 2.09-1.47 0.01-8.22 3.39-8.22 4.13 0 0.44-1.94 0.81-4.31 0.81s-5.96 0.69-7.97 1.53c-4.02 1.69-11.46 1.57-12.03-0.18-0.23-0.71 2.07-1.38 6.34-1.82 8.65-0.89 20.44-4.21 25.1-7.09 2.02-1.25 4.16-2.28 4.75-2.28s4.04-2.1 7.65-4.63c3.62-2.52 5.99-3.96 5.32-3.21-2.43 2.66-1.16 3.05 1.81 0.56 1.66-1.4 3.43-2.56 3.94-2.56zm-95.13 0.24c0.17 0 0.4 0.15 0.69 0.44 0.59 0.59 0.9 1.8 0.72 2.72-0.44 2.16-1.82 0.79-1.82-1.81 0.01-0.91 0.13-1.33 0.41-1.35zm-18.59 2c-0.07 0-0.12 0.03-0.16 0.07-0.3 0.3 0.39 1.83 1.53 3.43 1.14 1.61 2.07 3.41 2.07 4-0.01 0.6 0.22 1.07 0.5 1.07 0.27 0 0.5-0.54 0.5-1.22-0.01-1.62-3.47-7.2-4.44-7.35zm134.97 0.54c0.14 0.02 0.28 0.12 0.4 0.31 1.39 2.19 0.98 6.12-1.09 10.19-3 5.88-2.56 9.48 1.66 14.18 2.27 2.54 4.44 4 5.9 4 1.27 0 3.09 0.4 4.03 0.88s3.45 1.71 5.6 2.72c2.15 1 4.78 2.62 5.84 3.56s2.62 1.91 3.47 2.19c0.85 0.27 2.28 2.27 3.19 4.43 0.93 2.23 2.31 3.94 3.18 3.94 0.9 0 1.57 0.84 1.57 1.97 0 2.83-2.41 2.4-5.19-0.91-1.7-2.01-2.81-2.58-3.78-1.96-2.19 1.38-2.69 1.12-5.72-3.07-1.58-2.17-3.03-3.38-3.25-2.71-0.22 0.66-4.94-3.36-10.53-8.88l-10.19-10.03 0.56-6.69c0.57-6.74 2.8-13.8 4.22-14.09 0.05-0.01 0.08-0.04 0.13-0.03zm-215.63 0.68 0.63 6.41c0.34 3.51 0.46 6.52 0.25 6.75s-0.38-0.09-0.38-0.72c0-0.78-2.53-1.16-7.87-1.16-7.26 0.01-7.88-0.15-7.88-2 0-2.27 0.77-2.65 6.69-3.31 3.14-0.35 4.82-1.2 6.4-3.22l2.16-2.75zm-15.9 0.85c0.26 0 0.28 0.37 0.03 1.03-0.66 1.7-1.35 2.04-1.35 0.62 0-0.51 0.44-1.2 0.97-1.53 0.14-0.08 0.26-0.12 0.35-0.12zm54.34 0.22c0.02-0.01 0.06 0.02 0.09 0.06 0.45 0.62 0.98 10.23 1.16 21.37 0.18 11.15 0.06 20.28-0.25 20.28-0.32 0-0.6-4.16-0.6-9.21 0-5.06-0.21-14.67-0.53-21.38-0.29-6.29-0.25-11.07 0.13-11.12zm-79.84 0.37c0.33-0.01 0.56 0.23 0.56 0.88 0 0.47-0.61 1.39-1.38 2.03-1.14 0.95-1.28 0.78-0.84-0.88 0.32-1.23 1.1-2.01 1.66-2.03zm134.15 0.13c1.06-0.23 2.15 2.3 1.56 4.18-0.41 1.32-0.22 1.64 0.66 1.1 0.93-0.57 1.07-0.08 0.56 1.93-0.39 1.58-0.31 2.43 0.22 2.1 0.5-0.31 1.16 0.33 1.44 1.4 0.32 1.23 0.04 1.97-0.78 1.97-0.72 0-1.62-1.32-1.97-2.93s-1.13-2.81-1.75-2.69-1.32-0.79-1.5-2c-0.26-1.67 0.05-2.04 1.22-1.59 0.85 0.32 1.53 0.11 1.53-0.44 0-0.56-0.54-1.2-1.22-1.44s-0.87-0.85-0.44-1.31c0.15-0.16 0.32-0.25 0.47-0.28zm-131.91 0.28c0.16-0.1 0.19 0.33 0.22 1.19 0.05 1.13-0.82 2.86-1.9 3.84-1.12 1.01-1.94 1.27-1.94 0.62 0-0.62 0.41-1.12 0.91-1.12 0.49 0 1.33-1.23 1.87-2.72 0.41-1.13 0.69-1.72 0.84-1.81zm93.29 0.15c0.06 0.01 0.11 0.22 0.18 0.69 0.23 1.5 0.24 3.7 0 4.91-0.23 1.21-0.44 0.02-0.43-2.69 0-1.86 0.12-2.92 0.25-2.91zm-18.63 0.19c0.33-0.13 0.75 1.52 0.91 3.69 0.46 6.42 1.74 37.69 1.9 46.53 0.29 15.53-1.75 9.06-2.71-8.66-0.17-2.97-0.43-0.54-0.57 5.41-0.2 8.8-0.44 10.37-1.31 8.38-0.86-1.99-1.14-2.14-1.47-0.79-0.31 1.31-1.1 1.59-3.53 1.16-11.74-2.06-19.38-11.29-19.38-23.41 0-3.87 0.22-4.27 1.97-3.81 2.82 0.74 4.91-1.42 4.91-5.06 0-3.62 3.02-8.13 9.38-14 3.05-2.82 4.4-4.85 4.4-6.63 0-2.08 0.48-2.56 2.47-2.56 1.35 0 2.71-0.11 3.03-0.25zm212.06 1.69c1.15-0.04 1.99 4.83 1.25 7.78-0.5 1.99-0.28 2.59 0.94 2.59 1.88 0 2.1 1.53 0.35 2.35-0.99 0.46-0.99 0.73 0 1.18 0.67 0.32 1.24 0.91 1.24 1.35s-0.57 1.01-1.28 1.28c-2.3 0.89-4.94-15.06-2.72-16.44 0.08-0.05 0.15-0.09 0.22-0.09zm-55.72 0.94c0.1-0.03 0.21-0.02 0.29 0.06 0.3 0.3-0.02 1.11-0.69 1.78-0.97 0.96-1.07 0.84-0.53-0.56 0.27-0.73 0.64-1.21 0.93-1.28zm16.16 0.03c0.04 0 0.03 0.05 0.03 0.12 0.01 0.58-0.64 1.89-1.43 2.94-1.88 2.47-1.91 3.97-0.07 2.44 1.18-0.98 1.56-0.75 2.07 1.28 0.34 1.36 0.41 3.26 0.15 4.25-0.25 0.99-0.54 0.27-0.62-1.63l-0.13-3.43-1.5 2.72c-1.31 2.41-1.65 2.53-2.94 1.24-1.29-1.28-1.11-1.98 1.5-6.15 1.43-2.27 2.66-3.81 2.94-3.78zm31.78 0.72c0.18-0.07 0.44 0.13 0.85 0.53 0.6 0.6 0.92 1.59 0.71 2.22-0.48 1.46-1.81 0.14-1.81-1.82 0-0.55 0.08-0.87 0.25-0.93zm-284.53 0.81c0.54 0 0.97 0.2 0.97 0.44 0 0.23-0.43 0.69-0.97 1.03-0.54 0.33-1 0.13-1-0.44s0.46-1.03 1-1.03zm189.35 2.81-7.88 4.09c-4.33 2.26-8.3 4.48-8.84 4.91-2.1 1.65-8.18 2.44-15.25 1.97l-7.38-0.5-0.28-4.09-0.31-4.13 5.25-0.56c2.87-0.3 11.82-0.78 19.93-1.1l14.76-0.59zm-254.29 2.09c-0.54 0.01-0.97 0.46-0.97 1 0 0.55 0.43 0.97 0.97 0.97s0.97-0.42 0.97-0.97c0-0.54-0.43-1-0.97-1zm46.57 0.1c0.48-0.01 0.43 0.44-0.35 1.37-0.67 0.82-1.9 1.5-2.75 1.5-1.23 0-1.15-0.31 0.38-1.47 1.25-0.94 2.23-1.39 2.72-1.4zm287.4 0.06c0.98-0.09 2.45 0.2 4.44 0.81 2.42 0.75 2.39 0.8-1.22 2.38-4.1 1.8-7.41 2-9.59 0.62-1.17-0.74-1.23-1.18-0.25-2.15 0.92-0.93 1.22-0.93 1.22-0.03 0 0.65 0.88 1.18 1.96 1.18 1.1 0 1.97-0.68 1.97-1.5 0-0.78 0.49-1.22 1.47-1.31zm15.47 0.91c0.06-0.06 0.5 0.31 1.35 1.12 0.97 0.94 1.54 1.93 1.28 2.19s-1.07-0.49-1.78-1.69c-0.63-1.03-0.91-1.56-0.85-1.62zm-66.69 1c0.08-0.01 0.16-0.01 0.22 0 0.29 0.04 0.35 0.33 0.35 0.81 0 0.49-1.42 1.37-3.13 1.97-4.46 1.55-4.68 1.32-1.03-0.91 1.98-1.2 3.04-1.79 3.59-1.87zm-295 0.9c-0.712 0-1.551 0.69-1.875 1.53-0.325 0.85-0.989 1.31-1.438 1.04-0.783-0.49-4.125 2.7-4.125 3.93 0 0.33 0.632 0.12 1.375-0.5 0.743-0.61 2.021-0.84 2.844-0.53 1.001 0.39 1.993-0.45 3-2.47 1.191-2.38 1.244-3 0.219-3zm52.596 0.1c0.81 0-0.25 0.84-2.38 1.9-2.12 1.06-4.36 1.93-4.94 1.91-1.58-0.06 5.61-3.81 7.32-3.81zm303.87 0.12c0.61-0.06 1.27 0.34 2.47 1.13 1.39 0.91 2.53 2.29 2.53 3.09 0 1.65-1.55 1.95-2.47 0.47-0.33-0.54-2-0.97-3.72-0.97h-3.09l2.13-2.12c1.01-1.02 1.55-1.54 2.15-1.6zm-338.87 0.75c-0.24 0-0.44 0.46-0.44 1s0.49 0.97 1.06 0.97c0.58 0 0.77-0.43 0.44-0.97s-0.82-1-1.06-1zm306.31 0c0.12 0 0.13 0.35 0.09 1-0.04 0.81-0.47 2.59-0.9 3.94l-0.75 2.44-0.1-2.44c-0.04-1.35 0.32-3.13 0.85-3.94 0.42-0.65 0.69-1 0.81-1zm-108 0.78c0.01 0 0.05 0.02 0.06 0.04 1.52 1.8 2.86 9.32 2.28 12.9-0.64 4.03-2.23 5.47-2.53 2.28-0.42-4.57-0.27-15.1 0.19-15.22zm97.44 1.69-1.5 3.13c-1.79 3.69-1.88 4.25-0.57 4.25 0.55 0 1.06-0.78 1.1-1.72 0.04-0.95 0.3-1.23 0.56-0.6 0.26 0.64-1.14 3.23-3.06 5.75-1.93 2.52-3.5 3.94-3.5 3.13s0.5-1.67 1.12-1.88c0.99-0.33 1.43-1.82 1.75-6.28 0.05-0.61 0.99-2.16 2.1-3.43l2-2.35zm34.34 0.5c0.54 0 1 0.43 1 0.97s-0.46 1-1 1-0.97-0.46-0.97-1 0.43-0.97 0.97-0.97zm-305.47 0.13c0.5 0 0.43 0.26-0.47 0.84-0.81 0.52-2.12 0.94-2.93 0.91-0.98-0.04-0.8-0.35 0.5-0.91 1.35-0.58 2.4-0.84 2.9-0.84zm241.91 0.93c0.7-0.01 0.59 0.26 0.59 0.79 0 0.93-9.29 5.22-14.75 6.81-6.4 1.87-8.73 2.16-9.31 1.22-0.51-0.83 2.7-2.01 8.84-3.25 1.09-0.22-1.05-0.39-4.75-0.35-5.06 0.06-7-0.29-7.87-1.47-0.63-0.86-1.81-1.86-2.63-2.22-0.81-0.35 0.28-0.38 2.44-0.06 5.63 0.85 16.05 0.59 22.13-0.56 3.14-0.6 4.61-0.89 5.31-0.91zm-238.35 0.03c0.35-0.01 0.74 0.05 1.1 0.19 0.78 0.32 0.55 0.55-0.6 0.6-1.03 0.04-1.6-0.18-1.28-0.5 0.17-0.17 0.44-0.27 0.78-0.29zm-43.682 0.1c-0.224 0.07-0.569 1.04-1.032 2.97-0.385 1.6-0.22 2.72 0.375 2.72 0.552 0 0.969-1.38 0.969-3.1 0-1.79-0.089-2.66-0.312-2.59zm191.34 0c-0.12 0.04-0.19 0.17-0.19 0.4 0 0.56 0.33 1.33 0.69 1.69s0.85 0.41 1.13 0.13-0.02-1.02-0.66-1.66c-0.44-0.44-0.77-0.63-0.97-0.56zm-132.5 0.22c0.33-0.09 0.5 0.51 0.5 1.75 0 2.26-5.29 12.9-8.09 16.28-0.57 0.69-0.8 1.48-0.5 1.78 0.74 0.74 5.62-6.57 5.62-8.41 0-0.91 1.1-0.25 2.91 1.72 1.59 1.75 3.07 3.16 3.28 3.16 1.43 0 6.62-9.18 6.62-11.72 0-1.67 0.43-3.03 0.97-3.03s1.04 1.43 1.07 3.19c0.02 1.75 0.58 4.53 1.28 6.15 1.21 2.82 1.14 3.05-1.94 5.16-1.78 1.22-3.87 2.22-4.62 2.22-1.95 0-4.63 3.24-4.63 5.59 0 1.09 0.82 2.92 1.81 4.06 2.13 2.46 11.4 7.29 13.19 6.88 2.41-0.55 5.46 3.99 7.19 10.69l1.75 6.75-3 6.37c-1.65 3.51-4.03 8.84-5.28 11.81-3.06 7.28-5.25 9.58-12.22 12.91-6.5 3.11-10.28 3.48-14.75 1.44-1.63-0.75-4.94-2.26-7.38-3.38-2.43-1.11-6.21-2.69-8.37-3.47-7.55-2.72-15.25-6.51-15.25-7.5 0-0.54-0.54-0.99-1.22-1-1.4-0.01-10.45-10-12.31-13.59-0.68-1.3-1.22-2.93-1.22-3.59 0-0.67-0.686-2.62-1.534-4.32-2.095-4.2-1.472-7.91 1.754-10.31 2.6-1.93 2.75-1.94 4.68-0.19 1.1 0.99 1.97 2.62 1.97 3.6 0 3.78 8.96 16.59 11.6 16.59 0.52 0 2.02 0.83 3.31 1.85 3.13 2.44 7.51 3.13 24.65 3.9 7.94 0.36 14.73 1 15.13 1.41 1.46 1.47-1.74 8.18-4.94 10.37-5.13 3.52-9.12-0.02-4.62-4.09 2.35-2.13 5.21-2.17 4.4-0.06-0.39 1.03-0.83 1.19-1.28 0.47-0.45-0.73-1.23-0.46-2.37 0.81-2.36 2.6-0.45 3.55 3.28 1.62 3.34-1.72 4.85-5.68 3-7.9-1.57-1.89-2.44-1.86-5.06 0.25-8.8 7.04-10.11 12.15-4 15.56 3.62 2.02 3.73 2.03 8.5 0.28 6.4-2.34 8.26-4.11 6.31-6.06-1.15-1.15-1.78-1.2-3.13-0.22-2.31 1.69-2.08 2.78 0.32 1.5 1.08-0.58 1.96-0.69 1.96-0.25 0 1.11-6.76 4.64-7.5 3.91-0.33-0.34 1-2.45 2.91-4.69 1.92-2.24 3.85-5.69 4.31-7.66 0.76-3.18 1.22-3.57 4.25-3.81 6.71-0.53 7.45-1.71 2.94-4.72-1.62-1.08-2.97-2.5-2.97-3.19 0-0.68-0.5-2.23-1.12-3.43-0.63-1.21-1.46-2.91-1.85-3.72-0.73-1.52-3.14-1.63-10.31-0.57-9.77 1.45-9.77 1.43-10.31-2.59-0.27-2.02-1.25-4.57-2.19-5.66-2.03-2.35-6.85-2.64-8.97-0.53-1.63 1.64-3.62 1.96-3.62 0.6 0-0.49-1.11-1.15-2.5-1.5-1.89-0.48-3.71 0.15-7.07 2.37-2.48 1.64-4.74 2.76-5 2.5-0.25-0.25 0.96-2.34 2.66-4.66 12.92-17.61 15.25-21 22.63-32.59 2.5-3.93 4.03-4.31 2.03-0.5-2.08 3.97-8.17 12.92-10.5 15.44-1.23 1.33-2.25 2.79-2.25 3.25s-0.87 1.74-1.97 2.84c-1.93 1.93-1.84 4.56 0.12 3.35 0.85-0.53 4.41-5.61 7.28-10.47 0.56-0.93 2.86-4.38 5.16-7.66s4.19-6.34 4.19-6.78 0.98-1.63 2.15-2.66c2.47-2.15 2.33-1.92-4 8.44-2.47 4.06-4.86 7.54-5.28 7.72-0.41 0.18-0.75 0.79-0.75 1.34 0 0.56-1.11 2.3-2.47 3.91-1.35 1.61-2.46 3.31-2.46 3.81 0 2.05 1.66 0.66 4.4-3.75 1.6-2.57 3.17-4.88 3.5-5.15s2.19-3.13 4.13-6.38c9.06-15.21 8.87-14.91 8.22-11.97-0.34 1.54-1.74 4.49-3.07 6.6-1.33 2.1-2.4 4.11-2.4 4.47 0 0.35-2.15 3.57-4.78 7.15-4.69 6.38-7.04 10.17-7.04 11.44 0.01 2.51 14.47-19.13 17-25.44 1.6-3.96 2.61-5.95 3.16-6.09zm66.06 0.06 0.69 8.84c0.37 4.87 1.12 11.57 1.66 14.88 0.53 3.31 0.93 7.2 0.93 8.62 0 1.43-0.42 2.57-0.96 2.57s-1-1.52-1-3.38-0.45-3.69-1-4.03c-0.56-0.34-0.92-1.11-0.82-1.75 0.11-0.64-0.11-4.05-0.5-7.56-0.38-3.52-0.31-9.04 0.16-12.28l0.84-5.91zm-83.56 0.62c0.42-0.01 0.02 0.37-1.12 1.29-1.05 0.84-2.56 1.53-3.38 1.53-2.08 0-0.22-1.6 2.81-2.41 0.89-0.23 1.44-0.4 1.69-0.41zm315.75 0.85c0.65-0.01 1.45 0.46 1.78 1 0.76 1.22 0.42 1.22-1.47 0-0.88-0.57-1.01-0.99-0.31-1zm-12.06 1c0.84 0 1.56 0.43 1.56 0.97s-0.43 0.97-0.94 0.97-1.19-0.43-1.53-0.97c-0.33-0.54 0.07-0.97 0.91-0.97zm25.31 0.44c0.08-0.01 0.18 0.01 0.31 0.03 0.53 0.08 1.32 1.86 1.75 3.97 0.44 2.11 0.63 4.51 0.41 5.34-0.36 1.31-0.45 1.32-0.66 0.03-0.12-0.81-0.13-2.06-0.03-2.81 0.13-0.94-0.36-1.16-1.59-0.69-1.44 0.55-1.58 0.4-0.59-0.59 1.35-1.37 1.65-4.36 0.5-5-0.31-0.17-0.33-0.28-0.1-0.28zm-363 0.56c-1.34 0.03-1.32 0.25 0.28 1.47 2.49 1.88 4.1 1.86 2.53-0.03-0.67-0.82-1.93-1.46-2.81-1.44zm157.81 0c0.05 0 0.11 0.1 0.16 0.28 0.33 1.27 1.2 1.69 3.06 1.47 2.21-0.26 2.68 0.11 2.94 2.34 0.24 2.11-0.3 2.97-2.66 4.19-1.63 0.84-3.2 1.53-3.5 1.53-0.29 0-0.5-2.54-0.43-5.66 0.05-2.52 0.23-4.16 0.43-4.15zm164.94 0.31c0.87-0.03 4.86 3.46 11.35 10.13 8.87 9.12 11.77 11.44 18.06 14.47 4.11 1.97 8.43 3.59 9.59 3.59 1.2 0 2.09 0.61 2.09 1.44 0 0.88-0.6 1.25-1.5 0.9-2.07-0.79-1.93 2.94 0.19 5.07 0.92 0.91 2.92 2.12 4.44 2.65 1.72 0.6 2.75 1.65 2.75 2.81 0 1.03-0.2 1.88-0.47 1.88s-0.5-0.43-0.5-0.97-0.47-1-1.03-1c-1.08 0-2.54-1.05-6.44-4.63-1.3-1.19-2.37-1.73-2.37-1.18s-0.54 0.67-1.22 0.25-2.12-0.9-3.19-1.07c-4.52-0.7-16.98-11.34-22.19-18.93-2.84-4.15-3.87-5.46-6.12-7.94-0.95-1.04-1.43-1.91-1.09-1.91 0.33 0-0.15-1.16-1.07-2.56-1.32-2.02-1.74-2.98-1.28-3zm-82 0.03c0.19 0.03 0.39 0.22 0.56 0.5 0.38 0.61 0.14 1.1-0.5 1.1-0.86 0-0.85 0.37 0.07 1.47 0.77 0.93 0.84 1.46 0.18 1.46-1.65 0-2.36-1.8-1.37-3.56 0.31-0.55 0.61-0.85 0.87-0.94 0.07-0.02 0.13-0.04 0.19-0.03zm-116.31 0.03c0.05-0.01 0.1-0.01 0.16 0 0.06 0.02 0.11 0.06 0.18 0.1 0.54 0.33 1 1.25 1 2.03s-0.46 1.41-1 1.41c-0.54-0.01-0.97-0.92-0.97-2.04 0-0.85 0.26-1.42 0.63-1.5zm107.56 0.5v3.5 3.47h-5.66c-6.71-0.02-8.38-0.9-7.93-4.06 0.31-2.18 0.81-2.36 6.97-2.63l6.62-0.28zm14.75 0.57-0.47 5.9c-0.63 8.15-1.57 13.58-2.53 14.78-0.45 0.56-1.68 5.17-2.78 10.22-1.1 5.06-2.42 9.68-2.91 10.28-0.82 1.03-1.31 3.4-2.72 12.69-0.3 2.03-0.98 3.92-1.46 4.22-0.49 0.3-0.88 1.65-0.88 2.97s-0.49 2.41-1.06 2.41c-1.24 0-0.28-7.62 1.59-12.82 0.69-1.89 1.97-6.98 2.88-11.31 0.9-4.33 2.05-8.65 2.56-9.59s0.92-2.91 0.94-4.41c0.02-2.52 2-10.17 5.4-20.91l1.44-4.43zm-212.62 0.47c0.16 0.02 0.17 0.29-0.07 0.78-2.16 4.55-3.3 6.71-3.72 7.12-0.27 0.27-2.12 3.05-4.15 6.16-3.65 5.58-4.69 6.58-4.69 4.65 0-0.54 0.46-0.97 1-0.97s0.97-0.66 0.97-1.43c0-0.78 0.54-1.99 1.22-2.72 1.82-1.98 3.69-5.51 3.69-6.94 0-0.69 1.15-2.42 2.53-3.91 1.64-1.77 2.85-2.8 3.22-2.74zm-35.88 0.21c-0.2 0.08-0.28 0.6-0.25 1.38 0.05 1.14 0.25 1.38 0.56 0.59 0.29-0.71 0.27-1.55-0.06-1.87-0.08-0.08-0.18-0.12-0.25-0.1zm313.97 0.69c0.78 0.14 1.44 2.32 1.44 6.5 0 3.61-0.42 6.41-0.97 6.41-0.6 0-0.95 4.08-0.88 10.56 0.11 9.57 0.23 10.05 0.97 5.16 0.45-2.98 0.57-6.95 0.32-8.85-0.44-3.18-0.37-3.24 0.62-0.97 0.59 1.36 0.94 5.45 0.75 9.1s-0.02 6.62 0.41 6.62c1.27 0 0.85 8.53-0.47 9.6-0.68 0.54-2.58 1.27-4.22 1.62-3.85 0.82-15.12 10.87-13.75 12.25 1.15 1.17 6.4 0.32 6.4-1.03 0.01-0.51 0.47-0.63 1.04-0.28s1.85-0.3 2.84-1.44c1.1-1.26 2.4-1.81 3.38-1.44 1.16 0.45 1.59 0.06 1.59-1.5 0-1.31 0.45-1.88 1.12-1.47 0.61 0.38 1.47 0.06 1.94-0.68 0.69-1.09 0.86-1.04 0.88 0.28 0 0.9-0.48 1.82-1.1 2.03-0.84 0.28-0.81 2.06 0.16 6.94 1.22 6.13 1.17 6.67-0.59 8.62-1.54 1.7-2.69 2.04-6.1 1.66-4.48-0.51-5.96 0.32-3.78 2.12 2.08 1.73 9.58 1.65 13.12-0.12 3.02-1.51 3.19-1.49 3.19 0.19 0 1.01-0.93 2.03-2.19 2.37-2.3 0.62-10.34 0.7-12.06 0.13-0.54-0.18-2.2-0.58-3.68-0.91-2.32-0.51-2.72-1.07-2.72-3.97 0-2.38 0.58-3.73 1.96-4.47 1.28-0.68 1.97-0.7 1.97-0.06 0 0.54 0.72 0.73 1.57 0.41 0.84-0.33 2.57-0.04 3.87 0.65 1.92 1.03 2.67 1.03 3.91 0 2.45-2.03 0.05-3.76-6.19-4.43-11.61-1.26-12.95-1.59-12.94-3.29 0.02-2.27 4.7-20.95 5.44-21.68 0.33-0.33 0.32 1.03-0.06 3.06-0.52 2.77-0.38 3.73 0.62 3.81 11.93 1.01 14.63 0.53 14.63-2.62 0-2.89-2.55-3.17-8.88-0.94-2.3 0.81-4.33 1.5-4.53 1.5-0.75 0-0.35-4.13 0.56-5.84 0.52-0.98 2.11-6.16 3.5-11.5 1.4-5.35 2.95-10.84 3.44-12.19 0.49-1.36 1.08-4.09 1.31-6.07 0.49-4.09 1.38-5.98 2.16-5.84zm-211.75 0.1c0.51-0.01 0.65 1 0.28 2.21-2.66 8.76-3.65 13.54-3.81 18.35l-0.19 5.53 9.59 0.25c5.31 0.15 9.6 0.72 9.6 1.25 0 0.55-4.32 0.94-10.22 0.94-11.54 0-11.38 0.13-11.41-8.72-0.01-4.74 4.67-19.81 6.16-19.81zm249.03 0c0.24-0.01 0.73 0.45 1.06 1 0.34 0.54 0.14 0.96-0.43 0.96-0.58 0-1.07-0.42-1.07-0.96 0-0.55 0.2-1 0.44-1zm-44.06 0.9c0.21 0 0.36 0.17 0.53 0.47 0.6 1.08 0.13 2.84-1.59 5.75-1.38 2.31-3 5.42-3.6 6.91-1.29 3.24-3.28 3.67-2.31 0.5 0.37-1.22 2.02-5.04 3.66-8.47 1.74-3.65 2.67-5.15 3.31-5.16zm-277.81 1.06c0.42 0 0.75 0.35 0.75 0.75-0.01 1.06-4.84 6.82-4.88 5.82-0.05-1.29 3.26-6.57 4.13-6.57zm236.47 0c0.81 0 1.2 0.46 0.87 1s-1.28 0.97-2.09 0.97c-0.82 0-1.18-0.43-0.85-0.97 0.34-0.54 1.25-1 2.07-1zm88.9 0c0.54 0 1 0.46 1 1s-0.46 0.97-1 0.97-0.97-0.43-0.97-0.97 0.43-1 0.97-1zm-245.22 0.1c1.69 0.04 3.48 0.55 4.72 1.5 1.89 1.45 1.85 1.48-0.75 0.84-2.98-0.73-3.86 0.99-0.97 1.91 0.95 0.3 2.35 1.59 3.1 2.81l1.34 2.19-2.41-2.19c-3.8-3.5-4.01-1.4-0.25 2.56 1.87 1.97 3.37 4.6 3.38 5.85 0.01 3.1-1.58 1.9-2.31-1.75-0.33-1.64-1-2.97-1.5-2.97-0.51 0-0.18 2.16 0.71 4.81 0.9 2.65 1.94 4.63 2.35 4.38 0.4-0.26 0.75-0.02 0.75 0.56 0 0.57-1.27 1.06-2.81 1.06-1.55 0-4.75 0.21-7.13 0.47-5.32 0.57-6.78-0.04-6.78-2.78 0-4.18 3.06-16.59 4.41-17.94 0.9-0.9 2.46-1.35 4.15-1.31zm-84.9 1.28c0.35 0.01 0.59 0.36 0.59 0.97 0 0.81-0.43 1.76-0.97 2.09-0.54 0.34-1-0.03-1-0.84s0.46-1.76 1-2.1c0.14-0.08 0.26-0.12 0.38-0.12zm298.03 0c0.28-0.12 1.19 1.3 2.87 4.53 4.39 8.42 5.92 10.84 6.97 10.84 0.48 0 0.44-0.57-0.06-1.25-0.5-0.67-1.44-2.56-2.09-4.18l-1.19-2.94 2.56 2.94c8.12 9.44 11.84 13.28 12.87 13.28 0.65 0 1.32 0.34 1.5 0.75 0.54 1.19 7.45 6.15 8.6 6.15 0.58 0 1.06 0.41 1.06 0.91s1 1.21 2.22 1.59 2.42 0.98 2.69 1.32c0.9 1.11 7.05 4.06 8.47 4.06 2.05 0 1.67 2.3-0.6 3.72-2.2 1.37-2.64 5.33-0.75 6.84 0.68 0.54 2.34 1.28 3.69 1.66 8.11 2.23 10.79 4.77 3.69 3.47-2.82-0.52-5.18-0.35-7.28 0.53-2.68 1.12-3.42 1.08-5.41-0.28-2.16-1.49-2.2-1.48-0.94 0.09 1.72 2.13 0.77 2.11-2.62-0.03-2.63-1.66-2.63-1.65-1 0.25 1.58 1.85 1.51 1.94-1.16 1.94-1.53 0-3.67-0.85-4.81-1.88s-2.09-1.51-2.09-1.06c-0.01 0.45-1.12-0.23-2.47-1.5-3.89-3.65-3.73-1.8 0.28 3.22 3.78 4.74 7.02 5.85 10.93 3.75 0.96-0.51 4.13-1.25 7.07-1.63l5.34-0.69-2.91 2.35c-1.6 1.28-5.34 3.54-8.34 5.03-7.31 3.64-9.25 3.51-11.78-0.78-1.14-1.93-2.06-3.86-2.06-4.31 0-0.46-1.5-3.52-3.35-6.79-1.84-3.26-3.68-6.94-4.06-8.18-0.8-2.64-3.19-8.41-4.53-10.94-0.51-0.97-0.67-2.15-0.38-2.62 0.3-0.48-1-3.54-2.9-6.79-3.83-6.53-4.13-7.49-2.03-6.68 0.95 0.36 1.24 0.04 0.87-0.91-0.3-0.78-1.04-1.4-1.65-1.41-1.2-0.01-4.49-8.33-5.25-13.28-0.11-0.68-0.1-1.04 0.03-1.09zm-225.47 0.5c0.64-0.01 0.89 0.41 0.5 1.34-0.29 0.68-1.05 3.11-1.69 5.41-0.71 2.58-1.73 4.19-2.65 4.19-2.12 0-4.12 2.93-4.16 6.12-0.03 2.34-0.41 2.72-2.97 2.72-2.02 0-2.97-0.48-2.97-1.53 0-0.9-0.43-1.25-1.09-0.85-1.71 1.06-0.14-4.42 2.28-7.96 2.91-4.27 10.45-9.43 12.75-9.44zm144.87 0.09c0.24 0 0.7 0.46 1.03 1 0.34 0.54 0.17 0.97-0.4 0.97s-1.06-0.43-1.06-0.97 0.2-1 0.43-1zm18 0.28c0.61 0.03 0.54 0.23-0.21 0.57-3.45 1.54-8.98 2.43-7.88 1.28 0.54-0.57 2.97-1.29 5.41-1.6 0.75-0.09 1.36-0.18 1.84-0.22 0.36-0.02 0.64-0.04 0.84-0.03zm-111.4 0.57c-0.13 0.11-0.22 0.88-0.22 2.12 0 1.89 0.16 2.67 0.41 1.72 0.24-0.95 0.24-2.49 0-3.44-0.07-0.23-0.08-0.37-0.13-0.4-0.02-0.02-0.04-0.02-0.06 0zm-141.94 1.12c-0.51 0-1.48 0.69-2.16 1.5-0.67 0.81-0.9 1.47-0.53 1.47 0.38 0 1.35-0.66 2.16-1.47s1.04-1.5 0.53-1.5zm9.25 0c0.78 0 1.06 0.99 0.78 2.72-0.24 1.49-0.68 6.23-0.97 10.56-0.28 4.33-0.89 8.76-1.34 9.85-0.45 1.08-1.37 3.41-2.03 5.18-1.78 4.72-2.68 4.72-3.94 0-1.22-4.58-3.45-7.65-5.53-7.65-1.81 0-1.67-1.88 0.19-2.6 0.82-0.31 2.86-3.5 4.56-7.09 3.3-6.98 6.31-10.97 8.28-10.97zm223.31 0.31c1.23-0.17 4.31 0.99 4.31 1.79 0 1.23-3.65 1.07-4.43-0.19-0.36-0.58-0.5-1.23-0.28-1.44 0.08-0.08 0.23-0.13 0.4-0.16zm-243.15 0.69c-0.238 0-0.406 0.43-0.406 0.97s0.458 1 1.031 1 0.772-0.46 0.438-1c-0.335-0.54-0.824-0.97-1.063-0.97zm290.93 0c0.46 0 0.82 5.75 0.82 12.78 0 14.33-0.89 17.54-1.16 4.19-0.1-4.73-0.23-10.48-0.31-12.78-0.09-2.3 0.2-4.19 0.65-4.19zm3.03 0.97c0.41 0 0.75 4.55 0.76 10.09 0 5.55 0.28 11.76 0.62 13.78 0.38 2.33 0.22 3.69-0.44 3.69-0.57 0-1.29-2.34-1.59-5.19-0.73-6.88-0.27-22.37 0.65-22.37zm-74.74 0.03c0.12-0.03 0.28 0.04 0.46 0.19 0.68 0.56 1.22 2.47 1.22 4.25s0.69 6.7 1.5 10.94 1.47 10.29 1.47 13.43c0 3.15 0.46 6.59 1.03 7.66 1.1 2.06 0.89 9.98-0.22 8.28-0.35-0.54-0.97-2.79-1.37-4.94-0.59-3.11-0.86-3.49-1.41-1.93-0.38 1.07-0.48-2.38-0.22-7.66 0.42-8.46 0.29-9.59-1.15-9.59-1.3 0-1.43-0.37-0.63-1.88 0.56-1.05 0.61-2.04 0.13-2.22s-1.03-4.15-1.22-8.84c-0.22-5.47-0.15-7.54 0.41-7.69zm62.06 0.16c0.06-0.03 0.17 0.01 0.25 0.09 0.32 0.33 0.34 1.17 0.06 1.88-0.31 0.78-0.55 0.55-0.59-0.6-0.04-0.78 0.08-1.3 0.28-1.37zm3.4 0.22c0.05 0 0.05 0.03 0.1 0.06 0.59 0.37 1.06 3.8 1.06 7.9 0 10.18-1.52 10.05-1.84-0.15-0.17-5.42 0.06-7.9 0.68-7.81zm-56.37 0.59c0.35-0.01 0.77 0 1.22 0 3.62 0.01 3.69 0.08 3.84 3.97 0.09 2.47 1.01 5.14 2.5 7.12 1.31 1.75 2.71 3.93 3.06 4.88 0.56 1.51-0.06 1.72-5.03 1.72h-5.65l-1.19-5.19c-0.67-2.86-1.22-6.83-1.22-8.84 0-3.13 0.04-3.6 2.47-3.66zm143.34 0c0.41 0 0.75 0.66 0.75 1.47v2.22c0 0.4-0.34 0.83-0.75 0.97-0.4 0.13-0.72-0.87-0.72-2.22 0-1.36 0.32-2.44 0.72-2.44zm-347.75 0.41c0.09 0.03 0.13 0.22 0.13 0.56-0.02 0.81-0.41 2.58-0.85 3.94-0.63 1.97-0.75 2.08-0.78 0.5-0.01-1.09 0.32-2.86 0.78-3.94 0.26-0.6 0.49-0.95 0.63-1.03 0.03-0.02 0.07-0.05 0.09-0.03zm125.5 0.28c-0.09 0.12-0.14 1.13-0.18 2.9-0.07 2.26 0.16 4.84 0.5 5.72 1.14 2.99 1.38 0.84 0.5-4.5-0.5-2.96-0.7-4.28-0.82-4.12zm65 0.9c0.31-0.07 0.95 1.65 1.56 4.19 1.03 4.24 1.03 5.38 0.04 6-0.79 0.49-1 1.75-0.6 3.38 0.66 2.6 0.5 3.08-0.68 1.9-1.05-1.04-0.81-7.03 0.31-7.4 0.68-0.23 0.65-1.39-0.1-3.53-0.6-1.75-0.88-3.69-0.65-4.38 0.03-0.09 0.08-0.15 0.12-0.16zm73.82 0.16c0.39 0.06 0.51 1.82 0.53 5.88 0.01 3.92-0.11 7.12-0.32 7.12-1 0-1.63-10.93-0.71-12.5 0.19-0.33 0.36-0.52 0.5-0.5zm-259.47 0.53c0.21 0.04 0.34 0.23 0.34 0.53 0 0.54-0.43 1.26-0.97 1.6-0.54 0.33-1 0.19-1-0.35s0.46-1.29 1-1.62c0.14-0.09 0.26-0.1 0.38-0.13 0.08-0.01 0.17-0.04 0.25-0.03zm270.28 0.72c0.25-0.11 0.61 0.19 1.03 0.87 0.31 0.51 0.14 1.2-0.41 1.54s-1.03-0.1-1.03-0.94c0-0.87 0.15-1.36 0.41-1.47zm-17.75 0.13c0.06-0.03 0.17 0.01 0.25 0.09 0.32 0.33 0.34 1.16 0.06 1.87-0.31 0.79-0.55 0.56-0.59-0.59-0.04-0.78 0.08-1.3 0.28-1.37zm82.68 0.81c0.24 0 0.73 0.43 1.07 0.97 0.33 0.54 0.13 1-0.44 1s-1.03-0.46-1.03-1 0.17-0.97 0.4-0.97zm-67.96 0.75c0.16-0.21 0.39 1.84 0.78 6.12 0.46 5.14 0.7 9.81 0.53 10.35-0.52 1.59-1.61-9.45-1.47-14.79 0.03-1.02 0.08-1.59 0.16-1.68zm24.28 0.22c0.54 0 0.97 0.2 0.97 0.43 0 0.24-0.43 0.7-0.97 1.03-0.54 0.34-1 0.17-1-0.4s0.46-1.06 1-1.06zm-295.69 0.43c0.06 0.01 0.14 0.13 0.22 0.32 0.27 0.67 0.27 1.76 0 2.43-0.27 0.68-0.47 0.14-0.47-1.22 0-0.84 0.06-1.38 0.19-1.5 0.02-0.01 0.04-0.03 0.06-0.03zm241.84 0.66c0.16 0.03 0.29 0.56 0.47 1.63 0.46 2.59 2.96 2.88 4.66 0.56 1.43-1.96 3.47-0.94 3.47 1.72 0 1.94 0.74 2.22 4.65 1.9 1.85-0.15 2.22 0.34 2.22 2.82 0 3.36 0.94 4.31 2.97 3.06 2.31-1.43 4 0.72 2.75 3.47-1.38 3.03-0.48 5.16 2.34 5.59 1.43 0.22 2.15 0.9 1.91 1.81-1.32 5.04-1.27 5.85 0.5 6.5 2.74 1.01 3.37 2.55 1.59 3.85-1.36 0.99-1.4 1.57-0.31 4.22 0.7 1.68 1.68 2.85 2.16 2.56 0.48-0.3 0.84 0.38 0.84 1.53 0 1.14-0.36 1.83-0.84 1.53-0.49-0.3-1.17 0.15-1.5 1-0.97 2.53-0.69 5.11 0.62 5.66 0.87 0.36 0.65 0.99-0.71 2.09-1.07 0.86-1.99 2.77-2.1 4.25s-0.24 2.98-0.28 3.38c-0.04 0.39-1.46 0.45-3.12 0.12-2.58-0.51-2.97-0.33-2.69 1.22 0.34 1.97-2.93 3.3-4 1.62-0.34-0.52-1.63-1.24-2.85-1.62-1.64-0.52-2.18-0.31-2.18 0.84 0 2.47-2.91 1.78-3.94-0.94-0.77-2.03-1.41-2.35-3.44-1.84-2.16 0.54-2.47 0.28-2.47-1.9 0-2.79-1.57-4.18-4.19-3.76-1.84 0.31-2.37-1.31-0.74-2.31 1.57-0.97-1.69-6.42-3.44-5.75-1.16 0.45-1.47-0.31-1.47-3.53 0-3.15-0.6-4.65-2.59-6.5-2.02-1.86-2.34-2.71-1.47-3.75 0.82-0.99 0.81-2.16 0-4.5-0.61-1.75-0.83-4.92-0.47-7.12 0.39-2.48 0.23-4.53-0.47-5.38-0.91-1.09-0.72-1.34 0.91-1.34 2.58 0 5.04-3.46 4.34-6.13-0.46-1.75-0.21-1.96 1.81-1.47 2.64 0.65 5.03-0.74 6.31-3.72 0.41-0.94 0.59-1.4 0.75-1.37zm58.41 0.31c0.06 0 0.14 0.06 0.25 0.19 0.4 0.47 1.33 2.85 2.03 5.28 0.71 2.44 1.85 6.21 2.56 8.38 0.71 2.16 2.28 7.37 3.47 11.56 1.2 4.19 2.59 7.62 3.13 7.62 1.39 0 3.59 3.12 3.62 5.16 0.02 0.95 0.49 1.72 1.03 1.72 1.37 0 1.32-0.19-1.62-6.59-1.44-3.13-2.55-6.04-2.47-6.44 0.08-0.41-0.25-0.72-0.75-0.72s-1.21-1.46-1.56-3.22c-0.36-1.76-0.86-4.07-1.13-5.16-0.27-1.08 1.1 1.09 3.03 4.85 1.94 3.75 3.5 7.19 3.5 7.62s2.22 5.35 4.91 10.91 5 11.17 5.16 12.5c0.5 4.42-3.76 3.56-5.41-1.1-0.32-0.9-1.82-2.27-3.34-3-3.26-1.55-5.61-5.88-7.53-14.06-0.77-3.24-2.81-11.22-4.57-17.72-3.78-13.99-4.71-17.73-4.31-17.78zm-83.28 0.56c0.54 0.01 1 0.66 1 1.47 0 0.82-0.46 1.5-1 1.5s-0.97-0.68-0.97-1.5c0-0.81 0.43-1.47 0.97-1.47zm130.28 0c0.24 0.01 0.73 0.46 1.06 1 0.34 0.55 0.14 0.97-0.44 0.97-0.57 0-1.06-0.42-1.06-0.97 0-0.54 0.2-1 0.44-1zm-274.88 1.16c1.11-0.03 1.37 2.65 0.41 5.16-0.33 0.85-1.01 1.56-1.53 1.56-1.38 0-0.57-6.18 0.88-6.66 0.08-0.02 0.17-0.06 0.24-0.06zm-73.5 2.13c0.22-0.1 0.57 0.13 1.16 0.62 1.28 1.06 1.3 1.55 0 4.06-1.75 3.4-2.86 3.77-2.03 0.66 0.33-1.22 0.59-3.05 0.59-4.06 0.01-0.76 0.07-1.19 0.28-1.28zm137.16 1.56c0.07-0.01 0.14 0.02 0.22 0.15 1.21 1.93 1.57 26.5 0.41 27.35-0.46 0.33-1.61 2.17-2.57 4.06-0.95 1.89-3.02 5.52-4.62 8.09-1.6 2.58-3.33 6.12-3.81 7.88-0.79 2.84-0.96 3-1.66 1.25-0.44-1.08-1.07-2.21-1.37-2.5-0.31-0.29-2.41-2.49-4.66-4.91-4.06-4.36-4.1-4.47-5.22-15.22-0.62-5.95-1.37-11.92-1.69-13.28l-0.59-2.46 2.59 2.4c1.43 1.31 2.65 3.28 2.69 4.41 0.07 1.98 0.07 1.98 0.81 0.09 0.69-1.75 0.89-1.64 1.85 1 0.86 2.38 1.06 2.49 1.12 0.78 0.11-2.84 4.4-3.9 7.5-1.87 1.66 1.09 2.46 2.78 2.91 6.19 0.34 2.58 0.68 5.32 0.78 6.09s0.8 1.62 1.56 1.87c1.08 0.36 1.25-0.3 0.75-2.9-0.39-2.06-0.28-2.8 0.25-1.97 1.91 2.97 2.71-2.31 2.35-14.97-0.23-7.78-0.08-11.45 0.4-11.53zm146.5 0.34c0.2 0.02 0.3 0.16 0.28 0.41-0.04 0.44-0.44 1.7-0.9 2.78-0.82 1.9-0.84 1.89-0.91-0.19-0.04-1.18 0.37-2.44 0.91-2.78 0.13-0.08 0.29-0.15 0.4-0.19 0.09-0.02 0.15-0.03 0.22-0.03zm30.81 0.22c-0.46-0.03-0.58 0.35-0.31 1.06 0.3 0.79 0.99 1.41 1.47 1.41 1.41 0 0.99-1.72-0.56-2.31-0.24-0.09-0.44-0.15-0.6-0.16zm-333.31 0.5c0.54 0 0.71 0.43 0.38 0.97-0.34 0.54-1.06 1-1.6 1s-0.71-0.46-0.37-1c0.33-0.54 1.05-0.97 1.59-0.97zm295.47 0.22c0.02-0.02 0.01-0.01 0.03 0 0.05 0.04 0.13 0.23 0.19 0.53 0.23 1.22 0.23 3.19 0 4.41-0.24 1.21-0.44 0.21-0.44-2.22 0-1.6 0.1-2.58 0.22-2.72zm-82.91 1.25 0.91 4.44c0.49 2.43 0.77 5.52 0.63 6.87l-0.26 2.47-0.74-2.47c-0.4-1.35-0.68-4.44-0.63-6.87l0.09-4.44zm51 0.41c-2.63 0-5.17 1.16-7.5 3.56-3.11 3.21-3.37 3.91-3.37 9.78 0 3.48 0.42 7.32 0.91 8.56 5.13 13.25 10.04 20.99 15.65 24.63 3.61 2.34 10.33 1.72 13.5-1.25 2.16-2.03 2.41-3.07 2.41-10.28 0-6.16-0.56-9.39-2.41-14.1-5.26-13.41-12.47-20.91-19.19-20.9zm41.07 0.15c0.13 0.03 0.18 0.38 0.18 1.1 0.01 0.91-0.42 1.94-0.97 2.28-1.24 0.77-1.24-0.54 0-2.47 0.42-0.64 0.65-0.93 0.79-0.91zm-275.94 0.25c-0.46 0.03-1.09 0.38-1.72 1.22-0.79 1.04-1.45 2.3-1.47 2.75-0.05 1.28 2.18 0.2 3.31-1.59 0.93-1.48 0.64-2.42-0.12-2.38zm48.75 1.13c0.79-0.04 1.75-0.01 2.87 0.12 5.04 0.6 6.13 1.05 6.13 2.44 0 1.24-10.54 1.19-11.31-0.06-0.93-1.51-0.07-2.38 2.31-2.5zm185.78 0.5c1.39-0.02 2.37 1.1 2.78 3.31 0.34 1.81 0.49 4.58 0.31 6.16l-0.34 2.84-3.66-4.91c-3.3-4.45-3.5-5.04-2.03-6.15 1.11-0.84 2.1-1.24 2.94-1.25zm37.53 1.28c0.08 0.01 0.09 0.18 0.09 0.47 0.03 0.67-1.28 5.94-2.9 11.72-1.62 5.77-3.22 10.74-3.56 11.06s-0.37-0.29-0.07-1.38c0.3-1.08 1.34-5.28 2.29-9.34 1.49-6.43 3.6-12.64 4.15-12.53zm-146.87 0.09c0.05-0.04 0.12 0.24 0.18 0.88 0.22 2.03 0.22 5.34 0 7.37-0.21 2.03-0.37 0.37-0.37-3.68 0-2.79 0.07-4.46 0.19-4.57zm-64.35 0.13-0.65 2.47c-0.37 1.35-1.74 5.15-3.04 8.43-1.29 3.29-2.34 6.54-2.34 7.22s-0.89 1.98-1.97 2.88-2.86 3.4-3.97 5.56c-2.74 5.37-1.29 0.42 2-6.88 1.47-3.24 3.43-7.9 4.35-10.34 0.92-2.43 2.56-5.52 3.65-6.87l1.97-2.47zm36.07 0.5c0.54 0 1.49 1.43 2.12 3.18 1.5 4.21 3.98 18.02 4 22.38 0.02 3.39 1.9 10.15 3.22 11.47 0.37 0.37 0.69 4.59 0.69 9.41 0 10.08 1.47 10.85 2.5 1.28 0.37-3.51 1.08-6.41 1.56-6.41s0.84 2.89 0.84 6.41c0 3.51 0.43 6.37 0.91 6.37 1.06 0 2.06-2.41 2.06-4.94 0-1.01 1.13-3.02 2.47-4.47 1.34-1.44 2.69-4.13 3.03-5.96 0.35-1.84 1.1-3.63 1.66-3.97 1.2-0.75 0.28 6.28-1.47 11.19-1.33 3.7-0.7 4.8 1.97 3.37 1.4-0.75 2.07-2.54 2.56-6.69 0.85-7.19 1.59-10.15 2.56-10.15 0.42 0 0.53 3.66 0.25 8.18-0.32 5.1-0.12 8.49 0.5 8.88 0.66 0.41 1.14-4.26 1.38-13.59 0.23-8.99 0.78-14.66 1.5-15.38 1.15-1.15 1.39-0.06 2.62 11.59 0.34 3.23 0.14 3.98-0.93 3.57-1.03-0.4-1.25 0.2-0.91 2.31 0.25 1.54 0.69 5.21 1 8.19s1.03 6.1 1.59 6.9c1.03 1.48 0.91-1.53-0.53-11.31-0.43-2.91-0.32-3.43 0.38-1.97 0.52 1.08 1.21 4.12 1.56 6.75 0.42 3.22 0.96 4.45 1.62 3.78 0.67-0.66 0.49-2.84-0.5-6.72-1.29-5.09-2.28-13.1-3.03-24-0.13-1.89-0.37-3.86-0.53-4.4-0.15-0.54-0.18-2.32-0.06-3.94 0.2-2.74 0.25-2.68 1 0.97 0.44 2.16 1.12 6.48 1.47 9.59 0.34 3.11 1.1 5.66 1.65 5.66 0.64 0 0.77-1.89 0.38-5.16-0.4-3.27-0.32-4.62 0.25-3.69 0.49 0.82 1.22 4.99 1.59 9.29 0.38 4.29 0.98 8.27 1.35 8.84 0.36 0.57 0.74 2.15 0.81 3.5 0.37 6.91 1.73 14.78 2.59 14.78 0.61 0 0.76-3.06 0.41-8.12-0.32-4.59-0.22-6.8 0.22-5.1 0.89 3.51 4.11 9.28 5.19 9.28 0.4 0 0.49 0.66 0.18 1.47-0.68 1.77 0.76 1.96 2.41 0.32 1.8-1.81 1.39-3.76-0.78-3.76-1.16 0-2.55-1.18-3.44-2.9-1.66-3.22-3.41-13.91-3.41-20.72 0-4.34 0.05-4.25 2.82 3.94 1.55 4.6 3.33 10.27 3.96 12.62 1.55 5.77 2.35 4.5 2.22-3.53l-0.12-6.62 1.9 3.93c1.05 2.17 2.19 5.37 2.54 7.13 0.4 2.05 1.98 4.35 4.43 6.37 2.11 1.74 3.82 3.52 3.82 3.94 0 0.43-1.79 0.75-3.97 0.75-2.19 0-5.15 0.77-6.6 1.72-3.88 2.54-19.99 2.43-24.81-0.16-4.01-2.15-15.38-2.35-19-0.37-2.02 1.11-14.47 1.94-14.47 0.97 0-0.24 1.32-1.94 2.94-3.78 2.05-2.34 2.94-4.34 2.88-6.53l-0.1-3.16-0.9 2.97c-1.15 3.76-7.38 10.77-8.29 9.31-0.85-1.37 0.32-7.61 1.57-8.38 0.52-0.32 0.9 0.59 0.9 2 0 1.42 0.41 2.36 0.88 2.07 0.46-0.29 0.71-4.87 0.53-10.16-0.28-7.95-0.2-8.96 0.62-5.72 0.55 2.16 1.5 4.39 2.1 4.94 0.78 0.72 0.91 0.3 0.47-1.47-0.34-1.35-0.62-3.9-0.63-5.72-0.01-2.63-0.35-3.2-1.62-2.72-1.42 0.55-1.49-0.29-0.94-7.53 0.58-7.71-0.24-16.89-1.85-20.65-0.41-0.99-0.31-1.72 0.26-1.72zm106.43 0.53c5.2-0.03 5.41 0.04 5.13 2.41-0.89 7.3-1.49 10.42-2.16 11.31-0.41 0.54-1.77 5.51-3.03 11.06-1.86 8.22-2.61 10.09-4.06 10.09-1.4 0-1.78-0.78-1.78-3.68-0.01-2.03-0.64-7.67-1.44-12.54-0.8-4.86-1.46-10.74-1.47-13.06-0.02-4.96 0.89-5.55 8.81-5.59zm70.38 1.84c0.03-0.02 0.07 0 0.09 0 0.16 0.05 0.08 0.69-0.22 2.03-0.81 3.62-1.39 4.43-1.37 1.91 0.01-1.04 0.48-2.56 1.03-3.37 0.2-0.31 0.36-0.5 0.47-0.57zm-34.44 0.41c0.05 0.03 0.09 0.17 0.16 0.4 0.24 0.95 0.24 2.5 0 3.44-0.25 0.95-0.44 0.18-0.44-1.72 0-1.42 0.12-2.21 0.28-2.12zm2.91 0.37c0.01-0.02 0.01-0.01 0.03 0 0.05 0.04 0.13 0.23 0.19 0.53 0.23 1.22 0.23 3.23 0 4.44-0.24 1.22-0.44 0.22-0.44-2.22 0-1.59 0.1-2.6 0.22-2.75zm-150.5 0.63-3.19 3.03c-3.28 3.09-3.34 4.34-0.06 1.37 0.99-0.89 2.13-1.3 2.53-0.9 0.86 0.87-4.91 5.85-9.22 7.94-2.96 1.43-6.24 4.43-4.84 4.43 1.47 0 10.03-5.36 13.06-8.18 1.76-1.65 3.18-2.69 3.18-2.32 0 0.94-2.73 3.54-7.37 7.03-2.13 1.61-4.66 3.73-5.63 4.69-2.2 2.21-2.95 2.2-4.34-0.03-1.51-2.41-3.61-12.78-2.94-14.53 0.3-0.77 1.58-1.37 2.82-1.34 1.23 0.02 5.33-0.23 9.12-0.57l6.88-0.62zm-133.72 0.16c0.843 0 1.271 0.42 0.937 0.96s-1.053 1-1.563 1c-0.509 0-0.906-0.46-0.906-1s0.688-0.96 1.532-0.96zm95.282 0c0.87 0 1.57 0.54 1.56 1.21-0.02 1.6-1.92 4.57-1.94 3.03 0-0.63-0.29-1.83-0.62-2.68-0.39-1.02-0.04-1.56 1-1.56zm291.03 0.21c0.12 0.05 0.36 0.74 0.78 2.16 0.9 2.99 0.77 4.02-0.37 2.87-0.36-0.36-0.64-1.78-0.6-3.18 0.04-1.25 0.07-1.89 0.19-1.85zm-372.22 0.91c-0.63-0.05-0.69 0.68-0.25 2.47 0.38 1.54 1.04 2.94 1.5 3.12s0.84 1.09 0.84 2.03c0 0.95 1.36 3.82 3.04 6.35 2.12 3.2 3.67 4.52 5.15 4.47 1.43-0.05 1.66-0.22 0.69-0.6-3.25-1.28-7.47-8.25-8.81-14.5-0.34-1.58-1.19-3.05-1.88-3.28-0.11-0.04-0.19-0.05-0.28-0.06zm243.94 0.09c1.09 0.14 1.29 4.69 1.25 24.6-0.02 11.45-0.25 11.78-5.31 9.03-2.48-1.35-2.69-1.95-2.69-7.28 0-3.2 0.37-6.06 0.84-6.35 0.73-0.44 1.67-4.03 2.69-10.4 0.83-5.2 2.08-9.27 2.97-9.57 0.08-0.02 0.18-0.04 0.25-0.03zm12.31 0.1c0.11-0.07 0.23-0.02 0.41 0.15 0.56 0.54 1.19 3.75 1.37 7.13s-0.03 6.16-0.44 6.15c-0.4 0-0.74-1.06-0.74-2.34-0.01-1.28-0.26-4.48-0.6-7.12-0.32-2.5-0.31-3.77 0-3.97zm-178.69 0.15c0.28 0.04 0.65 0.65 1.16 1.88 0.65 1.58 0.99 3.58 0.78 4.44-0.26 1.06-0.75 0.65-1.56-1.32-0.65-1.58-0.99-3.55-0.78-4.4 0.09-0.4 0.24-0.62 0.4-0.6zm11.5 0.1c0.49-0.16 0.49 2.32-0.37 6.47-0.6 2.88-1.74 8.99-2.5 13.59-0.77 4.6-1.84 9.92-2.38 11.81-0.81 2.89-0.93 2.33-0.59-3.43 0.62-10.57 1.65-18.6 2.5-19.69 0.42-0.54 1.3-2.97 1.97-5.41 0.6-2.21 1.08-3.25 1.37-3.34zm184.53 0.4c0.55 0 0.97 1.09 0.97 2.44s-0.42 2.47-0.97 2.47c-0.54 0-1-1.12-1-2.47s0.46-2.44 1-2.44zm-177.62 0.25c0.1-0.01 0.22 0.04 0.38 0.13 0.55 0.34 1.31 2.48 1.68 4.78 0.38 2.3 1.24 5.5 1.94 7.12 0.7 1.63 1.53 3.75 1.84 4.69 0.35 1.06 0.05 1.72-0.75 1.72-0.81 0-1.92-2.83-3-7.62-0.94-4.2-1.94-8.46-2.21-9.47-0.23-0.83-0.18-1.31 0.12-1.35zm-61.66 0.03c0.68-0.03 1.33 0.42 2.57 1.32 1.88 1.37 2.54 2.73 2.56 5.37 0.04 4.43 2.44 6.85 6.15 6.13 1.49-0.29 2.72-0.91 2.72-1.38s1.01-0.85 2.22-0.81c1.22 0.04 3.85-0.25 5.82-0.63 3.48-0.67 3.57-0.57 4.74 3.13 0.67 2.09 1.73 4.24 2.35 4.78s1.72 1.77 2.47 2.72c1.24 1.58 1 1.72-3.03 1.72-2.41 0-4.68-0.3-5.03-0.66-0.36-0.35-6.24-0.57-13.07-0.47-8.34 0.13-12.9-0.19-13.84-0.96-0.77-0.64-3.54-1.52-6.19-1.94-2.64-0.42-5.78-1.64-6.97-2.69s-3.01-2.62-4.03-3.5c-2.82-2.45-2.22-3.75 3.63-7.81 4.87-3.39 5.55-3.6 6.93-2.22 2.07 2.06 3.9 1.95 7.25-0.53 1.39-1.03 2.07-1.53 2.75-1.57zm220.19 0.35c0.25-0.08 0.28 0.97 0.31 3.53 0.04 2.57-0.11 4.69-0.37 4.69-1.1 0-1.52-4.66-0.63-6.91 0.32-0.8 0.54-1.26 0.69-1.31zm79.09 0.34c-0.05 0.05 0.24 0.47 0.85 1.25 1.28 1.64 2.09 2.16 2.09 1.35 0-0.21-0.77-0.98-1.72-1.72-0.78-0.61-1.16-0.93-1.22-0.88zm-240.03 0.07c0.55-0.07 0.97 0.71 0.97 2.34 0 1.33 0.54 3.54 1.16 4.9 0.87 1.92 0.84 2.81-0.13 3.97-0.68 0.83-1.76 1.45-2.37 1.41-0.7-0.05-0.65-0.22 0.12-0.53 1.93-0.78 1.48-1.92-1.31-3.19-1.82-0.83-2.27-1.49-1.59-2.34 0.52-0.67 1.2-2.42 1.56-3.91 0.4-1.68 1.05-2.59 1.59-2.65zm229.5 2.21c0.03 0.02 0.05 0.09 0.1 0.19 0.23 0.54 1.41 5.4 2.59 10.81 1.19 5.41 2.39 10.5 2.69 11.32 0.3 0.81 0.71 2.58 0.94 3.93 0.47 2.89 2.72 5.62 5.31 6.44 1.13 0.36 1.84 1.5 1.84 2.97 0 2.2-0.36 2.41-4.72 2.41-7.28 0-8.59-1.5-8.34-9.47 0.12-3.66-0.18-7.12-0.66-7.69-0.47-0.57-0.89-2.15-0.93-3.5-0.05-1.35-0.28-4.67-0.53-7.38-0.46-4.84-0.44-4.88 0.59-1.24 0.57 2.02 1.48 3.68 2.03 3.68s0.68-0.77 0.31-1.72c-0.67-1.74-1.67-10.95-1.22-10.75zm-31.34 0.13c0.06 0.01 0.14 0.12 0.22 0.31 0.27 0.68 0.27 1.76 0 2.44s-0.5 0.13-0.5-1.22c0-0.85 0.09-1.38 0.22-1.5 0.02-0.02 0.04-0.03 0.06-0.03zm-80.22 0.62c0.49-0.05 1.09 0.44 1.5 1.5 0.33 0.86 0.56 1.65 0.56 1.78 0 0.14-0.65 0.26-1.47 0.26-0.81-0.01-1.46-0.79-1.46-1.79 0-1.1 0.38-1.7 0.87-1.75zm64.41 0.13c0.06-0.03 0.17-0.02 0.25 0.06 0.32 0.33 0.34 1.17 0.06 1.88-0.31 0.78-0.55 0.58-0.59-0.57-0.04-0.77 0.08-1.3 0.28-1.37zm-15.35 0.22c0.07-0.01 0.15 0.01 0.22 0.06 0.54 0.33 1 2.37 1 4.5s-0.46 3.87-1 3.87-0.97-2.03-0.97-4.5c0-2.39 0.28-3.86 0.75-3.93zm-271.59 0.25c0.154-0.01 0.144 1.16 0.031 3.75-0.17 3.88-0.63 5.11-2.219 5.81-2.286 1.01-4.826 7.47-2.937 7.47 0.623 0 1.65-0.49 2.281-1.13 1.428-1.42 2.516 0.87 2.032 4.28-0.232 1.64-0.989 2.27-2.626 2.29-2.523 0.02-5.997 3.89-6.031 6.68-0.056 4.56-4.873 8.68-7.531 6.47-1.102-0.91-1.7-0.92-2.562-0.06-1.371 1.37-2.75 1.48-2.75 0.22-0.001-1.4 2.955-4 4.531-4 1.006 0 1.375-1.2 1.375-4.31 0-4.39 2.911-12.6 4.875-13.82 0.586-0.36 1.045-2.31 1.062-4.31 0.023-2.7 0.678-4.07 2.469-5.37 2.202-1.61 2.335-1.62 1.75-0.1-0.433 1.13-0.247 1.45 0.531 0.97 0.633-0.39 1.125-1.34 1.125-2.12s0.454-1.41 1.032-1.41c0.602 0 0.795 0.84 0.437 1.97-0.351 1.1-0.168 1.94 0.406 1.94 0.562 0 1.466-1.43 2-3.19 0.398-1.31 0.6-2.03 0.719-2.03zm-16.281 0.37c-0.502 0-1.4 0.45-2.625 1.38-1.871 1.41-1.878 1.47 0.187 1.5 1.16 0.01 2.376-0.66 2.688-1.47 0.359-0.94 0.252-1.4-0.25-1.41zm296 1.1c2.67 0.18 5.87 3.95 5.87 8.56 0 3.78-0.2 4.08-2.71 4.06-1.49-0.01-3.23-0.41-3.91-0.84-1.94-1.23-3.23-6.83-2.19-9.57 0.63-1.64 1.73-2.3 2.94-2.21zm-89.16 0.12c-0.05 0.01-0.08 0.03-0.12 0.06-0.31 0.31 0.03 1.24 0.72 2.07 1.76 2.13 2.25 1.87 0.96-0.54-0.52-0.98-1.2-1.65-1.56-1.59zm-13.72 1.13c0.07 0 0.15 0.12 0.22 0.31 0.28 0.68 0.28 1.76 0 2.44-0.27 0.67-0.5 0.13-0.5-1.22 0-0.85 0.09-1.39 0.22-1.5 0.02-0.02 0.04-0.04 0.06-0.03zm112.32 0.68c1.84 0.13 2.92 3.83 1.22 4.91-2.09 1.32-2.82 1.01-2.82-1.13 0-1.08-0.06-2.28-0.15-2.68-0.1-0.41 0.51-0.9 1.37-1.06 0.13-0.03 0.25-0.04 0.38-0.04zm-284.97 0.54c0.634-0.17 1.062 0.58 1.062 2.28 0 1.02 1.288 4.06 2.87 6.75 2.25 3.81 2.73 5.52 2.16 7.68-0.58 2.18-1.39 2.86-3.78 3.1-2.681 0.26-3.142-0.1-4.031-2.97-2.239-7.23-2.361-9.81-0.625-13.66 0.869-1.93 1.709-3.02 2.344-3.18zm275.93 0.5c-0.25-0.02-0.53 0.03-0.78 0.12-2.09 0.8-2.06 2.68 0.1 5.38 1.99 2.49 3.56 2.33 3.97-0.38 0.35-2.36-1.49-5.01-3.29-5.12zm105.63 0c0.1-0.01 0.16 0.1 0.16 0.31 0 0.54-0.45 1.62-0.97 2.43-0.53 0.82-0.94 1.05-0.94 0.5 0-0.54 0.41-1.65 0.94-2.46 0.33-0.51 0.64-0.78 0.81-0.78zm-233.81 2.28c-0.07-0.02-0.13-0.01-0.19 0.03-1.21 0.75-0.16 16.21 1.22 17.87 1.81 2.18 3.05 1.43 2.34-1.44-0.77-3.11-1.39-6.86-2.12-12.81-0.25-2.02-0.78-3.52-1.25-3.65zm231.62 2.72c0.28 0.02 0.41 0.5 0.41 1.5 0 2.37-0.48 2.74-1.5 1.09-0.36-0.59-0.2-1.56 0.41-2.16 0.3-0.3 0.51-0.45 0.68-0.43zm-114.15 0.71h1.47c4.98 0 6.28 2.33 2.81 5-3.16 2.43-3.53 2.39-5.28-1-1.79-3.46-1.99-3.94 1-4zm-140.66 0.97c0.38 0 0.11 0.69-0.56 1.5-0.68 0.81-1.61 1.47-2.13 1.47-0.51 0-0.28-0.66 0.53-1.47 0.82-0.81 1.78-1.5 2.16-1.5zm-26.63 0.1c0.56-0.12 1.63 0.36 3.44 1.4 1.36 0.78 1.81 1.36 1 1.32-2.76-0.15-4.9-0.97-4.9-1.88 0-0.47 0.13-0.78 0.46-0.84zm189.44 0.09c0.88 0.07 1.32 1.85 1.69 5.69 0.51 5.35-0.07 5.89-3.47 3.06-2.71-2.26-2.77-4.06-0.31-7.09 0.9-1.11 1.57-1.7 2.09-1.66zm-169.78 0.94c0.5 0 0.43 0.26-0.47 0.84-0.81 0.53-2.12 0.94-2.93 0.91-0.98-0.04-0.83-0.35 0.46-0.91 1.36-0.58 2.44-0.84 2.94-0.84zm-29.72 0.84c0.41 0 0.72 2.23 0.72 4.94 0 4.31-0.39 5.33-3.19 7.87-1.75 1.6-3.91 2.89-4.78 2.91-1.23 0.02-0.68-1.7 2.47-7.84 2.22-4.33 4.38-7.87 4.78-7.88zm20.91 2.47c3.95 0 6.65 0.35 6.03 0.75s-3.33 0.69-6.03 0.69c-2.71 0-5.44-0.29-6.06-0.69-0.63-0.4 2.1-0.75 6.06-0.75zm217.25 0.69c0.07-0.03 0.17 0.01 0.25 0.09 0.33 0.33 0.35 1.17 0.06 1.88-0.31 0.78-0.55 0.55-0.59-0.6-0.03-0.78 0.08-1.3 0.28-1.37zm-230.53 0.78c0.54 0 0.97 0.2 0.97 0.44 0 0.23-0.43 0.69-0.97 1.03-0.54 0.33-1 0.16-1-0.41s0.46-1.06 1-1.06zm184.69 1c1.34 0.01 7 5.84 7.65 7.91 0.36 1.11 0.13 2.61-0.47 3.34-0.6 0.72-2.16 1.53-3.47 1.78-2.15 0.41-2.47-0.01-3.4-4.38-1.22-5.67-1.34-8.66-0.31-8.65zm-159.5 0.47 0.18 9.12c0.17 8.21-0.08 10.49-0.97 8.35-0.16-0.41-0.05-4.5 0.25-9.1l0.54-8.37zm-12.29 0.5c1.88 0 2.74 0.41 2.32 1.09-0.37 0.59-1.55 0.81-2.6 0.53-1.19-0.31-1.77-0.03-1.53 0.69 0.47 1.42 2.56 1.57 5 0.37 1.37-0.67 1.73-0.55 1.41 0.44-0.63 1.91-6.11 2.2-7.6 0.41-1.72-2.08-0.47-3.53 3-3.53zm161.19 0c1.53 0 1.97 0.67 1.97 2.97 0 3.49-0.07 3.52-2.25 0.97-2.23-2.61-2.13-3.94 0.28-3.94zm3.34 0.18c0.07-0.02 0.14 0.02 0.22 0.1 0.33 0.33 0.35 1.16 0.07 1.87-0.32 0.79-0.52 0.56-0.57-0.59-0.03-0.78 0.08-1.3 0.28-1.38zm-155.62 0.32c0.59-0.22 0.81 1.32 0.81 5.22 0 3.35-0.18 6.09-0.4 6.09-1.06 0-1.69-10.1-0.69-11.09 0.1-0.1 0.2-0.19 0.28-0.22zm60.03 0.59c0.13 0.02 0.37 0.18 0.72 0.5 0.67 0.62 1.01 2.57 0.78 4.44-0.33 2.7-0.43 2.85-0.56 0.72-0.09-1.45-0.43-3.45-0.78-4.44-0.31-0.86-0.38-1.26-0.16-1.22zm-53.81 0.25c0.24-0.11 0.35 1.4 0.4 4.81 0.06 3.66-0.06 6.63-0.28 6.63-0.82 0-1.2-7.47-0.53-10.28 0.17-0.7 0.3-1.11 0.41-1.16zm4.84 0.63c0.24 0 0.73 0.46 1.06 1 0.34 0.54 0.14 0.97-0.43 0.97-0.58 0-1.07-0.43-1.07-0.97s0.2-1 0.44-1zm-57.4 1c-1.12 0-2.04 0.42-2.04 0.97 0 0.54 0.63 1 1.41 1s1.7-0.46 2.03-1c0.34-0.55-0.29-0.97-1.4-0.97zm206.03 0.53c0.06 0 0.11 0.22 0.19 0.68 0.22 1.5 0.23 3.7 0 4.91-0.24 1.21-0.45 0.02-0.44-2.69 0-1.86 0.12-2.91 0.25-2.9zm105.84 0.31c2.28-0.05 5.32 0.86 7.35 2.59 1.57 1.36 3.75 2.44 4.81 2.44 1.46 0 1.62 0.29 0.75 1.16s-0.75 1.47 0.53 2.4c0.93 0.68 1.37 1.57 0.97 1.97-0.41 0.41-0.75 0.2-0.75-0.43 0-0.79-1.69-1.05-5.38-0.79-4.97 0.36-5.65 0.17-8.37-2.62-1.63-1.67-2.97-3.83-2.97-4.81 0-1.25 1.29-1.87 3.06-1.91zm-370.47 1.13c0.81 0 1.47 0.13 1.47 0.34 0 0.2-0.66 0.95-1.47 1.62-1.21 1.01-1.5 0.94-1.5-0.37 0-0.88 0.69-1.59 1.5-1.59zm181.25 0c0.03-0.02 0.09 0 0.13 0 0.85 0 2.18 2.45 4.5 8.24 1.78 4.48 1.54 5.29-0.85 2.66-1.84-2.04-4.69-10.39-3.78-10.9zm29.16 0c0.21 0 0.66 0.65 0.97 1.46 0.31 0.82 0.12 1.47-0.41 1.47-0.52 0-0.97-0.65-0.97-1.47 0-0.81 0.2-1.46 0.41-1.46zm-121.85 0.96c0.06-0.04 0.12 0.2 0.19 0.75 0.22 1.76 0.22 4.62 0 6.38s-0.37 0.33-0.37-3.19c0-2.42 0.06-3.85 0.18-3.94zm24.6 0c0.05-0.04 0.12 0.2 0.19 0.75 0.21 1.76 0.21 4.62 0 6.38-0.22 1.76-0.38 0.33-0.38-3.19 0-2.42 0.07-3.85 0.19-3.94zm-103.41 0.07c-0.28 0.02-0.4 0.29-0.4 0.78 0 0.46 1 1.32 2.21 1.9 3.2 1.54 3.34 1.42 0.97-0.78-1.42-1.33-2.31-1.94-2.78-1.9zm353.81 1.12c0.53 0.03 1.17 0.39 2.19 1.06 1.32 0.86 2.62 2.48 2.91 3.6 0.48 1.85 0.08 2.03-4.38 2.03-4.61 0-4.81-0.13-4.18-2.22 0.36-1.22 1.24-2.83 1.96-3.59 0.57-0.6 0.98-0.9 1.5-0.88zm-269.15 0.09c0.59-0.14 1.55 1.44 1.65 3.47 0.12 2.32 0.16 2.35 0.54 0.41 0.66-3.46 2.25-2.57 2.25 1.25 0 1.89 0.48 3.44 1.06 3.44 0.61 0 0.79-0.93 0.44-2.22l-0.6-2.22 2.03 2.34c1.11 1.28 2 3.53 2 5.03 0 2.45-0.39 2.82-3.68 3.13-4.99 0.47-11.1-0.13-11.1-1.06 0-0.42 1.12-2.93 2.47-5.6 1.35-2.66 2.47-5.61 2.47-6.59 0-0.87 0.2-1.31 0.47-1.38zm-7.81 0.29c0.05-0.04 0.11 0.19 0.18 0.65 0.23 1.49 0.23 3.92 0 5.41-0.22 1.49-0.4 0.26-0.4-2.72 0-2.05 0.09-3.27 0.22-3.34zm-100 0.06c2.187-0.05 5.444 0.57 10.254 1.84 5.5 1.45 11.57 3.47 13.47 4.47 1.89 1 4.32 2.15 5.4 2.56 1.44 0.56 0.69 0.85-2.87 1.1-2.68 0.18-5.88-0.21-7.13-0.88-1.24-0.66-2.52-0.94-2.84-0.62-1.42 1.42 4.54 2.94 13.47 3.44 9.47 0.52 11.97 1.39 7.5 2.59-1.22 0.32-2.65 0.51-3.19 0.47-3.7-0.32-19.96-3-21.16-3.5-0.81-0.34-2.58-0.78-3.94-1-1.35-0.22-2.86-0.84-3.37-1.35-0.51-0.5-1.739-0.9-2.688-0.9-3.441 0-6.718-2.24-6.718-4.57 0-2.42 1.001-3.59 3.812-3.65zm202.65 0.34c0.49 0 1.21 2.32 1.6 5.16 0.75 5.6 1.97 8.62 3.47 8.62 1.41 0 1.08-3.17-0.57-5.34-3.13-4.14-0.78-4.76 4.07-1.06 3.35 2.56 4.94 3.01 5.5 1.62 0.4-1.01 13.59 0.96 13.59 2.03 0 0.43-1.48 0.78-3.25 0.78-3.35 0-5.96 1.46-10 5.5-3.39 3.39-6.77 3.05-9.81-0.93-3.71-4.86-6.95-16.38-4.6-16.38zm30 0.03c4.33-0.05 13.56 2.36 18.03 5.25 3.57 2.31 4.28 4.05 1.28 3.1-1.5-0.48-2.04-0.05-2.53 1.9-0.66 2.67-0.59 2.67-10.03 1.82-4.02-0.37-5.6-2.23-3.18-3.72 1.53-0.95 1.14-4.44-0.5-4.44-0.82 0-1.47-0.46-1.47-1s-0.89-0.97-1.97-0.97-1.97-0.46-1.97-1c0-0.65 0.9-0.92 2.34-0.94zm-240.22 1.41c1.838-0.22 2.882 1.54 2.594 4.56-0.282 2.95-0.699 3.39-3.438 3.66-3.744 0.36-5.021-1.29-2.875-3.66 0.865-0.95 1.563-2.2 1.563-2.78-0.001-0.57 0.587-1.28 1.312-1.56 0.294-0.11 0.581-0.19 0.844-0.22zm377.57 0.53c0.54 0 0.96 0.4 0.96 0.91s-0.42 1.23-0.96 1.56-1-0.09-1-0.94c0-0.84 0.46-1.53 1-1.53zm-393.32 0.06c0.493-0.09 0.812 0.32 0.812 1.28 0 0.75-0.856 1.61-1.906 1.88-1.657 0.43-1.758 0.27-0.75-1.34 0.682-1.1 1.35-1.72 1.844-1.82zm423.04 0c0.36-0.03 0.81 0 1.34 0.1 1.54 0.3 1.54 0.47 0.16 1.62-1.11 0.92-1.74 0.95-2.22 0.16-0.68-1.09-0.37-1.77 0.72-1.88zm-369.85 0.04c-0.34-0.03-0.1 0.24 0.56 0.96 0.7 0.76 2.68 1.93 4.41 2.57 3.58 1.31 6.28 1.62 5.28 0.62-0.37-0.37-2.09-1.2-3.84-1.84s-4.11-1.49-5.19-1.91c-0.62-0.24-1.01-0.39-1.22-0.4zm229.44 0.12c0.02-0.02 0.01-0.01 0.03 0 0.05 0.04 0.13 0.23 0.19 0.53 0.23 1.22 0.23 3.19 0 4.41-0.24 1.21-0.44 0.21-0.44-2.22 0-1.6 0.1-2.58 0.22-2.72zm-32.06 0.69c0.2-0.02 0.47 0.09 0.71 0.34 0.33 0.33 0.39 1.13 0.16 1.81-0.33 1-0.57 1.01-1.19 0-0.61-0.99-0.3-2.09 0.32-2.15zm-3.91 0.06c0.57 0 1.06 0.46 1.06 1s-0.2 0.97-0.44 0.97c-0.23 0-0.69-0.43-1.03-0.97-0.33-0.54-0.16-1 0.41-1zm-94.97 0.47c0.08-0.07 0.18 0.03 0.28 0.28 0.28 0.68 0.28 1.79 0 2.47-0.27 0.68-0.5 0.1-0.5-1.25 0-0.85 0.09-1.39 0.22-1.5zm-38.37 0.72c0.06-0.03 0.16 0.01 0.25 0.09 0.32 0.33 0.34 1.17 0.06 1.88-0.32 0.78-0.55 0.55-0.59-0.6-0.04-0.78 0.07-1.3 0.28-1.37zm130.56 0.9c0.34-0.01 0.71 0.05 1.06 0.19 0.79 0.32 0.58 0.55-0.56 0.59-1.04 0.05-1.64-0.17-1.31-0.5 0.16-0.16 0.47-0.26 0.81-0.28zm-178.53 1.85c-0.51 0.04-0.64 0.29-0.19 0.75 0.4 0.4 2.16 1.27 3.88 1.9 4.89 1.81 6.39 1.4 2.59-0.68-2.31-1.27-5.17-2.07-6.28-1.97zm82.4 0.19c0.07-0.03 0.17 0.01 0.25 0.09 0.33 0.33 0.35 1.16 0.07 1.87-0.32 0.79-0.55 0.59-0.6-0.56-0.03-0.78 0.08-1.33 0.28-1.4zm-125.37 1.06c0.41 0.01 0.97 0.15 1.687 0.53 1 0.52 2.929 1.44 4.284 2l2.47 1.03-2.972 0.03c-1.624 0.02-3.77-0.62-4.813-1.41-1.431-1.08-1.687-1.97-1.031-2.15 0.098-0.03 0.238-0.04 0.375-0.03zm384.9 1.62c2.36-0.02 4.34-0.02 5.44 0.03 0.68 0.04 1.25 0.95 1.25 2.03 0 1.86-0.66 1.97-11.84 1.97-9.76 0-11.96-0.24-12.44-1.5-0.32-0.83-0.37-1.72-0.15-1.93 0.24-0.24 10.67-0.54 17.74-0.6zm-290.46 1.06c0.38 0 1.5 0.62 2.5 1.35 1.25 0.92 1.47 1.54 0.68 2.03-0.62 0.39-1.15 1.79-1.15 3.12 0 1.7-0.77 2.71-2.53 3.38-3.27 1.24-3.38 1.22-3.38-0.5 0-2.03 3.04-9.38 3.88-9.38zm-100.28 0.1c0.973 0.03 0.829 0.35-0.469 0.9-2.704 1.17-4.267 1.17-2.468 0 0.811-0.52 2.125-0.93 2.937-0.9zm89.845 0.31c2.54 0.03 4.59 0.77 4.59 2.31 0 1.12-0.68 1.32-2.87 0.88-1.66-0.33-4.41 0.05-6.38 0.87-4.85 2.03-5.77 1.81-4-0.9 1.36-2.07 5.39-3.19 8.66-3.16zm42.28 0.59c0.89 0 2.08 0.89 2.66 1.97 0.8 1.51 0.75 1.97-0.25 1.97-0.73 0-1.85-0.54-2.5-1.18-0.92-0.92-1.19-0.59-1.19 1.43 0 1.43-0.46 2.88-1.06 3.25-0.74 0.46-0.91-0.07-0.47-1.65 0.62-2.23 0.57-2.24-1.44 0.34-2.02 2.61-2.44 2.72-11.13 2.69-10.28-0.04-13-1.01-11.4-4 0.57-1.07 1.47-1.63 2.03-1.28 0.56 0.34 4.95 0.6 9.75 0.56 7.69-0.07 8.64 0.08 8.09 1.5-0.41 1.07-0.2 1.35 0.57 0.87 0.63-0.39 1.12-1.27 1.12-1.97 0-1.71 3.24-4.5 5.22-4.5zm103.91 1.26c0.96-0.06 1.81 0.05 2.43 0.4 1.44 0.8 1.3 1.09-0.93 2.28-2.03 1.09-2.91 1.13-4.41 0.19-1.67-1.04-1.86-0.92-1.66 1.03 0.17 1.61-0.36 2.31-1.9 2.53-1.17 0.17-2.35-0.09-2.63-0.53-1.34-2.16 4.92-5.66 9.1-5.9zm69.34 0.18c0.91-0.05 1.56 0.09 1.56 0.5 0 0.55-0.4 1-0.87 1-0.48 0-2.36 0.26-4.19 0.56-2.27 0.39-2.85 0.26-1.84-0.37 1.53-0.95 3.82-1.59 5.34-1.69zm-282.66 0.66c0.35-0.02 0.74 0.04 1.1 0.19 0.78 0.31 0.55 0.51-0.6 0.56-1.03 0.04-1.6-0.14-1.28-0.47 0.17-0.16 0.44-0.27 0.78-0.28zm7.07 0.97c2.03-0.07 3.68 0.33 3.68 0.87 0 1.09-0.17 1.09-4.43 0-2.94-0.74-2.93-0.76 0.75-0.87zm316.06 0.09c-1.93 0.05-2.53 0.41-2.53 1.31 0 1.2 1 1.49 4.62 1.25 6.22-0.4 6.44-2.23 0.31-2.53-0.96-0.04-1.76-0.05-2.4-0.03zm-296.22 0.22c1.97 0.01 3.28 0.13 3.12 0.38-0.3 0.49-4.62 0.99-9.62 1.09s-8.91-0.02-8.66-0.25c0.63-0.55 7.83-1.08 13-1.19 0.78-0.02 1.5-0.03 2.16-0.03zm223.84 0.69c-0.8 0-1.58 0.04-2.18 0.15-1.22 0.24-0.25 0.41 2.18 0.41 2.44 0 3.44-0.17 2.22-0.41-0.61-0.11-1.41-0.15-2.22-0.15zm-268.53 0.84c-5.246 0-8.874 0.42-8.874 1-0.001 0.58 3.628 0.97 8.874 0.97 5.247 0 8.848-0.39 8.848-0.97s-3.601-1-8.848-1zm298.53 1c-2.68 0-3.08 0.92-1.25 2.75 1.43 1.42 12.57 1.59 12.57 0.19 0-0.54-1.98-0.97-4.41-0.97s-4.44-0.46-4.44-1-1.11-0.97-2.47-0.97zm-39.81 0.13c-0.44 0-0.91 0.05-1.25 0.18-0.68 0.28-0.1 0.5 1.25 0.5s1.9-0.22 1.22-0.5c-0.34-0.13-0.77-0.18-1.22-0.18zm-99.5 0.28c1.17-0.05 3.18 0.42 4.78 1.09 3.26 1.36 3.29 1.43 1.75 3.78-0.87 1.33-2.24 2.65-3 2.94-1.94 0.74-2.83-1.12-1.37-2.87 1.84-2.22 0.3-2.88-2.47-1.07-2.29 1.5-2.4 1.5-1.81-0.03 0.42-1.1 0.27-1.38-0.5-0.9-0.64 0.39-1.19 0.21-1.19-0.38 0-0.77-0.56-0.79-1.97-0.03-1.3 0.69-1.97 0.72-1.97 0.06 0-0.9 1-1.25 7.31-2.53 0.13-0.03 0.27-0.06 0.44-0.06zm-159.22 1.56c-1.623 0-2.968 0.32-2.968 0.75s1.345 0.91 2.968 1.03c1.624 0.12 2.938-0.23 2.938-0.78s-1.314-1-2.938-1zm266.72 0c-2.08 0.06-5.36 0.5-6.53 1.03-1.32 0.6-0.37 0.69 2.94 0.28 2.7-0.33 5.12-0.77 5.34-0.97 0.32-0.28-0.5-0.38-1.75-0.34zm-202.69 0.12c-0.34 0.02-0.65 0.09-0.81 0.26-0.33 0.32 0.28 0.54 1.31 0.5 1.15-0.05 1.35-0.28 0.57-0.6-0.36-0.14-0.72-0.17-1.07-0.16zm-11.4 1.85c-1.9 0-3.44 0.43-3.44 0.97s1.54 0.97 3.44 0.97c1.89 0 3.44-0.43 3.44-0.97s-1.55-0.97-3.44-0.97z"/>
						 <rect id="rect8" height="10.014" width="420.03" y="430.82" x="63.422"/>
						 <path id="path10" d="m543.54 276.94a276.23 276.23 0 1 1 -552.47 0 276.23 276.23 0 1 1 552.47 0z" transform="matrix(.95831 0 0 .95831 17.669 8.4373)" stroke="#000" stroke-linecap="round" stroke-miterlimit="2.41" stroke-width="9.7" fill="none"/>
						 <path id="path12" d="m207.05 63.887c0 1.932 0 3.667-0.03 5.205-0.02 1.537-0.08 2.752-0.18 3.646-0.07 0.612-0.19 1.122-0.35 1.532-0.17 0.409-0.45 0.66-0.85 0.753-0.19 0.043-0.41 0.081-0.66 0.114s-0.53 0.05-0.84 0.052c-0.24 0.001-0.42 0.03-0.52 0.088s-0.15 0.14-0.14 0.244c0 0.284 0.28 0.423 0.83 0.416 0.42-0.004 0.88-0.017 1.38-0.042 0.51-0.024 1-0.038 1.48-0.041 0.51-0.02 0.97-0.032 1.39-0.037 0.42-0.004 0.75-0.006 0.98-0.005 0.33 0 0.77 0.011 1.33 0.031 0.56 0.021 1.15 0.052 1.79 0.094 0.62 0.023 1.19 0.049 1.72 0.078 0.53 0.028 0.92 0.044 1.19 0.047 3.8-0.1 6.61-1.054 8.41-2.862s2.7-3.874 2.68-6.196c-0.1-2.428-0.94-4.386-2.5-5.875-1.57-1.488-3.26-2.521-5.06-3.1 1.18-0.89 2.17-1.905 2.98-3.044 0.8-1.139 1.22-2.548 1.26-4.227 0.1-1.224-0.44-2.538-1.61-3.943-1.17-1.404-3.58-2.168-7.24-2.29-0.7 0.005-1.47 0.026-2.3 0.062-0.84 0.037-1.76 0.057-2.77 0.063-0.46-0.006-1.23-0.026-2.31-0.063-1.08-0.036-2.2-0.057-3.34-0.062-0.31-0.003-0.54 0.023-0.69 0.078-0.15 0.054-0.23 0.153-0.23 0.296s0.06 0.241 0.18 0.296c0.13 0.055 0.3 0.08 0.53 0.078 0.3 0 0.6 0.01 0.9 0.031s0.54 0.052 0.72 0.094c0.67 0.137 1.13 0.392 1.38 0.763 0.24 0.371 0.38 0.906 0.41 1.605 0.04 0.554 0.06 1.399 0.07 2.534 0.01 1.136 0.01 3.228 0.01 6.275v7.312zm4.99-16.869c-0.01-0.224 0.02-0.389 0.07-0.493 0.06-0.105 0.16-0.176 0.3-0.213 0.2-0.04 0.41-0.064 0.62-0.073 0.22-0.009 0.47-0.012 0.75-0.01 1.78 0.094 3.09 0.819 3.94 2.176 0.84 1.356 1.26 2.778 1.25 4.264 0 1.02-0.15 1.899-0.44 2.638-0.3 0.74-0.72 1.328-1.26 1.766-0.35 0.306-0.76 0.515-1.25 0.629-0.48 0.113-1.06 0.167-1.74 0.161-0.48 0-0.87-0.011-1.2-0.032-0.32-0.02-0.57-0.051-0.75-0.093-0.09-0.016-0.16-0.056-0.21-0.12-0.05-0.063-0.08-0.175-0.08-0.337v-10.263zm9.51 21.855c-0.09 2.113-0.7 3.539-1.81 4.28-1.12 0.741-2.19 1.087-3.22 1.039-0.47 0.008-0.96-0.018-1.45-0.078-0.5-0.06-1.02-0.2-1.58-0.421-0.64-0.231-1.05-0.62-1.23-1.168-0.17-0.548-0.25-1.488-0.22-2.821v-9.847c0-0.201 0.08-0.298 0.25-0.291 0.3-0.001 0.58 0.001 0.84 0.005 0.27 0.005 0.58 0.017 0.94 0.037 0.8 0.039 1.47 0.137 2.01 0.296 0.53 0.158 1.02 0.392 1.44 0.701 1.55 1.147 2.62 2.478 3.2 3.994s0.86 2.94 0.83 4.274zm14.88-4.986c0 2.032-0.01 3.827-0.03 5.386s-0.08 2.783-0.18 3.672c-0.05 0.604-0.17 1.08-0.34 1.429-0.17 0.348-0.46 0.565-0.87 0.649-0.18 0.043-0.4 0.081-0.65 0.114s-0.53 0.05-0.84 0.052c-0.25 0.001-0.42 0.03-0.52 0.088s-0.15 0.14-0.15 0.244c0.01 0.284 0.29 0.423 0.84 0.416 0.88-0.005 1.84-0.026 2.88-0.062 1.03-0.037 1.82-0.058 2.35-0.063 0.59 0.005 1.47 0.026 2.63 0.063 1.17 0.036 2.45 0.057 3.85 0.062 0.24 0.001 0.42-0.032 0.57-0.099 0.14-0.066 0.22-0.172 0.22-0.317 0.01-0.214-0.21-0.325-0.66-0.332-0.33-0.002-0.69-0.019-1.08-0.052s-0.74-0.071-1.04-0.114c-0.61-0.088-1.03-0.307-1.25-0.66-0.23-0.352-0.37-0.811-0.41-1.376-0.08-0.909-0.13-2.145-0.15-3.708-0.02-1.564-0.02-3.361-0.02-5.392v-7.312c0-3.047 0-5.139 0.01-6.275 0.01-1.135 0.03-1.98 0.07-2.534 0.03-0.722 0.16-1.273 0.38-1.652s0.61-0.618 1.16-0.716c0.24-0.042 0.46-0.073 0.65-0.094 0.2-0.021 0.39-0.031 0.6-0.031 0.21 0.003 0.37-0.024 0.48-0.083 0.12-0.059 0.18-0.17 0.18-0.333 0-0.123-0.08-0.209-0.23-0.259-0.16-0.05-0.37-0.075-0.64-0.073-0.84 0.005-1.75 0.026-2.74 0.062-0.99 0.037-1.76 0.057-2.33 0.063-0.65-0.006-1.51-0.026-2.56-0.063-1.05-0.036-2-0.057-2.84-0.062-0.33-0.002-0.58 0.022-0.75 0.073-0.17 0.05-0.25 0.136-0.25 0.259 0 0.163 0.06 0.274 0.18 0.333 0.11 0.059 0.28 0.086 0.49 0.083 0.25-0.001 0.5 0.011 0.76 0.036s0.5 0.069 0.73 0.13c0.46 0.1 0.79 0.337 1.02 0.712 0.22 0.374 0.36 0.913 0.39 1.615 0.04 0.554 0.07 1.399 0.08 2.534 0.01 1.136 0.01 3.228 0.01 6.275v7.312zm18.74 0c0.01 1.932 0 3.667-0.02 5.205-0.02 1.537-0.08 2.752-0.18 3.646-0.07 0.612-0.19 1.122-0.36 1.532-0.16 0.409-0.45 0.66-0.85 0.753-0.19 0.043-0.4 0.081-0.65 0.114s-0.53 0.05-0.84 0.052c-0.25 0.001-0.42 0.03-0.52 0.088s-0.15 0.14-0.15 0.244c0.01 0.284 0.28 0.423 0.83 0.416 0.89-0.005 1.85-0.026 2.88-0.062 1.04-0.037 1.82-0.058 2.36-0.063 0.57 0.005 1.43 0.026 2.59 0.063 1.17 0.036 2.45 0.057 3.85 0.062 0.23 0.001 0.42-0.032 0.56-0.099 0.15-0.066 0.22-0.172 0.23-0.317 0-0.214-0.22-0.325-0.67-0.332-0.32-0.002-0.68-0.019-1.07-0.052-0.4-0.033-0.74-0.071-1.05-0.114-0.6-0.094-1.01-0.343-1.23-0.748-0.21-0.405-0.34-0.904-0.39-1.496-0.1-0.913-0.16-2.141-0.18-3.682-0.02-1.542-0.03-3.278-0.03-5.21v-16.62c0.01-0.45 0.12-0.713 0.34-0.789 0.19-0.062 0.43-0.105 0.71-0.13 0.29-0.025 0.59-0.037 0.91-0.036 0.5-0.019 1.12 0.08 1.87 0.296 0.75 0.215 1.51 0.657 2.28 1.324 1.12 1.083 1.82 2.21 2.1 3.381s0.4 2.122 0.35 2.852c-0.08 2.139-0.72 3.812-1.91 5.017-1.18 1.205-2.4 1.818-3.65 1.838-0.43-0.001-0.74 0.033-0.91 0.104-0.18 0.071-0.26 0.189-0.26 0.353 0.01 0.141 0.07 0.234 0.17 0.281 0.11 0.047 0.22 0.078 0.33 0.093 0.12 0.02 0.26 0.032 0.44 0.037 0.17 0.004 0.32 0.006 0.43 0.005 3.01-0.05 5.45-0.989 7.33-2.815 1.87-1.827 2.84-4.24 2.9-7.24-0.03-1.115-0.27-2.105-0.7-2.971-0.44-0.866-0.9-1.524-1.38-1.974-0.29-0.371-1.01-0.844-2.17-1.418-1.15-0.573-3.01-0.89-5.56-0.95-0.98 0.005-2.01 0.026-3.09 0.062-1.08 0.037-2.06 0.057-2.94 0.063-0.62-0.006-1.48-0.026-2.6-0.063-1.11-0.036-2.24-0.057-3.38-0.062-0.31-0.003-0.54 0.023-0.69 0.078-0.15 0.054-0.22 0.153-0.22 0.296s0.06 0.241 0.18 0.296 0.29 0.08 0.52 0.078c0.3 0 0.61 0.01 0.91 0.031s0.54 0.052 0.71 0.094c0.67 0.137 1.13 0.392 1.38 0.763s0.39 0.906 0.41 1.605c0.04 0.554 0.06 1.399 0.07 2.534 0.01 1.136 0.02 3.228 0.01 6.275v7.312zm24.61 7.895c-0.08 0.739-0.25 1.432-0.49 2.077-0.24 0.646-0.64 1.048-1.21 1.205-0.3 0.06-0.55 0.096-0.73 0.109-0.19 0.013-0.36 0.019-0.52 0.016-0.21-0.001-0.37 0.022-0.48 0.068-0.12 0.045-0.18 0.12-0.18 0.223 0 0.183 0.08 0.305 0.22 0.369 0.14 0.063 0.31 0.092 0.53 0.088 0.7-0.005 1.45-0.026 2.26-0.062 0.8-0.037 1.42-0.058 1.85-0.063 0.4 0.005 1 0.026 1.81 0.063 0.8 0.036 1.66 0.057 2.55 0.062 0.32 0.004 0.56-0.025 0.74-0.088 0.17-0.064 0.26-0.186 0.26-0.369 0-0.103-0.07-0.178-0.19-0.223-0.12-0.046-0.26-0.069-0.43-0.068-0.21 0.002-0.46-0.012-0.75-0.042-0.29-0.029-0.62-0.084-1-0.166-0.36-0.078-0.65-0.222-0.89-0.431-0.23-0.208-0.35-0.508-0.35-0.898 0-0.326 0.01-0.641 0.03-0.946 0.02-0.304 0.05-0.64 0.09-1.007l2.16-16.537h0.17c0.79 1.693 1.65 3.511 2.56 5.453 0.92 1.943 1.51 3.2 1.76 3.771 0.2 0.447 0.61 1.293 1.24 2.538 0.63 1.244 1.28 2.53 1.97 3.858 0.68 1.327 1.2 2.339 1.57 3.036 0.33 0.632 0.6 1.134 0.83 1.506s0.44 0.563 0.62 0.571c0.17 0.025 0.35-0.118 0.55-0.431 0.2-0.312 0.53-0.944 0.99-1.895l9.06-18.864h0.16l2.5 18.282c0.08 0.578 0.09 1.011 0.05 1.298-0.05 0.288-0.13 0.45-0.26 0.489-0.15 0.06-0.26 0.126-0.34 0.197s-0.12 0.157-0.12 0.26c-0.01 0.123 0.07 0.219 0.25 0.29 0.17 0.071 0.49 0.127 0.96 0.167 0.6 0.042 1.5 0.082 2.69 0.12 1.19 0.037 2.34 0.068 3.46 0.092s1.88 0.036 2.28 0.037c0.3 0.002 0.55-0.033 0.76-0.104 0.2-0.071 0.31-0.189 0.32-0.353 0-0.121-0.07-0.201-0.19-0.239-0.13-0.038-0.28-0.055-0.47-0.052-0.27 0.006-0.62-0.016-1.04-0.067-0.43-0.052-0.94-0.168-1.54-0.348-0.61-0.175-1.06-0.594-1.35-1.257s-0.52-1.643-0.69-2.94l-3.78-25.678c-0.12-0.866-0.37-1.295-0.74-1.288-0.19 0-0.34 0.083-0.48 0.249-0.13 0.166-0.28 0.416-0.44 0.748l-11.3 23.725-11.34-23.434c-0.27-0.526-0.48-0.876-0.64-1.049-0.17-0.173-0.33-0.253-0.49-0.239-0.34 0.007-0.57 0.367-0.7 1.08l-4.12 27.091z"/>
						 <path id="path14" d="m162.68 489.86c-0.34 0.57-0.72 1.09-1.16 1.53-0.43 0.45-0.9 0.64-1.43 0.56-0.27-0.06-0.49-0.11-0.64-0.17-0.16-0.06-0.3-0.11-0.43-0.17-0.18-0.08-0.32-0.12-0.43-0.12-0.11-0.01-0.19 0.03-0.23 0.12-0.06 0.15-0.04 0.28 0.05 0.38s0.23 0.19 0.41 0.27c0.58 0.24 1.21 0.5 1.88 0.76 0.68 0.26 1.2 0.46 1.56 0.61 0.33 0.15 0.82 0.39 1.47 0.71s1.35 0.64 2.09 0.97c0.26 0.12 0.47 0.18 0.64 0.19 0.16 0.01 0.28-0.06 0.35-0.21 0.03-0.09 0.01-0.17-0.08-0.25-0.08-0.08-0.19-0.15-0.33-0.21-0.18-0.08-0.38-0.18-0.61-0.31s-0.48-0.29-0.76-0.49c-0.27-0.2-0.46-0.42-0.58-0.68-0.11-0.26-0.11-0.55 0.03-0.87 0.12-0.27 0.24-0.53 0.37-0.77 0.12-0.25 0.27-0.51 0.44-0.8l7.74-12.88 0.14 0.06c0.04 1.68 0.09 3.49 0.15 5.43 0.06 1.93 0.09 3.18 0.09 3.74 0.01 0.44 0.04 1.29 0.11 2.55 0.07 1.25 0.15 2.55 0.24 3.89 0.09 1.35 0.15 2.37 0.2 3.08 0.05 0.64 0.1 1.15 0.15 1.54 0.06 0.39 0.16 0.63 0.31 0.7 0.13 0.08 0.33 0.03 0.61-0.16 0.27-0.19 0.77-0.59 1.49-1.21l14.29-12.32 0.13 0.06-4.53 16c-0.14 0.51-0.28 0.87-0.42 1.09-0.14 0.23-0.27 0.33-0.39 0.31-0.14 0-0.26 0.01-0.35 0.05-0.09 0.03-0.16 0.08-0.19 0.17-0.06 0.09-0.02 0.2 0.09 0.32 0.12 0.13 0.37 0.29 0.74 0.49 0.48 0.25 1.21 0.61 2.18 1.07s1.91 0.9 2.83 1.32c0.91 0.43 1.54 0.71 1.87 0.85 0.24 0.11 0.46 0.18 0.66 0.19 0.2 0.02 0.33-0.04 0.39-0.17 0.04-0.11 0.02-0.19-0.07-0.27s-0.21-0.15-0.37-0.21c-0.22-0.1-0.5-0.24-0.83-0.43-0.34-0.2-0.72-0.48-1.15-0.85-0.44-0.36-0.66-0.87-0.66-1.52s0.16-1.54 0.49-2.68l6.13-22.57c0.21-0.77 0.16-1.21-0.15-1.34-0.15-0.06-0.31-0.05-0.48 0.04s-0.39 0.24-0.64 0.46l-17.89 15.53-0.92-23.45c-0.03-0.53-0.08-0.9-0.15-1.1s-0.18-0.33-0.31-0.37c-0.29-0.12-0.61 0.09-0.98 0.64l-13.16 20.9zm39.96 8.38c-0.48 1.67-0.93 3.17-1.33 4.49-0.41 1.33-0.77 2.36-1.08 3.11-0.22 0.51-0.45 0.93-0.69 1.24-0.25 0.31-0.56 0.46-0.93 0.44-0.17-0.01-0.37-0.04-0.6-0.07-0.22-0.04-0.47-0.09-0.74-0.17-0.21-0.06-0.37-0.08-0.47-0.05-0.1 0.02-0.16 0.08-0.19 0.17-0.06 0.25 0.14 0.44 0.62 0.57 0.37 0.1 0.77 0.21 1.21 0.31 0.44 0.11 0.87 0.22 1.29 0.34 0.44 0.11 0.85 0.22 1.21 0.32s0.65 0.18 0.85 0.24c0.53 0.16 1.09 0.33 1.69 0.52 0.59 0.2 1.26 0.42 2.02 0.68 0.76 0.25 1.65 0.53 2.66 0.85s2.19 0.68 3.53 1.07c0.65 0.22 1.13 0.31 1.42 0.29s0.56-0.24 0.79-0.66c0.22-0.4 0.52-1.02 0.87-1.86 0.36-0.85 0.61-1.51 0.76-1.99 0.06-0.18 0.09-0.34 0.1-0.47s-0.06-0.22-0.2-0.26c-0.12-0.04-0.22-0.02-0.3 0.04-0.08 0.07-0.16 0.2-0.25 0.38-0.33 0.7-0.68 1.22-1.05 1.56-0.38 0.35-0.82 0.56-1.34 0.63-0.55 0.07-1.15 0.03-1.8-0.11s-1.22-0.29-1.71-0.44c-1.79-0.49-2.9-1.03-3.34-1.6-0.43-0.58-0.46-1.47-0.09-2.68 0.16-0.62 0.42-1.52 0.78-2.72 0.35-1.2 0.64-2.15 0.84-2.85l0.83-2.84c0.03-0.11 0.07-0.2 0.12-0.25 0.05-0.06 0.11-0.07 0.2-0.05 0.55 0.16 1.42 0.42 2.61 0.79 1.2 0.37 2.02 0.64 2.47 0.81 0.63 0.26 1.06 0.56 1.29 0.9s0.34 0.7 0.31 1.09c-0.02 0.25-0.05 0.49-0.1 0.71-0.05 0.23-0.1 0.44-0.13 0.62-0.03 0.09-0.03 0.18 0 0.25 0.03 0.08 0.1 0.13 0.23 0.17 0.15 0.03 0.27-0.02 0.35-0.15 0.07-0.14 0.13-0.28 0.17-0.44 0.05-0.16 0.17-0.5 0.36-1.01 0.18-0.51 0.35-0.96 0.48-1.36 0.34-0.87 0.59-1.49 0.76-1.86 0.17-0.36 0.27-0.59 0.3-0.68 0.03-0.1 0.03-0.19-0.01-0.24-0.03-0.06-0.09-0.1-0.16-0.12-0.09-0.02-0.19-0.01-0.3 0.05s-0.25 0.14-0.41 0.25c-0.21 0.13-0.47 0.19-0.77 0.19-0.31-0.01-0.68-0.06-1.11-0.15-0.33-0.07-0.89-0.22-1.7-0.44-0.81-0.23-1.62-0.46-2.42-0.69s-1.35-0.39-1.66-0.48c-0.1-0.03-0.16-0.08-0.18-0.16-0.01-0.08 0.01-0.18 0.04-0.31l2.66-9.09c0.06-0.25 0.18-0.35 0.35-0.29 0.28 0.08 0.78 0.24 1.51 0.46 0.72 0.23 1.43 0.45 2.14 0.69 0.71 0.23 1.18 0.39 1.42 0.48 0.84 0.36 1.38 0.7 1.64 1.01s0.39 0.64 0.39 0.99c0.02 0.25 0.01 0.51-0.03 0.77-0.05 0.25-0.09 0.45-0.13 0.59-0.05 0.16-0.07 0.29-0.04 0.39 0.02 0.1 0.09 0.17 0.21 0.2 0.13 0.04 0.23 0.02 0.3-0.05 0.08-0.07 0.14-0.15 0.18-0.24 0.11-0.25 0.27-0.64 0.46-1.18 0.19-0.53 0.33-0.91 0.41-1.14 0.29-0.78 0.52-1.33 0.68-1.64 0.16-0.3 0.25-0.51 0.29-0.61 0.03-0.09 0.04-0.17 0.03-0.24-0.02-0.07-0.06-0.12-0.15-0.15-0.09-0.02-0.2-0.03-0.31-0.02h-0.31c-0.16-0.01-0.38-0.03-0.65-0.07-0.28-0.05-0.6-0.1-0.96-0.17-0.31-0.07-1.1-0.3-2.38-0.66-1.29-0.37-2.59-0.75-3.93-1.14-1.33-0.38-2.23-0.65-2.69-0.78-0.25-0.08-0.57-0.18-0.96-0.31-0.39-0.12-0.81-0.27-1.28-0.42-0.45-0.14-0.93-0.28-1.43-0.44l-1.47-0.45c-0.27-0.08-0.48-0.11-0.62-0.1-0.14 0-0.23 0.07-0.27 0.2-0.03 0.12-0.01 0.22 0.08 0.3 0.09 0.07 0.24 0.14 0.44 0.2 0.26 0.07 0.52 0.16 0.77 0.25 0.26 0.1 0.46 0.18 0.6 0.26 0.54 0.29 0.88 0.63 1 1.01 0.12 0.39 0.1 0.88-0.05 1.49-0.11 0.49-0.3 1.23-0.58 2.22-0.28 0.98-0.8 2.79-1.57 5.43l-1.85 6.33zm26.73 6.73c-0.31 1.72-0.6 3.25-0.87 4.61s-0.52 2.43-0.75 3.21c-0.15 0.53-0.33 0.97-0.55 1.3-0.22 0.34-0.51 0.51-0.89 0.53-0.17 0.01-0.37 0.01-0.6-0.01-0.22-0.01-0.48-0.04-0.75-0.09-0.22-0.04-0.38-0.04-0.48 0-0.09 0.03-0.15 0.1-0.17 0.19-0.03 0.25 0.19 0.42 0.67 0.5 0.79 0.14 1.65 0.28 2.57 0.42 0.93 0.13 1.62 0.24 2.1 0.32 0.54 0.1 1.32 0.27 2.35 0.49 1.04 0.22 2.17 0.45 3.41 0.68 0.21 0.04 0.38 0.04 0.52 0 0.14-0.03 0.22-0.11 0.25-0.24 0.04-0.19-0.14-0.33-0.54-0.4-0.28-0.06-0.6-0.13-0.94-0.22-0.34-0.1-0.65-0.19-0.91-0.27-0.52-0.19-0.84-0.47-0.97-0.87-0.13-0.39-0.16-0.85-0.1-1.39 0.06-0.82 0.2-1.92 0.43-3.29s0.51-2.91 0.82-4.63l2.76-15.1 4.62 0.96c1.61 0.35 2.69 0.79 3.25 1.31 0.57 0.53 0.81 1.04 0.73 1.55l-0.04 0.41c-0.04 0.27-0.04 0.47 0 0.59 0.03 0.12 0.12 0.2 0.27 0.22 0.11 0.02 0.2-0.02 0.26-0.12 0.07-0.09 0.13-0.23 0.18-0.41 0.1-0.55 0.26-1.28 0.46-2.2 0.2-0.91 0.34-1.6 0.43-2.05 0.05-0.28 0.07-0.48 0.06-0.61-0.02-0.13-0.09-0.2-0.21-0.22-0.08-0.01-0.19-0.02-0.36-0.01-0.16 0-0.39 0-0.67 0.01-0.28-0.01-0.64-0.03-1.06-0.07s-0.93-0.11-1.52-0.21l-14.59-2.66c-0.62-0.12-1.25-0.25-1.89-0.4s-1.22-0.31-1.76-0.46c-0.44-0.13-0.77-0.28-0.98-0.44s-0.39-0.25-0.52-0.29c-0.11-0.02-0.21 0.02-0.3 0.12-0.08 0.1-0.18 0.27-0.27 0.5-0.06 0.12-0.2 0.48-0.44 1.05-0.23 0.58-0.46 1.17-0.69 1.78s-0.37 1.03-0.42 1.26c-0.04 0.2-0.04 0.36-0.01 0.46 0.03 0.11 0.11 0.17 0.23 0.19 0.11 0.02 0.21 0 0.28-0.06 0.08-0.06 0.15-0.17 0.21-0.31s0.16-0.31 0.3-0.51 0.33-0.42 0.56-0.66c0.33-0.35 0.78-0.55 1.34-0.59 0.57-0.05 1.38 0.01 2.43 0.17l5.52 0.86-2.76 15.1zm20.29 3.06c-0.13 1.74-0.26 3.29-0.38 4.68-0.13 1.38-0.26 2.46-0.41 3.26-0.11 0.54-0.25 1-0.43 1.35-0.17 0.36-0.44 0.57-0.81 0.62-0.17 0.03-0.37 0.05-0.6 0.06s-0.48 0.01-0.76-0.01c-0.22-0.02-0.38 0-0.47 0.04-0.1 0.05-0.15 0.12-0.15 0.21-0.01 0.26 0.23 0.4 0.72 0.43 0.8 0.06 1.66 0.1 2.59 0.14 0.94 0.04 1.64 0.08 2.12 0.11 0.51 0.04 1.29 0.12 2.33 0.23s2.19 0.22 3.45 0.32c0.21 0.02 0.38 0 0.52-0.05 0.13-0.05 0.21-0.14 0.22-0.27 0.02-0.19-0.17-0.31-0.57-0.34-0.3-0.03-0.62-0.07-0.97-0.12-0.35-0.06-0.66-0.12-0.93-0.18-0.53-0.12-0.89-0.37-1.05-0.75-0.17-0.38-0.25-0.84-0.25-1.37-0.03-0.83 0-1.94 0.09-3.33 0.08-1.38 0.2-2.95 0.33-4.68l1.14-14.94c0.04-0.4 0.15-0.63 0.35-0.69 0.18-0.04 0.4-0.06 0.66-0.06 0.25-0.01 0.53 0 0.81 0.03 0.45 0.01 1 0.15 1.67 0.39 0.66 0.25 1.31 0.69 1.95 1.35 0.94 1.05 1.49 2.11 1.66 3.18s0.21 1.93 0.12 2.59c-0.22 1.91-0.91 3.37-2.06 4.38-1.15 1-2.29 1.46-3.41 1.4-0.39-0.03-0.66-0.02-0.83 0.03-0.16 0.05-0.24 0.15-0.25 0.3 0 0.13 0.04 0.21 0.14 0.26 0.09 0.05 0.18 0.09 0.28 0.11s0.23 0.05 0.39 0.06c0.16 0.02 0.29 0.03 0.39 0.04 2.71 0.16 4.97-0.52 6.78-2.03 1.81-1.52 2.84-3.62 3.1-6.31 0.05-1.01-0.09-1.91-0.42-2.72s-0.7-1.43-1.11-1.87c-0.23-0.35-0.85-0.83-1.85-1.42-1-0.6-2.64-1.01-4.93-1.24-0.88-0.06-1.81-0.11-2.78-0.15-0.98-0.04-1.86-0.09-2.65-0.15-0.55-0.04-1.33-0.12-2.33-0.23s-2.01-0.21-3.04-0.29c-0.27-0.02-0.48-0.01-0.62 0.02-0.14 0.04-0.21 0.13-0.22 0.26-0.01 0.12 0.04 0.22 0.14 0.27 0.1 0.06 0.26 0.1 0.47 0.11 0.27 0.02 0.54 0.05 0.81 0.09s0.48 0.08 0.63 0.13c0.6 0.17 0.99 0.43 1.19 0.78s0.28 0.84 0.26 1.47c0 0.5-0.04 1.27-0.11 2.29s-0.21 2.9-0.42 5.64l-0.5 6.57zm18.94-2.51c0.1 2.19 0.73 4.28 1.91 6.25 1.17 1.97 2.88 3.56 5.13 4.76l-2.96 0.13c-0.73 0.03-1.41-0.03-2.04-0.21-0.63-0.17-1.1-0.46-1.42-0.88-0.12-0.16-0.25-0.41-0.39-0.73s-0.26-0.72-0.36-1.18c-0.05-0.21-0.1-0.35-0.16-0.43-0.06-0.09-0.15-0.13-0.28-0.12-0.14 0.01-0.23 0.08-0.25 0.21-0.03 0.13-0.04 0.29-0.02 0.48 0.02 0.33 0.07 0.89 0.16 1.7 0.09 0.8 0.18 1.6 0.29 2.39s0.21 1.33 0.28 1.61c0.13 0.46 0.34 0.74 0.61 0.83 0.28 0.09 0.77 0.11 1.45 0.06 1.5-0.07 3.11-0.15 4.83-0.25s3.03-0.18 3.93-0.24c0.38 0.02 0.6 0.03 0.67 0.04 0.06 0 0.28-0.01 0.64-0.02 0.11-0.01 0.18-0.05 0.21-0.12s0.04-0.17 0.03-0.31l-0.07-1.79c-2.09-1.08-3.76-2.86-4.99-5.33-1.24-2.47-1.93-5.03-2.06-7.68-0.09-1.66 0.11-3.38 0.6-5.15 0.49-1.78 1.42-3.31 2.77-4.59s3.27-2 5.75-2.16c3.51-0.05 6.07 1.06 7.69 3.32 1.63 2.26 2.49 5.07 2.6 8.42 0.12 3.58-0.38 6.33-1.48 8.27-1.11 1.93-2.57 3.47-4.37 4.62l0.07 1.79c0.01 0.14 0.03 0.24 0.06 0.31 0.04 0.07 0.11 0.1 0.22 0.09 0.36-0.01 0.58-0.02 0.64-0.03 0.07-0.01 0.29-0.04 0.67-0.1 0.89-0.01 2.2-0.05 3.93-0.1 1.73-0.04 3.34-0.1 4.83-0.16 0.69-0.01 1.17-0.07 1.44-0.19 0.27-0.11 0.45-0.4 0.54-0.87 0.06-0.32 0.11-0.88 0.15-1.68s0.07-1.6 0.08-2.4c0.02-0.8 0.02-1.35 0.01-1.67 0-0.19-0.02-0.35-0.06-0.47-0.04-0.13-0.13-0.19-0.27-0.19-0.13 0-0.22 0.05-0.27 0.14s-0.09 0.24-0.12 0.44c-0.05 0.47-0.14 0.89-0.26 1.26s-0.27 0.67-0.47 0.91c-0.35 0.42-0.84 0.72-1.48 0.9s-1.36 0.28-2.18 0.31l-2.88 0.12c2.02-1.68 3.62-3.53 4.8-5.53 1.17-2.01 1.72-4.27 1.64-6.78-0.19-3.97-1.54-7.09-4.05-9.36s-6.01-3.34-10.51-3.21c-2.27 0.09-4.59 0.68-6.97 1.77-2.37 1.08-4.36 2.69-5.96 4.81s-2.36 4.78-2.3 7.99zm59.66-16.67c0.36-0.93 0.7-1.68 1.01-2.26s0.66-0.97 1.05-1.17c0.48-0.26 0.9-0.43 1.27-0.5 0.19-0.04 0.32-0.1 0.41-0.18s0.13-0.17 0.11-0.28c-0.03-0.11-0.11-0.18-0.24-0.21-0.12-0.03-0.29-0.02-0.49 0.02-0.7 0.16-1.37 0.32-2.02 0.49-0.65 0.18-1.16 0.31-1.55 0.39-0.37 0.08-0.89 0.17-1.57 0.28-0.67 0.11-1.38 0.25-2.11 0.4-0.52 0.11-0.75 0.27-0.7 0.49 0.03 0.13 0.09 0.21 0.19 0.24s0.2 0.03 0.32 0c0.15-0.04 0.34-0.07 0.56-0.11 0.22-0.03 0.43-0.04 0.63-0.03 0.2 0.02 0.37 0.08 0.51 0.18s0.23 0.21 0.26 0.34c0.03 0.16 0.04 0.37 0.04 0.64-0.01 0.26-0.06 0.55-0.15 0.84-0.13 0.44-0.41 1.23-0.85 2.38-0.43 1.15-0.89 2.34-1.36 3.57-0.48 1.23-0.85 2.18-1.11 2.85-0.99-1.09-2.02-2.22-3.1-3.4-1.08-1.17-2.18-2.4-3.29-3.7-0.15-0.18-0.28-0.36-0.39-0.54s-0.17-0.33-0.2-0.44-0.02-0.23 0.02-0.36c0.05-0.12 0.14-0.23 0.29-0.32s0.31-0.16 0.5-0.23c0.19-0.06 0.34-0.1 0.46-0.13 0.17-0.03 0.3-0.08 0.38-0.15 0.09-0.07 0.12-0.17 0.1-0.3-0.03-0.12-0.1-0.2-0.23-0.22s-0.32-0.01-0.57 0.05c-0.73 0.16-1.48 0.34-2.27 0.54-0.78 0.21-1.33 0.34-1.63 0.41-0.93 0.2-1.97 0.4-3.11 0.61s-1.97 0.37-2.48 0.48c-0.24 0.05-0.41 0.11-0.53 0.18-0.11 0.07-0.16 0.16-0.14 0.27 0.03 0.12 0.08 0.21 0.16 0.25 0.08 0.05 0.18 0.06 0.29 0.03 0.18-0.04 0.42-0.07 0.7-0.08 0.27-0.02 0.57-0.02 0.89 0.01 0.67 0.06 1.3 0.27 1.88 0.62 0.58 0.34 1.16 0.84 1.75 1.47l8.54 9.09-4.85 11.5c-0.42 0.99-0.8 1.74-1.16 2.26-0.35 0.51-0.77 0.89-1.25 1.13-0.27 0.13-0.52 0.24-0.76 0.31-0.24 0.08-0.42 0.13-0.56 0.16-0.15 0.03-0.26 0.09-0.35 0.16-0.08 0.08-0.11 0.17-0.09 0.28 0.05 0.22 0.25 0.29 0.62 0.21l0.62-0.13c0.34-0.08 0.84-0.2 1.49-0.38 0.65-0.17 1.17-0.3 1.56-0.39 0.54-0.11 1.2-0.23 2-0.37s1.29-0.23 1.47-0.26l0.66-0.14c0.24-0.05 0.42-0.11 0.53-0.19 0.11-0.07 0.16-0.17 0.13-0.3-0.03-0.11-0.09-0.18-0.19-0.22-0.1-0.03-0.2-0.04-0.32-0.01-0.15 0.03-0.3 0.05-0.45 0.07-0.16 0.02-0.29 0.03-0.41 0.03-0.18 0-0.34-0.04-0.5-0.11-0.16-0.08-0.27-0.2-0.33-0.36-0.06-0.2-0.07-0.44-0.04-0.72s0.11-0.59 0.23-0.93l3.54-9.91c1.15 1.21 2.4 2.56 3.77 4.07 1.36 1.5 2.74 3.05 4.15 4.65 0.17 0.21 0.26 0.4 0.25 0.55 0 0.16-0.05 0.26-0.14 0.3-0.16 0.07-0.28 0.15-0.35 0.23s-0.1 0.18-0.08 0.29c0.02 0.12 0.13 0.19 0.32 0.2 0.2 0.02 0.53-0.02 1.01-0.1 1.46-0.28 2.8-0.55 4.03-0.8 1.23-0.26 2.09-0.44 2.57-0.55l1.1-0.23c0.21-0.05 0.37-0.11 0.48-0.2 0.12-0.08 0.16-0.19 0.14-0.32-0.03-0.11-0.09-0.17-0.19-0.2-0.1-0.02-0.22-0.02-0.35 0.01-0.16 0.04-0.36 0.07-0.6 0.09-0.23 0.01-0.51 0.01-0.84-0.01-0.5-0.04-0.93-0.15-1.31-0.32s-0.76-0.43-1.14-0.76c-0.48-0.42-1.46-1.41-2.97-2.99-1.51-1.57-3.04-3.18-4.59-4.82-1.55-1.63-2.63-2.75-3.23-3.36l4.15-9.93zm12.65 10.58c0.54 1.65 1.02 3.14 1.43 4.47 0.41 1.32 0.7 2.38 0.86 3.17 0.11 0.55 0.15 1.02 0.13 1.41-0.03 0.4-0.2 0.69-0.52 0.89-0.15 0.09-0.33 0.18-0.53 0.28-0.21 0.09-0.44 0.19-0.71 0.28-0.21 0.07-0.35 0.14-0.42 0.22-0.07 0.07-0.09 0.16-0.06 0.25 0.09 0.24 0.37 0.28 0.83 0.12 0.76-0.25 1.58-0.54 2.46-0.86 0.87-0.32 1.54-0.55 2-0.71 0.48-0.15 1.23-0.38 2.24-0.67 1-0.29 2.11-0.63 3.31-1.02 0.2-0.06 0.35-0.14 0.46-0.24 0.1-0.1 0.14-0.21 0.1-0.33-0.05-0.19-0.27-0.22-0.66-0.1-0.28 0.08-0.59 0.17-0.94 0.25-0.34 0.08-0.65 0.15-0.92 0.19-0.55 0.09-0.97-0.01-1.27-0.29-0.3-0.29-0.55-0.68-0.75-1.18-0.34-0.75-0.73-1.79-1.18-3.1-0.45-1.32-0.94-2.8-1.48-4.46l-4.64-14.24c-0.12-0.39-0.1-0.65 0.07-0.77 0.14-0.11 0.34-0.21 0.57-0.31 0.24-0.11 0.5-0.2 0.77-0.29 0.42-0.15 0.98-0.24 1.69-0.27 0.7-0.02 1.48 0.14 2.32 0.5 1.26 0.62 2.18 1.39 2.74 2.31 0.57 0.93 0.94 1.71 1.1 2.35 0.53 1.86 0.45 3.47-0.24 4.83-0.68 1.37-1.55 2.23-2.62 2.6-0.37 0.12-0.62 0.23-0.75 0.34s-0.17 0.24-0.12 0.38c0.05 0.11 0.13 0.18 0.23 0.19s0.21 0 0.31-0.01c0.1-0.02 0.23-0.05 0.38-0.09 0.15-0.05 0.28-0.09 0.38-0.12 2.56-0.88 4.39-2.37 5.49-4.46 1.09-2.09 1.25-4.42 0.46-7.01-0.34-0.95-0.81-1.73-1.43-2.35-0.61-0.62-1.19-1.06-1.73-1.31-0.35-0.24-1.1-0.44-2.25-0.61s-2.83 0.08-5.04 0.74c-0.84 0.28-1.71 0.58-2.63 0.91-0.91 0.34-1.75 0.63-2.5 0.88-0.53 0.16-1.28 0.39-2.24 0.67-0.97 0.28-1.94 0.58-2.92 0.89-0.27 0.08-0.46 0.17-0.57 0.26s-0.15 0.19-0.11 0.31c0.04 0.13 0.12 0.19 0.24 0.21 0.12 0.01 0.28-0.02 0.47-0.08 0.26-0.09 0.52-0.16 0.79-0.23 0.26-0.06 0.47-0.1 0.64-0.12 0.61-0.07 1.07 0.02 1.39 0.27s0.58 0.67 0.8 1.26c0.19 0.47 0.44 1.18 0.77 2.16 0.32 0.97 0.91 2.76 1.76 5.37l2.04 6.27zm16.57-9.55c0.92 2 2.3 3.69 4.14 5.06 1.84 1.38 4.02 2.2 6.56 2.46l-2.69 1.24c-0.66 0.31-1.32 0.5-1.96 0.58-0.65 0.08-1.2-0.01-1.65-0.27-0.18-0.11-0.4-0.28-0.65-0.53-0.25-0.24-0.51-0.56-0.78-0.96-0.12-0.17-0.22-0.28-0.31-0.33-0.09-0.06-0.19-0.06-0.3 0-0.13 0.06-0.18 0.16-0.16 0.29 0.03 0.12 0.08 0.27 0.17 0.44 0.14 0.3 0.4 0.8 0.79 1.51s0.78 1.41 1.18 2.1 0.69 1.16 0.88 1.39c0.29 0.38 0.58 0.56 0.88 0.53 0.29-0.02 0.74-0.18 1.36-0.49 1.35-0.63 2.81-1.32 4.37-2.07s2.74-1.32 3.54-1.71c0.36-0.13 0.57-0.2 0.63-0.22 0.07-0.02 0.26-0.11 0.59-0.26 0.1-0.05 0.15-0.11 0.15-0.19s-0.03-0.18-0.09-0.3l-0.75-1.63c-2.34-0.2-4.56-1.22-6.64-3.03-2.09-1.82-3.69-3.92-4.82-6.32-0.72-1.5-1.18-3.17-1.4-5s0.05-3.6 0.81-5.29c0.77-1.7 2.27-3.09 4.51-4.19 3.22-1.37 6.01-1.33 8.37 0.15 2.36 1.47 4.23 3.74 5.61 6.8 1.46 3.27 2.05 6 1.76 8.21s-1.05 4.19-2.28 5.94l0.75 1.63c0.05 0.12 0.11 0.21 0.17 0.26s0.14 0.05 0.24 0c0.33-0.15 0.52-0.24 0.58-0.27 0.06-0.04 0.25-0.15 0.58-0.34 0.82-0.36 2.02-0.89 3.6-1.59s3.05-1.36 4.4-1.99c0.64-0.27 1.06-0.51 1.26-0.72 0.21-0.2 0.27-0.54 0.17-1.01-0.06-0.32-0.23-0.86-0.5-1.61-0.26-0.76-0.54-1.51-0.83-2.25-0.29-0.75-0.5-1.26-0.63-1.55-0.08-0.17-0.16-0.31-0.24-0.42-0.08-0.1-0.18-0.12-0.32-0.06-0.11 0.05-0.18 0.12-0.19 0.23-0.02 0.1 0 0.25 0.05 0.45 0.13 0.46 0.21 0.88 0.24 1.27 0.03 0.38 0 0.72-0.09 1.01-0.16 0.52-0.5 0.99-1.03 1.4-0.52 0.4-1.15 0.78-1.89 1.11l-2.62 1.21c1.23-2.32 2.01-4.64 2.33-6.94s-0.03-4.6-1.05-6.9c-1.69-3.59-4.13-5.97-7.31-7.11-3.18-1.15-6.83-0.81-10.94 1.02-2.06 0.95-3.99 2.38-5.77 4.28-1.79 1.91-3.01 4.15-3.69 6.72-0.67 2.57-0.37 5.32 0.91 8.26z"/>
					</svg>
				</fo:instream-foreign-object>
			</fo:block>
		</fo:block-container>
		<!-- grey opacity -->
		<fo:block-container absolute-position="fixed" left="0" top="0">
			<fo:block>
				<fo:instream-foreign-object content-height="{$pageHeight}" fox:alt-text="Background color">
					<svg xmlns="http://www.w3.org/2000/svg" version="1.0" width="210mm" height="297mm">
						<rect width="210mm" height="297mm" style="fill:rgb(255,255,255);stroke-width:0;fill-opacity:0.73"/>
						</svg>
					</fo:instream-foreign-object>
				</fo:block>
			</fo:block-container>
	</xsl:template>
	
</xsl:stylesheet>
