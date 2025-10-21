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