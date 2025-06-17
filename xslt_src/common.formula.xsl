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
	
	<!-- Formula's styles -->
	<xsl:attribute-set name="formula-style">
		<xsl:attribute name="margin-top">6pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="margin-top">14pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">14pt</xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'm3d'">
			<xsl:attribute name="margin-top">14pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">14pt</xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp'">
			<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-sp'">
			<xsl:attribute name="margin-top">0pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- formula-style -->
	
	<xsl:attribute-set name="formula-stem-block-style">
		<xsl:attribute name="text-align">center</xsl:attribute>
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="text-align">left</xsl:attribute>
			<xsl:attribute name="margin-left">5mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="text-align">left</xsl:attribute>
			<xsl:attribute name="margin-left">5mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csd'">
			<xsl:attribute name="text-align">left</xsl:attribute>
			<xsl:attribute name="margin-left">5mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="text-align">center</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="text-align">left</xsl:attribute>
			<xsl:attribute name="margin-left">1mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="text-align">left</xsl:attribute>
			<xsl:attribute name="margin-left">5mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="margin-left">0mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jcgm'">
			<xsl:attribute name="text-align">left</xsl:attribute>
			<xsl:attribute name="margin-left">25mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-sp'">
			<xsl:attribute name="margin-left">7mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="text-align">left</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:attribute name="text-align">left</xsl:attribute>
			<xsl:attribute name="margin-left">5mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="text-align">left</xsl:attribute>
			<xsl:attribute name="margin-left">5mm</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- formula-stem-block-style -->
	
	<xsl:template name="refine_formula-stem-block-style">
		<xsl:if test="$namespace = 'nist-cswp' or $namespace = 'unece' or $namespace = 'unece-rec'">
			<xsl:if test="ancestor::mn:annex">
				<xsl:attribute name="text-align">left</xsl:attribute>
				<xsl:attribute name="margin-left">7mm</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template> <!-- refine_formula-stem-block-style -->

	
	<xsl:attribute-set name="formula-stem-number-style">
		<xsl:attribute name="text-align">right</xsl:attribute>
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="text-align">left</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="margin-right">-10mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="margin-left">0mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jcgm'">
		</xsl:if>
		<xsl:if test="$namespace = 'm3d'">
			<xsl:attribute name="text-align">left</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- formula-stem-number-style -->
	<!-- End Formula's styles -->
	
	<xsl:template name="refine_formula-stem-number-style">
		<xsl:if test="$namespace = 'iec'">
			<xsl:if test="ancestor::mn:table">
				<xsl:attribute name="margin-right">0mm</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:attribute-set name="mathml-style">
		<xsl:attribute name="font-family">STIX Two Math</xsl:attribute>
		<xsl:if test="$namespace = 'bsi' or $namespace = 'iso' or $namespace = 'jcgm' or $namespace = 'm3d'">
			<xsl:attribute name="font-family">Cambria Math</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:template name="refine_mathml-style">
		<xsl:if test="$namespace = 'bipm'">
			<xsl:if test="ancestor::*[local-name()='table']">
				<xsl:attribute name="font-size">95%</xsl:attribute> <!-- base font in table is 10pt -->
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-sp'">
			<xsl:if test="ancestor::*[local-name()='table']">
				<xsl:attribute name="font-size">10pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>