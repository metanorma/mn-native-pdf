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
	

	<!-- Tabulation processing -->
	<xsl:template match="mn:tab">
		<!-- zero-space char -->
		<xsl:variable name="depth">
			<xsl:call-template name="getLevel">
				<xsl:with-param name="depth" select="../@depth"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="padding">
			<xsl:if test="$namespace = 'csa'">2</xsl:if>
			<xsl:if test="$namespace = 'csd'">
				<xsl:choose>
					<xsl:when test="$depth &gt;= 3">3</xsl:when>
					<xsl:when test="$depth = 1">3</xsl:when>
					<xsl:otherwise>2</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:if test="$namespace = 'gb'">3</xsl:if>
			<xsl:if test="$namespace = 'iec'">
				<xsl:choose>
					<xsl:when test="parent::mn:appendix">5</xsl:when>
					<xsl:when test="$depth = 2 and ancestor::mn:annex">6</xsl:when>
					<xsl:when test="$depth = 2">7</xsl:when>
					<xsl:otherwise>5</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:if test="$namespace = 'iho'">
				<xsl:choose>
					<xsl:when test="$depth = 2">3</xsl:when>
					<xsl:when test="$depth = 3">3</xsl:when>
					<xsl:otherwise>4</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:if test="$namespace = 'bsi'">
				<xsl:choose>
					<xsl:when test="$document_type = 'PAS'">
						<xsl:choose>
							<xsl:when test="$depth = 1">1.5</xsl:when>
							<xsl:otherwise>1</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="$doctype = 'expert-commentary'">1</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="$depth = 1 and ../@ancestor = 'annex'">1.5</xsl:when>
							<xsl:when test="$depth = 2">3</xsl:when>
							<xsl:otherwise>4</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:if test="$namespace = 'ieee'">1</xsl:if>
			<xsl:if test="$namespace = 'iso'">
				<xsl:choose>
					<xsl:when test="$layoutVersion = '1951'">2</xsl:when>
					<xsl:when test="$depth = 2">3</xsl:when>
					<xsl:otherwise>4</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:if test=" $namespace = 'jcgm'">
				<xsl:choose>
					<xsl:when test="$depth = 2">3</xsl:when>
					<xsl:otherwise>4</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:if test="$namespace = 'itu'">
				<xsl:choose>
					<xsl:when test="$depth = 5">7</xsl:when>
					<xsl:when test="$depth = 4">10</xsl:when>
					<xsl:when test="$depth = 3">6</xsl:when>
					<xsl:when test="$depth = 2">9</xsl:when>
					<xsl:otherwise>12</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:if test="$namespace = 'm3d'">								
				<xsl:variable name="references_num_current">
					<xsl:number level="any" count="m3d:references"/>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="(ancestor-or-self::m3d:sections and $depth = 1) or 
															(local-name(../..) = 'references' and $references_num_current = 1)">25</xsl:when>
					<xsl:when test="ancestor-or-self::m3d:sections or ancestor-or-self::m3d:annex">3</xsl:when>
				</xsl:choose>
			</xsl:if>
			<xsl:if test="$namespace = 'nist-sp'">
				<xsl:choose>
					<xsl:when test="ancestor-or-self::mn:annex and $depth &gt;= 2">1</xsl:when>
					<xsl:when test="$depth = 1 and local-name(..) != 'annex'">5</xsl:when>
					<xsl:otherwise>1</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			
			<xsl:if test="$namespace = 'nist-cswp'">				
				<xsl:choose>
					<xsl:when test="$depth = 1 and local-name(..) != 'annex'">7.5</xsl:when>										
					<xsl:otherwise>4</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:if test="$namespace = 'ogc'">
				<xsl:choose>
					<xsl:when test="ancestor::mn:note and ancestor::mn:name">1</xsl:when>
					<xsl:when test="$depth = 2">2</xsl:when>
					<xsl:otherwise>1</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:if test="$namespace = 'ogc-white-paper'">
				<xsl:choose>
					<xsl:when test="ancestor::mn:note and ancestor::mn:name">4</xsl:when>
					<xsl:when test="$depth &gt;= 5"/>
					<xsl:when test="$depth &gt;= 4">5</xsl:when>
					<xsl:when test="$depth &gt;= 3 and ancestor::mn:terms">3</xsl:when>
					<xsl:when test="$depth &gt;= 2">4</xsl:when>
					<xsl:when test="$depth = 1">4</xsl:when>
					<xsl:otherwise>2</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:if test="$namespace = 'rsd'">1.5</xsl:if>
			<xsl:if test="$namespace = 'unece'">
				<xsl:choose>
					<xsl:when test="ancestor::un:sections and $depth = 1">12</xsl:when>
					<xsl:when test="ancestor::un:sections">8</xsl:when>					
				</xsl:choose>
			</xsl:if>
			<xsl:if test="$namespace = 'unece-rec'">
				<xsl:choose>
					<xsl:when test="ancestor::un:annex and $depth &gt;= 2">9.5</xsl:when>
					<xsl:when test="ancestor::un:sections">9.5</xsl:when>
				</xsl:choose>
			</xsl:if>
			<xsl:if test="$namespace = 'mpfd'">3</xsl:if>
			<xsl:if test="$namespace = 'bipm'">
				<xsl:choose>
					<xsl:when test="ancestor::mn:annex">2</xsl:when>
					<xsl:otherwise>8</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:variable>
		
		<xsl:variable name="padding-right">
			<xsl:choose>
				<xsl:when test="normalize-space($padding) = ''">0</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space($padding)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:if test="$namespace = 'iso'">
			<xsl:if test="$layoutVersion = '1951' and $depth = 1">.</xsl:if>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="$lang = 'zh'">
				<fo:inline role="SKIP"><xsl:value-of select="$tab_zh"/></fo:inline>
			</xsl:when>
			<xsl:when test="../../@inline-header = 'true'">
				<fo:inline font-size="90%" role="SKIP">
					<xsl:call-template name="insertNonBreakSpaces">
						<xsl:with-param name="count" select="$padding-right"/>
					</xsl:call-template>
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="direction"><xsl:if test="$lang = 'ar'"><xsl:value-of select="$RLM"/></xsl:if></xsl:variable>
				<fo:inline padding-right="{$padding-right}mm" role="SKIP"><xsl:value-of select="$direction"/>&#x200B;</fo:inline>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template> <!-- tab -->
	
	<xsl:template match="mn:note/mn:name/mn:tab" priority="2"/>
	<xsl:template match="mn:termnote/mn:name/mn:tab" priority="2"/>
	
	<xsl:template match="mn:note/mn:name/mn:tab" mode="tab">
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="padding-right">1.5mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="padding-right">4mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csd'">
			<xsl:attribute name="padding-right">6mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="padding-right">6mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="padding-right">2mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso' and $namespace = 'jcgm'">
			<xsl:attribute name="padding-right">6mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
		</xsl:if>
		<xsl:if test="$namespace = 'm3d'">
			<xsl:attribute name="padding-right">5mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="padding-right">1mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:attribute name="padding-right">1mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-sp' or $namespace = 'nist-cswp'">
			<xsl:attribute name="padding-right">1mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece'">
			<xsl:attribute name="padding-right">4mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="padding-right">0.5mm</xsl:attribute>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="insertNonBreakSpaces">
		<xsl:param name="count"/>
		<xsl:if test="$count &gt; 0">
			<xsl:text>&#xA0;</xsl:text>
			<xsl:call-template name="insertNonBreakSpaces">
				<xsl:with-param name="count" select="$count - 1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>