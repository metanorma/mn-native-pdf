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

	<!-- ========================= -->
	<!-- Rich text formatting -->
	<!-- ========================= -->
	
	<xsl:attribute-set name="pre-style">
		<xsl:attribute name="font-family">Courier New, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>
		<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		<xsl:if test="$namespace = 'bsi' or $namespace = 'pas'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="font-family"><xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>
			<xsl:attribute name="line-height">113%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csd'">
			<xsl:attribute name="font-family"><xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="margin-top">5pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">5pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="margin-top">5pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">5pt</xsl:attribute>
			<xsl:attribute name="font-size">95%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="font-family">Fira Code, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>
			<xsl:attribute name="line-height">113%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jcgm'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'm3d'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>		
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="font-family">Fira Code, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>
			<xsl:attribute name="line-height">113%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:attribute name="line-height">113%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-family"><xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>
			<xsl:attribute name="line-height">113%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp' or $namespace = 'nist-sp'">
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece' or $namespace = 'unece-rec'">
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- pre-style -->
	
	<xsl:template name="refine_pre-style">
	</xsl:template>
	
	<xsl:attribute-set name="tt-style">
		<xsl:if test="$namespace = 'csa' or $namespace = 'csd' or $namespace = 'rsd'">
			<xsl:attribute name="font-family"><xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'bsi' or $namespace = 'pas' or $namespace = 'gb' or $namespace = 'iec' or $namespace = 'iho' or $namespace = 'iso' or $namespace = 'm3d' or 
										 $namespace = 'ogc-white-paper' or $namespace = 'jcgm'">
			<xsl:attribute name="font-family">Courier New, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="font-family">Fira Code, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>			
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:template name="refine_tt-style">
		<xsl:variable name="_font-size">
			<xsl:if test="$namespace = 'csa'">10</xsl:if>
			<xsl:if test="$namespace = 'csd'">10</xsl:if>
			<xsl:if test="$namespace = 'gb'">10</xsl:if>
			<xsl:if test="$namespace = 'iec'">10</xsl:if>
			<xsl:if test="$namespace = 'iho'">9.5</xsl:if>
			<xsl:if test="$namespace = 'iso'">9</xsl:if> <!-- inherit -->
			<xsl:if test="$namespace = 'bsi' or $namespace = 'pas'">10</xsl:if>
			<xsl:if test="$namespace = 'jcgm'">10</xsl:if>
			<xsl:if test="$namespace = 'itu'"></xsl:if>
			<xsl:if test="$namespace = 'm3d'">
				<xsl:choose>
					<xsl:when test="not(ancestor::mn:note)">10</xsl:when>
					<xsl:otherwise>11</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:if test="$namespace = 'mpfd'"></xsl:if>
			<xsl:if test="$namespace = 'nist-cswp'  or $namespace = 'nist-sp'"></xsl:if>
			<xsl:if test="$namespace = 'ogc'">
				<xsl:choose>
					<xsl:when test="ancestor::mn:table">8.5</xsl:when>
					<xsl:otherwise>9.5</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:if test="$namespace = 'ogc-white-paper'">
				<xsl:choose>
					<xsl:when test="ancestor::mn:table">8.5</xsl:when>
					<xsl:otherwise>9.5</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:if test="$namespace = 'rsd'">
				<xsl:choose>
					<xsl:when test="ancestor::mn:table">inherit</xsl:when>
					<xsl:otherwise>95%</xsl:otherwise> <!-- 110% -->
				</xsl:choose>
			</xsl:if>
			<xsl:if test="$namespace = 'unece' or $namespace = 'unece-rec'"></xsl:if>		
		</xsl:variable>
		<xsl:variable name="font-size" select="normalize-space($_font-size)"/>		
		<xsl:if test="$font-size != ''">
			<xsl:attribute name="font-size">
				<xsl:choose>
					<xsl:when test="$font-size = 'inherit'"><xsl:value-of select="$font-size"/></xsl:when>
					<xsl:when test="contains($font-size, '%')"><xsl:value-of select="$font-size"/></xsl:when>
					<xsl:when test="ancestor::mn:note or ancestor::mn:example"><xsl:value-of select="$font-size * 0.91"/>pt</xsl:when>
					<xsl:otherwise><xsl:value-of select="$font-size"/>pt</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
		</xsl:if>
	</xsl:template>
	
	<xsl:variable name="color-added-text">
		<xsl:text>rgb(0, 255, 0)</xsl:text>
	</xsl:variable>
	<xsl:attribute-set name="add-style">
		<xsl:choose>
			<xsl:when test="$namespace = 'bsi' or $namespace = 'pas'">
				<xsl:attribute name="font-style">italic</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="color">red</xsl:attribute>
				<xsl:attribute name="text-decoration">underline</xsl:attribute>
				<!-- <xsl:attribute name="color">black</xsl:attribute>
				<xsl:attribute name="background-color"><xsl:value-of select="$color-added-text"/></xsl:attribute>
				<xsl:attribute name="padding-top">1mm</xsl:attribute>
				<xsl:attribute name="padding-bottom">0.5mm</xsl:attribute> -->
			</xsl:otherwise>
		</xsl:choose>
	</xsl:attribute-set>
	
	<xsl:template name="refine_add-style">
	</xsl:template>
  
	<xsl:variable name="add-style">
		<add-style xsl:use-attribute-sets="add-style">
			<xsl:call-template name="refine_add-style"/>
		</add-style>
	</xsl:variable>
	<xsl:template name="append_add-style">
		<xsl:copy-of select="xalan:nodeset($add-style)/add-style/@*"/>
	</xsl:template>

	<xsl:variable name="color-deleted-text">
		<xsl:text>red</xsl:text>
	</xsl:variable>
	<xsl:attribute-set name="del-style">
		<xsl:attribute name="color"><xsl:value-of select="$color-deleted-text"/></xsl:attribute>
		<xsl:attribute name="text-decoration">line-through</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:template name="refine_del-style">
	</xsl:template>

	<xsl:attribute-set name="strong-style">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_strong_style">
		<xsl:if test="$namespace = 'iso'">
			<xsl:if test="ancestor::*[local-name() = 'item']">
				<xsl:attribute name="role">SKIP</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:if test="not($vertical_layout = 'true')">
				<xsl:attribute name="font-family">Times New Roman</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:if test="not(parent::mn:fmt-termsource)">
				<xsl:attribute name="font-weight">normal</xsl:attribute>
				<xsl:attribute name="color">black</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="ancestor::*['preferred']">
			<xsl:attribute name="role">SKIP</xsl:attribute>
		</xsl:if>
	</xsl:template> <!-- refine_strong_style -->

	<xsl:attribute-set name="em-style">
		<xsl:attribute name="font-style">italic</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_em_style">
		<xsl:if test="$namespace = 'iso'">
			<xsl:if test="ancestor::*[local-name() = 'item']">
				<xsl:attribute name="role">SKIP</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:if test="$lang = 'ar'"> <!-- to prevent rendering `###` due the missing Arabic glyphs in the italic font (Times New Roman) -->
				<xsl:attribute name="font-style">normal</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template> <!-- refine_em_style -->
	
	<xsl:attribute-set name="sup-style">
		<xsl:attribute name="font-size">80%</xsl:attribute>
		<xsl:attribute name="vertical-align">super</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:template name="refine_sup-style">
	</xsl:template>

	<xsl:attribute-set name="sub-style">
		<xsl:attribute name="font-size">80%</xsl:attribute>
		<xsl:attribute name="vertical-align">sub</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:template name="refine_sub-style">
	</xsl:template>
	
	<xsl:attribute-set name="underline-style">
		<xsl:attribute name="text-decoration">underline</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:template name="refine_underline-style">
	</xsl:template>
	
	<xsl:attribute-set name="hi-style">
		<xsl:attribute name="background-color">yellow</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:template name="refine_hi-style">
	</xsl:template>
	
	<xsl:attribute-set name="strike-style">
		<xsl:attribute name="text-decoration">line-through</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:template name="refine_strike-style">
	</xsl:template>
	
	<xsl:template match="mn:br">
		<xsl:value-of select="$linebreak"/>
	</xsl:template>
	
	<xsl:template match="mn:em">
		<fo:inline xsl:use-attribute-sets="em-style">
			<xsl:call-template name="refine_em_style"/>
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>

	<xsl:template match="mn:strong | *[local-name()='b']">
		<xsl:param name="split_keep-within-line"/>
		<fo:inline xsl:use-attribute-sets="strong-style">
			<xsl:call-template name="refine_strong_style"/>
			
			<xsl:apply-templates>
				<xsl:with-param name="split_keep-within-line" select="$split_keep-within-line"/>
			</xsl:apply-templates>
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="*[local-name()='padding']">
		<fo:inline padding-right="{@value}">&#xA0;</fo:inline>
	</xsl:template>
	
	<xsl:template match="mn:sup">
		<fo:inline xsl:use-attribute-sets="sup-style">
			<xsl:call-template name="refine_sup-style"/>
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>

	<xsl:template match="mn:sub">
		<fo:inline xsl:use-attribute-sets="sub-style">
			<xsl:call-template name="refine_sub-style"/>
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="mn:tt">
		<fo:inline xsl:use-attribute-sets="tt-style">
			<xsl:call-template name="refine_tt-style"/>
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template> <!-- tt -->
	
	<xsl:variable name="regex_url_start">^(http://|https://|www\.)?(.*)</xsl:variable>
	<xsl:template match="mn:tt/text()" priority="2">
		<xsl:choose>
			<xsl:when test="java:replaceAll(java:java.lang.String.new(.), $regex_url_start, '$2') != ''">
				 <!-- url -->
				<xsl:call-template name="add-zero-spaces-link-java"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="add_spaces_to_sourcecode"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="mn:underline">
		<fo:inline xsl:use-attribute-sets="underline-style">
			<xsl:call-template name="refine_underline-style"/>
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>
	
	<!-- ================= -->
	<!-- Added,deleted text -->
	<!-- ================= -->
	<xsl:template match="mn:add | mn:change-open-tag | mn:change-close-tag" name="tag_add">
		<xsl:param name="skip">true</xsl:param>
		<xsl:param name="block">false</xsl:param>
		<xsl:param name="type"/>
		<xsl:param name="text-align"/>
		<xsl:choose>
			<xsl:when test="starts-with(., $ace_tag) or self::mn:change-open-tag or self::mn:change-close-tag"> <!-- examples: ace-tag_A1_start, ace-tag_A2_end, C1_start, AC_start, or
							<change-open-tag>A<sub>1</sub></change-open-tag>, <change-close-tag>A<sub>1</sub></change-close-tag> -->
				<xsl:choose>
					<xsl:when test="$skip = 'true' and 
					((local-name(../..) = 'note' and not(preceding-sibling::node())) or 
					(parent::mn:fmt-title and preceding-sibling::node()[1][self::mn:tab]) or
					local-name(..) = 'formattedref' and not(preceding-sibling::node()))
					and 
					../node()[last()][self::mn:add][starts-with(text(), $ace_tag)]"><!-- start tag displayed in template name="note" and title --></xsl:when>
					<xsl:otherwise>
						<xsl:variable name="tag">
							<xsl:call-template name="insertTag">
								<xsl:with-param name="type">
									<xsl:choose>
										<xsl:when test="self::mn:change-open-tag">start</xsl:when>
										<xsl:when test="self::mn:change-close-tag">end</xsl:when>
										<xsl:when test="$type = ''"><xsl:value-of select="substring-after(substring-after(., $ace_tag), '_')"/> <!-- start or end --></xsl:when>
										<xsl:otherwise><xsl:value-of select="$type"/></xsl:otherwise>
									</xsl:choose>
								</xsl:with-param>
								<xsl:with-param name="kind">
									<xsl:choose>
										<xsl:when test="self::mn:change-open-tag or self::mn:change-close-tag">
											<xsl:value-of select="text()"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="substring(substring-before(substring-after(., $ace_tag), '_'), 1, 1)"/> <!-- A or C -->
										</xsl:otherwise>
									</xsl:choose>
								</xsl:with-param>
								<xsl:with-param name="value">
									<xsl:choose>
										<xsl:when test="self::mn:change-open-tag or self::mn:change-close-tag">
											<xsl:value-of select="mn:sub"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="substring(substring-before(substring-after(., $ace_tag), '_'), 2)"/> <!-- 1, 2, C -->
										</xsl:otherwise>
									</xsl:choose>
								</xsl:with-param>
							</xsl:call-template>
						</xsl:variable>
						<xsl:choose>
							<xsl:when test="$block = 'false'">
								<fo:inline>
									<xsl:copy-of select="$tag"/>									
								</fo:inline>
							</xsl:when>
							<xsl:otherwise>
								<fo:block> <!-- for around figures -->
									<xsl:if test="$text-align != ''">
										<xsl:attribute name="text-align"><xsl:value-of select="$text-align"/></xsl:attribute>
									</xsl:if>
									<xsl:copy-of select="$tag"/>
								</fo:block>
							</xsl:otherwise>
						</xsl:choose>
						
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="@amendment">
				<fo:inline>
					<xsl:call-template name="insertTag">
						<xsl:with-param name="kind">A</xsl:with-param>
						<xsl:with-param name="value"><xsl:value-of select="@amendment"/></xsl:with-param>
					</xsl:call-template>
					<xsl:apply-templates />
					<xsl:call-template name="insertTag">
						<xsl:with-param name="type">closing</xsl:with-param>
						<xsl:with-param name="kind">A</xsl:with-param>
						<xsl:with-param name="value"><xsl:value-of select="@amendment"/></xsl:with-param>
					</xsl:call-template>
				</fo:inline>
			</xsl:when>
			<xsl:when test="@corrigenda">
				<fo:inline>
					<xsl:call-template name="insertTag">
						<xsl:with-param name="kind">C</xsl:with-param>
						<xsl:with-param name="value"><xsl:value-of select="@corrigenda"/></xsl:with-param>
					</xsl:call-template>
					<xsl:apply-templates />
					<xsl:call-template name="insertTag">
						<xsl:with-param name="type">closing</xsl:with-param>
						<xsl:with-param name="kind">C</xsl:with-param>
						<xsl:with-param name="value"><xsl:value-of select="@corrigenda"/></xsl:with-param>
					</xsl:call-template>
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<fo:inline xsl:use-attribute-sets="add-style">
					<xsl:apply-templates />
				</fo:inline>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- add -->
	
	<xsl:template name="insertTag">
		<xsl:param name="type"/>
		<xsl:param name="kind"/>
		<xsl:param name="value"/>
		<xsl:variable name="add_width" select="string-length($value) * 20" />
		<xsl:variable name="maxwidth" select="60 + $add_width"/>
			<fo:instream-foreign-object fox:alt-text="OpeningTag" baseline-shift="-10%"><!-- alignment-baseline="middle" -->
				<xsl:attribute name="height">3.5mm</xsl:attribute> <!-- 5mm -->
				<xsl:attribute name="content-width">100%</xsl:attribute>
				<xsl:attribute name="content-width">scale-down-to-fit</xsl:attribute>
				<xsl:attribute name="scaling">uniform</xsl:attribute>
				<!-- <svg xmlns="http://www.w3.org/2000/svg" width="{$maxwidth + 32}" height="80">
					<g>
						<xsl:if test="$type = 'closing' or $type = 'end'">
							<xsl:attribute name="transform">scale(-1 1) translate(-<xsl:value-of select="$maxwidth + 32"/>,0)</xsl:attribute>
						</xsl:if>
						<polyline points="0,0 {$maxwidth},0 {$maxwidth + 30},40 {$maxwidth},80 0,80 " stroke="black" stroke-width="5" fill="white"/>
						<line x1="0" y1="0" x2="0" y2="80" stroke="black" stroke-width="20"/>
					</g>
					<text font-family="Arial" x="15" y="57" font-size="40pt">
						<xsl:if test="$type = 'closing' or $type = 'end'">
							<xsl:attribute name="x">25</xsl:attribute>
						</xsl:if>
						<xsl:value-of select="$kind"/><tspan dy="10" font-size="30pt"><xsl:value-of select="$value"/></tspan>
					</text>
				</svg> -->
				<svg xmlns="http://www.w3.org/2000/svg" width="{$maxwidth + 32}" height="80">
					<g>
						<xsl:if test="$type = 'closing' or $type = 'end'">
							<xsl:attribute name="transform">scale(-1 1) translate(-<xsl:value-of select="$maxwidth + 32"/>,0)</xsl:attribute>
						</xsl:if>
						<polyline points="0,2.5 {$maxwidth},2.5 {$maxwidth + 20},40 {$maxwidth},77.5 0,77.5" stroke="black" stroke-width="5" fill="white"/>
						<line x1="9.5" y1="0" x2="9.5" y2="80" stroke="black" stroke-width="19"/>
					</g>
					<xsl:variable name="text_x">
						<xsl:choose>
							<xsl:when test="$type = 'closing' or $type = 'end'">28</xsl:when>
							<xsl:otherwise>22</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<text font-family="Arial" x="{$text_x}" y="50" font-size="40pt">
						<xsl:value-of select="$kind"/>
					</text>
					<text font-family="Arial" x="{$text_x + 33}" y="65" font-size="38pt">
						<xsl:value-of select="$value"/>
					</text>
				</svg>
			</fo:instream-foreign-object>
	</xsl:template>
	
	<xsl:template match="mn:del">
		<fo:inline xsl:use-attribute-sets="del-style">
			<xsl:call-template name="refine_del-style"/>
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>
	<!-- ================= -->
	<!-- END Added,deleted text -->
	<!-- ================= -->
	
	<!-- highlight text -->
	<xsl:template match="mn:hi | mn:span[@class = 'fmt-hi']" priority="3">
		<fo:inline xsl:use-attribute-sets="hi-style">
			<xsl:call-template name="refine_hi-style"/>
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="text()[ancestor::mn:smallcap]" name="smallcaps">
		<xsl:param name="txt"/>
		<!-- <xsl:variable name="text" select="normalize-space(.)"/> --> <!-- https://github.com/metanorma/metanorma-iso/issues/1115 -->
		<xsl:variable name="text">
			<xsl:choose>
				<xsl:when test="$txt != ''">
					<xsl:value-of select="$txt"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="ratio_">
			<xsl:choose>
				<xsl:when test="$namespace = 'iso'">
					<xsl:choose>
						<xsl:when test="$layoutVersion = '1951'">0.9</xsl:when>
						<xsl:when test="$layoutVersion = '2024'">0.8</xsl:when>
						<xsl:otherwise>0.75</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>0.75</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="ratio" select="number(normalize-space($ratio_))"/>
		<fo:inline font-size="{$ratio * 100}%" role="SKIP">
				<xsl:if test="string-length($text) &gt; 0">
					<xsl:variable name="smallCapsText">
						<xsl:call-template name="recursiveSmallCaps">
							<xsl:with-param name="text" select="$text"/>
							<xsl:with-param name="ratio" select="$ratio"/>
						</xsl:call-template>
					</xsl:variable>
					<!-- merge neighboring fo:inline -->
					<xsl:for-each select="xalan:nodeset($smallCapsText)/node()">
						<xsl:choose>
							<xsl:when test="self::fo:inline and preceding-sibling::node()[1][self::fo:inline]"><!-- <xsl:copy-of select="."/> --></xsl:when>
							<xsl:when test="self::fo:inline and @font-size">
								<xsl:variable name="curr_pos" select="count(preceding-sibling::node()) + 1"/>
								<!-- <curr_pos><xsl:value-of select="$curr_pos"/></curr_pos> -->
								<xsl:variable name="next_text_" select="count(following-sibling::node()[not(local-name() = 'inline')][1]/preceding-sibling::node())"/>
								<xsl:variable name="next_text">
									<xsl:choose>
										<xsl:when test="$next_text_ = 0">99999999</xsl:when>
										<xsl:otherwise><xsl:value-of select="$next_text_ + 1"/></xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<!-- <next_text><xsl:value-of select="$next_text"/></next_text> -->
								<fo:inline>
									<xsl:copy-of select="@*"/>
									<xsl:copy-of select="./node()"/>
									<xsl:for-each select="following-sibling::node()[position() &lt; $next_text - $curr_pos]"> <!-- [self::fo:inline] -->
										<xsl:copy-of select="./node()"/>
									</xsl:for-each>
								</fo:inline>
							</xsl:when>
							<xsl:otherwise>
								<xsl:copy-of select="."/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:if>
			</fo:inline> 
	</xsl:template>
	
	<xsl:template name="recursiveSmallCaps">
    <xsl:param name="text"/>
    <xsl:param name="ratio">0.75</xsl:param>
    <xsl:variable name="char" select="substring($text,1,1)"/>
    <!-- <xsl:variable name="upperCase" select="translate($char, $lower, $upper)"/> -->
		<xsl:variable name="upperCase" select="java:toUpperCase(java:java.lang.String.new($char))"/>
    <xsl:choose>
      <xsl:when test="$char=$upperCase">
        <fo:inline font-size="{100 div $ratio}%" role="SKIP">
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
        <xsl:with-param name="ratio" select="$ratio"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
	
	<xsl:template match="mn:strike">
		<fo:inline xsl:use-attribute-sets="strike-style">
			<xsl:call-template name="refine_strike-style"/>
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>
	
	<!-- Example: <span style="font-family:&quot;Noto Sans JP&quot;">styled text</span> -->
	<xsl:template match="mn:span[@style]" priority="2">
		<xsl:variable name="styles__">
			<xsl:call-template name="split">
				<xsl:with-param name="pText" select="concat(@style,';')"/>
				<xsl:with-param name="sep" select="';'"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="quot">"</xsl:variable>
		<xsl:variable name="styles_">
			<xsl:for-each select="xalan:nodeset($styles__)/mnx:item">
				<xsl:variable name="key" select="normalize-space(substring-before(., ':'))"/>
				<xsl:variable name="value_" select="normalize-space(substring-after(translate(.,$quot,''), ':'))"/>
				<xsl:variable name="value">
					<xsl:choose>
						<!-- if font-size is digits only -->
						<xsl:when test="$key = 'font-size' and translate($value_, '0123456789', '') = ''"><xsl:value-of select="$value_"/>pt</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$value_"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:if test="$key = 'font-family' or 
									$key = 'font-size' or
									$key = 'color' or
									$key = 'baseline-shift' or
									$key = 'line-height'
									">
					<style name="{$key}"><xsl:value-of select="$value"/></style>
				</xsl:if>
				<xsl:if test="$key = 'text-indent'">
					<style name="padding-left"><xsl:value-of select="$value"/></style>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="styles" select="xalan:nodeset($styles_)"/>
		<xsl:choose>
			<xsl:when test="$styles/style">
				<fo:inline>
					<xsl:for-each select="$styles/style">
						<xsl:attribute name="{@name}"><xsl:value-of select="."/></xsl:attribute>
						<xsl:if test="$namespace = 'jis'">
							<xsl:if test="@name = 'font-family' and . = 'MS Gothic'">
								<xsl:if test="not($vertical_layout = 'true')">
									<xsl:attribute name="{@name}">IPAexGothic</xsl:attribute>
								</xsl:if>
								<xsl:if test="$vertical_layout = 'true'">
									<xsl:attribute name="{@name}">Noto Serif JP</xsl:attribute>
								</xsl:if>
							</xsl:if>
						</xsl:if>
					</xsl:for-each>
					<xsl:apply-templates />
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- END: span[@style] -->
	
	<!-- Note: to enable the addition of character span markup with semantic styling for DIS Word output -->
	<xsl:template match="mn:span">
		<xsl:apply-templates />
	</xsl:template>
	
	<!-- Don't break standard's numbers -->
	<!-- Example : <span class="stdpublisher">ISO</span> <span class="stddocNumber">10303</span>-<span class="stddocPartNumber">1</span>:<span class="stdyear">1994</span> -->
	<xsl:template match="mn:span[@class = 'stdpublisher' or @class = 'stddocNumber' or @class = 'stddocPartNumber' or @class = 'stdyear']" priority="2">
		<xsl:choose>
			<xsl:when test="ancestor::mn:table"><xsl:apply-templates /></xsl:when>
			<xsl:when test="following-sibling::*[2][self::mn:span][@class = 'stdpublisher' or @class = 'stddocNumber' or @class = 'stddocPartNumber' or @class = 'stdyear']">
				<fo:inline keep-with-next.within-line="always" role="SKIP"><xsl:apply-templates /></fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="text()[not(ancestor::mn:table) and preceding-sibling::*[1][self::mn:span][@class = 'stdpublisher' or @class = 'stddocNumber' or @class = 'stddocPartNumber' or @class = 'stdyear'] and 
	following-sibling::*[1][self::mn:span][@class = 'stdpublisher' or @class = 'stddocNumber' or @class = 'stddocPartNumber' or @class = 'stdyear']]" priority="2">
		<fo:inline keep-with-next.within-line="always" role="SKIP"><xsl:value-of select="."/></fo:inline>
	</xsl:template>
	
	
	<xsl:template match="mn:span[contains(@style, 'text-transform:none')]//text()" priority="5">
		<xsl:value-of select="."/>
	</xsl:template>
	
	<xsl:template match="mn:pre" name="pre">
		<fo:block xsl:use-attribute-sets="pre-style">
			<xsl:call-template name="refine_pre-style"/>
			<xsl:copy-of select="@id"/>
			<xsl:choose>
			
				<xsl:when test="ancestor::mn:sourcecode[@linenums = 'true'] and ancestor::*[local-name() = 'td'][1][not(preceding-sibling::*)]"> <!-- pre in the first td in the table with @linenums = 'true' -->
					<xsl:if test="ancestor::mn:tr[1]/following-sibling::mn:tr"> <!-- is current tr isn't last -->
						<xsl:attribute name="margin-top">0pt</xsl:attribute>
						<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
					</xsl:if>
					<fo:instream-foreign-object fox:alt-text="{.}" content-width="95%">
						<math xmlns="http://www.w3.org/1998/Math/MathML">
							<mtext><xsl:value-of select="."/></mtext>
						</math>
					</fo:instream-foreign-object>
				</xsl:when>
				
				<xsl:otherwise>
					<xsl:apply-templates />
				</xsl:otherwise>
				
			</xsl:choose>		
		</fo:block>
	</xsl:template> <!-- pre -->
	
	<!-- ========================= -->
	<!-- END Rich text formatting -->
	<!-- ========================= -->
	
</xsl:stylesheet>