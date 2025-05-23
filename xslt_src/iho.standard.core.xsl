<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
											xmlns:fo="http://www.w3.org/1999/XSL/Format" 
											xmlns:iho="https://www.metanorma.org/ns/standoc" 
											xmlns:mathml="http://www.w3.org/1998/Math/MathML" 
											xmlns:xalan="http://xml.apache.org/xalan" 
											xmlns:fox="http://xmlgraphics.apache.org/fop/extensions" 
											xmlns:java="http://xml.apache.org/xalan/java" 
											xmlns:redirect="http://xml.apache.org/xalan/redirect"
											exclude-result-prefixes="java xalan"
											extension-element-prefixes="redirect"
											version="1.0">

	<xsl:output method="xml" encoding="UTF-8" indent="no"/>
	
	<xsl:include href="./common.xsl"/>

	<xsl:key name="kfn" match="*[local-name() = 'fn'][not(ancestor::*[(local-name() = 'table' or local-name() = 'figure' or local-name() = 'localized-strings')] and not(ancestor::*[local-name() = 'name']))]" use="@reference"/>
	
	<xsl:variable name="namespace">iho</xsl:variable>
	
	<xsl:variable name="debug">false</xsl:variable>
	

	<xsl:variable name="title-en">
		<xsl:apply-templates select="/iho:metanorma/iho:bibdata/iho:title[@language = 'en']/node()"/>
	</xsl:variable>
	<xsl:variable name="docidentifier" select="/iho:metanorma/iho:bibdata/iho:docidentifier[@type = 'IHO']"/>
	<xsl:variable name="copyrightText" select="concat('© International Hydrographic Association ', /iho:metanorma/iho:bibdata/iho:copyright/iho:from ,' – All rights reserved')"/>
	<xsl:variable name="edition">
		<xsl:apply-templates select="/iho:metanorma/iho:bibdata/iho:edition[normalize-space(@language) = '']"/>
	</xsl:variable>
	<xsl:variable name="month_year">
		<xsl:apply-templates select="/iho:metanorma/iho:bibdata/iho:date[@type = 'published']"/>
	</xsl:variable>

	<!-- Example:
		<item level="1" id="Foreword" display="true">Foreword</item>
		<item id="term-script" display="false">3.2</item>
	-->
	<xsl:variable name="contents_">
		<contents>
			<xsl:call-template name="processPrefaceSectionsDefault_Contents"/>
			<xsl:call-template name="processMainSectionsDefault_Contents"/>
			
			<xsl:call-template name="processTablesFigures_Contents"/>
		</contents>
	</xsl:variable>
	<xsl:variable name="contents" select="xalan:nodeset($contents_)"/>
	
	<xsl:template match="/">
		
		<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format" xml:lang="{$lang}">
			<xsl:variable name="root-style">
				<root-style xsl:use-attribute-sets="root-style"/>
			</xsl:variable>
			<xsl:call-template name="insertRootStyle">
				<xsl:with-param name="root-style" select="$root-style"/>
			</xsl:call-template>
			<fo:layout-master-set>
				<!-- cover page -->
				<fo:simple-page-master master-name="cover" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
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
						<fo:conditional-page-master-reference master-reference="blankpage" blank-or-not-blank="blank"/>
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
						<fo:conditional-page-master-reference master-reference="blankpage" blank-or-not-blank="blank"/>
						<fo:conditional-page-master-reference odd-or-even="even" master-reference="even-landscape"/>
						<fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd-landscape"/>
					</fo:repeatable-page-master-alternatives>
				</fo:page-sequence-master>
			</fo:layout-master-set>
			
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
			
			<xsl:for-each select="xalan:nodeset($updated_xml)/*">
			
				<!-- =========================== -->
				<!-- Cover Page -->
				<fo:page-sequence master-reference="cover">				
					<fo:flow flow-name="xsl-region-body">
					
						<xsl:variable name="isCoverPageImage" select="normalize-space(/*[local-name() = 'metanorma']/*[local-name() = 'metanorma-extension']/*[local-name() = 'presentation-metadata'][*[local-name() = 'name'] = 'coverpage-image']/*[local-name() = 'value']/*[local-name() = 'image'] and 1 = 1)"/>
					
						<xsl:variable name="document_scheme" select="normalize-space(/*[local-name() = 'metanorma']/*[local-name() = 'metanorma-extension']/*[local-name() = 'presentation-metadata'][*[local-name() = 'name'] = 'document-scheme']/*[local-name() = 'value'])"/>
						
						<xsl:choose>
							<xsl:when test="$document_scheme != '' and $document_scheme != '2019' and $isCoverPageImage = 'true'">
								<xsl:call-template name="insertBackgroundPageImage"/>
							</xsl:when>
							<xsl:otherwise>
							
								<fo:block-container position="absolute" left="14.25mm" top="12mm" id="__internal_layout__coverpage_{generate-id()}">
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
															<fo:external-graphic src="{concat('data:image/png;base64,', normalize-space($Image-IHO))}" width="25.9mm" content-width="scale-to-fit" scaling="uniform" fox:alt-text="Image IHO"/>
														</fo:block>
													</fo:table-cell>
													
													<!-- https://github.com/metanorma/metanorma-iho/issues/288 -->
													<xsl:choose>
														<xsl:when test="$isCoverPageImage = 'true'">
															<fo:table-cell number-columns-spanned="2">
																<fo:block-container font-size="0"> <!-- height="168mm" width="115mm"  -->
																	<fo:block>
																		<xsl:for-each select="/*[local-name() = 'metanorma']/*[local-name() = 'metanorma-extension']/*[local-name() = 'presentation-metadata'][*[local-name() = 'name'] = 'coverpage-image'][1]/*[local-name() = 'value']/*[local-name() = 'image'][1]">
																			<xsl:choose>
																				<xsl:when test="*[local-name() = 'svg'] or java:endsWith(java:java.lang.String.new(@src), '.svg')">
																					<fo:instream-foreign-object fox:alt-text="Image Front">
																						<xsl:attribute name="content-height"><xsl:value-of select="$pageHeight"/>mm</xsl:attribute>
																						<xsl:call-template name="getSVG"/>
																					</fo:instream-foreign-object>
																				</xsl:when>
																				<xsl:when test="starts-with(@src, 'data:application/pdf;base64')">
																					<fo:external-graphic src="{@src}" fox:alt-text="Image Front"/>
																				</xsl:when>
																				<xsl:otherwise> <!-- bitmap image -->
																					<xsl:variable name="coverimage_src" select="normalize-space(@src)"/>
																					<xsl:if test="$coverimage_src != ''">
																						<xsl:variable name="coverpage">
																							<xsl:call-template name="getImageURL">
																								<xsl:with-param name="src" select="$coverimage_src"/>
																							</xsl:call-template>
																						</xsl:variable>
																						<fo:external-graphic src="{$coverpage}" width="155.5mm" content-height="scale-to-fit" scaling="uniform" fox:alt-text="Image Front"/>
																					</xsl:if>
																				</xsl:otherwise>
																			</xsl:choose>
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
																			<fo:block-container display-align="center" height="90mm">
																				<fo:block font-size="28pt" role="H1" line-height="115%">
																					<xsl:copy-of select="$title-en"/>
																				</fo:block>
																			</fo:block-container>
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
															<fo:external-graphic src="{concat('data:image/png;base64,', normalize-space($Image-Logo-IHO))}" width="25.9mm" content-width="scale-to-fit" scaling="uniform" fox:alt-text="Image Logo IHO"/>
														</fo:block>
													</fo:table-cell>
													<fo:table-cell>
														<fo:block font-size="1">
															<fo:external-graphic src="{concat('data:image/png;base64,', normalize-space($Image-Text-IHO))}" width="25.8mm" content-width="scale-to-fit" scaling="uniform" fox:alt-text="Image Text IHO"/>
														</fo:block>
													</fo:table-cell>
													<fo:table-cell>
														<fo:block-container width="79mm" height="72mm" margin-left="56.8mm" background-color="rgb(0, 172, 158)" text-align="right" display-align="after">
															<fo:block-container margin-left="0mm">
																<fo:block font-size="8pt" color="white" margin-right="5mm" margin-bottom="5mm" line-height-shift-adjustment="disregard-shifts">
																	<xsl:apply-templates select="/iho:metanorma/iho:boilerplate/iho:feedback-statement"/>
																</fo:block>
															</fo:block-container>
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
			
				<xsl:choose>
					<xsl:when test="/iho:metanorma/iho:boilerplate/*[local-name() != 'feedback-statement']">
						<fo:page-sequence master-reference="preface" format="i" force-page-count="no-force">
							<xsl:call-template name="insertHeaderFooter">
								<xsl:with-param name="font-weight">normal</xsl:with-param>
							</xsl:call-template>
							<fo:flow flow-name="xsl-region-body">
								<fo:block-container margin-left="-1.5mm" margin-right="-1mm">
									<fo:block-container margin-left="0mm" margin-right="0mm" border="0.5pt solid black" >
										<fo:block-container margin-top="6.5mm" margin-left="7.5mm" margin-right="8.5mm" margin-bottom="7.5mm">
											<fo:block-container margin="0">
												<fo:block text-align="justify">
													<xsl:apply-templates select="/iho:metanorma/iho:boilerplate/*[local-name() != 'feedback-statement']"/>
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
							<xsl:call-template name="insertHeaderFooterBlank"/>
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
					
					<xsl:for-each select=".//*[local-name() = 'page_sequence'][parent::*[local-name() = 'preface']][normalize-space() != '' or .//*[local-name() = 'image'] or .//*[local-name() = 'svg']]">
		
						<!-- Preface Pages -->
						<fo:page-sequence master-reference="preface" format="i" force-page-count="end-on-even">
							
							<xsl:attribute name="master-reference">
								<xsl:text>preface</xsl:text>
								<xsl:call-template name="getPageSequenceOrientation"/>
							</xsl:attribute>
						
							<xsl:call-template name="insertFootnoteSeparatorCommon"/>
							<xsl:call-template name="insertHeaderFooter">
								<xsl:with-param name="font-weight">normal</xsl:with-param>
							</xsl:call-template>
							<fo:flow flow-name="xsl-region-body">
								
								
								<!-- <xsl:if test="position() = 1">
									<fo:block-container margin-left="-1.5mm" margin-right="-1mm">
										<fo:block-container margin-left="0mm" margin-right="0mm" border="0.5pt solid black" >
											<fo:block-container margin-top="6.5mm" margin-left="7.5mm" margin-right="8.5mm" margin-bottom="7.5mm">
												<fo:block-container margin="0">
													<fo:block text-align="justify">
														<xsl:apply-templates select="/iho:metanorma/iho:boilerplate/*[local-name() != 'feedback-statement']"/>
													</fo:block>
												</fo:block-container>
											</fo:block-container>
										</fo:block-container>
									</fo:block-container>
									<fo:block break-after="page"/>
								</xsl:if> -->
								
								<!-- Contents, Document History, ... except Foreword and Introduction -->
								<!-- <xsl:call-template name="processPrefaceSectionsDefault"/> -->
								<xsl:apply-templates select="*[not(local-name() = 'foreword') and not(local-name() = 'introduction')]"/>
								
							</fo:flow>
						</fo:page-sequence>
						<!-- End Preface Pages -->
						<!-- =========================== -->
						<!-- =========================== -->
					</xsl:for-each>
					
					
					<xsl:for-each select=".//*[local-name() = 'page_sequence'][*[local-name() = 'foreword'] or *[local-name() = 'introduction']][parent::*[local-name() = 'preface']][normalize-space() != '' or .//*[local-name() = 'image'] or .//*[local-name() = 'svg']]">
		
						<!-- Preface Pages -->
						<fo:page-sequence master-reference="preface" format="i" force-page-count="end-on-even">
							
							<xsl:attribute name="master-reference">
								<xsl:text>preface</xsl:text>
								<xsl:call-template name="getPageSequenceOrientation"/>
							</xsl:attribute>
						
							<xsl:call-template name="insertFootnoteSeparatorCommon"/>
							<xsl:call-template name="insertHeaderFooter">
								<xsl:with-param name="font-weight">normal</xsl:with-param>
							</xsl:call-template>
							<fo:flow flow-name="xsl-region-body">
								
								<!-- Foreword, Introduction -->
								<xsl:apply-templates select="*[local-name() = 'foreword' or local-name() = 'introduction']"/>
								
							</fo:flow>
						</fo:page-sequence>
						<!-- End Preface Pages -->
						<!-- =========================== -->
						<!-- =========================== -->
					</xsl:for-each>
					
				
				
					<xsl:for-each select=".//*[local-name() = 'page_sequence'][not(parent::*[local-name() = 'preface'])][normalize-space() != '' or .//*[local-name() = 'image'] or .//*[local-name() = 'svg']]">
				
						<fo:page-sequence master-reference="document" format="1" force-page-count="end-on-even">
						
							<xsl:attribute name="master-reference">
								<xsl:text>document</xsl:text>
								<xsl:call-template name="getPageSequenceOrientation"/>
							</xsl:attribute>
							
							<xsl:if test="position() = 1">
								<xsl:attribute name="initial-page-number">1</xsl:attribute>
							</xsl:if>
							
							<xsl:call-template name="insertFootnoteSeparatorCommon"/>
							<xsl:call-template name="insertHeaderFooter"/>
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
									
									<xsl:apply-templates />
									
									<xsl:if test="$table_if = 'true'"><fo:block/></xsl:if>
								</fo:block-container>
							</fo:flow>
						</fo:page-sequence>
				<!-- </xsl:if> -->
					</xsl:for-each>
				</xsl:for-each>
					
					<!-- <xsl:if test="/iho:metanorma/iho:annex">
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
	
	<xsl:template name="insertListOf_Title">
		<xsl:param name="title"/>
		<fo:block role="TOCI" font-weight="bold" margin-top="6pt" keep-with-next="always">
			<xsl:value-of select="$title"/>
		</fo:block>
	</xsl:template>
	
	<xsl:template name="insertListOf_Item">
		<fo:block role="TOCI" text-align-last="justify" margin-left="12mm" text-indent="-12mm">
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
	
	<xsl:template match="iho:preface//iho:clause[@type = 'toc']" priority="4">
		<!-- Table of Contents -->
		<fo:block>
			
			<xsl:apply-templates />
			
			<xsl:if test="$debug = 'true'">
				<redirect:write file="contents_.xml"> <!-- {java:getTime(java:java.util.Date.new())} -->
					<xsl:copy-of select="$contents"/>
				</redirect:write>
			</xsl:if>
			
			<xsl:if test="count(*) = 1 and *[local-name() = 'title']"> <!-- if there isn't user ToC -->
			
				<fo:block line-height="115%" role="TOC">
				
					<xsl:for-each select="$contents//item[@display = 'true']"><!-- [not(@level = 2 and starts-with(@section, '0'))] skip clause from preface -->							
						<fo:block role="TOCI">
							<fo:list-block>
								<xsl:attribute name="provisional-distance-between-starts">
									<xsl:choose>
										<xsl:when test="@level &gt;= 1 and @root = 'preface'">0mm</xsl:when>
										<xsl:when test="@level &gt;= 1 and @root = 'annex' and not(@type = 'annex')">13mm</xsl:when>
										<xsl:when test="@level &gt;= 1 and not(@type = 'annex')">
											<xsl:choose>
												<xsl:when test="$toc_level = 3">12.9mm</xsl:when>
												<xsl:when test="$toc_level &gt; 3">15mm</xsl:when>
												<xsl:otherwise>10mm</xsl:otherwise>
											</xsl:choose>
										</xsl:when>
										<xsl:otherwise>0mm</xsl:otherwise>
									</xsl:choose>											
								</xsl:attribute>
								<fo:list-item>
									<fo:list-item-label end-indent="label-end()">
										<fo:block id="__internal_layout__toc_sectionnum_{generate-id()}">
											<xsl:if test="@section != '' and not(@type = 'annex')"> <!-- output below   -->
												<xsl:value-of select="@section"/>
											</xsl:if>
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
			</xsl:if>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="iho:preface//iho:clause[@type = 'toc']/iho:title" priority="3">
		<fo:block font-weight="bold" margin-bottom="7.5pt" font-size="12pt" margin-top="4pt" role="SKIP">
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
	<xsl:template match="*[iho:title or iho:fmt-title]" mode="contents">
		<xsl:variable name="level">
			<xsl:call-template name="getLevel">
				<xsl:with-param name="depth" select="iho:fmt-title/@depth | iho:title/@depth"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="display">
			<xsl:choose>
				<xsl:when test="@id = '_document_history' or iho:title = 'Document History'">false</xsl:when>
				<xsl:when test="$level &lt;= $toc_level">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="skip">
			<xsl:choose>
				<xsl:when test="@type = 'toc'">true</xsl:when>
				<xsl:when test="ancestor-or-self::iho:bibitem">true</xsl:when>
				<xsl:when test="ancestor-or-self::iho:term">true</xsl:when>				
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
				<xsl:if test="ancestor-or-self::iho:preface">preface</xsl:if>
				<xsl:if test="ancestor-or-self::iho:annex">annex</xsl:if>
			</xsl:variable>
			
			<item id="{@id}" level="{$level}" section="{$section}" type="{$type}" root="{$root}" display="{$display}">
				<title>
					<xsl:apply-templates select="xalan:nodeset($title)" mode="contents_item"/>
				</title>
				<xsl:apply-templates  mode="contents" />
			</item>
			
		</xsl:if>	
		
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'strong']" mode="contents_item" priority="2">
		<xsl:apply-templates mode="contents_item"/>
	</xsl:template>
	
	<!-- ============================= -->
	<!-- END CONTENTS                                 -->
	<!-- ============================= -->
	<!-- ============================= -->
	
	<xsl:template match="*[local-name() = 'requirement'] | *[local-name() = 'recommendation'] | *[local-name() = 'permission']" priority="2" mode="update_xml_step1">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'requirement'] | *[local-name() = 'recommendation'] | *[local-name() = 'permission']" priority="2">
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
	
	<xsl:template match="*[local-name() = 'fmt-provision']" priority="2" mode="update_xml_step1">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'fmt-provision']/*[local-name() = 'div']" priority="2">
		<fo:inline><xsl:copy-of select="@id"/><xsl:apply-templates /></fo:inline>
	</xsl:template>
	
	<xsl:template match="/iho:metanorma/iho:bibdata/iho:edition">
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
	
	<xsl:template match="/iho:metanorma/iho:bibdata/iho:date[@type = 'published']">
		<xsl:call-template name="convertDate">
			<xsl:with-param name="date" select="."/>
			<xsl:with-param name="format" select="'short'"/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="iho:feedback-statement//iho:br" priority="2">
		<fo:block/>
	</xsl:template>
	
	<xsl:template match="iho:feedback-statement//iho:sup" priority="2">
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
	
	<xsl:template match="iho:annex/iho:title">
		<fo:block font-size="12pt" font-weight="bold" text-align="center" margin-bottom="12pt" keep-with-next="always" role="H1">			
			<xsl:apply-templates />
			<xsl:apply-templates select="following-sibling::*[1][local-name() = 'variant-title'][@type = 'sub']" mode="subtitle"/>
		</fo:block>
	</xsl:template>
		
	<xsl:template match="iho:bibliography/iho:references[not(@normative='true')]/iho:title">
		<fo:block font-size="16pt" font-weight="bold" text-align="center" margin-top="6pt" margin-bottom="36pt" keep-with-next="always" role="H1">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'clause']" priority="3">
		<xsl:if test="parent::iho:preface or (parent::*[local-name() = 'page_sequence'] and local-name(../..) = 'preface')">
			<fo:block break-after="page"/>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="iho:title">
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
	
	<xsl:template match="iho:title" name="title">
		
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
			<xsl:for-each select="parent::*[local-name() = 'clause']">
				<xsl:call-template name="setId"/>
			</xsl:for-each>
			<xsl:attribute name="font-size"><xsl:value-of select="$font-size"/></xsl:attribute>			
			<xsl:attribute name="font-weight">bold</xsl:attribute>			
			<xsl:attribute name="space-before">
				<xsl:choose>
					<xsl:when test="$level = 1">24pt</xsl:when>
					<xsl:when test="$level = 2 and ../preceding-sibling::*[1][self::iho:title]">10pt</xsl:when>
					<xsl:when test="$level = 2">24pt</xsl:when>
					<xsl:when test="$level &gt;= 3">6pt</xsl:when>
					<xsl:when test="ancestor::iho:preface">8pt</xsl:when>
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
			<xsl:apply-templates select="following-sibling::*[1][local-name() = 'variant-title'][@type = 'sub']" mode="subtitle"/>
		</xsl:element>
		
		<xsl:if test="$element-name = 'fo:inline' and not(following-sibling::iho:p)">
			<fo:block > <!-- margin-bottom="12pt" -->
				<xsl:value-of select="$linebreak"/>
			</fo:block>
		</xsl:if>
		
	</xsl:template>
	<!-- ====== -->
	<!-- ====== -->
	
	
	<xsl:template match="iho:p" name="paragraph">
		<xsl:param name="inline" select="'false'"/>
		<xsl:param name="split_keep-within-line"/>
		<xsl:variable name="previous-element" select="local-name(preceding-sibling::*[1])"/>
		<xsl:variable name="element-name">
			<xsl:choose>
				<xsl:when test="$inline = 'true'">fo:inline</xsl:when>
				<xsl:when test="../@inline-header = 'true' and $previous-element = 'title'">fo:inline</xsl:when> <!-- first paragraph after inline title -->
				<xsl:when test="local-name(..) = 'admonition'">fo:inline</xsl:when>
				<xsl:when test="ancestor::*[local-name() = 'recommendation' or local-name() = 'requirement' or local-name() = 'permission'] and not(preceding-sibling::*[local-name() = 'p'])">fo:inline</xsl:when>
				<xsl:otherwise>fo:block</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:element name="{$element-name}">
			<xsl:attribute name="text-align">
				<xsl:choose>
					<xsl:when test="ancestor::iho:quote">justify</xsl:when>
					<xsl:when test="ancestor::iho:feedback-statement">right</xsl:when>
					<xsl:when test="ancestor::iho:boilerplate and not(@align)">justify</xsl:when>
					<xsl:when test="@align = 'justified'">justify</xsl:when>
					<xsl:when test="@align"><xsl:value-of select="@align"/></xsl:when>
					<xsl:when test="ancestor::iho:td/@align"><xsl:value-of select="ancestor::iho:td/@align"/></xsl:when>
					<xsl:when test="ancestor::iho:th/@align"><xsl:value-of select="ancestor::iho:th/@align"/></xsl:when>
					<xsl:otherwise>justify</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:call-template name="setKeepAttributes"/>
			<xsl:attribute name="space-after">6pt</xsl:attribute>
			<xsl:if test="parent::iho:dd">
				<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="ancestor::*[2][local-name() = 'license-statement'] and not(following-sibling::iho:p)">
				<xsl:attribute name="space-after">0pt</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="line-height">115%</xsl:attribute>
			<!-- <xsl:attribute name="border">1pt solid red</xsl:attribute> -->
			<xsl:if test="ancestor::iho:boilerplate and not(ancestor::iho:feedback-statement)">
				<xsl:attribute name="line-height">125%</xsl:attribute>
				<xsl:attribute name="space-after">14pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="following-sibling::*[1][self::iho:ol or self::iho:ul or self::iho:note or self::iho:termnote or self::iho:example or self::iho:dl]">
				<xsl:attribute name="space-after">3pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="following-sibling::*[1][self::iho:dl]">
				<xsl:attribute name="space-after">6pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="ancestor::iho:quote">
				<xsl:attribute name="line-height">130%</xsl:attribute>
				<!-- <xsl:attribute name="margin-bottom">12pt</xsl:attribute> -->
			</xsl:if>
			
			<xsl:if test="ancestor::*[local-name() = 'recommendation' or local-name() = 'requirement' or local-name() = 'permission'] and
			not(following-sibling::*)">
				<xsl:attribute name="space-after">0pt</xsl:attribute>
			</xsl:if>
			
			<xsl:if test=".//iho:fn">
				<xsl:attribute name="line-height-shift-adjustment">disregard-shifts</xsl:attribute>
			</xsl:if>
			
			<xsl:apply-templates>
				<xsl:with-param name="split_keep-within-line" select="$split_keep-within-line"/>
			</xsl:apply-templates>
		</xsl:element>
		<xsl:if test="$element-name = 'fo:inline' and not($inline = 'true') and not(local-name(..) = 'admonition') and
		not(ancestor::*[local-name() = 'recommendation' or local-name() = 'requirement' or local-name() = 'permission'])">
			<fo:block margin-bottom="12pt">
				<!--  <xsl:if test="ancestor::iho:annex">
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
	<!-- <xsl:template match="iho:ul//iho:note  | iho:ol//iho:note" priority="2">
		<fo:block id="{@id}">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template> -->
	

	<xsl:template match="iho:li//iho:p//text()">
		<xsl:choose>
			<xsl:when test="contains(., '&#x9;')">
				<fo:inline white-space="pre"><xsl:value-of select="."/></fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="."/>
			</xsl:otherwise>
		</xsl:choose>		
	</xsl:template>
	

	
	<!-- <xsl:template match="iho:example/iho:p" priority="2">
			<fo:block-container xsl:use-attribute-sets="example-p-style">
				<fo:block-container margin-left="0mm">
					<fo:block>
						<xsl:apply-templates />
					</fo:block>
				</fo:block-container>
			</fo:block-container>
	</xsl:template> -->


	
	<xsl:template match="iho:pagebreak" priority="2">
		<xsl:copy-of select="."/>
	</xsl:template>
	
	<!-- https://github.com/metanorma/mn-native-pdf/issues/214 -->
	<xsl:template match="iho:index"/>
	


	<xsl:template name="insertHeaderFooter">
		<xsl:param name="font-weight" select="'bold'"/>
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
								<fo:table-cell text-align="center"><fo:block><xsl:copy-of select="$title-en"/></fo:block></fo:table-cell>
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
								<fo:table-cell text-align="center"><fo:block><xsl:copy-of select="$title-en"/></fo:block></fo:table-cell>
								<fo:table-cell><fo:block>&#xa0;</fo:block></fo:table-cell>
							</fo:table-row>
						</fo:table-body>
					</fo:table>
				</fo:block>
			</fo:block-container>
		</fo:static-content>
		<xsl:call-template name="insertHeaderBlank"/>
		<xsl:call-template name="insertFooter"/>
	</xsl:template>
	<xsl:template name="insertHeaderBlank">
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
								<fo:table-cell text-align="center"><fo:block><xsl:copy-of select="$title-en"/></fo:block></fo:table-cell>
								<fo:table-cell><fo:block>&#xa0;</fo:block></fo:table-cell>
							</fo:table-row>
						</fo:table-body>
					</fo:table>
				</fo:block>
			</fo:block-container>
			<fo:block-container position="absolute" left="40.5mm" top="130mm" height="4mm" width="79mm" border="0.75pt solid black" text-align="center" display-align="center" line-height="100%">
				<fo:block>Page intentionally left blank</fo:block>
			</fo:block-container>
		</fo:static-content>
	</xsl:template>
	<xsl:template name="insertFooter">
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
		<xsl:call-template name="insertHeaderBlank"/>
		<xsl:call-template name="insertFooter"/>
	</xsl:template>
	
	
	<xsl:variable name="Image-IHO">
		<xsl:text>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</xsl:text>
	</xsl:variable>
	
	<xsl:variable name="Image-Logo-IHO">
		<xsl:text>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</xsl:text>
	</xsl:variable>
	
	<xsl:variable name="Image-Text-IHO">
		<xsl:text>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</xsl:text>
	</xsl:variable>
	
</xsl:stylesheet>