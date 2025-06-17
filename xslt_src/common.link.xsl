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
	
	<xsl:attribute-set name="link-style">
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="color">rgb(58,88,168)</xsl:attribute>
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee' or $namespace = 'iso' or $namespace = 'csd' or $namespace = 'ogc-white-paper' or $namespace = 'm3d' or $namespace = 'iho' or $namespace = 'mpfd' or $namespace = 'bipm' or $namespace = 'jcgm'">
			<xsl:attribute name="color">blue</xsl:attribute>
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="color"><xsl:value-of select="$color_blue"/></xsl:attribute>
			<xsl:attribute name="font-weight">300</xsl:attribute><!-- bold -->
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="color">rgb(33, 94, 159)</xsl:attribute>
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>

	<xsl:template name="refine_link-style">
		<xsl:if test="$namespace = 'bsi'">
			<xsl:if test="$document_type = 'PAS'">
				<xsl:attribute name="color">inherit</xsl:attribute>
				<xsl:attribute name="text-decoration">none</xsl:attribute>
			</xsl:if>
			<xsl:if test="$doctype = 'flex-standard' and ancestor::mn:copyright-statement">
				<xsl:attribute name="color"><xsl:value-of select="$color_secondary_shade_1_PAS"/></xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:if test="$current_template = 'whitepaper' or $current_template = 'icap-whitepaper' or $current_template = 'industry-connection-report'">
				<xsl:attribute name="color"><xsl:value-of select="$color_blue"/></xsl:attribute>
				<xsl:attribute name="text-decoration">none</xsl:attribute>
			</xsl:if>
			<xsl:if test="$current_template = 'standard'">
				<xsl:attribute name="color"><xsl:value-of select="$color_blue"/></xsl:attribute>
				<xsl:attribute name="text-decoration">none</xsl:attribute>
				<xsl:if test="ancestor::mn:feedback-statement">
					<xsl:attribute name="text-decoration">underline</xsl:attribute>
				</xsl:if>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:if test="ancestor::*[self::mn:feedback-statement or self::mn:copyright-statement]">
				<xsl:attribute name="color">blue</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:if test="(ancestor::mn:copyright-statement and contains(@target, 'mailto:')) or
							($layoutVersion = '2024' and ancestor::mn:termsource)">
				<xsl:attribute name="color">inherit</xsl:attribute>
				<xsl:attribute name="text-decoration">none</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:if test="ancestor::mn:bibitem">
				<xsl:attribute name="color">black</xsl:attribute>
				<xsl:attribute name="text-decoration">none</xsl:attribute>
				<xsl:attribute name="font-weight">300</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template> <!-- refine_link-style -->

</xsl:stylesheet>