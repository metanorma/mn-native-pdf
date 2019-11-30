<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:iso="http://riboseinc.com/isoxml" xmlns:mathml="http://www.w3.org/1998/Math/MathML" xmlns:xalan="http://xml.apache.org/xalan" version="1.0">

	
	<xsl:variable name="lower">abcdefghijklmnopqrstuvwxyz</xsl:variable> 
	<xsl:variable name="upper">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>

	<xsl:variable name="en_chars" select="concat($lower,$upper,',.`1234567890-=~!@#$%^*()_+[]{}\|?/')"/>
	
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
		<xsl:variable name="namespace" select="substring-before(name(/*), '-')"/>
		<xsl:if test="$namespace = 'itu'">
			<fo:block space-before="18pt">&#xA0;</fo:block>				
		</xsl:if>
		<xsl:choose>
			<xsl:when test="@unnumbered = 'true'"></xsl:when>
			<xsl:otherwise>
				<fo:block font-weight="bold" text-align="center" margin-bottom="6pt">
					<xsl:text>Table </xsl:text>
						<xsl:choose>
							<xsl:when test="ancestor::annex">
								<xsl:number format="A-1" level="multiple" count="*[local-name()='annex'] |*[local-name()='table'] "/>
							</xsl:when>
							<xsl:otherwise>
								<!-- <xsl:number format="1"/> -->
								<xsl:number format="A." count="*[local-name()='annex']"/>
								<xsl:number format="1" level="any" count="*[local-name()='sections']//*[local-name()='table']"/>
							</xsl:otherwise>
						</xsl:choose>
						
						
					<xsl:if test="*[local-name()='name']">
						<xsl:text> — </xsl:text>
						<xsl:apply-templates select="*[local-name()='name']"/>
					</xsl:if>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
		
		<xsl:variable name="colwidths">
			<xsl:variable name="cols-count">
				<xsl:choose>
					<xsl:when test="*[local-name()='thead']">
						<!-- <xsl:value-of select="count(*[local-name()='thead']/*[local-name()='tr']/*[local-name()='th'])"/> -->
						<xsl:call-template name="calculate-columns-numbers">
							<xsl:with-param name="table-row" select="*[local-name()='thead']/*[local-name()='tr'][1]"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<!-- <xsl:value-of select="count(*[local-name()='tbody']/*[local-name()='tr'][1]/*[local-name()='td'])"/> -->
						<xsl:call-template name="calculate-columns-numbers">
							<xsl:with-param name="table-row" select="*[local-name()='tbody']/*[local-name()='tr'][1]"/>
						</xsl:call-template>
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
			<fo:table id="{@id}" table-layout="fixed" font-size="10pt" width="100%" margin-left="{$margin-left}mm" margin-right="{$margin-left}mm">
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
			<xsl:if test="$namespace = 'itu'">
				<fo:block space-after="6pt">&#xA0;</fo:block>				
			</xsl:if>
		</fo:block-container>
	</xsl:template>

	<xsl:template name="calculate-columns-numbers">
		<xsl:param name="table-row" />
		<xsl:variable name="columns-count" select="count($table-row/*)"/>
		<xsl:variable name="sum-colspans"  select="sum($table-row/*/@colspan)"/>
		<xsl:variable name="columns-with-colspan" select="count($table-row/*[@colspan])"/>
		<xsl:value-of select="$columns-count + $sum-colspans - $columns-with-colspan"/>
	</xsl:template>

	<xsl:template name="calculate-column-widths">
		<xsl:param name="cols-count"/>
		<xsl:param name="curr-col" select="1"/>
		<xsl:param name="width" select="0"/>
		
		<xsl:if test="$curr-col &lt;= $cols-count">
			<xsl:variable name="widths">
				<xsl:for-each select="*[local-name()='thead']//*[local-name()='tr']">
					<xsl:variable name="words">
						<xsl:call-template name="tokenize">
							<xsl:with-param name="text" select="translate(*[local-name()='th'][$curr-col],'- —', '   ')"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:variable name="max_length">
						<xsl:call-template name="max_length">
							<xsl:with-param name="words" select="xalan:nodeset($words)"/>
						</xsl:call-template>
					</xsl:variable>
					<width>
						<xsl:value-of select="$max_length"/>
					</width>
				</xsl:for-each>
				<xsl:for-each select="*[local-name()='tbody']//*[local-name()='tr']">
					<xsl:variable name="words">
						<xsl:call-template name="tokenize">
							<xsl:with-param name="text" select="translate(*[local-name()='td'][$curr-col],'- —', '   ')"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:variable name="max_length">
						<xsl:call-template name="max_length">
							<xsl:with-param name="words" select="xalan:nodeset($words)"/>
						</xsl:call-template>
					</xsl:variable>
					<width>
						<xsl:value-of select="$max_length"/>
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
	
	<xsl:template match="*[local-name()='tfoot']"/>

	<xsl:template match="*[local-name()='tfoot']" mode="process">
		<xsl:apply-templates />
	</xsl:template>
	
	<xsl:template match="*[local-name()='tbody']">
		<xsl:variable name="cols-count">
			<xsl:choose>
				<xsl:when test="../*[local-name()='thead']">
					<!-- <xsl:value-of select="count(../*[local-name()='thead']/*[local-name()='tr']/*[local-name()='th'])"/> -->
					<xsl:call-template name="calculate-columns-numbers">
						<xsl:with-param name="table-row" select="../*[local-name()='thead']/*[local-name()='tr'][1]"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<!-- <xsl:value-of select="count(./*[local-name()='tr'][1]/*[local-name()='td'])"/> -->
					<xsl:call-template name="calculate-columns-numbers">
						<xsl:with-param name="table-row" select="./*[local-name()='tr'][1]"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
	
		<fo:table-body>
			<xsl:apply-templates select="../*[local-name()='thead']" mode="process"/>
			<xsl:apply-templates />
			<xsl:apply-templates select="../*[local-name()='tfoot']" mode="process"/>
			<!-- if there are note(s) or fn(s) then create footer row -->
			<xsl:if test="../*[local-name()='note'] or ..//*[local-name()='fn']">
				<fo:table-row>
					<fo:table-cell border="solid black 1pt" padding-left="1mm" padding-right="1mm" padding-top="1mm" number-columns-spanned="{$cols-count}">
						
						<!-- fn will be processed inside 'note' processing -->
						<xsl:apply-templates select="../*[local-name()='note']" mode="process"/>
						<!-- fn processing -->
						<xsl:call-template name="fn_display" />
						
						<!-- <xsl:choose>
							<xsl:when test="../*[local-name()='note']">
								
								
								<fo:block>
										<xsl:call-template name="fn_display" />
									</fo:block>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="..//*[local-name()='fn']">
									
									
									<fo:block>
										<xsl:call-template name="fn_display" />
									</fo:block>
									
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose> -->
					</fo:table-cell>
				</fo:table-row>
				
			</xsl:if>
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
		<xsl:variable name="namespace" select="substring-before(name(/*), '-')"/>
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
		
		
			<fo:block font-size="10pt" margin-bottom="12pt">
				<fo:inline padding-right="2mm">NOTE <xsl:number format="1 "/></fo:inline>
				<xsl:apply-templates mode="process"/>
			</fo:block>
		
	</xsl:template>
	
	<xsl:template match="*[local-name()='table']/*[local-name()='note']/*[local-name()='p']" mode="process">
		<xsl:apply-templates/>
	</xsl:template>
	
	
	<xsl:template name="fn_display">
		<xsl:variable name="references">
			<xsl:for-each select="..//*[local-name()='fn']">
				<fn reference="{@reference}" id="{@reference}_{ancestor::*[@id][1]/@id}">
					<xsl:apply-templates />
				</fn>
			</xsl:for-each>
		</xsl:variable>
		<xsl:for-each select="xalan:nodeset($references)//fn">
			<xsl:variable name="reference" select="@reference"/>
			<xsl:if test="not(preceding-sibling::*[@reference = $reference])"> <!-- only unique reference puts in note-->
				<fo:block margin-bottom="12pt">
					<fo:inline font-size="80%" padding-right="5mm" vertical-align="super" id="{@id}">
						<xsl:value-of select="@reference"/>
					</fo:inline>
					<xsl:apply-templates />
				</fo:block>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template name="fn_display_figure">
		<xsl:variable name="references">
			<xsl:for-each select=".//*[local-name()='fn']">
				<fn reference="{@reference}" id="{@reference}_{ancestor::*[@id][1]/@id}">
					<xsl:apply-templates />
				</fn>
			</xsl:for-each>
		</xsl:variable>
		<xsl:if test="xalan:nodeset($references)//fn">
			<fo:block>
				<fo:table width="95%" table-layout="fixed">
					<fo:table-column column-width="10%"/>
					<fo:table-column column-width="90%"/>
					<fo:table-body>
						<xsl:for-each select="xalan:nodeset($references)//fn">
							<xsl:variable name="reference" select="@reference"/>
							<xsl:if test="not(preceding-sibling::*[@reference = $reference])"> <!-- only unique reference puts in note-->
								<fo:table-row>
									<fo:table-cell>
										<fo:block>
											<fo:inline font-size="80%" padding-right="5mm" vertical-align="super" id="{@id}">
												<xsl:value-of select="@reference"/>
											</fo:inline>
										</fo:block>
									</fo:table-cell>
									<fo:table-cell>
										<fo:block text-align="justify" margin-bottom="12pt">
											<xsl:apply-templates />
										</fo:block>
									</fo:table-cell>
								</fo:table-row>
							</xsl:if>
						</xsl:for-each>
					</fo:table-body>
				</fo:table>
			</fo:block>
		</xsl:if>
		
	</xsl:template>
	
	
	<xsl:template match="*[local-name()='fn']">
		<xsl:variable name="namespace" select="substring-before(name(/*), '-')"/>
		<fo:inline font-size="80%" keep-with-previous.within-line="always" vertical-align="super">
			<xsl:if test="$namespace = 'itu'">
				<xsl:attribute name="color">blue</xsl:attribute>
			</xsl:if>
			<fo:basic-link internal-destination="{@reference}_{ancestor::*[@id][1]/@id}"> <!-- @reference   | ancestor::*[local-name()='clause'][1]/@id-->
				<xsl:value-of select="@reference"/>
			</fo:basic-link>
		</fo:inline>
	</xsl:template>
	

	<xsl:template match="*[local-name()='fn']/*[local-name()='p']">
		<fo:inline>
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>

	<xsl:template match="*[local-name()='dl']">
		<xsl:choose>
			<xsl:when test="local-name(..) = 'formula'">
				<fo:block margin-bottom="12pt">
					<xsl:text>where</xsl:text>
				</fo:block>
			</xsl:when>
			<xsl:when test="local-name(..) = 'figure'">
				<fo:block font-weight="bold" text-align="left" margin-bottom="12pt">
					<xsl:text>Key</xsl:text>
				</fo:block>
			</xsl:when>
		</xsl:choose>
		
		<fo:block>
			<fo:table width="95%" table-layout="fixed">
				<fo:table-column column-width="15%"/>
				<fo:table-column column-width="85%"/>
				<fo:table-body>
					<xsl:apply-templates />
					
				</fo:table-body>
			</fo:table>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="*[local-name()='dl']/*[local-name()='note']">
		<fo:table-row>
			<fo:table-cell>
				<fo:block margin-top="6pt">
					NOTE
				</fo:block>
			</fo:table-cell>
			<fo:table-cell>
				<fo:block>
					<xsl:apply-templates />
				</fo:block>
			</fo:table-cell>
		</fo:table-row>
	</xsl:template>
	
	<xsl:template match="*[local-name()='dt']">
		<fo:table-row>
			<fo:table-cell>
				<fo:block margin-top="6pt">
					<xsl:apply-templates />
				</fo:block>
			</fo:table-cell>
			<fo:table-cell>
				<fo:block>
					<xsl:apply-templates select="following-sibling::*[local-name()='dd'][1]" mode="process"/>
				</fo:block>
			</fo:table-cell>
		</fo:table-row>
	</xsl:template>
	
	<xsl:template match="*[local-name()='dd']"/>
	<xsl:template match="*[local-name()='dd']" mode="process">
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="*[local-name()='em']">
		<fo:inline font-style="italic">
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>

	<xsl:template match="*[local-name()='strong']">
		<fo:inline font-weight="bold">
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="*[local-name()='sup']">
		<fo:inline font-size="80%" vertical-align="super">
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="*[local-name()='sub']">
		<fo:inline font-size="80%" vertical-align="sub">
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="*[local-name()='tt']">
		<fo:inline font-family="Courier" font-size="10pt">
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="*[local-name()='del']">
		<fo:inline font-size="10pt" color="red" text-decoration="line-through">
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="text()[ancestor::*[local-name()='smallcap']]">
		<xsl:variable name="text" select="normalize-space(.)"/>
		<fo:inline font-size="75%">
				<xsl:if test="string-length($text) &gt; 0">
					<xsl:call-template name="recursiveSmallCaps">
						<xsl:with-param name="text" select="$text"/>
					</xsl:call-template>
				</xsl:if>
			</fo:inline> 
	</xsl:template>
	
	<xsl:template name="recursiveSmallCaps">
    <xsl:param name="text"/>
    <xsl:variable name="char" select="substring($text,1,1)"/>
    <xsl:variable name="upperCase" select="translate($char, $lower, $upper)"/>
    <xsl:choose>
      <xsl:when test="$char=$upperCase">
        <fo:inline font-size="{100 div 0.75}%">
          <xsl:value-of select="$upperCase"/>
        </fo:inline>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$upperCase"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="string-length($text) &gt; 1">
      <xsl:call-template name="recursiveSmallCaps">
        <xsl:with-param name="text" select="substring($text,2)"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
	
	<!-- split string 'text' by 'separator' -->
	<xsl:template name="tokenize">
		<xsl:param name="text"/>
		<xsl:param name="separator" select="' '"/>
		<xsl:choose>
			<xsl:when test="not(contains($text, $separator))">
				<word>
					<xsl:variable name="str_no_en_chars" select="normalize-space(translate($text, $en_chars, ''))"/>
					<xsl:variable name="len_str_no_en_chars" select="string-length($str_no_en_chars)"/>
					<xsl:variable name="len_str" select="string-length(normalize-space($text))"/>
					
					<!-- <xsl:if test="$len_str_no_en_chars div $len_str &gt; 0.8">
						<xsl:message>
							div=<xsl:value-of select="$len_str_no_en_chars div $len_str"/>
							len_str=<xsl:value-of select="$len_str"/>
							len_str_no_en_chars=<xsl:value-of select="$len_str_no_en_chars"/>
						</xsl:message>
					</xsl:if> -->
					<!-- <len_str_no_en_chars><xsl:value-of select="$len_str_no_en_chars"/></len_str_no_en_chars>
					<len_str><xsl:value-of select="$len_str"/></len_str> -->
					<xsl:choose>
						<xsl:when test="$len_str_no_en_chars div $len_str &gt; 0.8"> <!-- means non-english string -->
							<xsl:value-of select="$len_str - $len_str_no_en_chars"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$len_str"/>
						</xsl:otherwise>
					</xsl:choose>
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
