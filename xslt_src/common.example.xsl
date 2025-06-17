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
	
	<xsl:attribute-set name="termexample-style">
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="margin-top">14pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">10pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa' or $namespace = 'csd' or $namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="font-size">9pt</xsl:attribute>
			<xsl:attribute name="margin-top">14pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">14pt</xsl:attribute>
			<xsl:attribute name="text-align">justify</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="margin-top">8pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
			<xsl:attribute name="text-align">justify</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho' or $namespace = 'iso' or $namespace = 'jcgm'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-top">8pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
			<xsl:attribute name="text-align">justify</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jis' or $namespace = 'plateau'">
			<xsl:attribute name="margin-top">4pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">4pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'm3d'">			
			<xsl:attribute name="margin-top">14pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">14pt</xsl:attribute>
			<xsl:attribute name="text-align">justify</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- termexample-style -->

	<xsl:template name="refine_termexample-style">
		<xsl:if test="$namespace = 'iso'">
			<xsl:if test="$layoutVersion = '1972' or $layoutVersion = '1979' or $layoutVersion = '1987' or $layoutVersion = '1989'">
				<xsl:attribute name="font-size">9pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template> <!-- refine_termexample-style -->
	
	<xsl:attribute-set name="termexample-name-style">
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="font-style">italic</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa' or $namespace = 'csd' or $namespace = 'iec' or $namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="padding-right">10mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="padding-right">1mm</xsl:attribute>
			<xsl:attribute name="font-family">SimHei</xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'bsi' or $namespace = 'iho' or $namespace = 'iso' or $namespace = 'jcgm'">
			<xsl:attribute name="padding-right">5mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="padding-right">9mm</xsl:attribute>
			<xsl:attribute name="font-style">italic</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
		</xsl:if>
		<xsl:if test="$namespace = 'm3d'">
			<xsl:attribute name="padding-right">1mm</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>			
		</xsl:if>		
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="color"><xsl:value-of select="$color_blue"/></xsl:attribute>
			<xsl:attribute name="padding-right">0.5mm</xsl:attribute>
		</xsl:if>		
	</xsl:attribute-set> <!-- termexample-name-style -->

	<xsl:template name="refine_termexample-name-style">
		<xsl:if test="$namespace = 'iso'">
			<xsl:if test="$layoutVersion = '2024' and translate(.,'0123456789','') = ."> <!-- EXAMPLE without number -->
				<xsl:attribute name="padding-right">8mm</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:if test="not($vertical_layout = 'true')">
				<xsl:attribute name="font-family">IPAexGothic</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	
	<xsl:attribute-set name="example-style">
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'csd'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="margin-top">8pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
			<xsl:attribute name="text-align">justify</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb' or $namespace = 'iso' or $namespace = 'jcgm'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-top">8pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="space-before">8pt</xsl:attribute>
			<xsl:attribute name="space-after">8pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<!-- <xsl:attribute name="font-size">11pt</xsl:attribute> -->
			<xsl:attribute name="margin-top">4pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="text-align">justify</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'jis' or $namespace = 'plateau'">
			<xsl:attribute name="margin-top">4pt</xsl:attribute>			
			<xsl:attribute name="margin-bottom">4pt</xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'm3d'">
			<xsl:attribute name="margin-top">8pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">			
			<xsl:attribute name="margin-top">10pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">10pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>			
			<xsl:attribute name="margin-left">12.5mm</xsl:attribute>
			<xsl:attribute name="margin-right">12.5mm</xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="margin-left">15mm</xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'nist-sp'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="margin-left">12.5mm</xsl:attribute>			
			<xsl:attribute name="margin-right">12.5mm</xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="margin-top">12pt</xsl:attribute>			
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>			
		</xsl:if>
	</xsl:attribute-set> <!-- example-style -->

	<xsl:template name="refine_example-style">
		<xsl:if test="$namespace = 'iso'">
			<xsl:if test="$layoutVersion = '1972' or $layoutVersion = '1979' or $layoutVersion = '1987' or $layoutVersion = '1989'">
				<xsl:attribute name="font-size">9pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:if test="ancestor::mn:ul or ancestor::mn:ol">
				<xsl:attribute name="margin-top">6pt</xsl:attribute>
				<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template> <!-- refine_example-style -->

	<xsl:attribute-set name="example-body-style">
		<xsl:if test="$namespace = 'csa'">			
			<xsl:attribute name="margin-left">12.5mm</xsl:attribute>
			<xsl:attribute name="margin-right">12.5mm</xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'csd'">
			<xsl:attribute name="margin-left">12.5mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="margin-left">10mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">			
			<xsl:attribute name="margin-left">7mm</xsl:attribute>
			<xsl:attribute name="margin-right">7mm</xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'mpfd'">
			<xsl:attribute name="margin-left">12.5mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">18pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- example-body-style -->


	<xsl:attribute-set name="example-name-style">
		<xsl:if test="$namespace = 'csa'">			
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csd'">
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bsi' or $namespace = 'jcgm'">
			<xsl:attribute name="padding-right">5mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb' or $namespace = 'iso'">
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="padding-right">5mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="padding-right">9mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="padding-right">9mm</xsl:attribute>
			<xsl:attribute name="font-style">italic</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<!-- <xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute> -->
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			
		</xsl:if>
		<xsl:if test="$namespace = 'm3d'">
			<xsl:attribute name="padding-right">5mm</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp'">
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>			
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-sp'">
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>			
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="color"><xsl:value-of select="$color_blue"/></xsl:attribute>
			<xsl:attribute name="padding-right">0.5mm</xsl:attribute>
		</xsl:if>		
		<xsl:if test="$namespace = 'unece' or $namespace = 'unece-rec'">
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>			
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>		
		
		<xsl:if test="$namespace = 'mpfd'">
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>			
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="font-style">italic</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- example-name-style -->

	<xsl:template name="refine_example-name-style">
		<xsl:if test="$namespace = 'iso'">
			<xsl:if test="$layoutVersion = '2024' and translate(.,'0123456789','') = ."> <!-- EXAMPLE without number -->
				<xsl:attribute name="padding-right">8mm</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:if test="not($vertical_layout = 'true')">
				<xsl:attribute name="font-family">IPAexGothic</xsl:attribute>
			</xsl:if>
			<xsl:if test="$vertical_layout = 'true'">
				<xsl:attribute name="font-family">Noto Sans JP</xsl:attribute>
				<xsl:attribute name="font-weight">500</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'plateau'">
			<xsl:if test="ancestor::mn:figure">
				<xsl:attribute name="font-weight">bold</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	
	<xsl:attribute-set name="example-p-style">
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="margin-bottom">14pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csd'">			
			<xsl:attribute name="margin-bottom">14pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb' or $namespace = 'iso' or $namespace = 'jcgm'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-top">8pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="margin-top">5pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<!-- <xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="margin-left">12.7mm</xsl:attribute> -->
			<xsl:attribute name="space-before">2pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bsi' or $namespace = 'iso'">
			<xsl:attribute name="text-align">justify</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jis' or $namespace = 'plateau'">
			<xsl:attribute name="margin-bottom">2pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'm3d'">
			<xsl:attribute name="margin-top">8pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'rsd'">			
			<xsl:attribute name="margin-bottom">14pt</xsl:attribute>
		</xsl:if>
		
		<xsl:if test="$namespace = 'unece' or $namespace = 'unece-rec'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="margin-left">15mm</xsl:attribute>			
		</xsl:if>
		
		<xsl:if test="$namespace = 'mpfd'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>			
		</xsl:if>
		
	</xsl:attribute-set> <!-- example-p-style -->

	<xsl:template name="refine_example-p-style">
		<xsl:if test="$namespace = 'ieee'">
			<xsl:if test="not(preceding-sibling::mn:p)">
				<xsl:attribute name="margin-top">6pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp' or $namespace = 'unece' or $namespace = 'unece-rec'">
			<xsl:variable name="num"><xsl:number/></xsl:variable>
			<xsl:if test="$num = 1">
				<xsl:attribute name="margin-left">5mm</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template> <!-- refine_example-p-style -->
	
</xsl:stylesheet>