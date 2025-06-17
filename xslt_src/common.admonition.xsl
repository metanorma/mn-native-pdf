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
	
	<!-- admonition -->
	<xsl:attribute-set name="admonition-style">
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="border">0.5pt solid rgb(79, 129, 189)</xsl:attribute>
			<xsl:attribute name="color">rgb(79, 129, 189)</xsl:attribute>
			<xsl:attribute name="margin-left">16mm</xsl:attribute>
			<xsl:attribute name="margin-right">16mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csd'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="border">0.25pt solid black</xsl:attribute>
			<xsl:attribute name="margin-left">16mm</xsl:attribute>
			<xsl:attribute name="margin-right">16mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="border">0.5pt solid black</xsl:attribute>
			<xsl:attribute name="margin-left">-2mm</xsl:attribute>
			<xsl:attribute name="margin-right">-2mm</xsl:attribute>
			<xsl:attribute name="space-before">18pt</xsl:attribute>
			<xsl:attribute name="space-after">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="border">0.5pt solid black</xsl:attribute>
			<xsl:attribute name="space-before">12pt</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="space-after">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="border">0.5pt solid rgb(79, 129, 189)</xsl:attribute>
			<xsl:attribute name="color">rgb(79, 129, 189)</xsl:attribute>
			<xsl:attribute name="margin-left">16mm</xsl:attribute>
			<xsl:attribute name="margin-right">16mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="border">0.5pt solid black</xsl:attribute>
			<xsl:attribute name="space-before">12pt</xsl:attribute>
			<xsl:attribute name="space-after">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jcgm'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp'">
			<xsl:attribute name="border">1pt solid black</xsl:attribute>
			<xsl:attribute name="margin-left">-2mm</xsl:attribute>
			<xsl:attribute name="margin-right">-2mm</xsl:attribute>
			<xsl:attribute name="padding-top">6mm</xsl:attribute>
			<xsl:attribute name="padding-bottom">7mm</xsl:attribute>
			<xsl:attribute name="background-color">rgb(222,222,222)</xsl:attribute>
			<xsl:attribute name="space-after">24pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-sp'">
			<xsl:attribute name="border">1pt solid black</xsl:attribute>
			<xsl:attribute name="margin-left">-2mm</xsl:attribute>
			<xsl:attribute name="margin-right">-2mm</xsl:attribute>
			<xsl:attribute name="background-color">rgb(222,222,222)</xsl:attribute>
			<xsl:attribute name="space-after">24pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="border">0.5pt solid rgb(79, 129, 189)</xsl:attribute>
			<xsl:attribute name="color">rgb(79, 129, 189)</xsl:attribute>
			<xsl:attribute name="margin-left">16mm</xsl:attribute>
			<xsl:attribute name="margin-right">16mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="border">0.5pt solid rgb(79, 129, 189)</xsl:attribute>
			<xsl:attribute name="color">rgb(79, 129, 189)</xsl:attribute>
			<xsl:attribute name="margin-left">16mm</xsl:attribute>
			<xsl:attribute name="margin-right">16mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece'">
			<xsl:attribute name="border">0.25pt solid black</xsl:attribute>
			<xsl:attribute name="margin-left">-3mm</xsl:attribute>
			<xsl:attribute name="margin-right">-3mm</xsl:attribute>
			<xsl:attribute name="padding-top">4mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece-rec'">
			<xsl:attribute name="border">0.25pt solid black</xsl:attribute>
			<xsl:attribute name="margin-top">7mm</xsl:attribute>
			<xsl:attribute name="margin-left">-9mm</xsl:attribute>
			<xsl:attribute name="margin-right">-14mm</xsl:attribute>
			<xsl:attribute name="padding-top">3mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">16pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- admonition-style -->
	
	<xsl:attribute-set name="admonition-container-style">
		<xsl:attribute name="margin-left">0mm</xsl:attribute>
		<xsl:attribute name="margin-right">0mm</xsl:attribute>
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="padding">0.5mm</xsl:attribute>
			<xsl:attribute name="font-size">9pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="padding">2mm</xsl:attribute>
			<xsl:attribute name="padding-top">3mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="padding">2mm</xsl:attribute>
			<xsl:attribute name="padding-top">3mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="padding">1mm</xsl:attribute>
			<xsl:attribute name="padding-top">2mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="padding">1mm</xsl:attribute>
			<xsl:attribute name="padding-bottom">2mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="padding">2mm</xsl:attribute>
			<xsl:attribute name="padding-top">3mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="padding">2mm</xsl:attribute>
			<xsl:attribute name="padding-top">3mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp'">
			<xsl:attribute name="margin-left">8mm</xsl:attribute>
			<xsl:attribute name="margin-right">8mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-sp'">
			<xsl:attribute name="margin-left">8mm</xsl:attribute>
			<xsl:attribute name="margin-right">8mm</xsl:attribute>
			<xsl:attribute name="padding-top">6mm</xsl:attribute>
			<xsl:attribute name="padding-bottom">7mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="padding">2mm</xsl:attribute>
			<xsl:attribute name="padding-top">3mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="padding">2mm</xsl:attribute>
			<xsl:attribute name="padding-top">3mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece'">
			<xsl:attribute name="margin-left">2mm</xsl:attribute>
			<xsl:attribute name="margin-right">2mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece-rec'">
			<xsl:attribute name="margin-left">20mm</xsl:attribute>
			<xsl:attribute name="margin-right">20mm</xsl:attribute>
			<xsl:attribute name="text-indent">0mm</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- admonition-container-style -->
	
	
	<xsl:attribute-set name="admonition-name-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="font-style">italic</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="font-style">italic</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="font-family">SimHei</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="font-style">italic</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'm3d'">
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'mpfd'">
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-sp'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="font-style">italic</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="font-weight">normal</xsl:attribute>
			<xsl:attribute name="font-style">italic</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece'">
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="font-style">italic</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece-rec'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="margin-left">20mm</xsl:attribute>
			<xsl:attribute name="margin-right">25mm</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- admonition-name-style -->
	
	<xsl:attribute-set name="admonition-p-style">
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="font-style">italic</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="font-style">italic</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="text-align">justify</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="font-style">italic</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'm3d'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp' or $namespace = 'nist-sp'">
		</xsl:if>
		<xsl:if test="$namespace = 'mpfd'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="font-style">italic</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-style">italic</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece'">
			<xsl:attribute name="text-align">justify</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="line-height">122%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece-rec'">
			<xsl:attribute name="text-align">justify</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- admonition-p-style -->
	<!-- end admonition -->
	
</xsl:stylesheet>