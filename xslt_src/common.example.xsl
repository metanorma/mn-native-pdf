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
	
	<xsl:attribute-set name="termexample-style">
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="margin-top">14pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">10pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa' or $namespace = 'csd' or $namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="font-size">9pt</xsl:attribute>
			<xsl:attribute name="margin-top">14pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">14pt</xsl:attribute>
			<xsl:attribute name="text-align">justify</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="margin-top">8pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
			<xsl:attribute name="text-align">justify</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho' or $namespace = 'iso' or $namespace = 'jcgm'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-top">8pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
			<xsl:attribute name="text-align">justify</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jis' or $namespace = 'plateau'">
			<xsl:attribute name="margin-top">4pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">4pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'm3d'">			
			<xsl:attribute name="margin-top">14pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">14pt</xsl:attribute>
			<xsl:attribute name="text-align">justify</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- termexample-style -->

	<xsl:template name="refine_termexample-style">
		<xsl:if test="$namespace = 'iso'">
			<xsl:if test="$layoutVersion = '1972' or $layoutVersion = '1979' or $layoutVersion = '1987' or $layoutVersion = '1989'">
				<xsl:attribute name="font-size">9pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template> <!-- refine_termexample-style -->
	
	<xsl:attribute-set name="termexample-name-style">
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="font-style">italic</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa' or $namespace = 'csd' or $namespace = 'iec' or $namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="padding-right">10mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="padding-right">1mm</xsl:attribute>
			<xsl:attribute name="font-family">SimHei</xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'bsi' or $namespace = 'iho' or $namespace = 'iso' or $namespace = 'jcgm'">
			<xsl:attribute name="padding-right">5mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="padding-right">9mm</xsl:attribute>
			<xsl:attribute name="font-style">italic</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
		</xsl:if>
		<xsl:if test="$namespace = 'm3d'">
			<xsl:attribute name="padding-right">1mm</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>			
		</xsl:if>		
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="color"><xsl:value-of select="$color_blue"/></xsl:attribute>
			<xsl:attribute name="padding-right">0.5mm</xsl:attribute>
		</xsl:if>		
	</xsl:attribute-set> <!-- termexample-name-style -->

	<xsl:template name="refine_termexample-name-style">
		<xsl:if test="$namespace = 'iso'">
			<xsl:if test="$layoutVersion = '2024' and translate(.,'0123456789','') = ."> <!-- EXAMPLE without number -->
				<xsl:attribute name="padding-right">8mm</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:if test="not($vertical_layout = 'true')">
				<xsl:attribute name="font-family">IPAexGothic</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	
	<xsl:attribute-set name="example-style">
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'csd'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="margin-top">8pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
			<xsl:attribute name="text-align">justify</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb' or $namespace = 'iso' or $namespace = 'jcgm'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-top">8pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="space-before">8pt</xsl:attribute>
			<xsl:attribute name="space-after">8pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<!-- <xsl:attribute name="font-size">11pt</xsl:attribute> -->
			<xsl:attribute name="margin-top">4pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="text-align">justify</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'jis' or $namespace = 'plateau'">
			<xsl:attribute name="margin-top">4pt</xsl:attribute>			
			<xsl:attribute name="margin-bottom">4pt</xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'm3d'">
			<xsl:attribute name="margin-top">8pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">			
			<xsl:attribute name="margin-top">10pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">10pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>			
			<xsl:attribute name="margin-left">12.5mm</xsl:attribute>
			<xsl:attribute name="margin-right">12.5mm</xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="margin-left">15mm</xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'nist-sp'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="margin-left">12.5mm</xsl:attribute>			
			<xsl:attribute name="margin-right">12.5mm</xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="margin-top">12pt</xsl:attribute>			
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>			
		</xsl:if>
	</xsl:attribute-set> <!-- example-style -->

	<xsl:template name="refine_example-style">
		<xsl:if test="$namespace = 'iso'">
			<xsl:if test="$layoutVersion = '1972' or $layoutVersion = '1979' or $layoutVersion = '1987' or $layoutVersion = '1989'">
				<xsl:attribute name="font-size">9pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:if test="ancestor::mn:ul or ancestor::mn:ol">
				<xsl:attribute name="margin-top">6pt</xsl:attribute>
				<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template> <!-- refine_example-style -->

	<xsl:attribute-set name="example-body-style">
		<xsl:if test="$namespace = 'csa'">			
			<xsl:attribute name="margin-left">12.5mm</xsl:attribute>
			<xsl:attribute name="margin-right">12.5mm</xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'csd'">
			<xsl:attribute name="margin-left">12.5mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="margin-left">10mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">			
			<xsl:attribute name="margin-left">7mm</xsl:attribute>
			<xsl:attribute name="margin-right">7mm</xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'mpfd'">
			<xsl:attribute name="margin-left">12.5mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">18pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- example-body-style -->


	<xsl:attribute-set name="example-name-style">
		<xsl:if test="$namespace = 'csa'">			
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csd'">
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bsi' or $namespace = 'jcgm'">
			<xsl:attribute name="padding-right">5mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb' or $namespace = 'iso'">
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="padding-right">5mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="padding-right">9mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="padding-right">9mm</xsl:attribute>
			<xsl:attribute name="font-style">italic</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<!-- <xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute> -->
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			
		</xsl:if>
		<xsl:if test="$namespace = 'm3d'">
			<xsl:attribute name="padding-right">5mm</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp'">
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>			
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-sp'">
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>			
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="color"><xsl:value-of select="$color_blue"/></xsl:attribute>
			<xsl:attribute name="padding-right">0.5mm</xsl:attribute>
		</xsl:if>		
		<xsl:if test="$namespace = 'unece' or $namespace = 'unece-rec'">
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>			
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>		
		
		<xsl:if test="$namespace = 'mpfd'">
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>			
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="font-style">italic</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- example-name-style -->

	<xsl:template name="refine_example-name-style">
		<xsl:if test="$namespace = 'iso'">
			<xsl:if test="$layoutVersion = '2024' and translate(.,'0123456789','') = ."> <!-- EXAMPLE without number -->
				<xsl:attribute name="padding-right">8mm</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:if test="not($vertical_layout = 'true')">
				<xsl:attribute name="font-family">IPAexGothic</xsl:attribute>
			</xsl:if>
			<xsl:if test="$vertical_layout = 'true'">
				<xsl:attribute name="font-family">Noto Sans JP</xsl:attribute>
				<xsl:attribute name="font-weight">500</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'plateau'">
			<xsl:if test="ancestor::mn:figure">
				<xsl:attribute name="font-weight">bold</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	
	<xsl:attribute-set name="example-p-style">
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="margin-bottom">14pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csd'">			
			<xsl:attribute name="margin-bottom">14pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb' or $namespace = 'iso' or $namespace = 'jcgm'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-top">8pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="margin-top">5pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<!-- <xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="margin-left">12.7mm</xsl:attribute> -->
			<xsl:attribute name="space-before">2pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bsi' or $namespace = 'iso'">
			<xsl:attribute name="text-align">justify</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jis' or $namespace = 'plateau'">
			<xsl:attribute name="margin-bottom">2pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'm3d'">
			<xsl:attribute name="margin-top">8pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'rsd'">			
			<xsl:attribute name="margin-bottom">14pt</xsl:attribute>
		</xsl:if>
		
		<xsl:if test="$namespace = 'unece' or $namespace = 'unece-rec'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="margin-left">15mm</xsl:attribute>			
		</xsl:if>
		
		<xsl:if test="$namespace = 'mpfd'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>			
		</xsl:if>
		
	</xsl:attribute-set> <!-- example-p-style -->

	<xsl:template name="refine_example-p-style">
		<xsl:if test="$namespace = 'ieee'">
			<xsl:if test="not(preceding-sibling::mn:p)">
				<xsl:attribute name="margin-top">6pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp' or $namespace = 'unece' or $namespace = 'unece-rec'">
			<xsl:variable name="num"><xsl:number/></xsl:variable>
			<xsl:if test="$num = 1">
				<xsl:attribute name="margin-left">5mm</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template> <!-- refine_example-p-style -->
	
	<!-- ====== -->
	<!-- termexample -->	
	<!-- ====== -->
	<xsl:template match="mn:termexample">
		<xsl:call-template name="setNamedDestination"/>
		<fo:block id="{@id}" xsl:use-attribute-sets="termexample-style">
			<xsl:call-template name="refine_termexample-style"/>
			<xsl:call-template name="setBlockSpanAll"/>
			
			<xsl:apply-templates select="mn:name" />
			<xsl:apply-templates select="node()[not(self::mn:name)]" />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="mn:termexample/mn:name">
		<xsl:if test="normalize-space() != ''">
			<fo:inline xsl:use-attribute-sets="termexample-name-style">
				<xsl:call-template name="refine_termexample-name-style"/>
				<xsl:apply-templates /><xsl:if test="$namespace = 'rsd'">: </xsl:if> <!-- commented $namespace = 'ieee', https://github.com/metanorma/isodoc/issues/614-->
			</fo:inline>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="mn:termexample/mn:p">
		<xsl:variable name="element">inline
			<xsl:if test="$namespace = 'bsi'">block</xsl:if>
			<xsl:if test="$namespace = 'ieee'">block</xsl:if>
		</xsl:variable>		
		<xsl:choose>			
			<xsl:when test="contains($element, 'block')">
				<fo:block xsl:use-attribute-sets="example-p-style">
				
					<xsl:if test="$namespace = 'ieee'">
						<xsl:if test="not(preceding-sibling::mn:p)">
							<xsl:attribute name="margin-top">6pt</xsl:attribute>
						</xsl:if>
					</xsl:if>
						
					<xsl:apply-templates/>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<fo:inline><xsl:apply-templates/></fo:inline>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>	
	<!-- ====== -->
	<!-- ====== -->
	
	
	<!-- ====== -->
	<!-- example -->	
	<!-- ====== -->
	
	<!-- There are a few cases:
	1. EXAMPLE text
	2. EXAMPLE
	        text
	3. EXAMPLE text line 1
	     text line 2
	4. EXAMPLE
	     text line 1
			 text line 2
	-->
	<xsl:template match="mn:example" name="example">
		
		<xsl:choose>
			<xsl:when test="$namespace = 'jis'">
				<xsl:call-template name="setNamedDestination"/>
				<fo:block id="{@id}" xsl:use-attribute-sets="example-style" role="SKIP">
					<xsl:call-template name="setBlockSpanAll"/>
					
					<xsl:call-template name="refine_example-style"/>
					
					<xsl:variable name="ol_adjust">
						<xsl:choose>
							<xsl:when test="$vertical_layout = 'true' and ancestor::mn:ol/@provisional-distance-between-starts">
								<xsl:value-of select="number(translate(ancestor::mn:ol/@provisional-distance-between-starts, 'mm', ''))"/>
							</xsl:when>
							<xsl:otherwise>0</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="provisional_distance_between_starts_">
						<xsl:value-of select="10 + $text_indent - $ol_adjust"/>
					</xsl:variable>
					<xsl:variable name="provisional_distance_between_starts" select="normalize-space($provisional_distance_between_starts_)"/>
					<xsl:variable name="indent_">
						<xsl:value-of select="$text_indent"/>
					</xsl:variable>
					<xsl:variable name="indent" select="normalize-space($indent_)"/>
				
					<fo:list-block provisional-distance-between-starts="{$provisional_distance_between_starts}mm">
						<xsl:if test="$vertical_layout = 'true'">
							<xsl:attribute name="provisional-distance-between-starts"><xsl:value-of select="$provisional_distance_between_starts + 2"/>mm</xsl:attribute>
						</xsl:if>
						<fo:list-item>
							<fo:list-item-label start-indent="{$indent}mm" end-indent="label-end()">
								<xsl:if test="$vertical_layout = 'true'">
									<xsl:attribute name="start-indent">0mm</xsl:attribute>
								</xsl:if>
								<fo:block>
									<xsl:apply-templates select="mn:name">
										<xsl:with-param name="fo_element">block</xsl:with-param>
									</xsl:apply-templates>
								</fo:block>
							</fo:list-item-label>
							<fo:list-item-body start-indent="body-start()">
								<fo:block>
									<xsl:apply-templates select="node()[not(self::mn:name)]">
										<xsl:with-param name="fo_element" select="'list'"/>
									</xsl:apply-templates>
								</fo:block>
							</fo:list-item-body>
						</fo:list-item>
					</fo:list-block>
					
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="setNamedDestination"/>
				<fo:block-container id="{@id}" xsl:use-attribute-sets="example-style" role="SKIP">
				
					<xsl:call-template name="setBlockSpanAll"/>
				
					<xsl:call-template name="refine_example-style"/>
				
					<xsl:variable name="fo_element">
						<xsl:if test=".//mn:table or .//mn:dl or *[not(self::mn:name)][1][self::mn:sourcecode]">block</xsl:if> 
						<xsl:choose>			
							<xsl:when test="$namespace = 'bsi' or 
																$namespace = 'iho' or 
																$namespace = 'jcgm' or 
																$namespace = 'm3d' or
																$namespace = 'ogc' or 
																$namespace = 'rsd'">inline</xsl:when> <!-- display first Example paragraph on the same line as EXAMPLE title -->
							<xsl:when test="$namespace = 'iso'">
								<xsl:choose>
									<xsl:when test="$layoutVersion = '1951' and $revision_date_num &lt; 19610101">list</xsl:when>
									<xsl:otherwise>inline</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:when test="$namespace = 'iec'">
								<xsl:choose>
									<!-- if example contains only one (except 'name') element (paragraph for example), then display it on the same line as EXAMPLE title -->
									<xsl:when test="count(*[not(self::mn:name)]) = 1">inline</xsl:when>
									<xsl:otherwise>block</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>block</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					
					<fo:block-container margin-left="0mm" role="SKIP">
					
						<xsl:choose>
							
							<xsl:when test="contains(normalize-space($fo_element), 'block')">
							
								<!-- display name 'EXAMPLE' in a separate block  -->
								<fo:block>
									<xsl:apply-templates select="mn:name">
										<xsl:with-param name="fo_element" select="$fo_element"/>
									</xsl:apply-templates>
								</fo:block>
								
								<fo:block-container xsl:use-attribute-sets="example-body-style" role="SKIP">
									<fo:block-container margin-left="0mm" margin-right="0mm" role="SKIP">
										<xsl:variable name="example_body">
											<xsl:apply-templates select="node()[not(self::mn:name)]">
												<xsl:with-param name="fo_element" select="$fo_element"/>
											</xsl:apply-templates>
										</xsl:variable>
										<xsl:choose>
											<xsl:when test="xalan:nodeset($example_body)/*">
												<xsl:copy-of select="$example_body"/>
											</xsl:when>
											<xsl:otherwise><fo:block/><!-- prevent empty block-container --></xsl:otherwise>
										</xsl:choose>
									</fo:block-container>
								</fo:block-container>
							</xsl:when> <!-- end block -->
							
							<xsl:when test="contains(normalize-space($fo_element), 'list')">
							
								<xsl:variable name="provisional_distance_between_starts_">
									<xsl:choose>
										<xsl:when test="$namespace = 'iso'">45</xsl:when>
										<xsl:otherwise>7</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:variable name="provisional_distance_between_starts" select="normalize-space($provisional_distance_between_starts_)"/>
								<xsl:variable name="indent_">
									<xsl:choose>
										<xsl:when test="$namespace = 'iso'">28</xsl:when>
										<xsl:otherwise>0</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:variable name="indent" select="normalize-space($indent_)"/>
							
								<fo:list-block provisional-distance-between-starts="{$provisional_distance_between_starts}mm">
									<fo:list-item>
										<fo:list-item-label start-indent="{$indent}mm" end-indent="label-end()">
											<fo:block>
												<xsl:apply-templates select="mn:name">
													<xsl:with-param name="fo_element">block</xsl:with-param>
												</xsl:apply-templates>
											</fo:block>
										</fo:list-item-label>
										<fo:list-item-body start-indent="body-start()">
											<fo:block>
												<xsl:apply-templates select="node()[not(self::mn:name)]">
													<xsl:with-param name="fo_element" select="$fo_element"/>
												</xsl:apply-templates>
											</fo:block>
										</fo:list-item-body>
									</fo:list-item>
								</fo:list-block>
							</xsl:when> <!-- end list -->
							
							<xsl:otherwise> <!-- inline -->
							
								<!-- display 'EXAMPLE' and first element in the same line -->
								<fo:block>
									<xsl:apply-templates select="mn:name">
										<xsl:with-param name="fo_element" select="$fo_element"/>
									</xsl:apply-templates>
									<fo:inline>
										<xsl:apply-templates select="*[not(self::mn:name)][1]">
											<xsl:with-param name="fo_element" select="$fo_element"/>
										</xsl:apply-templates>
									</fo:inline>
								</fo:block> 
								
								<xsl:if test="*[not(self::mn:name)][position() &gt; 1]">
									<!-- display further elements in blocks -->
									<fo:block-container xsl:use-attribute-sets="example-body-style" role="SKIP">
										<fo:block-container margin-left="0mm" margin-right="0mm" role="SKIP">
											<xsl:apply-templates select="*[not(self::mn:name)][position() &gt; 1]">
												<xsl:with-param name="fo_element" select="'block'"/>
											</xsl:apply-templates>
										</fo:block-container>
									</fo:block-container>
								</xsl:if>
							</xsl:otherwise> <!-- end inline -->
							
						</xsl:choose>
					</fo:block-container>
				</fo:block-container>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<!-- example/name -->
	<xsl:template match="mn:example/mn:name">
		<xsl:param name="fo_element">block</xsl:param>
	
		<xsl:choose>
			<xsl:when test="ancestor::mn:appendix">
				<fo:inline>
					<xsl:apply-templates/>
				</fo:inline>
			</xsl:when>
			<xsl:when test="contains(normalize-space($fo_element), 'block')">
				<fo:block xsl:use-attribute-sets="example-name-style">
					<xsl:if test="$namespace = 'jis'">
						<xsl:call-template name="refine_example-name-style"/>
					</xsl:if>
					<xsl:apply-templates/>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<fo:inline xsl:use-attribute-sets="example-name-style">
					<xsl:call-template name="refine_example-name-style"/>
					<xsl:apply-templates/><xsl:if test="$namespace = 'iho' or $namespace = 'ogc' or $namespace = 'rsd'">: </xsl:if> <!-- $namespace = 'ieee', see https://github.com/metanorma/isodoc/issues/614  -->
				</fo:inline>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>
	
	<!-- table/example/name, table/tfoot//example/name -->
	<xsl:template match="mn:table/mn:example/mn:name |
	mn:table/mn:tfoot//mn:example/mn:name">
		<fo:inline xsl:use-attribute-sets="example-name-style">
			<xsl:if test="$namespace = 'jis'">
				<xsl:if test="not($vertical_layout = 'true')">
					<xsl:attribute name="font-family">IPAexGothic</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$namespace = 'plateau'">
				<xsl:attribute name="font-weight">bold</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="mn:example/mn:p">
		<xsl:param name="fo_element">block</xsl:param>
		
		<xsl:variable name="num"><xsl:number/></xsl:variable>
		<xsl:variable name="element">
			<xsl:if test="$namespace = 'iso'">
				<xsl:choose>
					<xsl:when test="$num = 1 and not(contains($fo_element, 'block'))">inline</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="$layoutVersion = '1951' and $revision_date_num &lt; 19610101">list</xsl:when>
							<xsl:otherwise>block</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:if test="$namespace = 'jcgm' or $namespace = 'rsd'">
				<xsl:choose>
					<xsl:when test="$num = 1 and not(contains($fo_element, 'block'))">inline</xsl:when>
					<xsl:otherwise>block</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:value-of select="$fo_element"/>
		</xsl:variable>		
		<xsl:choose>			
			<xsl:when test="starts-with(normalize-space($element), 'block')">
				<fo:block-container role="SKIP">
					<xsl:if test="ancestor::mn:li and contains(normalize-space($fo_element), 'block')">
						<xsl:attribute name="margin-left">0mm</xsl:attribute>
						<xsl:attribute name="margin-right">0mm</xsl:attribute>
					</xsl:if>
					<fo:block xsl:use-attribute-sets="example-p-style">
					
						<xsl:call-template name="refine_example-p-style"/>
						
						<xsl:apply-templates/>
					</fo:block>
				</fo:block-container>
			</xsl:when>
			<xsl:when test="starts-with(normalize-space($element), 'list')">
				<fo:block xsl:use-attribute-sets="example-p-style">
					<xsl:apply-templates/>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<fo:inline xsl:use-attribute-sets="example-p-style">
					<xsl:apply-templates/>					
				</fo:inline>
			</xsl:otherwise>
		</xsl:choose>	
	</xsl:template> <!-- example/p -->
	
	<!-- ====== -->
	<!-- ====== -->
</xsl:stylesheet>