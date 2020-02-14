<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:iec="https://www.metanorma.com/ns/iec" xmlns:mathml="http://www.w3.org/1998/Math/MathML" xmlns:xalan="http://xml.apache.org/xalan" xmlns:fox="http://xmlgraphics.apache.org/fop/extensions" version="1.0">

	<xsl:output method="xml" encoding="UTF-8" indent="no"/>
	
	<xsl:include href="./common.xsl"/>
	
	<xsl:variable name="namespace">iec</xsl:variable>
	
	<xsl:variable name="pageWidth" select="'210mm'"/>
	<xsl:variable name="pageHeight" select="'297mm'"/>

	<xsl:variable name="copyrightText" select="concat('© ', /iec:iec-standard/iec:bibdata/iec:copyright/iec:owner/iec:organization/iec:abbreviation, ':', iec:iec-standard/iec:bibdata/iec:copyright/iec:from)"/>
  <!-- <xsl:variable name="lang-1st-letter" select="concat('(', translate(substring(iec:iec-standard/iec:bibdata/iec:language,1,1),$lower, $upper), ')')"/> -->
  <xsl:variable name="lang-1st-letter" select="''"/>
	<xsl:variable name="ISOname" select="/iec:iec-standard/iec:bibdata/iec:docidentifier[@type='iso']"/>
	
	<!-- Information and documentation — Codes for transcription systems  -->
	<xsl:variable name="title-en" select="/iec:iec-standard/iec:bibdata/iec:title[@language = 'en' and @type = 'main']"/>
	<xsl:variable name="title-fr" select="/iec:iec-standard/iec:bibdata/iec:title[@language = 'fr' and @type = 'main']"/>

	<xsl:variable name="title-intro" select="/iec:iec-standard/iec:bibdata/iec:title[@language = 'en' and @type = 'title-intro']"/>
	<xsl:variable name="title-main" select="/iec:iec-standard/iec:bibdata/iec:title[@language = 'en' and @type = 'title-main']"/>
	<xsl:variable name="part" select="/iec:iec-standard/iec:bibdata/iec:ext/iec:structuredidentifier/iec:project-number/@part"/>
	
	<xsl:variable name="title-part" select="/iec:iec-standard/iec:bibdata/iec:title[@language = 'en' and @type = 'title-part']"/>
	
	<xsl:variable name="organization" select="translate(/iec:iec-standard/iec:bibdata/iec:contributor/iec:organization/iec:name, $lower, $upper)"/>
	
	
	<!-- Example:
		<item level="1" id="Foreword" display="true">Foreword</item>
		<item id="term-script" display="false">3.2</item>
	-->
	<xsl:variable name="contents">
		<contents>
			<xsl:apply-templates select="/iec:iec-standard/iec:preface/node()" mode="contents"/>
				<!-- <xsl:with-param name="sectionNum" select="'0'"/>
			</xsl:apply-templates> -->
			<xsl:apply-templates select="/iec:iec-standard/iec:sections/iec:clause[1]" mode="contents"> <!-- [@id = '_scope'] -->
				<xsl:with-param name="sectionNum" select="'1'"/>
			</xsl:apply-templates>
			<xsl:apply-templates select="/iec:iec-standard/iec:bibliography/iec:references[1]" mode="contents"> <!-- [@id = '_normative_references'] -->
				<xsl:with-param name="sectionNum" select="'2'"/>
			</xsl:apply-templates>
			<xsl:apply-templates select="/iec:iec-standard/iec:sections/*[position() &gt; 1]" mode="contents"> <!-- @id != '_scope' -->
				<xsl:with-param name="sectionNumSkew" select="'1'"/>
			</xsl:apply-templates>
			<xsl:apply-templates select="/iec:iec-standard/iec:annex" mode="contents"/>
			<xsl:apply-templates select="/iec:iec-standard/iec:bibliography/iec:references[position() &gt; 1]" mode="contents"/> <!-- @id = '_bibliography' -->
			
		</contents>
	</xsl:variable>
	
	<xsl:variable name="lang">
		<xsl:call-template name="getLang"/>
	</xsl:variable>	
	
	<xsl:template match="/">
		<!-- https://stackoverflow.com/questions/25261949/xsl-fo-letter-spacing-with-text-align -->
		<!-- https://xmlgraphics.apache.org/fop/knownissues.html -->
		<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format" font-family="Arial, Times New Roman, Cambria Math, HanSans" font-size="10pt" xml:lang="{$lang}">
			<fo:layout-master-set>
				<!-- odd pages -->
				<fo:simple-page-master master-name="odd" page-width="{$pageWidth}" page-height="{$pageHeight}">
					<fo:region-body margin-top="30mm" margin-bottom="15mm" margin-left="25mm" margin-right="25mm"/>
					<fo:region-before region-name="header-odd" extent="30mm"/> 
					<fo:region-after region-name="footer" extent="15mm"/>
					<fo:region-start region-name="left-region" extent="25mm"/>
					<fo:region-end region-name="right-region" extent="25mm"/>
				</fo:simple-page-master>
				<!-- even pages -->
				<fo:simple-page-master master-name="even" page-width="{$pageWidth}" page-height="{$pageHeight}">
					<fo:region-body margin-top="30mm" margin-bottom="15mm" margin-left="25mm" margin-right="25mm"/>
					<fo:region-before region-name="header-even" extent="30mm"/>
					<fo:region-after region-name="footer" extent="15mm"/>
					<fo:region-start region-name="left-region" extent="25mm"/>
					<fo:region-end region-name="right-region" extent="25mm"/>
				</fo:simple-page-master>
				<fo:page-sequence-master master-name="document">
					<fo:repeatable-page-master-alternatives>
						<fo:conditional-page-master-reference odd-or-even="even" master-reference="even"/>
						<fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd"/>
					</fo:repeatable-page-master-alternatives>
				</fo:page-sequence-master>
			</fo:layout-master-set>

			<fo:declarations>
				<pdf:catalog xmlns:pdf="http://xmlgraphics.apache.org/fop/extensions/pdf">
						<pdf:dictionary type="normal" key="ViewerPreferences">
							<pdf:boolean key="DisplayDocTitle">true</pdf:boolean>
						</pdf:dictionary>
					</pdf:catalog>
				<x:xmpmeta xmlns:x="adobe:ns:meta/">
					<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
						<rdf:Description rdf:about="" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:pdf="http://ns.adobe.com/pdf/1.3/">
						<!-- Dublin Core properties go here -->
							<dc:title><xsl:value-of select="$title-en"/></dc:title>
							<dc:creator></dc:creator>
							<dc:description>
								<xsl:variable name="abstract">
									<xsl:copy-of select="/iec:iec-standard/iec:bibliography/iec:references/iec:bibitem/iec:abstract[@language = 'en']//text()"/>
								</xsl:variable>
								<xsl:value-of select="normalize-space($abstract)"/>
							</dc:description>
							<pdf:Keywords></pdf:Keywords>
						</rdf:Description>
						<rdf:Description rdf:about=""
								xmlns:xmp="http://ns.adobe.com/xap/1.0/">
							<!-- XMP properties go here -->
							<xmp:CreatorTool></xmp:CreatorTool>
						</rdf:Description>
					</rdf:RDF>
				</x:xmpmeta>
			</fo:declarations>
			
			<fo:page-sequence master-reference="document" format="i" force-page-count="no-force">
				<xsl:call-template name="insertHeaderFooter"/>
				<fo:flow flow-name="xsl-region-body">
					
					<fo:block-container>
						<fo:block font-size="12pt" font-weight="bold" text-align="center" margin-bottom="15pt">Contents</fo:block>
						
						<xsl:text disable-output-escaping="yes">&lt;!--</xsl:text>
							DEBUG
							contents=<xsl:copy-of select="xalan:nodeset($contents)"/>
						<xsl:text disable-output-escaping="yes">--&gt;</xsl:text>
						
						<xsl:variable name="margin-left">5</xsl:variable>
						
						<xsl:for-each select="xalan:nodeset($contents)//item[@display = 'true']
																																													[@level &lt;= 2]
																																													[not(@level = 2 and starts-with(@section, '0'))]"><!-- skip clause from preface -->
							<fo:block text-align-last="justify"> <!-- font-family="Helvetica"  -->
								<xsl:if test="@level = 1">
									<xsl:attribute name="margin-bottom">5pt</xsl:attribute>
								</xsl:if>
								<xsl:if test="@level = 2">
									<xsl:attribute name="margin-bottom">3pt</xsl:attribute>
								</xsl:if>
								<xsl:if test="@level &gt;= 2 and @section != ''">
									<xsl:attribute name="margin-left">5mm</xsl:attribute>
								</xsl:if>
								
								<fo:basic-link internal-destination="{@id}" fox:alt-text="{text()}">
									<xsl:if test="@section != '' and not(@display-section = 'false')"> <!--   -->
										<xsl:value-of select="@section"/><xsl:text> </xsl:text>
									</xsl:if>
									<xsl:if test="@type = 'annex'">
										<fo:inline font-weight="bold"><xsl:value-of select="@section"/></fo:inline>
											<xsl:if test="@addon != ''">
												<fo:inline>(<xsl:value-of select="@addon"/>)</fo:inline>
											</xsl:if>
									</xsl:if>
									<fo:inline>
										<xsl:if test="@type = 'annex'">
											<xsl:attribute name="font-weight">bold</xsl:attribute>
										</xsl:if>
										<xsl:value-of select="text()"/>
									</fo:inline>
									<fo:inline keep-together.within-line="always">
										<fo:leader leader-pattern="dots"/>
										<fo:page-number-citation ref-id="{@id}"/>
									</fo:inline>
								</fo:basic-link>
							</fo:block>
						</xsl:for-each>
						
						<xsl:if test="xalan:nodeset($contents)//item[@type = 'table']">
							<fo:block margin-bottom="5pt">&#xA0;</fo:block>
							<fo:block margin-top="5pt" margin-bottom="10pt">&#xA0;</fo:block>
							<xsl:for-each select="xalan:nodeset($contents)//item[@type = 'table']">
								<fo:block text-align-last="justify" margin-bottom="5pt" margin-left="8mm" text-indent="-8mm">
									<fo:basic-link internal-destination="{@id}"  fox:alt-text="{@section}">
										<xsl:value-of select="@section"/>
										<xsl:if test="text() != ''">
											<xsl:text> — </xsl:text>
											<xsl:value-of select="text()"/>
										</xsl:if>
										<fo:inline keep-together.within-line="always">
											<fo:leader leader-pattern="dots"/>
											<fo:page-number-citation ref-id="{@id}"/>
										</fo:inline>
									</fo:basic-link>
								</fo:block>
							</xsl:for-each>
						</xsl:if>
						
						<xsl:if test="xalan:nodeset($contents)//item[@type = 'figure']">
							<fo:block margin-bottom="5pt">&#xA0;</fo:block>
							<fo:block margin-top="5pt" margin-bottom="10pt">&#xA0;</fo:block>
							<xsl:for-each select="xalan:nodeset($contents)//item[@type = 'figure']">
								<fo:block text-align-last="justify" margin-bottom="5pt" margin-left="8mm" text-indent="-8mm">
									<fo:basic-link internal-destination="{@id}"  fox:alt-text="{@section}">
										<xsl:value-of select="@section"/>
										<xsl:if test="text() != ''">
											<xsl:text> — </xsl:text>
											<xsl:value-of select="text()"/>
										</xsl:if>
										<fo:inline keep-together.within-line="always">
											<fo:leader leader-pattern="dots"/>
											<fo:page-number-citation ref-id="{@id}"/>
										</fo:inline>
									</fo:basic-link>
								</fo:block>
							</xsl:for-each>
						</xsl:if>
					</fo:block-container>
					

					<fo:block break-after="page"/>
					
					<fo:block-container font-size="12pt" text-align="center">
						<fo:block><xsl:value-of select="$organization"/></fo:block>
						<fo:block>____________</fo:block>
						<fo:block>&#xa0;</fo:block>
						<fo:block font-weight="bold">
							<xsl:value-of select="translate($title-intro, $lower, $upper)"/>
							<xsl:text> — </xsl:text>
							<xsl:value-of select="translate($title-main, $lower, $upper)"/>
							<xsl:if test="$part != ''">
								<xsl:text> — </xsl:text>
								<fo:block>&#xa0;</fo:block>
								<fo:block>
									<xsl:text>Part </xsl:text><xsl:value-of select="$part"/>
									<xsl:text>:</xsl:text>
									<xsl:value-of select="$title-part"/>
								</fo:block>
							</xsl:if>
							<fo:block>&#xa0;</fo:block>
						</fo:block>
					</fo:block-container>
					
					<!-- Foreword, Introduction -->
					<xsl:apply-templates select="/iec:iec-standard/iec:preface/*"/>
						
				</fo:flow>
			</fo:page-sequence>
			
			<!-- BODY -->
			<fo:page-sequence master-reference="document" initial-page-number="1" force-page-count="no-force">
				<fo:static-content flow-name="xsl-footnote-separator">
					<fo:block>
						<fo:leader leader-pattern="rule" leader-length="30%"/>
					</fo:block>
				</fo:static-content>
				<xsl:call-template name="insertHeaderFooter"/>
				<fo:flow flow-name="xsl-region-body">
					
					<fo:block-container font-size="12pt" text-align="center">
						<fo:block><xsl:value-of select="$organization"/></fo:block>
						<fo:block>____________</fo:block>
						<fo:block>&#xa0;</fo:block>
						<fo:block font-weight="bold">
							<xsl:value-of select="translate($title-intro, $lower, $upper)"/>
							<xsl:text> — </xsl:text>
							<xsl:value-of select="translate($title-main, $lower, $upper)"/>
							<xsl:if test="$part != ''">
								<xsl:text> — </xsl:text>
								<fo:block>&#xa0;</fo:block>
								<fo:block>
									<xsl:text>Part </xsl:text><xsl:value-of select="$part"/>
									<xsl:text>:</xsl:text>
									<xsl:value-of select="$title-part"/>
								</fo:block>
							</xsl:if>
							<fo:block>&#xa0;</fo:block>
						</fo:block>
					</fo:block-container>
					
					<!-- Clause(s) -->
					<fo:block>
					
						<!-- Scope -->
						<xsl:apply-templates select="/iec:iec-standard/iec:sections/iec:clause[1]">
							<xsl:with-param name="sectionNum" select="'1'"/>
						</xsl:apply-templates>

						 <!-- Normative references  -->
						<xsl:apply-templates select="/iec:iec-standard/iec:bibliography/iec:references[1]">
							<xsl:with-param name="sectionNum" select="'2'"/>
						</xsl:apply-templates>
						
						 <!-- main sections -->
						<xsl:apply-templates select="/iec:iec-standard/iec:sections/*[position() &gt; 1]">
							<xsl:with-param name="sectionNumSkew" select="'1'"/>
						</xsl:apply-templates>
						
						<!-- Annex(s) -->
						<xsl:apply-templates select="/iec:iec-standard/iec:annex"/>
						
						<!-- Bibliography -->
						<xsl:apply-templates select="/iec:iec-standard/iec:bibliography/iec:references[position() &gt; 1]"/>
					</fo:block>
					
				</fo:flow>
			</fo:page-sequence>
			
			
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
	<xsl:template match="iec:iec-standard/iec:sections/*" mode="contents">
		<xsl:param name="sectionNum"/>
		<xsl:param name="sectionNumSkew" select="0"/>
		<xsl:variable name="sectionNum_">
			<xsl:choose>
				<xsl:when test="$sectionNum"><xsl:value-of select="$sectionNum"/></xsl:when>
				<xsl:when test="$sectionNumSkew != 0">
					<xsl:variable name="number"><xsl:number count="*"/></xsl:variable> <!-- iec:sections/iec:clause | iec:sections/iec:terms -->
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
	<xsl:template match="iec:title | iec:preferred" mode="contents">
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
				<xsl:when test="ancestor::iec:bibitem">false</xsl:when>
				<xsl:when test="ancestor::iec:term">false</xsl:when>
				<xsl:when test="ancestor::iec:annex and $level &gt;= 2">false</xsl:when>
				<xsl:when test="$level &lt;= 3">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="display-section">
			<xsl:choose>
				<xsl:when test="ancestor::iec:annex">false</xsl:when>
				<xsl:otherwise>true</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="type">
			<xsl:value-of select="local-name(..)"/>
		</xsl:variable>

		<xsl:variable name="root">
			<xsl:choose>
				<xsl:when test="ancestor::iec:annex">annex</xsl:when>
			</xsl:choose>
		</xsl:variable>
		
		<item id="{$id}" level="{$level}" section="{$section}" display-section="{$display-section}" display="{$display}" type="{$type}" root="{$root}">
			<xsl:attribute name="addon">
				<xsl:if test="local-name(..) = 'annex'"><xsl:value-of select="../@obligation"/></xsl:if>
			</xsl:attribute>
			<xsl:value-of select="."/>
		</item>
		
		<xsl:apply-templates mode="contents">
			<xsl:with-param name="sectionNum" select="$sectionNum"/>
		</xsl:apply-templates>
		
	</xsl:template>
	
	
	<xsl:template match="iec:figure" mode="contents">
		<xsl:param name="sectionNum"/>
		<xsl:apply-templates mode="contents">
			<xsl:with-param name="sectionNum" select="$sectionNum"/>
		</xsl:apply-templates>
		<item level="" id="{@id}" display="false" type="figure">
			<xsl:attribute name="section">
				<xsl:text>Figure </xsl:text>
				<xsl:choose>
					<xsl:when test="ancestor::iec:annex">
						<xsl:choose>
							<xsl:when test="count(//iec:annex) = 1">
								<xsl:value-of select="/iec:iec-standard/iec:bibdata/iec:ext/iec:structuredidentifier/iec:annexid"/><xsl:number format="-1" level="any" count="iec:annex//iec:figure"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:number format="A.1-1" level="multiple" count="iec:annex | iec:figure"/>
							</xsl:otherwise>
						</xsl:choose>		
					</xsl:when>
					<xsl:when test="ancestor::iec:figure">
						<xsl:for-each select="parent::*[1]">
							<xsl:number format="1" level="any" count="iec:figure[not(parent::iec:figure)]"/>
						</xsl:for-each>
						<xsl:number format="-a"  count="iec:figure"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:number format="1" level="any" count="iec:figure[not(parent::iec:figure)]"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:value-of select="iec:name"/>
		</item>
	</xsl:template>
	
	
	<xsl:template match="iec:table" mode="contents">
		<xsl:param name="sectionNum" />
		<xsl:variable name="annex-id" select="ancestor::iec:annex/@id"/>
		<item level="" id="{@id}" display="false" type="table">
			<xsl:attribute name="section">
				<xsl:text>Table </xsl:text>
				<xsl:choose>
					<xsl:when test="ancestor::*[local-name()='executivesummary']"> <!-- NIST -->
							<xsl:text>ES-</xsl:text><xsl:number format="1" count="*[local-name()='executivesummary']//*[local-name()='table']"/>
						</xsl:when>
					<xsl:when test="ancestor::*[local-name()='annex']">
						<xsl:number format="A." count="iec:annex"/>
						<xsl:number format="1" level="any" count="iec:table[ancestor::iec:annex[@id = $annex-id]]"/>
					</xsl:when>
					<xsl:otherwise>
						<!-- <xsl:number format="1"/> -->
						<!-- <xsl:number format="1" level="any" count="*[local-name()='sections']//*[local-name()='table']"/> -->
						<!-- <xsl:number format="1" level="any" count="*[local-name()='table'][not(ancestor::*[local-name()='annex'])]"/> -->
						<!-- <xsl:number format="1" level="any" count="*[not(local-name()='annex') and not(local-name()='executivesummary')]//*[local-name()='table'][not(@unnumbered) or @unnumbered != 'true']"/> -->
						<xsl:number format="1" level="any" count="//*[local-name()='table']
																																								[not(ancestor::*[local-name()='annex']) and not(ancestor::*[local-name()='executivesummary'])]
																																								[not(@unnumbered) or @unnumbered != 'true']"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:value-of select="iec:name/text()"/>
		</item>
	</xsl:template>
	
	
	
	<xsl:template match="iec:formula" mode="contents">
		<xsl:param name="sectionNum" />
		<item level="" id="{@id}" display="false" type="formula">
			<xsl:attribute name="section">
				<xsl:text>Formula (</xsl:text><xsl:number format="A.1" level="multiple" count="iec:annex | iec:formula"/><xsl:text>)</xsl:text>
			</xsl:attribute>
			<xsl:attribute name="parentsection">
				<xsl:for-each select="parent::*[1]/iec:title">
					<xsl:call-template name="getSection">
						<xsl:with-param name="sectionNum" select="$sectionNum"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:attribute>
		</item>
	</xsl:template>
	<!-- ============================= -->
	<!-- ============================= -->
	
	
	<xsl:template match="iec:license-statement//iec:title">
		<fo:block text-align="center" font-weight="bold">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="iec:license-statement//iec:p">
		<fo:block margin-left="1.5mm" margin-right="1.5mm">
			<xsl:if test="following-sibling::iec:p">
				<xsl:attribute name="margin-top">6pt</xsl:attribute>
				<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<!-- <fo:block margin-bottom="12pt">© ISO 2019, Published in Switzerland.</fo:block>
			<fo:block font-size="10pt" margin-bottom="12pt">All rights reserved. Unless otherwise specified, no part of this publication may be reproduced or utilized otherwise in any form or by any means, electronic or mechanical, including photocopying, or posting on the internet or an intranet, without prior written permission. Permission can be requested from either ISO at the address below or ISO’s member body in the country of the requester.</fo:block>
			<fo:block font-size="10pt" text-indent="7.1mm">
				<fo:block>ISO copyright office</fo:block>
				<fo:block>Ch. de Blandonnet 8 • CP 401</fo:block>
				<fo:block>CH-1214 Vernier, Geneva, Switzerland</fo:block>
				<fo:block>Tel.  + 41 22 749 01 11</fo:block>
				<fo:block>Fax  + 41 22 749 09 47</fo:block>
				<fo:block>copyright@iso.org</fo:block>
				<fo:block>www.iso.org</fo:block>
			</fo:block> -->
	<xsl:template match="iec:copyright-statement//iec:p">
		<fo:block>
			<xsl:if test="preceding-sibling::iec:p">
				<!-- <xsl:attribute name="font-size">10pt</xsl:attribute> -->
			</xsl:if>
			<xsl:if test="following-sibling::iec:p">
				<!-- <xsl:attribute name="margin-bottom">12pt</xsl:attribute> -->
				<xsl:attribute name="margin-bottom">3pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="not(following-sibling::iec:p)">
				<!-- <xsl:attribute name="margin-left">7.1mm</xsl:attribute> -->
				<xsl:attribute name="margin-left">4mm</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	
	<xsl:template match="iec:iec-standard/iec:preface/iec:foreword" priority="2">
		<fo:block id="{iec:title}" margin-bottom="10pt" font-size="12pt" text-align="center">
			<xsl:value-of select="translate(iec:title, $lower, $upper)"/>
		</fo:block>
		<fo:block font-size="8pt" text-align="justify" margin-left="6.3mm">
			<xsl:apply-templates select="/iec:iec-standard/iec:boilerplate/iec:legal-statement/*"/>
		</fo:block>
		<fo:block>
			<xsl:apply-templates select="*[not(local-name() = 'title')]"/>
		</fo:block>
	</xsl:template>
	
	<!-- Foreword, Introduction -->
	<xsl:template match="iec:iec-standard/iec:preface/*">
		<fo:block break-after="page"/>
		<fo:block>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	
	<!-- clause, terms, clause, ...-->
	<xsl:template match="iec:iec-standard/iec:sections/*">
		<xsl:param name="sectionNum"/>
		<xsl:param name="sectionNumSkew" select="0"/>
		<fo:block>
			<xsl:variable name="pos"><xsl:number count="iec:sections/iec:clause | iec:sections/iec:terms"/></xsl:variable>
			<!-- <xsl:if test="$pos &gt;= 2">
				<xsl:attribute name="space-before">18pt</xsl:attribute>
			</xsl:if> -->
			<!-- pos=<xsl:value-of select="$pos" /> -->
			<xsl:variable name="sectionNum_">
				<xsl:choose>
					<xsl:when test="$sectionNum"><xsl:value-of select="$sectionNum"/></xsl:when>
					<xsl:when test="$sectionNumSkew != 0">
						<xsl:variable name="number"><xsl:number count="iec:sections/iec:clause | iec:sections/iec:terms"/></xsl:variable>
						<xsl:value-of select="$number + $sectionNumSkew"/>
					</xsl:when>
				</xsl:choose>
			</xsl:variable>
			<xsl:if test="not(iec:title)">
				<fo:block margin-top="3pt" margin-bottom="12pt">
					<xsl:value-of select="$sectionNum_"/><xsl:number format=".1 " level="multiple" count="iec:clause" />
				</fo:block>
			</xsl:if>
			<xsl:apply-templates>
				<xsl:with-param name="sectionNum" select="$sectionNum_"/>
			</xsl:apply-templates>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="iec:annex//iec:clause">
		<xsl:param name="sectionNum"/>
		<fo:block margin-top="5pt" margin-bottom="10pt" text-align="justify">
			<xsl:apply-templates>
				<xsl:with-param name="sectionNum" select="$sectionNum"/>
			</xsl:apply-templates>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="iec:clause//iec:clause[not(iec:title)]">
		<xsl:param name="sectionNum"/>
		<xsl:variable name="section">
			<xsl:call-template name="getSection">
				<xsl:with-param name="sectionNum" select="$sectionNum"/>
			</xsl:call-template>
		</xsl:variable>
		
		<fo:block margin-top="5pt" margin-bottom="5pt" font-weight="bold" keep-with-next="always">
			<xsl:value-of select="$section"/>
		</fo:block>
		<fo:block margin-bottom="10pt">
			<xsl:apply-templates>
				<xsl:with-param name="sectionNum" select="$sectionNum"/>
				<!-- <xsl:with-param name="inline" select="'true'"/> -->
			</xsl:apply-templates>
		</fo:block>
		<!-- <fo:block margin-top="3pt" >
			<fo:inline font-weight="bold" padding-right="3mm">
				<xsl:value-of select="$section"/>
			</fo:inline>
			<xsl:apply-templates>
				<xsl:with-param name="sectionNum" select="$sectionNum"/>
				<xsl:with-param name="inline" select="'true'"/>
			</xsl:apply-templates>
		</fo:block> -->
	</xsl:template>
	
	
	<xsl:template match="iec:title">
		<xsl:param name="sectionNum"/>
		
		<xsl:variable name="parent-name"  select="local-name(..)"/>
		<xsl:variable name="references_num_current">
			<xsl:number level="any" count="iec:references"/>
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
				<xsl:when test="ancestor::iec:sections and $level = 1">11pt</xsl:when>
				<xsl:when test="ancestor::iec:references[not (preceding-sibling::iec:references)]">11pt</xsl:when>
				<xsl:otherwise>10pt</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
			<!-- <xsl:choose>
				<xsl:when test="ancestor::iec:annex and $level = 1">12pt</xsl:when>
				<xsl:when test="ancestor::iec:annex and $level &gt;= 2">10pt</xsl:when>
				<xsl:when test="ancestor::iec:preface">16pt</xsl:when>
				<xsl:when test="$level = 2">12pt</xsl:when>
				<xsl:when test="$level &gt;= 3">11pt</xsl:when>
				<xsl:otherwise>13pt</xsl:otherwise>
			</xsl:choose>
		</xsl:variable> -->
		
		<xsl:variable name="element-name">
			<xsl:choose>
				<xsl:when test="../@inline-header = 'true'">fo:inline</xsl:when>
				<xsl:otherwise>fo:block</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="$parent-name = 'annex'">
				<fo:block id="{$id}" font-size="12pt" font-weight="bold" text-align="center" margin-bottom="10pt" keep-with-next="always">
					<xsl:value-of select="$section"/>
					<xsl:if test=" ../@obligation">
						<xsl:value-of select="$linebreak"/>
						<xsl:value-of select="$linebreak"/>
						<fo:inline font-weight="normal">(<xsl:value-of select="../@obligation"/>)</fo:inline>
					</xsl:if>
					<xsl:value-of select="$linebreak"/>
					<xsl:value-of select="$linebreak"/>
					<xsl:apply-templates />
				</fo:block>
			</xsl:when>
			<xsl:when test="$parent-name = 'references' and $references_num_current != 1"> <!-- Bibliography -->
				<fo:block id="{$id}" font-family="Times New Roman" font-size="24pt" font-weight="bold" margin-bottom="12pt" keep-with-next="always">
					<xsl:apply-templates />
				</fo:block>
			</xsl:when>
			<xsl:when test="$parent-name = 'introduction'">
				<fo:block id="{$id}" font-size="12pt" text-align="center" margin-bottom="10pt">
					<xsl:value-of select="translate(text(), $lower, $upper)"/>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="{$element-name}">
					<xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute>
					<xsl:attribute name="font-size">
						<xsl:value-of select="$font-size"/>
					</xsl:attribute>
					<xsl:attribute name="font-weight">bold</xsl:attribute>
					
					<xsl:if test="$element-name = 'fo:block'">
						<xsl:attribute name="keep-with-next">always</xsl:attribute>		
						<xsl:attribute name="margin-top"> <!-- margin-top -->
							<xsl:choose>
								<xsl:when test="$level &gt;= 2 and ancestor::iec:annex">5pt</xsl:when>
								<xsl:when test="$level = '' or $level = 1">10pt</xsl:when><!-- 13.5pt -->
								<xsl:otherwise>10pt</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<xsl:attribute name="margin-bottom">
							<xsl:choose>
								<xsl:when test="$level = '' or $level = 1">10pt</xsl:when>
								<xsl:otherwise>5pt</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
					</xsl:if>
					
						<xsl:value-of select="$section"/>
						<xsl:if test="$section != ''">
							<xsl:choose>
								<xsl:when test="$level = 2">
									<fo:inline>&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;</fo:inline>
								</xsl:when>
								<xsl:otherwise>
									<fo:inline>&#xA0;&#xA0;&#xA0;&#xA0;</fo:inline>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:if>
				
						<xsl:apply-templates />
						
						
				</xsl:element>
				
				<!-- <xsl:if test="$element-name = 'fo:inline' and not(following-sibling::iec:p)">
					<fo:block> 
						<xsl:value-of select="$linebreak"/>
					</fo:block>
				</xsl:if> -->
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	

	
	<xsl:template match="iec:p">
		<xsl:param name="inline" select="'false'"/>
		<xsl:variable name="previous-element" select="local-name(preceding-sibling::*[1])"/>
		<xsl:variable name="element-name">
			<xsl:choose>
				<xsl:when test="$inline = 'true'">fo:inline</xsl:when>
				<xsl:when test="../@inline-header = 'true' and $previous-element = 'title'">fo:inline</xsl:when> <!-- first paragraph after inline title -->
				<xsl:when test="local-name(..) = 'admonition'">fo:block</xsl:when>
				<xsl:otherwise>fo:block</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!-- inline=<xsl:value-of select="$inline"/> -->
		<xsl:choose>
			<xsl:when test="$element-name = 'fo:block'">
				<xsl:element name="{$element-name}">
					<xsl:attribute name="text-align">
						<xsl:choose>
							<!-- <xsl:when test="ancestor::iec:preface">justify</xsl:when> -->
							<xsl:when test="@align"><xsl:value-of select="@align"/></xsl:when>
							<xsl:otherwise>justify</xsl:otherwise><!-- left -->
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="margin-top">5pt</xsl:attribute>
					<xsl:attribute name="margin-bottom">10pt</xsl:attribute>
					<xsl:apply-templates />
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates />
			</xsl:otherwise>
		</xsl:choose>
		
		
		<!-- <xsl:if test="$element-name = 'fo:inline' and not($inline = 'true') and not(local-name(..) = 'admonition')">
			<fo:block margin-bottom="10pt">
				 <xsl:if test="ancestor::iec:annex">
					<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
				 </xsl:if>
				<xsl:value-of select="$linebreak"/>
			</fo:block>
		</xsl:if> -->
		<!-- <xsl:if test="$inline = 'true'">
			<fo:block>&#xA0;</fo:block>
		</xsl:if> -->
	</xsl:template>
	
	<!--
	<fn reference="1">
			<p id="_8e5cf917-f75a-4a49-b0aa-1714cb6cf954">Formerly denoted as 15 % (m/m).</p>
		</fn>
	-->
	<xsl:template match="iec:p/iec:fn" priority="2">
		<fo:footnote>
			<xsl:variable name="number">
				<xsl:number level="any" count="iec:p/iec:fn"/>
			</xsl:variable>
			<fo:inline font-size="8pt" keep-with-previous.within-line="always" baseline-shift="15%"> <!-- font-size="80%"  vertical-align="super"-->
				<fo:basic-link internal-destination="footnote_{@reference}" fox:alt-text="footnote {@reference}">
					<!-- <xsl:value-of select="@reference"/> -->
					<xsl:value-of select="$number + count(//iec:bibitem/iec:note)"/><!-- <xsl:text>)</xsl:text> -->
				</fo:basic-link>
			</fo:inline>
			<fo:footnote-body>
				<fo:block font-size="8pt" margin-bottom="5pt">
					<fo:inline id="footnote_{@reference}" keep-with-next.within-line="always" baseline-shift="15%"> <!-- padding-right="3mm" font-size="60%"  alignment-baseline="hanging" -->
						<xsl:value-of select="$number + count(//iec:bibitem/iec:note)"/><!-- <xsl:text>)</xsl:text> -->
					</fo:inline>
					<xsl:for-each select="iec:p">
							<xsl:apply-templates />
					</xsl:for-each>
				</fo:block>
			</fo:footnote-body>
		</fo:footnote>
	</xsl:template>

	<xsl:template match="iec:p/iec:fn/iec:p">
		<xsl:apply-templates />
	</xsl:template>
	
	<xsl:template match="iec:dd/iec:p">
		<fo:block margin-top="5pt" margin-bottom="10pt"><xsl:apply-templates /></fo:block>
	</xsl:template>
	
	<xsl:template match="iec:review">
		<!-- comment 2019-11-29 -->
		<!-- <fo:block font-weight="bold">Review:</fo:block>
		<xsl:apply-templates /> -->
	</xsl:template>

	<xsl:template match="text()">
		<xsl:value-of select="."/>
	</xsl:template>
	


	<xsl:template match="iec:image">
		<fo:block-container text-align="center">
			<fo:block>
				<fo:external-graphic src="{@src}" fox:alt-text="Image"/>
			</fo:block>
			<fo:block font-weight="bold" margin-top="12pt" margin-bottom="12pt">Figure <xsl:number format="1" level="any"/></fo:block>
		</fo:block-container>
		
	</xsl:template>

	<xsl:template match="iec:figure">
		<xsl:variable name="title">
			<xsl:text>Figure </xsl:text>
		</xsl:variable>
		
		<fo:block-container id="{@id}">
			<fo:block>
				<xsl:apply-templates />
			</fo:block>
			<xsl:call-template name="fn_display_figure"/>
			<xsl:for-each select="iec:note//iec:p">
				<xsl:call-template name="note"/>
			</xsl:for-each>
			<fo:block font-weight="bold" text-align="center" margin-top="12pt" margin-bottom="12pt" keep-with-previous="always">
				<xsl:choose>
					<xsl:when test="ancestor::iec:annex">
						
						<!-- <xsl:choose>
							
							<xsl:when test="local-name(..) = 'figure'">
								<xsl:number format="a) "/>
							</xsl:when>
							<xsl:otherwise> -->
								<xsl:value-of select="$title"/><xsl:number format="A.1-1" level="multiple" count="iec:annex | iec:figure"/>
							<!-- </xsl:otherwise>
						</xsl:choose> -->
						
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$title"/><xsl:number format="1" level="any"/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:if test="iec:name">
					<!-- <xsl:if test="not(local-name(..) = 'figure')"> -->
						<xsl:text> — </xsl:text>
					<!-- </xsl:if> -->
					<xsl:value-of select="iec:name"/>
				</xsl:if>
			</fo:block>
		</fo:block-container>
	</xsl:template>
	
	<xsl:template match="iec:figure/iec:name"/>
	<xsl:template match="iec:figure/iec:fn" priority="2"/>
	<xsl:template match="iec:figure/iec:note"/>
	
	
	<xsl:template match="iec:figure/iec:image">
		<fo:block text-align="center">
			<fo:external-graphic src="{@src}" width="75%" content-height="scale-to-fit" scaling="uniform" fox:alt-text="Image"/> <!-- content-width="100%"  -->
		</fo:block>
	</xsl:template>
	
	
	
	
	<xsl:template match="iec:bibitem">
		<fo:block id="{@id}" margin-top="5pt" margin-bottom="10pt"> <!-- letter-spacing="0.4pt" -->
				<!-- iec:docidentifier -->
			<xsl:if test="iec:docidentifier">
				<xsl:choose>
					<xsl:when test="iec:docidentifier/@type = 'metanorma'"/>
					<xsl:otherwise><fo:inline><xsl:value-of select="iec:docidentifier"/></fo:inline></xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:apply-templates select="iec:note"/>
			<xsl:if test="iec:docidentifier">, </xsl:if>
			<fo:inline font-style="italic">
				<xsl:choose>
					<xsl:when test="iec:title[@type = 'main' and @language = 'en']">
						<xsl:value-of select="iec:title[@type = 'main' and @language = 'en']"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="iec:title"/>
					</xsl:otherwise>
				</xsl:choose>
			</fo:inline>
		</fo:block>
	</xsl:template>
	
	
	<xsl:template match="iec:bibitem/iec:note">
		<fo:footnote>
			<xsl:variable name="number">
				<xsl:number level="any" count="iec:bibitem/iec:note"/>
			</xsl:variable>
			<fo:inline font-size="8pt" keep-with-previous.within-line="always"  baseline-shift="15%" > <!--font-size="85%"  vertical-align="super"60% -->
				<fo:basic-link internal-destination="footnote_{../@id}" fox:alt-text="footnote {$number}">
					<xsl:value-of select="$number"/><!-- <xsl:text>)</xsl:text> -->
				</fo:basic-link>
			</fo:inline>
			<fo:footnote-body>
				<fo:block font-size="8pt" margin-bottom="5pt">
					<fo:inline id="footnote_{../@id}" keep-with-next.within-line="always" baseline-shift="15%"><!-- padding-right="9mm" alignment-baseline="hanging"  font-size="60%"  -->
						<xsl:value-of select="$number"/><!-- <xsl:text>)</xsl:text> -->
					</fo:inline>
					<xsl:apply-templates />
				</fo:block>
			</fo:footnote-body>
		</fo:footnote>
	</xsl:template>
	
	
	
	<xsl:template match="iec:ul | iec:ol">
		<fo:list-block provisional-distance-between-starts="7mm">
			<xsl:if test="local-name() = 'ul'">
				<xsl:attribute name="margin-left">6mm</xsl:attribute>
			</xsl:if>
			<xsl:if test="ancestor::iec:legal-statement">
				<xsl:attribute name="provisional-distance-between-starts">5mm</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates />
		</fo:list-block>
	</xsl:template>
	
	<xsl:template match="iec:li">
		<fo:list-item>
			<fo:list-item-label end-indent="label-end()">
				<xsl:if test="local-name(..) = 'ul'">
					<xsl:attribute name="font-size">12pt</xsl:attribute>
				</xsl:if>
				<fo:block>
					<xsl:choose>
						<xsl:when test="local-name(..) = 'ul'">•</xsl:when> <!-- &#x2014; dash -->
						<xsl:otherwise> <!-- for ordered lists -->
							<xsl:choose>
								<xsl:when test="../@type = 'arabic'">
									<xsl:number format="a)"/>
								</xsl:when>
								<xsl:when test="../@type = 'alphabet'">
									<xsl:number format="a)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:number format="1)"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</fo:block>
			</fo:list-item-label>
			<fo:list-item-body start-indent="body-start()">
				<xsl:apply-templates />
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>
	
	<xsl:template match="iec:li/iec:p">
		<fo:block margin-bottom="0pt">
			<xsl:if test="ancestor::iec:legal-statement">
				<xsl:attribute name="margin-bottom">5pt</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="iec:link">
		<fo:inline>
			<fo:basic-link external-destination="{@target}" fox:alt-text="{@target}">
				<xsl:choose>
					<xsl:when test="normalize-space(.) = ''">
						<xsl:value-of select="@target"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates />
					</xsl:otherwise>
				</xsl:choose>
			</fo:basic-link>
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="iec:preferred">
		<xsl:param name="sectionNum"/>
		<fo:block line-height="1.1">
			<fo:block font-weight="bold" keep-with-next="always">
				<fo:inline id="{../@id}">
					<xsl:value-of select="$sectionNum"/>.<xsl:number count="iec:term"/>
				</fo:inline>
			</fo:block>
			<fo:block font-weight="bold" keep-with-next="always">
				<xsl:apply-templates />
			</fo:block>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="iec:admitted">
		<fo:block>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="iec:deprecates">
		<fo:block font-size="8pt" margin-top="5pt" margin-bottom="5pt">DEPRECATED: <xsl:apply-templates /></fo:block>
	</xsl:template>
	
	<xsl:template match="iec:definition[preceding-sibling::iec:domain]">
		<xsl:apply-templates />
	</xsl:template>
	<xsl:template match="iec:definition[preceding-sibling::iec:domain]/iec:p">
		<fo:inline> <xsl:apply-templates /></fo:inline>
		<fo:block>&#xA0;</fo:block>
	</xsl:template>
	
	<xsl:template match="iec:definition">
		<fo:block margin-bottom="6pt">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="iec:termsource">
		<fo:block margin-bottom="8pt" keep-with-previous="always">
			<!-- Example: [SOURCE: ISO 5127:2017, 3.1.6.02] -->
			<fo:basic-link internal-destination="{iec:origin/@bibitemid}" fox:alt-text="{iec:origin/@citeas}">
				<xsl:text>[SOURCE: </xsl:text>
				<xsl:value-of select="iec:origin/@citeas"/>
				<xsl:if test="iec:origin/iec:locality/iec:referenceFrom">
					<xsl:text>, </xsl:text><xsl:value-of select="iec:origin/iec:locality/iec:referenceFrom"/>
				</xsl:if>
			</fo:basic-link>
			<xsl:apply-templates select="iec:modification"/>
			<xsl:text>]</xsl:text>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="iec:modification">
		<xsl:text>, modified — </xsl:text>
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="iec:modification/iec:p">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template>
	
	<xsl:template match="iec:termnote">
		<fo:block font-size="8pt" margin-top="5pt" margin-bottom="5pt">
			<xsl:text>Note </xsl:text>
			<xsl:number />
			<xsl:text> to entry: </xsl:text>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="iec:termnote/iec:p">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template>
	
	<xsl:template match="iec:domain">
		<fo:inline>&lt;<xsl:apply-templates/>&gt;</fo:inline>
	</xsl:template>
	
	
	<xsl:template match="iec:termexample">
		<fo:block margin-top="14pt" margin-bottom="10pt">
			<fo:inline padding-right="10mm">EXAMPLE</fo:inline>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="iec:termexample/iec:p">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template>

	
	<xsl:template match="iec:annex">
		<fo:block break-after="page"/>
		<xsl:apply-templates />
	</xsl:template>

	
	<!-- <xsl:template match="iec:references[@id = '_bibliography']"> -->
	<xsl:template match="iec:references[position() &gt; 1]">
		<fo:block break-after="page"/>
			<xsl:apply-templates />
	</xsl:template>


	<!-- Example: [1] ISO 9:1995, Information and documentation – Transliteration of Cyrillic characters into Latin characters – Slavic and non-Slavic languages -->
	<!-- <xsl:template match="iec:references[@id = '_bibliography']/iec:bibitem"> -->
	<xsl:template match="iec:references[position() &gt; 1]/iec:bibitem">
		<fo:list-block margin-top="5pt" margin-bottom="10pt" provisional-distance-between-starts="12mm">
			<fo:list-item>
				<fo:list-item-label end-indent="label-end()">
					<fo:block>
						<fo:inline id="{@id}">
							<xsl:number format="[1]"/>
						</fo:inline>
					</fo:block>
				</fo:list-item-label>
				<fo:list-item-body start-indent="body-start()">
					<fo:block>
						<xsl:if test="iec:docidentifier">
							<xsl:choose>
								<xsl:when test="iec:docidentifier/@type = 'metanorma'"/>
								<xsl:otherwise><fo:inline><xsl:value-of select="iec:docidentifier"/>, </fo:inline></xsl:otherwise>
							</xsl:choose>
						</xsl:if>
						<xsl:choose>
							<xsl:when test="iec:title[@type = 'main' and @language = 'en']">
								<xsl:apply-templates select="iec:title[@type = 'main' and @language = 'en']"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates select="iec:title"/>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:apply-templates select="iec:formattedref"/>
					</fo:block>
				</fo:list-item-body>
			</fo:list-item>
		</fo:list-block>
	</xsl:template>
	
	<!-- <xsl:template match="iec:references[@id = '_bibliography']/iec:bibitem" mode="contents"/> -->
	<xsl:template match="iec:references[position() &gt; 1]/iec:bibitem" mode="contents"/>
	
	<!-- <xsl:template match="iec:references[@id = '_bibliography']/iec:bibitem/iec:title"> -->
	<xsl:template match="iec:references[position() &gt; 1]/iec:bibitem/iec:title">
		<fo:inline font-style="italic">
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>

	<xsl:template match="iec:quote">
		<fo:block margin-top="5pt" margin-bottom="10pt" margin-left="12mm" margin-right="12mm">
			<xsl:apply-templates select=".//iec:p"/>
			<fo:block text-align="right" margin-top="15pt">
				<!-- — ISO, ISO 7301:2011, Clause 1 -->
				<xsl:text>— </xsl:text><xsl:value-of select="iec:author"/>
				<xsl:if test="iec:source">
					<xsl:text>, </xsl:text>
					<xsl:apply-templates select="iec:source"/>
				</xsl:if>
			</fo:block>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="iec:source">
		<fo:basic-link internal-destination="{@bibitemid}" fox:alt-text="{@citeas}">
			<xsl:value-of select="@citeas" disable-output-escaping="yes"/>
			<xsl:if test="iec:locality">
				<xsl:text>, </xsl:text>
				<xsl:apply-templates select="iec:locality"/>
			</xsl:if>
		</fo:basic-link>
	</xsl:template>
	
	<xsl:template match="iec:appendix">
		<fo:block font-weight="bold" margin-top="5pt" margin-bottom="5pt">
			<fo:inline padding-right="5mm">Appendix <xsl:number /></fo:inline>
			<xsl:apply-templates select="iec:title" mode="process"/>
		</fo:block>
		<xsl:apply-templates />
	</xsl:template>
	
	<xsl:template match="iec:appendix//iec:example">
		<fo:block margin-top="14pt" margin-bottom="14pt">
			<xsl:text>EXAMPLE</xsl:text>
			<xsl:if test="iec:name">
				<xsl:text> — </xsl:text><xsl:apply-templates select="iec:name" mode="process"/>
			</xsl:if>
		</fo:block>
		<xsl:apply-templates />
	</xsl:template>
	
	<xsl:template match="iec:appendix//iec:example/iec:name"/>
	<xsl:template match="iec:appendix//iec:example/iec:name" mode="process">
		<fo:inline><xsl:apply-templates /></fo:inline>
	</xsl:template>
	
	<!-- <xsl:template match="iec:callout/text()">	
		<fo:basic-link internal-destination="{@target}"><fo:inline>&lt;<xsl:apply-templates />&gt;</fo:inline></fo:basic-link>
	</xsl:template> -->
	<xsl:template match="iec:callout">		
			<fo:basic-link internal-destination="{@target}" fox:alt-text="{@target}">&lt;<xsl:apply-templates />&gt;</fo:basic-link>
	</xsl:template>
	
	<xsl:template match="iec:annotation">
		<fo:block>
			
		</fo:block>
		<xsl:apply-templates />
	</xsl:template>
	
	<xsl:template match="iec:annotation/text()"/>
	
	<xsl:template match="iec:annotation/iec:p">
		<xsl:variable name="annotation-id" select="../@id"/>
		<xsl:variable name="callout" select="//*[@target = $annotation-id]/text()"/>
		<fo:block id="{$annotation-id}">
			<xsl:value-of select="concat('&lt;', $callout, '&gt; ')"/>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	
	<xsl:template match="iec:appendix/iec:title"/>
	<xsl:template match="iec:appendix/iec:title" mode="process">
		<fo:inline><xsl:apply-templates /></fo:inline>
	</xsl:template>
	
	<xsl:template match="mathml:math">
		<fo:inline font-family="Cambria Math">
			<fo:instream-foreign-object fox:alt-text="Math">
				<xsl:copy-of select="."/>
			</fo:instream-foreign-object>
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="iec:xref">
		<xsl:variable name="section" select="xalan:nodeset($contents)//item[@id = current()/@target]/@section"/>
		<fo:basic-link internal-destination="{@target}" fox:alt-text="{$section}">
			<xsl:variable name="type" select="xalan:nodeset($contents)//item[@id = current()/@target]/@type"/>
			<xsl:variable name="root" select="xalan:nodeset($contents)//item[@id = current()/@target]/@root"/>
			<xsl:variable name="parentsection" select="xalan:nodeset($contents)//item[@id = current()/@target]/@parentsection"/>
			<xsl:choose>
				<xsl:when test="$type = 'clause' and $root != 'annex'">Clause </xsl:when><!-- and not (ancestor::annex) -->
				<xsl:otherwise></xsl:otherwise> <!-- <xsl:value-of select="$type"/> -->
			</xsl:choose>
			<xsl:variable name="currentsection">
				<xsl:for-each select="ancestor::iec:clause[1]/iec:title">
					<xsl:call-template name="getSection"/>
				</xsl:for-each>
			</xsl:variable>
			<xsl:if test="$type = 'formula' and $parentsection != '' and not(contains($parentsection, $currentsection))">
				<xsl:value-of select="$parentsection"/><xsl:text>, </xsl:text>
			</xsl:if>
			<xsl:value-of select="$section"/>
      </fo:basic-link>
	</xsl:template>

	<xsl:template match="iec:sourcecode">
		<fo:block font-family="Courier" font-size="9pt" margin-top="5pt" margin-bottom="5pt">
			<xsl:choose>
				<xsl:when test="@lang = 'en'"></xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="white-space">pre</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="iec:example/iec:p">
		<fo:block>
			<fo:inline padding-right="9mm">EXAMPLE</fo:inline>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="iec:note/iec:p" name="note">
		<fo:block margin-top="5pt" margin-bottom="5pt" font-size="8pt">
			<fo:inline padding-right="6mm">NOTE</fo:inline>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>

	<!-- <eref type="inline" bibitemid="ISO20483" citeas="ISO 20483:2013"><locality type="annex"><referenceFrom>C</referenceFrom></locality></eref> -->
	<xsl:template match="iec:eref">
		<fo:basic-link internal-destination="{@bibitemid}" fox:alt-text="{@citeas}">
			<xsl:if test="@type = 'footnote'">
				<xsl:attribute name="keep-together.within-line">always</xsl:attribute>
				<xsl:attribute name="font-size">80%</xsl:attribute>
				<xsl:attribute name="keep-with-previous.within-line">always</xsl:attribute>
				<xsl:attribute name="vertical-align">super</xsl:attribute>
			</xsl:if>
			
			<xsl:value-of select="@citeas" disable-output-escaping="yes"/>
			<xsl:if test="iec:locality">
				<xsl:text>, </xsl:text>
				<!-- <xsl:choose>
						<xsl:when test="iec:locality/@type = 'section'">Section </xsl:when>
						<xsl:when test="iec:locality/@type = 'clause'">Clause </xsl:when>
						<xsl:otherwise></xsl:otherwise>
					</xsl:choose> -->
					<xsl:apply-templates select="iec:locality"/>
			</xsl:if>
		</fo:basic-link>
	</xsl:template>
	
	<xsl:template match="iec:locality">
		<xsl:choose>
			<xsl:when test="@type ='clause'">Clause </xsl:when>
			<xsl:when test="@type ='annex'">Annex </xsl:when>
			<xsl:when test="@type ='table'">Table </xsl:when>
			<xsl:otherwise><xsl:value-of select="@type"/></xsl:otherwise>
		</xsl:choose>
		<xsl:text> </xsl:text><xsl:value-of select="iec:referenceFrom"/>
	</xsl:template>
	
	<xsl:template match="iec:admonition">
		<fo:block font-weight="bold">
			<fo:block  text-align="center" margin-top="5pt" margin-bottom="10pt">
				<xsl:value-of select="translate(@type, $lower, $upper)"/>
			</fo:block>
			<!-- <xsl:text> — </xsl:text> -->
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="iec:formula/iec:dt/iec:stem">
		<fo:inline>
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="iec:admitted/iec:stem">
		<fo:inline padding-left="6mm">
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="iec:formula/iec:stem">
		<fo:block id="{../@id}" margin-top="6pt" margin-bottom="12pt">
			<fo:table table-layout="fixed" width="100%">
				<fo:table-column column-width="95%"/>
				<fo:table-column column-width="5%"/>
				<fo:table-body>
					<fo:table-row>
						<fo:table-cell display-align="center">
							<fo:block text-align="left"> <!-- margin-left="5mm" -->
								<xsl:apply-templates />
							</fo:block>
						</fo:table-cell>
						<fo:table-cell display-align="center">
							<fo:block text-align="right" margin-right="-10mm">
								<xsl:choose>
									<xsl:when test="ancestor::iec:annex">
										<xsl:text>(</xsl:text><xsl:number format="A.1" level="multiple" count="iec:annex | iec:formula"/><xsl:text>)</xsl:text>
									</xsl:when>
									<xsl:otherwise> <!-- not(ancestor::iec:annex) -->
										<xsl:text>(</xsl:text><xsl:number level="any" count="iec:formula"/><xsl:text>)</xsl:text>
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
	
	
	<xsl:template match="iec:br" priority="2">
		<!-- <fo:block>&#xA0;</fo:block> -->
		<xsl:value-of select="$linebreak"/>
	</xsl:template>
	
	<xsl:template name="insertHeaderFooter">
		<fo:static-content flow-name="header-even">
			<fo:block-container height="29mm" display-align="before"> <!--  letter-spacing="0.4pt" -->
				<fo:table table-layout="fixed" width="100%">
					<fo:table-column column-width="45%"/>
					<fo:table-column column-width="10%"/>
					<fo:table-column column-width="45%"/>
					<fo:table-body>
						<fo:table-row>
							<fo:table-cell><fo:block>&#xA0;</fo:block></fo:table-cell>
							<fo:table-cell text-align="center">
								<fo:block padding-top="12.5mm">– <fo:page-number/> –</fo:block>
							</fo:table-cell>
							<fo:table-cell text-align="right">
								<fo:block padding-top="12.5mm">
									<xsl:value-of select="$ISOname"/>
									<xsl:text> </xsl:text>
									<xsl:value-of select="$copyrightText"/>
								</fo:block>
							</fo:table-cell>
						</fo:table-row>
					</fo:table-body>
				</fo:table>
			</fo:block-container>
		</fo:static-content>
		
		<fo:static-content flow-name="header-odd">
			<fo:block-container height="29mm" display-align="before">
				<fo:table table-layout="fixed" width="100%">
					<fo:table-column column-width="45%"/>
					<fo:table-column column-width="10%"/>
					<fo:table-column column-width="45%"/>
					<fo:table-body>
						<fo:table-row>
							<fo:table-cell>
								<fo:block padding-top="12.5mm">
									<xsl:value-of select="$ISOname"/>
									<xsl:text> </xsl:text>
									<xsl:value-of select="$copyrightText"/>
								</fo:block>
							</fo:table-cell>
							<fo:table-cell text-align="center">
								<fo:block padding-top="12.5mm">– <fo:page-number/> –</fo:block>
							</fo:table-cell>
							<fo:table-cell><fo:block>&#xA0;</fo:block></fo:table-cell>
						</fo:table-row>
					</fo:table-body>
				</fo:table>
			</fo:block-container>
		</fo:static-content>
	</xsl:template>

	<xsl:template name="getId">
		<xsl:choose>
			<xsl:when test="../@id">
				<xsl:value-of select="../@id"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="text()"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="getLevel">
		<xsl:variable name="level_total" select="count(ancestor::*)"/>
		<xsl:variable name="level">
			<xsl:choose>
				<xsl:when test="ancestor::iec:preface">
					<xsl:value-of select="$level_total - 2"/>
				</xsl:when>
				<xsl:when test="ancestor::iec:sections">
					<xsl:value-of select="$level_total - 2"/>
				</xsl:when>
				<xsl:when test="ancestor::iec:bibliography">
					<xsl:value-of select="$level_total - 2"/>
				</xsl:when>
				<xsl:when test="local-name(ancestor::*[1]) = 'annex'">1</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$level_total - 1"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$level"/>
	</xsl:template>

	<xsl:template name="getSection">
		<xsl:param name="sectionNum"/>
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		<xsl:variable name="section">
			<xsl:choose>
				<xsl:when test="ancestor::iec:bibliography">
					<xsl:value-of select="$sectionNum"/>
				</xsl:when>
				<xsl:when test="ancestor::iec:sections">
					<!-- 1, 2, 3, 4, ... from main section (not annex, bibliography, ...) -->
					<xsl:choose>
						<xsl:when test="$level = 1">
							<xsl:value-of select="$sectionNum"/>
						</xsl:when>
						<xsl:when test="$level &gt;= 2">
							<xsl:variable name="num">
								<xsl:number format=".1" level="multiple" count="iec:clause/iec:clause | iec:clause/iec:terms | iec:terms/iec:term | iec:clause/iec:term"/>
							</xsl:variable>
							<xsl:value-of select="concat($sectionNum, $num)"/>
						</xsl:when>
						<xsl:otherwise>
							<!-- z<xsl:value-of select="$sectionNum"/>z -->
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<!-- <xsl:when test="ancestor::iec:annex[@obligation = 'informative']">
					<xsl:choose>
						<xsl:when test="$level = 1">
							<xsl:text>Annex  </xsl:text>
							<xsl:number format="I" level="any" count="iec:annex[@obligation = 'informative']"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:number format="I.1" level="multiple" count="iec:annex[@obligation = 'informative'] | iec:clause"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when> -->
				<xsl:when test="ancestor::iec:annex">
					<xsl:choose>
						<xsl:when test="$level = 1">
							<xsl:text>Annex </xsl:text>
							<xsl:choose>
								<xsl:when test="count(//iec:annex) = 1">
									<xsl:value-of select="/iec:iec-standard/iec:bibdata/iec:ext/iec:structuredidentifier/iec:annexid"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:number format="A" level="any" count="iec:annex"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="count(//iec:annex) = 1">
									<xsl:value-of select="/iec:iec-standard/iec:bibdata/iec:ext/iec:structuredidentifier/iec:annexid"/><xsl:number format=".1" level="multiple" count="iec:clause"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:number format="A.1" level="multiple" count="iec:annex | iec:clause"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="ancestor::iec:preface"> <!-- if preface and there is clause(s) -->
					<xsl:choose>
						<xsl:when test="$level = 1 and  ..//iec:clause">0</xsl:when>
						<xsl:when test="$level &gt;= 2">
							<xsl:variable name="num">
								<xsl:number format=".1" level="multiple" count="iec:clause"/>
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

</xsl:stylesheet>
