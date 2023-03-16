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
											exclude-result-prefixes="java"
											version="1.0">

	<xsl:output method="xml" encoding="UTF-8" indent="no"/>
		
	<xsl:include href="./common.xsl"/>

	<xsl:key name="kfn" match="*[local-name() = 'fn'][not(ancestor::*[(local-name() = 'table' or local-name() = 'figure' or local-name() = 'localized-strings')] and not(ancestor::*[local-name() = 'name']))]" use="@reference"/>
	
	<xsl:variable name="namespace">jis</xsl:variable>
	
	<xsl:variable name="namespace_full">https://www.metanorma.org/ns/jis</xsl:variable>
	
	<xsl:variable name="debug">false</xsl:variable>
	
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
						<xsl:call-template name="processPrefaceSectionsDefault_Contents"/>
						
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

	<xsl:template match="/">
	
		<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format" xml:lang="{$lang}">
			<xsl:variable name="root-style">
				<root-style xsl:use-attribute-sets="root-style">
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
			
				<fo:simple-page-master master-name="odd" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
					<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
					<fo:region-before region-name="header-odd" extent="{$marginTop}mm"/>
					<fo:region-after region-name="footer" extent="{$marginBottom}mm"/>
					<fo:region-start region-name="left-region" extent="{$marginLeftRight1}mm"/>
					<fo:region-end region-name="right-region" extent="{$marginLeftRight2}mm"/>
				</fo:simple-page-master>
				<fo:simple-page-master master-name="even" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
					<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
					<fo:region-before region-name="header-even" extent="{$marginTop}mm"/>
					<fo:region-after region-name="footer" extent="{$marginBottom}mm"/>
					<fo:region-start region-name="left-region" extent="{$marginLeftRight1}mm"/>
					<fo:region-end region-name="right-region" extent="{$marginLeftRight2}mm"/>
				</fo:simple-page-master>
				<fo:page-sequence-master master-name="document">
					<fo:repeatable-page-master-alternatives>
						<fo:conditional-page-master-reference odd-or-even="even" master-reference="even"/>
						<fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd"/>
					</fo:repeatable-page-master-alternatives>
				</fo:page-sequence-master>
			
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
				
					<xsl:variable name="docidentifier">
						<fo:inline font-family="Arial"><xsl:value-of select="/*/jis:bibdata/jis:docidentifier[@type = 'JIS']"/></fo:inline>
						<fo:inline font-family="IPAexGothic">：</fo:inline>
						<fo:inline font-family="Arial"><xsl:value-of select="substring(/*/jis:bibdata/jis:version/jis:revision-date, 1, 4)"/></fo:inline>
					</xsl:variable>
				
					<xsl:call-template name="insertCoverPage">
						<xsl:with-param name="num" select="$num"/>
					</xsl:call-template>
										
				
					<xsl:call-template name="insertInnerCoverPage">
						<xsl:with-param name="docidentifier" select="$docidentifier"/>
					</xsl:call-template>
				
				</xsl:for-each>
			
			</xsl:for-each>
			
		</fo:root>
	</xsl:template>
	
	<xsl:template name="insertCoverPage">
		<xsl:param name="num"/>
		<fo:page-sequence master-reference="cover-page" force-page-count="no-force">
			<xsl:call-template name="insertFooter"/>
				
			<fo:flow flow-name="xsl-region-body">
				<!-- JIS -->
				<fo:block id="firstpage_id_{$num}">
					<fo:instream-foreign-object content-width="81mm" fox:alt-text="JIS Logo">
						<xsl:copy-of select="$JIS-Logo"/>
					</fo:instream-foreign-object>
				</fo:block>
				
				<fo:block-container text-align="center">
					<!-- title -->
					<fo:block role="H1" font-family="IPAexGothic" font-size="22pt" margin-top="27mm">規格票の様式及び作成方法</fo:block>
					<!-- docidentifier, 3 part: number, colon and year-->
					<fo:block font-family="IPAexGothic" font-size="20pt" margin-top="15mm">JIS Z 8301<fo:inline baseline-shift="20%"><fo:inline font-size="10pt">：</fo:inline><fo:inline font-family="IPAexMincho" font-size="10pt">2019</fo:inline></fo:inline></fo:block>
					<fo:block font-family="IPAexGothic" font-size="14pt" margin-top="12mm"><fo:inline font-family="IPAexMincho">（</fo:inline>JSA<fo:inline font-family="IPAexMincho">）</fo:inline></fo:block>
				</fo:block-container>
				
				<fo:block-container absolute-position="fixed" left="0mm" top="200mm" height="69mm" text-align="center" display-align="after" font-family="IPAexMincho">
					<!-- Revised on July 22, 2019 -->
					<fo:block font-size="9pt">令和元年<fo:inline font-family="Times New Roman"> 7 </fo:inline>月<fo:inline font-family="Times New Roman"> 22 </fo:inline>日 改正</fo:block>
					<!-- Japan Industrial Standards Survey Council deliberations -->
					<fo:block font-size="14pt" margin-top="7mm">日本産業標準調査会 審議</fo:block>
					<!-- (Issued by the Japan Standards Association) -->
					<fo:block font-size="9pt" margin-top="6.5mm">（日本規格協会 発行）</fo:block>
				</fo:block-container>
			</fo:flow>
		</fo:page-sequence>
	</xsl:template> <!-- insertCoverPage -->
	
	<xsl:template name="insertInnerCoverPage">
		<xsl:param name="docidentifier"/>
		<fo:page-sequence master-reference="document" force-page-count="no-force">
			<xsl:call-template name="insertHeaderFooter">
				<xsl:with-param name="docidentifier" select="$docidentifier"/>
			</xsl:call-template>
				
			<fo:flow flow-name="xsl-region-body">
				<fo:block-container font-size="9pt" margin-top="5mm">
					<fo:block text-align="center">日本産業標準調査会標準第一部会 構成表</fo:block>
					
					
					
				</fo:block-container>
			</fo:flow>
		</fo:page-sequence>
	</xsl:template> <!-- insertInnerCoverPage -->
	
	
	<xsl:template match="jis:title" priority="2" name="title">
	
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		
		<xsl:variable name="font-size">
			<xsl:choose>
				<xsl:when test="@type = 'section-title'">18pt</xsl:when>
				<xsl:when test="@ancestor = 'foreword' and $level = '1'">18pt</xsl:when>
				<xsl:when test="@ancestor = 'foreword' and $level &gt;= '2'">11pt</xsl:when>
				<xsl:when test=". = 'Executive summary'">18pt</xsl:when>
				<!-- <xsl:when test="@ancestor = 'introduction' and $level = '1'">11.5pt</xsl:when> -->
				<xsl:when test="@ancestor = 'introduction' and $level = '1'">18pt</xsl:when>
				<xsl:when test="@ancestor = 'introduction' and $level &gt;= '2'">11pt</xsl:when>
				<xsl:when test="@ancestor = 'sections' and $level = '1'">14pt</xsl:when>
				<xsl:when test="@ancestor = 'sections' and $level = '2'">11pt</xsl:when>
				<xsl:when test="@ancestor = 'sections' and $level &gt;= '3'">10pt</xsl:when>
				<xsl:when test="@ancestor = 'sections' and $level = '2' and preceding-sibling::*[1][local-name() = 'references']">inherit</xsl:when> <!-- Normative references -->
				<xsl:when test="@ancestor = 'sections' and $level = '2'">11pt</xsl:when>
				<xsl:when test="@ancestor = 'sections' and $level &gt;= '3' and preceding-sibling::*[1][local-name() = 'terms']">11pt</xsl:when>
				<xsl:when test="@ancestor = 'sections' and $level = '3'">10.5pt</xsl:when>
				<xsl:when test="@ancestor = 'sections' and $level &gt;= '4'">10pt</xsl:when>
				<xsl:when test="@ancestor = 'annex' and $level = '1'">18pt</xsl:when>
				<xsl:when test="@ancestor = 'annex' and $level = '2'">13pt</xsl:when>
				<xsl:when test="@ancestor = 'annex' and $level &gt;= '3'">11.5pt</xsl:when>
				<xsl:when test="@ancestor = 'bibliography' and $level = '1' and preceding-sibling::*[local-name() = 'references']">11.5pt</xsl:when>
				<xsl:when test="@ancestor = 'bibliography' and $level = '1'">13pt</xsl:when>
				<xsl:when test="@ancestor = 'bibliography' and $level &gt;= '2'">10pt</xsl:when>
				<xsl:otherwise>11.5pt</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="font-weight">bold</xsl:variable>
			
		<xsl:variable name="margin-top">
			<xsl:choose>
				<xsl:when test="$level = 1">4.5mm</xsl:when>
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
				<!-- <xsl:when test="$level = 1 and following-sibling::*[1][self::jis:clause]">4mm</xsl:when> -->
				<xsl:when test="@type = 'section-title'">6mm</xsl:when>
				<xsl:when test="@inline-header = 'true'">0pt</xsl:when>
				<xsl:when test="@ancestor = 'foreword' and $level = 1">5.5mm</xsl:when>
				<xsl:when test=". = 'Executive summary'">5.5mm</xsl:when>
				<xsl:when test="@ancestor = 'introduction' and $level = 1">5.5mm</xsl:when>
				<xsl:when test="@ancestor = 'annex' and $level = 1">6mm</xsl:when>
				<xsl:when test="$level = 1">2mm</xsl:when>
				<xsl:when test="$level = 2">6pt</xsl:when>
				<xsl:when test="$level &gt;= 3">6pt</xsl:when>
				<!-- <xsl:when test="local-name() = 'term' and @level = 2">0mm</xsl:when> -->
				<xsl:otherwise>0mm</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
	
		<xsl:element name="{$element-name}">
			<!-- copy @id from empty preceding clause -->
			<xsl:copy-of select="preceding-sibling::*[1][local-name() = 'clause' and count(node()) = 0]/@id"/>
			<xsl:attribute name="font-size"><xsl:value-of select="$font-size"/></xsl:attribute>
			<xsl:attribute name="font-weight"><xsl:value-of select="$font-weight"/></xsl:attribute>
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
			
			<xsl:apply-templates />
			<xsl:apply-templates select="following-sibling::*[1][local-name() = 'variant-title'][@type = 'sub']" mode="subtitle"/>
		</xsl:element>
			
	</xsl:template>
	
		<xsl:template match="*[local-name() = 'annex']" priority="2">
		<fo:block id="{@id}">
		</fo:block>
		<xsl:apply-templates />
	</xsl:template>
	
	<xsl:template match="jis:p" name="paragraph">
		<xsl:param name="inline-header">false</xsl:param>
		<xsl:param name="split_keep-within-line"/>
		
		<xsl:choose>
		
			<xsl:when test="preceding-sibling::*[1][self::jis:title]/@inline-header = 'true' and $inline-header = 'false'"/> <!-- paragraph displayed in title template -->
			
			<xsl:otherwise>
			
				<xsl:variable name="previous-element" select="local-name(preceding-sibling::*[1])"/>
				<xsl:variable name="element-name">fo:block</xsl:variable>
				
				<xsl:element name="{$element-name}">
					<xsl:call-template name="setBlockAttributes"/>
					<xsl:attribute name="margin-bottom">6pt</xsl:attribute><!-- 8pt -->
					<xsl:if test="../following-sibling::*[1][self::jis:note or self::jis:termnote or self::jis:ul or self::jis:ol] or following-sibling::*[1][self::jis:ul or self::jis:ol]">
						<xsl:attribute name="margin-bottom">4pt</xsl:attribute>
					</xsl:if>
					<xsl:if test="parent::jis:li">
						<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
						<xsl:if test="ancestor::jis:feedback-statement">
							<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
						</xsl:if>
					</xsl:if>
					<xsl:if test="parent::jis:li and (ancestor::jis:note or ancestor::jis:termnote)">
						<xsl:attribute name="margin-bottom">4pt</xsl:attribute>
					</xsl:if>
					<xsl:if test="(following-sibling::*[1][self::jis:clause or self::jis:terms or self::jis:references])">
						<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
					</xsl:if>
					<xsl:if test="@id">
						<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
					</xsl:if>
					<xsl:attribute name="line-height">1.4</xsl:attribute>
					<!-- bookmarks only in paragraph -->
					<xsl:if test="count(jis:bookmark) != 0 and count(*) = count(jis:bookmark) and normalize-space() = ''">
						<xsl:attribute name="font-size">0</xsl:attribute>
						<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
						<xsl:attribute name="line-height">0</xsl:attribute>
					</xsl:if>
					<xsl:if test="ancestor::jis:admonition and not(ancestor::jis:admonition/@type = 'commentary')">
						<xsl:attribute name="text-align">justify</xsl:attribute>
						<xsl:if test="not(following-sibling::*)">
							<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
						</xsl:if>
					</xsl:if>
					<xsl:if test="ancestor::*[@key = 'true']">
						<xsl:attribute name="margin-bottom">2pt</xsl:attribute>
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
	
	<xsl:template name="insertHeaderFooter">
		<xsl:param name="docidentifier" />
		<xsl:param name="hidePageNumber">false</xsl:param>
		<xsl:param name="section"/>
		<xsl:param name="copyrightText"/>
		<fo:static-content flow-name="header-odd" role="artifact">
			<fo:block-container height="26mm" display-align="after" text-align="right">
				<fo:block font-size="9pt"><xsl:copy-of select="$docidentifier"/></fo:block>
			</fo:block-container>
		</fo:static-content>
		<fo:static-content flow-name="header-even" role="artifact">
			<fo:block-container height="26mm" display-align="after">
				<fo:block font-size="9pt"><xsl:copy-of select="$docidentifier"/></fo:block>
			</fo:block-container>
		</fo:static-content>
		<xsl:call-template name="insertFooter">
			<xsl:with-param name="section" select="$section"/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template name="insertFooter">
		<xsl:param name="section"/>
		<fo:static-content flow-name="footer">
			<fo:block-container height="24.5mm" display-align="after">
				<xsl:if test="$section = 'preface'">
					<fo:block font-family="Times New Roman" font-size="9pt">(<fo:page-number />)</fo:block>
				</xsl:if>
				<!-- copyright restriction -->
				<fo:block font-size="7pt" text-align="center" font-family="IPAexMincho" margin-bottom="13mm">著作権法により無断での複製，転載等は禁止されております。</fo:block>
			</fo:block-container>
		</fo:static-content>
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
	
</xsl:stylesheet>
