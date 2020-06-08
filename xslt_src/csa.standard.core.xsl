<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
											xmlns:fo="http://www.w3.org/1999/XSL/Format" 
											xmlns:csa="https://www.metanorma.org/ns/csa" 
											xmlns:mathml="http://www.w3.org/1998/Math/MathML" 
											xmlns:xalan="http://xml.apache.org/xalan" 
											xmlns:fox="http://xmlgraphics.apache.org/fop/extensions" 
											xmlns:java="http://xml.apache.org/xalan/java" 
											exclude-result-prefixes="java"
											version="1.0">

	<xsl:output version="1.0" method="xml" encoding="UTF-8" indent="yes"/>

	<xsl:variable name="pageWidth" select="'215.9mm'"/>
	<xsl:variable name="pageHeight" select="'279.4mm'"/>

	<xsl:variable name="namespace">csa</xsl:variable>

	<xsl:variable name="debug">false</xsl:variable>
	
	<xsl:variable name="copyright">
		<xsl:text>© Copyright </xsl:text>
		<xsl:value-of select="/csa:csa-standard/csa:bibdata/csa:copyright/csa:from"/>
		<xsl:text>, Cloud Security Alliance. All rights reserved.</xsl:text>
	</xsl:variable>
	
	<xsl:variable name="color-header-cover">rgb(55, 243, 244)</xsl:variable>
	<xsl:variable name="color-header-document">rgb(79, 201, 204)</xsl:variable>
	<xsl:variable name="color-link">rgb(33, 94, 159)</xsl:variable>
	
	<xsl:variable name="copyright_short">
		<xsl:text>© </xsl:text>
		<xsl:value-of select="/csa:csa-standard/csa:bibdata/csa:copyright/csa:from"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="/csa:csa-standard/csa:bibdata/csa:contributor/csa:organization/csa:name"/>
	</xsl:variable>
	
	<xsl:variable name="doctitle" select="/csa:csa-standard/csa:bibdata/csa:title[@language = 'en']"/>

	<xsl:variable name="doctype">
		<xsl:call-template name="capitalizeWords">
			<xsl:with-param name="str" select="/csa:csa-standard/csa:bibdata/csa:ext/csa:doctype"/>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="header">
		<xsl:text>Open Geospatial Consortium </xsl:text>
		<xsl:value-of select="/csa:csa-standard/csa:bibdata/csa:docidentifier[@type = 'csa-internal']"/>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="/csa:csa-standard/csa:bibdata/csa:copyright/csa:from"/>
	</xsl:variable>
	
	<xsl:variable name="contents">
		<contents>
		
			<xsl:apply-templates select="/csa:csa-standard/csa:preface/csa:introduction" mode="contents"/>
					
			<xsl:apply-templates select="/csa:csa-standard/csa:sections/csa:clause[@id='_scope']" mode="contents"/>
				
			<!-- Normative references  -->
			<xsl:apply-templates select="/csa:csa-standard/csa:bibliography/csa:references[@id = '_normative_references' or @id = '_references']" mode="contents"/>
		
			<xsl:apply-templates select="/csa:csa-standard/csa:sections/csa:terms" mode="contents"/> <!-- Terms and definitions -->
				
			<xsl:apply-templates select="/csa:csa-standard/csa:sections/*[local-name() != 'terms' and not(@id='_scope') and not(@id='conformance') and not(@id='_conformance')]" mode="contents"/>
				
			<xsl:apply-templates select="/csa:csa-standard/csa:annex" mode="contents"/>
			<xsl:apply-templates select="/csa:csa-standard/csa:bibliography/csa:references[@id != '_normative_references' and @id != '_references']" mode="contents"/>
			
		</contents>
	</xsl:variable>
	
	<xsl:variable name="lang">
		<xsl:call-template name="getLang"/>
	</xsl:variable>
	
	<xsl:template match="/">
		<xsl:message>INFO: Document namespace: '<xsl:value-of select="namespace-uri(/*)"/>'</xsl:message>
		<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format" font-family="AzoSans, STIX2Math" font-size="10pt" xml:lang="{$lang}">
			<fo:layout-master-set>
				<!-- Cover page -->
				<fo:simple-page-master master-name="cover-page" page-width="{$pageWidth}" page-height="{$pageHeight}">
					<fo:region-body margin-top="21mm" margin-bottom="21mm" margin-left="25mm" margin-right="25mm"/>
					<fo:region-before region-name="cover-page-header" extent="21mm" precedence="true"/>
					<fo:region-after region-name="footer" extent="21mm"/>
				</fo:simple-page-master>
				
				<fo:simple-page-master master-name="document" page-width="{$pageWidth}" page-height="{$pageHeight}">
					<fo:region-body margin-top="25mm" margin-bottom="21mm" margin-left="25mm" margin-right="25mm"/>
					<fo:region-before region-name="header" extent="25mm" precedence="true"/> 
					<fo:region-after region-name="footer" extent="21mm"/>
					<fo:region-start region-name="left-region" extent="25mm"/>
					<fo:region-end region-name="right-region" extent="25mm"/>
				</fo:simple-page-master>
				
			</fo:layout-master-set>
			
			<xsl:call-template name="addPDFUAmeta"/>
			
			<!-- Cover Page -->
			<fo:page-sequence master-reference="cover-page" force-page-count="no-force">				
				<fo:static-content flow-name="xsl-footnote-separator">
					<fo:block>
						<fo:leader leader-pattern="rule" leader-length="30%"/>
					</fo:block>
				</fo:static-content>
				<fo:static-content flow-name="cover-page-header">
					<fo:block-container height="2.5mm" background-color="{$color-header-cover}">
						<fo:block font-size="1pt">&#xA0;</fo:block>
					</fo:block-container>
					<fo:block-container position="absolute" top="2.5mm" height="{279.4 - 2.5}mm" width="100%" background-color="rgb(80, 203, 205)">
						<fo:block>&#xA0;</fo:block>
					</fo:block-container>
				</fo:static-content>
				
				<fo:flow flow-name="xsl-region-body">
					
					<fo:block-container width="136mm" margin-bottom="12pt">
						<fo:block font-size="36pt" font-weight="bold" color="rgb(54, 59, 74)">
							<xsl:value-of select="$doctitle" />
						</fo:block>
					</fo:block-container>
					
					<fo:block font-size="26pt" color="rgb(55, 60, 75)">
						<xsl:value-of select="/csa:csa-standard/csa:bibdata/csa:title[@language = 'en' and @type = 'subtitle']"/>
					</fo:block>
					
					<fo:block-container absolute-position="fixed" left="11mm" top="245mm">
						<fo:block>
							<fo:external-graphic src="{concat('data:image/png;base64,', normalize-space($Image-Logo))}" width="42mm" content-height="scale-to-fit" scaling="uniform" fox:alt-text="Image {@alt}"/>
						</fo:block>
					</fo:block-container>
					
				</fo:flow>
			</fo:page-sequence>
			<!-- End Cover Page -->
			
			
			<!-- Copyright, Content, Foreword, etc. pages -->
			<fo:page-sequence master-reference="document" initial-page-number="2" format="1" force-page-count="no-force">
				<fo:static-content flow-name="xsl-footnote-separator">
					<fo:block>
						<fo:leader leader-pattern="rule" leader-length="30%"/>
					</fo:block>
				</fo:static-content>
				<xsl:call-template name="insertHeaderFooter"/>
				<fo:flow flow-name="xsl-region-body">
				
					<xsl:if test="$debug = 'true'">
						<xsl:text disable-output-escaping="yes">&lt;!--</xsl:text>
							DEBUG
							contents=<!-- <xsl:copy-of select="xalan:nodeset($contents)"/> --> 
						<xsl:text disable-output-escaping="yes">--&gt;</xsl:text>
					</xsl:if>
					
					<fo:block>
						<fo:block>The permanent and official location for Cloud Security Alliance DevSecOps is</fo:block>
						<fo:block color="rgb(33, 94, 159)" text-decoration="underline">https://cloudsecurityalliance.org/group/DevSecOps/</fo:block>
					</fo:block>

					<fo:block-container absolute-position="fixed" left="25mm" top="152mm" width="165mm" height="100mm" display-align="after" color="rgb(165, 169, 172)" line-height="145%">
						<fo:block>© <xsl:value-of select="/csa:csa-standard/csa:bibdata/csa:copyright/csa:from"/> Cloud Security Alliance – All Rights Reserved. You may download, store, display on your
						computer, view, print, and link to the Cloud Security Alliance at <fo:inline text-decoration="underline">https://cloudsecurityalliance.org</fo:inline>
						subject to the following: (a) the draft may be used solely for your personal, informational, noncommercial
						use; (b) the draft may not be modified or altered in any way; (c) the draft may not be
						redistributed; and (d) the trademark, copyright or other notices may not be removed. You may quote
						portions of the draft as permitted by the Fair Use provisions of the United States Copyright Act,
						provided that you attribute the portions to the Cloud Security Alliance.</fo:block>
					</fo:block-container>
					
					<fo:block break-after="page"/>
					
					<fo:block font-size="26pt" margin-bottom="18pt">Acknowledgements</fo:block>

					<fo:block font-size="18pt" font-weight="bold" margin-bottom="12pt" color="rgb(3, 115, 200)">Lead Authors:</fo:block>
					<fo:block>Ronald Tse</fo:block>
					<fo:block font-size="18pt" font-weight="bold" margin-top="16pt" margin-bottom="12pt" color="rgb(3, 115, 200)">Contributors:</fo:block>
					<fo:block>Michael Roza</fo:block>
					<fo:block>Sean Heide</fo:block>
					<fo:block>David Lewis</fo:block>
					<fo:block>Eric Gauthier</fo:block>
					<fo:block font-size="18pt" font-weight="bold" margin-top="16pt" margin-bottom="12pt" color="rgb(3, 115, 200)">CSA Staff:</fo:block>
					<fo:block>Sean Heide</fo:block>
					
					<fo:block break-after="page"/>

					<fo:block-container font-size="12pt" line-height="170%" color="rgb(7, 72, 156)">
						<fo:block font-size="26pt" color="black" margin-top="2pt" margin-bottom="30pt">Table of Contents</fo:block>
						
						<fo:block margin-left="-3mm">
							<xsl:for-each select="xalan:nodeset($contents)//item[@display = 'true' and @level &lt;= 2]">
								
								<fo:block>
									<fo:list-block>
										
										<xsl:attribute name="provisional-distance-between-starts">
											<xsl:choose>
												<xsl:when test="@level = 2">10mm</xsl:when>
												<xsl:otherwise>3mm</xsl:otherwise>
											</xsl:choose>
										</xsl:attribute>
										<fo:list-item>
											<fo:list-item-label end-indent="label-end()">
												<fo:block font-size="1pt">&#x200a;</fo:block>
											</fo:list-item-label>
											<fo:list-item-body start-indent="body-start()">
												<fo:block text-align-last="justify" margin-left="12mm" text-indent="-12mm">
													<fo:basic-link internal-destination="{@id}" fox:alt-text="{text()}">
														<xsl:if test="@section and @display-section = 'false' and not(@section = '0')">
															<xsl:value-of select="@section"/><xsl:text> </xsl:text>
														</xsl:if>
														<xsl:if test="@addon != ''">
															<xsl:text>(</xsl:text><xsl:value-of select="@addon"/><xsl:text>)</xsl:text>
														</xsl:if>
														<xsl:text> </xsl:text><xsl:value-of select="text()"/>
														<fo:inline keep-together.within-line="always">
															<fo:leader leader-pattern="dots"/>
															<fo:inline><fo:page-number-citation ref-id="{@id}"/></fo:inline>
														</fo:inline>
													</fo:basic-link>
												</fo:block>
											</fo:list-item-body>
										</fo:list-item>
									</fo:list-block>
								</fo:block>
							</xsl:for-each>
						</fo:block>
					</fo:block-container>
					
					<fo:block break-after="page"/>
					
					<fo:block line-height="145%">
						<xsl:apply-templates select="/csa:csa-standard/csa:preface/csa:introduction" mode="introduction"/>
					
						<xsl:apply-templates select="/csa:csa-standard/csa:sections/csa:clause[@id='_scope']"/>
							
						<!-- Normative references  -->
						<xsl:apply-templates select="/csa:csa-standard/csa:bibliography/csa:references[@id = '_normative_references' or @id = '_references']"/>
					
						<xsl:apply-templates select="/csa:csa-standard/csa:sections/csa:terms"/> <!-- Terms and definitions -->
							
						<xsl:apply-templates select="/csa:csa-standard/csa:sections/*[local-name() != 'terms' and not(@id='_scope') and not(@id='conformance') and not(@id='_conformance')]"/>
							
						<xsl:apply-templates select="/csa:csa-standard/csa:annex"/>
						<xsl:apply-templates select="/csa:csa-standard/csa:bibliography/csa:references[@id != '_normative_references' and @id != '_references']" />
						
					</fo:block>
					
					
				</fo:flow>
			</fo:page-sequence>
			<!-- End Document Pages -->
			
		</fo:root>
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
	<xsl:template match="csa:csa-standard/csa:sections/*" mode="contents">
		<xsl:param name="sectionNum"/>
		<xsl:param name="sectionNumSkew" select="0"/>
		<xsl:variable name="sectionNum_">
			<xsl:choose>
				<xsl:when test="$sectionNum"><xsl:value-of select="$sectionNum"/></xsl:when>
				<xsl:when test="$sectionNumSkew != 0">
					<xsl:variable name="number"><xsl:number count="csa:sections/csa:clause[not(@id='_scope') and not(@id='conformance') and not(@id='_conformance')]"/></xsl:variable> <!-- * csa:sections/csa:clause | csa:sections/csa:terms -->
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
	<xsl:template match="csa:csa-standard/csa:sections/csa:terms" mode="contents">
		<xsl:param name="sectionNum"/>
		<xsl:param name="sectionNumSkew" select="0"/>
		<xsl:variable name="sectionNum_">
			<xsl:choose>
				<xsl:when test="$sectionNum"><xsl:value-of select="$sectionNum"/></xsl:when>
				<xsl:when test="$sectionNumSkew != 0">
					<xsl:variable name="number"><xsl:number count="*"/></xsl:variable> <!-- csa:sections/csa:clause | csa:sections/csa:terms -->
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
	<xsl:template match="csa:title | csa:preferred" mode="contents">
		<xsl:param name="sectionNum"/>
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
				<xsl:when test="ancestor::csa:bibitem">false</xsl:when>
				<xsl:when test="ancestor::csa:term">false</xsl:when>
				<xsl:when test="ancestor::csa:annex and $level &gt;= 3">false</xsl:when>
				<xsl:when test="$level &lt;= 3">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="display-section">
			<xsl:choose>
				<xsl:when test="ancestor::csa:annex and $level &gt;= 2">true</xsl:when>
				<xsl:when test="ancestor::csa:annex">false</xsl:when>
				<xsl:when test="$section = '0'">false</xsl:when>
				<xsl:otherwise>true</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="type">
			<xsl:value-of select="local-name(..)"/>
		</xsl:variable>

		<xsl:variable name="root">
			<xsl:choose>
				<xsl:when test="ancestor::csa:annex">annex</xsl:when>
				<xsl:when test="ancestor::csa:clause">clause</xsl:when>
				<xsl:when test="ancestor::csa:terms">terms</xsl:when>
			</xsl:choose>
		</xsl:variable>
		
		<item id="{$id}" level="{$level}" section="{$section}" display-section="{$display-section}" display="{$display}" type="{$type}" root="{$root}">
			<xsl:attribute name="addon">
				<xsl:if test="local-name(..) = 'annex'"><xsl:value-of select="../@obligation"/></xsl:if>
			</xsl:attribute>
			<xsl:apply-templates />
		</item>
		
		<xsl:apply-templates mode="contents">
			<xsl:with-param name="sectionNum" select="$sectionNum"/>
		</xsl:apply-templates>
		
	</xsl:template>
	
	<xsl:template match="csa:csa-standard/csa:preface/*" mode="contents">
		<xsl:param name="sectionNum" select="'1'"/>
		<xsl:variable name="section">
			<xsl:number format="i" value="$sectionNum"/>
		</xsl:variable>
		<xsl:variable name="id">
			<xsl:choose>
				<xsl:when test="@id">
					<xsl:value-of select="@id"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="local-name()"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="not(csa:title)">
			<item id="{$id}" level="1" section="{$section}" display-section="true" display="true" type="abstract" root="preface">
				<xsl:if test="local-name() = 'foreword'">
					<xsl:attribute name="display">false</xsl:attribute>
				</xsl:if>
				<xsl:choose>
					<xsl:when test="not(csa:title)">
						<xsl:variable name="name" select="local-name()"/>
						<xsl:value-of select="translate(substring($name, 1, 1), $lower, $upper)"/><xsl:value-of select="substring($name, 2)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="csa:title"/>
					</xsl:otherwise>
				</xsl:choose>
			</item>
		</xsl:if>
		<xsl:apply-templates mode="contents">
			<xsl:with-param name="sectionNum" select="$sectionNum"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<!-- Keywords -->
	<xsl:template match="/csa:csa-standard/csa:bibdata/csa:keyword" mode="contents">
		<xsl:param name="sectionNum" select="'1'"/>
		<xsl:variable name="section">
			<xsl:number format="i" value="$sectionNum"/>
		</xsl:variable>
		<item id="keywords" level="1" section="{$section}" display-section="true" display="true" type="abstract" root="preface">
			<xsl:text>Keywords</xsl:text>
		</item>
	</xsl:template>
	<!-- Submitting Organizations -->
	<xsl:template match="/csa:csa-standard/csa:bibdata/csa:contributor[csa:role/@type='author']/csa:organization/csa:name" mode="contents">
		<xsl:param name="sectionNum" select="'1'"/>
		<xsl:variable name="section">
			<xsl:number format="i" value="$sectionNum"/>
		</xsl:variable>
		<item id="submitting_orgs" level="1" section="{$section}" display-section="true" display="true" type="abstract" root="preface">
			<xsl:text>Submitting Organizations</xsl:text>
		</item>
	</xsl:template>
	
	<xsl:template match="csa:figure" mode="contents">
		<xsl:param name="sectionNum" />
		<item level="" id="{@id}" type="figure">
			<xsl:attribute name="section">
				<xsl:text>Figure </xsl:text>
				<xsl:choose>
					<xsl:when test="ancestor::csa:annex">
						<xsl:choose>
							<xsl:when test="count(//csa:annex) = 1">
								<xsl:value-of select="/csa:nist-standard/csa:bibdata/csa:ext/csa:structuredidentifier/csa:annexid"/><xsl:number format="-1" level="any" count="csa:annex//csa:figure"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:number format="A.1-1" level="multiple" count="csa:annex | csa:figure"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="ancestor::csa:figure">
						<xsl:for-each select="parent::*[1]">
							<xsl:number format="1" level="any" count="csa:figure[not(parent::csa:figure)]"/>
						</xsl:for-each>
						<xsl:number format="-a"  count="csa:figure"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:number format="1" level="any" count="csa:figure[not(parent::csa:figure)] | csa:sourcecode[not(@unnumbered = 'true') and not(ancestor::csa:example)]"/>
						<!-- <xsl:number format="1.1-1" level="multiple" count="csa:annex | csa:figure"/> -->
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:value-of select="csa:name"/>
		</item>
	</xsl:template>

	
	
	<xsl:template match="csa:table[not(@unnumbered='true')]" mode="contents">
		<xsl:param name="sectionNum" />
		<xsl:variable name="annex-id" select="ancestor::csa:annex/@id"/>
		<item level="" id="{@id}" display="false" type="table">
			<xsl:attribute name="section">
				<xsl:text>Table </xsl:text>
				<xsl:choose>
					<xsl:when test="ancestor::*[local-name()='executivesummary']">
							<xsl:text>ES-</xsl:text><xsl:number format="1" count="*[local-name()='executivesummary']//*[local-name()='table'][not(@unnumbered='true')]"/>
						</xsl:when>
					<xsl:when test="ancestor::*[local-name()='annex']">
						<xsl:number format="A-" count="csa:annex"/>
						<xsl:number format="1" level="any" count="csa:table[ancestor::csa:annex[@id = $annex-id]][not(@unnumbered='true')]"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:number format="1" level="any" count="*[local-name()='sections']//*[local-name()='table'][not(@unnumbered='true')] | *[local-name()='preface']//*[local-name()='table'][not(@unnumbered='true')]"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:value-of select="csa:name/text()"/>
		</item>
	</xsl:template>
	
	
	
	<xsl:template match="csa:formula" mode="contents">
		<item level="" id="{@id}" display="false">
			<xsl:attribute name="section">
				<xsl:text>Formula (</xsl:text><xsl:number format="A.1" level="multiple" count="csa:annex | csa:formula"/><xsl:text>)</xsl:text>
			</xsl:attribute>
		</item>
	</xsl:template>
	
	<xsl:template match="csa:fn" mode="contents"/>
	<!-- ============================= -->
	<!-- ============================= -->
	
	<xsl:template match="/csa:csa-standard/csa:bibdata/csa:uri[not(@type)]">
		<fo:block margin-bottom="12pt">
			<xsl:text>URL for this OGC® document: </xsl:text>
			<xsl:value-of select="."/><xsl:text> </xsl:text>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="/csa:csa-standard/csa:bibdata/csa:edition">
		<fo:block margin-bottom="12pt">
			<xsl:text>Version: </xsl:text>
			<xsl:value-of select="."/><xsl:text> </xsl:text>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="csa:license-statement//csa:title">
		<fo:block text-align="center" font-weight="bold" margin-top="4pt">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="csa:license-statement//csa:p">
		<fo:block font-size="8pt" margin-top="14pt" line-height="115%">
			<xsl:if test="following-sibling::csa:p">
				<xsl:attribute name="margin-bottom">14pt</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="csa:feedback-statement">
		<fo:block margin-top="12pt" margin-bottom="12pt">
			<xsl:apply-templates select="csa:clause[1]"/>
		</fo:block>
	</xsl:template>
		
	<xsl:template match="csa:copyright-statement//csa:title">
		<fo:block font-weight="bold" text-align="center">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	<xsl:template match="csa:copyright-statement//csa:p">
		<fo:block margin-bottom="12pt">
			<xsl:if test="not(following-sibling::p)">
				<xsl:attribute name="margin-bottom">10pt</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="text-align">
				<xsl:choose>
					<xsl:when test="@align"><xsl:value-of select="@align"/></xsl:when>
					<xsl:otherwise>left</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="csa:legal-statement">
		<fo:block-container border="0.5pt solid black" margin-bottom="12pt" margin-left="-2mm" margin-right="-2mm">
			<fo:block-container margin-left="0mm" margin-right="0mm">
				<fo:block margin-left="2mm" margin-right="2mm">
					<xsl:apply-templates/>
				</fo:block>
			</fo:block-container>
		</fo:block-container>
	</xsl:template>

	
	<xsl:template match="csa:legal-statement//csa:title">
		<fo:block text-align="center" font-weight="bold" padding-top="2mm" margin-bottom="6pt">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="csa:legal-statement//csa:p">
		<fo:block margin-bottom="6pt">
			<xsl:if test="not(following-sibling::csa:p)">
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="text-align">
				<xsl:choose>
					<xsl:when test="@align"><xsl:value-of select="@align"/></xsl:when>
					<xsl:otherwise>left</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	
	<!-- Introduction -->
	<xsl:template match="csa:csa-standard/csa:preface/csa:introduction" mode="introduction">
		<fo:block break-after="page"/>
		<xsl:apply-templates select="current()"/>
	</xsl:template>
	<!-- Abstract -->
	<xsl:template match="csa:csa-standard/csa:preface/csa:abstract" mode="abstract">
		<fo:block break-after="page"/>
		<xsl:apply-templates select="current()"/>
	</xsl:template>
	<!-- Preface -->
	<xsl:template match="csa:csa-standard/csa:preface/csa:foreword" mode="preface">
		<xsl:param name="sectionNum"/>
		<fo:block break-after="page"/>
		<xsl:apply-templates select="current()">
			<xsl:with-param name="sectionNum" select="$sectionNum"/>
		</xsl:apply-templates>
	</xsl:template>
	<!-- Abstract, Preface -->
	<xsl:template match="csa:csa-standard/csa:preface/*">
		<xsl:param name="sectionNum" select="'1'"/>
		<xsl:if test="not(csa:title)">
			<xsl:variable name="id">
				<xsl:choose>
					<xsl:when test="@id">
						<xsl:value-of select="@id"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="local-name()"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<fo:block id="{$id}" font-size="13pt" font-weight="bold" margin-bottom="12pt" color="rgb(14, 26, 133)">
				<xsl:number format="i." value="$sectionNum"/><fo:inline padding-right="3mm">&#xA0;</fo:inline>
				<xsl:variable name="name" select="local-name()"/>
				<xsl:value-of select="translate(substring($name, 1, 1), $lower, $upper)"/><xsl:value-of select="substring($name, 2)"/>
			</fo:block>
		</xsl:if>
		<xsl:apply-templates />
	</xsl:template>
	<!-- Keywords -->
	<xsl:template match="/csa:csa-standard/csa:bibdata/csa:keyword">
		<xsl:param name="sectionNum" select="'1'"/>
		<fo:block id="keywords" font-size="13pt" font-weight="bold" margin-top="13.5pt" margin-bottom="12pt" color="rgb(14, 26, 133)">
			<xsl:number format="i." value="$sectionNum"/><fo:inline padding-right="2mm">&#xA0;</fo:inline>
			<xsl:text>Keywords</xsl:text>
		</fo:block>
		<fo:block margin-bottom="12pt">The following are keywords to be used by search engines and document catalogues.</fo:block>
		<fo:block margin-bottom="12pt">		
			<xsl:call-template name="insertKeywords">
				<xsl:with-param name="sorting">no</xsl:with-param>
				<xsl:with-param name="charAtEnd"></xsl:with-param>
			</xsl:call-template>		
			<!-- <xsl:for-each select="/csa:csa-standard/csa:bibdata/csa:keyword">
				<xsl:value-of select="."/>
				<xsl:if test="position() != last()">, </xsl:if>
			</xsl:for-each> -->
		</fo:block>
	</xsl:template>
	<!-- Submitting Organizations -->
	<xsl:template match="/csa:csa-standard/csa:bibdata/csa:contributor[csa:role/@type='author']/csa:organization/csa:name">
		<xsl:param name="sectionNum" select="'1'"/>
		<fo:block id="submitting_orgs" font-size="13pt" font-weight="bold" color="rgb(14, 26, 133)" margin-top="13.5pt" margin-bottom="12pt">
			<xsl:number format="i." value="$sectionNum"/><fo:inline padding-right="3mm">&#xA0;</fo:inline>
			<xsl:text>Submitting Organizations</xsl:text>
		</fo:block>
		<fo:block margin-bottom="12pt">The following organizations submitted this Document to the Open Geospatial Consortium (OGC):</fo:block>
		<fo:list-block provisional-distance-between-starts="6.5mm" margin-bottom="12pt" line-height="115%">
			<xsl:for-each select="/csa:csa-standard/csa:bibdata/csa:contributor[csa:role/@type='author']/csa:organization/csa:name">
				<fo:list-item>
					<fo:list-item-label end-indent="label-end()">
						<fo:block>&#x2014;</fo:block>
					</fo:list-item-label>
					<fo:list-item-body start-indent="body-start()" line-height-shift-adjustment="disregard-shifts">
						<fo:block>
							<xsl:apply-templates />
						</fo:block>
					</fo:list-item-body>
				</fo:list-item>
			</xsl:for-each>
		</fo:list-block>
	</xsl:template>

	
	<!-- clause, terms, clause, ...-->
	<xsl:template match="csa:csa-standard/csa:sections/*">
		<xsl:param name="sectionNum"/>
		<xsl:param name="sectionNumSkew" select="0"/>
		<fo:block>
			<xsl:variable name="pos"><xsl:number count="csa:sections/csa:clause[not(@id='_scope') and not(@id='conformance') and not(@id='_conformance')]"/></xsl:variable> <!--  | csa:sections/csa:terms -->
			<xsl:if test="$pos &gt;= 2">
				<xsl:attribute name="space-before">18pt</xsl:attribute>
			</xsl:if>
			<xsl:variable name="sectionNum_">
				<xsl:choose>
					<xsl:when test="$sectionNum"><xsl:value-of select="$sectionNum"/></xsl:when>
					<xsl:when test="$sectionNumSkew != 0">
						<xsl:variable name="number"><xsl:number count="csa:sections/csa:clause[not(@id='_scope') and not(@id='conformance') and not(@id='_conformance')]"/></xsl:variable> <!--  | csa:sections/csa:terms -->
						<xsl:value-of select="$number + $sectionNumSkew"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:number count="*"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:if test="not(csa:title)">
				<fo:block margin-top="3pt" margin-bottom="12pt">
					<xsl:value-of select="$sectionNum_"/><xsl:number format=".1 " level="multiple" count="csa:clause[not(@id='_scope') and not(@id='conformance') and not(@id='_conformance')]" />
				</fo:block>
			</xsl:if>
			<xsl:apply-templates>
				<xsl:with-param name="sectionNum" select="$sectionNum_"/>
			</xsl:apply-templates>
		</fo:block>
	</xsl:template>
	

	
	<xsl:template match="csa:clause//csa:clause[not(csa:title)]">
		<xsl:param name="sectionNum"/>
		<xsl:variable name="section">
			<xsl:call-template name="getSection">
				<xsl:with-param name="sectionNum" select="$sectionNum"/>
			</xsl:call-template>
		</xsl:variable>
		
		<fo:block margin-top="3pt" >
			<fo:inline font-weight="bold" padding-right="3mm">
				<xsl:value-of select="$section"/>
			</fo:inline>
			<xsl:apply-templates>
				<xsl:with-param name="sectionNum" select="$sectionNum"/>
				<xsl:with-param name="inline" select="'true'"/>
			</xsl:apply-templates>
		</fo:block>
	</xsl:template>
	
	
	<xsl:template match="csa:title">
		<xsl:param name="sectionNum"/>
		
		<xsl:variable name="parent-name"  select="local-name(..)"/>
		<xsl:variable name="references_num_current">
			<xsl:number level="any" count="csa:references"/>
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
				<xsl:when test="ancestor::csa:preface and $level &gt;= 2">12pt</xsl:when>
				<xsl:when test="ancestor::csa:preface">13pt</xsl:when>
				<xsl:when test="$level = 1">26pt</xsl:when>
				<xsl:when test="$level = 2 and ancestor::csa:terms">11pt</xsl:when>
				<xsl:when test="$level = 2">14pt</xsl:when>
				<xsl:when test="$level &gt;= 3">11pt</xsl:when>
				<xsl:otherwise>16pt</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="font-weight">
			<xsl:choose>
				<xsl:when test="$level = 1">normal</xsl:when>
				<xsl:otherwise>bold</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="element-name">
			<xsl:choose>
				<xsl:when test="../@inline-header = 'true'">fo:inline</xsl:when>
				<xsl:otherwise>fo:block</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="color">
			<xsl:choose>
				<xsl:when test="$level &gt;= 2">rgb(3, 115, 200)</xsl:when>
				<xsl:otherwise>black</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="$parent-name = 'annex'">
				<fo:block id="{$id}" font-size="12pt" font-weight="{$font-weight}" text-align="center" margin-bottom="12pt" keep-with-next="always" color="{$color}">
					<xsl:value-of select="$section"/>
					<xsl:if test=" ../@obligation">
						<xsl:value-of select="$linebreak"/>
						<fo:inline font-weight="normal">(<xsl:value-of select="../@obligation"/>)</fo:inline>
					</xsl:if>
					<xsl:value-of select="$linebreak"/>
					<xsl:apply-templates />
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="{$element-name}">
					<xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute>
					<xsl:attribute name="font-size"><xsl:value-of select="$font-size"/></xsl:attribute>
					<xsl:attribute name="font-weight"><xsl:value-of select="$font-weight"/></xsl:attribute>
					<xsl:attribute name="space-before">13.5pt</xsl:attribute>
					<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
					<xsl:attribute name="keep-with-next">always</xsl:attribute>		
					<xsl:attribute name="color"><xsl:value-of select="$color"/></xsl:attribute>
					<xsl:attribute name="line-height">120%</xsl:attribute>
					
					<xsl:if test="$level = 2">
						<fo:inline padding-right="1mm">
							<fo:external-graphic src="{concat('data:image/png;base64,', normalize-space($Title-Image))}" width="15mm" content-height="scale-to-fit" scaling="uniform" fox:alt-text="Image {@alt}" vertical-align="middle"/>
						</fo:inline>
					</xsl:if>
					
					<xsl:apply-templates />
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
	
	<xsl:template match="csa:p">
		<xsl:param name="inline" select="'false'"/>
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
			<xsl:attribute name="id">
				<xsl:value-of select="@id"/>
			</xsl:attribute>
			<xsl:attribute name="text-align">
				<xsl:choose>
					<!-- <xsl:when test="ancestor::csa:preface">justify</xsl:when> -->
					<xsl:when test="@align"><xsl:value-of select="@align"/></xsl:when>
					<xsl:otherwise>left</xsl:otherwise><!-- justify -->
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="space-after">
				<xsl:choose>
					<xsl:when test="ancestor::csa:li">0pt</xsl:when>
					<xsl:otherwise>12pt</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="line-height">155%</xsl:attribute>
			<xsl:apply-templates />
		</xsl:element>
		<xsl:if test="$element-name = 'fo:inline' and not($inline = 'true') and not(local-name(..) = 'admonition')">
			<fo:block margin-bottom="12pt">
				 <xsl:if test="ancestor::csa:annex">
					<xsl:attribute name="margin-bottom">0</xsl:attribute>
				 </xsl:if>
				<xsl:value-of select="$linebreak"/>
			</fo:block>
		</xsl:if>
		<xsl:if test="$inline = 'true'">
			<fo:block>&#xA0;</fo:block>
		</xsl:if>
	</xsl:template>
	
	<!--
	<fn reference="1">
			<p id="_8e5cf917-f75a-4a49-b0aa-1714cb6cf954">Formerly denoted as 15 % (m/m).</p>
		</fn>
	-->
	<xsl:template match="csa:title/csa:fn | csa:p/csa:fn[not(ancestor::csa:table)]" priority="2">
		<fo:footnote keep-with-previous.within-line="always">
			<xsl:variable name="number" select="@reference"/>
			
			<fo:inline font-size="65%" keep-with-previous.within-line="always" vertical-align="super">
				<fo:basic-link internal-destination="footnote_{@reference}" fox:alt-text="footnote {@reference}">
					<xsl:value-of select="$number"/><!--  + count(//csa:bibitem/csa:note) -->
				</fo:basic-link>
			</fo:inline>
			<fo:footnote-body>
				<fo:block font-family="AzoSans-Light" font-size="10pt" margin-bottom="12pt" font-weight="normal" text-indent="0" start-indent="0" color="rgb(168, 170, 173)" text-align="left">
					<fo:inline id="footnote_{@reference}" keep-with-next.within-line="always" font-size="60%" vertical-align="super">
						<xsl:value-of select="$number "/><!-- + count(//csa:bibitem/csa:note) -->
					</fo:inline>
					<xsl:for-each select="csa:p">
							<xsl:apply-templates />
					</xsl:for-each>
				</fo:block>
			</fo:footnote-body>
		</fo:footnote>
	</xsl:template>

	<xsl:template match="csa:fn/csa:p">
		<fo:block>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="csa:review">
		<!-- comment 2019-11-29 -->
		<!-- <fo:block font-weight="bold">Review:</fo:block>
		<xsl:apply-templates /> -->
	</xsl:template>

	<xsl:template match="text()">
		<xsl:value-of select="."/>
	</xsl:template>
	

	<xsl:template match="csa:image"> <!-- only for without outer figure -->
		<fo:block margin-top="12pt" margin-bottom="6pt">
			<fo:external-graphic src="{@src}" width="100%" content-height="scale-to-fit" scaling="uniform" fox:alt-text="Image {@alt}"/> <!-- content-width="75%"  -->
		</fo:block>
	</xsl:template>

	<xsl:template match="csa:figure">
		<xsl:variable name="title">
			<xsl:text>Figure </xsl:text>
		</xsl:variable>
		
		<fo:block-container id="{@id}">
			<fo:block>
				<xsl:apply-templates />
			</fo:block>
			<xsl:call-template name="fn_display_figure"/>
			<xsl:for-each select="csa:note//csa:p">
				<xsl:call-template name="note"/>
			</xsl:for-each>
			<fo:block font-size="11pt" font-weight="bold" text-align="center" margin-top="12pt" margin-bottom="6pt" keep-with-previous="always">
				
				<xsl:choose>
					<xsl:when test="ancestor::csa:annex">
						<xsl:choose>
							<xsl:when test="local-name(..) = 'figure'">
								<xsl:number format="a) "/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$title"/><xsl:number format="A.1-1" level="multiple" count="csa:annex | csa:figure"/>
							</xsl:otherwise>
						</xsl:choose>
						
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$title"/><xsl:number format="1" level="any" count="csa:sourcecode[not(@unnumbered='true') and not(ancestor::csa:example)] | csa:figure"/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:if test="csa:name">
					<xsl:if test="not(local-name(..) = 'figure')">
						<xsl:text> — </xsl:text>
					</xsl:if>
					<xsl:value-of select="csa:name"/>
				</xsl:if>
			</fo:block>
		</fo:block-container>
	</xsl:template>
	
	<xsl:template match="csa:figure/csa:name"/>
	<xsl:template match="csa:figure/csa:fn"/>
	<xsl:template match="csa:figure/csa:note"/>
	
	
	<xsl:template match="csa:figure/csa:image">
		<fo:block text-align="center">
			<fo:external-graphic src="{@src}" width="100%" content-height="scale-to-fit" scaling="uniform" fox:alt-text="Image {@alt}"/> <!-- content-width="75%"  -->
		</fo:block>
	</xsl:template>
	
	
	<xsl:template match="csa:bibitem">
		<fo:block id="{@id}" margin-bottom="12pt" start-indent="12mm" text-indent="-12mm" line-height="145%">
			<xsl:if test=".//csa:fn">
				<xsl:attribute name="line-height-shift-adjustment">disregard-shifts</xsl:attribute>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="csa:formattedref">
					<xsl:apply-templates select="csa:formattedref"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:for-each select="csa:contributor[csa:role/@type='publisher']/csa:organization/csa:name">
						<xsl:apply-templates />
						<xsl:if test="position() != last()">, </xsl:if>
						<xsl:if test="position() = last()">: </xsl:if>
					</xsl:for-each>
						<!-- csa:docidentifier -->
					<xsl:if test="csa:docidentifier">
						<xsl:value-of select="csa:docidentifier/@type"/><xsl:text> </xsl:text>
						<xsl:value-of select="csa:docidentifier"/>
					</xsl:if>
					<xsl:apply-templates select="csa:note"/>
					<xsl:if test="csa:docidentifier">, </xsl:if>
					<fo:inline font-style="italic">
						<xsl:choose>
							<xsl:when test="csa:title[@type = 'main' and @language = 'en']">
								<xsl:value-of select="csa:title[@type = 'main' and @language = 'en']"/><xsl:text>. </xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="csa:title"/><xsl:text>. </xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</fo:inline>
					<xsl:for-each select="csa:contributor[csa:role/@type='publisher']/csa:organization/csa:name">
						<xsl:apply-templates />
						<xsl:if test="position() != last()">, </xsl:if>
					</xsl:for-each>
					<xsl:if test="csa:date[@type='published']/csa:on">
						<xsl:text>(</xsl:text><xsl:value-of select="csa:date[@type='published']/csa:on"/><xsl:text>)</xsl:text>
					</xsl:if>
			</xsl:otherwise>
			</xsl:choose>
		</fo:block>
	</xsl:template>
	
	
	<xsl:template match="csa:bibitem/csa:note">
		<fo:footnote>
			<xsl:variable name="number">
				<xsl:choose>
					<xsl:when test="ancestor::csa:references[preceding-sibling::csa:references]">
						<xsl:number level="any" count="csa:references[preceding-sibling::csa:references]//csa:bibitem/csa:note"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:number level="any" count="csa:bibitem/csa:note"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<fo:inline font-size="65%" keep-with-previous.within-line="always" vertical-align="super"> <!--  60% baseline-shift="35%"   -->
				<fo:basic-link internal-destination="{generate-id()}" fox:alt-text="footnote {$number}">
					<xsl:value-of select="$number"/><!-- <xsl:text>)</xsl:text> -->
				</fo:basic-link>
			</fo:inline>
			<fo:footnote-body>
				<fo:block font-family="AzoSans-Light" font-size="10pt" margin-bottom="12pt" start-indent="0pt" color="rgb(168, 170, 173)">
					<fo:inline id="{generate-id()}" keep-with-next.within-line="always" font-size="60%" vertical-align="super"><!-- baseline-shift="30%" padding-right="9mm"  alignment-baseline="hanging" -->
						<xsl:value-of select="$number"/><!-- <xsl:text>)</xsl:text> -->
					</fo:inline>
					<xsl:apply-templates />
				</fo:block>
			</fo:footnote-body>
		</fo:footnote>
	</xsl:template>
	
	
	
	<xsl:template match="csa:ul | csa:ol">
		<xsl:choose>
			<xsl:when test="not(ancestor::csa:ul) and not(ancestor::csa:ol)">
				<fo:block-container border-left="0.75mm solid {$color-header-document}" margin-left="1mm" margin-bottom="12pt">
					<fo:block-container margin-left="8mm">
						<fo:block margin-left="-8mm" padding-top="6pt">
							<xsl:call-template name="listProcessing"/>
						</fo:block>
					</fo:block-container>
				</fo:block-container>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="listProcessing"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="listProcessing">
		<fo:list-block provisional-distance-between-starts="6.5mm" line-height="145%">
			<xsl:if test="ancestor::csa:ul | ancestor::csa:ol">
				<!-- <xsl:attribute name="margin-bottom">0pt</xsl:attribute> -->
			</xsl:if>
			<xsl:if test="following-sibling::*[1][local-name() = 'ul' or local-name() = 'ol']">
				<!-- <xsl:attribute name="margin-bottom">0pt</xsl:attribute> -->
			</xsl:if>
			<xsl:apply-templates />
		</fo:list-block>
	</xsl:template>
	
	<xsl:template match="csa:li">
		<fo:list-item>
			<fo:list-item-label end-indent="label-end()">
				<fo:block>
					<xsl:choose>
						<xsl:when test="local-name(..) = 'ul' and (../ancestor::csa:ul or ../ancestor::csa:ol)">-</xsl:when> <!-- &#x2014; dash -->
						<xsl:when test="local-name(..) = 'ul'">•</xsl:when> <!-- &#x2014; dash -->
						<xsl:otherwise> <!-- for ordered lists -->
							<xsl:choose>
								<xsl:when test="../@type = 'arabic'">
									<xsl:number format="a)"/>
								</xsl:when>
								<xsl:when test="../@type = 'alphabet'">
									<xsl:number format="1)"/>
								</xsl:when>
								<xsl:when test="../@type = 'alphabet_upper'">
									<xsl:number format="A)"/>
								</xsl:when>
								
								<xsl:when test="../@type = 'roman'">
									<xsl:number format="i)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:number format="1)"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</fo:block>
			</fo:list-item-label>
			<fo:list-item-body start-indent="body-start()" line-height-shift-adjustment="disregard-shifts">
				<xsl:apply-templates />
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>
	
	<xsl:template match="csa:ul/csa:note | csa:ol/csa:note">
		<fo:list-item font-size="10pt">
			<fo:list-item-label><fo:block></fo:block></fo:list-item-label>
			<fo:list-item-body>
				<xsl:apply-templates />
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>

	<xsl:template match="csa:term">
		<xsl:param name="sectionNum"/>
		<fo:wrapper id="{@id}">
			<xsl:apply-templates>
				<xsl:with-param name="sectionNum" select="$sectionNum"/>
			</xsl:apply-templates>
		</fo:wrapper>
	</xsl:template>
	
	<xsl:template match="csa:preferred">
		<xsl:param name="sectionNum"/>
		<xsl:variable name="section">
			<xsl:call-template name="getSection">
				<xsl:with-param name="sectionNum" select="$sectionNum"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		<xsl:variable name="font-size">
			<xsl:choose>
				<xsl:when test="$level &gt;= 2">11pt</xsl:when>
				<xsl:otherwise>12pt</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<fo:block font-size="{$font-size}">
			<fo:block font-weight="bold" keep-with-next="always">
				<fo:inline>
					<xsl:value-of select="$section"/><xsl:text>.</xsl:text>
				</fo:inline>
			</fo:block>
			<fo:block font-weight="bold" keep-with-next="always" line-height="1">
				<xsl:apply-templates />
			</fo:block>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="csa:admitted">
		<fo:block font-size="11pt">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="csa:deprecates">
		<fo:block>DEPRECATED: <xsl:apply-templates /></fo:block>
	</xsl:template>
	
	<xsl:template match="csa:definition[preceding-sibling::csa:domain]">
		<xsl:apply-templates />
	</xsl:template>
	<xsl:template match="csa:definition[preceding-sibling::csa:domain]/csa:p">
		<fo:inline> <xsl:apply-templates /></fo:inline>
		<fo:block>&#xA0;</fo:block>
	</xsl:template>
	
	<xsl:template match="csa:definition">
		<fo:block space-after="6pt">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="csa:termsource">
		<fo:block margin-bottom="12pt" keep-with-previous="always">
			<!-- Example: [SOURCE: ISO 5127:2017, 3.1.6.02] -->
			<fo:basic-link internal-destination="{csa:origin/@bibitemid}" fox:alt-text="{csa:origin/@citeas}">
				<xsl:text>[SOURCE: </xsl:text>
				<fo:inline text-decoration="underline" color="{$color-link}">
					<xsl:value-of select="csa:origin/@citeas"/>
          
					<xsl:apply-templates select="csa:origin/csa:localityStack"/>
					
				</fo:inline>
			</fo:basic-link>
			<xsl:apply-templates select="csa:modification"/>
			<xsl:text>]</xsl:text>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="csa:modification">
		<xsl:text>, modified — </xsl:text>
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="csa:modification/csa:p">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template>
	
	<xsl:template match="csa:termnote">
		<fo:block font-size="10pt" margin-bottom="12pt">
			<xsl:text>Note </xsl:text>
			<xsl:number />
			<xsl:text> to entry: </xsl:text>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="csa:termnote/csa:p">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template>
	
	<xsl:template match="csa:domain">
		<fo:inline>&lt;<xsl:apply-templates/>&gt;</fo:inline>
	</xsl:template>
	
	
	<xsl:template match="csa:termexample">
		<fo:block font-size="10pt" margin-bottom="12pt">
			<fo:inline padding-right="10mm">EXAMPLE</fo:inline>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="csa:termexample/csa:p">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template>

	
	<xsl:template match="csa:annex">
		<fo:block break-after="page"/>
		<xsl:apply-templates />
	</xsl:template>

	
	<!-- [position() &gt; 1] -->
	<xsl:template match="csa:references[@id != '_normative_references' and @id != '_references']">
		<fo:block break-after="page"/>
		<fo:block line-height="145%">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>


	<!-- Example: [1] ISO 9:1995, Information and documentation – Transliteration of Cyrillic characters into Latin characters – Slavic and non-Slavic languages -->
	<!-- <xsl:template match="csa:references[@id = '_bibliography']/csa:bibitem"> [position() &gt; 1] -->
	<xsl:template match="csa:references[@id != '_normative_references' and @id != '_references']/csa:bibitem">
		<fo:block margin-bottom="12pt" line-height="145%">
			<fo:inline id="{@id}">
				<xsl:number format="[1]"/>
			</fo:inline>
				
			<xsl:if test="not(csa:formattedref)">
				<xsl:choose>
					<xsl:when test="csa:contributor[csa:role/@type='publisher']/csa:organization/csa:abbreviation">
						<xsl:for-each select="csa:contributor[csa:role/@type='publisher']/csa:organization/csa:abbreviation">
							<xsl:value-of select="."/>
							<xsl:if test="position() != last()">/</xsl:if>
						</xsl:for-each>
						<xsl:text>: </xsl:text>
					</xsl:when>
					<xsl:when test="csa:contributor[csa:role/@type='publisher']/csa:organization/csa:name">
						<xsl:value-of select="csa:contributor[csa:role/@type='publisher']/csa:organization/csa:name"/>
						<xsl:text>: </xsl:text>
					</xsl:when>
				</xsl:choose>
				
			</xsl:if>
			
			<xsl:if test="csa:docidentifier">
				<xsl:choose>
					<xsl:when test="csa:docidentifier/@type = 'ISO' and csa:formattedref"/>
					<xsl:when test="csa:docidentifier/@type = 'OGC' and csa:formattedref"/>
					<xsl:otherwise><fo:inline>
						<xsl:if test="csa:docidentifier/@type = 'OGC'">OGC </xsl:if>
						<xsl:value-of select="csa:docidentifier"/><xsl:apply-templates select="csa:note"/>, </fo:inline></xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			
			<xsl:choose>
				<xsl:when test="csa:title[@type = 'main' and @language = 'en']">
					<xsl:apply-templates select="csa:title[@type = 'main' and @language = 'en']"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="csa:title"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="csa:contributor[csa:role/@type='publisher']/csa:organization/csa:name">
				<xsl:text>, </xsl:text>
				<xsl:for-each select="csa:contributor[csa:role/@type='publisher']/csa:organization/csa:name">
					<xsl:if test="position() != last()">and </xsl:if>
					<xsl:value-of select="."/>
				</xsl:for-each>
				
			</xsl:if>
			<xsl:if test="csa:place">
				<xsl:text>, </xsl:text>
				<xsl:value-of select="csa:place"/>
			</xsl:if>
			<xsl:if test="csa:date[@type='published']/csa:on">
				<xsl:text> (</xsl:text><xsl:value-of select="csa:date[@type='published']/csa:on"/><xsl:text>).</xsl:text>
			</xsl:if>
			<xsl:apply-templates select="csa:formattedref"/>
					
			
		</fo:block>
	</xsl:template>
	
	<!-- <xsl:template match="csa:references[@id = '_bibliography']/csa:bibitem" mode="contents"/> [position() &gt; 1] -->
	<xsl:template match="csa:references[@id != '_normative_references' and @id != '_references']/csa:bibitem" mode="contents"/>
	
	<!-- <xsl:template match="csa:references[@id = '_bibliography']/csa:bibitem/csa:title"> [position() &gt; 1]-->
	<xsl:template match="csa:references[@id != '_normative_references' and  @id != '_references']/csa:bibitem/csa:title">
		<fo:inline font-style="italic">
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>

	<xsl:template match="csa:quote">
		<fo:block margin-top="12pt" margin-left="13mm" margin-right="12mm">
			<xsl:apply-templates select=".//csa:p"/>
		</fo:block>
		<xsl:if test="csa:author or csa:source">
			<fo:block text-align="right" margin-right="25mm">
				<!-- — ISO, ISO 7301:2011, Clause 1 -->
				<xsl:if test="csa:author">
					<xsl:text>— </xsl:text><xsl:value-of select="csa:author"/>
				</xsl:if>
				<xsl:if test="csa:source">
					<xsl:text>, </xsl:text>
					<xsl:apply-templates select="csa:source"/>
				</xsl:if>
			</fo:block>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="csa:source">
		<fo:basic-link internal-destination="{@bibitemid}" fox:alt-text="{@citeas}">
			<xsl:value-of select="@citeas" disable-output-escaping="yes"/>
			<xsl:apply-templates select="csa:localityStack"/>
		</fo:basic-link>
	</xsl:template>
		
	
	<xsl:template match="csa:xref">
		<fo:basic-link internal-destination="{@target}" fox:alt-text="{@target}">
			<xsl:variable name="section" select="xalan:nodeset($contents)//item[@id = current()/@target]/@section"/>
			<!-- <xsl:if test="not(starts-with($section, 'Figure') or starts-with($section, 'Table'))"> -->
				<!-- <xsl:attribute name="color">blue</xsl:attribute> -->
				<xsl:attribute name="text-decoration">underline</xsl:attribute>
			<!-- </xsl:if> -->
			<xsl:variable name="type" select="xalan:nodeset($contents)//item[@id = current()/@target]/@type"/>
			<xsl:variable name="root" select="xalan:nodeset($contents)//item[@id = current()/@target]/@root"/>
			
			<xsl:choose>
				<xsl:when test="normalize-space(.) != ''">
					<xsl:apply-templates/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="$type = 'clause' and $root != 'annex'">Clause </xsl:when><!-- and not (ancestor::annex) -->
						<xsl:when test="$type = 'term' and ($root = 'clause' or $root = 'terms')">Clause </xsl:when>
						<xsl:when test="$type = 'clause' and $root = 'annex'">Annex </xsl:when>
						<xsl:otherwise></xsl:otherwise> <!-- <xsl:value-of select="$type"/> -->
					</xsl:choose>
					<xsl:value-of select="$section"/>
				</xsl:otherwise>
			</xsl:choose>
      </fo:basic-link>
	</xsl:template>

	<xsl:template match="csa:sourcecode" priority="2">
		<xsl:call-template name="sourcecode"/>		
		<xsl:choose>
			<xsl:when test="@unnumbered='true'"></xsl:when>
			<xsl:when test="ancestor::csa:example"/>
			<xsl:when test="ancestor::csa:td"/>
			<xsl:when test="ancestor::csa:annex">
				<xsl:variable name="id_annex" select="ancestor::csa:annex/@id"/>
				<xsl:choose>
					<xsl:when test="count(//csa:annex) = 1">
						<xsl:value-of select="/csa:nist-standard/csa:bibdata/csa:ext/csa:structuredidentifier/csa:annexid"/><xsl:number format="-1" level="any" count="csa:annex//csa:sourcecode"/>
					</xsl:when>
					<xsl:otherwise>
						<fo:block font-size="11pt" font-weight="bold" text-align="center" margin-bottom="12pt">
							<xsl:text>Figure </xsl:text>
							<xsl:number format="A." level="multiple" count="csa:annex"/>
							<xsl:number format="1" level="any" count="csa:sourcecode[ancestor::csa:annex/@id = $id_annex and not(@unnumbered='true') and not(ancestor::csa:example)]"/>
							<xsl:if test="csa:name">
								<xsl:text> — </xsl:text>
								<xsl:apply-templates select="csa:name/*"/>
							</xsl:if>
						</fo:block>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<fo:block font-size="11pt" font-weight="bold" text-align="center" margin-bottom="12pt">
					<xsl:text>Figure </xsl:text>
					<xsl:number format="1" level="any" count="csa:sourcecode[not(@unnumbered='true') and not(ancestor::csa:example)] | csa:figure"/>
					<xsl:if test="csa:name">
						<xsl:text> — </xsl:text>
						<xsl:apply-templates select="csa:name/*"/>
					</xsl:if>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="csa:sourcecode/text()">
		<xsl:variable name="text">
			<xsl:call-template name="add-zero-spaces-equal"/>
		</xsl:variable>
		<xsl:call-template name="add-zero-spaces">
			<xsl:with-param name="text" select="$text"/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="csa:sourcecode/csa:name"/>
	
	<xsl:template match="csa:tt" priority="2">
		<fo:inline font-family="SourceCodePro" font-size="10pt">
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="csa:example">
		<fo:block font-size="10pt" margin-top="12pt" margin-bottom="12pt" font-weight="bold" keep-with-next="always">
			<xsl:text>EXAMPLE</xsl:text>
			<xsl:if test="following-sibling::csa:example or preceding-sibling::csa:example">
				<xsl:number format=" 1"/>
			</xsl:if>
			<xsl:if test="csa:name">
				<xsl:text> — </xsl:text>
				<xsl:apply-templates select="csa:name/node()"/>
			</xsl:if>
		</fo:block>
		<fo:block  font-size="10pt" margin-left="12.5mm" margin-right="12.5mm">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="csa:example/csa:name"/>
	
	<xsl:template match="csa:example/csa:p">
		<fo:block  margin-bottom="14pt">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	
	<xsl:template match="csa:note/csa:p" name="note">
		<fo:block font-size="10pt" margin-top="12pt" margin-bottom="12pt" line-height="115%">
			<xsl:if test="ancestor::csa:ul or ancestor::csa:ol and not(ancestor::csa:note[1]/following-sibling::*)">
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			</xsl:if>
			<xsl:variable name="clauseid" select="ancestor::csa:clause[1]/@id"/>
			<fo:inline padding-right="4mm">
				<xsl:text>NOTE </xsl:text>
				<xsl:if test="count(//csa:note[ancestor::csa:clause[1][@id = $clauseid]]) &gt; 1">
					<xsl:number count="csa:note[ancestor::csa:clause[1][@id = $clauseid]]" level="any"/>
				</xsl:if>
			</fo:inline>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>

	<!-- <eref type="inline" bibitemid="ISO20483" citeas="ISO 20483:2013"><locality type="annex"><referenceFrom>C</referenceFrom></locality></eref> -->
	<xsl:template match="csa:eref">
		<fo:basic-link internal-destination="{@bibitemid}" fox:alt-text="{@citeas}" text-decoration="underline" color="{$color-link}"> <!-- font-size="9pt" color="blue" vertical-align="super" -->
			<xsl:if test="@type = 'footnote'">
				<xsl:attribute name="keep-together.within-line">always</xsl:attribute>
				<xsl:attribute name="font-size">80%</xsl:attribute>
				<xsl:attribute name="keep-with-previous.within-line">always</xsl:attribute>
				<xsl:attribute name="vertical-align">super</xsl:attribute>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="@citeas and normalize-space(text()) = ''">
					<xsl:value-of select="@citeas" disable-output-escaping="yes"/>
				</xsl:when>
				<xsl:when test="@bibitemid and normalize-space(text()) = ''">
					<xsl:value-of select="//csa:bibitem[@id = current()/@bibitemid]/csa:docidentifier"/>
				</xsl:when>
				<xsl:otherwise></xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates select="csa:localityStack"/>
			<xsl:apply-templates select="text()"/>
		</fo:basic-link>
	</xsl:template>
	
	<xsl:template match="csa:locality">
		<xsl:choose>
			<xsl:when test="@type ='clause'">Clause </xsl:when>
			<xsl:when test="@type ='annex'">Annex </xsl:when>
			<xsl:otherwise><xsl:value-of select="@type"/></xsl:otherwise>
		</xsl:choose>
		<xsl:text> </xsl:text><xsl:value-of select="csa:referenceFrom"/>
	</xsl:template>
	
	<xsl:template match="csa:admonition">
		<fo:block-container border="0.5pt solid rgb(79, 129, 189)" color="rgb(79, 129, 189)" margin-left="16mm" margin-right="16mm" margin-bottom="12pt">
			<fo:block-container margin-left="0mm" margin-right="0mm" padding="2mm" padding-top="3mm">
				<fo:block font-size="11pt" margin-bottom="6pt" font-weight="bold" font-style="italic" text-align="center">
					<xsl:value-of select="translate(@type, $lower, $upper)"/>
				</fo:block>
				<fo:block font-style="italic">
					<xsl:apply-templates />
				</fo:block>
			</fo:block-container>
		</fo:block-container>
		
		
	</xsl:template>
	
	<xsl:template match="csa:formula">
		<fo:wrapper id="{@id}">
			<xsl:apply-templates />
		</fo:wrapper>
	</xsl:template>
	
	<xsl:template match="csa:formula/csa:dt/csa:stem">
		<fo:inline>
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="csa:formula/csa:stem">
		<fo:block margin-top="6pt" margin-bottom="12pt">
			<fo:table table-layout="fixed" width="100%">
				<fo:table-column column-width="95%"/>
				<fo:table-column column-width="5%"/>
				<fo:table-body>
					<fo:table-row>
						<fo:table-cell display-align="center">
							<fo:block text-align="left" margin-left="5mm">
								<xsl:apply-templates />
							</fo:block>
						</fo:table-cell>
						<fo:table-cell display-align="center">
							<fo:block text-align="right">
								<xsl:choose>
									<xsl:when test="ancestor::csa:annex">
										<xsl:text>(</xsl:text><xsl:number format="A.1" level="multiple" count="csa:annex | csa:formula"/><xsl:text>)</xsl:text>
									</xsl:when>
									<xsl:otherwise> <!-- not(ancestor::csa:annex) -->
										<!-- <xsl:text>(</xsl:text><xsl:number level="any" count="csa:formula"/><xsl:text>)</xsl:text> -->
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
	
	
	<xsl:template match="csa:br" priority="2">
		<!-- <fo:block>&#xA0;</fo:block> -->
		<xsl:value-of select="$linebreak"/>
	</xsl:template>
	
	<xsl:template match="csa:pagebreak">
		<fo:block break-after="page"/>
		<fo:block>&#xA0;</fo:block>
		<fo:block break-after="page"/>
	</xsl:template>
		
	<xsl:template name="insertHeaderFooter">
		<fo:static-content flow-name="header">
			<fo:block-container height="2.5mm" background-color="{$color-header-document}">
				<fo:block font-size="1pt">&#xA0;</fo:block>
			</fo:block-container>
		</fo:static-content>
		<fo:static-content flow-name="footer">
			<fo:block-container font-family="AzoSans-Light" font-size="10.1pt" height="100%" display-align="after"> <!-- 11.5pt -->
				<fo:block padding-bottom="13mm" text-align="right" color="rgb(144, 144, 144)">
					<fo:inline padding-right="7mm"><xsl:value-of select="$copyright" /></fo:inline>
					<fo:page-number/>
				</fo:block>
			</fo:block-container>
		</fo:static-content>
	</xsl:template>


	<xsl:template name="getSection">
		<xsl:param name="sectionNum"/>
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		<xsl:variable name="section">
			<xsl:choose>
				<xsl:when test="ancestor::csa:bibliography">
					<xsl:value-of select="$sectionNum"/>
				</xsl:when>
				<xsl:when test="ancestor::csa:sections">
					<!-- 1, 2, 3, 4, ... from main section (not annex, bibliography, ...) -->
					<xsl:choose>
						<xsl:when test="$level = 1">
							<xsl:value-of select="$sectionNum"/>
						</xsl:when>
						<xsl:when test="$level &gt;= 2">
							<xsl:variable name="num">
								<xsl:call-template name="getSubSection"/>								
							</xsl:variable>
							<xsl:value-of select="concat($sectionNum, $num)"/>
						</xsl:when>
						<xsl:otherwise>
							<!-- z<xsl:value-of select="$sectionNum"/>z -->
						</xsl:otherwise>
					</xsl:choose>
					<!-- <xsl:text>.</xsl:text> -->
				</xsl:when>
				<!-- <xsl:when test="ancestor::csa:annex[@obligation = 'informative']">
					<xsl:choose>
						<xsl:when test="$level = 1">
							<xsl:text>Annex  </xsl:text>
							<xsl:number format="I" level="any" count="csa:annex[@obligation = 'informative']"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:number format="I.1" level="multiple" count="csa:annex[@obligation = 'informative'] | csa:clause"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when> -->
				<xsl:when test="ancestor::csa:annex">
					<xsl:choose>
						<xsl:when test="$level = 1">
							<xsl:text>Annex </xsl:text>
							<xsl:choose>
								<xsl:when test="count(//csa:annex) = 1">
									<xsl:value-of select="/csa:csa-standard/csa:bibdata/csa:ext/csa:structuredidentifier/csa:annexid"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:number format="A" level="any" count="csa:annex"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="count(//csa:annex) = 1">
									<xsl:value-of select="/csa:csa-standard/csa:bibdata/csa:ext/csa:structuredidentifier/csa:annexid"/><xsl:number format=".1" level="multiple" count="csa:clause"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:number format="A.1" level="multiple" count="csa:annex | csa:clause"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="ancestor::csa:preface"> <!-- if preface and there is clause(s) -->
					<xsl:choose>
						<xsl:when test="$level = 1 and  ..//csa:clause">0</xsl:when>
						<xsl:when test="$level &gt;= 2">
							<xsl:variable name="num">
								<xsl:number format=".1" level="multiple" count="csa:clause"/>
							</xsl:variable>
							<xsl:value-of select="concat('0', $num)"/>
						</xsl:when>
						<xsl:otherwise>
							<!-- z<xsl:value-of select="$sectionNum"/>z -->
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$section"/>
	</xsl:template>

	<xsl:variable name="Image-Logo">
		<xsl:text>iVBORw0KGgoAAAANSUhEUgAAA+AAAAFsCAYAAABMytP3AAAAGXRFWHRTb2Z0d2FyZQBBZG9i
ZSBJbWFnZVJlYWR5ccllPAAAA3BpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tl
dCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1l
dGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUu
Ni1jMDE0IDc5LjE1Njc5NywgMjAxNC8wOC8yMC0wOTo1MzowMiAgICAgICAgIj4gPHJkZjpS
REYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgt
bnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6
Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRv
YmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9u
cy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRp
ZDplYWRhN2RlNC04YzAyLTQ1N2UtYjUwNy0zNGYzY2RjNWE2ZGQiIHhtcE1NOkRvY3VtZW50
SUQ9InhtcC5kaWQ6NkU5NEE5NUY3NjVBMTFFQUFGNTc5RUZEMzQzODM4QzgiIHhtcE1NOklu
c3RhbmNlSUQ9InhtcC5paWQ6NkU5NEE5NUU3NjVBMTFFQUFGNTc5RUZEMzQzODM4QzgiIHht
cDpDcmVhdG9yVG9vbD0iQWRvYmUgSW5EZXNpZ24gMTQuMCAoTWFjaW50b3NoKSI+IDx4bXBN
TTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ1dWlkOmQ1MDMzN2Q0LTBkZmItYzI0
MS1iZTY2LWI3M2VlMWI2NWE4MyIgc3RSZWY6ZG9jdW1lbnRJRD0ieG1wLmlkOmJhMmE0NmVk
LTFmMjUtNDExNS1hOTkzLWJkN2Q0YmY4MDBlMSIvPiA8L3JkZjpEZXNjcmlwdGlvbj4gPC9y
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
JP5/AQYA3Lt5kGz07MoAAAAASUVORK5CYII=
		</xsl:text>
	</xsl:variable>
	
	<xsl:variable name="Title-Image">
		<xsl:text>iVBORw0KGgoAAAANSUhEUgAAASEAAAEhCAYAAAAwHRYbAAAAGXRFWHRTb2Z0d2FyZQBBZG9i
			ZSBJbWFnZVJlYWR5ccllPAAAA3BpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tl
			dCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1l
			dGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUu
			Ni1jMDE0IDc5LjE1Njc5NywgMjAxNC8wOC8yMC0wOTo1MzowMiAgICAgICAgIj4gPHJkZjpS
			REYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgt
			bnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6
			Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRv
			YmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9u
			cy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRp
			ZDplYWRhN2RlNC04YzAyLTQ1N2UtYjUwNy0zNGYzY2RjNWE2ZGQiIHhtcE1NOkRvY3VtZW50
			SUQ9InhtcC5kaWQ6MDUyNzBENDc3NjVCMTFFQTlDMDhGMEI2ODhENjUxQkIiIHhtcE1NOklu
			c3RhbmNlSUQ9InhtcC5paWQ6MDUyNzBENDY3NjVCMTFFQTlDMDhGMEI2ODhENjUxQkIiIHht
			cDpDcmVhdG9yVG9vbD0iQWRvYmUgSW5EZXNpZ24gMTQuMCAoTWFjaW50b3NoKSI+IDx4bXBN
			TTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ1dWlkOmZiZjFiODZmLTIzMjMtM2U0
			OS1hMDMzLTVlOGQxYThlNmI1YiIgc3RSZWY6ZG9jdW1lbnRJRD0ieG1wLmlkOjFlMzVjZTE3
			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
			AElFTkSuQmCC
		</xsl:text>
	</xsl:variable>
	
</xsl:stylesheet>
