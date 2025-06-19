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
	
	<!-- ===================================== -->
	<!-- ===================================== -->
	<!-- Ruby text (CJK languages) rendering -->
	<!-- ===================================== -->
	<!-- ===================================== -->
	<xsl:template match="mn:ruby">
		<fo:inline-container text-indent="0mm" last-line-end-indent="0mm">
			<xsl:if test="not(ancestor::mn:ruby)">
				<xsl:attribute name="alignment-baseline">central</xsl:attribute>
			</xsl:if>
			<xsl:variable name="rt_text" select="mn:rt"/>
			<xsl:variable name="rb_text" select=".//mn:rb[not(mn:ruby)]"/>
			<!-- Example: width="2em"  -->
			<xsl:variable name="text_rt_width" select="java:org.metanorma.fop.Util.getStringWidthByFontSize($rt_text, $font_main, 6)"/>
			<xsl:variable name="text_rb_width" select="java:org.metanorma.fop.Util.getStringWidthByFontSize($rb_text, $font_main, 10)"/>
			<xsl:variable name="text_width">
				<xsl:choose>
					<xsl:when test="$text_rt_width &gt;= $text_rb_width"><xsl:value-of select="$text_rt_width"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="$text_rb_width"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:attribute name="width"><xsl:value-of select="$text_width div 10"/>em</xsl:attribute>
			
			<xsl:choose>
				<xsl:when test="ancestor::mn:ruby">
					<xsl:apply-templates select="mn:rb"/>
					<xsl:apply-templates select="mn:rt"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="mn:rt"/>
					<xsl:apply-templates select="mn:rb"/>
				</xsl:otherwise>
			</xsl:choose>
			
			<xsl:apply-templates select="node()[not(self::mn:rt) and not(self::mn:rb)]"/>
		</fo:inline-container>
	</xsl:template>
	
	<xsl:template match="mn:rb">
		<fo:block line-height="1em" text-align="center"><xsl:apply-templates /></fo:block>
	</xsl:template>
	
	<xsl:template match="mn:rt">
		<fo:block font-size="0.5em" text-align="center" line-height="1.2em" space-before="-1.4em" space-before.conditionality="retain"> <!--  -->
			<xsl:if test="ancestor::mn:ruby[last()]//mn:ruby or
					ancestor::mn:rb">
				<xsl:attribute name="space-before">0em</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates />
		</fo:block>
		
	</xsl:template>
	
	<!-- ===================================== -->
	<!-- ===================================== -->
	<!-- END: Ruby text (CJK languages) rendering -->
	<!-- ===================================== -->
	<!-- ===================================== -->	
	
</xsl:stylesheet>