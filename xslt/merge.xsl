<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" version="1.0">
	
	<xsl:template match="node()|@*">
			<xsl:copy>
					<xsl:apply-templates select="node()|@*"/>
			</xsl:copy>
	</xsl:template>
	
	<xsl:variable name="namespace" select="//xsl:variable[@name = 'namespace']"/>
	
	<xsl:variable name="apos">'</xsl:variable>
	
	<xsl:template match="xsl:stylesheet">
		<xsl:copy>
				<xsl:apply-templates select="node()|@*"/>
				<!-- <test2></test2> -->
				
				<xsl:apply-templates select="document('common.xsl')/xsl:stylesheet/*"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="xsl:include"/>
	<xsl:template match="xsl:variable[@name = 'namespace']"/>
	
	<xsl:template match="xsl:if[contains(@test, '$namespace')]">
		<xsl:if test="contains(@test, concat('$namespace = ', $apos, $namespace, $apos))">
			<xsl:apply-templates select="node()"/>
		</xsl:if>
	</xsl:template>
	
</xsl:stylesheet>
