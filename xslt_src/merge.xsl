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
	
	<!-- ======================== -->
	<!-- Pretty print XML         -->
	<!-- ======================== -->
	
	<!-- remove one tab for pretty print (text aligment) -->
	<xsl:template match="*[self::xsl:if][contains(@test, '$namespace')]//text()[normalize-space() = '' and contains(., '&#x09;')]">
		<xsl:variable name="text" select="substring(., 1, string-length(.) - 1)"/>
		<xsl:choose>
			<xsl:when test="parent::*[self::xsl:if] and position() = 1">
				<!-- remove CR or LF at start -->
				<!-- <xsl:value-of select="java:replaceAll(java:java.lang.String.new($text),'^(&#x0d;&#x0a;|&#x0d;|&#x0a;)', '')"/> -->
				<xsl:value-of select="$text"/>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="$text"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- remove two tabs for pretty print (text aligment) -->
	<xsl:template match="*[self::xsl:when][contains(@test, '$namespace')]//text()[normalize-space() = '' and contains(., '&#x09;')]">
		<xsl:value-of select="substring(., 1, string-length(.) - 2)"/>
	</xsl:template>
	
	<xsl:template match="*[self::xsl:otherwise][preceding-sibling::*[self::xsl:when][contains(@test, '$namespace')]]//text()[normalize-space() = '' and contains(., '&#x09;')]">
		<xsl:value-of select="substring(., 1, string-length(.) - 2)"/>
	</xsl:template>
	
	
	<!-- text before <xsl:if namespace=... -->
	<xsl:template match="text()[normalize-space() = ''][following-sibling::node()[1][self::xsl:if and contains(@test, '$namespace')]]"/>
	<!-- text after <xsl:if namespace=... -->
	<xsl:template match="text()[normalize-space() = ''][parent::*[self::xsl:if and contains(@test, '$namespace')]][not(following-sibling::node())]"/>

	<!-- text before <xsl:choose><xsl:when namespace=... -->
	<xsl:template match="text()[normalize-space() = ''][following-sibling::node()[1][self::xsl:choose][*[self::xsl:when and contains(@test, '$namespace')]]]"/>

	<!-- text between <choose> and <xsl:when namespace=... -->
	<!-- <xsl:template match="text()[normalize-space() = ''][parent::*[self::xsl:choose[*[self::xsl:when and contains(@test, '$namespace')]]]]"/> -->
	
	<!-- text after <choose -->
	<!-- <xsl:template match="text()[normalize-space() = ''][preceding-sibling::node()[1][self::xsl:choose][*[self::xsl:when and contains(@test, '$namespace')]]][not(following-sibling::node())]">z</xsl:template> -->
	
	<!-- text before otherwise in choose -->
	<xsl:template match="text()[normalize-space() = ''][parent::xsl:otherwise][../parent::*[self::xsl:choose[*[self::xsl:when and contains(@test, '$namespace')]]]][not(following-sibling::node())]"/>
	
	<!-- ======================== -->
	<!-- END: Pretty print XML    -->
	<!-- ======================== -->


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

</xsl:stylesheet>
