<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
											xmlns:fo="http://www.w3.org/1999/XSL/Format" 
											xmlns:mn="https://www.metanorma.org/ns/standoc" 
											xmlns:mnx="https://www.metanorma.org/ns/xslt" 
											xmlns:mathml="http://www.w3.org/1998/Math/MathML" 
											xmlns:xalan="http://xml.apache.org/xalan" 
											xmlns:fox="http://xmlgraphics.apache.org/fop/extensions" 
											xmlns:java="http://xml.apache.org/xalan/java" 
											xmlns:redirect="http://xml.apache.org/xalan/redirect"
											exclude-result-prefixes="java xalan"
											extension-element-prefixes="redirect"
											version="1.0">

	<xsl:output method="xml" encoding="UTF-8" indent="no"/>
	
	<xsl:key name="kfn" match="mn:fn[not(ancestor::*[self::mn:table or self::mn:figure or self::mn:localized-strings] and not(ancestor::mn:fmt-name))]" use="@reference"/>
	
	<xsl:variable name="namespace">iho</xsl:variable>
	
	<xsl:variable name="debug">false</xsl:variable>
	
	<!-- Example:
		<item level="1" id="Foreword" display="true">Foreword</item>
		<item id="term-script" display="false">3.2</item>
	-->
	<xsl:variable name="contents_">
		<xsl:variable name="bundle" select="count(//mn:metanorma) &gt; 1"/>
		<xsl:for-each select="//mn:metanorma">
			<xsl:variable name="num"><xsl:number level="any" count="mn:metanorma"/></xsl:variable>
			<xsl:variable name="docidentifier"><xsl:value-of select="mn:bibdata/mn:docidentifier[@type = 'IHO']"/></xsl:variable>
			<xsl:variable name="docnumber_">
				<xsl:choose>
					<xsl:when test="ancestor::*[local-name() = 'doc-container'] and 
					(preceding::mn:metanorma/mn:bibdata/mn:docidentifier[@type = 'IHO'] = $docidentifier or
					 following::mn:metanorma/mn:bibdata/mn:docidentifier[@type = 'IHO'] = $docidentifier)">
						<xsl:variable name="doc_container_id" select="ancestor::*[local-name() = 'doc-container']/@id"/>
						<xsl:value-of select="ancestor::*[local-name() = 'metanorma-collection']//*[local-name() = 'entry'][@target = $doc_container_id]/*[local-name() = 'identifier']"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$docidentifier"/>
						<xsl:if test="normalize-space($docidentifier) = ''">
							<xsl:value-of select="mn:bibdata/mn:docidentifier[1]"/>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="docnumber" select="normalize-space($docnumber_)"/>
			<xsl:variable name="current_document">
				<xsl:copy-of select="."/>
			</xsl:variable>
			
			<xsl:for-each select="xalan:nodeset($current_document)"> <!-- <xsl:for-each select="."> -->
				<mnx:doc num="{$num}" firstpage_id="firstpage_id_{$num}" title-part="{$docnumber}" bundle="{$bundle}"> <!-- 'bundle' means several different documents (not language versions) in one xml -->
					<mnx:contents>
						<xsl:call-template name="processPrefaceSectionsDefault_Contents"/>
						<xsl:call-template name="processMainSectionsDefault_Contents"/>
						
						<xsl:call-template name="processTablesFigures_Contents"/>
					</mnx:contents>
				</mnx:doc>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="contents" select="xalan:nodeset($contents_)"/>
	
	<xsl:template name="layout-master-set">
		<fo:layout-master-set>
			<!-- cover page -->
			<fo:simple-page-master master-name="cover-page" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="0mm" margin-bottom="5mm" margin-left="0mm" margin-right="5mm"/>
			</fo:simple-page-master>
			
			<fo:simple-page-master master-name="first" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
				<fo:region-before region-name="header" extent="{$marginTop}mm"/> 
				<fo:region-after region-name="footer" extent="{$marginBottom}mm"/>
				<fo:region-start region-name="left-region" extent="{$marginLeftRight1}mm"/>
				<fo:region-end region-name="right-region" extent="{$marginLeftRight2}mm"/>
			</fo:simple-page-master>				
			<fo:simple-page-master master-name="odd" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
				<fo:region-before region-name="header-odd" extent="{$marginTop}mm"/> 
				<fo:region-after region-name="footer" extent="{$marginBottom}mm"/>
				<fo:region-start region-name="left-region" extent="{$marginLeftRight1}mm"/>
				<fo:region-end region-name="right-region" extent="{$marginLeftRight2}mm"/>
			</fo:simple-page-master>
			<fo:simple-page-master master-name="odd-landscape" page-width="{$pageHeight}mm" page-height="{$pageWidth}mm">
				<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
				<fo:region-before region-name="header-odd" extent="{$marginTop}mm"/> 
				<fo:region-after region-name="footer" extent="{$marginBottom}mm"/>
				<fo:region-start region-name="left-region" extent="{$marginLeftRight1}mm"/>
				<fo:region-end region-name="right-region" extent="{$marginLeftRight2}mm"/>
			</fo:simple-page-master>
			<fo:simple-page-master master-name="even" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight2}mm" margin-right="{$marginLeftRight1}mm"/>
				<fo:region-before region-name="header-even" extent="{$marginTop}mm"/>
				<fo:region-after region-name="footer" extent="{$marginBottom}mm"/>
				<fo:region-start region-name="left-region" extent="{$marginLeftRight2}mm"/>
				<fo:region-end region-name="right-region" extent="{$marginLeftRight1}mm"/>
			</fo:simple-page-master>
			<fo:simple-page-master master-name="even-landscape" page-width="{$pageHeight}mm" page-height="{$pageWidth}mm">
				<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight2}mm" margin-right="{$marginLeftRight1}mm"/>
				<fo:region-before region-name="header-even" extent="{$marginTop}mm"/>
				<fo:region-after region-name="footer" extent="{$marginBottom}mm"/>
				<fo:region-start region-name="left-region" extent="{$marginLeftRight2}mm"/>
				<fo:region-end region-name="right-region" extent="{$marginLeftRight1}mm"/>
			</fo:simple-page-master>
			<fo:simple-page-master master-name="blankpage" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight2}mm" margin-right="{$marginLeftRight1}mm"/>
				<fo:region-before region-name="header-blank" extent="{$marginTop}mm"/>
				<fo:region-after region-name="footer" extent="{$marginBottom}mm"/>
				<fo:region-start region-name="left-region" extent="{$marginLeftRight2}mm"/>
				<fo:region-end region-name="right-region" extent="{$marginLeftRight1}mm"/>
			</fo:simple-page-master>
			<fo:simple-page-master master-name="blankpage-landscape" page-width="{$pageHeight}mm" page-height="{$pageWidth}mm">
				<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight2}mm" margin-right="{$marginLeftRight1}mm"/>
				<fo:region-before region-name="header-blank" extent="{$marginTop}mm"/>
				<fo:region-after region-name="footer" extent="{$marginBottom}mm"/>
				<fo:region-start region-name="left-region" extent="{$marginLeftRight2}mm"/>
				<fo:region-end region-name="right-region" extent="{$marginLeftRight1}mm"/>
			</fo:simple-page-master>
			<!-- Preface pages -->
			<fo:page-sequence-master master-name="preface">
				<fo:repeatable-page-master-alternatives>
					<!-- <fo:conditional-page-master-reference master-reference="first" page-position="first"/> -->
					<fo:conditional-page-master-reference master-reference="blankpage" blank-or-not-blank="blank"/>
					<fo:conditional-page-master-reference odd-or-even="even" master-reference="even"/>
					<fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd"/>
				</fo:repeatable-page-master-alternatives>
			</fo:page-sequence-master>
			<fo:page-sequence-master master-name="preface-landscape">
				<fo:repeatable-page-master-alternatives>
					<fo:conditional-page-master-reference master-reference="blankpage-landscape" blank-or-not-blank="blank"/>
					<fo:conditional-page-master-reference odd-or-even="even" master-reference="even-landscape"/>
					<fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd-landscape"/>
				</fo:repeatable-page-master-alternatives>
			</fo:page-sequence-master>
			<!-- Document pages -->
			<fo:page-sequence-master master-name="document">
				<fo:repeatable-page-master-alternatives>
					<fo:conditional-page-master-reference master-reference="blankpage" blank-or-not-blank="blank"/>
					<fo:conditional-page-master-reference odd-or-even="even" master-reference="even"/>
					<fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd"/>
				</fo:repeatable-page-master-alternatives>
			</fo:page-sequence-master>
			<fo:page-sequence-master master-name="document-portrait">
				<fo:repeatable-page-master-alternatives>
					<fo:conditional-page-master-reference master-reference="blankpage" blank-or-not-blank="blank"/>
					<fo:conditional-page-master-reference odd-or-even="even" master-reference="even"/>
					<fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd"/>
				</fo:repeatable-page-master-alternatives>
			</fo:page-sequence-master>
			<fo:page-sequence-master master-name="document-landscape">
				<fo:repeatable-page-master-alternatives>
					<fo:conditional-page-master-reference master-reference="blankpage-landscape" blank-or-not-blank="blank"/>
					<fo:conditional-page-master-reference odd-or-even="even" master-reference="even-landscape"/>
					<fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd-landscape"/>
				</fo:repeatable-page-master-alternatives>
			</fo:page-sequence-master>
		</fo:layout-master-set>
	</xsl:template> <!-- END: layout-master-set -->
	
	<xsl:template match="/">
		
		<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format" xml:lang="{$lang}">
			<xsl:variable name="root-style">
				<root-style xsl:use-attribute-sets="root-style"/>
			</xsl:variable>
			<xsl:call-template name="insertRootStyle">
				<xsl:with-param name="root-style" select="$root-style"/>
			</xsl:call-template>
			
			<xsl:call-template name="layout-master-set"/>
			
			<fo:declarations>
				<xsl:call-template name="addPDFUAmeta"/>
			</fo:declarations>
			
			<xsl:call-template name="addBookmarks">
				<xsl:with-param name="contents" select="$contents"/>
			</xsl:call-template>
			
			
			<xsl:variable name="updated_xml">
				<xsl:call-template name="updateXML"/>
			</xsl:variable>
			
			<xsl:if test="$debug = 'true'">
				<redirect:write file="updated_xml.xml">
					<xsl:copy-of select="$updated_xml"/>
				</redirect:write>
			</xsl:if>
			
			<!-- <xsl:for-each select="xalan:nodeset($updated_xml)/*"> -->
			<xsl:for-each select="xalan:nodeset($updated_xml)//mn:metanorma">
				<xsl:variable name="num"><xsl:number level="any" count="mn:metanorma"/></xsl:variable>
				
				<xsl:variable name="current_document">
					<xsl:copy-of select="."/>
				</xsl:variable>
				
				<xsl:for-each select="xalan:nodeset($current_document)">
			
					<xsl:variable name="title-en"><xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:title[@language = 'en']/node()"/></xsl:variable>
					<xsl:variable name="title-main_"><xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:title[@type = 'main']/node()"/></xsl:variable>
					
					<xsl:variable name="title_header">
						<xsl:copy-of select="$title-main_"/>
						<xsl:if test="normalize-space($title-main_) = ''"><xsl:copy-of select="$title-en"/></xsl:if>
					</xsl:variable>
			
					<xsl:variable name="docidentifier_parent" select="normalize-space(/mn:metanorma/mn:bibdata/mn:docidentifier[@type = 'IHO-parent-document'])"/>
					<xsl:variable name="docidentifier">
						<xsl:value-of select="$docidentifier_parent"/>
						<xsl:if test="$docidentifier_parent = ''"><xsl:value-of select="/mn:metanorma/mn:bibdata/mn:docidentifier[@type = 'IHO']"/></xsl:if>
					</xsl:variable>
					
					<xsl:variable name="copyrightText" select="concat('© International Hydrographic Association ', /mn:metanorma/mn:bibdata/mn:copyright/mn:from ,' – All rights reserved')"/>
					<xsl:variable name="edition"><xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:edition[normalize-space(@language) = '']"/></xsl:variable>
					<xsl:variable name="month_year"><xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:date[@type = 'published']"/></xsl:variable>
					
					<xsl:call-template name="cover-page">
						<xsl:with-param name="num" select="$num"/>
						<xsl:with-param name="docidentifier" select="$docidentifier"/>
						<xsl:with-param name="edition" select="$edition"/>
						<xsl:with-param name="month_year" select="$month_year"/>
					</xsl:call-template>
				
					<xsl:call-template name="inner-cover-page">
						<xsl:with-param name="title_header" select="$title_header"/>
						<xsl:with-param name="docidentifier" select="$docidentifier"/>
						<xsl:with-param name="edition" select="$edition"/>
						<xsl:with-param name="month_year" select="$month_year"/>
					</xsl:call-template>
					
					<xsl:variable name="updated_xml_with_pages">
						<xsl:call-template name="processPrefaceAndMainSectionsIHO_items"/>
					</xsl:variable>
					
					<xsl:for-each select="xalan:nodeset($updated_xml_with_pages)"> <!-- set context to preface/sections -->
						
						<xsl:for-each select=".//mn:page_sequence[parent::mn:preface][normalize-space() != '' or .//mn:image or .//*[local-name() = 'svg']]">
			
							<!-- Preface Pages -->
							<fo:page-sequence master-reference="preface" format="i" force-page-count="end-on-even">
								
								<xsl:attribute name="master-reference">
									<xsl:text>preface</xsl:text>
									<xsl:call-template name="getPageSequenceOrientation"/>
								</xsl:attribute>
							
								<xsl:call-template name="insertFootnoteSeparatorCommon"/>
								<xsl:call-template name="insertHeaderFooter">
									<xsl:with-param name="title_header" select="$title_header"/>
									<xsl:with-param name="docidentifier" select="$docidentifier"/>
									<xsl:with-param name="edition" select="$edition"/>
									<xsl:with-param name="month_year" select="$month_year"/>
									<xsl:with-param name="font-weight">normal</xsl:with-param>
									<xsl:with-param name="orientation"><xsl:call-template name="getPageSequenceOrientation"/></xsl:with-param>
								</xsl:call-template>
								<fo:flow flow-name="xsl-region-body">
									
									
									<!-- <xsl:if test="position() = 1">
										<fo:block-container margin-left="-1.5mm" margin-right="-1mm">
											<fo:block-container margin-left="0mm" margin-right="0mm" border="0.5pt solid black" >
												<fo:block-container margin-top="6.5mm" margin-left="7.5mm" margin-right="8.5mm" margin-bottom="7.5mm">
													<fo:block-container margin="0">
														<fo:block text-align="justify">
															<xsl:apply-templates select="/mn:metanorma/mn:boilerplate/*[local-name() != 'feedback-statement']"/>
														</fo:block>
													</fo:block-container>
												</fo:block-container>
											</fo:block-container>
										</fo:block-container>
										<fo:block break-after="page"/>
									</xsl:if> -->
									
									<!-- Contents, Document History, ... except Foreword and Introduction -->
									<!-- <xsl:call-template name="processPrefaceSectionsDefault"/> -->
									<xsl:apply-templates select="*[not(self::mn:foreword) and not(self::mn:introduction)]">
										<xsl:with-param name="num" select="$num"/>
									</xsl:apply-templates>
									
								</fo:flow>
							</fo:page-sequence>
							<!-- End Preface Pages -->
							<!-- =========================== -->
							<!-- =========================== -->
						</xsl:for-each>
						
						
						<xsl:for-each select=".//mn:page_sequence[mn:foreword or mn:introduction][parent::mn:preface][normalize-space() != '' or .//mn:image or .//*[local-name() = 'svg']]">
			
							<!-- Preface Pages -->
							<fo:page-sequence master-reference="preface" format="i" force-page-count="end-on-even">
								
								<xsl:attribute name="master-reference">
									<xsl:text>preface</xsl:text>
									<xsl:call-template name="getPageSequenceOrientation"/>
								</xsl:attribute>
							
								<xsl:call-template name="insertFootnoteSeparatorCommon"/>
								<xsl:call-template name="insertHeaderFooter">
									<xsl:with-param name="title_header" select="$title_header"/>
									<xsl:with-param name="docidentifier" select="$docidentifier"/>
									<xsl:with-param name="edition" select="$edition"/>
									<xsl:with-param name="month_year" select="$month_year"/>
									<xsl:with-param name="font-weight">normal</xsl:with-param>
									<xsl:with-param name="orientation"><xsl:call-template name="getPageSequenceOrientation"/></xsl:with-param>
								</xsl:call-template>
								<fo:flow flow-name="xsl-region-body">
									
									<!-- Foreword, Introduction -->
									<xsl:apply-templates select="*[self::mn:foreword or self::mn:introduction]"/>
									
								</fo:flow>
							</fo:page-sequence>
							<!-- End Preface Pages -->
							<!-- =========================== -->
							<!-- =========================== -->
						</xsl:for-each>
						
					
					
						<xsl:for-each select=".//mn:page_sequence[not(parent::mn:preface)][normalize-space() != '' or .//mn:image or .//*[local-name() = 'svg']]">
					
							<xsl:variable name="page_sequence_content">
								<xsl:apply-templates />
							</xsl:variable>
					
							<xsl:if test="xalan:nodeset($page_sequence_content)/node()">
					
								<fo:page-sequence master-reference="document" format="1" force-page-count="end-on-even">
								
									<xsl:attribute name="master-reference">
										<xsl:text>document</xsl:text>
										<xsl:call-template name="getPageSequenceOrientation"/>
									</xsl:attribute>
									
									<xsl:if test="position() = 1">
										<xsl:attribute name="initial-page-number">1</xsl:attribute>
									</xsl:if>
									
									<xsl:call-template name="insertFootnoteSeparatorCommon"/>
									<xsl:call-template name="insertHeaderFooter">
										<xsl:with-param name="title_header" select="$title_header"/>
										<xsl:with-param name="docidentifier" select="$docidentifier"/>
										<xsl:with-param name="edition" select="$edition"/>
										<xsl:with-param name="month_year" select="$month_year"/>
										<xsl:with-param name="orientation"><xsl:call-template name="getPageSequenceOrientation"/></xsl:with-param>
									</xsl:call-template>
									<fo:flow flow-name="xsl-region-body">
										<fo:block-container>
											
											<!-- <fo:block font-size="16pt" font-weight="bold" margin-bottom="18pt" role="H1"><xsl:value-of select="$title-en"/></fo:block> -->
											
											<!-- <xsl:apply-templates select="/*/*[local-name()='sections']/*[local-name()='clause'][@type='scope']" /> -->
											<!-- Normative references  -->
											<!-- <xsl:apply-templates select="/*/*[local-name()='bibliography']/*[local-name()='references'][@normative='true']" /> -->
											<!-- Terms and definitions -->
											<!-- <xsl:apply-templates select="/*/*[local-name()='sections']/*[local-name()='terms']" />
											<xsl:apply-templates select="/*/*[local-name()='sections']/*[local-name()='definitions']" />
											<xsl:apply-templates select="/*/*[local-name()='sections']/*[local-name() != 'terms' and local-name() != 'definitions' and not(@type='scope')]" /> -->
											
											<!-- <xsl:call-template name="processMainSectionsDefault"/> -->
											
											<!--<xsl:apply-templates /> -->
											<xsl:copy-of select="$page_sequence_content"/>
											
											<xsl:if test="$table_if = 'true'"><fo:block/></xsl:if>
										</fo:block-container>
									</fo:flow>
								</fo:page-sequence>
							</xsl:if>
					<!-- </xsl:if> -->
						</xsl:for-each>
					</xsl:for-each>
				</xsl:for-each>
					
					<!-- <xsl:if test="/mn:metanorma/mn:annex">
						<fo:page-sequence master-reference="document">
							<fo:static-content flow-name="xsl-footnote-separator">
								<fo:block>
									<fo:leader leader-pattern="rule" leader-length="30%"/>
								</fo:block>
							</fo:static-content>
							<xsl:call-template name="insertHeaderFooter"/>
							<fo:flow flow-name="xsl-region-body">
								<fo:block-container>								
									<xsl:apply-templates select="/*/*[local-name()='annex']" />
									
									<xsl:if test="$table_if = 'true'"><fo:block/></xsl:if>
								</fo:block-container>
							</fo:flow>
						</fo:page-sequence>
					</xsl:if> -->
					
					<!-- <xsl:if test="/*/*[local-name()='bibliography']/*[local-name()='references'][not(@normative='true')]">
						<fo:page-sequence master-reference="document">
							<fo:static-content flow-name="xsl-footnote-separator">
								<fo:block>
									<fo:leader leader-pattern="rule" leader-length="30%"/>
								</fo:block>
							</fo:static-content>
							<xsl:call-template name="insertHeaderFooter"/>
							<fo:flow flow-name="xsl-region-body">
								<fo:block-container>	 -->							
									<!-- Bibliography -->
									<!-- <xsl:apply-templates select="/*/*[local-name()='bibliography']/*[local-name()='references'][not(@normative='true')]" />
									
									<xsl:if test="$table_if = 'true'"><fo:block/></xsl:if>
								</fo:block-container>
							</fo:flow>
						</fo:page-sequence>
					</xsl:if> -->
					
					
					
					<!-- =========================== -->
					<!-- End Document Pages -->
					<!-- =========================== -->
					<!-- =========================== -->
			</xsl:for-each>
			
			<xsl:call-template name="back-page"/>
			
		</fo:root>
	</xsl:template>
	
	<xsl:template name="cover-page">
		<xsl:param name="num"/>
		<xsl:param name="docidentifier"/>
		<xsl:param name="edition"/>
		<xsl:param name="month_year"/>
		
		<xsl:variable name="title-en"><xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:title[@language = 'en']/node()"/></xsl:variable>
		<xsl:variable name="title-main_"><xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:title[@type = 'main']/node()"/></xsl:variable>
		<xsl:variable name="title-main"><xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:title[@type = 'title-main']/node()"/></xsl:variable>
		<xsl:variable name="title-appendix"><xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:title[@type = 'title-appendix']/node()"/></xsl:variable>
		<xsl:variable name="title-annex"><xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:title[@type = 'title-annex']/node()"/></xsl:variable>
		<xsl:variable name="title-part"><xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:title[@type = 'title-part']/node()"/></xsl:variable>
		<xsl:variable name="title-supplement"><xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:title[@type = 'title-supplement']/node()"/></xsl:variable>
		
		<!-- =========================== -->
		<!-- Cover Page -->
		<fo:page-sequence master-reference="cover-page">				
			<fo:flow flow-name="xsl-region-body">
			
				<fo:block-container absolute-position="fixed" top="1mm">
					<xsl:if test="$num = 1">
						<xsl:attribute name="id">firstpage_id_0</xsl:attribute>
					</xsl:if>
					<fo:block id="firstpage_id_{$num}">&#xa0;</fo:block>
				</fo:block-container>
			
				<xsl:variable name="isCoverPageImage" select="normalize-space(/mn:metanorma/mn:metanorma-extension/mn:presentation-metadata[mn:name = 'coverpage-image']/mn:value/mn:image and 1 = 1)"/>
			
				<xsl:variable name="document_scheme" select="normalize-space(/mn:metanorma/mn:metanorma-extension/mn:presentation-metadata[mn:name = 'document-scheme']/mn:value)"/>
				
				<xsl:choose>
					<xsl:when test="$document_scheme != '' and $document_scheme != '2019' and $isCoverPageImage = 'true'">
						<xsl:call-template name="insertBackgroundPageImage"/>
					</xsl:when>
					<xsl:otherwise>
					
						<fo:block-container position="absolute" left="14.25mm" top="12mm" id="__internal_layout__coverpage_{$num}_{generate-id()}">
							<fo:table table-layout="fixed" width="181.1mm">
									<fo:table-column column-width="26mm"/>
									<fo:table-column column-width="19.4mm"/> 
									<fo:table-column column-width="135.7mm"/>
									<fo:table-body>
										<fo:table-row>
											<fo:table-cell><fo:block>&#xA0;</fo:block></fo:table-cell>
											<fo:table-cell>
												<fo:block-container width="19.4mm" height="21mm" background-color="rgb(241, 234, 202)" border-bottom="0.05pt solid rgb(0, 21, 50)" text-align="center" display-align="center" font-size="10pt" font-weight="bold">
													<xsl:if test="$isCoverPageImage = 'true'">
														<xsl:attribute name="width">42.5mm</xsl:attribute>
													</xsl:if>
													<fo:block>
														<xsl:value-of select="$docidentifier"/>
														<xsl:if test="$isCoverPageImage = 'true'">
															<xsl:text> </xsl:text><xsl:value-of select="$edition"/>
														</xsl:if>
													</fo:block>
												</fo:block-container>
											</fo:table-cell>
											<fo:table-cell><fo:block>&#xA0;</fo:block></fo:table-cell>
										</fo:table-row>
										<fo:table-row>
											<fo:table-cell display-align="after" text-align="right">
												<fo:block font-size="1">
													<fo:instream-foreign-object content-width="25.9mm" fox:alt-text="Image IHO">
														<xsl:copy-of select="$Image-IHO-SVG"/>
													</fo:instream-foreign-object>
												</fo:block>
											</fo:table-cell>
											
											<!-- https://github.com/metanorma/metanorma-iho/issues/288 -->
											<xsl:choose>
												<xsl:when test="$isCoverPageImage = 'true'">
													<fo:table-cell number-columns-spanned="2">
														<fo:block-container font-size="0"> <!-- height="168mm" width="115mm"  -->
															<fo:block>
																<xsl:for-each select="/mn:metanorma/mn:metanorma-extension/mn:presentation-metadata[mn:name = 'coverpage-image'][1]/mn:value/mn:image[1]">
																
																	<xsl:call-template name="insertPageImage">
																		<xsl:with-param name="bitmap_width">155.5</xsl:with-param>
																	</xsl:call-template>
																	
																</xsl:for-each>
															</fo:block>
														</fo:block-container>
													</fo:table-cell>
												</xsl:when>
												<xsl:otherwise>
													<fo:table-cell number-columns-spanned="2" border="0.5pt solid rgb(0, 21, 50)" font-weight="bold" color="rgb(0, 0, 76)" padding-top="3mm">
														<fo:block-container height="165mm" width="115mm">
															<fo:block-container margin-left="10mm">
																<fo:block-container xsl:use-attribute-sets="reset-margins-style">
																
																	<!-- <fo:block-container display-align="center" height="90mm"> -->
																	<fo:table table-layout="fixed" width="100%">
																		<fo:table-body>
																			<fo:table-row min-height="90mm"> <!-- for debug: border="1pt solid blue" -->
																				<fo:table-cell display-align="center">
																					<xsl:if test="normalize-space($title-annex) != '' or 
																						normalize-space($title-appendix) != '' or
																						normalize-space($title-supplement) != ''">
																						<fo:block font-size="14pt" role="H1" line-height="115%" margin-top="35mm">
																							<fo:block><xsl:copy-of select="$title-annex"/></fo:block>
																							<fo:block><xsl:copy-of select="$title-appendix"/></fo:block>
																							<fo:block><xsl:copy-of select="$title-supplement"/></fo:block>
																						</fo:block>
																						<fo:block font-size="28pt" role="SKIP" line-height="115%">&#xa0;</fo:block>
																					</xsl:if>
																					<fo:block font-size="28pt" role="H1" line-height="115%">
																						<xsl:copy-of select="$title-main"/>
																						<xsl:if test="normalize-space($title-main) = ''">
																							<xsl:copy-of select="$title-main_"/>
																							<xsl:if test="normalize-space($title-main_) = ''"><xsl:copy-of select="$title-en"/></xsl:if>
																						</xsl:if>
																					</fo:block>
																					<xsl:if test="normalize-space($title-part) != ''">
																						<fo:block font-size="28pt" role="SKIP" line-height="115%">&#xa0;</fo:block>
																						<fo:block font-size="18pt" role="H2" line-height="115%" margin-bottom="10mm">
																							<xsl:copy-of select="$title-part"/>
																						</fo:block>
																					</xsl:if>
																				</fo:table-cell>
																			</fo:table-row>
																		</fo:table-body>
																	</fo:table>
																	<!-- </fo:block-container> -->
																	
																	<fo:block font-size="14pt">
																		<xsl:value-of select="$edition"/>
																		<xsl:if test="normalize-space($month_year) != ''">
																			<xsl:text> – </xsl:text>
																			<xsl:value-of select="$month_year" />
																		</xsl:if>
																	</fo:block>
																</fo:block-container>
															</fo:block-container>
														</fo:block-container>
													</fo:table-cell>
												</xsl:otherwise>
											</xsl:choose>
										</fo:table-row>
										<fo:table-row>
											<fo:table-cell>
												<fo:block font-size="1">
													<fo:instream-foreign-object content-width="25.9mm" fox:alt-text="Image Logo IHO">
														<xsl:copy-of select="$Image-Logo-IHO-SVG"/>
													</fo:instream-foreign-object>
												</fo:block>
											</fo:table-cell>
											<fo:table-cell>
												<fo:block font-size="1">
													<fo:instream-foreign-object content-width="25.8mm" fox:alt-text="Image Logo IHO">
														<xsl:copy-of select="$Image-Text-IHO-SVG"/>
													</fo:instream-foreign-object>
												</fo:block>
											</fo:table-cell>
											<fo:table-cell number-rows-spanned="2">
												<fo:block-container width="79mm" height="72mm" margin-left="56.8mm" background-color="rgb(0, 172, 158)" text-align="right" display-align="after">
													<fo:block-container xsl:use-attribute-sets="reset-margins-style">
														<fo:block font-size="8pt" color="white" margin-right="5mm" margin-bottom="5mm" line-height-shift-adjustment="disregard-shifts">
															<xsl:apply-templates select="/mn:metanorma/mn:boilerplate/mn:feedback-statement"/>
														</fo:block>
													</fo:block-container>
												</fo:block-container>					
											</fo:table-cell>
										</fo:table-row>
										<fo:table-row>
											<fo:table-cell number-columns-spanned="2" padding-top="2mm">
												<fo:block-container width="51.5mm">
													<fo:block>
														<xsl:for-each select="/mn:metanorma/mn:bibdata/mn:contributor[mn:role/@type = 'publisher']/mn:organization[not(mn:abbreviation = 'IHO')]">
															<xsl:apply-templates select="mn:logo/mn:image">
																<xsl:with-param name="logo_width">25.8mm</xsl:with-param>
															</xsl:apply-templates>
															<xsl:if test="position() != last()"><fo:inline> </fo:inline></xsl:if>
														</xsl:for-each>
													</fo:block>
												</fo:block-container>
											</fo:table-cell>
										</fo:table-row>
									</fo:table-body>
								</fo:table>
						</fo:block-container>
					</xsl:otherwise>
				</xsl:choose>
			</fo:flow>
		</fo:page-sequence>
		<!-- End Cover Page -->
		<!-- =========================== -->
		<!-- =========================== -->
	</xsl:template>
	
	<xsl:template name="inner-cover-page">
		<xsl:param name="title_header"/>
		<xsl:param name="docidentifier"/>
		<xsl:param name="edition"/>
		<xsl:param name="month_year"/>
		<xsl:choose>
			<xsl:when test="/mn:metanorma/mn:boilerplate/*[not(self::mn:feedback-statement)]">
				<fo:page-sequence master-reference="preface" format="i" force-page-count="no-force">
					<xsl:call-template name="insertHeaderFooter">
						<xsl:with-param name="title_header" select="$title_header"/>
						<xsl:with-param name="docidentifier" select="$docidentifier"/>
						<xsl:with-param name="edition" select="$edition"/>
						<xsl:with-param name="month_year" select="$month_year"/>
						<xsl:with-param name="font-weight">normal</xsl:with-param>
					</xsl:call-template>
					<fo:flow flow-name="xsl-region-body">
						<fo:block-container margin-left="-1.5mm" margin-right="-1mm">
							<fo:block-container xsl:use-attribute-sets="reset-margins-style" border="0.5pt solid black" >
								<fo:block-container margin-top="6.5mm" margin-left="7.5mm" margin-right="8.5mm" margin-bottom="7.5mm">
									<fo:block-container margin="0">
										<fo:block text-align="justify">
											<xsl:apply-templates select="/mn:metanorma/mn:boilerplate/*[not(self::mn:feedback-statement)]"/>
										</fo:block>
									</fo:block-container>
								</fo:block-container>
							</fo:block-container>
						</fo:block-container>
					</fo:flow>
				</fo:page-sequence>
			</xsl:when>
			<xsl:otherwise>
				<!-- https://github.com/metanorma/metanorma-iho/issues/293:
					If the publication has no copyright boxed note (normally on page ii of the publication), page ii should be "Page intentionally left blank". -->
				<fo:page-sequence master-reference="blankpage" format="i" force-page-count="no-force">
					<xsl:call-template name="insertHeaderFooterBlank">
						<xsl:with-param name="title_header" select="$title_header"/>
						<xsl:with-param name="docidentifier" select="$docidentifier"/>
						<xsl:with-param name="edition" select="$edition"/>
						<xsl:with-param name="month_year" select="$month_year"/>
					</xsl:call-template>
					<fo:flow flow-name="xsl-region-body">
						<fo:block/>
					</fo:flow>
				</fo:page-sequence>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- inner-cover-page -->
	
	<xsl:template name="back-page">
	</xsl:template>
	
	<xsl:template name="insertListOf_Title">
		<xsl:param name="title"/>
		<fo:block xsl:use-attribute-sets="toc-listof-title-style">
			<xsl:value-of select="$title"/>
		</fo:block>
	</xsl:template>
	
	<xsl:template name="insertListOf_Item">
		<fo:block xsl:use-attribute-sets="toc-listof-item-style">
			<fo:basic-link internal-destination="{@id}">
				<xsl:call-template name="setAltText">
					<xsl:with-param name="value" select="@alt-text"/>
				</xsl:call-template>
				<xsl:apply-templates select="." mode="contents"/>
				<fo:inline keep-together.within-line="always">
					<fo:leader xsl:use-attribute-sets="toc-leader-style" />
					<fo:inline><fo:page-number-citation ref-id="{@id}"/></fo:inline>
				</fo:inline>
			</fo:basic-link>
		</fo:block>
	</xsl:template>
	
	<xsl:template name="processPrefaceAndMainSectionsIHO_items">
	
		<xsl:variable name="updated_xml_step_move_pagebreak">
			<xsl:element name="{$root_element}" namespace="{$namespace_full}">
				<xsl:call-template name="copyCommonElements"/>
				<xsl:call-template name="insertPrefaceSectionsPageSequences"/>
				
				<!-- <xsl:call-template name="insertMainSectionsPageSequences"/> -->
				
				<xsl:call-template name="insertSectionsInPageSequence"/>
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
	</xsl:template>
	
	<xsl:template match="mn:preface//mn:clause[@type = 'toc']" name="toc" priority="4">
		<xsl:param name="num"/>
		<!-- Table of Contents -->
		<fo:block>
		
			<xsl:apply-templates />
			
			<xsl:if test="$debug = 'true'">
				<redirect:write file="contents_.xml"> <!-- {java:getTime(java:java.util.Date.new())} -->
					<xsl:copy-of select="$contents"/>
				</redirect:write>
			</xsl:if>
			
			<xsl:if test="count(*) = 1 and mn:fmt-title"> <!-- if there isn't user ToC -->
			
				<fo:block role="TOC" xsl:use-attribute-sets="toc-style">
				
					<xsl:for-each select="$contents/mnx:doc[@num = $num]//mnx:item[@display = 'true']"><!-- [not(@level = 2 and starts-with(@section, '0'))] skip clause from preface -->							
						<fo:block role="TOCI">
							<fo:list-block xsl:use-attribute-sets="toc-item-block-style">
								
								<xsl:call-template name="refine_toc-item-block-style"/>
								
								<fo:list-item>
									<fo:list-item-label end-indent="label-end()">
										<fo:block id="__internal_layout__toc_sectionnum_{$num}_{generate-id()}">
											<xsl:if test="@section != '' and not(@type = 'annex')"> <!-- output below   -->
												<xsl:value-of select="@section"/>
											</xsl:if>
										</fo:block>
									</fo:list-item-label>
										<fo:list-item-body start-indent="body-start()">
											<fo:block xsl:use-attribute-sets="toc-item-style">
												<fo:basic-link internal-destination="{@id}" fox:alt-text="{mnx:title}">
													<xsl:apply-templates select="mnx:title"/>
													<fo:inline keep-together.within-line="always">
														<fo:leader xsl:use-attribute-sets="toc-leader-style"/>
														<fo:inline><fo:page-number-citation ref-id="{@id}"/></fo:inline>
													</fo:inline>
												</fo:basic-link>
											</fo:block>
										</fo:list-item-body>
								</fo:list-item>
							</fo:list-block>
						</fo:block>
					</xsl:for-each>
					
					<!-- List of Tables -->
					<xsl:for-each select="$contents//mnx:tables/mnx:table">
						<xsl:if test="position() = 1">
							<xsl:call-template name="insertListOf_Title">
								<xsl:with-param name="title" select="$title-list-tables"/>
							</xsl:call-template>
						</xsl:if>
						<xsl:call-template name="insertListOf_Item"/>
					</xsl:for-each>
					
					<!-- List of Figures -->
					<xsl:for-each select="$contents//mnx:figures/mnx:figure">
						<xsl:if test="position() = 1">
							<xsl:call-template name="insertListOf_Title">
								<xsl:with-param name="title" select="$title-list-figures"/>
							</xsl:call-template>
						</xsl:if>
						<xsl:call-template name="insertListOf_Item"/>
					</xsl:for-each>
				</fo:block>
			</xsl:if>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="mn:preface//mn:clause[@type = 'toc']/mn:fmt-title" priority="3">
		<fo:block xsl:use-attribute-sets="toc-title-style">
			<fo:block-container width="18.3mm" border-bottom="1.25pt solid black" role="SKIP">
				<fo:block line-height="75%">
					<!-- <xsl:call-template name="getLocalizedString">
						<xsl:with-param name="key">table_of_contents</xsl:with-param>
					</xsl:call-template> -->
					<xsl:apply-templates />
				</fo:block>
			</fo:block-container>
		</fo:block>
	</xsl:template>
	
	<!-- ============================= -->
	<!-- CONTENTS                                       -->
	<!-- ============================= -->

	<!-- element with title -->
	<xsl:template match="*[mn:title or mn:fmt-title]" mode="contents">
		<xsl:variable name="level">
			<xsl:call-template name="getLevel">
				<xsl:with-param name="depth" select="mn:fmt-title/@depth | mn:title/@depth"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="display">
			<xsl:choose>
				<xsl:when test="@id = '_document_history' or mn:title = 'Document History'">false</xsl:when>
				<xsl:when test="$level &lt;= $toc_level">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="skip">
			<xsl:choose>
				<xsl:when test="@type = 'toc'">true</xsl:when>
				<xsl:when test="ancestor-or-self::mn:bibitem">true</xsl:when>
				<xsl:when test="ancestor-or-self::mn:term">true</xsl:when>				
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:if test="$skip = 'false'">		
		
			<xsl:variable name="section">
				<xsl:call-template name="getSection"/>
			</xsl:variable>
			
			<xsl:variable name="title">
				<xsl:call-template name="getName"/>
			</xsl:variable>
			
			<xsl:variable name="type">
				<xsl:value-of select="local-name()"/>
			</xsl:variable>
			
			<xsl:variable name="root">
				<xsl:if test="ancestor-or-self::mn:preface">preface</xsl:if>
				<xsl:if test="ancestor-or-self::mn:annex">annex</xsl:if>
			</xsl:variable>
			
			<mnx:item id="{@id}" level="{$level}" section="{$section}" type="{$type}" root="{$root}" display="{$display}">
				<mnx:title>
					<xsl:apply-templates select="xalan:nodeset($title)" mode="contents_item"/>
				</mnx:title>
				<xsl:apply-templates  mode="contents" />
			</mnx:item>
			
		</xsl:if>	
		
	</xsl:template>
	
	<xsl:template match="mn:strong" mode="contents_item" priority="2">
		<xsl:apply-templates mode="contents_item"/>
	</xsl:template>
	
	<!-- ============================= -->
	<!-- END CONTENTS                                 -->
	<!-- ============================= -->
	<!-- ============================= -->
	
	<xsl:template match="mn:requirement | mn:recommendation | mn:permission" priority="2" mode="update_xml_step1">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="mn:requirement | mn:recommendation | mn:permission" priority="2">
		<xsl:call-template name="setNamedDestination"/>
		<fo:block-container id="{@id}" xsl:use-attribute-sets="recommendation-style">
			<fo:block-container margin="2mm">
				<fo:block-container margin="0">
					<fo:block>
						<xsl:apply-templates />
					</fo:block>
				</fo:block-container>
			</fo:block-container>
		</fo:block-container>
	</xsl:template>
	
	<xsl:template match="mn:fmt-provision" priority="2" mode="update_xml_step1">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="mn:fmt-provision/mn:div" priority="2">
		<fo:inline><xsl:copy-of select="@id"/><xsl:apply-templates /></fo:inline>
	</xsl:template>
	
	<xsl:template match="mn:metanorma/mn:bibdata/mn:edition">
		<xsl:call-template name="capitalize">
			<xsl:with-param name="str">
				<xsl:call-template name="getLocalizedString">
					<xsl:with-param name="key">edition</xsl:with-param>
				</xsl:call-template>
			</xsl:with-param>
		</xsl:call-template>
		<xsl:text> </xsl:text>
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="mn:metanorma/mn:bibdata/mn:date[@type = 'published']">
		<xsl:call-template name="convertDate">
			<xsl:with-param name="date" select="."/>
			<xsl:with-param name="format" select="'short'"/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="mn:feedback-statement//mn:br" priority="2">
		<fo:block/>
	</xsl:template>
	
	<xsl:template match="mn:feedback-statement//mn:sup" priority="2">
		<fo:inline font-size="62%" baseline-shift="35%">
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>
	
	
	<xsl:template match="node()">		
		<xsl:apply-templates />			
	</xsl:template>
	

	<!-- ====== -->
	<!-- title      -->
	<!-- ====== -->
	
	<xsl:template match="mn:annex/mn:fmt-title" name="annex_title">
		<fo:block xsl:use-attribute-sets="annex-title-style">
		
			<xsl:call-template name="refine_annex-title-style"/>
			
			<xsl:apply-templates />
			<xsl:apply-templates select="following-sibling::*[1][mn:variant-title][@type = 'sub']" mode="subtitle"/>
		</fo:block>
	</xsl:template>
		
	<xsl:template match="mn:bibliography/mn:references[not(@normative='true')]/mn:fmt-title">
		<fo:block xsl:use-attribute-sets="references-non-normative-title-style">
		
			<xsl:call-template name="refine_references-non-normative-title-style"/>
		
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="mn:clause" priority="3">
		<xsl:if test="parent::mn:preface or (parent::mn:page_sequence and local-name(../..) = 'preface')">
			<fo:block break-after="page"/>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="mn:fmt-title">
				<xsl:apply-templates />
			</xsl:when>
			<xsl:otherwise>
				<fo:block>
					<xsl:call-template name="setId"/>
					<xsl:call-template name="addReviewHelper"/>
					<xsl:apply-templates />
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="mn:fmt-title" name="title">
		
		<xsl:variable name="element-name">
			<xsl:choose>
				<xsl:when test="../@inline-header = 'true'">fo:inline</xsl:when>
				<xsl:otherwise>fo:block</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="title_styles">
			<styles xsl:use-attribute-sets="title-style"><xsl:call-template name="refine_title-style"/></styles>
		</xsl:variable>
		
		<xsl:element name="{$element-name}">
			<xsl:copy-of select="xalan:nodeset($title_styles)/styles/@*"/>
			
			<xsl:apply-templates />
			<xsl:apply-templates select="following-sibling::*[1][mn:variant-title][@type = 'sub']" mode="subtitle"/>
		</xsl:element>
		
		<xsl:if test="$element-name = 'fo:inline' and not(following-sibling::mn:p)">
			<fo:block><xsl:value-of select="$linebreak"/></fo:block>
		</xsl:if>
	</xsl:template>
	<!-- ====== -->
	<!-- ====== -->
	
	
	<xsl:template match="mn:p" name="paragraph">
		<xsl:param name="inline" select="'false'"/>
		<xsl:param name="split_keep-within-line"/>
		<xsl:variable name="previous-element" select="local-name(preceding-sibling::*[1])"/>
		<xsl:variable name="element-name">
			<xsl:choose>
				<xsl:when test="$inline = 'true'">fo:inline</xsl:when>
				<xsl:when test="../@inline-header = 'true' and $previous-element = 'fmt-title'">fo:inline</xsl:when> <!-- first paragraph after inline title -->
				<xsl:when test="parent::mn:admonition">fo:inline</xsl:when>
				<xsl:when test="ancestor::*[self::mn:recommendation or self::mn:requirement or self::mn:permission] and not(preceding-sibling::mn:p)">fo:inline</xsl:when>
				<xsl:otherwise>fo:block</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="p_styles">
			<styles xsl:use-attribute-sets="p-style">
				<xsl:call-template name="refine_p-style"><xsl:with-param name="element-name" select="$element-name"/></xsl:call-template>
			</styles>
		</xsl:variable>
		
		<xsl:element name="{$element-name}">
			<xsl:copy-of select="xalan:nodeset($p_styles)/styles/@*"/>
			
			<xsl:apply-templates>
				<xsl:with-param name="split_keep-within-line" select="$split_keep-within-line"/>
			</xsl:apply-templates>
		</xsl:element>
		<xsl:if test="$element-name = 'fo:inline' and not($inline = 'true') and not(parent::mn:admonition) and
		not(ancestor::*[self::mn:recommendation or self::mn:requirement or self::mn:permission])">
			<fo:block margin-bottom="12pt">
				<!--  <xsl:if test="ancestor::mn:annex">
					<xsl:attribute name="margin-bottom">0</xsl:attribute>
				 </xsl:if> -->
				<xsl:value-of select="$linebreak"/>
			</fo:block>
		</xsl:if>
		<xsl:if test="$inline = 'true'">
			<fo:block>&#xA0;</fo:block>
		</xsl:if>
	</xsl:template>
	

	<!-- note in list item -->
	<!-- <xsl:template match="mn:ul//mn:note  | mn:ol//mn:note" priority="2">
		<fo:block id="{@id}">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template> -->
	

	<xsl:template match="mn:li//mn:p//text()">
		<xsl:choose>
			<xsl:when test="contains(., '&#x9;')">
				<fo:inline white-space="pre"><xsl:value-of select="."/></fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="."/>
			</xsl:otherwise>
		</xsl:choose>		
	</xsl:template>
	

	
	<!-- <xsl:template match="mn:example/mn:p" priority="2">
			<fo:block-container xsl:use-attribute-sets="example-p-style">
				<fo:block-container margin-left="0mm">
					<fo:block>
						<xsl:apply-templates />
					</fo:block>
				</fo:block-container>
			</fo:block-container>
	</xsl:template> -->


	
	<xsl:template match="mn:pagebreak" priority="2">
		<xsl:copy-of select="."/>
	</xsl:template>
	
	<!-- https://github.com/metanorma/mn-native-pdf/issues/214 -->
	<xsl:template match="mn:index"/>
	
	
	<xsl:template name="insertHeaderFooter">
		<xsl:param name="title_header"/>
		<xsl:param name="docidentifier"/>
		<xsl:param name="edition"/>
		<xsl:param name="month_year"/>
		<xsl:param name="font-weight" select="'bold'"/>
		<xsl:param name="orientation"/>
		
		<xsl:call-template name="insertHeader">
			<xsl:with-param name="title_header" select="$title_header"/>
			<xsl:with-param name="orientation" select="$orientation"/>
		</xsl:call-template>
		
		<xsl:call-template name="insertFooter">
			<xsl:with-param name="docidentifier" select="$docidentifier"/>
			<xsl:with-param name="edition" select="$edition"/>
			<xsl:with-param name="month_year" select="$month_year"/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template name="insertHeader">
		<xsl:param name="title_header"/>
		<xsl:param name="orientation"/>
		<fo:static-content flow-name="header-odd" role="artifact">
			<fo:block-container height="100%" font-size="8pt">
				<fo:block padding-top="12.5mm">
					<fo:table table-layout="fixed" width="100%">
						<fo:table-column column-width="proportional-column-width(1)"/>
						<fo:table-column column-width="proportional-column-width(10)"/>
						<fo:table-column column-width="proportional-column-width(1)"/>
						<fo:table-body>
							<fo:table-row>
								<fo:table-cell><fo:block>&#xa0;</fo:block></fo:table-cell>
								<fo:table-cell text-align="center"><fo:block><xsl:copy-of select="$title_header"/></fo:block></fo:table-cell>
								<fo:table-cell text-align="right"><fo:block><fo:page-number /></fo:block></fo:table-cell>
							</fo:table-row>
						</fo:table-body>
					</fo:table>
				</fo:block>
			</fo:block-container>
		</fo:static-content>
		<fo:static-content flow-name="header-even" role="artifact">
			<fo:block-container height="100%" font-size="8pt">
				<fo:block padding-top="12.5mm">
					<fo:table table-layout="fixed" width="100%">
						<fo:table-column column-width="proportional-column-width(1)"/>
						<fo:table-column column-width="proportional-column-width(10)"/>
						<fo:table-column column-width="proportional-column-width(1)"/>
						<fo:table-body>
							<fo:table-row>
								<fo:table-cell><fo:block><fo:page-number /></fo:block></fo:table-cell>
								<fo:table-cell text-align="center"><fo:block><xsl:copy-of select="$title_header"/></fo:block></fo:table-cell>
								<fo:table-cell><fo:block>&#xa0;</fo:block></fo:table-cell>
							</fo:table-row>
						</fo:table-body>
					</fo:table>
				</fo:block>
			</fo:block-container>
		</fo:static-content>
		<xsl:call-template name="insertHeaderBlank">
			<xsl:with-param name="title_header" select="$title_header"/>
			<xsl:with-param name="orientation" select="$orientation"/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template name="insertHeaderBlank">
		<xsl:param name="title_header"/>
		<xsl:param name="orientation"/>
		<fo:static-content flow-name="header-blank" role="artifact">
			<fo:block-container height="100%" font-size="8pt">
				<fo:block padding-top="12.5mm">
					<fo:table table-layout="fixed" width="100%">
						<fo:table-column column-width="proportional-column-width(1)"/>
						<fo:table-column column-width="proportional-column-width(10)"/>
						<fo:table-column column-width="proportional-column-width(1)"/>
						<fo:table-body>
							<fo:table-row>
								<fo:table-cell><fo:block><fo:page-number /></fo:block></fo:table-cell>
								<fo:table-cell text-align="center"><fo:block><xsl:copy-of select="$title_header"/></fo:block></fo:table-cell>
								<fo:table-cell><fo:block>&#xa0;</fo:block></fo:table-cell>
							</fo:table-row>
						</fo:table-body>
					</fo:table>
				</fo:block>
			</fo:block-container>
			<fo:block-container position="absolute" left="40.5mm" top="130mm" height="4mm" width="79mm" border="0.75pt solid black" text-align="center" display-align="center" line-height="100%">
				<xsl:if test="$orientation = '-landscape'">
					<xsl:attribute name="left">84mm</xsl:attribute>
					<xsl:attribute name="top">87mm</xsl:attribute>
				</xsl:if>
				<fo:block>Page intentionally left blank</fo:block>
			</fo:block-container>
		</fo:static-content>
	</xsl:template>
	
	<xsl:template name="insertFooter">
		<xsl:param name="docidentifier"/>
		<xsl:param name="edition"/>
		<xsl:param name="month_year"/>
		<fo:static-content flow-name="footer" role="artifact">
			<fo:block-container height="100%" display-align="after">
				<fo:block padding-bottom="12.5mm" font-size="8pt" text-align-last="justify">
					<fo:inline><xsl:value-of select="$docidentifier" /></fo:inline>
					<fo:inline keep-together.within-line="always">
						<fo:leader leader-pattern="space"/>
						<fo:inline>&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;<xsl:value-of select="$month_year" /></fo:inline>
					</fo:inline>						
					<fo:inline keep-together.within-line="always">
						<fo:leader leader-pattern="space"/>
						<fo:inline><xsl:value-of select="$edition" /></fo:inline>
					</fo:inline>						
				</fo:block>
			</fo:block-container>
		</fo:static-content>
	</xsl:template>
	
	<xsl:template name="insertHeaderFooterBlank">
		<xsl:param name="title_header"/>
		<xsl:param name="docidentifier"/>
		<xsl:param name="edition"/>
		<xsl:param name="month_year"/>
		<xsl:call-template name="insertHeaderBlank">
			<xsl:with-param name="title_header" select="$title_header"/>
		</xsl:call-template>
		<xsl:call-template name="insertFooter">
			<xsl:with-param name="docidentifier" select="$docidentifier"/>
			<xsl:with-param name="edition" select="$edition"/>
			<xsl:with-param name="month_year" select="$month_year"/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:variable name="Image-IHO-SVG">
		<xsl:choose>
			<xsl:when test="$lang = 'es' or $lang = 'fr'">
				<svg id="uuid-77734ae3-e014-495b-ac9d-44601be3ed54" xmlns="http://www.w3.org/2000/svg" width="235.3mm" height="235.3mm" viewBox="0 0 667 667">
					<rect width="667" height="667" style="fill:#01a9aa;"/>
					<path d="M292.18,332.88c0,49.89-35.07,84.97-84.97,84.97s-84.72-35.07-84.72-86.2,34.58-85.95,84.72-85.95,84.97,34.83,84.97,87.19ZM173.62,331.64c0,27.42,13.09,44.95,33.84,44.95s33.59-17.54,33.59-44.46-13.09-45.2-33.84-45.2-33.59,17.54-33.59,44.71Z" style="fill:#fff;"/>
					<path d="M356.97,348.93v65.21h-49.4v-164.75h49.4v55.82h47.42v-55.82h49.4v164.75h-49.4v-65.21h-47.42Z" style="fill:#fff;"/>
					<path d="M533.35,414.14h-51.13v-164.75h51.13v164.75Z" style="fill:#fff;"/>
				</svg>
			</xsl:when>
			<xsl:otherwise> <!-- default 'en' -->
				<svg id="uuid-f75324d8-fec1-4d12-b47f-c98c06f1dded" xmlns="http://www.w3.org/2000/svg" width="235.3mm" height="235.3mm" viewBox="0 0 667 667">
					<rect width="667" height="667" style="fill:#01a9aa;"/>
					<path d="M183.55,413.03h-51.13v-164.75h51.13v164.75Z" style="fill:#fff;"/>
					<path d="M259.62,347.82v65.21h-49.4v-164.75h49.4v55.82h47.42v-55.82h49.4v164.75h-49.4v-65.21h-47.42Z" style="fill:#fff;"/>
					<path d="M536.65,331.77c0,49.89-35.07,84.97-84.97,84.97s-84.72-35.07-84.72-86.2,34.58-85.95,84.72-85.95,84.97,34.83,84.97,87.19ZM418.1,330.53c0,27.42,13.09,44.95,33.84,44.95s33.59-17.54,33.59-44.46-13.09-45.2-33.84-45.2-33.59,17.54-33.59,44.71Z" style="fill:#fff;"/>
				</svg>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="Image-Logo-IHO-SVG">
		<svg id="uuid-36096db9-e6d6-4ead-b6c6-4aee04678126" xmlns="http://www.w3.org/2000/svg" width="235.3mm" height="235.3mm" viewBox="0 0 667 667">
			<rect width="667" height="667" style="fill:#00154c;"/>
			<path d="M345.73,314.66v-75.32c-4.09-.54-8.25-.82-12.48-.82s-8.57.3-12.73.86v75.28h25.22Z" style="fill:#fdda5a;"/>
			<path d="M215.62,172.83l9.45,13,95.44,7.97v9.33c4.21-.4,8.45-.61,12.73-.61s8.36.2,12.48.59v-9.31l93.48-7.68,10.74-13.29-104.22-8.45v-7.09c8.47-4.6,14.23-13.57,14.23-23.89,0-15-12.16-27.16-27.16-27.16s-27.16,12.16-27.16,27.16c0,3.66.74,7.15,2.05,10.33,4.9-3.49,9.75-6.94,13.33-9.49,0-.12-.02-.23-.02-.35,0-6.52,5.29-11.81,11.81-11.81s11.81,5.29,11.81,11.81c0,4.99-3.09,9.24-7.46,10.98l-2.47,1.76-14.87,10.62c.22.12.44.25.67.37v6.76l-104.89,8.45Z" style="fill:#fdda5a;"/>
			<path d="M362.63,311.41c-.73-.06-1.45-.05-2.17-.01-2.24-5.11-4.71-10.73-6.47-14.73,2.05-.98,3.92-2.4,5.45-4.28,5.55-6.8,4.54-16.81-2.26-22.36-1.02-.83-3.22-2.99-5.58-5.31v9.72c.44.4.82.74,1.15,1,3.8,3.1,4.37,8.71,1.27,12.51-.68.84-1.51,1.52-2.41,2.05v24.68s0,0,0,.02c-3.4,2.64-5.74,6.63-6.11,11.25-.23,2.86-2.46,13.85-2.76,17.56-.55,6.7,3.16,12.76,8.85,15.55-.63,3.84-1.31,8.05-1.95,11.98-5.46.88-10.3,4.59-12.37,10.14-1,2.69-6.13,12.65-7.43,16.14-2.18,5.86-.67,12.19,3.35,16.45-1.95,3.31-4.1,6.95-6.11,10.37-.81-.13-1.62-.19-2.43-.19-5.07,0-10.05,2.42-13.13,6.91-1.62,2.37-9.01,10.8-11.11,13.87-4.15,6.06-3.52,13.96,1.03,19.29l-3.82,5.59,9.38,2.97,2.38-3.53c1.36.37,2.74.56,4.13.56,5.07,0,10.05-2.42,13.13-6.91,1.62-2.37,9.01-10.8,11.11-13.87,4.5-6.57,3.38-15.3-2.26-20.57,1.93-3.28,3.96-6.73,5.81-9.89,1.15.26,2.3.4,3.44.4,6.45,0,12.51-3.95,14.9-10.35,1-2.69,6.13-12.65,7.43-16.14,2.92-7.82-.73-16.47-8.17-19.94.63-3.87,1.3-8.01,1.91-11.81,7.2-1.01,13.01-6.89,13.63-14.44.23-2.86,2.46-13.85,2.76-17.56.71-8.75-5.8-16.42-14.55-17.13ZM331.95,444.89c-.94,1.37-3.63,4.62-5.8,7.23-2.71,3.27-4.42,5.34-5.31,6.64-1.62,2.36-4.27,3.78-7.13,3.86l2.71-4.03h0c.32-.57.53-1.2.59-1.88.22-2.57-1.68-4.83-4.25-5.05-1.67-.14-3.2.62-4.14,1.87h0s-2.98,4.35-2.98,4.35c-.41-.78-.7-1.62-.87-2.51-.44-2.34.06-4.7,1.41-6.66.94-1.37,3.63-4.62,5.8-7.23,2.71-3.27,4.42-5.34,5.31-6.64,1.34-1.95,3.39-3.25,5.67-3.69-1.94,3.29-3.34,5.68-3.66,6.23-1.29,2.23-.52,5.09,1.71,6.38s5.09.52,6.38-1.71c.18-.31,1.95-3.32,4.38-7.46,2.19,2.96,2.39,7.1.19,10.31ZM360.24,383.04c.99,2.16,1.07,4.58.24,6.8-.58,1.55-2.41,5.36-3.88,8.41-1.84,3.83-3,6.25-3.55,7.73-1.24,3.32-4.36,5.57-7.87,5.76,1.06-1.8,1.89-3.21,2.37-4.03.15-.2.27-.42.38-.65.05-.09.08-.14.08-.14h0c.27-.59.42-1.24.42-1.92,0-2.58-2.09-4.67-4.67-4.67-1.68,0-3.14.89-3.96,2.22h0s-1.11,1.87-2.79,4.73c-1.26-2.21-1.57-4.95-.62-7.51.58-1.55,2.41-5.36,3.88-8.41,1.84-3.83,3-6.25,3.55-7.73.83-2.22,2.5-3.96,4.57-4.94-.6,3.7-1.03,6.38-1.13,7-.39,2.55,1.36,4.93,3.91,5.33,2.55.39,4.93-1.36,5.33-3.91.05-.32.52-3.23,1.18-7.34,1.09.86,1.97,1.97,2.56,3.27ZM370.2,327.98c-.13,1.65-.86,5.81-1.45,9.15-.73,4.18-1.19,6.83-1.32,8.41-.28,3.42-2.47,6.23-5.43,7.47.38-2.33.68-4.18.84-5.2.06-.24.1-.49.12-.74.02-.1.03-.16.03-.16h0c.04-.64-.05-1.3-.3-1.94-.94-2.4-3.64-3.59-6.05-2.66-1.56.61-2.6,1.97-2.89,3.51h0s-.37,2.28-.94,5.76c-2.1-1.79-3.34-4.52-3.1-7.48.13-1.65.86-5.81,1.45-9.15.73-4.18,1.19-6.83,1.32-8.41.16-1.99.98-3.76,2.21-5.15,1.07,2.38,2.1,4.72,2.45,5.74.85,2.44,3.51,3.73,5.94,2.88,2.44-.85,3.73-3.51,2.88-5.94-.09-.26-1-2.36-2.31-5.38,4.07,1.09,6.91,4.96,6.56,9.31Z" style="fill:#fdda5a;"/>
			<path d="M314.84,237.85c-.99-2.69-3.59-13.6-4.88-17.09-2.29-6.22-8.08-10.14-14.32-10.38-.78-2.82-1.62-5.9-2.45-8.93,1.25-.85,2.37-1.87,3.34-3.04-8.7-.79-17.64-1.59-26.13-2.35,2.25,4.03,6.23,7.05,11.14,7.9.92.16,1.83.24,2.74.24.79,2.91,1.6,5.85,2.34,8.58-6.26,3.9-9.14,11.78-6.49,18.97.99,2.69,3.59,13.6,4.88,17.09,2.37,6.42,8.45,10.4,14.91,10.4,1.83,0,3.68-.32,5.49-.98.65-.24,1.26-.52,1.85-.83,2.62,2.56,5.5,5.37,8.24,8.05v-13.04c-.54-.53-1.08-1.05-1.61-1.57,2.08-3.87,2.57-8.58.93-13.02ZM304.96,242.14c-.16-.19-.35-.36-.54-.53-.07-.07-.12-.12-.12-.12h0c-.51-.39-1.1-.7-1.76-.87-.37-.09-.75-.14-1.12-.14-2.1,0-4.01,1.43-4.53,3.56-.4,1.63.12,3.26,1.21,4.38h0s1.45,1.42,3.68,3.6c-.61.13-1.22.2-1.84.2-3.71,0-7.06-2.34-8.35-5.82-.57-1.56-1.66-5.63-2.54-8.91-1.1-4.1-1.8-6.69-2.34-8.18-1.21-3.29-.34-6.84,1.93-9.22.69,2.53,1.18,4.3,1.32,4.78.7,2.48,3.28,3.92,5.77,3.22,2.48-.7,3.92-3.28,3.22-5.77-.07-.24-.55-1.98-1.26-4.59,2.6.81,4.75,2.78,5.72,5.42.57,1.56,1.66,5.63,2.54,8.91,1.1,4.1,1.8,6.69,2.34,8.18.64,1.74.72,3.59.25,5.35-1.6-1.56-2.85-2.78-3.56-3.47Z" style="fill:#fdda5a;"/>
			<path d="M330.34,135.59c-1.53-.68-3.23-.46-4.52.42h0s-15.71,11.17-25.45,18.12c-2.22-2.17-5.09-3.72-8.37-4.29-.92-.16-1.84-.24-2.75-.24-7.58,0-14.29,5.44-15.64,13.16-.01.07-.03.15-.04.23l7.37-.62c1.28-3.42,4.55-5.77,8.31-5.77.51,0,1.03.05,1.55.14,1.37.24,2.63.79,3.71,1.58-.8.57-1.37.98-1.59,1.14-.73.53-1.26,1.24-1.57,2.03l16.79-1.42c8.43-6.02,19.71-14.07,22.68-16.19.22-.13.42-.28.61-.44.08-.06.14-.1.14-.1h0c.48-.43.89-.96,1.17-1.59,1.05-2.36,0-5.12-2.36-6.17Z" style="fill:#fdda5a;"/>
			<path d="M367.51,382.73v8.09c.73-2.73.68-5.5,0-8.09Z" style="fill:#fdda5a;"/>
			<path d="M324.31,418.97l2.83-4.8c-3.54-5.48-4.34-12.31-2-18.58.77-2.07,2.57-5.81,4.31-9.43,1.28-2.66,2.73-5.67,3.12-6.71,2.18-5.85,6.86-10.37,12.65-12.41l.51-3.1v-2.66c-3.4-2.64-5.88-6.22-7.12-10.27h-18.09v68.37c1.24-.25,2.51-.39,3.8-.41Z" style="fill:#fdda5a;"/>
			<path d="M298.14,346h39.57c-.03-.46-.04-.93-.03-1.4,0-.01,0-.03,0-.04,0-.48.03-.96.07-1.45.18-2.2.9-6.29,1.59-10.25.51-2.91,1.09-6.2,1.18-7.31.05-.56.12-1.11.21-1.65.05-.28.11-.56.17-.84.05-.24.1-.47.16-.71.09-.37.19-.74.3-1.1.03-.11.07-.22.1-.33.14-.43.28-.85.45-1.26h0s-43.76,0-43.76,0v-55.42h-28.77v138.67h28.77v-56.91Z" style="fill:#fdda5a;"/>
			<path d="M367.51,264.24v13.63c.07.31.12.62.18.94.04.21.07.43.1.64.07.5.12.99.16,1.49.01.18.02.37.03.55.02.56.02,1.11,0,1.67,0,.14,0,.28-.02.42-.06,1.08-.21,2.16-.44,3.23v20.48c.2.06.39.14.58.2.36.12.71.25,1.06.39.23.09.45.19.68.29.32.14.64.3.96.45.2.1.41.2.61.31.49.27.96.55,1.43.85.1.06.19.13.28.2.39.27.77.55,1.15.84.15.12.31.25.46.38.32.27.63.55.94.83.13.13.27.25.4.38.42.42.83.85,1.22,1.31,3.61,4.25,5.35,9.66,4.9,15.22-.18,2.2-.9,6.29-1.59,10.25-.51,2.91-1.09,6.2-1.18,7.31-.04.51-.1,1.01-.18,1.5-.03.17-.06.34-.09.5-.06.32-.11.64-.19.96-.05.2-.1.4-.15.6-.07.27-.14.55-.22.81-.07.22-.14.43-.21.65-.08.24-.17.48-.26.72-.09.23-.18.45-.27.67-.09.22-.18.43-.28.64-.11.24-.22.47-.33.7-.09.18-.19.36-.29.55-.13.25-.27.49-.41.73-.08.14-.18.28-.26.42-.17.27-.34.54-.52.8-.05.07-.1.13-.15.2-1.27,1.78-2.8,3.34-4.56,4.64,0,0,0,0,0,0-.35.26-.72.51-1.09.75-.01,0-.03.02-.04.03-.37.24-.75.46-1.13.67-.01,0-.03.01-.04.02-.39.22-.79.42-1.2.61v8.95c1.6,1.75,2.88,3.76,3.8,5.92,0,.01.01.03.02.04.16.38.31.76.44,1.15.03.1.07.19.1.29.12.35.23.71.33,1.07.04.13.07.27.11.41.09.34.18.69.25,1.03.03.16.06.31.09.47.19,1.04.31,2.1.34,3.16,0,.28.02.57.02.85,0,.24-.02.47-.03.71-.01.3-.03.6-.06.9-.02.23-.04.45-.07.68-.04.32-.09.63-.14.95-.04.21-.07.42-.11.63-.07.35-.16.7-.25,1.05-.04.17-.08.35-.13.52-.15.52-.31,1.04-.51,1.56-.09.25-.21.53-.33.83-.04.1-.09.21-.13.32-.09.21-.17.42-.27.64-.06.14-.13.3-.2.44-.09.21-.18.41-.28.63-.08.17-.16.35-.24.52-.1.21-.19.42-.29.64-.09.2-.19.41-.29.61-.09.2-.19.4-.28.61-.11.23-.22.47-.33.71-.09.19-.18.38-.27.57-.12.26-.25.51-.37.77-.09.18-.17.36-.26.54-.16.32-.31.65-.47.97-.01.03-.03.06-.04.09h28.6v-138.67h-28.77Z" style="fill:#fdda5a;"/>
			<path d="M297.62,453.35s0,0,0,0c0,0,0-.02,0-.02,0,0,0,.02,0,.02Z" style="fill:#fdda5a;"/>
			<path d="M292.72,451.78s0,0,0,0c.03-.38.08-.76.14-1.14.01-.07.02-.15.03-.22.05-.34.12-.68.19-1.01.02-.12.05-.23.07-.35.07-.31.15-.61.23-.91.04-.15.08-.3.13-.45.08-.28.17-.55.26-.82.06-.18.13-.36.2-.54.09-.24.18-.49.29-.73.09-.21.19-.42.28-.63.1-.21.19-.42.29-.62.13-.26.27-.51.41-.76.09-.16.17-.32.26-.47.24-.41.49-.81.77-1.21,1.25-1.82,3.9-5.02,6.46-8.11.31-.38.63-.76.95-1.14.02-.03.05-.06.07-.09.32-.39.64-.78.96-1.16-42.43-12.35-73.44-51.51-73.44-97.93,0-36.15,18.81-67.91,47.18-86.02-1.73-6.25-3.75-14.28-4.7-16.85-.77-2.1-1.2-4.25-1.32-6.37-9.98,5.58-19.26,12.56-27.56,20.87-23.61,23.61-36.61,54.99-36.61,88.37s13,64.77,36.61,88.37c13.7,13.7,30.03,23.82,47.85,29.91Z" style="fill:#fdda5a;"/>
			<path d="M482.4,415.39l-7.09,12.11,8.27,4.73s-91.47,40.65-137.86,48.14v-22.51c28.67-2.82,55.25-15.35,75.89-35.99,23.61-23.61,36.61-54.99,36.61-88.37s-13-64.77-36.61-88.37c-23.61-23.61-54.99-36.61-88.37-36.61-7.28,0-14.47.62-21.51,1.83,1.14,1.58,2.1,3.32,2.81,5.24,1.18,3.21,3.18,11,4.77,16.88,4.55-.62,9.2-.95,13.93-.95,56.32,0,101.98,45.66,101.98,101.98,0,52.26-39.32,95.34-89.99,101.27-.11.01-.21.02-.32.03.03.12.05.24.08.36.08.33.15.66.21.99.03.17.06.34.09.5.05.35.1.7.14,1.06h0c.01.13.03.25.04.38,0,0,0,.01,0,.02.03.4.05.8.06,1.2,0,.16,0,.32,0,.49,0,.34,0,.68-.02,1.02,0,.12,0,.25-.02.37-.03.44-.07.88-.13,1.32-.02.14-.04.28-.06.42-.05.35-.11.69-.18,1.04-.03.13-.05.25-.08.38-.1.44-.21.89-.34,1.33-.02.06-.04.12-.06.19-.01.04-.03.09-.04.13-.11.36-.23.72-.37,1.07-.05.12-.09.24-.14.37-.17.44-.36.88-.56,1.31-.03.06-.07.13-.1.19-.18.38-.38.75-.59,1.12-.07.12-.13.23-.2.35-.25.42-.51.85-.79,1.26-.15.21-.31.45-.5.7-.06.09-.14.18-.2.27-.13.17-.25.34-.39.52-.09.11-.18.23-.27.34-.08.11-.17.22-.26.34-.05.07-.1.13-.16.2-.1.13-.21.26-.31.39-.14.18-.29.37-.44.55-.11.14-.23.28-.34.43-.15.19-.31.38-.46.57-.13.16-.25.31-.38.47-.11.14-.23.28-.34.41-.42.52-.86,1.04-1.3,1.57h0c-.37.45-.74.89-1.11,1.34-1.88,2.27-4.02,4.85-4.65,5.76-2.53,3.69-6.13,6.41-10.23,7.87v7c-3.52-.56-7.3-1.3-11.27-2.2l-.2.29-3.57-1.13-.61-.19c-49.1-12.02-123.43-44.64-123.43-44.64l9.43-5.6-7.97-12.7-49.16,27.97,9.75,14.84,14.4-9.53,175.37,112.61,174.56-112.24,14.77,8.86,8.57-13.88-48.73-27.47Z" style="fill:#fdda5a;"/>
		</svg>
	</xsl:variable>
	
	<xsl:variable name="Image-Text-IHO-SVG">
		<xsl:choose>
			<xsl:when test="$lang = 'es'">
				<svg id="uuid-0d4fc8fd-8217-4339-8f76-2243238eb027" xmlns="http://www.w3.org/2000/svg" width="235.3mm" height="235.3mm" viewBox="0 0 667 667">
					<rect width="667" height="667" style="fill:#f0ebd8;"/>
					<path d="M109.69,232.12c1.04-3.3,2.59-6.23,4.66-8.77,2.07-2.54,4.67-4.56,7.81-6.07,3.13-1.5,6.77-2.26,10.92-2.26s7.77.75,10.88,2.26,5.7,3.53,7.77,6.07c2.07,2.54,3.63,5.46,4.66,8.77,1.04,3.31,1.55,6.78,1.55,10.43s-.52,7.13-1.55,10.43c-1.04,3.31-2.59,6.22-4.66,8.73-2.07,2.52-4.66,4.53-7.77,6.03s-6.73,2.26-10.88,2.26-7.78-.75-10.92-2.26c-3.13-1.5-5.74-3.51-7.81-6.03-2.07-2.52-3.63-5.43-4.66-8.73-1.04-3.3-1.55-6.78-1.55-10.43s.52-7.13,1.55-10.43ZM114.31,251.03c.76,2.79,1.95,5.28,3.55,7.47,1.6,2.2,3.66,3.96,6.18,5.29,2.52,1.33,5.52,2,9.03,2s6.5-.67,8.99-2c2.49-1.33,4.54-3.1,6.14-5.29,1.6-2.19,2.79-4.69,3.55-7.47s1.15-5.61,1.15-8.47-.38-5.75-1.15-8.51c-.76-2.76-1.95-5.24-3.55-7.44-1.6-2.19-3.65-3.96-6.14-5.29-2.49-1.33-5.49-2-8.99-2s-6.51.67-9.03,2c-2.52,1.33-4.58,3.1-6.18,5.29-1.6,2.2-2.79,4.67-3.55,7.44-.77,2.76-1.15,5.6-1.15,8.51s.38,5.69,1.15,8.47Z" style="fill:#00154c;"/>
					<path d="M172.37,230.79v8.95h.15c1.18-3.11,3.02-5.5,5.51-7.18,2.49-1.68,5.46-2.44,8.92-2.29v4.66c-2.12-.1-4.04.19-5.77.85-1.73.67-3.22,1.62-4.48,2.85-1.26,1.23-2.23,2.7-2.92,4.4-.69,1.7-1.04,3.56-1.04,5.59v20.35h-4.66v-38.18h4.29Z" style="fill:#00154c;"/>
					<path d="M225.9,273.49c-.62,2.27-1.59,4.19-2.92,5.77-1.33,1.58-3.07,2.79-5.22,3.63-2.15.84-4.77,1.26-7.88,1.26-1.92,0-3.8-.22-5.62-.67-1.83-.44-3.47-1.13-4.92-2.07-1.46-.94-2.66-2.13-3.63-3.59s-1.52-3.19-1.67-5.22h4.66c.25,1.43.73,2.63,1.44,3.59.71.96,1.58,1.74,2.59,2.33,1.01.59,2.13,1.02,3.37,1.29,1.23.27,2.49.41,3.77.41,4.34,0,7.47-1.23,9.4-3.7s2.89-6.02,2.89-10.66v-5.18h-.15c-1.08,2.37-2.68,4.27-4.77,5.7-2.1,1.43-4.55,2.15-7.36,2.15-3.06,0-5.67-.51-7.84-1.52-2.17-1.01-3.96-2.41-5.37-4.18-1.41-1.78-2.43-3.86-3.07-6.25-.64-2.39-.96-4.95-.96-7.66s.38-5.09,1.15-7.44c.76-2.34,1.87-4.39,3.33-6.14,1.45-1.75,3.26-3.13,5.4-4.14,2.15-1.01,4.6-1.52,7.36-1.52,1.43,0,2.78.2,4.03.59,1.26.4,2.41.95,3.44,1.67,1.04.72,1.96,1.54,2.77,2.48.81.94,1.44,1.92,1.89,2.96h.15v-6.59h4.66v35.08c0,2.81-.31,5.35-.92,7.62ZM215.21,263.31c1.53-.86,2.81-2,3.85-3.4,1.04-1.41,1.81-3.02,2.33-4.85.52-1.82.78-3.7.78-5.62s-.22-3.75-.67-5.62c-.44-1.87-1.16-3.58-2.15-5.11-.99-1.53-2.26-2.76-3.81-3.7-1.55-.94-3.44-1.41-5.66-1.41s-4.12.46-5.7,1.37c-1.58.91-2.89,2.11-3.92,3.59-1.04,1.48-1.79,3.17-2.26,5.07-.47,1.9-.7,3.84-.7,5.81s.25,3.8.74,5.62c.49,1.83,1.26,3.44,2.29,4.85,1.04,1.41,2.34,2.54,3.92,3.4,1.58.86,3.45,1.29,5.62,1.29,2.02,0,3.8-.43,5.33-1.29Z" style="fill:#00154c;"/>
					<path d="M239.85,236.71c.79-1.63,1.86-2.96,3.22-4,1.36-1.04,2.95-1.8,4.77-2.29,1.83-.49,3.85-.74,6.07-.74,1.68,0,3.35.16,5.03.48,1.68.32,3.18.92,4.51,1.81,1.33.89,2.42,2.13,3.26,3.74.84,1.6,1.26,3.69,1.26,6.25v20.28c0,1.88.91,2.81,2.74,2.81.54,0,1.04-.1,1.48-.3v3.92c-.54.1-1.02.17-1.44.22-.42.05-.95.07-1.59.07-1.18,0-2.13-.16-2.85-.48-.72-.32-1.27-.78-1.67-1.37-.4-.59-.66-1.29-.78-2.11-.12-.81-.18-1.71-.18-2.7h-.15c-.84,1.23-1.69,2.33-2.55,3.29-.86.96-1.83,1.76-2.89,2.41-1.06.64-2.27,1.13-3.63,1.48-1.36.34-2.97.52-4.85.52-1.78,0-3.44-.21-5-.63s-2.91-1.08-4.07-2c-1.16-.91-2.07-2.07-2.74-3.48-.67-1.41-1-3.07-1-5,0-2.66.59-4.75,1.78-6.25,1.18-1.5,2.75-2.65,4.7-3.44,1.95-.79,4.14-1.34,6.59-1.67,2.44-.32,4.92-.63,7.44-.92.99-.1,1.85-.22,2.59-.37s1.36-.41,1.85-.78.88-.88,1.15-1.52c.27-.64.41-1.48.41-2.52,0-1.58-.26-2.87-.78-3.89-.52-1.01-1.23-1.81-2.15-2.4-.91-.59-1.97-1-3.18-1.22-1.21-.22-2.5-.33-3.88-.33-2.96,0-5.38.7-7.25,2.11-1.88,1.41-2.86,3.66-2.96,6.77h-4.66c.15-2.22.62-4.14,1.41-5.77ZM263.16,248.1c-.3.54-.86.94-1.7,1.18-.84.25-1.58.42-2.22.52-1.97.35-4.01.65-6.11.92-2.1.27-4.01.68-5.73,1.22-1.73.54-3.15,1.32-4.25,2.33-1.11,1.01-1.67,2.45-1.67,4.33,0,1.18.23,2.23.7,3.14.47.91,1.1,1.7,1.89,2.37.79.67,1.7,1.17,2.74,1.52,1.04.35,2.1.52,3.18.52,1.78,0,3.48-.27,5.11-.81,1.63-.54,3.04-1.33,4.25-2.37,1.21-1.04,2.17-2.29,2.89-3.77.71-1.48,1.07-3.16,1.07-5.03v-6.07h-.15Z" style="fill:#00154c;"/>
					<path d="M285.07,230.79v6.59h.15c.89-2.32,2.47-4.18,4.74-5.59,2.27-1.41,4.76-2.11,7.47-2.11s4.9.35,6.7,1.04c1.8.69,3.24,1.67,4.33,2.92,1.08,1.26,1.85,2.8,2.29,4.62.44,1.83.67,3.87.67,6.14v24.57h-4.66v-23.83c0-1.63-.15-3.14-.44-4.55s-.81-2.63-1.55-3.66-1.74-1.85-3-2.44c-1.26-.59-2.82-.89-4.7-.89s-3.54.33-4.99,1c-1.46.67-2.69,1.58-3.7,2.74-1.01,1.16-1.8,2.54-2.37,4.14-.57,1.6-.88,3.34-.92,5.22v22.27h-4.66v-38.18h4.66Z" style="fill:#00154c;"/>
					<path d="M328.13,216.14v7.47h-4.66v-7.47h4.66ZM328.13,230.79v38.18h-4.66v-38.18h4.66Z" style="fill:#00154c;"/>
					<path d="M368.83,265.05v3.92h-31.89v-3.77l24.94-30.49h-23.24v-3.92h29.16v3.33l-25.23,30.93h26.27Z" style="fill:#00154c;"/>
					<path d="M378.67,236.71c.79-1.63,1.86-2.96,3.22-4,1.36-1.04,2.95-1.8,4.77-2.29,1.83-.49,3.85-.74,6.07-.74,1.68,0,3.35.16,5.03.48,1.68.32,3.18.92,4.51,1.81,1.33.89,2.42,2.13,3.26,3.74.84,1.6,1.26,3.69,1.26,6.25v20.28c0,1.88.91,2.81,2.74,2.81.54,0,1.04-.1,1.48-.3v3.92c-.54.1-1.02.17-1.44.22-.42.05-.95.07-1.59.07-1.18,0-2.13-.16-2.85-.48-.72-.32-1.27-.78-1.67-1.37-.4-.59-.66-1.29-.78-2.11-.12-.81-.18-1.71-.18-2.7h-.15c-.84,1.23-1.69,2.33-2.55,3.29-.86.96-1.83,1.76-2.89,2.41-1.06.64-2.27,1.13-3.63,1.48-1.36.34-2.97.52-4.85.52-1.78,0-3.44-.21-5-.63s-2.91-1.08-4.07-2c-1.16-.91-2.07-2.07-2.74-3.48-.67-1.41-1-3.07-1-5,0-2.66.59-4.75,1.78-6.25,1.18-1.5,2.75-2.65,4.7-3.44,1.95-.79,4.14-1.34,6.59-1.67,2.44-.32,4.92-.63,7.44-.92.99-.1,1.85-.22,2.59-.37s1.36-.41,1.85-.78.88-.88,1.15-1.52c.27-.64.41-1.48.41-2.52,0-1.58-.26-2.87-.78-3.89-.52-1.01-1.23-1.81-2.15-2.4-.91-.59-1.97-1-3.18-1.22-1.21-.22-2.5-.33-3.88-.33-2.96,0-5.38.7-7.25,2.11-1.88,1.41-2.86,3.66-2.96,6.77h-4.66c.15-2.22.62-4.14,1.41-5.77ZM401.98,248.1c-.3.54-.86.94-1.7,1.18-.84.25-1.58.42-2.22.52-1.97.35-4.01.65-6.11.92-2.1.27-4.01.68-5.73,1.22-1.73.54-3.15,1.32-4.25,2.33-1.11,1.01-1.67,2.45-1.67,4.33,0,1.18.23,2.23.7,3.14.47.91,1.1,1.7,1.89,2.37.79.67,1.7,1.17,2.74,1.52,1.04.35,2.1.52,3.18.52,1.78,0,3.48-.27,5.11-.81,1.63-.54,3.04-1.33,4.25-2.37,1.21-1.04,2.17-2.29,2.89-3.77.71-1.48,1.07-3.16,1.07-5.03v-6.07h-.15Z" style="fill:#00154c;"/>
					<path d="M442.68,236.04c-1.73-1.63-4.14-2.44-7.25-2.44-2.22,0-4.17.47-5.85,1.41-1.68.94-3.07,2.17-4.18,3.7-1.11,1.53-1.95,3.27-2.52,5.22-.57,1.95-.85,3.93-.85,5.96s.28,4.01.85,5.96c.57,1.95,1.41,3.69,2.52,5.22,1.11,1.53,2.5,2.76,4.18,3.7,1.68.94,3.63,1.41,5.85,1.41,1.43,0,2.79-.27,4.07-.81,1.28-.54,2.42-1.29,3.4-2.26.99-.96,1.8-2.11,2.44-3.44.64-1.33,1.04-2.79,1.18-4.37h4.66c-.64,4.64-2.34,8.25-5.11,10.84s-6.32,3.88-10.66,3.88c-2.91,0-5.49-.53-7.73-1.59-2.25-1.06-4.13-2.5-5.66-4.33-1.53-1.82-2.69-3.96-3.48-6.4-.79-2.44-1.18-5.04-1.18-7.81s.39-5.37,1.18-7.81c.79-2.44,1.95-4.58,3.48-6.4,1.53-1.82,3.42-3.28,5.66-4.37,2.24-1.08,4.82-1.63,7.73-1.63,4.09,0,7.56,1.09,10.4,3.26,2.84,2.17,4.53,5.45,5.07,9.84h-4.66c-.64-2.86-1.83-5.11-3.55-6.73Z" style="fill:#00154c;"/>
					<path d="M465.62,216.14v7.47h-4.66v-7.47h4.66ZM465.62,230.79v38.18h-4.66v-38.18h4.66Z" style="fill:#00154c;"/>
					<path d="M501.62,231.31c2.24,1.09,4.13,2.54,5.66,4.37,1.53,1.83,2.69,3.96,3.48,6.4.79,2.44,1.18,5.04,1.18,7.81s-.4,5.37-1.18,7.81c-.79,2.44-1.95,4.58-3.48,6.4-1.53,1.83-3.42,3.27-5.66,4.33-2.25,1.06-4.82,1.59-7.73,1.59s-5.49-.53-7.73-1.59c-2.25-1.06-4.13-2.5-5.66-4.33-1.53-1.82-2.69-3.96-3.48-6.4-.79-2.44-1.18-5.04-1.18-7.81s.39-5.37,1.18-7.81c.79-2.44,1.95-4.58,3.48-6.4,1.53-1.82,3.42-3.28,5.66-4.37,2.24-1.08,4.82-1.63,7.73-1.63s5.49.54,7.73,1.63ZM488.05,235.01c-1.68.94-3.07,2.17-4.18,3.7-1.11,1.53-1.95,3.27-2.52,5.22-.57,1.95-.85,3.93-.85,5.96s.28,4.01.85,5.96c.57,1.95,1.41,3.69,2.52,5.22,1.11,1.53,2.5,2.76,4.18,3.7,1.68.94,3.63,1.41,5.85,1.41s4.17-.47,5.85-1.41c1.68-.94,3.07-2.17,4.18-3.7,1.11-1.53,1.95-3.27,2.52-5.22.57-1.95.85-3.93.85-5.96s-.28-4.01-.85-5.96c-.57-1.95-1.41-3.69-2.52-5.22-1.11-1.53-2.5-2.76-4.18-3.7-1.68-.94-3.63-1.41-5.85-1.41s-4.17.47-5.85,1.41ZM489.53,225.46l7.77-10.43h5.77l-9.77,10.43h-3.77Z" style="fill:#00154c;"/>
					<path d="M526.67,230.79v6.59h.15c.89-2.32,2.47-4.18,4.74-5.59,2.27-1.41,4.76-2.11,7.47-2.11s4.9.35,6.7,1.04c1.8.69,3.24,1.67,4.33,2.92,1.08,1.26,1.85,2.8,2.29,4.62.44,1.83.67,3.87.67,6.14v24.57h-4.66v-23.83c0-1.63-.15-3.14-.44-4.55s-.81-2.63-1.55-3.66-1.74-1.85-3-2.44c-1.26-.59-2.82-.89-4.7-.89s-3.54.33-4.99,1c-1.46.67-2.69,1.58-3.7,2.74-1.01,1.16-1.8,2.54-2.37,4.14-.57,1.6-.88,3.34-.92,5.22v22.27h-4.66v-38.18h4.66Z" style="fill:#00154c;"/>
					<path d="M115.98,312.14v22.94h31.38v-22.94h5.03v52.84h-5.03v-25.6h-31.38v25.6h-5.03v-52.84h5.03Z" style="fill:#00154c;"/>
					<path d="M170.07,312.14v7.47h-4.66v-7.47h4.66ZM170.07,326.79v38.18h-4.66v-38.18h4.66Z" style="fill:#00154c;"/>
					<path d="M211.51,364.97v-7.25h-.15c-.49,1.23-1.22,2.37-2.18,3.4s-2.06,1.91-3.29,2.63c-1.23.72-2.55,1.27-3.96,1.67-1.41.39-2.8.59-4.18.59-2.91,0-5.44-.53-7.59-1.59-2.15-1.06-3.93-2.52-5.36-4.37-1.43-1.85-2.49-4-3.18-6.44-.69-2.44-1.04-5.02-1.04-7.73s.34-5.29,1.04-7.73c.69-2.44,1.75-4.59,3.18-6.44,1.43-1.85,3.22-3.32,5.36-4.4,2.15-1.08,4.67-1.63,7.59-1.63,1.43,0,2.82.17,4.18.52,1.36.35,2.63.88,3.81,1.59,1.18.72,2.23,1.59,3.15,2.63.91,1.04,1.62,2.25,2.11,3.63h.15v-21.9h4.66v52.84h-4.29ZM185.94,351.76c.47,1.95,1.21,3.69,2.22,5.22,1.01,1.53,2.3,2.78,3.88,3.74,1.58.96,3.48,1.44,5.7,1.44,2.47,0,4.55-.48,6.25-1.44,1.7-.96,3.08-2.21,4.14-3.74,1.06-1.53,1.82-3.27,2.29-5.22.47-1.95.7-3.91.7-5.88s-.23-3.93-.7-5.88c-.47-1.95-1.23-3.69-2.29-5.22-1.06-1.53-2.44-2.77-4.14-3.74-1.7-.96-3.79-1.44-6.25-1.44-2.22,0-4.12.48-5.7,1.44-1.58.96-2.88,2.21-3.88,3.74-1.01,1.53-1.75,3.27-2.22,5.22-.47,1.95-.7,3.91-.7,5.88s.23,3.93.7,5.88Z" style="fill:#00154c;"/>
					<path d="M232.16,326.79v8.95h.15c1.18-3.11,3.02-5.5,5.51-7.18,2.49-1.68,5.46-2.44,8.92-2.29v4.66c-2.12-.1-4.04.18-5.77.85-1.73.67-3.22,1.62-4.48,2.85-1.26,1.23-2.23,2.7-2.92,4.4-.69,1.7-1.04,3.56-1.04,5.59v20.35h-4.66v-38.18h4.29Z" style="fill:#00154c;"/>
					<path d="M276.89,327.31c2.24,1.09,4.13,2.54,5.66,4.37,1.53,1.83,2.69,3.96,3.48,6.4.79,2.44,1.18,5.04,1.18,7.81s-.4,5.37-1.18,7.81c-.79,2.44-1.95,4.58-3.48,6.4-1.53,1.83-3.42,3.27-5.66,4.33-2.25,1.06-4.82,1.59-7.73,1.59s-5.49-.53-7.73-1.59c-2.25-1.06-4.13-2.5-5.66-4.33s-2.69-3.96-3.48-6.4c-.79-2.44-1.18-5.04-1.18-7.81s.39-5.37,1.18-7.81c.79-2.44,1.95-4.58,3.48-6.4s3.42-3.28,5.66-4.37c2.24-1.08,4.82-1.63,7.73-1.63s5.49.54,7.73,1.63ZM263.31,331.01c-1.68.94-3.07,2.17-4.18,3.7s-1.95,3.27-2.52,5.22c-.57,1.95-.85,3.93-.85,5.96s.28,4.01.85,5.96c.57,1.95,1.41,3.69,2.52,5.22,1.11,1.53,2.5,2.76,4.18,3.7,1.68.94,3.63,1.41,5.85,1.41s4.17-.47,5.85-1.41c1.68-.94,3.07-2.17,4.18-3.7,1.11-1.53,1.95-3.27,2.52-5.22.57-1.95.85-3.93.85-5.96s-.28-4.01-.85-5.96c-.57-1.95-1.41-3.69-2.52-5.22-1.11-1.53-2.5-2.76-4.18-3.7-1.68-.94-3.63-1.41-5.85-1.41s-4.17.47-5.85,1.41Z" style="fill:#00154c;"/>
					<path d="M328.69,369.49c-.62,2.27-1.59,4.19-2.92,5.77-1.33,1.58-3.07,2.79-5.22,3.63-2.15.84-4.77,1.26-7.88,1.26-1.92,0-3.8-.22-5.62-.67s-3.47-1.14-4.92-2.07c-1.46-.94-2.66-2.13-3.63-3.59s-1.52-3.19-1.67-5.22h4.66c.25,1.43.73,2.63,1.44,3.59.71.96,1.58,1.74,2.59,2.33,1.01.59,2.13,1.02,3.37,1.29,1.23.27,2.49.41,3.77.41,4.34,0,7.47-1.23,9.4-3.7,1.92-2.47,2.89-6.02,2.89-10.66v-5.18h-.15c-1.08,2.37-2.68,4.27-4.77,5.7-2.1,1.43-4.55,2.15-7.36,2.15-3.06,0-5.67-.5-7.84-1.52-2.17-1.01-3.96-2.41-5.37-4.18-1.41-1.78-2.43-3.86-3.07-6.25-.64-2.39-.96-4.95-.96-7.66s.38-5.09,1.15-7.44c.76-2.34,1.87-4.39,3.33-6.14,1.45-1.75,3.26-3.13,5.4-4.14,2.15-1.01,4.6-1.52,7.36-1.52,1.43,0,2.78.2,4.03.59,1.26.4,2.41.95,3.44,1.67,1.04.72,1.96,1.54,2.77,2.48.81.94,1.44,1.92,1.89,2.96h.15v-6.59h4.66v35.08c0,2.81-.31,5.35-.92,7.62ZM318,359.31c1.53-.86,2.81-2,3.85-3.4,1.04-1.41,1.81-3.02,2.33-4.85.52-1.82.78-3.7.78-5.62s-.22-3.75-.67-5.62c-.44-1.87-1.16-3.58-2.15-5.11-.99-1.53-2.26-2.76-3.81-3.7-1.55-.94-3.44-1.41-5.66-1.41s-4.12.46-5.7,1.37c-1.58.91-2.89,2.11-3.92,3.59-1.04,1.48-1.79,3.17-2.26,5.07-.47,1.9-.7,3.84-.7,5.81s.25,3.8.74,5.62c.49,1.83,1.26,3.44,2.29,4.85,1.04,1.41,2.34,2.54,3.92,3.4,1.58.86,3.45,1.29,5.62,1.29,2.02,0,3.8-.43,5.33-1.29Z" style="fill:#00154c;"/>
					<path d="M345.97,326.79v8.95h.15c1.18-3.11,3.02-5.5,5.51-7.18,2.49-1.68,5.46-2.44,8.92-2.29v4.66c-2.12-.1-4.04.18-5.77.85-1.73.67-3.22,1.62-4.48,2.85-1.26,1.23-2.23,2.7-2.92,4.4-.69,1.7-1.04,3.56-1.04,5.59v20.35h-4.66v-38.18h4.29Z" style="fill:#00154c;"/>
					<path d="M369.13,332.71c.79-1.63,1.86-2.96,3.22-4,1.36-1.04,2.95-1.8,4.77-2.29,1.83-.49,3.85-.74,6.07-.74,1.68,0,3.35.16,5.03.48,1.68.32,3.18.92,4.51,1.81,1.33.89,2.42,2.13,3.26,3.74.84,1.6,1.26,3.69,1.26,6.25v20.28c0,1.88.91,2.81,2.74,2.81.54,0,1.04-.1,1.48-.3v3.92c-.54.1-1.02.17-1.44.22-.42.05-.95.07-1.59.07-1.18,0-2.13-.16-2.85-.48-.72-.32-1.27-.78-1.67-1.37-.4-.59-.66-1.29-.78-2.11-.12-.81-.18-1.71-.18-2.7h-.15c-.84,1.23-1.69,2.33-2.55,3.29-.86.96-1.83,1.76-2.89,2.41-1.06.64-2.27,1.13-3.63,1.48-1.36.34-2.97.52-4.85.52-1.78,0-3.44-.21-5-.63-1.55-.42-2.91-1.08-4.07-2-1.16-.91-2.07-2.07-2.74-3.48-.67-1.41-1-3.07-1-5,0-2.66.59-4.75,1.78-6.25,1.18-1.5,2.75-2.65,4.7-3.44,1.95-.79,4.14-1.34,6.59-1.67,2.44-.32,4.92-.63,7.44-.92.99-.1,1.85-.22,2.59-.37.74-.15,1.36-.41,1.85-.78s.88-.88,1.15-1.52c.27-.64.41-1.48.41-2.52,0-1.58-.26-2.87-.78-3.88-.52-1.01-1.23-1.81-2.15-2.41-.91-.59-1.97-1-3.18-1.22-1.21-.22-2.5-.33-3.88-.33-2.96,0-5.38.7-7.25,2.11-1.88,1.41-2.86,3.66-2.96,6.77h-4.66c.15-2.22.62-4.14,1.41-5.77ZM392.44,344.1c-.3.54-.86.94-1.7,1.18s-1.58.42-2.22.52c-1.97.35-4.01.65-6.11.92-2.1.27-4.01.68-5.73,1.22-1.73.54-3.15,1.32-4.25,2.33-1.11,1.01-1.67,2.46-1.67,4.33,0,1.18.23,2.23.7,3.15.47.91,1.1,1.7,1.89,2.37.79.67,1.7,1.17,2.74,1.52,1.04.35,2.1.52,3.18.52,1.78,0,3.48-.27,5.11-.81,1.63-.54,3.04-1.33,4.25-2.37,1.21-1.04,2.17-2.29,2.89-3.77.71-1.48,1.07-3.16,1.07-5.03v-6.07h-.15ZM378.53,321.46l7.77-10.43h5.77l-9.77,10.43h-3.77Z" style="fill:#00154c;"/>
					<path d="M416.93,330.71v34.26h-4.66v-34.26h-6.51v-3.92h6.51v-3.48c0-1.63.12-3.13.37-4.51.25-1.38.71-2.56,1.41-3.55.69-.99,1.64-1.75,2.85-2.29,1.21-.54,2.75-.81,4.62-.81.69,0,1.33.03,1.92.07.59.05,1.26.12,2,.22v4c-.64-.1-1.23-.18-1.78-.26s-1.08-.11-1.63-.11c-1.28,0-2.27.2-2.96.59-.69.39-1.2.92-1.52,1.59-.32.67-.51,1.44-.55,2.33-.05.89-.07,1.85-.07,2.89v3.33h7.55v3.92h-7.55Z" style="fill:#00154c;"/>
					<path d="M436.84,312.14v7.47h-4.66v-7.47h4.66ZM436.84,326.79v38.18h-4.66v-38.18h4.66Z" style="fill:#00154c;"/>
					<path d="M472.36,332.04c-1.73-1.63-4.14-2.44-7.25-2.44-2.22,0-4.17.47-5.85,1.41-1.68.94-3.07,2.17-4.18,3.7s-1.95,3.27-2.52,5.22c-.57,1.95-.85,3.93-.85,5.96s.28,4.01.85,5.96c.57,1.95,1.41,3.69,2.52,5.22,1.11,1.53,2.5,2.76,4.18,3.7,1.68.94,3.63,1.41,5.85,1.41,1.43,0,2.79-.27,4.07-.81,1.28-.54,2.42-1.29,3.4-2.26.99-.96,1.8-2.11,2.44-3.44.64-1.33,1.04-2.79,1.18-4.37h4.66c-.64,4.64-2.34,8.25-5.11,10.84-2.76,2.59-6.32,3.88-10.66,3.88-2.91,0-5.49-.53-7.73-1.59-2.25-1.06-4.13-2.5-5.66-4.33s-2.69-3.96-3.48-6.4c-.79-2.44-1.18-5.04-1.18-7.81s.39-5.37,1.18-7.81c.79-2.44,1.95-4.58,3.48-6.4s3.42-3.28,5.66-4.37c2.24-1.08,4.82-1.63,7.73-1.63,4.09,0,7.56,1.09,10.4,3.26,2.84,2.17,4.53,5.45,5.07,9.84h-4.66c-.64-2.86-1.83-5.11-3.55-6.73Z" style="fill:#00154c;"/>
					<path d="M491.52,332.71c.79-1.63,1.86-2.96,3.22-4,1.36-1.04,2.95-1.8,4.77-2.29,1.83-.49,3.85-.74,6.07-.74,1.68,0,3.35.16,5.03.48,1.68.32,3.18.92,4.51,1.81,1.33.89,2.42,2.13,3.26,3.74.84,1.6,1.26,3.69,1.26,6.25v20.28c0,1.88.91,2.81,2.74,2.81.54,0,1.04-.1,1.48-.3v3.92c-.54.1-1.02.17-1.44.22-.42.05-.95.07-1.59.07-1.18,0-2.13-.16-2.85-.48-.72-.32-1.27-.78-1.67-1.37-.4-.59-.66-1.29-.78-2.11-.12-.81-.18-1.71-.18-2.7h-.15c-.84,1.23-1.69,2.33-2.55,3.29-.86.96-1.83,1.76-2.89,2.41-1.06.64-2.27,1.13-3.63,1.48-1.36.34-2.97.52-4.85.52-1.78,0-3.44-.21-5-.63-1.55-.42-2.91-1.08-4.07-2-1.16-.91-2.07-2.07-2.74-3.48-.67-1.41-1-3.07-1-5,0-2.66.59-4.75,1.78-6.25,1.18-1.5,2.75-2.65,4.7-3.44,1.95-.79,4.14-1.34,6.59-1.67,2.44-.32,4.92-.63,7.44-.92.99-.1,1.85-.22,2.59-.37.74-.15,1.36-.41,1.85-.78s.88-.88,1.15-1.52c.27-.64.41-1.48.41-2.52,0-1.58-.26-2.87-.78-3.88-.52-1.01-1.23-1.81-2.15-2.41-.91-.59-1.97-1-3.18-1.22-1.21-.22-2.5-.33-3.88-.33-2.96,0-5.38.7-7.25,2.11-1.88,1.41-2.86,3.66-2.96,6.77h-4.66c.15-2.22.62-4.14,1.41-5.77ZM514.83,344.1c-.3.54-.86.94-1.7,1.18s-1.58.42-2.22.52c-1.97.35-4.01.65-6.11.92-2.1.27-4.01.68-5.73,1.22-1.73.54-3.15,1.32-4.25,2.33-1.11,1.01-1.67,2.46-1.67,4.33,0,1.18.23,2.23.7,3.15.47.91,1.1,1.7,1.89,2.37.79.67,1.7,1.17,2.74,1.52,1.04.35,2.1.52,3.18.52,1.78,0,3.48-.27,5.11-.81,1.63-.54,3.04-1.33,4.25-2.37,1.21-1.04,2.17-2.29,2.89-3.77.71-1.48,1.07-3.16,1.07-5.03v-6.07h-.15Z" style="fill:#00154c;"/>
					<path d="M116.35,408.14v52.84h-5.03v-52.84h5.03Z" style="fill:#00154c;"/>
					<path d="M134.25,422.79v6.59h.15c.89-2.32,2.47-4.18,4.74-5.59,2.27-1.41,4.76-2.11,7.47-2.11s4.9.35,6.7,1.04c1.8.69,3.24,1.67,4.33,2.92,1.08,1.26,1.85,2.8,2.29,4.62.44,1.83.67,3.87.67,6.14v24.57h-4.66v-23.83c0-1.63-.15-3.14-.44-4.55s-.81-2.63-1.55-3.66-1.74-1.85-3-2.44c-1.26-.59-2.82-.89-4.7-.89s-3.54.33-4.99,1c-1.46.67-2.69,1.58-3.7,2.74-1.01,1.16-1.8,2.54-2.37,4.14-.57,1.6-.88,3.34-.92,5.22v22.27h-4.66v-38.18h4.66Z" style="fill:#00154c;"/>
					<path d="M187.76,422.79v3.92h-7.77v25.75c0,1.53.21,2.73.63,3.59.42.86,1.47,1.34,3.15,1.44,1.33,0,2.66-.07,4-.22v3.92c-.69,0-1.38.02-2.07.07-.69.05-1.38.07-2.07.07-3.11,0-5.28-.6-6.51-1.81-1.23-1.21-1.83-3.44-1.78-6.7v-26.12h-6.66v-3.92h6.66v-11.47h4.66v11.47h7.77Z" style="fill:#00154c;"/>
					<path d="M201.11,448.36c.47,1.8,1.22,3.42,2.26,4.85s2.34,2.62,3.92,3.55c1.58.94,3.48,1.41,5.7,1.41,3.4,0,6.07-.89,7.99-2.66,1.92-1.78,3.26-4.14,4-7.1h4.66c-.99,4.34-2.8,7.7-5.44,10.06-2.64,2.37-6.38,3.55-11.21,3.55-3.01,0-5.61-.53-7.81-1.59-2.2-1.06-3.98-2.52-5.37-4.37-1.38-1.85-2.41-4-3.07-6.44-.67-2.44-1-5.02-1-7.73,0-2.52.33-4.98,1-7.4.67-2.42,1.69-4.58,3.07-6.47,1.38-1.9,3.17-3.43,5.37-4.59,2.19-1.16,4.8-1.74,7.81-1.74s5.67.62,7.84,1.85c2.17,1.23,3.93,2.85,5.29,4.85,1.36,2,2.33,4.29,2.92,6.88.59,2.59.84,5.22.74,7.88h-29.38c0,1.68.23,3.42.7,5.22ZM224.2,434.11c-.57-1.63-1.37-3.07-2.4-4.33-1.04-1.26-2.29-2.27-3.77-3.03-1.48-.76-3.16-1.15-5.03-1.15s-3.63.38-5.11,1.15c-1.48.76-2.74,1.78-3.77,3.03-1.04,1.26-1.86,2.71-2.48,4.37-.62,1.65-1.02,3.34-1.22,5.07h24.72c-.05-1.78-.36-3.48-.92-5.11Z" style="fill:#00154c;"/>
					<path d="M243.55,422.79v8.95h.15c1.18-3.11,3.02-5.5,5.51-7.18,2.49-1.68,5.46-2.44,8.92-2.29v4.66c-2.12-.1-4.04.18-5.77.85-1.73.67-3.22,1.62-4.48,2.85-1.26,1.23-2.23,2.7-2.92,4.4-.69,1.7-1.04,3.56-1.04,5.59v20.35h-4.66v-38.18h4.29Z" style="fill:#00154c;"/>
					<path d="M271.67,422.79v6.59h.15c.89-2.32,2.47-4.18,4.74-5.59,2.27-1.41,4.76-2.11,7.47-2.11s4.9.35,6.7,1.04c1.8.69,3.24,1.67,4.33,2.92,1.08,1.26,1.85,2.8,2.29,4.62.44,1.83.67,3.87.67,6.14v24.57h-4.66v-23.83c0-1.63-.15-3.14-.44-4.55s-.81-2.63-1.55-3.66-1.74-1.85-3-2.44c-1.26-.59-2.82-.89-4.7-.89s-3.54.33-4.99,1c-1.46.67-2.69,1.58-3.7,2.74-1.01,1.16-1.8,2.54-2.37,4.14-.57,1.6-.88,3.34-.92,5.22v22.27h-4.66v-38.18h4.66Z" style="fill:#00154c;"/>
					<path d="M310.96,428.71c.79-1.63,1.86-2.96,3.22-4,1.36-1.04,2.95-1.8,4.77-2.29s3.85-.74,6.07-.74c1.68,0,3.35.16,5.03.48,1.68.32,3.18.93,4.51,1.81s2.42,2.13,3.26,3.74c.84,1.6,1.26,3.69,1.26,6.25v20.28c0,1.88.91,2.81,2.74,2.81.54,0,1.04-.1,1.48-.3v3.92c-.54.1-1.02.17-1.44.22-.42.05-.95.07-1.59.07-1.18,0-2.13-.16-2.85-.48-.72-.32-1.27-.78-1.67-1.37-.4-.59-.66-1.29-.78-2.11-.12-.81-.18-1.71-.18-2.7h-.15c-.84,1.23-1.69,2.33-2.55,3.29-.86.96-1.83,1.76-2.89,2.41-1.06.64-2.27,1.13-3.63,1.48-1.36.34-2.97.52-4.85.52-1.78,0-3.44-.21-5-.63-1.55-.42-2.91-1.08-4.07-2-1.16-.91-2.07-2.07-2.74-3.48-.67-1.41-1-3.07-1-5,0-2.66.59-4.75,1.78-6.25,1.18-1.5,2.75-2.65,4.7-3.44,1.95-.79,4.14-1.34,6.59-1.67,2.44-.32,4.92-.63,7.44-.92.99-.1,1.85-.22,2.59-.37.74-.15,1.36-.41,1.85-.78s.88-.88,1.15-1.52c.27-.64.41-1.48.41-2.52,0-1.58-.26-2.87-.78-3.88-.52-1.01-1.23-1.81-2.15-2.41-.91-.59-1.97-1-3.18-1.22-1.21-.22-2.5-.33-3.88-.33-2.96,0-5.38.7-7.25,2.11-1.88,1.41-2.86,3.66-2.96,6.77h-4.66c.15-2.22.62-4.14,1.41-5.77ZM334.27,440.1c-.3.54-.86.94-1.7,1.18s-1.58.42-2.22.52c-1.97.35-4.01.65-6.11.92-2.1.27-4.01.68-5.73,1.22-1.73.54-3.15,1.32-4.25,2.33-1.11,1.01-1.67,2.46-1.67,4.33,0,1.18.23,2.23.7,3.15.47.91,1.1,1.7,1.89,2.37.79.67,1.7,1.17,2.74,1.52,1.04.35,2.1.52,3.18.52,1.78,0,3.48-.27,5.11-.81,1.63-.54,3.04-1.33,4.25-2.37,1.21-1.04,2.17-2.29,2.89-3.77.71-1.48,1.07-3.16,1.07-5.03v-6.07h-.15Z" style="fill:#00154c;"/>
					<path d="M374.97,428.04c-1.73-1.63-4.14-2.44-7.25-2.44-2.22,0-4.17.47-5.85,1.41-1.68.94-3.07,2.17-4.18,3.7s-1.95,3.27-2.52,5.22c-.57,1.95-.85,3.93-.85,5.96s.28,4.01.85,5.96c.57,1.95,1.41,3.69,2.52,5.22,1.11,1.53,2.5,2.76,4.18,3.7,1.68.94,3.63,1.41,5.85,1.41,1.43,0,2.79-.27,4.07-.81,1.28-.54,2.42-1.29,3.4-2.26.99-.96,1.8-2.11,2.44-3.44.64-1.33,1.04-2.79,1.18-4.37h4.66c-.64,4.64-2.34,8.25-5.11,10.84-2.76,2.59-6.32,3.88-10.66,3.88-2.91,0-5.49-.53-7.73-1.59-2.25-1.06-4.13-2.5-5.66-4.33s-2.69-3.96-3.48-6.4c-.79-2.44-1.18-5.04-1.18-7.81s.39-5.37,1.18-7.81c.79-2.44,1.95-4.58,3.48-6.4s3.42-3.28,5.66-4.37c2.24-1.08,4.82-1.63,7.73-1.63,4.09,0,7.56,1.09,10.4,3.26,2.84,2.17,4.53,5.45,5.07,9.84h-4.66c-.64-2.86-1.83-5.11-3.55-6.73Z" style="fill:#00154c;"/>
					<path d="M397.91,408.14v7.47h-4.66v-7.47h4.66ZM397.91,422.79v38.18h-4.66v-38.18h4.66Z" style="fill:#00154c;"/>
					<path d="M433.91,423.31c2.24,1.09,4.13,2.54,5.66,4.37,1.53,1.83,2.69,3.96,3.48,6.4.79,2.44,1.18,5.04,1.18,7.81s-.4,5.37-1.18,7.81c-.79,2.44-1.95,4.58-3.48,6.4-1.53,1.83-3.42,3.27-5.66,4.33-2.25,1.06-4.82,1.59-7.73,1.59s-5.49-.53-7.73-1.59c-2.25-1.06-4.13-2.5-5.66-4.33s-2.69-3.96-3.48-6.4c-.79-2.44-1.18-5.04-1.18-7.81s.39-5.37,1.18-7.81c.79-2.44,1.95-4.58,3.48-6.4s3.42-3.28,5.66-4.37c2.24-1.08,4.82-1.63,7.73-1.63s5.49.54,7.73,1.63ZM420.33,427.01c-1.68.94-3.07,2.17-4.18,3.7s-1.95,3.27-2.52,5.22c-.57,1.95-.85,3.93-.85,5.96s.28,4.01.85,5.96c.57,1.95,1.41,3.69,2.52,5.22,1.11,1.53,2.5,2.76,4.18,3.7,1.68.94,3.63,1.41,5.85,1.41s4.17-.47,5.85-1.41c1.68-.94,3.07-2.17,4.18-3.7,1.11-1.53,1.95-3.27,2.52-5.22.57-1.95.85-3.93.85-5.96s-.28-4.01-.85-5.96c-.57-1.95-1.41-3.69-2.52-5.22-1.11-1.53-2.5-2.76-4.18-3.7-1.68-.94-3.63-1.41-5.85-1.41s-4.17.47-5.85,1.41Z" style="fill:#00154c;"/>
					<path d="M458.96,422.79v6.59h.15c.89-2.32,2.47-4.18,4.74-5.59,2.27-1.41,4.76-2.11,7.47-2.11s4.9.35,6.7,1.04c1.8.69,3.24,1.67,4.33,2.92,1.08,1.26,1.85,2.8,2.29,4.62.44,1.83.67,3.87.67,6.14v24.57h-4.66v-23.83c0-1.63-.15-3.14-.44-4.55s-.81-2.63-1.55-3.66-1.74-1.85-3-2.44c-1.26-.59-2.82-.89-4.7-.89s-3.54.33-4.99,1c-1.46.67-2.69,1.58-3.7,2.74-1.01,1.16-1.8,2.54-2.37,4.14-.57,1.6-.88,3.34-.92,5.22v22.27h-4.66v-38.18h4.66Z" style="fill:#00154c;"/>
					<path d="M498.25,428.71c.79-1.63,1.86-2.96,3.22-4,1.36-1.04,2.95-1.8,4.77-2.29s3.85-.74,6.07-.74c1.68,0,3.35.16,5.03.48,1.68.32,3.18.93,4.51,1.81s2.42,2.13,3.26,3.74c.84,1.6,1.26,3.69,1.26,6.25v20.28c0,1.88.91,2.81,2.74,2.81.54,0,1.04-.1,1.48-.3v3.92c-.54.1-1.02.17-1.44.22-.42.05-.95.07-1.59.07-1.18,0-2.13-.16-2.85-.48-.72-.32-1.27-.78-1.67-1.37-.4-.59-.66-1.29-.78-2.11-.12-.81-.18-1.71-.18-2.7h-.15c-.84,1.23-1.69,2.33-2.55,3.29-.86.96-1.83,1.76-2.89,2.41-1.06.64-2.27,1.13-3.63,1.48-1.36.34-2.97.52-4.85.52-1.78,0-3.44-.21-5-.63-1.55-.42-2.91-1.08-4.07-2-1.16-.91-2.07-2.07-2.74-3.48-.67-1.41-1-3.07-1-5,0-2.66.59-4.75,1.78-6.25,1.18-1.5,2.75-2.65,4.7-3.44,1.95-.79,4.14-1.34,6.59-1.67,2.44-.32,4.92-.63,7.44-.92.99-.1,1.85-.22,2.59-.37.74-.15,1.36-.41,1.85-.78s.88-.88,1.15-1.52c.27-.64.41-1.48.41-2.52,0-1.58-.26-2.87-.78-3.88-.52-1.01-1.23-1.81-2.15-2.41-.91-.59-1.97-1-3.18-1.22-1.21-.22-2.5-.33-3.88-.33-2.96,0-5.38.7-7.25,2.11-1.88,1.41-2.86,3.66-2.96,6.77h-4.66c.15-2.22.62-4.14,1.41-5.77ZM521.56,440.1c-.3.54-.86.94-1.7,1.18s-1.58.42-2.22.52c-1.97.35-4.01.65-6.11.92-2.1.27-4.01.68-5.73,1.22-1.73.54-3.15,1.32-4.25,2.33-1.11,1.01-1.67,2.46-1.67,4.33,0,1.18.23,2.23.7,3.15.47.91,1.1,1.7,1.89,2.37.79.67,1.7,1.17,2.74,1.52,1.04.35,2.1.52,3.18.52,1.78,0,3.48-.27,5.11-.81,1.63-.54,3.04-1.33,4.25-2.37,1.21-1.04,2.17-2.29,2.89-3.77.71-1.48,1.07-3.16,1.07-5.03v-6.07h-.15Z" style="fill:#00154c;"/>
					<path d="M543.62,408.14v52.84h-4.66v-52.84h4.66Z" style="fill:#00154c;"/>
				</svg>
			</xsl:when>
			<xsl:when test="$lang = 'fr'">
				<svg id="uuid-f2eecaa4-7d5e-454f-aac7-8245ef180cc6" xmlns="http://www.w3.org/2000/svg" width="235.3mm" height="235.3mm" viewBox="0 0 667 667">
					<rect width="667" height="667" style="fill:#f0ebd8;"/>
					<path d="M72.4,235.12c1.04-3.3,2.59-6.23,4.66-8.77,2.07-2.54,4.67-4.56,7.81-6.07,3.13-1.5,6.77-2.26,10.92-2.26s7.77.75,10.88,2.26c3.11,1.51,5.7,3.53,7.77,6.07,2.07,2.54,3.63,5.46,4.66,8.77,1.04,3.31,1.55,6.78,1.55,10.43s-.52,7.13-1.55,10.43c-1.04,3.31-2.59,6.22-4.66,8.73-2.07,2.52-4.66,4.53-7.77,6.03-3.11,1.5-6.73,2.26-10.88,2.26s-7.78-.75-10.92-2.26c-3.13-1.5-5.74-3.51-7.81-6.03-2.07-2.52-3.63-5.43-4.66-8.73-1.04-3.3-1.55-6.78-1.55-10.43s.52-7.13,1.55-10.43ZM77.03,254.03c.76,2.79,1.95,5.28,3.55,7.47,1.6,2.2,3.66,3.96,6.18,5.29,2.52,1.33,5.52,2,9.03,2s6.5-.67,8.99-2c2.49-1.33,4.54-3.09,6.14-5.29,1.6-2.19,2.79-4.69,3.55-7.47.76-2.79,1.15-5.61,1.15-8.47s-.38-5.75-1.15-8.51c-.76-2.76-1.95-5.24-3.55-7.44-1.6-2.19-3.65-3.96-6.14-5.29-2.49-1.33-5.49-2-8.99-2s-6.51.67-9.03,2c-2.52,1.33-4.58,3.1-6.18,5.29-1.6,2.2-2.79,4.67-3.55,7.44-.77,2.76-1.15,5.6-1.15,8.51s.38,5.69,1.15,8.47Z" style="fill:#00154c;"/>
					<path d="M135.08,233.79v8.95h.15c1.18-3.11,3.02-5.5,5.51-7.18,2.49-1.68,5.46-2.44,8.92-2.29v4.66c-2.12-.1-4.04.18-5.77.85-1.73.67-3.22,1.62-4.48,2.85-1.26,1.23-2.23,2.7-2.92,4.4-.69,1.7-1.04,3.57-1.04,5.59v20.35h-4.66v-38.18h4.29Z" style="fill:#00154c;"/>
					<path d="M188.62,276.49c-.62,2.27-1.59,4.19-2.92,5.77-1.33,1.58-3.07,2.79-5.22,3.63-2.15.84-4.77,1.26-7.88,1.26-1.92,0-3.8-.22-5.62-.67s-3.47-1.14-4.92-2.07c-1.46-.94-2.66-2.13-3.63-3.59-.96-1.46-1.52-3.19-1.67-5.22h4.66c.25,1.43.73,2.63,1.44,3.59.71.96,1.58,1.74,2.59,2.33,1.01.59,2.13,1.02,3.37,1.29,1.23.27,2.49.41,3.77.41,4.34,0,7.47-1.23,9.4-3.7,1.92-2.47,2.89-6.02,2.89-10.66v-5.18h-.15c-1.08,2.37-2.68,4.27-4.77,5.7-2.1,1.43-4.55,2.15-7.36,2.15-3.06,0-5.67-.5-7.84-1.52-2.17-1.01-3.96-2.41-5.37-4.18-1.41-1.78-2.43-3.86-3.07-6.25-.64-2.39-.96-4.95-.96-7.66s.38-5.09,1.15-7.44c.76-2.34,1.87-4.39,3.33-6.14,1.45-1.75,3.26-3.13,5.4-4.14,2.15-1.01,4.6-1.52,7.36-1.52,1.43,0,2.78.2,4.03.59,1.26.4,2.41.95,3.44,1.67,1.04.72,1.96,1.54,2.77,2.48.81.94,1.44,1.92,1.89,2.96h.15v-6.59h4.66v35.08c0,2.81-.31,5.35-.92,7.62ZM177.93,266.31c1.53-.86,2.81-2,3.85-3.4,1.04-1.41,1.81-3.02,2.33-4.85.52-1.82.78-3.7.78-5.62s-.22-3.75-.67-5.62c-.44-1.87-1.16-3.58-2.15-5.11-.99-1.53-2.26-2.76-3.81-3.7-1.55-.94-3.44-1.41-5.66-1.41s-4.12.46-5.7,1.37c-1.58.91-2.89,2.11-3.92,3.59-1.04,1.48-1.79,3.17-2.26,5.07-.47,1.9-.7,3.84-.7,5.81s.25,3.8.74,5.62c.49,1.83,1.26,3.44,2.29,4.85s2.34,2.54,3.92,3.4c1.58.86,3.45,1.29,5.62,1.29,2.02,0,3.8-.43,5.33-1.29Z" style="fill:#00154c;"/>
					<path d="M202.57,239.71c.79-1.63,1.86-2.96,3.22-4,1.36-1.04,2.95-1.8,4.77-2.29,1.83-.49,3.85-.74,6.07-.74,1.68,0,3.35.16,5.03.48,1.68.32,3.18.92,4.51,1.81,1.33.89,2.42,2.13,3.26,3.74.84,1.6,1.26,3.69,1.26,6.25v20.28c0,1.88.91,2.81,2.74,2.81.54,0,1.04-.1,1.48-.3v3.92c-.54.1-1.02.17-1.44.22-.42.05-.95.07-1.59.07-1.18,0-2.13-.16-2.85-.48-.72-.32-1.27-.78-1.67-1.37-.4-.59-.66-1.29-.78-2.11-.12-.81-.18-1.71-.18-2.7h-.15c-.84,1.23-1.69,2.33-2.55,3.29-.86.96-1.83,1.76-2.89,2.41-1.06.64-2.27,1.13-3.63,1.48-1.36.34-2.97.52-4.85.52-1.78,0-3.44-.21-5-.63-1.55-.42-2.91-1.08-4.07-2-1.16-.91-2.07-2.07-2.74-3.48s-1-3.07-1-5c0-2.66.59-4.75,1.78-6.25,1.18-1.5,2.75-2.65,4.7-3.44,1.95-.79,4.14-1.34,6.59-1.67,2.44-.32,4.92-.63,7.44-.93.99-.1,1.85-.22,2.59-.37.74-.15,1.36-.41,1.85-.78s.88-.88,1.15-1.52c.27-.64.41-1.48.41-2.52,0-1.58-.26-2.87-.78-3.88-.52-1.01-1.23-1.81-2.15-2.41s-1.97-1-3.18-1.22c-1.21-.22-2.5-.33-3.88-.33-2.96,0-5.38.7-7.25,2.11-1.88,1.41-2.86,3.66-2.96,6.77h-4.66c.15-2.22.62-4.14,1.41-5.77ZM225.88,251.1c-.3.54-.86.94-1.7,1.18-.84.25-1.58.42-2.22.52-1.97.35-4.01.65-6.11.92-2.1.27-4.01.68-5.73,1.22-1.73.54-3.15,1.32-4.25,2.33-1.11,1.01-1.67,2.46-1.67,4.33,0,1.18.23,2.23.7,3.15.47.91,1.1,1.7,1.89,2.37.79.67,1.7,1.17,2.74,1.52,1.04.35,2.1.52,3.18.52,1.78,0,3.48-.27,5.11-.81,1.63-.54,3.04-1.33,4.25-2.37,1.21-1.04,2.17-2.29,2.89-3.77.71-1.48,1.07-3.16,1.07-5.03v-6.07h-.15Z" style="fill:#00154c;"/>
					<path d="M247.78,233.79v6.59h.15c.89-2.32,2.47-4.18,4.74-5.59,2.27-1.41,4.76-2.11,7.47-2.11s4.9.35,6.7,1.04c1.8.69,3.24,1.67,4.33,2.92,1.08,1.26,1.85,2.8,2.29,4.62s.67,3.87.67,6.14v24.57h-4.66v-23.83c0-1.63-.15-3.15-.44-4.55-.3-1.41-.81-2.63-1.55-3.66s-1.74-1.85-3-2.44-2.82-.89-4.7-.89-3.54.33-4.99,1c-1.46.67-2.69,1.58-3.7,2.74-1.01,1.16-1.8,2.54-2.37,4.14-.57,1.6-.88,3.34-.92,5.22v22.27h-4.66v-38.18h4.66Z" style="fill:#00154c;"/>
					<path d="M290.85,219.14v7.47h-4.66v-7.47h4.66ZM290.85,233.79v38.18h-4.66v-38.18h4.66Z" style="fill:#00154c;"/>
					<path d="M324.96,241.23c-.54-1.06-1.27-1.94-2.18-2.63-.91-.69-1.96-1.2-3.15-1.52-1.18-.32-2.44-.48-3.77-.48-1.04,0-2.08.11-3.15.33-1.06.22-2.04.59-2.92,1.11-.89.52-1.6,1.2-2.15,2.04-.54.84-.81,1.88-.81,3.11,0,1.04.26,1.91.78,2.63.52.72,1.17,1.32,1.96,1.81.79.49,1.65.9,2.59,1.22.94.32,1.8.58,2.59.78l6.22,1.41c1.33.2,2.65.55,3.96,1.07,1.31.52,2.47,1.2,3.48,2.04,1.01.84,1.84,1.88,2.48,3.11.64,1.23.96,2.69.96,4.37,0,2.07-.47,3.84-1.41,5.29-.94,1.46-2.13,2.64-3.59,3.55-1.46.91-3.1,1.57-4.92,1.96-1.83.39-3.63.59-5.4.59-4.49,0-8.13-1.06-10.92-3.18-2.79-2.12-4.38-5.52-4.77-10.21h4.66c.2,3.16,1.34,5.54,3.44,7.14,2.1,1.6,4.7,2.4,7.81,2.4,1.13,0,2.31-.12,3.51-.37,1.21-.25,2.33-.67,3.37-1.26s1.89-1.34,2.55-2.26c.67-.91,1-2.04,1-3.37,0-1.13-.23-2.08-.7-2.85-.47-.76-1.1-1.41-1.89-1.92-.79-.52-1.69-.95-2.7-1.29-1.01-.34-2.04-.64-3.07-.89l-5.99-1.33c-1.53-.39-2.94-.85-4.22-1.37-1.28-.52-2.41-1.16-3.37-1.92-.96-.76-1.71-1.7-2.26-2.81-.54-1.11-.81-2.48-.81-4.11,0-1.92.43-3.58,1.29-4.96.86-1.38,1.99-2.49,3.37-3.33,1.38-.84,2.92-1.45,4.62-1.85,1.7-.39,3.39-.59,5.07-.59,1.92,0,3.71.25,5.36.74,1.65.49,3.11,1.26,4.37,2.29,1.26,1.04,2.26,2.32,3,3.85.74,1.53,1.16,3.33,1.26,5.4h-4.66c-.05-1.43-.35-2.68-.89-3.74Z" style="fill:#00154c;"/>
					<path d="M342.72,239.71c.79-1.63,1.86-2.96,3.22-4,1.36-1.04,2.95-1.8,4.77-2.29,1.83-.49,3.85-.74,6.07-.74,1.68,0,3.35.16,5.03.48,1.68.32,3.18.92,4.51,1.81,1.33.89,2.42,2.13,3.26,3.74.84,1.6,1.26,3.69,1.26,6.25v20.28c0,1.88.91,2.81,2.74,2.81.54,0,1.04-.1,1.48-.3v3.92c-.54.1-1.02.17-1.44.22-.42.05-.95.07-1.59.07-1.18,0-2.13-.16-2.85-.48-.72-.32-1.27-.78-1.67-1.37-.4-.59-.66-1.29-.78-2.11-.12-.81-.18-1.71-.18-2.7h-.15c-.84,1.23-1.69,2.33-2.55,3.29-.86.96-1.83,1.76-2.89,2.41-1.06.64-2.27,1.13-3.63,1.48-1.36.34-2.97.52-4.85.52-1.78,0-3.44-.21-5-.63-1.55-.42-2.91-1.08-4.07-2-1.16-.91-2.07-2.07-2.74-3.48s-1-3.07-1-5c0-2.66.59-4.75,1.78-6.25,1.18-1.5,2.75-2.65,4.7-3.44,1.95-.79,4.14-1.34,6.59-1.67,2.44-.32,4.92-.63,7.44-.93.99-.1,1.85-.22,2.59-.37.74-.15,1.36-.41,1.85-.78s.88-.88,1.15-1.52c.27-.64.41-1.48.41-2.52,0-1.58-.26-2.87-.78-3.88-.52-1.01-1.23-1.81-2.15-2.41s-1.97-1-3.18-1.22c-1.21-.22-2.5-.33-3.88-.33-2.96,0-5.38.7-7.25,2.11-1.88,1.41-2.86,3.66-2.96,6.77h-4.66c.15-2.22.62-4.14,1.41-5.77ZM366.03,251.1c-.3.54-.86.94-1.7,1.18-.84.25-1.58.42-2.22.52-1.97.35-4.01.65-6.11.92-2.1.27-4.01.68-5.73,1.22-1.73.54-3.15,1.32-4.25,2.33-1.11,1.01-1.67,2.46-1.67,4.33,0,1.18.23,2.23.7,3.15.47.91,1.1,1.7,1.89,2.37.79.67,1.7,1.17,2.74,1.52,1.04.35,2.1.52,3.18.52,1.78,0,3.48-.27,5.11-.81,1.63-.54,3.04-1.33,4.25-2.37,1.21-1.04,2.17-2.29,2.89-3.77.71-1.48,1.07-3.16,1.07-5.03v-6.07h-.15Z" style="fill:#00154c;"/>
					<path d="M398.52,233.79v3.92h-7.77v25.75c0,1.53.21,2.73.63,3.59.42.86,1.47,1.34,3.15,1.44,1.33,0,2.66-.07,4-.22v3.92c-.69,0-1.38.02-2.07.07-.69.05-1.38.07-2.07.07-3.11,0-5.28-.6-6.51-1.81-1.23-1.21-1.83-3.44-1.78-6.7v-26.12h-6.66v-3.92h6.66v-11.47h4.66v11.47h7.77Z" style="fill:#00154c;"/>
					<path d="M413.17,219.14v7.47h-4.66v-7.47h4.66ZM413.17,233.79v38.18h-4.66v-38.18h4.66Z" style="fill:#00154c;"/>
					<path d="M449.17,234.31c2.24,1.09,4.13,2.54,5.66,4.37,1.53,1.83,2.69,3.96,3.48,6.4.79,2.44,1.18,5.04,1.18,7.81s-.4,5.36-1.18,7.81c-.79,2.44-1.95,4.58-3.48,6.4-1.53,1.83-3.42,3.27-5.66,4.33-2.25,1.06-4.82,1.59-7.73,1.59s-5.49-.53-7.73-1.59c-2.25-1.06-4.13-2.5-5.66-4.33s-2.69-3.96-3.48-6.4c-.79-2.44-1.18-5.04-1.18-7.81s.39-5.37,1.18-7.81c.79-2.44,1.95-4.58,3.48-6.4s3.42-3.28,5.66-4.37c2.24-1.08,4.82-1.63,7.73-1.63s5.49.54,7.73,1.63ZM435.59,238.01c-1.68.94-3.07,2.17-4.18,3.7-1.11,1.53-1.95,3.27-2.52,5.22-.57,1.95-.85,3.93-.85,5.96s.28,4.01.85,5.96c.57,1.95,1.41,3.69,2.52,5.22s2.5,2.76,4.18,3.7c1.68.94,3.63,1.41,5.85,1.41s4.17-.47,5.85-1.41c1.68-.94,3.07-2.17,4.18-3.7,1.11-1.53,1.95-3.27,2.52-5.22.57-1.95.85-3.93.85-5.96s-.28-4.01-.85-5.96c-.57-1.95-1.41-3.69-2.52-5.22-1.11-1.53-2.5-2.76-4.18-3.7-1.68-.94-3.63-1.41-5.85-1.41s-4.17.47-5.85,1.41Z" style="fill:#00154c;"/>
					<path d="M474.22,233.79v6.59h.15c.89-2.32,2.47-4.18,4.74-5.59,2.27-1.41,4.76-2.11,7.47-2.11s4.9.35,6.7,1.04c1.8.69,3.24,1.67,4.33,2.92,1.08,1.26,1.85,2.8,2.29,4.62s.67,3.87.67,6.14v24.57h-4.66v-23.83c0-1.63-.15-3.15-.44-4.55-.3-1.41-.81-2.63-1.55-3.66s-1.74-1.85-3-2.44-2.82-.89-4.7-.89-3.54.33-4.99,1c-1.46.67-2.69,1.58-3.7,2.74-1.01,1.16-1.8,2.54-2.37,4.14-.57,1.6-.88,3.34-.92,5.22v22.27h-4.66v-38.18h4.66Z" style="fill:#00154c;"/>
					<path d="M78.69,315.14v22.94h31.38v-22.94h5.03v52.84h-5.03v-25.6h-31.38v25.6h-5.03v-52.84h5.03Z" style="fill:#00154c;"/>
					<path d="M128.72,329.79l12.58,32.56,11.77-32.56h4.66l-16.58,43.96c-.69,1.63-1.33,2.97-1.92,4.03-.59,1.06-1.25,1.9-1.96,2.52-.72.62-1.55,1.06-2.52,1.33-.96.27-2.18.41-3.66.41-.94-.05-1.67-.09-2.18-.11-.52-.03-.97-.11-1.37-.26v-3.92c.54.1,1.07.19,1.59.26.52.07,1.05.11,1.59.11,1.04,0,1.89-.15,2.55-.44s1.25-.7,1.74-1.22c.49-.52.91-1.15,1.26-1.89.34-.74.71-1.55,1.11-2.44l1.63-4.29-15.24-38.04h4.96Z" style="fill:#00154c;"/>
					<path d="M194.8,367.97v-7.25h-.15c-.49,1.23-1.22,2.37-2.18,3.4s-2.06,1.91-3.29,2.63c-1.23.72-2.55,1.27-3.96,1.67-1.41.39-2.8.59-4.18.59-2.91,0-5.44-.53-7.59-1.59-2.15-1.06-3.93-2.52-5.36-4.37-1.43-1.85-2.49-4-3.18-6.44-.69-2.44-1.04-5.02-1.04-7.73s.34-5.29,1.04-7.73c.69-2.44,1.75-4.59,3.18-6.44,1.43-1.85,3.22-3.32,5.36-4.4,2.15-1.08,4.67-1.63,7.59-1.63,1.43,0,2.82.17,4.18.52,1.36.35,2.63.88,3.81,1.59,1.18.72,2.23,1.59,3.15,2.63.91,1.04,1.62,2.25,2.11,3.63h.15v-21.9h4.66v52.84h-4.29ZM169.23,354.76c.47,1.95,1.21,3.69,2.22,5.22,1.01,1.53,2.3,2.78,3.88,3.74,1.58.96,3.48,1.44,5.7,1.44,2.47,0,4.55-.48,6.25-1.44,1.7-.96,3.08-2.21,4.14-3.74,1.06-1.53,1.82-3.27,2.29-5.22.47-1.95.7-3.91.7-5.88s-.23-3.93-.7-5.88c-.47-1.95-1.23-3.69-2.29-5.22-1.06-1.53-2.44-2.77-4.14-3.74-1.7-.96-3.79-1.44-6.25-1.44-2.22,0-4.12.48-5.7,1.44-1.58.96-2.88,2.21-3.88,3.74-1.01,1.53-1.75,3.27-2.22,5.22-.47,1.95-.7,3.91-.7,5.88s.23,3.93.7,5.88Z" style="fill:#00154c;"/>
					<path d="M215.44,329.79v8.95h.15c1.18-3.11,3.02-5.5,5.51-7.18,2.49-1.68,5.46-2.44,8.92-2.29v4.66c-2.12-.1-4.04.18-5.77.85-1.73.67-3.22,1.62-4.48,2.85-1.26,1.23-2.23,2.7-2.92,4.4-.69,1.7-1.04,3.56-1.04,5.59v20.35h-4.66v-38.18h4.29Z" style="fill:#00154c;"/>
					<path d="M260.18,330.31c2.24,1.09,4.13,2.54,5.66,4.37,1.53,1.83,2.69,3.96,3.48,6.4.79,2.44,1.18,5.04,1.18,7.81s-.4,5.37-1.18,7.81c-.79,2.44-1.95,4.58-3.48,6.4-1.53,1.83-3.42,3.27-5.66,4.33-2.25,1.06-4.82,1.59-7.73,1.59s-5.49-.53-7.73-1.59c-2.25-1.06-4.13-2.5-5.66-4.33s-2.69-3.96-3.48-6.4c-.79-2.44-1.18-5.04-1.18-7.81s.39-5.37,1.18-7.81c.79-2.44,1.95-4.58,3.48-6.4s3.42-3.28,5.66-4.37c2.24-1.08,4.82-1.63,7.73-1.63s5.49.54,7.73,1.63ZM246.6,334.01c-1.68.94-3.07,2.17-4.18,3.7s-1.95,3.27-2.52,5.22c-.57,1.95-.85,3.93-.85,5.96s.28,4.01.85,5.96c.57,1.95,1.41,3.69,2.52,5.22,1.11,1.53,2.5,2.76,4.18,3.7,1.68.94,3.63,1.41,5.85,1.41s4.17-.47,5.85-1.41c1.68-.94,3.07-2.17,4.18-3.7,1.11-1.53,1.95-3.27,2.52-5.22.57-1.95.85-3.93.85-5.96s-.28-4.01-.85-5.96c-.57-1.95-1.41-3.69-2.52-5.22-1.11-1.53-2.5-2.76-4.18-3.7-1.68-.94-3.63-1.41-5.85-1.41s-4.17.47-5.85,1.41Z" style="fill:#00154c;"/>
					<path d="M311.98,372.49c-.62,2.27-1.59,4.19-2.92,5.77-1.33,1.58-3.07,2.79-5.22,3.63-2.15.84-4.77,1.26-7.88,1.26-1.92,0-3.8-.22-5.62-.67s-3.47-1.14-4.92-2.07c-1.46-.94-2.66-2.13-3.63-3.59s-1.52-3.19-1.67-5.22h4.66c.25,1.43.73,2.63,1.44,3.59.71.96,1.58,1.74,2.59,2.33,1.01.59,2.13,1.02,3.37,1.29,1.23.27,2.49.41,3.77.41,4.34,0,7.47-1.23,9.4-3.7,1.92-2.47,2.89-6.02,2.89-10.66v-5.18h-.15c-1.08,2.37-2.68,4.27-4.77,5.7-2.1,1.43-4.55,2.15-7.36,2.15-3.06,0-5.67-.5-7.84-1.52-2.17-1.01-3.96-2.41-5.37-4.18-1.41-1.78-2.43-3.86-3.07-6.25-.64-2.39-.96-4.95-.96-7.66s.38-5.09,1.15-7.44c.76-2.34,1.87-4.39,3.33-6.14,1.45-1.75,3.26-3.13,5.4-4.14,2.15-1.01,4.6-1.52,7.36-1.52,1.43,0,2.78.2,4.03.59,1.26.4,2.41.95,3.44,1.67,1.04.72,1.96,1.54,2.77,2.48.81.94,1.44,1.92,1.89,2.96h.15v-6.59h4.66v35.08c0,2.81-.31,5.35-.92,7.62ZM301.28,362.31c1.53-.86,2.81-2,3.85-3.4,1.04-1.41,1.81-3.02,2.33-4.85.52-1.82.78-3.7.78-5.62s-.22-3.75-.67-5.62c-.44-1.87-1.16-3.58-2.15-5.11-.99-1.53-2.26-2.76-3.81-3.7-1.55-.94-3.44-1.41-5.66-1.41s-4.12.46-5.7,1.37c-1.58.91-2.89,2.11-3.92,3.59-1.04,1.48-1.79,3.17-2.26,5.07-.47,1.9-.7,3.84-.7,5.81s.25,3.8.74,5.62c.49,1.83,1.26,3.44,2.29,4.85,1.04,1.41,2.34,2.54,3.92,3.4,1.58.86,3.45,1.29,5.62,1.29,2.02,0,3.8-.43,5.33-1.29Z" style="fill:#00154c;"/>
					<path d="M329.26,329.79v8.95h.15c1.18-3.11,3.02-5.5,5.51-7.18,2.49-1.68,5.46-2.44,8.92-2.29v4.66c-2.12-.1-4.04.18-5.77.85-1.73.67-3.22,1.62-4.48,2.85-1.26,1.23-2.23,2.7-2.92,4.4-.69,1.7-1.04,3.56-1.04,5.59v20.35h-4.66v-38.18h4.29Z" style="fill:#00154c;"/>
					<path d="M352.42,335.71c.79-1.63,1.86-2.96,3.22-4,1.36-1.04,2.95-1.8,4.77-2.29,1.83-.49,3.85-.74,6.07-.74,1.68,0,3.35.16,5.03.48,1.68.32,3.18.92,4.51,1.81s2.42,2.13,3.26,3.74c.84,1.6,1.26,3.69,1.26,6.25v20.28c0,1.88.91,2.81,2.74,2.81.54,0,1.04-.1,1.48-.3v3.92c-.54.1-1.02.17-1.44.22-.42.05-.95.07-1.59.07-1.18,0-2.13-.16-2.85-.48-.72-.32-1.27-.78-1.67-1.37-.4-.59-.66-1.29-.78-2.11-.12-.81-.18-1.71-.18-2.7h-.15c-.84,1.23-1.69,2.33-2.55,3.29-.86.96-1.83,1.76-2.89,2.41-1.06.64-2.27,1.13-3.63,1.48-1.36.34-2.97.52-4.85.52-1.78,0-3.44-.21-5-.63-1.55-.42-2.91-1.08-4.07-2-1.16-.91-2.07-2.07-2.74-3.48-.67-1.41-1-3.07-1-5,0-2.66.59-4.75,1.78-6.25,1.18-1.5,2.75-2.65,4.7-3.44,1.95-.79,4.14-1.34,6.59-1.67,2.44-.32,4.92-.63,7.44-.92.99-.1,1.85-.22,2.59-.37.74-.15,1.36-.41,1.85-.78s.88-.88,1.15-1.52c.27-.64.41-1.48.41-2.52,0-1.58-.26-2.87-.78-3.88-.52-1.01-1.23-1.81-2.15-2.41-.91-.59-1.97-1-3.18-1.22-1.21-.22-2.5-.33-3.88-.33-2.96,0-5.38.7-7.25,2.11-1.88,1.41-2.86,3.66-2.96,6.77h-4.66c.15-2.22.62-4.14,1.41-5.77ZM375.73,347.1c-.3.54-.86.94-1.7,1.18s-1.58.42-2.22.52c-1.97.35-4.01.65-6.11.92-2.1.27-4.01.68-5.73,1.22-1.73.54-3.15,1.32-4.25,2.33-1.11,1.01-1.67,2.46-1.67,4.33,0,1.18.23,2.23.7,3.15.47.91,1.1,1.7,1.89,2.37.79.67,1.7,1.17,2.74,1.52,1.04.35,2.1.52,3.18.52,1.78,0,3.48-.27,5.11-.81,1.63-.54,3.04-1.33,4.25-2.37,1.21-1.04,2.17-2.29,2.89-3.77.71-1.48,1.07-3.16,1.07-5.03v-6.07h-.15Z" style="fill:#00154c;"/>
					<path d="M397.33,329.79v7.25h.15c1.08-2.66,2.85-4.72,5.29-6.18,2.44-1.45,5.22-2.18,8.33-2.18,2.91,0,5.44.54,7.58,1.63,2.15,1.09,3.93,2.55,5.37,4.4,1.43,1.85,2.49,4,3.18,6.44.69,2.44,1.04,5.02,1.04,7.73s-.35,5.29-1.04,7.73c-.69,2.44-1.75,4.59-3.18,6.44-1.43,1.85-3.22,3.31-5.37,4.37-2.15,1.06-4.67,1.59-7.58,1.59-1.38,0-2.76-.17-4.14-.52-1.38-.35-2.66-.86-3.85-1.55-1.18-.69-2.23-1.55-3.14-2.59-.91-1.04-1.62-2.24-2.11-3.63h-.15v21.31h-4.66v-52.24h4.29ZM422.9,343c-.47-1.95-1.21-3.69-2.22-5.22-1.01-1.53-2.31-2.77-3.88-3.74-1.58-.96-3.48-1.44-5.7-1.44-2.57,0-4.71.44-6.44,1.33-1.73.89-3.11,2.07-4.14,3.55-1.04,1.48-1.76,3.21-2.18,5.18-.42,1.97-.63,4.04-.63,6.22,0,1.97.23,3.93.7,5.88.47,1.95,1.23,3.69,2.29,5.22,1.06,1.53,2.44,2.78,4.14,3.74s3.79,1.44,6.25,1.44c2.22,0,4.12-.48,5.7-1.44,1.58-.96,2.87-2.21,3.88-3.74,1.01-1.53,1.75-3.27,2.22-5.22.47-1.95.7-3.91.7-5.88s-.23-3.93-.7-5.88Z" style="fill:#00154c;"/>
					<path d="M443.29,315.14v21.24h.15c.89-2.32,2.47-4.18,4.74-5.59,2.27-1.41,4.76-2.11,7.47-2.11s4.9.35,6.7,1.04c1.8.69,3.24,1.67,4.33,2.92,1.08,1.26,1.85,2.8,2.29,4.62.44,1.83.67,3.87.67,6.14v24.57h-4.66v-23.83c0-1.63-.15-3.14-.44-4.55s-.81-2.63-1.55-3.66-1.74-1.85-3-2.44c-1.26-.59-2.82-.89-4.7-.89s-3.54.33-4.99,1c-1.46.67-2.69,1.58-3.7,2.74-1.01,1.16-1.8,2.54-2.37,4.14-.57,1.6-.88,3.34-.92,5.22v22.27h-4.66v-52.84h4.66Z" style="fill:#00154c;"/>
					<path d="M486.35,315.14v7.47h-4.66v-7.47h4.66ZM486.35,329.79v38.18h-4.66v-38.18h4.66Z" style="fill:#00154c;"/>
					<path d="M527.42,382.03v-21.31h-.15c-.49,1.38-1.2,2.59-2.11,3.63-.91,1.04-1.96,1.9-3.15,2.59-1.18.69-2.45,1.21-3.81,1.55-1.36.34-2.75.52-4.18.52-2.91,0-5.44-.53-7.59-1.59-2.15-1.06-3.93-2.52-5.36-4.37-1.43-1.85-2.49-4-3.18-6.44-.69-2.44-1.04-5.02-1.04-7.73s.34-5.29,1.04-7.73c.69-2.44,1.75-4.59,3.18-6.44,1.43-1.85,3.22-3.32,5.36-4.4,2.15-1.08,4.67-1.63,7.59-1.63,1.38,0,2.77.2,4.18.59,1.41.4,2.73.96,3.96,1.7,1.23.74,2.33,1.62,3.29,2.63.96,1.01,1.69,2.16,2.18,3.44h.15v-7.25h4.29v52.24h-4.66ZM502.23,354.76c.47,1.95,1.21,3.69,2.22,5.22,1.01,1.53,2.3,2.78,3.88,3.74,1.58.96,3.48,1.44,5.7,1.44,2.47,0,4.55-.48,6.25-1.44,1.7-.96,3.08-2.21,4.14-3.74,1.06-1.53,1.82-3.27,2.29-5.22.47-1.95.7-3.91.7-5.88s-.23-3.93-.7-5.88c-.47-1.95-1.23-3.69-2.29-5.22-1.06-1.53-2.44-2.77-4.14-3.74-1.7-.96-3.79-1.44-6.25-1.44-2.22,0-4.12.48-5.7,1.44-1.58.96-2.88,2.21-3.88,3.74-1.01,1.53-1.75,3.27-2.22,5.22-.47,1.95-.7,3.91-.7,5.88s.23,3.93.7,5.88Z" style="fill:#00154c;"/>
					<path d="M570.79,367.97v-6.88h-.15c-1.23,2.57-3.02,4.53-5.36,5.88-2.34,1.36-4.95,2.04-7.81,2.04-2.42,0-4.48-.33-6.18-1s-3.08-1.62-4.14-2.85-1.84-2.74-2.33-4.51c-.49-1.78-.74-3.8-.74-6.07v-24.79h4.66v24.86c.1,3.45.9,6.07,2.4,7.84,1.5,1.78,4.11,2.66,7.81,2.66,2.02,0,3.75-.43,5.18-1.3,1.43-.86,2.61-2.01,3.55-3.44.94-1.43,1.63-3.07,2.07-4.92.44-1.85.67-3.74.67-5.66v-20.05h4.66v38.18h-4.29Z" style="fill:#00154c;"/>
					<path d="M590.51,355.36c.47,1.8,1.22,3.42,2.26,4.85s2.34,2.62,3.92,3.55c1.58.94,3.48,1.41,5.7,1.41,3.4,0,6.07-.89,7.99-2.66,1.92-1.78,3.26-4.14,4-7.1h4.66c-.99,4.34-2.8,7.7-5.44,10.06-2.64,2.37-6.38,3.55-11.21,3.55-3.01,0-5.61-.53-7.81-1.59-2.2-1.06-3.98-2.52-5.37-4.37-1.38-1.85-2.41-4-3.07-6.44-.67-2.44-1-5.02-1-7.73,0-2.52.33-4.98,1-7.4.67-2.42,1.69-4.58,3.07-6.47,1.38-1.9,3.17-3.43,5.37-4.59,2.19-1.16,4.8-1.74,7.81-1.74s5.67.62,7.84,1.85c2.17,1.23,3.93,2.85,5.29,4.85,1.36,2,2.33,4.29,2.92,6.88.59,2.59.84,5.22.74,7.88h-29.38c0,1.68.23,3.42.7,5.22ZM613.6,341.11c-.57-1.63-1.37-3.07-2.4-4.33-1.04-1.26-2.29-2.27-3.77-3.03-1.48-.76-3.16-1.15-5.03-1.15s-3.63.38-5.11,1.15c-1.48.76-2.74,1.78-3.77,3.03-1.04,1.26-1.86,2.71-2.48,4.37-.62,1.65-1.02,3.34-1.22,5.07h24.72c-.05-1.78-.36-3.48-.92-5.11Z" style="fill:#00154c;"/>
					<path d="M79.06,411.14v52.84h-5.03v-52.84h5.03Z" style="fill:#00154c;"/>
					<path d="M96.97,425.79v6.59h.15c.89-2.32,2.47-4.18,4.74-5.59,2.27-1.41,4.76-2.11,7.47-2.11s4.9.35,6.7,1.04c1.8.69,3.24,1.67,4.33,2.92,1.08,1.26,1.85,2.8,2.29,4.62.44,1.83.67,3.87.67,6.14v24.57h-4.66v-23.83c0-1.63-.15-3.14-.44-4.55s-.81-2.63-1.55-3.66-1.74-1.85-3-2.44c-1.26-.59-2.82-.89-4.7-.89s-3.54.33-4.99,1c-1.46.67-2.69,1.58-3.7,2.74-1.01,1.16-1.8,2.54-2.37,4.14-.57,1.6-.88,3.34-.92,5.22v22.27h-4.66v-38.18h4.66Z" style="fill:#00154c;"/>
					<path d="M150.47,425.79v3.92h-7.77v25.75c0,1.53.21,2.73.63,3.59.42.86,1.47,1.34,3.15,1.44,1.33,0,2.66-.07,4-.22v3.92c-.69,0-1.38.02-2.07.07-.69.05-1.38.07-2.07.07-3.11,0-5.28-.6-6.51-1.81-1.23-1.21-1.83-3.44-1.78-6.7v-26.12h-6.66v-3.92h6.66v-11.47h4.66v11.47h7.77Z" style="fill:#00154c;"/>
					<path d="M163.83,451.36c.47,1.8,1.22,3.42,2.26,4.85s2.34,2.62,3.92,3.55c1.58.94,3.48,1.41,5.7,1.41,3.4,0,6.07-.89,7.99-2.66,1.92-1.78,3.26-4.14,4-7.1h4.66c-.99,4.34-2.8,7.7-5.44,10.06-2.64,2.37-6.38,3.55-11.21,3.55-3.01,0-5.61-.53-7.81-1.59-2.2-1.06-3.98-2.52-5.37-4.37-1.38-1.85-2.41-4-3.07-6.44-.67-2.44-1-5.02-1-7.73,0-2.52.33-4.98,1-7.4.67-2.42,1.69-4.58,3.07-6.47,1.38-1.9,3.17-3.43,5.37-4.59,2.19-1.16,4.8-1.74,7.81-1.74s5.67.62,7.84,1.85c2.17,1.23,3.93,2.85,5.29,4.85,1.36,2,2.33,4.29,2.92,6.88.59,2.59.84,5.22.74,7.88h-29.38c0,1.68.23,3.42.7,5.22ZM186.91,437.11c-.57-1.63-1.37-3.07-2.4-4.33-1.04-1.26-2.29-2.27-3.77-3.03-1.48-.76-3.16-1.15-5.03-1.15s-3.63.38-5.11,1.15c-1.48.76-2.74,1.78-3.77,3.03-1.04,1.26-1.86,2.71-2.48,4.37-.62,1.65-1.02,3.34-1.22,5.07h24.72c-.05-1.78-.36-3.48-.92-5.11Z" style="fill:#00154c;"/>
					<path d="M206.27,425.79v8.95h.15c1.18-3.11,3.02-5.5,5.51-7.18,2.49-1.68,5.46-2.44,8.92-2.29v4.66c-2.12-.1-4.04.18-5.77.85-1.73.67-3.22,1.62-4.48,2.85-1.26,1.23-2.23,2.7-2.92,4.4-.69,1.7-1.04,3.56-1.04,5.59v20.35h-4.66v-38.18h4.29Z" style="fill:#00154c;"/>
					<path d="M234.38,425.79v6.59h.15c.89-2.32,2.47-4.18,4.74-5.59,2.27-1.41,4.76-2.11,7.47-2.11s4.9.35,6.7,1.04c1.8.69,3.24,1.67,4.33,2.92,1.08,1.26,1.85,2.8,2.29,4.62.44,1.83.67,3.87.67,6.14v24.57h-4.66v-23.83c0-1.63-.15-3.14-.44-4.55s-.81-2.63-1.55-3.66-1.74-1.85-3-2.44c-1.26-.59-2.82-.89-4.7-.89s-3.54.33-4.99,1c-1.46.67-2.69,1.58-3.7,2.74-1.01,1.16-1.8,2.54-2.37,4.14-.57,1.6-.88,3.34-.92,5.22v22.27h-4.66v-38.18h4.66Z" style="fill:#00154c;"/>
					<path d="M273.68,431.71c.79-1.63,1.86-2.96,3.22-4,1.36-1.04,2.95-1.8,4.77-2.29s3.85-.74,6.07-.74c1.68,0,3.35.16,5.03.48,1.68.32,3.18.93,4.51,1.81s2.42,2.13,3.26,3.74c.84,1.6,1.26,3.69,1.26,6.25v20.28c0,1.88.91,2.81,2.74,2.81.54,0,1.04-.1,1.48-.3v3.92c-.54.1-1.02.17-1.44.22-.42.05-.95.07-1.59.07-1.18,0-2.13-.16-2.85-.48-.72-.32-1.27-.78-1.67-1.37-.4-.59-.66-1.29-.78-2.11-.12-.81-.18-1.71-.18-2.7h-.15c-.84,1.23-1.69,2.33-2.55,3.29-.86.96-1.83,1.76-2.89,2.41-1.06.64-2.27,1.13-3.63,1.48-1.36.34-2.97.52-4.85.52-1.78,0-3.44-.21-5-.63-1.55-.42-2.91-1.08-4.07-2-1.16-.91-2.07-2.07-2.74-3.48-.67-1.41-1-3.07-1-5,0-2.66.59-4.75,1.78-6.25,1.18-1.5,2.75-2.65,4.7-3.44,1.95-.79,4.14-1.34,6.59-1.67,2.44-.32,4.92-.63,7.44-.92.99-.1,1.85-.22,2.59-.37.74-.15,1.36-.41,1.85-.78s.88-.88,1.15-1.52c.27-.64.41-1.48.41-2.52,0-1.58-.26-2.87-.78-3.88-.52-1.01-1.23-1.81-2.15-2.41-.91-.59-1.97-1-3.18-1.22-1.21-.22-2.5-.33-3.88-.33-2.96,0-5.38.7-7.25,2.11-1.88,1.41-2.86,3.66-2.96,6.77h-4.66c.15-2.22.62-4.14,1.41-5.77ZM296.99,443.1c-.3.54-.86.94-1.7,1.18s-1.58.42-2.22.52c-1.97.35-4.01.65-6.11.92-2.1.27-4.01.68-5.73,1.22-1.73.54-3.15,1.32-4.25,2.33-1.11,1.01-1.67,2.46-1.67,4.33,0,1.18.23,2.23.7,3.15.47.91,1.1,1.7,1.89,2.37.79.67,1.7,1.17,2.74,1.52,1.04.35,2.1.52,3.18.52,1.78,0,3.48-.27,5.11-.81,1.63-.54,3.04-1.33,4.25-2.37,1.21-1.04,2.17-2.29,2.89-3.77.71-1.48,1.07-3.16,1.07-5.03v-6.07h-.15Z" style="fill:#00154c;"/>
					<path d="M329.47,425.79v3.92h-7.77v25.75c0,1.53.21,2.73.63,3.59.42.86,1.47,1.34,3.15,1.44,1.33,0,2.66-.07,4-.22v3.92c-.69,0-1.38.02-2.07.07-.69.05-1.38.07-2.07.07-3.11,0-5.28-.6-6.51-1.81-1.23-1.21-1.83-3.44-1.78-6.7v-26.12h-6.66v-3.92h6.66v-11.47h4.66v11.47h7.77Z" style="fill:#00154c;"/>
					<path d="M344.12,411.14v7.47h-4.66v-7.47h4.66ZM344.12,425.79v38.18h-4.66v-38.18h4.66Z" style="fill:#00154c;"/>
					<path d="M380.12,426.31c2.24,1.09,4.13,2.54,5.66,4.37,1.53,1.83,2.69,3.96,3.48,6.4.79,2.44,1.18,5.04,1.18,7.81s-.4,5.37-1.18,7.81c-.79,2.44-1.95,4.58-3.48,6.4-1.53,1.83-3.42,3.27-5.66,4.33-2.25,1.06-4.82,1.59-7.73,1.59s-5.49-.53-7.73-1.59c-2.25-1.06-4.13-2.5-5.66-4.33s-2.69-3.96-3.48-6.4c-.79-2.44-1.18-5.04-1.18-7.81s.39-5.37,1.18-7.81c.79-2.44,1.95-4.58,3.48-6.4s3.42-3.28,5.66-4.37c2.24-1.08,4.82-1.63,7.73-1.63s5.49.54,7.73,1.63ZM366.55,430.01c-1.68.94-3.07,2.17-4.18,3.7s-1.95,3.27-2.52,5.22c-.57,1.95-.85,3.93-.85,5.96s.28,4.01.85,5.96c.57,1.95,1.41,3.69,2.52,5.22,1.11,1.53,2.5,2.76,4.18,3.7,1.68.94,3.63,1.41,5.85,1.41s4.17-.47,5.85-1.41c1.68-.94,3.07-2.17,4.18-3.7,1.11-1.53,1.95-3.27,2.52-5.22.57-1.95.85-3.93.85-5.96s-.28-4.01-.85-5.96c-.57-1.95-1.41-3.69-2.52-5.22-1.11-1.53-2.5-2.76-4.18-3.7-1.68-.94-3.63-1.41-5.85-1.41s-4.17.47-5.85,1.41Z" style="fill:#00154c;"/>
					<path d="M405.17,425.79v6.59h.15c.89-2.32,2.47-4.18,4.74-5.59,2.27-1.41,4.76-2.11,7.47-2.11s4.9.35,6.7,1.04c1.8.69,3.24,1.67,4.33,2.92,1.08,1.26,1.85,2.8,2.29,4.62.44,1.83.67,3.87.67,6.14v24.57h-4.66v-23.83c0-1.63-.15-3.14-.44-4.55s-.81-2.63-1.55-3.66-1.74-1.85-3-2.44c-1.26-.59-2.82-.89-4.7-.89s-3.54.33-4.99,1c-1.46.67-2.69,1.58-3.7,2.74-1.01,1.16-1.8,2.54-2.37,4.14-.57,1.6-.88,3.34-.92,5.22v22.27h-4.66v-38.18h4.66Z" style="fill:#00154c;"/>
					<path d="M444.47,431.71c.79-1.63,1.86-2.96,3.22-4,1.36-1.04,2.95-1.8,4.77-2.29s3.85-.74,6.07-.74c1.68,0,3.35.16,5.03.48,1.68.32,3.18.93,4.51,1.81s2.42,2.13,3.26,3.74c.84,1.6,1.26,3.69,1.26,6.25v20.28c0,1.88.91,2.81,2.74,2.81.54,0,1.04-.1,1.48-.3v3.92c-.54.1-1.02.17-1.44.22-.42.05-.95.07-1.59.07-1.18,0-2.13-.16-2.85-.48-.72-.32-1.27-.78-1.67-1.37-.4-.59-.66-1.29-.78-2.11-.12-.81-.18-1.71-.18-2.7h-.15c-.84,1.23-1.69,2.33-2.55,3.29-.86.96-1.83,1.76-2.89,2.41-1.06.64-2.27,1.13-3.63,1.48-1.36.34-2.97.52-4.85.52-1.78,0-3.44-.21-5-.63-1.55-.42-2.91-1.08-4.07-2-1.16-.91-2.07-2.07-2.74-3.48-.67-1.41-1-3.07-1-5,0-2.66.59-4.75,1.78-6.25,1.18-1.5,2.75-2.65,4.7-3.44,1.95-.79,4.14-1.34,6.59-1.67,2.44-.32,4.92-.63,7.44-.92.99-.1,1.85-.22,2.59-.37.74-.15,1.36-.41,1.85-.78s.88-.88,1.15-1.52c.27-.64.41-1.48.41-2.52,0-1.58-.26-2.87-.78-3.88-.52-1.01-1.23-1.81-2.15-2.41-.91-.59-1.97-1-3.18-1.22-1.21-.22-2.5-.33-3.88-.33-2.96,0-5.38.7-7.25,2.11-1.88,1.41-2.86,3.66-2.96,6.77h-4.66c.15-2.22.62-4.14,1.41-5.77ZM467.78,443.1c-.3.54-.86.94-1.7,1.18s-1.58.42-2.22.52c-1.97.35-4.01.65-6.11.92-2.1.27-4.01.68-5.73,1.22-1.73.54-3.15,1.32-4.25,2.33-1.11,1.01-1.67,2.46-1.67,4.33,0,1.18.23,2.23.7,3.15.47.91,1.1,1.7,1.89,2.37.79.67,1.7,1.17,2.74,1.52,1.04.35,2.1.52,3.18.52,1.78,0,3.48-.27,5.11-.81,1.63-.54,3.04-1.33,4.25-2.37,1.21-1.04,2.17-2.29,2.89-3.77.71-1.48,1.07-3.16,1.07-5.03v-6.07h-.15Z" style="fill:#00154c;"/>
					<path d="M489.83,411.14v52.84h-4.66v-52.84h4.66Z" style="fill:#00154c;"/>
					<path d="M505.41,451.36c.47,1.8,1.22,3.42,2.26,4.85s2.34,2.62,3.92,3.55c1.58.94,3.48,1.41,5.7,1.41,3.4,0,6.07-.89,7.99-2.66,1.92-1.78,3.26-4.14,4-7.1h4.66c-.99,4.34-2.8,7.7-5.44,10.06-2.64,2.37-6.38,3.55-11.21,3.55-3.01,0-5.61-.53-7.81-1.59-2.2-1.06-3.98-2.52-5.37-4.37-1.38-1.85-2.41-4-3.07-6.44-.67-2.44-1-5.02-1-7.73,0-2.52.33-4.98,1-7.4.67-2.42,1.69-4.58,3.07-6.47,1.38-1.9,3.17-3.43,5.37-4.59,2.19-1.16,4.8-1.74,7.81-1.74s5.67.62,7.84,1.85c2.17,1.23,3.93,2.85,5.29,4.85,1.36,2,2.33,4.29,2.92,6.88.59,2.59.84,5.22.74,7.88h-29.38c0,1.68.23,3.42.7,5.22ZM528.49,437.11c-.57-1.63-1.37-3.07-2.4-4.33-1.04-1.26-2.29-2.27-3.77-3.03-1.48-.76-3.16-1.15-5.03-1.15s-3.63.38-5.11,1.15c-1.48.76-2.74,1.78-3.77,3.03-1.04,1.26-1.86,2.71-2.48,4.37-.62,1.65-1.02,3.34-1.22,5.07h24.72c-.05-1.78-.36-3.48-.92-5.11Z" style="fill:#00154c;"/>
				</svg>
			</xsl:when>
			<xsl:otherwise> <!-- en default -->
				<svg id="uuid-4850eec0-d71a-4649-bbc4-888bd73bf371" xmlns="http://www.w3.org/2000/svg" width="235.3mm" height="235.3mm" viewBox="0 0 667 667">
					<rect x="0" width="667" height="667" style="fill:#f0ebd8;"/>
					<path d="M113.12,219.14v52.84h-5.03v-52.84h5.03Z" style="fill:#00154c;"/>
					<path d="M131.03,233.79v6.59h.15c.89-2.32,2.47-4.18,4.74-5.59,2.27-1.41,4.76-2.11,7.47-2.11s4.9.35,6.7,1.04c1.8.69,3.24,1.67,4.33,2.92,1.08,1.26,1.85,2.8,2.29,4.62s.67,3.87.67,6.14v24.57h-4.66v-23.83c0-1.63-.15-3.14-.44-4.55s-.81-2.63-1.55-3.66-1.74-1.85-3-2.44-2.82-.89-4.7-.89-3.54.33-4.99,1c-1.46.67-2.69,1.58-3.7,2.74-1.01,1.16-1.8,2.54-2.37,4.14-.57,1.6-.88,3.34-.92,5.22v22.27h-4.66v-38.18h4.66Z" style="fill:#00154c;"/>
					<path d="M184.53,233.79v3.92h-7.77v25.75c0,1.53.21,2.73.63,3.59.42.86,1.47,1.34,3.15,1.44,1.33,0,2.66-.07,4-.22v3.92c-.69,0-1.38.02-2.07.07-.69.05-1.38.07-2.07.07-3.11,0-5.28-.6-6.51-1.81-1.23-1.21-1.83-3.44-1.78-6.7v-26.12h-6.66v-3.92h6.66v-11.47h4.66v11.47h7.77Z" style="fill:#00154c;"/>
					<path d="M197.88,259.36c.47,1.8,1.22,3.42,2.26,4.85,1.04,1.43,2.34,2.62,3.92,3.55,1.58.94,3.48,1.41,5.7,1.41,3.4,0,6.07-.89,7.99-2.66,1.92-1.78,3.26-4.14,4-7.1h4.66c-.99,4.34-2.8,7.7-5.44,10.06-2.64,2.37-6.38,3.55-11.21,3.55-3.01,0-5.61-.53-7.81-1.59-2.2-1.06-3.98-2.52-5.37-4.37-1.38-1.85-2.41-4-3.07-6.44-.67-2.44-1-5.02-1-7.73,0-2.52.33-4.98,1-7.4.67-2.42,1.69-4.58,3.07-6.47,1.38-1.9,3.17-3.43,5.37-4.59,2.19-1.16,4.8-1.74,7.81-1.74s5.67.62,7.84,1.85c2.17,1.23,3.93,2.85,5.29,4.85,1.36,2,2.33,4.29,2.92,6.88.59,2.59.84,5.22.74,7.88h-29.38c0,1.68.23,3.42.7,5.22ZM220.97,245.11c-.57-1.63-1.37-3.07-2.4-4.33-1.04-1.26-2.29-2.27-3.77-3.03-1.48-.76-3.16-1.15-5.03-1.15s-3.63.38-5.11,1.15c-1.48.77-2.74,1.78-3.77,3.03s-1.86,2.71-2.48,4.37c-.62,1.65-1.02,3.34-1.22,5.07h24.72c-.05-1.78-.36-3.48-.92-5.11Z" style="fill:#00154c;"/>
					<path d="M240.32,233.79v8.95h.15c1.18-3.11,3.02-5.5,5.51-7.18,2.49-1.68,5.46-2.44,8.92-2.29v4.66c-2.12-.1-4.04.18-5.77.85-1.73.67-3.22,1.62-4.48,2.85-1.26,1.23-2.23,2.7-2.92,4.4-.69,1.7-1.04,3.57-1.04,5.59v20.35h-4.66v-38.18h4.29Z" style="fill:#00154c;"/>
					<path d="M268.44,233.79v6.59h.15c.89-2.32,2.47-4.18,4.74-5.59,2.27-1.41,4.76-2.11,7.47-2.11s4.9.35,6.7,1.04c1.8.69,3.24,1.67,4.33,2.92,1.08,1.26,1.85,2.8,2.29,4.62s.67,3.87.67,6.14v24.57h-4.66v-23.83c0-1.63-.15-3.14-.44-4.55s-.81-2.63-1.55-3.66-1.74-1.85-3-2.44-2.82-.89-4.7-.89-3.54.33-4.99,1c-1.46.67-2.69,1.58-3.7,2.74-1.01,1.16-1.8,2.54-2.37,4.14-.57,1.6-.88,3.34-.92,5.22v22.27h-4.66v-38.18h4.66Z" style="fill:#00154c;"/>
					<path d="M307.73,239.71c.79-1.63,1.86-2.96,3.22-4,1.36-1.04,2.95-1.8,4.77-2.29,1.83-.49,3.85-.74,6.07-.74,1.68,0,3.35.16,5.03.48,1.68.32,3.18.92,4.51,1.81s2.42,2.13,3.26,3.74c.84,1.6,1.26,3.69,1.26,6.25v20.28c0,1.88.91,2.81,2.74,2.81.54,0,1.04-.1,1.48-.3v3.92c-.54.1-1.02.17-1.44.22-.42.05-.95.07-1.59.07-1.18,0-2.13-.16-2.85-.48-.72-.32-1.27-.78-1.67-1.37-.4-.59-.66-1.29-.78-2.11-.12-.81-.18-1.71-.18-2.7h-.15c-.84,1.23-1.69,2.33-2.55,3.29-.86.96-1.83,1.76-2.89,2.41-1.06.64-2.27,1.13-3.63,1.48-1.36.35-2.97.52-4.85.52-1.78,0-3.44-.21-5-.63s-2.91-1.08-4.07-2c-1.16-.91-2.07-2.07-2.74-3.48-.67-1.41-1-3.07-1-5,0-2.66.59-4.75,1.78-6.25,1.18-1.5,2.75-2.65,4.7-3.44,1.95-.79,4.14-1.34,6.59-1.67,2.44-.32,4.92-.63,7.44-.92.99-.1,1.85-.22,2.59-.37.74-.15,1.36-.41,1.85-.78s.88-.88,1.15-1.52c.27-.64.41-1.48.41-2.52,0-1.58-.26-2.87-.78-3.89-.52-1.01-1.23-1.81-2.15-2.41s-1.97-1-3.18-1.22c-1.21-.22-2.5-.33-3.88-.33-2.96,0-5.38.7-7.25,2.11-1.88,1.41-2.86,3.66-2.96,6.77h-4.66c.15-2.22.62-4.14,1.41-5.77ZM331.04,251.1c-.3.54-.86.94-1.7,1.18-.84.25-1.58.42-2.22.52-1.97.35-4.01.65-6.11.92-2.1.27-4.01.68-5.73,1.22-1.73.54-3.15,1.32-4.25,2.33-1.11,1.01-1.67,2.46-1.67,4.33,0,1.18.23,2.23.7,3.14.47.91,1.1,1.7,1.89,2.37.79.67,1.7,1.17,2.74,1.52,1.04.35,2.1.52,3.18.52,1.78,0,3.48-.27,5.11-.81,1.63-.54,3.04-1.33,4.25-2.37,1.21-1.04,2.17-2.29,2.89-3.77.71-1.48,1.07-3.16,1.07-5.03v-6.07h-.15Z" style="fill:#00154c;"/>
					<path d="M363.53,233.79v3.92h-7.77v25.75c0,1.53.21,2.73.63,3.59.42.86,1.47,1.34,3.15,1.44,1.33,0,2.66-.07,4-.22v3.92c-.69,0-1.38.02-2.07.07-.69.05-1.38.07-2.07.07-3.11,0-5.28-.6-6.51-1.81-1.23-1.21-1.83-3.44-1.78-6.7v-26.12h-6.66v-3.92h6.66v-11.47h4.66v11.47h7.77Z" style="fill:#00154c;"/>
					<path d="M378.18,219.14v7.47h-4.66v-7.47h4.66ZM378.18,233.79v38.18h-4.66v-38.18h4.66Z" style="fill:#00154c;"/>
					<path d="M414.18,234.31c2.24,1.09,4.13,2.54,5.66,4.37,1.53,1.83,2.69,3.96,3.48,6.4.79,2.44,1.18,5.04,1.18,7.81s-.4,5.37-1.18,7.81c-.79,2.44-1.95,4.58-3.48,6.4-1.53,1.83-3.42,3.27-5.66,4.33-2.25,1.06-4.82,1.59-7.73,1.59s-5.49-.53-7.73-1.59c-2.25-1.06-4.13-2.5-5.66-4.33s-2.69-3.96-3.48-6.4c-.79-2.44-1.18-5.04-1.18-7.81s.39-5.37,1.18-7.81c.79-2.44,1.95-4.58,3.48-6.4s3.42-3.28,5.66-4.37c2.24-1.08,4.82-1.63,7.73-1.63s5.49.54,7.73,1.63ZM400.6,238.01c-1.68.94-3.07,2.17-4.18,3.7s-1.95,3.27-2.52,5.22c-.57,1.95-.85,3.93-.85,5.96s.28,4.01.85,5.96c.57,1.95,1.41,3.69,2.52,5.22s2.5,2.76,4.18,3.7c1.68.94,3.63,1.41,5.85,1.41s4.17-.47,5.85-1.41c1.68-.94,3.07-2.17,4.18-3.7,1.11-1.53,1.95-3.27,2.52-5.22.57-1.95.85-3.93.85-5.96s-.28-4.01-.85-5.96c-.57-1.95-1.41-3.69-2.52-5.22-1.11-1.53-2.5-2.76-4.18-3.7-1.68-.94-3.63-1.41-5.85-1.41s-4.17.47-5.85,1.41Z" style="fill:#00154c;"/>
					<path d="M439.23,233.79v6.59h.15c.89-2.32,2.47-4.18,4.74-5.59,2.27-1.41,4.76-2.11,7.47-2.11s4.9.35,6.7,1.04c1.8.69,3.24,1.67,4.33,2.92,1.08,1.26,1.85,2.8,2.29,4.62s.67,3.87.67,6.14v24.57h-4.66v-23.83c0-1.63-.15-3.14-.44-4.55s-.81-2.63-1.55-3.66-1.74-1.85-3-2.44-2.82-.89-4.7-.89-3.54.33-4.99,1c-1.46.67-2.69,1.58-3.7,2.74-1.01,1.16-1.8,2.54-2.37,4.14-.57,1.6-.88,3.34-.92,5.22v22.27h-4.66v-38.18h4.66Z" style="fill:#00154c;"/>
					<path d="M478.52,239.71c.79-1.63,1.86-2.96,3.22-4,1.36-1.04,2.95-1.8,4.77-2.29,1.83-.49,3.85-.74,6.07-.74,1.68,0,3.35.16,5.03.48,1.68.32,3.18.92,4.51,1.81s2.42,2.13,3.26,3.74c.84,1.6,1.26,3.69,1.26,6.25v20.28c0,1.88.91,2.81,2.74,2.81.54,0,1.04-.1,1.48-.3v3.92c-.54.1-1.02.17-1.44.22-.42.05-.95.07-1.59.07-1.18,0-2.13-.16-2.85-.48-.72-.32-1.27-.78-1.67-1.37-.4-.59-.66-1.29-.78-2.11-.12-.81-.18-1.71-.18-2.7h-.15c-.84,1.23-1.69,2.33-2.55,3.29-.86.96-1.83,1.76-2.89,2.41-1.06.64-2.27,1.13-3.63,1.48-1.36.35-2.97.52-4.85.52-1.78,0-3.44-.21-5-.63s-2.91-1.08-4.07-2c-1.16-.91-2.07-2.07-2.74-3.48-.67-1.41-1-3.07-1-5,0-2.66.59-4.75,1.78-6.25,1.18-1.5,2.75-2.65,4.7-3.44,1.95-.79,4.14-1.34,6.59-1.67,2.44-.32,4.92-.63,7.44-.92.99-.1,1.85-.22,2.59-.37.74-.15,1.36-.41,1.85-.78s.88-.88,1.15-1.52c.27-.64.41-1.48.41-2.52,0-1.58-.26-2.87-.78-3.89-.52-1.01-1.23-1.81-2.15-2.41s-1.97-1-3.18-1.22c-1.21-.22-2.5-.33-3.88-.33-2.96,0-5.38.7-7.25,2.11-1.88,1.41-2.86,3.66-2.96,6.77h-4.66c.15-2.22.62-4.14,1.41-5.77ZM501.83,251.1c-.3.54-.86.94-1.7,1.18-.84.25-1.58.42-2.22.52-1.97.35-4.01.65-6.11.92-2.1.27-4.01.68-5.73,1.22-1.73.54-3.15,1.32-4.25,2.33-1.11,1.01-1.67,2.46-1.67,4.33,0,1.18.23,2.23.7,3.14.47.91,1.1,1.7,1.89,2.37.79.67,1.7,1.17,2.74,1.52,1.04.35,2.1.52,3.18.52,1.78,0,3.48-.27,5.11-.81,1.63-.54,3.04-1.33,4.25-2.37,1.21-1.04,2.17-2.29,2.89-3.77.71-1.48,1.07-3.16,1.07-5.03v-6.07h-.15Z" style="fill:#00154c;"/>
					<path d="M523.89,219.14v52.84h-4.66v-52.84h4.66Z" style="fill:#00154c;"/>
					<path d="M112.75,315.14v22.94h31.38v-22.94h5.03v52.84h-5.03v-25.6h-31.38v25.6h-5.03v-52.84h5.03Z" style="fill:#00154c;"/>
					<path d="M162.77,329.79l12.58,32.56,11.77-32.56h4.66l-16.58,43.96c-.69,1.63-1.33,2.97-1.92,4.03-.59,1.06-1.25,1.9-1.96,2.52-.72.62-1.55,1.06-2.52,1.33-.96.27-2.18.41-3.66.41-.94-.05-1.67-.09-2.18-.11-.52-.03-.97-.11-1.37-.26v-3.92c.54.1,1.07.19,1.59.26.52.07,1.05.11,1.59.11,1.04,0,1.89-.15,2.55-.44s1.25-.7,1.74-1.22c.49-.52.91-1.15,1.26-1.89.34-.74.71-1.55,1.11-2.44l1.63-4.29-15.24-38.04h4.96Z" style="fill:#00154c;"/>
					<path d="M228.86,367.97v-7.25h-.15c-.49,1.23-1.22,2.37-2.18,3.4s-2.06,1.91-3.29,2.63c-1.23.72-2.55,1.27-3.96,1.67-1.41.39-2.8.59-4.18.59-2.91,0-5.44-.53-7.59-1.59-2.15-1.06-3.93-2.52-5.36-4.37-1.43-1.85-2.49-4-3.18-6.44-.69-2.44-1.04-5.02-1.04-7.73s.34-5.29,1.04-7.73c.69-2.44,1.75-4.59,3.18-6.44,1.43-1.85,3.22-3.32,5.36-4.4,2.15-1.08,4.67-1.63,7.59-1.63,1.43,0,2.82.17,4.18.52,1.36.35,2.63.88,3.81,1.59,1.18.72,2.23,1.59,3.15,2.63.91,1.04,1.62,2.25,2.11,3.63h.15v-21.9h4.66v52.84h-4.29ZM203.29,354.76c.47,1.95,1.21,3.69,2.22,5.22,1.01,1.53,2.3,2.78,3.88,3.74,1.58.96,3.48,1.44,5.7,1.44,2.47,0,4.55-.48,6.25-1.44,1.7-.96,3.08-2.21,4.14-3.74,1.06-1.53,1.82-3.27,2.29-5.22.47-1.95.7-3.91.7-5.88s-.23-3.93-.7-5.88c-.47-1.95-1.23-3.69-2.29-5.22-1.06-1.53-2.44-2.77-4.14-3.74-1.7-.96-3.79-1.44-6.25-1.44-2.22,0-4.12.48-5.7,1.44-1.58.96-2.88,2.21-3.88,3.74-1.01,1.53-1.75,3.27-2.22,5.22-.47,1.95-.7,3.91-.7,5.88s.23,3.93.7,5.88Z" style="fill:#00154c;"/>
					<path d="M249.5,329.79v8.95h.15c1.18-3.11,3.02-5.5,5.51-7.18,2.49-1.68,5.46-2.44,8.92-2.29v4.66c-2.12-.1-4.04.18-5.77.85-1.73.67-3.22,1.62-4.48,2.85-1.26,1.23-2.23,2.7-2.92,4.4-.69,1.7-1.04,3.56-1.04,5.59v20.35h-4.66v-38.18h4.29Z" style="fill:#00154c;"/>
					<path d="M294.23,330.31c2.24,1.09,4.13,2.54,5.66,4.37,1.53,1.83,2.69,3.96,3.48,6.4.79,2.44,1.18,5.04,1.18,7.81s-.4,5.37-1.18,7.81c-.79,2.44-1.95,4.58-3.48,6.4-1.53,1.83-3.42,3.27-5.66,4.33-2.25,1.06-4.82,1.59-7.73,1.59s-5.49-.53-7.73-1.59c-2.25-1.06-4.13-2.5-5.66-4.33s-2.69-3.96-3.48-6.4c-.79-2.44-1.18-5.04-1.18-7.81s.39-5.37,1.18-7.81c.79-2.44,1.95-4.58,3.48-6.4s3.42-3.28,5.66-4.37c2.24-1.08,4.82-1.63,7.73-1.63s5.49.54,7.73,1.63ZM280.65,334.01c-1.68.94-3.07,2.17-4.18,3.7s-1.95,3.27-2.52,5.22c-.57,1.95-.85,3.93-.85,5.96s.28,4.01.85,5.96c.57,1.95,1.41,3.69,2.52,5.22,1.11,1.53,2.5,2.76,4.18,3.7,1.68.94,3.63,1.41,5.85,1.41s4.17-.47,5.85-1.41c1.68-.94,3.07-2.17,4.18-3.7,1.11-1.53,1.95-3.27,2.52-5.22.57-1.95.85-3.93.85-5.96s-.28-4.01-.85-5.96c-.57-1.95-1.41-3.69-2.52-5.22-1.11-1.53-2.5-2.76-4.18-3.7-1.68-.94-3.63-1.41-5.85-1.41s-4.17.47-5.85,1.41Z" style="fill:#00154c;"/>
					<path d="M346.03,372.49c-.62,2.27-1.59,4.19-2.92,5.77-1.33,1.58-3.07,2.79-5.22,3.63-2.15.84-4.77,1.26-7.88,1.26-1.92,0-3.8-.22-5.62-.67s-3.47-1.14-4.92-2.07c-1.46-.94-2.66-2.13-3.63-3.59s-1.52-3.19-1.67-5.22h4.66c.25,1.43.73,2.63,1.44,3.59.71.96,1.58,1.74,2.59,2.33,1.01.59,2.13,1.02,3.37,1.29,1.23.27,2.49.41,3.77.41,4.34,0,7.47-1.23,9.4-3.7,1.92-2.47,2.89-6.02,2.89-10.66v-5.18h-.15c-1.08,2.37-2.68,4.27-4.77,5.7-2.1,1.43-4.55,2.15-7.36,2.15-3.06,0-5.67-.5-7.84-1.52-2.17-1.01-3.96-2.41-5.37-4.18-1.41-1.78-2.43-3.86-3.07-6.25-.64-2.39-.96-4.95-.96-7.66s.38-5.09,1.15-7.44c.76-2.34,1.87-4.39,3.33-6.14,1.45-1.75,3.26-3.13,5.4-4.14,2.15-1.01,4.6-1.52,7.36-1.52,1.43,0,2.78.2,4.03.59,1.26.4,2.41.95,3.44,1.67,1.04.72,1.96,1.54,2.77,2.48.81.94,1.44,1.92,1.89,2.96h.15v-6.59h4.66v35.08c0,2.81-.31,5.35-.92,7.62ZM335.34,362.31c1.53-.86,2.81-2,3.85-3.4,1.04-1.41,1.81-3.02,2.33-4.85.52-1.82.78-3.7.78-5.62s-.22-3.75-.67-5.62c-.44-1.87-1.16-3.58-2.15-5.11-.99-1.53-2.26-2.76-3.81-3.7-1.55-.94-3.44-1.41-5.66-1.41s-4.12.46-5.7,1.37c-1.58.91-2.89,2.11-3.92,3.59-1.04,1.48-1.79,3.17-2.26,5.07-.47,1.9-.7,3.84-.7,5.81s.25,3.8.74,5.62c.49,1.83,1.26,3.44,2.29,4.85,1.04,1.41,2.34,2.54,3.92,3.4,1.58.86,3.45,1.29,5.62,1.29,2.02,0,3.8-.43,5.33-1.29Z" style="fill:#00154c;"/>
					<path d="M363.31,329.79v8.95h.15c1.18-3.11,3.02-5.5,5.51-7.18,2.49-1.68,5.46-2.44,8.92-2.29v4.66c-2.12-.1-4.04.18-5.77.85-1.73.67-3.22,1.62-4.48,2.85-1.26,1.23-2.23,2.7-2.92,4.4-.69,1.7-1.04,3.56-1.04,5.59v20.35h-4.66v-38.18h4.29Z" style="fill:#00154c;"/>
					<path d="M386.47,335.71c.79-1.63,1.86-2.96,3.22-4,1.36-1.04,2.95-1.8,4.77-2.29,1.83-.49,3.85-.74,6.07-.74,1.68,0,3.35.16,5.03.48,1.68.32,3.18.92,4.51,1.81s2.42,2.13,3.26,3.74c.84,1.6,1.26,3.69,1.26,6.25v20.28c0,1.88.91,2.81,2.74,2.81.54,0,1.04-.1,1.48-.3v3.92c-.54.1-1.02.17-1.44.22-.42.05-.95.07-1.59.07-1.18,0-2.13-.16-2.85-.48-.72-.32-1.27-.78-1.67-1.37-.4-.59-.66-1.29-.78-2.11-.12-.81-.18-1.71-.18-2.7h-.15c-.84,1.23-1.69,2.33-2.55,3.29-.86.96-1.83,1.76-2.89,2.41-1.06.64-2.27,1.13-3.63,1.48-1.36.34-2.97.52-4.85.52-1.78,0-3.44-.21-5-.63-1.55-.42-2.91-1.08-4.07-2-1.16-.91-2.07-2.07-2.74-3.48-.67-1.41-1-3.07-1-5,0-2.66.59-4.75,1.78-6.25,1.18-1.5,2.75-2.65,4.7-3.44,1.95-.79,4.14-1.34,6.59-1.67,2.44-.32,4.92-.63,7.44-.92.99-.1,1.85-.22,2.59-.37.74-.15,1.36-.41,1.85-.78s.88-.88,1.15-1.52c.27-.64.41-1.48.41-2.52,0-1.58-.26-2.87-.78-3.88-.52-1.01-1.23-1.81-2.15-2.41-.91-.59-1.97-1-3.18-1.22-1.21-.22-2.5-.33-3.88-.33-2.96,0-5.38.7-7.25,2.11-1.88,1.41-2.86,3.66-2.96,6.77h-4.66c.15-2.22.62-4.14,1.41-5.77ZM409.78,347.1c-.3.54-.86.94-1.7,1.18s-1.58.42-2.22.52c-1.97.35-4.01.65-6.11.92-2.1.27-4.01.68-5.73,1.22-1.73.54-3.15,1.32-4.25,2.33-1.11,1.01-1.67,2.46-1.67,4.33,0,1.18.23,2.23.7,3.15.47.91,1.1,1.7,1.89,2.37.79.67,1.7,1.17,2.74,1.52,1.04.35,2.1.52,3.18.52,1.78,0,3.48-.27,5.11-.81,1.63-.54,3.04-1.33,4.25-2.37,1.21-1.04,2.17-2.29,2.89-3.77.71-1.48,1.07-3.16,1.07-5.03v-6.07h-.15Z" style="fill:#00154c;"/>
					<path d="M431.39,329.79v7.25h.15c1.08-2.66,2.85-4.72,5.29-6.18,2.44-1.45,5.22-2.18,8.33-2.18,2.91,0,5.44.54,7.58,1.63,2.15,1.09,3.93,2.55,5.37,4.4,1.43,1.85,2.49,4,3.18,6.44.69,2.44,1.04,5.02,1.04,7.73s-.35,5.29-1.04,7.73c-.69,2.44-1.75,4.59-3.18,6.44-1.43,1.85-3.22,3.31-5.37,4.37-2.15,1.06-4.67,1.59-7.58,1.59-1.38,0-2.76-.17-4.14-.52-1.38-.35-2.66-.86-3.85-1.55-1.18-.69-2.23-1.55-3.14-2.59-.91-1.04-1.62-2.24-2.11-3.63h-.15v21.31h-4.66v-52.24h4.29ZM456.96,343c-.47-1.95-1.21-3.69-2.22-5.22-1.01-1.53-2.31-2.77-3.88-3.74-1.58-.96-3.48-1.44-5.7-1.44-2.57,0-4.71.44-6.44,1.33-1.73.89-3.11,2.07-4.14,3.55-1.04,1.48-1.76,3.21-2.18,5.18-.42,1.97-.63,4.04-.63,6.22,0,1.97.23,3.93.7,5.88.47,1.95,1.23,3.69,2.29,5.22,1.06,1.53,2.44,2.78,4.14,3.74s3.79,1.44,6.25,1.44c2.22,0,4.12-.48,5.7-1.44,1.58-.96,2.87-2.21,3.88-3.74,1.01-1.53,1.75-3.27,2.22-5.22.47-1.95.7-3.91.7-5.88s-.23-3.93-.7-5.88Z" style="fill:#00154c;"/>
					<path d="M477.34,315.14v21.24h.15c.89-2.32,2.47-4.18,4.74-5.59,2.27-1.41,4.76-2.11,7.47-2.11s4.9.35,6.7,1.04c1.8.69,3.24,1.67,4.33,2.92,1.08,1.26,1.85,2.8,2.29,4.62.44,1.83.67,3.87.67,6.14v24.57h-4.66v-23.83c0-1.63-.15-3.14-.44-4.55s-.81-2.63-1.55-3.66-1.74-1.85-3-2.44c-1.26-.59-2.82-.89-4.7-.89s-3.54.33-4.99,1c-1.46.67-2.69,1.58-3.7,2.74-1.01,1.16-1.8,2.54-2.37,4.14-.57,1.6-.88,3.34-.92,5.22v22.27h-4.66v-52.84h4.66Z" style="fill:#00154c;"/>
					<path d="M520.41,315.14v7.47h-4.66v-7.47h4.66ZM520.41,329.79v38.18h-4.66v-38.18h4.66Z" style="fill:#00154c;"/>
					<path d="M555.93,335.04c-1.73-1.63-4.14-2.44-7.25-2.44-2.22,0-4.17.47-5.85,1.41-1.68.94-3.07,2.17-4.18,3.7s-1.95,3.27-2.52,5.22c-.57,1.95-.85,3.93-.85,5.96s.28,4.01.85,5.96c.57,1.95,1.41,3.69,2.52,5.22,1.11,1.53,2.5,2.76,4.18,3.7,1.68.94,3.63,1.41,5.85,1.41,1.43,0,2.79-.27,4.07-.81,1.28-.54,2.42-1.29,3.4-2.26.99-.96,1.8-2.11,2.44-3.44.64-1.33,1.04-2.79,1.18-4.37h4.66c-.64,4.64-2.34,8.25-5.11,10.84-2.76,2.59-6.32,3.88-10.66,3.88-2.91,0-5.49-.53-7.73-1.59-2.25-1.06-4.13-2.5-5.66-4.33s-2.69-3.96-3.48-6.4c-.79-2.44-1.18-5.04-1.18-7.81s.39-5.37,1.18-7.81c.79-2.44,1.95-4.58,3.48-6.4s3.42-3.28,5.66-4.37c2.24-1.08,4.82-1.63,7.73-1.63,4.09,0,7.56,1.08,10.4,3.26,2.84,2.17,4.53,5.45,5.07,9.84h-4.66c-.64-2.86-1.83-5.11-3.55-6.73Z" style="fill:#00154c;"/>
					<path d="M106.46,427.12c1.04-3.3,2.59-6.23,4.66-8.77,2.07-2.54,4.67-4.56,7.81-6.07,3.13-1.5,6.77-2.26,10.92-2.26s7.77.75,10.88,2.26c3.11,1.51,5.7,3.53,7.77,6.07,2.07,2.54,3.63,5.46,4.66,8.77,1.04,3.31,1.55,6.78,1.55,10.43s-.52,7.13-1.55,10.43c-1.04,3.31-2.59,6.22-4.66,8.73-2.07,2.52-4.66,4.53-7.77,6.03-3.11,1.5-6.73,2.26-10.88,2.26s-7.78-.75-10.92-2.26c-3.13-1.5-5.74-3.52-7.81-6.03-2.07-2.52-3.63-5.43-4.66-8.73-1.04-3.3-1.55-6.78-1.55-10.43s.52-7.13,1.55-10.43ZM111.08,446.03c.76,2.79,1.95,5.28,3.55,7.47,1.6,2.2,3.66,3.96,6.18,5.29,2.52,1.33,5.52,2,9.03,2s6.5-.67,8.99-2c2.49-1.33,4.54-3.1,6.14-5.29,1.6-2.2,2.79-4.69,3.55-7.47.76-2.79,1.15-5.61,1.15-8.47s-.38-5.75-1.15-8.51-1.95-5.24-3.55-7.44c-1.6-2.19-3.65-3.96-6.14-5.29-2.49-1.33-5.49-2-8.99-2s-6.51.67-9.03,2c-2.52,1.33-4.58,3.1-6.18,5.29-1.6,2.2-2.79,4.67-3.55,7.44-.77,2.76-1.15,5.6-1.15,8.51s.38,5.69,1.15,8.47Z" style="fill:#00154c;"/>
					<path d="M169.14,425.79v8.95h.15c1.18-3.11,3.02-5.5,5.51-7.18,2.49-1.68,5.46-2.44,8.92-2.29v4.66c-2.12-.1-4.04.18-5.77.85-1.73.67-3.22,1.62-4.48,2.85-1.26,1.23-2.23,2.7-2.92,4.4-.69,1.7-1.04,3.56-1.04,5.59v20.35h-4.66v-38.18h4.29Z" style="fill:#00154c;"/>
					<path d="M222.68,468.49c-.62,2.27-1.59,4.19-2.92,5.77-1.33,1.58-3.07,2.79-5.22,3.63-2.15.84-4.77,1.26-7.88,1.26-1.92,0-3.8-.22-5.62-.67s-3.47-1.14-4.92-2.07c-1.46-.94-2.66-2.13-3.63-3.59s-1.52-3.19-1.67-5.22h4.66c.25,1.43.73,2.63,1.44,3.59.71.96,1.58,1.74,2.59,2.33,1.01.59,2.13,1.02,3.37,1.29,1.23.27,2.49.41,3.77.41,4.34,0,7.47-1.23,9.4-3.7,1.92-2.47,2.89-6.02,2.89-10.66v-5.18h-.15c-1.08,2.37-2.68,4.27-4.77,5.7-2.1,1.43-4.55,2.15-7.36,2.15-3.06,0-5.67-.5-7.84-1.52-2.17-1.01-3.96-2.41-5.37-4.18-1.41-1.78-2.43-3.86-3.07-6.25-.64-2.39-.96-4.95-.96-7.66s.38-5.09,1.15-7.44c.76-2.34,1.87-4.39,3.33-6.14,1.45-1.75,3.26-3.13,5.4-4.14,2.15-1.01,4.6-1.52,7.36-1.52,1.43,0,2.78.2,4.03.59,1.26.4,2.41.95,3.44,1.67,1.04.72,1.96,1.54,2.77,2.48.81.94,1.44,1.92,1.89,2.96h.15v-6.59h4.66v35.08c0,2.81-.31,5.35-.92,7.62ZM211.98,458.31c1.53-.86,2.81-2,3.85-3.4,1.04-1.41,1.81-3.02,2.33-4.85.52-1.82.78-3.7.78-5.62s-.22-3.75-.67-5.62c-.44-1.87-1.16-3.58-2.15-5.11-.99-1.53-2.26-2.76-3.81-3.7-1.55-.94-3.44-1.41-5.66-1.41s-4.12.46-5.7,1.37c-1.58.91-2.89,2.11-3.92,3.59-1.04,1.48-1.79,3.17-2.26,5.07-.47,1.9-.7,3.84-.7,5.81s.25,3.8.74,5.62c.49,1.83,1.26,3.44,2.29,4.85,1.04,1.41,2.34,2.54,3.92,3.4,1.58.86,3.45,1.29,5.62,1.29,2.02,0,3.8-.43,5.33-1.29Z" style="fill:#00154c;"/>
					<path d="M236.62,431.71c.79-1.63,1.86-2.96,3.22-4,1.36-1.04,2.95-1.8,4.77-2.29s3.85-.74,6.07-.74c1.68,0,3.35.16,5.03.48,1.68.32,3.18.93,4.51,1.81s2.42,2.13,3.26,3.74c.84,1.6,1.26,3.69,1.26,6.25v20.28c0,1.88.91,2.81,2.74,2.81.54,0,1.04-.1,1.48-.3v3.92c-.54.1-1.02.17-1.44.22-.42.05-.95.07-1.59.07-1.18,0-2.13-.16-2.85-.48-.72-.32-1.27-.78-1.67-1.37-.4-.59-.66-1.29-.78-2.11-.12-.81-.18-1.71-.18-2.7h-.15c-.84,1.23-1.69,2.33-2.55,3.29-.86.96-1.83,1.76-2.89,2.41-1.06.64-2.27,1.13-3.63,1.48-1.36.34-2.97.52-4.85.52-1.78,0-3.44-.21-5-.63-1.55-.42-2.91-1.08-4.07-2-1.16-.91-2.07-2.07-2.74-3.48-.67-1.41-1-3.07-1-5,0-2.66.59-4.75,1.78-6.25,1.18-1.5,2.75-2.65,4.7-3.44,1.95-.79,4.14-1.34,6.59-1.67,2.44-.32,4.92-.63,7.44-.92.99-.1,1.85-.22,2.59-.37.74-.15,1.36-.41,1.85-.78s.88-.88,1.15-1.52c.27-.64.41-1.48.41-2.52,0-1.58-.26-2.87-.78-3.88-.52-1.01-1.23-1.81-2.15-2.41-.91-.59-1.97-1-3.18-1.22-1.21-.22-2.5-.33-3.88-.33-2.96,0-5.38.7-7.25,2.11-1.88,1.41-2.86,3.66-2.96,6.77h-4.66c.15-2.22.62-4.14,1.41-5.77ZM259.93,443.1c-.3.54-.86.94-1.7,1.18s-1.58.42-2.22.52c-1.97.35-4.01.65-6.11.92-2.1.27-4.01.68-5.73,1.22-1.73.54-3.15,1.32-4.25,2.33-1.11,1.01-1.67,2.46-1.67,4.33,0,1.18.23,2.23.7,3.15.47.91,1.1,1.7,1.89,2.37.79.67,1.7,1.17,2.74,1.52,1.04.35,2.1.52,3.18.52,1.78,0,3.48-.27,5.11-.81,1.63-.54,3.04-1.33,4.25-2.37,1.21-1.04,2.17-2.29,2.89-3.77.71-1.48,1.07-3.16,1.07-5.03v-6.07h-.15Z" style="fill:#00154c;"/>
					<path d="M281.84,425.79v6.59h.15c.89-2.32,2.47-4.18,4.74-5.59,2.27-1.41,4.76-2.11,7.47-2.11s4.9.35,6.7,1.04c1.8.69,3.24,1.67,4.33,2.92,1.08,1.26,1.85,2.8,2.29,4.62.44,1.83.67,3.87.67,6.14v24.57h-4.66v-23.83c0-1.63-.15-3.14-.44-4.55s-.81-2.63-1.55-3.66-1.74-1.85-3-2.44c-1.26-.59-2.82-.89-4.7-.89s-3.54.33-4.99,1c-1.46.67-2.69,1.58-3.7,2.74-1.01,1.16-1.8,2.54-2.37,4.14-.57,1.6-.88,3.34-.92,5.22v22.27h-4.66v-38.18h4.66Z" style="fill:#00154c;"/>
					<path d="M324.91,411.14v7.47h-4.66v-7.47h4.66ZM324.91,425.79v38.18h-4.66v-38.18h4.66Z" style="fill:#00154c;"/>
					<path d="M365.61,460.05v3.92h-31.89v-3.77l24.94-30.49h-23.24v-3.92h29.16v3.33l-25.23,30.93h26.27Z" style="fill:#00154c;"/>
					<path d="M375.45,431.71c.79-1.63,1.86-2.96,3.22-4,1.36-1.04,2.95-1.8,4.77-2.29s3.85-.74,6.07-.74c1.68,0,3.35.16,5.03.48,1.68.32,3.18.93,4.51,1.81s2.42,2.13,3.26,3.74c.84,1.6,1.26,3.69,1.26,6.25v20.28c0,1.88.91,2.81,2.74,2.81.54,0,1.04-.1,1.48-.3v3.92c-.54.1-1.02.17-1.44.22-.42.05-.95.07-1.59.07-1.18,0-2.13-.16-2.85-.48-.72-.32-1.27-.78-1.67-1.37-.4-.59-.66-1.29-.78-2.11-.12-.81-.18-1.71-.18-2.7h-.15c-.84,1.23-1.69,2.33-2.55,3.29-.86.96-1.83,1.76-2.89,2.41-1.06.64-2.27,1.13-3.63,1.48-1.36.34-2.97.52-4.85.52-1.78,0-3.44-.21-5-.63-1.55-.42-2.91-1.08-4.07-2-1.16-.91-2.07-2.07-2.74-3.48-.67-1.41-1-3.07-1-5,0-2.66.59-4.75,1.78-6.25,1.18-1.5,2.75-2.65,4.7-3.44,1.95-.79,4.14-1.34,6.59-1.67,2.44-.32,4.92-.63,7.44-.92.99-.1,1.85-.22,2.59-.37.74-.15,1.36-.41,1.85-.78s.88-.88,1.15-1.52c.27-.64.41-1.48.41-2.52,0-1.58-.26-2.87-.78-3.88-.52-1.01-1.23-1.81-2.15-2.41-.91-.59-1.97-1-3.18-1.22-1.21-.22-2.5-.33-3.88-.33-2.96,0-5.38.7-7.25,2.11-1.88,1.41-2.86,3.66-2.96,6.77h-4.66c.15-2.22.62-4.14,1.41-5.77ZM398.76,443.1c-.3.54-.86.94-1.7,1.18s-1.58.42-2.22.52c-1.97.35-4.01.65-6.11.92-2.1.27-4.01.68-5.73,1.22-1.73.54-3.15,1.32-4.25,2.33-1.11,1.01-1.67,2.46-1.67,4.33,0,1.18.23,2.23.7,3.15.47.91,1.1,1.7,1.89,2.37.79.67,1.7,1.17,2.74,1.52,1.04.35,2.1.52,3.18.52,1.78,0,3.48-.27,5.11-.81,1.63-.54,3.04-1.33,4.25-2.37,1.21-1.04,2.17-2.29,2.89-3.77.71-1.48,1.07-3.16,1.07-5.03v-6.07h-.15Z" style="fill:#00154c;"/>
					<path d="M431.24,425.79v3.92h-7.77v25.75c0,1.53.21,2.73.63,3.59.42.86,1.47,1.34,3.15,1.44,1.33,0,2.66-.07,4-.22v3.92c-.69,0-1.38.02-2.07.07-.69.05-1.38.07-2.07.07-3.11,0-5.28-.6-6.51-1.81-1.23-1.21-1.83-3.44-1.78-6.7v-26.12h-6.66v-3.92h6.66v-11.47h4.66v11.47h7.77Z" style="fill:#00154c;"/>
					<path d="M445.89,411.14v7.47h-4.66v-7.47h4.66ZM445.89,425.79v38.18h-4.66v-38.18h4.66Z" style="fill:#00154c;"/>
					<path d="M481.89,426.31c2.24,1.09,4.13,2.54,5.66,4.37,1.53,1.83,2.69,3.96,3.48,6.4.79,2.44,1.18,5.04,1.18,7.81s-.4,5.37-1.18,7.81c-.79,2.44-1.95,4.58-3.48,6.4-1.53,1.83-3.42,3.27-5.66,4.33-2.25,1.06-4.82,1.59-7.73,1.59s-5.49-.53-7.73-1.59c-2.25-1.06-4.13-2.5-5.66-4.33s-2.69-3.96-3.48-6.4c-.79-2.44-1.18-5.04-1.18-7.81s.39-5.37,1.18-7.81c.79-2.44,1.95-4.58,3.48-6.4s3.42-3.28,5.66-4.37c2.24-1.08,4.82-1.63,7.73-1.63s5.49.54,7.73,1.63ZM468.32,430.01c-1.68.94-3.07,2.17-4.18,3.7s-1.95,3.27-2.52,5.22c-.57,1.95-.85,3.93-.85,5.96s.28,4.01.85,5.96c.57,1.95,1.41,3.69,2.52,5.22,1.11,1.53,2.5,2.76,4.18,3.7,1.68.94,3.63,1.41,5.85,1.41s4.17-.47,5.85-1.41c1.68-.94,3.07-2.17,4.18-3.7,1.11-1.53,1.95-3.27,2.52-5.22.57-1.95.85-3.93.85-5.96s-.28-4.01-.85-5.96c-.57-1.95-1.41-3.69-2.52-5.22-1.11-1.53-2.5-2.76-4.18-3.7-1.68-.94-3.63-1.41-5.85-1.41s-4.17.47-5.85,1.41Z" style="fill:#00154c;"/>
					<path d="M506.94,425.79v6.59h.15c.89-2.32,2.47-4.18,4.74-5.59,2.27-1.41,4.76-2.11,7.47-2.11s4.9.35,6.7,1.04c1.8.69,3.24,1.67,4.33,2.92,1.08,1.26,1.85,2.8,2.29,4.62.44,1.83.67,3.87.67,6.14v24.57h-4.66v-23.83c0-1.63-.15-3.14-.44-4.55s-.81-2.63-1.55-3.66-1.74-1.85-3-2.44c-1.26-.59-2.82-.89-4.7-.89s-3.54.33-4.99,1c-1.46.67-2.69,1.58-3.7,2.74-1.01,1.16-1.8,2.54-2.37,4.14-.57,1.6-.88,3.34-.92,5.22v22.27h-4.66v-38.18h4.66Z" style="fill:#00154c;"/>
				</svg>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:include href="./common.xsl"/>
	
</xsl:stylesheet>