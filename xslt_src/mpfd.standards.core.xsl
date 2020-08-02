<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
											xmlns:fo="http://www.w3.org/1999/XSL/Format" 
											xmlns:mpfd="https://www.metanorma.org/ns/mpfd" 
											xmlns:mathml="http://www.w3.org/1998/Math/MathML" 
											xmlns:xalan="http://xml.apache.org/xalan" 
											xmlns:fox="http://xmlgraphics.apache.org/fop/extensions" 
											xmlns:java="http://xml.apache.org/xalan/java" 
											exclude-result-prefixes="java"
											version="1.0">

	<xsl:output method="xml" encoding="UTF-8" indent="no"/>
	
	<xsl:param name="svg_images"/>
	<xsl:variable name="images" select="document($svg_images)"/>
	
	<xsl:include href="./common.xsl"/>

	<xsl:key name="kfn" match="mpfd:p/mpfd:fn" use="@reference"/>
	
	<xsl:variable name="namespace">mpfd</xsl:variable>
	
	<xsl:variable name="debug">false</xsl:variable>
	<xsl:variable name="pageWidth" select="'210mm'"/>
	<xsl:variable name="pageHeight" select="'297mm'"/>
	
	<xsl:variable name="copyrightHolder">Ribose Group Inc.</xsl:variable>

	<xsl:variable name="copyright">
		<xsl:text>© </xsl:text>
		<xsl:value-of select="$copyrightHolder"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="/mpfd:mpfd-standard/mpfd:bibdata/mpfd:copyright/mpfd:from"/>
		<xsl:text> – All rights reserved</xsl:text>
	</xsl:variable>
	
	<xsl:variable name="copyrightShort">
		<xsl:value-of select="$copyrightHolder"/>
		<xsl:text> :</xsl:text>
		<xsl:value-of select="/mpfd:mpfd-standard/mpfd:bibdata/mpfd:copyright/mpfd:from"/>
	</xsl:variable>
	
	<xsl:variable name="title-en" select="/mpfd:mpfd-standard/mpfd:bibdata/mpfd:title[@language = 'en']"/>
	<!-- Example:
		<item level="1" id="Foreword" display="true">Foreword</item>
		<item id="term-script" display="false">3.2</item>
	-->
	<xsl:variable name="contents">
		<contents>
			<xsl:apply-templates select="/mpfd:mpfd-standard/mpfd:preface/node()" mode="contents"/>
				
			<xsl:apply-templates select="/mpfd:mpfd-standard/mpfd:sections/mpfd:clause[1]" mode="contents"> <!-- [@id = '_scope'] -->
				<xsl:with-param name="sectionNum" select="'1'"/>
			</xsl:apply-templates>
			<xsl:apply-templates select="/mpfd:mpfd-standard/mpfd:bibliography/mpfd:references[1]" mode="contents"> <!-- [@id = '_normative_references'] -->
				<xsl:with-param name="sectionNum" select="'2'"/>
			</xsl:apply-templates>
			<xsl:apply-templates select="/mpfd:mpfd-standard/mpfd:sections/*[position() &gt; 1]" mode="contents"> <!-- @id != '_scope' -->
				<xsl:with-param name="sectionNumSkew" select="'1'"/>
			</xsl:apply-templates>
			<xsl:apply-templates select="/mpfd:mpfd-standard/mpfd:annex" mode="contents"/>
			<xsl:apply-templates select="/mpfd:mpfd-standard/mpfd:bibliography/mpfd:references[position() &gt; 1]" mode="contents"/> <!-- @id = '_bibliography' -->
			
			<xsl:apply-templates select="//mpfd:figure" mode="contents"/>
			
			<xsl:apply-templates select="//mpfd:table" mode="contents"/>
		</contents>
	</xsl:variable>
	
	<xsl:variable name="lang">
		<xsl:call-template name="getLang"/>
	</xsl:variable>
	
	<xsl:template match="/">
		<xsl:call-template name="namespaceCheck"/>
		<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format" font-family="Arial" font-size="10.5pt" xml:lang="{$lang}">
			<fo:layout-master-set>
				
				<!-- cover page -->
				<fo:simple-page-master master-name="cover" page-width="{$pageWidth}" page-height="{$pageHeight}">
					<fo:region-body margin-top="24mm" margin-bottom="10mm" margin-left="19mm" margin-right="19mm"/>
					<fo:region-before region-name="cover-header" extent="24mm" />
					<fo:region-after region-name="footer" extent="10mm" />
					<fo:region-start region-name="left-region" extent="19mm"/>
					<fo:region-end region-name="right-region" extent="19mm"/>
				</fo:simple-page-master>
				
				<!-- document pages -->				
				<fo:simple-page-master master-name="odd" page-width="{$pageWidth}" page-height="{$pageHeight}">
					<fo:region-body margin-top="14mm" margin-bottom="10mm" margin-left="19mm" margin-right="19mm"/>
					<fo:region-before region-name="header-odd" extent="14mm" />
					<fo:region-after region-name="footer-odd" extent="10mm" />
					<fo:region-start region-name="left-region" extent="19mm"/>
					<fo:region-end region-name="right-region" extent="19mm"/>
				</fo:simple-page-master>
				<fo:simple-page-master master-name="even" page-width="{$pageWidth}" page-height="{$pageHeight}">
					<fo:region-body margin-top="14mm" margin-bottom="10mm" margin-left="19mm" margin-right="19mm"/>
					<fo:region-before region-name="header-even" extent="14mm" />
					<fo:region-after region-name="footer-even" extent="10mm" />
					<fo:region-start region-name="left-region" extent="19mm"/>
					<fo:region-end region-name="right-region" extent="19mm"/>
				</fo:simple-page-master>
				
				<fo:page-sequence-master master-name="document">
					<fo:repeatable-page-master-alternatives>						
						<fo:conditional-page-master-reference odd-or-even="even" master-reference="even"/>
						<fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd"/>
					</fo:repeatable-page-master-alternatives>
				</fo:page-sequence-master>
				
			</fo:layout-master-set>

			<xsl:call-template name="addPDFUAmeta"/>
			
			<fo:page-sequence master-reference="cover" force-page-count="no-force">
				<fo:static-content flow-name="cover-header">
					<fo:block-container height="100%">						
							<fo:block font-size="10pt" padding-top="12.5mm">
								<xsl:text>© Ribose Group Inc. 2007 – All rights reserved</xsl:text>
							</fo:block>						
					</fo:block-container>
				</fo:static-content>
				<fo:flow flow-name="xsl-region-body">
					<fo:block>
						<fo:inline>Test</fo:inline>
						<fo:external-graphic src="{concat('data:image/png;base64,', normalize-space($Image-MPFD-Logo))}" width="13.2mm" content-height="13mm" content-width="scale-to-fit" scaling="uniform" fox:alt-text="Image MPFD Logo"/>
					</fo:block>
					<fo:block-container text-align="center">
						<fo:block>								
							<fo:inline font-size="24pt" font-weight="bold">
								<xsl:call-template name="capitalizeWords">
									<xsl:with-param name="str" select="java:replaceAll(java:java.lang.String.new(/mpfd:mpfd-standard/mpfd:bibdata/mpfd:ext/mpfd:doctype),'MPF','')"/>
								</xsl:call-template>
							</fo:inline>
							<xsl:value-of select="$linebreak"/>
							<fo:inline font-size="16pt"><xsl:value-of select="$title-en"/></fo:inline>							
						</fo:block>
					</fo:block-container>
					<fo:block margin-bottom="12pt">&#xA0;</fo:block>
					<fo:block-container text-align="center" border="0.5pt solid black" margin-bottom="12pt">
						<fo:block font-size="16pt" margin-bottom="12pt" padding-top="1mm">
							<xsl:value-of select="/mpfd:mpfd-standard/mpfd:bibdata/mpfd:edition"/><xsl:text> Edition</xsl:text>
							<xsl:value-of select="$linebreak"/>
							<xsl:call-template name="formatDate">
								<xsl:with-param name="date" select="/mpfd:mpfd-standard/mpfd:bibdata/mpfd:version/mpfd:revision-date"/>
							</xsl:call-template>							
						</fo:block>
						<fo:block>Hong Kong</fo:block>
					</fo:block-container>
					<fo:block margin-bottom="12pt">&#xA0;</fo:block>
					<fo:block text-align="center">Ribose Group Inc.  <xsl:value-of select="/mpfd:mpfd-standard/mpfd:bibdata/mpfd:copyright/mpfd:from"/></fo:block>
				</fo:flow>
			</fo:page-sequence>
			
			<fo:page-sequence master-reference="document" initial-page-number="2" format="i"  force-page-count="no-force">
				<xsl:call-template name="insertHeaderFooter"/>
				
				
				<fo:flow flow-name="xsl-region-body">
					<fo:block-container font-weight="bold" text-align="center">
						<!-- Messaging, Malware and Mobile Anti-Abuse Working Group -->
						<fo:block font-size="16pt">
							<xsl:apply-templates select="/mpfd:mpfd-standard/mpfd:boilerplate/mpfd:feedback-statement/mpfd:p[@id = 'boilerplate-name']/node()"/>
						</fo:block>
						<!-- M 3 AAWG Companion Document:  
							Recipes for Encrypting  
							DNS Stub Resolver-to-Recursive Resolver Traffic  -->						
						<fo:block font-size="22pt" margin-top="16pt" >
							<fo:inline border-bottom="1pt solid black">
									<fo:inline>M</fo:inline><fo:inline font-size="13pt" vertical-align="super">3</fo:inline><fo:inline>AAWG Companion Document: </fo:inline>
							</fo:inline>
						</fo:block>
						
						<fo:block font-size="22pt" margin-bottom="12pt">
							<xsl:value-of select="$title-en"/>
						</fo:block>
						<!-- Version 1.0  -->
						<fo:block font-size="12pt" margin-bottom="6pt">
							<xsl:variable name="title-edition">
								<xsl:call-template name="getTitle">
									<xsl:with-param name="name" select="'title-edition'"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:value-of select="$title-edition"/><xsl:text>: </xsl:text>
							<xsl:variable name="edition" select="/mpfd:mpfd-standard/mpfd:bibdata/mpfd:edition"/>
							<xsl:choose>
								<xsl:when test="contains($edition, '.')">
									<xsl:value-of select="$edition"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$edition"/><xsl:text>.0</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
						<fo:block font-size="12pt" margin-bottom="12pt">
							<xsl:call-template name="convertDate">
								<xsl:with-param name="date" select="/mpfd:mpfd-standard/mpfd:bibdata/mpfd:version/mpfd:revision-date"/>
							</xsl:call-template>
						</fo:block>
					</fo:block-container>
					
					<fo:block-container font-size="12pt">
						<fo:block text-align="center" font-weight="normal" margin-bottom="10pt">
							<xsl:text>The direct URL to this paper is:  </xsl:text><fo:inline color="blue" text-decoration="underline">www.m3aawg.org/dns-crypto-recipes</fo:inline>
						</fo:block>
						<fo:block margin-bottom="10pt">This document is intended to accompany and complement the companion document, “M<fo:inline font-size="7pt" vertical-align="super">3</fo:inline> AAWG Tutorial  on Third Party Recursive Resolvers and Encrypting DNS Stub Resolver-to-Recursive Resolver Traffic” 
								(<fo:inline color="blue" text-decoration="underline">www.m3aawg.org/dns-crypto-tutorial</fo:inline>). 
						</fo:block>
						<fo:block margin-bottom="12pt">This document was produced by the M<fo:inline font-size="7pt" vertical-align="super">3</fo:inline> AAWG Data and Identity Protection Committee. </fo:block>
					</fo:block-container>
					
					<xsl:if test="$debug = 'true'">
						<xsl:text disable-output-escaping="yes">&lt;!--</xsl:text>
							DEBUG
							contents=<xsl:copy-of select="xalan:nodeset($contents)"/>
						<xsl:text disable-output-escaping="yes">--&gt;</xsl:text>
					</xsl:if>
					
					<!-- Table of content -->
					<fo:block-container>
						<xsl:variable name="title-toc">
							<xsl:call-template name="getTitle">
								<xsl:with-param name="name" select="'title-toc'"/>
							</xsl:call-template>
						</xsl:variable>
						<fo:block font-size="12pt" font-weight="bold" text-decoration="underline" margin-bottom="4pt"><xsl:value-of select="$title-toc"/></fo:block>
						<fo:table table-layout="fixed" width="100%" font-size="10pt">
							<fo:table-column column-width="25mm"/>
							<fo:table-column column-width="155mm"/>
							<fo:table-body>
								<xsl:for-each select="xalan:nodeset($contents)//item[@display = 'true'][not(@level = 2 and starts-with(@section, '0'))]"><!-- skip clause from preface -->							
									<fo:table-row height="6mm">
										<fo:table-cell>
											<fo:block font-weight="bold">
												<fo:basic-link internal-destination="{@id}" fox:alt-text="{text()}">
													<xsl:choose>
														<xsl:when test="@section = '0'">
															<xsl:value-of select="text()"/>
														</xsl:when>
														<xsl:when test="@type = 'references' and @section = ''">
															<xsl:value-of select="text()"/>
														</xsl:when>
														<xsl:when test="@level = 1">
															<xsl:value-of select="@section"/>
														</xsl:when>
														<xsl:otherwise></xsl:otherwise>
													</xsl:choose>
												</fo:basic-link>
											</fo:block>
										</fo:table-cell>
										<fo:table-cell>
											<fo:block text-align-last="justify">
												<xsl:if test="@level = 1">
													<xsl:attribute name="font-weight">bold</xsl:attribute>
												</xsl:if>
												<fo:basic-link internal-destination="{@id}" fox:alt-text="{text()}">
													<xsl:choose>
														<xsl:when test="@section = '0'"></xsl:when>
														<xsl:when test="@type = 'references' and @section = ''"></xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="text()"/>
														</xsl:otherwise>
													</xsl:choose>
													<fo:inline keep-together.within-line="always">
														<fo:leader font-weight="normal" leader-pattern="dots"/>
														<fo:inline><fo:page-number-citation ref-id="{@id}"/></fo:inline>
													</fo:inline>
												</fo:basic-link>
											</fo:block>
										</fo:table-cell>
									</fo:table-row>
								</xsl:for-each>
							</fo:table-body>
						</fo:table>
					</fo:block-container>
					
					<fo:block break-after="page"/>
					
					<fo:block>
						<xsl:apply-templates select="/mpfd:mpfd-standard/mpfd:boilerplate"/>
					</fo:block>
					
					<!-- Foreword, Introduction -->
					<fo:block>
						<xsl:apply-templates select="/mpfd:mpfd-standard/mpfd:preface/node()"/>
					</fo:block>
					
					<fo:block break-after="page"/>
					
					<xsl:apply-templates select="/mpfd:mpfd-standard/mpfd:sections/mpfd:clause[1]"> <!-- Scope -->
						<xsl:with-param name="sectionNum" select="'1'"/>
					</xsl:apply-templates>
					
					<!-- Normative references  -->
					<xsl:if test="/mpfd:mpfd-standard/mpfd:bibliography/mpfd:references[1]">
						<fo:block break-after="page"/>
						<xsl:apply-templates select="/mpfd:mpfd-standard/mpfd:bibliography/mpfd:references[1]">
							<xsl:with-param name="sectionNum" select="'2'"/>
						</xsl:apply-templates>
					</xsl:if>

					<!-- Main sections -->
					<xsl:apply-templates select="/mpfd:mpfd-standard/mpfd:sections/*[position() &gt; 1]">
						<xsl:with-param name="sectionNumSkew" select="'1'"/>
					</xsl:apply-templates>
					
					<!-- Annex(s) -->
					<xsl:apply-templates select="/mpfd:mpfd-standard/mpfd:annex"/>
					
					<!-- Bibliography -->
					<xsl:apply-templates select="/mpfd:mpfd-standard/mpfd:bibliography/mpfd:references[position() &gt; 1]"/>
				
				</fo:flow>
			</fo:page-sequence>
			
		</fo:root>
	</xsl:template> 

	
	<xsl:template match="mpfd:boilerplate//mpfd:p">
		<fo:block font-size="11pt" margin-bottom="12pt">
			<xsl:apply-templates/>
		</fo:block>
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
	<xsl:template match="mpfd:mpfd-standard/mpfd:sections/*" mode="contents">
		<xsl:param name="sectionNum"/>
		<xsl:param name="sectionNumSkew" select="0"/>
		<xsl:variable name="sectionNum_">
			<xsl:choose>
				<xsl:when test="$sectionNum"><xsl:value-of select="$sectionNum"/></xsl:when>
				<xsl:when test="$sectionNumSkew != 0">
					<xsl:variable name="number"><xsl:number count="*"/></xsl:variable> <!-- mpfd:sections/mpfd:clause | mpfd:sections/mpfd:terms -->
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
	<xsl:template match="mpfd:title | mpfd:preferred" mode="contents">
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
				<xsl:when test="ancestor::mpfd:bibitem">false</xsl:when>
				<xsl:when test="ancestor::mpfd:term">false</xsl:when>
				<xsl:when test="ancestor::mpfd:annex and $level &gt;= 3">false</xsl:when>
				<xsl:when test="$level &lt;= 3">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="display-section">true</xsl:variable>
		
		<xsl:variable name="type">
			<xsl:value-of select="local-name(..)"/>
		</xsl:variable>

		<xsl:variable name="root">
			<xsl:choose>
				<xsl:when test="ancestor::mpfd:annex">annex</xsl:when>
			</xsl:choose>
		</xsl:variable>
		
		<item id="{$id}" level="{$level}" section="{$section}" display-section="{$display-section}" display="{$display}" type="{$type}" root="{$root}">
			<xsl:attribute name="addon">
				<xsl:if test="local-name(..) = 'annex'">
					
					<xsl:variable name="obligation" select="../@obligation"/>
					<xsl:value-of select="$obligation"/>
					
				</xsl:if>
			</xsl:attribute>
			<xsl:value-of select="."/>
		</item>
		
		<xsl:apply-templates mode="contents">
			<xsl:with-param name="sectionNum" select="$sectionNum"/>
		</xsl:apply-templates>
		
	</xsl:template>
	
	
	<xsl:template match="mpfd:figure" mode="contents">
		<item level="" id="{@id}" display="false">
			<xsl:attribute name="section">
				<xsl:call-template name="getFigureNumber"/>
			</xsl:attribute>
		</item>
	</xsl:template>
	
	<xsl:template match="mpfd:table" mode="contents">
		<xsl:param name="sectionNum" />
		<xsl:variable name="annex-id" select="ancestor::mpfd:annex/@id"/>
		<item level="" id="{@id}" display="false" type="table">
			<xsl:attribute name="section">
				<xsl:variable name="title-table">
					<xsl:call-template name="getTitle">
						<xsl:with-param name="name" select="'title-table'"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:value-of select="$title-table"/>
				<xsl:choose>
					<xsl:when test="ancestor::*[local-name()='executivesummary']"> <!-- NIST -->
							<xsl:text>ES-</xsl:text><xsl:number format="1" count="*[local-name()='executivesummary']//*[local-name()='table']"/>
						</xsl:when>
					<xsl:when test="ancestor::*[local-name()='annex']">
						<xsl:number format="A-" count="mpfd:annex"/>
						<xsl:number format="1" level="any" count="mpfd:table[ancestor::mpfd:annex[@id = $annex-id]]"/>
					</xsl:when>
					<xsl:otherwise>
						<!-- <xsl:number format="1"/> -->
						<xsl:number format="1" level="any" count="*[local-name()='sections']//*[local-name()='table']"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:value-of select="mpfd:name/text()"/>
		</item>
	</xsl:template>
	
	<xsl:template match="mpfd:formula" mode="contents">
		<item level="" id="{@id}" display="false">
			<xsl:attribute name="section">
				<xsl:variable name="title-formula">
					<xsl:call-template name="getTitle">
						<xsl:with-param name="name" select="'title-formula'"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:value-of select="$title-formula"/><xsl:number format="(A.1)" level="multiple" count="mpfd:annex | mpfd:formula"/>
			</xsl:attribute>
		</item>
	</xsl:template>
	
	<xsl:template match="mpfd:li" mode="contents">
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
			<xsl:when test="local-name(..) = 'ul'">•</xsl:when> <!-- &#x2014; dash -->
			<xsl:otherwise> <!-- for ordered lists -->
				<xsl:choose>
					<xsl:when test="../@type = 'arabic'">
						<xsl:number format="a)"/>
					</xsl:when>
					<xsl:when test="../@type = 'alphabet'">
						<xsl:number format="1)"/>
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
	
	
	<!-- Foreword, Introduction -->
	<xsl:template match="mpfd:mpfd-standard/mpfd:preface/*">
		<fo:block break-after="page"/>
		<xsl:apply-templates />
	</xsl:template>
	
	
	<!-- clause, terms, clause, ...-->
	<xsl:template match="mpfd:mpfd-standard/mpfd:sections/*">
		<xsl:param name="sectionNum"/>
		<xsl:param name="sectionNumSkew" select="0"/>
		<fo:block break-after="page"/>
		<fo:block>
			<xsl:variable name="pos"><xsl:number count="mpfd:sections/mpfd:clause | mpfd:sections/mpfd:terms"/></xsl:variable>
			<xsl:if test="$pos &gt;= 2">
				<xsl:attribute name="space-before">18pt</xsl:attribute>
			</xsl:if>
			<!-- pos=<xsl:value-of select="$pos" /> -->
			<xsl:variable name="sectionNum_">
				<xsl:choose>
					<xsl:when test="$sectionNum"><xsl:value-of select="$sectionNum"/></xsl:when>
					<xsl:when test="$sectionNumSkew != 0">
						<xsl:variable name="number"><xsl:number count="mpfd:sections/mpfd:clause | mpfd:sections/mpfd:terms"/></xsl:variable>
						<xsl:value-of select="$number + $sectionNumSkew"/>
					</xsl:when>
				</xsl:choose>
			</xsl:variable>
			<xsl:if test="not(mpfd:title)">
				<fo:block margin-top="3pt" margin-bottom="12pt">
					<xsl:value-of select="$sectionNum_"/><xsl:number format=".1 " level="multiple" count="mpfd:clause" />
				</fo:block>
			</xsl:if>
			<xsl:apply-templates>
				<xsl:with-param name="sectionNum" select="$sectionNum_"/>
			</xsl:apply-templates>
		</fo:block>
	</xsl:template>
	
	
	<xsl:template match="mpfd:clause//mpfd:clause[not(mpfd:title)]">
		<xsl:param name="sectionNum"/>
		<xsl:variable name="section">
			<xsl:call-template name="getSection">
				<xsl:with-param name="sectionNum" select="$sectionNum"/>
			</xsl:call-template>
		</xsl:variable>
		<fo:block margin-top="6pt" margin-bottom="6pt" keep-with-next="always">
			<fo:inline>
				<xsl:value-of select="$section"/><!-- <xsl:text>.</xsl:text> -->
			</fo:inline>			
		</fo:block>
		<xsl:apply-templates>
			<xsl:with-param name="sectionNum" select="$sectionNum"/>
		</xsl:apply-templates>
	</xsl:template>
	
	
	<xsl:template match="mpfd:title">
		<xsl:param name="sectionNum"/>
		
		<xsl:variable name="parent-name"  select="local-name(..)"/>
		<xsl:variable name="references_num_current">
			<xsl:number level="any" count="mpfd:references"/>
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
		
		<xsl:variable name="font-size">
			<xsl:choose>
				<xsl:when test="ancestor::mpfd:preface">14pt</xsl:when>
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
		
		<xsl:choose>
			<xsl:when test="ancestor::mpfd:boilerplate">
				<fo:block id="{$id}" font-size="14pt" font-weight="bold" text-align="center" margin-top="12pt" margin-bottom="15.5pt" keep-with-next="always">
					<xsl:apply-templates />
				</fo:block>
			</xsl:when>
			<xsl:when test="$parent-name = 'annex'">
				<fo:block id="{$id}" font-size="{$font-size}" font-weight="bold" text-align="center" margin-bottom="12pt" keep-with-next="always">
					<xsl:value-of select="$section"/>
					<xsl:if test=" ../@obligation">
						<xsl:value-of select="$linebreak"/>
						<fo:inline font-weight="normal">
							<xsl:text>(</xsl:text>							
							<xsl:value-of select="../@obligation"/>
							<xsl:text>)</xsl:text>
						</fo:inline>
					</xsl:if>
					<fo:block margin-top="14pt" margin-bottom="24pt"><xsl:apply-templates /></fo:block>
				</fo:block>
			</xsl:when>
			 <!-- Bibliography -->
			<!-- <xsl:when test="$parent-name = 'references' and $references_num_current != 1">
				<fo:block id="{$id}" text-align="center" margin-top="6pt" margin-bottom="16pt" keep-with-next="always">
					<xsl:apply-templates />
				</fo:block>
			</xsl:when> -->
			
			<xsl:otherwise>
				<xsl:element name="{$element-name}">
					<xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute>
					<xsl:attribute name="font-size"><xsl:value-of select="$font-size"/></xsl:attribute>
					<xsl:attribute name="font-weight">bold</xsl:attribute>
					<xsl:attribute name="margin-top">
						<xsl:choose>
							<xsl:when test="ancestor::mpfd:preface">8pt</xsl:when>
							<xsl:when test="$level = 2 and ancestor::mpfd:annex">10pt</xsl:when>
							<xsl:when test="$level = 1">0pt</xsl:when>
							<xsl:when test="$level = ''">6pt</xsl:when>
							<xsl:otherwise>12pt</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="margin-bottom">
						<xsl:choose>
							<xsl:when test="ancestor::mpfd:preface">6pt</xsl:when>
							<xsl:when test="$level = 1">12pt</xsl:when>
							<xsl:otherwise>8pt</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="keep-with-next">always</xsl:attribute>		
					
					<xsl:choose>
						<xsl:when test="(ancestor::mpfd:sections and $level = 1) or 
																($parent-name = 'references' and $references_num_current = 1)">
							<fo:table table-layout="fixed" width="100%">
								<fo:table-column column-width="25mm"/>
								<fo:table-column column-width="150mm"/>
								<fo:table-body>
									<fo:table-row>
											<fo:table-cell>
												<fo:block>
													<xsl:value-of select="$section"/>
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
						</xsl:when>
						<xsl:when test="ancestor::mpfd:sections or ancestor::mpfd:annex">
							<fo:inline padding-right="3mm"><xsl:value-of select="$section"/></fo:inline>
							<xsl:apply-templates />
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates />
						</xsl:otherwise>
					</xsl:choose>
					
					
				</xsl:element>
				
				<xsl:if test="$element-name = 'fo:inline' and not(following-sibling::mpfd:p)">
					<!-- <fo:block> -->
						<xsl:value-of select="$linebreak"/>
					<!-- </fo:block> -->
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>		
	</xsl:template>
	

	
	<xsl:template match="mpfd:p">
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
					<xsl:when test="@align"><xsl:value-of select="@align"/></xsl:when>
					<xsl:when test="ancestor::mpfd:td/@align"><xsl:value-of select="ancestor::mpfd:td/@align"/></xsl:when>
					<xsl:when test="ancestor::mpfd:th/@align"><xsl:value-of select="ancestor::mpfd:th/@align"/></xsl:when>
					<xsl:otherwise>justify</xsl:otherwise><!-- left -->
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="text-indent">0mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:apply-templates />
		</xsl:element>
		<xsl:if test="$element-name = 'fo:inline' and not($inline = 'true') and not(local-name(..) = 'admonition')">
			<xsl:choose>
				<xsl:when test="ancestor::mpfd:annex">
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
	
	<xsl:template match="mpfd:li//mpfd:p//text()">
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
		<xsl:for-each select="//mpfd:p/mpfd:fn[generate-id(.)=generate-id(key('kfn',@reference)[1])]">
			<!-- copy unique fn -->
			<fn gen_id="{generate-id(.)}">
				<xsl:copy-of select="@*"/>
				<xsl:copy-of select="node()"/>
			</fn>
		</xsl:for-each>
	</xsl:variable>
	
	<xsl:template match="mpfd:p/mpfd:fn" priority="2">
		<xsl:variable name="gen_id" select="generate-id(.)"/>
		<xsl:variable name="reference" select="@reference"/>
		<xsl:variable name="number">
			<xsl:value-of select="count(xalan:nodeset($p_fn)//fn[@reference = $reference]/preceding-sibling::fn) + 1" />
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="xalan:nodeset($p_fn)//fn[@gen_id = $gen_id]">
				<fo:footnote>
					<fo:inline font-size="7pt" keep-with-previous.within-line="always" vertical-align="super">
						<fo:basic-link internal-destination="footnote_{@reference}_{$number}" fox:alt-text="footnote {@reference} {$number}">
							<!-- <xsl:value-of select="@reference"/> -->
							<xsl:value-of select="$number + count(//mpfd:bibitem[ancestor::mpfd:references[@id='_normative_references' or not(preceding-sibling::mpfd:references)]]/mpfd:note)"/>
						</fo:basic-link>
					</fo:inline>
					<fo:footnote-body>
						<fo:block font-size="9pt" margin-bottom="12pt">
							<fo:inline font-size="6pt" id="footnote_{@reference}_{$number}" keep-with-next.within-line="always" vertical-align="super" padding-right="1mm">
								<xsl:value-of select="$number + count(//mpfd:bibitem[ancestor::mpfd:references[@id='_normative_references' or not(preceding-sibling::mpfd:references)]]/mpfd:note)"/>
							</fo:inline>
							<xsl:for-each select="mpfd:p">
									<xsl:apply-templates />
							</xsl:for-each>
						</fo:block>
					</fo:footnote-body>
				</fo:footnote>
			</xsl:when>
			<xsl:otherwise>
				<fo:inline font-size="7pt" keep-with-previous.within-line="always" vertical-align="super">
					<fo:basic-link internal-destination="footnote_{@reference}_{$number}" fox:alt-text="footnote {@reference} {$number}">
						<xsl:value-of select="$number + count(//mpfd:bibitem/mpfd:note)"/>
					</fo:basic-link>
				</fo:inline>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="mpfd:p/mpfd:fn/mpfd:p">
		<xsl:apply-templates />
	</xsl:template>
	
	<xsl:template match="mpfd:review">
		<!-- comment 2019-11-29 -->
		<!-- <fo:block font-weight="bold">Review:</fo:block>
		<xsl:apply-templates /> -->
	</xsl:template>

	<xsl:template match="text()">
		<xsl:value-of select="."/>
	</xsl:template>

	<xsl:template match="mpfd:image">
		<fo:block-container text-align="center">
			<fo:block>
				<fo:external-graphic src="{@src}" fox:alt-text="Image {@alt}"/>
			</fo:block>
			<fo:block margin-top="12pt" margin-bottom="12pt">
				<xsl:variable name="title-figure">
					<xsl:call-template name="getTitle">
						<xsl:with-param name="name" select="'title-figure'"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:value-of select="$title-figure"/>
				<xsl:call-template name="getFigureNumber"/>
			</fo:block>
		</fo:block-container>
	</xsl:template>

	<xsl:template match="mpfd:figure">
		<fo:block-container id="{@id}">
			<fo:block>
				<xsl:apply-templates />
			</fo:block>
			<xsl:call-template name="fn_display_figure"/>
			<xsl:for-each select="mpfd:note//mpfd:p">
				<xsl:call-template name="note"/>
			</xsl:for-each>
			<fo:block text-align="center" margin-top="12pt" margin-bottom="12pt" keep-with-previous="always">
				<xsl:call-template name="getFigureNumber"/>
				<xsl:if test="mpfd:name">
					<!-- <xsl:if test="not(local-name(..) = 'figure')"> -->
						<xsl:text> — </xsl:text>
					<!-- </xsl:if> -->
					<xsl:value-of select="mpfd:name"/>
				</xsl:if>
			</fo:block>
		</fo:block-container>
	</xsl:template>
	
	<xsl:template name="getFigureNumber">
		<xsl:variable name="title-figure">
			<xsl:call-template name="getTitle">
				<xsl:with-param name="name" select="'title-figure'"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="ancestor::mpfd:annex">
				<xsl:value-of select="$title-figure"/><xsl:number format="A.1-1" level="multiple" count="mpfd:annex | mpfd:figure"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$title-figure"/><xsl:number format="1" level="any"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="mpfd:figure/mpfd:name"/>
	<xsl:template match="mpfd:figure/mpfd:fn" priority="2"/>
	<xsl:template match="mpfd:figure/mpfd:note"/>
	
	
	<xsl:template match="mpfd:figure/mpfd:image">
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
	
	
	<xsl:template match="mpfd:bibitem">
		<fo:block id="{@id}" margin-bottom="12pt" text-indent="-11.7mm" margin-left="11.7mm"> <!-- 12 pt -->
				<!-- mpfd:docidentifier -->
			<xsl:if test="mpfd:docidentifier">
				<xsl:choose>
					<xsl:when test="mpfd:docidentifier/@type = 'metanorma'"/>
					<xsl:otherwise><fo:inline><xsl:value-of select="mpfd:docidentifier"/></fo:inline></xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:apply-templates select="mpfd:note"/>
			<xsl:if test="mpfd:docidentifier">, </xsl:if>
			<fo:inline font-style="italic">
				<xsl:choose>
					<xsl:when test="mpfd:title[@type = 'main' and @language = 'en']">
						<xsl:value-of select="mpfd:title[@type = 'main' and @language = 'en']"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="mpfd:title"/>
					</xsl:otherwise>
				</xsl:choose>
			</fo:inline>
		</fo:block>
	</xsl:template>
	
	
	<xsl:template match="mpfd:bibitem/mpfd:note">
		<fo:footnote>
			<xsl:variable name="number">
				<xsl:number level="any" count="mpfd:bibitem/mpfd:note"/>
			</xsl:variable>
			<fo:inline font-size="7pt" keep-with-previous.within-line="always" baseline-shift="30%">
				<fo:basic-link internal-destination="{generate-id()}" fox:alt-text="footnote {$number}">
					<xsl:value-of select="$number"/>
				</fo:basic-link>
			</fo:inline>
			<fo:footnote-body>
				<fo:block font-size="9pt" margin-bottom="4pt" start-indent="0pt">
					<fo:inline font-size="6pt" id="{generate-id()}" keep-with-next.within-line="always" baseline-shift="30%" padding-right="1mm"><!-- alignment-baseline="hanging" font-size="60%"  -->
						<xsl:value-of select="$number"/>
					</fo:inline>
					<xsl:apply-templates />
				</fo:block>
			</fo:footnote-body>
		</fo:footnote>
	</xsl:template>
	
	
	
	<xsl:template match="mpfd:ul | mpfd:ol">
		<fo:block-container margin-left="6mm">
			<fo:block-container margin-left="0mm">
				<fo:list-block margin-bottom="12pt" provisional-distance-between-starts="6mm"> <!--   margin-bottom="8pt" -->
					<xsl:if test="local-name() = 'ol'">
						<xsl:attribute name="provisional-distance-between-starts">7mm</xsl:attribute>
					</xsl:if>			
					<xsl:apply-templates />
				</fo:list-block>
				<xsl:for-each select="./mpfd:note//mpfd:p">
					<xsl:call-template name="note"/>
				</xsl:for-each>
			</fo:block-container>
		</fo:block-container>
	</xsl:template>
	
	<xsl:template match="mpfd:ul//mpfd:note |  mpfd:ol//mpfd:note"/>
	
	<xsl:template match="mpfd:li">
		<fo:list-item id="{@id}">
			<fo:list-item-label end-indent="label-end()">
				<fo:block>
					<xsl:if test="local-name(..) = 'ul'">
						<xsl:attribute name="font-size">18pt</xsl:attribute>
						<xsl:attribute name="margin-top">-0.5mm</xsl:attribute><!-- to vertical align big dot -->
					</xsl:if>
					<xsl:call-template name="getListItemFormat"/>
				</fo:block>
			</fo:list-item-label>
			<fo:list-item-body start-indent="body-start()">
				<xsl:apply-templates />
				<xsl:apply-templates select=".//mpfd:note" mode="process"/>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>
	
	
	<xsl:template match="mpfd:term">
		<xsl:param name="sectionNum"/>
		<fo:block id="{@id}" keep-with-next="always" margin-top="10pt" margin-bottom="8pt" line-height="1.1">
			<fo:inline>
				<xsl:variable name="section">
					<xsl:for-each select="*[1]">
						<xsl:call-template name="getSection">
							<xsl:with-param name="sectionNum" select="$sectionNum"/>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:variable>
				<xsl:value-of select="$section"/><!-- <xsl:text>.</xsl:text> -->
			</fo:inline>
		</fo:block>
		<fo:block>
			<xsl:apply-templates>
				<xsl:with-param name="sectionNum" select="$sectionNum"/>
			</xsl:apply-templates>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="mpfd:preferred">
		<xsl:param name="sectionNum"/>

		<fo:inline>
			<xsl:apply-templates />
		</fo:inline>
		
		<xsl:if test="not(following-sibling::*[1][local-name() = 'preferred'])">
			<xsl:value-of select="$linebreak"/>
		</xsl:if>

	</xsl:template>
	
	<xsl:template match="mpfd:admitted">
		<xsl:param name="sectionNum"/>
		
		<fo:inline>
			<xsl:apply-templates />
		</fo:inline>
		
		<xsl:if test="not(following-sibling::*[1][local-name() = 'admitted'])">
			<xsl:value-of select="$linebreak"/>
		</xsl:if>
			
	</xsl:template>
	
	<xsl:template match="mpfd:deprecates">
		<xsl:param name="sectionNum"/>		
		<fo:inline>
			<xsl:if test="not(preceding-sibling::*[1][local-name() = 'deprecates'])">
				<xsl:variable name="title-deprecated">
					<xsl:call-template name="getTitle">
						<xsl:with-param name="name" select="'title-deprecated'"/>
					</xsl:call-template>
				</xsl:variable>
				<fo:inline><xsl:value-of select="$title-deprecated"/>: </fo:inline>
			</xsl:if>
			<xsl:apply-templates />
		</fo:inline>
		<xsl:if test="not(following-sibling::*[1][local-name() = 'deprecates'])">
			<xsl:value-of select="$linebreak"/>
		</xsl:if>
		
	</xsl:template>
	
	<xsl:template match="mpfd:definition[preceding-sibling::mpfd:domain]">
		<xsl:apply-templates />
	</xsl:template>
	<xsl:template match="mpfd:definition[preceding-sibling::mpfd:domain]/mpfd:p">
		<fo:inline> <xsl:apply-templates /></fo:inline>
		<fo:block>&#xA0;</fo:block>
	</xsl:template>
	
	<xsl:template match="mpfd:definition">
		<fo:block>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="mpfd:termsource">
		<fo:block>
			<!-- Example: [SOURCE: ISO 5127:2017, 3.1.6.02] -->
			<fo:basic-link internal-destination="{mpfd:origin/@bibitemid}" fox:alt-text="{mpfd:origin/@citeas}">
				<xsl:text>[</xsl:text> <!-- SOURCE:  -->
				<xsl:value-of select="mpfd:origin/@citeas"/>
				
				<xsl:apply-templates select="mpfd:origin/mpfd:localityStack"/>
				
			</fo:basic-link>
			<xsl:apply-templates select="mpfd:modification"/>
			<xsl:text>]</xsl:text>
		</fo:block>
	</xsl:template>
	

	<xsl:template match="mpfd:modification/mpfd:p">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="mpfd:modification/text()">
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="mpfd:termnote">
		<fo:block-container margin-left="0mm" margin-top="4pt" line-height="125%">
			<fo:block>
				<fo:inline padding-right="1mm">
					<xsl:variable name="num"><xsl:number /></xsl:variable>
					<xsl:variable name="title-note-to-entry">
						<xsl:call-template name="getTitle">
							<xsl:with-param name="name" select="'title-note-to-entry'"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:value-of select="java:replaceAll(java:java.lang.String.new($title-note-to-entry),'#',$num)"/>					
				</fo:inline>
				<xsl:apply-templates />
			</fo:block>
		</fo:block-container>
	</xsl:template>
	
	<xsl:template match="mpfd:termnote/mpfd:p">
		<fo:inline><xsl:apply-templates/></fo:inline>		
	</xsl:template>
	
	<xsl:template match="mpfd:domain">
		<fo:inline>&lt;<xsl:apply-templates/>&gt; </fo:inline>
	</xsl:template>
	
	
	<xsl:template match="mpfd:termexample">
		<fo:block margin-top="14pt" margin-bottom="14pt"  text-align="justify">
			<fo:inline padding-right="1mm" font-weight="bold">
				<xsl:variable name="title-example">
					<xsl:call-template name="getTitle">
						<xsl:with-param name="name" select="'title-example'"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:value-of select="$title-example"/>
				<xsl:if test="count(ancestor::mpfd:term[1]//mpfd:termexample) &gt; 1">
					<xsl:number />
				</xsl:if>
				<xsl:text>:</xsl:text>
			</fo:inline>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="mpfd:termexample/mpfd:p">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template>

	
	<xsl:template match="mpfd:annex">
		<fo:block break-after="page"/>
		<xsl:apply-templates />
	</xsl:template>

	
	<!-- <xsl:template match="mpfd:references[@id = '_bibliography']"> -->
	<xsl:template match="mpfd:references[position() &gt; 1]">
		<fo:block break-after="page"/>
		<xsl:apply-templates />
		<fo:block-container text-align="center">
			<fo:block-container margin-left="63mm" width="42mm" border-bottom="2pt solid black">
				<fo:block>&#xA0;</fo:block>
			</fo:block-container>
		</fo:block-container>
	</xsl:template>


	<!-- Example: [1] ISO 9:1995, Information and documentation – Transliteration of Cyrillic characters into Latin characters – Slavic and non-Slavic languages -->
	<!-- <xsl:template match="mpfd:references[@id = '_bibliography']/mpfd:bibitem"> -->
	<xsl:template match="mpfd:references[position() &gt; 1]/mpfd:bibitem">
		<fo:list-block margin-bottom="12pt" provisional-distance-between-starts="12mm">
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
							<xsl:if test="mpfd:docidentifier">
								<xsl:choose>
									<xsl:when test="mpfd:docidentifier/@type = 'metanorma'"/>
									<xsl:otherwise><xsl:value-of select="mpfd:docidentifier"/></xsl:otherwise>
								</xsl:choose>
							</xsl:if>
						</xsl:variable>
						<fo:inline><xsl:value-of select="$docidentifier"/></fo:inline>
						<xsl:apply-templates select="mpfd:note"/>
						<xsl:if test="normalize-space($docidentifier) != ''">, </xsl:if>
						<xsl:choose>
							<xsl:when test="mpfd:title[@type = 'main' and @language = 'en']">
								<xsl:apply-templates select="mpfd:title[@type = 'main' and @language = 'en']"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates select="mpfd:title"/>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:apply-templates select="mpfd:formattedref"/>
					</fo:block>
				</fo:list-item-body>
			</fo:list-item>
		</fo:list-block>
	</xsl:template>
	
	<!-- <xsl:template match="mpfd:references[@id = '_bibliography']/mpfd:bibitem" mode="contents"/> -->
	<xsl:template match="mpfd:references[position() &gt; 1]/mpfd:bibitem" mode="contents"/>
	
	<!-- <xsl:template match="mpfd:references[@id = '_bibliography']/mpfd:bibitem/mpfd:title"> -->
	<xsl:template match="mpfd:references[position() &gt; 1]/mpfd:bibitem/mpfd:title">
		<fo:inline font-style="italic">
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>

	<xsl:template match="mpfd:quote">
		<fo:block margin-top="12pt" margin-left="12mm" margin-right="12mm">
			<xsl:apply-templates select=".//mpfd:p"/>
		</fo:block>
		<fo:block text-align="right">
			<!-- — ISO, ISO 7301:2011, Clause 1 -->
			<xsl:text>— </xsl:text><xsl:value-of select="mpfd:author"/>
			<xsl:if test="mpfd:source">
				<xsl:text>, </xsl:text>
				<xsl:apply-templates select="mpfd:source"/>
			</xsl:if>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="mpfd:source">
		<fo:basic-link internal-destination="{@bibitemid}" fox:alt-text="{@citeas}">
			<xsl:value-of select="@citeas"/> <!--  disable-output-escaping="yes" -->
			<xsl:apply-templates select="mpfd:localityStack"/>
		</fo:basic-link>
	</xsl:template>
	
	
	<xsl:template match="mathml:math" priority="2">
		<fo:inline font-family="Cambria Math">
			<fo:instream-foreign-object fox:alt-text="Math">
				<xsl:copy-of select="."/>
			</fo:instream-foreign-object>
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="mpfd:xref" priority="2">
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
			
			<xsl:variable name="title-clause">
				<xsl:call-template name="getTitle">
					<xsl:with-param name="name" select="'title-clause'"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="title-annex">
				<xsl:call-template name="getTitle">
					<xsl:with-param name="name" select="'title-annex'"/>
				</xsl:call-template>
			</xsl:variable>
			
			<xsl:choose>
				<xsl:when test="$type = 'clause' and $root != 'annex' and $level = 1"><xsl:value-of select="$title-clause"/></xsl:when><!-- and not (ancestor::annex) -->
				<xsl:when test="$type = 'clause' and $root = 'annex'"><xsl:value-of select="$title-annex"/></xsl:when>
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
	
	<xsl:template match="mpfd:example/mpfd:p">
		<fo:block margin-top="8pt" margin-bottom="8pt">
			<xsl:variable name="claims_id" select="ancestor::mpfd:clause[1]/@id"/>
			<fo:inline padding-right="5mm" font-weight="bold">
				<xsl:variable name="title-example">
					<xsl:call-template name="getTitle">
						<xsl:with-param name="name" select="'title-example'"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:value-of select="$title-example"/>
				<xsl:if test="count(ancestor::mpfd:clause[1]//mpfd:example) &gt; 1">
					<xsl:number count="mpfd:example[ancestor::mpfd:clause[@id = $claims_id]]" level="any"/>
				</xsl:if>
			</fo:inline>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="mpfd:note/mpfd:p" name="note">
		<xsl:variable name="claims_id" select="ancestor::mpfd:clause[1]/@id"/>
		<fo:block-container margin-left="0mm" margin-top="4pt" line-height="125%">
			<fo:block>
				<fo:inline padding-right="5mm" font-weight="bold">
					<xsl:variable name="title-note">
						<xsl:call-template name="getTitle">
							<xsl:with-param name="name" select="'title-note'"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:value-of select="$title-note"/>
					<xsl:if test="count(ancestor::mpfd:clause[1]//mpfd:note) &gt; 1">
						<xsl:text> </xsl:text><xsl:number count="mpfd:note[ancestor::mpfd:clause[@id = $claims_id]]" level="any"/>
					</xsl:if>
					<xsl:text>:</xsl:text>
				</fo:inline>
				<xsl:apply-templates />
			</fo:block>
		</fo:block-container>
	</xsl:template>

	<!-- <eref type="inline" bibitemid="IEC60050-113" citeas="IEC 60050-113:2011"><localityStack><locality type="clause"><referenceFrom>113-01-12</referenceFrom></locality></localityStack></eref> -->
	<xsl:template match="mpfd:eref">
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
					<xsl:value-of select="@citeas"/> <!--  disable-output-escaping="yes" -->
				</xsl:when>
				<xsl:when test="@bibitemid and normalize-space(text()) = ''">
					<xsl:value-of select="//mpfd:bibitem[@id = current()/@bibitemid]/mpfd:docidentifier"/>
				</xsl:when>
				<xsl:otherwise></xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates select="mpfd:localityStack"/>
			<xsl:apply-templates select="text()"/>
		</fo:basic-link>
	</xsl:template>
	
	<xsl:template match="mpfd:locality">
		<xsl:variable name="title-clause">
			<xsl:call-template name="getTitle">
				<xsl:with-param name="name" select="'title-clause'"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="title-annex">
			<xsl:call-template name="getTitle">
				<xsl:with-param name="name" select="'title-annex'"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="title-table">
			<xsl:call-template name="getTitle">
				<xsl:with-param name="name" select="'title-table'"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="@type ='section' and ancestor::mpfd:termsource">SOURCE Section </xsl:when>
			<xsl:when test="ancestor::mpfd:termsource"></xsl:when>
			<xsl:when test="@type ='clause' and ancestor::mpfd:eref"></xsl:when>
			<xsl:when test="@type ='clause'"><xsl:value-of select="$title-clause"/></xsl:when>
			<xsl:when test="@type ='annex'"><xsl:value-of select="$title-annex"/></xsl:when>
			<xsl:when test="@type ='table'"><xsl:value-of select="$title-table"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="@type"/></xsl:otherwise>
		</xsl:choose>
		<xsl:text> </xsl:text><xsl:value-of select="mpfd:referenceFrom"/>
	</xsl:template>
	
	<xsl:template match="mpfd:admonition">
		<fo:block text-align="center" margin-bottom="12pt" font-weight="bold">			
			<xsl:value-of select="java:toUpperCase(java:java.lang.String.new(@type))"/>
		</fo:block>
		<fo:block font-weight="bold">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="mpfd:formula" priority="2">
		<fo:block id="{@id}">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="mpfd:formula/mpfd:dt/mpfd:stem" priority="2">
		<fo:inline>
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="mpfd:formula/mpfd:stem" priority="2">
		<fo:block margin-top="14pt" margin-bottom="14pt">
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
									<xsl:when test="ancestor::mpfd:annex">
										<xsl:number format="(A.1)" level="multiple" count="mpfd:annex | mpfd:formula"/>
									</xsl:when>
									<xsl:otherwise> <!-- not(ancestor::mpfd:annex) -->
										<xsl:text>(</xsl:text><xsl:number level="any" count="mpfd:formula"/><xsl:text>)</xsl:text>
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
	
	<xsl:template match="mpfd:br" priority="2">
		<xsl:value-of select="$linebreak"/>
	</xsl:template>

	<xsl:template name="getSection">
		<xsl:param name="sectionNum"/>
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		<xsl:variable name="references_num_current">
			<xsl:number level="any" count="mpfd:references"/>
		</xsl:variable>
		<xsl:variable name="section">
			<xsl:variable name="title-section">
				<xsl:call-template name="getTitle">
					<xsl:with-param name="name" select="'title-section'"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="ancestor::mpfd:bibliography and $references_num_current = 1"><!-- Normative references -->
					<xsl:value-of select="$title-section"/><xsl:value-of select="$sectionNum"/><xsl:text>.</xsl:text>
				</xsl:when>
				<xsl:when test="ancestor::mpfd:bibliography">
					<xsl:value-of select="$sectionNum"/>
				</xsl:when>
				<xsl:when test="ancestor::mpfd:sections">
					<!-- 1, 2, 3, 4, ... from main section (not annex, bibliography, ...) -->
					<xsl:if test="$level = 1">
						<xsl:value-of select="$title-section"/>
					</xsl:if>
					<xsl:choose>
						<xsl:when test="$level = 1">
							<xsl:value-of select="$sectionNum"/><xsl:text>.</xsl:text>
						</xsl:when>
						<xsl:when test="$level &gt;= 2">
							<xsl:variable name="num">
								<xsl:call-template name="getSubSection"/>								
							</xsl:variable>
							<xsl:value-of select="concat($sectionNum, $num)"/><xsl:text>.</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<!-- z<xsl:value-of select="$sectionNum"/>z -->
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>				
				<xsl:when test="ancestor::mpfd:annex">
					<xsl:variable name="annexid" select="normalize-space(/mpfd:mpfd-standard/mpfd:bibdata/mpfd:ext/mpfd:structuredidentifier/mpfd:annexid)"/>
					<xsl:choose>
						<xsl:when test="$level = 1">
							<xsl:variable name="title-annex">
								<xsl:call-template name="getTitle">
									<xsl:with-param name="name" select="'title-annex'"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:value-of select="$title-annex"/>
							<xsl:choose>
								<xsl:when test="count(//mpfd:annex) = 1 and $annexid != ''">
									<xsl:value-of select="$annexid"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:number format="A" level="any" count="mpfd:annex"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="count(//mpfd:annex) = 1 and $annexid != ''">
									<xsl:value-of select="$annexid"/><xsl:number format=".1" level="multiple" count="mpfd:clause"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:number format="A.1" level="multiple" count="mpfd:annex | mpfd:clause"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<!-- if preface and there is clause(s) -->
				<xsl:when test="ancestor::mpfd:preface">0</xsl:when>
					<!-- <xsl:choose>
						<xsl:when test="$level = 1 and  ..//mpfd:clause">0</xsl:when>
						<xsl:when test="$level &gt;= 2">
							<xsl:variable name="num">
								<xsl:number format=".1" level="multiple" count="mpfd:clause"/>
							</xsl:variable>
							<xsl:value-of select="concat('0', $num)"/>
						</xsl:when>
						<xsl:otherwise>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when> -->
				<xsl:otherwise>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$section"/>
	</xsl:template>

	<xsl:variable name="Image-MPFD-Logo">
		<xsl:text>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</xsl:text>
	</xsl:variable>
	
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

	<!-- convert date from format 2007-04-01 to 1 April 2007-->
	<xsl:template name="formatDate">
		<xsl:param name="date"/>
		<xsl:variable name="year" select="substring($date, 1, 4)"/>
		<xsl:variable name="month" select="substring($date, 6, 2)"/>
		<xsl:variable name="day" select="number(substring($date, 9, 2))"/>
		<xsl:variable name="monthStr">
			<xsl:choose>
				<xsl:when test="$month = '01'">January</xsl:when>
				<xsl:when test="$month = '02'">February</xsl:when>
				<xsl:when test="$month = '03'">March</xsl:when>
				<xsl:when test="$month = '04'">April</xsl:when>
				<xsl:when test="$month = '05'">May</xsl:when>
				<xsl:when test="$month = '06'">June</xsl:when>
				<xsl:when test="$month = '07'">July</xsl:when>
				<xsl:when test="$month = '08'">August</xsl:when>
				<xsl:when test="$month = '09'">September</xsl:when>
				<xsl:when test="$month = '10'">October</xsl:when>
				<xsl:when test="$month = '11'">November</xsl:when>
				<xsl:when test="$month = '12'">December</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="normalize-space(concat($day, ' ', $monthStr, ' ',  $year))"/>		
	</xsl:template>
	
	<xsl:template name="insertHeaderFooter">
		<xsl:param name="font-weight">normal</xsl:param>
		<fo:static-content flow-name="header-even">
			<fo:block-container height="100%" display-align="before">
				<fo:block padding-top="12.5mm">
					<xsl:value-of select="$copyrightShort"/>
				</fo:block>
			</fo:block-container>
		</fo:static-content>
		<fo:static-content flow-name="footer-even">
			<fo:block-container font-size="10pt" height="100%" display-align="after">
				<fo:table table-layout="fixed" width="100%">
					<fo:table-column column-width="10%"/>
					<fo:table-column column-width="90%"/>
					<fo:table-body>
						<fo:table-row>
							<fo:table-cell font-weight="{$font-weight}">
								<fo:block padding-bottom="5mm"><fo:page-number/></fo:block>
							</fo:table-cell>
							<fo:table-cell padding-right="2mm">
								<fo:block padding-bottom="5mm" text-align="right"><xsl:value-of select="$copyright"/></fo:block>
							</fo:table-cell>
						</fo:table-row>
					</fo:table-body>
				</fo:table>
			</fo:block-container>
		</fo:static-content>
		<fo:static-content flow-name="header-odd">
			<fo:block-container height="100%" display-align="before">
				<fo:block text-align="right" padding-top="12.5mm">
					<xsl:value-of select="$copyrightShort"/>
				</fo:block>
			</fo:block-container>
		</fo:static-content>
		<fo:static-content flow-name="footer-odd">
			<fo:block-container font-size="10pt" height="100%" display-align="after">
				<fo:table table-layout="fixed" width="100%">
					<fo:table-column column-width="90%"/>
					<fo:table-column column-width="10%"/>
					<fo:table-body>
						<fo:table-row>
							<fo:table-cell>
								<fo:block padding-bottom="5mm"><xsl:value-of select="$copyright"/></fo:block>
							</fo:table-cell>
							<fo:table-cell font-weight="{$font-weight}" padding-right="2mm">
								<fo:block padding-bottom="5mm" text-align="right"><fo:page-number/></fo:block>
							</fo:table-cell>
						</fo:table-row>
					</fo:table-body>
				</fo:table>
			</fo:block-container>
		</fo:static-content>
	</xsl:template>

	
	
</xsl:stylesheet>
