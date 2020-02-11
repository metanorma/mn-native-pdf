<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:un="https://www.metanorma.org/ns/unece" xmlns:mathml="http://www.w3.org/1998/Math/MathML" xmlns:xalan="http://xml.apache.org/xalan" xmlns:fox="http://xmlgraphics.apache.org/fop/extensions" version="1.0">

	<xsl:output version="1.0" method="xml" encoding="UTF-8" indent="no"/>

	<xsl:include href="./common.xsl"/>
	
	<xsl:variable name="namespace">unece</xsl:variable>
	
	<xsl:variable name="pageWidth" select="'210mm'"/>
	<xsl:variable name="pageHeight" select="'297mm'"/>

	<xsl:variable name="contents">
		<contents>
			<xsl:apply-templates select="/un:unece-standard/un:sections/*" mode="contents"/>
			<xsl:apply-templates select="/un:unece-standard/un:annex" mode="contents"/>
		</contents>
	</xsl:variable>
	
	<xsl:variable name="lang">
		<xsl:call-template name="getLang"/>
	</xsl:variable>
	
	<xsl:template match="/">
		<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format" font-family="Times New Roman, Cambria Math, HanSans" font-size="10.5pt" xml:lang="{$lang}">
			<fo:layout-master-set>
				<!-- Cover page -->
				<fo:simple-page-master master-name="cover-page" page-width="{$pageWidth}" page-height="{$pageHeight}">
					<fo:region-body margin-top="14mm" margin-bottom="10mm" margin-left="19mm" margin-right="19mm"/>
					<fo:region-before extent="14mm"/>
					<fo:region-after extent="10mm"/>
					<fo:region-start extent="19mm"/>
					<fo:region-end extent="19mm"/>
				</fo:simple-page-master>
				
				<!-- Document pages -->
				<fo:simple-page-master master-name="document" page-width="{$pageWidth}" page-height="{$pageHeight}">
					<fo:region-body margin-top="25mm" margin-bottom="11mm" margin-left="30mm" margin-right="19mm"/>
					<fo:region-before region-name="header" extent="25mm"/>
					<fo:region-after region-name="footer" extent="10mm"/>
					<fo:region-start region-name="left" extent="30mm"/>
					<fo:region-end region-name="right" extent="19mm"/>
				</fo:simple-page-master>
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
							<dc:title><xsl:value-of select="/un:unece-standard/un:bibdata/un:title[@language = 'en' and @type = 'main']"/></dc:title>
							<dc:creator></dc:creator>
							<dc:description>
								<xsl:variable name="abstract">
									<xsl:copy-of select="/un:unece-standard/un:preface/un:abstract//text()"/>
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
			
			<!-- Cover Page -->
			<fo:page-sequence master-reference="cover-page" force-page-count="even">				
				<fo:flow flow-name="xsl-region-body">
					<fo:block-container border-bottom="0.5pt solid black" margin-bottom="16pt" height="4mm">
						<fo:block text-align-last="justify" >
							<fo:inline padding-right="25mm">&#x200a;</fo:inline>
							<xsl:text>United Nations</xsl:text>
							<fo:inline keep-together.within-line="always" padding-right="32mm">
								<fo:leader leader-pattern="space"/>
								<xsl:value-of select="/un:unece-standard/un:bibdata/un:docidentifier"/>
							</fo:inline>
						</fo:block>
					</fo:block-container>
					<fo:block>
						<fo:table table-layout="fixed" width="100%">
							<fo:table-column column-width="26mm"/>
							<fo:table-column column-width="95mm"/>
							<fo:table-column column-width="49mm"/>
							<fo:table-body>
								<fo:table-row>
									<fo:table-cell>
										<fo:block>&#xA0;</fo:block>
									</fo:table-cell>
									<fo:table-cell display-align="after" padding-bottom="-1mm">
										<fo:block font-size="18pt" font-weight="bold"> Economic and Social Council</fo:block>
									</fo:table-cell>
									<fo:table-cell display-align="after">
										<fo:block font-size="10pt">
											<xsl:text>Distr.: </xsl:text><xsl:value-of select="/un:unece-standard/un:bibdata/un:ext/un:distribution"/>
										</fo:block>
									</fo:table-cell>
								</fo:table-row>
								<fo:table-row height="13mm">
									<fo:table-cell>
										<fo:block>&#xA0;</fo:block>
									</fo:table-cell>
									<fo:table-cell>
										<fo:block>&#xA0;</fo:block>
									</fo:table-cell>
									<fo:table-cell display-align="after">
										<fo:block font-size="10pt" margin-bottom="12pt">
											<xsl:value-of select="/un:unece-standard/un:bibdata/un:version/un:revision-date"/>
										</fo:block>
									</fo:table-cell>
								</fo:table-row>
							</fo:table-body>
						</fo:table>
					</fo:block>
					<fo:block margin-bottom="10pt">&#xA0;</fo:block>
					<fo:block-container font-weight="bold" border-top="2.25pt solid black" border-bottom="2.25pt solid black">
						<fo:block padding-top="0.5mm" margin-bottom="12pt">Economic Commision for Europe</fo:block>
						<fo:block margin-bottom="12pt">UNECE Executive Committee</fo:block>
						<fo:block margin-bottom="12pt"><xsl:value-of select="/un:unece-standard/un:bibdata/un:ext/un:editorialgroup/un:committee"/></fo:block>
						<fo:block margin-bottom="10pt">&#xA0;</fo:block>
					</fo:block-container>
					<fo:block font-weight="bold" padding-top="0.5mm" margin-bottom="12pt">
						<!-- Example: 24 -> Twenty-fourth session -->
						<xsl:call-template name="number-to-words">
							<xsl:with-param name="number" select="/un:unece-standard/un:bibdata/un:ext/un:session/un:number"/>
							<xsl:with-param name="first" select="'true'"/>
						</xsl:call-template>
						<xsl:text>session</xsl:text>
					</fo:block>
					<fo:block margin-bottom="12pt"><xsl:value-of select="/un:unece-standard/un:bibdata/un:ext/un:session/un:date"/></fo:block>
					<fo:block margin-bottom="12pt"><xsl:value-of select="/un:unece-standard/un:bibdata/un:docidentifier"/></fo:block>
					<fo:block margin-bottom="12pt">&#xA0;</fo:block>
					<fo:block-container font-weight="bold" margin-left="25mm">
						<fo:block margin-left="-25mm">
							<fo:block font-size="16pt" margin-bottom="12pt">
								<xsl:value-of select="/un:unece-standard/un:bibdata/un:title[@language = 'en' and @type = 'main']"/>
							</fo:block>
							<fo:block margin-bottom="12pt">
								<xsl:value-of select="/un:unece-standard/un:bibdata/un:title[@language = 'en' and @type = 'subtitle']"/>
							</fo:block>
							<fo:block margin-bottom="12pt">
								<xsl:text>Developed in Collaboration with </xsl:text><xsl:value-of select="/un:unece-standard/un:bibdata/un:ext/un:session/un:collaborator"/>
							</fo:block>
						</fo:block>
					</fo:block-container>
					<fo:block>
						<fo:table table-layout="fixed" width="100%" border="0.5pt solid black">
							<fo:table-column column-width="25mm"/>
							<fo:table-column column-width="147mm"/>
							<fo:table-body>
								<fo:table-row>
									<fo:table-cell padding-left="0.5mm">
										<fo:block font-style="italic" margin-bottom="12pt">Summary</fo:block>
									</fo:table-cell>
									<fo:table-cell>
										<fo:block>&#xA0;</fo:block>
									</fo:table-cell>
								</fo:table-row>
								<fo:table-row>
									<fo:table-cell>
										<fo:block>&#xA0;</fo:block>
									</fo:table-cell>
									<fo:table-cell padding-bottom="-12pt" padding-right="3mm">
										<fo:block line-height="115%"><xsl:apply-templates select="/un:unece-standard/un:preface/un:abstract"/></fo:block>
									</fo:table-cell>
								</fo:table-row>
							</fo:table-body>
						</fo:table>
					</fo:block>
					<fo:block margin-bottom="12pt">&#xA0;</fo:block>
					<fo:block margin-bottom="12pt">&#xA0;</fo:block>
					<fo:block margin-bottom="12pt">&#xA0;</fo:block>
					<fo:block margin-bottom="12pt">&#xA0;</fo:block>
					<fo:block margin-bottom="12pt">&#xA0;</fo:block>
					<fo:block><xsl:value-of select="/un:unece-standard/un:bibdata/un:ext/un:session/un:id"/></fo:block>
				</fo:flow>
			</fo:page-sequence>
			<!-- End Cover Page -->
			
			
			<!-- Document Pages -->
			<fo:page-sequence master-reference="document" initial-page-number="1" format="1" force-page-count="no-force" line-height="115%">
				<fo:static-content flow-name="xsl-footnote-separator">
					<fo:block>
						<fo:leader leader-pattern="rule" leader-length="30%"/>
					</fo:block>
				</fo:static-content>
				<xsl:call-template name="insertHeaderFooter"/>
				<fo:flow flow-name="xsl-region-body">
					
					<xsl:text disable-output-escaping="yes">&lt;!--</xsl:text>
						DEBUG
						contents=<xsl:copy-of select="xalan:nodeset($contents)"/>
					<xsl:text disable-output-escaping="yes">--&gt;</xsl:text>
					
					<fo:block>
						<xsl:apply-templates select="/un:unece-standard/un:sections/*"/>
						<xsl:apply-templates select="/un:unece-standard/un:annex"/>
					</fo:block>
					
					
					<fo:block-container margin-left="60mm" width="45mm" border-bottom="1pt solid black">
						<fo:block>&#xA0;</fo:block>
					</fo:block-container>
					
					
					
				</fo:flow>
			</fo:page-sequence>
			<!-- End Document Pages -->
			
		</fo:root>
	</xsl:template> 

	<!-- ============================= -->
	<!-- CONTENTS                                       -->
	<!-- ============================= -->
	<xsl:template match="node()" mode="contents">
		<xsl:apply-templates mode="contents"/>
	</xsl:template>
	
	<xsl:template match="un:unece-standard/un:sections/*" mode="contents">
		<xsl:apply-templates mode="contents"/>
	</xsl:template>
	
	
	<!-- Any node with title element - clause, definition, annex,... -->
	<xsl:template match="un:title | un:preferred" mode="contents">
		<xsl:variable name="id">
			<xsl:choose>
				<xsl:when test="../@id">
					<xsl:value-of select="../@id"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="text()"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		
		<!-- <xsl:message>
			level=<xsl:value-of select="$level"/>=<xsl:value-of select="."/>
		</xsl:message> -->
		
		<xsl:variable name="section">
			<xsl:call-template name="getSection"/>
		</xsl:variable>
			
		
		<xsl:variable name="type">
			<xsl:value-of select="local-name(..)"/>
		</xsl:variable>
		
		<item id="{$id}" level="{$level}" section="{$section}" display="false" type="{$type}">
			<xsl:if test="$type = 'clause'">
				<xsl:attribute name="section">
					<xsl:text>Clause </xsl:text>
					<xsl:choose>
						<xsl:when test="ancestor::un:sections">
							<!-- 1, 2, 3, 4, ... from main section (not annex ...) -->
							<xsl:choose>
								<xsl:when test="$level = 1">
									<xsl:number format="I" count="//un:sections/un:clause"/>
								</xsl:when>
								<xsl:when test="$level = 2">
									<xsl:number format="I." count="//un:sections/un:clause"/>
									<xsl:number format="A" count="//un:sections/un:clause/un:clause[un:title]"/>
								</xsl:when>
								<xsl:when test="$level &gt;= 3">
									<xsl:number format="I." count="//un:sections/un:clause"/>
									<xsl:number format="A." count="//un:sections/un:clause/un:clause[un:title]"/>
									<xsl:number format="1" count="//un:sections/un:clause/un:clause/un:clause[un:title]"/>
								</xsl:when>
								<xsl:otherwise>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="ancestor::un:annex">
							<xsl:choose>
								<xsl:when test="$level = 1">
									<xsl:text>Annex  </xsl:text>
									<xsl:number format="I" level="any" count="un:annex"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:variable name="annex_id" select="ancestor::un:annex/@id"/>
									<xsl:number format="1." count="//un:annex[@id = $annex_id]/un:clause[un:title]"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				
			</xsl:if>
			<xsl:value-of select="."/>
		</item>
		
		<xsl:apply-templates mode="contents"/>
	</xsl:template>
	
	<xsl:template match="un:bibitem" mode="contents"/>

	<xsl:template match="un:references" mode="contents">
		<xsl:apply-templates mode="contents"/>
	</xsl:template>

	
	<xsl:template match="un:figure" mode="contents">
		<item level="" id="{@id}" type="figure">
			<xsl:attribute name="section">
				<xsl:text>Figure </xsl:text>
				<xsl:choose>
					<xsl:when test="ancestor::un:annex">
						<xsl:choose>
							<xsl:when test="count(//un:annex) = 1">
								<xsl:value-of select="/un:unece-standard/un:bibdata/un:ext/un:structuredidentifier/un:annexid"/><xsl:number format="-1" level="any" count="un:annex//un:figure"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:number format="A.1-1" level="multiple" count="un:annex | un:figure"/>
							</xsl:otherwise>
						</xsl:choose>		
					</xsl:when>
					<xsl:when test="ancestor::un:figure">
						<xsl:for-each select="parent::*[1]">
							<xsl:number format="1" level="any" count="un:figure[not(parent::un:figure)]"/>
						</xsl:for-each>
						<xsl:number format="-a"  count="un:figure"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:number format="1" level="any" count="un:figure[not(parent::un:figure)]"/>
						<!-- <xsl:number format="1.1-1" level="multiple" count="un:annex | un:figure"/> -->
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:value-of select="un:name"/>
		</item>
	</xsl:template>
	
	<xsl:template match="un:table" mode="contents">
		<xsl:variable name="annex-id" select="ancestor::un:annex/@id"/>
		<item level="" id="{@id}" display="false" type="table">
			<xsl:attribute name="section">
				<xsl:text>Table </xsl:text>
				<xsl:choose>
					<xsl:when test="ancestor::*[local-name()='executivesummary']"> <!-- NIST -->
							<xsl:text>ES-</xsl:text><xsl:number format="1" count="*[local-name()='executivesummary']//*[local-name()='table']"/>
						</xsl:when>
					<xsl:when test="ancestor::*[local-name()='annex']">
						<xsl:number format="I." count="un:annex"/>
						<xsl:number format="1" level="any" count="un:table[ancestor::un:annex[@id = $annex-id]]"/>
					</xsl:when>
					<xsl:otherwise>
						<!-- <xsl:number format="1"/> -->
						<xsl:number format="1" level="any" count="*[local-name()='sections']//*[local-name()='table']"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:apply-templates select="un:name"/>
		</item>
	</xsl:template>
	
	
	<xsl:template match="un:formula" mode="contents">
		<item level="" id="{@id}" display="false">
			<xsl:attribute name="section">
				<xsl:text>Formula (</xsl:text><xsl:number format="A.1" level="multiple" count="un:annex | un:formula"/><xsl:text>)</xsl:text>
			</xsl:attribute>
		</item>
	</xsl:template>

	<xsl:template match="un:example" mode="contents">
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		<xsl:variable name="section">
			<xsl:call-template name="getSection"/>
		</xsl:variable>
		
		<xsl:variable name="parent-element" select="local-name(..)"/>
		<item level="" id="{@id}" display="false" type="Example" section="{$section}">
			<xsl:attribute name="parent">
				<xsl:choose>
					<xsl:when test="$parent-element = 'clause'">Clause</xsl:when>
					<xsl:otherwise></xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
		</item>
		<xsl:apply-templates mode="contents"/>
	</xsl:template>
	
	<xsl:template match="un:terms" mode="contents">
		<item level="" id="{@id}" display="false" type="Terms">
			<xsl:if test="ancestor::un:annex">
				<xsl:attribute name="section">
					<xsl:text>Appendix </xsl:text><xsl:number format="A" count="un:annex"/>
				</xsl:attribute>
			</xsl:if>
		</item>
	</xsl:template>
	
	<xsl:template match="un:references" mode="contents">
		<item level="" id="{@id}" display="false" type="References">
			<xsl:if test="ancestor::un:annex">
				<xsl:attribute name="section">
					<xsl:text>Appendix </xsl:text><xsl:number format="A" count="un:annex"/>
				</xsl:attribute>
			</xsl:if>
		</item>
	</xsl:template>
	
	<xsl:template match="un:admonition" mode="contents">
		<item level="" id="{@id}" display="false" type="Box">
			<xsl:attribute name="section">
				<xsl:variable name="num">
					<xsl:number />
				</xsl:variable>
				<xsl:text>Box </xsl:text><xsl:value-of select="$num - 1"/>
			</xsl:attribute>
		</item>
	</xsl:template>
	
	<!-- ============================= -->
	<!-- ============================= -->
		
		
	<!-- ============================= -->
	<!-- PARAGRAPHS                                    -->
	<!-- ============================= -->	
	
	<xsl:template match="un:preface//un:p">
		<fo:block margin-bottom="12pt">
			<xsl:attribute name="text-align">
				<xsl:choose>
					<xsl:when test="@align"><xsl:value-of select="@align"/></xsl:when>
					<xsl:otherwise>left</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<!-- <xsl:choose>
				<xsl:when test="ancestor::un:sections">
					<fo:inline padding-right="10mm"><xsl:number format="1. " level="any" count="un:sections//un:clause/un:p"/></fo:inline>
				</xsl:when>
				<xsl:when test="ancestor::un:annex">
					<xsl:variable name="annex_id" select="ancestor::un:annex/@id"/>
					<fo:inline padding-right="10mm"><xsl:number format="1. " level="any" count="un:annex[@id = $annex_id]//un:clause/un:p"/></fo:inline>
				</xsl:when>
			</xsl:choose> -->
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="un:p">
	
		<fo:list-block provisional-distance-between-starts="13.5mm" margin-bottom="12pt">
			<xsl:attribute name="text-align">
				<xsl:choose>
					<xsl:when test="@align"><xsl:value-of select="@align"/></xsl:when>
					<xsl:otherwise>left</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<fo:list-item>
				<fo:list-item-label end-indent="label-end()">
					<fo:block>
						<xsl:choose>
							<xsl:when test="ancestor::un:sections">
								<xsl:number format="1. " level="any" count="un:sections//un:clause/un:p"/>
							</xsl:when>
							<xsl:when test="ancestor::un:annex">
								<xsl:variable name="annex_id" select="ancestor::un:annex/@id"/>
								<xsl:number format="1. " level="any" count="un:annex[@id = $annex_id]//un:clause/un:p"/>
							</xsl:when>
						</xsl:choose>
					</fo:block>
				</fo:list-item-label>
				<fo:list-item-body text-indent="body-start()">
					<fo:block>
						<xsl:text> </xsl:text><xsl:apply-templates />
					</fo:block>
				</fo:list-item-body>
			</fo:list-item>
		</fo:list-block>
	</xsl:template>
	
	<xsl:template match="text()">
		<xsl:value-of select="."/>
	</xsl:template>
	
	<xsl:template match="un:title/un:fn | un:p/un:fn[not(ancestor::un:table)]" priority="2">
		<fo:footnote keep-with-previous.within-line="always">
			<xsl:variable name="number">
				<xsl:number level="any" count="un:fn[not(ancestor::un:table)]"/>
			</xsl:variable>
			<fo:inline font-size="60%" keep-with-previous.within-line="always" vertical-align="super">
				<fo:basic-link internal-destination="footnote_{@reference}_{$number}" fox:alt-text="footnote {@reference} {$number}">
					<xsl:value-of select="$number + count(//un:bibitem/un:note)"/>
				</fo:basic-link>
			</fo:inline>
			<fo:footnote-body>
				<fo:block font-size="9pt" line-height="125%" font-weight="normal" text-indent="0">
					<fo:inline id="footnote_{@reference}_{$number}" font-size="60%" keep-with-next.within-line="always" vertical-align="super"> <!-- alignment-baseline="hanging" -->
						<xsl:value-of select="$number + count(//un:bibitem/un:note)"/>
					</fo:inline>
					<xsl:for-each select="un:p">
						<xsl:apply-templates />
					</xsl:for-each>
				</fo:block>
			</fo:footnote-body>
		</fo:footnote>
	</xsl:template>
	
	<xsl:template match="un:fn/un:p">
		<fo:block>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="un:ul | un:ol">
		<fo:list-block provisional-distance-between-starts="6.5mm">
			<xsl:apply-templates />
		</fo:list-block>
		<xsl:apply-templates select="./un:note" mode="process"/>
	</xsl:template>
	
	<xsl:template match="un:ul//un:note |  un:ol//un:note"/>
	<xsl:template match="un:ul//un:note/un:p  | un:ol//un:note/un:p" mode="process">
		<fo:block font-size="11pt" margin-top="4pt">
			<xsl:text>NOTE </xsl:text>
			<xsl:if test="../following-sibling::un:note or ../preceding-sibling::un:note">
					<xsl:number count="un:note"/><xsl:text> </xsl:text>
				</xsl:if>
			<xsl:text>– </xsl:text>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="un:li">
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		<fo:list-item>
			<fo:list-item-label end-indent="label-end()">
				<fo:block>
					<xsl:choose>
						<xsl:when test="local-name(..) = 'ul'">&#x2014;</xsl:when> <!-- dash --> 
						<!-- <xsl:when test="local-name(..) = 'ul'">•</xsl:when> -->
						<xsl:otherwise> <!-- for ordered lists -->
							<xsl:choose>
								<xsl:when test="../@type = 'arabic'">
									<xsl:number format="a)"/>
								</xsl:when>
								<xsl:when test="../@type = 'alphabet'">
									<xsl:number format="1)"/>
								</xsl:when>
								<xsl:when test="ancestor::*[un:annex]">
									<xsl:choose>
										<xsl:when test="$level = 1">
											<xsl:number format="a)"/>
										</xsl:when>
										<xsl:when test="$level = 2">
											<xsl:number format="i)"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:number format="1.)"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<xsl:otherwise>
									<xsl:number format="1."/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</fo:block>
			</fo:list-item-label>
			<fo:list-item-body start-indent="body-start()">
				<xsl:apply-templates />
				<xsl:apply-templates select=".//un:note" mode="process"/>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>
	
	<xsl:template match="un:li//un:p">
		<fo:block margin-bottom="12pt">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="un:link">
		<fo:basic-link external-destination="{@target}" color="blue" text-decoration="underline" fox:alt-text="{@target}">
			<xsl:choose>
				<xsl:when test="normalize-space(.) = ''">
					<xsl:value-of select="@target"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates />
				</xsl:otherwise>
			</xsl:choose>
		</fo:basic-link>
	</xsl:template>
	
	<xsl:template match="un:xref">
		<xsl:variable name="section" select="xalan:nodeset($contents)//item[@id = current()/@target]/@section"/>
		<xsl:variable name="type" select="xalan:nodeset($contents)//item[@id = current()/@target]/@type"/>
		<fo:basic-link internal-destination="{@target}" text-decoration="underline" color="blue" fox:alt-text="{@target}">
			<xsl:choose>
				<xsl:when test="$section != ''"><xsl:value-of select="$section"/></xsl:when>
				<xsl:otherwise>???</xsl:otherwise>
			</xsl:choose>
      </fo:basic-link>
	</xsl:template>
	
	<xsl:template match="un:admonition">
		<fo:block-container border="0.25pt solid black" margin-left="16mm" margin-right="16mm" padding-top="3mm">
			<fo:block id="{@id}" font-size="11pt" font-weight="bold" margin-left="-10mm" margin-right="-10mm" text-align="center" margin-bottom="6pt" keep-with-next="always">
				<xsl:variable name="num">
					<xsl:number />
				</xsl:variable>
				<xsl:text>Box </xsl:text><xsl:value-of select="$num - 1"/><xsl:text> — </xsl:text><xsl:apply-templates select="un:name" mode="process"/>
			</fo:block>
			<fo:block margin-left="-12mm" margin-right="-12mm">
				<xsl:apply-templates />
			</fo:block>
		</fo:block-container>
		<fo:block margin-bottom="6pt">&#xA0;</fo:block>
	</xsl:template>
	
	<xsl:template match="un:admonition/un:name"/>
	<xsl:template match="un:admonition/un:name" mode="process">
		<xsl:apply-templates />
	</xsl:template>
	
	<xsl:template match="un:admonition/un:p">
		<fo:block margin-bottom="12pt"><xsl:apply-templates /></fo:block>
	</xsl:template>
	
	<!-- ============================= -->	
	<!-- ============================= -->	
	
	
	<xsl:template match="un:unece-standard/un:sections/*">
		<xsl:variable name="num"><xsl:number /></xsl:variable>
		<fo:block>
			<xsl:if test="$num = 1">
				<xsl:attribute name="margin-top">18pt</xsl:attribute>
			</xsl:if>
			<xsl:variable name="sectionNum"><xsl:number count="*"/></xsl:variable>
			<xsl:apply-templates>
				<xsl:with-param name="sectionNum" select="$sectionNum"/>
			</xsl:apply-templates>
		</fo:block>
		<!--  -->
	</xsl:template>
	
	
	<xsl:template match="/un:unece-standard/un:annex">
		<fo:block break-after="page"/>
		<xsl:variable name="num"><xsl:number /></xsl:variable>
		
			<!-- <fo:block-container border-bottom="0.5pt solid black">
				<fo:block>&#xA0;</fo:block>
			</fo:block-container>
			<fo:block margin-bottom="12pt">&#xA0;</fo:block> -->
		
		<fo:block>
			<xsl:if test="$num = 1">
				<xsl:attribute name="margin-top">3pt</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="un:title">
		<xsl:variable name="id">
			<xsl:choose>
				<xsl:when test="../@id">
					<xsl:value-of select="../@id"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="text()"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		
		<xsl:variable name="font-size">
			<xsl:choose>
				<xsl:when test="$level = 1 and ancestor::un:preface">14pt</xsl:when>
				<xsl:when test="$level = 1 and ancestor::un:annex">18pt</xsl:when>
				<xsl:when test="$level = 2 and ancestor::un:annex">12pt</xsl:when>
				<xsl:when test="$level = 1">13pt</xsl:when>
				<xsl:when test="$level = 2">12pt</xsl:when>
				<xsl:otherwise>11pt</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="section">
			<xsl:call-template name="getSection"/>
		</xsl:variable>
				
		<xsl:choose>
			<xsl:when test="ancestor::un:preface">
				<fo:block id="{$id}" font-size="{$font-size}" font-weight="bold" margin-top="3pt" margin-bottom="16pt" keep-with-next="always">
					<xsl:apply-templates />
				</fo:block>
			</xsl:when>
			<xsl:when test="ancestor::un:sections or (ancestor::un:annex and $level &gt;= 2)">
				<fo:block id="{$id}" font-size="{$font-size}" font-weight="bold" space-before="13.5pt" margin-bottom="12pt" text-indent="-9.5mm" keep-with-next="always">
					<fo:list-block provisional-distance-between-starts="9.5mm">
						<fo:list-item>
							<fo:list-item-label end-indent="label-end()">
								<fo:block>
									<xsl:value-of select="$section"/>
								</fo:block>
							</fo:list-item-label>
							<fo:list-item-body start-indent="body-start()">
								<fo:block>
									<xsl:apply-templates />
								</fo:block>
							</fo:list-item-body>
						</fo:list-item>
					</fo:list-block>
				</fo:block>
			</xsl:when>
			<xsl:when test="ancestor::un:annex and $level = 1">
				<fo:block id="{$id}" font-size="{$font-size}" font-weight="bold" space-before="3pt" margin-bottom="12pt" keep-with-next="always" line-height="22pt">
					<xsl:value-of select="$section"/>
					<xsl:value-of select="$linebreak"/>
					<xsl:apply-templates />
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<fo:block id="{$id}" font-size="{$font-size}" font-weight="bold" text-align="left" keep-with-next="always">
						<fo:inline><xsl:value-of select="$section"/></fo:inline>
						<xsl:apply-templates />
					</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- ============================ -->
	<!-- for further use -->
	<!-- ============================ -->
	<xsl:template match="un:recommendation">
		<fo:block margin-left="20mm">
			<fo:block font-weight="bold">
				<xsl:text>Recommendation </xsl:text>
				<xsl:choose>
					<xsl:when test="ancestor::un:sections">
						<xsl:number level="any" count="un:sections//un:recommendation"/>
					</xsl:when>
					<xsl:when test="ancestor::*[local-name()='annex']">
						<xsl:variable name="annex-id" select="ancestor::*[local-name()='annex']/@id"/>
						<xsl:number format="A-" count="un:annex"/>
						<xsl:number format="1" level="any" count="un:recommendation[ancestor::un:annex[@id = $annex-id]]"/>						
						<!-- <xsl:number format="A-1" level="multiple" count="un:annex | un:recommendation"/> -->
					</xsl:when>
				</xsl:choose>
				<xsl:text>:</xsl:text>
			</fo:block>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	
	<xsl:template match="un:bibitem">
		<fo:block  id="{@id}" margin-top="6pt" margin-left="14mm" text-indent="-14mm">
			<fo:inline padding-right="5mm">[<xsl:value-of select="un:docidentifier"/>]</fo:inline><xsl:value-of select="un:docidentifier"/>
				<xsl:if test="un:title">
				<fo:inline font-style="italic">
						<xsl:text>, </xsl:text>
						<xsl:choose>
							<xsl:when test="un:title[@type = 'main' and @language = 'en']">
								<xsl:value-of select="un:title[@type = 'main' and @language = 'en']"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="un:title"/>
							</xsl:otherwise>
						</xsl:choose>
					</fo:inline>
				</xsl:if>
				<xsl:apply-templates select="un:formattedref"/>
			</fo:block>
	</xsl:template>
	<xsl:template match="un:bibitem/un:docidentifier"/>
	
	<xsl:template match="un:bibitem/un:title"/>
	
	<xsl:template match="un:formattedref">
		<xsl:text>, </xsl:text><xsl:apply-templates />
	</xsl:template>
	
	
	<xsl:template match="*[local-name()='tt']">
		<xsl:variable name="element-name">
			<xsl:choose>
				<xsl:when test="normalize-space(ancestor::un:p[1]//text()[not(parent::un:tt)]) != ''">fo:inline</xsl:when>
				<xsl:otherwise>fo:block</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:element name="{$element-name}">
			<xsl:attribute name="font-family">Courier</xsl:attribute>
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:apply-templates />
		</xsl:element>
	</xsl:template>


	<xsl:template match="un:figure">
		<fo:block-container id="{@id}">
			<fo:block>
				<xsl:apply-templates />
			</fo:block>
			<xsl:call-template name="fn_display_figure"/>
			<xsl:for-each select="un:note//un:p">
				<xsl:call-template name="note"/>
			</xsl:for-each>
			<fo:block font-size="11pt" font-weight="bold" text-align="center" margin-bottom="6pt" keep-with-previous="always">
				<xsl:text>Figure </xsl:text>
				<xsl:choose>
					<xsl:when test="ancestor::un:annex">
						<xsl:choose>
							<xsl:when test="count(//un:annex) = 1">
								<xsl:value-of select="/un:unece-standard/un:bibdata/un:ext/un:structuredidentifier/un:annexid"/><xsl:number format="-1" level="any" count="un:annex//un:figure"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:number format="A-1-1" level="multiple" count="un:annex | un:figure"/>
							</xsl:otherwise>
						</xsl:choose>		
					</xsl:when>
					<xsl:when test="ancestor::un:figure">
						<xsl:for-each select="parent::*[1]">
							<xsl:number format="1" level="any" count="un:figure[not(parent::un:figure)]"/>
						</xsl:for-each>
						<xsl:number format="-a"  count="un:figure"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:number format="1" level="any" count="un:figure[not(parent::un:figure)]"/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:if test="un:name">
					<xsl:text> — </xsl:text>
					<xsl:apply-templates select="un:name" mode="process"/>
				</xsl:if>
			</fo:block>
		</fo:block-container>
	</xsl:template>
	
	<xsl:template match="un:figure/un:name"/>
	<xsl:template match="un:figure/un:name" mode="process">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="un:figure/un:fn" priority="2"/>
	<xsl:template match="un:figure/un:note"/>

	
	<xsl:template match="un:image">
		<fo:block text-align="center" margin-bottom="12pt" keep-with-next="always">
			<fo:external-graphic src="{@src}"
				width="75%"
				content-height="100%"
				content-width="scale-to-fit" scaling="uniform"/>
		</fo:block>
	</xsl:template>
	
	
	<!-- Examples:
	[b-ASM]	b-ASM, http://www.eecs.umich.edu/gasm/ (accessed 20 March 2018).
	[b-Börger & Stärk]	b-Börger & Stärk, Börger, E., and Stärk, R. S. (2003), Abstract State Machines: A Method for High-Level System Design and Analysis, Springer-Verlag.
	-->
	<xsl:template match="un:annex//un:bibitem">
		<fo:block id="{@id}" margin-top="6pt" margin-left="12mm" text-indent="-12mm">
				<xsl:if test="un:formattedref">
					<xsl:choose>
						<xsl:when test="un:docidentifier[@type = 'metanorma']">
							<xsl:attribute name="margin-left">0</xsl:attribute>
							<xsl:attribute name="text-indent">0</xsl:attribute>
							<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
							<!-- create list -->
							<fo:list-block >
								<fo:list-item>
									<fo:list-item-label end-indent="label-end()">
										<fo:block>
											<xsl:apply-templates select="un:docidentifier[@type = 'metanorma']" mode="process"/>
										</fo:block>
									</fo:list-item-label>
									<fo:list-item-body start-indent="body-start()">
										<fo:block margin-left="3mm">
											<xsl:apply-templates select="un:formattedref"/>
										</fo:block>
									</fo:list-item-body>
								</fo:list-item>
							</fo:list-block>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="un:formattedref"/>
							<xsl:apply-templates select="un:docidentifier[@type != 'metanorma' or not(@type)]" mode="process"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
				<xsl:if test="un:title">
					<xsl:for-each select="un:contributor">
						<xsl:value-of select="un:organization/un:name"/>
						<xsl:if test="position() != last()">, </xsl:if>
					</xsl:for-each>
					<xsl:text> (</xsl:text>
					<xsl:variable name="date">
						<xsl:choose>
							<xsl:when test="un:date[@type='issued']">
								<xsl:value-of select="un:date[@type='issued']/un:on"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of  select="un:date/un:on"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:value-of select="$date"/>
					<xsl:text>) </xsl:text>
					<fo:inline font-style="italic"><xsl:value-of select="un:title"/></fo:inline>
					<xsl:if test="un:contributor[un:role/@type='publisher']/un:organization/un:name">
						<xsl:text> (</xsl:text><xsl:value-of select="un:contributor[un:role/@type='publisher']/un:organization/un:name"/><xsl:text>)</xsl:text>
					</xsl:if>
					<xsl:text>, </xsl:text>
					<xsl:value-of select="$date"/>
					<xsl:text>. </xsl:text>
					<xsl:value-of select="un:docidentifier"/>
					<xsl:value-of select="$linebreak"/>
					<xsl:value-of select="un:uri"/>
				</xsl:if>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="un:annex//un:bibitem//un:formattedref">
		<xsl:apply-templates />
	</xsl:template>
	
	<xsl:template match="un:docidentifier[@type = 'metanorma']" mode="process">
		<xsl:apply-templates />
	</xsl:template>
	<xsl:template match="un:docidentifier[@type != 'metanorma' or not(@type)]" mode="process">
		<xsl:text> [</xsl:text><xsl:apply-templates /><xsl:text>]</xsl:text>
	</xsl:template>
	<xsl:template match="un:docidentifier"/>

	<xsl:template match="un:note/un:p | un:annex//un:note/un:p" name="note">
		<fo:block font-size="10pt" space-after="12pt" text-indent="0">
			<fo:inline padding-right="4mm"><xsl:text>NOTE </xsl:text>
			<xsl:if test="../following-sibling::un:note or ../preceding-sibling::un:note">
					<xsl:number count="un:note"/><xsl:text> </xsl:text>
				</xsl:if>
			</fo:inline>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>	
	
	<xsl:template match="un:termnote">
		<fo:block margin-top="4pt">
			<xsl:text>NOTE </xsl:text>
				<xsl:if test="following-sibling::un:termnote or preceding-sibling::un:termnote">
					<xsl:number/><xsl:text> </xsl:text>
				</xsl:if>
				<xsl:text>– </xsl:text>
				<xsl:apply-templates />
		</fo:block>
	</xsl:template>

	<xsl:template match="un:termnote/un:p">
		<xsl:apply-templates />
	</xsl:template>
	
	
	<xsl:template match="un:formula" name="formula">
		<fo:block id="{@id}" margin-top="6pt">
			<fo:table table-layout="fixed" width="100%">
				<fo:table-column column-width="95%"/>
				<fo:table-column column-width="5%"/>
				<fo:table-body>
					<fo:table-row>
						<fo:table-cell>
							<fo:block text-align="center">
								<xsl:if test="ancestor::un:annex">
									<xsl:attribute name="text-align">left</xsl:attribute>
									<xsl:attribute name="margin-left">7mm</xsl:attribute>
								</xsl:if>
								<xsl:apply-templates />
							</fo:block>
						</fo:table-cell>
						<fo:table-cell> <!--  display-align="center" -->
							<fo:block text-align="right">
								<xsl:if test="not(ancestor::un:annex)">
									<xsl:text>(</xsl:text><xsl:number level="any"/><xsl:text>)</xsl:text>
								</xsl:if>
								<xsl:if test="ancestor::un:annex">
									<xsl:variable name="annex-id" select="ancestor::un:annex/@id"/>
									<xsl:text>(</xsl:text>
									<xsl:number format="A-" count="un:annex"/>
									<xsl:number format="1" level="any" count="un:formula[ancestor::un:annex[@id = $annex-id]]"/>
									<xsl:text>)</xsl:text>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</fo:table-body>
			</fo:table>
			<fo:inline keep-together.within-line="always">
			</fo:inline>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="un:formula" mode="process">
		<xsl:call-template name="formula"/>
	</xsl:template>
	
	<xsl:template match="mathml:math">
		<fo:inline font-family="Cambria Math">
			<fo:instream-foreign-object> 
				<xsl:copy-of select="."/>
			</fo:instream-foreign-object>
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="un:example">
		<fo:block id="{@id}" font-size="10pt" font-weight="bold" margin-bottom="12pt">EXAMPLE</fo:block>
		<fo:block font-size="11pt" margin-top="12pt" margin-bottom="12pt" margin-left="15mm" >
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	<xsl:template match="un:example/un:p">
		<xsl:variable name="num"><xsl:number/></xsl:variable>
		<fo:block margin-bottom="12pt">
			<xsl:if test="$num = 1">
				<xsl:attribute name="margin-left">5mm</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="un:eref">
		<!-- <fo:inline color="blue"> -->
		<fo:basic-link internal-destination="{@bibitemid}" color="blue" fox:alt-text="{@citeas}">
			<xsl:if test="@type = 'footnote'">
				<xsl:attribute name="keep-together.within-line">always</xsl:attribute>
				<xsl:attribute name="font-size">80%</xsl:attribute>
				<xsl:attribute name="keep-with-previous.within-line">always</xsl:attribute>
				<xsl:attribute name="vertical-align">super</xsl:attribute>
			</xsl:if>
			<xsl:if test="@type = 'inline'">
				<xsl:attribute name="text-decoration">underline</xsl:attribute>
			</xsl:if>
			<xsl:text>[</xsl:text><xsl:value-of select="@citeas" disable-output-escaping="yes"/><xsl:text>]</xsl:text>
			<xsl:if test="un:locality">
				<xsl:text>, </xsl:text>
				<xsl:choose>
					<xsl:when test="un:locality/@type = 'section'">Section </xsl:when>
					<xsl:when test="un:locality/@type = 'clause'">Clause </xsl:when>
					<xsl:otherwise></xsl:otherwise>
				</xsl:choose>
				<xsl:apply-templates select="un:locality"/>
			</xsl:if>
		</fo:basic-link>
		<!-- </fo:inline> -->
	</xsl:template>
	
	
	<xsl:template match="un:terms[un:term[un:preferred and un:definition]]">
		<fo:block id="{@id}">
			<fo:table width="100%" table-layout="fixed">
				<fo:table-column column-width="22%"/>
				<fo:table-column column-width="78%"/>
				<fo:table-body>
					<xsl:apply-templates mode="table"/>
				</fo:table-body>
			</fo:table>
		</fo:block>
	</xsl:template>
	<xsl:template match="un:term" mode="table">
		<fo:table-row>
			<fo:table-cell padding-right="1mm">
				<fo:block margin-bottom="12pt">
					<xsl:apply-templates select="un:preferred"/>
				</fo:block>
			</fo:table-cell>
			<fo:table-cell>
				<fo:block margin-bottom="12pt">
					<xsl:apply-templates select="un:*[local-name(.) != 'preferred']"/>
				</fo:block>
			</fo:table-cell>
		</fo:table-row>
	</xsl:template>
	<xsl:template match="un:preferred">
		<fo:inline id="{../@id}">
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>
	<xsl:template match="un:definition/un:p">
		<fo:block>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="un:errata">
		<!-- <row>
					<date>05-07-2013</date>
					<type>Editorial</type>
					<change>Changed CA-9 Priority Code from P1 to P2 in <xref target="tabled2"/>.</change>
					<pages>D-3</pages>
				</row>
		-->
		<fo:table table-layout="fixed" width="100%" font-size="10pt" border="1pt solid black">
			<fo:table-column column-width="20mm"/>
			<fo:table-column column-width="23mm"/>
			<fo:table-column column-width="107mm"/>
			<fo:table-column column-width="15mm"/>
			<fo:table-body>
				<fo:table-row font-family="Arial" text-align="center" font-weight="bold" background-color="black" color="white">
					<fo:table-cell border="1pt solid black"><fo:block>Date</fo:block></fo:table-cell>
					<fo:table-cell border="1pt solid black"><fo:block>Type</fo:block></fo:table-cell>
					<fo:table-cell border="1pt solid black"><fo:block>Change</fo:block></fo:table-cell>
					<fo:table-cell border="1pt solid black"><fo:block>Pages</fo:block></fo:table-cell>
				</fo:table-row>
				<xsl:apply-templates />
			</fo:table-body>
		</fo:table>
	</xsl:template>
	
	<xsl:template match="un:errata/un:row">
		<fo:table-row>
			<xsl:apply-templates />
		</fo:table-row>
	</xsl:template>
	
	<xsl:template match="un:errata/un:row/*">
		<fo:table-cell border="1pt solid black" padding-left="1mm" padding-top="0.5mm">
			<fo:block><xsl:apply-templates /></fo:block>
		</fo:table-cell>
	</xsl:template>
	
	<xsl:template match="un:quote">
		<fo:block-container margin-left="7mm" margin-right="7mm">
			<xsl:apply-templates />
			<xsl:apply-templates select="un:author" mode="process"/>
		</fo:block-container>
	</xsl:template>
	
	<xsl:template match="un:quote/un:author"/>
	<xsl:template match="un:quote/un:p">
		<fo:block text-align="justify" margin-bottom="12pt">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	<xsl:template match="un:quote/un:author" mode="process">
		<fo:block text-align="right" margin-left="0.5in" margin-right="0.5in">
			<fo:inline>— </fo:inline>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="un:sourcecode">
		<fo:block font-family="Courier" font-size="10pt" margin-top="6pt" margin-bottom="6pt">
			<xsl:attribute name="white-space">pre</xsl:attribute>
			<xsl:attribute name="wrap-option">wrap</xsl:attribute>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="un:references">
		<fo:block>
			<xsl:if test="not(un:title)">
				<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
			</xsl:if>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	<!-- ============================ -->
	<!-- ============================ -->	
	
	<xsl:template name="insertHeaderFooter">
		<fo:static-content flow-name="header">
			<fo:block-container height="25mm" display-align="before">
				<fo:block font-weight="bold" padding-top="12.5mm" text-align="center">
					<xsl:value-of select="/un:unece-standard/un:bibdata/un:docidentifier"/>
				</fo:block>
				<fo:block-container  border-bottom="0.5pt solid black">
					<fo:block>&#xA0;</fo:block>
				</fo:block-container>
			</fo:block-container>
		</fo:static-content>
		<fo:static-content flow-name="footer">
			<fo:block-container height="10mm" display-align="after">
				<fo:block font-size="10pt" font-weight="bold" text-align="center" padding-bottom="5mm" ><fo:page-number/></fo:block>
			</fo:block-container>
		</fo:static-content>
	</xsl:template>


	<xsl:template name="getLevel">
		<xsl:variable name="level_total" select="count(ancestor::*)"/>
		<xsl:variable name="level">
			<xsl:choose>
				<xsl:when test="ancestor::un:preface">
					<xsl:value-of select="$level_total - 2"/>
				</xsl:when>
				<xsl:when test="ancestor::un:sections">
					<xsl:value-of select="$level_total - 2"/>
				</xsl:when>
				<xsl:when test="ancestor::un:bibliography">
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
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		
		<xsl:variable name="section">
			<xsl:choose>
				
				<xsl:when test="ancestor::un:sections">
					<!-- 1, 2, 3, 4, ... from main section (not annex ...) -->
					<xsl:choose>
						<xsl:when test="$level = 1">
							<xsl:number format="I." count="//un:sections/un:clause"/>
						</xsl:when>
						<xsl:when test="$level = 2">
							<xsl:number format="A." count="//un:sections/un:clause/un:clause[un:title]"/>
						</xsl:when>
						<xsl:when test="$level &gt;= 3">
							<xsl:number format="1." count="//un:sections/un:clause/un:clause/un:clause[un:title]"/>
						</xsl:when>
						<xsl:otherwise>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="ancestor::un:annex">
					<xsl:choose>
						<xsl:when test="$level = 1">
							<xsl:text>Annex  </xsl:text>
							<xsl:number format="I" level="any" count="un:annex"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="annex_id" select="ancestor::un:annex/@id"/>
							<xsl:number format="1." count="//un:annex[@id = $annex_id]/un:clause[un:title]"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$section"/>
	</xsl:template>	

	<xsl:template name="number-to-words">
		<xsl:param name="number" />
		<xsl:param name="first"/>
		<xsl:if test="$number != ''">
			<xsl:variable name="words">
				<words>
					<word cardinal="1">one-</word>
					<word ordinal="1">first </word>
					<word cardinal="2">two-</word>
					<word ordinal="2">second </word>
					<word cardinal="3">three-</word>
					<word ordinal="3">third </word>
					<word cardinal="4">four-</word>
					<word ordinal="4">fourth </word>
					<word cardinal="5">five-</word>
					<word ordinal="5">fifth </word>
					<word cardinal="6">six-</word>
					<word ordinal="6">sixth </word>
					<word cardinal="7">seven-</word>
					<word ordinal="7">seventh </word>
					<word cardinal="8">eight-</word>
					<word ordinal="8">eighth </word>
					<word cardinal="9">nine-</word>
					<word ordinal="9">ninth </word>
					<word ordinal="10">tenth </word>
					<word ordinal="11">eleventh </word>
					<word ordinal="12">twelfth </word>
					<word ordinal="13">thirteenth </word>
					<word ordinal="14">fourteenth </word>
					<word ordinal="15">fifteenth </word>
					<word ordinal="16">sixteenth </word>
					<word ordinal="17">seventeenth </word>
					<word ordinal="18">eighteenth </word>
					<word ordinal="19">nineteenth </word>
					<word cardinal="20">twenty-</word>
					<word ordinal="20">twentieth </word>				
					<word cardinal="30">thirty-</word>
					<word ordinal="30">thirtieth </word>
					<word cardinal="40">forty-</word>
					<word ordinal="40">fortieth </word>
					<word cardinal="50">fifty-</word>
					<word ordinal="50">fiftieth </word>
					<word cardinal="60">sixty-</word>
					<word ordinal="60">sixtieth </word>
					<word cardinal="70">seventy-</word>
					<word ordinal="70">seventieth </word>
					<word cardinal="80">eighty-</word>
					<word ordinal="80">eightieth </word>
					<word cardinal="90">ninety-</word>
					<word ordinal="90">ninetieth </word>
					<word cardinal="100">hundred-</word>
					<word ordinal="100">hundredth </word>
				</words>
			</xsl:variable>

			<xsl:variable name="ordinal" select="xalan:nodeset($words)//word[@ordinal = $number]/text()"/>
			
			<xsl:variable name="value">
				<xsl:choose>
					<xsl:when test="$ordinal != ''">
						<xsl:value-of select="$ordinal"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="$number &lt; 100">
								<xsl:variable name="decade" select="concat(substring($number,1,1), '0')"/>
								<xsl:variable name="digit" select="substring($number,2)"/>
								<xsl:value-of select="xalan:nodeset($words)//word[@cardinal = $decade]/text()"/>
								<xsl:value-of select="xalan:nodeset($words)//word[@ordinal = $digit]/text()"/>
							</xsl:when>
							<xsl:otherwise>
								<!-- more 100 -->
								<xsl:variable name="hundred" select="substring($number,1,1)"/>
								<xsl:variable name="digits" select="number(substring($number,2))"/>
								<xsl:value-of select="xalan:nodeset($words)//word[@cardinal = $hundred]/text()"/>
								<xsl:value-of select="xalan:nodeset($words)//word[@cardinal = '100']/text()"/>
								<xsl:call-template name="number-to-words">
									<xsl:with-param name="number" select="$digits"/>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="$first = 'true'">
					<xsl:value-of select="translate(substring($value, 1, 1), $lower, $upper)"/><xsl:value-of select="substring($value, 2)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$value"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	
</xsl:stylesheet>
