<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:gb="https://www.metanorma.org/ns/gb" xmlns:mathml="http://www.w3.org/1998/Math/MathML" xmlns:xalan="http://xml.apache.org/xalan" xmlns:fox="http://xmlgraphics.apache.org/fop/extensions" version="1.0">

	<xsl:output method="xml" encoding="UTF-8" indent="no"/>
	
	<xsl:param name="svg_images"/>
	<xsl:variable name="images" select="document($svg_images)"/>
	
	<xsl:include href="./common.xsl"/>

	<xsl:key name="kfn" match="gb:p/gb:fn" use="@reference"/>
	
	<xsl:variable name="namespace">gb</xsl:variable>
	
	<xsl:variable name="debug">true</xsl:variable>
	<xsl:variable name="pageWidth" select="'210mm'"/>
	<xsl:variable name="pageHeight" select="'297mm'"/>

	<xsl:variable name="copyrightText" select="concat('© ISO ', gb:gb-standard/gb:bibdata/gb:copyright/gb:from ,' – All rights reserved')"/>
  
	<xsl:variable name="lang-1st-letter_tmp" select="substring-before(substring-after(/gb:gb-standard/gb:bibdata/gb:docidentifier[@type = 'iso-with-lang'], '('), ')')"/>
	<xsl:variable name="lang-1st-letter" select="concat('(', $lang-1st-letter_tmp , ')')"/>
  
	<!-- <xsl:variable name="ISOname" select="concat(/gb:gb-standard/gb:bibdata/gb:docidentifier, ':', /gb:gb-standard/gb:bibdata/gb:copyright/gb:from , $lang-1st-letter)"/> -->
	<xsl:variable name="ISOname" select="/gb:gb-standard/gb:bibdata/gb:docidentifier[@type = 'iso-reference']"/>

	<!-- Information and documentation — Codes for transcription systems  -->
	<xsl:variable name="title-en" select="/gb:gb-standard/gb:bibdata/gb:title[@language = 'en' and @type = 'main']"/>
	<xsl:variable name="title-fr" select="/gb:gb-standard/gb:bibdata/gb:title[@language = 'fr' and @type = 'main']"/>
	<xsl:variable name="title-intro" select="/gb:gb-standard/gb:bibdata/gb:title[@language = 'en' and @type = 'title-intro']"/>
	<xsl:variable name="title-intro-fr" select="/gb:gb-standard/gb:bibdata/gb:title[@language = 'fr' and @type = 'title-intro']"/>
	<xsl:variable name="title-main" select="/gb:gb-standard/gb:bibdata/gb:title[@language = 'en' and @type = 'title-main']"/>
	<xsl:variable name="title-main-fr" select="/gb:gb-standard/gb:bibdata/gb:title[@language = 'fr' and @type = 'title-main']"/>
	<xsl:variable name="part" select="/gb:gb-standard/gb:bibdata/gb:ext/gb:structuredidentifier/gb:project-number/@part"/>
	<xsl:variable name="title-part" select="/gb:gb-standard/gb:bibdata/gb:title[@language = 'en' and @type = 'title-part']"/>
	<xsl:variable name="title-part-fr" select="/gb:gb-standard/gb:bibdata/gb:title[@language = 'fr' and @type = 'title-part']"/>

	<xsl:variable name="doctype_uppercased" select="translate(translate(/gb:gb-standard/gb:bibdata/gb:ext/gb:doctype,'-',' '), $lower,$upper)"/>
	
	<xsl:variable name="stage" select="number(/gb:gb-standard/gb:bibdata/gb:status/gb:stage)"/>
	<xsl:variable name="substage" select="number(/gb:gb-standard/gb:bibdata/gb:status/gb:substage)"/>	
	<xsl:variable name="stagename" select="normalize-space(/gb:gb-standard/gb:bibdata/gb:ext/gb:stagename)"/>
	<xsl:variable name="abbreviation" select="normalize-space(/gb:gb-standard/gb:bibdata/gb:status/gb:stage/@abbreviation)"/>
		
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
				<xsl:value-of select="translate($stagename, $lower, $upper)"/>
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

	<xsl:variable name="title-figure">
		<xsl:text>Figure </xsl:text>
	</xsl:variable>
	
	<!-- Example:
		<item level="1" id="Foreword" display="true">Foreword</item>
		<item id="term-script" display="false">3.2</item>
	-->
	<xsl:variable name="contents">
		<contents>
			<xsl:apply-templates select="/gb:gb-standard/gb:preface/node()" mode="contents"/>
				<!-- <xsl:with-param name="sectionNum" select="'0'"/>
			</xsl:apply-templates> -->
			<xsl:apply-templates select="/gb:gb-standard/gb:sections/gb:clause[1]" mode="contents"> <!-- [@id = '_scope'] -->
				<xsl:with-param name="sectionNum" select="'1'"/>
			</xsl:apply-templates>
			<xsl:apply-templates select="/gb:gb-standard/gb:bibliography/gb:references[1]" mode="contents"> <!-- [@id = '_normative_references'] -->
				<xsl:with-param name="sectionNum" select="'2'"/>
			</xsl:apply-templates>
			<xsl:apply-templates select="/gb:gb-standard/gb:sections/*[position() &gt; 1]" mode="contents"> <!-- @id != '_scope' -->
				<xsl:with-param name="sectionNumSkew" select="'1'"/>
			</xsl:apply-templates>
			<xsl:apply-templates select="/gb:gb-standard/gb:annex" mode="contents"/>
			<xsl:apply-templates select="/gb:gb-standard/gb:bibliography/gb:references[position() &gt; 1]" mode="contents"/> <!-- @id = '_bibliography' -->
			
			<xsl:apply-templates select="//gb:figure" mode="contents"/>
			
			<xsl:apply-templates select="//gb:table" mode="contents"/>
			
		</contents>
	</xsl:variable>
	
	<xsl:variable name="lang">
		<xsl:call-template name="getLang"/>
	</xsl:variable>
	
	<xsl:template match="/">
		<xsl:message>INFO: Document namespace: '<xsl:value-of select="namespace-uri(/*)"/>'</xsl:message>
		<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format" font-family="SimSun" font-size="10.5pt" xml:lang="{$lang}"> <!--   -->
			<fo:layout-master-set>
				
				<!-- cover page -->
				<fo:simple-page-master master-name="cover" page-width="{$pageWidth}" page-height="{$pageHeight}">
					<fo:region-body margin-top="10mm" margin-bottom="24mm" margin-left="25mm" margin-right="23mm"/>
					<fo:region-before region-name="cover-header" extent="10mm" />
					<fo:region-after region-name="cover-footer" extent="24mm" />
					<fo:region-start region-name="cover-left-region" extent="25mm"/>
					<fo:region-end region-name="cover-right-region" extent="23mm"/>
				</fo:simple-page-master>
				
				
				<!-- contents pages -->
				<!-- odd pages -->
				<fo:simple-page-master master-name="odd" page-width="{$pageWidth}" page-height="{$pageHeight}">
					<fo:region-body margin-top="35mm" margin-bottom="20mm" margin-left="25mm" margin-right="20mm"/>
					<fo:region-before region-name="header" extent="35mm"/>
					<fo:region-after region-name="footer-odd" extent="20mm"/>
					<fo:region-start region-name="left-region" extent="25mm"/>
					<fo:region-end region-name="right-region" extent="20mm"/>
				</fo:simple-page-master>
				<!-- even pages -->
				<fo:simple-page-master master-name="even" page-width="{$pageWidth}" page-height="{$pageHeight}">
					<fo:region-body margin-top="35mm" margin-bottom="25mm" margin-left="20mm" margin-right="25mm"/>
					<fo:region-before region-name="header" extent="35mm"/>
					<fo:region-after region-name="footer-even" extent="20mm"/>
					<fo:region-start region-name="left-region" extent="20mm"/>
					<fo:region-end region-name="right-region" extent="25mm"/>
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

			<fo:declarations>
				<pdf:catalog xmlns:pdf="http://xmlgraphics.apache.org/fop/extensions/pdf">
						<pdf:dictionary type="normal" key="ViewerPreferences">
							<pdf:boolean key="DisplayDocTitle">true</pdf:boolean>
						</pdf:dictionary>
					</pdf:catalog>
				<x:xmpmeta xmlns:x="adobe:ns:meta/">
					<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
						<rdf:Description rdf:about="" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:pdf="http://ns.adobe.com/pdf/1.3/">
						<!-- Dublin Core properties go here -->
							<dc:title><xsl:value-of select="$title-en"/></dc:title>
							<dc:creator><xsl:value-of select="/gb:gb-standard/gb:bibdata/gb:contributor[gb:role/@type='author']/gb:organization/gb:name"/></dc:creator>
							<dc:description>
								<xsl:variable name="abstract">
									<xsl:copy-of select="/gb:gb-standard/gb:bibliography/gb:references/gb:bibitem/gb:abstract//text()"/>
								</xsl:variable>
								<xsl:value-of select="normalize-space($abstract)"/>
							</dc:description>
							<pdf:Keywords></pdf:Keywords>
						</rdf:Description>
						<rdf:Description rdf:about=""
								xmlns:xmp="http://ns.adobe.com/xap/1.0/">
							<!-- XMP properties go here -->
							<xmp:CreatorTool></xmp:CreatorTool>
						</rdf:Description>
					</rdf:RDF>
				</x:xmpmeta>
			</fo:declarations>
			
			<fo:page-sequence master-reference="cover" force-page-count="no-force">
				<fo:flow flow-name="xsl-region-body">
					<fo:block-container>
						<xsl:variable name="ccs" select="normalize-space(/gb:gb-standard/gb:bibdata/gb:ext/gb:ccs)"/>
						<fo:block font-weight="bold" line-height="130%">
							<xsl:if test="$ccs != ''">
								<xsl:text>ICS</xsl:text>
							</xsl:if>
							<xsl:text> </xsl:text>
							<xsl:value-of select="$linebreak"/>
							<xsl:value-of select="substring($ccs, 1, 1)"/>
							<xsl:text> </xsl:text>
							<fo:inline font-family="SimHei" font-weight="normal"><xsl:value-of select="substring($ccs, 2)"/></fo:inline>
							<xsl:text> </xsl:text>
						</fo:block>
					</fo:block-container>
					<!-- GB Logo -->
					<fo:block-container position="absolute" left="119mm" top="8mm">
						<fo:block>
							<fo:external-graphic src="{concat('data:image/gif;base64,', normalize-space($Image-GB-Logo))}" width="29.9mm" content-height="14.8mm" content-width="scale-to-fit" scaling="uniform" fox:alt-text="Image GB Logo"/>
						</fo:block>
					</fo:block-container>
					<!-- National standard (Recommended) -->
					<fo:block-container position="absolute" left="0mm" top="28mm" width="170mm" text-align="center">
						<fo:block font-weight="bold" font-size="12pt"> <!-- font-stretch="wider" not supported by FOP-->
							<xsl:variable name="standard">
								<xsl:variable name="gbscope" select="/gb:gb-standard/gb:bibdata/gb:ext/gb:gbtype/gb:gbscope"/>
								<xsl:value-of select="translate(substring($gbscope, 1, 1), $lower, $upper)"/><xsl:value-of select="substring($gbscope, 2)"/>
								<xsl:text> standard (</xsl:text>
								<xsl:variable name="gbmandate" select="/gb:gb-standard/gb:bibdata/gb:ext/gb:gbtype/gb:gbmandate"/>
								<xsl:value-of select="translate(substring($gbmandate, 1, 1), $lower, $upper)"/><xsl:value-of select="substring($gbmandate, 2)"/>
								<xsl:text>)</xsl:text>
							</xsl:variable>
							<xsl:call-template name="addLetterSpacing">
								<xsl:with-param name="text" select="$standard"/>
								<xsl:with-param name="letter-spacing" select="0.7"/>
							</xsl:call-template>
						</fo:block>
					</fo:block-container>
					<fo:block-container position="absolute" left="0mm" top="43mm" height="46.4mm" width="165mm" text-align="right">
						<fo:block>
							<!-- GB/T/303 80021.1 -->
							<fo:block font-family="SimHei" font-size="14pt">
								<xsl:value-of select="/gb:gb-standard/gb:bibdata/gb:docidentifier[@type = 'gb']"/>							
							</fo:block>
							<!-- Partly Supercedes GB/T 88021-2016 -->
							<fo:block margin-top="2.85pt">
								<xsl:text>Fixed text: Partly Supercedes GB/T 88021-2016</xsl:text>
							</fo:block>
						</fo:block>
					</fo:block-container>
					<fo:block-container position="absolute" left="0mm" top="66mm" height="2mm" width="170mm" border-top="1pt solid black">
						<fo:block>&#xA0;</fo:block>
					</fo:block-container>
					<fo:block-container position="absolute" left="-2.5mm" top="106mm" height="124mm" width="165mm" text-align="center">
						<!-- Cereals and pulses—Specifications and test methods—Part 1: Rice -->
						<fo:block font-family="Cambria" font-size="26pt" line-height="130%">
							<xsl:call-template name="insertTitle"/>
						</fo:block>
						<fo:block font-size="14pt" margin-top="28.35pt" margin-bottom="28.35pt">
							<xsl:value-of select="/gb:gb-standard/gb:bibdata/gb:title[@language = 'zh' and @type='title-intro']"/>
							<xsl:if test="/gb:gb-standard/gb:bibdata/gb:title[@language = 'zh' and @type='title-main']">
								<xsl:text>&#xA0;</xsl:text>
								<xsl:value-of select="/gb:gb-standard/gb:bibdata/gb:title[@language = 'zh' and @type='title-main']"/>
							</xsl:if>
							<xsl:if test="/gb:gb-standard/gb:bibdata/gb:ext/gb:structuredidentifier/gb:project-number/@part">
								<xsl:text>&#xA0;</xsl:text>
								<xsl:text>第</xsl:text>
								<xsl:value-of select="/gb:gb-standard/gb:bibdata/gb:ext/gb:structuredidentifier/gb:project-number/@part"/>
								<xsl:text>部分: </xsl:text>
							</xsl:if>
							<xsl:value-of select="/gb:gb-standard/gb:bibdata/gb:title[@language = 'zh' and @type='title-part']"/>
						</fo:block>
						<!-- (ISO 17301-1:2016, IDT) -->
						<fo:block font-size="14pt" margin-top="30pt">
							<xsl:text>&#xA0;</xsl:text>
								<xsl:if test="/gb:gb-standard/gb:bibdata/gb:relation[@type='adoptedFrom']/gb:bibitem/gb:docidentifier">
									<xsl:text>(</xsl:text>
										<xsl:value-of select="/gb:gb-standard/gb:bibdata/gb:relation[@type='adoptedFrom']/gb:bibitem/gb:docidentifier"/>
										<xsl:text>, </xsl:text>
										<xsl:text> Fixed text IDT</xsl:text>
									<xsl:text>)</xsl:text>
								</xsl:if>
							<xsl:text>&#xA0;</xsl:text>
						</fo:block>
						<!-- （CD） -->
						<fo:block font-size="12pt" margin-top="30pt">
							<xsl:text>(</xsl:text>
							<xsl:value-of select="/gb:gb-standard/gb:bibdata/gb:status/gb:stage/@abbreviation"/>
							<xsl:text>)</xsl:text>
						</fo:block>
						<fo:block text-align="justify">
							<!-- When submitting feedback, please attach any relevant patents that you are aware of, together with supporting documents. -->
							<xsl:apply-templates select="/gb:gb-standard/gb:boilerplate/gb:legal-statement"/>
						</fo:block>
						<fo:block margin-top="9.05pt">
							<xsl:text>（Completion date for this manuscript: </xsl:text>
								<xsl:value-of select="/gb:gb-standard/gb:bibdata/gb:version/gb:revision-date"/>
							<xsl:text>)</xsl:text>
						</fo:block>
					</fo:block-container>
					<fo:block-container position="absolute" left="0mm" top="239mm" width="170mm" border-bottom="1pt solid black">
						<fo:block font-family="SimHei" font-size="14pt" text-align-last="justify" margin-bottom="2.5mm">
							<xsl:text>Issuance Date: </xsl:text>
							<xsl:value-of select="/gb:gb-standard/gb:bibdata/gb:date[@type='issued']/gb:on"/>
							<fo:inline keep-together.within-line="always">
								<fo:leader  leader-pattern="space"/>
							</fo:inline>
							<xsl:text>Implementation Date: </xsl:text>
							<xsl:value-of select="/gb:gb-standard/gb:bibdata/gb:date[@type='implemented']/gb:on"/>
						</fo:block>
					</fo:block-container>
					<fo:block break-after="page"/>
					<fo:block>&#xA0;</fo:block>
				</fo:flow>
			</fo:page-sequence>
			
			<fo:page-sequence master-reference="preface" format="I" initial-page-number="1" force-page-count="no-force">
				<xsl:call-template name="insertHeaderFooter"/>
				<fo:flow flow-name="xsl-region-body">
					<fo:block-container>
						
						<fo:block font-family="SimHei" font-size="16pt" margin-top="6pt" margin-bottom="32pt" text-align="center">
							<xsl:text>Table of contents</xsl:text>
						</fo:block>
						
						<xsl:if test="$debug = 'true'">
							<xsl:text disable-output-escaping="yes">&lt;!--</xsl:text>
								DEBUG
								contents=<xsl:copy-of select="xalan:nodeset($contents)"/>
							<xsl:text disable-output-escaping="yes">--&gt;</xsl:text>
						</xsl:if>
						
						<fo:block line-height="220%">
						<xsl:variable name="margin-left">12</xsl:variable>
						<xsl:for-each select="xalan:nodeset($contents)//item[@display = 'true'][not(@level = 2 and starts-with(@section, '0'))]"><!-- skip clause from preface -->							
							<fo:block text-align-last="justify">
								<xsl:if test="@level =2">
									<xsl:attribute name="margin-left">3.7mm</xsl:attribute>
								</xsl:if>
								<fo:basic-link internal-destination="{@id}" fox:alt-text="{text()}">
									<xsl:if test="normalize-space(@section) != '' and not(@display-section = 'false')">
										<fo:inline>
											<xsl:if test="@type = 'annex' and @level = 1">
												<xsl:attribute name="font-weight">bold</xsl:attribute>
											</xsl:if>
											<xsl:value-of select="@section"/>											
										</fo:inline>
										<xsl:if test="not(@type = 'annex' and @level = 1)">
											<xsl:text>.&#x3000;</xsl:text>
										</xsl:if>
										<xsl:if test="@type = 'annex' and @level = 1">
											<xsl:text>&#xA0;</xsl:text>
										</xsl:if>
									</xsl:if>
									<xsl:if test="@addon != ''">
										<fo:inline font-weight="normal">(<xsl:value-of select="@addon"/>)</fo:inline>
										<xsl:text>&#xA0;</xsl:text>
									</xsl:if>
									<xsl:value-of select="text()"/>
									<xsl:text> </xsl:text>
									<fo:inline keep-together.within-line="always">
										<fo:leader font-weight="normal" leader-pattern="dots"/>
										<fo:inline><fo:page-number-citation ref-id="{@id}"/></fo:inline>
									</fo:inline>
								</fo:basic-link>
								
							</fo:block>
							
						</xsl:for-each>
						</fo:block>
					</fo:block-container>
					
					<!-- Foreword, Introduction -->
					<fo:block line-height="150%">
						<xsl:apply-templates select="/gb:gb-standard/gb:preface/node()"/>
					</fo:block>
					
				</fo:flow>
			</fo:page-sequence>
			
			<fo:page-sequence master-reference="document" format="1" initial-page-number="1" force-page-count="no-force">
				<fo:static-content flow-name="xsl-footnote-separator">
					<fo:block margin-left="7.4mm">
						<fo:leader leader-pattern="rule" leader-length="30%"/>
					</fo:block>
				</fo:static-content>
				<xsl:call-template name="insertHeaderFooter"/>
				<fo:flow flow-name="xsl-region-body">
					<fo:block line-height="150%">
					
						<!-- Cereals and pulses—Specifications and test methods—Part 1: Rice -->
						<fo:block font-family="SimHei" font-size="16pt" text-align="center" line-height="130%" margin-bottom="18pt">
							<xsl:call-template name="insertTitle"/>
						</fo:block>
					
						<xsl:apply-templates select="/gb:gb-standard/gb:sections/gb:clause[1]"> <!-- Scope -->
							<xsl:with-param name="sectionNum" select="'1'"/>
						</xsl:apply-templates>
						
						<!-- Normative references  -->
						<xsl:apply-templates select="/gb:gb-standard/gb:bibliography/gb:references[1]">
							<xsl:with-param name="sectionNum" select="'2'"/>
						</xsl:apply-templates>
						
						<!-- Main sections -->
						<xsl:apply-templates select="/gb:gb-standard/gb:sections/*[position() &gt; 1]">
							<xsl:with-param name="sectionNumSkew" select="'1'"/>
						</xsl:apply-templates>
						
						<!-- Annex(s) -->
						<xsl:apply-templates select="/gb:gb-standard/gb:annex"/>
						
						<!-- Bibliography -->
						<xsl:apply-templates select="/gb:gb-standard/gb:bibliography/gb:references[position() &gt; 1]"/>
						
					</fo:block>
				</fo:flow>
			</fo:page-sequence>
			
			
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
																	<xsl:variable name="docid" select="substring-before(/gb:gb-standard/gb:bibdata/gb:docidentifier, ' ')"/>
																	<xsl:for-each select="xalan:tokenize($docid, '/')">
																		<xsl:choose>
																			<xsl:when test=". = 'ISO'">
																				<fo:external-graphic src="{concat('data:image/png;base64,', normalize-space($Image-GB-Logo))}" width="21mm" content-height="21mm" content-width="scale-to-fit" scaling="uniform" fox:alt-text="Image {@alt}"/>
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
																	<fo:block><fo:inline font-size="9pt">©</fo:inline><xsl:value-of select="concat(' ISO ', gb:gb-standard/gb:bibdata/gb:copyright/gb:from)"/></fo:block>
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
										</fo:block>
										<fo:block font-size="20pt" font-weight="bold" text-align="right">
											<xsl:value-of select="/gb:gb-standard/gb:bibdata/gb:docidentifier[@type = 'iso']"/>
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
														<fo:block margin-bottom="3mm">ISO/TC <fo:inline font-weight="bold"><xsl:value-of select="/gb:gb-standard/gb:bibdata/gb:ext/gb:editorialgroup/gb:technical-committee/@number"/></fo:inline>
														</fo:block>
													</fo:table-cell>
													<fo:table-cell>
														<fo:block>Secretariat: <fo:inline font-weight="bold"><xsl:value-of select="/gb:gb-standard/gb:bibdata/gb:ext/gb:editorialgroup/gb:secretariat"/></fo:inline></fo:block>
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
																<xsl:when test="/gb:gb-standard/gb:bibdata/gb:date[@type = 'vote-started']/gb:on">
																	<xsl:value-of select="/gb:gb-standard/gb:bibdata/gb:date[@type = 'vote-started']/gb:on"/>
																</xsl:when>
																<xsl:otherwise>YYYY-MM-DD</xsl:otherwise>
															</xsl:choose>
														</fo:block>
													</fo:table-cell>
													<fo:table-cell>
														<fo:block font-weight="bold">
															<xsl:choose>
																<xsl:when test="/gb:gb-standard/gb:bibdata/gb:date[@type = 'vote-ended']/gb:on">
																	<xsl:value-of select="/gb:gb-standard/gb:bibdata/gb:date[@type = 'vote-ended']/gb:on"/>
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
													
													<xsl:if test="normalize-space($title-part) != ''">
														<xsl:if test="$part != ''">
															<xsl:text> — </xsl:text>
															<fo:block font-weight="normal" margin-top="6pt">
																<xsl:text>Part </xsl:text><xsl:value-of select="$part"/>
																<xsl:text>:</xsl:text>
															</fo:block>
														</xsl:if>
														<xsl:value-of select="$title-part"/>
													</xsl:if>
												</fo:block>
															
												<fo:block font-size="9pt"><xsl:value-of select="$linebreak"/></fo:block>
												<fo:block font-size="11pt" font-style="italic" line-height="1.5">
													
													<xsl:if test="normalize-space($title-intro-fr) != ''">
														<xsl:value-of select="$title-intro-fr"/>
														<xsl:text> — </xsl:text>
													</xsl:if>
													
													<xsl:value-of select="$title-main-fr"/>
													
													<xsl:if test="normalize-space($title-part-fr) != ''">
														<xsl:if test="$part != ''">
															<xsl:text> — </xsl:text>
															<xsl:text>Partie </xsl:text>
															<xsl:value-of select="$part"/>
															<xsl:text>:</xsl:text>
														</xsl:if>
														<xsl:value-of select="$title-part-fr"/>
													</xsl:if>
												</fo:block>
											</fo:block>
											<fo:block margin-top="10mm">
												<xsl:for-each select="/gb:gb-standard/gb:bibdata/gb:ext/gb:ics/gb:code">
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
															<xsl:variable name="iteration" select="number(/gb:gb-standard/gb:bibdata/gb:status/gb:iteration)"/>	
															
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
															<xsl:value-of select="$doctype_uppercased"/>
														</fo:block>
													</fo:table-cell>
													<fo:table-cell>
														<fo:block text-align="right" font-weight="bold" margin-bottom="13mm">
															<xsl:value-of select="/gb:gb-standard/gb:bibdata/gb:docidentifier[@type = 'iso']"/>
														</fo:block>
													</fo:table-cell>
												</fo:table-row>
												<fo:table-row height="42mm">
													<fo:table-cell number-columns-spanned="3" font-size="10pt" line-height="1.2">
														<fo:block text-align="right">
															<xsl:if test="$stage-abbreviation = 'PRF' or 
																								$stage-abbreviation = 'IS' or 
																								$stage-abbreviation = 'published'">
																<xsl:call-template name="printEdition"/>
															</xsl:if>
															<xsl:choose>
																<xsl:when test="$stage-abbreviation = 'IS'">
																	<xsl:value-of select="$linebreak"/>
																	<xsl:value-of select="/gb:gb-standard/gb:bibdata/gb:date[@type = 'published']"/>
																</xsl:when>
																<xsl:when test="$stage-abbreviation = 'published'">
																	<xsl:value-of select="$linebreak"/>
																	<xsl:value-of select="substring(/gb:gb-standard/gb:bibdata/gb:version/gb:revision-date,1, 7)"/>
																</xsl:when>
															</xsl:choose>
															<!-- <xsl:value-of select="$linebreak"/>
															<xsl:value-of select="/gb:gb-standard/gb:bibdata/gb:version/gb:revision-date"/> -->
															</fo:block>
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
																			<fo:block margin-bottom="8pt">ISO/TC <fo:inline font-weight="bold"><xsl:value-of select="/gb:gb-standard/gb:bibdata/gb:ext/gb:editorialgroup/gb:technical-committee/@number"/></fo:inline></fo:block>
																			<fo:block margin-bottom="6pt">Secretariat: <xsl:value-of select="/gb:gb-standard/gb:bibdata/gb:ext/gb:editorialgroup/gb:secretariat"/></fo:block>
																			<fo:block margin-bottom="6pt">Voting begins on:<xsl:value-of select="$linebreak"/>
																				<fo:inline font-weight="bold">
																					<xsl:choose>
																						<xsl:when test="/gb:gb-standard/gb:bibdata/gb:date[@type = 'vote-started']/gb:on">
																							<xsl:value-of select="/gb:gb-standard/gb:bibdata/gb:date[@type = 'vote-started']/gb:on"/>
																						</xsl:when>
																						<xsl:otherwise>YYYY-MM-DD</xsl:otherwise>
																					</xsl:choose>
																				</fo:inline>
																			</fo:block>
																			<fo:block>Voting terminates on:<xsl:value-of select="$linebreak"/>
																				<fo:inline font-weight="bold">
																					<xsl:choose>
																						<xsl:when test="/gb:gb-standard/gb:bibdata/gb:date[@type = 'vote-ended']/gb:on">
																							<xsl:value-of select="/gb:gb-standard/gb:bibdata/gb:date[@type = 'vote-ended']/gb:on"/>
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
																	
																	<xsl:if test="normalize-space($title-part) != ''">
																		<xsl:if test="$part != ''">
																			<xsl:text> — </xsl:text>
																			<fo:block font-weight="normal" margin-top="6pt">
																				<xsl:text>Part </xsl:text><xsl:value-of select="$part"/>
																				<xsl:text>:</xsl:text>
																			</fo:block>
																		</xsl:if>
																		<xsl:value-of select="$title-part"/>
																	</xsl:if>
																</fo:block>
																			
																<fo:block font-size="9pt"><xsl:value-of select="$linebreak"/></fo:block>
																<fo:block font-size="11pt" font-style="italic" line-height="1.5">
																	
																	<xsl:if test="normalize-space($title-intro-fr) != ''">
																		<xsl:value-of select="$title-intro-fr"/>
																		<xsl:text> — </xsl:text>
																	</xsl:if>
																	
																	<xsl:value-of select="$title-main-fr"/>
																	
																	<xsl:if test="normalize-space($title-part-fr) != ''">
																		<xsl:if test="$part != ''">
																			<xsl:text> — </xsl:text>
																			<xsl:text>Partie </xsl:text>
																			<xsl:value-of select="$part"/>
																			<xsl:text>:</xsl:text>
																		</xsl:if>
																		<xsl:value-of select="$title-part-fr"/>
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
												<fo:external-graphic src="{concat('data:image/png;base64,', normalize-space($Image-GB-Logo))}" width="21mm" content-height="21mm" content-width="scale-to-fit" scaling="uniform" fox:alt-text="Image {@alt}"/>
											</fo:block>
										</fo:table-cell>
										<fo:table-cell  display-align="center">
											<fo:block text-align="right">
												<fo:block>Reference number</fo:block>
												<fo:block><xsl:value-of select="$ISOname"/></fo:block>
												<fo:block>&#xA0;</fo:block>
												<fo:block>&#xA0;</fo:block>
												<fo:block><fo:inline font-size="9pt">©</fo:inline><xsl:value-of select="concat(' ISO ', gb:gb-standard/gb:bibdata/gb:copyright/gb:from)"/></fo:block>
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
													<xsl:value-of select="/gb:gb-standard/gb:bibdata/gb:docidentifier[@type = 'iso']"/>
												</fo:block>
											</fo:table-cell>
										</fo:table-row>
										<fo:table-row>
											<fo:table-cell number-columns-spanned="2" font-size="10pt" line-height="1.2">
												<fo:block text-align="right">
													<xsl:call-template name="printEdition"/>
													<xsl:value-of select="$linebreak"/>
													<xsl:value-of select="/gb:gb-standard/gb:bibdata/gb:version/gb:revision-date"/></fo:block>
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
										
										<xsl:if test="normalize-space($title-part) != ''">
											<xsl:if test="$part != ''">
												<xsl:text> — </xsl:text>
												<fo:block font-weight="normal" margin-top="6pt">
													<xsl:text>Part </xsl:text><xsl:value-of select="$part"/>
													<xsl:text>:</xsl:text>
												</fo:block>
											</xsl:if>
											<xsl:value-of select="$title-part"/>
										</xsl:if>
									</fo:block>
												
									<fo:block font-size="9pt"><xsl:value-of select="$linebreak"/></fo:block>
									<fo:block font-size="11pt" font-style="italic" line-height="1.5">
										
										<xsl:if test="normalize-space($title-intro-fr) != ''">
											<xsl:value-of select="$title-intro-fr"/>
											<xsl:text> — </xsl:text>
										</xsl:if>
										
										<xsl:value-of select="$title-main-fr"/>

										<xsl:if test="normalize-space($title-part-fr) != ''">
											<xsl:if test="$part != ''">
												<xsl:text> — </xsl:text>
												<xsl:text>Partie </xsl:text>
												<xsl:value-of select="$part"/>
												<xsl:text>:</xsl:text>
											</xsl:if>
											<xsl:value-of select="$title-part-fr"/>
										</xsl:if>
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
									<xsl:when test="/gb:gb-standard/gb:bibdata/gb:docidentifier[@type = 'iso-tc']">
										<!-- 17301  -->
										<fo:block font-size="14pt" font-weight="bold" margin-bottom="12pt">
											<xsl:value-of select="/gb:gb-standard/gb:bibdata/gb:docidentifier[@type = 'iso-tc']"/>
										</fo:block>
										<!-- Date: 2016-05-01  -->
										<fo:block margin-bottom="12pt">
											<xsl:text>Date: </xsl:text><xsl:value-of select="/gb:gb-standard/gb:bibdata/gb:version/gb:revision-date"/>
										</fo:block>
									
										<!-- ISO/CD 17301-1(E)  -->
										<fo:block margin-bottom="12pt">
											<xsl:value-of select="concat(/gb:gb-standard/gb:bibdata/gb:docidentifier, $lang-1st-letter)"/>
										</fo:block>
									</xsl:when>
									<xsl:otherwise>
										<fo:block font-size="14pt" font-weight="bold" margin-bottom="12pt">
											<!-- ISO/WD 24229(E)  -->
											<xsl:value-of select="concat(/gb:gb-standard/gb:bibdata/gb:docidentifier, $lang-1st-letter)"/>
										</fo:block>
										
									</xsl:otherwise>
								</xsl:choose>
								
								<!-- ISO/TC 46/WG 3  -->
										<!-- <fo:block margin-bottom="12pt">
											<xsl:value-of select="concat('ISO/', /gb:gb-standard/gb:bibdata/gb:ext/gb:editorialgroup/gb:technical-committee/@type, ' ',
																																				/gb:gb-standard/gb:bibdata/gb:ext/gb:editorialgroup/gb:technical-committee/@number, '/', 
																																				/gb:gb-standard/gb:bibdata/gb:ext/gb:editorialgroup/gb:workgroup/@type, ' ',
																																				/gb:gb-standard/gb:bibdata/gb:ext/gb:editorialgroup/gb:workgroup/@number)"/>
								 -->
								<!-- ISO/TC 34/SC 4/WG 3 -->
								<fo:block margin-bottom="12pt">
									<xsl:text>ISO</xsl:text>
									<xsl:for-each select="/gb:gb-standard/gb:bibdata/gb:ext/gb:editorialgroup/gb:technical-committee[@number]">
										<xsl:text>/TC </xsl:text><xsl:value-of select="@number"/>
									</xsl:for-each>
									<xsl:for-each select="/gb:gb-standard/gb:bibdata/gb:ext/gb:editorialgroup/gb:subcommittee[@number]">
										<xsl:text>/SC </xsl:text>
										<xsl:value-of select="@number"/>
									</xsl:for-each>
									<xsl:for-each select="/gb:gb-standard/gb:bibdata/gb:ext/gb:editorialgroup/gb:workgroup[@number]">
										<xsl:text>/WG </xsl:text>
										<xsl:value-of select="@number"/>
									</xsl:for-each>
								</fo:block>
								
								<!-- Secretariat: AFNOR  -->
								
								<fo:block margin-bottom="100pt">
									<xsl:text>Secretariat: </xsl:text>
									<xsl:value-of select="/gb:gb-standard/gb:bibdata/gb:ext/gb:editorialgroup/gb:secretariat"/>
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
										
										<xsl:if test="normalize-space($title-part) != ''">
											<xsl:if test="$part != ''">
												<xsl:text> — </xsl:text>
												<fo:block font-weight="normal" margin-top="6pt">
													<xsl:text>Part </xsl:text><xsl:value-of select="$part"/>
													<xsl:text>:</xsl:text>
												</fo:block>
											</xsl:if>
											<xsl:value-of select="$title-part"/>
										</xsl:if>
									</fo:block>
									
									<fo:block font-size="12pt"><xsl:value-of select="$linebreak"/></fo:block>
									<fo:block>
										<xsl:if test="normalize-space($title-intro-fr) != ''">
											<xsl:value-of select="$title-intro-fr"/>
											<xsl:text> — </xsl:text>
										</xsl:if>
										
										<xsl:value-of select="$title-main-fr"/>
										
										<xsl:if test="normalize-space($title-part-fr) != ''">
											<xsl:if test="$part != ''">
												<xsl:text> — </xsl:text>
												<fo:block margin-top="6pt" font-weight="normal">
													<xsl:text>Partie </xsl:text><xsl:value-of select="$part"/>
													<xsl:text>:</xsl:text>
												</fo:block>
											</xsl:if>
											<xsl:value-of select="$title-part-fr"/>
										</xsl:if>
									</fo:block>
							</fo:block-container>
							<fo:block font-size="11pt" margin-bottom="8pt"><xsl:value-of select="$linebreak"/></fo:block>
							<fo:block-container font-size="40pt" text-align="center" margin-bottom="12pt" border="0.5pt solid black">
								<xsl:variable name="stage-title" select="substring-after(substring-before(/gb:gb-standard/gb:bibdata/gb:docidentifier[@type = 'iso'], ' '), '/')"/>
								<fo:block padding-top="2mm"><xsl:value-of select="$stage-title"/><xsl:text> stage</xsl:text></fo:block>
							</fo:block-container>
							<fo:block><xsl:value-of select="$linebreak"/></fo:block>
							
							<xsl:if test="/gb:gb-standard/gb:boilerplate/gb:license-statement">
								<fo:block-container font-size="10pt" margin-top="12pt" margin-bottom="6pt" border="0.5pt solid black">
									<fo:block padding-top="1mm">
										<xsl:apply-templates select="/gb:gb-standard/gb:boilerplate/gb:license-statement"/>
									</fo:block>
								</fo:block-container>
							</xsl:if>
						</fo:flow>
					</fo:page-sequence>
				</xsl:otherwise>
			</xsl:choose>	
			
			<fo:page-sequence master-reference="preface{$document-master-reference}" format="i" force-page-count="{$force-page-count-preface}">
				<xsl:call-template name="insertHeaderFooter2">
					<xsl:with-param name="font-weight">normal</xsl:with-param>
				</xsl:call-template>
				<fo:flow flow-name="xsl-region-body" line-height="115%">
					<xsl:if test="/gb:gb-standard/gb:boilerplate/gb:copyright-statement">
					
						<fo:block-container height="252mm" display-align="after">
							<fo:block margin-bottom="3mm">
								<fo:external-graphic src="{concat('data:image/png;base64,', normalize-space($Image-Attention))}" width="14mm" content-height="13mm" content-width="scale-to-fit" scaling="uniform" fox:alt-text="Image {@alt}"/>
								<fo:inline padding-left="6mm" font-size="12pt" font-weight="bold">COPYRIGHT PROTECTED DOCUMENT</fo:inline>
							</fo:block>
							<fo:block line-height="90%">
								<fo:block font-size="9pt" text-align="justify">
									<xsl:apply-templates select="/gb:gb-standard/gb:boilerplate/gb:copyright-statement"/>
								</fo:block>
							</fo:block>
						</fo:block-container>
						<fo:block break-after="page"/>
					</xsl:if>
					
					<fo:block>ttt</fo:block>
					
						
				</fo:flow>
			</fo:page-sequence>
			
			<!-- BODY -->
			<fo:page-sequence master-reference="document{$document-master-reference}" initial-page-number="1" force-page-count="no-force">
				<fo:static-content flow-name="xsl-footnote-separator">
					<fo:block>
						<fo:leader leader-pattern="rule" leader-length="30%"/>
					</fo:block>
				</fo:static-content>
				<xsl:call-template name="insertHeaderFooter2"/>
				<fo:flow flow-name="xsl-region-body">
				
					
					<fo:block-container>
						<!-- Information and documentation — Codes for transcription systems -->
						<!-- <fo:block font-size="16pt" font-weight="bold" margin-bottom="18pt">
							<xsl:value-of select="$title-en"/>
						</fo:block>
						 -->
						<fo:block font-size="18pt" font-weight="bold" margin-top="40pt" margin-bottom="20pt" line-height="1.1">
							<fo:block>
								<xsl:if test="normalize-space($title-intro) != ''">
									<xsl:value-of select="$title-intro"/>
									<xsl:text> — </xsl:text>
								</xsl:if>
								
								<xsl:value-of select="$title-main"/>
								
								<xsl:if test="normalize-space($title-part) != ''">
									<xsl:if test="$part != ''">
										<xsl:text> — </xsl:text>
										<fo:block font-weight="normal" margin-top="12pt" line-height="1.1">
											<xsl:text>Part </xsl:text><xsl:value-of select="$part"/>
											<xsl:text>:</xsl:text>
										</fo:block>
									</xsl:if>
								</xsl:if>
							</fo:block>
							<fo:block>
								<xsl:value-of select="$title-part"/>
							</fo:block>
						</fo:block>
					
						
					</fo:block-container>
					<!-- Clause(s) -->
					<fo:block>
						
						

						
						
						
						<!-- <fo:block space-before="18pt">&#xA0;</fo:block> -->
						
						
						
						
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
									<xsl:for-each select="/gb:gb-standard/gb:bibdata/gb:ext/gb:ics/gb:code">
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
								<fo:block font-size="9pt">Price based on <fo:page-number-citation ref-id="lastBlock"/> pages</fo:block>
							</fo:block-container>
						</fo:block-container>
					</fo:flow>
				</fo:page-sequence>
			</xsl:if>
		</fo:root>
	</xsl:template> 

	<xsl:template name="insertTitle">
		<xsl:value-of select="/gb:gb-standard/gb:bibdata/gb:title[@language = 'en' and @type='title-intro']"/>
		<xsl:if test="/gb:gb-standard/gb:bibdata/gb:title[@language = 'en' and @type='title-main']">
			<xsl:text>—</xsl:text>
			<xsl:value-of select="/gb:gb-standard/gb:bibdata/gb:title[@language = 'en' and @type='title-main']"/>
		</xsl:if>
		<xsl:if test="/gb:gb-standard/gb:bibdata/gb:title[@language = 'en' and @type='title-part']">
			<xsl:text>—</xsl:text>
			<xsl:if test="/gb:gb-standard/gb:bibdata/gb:ext/gb:structuredidentifier/gb:project-number/@part">
				<xsl:text>Part </xsl:text>
				<xsl:value-of select="/gb:gb-standard/gb:bibdata/gb:ext/gb:structuredidentifier/gb:project-number/@part"/>
				<xsl:text>: </xsl:text>
			</xsl:if>
			<xsl:value-of select="/gb:gb-standard/gb:bibdata/gb:title[@language = 'en' and @type='title-part']"/>
		</xsl:if>
	</xsl:template>
	
	<!-- for pass the paremeter 'sectionNum' over templates, like 'tunnel' parameter in XSLT 2.0 -->
	<xsl:template match="node()">
		<xsl:param name="sectionNum"/>
		<xsl:param name="sectionNumSkew"/>
		<xsl:apply-templates>
			<xsl:with-param name="sectionNum" select="$sectionNum"/>
			<xsl:with-param name="sectionNumSkew" select="$sectionNumSkew"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<!-- ============================= -->
	<!-- CONTENTS                                       -->
	<!-- ============================= -->
	<xsl:template match="node()" mode="contents">
		<xsl:param name="sectionNum"/>
		<xsl:param name="sectionNumSkew"/>
		<xsl:apply-templates mode="contents">
			<xsl:with-param name="sectionNum" select="$sectionNum"/>
			<xsl:with-param name="sectionNumSkew" select="$sectionNumSkew"/>
		</xsl:apply-templates>
	</xsl:template>

	
	<!-- calculate main section number (1,2,3) and pass it deep into templates -->
	<!-- it's necessary, because there is itu:bibliography/itu:references from other section, but numbering should be sequental -->
	<xsl:template match="gb:gb-standard/gb:sections/*" mode="contents">
		<xsl:param name="sectionNum"/>
		<xsl:param name="sectionNumSkew" select="0"/>
		<xsl:variable name="sectionNum_">
			<xsl:choose>
				<xsl:when test="$sectionNum"><xsl:value-of select="$sectionNum"/></xsl:when>
				<xsl:when test="$sectionNumSkew != 0">
					<xsl:variable name="number"><xsl:number count="*"/></xsl:variable> <!-- gb:sections/gb:clause | gb:sections/gb:terms -->
					<xsl:value-of select="$number + $sectionNumSkew"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:number count="*"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:apply-templates mode="contents">
			<xsl:with-param name="sectionNum" select="$sectionNum_"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<!-- Any node with title element - clause, definition, annex,... -->
	<xsl:template match="gb:title | gb:preferred" mode="contents">
		<xsl:param name="sectionNum"/>
		<!-- sectionNum=<xsl:value-of select="$sectionNum"/> -->
		<xsl:variable name="id">
			<xsl:call-template name="getId"/>
		</xsl:variable>
		
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		
		<xsl:variable name="section">
			<xsl:call-template name="getSection">
				<xsl:with-param name="sectionNum" select="$sectionNum"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="display">
			<xsl:choose>
				<xsl:when test="ancestor::gb:bibitem">false</xsl:when>
				<xsl:when test="ancestor::gb:term">false</xsl:when>
				<xsl:when test="ancestor::gb:annex and $level &gt;= 3">false</xsl:when>
				<xsl:when test="$level &lt;= 3">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="display-section">true</xsl:variable>
			<!-- <xsl:choose>
				<xsl:when test="ancestor::gb:annex">false</xsl:when>
				<xsl:otherwise>true</xsl:otherwise>
			</xsl:choose>
		</xsl:variable> -->
		
		<xsl:variable name="type">
			<xsl:value-of select="local-name(..)"/>
		</xsl:variable>

		<xsl:variable name="root">
			<xsl:choose>
				<xsl:when test="ancestor::gb:annex">annex</xsl:when>
			</xsl:choose>
		</xsl:variable>
		
		<item id="{$id}" level="{$level}" section="{$section}" display-section="{$display-section}" display="{$display}" type="{$type}" root="{$root}">
			<xsl:attribute name="addon">
				<xsl:if test="local-name(..) = 'annex'"><xsl:value-of select="../@obligation"/></xsl:if>
			</xsl:attribute>
			<xsl:value-of select="."/>
		</item>
		
		<xsl:apply-templates mode="contents">
			<xsl:with-param name="sectionNum" select="$sectionNum"/>
		</xsl:apply-templates>
		
	</xsl:template>
	
	
	<xsl:template match="gb:figure" mode="contents">
		<item level="" id="{@id}" display="false">
			<xsl:attribute name="section">
				<xsl:call-template name="getFigureNumber"/>
				<!-- <xsl:text>Figure </xsl:text><xsl:number format="A.1-1" level="multiple" count="gb:annex | gb:figure"/> -->
			</xsl:attribute>
		</item>
	</xsl:template>
	
	
	<xsl:template match="gb:table" mode="contents">
		<xsl:param name="sectionNum" />
		<xsl:variable name="annex-id" select="ancestor::gb:annex/@id"/>
		<item level="" id="{@id}" display="false" type="table">
			<xsl:attribute name="section">
				<xsl:text>Table </xsl:text>
				<xsl:choose>
					<xsl:when test="ancestor::*[local-name()='executivesummary']"> <!-- NIST -->
							<xsl:text>ES-</xsl:text><xsl:number format="1" count="*[local-name()='executivesummary']//*[local-name()='table']"/>
						</xsl:when>
					<xsl:when test="ancestor::*[local-name()='annex']">
						<xsl:number format="A-" count="gb:annex"/>
						<xsl:number format="1" level="any" count="gb:table[ancestor::gb:annex[@id = $annex-id]]"/>
					</xsl:when>
					<xsl:otherwise>
						<!-- <xsl:number format="1"/> -->
						<xsl:number format="1" level="any" count="*[local-name()='sections']//*[local-name()='table']"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:value-of select="gb:name/text()"/>
		</item>
	</xsl:template>
	
	<xsl:template match="gb:formula" mode="contents">
		<item level="" id="{@id}" display="false">
			<xsl:attribute name="section">
				<xsl:text>Formula (</xsl:text><xsl:number format="A.1" level="multiple" count="gb:annex | gb:formula"/><xsl:text>)</xsl:text>
			</xsl:attribute>
		</item>
	</xsl:template>
	
	<xsl:template match="gb:li" mode="contents">
		<xsl:param name="sectionNum" />
		<item level="" id="{@id}" display="false" type="li">
			<xsl:attribute name="section">
				<xsl:call-template name="getListItemFormat"/>
			</xsl:attribute>
			<xsl:attribute name="parent_section">
				<xsl:for-each select="ancestor::*[not(local-name() = 'p' or local-name() = 'ol')][1]">
					<xsl:call-template name="getSection">
						<xsl:with-param name="sectionNum" select="$sectionNum"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:attribute>
		</item>
		<xsl:apply-templates mode="contents">
			<xsl:with-param name="sectionNum" select="$sectionNum"/>
		</xsl:apply-templates>
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
	
	
	<xsl:template match="gb:license-statement//gb:title">
		<fo:block text-align="center" font-weight="bold">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="gb:license-statement//gb:p">
		<fo:block margin-left="1.5mm" margin-right="1.5mm">
			<xsl:if test="following-sibling::gb:p">
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
	
	<xsl:template match="gb:copyright-statement//gb:p">
		<fo:block>
			<xsl:if test="preceding-sibling::gb:p">
				<!-- <xsl:attribute name="font-size">10pt</xsl:attribute> -->
			</xsl:if>
			<xsl:if test="following-sibling::gb:p">
				<!-- <xsl:attribute name="margin-bottom">12pt</xsl:attribute> -->
				<xsl:attribute name="margin-bottom">3pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="contains(@id, 'address')"> <!-- not(following-sibling::gb:p) -->
				<!-- <xsl:attribute name="margin-left">7.1mm</xsl:attribute> -->
				<xsl:attribute name="margin-left">4mm</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<!-- Foreword, Introduction -->
	<xsl:template match="gb:gb-standard/gb:preface/*">
		<fo:block break-after="page"/>
		<xsl:apply-templates />
	</xsl:template>
	

	
	<!-- clause, terms, clause, ...-->
	<xsl:template match="gb:gb-standard/gb:sections/*">
		<xsl:param name="sectionNum"/>
		<xsl:param name="sectionNumSkew" select="0"/>
		<fo:block>
			<xsl:variable name="pos"><xsl:number count="gb:sections/gb:clause | gb:sections/gb:terms"/></xsl:variable>
			<xsl:if test="$pos &gt;= 2">
				<xsl:attribute name="space-before">18pt</xsl:attribute>
			</xsl:if>
			<!-- pos=<xsl:value-of select="$pos" /> -->
			<xsl:variable name="sectionNum_">
				<xsl:choose>
					<xsl:when test="$sectionNum"><xsl:value-of select="$sectionNum"/></xsl:when>
					<xsl:when test="$sectionNumSkew != 0">
						<xsl:variable name="number"><xsl:number count="gb:sections/gb:clause | gb:sections/gb:terms"/></xsl:variable>
						<xsl:value-of select="$number + $sectionNumSkew"/>
					</xsl:when>
				</xsl:choose>
			</xsl:variable>
			<xsl:if test="not(gb:title)">
				<fo:block margin-top="3pt" margin-bottom="12pt">
					<xsl:value-of select="$sectionNum_"/><xsl:number format=".1 " level="multiple" count="gb:clause" />
				</fo:block>
			</xsl:if>
			<xsl:apply-templates>
				<xsl:with-param name="sectionNum" select="$sectionNum_"/>
			</xsl:apply-templates>
		</fo:block>
	</xsl:template>
	

	
	<xsl:template match="gb:clause//gb:clause[not(gb:title)]">
		<xsl:param name="sectionNum"/>
		<xsl:variable name="section">
			<xsl:call-template name="getSection">
				<xsl:with-param name="sectionNum" select="$sectionNum"/>
			</xsl:call-template>
		</xsl:variable>
		<fo:block margin-top="6pt" margin-bottom="6pt" keep-with-next="always">
			<fo:inline font-family="SimHei">
				<xsl:value-of select="$section"/><xsl:text>.</xsl:text>
			</fo:inline>			
		</fo:block>
		<xsl:apply-templates>
			<xsl:with-param name="sectionNum" select="$sectionNum"/>
		</xsl:apply-templates>
	</xsl:template>
	
	
	<xsl:template match="gb:title">
		<xsl:param name="sectionNum"/>
		
		<xsl:variable name="parent-name"  select="local-name(..)"/>
		<xsl:variable name="references_num_current">
			<xsl:number level="any" count="gb:references"/>
		</xsl:variable>
		
		<xsl:variable name="id">
			<xsl:call-template name="getId"/>
		</xsl:variable>
		
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		
		<xsl:variable name="section">
			<xsl:call-template name="getSection">
				<xsl:with-param name="sectionNum" select="$sectionNum"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="font-family">
			<xsl:choose>
				<xsl:when test="ancestor::gb:annex and $level &gt;= 3">SimSun</xsl:when>
				<xsl:otherwise>SimHei</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="font-size">
			<xsl:choose>
				<xsl:when test="ancestor::gb:preface">16pt</xsl:when>
				<xsl:otherwise>10.5pt</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="element-name">
			<xsl:choose>
				<xsl:when test="../@inline-header = 'true'">fo:inline</xsl:when>
				<xsl:otherwise>fo:block</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="$parent-name = 'annex'">
				<fo:block id="{$id}" font-family="{$font-family}" font-size="{$font-size}"  text-align="center" margin-bottom="12pt" keep-with-next="always">
				<!-- font-weight="bold" -->
					<xsl:value-of select="$section"/>
					<xsl:if test=" ../@obligation">
						<xsl:value-of select="$linebreak"/>
						<fo:inline font-weight="normal">(<xsl:value-of select="../@obligation"/>)</fo:inline>
					</xsl:if>
					<fo:block margin-top="14pt" margin-bottom="24pt"><xsl:apply-templates /></fo:block>
				</fo:block>
			</xsl:when>
			<xsl:when test="$parent-name = 'references' and $references_num_current != 1"> <!-- Bibliography -->
				<fo:block id="{$id}" font-family="{$font-family}" text-align="center" margin-top="6pt" margin-bottom="16pt" keep-with-next="always">
				<!-- font-weight="bold" -->
					<xsl:apply-templates />
				</fo:block>
			</xsl:when>
			
			<xsl:otherwise>
				<xsl:element name="{$element-name}">
					<xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute>
					<xsl:attribute name="font-size"><xsl:value-of select="$font-size"/></xsl:attribute>
					<xsl:attribute name="font-family"><xsl:value-of select="$font-family"/></xsl:attribute>
					<!-- <xsl:attribute name="font-weight">bold</xsl:attribute> -->
					<xsl:attribute name="margin-top"> <!-- margin-top -->
						<xsl:choose>
							<xsl:when test="ancestor::gb:preface">8pt</xsl:when>
							<xsl:when test="$level = 2 and ancestor::gb:annex">10pt</xsl:when>
							<!-- <xsl:when test="$level = 3 and ancestor::gb:annex">0</xsl:when> -->
							<xsl:when test="$level = 1">16pt</xsl:when>
							<xsl:when test="$level = ''">6pt</xsl:when><!-- 13.5pt -->
							<xsl:otherwise>12pt</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="margin-bottom">
						<xsl:choose>
							<xsl:when test="ancestor::gb:preface">24pt</xsl:when>
							<xsl:when test="$level = 1">16pt</xsl:when>
							<!-- <xsl:when test="$level = 3 and ancestor::gb:annex">0</xsl:when> -->
							<!-- <xsl:otherwise>12pt</xsl:otherwise> -->
							<xsl:otherwise>8pt</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="keep-with-next">always</xsl:attribute>		
					<xsl:if test="ancestor::gb:preface">
						<xsl:attribute name="text-align">center</xsl:attribute>
						<xsl:attribute name="font-family">SimHei</xsl:attribute>
					</xsl:if>
					<xsl:if test="$element-name = 'fo:inline'">
						<xsl:attribute name="padding-left">7.4mm</xsl:attribute>
					</xsl:if>
						<!-- DEBUG level=<xsl:value-of select="$level"/>x -->
						<!-- section=<xsl:value-of select="$sectionNum"/> -->
						<!-- <xsl:if test="$sectionNum"> -->
						<xsl:value-of select="$section"/>
						<xsl:if test="$section != ''">.&#x3000;</xsl:if>
							<!-- <xsl:choose>
								<xsl:when test="$level = 2">
									<fo:inline padding-right="2mm">&#xA0;</fo:inline>
								</xsl:when>
								<xsl:otherwise>
									<fo:inline padding-right="3mm">&#xA0;</fo:inline>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:if> -->
				
						<xsl:apply-templates />
				</xsl:element>
				
				<xsl:if test="$element-name = 'fo:inline' and not(following-sibling::gb:p)">
					<!-- <fo:block> -->
						<xsl:value-of select="$linebreak"/>
					<!-- </fo:block> -->
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	

	
	<xsl:template match="gb:p">
		<xsl:param name="inline" select="'false'"/>
		<xsl:variable name="previous-element" select="local-name(preceding-sibling::*[1])"/>
		<xsl:variable name="element-name">
			<xsl:choose>
				<xsl:when test="$inline = 'true'">fo:inline</xsl:when>
				<xsl:when test="../@inline-header = 'true' and $previous-element = 'title'">fo:inline</xsl:when> <!-- first paragraph after inline title -->
				<!-- <xsl:when test="local-name(..) = 'admonition'">fo:inline</xsl:when> -->
				<xsl:otherwise>fo:block</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:element name="{$element-name}">
			<xsl:attribute name="text-align">
				<xsl:choose>
					<!-- <xsl:when test="ancestor::gb:preface">justify</xsl:when> -->
					<xsl:when test="@align"><xsl:value-of select="@align"/></xsl:when>
					<xsl:when test="ancestor::gb:td/@align"><xsl:value-of select="ancestor::gb:td/@align"/></xsl:when>
					<xsl:when test="ancestor::gb:th/@align"><xsl:value-of select="ancestor::gb:th/@align"/></xsl:when>
					<xsl:otherwise>justify</xsl:otherwise><!-- left -->
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="text-indent">
				<xsl:choose>
					<xsl:when test="parent::gb:li">0mm</xsl:when>
					<xsl:otherwise>7.4mm</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<!-- <xsl:attribute name="margin-bottom">
				<xsl:choose>
					<xsl:when test="ancestor::gb:legal-statement">0pt</xsl:when>
					<xsl:otherwise>8pt</xsl:otherwise>
				</xsl:choose>
				</xsl:attribute> -->
			<xsl:apply-templates />
		</xsl:element>
		<xsl:if test="$element-name = 'fo:inline' and not($inline = 'true') and not(local-name(..) = 'admonition')">
			<xsl:choose>
				<xsl:when test="ancestor::gb:annex">
					<xsl:value-of select="$linebreak"/>
				</xsl:when>
				<xsl:otherwise>
					<fo:block margin-bottom="12pt">
						<xsl:value-of select="$linebreak"/>
					</fo:block>
				</xsl:otherwise>
			</xsl:choose>
			
		</xsl:if>
		<xsl:if test="$inline = 'true'">
			<fo:block>&#xA0;</fo:block>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="gb:li//gb:p//text()">
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
		<xsl:for-each select="//gb:p/gb:fn[generate-id(.)=generate-id(key('kfn',@reference)[1])]">
			<!-- copy unique fn -->
			<fn gen_id="{generate-id(.)}">
				<xsl:copy-of select="@*"/>
				<xsl:copy-of select="node()"/>
			</fn>
		</xsl:for-each>
	</xsl:variable>
	
	<xsl:template match="gb:p/gb:fn" priority="2">
		<xsl:variable name="gen_id" select="generate-id(.)"/>
		<xsl:variable name="reference" select="@reference"/>
		<xsl:variable name="number">
			<!-- <xsl:number level="any" count="gb:p/gb:fn"/> -->
			<xsl:value-of select="count(xalan:nodeset($p_fn)//fn[@reference = $reference]/preceding-sibling::fn) + 1" />
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="xalan:nodeset($p_fn)//fn[@gen_id = $gen_id]">
				<fo:footnote>
					<fo:inline font-size="60%" keep-with-previous.within-line="always" vertical-align="super">
						<fo:basic-link internal-destination="footnote_{@reference}_{$number}" fox:alt-text="footnote {@reference} {$number}">
							<!-- <xsl:value-of select="@reference"/> -->
							<xsl:value-of select="$number + count(//gb:bibitem[ancestor::gb:references[@id='_normative_references' or not(preceding-sibling::gb:references)]]/gb:note)"/>
						</fo:basic-link>
					</fo:inline>
					<fo:footnote-body>
						<fo:block font-size="9pt" margin-bottom="12pt">
							<fo:inline font-size="50%" id="footnote_{@reference}_{$number}" keep-with-next.within-line="always" vertical-align="super">
								<xsl:value-of select="$number + count(//gb:bibitem[ancestor::gb:references[@id='_normative_references' or not(preceding-sibling::gb:references)]]/gb:note)"/>
							</fo:inline>
							<xsl:for-each select="gb:p">
									<xsl:apply-templates />
							</xsl:for-each>
						</fo:block>
					</fo:footnote-body>
				</fo:footnote>
			</xsl:when>
			<xsl:otherwise>
				<fo:inline font-size="50%" keep-with-previous.within-line="always" vertical-align="super">
					<fo:basic-link internal-destination="footnote_{@reference}_{$number}" fox:alt-text="footnote {@reference} {$number}">
						<xsl:value-of select="$number + count(//gb:bibitem/gb:note)"/>
					</fo:basic-link>
				</fo:inline>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="gb:p/gb:fn/gb:p">
		<xsl:apply-templates />
	</xsl:template>
	
	<xsl:template match="gb:review">
		<!-- comment 2019-11-29 -->
		<!-- <fo:block font-weight="bold">Review:</fo:block>
		<xsl:apply-templates /> -->
	</xsl:template>

	<xsl:template match="text()">
		<xsl:value-of select="."/>
	</xsl:template>

	<xsl:template match="gb:image">
		<fo:block-container text-align="center">
			<fo:block>
				<fo:external-graphic src="{@src}" fox:alt-text="Image {@alt}"/>
			</fo:block>
			<fo:block font-family="SimHei" margin-top="12pt" margin-bottom="12pt">
				<xsl:value-of select="$title-figure"/>
				<xsl:call-template name="getFigureNumber"/>
			</fo:block>
		</fo:block-container>
	</xsl:template>

	<xsl:template match="gb:figure">
		<fo:block-container id="{@id}">
			<fo:block>
				<xsl:apply-templates />
			</fo:block>
			<xsl:call-template name="fn_display_figure"/>
			<xsl:for-each select="gb:note//gb:p">
				<xsl:call-template name="note"/>
			</xsl:for-each>
			<fo:block font-family="SimHei" text-align="center" margin-top="12pt" margin-bottom="12pt" keep-with-previous="always">
				<xsl:call-template name="getFigureNumber"/>
				<xsl:if test="gb:name">
					<xsl:if test="not(local-name(..) = 'figure')">
						<xsl:text> — </xsl:text>
					</xsl:if>
					<xsl:value-of select="gb:name"/>
				</xsl:if>
			</fo:block>
		</fo:block-container>
	</xsl:template>
	
	<xsl:template name="getFigureNumber">
		<xsl:choose>
			<xsl:when test="ancestor::gb:annex">
				<xsl:choose>
					<xsl:when test="local-name(..) = 'figure'">
						<!-- <xsl:number format="a) "/> -->
						<xsl:value-of select="$title-figure"/><xsl:number format="A.1-1" level="multiple" count="gb:annex | gb:figure"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$title-figure"/><xsl:number format="A.1-1" level="multiple" count="gb:annex | gb:figure"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$title-figure"/><xsl:number format="1" level="any"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="gb:figure/gb:name"/>
	<xsl:template match="gb:figure/gb:fn" priority="2"/>
	<xsl:template match="gb:figure/gb:note"/>
	
	
	<xsl:template match="gb:figure/gb:image">
		<fo:block text-align="center">
			<xsl:variable name="src">
				<xsl:choose>
					<xsl:when test="@mimetype = 'image/svg+xml' and $images/images/image[@id = current()/@id]">
						<xsl:value-of select="$images/images/image[@id = current()/@id]/@src"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="@src"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>		
			<fo:external-graphic  src="{$src}" width="100%" content-height="100%" content-width="scale-to-fit" scaling="uniform" fox:alt-text="Image {@alt}"/>  <!-- src="{@src}" -->
		</fo:block>
	</xsl:template>
	
	
	<xsl:template match="gb:bibitem">
		<fo:block id="{@id}" margin-bottom="12pt" text-indent="-11.7mm" margin-left="11.7mm"> <!-- 12 pt -->
				<!-- gb:docidentifier -->
			<xsl:if test="gb:docidentifier">
				<xsl:choose>
					<xsl:when test="gb:docidentifier/@type = 'metanorma'"/>
					<xsl:otherwise><fo:inline><xsl:value-of select="gb:docidentifier"/></fo:inline></xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:apply-templates select="gb:note"/>
			<xsl:if test="gb:docidentifier">, </xsl:if>
			<fo:inline font-style="italic">
				<xsl:choose>
					<xsl:when test="gb:title[@type = 'main' and @language = 'en']">
						<xsl:value-of select="gb:title[@type = 'main' and @language = 'en']"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="gb:title"/>
					</xsl:otherwise>
				</xsl:choose>
			</fo:inline>
		</fo:block>
	</xsl:template>
	
	
	<xsl:template match="gb:bibitem/gb:note">
		<fo:footnote>
			<xsl:variable name="number">
				<xsl:number level="any" count="gb:bibitem/gb:note"/>
			</xsl:variable>
			<fo:inline font-size="50%" keep-with-previous.within-line="always" baseline-shift="30%">
				<fo:basic-link internal-destination="footnote_{../@id}" fox:alt-text="footnote {$number}">
					<xsl:value-of select="$number"/>
				</fo:basic-link>
			</fo:inline>
			<fo:footnote-body>
				<fo:block font-size="9pt" margin-bottom="4pt" start-indent="0pt" text-indent="7.4mm">
					<fo:inline font-size="50%" id="footnote_{../@id}" keep-with-next.within-line="always" baseline-shift="30%"><!-- alignment-baseline="hanging" font-size="60%"  -->
						<xsl:value-of select="$number"/>
					</fo:inline>
					<xsl:apply-templates />
				</fo:block>
			</fo:footnote-body>
		</fo:footnote>
	</xsl:template>
	
	
	
	<xsl:template match="gb:ul | gb:ol">
		<fo:list-block margin-bottom="12pt" margin-left="7.4mm" provisional-distance-between-starts="4mm"> <!--   margin-bottom="8pt" -->
			<xsl:if test="local-name() = 'ol'">
				<xsl:attribute name="provisional-distance-between-starts">7mm</xsl:attribute>
			</xsl:if>			
			<xsl:apply-templates />
		</fo:list-block>
		<xsl:for-each select="./gb:note//gb:p">
			<xsl:call-template name="note"/>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="gb:ul//gb:note |  gb:ol//gb:note"/>
	
	<xsl:template match="gb:li">
		<fo:list-item id="{@id}">
			<fo:list-item-label end-indent="label-end()">
				<fo:block>
					<xsl:call-template name="getListItemFormat"/>
				</fo:block>
			</fo:list-item-label>
			<fo:list-item-body start-indent="body-start()">
				<xsl:apply-templates />
				<xsl:apply-templates select=".//gb:note" mode="process"/>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>
	
	<xsl:template match="gb:link">
		<fo:inline>
			<fo:basic-link external-destination="{@target}" fox:alt-text="{@target}"> <!-- color="blue" text-decoration="underline" -->
				<xsl:choose>
					<xsl:when test="normalize-space(.) = ''">
						<xsl:choose>
							<xsl:when test="starts-with(@target, 'mailto:')">
								<xsl:value-of select="substring-after(@target, 'mailto:')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="@target"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates />
					</xsl:otherwise>
				</xsl:choose>
			</fo:basic-link>
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="gb:term">
		<xsl:param name="sectionNum"/>
		<fo:block id="{@id}" font-family="SimHei" font-size="11pt" keep-with-next="always" margin-top="10pt" margin-bottom="8pt" line-height="1.1">
			<fo:inline>
				<xsl:variable name="section">
					<xsl:for-each select="*[1]">
						<xsl:call-template name="getSection">
							<xsl:with-param name="sectionNum" select="$sectionNum"/>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:variable>
				<xsl:value-of select="$section"/><xsl:text>.</xsl:text>
			</fo:inline>
		</fo:block>
		<fo:block>
			<xsl:apply-templates>
				<xsl:with-param name="sectionNum" select="$sectionNum"/>
			</xsl:apply-templates>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="gb:preferred">
		<xsl:param name="sectionNum"/>

		<fo:inline font-family="SimHei" font-size="11pt">
			<xsl:if test="not(preceding-sibling::*[1][local-name() = 'preferred'])">
				<xsl:attribute name="padding-left">7.4mm</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates /><xsl:text>&#x3000;</xsl:text>
		</fo:inline>
		
		<xsl:if test="not(following-sibling::*[1][local-name() = 'preferred'])">
			<xsl:value-of select="$linebreak"/>
		</xsl:if>

	</xsl:template>
	
	<xsl:template match="gb:admitted">
		<xsl:param name="sectionNum"/>
		
		<fo:inline font-size="11pt">
			<xsl:if test="not(preceding-sibling::*[1][local-name() = 'admitted'])">
				<xsl:attribute name="padding-left">7.4mm</xsl:attribute>
			</xsl:if>			
			<xsl:apply-templates /><xsl:text>&#x3000;</xsl:text>
		</fo:inline>
		
		<xsl:if test="not(following-sibling::*[1][local-name() = 'admitted'])">
			<xsl:value-of select="$linebreak"/>
		</xsl:if>
			
	</xsl:template>
	
	<xsl:template match="gb:deprecates">
		<xsl:param name="sectionNum"/>		
		<fo:inline font-size="11pt">
			<xsl:if test="not(preceding-sibling::*[1][local-name() = 'deprecates'])">
				<xsl:attribute name="padding-left">7.4mm</xsl:attribute>
				<fo:inline>DEPRECATED: </fo:inline>
			</xsl:if>
			<xsl:apply-templates />
		</fo:inline>
		<xsl:if test="not(following-sibling::*[1][local-name() = 'deprecates'])">
			<xsl:value-of select="$linebreak"/>
		</xsl:if>
		
	</xsl:template>
	
	<xsl:template match="gb:definition[preceding-sibling::gb:domain]">
		<xsl:apply-templates />
	</xsl:template>
	<xsl:template match="gb:definition[preceding-sibling::gb:domain]/gb:p">
		<fo:inline> <xsl:apply-templates /></fo:inline>
		<fo:block>&#xA0;</fo:block>
	</xsl:template>
	
	<xsl:template match="gb:definition">
		<fo:block>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="gb:termsource">
		<fo:block text-indent="7.4mm"> <!-- margin-bottom="8pt" keep-with-previous="always" -->
			<!-- Example: [SOURCE: ISO 5127:2017, 3.1.6.02] -->
			<fo:basic-link internal-destination="{gb:origin/@bibitemid}" fox:alt-text="{gb:origin/@citeas}">
				<xsl:text>[</xsl:text> <!-- SOURCE:  -->
				<xsl:value-of select="gb:origin/@citeas"/>
				
				<xsl:apply-templates select="gb:origin/gb:localityStack"/>
				
				<!-- <xsl:if test="gb:origin/gb:locality/gb:referenceFrom">
					<xsl:text>, </xsl:text><xsl:value-of select="gb:origin/gb:locality/gb:referenceFrom"/>
				</xsl:if> -->
			</fo:basic-link>
			<xsl:apply-templates select="gb:modification"/>
			<xsl:text>]</xsl:text>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="gb:modification">
		<xsl:text>, modified — </xsl:text>
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="gb:modification/gb:p">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="gb:modification/text()">
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="gb:termnote">
		<fo:block-container font-size="9pt" margin-left="7.4mm" margin-top="4pt" line-height="125%">
			<fo:block-container margin-left="0mm">
				<fo:table table-layout="fixed" width="100%">
					<fo:table-column column-width="27mm"/>
					<fo:table-column column-width="138mm"/>
					<fo:table-body>
						<fo:table-row>
							<fo:table-cell>
								<fo:block font-family="SimHei">
									<xsl:text>Note </xsl:text>
									<xsl:number />
									<xsl:text> to entry: </xsl:text>
								</fo:block>
							</fo:table-cell>
							<fo:table-cell>
								<fo:block>
									<xsl:apply-templates />
								</fo:block>
							</fo:table-cell>
						</fo:table-row>
					</fo:table-body>
				</fo:table>
			</fo:block-container>
		</fo:block-container>
	</xsl:template>
	
	<xsl:template match="gb:termnote/gb:p">
		<fo:inline><xsl:apply-templates/></fo:inline>
		<!-- <xsl:if test="following-sibling::* and not(following-sibling::gb:p)">
			<xsl:value-of select="$linebreak"/>
			<xsl:value-of select="$linebreak"/>
		</xsl:if> -->
	</xsl:template>
	
	<xsl:template match="gb:domain">
		<fo:inline padding-left="7.4mm">&lt;<xsl:apply-templates/>&gt; </fo:inline>
	</xsl:template>
	
	
	<xsl:template match="gb:termexample">
		<fo:block font-size="9pt" margin-top="14pt" margin-bottom="14pt"  text-align="justify">
			<fo:inline padding-right="1mm" font-family="SimHei">
				<xsl:text>EXAMPLE </xsl:text>
				<xsl:if test="count(ancestor::gb:term[1]//gb:termexample) &gt; 1">
					<xsl:number />
				</xsl:if>
				<xsl:text>:</xsl:text>
			</fo:inline>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="gb:termexample/gb:p">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template>

	
	<xsl:template match="gb:annex">
		<fo:block break-after="page"/>
		<xsl:apply-templates />
	</xsl:template>

	
	<!-- <xsl:template match="gb:references[@id = '_bibliography']"> -->
	<xsl:template match="gb:references[position() &gt; 1]">
		<fo:block break-after="page"/>
		<xsl:apply-templates />
		<fo:block-container text-align="center">
			<fo:block-container margin-left="63mm" width="42mm" border-bottom="2pt solid black">
				<fo:block>&#xA0;</fo:block>
			</fo:block-container>
		</fo:block-container>
	</xsl:template>


	<!-- Example: [1] ISO 9:1995, Information and documentation – Transliteration of Cyrillic characters into Latin characters – Slavic and non-Slavic languages -->
	<!-- <xsl:template match="gb:references[@id = '_bibliography']/gb:bibitem"> -->
	<xsl:template match="gb:references[position() &gt; 1]/gb:bibitem">
		<fo:list-block font-size="11pt" margin-bottom="12pt" provisional-distance-between-starts="12mm">
			<fo:list-item>
				<fo:list-item-label end-indent="label-end()">
					<fo:block>
						<fo:inline id="{@id}">
							<xsl:number format="[1]"/>
						</fo:inline>
					</fo:block>
				</fo:list-item-label>
				<fo:list-item-body start-indent="body-start()">
					<fo:block text-align="justify">
						<xsl:variable name="docidentifier">
							<xsl:if test="gb:docidentifier">
								<xsl:choose>
									<xsl:when test="gb:docidentifier/@type = 'metanorma'"/>
									<xsl:otherwise><xsl:value-of select="gb:docidentifier"/></xsl:otherwise>
								</xsl:choose>
							</xsl:if>
						</xsl:variable>
						<fo:inline><xsl:value-of select="$docidentifier"/></fo:inline>
						<xsl:apply-templates select="gb:note"/>
						<xsl:if test="normalize-space($docidentifier) != ''">, </xsl:if>
						<xsl:choose>
							<xsl:when test="gb:title[@type = 'main' and @language = 'en']">
								<xsl:apply-templates select="gb:title[@type = 'main' and @language = 'en']"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates select="gb:title"/>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:apply-templates select="gb:formattedref"/>
					</fo:block>
				</fo:list-item-body>
			</fo:list-item>
		</fo:list-block>
	</xsl:template>
	
	<!-- <xsl:template match="gb:references[@id = '_bibliography']/gb:bibitem" mode="contents"/> -->
	<xsl:template match="gb:references[position() &gt; 1]/gb:bibitem" mode="contents"/>
	
	<!-- <xsl:template match="gb:references[@id = '_bibliography']/gb:bibitem/gb:title"> -->
	<xsl:template match="gb:references[position() &gt; 1]/gb:bibitem/gb:title">
		<fo:inline font-style="italic">
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>

	<xsl:template match="gb:quote">
		<fo:block margin-top="12pt" margin-left="12mm" margin-right="12mm">
			<xsl:apply-templates select=".//gb:p"/>
		</fo:block>
		<fo:block text-align="right">
			<!-- — ISO, ISO 7301:2011, Clause 1 -->
			<xsl:text>— </xsl:text><xsl:value-of select="gb:author"/>
			<xsl:if test="gb:source">
				<xsl:text>, </xsl:text>
				<xsl:apply-templates select="gb:source"/>
			</xsl:if>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="gb:source">
		<fo:basic-link internal-destination="{@bibitemid}" fox:alt-text="{@citeas}">
			<xsl:value-of select="@citeas" disable-output-escaping="yes"/>
			<xsl:apply-templates select="gb:localityStack"/>
		</fo:basic-link>
	</xsl:template>
	
	<xsl:template match="gb:appendix">
		<fo:block font-size="12pt" font-weight="bold" margin-top="12pt" margin-bottom="12pt">
			<fo:inline padding-right="5mm">Appendix <xsl:number /></fo:inline>
			<xsl:apply-templates select="gb:title" mode="process"/>
		</fo:block>
		<xsl:apply-templates />
	</xsl:template>
	
	<xsl:template match="gb:appendix//gb:example">
		<fo:block font-size="10pt" margin-top="8pt" margin-bottom="8pt">
			<xsl:variable name="claims_id" select="ancestor::gb:clause[1]/@id"/>
			<xsl:text>EXAMPLE </xsl:text>
			<xsl:if test="count(ancestor::gb:clause[1]//gb:example) &gt; 1">
					<xsl:number count="gb:example[ancestor::gb:clause[@id = $claims_id]]" level="any"/><xsl:text> </xsl:text>
				</xsl:if>
			<xsl:if test="gb:name">
				<xsl:text>— </xsl:text><xsl:apply-templates select="gb:name" mode="process"/>
			</xsl:if>
		</fo:block>
		<xsl:apply-templates />
	</xsl:template>
	
	<xsl:template match="gb:appendix//gb:example/gb:name"/>
	<xsl:template match="gb:appendix//gb:example/gb:name" mode="process">
		<fo:inline><xsl:apply-templates /></fo:inline>
	</xsl:template>
	
	<!-- <xsl:template match="gb:callout/text()">	
		<fo:basic-link internal-destination="{@target}"><fo:inline>&lt;<xsl:apply-templates />&gt;</fo:inline></fo:basic-link>
	</xsl:template> -->
	<xsl:template match="gb:callout">		
			<fo:basic-link internal-destination="{@target}" fox:alt-text="{@target}">&lt;<xsl:apply-templates />&gt;</fo:basic-link>
	</xsl:template>
	
	<xsl:template match="gb:annotation">
		<fo:block>
			
		</fo:block>
		<xsl:apply-templates />
	</xsl:template>
	
	<xsl:template match="gb:annotation/text()"/>
	
	<xsl:template match="gb:annotation/gb:p">
		<xsl:variable name="annotation-id" select="../@id"/>
		<xsl:variable name="callout" select="//*[@target = $annotation-id]/text()"/>
		<fo:block id="{$annotation-id}">
			<xsl:value-of select="concat('&lt;', $callout, '&gt; ')"/>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	
	<xsl:template match="gb:appendix/gb:title"/>
	<xsl:template match="gb:appendix/gb:title" mode="process">
		<fo:inline><xsl:apply-templates /></fo:inline>
	</xsl:template>
	
	<xsl:template match="mathml:math" priority="2">
		<fo:inline font-family="Cambria Math">
			<fo:instream-foreign-object fox:alt-text="Math">
				<xsl:copy-of select="."/>
			</fo:instream-foreign-object>
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="gb:xref">
		<xsl:param name="sectionNum"/>
		
		<xsl:variable name="target" select="normalize-space(@target)"/>
		<fo:basic-link internal-destination="{$target}" fox:alt-text="{$target}">
			<xsl:variable name="section" select="xalan:nodeset($contents)//item[@id = $target]/@section"/>
			<!-- <xsl:if test="not(starts-with($section, 'Figure') or starts-with($section, 'Table'))"> -->
				<!-- <xsl:attribute name="color">blue</xsl:attribute>
				<xsl:attribute name="text-decoration">underline</xsl:attribute> -->
			<!-- </xsl:if> -->
			<xsl:variable name="type" select="xalan:nodeset($contents)//item[@id = $target]/@type"/>
			<xsl:variable name="root" select="xalan:nodeset($contents)//item[@id =$target]/@root"/>
			<xsl:variable name="level" select="xalan:nodeset($contents)//item[@id =$target]/@level"/>
			<xsl:choose>
				<xsl:when test="$type = 'clause' and $root != 'annex' and $level = 1">Clause </xsl:when><!-- and not (ancestor::annex) -->
				<xsl:when test="$type = 'clause' and $root = 'annex'">Annex </xsl:when>
				<xsl:when test="$type = 'li'">
					<xsl:attribute name="color">black</xsl:attribute>
					<xsl:attribute name="text-decoration">none</xsl:attribute>
					<xsl:variable name="parent_section" select="xalan:nodeset($contents)//item[@id =$target]/@parent_section"/>
					<xsl:variable name="currentSection">
						<xsl:call-template name="getSection"/>
					</xsl:variable>
					<xsl:if test="not(contains($parent_section, $currentSection))">
						<fo:basic-link internal-destination="{$target}" fox:alt-text="{$target}">
							<xsl:attribute name="color">blue</xsl:attribute>
							<xsl:attribute name="text-decoration">underline</xsl:attribute>
							<xsl:value-of select="$parent_section"/><xsl:text> </xsl:text>
						</fo:basic-link>
					</xsl:if>
				</xsl:when>
				<xsl:when test="normalize-space($section) = ''">
					<xsl:text>[</xsl:text><xsl:value-of select="$target"/><xsl:text>]</xsl:text>
				</xsl:when>
				<xsl:otherwise></xsl:otherwise> <!-- <xsl:value-of select="$type"/> -->
			</xsl:choose>
			<xsl:value-of select="$section"/>
      </fo:basic-link>
	</xsl:template>

	<xsl:template match="gb:sourcecode">
		<fo:block font-family="Courier" font-size="9pt" margin-bottom="12pt">
			<xsl:choose>
				<xsl:when test="@lang = 'en'"></xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="white-space">pre</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="gb:example/gb:p">
		<fo:block font-size="10pt" margin-top="8pt" margin-bottom="8pt">
			<!-- <xsl:if test="ancestor::gb:li">
				<xsl:attribute name="font-size">11pt</xsl:attribute>
			</xsl:if> -->
			<xsl:variable name="claims_id" select="ancestor::gb:clause[1]/@id"/>
			<fo:inline padding-right="5mm">
				<xsl:text>EXAMPLE </xsl:text>
				<xsl:if test="count(ancestor::gb:clause[1]//gb:example) &gt; 1">
					<xsl:number count="gb:example[ancestor::gb:clause[@id = $claims_id]]" level="any"/>
				</xsl:if>
			</fo:inline>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="gb:note/gb:p" name="note">
		<xsl:variable name="claims_id" select="ancestor::gb:clause[1]/@id"/>
		<fo:block-container font-size="9pt" margin-left="7.4mm" margin-top="4pt" line-height="125%">
			<fo:block-container margin-left="0mm">
				<fo:table table-layout="fixed" width="100%">
					<fo:table-column column-width="10mm"/>
					<fo:table-column column-width="155mm"/>
					<fo:table-body>
						<fo:table-row>
							<fo:table-cell>
								<fo:block font-family="SimHei">
									<xsl:text>NOTE</xsl:text>
									<xsl:if test="count(ancestor::gb:clause[1]//gb:note) &gt; 1">
										<xsl:text> </xsl:text><xsl:number count="gb:note[ancestor::gb:clause[@id = $claims_id]]" level="any"/>
									</xsl:if>
									<xsl:text>:</xsl:text>
								</fo:block>
							</fo:table-cell>
							<fo:table-cell>
								<fo:block text-align="justify">
									<xsl:apply-templates />
								</fo:block>
							</fo:table-cell>
						</fo:table-row>
					</fo:table-body>
				</fo:table>
			</fo:block-container>
		</fo:block-container>
	</xsl:template>

	<!-- <eref type="inline" bibitemid="IEC60050-113" citeas="IEC 60050-113:2011"><localityStack><locality type="clause"><referenceFrom>113-01-12</referenceFrom></locality></localityStack></eref> -->
	<xsl:template match="gb:eref">
		<fo:basic-link internal-destination="{@bibitemid}" fox:alt-text="{@citeas}"> <!-- font-size="9pt" color="blue" vertical-align="super" -->
			<xsl:if test="@type = 'footnote'">
				<xsl:attribute name="keep-together.within-line">always</xsl:attribute>
				<xsl:attribute name="font-size">50%</xsl:attribute>
				<xsl:attribute name="keep-with-previous.within-line">always</xsl:attribute>
				<xsl:attribute name="vertical-align">super</xsl:attribute>
			</xsl:if>
			<!-- <xsl:if test="@type = 'inline'">
				<xsl:attribute name="color">blue</xsl:attribute>
				<xsl:attribute name="text-decoration">underline</xsl:attribute>
			</xsl:if> -->
			
			<xsl:choose>
				<xsl:when test="@citeas and normalize-space(text()) = ''">
					<xsl:value-of select="@citeas" disable-output-escaping="yes"/>
				</xsl:when>
				<xsl:when test="@bibitemid and normalize-space(text()) = ''">
					<xsl:value-of select="//gb:bibitem[@id = current()/@bibitemid]/gb:docidentifier"/>
				</xsl:when>
				<xsl:otherwise></xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates select="gb:localityStack"/>
			<xsl:apply-templates select="text()"/>
		</fo:basic-link>
	</xsl:template>
	
	<xsl:template match="gb:locality">
		<xsl:choose>
			<xsl:when test="@type ='section' and ancestor::gb:termsource">SOURCE Section </xsl:when>
			<xsl:when test="ancestor::gb:termsource"></xsl:when>
			<xsl:when test="@type ='clause' and ancestor::gb:eref"></xsl:when>
			<xsl:when test="@type ='clause'">Clause </xsl:when>
			<xsl:when test="@type ='annex'">Annex </xsl:when>
			<xsl:when test="@type ='table'">Table </xsl:when>
			<xsl:otherwise><xsl:value-of select="@type"/></xsl:otherwise>
		</xsl:choose>
		<xsl:text> </xsl:text><xsl:value-of select="gb:referenceFrom"/>
	</xsl:template>
	
	<xsl:template match="gb:admonition">
		<fo:block font-family="SimHei" text-align="center" margin-bottom="12pt" font-weight="bold">
			<xsl:value-of select="translate(@type, $lower, $upper)"/>
		</fo:block>
		<fo:block font-weight="bold">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="gb:formula/gb:dt/gb:stem">
		<fo:inline>
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="gb:formula/gb:stem">
		<fo:block id="{../@id}" font-size="11pt" margin-top="14pt" margin-bottom="14pt">
			<fo:table table-layout="fixed" width="170mm">
				<fo:table-column column-width="165mm"/>
				<fo:table-column column-width="5mm"/>
				<fo:table-body>
					<fo:table-row>
						<fo:table-cell display-align="center">
							<fo:block text-align="center">
								<xsl:apply-templates />
							</fo:block>
						</fo:table-cell>
						<fo:table-cell display-align="center">
							<fo:block text-align="left">
								<xsl:choose>
									<xsl:when test="ancestor::gb:annex">
										<xsl:text>(</xsl:text><xsl:number format="A.1" level="multiple" count="gb:annex | gb:formula"/><xsl:text>)</xsl:text>
									</xsl:when>
									<xsl:otherwise> <!-- not(ancestor::gb:annex) -->
										<xsl:text>(</xsl:text><xsl:number level="any" count="gb:formula"/><xsl:text>)</xsl:text>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</fo:table-body>
			</fo:table>
			<fo:inline keep-together.within-line="always">
			</fo:inline>
		</fo:block>
	</xsl:template>
	
	
	<xsl:template match="gb:br" priority="2">
		<!-- <fo:block>&#xA0;</fo:block> -->
		<xsl:value-of select="$linebreak"/>
	</xsl:template>
	
	<xsl:template name="insertHeaderFooter">
		<fo:static-content flow-name="header">
			<fo:block-container height="30mm" display-align="after">
				<fo:block font-family="SimHei" font-size="12pt">
					<xsl:value-of select="/gb:gb-standard/gb:bibdata/gb:docidentifier[@type = 'gb']"/>
					<xsl:text>—</xsl:text>
					<xsl:value-of select="/gb:gb-standard/gb:bibdata/gb:copyright/gb:from"/>
				</fo:block>
			</fo:block-container>
		</fo:static-content>
		<fo:static-content flow-name="footer-odd">
			<fo:block-container height="100%" display-align="after">
				<fo:block-container height="14.5mm" display-align="before">
					<fo:block font-size="9pt" text-align="right" margin-right="3.5mm">
						<fo:page-number/>
					</fo:block>
				</fo:block-container>
			</fo:block-container>
		</fo:static-content>
		<fo:static-content flow-name="footer-even">
			<fo:block-container height="100%" display-align="after">
				<fo:block-container height="14.5mm" display-align="before">
					<fo:block font-size="9pt">
						<fo:page-number/>
					</fo:block>
				</fo:block-container>
			</fo:block-container>
		</fo:static-content>
	</xsl:template>
	
	<xsl:template name="insertHeaderFooter2">
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
	
	<xsl:template name="getId">
		<xsl:choose>
			<xsl:when test="../@id">
				<xsl:value-of select="../@id"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="text()"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="getLevel">
		<xsl:variable name="level_total" select="count(ancestor::*)"/>
		<xsl:variable name="level">
			<xsl:choose>
				<xsl:when test="ancestor::gb:preface">
					<xsl:value-of select="$level_total - 2"/>
				</xsl:when>
				<xsl:when test="ancestor::gb:sections">
					<xsl:value-of select="$level_total - 2"/>
				</xsl:when>
				<xsl:when test="ancestor::gb:bibliography">
					<xsl:value-of select="$level_total - 2"/>
				</xsl:when>
				<xsl:when test="local-name(ancestor::*[1]) = 'annex'">1</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$level_total - 1"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$level"/>
	</xsl:template>

	<xsl:template name="getSection">
		<xsl:param name="sectionNum"/>
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		<xsl:variable name="section">
			<xsl:choose>
				<xsl:when test="ancestor::gb:bibliography">
					<xsl:value-of select="$sectionNum"/>
				</xsl:when>
				<xsl:when test="ancestor::gb:sections">
					<!-- 1, 2, 3, 4, ... from main section (not annex, bibliography, ...) -->
					<xsl:choose>
						<xsl:when test="$level = 1">
							<xsl:value-of select="$sectionNum"/>
						</xsl:when>
						<xsl:when test="$level &gt;= 2">
							<xsl:variable name="num">
								<xsl:number format=".1" level="multiple" count="gb:clause/gb:clause | 
																																										gb:clause/gb:terms | 
																																										gb:terms/gb:term | 
																																										gb:clause/gb:term |  
																																										gb:terms/gb:clause |
																																										gb:terms/gb:definitions |
																																										gb:definitions/gb:clause |
																																										gb:clause/gb:definitions"/>
							</xsl:variable>
							<xsl:value-of select="concat($sectionNum, $num)"/>
						</xsl:when>
						<xsl:otherwise>
							<!-- z<xsl:value-of select="$sectionNum"/>z -->
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<!-- <xsl:when test="ancestor::gb:annex[@obligation = 'informative']">
					<xsl:choose>
						<xsl:when test="$level = 1">
							<xsl:text>Annex  </xsl:text>
							<xsl:number format="I" level="any" count="gb:annex[@obligation = 'informative']"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:number format="I.1" level="multiple" count="gb:annex[@obligation = 'informative'] | gb:clause"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when> -->
				<xsl:when test="ancestor::gb:annex">
					<xsl:variable name="annexid" select="normalize-space(/gb:gb-standard/gb:bibdata/gb:ext/gb:structuredidentifier/gb:annexid)"/>
					<xsl:choose>
						<xsl:when test="$level = 1">
							<xsl:text>Annex </xsl:text>
							<xsl:choose>
								<xsl:when test="count(//gb:annex) = 1 and $annexid != ''">
									<xsl:value-of select="$annexid"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:number format="A" level="any" count="gb:annex"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="annexid" select="normalize-space(/gb:gb-standard/gb:bibdata/gb:ext/gb:structuredidentifier/gb:annexid)"/>
							<xsl:choose>
								<xsl:when test="count(//gb:annex) = 1 and $annexid != ''">
									<xsl:value-of select="$annexid"/><xsl:number format=".1" level="multiple" count="gb:clause"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:number format="A.1" level="multiple" count="gb:annex | gb:clause"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="ancestor::gb:preface"> <!-- if preface and there is clause(s) -->
					<xsl:choose>
						<xsl:when test="$level = 1 and  ..//gb:clause">0</xsl:when>
						<xsl:when test="$level &gt;= 2">
							<xsl:variable name="num">
								<xsl:number format=".1" level="multiple" count="gb:clause"/>
							</xsl:variable>
							<xsl:value-of select="concat('0', $num)"/>
						</xsl:when>
						<xsl:otherwise>
							<!-- z<xsl:value-of select="$sectionNum"/>z -->
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$section"/>
	</xsl:template>

	
	<xsl:variable name="Image-GB-Logo">
		<xsl:text>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</xsl:text>
	</xsl:variable>
	
	<xsl:variable name="Image-IEC-Logo">
		<xsl:text>iVBORw0KGgoAAAANSUhEUgAAAOwAAADlCAYAAABQ3BvcAAAAGXRFWHRTb2Z0d2FyZQBBZG9i
			ZSBJbWFnZVJlYWR5ccllPAAAA39pVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tl
			dCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1l
			dGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUu
			Ni1jMDE0IDc5LjE1Njc5NywgMjAxNC8wOC8yMC0wOTo1MzowMiAgICAgICAgIj4gPHJkZjpS
			REYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgt
			bnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6
			Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRv
			YmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9u
			cy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6QUZCNjhD
			NjM3QTUxMTFFQUE0MDdDNjQ1OTIxQjc1Q0IiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6
			QUZCNjhDNjI3QTUxMTFFQUE0MDdDNjQ1OTIxQjc1Q0IiIHhtcDpDcmVhdG9yVG9vbD0iTW96
			aWxsYS81LjAgKE1hY2ludG9zaDsgSW50ZWwgTWFjIE9TIFggMTBfMTRfNikgQXBwbGVXZWJL
			aXQvNTM3LjM2IChLSFRNTCwgbGlrZSBHZWNrbykgQ2hyb21lLzc3LjAuMzg2NS45MCBTYWZh
			cmkvNTM3LjM2Ij4gPHhtcE1NOkRlcml2ZWRGcm9tIHN0UmVmOmluc3RhbmNlSUQ9InV1aWQ6
			OGRjOTFlYTktMGJlYy00YjJiLWI5ZjctYTNlMjA3ZTBiM2RjIiBzdFJlZjpkb2N1bWVudElE
			PSJ1dWlkOmZmYjEyOTA0LTcyNWItNGRlOS1iNTYxLWU3YmY0YjEzMDMyZSIvPiA8L3JkZjpE
			ZXNjcmlwdGlvbj4gPC9yZGY6UkRGPiA8L3g6eG1wbWV0YT4gPD94cGFja2V0IGVuZD0iciI/
			PuNo9+0AAA5WSURBVHja7J1pkBXlFYYPEQRlFAxjQFExIho0igY3NJAyRkVErTJKTFwTo0lc
			UdyIK2i5gFvFRI0aV1BBQDRaMYLEBTXGjS2ZuCO4sOjIKKIMAjkn/VlSFMz0vff0dud5qt7i
			xzSnu7/u9/a3n1bdu205UUQOEQDIO8O+RRkAFAcMC4BhAQDDAmBYAMCwAIBhATAsAGBYAMCw
			ABgWADAsAGBYAAwLABgWADAsAIYFAAwLABgWAMMCAIYFAAwLgGEBAMMCAIYFwLAAgGEBAMMC
			YFgAwLAAgGEBMCwAYFgAwLAAGBYAMCwAYFgADAsAGBYAMCwAhgUADAsAGBYAwwIAhgUADAuA
			YQEgW1pTBFAgPlW9qZob9LFqkapRtUTVUbWuagPVJqotgrpXy7uOYSHPzFZNUj2tekn1umpF
			GXHaqnZU9Vb1Ue0bDI1hm6PLJl2k9Tq+p21ctkwWzJ+fh/JcrFpeoOffLrzMeeIV1f2qiao3
			nGIuVb0YdLOqVTDwANVhqh9g2LUwZtw46dq1q2vMuro6OeiAAVmU39uq+8JX4NVQZSsSl6gu
			zsF1WNX2dtUtocqbNCtV04OuCNXmY1WnqjbO8wOj06k83gi/zD1UF6ieKqBZ88BM1XEq+wU/
			JyWzrok5qktV3VS/Ub2HYauH60N1anyZ7SkQ+afqAFUv1V2hypoHvghf+W1Ul6mWYdjiYuY8
			XnWG6kuKoyzmharnnqrHQtU0j5hxL1Ttai0uDFtMfhvaWVAe1tbfVnV3jo26OtODacfm5YIY
			1omHVZNupRjKwsZHT034x65GtZdqJ9VWqs4SjclalbZB9YHqNdXLEg0PfVVC7M9VR4R27ZkY
			Nv+8rzqLYiiLD1UDJRqq8aZ3iL2fanfVOjH/n3UOPhq+9H+P+bW3Y4aEH4BzMWy+sc6HzyiG
			knlLtX/41wubwXRi6EvoWWaMDVU/D7KJGMNDdT1OB+J5qvaqUzBsPrHxwTsSir29ajdVhwzv
			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
			QDH4nwADAD8qVGA5YSc/AAAAAElFTkSuQmCC
			</xsl:text>
	</xsl:variable>
	
	<xsl:variable name="Image-Attention">
		<xsl:text>
			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
		</xsl:text>
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
		<xsl:variable name="edition" select="normalize-space(/gb:gb-standard/gb:bibdata/gb:edition)"/>
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
		<xsl:if test="$edition != ''"><xsl:text> edition</xsl:text></xsl:if>
	</xsl:template>

	<xsl:template name="addLetterSpacing">
		<xsl:param name="text"/>
		<xsl:param name="letter-spacing" select="'0.15'"/>
		<xsl:if test="string-length($text) &gt; 0">
			<xsl:variable name="char" select="substring($text, 1, 1)"/>
			<fo:inline padding-right="{$letter-spacing}mm"><xsl:value-of select="$char"/></fo:inline>
			<xsl:call-template name="addLetterSpacing">
				<xsl:with-param name="text" select="substring($text, 2)"/>
				<xsl:with-param name="letter-spacing" select="$letter-spacing"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
</xsl:stylesheet>
