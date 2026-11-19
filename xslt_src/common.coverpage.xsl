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
	
	<xsl:template name="cover-pages">
		<xsl:param name="num"/>
		<xsl:call-template name="cover-page">
			<xsl:with-param name="num" select="$num"/>
		</xsl:call-template>
	</xsl:template>

	<!-- insert cover page image -->
	<!-- background cover image -->
	<xsl:template name="insertBackgroundPageImage">
		<xsl:param name="number">1</xsl:param>
		<xsl:param name="name">coverpage-image</xsl:param>
		<xsl:param name="suffix"/>
		<xsl:variable name="num" select="number($number)"/>
		<!-- background image -->
		<fo:block-container absolute-position="fixed" left="0mm" top="0mm" font-size="0" id="__internal_layout__coverpage{$suffix}_{$name}_{$number}_{generate-id()}">
			<fo:block>
				<xsl:for-each select="/mn:metanorma/mn:metanorma-extension/mn:presentation-metadata/*[local-name() = $name][1]/mn:image[$num]">
					
					<xsl:call-template name="insertPageImage"/>
					
				</xsl:for-each>
			</fo:block>
		</fo:block-container>
	</xsl:template>
	
	<!-- for https://github.com/metanorma/mn-native-pdf/issues/845 -->
	<xsl:template name="insertCoverPageFullImage">
		<xsl:param name="name">coverpage-image</xsl:param>
		<xsl:for-each select="//mn:metanorma/mn:metanorma-extension/mn:presentation-metadata/*[local-name() = $name][1]/mn:image">
			<fo:page-sequence master-reference="cover-page" force-page-count="no-force" initial-page-number="1">
				<xsl:if test="$namespace = 'bipm' and position() = 1">
					<xsl:attribute name="force-page-count">even</xsl:attribute>
				</xsl:if>
				<fo:flow flow-name="xsl-region-body">
					<xsl:call-template name="insertBackgroundPageImage">
						<xsl:with-param name="number" select="position()"/>
					</xsl:call-template>
				</fo:flow>
			</fo:page-sequence>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template name="insertPageImage">
		<xsl:param name="svg_content_height" select="$pageHeight"/>
		<xsl:param name="bitmap_width" select="$pageWidth"/>
		<xsl:choose>
			<xsl:when test="*[local-name() = 'svg'] or java:endsWith(java:java.lang.String.new(@src), '.svg')">
				<fo:instream-foreign-object fox:alt-text="Image Front" fox:placement="Block">
					<xsl:attribute name="content-height"><xsl:value-of select="$svg_content_height"/>mm</xsl:attribute>
					<xsl:call-template name="getSVG"/>
				</fo:instream-foreign-object>
			</xsl:when>
			<xsl:when test="starts-with(@src, 'data:application/pdf;base64')">
				<fo:external-graphic src="{@src}" fox:alt-text="Image Front" fox:placement="Block"/>
			</xsl:when>
			<xsl:otherwise> <!-- bitmap image -->
				<xsl:variable name="coverimage_src" select="normalize-space(@src)"/>
				<xsl:if test="$coverimage_src != ''">
					<xsl:variable name="coverpage">
						<xsl:call-template name="getImageURL">
							<xsl:with-param name="src" select="$coverimage_src"/>
						</xsl:call-template>
					</xsl:variable>
					<fo:external-graphic src="{$coverpage}" width="{$bitmap_width}mm" content-height="scale-to-fit" scaling="uniform" fox:alt-text="Image Front" fox:placement="Block"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="getImageURL">
		<xsl:param name="src"/>
		<xsl:choose>
			<xsl:when test="starts-with($src, 'data:image')">
				<xsl:value-of select="$src"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="src_external"><xsl:call-template name="getImageSrcExternal"/></xsl:variable>
				<xsl:value-of select="concat('url(file:///', $src_external, ')')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="getSVG">
		<xsl:choose>
			<xsl:when test="*[local-name() = 'svg']">
				<xsl:apply-templates select="*[local-name() = 'svg']" mode="svg_update"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="svg_content" select="document(@src)"/>
				<xsl:for-each select="xalan:nodeset($svg_content)/node()">
					<xsl:apply-templates select="." mode="svg_update"/>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- END: insert cover page image -->
</xsl:stylesheet>