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
	
	<xsl:variable name="reviews_">
		<xsl:for-each select="//mn:annotation[not(parent::mn:annotation-container)][@from]">
			<xsl:copy>
				<xsl:copy-of select="@from"/>
				<xsl:copy-of select="@id"/>
			</xsl:copy>
		</xsl:for-each>
		<xsl:for-each select="//mn:fmt-annotation-start[@source]">
			<xsl:copy>
				<xsl:copy-of select="@source"/>
				<xsl:copy-of select="@id"/>
			</xsl:copy>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="reviews" select="xalan:nodeset($reviews_)"/>
	
	<xsl:template name="addReviewHelper">
		<xsl:if test="$isGenerateTableIF = 'false'">
			<!-- if there is review with from="...", then add small helper block for Annot tag adding, see 'review' template -->
			<xsl:variable name="curr_id" select="@id"/>
			<!-- <xsl:variable name="review_id" select="normalize-space(/@id)"/> -->
			<xsl:for-each select="$reviews//mn:annotation[@from = $curr_id]"> <!-- $reviews//mn:fmt-review-start[@source = $curr_id] -->
				<xsl:variable name="review_id" select="normalize-space(@id)"/>
				<xsl:if test="$review_id != ''"> <!-- i.e. if review found -->
					<fo:block keep-with-next="always" line-height="0.1" id="{$review_id}" font-size="1pt" role="SKIP"><xsl:value-of select="$hair_space"/><fo:basic-link internal-destination="{$review_id}" fox:alt-text="Annot___{$review_id}" role="Annot"><xsl:value-of select="$hair_space"/></fo:basic-link></fo:block>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
		<!-- <fo:block>
			<curr_id><xsl:value-of select="$curr_id"/></curr_id>
			<xsl:copy-of select="$reviews"/>
		</fo:block> -->
	</xsl:template>

	<!-- document text (not figures, or tables) footnotes -->
	<xsl:variable name="reviews_container_">
		<xsl:for-each select="//mn:annotation-container/mn:fmt-annotation-body">
			<xsl:variable name="update_xml_step1">
				<xsl:apply-templates select="." mode="update_xml_step1"/>
			</xsl:variable>
			<xsl:apply-templates select="xalan:nodeset($update_xml_step1)" mode="update_xml_enclose_keep-together_within-line"/>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="reviews_container" select="xalan:nodeset($reviews_container_)"/>
  
	<xsl:template match="mn:annotation-container"/>
	
	<!-- for old Presentation XML (before https://github.com/metanorma/isodoc/issues/670) -->
	<xsl:template match="mn:annotation[not(parent::mn:annotation-container)]">  <!-- 'review' will be processed in mn2pdf/review.xsl -->
		<xsl:variable name="id_from" select="normalize-space(current()/@from)"/>
		<xsl:if test="$isGenerateTableIF = 'false'">
		<xsl:choose>
			<!-- if there isn't the attribute '@from', then -->
			<xsl:when test="$id_from = ''">
				<fo:block id="{@id}" font-size="1pt" role="SKIP"><xsl:value-of select="$hair_space"/><fo:basic-link internal-destination="{@id}" fox:alt-text="Annot___{@id}" role="Annot"><xsl:value-of select="$hair_space"/></fo:basic-link></fo:block>
			</xsl:when>
			<!-- if there isn't element with id 'from', then create 'bookmark' here -->
			<xsl:when test="ancestor::mn:metanorma and not(ancestor::mn:metanorma//*[@id = $id_from])">
				<fo:block id="{@from}" font-size="1pt" role="SKIP"><xsl:value-of select="$hair_space"/><fo:basic-link internal-destination="{@from}" fox:alt-text="Annot___{@id}" role="Annot"><xsl:value-of select="$hair_space"/></fo:basic-link></fo:block>
			</xsl:when>
			<xsl:when test="not(/*[@id = $id_from]) and not(/*//*[@id = $id_from]) and not(preceding-sibling::*[@id = $id_from])">
				<fo:block id="{@from}" font-size="1pt" role="SKIP"><xsl:value-of select="$hair_space"/><fo:basic-link internal-destination="{@from}" fox:alt-text="Annot___{@id}" role="Annot"><xsl:value-of select="$hair_space"/></fo:basic-link></fo:block>
			</xsl:when>
		</xsl:choose>
		</xsl:if>
	</xsl:template>
	
	<!-- for new Presentation XML (https://github.com/metanorma/isodoc/issues/670) -->
	<xsl:template match="mn:fmt-annotation-start" name="fmt-annotation-start"> <!-- 'review' will be processed in mn2pdf/review.xsl -->
		<!-- comment 2019-11-29 -->
		<!-- <fo:block font-weight="bold">Review:</fo:block>
		<xsl:apply-templates /> -->
		
		<xsl:variable name="id_from" select="normalize-space(current()/@source)"/>

		<xsl:variable name="source" select="normalize-space(@source)"/>
		
		<xsl:if test="$isGenerateTableIF = 'false'">
		<!-- <xsl:variable name="id_from" select="normalize-space(current()/@from)"/> -->
		
		<!-- <xsl:if test="@source = @end"> -->
		<!-- following-sibling::node()[1][local-name() = 'bookmark'][@id = $source] and
				following-sibling::node()[2][local-name() = 'fmt-review-end'][@source = $source] -->
			<!-- <fo:block id="{$source}" font-size="1pt" role="SKIP"><xsl:value-of select="$hair_space"/><fo:basic-link internal-destination="{$source}" fox:alt-text="Annot___{$source}" role="Annot"><xsl:value-of select="$hair_space"/></fo:basic-link></fo:block> -->
			<xsl:call-template name="setNamedDestination"/>
			<fo:block id="{@id}" font-size="1pt" role="SKIP" keep-with-next="always" line-height="0.1"><xsl:value-of select="$hair_space"/><fo:basic-link internal-destination="{@id}" fox:alt-text="Annot___{@id}" role="Annot"><xsl:value-of select="$hair_space"/></fo:basic-link></fo:block>
		<!-- </xsl:if> -->
		</xsl:if>
		
		<xsl:if test="1 = 2">
		<xsl:choose>
			<!-- if there isn't the attribute '@from', then -->
			<xsl:when test="$id_from = ''">
				<fo:block id="{@id}" font-size="1pt" role="SKIP"><xsl:value-of select="$hair_space"/><fo:basic-link internal-destination="{@id}" fox:alt-text="Annot___{@id}" role="Annot"><xsl:value-of select="$hair_space"/></fo:basic-link></fo:block>
			</xsl:when>
			<!-- if there isn't element with id 'from', then create 'bookmark' here -->
			<xsl:when test="ancestor::mn:metanorma and not(ancestor::mn:metanorma//*[@id = $id_from])">
				<fo:block id="{$id_from}" font-size="1pt" role="SKIP"><xsl:value-of select="$hair_space"/><fo:basic-link internal-destination="{$id_from}" fox:alt-text="Annot___{@id}" role="Annot"><xsl:value-of select="$hair_space"/></fo:basic-link></fo:block>
			</xsl:when>
			<xsl:when test="not(/*[@id = $id_from]) and not(/*//*[@id = $id_from]) and not(preceding-sibling::*[@id = $id_from])">
				<fo:block id="{$id_from}" font-size="1pt" role="SKIP"><xsl:value-of select="$hair_space"/><fo:basic-link internal-destination="{$id_from}" fox:alt-text="Annot___{@id}" role="Annot"><xsl:value-of select="$hair_space"/></fo:basic-link></fo:block>
			</xsl:when>
		</xsl:choose>
		</xsl:if>
		
    <xsl:if test="1 = 2">
		<xsl:choose>
			<!-- if there isn't the attribute '@from', then -->
			<xsl:when test="$id_from = ''">
				<fo:block id="{@id}" font-size="1pt" role="SKIP"><fo:wrapper role="artifact"><xsl:value-of select="$hair_space"/></fo:wrapper></fo:block>
			</xsl:when>
			<!-- if there isn't element with id 'from', then create 'bookmark' here -->
			<xsl:when test="ancestor::mn:metanorma and not(ancestor::mn:metanorma//*[@id = $id_from])">
				<fo:block id="{@from}" font-size="1pt" role="SKIP"><fo:wrapper role="artifact"><xsl:value-of select="$hair_space"/></fo:wrapper></fo:block>
			</xsl:when>
			<xsl:when test="not(/*[@id = $id_from]) and not(/*//*[@id = $id_from]) and not(preceding-sibling::*[@id = $id_from])">
				<fo:block id="{@from}" font-size="1pt" role="SKIP"><fo:wrapper role="artifact"><xsl:value-of select="$hair_space"/></fo:wrapper></fo:block>
			</xsl:when>
		</xsl:choose>
    </xsl:if>
		
	</xsl:template>

	<!-- https://github.com/metanorma/mn-samples-bsi/issues/312 -->
	<xsl:template match="mn:annotation[@type = 'other']"/>

</xsl:stylesheet>