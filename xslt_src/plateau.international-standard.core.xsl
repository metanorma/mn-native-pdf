<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
											xmlns:fo="http://www.w3.org/1999/XSL/Format" 
											xmlns:mn="https://www.metanorma.org/ns/standoc" 
											xmlns:mnx="https://www.metanorma.org/ns/xslt" 
											xmlns:mathml="http://www.w3.org/1998/Math/MathML" 
											xmlns:xalan="http://xml.apache.org/xalan" 
											xmlns:fox="http://xmlgraphics.apache.org/fop/extensions" 
											xmlns:pdf="http://xmlgraphics.apache.org/fop/extensions/pdf"
											xmlns:xlink="http://www.w3.org/1999/xlink"
											xmlns:java="http://xml.apache.org/xalan/java"
											xmlns:jeuclid="http://jeuclid.sf.net/ns/ext"
											xmlns:barcode="http://barcode4j.krysalis.org/ns" 
											xmlns:redirect="http://xml.apache.org/xalan/redirect"
											exclude-result-prefixes="java redirect"
											extension-element-prefixes="redirect"
											version="1.0">

	<xsl:output method="xml" encoding="UTF-8" indent="no"/>
	
	<xsl:key name="kfn" match="mn:fn[not(ancestor::*[self::mn:table or self::mn:figure or self::mn:localized-strings] and not(ancestor::mn:name))]" use="@reference"/>
	
	<xsl:variable name="namespace">plateau</xsl:variable>
	
	<xsl:variable name="debug">false</xsl:variable>
	
	<!-- <xsl:variable name="isIgnoreComplexScripts">true</xsl:variable> -->
	
	<xsl:variable name="doctype" select="//mn:metanorma[1]/mn:bibdata/mn:ext/mn:doctype[@language = '' or not(@language)]"/>
	
	<xsl:variable name="i18n_doctype_dict_annex"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">doctype_dict.annex</xsl:with-param></xsl:call-template></xsl:variable>
	<xsl:variable name="i18n_doctype_dict_technical_report"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">doctype_dict.technical-report</xsl:with-param></xsl:call-template></xsl:variable>
	<xsl:variable name="i18n_table_of_contents"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">table_of_contents</xsl:with-param></xsl:call-template></xsl:variable>
	<xsl:variable name="i18n_table_footnote"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">table_footnote</xsl:with-param></xsl:call-template></xsl:variable>
	
	<xsl:variable name="vertical_layout" select="normalize-space(/*/mn:metanorma-extension/mn:presentation-metadata/mn:vertical-layout)"/>
	<xsl:variable name="vertical_layout_rotate_clause_numbers" select="normalize-space(/*/mn:metanorma-extension/mn:presentation-metadata/mn:vertical-layout-rotate-clause-numbers)"/>
	
	<xsl:variable name="page_header">
		<xsl:value-of select="/*/mn:metanorma-extension/mn:presentation-metadata/mn:use-case"/>
		<xsl:text>_</xsl:text>
		<xsl:value-of select="$i18n_doctype_dict_technical_report"/>
		<xsl:text>_</xsl:text>
		<xsl:value-of select="/*/mn:bibdata/mn:title[@language = 'ja' and @type = 'title-main']"/>
	</xsl:variable>
	
	<xsl:variable name="contents_">
		<xsl:variable name="bundle" select="count(//mn:metanorma) &gt; 1"/>
		
		<xsl:if test="normalize-space($bundle) = 'true'">
			<collection firstpage_id="firstpage_id_0"/>
		</xsl:if>
		
		<xsl:for-each select="//mn:metanorma">
			<xsl:variable name="num"><xsl:number level="any" count="mn:metanorma"/></xsl:variable>
			<xsl:variable name="docnumber"><xsl:value-of select="mn:bibdata/mn:docidentifier[@type = 'JIS']"/></xsl:variable>
			<xsl:variable name="current_document">
				<xsl:copy-of select="."/>
			</xsl:variable>
			
			<xsl:for-each select="xalan:nodeset($current_document)"> <!-- . -->
				<mnx:doc num="{$num}" firstpage_id="firstpage_id_{$num}" title-part="{$docnumber}" bundle="{$bundle}"> <!-- 'bundle' means several different documents (not language versions) in one xml -->
					<mnx:contents>
						<!-- <xsl:call-template name="processPrefaceSectionsDefault_Contents"/> -->
						
						<xsl:call-template name="processMainSectionsDefault_Contents"/>
						
						<xsl:apply-templates select="//mn:indexsect" mode="contents"/>

					</mnx:contents>
				</mnx:doc>
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
			<xsl:if test="$doctype = 'technical-report'">
				<xsl:attribute name="font-size">10pt</xsl:attribute>
			</xsl:if>
			
			<fo:layout-master-set>
			
				<!-- Cover page -->
				<xsl:variable name="cover_page_margin_bottom">
					<xsl:choose>
						<xsl:when test="$doctype = 'technical-report'">48</xsl:when>
						<xsl:otherwise>45</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<fo:simple-page-master master-name="cover-page" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
					<fo:region-body margin-top="15mm" margin-bottom="{$cover_page_margin_bottom}mm" margin-left="36mm" margin-right="8.5mm"/>
					<fo:region-before region-name="header" extent="15mm"/>
					<fo:region-after region-name="footer" extent="{$cover_page_margin_bottom}mm"/>
					<fo:region-start region-name="left-region" extent="36mm"/>
					<fo:region-end region-name="right-region" extent="8.5mm"/>
				</fo:simple-page-master>
			
				<fo:simple-page-master master-name="document_preface" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
					<xsl:if test="$vertical_layout = 'true'">
						<xsl:attribute name="page-width"><xsl:value-of select="$pageHeight"/>mm</xsl:attribute>
						<xsl:attribute name="page-height"><xsl:value-of select="$pageWidth"/>mm</xsl:attribute>
					</xsl:if>
					<fo:region-body margin-top="50mm" margin-bottom="35mm" margin-left="26mm" margin-right="34mm">
						<xsl:if test="$vertical_layout = 'true'">
							<xsl:attribute name="writing-mode">tb-rl</xsl:attribute>
						</xsl:if>
					</fo:region-body>
					<fo:region-before region-name="header" extent="50mm"/>
					<fo:region-after region-name="footer" extent="35mm"/>
					<fo:region-start region-name="left-region" extent="26mm"/>
					<fo:region-end region-name="right-region" extent="34mm"/>
				</fo:simple-page-master>
				
				<fo:simple-page-master master-name="document_toc" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
					<xsl:if test="$vertical_layout = 'true'">
						<xsl:attribute name="page-width"><xsl:value-of select="$pageHeight"/>mm</xsl:attribute>
						<xsl:attribute name="page-height"><xsl:value-of select="$pageWidth"/>mm</xsl:attribute>
					</xsl:if>
					<fo:region-body margin-top="16.5mm" margin-bottom="22mm" margin-left="14.5mm" margin-right="22.3mm">
						<xsl:if test="$vertical_layout = 'true'">
							<xsl:attribute name="writing-mode">tb-rl</xsl:attribute>
						</xsl:if>
					</fo:region-body>
					<fo:region-before region-name="header" extent="16.5mm"/>
					<fo:region-after region-name="footer" extent="22mm"/>
					<fo:region-start region-name="left-region" extent="14.5mm"/>
					<fo:region-end region-name="right-region" extent="22.3mm"/>
				</fo:simple-page-master>
				
				<fo:simple-page-master master-name="document" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
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
				
				<!-- landscape -->
				<fo:simple-page-master master-name="document-landscape" page-width="{$pageHeight}mm" page-height="{$pageWidth}mm">
					<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
					<fo:region-before region-name="header" extent="{$marginTop}mm" precedence="true"/>
					<fo:region-after region-name="footer" extent="{$marginBottom}mm" precedence="true"/>
					<fo:region-start region-name="left-region-landscape" extent="{$marginLeftRight1}mm"/>
					<fo:region-end region-name="right-region-landscape" extent="{$marginLeftRight2}mm"/>
				</fo:simple-page-master>
				
				<fo:simple-page-master master-name="last-page" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
					<fo:region-body margin-top="179.5mm" margin-bottom="30mm" margin-left="15mm" margin-right="22.7mm"/>
					<fo:region-before region-name="header" extent="179.5mm"/>
					<fo:region-after region-name="footer" extent="30mm"/>
					<fo:region-start region-name="left-region" extent="15mm"/>
					<fo:region-end region-name="right-region" extent="22.7mm"/>
				</fo:simple-page-master>
				
				<fo:simple-page-master master-name="last-page_technical-report" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
					<fo:region-body margin-top="191mm" margin-bottom="41mm" margin-left="26mm" margin-right="26mm"/>
					<fo:region-before region-name="header" extent="{$marginTop}mm"/>
					<fo:region-after region-name="footer" extent="{$marginBottom}mm"/>
					<fo:region-start region-name="left-region" extent="{$marginLeftRight1}mm"/>
					<fo:region-end region-name="right-region" extent="{$marginLeftRight2}mm"/>
				</fo:simple-page-master>
			</fo:layout-master-set>
			
			<fo:declarations>
				<xsl:call-template name="addPDFUAmeta"/>
			</fo:declarations>

			<xsl:call-template name="addBookmarks">
				<xsl:with-param name="contents" select="$contents"/>
			</xsl:call-template>
			
			<!-- <xsl:if test="$debug = 'true'">
				<xsl:message>start contents redirect</xsl:message>
				<redirect:write file="contents.xml">
					<xsl:copy-of select="$contents"/>
				</redirect:write>
				<xsl:message>end contents redirect</xsl:message>
			</xsl:if> -->
			
			<xsl:variable name="updated_xml_pres">
				<xsl:apply-templates mode="update_xml_pres"/>
			</xsl:variable>
			
			<xsl:if test="$debug = 'true'">
				<xsl:message>start redirect</xsl:message>
				<redirect:write file="update_xml_pres.xml">
					<xsl:copy-of select="$updated_xml_pres"/>
				</redirect:write>
				<xsl:message>end redirect</xsl:message>
			</xsl:if>
			
			<xsl:variable name="updated_xml_step1">
				<xsl:apply-templates select="xalan:nodeset($updated_xml_pres)" mode="update_xml_step1"/>
			</xsl:variable>
			<!-- DEBUG: updated_xml_step1=<xsl:copy-of select="$updated_xml_step1"/> -->
			<xsl:if test="$debug = 'true'">
				<xsl:message>start redirect</xsl:message>
				<redirect:write file="update_xml_step1.xml">
					<xsl:copy-of select="$updated_xml_step1"/>
				</redirect:write>
				<xsl:message>end redirect</xsl:message>
			</xsl:if>
			
			
			<xsl:variable name="updated_xml_step2_">
				<xsl:apply-templates select="xalan:nodeset($updated_xml_step1)" mode="update_xml_step2"/>
			</xsl:variable>
			<xsl:variable name="updated_xml_step2" select="xalan:nodeset($updated_xml_step2_)"/>
			<!-- DEBUG: updated_xml_step2=<xsl:copy-of select="$updated_xml_step2"/> -->
			
			<xsl:if test="$debug = 'true'">
				<xsl:message>start redirect</xsl:message>
				<redirect:write file="update_xml_step2.xml">
					<xsl:copy-of select="$updated_xml_step2"/>
				</redirect:write>
				<xsl:message>end redirect</xsl:message>
			</xsl:if>
			
			
			<xsl:for-each select="$updated_xml_step2//mn:metanorma">
				<xsl:variable name="num"><xsl:number level="any" count="mn:metanorma"/></xsl:variable>
				
				<!-- <xsl:variable name="current_document">
					<xsl:copy-of select="."/>
				</xsl:variable> -->
				
				<xsl:variable name="updated_xml_with_pages">
					<xsl:call-template name="processPrefaceAndMainSectionsPlateau_items"/>
				</xsl:variable>
				
				<!-- <xsl:for-each select="xalan:nodeset($current_document)"> -->
				<xsl:for-each select="xalan:nodeset($updated_xml_with_pages)">
				
					<xsl:call-template name="insertCoverPage">
						<xsl:with-param name="num" select="$num"/>
					</xsl:call-template>
										
					<!-- ========================== -->
					<!-- Preface and contents pages -->
					<!-- ========================== -->
					
					<!-- Preface pages -->
					<xsl:for-each select=".//mn:page_sequence[parent::mn:preface][normalize-space() != '' or .//mn:image or .//*[local-name() = 'svg']]">
					
						<xsl:choose>
							<xsl:when test="mn:clause[@type = 'toc']">
								<fo:page-sequence master-reference="document_toc" initial-page-number="1" force-page-count="no-force">
									<xsl:if test="$doctype = 'technical-report'">
										<xsl:attribute name="master-reference">document</xsl:attribute>
									</xsl:if>
									<xsl:call-template name="insertHeader"/>
									<fo:flow flow-name="xsl-region-body">
										
										<!-- <xsl:apply-templates select="/*/mn:preface/mn:clause[@type = 'toc']">
											<xsl:with-param name="num" select="$num"/>
										</xsl:apply-templates>
										
										<xsl:if test="not(/*/mn:preface/mn:clause[@type = 'toc'])">
											<fo:block> --><!-- prevent fop error for empty document --><!-- </fo:block>
										</xsl:if> -->
										
										<xsl:apply-templates select="*">
											<xsl:with-param name="num" select="$num"/>
										</xsl:apply-templates>
									</fo:flow>
								</fo:page-sequence>
							</xsl:when>
							<xsl:otherwise>
					
								<fo:page-sequence master-reference="document_preface" force-page-count="no-force" font-family="Noto Sans JP" font-size="10pt">
								
									<xsl:attribute name="master-reference">
										<xsl:text>document_preface</xsl:text>
										<xsl:call-template name="getPageSequenceOrientation"/>
									</xsl:attribute>
									
									<fo:static-content flow-name="header" role="artifact" id="__internal_layout__preface_header_{generate-id()}">
										<!-- grey background  -->
										<fo:block-container absolute-position="fixed" left="24.2mm" top="40mm" height="231.4mm" width="161mm" background-color="rgb(242,242,242)" id="__internal_layout__preface_header_{$num}_{generate-id()}">
											<xsl:if test="$vertical_layout = 'true'">
												<xsl:attribute name="top">24.2mm</xsl:attribute>
												<xsl:attribute name="left">40mm</xsl:attribute>
												<xsl:attribute name="writing-mode">tb-rl</xsl:attribute>
											</xsl:if>
											<fo:block>&#xa0;</fo:block>
										</fo:block-container>
									</fo:static-content>
								
									<fo:flow flow-name="xsl-region-body">
										<fo:block line-height="2">
											<!-- <xsl:for-each select="$paged_xml_preface/*[local-name()='page']">
												<xsl:if test="position() != 1">
													<fo:block break-after="page"/>
												</xsl:if>
												<xsl:apply-templates select="*" mode="page"/>
											</xsl:for-each> -->
											<xsl:apply-templates />
										</fo:block>
									</fo:flow>
								
								</fo:page-sequence>
							</xsl:otherwise>
						</xsl:choose>
					
					
					</xsl:for-each>
				
					<!-- ========================== -->
					<!-- END Preface and contents pages -->
					<!-- ========================== -->
					
					<xsl:for-each select=".//mn:page_sequence[not(parent::mn:preface)][normalize-space() != '' or .//mn:image or .//*[local-name() = 'svg']]">
						<fo:page-sequence master-reference="document" force-page-count="no-force">
							
							<xsl:attribute name="master-reference">
								<xsl:text>document</xsl:text>
								<xsl:call-template name="getPageSequenceOrientation"/>
							</xsl:attribute>
							
							<xsl:if test="position() = 1">
								<xsl:attribute name="initial-page-number">1</xsl:attribute>
							</xsl:if>
							
							<xsl:call-template name="insertFootnoteSeparatorCommon"><xsl:with-param name="leader_length">15%</xsl:with-param></xsl:call-template>
							
							<xsl:call-template name="insertHeaderFooter"/>
							
							<fo:flow flow-name="xsl-region-body">
								<xsl:apply-templates />

								<fo:block/><!-- prevent fop error for empty document -->
								
							</fo:flow>
						</fo:page-sequence>
					</xsl:for-each>
					
					
					
					<xsl:choose>
						<xsl:when test="$doctype = 'technical-report'">
							<fo:page-sequence master-reference="last-page_technical-report" force-page-count="no-force">
								<xsl:call-template name="insertHeaderFooter"/>
								<fo:flow flow-name="xsl-region-body">
									<fo:block-container width="100%" height="64mm" border="0.75pt solid black" font-size="14pt" text-align="center" display-align="center" line-height="1.7">
										<fo:block>
											<xsl:value-of select="/*/mn:bibdata/mn:title[@language = 'ja' and @type = 'title-main']"/>
										</fo:block>
										<fo:block>
											<xsl:value-of select="$i18n_doctype_dict_technical_report"/>
										</fo:block>
										<fo:block font-size="12pt" margin-top="18pt">
											<fo:block><xsl:value-of select="/*/mn:bibdata/mn:date[@type = 'published']"/><xsl:text> 発行</xsl:text></fo:block>
											<!-- 委託者 (Contractor) -->
											<fo:block>委託者：<xsl:value-of select="/*/mn:bibdata/mn:contributor[mn:role/@type = 'author']/mn:organization/mn:name"/></fo:block>
											<!-- 受託者 (Trustees) -->
											<fo:block>受託者：<xsl:value-of select="/*/mn:bibdata/mn:contributor[mn:role/@type = 'enabler']/mn:organization/mn:name"/></fo:block>
										</fo:block>
									</fo:block-container>
								</fo:flow>
							</fo:page-sequence>
						</xsl:when>
						<xsl:otherwise> <!-- handbook -->
							<fo:page-sequence master-reference="last-page" force-page-count="no-force">
								<fo:flow flow-name="xsl-region-body">
									<fo:block-container width="100%" border="0.75pt solid black" font-size="10pt" line-height="1.7">
										<fo:block margin-left="4.5mm" margin-top="1mm">
											<xsl:value-of select="/*/mn:bibdata/mn:title[@language = 'ja' and @type = 'title-main']"/>
											<fo:inline padding-left="4mm"><xsl:value-of select="/*/mn:bibdata/mn:edition[@language = 'ja']"/></fo:inline>
										</fo:block>
										<fo:block margin-left="7.7mm"><xsl:value-of select="/*/mn:bibdata/mn:date[@type = 'published']"/><xsl:text> 発行</xsl:text></fo:block>
										<!-- MLIT Department -->
										<fo:block margin-left="7.7mm"><xsl:value-of select="/*/mn:bibdata/mn:contributor[mn:role/@type = 'author']/mn:organization/mn:name"/></fo:block>
										<fo:block margin-left="9mm"><xsl:value-of select="/*/mn:bibdata/mn:contributor[mn:role/@type = 'enabler']/mn:organization/mn:name"/></fo:block>
									</fo:block-container>
								</fo:flow>
							</fo:page-sequence>
						</xsl:otherwise>
					</xsl:choose>
					
					


					
				</xsl:for-each>
			
			</xsl:for-each>
			
			<xsl:if test="not(//mn:metanorma)">
				<fo:page-sequence master-reference="document" force-page-count="no-force">
					<fo:flow flow-name="xsl-region-body">
						<fo:block><!-- prevent fop error for empty document --></fo:block>
					</fo:flow>
				</fo:page-sequence>
			</xsl:if>
			
		</fo:root>
	</xsl:template>
	
	<xsl:template name="processPrefaceAndMainSectionsPlateau_items">
			
		<xsl:variable name="updated_xml_step_move_pagebreak">
			<xsl:element name="{$root_element}" namespace="{$namespace_full}">
				<xsl:call-template name="copyCommonElements"/>
				
				
				<xsl:element name="preface" namespace="{$namespace_full}"> <!-- save context element -->
					<xsl:for-each select="/*/mn:preface/*[not(self::mn:note or self::mn:admonition or (self::mn:clause and @type = 'toc'))]">
						<xsl:sort select="@displayorder" data-type="number"/>
						<xsl:element name="page_sequence" namespace="{$namespace_full}">
							<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak"/>
						</xsl:element>
					</xsl:for-each>
				</xsl:element>
			
				<xsl:element name="preface" namespace="{$namespace_full}"> <!-- save context element -->
					<xsl:for-each select="/*/mn:preface/*[self::mn:clause and @type = 'toc']">
						<xsl:element name="page_sequence" namespace="{$namespace_full}">
							<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak"/>
						</xsl:element>
					</xsl:for-each>
				</xsl:element>
				
				
				<xsl:element name="sections" namespace="{$namespace_full}"> <!-- save context element -->
					
					<!-- determine clause 2 element number -->
					<xsl:variable name="clause_2_num_" select="count(/*/mn:sections/*[normalize-space(mn:title/mn:tab/preceding-sibling::*) = '2']/preceding-sibling::*)"/>
					<xsl:variable name="clause_2_num__">
						<xsl:choose>
							<xsl:when test="$clause_2_num_ = 0">2</xsl:when>
							<xsl:otherwise><xsl:value-of select="$clause_2_num_ + 1"/></xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="clause_2_num" select="number($clause_2_num__)"/>
					
					
					<xsl:for-each select="/*/mn:sections/*[position() &lt; $clause_2_num]">
						<xsl:sort select="@displayorder" data-type="number"/>
						<xsl:element name="page_sequence" namespace="{$namespace_full}">
							<xsl:attribute name="main_page_sequence"/>
							<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak"/>
						</xsl:element>
					</xsl:for-each>
					
					<!-- second clause is scope -->
					<xsl:choose>
						<xsl:when test="count(/*/mn:sections/*[$clause_2_num]/*) = 2"> <!-- title and paragraph -->
							<xsl:element name="page_sequence" namespace="{$namespace_full}">
								<xsl:apply-templates select="/*/mn:sections/*[$clause_2_num]" mode="update_xml_step_move_pagebreak"/>
								<xsl:apply-templates select="/*/mn:sections/*[$clause_2_num + 1]" mode="update_xml_step_move_pagebreak"/>
							</xsl:element>
						</xsl:when>
						<xsl:otherwise>
							<xsl:element name="page_sequence" namespace="{$namespace_full}">
								<xsl:apply-templates select="/*/mn:sections/*[$clause_2_num]" mode="update_xml_step_move_pagebreak"/>
							</xsl:element>
							<xsl:element name="page_sequence" namespace="{$namespace_full}">
								<xsl:apply-templates select="/*/mn:sections/*[$clause_2_num + 1]" mode="update_xml_step_move_pagebreak"/>
							</xsl:element>
						</xsl:otherwise>
					</xsl:choose>
					
					<xsl:for-each select="/*/mn:sections/*[position() &gt; $clause_2_num + 1]">
						<xsl:sort select="@displayorder" data-type="number"/>
						<xsl:element name="page_sequence" namespace="{$namespace_full}">
							<xsl:attribute name="main_page_sequence"/>
							<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak"/>
						</xsl:element>
					</xsl:for-each>
				</xsl:element>
				
				<xsl:call-template name="insertAnnexInSeparatePageSequences"/>
				<xsl:call-template name="insertBibliographyInSeparatePageSequences"/>
				<xsl:call-template name="insertIndexInSeparatePageSequences"/>
		
			</xsl:element>
		</xsl:variable>
		
		<xsl:variable name="updated_xml_step_move_pagebreak_filename" select="concat($output_path,'_main_', java:getTime(java:java.util.Date.new()), '.xml')"/>
		
	
		<redirect:write file="{$updated_xml_step_move_pagebreak_filename}">
			<xsl:copy-of select="$updated_xml_step_move_pagebreak"/>
		</redirect:write>
		
	
		<xsl:copy-of select="document($updated_xml_step_move_pagebreak_filename)"/>
		
		<xsl:if test="$debug = 'true'">
			<redirect:write file="page_sequence_preface_and_main.xml">
				<xsl:copy-of select="$updated_xml_step_move_pagebreak"/>
			</redirect:write>
		</xsl:if>
		
		<xsl:call-template name="deleteFile">
			<xsl:with-param name="filepath" select="$updated_xml_step_move_pagebreak_filename"/>
		</xsl:call-template>
	</xsl:template> <!-- END: processPrefaceAndMainSectionsPlateau_items -->
	
	
	<xsl:template match="mn:preface//mn:clause[@type = 'toc']" priority="4">
		<xsl:param name="num"/>
		<xsl:if test="$doctype = 'technical-report'">
			<fo:block font-size="16pt" margin-top="5mm"><xsl:value-of select="$i18n_table_of_contents"/></fo:block>
			<fo:block><fo:leader leader-pattern="rule" rule-style="double" rule-thickness="1.5pt" leader-length="100%"/></fo:block>
		</xsl:if>
		<xsl:apply-templates />
		<xsl:if test="count(*) = 1 and mn:title"> <!-- if there isn't user ToC -->
			<!-- fill ToC -->
			<fo:block role="TOC" font-weight="bold">
				<xsl:if test="$doctype = 'technical-report'">
					<xsl:attribute name="font-weight">normal</xsl:attribute>
					<xsl:attribute name="line-height">1.2</xsl:attribute>
				</xsl:if>
				<xsl:if test="$contents/mnx:doc[@num = $num]//mnx:item[@display = 'true']">
					<xsl:for-each select="$contents/mnx:doc[@num = $num]//mnx:item[@display = 'true'][@level &lt;= $toc_level or @type='figure' or @type = 'table']">
						<fo:block role="TOCI">
							<xsl:choose>
								<xsl:when test="$doctype = 'technical-report'">
									<fo:block space-after="5pt">
										<xsl:variable name="margin-left">
											<xsl:choose>
												<xsl:when test="@level = 1">1</xsl:when>
												<xsl:when test="@level = 2">3.5</xsl:when>
												<xsl:when test="@level = 3">7</xsl:when>
												<xsl:otherwise>10</xsl:otherwise>
											</xsl:choose>
										</xsl:variable>
										<xsl:attribute name="margin-left">
											<xsl:choose>
												<xsl:when test="$vertical_layout_rotate_clause_numbers = 'true'">
													<xsl:value-of select="concat($margin-left * 1.5, 'mm')"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="concat($margin-left, 'mm')"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:attribute>
										<xsl:call-template name="insertTocItem">
											<xsl:with-param name="printSection">true</xsl:with-param>
										</xsl:call-template>
									</fo:block>
								</xsl:when>
								<xsl:otherwise>
									<xsl:choose>
										<xsl:when test="@type = 'annex' or @type = 'bibliography' or @type = 'index'">
											<fo:block space-after="5pt">
												<xsl:call-template name="insertTocItem"/>
											</fo:block>
										</xsl:when>
										<xsl:otherwise>
											<xsl:variable name="margin_left" select="number(@level - 1) * 3"/>
											<fo:list-block space-after="2pt" margin-left="{$margin_left}mm">
												<xsl:variable name="provisional-distance-between-starts">
													<xsl:choose>
														<xsl:when test="@level = 1">7</xsl:when>
														<xsl:when test="@level = 2">10</xsl:when>
														<xsl:when test="@level = 3">14</xsl:when>
														<xsl:otherwise>14</xsl:otherwise>
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
												<fo:list-item>
													<fo:list-item-label end-indent="label-end()">
														<fo:block>
															<xsl:choose>
																<xsl:when test="$vertical_layout_rotate_clause_numbers = 'true'">
																	<xsl:call-template name="insertVerticalChar">
																		<xsl:with-param name="str" select="@section"/>
																	</xsl:call-template>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:value-of select="@section"/>
																</xsl:otherwise>
															</xsl:choose>
														</fo:block>
													</fo:list-item-label>
													<fo:list-item-body start-indent="body-start()">
														<xsl:call-template name="insertTocItem"/>
													</fo:list-item-body>
												</fo:list-item>
											</fo:list-block>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</xsl:for-each>
				</xsl:if>
			</fo:block>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="mn:clause[@type = 'toc']/mn:title" priority="3"/>
		
	<xsl:template name="insertTocItem">
		<xsl:param name="printSection">false</xsl:param>
		<fo:block text-align-last="justify" role="TOCI">
			<fo:basic-link internal-destination="{@id}" fox:alt-text="{mnx:title}">
				<xsl:if test="$printSection = 'true' and @section != ''">
					<xsl:value-of select="@section"/>
					<xsl:text>. </xsl:text>
				</xsl:if>
				<fo:inline><xsl:apply-templates select="mnx:title" /><xsl:text> </xsl:text></fo:inline>
				<fo:inline keep-together.within-line="always">
					<fo:leader leader-pattern="dots"/>
					<fo:inline>
						<xsl:if test="$doctype = 'technical-report'"><xsl:text>- </xsl:text></xsl:if>
						<fo:page-number-citation ref-id="{@id}"/>
						<xsl:if test="$doctype = 'technical-report'"><xsl:text> -</xsl:text></xsl:if>
					</fo:inline>
				</fo:inline>
			</fo:basic-link>
		</fo:block>
	</xsl:template>
	
	<xsl:template name="insertCoverPage">
		<xsl:param name="num"/>
		<fo:page-sequence master-reference="cover-page" force-page-count="no-force" font-family="Noto Sans Condensed">
			
			<xsl:if test="$doctype = 'annex'">
				<xsl:attribute name="color">white</xsl:attribute>
			</xsl:if>
			<xsl:if test="$doctype = 'technical-report'">
				<xsl:attribute name="font-family">Noto Sans</xsl:attribute>
			</xsl:if>
			
			<fo:static-content flow-name="header" role="artifact" id="__internal_layout__coverpage_header_{generate-id()}">
				<!-- background cover image -->
				<xsl:call-template name="insertBackgroundPageImage"/>
			</fo:static-content>
			
			<fo:static-content flow-name="footer" role="artifact">
				<fo:block-container>
					<fo:table table-layout="fixed" width="100%">
						<fo:table-column column-width="proportional-column-width(140)"/>
						<fo:table-column column-width="proportional-column-width(13.5)"/>
						<xsl:choose>
							<xsl:when test="$doctype = 'technical-report'">
								<fo:table-column column-width="proportional-column-width(20)"/>
							</xsl:when>
							<xsl:otherwise>
								<fo:table-column column-width="proportional-column-width(11)"/>
							</xsl:otherwise>
						</xsl:choose>
						<fo:table-body>
							<fo:table-row>
								<fo:table-cell>
									<fo:block font-size="28pt" font-family="Noto Sans JP">
										<xsl:if test="$doctype = 'annex'">
											<xsl:attribute name="text-indent">-7mm</xsl:attribute>
											<xsl:value-of select="concat('（', $i18n_doctype_dict_annex)"/>
											<fo:inline letter-spacing="-3mm">）</fo:inline>
										</xsl:if>
										<xsl:if test="$doctype = 'technical-report'">
											<xsl:attribute name="font-size">18pt</xsl:attribute>
											<xsl:attribute name="line-height">1.8</xsl:attribute>
										</xsl:if>
										<xsl:variable name="title">
											<xsl:apply-templates select="/*/mn:bibdata/mn:title[@language = 'ja' and @type = 'title-main']/node()"/>
										</xsl:variable>
										<xsl:copy-of select="$title"/>
										<xsl:if test="$doctype = 'technical-report'">
											<xsl:choose>
												<xsl:when test="string-length($title) &gt; 60">
													<fo:inline> <xsl:value-of select="$i18n_doctype_dict_technical_report"/></fo:inline>
												</xsl:when>
												<xsl:otherwise>
													<fo:block><xsl:value-of select="$i18n_doctype_dict_technical_report"/></fo:block>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:if>
									</fo:block>
									<fo:block font-size="14pt" margin-top="3mm">
										<xsl:if test="$doctype = 'technical-report'">
											<xsl:attribute name="font-size">9pt</xsl:attribute>
											<xsl:attribute name="margin-top">1mm</xsl:attribute>
										</xsl:if>
										<xsl:apply-templates select="/*/mn:bibdata/mn:title[@language = 'en' and @type = 'title-main']/node()"/>
									</fo:block>
								</fo:table-cell>
								<fo:table-cell text-align="right" font-size="8.5pt" padding-top="3mm" padding-right="2mm">
									<xsl:if test="$doctype = 'technical-report'">
										<xsl:attribute name="font-size">9.5pt</xsl:attribute>
										<xsl:attribute name="padding-top">2mm</xsl:attribute>
									</xsl:if>
									<fo:block>series</fo:block>
									<fo:block>No.</fo:block>
								</fo:table-cell>
								<fo:table-cell text-align="right">
									<xsl:if test="$doctype = 'technical-report'">
										<xsl:attribute name="text-align">center</xsl:attribute>
									</xsl:if>
									<fo:block font-size="32pt">
										<xsl:if test="$doctype = 'technical-report'">
											<xsl:attribute name="font-size">28pt</xsl:attribute>
										</xsl:if>
										<xsl:variable name="docnumber" select="/*/mn:bibdata/mn:docnumber"/>
										<xsl:if test="string-length($docnumber) = 1">0</xsl:if><xsl:value-of select="$docnumber"/>
									</fo:block>
								</fo:table-cell>
							</fo:table-row>
						</fo:table-body>
					</fo:table>
				</fo:block-container>
			</fo:static-content>
		
			<fo:static-content flow-name="left-region" role="artifact" id="__internal_layout__coverpage_left_region_{generate-id()}">				
				<fo:block text-align="center" margin-top="14.5mm" margin-left="2mm">
					<xsl:if test="$doctype = 'technical-report'">
						<xsl:attribute name="margin-left">5.5mm</xsl:attribute>
					</xsl:if>
					<fo:instream-foreign-object content-width="24mm" fox:alt-text="PLATEAU Logo">
						<xsl:if test="$doctype = 'technical-report'">
							<xsl:attribute name="content-width">20.5mm</xsl:attribute>
						</xsl:if>
						<xsl:choose>
							<xsl:when test="$doctype = 'annex'">
								<xsl:copy-of select="$PLATEAU-Logo-inverted"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:copy-of select="$PLATEAU-Logo"/>
							</xsl:otherwise>
						</xsl:choose>
					</fo:instream-foreign-object>
				</fo:block>
				<fo:block-container reference-orientation="-90" width="205mm" height="36mm" margin-top="6mm">
					<xsl:if test="$doctype = 'technical-report'">
						<xsl:attribute name="margin-top">2mm</xsl:attribute>
					</xsl:if>
					<fo:block font-size="21.2pt" margin-top="7mm">
						<xsl:if test="$doctype = 'technical-report'">
							<xsl:attribute name="font-size">16pt</xsl:attribute>
							<xsl:attribute name="margin-top">8mm</xsl:attribute>
						</xsl:if>
						<xsl:apply-templates select="/*/mn:bibdata/mn:title[@language = 'en' and @type = 'title-intro']/node()"/>
					</fo:block>
					<fo:block font-family="Noto Sans JP" font-size="14.2pt" margin-top="2mm">
						<xsl:if test="$doctype = 'annex'">
							<xsl:attribute name="text-indent">-3.5mm</xsl:attribute>
							<xsl:value-of select="concat('（', $i18n_doctype_dict_annex)"/>
							<fo:inline letter-spacing="-1mm">）</fo:inline>
						</xsl:if>
						<xsl:if test="$doctype = 'technical-report'">
							<xsl:attribute name="font-size">12pt</xsl:attribute>
						</xsl:if>
						<xsl:apply-templates select="/*/mn:bibdata/mn:title[@language = 'ja' and @type = 'title-intro']/node()"/>
					</fo:block>
				</fo:block-container>
			</fo:static-content>
			
			<fo:flow flow-name="xsl-region-body">
				<fo:block id="firstpage_id_{$num}">&#xa0;</fo:block>
			</fo:flow>
		</fo:page-sequence>
	</xsl:template> <!-- insertCoverPage -->
	
	
	<xsl:template match="mn:p[@class = 'JapaneseIndustrialStandard']" priority="4"/>
	<xsl:template match="mn:p[@class = 'StandardNumber']" priority="4"/>
	<xsl:template match="mn:p[@class = 'IDT']" priority="4"/>
	<xsl:template match="mn:p[@class = 'zzSTDTitle1']" priority="4"/>
	<xsl:template match="mn:p[@class = 'zzSTDTitle2']" priority="4"/>
	
	<!-- for commentary annex -->
	<xsl:template match="mn:p[@class = 'CommentaryStandardNumber']" priority="4">
		<fo:block font-size="15pt" text-align="center">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="mn:p[@class = 'CommentaryStandardNumber']//text()[not(ancestor::mn:span)]" priority="4">
		<fo:inline font-family="Arial">
			<xsl:choose>
				<xsl:when test="contains(., ':')">
					<xsl:value-of select="substring-before(., ':')"/>
					<fo:inline baseline-shift="10%" font-size="10pt">：</fo:inline>
					<xsl:value-of select="substring-after(., ':')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="mn:p[@class = 'CommentaryStandardNumber']/mn:span[@class = 'CommentaryEffectiveYear']" priority="4">
		<fo:inline  baseline-shift="10%" font-family="Noto Sans Condensed" font-size="10pt"><xsl:apply-templates/></fo:inline>
	</xsl:template>
	
	<xsl:template match="mn:p[@class = 'CommentaryStandardName']" priority="4">
		<fo:block role="H1" font-size="16pt" text-align="center" margin-top="6mm">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	
	<!-- ============================= -->
	<!-- CONTENTS                      -->
	<!-- ============================= -->
	
	<!-- element with title -->
	<xsl:template match="*[mn:title or mn:fmt-title]" mode="contents">
	
		<xsl:variable name="level">
			<xsl:call-template name="getLevel">
				<xsl:with-param name="depth" select="mn:fmt-title/@depth | mn:title/@depth"/>
			</xsl:call-template>
		</xsl:variable>
		
		<!-- if previous clause contains section-title as latest element (section-title may contain  note's, admonition's, etc.),
		and if @depth of current clause equals to section-title @depth,
		then put section-title before current clause -->
		<xsl:if test="self::mn:clause">
			<xsl:apply-templates select="preceding-sibling::*[1][self::mn:clause]//*[self::mn:p and @type = 'section-title'
				and @depth = $level 
				and not(following-sibling::mn:clause)]" mode="contents_in_clause"/>
		</xsl:if>
		
		<xsl:variable name="section">
			<xsl:call-template name="getSection"/>
		</xsl:variable>
		
		<xsl:variable name="type">
			<xsl:choose>
				<xsl:when test="self::mn:indexsect">index</xsl:when>
				<xsl:when test="(ancestor-or-self::mn:bibliography and self::mn:clause and not(.//*[self::mn:references and @normative='true'])) or self::mn:references[not(@normative) or @normative='false']">bibliography</xsl:when>
				<xsl:otherwise><xsl:value-of select="local-name()"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
			
		<xsl:variable name="display">
			<xsl:choose>
				<xsl:when test="normalize-space(@id) = ''">false</xsl:when>
				<xsl:when test="ancestor-or-self::mn:annex and $level &gt;= 2">false</xsl:when>
				<!-- <xsl:when test="$type = 'bibliography' and $level &gt;= 2">false</xsl:when> -->
				<xsl:when test="$type = 'bibliography'">true</xsl:when>
				<!-- <xsl:when test="$type = 'references' and $level &gt;= 2">false</xsl:when> -->
				<xsl:when test="$type = 'references'">true</xsl:when>
				<xsl:when test="ancestor-or-self::mn:colophon">true</xsl:when>
				<xsl:when test="$section = '' and $type = 'clause' and $level = 1 and ancestor::mn:preface">true</xsl:when>
				<xsl:when test="$section = '' and $type = 'clause'">false</xsl:when>
				<xsl:when test="$level &lt;= $toc_level">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="skip">
			<xsl:choose>
				<xsl:when test="ancestor-or-self::mn:bibitem">true</xsl:when>
				<xsl:when test="ancestor-or-self::mn:term">true</xsl:when>				
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
				<xsl:if test="ancestor-or-self::mn:preface">preface</xsl:if>
				<xsl:if test="ancestor-or-self::mn:annex">annex</xsl:if>
			</xsl:variable>
			
			<mnx:item id="{@id}" level="{$level}" section="{$section}" type="{$type}" root="{$root}" display="{$display}">
				<xsl:if test="$type = 'index'">
					<xsl:attribute name="level">1</xsl:attribute>
				</xsl:if>
				<mnx:title>
					<xsl:apply-templates select="xalan:nodeset($title)" mode="contents_item">
						<xsl:with-param name="mode">contents</xsl:with-param>
					</xsl:apply-templates>
				</mnx:title>
				<xsl:if test="$type != 'index'">
					<xsl:apply-templates  mode="contents" />
				</xsl:if>
			</mnx:item>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="mn:preface/mn:page_sequence/mn:clause" priority="3">
		<fo:block>
			<xsl:call-template name="setId"/>
			<xsl:call-template name="addReviewHelper"/>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="*" priority="3" mode="page">
		<xsl:call-template name="elementProcessing"/>
	</xsl:template>
	
	<xsl:template name="elementProcessing">
		<xsl:choose>
			<xsl:when test="self::mn:p and count(node()) = count(processing-instruction())"><!-- skip --></xsl:when> <!-- empty paragraph with processing-instruction -->
			<xsl:when test="@hidden = 'true'"><!-- skip --></xsl:when>
			<xsl:when test="self::mn:title or self::mn:term">
				<xsl:apply-templates select="."/>
			</xsl:when>
			<xsl:when test="@mainsection = 'true'">
				<!-- page break before section's title -->
				<xsl:if test="self::mn:p and @type='section-title'">
					<fo:block break-after="page"/>
				</xsl:if>
				<fo:block-container>
					<xsl:attribute name="keep-with-next">always</xsl:attribute>
					<fo:block><xsl:apply-templates select="."/></fo:block>
				</fo:block-container>
			</xsl:when>
			<xsl:when test="self::mn:indexsect">
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
	
	
	<xsl:template match="mn:title" priority="2" name="title">
	
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		
		<xsl:variable name="font-size">
			<xsl:choose>
				<!-- <xsl:when test="@parent = 'preface'">10pt</xsl:when> -->
				<xsl:when test="$doctype = 'technical-report' and $level = 1">16pt</xsl:when>
				<xsl:when test="$doctype = 'technical-report' and $level = 2">14pt</xsl:when>
				<xsl:when test="$doctype = 'technical-report' and $level = 3">12pt</xsl:when>
				<xsl:when test="$doctype = 'technical-report' and $level &gt;= 4">10pt</xsl:when>
				<xsl:when test="ancestor::mn:sections">12pt</xsl:when>
				<xsl:when test="ancestor::mn:annex and $level = 1">14pt</xsl:when>
				<xsl:when test="ancestor::mn:annex">12pt</xsl:when>
				<xsl:otherwise>10pt</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="font-weight">bold</xsl:variable>
			<!-- <xsl:choose>
				<xsl:when test="@parent = 'preface'">bold</xsl:when>
				<xsl:when test="@parent = 'annex'">bold</xsl:when>
				<xsl:when test="@parent = 'bibliography'">bold</xsl:when>
				<xsl:otherwise>normal</xsl:otherwise>
			</xsl:choose>
		</xsl:variable> -->
		
		<xsl:variable name="text-align">
			<xsl:choose>
				<xsl:when test="ancestor::mn:foreword and $level = 1">center</xsl:when>
				<xsl:when test="ancestor::mn:annex and $level = 1">center</xsl:when>
				<xsl:otherwise>left</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		
		<xsl:variable name="margin-top">
			<xsl:choose>
				<xsl:when test="ancestor::mn:foreword and $level = 1">9mm</xsl:when>
				<!-- <xsl:when test="ancestor::mn:annex and $level = '1' and ancestor::mn:annex[1][@commentary = 'true']">1mm</xsl:when> -->
				<xsl:when test="ancestor::mn:annex and $level = 1">0mm</xsl:when>
				<xsl:when test="$level = 1 and not(ancestor::mn:preface)">6.5mm</xsl:when>
				<xsl:when test="ancestor::mn:foreword and $level = 2">0mm</xsl:when>
				<!-- <xsl:when test="ancestor::mn:annex and $level = 2">4.5mm</xsl:when> -->
				<xsl:when test="ancestor::mn:bibliography and $level = 2">0mm</xsl:when>
				<xsl:when test="$doctype = 'technical-report' and $level = 2 and preceding-sibling::*[2][self::mn:title]">0mm</xsl:when>
				<xsl:when test="$doctype = 'technical-report' and $level = 3 and preceding-sibling::*[2][self::mn:title]">0mm</xsl:when>
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
				<xsl:when test="$doctype = 'technical-report'">
					<xsl:choose>
						<xsl:when test="following-sibling::*[1][self::mn:clause]">0</xsl:when>
						<xsl:when test="following-sibling::*[1][self::mn:p]">16pt</xsl:when>
						<xsl:otherwise>12pt</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="ancestor::mn:preface">6pt</xsl:when>
						<xsl:when test="ancestor::mn:foreword and $level = 1">9mm</xsl:when>
						<!-- <xsl:when test="ancestor::mn:annex and $level = '1' and ancestor::mn:annex[1][@commentary = 'true']">7mm</xsl:when> -->
						<!-- <xsl:when test="ancestor::mn:annex and $level = 1">1mm</xsl:when> -->
						<xsl:when test="$level = 1 and following-sibling::*[1][self::mn:clause]">8pt</xsl:when>
						<xsl:when test="$level = 1">12pt</xsl:when>
						<xsl:when test="$level = 2 and following-sibling::*[1][self::mn:clause]">8pt</xsl:when>
						<xsl:when test="$level &gt;= 2">12pt</xsl:when>
						<xsl:when test="@type = 'section-title'">6mm</xsl:when>
						<xsl:when test="@inline-header = 'true'">0pt</xsl:when>
						<xsl:otherwise>0mm</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
	

		<!-- to space-before Foreword -->
		<xsl:if test="ancestor::mn:foreword and $level = '1'"><fo:block></fo:block></xsl:if>
	

		<xsl:choose>
			<xsl:when test="@inline-header = 'true' and following-sibling::*[1][self::mn:p]">
				<fo:block role="H{$level}">
					<xsl:for-each select="following-sibling::*[1][self::mn:p]">
						<xsl:call-template name="paragraph">
							<xsl:with-param name="inline-header">true</xsl:with-param>
						</xsl:call-template>
					</xsl:for-each>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="{$element-name}">
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
					
					<!-- <xsl:if test="$level = '3'">
						<xsl:attribute name="margin-left">7.5mm</xsl:attribute>
					</xsl:if> -->
					
					<xsl:if test="$doctype = 'technical-report'">
						<xsl:choose>
							<xsl:when test="$level = 2">
								<xsl:attribute name="background-color">rgb(229,229,229)</xsl:attribute>
								<xsl:attribute name="padding-top">2mm</xsl:attribute>
								<xsl:attribute name="padding-bottom">2mm</xsl:attribute>
							</xsl:when>
							<xsl:when test="$level = 3">
								<xsl:attribute name="background-color">rgb(204,204,204)</xsl:attribute>
							</xsl:when>
						</xsl:choose>
					</xsl:if>
					
					<!-- if first and last childs are `add` ace-tag, then move start ace-tag before title -->
					<xsl:if test="mn:tab[1]/following-sibling::node()[last()][self::mn:add][starts-with(text(), $ace_tag)]">
						<xsl:apply-templates select="mn:tab[1]/following-sibling::node()[1][self::mn:add][starts-with(text(), $ace_tag)]">
							<xsl:with-param name="skip">false</xsl:with-param>
						</xsl:apply-templates> 
					</xsl:if>
					
					<xsl:variable name="section">
						<xsl:call-template name="extractSection"/>
					</xsl:variable>
					<xsl:if test="normalize-space($section) != ''">
						<xsl:choose>
							<xsl:when test="$vertical_layout_rotate_clause_numbers = 'true'">
								<xsl:call-template name="insertVerticalChar">
									<xsl:with-param name="str" select="$section"/>
								</xsl:call-template>
								<fo:inline padding-right="4mm">&#xa0;</fo:inline>
							</xsl:when>
							<xsl:otherwise>
								<fo:inline> <!--  font-family="Noto Sans Condensed" font-weight="bold" -->
									<xsl:value-of select="$section"/>
									<fo:inline padding-right="4mm">&#xa0;</fo:inline>
								</fo:inline>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
					
					<xsl:call-template name="extractTitle"/>
					
					<xsl:apply-templates select="following-sibling::*[1][self::mn:variant-title][@type = 'sub']" mode="subtitle"/>
					<xsl:choose>
						<xsl:when test="$doctype = 'technical-report' and $level = 1">
							<fo:block margin-top="-3mm" margin-bottom="-1.5mm"><fo:leader leader-pattern="rule" rule-style="double" rule-thickness="1.5pt" leader-length="100%"/></fo:block>
						</xsl:when>
						<xsl:when test="ancestor::mn:annex and $level = 1">
							<fo:block margin-top="-3mm"><fo:leader leader-pattern="rule" rule-thickness="2.5pt" leader-length="100%"/></fo:block>
							<fo:block>&#xa0;</fo:block>
						</xsl:when>
					</xsl:choose>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="mn:sections/mn:page_sequence//mn:clause" priority="20">
		<fo:block keep-with-next="always">
			<fo:block id="{@id}" />
		</fo:block>
		<xsl:apply-templates/>
	</xsl:template>
	
	<!-- indent for clause level 4 and more -->
	<xsl:template match="mn:sections/mn:page_sequence//mn:clause[mn:title[@depth &gt;= 4]]" priority="20">
		<fo:block keep-with-next="always">
			<fo:block id="{@id}" />
		</fo:block>
		<xsl:apply-templates select="mn:title"/>
		<fo:block-container margin-left="6mm">
			<fo:block-container margin-left="0">
				<fo:block>
					<xsl:apply-templates select="*[not(self::mn:title)]"/>
				</fo:block>
			</fo:block-container>
		</fo:block-container>
	</xsl:template>

	<xsl:template match="mn:sections/mn:page_sequence/mn:clause" priority="21">
		<fo:block-container keep-with-next="always">
			<fo:block>
				<fo:block id="{@id}" />
			</fo:block>
		</fo:block-container>
		<xsl:apply-templates/>
	</xsl:template>
	

	<xsl:template match="mn:annex" priority="2">
		<fo:block id="{@id}">
		</fo:block>
		<xsl:apply-templates />
	</xsl:template>
	
	
	<xsl:variable name="text_indent">3</xsl:variable>
	
	<xsl:template match="mn:p" name="paragraph">
		<xsl:param name="inline-header">false</xsl:param>
		<xsl:param name="split_keep-within-line"/>
		
		<xsl:choose>
		
			<xsl:when test="preceding-sibling::*[1][self::mn:title]/@inline-header = 'true' and $inline-header = 'false'"/> <!-- paragraph displayed in title template -->
			
			<xsl:otherwise>
			
				<xsl:variable name="previous-element" select="local-name(preceding-sibling::*[1])"/>
				<xsl:variable name="element-name">
					<xsl:choose>
						<xsl:when test="ancestor::mn:figure and parent::mn:note[not(@type = 'units')]">fo:inline</xsl:when>
						<xsl:otherwise>fo:block</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				
				<xsl:element name="{$element-name}">
					<xsl:call-template name="setBlockAttributes">
						<xsl:with-param name="text_align_default">justify</xsl:with-param>
					</xsl:call-template>
					<xsl:attribute name="margin-bottom">10pt</xsl:attribute>
					<xsl:if test="$doctype = 'technical-report'">
						<xsl:attribute name="margin-bottom">18pt</xsl:attribute>
					</xsl:if>
					
					<!--
					<xsl:if test="not(parent::mn:note or parent::mn:li or ancestor::mn:table)">
						<xsl:attribute name="text-indent"><xsl:value-of select="$text_indent"/>mm</xsl:attribute>
					</xsl:if>
					-->
					
					<xsl:copy-of select="@id"/>
					
					<xsl:if test="$doctype = 'technical-report'">
						<xsl:attribute name="line-height">1.8</xsl:attribute>
					</xsl:if>
					
					<!-- bookmarks only in paragraph -->
					<xsl:if test="count(mn:bookmark) != 0 and count(*) = count(mn:bookmark) and normalize-space() = ''">
						<xsl:attribute name="font-size">0</xsl:attribute>
						<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
						<xsl:attribute name="line-height">0</xsl:attribute>
					</xsl:if>

					<xsl:if test="ancestor::*[@key = 'true']">
						<xsl:attribute name="margin-bottom">2pt</xsl:attribute>
					</xsl:if>
					
					<xsl:if test="parent::mn:definition">
						<xsl:attribute name="margin-bottom">2pt</xsl:attribute>
					</xsl:if>
					
					<xsl:if test="parent::mn:li or parent::mn:quote">
						<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
					</xsl:if>
					
					<xsl:if test="parent::mn:li and following-sibling::*[1][self::mn:ol or self::mn:ul or self::mn:note or self::mn:example]">
						<xsl:attribute name="margin-bottom">4pt</xsl:attribute>
					</xsl:if>
					
					<xsl:if test="ancestor::mn:td or ancestor::mn:th">
						<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
					</xsl:if>
					
					<xsl:if test="parent::mn:dd">
						<xsl:attribute name="margin-bottom">5pt</xsl:attribute>
					</xsl:if>
					
					<xsl:if test="parent::mn:dd and ancestor::mn:dl[@key = 'true'] and (ancestor::mn:tfoot or ancestor::mn:figure)">
						<xsl:attribute name="margin-bottom">2pt</xsl:attribute>
					</xsl:if>
					
					<xsl:if test="parent::mn:clause[@type = 'inner-cover-note'] or ancestor::mn:boilerplate">
						<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
					</xsl:if>
					
					<xsl:if test="parent::mn:note and not(following-sibling::*)">
						<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
					</xsl:if>
					
					<xsl:if test="(ancestor::*[local-name() = 'td' or local-name() = 'th']) and
											(.//*[local-name() = 'font_en' or local-name() = 'font_en_bold'])">
						<xsl:if test="$isGenerateTableIF = 'false'">
							<xsl:attribute name="language">en</xsl:attribute>
							<xsl:attribute name="hyphenate">true</xsl:attribute>
						</xsl:if>
					</xsl:if>
					
					<xsl:if test="ancestor::mn:note[@type = 'units']">
						<xsl:attribute name="text-align">right</xsl:attribute>
					</xsl:if>
					
					<!-- paragraph in table or figure footer -->
					<xsl:if test="parent::mn:table or parent::mn:figure or (ancestor::mn:tfoot and ancestor::mn:td[1]/@colspan and not(parent::mn:dd))">
						<xsl:attribute name="margin-left"><xsl:value-of select="$tableAnnotationIndent"/></xsl:attribute>
						<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
					</xsl:if>
					
					<xsl:if test="parent::mn:clause or (ancestor::mn:note and not(ancestor::mn:table))">
						<xsl:text>&#x3000;</xsl:text>
					</xsl:if>
					
					<xsl:apply-templates>
						<xsl:with-param name="split_keep-within-line" select="$split_keep-within-line"/>
					</xsl:apply-templates>
				</xsl:element>
				<!-- <xsl:if test="$element-name = 'fo:inline' and not(local-name(..) = 'admonition')">
					<fo:block margin-bottom="12pt">
						 <xsl:if test="ancestor::mn:annex or following-sibling::mn:table">
							<xsl:attribute name="margin-bottom">0</xsl:attribute>
						 </xsl:if>
						<xsl:value-of select="$linebreak"/>
					</fo:block>
				</xsl:if>-->
		
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<xsl:template match="mn:note[not(ancestor::mn:table)]" priority="2">
	
		<fo:block-container id="{@id}" xsl:use-attribute-sets="note-style" role="SKIP">
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			
			<xsl:call-template name="setBlockSpanAll"/>
			
			<xsl:call-template name="refine_note-style"/>
			
			<fo:block-container margin-left="0mm" margin-right="0mm" role="SKIP">
	
				<fo:table table-layout="fixed" width="99%" border="1pt solid black">
					<fo:table-body>
						<fo:table-row>
							<fo:table-cell padding="2mm">
								<fo:block keep-with-next="always" margin-bottom="10pt" role="SKIP">
									<xsl:apply-templates select="mn:name" />
								</fo:block>
								<fo:block>
									<xsl:apply-templates select="node()[not(self::mn:name)]" />
								</fo:block>
							</fo:table-cell>
						</fo:table-row>
					</fo:table-body>
				</fo:table>
			</fo:block-container>
		</fo:block-container>
	</xsl:template>
	
	<xsl:template match="mn:figure/mn:note[not(@type = 'units')]" priority="3"/>
	
	<xsl:template match="mn:note[not(ancestor::mn:table)]/mn:p" priority="2">
		<xsl:call-template name="paragraph"/>
	</xsl:template>
	
	
	<xsl:template match="mn:termnote" priority="2">
		<fo:block id="{@id}" xsl:use-attribute-sets="termnote-style">
			<fo:list-block provisional-distance-between-starts="{14 + $text_indent}mm">
				<fo:list-item>
					<fo:list-item-label start-indent="{$text_indent}mm" end-indent="label-end()">
						<fo:block xsl:use-attribute-sets="note-name-style">
							<xsl:apply-templates select="mn:name" />
						</fo:block>
					</fo:list-item-label>
					<fo:list-item-body start-indent="body-start()">
						<fo:block>
							<xsl:apply-templates select="node()[not(self::mn:name)]" />
						</fo:block>
					</fo:list-item-body>
				</fo:list-item>
			</fo:list-block>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="mn:li" priority="2">
		<fo:list-item xsl:use-attribute-sets="list-item-style">
			<xsl:copy-of select="@id"/>
			
			<xsl:call-template name="refine_list-item-style"/>
			
			<fo:list-item-label end-indent="label-end()">
				<fo:block xsl:use-attribute-sets="list-item-label-style">
				
					<xsl:call-template name="refine_list-item-label-style"/>
					
					<xsl:if test="$doctype = 'technical-report'">
						<xsl:attribute name="line-height">1.8</xsl:attribute>
					</xsl:if>
					
					<xsl:variable name="list_item_label">
						<xsl:call-template name="getListItemFormat" />
					</xsl:variable>
					
					<!-- <xsl:attribute name="line-height">2</xsl:attribute> -->
					
					<!-- if 'p' contains all text in 'add' first and last elements in first p are 'add' -->
					<xsl:if test="*[1][count(node()[normalize-space() != '']) = 1 and mn:add]">
						<xsl:call-template name="append_add-style"/>
					</xsl:if>
					
					<xsl:choose>
						<xsl:when test="contains($list_item_label, ')')">
							<xsl:value-of select="substring-before($list_item_label,')')"/>
							<fo:inline font-weight="normal">)</fo:inline>
							<xsl:value-of select="substring-after($list_item_label,')')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<!-- <xsl:when test="parent::mn:ul and ancestor::mn:sections and $list_item_label = '・' and not(ancestor::mn:table)">
									<fo:inline>
										<fo:instream-foreign-object content-width="2.5mm" fox:alt-text="ul list label">
											<xsl:copy-of select="$list_label_black_circle"/>
										</fo:instream-foreign-object>
									</fo:inline>
								</xsl:when> -->
								<xsl:when test="parent::mn:ul and $list_item_label = '→'">
									<fo:inline>
										<fo:instream-foreign-object content-width="2.5mm" fox:alt-text="ul list label">
											<xsl:copy-of select="$list_label_arrow"/>
										</fo:instream-foreign-object>
									</fo:inline>
								</xsl:when>
								<xsl:when test="parent::mn:ul and $list_item_label = '☆'">
									<fo:inline>
										<fo:instream-foreign-object content-width="2.5mm" fox:alt-text="ul list label">
											<xsl:copy-of select="$list_label_star"/>
										</fo:instream-foreign-object>
									</fo:inline>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$list_item_label"/>
								</xsl:otherwise>
							</xsl:choose>
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
	<xsl:template match="mn:li/*[not(self::mn:ul) and not(self::mn:ol)][last()]" priority="3" mode="list_jis">
		<xsl:apply-templates select="."/>
		
		<xsl:variable name="list_id" select="ancestor::*[self::mn:ul or self::mn:ol][1]/@id"/>
		<!-- render footnotes after current list-item, if there aren't footnotes anymore in the list -->
		<!-- i.e. i.e. if list-item is latest with footnote -->
		<xsl:if test="ancestor::mn:li[1]//mn:fn[ancestor::*[self::mn:ul or self::mn:ol][1][@id = $list_id]] and
		not(ancestor::mn:li[1]/following-sibling::mn:li[.//mn:fn[ancestor::*[self::mn:ul or self::mn:ol][1][@id = $list_id]]])">
			<xsl:apply-templates select="ancestor::*[self::mn:ul or self::mn:ol][1]//mn:fn[ancestor::*[self::mn:ul or self::mn:ol][1][@id = $list_id]][generate-id(.)=generate-id(key('kfn',@reference)[1])]" mode="fn_after_element">
				<xsl:with-param name="ancestor">li</xsl:with-param>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="mn:fn" mode="fn_after_element">
		<xsl:param name="ancestor">li</xsl:param>
		
		<xsl:variable name="ancestor_tree_">
			<xsl:for-each select="ancestor::*[not(self::mn:p) and not(self::mn:bibitem) and not(self::mn:biblio-tag)]">
				<item><xsl:value-of select="local-name()"/></item>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="ancestor_tree" select="xalan:nodeset($ancestor_tree_)"/>
		<!-- <debug><xsl:copy-of select="$ancestor_tree"/></debug>
		<debug><ancestor><xsl:value-of select="$ancestor"/></ancestor></debug> -->
		
		
		<xsl:variable name="ref_id" select="@target"/>
		
		<xsl:if test="$ancestor_tree//item[last()][. = $ancestor]">
			<fo:block-container margin-left="11mm" margin-bottom="4pt" id="{$ref_id}">
				
				<xsl:if test="position() = last()">
					<xsl:attribute name="margin-bottom">10pt</xsl:attribute>
				</xsl:if>
				<fo:block-container margin-left="0mm">
					<fo:list-block provisional-distance-between-starts="10mm">
						<fo:list-item>
							<fo:list-item-label end-indent="label-end()">
								<xsl:variable name="current_fn_number" select="translate(normalize-space(mn:fmt-fn-label), ')', '')"/>
								<fo:block xsl:use-attribute-sets="note-name-style">注 <fo:inline xsl:use-attribute-sets="fn-num-style"><xsl:value-of select="$current_fn_number"/><fo:inline font-weight="normal">)</fo:inline></fo:inline></fo:block>
							</fo:list-item-label>
							<fo:list-item-body start-indent="body-start()">
								<fo:block>
									<!-- <xsl:apply-templates /> -->
									<xsl:apply-templates select="$footnotes/mn:fmt-fn-body[@id = $ref_id]"/>
								</fo:block>
							</fo:list-item-body>
						</fo:list-item>
					</fo:list-block>
				</fo:block-container>
			</fo:block-container>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="mn:span[@class = 'surname' or @class = 'givenname' or @class = 'JIS' or @class = 'EffectiveYear' or @class = 'CommentaryEffectiveYear']" mode="update_xml_step1" priority="2">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()" mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="mn:span[@style = 'font-family:&quot;MS Gothic&quot;']" mode="update_xml_step1" priority="3">
		<xsl:copy>
			<xsl:copy-of select="@*[not(name() = 'style')]"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="@*|node()" mode="update_xml_pres">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="update_xml_pres"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- remove semantic xml -->
	<xsl:template match="mn:metanorma-extension/mn:metanorma/mn:source" mode="update_xml_pres"/>
	<!-- remove image/emf -->
	<xsl:template match="mn:image/mn:emf" mode="update_xml_pres"/>
	<xsl:template match="mn:preprocess-xslt" mode="update_xml_pres"/>
	<xsl:template match="mn:stem" mode="update_xml_pres"/>
	
	<xsl:template match="mn:span[
															@class = 'fmt-caption-label' or 
															@class = 'fmt-element-name' or
															@class = 'fmt-caption-delim' or
															@class = 'fmt-autonum-delim']" mode="update_xml_pres" priority="3">
		<xsl:apply-templates mode="update_xml_pres"/>
	</xsl:template>
	
	<xsl:template match="mn:semx" mode="update_xml_pres">
		<xsl:apply-templates mode="update_xml_pres"/>
	</xsl:template>
	
	<xsl:template match="mn:fmt-xref-label" mode="update_xml_pres"/>
	<xsl:template match="mn:erefstack" mode="update_xml_pres"/>
	
	<xsl:template match="mn:ul//mn:fn | mn:ol//mn:fn" mode="update_xml_pres">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="update_xml_pres"/>
			<!-- for output footnote after the 'li' -->
			<xsl:attribute name="skip_footnote_body">true</xsl:attribute>
			<xsl:apply-templates select="node()" mode="update_xml_pres"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- remove Annex and (normative) -->
	<!-- <xsl:template match="mn:annex/mn:title" mode="update_xml_step1" priority="3">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="*[local-name() = 'br'][2]/following-sibling::node()" mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template> -->
	
	<xsl:template match="mn:clause[@type = 'contributors']//mn:table//mn:span[@class = 'surname']/text()[string-length() &lt; 3]" priority="2">
		<xsl:choose>
			<xsl:when test="string-length() = 1">
				<xsl:value-of select="concat(.,'&#x3000;&#x3000;')"/>
			</xsl:when>
			<xsl:when test="string-length() = 2">
				<xsl:value-of select="concat(substring(.,1,1), '&#x3000;', substring(., 2))"/>
			</xsl:when>
		</xsl:choose>
		<xsl:if test="../following-sibling::node()[1][self::mn:span and @class = 'surname']"> <!-- if no space between surname and given name -->
			<xsl:text>&#x3000;</xsl:text>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="mn:clause[@type = 'contributors']//mn:table//mn:span[@class = 'givenname']/text()[string-length() &lt; 3]" priority="2">
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
	<!-- and following-sibling::node()[1][self::mn:span and @class = 'givenname'] -->
	<xsl:template match="mn:clause[@type = 'contributors']//mn:table//node()[preceding-sibling::node()[1][self::mn:span and @class = 'surname']][. = ' ']" priority="2">
		<xsl:text>&#x3000;</xsl:text>
	</xsl:template>
	
	<xsl:template name="makePagedXML">
		<xsl:param name="structured_xml"/>
		<xsl:choose>
			<xsl:when test="not(xalan:nodeset($structured_xml)/mn:pagebreak)">
				<xsl:element name="page" namespace="{$namespace_full}">
					<xsl:copy-of select="xalan:nodeset($structured_xml)"/>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="xalan:nodeset($structured_xml)/mn:pagebreak">
			
					<xsl:variable name="pagebreak_id" select="generate-id()"/>
					
					<!-- copy elements before pagebreak -->
					<xsl:element name="page" namespace="{$namespace_full}">
						<xsl:if test="not(preceding-sibling::mn:pagebreak)">
							<xsl:copy-of select="../@*" />
						</xsl:if>
						<!-- copy previous pagebreak orientation -->
						<xsl:copy-of select="preceding-sibling::mn:pagebreak[1]/@orientation"/>
					
						<xsl:copy-of select="preceding-sibling::node()[following-sibling::mn:pagebreak[1][generate-id(.) = $pagebreak_id]][not(self::mn:pagebreak)]" />
					</xsl:element>
					
					<!-- copy elements after last page break -->
					<xsl:if test="position() = last() and following-sibling::node()">
						<xsl:element name="page" namespace="{$namespace_full}">
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
	
	<!-- <xsl:variable name="regex_en">([^\u2160-\u2188\u25A0-\u25E5\u2F00-\u2FD5\u3000-\u9FFF\uF900-\uFFFF]{1,})</xsl:variable> -->
	<xsl:variable name="regex_en">([^\u2160-\uFFFF]{1,})</xsl:variable>
	
	<xsl:variable name="element_name_font_en">font_en</xsl:variable>
	<xsl:variable name="tag_font_en_open">###<xsl:value-of select="$element_name_font_en"/>###</xsl:variable>
	<xsl:variable name="tag_font_en_close">###/<xsl:value-of select="$element_name_font_en"/>###</xsl:variable>
	<xsl:variable name="element_name_font_en_bold">font_en_bold</xsl:variable>
	<xsl:variable name="tag_font_en_bold_open">###<xsl:value-of select="$element_name_font_en_bold"/>###</xsl:variable>
	<xsl:variable name="tag_font_en_bold_close">###/<xsl:value-of select="$element_name_font_en_bold"/>###</xsl:variable>
	
	<xsl:template match="mn:p//text()[not(ancestor::mn:strong) and not(ancestor::mn:stem)] |
						mn:dt/text() | mn:td/text() | mn:th/text()" mode="update_xml_step1">
		<!-- add hairspace after 'IDEOGRAPHIC SPACE' (U+3000) -->
		<xsl:variable name="text" select="java:replaceAll(java:java.lang.String.new(.), '(\u3000)', concat('$1',$hair_space))"/>
		<xsl:variable name="text_en__">
			<xsl:choose>
				<xsl:when test="ancestor::mn:td or ancestor::mn:th">
					<xsl:value-of select="java:replaceAll(java:java.lang.String.new($text), '([a-z]{2,})([A-Z]+)', concat('$1',$zero_width_space,'$2'))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$text"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!-- <xsl:if test="ancestor::*[local-name() = 'td' or local-name() = 'th']">table cell </xsl:if> -->
		<xsl:variable name="text_en_" select="java:replaceAll(java:java.lang.String.new($text_en__), $regex_en, concat($tag_font_en_open,'$1',$tag_font_en_close))"/>
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
	
	<!-- mn:term/mn:preferred2//text() | -->
	
	<!-- <name>注記  1</name> to <name>注記<font_en>  1</font_en></name> -->
	<xsl:template match="mn:title/text() | mn:fmt-title/text() | 
						mn:note/mn:name/text() | mn:note/mn:fmt-name/text() | 
						mn:termnote/mn:name/text() | mn:termnote/mn:fmt-name/text() |
						mn:table/mn:name/text() | mn:table/mn:fmt-name/text() |
						mn:figure/mn:name/text() | mn:figure/mn:fmt-name/text() |
						mn:termexample/mn:name/text() | mn:termexample/mn:fmt-name/text() |
						mn:xref//text() | mn:fmt-xref//text() |
						mn:origin/text() | mn:fmt-origin/text()" mode="update_xml_step1">
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
	<xsl:template match="mnx:title/text()">
		<xsl:variable name="regex_en_contents">([^\u3000-\u9FFF\uF900-\uFFFF\(\)]{1,})</xsl:variable>
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
	<!-- Example:
		<example id="_7569d639-c245-acb6-2141-3b746374a9e1" autonum="1">
		<name id="_8eac959b-b129-4892-b8bb-fcca2914bd39">（可能性の例）</name>
		<fmt-name>
			<span class="fmt-caption-label">
				<span class="fmt-element-name">例</span>
				<semx element="autonum" source="_7569d639-c245-acb6-2141-3b746374a9e1">1</semx>
			</span>
			<span class="fmt-caption-delim"> — </span>
			<semx element="name" source="_8eac959b-b129-4892-b8bb-fcca2914bd39">（可能性の例）</semx>
		</fmt-name>
	-->
	<!-- <xsl:template match="mn:example[contains(mn:name/text(), ' — ')]" mode="update_xml_step1"> -->
	<xsl:template match="mn:example[mn:fmt-name[contains(mn:span/text(), ' — ')]]" mode="update_xml_step1">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:element name="p" namespace="{$namespace_full}">
				<!-- <xsl:value-of select="substring-after(mn:name/text(), ' — ')"/> -->
				<xsl:apply-templates select="mn:fmt-name/mn:span[contains(., ' — ')][1]/following-sibling::node()" mode="update_xml_step1"/>
			</xsl:element>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="mn:example/mn:fmt-name[contains(mn:span/text(), ' — ')]" mode="update_xml_step1" priority="2">
		<xsl:element name="name" namespace="{$namespace_full}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="*[1]" mode="update_xml_step1"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="mn:example/mn:name/text()" mode="update_xml_step1">
		<xsl:variable name="example_name" select="."/>
		<!-- 
			<xsl:choose>
				<xsl:when test="contains(., ' — ')"><xsl:value-of select="substring-before(., ' — ')"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable> -->
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
	
	<xsl:template match="mn:eref//text()" mode="update_xml_step1">
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
	
	<xsl:template match="mn:strong" priority="2" mode="update_xml_step1">
		<xsl:apply-templates mode="update_xml_step1"/>
	</xsl:template>
	<xsl:template match="mn:strong/text()" priority="2" mode="update_xml_step1">
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
	
	<!-- Key title after the table -->
	<!-- <xsl:template match="mn:table/mn:p[@class = 'ListTitle']" priority="2" mode="update_xml_step1"/> -->
  
	<xsl:template match="*[local-name() = 'font_en_bold'][normalize-space() != '']">
		<xsl:if test="ancestor::*[local-name() = 'td' or local-name() = 'th']">
			<xsl:choose>
				<xsl:when test="$isGenerateTableIF = 'false'"><fo:inline font-size="0.1pt"><xsl:text> </xsl:text></fo:inline></xsl:when>
				<xsl:otherwise><fo:inline><xsl:value-of select="$zero_width_space"/></fo:inline></xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		<fo:inline font-family="Noto Sans Condensed" font-weight="300"> <!--  font-weight="bold" -->
			<!-- <xsl:if test="ancestor::mn:preferred">
				<xsl:attribute name="font-weight">normal</xsl:attribute>
			</xsl:if> -->
			<xsl:if test="(ancestor::mn:figure or ancestor::mn:table) and parent::mn:name">
				<xsl:attribute name="font-weight">bold</xsl:attribute>
				<xsl:if test="$doctype = 'technical-report'">
					<xsl:attribute name="font-weight">normal</xsl:attribute>
				</xsl:if>
			</xsl:if>
			
			<xsl:if test="ancestor::mn:annex and ancestor::mn:title and not(ancestor::mn:clause)">
				<xsl:attribute name="font-family">inherit</xsl:attribute>
				<xsl:attribute name="font-weight">bold</xsl:attribute>
			</xsl:if>
			
			<xsl:apply-templates/>
		</fo:inline>
		<xsl:if test="ancestor::*[local-name() = 'td' or local-name() = 'th']">
			<xsl:choose>
				<xsl:when test="$isGenerateTableIF = 'false'"><fo:inline font-size="0.1pt"><xsl:text> </xsl:text></fo:inline></xsl:when>
				<xsl:otherwise><fo:inline><xsl:value-of select="$zero_width_space"/></fo:inline></xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'font_en'][normalize-space() != '']">
		<xsl:if test="ancestor::*[local-name() = 'td' or local-name() = 'th']">
			<xsl:choose>
				<xsl:when test="$isGenerateTableIF = 'false'"><fo:inline font-size="0.1pt"><xsl:text> </xsl:text></fo:inline></xsl:when>
				<xsl:otherwise><fo:inline><xsl:value-of select="$zero_width_space"/></fo:inline></xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		<fo:inline>
			<xsl:if test="not(ancestor::mn:p[@class = 'zzSTDTitle2']) and not(ancestor::mn:span[@class = 'JIS'])">
				<xsl:attribute name="font-family">Noto Sans Condensed</xsl:attribute>
				<xsl:attribute name="font-weight">300</xsl:attribute>
			</xsl:if>
			<xsl:if test="ancestor::mn:preferred">
				<xsl:attribute name="font-weight">normal</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</fo:inline>
		<xsl:if test="ancestor::*[local-name() = 'td' or local-name() = 'th']">
			<xsl:choose>
				<xsl:when test="$isGenerateTableIF = 'false'"><fo:inline font-size="0.1pt"><xsl:text> </xsl:text></fo:inline></xsl:when>
				<xsl:otherwise><fo:inline><xsl:value-of select="$zero_width_space"/></fo:inline></xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	
	<!-- ========================= -->
	<!-- END: Allocate non-Japanese text -->
	<!-- ========================= -->
	
	<!-- Table key -->
	
	<xsl:template match="mn:table/mn:p[@class = 'ListTitle'] | mn:figure/mn:p[@keep-with-next = 'true']" priority="2">
		<fo:block>
			<xsl:copy-of select="@id"/>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:variable name="tableAnnotationIndent">3mm</xsl:variable>
	
	<xsl:template match="mn:table/mn:p[@class = 'dl'] | mn:figure/mn:p[@class = 'dl']" priority="2">
		<fo:block-container margin-left="{$tableAnnotationIndent}"> <!-- 90mm -->
			<xsl:if test="not(following-sibling::*[1][self::mn:p[@class = 'dl']])"> <!-- last dl -->
				<xsl:attribute name="margin-bottom">2pt</xsl:attribute>
			</xsl:if>
			<fo:block-container margin-left="0mm">
				<fo:block>
					<xsl:if test="parent::mn:table">
						<xsl:attribute name="font-size">10pt</xsl:attribute>
					</xsl:if>
					<xsl:copy-of select="@id"/>
					<xsl:apply-templates/>
				</fo:block>
			</fo:block-container>
		</fo:block-container>
	</xsl:template>
	
	<!-- =================== -->
	<!-- Index processing -->
	<!-- =================== -->
	<xsl:template match="mn:indexsect">
		<fo:block id="{@id}" span="all">
			<xsl:apply-templates select="mn:title"/>
		</fo:block>
		<fo:block role="Index">
			<xsl:apply-templates select="*[not(self::mn:title)]"/>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="mn:xref[@pagenumber = 'true']"  priority="2">
		<xsl:call-template name="insert_basic_link">
			<xsl:with-param name="element">
				<fo:basic-link internal-destination="{@target}" fox:alt-text="{@target}" xsl:use-attribute-sets="xref-style">
					<fo:inline>
						<xsl:if test="@id">
							<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
						</xsl:if>
						<fo:page-number-citation ref-id="{@target}"/>
					</fo:inline>
				</fo:basic-link>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!-- =================== -->
	<!-- End of Index processing -->
	<!-- =================== -->
	
	<xsl:template name="insertHeaderFooter">
		<xsl:call-template name="insertHeader"/>
		<fo:static-content flow-name="footer">
			<xsl:choose>
				<xsl:when test="$doctype = 'technical-report'">
					<fo:block-container height="23mm" display-align="after">
						<fo:block text-align="center" margin-bottom="16mm">
							<xsl:if test="$vertical_layout = 'true'">
								<xsl:attribute name="margin-bottom">0mm</xsl:attribute>
							</xsl:if>
							<xsl:text>- </xsl:text>
							<fo:page-number />
							<xsl:text> -</xsl:text>
						</fo:block>
					</fo:block-container>
				</xsl:when>
				<xsl:otherwise>
					<fo:block-container height="24mm" display-align="after">
						<fo:block text-align="center" margin-bottom="16mm">
							<xsl:if test="$vertical_layout = 'true'">
								<xsl:attribute name="margin-bottom">0mm</xsl:attribute>
							</xsl:if>
							<fo:page-number />
						</fo:block>
					</fo:block-container>
				</xsl:otherwise>
			</xsl:choose>
		</fo:static-content>
	</xsl:template>
	
	<xsl:template name="insertHeader">
		<xsl:if test="$doctype = 'technical-report'">
			<fo:static-content flow-name="header">
				<fo:block-container height="19.5mm" display-align="after">
					<fo:block>
						<xsl:value-of select="$page_header"/>
					</fo:block>
				</fo:block-container>
			</fo:static-content>
		</xsl:if>
	</xsl:template>
	
	
	<xsl:variable name="PLATEAU-Logo">
		<svg id="Layer_1" data-name="Layer 1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 141.72 172.64">
			<defs>
				<style>
					.cls-1 {
						fill: #0c0103;
						fill-rule: evenodd;
						stroke-width: 0px;
					}
				</style>
			</defs>
			<polygon class="cls-1" points="27.54 25.75 60.03 44.51 69.57 50.02 79.53 55.77 91.88 62.9 96.85 65.77 114.18 75.78 114.18 124.32 27.54 74.29 27.54 25.75"/>
			<polygon class="cls-1" points="69.57 0 69.57 47.05 59.39 41.17 28.83 23.52 69.57 0"/>
			<polygon class="cls-1" points="72.15 0 112.9 23.52 91.88 35.66 91.88 59.93 80.04 53.09 72.15 48.53 72.15 0"/>
			<polygon class="cls-1" points="114.18 25.75 114.18 72.8 98.4 63.69 94.45 61.41 94.45 37.14 114.18 25.75"/>
			<polygon class="cls-1" points="0 137.06 2.97 137.06 3.84 137.14 3.84 139.1 2.97 138.96 2.06 138.96 2.06 143.16 2.99 143.16 3.84 142.91 3.84 144.96 2.99 145.06 2.06 145.06 2.06 150.53 0 150.53 0 137.06"/>
			<path class="cls-1" d="m3.84,137.14l.55.05c.51.1,1.04.28,1.53.6,1.13.75,1.68,2.04,1.68,3.27,0,.79-.2,2-1.31,2.95-.54.46-1.11.72-1.68.87l-.77.08v-2.05l1.13-.34c.43-.37.65-.9.65-1.53,0-.56-.17-1.45-1.24-1.86l-.53-.08v-1.96Z"/>
			<polygon class="cls-1" points="21.93 137.06 23.99 137.06 23.99 148.59 27.95 148.59 27.95 150.53 21.93 150.53 21.93 137.06"/>
			<polygon class="cls-1" points="47.63 136.54 47.63 140.87 45.59 145.34 47.63 145.34 47.63 147.28 44.74 147.28 43.27 150.53 41.05 150.53 47.63 136.54"/>
			<polygon class="cls-1" points="47.75 136.28 54.13 150.53 51.91 150.53 50.5 147.28 47.63 147.28 47.63 145.34 49.67 145.34 47.67 140.78 47.63 140.87 47.63 136.54 47.75 136.28"/>
			<polygon class="cls-1" points="65.99 137.07 74.22 137.07 74.22 139 71.13 139 71.13 150.53 69.07 150.53 69.07 139 65.99 139 65.99 137.07"/>
			<polygon class="cls-1" points="88.4 137.07 95.83 137.07 95.83 139 90.46 139 90.46 142.42 95.67 142.42 95.67 144.35 90.46 144.35 90.46 148.59 95.83 148.59 95.83 150.53 88.4 150.53 88.4 137.07"/>
			<polygon class="cls-1" points="114.26 136.53 114.26 140.87 112.23 145.34 114.26 145.34 114.26 147.28 111.38 147.28 109.9 150.53 107.68 150.53 114.26 136.53"/>
			<polygon class="cls-1" points="114.38 136.28 120.77 150.53 118.54 150.53 117.13 147.28 114.26 147.28 114.26 145.34 116.3 145.34 114.3 140.78 114.26 140.87 114.26 136.53 114.38 136.28"/>
			<path class="cls-1" d="m131.75,137.06h2.06v8.12c0,.73.02,1.62.42,2.32.41.69,1.32,1.4,2.51,1.4s2.1-.71,2.5-1.4c.4-.7.42-1.59.42-2.32v-8.12h2.06v8.67c0,1.07-.22,2.36-1.25,3.49-.7.77-1.9,1.58-3.73,1.58s-3.03-.81-3.74-1.58c-1.03-1.13-1.25-2.42-1.25-3.49v-8.67Z"/>
			<path class="cls-1" d="m37.65,161.31h1.7v3.94c.22-.29.48-.48.77-.6l.46-.09v1.39l-.96.39c-.2.21-.37.52-.37.97s.19.75.39.94l.94.38v1.37l-.65-.16c-.26-.15-.45-.36-.58-.55v.64h-1.7v-8.62Z"/>
			<path class="cls-1" d="m40.99,164.48c.73,0,1.38.27,1.84.71.51.49.82,1.21.82,2.08,0,.82-.28,1.57-.82,2.12-.46.47-1.03.72-1.81.72l-.44-.11v-1.37h.02c.3,0,.63-.11.89-.35.25-.24.42-.58.42-.97,0-.43-.17-.77-.42-1.01-.27-.26-.57-.35-.91-.35v-1.39l.41-.08Z"/>
			<polygon class="cls-1" points="47.39 164.66 49.35 164.66 50.84 167.52 52.3 164.66 54.21 164.66 49.97 172.64 48.05 172.64 49.91 169.26 47.39 164.66"/>
			<polygon class="cls-1" points="66.6 162.05 68.11 162.05 70.07 166.76 72.03 162.05 73.55 162.05 74.81 169.93 72.99 169.93 72.36 165.23 70.39 169.93 69.75 169.93 67.78 165.23 67.15 169.93 65.33 169.93 66.6 162.05"/>
			<polygon class="cls-1" points="80.9 162.05 82.72 162.05 82.72 168.39 85.16 168.39 85.16 169.93 80.9 169.93 80.9 162.05"/>
			<polyline class="cls-1" points="91.43 162.05 93.25 162.05 93.25 169.93 91.43 169.93 91.43 162.05"/>
			<polygon class="cls-1" points="99.44 162.05 104.69 162.05 104.69 163.58 102.98 163.58 102.98 169.93 101.16 169.93 101.16 163.58 99.44 163.58 99.44 162.05"/>
		</svg>
	</xsl:variable>
  
	<xsl:variable name="PLATEAU-Logo-inverted">
		<svg id="Layer_1" data-name="Layer 1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 141.72 172.64">
			<defs>
				<style>
					.cls-1 {
						fill: #ffffff;
						fill-rule: evenodd;
						stroke-width: 0px;
					}
				</style>
			</defs>
			<rect width="100%" height="100%" fill="black"/>
			<polygon class="cls-1" points="27.54 25.75 60.03 44.51 69.57 50.02 79.53 55.77 91.88 62.9 96.85 65.77 114.18 75.78 114.18 124.32 27.54 74.29 27.54 25.75"/>
			<polygon class="cls-1" points="69.57 0 69.57 47.05 59.39 41.17 28.83 23.52 69.57 0"/>
			<polygon class="cls-1" points="72.15 0 112.9 23.52 91.88 35.66 91.88 59.93 80.04 53.09 72.15 48.53 72.15 0"/>
			<polygon class="cls-1" points="114.18 25.75 114.18 72.8 98.4 63.69 94.45 61.41 94.45 37.14 114.18 25.75"/>
			<polygon class="cls-1" points="0 137.06 2.97 137.06 3.84 137.14 3.84 139.1 2.97 138.96 2.06 138.96 2.06 143.16 2.99 143.16 3.84 142.91 3.84 144.96 2.99 145.06 2.06 145.06 2.06 150.53 0 150.53 0 137.06"/>
			<path class="cls-1" d="m3.84,137.14l.55.05c.51.1,1.04.28,1.53.6,1.13.75,1.68,2.04,1.68,3.27,0,.79-.2,2-1.31,2.95-.54.46-1.11.72-1.68.87l-.77.08v-2.05l1.13-.34c.43-.37.65-.9.65-1.53,0-.56-.17-1.45-1.24-1.86l-.53-.08v-1.96Z"/>
			<polygon class="cls-1" points="21.93 137.06 23.99 137.06 23.99 148.59 27.95 148.59 27.95 150.53 21.93 150.53 21.93 137.06"/>
			<polygon class="cls-1" points="47.63 136.54 47.63 140.87 45.59 145.34 47.63 145.34 47.63 147.28 44.74 147.28 43.27 150.53 41.05 150.53 47.63 136.54"/>
			<polygon class="cls-1" points="47.75 136.28 54.13 150.53 51.91 150.53 50.5 147.28 47.63 147.28 47.63 145.34 49.67 145.34 47.67 140.78 47.63 140.87 47.63 136.54 47.75 136.28"/>
			<polygon class="cls-1" points="65.99 137.07 74.22 137.07 74.22 139 71.13 139 71.13 150.53 69.07 150.53 69.07 139 65.99 139 65.99 137.07"/>
			<polygon class="cls-1" points="88.4 137.07 95.83 137.07 95.83 139 90.46 139 90.46 142.42 95.67 142.42 95.67 144.35 90.46 144.35 90.46 148.59 95.83 148.59 95.83 150.53 88.4 150.53 88.4 137.07"/>
			<polygon class="cls-1" points="114.26 136.53 114.26 140.87 112.23 145.34 114.26 145.34 114.26 147.28 111.38 147.28 109.9 150.53 107.68 150.53 114.26 136.53"/>
			<polygon class="cls-1" points="114.38 136.28 120.77 150.53 118.54 150.53 117.13 147.28 114.26 147.28 114.26 145.34 116.3 145.34 114.3 140.78 114.26 140.87 114.26 136.53 114.38 136.28"/>
			<path class="cls-1" d="m131.75,137.06h2.06v8.12c0,.73.02,1.62.42,2.32.41.69,1.32,1.4,2.51,1.4s2.1-.71,2.5-1.4c.4-.7.42-1.59.42-2.32v-8.12h2.06v8.67c0,1.07-.22,2.36-1.25,3.49-.7.77-1.9,1.58-3.73,1.58s-3.03-.81-3.74-1.58c-1.03-1.13-1.25-2.42-1.25-3.49v-8.67Z"/>
			<path class="cls-1" d="m37.65,161.31h1.7v3.94c.22-.29.48-.48.77-.6l.46-.09v1.39l-.96.39c-.2.21-.37.52-.37.97s.19.75.39.94l.94.38v1.37l-.65-.16c-.26-.15-.45-.36-.58-.55v.64h-1.7v-8.62Z"/>
			<path class="cls-1" d="m40.99,164.48c.73,0,1.38.27,1.84.71.51.49.82,1.21.82,2.08,0,.82-.28,1.57-.82,2.12-.46.47-1.03.72-1.81.72l-.44-.11v-1.37h.02c.3,0,.63-.11.89-.35.25-.24.42-.58.42-.97,0-.43-.17-.77-.42-1.01-.27-.26-.57-.35-.91-.35v-1.39l.41-.08Z"/>
			<polygon class="cls-1" points="47.39 164.66 49.35 164.66 50.84 167.52 52.3 164.66 54.21 164.66 49.97 172.64 48.05 172.64 49.91 169.26 47.39 164.66"/>
			<polygon class="cls-1" points="66.6 162.05 68.11 162.05 70.07 166.76 72.03 162.05 73.55 162.05 74.81 169.93 72.99 169.93 72.36 165.23 70.39 169.93 69.75 169.93 67.78 165.23 67.15 169.93 65.33 169.93 66.6 162.05"/>
			<polygon class="cls-1" points="80.9 162.05 82.72 162.05 82.72 168.39 85.16 168.39 85.16 169.93 80.9 169.93 80.9 162.05"/>
			<polyline class="cls-1" points="91.43 162.05 93.25 162.05 93.25 169.93 91.43 169.93 91.43 162.05"/>
			<polygon class="cls-1" points="99.44 162.05 104.69 162.05 104.69 163.58 102.98 163.58 102.98 169.93 101.16 169.93 101.16 163.58 99.44 163.58 99.44 162.05"/>
		</svg>
	</xsl:variable>
	
	<xsl:variable name="list_label_black_circle">
		<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 20 20">
			<circle cx="10" cy="10" r="5" stroke="black" stroke-width="5" fill="black"/>
		</svg>
	</xsl:variable>
	
	<xsl:variable name="list_label_arrow">
		<svg id="Layer_1" data-name="Layer 1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 7.51 8.67">
			<defs>
				<style>
					.cls-1 {
						fill: #231f20;
						stroke-width: 0px;
					}
				</style>
			</defs>
			<path class="cls-1" d="m2.51,4.34L0,0l7.51,4.34L0,8.67l2.51-4.34ZM.78.77l2.06,3.56h4.1L.78.77Z"/>
		</svg>
	</xsl:variable>
	
	<xsl:variable name="list_label_star">
		<svg id="Layer_1" data-name="Layer 1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 8.68 8.68">
			<defs>
				<style>
					.cls-1 {
						fill: #231f20;
						stroke-width: 0px;
					}
				</style>
			</defs>
			<path class="cls-1" d="m0,4.04c1.04-.05,1.92-.37,2.63-.97.88-.75,1.36-1.77,1.43-3.07h.58c.08,1.31.56,2.34,1.42,3.07.7.6,1.57.92,2.62.97v.58c-1.05.05-1.92.38-2.62.97-.88.75-1.36,1.78-1.42,3.08h-.58c-.05-1.04-.37-1.92-.98-2.63-.75-.89-1.78-1.36-3.07-1.43v-.58Zm7.09.29c-1.33-.5-2.24-1.42-2.75-2.75-.47,1.32-1.39,2.24-2.75,2.75.65.23,1.21.58,1.68,1.06s.83,1.04,1.07,1.69c.24-.65.6-1.22,1.07-1.7s1.04-.83,1.68-1.06Z"/>
		</svg>
	</xsl:variable>
	
	<xsl:include href="./common.xsl"/>
	
</xsl:stylesheet>
