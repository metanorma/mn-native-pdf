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
	
	<xsl:attribute-set name="annex-title-style">
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="font-size">16pt</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-bottom">48pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="role">H1</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="font-size">12pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="role">H1</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:template name="refine_annex-title-style">
		<xsl:if test="$namespace = 'iso'">
			<xsl:call-template name="setIDforNamedDestination"/>
			<xsl:if test="$layoutVersion = '2024'">
				<xsl:attribute name="line-height">1.1</xsl:attribute>
				<!-- <xsl:attribute name="margin-bottom">52pt</xsl:attribute> -->
			</xsl:if>
			<xsl:if test="$layoutVersion = '1972' or $layoutVersion = '1979' or $layoutVersion = '1987' or $layoutVersion = '1989'">
				<xsl:attribute name="span">all</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	
	
</xsl:stylesheet>