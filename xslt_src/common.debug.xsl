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
	
	<!-- debug templates -->
	<xsl:template name="debug_contents">
		<xsl:if test="$debug = 'true'">
			<redirect:write file="contents_.xml"> <!-- {java:getTime(java:java.util.Date.new())} -->
				<xsl:copy-of select="$contents"/>
			</redirect:write>
		</xsl:if>
	</xsl:template>
	
	<xsl:if test="$namespace = 'ogc'">
	<xsl:template name="debug_toc_recommendations">
		<xsl:if test="$debug = 'true'">
			<redirect:write file="toc_recommendations.xml"> <!-- {java:getTime(java:java.util.Date.new())} -->
				<xsl:copy-of select="$toc_recommendations"/>
			</redirect:write>
		</xsl:if>
	</xsl:template>
	</xsl:if>

</xsl:stylesheet>