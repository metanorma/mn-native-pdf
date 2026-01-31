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
	
	<xsl:attribute-set name="key-style">
		
	</xsl:attribute-set>
	
	<xsl:template name="refine_key-style">
		
	</xsl:template>
	
	<xsl:attribute-set name="key-name-style" use-attribute-sets="dl-name-style">
		
	</xsl:attribute-set>
	
	<xsl:template name="refine_key-name-style">
		<xsl:if test="$namespace = 'plateau'">
			<xsl:if test="ancestor::mn:figure">
				<xsl:attribute name="font-weight">bold</xsl:attribute>
			</xsl:if>
			<xsl:if test="ancestor::mn:tfoot and (../@key = 'true' or ancestor::mn:key)">
				<xsl:attribute name="margin-left">-<xsl:value-of select="$tableAnnotationIndent"/></xsl:attribute>
				<xsl:attribute name="margin-bottom">2pt</xsl:attribute>
				<xsl:attribute name="font-weight">bold</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="mn:key">
		<xsl:apply-templates />
	</xsl:template>
	
	<xsl:template match="mn:key/mn:name">
		<xsl:param name="process">false</xsl:param>
		<xsl:if test="$process = 'true'">
			<fo:block xsl:use-attribute-sets="key-name-style">
				<xsl:call-template name="refine_key-name-style"/>
				<xsl:apply-templates />
			</fo:block>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>