<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xalan="http://xml.apache.org/xalan" xmlns:java="http://xml.apache.org/xalan/java" version="1.0">

	<xsl:param name="xslfile"/>

	<xsl:template match="node()|@*">
			<xsl:copy>
					<xsl:apply-templates select="node()|@*"/>
			</xsl:copy>
	</xsl:template>

	<xsl:variable name="namespace" select="//xsl:variable[@name = 'namespace']"/>

	<xsl:variable name="apos">'</xsl:variable>

	<xsl:template match="/">
		<xsl:variable name="xml">
			<xsl:apply-templates />
		</xsl:variable>
		<xsl:apply-templates select="xalan:nodeset($xml)" mode="whitespaces"/>
	</xsl:template>

	<xsl:template match="xsl:stylesheet">
		<xsl:copy>
				<xsl:apply-templates select="node()|@*"/>
				<xsl:choose>
					<xsl:when test="contains($xslfile, 'presentation')">
						<xsl:apply-templates select="document('common.presentation.xsl')/xsl:stylesheet/node()"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="document('common.xsl')/xsl:stylesheet/node()"/>
					</xsl:otherwise>
				</xsl:choose>

		</xsl:copy>
	</xsl:template>

	<xsl:template match="xsl:include"/>
	<xsl:template match="xsl:variable[@name = 'namespace']"/>

	<xsl:template match="xsl:if[contains(@test, '$namespace')]">
		<xsl:if test="contains(@test, concat($apos, $namespace, $apos))">
			<xsl:apply-templates select="node()"/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="xsl:choose[contains(xsl:when/@test, '$namespace')]">
		<xsl:apply-templates select="xsl:when[contains(@test, concat($apos, $namespace, $apos))]"/>
		<xsl:if test="not(xsl:when[contains(@test, concat($apos, $namespace, $apos))])">
			<xsl:apply-templates select="xsl:otherwise/node()"/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="xsl:when[contains(@test, '$namespace')]">
		<xsl:if test="contains(@test, concat($apos, $namespace, $apos))">
			<xsl:apply-templates select="node()"/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="node()|@*" mode="whitespaces">
			<xsl:copy>
					<xsl:apply-templates select="node()|@*" mode="whitespaces"/>
			</xsl:copy>
	</xsl:template>

	<xsl:template match="text()" mode="whitespaces">
		<xsl:variable name="text_without_trailing_spaces" select="java:replaceAll(java:java.lang.String.new(.),'^(\h+)(\v+)','$2')"/>
		<xsl:variable name="text_without_leading_spaces_multiline" select="java:replaceAll(java:java.lang.String.new($text_without_trailing_spaces),'(\v)((\h+)\v){2,}','$1$1$1')"/>
		<xsl:variable name="text_without_leading_spaces" select="java:replaceAll(java:java.lang.String.new($text_without_leading_spaces_multiline),'(\v)\h+\v','$1$1')"/>
		<xsl:variable name="text_without_empty_multilines" select="java:replaceAll(java:java.lang.String.new($text_without_leading_spaces),'^(\v+){3,}','$1$1')"/>
		<xsl:value-of select="$text_without_empty_multilines"/>
	</xsl:template>

	<xsl:template match="abc/text()">

		<xsl:variable name="text_without_trailing_spaces" select="java:replaceAll(java:java.lang.String.new(.),'^(\h+)(\v+)','$2')"/>
		
		<xsl:variable name="text_without_leading_spaces" select="java:replaceAll(java:java.lang.String.new($text_without_trailing_spaces),'(\v+)((\h+)(\v+))+','$1$1')"/>
		
		<xsl:variable name="text_without_empty_multilines" select="java:replaceAll(java:java.lang.String.new($text_without_leading_spaces),'^(\v+){3,}','$1$1')"/>
		
		<xsl:value-of select="$text_without_empty_multilines"/>
		
		<!-- <xsl:text>start</xsl:text>
		<xsl:value-of select="."/>
		<xsl:text>end</xsl:text> -->
	</xsl:template>
	
</xsl:stylesheet>
