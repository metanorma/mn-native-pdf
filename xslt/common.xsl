<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:iso="http://riboseinc.com/isoxml" xmlns:mathml="http://www.w3.org/1998/Math/MathML" xmlns:xalan="http://xml.apache.org/xalan" version="1.0">

	
	<xsl:variable name="lower">abcdefghijklmnopqrstuvwxyz</xsl:variable> 
	<xsl:variable name="upper">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
	
	<xsl:variable name="linebreak" select="'&#x2028;'"/>

	<xsl:template match="text()">
		<xsl:value-of select="."/>
	</xsl:template>

	<xsl:template match="*[local-name()='br']">
		<xsl:value-of select="$linebreak"/>
	</xsl:template>
	
	<xsl:template match="*[local-name()='td']//text() | *[local-name()='th']//text()" priority="1">
		<xsl:call-template name="add-zero-spaces"/>
	</xsl:template>
	
	<xsl:template match="*[local-name()='table']">
		<xsl:choose>
			<xsl:when test="@unnumbered = 'true'"></xsl:when>
			<xsl:otherwise>
				<fo:block font-weight="bold" text-align="center" margin-bottom="6pt">
					<xsl:text>Table </xsl:text><xsl:number format="A." count="iso:annex"/><xsl:number format="1"/>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
		
		<xsl:variable name="colwidths">
			<xsl:variable name="cols-count">
				<xsl:choose>
					<xsl:when test="*[local-name()='thead']">
						<xsl:value-of select="count(*[local-name()='thead']/*[local-name()='tr']/*[local-name()='th'])"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="count(*[local-name()='tbody']/*[local-name()='tr'][1]/*[local-name()='td'])"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:call-template name="calculate-column-widths">
				<xsl:with-param name="cols-count" select="$cols-count"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="margin-left">
			<xsl:choose>
				<xsl:when test="sum(xalan:nodeset($colwidths)//column) &gt; 75">15</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<fo:block-container margin-left="-{$margin-left}mm" margin-right="-{$margin-left}mm">
		
			<fo:table table-layout="fixed" font-size="10pt" width="100%" margin-left="{$margin-left}mm" margin-right="{$margin-left}mm">
				<xsl:for-each select="xalan:nodeset($colwidths)//column">
					<xsl:choose>
						<xsl:when test=". = 1">
							<fo:table-column column-width="proportional-column-width(2)"/>
						</xsl:when>
						<xsl:otherwise>
							<fo:table-column column-width="proportional-column-width({.})"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
				<xsl:apply-templates />
			</fo:table>
			
		</fo:block-container>
	</xsl:template>
	
	<xsl:template name="calculate-column-widths">
		<xsl:param name="cols-count"/>
		<xsl:param name="curr-col" select="1"/>
		<xsl:param name="width" select="0"/>
		
		<xsl:if test="$curr-col &lt;= $cols-count">
			<xsl:variable name="widths">
				<xsl:for-each select="*[local-name()='thead']//*[local-name()='tr']">
					<width>
						<xsl:variable name="words">
							<xsl:call-template name="tokenize">
								<xsl:with-param name="text" select="translate(*[local-name()='th'][$curr-col],'- —', '   ')"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:call-template name="max_length">
							<xsl:with-param name="words" select="xalan:nodeset($words)"/>
						</xsl:call-template>
					</width>
				</xsl:for-each>
				<xsl:for-each select="*[local-name()='tbody']//*[local-name()='tr']">
					<width>
						<xsl:variable name="words">
							<xsl:call-template name="tokenize">
								<xsl:with-param name="text" select="translate(*[local-name()='td'][$curr-col],'- —', '   ')"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:call-template name="max_length">
							<xsl:with-param name="words" select="xalan:nodeset($words)"/>
						</xsl:call-template>
					</width>
				</xsl:for-each>
			</xsl:variable>
			
			<column>
				<xsl:for-each select="xalan:nodeset($widths)//width">
					<xsl:sort select="." data-type="number" order="descending"/>
					<xsl:if test="position()=1">
							<xsl:value-of select="."/>
					</xsl:if>
				</xsl:for-each>
			</column>
			<xsl:call-template name="calculate-column-widths">
				<xsl:with-param name="cols-count" select="$cols-count"/>
				<xsl:with-param name="curr-col" select="$curr-col +1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<!-- for debug purpose only -->
	<xsl:template match="*[local-name()='table2']"/>
	
	<xsl:template match="*[local-name()='thead']"/>

	<xsl:template match="*[local-name()='thead']" mode="process">
		<!-- <fo:table-header font-weight="bold">
			<xsl:apply-templates />
		</fo:table-header> -->
			<xsl:apply-templates />
	</xsl:template>
	
	
	<xsl:template match="*[local-name()='tbody']">
		<fo:table-body>
			<xsl:apply-templates select="../*[local-name()='thead']" mode="process"/>
			<xsl:apply-templates />
			<xsl:choose>
				<xsl:when test="../*[local-name()='note']">
					<!-- fn will be processed inside 'note' processing -->
					<xsl:apply-templates select="../*[local-name()='note']" mode="process"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="..//*[local-name()='fn']">
						<!-- fn processing -->
						<xsl:variable name="cols-count">
							<xsl:choose>
								<xsl:when test="../*[local-name()='thead']">
									<xsl:value-of select="count(../*[local-name()='thead']/*[local-name()='tr']/*[local-name()='th'])"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="count(./*[local-name()='tr'][1]/*[local-name()='td'])"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:if test="$cols-count &gt; 0">
							<fo:table-row>
								<fo:table-cell border="solid black 1pt" padding-left="1mm" padding-right="1mm" padding-top="1mm" number-columns-spanned="{$cols-count}">
									<fo:block>
										<xsl:for-each select="..//*[local-name()='fn']">
											<xsl:variable name="reference" select="@reference"/>
											<!-- reference=<xsl:value-of select="preceding-sibling::*[local-name()='fn']/@reference"/> -->
											<xsl:if test="not(preceding-sibling::*[local-name()='fn'][@reference = $reference])"> <!-- only unique reference puts in note-->
												<fo:block margin-bottom="12pt">
													<fo:inline font-size="80%" padding-right="5mm" vertical-align="super" id="{@reference}">
														<xsl:value-of select="@reference"/>
													</fo:inline>
													<xsl:apply-templates />
												</fo:block>
											</xsl:if>
										</xsl:for-each>
									</fo:block>
								</fo:table-cell>
							</fo:table-row>
						</xsl:if>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</fo:table-body>
	</xsl:template>
	
<!--	
	<xsl:template match="*[local-name()='thead']/*[local-name()='tr']">
		<fo:table-row font-weight="bold" min-height="4mm" >
			<xsl:apply-templates />
		</fo:table-row>
	</xsl:template> -->
	
	<xsl:template match="*[local-name()='tr']">
		<xsl:variable name="parent-name" select="local-name(..)"/>
		<xsl:variable name="namespace" select="substring-before(name(), ':')"/>
		<fo:table-row min-height="4mm">
				<xsl:if test="$parent-name = 'thead'">
					<xsl:attribute name="font-weight">bold</xsl:attribute>
					<xsl:choose>
						<xsl:when test="$namespace = 'iso'"> <!-- TEST need -->
							<xsl:attribute name="border-top">solid black 1.5pt</xsl:attribute>
							<xsl:attribute name="border-bottom">solid black 1.5pt</xsl:attribute>
						</xsl:when>
					</xsl:choose>
				</xsl:if>
			<xsl:apply-templates />
		</fo:table-row>
	</xsl:template>
	

	<xsl:template match="*[local-name()='th']">
		<fo:table-cell text-align="{@align}" border="solid black 1pt" padding-left="1mm" display-align="center">
			<xsl:if test="@colspan">
				<xsl:attribute name="number-columns-spanned">
					<xsl:value-of select="@colspan"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@rowspan">
				<xsl:attribute name="number-rows-spanned">
					<xsl:value-of select="@rowspan"/>
				</xsl:attribute>
			</xsl:if>
			<fo:block>
				<xsl:apply-templates />
			</fo:block>
		</fo:table-cell>
	</xsl:template>
	
	
	<xsl:template match="*[local-name()='td']">
		<fo:table-cell text-align="{@align}" border="solid black 1pt" padding-left="1mm">
			<xsl:if test="@colspan">
				<xsl:attribute name="number-columns-spanned">
					<xsl:value-of select="@colspan"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@rowspan">
				<xsl:attribute name="number-rows-spanned">
					<xsl:value-of select="@rowspan"/>
				</xsl:attribute>
			</xsl:if>
			<fo:block>
				<xsl:apply-templates />
			</fo:block>
		</fo:table-cell>
	</xsl:template>
	
	
	<xsl:template match="*[local-name()='table']/*[local-name()='note']"/>
	<xsl:template match="*[local-name()='table']/*[local-name()='note']" mode="process">
		<xsl:variable name="cols-count">
			<xsl:choose>
				<xsl:when test="../*[local-name()='thead']">
					<xsl:value-of select="count(../*[local-name()='thead']/*[local-name()='tr']/*[local-name()='th'])"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="count(../*[local-name()='tbody']/*[local-name()='tr'][1]/*[local-name()='td'])"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<!-- <fo:table-footer> -->
			<fo:table-row>
				<fo:table-cell border="solid black 1pt" padding-left="1mm" padding-right="1mm" padding-top="1mm" number-columns-spanned="{$cols-count}">
					<xsl:apply-templates />
						<xsl:for-each select="..//*[local-name()='fn']">
							<fo:block margin-bottom="12pt">
								<fo:inline font-size="80%" padding-right="5mm" vertical-align="super" id="{@reference}">
									<xsl:value-of select="@reference"/>
								</fo:inline>
								<xsl:apply-templates />
							</fo:block>
						</xsl:for-each>
				</fo:table-cell>
			</fo:table-row>
		<!-- </fo:table-footer> -->
	</xsl:template>
	

	<xsl:template match="*[local-name()='fn']">
		<xsl:variable name="namespace" select="substring-before(name(), ':')"/>
		<fo:inline font-size="80%" keep-with-previous.within-line="always" vertical-align="super">
			<xsl:if test="$namespace = 'itu'">
				<xsl:attribute name="color">blue</xsl:attribute>
			</xsl:if>
			<fo:basic-link internal-destination="{@reference}">
				<xsl:value-of select="@reference"/>
			</fo:basic-link>
		</fo:inline>
	</xsl:template>
	

	<xsl:template match="*[local-name()='fn']/*[local-name()='p']">
		<fo:inline>
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>
	
	<!-- split string 'text' by 'separator' -->
	<xsl:template name="tokenize">
		<xsl:param name="text"/>
		<xsl:param name="separator" select="' '"/>
		<xsl:choose>
			<xsl:when test="not(contains($text, $separator))">
				<word>
					<xsl:value-of select="string-length(normalize-space($text))"/>
				</word>
			</xsl:when>
			<xsl:otherwise>
				<word>
					<xsl:value-of select="string-length(normalize-space(substring-before($text, $separator)))"/>
				</word>
				<xsl:call-template name="tokenize">
					<xsl:with-param name="text" select="substring-after($text, $separator)"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- get max value in array -->
	<xsl:template name="max_length">
		<xsl:param name="words"/>
		<xsl:for-each select="$words//word">
				<xsl:sort select="." data-type="number" order="descending"/>
				<xsl:if test="position()=1">
						<xsl:value-of select="."/>
				</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<!-- add zero space after dash character (for table's entries) -->
	<xsl:template name="add-zero-spaces">
		<xsl:param name="text" select="."/>
		<xsl:variable name="zero-space-after-chars">&#x002D;</xsl:variable>
		<xsl:variable name="zero-space">&#x200B;</xsl:variable>
		<xsl:choose>
			<xsl:when test="contains($text, $zero-space-after-chars)">
				<xsl:value-of select="substring-before($text, $zero-space-after-chars)"/>
				<xsl:value-of select="$zero-space-after-chars"/>
				<xsl:value-of select="$zero-space"/>
				<xsl:call-template name="add-zero-spaces">
					<xsl:with-param name="text" select="substring-after($text, $zero-space-after-chars)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>   
	
</xsl:stylesheet>
