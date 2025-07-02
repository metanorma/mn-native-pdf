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
	
	<xsl:attribute-set name="term-style">
		<xsl:if test="$namespace = 'bsi' or $namespace = 'iho' or $namespace = 'iso' or $namespace = 'jcgm'">
			<xsl:attribute name="margin-bottom">10pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:attribute name="space-before">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'plateau'">
			<xsl:attribute name="space-after">12pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- term-style -->
	
	<xsl:attribute-set name="term-name-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:if test="$namespace = 'jis'">
			<xsl:attribute name="space-after">2pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'plateau'">
			<xsl:attribute name="font-weight">normal</xsl:attribute>
			<xsl:attribute name="space-after">2pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- term-name-style -->
	
		<xsl:attribute-set name="preferred-block-style">
		<xsl:if test="$namespace = 'csd'">
			<xsl:attribute name="line-height">1.1</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="line-height">1.1</xsl:attribute>
			<xsl:attribute name="space-before">14pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="line-height">1.1</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="line-height">1.1</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jcgm'">
			<xsl:attribute name="line-height">1.1</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
		</xsl:if>
	</xsl:attribute-set> <!-- preferred-block-style -->

	<xsl:attribute-set name="preferred-term-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="line-height">1</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:attribute name="line-height">1</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:attribute name="font-weight">normal</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'plateau'">
			<xsl:attribute name="font-weight">normal</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- preferred-term-style -->

	<xsl:attribute-set name="domain-style">
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="padding-left">7.4mm</xsl:attribute>
		</xsl:if>		
	</xsl:attribute-set> <!-- domain-style -->

	<xsl:attribute-set name="admitted-style">
		<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jcgm'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="color">black</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- admitted-style -->

	<xsl:attribute-set name="deprecates-style">
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="font-size">8pt</xsl:attribute>
			<xsl:attribute name="margin-top">5pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">5pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="color">black</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- deprecates-style -->
	
	<xsl:attribute-set name="related-block-style" use-attribute-sets="preferred-block-style">
	</xsl:attribute-set>

	<xsl:attribute-set name="definition-style">
		<xsl:if test="$namespace = 'csa' or $namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="space-after">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csd' or $namespace = 'iec' or $namespace = 'iho' or $namespace = 'iso' or $namespace = 'jcgm'">
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:attribute name="space-before">2pt</xsl:attribute>
			<xsl:attribute name="space-after">2pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
			<xsl:attribute name="space-before">12pt</xsl:attribute>
			<xsl:attribute name="space-after">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'plateau'">
			<xsl:attribute name="space-before">2pt</xsl:attribute>
			<xsl:attribute name="space-after">2pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- definition-style -->
	
	<xsl:attribute-set name="termsource-style">
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="text-align">right</xsl:attribute>
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa' or $namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csd' or $namespace = 'iec'">
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="text-indent">7.4mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso' or $namespace = 'jcgm'">
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:attribute name="margin-left">6mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- termsource-style -->
	
	<xsl:template name="refine_termsource-style">
		<xsl:if test="$namespace = 'bsi'">
			<xsl:if test="$document_type = 'PAS'">
				<xsl:attribute name="text-align">left</xsl:attribute>
				<xsl:attribute name="space-before">12pt</xsl:attribute>
				<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'plateau'">
			<xsl:if test="ancestor::mn:table">
				<xsl:attribute name="margin-bottom">1pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template> <!-- refine_termsource-style -->
	
	<xsl:attribute-set name="termsource-text-style">
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="color"><xsl:value-of select="$color_blue"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="padding-right">1mm</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- termsource-text-style -->
	
	<xsl:attribute-set name="origin-style">
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="color">rgb(33, 94, 159)</xsl:attribute>
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="color">blue</xsl:attribute>
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
		</xsl:if>
	</xsl:attribute-set> <!-- origin-style -->
	
	<!-- ====== -->
	<!-- term      -->	
	<!-- ====== -->
	
	<xsl:template match="mn:terms">
		<!-- <xsl:message>'terms' <xsl:number/> processing...</xsl:message> -->
		<xsl:call-template name="setNamedDestination"/>
		<fo:block id="{@id}">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="mn:term">
		<xsl:call-template name="setNamedDestination"/>
		<fo:block id="{@id}" xsl:use-attribute-sets="term-style">

			<xsl:if test="$namespace = 'gb'">
				<fo:block font-family="SimHei" font-size="11pt" keep-with-next="always" margin-top="10pt" margin-bottom="8pt" line-height="1.1">
					<xsl:apply-templates select="gb:name" />
				</fo:block>
			</xsl:if>
			<xsl:if test="$namespace = 'm3d'">
				<fo:block keep-with-next="always" margin-top="10pt" margin-bottom="8pt" line-height="1.1">
					<xsl:apply-templates select="m3d:name" />
				</fo:block>
			</xsl:if>
			<xsl:if test="$namespace = 'ogc'">
				<xsl:apply-templates select="mn:fmt-name" />
			</xsl:if>
			
			<xsl:if test="parent::mn:term and not(preceding-sibling::mn:term)">
				<xsl:if test="$namespace = 'iso'">
					<xsl:attribute name="space-before">12pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:apply-templates select="node()[not(self::mn:fmt-name)]" />
		</fo:block>
	</xsl:template>
	
	
	<xsl:template match="mn:term/mn:fmt-name">
		<xsl:if test="normalize-space() != ''">
			<!-- <xsl:variable name="level">
				<xsl:call-template name="getLevelTermName"/>
			</xsl:variable>
			<fo:inline role="H{$level}">
				<xsl:apply-templates />
			</fo:inline> -->
			<xsl:apply-templates />
		</xsl:if>
	</xsl:template>
	<!-- ====== -->
	<!-- ====== -->
	

	<!-- ====== -->
	<!-- termsource -->	
	<!-- origin -->	
	<!-- modification -->		
	<!-- ====== -->
	<xsl:template match="mn:termsource" name="termsource">
		<fo:block xsl:use-attribute-sets="termsource-style">
			
			<xsl:call-template name="refine_termsource-style"/>
			
			<!-- Example: [SOURCE: ISO 5127:2017, 3.1.6.02] -->			
			<xsl:variable name="termsource_text">
				<xsl:apply-templates />
			</xsl:variable>
			<xsl:copy-of select="$termsource_text"/>
			<!-- <xsl:choose>
				<xsl:when test="starts-with(normalize-space($termsource_text), '[')">
					<xsl:copy-of select="$termsource_text"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="$namespace = 'bsi'">
						<xsl:choose>
							<xsl:when test="$document_type = 'PAS' and starts-with(mn:origin/@citeas, '[')"><xsl:text>{</xsl:text></xsl:when>
							<xsl:otherwise><xsl:text>[</xsl:text></xsl:otherwise>
						</xsl:choose>
					</xsl:if>
					<xsl:if test="$namespace = 'gb' or $namespace = 'iso' or $namespace = 'iec' or $namespace = 'itu' or $namespace = 'unece' or $namespace = 'unece-rec' or $namespace = 'nist-cswp'  or $namespace = 'nist-sp' or $namespace = 'ogc-white-paper' or $namespace = 'csa' or $namespace = 'csd' or $namespace = 'm3d' or $namespace = 'iho' or $namespace = 'bipm' or $namespace = 'jcgm'">
						<xsl:text>[</xsl:text>
					</xsl:if>
					<xsl:copy-of select="$termsource_text"/>
					<xsl:if test="$namespace = 'bsi'">
						<xsl:choose>
							<xsl:when test="$document_type = 'PAS' and starts-with(mn:origin/@citeas, '[')"><xsl:text>}</xsl:text></xsl:when>
							<xsl:otherwise><xsl:text>]</xsl:text></xsl:otherwise>
						</xsl:choose>
					</xsl:if>
					<xsl:if test="$namespace = 'gb' or $namespace = 'iso' or $namespace = 'iec' or $namespace = 'itu' or $namespace = 'unece' or $namespace = 'unece-rec' or $namespace = 'nist-cswp'  or $namespace = 'nist-sp' or $namespace = 'ogc-white-paper' or $namespace = 'csa' or $namespace = 'csd' or $namespace = 'm3d' or $namespace = 'iho' or $namespace = 'bipm' or $namespace = 'jcgm'">
						<xsl:text>]</xsl:text>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose> -->
		</fo:block>
	</xsl:template>

	
	<xsl:template match="mn:termsource/text()[starts-with(., '[SOURCE: Adapted from: ') or
				starts-with(., '[SOURCE: Quoted from: ') or
				starts-with(., '[SOURCE: Modified from: ')]" priority="2">
		<xsl:text>[</xsl:text><xsl:value-of select="substring-after(., '[SOURCE: ')"/>
	</xsl:template>
	
	<xsl:template match="mn:termsource/text()">
		<xsl:if test="normalize-space() != ''">
			<xsl:value-of select="."/>
		</xsl:if>
	</xsl:template>
	
	
	<!-- text SOURCE: -->
	<xsl:template match="mn:termsource/mn:strong[1][following-sibling::*[1][self::mn:origin]]/text()">
		<fo:inline xsl:use-attribute-sets="termsource-text-style">
			<xsl:value-of select="."/>
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="mn:origin">
		<xsl:call-template name="insert_basic_link">
			<xsl:with-param name="element">
				<fo:basic-link internal-destination="{@bibitemid}" fox:alt-text="{@citeas}">
					<xsl:if test="normalize-space(@citeas) = ''">
						<xsl:attribute name="fox:alt-text"><xsl:value-of select="@bibitemid"/></xsl:attribute>
					</xsl:if>
					<fo:inline xsl:use-attribute-sets="origin-style">
						<xsl:apply-templates/>
					</fo:inline>
				</fo:basic-link>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	
	<!-- not using, see https://github.com/glossarist/iev-document/issues/23 -->
	<xsl:template match="mn:modification">
		<xsl:variable name="title-modified">
			<xsl:call-template name="getLocalizedString">
				<xsl:with-param name="key">modified</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="text"><xsl:apply-templates/></xsl:variable>
		<xsl:choose>
			<xsl:when test="$lang = 'zh'"><xsl:text>、</xsl:text><xsl:value-of select="$title-modified"/><xsl:if test="normalize-space($text) != ''"><xsl:text>—</xsl:text></xsl:if></xsl:when>
			<xsl:otherwise><xsl:text>, </xsl:text><xsl:value-of select="$title-modified"/><xsl:if test="normalize-space($text) != ''"><xsl:text> — </xsl:text></xsl:if></xsl:otherwise>
		</xsl:choose>
		<xsl:apply-templates/>
	</xsl:template>	
	
	<xsl:template match="mn:modification/mn:p">
		<fo:inline><xsl:apply-templates /></fo:inline>
	</xsl:template>	
	
	<xsl:template match="mn:modification/text()">
		<xsl:if test="normalize-space() != ''">
			<!-- <xsl:value-of select="."/> -->
			<xsl:call-template name="text"/>
		</xsl:if>
	</xsl:template>
	
	<!-- ====== -->
	<!-- ====== -->
	
	<!-- Preferred, admitted, deprecated -->
	<xsl:template match="mn:fmt-preferred">
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		<xsl:variable name="font-size">
			<xsl:choose>
				<xsl:when test="$namespace = 'csa'">
					<xsl:choose>
						<xsl:when test="$level &gt;= 2">11pt</xsl:when>
						<xsl:otherwise>12pt</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="$namespace = 'csd'">
					<xsl:choose>
						<xsl:when test="$level &gt;= 3">11pt</xsl:when>
						<xsl:otherwise>12pt</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="$namespace = 'ogc-white-paper'">
					<xsl:choose>
						<xsl:when test="$level &gt;= 2">11pt</xsl:when>
						<xsl:otherwise>12pt</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>inherit</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="levelTerm">
			<xsl:call-template name="getLevelTermName"/>
		</xsl:variable>
		<fo:block font-size="{normalize-space($font-size)}" role="H{$levelTerm}" xsl:use-attribute-sets="preferred-block-style">
		
			<xsl:if test="$namespace = 'iec'">
				<xsl:if test="preceding-sibling::*[1][self::mn:fmt-preferred]">
					<xsl:attribute name="space-before">1pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			
			<xsl:if test="$namespace = 'jis'">
				<xsl:if test="$vertical_layout = 'true'">
					<xsl:attribute name="letter-spacing">1mm</xsl:attribute>
					<xsl:attribute name="margin-left">-6mm</xsl:attribute>
				</xsl:if>
			</xsl:if>
			
			<xsl:if test="parent::mn:term and not(preceding-sibling::mn:fmt-preferred)"> <!-- if first preffered in term, then display term's name -->
				
				<fo:block xsl:use-attribute-sets="term-name-style" role="SKIP">
					<xsl:if test="$namespace = 'jis'">
						<xsl:if test="not($vertical_layout = 'true')">
							<xsl:attribute name="font-family">Times New Roman</xsl:attribute>
						</xsl:if>
					</xsl:if>
					
					<xsl:for-each select="ancestor::mn:term[1]/mn:fmt-name"><!-- change context -->
						<xsl:call-template name="setIDforNamedDestination"/>
					</xsl:for-each>
					
					<xsl:apply-templates select="ancestor::mn:term[1]/mn:fmt-name" />
				</fo:block>
			</xsl:if>
			
			<fo:block xsl:use-attribute-sets="preferred-term-style" role="SKIP">
				<xsl:call-template name="setStyle_preferred"/>
				
				<xsl:if test="$namespace = 'jis'">
					<xsl:if test="$vertical_layout = 'true'">
						<xsl:attribute name="margin-left">6mm</xsl:attribute>
						<xsl:attribute name="font-family">Noto Sans JP</xsl:attribute>
						<xsl:attribute name="font-weight">bold</xsl:attribute>
					</xsl:if>
					<xsl:if test="not($vertical_layout = 'true')">
						<xsl:attribute name="font-family">IPAexGothic</xsl:attribute>
					</xsl:if>
				</xsl:if>
				
				<xsl:apply-templates />
			</fo:block>
		</fo:block>
	</xsl:template>
	
	<!-- <xsl:template match="mn:domain"> -->
		<!-- https://github.com/metanorma/isodoc/issues/607 
		<fo:inline xsl:use-attribute-sets="domain-style">&lt;<xsl:apply-templates/>&gt;</fo:inline>
		<xsl:text> </xsl:text> -->
		<!-- <xsl:if test="not(@hidden = 'true')">
			<xsl:apply-templates/>
		</xsl:if>
	</xsl:template> -->
	
	<!-- https://github.com/metanorma/isodoc/issues/632#issuecomment-2567163931 -->
	<xsl:template match="mn:domain"/>
	
	<xsl:template match="mn:fmt-admitted">
		<fo:block xsl:use-attribute-sets="admitted-style">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="mn:fmt-deprecates">
		<fo:block xsl:use-attribute-sets="deprecates-style">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>

	<xsl:template name="setStyle_preferred">
		<xsl:choose>
			<xsl:when test="$namespace = 'rsd'">
				<xsl:attribute name="font-weight">normal</xsl:attribute>
				<xsl:attribute name="color">black</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="mn:strong">
					<xsl:attribute name="font-weight">normal</xsl:attribute>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- regarding ISO 10241-1:2011,  If there is more than one preferred term, each preferred term follows the previous one on a new line. -->
	<!-- in metanorma xml preferred terms delimited by semicolons -->
	<xsl:template match="mn:fmt-preferred/text()[contains(., ';')] | mn:fmt-preferred/mn:strong/text()[contains(., ';')]">
		<xsl:value-of select="java:replaceAll(java:java.lang.String.new(.), ';', $linebreak)"/>
	</xsl:template>
	<!--  End Preferred, admitted, deprecated -->
	
	<xsl:template match="mn:fmt-related">
		<fo:block role="SKIP" xsl:use-attribute-sets="related-block-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	<xsl:template match="mn:fmt-related/mn:p" priority="4">
		<fo:block>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<!-- ========== -->
	<!-- definition -->
	<!-- ========== -->
	<xsl:template match="mn:definition">
		<fo:block xsl:use-attribute-sets="definition-style" role="SKIP">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="mn:definition[preceding-sibling::mn:domain]">
		<xsl:apply-templates />
	</xsl:template>
	<xsl:template match="mn:definition[preceding-sibling::mn:domain]/mn:p[1]">
		<fo:inline> <xsl:apply-templates /></fo:inline>
		<fo:block></fo:block>
	</xsl:template>
	<!-- ========== -->
	<!-- END definition -->
	<!-- ========== -->
	
	<xsl:template match="mn:definitions">
		<xsl:call-template name="setNamedDestination"/>
		<fo:block id="{@id}">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
</xsl:stylesheet>