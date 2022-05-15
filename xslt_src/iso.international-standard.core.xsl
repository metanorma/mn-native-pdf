<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
											xmlns:fo="http://www.w3.org/1999/XSL/Format" 
											xmlns:iso="https://www.metanorma.org/ns/iso" 
											xmlns:mathml="http://www.w3.org/1998/Math/MathML" 
											xmlns:xalan="http://xml.apache.org/xalan" 
											xmlns:fox="http://xmlgraphics.apache.org/fop/extensions" 
											xmlns:pdf="http://xmlgraphics.apache.org/fop/extensions/pdf"
											xmlns:xlink="http://www.w3.org/1999/xlink"
											xmlns:java="http://xml.apache.org/xalan/java"
											exclude-result-prefixes="java"
											version="1.0">

	<xsl:output method="xml" encoding="UTF-8" indent="no"/>
	
	<xsl:include href="./common.xsl"/>

	<xsl:key name="kfn" match="*[local-name() = 'fn'][not(ancestor::*[(local-name() = 'table' or local-name() = 'figure') and not(ancestor::*[local-name() = 'name'])])]" use="@reference"/>
	
	<xsl:key name="attachments" match="iso:eref[contains(@bibitemid, '.exp')]" use="@bibitemid"/>
	
	<xsl:variable name="namespace">iso</xsl:variable>
	
	<xsl:variable name="namespace_full">https://www.metanorma.org/ns/iso</xsl:variable>
	
	<xsl:variable name="debug">false</xsl:variable>
	
	<xsl:variable name="docidentifierISO_undated" select="normalize-space(/iso:iso-standard/iso:bibdata/iso:docidentifier[@type = 'iso-undated'])"/>
	<xsl:variable name="docidentifierISO_">
		<xsl:value-of select="$docidentifierISO_undated"/>
		<xsl:if test="$docidentifierISO_undated = ''">
			<xsl:value-of select="/iso:iso-standard/iso:bibdata/iso:docidentifier[@type = 'iso'] | /iso:iso-standard/iso:bibdata/iso:docidentifier[@type = 'ISO']"/>
		</xsl:if>
	</xsl:variable>
	<xsl:variable name="docidentifierISO" select="normalize-space($docidentifierISO_)"/>

	<xsl:variable name="all_rights_reserved">
		<xsl:call-template name="getLocalizedString">
			<xsl:with-param name="key">all_rights_reserved</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>	
	<xsl:variable name="copyrightYear" select="/iso:iso-standard/iso:bibdata/iso:copyright/iso:from"/>
	<xsl:variable name="copyrightAbbr_">
		<xsl:for-each select="/iso:iso-standard/iso:bibdata/iso:copyright/iso:owner/iso:organization/iso:abbreviation">
			<xsl:value-of select="."/><xsl:if test="position() != last()">/</xsl:if>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="copyrightAbbr" select="normalize-space($copyrightAbbr_)"/>
	<xsl:variable name="copyrightText" select="concat('© ', $copyrightAbbr, ' ', $copyrightYear ,' – ', $all_rights_reserved)"/>
  
	<xsl:variable name="lang-1st-letter_tmp" select="substring-before(substring-after(/iso:iso-standard/iso:bibdata/iso:docidentifier[@type = 'iso-with-lang'], '('), ')')"/>
	<xsl:variable name="lang-1st-letter" select="concat('(', $lang-1st-letter_tmp , ')')"/>
  
	<!-- <xsl:variable name="ISOname" select="concat(/iso:iso-standard/iso:bibdata/iso:docidentifier, ':', /iso:iso-standard/iso:bibdata/iso:copyright/iso:from , $lang-1st-letter)"/> -->
	<xsl:variable name="ISOname" select="/iso:iso-standard/iso:bibdata/iso:docidentifier[@type = 'iso-reference']"/>

	<xsl:variable name="part" select="/iso:iso-standard/iso:bibdata/iso:ext/iso:structuredidentifier/iso:project-number/@part"/>
	
	<xsl:variable name="doctype" select="/iso:iso-standard/iso:bibdata/iso:ext/iso:doctype"/>	 
  <xsl:variable name="doctype_localized" select="/iso:iso-standard/iso:bibdata/iso:ext/iso:doctype[@language = $lang]"/>
    
	<xsl:variable name="doctype_uppercased">
    <xsl:choose>
      <xsl:when test="$doctype_localized != ''">
        <xsl:value-of select="java:toUpperCase(java:java.lang.String.new(translate(normalize-space($doctype_localized),'-',' ')))"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="java:toUpperCase(java:java.lang.String.new(translate(normalize-space($doctype),'-',' ')))"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable> 
	 	
	<xsl:variable name="stage" select="number(/iso:iso-standard/iso:bibdata/iso:status/iso:stage)"/>
	<xsl:variable name="substage" select="number(/iso:iso-standard/iso:bibdata/iso:status/iso:substage)"/>	
	<xsl:variable name="stagename" select="normalize-space(/iso:iso-standard/iso:bibdata/iso:ext/iso:stagename)"/>
	<xsl:variable name="stagename_localized" select="normalize-space(/iso:iso-standard/iso:bibdata/iso:status/iso:stage[@language = $lang])"/>
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
			<xsl:when test="$stagename_localized != ''">
				<xsl:value-of select="java:toUpperCase(java:java.lang.String.new($stagename_localized))"/>
			</xsl:when>
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
	<xsl:variable name="contents_">
		<contents>
			<xsl:call-template name="processPrefaceSectionsDefault_Contents"/>
			<xsl:call-template name="processMainSectionsDefault_Contents"/>
			<xsl:apply-templates select="//iso:indexsect" mode="contents"/>
			<xsl:call-template name="processTablesFigures_Contents"/>
		</contents>
	</xsl:variable>
	<xsl:variable name="contents" select="xalan:nodeset($contents_)"/>
	
	<xsl:variable name="lang_other">
		<xsl:for-each select="/iso:iso-standard/iso:bibdata/iso:title[@language != $lang]">
			<xsl:if test="not(preceding-sibling::iso:title[@language = current()/@language])">
				<lang><xsl:value-of select="@language"/></lang>
			</xsl:if>
		</xsl:for-each>
	</xsl:variable>
	
	<xsl:variable name="editorialgroup_">
		<xsl:variable name="data">
			<xsl:for-each select="/iso:iso-standard/iso:bibdata/iso:ext/iso:editorialgroup/iso:technical-committee[normalize-space(@number) != '']">
				<xsl:text>/TC </xsl:text><fo:inline font-weight="bold"><xsl:value-of select="@number"/></fo:inline>
			</xsl:for-each>
			<xsl:for-each select="/iso:iso-standard/iso:bibdata/iso:ext/iso:editorialgroup/iso:subcommittee[normalize-space(@number) != '']">
				<xsl:text>/SC </xsl:text><fo:inline font-weight="bold"><xsl:value-of select="@number"/></fo:inline>
			</xsl:for-each>
			<xsl:if test="not($stage-abbreviation = 'DIS' or $stage-abbreviation = 'FDIS')">
				<xsl:for-each select="/iso:iso-standard/iso:bibdata/iso:ext/iso:editorialgroup/iso:workgroup[normalize-space(@number) != '']">
					<xsl:text>/WG </xsl:text><fo:inline font-weight="bold"><xsl:value-of select="@number"/></fo:inline>
				</xsl:for-each>
			</xsl:if>
		</xsl:variable>
		<xsl:if test="normalize-space($data) != ''">
			<xsl:text>ISO</xsl:text><xsl:copy-of select="$data"/>
		</xsl:if>
	</xsl:variable>
	<xsl:variable name="editorialgroup" select="xalan:nodeset($editorialgroup_)" />
	
	<xsl:variable name="secretariat_">
		<xsl:variable name="value" select="normalize-space(/iso:iso-standard/iso:bibdata/iso:ext/iso:editorialgroup/iso:secretariat)"/>
		<xsl:if test="$value != ''">
			<xsl:call-template name="getLocalizedString">
				<xsl:with-param name="key">secretariat</xsl:with-param>
			</xsl:call-template>
			<xsl:text>: </xsl:text>
			<fo:inline font-weight="bold"><xsl:value-of select="$value"/></fo:inline>
		</xsl:if>
	</xsl:variable>
	<xsl:variable name="secretariat" select="xalan:nodeset($secretariat_)" />
	
	<xsl:variable name="ics_">
		<xsl:for-each select="/iso:iso-standard/iso:bibdata/iso:ext/iso:ics/iso:code">
			<xsl:if test="position() = 1"><fo:inline>ICS: </fo:inline></xsl:if>
			<xsl:value-of select="."/>
			<xsl:if test="position() != last()"><xsl:text>; </xsl:text></xsl:if>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="ics" select="xalan:nodeset($ics_)"/>
	
	<xsl:variable name="XML" select="/"/>
	
	<xsl:template match="/">
		<xsl:call-template name="namespaceCheck"/>
		<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format" xml:lang="{$lang}">
			
			<xsl:variable name="root-style">
				<root-style xsl:use-attribute-sets="root-style">
					<xsl:if test="$lang = 'zh'">
						<xsl:attribute name="font-family">Source Han Sans, Times New Roman, Cambria Math</xsl:attribute>
					</xsl:if>
				</root-style>
			</xsl:variable>
			<xsl:call-template name="insertRootStyle">
				<xsl:with-param name="root-style" select="$root-style"/>
			</xsl:call-template>
			
			<fo:layout-master-set>
				
				<!-- cover page -->
				<fo:simple-page-master master-name="cover-page" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
					<fo:region-body margin-top="25.4mm" margin-bottom="25.4mm" margin-left="31.7mm" margin-right="31.7mm"/>
					<fo:region-before region-name="cover-page-header" extent="25.4mm" />
					<fo:region-after/>
					<fo:region-start region-name="cover-left-region" extent="31.7mm"/>
					<fo:region-end region-name="cover-right-region" extent="31.7mm"/>
				</fo:simple-page-master>
				
				<fo:simple-page-master master-name="cover-page-published" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
					<fo:region-body margin-top="12.7mm" margin-bottom="40mm" margin-left="78mm" margin-right="18.5mm"/>
					<fo:region-before region-name="cover-page-header" extent="12.7mm" />
					<fo:region-after region-name="cover-page-footer" extent="40mm" display-align="after" />
					<fo:region-start region-name="cover-left-region" extent="78mm"/>
					<fo:region-end region-name="cover-right-region" extent="18.5mm"/>
				</fo:simple-page-master>
				
				
				<fo:simple-page-master master-name="cover-page-publishedISO-odd" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
					<fo:region-body margin-top="12.7mm" margin-bottom="40mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
					<fo:region-before region-name="cover-page-header" extent="12.7mm" />
					<fo:region-after region-name="cover-page-footer" extent="40mm" display-align="after" />
					<fo:region-start region-name="cover-left-region" extent="{$marginLeftRight1}mm"/>
					<fo:region-end region-name="cover-right-region" extent="{$marginLeftRight2}mm"/>
				</fo:simple-page-master>
				<fo:simple-page-master master-name="cover-page-publishedISO-even" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
					<fo:region-body margin-top="12.7mm" margin-bottom="40mm" margin-left="{$marginLeftRight2}mm" margin-right="{$marginLeftRight1}mm"/>
					<fo:region-before region-name="cover-page-header" extent="12.7mm" />
					<fo:region-after region-name="cover-page-footer" extent="40mm" display-align="after" />
					<fo:region-start region-name="cover-left-region" extent="{$marginLeftRight2}mm"/>
					<fo:region-end region-name="cover-right-region" extent="{$marginLeftRight1}mm"/>
				</fo:simple-page-master>
				<fo:page-sequence-master master-name="cover-page-publishedISO">
					<fo:repeatable-page-master-alternatives>
						<fo:conditional-page-master-reference odd-or-even="even" master-reference="cover-page-publishedISO-even"/>
						<fo:conditional-page-master-reference odd-or-even="odd" master-reference="cover-page-publishedISO-odd"/>
					</fo:repeatable-page-master-alternatives>
				</fo:page-sequence-master>


				<!-- contents pages -->
				<!-- odd pages -->
				<fo:simple-page-master master-name="odd" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
					<fo:region-body margin-top="27.4mm" margin-bottom="{$marginBottom + 2}mm" margin-left="19mm" margin-right="19mm"/>
					<fo:region-before region-name="header-odd" extent="27.4mm"/> <!--   display-align="center" -->
					<fo:region-after region-name="footer-odd" extent="{$marginBottom}mm"/>
					<fo:region-start region-name="left-region" extent="19mm"/>
					<fo:region-end region-name="right-region" extent="19mm"/>
				</fo:simple-page-master>
				<!-- even pages -->
				<fo:simple-page-master master-name="even" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
					<fo:region-body margin-top="27.4mm" margin-bottom="{$marginBottom + 2}mm" margin-left="19mm" margin-right="19mm"/>
					<fo:region-before region-name="header-even" extent="27.4mm"/> <!--   display-align="center" -->
					<fo:region-after region-name="footer-even" extent="{$marginBottom}mm"/>
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
				<fo:simple-page-master master-name="first-publishedISO" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
					<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom + 2}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
					<fo:region-before region-name="header-first" extent="{$marginTop}mm"/> <!--   display-align="center" -->
					<fo:region-after region-name="footer-odd" extent="{$marginBottom}mm"/>
					<fo:region-start region-name="left-region" extent="{$marginLeftRight1}mm"/>
					<fo:region-end region-name="right-region" extent="{$marginLeftRight2}mm"/>
				</fo:simple-page-master>
				<!-- odd pages -->
				<fo:simple-page-master master-name="odd-publishedISO" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
					<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom + 2}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
					<fo:region-before region-name="header-odd" extent="{$marginTop}mm"/> <!--   display-align="center" -->
					<fo:region-after region-name="footer-odd" extent="{$marginBottom}mm"/>
					<fo:region-start region-name="left-region" extent="{$marginLeftRight1}mm"/>
					<fo:region-end region-name="right-region" extent="{$marginLeftRight2}mm"/>
				</fo:simple-page-master>
				<!-- even pages -->
				<fo:simple-page-master master-name="even-publishedISO" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
					<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom + 2}mm" margin-left="{$marginLeftRight2}mm" margin-right="{$marginLeftRight1}mm"/>
					<fo:region-before region-name="header-even" extent="{$marginTop}mm"/>
					<fo:region-after region-name="footer-even" extent="{$marginBottom}mm"/>
					<fo:region-start region-name="left-region" extent="{$marginLeftRight2}mm"/>
					<fo:region-end region-name="right-region" extent="{$marginLeftRight1}mm"/>
				</fo:simple-page-master>
				<fo:simple-page-master master-name="blankpage" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
					<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom + 2}mm" margin-left="{$marginLeftRight2}mm" margin-right="{$marginLeftRight1}mm"/>
					<fo:region-before region-name="header" extent="{$marginTop}mm"/>
					<fo:region-after region-name="footer" extent="{$marginBottom}mm"/>
					<fo:region-start region-name="left" extent="{$marginLeftRight2}mm"/>
					<fo:region-end region-name="right" extent="{$marginLeftRight1}mm"/>
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
				
				<fo:simple-page-master master-name="last-page" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
					<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight2}mm" margin-right="{$marginLeftRight1}mm"/>
					<fo:region-before region-name="header-even" extent="{$marginTop}mm"/>
					<fo:region-after region-name="last-page-footer" extent="{$marginBottom}mm"/>
					<fo:region-start region-name="left-region" extent="{$marginLeftRight2}mm"/>
					<fo:region-end region-name="right-region" extent="{$marginLeftRight1}mm"/>
				</fo:simple-page-master>
				
				<!-- Index pages -->
				<fo:simple-page-master master-name="index-odd" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
					<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm" column-count="2" column-gap="10mm"/>
					<fo:region-before region-name="header-odd" extent="{$marginTop}mm"/>
					<fo:region-after region-name="footer-odd" extent="{$marginBottom}mm"/>
					<fo:region-start region-name="left-region" extent="{$marginLeftRight1}mm"/>
					<fo:region-end region-name="right-region" extent="{$marginLeftRight2}mm"/>
				</fo:simple-page-master>
				<fo:simple-page-master master-name="index-even" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
					<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight2}mm" margin-right="{$marginLeftRight1}mm" column-count="2" column-gap="10mm"/>
					<fo:region-before region-name="header-even" extent="{$marginTop}mm"/>
					<fo:region-after region-name="footer-even" extent="{$marginBottom}mm"/>
					<fo:region-start region-name="left-region" extent="{$marginLeftRight2}mm"/>
					<fo:region-end region-name="right-region" extent="{$marginLeftRight1}mm"/>
				</fo:simple-page-master>
				<fo:page-sequence-master master-name="index">
					<fo:repeatable-page-master-alternatives>						
						<fo:conditional-page-master-reference odd-or-even="even" master-reference="index-even"/>
						<fo:conditional-page-master-reference odd-or-even="odd" master-reference="index-odd"/>
					</fo:repeatable-page-master-alternatives>
				</fo:page-sequence-master>
				
				
			</fo:layout-master-set>
			
			<fo:declarations>
				<xsl:call-template name="addPDFUAmeta"/>
				<xsl:for-each select="//*[local-name() = 'eref'][generate-id(.)=generate-id(key('attachments',@bibitemid)[1])]">
					<xsl:variable name="url" select="concat('url(file:',$basepath, @bibitemid, ')')"/>
					<pdf:embedded-file src="{$url}" filename="{@bibitemid}"/>
				</xsl:for-each>
			</fo:declarations>

			
			
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
												<xsl:call-template name="insertTripleLine"/>
												<fo:table table-layout="fixed" width="100%" margin-bottom="3mm">
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
																				<fo:external-graphic src="{concat('data:image/png;base64,', normalize-space($Image-ISO-Logo))}" content-height="19mm" content-width="scale-to-fit" scaling="uniform" fox:alt-text="Image {@alt}"/>
																			</xsl:when>
																			<xsl:when test=". = 'IEC'">
																				<fo:external-graphic src="{concat('data:image/png;base64,', normalize-space($Image-IEC-Logo))}" content-height="19mm" content-width="scale-to-fit" scaling="uniform" fox:alt-text="Image {@alt}"/>
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
																	<fo:block space-before="28pt"><fo:inline font-size="9pt">©</fo:inline><xsl:value-of select="concat(' ', $copyrightAbbr, ' ', $copyrightYear)"/></fo:block>
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
														<fo:block margin-bottom="3mm">
															<xsl:copy-of select="$editorialgroup"/>
														</fo:block>
													</fo:table-cell>
													<fo:table-cell>
														<fo:block>
															<xsl:copy-of select="$secretariat"/>
														</fo:block>
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
										
										<fo:block-container line-height="1.1" margin-top="3mm">
											<xsl:call-template name="insertTripleLine"/>
											<fo:block margin-right="5mm">
												<fo:block font-size="18pt" font-weight="bold" margin-top="6pt" role="H1">
												
													<xsl:apply-templates select="/iso:iso-standard/iso:bibdata/iso:title[@language = $lang and @type = 'title-intro']"/>
																	
													<xsl:apply-templates select="/iso:iso-standard/iso:bibdata/iso:title[@language = $lang and @type = 'title-main']"/>
													
													<xsl:apply-templates select="/iso:iso-standard/iso:bibdata/iso:title[@language = $lang and @type = 'title-part']">
														<xsl:with-param name="isMainLang">true</xsl:with-param>
													</xsl:apply-templates>
													
													<xsl:apply-templates select="/iso:iso-standard/iso:bibdata/iso:title[@language = $lang and @type = 'title-amd']">
														<xsl:with-param name="isMainLang">true</xsl:with-param>
													</xsl:apply-templates>
												
												</fo:block>
												
												
												<xsl:for-each select="xalan:nodeset($lang_other)/lang">
													<xsl:variable name="lang_other" select="."/>
												
													<fo:block font-size="12pt"><xsl:value-of select="$linebreak"/></fo:block>
													<fo:block font-size="11pt" font-style="italic" line-height="1.1" role="H1">
														
														<!-- Example: title-intro fr -->
														<xsl:apply-templates select="$XML/iso:iso-standard/iso:bibdata/iso:title[@language = $lang_other and @type = 'title-intro']"/>
														
														<xsl:apply-templates select="$XML/iso:iso-standard/iso:bibdata/iso:title[@language = $lang_other and @type = 'title-main']"/>
														
														<xsl:apply-templates select="$XML/iso:iso-standard/iso:bibdata/iso:title[@language = $lang_other and @type = 'title-part']">
															<xsl:with-param name="curr_lang" select="$lang_other"/>
														</xsl:apply-templates>
														
														<xsl:apply-templates select="$XML/iso:iso-standard/iso:bibdata/iso:title[@language = $lang_other and @type = 'title-amd']">
															<xsl:with-param name="curr_lang" select="$lang_other"/>
														</xsl:apply-templates>
														
													</fo:block>
												</xsl:for-each>
											</fo:block>
											
											<fo:block margin-top="10mm">
												<xsl:copy-of select="$ics"/>
											</fo:block>
											
										</fo:block-container>
										
										
									</fo:block-container>
								</fo:flow>
							
							</xsl:when> <!-- END: $stage-abbreviation = 'DIS' -->
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
													
													<xsl:variable name="lastWord">
														<xsl:call-template name="substring-after-last">
															<xsl:with-param name="value" select="$doctype_uppercased"/>
															<xsl:with-param name="delimiter" select="' '"/>
														</xsl:call-template>
													</xsl:variable>
													<xsl:variable name="font-size"><xsl:if test="string-length($lastWord) &gt;= 12">90%</xsl:if></xsl:variable> <!-- to prevent overlapping 'NORME INTERNATIONALE' to number -->
													
													<fo:table-cell>
														<fo:block text-align="left">
															<xsl:choose>
																<xsl:when test="$doctype = 'amendment'">
																	<xsl:value-of select="java:toUpperCase(java:java.lang.String.new(translate(/iso:iso-standard/iso:bibdata/iso:ext/iso:updates-document-type,'-',' ')))"/>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:if test="$font-size != ''">
																		<xsl:attribute name="font-size"><xsl:value-of select="$font-size"/></xsl:attribute>
																	</xsl:if>
																	<xsl:value-of select="$doctype_uppercased"/>
																</xsl:otherwise>
															</xsl:choose>
														</fo:block>
													</fo:table-cell>
													<fo:table-cell>
														<fo:block text-align="right" font-weight="bold" margin-bottom="13mm">
															<xsl:if test="$font-size != ''">
																<xsl:attribute name="font-size"><xsl:value-of select="$font-size"/></xsl:attribute>
															</xsl:if>
															<xsl:value-of select="$docidentifierISO"/>
														</fo:block>
													</fo:table-cell>
												</fo:table-row>
												<fo:table-row height="25mm">
													<fo:table-cell number-columns-spanned="3" font-size="10pt" line-height="1.2">
														<fo:block text-align="right">
															<xsl:if test="$stage-abbreviation = 'PRF' or 
																								$stage-abbreviation = 'IS' or 
																								$stage-abbreviation = 'D' or 
																								$stage-abbreviation = 'published'">
																<xsl:call-template name="printEdition"/>
															</xsl:if>
															<xsl:choose>
																<xsl:when test="($stage-abbreviation = 'PWI' or $stage-abbreviation = 'AWI' or $stage-abbreviation = 'WD' or $stage-abbreviation = 'CD') and /iso:iso-standard/iso:bibdata/iso:version/iso:revision-date">
																	<xsl:value-of select="$linebreak"/>
																	<xsl:value-of select="/iso:iso-standard/iso:bibdata/iso:version/iso:revision-date"/>
																</xsl:when>
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
																<fo:block font-weight="bold" margin-top="4pt" role="H1">
																	<xsl:value-of select="$doctype_uppercased"/>
																	<xsl:text> </xsl:text>
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
												<fo:table-row height="17mm">
													<fo:table-cell><fo:block></fo:block></fo:table-cell>
													<fo:table-cell number-columns-spanned="2" font-size="10pt" line-height="1.2" display-align="center">
														<fo:block>
															<xsl:if test="$stage-abbreviation = 'PWI' or $stage-abbreviation = 'AWI' or $stage-abbreviation = 'WD' or $stage-abbreviation = 'CD'">
																<fo:table table-layout="fixed" width="100%">
																	<fo:table-column column-width="50%"/>
																	<fo:table-column column-width="50%"/>
																	<fo:table-body>
																		<fo:table-row>
																			<fo:table-cell>
																				<fo:block>
																					<xsl:copy-of select="$editorialgroup"/>
																				</fo:block>
																			</fo:table-cell>
																			<fo:table-cell>
																				<fo:block>
																					<xsl:copy-of select="$secretariat"/>
																				</fo:block>
																			</fo:table-cell>
																		</fo:table-row>
																	</fo:table-body>
																</fo:table>
															</xsl:if>
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
																			<fo:block margin-bottom="8pt"><xsl:copy-of select="$editorialgroup"/></fo:block>
																			<fo:block margin-bottom="6pt"><xsl:value-of select="$secretariat"/></fo:block>
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
														<xsl:call-template name="insertTripleLine"/>
														<fo:block-container line-height="1.1">
															<fo:block margin-right="5mm">
																<fo:block font-size="18pt" font-weight="bold" margin-top="12pt" role="H1">
																	
																	<xsl:apply-templates select="/iso:iso-standard/iso:bibdata/iso:title[@language = $lang and @type = 'title-intro']"/>
																	
																	<xsl:apply-templates select="/iso:iso-standard/iso:bibdata/iso:title[@language = $lang and @type = 'title-main']"/>
																	
																	<xsl:apply-templates select="/iso:iso-standard/iso:bibdata/iso:title[@language = $lang and @type = 'title-part']">
																		<xsl:with-param name="isMainLang">true</xsl:with-param>
																	</xsl:apply-templates>
																	
																	<xsl:apply-templates select="/iso:iso-standard/iso:bibdata/iso:title[@language = $lang and @type = 'title-amd']">
																		<xsl:with-param name="isMainLang">true</xsl:with-param>
																	</xsl:apply-templates>
																	
																</fo:block>
																			
																
																<xsl:for-each select="xalan:nodeset($lang_other)/lang">
																	<xsl:variable name="lang_other" select="."/>
																	
																	<fo:block font-size="12pt"><xsl:value-of select="$linebreak"/></fo:block>
																	<fo:block font-size="11pt" font-style="italic" line-height="1.1" role="H1">
																		
																		<!-- Example: title-intro fr -->
																		<xsl:apply-templates select="$XML/iso:iso-standard/iso:bibdata/iso:title[@language = $lang_other and @type = 'title-intro']"/>
																		
																		<xsl:apply-templates select="$XML/iso:iso-standard/iso:bibdata/iso:title[@language = $lang_other and @type = 'title-main']"/>
																		
																		<xsl:apply-templates select="$XML/iso:iso-standard/iso:bibdata/iso:title[@language = $lang_other and @type = 'title-part']">
																			<xsl:with-param name="curr_lang" select="$lang_other"/>
																		</xsl:apply-templates>
																		
																		<xsl:apply-templates select="$XML/iso:iso-standard/iso:bibdata/iso:title[@language = $lang_other and @type = 'title-amd']">
																			<xsl:with-param name="curr_lang" select="$lang_other"/>
																		</xsl:apply-templates>
																		
																	</fo:block>
																</xsl:for-each>
																
																<xsl:if test="$stage-abbreviation = 'PWI' or $stage-abbreviation = 'AWI' or $stage-abbreviation = 'WD' or $stage-abbreviation = 'CD'">
																	<fo:block margin-top="10mm">
																		<xsl:copy-of select="$ics"/>
																	</fo:block>
																</xsl:if>
																
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
							<xsl:call-template name="insertTripleLine"/>
							<fo:table table-layout="fixed" width="100%" margin-bottom="3mm">
								<fo:table-column column-width="50%"/>
								<fo:table-column column-width="50%"/>
								<fo:table-body>
									<fo:table-row height="32mm">
										<fo:table-cell display-align="center">
											<fo:block text-align="left">
												<fo:external-graphic src="{concat('data:image/png;base64,', normalize-space($Image-ISO-Logo))}" width="21mm" content-height="21mm" content-width="scale-to-fit" scaling="uniform" fox:alt-text="Image {@alt}"/>
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
												<fo:block><fo:inline font-size="9pt">©</fo:inline><xsl:value-of select="concat(' ', $copyrightAbbr, ' ', $copyrightYear)"/></fo:block>
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
								
								<xsl:call-template name="insertTripleLine"/>
								<fo:block-container line-height="1.1">
									<fo:block margin-right="40mm">
										<fo:block font-size="18pt" font-weight="bold" margin-top="12pt" role="H1">
										
											<xsl:apply-templates select="/iso:iso-standard/iso:bibdata/iso:title[@language = $lang and @type = 'title-intro']"/>
																		
											<xsl:apply-templates select="/iso:iso-standard/iso:bibdata/iso:title[@language = $lang and @type = 'title-main']"/>
											
											<xsl:apply-templates select="/iso:iso-standard/iso:bibdata/iso:title[@language = $lang and @type = 'title-part']">
												<xsl:with-param name="isMainLang">true</xsl:with-param>
											</xsl:apply-templates>
											
										</fo:block>
											
										<xsl:for-each select="xalan:nodeset($lang_other)/lang">
											<xsl:variable name="lang_other" select="."/>
											
											<fo:block font-size="12pt"><xsl:value-of select="$linebreak"/></fo:block>
											<fo:block font-size="11pt" font-style="italic" line-height="1.1" role="H1">
												
												<!-- Example: title-intro fr -->
												<xsl:apply-templates select="$XML/iso:iso-standard/iso:bibdata/iso:title[@language = $lang_other and @type = 'title-intro']"/>
												
												<xsl:apply-templates select="$XML/iso:iso-standard/iso:bibdata/iso:title[@language = $lang_other and @type = 'title-main']"/>
												
												<xsl:apply-templates select="$XML/iso:iso-standard/iso:bibdata/iso:title[@language = $lang_other and @type = 'title-part']">
													<xsl:with-param name="curr_lang" select="$lang_other"/>
												</xsl:apply-templates>
												
											</fo:block>
										</xsl:for-each>
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
								
								 
								<xsl:if test="normalize-space($editorialgroup) != ''">
									<!-- ISO/TC 34/SC 4/WG 3 -->
									<fo:block margin-bottom="12pt">
										<xsl:copy-of select="$editorialgroup"/>
									</fo:block>
								</xsl:if>
								
								<!-- Secretariat: AFNOR  -->
								<fo:block margin-bottom="100pt">
									<xsl:value-of select="$secretariat"/>
									<xsl:text>&#xA0;</xsl:text>
								</fo:block>


								</fo:block-container>
							<fo:block-container font-size="16pt">
								<!-- Information and documentation — Codes for transcription systems  -->
									<fo:block font-weight="bold" role="H1">
									
										<xsl:apply-templates select="/iso:iso-standard/iso:bibdata/iso:title[@language = $lang and @type = 'title-intro']"/>
																	
										<xsl:apply-templates select="/iso:iso-standard/iso:bibdata/iso:title[@language = $lang and @type = 'title-main']"/>
										
										<xsl:apply-templates select="/iso:iso-standard/iso:bibdata/iso:title[@language = $lang and @type = 'title-part']">
											<xsl:with-param name="isMainLang">true</xsl:with-param>
										</xsl:apply-templates>
									
									</fo:block>
									
									<xsl:for-each select="xalan:nodeset($lang_other)/lang">
										<xsl:variable name="lang_other" select="."/>
									
										<fo:block font-size="12pt"><xsl:value-of select="$linebreak"/></fo:block>
										<fo:block role="H1">
										
											<!-- Example: title-intro fr -->
											<xsl:apply-templates select="$XML/iso:iso-standard/iso:bibdata/iso:title[@language = $lang_other and @type = 'title-intro']"/>
											
											<xsl:apply-templates select="$XML/iso:iso-standard/iso:bibdata/iso:title[@language = $lang_other and @type = 'title-main']"/>
											
											<xsl:apply-templates select="$XML/iso:iso-standard/iso:bibdata/iso:title[@language = $lang_other and @type = 'title-part']">
												<xsl:with-param name="curr_lang" select="$lang_other"/>
											</xsl:apply-templates>
												
										</fo:block>
										
									</xsl:for-each>
									
							</fo:block-container>
							<fo:block font-size="11pt" margin-bottom="8pt"><xsl:value-of select="$linebreak"/></fo:block>
							<fo:block-container font-size="40pt" text-align="center" margin-bottom="12pt" border="0.5pt solid black">
								<xsl:variable name="stage-title" select="substring-after(substring-before($docidentifierISO, ' '), '/')"/>
								<xsl:choose>
									<xsl:when test="normalize-space($stage-title) != ''">
										<fo:block padding-top="2mm"><xsl:value-of select="$stage-title"/><xsl:text> stage</xsl:text></fo:block>
									</xsl:when>
									<xsl:otherwise>
										<xsl:attribute name="border">0pt solid white</xsl:attribute>
										<fo:block>&#xa0;</fo:block>
									</xsl:otherwise>
								</xsl:choose>
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
			
			<xsl:variable name="updated_xml_step1">
				<xsl:apply-templates mode="update_xml_step1"/>
			</xsl:variable>
			<!-- DEBUG: updated_xml_step1=<xsl:copy-of select="$updated_xml_step1"/> -->
			
			<xsl:variable name="updated_xml_step2">
				<xsl:apply-templates select="xalan:nodeset($updated_xml_step1)" mode="update_xml_step2"/>
			</xsl:variable>
			<!-- DEBUG: updated_xml_step2=<xsl:copy-of select="$updated_xml_step2"/> -->
			
			<xsl:variable name="updated_xml_step3">
				<xsl:apply-templates select="xalan:nodeset($updated_xml_step2)" mode="update_xml_enclose_keep-together_within-line"/>
			</xsl:variable>
			<!-- DEBUG: updated_xml_step3=<xsl:copy-of select="$updated_xml_step3"/> -->
			
			<xsl:for-each select="xalan:nodeset($updated_xml_step3)">
			
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
									<fo:block role="TOC">
										<fo:block text-align-last="justify" font-size="16pt" margin-top="10pt" margin-bottom="18pt">
											<fo:inline font-size="16pt" font-weight="bold" role="H1">
												<!-- Contents -->
												<xsl:call-template name="getLocalizedString">
													<xsl:with-param name="key">table_of_contents</xsl:with-param>
												</xsl:call-template>
											</fo:inline>
											<fo:inline keep-together.within-line="always">
												<fo:leader leader-pattern="space"/>
												<fo:inline font-weight="normal" font-size="10pt">
													<!-- Page -->
													<xsl:call-template name="getLocalizedString">
													<xsl:with-param name="key">locality.page</xsl:with-param>
												</xsl:call-template>
												</fo:inline>
											</fo:inline>
										</fo:block>
										
										<xsl:if test="$debug = 'true'">
											<xsl:text disable-output-escaping="yes">&lt;!--</xsl:text>
												DEBUG
												contents=<xsl:copy-of select="$contents"/>
											<xsl:text disable-output-escaping="yes">--&gt;</xsl:text>
										</xsl:if>
										
										<xsl:variable name="margin-left">12</xsl:variable>
										<xsl:for-each select="$contents//item[@display = 'true']"><!-- [not(@level = 2 and starts-with(@section, '0'))] skip clause from preface -->
											
											<fo:block role="TOCI">
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
																		<fo:inline>
																			<xsl:if test="@level = 1 and @type = 'annex'">
																				<xsl:attribute name="font-weight">bold</xsl:attribute>
																			</xsl:if>
																			<fo:page-number-citation ref-id="{@id}"/>
																		</fo:inline>
																	</fo:inline>
																</fo:basic-link>
															</fo:block>
														</fo:list-item-body>
													</fo:list-item>
												</fo:list-block>
											</fo:block>
											
										</xsl:for-each>
										
										<!-- List of Tables -->
										<xsl:if test="$contents//tables/table">
											<xsl:call-template name="insertListOf_Title">
												<xsl:with-param name="title" select="$title-list-tables"/>
											</xsl:call-template>
											<xsl:for-each select="$contents//tables/table">
												<xsl:call-template name="insertListOf_Item"/>
											</xsl:for-each>
										</xsl:if>
										
										<!-- List of Figures -->
										<xsl:if test="$contents//figures/figure">
											<xsl:call-template name="insertListOf_Title">
												<xsl:with-param name="title" select="$title-list-figures"/>
											</xsl:call-template>
											<xsl:for-each select="$contents//figures/figure">
												<xsl:call-template name="insertListOf_Item"/>
											</xsl:for-each>
										</xsl:if>
										
									</fo:block>
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
							
								<fo:block role="H1">
								
									<xsl:apply-templates select="/iso:iso-standard/iso:bibdata/iso:title[@language = $lang and @type = 'title-intro']"/>
									
									<xsl:apply-templates select="/iso:iso-standard/iso:bibdata/iso:title[@language = $lang and @type = 'title-main']"/>
									
									<xsl:apply-templates select="/iso:iso-standard/iso:bibdata/iso:title[@language = $lang and @type = 'title-part']">
										<xsl:with-param name="isMainLang">true</xsl:with-param>
										<xsl:with-param name="isMainBody">true</xsl:with-param>
									</xsl:apply-templates>
									
								</fo:block>
								<fo:block role="H1">
									<xsl:apply-templates select="/iso:iso-standard/iso:bibdata/iso:title[@language = $lang and @type = 'title-part']/node()"/>
								</fo:block>
								
								<xsl:apply-templates select="/iso:iso-standard/iso:bibdata/iso:title[@language = $lang and @type = 'title-amd']">
									<xsl:with-param name="isMainLang">true</xsl:with-param>
									<xsl:with-param name="isMainBody">true</xsl:with-param>
								</xsl:apply-templates>
								
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
				
				
				<!-- Index -->
				<xsl:apply-templates select="//iso:indexsect" mode="index"/>
				
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
								<xsl:call-template name="insertTripleLine"/>
								<fo:block-container>
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
			</xsl:for-each>
		</fo:root>
	</xsl:template> 

	
	<xsl:template name="insertListOf_Title">
		<xsl:param name="title"/>
		<fo:block role="TOCI" margin-top="5pt" keep-with-next="always">
			<xsl:value-of select="$title"/>
		</fo:block>
	</xsl:template>
	
	<xsl:template name="insertListOf_Item">
		<fo:block role="TOCI" font-weight="normal" text-align-last="justify" margin-left="12mm">
			<fo:basic-link internal-destination="{@id}">
				<xsl:call-template name="setAltText">
					<xsl:with-param name="value" select="@alt-text"/>
				</xsl:call-template>
				<xsl:apply-templates select="." mode="contents"/>
				<fo:inline keep-together.within-line="always">
					<fo:leader font-size="9pt" font-weight="normal" leader-pattern="dots"/>
					<fo:inline><fo:page-number-citation ref-id="{@id}"/></fo:inline>
				</fo:inline>
			</fo:basic-link>
		</fo:block>
	</xsl:template>

	
	<!-- ==================== -->
	<!-- display titles       -->
	<!-- ==================== -->
	<xsl:template match="iso:bibdata/iso:title[@type = 'title-intro']">
		<xsl:apply-templates />
		<xsl:text> — </xsl:text>
	</xsl:template>

	<xsl:template match="iso:bibdata/iso:title[@type = 'title-main']">
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="iso:bibdata/iso:title[@type = 'title-part']">
		<xsl:param name="curr_lang" select="$lang"/>
		<xsl:param name="isMainLang">false</xsl:param>
		<xsl:param name="isMainBody">false</xsl:param>
		<xsl:if test="$part != ''">
			<xsl:text> — </xsl:text>
			<xsl:variable name="part-text">
				<xsl:choose>
					<xsl:when test="$isMainLang = 'true'">
						<xsl:call-template name="getLocalizedString">
							<xsl:with-param name="key">locality.part</xsl:with-param>
						</xsl:call-template>
						<xsl:text> </xsl:text>
						<xsl:value-of select="$part"/>
						<xsl:text>:</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="java:replaceAll(java:java.lang.String.new($titles/title-part[@lang=$curr_lang]),'#',$part)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="$isMainBody = 'true'">
					<fo:block font-weight="normal" margin-top="12pt" line-height="1.1">
						<xsl:value-of select="$part-text"/>
					</fo:block>
				</xsl:when>
				<xsl:when test="$isMainLang = 'true'">
					<fo:block font-weight="normal" margin-top="6pt">
						<xsl:value-of select="$part-text"/>
					</fo:block>
				</xsl:when>
				<xsl:otherwise>
					<!-- <xsl:value-of select="$linebreak"/> -->
					<fo:block font-size="1pt" margin-top="5pt">&#xa0;</fo:block>
					<xsl:value-of select="$part-text"/>
					<xsl:text>&#xa0;</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		<xsl:if test="$isMainBody = 'false'">
			<xsl:apply-templates />
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="iso:bibdata/iso:title[@type = 'title-amd']">
		<xsl:param name="isMainLang">false</xsl:param>
		<xsl:param name="curr_lang" select="$lang"/>
		<xsl:param name="isMainBody">false</xsl:param>
		<xsl:if test="$doctype = 'amendment'">
			<fo:block margin-right="-5mm" margin-top="6pt" role="H1">
				<xsl:if test="$isMainLang = 'true'">
					<xsl:attribute name="margin-top">12pt</xsl:attribute>
				</xsl:if>
				<xsl:if test="$stage-abbreviation = 'DIS' or $isMainBody = 'true'">
					<xsl:attribute name="margin-right">0mm</xsl:attribute>
				</xsl:if>
				
				<fo:block font-weight="normal" line-height="1.1">
					<xsl:value-of select="$doctype_uppercased"/>
					<xsl:variable name="amendment-number" select="/iso:iso-standard/iso:bibdata/iso:ext/iso:structuredidentifier/iso:project-number/@amendment"/>
					<xsl:if test="normalize-space($amendment-number) != ''">
						<xsl:text> </xsl:text><xsl:value-of select="$amendment-number"/>
					</xsl:if>
					<xsl:text>: </xsl:text>
					<xsl:apply-templates />
				</fo:block>
				
			</fo:block>
		</xsl:if>
	</xsl:template>
	
	
	<!-- ==================== -->
	<!-- END display titles   -->
	<!-- ==================== -->
	
	<xsl:template match="node()">		
		<xsl:apply-templates />			
	</xsl:template>
	
	<!-- ============================= -->
	<!-- CONTENTS                                       -->
	<!-- ============================= -->
	
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
			<xsl:choose>
				<xsl:when test="local-name() = 'indexsect'">index</xsl:when>
				<xsl:otherwise><xsl:value-of select="local-name()"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
			
		<xsl:variable name="display">
			<xsl:choose>				
				<xsl:when test="ancestor-or-self::iso:annex and $level &gt;= 2">false</xsl:when>
				<xsl:when test="$section = '' and $type = 'clause'">false</xsl:when>
				<xsl:when test="$level &lt;= $toc_level">true</xsl:when>
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
				<xsl:if test="$type = 'index'">
					<xsl:attribute name="level">1</xsl:attribute>
				</xsl:if>
				<title>
					<xsl:apply-templates select="xalan:nodeset($title)" mode="contents_item"/>
				</title>
				<xsl:if test="$type != 'index'">
					<xsl:apply-templates  mode="contents" />
				</xsl:if>
			</item>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="iso:p | iso:termsource | iso:termnote" mode="contents" />

	
	
	<!-- ============================= -->
	<!-- ============================= -->

	
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
	
	<xsl:template match="iso:copyright-statement/iso:clause[1]/iso:title" priority="2">
		<fo:block margin-left="0.5mm" margin-bottom="3mm" role="H1">
				<fo:external-graphic src="{concat('data:image/png;base64,', normalize-space($Image-Attention))}" width="14mm" content-height="13mm" content-width="scale-to-fit" scaling="uniform" fox:alt-text="Image {@alt}"/>
				<!-- <fo:inline padding-left="6mm" font-size="12pt" font-weight="bold">COPYRIGHT PROTECTED DOCUMENT</fo:inline> -->
				<fo:inline padding-left="6mm" font-size="12pt" font-weight="bold"><xsl:apply-templates /></fo:inline>
			</fo:block>
	</xsl:template>
	
	<xsl:template match="iso:copyright-statement//iso:p" priority="2">
		<fo:block>
			<xsl:if test="following-sibling::iso:p">
				<xsl:attribute name="margin-bottom">3pt</xsl:attribute>
				<xsl:attribute name="margin-left">0.5mm</xsl:attribute>
				<xsl:attribute name="margin-right">0.5mm</xsl:attribute>
			</xsl:if>
			<xsl:if test="contains(@id, 'address')">
				<xsl:attribute name="margin-left">4.5mm</xsl:attribute>
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
				<fo:block font-size="16pt" text-align="center" margin-bottom="48pt" keep-with-next="always" role="H1">
					<xsl:apply-templates />
					<xsl:apply-templates select="following-sibling::*[1][local-name() = 'variant-title'][@type = 'sub']" mode="subtitle"/>
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
				<fo:block font-size="16pt" font-weight="bold" text-align="center" margin-top="6pt" margin-bottom="36pt" keep-with-next="always" role="H1">
					<xsl:apply-templates />
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="iso:title" name="title">
	
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
				<fo:block font-size="11pt" font-style="italic" margin-bottom="12pt" keep-with-next="always" role="H{$level}">
					<xsl:apply-templates />
					<xsl:apply-templates select="following-sibling::*[1][local-name() = 'variant-title'][@type = 'sub']" mode="subtitle"/>
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
					<xsl:attribute name="role">H<xsl:value-of select="$level"/></xsl:attribute>
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
					<xsl:apply-templates select="following-sibling::*[1][local-name() = 'variant-title'][@type = 'sub']" mode="subtitle"/>
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

	
	<xsl:template match="iso:p" name="paragraph">
		<xsl:param name="inline" select="'false'"/>
		<xsl:param name="split_keep-within-line"/>
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
			<xsl:if test="@id">
				<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
			</xsl:if>
			<!-- bookmarks only in paragraph -->
			<xsl:if test="count(iso:bookmark) != 0 and count(*) = count(iso:bookmark) and normalize-space() = ''">
				<xsl:attribute name="font-size">0</xsl:attribute>
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
				<xsl:attribute name="line-height">0</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates>
				<xsl:with-param name="split_keep-within-line" select="$split_keep-within-line"/>
			</xsl:apply-templates>
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
				<!-- <fo:inline white-space="pre"><xsl:value-of select="translate(., $thin_space, ' ')"/></fo:inline> -->
				<fo:inline white-space="pre"><xsl:value-of select="."/></fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<!-- <xsl:value-of select="translate(., $thin_space, ' ')"/> -->
				<!-- <xsl:value-of select="."/> -->
				<xsl:call-template name="text"/>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
	
	
	<xsl:template match="iso:p/iso:fn/iso:p">
		<xsl:apply-templates />
	</xsl:template>
	
	
	<!-- For express listings PDF attachments -->
	<xsl:template match="*[local-name() = 'eref'][contains(@bibitemid, '.exp')]" priority="2">
		<fo:inline xsl:use-attribute-sets="eref-style">
			<xsl:variable name="url" select="concat('url(embedded-file:', @bibitemid, ')')"/>
			<fo:basic-link external-destination="{$url}" fox:alt-text="{@citeas}">
				<xsl:if test="normalize-space(@citeas) = ''">
					<xsl:attribute name="fox:alt-text"><xsl:value-of select="."/></xsl:attribute>
				</xsl:if>
				<xsl:apply-templates />
			</fo:basic-link>
		</fo:inline>
	</xsl:template>
	

	<!-- =================== -->
	<!-- Index processing -->
	<!-- =================== -->
	
	<xsl:template match="iso:indexsect" />
	<xsl:template match="iso:indexsect" mode="index">
	
		<fo:page-sequence master-reference="index" force-page-count="no-force">
			<xsl:variable name="header-title">
				<xsl:choose>
					<xsl:when test="./iso:title[1]/*[local-name() = 'tab']">
						<xsl:apply-templates select="./iso:title[1]/*[local-name() = 'tab'][1]/following-sibling::node()" mode="header"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="./iso:title[1]" mode="header"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:call-template name="insertHeaderFooter">
				<xsl:with-param name="header-title" select="$header-title"/>
			</xsl:call-template>
			
			<fo:flow flow-name="xsl-region-body">
				<fo:block id="{@id}" span="all">
					<xsl:apply-templates select="iso:title"/>
				</fo:block>
				<fo:block role="Index">
					<xsl:apply-templates select="*[not(local-name() = 'title')]"/>
				</fo:block>
			</fo:flow>
		</fo:page-sequence>
	</xsl:template>
	
	
	<xsl:template match="iso:xref" priority="2">
		<fo:basic-link internal-destination="{@target}" fox:alt-text="{@target}" xsl:use-attribute-sets="xref-style">
			<xsl:choose>
				<xsl:when test="@pagenumber='true'">
					<fo:inline>
						<xsl:if test="@id">
							<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
						</xsl:if>
						<fo:page-number-citation ref-id="{@target}"/>
					</fo:inline>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates />
				</xsl:otherwise>
			</xsl:choose>
		</fo:basic-link>
	</xsl:template>
	
	<!-- =================== -->
	<!-- End of Index processing -->
	<!-- =================== -->
	
	<!-- 
	<xsl:template match="text()[contains(., $thin_space)]">
		<xsl:value-of select="translate(., $thin_space, ' ')"/>
	</xsl:template> -->
	
	
	<xsl:template name="insertHeaderFooter">
		<xsl:param name="font-weight" select="'bold'"/>
		<xsl:call-template name="insertHeaderEven"/>
		<fo:static-content flow-name="footer-even" role="artifact">
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
		<fo:static-content flow-name="header-odd" role="artifact">
			<fo:block-container height="24mm" display-align="before">
				<fo:block  font-size="12pt" font-weight="bold" text-align="right" padding-top="12.5mm"><xsl:value-of select="$ISOname"/></fo:block>
			</fo:block-container>
		</fo:static-content>
		<fo:static-content flow-name="footer-odd" role="artifact">
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
		<fo:static-content flow-name="header-even" role="artifact">
			<fo:block-container height="24mm" display-align="before">
				<fo:block font-size="12pt" font-weight="bold" padding-top="12.5mm"><xsl:value-of select="$ISOname"/></fo:block>
			</fo:block-container>
		</fo:static-content>
	</xsl:template>
	
	<xsl:template name="insertTripleLine">
		<fo:block font-size="1.25pt">
			<fo:block><fo:leader leader-pattern="rule" rule-thickness="0.75pt" leader-length="100%"/></fo:block>
			<fo:block><fo:leader leader-pattern="rule" rule-thickness="0.75pt" leader-length="100%"/></fo:block>
			<fo:block><fo:leader leader-pattern="rule" rule-thickness="0.75pt" leader-length="100%"/></fo:block>
		</fo:block>
	</xsl:template>

	<xsl:variable name="Image-ISO-Logo">
		<xsl:text>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</xsl:text>
	</xsl:variable>
	
	<xsl:variable name="Image-IEC-Logo">
		<xsl:text>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</xsl:text>
	</xsl:variable>
	
	<xsl:variable name="Image-Attention">
		<xsl:text>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</xsl:text>
	</xsl:variable>
	
</xsl:stylesheet>
