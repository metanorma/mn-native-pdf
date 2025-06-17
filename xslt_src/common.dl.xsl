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
	
	<!-- ========================== -->
	<!-- Definition's list styles -->
	<!-- ========================== -->
	
	<xsl:attribute-set name="dl-block-style">
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'plateau'">
			<xsl:attribute name="margin-bottom">16pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="dt-row-style">
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="min-height">8.5mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="min-height">7mm</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="dt-cell-style">
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="padding-top">0.5mm</xsl:attribute>
			<xsl:attribute name="padding-right">5mm</xsl:attribute>
			<xsl:attribute name="padding-left">1mm</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:template name="refine_dt-cell-style">
		<xsl:if test="$namespace = 'itu'">
			<xsl:if test="ancestor::*[1][self::mn:dl]/preceding-sibling::*[1][self::mn:formula]">						
				<xsl:attribute name="padding-right">3mm</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:if test="not(ancestor::mn:sourcecode)">
				<!-- <xsl:attribute name="border-left">1pt solid <xsl:value-of select="$color_design"/></xsl:attribute> -->
				<xsl:attribute name="background-color"><xsl:value-of select="$color_dl_dt"/></xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template> <!-- refine_dt-cell-style -->
	
	<xsl:attribute-set name="dt-block-style">
		<xsl:attribute name="margin-top">0pt</xsl:attribute>
		<xsl:if test="$namespace = 'csd'">
			<xsl:attribute name="margin-left">7mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="margin-left">2mm</xsl:attribute>
			<xsl:attribute name="line-height">1.2</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:attribute name="line-height">1.5</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp' or $namespace = 'nist-sp'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="color"><xsl:value-of select="$color_blue"/></xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:template name="refine_dt-block-style">
		<xsl:if test="$namespace = 'iso'">
			<xsl:if test="$layoutVersion = '2024'">
				<xsl:attribute name="margin-bottom">9pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:if test="ancestor::*[1][self::mn:dl]/preceding-sibling::*[1][self::mn:formula]">
				<xsl:attribute name="text-align">right</xsl:attribute>							
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:if test="ancestor::mn:sourcecode">
				<xsl:attribute name="margin-bottom">2pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="not(following-sibling::mn:dt)"> <!-- last dt -->
				<xsl:attribute name="margin-bottom">0</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template> <!-- refine_dt-block-style -->

	
	<xsl:attribute-set name="dl-name-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		<xsl:if test="$namespace = 'bsi'">
		</xsl:if>	
		<xsl:if test="$namespace = 'itu' or $namespace = 'csd' or $namespace = 'm3d'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="font-weight">normal</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="font-famuily">Arial</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="font-weight">normal</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso' or $namespace = 'jcgm'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>		
		<xsl:if test="$namespace = 'nist-cswp'  or $namespace = 'nist-sp'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">							
			<xsl:attribute name="font-weight">normal</xsl:attribute>
			<xsl:attribute name="color"><xsl:value-of select="$color_text_title"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:attribute name="color">rgb(68, 84, 106)</xsl:attribute>
			<xsl:attribute name="font-weight">normal</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece'">
			<xsl:attribute name="font-weight">normal</xsl:attribute>
		</xsl:if>		
		<xsl:if test="$namespace = 'unece-rec'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'mpfd'">
		</xsl:if>
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-weight">300</xsl:attribute>
			<xsl:attribute name="color">black</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- dl-name-style -->
	
	<xsl:attribute-set name="dd-cell-style">
		<xsl:attribute name="padding-left">2mm</xsl:attribute>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="padding-top">0.5mm</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:template name="refine_dd-cell-style">
		<xsl:if test="$namespace = 'ogc'">
			<xsl:if test="not(ancestor::mn:sourcecode)">
				<xsl:attribute name="background-color"><xsl:value-of select="$color_dl_dd"/></xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template> <!-- refine_dd-cell-style -->

	
	<!-- ========================== -->
	<!-- END Definition's list styles -->
	<!-- ========================== -->
	
</xsl:stylesheet>