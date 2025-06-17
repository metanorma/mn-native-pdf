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
	
	<xsl:attribute-set name="term-style">
		<xsl:if test="$namespace = 'bsi' or $namespace = 'iho' or $namespace = 'iso' or $namespace = 'jcgm'">
			<xsl:attribute name="margin-bottom">10pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:attribute name="space-before">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'plateau'">
			<xsl:attribute name="space-after">12pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- term-style -->
	
	<xsl:attribute-set name="term-name-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:if test="$namespace = 'jis'">
			<xsl:attribute name="space-after">2pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'plateau'">
			<xsl:attribute name="font-weight">normal</xsl:attribute>
			<xsl:attribute name="space-after">2pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- term-name-style -->
	
		<xsl:attribute-set name="preferred-block-style">
		<xsl:if test="$namespace = 'csd'">
			<xsl:attribute name="line-height">1.1</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="line-height">1.1</xsl:attribute>
			<xsl:attribute name="space-before">14pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="line-height">1.1</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="line-height">1.1</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jcgm'">
			<xsl:attribute name="line-height">1.1</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
		</xsl:if>
	</xsl:attribute-set> <!-- preferred-block-style -->

	<xsl:attribute-set name="preferred-term-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="line-height">1</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:attribute name="line-height">1</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:attribute name="font-weight">normal</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'plateau'">
			<xsl:attribute name="font-weight">normal</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- preferred-term-style -->

	<xsl:attribute-set name="domain-style">
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="padding-left">7.4mm</xsl:attribute>
		</xsl:if>		
	</xsl:attribute-set> <!-- domain-style -->

	<xsl:attribute-set name="admitted-style">
		<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jcgm'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="color">black</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- admitted-style -->

	<xsl:attribute-set name="deprecates-style">
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="font-size">8pt</xsl:attribute>
			<xsl:attribute name="margin-top">5pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">5pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="color">black</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- deprecates-style -->
	
	<xsl:attribute-set name="related-block-style" use-attribute-sets="preferred-block-style">
	</xsl:attribute-set>

	<xsl:attribute-set name="definition-style">
		<xsl:if test="$namespace = 'csa' or $namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="space-after">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csd' or $namespace = 'iec' or $namespace = 'iho' or $namespace = 'iso' or $namespace = 'jcgm'">
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:attribute name="space-before">2pt</xsl:attribute>
			<xsl:attribute name="space-after">2pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
			<xsl:attribute name="space-before">12pt</xsl:attribute>
			<xsl:attribute name="space-after">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'plateau'">
			<xsl:attribute name="space-before">2pt</xsl:attribute>
			<xsl:attribute name="space-after">2pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- definition-style -->
	
	<xsl:attribute-set name="termsource-style">
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="text-align">right</xsl:attribute>
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa' or $namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csd' or $namespace = 'iec'">
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="text-indent">7.4mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso' or $namespace = 'jcgm'">
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:attribute name="margin-left">6mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- termsource-style -->
	
	<xsl:template name="refine_termsource-style">
		<xsl:if test="$namespace = 'bsi'">
			<xsl:if test="$document_type = 'PAS'">
				<xsl:attribute name="text-align">left</xsl:attribute>
				<xsl:attribute name="space-before">12pt</xsl:attribute>
				<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'plateau'">
			<xsl:if test="ancestor::mn:table">
				<xsl:attribute name="margin-bottom">1pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template> <!-- refine_termsource-style -->
	
	<xsl:attribute-set name="termsource-text-style">
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="color"><xsl:value-of select="$color_blue"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="padding-right">1mm</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- termsource-text-style -->
	
	<xsl:attribute-set name="origin-style">
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="color">rgb(33, 94, 159)</xsl:attribute>
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="color">blue</xsl:attribute>
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
		</xsl:if>
	</xsl:attribute-set> <!-- origin-style -->
	
</xsl:stylesheet>