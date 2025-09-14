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
	
	<xsl:attribute-set name="p-zzSTDTitle1-style">
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="font-family">Arial</xsl:attribute>
			<xsl:attribute name="font-size">23pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="margin-top">84pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">52pt</xsl:attribute>
			<xsl:attribute name="line-height">1.1</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>

	<xsl:template name="refine_p-zzSTDTitle1-style">
		<xsl:if test="$namespace = 'ieee'">
			<xsl:if test="(contains('amendment corrigendum erratum', $subdoctype) and $subdoctype != '') or
						$current_template = 'standard'">
				<xsl:attribute name="font-size">24pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>