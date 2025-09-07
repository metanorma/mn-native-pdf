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
	
	<xsl:attribute-set name="toc-style">
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="line-height">135%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="font-size">12pt</xsl:attribute>
			<xsl:attribute name="line-height">170%</xsl:attribute>
			<xsl:attribute name="color">rgb(7, 72, 156)</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csd'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="line-height">115%</xsl:attribute>
			<xsl:attribute name="role">SKIP</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="line-height">115%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-sp'">
			<xsl:attribute name="font-family">Arial</xsl:attribute>
			<xsl:attribute name="font-size">11pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'plateau'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="margin-left">32mm</xsl:attribute>
			<xsl:attribute name="margin-right">-17mm</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:template name="refine_toc-style">
		<xsl:if test="$namespace = 'iso'">
			<xsl:if test="$layoutVersion = '1987'">
				<xsl:attribute name="font-size">9pt</xsl:attribute>
				<xsl:attribute name="font-weight">normal</xsl:attribute>
			</xsl:if>
		
			<xsl:if test="$layoutVersion = '1972' or $layoutVersion = '1979' or $layoutVersion = '1987' or ($layoutVersion = '1989' and $revision_date_num &lt;= 19981231)">
				<xsl:attribute name="margin-top">62mm</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:if test="not($vertical_layout = 'true') and not($lang = 'en')">
				<xsl:attribute name="font-family">IPAexGothic</xsl:attribute>
			</xsl:if>
			<xsl:if test="$vertical_layout = 'true'">
				<xsl:attribute name="font-size">10.5pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'plateau'">
			<xsl:if test="$doctype = 'technical-report'">
				<xsl:attribute name="font-weight">normal</xsl:attribute>
				<xsl:attribute name="line-height">1.2</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	
	<xsl:attribute-set name="toc-title-style">
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="margin-left">-14mm</xsl:attribute>
			<xsl:attribute name="font-family">Arial</xsl:attribute>
			<xsl:attribute name="font-size">16pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align-last">justify</xsl:attribute>
			<xsl:attribute name="margin-bottom">82pt</xsl:attribute>
			<xsl:attribute name="role">H1</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="font-size">26pt</xsl:attribute>
			<xsl:attribute name="color">black</xsl:attribute>
			<xsl:attribute name="margin-top">2pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">30pt</xsl:attribute>
			<xsl:attribute name="role">H1</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csd'">
			<xsl:attribute name="font-size">14pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">15.5pt</xsl:attribute>
			<xsl:attribute name="role">H1</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="font-size">12pt</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-bottom">22pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="font-family">Arial</xsl:attribute>
			<xsl:attribute name="font-size">12pt</xsl:attribute>
			<xsl:attribute name="role">H1</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">24pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="font-size">12pt</xsl:attribute>
			<xsl:attribute name="margin-top">4pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">7.5pt</xsl:attribute>
			<xsl:attribute name="role">SKIP</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="text-align-last">justify</xsl:attribute>
			<xsl:attribute name="font-size">16pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="margin-top">10pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">18pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="role">H1</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jcgm'">
			<xsl:attribute name="font-size">15pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="role">H1</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:attribute name="font-size">14pt</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-top">8.5mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-sp'">
			<xsl:attribute name="font-size">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="role">H1</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="font-size">33pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">4pt</xsl:attribute>
			<xsl:attribute name="role">H1</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:attribute name="font-size">26pt</xsl:attribute>		
			<xsl:attribute name="border-bottom">2pt solid rgb(21, 43, 77)</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>				
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="role">H1</xsl:attribute>
			<xsl:attribute name="font-size">27pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="color">black</xsl:attribute>
			<xsl:attribute name="margin-left">-15mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">13mm</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:template name="refine_toc-title-style">
		<xsl:if test="$namespace = 'jis'">
			<xsl:if test="not($vertical_layout = 'true')">
				<xsl:attribute name="font-family">IPAexGothic</xsl:attribute>
			</xsl:if>
			<xsl:if test="$vertical_layout = 'true'">
				<xsl:attribute name="text-align">left</xsl:attribute>
				<xsl:attribute name="font-weight">bold</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	
	<xsl:attribute-set name="toc-title-page-style">
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="text-align">right</xsl:attribute>
			<xsl:attribute name="font-size">9pt</xsl:attribute>
			<xsl:attribute name="font-family">Arial</xsl:attribute>
			<xsl:attribute name="role">SKIP</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="font-weight">normal</xsl:attribute>
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="role">SKIP</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="text-align">end</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:attribute name="text-align">right</xsl:attribute>
			<xsl:attribute name="margin-top">10mm</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- toc-title-page-style -->
	
	<xsl:template name="refine_toc-title-page-style">
		<xsl:if test="$namespace = 'jis'">
			<xsl:if test="not($vertical_layout = 'true')">
				<xsl:attribute name="font-family">IPAexMincho</xsl:attribute>
				<xsl:attribute name="font-size">8pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="$vertical_layout = 'true'">
				<xsl:attribute name="font-size">10.5pt</xsl:attribute>
				<xsl:attribute name="margin-top">1mm</xsl:attribute>
				<xsl:attribute name="margin-bottom">6mm</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	
	<xsl:attribute-set name="toc-item-block-style">
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="provisional-distance-between-starts">3mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="provisional-distance-between-starts">10mm</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:template name="refine_toc-item-block-style">
		<xsl:if test="$namespace = 'csa'">
			<xsl:if test="@level &gt;= 2">
				<xsl:attribute name="provisional-distance-between-starts"><xsl:value-of select="(@level - 1) * 10"/>mm</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="provisional-distance-between-starts">
				<xsl:choose>
					<xsl:when test="@level &gt;= 1 and @root = 'preface'">0mm</xsl:when>
					<xsl:when test="@level &gt;= 1 and @root = 'annex' and not(@type = 'annex')">13mm</xsl:when>
					<xsl:when test="@level &gt;= 1 and not(@type = 'annex')">
						<!-- for default values, maximum digits for 2nd level is 4, for example 20.19, 
						for 3rd level is 5, for example 2.15.12
						if not, then increase -->
						<xsl:variable name="default_value_">
							<xsl:choose>
								<xsl:when test="$toc_level = 3">12.9</xsl:when>
								<xsl:when test="$toc_level &gt; 3">15</xsl:when>
								<xsl:otherwise>10</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="default_value" select="number($default_value_)"/>
						<xsl:variable name="root-style"><root-style xsl:use-attribute-sets="root-style"/></xsl:variable>
						<xsl:variable name="font_size" select="normalize-space(translate(xalan:nodeset($root-style)/root-style/@font-size, 'pt', ''))"/>
						<xsl:variable name="item_section_max">
							<xsl:choose>
								<xsl:when test="following-sibling::mnx:item"><xsl:value-of select="following-sibling::mnx:item[last()]/@section"/></xsl:when>
								<xsl:otherwise><xsl:value-of select="@section"/></xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<!-- in em -->
						<xsl:variable name="text_rt_width_em" select="java:org.metanorma.fop.Util.getStringWidthByFontSize($item_section_max, $font_main, $font_size)"/>
						<!-- in mm, multiplier 3.175 for Arial em size -->
						<xsl:variable name="text_rt_width_mm" select="number($text_rt_width_em) div 10 * 3.175 + 2"/>
						<xsl:choose>
							<xsl:when test="$text_rt_width_mm &gt; $default_value"><xsl:value-of select="ceiling($text_rt_width_mm) + 1"/>mm</xsl:when>
							<xsl:otherwise><xsl:value-of select="$default_value"/>mm</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>0mm</xsl:otherwise>
				</xsl:choose>											
			</xsl:attribute>
		</xsl:if>
	</xsl:template>
	
	<xsl:attribute-set name="toc-item-style">
		<xsl:attribute name="role">TOCI</xsl:attribute>
		<xsl:if test="$namespace = 'bipm'">
		</xsl:if>
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="text-align-last">justify</xsl:attribute>
			<xsl:attribute name="margin-left">12mm</xsl:attribute>
			<xsl:attribute name="text-indent">-12mm</xsl:attribute>
			<xsl:attribute name="role">SKIP</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csd'">
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="role">SKIP</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="role">SKIP</xsl:attribute>
			<xsl:attribute name="text-align-last">justify</xsl:attribute>
			<xsl:attribute name="margin-left">12mm</xsl:attribute>
			<xsl:attribute name="text-indent">-12mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:attribute name="text-align-last">justify</xsl:attribute>
			<xsl:attribute name="role">SKIP</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-sp'">
			<xsl:attribute name="text-align-last">justify</xsl:attribute>
			<xsl:attribute name="margin-left">12mm</xsl:attribute>
			<xsl:attribute name="text-indent">-12mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:attribute name="margin-top">8pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">5pt</xsl:attribute>
			<xsl:attribute name="text-align-last">justify</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'plateau'">
			<xsl:attribute name="text-align-last">justify</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-size">13pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- END: toc-item-style -->
	
	<xsl:template name="refine_toc-item-style">
		<xsl:if test="$namespace = 'bipm'">
			<xsl:if test="@level = 1">
				<xsl:attribute name="font-family">Arial</xsl:attribute>
				<xsl:attribute name="font-size">10pt</xsl:attribute>
				<xsl:attribute name="font-weight">bold</xsl:attribute>
			</xsl:if>
			<xsl:if test="@level &gt;= 2 and not(@parent = 'annex')">
				<xsl:attribute name="font-size">10.5pt</xsl:attribute>
			</xsl:if>									
			<xsl:if test="@level = 2">
				<xsl:attribute name="margin-left">8mm</xsl:attribute>
			</xsl:if>
			<xsl:if test="@level &gt; 2">
				<xsl:attribute name="margin-left">9mm</xsl:attribute>
			</xsl:if>
			<xsl:if test="@level &gt;= 2 and @parent = 'annex'">
				<xsl:attribute name="font-family">Arial</xsl:attribute>
				<xsl:attribute name="font-size">8pt</xsl:attribute>
				<xsl:attribute name="margin-left">25mm</xsl:attribute>
				<xsl:attribute name="font-weight">bold</xsl:attribute>
			</xsl:if>
			<xsl:if test="@type = 'index'">
				<xsl:attribute name="font-family">Arial</xsl:attribute>
				<xsl:attribute name="font-size">10pt</xsl:attribute>
				<xsl:attribute name="font-weight">bold</xsl:attribute>
				<xsl:attribute name="space-before">14pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'csd'">
			<xsl:if test="@level = 1">
				<xsl:attribute name="margin-top">6pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:if test="@level = 1">
				<xsl:attribute name="margin-bottom">5pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="@level = 2">
				<xsl:attribute name="margin-bottom">3pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="@level &gt;= 3">
				<xsl:attribute name="margin-bottom">2pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="@type = 'indexsect'">
				<xsl:attribute name="space-before">16pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="@type = 'references'">
				<xsl:attribute name="space-before">5pt</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="margin-left">
				<xsl:choose>
					<xsl:when test="mnx:title/@variant-title = 'true'">0mm</xsl:when>
					<xsl:when test="@level = 2">8mm</xsl:when>
					<xsl:when test="@level &gt;= 3"><xsl:value-of select="(@level - 2) * 23"/>mm</xsl:when>
					<xsl:otherwise>0mm</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="provisional-distance-between-starts">
				<xsl:choose>
					<xsl:when test="@section = ''">0mm</xsl:when>
					<xsl:when test="@level = 1">8mm</xsl:when>
					<xsl:when test="@level = 2">15mm</xsl:when>
					<xsl:when test="@level &gt;= 3"><xsl:value-of select="(@level - 2) * 19"/>mm</xsl:when>
					<xsl:otherwise>0mm</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:if test="@level = 1">
				<xsl:attribute name="margin-top">5pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="@level = 3">
				<xsl:attribute name="margin-top">-0.7pt</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="$layoutVersion = '1987'">
				<xsl:if test="@type = 'section'">
					<xsl:attribute name="margin-top">12pt</xsl:attribute>
				</xsl:if>
				<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:if test="@level = 1">
				<xsl:attribute name="margin-top">6pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="@level &gt;= 2">
				<xsl:attribute name="margin-top">4pt</xsl:attribute>
				<!-- <xsl:attribute name="margin-left">12mm</xsl:attribute> -->
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-sp'">
			<xsl:if test="@level = 1">
				<xsl:attribute name="margin-top">6pt</xsl:attribute>
				<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="@level &gt;= 2 and @section != ''">
				<xsl:attribute name="margin-left"><xsl:value-of select="(@level - 1) * 22"/>mm</xsl:attribute>
			</xsl:if>
			<xsl:if test="@type = 'annex'">
				<xsl:attribute name="font-weight">bold</xsl:attribute>
			</xsl:if>
		</xsl:if>
	
		<xsl:if test="$namespace = 'ogc'">
			<xsl:if test="@level = 1">
				<xsl:attribute name="margin-top">14pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="@level = 1 or @parent = 'annex'">										
				<xsl:attribute name="font-size">12pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="@level &gt;= 2"> <!-- and not(@parent = 'annex') -->
				<xsl:attribute name="font-size">10pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:variable name="margin-left">3.9</xsl:variable>
			<xsl:attribute name="margin-left"><xsl:value-of select="(@level - 1) * $margin-left"/>mm</xsl:attribute>
		</xsl:if>
		
		<xsl:if test="$namespace = 'rsd'">
			<xsl:if test="@level = 1">
				<xsl:if test="preceding-sibling::mnx:item[@display = 'true' and @level = 1]">
					<xsl:attribute name="space-before">16pt</xsl:attribute>
				</xsl:if>
				<xsl:attribute name="space-after">4pt</xsl:attribute>
				<xsl:attribute name="font-weight">bold</xsl:attribute>
				<xsl:attribute name="keep-with-next">always</xsl:attribute>
				<xsl:attribute name="color">black</xsl:attribute>
			</xsl:if>
			<xsl:if test="@level &gt;= 2">
				<xsl:attribute name="margin-left"><xsl:value-of select="(@level - 1) * 16.5"/>mm</xsl:attribute>
				<xsl:attribute name="space-before">4pt</xsl:attribute>
				<xsl:attribute name="space-after">5pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template> <!-- END: refine_toc-item-style -->
	
	<xsl:attribute-set name="toc-leader-style">
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="leader-pattern">dots</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csd'">
			<xsl:attribute name="leader-pattern">dots</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="leader-pattern">dots</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="font-size">9pt</xsl:attribute>
			<xsl:attribute name="font-weight">normal</xsl:attribute>
			 <xsl:attribute name="leader-pattern">dots</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="font-size">9pt</xsl:attribute>
			<xsl:attribute name="font-weight">normal</xsl:attribute>
			<xsl:attribute name="leader-pattern">dots</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="font-size">9pt</xsl:attribute>
			<xsl:attribute name="font-weight">normal</xsl:attribute>
			<xsl:attribute name="leader-pattern">dots</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="leader-pattern">dots</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jcgm'">
			<xsl:attribute name="font-size">9pt</xsl:attribute>
			<xsl:attribute name="leader-pattern">dots</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:attribute name="leader-pattern">dots</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-sp'">
			<xsl:attribute name="leader-pattern">dots</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="leader-pattern">dots</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:attribute name="leader-pattern">dots</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'plateau'">
			<xsl:attribute name="leader-pattern">dots</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="leader-pattern">rule</xsl:attribute>
			<xsl:attribute name="rule-thickness">0.2mm</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- END: toc-leader-style -->
	
	<xsl:template name="refine_toc-leader-style">
	</xsl:template>
	
	<xsl:attribute-set name="toc-pagenumber-style">
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="font-family">Arial</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="font-size">10pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="padding-left">2mm</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:template name="refine_toc-pagenumber-style">
	</xsl:template>
	
	<!-- List of Figures, Tables -->
	<xsl:attribute-set name="toc-listof-title-style">
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="font-family">Arial</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="padding-top">14pt</xsl:attribute>
			<xsl:attribute name="padding-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="provisional-distance-between-starts">3mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csd'">
			<xsl:attribute name="role">TOCI</xsl:attribute>
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			 <xsl:attribute name="role">TOCI</xsl:attribute>
			 <xsl:attribute name="space-before">12pt</xsl:attribute>
			 <xsl:attribute name="keep-with-next">always</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="role">TOCI</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="role">TOCI</xsl:attribute>
			<xsl:attribute name="margin-top">5pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="space-before">36pt</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jcgm'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-sp'">
			<xsl:attribute name="font-size">12pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="margin-left">-18mm</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="margin-bottom">10pt</xsl:attribute>
			<xsl:attribute name="space-before">36pt</xsl:attribute>
			<xsl:attribute name="role">SKIP</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-size">13pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="color">black</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:template name="refine_toc-listof-title-style">
		<xsl:if test="$namespace = 'ieee'">
			<xsl:if test="$current_template = 'standard'">
				<xsl:attribute name="font-size">12pt</xsl:attribute>
				<xsl:attribute name="font-weight">bold</xsl:attribute>
				<xsl:attribute name="font-family">Arial</xsl:attribute>
				<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	
	<xsl:attribute-set name="toc-listof-item-block-style">
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="provisional-distance-between-starts">10mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csd'">
			<xsl:attribute name="provisional-distance-between-starts">8mm</xsl:attribute>
			<xsl:attribute name="role">SKIP</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:template name="refine_toc-listof-item-block-style">
	</xsl:template>
	
	<xsl:attribute-set name="toc-listof-item-style">
		<xsl:attribute name="role">TOCI</xsl:attribute>
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="font-size">10.5pt</xsl:attribute>
			<xsl:attribute name="margin-left">8mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="text-align-last">justify</xsl:attribute>
			<xsl:attribute name="margin-left">12mm</xsl:attribute>
			<xsl:attribute name="text-indent">-12mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csd'">
			<xsl:attribute name="text-align-last">justify</xsl:attribute>
			<xsl:attribute name="margin-left">12mm</xsl:attribute>
			<xsl:attribute name="text-indent">-12mm</xsl:attribute>
			<xsl:attribute name="role">SKIP</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="text-align-last">justify</xsl:attribute>
			<xsl:attribute name="margin-bottom">5pt</xsl:attribute>
			<xsl:attribute name="margin-left">8mm</xsl:attribute>
			<xsl:attribute name="text-indent">-8mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="provisional-distance-between-starts">22.5mm</xsl:attribute>
			<xsl:attribute name="font-weight">normal</xsl:attribute>
			<xsl:attribute name="role">TOCI</xsl:attribute>
			<xsl:attribute name="margin-left">2mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="text-align-last">justify</xsl:attribute>
			<xsl:attribute name="margin-left">12mm</xsl:attribute>
			<xsl:attribute name="text-indent">-12mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="font-weight">normal</xsl:attribute>
			<xsl:attribute name="text-align-last">justify</xsl:attribute>
			<xsl:attribute name="margin-left">12mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="text-align-last">justify</xsl:attribute>
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jcgm'">
			<xsl:attribute name="margin-left">17mm</xsl:attribute>
			<xsl:attribute name="text-indent">-12mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-sp'">
			<xsl:attribute name="text-align-last">justify</xsl:attribute>
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="text-align-last">justify</xsl:attribute>
			<xsl:attribute name="margin-top">2pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			 <xsl:attribute name="margin-top">8pt</xsl:attribute>
			 <xsl:attribute name="margin-bottom">5pt</xsl:attribute>
			 <xsl:attribute name="text-align-last">justify</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-size">13pt</xsl:attribute>
			<xsl:attribute name="margin-left">16.5mm</xsl:attribute>
			<xsl:attribute name="space-before">4pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:template name="refine_toc-listof-item-style">
	</xsl:template>
	
	<xsl:template name="processPrefaceSectionsDefault_Contents">
		<xsl:variable name="nodes_preface_">
			<xsl:for-each select="/*/mn:preface/*[not(self::mn:note or self::mn:admonition or @type = 'toc')]">
				<node id="{@id}"/>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="nodes_preface" select="xalan:nodeset($nodes_preface_)"/>
		
		<xsl:for-each select="/*/mn:preface/*[not(self::mn:note or self::mn:admonition or @type = 'toc')]">
			<xsl:sort select="@displayorder" data-type="number"/>
			
			<!-- process Section's title -->
			<xsl:variable name="preceding-sibling_id" select="$nodes_preface/node[@id = current()/@id]/preceding-sibling::node[1]/@id"/>
			<xsl:if test="$preceding-sibling_id != ''">
				<xsl:apply-templates select="parent::*/*[@type = 'section-title' and @id = $preceding-sibling_id and not(@displayorder)]" mode="contents_no_displayorder"/>
			</xsl:if>
			
			<xsl:apply-templates select="." mode="contents"/>
		</xsl:for-each>
	</xsl:template>
	
	
	<xsl:template name="processMainSectionsDefault_Contents">
	
		<xsl:variable name="nodes_sections_">
			<xsl:for-each select="/*/mn:sections/*">
				<node id="{@id}"/>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="nodes_sections" select="xalan:nodeset($nodes_sections_)"/>
		
		<xsl:for-each select="/*/mn:sections/* | /*/mn:bibliography/mn:references[@normative='true'] |
			/*/mn:bibliography/mn:clause[mn:references[@normative='true']]">
			<xsl:sort select="@displayorder" data-type="number"/>
			
			<!-- process Section's title -->
			<xsl:variable name="preceding-sibling_id" select="$nodes_sections/node[@id = current()/@id]/preceding-sibling::node[1]/@id"/>
			<xsl:if test="$preceding-sibling_id != ''">
				<xsl:apply-templates select="parent::*/*[@type = 'section-title' and @id = $preceding-sibling_id and not(@displayorder)]" mode="contents_no_displayorder"/>
			</xsl:if>
			
			<xsl:apply-templates select="." mode="contents"/>
		</xsl:for-each>
		
		<!-- <xsl:for-each select="/*/mn:annex">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:apply-templates select="." mode="contents"/>
		</xsl:for-each> -->
		
		<xsl:for-each select="/*/mn:annex | /*/mn:bibliography/*[not(@normative='true') and not(mn:references[@normative='true'])][count(.//mn:bibitem[not(@hidden) = 'true']) &gt; 0] | 
								/*/mn:bibliography/mn:clause[mn:references[not(@normative='true')]][count(.//mn:bibitem[not(@hidden) = 'true']) &gt; 0]">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:apply-templates select="." mode="contents"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="processTablesFigures_Contents">
		<xsl:param name="always"/>
		<xsl:if test="(//mn:metanorma/mn:metanorma-extension/mn:toc[@type='table']/mn:title) or normalize-space($always) = 'true'">
			<xsl:call-template name="processTables_Contents"/>
		</xsl:if>
		<xsl:if test="(//mn:metanorma/mn:metanorma-extension/mn:toc[@type='figure']/mn:title) or normalize-space($always) = 'true'">
			<xsl:call-template name="processFigures_Contents"/>
		</xsl:if>
	</xsl:template>

	<xsl:template name="processTables_Contents">
		<mnx:tables>
			<xsl:for-each select="//mn:table[not(ancestor::mn:metanorma-extension)][@id and mn:fmt-name and normalize-space(@id) != '']">
				<xsl:choose>
					<xsl:when test="mn:fmt-name">
						<xsl:variable name="fmt_name">
							<xsl:apply-templates select="mn:fmt-name" mode="update_xml_step1"/>
						</xsl:variable>
						<mnx:table id="{@id}" alt-text="{normalize-space($fmt_name)}">
							<xsl:copy-of select="$fmt_name"/>
						</mnx:table>
					</xsl:when>
					<xsl:otherwise>
						<mnx:table id="{@id}" alt-text="{mn:name}">
							<xsl:copy-of select="mn:name"/>
						</mnx:table>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</mnx:tables>
	</xsl:template>
	
	<xsl:template name="processFigures_Contents">
		<mnx:figures>
			<xsl:for-each select="//mn:figure[@id and mn:fmt-name and not(@unnumbered = 'true') and normalize-space(@id) != ''] | //*[@id and starts-with(mn:name, 'Figure ') and normalize-space(@id) != '']">
				<xsl:choose>
					<xsl:when test="mn:fmt-name">
						<xsl:variable name="fmt_name">
							<xsl:apply-templates select="mn:fmt-name" mode="update_xml_step1"/>
						</xsl:variable>
						<mnx:figure id="{@id}" alt-text="{normalize-space($fmt_name)}">
							<xsl:copy-of select="$fmt_name"/>
						</mnx:figure>
					</xsl:when>
					<xsl:otherwise>
						<mnx:figure id="{@id}" alt-text="{mn:name}">
							<xsl:copy-of select="mn:name"/>
						</mnx:figure>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</mnx:figures>
	</xsl:template>



	
	<xsl:template match="mn:figure/mn:name | mnx:figure/mn:name | 
														mn:table/mn:name | mnx:table/mn:name |
														mn:permission/mn:name | mnx:permission/mn:name |
														mn:recommendation/mn:name | mnx:recommendation/mn:name |
														mn:requirement/mn:name | mnx:requirement/mn:name" mode="contents">		
		<xsl:if test="not(following-sibling::*[1][self::mn:fmt-name])">
			<xsl:apply-templates mode="contents"/>
			<xsl:text> </xsl:text>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="mn:title[following-sibling::*[1][self::mn:fmt-title]]" mode="contents"/>
	
	<xsl:template match="mn:figure/mn:fmt-name | mnx:figure/mn:fmt-name |
														mn:table/mn:fmt-name | mnx:table/mn:fmt-name |
														mn:permission/mn:fmt-name | mnx:permission/mn:fmt-name |
														mn:recommendation/mn:fmt-name | mnx:recommendation/mn:fmt-name |
														mn:requirement/mn:fmt-name | mnx:requirement/mn:fmt-name" mode="contents">		
		<xsl:apply-templates mode="contents"/>
		<xsl:text> </xsl:text>
	</xsl:template>
	
	<xsl:template match="mn:figure/mn:name | mnx:figure/mn:name | 
														mn:table/mn:name | mnx:table/mn:name |
														mn:permission/mn:name | mnx:permission/mn:name |
														mn:recommendation/mn:name | mnx:recommendation/mn:name |
														mn:requirement/mn:name | mnx:requirement/mn:name |
														mn:sourcecode/mn:name" mode="bookmarks">
		<xsl:if test="not(following-sibling::*[1][self::mn:fmt-name])">
			<xsl:apply-templates mode="bookmarks"/>
			<xsl:text> </xsl:text>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="mn:figure/mn:fmt-name | mnx:figure/mn:fmt-name | 
														mn:table/mn:fmt-name | mnx:table/mn:fmt-name | 
														mn:permission/mn:fmt-name | mnx:permission/mn:fmt-name | 
														mn:recommendation/mn:fmt-name | mnx:recommendation/mn:fmt-name | 
														mn:requirement/mn:fmt-name | mnx:requirement/mn:fmt-name | 
														mn:sourcecode/mn:fmt-name | mnx:sourcecode/mn:fmt-name" mode="bookmarks">		
		<xsl:apply-templates mode="bookmarks"/>
		<xsl:text> </xsl:text>
	</xsl:template>
	
	<xsl:template match="*[self::mn:figure or self::mn:table or self::mn:permission or self::mn:recommendation or self::mn:requirement]/mn:name/text() |
			*[self::mnx:figure or self::mnx:table or self::mnx:permission or self::mnx:recommendation or self::mnx:requirement]/mn:name/text()" mode="contents" priority="2">
		<xsl:if test="not(../following-sibling::*[1][self::mn:fmt-name])">
			<xsl:value-of select="."/>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="*[self::mn:figure or self::mn:table or self::mn:permission or self::mn:recommendation or self::mn:requirement]/mn:fmt-name/text() |
		*[self::mnx:figure or self::mnx:table or self::mnx:permission or self::mnx:recommendation or self::mnx:requirement]/mn:fmt-name/text()" mode="contents" priority="2">
		<xsl:value-of select="."/>
	</xsl:template>
	
	<xsl:template match="*[self::mn:figure or self::mn:table or self::mn:permission or self::mn:recommendation or self::mn:requirement or self::mn:sourcecode]/mn:name//text() |
			*[self::mnx:figure or self::mnx:table or self::mnx:permission or self::mnx:recommendation or self::mnx:requirement or self::mnx:sourcecode]/mn:name//text()" mode="bookmarks" priority="2">
		<xsl:if test="not(../following-sibling::*[1][self::mn:fmt-name])">
			<xsl:value-of select="."/>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="*[self::mn:figure or self::mn:table or self::mn:permission or self::mn:recommendation or self::mn:requirement or self::mn:sourcecode]/mn:fmt-name//text() |
			*[self::mnx:figure or self::mnx:table or self::mnx:permission or self::mnx:recommendation or self::mnx:requirement or self::mnx:sourcecode]/mn:fmt-name//text()" mode="bookmarks" priority="2">
		<xsl:value-of select="."/>
	</xsl:template>
	
	<xsl:template match="mn:add/text()" mode="bookmarks" priority="3"> <!-- mn:add[starts-with(., $ace_tag)] -->
		<xsl:choose>
			<xsl:when test="starts-with(normalize-space(..), $ace_tag)"><!-- skip --></xsl:when>
			<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="node()" mode="contents">
		<xsl:apply-templates mode="contents"/>
	</xsl:template>

	<!-- special case: ignore preface/section-title and sections/section-title without @displayorder  -->
	<xsl:template match="*[self::mn:preface or self::mn:sections]/mn:p[@type = 'section-title' and not(@displayorder)]" priority="3" mode="contents"/>
	<!-- process them by demand (mode="contents_no_displayorder") -->
	<xsl:template match="mn:p[@type = 'section-title' and not(@displayorder)]" mode="contents_no_displayorder">
		<xsl:call-template name="contents_section-title"/>
	</xsl:template>
	<xsl:template match="mn:p[@type = 'section-title']" mode="contents_in_clause">
		<xsl:call-template name="contents_section-title"/>
	</xsl:template>
	
	<!-- special case: ignore section-title if @depth different than @depth of parent clause, or @depth of parent clause = 1 -->
	<xsl:template match="mn:clause/mn:p[@type = 'section-title' and (@depth != ../*[self::mn:title or self::mn:fmt-title]/@depth or ../*[self::mn:title or self::mn:fmt-title]/@depth = 1)]" priority="3" mode="contents"/>
	
	<xsl:template match="mn:p[@type = 'floating-title' or @type = 'section-title']" priority="2" name="contents_section-title" mode="contents">
		<xsl:variable name="level">
			<xsl:call-template name="getLevel">
				<xsl:with-param name="depth" select="@depth"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="section">
			<xsl:choose>
				<xsl:when test="@type = 'section-title'"></xsl:when>
				<xsl:when test="mn:span[@class = 'fmt-caption-delim']">
					<xsl:value-of select="mn:span[@class = 'fmt-caption-delim'][1]/preceding-sibling::node()"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="mn:tab[1]/preceding-sibling::node()"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="type"><xsl:value-of select="@type"/></xsl:variable>
			
		<xsl:variable name="display">
			<xsl:choose>
				<xsl:when test="normalize-space(@id) = ''">false</xsl:when>
				<xsl:when test="$level &lt;= $toc_level">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="skip">false</xsl:variable>

		<xsl:if test="$skip = 'false'">		
		
			<xsl:variable name="title">
				<xsl:choose>
					<!-- https://github.com/metanorma/mn-native-pdf/issues/770 -->
					<xsl:when test="mn:span[@class = 'fmt-caption-delim']">
						<xsl:choose>
							<xsl:when test="@type = 'section-title'">
								<xsl:value-of select="mn:span[@class = 'fmt-caption-delim'][1]/preceding-sibling::node()"/>
								<xsl:text>: </xsl:text>
								<xsl:copy-of select="mn:span[@class = 'fmt-caption-delim'][1]/following-sibling::node()[not(self::mn:fmt-xref-label)]"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:copy-of select="mn:span[@class = 'fmt-caption-delim'][1]/following-sibling::node()[not(self::mn:fmt-xref-label)]"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="mn:tab">
						<xsl:choose>
							<xsl:when test="@type = 'section-title'">
								<xsl:value-of select="mn:tab[1]/preceding-sibling::node()"/>
								<xsl:text>: </xsl:text>
								<xsl:copy-of select="mn:tab[1]/following-sibling::node()"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:copy-of select="mn:tab[1]/following-sibling::node()"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select="node()"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<xsl:variable name="root">
				<xsl:if test="ancestor-or-self::mn:preface">preface</xsl:if>
				<xsl:if test="ancestor-or-self::mn:annex">annex</xsl:if>
			</xsl:variable>
			
			<mnx:item id="{@id}" level="{$level}" section="{$section}" type="{$type}" root="{$root}" display="{$display}">
				<mnx:title>
					<xsl:apply-templates select="xalan:nodeset($title)" mode="contents_item"/>
				</mnx:title>
			</mnx:item>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="node()" mode="bookmarks">
		<xsl:apply-templates mode="bookmarks"/>
	</xsl:template>
	
	<xsl:template match="mn:stem" mode="contents"/>
	
	<xsl:template match="*[self::mn:title or self::mn:name or self::mn:fmt-title or self::mn:fmt-name]//mn:fmt-stem" mode="contents">
		<xsl:apply-templates select="."/>
	</xsl:template>
	
	<!-- prevent missing stem for table and figures in ToC -->
	<xsl:template match="*[self::mn:name or self::mn:fmt-name]//mn:stem" mode="contents">
		<xsl:if test="not(following-sibling::*[1][self::mn:fmt-stem])">
			<xsl:apply-templates select="."/>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="mn:references[@hidden='true']" mode="contents" priority="3"/>
	
	<xsl:template match="mn:references/mn:bibitem" mode="contents"/>
	
	<!-- Note: to enable the addition of character span markup with semantic styling for DIS Word output -->
	<xsl:template match="mn:span" mode="contents">
		<xsl:apply-templates mode="contents"/>
	</xsl:template>
	
	<xsl:template match="mn:semx" mode="contents">
		<xsl:apply-templates mode="contents"/>
	</xsl:template>
	
	<xsl:template match="mn:concept" mode="contents"/>
	<xsl:template match="mn:eref" mode="contents"/>
	<xsl:template match="mn:xref" mode="contents"/>
	<xsl:template match="mn:link" mode="contents"/>
	<xsl:template match="mn:origin" mode="contents"/>
	<xsl:template match="mn:erefstack" mode="contents"/>
	
	<xsl:template match="mn:requirement |
												mn:recommendation | 
												mn:permission" mode="contents" priority="3"/>
	
	<xsl:template match="mn:stem" mode="bookmarks"/>
	<xsl:template match="mn:fmt-stem" mode="bookmarks">
		<xsl:apply-templates mode="bookmarks"/>
	</xsl:template>
	
	<!-- Note: to enable the addition of character span markup with semantic styling for DIS Word output -->
	<xsl:template match="mn:span" mode="bookmarks">
		<xsl:apply-templates mode="bookmarks"/>
	</xsl:template>
	
	<xsl:template match="mn:semx" mode="bookmarks">
		<xsl:apply-templates mode="bookmarks"/>
	</xsl:template>
	
	<xsl:template match="mn:concept" mode="bookmarks"/>
	<xsl:template match="mn:eref" mode="bookmarks"/>
	<xsl:template match="mn:xref" mode="bookmarks"/>
	<xsl:template match="mn:link" mode="bookmarks"/>
	<xsl:template match="mn:origin" mode="bookmarks"/>
	<xsl:template match="mn:erefstack" mode="bookmarks"/>
	
	<xsl:template match="mn:requirement |
												mn:recommendation | 
												mn:permission" mode="bookmarks" priority="3"/>
	
	<!-- Bookmarks -->
	<xsl:template name="addBookmarks">
		<xsl:param name="contents"/>
		<xsl:param name="contents_addon"/>
		<xsl:variable name="contents_nodes" select="xalan:nodeset($contents)"/>
		<xsl:if test="$contents_nodes//mnx:item">
			<fo:bookmark-tree>
				<xsl:choose>
					<xsl:when test="$contents_nodes/mnx:doc">
						<xsl:choose>
							<xsl:when test="count($contents_nodes/mnx:doc) &gt; 1">
								
								<xsl:if test="$contents_nodes/collection">
									<fo:bookmark internal-destination="{$contents/collection/@firstpage_id}">
										<fo:bookmark-title>collection.pdf</fo:bookmark-title>
									</fo:bookmark>
								</xsl:if>
							
								<xsl:for-each select="$contents_nodes/mnx:doc">
									<fo:bookmark internal-destination="{mnx:contents/mnx:item[@display = 'true'][1]/@id}" starting-state="hide">
										<xsl:if test="@bundle = 'true'">
											<xsl:attribute name="internal-destination"><xsl:value-of select="@firstpage_id"/></xsl:attribute>
										</xsl:if>
										<fo:bookmark-title>
											<xsl:choose>
												<xsl:when test="not(normalize-space(@bundle) = 'true')"> <!-- 'bundle' means several different documents (not language versions) in one xml -->
													<xsl:variable name="bookmark-title_">
														<xsl:call-template name="getLangVersion">
															<xsl:with-param name="lang" select="@lang"/>
															<xsl:with-param name="doctype" select="@doctype"/>
															<xsl:with-param name="title" select="@title-part"/>
														</xsl:call-template>
													</xsl:variable>
													<xsl:choose>
														<xsl:when test="normalize-space($bookmark-title_) != ''">
															<xsl:value-of select="normalize-space($bookmark-title_)"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:choose>
																<xsl:when test="@lang = 'en'">English</xsl:when>
																<xsl:when test="@lang = 'fr'">Français</xsl:when>
																<xsl:when test="@lang = 'de'">Deutsche</xsl:when>
																<xsl:otherwise><xsl:value-of select="@lang"/> version</xsl:otherwise>
															</xsl:choose>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="@title-part"/>
												</xsl:otherwise>
											</xsl:choose>
										</fo:bookmark-title>
										
										<xsl:apply-templates select="mnx:contents/mnx:item" mode="bookmark"/>
										
										<xsl:call-template name="insertFigureBookmarks">
											<xsl:with-param name="contents" select="mnx:contents"/>
										</xsl:call-template>
										
										<xsl:call-template name="insertTableBookmarks">
											<xsl:with-param name="contents" select="mnx:contents"/>
											<xsl:with-param name="lang" select="@lang"/>
										</xsl:call-template>
										
									</fo:bookmark>
									
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<xsl:for-each select="$contents_nodes/mnx:doc">
								
									<xsl:apply-templates select="mnx:contents/mnx:item" mode="bookmark"/>
									
									<xsl:call-template name="insertFigureBookmarks">
										<xsl:with-param name="contents" select="mnx:contents"/>
									</xsl:call-template>
										
									<xsl:call-template name="insertTableBookmarks">
										<xsl:with-param name="contents" select="mnx:contents"/>
										<xsl:with-param name="lang" select="@lang"/>
									</xsl:call-template>
									
								</xsl:for-each>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="$contents_nodes/mnx:contents/mnx:item" mode="bookmark"/>				
						
						<xsl:call-template name="insertFigureBookmarks">
							<xsl:with-param name="contents" select="$contents_nodes/mnx:contents"/>
						</xsl:call-template>
							
						<xsl:call-template name="insertTableBookmarks">
							<xsl:with-param name="contents" select="$contents_nodes/mnx:contents"/>
							<xsl:with-param name="lang" select="@lang"/>
						</xsl:call-template>
						
					</xsl:otherwise>
				</xsl:choose>
				
				<!-- for $namespace = 'nist-sp' $namespace = 'ogc' $namespace = 'ogc-white-paper' -->
				<xsl:copy-of select="$contents_addon"/>
				
			</fo:bookmark-tree>
		</xsl:if>
	</xsl:template>
	
	
	<xsl:template name="insertFigureBookmarks">
		<xsl:param name="contents"/>
		<xsl:variable name="contents_nodes" select="xalan:nodeset($contents)"/>
		<xsl:if test="$contents_nodes/mnx:figure">
			<fo:bookmark internal-destination="{$contents_nodes/mnx:figure[1]/@id}" starting-state="hide">
				<fo:bookmark-title>Figures</fo:bookmark-title>
				<xsl:for-each select="$contents_nodes/mnx:figure">
					<fo:bookmark internal-destination="{@id}">
						<fo:bookmark-title>
							<xsl:value-of select="normalize-space(mnx:title)"/>
						</fo:bookmark-title>
					</fo:bookmark>
				</xsl:for-each>
			</fo:bookmark>	
		</xsl:if>
		
		<xsl:choose>
			<xsl:when test="$namespace = 'nist-sp' or $namespace = 'ogc' or $namespace = 'ogc-white-paper'"><!-- see template addBookmarks --></xsl:when>
			<xsl:otherwise>
				<xsl:if test="$contents_nodes//mnx:figures/mnx:figure">
					<fo:bookmark internal-destination="empty_bookmark" starting-state="hide">
					
						<xsl:if test="$namespace = 'iec'">
							<xsl:attribute name="internal-destination">
								<xsl:value-of select="$contents_nodes//mnx:figures/mnx:figure[1]/@id"/>
							</xsl:attribute>
						</xsl:if>
						
						<xsl:variable name="bookmark-title">
							<xsl:choose>
								<xsl:when test="$namespace = 'iec'">Figures</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$title-list-figures"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<fo:bookmark-title><xsl:value-of select="normalize-space($bookmark-title)"/></fo:bookmark-title>
						<xsl:for-each select="$contents_nodes//mnx:figures/mnx:figure">
							<fo:bookmark internal-destination="{@id}">
								<fo:bookmark-title><xsl:value-of select="normalize-space(.)"/></fo:bookmark-title>
							</fo:bookmark>
						</xsl:for-each>
					</fo:bookmark>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- insertFigureBookmarks -->
	
	<xsl:template name="insertTableBookmarks">
		<xsl:param name="contents"/>
		<xsl:param name="lang"/>
		<xsl:variable name="contents_nodes" select="xalan:nodeset($contents)"/>
		<xsl:if test="$contents_nodes/mnx:table">
			<fo:bookmark internal-destination="{$contents_nodes/mnx:table[1]/@id}" starting-state="hide">
				<fo:bookmark-title>
					<xsl:choose>
						<xsl:when test="$lang = 'fr'">Tableaux</xsl:when>
						<xsl:otherwise>Tables</xsl:otherwise>
					</xsl:choose>
				</fo:bookmark-title>
				<xsl:for-each select="$contents_nodes/mnx:table">
					<fo:bookmark internal-destination="{@id}">
						<fo:bookmark-title>
							<xsl:value-of select="normalize-space(mnx:title)"/>
						</fo:bookmark-title>
					</fo:bookmark>
				</xsl:for-each>
			</fo:bookmark>	
		</xsl:if>
		
		<xsl:choose>
			<xsl:when test="$namespace = 'nist-sp' or $namespace = 'ogc' or $namespace = 'ogc-white-paper'"><!-- see template addBookmarks --></xsl:when>
			<xsl:otherwise>
				<xsl:if test="$contents_nodes//mnx:tables/mnx:table">
					<fo:bookmark internal-destination="empty_bookmark" starting-state="hide">
						
						<xsl:if test="$namespace = 'iec'">
							<xsl:attribute name="internal-destination">
								<xsl:value-of select="$contents_nodes//mnx:tables/mnx:table[1]/@id"/>
							</xsl:attribute>
						</xsl:if>
						
						<xsl:variable name="bookmark-title">
							<xsl:choose>
								<xsl:when test="$namespace = 'iec'">
									<xsl:choose>
										<xsl:when test="$lang = 'fr'">Tableaux</xsl:when>
										<xsl:otherwise>Tables</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$title-list-tables"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						
						<fo:bookmark-title><xsl:value-of select="$bookmark-title"/></fo:bookmark-title>
						
						<xsl:for-each select="$contents_nodes//mnx:tables/mnx:table">
							<fo:bookmark internal-destination="{@id}">
								<!-- <fo:bookmark-title><xsl:value-of select="normalize-space(.)"/></fo:bookmark-title> -->
								<fo:bookmark-title><xsl:apply-templates mode="bookmark_clean"/></fo:bookmark-title>
							</fo:bookmark>
						</xsl:for-each>
					</fo:bookmark>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- insertTableBookmarks -->
	<!-- End Bookmarks -->
	
	<!-- ============================ -->
	<!-- mode="bookmark_clean" -->
	<!-- ============================ -->
	<xsl:template match="node()" mode="bookmark_clean">
		<xsl:apply-templates select="node()" mode="bookmark_clean"/>
	</xsl:template>
	
	<xsl:template match="text()" mode="bookmark_clean">
		<xsl:value-of select="."/>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'math']" mode="bookmark_clean">
		<xsl:value-of select="normalize-space(.)"/>
	</xsl:template>
	
	<xsl:template match="mn:asciimath" mode="bookmark_clean"/>
	<!-- ============================ -->
	<!-- END: mode="bookmark_clean" -->
	<!-- ============================ -->
	

	<xsl:template name="getLangVersion">
		<xsl:param name="lang"/>
		<xsl:param name="doctype" select="''"/>
		<xsl:param name="title" select="''"/>
		<xsl:choose>
			<xsl:when test="$lang = 'en'">
				<xsl:if test="$namespace = 'iec'">English</xsl:if>
				<xsl:if test="$namespace = 'bipm'">
					<xsl:choose>
						<xsl:when test="$doctype = 'guide'">
							<xsl:value-of select="$title"/>
						</xsl:when>
						<xsl:otherwise>English version</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
				</xsl:when>
			<xsl:when test="$lang = 'fr'">
				<xsl:if test="$namespace = 'iec'">Français</xsl:if>
				<xsl:if test="$namespace = 'bipm'">
					<xsl:choose>
						<xsl:when test="$doctype = 'guide'">
							<xsl:value-of select="$title"/>
						</xsl:when>
						<xsl:otherwise>Version française</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</xsl:when>
			<xsl:when test="$lang = 'de'">Deutsche</xsl:when>
			<xsl:otherwise><xsl:value-of select="$lang"/> version</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="mnx:item" mode="bookmark">
		<xsl:choose>
			<xsl:when test="@id != ''">
				<fo:bookmark internal-destination="{@id}" starting-state="hide">
					<fo:bookmark-title>
						<xsl:if test="@section != ''">
							<xsl:value-of select="@section"/> 
							<xsl:text> </xsl:text>
						</xsl:if>
						<xsl:variable name="title">
							<xsl:for-each select="mnx:title/node()">
								<xsl:choose>
									<xsl:when test="local-name() = 'add' and starts-with(., $ace_tag)"><!-- skip --></xsl:when>
									<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
						</xsl:variable>
						<xsl:value-of select="normalize-space($title)"/>
					</fo:bookmark-title>
					<xsl:apply-templates mode="bookmark"/>
				</fo:bookmark>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates mode="bookmark"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>	
	
	<xsl:template match="mnx:title" mode="bookmark"/>	
	<xsl:template match="text()" mode="bookmark"/>
	

	<!-- ====== -->
	<!-- ====== -->
	<xsl:template match="mn:title" mode="contents_item">
		<xsl:param name="mode">bookmarks</xsl:param>
		<xsl:if test="not(following-sibling::*[1][self::mn:fmt-title])">
			<xsl:apply-templates mode="contents_item">
				<xsl:with-param name="mode" select="$mode"/>
			</xsl:apply-templates>
			<!-- <xsl:text> </xsl:text> -->
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="mn:fmt-title" mode="contents_item">
		<xsl:param name="mode">bookmarks</xsl:param>
		<xsl:apply-templates mode="contents_item">
			<xsl:with-param name="mode" select="$mode"/>
		</xsl:apply-templates>
		<!-- <xsl:text> </xsl:text> -->
	</xsl:template>
	
	<xsl:template match="mn:span[
															@class = 'fmt-caption-label' or 
															@class = 'fmt-element-name' or
															@class = 'fmt-caption-delim']" mode="contents_item" priority="3">
		<xsl:apply-templates mode="contents_item"/>
	</xsl:template>
	
	<xsl:template match="mn:semx" mode="contents_item">
		<xsl:apply-templates mode="contents_item"/>
	</xsl:template>
	
	
	<xsl:template match="mn:fmt-xref-label"  mode="contents_item"/>
	
	<xsl:template match="mn:concept"  mode="contents_item"/>
	<xsl:template match="mn:eref" mode="contents_item"/>
	<xsl:template match="mn:xref" mode="contents_item"/>
	<xsl:template match="mn:link" mode="contents_item"/>
	<xsl:template match="mn:origin" mode="contents_item"/>
	<xsl:template match="mn:erefstack" mode="contents_item"/>

	<!-- fn -->
	<xsl:template match="mn:fn" mode="contents"/>
	<xsl:template match="mn:fn" mode="bookmarks"/>
	
	<xsl:template match="mn:fn" mode="contents_item"/>

	<xsl:template match="mn:xref | mn:eref" mode="contents">
		<xsl:value-of select="."/>
	</xsl:template>

	
	<xsl:template match="mn:annotation" mode="contents_item"/>

	<xsl:template match="mn:tab" mode="contents_item">
		<xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="mn:strong" mode="contents_item">
		<xsl:param name="element"/>
		<xsl:copy>
			<xsl:apply-templates mode="contents_item">
				<xsl:with-param name="element" select="$element"/>
			</xsl:apply-templates>
		</xsl:copy>		
	</xsl:template>
	
	<xsl:template match="mn:em" mode="contents_item">
		<xsl:copy>
			<xsl:apply-templates mode="contents_item"/>
		</xsl:copy>		
	</xsl:template>
	
	<xsl:template match="mn:sub" mode="contents_item">
		<xsl:copy>
			<xsl:apply-templates mode="contents_item"/>
		</xsl:copy>		
	</xsl:template>
	
	<xsl:template match="mn:sup" mode="contents_item">
		<xsl:copy>
			<xsl:apply-templates mode="contents_item"/>
		</xsl:copy>		
	</xsl:template>
	
	<xsl:template match="mn:stem" mode="contents_item"/>
	<xsl:template match="mn:fmt-stem" mode="contents_item">
		<xsl:copy-of select="." />
	</xsl:template>

	<xsl:template match="mn:br" mode="contents_item">
		<xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="mn:name" mode="contents_item">
		<xsl:param name="mode">bookmarks</xsl:param>
		<xsl:if test="not(following-sibling::*[1][self::mn:fmt-name])">
			<xsl:apply-templates mode="contents_item">
				<xsl:with-param name="mode" select="$mode"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="mn:fmt-name" mode="contents_item">
		<xsl:param name="mode">bookmarks</xsl:param>
		<xsl:apply-templates mode="contents_item">
			<xsl:with-param name="mode" select="$mode"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="mn:add" mode="contents_item">
		<xsl:param name="mode">bookmarks</xsl:param>
		<xsl:choose>
			<xsl:when test="starts-with(text(), $ace_tag)">
				<xsl:if test="$mode = 'contents'">
					<xsl:copy>
						<xsl:apply-templates mode="contents_item"/>
					</xsl:copy>		
				</xsl:if>
			</xsl:when>
			<xsl:otherwise><xsl:apply-templates mode="contents_item"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="text()" mode="contents_item">
		<xsl:variable name="text">
			<!-- to split by '_' and other chars -->
			<mnx:text><xsl:call-template name="add-zero-spaces-java"/></mnx:text>
		</xsl:variable>
		<xsl:for-each select="xalan:nodeset($text)/mnx:text/text()">
			<xsl:call-template name="keep_together_standard_number"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="mn:add/text()" mode="contents_item" priority="2"> <!-- mn:add[starts-with(., $ace_tag)]/text() -->
		<xsl:if test="starts-with(normalize-space(..), $ace_tag)"><xsl:value-of select="."/></xsl:if>
	</xsl:template>

	<!-- Note: to enable the addition of character span markup with semantic styling for DIS Word output -->
	<xsl:template match="mn:span" mode="contents_item">
		<xsl:param name="element"/>
		<xsl:apply-templates mode="contents_item">
			<xsl:with-param name="element" select="$element"/>
		</xsl:apply-templates>
	</xsl:template>


	<!-- =================== -->
	<!-- Table of Contents (ToC) processing -->
	<!-- =================== -->
	
	<xsl:variable name="toc_level">
		<!-- https://www.metanorma.org/author/ref/document-attributes/ -->
		<xsl:variable name="pdftoclevels" select="normalize-space(//mn:metanorma-extension/mn:presentation-metadata[mn:name/text() = 'PDF TOC Heading Levels']/mn:value)"/> <!-- :toclevels-pdf  Number of table of contents levels to render in PDF output; used to override :toclevels:-->
		<xsl:variable name="toclevels" select="normalize-space(//mn:metanorma-extension/mn:presentation-metadata[mn:name/text() = 'TOC Heading Levels']/mn:value)"/> <!-- Number of table of contents levels to render -->
		<xsl:choose>
			<xsl:when test="$pdftoclevels != ''"><xsl:value-of select="number($pdftoclevels)"/></xsl:when> <!-- if there is value in xml -->
			<xsl:when test="$toclevels != ''"><xsl:value-of select="number($toclevels)"/></xsl:when>  <!-- if there is value in xml -->
			<xsl:otherwise><!-- default value -->
				<xsl:choose>
					<xsl:when test="$namespace = 'bipm' or $namespace = 'iec' or $namespace = 'iso' or $namespace = 'jcgm' or $namespace = 'm3d' or $namespace = 'nist-cswp' or 
					$namespace = 'ogc-white-paper' or $namespace = 'unece' or $namespace = 'unece-rec'">3</xsl:when>
					<xsl:when test="$namespace = 'ieee'">
						<xsl:choose>
							<xsl:when test="$current_template = 'whitepaper' or $current_template = 'icap-whitepaper' or $current_template = 'industry-connection-report'">3</xsl:when>
							<xsl:otherwise>2</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>2</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:template match="mn:toc">
		<xsl:param name="colwidths"/>
		<xsl:variable name="colwidths_">
			<xsl:choose>
				<xsl:when test="not($colwidths)">
					<xsl:variable name="toc_table_simple">
						<mn:tbody>
							<xsl:apply-templates mode="toc_table_width" />
						</mn:tbody>
					</xsl:variable>
					<!-- <debug_toc_table_simple><xsl:copy-of select="$toc_table_simple"/></debug_toc_table_simple> -->
					<xsl:variable name="cols-count" select="count(xalan:nodeset($toc_table_simple)/*/mn:tr[1]/mn:td)"/>
					<xsl:call-template name="calculate-column-widths-proportional">
						<xsl:with-param name="cols-count" select="$cols-count"/>
						<xsl:with-param name="table" select="$toc_table_simple"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="$colwidths"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!-- <debug_colwidth><xsl:copy-of select="$colwidths_"/></debug_colwidth> -->
		<fo:block role="TOCI" space-after="16pt">
			<fo:table width="100%" table-layout="fixed">
				<xsl:for-each select="xalan:nodeset($colwidths_)/column">
					<fo:table-column column-width="proportional-column-width({.})"/>
				</xsl:for-each>
				<fo:table-body>
					<xsl:apply-templates />
				</fo:table-body>
			</fo:table>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:toc//mn:li" priority="2">
		<fo:table-row min-height="5mm">
			<xsl:apply-templates />
		</fo:table-row>
	</xsl:template>
	
	<xsl:template match="mn:toc//mn:li/mn:p">
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="mn:toc//mn:xref | mn:toc//mn:fmt-xref" priority="3">
		<!-- <xref target="cgpm9th1948r6">1.6.3<tab/>&#8220;9th CGPM, 1948:<tab/>decision to establish the SI&#8221;</xref> -->
		<!-- New format: one tab <xref target="cgpm9th1948r6">&#8220;9th CGPM, 1948:<tab/>decision to establish the SI&#8221;</xref> -->
		<!-- <test><xsl:copy-of select="."/></test> -->
		
		<xsl:variable name="target" select="@target"/>
		
		<xsl:for-each select="mn:tab">
		
			<xsl:if test="position() = 1">
				<!-- first column (data before first `tab`) -->
				<fo:table-cell>
					<fo:block line-height-shift-adjustment="disregard-shifts" role="SKIP">
						<xsl:call-template name="insert_basic_link">
							<xsl:with-param name="element">
								<fo:basic-link internal-destination="{$target}" fox:alt-text="{.}">
									<xsl:for-each select="preceding-sibling::node()">
										<xsl:choose>
											<xsl:when test="self::text()"><xsl:value-of select="."/></xsl:when>
											<xsl:otherwise><xsl:apply-templates select="."/></xsl:otherwise>
										</xsl:choose>
									</xsl:for-each>
								</fo:basic-link>
							</xsl:with-param>
						</xsl:call-template>
					</fo:block>
				</fo:table-cell>
			</xsl:if>
		
			<xsl:variable name="current_id" select="generate-id()"/>
			<fo:table-cell>
				<fo:block line-height-shift-adjustment="disregard-shifts" role="SKIP">
					<xsl:call-template name="insert_basic_link">
						<xsl:with-param name="element">
							<fo:basic-link internal-destination="{$target}" fox:alt-text="{.}">
								<xsl:for-each select="following-sibling::node()[not(self::mn:tab) and preceding-sibling::mn:tab[1][generate-id() = $current_id]]">
									<xsl:choose>
										<xsl:when test="self::text()"><xsl:value-of select="."/></xsl:when>
										<xsl:otherwise><xsl:apply-templates select="."/></xsl:otherwise>
									</xsl:choose>
								</xsl:for-each>
							</fo:basic-link>
						</xsl:with-param>
					</xsl:call-template>
				</fo:block>
			</fo:table-cell>
		</xsl:for-each>
		<!-- last column - for page numbers -->
		<fo:table-cell text-align="right" font-size="10pt" font-weight="bold" font-family="Arial">
			<fo:block role="SKIP">
				<xsl:call-template name="insert_basic_link">
					<xsl:with-param name="element">
						<fo:basic-link internal-destination="{$target}" fox:alt-text="{.}">
							<fo:page-number-citation ref-id="{$target}"/>
						</fo:basic-link>
					</xsl:with-param>
				</xsl:call-template>
			</fo:block>
		</fo:table-cell>
	</xsl:template>
	
	<!-- ================================== -->
	<!-- calculate ToC table columns widths -->
	<!-- ================================== -->
	<xsl:template match="*" mode="toc_table_width">
		<xsl:apply-templates mode="toc_table_width" />
	</xsl:template>

	<xsl:template match="mn:clause[@type = 'toc']/mn:fmt-title" mode="toc_table_width"/>
	<xsl:template match="mn:clause[not(@type = 'toc')]/mn:fmt-title" mode="toc_table_width" />
	
	<xsl:template match="mn:li" mode="toc_table_width">
		<mn:tr>
			<xsl:apply-templates mode="toc_table_width"/>
		</mn:tr>
	</xsl:template>
	
	<xsl:template match="mn:fmt-xref" mode="toc_table_width">
		<!-- <xref target="cgpm9th1948r6">1.6.3<tab/>&#8220;9th CGPM, 1948:<tab/>decision to establish the SI&#8221;</xref> -->
		<!-- New format - one tab <xref target="cgpm9th1948r6">&#8220;9th CGPM, 1948:<tab/>decision to establish the SI&#8221;</xref> -->
		<xsl:for-each select="mn:tab">
			<xsl:if test="position() = 1">
				<mn:td>
					<xsl:for-each select="preceding-sibling::node()">
						<xsl:choose>
							<xsl:when test="self::text()"><xsl:value-of select="."/></xsl:when>
							<xsl:otherwise><xsl:copy-of select="."/></xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</mn:td>
			</xsl:if>
			<xsl:variable name="current_id" select="generate-id()"/>
			<mn:td>
				<xsl:for-each select="following-sibling::node()[not(self::mn:tab) and preceding-sibling::mn:tab[1][generate-id() = $current_id]]">
					<xsl:choose>
						<xsl:when test="self::text()"><xsl:value-of select="."/></xsl:when>
						<xsl:otherwise><xsl:copy-of select="."/></xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</mn:td>
		</xsl:for-each>
		<mn:td>333</mn:td> <!-- page number, just for fill -->
	</xsl:template>
	
	<!-- ================================== -->
	<!-- END: calculate ToC table columns widths -->
	<!-- ================================== -->
	
	<!-- =================== -->
	<!-- End Table of Contents (ToC) processing -->
	<!-- =================== -->

</xsl:stylesheet>