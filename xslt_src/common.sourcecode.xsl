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
	
	<xsl:attribute-set name="sourcecode-container-style">
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="space-after">12pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>

	<xsl:attribute-set name="sourcecode-style">
		<xsl:attribute name="white-space">pre</xsl:attribute>
		<xsl:attribute name="wrap-option">wrap</xsl:attribute>
		<xsl:attribute name="role">Code</xsl:attribute>
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="font-family">Courier New, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>			
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="font-family"><xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>			
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="line-height">113%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csd'">
			<xsl:attribute name="font-family"><xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>			
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>					
		</xsl:if>
		
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="font-family">Courier New, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>			
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="font-family">Courier New, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>			
			<xsl:attribute name="margin-top">5pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">5pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="font-family">Courier New, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>			
			<xsl:attribute name="margin-top">5pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">5pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="font-family">Fira Code, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>			
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="line-height">113%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="font-family">Courier New, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>			
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="font-family">Courier New, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>			
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jcgm'">
			<xsl:attribute name="font-family">Courier New, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>			
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'm3d'">
			<xsl:attribute name="font-family">Courier New, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>			
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>		
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="font-family">Fira Code, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>			
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>			
			<xsl:attribute name="line-height">113%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:attribute name="font-family">Courier New, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>			
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="line-height">113%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-family"><xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>			
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="line-height">113%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp' or $namespace = 'nist-sp'">
			<xsl:attribute name="font-family">Courier New, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>			
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece' or $namespace = 'unece-rec'">
			<xsl:attribute name="font-family">Courier New, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>			
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- sourcecode-style -->

	<xsl:template name="refine_sourcecode-style">
		<xsl:if test="$namespace = 'rsd'"> <!-- background for image -->
			<xsl:if test="starts-with(mn:name/text()[1], 'Figure ')">
				<xsl:attribute name="background-color">rgb(236,242,246)</xsl:attribute>
				<xsl:attribute name="padding-left">11mm</xsl:attribute>
				<xsl:attribute name="margin-left">0mm</xsl:attribute>
				<xsl:attribute name="padding-right">11mm</xsl:attribute>
				<xsl:attribute name="margin-right">0mm</xsl:attribute>
				<xsl:attribute name="padding-top">7.5mm</xsl:attribute>
				<xsl:attribute name="padding-bottom">7.5mm</xsl:attribute>
				<xsl:if test="following-sibling::*[1][self::mn:sourcecode] and starts-with(mn:name/text()[1], 'Figure ')">
					<xsl:attribute name="margin-bottom">16pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:if test="parent::mn:example">
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template> <!-- refine_sourcecode-style -->

	<xsl:attribute-set name="sourcecode-name-style">
		<xsl:attribute name="font-size">11pt</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="text-align">center</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		<xsl:attribute name="keep-with-previous">always</xsl:attribute>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-size">13pt</xsl:attribute>
			<xsl:attribute name="font-weight">300</xsl:attribute>
			<xsl:attribute name="color">black</xsl:attribute>
			<xsl:attribute name="text-align">left</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- sourcecode-name-style -->

</xsl:stylesheet>