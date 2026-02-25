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
	
	<xsl:attribute-set name="form-checkbox-style">
		<xsl:attribute name="border">0.5pt solid black</xsl:attribute>
		<xsl:attribute name="background-color">yellow</xsl:attribute>
	</xsl:attribute-set>
	
	<!-- =================== -->
	<!-- Form's elements processing -->
	<!-- =================== -->
	<xsl:template match="mn:form">
		<fo:block>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="mn:form//mn:label">
		<fo:inline><xsl:apply-templates /></fo:inline>
	</xsl:template>
	
	<xsl:template match="mn:form//mn:input[@type = 'text']">
		<!-- add helper id for mn2pdf class FOPIFFormsHandler  (_metanorma_form_item_border_) -->
		<fo:inline>
			<xsl:call-template name="set_id_metanorma_form_item">
				<xsl:with-param name="border_prefix">border_</xsl:with-param>
			</xsl:call-template>
			<xsl:value-of select="$hair_space"/>
		</fo:inline>
		<fo:inline border="1pt solid black"><!-- don't remove, this border needs for mn2pdf FOPIFFormsHandler -->
			<fo:inline>
				<xsl:call-template name="set_id_metanorma_form_item"/>
				<xsl:call-template name="text_input"/>
			</fo:inline>
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="mn:form//mn:input[@type = 'date' or @type = 'file' or @type = 'password']">
		<fo:inline>
			<xsl:call-template name="text_input"/>
		</fo:inline>
	</xsl:template>
	
	<xsl:template name="text_input">
		<xsl:variable name="count">
			<xsl:choose>
				<xsl:when test="normalize-space(@maxlength) != ''"><xsl:value-of select="@maxlength"/></xsl:when>
				<xsl:when test="normalize-space(@size) != ''"><xsl:value-of select="@size"/></xsl:when>
				<xsl:otherwise>10</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:call-template name="repeat">
			<xsl:with-param name="char" select="'_'"/>
			<xsl:with-param name="count" select="$count"/>
		</xsl:call-template>
		<xsl:text> </xsl:text>
	</xsl:template>
	
	<xsl:template match="mn:form//mn:input[@type = 'button']">
		<xsl:variable name="caption">
			<xsl:choose>
				<xsl:when test="normalize-space(@value) != ''"><xsl:value-of select="@value"/></xsl:when>
				<xsl:otherwise>BUTTON</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<fo:inline>[<xsl:value-of select="$caption"/>]</fo:inline>
	</xsl:template>
	
	<xsl:template match="mn:form//mn:input[@type = 'checkbox']">
		<!-- add helper id for mn2pdf class FOPIFFormsHandler  (_metanorma_form_item_border_) -->
		<fo:inline>
			<xsl:call-template name="set_id_metanorma_form_item">
				<xsl:with-param name="form_item_type">checkbox</xsl:with-param>
				<xsl:with-param name="border_prefix">border_</xsl:with-param>
			</xsl:call-template>
			<xsl:value-of select="$hair_space"/>
		</fo:inline>
		
		<fo:inline padding-right="1mm" border="1pt solid black"><!-- don't remove 'border', this border needs for mn2pdf FOPIFFormsHandler -->
			<xsl:call-template name="set_id_metanorma_form_item">
				<xsl:with-param name="form_item_type">checkbox</xsl:with-param>
			</xsl:call-template>
			<fo:instream-foreign-object fox:alt-text="Box" baseline-shift="-10%">
				<xsl:attribute name="height">3.5mm</xsl:attribute>
				<xsl:attribute name="content-width">100%</xsl:attribute>
				<xsl:attribute name="content-width">scale-down-to-fit</xsl:attribute>
				<xsl:attribute name="scaling">uniform</xsl:attribute>
				<svg xmlns="http://www.w3.org/2000/svg" width="80" height="80">
					<polyline points="0,0 80,0 80,80 0,80 0,0" stroke="black" stroke-width="5" fill="white"/>
				</svg>
			</fo:instream-foreign-object>
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="mn:form//mn:input[@type = 'radio']">
		<fo:inline padding-right="1mm">
			<fo:instream-foreign-object fox:alt-text="Box" baseline-shift="-10%">
				<xsl:attribute name="height">3.5mm</xsl:attribute>
				<xsl:attribute name="content-width">100%</xsl:attribute>
				<xsl:attribute name="content-width">scale-down-to-fit</xsl:attribute>
				<xsl:attribute name="scaling">uniform</xsl:attribute>
				<svg xmlns="http://www.w3.org/2000/svg" width="80" height="80">
					<circle cx="40" cy="40" r="30" stroke="black" stroke-width="5" fill="white"/>
					<circle cx="40" cy="40" r="15" stroke="black" stroke-width="5" fill="white"/>
				</svg>
			</fo:instream-foreign-object>
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="mn:form//mn:select">
		<fo:inline>
			<xsl:call-template name="text_input"/>
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="mn:form//mn:textarea">
		<fo:block-container border="1pt solid black" width="50%">
			<fo:block>&#xA0;</fo:block>
		</fo:block-container>
	</xsl:template>

  <xsl:template name="set_id_metanorma_form_item">
    <xsl:param name="form_item_type">textfield</xsl:param>
    <xsl:param name="border_prefix"/>
    <xsl:if test="@id">
      <xsl:attribute name="id"><xsl:value-of select="concat('_metanorma_form_item_', $border_prefix, $form_item_type, '_', @id, '___name_', @name)"/></xsl:attribute>
    </xsl:if>
  </xsl:template>

	<!-- =================== -->
	<!-- End Form's elements processing -->
	<!-- =================== -->
	
</xsl:stylesheet>