<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
											xmlns:fo="http://www.w3.org/1999/XSL/Format"
											xmlns:mn="https://www.metanorma.org/ns/standoc" 
											xmlns:mnx="https://www.metanorma.org/ns/xslt" 
											xmlns:mathml="http://www.w3.org/1998/Math/MathML" 
											xmlns:xalan="http://xml.apache.org/xalan"  
											xmlns:fox="http://xmlgraphics.apache.org/fop/extensions" 
											xmlns:redirect="http://xml.apache.org/xalan/redirect"
											xmlns:java="http://xml.apache.org/xalan/java"
											exclude-result-prefixes="java redirect"
											extension-element-prefixes="redirect"
											version="1.0">
	
	<xsl:attribute-set name="title-style">
		<!-- Note: font-size for level 1 title -->
		
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="font-size">16pt</xsl:attribute>
			<xsl:attribute name="margin-left">-14mm</xsl:attribute>
			<xsl:attribute name="font-family">Arial</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="line-height">130%</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="font-size">11.5pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="space-before">4.5mm</xsl:attribute>
			<xsl:attribute name="space-after">2mm</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
		</xsl:if>
		
		<xsl:if test="$namespace = 'pas'">
			<xsl:attribute name="font-size">18pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="color"><xsl:value-of select="$color_secondary_shade_1_PAS"/></xsl:attribute>
			<xsl:attribute name="space-before">0mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">17mm</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="keep-together.within-column">always</xsl:attribute>
		</xsl:if>
		
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="font-size">26pt</xsl:attribute>
			<xsl:attribute name="font-weight">normal</xsl:attribute>
			<xsl:attribute name="space-before">13.5pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="color">black</xsl:attribute>
			<xsl:attribute name="line-height">120%</xsl:attribute>
		</xsl:if>
		
		<xsl:if test="$namespace = 'csd'">
			<xsl:attribute name="font-size">13pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>		
			<xsl:attribute name="color">rgb(14, 26, 133)</xsl:attribute>
		</xsl:if>
		
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="space-before">18pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">14pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
		</xsl:if>
		
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="font-family">Arial</xsl:attribute>
			<xsl:attribute name="font-size">12pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="margin-bottom">24pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="keep-together.within-column">always</xsl:attribute>
		</xsl:if>
		
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="font-size">12pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="space-before">24pt</xsl:attribute>
			<xsl:attribute name="space-after">10pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
		</xsl:if>
		
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="font-size">12pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">left</xsl:attribute>
			<xsl:attribute name="space-before">18pt</xsl:attribute>
			<xsl:attribute name="space-after">6pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
		</xsl:if>
		
		<xsl:if test="$namespace = 'jcgm'">
			<xsl:attribute name="font-size">13pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="space-before">36pt</xsl:attribute>
			<xsl:attribute name="space-after">12pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>		
		</xsl:if>
		
		<xsl:if test="$namespace = 'jis'">
			<xsl:attribute name="font-family">IPAexGothic</xsl:attribute>
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="font-weight">normal</xsl:attribute>
			<xsl:attribute name="text-align">left</xsl:attribute>
			<xsl:attribute name="space-before">6.5mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
		</xsl:if>
		
		<xsl:if test="$namespace = 'nist-cswp' or $namespace = 'nist-sp'">
			<xsl:attribute name="font-size">12pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="font-family">Arial</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="text-align">left</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>		
		</xsl:if>
		
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="font-size">18pt</xsl:attribute>
			<xsl:attribute name="font-weight">normal</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="color"><xsl:value-of select="$color_text_title"/></xsl:attribute>
		</xsl:if>
		
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:attribute name="font-family">Lato</xsl:attribute>
			<xsl:attribute name="font-size">26pt</xsl:attribute>
			<xsl:attribute name="margin-top">18pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">18pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>		
		</xsl:if>
		
		<xsl:if test="$namespace = 'plateau'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">left</xsl:attribute>
			<xsl:attribute name="space-before">0mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
		</xsl:if>
		
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-size">22pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute> 
			<xsl:attribute name="space-before">25mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="color">black</xsl:attribute>
			<xsl:attribute name="line-height">125%</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- title-style -->

	<xsl:template name="refine_title-style">
		<xsl:param name="element-name"/>
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		
		<xsl:if test="$namespace = 'bipm'">
		
			<xsl:if test="$level = 1">
				<xsl:if test="parent::mn:annex or ancestor::mn:annex or parent::mn:abstract or ancestor::mn:preface">
					<xsl:attribute name="margin-bottom">84pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
		
			<xsl:if test="$level = 2">
				<xsl:attribute name="font-size">14pt</xsl:attribute>
				<xsl:attribute name="space-before">30pt</xsl:attribute>
				<xsl:attribute name="margin-bottom">10pt</xsl:attribute>
				<xsl:if test="ancestor::mn:annex">
					<xsl:attribute name="font-size">10.5pt</xsl:attribute>
					<xsl:attribute name="space-before">18pt</xsl:attribute>
					<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
					<xsl:if test="../@type = 'toc'">
						<xsl:attribute name="font-size">16pt</xsl:attribute>
						<xsl:attribute name="margin-bottom">29mm</xsl:attribute>
					</xsl:if>
				</xsl:if>
			</xsl:if>
			
			<xsl:if test="$level = 3">
				<xsl:attribute name="font-size">12pt</xsl:attribute>
				<xsl:attribute name="space-before">20pt</xsl:attribute>
				<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
				<xsl:if test="ancestor::mn:annex">
					<xsl:attribute name="font-size">10pt</xsl:attribute>
					<xsl:attribute name="space-before">12pt</xsl:attribute>
					<xsl:if test="../@type = 'toc'">
						<xsl:attribute name="font-size">9pt</xsl:attribute>
						<xsl:attribute name="space-before">0pt</xsl:attribute>
					</xsl:if>
				</xsl:if>
			</xsl:if>
			
			<xsl:if test="$level &gt;= 4">
				<xsl:attribute name="font-size">11pt</xsl:attribute>
				<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
				<xsl:if test="ancestor::mn:annex">
					<xsl:attribute name="font-size">9pt</xsl:attribute>
					<xsl:if test="$level = 4">
						<xsl:attribute name="space-before">12pt</xsl:attribute>
					</xsl:if>
					<xsl:if test="../@type = 'toc'">
						<xsl:attribute name="space-before">0pt</xsl:attribute>
					</xsl:if>
				</xsl:if>
			</xsl:if>
			
			<xsl:if test="local-name(preceding-sibling::*[1]) = 'clause'">
				<xsl:attribute name="id"><xsl:value-of select="preceding-sibling::*[1]/@id"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="@type = 'quoted'">
				<xsl:attribute name="font-weight">normal</xsl:attribute>
			</xsl:if>
			<!-- $namespace = 'bipm' -->
		</xsl:if>
		
		<xsl:if test="$namespace = 'bsi'">
			<xsl:if test="$level = 1">
				<xsl:if test="@ancestor = 'foreword' or @ancestor = 'executivesummary' or @ancestor = 'introduction'">
					<xsl:attribute name="font-size">18pt</xsl:attribute>
					<xsl:attribute name="space-after">5.5mm</xsl:attribute>
				</xsl:if>
				<xsl:if test="@ancestor = 'sections' and $doctype = 'expert-commentary'">
					<xsl:attribute name="font-size">14pt</xsl:attribute>
				</xsl:if>
				<xsl:if test="@ancestor = 'annex'">
					<xsl:attribute name="font-size">18pt</xsl:attribute>
					<xsl:attribute name="margin-left">-10mm</xsl:attribute>
					<xsl:attribute name="line-height">1.15</xsl:attribute>
					<xsl:attribute name="space-after">6mm</xsl:attribute>
				</xsl:if>
				<xsl:if test="@ancestor = 'bibliography'">
					<xsl:attribute name="font-size">13pt</xsl:attribute>
					<xsl:if test="preceding-sibling::mn:references">
						<xsl:attribute name="font-size">11.5pt</xsl:attribute>
					</xsl:if>
				</xsl:if>
			</xsl:if>
			
			<xsl:if test="$level &gt;= 2">
				<xsl:if test="@ancestor = 'foreword'">
					<xsl:attribute name="font-size">11pt</xsl:attribute>
					
				</xsl:if>
				<xsl:if test="@ancestor = 'introduction'">
					<xsl:attribute name="font-size">11pt</xsl:attribute>
				</xsl:if>
				<xsl:if test="@ancestor = 'bibliography'">
					<xsl:attribute name="font-size">10pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			
			<xsl:if test="$level = 2">
				<xsl:attribute name="space-before">2mm</xsl:attribute>
				<xsl:attribute name="space-after">6pt</xsl:attribute>
				<xsl:if test="@ancestor = 'foreword'">
					<xsl:attribute name="space-before">0mm</xsl:attribute>
				</xsl:if>
				<xsl:if test="@ancestor = 'sections'">
					<xsl:attribute name="font-size">11pt</xsl:attribute>
					<xsl:if test="preceding-sibling::*[1][self::mn:references]"><!-- Normative references -->
						<xsl:attribute name="font-size">inherit</xsl:attribute>
					</xsl:if>
					<xsl:if test="$doctype = 'expert-commentary'">
						<xsl:attribute name="font-size">11pt</xsl:attribute>
					</xsl:if>
				</xsl:if>
				<xsl:if test="@ancestor = 'annex'">
					<xsl:attribute name="font-size">13pt</xsl:attribute>
					<xsl:attribute name="space-before">4.5mm</xsl:attribute>
				</xsl:if>
				<xsl:if test="@ancestor = 'bibliography'">
					<xsl:attribute name="space-before">0mm</xsl:attribute>
				</xsl:if>
			</xsl:if>
			
			<xsl:if test="$level = 3">
				<xsl:if test="@ancestor = 'sections'">
					<xsl:attribute name="font-size">10.5pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			
			<xsl:if test="$level &gt;= 4">
				<xsl:if test="@ancestor = 'sections'">
					<xsl:attribute name="font-size">10pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			
			<xsl:if test="$level &gt;= 3">
				<xsl:attribute name="space-before">2mm</xsl:attribute>
				<xsl:attribute name="space-after">6pt</xsl:attribute>
				<xsl:if test="@ancestor = 'sections'">
					<xsl:if test="preceding-sibling::*[1][self::mn:terms]">
						<xsl:attribute name="font-size">11pt</xsl:attribute>
					</xsl:if>
					<xsl:if test="$doctype = 'expert-commentary'">
						<xsl:attribute name="font-size">10pt</xsl:attribute>
					</xsl:if>
				</xsl:if>
				<xsl:if test="@ancestor = 'annex'">
					<xsl:attribute name="font-size">11.5pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			
			<xsl:if test=". = 'Executive summary' or . = 'Executive Summary'">
				<xsl:attribute name="font-size">18pt</xsl:attribute>
				<xsl:attribute name="space-after">5.5mm</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="@type = 'section-title'">
				<xsl:attribute name="font-size">18pt</xsl:attribute>
				<xsl:attribute name="margin-left">-10mm</xsl:attribute>
				<xsl:attribute name="space-after">6mm</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="@inline-header = 'true'">
				<xsl:attribute name="space-after">0pt</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="@type = 'floating-title' or @type = 'section-title'">
				<xsl:copy-of select="@id"/>
			</xsl:if>
			
			<xsl:if test="$doctype = 'expert-commentary'">
				<xsl:attribute name="color">
					<xsl:choose>
						<xsl:when test="$level = '1'">rgb(206,42,39)</xsl:when>
						<xsl:otherwise>rgb(7,129,147)</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</xsl:if>
			<!-- $namespace = 'bsi' -->
		</xsl:if>
		
		<xsl:if test="$namespace = 'pas'">
			<!-- copy @id from empty preceding clause -->
			<xsl:copy-of select="preceding-sibling::*[1][self::mn:clause and count(node()) = 0]/@id"/>
			<xsl:if test="$level = 1">
				<xsl:attribute name="span">all</xsl:attribute>
				<xsl:attribute name="keep-with-next">auto</xsl:attribute>
				<xsl:if test="@ancestor = 'foreword'">
					<xsl:attribute name="font-size">31pt</xsl:attribute>
					<xsl:attribute name="font-weight">300</xsl:attribute>
					<xsl:attribute name="margin-bottom">12mm</xsl:attribute>
				</xsl:if>
				<xsl:if test="@ancestor = 'introduction'">
					<xsl:attribute name="font-size">31pt</xsl:attribute>
					<xsl:attribute name="font-weight">300</xsl:attribute>
					<xsl:attribute name="margin-bottom">13mm</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="following-sibling::mn:p[1][@align = 'span' or @columns = '1']">
				<xsl:attribute name="span">all</xsl:attribute>
			</xsl:if>
			<xsl:if test="@type = 'floating-title' or @type = 'section-title'">
				<xsl:copy-of select="@id"/>
			</xsl:if>
			<xsl:if test="$level = 2">
				<xsl:attribute name="font-size">12pt</xsl:attribute>
				<xsl:attribute name="space-before">4mm</xsl:attribute>
				<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="$level = 3">
				<xsl:attribute name="space-before">3mm</xsl:attribute>
				<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="$level &gt;= 3">
				<xsl:attribute name="font-size">9pt</xsl:attribute>
				<xsl:if test="@type = 'floating-title'">
					<xsl:attribute name="font-size">12pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$level &gt;= 4">
				<xsl:attribute name="space-before">0mm</xsl:attribute>
				<xsl:attribute name="margin-bottom">0mm</xsl:attribute>
			</xsl:if>
			<xsl:if test="$element-name = 'fo:inline'">
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			</xsl:if>
			<!-- $namespace = 'pas' -->
		</xsl:if>
		
		<xsl:if test="$namespace = 'csa'">
			<xsl:if test="$level &gt; 1">
				<xsl:attribute name="font-weight">bold</xsl:attribute>
			</xsl:if>
			<xsl:if test="$level = 2">
				<xsl:attribute name="font-size">14pt</xsl:attribute>
				<xsl:if test="ancestor::mn:terms">
					<xsl:attribute name="font-size">11pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$level &gt;= 2">
				<xsl:attribute name="color">rgb(3, 115, 200)</xsl:attribute>
			</xsl:if>
			<xsl:if test="$level &gt;= 3">
				<xsl:attribute name="font-size">11pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="ancestor::mn:preface">
				<xsl:attribute name="font-size">13pt</xsl:attribute>
				<xsl:if test="$level &gt;= 2">
					<xsl:attribute name="font-size">12pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<!-- $namespace = 'csa' -->
		</xsl:if>
		
		<xsl:if test="$namespace = 'csd'">
			<xsl:if test="$level = 2">
				<xsl:attribute name="font-size">12pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="$level &gt;= 3">
				<xsl:attribute name="font-size">11pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="ancestor::mn:preface">
				<xsl:attribute name="font-size">13pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="ancestor::mn:sections">
				<xsl:attribute name="margin-top">13.5pt</xsl:attribute>
			</xsl:if>
			<!-- $namespace = 'csd' -->
		</xsl:if>
		
		<xsl:if test="$namespace = 'iec'">
			<xsl:if test="(ancestor::mn:sections and $level = 1) or
				(ancestor::mn:annex and $level &lt;= 2) or
				(ancestor::mn:references[not (preceding-sibling::mn:references)])">
				<xsl:attribute name="font-size">11pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="$level &gt;= 2">
				<xsl:attribute name="space-before">10pt</xsl:attribute>
				<xsl:attribute name="margin-bottom">5pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="$level = 2">
				<xsl:if test="ancestor::mn:annex">
					<xsl:attribute name="space-before">22pt</xsl:attribute>
					<xsl:attribute name="margin-bottom">14pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$level &gt; 2">
				<xsl:if test="ancestor::mn:annex">
					<xsl:attribute name="space-before">5pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			
			<!-- $namespace = 'iec' -->
		</xsl:if>
		
		<xsl:if test="$namespace = 'ieee'">
			<xsl:variable name="space_before">
				<xsl:call-template name="getTitleMarginTop"/>
			</xsl:variable>
			
			<xsl:choose>
				<xsl:when test="$current_template = 'whitepaper' or $current_template = 'icap-whitepaper' or $current_template = 'industry-connection-report'">
					<xsl:attribute name="font-family">Arial Black</xsl:attribute>
					<xsl:attribute name="font-weight">normal</xsl:attribute>
					<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
					<xsl:if test="ancestor::mn:abstract">
						<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
					</xsl:if>
					<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
					<xsl:variable name="section">
						<xsl:call-template name="extractSection"/>
					</xsl:variable>
					<xsl:if test="string-length($section) != 0 and $element-name = 'fo:block'">
						<xsl:attribute name="provisional-distance-between-starts">
							<xsl:choose>
								<xsl:when test="$level = 1 and string-length($section) = 2">8.5mm</xsl:when>
								<xsl:when test="$level = 1 and string-length($section) = 3">13mm</xsl:when>
								<xsl:when test="$level &gt;= 2">17.8mm</xsl:when>
								<xsl:otherwise>10mm</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<xsl:if test="$level = 1">
							<xsl:attribute name="font-size">20pt</xsl:attribute>
							<xsl:attribute name="line-height">20pt</xsl:attribute>
						</xsl:if>
						<xsl:if test="$level = 2">
							<xsl:attribute name="font-size">16pt</xsl:attribute>
						</xsl:if>
						<xsl:if test="$level = 3">
							<xsl:attribute name="font-size">13pt</xsl:attribute>
						</xsl:if>
						<xsl:if test="$level &gt;= 4">
							<xsl:attribute name="font-size">11pt</xsl:attribute>
						</xsl:if>
						<xsl:if test="ancestor::mn:abstract">
							<xsl:attribute name="font-size">13pt</xsl:attribute>
						</xsl:if>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="$level = 1">
						<xsl:if test="ancestor::mn:acknowledgements">
							<xsl:attribute name="font-size">11pt</xsl:attribute>
						</xsl:if>
						<xsl:if test="ancestor::mn:annex">
							<xsl:attribute name="font-weight">normal</xsl:attribute>
						</xsl:if>
						<xsl:if test="not(following-sibling::*[1][self::mn:clause])">
							<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
						</xsl:if>
						<xsl:if test="ancestor::mn:preface or ancestor::mn:introduction or ancestor::mn:acknowledgements">
							<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
						</xsl:if>
					</xsl:if>
					<xsl:if test="$level &gt;= 2">
						<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
					</xsl:if>
					<xsl:if test="$level = 2">
						<xsl:attribute name="font-size">11pt</xsl:attribute>
					</xsl:if>
					<xsl:if test="$level &gt;= 3">
						<xsl:attribute name="font-size">10pt</xsl:attribute>
					</xsl:if>
					<xsl:if test="@type = 'section-title'">
						<xsl:attribute name="font-size">12pt</xsl:attribute>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
			
			<xsl:attribute name="space-before"><xsl:value-of select="$space_before"/></xsl:attribute>
			<xsl:if test="ancestor::mn:introduction"><xsl:attribute name="margin-top"><xsl:value-of select="$space_before"/></xsl:attribute></xsl:if>
			
			<xsl:if test="@type = 'floating-title' or @type = 'section-title'">
				<xsl:copy-of select="@id"/>
			</xsl:if>
			<!-- $namespace = 'ieee' -->
		</xsl:if>
		
		<xsl:if test="$namespace = 'iho'">
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
			
			<xsl:if test="$level = 2">
				<xsl:attribute name="font-size">11pt</xsl:attribute>
				<xsl:attribute name="space-before">24pt</xsl:attribute>
				<xsl:if test="../preceding-sibling::*[1][self::mn:fmt-title]">
					<xsl:attribute name="space-before">10pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$level &gt;= 3">
				<xsl:attribute name="font-size">10pt</xsl:attribute>
				<xsl:attribute name="space-before">6pt</xsl:attribute>
				<xsl:attribute name="space-after">6pt</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="../@id = '_document_history' or . = 'Document History'">
				<xsl:attribute name="text-align">center</xsl:attribute>
			</xsl:if>
			<!-- $namespace = 'iho' -->
		</xsl:if>
		
		<xsl:if test="$namespace = 'itu'">
			<xsl:variable name="doctype" select="ancestor::mn:metanorma/mn:bibdata/mn:ext/mn:doctype[not(@language) or @language = '']"/>
			
			<xsl:if test="$level = 1">
				<xsl:if test="$doctype = 'resolution'">
					<xsl:attribute name="font-size">14pt</xsl:attribute>
					<xsl:attribute name="text-align">center</xsl:attribute>
					<xsl:attribute name="space-after">24pt</xsl:attribute>
				</xsl:if>
				<xsl:if test="$doctype = 'service-publication'">
					<xsl:attribute name="space-before">12pt</xsl:attribute>
					<xsl:attribute name="space-after">12pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			
			<xsl:if test="$level = 2">
				<xsl:attribute name="space-before">12pt</xsl:attribute>
				<xsl:attribute name="space-after">6pt</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="$level &gt;= 2">
				<xsl:if test="$doctype = 'resolution' and ../@inline-header = 'true'">
					<xsl:attribute name="font-size">11pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			
			<xsl:if test="$level &gt;= 3">
				<xsl:attribute name="space-before">6pt</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="$doctype = 'service-publication'">
				<xsl:attribute name="font-size">11pt</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="$lang = 'ar'">
				<xsl:attribute name="text-align">start</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="$element-name = 'fo:inline'">
				<xsl:attribute name="padding-right">
					<xsl:choose>
						<xsl:when test="$level = 2">9mm</xsl:when>
						<xsl:when test="$level = 3">6.5mm</xsl:when>
						<xsl:otherwise>4mm</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</xsl:if>
			<!-- $namespace = 'itu' -->
		</xsl:if>
		
		<xsl:if test="$namespace = 'jcgm'">
			
			<xsl:if test="$level = 1">
				<xsl:if test="parent::mn:annex">
					<xsl:attribute name="space-before">0pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$level = 2">
				<xsl:attribute name="font-size">11.5pt</xsl:attribute>
				<xsl:attribute name="space-before">18pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="$level &gt;= 3">
				<xsl:attribute name="font-size">10.5pt</xsl:attribute>
				<xsl:attribute name="space-before">3pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="../@inline-header = 'true'  or @inline-header = 'true'">
				<xsl:attribute name="font-size">10.5pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="following-sibling::*[1][self::mn:fmt-admitted]">
				<xsl:attribute name="space-after">0pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="ancestor::mn:preface">
				<xsl:attribute name="font-size">15pt</xsl:attribute>
				<xsl:attribute name="space-after">12pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="parent::mn:annex">
				<xsl:attribute name="font-size">15pt</xsl:attribute>
				<xsl:attribute name="space-after">30pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="$element-name = 'fo:inline'">
				<xsl:attribute name="padding-right">
					<xsl:choose>
						<xsl:when test="$level = 3">6.5mm</xsl:when>
						<xsl:otherwise>4mm</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="parent::mn:annex">
				<xsl:attribute name="text-align">center</xsl:attribute>
				<xsl:attribute name="line-height">130%</xsl:attribute>
			</xsl:if>
			
			<!-- $namespace = 'jcgm' -->
		</xsl:if>
		
		<xsl:if test="$namespace = 'jis'">
		
			<xsl:if test="@inline-header = 'true'">
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="@type = 'section-title'">
				<xsl:attribute name="margin-bottom">6mm</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="$level = 1">
				<xsl:if test="following-sibling::mn:clause">
					<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
				</xsl:if>
				<xsl:if test="@ancestor = 'foreword'">
					<xsl:attribute name="font-size">14pt</xsl:attribute>
					<xsl:attribute name="text-align">center</xsl:attribute>
					<xsl:attribute name="space-before">9mm</xsl:attribute>
					<xsl:attribute name="margin-bottom">9mm</xsl:attribute>
				</xsl:if>
				<xsl:if test="@ancestor = 'annex'">
					<xsl:attribute name="font-size">14pt</xsl:attribute>
					<xsl:attribute name="text-align">center</xsl:attribute>
					<xsl:if test="preceding-sibling::mn:annex[1][@commentary = 'true']">
						<xsl:attribute name="font-size">16pt</xsl:attribute>
						<xsl:attribute name="space-before">1mm</xsl:attribute>
						<xsl:attribute name="margin-bottom">7mm</xsl:attribute>
					</xsl:if>
				</xsl:if>
			</xsl:if>
			
			<xsl:if test="$level = 2">
				<xsl:attribute name="space-before">2mm</xsl:attribute>
				<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
				<xsl:if test="@ancestor = 'foreword'">
					<xsl:attribute name="space-before">0mm</xsl:attribute>
				</xsl:if>
				<xsl:if test="@ancestor = 'annex'">
					<xsl:attribute name="space-before">4.5mm</xsl:attribute>
				</xsl:if>
				<xsl:if test="@ancestor = 'bibliography'">
					<xsl:attribute name="space-before">0mm</xsl:attribute>
				</xsl:if>
				<xsl:if test="following-sibling::mn:clause">
					<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			
			<xsl:if test="$level &gt;= 3">
				<xsl:attribute name="space-before">2mm</xsl:attribute>
				<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="@type = 'section-title'">
				<xsl:attribute name="font-size">18pt</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="@type = 'floating-title' or @type = 'section-title'">
				<xsl:copy-of select="@id"/>
			</xsl:if>
			
			<xsl:if test="$vertical_layout = 'true'">
				<xsl:attribute name="font-family">Noto Sans JP</xsl:attribute>
				<xsl:attribute name="font-size">12pt</xsl:attribute>
				<xsl:attribute name="font-weight">500</xsl:attribute>
				<xsl:if test="not($level = 1 and (@ancestor = 'foreword' or @ancestor = 'annex'))">
					<xsl:attribute name="margin-left">-6mm</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<!-- $namespace = 'jis' -->
		</xsl:if>
		
		<xsl:if test="$namespace = 'nist-cswp'">
			<xsl:if test="$level = 1">
				<xsl:attribute name="margin-left">4mm</xsl:attribute>
				<xsl:attribute name="padding-top">1mm</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="$level &gt;= 2">
				<xsl:attribute name="font-size">11pt</xsl:attribute>
				<xsl:if test="ancestor::mn:annex">
					<xsl:attribute name="margin-top">3pt</xsl:attribute>
				</xsl:if>
				<xsl:if test="not(ancestor::mn:annex)">
					<xsl:attribute name="color"><xsl:value-of select="$color"/></xsl:attribute>
				</xsl:if>
			</xsl:if>
			
			<xsl:if test="$level = 2">
				<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
				<xsl:if test="ancestor::mn:annex">
					<xsl:attribute name="font-size">12pt</xsl:attribute>
					<xsl:attribute name="text-align">center</xsl:attribute>
				</xsl:if>
			</xsl:if>
			
			<xsl:if test="$level &gt;= 3">
				<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
				<xsl:if test="ancestor::mn:annex">
					<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<!-- $namespace = 'nist-cswp' -->
		</xsl:if>
		
		<xsl:if test="$namespace = 'nist-sp'">
			<xsl:if test="$level = 1">
				<xsl:attribute name="margin-left">4mm</xsl:attribute>
				<xsl:attribute name="padding-top">1mm</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="$level &gt;= 2">
				<xsl:attribute name="font-size">11pt</xsl:attribute>
				<xsl:if test="ancestor-or-self::mn:annex">
					<xsl:attribute name="margin-top">3pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			
			<xsl:if test="$level = 2">
				<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
				<xsl:if test="ancestor-or-self::mn:annex">
					<xsl:attribute name="font-size">12pt</xsl:attribute>
				</xsl:if>
				<xsl:if test="not(ancestor-or-self::mn:annex)">
					<xsl:attribute name="space-before">12pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			
			<xsl:if test="$level &gt;= 3">
				<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
				<xsl:if test="ancestor-or-self::mn:annex">
					<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
				</xsl:if>
				<xsl:if test="not(ancestor-or-self::mn:annex)">
					<xsl:attribute name="space-before">6pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<!-- $namespace = 'nist-sp' -->
		</xsl:if>
		
		<xsl:if test="$namespace = 'ogc'">
		
			<xsl:if test="$level = 1">
				<xsl:attribute name="space-before">36pt</xsl:attribute>
				<xsl:attribute name="margin-bottom">10pt</xsl:attribute>
			</xsl:if>
		
			<xsl:if test="$level = 2">
				<xsl:attribute name="space-before">24pt</xsl:attribute>
				<xsl:attribute name="margin-bottom">10pt</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="$level = 3">
				<xsl:attribute name="font-size">14pt</xsl:attribute>
				<xsl:attribute name="font-weight">bold</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="$level &gt;= 3">
				<xsl:attribute name="margin-top">30pt</xsl:attribute>
				<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="$level = 4">
				<xsl:attribute name="font-size">12pt</xsl:attribute>
				<xsl:attribute name="font-weight">bold</xsl:attribute>
			</xsl:if>
			<xsl:if test="$level = 5">
				<xsl:attribute name="font-weight">bold</xsl:attribute>
			</xsl:if>
			<xsl:if test="$level &gt;= 5">
				<xsl:attribute name="font-size">11pt</xsl:attribute>
			</xsl:if>
			<!-- $namespace = 'ogc' -->
		</xsl:if>
		
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:if test="$level = 1">
				<xsl:attribute name="color">rgb(59, 56, 56)</xsl:attribute>
				<xsl:attribute name="border-bottom">2pt solid rgb(21, 43, 77)</xsl:attribute>
				<xsl:attribute name="line-height">110%</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="$level = 2">
				<xsl:attribute name="font-size">18pt</xsl:attribute>
				<xsl:attribute name="color">rgb(21, 43, 77)</xsl:attribute>
				<xsl:attribute name="margin-top">12pt</xsl:attribute>
				<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
				<xsl:attribute name="line-height">110%</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="$level = 3">
				<xsl:attribute name="font-size">12pt</xsl:attribute>
				<xsl:attribute name="font-weight">bold</xsl:attribute>
				<xsl:attribute name="color">rgb(21, 43, 77)</xsl:attribute>
				<xsl:attribute name="margin-top">6pt</xsl:attribute>
				<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
			</xsl:if>
			<!-- 'ogc-white-paper' -->
		</xsl:if>
		
		<xsl:if test="$namespace = 'plateau'">
			<!-- <xsl:attribute name="font-size">10pt</xsl:attribute> -->
			<xsl:if test="ancestor::mn:sections">
				<xsl:attribute name="font-size">12pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="ancestor::mn:annex">
				<xsl:attribute name="font-size">12pt</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="@inline-header = 'true'">
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="@type = 'section-title'">
				<xsl:attribute name="margin-bottom">6mm</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="$level = 1">
				<xsl:if test="not(ancestor::mn:preface)">
					<xsl:attribute name="space-before">6.5mm</xsl:attribute>
				</xsl:if>
				<xsl:if test="following-sibling::*[1][self::mn:clause]">
					<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
				</xsl:if>
				<xsl:if test="ancestor::mn:foreword">
					<xsl:attribute name="text-align">center</xsl:attribute>
					<xsl:attribute name="space-before">9mm</xsl:attribute>
					<xsl:attribute name="margin-bottom">9mm</xsl:attribute>
				</xsl:if>
				<xsl:if test="ancestor::mn:annex">
					<xsl:attribute name="font-size">14pt</xsl:attribute>
					<xsl:attribute name="text-align">center</xsl:attribute>
					<xsl:attribute name="space-before">0mm</xsl:attribute>
				</xsl:if>
				<xsl:if test="$doctype = 'technical-report'">
					<xsl:attribute name="font-size">16pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$level &gt;= 2">
				<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="$level = 2">
				<xsl:attribute name="space-before">2mm</xsl:attribute>
				<xsl:if test="ancestor::mn:foreword">
					<xsl:attribute name="space-before">0mm</xsl:attribute>
				</xsl:if>
				<xsl:if test="ancestor::mn:bibliography">
					<xsl:attribute name="space-before">0mm</xsl:attribute>
				</xsl:if>
				
				<xsl:if test="following-sibling::*[1][self::mn:clause]">
					<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
				</xsl:if>
				
				<xsl:if test="$doctype = 'technical-report'">
					<xsl:attribute name="font-size">14pt</xsl:attribute>
					<xsl:attribute name="background-color">rgb(229,229,229)</xsl:attribute>
					<xsl:attribute name="padding-top">2mm</xsl:attribute>
					<xsl:attribute name="padding-bottom">2mm</xsl:attribute>
					<xsl:if test="preceding-sibling::*[2][self::mn:fmt-title]">
						<xsl:attribute name="space-before">0mm</xsl:attribute>
					</xsl:if>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$level = 3">
				<xsl:attribute name="space-before">2mm</xsl:attribute>
				<xsl:if test="$doctype = 'technical-report'">
					<xsl:attribute name="font-size">12pt</xsl:attribute>
					<xsl:attribute name="background-color">rgb(204,204,204)</xsl:attribute>
					<xsl:if test="preceding-sibling::*[2][self::mn:fmt-title]">
						<xsl:attribute name="space-before">0mm</xsl:attribute>
					</xsl:if>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$level &gt;= 4">
				<xsl:attribute name="space-before">2mm</xsl:attribute>
				<xsl:if test="$doctype = 'technical-report'">
					<xsl:attribute name="font-size">10pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			
			<xsl:if test="ancestor::mn:preface">
				<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="$doctype = 'technical-report'">
				<xsl:if test="following-sibling::*[1][self::mn:clause]">
					<xsl:attribute name="margin-bottom">0</xsl:attribute>
				</xsl:if>
				<xsl:if test="following-sibling::*[1][self::mn:p]">
					<xsl:attribute name="margin-bottom">16pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			
			<xsl:if test="@type = 'floating-title' or @type = 'section-title'">
				<xsl:copy-of select="@id"/>
			</xsl:if>
			<!-- $namespace = 'plateau' -->
		</xsl:if>
		
		<xsl:if test="$namespace = 'rsd'">
			<xsl:if test="$level &gt;= 2">
				<xsl:attribute name="font-size">13pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="$level = 2">
				<xsl:attribute name="space-before">9mm</xsl:attribute>
			</xsl:if>
			<xsl:if test="$level = 3">
				<xsl:attribute name="space-before">12pt</xsl:attribute>
				<xsl:attribute name="color"><xsl:value-of select="$color_blue"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="$level &gt;= 4">
				<xsl:attribute name="font-weight">normal</xsl:attribute> 
				<xsl:attribute name="space-before">8pt</xsl:attribute>
				<xsl:attribute name="margin-bottom">4pt</xsl:attribute>
			</xsl:if>
			<!-- $namespace = 'rsd' -->
		</xsl:if>
		<xsl:attribute name="role">H<xsl:value-of select="$level"/></xsl:attribute>
	</xsl:template> <!-- refine_title-style -->



</xsl:stylesheet>