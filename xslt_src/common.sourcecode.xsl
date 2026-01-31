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
	
	<xsl:attribute-set name="sourcecode-container-style">
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="space-after">12pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:template name="refine_sourcecode-container-style">
		<xsl:if test="not(ancestor::mn:li) or ancestor::mn:example">
			<xsl:attribute name="margin-left">0mm</xsl:attribute>
		</xsl:if>
		
		<xsl:if test="ancestor::mn:example">
			<xsl:attribute name="margin-right">0mm</xsl:attribute>
		</xsl:if>
		
		<xsl:copy-of select="@id"/>
		
		<xsl:if test="parent::mn:note">
			<xsl:attribute name="margin-left">
				<xsl:choose>
					<xsl:when test="not(ancestor::mn:table)"><xsl:value-of select="$note-body-indent"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="$note-body-indent-table"/></xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:if test="$namespace = 'gb'">
				<xsl:attribute name="margin-left">0mm</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:attribute-set name="sourcecode-style">
		<xsl:attribute name="white-space">pre</xsl:attribute>
		<xsl:attribute name="wrap-option">wrap</xsl:attribute>
		<xsl:attribute name="role">Code</xsl:attribute>
		<xsl:if test="$namespace = 'bsi' or $namespace = 'pas'">
			<xsl:attribute name="font-family">Courier New, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>			
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="font-family"><xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>			
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="line-height">113%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csd'">
			<xsl:attribute name="font-family"><xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>			
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>					
		</xsl:if>
		
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="font-family">Courier New, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>			
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="font-family">Courier New, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>			
			<xsl:attribute name="margin-top">5pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">5pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="font-family">Courier New, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>			
			<xsl:attribute name="margin-top">5pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">5pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="font-family">Fira Code, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>			
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="line-height">113%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="font-family">Courier New, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>			
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="font-family">Courier New, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>			
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jcgm'">
			<xsl:attribute name="font-family">Courier New, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>			
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'm3d'">
			<xsl:attribute name="font-family">Courier New, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>			
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>		
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="font-family">Fira Code, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>			
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>			
			<xsl:attribute name="line-height">113%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:attribute name="font-family">Courier New, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>			
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="line-height">113%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-family"><xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>			
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="line-height">113%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp' or $namespace = 'nist-sp'">
			<xsl:attribute name="font-family">Courier New, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>			
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece' or $namespace = 'unece-rec'">
			<xsl:attribute name="font-family">Courier New, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>			
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- sourcecode-style -->

	<xsl:template name="refine_sourcecode-style">
		<xsl:if test="$namespace = 'rsd'"> <!-- background for image -->
			<xsl:if test="starts-with((mn:fmt-name//text())[1], 'Figure ')">
				<xsl:attribute name="background-color">rgb(236,242,246)</xsl:attribute>
				<xsl:attribute name="padding-left">11mm</xsl:attribute>
				<xsl:attribute name="margin-left">0mm</xsl:attribute>
				<xsl:attribute name="padding-right">11mm</xsl:attribute>
				<xsl:attribute name="margin-right">0mm</xsl:attribute>
				<xsl:attribute name="padding-top">7.5mm</xsl:attribute>
				<xsl:attribute name="padding-bottom">7.5mm</xsl:attribute>
				<xsl:if test="following-sibling::*[1][self::mn:sourcecode] and starts-with((mn:fmt-name//text())[1], 'Figure ')">
					<xsl:attribute name="margin-bottom">16pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:if test="parent::mn:example">
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template> <!-- refine_sourcecode-style -->

	<xsl:attribute-set name="sourcecode-number-style">
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="font-style">normal</xsl:attribute>
			<xsl:attribute name="color">black</xsl:attribute>
			<xsl:attribute name="text-transform">uppercase</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:template name="refine_sourcecode-number-style">
	</xsl:template>

	<xsl:attribute-set name="sourcecode-name-style">
		<xsl:attribute name="font-size">11pt</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="text-align">center</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		<xsl:attribute name="keep-with-previous">always</xsl:attribute>
		<xsl:if test="$namespace = 'rsd'">
			<!-- <xsl:attribute name="font-size">13pt</xsl:attribute> -->
			<xsl:attribute name="font-weight">300</xsl:attribute>
			<xsl:attribute name="color">black</xsl:attribute>
			<xsl:attribute name="text-align">left</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- sourcecode-name-style -->
	
	<xsl:template name="refine_sourcecode-name-style">
	</xsl:template>

	<xsl:template name="add-zero-spaces-equal">
		<xsl:param name="text" select="."/>
		<xsl:variable name="zero-space-after-equals">==========</xsl:variable>
		<xsl:variable name="regex_zero-space-after-equals">(==========)</xsl:variable>
		<xsl:variable name="zero-space-after-equal">=</xsl:variable>
		<xsl:variable name="regex_zero-space-after-equal">(=)</xsl:variable>
		<xsl:variable name="zero-space">&#x200B;</xsl:variable>
		<xsl:choose>
			<xsl:when test="contains($text, $zero-space-after-equals)">
				<!-- <xsl:value-of select="substring-before($text, $zero-space-after-equals)"/>
				<xsl:value-of select="$zero-space-after-equals"/>
				<xsl:value-of select="$zero-space"/>
				<xsl:call-template name="add-zero-spaces-equal">
					<xsl:with-param name="text" select="substring-after($text, $zero-space-after-equals)"/>
				</xsl:call-template> -->
				<xsl:value-of select="java:replaceAll(java:java.lang.String.new(.),$regex_zero-space-after-equals,concat('$1',$zero_width_space))"/>
			</xsl:when>
			<xsl:when test="contains($text, $zero-space-after-equal)">
				<!-- <xsl:value-of select="substring-before($text, $zero-space-after-equal)"/>
				<xsl:value-of select="$zero-space-after-equal"/>
				<xsl:value-of select="$zero-space"/>
				<xsl:call-template name="add-zero-spaces-equal">
					<xsl:with-param name="text" select="substring-after($text, $zero-space-after-equal)"/>
				</xsl:call-template> -->
				<xsl:value-of select="java:replaceAll(java:java.lang.String.new(.),$regex_zero-space-after-equal,concat('$1',$zero_width_space))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- add-zero-spaces-equal -->

	<!-- =============== -->
	<!-- sourcecode  -->
	<!-- =============== -->
	
	<xsl:variable name="source-highlighter-css_" select="//mn:metanorma/mn:metanorma-extension/mn:source-highlighter-css"/>
	<xsl:variable name="sourcecode_css_" select="java:org.metanorma.fop.Util.parseCSS($source-highlighter-css_)"/>
	<xsl:variable name="sourcecode_css" select="xalan:nodeset($sourcecode_css_)"/>	
	
	<xsl:template match="*[local-name() = 'property']" mode="css">
		<!-- don't delete leading and trailing spaces -->
		<!-- the list from https://www.data2type.de/en/xml-xslt-xslfo/xsl-fo/xsl-fo-introduction/blocks -->
		<xsl:variable name="allowed_attributes_">
			<xsl:text>
				background-attachment
				background-color
				background-image
				background-position-horizontal
				background-position-vertical
				background-repeat
				border
				border-after-color
				border-after-style
				border-after-width
				border-before-color
				border-before-style
				border-before-width
				border-bottom-color
				border-bottom-style
				border-bottom-width
				border-color
				border-end-color
				border-end-style
				border-end-width
				border-left-color
				border-left-style
				border-left-width
				border-right-color
				border-right-style
				border-right-width
				border-start-color
				border-start-style
				border-start-width
				border-style
				border-top-color
				border-top-style
				border-top-width
				border-width
				break-after
				break-before
				color
				country
				end-indent
				font-family
				font-model
				font-selection-strategy
				font-size
				font-size-adjust
				font-stretch
				font-style
				font-variant
				font-weight
				hyphenate
				hyphenation-character
				hyphenation-keep
				hyphenation-ladder-count
				hyphenation-push-character-count
				hyphenation-remain-character-count
				id
				intrusion-displace
				keep-together
				keep-with-next
				keep-with-previous
				language
				last-line-end-indent
				line-height
				line-height-shift-adjustment
				line-stacking-strategy
				linefeed-treatment
				margin
				margin-bottom
				margin-left
				margin-right
				margin-top
				orphans
				padding
				padding-after
				padding-before
				padding-bottom
				padding-end
				padding-left
				padding-right
				pause-after
				padding-start
				padding-top
				reference-orientation
				relative-position
				richness
				role
				script
				source-document
				space-after
				space-before
				span
				start-indent
				text-align
				text-align-last
				text-altitude
				text-depth
				text-indent
				visibility
				white-space-collapse
				white-space-treatment
				widows
				wrap-option
			</xsl:text>
		</xsl:variable>
		<xsl:variable name="allowed_attributes" select="concat(' ', normalize-space($allowed_attributes_), ' ')"/>
		<xsl:choose>
			<xsl:when test="contains($allowed_attributes, concat(' ', @name, ' '))">
				<xsl:attribute name="{@name}">
					<xsl:value-of select="@value"/>
				</xsl:attribute>
			</xsl:when>
			<xsl:when test="@name = 'border-radius'">
				<xsl:attribute name="fox:border-radius">
					<xsl:value-of select="@value"/>
				</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<!-- skip -->
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="get_sourcecode_attributes">
		<xsl:element name="sourcecode_attributes" use-attribute-sets="sourcecode-style">
			<xsl:variable name="_font-size">
				<xsl:if test="$namespace = 'csa'">10</xsl:if>
				<xsl:if test="$namespace = 'csd'">10</xsl:if>						
				<xsl:if test="$namespace = 'gb'">9</xsl:if>
				<xsl:if test="$namespace = 'iec'">9</xsl:if>
				<xsl:if test="$namespace = 'iho'">9.5</xsl:if>
				<xsl:if test="$namespace = 'iso'">9</xsl:if><!-- inherit -->
				<xsl:if test="$namespace = 'bsi' or $namespace = 'pas'">9</xsl:if>
				<xsl:if test="$namespace = 'jcgm'">9</xsl:if>
				<xsl:if test="$namespace = 'itu'">10</xsl:if>
				<xsl:if test="$namespace = 'm3d'"></xsl:if>		
				<xsl:if test="$namespace = 'mpfd'"></xsl:if>
				<xsl:if test="$namespace = 'nist-cswp'  or $namespace = 'nist-sp'">10</xsl:if>
				<xsl:if test="$namespace = 'ogc'">
					<xsl:choose>
						<xsl:when test="ancestor::mn:table[not(parent::mn:sourcecode[@linenums = 'true'])]">8.5</xsl:when>
						<xsl:otherwise>9.5</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
				<xsl:if test="$namespace = 'ogc-white-paper'">
					<xsl:choose>
						<xsl:when test="ancestor::mn:table[not(parent::mn:sourcecode[@linenums = 'true'])]">8.5</xsl:when>
						<xsl:otherwise>9.5</xsl:otherwise>
					</xsl:choose>
				</xsl:if>						
				<xsl:if test="$namespace = 'rsd'">
					<xsl:choose>
						<!-- <xsl:when test="ancestor::mn:table[not(parent::mn:sourcecode[@linenums = 'true'])]">inherit</xsl:when> -->
						<xsl:when test="ancestor::mn:table">95%</xsl:when>
						<xsl:otherwise>95%</xsl:otherwise><!-- 110% -->
					</xsl:choose>
				</xsl:if>
				<xsl:if test="$namespace = 'unece' or $namespace = 'unece-rec'">10</xsl:if>		
			</xsl:variable>
			
			<xsl:variable name="font-size" select="normalize-space($_font-size)"/>		
			<xsl:if test="$font-size != ''">
				<xsl:attribute name="font-size">
					<xsl:choose>
						<xsl:when test="$font-size = 'inherit'"><xsl:value-of select="$font-size"/></xsl:when>
						<xsl:when test="contains($font-size, '%')"><xsl:value-of select="$font-size"/></xsl:when>
						<xsl:when test="ancestor::mn:note"><xsl:value-of select="$font-size * 0.91"/>pt</xsl:when>
						<xsl:otherwise><xsl:value-of select="$font-size"/>pt</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates select="$sourcecode_css//class[@name = 'sourcecode']" mode="css"/>
		</xsl:element>
	</xsl:template>
	
	<!-- show sourcecode's name 'before' or 'after' source code -->
	<xsl:variable name="sourcecode-name-position">
		<xsl:choose>
			<xsl:when test="$namespace = 'rsd'"><xsl:text>before</xsl:text></xsl:when>
			<xsl:otherwise><xsl:text>after</xsl:text></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:template match="mn:sourcecode" name="sourcecode">
	
		<xsl:variable name="sourcecode_attributes">
			<xsl:call-template name="get_sourcecode_attributes"/>
		</xsl:variable>
	
    <!-- <xsl:copy-of select="$sourcecode_css"/> -->
  
		<xsl:choose>
			<xsl:when test="$isGenerateTableIF = 'true' and (ancestor::*[local-name() = 'td'] or ancestor::*[local-name() = 'th'])">
				<!-- <xsl:for-each select="xalan:nodeset($sourcecode_attributes)/sourcecode_attributes/@*">					
					<xsl:attribute name="{name()}">
						<xsl:value-of select="."/>
					</xsl:attribute>
				</xsl:for-each> -->
				<xsl:copy-of select="xalan:nodeset($sourcecode_attributes)/sourcecode_attributes/@*"/>
				<xsl:apply-templates select="node()[not(self::mn:fmt-name)]" />
			</xsl:when>
			
			<xsl:otherwise>
				<fo:block-container xsl:use-attribute-sets="sourcecode-container-style" role="SKIP">
				
					<xsl:call-template name="refine_sourcecode-container-style"/>

					<fo:block-container margin-left="0mm" margin-right="0mm" role="SKIP">
				
						<!-- <xsl:if test="$namespace = 'rsd'"> -->
						<xsl:if test="$sourcecode-name-position = 'before'">
							<xsl:apply-templates select="mn:fmt-name" /> <!-- show sourcecode's name BEFORE content -->
						</xsl:if>
						
						<xsl:if test="$namespace = 'ogc'">
							<xsl:if test="parent::mn:example">
								<fo:block font-size="1pt" line-height="10%" space-after="4pt">&#xa0;</fo:block>
							</xsl:if>
						</xsl:if>
						
						<fo:block xsl:use-attribute-sets="sourcecode-style">
							
							<!-- <xsl:for-each select="xalan:nodeset($sourcecode_attributes)/sourcecode_attributes/@*">					
								<xsl:attribute name="{name()}">
									<xsl:value-of select="."/>
								</xsl:attribute>
							</xsl:for-each> -->
							<xsl:copy-of select="xalan:nodeset($sourcecode_attributes)/sourcecode_attributes/@*"/>
							
							<xsl:call-template name="refine_sourcecode-style"/>
							
							<!-- remove margin between rows in the table with sourcecode line numbers -->
							<xsl:if test="ancestor::mn:sourcecode[@linenums = 'true'] and ancestor::mn:tr[1]/following-sibling::mn:tr">
								<xsl:attribute name="margin-top">0pt</xsl:attribute>
								<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
							</xsl:if>
							
							<xsl:apply-templates select="node()[not(self::mn:fmt-name or self::mn:dl or self::mn:key)]" />
						</fo:block>
						
						<xsl:apply-templates select="mn:dl | mn:key"/> <!-- Key table -->
						
						<!-- <xsl:choose>
							<xsl:when test="$namespace = 'rsd'"></xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates select="mn:fmt-name" />  --><!-- show sourcecode's name AFTER content -->
							<!-- </xsl:otherwise>
						</xsl:choose> -->
						<xsl:if test="$sourcecode-name-position = 'after'">
							<xsl:apply-templates select="mn:fmt-name" /> <!-- show sourcecode's name AFTER content -->
						</xsl:if>
							
						<xsl:if test="$namespace = 'ogc'">
							<xsl:if test="parent::mn:example">
								<fo:block font-size="1pt" line-height="10%" space-before="6pt">&#xa0;</fo:block>
							</xsl:if>
						</xsl:if>
						
					</fo:block-container>
				</fo:block-container>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	

	<xsl:template match="mn:sourcecode/text() | mn:sourcecode//mn:span/text()" priority="2">
		<xsl:choose>
			<!-- disabled -->
			<xsl:when test="1 = 2 and normalize-space($syntax-highlight) = 'true' and normalize-space(../@lang) != ''"> <!-- condition for turn on of highlighting -->
				<xsl:variable name="syntax" select="java:org.metanorma.fop.Util.syntaxHighlight(., ../@lang)"/>
				<xsl:choose>
					<xsl:when test="normalize-space($syntax) != ''"><!-- if there is highlighted result -->
						<xsl:apply-templates select="xalan:nodeset($syntax)" mode="syntax_highlight"/> <!-- process span tags -->
					</xsl:when>
					<xsl:otherwise> <!-- if case of non-succesfull syntax highlight (for instance, unknown lang), process without highlighting -->
						<xsl:call-template name="add_spaces_to_sourcecode"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="add_spaces_to_sourcecode"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- add sourcecode highlighting -->
	<xsl:template match="mn:sourcecode//mn:span[@class]" priority="2">
		<xsl:variable name="class" select="@class"/>
		
		<!-- Example: <1> -->
		<xsl:variable name="is_callout">
			<xsl:if test="parent::mn:dt">
				<xsl:variable name="dt_id" select="../@id"/>
				<xsl:if test="ancestor::mn:sourcecode//mn:callout[@target = $dt_id]">true</xsl:if>
			</xsl:if>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="$sourcecode_css//class[@name = $class]">
				<fo:inline>
					<xsl:apply-templates select="$sourcecode_css//class[@name = $class]" mode="css"/>
					<xsl:if test="$is_callout = 'true'">&lt;</xsl:if>
					<xsl:apply-templates />
					<xsl:if test="$is_callout = 'true'">&gt;</xsl:if>
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- outer table with line numbers for sourcecode -->
	<xsl:template match="mn:sourcecode[@linenums = 'true']/mn:table" priority="2"> <!-- *[local-name()='table'][@type = 'sourcecode'] |  -->
		<fo:block>
			<fo:table width="100%" table-layout="fixed">
				<xsl:copy-of select="@id"/>
					<fo:table-column column-width="8%"/>
					<fo:table-column column-width="92%"/>
					<fo:table-body>
						<xsl:apply-templates />
					</fo:table-body>
			</fo:table>
		</fo:block>
	</xsl:template>
	<xsl:template match="mn:sourcecode[@linenums = 'true']/mn:table/mn:tbody" priority="2"> <!-- *[local-name()='table'][@type = 'sourcecode']/*[local-name() = 'tbody'] |  -->
		<xsl:apply-templates />
	</xsl:template>
	<xsl:template match="mn:sourcecode[@linenums = 'true']/mn:table//mn:tr" priority="2"> <!-- *[local-name()='table'][@type = 'sourcecode']//*[local-name()='tr'] |  -->
		<fo:table-row>
			<xsl:apply-templates />
		</fo:table-row>
	</xsl:template>
	<!-- first td with line numbers -->
	<xsl:template match="mn:sourcecode[@linenums = 'true']/mn:table//mn:tr/*[local-name() = 'td'][not(preceding-sibling::*)]" priority="2"> <!-- *[local-name()='table'][@type = 'sourcecode'] -->
		<fo:table-cell>
			<fo:block>
				
				<!-- set attibutes for line numbers - same as sourcecode -->
				<xsl:variable name="sourcecode_attributes">
					<xsl:for-each select="following-sibling::*[local-name() = 'td']/mn:sourcecode">
						<xsl:call-template name="get_sourcecode_attributes"/>
					</xsl:for-each>
				</xsl:variable>
				<xsl:for-each select="xalan:nodeset($sourcecode_attributes)/sourcecode_attributes/@*[not(starts-with(local-name(), 'margin-') or starts-with(local-name(), 'space-'))]">					
					<xsl:attribute name="{name()}">
						<xsl:value-of select="."/>
					</xsl:attribute>
				</xsl:for-each>
				
				<xsl:apply-templates />
			</fo:block>
		</fo:table-cell>
	</xsl:template>
	
	<!-- second td with sourcecode -->
	<xsl:template match="mn:sourcecode[@linenums = 'true']/mn:table//mn:tr/*[local-name() = 'td'][preceding-sibling::*]" priority="2"> <!-- *[local-name()='table'][@type = 'sourcecode'] -->
		<fo:table-cell>
			<fo:block role="SKIP">
				<xsl:apply-templates />
			</fo:block>
		</fo:table-cell>
	</xsl:template>
	<!-- END outer table with line numbers for sourcecode -->
	
	<xsl:template name="add_spaces_to_sourcecode">
		<xsl:variable name="text_step1">
			<xsl:call-template name="add-zero-spaces-equal"/>
		</xsl:variable>
		<xsl:variable name="text_step2">
			<xsl:call-template name="add-zero-spaces-java">
				<xsl:with-param name="text" select="$text_step1"/>
			</xsl:call-template>
		</xsl:variable>
		
		<!-- <xsl:value-of select="$text_step2"/> -->
		
		<!-- add zero-width space after space -->
		<xsl:variable name="text_step3" select="java:replaceAll(java:java.lang.String.new($text_step2),' ',' &#x200B;')"/>
		
		<!-- split text by zero-width space -->
		<xsl:variable name="text_step4">
			<xsl:call-template name="split_for_interspers">
				<xsl:with-param name="pText" select="$text_step3"/>
				<xsl:with-param name="sep" select="$zero_width_space"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:for-each select="xalan:nodeset($text_step4)/node()">
			<xsl:choose>
				<xsl:when test="local-name() = 'interspers'"> <!-- word with length more than 30 will be interspersed with zero-width space -->
					<xsl:call-template name="interspers-java">
						<xsl:with-param name="str" select="."/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
		
	</xsl:template> <!-- add_spaces_to_sourcecode -->
	
	
	<xsl:variable name="interspers_tag_open">###interspers123###</xsl:variable>
	<xsl:variable name="interspers_tag_close">###/interspers123###</xsl:variable>
	<!-- split string by separator for interspers -->
	<xsl:template name="split_for_interspers">
		<xsl:param name="pText" select="."/>
		<xsl:param name="sep" select="','"/>
		<!-- word with length more than 30 will be interspersed with zero-width space -->
		<xsl:variable name="regex" select="concat('([^', $zero_width_space, ']{31,})')"/> <!-- sequence of characters (more 31), that doesn't contains zero-width space -->
		<xsl:variable name="text" select="java:replaceAll(java:java.lang.String.new($pText),$regex,concat($interspers_tag_open,'$1',$interspers_tag_close))"/>
		<xsl:call-template name="replace_tag_interspers">
			<xsl:with-param name="text" select="$text"/>
		</xsl:call-template>
	</xsl:template> <!-- end: split string by separator for interspers -->
	
	<xsl:template name="replace_tag_interspers">
		<xsl:param name="text"/>
		<xsl:choose>
			<xsl:when test="contains($text, $interspers_tag_open)">
				<xsl:value-of select="substring-before($text, $interspers_tag_open)"/>
				<xsl:variable name="text_after" select="substring-after($text, $interspers_tag_open)"/>
				<interspers>
					<xsl:value-of select="substring-before($text_after, $interspers_tag_close)"/>
				</interspers>
				<xsl:call-template name="replace_tag_interspers">
					<xsl:with-param name="text" select="substring-after($text_after, $interspers_tag_close)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="$text"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
		
	
	<xsl:template name="interspers-java">
		<xsl:param name="str"/>
		<xsl:param name="char" select="$zero_width_space"/>
		<xsl:value-of select="java:replaceAll(java:java.lang.String.new($str),'([^ -.:=_—])',concat('$1', $char))"/> <!-- insert $char after each char excep space, - . : = _ etc. -->
	</xsl:template>
	
	
	<xsl:template match="*" mode="syntax_highlight">
		<xsl:apply-templates mode="syntax_highlight"/>
	</xsl:template>
	
	<xsl:variable name="syntax_highlight_styles_">
		<style class="hljs-addition" xsl:use-attribute-sets="hljs-addition"></style>
		<style class="hljs-attr" xsl:use-attribute-sets="hljs-attr"></style>
		<style class="hljs-attribute" xsl:use-attribute-sets="hljs-attribute"></style>
		<style class="hljs-built_in" xsl:use-attribute-sets="hljs-built_in"></style>
		<style class="hljs-bullet" xsl:use-attribute-sets="hljs-bullet"></style>
		<style class="hljs-char_and_escape_" xsl:use-attribute-sets="hljs-char_and_escape_"></style>
		<style class="hljs-code" xsl:use-attribute-sets="hljs-code"></style>
		<style class="hljs-comment" xsl:use-attribute-sets="hljs-comment"></style>
		<style class="hljs-deletion" xsl:use-attribute-sets="hljs-deletion"></style>
		<style class="hljs-doctag" xsl:use-attribute-sets="hljs-doctag"></style>
		<style class="hljs-emphasis" xsl:use-attribute-sets="hljs-emphasis"></style>
		<style class="hljs-formula" xsl:use-attribute-sets="hljs-formula"></style>
		<style class="hljs-keyword" xsl:use-attribute-sets="hljs-keyword"></style>
		<style class="hljs-link" xsl:use-attribute-sets="hljs-link"></style>
		<style class="hljs-literal" xsl:use-attribute-sets="hljs-literal"></style>
		<style class="hljs-meta" xsl:use-attribute-sets="hljs-meta"></style>
		<style class="hljs-meta_hljs-string" xsl:use-attribute-sets="hljs-meta_hljs-string"></style>
		<style class="hljs-meta_hljs-keyword" xsl:use-attribute-sets="hljs-meta_hljs-keyword"></style>
		<style class="hljs-name" xsl:use-attribute-sets="hljs-name"></style>
		<style class="hljs-number" xsl:use-attribute-sets="hljs-number"></style>
		<style class="hljs-operator" xsl:use-attribute-sets="hljs-operator"></style>
		<style class="hljs-params" xsl:use-attribute-sets="hljs-params"></style>
		<style class="hljs-property" xsl:use-attribute-sets="hljs-property"></style>
		<style class="hljs-punctuation" xsl:use-attribute-sets="hljs-punctuation"></style>
		<style class="hljs-quote" xsl:use-attribute-sets="hljs-quote"></style>
		<style class="hljs-regexp" xsl:use-attribute-sets="hljs-regexp"></style>
		<style class="hljs-section" xsl:use-attribute-sets="hljs-section"></style>
		<style class="hljs-selector-attr" xsl:use-attribute-sets="hljs-selector-attr"></style>
		<style class="hljs-selector-class" xsl:use-attribute-sets="hljs-selector-class"></style>
		<style class="hljs-selector-id" xsl:use-attribute-sets="hljs-selector-id"></style>
		<style class="hljs-selector-pseudo" xsl:use-attribute-sets="hljs-selector-pseudo"></style>
		<style class="hljs-selector-tag" xsl:use-attribute-sets="hljs-selector-tag"></style>
		<style class="hljs-string" xsl:use-attribute-sets="hljs-string"></style>
		<style class="hljs-strong" xsl:use-attribute-sets="hljs-strong"></style>
		<style class="hljs-subst" xsl:use-attribute-sets="hljs-subst"></style>
		<style class="hljs-symbol" xsl:use-attribute-sets="hljs-symbol"></style>		
		<style class="hljs-tag" xsl:use-attribute-sets="hljs-tag"></style>
		<!-- <style class="hljs-tag_hljs-attr" xsl:use-attribute-sets="hljs-tag_hljs-attr"></style> -->
		<!-- <style class="hljs-tag_hljs-name" xsl:use-attribute-sets="hljs-tag_hljs-name"></style> -->
		<style class="hljs-template-tag" xsl:use-attribute-sets="hljs-template-tag"></style>
		<style class="hljs-template-variable" xsl:use-attribute-sets="hljs-template-variable"></style>
		<style class="hljs-title" xsl:use-attribute-sets="hljs-title"></style>
		<style class="hljs-title_and_class_" xsl:use-attribute-sets="hljs-title_and_class_"></style>
		<style class="hljs-title_and_class__and_inherited__" xsl:use-attribute-sets="hljs-title_and_class__and_inherited__"></style>
		<style class="hljs-title_and_function_" xsl:use-attribute-sets="hljs-title_and_function_"></style>
		<style class="hljs-type" xsl:use-attribute-sets="hljs-type"></style>
		<style class="hljs-variable" xsl:use-attribute-sets="hljs-variable"></style>
		<style class="hljs-variable_and_language_" xsl:use-attribute-sets="hljs-variable_and_language_"></style>
	</xsl:variable>
	<xsl:variable name="syntax_highlight_styles" select="xalan:nodeset($syntax_highlight_styles_)"/>
	
	<xsl:template match="span" mode="syntax_highlight" priority="2">
		<!-- <fo:inline color="green" font-style="italic"><xsl:apply-templates mode="syntax_highlight"/></fo:inline> -->
		<fo:inline>
			<xsl:variable name="classes_">
				<xsl:call-template name="split">
					<xsl:with-param name="pText" select="@class"/>
					<xsl:with-param name="sep" select="' '"/>
				</xsl:call-template>
				<!-- a few classes together (_and_ suffix) -->
				<xsl:if test="contains(@class, 'hljs-char') and contains(@class, 'escape_')">
					<item>hljs-char_and_escape_</item>
				</xsl:if>
				<xsl:if test="contains(@class, 'hljs-title') and contains(@class, 'class_')">
					<item>hljs-title_and_class_</item>
				</xsl:if>
				<xsl:if test="contains(@class, 'hljs-title') and contains(@class, 'class_') and contains(@class, 'inherited__')">
					<item>hljs-title_and_class__and_inherited__</item>
				</xsl:if>
				<xsl:if test="contains(@class, 'hljs-title') and contains(@class, 'function_')">
					<item>hljs-title_and_function_</item>
				</xsl:if>
				<xsl:if test="contains(@class, 'hljs-variable') and contains(@class, 'language_')">
					<item>hljs-variable_and_language_</item>
				</xsl:if>
				<!-- with parent classes (_ suffix) -->
				<xsl:if test="contains(@class, 'hljs-keyword') and contains(ancestor::*/@class, 'hljs-meta')">
					<item>hljs-meta_hljs-keyword</item>
				</xsl:if>
				<xsl:if test="contains(@class, 'hljs-string') and contains(ancestor::*/@class, 'hljs-meta')">
					<item>hljs-meta_hljs-string</item>
				</xsl:if>
			</xsl:variable>
			<xsl:variable name="classes" select="xalan:nodeset($classes_)"/>
			
			<xsl:for-each select="$classes/*[local-name() = 'item']">
				<xsl:variable name="class_name" select="."/>
				<xsl:for-each select="$syntax_highlight_styles/style[@class = $class_name]/@*[not(local-name() = 'class')]">
					<xsl:attribute name="{local-name()}"><xsl:value-of select="."/></xsl:attribute>
				</xsl:for-each>
			</xsl:for-each>
			
			<!-- <xsl:variable name="class_name">
				<xsl:choose>
					<xsl:when test="@class = 'hljs-attr' and ancestor::*/@class = 'hljs-tag'">hljs-tag_hljs-attr</xsl:when>
					<xsl:when test="@class = 'hljs-name' and ancestor::*/@class = 'hljs-tag'">hljs-tag_hljs-name</xsl:when>
					<xsl:when test="@class = 'hljs-string' and ancestor::*/@class = 'hljs-meta'">hljs-meta_hljs-string</xsl:when>
					<xsl:otherwise><xsl:value-of select="@class"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:for-each select="$syntax_highlight_styles/style[@class = $class_name]/@*[not(local-name() = 'class')]">
				<xsl:attribute name="{local-name()}"><xsl:value-of select="."/></xsl:attribute>
			</xsl:for-each> -->
			
		<xsl:apply-templates mode="syntax_highlight"/></fo:inline>
	</xsl:template>
	
	<xsl:template match="text()" mode="syntax_highlight" priority="2">
		<xsl:call-template name="add_spaces_to_sourcecode"/>
	</xsl:template>
	
	<!-- end mode="syntax_highlight" -->
	
	<xsl:template match="mn:sourcecode/mn:fmt-name">
		<xsl:if test="normalize-space() != ''">		
			<fo:block xsl:use-attribute-sets="sourcecode-name-style">
				<xsl:call-template name="refine_sourcecode-name-style"/>
				<xsl:apply-templates/>
			</fo:block>
		</xsl:if>
	</xsl:template>	
	<!-- =============== -->
	<!-- END sourcecode  -->
	<!-- =============== -->

	<xsl:template match="mn:callout">
		<xsl:choose>
			<xsl:when test="normalize-space(@target) = ''">&lt;<xsl:apply-templates />&gt;</xsl:when>
			<xsl:otherwise><fo:basic-link internal-destination="{@target}" fox:alt-text="{normalize-space()}">&lt;<xsl:apply-templates />&gt;</fo:basic-link></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="mn:callout-annotation">
		<xsl:variable name="annotation-id" select="@id"/>
		<xsl:variable name="callout" select="//*[@target = $annotation-id]/text()"/>		
		<fo:block id="{$annotation-id}" white-space="nowrap">			
			<xsl:if test="$namespace = 'ogc'">
				<xsl:if test="not(preceding-sibling::mn:callout-annotation)">
					<xsl:attribute name="space-before">6pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<fo:inline>				
				<xsl:apply-templates>
					<xsl:with-param name="callout" select="concat('&lt;', $callout, '&gt; ')"/>
				</xsl:apply-templates>
			</fo:inline>
		</fo:block>		
	</xsl:template>	

	<xsl:template match="mn:callout-annotation/mn:p">
		<xsl:param name="callout"/>
		<fo:inline id="{@id}">
			<xsl:call-template name="setNamedDestination"/>
			<!-- for first p in annotation, put <x> -->
			<xsl:if test="not(preceding-sibling::mn:p)"><xsl:value-of select="$callout"/></xsl:if>
			<xsl:apply-templates />
		</fo:inline>		
	</xsl:template>

</xsl:stylesheet>