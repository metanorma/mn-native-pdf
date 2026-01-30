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
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="line-height-shift-adjustment">disregard-shifts</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute><!-- 8pt -->
			<xsl:attribute name="line-height">1.4</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'pas'">
			<xsl:attribute name="line-height">1.32</xsl:attribute>
			<xsl:attribute name="space-after">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="line-height">155%</xsl:attribute>
			<xsl:attribute name="space-after">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csd'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="line-height">115%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="margin-top">5pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute><!-- 8pt -->
			<xsl:attribute name="line-height">1.2</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="space-after">6pt</xsl:attribute>
			<xsl:attribute name="line-height">115%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="text-align">justify</xsl:attribute>
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
			<xsl:attribute name="line-height">1.13</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jcgm'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:attribute name="margin-bottom">10pt</xsl:attribute>
			<xsl:attribute name="line-height">1.5</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:attribute name="space-after">12pt</xsl:attribute>
			<xsl:attribute name="line-height">115%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'plateau'">
			<xsl:attribute name="margin-bottom">10pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- p-style -->
	
	<xsl:template name="refine_p-style">
		<xsl:param name="element-name"/>
		<xsl:param name="margin"/>
		<xsl:if test="$namespace = 'bipm'">
			<xsl:copy-of select="@id"/>
			<xsl:attribute name="text-align">
				<xsl:choose>
					<xsl:when test="@align"><xsl:value-of select="@align"/></xsl:when>
					<xsl:when test="ancestor::mn:note_side">left</xsl:when>
					<xsl:when test="../@align"><xsl:value-of select="../@align"/></xsl:when>
					<xsl:otherwise>justify</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:call-template name="setKeepAttributes"/>
			<xsl:copy-of select="@font-family"/>
			<xsl:if test="not(ancestor::mn:table)">
				<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="ancestor::mn:table and ancestor::mn:preface">
				<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="parent::mn:li">
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="@align = 'center'">
				<xsl:attribute name="keep-with-next">always</xsl:attribute>
			</xsl:if>
			<xsl:if test="*[1][self::mn:strong] and normalize-space(.) = normalize-space(*[1])">
				<xsl:attribute name="keep-with-next">always</xsl:attribute>
			</xsl:if>
			<xsl:if test="@parent-type = 'quote'">
				<xsl:attribute name="font-family">Arial</xsl:attribute>
				<xsl:attribute name="font-size">9pt</xsl:attribute>
				<xsl:attribute name="line-height">130%</xsl:attribute>
				<xsl:attribute name="role">BlockQuote</xsl:attribute>
			</xsl:if>
			<!-- $namespace = 'bipm' -->
		</xsl:if>
		
		<xsl:if test="$namespace = 'bsi'">
			<xsl:call-template name="setBlockAttributes"/>
					
			<xsl:if test="../following-sibling::*[1][self::mn:note or self::mn:termnote or self::mn:ul or self::mn:ol] or following-sibling::*[1][self::mn:ul or self::mn:ol]">
				<xsl:attribute name="margin-bottom">4pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="parent::mn:li">
				<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
				<xsl:if test="ancestor::mn:feedback-statement">
					<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="parent::mn:li and (ancestor::mn:note or ancestor::mn:termnote)">
				<xsl:attribute name="margin-bottom">4pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="(following-sibling::*[1][self::mn:clause or self::mn:terms or self::mn:references])">
				<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
			</xsl:if>
			<xsl:copy-of select="@id"/>
			
			<!-- bookmarks only in paragraph -->
			<xsl:if test="count(mn:bookmark) != 0 and count(*) = count(mn:bookmark) and normalize-space() = ''">
				<xsl:attribute name="font-size">0</xsl:attribute>
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
				<xsl:attribute name="line-height">0</xsl:attribute>
			</xsl:if>
			<xsl:if test="ancestor::mn:admonition and not(ancestor::mn:admonition/@type = 'commentary')">
				<xsl:attribute name="text-align">justify</xsl:attribute>
				<xsl:if test="not(following-sibling::*)">
					<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="ancestor::*[@key = 'true'] or ancestor::mn:key">
				<xsl:attribute name="margin-bottom">2pt</xsl:attribute>
			</xsl:if>
			<!-- $namespace = 'bsi' -->
		</xsl:if>
		
		<xsl:if test="$namespace = 'pas'">
			<xsl:call-template name="setBlockAttributes"/>
			
			<xsl:call-template name="setBlockSpanAll"/>
			
			<!-- for paragraphs in foreword, that contain only bolded text -->
			<xsl:if test="count(*) = 1 and mn:strong and normalize-space(text()) = '' and preceding-sibling::mn:fmt-title[1]/preceding-sibling::*[1][self::mn:foreword]">
				<xsl:attribute name="space-after">6pt</xsl:attribute>
				<xsl:choose>
					<xsl:when test="not(following-sibling::*[1][self::mn:figure])"> <!-- if next element isn't figure -->
						<xsl:attribute name="font-size">12pt</xsl:attribute>
						<xsl:attribute name="color"><xsl:value-of select="$color_secondary_shade_1_PAS"/></xsl:attribute>
						<xsl:attribute name="keep-with-next">always</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<!-- <xsl:attribute name="font-size">11pt</xsl:attribute> -->
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<!-- if first preceding title that has following paragraph with text starts with 'COMMENTARY ON ' -->
			<xsl:if test="preceding-sibling::mn:fmt-title[1]/following-sibling::*[1][self::mn:p and starts-with(normalize-space(), 'COMMENTARY ON ')]">
				<xsl:attribute name="color"><xsl:value-of select="$color_secondary_shade_1_PAS"/></xsl:attribute>
				<xsl:if test="starts-with(normalize-space(), 'COMMENTARY ON ')">
					<xsl:attribute name="space-after">6pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="parent::mn:li">
				<xsl:if test="../../preceding-sibling::mn:fmt-title[1]/following-sibling::*[1][self::mn:p and starts-with(normalize-space(), 'COMMENTARY ON ')]">
					<xsl:attribute name="color"><xsl:value-of select="$color_secondary_shade_1_PAS"/></xsl:attribute>
				</xsl:if>
			</xsl:if>
			
			<xsl:if test="parent::mn:li">
				<xsl:attribute name="space-after">2pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="parent::mn:fmt-definition">
				<xsl:attribute name="space-after">2pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="following-sibling::*[1][self::mn:ul or self::mn:ol]">
				<xsl:attribute name="space-after">4pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="following-sibling::*[1][self::mn:note]">
				<xsl:attribute name="space-after">2pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="parent::*[self::mn:admonition and @type = 'commentary']">
				<xsl:attribute name="space-after">2pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="@align = 'span'">
				<xsl:attribute name="span">all</xsl:attribute>
			</xsl:if>
			<!-- <xsl:copy-of select="@span"/> -->
			<!-- <xsl:if test="normalize-space($span) = 'all'">
				<xsl:attribute name="span">all</xsl:attribute>
			</xsl:if> -->
			
			<!-- first p in Foreword -->
			<xsl:if test="preceding-sibling::*[2][self::mn:foreword]"> <!-- [1] ancestor is title, [2] is foreword -->
				<xsl:attribute name="span">all</xsl:attribute>
				<xsl:attribute name="color"><xsl:value-of select="$color_secondary_shade_1_PAS"/></xsl:attribute>
				<xsl:attribute name="font-size">13pt</xsl:attribute>
				<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			</xsl:if>
			
			<!-- put inline title in the first paragraph -->
			<xsl:if test="preceding-sibling::*[1]/@inline-header = 'true' and preceding-sibling::*[1][self::mn:fmt-title]">
				<xsl:attribute name="space-before">0pt</xsl:attribute>
				<xsl:for-each select="preceding-sibling::*[1]">
					<xsl:call-template name="title"/>
				</xsl:for-each>
				<xsl:text> </xsl:text>
			</xsl:if>
			<!-- $namespace = 'pas' -->
		</xsl:if>
		
		<xsl:if test="$namespace = 'csa'">
			<xsl:copy-of select="@id"/>
			<xsl:call-template name="setBlockAttributes"/>
			
			<xsl:if test="ancestor::mn:li">
				<xsl:attribute name="space-after">0pt</xsl:attribute>
			</xsl:if>
			<!-- $namespace = 'csa' -->
		</xsl:if>
		
		<xsl:if test="$namespace = 'csd'">
			<xsl:call-template name="setBlockAttributes"/>
			
			<xsl:if test="ancestor::mn:li">
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			</xsl:if>
			<!-- $namespace = 'csd' -->
		</xsl:if>
		
		<xsl:if test="$namespace = 'iec'">
			<xsl:call-template name="setBlockAttributes">
				<xsl:with-param name="text_align_default">justify</xsl:with-param>
			</xsl:call-template>
			
			<xsl:if test="ancestor::mn:fmt-definition">
				<xsl:attribute name="margin-top">1pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="ancestor::mn:dl">
				<xsl:attribute name="margin-top">0pt</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="local-name(following-sibling::*[1])= 'table'">
				<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="ancestor::mn:admonition">
				<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="ancestor::mn:admonition and not(following-sibling::mn:p)">
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="ancestor::mn:dl">
				<xsl:attribute name="margin-bottom">5pt</xsl:attribute>
			</xsl:if>
			<xsl:copy-of select="@id"/>
			<!-- $namespace = 'iec' -->
		</xsl:if>
		
		<xsl:if test="$namespace = 'ieee'">
			<xsl:call-template name="setBlockAttributes">
				<xsl:with-param name="text_align_default">justify</xsl:with-param>
			</xsl:call-template>
			
			<xsl:if test="($current_template = 'whitepaper' or $current_template = 'icap-whitepaper' or $current_template = 'industry-connection-report') and (ancestor::mn:sections or ancestor::mn:annex)">
				<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="../following-sibling::*[1][self::mn:note or self::mn:termnote or self::mn:ul or self::mn:ol] or following-sibling::*[1][self::mn:ul or self::mn:ol]">
				<xsl:attribute name="margin-bottom">4pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="parent::mn:li">
				<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
				<xsl:if test="ancestor::mn:feedback-statement">
					<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="parent::mn:li and (ancestor::mn:note or ancestor::mn:termnote)">
				<xsl:attribute name="margin-bottom">4pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="(following-sibling::*[1][self::mn:clause or self::mn:terms or self::mn:references])">
				<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
			</xsl:if>
			<xsl:copy-of select="@id"/>
			
			<!-- bookmarks only in paragraph -->
			<xsl:if test="count(mn:bookmark) != 0 and count(*) = count(mn:bookmark) and normalize-space() = ''">
				<xsl:attribute name="font-size">0</xsl:attribute>
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
				<xsl:attribute name="line-height">0</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="($current_template = 'whitepaper' or $current_template = 'icap-whitepaper' or $current_template = 'industry-connection-report') and not(parent::mn:li)">
				<xsl:attribute name="line-height"><xsl:value-of select="$line-height"/></xsl:attribute>
				<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="($current_template = 'whitepaper' or $current_template = 'icap-whitepaper' or $current_template = 'industry-connection-report') and parent::mn:li">
				<xsl:attribute name="line-height">inherit</xsl:attribute>
				<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			</xsl:if>
			<!-- $namespace = 'ieee' -->
		</xsl:if>
		
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="text-align">
				<xsl:choose>
					<xsl:when test="ancestor::mn:quote">justify</xsl:when>
					<xsl:when test="ancestor::mn:feedback-statement">right</xsl:when>
					<xsl:when test="ancestor::mn:boilerplate and not(@align)">justify</xsl:when>
					<xsl:when test="@align = 'justified'">justify</xsl:when>
					<xsl:when test="@align"><xsl:value-of select="@align"/></xsl:when>
					<xsl:when test="ancestor::mn:td/@align"><xsl:value-of select="ancestor::mn:td/@align"/></xsl:when>
					<xsl:when test="ancestor::mn:th/@align"><xsl:value-of select="ancestor::mn:th/@align"/></xsl:when>
					<xsl:otherwise>justify</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:call-template name="setKeepAttributes"/>
			
			<xsl:if test="parent::mn:dd">
				<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="ancestor::*[2][self::mn:license-statement] and not(following-sibling::mn:p)">
				<xsl:attribute name="space-after">0pt</xsl:attribute>
			</xsl:if>
			
			<!-- <xsl:attribute name="border">1pt solid red</xsl:attribute> -->
			<xsl:if test="ancestor::mn:boilerplate and not(ancestor::mn:feedback-statement)">
				<xsl:attribute name="line-height">125%</xsl:attribute>
				<xsl:attribute name="space-after">14pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="following-sibling::*[1][self::mn:ol or self::mn:ul or self::mn:note or self::mn:termnote or self::mn:example or self::mn:dl]">
				<xsl:attribute name="space-after">3pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="following-sibling::*[1][self::mn:dl]">
				<xsl:attribute name="space-after">6pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="ancestor::mn:quote">
				<xsl:attribute name="line-height">130%</xsl:attribute>
				<!-- <xsl:attribute name="margin-bottom">12pt</xsl:attribute> -->
			</xsl:if>
			
			<xsl:if test="ancestor::*[self::mn:recommendation or self::mn:requirement or self::mn:permission] and
			not(following-sibling::*)">
				<xsl:attribute name="space-after">0pt</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="ancestor::mn:li and ancestor::mn:table">
				<xsl:attribute name="space-after">0pt</xsl:attribute>
			</xsl:if>
			
			<xsl:if test=".//mn:fn">
				<xsl:attribute name="line-height-shift-adjustment">disregard-shifts</xsl:attribute>
			</xsl:if>
			
			<xsl:copy-of select="@id"/>
			<!-- $namespace = 'iho' -->
		</xsl:if>
		
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

		<xsl:if test="$namespace = 'itu'">
			<xsl:call-template name="setKeepAttributes"/>
			
			<xsl:if test="@class='supertitle'">
				<xsl:attribute name="space-before">36pt</xsl:attribute>
				<xsl:attribute name="margin-bottom">24pt</xsl:attribute>
				<xsl:attribute name="margin-top">0pt</xsl:attribute>
				<xsl:attribute name="font-size">14pt</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="text-align">
				<xsl:choose>
					<xsl:when test="@class='supertitle'">center</xsl:when>
					<!-- <xsl:when test="@align"><xsl:value-of select="@align"/></xsl:when> -->
					<xsl:when test="@align"><xsl:call-template name="setAlignment"/></xsl:when>
					<xsl:when test="ancestor::*[1][self::mn:td]/@align">
						<!-- <xsl:value-of select="ancestor::*[1][local-name() = 'td']/@align"/> -->
						<xsl:call-template name="setAlignment">
							<xsl:with-param name="align" select="ancestor::*[1][self::mn:td]/@align"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="ancestor::*[1][self::mn:th]/@align">
						<!-- <xsl:value-of select="ancestor::*[1][local-name() = 'th']/@align"/> -->
						<xsl:call-template name="setAlignment">
							<xsl:with-param name="align" select="ancestor::*[1][self::mn:th]/@align"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>justify</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<!-- $namespace = 'itu' -->
		</xsl:if>
		
		<xsl:if test="$namespace = 'jcgm'">
			<xsl:call-template name="setBlockAttributes">
				<xsl:with-param name="text_align_default">justify</xsl:with-param>
			</xsl:call-template>
			
			<xsl:if test="ancestor::*[@first or @slave]">
				<!-- JCGM two column layout -->
				<xsl:attribute name="widows">1</xsl:attribute>
				<xsl:attribute name="orphans">1</xsl:attribute>
			</xsl:if>
			<!-- $namespace = 'jcgm' -->
		</xsl:if>
		
		<xsl:if test="$namespace = 'jis'">
			<xsl:call-template name="setBlockAttributes">
				<xsl:with-param name="text_align_default">justify</xsl:with-param>
			</xsl:call-template>
			
			<xsl:if test="not(parent::mn:note or parent::mn:li or ancestor::mn:table)">
				<xsl:attribute name="text-indent"><xsl:value-of select="$text_indent"/>mm</xsl:attribute>
			</xsl:if>
			
			<xsl:copy-of select="@id"/>
			
			<!-- bookmarks only in paragraph -->
		
			<xsl:if test="count(mn:bookmark) != 0 and count(*) = count(mn:bookmark) and normalize-space() = ''">
				<xsl:attribute name="font-size">0</xsl:attribute>
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
				<xsl:attribute name="line-height">0</xsl:attribute>
			</xsl:if>

			<xsl:if test="ancestor::*[@key = 'true'] or ancestor::mn:key">
				<xsl:attribute name="margin-bottom">2pt</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="parent::mn:fmt-definition">
				<xsl:attribute name="margin-bottom">2pt</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="parent::mn:li or following-sibling::*[1][self::mn:ol or self::mn:ul or self::mn:note or self::mn:example] or parent::mn:quote">
				<xsl:attribute name="margin-bottom">4pt</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="parent::mn:td or parent::mn:th or parent::mn:dd">
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="parent::mn:clause[@type = 'inner-cover-note'] or ancestor::mn:boilerplate">
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			</xsl:if>
			<!-- $namespace = 'jis' -->
		</xsl:if>

		<xsl:if test="$namespace = 'nist-cswp'">
			<xsl:attribute name="margin-bottom">
				<xsl:choose>
					<xsl:when test="(parent::mn:td or parent::mn:th) and ancestor::mn:annex">0</xsl:when>
					<xsl:when test="$margin != ''"><xsl:value-of select="$margin"/></xsl:when>
					<xsl:otherwise>12pt</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			
			<xsl:call-template name="setBlockAttributes"/>

			<xsl:if test="ancestor::mn:preface or ancestor::mn:boilerplate">
				<xsl:attribute name="text-align">justify</xsl:attribute>
			</xsl:if>
			<xsl:if test="ancestor::mn:attribution">
				<xsl:attribute name="text-align">right</xsl:attribute>
			</xsl:if>
			<!-- $namespace = 'nist-cswp' -->
		</xsl:if>
		
		<xsl:if test="$namespace = 'nist-sp'">
			<xsl:attribute name="margin-bottom">
				<xsl:choose>
					<xsl:when test="(parent::mn:td or parent::mn:th)">0</xsl:when> <!-- and ancestor::mn:annex -->
					<xsl:when test="$margin != ''"><xsl:value-of select="$margin"/></xsl:when>
					<xsl:otherwise>12pt</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			
			<!-- <xsl:if test="not(local-name(..) = 'td' or local-name(..) = 'th')">
				<xsl:attribute name="text-align">
					<xsl:choose>
						<xsl:when test="@align"><xsl:value-of select="@align"/></xsl:when>
						<xsl:otherwise>left</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</xsl:if> -->
			
			<xsl:call-template name="setBlockAttributes"/>
			
			<xsl:if test="ancestor::mn:license-statement">
				<xsl:if test="$stage = 'draft-internal'">
					<xsl:attribute name="font-size">14pt</xsl:attribute>
					<xsl:attribute name="text-align">center</xsl:attribute>
				</xsl:if>
				<xsl:if test="$stage = 'draft-wip' or $stage = 'draft-prelim' or $stage = 'draft-public'">
					<xsl:attribute name="text-align">justify</xsl:attribute>				
				</xsl:if>
			</xsl:if>
			<xsl:if test="ancestor::mn:attribution">
				<xsl:attribute name="text-align">right</xsl:attribute>
			</xsl:if>
			<!-- $namespace = 'nist-sp' -->
		</xsl:if>
		
		<xsl:if test="$namespace = 'ogc'">
			<xsl:copy-of select="@id"/>
			
			<xsl:call-template name="setBlockAttributes"/>
			
			<xsl:if test="not(ancestor::mn:table)">
				<xsl:attribute name="line-height">124%</xsl:attribute>
				<xsl:attribute name="margin-bottom">10pt</xsl:attribute>
			</xsl:if>			
			<xsl:if test="ancestor::mn:dd and not(ancestor::mn:table)">
				<xsl:attribute name="margin-bottom">4pt</xsl:attribute>
				<xsl:if test="not(ancestor::mn:dd[1]/following-sibling::mn:dt)">
					<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<!-- $namespace = 'ogc' -->
		</xsl:if>
		
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:copy-of select="@id"/>
			
			<xsl:call-template name="setBlockAttributes"/>
				
			<xsl:if test="ancestor::mn:li">
				<xsl:attribute name="space-after">0pt</xsl:attribute>
			</xsl:if>					
			
			<xsl:if test="ancestor::mn:dd and not(ancestor::mn:table)">
				<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			</xsl:if>
			<!-- $namespace = 'ogc-white-paper' -->
		</xsl:if>
		
		<xsl:if test="$namespace = 'plateau'">
			<xsl:call-template name="setBlockAttributes">
				<xsl:with-param name="text_align_default">justify</xsl:with-param>
			</xsl:call-template>
			
			<xsl:if test="$doctype = 'technical-report'">
				<xsl:attribute name="margin-bottom">18pt</xsl:attribute>
			</xsl:if>
			
			<!--
			<xsl:if test="not(parent::mn:note or parent::mn:li or ancestor::mn:table)">
				<xsl:attribute name="text-indent"><xsl:value-of select="$text_indent"/>mm</xsl:attribute>
			</xsl:if>
			-->
			
			<xsl:copy-of select="@id"/>
			
			<xsl:if test="$doctype = 'technical-report'">
				<xsl:attribute name="line-height">1.8</xsl:attribute>
			</xsl:if>
			
			<!-- bookmarks only in paragraph -->
			<xsl:if test="count(mn:bookmark) != 0 and count(*) = count(mn:bookmark) and normalize-space() = ''">
				<xsl:attribute name="font-size">0</xsl:attribute>
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
				<xsl:attribute name="line-height">0</xsl:attribute>
			</xsl:if>

			<xsl:if test="ancestor::*[@key = 'true'] or ancestor::mn:key">
				<xsl:attribute name="margin-bottom">2pt</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="parent::mn:fmt-definition">
				<xsl:attribute name="margin-bottom">2pt</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="parent::mn:li or parent::mn:quote">
				<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="parent::mn:li and following-sibling::*[1][self::mn:ol or self::mn:ul or self::mn:note or self::mn:example]">
				<xsl:attribute name="margin-bottom">4pt</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="ancestor::mn:td or ancestor::mn:th">
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="parent::mn:dd">
				<xsl:attribute name="margin-bottom">5pt</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="parent::mn:dd and (ancestor::mn:dl[@key = 'true'] or ancestor::mn:key) and (ancestor::mn:tfoot or ancestor::mn:figure)">
				<xsl:attribute name="margin-bottom">2pt</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="parent::mn:clause[@type = 'inner-cover-note'] or ancestor::mn:boilerplate">
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="parent::mn:note and not(following-sibling::*)">
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="(ancestor::*[local-name() = 'td' or local-name() = 'th']) and
									(.//*[local-name() = 'font_en' or local-name() = 'font_en_bold'])">
				<xsl:if test="$isGenerateTableIF = 'false'">
					<xsl:attribute name="language">en</xsl:attribute>
					<xsl:attribute name="hyphenate">true</xsl:attribute>
				</xsl:if>
			</xsl:if>
			
			<xsl:if test="ancestor::mn:note[@type = 'units']">
				<xsl:attribute name="text-align">right</xsl:attribute>
			</xsl:if>
			
			<!-- paragraph in table or figure footer -->
			<xsl:if test="parent::mn:table or parent::mn:figure or (ancestor::mn:tfoot and ancestor::mn:td[1]/@colspan and not(parent::mn:dd))">
				<xsl:attribute name="margin-left"><xsl:value-of select="$tableAnnotationIndent"/></xsl:attribute>
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			</xsl:if>
			<!-- namespace = 'plateau' -->
		</xsl:if>
		
		<xsl:if test="$namespace = 'rsd'">
			<xsl:call-template name="setBlockAttributes"/>
			
			<xsl:copy-of select="@id"/>
			
			<xsl:attribute name="space-after">
				<xsl:choose>
					<xsl:when test="ancestor::mn:li">6pt</xsl:when>
					<xsl:when test="ancestor::mn:feedback-statement and not(following-sibling::mn:p)">0pt</xsl:when>
					<xsl:otherwise>6pt</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:if  test="ancestor::mn:dl">
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			</xsl:if>
			<!-- namespace = 'rsd' -->
		</xsl:if>
		
	</xsl:template> <!-- refine_p-style -->

</xsl:stylesheet>