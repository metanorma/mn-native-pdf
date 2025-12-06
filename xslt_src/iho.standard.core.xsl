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
													<xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:contributor/mn:organization/mn:logo[@type = 'mark']"/>
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
													<xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:contributor/mn:organization/mn:logo[@type = 'sign']"/>
												</fo:block>
											</fo:table-cell>
											<fo:table-cell>
												<fo:block font-size="1">
													<xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:contributor/mn:organization/mn:logo[@type = 'desc']"/>
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
	
	<xsl:template match="mn:logo[@type = 'desc' or @type = 'mark' or @type = 'sign']">
		<fo:instream-foreign-object content-width="25.9mm" fox:alt-text="Image Logo IHO">
			<xsl:if test="@type = 'desc'"><xsl:attribute name="content-width">25.8mm</xsl:attribute></xsl:if>
			<xsl:copy-of select="mn:image/*[local-name() = 'svg']"/>
			<xsl:if test="not(mn:image/*[local-name() = 'svg'])">
				<xsl:copy-of select="$svg_empty"/>
			</xsl:if>
		</fo:instream-foreign-object>
	</xsl:template>
	
	<xsl:include href="./common.xsl"/>
	
</xsl:stylesheet>