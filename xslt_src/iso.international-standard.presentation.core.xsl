<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
											xmlns:fo="http://www.w3.org/1999/XSL/Format" 
											xmlns:iso="https://www.metanorma.org/ns/iso" 
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

	<xsl:key name="kfn" match="iso:p/iso:fn" use="@reference"/>
	
	<xsl:variable name="namespace">iso</xsl:variable>
	
	<xsl:variable name="debug">false</xsl:variable>
	<xsl:variable name="pageWidth" select="'210mm'"/>
	<xsl:variable name="pageHeight" select="'297mm'"/>

	<xsl:variable name="docidentifierISO" select="/iso:iso-standard/iso:bibdata/iso:docidentifier[@type = 'iso'] | /iso:iso-standard/iso:bibdata/iso:docidentifier[@type = 'ISO']"/>

	<xsl:variable name="copyrightText" select="concat('© ISO ', iso:iso-standard/iso:bibdata/iso:copyright/iso:from ,' – All rights reserved')"/>
  
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
		<xsl:call-template name="namespaceCheck"/>
		<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format" font-family="Cambria, Times New Roman, Cambria Math, HanSans" font-size="11pt" xml:lang="{$lang}"> <!--   -->
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
																	<fo:block>Reference number</fo:block>
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
												<fo:block>Reference number</fo:block>
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
							<fo:block margin-bottom="3mm">
								<fo:external-graphic src="{concat('data:image/png;base64,', normalize-space($Image-Attention))}" width="14mm" content-height="13mm" content-width="scale-to-fit" scaling="uniform" fox:alt-text="Image {@alt}"/>
								<fo:inline padding-left="6mm" font-size="12pt" font-weight="bold">COPYRIGHT PROTECTED DOCUMENT</fo:inline>
							</fo:block>
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
							<xsl:variable name="part-en" select="/iso:iso-standard/iso:bibdata/iso:title[@language = 'en' and @type = 'title-part']"/>
							<fo:block>
								<xsl:if test="normalize-space($title-intro) != ''">
									<xsl:value-of select="$title-intro"/>
									<xsl:text> — </xsl:text>
								</xsl:if>
								
								<xsl:value-of select="$title-main"/>
								
								<xsl:if test="normalize-space($part-en) != ''">
									<xsl:if test="$part != ''">
										<xsl:text> — </xsl:text>
										<fo:block font-weight="normal" margin-top="12pt" line-height="1.1">
											<xsl:value-of select="java:replaceAll(java:java.lang.String.new($titles/title-part[@lang='en']),'#',$part)"/>
											<!-- <xsl:value-of select="$title-part-en"/>
											<xsl:value-of select="$part"/>
											<xsl:text>:</xsl:text> -->
										</fo:block>
									</xsl:if>
								</xsl:if>
							</fo:block>
							<fo:block>
								<xsl:value-of select="$part-en"/>
							</fo:block>
							
							<xsl:variable name="title-amd" select="/iso:iso-standard/iso:bibdata/iso:title[@language = 'en' and @type = 'title-amd']"/>
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
								<fo:block font-size="9pt">Price based on <fo:page-number-citation ref-id="lastBlock"/> pages</fo:block>
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
	<xsl:template match="*[iso:title]" mode="contents">
		<xsl:variable name="level">
			<xsl:call-template name="getLevel">
				<xsl:with-param name="depth" select="iso:title/@depth"/>
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
				<xsl:when test="ancestor-or-self::iso:annex and $level &gt;= 2">false</xsl:when>
				<xsl:when test="$section = '' and $type = 'clause'">false</xsl:when>
				<xsl:when test="$level &lt;= 3">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="skip">
			<xsl:choose>
				<xsl:when test="ancestor-or-self::iso:bibitem">true</xsl:when>
				<xsl:when test="ancestor-or-self::iso:term">true</xsl:when>				
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		
		<xsl:if test="$skip = 'false'">		
		
			<xsl:variable name="title">
				<xsl:call-template name="getName"/>
			</xsl:variable>
			
			<xsl:variable name="root">
				<xsl:if test="ancestor-or-self::iso:preface">preface</xsl:if>
				<xsl:if test="ancestor-or-self::iso:annex">annex</xsl:if>
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
						<xsl:number format="a)"/>
					</xsl:when>
					<xsl:when test="../@type = 'alphabet'">
						<xsl:number format="a)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:number format="1."/>
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

	
	<xsl:template match="iso:p">
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
					<xsl:when test="ancestor::iso:td/@align"><xsl:value-of select="ancestor::iso:td/@align"/></xsl:when>
					<xsl:when test="ancestor::iso:th/@align"><xsl:value-of select="ancestor::iso:th/@align"/></xsl:when>
					<xsl:otherwise>justify</xsl:otherwise><!-- left -->
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
			<xsl:apply-templates />
		</xsl:element>
		<xsl:if test="$element-name = 'fo:inline' and not($inline = 'true') and not(local-name(..) = 'admonition')">
			<fo:block margin-bottom="12pt">
				 <xsl:if test="ancestor::iso:annex or following-sibling::iso:table">
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
		<xsl:for-each select="//iso:p/iso:fn[generate-id(.)=generate-id(key('kfn',@reference)[1])]">
			<!-- copy unique fn -->
			<fn gen_id="{generate-id(.)}">
				<xsl:copy-of select="@*"/>
				<xsl:copy-of select="node()"/>
			</fn>
		</xsl:for-each>
	</xsl:variable>
	
	<xsl:template match="iso:p/iso:fn" priority="2">
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
							<xsl:value-of select="$number + count(//iso:bibitem[ancestor::iso:references[@normative='true']]/iso:note)"/><xsl:text>)</xsl:text>
						</fo:basic-link>
					</fo:inline>
					<fo:footnote-body>
						<fo:block font-size="10pt" margin-bottom="12pt">
							<fo:inline id="footnote_{@reference}_{$number}" keep-with-next.within-line="always" padding-right="3mm"> <!-- font-size="60%"  alignment-baseline="hanging" -->
								<xsl:value-of select="$number + count(//iso:bibitem[ancestor::iso:references[@normative='true']]/iso:note)"/><xsl:text>)</xsl:text>
							</fo:inline>
							<xsl:for-each select="iso:p">
									<xsl:apply-templates />
							</xsl:for-each>
						</fo:block>
					</fo:footnote-body>
				</fo:footnote>
			</xsl:when>
			<xsl:otherwise>
				<fo:inline font-size="60%" keep-with-previous.within-line="always" vertical-align="super">
					<fo:basic-link internal-destination="footnote_{@reference}_{$number}" fox:alt-text="footnote {@reference} {$number}">
						<xsl:value-of select="$number + count(//iso:bibitem/iso:note)"/>
					</fo:basic-link>
				</fo:inline>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="iso:p/iso:fn/iso:p">
		<xsl:apply-templates />
	</xsl:template>
	
	
	
	<xsl:template match="iso:bibitem">
		<fo:block id="{@id}" margin-bottom="6pt"> <!-- 12 pt -->
			<xsl:variable name="docidentifier">
				<xsl:if test="iso:docidentifier">
					<xsl:choose>
						<xsl:when test="iso:docidentifier/@type = 'metanorma'"/>
						<xsl:otherwise><xsl:value-of select="iso:docidentifier"/></xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</xsl:variable>
			<xsl:value-of select="$docidentifier"/>
			<xsl:apply-templates select="iso:note"/>			
			<xsl:if test="normalize-space($docidentifier) != ''">, </xsl:if>
			<fo:inline font-style="italic">
				<xsl:choose>
					<xsl:when test="iso:title[@type = 'main' and @language = 'en']">
						<xsl:value-of select="iso:title[@type = 'main' and @language = 'en']"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="iso:title"/>
					</xsl:otherwise>
				</xsl:choose>
			</fo:inline>
		</fo:block>
	</xsl:template>
	
	
	<xsl:template match="iso:bibitem/iso:note" priority="2">
		<fo:footnote>
			<xsl:variable name="number">
				<xsl:number level="any" count="iso:bibitem/iso:note"/>
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
	
	
	
	<xsl:template match="iso:ul | iso:ol" mode="ul_ol">
		<fo:list-block provisional-distance-between-starts="7mm" margin-top="8pt"> <!-- margin-bottom="8pt" -->
			<xsl:apply-templates />
		</fo:list-block>
		<xsl:for-each select="./iso:note">
			<xsl:call-template name="note"/>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="iso:ul//iso:note |  iso:ol//iso:note" priority="2"/>
	
	<xsl:template match="iso:li">
		<fo:list-item id="{@id}">
			<fo:list-item-label end-indent="label-end()">
				<fo:block>
					<xsl:call-template name="getListItemFormat"/>
				</fo:block>
			</fo:list-item-label>
			<fo:list-item-body start-indent="body-start()">
				<fo:block>
					<xsl:apply-templates />
					<xsl:apply-templates select=".//iso:note" mode="process"/>
				</fo:block>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>
	
	<xsl:template match="iso:note" mode="process">
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
	

	<xsl:template match="iso:references[@normative='true']">
		<fo:block id="{@id}">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<!-- <xsl:template match="iso:references[@id = '_bibliography']"> -->
	<xsl:template match="iso:references[not(@normative='true')]">
		<fo:block break-after="page"/>
		<fo:block id="{@id}">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>


	<!-- Example: [1] ISO 9:1995, Information and documentation – Transliteration of Cyrillic characters into Latin characters – Slavic and non-Slavic languages -->
	<!-- <xsl:template match="iso:references[@id = '_bibliography']/iso:bibitem"> -->
	<xsl:template match="iso:references[not(@normative='true')]/iso:bibitem">
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
							<xsl:if test="iso:docidentifier">
								<xsl:choose>
									<xsl:when test="iso:docidentifier/@type = 'metanorma'"/>
									<xsl:otherwise><xsl:value-of select="iso:docidentifier"/></xsl:otherwise>
								</xsl:choose>
							</xsl:if>
						</xsl:variable>
						<xsl:value-of select="$docidentifier"/>
						<xsl:apply-templates select="iso:note"/>
						<xsl:if test="normalize-space($docidentifier) != ''">, </xsl:if>
						<xsl:choose>
							<xsl:when test="iso:title[@type = 'main' and @language = 'en']">
								<xsl:apply-templates select="iso:title[@type = 'main' and @language = 'en']"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates select="iso:title"/>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:apply-templates select="iso:formattedref"/>
					</fo:block>
				</fo:list-item-body>
			</fo:list-item>
		</fo:list-block>
	</xsl:template>
	
	<!-- <xsl:template match="iso:references[@id = '_bibliography']/iso:bibitem" mode="contents"/> -->
	<xsl:template match="iso:references[not(@normative='true')]/iso:bibitem" mode="contents"/>
	
	<!-- <xsl:template match="iso:references[@id = '_bibliography']/iso:bibitem/iso:title"> -->
	<xsl:template match="iso:references[not(@normative='true')]/iso:bibitem/iso:title">
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
			<xsl:value-of select="java:toUpperCase(java:java.lang.String.new(@type))"/>
			<xsl:text> — </xsl:text>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	

	<xsl:template match="iso:formula/iso:stem">
		<fo:block margin-top="6pt" margin-bottom="12pt">
			<fo:table table-layout="fixed" width="100%">
				<fo:table-column column-width="95%"/>
				<fo:table-column column-width="5%"/>
				<fo:table-body>
					<fo:table-row>
						<fo:table-cell display-align="center">
							<fo:block text-align="left" margin-left="5mm">
								<xsl:apply-templates />
							</fo:block>
						</fo:table-cell>
						<fo:table-cell display-align="center">
							<fo:block text-align="right">
								<xsl:apply-templates select="../iso:name" mode="presentation"/>
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
		<xsl:text>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</xsl:text>
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
		<xsl:variable name="edition" select="normalize-space(/iso:iso-standard/iso:bibdata/iso:edition)"/>
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

	
</xsl:stylesheet>
