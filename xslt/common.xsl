<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:iso="http://riboseinc.com/isoxml" xmlns:itu="https://open.ribose.com/standards/itu" xmlns:nist="http://www.nist.gov/metanorma" xmlns:mathml="http://www.w3.org/1998/Math/MathML" xmlns:xalan="http://xml.apache.org/xalan"  xmlns:fox="http://xmlgraphics.apache.org/fop/extensions" version="1.0">
	
	<xsl:variable name="lower">abcdefghijklmnopqrstuvwxyz</xsl:variable> 
	<xsl:variable name="upper">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>

	<xsl:variable name="en_chars" select="concat($lower,$upper,',.`1234567890-=~!@#$%^*()_+[]{}\|?/')"/>
	
	<xsl:variable name="linebreak" select="'&#x2028;'"/>
	
	<xsl:variable name="namespace" select="substring-before(name(/*), '-')"/>
	
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
	
		<xsl:variable name="simple-table">
			<!-- <xsl:copy> -->
				<xsl:call-template  name="getSimpleTable"/>
			<!-- </xsl:copy> -->
		</xsl:variable>
	
		<!-- DEBUG -->
		<!-- SourceTable=<xsl:copy-of select="current()"/>EndSourceTable -->
		<!-- Simpletable=<xsl:copy-of select="$simple-table"/>EndSimpltable -->
	
		<!-- <xsl:variable name="namespace" select="substring-before(name(/*), '-')"/> -->
		<xsl:if test="$namespace = 'itu'">
			<fo:block space-before="18pt">&#xA0;</fo:block>				
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<fo:block space-before="6pt">&#xA0;</fo:block>				
		</xsl:if>
		<xsl:choose>
			<xsl:when test="@unnumbered = 'true'"></xsl:when>
			<xsl:otherwise>
				<fo:block font-weight="bold" text-align="center" margin-bottom="6pt">
					<xsl:if test="$namespace = 'nist'">
						<xsl:attribute name="font-family">Arial</xsl:attribute>
						<xsl:attribute name="font-size">9pt</xsl:attribute>
					</xsl:if>
					<xsl:if test="$namespace = 'unece'">
						<xsl:attribute name="font-weight">normal</xsl:attribute>
						<xsl:attribute name="font-size">11pt</xsl:attribute>
					</xsl:if>
					<xsl:text>Table </xsl:text>
					<xsl:choose>
						<xsl:when test="ancestor::*[local-name()='executivesummary']"> <!-- NIST -->
							<xsl:text>ES-</xsl:text><xsl:number format="1" count="*[local-name()='executivesummary']//*[local-name()='table'][not(@unnumbered) or @unnumbered != 'true']"/>
						</xsl:when>
						<xsl:when test="ancestor::*[local-name()='annex']">
							<xsl:choose>
								<xsl:when test="$namespace = 'iso'">
									<xsl:number format="A." count="*[local-name()='annex']"/><xsl:number format="1"/>
								</xsl:when>
								<xsl:when test="$namespace = 'itu'">
									<xsl:choose>
										<xsl:when test="ancestor::itu:annex[@obligation = 'informative']">
											<xsl:variable name="annex-id" select="ancestor::itu:annex/@id"/>
											<!-- Table in Appendix -->
											<xsl:number format="I-" count="itu:annex[@obligation = 'informative']"/>
											<xsl:number format="1" level="any" count="itu:table[(not(@unnumbered) or @unnumbered != 'true') and ancestor::itu:annex[@id = $annex-id]]"/>
										</xsl:when>
										<!-- Table in Annex -->
										<xsl:when test="ancestor::itu:annex[not(@obligation) or @obligation != 'informative']">
											<xsl:variable name="annex-id" select="ancestor::itu:annex/@id"/>
											<xsl:number format="A-" count="itu:annex[not(@obligation) or @obligation != 'informative']"/>
											<xsl:number format="1" level="any" count="itu:table[(not(@unnumbered) or @unnumbered != 'true') and ancestor::itu:annex[@id = $annex-id]]"/>
										</xsl:when>
									</xsl:choose>
								</xsl:when>
								<xsl:when test="$namespace = 'nist'">
									<xsl:variable name="annex-id" select="ancestor::*[local-name()='annex']/@id"/>
									<xsl:number format="A-" count="*[local-name()='annex']"/>
									<xsl:number format="1" level="any" count="*[local-name()='table'][not(@unnumbered) or @unnumbered != 'true'][ancestor::*[local-name()='annex'][@id = $annex-id]]"/>
								</xsl:when>
								<xsl:when test="$namespace = 'unece'">
									<xsl:variable name="annex-id" select="ancestor::*[local-name()='annex']/@id"/>
									<xsl:number format="I." count="*[local-name()='annex']"/>
									<xsl:number format="1" level="any" count="*[local-name()='table'][not(@unnumbered) or @unnumbered != 'true'][ancestor::*[local-name()='annex'][@id = $annex-id]]"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:number format="A-1" level="multiple" count="*[local-name()='annex'] | *[local-name()='table'][not(@unnumbered) or @unnumbered != 'true'] "/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<!-- <xsl:number format="1"/> -->
							<xsl:number format="A." count="*[local-name()='annex']"/>
							<!-- <xsl:number format="1" level="any" count="*[local-name()='sections']//*[local-name()='table'][not(@unnumbered) or @unnumbered != 'true']"/> -->
							<xsl:number format="1" level="any" count="//*[local-name()='table']
																																								[not(ancestor::*[local-name()='annex']) and not(ancestor::*[local-name()='executivesummary'])]
																																								[not(@unnumbered) or @unnumbered != 'true']"/>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:if test="*[local-name()='name']">
						<xsl:text> — </xsl:text>
						<xsl:apply-templates select="*[local-name()='name']" mode="process"/>
					</xsl:if>
				</fo:block>
				<xsl:call-template name="fn_name_display"/>
			</xsl:otherwise>
		</xsl:choose>
		
		<xsl:variable name="cols-count" select="count(xalan:nodeset($simple-table)//tr[1]/td)"/>
		
		<!-- <xsl:variable name="cols-count">
			<xsl:choose>
				<xsl:when test="*[local-name()='thead']">
					<xsl:call-template name="calculate-columns-numbers">
						<xsl:with-param name="table-row" select="*[local-name()='thead']/*[local-name()='tr'][1]"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="calculate-columns-numbers">
						<xsl:with-param name="table-row" select="*[local-name()='tbody']/*[local-name()='tr'][1]"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable> -->
		<!-- cols-count=<xsl:copy-of select="$cols-count"/> -->
		<!-- cols-count2=<xsl:copy-of select="$cols-count2"/> -->
		
		
		
		<xsl:variable name="colwidths">
			<xsl:call-template name="calculate-column-widths">
				<xsl:with-param name="cols-count" select="$cols-count"/>
				<xsl:with-param name="table" select="$simple-table"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="colwidths2">
			<xsl:call-template name="calculate-column-widths">
				<xsl:with-param name="cols-count" select="$cols-count"/>
			</xsl:call-template>
		</xsl:variable>
		
		<!-- cols-count=<xsl:copy-of select="$cols-count"/>
		colwidthsNew=<xsl:copy-of select="$colwidths"/>
		colwidthsOld=<xsl:copy-of select="$colwidths2"/>z -->
		
		<xsl:variable name="margin-left">
			<xsl:choose>
				<xsl:when test="sum(xalan:nodeset($colwidths)//column) &gt; 75">15</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<fo:block-container margin-left="-{$margin-left}mm" margin-right="-{$margin-left}mm">			
			<xsl:if test="$namespace = 'itu' or $namespace = 'nist'">
				<xsl:attribute name="space-after">6pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="$namespace='unece'">
				<xsl:attribute name="space-after">12pt</xsl:attribute>
			</xsl:if>
			<fo:table id="{@id}" table-layout="fixed" width="100%" margin-left="{$margin-left}mm" margin-right="{$margin-left}mm">
				<xsl:if test="$namespace = 'iso'">
					<xsl:attribute name="border">1.5pt solid black</xsl:attribute>
				</xsl:if>
				<xsl:choose>
					<xsl:when test="$namespace = 'nist' and (ancestor::*[local-name()='annex'] or ancestor::*[local-name()='preface'])">
						<xsl:attribute name="font-family">Times New Roman</xsl:attribute>
						<xsl:attribute name="font-size">10pt</xsl:attribute>
					</xsl:when>
					<xsl:when test="$namespace = 'nist'">
						<xsl:attribute name="font-family">Times New Roman</xsl:attribute>
						<xsl:attribute name="font-size">12pt</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="font-size">10pt</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
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
			<!-- <xsl:if test="$namespace = 'itu' or $namespace = 'nist'">
				<fo:block space-after="6pt">&#xA0;</fo:block>				
			</xsl:if> -->
		</fo:block-container>
	</xsl:template>

	<xsl:template match="*[local-name()='table']/*[local-name()='name']"/>
	<xsl:template match="*[local-name()='table']/*[local-name()='name']" mode="process">
		<xsl:apply-templates />
	</xsl:template>
	
	
	
	<xsl:template name="calculate-columns-numbers">
		<xsl:param name="table-row" />
		<xsl:variable name="columns-count" select="count($table-row/*)"/>
		<xsl:variable name="sum-colspans"  select="sum($table-row/*/@colspan)"/>
		<xsl:variable name="columns-with-colspan" select="count($table-row/*[@colspan])"/>
		<xsl:value-of select="$columns-count + $sum-colspans - $columns-with-colspan"/>
	</xsl:template>

	<xsl:template name="calculate-column-widths">
		<xsl:param name="table"/>
		<xsl:param name="cols-count"/>
		<xsl:param name="curr-col" select="1"/>
		<xsl:param name="width" select="0"/>
		
		<xsl:if test="$curr-col &lt;= $cols-count">
			<xsl:variable name="widths">
				<xsl:choose>
					<xsl:when test="not($table)">
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
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each select="xalan:nodeset($table)//tr">
							<xsl:variable name="words">
								<xsl:call-template name="tokenize">
									<xsl:with-param name="text" select="translate(td[$curr-col],'- —', '   ')"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:variable name="max_length">
								<xsl:call-template name="max_length">
									<xsl:with-param name="words" select="xalan:nodeset($words)"/>
								</xsl:call-template>
							</xsl:variable>
							<width>
								<xsl:variable name="divider">
									<xsl:choose>
										<xsl:when test="td[$curr-col]/@divide">
											<xsl:value-of select="td[$curr-col]/@divide"/>
										</xsl:when>
										<xsl:otherwise>1</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:value-of select="$max_length div $divider"/>
							</width>
							
						</xsl:for-each>
					
					</xsl:otherwise>
				</xsl:choose>
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
				<xsl:with-param name="table" select="$table"/>
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
		<xsl:apply-templates/>
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
			<xsl:if test="../*[local-name()='note'] or ..//*[local-name()='fn'][local-name(..) != 'name']">
				<fo:table-row>
					<fo:table-cell border="solid black 1pt" padding-left="1mm" padding-right="1mm" padding-top="1mm" number-columns-spanned="{$cols-count}">
						<xsl:if test="$namespace = 'iso'">
							<xsl:attribute name="border-top">solid black 0pt</xsl:attribute>
						</xsl:if>
						<!-- fn will be processed inside 'note' processing -->
						<xsl:apply-templates select="../*[local-name()='note']" mode="process"/>
						<!-- fn processing -->
						<xsl:call-template name="fn_display" />
						
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
		<!-- <xsl:variable name="namespace" select="substring-before(name(/*), '-')"/> -->
		<fo:table-row min-height="4mm">
				<xsl:if test="$parent-name = 'thead'">
					<xsl:attribute name="font-weight">bold</xsl:attribute>
					<xsl:if test="$namespace = 'nist'">
						<xsl:attribute name="font-family">Arial</xsl:attribute>
						<xsl:attribute name="font-size">10pt</xsl:attribute>
					</xsl:if>
					<xsl:choose>
						<xsl:when test="$namespace = 'iso' and position() = 1">
							<xsl:attribute name="border-top">solid black 1.5pt</xsl:attribute>
							<xsl:attribute name="border-bottom">solid black 1pt</xsl:attribute>
						</xsl:when>
						<xsl:when test="$namespace = 'iso' and position() = last()">
							<xsl:attribute name="border-top">solid black 1pt</xsl:attribute>
							<xsl:attribute name="border-bottom">solid black 1.5pt</xsl:attribute>
						</xsl:when>
						<xsl:when test="$namespace = 'iso'">
							<xsl:attribute name="border-top">solid black 1pt</xsl:attribute>
							<xsl:attribute name="border-bottom">solid black 1pt</xsl:attribute>
						</xsl:when>
					</xsl:choose>
				</xsl:if>
				<xsl:if test="$parent-name = 'tfoot'">
					<xsl:if test="$namespace = 'iso'">
						<xsl:attribute name="font-size">9pt</xsl:attribute>
						<xsl:attribute name="border-left">solid black 1pt</xsl:attribute>
						<xsl:attribute name="border-right">solid black 1pt</xsl:attribute>
					</xsl:if>
				</xsl:if>
			<xsl:apply-templates />
		</fo:table-row>
	</xsl:template>
	

	<xsl:template match="*[local-name()='th']">
		<fo:table-cell text-align="{@align}" font-weight="bold" border="solid black 1pt" padding-left="1mm" display-align="center">
			<xsl:if test="$namespace = 'iso'">
				<xsl:attribute name="padding-top">1mm</xsl:attribute>
			</xsl:if>
			<xsl:if test="$namespace = 'nist'">
				<xsl:attribute name="text-align">center</xsl:attribute>
				<xsl:attribute name="background-color">black</xsl:attribute>
				<xsl:attribute name="color">white</xsl:attribute>
			</xsl:if>
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
		<fo:table-cell text-align="{@align}" display-align="center" border="solid black 1pt" padding-left="1mm">
			<xsl:if test="$namespace = 'iso'"> <!--  and ancestor::*[local-name() = 'thead'] -->
				<xsl:attribute name="padding-top">0.5mm</xsl:attribute>
			</xsl:if>
			<xsl:if test="$namespace = 'iso' and ancestor::*[local-name() = 'tfoot']">
				<xsl:attribute name="border">solid black 0</xsl:attribute>
			</xsl:if>
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
			<!-- <xsl:choose>
				<xsl:when test="count(*) = 1 and *[local-name() = 'p']">
					<xsl:apply-templates />
				</xsl:when>
				<xsl:otherwise>
					<fo:block>
						<xsl:apply-templates />
					</fo:block>
				</xsl:otherwise>
			</xsl:choose> -->
			
			
		</fo:table-cell>
	</xsl:template>
	
	
	<xsl:template match="*[local-name()='table']/*[local-name()='note']"/>
	<xsl:template match="*[local-name()='table']/*[local-name()='note']" mode="process">
		
		
			<fo:block font-size="10pt" margin-bottom="12pt">
				<xsl:if test="$namespace = 'iso'">
					<xsl:attribute name="font-size">9pt</xsl:attribute>
					<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
				</xsl:if>
				<fo:inline padding-right="2mm">NOTE <xsl:number format="1 "/></fo:inline>
				<xsl:apply-templates mode="process"/>
			</fo:block>
		
	</xsl:template>
	
	<xsl:template match="*[local-name()='table']/*[local-name()='note']/*[local-name()='p']" mode="process">
		<xsl:apply-templates/>
	</xsl:template>
	
	
	<xsl:template name="fn_display">
		<xsl:variable name="references">
			<xsl:for-each select="..//*[local-name()='fn'][local-name(..) != 'name']">
				<fn reference="{@reference}" id="{@reference}_{ancestor::*[@id][1]/@id}">
					<xsl:apply-templates />
				</fn>
			</xsl:for-each>
		</xsl:variable>
		<xsl:for-each select="xalan:nodeset($references)//fn">
			<xsl:variable name="reference" select="@reference"/>
			<xsl:if test="not(preceding-sibling::*[@reference = $reference])"> <!-- only unique reference puts in note-->
				<fo:block margin-bottom="12pt">
					<xsl:if test="$namespace = 'iso'">
						<xsl:attribute name="font-size">9pt</xsl:attribute>
						<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
					</xsl:if>
					<fo:inline font-size="80%" padding-right="5mm" id="{@id}">
						<xsl:if test="$namespace != 'iso'">
							<xsl:attribute name="vertical-align">super</xsl:attribute>
						</xsl:if>
						<xsl:if test="$namespace = 'iso'">
							<xsl:attribute name="alignment-baseline">hanging</xsl:attribute>
						</xsl:if>
						<xsl:value-of select="@reference"/>
					</fo:inline>
					<xsl:apply-templates />
				</fo:block>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template name="fn_name_display">
		<!-- <xsl:variable name="references">
			<xsl:for-each select="*[local-name()='name']//*[local-name()='fn']">
				<fn reference="{@reference}" id="{@reference}_{ancestor::*[@id][1]/@id}">
					<xsl:apply-templates />
				</fn>
			</xsl:for-each>
		</xsl:variable>
		$references=<xsl:copy-of select="$references"/> -->
		<xsl:for-each select="*[local-name()='name']//*[local-name()='fn']">
			<xsl:variable name="reference" select="@reference"/>
			<fo:block id="{@reference}_{ancestor::*[@id][1]/@id}"><xsl:value-of select="@reference"/></fo:block>
			<fo:block margin-bottom="12pt">
				<xsl:apply-templates />
			</fo:block>
		</xsl:for-each>
	</xsl:template>
	
	
	<xsl:template name="fn_display_figure">
		<xsl:variable name="key_iso">
			<xsl:if test="$namespace = 'iso'">true</xsl:if> <!-- and (not(@class) or @class !='pseudocode') -->
		</xsl:variable>
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
					<xsl:if test="$key_iso = 'true'">
						<xsl:attribute name="font-size">10pt</xsl:attribute>
					</xsl:if>
					<fo:table-column column-width="15%"/>
					<fo:table-column column-width="85%"/>
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
											<xsl:if test="$key_iso = 'true'">
												<xsl:attribute name="margin-bottom">0</xsl:attribute>
											</xsl:if>
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
	
	<!-- *[local-name()='table']// -->
	<xsl:template match="*[local-name()='fn']">
		<!-- <xsl:variable name="namespace" select="substring-before(name(/*), '-')"/> -->
		<fo:inline font-size="80%" keep-with-previous.within-line="always">
			<xsl:if test="$namespace = 'iso' and ancestor::*[local-name()='td']">
				<xsl:attribute name="font-weight">normal</xsl:attribute>
				<!-- <xsl:attribute name="alignment-baseline">hanging</xsl:attribute> -->
				<xsl:attribute name="baseline-shift">15%</xsl:attribute>
			</xsl:if>
			<xsl:if test="$namespace = 'itu' or $namespace = 'nist'">
				<xsl:attribute name="vertical-align">super</xsl:attribute>
				<xsl:attribute name="color">blue</xsl:attribute>
			</xsl:if>
			<xsl:if test="$namespace = 'nist'">
				<xsl:attribute name="text-decoration">underline</xsl:attribute>
			</xsl:if>
			<fo:basic-link internal-destination="{@reference}_{ancestor::*[@id][1]/@id}" fox:alt-text="{@reference}"> <!-- @reference   | ancestor::*[local-name()='clause'][1]/@id-->
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
		<xsl:variable name="parent" select="local-name(..)"/>
		
		<xsl:variable name="key_iso">
			<xsl:if test="$namespace = 'iso' and ($parent = 'figure' or $parent = 'formula')">true</xsl:if> <!-- and  (not(../@class) or ../@class !='pseudocode') -->
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="$parent = 'formula' and count(*[local-name()='dt']) = 1"> <!-- only one component -->
				<fo:block margin-bottom="12pt">
					<xsl:if test="$namespace = 'iso'">
						<xsl:attribute name="margin-bottom">0</xsl:attribute>
					</xsl:if>
					<xsl:text>where </xsl:text>
					<xsl:apply-templates select="*[local-name()='dt']/*"/>
					<xsl:text></xsl:text>
					<xsl:apply-templates select="*[local-name()='dd']/*" mode="inline"/>
				</fo:block>
			</xsl:when>
			<xsl:when test="$parent = 'formula'"> <!-- a few components -->
				<fo:block margin-bottom="12pt">
					<xsl:if test="$namespace = 'iso'">
						<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
					</xsl:if>
					<xsl:text>where</xsl:text>
				</fo:block>
			</xsl:when>
			<xsl:when test="$parent = 'figure' and  (not(../@class) or ../@class !='pseudocode')">
				<fo:block font-weight="bold" text-align="left" margin-bottom="12pt">
					<xsl:if test="$namespace = 'iso'">
						<xsl:attribute name="font-size">10pt</xsl:attribute>
						<xsl:attribute name="margin-bottom">0</xsl:attribute>
					</xsl:if>
					<xsl:text>Key</xsl:text>
				</fo:block>
			</xsl:when>
		</xsl:choose>
		
		<!-- a few components -->
		<xsl:if test="not($parent = 'formula' and count(*[local-name()='dt']) = 1)">
			<fo:block>
				<xsl:variable name="abbreviation" select="/iso:iso-standard/iso:bibdata/iso:contributor/iso:organization/iso:abbreviation"/>
				<xsl:if test="$namespace ='iso' and $parent = 'formula' and not($abbreviation = 'IEC')">
					<xsl:attribute name="margin-left">4mm</xsl:attribute>
				</xsl:if>
				<xsl:if test="$namespace = 'itu' and local-name(..) = 'li'">
					<xsl:attribute name="margin-left">-4mm</xsl:attribute>
				</xsl:if>
				<xsl:if test="$namespace = 'nist' and not(.//*[local-name()='dt']//*[local-name()='stem'])">
					<xsl:attribute name="margin-left">5mm</xsl:attribute>
				</xsl:if>
				
				<fo:block>
					<xsl:if test="$namespace = 'nist' and not(.//*[local-name()='dt']//*[local-name()='stem'])">
						<xsl:attribute name="margin-left">-2.5mm</xsl:attribute>
					</xsl:if>
					
					<!-- create virtual html table for dl/[dt and dd] -->
					<xsl:variable name="html-table">
						<xsl:element name="{$namespace}:table">
							<tbody>
								<xsl:apply-templates mode="dl"/>
							</tbody>
						</xsl:element>
					</xsl:variable>
					
					<xsl:variable name="colwidths">
						<xsl:call-template name="calculate-column-widths">
							<xsl:with-param name="cols-count" select="2"/>
							<xsl:with-param name="table" select="$html-table"/>
						</xsl:call-template>
					</xsl:variable>
					<!-- colwidths=<xsl:value-of select="$colwidths"/> -->
					
					<fo:table width="95%" table-layout="fixed">
						<xsl:choose>
							<xsl:when test="$key_iso = 'true' and $parent = 'formula'">
								<!-- <xsl:attribute name="font-size">11pt</xsl:attribute> -->
							</xsl:when>
							<xsl:when test="$key_iso = 'true'">
								<xsl:attribute name="font-size">10pt</xsl:attribute>
							</xsl:when>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="ancestor::*[local-name()='dl']"><!-- second level, i.e. inlined table -->
								<fo:table-column column-width="50%"/>
								<fo:table-column column-width="50%"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:choose>
									<!-- <xsl:when test="xalan:nodeset($colwidths)/column[1] div xalan:nodeset($colwidths)/column[2] &gt; 1.7">
										<fo:table-column column-width="60%"/>
										<fo:table-column column-width="40%"/>
									</xsl:when> -->
									<xsl:when test="xalan:nodeset($colwidths)/column[1] div xalan:nodeset($colwidths)/column[2] &gt; 1.3">
										<fo:table-column column-width="50%"/>
										<fo:table-column column-width="50%"/>
									</xsl:when>
									<xsl:when test="xalan:nodeset($colwidths)/column[1] div xalan:nodeset($colwidths)/column[2] &gt; 0.5">
										<fo:table-column column-width="40%"/>
										<fo:table-column column-width="60%"/>
									</xsl:when>
									<xsl:otherwise>
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
									</xsl:otherwise>
								</xsl:choose>
								<!-- <fo:table-column column-width="15%"/>
								<fo:table-column column-width="85%"/> -->
							</xsl:otherwise>
						</xsl:choose>
						<fo:table-body>
							<xsl:apply-templates>
								<xsl:with-param name="key_iso" select="$key_iso"/>
							</xsl:apply-templates>
						</fo:table-body>
					</fo:table>
				</fo:block>
			</fo:block>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="*[local-name()='dl']/*[local-name()='note']">
		<xsl:param name="key_iso"/>
		
		<!-- <tr>
			<td>NOTE</td>
			<td>
				<xsl:apply-templates />
			</td>
		</tr>
		 -->
		<fo:table-row>
			<fo:table-cell>
				<fo:block margin-top="6pt">
					<xsl:if test="$key_iso = 'true'">
						<xsl:attribute name="margin-top">0</xsl:attribute>
					</xsl:if>
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
	
	<xsl:template match="*[local-name()='dt']" mode="dl">
		<tr>
			<td>
				<xsl:apply-templates />
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="$namespace = 'nist'">
						<xsl:if test="local-name(*[1]) != 'stem'">
							<xsl:apply-templates select="following-sibling::*[local-name()='dd'][1]" mode="process"/>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="following-sibling::*[local-name()='dd'][1]" mode="process"/>
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
		<xsl:if test="local-name(*[1]) = 'stem' and $namespace = 'nist' ">
			<tr>
				<td>
					<xsl:text>&#xA0;</xsl:text>
				</td>
				<td>
					<xsl:apply-templates select="following-sibling::*[local-name()='dd'][1]" mode="dl_process"/>
				</td>
			</tr>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="*[local-name()='dt']">
		<xsl:param name="key_iso"/>
		
		<fo:table-row>
			<fo:table-cell>
				<fo:block margin-top="6pt">
					<xsl:if test="$key_iso = 'true'">
						<xsl:attribute name="margin-top">0</xsl:attribute>
					</xsl:if>
					<xsl:if test="$namespace = 'nist'">
						<xsl:attribute name="margin-top">0</xsl:attribute>
						<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
					</xsl:if>
					<xsl:apply-templates />
				</fo:block>
			</fo:table-cell>
			<fo:table-cell>
				<fo:block>
					<xsl:choose>
						<xsl:when test="$namespace = 'nist'">
							<xsl:if test="local-name(*[1]) != 'stem'">
								<xsl:apply-templates select="following-sibling::*[local-name()='dd'][1]" mode="process"/>
							</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="following-sibling::*[local-name()='dd'][1]" mode="process"/>
						</xsl:otherwise>
					</xsl:choose>
				</fo:block>
			</fo:table-cell>
		</fo:table-row>
		<xsl:if test="local-name(*[1]) = 'stem' and $namespace = 'nist' ">
			<fo:table-row>
			<fo:table-cell>
				<fo:block margin-top="6pt">
					<xsl:if test="$key_iso = 'true'">
						<xsl:attribute name="margin-top">0</xsl:attribute>
					</xsl:if>
					<xsl:text>&#xA0;</xsl:text>
				</fo:block>
			</fo:table-cell>
			<fo:table-cell>
				<fo:block>
					<xsl:apply-templates select="following-sibling::*[local-name()='dd'][1]" mode="process"/>
				</fo:block>
			</fo:table-cell>
		</fo:table-row>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="*[local-name()='dd']" mode="dl"/>
	<xsl:template match="*[local-name()='dd']" mode="dl_process">
		<xsl:apply-templates />
	</xsl:template>
	
	<xsl:template match="*[local-name()='dd']"/>
	<xsl:template match="*[local-name()='dd']" mode="process">
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="*[local-name()='dd']/*[local-name()='p']" mode="inline">
		<fo:inline><xsl:apply-templates /></fo:inline>
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
		<xsl:variable name="zero-space-after-dot">.</xsl:variable>
		<xsl:variable name="zero-space-after-colon">:</xsl:variable>
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
			<xsl:when test="contains($text, $zero-space-after-dot)">
				<xsl:value-of select="substring-before($text, $zero-space-after-dot)"/>
				<xsl:value-of select="$zero-space-after-dot"/>
				<xsl:value-of select="$zero-space"/>
				<xsl:call-template name="add-zero-spaces">
					<xsl:with-param name="text" select="substring-after($text, $zero-space-after-dot)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($text, $zero-space-after-colon)">
				<xsl:value-of select="substring-before($text, $zero-space-after-colon)"/>
				<xsl:value-of select="$zero-space-after-colon"/>
				<xsl:value-of select="$zero-space"/>
				<xsl:call-template name="add-zero-spaces">
					<xsl:with-param name="text" select="substring-after($text, $zero-space-after-colon)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>   

	<!-- Table normalization (colspan,rowspan processing for adding TDs) for column width calculation -->
	<xsl:template name="getSimpleTable">
		<xsl:variable name="simple-table">
		
			<!-- Step 1. colspan processing -->
			<xsl:variable name="simple-table-colspan">
				<tbody>
					<xsl:apply-templates mode="simple-table-colspan"/>
				</tbody>
			</xsl:variable>
			
			<!-- Step 2. rowspan processing -->
			<xsl:variable name="simple-table-rowspan">
				<xsl:apply-templates select="xalan:nodeset($simple-table-colspan)" mode="simple-table-rowspan"/>
			</xsl:variable>
			
			<xsl:copy-of select="xalan:nodeset($simple-table-rowspan)"/>
					
			<!-- <xsl:choose>
				<xsl:when test="current()//*[local-name()='th'][@colspan] or current()//*[local-name()='td'][@colspan] ">
					
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="current()"/>
				</xsl:otherwise>
			</xsl:choose> -->
		</xsl:variable>
		<xsl:copy-of select="$simple-table"/>
	</xsl:template>
		
	<!-- ===================== -->
	<!-- 1. mode "simple-table-colspan" 
			1.1. remove thead, tbody, fn
			1.2. rename th -> td
			1.3. repeating N td with colspan=N
			1.4. remove namespace
			1.5. remove @colspan attribute
			1.6. add @divide attribute for divide text width in further processing 
	-->
	<!-- ===================== -->	
	<xsl:template match="*[local-name()='thead'] | *[local-name()='tbody']" mode="simple-table-colspan">
		<xsl:apply-templates mode="simple-table-colspan"/>
	</xsl:template>
	<xsl:template match="*[local-name()='fn']" mode="simple-table-colspan"/>
	
	<xsl:template match="*[local-name()='th'] | *[local-name()='td']" mode="simple-table-colspan">
		<xsl:choose>
			<xsl:when test="@colspan">
				<xsl:variable name="td">
					<xsl:element name="td">
						<xsl:attribute name="divide"><xsl:value-of select="@colspan"/></xsl:attribute>
						<xsl:apply-templates select="@*" mode="simple-table-colspan"/>
						<xsl:apply-templates mode="simple-table-colspan"/>
					</xsl:element>
				</xsl:variable>
				<xsl:call-template name="repeatNode">
					<xsl:with-param name="count" select="@colspan"/>
					<xsl:with-param name="node" select="$td"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="td">
					<xsl:apply-templates select="@*" mode="simple-table-colspan"/>
					<xsl:apply-templates mode="simple-table-colspan"/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="@colspan" mode="simple-table-colspan"/>
	
	<xsl:template match="*[local-name()='tr']" mode="simple-table-colspan">
		<xsl:element name="tr">
			<xsl:apply-templates select="@*" mode="simple-table-colspan"/>
			<xsl:apply-templates mode="simple-table-colspan"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="@*|node()" mode="simple-table-colspan">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="simple-table-colspan"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- repeat node 'count' times -->
	<xsl:template name="repeatNode">
		<xsl:param name="count"/>
		<xsl:param name="node"/>
		
		<xsl:if test="$count &gt; 0">
			<xsl:call-template name="repeatNode">
				<xsl:with-param name="count" select="$count - 1"/>
				<xsl:with-param name="node" select="$node"/>
			</xsl:call-template>
			<xsl:copy-of select="$node"/>
		</xsl:if>
	</xsl:template>
	<!-- End mode simple-table-colspan  -->
	<!-- ===================== -->
	<!-- ===================== -->
	
	<!-- ===================== -->
	<!-- 2. mode "simple-table-rowspan" 
	Row span processing, more information http://andrewjwelch.com/code/xslt/table/table-normalization.html	-->
	<!-- ===================== -->		
	<xsl:template match="@*|node()" mode="simple-table-rowspan">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="simple-table-rowspan"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="tbody" mode="simple-table-rowspan">
		<xsl:copy>
				<xsl:copy-of select="tr[1]" />
				<xsl:apply-templates select="tr[2]" mode="simple-table-rowspan">
						<xsl:with-param name="previousRow" select="tr[1]" />
				</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="tr" mode="simple-table-rowspan">
		<xsl:param name="previousRow"/>
		<xsl:variable name="currentRow" select="." />
	
		<xsl:variable name="normalizedTDs">
				<xsl:for-each select="xalan:nodeset($previousRow)//td">
						<xsl:choose>
								<xsl:when test="@rowspan &gt; 1">
										<xsl:copy>
												<xsl:attribute name="rowspan">
														<xsl:value-of select="@rowspan - 1" />
												</xsl:attribute>
												<xsl:copy-of select="@*[not(name() = 'rowspan')]" />
												<xsl:copy-of select="node()" />
										</xsl:copy>
								</xsl:when>
								<xsl:otherwise>
										<xsl:copy-of select="$currentRow/td[1 + count(current()/preceding-sibling::td[not(@rowspan) or (@rowspan = 1)])]" />
								</xsl:otherwise>
						</xsl:choose>
				</xsl:for-each>
		</xsl:variable>

		<xsl:variable name="newRow">
				<xsl:copy>
						<xsl:copy-of select="$currentRow/@*" />
						<xsl:copy-of select="xalan:nodeset($normalizedTDs)" />
				</xsl:copy>
		</xsl:variable>
		<xsl:copy-of select="$newRow" />

		<xsl:apply-templates select="following-sibling::tr[1]" mode="simple-table-rowspan">
				<xsl:with-param name="previousRow" select="$newRow" />
		</xsl:apply-templates>
	</xsl:template>
	<!-- End mode simple-table-rowspan  -->
	<!-- ===================== -->	
	<!-- ===================== -->	

	<xsl:template name="getLang">
		<xsl:variable name="language" select="//*[local-name()='bibdata']//*[local-name()='language']"/>
		<xsl:choose>
			<xsl:when test="$language = 'English'">en</xsl:when>
			<xsl:otherwise><xsl:value-of select="$language"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>
