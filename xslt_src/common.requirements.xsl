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
	
	<xsl:attribute-set name="permission-style">
		<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>

	<xsl:attribute-set name="permission-name-style">
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>			
			<xsl:attribute name="padding-top">0.5mm</xsl:attribute>
			<xsl:attribute name="padding-bottom">1mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">1mm</xsl:attribute>
			<xsl:attribute name="background-color">rgb(165,165,165)</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>

	<xsl:attribute-set name="permission-label-style">
		<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>

	<xsl:attribute-set name="requirement-style">
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>

	<xsl:attribute-set name="requirement-name-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>			
			<xsl:attribute name="margin-bottom">4pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>			
			<xsl:attribute name="padding-top">0.5mm</xsl:attribute>
			<xsl:attribute name="padding-bottom">1mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">1mm</xsl:attribute>
			<xsl:attribute name="background-color">rgb(165,165,165)</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>

	<xsl:attribute-set name="requirement-label-style">
		<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>

	<xsl:attribute-set name="subject-style">
	</xsl:attribute-set>
	
	<xsl:attribute-set name="inherit-style">
	</xsl:attribute-set>
	
	<xsl:attribute-set name="description-style">
	</xsl:attribute-set>
	
	<xsl:attribute-set name="specification-style">
	</xsl:attribute-set>
	
	<xsl:attribute-set name="measurement-target-style">
	</xsl:attribute-set>
	
	<xsl:attribute-set name="verification-style">
	</xsl:attribute-set>
	
	<xsl:attribute-set name="import-style">
	</xsl:attribute-set>
	
	<xsl:attribute-set name="component-style">
	</xsl:attribute-set>
	
	<xsl:attribute-set name="recommendation-style">
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="border">1pt solid black</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-sp'">
			<xsl:attribute name="margin-left">20mm</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="recommendation-name-style">
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>			
			<xsl:attribute name="padding-top">0.5mm</xsl:attribute>
			<xsl:attribute name="padding-bottom">1mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">1mm</xsl:attribute>
			<xsl:attribute name="background-color">rgb(165,165,165)</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-sp'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="recommendation-label-style">
		<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
</xsl:stylesheet>