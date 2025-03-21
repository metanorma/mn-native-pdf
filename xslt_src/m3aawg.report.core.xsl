<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
											xmlns:fo="http://www.w3.org/1999/XSL/Format" 
											xmlns:m3d="https://www.metanorma.org/ns/m3d" 
											xmlns:mathml="http://www.w3.org/1998/Math/MathML" 
											xmlns:xalan="http://xml.apache.org/xalan" 
											xmlns:fox="http://xmlgraphics.apache.org/fop/extensions" 
											xmlns:redirect="http://xml.apache.org/xalan/redirect"
											xmlns:java="http://xml.apache.org/xalan/java" 
											exclude-result-prefixes="java redirect"
											extension-element-prefixes="redirect"
											version="1.0">

	<xsl:output method="xml" encoding="UTF-8" indent="no"/>
		
	<xsl:include href="./common.xsl"/>

	<xsl:key name="kfn" match="*[local-name() = 'fn'][not(ancestor::*[(local-name() = 'table' or local-name() = 'figure' or local-name() = 'localized-strings')] and not(ancestor::*[local-name() = 'name']))]" use="@reference"/>
	
	<xsl:variable name="namespace">m3d</xsl:variable>
	
	<xsl:variable name="debug">false</xsl:variable>

	<xsl:variable name="title-en" select="/m3d:m3d-standard/m3d:bibdata/m3d:title[@language = 'en']"/>
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
		<xsl:call-template name="namespaceCheck"/>
		<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format" xml:lang="{$lang}">
			<xsl:variable name="root-style">
				<root-style xsl:use-attribute-sets="root-style"/>
			</xsl:variable>
			<xsl:call-template name="insertRootStyle">
				<xsl:with-param name="root-style" select="$root-style"/>
			</xsl:call-template>
			<fo:layout-master-set>
				
				<!-- cover page -->
				<fo:simple-page-master master-name="coverpage" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
					<fo:region-body margin-top="31mm" margin-bottom="32mm" margin-left="17.3mm" margin-right="22mm"/>
					<fo:region-before region-name="cover-header" extent="31mm" />
					<fo:region-after region-name="cover-footer" extent="32mm" />
					<fo:region-start region-name="cover-left-region" extent="17.3mm"/>
					<fo:region-end region-name="cover-right-region" extent="22mm"/>
				</fo:simple-page-master>
				
				<!-- contents pages -->				
				<fo:simple-page-master master-name="page" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
					<fo:region-body margin-top="20mm" margin-bottom="23mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
					<fo:region-before region-name="header" extent="{$marginTop}mm"/>
					<fo:region-after region-name="footer" extent="{$marginBottom}mm"/>
					<fo:region-start region-name="left-region" extent="{$marginLeftRight1}mm"/>
					<fo:region-end region-name="right-region" extent="{$marginLeftRight2}mm"/>
				</fo:simple-page-master>
				<fo:simple-page-master master-name="page-landscape" page-width="{$pageHeight}mm" page-height="{$pageWidth}mm">
					<fo:region-body margin-top="20mm" margin-bottom="23mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
					<fo:region-before region-name="header" extent="{$marginTop}mm"/>
					<fo:region-after region-name="footer" extent="{$marginBottom}mm"/>
					<fo:region-start region-name="left-region" extent="{$marginLeftRight1}mm"/>
					<fo:region-end region-name="right-region" extent="{$marginLeftRight2}mm"/>
				</fo:simple-page-master>
				
				<fo:simple-page-master master-name="last" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
					<fo:region-body margin-top="20mm" margin-bottom="54mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
					<fo:region-before region-name="header" extent="{$marginTop}mm"/>
					<fo:region-after region-name="footer-last" extent="53.2mm"/>
					<fo:region-start region-name="left-region" extent="17.3mm"/>
					<fo:region-end region-name="right-region" extent="17.3mm"/>
				</fo:simple-page-master>
				
				<fo:page-sequence-master master-name="cover">
					<fo:repeatable-page-master-alternatives>
						<fo:conditional-page-master-reference page-position="first" master-reference="coverpage"/>
						<fo:conditional-page-master-reference page-position="any" master-reference="page"/>
					</fo:repeatable-page-master-alternatives>
				</fo:page-sequence-master>
				
				<fo:page-sequence-master master-name="document">
					<fo:repeatable-page-master-alternatives>
						<fo:conditional-page-master-reference page-position="any" master-reference="page"/>
					</fo:repeatable-page-master-alternatives>
				</fo:page-sequence-master>
				<fo:page-sequence-master master-name="document-last">
					<fo:repeatable-page-master-alternatives>
						<fo:conditional-page-master-reference page-position="last" master-reference="last"/>
						<fo:conditional-page-master-reference page-position="any" master-reference="page"/>
					</fo:repeatable-page-master-alternatives>
				</fo:page-sequence-master>
				
				<fo:page-sequence-master master-name="document-landscape">
					<fo:repeatable-page-master-alternatives>
						<fo:conditional-page-master-reference page-position="any" master-reference="page-landscape"/>
					</fo:repeatable-page-master-alternatives>
				</fo:page-sequence-master>
				<fo:page-sequence-master master-name="document-landscape-last">
					<fo:repeatable-page-master-alternatives>
						<fo:conditional-page-master-reference page-position="last" master-reference="last"/>
						<fo:conditional-page-master-reference page-position="any" master-reference="page-landscape"/>
					</fo:repeatable-page-master-alternatives>
				</fo:page-sequence-master>
				
			</fo:layout-master-set>

			<fo:declarations>
				<xsl:call-template name="addPDFUAmeta"/>
			</fo:declarations>
			
			<xsl:call-template name="addBookmarks">
				<xsl:with-param name="contents" select="$contents"/>
			</xsl:call-template>
			
			<fo:page-sequence master-reference="cover" force-page-count="no-force">
				<fo:static-content flow-name="cover-header">
					<fo:block-container height="18mm" border-bottom="0.5pt solid red">
						<fo:block-container height="100%" display-align="after">
							<fo:block margin-bottom="-1mm">
								<fo:external-graphic src="{concat('data:image/png;base64,', normalize-space($Image-M3AAWG-Logo))}" width="85.4mm" content-height="11mm" content-width="scale-to-fit" scaling="uniform" fox:alt-text="Image M3AAWG Logo"/>
							</fo:block>
						</fo:block-container>
					</fo:block-container>
				</fo:static-content>
				<fo:static-content flow-name="cover-footer">
					<fo:block-container height="31mm" border-top="0.5pt solid red" font-family="Arial" text-align="center">
							<fo:block font-size="12pt" font-weight="bold" color="rgb(51, 169, 207)" margin-top="2mm">
								<fo:inline>M<fo:inline font-size="8pt" vertical-align="super">3</fo:inline>AAWG</fo:inline>
							</fo:block>
							<fo:block font-size="9pt">
								<xsl:value-of select="/m3d:m3d-standard/m3d:bibdata/m3d:contributor[m3d:role/@type='author']/m3d:organization/m3d:name"/>
								<xsl:value-of select="$linebreak"/>
								<fo:inline>781 Beach Street, Suite 302</fo:inline>
								<fo:inline font-size="11pt" color="rgb(51, 169, 207)" baseline-shift="5%" padding-left="1mm" padding-right="1mm">&#x25A0;</fo:inline>
								<fo:inline>San Francisco, California 94109 U.S.A.</fo:inline>
								<fo:inline font-size="11pt" color="rgb(51, 169, 207)" baseline-shift="5%" padding-left="1mm" padding-right="1mm">&#x25A0;</fo:inline>
								<fo:inline color="blue" text-decoration="underline">www.m3aawg.org</fo:inline>
							</fo:block>
					</fo:block-container>
				</fo:static-content>
				<xsl:call-template name="insertFooter"/>
				
				<fo:flow flow-name="xsl-region-body">
					<fo:block-container font-weight="bold" text-align="center">
						<!-- Messaging, Malware and Mobile Anti-Abuse Working Group -->
						<fo:block font-size="16pt">
							<xsl:apply-templates select="/m3d:m3d-standard/m3d:boilerplate/m3d:feedback-statement/m3d:p[@id = 'boilerplate-name']/node()"/>
						</fo:block>
						<!-- M 3 AAWG Companion Document:  
							Recipes for Encrypting  
							DNS Stub Resolver-to-Recursive Resolver Traffic  -->						
						<fo:block font-size="22pt" margin-top="16pt" >
							<fo:inline border-bottom="1pt solid black">
									<fo:inline>M</fo:inline><fo:inline font-size="13pt" baseline-shift="35%">3</fo:inline><fo:inline>AAWG Companion Document: </fo:inline>
							</fo:inline>
						</fo:block>
						
						<fo:block font-size="22pt" margin-bottom="12pt" role="H1">
							<xsl:value-of select="$title-en"/>
						</fo:block>
						<!-- Version 1.0  -->
						<fo:block font-size="12pt" margin-bottom="6pt">
							<xsl:variable name="edition" select="normalize-space(/m3d:m3d-standard/m3d:bibdata/m3d:edition[normalize-space(@language) = ''])"/>
							<xsl:if test="$edition != ''">
								<xsl:call-template name="capitalize">
									<xsl:with-param name="str">
										<xsl:call-template name="getLocalizedString">
											<xsl:with-param name="key">version</xsl:with-param>
										</xsl:call-template>
									</xsl:with-param>
								</xsl:call-template>
								<xsl:text>: </xsl:text>
								<xsl:value-of select="$edition"/><xsl:if test="not(contains($edition, '.'))"><xsl:text>.0</xsl:text></xsl:if>
							</xsl:if>
						</fo:block>
						<fo:block font-size="12pt" margin-bottom="12pt">
							<xsl:call-template name="convertDate">
								<xsl:with-param name="date" select="/m3d:m3d-standard/m3d:bibdata/m3d:version/m3d:revision-date"/>
							</xsl:call-template>
						</fo:block>
					</fo:block-container>
					
					<fo:block-container font-size="12pt">
						<fo:block text-align="center" font-weight="normal" margin-bottom="10pt">
							<xsl:text>The direct URL to this paper is:  </xsl:text><fo:inline color="blue" text-decoration="underline">www.m3aawg.org/dns-crypto-recipes</fo:inline>
						</fo:block>
						<fo:block margin-bottom="10pt">This document is intended to accompany and complement the companion document, “M<fo:inline font-size="7pt" baseline-shift="35%">3</fo:inline> AAWG Tutorial  on Third Party Recursive Resolvers and Encrypting DNS Stub Resolver-to-Recursive Resolver Traffic” 
								(<fo:inline color="blue" text-decoration="underline">www.m3aawg.org/dns-crypto-tutorial</fo:inline>). 
						</fo:block>
						<fo:block margin-bottom="12pt">This document was produced by the M<fo:inline font-size="7pt" baseline-shift="35%">3</fo:inline> AAWG Data and Identity Protection Committee. </fo:block>
					</fo:block-container>
					
					<!-- <xsl:if test="$debug = 'true'">
						<redirect:write file="contents_{java:getTime(java:java.util.Date.new())}.xml">
							<xsl:copy-of select="$contents"/>
						</redirect:write>
					</xsl:if> -->
					
					<!-- Table of contents -->
					<xsl:apply-templates select="/*/m3d:preface/m3d:clause[@type = 'toc']">
						<xsl:with-param name="process">true</xsl:with-param>
					</xsl:apply-templates>
					
					<fo:block>
						<xsl:apply-templates select="/m3d:m3d-standard/m3d:boilerplate"/>
					</fo:block>
				</fo:flow>
			</fo:page-sequence> <!-- END: cover -->
			
			
			<xsl:variable name="updated_xml">
				<xsl:call-template name="updateXML"/>
				<!-- <xsl:copy-of select="."/> -->
			</xsl:variable>
			
			<xsl:for-each select="xalan:nodeset($updated_xml)/*">
			
				<xsl:variable name="updated_xml_with_pages">
					<xsl:call-template name="processPrefaceAndMainSectionsDefault_items"/>
				</xsl:variable>
			
				<xsl:for-each select="xalan:nodeset($updated_xml_with_pages)"> <!-- set context to preface -->
				
					<xsl:for-each select=".//*[local-name() = 'page_sequence'][normalize-space() != '' or .//image or .//svg]">
			
						<fo:page-sequence master-reference="document" force-page-count="no-force">
						
							<xsl:attribute name="master-reference">
								<xsl:text>document</xsl:text>
								<xsl:call-template name="getPageSequenceOrientation"/>
								<xsl:if test="position() = last()">-last</xsl:if>
							</xsl:attribute>
						
							<xsl:call-template name="insertFooter"/>
							
							<fo:static-content flow-name="footer-last">
								<fo:block-container height="53mm" border-top="0.5pt solid rgb(103, 141, 207)" display-align="after">
									<fo:block-container padding-bottom="16mm">
										<fo:block text-align="justify">
											<fo:inline>As with all M3AAWG documents that we publish, please check the M3AAWG website (<fo:inline color="blue" text-decoration="underline">www.m3aawg.org</fo:inline>) for updates to this paper.</fo:inline>
										</fo:block>
										<fo:block>&#xA0;</fo:block>
										<fo:block>&#xA0;</fo:block>						
										<fo:block>
											<xsl:text>© </xsl:text>
											<xsl:value-of select="/m3d:m3d-standard/m3d:bibdata/m3d:copyright/m3d:from"/>
											<xsl:text> copyright by the </xsl:text>
											<xsl:value-of select="/m3d:m3d-standard/m3d:bibdata/m3d:copyright/m3d:owner/m3d:organization/m3d:name"/>
											<xsl:text> (</xsl:text>
											<xsl:value-of select="/m3d:m3d-standard/m3d:bibdata/m3d:copyright/m3d:owner/m3d:organization/m3d:abbreviation"/>
											<xsl:text>)</xsl:text>							
										</fo:block>
										<fo:block font-size="10pt">
											<fo:block text-align-last="justify" margin-top="2mm">
												<fo:inline font-weight="bold">
													<fo:inline>M<fo:inline font-size="6.5pt" baseline-shift="35%">3</fo:inline>AAWG </fo:inline>
													<xsl:value-of select="$title-en"/>								
												</fo:inline>
												<fo:leader font-weight="normal" leader-pattern="space"/>
												<fo:inline font-size="9pt"><fo:page-number /></fo:inline>
											</fo:block>
										</fo:block>
									</fo:block-container>
								</fo:block-container>
							</fo:static-content>
							
							<fo:flow flow-name="xsl-region-body">
								
								<!-- Foreword, Introduction -->
								<!-- <fo:block>						
									<xsl:call-template name="processPrefaceSectionsDefault"/>
								</fo:block>
								
								<fo:block break-after="page"/>
								
								<xsl:call-template name="processMainSectionsDefault"/> -->
								
								<xsl:apply-templates />
								<fo:block/> <!-- for prevent empty preface -->
								
							</fo:flow>
						</fo:page-sequence>
					</xsl:for-each>
				</xsl:for-each>
			</xsl:for-each>
		</fo:root>
	</xsl:template> 

	<xsl:template name="insertFooter">
		<fo:static-content flow-name="footer" role="artifact">
			<fo:block-container font-size="10pt">
				<fo:block text-align-last="justify" margin-top="2mm">
					<fo:inline font-weight="bold">
						<fo:inline>M<fo:inline font-size="6.5pt" baseline-shift="35%">3</fo:inline>AAWG </fo:inline>
						<xsl:value-of select="$title-en"/>								
					</fo:inline>
					<fo:leader font-weight="normal" leader-pattern="space"/>
					<fo:inline font-size="9pt"><fo:page-number /></fo:inline>
				</fo:block>
			</fo:block-container>				
		</fo:static-content>
	</xsl:template>

	<xsl:template name="insertListOf_Title">
		<xsl:param name="title"/>
		<fo:table table-layout="fixed" width="100%">
			<fo:table-column column-width="180mm"/>
			<fo:table-body>
				<fo:table-row height="6mm">
					<fo:table-cell>
						<fo:block role="TOCI" font-weight="bold">
							<xsl:value-of select="$title"/>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
			</fo:table-body>
		</fo:table>
	</xsl:template>
	
	<xsl:template name="insertListOf_Item">
		<fo:table table-layout="fixed" width="100%">
			<fo:table-column column-width="5mm"/>
			<fo:table-column column-width="175mm"/>
			<fo:table-body>
				<fo:table-row height="6mm">
					<fo:table-cell>
						<fo:block>&#xa0;</fo:block>
					</fo:table-cell>
					<fo:table-cell>
						<fo:block text-align-last="justify" role="TOCI" font-weight="bold">
							<fo:basic-link internal-destination="{@id}" >
								<xsl:call-template name="setAltText">
									<xsl:with-param name="value" select="@alt-text"/>
								</xsl:call-template>
								<xsl:apply-templates select="." mode="contents"/><xsl:text>&#xa0;</xsl:text>
								<fo:inline keep-together.within-line="always">
									<fo:leader font-weight="normal" leader-pattern="dots"/>
									<fo:inline><fo:page-number-citation ref-id="{@id}"/></fo:inline>
								</fo:inline>
							</fo:basic-link>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
			</fo:table-body>
		</fo:table>
	</xsl:template>
	
	<xsl:template match="m3d:boilerplate//m3d:p" priority="2">
		<fo:block font-size="11pt" margin-bottom="12pt">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="m3d:preface//m3d:clause[@type = 'toc']" priority="3">
		<xsl:param name="process">false</xsl:param>
		<xsl:if test="$process = 'true'">
			
			<!-- Table of content -->
			<fo:block-container>
			
				<xsl:apply-templates />
				
				<xsl:if test="count(*) = 1 and *[local-name() = 'title']"> <!-- if there isn't user ToC -->
				
					<fo:block font-size="10pt" role="TOC">
						<xsl:for-each select="$contents//item[@display = 'true']"><!-- [not(@level = 2 and starts-with(@section, '0'))] skip clause from preface -->							
							<xsl:choose>
								<xsl:when test="@section = ''">
									<fo:table table-layout="fixed" width="100%" id="__internal_layout__price_toc_{generate-id()}">
										<fo:table-column column-width="180mm"/>
										<fo:table-body>
											<fo:table-row height="6mm">
												<fo:table-cell>
													<fo:block text-align-last="justify" role="TOCI">
														<xsl:if test="@level = 1">
															<xsl:attribute name="font-weight">bold</xsl:attribute>
														</xsl:if>
														<fo:basic-link internal-destination="{@id}" fox:alt-text="{title}">
															<fo:inline font-weight="bold">
																<xsl:apply-templates select="title"/><xsl:text>&#xa0;</xsl:text>
															</fo:inline>
															<fo:inline keep-together.within-line="always">
																<fo:leader font-weight="normal" leader-pattern="dots"/>
																<fo:inline><fo:page-number-citation ref-id="{@id}"/></fo:inline>
															</fo:inline>
														</fo:basic-link>
													</fo:block>
												</fo:table-cell>
											</fo:table-row>
										</fo:table-body>
									</fo:table>
								</xsl:when>
								<xsl:otherwise>
									<fo:table table-layout="fixed" width="100%" id="__internal_layout__price_toc_{generate-id()}">
										<fo:table-column column-width="5mm"/> <!-- 25mm -->
										<fo:table-column column-width="175mm"/> <!-- 155mm -->
										<fo:table-body>
											<fo:table-row height="6mm">
												<fo:table-cell>
													<fo:block font-weight="bold" role="TOCI">
														<fo:basic-link internal-destination="{@id}" fox:alt-text="{title}">
															<xsl:choose>
																<!-- <xsl:when test="@section = ''">
																	<xsl:apply-templates select="title"/>
																</xsl:when> -->
																<!-- <xsl:when test="@type = 'references' and @section = ''">
																	<xsl:apply-templates select="title"/>
																</xsl:when> -->
																<xsl:when test="@level = 1">
																	<xsl:value-of select="@section"/>
																</xsl:when>
																<xsl:otherwise></xsl:otherwise>
															</xsl:choose>
														</fo:basic-link>
													</fo:block>
												</fo:table-cell>
												<fo:table-cell>
													<fo:block text-align-last="justify" role="TOCI">
														<xsl:if test="@level = 1">
															<xsl:attribute name="font-weight">bold</xsl:attribute>
														</xsl:if>
														<fo:basic-link internal-destination="{@id}" fox:alt-text="{title}">
															<!-- <xsl:choose>
																<xsl:when test="@section = ''"></xsl:when>
																<xsl:otherwise>
																	<xsl:apply-templates select="title"/>
																</xsl:otherwise>
															</xsl:choose> -->
															<xsl:apply-templates select="title"/><xsl:text>&#xa0;</xsl:text>
															<fo:inline keep-together.within-line="always">
																<fo:leader font-weight="normal" leader-pattern="dots"/>
																<fo:inline><fo:page-number-citation ref-id="{@id}"/></fo:inline>
															</fo:inline>
														</fo:basic-link>
													</fo:block>
												</fo:table-cell>
											</fo:table-row>
										</fo:table-body>
									</fo:table>
								</xsl:otherwise>
								
							</xsl:choose>
							
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
				
				<fo:block/> <!-- prevent empty toc -->
			</fo:block-container>
			
			<fo:block break-after="page"/>
			
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="m3d:preface//m3d:clause[@type = 'toc']/m3d:title" priority="3">
		<!-- <xsl:variable name="title-toc">
			<xsl:call-template name="getTitle">
				<xsl:with-param name="name" select="'title-toc'"/>
			</xsl:call-template>
		</xsl:variable> -->
		<fo:block font-size="12pt" font-weight="bold" text-decoration="underline" margin-bottom="4pt" role="H1">
			<!-- <xsl:value-of select="$title-toc"/> -->
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="node()">		
		<xsl:apply-templates />			
	</xsl:template>
	
	<!-- ============================= -->
	<!-- CONTENTS                     -->
	<!-- ============================= -->
	
	<!-- element with title -->
	<xsl:template match="*[m3d:title]" mode="contents">
		<xsl:variable name="level">
			<xsl:call-template name="getLevel">
				<xsl:with-param name="depth" select="m3d:title/@depth"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="display">
			<xsl:choose>				
				<xsl:when test="ancestor-or-self::m3d:preface and $level &gt;= 2">false</xsl:when>
				<xsl:when test="ancestor::m3d:annex and $level &gt;= 3">false</xsl:when>
				<xsl:when test="$level &lt;= $toc_level">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="skip">
			<xsl:choose>
				<xsl:when test="@type = 'toc'">true</xsl:when>
				<xsl:when test="ancestor-or-self::m3d:bibitem">true</xsl:when>
				<xsl:when test="ancestor-or-self::m3d:term">true</xsl:when>				
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
			
			<item id="{@id}" level="{$level}" section="{$section}" type="{$type}" display="{$display}">
				<title>
					<xsl:apply-templates select="xalan:nodeset($title)" mode="contents_item"/>
				</title>
				<xsl:apply-templates  mode="contents" />
			</item>
		</xsl:if>	
	</xsl:template>
	<!-- ============================= -->
	<!-- ============================= -->
	

	
	<!-- ====== -->
	<!-- title      -->
	<!-- ====== -->	
	
	<xsl:template match="m3d:boilerplate//m3d:title" priority="2">
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		<fo:block font-size="14pt" font-weight="bold" text-align="center" margin-top="12pt" margin-bottom="15.5pt" keep-with-next="always" role="H{$level}">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>

	
	<xsl:template match="m3d:annex/m3d:title">
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		<xsl:variable name="font-size">
			<xsl:choose>				
				<xsl:when test="$level = 1">14pt</xsl:when>				
				<xsl:otherwise>12pt</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<fo:block font-size="{$font-size}" text-align="center" margin-bottom="24pt" keep-with-next="always" role="H1">
			<xsl:apply-templates />
			<xsl:apply-templates select="following-sibling::*[1][local-name() = 'variant-title'][@type = 'sub']" mode="subtitle"/>
		</fo:block>
	</xsl:template>
	
	
	<xsl:template match="m3d:title" name="title">
		
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
				
		<xsl:variable name="font-size">
			<xsl:choose>
				<xsl:when test="ancestor::m3d:preface">14pt</xsl:when>
				<xsl:when test="$level = 1">14pt</xsl:when>
				<!-- <xsl:when test="@level = 2">12pt</xsl:when> -->
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
			<xsl:attribute name="font-size"><xsl:value-of select="$font-size"/></xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="margin-top">
				<xsl:choose>
					<xsl:when test="ancestor::m3d:preface">8pt</xsl:when>
					<xsl:when test="$level = 2 and ancestor::m3d:annex">10pt</xsl:when>
					<xsl:when test="$level = 1">0pt</xsl:when>
					<xsl:when test="$level = ''">6pt</xsl:when>
					<xsl:otherwise>12pt</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="margin-bottom">
				<xsl:choose>
					<xsl:when test="ancestor::m3d:preface">6pt</xsl:when>
					<xsl:when test="$level = 1">12pt</xsl:when>
					<xsl:otherwise>8pt</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>		
			<xsl:attribute name="role">H<xsl:value-of select="$level"/></xsl:attribute>
			
			<xsl:apply-templates />
			<xsl:apply-templates select="following-sibling::*[1][local-name() = 'variant-title'][@type = 'sub']" mode="subtitle"/>
			
		</xsl:element>
		
		<xsl:if test="$element-name = 'fo:inline' and not(following-sibling::m3d:p)">
			<!-- <fo:block> -->
				<xsl:value-of select="$linebreak"/>
			<!-- </fo:block> -->
		</xsl:if>
			
	</xsl:template>
	<!-- ====== -->	
	<!-- ====== -->	

	
	<xsl:template match="m3d:p" name="paragraph">
		<xsl:param name="inline" select="'false'"/>
		<xsl:param name="split_keep-within-line"/>
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
			<xsl:attribute name="text-indent">0mm</xsl:attribute>
			
			<xsl:call-template name="setBlockAttributes">
				<xsl:with-param name="text_align_default">justify</xsl:with-param>
			</xsl:call-template>
			
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:apply-templates>
				<xsl:with-param name="split_keep-within-line" select="$split_keep-within-line"/>
			</xsl:apply-templates>
		</xsl:element>
		<xsl:if test="$element-name = 'fo:inline' and not($inline = 'true') and not(local-name(..) = 'admonition')">
			<xsl:choose>
				<xsl:when test="ancestor::m3d:annex">
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
	
	<xsl:template match="m3d:li//m3d:p//text()">
		<xsl:choose>
			<xsl:when test="contains(., '&#x9;')">
				<fo:inline white-space="pre"><xsl:value-of select="."/></fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
	<xsl:template match="m3d:p/m3d:fn/m3d:p">
		<xsl:apply-templates />
	</xsl:template>
	
	
	<xsl:template match="m3d:ul | m3d:ol" mode="list" priority="2">
		<fo:block-container margin-left="6mm">
			<fo:block-container margin-left="0mm">
				<xsl:call-template name="list" />
			</fo:block-container>
		</fo:block-container>
	</xsl:template>
	
	
	<xsl:template match="m3d:preferred" priority="2">

		<fo:inline>
			<xsl:call-template name="setStyle_preferred"/>
			<xsl:apply-templates />
		</fo:inline>
		
		<xsl:if test="not(following-sibling::*[1][local-name() = 'preferred'])">
			<xsl:value-of select="$linebreak"/>
		</xsl:if>

	</xsl:template>


	
	<xsl:template match="m3d:termnote" priority="2">
		<fo:block-container margin-left="0mm" margin-top="4pt" line-height="125%">
			<fo:block>
				<fo:inline padding-right="1mm">
					<xsl:apply-templates select="m3d:name" />
				</fo:inline>
				<xsl:apply-templates select="node()[not(local-name() = 'name')]" />
			</fo:block>
		</fo:block-container>
	</xsl:template>
	
	<xsl:template match="m3d:example/m3d:p" priority="2">
		<fo:inline xsl:use-attribute-sets="example-p-style">
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>

	<xsl:template match="*[local-name()='sup']" priority="2">
		<fo:inline font-size="80%" baseline-shift="30%">
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>


	<xsl:variable name="Image-M3AAWG-Logo">
		<xsl:text>iVBORw0KGgoAAAANSUhEUgAAAjUAAAA8CAYAAACehUt5AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA99pVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtbG5zOmRjPSJodHRwOi8vcHVybC5vcmcvZGMvZWxlbWVudHMvMS4xLyIgeG1wTU06T3JpZ2luYWxEb2N1bWVudElEPSJ1dWlkOmZhZjViZGQ1LWJhM2QtMTFkYS1hZDMxLWQzM2Q3NTE4MmYxYiIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDo1QjFGQUNFRDVCODYxMUU0OUZCN0FCODI3QzkxM0M3RiIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDo1QjFGQUNFQzVCODYxMUU0OUZCN0FCODI3QzkxM0M3RiIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M2IChXaW5kb3dzKSI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOkMwOEQ1MzE4OTE1NUU0MTE4ODdFRjlCOTFBMkJDOUNFIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjg1QjAy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</xsl:text>
	</xsl:variable>

</xsl:stylesheet>
