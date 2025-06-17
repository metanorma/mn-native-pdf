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
	
	<xsl:attribute-set name="pre-style">
		<xsl:attribute name="font-family">Courier New, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>
		<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="font-family"><xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>
			<xsl:attribute name="line-height">113%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csd'">
			<xsl:attribute name="font-family"><xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="margin-top">5pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">5pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="margin-top">5pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">5pt</xsl:attribute>
			<xsl:attribute name="font-size">95%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="font-family">Fira Code, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>
			<xsl:attribute name="line-height">113%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jcgm'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'm3d'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>		
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="font-family">Fira Code, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>
			<xsl:attribute name="line-height">113%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:attribute name="line-height">113%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-family"><xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>
			<xsl:attribute name="line-height">113%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp' or $namespace = 'nist-sp'">
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece' or $namespace = 'unece-rec'">
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="tt-style">
		<xsl:if test="$namespace = 'csa' or $namespace = 'csd' or $namespace = 'rsd'">
			<xsl:attribute name="font-family"><xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'bsi' or $namespace = 'gb' or $namespace = 'iec' or $namespace = 'iho' or $namespace = 'iso' or $namespace = 'm3d' or 
										 $namespace = 'ogc-white-paper' or $namespace = 'jcgm'">
			<xsl:attribute name="font-family">Courier New, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="font-family">Fira Code, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>			
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:variable name="color-added-text">
		<xsl:text>rgb(0, 255, 0)</xsl:text>
	</xsl:variable>
	<xsl:attribute-set name="add-style">
		<xsl:choose>
			<xsl:when test="$namespace = 'bsi'">
				<xsl:attribute name="font-style">italic</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="color">red</xsl:attribute>
				<xsl:attribute name="text-decoration">underline</xsl:attribute>
				<!-- <xsl:attribute name="color">black</xsl:attribute>
				<xsl:attribute name="background-color"><xsl:value-of select="$color-added-text"/></xsl:attribute>
				<xsl:attribute name="padding-top">1mm</xsl:attribute>
				<xsl:attribute name="padding-bottom">0.5mm</xsl:attribute> -->
			</xsl:otherwise>
		</xsl:choose>
	</xsl:attribute-set>
  
	<xsl:variable name="add-style">
			<add-style xsl:use-attribute-sets="add-style"/>
		</xsl:variable>
	<xsl:template name="append_add-style">
		<xsl:copy-of select="xalan:nodeset($add-style)/add-style/@*"/>
	</xsl:template>

	<xsl:variable name="color-deleted-text">
		<xsl:text>red</xsl:text>
	</xsl:variable>
	<xsl:attribute-set name="del-style">
		<xsl:attribute name="color"><xsl:value-of select="$color-deleted-text"/></xsl:attribute>
		<xsl:attribute name="text-decoration">line-through</xsl:attribute>
	</xsl:attribute-set>
	
</xsl:stylesheet>