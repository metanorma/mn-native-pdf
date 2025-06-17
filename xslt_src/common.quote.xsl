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
	
	<xsl:attribute-set name="quote-style">
		<xsl:attribute name="margin-left">12mm</xsl:attribute>
		<xsl:attribute name="margin-right">12mm</xsl:attribute>
		<xsl:if test="$namespace = 'csa' or $namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'rsd'">
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-left">13mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bsi' or $namespace = 'csd' or $namespace = 'gb' or $namespace = 'iso' or $namespace = 'm3d'">
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jcgm'">
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="font-style">italic</xsl:attribute>
			<xsl:attribute name="text-align">justify</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="margin-top">5pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">10pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">			
			<xsl:attribute name="font-family">Calibri</xsl:attribute>
			<xsl:attribute name="margin-left">4.5mm</xsl:attribute>
			<xsl:attribute name="margin-right">9mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:attribute name="margin-left">0mm</xsl:attribute>
			<xsl:attribute name="margin-right">0mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'mpfd'">
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="text-align">justify</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'plateau'">
			<xsl:attribute name="margin-left">0mm</xsl:attribute>
			<xsl:attribute name="margin-right">0mm</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:template name="refine_quote-style">
		<xsl:if test="$namespace = 'iso'">
			<xsl:if test="$doctype = 'amendment' and (mn:note or mn:termnote)">
				<xsl:attribute name="margin-left">7mm</xsl:attribute>
				<xsl:attribute name="margin-right">0mm</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'jcgm'">
			<xsl:if test="ancestor::mn:boilerplate">
				<xsl:attribute name="margin-left">7mm</xsl:attribute>
				<xsl:attribute name="margin-right">7mm</xsl:attribute>
				<xsl:attribute name="font-style">normal</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:if test="ancestor::mn:li">
				<xsl:attribute name="margin-left">7.5mm</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:attribute-set name="quote-source-style">		
		<xsl:attribute name="text-align">right</xsl:attribute>
		<xsl:if test="$namespace = 'csa' or $namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'rsd'">
			<xsl:attribute name="margin-right">25mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="margin-top">15pt</xsl:attribute>
			<xsl:attribute name="margin-left">12mm</xsl:attribute>
			<xsl:attribute name="margin-right">12mm</xsl:attribute>			 
		</xsl:if>		
	</xsl:attribute-set>
	
</xsl:stylesheet>