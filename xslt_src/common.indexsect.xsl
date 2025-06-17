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
	
	<!-- Index section styles -->
	<xsl:attribute-set name="indexsect-title-style">
		<xsl:attribute name="role">H1</xsl:attribute>
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="font-size">16pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="margin-bottom">84pt</xsl:attribute>
			<xsl:attribute name="margin-left">-18mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="font-size">18pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="margin-bottom">24pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="font-size">12pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="margin-bottom">84pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="font-size">16pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="margin-bottom">84pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jcgm'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="span">all</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'plateau'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="span">all</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="indexsect-clause-title-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="margin-bottom">3pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="margin-bottom">3pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="margin-bottom">3pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="margin-bottom">3pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jcgm'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="margin-left">25mm</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	<!-- End Index section styles -->
	
</xsl:stylesheet>