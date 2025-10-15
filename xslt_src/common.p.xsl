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

	<xsl:attribute-set name="p-style">
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="text-align">justify</xsl:attribute>
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
			<xsl:attribute name="line-height">1.13</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- p-style -->
	
	<xsl:template name="refine_p-style">
		<xsl:param name="element-name"/>
		<xsl:if test="$namespace = 'iso'">
			<xsl:call-template name="setBlockAttributes">
				<!-- <xsl:with-param name="text_align_default">justify</xsl:with-param> -->
				<xsl:with-param name="skip_text_align_default">true</xsl:with-param>
			</xsl:call-template>
			
			<xsl:if test="count(ancestor::mn:li) = 1 and not(ancestor::mn:li[1]/following-sibling::mn:li) and not(following-sibling::mn:p)">
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="starts-with(ancestor::mn:table[1]/@type, 'recommend') and not(following-sibling::mn:p)">
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="parent::*[self::mn:td or self::mn:th]">
				<xsl:choose>
					<xsl:when test="not(following-sibling::*)"> <!-- last paragraph in table cell -->
						<xsl:attribute name="margin-bottom">2pt</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="margin-bottom">5pt</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
				<!-- Special case: if paragraph in 'strong', i.e. it's sub-header, then keeps with next -->
				<xsl:if test="count(node()) = count(mn:strong) and following-sibling::*">
					<xsl:attribute name="keep-with-next">always</xsl:attribute>
				</xsl:if>
			</xsl:if>
			
			<xsl:copy-of select="@id"/>
			
			<!-- bookmarks only in paragraph -->
			<xsl:if test="count(mn:bookmark) != 0 and count(*) = count(mn:bookmark) and normalize-space() = ''">
				<xsl:attribute name="font-size">0</xsl:attribute>
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
				<xsl:attribute name="line-height">0</xsl:attribute>
			</xsl:if>
			<xsl:if test="$element-name = 'fo:inline'">
				<xsl:attribute name="role">P</xsl:attribute>
			</xsl:if>
			<xsl:if test="ancestor::*[self::mn:li or self::mn:td or self::mn:th or self::mn:dd]">
				<xsl:attribute name="role">SKIP</xsl:attribute>
			</xsl:if>
			<!-- <xsl:apply-templates>
				<xsl:with-param name="split_keep-within-line" select="$split_keep-within-line"/>
			</xsl:apply-templates> -->
			<!-- <xsl:apply-templates select="node()[not(self::mn:note[not(following-sibling::*) or count(following-sibling::*) = count(../mn:note) - 1])]"> -->
			
			<xsl:if test="$layoutVersion = '1951'">
				<xsl:if test="not(ancestor::*[self::mn:li or self::mn:td or self::mn:th or self::mn:dd])">
					<!-- for paragraphs in the main text -->
					<xsl:choose>
						<xsl:when test="$revision_date_num &lt; 19600101">
							<xsl:attribute name="margin-bottom">14pt</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
				<xsl:if test="(ancestor::mn:preface and parent::mn:clause) or ancestor::mn:foreword">
					<xsl:attribute name="text-indent">7.1mm</xsl:attribute>
				</xsl:if>
			</xsl:if>
			
			<xsl:if test="$layoutVersion != '2024'">
				<xsl:attribute name="line-height">1.2</xsl:attribute>
				<xsl:if test="ancestor::mn:preface">
					<xsl:attribute name="line-height">1.15</xsl:attribute>
				</xsl:if>
			</xsl:if>
			
			<xsl:if test="$layoutVersion = '2024'">
				<xsl:if test="parent::mn:li/following-sibling::* or parent::mn:dd">
					<xsl:attribute name="margin-bottom">9pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<!-- $namespace = 'iso' -->
		</xsl:if>
	</xsl:template> <!-- refine_p-style -->

</xsl:stylesheet>