<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
											xmlns:fo="http://www.w3.org/1999/XSL/Format" 
											xmlns:jis="https://www.metanorma.org/ns/jis" 
											xmlns:mathml="http://www.w3.org/1998/Math/MathML" 
											xmlns:xalan="http://xml.apache.org/xalan" 
											xmlns:fox="http://xmlgraphics.apache.org/fop/extensions" 
											xmlns:pdf="http://xmlgraphics.apache.org/fop/extensions/pdf"
											xmlns:xlink="http://www.w3.org/1999/xlink"
											xmlns:java="http://xml.apache.org/xalan/java"
											xmlns:jeuclid="http://jeuclid.sf.net/ns/ext"
											xmlns:barcode="http://barcode4j.krysalis.org/ns" 
											xmlns:redirect="http://xml.apache.org/xalan/redirect"
											exclude-result-prefixes="java"
											extension-element-prefixes="redirect"
											version="1.0">

	<xsl:output method="xml" encoding="UTF-8" indent="no"/>
		
	<xsl:include href="./common.xsl"/>

	<xsl:key name="kfn" match="*[local-name() = 'fn'][not(ancestor::*[(local-name() = 'table' or local-name() = 'figure' or local-name() = 'localized-strings')] and not(ancestor::*[local-name() = 'name']))]" use="@reference"/>
	
	<xsl:variable name="namespace">jis</xsl:variable>
	
	<xsl:variable name="debug">false</xsl:variable>
	
	<!-- <xsl:variable name="isIgnoreComplexScripts">true</xsl:variable> -->
	
	<xsl:variable name="vertical_layout" select="normalize-space(/*/jis:metanorma-extension/jis:presentation-metadata/jis:vertical-layout)"/>
	<xsl:variable name="vertical_layout_rotate_clause_numbers" select="normalize-space(/*/jis:metanorma-extension/jis:presentation-metadata/jis:vertical-layout-rotate-clause-numbers)"/>
	
	<xsl:variable name="contents_">
		<xsl:variable name="bundle" select="count(//jis:jis-standard) &gt; 1"/>
		
		<xsl:if test="normalize-space($bundle) = 'true'">
			<collection firstpage_id="firstpage_id_0"/>
		</xsl:if>
		
		<xsl:for-each select="//jis:jis-standard">
			<xsl:variable name="num"><xsl:number level="any" count="jis:jis-standard"/></xsl:variable>
			<xsl:variable name="docnumber"><xsl:value-of select="jis:bibdata/jis:docidentifier[@type = 'JIS']"/></xsl:variable>
			<xsl:variable name="current_document">
				<xsl:copy-of select="."/>
			</xsl:variable>
			
			<xsl:for-each select="xalan:nodeset($current_document)"> <!-- . -->
				<doc num="{$num}" firstpage_id="firstpage_id_{$num}" title-part="{$docnumber}" bundle="{$bundle}"> <!-- 'bundle' means several different documents (not language versions) in one xml -->
					<contents>
						<!-- <xsl:call-template name="processPrefaceSectionsDefault_Contents"/> -->
						
						<xsl:call-template name="processMainSectionsDefault_Contents"/>
						
						<xsl:apply-templates select="//jis:indexsect" mode="contents"/>

					</contents>
				</doc>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="contents" select="xalan:nodeset($contents_)"/>
	
	<xsl:variable name="ids">
		<xsl:for-each select="//*[@id]">
			<id><xsl:value-of select="@id"/></id>
		</xsl:for-each>
	</xsl:variable>

	<xsl:variable name="pageWidthA5">148</xsl:variable>
	<xsl:variable name="pageHeightA5">210</xsl:variable>

	<xsl:template match="/">
	
		<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format" xml:lang="{$lang}">
			<xsl:variable name="root-style">
				<root-style xsl:use-attribute-sets="root-style">
					<xsl:if test="$vertical_layout = 'true'">
						<xsl:attribute name="font-family">Noto Serif JP, STIX Two Math, <xsl:value-of select="$font_noto_serif"/></xsl:attribute>
						<xsl:attribute name="font-family-generic">Serif</xsl:attribute>
						<xsl:attribute name="font-size">11pt</xsl:attribute>
						<xsl:attribute name="font-weight">200</xsl:attribute>
					</xsl:if>
				</root-style>
			</xsl:variable>
			<xsl:call-template name="insertRootStyle">
				<xsl:with-param name="root-style" select="$root-style"/>
			</xsl:call-template>
			
			<fo:layout-master-set>
			
				<!-- Cover page -->
				<fo:simple-page-master master-name="cover-page" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
					<fo:region-body margin-top="28.5mm" margin-bottom="25mm" margin-left="22mm" margin-right="22mm"/>
					<fo:region-before region-name="header" extent="28.5mm"/>
					<fo:region-after region-name="footer" extent="25mm"/>
					<fo:region-start region-name="left-region" extent="22mm"/>
					<fo:region-end region-name="right-region" extent="22mm"/>
				</fo:simple-page-master>
				
				<fo:simple-page-master master-name="cover-page_2024" page-width="{$pageWidthA5}mm" page-height="{$pageHeightA5}mm">
					<!-- Note (for writing-mode="tb-rl", may be due the update for support 'tb-rl' mode):
					 fo:region-body/@margin-top = left margin
					 fo:region-body/@margin-bottom = right margin
					 fo:region-body/margin-left = bottom margin
					 fo:region-body/margin-right = top margin
					-->
					<fo:region-body margin-top="6mm" margin-bottom="6mm" margin-left="12.8mm" margin-right="58mm" writing-mode="tb-rl"/>
					<fo:region-before region-name="header" extent="58mm" precedence="true"/>
					<fo:region-after region-name="footer" extent="12.8mm"/>
					<fo:region-start region-name="left-region" extent="20mm"/> <!-- 6 20mm -->
					<fo:region-end region-name="right-region" extent="6.8mm"/> <!-- 17mm -->
				</fo:simple-page-master>
		
				<fo:simple-page-master master-name="first_page" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
					<xsl:if test="$vertical_layout = 'true'">
						<xsl:attribute name="page-width"><xsl:value-of select="$pageHeight"/>mm</xsl:attribute>
						<xsl:attribute name="page-height"><xsl:value-of select="$pageWidth"/>mm</xsl:attribute>
					</xsl:if>
					<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm">
						<xsl:if test="$vertical_layout = 'true'">
							<xsl:attribute name="writing-mode">tb-rl</xsl:attribute>
						</xsl:if>
					</fo:region-body>
					<fo:region-before region-name="header" extent="{$marginTop}mm"/>
					<fo:region-after region-name="footer" extent="{$marginBottom}mm"/>
					<fo:region-start region-name="left-region" extent="{$marginLeftRight1}mm"/>
					<fo:region-end region-name="right-region" extent="{$marginLeftRight2}mm"/>
				</fo:simple-page-master>
				<fo:simple-page-master master-name="odd" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
					<xsl:if test="$vertical_layout = 'true'">
						<xsl:attribute name="page-width"><xsl:value-of select="$pageHeight"/>mm</xsl:attribute>
						<xsl:attribute name="page-height"><xsl:value-of select="$pageWidth"/>mm</xsl:attribute>
					</xsl:if>
					<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm">
						<xsl:if test="$vertical_layout = 'true'">
							<xsl:attribute name="writing-mode">tb-rl</xsl:attribute>
						</xsl:if>
					</fo:region-body>
					<fo:region-before region-name="header-odd" extent="{$marginTop}mm"/>
					<fo:region-after region-name="footer" extent="{$marginBottom}mm"/>
					<fo:region-start region-name="left-region" extent="{$marginLeftRight1}mm"/>
					<fo:region-end region-name="right-region" extent="{$marginLeftRight2}mm"/>
				</fo:simple-page-master>
				<fo:simple-page-master master-name="even" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
					<xsl:if test="$vertical_layout = 'true'">
						<xsl:attribute name="page-width"><xsl:value-of select="$pageHeight"/>mm</xsl:attribute>
						<xsl:attribute name="page-height"><xsl:value-of select="$pageWidth"/>mm</xsl:attribute>
					</xsl:if>
					<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm">
						<xsl:if test="$vertical_layout = 'true'">
							<xsl:attribute name="writing-mode">tb-rl</xsl:attribute>
						</xsl:if>
					</fo:region-body>
					<fo:region-before region-name="header-even" extent="{$marginTop}mm"/>
					<fo:region-after region-name="footer" extent="{$marginBottom}mm"/>
					<fo:region-start region-name="left-region" extent="{$marginLeftRight1}mm"/>
					<fo:region-end region-name="right-region" extent="{$marginLeftRight2}mm"/>
				</fo:simple-page-master>
				
				<fo:simple-page-master master-name="first_page_toc" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
					<xsl:if test="$vertical_layout = 'true'">
						<xsl:attribute name="page-width"><xsl:value-of select="$pageHeight"/>mm</xsl:attribute>
						<xsl:attribute name="page-height"><xsl:value-of select="$pageWidth"/>mm</xsl:attribute>
					</xsl:if>
					<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm">
						<xsl:if test="$vertical_layout = 'true'">
							<xsl:attribute name="writing-mode">tb-rl</xsl:attribute>
						</xsl:if>
					</fo:region-body>
					<fo:region-before region-name="header-odd-first" extent="{$marginTop}mm"/>
					<fo:region-after region-name="footer" extent="{$marginBottom}mm"/>
					<fo:region-start region-name="left-region" extent="{$marginLeftRight1}mm"/>
					<fo:region-end region-name="right-region" extent="{$marginLeftRight2}mm"/>
				</fo:simple-page-master>
				
				<fo:page-sequence-master master-name="document_toc">
					<fo:repeatable-page-master-alternatives>
						<fo:conditional-page-master-reference page-position="first" master-reference="first_page_toc"/>
						<fo:conditional-page-master-reference odd-or-even="even" master-reference="even"/>
						<fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd"/>
					</fo:repeatable-page-master-alternatives>
				</fo:page-sequence-master>
				
				<fo:simple-page-master master-name="document_toc_2024" page-width="{$pageHeight}mm" page-height="{$pageWidth}mm">
					<!-- Note (for writing-mode="tb-rl", may be due the update for support 'tb-rl' mode):
					 fo:region-body/@margin-top = left margin
					 fo:region-body/@margin-bottom = right margin
					 fo:region-body/margin-left = bottom margin
					 fo:region-body/margin-right = top margin
					-->
					<!-- <fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2 + 40}mm" writing-mode="tb-rl" background-color="rgb(240,240,240)"/> -->
					<fo:region-body margin-top="{$marginLeftRight1}mm" margin-bottom="{$marginLeftRight2}mm" margin-left="30mm" margin-right="30mm" writing-mode="tb-rl" background-color="rgb(240,240,240)"/>
					<fo:region-before region-name="header" extent="30mm" background-color="yellow"/>
					<fo:region-after region-name="footer" extent="30mm" background-color="green"/>
					<fo:region-start region-name="left-region" extent="{$marginLeftRight1}mm" background-color="blue"/>
					<fo:region-end region-name="right-region" extent="{$marginLeftRight2}mm" background-color="red"/>
				</fo:simple-page-master>
				
				<fo:page-sequence-master master-name="document_preface">
					<fo:repeatable-page-master-alternatives>
						<fo:conditional-page-master-reference odd-or-even="even" master-reference="even"/>
						<fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd"/>
					</fo:repeatable-page-master-alternatives>
				</fo:page-sequence-master>
				
				<fo:page-sequence-master master-name="document_first_section">
					<fo:repeatable-page-master-alternatives>
						<fo:conditional-page-master-reference page-position="first" master-reference="first_page"/>
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
			
			
				<fo:simple-page-master master-name="document_2024" page-width="{$pageHeight}mm" page-height="{$pageWidth}mm">
					<!-- Note (for writing-mode="tb-rl", may be due the update for support 'tb-rl' mode):
					 fo:region-body/@margin-top = left margin
					 fo:region-body/@margin-bottom = right margin
					 fo:region-body/margin-left = bottom margin
					 fo:region-body/margin-right = top margin
					-->
					<!-- <fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2 + 40}mm" writing-mode="tb-rl" background-color="rgb(240,240,240)"/> -->
					<fo:region-body margin-top="{$marginLeftRight1}mm" margin-bottom="{$marginLeftRight2}mm" margin-left="{$marginBottom}mm" margin-right="{$marginTop}mm" writing-mode="tb-rl" background-color="rgb(240,240,240)"/>
					<fo:region-before region-name="header" extent="{$marginTop}mm" background-color="yellow"/>
					<fo:region-after region-name="footer" extent="{$marginBottom}mm" background-color="green"/>
					<fo:region-start region-name="left-region" extent="{$marginLeftRight1}mm" background-color="blue"/>
					<fo:region-end region-name="right-region" extent="{$marginLeftRight2}mm" background-color="red"/>
				</fo:simple-page-master>
			
				<fo:simple-page-master master-name="commentary_first_page_even" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
					<xsl:if test="$vertical_layout = 'true'">
						<xsl:attribute name="page-width"><xsl:value-of select="$pageHeight"/>mm</xsl:attribute>
						<xsl:attribute name="page-height"><xsl:value-of select="$pageWidth"/>mm</xsl:attribute>
					</xsl:if>
					<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm">
						<xsl:if test="$vertical_layout = 'true'">
							<xsl:attribute name="writing-mode">tb-rl</xsl:attribute>
						</xsl:if>
					</fo:region-body>
					<fo:region-before region-name="header-commentary-even-first" extent="{$marginTop}mm"/>
					<fo:region-after region-name="footer" extent="{$marginBottom}mm"/>
					<fo:region-start region-name="left-region" extent="{$marginLeftRight1}mm"/>
					<fo:region-end region-name="right-region" extent="{$marginLeftRight2}mm"/>
				</fo:simple-page-master>
				
				<fo:simple-page-master master-name="commentary_first_page_odd" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
					<xsl:if test="$vertical_layout = 'true'">
						<xsl:attribute name="page-width"><xsl:value-of select="$pageHeight"/>mm</xsl:attribute>
						<xsl:attribute name="page-height"><xsl:value-of select="$pageWidth"/>mm</xsl:attribute>
					</xsl:if>
					<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm">
						<xsl:if test="$vertical_layout = 'true'">
							<xsl:attribute name="writing-mode">tb-rl</xsl:attribute>
						</xsl:if>
					</fo:region-body>
					<fo:region-before region-name="header-commentary-odd-first" extent="{$marginTop}mm"/>
					<fo:region-after region-name="footer" extent="{$marginBottom}mm"/>
					<fo:region-start region-name="left-region" extent="{$marginLeftRight1}mm"/>
					<fo:region-end region-name="right-region" extent="{$marginLeftRight2}mm"/>
				</fo:simple-page-master>
			
				<fo:page-sequence-master master-name="document_commentary_section">
					<fo:repeatable-page-master-alternatives>
						<fo:conditional-page-master-reference page-position="first" odd-or-even="even" master-reference="commentary_first_page_even"/>
						<fo:conditional-page-master-reference page-position="first" odd-or-even="odd" master-reference="commentary_first_page_odd"/>
						<fo:conditional-page-master-reference odd-or-even="even" master-reference="even"/>
						<fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd"/>
					</fo:repeatable-page-master-alternatives>
				</fo:page-sequence-master>
			
				<!-- landscape -->
				<fo:simple-page-master master-name="odd-landscape" page-width="{$pageHeight}mm" page-height="{$pageWidth}mm">
					<fo:region-body margin-top="{$marginLeftRight1}mm" margin-bottom="{$marginLeftRight2}mm" margin-left="{$marginBottom}mm" margin-right="{$marginTop}mm"/>
					<fo:region-before region-name="header-odd" extent="{$marginLeftRight1}mm" precedence="true"/>
					<fo:region-after region-name="footer" extent="{$marginLeftRight2}mm" precedence="true"/>
					<fo:region-start region-name="left-region-landscape" extent="{$marginBottom}mm"/>
					<fo:region-end region-name="right-region-landscape" extent="{$marginTop}mm"/>
				</fo:simple-page-master>
				<fo:simple-page-master master-name="even-landscape" page-width="{$pageHeight}mm" page-height="{$pageWidth}mm">
					<fo:region-body margin-top="{$marginLeftRight2}mm" margin-bottom="{$marginLeftRight1}mm" margin-left="{$marginBottom}mm" margin-right="{$marginTop}mm"/>
					<fo:region-before region-name="header-even" extent="{$marginLeftRight2}mm" precedence="true"/>
					<fo:region-after region-name="footer" extent="{$marginLeftRight1}mm" precedence="true"/>
					<fo:region-start region-name="left-region-landscape" extent="{$marginBottom}mm"/>
					<fo:region-end region-name="right-region-landspace" extent="{$marginTop}mm"/>
				</fo:simple-page-master>
				<fo:page-sequence-master master-name="document-landscape">
					<fo:repeatable-page-master-alternatives>
						<fo:conditional-page-master-reference odd-or-even="even" master-reference="even-landscape"/>
						<fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd-landscape"/>
					</fo:repeatable-page-master-alternatives>
				</fo:page-sequence-master>
			
				<fo:simple-page-master master-name="back-page_2024" page-width="{$pageWidthA5}mm" page-height="{$pageHeightA5}mm">
					<!-- Note (for writing-mode="tb-rl", may be due the update for support 'tb-rl' mode):
					 fo:region-body/@margin-top = left margin
					 fo:region-body/@margin-bottom = right margin
					 fo:region-body/margin-left = bottom margin
					 fo:region-body/margin-right = top margin
					-->
					<fo:region-body margin-top="5mm" margin-bottom="122mm" margin-left="6.5mm" margin-right="70mm" writing-mode="tb-rl"/>
					<fo:region-before region-name="header" extent="70mm"/>
					<fo:region-after region-name="footer" extent="6.5mm"/>
					<fo:region-start region-name="left-region" extent="5mm"/>
					<fo:region-end region-name="right-region" extent="122mm"/>
				</fo:simple-page-master>
			</fo:layout-master-set>
			
			<fo:declarations>
				<xsl:call-template name="addPDFUAmeta"/>
			</fo:declarations>

			<xsl:call-template name="addBookmarks">
				<xsl:with-param name="contents" select="$contents"/>
			</xsl:call-template>
			
			<xsl:variable name="updated_xml_step1">
				<xsl:apply-templates mode="update_xml_step1"/>
			</xsl:variable>
			<!-- DEBUG: updated_xml_step1=<xsl:copy-of select="$updated_xml_step1"/> -->
			<!-- <xsl:message>start redirect</xsl:message>
			<redirect:write file="update_xml_step1.xml">
				<xsl:copy-of select="$updated_xml_step1"/>
			</redirect:write>
			<xsl:message>end redirect</xsl:message> -->
			
			
			<xsl:variable name="updated_xml_step2_">
				<xsl:apply-templates select="xalan:nodeset($updated_xml_step1)" mode="update_xml_step2"/>
			</xsl:variable>
			<xsl:variable name="updated_xml_step2" select="xalan:nodeset($updated_xml_step2_)"/>
			<!-- DEBUG: updated_xml_step2=<xsl:copy-of select="$updated_xml_step2"/> -->
			
			
			<xsl:for-each select="$updated_xml_step2//jis:jis-standard">
				<xsl:variable name="num"><xsl:number level="any" count="jis:jis-standard"/></xsl:variable>
				
				<xsl:variable name="current_document">
					<xsl:copy-of select="."/>
				</xsl:variable>
				
				<xsl:for-each select="xalan:nodeset($current_document)">
				
					<xsl:variable name="docnumber" select="/*/jis:bibdata/jis:docnumber"/>
				
					<xsl:variable name="year_published" select="substring(/*/jis:bibdata/jis:date[@type = 'published']/jis:on, 1, 4)"/>
					
					<xsl:variable name="element_name_colon_gothic">colon_gothic</xsl:variable>
					<xsl:variable name="tag_colon_gothic_open">###<xsl:value-of select="$element_name_colon_gothic"/>###</xsl:variable>
					<xsl:variable name="tag_colon_gothic_close">###/<xsl:value-of select="$element_name_colon_gothic"/>###</xsl:variable>
					
					<xsl:variable name="docidentifier_" select="java:replaceAll(java:java.lang.String.new(/*/jis:bibdata/jis:docidentifier), '(:)', concat($tag_colon_gothic_open,'$1',$tag_colon_gothic_close))"/>
					
					<xsl:variable name="docidentifier__"><text><xsl:call-template name="replace_text_tags">
						<xsl:with-param name="tag_open" select="$tag_colon_gothic_open"/>
						<xsl:with-param name="tag_close" select="$tag_colon_gothic_close"/>
						<xsl:with-param name="text" select="$docidentifier_"/>
					</xsl:call-template></text></xsl:variable>
					
					<xsl:variable name="docidentifier">
						<xsl:apply-templates select="xalan:nodeset($docidentifier__)/node()"/>
					</xsl:variable>
					
					<xsl:variable name="copyrightText">
						<xsl:call-template name="getLocalizedString">
							<xsl:with-param name="key">permission_footer</xsl:with-param>
						</xsl:call-template>
					</xsl:variable>
					
					<xsl:variable name="doctype" select="/*/jis:bibdata/jis:ext/jis:doctype"/>
					
					<xsl:variable name="title_ja" select="/*/jis:bibdata/jis:title[@language = 'ja' and @type = 'main']"/>
					<xsl:variable name="title_en" select="/*/jis:bibdata/jis:title[@language = 'en' and @type = 'main']"/>
				
					<xsl:variable name="cover_header_footer_background_value" select="normalize-space(/*/jis:metanorma-extension/jis:presentation-metadata/jis:color-header-footer-background)"/>
					<xsl:variable name="cover_header_footer_background_">
						<xsl:value-of select="$cover_header_footer_background_value"/>
						<xsl:if test="$cover_header_footer_background_value = ''">#0B0968</xsl:if>
					</xsl:variable>
					<xsl:variable name="cover_header_footer_background" select="normalize-space($cover_header_footer_background_)"/>
					
					<xsl:variable name="docidentifier_JIS_" select="/*/jis:bibdata/jis:docidentifier[@type = 'JIS']"/>
					<xsl:variable name="docidentifier_JIS">
						<xsl:choose>
							<xsl:when test="contains($docidentifier_JIS_, ':')"><xsl:value-of select="substring-before($docidentifier_JIS_, ':')"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="$docidentifier_JIS_"/></xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="edition" select="/jis:jis-standard/jis:bibdata/jis:edition"/>
					
					<xsl:choose>
						<xsl:when test="$vertical_layout = 'true'">
							<xsl:call-template name="insertCoverPage2024">
								<xsl:with-param name="num" select="$num"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="insertCoverPage">
								<xsl:with-param name="num" select="$num"/>
								<xsl:with-param name="copyrightText" select="$copyrightText"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
										
					<xsl:call-template name="insertInnerCoverPage">
						<xsl:with-param name="docidentifier" select="$docidentifier"/>
						<xsl:with-param name="copyrightText" select="$copyrightText"/>
					</xsl:call-template>
				
				
					<!-- ========================== -->
					<!-- Contents and preface pages -->
					<!-- ========================== -->
					
					
					 
					<xsl:for-each select="/*/*[local-name()='preface']/*[not(local-name() = 'clause' and @type = 'contributors')]">
						<xsl:sort select="@displayorder" data-type="number"/>
						
						<xsl:choose>
							<xsl:when test="local-name() = 'clause' and @type = 'toc'">
								<fo:page-sequence master-reference="document_toc" force-page-count="no-force">
								
									<xsl:if test="$vertical_layout = 'true'">
										<xsl:attribute name="master-reference">document_toc_2024</xsl:attribute>
									</xsl:if>
						
									<xsl:if test="position() = 1">
										<xsl:attribute name="initial-page-number">1</xsl:attribute>
									</xsl:if>
									
									<xsl:choose>
										<xsl:when test="$vertical_layout = 'true'">
											<xsl:call-template name="insertLeftRightRegions">
												<xsl:with-param name="cover_header_footer_background" select="$cover_header_footer_background"/>
												<xsl:with-param name="title_ja" select="$title_ja"/>
												<xsl:with-param name="i18n_JIS" select="$i18n_JIS"/>
												<xsl:with-param name="docidentifier" select="concat('JIS ', $docidentifier_JIS)"/>
												<xsl:with-param name="edition" select="$edition"/>
												<xsl:with-param name="copyrightText" select="$copyrightText"/>
											</xsl:call-template>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="insertHeaderFooter">
												<xsl:with-param name="docidentifier" select="$docidentifier"/>
												<xsl:with-param name="copyrightText" select="$copyrightText"/>
												<xsl:with-param name="section">preface</xsl:with-param>
												<xsl:with-param name="section_title">
													<fo:inline font-family="IPAexGothic">
														<xsl:text>&#xa0;</xsl:text>
														<xsl:call-template name="getLocalizedString">
															<xsl:with-param name="key">table_of_contents</xsl:with-param>
														</xsl:call-template>
													</fo:inline>
												</xsl:with-param>
											</xsl:call-template>
										</xsl:otherwise>
									</xsl:choose>
									
									
									
									<fo:flow flow-name="xsl-region-body">
									
										<!-- <xsl:if test="$debug = 'true'">
											<redirect:write file="contents_.xml">
												<xsl:copy-of select="$contents"/>
											</redirect:write>
										</xsl:if> -->
										
										<xsl:apply-templates select=".">
											<xsl:with-param name="num" select="$num"/>
										</xsl:apply-templates>
										
										<!-- <xsl:if test="not(/*/*[local-name()='preface']/*[local-name() = 'clause'][@type = 'toc'])">
											<fo:block> --><!-- prevent fop error for empty document --><!-- </fo:block>
										</xsl:if> -->
										
									</fo:flow>
									
								</fo:page-sequence>
							</xsl:when><!-- end ToC -->
							<xsl:otherwise>
								<xsl:variable name="structured_xml_preface">
									<xsl:apply-templates select="." mode="linear_xml" />
								</xsl:variable>
								
								<xsl:variable name="paged_xml_preface_">
									<xsl:call-template name="makePagedXML">
										<xsl:with-param name="structured_xml" select="$structured_xml_preface"/>
									</xsl:call-template>
								</xsl:variable>
								<xsl:variable name="paged_xml_preface" select="xalan:nodeset($paged_xml_preface_)"/>
								
								<xsl:if test="$paged_xml_preface/*[local-name()='page'] and count($paged_xml_preface/*[local-name()='page']/*) != 0">
									<!-- Preface pages -->
									<fo:page-sequence master-reference="document_preface" force-page-count="no-force">
										
										<xsl:if test="position() = 1">
											<xsl:attribute name="initial-page-number">1</xsl:attribute>
										</xsl:if>
										
										<fo:static-content flow-name="xsl-footnote-separator">
											<fo:block text-align="center" margin-bottom="6pt">
												<fo:leader leader-pattern="rule" leader-length="80mm"/>
											</fo:block>
										</fo:static-content>
										
										<xsl:call-template name="insertHeaderFooter">
											<xsl:with-param name="docidentifier" select="$docidentifier"/>
											<xsl:with-param name="copyrightText" select="$copyrightText"/>
											<xsl:with-param name="section">preface</xsl:with-param>
										</xsl:call-template>
										
										<fo:flow flow-name="xsl-region-body">
										
											<fo:block>
												<xsl:for-each select="$paged_xml_preface/*[local-name()='page']">
													<xsl:if test="position() != 1">
														<fo:block break-after="page"/>
													</xsl:if>
													<xsl:apply-templates select="*" mode="page"/>
												</xsl:for-each>
											</fo:block>
										</fo:flow>
									</fo:page-sequence> <!-- END Preface pages -->
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
					
					
					<!-- Document type rendering -->
					<fo:page-sequence master-reference="document_preface" force-page-count="no-force">
						<xsl:call-template name="insertHeaderFooter">
							<xsl:with-param name="docidentifier" select="$docidentifier"/>
							<xsl:with-param name="copyrightText" select="$copyrightText"/>
							<xsl:with-param name="section">preface</xsl:with-param>
						</xsl:call-template>
						
						<fo:flow flow-name="xsl-region-body">
							<fo:block-container margin-left="70mm">
								<fo:block-container margin-left="0mm" margin-top="30mm" width="26.5mm" height="8.5mm" text-align="center" display-align="center" border="1pt solid black">
									<fo:block>
										<xsl:call-template name="getLocalizedString">
											<xsl:with-param name="key">white-paper</xsl:with-param>
										</xsl:call-template>
									</fo:block>
								</fo:block-container>
							</fo:block-container>
						</fo:flow>
					</fo:page-sequence>
					
					<!-- ========================== -->
					<!-- END Contents and preface pages -->
					<!-- ========================== -->
					
					
					<!-- item - page sequence -->
					<xsl:variable name="structured_xml_">
						
						<xsl:if test="not(/*/*[local-name()='preface']/*[local-name() = 'p' and @type = 'section-title'][following-sibling::*[1][local-name() = 'introduction']])">
							<item><xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name() = 'introduction']" mode="linear_xml" /></item>
						</xsl:if>
						
						<item>
							<xsl:choose>
								<xsl:when test="/*/*[local-name()='preface']/*[local-name() = 'p' and @type = 'section-title'][following-sibling::*[1][local-name() = 'introduction']]">
									<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name() = 'p' and @type = 'section-title'][following-sibling::*[1][local-name() = 'introduction']]" mode="linear_xml" />
									<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name() = 'introduction']" mode="linear_xml" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name() = 'p' and @type = 'section-title'][not(following-sibling::*) or following-sibling::*[1][local-name() = 'clause' and @type = 'corrigenda']]" mode="linear_xml" />
								</xsl:otherwise>
							</xsl:choose>
							
							<xsl:apply-templates select="/*/*[local-name()='sections']/*" mode="linear_xml"/>
						</item>	
						
						<!-- Annexes -->
						<!-- <xsl:for-each select="/*/*[local-name()='annex']">
							<item>
								<xsl:apply-templates select="." mode="linear_xml"/>
							</item>
						</xsl:for-each> -->
						
						<!-- Annexes and Bibliography -->
						<xsl:for-each select="/*/*[local-name()='annex'] | /*/*[local-name()='bibliography']/*[count(.//*[local-name() = 'bibitem'][not(@hidden) = 'true']) &gt; 0 and not(@hidden = 'true')]">
							<xsl:sort select="@displayorder" data-type="number"/>
							<item><xsl:apply-templates select="." mode="linear_xml"/></item>
						</xsl:for-each>
						
						<item>
							<xsl:copy-of select="//jis:indexsect" />
						</item>
						
					</xsl:variable>
					
					<!-- page break before each section -->
					<xsl:variable name="structured_xml">
						<xsl:for-each select="xalan:nodeset($structured_xml_)/item[*]">
							<xsl:element name="pagebreak" namespace="https://www.metanorma.org/ns/jis"/>
							<xsl:copy-of select="./*"/>
						</xsl:for-each>
					</xsl:variable>
					
					<!-- <xsl:if test="$debug = 'true'">
						<redirect:write file="structured_xml_.xml">
							<xsl:copy-of select="$structured_xml"/>
						</redirect:write>
					</xsl:if> -->
					
					<xsl:variable name="paged_xml">
						<xsl:call-template name="makePagedXML">
							<xsl:with-param name="structured_xml" select="$structured_xml"/>
						</xsl:call-template>
					</xsl:variable>
					<!-- paged_xml=<xsl:copy-of select="$paged_xml"/> -->
					
					<xsl:for-each select="xalan:nodeset($paged_xml)/*[local-name()='page'][*]">
					
						<xsl:variable name="isCommentary" select="normalize-space(.//jis:annex[@commentary = 'true'] and 1 = 1)"/> <!-- true or false -->
						<!-- DEBUG: <xsl:copy-of select="."/> -->
						<fo:page-sequence master-reference="document" force-page-count="no-force">
							
							<xsl:choose>
								<xsl:when test="$vertical_layout = 'true'">
									<xsl:attribute name="master-reference">document_2024</xsl:attribute>
									<xsl:attribute name="fox:number-conversion-features">&#x30A2;</xsl:attribute>
									
									
								</xsl:when>
								<xsl:otherwise>
									<xsl:if test="position() = 1">
										<xsl:attribute name="master-reference">document_first_section</xsl:attribute>
									</xsl:if>
									<xsl:if test="@orientation = 'landscape'">
										<xsl:attribute name="master-reference">document-<xsl:value-of select="@orientation"/></xsl:attribute>
									</xsl:if>
									<xsl:if test="$isCommentary = 'true'">
										<xsl:attribute name="master-reference">document_commentary_section</xsl:attribute>
									</xsl:if>
									<xsl:if test="position() = 1">
										<xsl:attribute name="initial-page-number">1</xsl:attribute>
									</xsl:if>
								</xsl:otherwise>
							</xsl:choose>
							
							
							<fo:static-content flow-name="xsl-footnote-separator">
								<fo:block>
									<fo:leader leader-pattern="rule" leader-length="15%"/>
								</fo:block>
							</fo:static-content>
							
							
							<xsl:variable name="section_title">
								<xsl:if test="$isCommentary = 'true'">
									<fo:inline font-family="IPAexGothic" padding-left="2mm">
										<xsl:text>&#xa0;</xsl:text>
										<xsl:call-template name="getLocalizedString">
											<xsl:with-param name="key">commentary</xsl:with-param>
										</xsl:call-template>
									</fo:inline>
								</xsl:if>
							</xsl:variable>
							
							<xsl:variable name="section">
								<xsl:choose>
									<xsl:when test="$isCommentary = 'true'">commentary</xsl:when>
									<xsl:otherwise>main</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							
							
							<xsl:choose>
								<xsl:when test="$vertical_layout = 'true'">
									<xsl:call-template name="insertLeftRightRegions">
										<xsl:with-param name="cover_header_footer_background" select="$cover_header_footer_background"/>
										<xsl:with-param name="title_ja" select="$title_ja"/>
										<xsl:with-param name="i18n_JIS" select="$i18n_JIS"/>
										<xsl:with-param name="docidentifier" select="concat('JIS ', $docidentifier_JIS)"/>
										<xsl:with-param name="edition" select="$edition"/>
										<xsl:with-param name="copyrightText" select="$copyrightText"/>
									</xsl:call-template>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="insertHeaderFooter">
										<xsl:with-param name="docidentifier" select="$docidentifier"/>
										<xsl:with-param name="copyrightText" select="$copyrightText"/>
										<xsl:with-param name="section" select="$section"/>
										<xsl:with-param name="section_title">
											<xsl:copy-of select="$section_title"/>
										</xsl:with-param>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
							
							<fo:flow flow-name="xsl-region-body">
								
								<!-- <xsl:if test="position() = 1">
									<fo:table table-layout="fixed" width="100%">
										<fo:table-column column-width="proportional-column-width(35)"/>
										<fo:table-column column-width="proportional-column-width(97)"/>
										<fo:table-column column-width="proportional-column-width(23)"/>
										<fo:table-column column-width="proportional-column-width(12)"/>
										<fo:table-body>
											<fo:table-row>
												<fo:table-cell><fo:block></fo:block></fo:table-cell>
												<fo:table-cell font-family="IPAexGothic" font-size="14pt" text-align="center">
													<fo:block>
														<xsl:call-template name="getLocalizedString">
															<xsl:with-param name="key">doctype_dict.<xsl:value-of select="$doctype"/></xsl:with-param>
														</xsl:call-template>
													</fo:block>
												</fo:table-cell>
												<fo:table-cell text-align="right">
													<fo:block font-family="Arial" font-size="16pt">
														<xsl:value-of select="java:replaceAll(java:java.lang.String.new($docnumber), '^(JIS)(.*)', '$1')"/>
														<fo:block/>
														<xsl:value-of select="java:replaceAll(java:java.lang.String.new($docnumber), '^(JIS)?(.*)', '$2')"/>
													</fo:block>
												</fo:table-cell>
												<fo:table-cell display-align="after">
													<fo:block font-size="10pt">
														<fo:inline baseline-shift="40%">
															<fo:inline font-family="IPAexMincho">：</fo:inline><fo:inline font-family="Times New Roman"><xsl:value-of select="$year_published"/></fo:inline>
														</fo:inline>
													</fo:block>
												</fo:table-cell>
												
											</fo:table-row>
										</fo:table-body>
									</fo:table>
									
									<fo:block font-family="IPAexGothic" font-size="19pt" text-align="center" margin-top="12mm" margin-bottom="4mm"><xsl:value-of select="$title_ja"/></fo:block>
									<fo:block font-family="Arial" font-size="13pt" text-align="center" margin-bottom="10mm"><xsl:value-of select="$title_en"/></fo:block>
									
								</xsl:if> -->
								
								
								<!-- Annex Commentary first page -->
								<!-- <xsl:if test="$isCommentary = 'true'"> -->
									
									<!-- Example: JIS Z 8301：2019  -->
									<!-- <fo:block font-family="IPAexGothic" font-size="15pt" text-align="center">
										<fo:inline font-family="Arial">JIS <xsl:value-of select="$docidentifier_number"/></fo:inline>
										<fo:inline baseline-shift="10%"><fo:inline font-size="10pt">：</fo:inline>
										<fo:inline font-family="Times New Roman" font-size="10pt"><xsl:value-of select="$docidentifier_year"/></fo:inline></fo:inline>
									</fo:block> -->

									<!-- title -->
									<!-- <fo:block role="H1" font-family="IPAexGothic" font-size="16pt" text-align="center" margin-top="6mm"><xsl:value-of select="$title_ja"/></fo:block> -->
								<!-- </xsl:if> -->
								
								<xsl:apply-templates select="*" mode="page"/>
								
								<xsl:if test="not(*)">
									<fo:block><!-- prevent fop error for empty document --></fo:block>
								</xsl:if>
								
							</fo:flow>
						</fo:page-sequence>
					</xsl:for-each>
					
				
					<xsl:if test="$vertical_layout = 'true'">
						<xsl:call-template name="insertBackPage2024">
							<xsl:with-param name="num" select="$num"/>
							<xsl:with-param name="copyrightText" select="$copyrightText"/>
						</xsl:call-template>
					</xsl:if>
				
				</xsl:for-each>
			
				
			
			</xsl:for-each>
			
			<xsl:if test="not(//jis:jis-standard)">
				<fo:page-sequence master-reference="document" force-page-count="no-force">
					<fo:flow flow-name="xsl-region-body">
						<fo:block><!-- prevent fop error for empty document --></fo:block>
					</fo:flow>
				</fo:page-sequence>
			</xsl:if>
			
		</fo:root>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'references'][not(@hidden = 'true')]" mode="linear_xml" priority="2">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="linear_xml"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'colon_gothic']">
		<!-- replace : to ： (Fullwidth colon) and render it in the font IPAexGothic -->
		<fo:inline font-family="IPAexGothic">：</fo:inline>
	</xsl:template>
	
	<xsl:template match="*[local-name()='preface']/*[local-name() = 'clause'][@type = 'toc']" priority="4">
		<xsl:param name="num"/>
		<xsl:apply-templates />
		<xsl:if test="count(*) = 1 and *[local-name() = 'title']"> <!-- if there isn't user ToC -->
			<!-- fill ToC -->
			<fo:block role="TOC" font-family="IPAexGothic">
			
				<xsl:if test="$vertical_layout = 'true'">
					<xsl:attribute name="font-family">Noto Serif JP</xsl:attribute>
					<xsl:attribute name="font-size">10.5pt</xsl:attribute>
				</xsl:if>
			
				<xsl:if test="$contents/doc[@num = $num]//item[@display = 'true']">
					<xsl:for-each select="$contents/doc[@num = $num]//item[@display = 'true'][@level &lt;= $toc_level or @type='figure' or @type = 'table']">
						<fo:block role="TOCI">
							<xsl:choose>
								<xsl:when test="@type = 'annex' or @type = 'bibliography'">
									<fo:block space-after="5pt">
										<xsl:if test="$vertical_layout = 'true'">
											<xsl:attribute name="space-after">8pt</xsl:attribute>
										</xsl:if>
										<xsl:call-template name="insertTocItem"/>
									</fo:block>
								</xsl:when>
								<xsl:otherwise>
									<fo:list-block space-after="5pt">
										<xsl:if test="$vertical_layout = 'true'">
											<xsl:attribute name="space-after">8pt</xsl:attribute>
										</xsl:if>
										<xsl:choose>
											<xsl:when test="$vertical_layout = 'true'">
												<xsl:attribute name="provisional-distance-between-starts">10mm</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:variable name="provisional-distance-between-starts">
													<xsl:choose>
														<xsl:when test="string-length(@section) = 1">5</xsl:when>
														<xsl:when test="string-length(@section) &gt;= 2"><xsl:value-of select="5 + (string-length(@section) - 1) * 2"/></xsl:when>
														<xsl:when test="@type = 'annex'">16</xsl:when>
														<xsl:otherwise>5</xsl:otherwise>
													</xsl:choose>
												</xsl:variable>
												<xsl:attribute name="provisional-distance-between-starts">
													<xsl:choose>
														<xsl:when test="$vertical_layout_rotate_clause_numbers = 'true'">
															<xsl:value-of select="concat($provisional-distance-between-starts * 1.5, 'mm')"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="concat($provisional-distance-between-starts, 'mm')"/>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:attribute>
												</xsl:otherwise>
											</xsl:choose>
										<fo:list-item>
											<fo:list-item-label end-indent="label-end()">
												<fo:block>
													<xsl:if test="not($vertical_layout = 'true') and @section != '' and @type != 'annex'">
														<xsl:attribute name="font-family">Times New Roman</xsl:attribute>
														<xsl:attribute name="font-weight">bold</xsl:attribute>
													</xsl:if>
													<xsl:value-of select="@section"/>
												</fo:block>
											</fo:list-item-label>
											<fo:list-item-body start-indent="body-start()">
												<xsl:call-template name="insertTocItem"/>
											</fo:list-item-body>
										</fo:list-item>
									</fo:list-block>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</xsl:for-each>
				</xsl:if>
			</fo:block>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'clause'][@type = 'toc']/*[local-name() = 'title']" priority="3">
		<fo:block text-align="center" font-size="14pt" font-family="IPAexGothic" margin-top="8.5mm">
			<xsl:if test="$vertical_layout = 'true'">
				<xsl:attribute name="text-align">left</xsl:attribute>
				<xsl:attribute name="font-family">Noto Serif JP</xsl:attribute>
				<xsl:attribute name="font-weight">bold</xsl:attribute>
				<xsl:attribute name="margin-top">26mm</xsl:attribute>
			</xsl:if>
			<!-- Contents -->
			<!-- <xsl:call-template name="getLocalizedString">
				<xsl:with-param name="key">table_of_contents</xsl:with-param>
			</xsl:call-template> -->
			<fo:marker marker-class-name="section_title">
				<xsl:variable name="section_title"><xsl:apply-templates/></xsl:variable>
				<xsl:value-of select="translate($section_title, '　', '')"/>
			</fo:marker>
			<xsl:apply-templates/>
		</fo:block>
		<fo:block text-align="right" font-size="8pt" font-family="IPAexMincho" margin-top="10mm">
			<xsl:if test="$vertical_layout = 'true'">
				<xsl:attribute name="font-size">10.5pt</xsl:attribute>
				<xsl:attribute name="font-family">Noto Serif JP</xsl:attribute>
				<xsl:attribute name="margin-top">1mm</xsl:attribute>
				<xsl:attribute name="margin-bottom">6mm</xsl:attribute>
			</xsl:if>
			<!-- Page -->
			<xsl:call-template name="getLocalizedString">
				<xsl:with-param name="key">locality.page</xsl:with-param>
			</xsl:call-template>
		</fo:block>
	</xsl:template>
	
	
	<xsl:template name="insertTocItem">
		<fo:block text-align-last="justify" role="TOCI">
			<fo:basic-link internal-destination="{@id}" fox:alt-text="{title}">
				<fo:inline>
					<xsl:if test="$vertical_layout = 'true'">
						<xsl:attribute name="padding-right">7.5mm</xsl:attribute>
					</xsl:if>
					<xsl:apply-templates select="title" />
				</fo:inline>
				<fo:inline keep-together.within-line="always">
					<fo:leader leader-pattern="dots">
						<xsl:if test="$vertical_layout = 'true'">
							<xsl:attribute name="leader-pattern">rule</xsl:attribute>
							<xsl:attribute name="rule-thickness">0.5pt</xsl:attribute>
							<xsl:attribute name="baseline-shift">60%</xsl:attribute>
						</xsl:if>
					</fo:leader>
					<fo:inline>
						<xsl:if test="not($vertical_layout = 'true')">
							<xsl:attribute name="font-size">8pt</xsl:attribute>
							<xsl:attribute name="font-family">Times New Roman</xsl:attribute>
						</xsl:if>
						<xsl:if test="$vertical_layout = 'true'">
							<xsl:attribute name="padding-left">6mm</xsl:attribute>
						</xsl:if>
						<fo:page-number-citation ref-id="{@id}"/>
					</fo:inline>
				</fo:inline>
			</fo:basic-link>
		</fo:block>
	</xsl:template>
	
	<!-- docidentifier, 3 part: number, colon and year-->
	<xsl:variable name="docidentifier_jis" select="/*/jis:bibdata/jis:docidentifier[@type = 'JIS']"/>
	<xsl:variable name="docidentifier_number" select="java:replaceAll(java:java.lang.String.new($docidentifier_jis), '^(.*)(:)(.*)$', '$1')"/>
	<xsl:variable name="docidentifier_year" select="java:replaceAll(java:java.lang.String.new($docidentifier_jis), '^(.*)(:)(.*)$', '$3')"/>
	<xsl:template name="insertCoverPage">
		<xsl:param name="num"/>
		<xsl:param name="copyrightText"/>
		<fo:page-sequence master-reference="cover-page" force-page-count="no-force">
			<xsl:call-template name="insertFooter">
				<xsl:with-param name="copyrightText" select="$copyrightText"/>
			</xsl:call-template>
				
			<fo:flow flow-name="xsl-region-body">
				<!-- JIS -->
				<fo:block id="firstpage_id_{$num}">
					<fo:instream-foreign-object content-width="81mm" fox:alt-text="JIS Logo">
						<xsl:copy-of select="$JIS-Logo"/>
					</fo:instream-foreign-object>
				</fo:block>
				
				<fo:block-container text-align="center">
					<!-- title -->
					<fo:block role="H1" font-family="IPAexGothic" font-size="22pt" margin-top="27mm"><xsl:apply-templates select="/*/jis:bibdata/jis:title[@language = 'ja' and @type = 'main']/node()"/></fo:block>
					
					<fo:block font-family="IPAexGothic" font-size="20pt" margin-top="15mm">
						<fo:inline font-family="Arial">JIS <xsl:value-of select="$docidentifier_number"/></fo:inline>
						<fo:inline baseline-shift="20%"><fo:inline font-size="10pt">：</fo:inline>
						<fo:inline font-family="Times New Roman" font-size="10pt"><xsl:value-of select="$docidentifier_year"/></fo:inline></fo:inline>
					</fo:block>
					<fo:block font-family="Arial" font-size="14pt" margin-top="12mm">
						<fo:inline font-family="IPAexMincho">（</fo:inline>
						<!-- JSA -->
						<xsl:value-of select="/*/jis:bibdata/jis:copyright/jis:owner/jis:organization/jis:abbreviation"/>
						<fo:inline font-family="IPAexMincho">）</fo:inline></fo:block>
				</fo:block-container>
				
				<fo:block-container absolute-position="fixed" left="0mm" top="200mm" height="69mm" text-align="center" display-align="after" font-family="IPAexMincho">
					<!-- Revised on July 22, 2019 -->
					<!-- <fo:block font-size="9pt">令和元年<fo:inline font-family="Times New Roman"> 7 </fo:inline>月<fo:inline font-family="Times New Roman"> 22 </fo:inline>日 改正</fo:block> -->
					<fo:block font-size="9pt"><xsl:apply-templates select="/*/jis:bibdata/jis:date[@type = 'published']/text()"/> 改正</fo:block>
					<!-- Japan Industrial Standards Survey Council deliberations -->
					<!-- 日本産業標準調査会 -->
					<fo:block font-size="14pt" margin-top="7mm"><xsl:value-of select="/*/jis:bibdata/jis:contributor[jis:role/@type = 'authorizer']/jis:organization/jis:name/jis:variant[@language = 'ja']"/> 審議</fo:block>
					<!-- (Issued by the Japan Standards Association) -->
					<!-- 日本規格協会 -->
					<fo:block font-size="9pt" margin-top="6.5mm">（<xsl:value-of select="/*/jis:bibdata/jis:contributor[jis:role/@type = 'publisher']/jis:organization/jis:name/jis:variant[@language = 'ja']"/> 発行）</fo:block>
				</fo:block-container>
			</fo:flow>
		</fo:page-sequence>
	</xsl:template> <!-- insertCoverPage -->
	
	<xsl:variable name="i18n_JIS"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">JIS</xsl:with-param></xsl:call-template></xsl:variable>
	<xsl:template name="insertCoverPage2024">
		<xsl:param name="num"/>
		
		<fo:page-sequence master-reference="cover-page_2024" force-page-count="no-force">
			
			<!-- <xsl:variable name="cover_page_background_1_value" select="normalize-space(//jis:jis-standard/jis:metanorma-extension/jis:presentation-metadata/jis:color-cover-page-background-1)"/>
			<xsl:variable name="cover_page_background_1_">
				<xsl:value-of select="$cover_page_background_1_value"/>
				<xsl:if test="$cover_page_background_1_value = ''">#00063F</xsl:if>
			</xsl:variable>
			<xsl:variable name="cover_page_background_1" select="normalize-space($cover_page_background_1_)"/>
			
			<xsl:variable name="cover_page_background_2_value" select="normalize-space(//jis:jis-standard/jis:metanorma-extension/jis:presentation-metadata/jis:color-cover-page-background-2)"/>
			<xsl:variable name="cover_page_background_2_">
				<xsl:value-of select="$cover_page_background_2_value"/>
				<xsl:if test="$cover_page_background_2_value = ''">#DBD6BD</xsl:if>
			</xsl:variable>
			<xsl:variable name="cover_page_background_2" select="normalize-space($cover_page_background_2_)"/> -->
			
			
			<fo:static-content flow-name="header">
				<xsl:call-template name="insertBackgroundPageImage"/>
				
				<!-- vertical bar -->
				<!-- <xsl:call-template name="insertBackgroundColor">
					<xsl:with-param name="opacity">0.58</xsl:with-param>
					<xsl:with-param name="color_background" select="$cover_page_background_1"/>
					<xsl:with-param name="width">20mm</xsl:with-param>
					<xsl:with-param name="absolute_position">true</xsl:with-param>
				</xsl:call-template> -->
				
				<!-- vertical bar -->
				<!-- <xsl:call-template name="insertBackgroundColor">
					<xsl:with-param name="opacity">0.75</xsl:with-param>
					<xsl:with-param name="color_background" select="$cover_page_background_2"/>
					<xsl:with-param name="width">46.5mm</xsl:with-param>
					<xsl:with-param name="absolute_position">true</xsl:with-param>
					<xsl:with-param name="left">20mm</xsl:with-param>
				</xsl:call-template> -->
				
				<!-- vertical bar -->
				<!-- <xsl:call-template name="insertBackgroundColor">
					<xsl:with-param name="opacity">0.75</xsl:with-param>
					<xsl:with-param name="color_background" select="$cover_page_background_2"/>
					<xsl:with-param name="width">10.7mm</xsl:with-param>
					<xsl:with-param name="absolute_position">true</xsl:with-param>
					<xsl:with-param name="left">133.8mm</xsl:with-param>
				</xsl:call-template> -->
				
				<!-- vertical bar -->
				<!-- <xsl:call-template name="insertBackgroundColor">
					<xsl:with-param name="opacity">0.58</xsl:with-param>
					<xsl:with-param name="color_background" select="$cover_page_background_1"/>
					<xsl:with-param name="width">17mm</xsl:with-param>
					<xsl:with-param name="absolute_position">true</xsl:with-param>
					<xsl:with-param name="left">131mm</xsl:with-param>
				</xsl:call-template> -->
				
			</fo:static-content>
			
			<fo:static-content flow-name="left-region">
				<fo:table table-layout="fixed" width="9mm" font-size="10pt" font-weight="bold" color="white" margin-left="2.7mm" margin-top="-1mm" line-height="1.5">
					<fo:table-column column-width="proportional-column-width(3)"/>
					<fo:table-column column-width="proportional-column-width(2.2)"/>
					<fo:table-column column-width="proportional-column-width(3)"/>
					<fo:table-body>
						<fo:table-row height="50mm">
							<fo:table-cell>
								<fo:block><xsl:value-of select="/*/jis:bibdata/jis:contributor[jis:role/@type = 'publisher']/jis:organization/jis:name/jis:variant[@language = 'ja']"/></fo:block>
							</fo:table-cell>
							<fo:table-cell><fo:block>&#xa0;</fo:block></fo:table-cell>
							<fo:table-cell>
								<fo:block><xsl:value-of select="/*/jis:bibdata/jis:contributor[jis:role/@type = 'authorizer']//jis:organization/jis:name"/></fo:block>
							</fo:table-cell>
						</fo:table-row>
						<fo:table-row>
							<fo:table-cell>
								<fo:block>発行</fo:block>
							</fo:table-cell>
							<fo:table-cell><fo:block>&#xa0;</fo:block></fo:table-cell>
							<fo:table-cell>
								<fo:block>審議</fo:block>
							</fo:table-cell>
						</fo:table-row>
					</fo:table-body>
				</fo:table>
			</fo:static-content>
			
			<!-- <fo:static-content flow-name="left-region"> -->
				
	
				<!-- JIS, JSA_logos -->
				<!-- <fo:block-container absolute-position="fixed" left="2.4mm" top="171mm" font-size="0">
					<fo:block id="firstpage_id_{$num}" margin-left="2mm">
						<fo:instream-foreign-object content-width="12.1mm" fox:alt-text="JIS Logo">
							<xsl:copy-of select="$JIS-Logo_2024"/>
						</fo:instream-foreign-object>
					</fo:block>
					<fo:block margin-top="3mm">
						<fo:instream-foreign-object content-width="15.2mm" fox:alt-text="JSA Logo">
							<xsl:copy-of select="$JSA-Logo_2024"/>
						</fo:instream-foreign-object>
					</fo:block>
				</fo:block-container>
			</fo:static-content> -->
			
			<fo:flow flow-name="xsl-region-body" font-family="Noto Serif JP">
			
				<fo:block font-weight="900" font-size="14pt" color="white" letter-spacing="2.5mm">
					<xsl:value-of select="$i18n_JIS"/>
				</fo:block>
				
				
				<fo:block margin-top="75mm" font-size="14pt" font-weight="500">
					
					<fo:inline-container writing-mode="lr-tb" text-align="center"
																		 alignment-baseline="central" reference-orientation="90" width="1em" margin="0" padding="0"
																		 text-indent="0mm" last-line-end-indent="0mm" start-indent="0mm" end-indent="0mm">
							
							<xsl:variable name="blocks">
								<xsl:call-template name="insertEachCharInBlock">
									<xsl:with-param name="str">JIS <xsl:value-of select="java:replaceAll(java:java.lang.String.new($docidentifier_number), ' ', '  ')"/></xsl:with-param>
									<xsl:with-param name="spaceIndent">0.5em</xsl:with-param>
									<xsl:with-param name="lineHeight">1.1em</xsl:with-param>
								</xsl:call-template>
								<fo:block line-height="1em" margin-top="0.2em"/>
							</xsl:variable>
							<xsl:variable name="blocksWidth">
								<xsl:for-each select="xalan:nodeset($blocks)//@line-height[normalize-space(..) != '']">
									<width><xsl:value-of select="substring-before(.,'em')"/></width>
								</xsl:for-each>
								<xsl:for-each select="xalan:nodeset($blocks)//@margin-top">
									<width><xsl:value-of select="substring-before(.,'em')"/></width>
								</xsl:for-each>
							</xsl:variable>
							<xsl:attribute name="width"><xsl:value-of select="sum(xalan:nodeset($blocksWidth)//width)"/>em</xsl:attribute>
							<fo:block-container width="1em">
								<xsl:copy-of select="$blocks"/>
							</fo:block-container>
					</fo:inline-container>
					
					<fo:inline font-size="8.16pt" baseline-shift="20%">:</fo:inline>
					
					<fo:inline-container writing-mode="lr-tb" text-align="center"
																		 alignment-baseline="central" reference-orientation="90" width="1em" margin="0" padding="0"
																		 text-indent="0mm" last-line-end-indent="0mm" start-indent="0mm" end-indent="0mm">
							<fo:block-container width="1em">
								<fo:block line-height="1em" margin-top="0.2em"/>
								<fo:block font-size="8.16pt" baseline-shift="20%">
									<xsl:call-template name="insertEachCharInBlock">
										<xsl:with-param name="str"><xsl:value-of select="$docidentifier_year"/></xsl:with-param>
										<xsl:with-param name="lineHeight">1em</xsl:with-param>
									</xsl:call-template>
								</fo:block>
							</fo:block-container>
					</fo:inline-container>
				</fo:block>
				
				
				<fo:block margin-top="2mm" font-size="24pt" letter-spacing="2mm" font-weight="bold">
					<xsl:apply-templates select="/*/jis:bibdata/jis:title[@language = 'ja' and @type = 'main']/node()"/>
				</fo:block>
				
				<fo:block margin-top="3mm" font-size="11pt" font-weight="500">
					<xsl:apply-templates select="/*/jis:bibdata/jis:title[@language = 'en' and @type = 'main']/node()"/>
				</fo:block>
				
				<fo:block margin-top="6.5mm" font-size="8pt" font-weight="500">
					<fo:inline padding-right="5mm"><xsl:apply-templates select="/*/jis:bibdata/jis:date[@type = 'published']/text()"/></fo:inline>改正
				</fo:block>
				
				<!--
				
				<fo:block font-size="10pt" font-weight="bold" color="white">
					2<xsl:value-of select="/*/jis:bibdata/jis:contributor[jis:role/@type = 'publisher']/jis:organization/jis:name/jis:variant[@language = 'ja']"/> 発行
				</fo:block> -->
				
				
			</fo:flow>
		</fo:page-sequence>
	</xsl:template> <!-- insertCoverPage2024 -->
	
	<xsl:template name="insertBackPage2024">
		<xsl:param name="num"/>
		<xsl:param name="copyrightText"/>
		
		<fo:page-sequence master-reference="back-page_2024" force-page-count="no-force" font-family="Noto Serif JP" font-weight="500">

			<fo:static-content flow-name="header">
				<xsl:variable name="presentation_metadata_image_name">
					<xsl:choose>
						<xsl:when test="/*[contains(local-name(), '-standard')]/*[local-name() = 'metanorma-extension']/*[local-name() = 'presentation-metadata'][*[local-name() = 'name'] = 'backpage-image']/*[local-name() = 'value']/*[local-name() = 'image']">backpage-image</xsl:when>
						<xsl:otherwise>coverpage-image</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:call-template name="insertBackgroundPageImage">
					<xsl:with-param name="name" select="$presentation_metadata_image_name"/>
				</xsl:call-template>
			</fo:static-content>
			
			<fo:flow flow-name="xsl-region-body">
				<!-- publication date -->
				<fo:block font-size="8pt" margin-left="90mm" text-align-last="justify" letter-spacing="0.5mm">
					<xsl:apply-templates select="/*/jis:bibdata/jis:date[@type = 'published']/text()"/>
					<fo:inline keep-together.within-line="always">
						<fo:leader leader-pattern="space"/>
						<xsl:text>発行</xsl:text>
					</fo:inline>
				</fo:block>
				<!-- revision date -->
				<fo:block font-size="8pt" margin-left="90mm" text-align-last="justify" letter-spacing="0.5mm">
					<xsl:apply-templates select="/*/jis:bibdata/jis:date[@type = 'revised']/text()"/>
					<fo:inline keep-together.within-line="always">
						<fo:leader leader-pattern="space"/>
						<xsl:text>改正</xsl:text>
					</fo:inline>
				</fo:block>
				<fo:block font-size="12pt" margin-top="7mm" text-align="right"><xsl:value-of select="$copyrightText"/></fo:block>
			</fo:flow>
		</fo:page-sequence>
	</xsl:template> <!-- insertBackPage2024 -->
	
	<xsl:template name="insertBackgroundColor">
		<xsl:param name="opacity">1</xsl:param>
		<xsl:param name="color_background">#ffffff</xsl:param>
		<xsl:param name="width">20mm</xsl:param>
		<xsl:param name="absolute_position">false</xsl:param>
		<xsl:param name="left"/>
		
		<!-- background color -->
		<fo:block-container font-size="0"> <!-- absolute-position="fixed" left="0" top="0"  -->
			<xsl:if test="$absolute_position = 'true'">
				<xsl:attribute name="absolute-position">fixed</xsl:attribute>
				<xsl:attribute name="top">0</xsl:attribute>
			</xsl:if>
			<xsl:if test="normalize-space($left) != ''">
				<xsl:attribute name="left"><xsl:value-of select="$left"/></xsl:attribute>
			</xsl:if>
			<fo:block>
				<fo:instream-foreign-object content-height="{$pageHeight}mm" fox:alt-text="Background color">
					<svg xmlns="http://www.w3.org/2000/svg" version="1.0" width="{$width}" height="{$pageHeight}mm">
						<rect width="{$pageWidth}mm" height="{$pageHeight}mm" style="fill:{$color_background};stroke-width:0;fill-opacity:{$opacity}"/>
					</svg>
				</fo:instream-foreign-object>
			</fo:block>
		</fo:block-container>
	</xsl:template>
	
	<xsl:template name="insertInnerCoverPage">
		<xsl:param name="docidentifier"/>
		<xsl:param name="copyrightText"/>
		<fo:page-sequence master-reference="document" force-page-count="no-force">
		
			<fo:static-content flow-name="xsl-footnote-separator">
				<fo:block text-align="center" margin-bottom="6pt">
					<fo:leader leader-pattern="rule" leader-length="80mm" rule-style="solid" rule-thickness="0.3pt"/>
				</fo:block>
			</fo:static-content>
			
			<xsl:call-template name="insertHeaderFooter">
				<xsl:with-param name="docidentifier" select="$docidentifier"/>
				<xsl:with-param name="copyrightText" select="$copyrightText"/>
			</xsl:call-template>
				
			<fo:flow flow-name="xsl-region-body">
				<fo:block-container font-size="9pt" margin-top="5mm">
					
					<xsl:apply-templates select="/*/*[local-name() = 'preface']/*[local-name() = 'clause'][@type = 'contributors']" />
					
					<fo:block>
						<fo:footnote>
							<fo:inline></fo:inline>
							<fo:footnote-body>
								<fo:block font-size="8.5pt">
									<!-- <xsl:apply-templates select="/*/*[local-name() = 'preface']/*[local-name() = 'clause'][@type = 'inner-cover-note']" /> -->
									<xsl:apply-templates select="/*/*[local-name() = 'boilerplate']" />
								</fo:block>
							</fo:footnote-body>
						</fo:footnote>
					</fo:block>
				</fo:block-container>
			</fo:flow>
		</fo:page-sequence>
	</xsl:template> <!-- insertInnerCoverPage -->
	
	<xsl:template match="jis:p[@class = 'JapaneseIndustrialStandard']" priority="4">
		<fo:table table-layout="fixed" width="100%">
			<fo:table-column column-width="proportional-column-width(36)"/>
			<fo:table-column column-width="proportional-column-width(92)"/>
			<fo:table-column column-width="proportional-column-width(36)"/>
			<fo:table-body>
				<fo:table-row>
					<fo:table-cell>
						<fo:block>&#xa0;</fo:block>
					</fo:table-cell>
					<fo:table-cell font-family="IPAexGothic" font-size="14pt" text-align="center">
						<fo:block><xsl:apply-templates /></fo:block>
					</fo:table-cell>
					<fo:table-cell padding-left="5mm">
						<fo:block font-family="Arial" font-size="16pt">
							<xsl:apply-templates select="jis:span[@class = 'JIS']">
								<xsl:with-param name="process">true</xsl:with-param>
							</xsl:apply-templates>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
			</fo:table-body>
		</fo:table>
	</xsl:template>
	
	<xsl:template match="jis:p[@class = 'StandardNumber']" priority="4">
		<fo:table table-layout="fixed" width="100%">
			<fo:table-column column-width="proportional-column-width(36)"/>
			<fo:table-column column-width="proportional-column-width(92)"/>
			<fo:table-column column-width="proportional-column-width(36)"/>
			<fo:table-body>
				<fo:table-row>
					<fo:table-cell>
						<fo:block>&#xa0;</fo:block>
					</fo:table-cell>
					<fo:table-cell>
						<fo:block>&#xa0;</fo:block>
					</fo:table-cell>
					<fo:table-cell>
						<fo:block>
							<xsl:apply-templates />
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
			</fo:table-body>
		</fo:table>
	</xsl:template>
	
	<xsl:template match="jis:p[@class = 'StandardNumber']//text()[not(ancestor::jis:span)]" priority="4">
		<fo:inline font-family="Arial" font-size="16pt">
			<xsl:choose>
				<xsl:when test="contains(., ':')">
					<xsl:value-of select="substring-before(., ':')"/>
					<fo:inline baseline-shift="10%" font-size="10pt" font-family="IPAexMincho">：</fo:inline>
					<xsl:value-of select="substring-after(., ':')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="jis:p[@class = 'StandardNumber']/jis:span[@class = 'EffectiveYear']" priority="4">
		<fo:inline font-size="10pt" baseline-shift="10%">
			<fo:inline font-family="Times New Roman"><xsl:apply-templates/></fo:inline>
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="jis:p[@class = 'JapaneseIndustrialStandard']/jis:tab" priority="4"/>
		<!-- <fo:inline role="SKIP" padding-right="0mm">&#x200B;</fo:inline>
	</xsl:template> -->
	<xsl:template match="jis:p[@class = 'JapaneseIndustrialStandard']/jis:span[@class = 'JIS']" priority="4">
		<xsl:param name="process">false</xsl:param>
		<xsl:if test="$process = 'true'">
			<fo:inline font-size="16pt" font-family="Arial"><xsl:apply-templates/></fo:inline>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="jis:p[@class = 'zzSTDTitle1']" priority="4">
		<fo:block font-family="IPAexGothic" font-size="19pt" text-align="center" margin-top="12mm" margin-bottom="4mm">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="jis:p[@class = 'zzSTDTitle2']" priority="4">
		<fo:block font-family="Arial" font-size="13pt" text-align="center" margin-bottom="10mm">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<!-- for commentary annex -->
	<xsl:template match="jis:p[@class = 'CommentaryStandardNumber']" priority="4">
		<fo:block font-family="IPAexGothic" font-size="15pt" text-align="center">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="jis:p[@class = 'CommentaryStandardNumber']//text()[not(ancestor::jis:span)]" priority="4">
		<fo:inline font-family="Arial">
			<xsl:choose>
				<xsl:when test="contains(., ':')">
					<xsl:value-of select="substring-before(., ':')"/>
					<fo:inline baseline-shift="10%" font-size="10pt" font-family="IPAexMincho">：</fo:inline>
					<xsl:value-of select="substring-after(., ':')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="jis:p[@class = 'CommentaryStandardNumber']/jis:span[@class = 'CommentaryEffectiveYear']" priority="4">
		<fo:inline  baseline-shift="10%" font-family="Times New Roman" font-size="10pt"><xsl:apply-templates/></fo:inline>
	</xsl:template>
	
	<xsl:template match="jis:p[@class = 'CommentaryStandardName']" priority="4">
		<fo:block role="H1" font-family="IPAexGothic" font-size="16pt" text-align="center" margin-top="6mm">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	
	<!-- ============================= -->
	<!-- CONTENTS                      -->
	<!-- ============================= -->
	
	<!-- element with title -->
	<xsl:template match="*[jis:title]" mode="contents">
	
		<xsl:variable name="level">
			<xsl:call-template name="getLevel">
				<xsl:with-param name="depth" select="jis:title/@depth"/>
			</xsl:call-template>
		</xsl:variable>
		
		<!-- if previous clause contains section-title as latest element (section-title may contain  note's, admonition's, etc.),
		and if @depth of current clause equals to section-title @depth,
		then put section-title before current clause -->
		<xsl:if test="local-name() = 'clause'">
			<xsl:apply-templates select="preceding-sibling::*[1][local-name() = 'clause']//*[local-name() = 'p' and @type = 'section-title'
				and @depth = $level 
				and not(following-sibling::*[local-name()='clause'])]" mode="contents_in_clause"/>
		</xsl:if>
		
		<xsl:variable name="section">
			<xsl:call-template name="getSection"/>
		</xsl:variable>
		
		<xsl:variable name="type">
			<xsl:choose>
				<xsl:when test="local-name() = 'indexsect'">index</xsl:when>
				<xsl:when test="(ancestor-or-self::jis:bibliography and local-name() = 'clause' and not(.//*[local-name() = 'references' and @normative='true'])) or self::jis:references[not(@normative) or @normative='false']">bibliography</xsl:when>
				<xsl:otherwise><xsl:value-of select="local-name()"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
			
		<xsl:variable name="display">
			<xsl:choose>
				<xsl:when test="normalize-space(@id) = ''">false</xsl:when>
				<xsl:when test="ancestor-or-self::jis:annex and $level &gt;= 2">false</xsl:when>
				<xsl:when test="$type = 'bibliography' and $level &gt;= 2">false</xsl:when>
				<xsl:when test="$type = 'bibliography'">true</xsl:when>
				<xsl:when test="$type = 'references' and $level &gt;= 2">false</xsl:when>
				<xsl:when test="ancestor-or-self::jis:colophon">true</xsl:when>
				<xsl:when test="$section = '' and $type = 'clause' and $level = 1 and ancestor::jis:preface">true</xsl:when>
				<xsl:when test="$section = '' and $type = 'clause'">false</xsl:when>
				<xsl:when test="$level &lt;= $toc_level">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="skip">
			<xsl:choose>
				<xsl:when test="ancestor-or-self::jis:bibitem">true</xsl:when>
				<xsl:when test="ancestor-or-self::jis:term">true</xsl:when>				
				<xsl:when test="@type = 'corrigenda'">true</xsl:when>
				<xsl:when test="@type = 'policy'">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		
		<xsl:if test="$skip = 'false'">		
		
			<xsl:variable name="title">
				<xsl:call-template name="getName"/>
			</xsl:variable>
			
			<xsl:variable name="root">
				<xsl:if test="ancestor-or-self::jis:preface">preface</xsl:if>
				<xsl:if test="ancestor-or-self::jis:annex">annex</xsl:if>
			</xsl:variable>
			
			<item id="{@id}" level="{$level}" section="{$section}" type="{$type}" root="{$root}" display="{$display}">
				<xsl:if test="$type = 'index'">
					<xsl:attribute name="level">1</xsl:attribute>
				</xsl:if>
				<title>
					<xsl:apply-templates select="xalan:nodeset($title)" mode="contents_item">
						<xsl:with-param name="mode">contents</xsl:with-param>
					</xsl:apply-templates>
				</title>
				<xsl:if test="$type != 'index'">
					<xsl:apply-templates  mode="contents" />
				</xsl:if>
			</item>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'preface']/*[local-name() = 'clause']" priority="3">
		<fo:block>
			<xsl:call-template name="setId"/>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="*" priority="3" mode="page">
		<xsl:call-template name="elementProcessing"/>
	</xsl:template>
	
	<xsl:template name="elementProcessing">
		<xsl:choose>
			<xsl:when test="local-name() = 'p' and count(node()) = count(processing-instruction())"><!-- skip --></xsl:when> <!-- empty paragraph with processing-instruction -->
			<xsl:when test="@hidden = 'true'"><!-- skip --></xsl:when>
			<xsl:when test="local-name() = 'title' or local-name() = 'term'">
				<xsl:apply-templates select="."/>
			</xsl:when>
			<xsl:when test="@mainsection = 'true'">
				<!-- page break before section's title -->
				<xsl:if test="local-name() = 'p' and @type='section-title'">
					<fo:block break-after="page"/>
				</xsl:if>
				<fo:block-container>
					<xsl:attribute name="keep-with-next">always</xsl:attribute>
					<fo:block><xsl:apply-templates select="."/></fo:block>
				</fo:block-container>
			</xsl:when>
			<xsl:when test="local-name() = 'indexsect'">
				<xsl:apply-templates select="." mode="index"/>
			</xsl:when>
			<xsl:otherwise>
				<fo:block>
					<xsl:if test="not(node())">
						<xsl:attribute name="keep-with-next">always</xsl:attribute>
					</xsl:if>
					<xsl:apply-templates select="."/>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<xsl:template match="jis:title" priority="2" name="title">
	
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		
		<xsl:variable name="font-family">IPAexGothic</xsl:variable>
		
		<xsl:variable name="font-size">
			<xsl:choose>
				<xsl:when test="@type = 'section-title'">18pt</xsl:when>
				<xsl:when test="@ancestor = 'foreword' and $level = '1'">14pt</xsl:when>
				<xsl:when test="@ancestor = 'annex' and $level = '1' and preceding-sibling::*[local-name() = 'annex'][1][@commentary = 'true']">16pt</xsl:when>
				<xsl:when test="@ancestor = 'annex' and $level = '1'">14pt</xsl:when>
				<!-- <xsl:when test="@ancestor = 'foreword' and $level &gt;= '2'">12pt</xsl:when>
				<xsl:when test=". = 'Executive summary'">18pt</xsl:when>
				<xsl:when test="@ancestor = 'introduction' and $level = '1'">18pt</xsl:when>
				<xsl:when test="@ancestor = 'introduction' and $level &gt;= '2'">11pt</xsl:when>
				<xsl:when test="@ancestor = 'sections' and $level = '1'">14pt</xsl:when>
				<xsl:when test="@ancestor = 'sections' and $level = '2'">11pt</xsl:when>
				<xsl:when test="@ancestor = 'sections' and $level &gt;= '3'">10pt</xsl:when>
				<xsl:when test="@ancestor = 'sections' and $level = '2' and preceding-sibling::*[1][local-name() = 'references']">inherit</xsl:when>
				<xsl:when test="@ancestor = 'sections' and $level = '2'">11pt</xsl:when>
				<xsl:when test="@ancestor = 'sections' and $level &gt;= '3' and preceding-sibling::*[1][local-name() = 'terms']">11pt</xsl:when>
				<xsl:when test="@ancestor = 'sections' and $level = '3'">10.5pt</xsl:when>
				<xsl:when test="@ancestor = 'sections' and $level &gt;= '4'">10pt</xsl:when>
				
				<xsl:when test="@ancestor = 'annex' and $level = '2'">13pt</xsl:when>
				<xsl:when test="@ancestor = 'annex' and $level &gt;= '3'">11.5pt</xsl:when>
				<xsl:when test="@ancestor = 'bibliography' and $level = '1' and preceding-sibling::*[local-name() = 'references']">11.5pt</xsl:when>
				<xsl:when test="@ancestor = 'bibliography' and $level = '1'">13pt</xsl:when>
				<xsl:when test="@ancestor = 'bibliography' and $level &gt;= '2'">10pt</xsl:when> -->
				<xsl:otherwise>10pt</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="font-weight">normal</xsl:variable>
		
		<xsl:variable name="text-align">
			<xsl:choose>
				<xsl:when test="@ancestor = 'foreword' and $level = 1">center</xsl:when>
				<xsl:when test="@ancestor = 'annex' and $level = 1">center</xsl:when>
				<xsl:otherwise>left</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		
		<xsl:variable name="margin-top">
			<xsl:choose>
				<xsl:when test="@ancestor = 'foreword' and $level = 1">9mm</xsl:when>
				<xsl:when test="@ancestor = 'annex' and $level = '1' and preceding-sibling::*[local-name() = 'annex'][1][@commentary = 'true']">1mm</xsl:when>
				<xsl:when test="$level = 1">6.5mm</xsl:when>
				<xsl:when test="@ancestor = 'foreword' and $level = 2">0mm</xsl:when>
				<xsl:when test="@ancestor = 'annex' and $level = 2">4.5mm</xsl:when>
				<xsl:when test="@ancestor = 'bibliography' and $level = 2">0mm</xsl:when>
				<xsl:when test="$level = 2">2mm</xsl:when>
				<xsl:when test="$level &gt;= 3">2mm</xsl:when>
				<xsl:otherwise>0mm</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="element-name">
			<xsl:choose>
				<xsl:when test="@inline-header = 'true'">fo:inline</xsl:when>
				<xsl:otherwise>fo:block</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="margin-bottom">
			<xsl:choose>
				<xsl:when test="@ancestor = 'foreword' and $level = 1">9mm</xsl:when>
				<xsl:when test="@ancestor = 'annex' and $level = '1' and preceding-sibling::*[local-name() = 'annex'][1][@commentary = 'true']">7mm</xsl:when>
				<xsl:when test="$level = 1 and following-sibling::jis:clause">8pt</xsl:when>
				<xsl:when test="$level = 1">12pt</xsl:when>
				<xsl:when test="$level = 2 and following-sibling::jis:clause">8pt</xsl:when>
				<xsl:when test="$level &gt;= 2">12pt</xsl:when>
				<xsl:when test="@type = 'section-title'">6mm</xsl:when>
				<xsl:when test="@inline-header = 'true'">0pt</xsl:when>
				<xsl:when test="@ancestor = 'annex' and $level = 1">6mm</xsl:when>
				<xsl:otherwise>0mm</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
	

		<!-- to space-before Foreword -->
		<xsl:if test="@ancestor = 'foreword' and $level = '1'"><fo:block></fo:block></xsl:if>
	

		<xsl:choose>
			<xsl:when test="@inline-header = 'true' and following-sibling::*[1][self::jis:p]">
				<fo:block role="H{$level}">
					<xsl:for-each select="following-sibling::*[1][self::jis:p]">
						<xsl:call-template name="paragraph">
							<xsl:with-param name="inline-header">true</xsl:with-param>
						</xsl:call-template>
					</xsl:for-each>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="{$element-name}">
					<xsl:attribute name="font-family"><xsl:value-of select="$font-family"/></xsl:attribute>
					<xsl:attribute name="font-size"><xsl:value-of select="$font-size"/></xsl:attribute>
					<xsl:attribute name="font-weight"><xsl:value-of select="$font-weight"/></xsl:attribute>
					<xsl:attribute name="text-align"><xsl:value-of select="$text-align"/></xsl:attribute>
					<xsl:attribute name="space-before"><xsl:value-of select="$margin-top"/></xsl:attribute>
					<xsl:attribute name="margin-bottom"><xsl:value-of select="$margin-bottom"/></xsl:attribute>
					<xsl:attribute name="keep-with-next">always</xsl:attribute>
					<xsl:attribute name="role">H<xsl:value-of select="$level"/></xsl:attribute>
					
					<xsl:if test="@type = 'floating-title' or @type = 'section-title'">
						<xsl:copy-of select="@id"/>
					</xsl:if>
					
					<!-- if first and last childs are `add` ace-tag, then move start ace-tag before title -->
					<xsl:if test="*[local-name() = 'tab'][1]/following-sibling::node()[last()][local-name() = 'add'][starts-with(text(), $ace_tag)]">
						<xsl:apply-templates select="*[local-name() = 'tab'][1]/following-sibling::node()[1][local-name() = 'add'][starts-with(text(), $ace_tag)]">
							<xsl:with-param name="skip">false</xsl:with-param>
						</xsl:apply-templates> 
					</xsl:if>
					
					<xsl:variable name="section">
						<xsl:call-template name="extractSection"/>
					</xsl:variable>
					<xsl:if test="normalize-space($section) != ''">
					
						<xsl:choose>
							<xsl:when test="$vertical_layout_rotate_clause_numbers = 'true'">
								<fo:inline font-family="Times New Roman" font-weight="bold">
									<xsl:call-template name="insertVerticalChar">
										<xsl:with-param name="str" select="$section"/>
									</xsl:call-template>
								</fo:inline>
								<fo:inline padding-right="4mm">&#xa0;</fo:inline>
							</xsl:when>
							<xsl:otherwise>
								<fo:inline font-family="Times New Roman" font-weight="bold">
									<xsl:value-of select="$section"/>
									<fo:inline padding-right="4mm">&#xa0;</fo:inline>
								</fo:inline>
							</xsl:otherwise>
						</xsl:choose>
						
					</xsl:if>
					
					<xsl:call-template name="extractTitle"/>
					
					<xsl:apply-templates select="following-sibling::*[1][local-name() = 'variant-title'][@type = 'sub']" mode="subtitle"/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*[local-name() = 'introduction']">
		<fo:block id="{@id}">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'annex']" priority="2">
		<fo:block id="{@id}">
		</fo:block>
		<xsl:apply-templates />
	</xsl:template>
	
	
	<xsl:variable name="text_indent">3</xsl:variable>
	
	<xsl:template match="jis:p" name="paragraph">
		<xsl:param name="inline-header">false</xsl:param>
		<xsl:param name="split_keep-within-line"/>
		
		<xsl:choose>
		
			<xsl:when test="preceding-sibling::*[1][self::jis:title]/@inline-header = 'true' and $inline-header = 'false'"/> <!-- paragraph displayed in title template -->
			
			<xsl:otherwise>
			
				<xsl:variable name="previous-element" select="local-name(preceding-sibling::*[1])"/>
				<xsl:variable name="element-name">fo:block</xsl:variable>
				
				<xsl:element name="{$element-name}">
					<xsl:call-template name="setBlockAttributes">
						<xsl:with-param name="text_align_default">justify</xsl:with-param>
					</xsl:call-template>
					<xsl:attribute name="margin-bottom">10pt</xsl:attribute>
					
					<xsl:if test="not(parent::jis:note or parent::jis:li or ancestor::jis:table)">
						<xsl:attribute name="text-indent"><xsl:value-of select="$text_indent"/>mm</xsl:attribute>
					</xsl:if>
					
					<xsl:copy-of select="@id"/>
					
					<xsl:attribute name="line-height">1.5</xsl:attribute>
					<!-- bookmarks only in paragraph -->
				
					<xsl:if test="count(jis:bookmark) != 0 and count(*) = count(jis:bookmark) and normalize-space() = ''">
						<xsl:attribute name="font-size">0</xsl:attribute>
						<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
						<xsl:attribute name="line-height">0</xsl:attribute>
					</xsl:if>

					<xsl:if test="ancestor::*[@key = 'true']">
						<xsl:attribute name="margin-bottom">2pt</xsl:attribute>
					</xsl:if>
					
					<xsl:if test="parent::jis:definition">
						<xsl:attribute name="margin-bottom">2pt</xsl:attribute>
					</xsl:if>
					
					<xsl:if test="parent::jis:li or following-sibling::*[1][self::jis:ol or self::jis:ul or self::jis:note or self::jis:example] or parent::jis:quote">
						<xsl:attribute name="margin-bottom">4pt</xsl:attribute>
					</xsl:if>
					
					<xsl:if test="parent::jis:td or parent::jis:th or parent::jis:dd">
						<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
					</xsl:if>
					
					<xsl:if test="parent::jis:clause[@type = 'inner-cover-note'] or ancestor::jis:boilerplate">
						<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
					</xsl:if>
					
					
					<xsl:apply-templates>
						<xsl:with-param name="split_keep-within-line" select="$split_keep-within-line"/>
					</xsl:apply-templates>
				</xsl:element>
				<xsl:if test="$element-name = 'fo:inline' and not(local-name(..) = 'admonition')"> <!-- and not($inline = 'true')  -->
					<fo:block margin-bottom="12pt">
						 <xsl:if test="ancestor::jis:annex or following-sibling::jis:table">
							<xsl:attribute name="margin-bottom">0</xsl:attribute>
						 </xsl:if>
						<xsl:value-of select="$linebreak"/>
					</fo:block>
				</xsl:if>
		
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<xsl:template match="jis:termnote" priority="2">
		<fo:block id="{@id}" xsl:use-attribute-sets="termnote-style">
			<fo:list-block provisional-distance-between-starts="{14 + $text_indent}mm">
				<fo:list-item>
					<fo:list-item-label start-indent="{$text_indent}mm" end-indent="label-end()">
						<fo:block xsl:use-attribute-sets="note-name-style">
							<xsl:apply-templates select="*[local-name() = 'name']" />
						</fo:block>
					</fo:list-item-label>
					<fo:list-item-body start-indent="body-start()">
						<fo:block>
							<xsl:apply-templates select="node()[not(local-name() = 'name')]" />
						</fo:block>
					</fo:list-item-body>
				</fo:list-item>
			</fo:list-block>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="*[local-name()='li']" priority="2">
		<fo:list-item xsl:use-attribute-sets="list-item-style">
			<xsl:copy-of select="@id"/>
			
			<xsl:call-template name="refine_list-item-style"/>
			
			<fo:list-item-label end-indent="label-end()">
				<fo:block xsl:use-attribute-sets="list-item-label-style">
				
					<xsl:call-template name="refine_list-item-label-style"/>
					
					<!-- if 'p' contains all text in 'add' first and last elements in first p are 'add' -->
					<xsl:if test="*[1][count(node()[normalize-space() != '']) = 1 and *[local-name() = 'add']]">
						<xsl:call-template name="append_add-style"/>
					</xsl:if>
					
					<xsl:variable name="list_item_label">
						<xsl:call-template name="getListItemFormat" />
					</xsl:variable>
					
					<xsl:choose>
						<xsl:when test="contains($list_item_label, ')')">
							<xsl:value-of select="substring-before($list_item_label,')')"/>
							<fo:inline font-weight="normal">)</fo:inline>
							<xsl:value-of select="substring-after($list_item_label,')')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$list_item_label"/>
						</xsl:otherwise>
					</xsl:choose>
					
				</fo:block>
			</fo:list-item-label>
			<fo:list-item-body start-indent="body-start()" xsl:use-attribute-sets="list-item-body-style">
				<fo:block>
				
					<xsl:call-template name="refine_list-item-body-style"/>
								
					<xsl:apply-templates mode="list_jis"/>
				
					<!-- <xsl:apply-templates select="node()[not(local-name() = 'note')]" />
					
					<xsl:for-each select="./bsi:note">
						<xsl:call-template name="note"/>
					</xsl:for-each> -->
				</fo:block>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>
	
	<xsl:template match="node()" priority="2" mode="list_jis">
		<xsl:apply-templates select="."/>
	</xsl:template>
	
	<!-- display footnote after last element in li, except ol or ul -->
	<xsl:template match="*[local-name()='li']/*[not(local-name() = 'ul') and not(local-name() = 'ol')][last()]" priority="3" mode="list_jis">
		<xsl:apply-templates select="."/>
		
		<xsl:variable name="list_id" select="ancestor::*[local-name() = 'ul' or local-name() = 'ol'][1]/@id"/>
		<!-- render footnotes after current list-item, if there aren't footnotes anymore in the list -->
		<!-- i.e. i.e. if list-item is latest with footnote -->
		<xsl:if test="ancestor::*[local-name() = 'li'][1]//jis:fn[ancestor::*[local-name() = 'ul' or local-name() = 'ol'][1][@id = $list_id]] and
		not(ancestor::*[local-name() = 'li'][1]/following-sibling::*[local-name() = 'li'][.//jis:fn[ancestor::*[local-name() = 'ul' or local-name() = 'ol'][1][@id = $list_id]]])">
			<xsl:apply-templates select="ancestor::*[local-name() = 'ul' or local-name() = 'ol'][1]//jis:fn[ancestor::*[local-name() = 'ul' or local-name() = 'ol'][1][@id = $list_id]][generate-id(.)=generate-id(key('kfn',@reference)[1])]" mode="fn_after_element">
				<xsl:with-param name="ancestor">li</xsl:with-param>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="jis:fn" mode="fn_after_element">
		<xsl:param name="ancestor">li</xsl:param>
		
		<xsl:variable name="ancestor_tree_">
			<xsl:for-each select="ancestor::*[local-name() != 'p' and local-name() != 'bibitem' and local-name() != 'biblio-tag']">
				<item><xsl:value-of select="local-name()"/></item>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="ancestor_tree" select="xalan:nodeset($ancestor_tree_)"/>
		<!-- <debug><xsl:copy-of select="$ancestor_tree"/></debug>
		<debug><ancestor><xsl:value-of select="$ancestor"/></ancestor></debug> -->
		
		<xsl:if test="$ancestor_tree//item[last()][. = $ancestor]">
			<xsl:call-template name="fn_jis"/>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="fn_jis">
		<fo:block-container margin-left="11mm" margin-bottom="4pt" id="{@ref_id}">
			<xsl:if test="position() = last()">
				<xsl:attribute name="margin-bottom">10pt</xsl:attribute>
			</xsl:if>
			<fo:block-container margin-left="0mm">
				<fo:list-block provisional-distance-between-starts="10mm">
					<fo:list-item>
						<fo:list-item-label end-indent="label-end()">
							<fo:block xsl:use-attribute-sets="note-name-style">注 <fo:inline xsl:use-attribute-sets="fn-num-style"><xsl:value-of select="@current_fn_number"/><fo:inline font-weight="normal">)</fo:inline></fo:inline></fo:block>
						</fo:list-item-label>
						<fo:list-item-body start-indent="body-start()">
							<fo:block>
								<xsl:apply-templates />
							</fo:block>
						</fo:list-item-body>
					</fo:list-item>
				</fo:list-block>
			</fo:block-container>
		</fo:block-container>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'span'][@class = 'surname' or @class = 'givenname' or @class = 'JIS' or @class = 'EffectiveYear' or @class = 'CommentaryEffectiveYear']" mode="update_xml_step1" priority="2">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()" mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="jis:clause[@type = 'contributors']//jis:table//jis:span[@class = 'surname']/text()[string-length() &lt; 3]" priority="2">
		<xsl:choose>
			<xsl:when test="string-length() = 1">
				<xsl:value-of select="concat(.,'&#x3000;&#x3000;')"/>
			</xsl:when>
			<xsl:when test="string-length() = 2">
				<xsl:value-of select="concat(substring(.,1,1), '&#x3000;', substring(., 2))"/>
			</xsl:when>
		</xsl:choose>
		<xsl:if test="../following-sibling::node()[1][self::jis:span and @class = 'surname']"> <!-- if no space between surname and given name -->
			<xsl:text>&#x3000;</xsl:text>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="jis:clause[@type = 'contributors']//jis:table//jis:span[@class = 'givenname']/text()[string-length() &lt; 3]" priority="2">
		<xsl:choose>
			<xsl:when test="string-length() = 1">
				<xsl:value-of select="concat('&#x3000;&#x3000;', .)"/>
			</xsl:when>
			<xsl:when test="string-length() = 2">
				<xsl:value-of select="concat(substring(.,1,1), '&#x3000;', substring(., 2))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- space between surname and givenname replace by 'ideographic space' -->
	<!-- and following-sibling::node()[1][self::jis:span and @class = 'givenname'] -->
	<xsl:template match="jis:clause[@type = 'contributors']//jis:table//node()[preceding-sibling::node()[1][self::jis:span and @class = 'surname']][. = ' ']" priority="2">
		<xsl:text>&#x3000;</xsl:text>
	</xsl:template>
	
	<xsl:template name="makePagedXML">
		<xsl:param name="structured_xml"/>
		<xsl:choose>
			<xsl:when test="not(xalan:nodeset($structured_xml)/*[local-name()='pagebreak'])">
				<xsl:element name="page" namespace="https://www.metanorma.org/ns/jis">
					<xsl:copy-of select="xalan:nodeset($structured_xml)"/>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="xalan:nodeset($structured_xml)/*[local-name()='pagebreak']">
			
					<xsl:variable name="pagebreak_id" select="generate-id()"/>
					
					<!-- copy elements before pagebreak -->
					<xsl:element name="page" namespace="https://www.metanorma.org/ns/jis">
						<xsl:if test="not(preceding-sibling::jis:pagebreak)">
							<xsl:copy-of select="../@*" />
						</xsl:if>
						<!-- copy previous pagebreak orientation -->
						<xsl:copy-of select="preceding-sibling::jis:pagebreak[1]/@orientation"/>
					
						<xsl:copy-of select="preceding-sibling::node()[following-sibling::jis:pagebreak[1][generate-id(.) = $pagebreak_id]][not(local-name() = 'pagebreak')]" />
					</xsl:element>
					
					<!-- copy elements after last page break -->
					<xsl:if test="position() = last() and following-sibling::node()">
						<xsl:element name="page" namespace="https://www.metanorma.org/ns/jis">
							<xsl:copy-of select="@orientation" />
							<xsl:copy-of select="following-sibling::node()" />
						</xsl:element>
					</xsl:if>
	
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ========================= -->
	<!-- Allocate non-Japanese text -->
	<!-- ========================= -->
	
	<xsl:variable name="regex_en">([^\u00A0\u2002-\u200B\u3000-\u9FFF\uF900-\uFFFF]{1,})</xsl:variable>
	
	<xsl:variable name="element_name_font_en">font_en</xsl:variable>
	<xsl:variable name="tag_font_en_open">###<xsl:value-of select="$element_name_font_en"/>###</xsl:variable>
	<xsl:variable name="tag_font_en_close">###/<xsl:value-of select="$element_name_font_en"/>###</xsl:variable>
	<xsl:variable name="element_name_font_en_bold">font_en_bold</xsl:variable>
	<xsl:variable name="tag_font_en_bold_open">###<xsl:value-of select="$element_name_font_en_bold"/>###</xsl:variable>
	<xsl:variable name="tag_font_en_bold_close">###/<xsl:value-of select="$element_name_font_en_bold"/>###</xsl:variable>
	
	<xsl:template match="jis:p//text()[not(ancestor::jis:strong)] |
						jis:dt/text()" mode="update_xml_step1">
		<xsl:variable name="text_en_" select="java:replaceAll(java:java.lang.String.new(.), $regex_en, concat($tag_font_en_open,'$1',$tag_font_en_close))"/>
		<xsl:variable name="text_en">
			<xsl:element name="text" namespace="{$namespace_full}">
				<xsl:call-template name="replace_text_tags">
					<xsl:with-param name="tag_open" select="$tag_font_en_open"/>
					<xsl:with-param name="tag_close" select="$tag_font_en_close"/>
					<xsl:with-param name="text" select="$text_en_"/>
				</xsl:call-template>
			</xsl:element>
		</xsl:variable>
		<xsl:copy-of select="xalan:nodeset($text_en)/*[local-name() = 'text']/node()"/>
	</xsl:template>
	
	<!-- jis:term/jis:preferred2//text() | -->
	
	<!-- <name>注記  1</name> to <name>注記<font_en>  1</font_en></name> -->
	<xsl:template match="jis:title/text() | 
						jis:note/jis:name/text() | 
						jis:termnote/jis:name/text() |
						jis:table/jis:name/text() |
						jis:figure/jis:name/text() |
						jis:termexample/jis:name/text() |
						jis:xref//text() |
						jis:origin/text()" mode="update_xml_step1">
		<xsl:variable name="text_en_" select="java:replaceAll(java:java.lang.String.new(.), $regex_en, concat($tag_font_en_bold_open,'$1',$tag_font_en_bold_close))"/>
		<xsl:variable name="text_en">
			<xsl:element name="text" namespace="{$namespace_full}">
				<xsl:call-template name="replace_text_tags">
					<xsl:with-param name="tag_open" select="$tag_font_en_bold_open"/>
					<xsl:with-param name="tag_close" select="$tag_font_en_bold_close"/>
					<xsl:with-param name="text" select="$text_en_"/>
				</xsl:call-template>
			</xsl:element>
		</xsl:variable>
		<xsl:copy-of select="xalan:nodeset($text_en)/*[local-name() = 'text']/node()"/>
	</xsl:template>
	
	<!-- for $contents -->
	<xsl:template match="title/text()">
		<xsl:variable name="regex_en_contents">([^\u00A0\u2002-\u200B\u3000-\u9FFF\uF900-\uFFFF\(\)]{1,})</xsl:variable>
		<xsl:variable name="text_en_" select="java:replaceAll(java:java.lang.String.new(.), $regex_en_contents, concat($tag_font_en_bold_open,'$1',$tag_font_en_bold_close))"/>
		<xsl:variable name="text_en">
			<xsl:element name="text" namespace="{$namespace_full}">
				<xsl:call-template name="replace_text_tags">
					<xsl:with-param name="tag_open" select="$tag_font_en_bold_open"/>
					<xsl:with-param name="tag_close" select="$tag_font_en_bold_close"/>
					<xsl:with-param name="text" select="$text_en_"/>
				</xsl:call-template>
			</xsl:element>
		</xsl:variable>
		<xsl:apply-templates select="xalan:nodeset($text_en)/*[local-name() = 'text']/node()"/>
	</xsl:template>
	
	<!-- move example title to the first paragraph -->
	<xsl:template match="jis:example[contains(jis:name/text(), ' — ')]" mode="update_xml_step1">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:element name="p" namespace="https://www.metanorma.org/ns/jis">
				<xsl:value-of select="substring-after(jis:name/text()[1], ' — ')"/>
				<xsl:apply-templates select="jis:name/text()[1]/following-sibling::node()" mode="update_xml_step1"/>
			</xsl:element>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="jis:example/jis:name[contains(text(), ' — ')]" mode="update_xml_step1">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="text()[1]" mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="jis:example/jis:name/text()" mode="update_xml_step1">
		<xsl:variable name="example_name">
			<xsl:choose>
				<xsl:when test="contains(., ' — ')"><xsl:value-of select="substring-before(., ' — ')"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="text_en_" select="java:replaceAll(java:java.lang.String.new($example_name), $regex_en, concat($tag_font_en_bold_open,'$1',$tag_font_en_bold_close))"/>
		<xsl:variable name="text_en">
			<xsl:element name="text" namespace="{$namespace_full}">
				<xsl:call-template name="replace_text_tags">
					<xsl:with-param name="tag_open" select="$tag_font_en_bold_open"/>
					<xsl:with-param name="tag_close" select="$tag_font_en_bold_close"/>
					<xsl:with-param name="text" select="$text_en_"/>
				</xsl:call-template>
			</xsl:element>
		</xsl:variable>
		<xsl:copy-of select="xalan:nodeset($text_en)/*[local-name() = 'text']/node()"/>
	</xsl:template>
	
	<xsl:template match="jis:eref//text()" mode="update_xml_step1">
		<!-- Example: JIS Z 8301:2011 to <font_en_bold>JIS Z 8301</font_en_bold><font_en>:2011</font_en> -->
		<xsl:variable name="parts">
			<xsl:choose>
				<xsl:when test="contains(., ':')">
					<xsl:element name="{$element_name_font_en_bold}" namespace="{$namespace_full}"><xsl:value-of select="substring-before(., ':')"/></xsl:element>
					<xsl:element name="{$element_name_font_en}" namespace="{$namespace_full}">:<xsl:value-of select="substring-after(., ':')"/></xsl:element>
				</xsl:when>
				<xsl:otherwise>
					<xsl:element name="{$element_name_font_en_bold}" namespace="{$namespace_full}"><xsl:value-of select="."/></xsl:element>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:for-each select="xalan:nodeset($parts)/*">
			<xsl:variable name="tag_open">###<xsl:value-of select="local-name()"/>###</xsl:variable>
			<xsl:variable name="tag_close">###/<xsl:value-of select="local-name()"/>###</xsl:variable>
			<xsl:variable name="text_en_" select="java:replaceAll(java:java.lang.String.new(.), $regex_en, concat($tag_open,'$1',$tag_close))"/>
			<xsl:variable name="text_en">
				<xsl:element name="text" namespace="{$namespace_full}">
					<xsl:call-template name="replace_text_tags">
						<xsl:with-param name="tag_open" select="$tag_open"/>
						<xsl:with-param name="tag_close" select="$tag_close"/>
						<xsl:with-param name="text" select="$text_en_"/>
					</xsl:call-template>
				</xsl:element>
			</xsl:variable>
			<xsl:copy-of select="xalan:nodeset($text_en)/*[local-name() = 'text']/node()"/>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="jis:strong" priority="2" mode="update_xml_step1">
		<xsl:apply-templates mode="update_xml_step1"/>
	</xsl:template>
	<xsl:template match="jis:strong/text()" priority="2" mode="update_xml_step1">
		<xsl:variable name="text_en_" select="java:replaceAll(java:java.lang.String.new(.), $regex_en, concat($tag_font_en_bold_open,'$1',$tag_font_en_bold_close))"/>
		<xsl:variable name="text_en">
			<xsl:element name="text" namespace="{$namespace_full}">
				<xsl:call-template name="replace_text_tags">
					<xsl:with-param name="tag_open" select="$tag_font_en_bold_open"/>
					<xsl:with-param name="tag_close" select="$tag_font_en_bold_close"/>
					<xsl:with-param name="text" select="$text_en_"/>
				</xsl:call-template>
			</xsl:element>
		</xsl:variable>
		<xsl:copy-of select="xalan:nodeset($text_en)/*[local-name() = 'text']/node()"/>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'font_en_bold'][normalize-space() != '']">
		<xsl:if test="ancestor::*[local-name() = 'td' or local-name() = 'th']"><xsl:value-of select="$zero_width_space"/></xsl:if>
		<fo:inline font-family="Times New Roman" font-weight="bold">
			<xsl:if test="ancestor::*[local-name() = 'preferred']">
				<xsl:attribute name="font-weight">normal</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</fo:inline>
		<xsl:if test="ancestor::*[local-name() = 'td' or local-name() = 'th']"><xsl:value-of select="$zero_width_space"/></xsl:if>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'font_en'][normalize-space() != '']">
		<xsl:if test="ancestor::*[local-name() = 'td' or local-name() = 'th']"><xsl:value-of select="$zero_width_space"/></xsl:if>
		<fo:inline>
			<xsl:if test="not(ancestor::jis:p[@class = 'zzSTDTitle2']) and not(ancestor::jis:span[@class = 'JIS'])">
				<xsl:attribute name="font-family">Times New Roman</xsl:attribute>
			</xsl:if>
			<xsl:if test="ancestor::*[local-name() = 'preferred']">
				<xsl:attribute name="font-weight">normal</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</fo:inline>
		<xsl:if test="ancestor::*[local-name() = 'td' or local-name() = 'th']"><xsl:value-of select="$zero_width_space"/></xsl:if>
	</xsl:template>
	
	<!-- ========================= -->
	<!-- END: Allocate non-Japanese text -->
	<!-- ========================= -->
	
	<xsl:template name="insertHeaderFooter">
		<xsl:param name="docidentifier" />
		<xsl:param name="hidePageNumber">false</xsl:param>
		<xsl:param name="section"/>
		<xsl:param name="copyrightText"/>
		<xsl:param name="section_title"/>
		<fo:static-content flow-name="header-odd-first" role="artifact">
			<fo:block-container font-family="Arial" font-size="9pt" height="26mm" display-align="after" text-align="right">
				<xsl:if test="$vertical_layout = 'true'">
					<xsl:attribute name="display-align">center</xsl:attribute>
				</xsl:if>
				<xsl:if test="$section = 'main'"><fo:block><fo:page-number /></fo:block></xsl:if>
				<fo:block>
					<xsl:copy-of select="$docidentifier"/>
				</fo:block>
			</fo:block-container>
		</fo:static-content>
		<fo:static-content flow-name="header-odd" role="artifact">
			<fo:block-container font-family="Arial" font-size="9pt" height="26mm" display-align="after" text-align="right">
				<xsl:if test="$vertical_layout = 'true'">
					<xsl:attribute name="display-align">center</xsl:attribute>
				</xsl:if>
				<xsl:if test="$section = 'main' or $section = 'commentary'"><fo:block><fo:page-number /></fo:block></xsl:if>
				<fo:block>
					<xsl:copy-of select="$docidentifier"/>
					<xsl:copy-of select="$section_title"/>
				</fo:block>
			</fo:block-container>
		</fo:static-content>
		<fo:static-content flow-name="header-even" role="artifact">
			<fo:block-container font-family="Arial" font-size="9pt" height="26mm" display-align="after">
				<xsl:if test="$vertical_layout = 'true'">
					<xsl:attribute name="display-align">center</xsl:attribute>
				</xsl:if>
				<xsl:if test="$section = 'main' or $section = 'commentary'"><fo:block><fo:page-number /></fo:block></xsl:if>
				<fo:block>
					<xsl:copy-of select="$docidentifier"/>
					<xsl:copy-of select="$section_title"/>
				</fo:block>
			</fo:block-container>
		</fo:static-content>
		
		<fo:static-content flow-name="header-commentary-even-first" role="artifact">
			<fo:block-container font-family="Arial" font-size="9pt" height="26mm" display-align="after" text-align="left">
				<xsl:if test="$vertical_layout = 'true'">
					<xsl:attribute name="display-align">center</xsl:attribute>
				</xsl:if>
				<fo:block><fo:page-number /></fo:block>
				<fo:block>&#xa0;</fo:block>
			</fo:block-container>
		</fo:static-content>
		
		<fo:static-content flow-name="header-commentary-odd-first" role="artifact">
			<fo:block-container font-family="Arial" font-size="9pt" height="26mm" display-align="after" text-align="right">
				<xsl:if test="$vertical_layout = 'true'">
					<xsl:attribute name="display-align">center</xsl:attribute>
				</xsl:if>
				<fo:block><fo:page-number /></fo:block>
				<fo:block>&#xa0;</fo:block>
			</fo:block-container>
		</fo:static-content>		
		
		<xsl:call-template name="insertFooter">
			<xsl:with-param name="section" select="$section"/>
			<xsl:with-param name="copyrightText" select="$copyrightText"/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template name="insertFooter">
		<xsl:param name="section"/>
		<xsl:param name="copyrightText"/>
		<fo:static-content flow-name="footer">
			<fo:block-container height="24mm" display-align="after">
        <xsl:if test="$section = 'commentary'">
          <xsl:attribute name="height">24.5mm</xsl:attribute>
        </xsl:if>
				<xsl:if test="$section = 'preface'">
					<fo:block font-size="9pt" text-align="center" space-after="10pt">(<fo:inline font-family="Times New Roman"><fo:page-number /></fo:inline>)</fo:block>
				</xsl:if>
				<xsl:if test="$section = 'commentary'">
					<fo:block font-size="9pt" text-align="center" space-after="12pt">
						<fo:inline font-family="IPAexGothic" padding-right="3mm">
							<xsl:call-template name="getLocalizedString">
								<xsl:with-param name="key">commentary_page</xsl:with-param>
							</xsl:call-template>
						</fo:inline>
						<fo:inline font-weight="bold" font-family="Times New Roman" id="_independent_page_number_commentary"><fo:page-number /></fo:inline>
					</fo:block>
				</xsl:if>
				<!-- copyright restriction -->
				<fo:block font-size="7pt" text-align="center" font-family="IPAexMincho" margin-bottom="13mm">
					<xsl:if test="$vertical_layout = 'true'">
						<xsl:attribute name="margin-bottom">5mm</xsl:attribute>
					</xsl:if>
					<xsl:value-of select="$copyrightText"/>
				</fo:block>
			</fo:block-container>
		</fo:static-content>
	</xsl:template>
	
	<xsl:template name="insertLeftRightRegions">
		<xsl:param name="cover_header_footer_background"/>
		<xsl:param name="i18n_JIS"/>
		<xsl:param name="docidentifier"/>
		<xsl:param name="title_ja"/>
		<xsl:param name="edition"/>
		<xsl:param name="copyrightText"/>
		
		<!-- header -->
		<fo:static-content flow-name="right-region" role="artifact">
			<fo:block-container font-size="9pt" height="{$pageHeightA5}mm" width="6mm" color="white" background-color="{$cover_header_footer_background}" text-align="center" margin-left="6mm">
				<fo:block-container margin-left="0mm" margin-top="14.5mm" line-height="1.1">
					 <!-- text-align-last="justify" -->
						<!-- example: 日本工業規格 JIS Z 8301 規格票の様式及び作成方法    一 -->
					<xsl:call-template name="insertEachCharInBlock">
						<xsl:with-param name="str" select="$i18n_JIS"/>
					</xsl:call-template>
					<fo:block margin-top="3mm">
						<xsl:call-template name="insertEachCharInBlock">
							<xsl:with-param name="str" select="$docidentifier"/>
							<xsl:with-param name="spaceIndent">1mm</xsl:with-param>
						</xsl:call-template>
					</fo:block>
					<fo:block margin-top="3mm">
						<xsl:call-template name="insertEachCharInBlock">
							<xsl:with-param name="str" select="$title_ja"/>
						</xsl:call-template>
					</fo:block>
					<fo:block margin-top="21mm">
						<xsl:value-of select="$edition"/>
					</fo:block>
				</fo:block-container>
			</fo:block-container>
		</fo:static-content>
		
		<!-- footer -->
		<fo:static-content flow-name="left-region" role="artifact">
			<fo:block-container absolute-position="fixed" left="0mm" top="0" width="6mm" height="{$pageHeightA5}mm" background-color="{$cover_header_footer_background}">
				<fo:block-container font-size="9pt" color="white" text-align="center">
					<fo:block margin-top="131mm">二<fo:page-number /></fo:block>
				</fo:block-container>
			</fo:block-container>
			
			<fo:block-container font-size="9pt" color="white" height="5.5mm" writing-mode="tb-rl" margin-left="56mm" line-height="1.1">
				
				<fo:block text-align-last="justify" margin-top="56mm" margin-bottom="-2mm">
				
					<fo:inline baseline-shift="-20%">
						<fo:inline>
							<fo:retrieve-marker retrieve-class-name="section_title"/>
						</fo:inline><!-- <fo:inline padding-bottom="5mm">三</fo:inline>用語及び定義 -->
					</fo:inline>
					
					<fo:inline keep-together.within-line="always">
						<fo:leader leader-pattern="space"/>
						<fo:inline font-size="6pt" baseline-shift="-10%"><xsl:value-of select="$copyrightText"/></fo:inline>
					</fo:inline >
				
				<!-- <fo:table table-layout="fixed" width="100%">
					<fo:table-column column-width="proportional-column-width(56)"/>
					<fo:table-column column-width="proportional-column-width(70)"/>
					<fo:table-column column-width="proportional-column-width(24)"/>
					<fo:table-column column-width="proportional-column-width(59)"/>
					<fo:table-body>
						<fo:table-row>
							<fo:table-cell><fo:block>&#xa0;</fo:block></fo:table-cell>
							<fo:table-cell><fo:block>三用語及び定義</fo:block></fo:table-cell>
							<fo:table-cell><fo:block text-align="center">二</fo:block></fo:table-cell>
							<fo:table-cell display-align="center"><fo:block font-size="6pt"><xsl:value-of select="$copyrightText"/></fo:block></fo:table-cell>
						</fo:table-row>
					</fo:table-body>
				</fo:table> -->
				</fo:block>
			</fo:block-container>
		</fo:static-content>
		
		<!-- <fo:static-content flow-name="left-region" role="artifact">
			<fo:block-container font-size="9pt" height="{$pageHeightA5}mm" width="6mm" color="white" background-color="{$cover_header_footer_background}" text-align="center">
				<fo:block-container margin-left="0mm" margin-top="55.5mm" line-height="1.1">
					
					<xsl:call-template name="insertEachCharInBlock">
						<xsl:with-param name="str" select="$i18n_JIS"/>
					</xsl:call-template>
					<fo:block margin-top="3mm">
						<xsl:call-template name="insertEachCharInBlock">
							<xsl:with-param name="str" select="$docidentifier"/>
							<xsl:with-param name="spaceIndent">1mm</xsl:with-param>
						</xsl:call-template>
					</fo:block>
					<fo:block margin-top="3mm">
						<xsl:call-template name="insertEachCharInBlock">
							<xsl:with-param name="str" select="$title_ja"/>
						</xsl:call-template>
					</fo:block>
					<fo:block margin-top="21mm">
						<xsl:value-of select="$edition"/>
					</fo:block>
				</fo:block-container>
			</fo:block-container>
		</fo:static-content> -->
	</xsl:template>
	
	<xsl:template name="insertEachCharInBlock">
		<xsl:param name="str"/>
		<xsl:param name="spaceIndent"/>
		<xsl:param name="lineHeight"/>
		<xsl:if test="string-length($str) &gt; 0">
			<xsl:variable name="char" select="substring($str, 1, 1)"/>
			<fo:block>
				<xsl:if test="$lineHeight != ''">
					<xsl:attribute name="line-height"><xsl:value-of select="$lineHeight"/></xsl:attribute>
				</xsl:if>
				<xsl:choose>
					<xsl:when test="$char = ' ' and $spaceIndent != ''">
						<xsl:attribute name="margin-top"><xsl:value-of select="$spaceIndent"/></xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$char"/>
					</xsl:otherwise>
				</xsl:choose>
			</fo:block>
			<xsl:call-template name="insertEachCharInBlock">
				<xsl:with-param name="str" select="substring($str,2)"/>
				<xsl:with-param name="spaceIndent" select="$spaceIndent"/>
				<xsl:with-param name="lineHeight" select="$lineHeight"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<xsl:variable name="JIS-Logo">
		<svg width="80.94133mm" height="47.963669mm" viewBox="0 0 80.94133 47.963669" version="1.1" id="svg781" xmlns="http://www.w3.org/2000/svg" xmlns:svg="http://www.w3.org/2000/svg">
		<defs id="defs778" />
			<g id="layer1" transform="translate(-0.51630433,-0.32770559)">
				<path
					 d="m 35.949294,46.979025 h 11.64167 V 1.4071956 h -11.64167 z"
					 style="display:inline;fill:#231f20;fill-opacity:1;fill-rule:nonzero;stroke:none;stroke-width:0.352778"
					 id="path94" />
				<path
					 d="m 76.419964,22.870205 c 3.175,2.37067 5.03767,6.35 5.03767,10.8585 0,7.6835 -6.096,13.7795 -13.75834,13.7795 -3.175,0 -6.096,-1.05833 -8.21266,-2.64583 l -7.13317,-5.03767 6.87917,-9.017 7.13316,5.03767 c 0.52917,0.254 1.05834,0.52916 1.5875,0.52916 1.5875,0 2.921,-1.05833 2.921,-2.64583 0,-1.05833 -0.52916,-1.86267 -1.3335,-2.39183 l -9.24983,-6.35 c -3.175,-2.667 -5.0165,-6.62517 -5.0165,-10.87967 0,-7.6834994 6.07483,-13.77949941 13.73717,-13.77949941 2.64583,0 5.82083,1.33350001 7.9375,2.92100001 l 2.921,2.39183 -6.87917,8.4666694 -2.64583,-2.11667 c -0.52917,-0.52916 -1.05834,-0.78316 -1.5875,-0.78316 -1.5875,0 -2.921,1.31233 -2.921,2.89983 0,0.80433 0.52916,1.60867 1.3335,2.13783 l 9.24983,6.62517"
					 style="display:inline;fill:#231f20;fill-opacity:1;fill-rule:nonzero;stroke:none;stroke-width:0.352778"
					 id="path244" />
				<path
					 d="m 28.816134,33.728705 c 0,9.271 -7.15433,14.56267 -14.2875,14.56267 -7.1331697,0 -10.5833297,-4.7625 -10.5833297,-4.7625 l -3.42899997,-3.45017 8.19149997,-8.21267 3.1749997,3.45017 0.80433,0.78317 c 0.508,0.52916 1.03717,1.05833 2.0955,1.05833 1.3335,0 2.64583,-1.31233 2.64583,-2.89983 0,0 0,0 0,-0.27517 V 1.4072066 h 11.38767 V 32.670375 c 0,0 0,-8.21267 0,1.05833"
					 style="display:inline;fill:#231f20;fill-opacity:1;fill-rule:nonzero;stroke:none;stroke-width:0.352778"
					 id="path364" />
			</g>
		</svg>
	</xsl:variable>
	
	<xsl:variable name="JIS-Logo_2024">
		<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 34.29 34.29">
			<defs>
				<style>
					.cls-1 {
						fill: #fff;
						stroke-width: 0px;
					}
				</style>
			</defs>
			<path class="cls-1" d="m6.72,27.57c5.76,5.76,15.09,5.76,20.85,0,5.76-5.76,5.76-15.09,0-20.85C21.81.96,12.48.96,6.72,6.72c-3.28,3.28-4.82,7.91-4.17,12.5.26,1.84,1.97,3.13,3.81,2.86,1.66-.24,2.9-1.66,2.9-3.34v-9.32h3.09v9.32c0,3.38-2.74,6.11-6.11,6.11-3.03,0-5.61-2.22-6.05-5.23C-1.19,10.27,5.29,1.56,14.66.18c9.37-1.38,18.08,5.11,19.45,14.47,1.38,9.37-5.1,18.08-14.47,19.45-5.36.79-10.78-1.01-14.61-4.84m13.84-19.84v15.43h-3.43v-15.43m11.78,7.71c1.8,1.68,1.9,4.5.23,6.3-.84.91-2.03,1.42-3.26,1.42h-2.74v-2.74h2.23c1.04,0,1.89-.84,1.89-1.89,0-.52-.22-1.02-.6-1.38l-2.15-1.99c-1.73-1.61-1.83-4.32-.22-6.06.81-.87,1.95-1.37,3.14-1.37h2.06v2.74h-1.54c-.95,0-1.71.77-1.71,1.71,0,.48.2.93.55,1.26"/>
		</svg>
	</xsl:variable>
	
	<xsl:variable name="JSA-Logo_2024">
		<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 43.34 25.77">
			<defs>
				<style>
					.cls-1 {
						fill: #fff;
						stroke-width: 0px;
					}
				</style>
			</defs>
			<path class="cls-1" d="m2.01,24.08c-1.58-3.99,5.49-12.06,15.79-17.97C28.09.2,37.75-1.37,39.32,2.62c.67,1.72-.24,4.18-2.34,6.89,2.31-2.77,3.38-5.32,2.72-7.12-1.52-4.17-11.45-2.58-22.51,2.95-1.2.6-2.01,1.19-2.98,1.78-.62.37-1.29.7-1.88,1.09C4.14,13.57-1.09,19.87.19,23.39c.44,1.21,1.6,1.95,3.28,2.26-.67-.32-1.19-.88-1.47-1.56"/>
			<polygon class="cls-1" points="32.72 6.03 32.72 23.58 43.34 23.58 32.72 6.03"/>
			<path class="cls-1" d="m20.81,7.75c-2.34,2.17-2.48,5.83-.31,8.17.05.06.1.11.16.17l8.93-8.49c-2.54-2.2-6.33-2.14-8.78.15"/>
			<path class="cls-1" d="m18.94,21.67c.06.06.1.11.15.16,2.47,2.29,6.28,2.29,8.75,0,2.3-2.13,2.44-5.71.31-8.01-.1-.11-.2-.21-.31-.31-.05-.05-.11-.09-.16-.14l-8.74,8.31Z"/>
			<path class="cls-1" d="m7.09,25.77l-.32-1.1c3.44-.29,5.37-1.72,5.37-7.99v-8.32l3.81-2.3v10.62c0,6.8-5.17,9.09-8.85,9.09"/>
			<path class="cls-1" d="m15.98,1.92c0,1.06-.86,1.92-1.92,1.92-1.06,0-1.92-.86-1.92-1.92C12.15.86,13,0,14.06,0c1.06,0,1.92.85,1.92,1.9v.02"/>
		</svg>
	</xsl:variable>
	
</xsl:stylesheet>
