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
	
	<xsl:attribute-set name="eref-style">
		<xsl:if test="$namespace = 'bsi'">
			<!-- <xsl:attribute name="color">rgb(58,88,168)</xsl:attribute>
			<xsl:attribute name="text-decoration">underline</xsl:attribute> -->
		</xsl:if>
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="color">rgb(33, 94, 159)</xsl:attribute>
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csd' or $namespace = 'ieee' or $namespace = 'itu' or $namespace = 'ogc-white-paper' or $namespace = 'mpfd'">
			<xsl:attribute name="color">blue</xsl:attribute>
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp' or $namespace = 'nist-sp' or $namespace = 'unece'">
			<xsl:attribute name="color">blue</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
		</xsl:if>
	</xsl:attribute-set>

	<xsl:template name="refine_eref-style">
		<xsl:variable name="citeas" select="java:replaceAll(java:java.lang.String.new(@citeas),'^\[?(.+?)\]?$','$1')"/> <!-- remove leading and trailing brackets -->
		<xsl:variable name="text" select="normalize-space()"/>
		<xsl:if test="$namespace = 'bsi'">
			<xsl:if test="not($ids/id = current()/@bibitemid) or $document_type = 'PAS' or not(contains($citeas, $text))"> <!-- if reference can't be resolved or PAS document -->
				<xsl:attribute name="color">inherit</xsl:attribute>
				<xsl:attribute name="text-decoration">none</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:if test="$current_template = 'whitepaper' or $current_template = 'icap-whitepaper' or $current_template = 'industry-connection-report'">
				<xsl:attribute name="color"><xsl:value-of select="$color_blue"/></xsl:attribute>
				<xsl:attribute name="text-decoration">none</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template> <!-- refine_eref-style -->

</xsl:stylesheet>