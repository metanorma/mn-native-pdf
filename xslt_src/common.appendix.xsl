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
	
	<xsl:attribute-set name="appendix-style">
		<xsl:if test="$namespace = 'bsi' or $namespace = 'iso' or $namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'm3d' or $namespace = 'gb' or $namespace = 'csd' or $namespace = 'jcgm'">		
			<xsl:attribute name="font-size">12pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="margin-top">5pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">5pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-size">12pt</xsl:attribute>
			<xsl:attribute name="font-weight">normal</xsl:attribute>
			<xsl:attribute name="color">black</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="appendix-example-style">
		<xsl:if test="$namespace = 'bsi' or $namespace = 'iso' or $namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'm3d' or $namespace = 'gb' or $namespace = 'csd' or $namespace = 'jcgm'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>			
			<xsl:attribute name="margin-top">8pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="margin-top">14pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">14pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-weight">normal</xsl:attribute>
			<xsl:attribute name="color">black</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	
	<!-- ======================== -->
	<!-- Appendix processing -->
	<!-- ======================== -->
	<xsl:template match="mn:appendix">
		<xsl:call-template name="setNamedDestination"/>
		<fo:block id="{@id}" xsl:use-attribute-sets="appendix-style">
			<xsl:apply-templates select="mn:fmt-title" />
		</fo:block>
		<xsl:apply-templates select="node()[not(self::mn:fmt-title)]"/>
	</xsl:template>

	<xsl:template match="mn:appendix/mn:fmt-title" priority="2">
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		<fo:inline role="H{$level}"><xsl:call-template name="setIDforNamedDestination"/><xsl:apply-templates /></fo:inline>
	</xsl:template>
	<!-- ======================== -->
	<!-- END Appendix processing -->
	<!-- ======================== -->
	
	<xsl:template match="mn:appendix//mn:example" priority="2">
		<xsl:call-template name="setNamedDestination"/>
		<fo:block id="{@id}" xsl:use-attribute-sets="appendix-example-style">			
			<xsl:apply-templates select="mn:fmt-name" />
		</fo:block>
		<xsl:apply-templates select="node()[not(self::mn:fmt-name)]"/>
	</xsl:template>
	
</xsl:stylesheet>