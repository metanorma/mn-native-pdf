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
	
	<xsl:attribute-set name="xref-style">
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="color">rgb(58,88,168)</xsl:attribute>
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee' or $namespace = 'iho' or $namespace = 'iso' or $namespace = 'itu' or $namespace = 'nist-cswp'  or $namespace = 'nist-sp' or $namespace = 'ogc-white-paper' or $namespace = 'mpfd' or $namespace = 'jcgm'">
			<xsl:attribute name="color">blue</xsl:attribute>
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
		</xsl:if>
	</xsl:attribute-set>

</xsl:stylesheet>