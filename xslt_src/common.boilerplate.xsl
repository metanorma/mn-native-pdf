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

	<!-- boilerplate sections styles -->
	<xsl:attribute-set name="copyright-statement-style">
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="font-size">8pt</xsl:attribute>
			<xsl:attribute name="line-height">125%</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- copyright-statement-style -->
	
	<xsl:attribute-set name="copyright-statement-title-style">
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="color"><xsl:value-of select="$color_text_title"/></xsl:attribute>
			<xsl:attribute name="margin-top">24pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:attribute name="font-family">Lato</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- copyright-statement-title-style -->
	
	<xsl:attribute-set name="copyright-statement-p-style">
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="space-after">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:attribute name="text-align">left</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- copyright-statement-p-style -->

		<xsl:attribute-set name="license-statement-style">
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="font-family">Times New Roman</xsl:attribute>
			<xsl:attribute name="font-size">10.5pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="font-size">8pt</xsl:attribute>
			<xsl:attribute name="line-height">125%</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- license-statement-style -->
	
	<xsl:attribute-set name="license-statement-title-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="text-align">center</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-sp'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="color"><xsl:value-of select="$color_text_title"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:attribute name="font-family">Lato</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="margin-top">4pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- license-statement-title-style -->
	
	<xsl:attribute-set name="license-statement-p-style">
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="text-align">justify</xsl:attribute>
			<xsl:attribute name="line-height">135%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="margin-left">1.5mm</xsl:attribute>
			<xsl:attribute name="margin-right">1.5mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:attribute name="font-size">8pt</xsl:attribute>
			<xsl:attribute name="margin-top">14pt</xsl:attribute>
			<xsl:attribute name="line-height">135%</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- license-statement-p-style -->

	<xsl:attribute-set name="legal-statement-style">
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="font-size">8pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
		</xsl:if>
	</xsl:attribute-set> <!-- legal-statement-style -->
	
	<xsl:attribute-set name="legal-statement-title-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp'">
			<xsl:attribute name="font-family">Arial</xsl:attribute>
			<xsl:attribute name="font-size">12pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="color"><xsl:value-of select="$color"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-sp'">
			<xsl:attribute name="font-family">Arial</xsl:attribute>
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:attribute name="font-family">Lato</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-weight">normal</xsl:attribute>
			<xsl:attribute name="padding-top">2mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- legal-statement-title-style -->
	
	<xsl:attribute-set name="legal-statement-p-style">
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:attribute name="text-align">left</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- legal-statement-p-style -->
	
	<xsl:attribute-set name="feedback-statement-style">
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="line-height">125%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="font-size">8pt</xsl:attribute>
			<xsl:attribute name="line-height">125%</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- feedback-statement-style -->
	
	<xsl:attribute-set name="feedback-statement-title-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- feedback-statement-title-style -->
	
	<xsl:attribute-set name="feedback-statement-p-style">
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- feedback-statement-p-style -->

	<!-- End boilerplate sections styles -->

	

</xsl:stylesheet>