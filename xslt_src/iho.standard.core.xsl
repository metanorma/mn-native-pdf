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
										<fo:block-container margin-left="0mm" margin-right="0mm" border="0.5pt solid black" >
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
																<fo:block-container margin-left="0mm">
																
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
													<fo:block-container margin-left="0mm">
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
		
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
	
		<xsl:variable name="font-size">
			<xsl:choose>
				<xsl:when test="$level = 1">12pt</xsl:when>
				<xsl:when test="$level = 2">11pt</xsl:when>
				<xsl:when test="$level &gt;= 3">10pt</xsl:when>				
				<xsl:otherwise>12pt</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="element-name">
			<xsl:choose>
				<xsl:when test="../@inline-header = 'true'">fo:inline</xsl:when>
				<xsl:otherwise>fo:block</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:element name="{$element-name}">
			
			<xsl:choose>
				<xsl:when test="@type = 'floating-title' or @type = 'section-title'">
					<xsl:copy-of select="@id"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:for-each select="parent::mn:clause">
						<xsl:call-template name="setId"/>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>
			
			<xsl:attribute name="font-size"><xsl:value-of select="$font-size"/></xsl:attribute>			
			<xsl:attribute name="font-weight">bold</xsl:attribute>			
			<xsl:attribute name="space-before">
				<xsl:choose>
					<xsl:when test="$level = 1">24pt</xsl:when>
					<xsl:when test="$level = 2 and ../preceding-sibling::*[1][self::mn:fmt-title]">10pt</xsl:when>
					<xsl:when test="$level = 2">24pt</xsl:when>
					<xsl:when test="$level &gt;= 3">6pt</xsl:when>
					<xsl:when test="ancestor::mn:preface">8pt</xsl:when>
					<xsl:when test="$level = ''">6pt</xsl:when><!-- 13.5pt -->
					<xsl:otherwise>12pt</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="space-after">
				<xsl:choose>
					<xsl:when test="$level &gt;= 3">6pt</xsl:when>
					<xsl:otherwise>10pt</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<!-- <xsl:attribute name="margin-bottom">10pt</xsl:attribute> -->
				
			<xsl:attribute name="keep-with-next">always</xsl:attribute>		
			
			<xsl:attribute name="role">H<xsl:value-of select="$level"/></xsl:attribute>
			
			<xsl:if test="../@id = '_document_history' or . = 'Document History'">
				<xsl:attribute name="text-align">center</xsl:attribute>
			</xsl:if>
			
			<xsl:apply-templates />
			<xsl:apply-templates select="following-sibling::*[1][mn:variant-title][@type = 'sub']" mode="subtitle"/>
		</xsl:element>
		
		<xsl:if test="$element-name = 'fo:inline' and not(following-sibling::mn:p)">
			<fo:block > <!-- margin-bottom="12pt" -->
				<xsl:value-of select="$linebreak"/>
			</fo:block>
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
		<xsl:element name="{$element-name}">
			<xsl:attribute name="text-align">
				<xsl:choose>
					<xsl:when test="ancestor::mn:quote">justify</xsl:when>
					<xsl:when test="ancestor::mn:feedback-statement">right</xsl:when>
					<xsl:when test="ancestor::mn:boilerplate and not(@align)">justify</xsl:when>
					<xsl:when test="@align = 'justified'">justify</xsl:when>
					<xsl:when test="@align"><xsl:value-of select="@align"/></xsl:when>
					<xsl:when test="ancestor::mn:td/@align"><xsl:value-of select="ancestor::mn:td/@align"/></xsl:when>
					<xsl:when test="ancestor::mn:th/@align"><xsl:value-of select="ancestor::mn:th/@align"/></xsl:when>
					<xsl:otherwise>justify</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:call-template name="setKeepAttributes"/>
			<xsl:attribute name="space-after">6pt</xsl:attribute>
			<xsl:if test="parent::mn:dd">
				<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="ancestor::*[2][self::mn:license-statement] and not(following-sibling::mn:p)">
				<xsl:attribute name="space-after">0pt</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="line-height">115%</xsl:attribute>
			<!-- <xsl:attribute name="border">1pt solid red</xsl:attribute> -->
			<xsl:if test="ancestor::mn:boilerplate and not(ancestor::mn:feedback-statement)">
				<xsl:attribute name="line-height">125%</xsl:attribute>
				<xsl:attribute name="space-after">14pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="following-sibling::*[1][self::mn:ol or self::mn:ul or self::mn:note or self::mn:termnote or self::mn:example or self::mn:dl]">
				<xsl:attribute name="space-after">3pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="following-sibling::*[1][self::mn:dl]">
				<xsl:attribute name="space-after">6pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="ancestor::mn:quote">
				<xsl:attribute name="line-height">130%</xsl:attribute>
				<!-- <xsl:attribute name="margin-bottom">12pt</xsl:attribute> -->
			</xsl:if>
			
			<xsl:if test="ancestor::*[self::mn:recommendation or self::mn:requirement or self::mn:permission] and
			not(following-sibling::*)">
				<xsl:attribute name="space-after">0pt</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="ancestor::mn:li and ancestor::mn:table">
				<xsl:attribute name="space-after">0pt</xsl:attribute>
			</xsl:if>
			
			<xsl:if test=".//mn:fn">
				<xsl:attribute name="line-height-shift-adjustment">disregard-shifts</xsl:attribute>
			</xsl:if>
			
			<xsl:copy-of select="@id"/>
			
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
		<xsl:call-template name="insertFooter">
			<xsl:with-param name="docidentifier" select="$docidentifier"/>
			<xsl:with-param name="edition" select="$edition"/>
			<xsl:with-param name="month_year" select="$month_year"/>
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
		<svg width="100px" height="100px" viewBox="0 0 100 100" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
			<g>
					<polygon fill="#00AAA9" points="0 100 100 100 100 0 0 0"></polygon>
					<g transform="translate(20.000000, 36.000000)" fill="#FEFEFE">
							<polygon points="0.510089944 25.6344052 8.07929262 25.6344052 8.07929262 1.10633647 0.510089944 1.10633647"></polygon>
							<polygon points="11.970913 1.1068918 19.5401156 1.1068918 19.5401156 9.62685265 26.628734 9.62685265 26.628734 1.1068918 34.1979367 1.1068918 34.1979367 25.6349606 26.628734 25.6349606 26.628734 15.9132532 19.5401156 15.9132532 19.5401156 25.6349606 11.970913 25.6349606"></polygon>
							<path d="M48.3801795,20.104372 C50.3069666,20.104372 53.2661199,18.8326531 53.2661199,13.3714815 C53.2661199,7.90919922 50.3069666,6.63748039 48.3801795,6.63748039 C46.4533925,6.63748039 43.4942392,7.90919922 43.4942392,13.3714815 C43.4942392,18.8326531 46.4533925,20.104372 48.3801795,20.104372 M48.3801795,0.523233944 C55.8459231,0.523233944 60.8353226,5.88222379 60.8353226,13.3714815 C60.8353226,20.8607392 55.8459231,26.2186184 48.3801795,26.2186184 C40.9133235,26.2186184 35.9239241,20.8607392 35.9239241,13.3714815 C35.9239241,5.88222379 40.9133235,0.523233944 48.3801795,0.523233944"></path>
					</g>
			</g>
		</svg>
	</xsl:variable>
	
	<xsl:variable name="Image-Logo-IHO-SVG">
		<svg width="100px" height="100px" viewBox="0 0 100 100" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
			<g>
				<polygon fill="#05164D" points="0 100 100 100 100 0 0 0"/>
				<g transform="translate(19.811321, 15.277778)" fill="#FEDC5B">
					<path d="M28.7238836,10.581 C28.5202673,10.5876667 28.3749843,10.7354444 28.3815881,10.9365556 C28.3881918,11.1343333 28.5433805,11.2721111 28.7480975,11.2643333 C28.9528145,11.2565556 29.0958962,11.1076667 29.0892925,10.911 C29.0826887,10.7098889 28.9286006,10.5732222 28.7238836,10.581"/>
					<path d="M30.2124843,35.6943333 L30.5393711,33.2898889 C30.5778931,33.0098889 30.6615409,32.7465556 30.765,32.4921111 L24.4705031,32.4921111 L24.4705031,24.2676667 L20.2396855,24.2676667 L20.2396855,44.8998889 L24.4705031,44.8998889 L24.4705031,36.471 L30.201478,36.471 C30.1761635,36.2176667 30.1761635,35.9576667 30.2124843,35.6943333"/>
					<path d="M33.993805,26.334 C33.8474214,25.704 33.4677044,25.1717778 32.9250943,24.8328889 L32.3538679,24.4762222 L32.3538679,25.824 C32.6246226,26.0028889 32.8161321,26.274 32.8920755,26.5962222 C32.9691195,26.9284444 32.9151887,27.2695556 32.7379874,27.5573333 C32.6400314,27.7195556 32.5046541,27.8451111 32.3538679,27.9462222 L32.3538679,29.1895556 C32.9151887,29.0195556 33.391761,28.664 33.7010377,28.1584444 C34.0367296,27.6117778 34.1401887,26.9628889 33.993805,26.334"/>
					<path d="M28.2444497,47.4391111 L28.6043553,46.8035556 C28.4733805,46.6046667 28.3578145,46.3946667 28.2697642,46.1657778 C27.9538836,45.3468889 27.9725943,44.4546667 28.3214937,43.6557778 L29.2889465,41.4335556 C29.7038836,40.4802222 30.5381604,39.8057778 31.5166195,39.5702222 L31.5166195,38.7924444 C31.0587579,38.4524444 30.6966509,37.9968889 30.4655189,37.4746667 L27.641305,37.4746667 L27.641305,47.4735556 C27.8063994,47.448 27.9725943,47.4302222 28.1420912,47.4302222 C28.1762107,47.4302222 28.2103302,47.438 28.2444497,47.4391111"/>
					<path d="M29.5788522,20.4073333 C28.9206761,20.4073333 28.2746069,20.4562222 27.6417453,20.5462222 L27.6417453,31.4884444 L31.4257075,31.4884444 C31.4290094,31.4851111 31.4323113,31.4817778 31.4356132,31.4784444 L31.5170597,31.4784444 L31.5170597,31.3862222 L31.5170597,30.9673333 L31.5170597,21.1562222 L31.5170597,20.5462222 C30.8830975,20.4562222 30.2370283,20.4073333 29.5788522,20.4073333"/>
					<path d="M44.0848113,55.2396667 C43.7953459,55.4474444 43.7381132,55.8074444 43.9549371,56.1152222 C44.1706604,56.423 44.5261635,56.4896667 44.8167296,56.2807778 C45.106195,56.0741111 45.162327,55.7141111 44.9466038,55.4052222 C44.7297799,55.0974444 44.3753774,55.0318889 44.0848113,55.2396667"/>
					<polygon points="31.5727516 60.0921111 32.4015252 60.0132222 31.8787264 58.891"/>
					<path d="M14.1195283,55.3286667 C13.9016038,55.6364444 13.9566352,55.9997778 14.2461006,56.2075556 C14.535566,56.4164444 14.8932704,56.3531111 15.111195,56.0453333 C15.3302201,55.7364444 15.2740881,55.3753333 14.9846226,55.1664444 C14.6940566,54.9564444 14.3374528,55.0208889 14.1195283,55.3286667"/>
					<path d="M38.4392453,57.2156667 C37.9219497,57.4223333 37.7040252,57.9501111 37.9197484,58.499 C38.1365723,59.049 38.6527673,59.2823333 39.1711635,59.0756667 C39.6884591,58.8678889 39.9063836,58.3401111 39.6895597,57.7912222 C39.4738365,57.2401111 38.9565409,57.0078889 38.4392453,57.2156667"/>
					<path d="M51.7951572,46.8437778 C51.4803774,47.4226667 51.1413836,47.986 50.7847799,48.5371111 L52.0725157,49.376 L36.1255031,54.6782222 C34.6539623,55.1671111 33.1119811,55.4993333 31.5171698,55.6482222 L31.5171698,54.326 C30.878805,54.3893333 30.2327358,54.4237778 29.5789623,54.4237778 C29.5041195,54.4237778 29.4303774,54.4182222 29.3555346,54.4171111 L29.1618239,54.6615556 C28.7920126,55.1226667 28.313239,55.4582222 27.7761321,55.6604444 C26.1890252,55.5226667 24.6536478,55.2037778 23.1865094,54.7293333 L7.08540881,49.376 L8.37424528,48.5371111 C8.01764151,47.986 7.67754717,47.4226667 7.3627673,46.8437778 L0.140440252,50.836 C0.549874214,51.5904444 0.991226415,52.3226667 1.45459119,53.0404444 L3.62503145,51.6282222 L29.5789623,68.4337778 L55.5328931,51.6282222 L57.7033333,53.0404444 C58.1666981,52.3226667 58.6080503,51.5893333 59.0174843,50.836 L51.7951572,46.8437778 Z"/>
					<path d="M32.2681289,41.4832222 C32.2219025,41.4832222 32.1756761,41.4854444 32.1305503,41.4898889 C31.6814937,41.5398889 31.2918711,41.8287778 31.1113679,42.2432222 L30.1439151,44.4643333 C30.0096384,44.7732222 30.001934,45.1187778 30.1252044,45.4365556 C30.2484748,45.7554444 30.4840094,46.0054444 30.7899843,46.1398889 C30.9506761,46.2121111 31.120173,46.2487778 31.2940723,46.2487778 C31.4503616,46.2487778 31.6055503,46.2187778 31.7541352,46.161 C32.0689151,46.0365556 32.3165566,45.7976667 32.451934,45.4876667 L33.4193868,43.2665556 C33.6989465,42.6243333 33.4083805,41.8732222 32.772217,41.5898889 C32.6126258,41.5187778 32.4431289,41.4832222 32.2681289,41.4832222 M31.2929717,47.391 C30.9616824,47.391 30.6391981,47.3232222 30.3343239,47.1876667 C29.7509906,46.9276667 29.301934,46.4543333 29.0697013,45.8521111 C28.8374686,45.2487778 28.8506761,44.5921111 29.1071226,44.0043333 L30.0745755,41.7832222 C30.4564937,40.9054444 31.3182862,40.3398889 32.2692296,40.3398889 C32.6016195,40.3398889 32.9241038,40.4076667 33.2278774,40.5432222 C34.4363679,41.0798889 34.9866824,42.5087778 34.4561792,43.7287778 L33.4887264,45.9487778 C33.2311792,46.5387778 32.7623113,46.991 32.1646698,47.2254444 C31.9665566,47.3032222 31.7596384,47.3543333 31.5516195,47.3776667 C31.4657704,47.3865556 31.3788208,47.391 31.2929717,47.391"/>
					<path d="M33.7427516,32.4657778 C33.4752987,32.4691111 33.2177516,32.558 33.0009277,32.7257778 C32.7312736,32.9313333 32.5573742,33.2291111 32.5122484,33.5646667 L32.184261,35.968 C32.1380346,36.3046667 32.2260849,36.6391111 32.4297013,36.9102222 C32.6333176,37.1813333 32.9293868,37.3568889 33.2617767,37.4024444 C33.3201101,37.4113333 33.3784434,37.4146667 33.4356761,37.4146667 C34.0608333,37.4146667 34.5968396,36.9424444 34.6826887,36.3157778 L35.0095755,33.9113333 C35.0558019,33.5746667 34.9688522,33.2402222 34.7652358,32.9691111 C34.5616195,32.698 34.2655503,32.5235556 33.9320597,32.4768889 C33.8781289,32.4691111 33.8219969,32.4657778 33.7669654,32.4657778 L33.7647642,32.4657778 L33.7427516,32.4657778 Z M33.4279717,38.558 C33.3223113,38.558 33.2155503,38.5502222 33.1076887,38.5346667 C32.4759277,38.4468889 31.9135063,38.1146667 31.5271855,37.6013333 C31.1408648,37.0857778 30.9757704,36.4502222 31.0627201,35.8124444 L31.3907075,33.4091111 C31.4765566,32.7713333 31.8056447,32.2057778 32.3163365,31.8146667 C32.7367767,31.4924444 33.2364623,31.3213333 33.7581604,31.3213333 C33.8671226,31.3213333 33.9771855,31.3291111 34.0861478,31.3446667 C34.7190094,31.4313333 35.2803302,31.7635556 35.6677516,32.2791111 C36.0540723,32.7935556 36.2191667,33.4291111 36.1311164,34.0668889 L35.8042296,36.4702222 C35.6446384,37.6446667 34.6397642,38.5413333 33.4675943,38.558 L33.4279717,38.558 Z"/>
					<path d="M23.9811635,17.3453333 C23.8644969,17.3453333 23.7467296,17.362 23.6344654,17.3953333 C22.9663836,17.5908889 22.5800629,18.2975556 22.772673,18.9708889 L23.4396541,21.302 C23.5948428,21.8431111 24.0945283,22.2208889 24.6525472,22.2208889 C24.7703145,22.2208889 24.8869811,22.2053333 25.0003459,22.172 C25.3228302,22.0775556 25.590283,21.8608889 25.7531761,21.562 C25.9160692,21.2631111 25.9545912,20.9197778 25.8621384,20.5953333 L25.1951572,18.2642222 C25.1027044,17.9408889 24.8880818,17.6708889 24.5920126,17.5053333 C24.4951572,17.4508889 24.3905975,17.4097778 24.2805346,17.382 C24.1825786,17.3575556 24.0813208,17.3453333 23.9811635,17.3453333 M24.6525472,23.3642222 C24.4610377,23.3642222 24.2684277,23.3408889 24.0813208,23.2942222 C23.2514465,23.0875556 22.5888679,22.4464444 22.3522327,21.6197778 L21.6852516,19.2886667 C21.3187421,18.0097778 22.051761,16.6675556 23.3185849,16.2975556 C23.5365094,16.2342222 23.7610377,16.202 23.9844654,16.202 C24.3839937,16.202 24.783522,16.3053333 25.1390252,16.5042222 C25.7003459,16.8164444 26.106478,17.3286667 26.2825786,17.9475556 L26.9506604,20.2786667 C27.126761,20.8964444 27.0541195,21.5486667 26.7448428,22.1142222 C26.4344654,22.6808889 25.9281761,23.0908889 25.3151258,23.2697778 C25.0994025,23.3331111 24.8759748,23.3642222 24.6525472,23.3642222"/>
					<path d="M22.1641352,8.82855556 C22.3677516,8.54744444 22.6704245,8.34633333 23.0270283,8.30411111 C23.075456,8.29855556 23.1238836,8.29633333 23.1734119,8.29633333 C23.2669654,8.29633333 23.3616195,8.30633333 23.4540723,8.32744444 C23.6830031,8.37966667 23.8866195,8.49855556 24.0517138,8.66188889 L25.329544,8.54966667 C25.2877201,8.45855556 25.2502987,8.36744444 25.1963679,8.28188889 C24.855173,7.73411111 24.3246698,7.35522222 23.7028145,7.213 C23.5289151,7.17188889 23.3495126,7.153 23.1723113,7.153 C22.0980975,7.153 21.1482547,7.90188889 20.868695,8.943 L22.1641352,8.82855556 Z"/>
					<path d="M29.6740566,5.19522222 C29.4033019,4.83855556 28.8827044,4.76077778 28.5128931,5.02188889 L23.236478,8.73411111 L26.4558176,8.44966667 L29.4935535,6.31188889 C29.8644654,6.05188889 29.9448113,5.55188889 29.6740566,5.19522222"/>
					<path d="M20.2831604,13.9051111 C20.313978,13.9662222 20.3370912,14.0295556 20.3745126,14.0884444 C20.7157075,14.6351111 21.2451101,15.0151111 21.8669654,15.1573333 C22.0441667,15.1984444 22.2235692,15.2184444 22.4018711,15.2184444 C22.4932233,15.2184444 22.5856761,15.2128889 22.6770283,15.2017778 C23.0303302,15.1595556 23.3638208,15.0395556 23.6708962,14.844 C23.9185377,14.6873333 24.125456,14.4862222 24.2971541,14.2595556 L20.2831604,13.9051111 Z"/>
					<path d="M21.1678459,12.52 L21.5211478,10.95 C21.2834119,10.9455556 21.0456761,10.9433333 20.8068396,10.9366667 C20.660456,10.9322222 20.5173742,10.9066667 20.3753931,10.8822222 L20.0639151,12.2666667 C20.0088836,12.5122222 20.0033805,12.7588889 20.0231918,13.0022222 L21.1799528,13.1044444 C21.1326258,12.9133333 21.1238208,12.7155556 21.1678459,12.52"/>
					<path d="M25.2779245,10.8554444 C24.8894025,10.8876667 24.5008805,10.911 24.1112579,10.9276667 L23.6269811,13.0832222 C23.6082704,13.1632222 23.5818553,13.2398889 23.5510377,13.3132222 L24.7044969,13.4154444 C24.7122013,13.3887778 24.7254088,13.3643333 24.7309119,13.3365556 L25.2636164,10.971 C25.2724214,10.9321111 25.2713208,10.8943333 25.2779245,10.8554444"/>
					<path d="M34.6886321,24.268 L34.6886321,30.5957778 C36.1997956,31.0502222 37.2035692,32.5613333 36.9823428,34.1857778 L36.655456,36.5891111 C36.4958648,37.7568889 35.7177201,38.7168889 34.6886321,39.1602222 L34.6886321,40.5713333 C35.5086006,41.5024444 35.7694497,42.8646667 35.2411478,44.0768889 L34.8834434,44.9002222 L38.9183491,44.9002222 L38.9183491,24.268 L34.6886321,24.268 Z"/>
					<path d="M29.5788522,15.8918889 C28.4165881,15.8918889 27.2818396,16.0052222 26.1801101,16.2118889 C26.6148585,16.6141111 26.9406447,17.1218889 27.1079403,17.7063333 L27.5845126,19.3752222 C28.2382862,19.2885556 28.903066,19.2396667 29.5788522,19.2396667 C37.9678459,19.2396667 44.7686321,26.1041111 44.7686321,34.573 C44.7686321,42.4685556 38.8571541,48.9685556 31.2595126,49.8118889 C31.3090409,49.9907778 31.3519654,50.1741111 31.3717767,50.3618889 C31.4642296,51.2363333 31.2154874,52.0907778 30.6706761,52.7718889 L30.2997642,53.2363333 C40.1856132,52.8541111 48.0837264,44.6474444 48.0837264,34.573 C48.0837264,24.2552222 39.7992925,15.8918889 29.5788522,15.8918889"/>
					<path d="M24.0999214,50.5392222 L25.1378145,49.2403333 C18.9159591,47.3214444 14.3890723,41.4825556 14.3890723,34.5736667 C14.3890723,29.1203333 17.2110849,24.3358889 21.4584119,21.617 L20.8607704,19.5292222 C20.7264937,19.0625556 20.7033805,18.5914444 20.7705189,18.1403333 C14.9955189,21.3025556 11.073978,27.4747778 11.073978,34.5736667 C11.073978,42.7081111 16.226022,49.6247778 23.4142296,52.1881111 C23.4879717,51.5892222 23.7158019,51.0203333 24.0999214,50.5392222"/>
					<path d="M29.0833491,51.4821111 L27.6107075,53.3998889 C27.4048899,53.6665556 27.1077201,53.8376667 26.7720283,53.881 C26.6135377,53.901 26.4561478,53.8921111 26.304261,53.8532222 C26.1358648,53.811 25.9795755,53.7332222 25.8419969,53.6254444 C25.5778459,53.4187778 25.4094497,53.1187778 25.3665252,52.7787778 C25.3225,52.4398889 25.4138522,52.1065556 25.6185692,51.8398889 L27.0912107,49.9232222 C27.3652673,49.5643333 27.8143239,49.3798889 28.2600786,49.4421111 C28.3052044,49.4498889 28.3514308,49.4576667 28.3965566,49.4687778 C28.5660535,49.5121111 28.7212421,49.5887778 28.8599214,49.6965556 C29.4080346,50.1265556 29.5092925,50.9276667 29.0833491,51.4821111 M29.5533176,48.7932222 C29.2902673,48.5876667 28.9941981,48.4421111 28.6728145,48.3598889 C27.7504874,48.1265556 26.7775314,48.4654444 26.1952987,49.2221111 L24.7237579,51.1387778 C24.3330346,51.6465556 24.1613365,52.281 24.242783,52.9232222 C24.3231289,53.5643333 24.6445126,54.1354444 25.1475,54.5276667 C25.1519025,54.531 25.156305,54.5332222 25.1607075,54.5365556 C25.8937264,54.701 26.6333491,54.8265556 27.3773742,54.9087778 C27.8220283,54.7587778 28.2127516,54.481 28.5055189,54.0998889 L29.9781604,52.1832222 C30.786022,51.131 30.5967138,49.6098889 29.5533176,48.7932222"/>
					<path d="M33.8245283,34.0461111 C33.7441824,34.0461111 33.6649371,34.0305556 33.591195,34.0016667 C33.4294025,33.9383333 33.3017296,33.8138889 33.2323899,33.6516667 L32.3397799,31.5594444 L32.345283,28.2361111 L34.427673,33.1105556 C34.5718553,33.445 34.4199686,33.8394444 34.0886792,33.9883333 C34.0050314,34.0261111 33.9158805,34.0461111 33.8245283,34.0461111"/>
					<path d="M24.4374843,21.7246667 C24.3175157,21.5991111 24.2536792,21.4335556 24.2558805,21.2591111 C24.2591824,21.0846667 24.328522,20.9213333 24.4539937,20.7991111 C24.5750629,20.6802222 24.7335535,20.6146667 24.9019497,20.6146667 C25.0802516,20.6146667 25.2464465,20.6857778 25.3708176,20.8157778 L26.8148428,22.328 L26.8148428,24.2135556 L24.4374843,21.7246667 Z"/>
					<path d="M32.2858491,43.0652222 C32.2484277,43.0652222 32.2121069,43.0618889 32.1735849,43.0552222 C31.8070755,42.9785556 31.5858491,42.6474444 31.645283,42.2996667 L32.6699686,36.3496667 C32.7238994,36.0352222 32.9924528,35.8074444 33.3083333,35.8074444 C33.3446541,35.8074444 33.3820755,35.8096667 33.4194969,35.8174444 C33.5867925,35.8418889 33.7320755,35.933 33.8333333,36.073 C33.9356918,36.2163333 33.9775157,36.3985556 33.9477987,36.573 L32.9231132,42.523 C32.8691824,42.8363333 32.6017296,43.0652222 32.2858491,43.0652222"/>
					<path d="M26.5785377,54.7134444 C26.1052673,54.6423333 25.6804245,54.5645556 25.2863994,54.479 L25.8928459,52.7212222 C25.9830975,52.459 26.2296384,52.2823333 26.5058962,52.2823333 C26.5785377,52.2823333 26.648978,52.2945556 26.7183176,52.319 C26.8823113,52.3756667 27.0143868,52.4945556 27.0881289,52.6523333 C27.1640723,52.809 27.1750786,52.9867778 27.1178459,53.1523333 L26.5785377,54.7134444 Z"/>
					<path d="M28.1730189,51.1153333 C28.0607547,51.1153333 27.9506918,51.0853333 27.8516352,51.0286667 C27.7019497,50.942 27.5940881,50.8008889 27.5489623,50.632 C27.5027358,50.4642222 27.5258491,50.2875556 27.6116981,50.1353333 L30.5800943,44.8931111 C30.6956604,44.6908889 30.9113836,44.5642222 31.144717,44.5642222 C31.2558805,44.5642222 31.367044,44.5942222 31.465,44.6508889 C31.7753774,44.8297778 31.883239,45.2308889 31.7049371,45.5431111 L28.7365409,50.7853333 C28.6220755,50.9886667 28.4074528,51.1142222 28.1763208,51.1153333 L28.1730189,51.1153333 Z"/>
					<path d="M23.9289937,18.8638889 C23.6417296,18.8583333 23.3885849,18.6572222 23.3148428,18.3772222 L22.2538365,14.3172222 L23.5977044,14.3261111 L24.5684591,18.0416667 C24.6135849,18.2116667 24.5893711,18.3872222 24.5024214,18.5383333 C24.4143711,18.6894444 24.2745912,18.7972222 24.1072956,18.8416667 C24.0533648,18.8561111 23.9972327,18.8638889 23.9411006,18.8638889 L23.9289937,18.8638889 Z"/>
					<path d="M32.2675786,12.7185556 L32.4822013,11.0318889 L31.9197799,11.1685556 L31.9913208,10.6163333 L33.1370755,10.3318889 L32.8222956,12.7907778 L32.2675786,12.7185556 Z M31.6072013,12.103 L31.5796855,12.6263333 L29.9342453,12.5418889 L29.9562579,12.0996667 L30.8334591,11.3174444 C30.9567296,11.2085556 31.0227673,11.0918889 31.0293711,10.9596667 C31.0392767,10.7774444 30.9127044,10.6485556 30.73,10.6396667 C30.5109748,10.6285556 30.3623899,10.7496667 30.2259119,10.8852222 L29.914434,10.4852222 C30.0729245,10.3096667 30.3546855,10.0796667 30.8158491,10.1041111 C31.3243396,10.1296667 31.6369182,10.4596667 31.6127044,10.933 C31.5983962,11.223 31.477327,11.4007778 31.2142767,11.6407778 L30.7542138,12.0596667 L31.6072013,12.103 Z M29.4587736,11.5685556 L28.8501258,12.5641111 L28.1765409,12.5874444 L28.7268553,11.7441111 L28.689434,11.7463333 C28.1468239,11.7652222 27.8089308,11.4152222 27.793522,10.9618889 C27.7759119,10.4707778 28.1677358,10.0952222 28.7059434,10.0763333 C29.2408491,10.0563333 29.6623899,10.3952222 29.6788994,10.8796667 C29.6877044,11.1096667 29.6051572,11.333 29.4587736,11.5685556 Z M26.9999686,12.7041111 L26.8106604,11.0185556 L26.2977673,11.2852222 L26.2361321,10.7341111 L27.2795283,10.1818889 L27.5546855,12.6407778 L26.9999686,12.7041111 Z M46.8454088,10.5496667 L31.5169497,9.19633333 L31.5169497,8.29522222 C32.7452516,7.60744444 33.5784277,6.28522222 33.5784277,4.76633333 C33.5784277,2.53855556 31.788805,0.733 29.5831447,0.733 C27.3763836,0.733 25.586761,2.53855556 25.586761,4.76633333 C25.586761,5.26633333 25.684717,5.74188889 25.8498113,6.183 L27.677956,4.89633333 C27.6735535,4.853 27.6647484,4.81077778 27.6647484,4.76633333 C27.6647484,3.69744444 28.523239,2.83077778 29.5831447,2.83077778 C30.6419497,2.83077778 31.5004403,3.69744444 31.5004403,4.76633333 C31.5004403,4.86855556 31.4861321,4.96522222 31.4707233,5.063 C31.4542138,5.17077778 31.4266981,5.27522222 31.3936792,5.37633333 C31.3903774,5.38744444 31.3870755,5.39966667 31.3837736,5.40966667 C31.3507547,5.503 31.3100314,5.59077778 31.2649057,5.67744444 C31.255,5.69633333 31.2450943,5.71522222 31.2351887,5.73411111 C31.1911635,5.81077778 31.1416352,5.883 31.088805,5.953 C31.0689937,5.97855556 31.0480818,6.00411111 31.0271698,6.02855556 C30.9765409,6.08744444 30.9226101,6.14411111 30.8653774,6.19633333 C30.8323585,6.22633333 30.7971384,6.25411111 30.7630189,6.283 C30.7090881,6.32522222 30.6562579,6.36633333 30.5990252,6.40188889 C30.5494969,6.433 30.4988679,6.45966667 30.4471384,6.48522222 C30.3965094,6.51188889 30.3458805,6.53966667 30.2919497,6.56188889 C30.2237107,6.58966667 30.1521698,6.60855556 30.0806289,6.62855556 C30.0465094,6.63744444 30.0145912,6.64744444 29.9804717,6.65633333 C29.9309434,6.703 29.8825157,6.75077778 29.8241824,6.79188889 L27.6416352,8.32744444 L27.6416352,9.22411111 L12.2977673,10.5796667 L13.6350314,12.4385556 L27.6416352,13.6752222 L27.6416352,14.8207778 C28.2788994,14.7574444 28.9249686,14.723 29.5787421,14.723 C30.2325157,14.723 30.8785849,14.7574444 31.5169497,14.8207778 L31.5169497,13.7041111 L45.4619182,12.4718889 L46.8454088,10.5496667 Z"/>
				</g>
			</g>
		</svg>
	</xsl:variable>
	
	<xsl:variable name="Image-Text-IHO-SVG">
		<svg width="100px" height="100px" viewBox="0 0 100 100" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
			<polygon fill="#F5EED6" points="0 100 100 100 100 0 0 0"/>
			<polygon fill="#2F4565" points="16 41 17 41 17 33 16 33"/>
			<g>
				<path d="M18.9185915,35.2588028 L19.6073239,35.2588028 L19.6073239,36.231338 L19.6284507,36.231338 C19.8805634,35.5538732 20.6340845,35.0947183 21.4312676,35.0947183 C23.0164789,35.0947183 23.4967606,35.9257042 23.4967606,37.2693662 L23.4967606,40.896831 L22.8080282,40.896831 L22.8080282,37.3785211 C22.8080282,36.4059859 22.491831,35.6735915 21.3770423,35.6735915 C20.2840845,35.6735915 19.6284507,36.5038732 19.6073239,37.6080986 L19.6073239,40.896831 L18.9185915,40.896831 L18.9185915,35.2588028 Z" fill="#2F4565"/>
				<path d="M26.4402113,35.2588028 L27.5873944,35.2588028 L27.5873944,35.8383803 L26.4402113,35.8383803 L26.4402113,39.6397887 C26.4402113,40.0890845 26.5057042,40.3503521 26.9972535,40.3841549 C27.1944366,40.3841549 27.3902113,40.3728873 27.5873944,40.3503521 L27.5873944,40.940493 C27.3789437,40.940493 27.183169,40.9623239 26.9754225,40.9623239 C26.0585211,40.9623239 25.7409155,40.6566901 25.7514789,39.6954225 L25.7514789,35.8383803 L24.7683803,35.8383803 L24.7683803,35.2588028 L25.7514789,35.2588028 L25.7514789,33.5651408 L26.4402113,33.5651408 L26.4402113,35.2588028 Z" fill="#2F4565"/>
				<path d="M33.1842958,37.6847183 C33.1519014,36.6466901 32.506831,35.6741549 31.3927465,35.6741549 C30.2673944,35.6741549 29.6441549,36.6579577 29.535,37.6847183 L33.1842958,37.6847183 Z M29.535,38.2628873 C29.5455634,39.2685211 30.0702113,40.4819014 31.3927465,40.4819014 C32.3976761,40.4819014 32.9448592,39.8917606 33.1624648,39.0396479 L33.8511972,39.0396479 C33.5561268,40.3178169 32.813169,41.0600704 31.3927465,41.0600704 C29.600493,41.0600704 28.8469718,39.6847183 28.8469718,38.0783803 C28.8469718,36.5917606 29.600493,35.0945775 31.3927465,35.0945775 C33.2061268,35.0945775 33.9272535,36.6790845 33.8730282,38.2628873 L29.535,38.2628873 Z" fill="#2F4565"/>
				<path d="M35.3523239,35.2588028 L35.9847183,35.2588028 L35.9847183,36.581338 L36.0072535,36.581338 C36.3565493,35.6735915 37.1227465,35.1390845 38.1389437,35.1827465 L38.1389437,35.8707746 C36.8924648,35.8045775 36.0410563,36.7228873 36.0410563,37.8919014 L36.0410563,40.896831 L35.3523239,40.896831 L35.3523239,35.2588028 Z" fill="#2F4565"/>
				<path d="M39.5288732,35.2588028 L40.2176056,35.2588028 L40.2176056,36.231338 L40.2387324,36.231338 C40.4894366,35.5538732 41.243662,35.0947183 42.0415493,35.0947183 C43.6253521,35.0947183 44.1070423,35.9257042 44.1070423,37.2693662 L44.1070423,40.896831 L43.4183099,40.896831 L43.4183099,37.3785211 C43.4183099,36.4059859 43.1021127,35.6735915 41.9873239,35.6735915 C40.893662,35.6735915 40.2387324,36.5038732 40.2176056,37.6080986 L40.2176056,40.896831 L39.5288732,40.896831 L39.5288732,35.2588028 Z" fill="#2F4565"/>
				<path d="M49.5626761,37.8154225 L49.5408451,37.8154225 C49.4535211,37.979507 49.1478873,38.0344366 48.9619718,38.066831 C47.7922535,38.2752817 46.3394366,38.2633099 46.3394366,39.3675352 C46.3394366,40.0562676 46.9514085,40.4823239 47.5964789,40.4823239 C48.6450704,40.4823239 49.5732394,39.8154225 49.5626761,38.7119014 L49.5626761,37.8154225 Z M45.8915493,36.9851408 C45.9570423,35.6626056 46.8859155,35.0942958 48.1746479,35.0942958 C49.1690141,35.0942958 50.2514085,35.4006338 50.2514085,36.9090845 L50.2514085,39.9027465 C50.2514085,40.1647183 50.3830986,40.3175352 50.656338,40.3175352 C50.7323944,40.3175352 50.8197183,40.2957042 50.8739437,40.2738732 L50.8739437,40.8534507 C50.721831,40.8865493 50.6119718,40.8971127 50.4267606,40.8971127 C49.7267606,40.8971127 49.6183099,40.5041549 49.6183099,39.9133099 L49.5964789,39.9133099 C49.1147887,40.6457042 48.6239437,41.060493 47.5415493,41.060493 C46.5035211,41.060493 45.6507042,40.5471127 45.6507042,39.4111972 C45.6507042,37.8266901 47.1922535,37.7717606 48.678169,37.5971127 C49.2464789,37.5309155 49.5626761,37.4548592 49.5626761,36.8316197 C49.5626761,35.9034507 48.8971831,35.6738732 48.0873239,35.6738732 C47.2359155,35.6738732 46.6014085,36.066831 46.5802817,36.9851408 L45.8915493,36.9851408 Z" fill="#2F4565"/>
				<path d="M53.2709155,35.2588028 L54.4188028,35.2588028 L54.4188028,35.8383803 L53.2709155,35.8383803 L53.2709155,39.6397887 C53.2709155,40.0890845 53.3364085,40.3503521 53.828662,40.3841549 C54.0244366,40.3841549 54.2216197,40.3728873 54.4188028,40.3503521 L54.4188028,40.940493 C54.2110563,40.940493 54.0138732,40.9623239 53.806831,40.9623239 C52.8885211,40.9623239 52.5716197,40.6566901 52.5821831,39.6954225 L52.5821831,35.8383803 L51.5983803,35.8383803 L51.5983803,35.2588028 L52.5821831,35.2588028 L52.5821831,33.5651408 L53.2709155,33.5651408 L53.2709155,35.2588028 Z" fill="#2F4565"/>
				<g/>
				<path d="M55.9725352,40.8971831 L56.6612676,40.8971831 L56.6612676,35.2591549 L55.9725352,35.2591549 L55.9725352,40.8971831 Z M55.9725352,34.1985915 L56.6612676,34.1985915 L56.6612676,33.0950704 L55.9725352,33.0950704 L55.9725352,34.1985915 Z" fill="#2F4565"/>
				<path d="M58.9352817,38.0780986 C58.9352817,39.279507 59.5909155,40.4823239 60.9127465,40.4823239 C62.2352817,40.4823239 62.8909155,39.279507 62.8909155,38.0780986 C62.8909155,36.8759859 62.2352817,35.6738732 60.9127465,35.6738732 C59.5909155,35.6738732 58.9352817,36.8759859 58.9352817,38.0780986 M63.5789437,38.0780986 C63.5789437,39.6957042 62.6388028,41.060493 60.9127465,41.060493 C59.1859859,41.060493 58.2465493,39.6957042 58.2465493,38.0780986 C58.2465493,36.460493 59.1859859,35.0942958 60.9127465,35.0942958 C62.6388028,35.0942958 63.5789437,36.460493 63.5789437,38.0780986" fill="#2F4565"/>
				<path d="M65.1457746,35.2588028 L65.834507,35.2588028 L65.834507,36.231338 L65.8556338,36.231338 C66.1077465,35.5538732 66.8612676,35.0947183 67.6584507,35.0947183 C69.243662,35.0947183 69.7239437,35.9257042 69.7239437,37.2693662 L69.7239437,40.896831 L69.0352113,40.896831 L69.0352113,37.3785211 C69.0352113,36.4059859 68.7190141,35.6735915 67.6042254,35.6735915 C66.5112676,35.6735915 65.8556338,36.5038732 65.834507,37.6080986 L65.834507,40.896831 L65.1457746,40.896831 L65.1457746,35.2588028 Z" fill="#2F4565"/>
				<path d="M75.1806338,37.8154225 L75.1588028,37.8154225 C75.0714789,37.979507 74.7658451,38.0344366 74.5799296,38.066831 C73.4102113,38.2752817 71.9573944,38.2633099 71.9573944,39.3675352 C71.9573944,40.0562676 72.5693662,40.4823239 73.2144366,40.4823239 C74.2637324,40.4823239 75.1919014,39.8154225 75.1806338,38.7119014 L75.1806338,37.8154225 Z M71.509507,36.9851408 C71.575,35.6626056 72.5038732,35.0942958 73.7926056,35.0942958 C74.7869718,35.0942958 75.8693662,35.4006338 75.8693662,36.9090845 L75.8693662,39.9027465 C75.8693662,40.1647183 76.0010563,40.3175352 76.2742958,40.3175352 C76.3503521,40.3175352 76.4376761,40.2957042 76.4919014,40.2738732 L76.4919014,40.8534507 C76.3397887,40.8865493 76.2299296,40.8971127 76.0447183,40.8971127 C75.3447183,40.8971127 75.2362676,40.5041549 75.2362676,39.9133099 L75.2144366,39.9133099 C74.7327465,40.6457042 74.2419014,41.060493 73.159507,41.060493 C72.1214789,41.060493 71.268662,40.5471127 71.268662,39.4111972 C71.268662,37.8266901 72.8102113,37.7717606 74.2961268,37.5971127 C74.8644366,37.5309155 75.1806338,37.4548592 75.1806338,36.8316197 C75.1806338,35.9034507 74.5151408,35.6738732 73.7059859,35.6738732 C72.8538732,35.6738732 72.2193662,36.066831 72.1982394,36.9851408 L71.509507,36.9851408 Z" fill="#2F4565"/>
				<polygon fill="#2F4565" points="77.8070423 40.8971831 78.4957746 40.8971831 78.4957746 33.0950704 77.8070423 33.0950704"/>
				<polygon fill="#2F4565" points="16.0861972 47.4462676 16.8305634 47.4462676 16.8305634 50.8328873 21.4629577 50.8328873 21.4629577 47.4462676 22.2059155 47.4462676 22.2059155 55.2483803 21.4629577 55.2483803 21.4629577 51.4666901 16.8305634 51.4666901 16.8305634 55.2483803 16.0861972 55.2483803"/>
				<path d="M23.565493,49.6094366 L24.2978873,49.6094366 L26.156338,54.4178873 L27.893662,49.6094366 L28.5823944,49.6094366 L26.1338028,56.1108451 C25.7408451,57.0615493 25.5112676,57.335493 24.6471831,57.335493 C24.3746479,57.3242254 24.2323944,57.3242254 24.1232394,57.2805634 L24.1232394,56.7009859 C24.2866197,56.7340845 24.4401408,56.7552113 24.5929577,56.7552113 C25.2049296,56.7552113 25.3464789,56.3953521 25.5760563,55.8714085 L25.8169014,55.226338 L23.565493,49.6094366 Z" fill="#2F4565"/>
				<path d="M32.1028873,54.8330282 C33.5669718,54.8330282 34.0810563,53.5978169 34.0810563,52.4288028 C34.0810563,51.2597887 33.5669718,50.0245775 32.1028873,50.0245775 C30.7909155,50.0245775 30.2564085,51.2597887 30.2564085,52.4288028 C30.2564085,53.5978169 30.7909155,54.8330282 32.1028873,54.8330282 Z M34.7697887,55.2478169 L34.1352817,55.2478169 L34.1352817,54.1773944 L34.1134507,54.1773944 C33.8183803,54.9090845 32.9233099,55.4111972 32.1028873,55.4111972 C30.3866901,55.4111972 29.5676761,54.0245775 29.5676761,52.4288028 C29.5676761,50.8330282 30.3866901,49.445 32.1028873,49.445 C32.9444366,49.445 33.7641549,49.8724648 34.0592254,50.6809155 L34.0810563,50.6809155 L34.0810563,47.4464085 L34.7697887,47.4464085 L34.7697887,55.2478169 Z" fill="#2F4565"/>
				<path d="M36.6311972,49.6094366 L37.2635915,49.6094366 L37.2635915,50.9319718 L37.2861268,50.9319718 C37.6354225,50.0242254 38.4016197,49.4897183 39.4178169,49.5333803 L39.4178169,50.2221127 C38.171338,50.1552113 37.3199296,51.0735211 37.3199296,52.2425352 L37.3199296,55.248169 L36.6311972,55.248169 L36.6311972,49.6094366 Z" fill="#2F4565"/>
				<path d="M40.8293662,52.4288028 C40.8293662,53.6302113 41.485,54.8330282 42.806831,54.8330282 C44.1293662,54.8330282 44.785,53.6302113 44.785,52.4288028 C44.785,51.2273944 44.1293662,50.0245775 42.806831,50.0245775 C41.485,50.0245775 40.8293662,51.2273944 40.8293662,52.4288028 M45.4730282,52.4288028 C45.4730282,54.0464085 44.5328873,55.4111972 42.806831,55.4111972 C41.0800704,55.4111972 40.1406338,54.0464085 40.1406338,52.4288028 C40.1406338,50.8111972 41.0800704,49.445 42.806831,49.445 C44.5328873,49.445 45.4730282,50.8111972 45.4730282,52.4288028" fill="#2F4565"/>
				<path d="M51.1269014,52.3634507 C51.1269014,51.2599296 50.6128169,50.0247183 49.3128169,50.0247183 C48.0015493,50.0247183 47.4550704,51.1937324 47.4550704,52.3634507 C47.4550704,53.4993662 48.0452113,54.6028873 49.3128169,54.6028873 C50.503662,54.6028873 51.1269014,53.5106338 51.1269014,52.3634507 Z M51.8156338,54.789507 C51.8043662,56.4711972 51.1592958,57.498662 49.3128169,57.498662 C48.1867606,57.498662 47.0726761,56.9965493 46.9747887,55.7951408 L47.6628169,55.7951408 C47.8149296,56.6247183 48.5473239,56.920493 49.3128169,56.920493 C50.5804225,56.920493 51.1269014,56.1662676 51.1269014,54.789507 L51.1269014,54.0247183 L51.1050704,54.0247183 C50.788169,54.7120423 50.1212676,55.1824648 49.3128169,55.1824648 C47.5092958,55.1824648 46.766338,53.8930282 46.766338,52.2873944 C46.766338,50.7345775 47.6846479,49.4451408 49.3128169,49.4451408 C50.1325352,49.4451408 50.831831,49.9592254 51.1050704,50.5824648 L51.1269014,50.5824648 L51.1269014,49.6092254 L51.8156338,49.6092254 L51.8156338,54.789507 Z" fill="#2F4565"/>
				<path d="M53.6759859,49.6094366 L54.3097887,49.6094366 L54.3097887,50.9319718 L54.3316197,50.9319718 C54.6816197,50.0242254 55.4464085,49.4897183 56.4626056,49.5333803 L56.4626056,50.2221127 C55.2175352,50.1552113 54.3647183,51.0735211 54.3647183,52.2425352 L54.3647183,55.248169 L53.6759859,55.248169 L53.6759859,49.6094366 Z" fill="#2F4565"/>
				<path d="M61.2728873,52.1664085 L61.2510563,52.1664085 C61.1644366,52.330493 60.8580986,52.3854225 60.6714789,52.4178169 C59.503169,52.6262676 58.0496479,52.6142958 58.0496479,53.7185211 C58.0496479,54.4072535 58.6609155,54.8333099 59.3059859,54.8333099 C60.3545775,54.8333099 61.2841549,54.1664085 61.2728873,53.0628873 L61.2728873,52.1664085 Z M57.6010563,51.3361268 C57.6672535,50.0135915 58.5954225,49.4452817 59.8855634,49.4452817 C60.8799296,49.4452817 61.9616197,49.7509155 61.9616197,51.2600704 L61.9616197,54.2530282 C61.9616197,54.5157042 62.0926056,54.6685211 62.3658451,54.6685211 C62.4419014,54.6685211 62.5299296,54.6466901 62.5848592,54.6248592 L62.5848592,55.2044366 C62.431338,55.236831 62.3221831,55.2480986 62.1362676,55.2480986 C61.4362676,55.2480986 61.3278169,54.8544366 61.3278169,54.2642958 L61.3059859,54.2642958 C60.825,54.9966901 60.3334507,55.4114789 59.2510563,55.4114789 C58.2130282,55.4114789 57.3609155,54.8980986 57.3609155,53.7621831 C57.3609155,52.1769718 58.9017606,52.1227465 60.3876761,51.9480986 C60.9559859,51.8819014 61.2728873,51.8058451 61.2728873,51.1826056 C61.2728873,50.2544366 60.6066901,50.0241549 59.7982394,50.0241549 C58.9454225,50.0241549 58.3109155,50.4178169 58.2890845,51.3361268 L57.6010563,51.3361268 Z" fill="#2F4565"/>
				<path d="M66.5542254,50.024507 C65.0359155,50.024507 64.5767606,51.1498592 64.5767606,52.4287324 C64.5767606,53.5977465 65.0901408,54.8329577 66.5542254,54.8329577 C67.865493,54.8329577 68.4021127,53.5977465 68.4021127,52.4287324 C68.4021127,51.2597183 67.865493,50.024507 66.5542254,50.024507 Z M63.8887324,49.6097183 L64.5211268,49.6097183 L64.5211268,50.6808451 L64.543662,50.6808451 C64.8605634,49.9160563 65.6478873,49.4449296 66.5542254,49.4449296 C68.2697183,49.4449296 69.0894366,50.8329577 69.0894366,52.4287324 C69.0894366,54.024507 68.2697183,55.4111268 66.5542254,55.4111268 C65.7133803,55.4111268 64.8929577,54.9850704 64.5985915,54.1773239 L64.5767606,54.1773239 L64.5767606,57.3350704 L63.8887324,57.3350704 L63.8887324,49.6097183 Z" fill="#2F4565"/>
				<path d="M70.6990845,47.4462676 L71.3878169,47.4462676 L71.3878169,50.5821831 L71.4089437,50.5821831 C71.6610563,49.9047183 72.4152817,49.4448592 73.2117606,49.4448592 C74.7969718,49.4448592 75.2772535,50.2765493 75.2772535,51.6209155 L75.2772535,55.2483803 L74.5892254,55.2483803 L74.5892254,51.7293662 C74.5892254,50.756831 74.2723239,50.0244366 73.1575352,50.0244366 C72.0652817,50.0244366 71.4089437,50.8547183 71.3878169,51.9596479 L71.3878169,55.2483803 L70.6990845,55.2483803 L70.6990845,47.4462676 Z" fill="#2F4565"/>
				<path d="M77.1394366,55.2478873 L77.828169,55.2478873 L77.828169,49.6091549 L77.1394366,49.6091549 L77.1394366,55.2478873 Z M77.1394366,48.55 L77.828169,48.55 L77.828169,47.4464789 L77.1394366,47.4464789 L77.1394366,48.55 Z" fill="#2F4565"/>
				<path d="M83.6753521,51.3796479 C83.4901408,50.5388028 82.9760563,50.0247183 82.0802817,50.0247183 C80.7577465,50.0247183 80.1021127,51.2275352 80.1021127,52.4289437 C80.1021127,53.6303521 80.7577465,54.833169 82.0802817,54.833169 C82.9323944,54.833169 83.6316901,54.1662676 83.7197183,53.2261268 L84.4084507,53.2261268 C84.221831,54.5810563 83.3380282,55.411338 82.0802817,55.411338 C80.3542254,55.411338 79.4140845,54.0465493 79.4140845,52.4289437 C79.4140845,50.811338 80.3542254,49.4451408 82.0802817,49.4451408 C83.2816901,49.4451408 84.2112676,50.0902113 84.3640845,51.3796479 L83.6753521,51.3796479 Z" fill="#2F4565"/>
				<path d="M19.3542254,69.1293662 C21.4084507,69.1293662 22.2823944,67.4026056 22.2823944,65.6976761 C22.2823944,63.9934507 21.4084507,62.2666901 19.3542254,62.2666901 C17.2887324,62.2666901 16.4140845,63.9934507 16.4140845,65.6976761 C16.4140845,67.4026056 17.2887324,69.1293662 19.3542254,69.1293662 M19.3542254,61.6321831 C21.8021127,61.6321831 23.0253521,63.5673944 23.0253521,65.6976761 C23.0253521,67.828662 21.8021127,69.7624648 19.3542254,69.7624648 C16.8957746,69.7624648 15.6711268,67.828662 15.6711268,65.6976761 C15.6711268,63.5673944 16.8957746,61.6321831 19.3542254,61.6321831" fill="#2F4565"/>
				<path d="M24.6046479,63.960493 L25.2377465,63.960493 L25.2377465,65.2830282 L25.2595775,65.2830282 C25.6088732,64.3752817 26.3750704,63.8407746 27.3912676,63.8844366 L27.3912676,64.573169 C26.145493,64.5062676 25.2933803,65.4245775 25.2933803,66.5935915 L25.2933803,69.5985211 L24.6046479,69.5985211 L24.6046479,63.960493 Z" fill="#2F4565"/>
				<path d="M32.6702113,66.7144366 C32.6702113,65.6109155 32.156831,64.3757042 30.8561268,64.3757042 C29.5448592,64.3757042 28.9990845,65.5440141 28.9990845,66.7144366 C28.9990845,67.8503521 29.5885211,68.9538732 30.8561268,68.9538732 C32.0469718,68.9538732 32.6702113,67.8616197 32.6702113,66.7144366 Z M33.3589437,69.140493 C33.3476761,70.8221831 32.7026056,71.8496479 30.8561268,71.8496479 C29.7314789,71.8496479 28.6166901,71.3475352 28.5180986,70.1461268 L29.2061268,70.1461268 C29.3596479,70.9757042 30.0920423,71.2707746 30.8561268,71.2707746 C32.1244366,71.2707746 32.6702113,70.5172535 32.6702113,69.140493 L32.6702113,68.3757042 L32.6483803,68.3757042 C32.3314789,69.0630282 31.6645775,69.5334507 30.8561268,69.5334507 C29.0533099,69.5334507 28.3110563,68.2440141 28.3110563,66.6383803 C28.3110563,65.0855634 29.2279577,63.7961268 30.8561268,63.7961268 C31.6758451,63.7961268 32.3751408,64.3102113 32.6483803,64.9334507 L32.6702113,64.9334507 L32.6702113,63.9602113 L33.3589437,63.9602113 L33.3589437,69.140493 Z" fill="#2F4565"/>
				<path d="M38.8259859,66.5170423 L38.8041549,66.5170423 C38.716831,66.681831 38.4111972,66.7360563 38.2259859,66.7684507 C37.0555634,66.9769014 35.6027465,66.9649296 35.6027465,68.0698592 C35.6027465,68.7578873 36.2147183,69.1839437 36.8597887,69.1839437 C37.9090845,69.1839437 38.8372535,68.5170423 38.8259859,67.4135211 L38.8259859,66.5170423 Z M35.1548592,65.6867606 C35.2203521,64.3642254 36.1499296,63.7959155 37.4379577,63.7959155 C38.4330282,63.7959155 39.5147183,64.1022535 39.5147183,65.6107042 L39.5147183,68.6043662 C39.5147183,68.8670423 39.6464085,69.0191549 39.9196479,69.0191549 C39.9964085,69.0191549 40.0830282,68.9973239 40.1379577,68.975493 L40.1379577,69.5550704 C39.9851408,69.588169 39.8752817,69.5987324 39.6900704,69.5987324 C38.9907746,69.5987324 38.8816197,69.2057746 38.8816197,68.6149296 L38.8597887,68.6149296 C38.3780986,69.3473239 37.8872535,69.7621127 36.8055634,69.7621127 C35.7675352,69.7621127 34.9140141,69.2494366 34.9140141,68.1128169 C34.9140141,66.5283099 36.4555634,66.4733803 37.9414789,66.2994366 C38.510493,66.2325352 38.8259859,66.1564789 38.8259859,65.5339437 C38.8259859,64.6057746 38.160493,64.375493 37.351338,64.375493 C36.4992254,64.375493 35.8654225,64.7691549 35.8435915,65.6867606 L35.1548592,65.6867606 Z" fill="#2F4565"/>
				<path d="M41.4307746,63.960493 L42.119507,63.960493 L42.119507,64.9330282 L42.1406338,64.9330282 C42.3927465,64.2555634 43.1462676,63.7964085 43.9434507,63.7964085 C45.528662,63.7964085 46.0089437,64.6273944 46.0089437,65.9710563 L46.0089437,69.5985211 L45.3209155,69.5985211 L45.3209155,66.0802113 C45.3209155,65.1076761 45.0040141,64.3752817 43.8892254,64.3752817 C42.7969718,64.3752817 42.1406338,65.2055634 42.119507,66.3097887 L42.119507,69.5985211 L41.4307746,69.5985211 L41.4307746,63.960493 Z" fill="#2F4565"/>
				<path d="M47.8711268,69.5985915 L48.5598592,69.5985915 L48.5598592,63.9605634 L47.8711268,63.9605634 L47.8711268,69.5985915 Z M47.8711268,62.9007042 L48.5598592,62.9007042 L48.5598592,61.7971831 L47.8711268,61.7971831 L47.8711268,62.9007042 Z" fill="#2F4565"/>
				<polygon fill="#2F4565" points="50.7685915 69.0193662 54.6474648 69.0193662 54.6474648 69.5989437 49.9376056 69.5989437 49.9376056 69.0411972 53.6207042 64.5397887 50.1890141 64.5397887 50.1890141 63.9602113 54.4939437 63.9602113 54.4939437 64.4517606"/>
				<path d="M59.6443662,66.5170423 L59.6225352,66.5170423 C59.5359155,66.681831 59.2295775,66.7360563 59.0429577,66.7684507 C57.8739437,66.9769014 56.4211268,66.9649296 56.4211268,68.0698592 C56.4211268,68.7578873 57.0323944,69.1839437 57.6774648,69.1839437 C58.7260563,69.1839437 59.6556338,68.5170423 59.6443662,67.4135211 L59.6443662,66.5170423 Z M55.9725352,65.6867606 C56.0387324,64.3642254 56.9669014,63.7959155 58.256338,63.7959155 C59.2514085,63.7959155 60.3330986,64.1022535 60.3330986,65.6107042 L60.3330986,68.6043662 C60.3330986,68.8670423 60.4640845,69.0191549 60.7373239,69.0191549 C60.8133803,69.0191549 60.9014085,68.9973239 60.956338,68.975493 L60.956338,69.5550704 C60.8028169,69.588169 60.693662,69.5987324 60.5070423,69.5987324 C59.8077465,69.5987324 59.6992958,69.2057746 59.6992958,68.6149296 L59.6767606,68.6149296 C59.1964789,69.3473239 58.7042254,69.7621127 57.6225352,69.7621127 C56.584507,69.7621127 55.7323944,69.2494366 55.7323944,68.1128169 C55.7323944,66.5283099 57.2732394,66.4733803 58.7591549,66.2994366 C59.3274648,66.2325352 59.6443662,66.1564789 59.6443662,65.5339437 C59.6443662,64.6057746 58.978169,64.375493 58.1697183,64.375493 C57.3161972,64.375493 56.6823944,64.7691549 56.6605634,65.6867606 L55.9725352,65.6867606 Z" fill="#2F4565"/>
				<path d="M63.3525352,63.960493 L64.4997183,63.960493 L64.4997183,64.5400704 L63.3525352,64.5400704 L63.3525352,68.3421831 C63.3525352,68.7907746 63.4180282,69.0520423 63.9095775,69.0858451 C64.1060563,69.0858451 64.3025352,69.0752817 64.4997183,69.0520423 L64.4997183,69.6421831 C64.2912676,69.6421831 64.095493,69.6647183 63.8877465,69.6647183 C62.9701408,69.6647183 62.6532394,69.3583803 62.6638028,68.3971127 L62.6638028,64.5400704 L61.68,64.5400704 L61.68,63.960493 L62.6638028,63.960493 L62.6638028,62.266831 L63.3525352,62.266831 L63.3525352,63.960493 Z" fill="#2F4565"/>
				<path d="M66.0535211,69.5985915 L66.7422535,69.5985915 L66.7422535,63.9605634 L66.0535211,63.9605634 L66.0535211,69.5985915 Z M66.0535211,62.9007042 L66.7422535,62.9007042 L66.7422535,61.7971831 L66.0535211,61.7971831 L66.0535211,62.9007042 Z" fill="#2F4565"/>
				<path d="M69.0159155,66.7797887 C69.0159155,67.9811972 69.6722535,69.1840141 70.9940845,69.1840141 C72.3166197,69.1840141 72.9729577,67.9811972 72.9729577,66.7797887 C72.9729577,65.5783803 72.3166197,64.3755634 70.9940845,64.3755634 C69.6722535,64.3755634 69.0159155,65.5783803 69.0159155,66.7797887 M73.6609859,66.7797887 C73.6609859,68.3973944 72.7208451,69.7621831 70.9940845,69.7621831 C69.2673239,69.7621831 68.3271831,68.3973944 68.3271831,66.7797887 C68.3271831,65.1621831 69.2673239,63.7959859 70.9940845,63.7959859 C72.7208451,63.7959859 73.6609859,65.1621831 73.6609859,66.7797887" fill="#2F4565"/>
				<path d="M75.2273944,63.960493 L75.9161268,63.960493 L75.9161268,64.9330282 L75.9379577,64.9330282 C76.1879577,64.2555634 76.9421831,63.7964085 77.7407746,63.7964085 C79.3245775,63.7964085 79.8055634,64.6273944 79.8055634,65.9710563 L79.8055634,69.5985211 L79.1175352,69.5985211 L79.1175352,66.0802113 C79.1175352,65.1076761 78.8006338,64.3752817 77.6858451,64.3752817 C76.5921831,64.3752817 75.9379577,65.2055634 75.9161268,66.3097887 L75.9161268,69.5985211 L75.2273944,69.5985211 L75.2273944,63.960493 Z" fill="#2F4565"/>
			</g>
		</svg>
	</xsl:variable>
	
	<xsl:include href="./common.xsl"/>
	
</xsl:stylesheet>