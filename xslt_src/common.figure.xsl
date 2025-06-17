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
	
	<xsl:attribute-set name="figure-block-style">
		<xsl:attribute name="role">SKIP</xsl:attribute>
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csd'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="space-after">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jcgm'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-sp' or $namespace = 'nist-cswp'">
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'm3d'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'mpfd'">
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece' or $namespace = 'unece-rec'">
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>

	<xsl:template name="refine_figure-block-style">
		<xsl:if test="$namespace = 'bipm'">
			<xsl:if test="mn:name">
				<xsl:attribute name="space-after">12pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:if test="$layoutVersion = '1972' or $layoutVersion = '1979' or $layoutVersion = '1987' or $layoutVersion = '1989'">
				<xsl:if test="normalize-space(@width) != 'text-width'">
					<xsl:attribute name="span">all</xsl:attribute>
					<xsl:attribute name="margin-top">6pt</xsl:attribute>
					<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$layoutVersion = '2024'">
				<xsl:attribute name="space-after">18pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:if test="ancestor::mn:example or ancestor::mn:note">
				<xsl:attribute name="margin-left">0mm</xsl:attribute>
			</xsl:if>
			<xsl:if test="$vertical_layout = 'true' and not(mn:figure)">
				<xsl:attribute name="reference-orientation">90</xsl:attribute>
				<xsl:attribute name="display-align">center</xsl:attribute>
				<!-- <xsl:attribute name="border">1pt solid blue</xsl:attribute> -->
				<xsl:attribute name="margin-left">0mm</xsl:attribute>
				
				<!-- determine block-container width for rotated image -->
				<xsl:for-each select="mn:image[1]"> <!-- set context to 'image' element -->
					
					<xsl:variable name="width">
						<xsl:call-template name="setImageWidth"/>
					</xsl:variable>
					
					<xsl:choose>
						<xsl:when test="normalize-space($width) != ''">
							<xsl:attribute name="width">
								<xsl:value-of select="$width"/>
							</xsl:attribute>
						</xsl:when>
						<xsl:when test="*[local-name() = 'svg']">
							<xsl:variable name="svg_content">
								<xsl:apply-templates select="*[local-name() = 'svg'][1]" mode="svg_update"/>
							</xsl:variable>
							<xsl:variable name="svg_width_" select="xalan:nodeset($svg_content)/*/@width"/>
							<xsl:variable name="svg_width" select="number(translate($svg_width_, 'px', ''))"/>
							
							<xsl:variable name="scale_width">
								<xsl:choose>
									<xsl:when test="$svg_width &gt; $height_effective_px">
										<xsl:value-of select="$height_effective_px div $svg_width"/>
									</xsl:when>
									<xsl:otherwise>1</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:attribute name="width"><xsl:value-of select="$svg_width * $scale_width"/>px</xsl:attribute>
							
							
						</xsl:when>
						<xsl:otherwise> <!-- determine image width programmatically -->
							<xsl:variable name="img_src">
								<xsl:call-template name="getImageSrc"/>
							</xsl:variable>
							<xsl:variable name="image_width_programmatically" select="java:org.metanorma.fop.utils.ImageUtils.getImageWidth($img_src, $height_effective, $width_effective)"/>
							
							<xsl:variable name="scale">
								<xsl:call-template name="getImageScale"/>
							</xsl:variable>
							
							<xsl:if test="normalize-space($image_width_programmatically) != '0'">
								<xsl:attribute name="width">
									<xsl:value-of select="concat($image_width_programmatically, 'mm')"/> <!-- * ($scale div 100) -->
								</xsl:attribute>
								<xsl:if test="$scale != 100">
									<xsl:attribute name="display-align">before</xsl:attribute>
								</xsl:if>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
				<!-- end: $vertical_layout = 'true -->
			</xsl:if>
			<!-- end: $namespace = 'jis' -->
		</xsl:if>
	</xsl:template>

	<xsl:attribute-set name="figure-style">
		<xsl:if test="$namespace = 'rsd'"> <!-- background for image -->
			<xsl:attribute name="background-color">rgb(236,242,246)</xsl:attribute>
			<xsl:attribute name="padding-left">11mm</xsl:attribute>
			<xsl:attribute name="margin-left">0mm</xsl:attribute>
			<xsl:attribute name="padding-right">11mm</xsl:attribute>
			<xsl:attribute name="margin-right">0mm</xsl:attribute>
			<xsl:attribute name="padding-top">7.5mm</xsl:attribute>
			<xsl:attribute name="padding-bottom">7.5mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">3mm</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>

	<xsl:attribute-set name="figure-name-style">
		<xsl:attribute name="role">Caption</xsl:attribute>
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">left</xsl:attribute>			
			<xsl:attribute name="margin-left">19mm</xsl:attribute>
			<xsl:attribute name="text-indent">-19mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bsi'">			
			<xsl:attribute name="font-weight">normal</xsl:attribute>
			<xsl:attribute name="font-style">italic</xsl:attribute>
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="text-align">left</xsl:attribute>
			<xsl:attribute name="space-before">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">2pt</xsl:attribute>
			<xsl:attribute name="margin-left">-20mm</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="space-after">6pt</xsl:attribute>
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="font-family">Arial</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="space-after">6pt</xsl:attribute>
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
		</xsl:if>		
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="color"><xsl:value-of select="$color_text_title"/></xsl:attribute>
			<!-- <xsl:attribute name="margin-top">12pt</xsl:attribute> -->
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="space-after">12pt</xsl:attribute>
			<!-- <xsl:attribute name="keep-with-next">always</xsl:attribute> -->
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="text-align">left</xsl:attribute>
			<xsl:attribute name="color">rgb(68, 84, 106)</xsl:attribute>
			<xsl:attribute name="font-weight">normal</xsl:attribute>
			<xsl:attribute name="font-style">italic</xsl:attribute>
			<xsl:attribute name="margin-top">0pt</xsl:attribute>
			<xsl:attribute name="space-after">6pt</xsl:attribute>
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csd' or $namespace = 'iec' or $namespace = 'iso' or $namespace = 'jcgm'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="space-after">12pt</xsl:attribute>
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="font-family">SimHei</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="space-after">12pt</xsl:attribute>
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<!-- <xsl:attribute name="font-size">11pt</xsl:attribute> -->
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-top">2pt</xsl:attribute>
			<xsl:attribute name="space-after">6pt</xsl:attribute>
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu' or $namespace = 'nist-sp'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="space-after">6pt</xsl:attribute>
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="space-after">6pt</xsl:attribute>
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'm3d'">
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="space-after">12pt</xsl:attribute>
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'plateau'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-size">13pt</xsl:attribute>
			<xsl:attribute name="font-weight">300</xsl:attribute>
			<xsl:attribute name="color">black</xsl:attribute>
			<xsl:attribute name="text-align">left</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece'">
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="space-after">6pt</xsl:attribute>
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece-rec'">
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="font-size">9pt</xsl:attribute>
			<xsl:attribute name="space-after">6pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="keep-together.within-column">always</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'mpfd'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="space-after">6pt</xsl:attribute>
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
		</xsl:if>	
	</xsl:attribute-set>
	
	<xsl:template name="refine_figure-name-style">
		<xsl:if test="$namespace = 'nist-cswp'  or $namespace = 'nist-sp'">
			<xsl:if test="mn:dl">
				<xsl:attribute name="space-before">12pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'bsi'">
			<xsl:if test="count(ancestor::mn:figure) &gt; 1">
				<xsl:attribute name="margin-left">0mm</xsl:attribute>
				<xsl:if test="$document_type != 'PAS'">
					<!-- for sub-figures -->
					<xsl:attribute name="font-style">normal</xsl:attribute>
					<xsl:attribute name="font-size">9pt</xsl:attribute>
					<xsl:attribute name="space-before">2pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$document_type = 'PAS'">
				<xsl:attribute name="margin-left">0mm</xsl:attribute>
				<xsl:attribute name="font-size">11pt</xsl:attribute>
				<xsl:attribute name="font-style">normal</xsl:attribute>
			</xsl:if>
			<xsl:if test="../@width = 'full-page-width' or ../mn:figure/@width = 'full-page-width'">
				<xsl:attribute name="margin-left">0mm</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'ieee'">
			<xsl:if test="$current_template = 'whitepaper' or $current_template = 'icap-whitepaper' or $current_template = 'industry-connection-report'">
				<xsl:attribute name="font-size">inherit</xsl:attribute>
				<xsl:attribute name="font-family">Arial Black</xsl:attribute>
			</xsl:if>
		</xsl:if>
    
		<xsl:if test="$namespace = 'jis'">
			<xsl:if test="ancestor::mn:figure">
				<xsl:attribute name="margin-top">0</xsl:attribute>
				<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="not($vertical_layout = 'true')">
				<xsl:attribute name="font-family">IPAexGothic</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'plateau'">
			<xsl:if test="$doctype = 'technical-report'">
				<xsl:attribute name="font-weight">normal</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template> <!-- refine_figure-name-style -->
	
	<xsl:attribute-set name="image-style">
		<xsl:attribute name="role">SKIP</xsl:attribute>
		<xsl:attribute name="text-align">center</xsl:attribute>
		<xsl:if test="$namespace = 'bsi'">
			
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="space-before">12pt</xsl:attribute>
			<xsl:attribute name="space-after">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:attribute name="space-before">12pt</xsl:attribute>
			<xsl:attribute name="space-after">0pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="border">2pt solid black</xsl:attribute>			
			<xsl:attribute name="text-indent">0</xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'unece-rec'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>			
		</xsl:if>
	</xsl:attribute-set>

	<xsl:template name="refine_image-style">
		<xsl:if test="$namespace = 'bsi'">
			<xsl:if test="ancestor::mn:table">
				<xsl:attribute name="text-align">inherit</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:if test="$vertical_layout = 'true'">
				<xsl:attribute name="text-align">inherit</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'unece-rec'">
			<xsl:if test="ancestor::un:admonition">
				<xsl:attribute name="margin-top">-12mm</xsl:attribute>
				<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	
	<xsl:attribute-set name="image-graphic-style">
		<xsl:attribute name="width">100%</xsl:attribute>
		<xsl:attribute name="content-height">100%</xsl:attribute>
		<xsl:attribute name="scaling">uniform</xsl:attribute>			
		<xsl:if test="$namespace = 'bsi' or $namespace = 'gb' or $namespace = 'itu' or $namespace = 'nist-cswp' or $namespace = 'nist-sp' or 
									$namespace = 'm3d' or $namespace = 'plateau' or $namespace = 'unece'">
			<xsl:attribute name="content-width">scale-to-fit</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa' or $namespace = 'csd' or $namespace = 'iec' or $namespace = 'ieee' or 
											$namespace = 'iho' or $namespace = 'iso' or 
											$namespace = 'ogc' or $namespace = 'ogc-white-paper' or
											$namespace = 'rsd' or 
											$namespace = 'unece-rec' or 
											$namespace = 'mpfd' or $namespace = 'bipm' or $namespace = 'jcgm'">
			<xsl:attribute name="content-height">scale-to-fit</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec' or $namespace = 'itu' or $namespace = 'nist-cswp' or $namespace = 'nist-sp'">
			<xsl:attribute name="width">75%</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="figure-source-style">
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="font-size">6pt</xsl:attribute>
			<xsl:attribute name="font-style">italic</xsl:attribute>
			<xsl:attribute name="text-align">right</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="figure-pseudocode-p-style">
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	
	<!-- ============================ -->
	<!-- figure's footnotes rendering -->
	<!-- ============================ -->
	
	<!-- figure/fmt-footnote-container -->
	<xsl:template match="mn:figure//mn:fmt-footnote-container"/>
	
	<!-- TO DO: remove, now the figure fn in figure/dl/... https://github.com/metanorma/isodoc/issues/658 -->
	<xsl:template name="figure_fn_display">
		
		<xsl:variable name="references">
			<xsl:for-each select="./mn:fmt-footnote-container/mn:fmt-fn-body">
				<xsl:variable name="curr_id" select="@id"/>
				<!-- <curr_id><xsl:value-of select="$curr_id"/></curr_id>
				<curr><xsl:copy-of select="."/></curr>
				<ancestor><xsl:copy-of select="ancestor::mn:figure[.//mn:name[.//mn:fn]]"/></ancestor> -->
				<xsl:choose>
					<!-- skip figure/name/fn -->
					<xsl:when test="ancestor::mn:figure[.//mn:name[.//mn:fn[@target = $curr_id]]]"><!-- skip --></xsl:when>
					<xsl:otherwise>
						<xsl:element name="figure" namespace="{$namespace_full}">
							<xsl:element name="fmt-footnote-container" namespace="{$namespace_full}">
								<xsl:copy-of select="."/>
							</xsl:element>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:variable>
		<!-- <references><xsl:copy-of select="$references"/></references> -->
		
		<xsl:if test="xalan:nodeset($references)//mn:fmt-fn-body">
		
			<xsl:variable name="key_iso">
				<xsl:if test="$namespace = 'iso' or $namespace = 'iec'  or $namespace = 'gb' or $namespace = 'jcgm'">true</xsl:if>
			</xsl:variable>
			
			<fo:block>
				<!-- current hierarchy is 'figure' element -->
				<xsl:variable name="following_dl_colwidths">
					<xsl:if test="mn:dl"><!-- if there is a 'dl', then set the same columns width as for 'dl' -->
						<xsl:variable name="simple-table">
							<!-- <xsl:variable name="doc_ns">
								<xsl:if test="$namespace = 'bipm'">bipm</xsl:if>
							</xsl:variable>
							<xsl:variable name="ns">
								<xsl:choose>
									<xsl:when test="normalize-space($doc_ns)  != ''">
										<xsl:value-of select="normalize-space($doc_ns)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="substring-before(name(/*), '-')"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable> -->
							
							<xsl:for-each select="mn:dl[1]">
								<mn:tbody>
									<xsl:apply-templates mode="dl"/>
								</mn:tbody>
							</xsl:for-each>
						</xsl:variable>
						
						<xsl:call-template name="calculate-column-widths">
							<xsl:with-param name="cols-count" select="2"/>
							<xsl:with-param name="table" select="$simple-table"/>
						</xsl:call-template>
						
					</xsl:if>
				</xsl:variable>
				
				<xsl:variable name="maxlength_dt">
					<xsl:for-each select="mn:dl[1]">
						<xsl:call-template name="getMaxLength_dt"/>			
					</xsl:for-each>
				</xsl:variable>
			
				<fo:table width="95%" table-layout="fixed">
					<xsl:if test="normalize-space($key_iso) = 'true'">
						<xsl:attribute name="font-size">10pt</xsl:attribute>
						<xsl:if test="$namespace = 'iec'">
							<xsl:attribute name="font-size">8pt</xsl:attribute>
						</xsl:if>
					</xsl:if>
					<xsl:choose>
						<!-- if there 'dl', then set same columns width -->
						<xsl:when test="xalan:nodeset($following_dl_colwidths)//column">
							<xsl:call-template name="setColumnWidth_dl">
								<xsl:with-param name="colwidths" select="$following_dl_colwidths"/>								
								<xsl:with-param name="maxlength_dt" select="$maxlength_dt"/>								
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<fo:table-column column-width="5%"/>
							<fo:table-column column-width="95%"/>
						</xsl:otherwise>
					</xsl:choose>
					<fo:table-body>
						<!-- <xsl:for-each select="xalan:nodeset($references)//fn"> -->
						<xsl:for-each select="xalan:nodeset($references)//mn:fmt-fn-body">
						
							<xsl:variable name="reference" select="@reference"/>
							<!-- <xsl:if test="not(preceding-sibling::*[@reference = $reference])"> --> <!-- only unique reference puts in note-->
								<fo:table-row>
									<fo:table-cell>
										<fo:block>
											<xsl:if test="$namespace = 'plateau'">
												<xsl:attribute name="margin-left"><xsl:value-of select="$tableAnnotationIndent"/></xsl:attribute>
												<xsl:attribute name="font-weight">bold</xsl:attribute>
											</xsl:if>
											<xsl:choose>
												<xsl:when test="$namespace = 'plateau'">
													<fo:inline id="{@id}">
														<xsl:attribute name="padding-right">0mm</xsl:attribute>
														<!-- <xsl:value-of select="@reference"/> -->
														<!-- <xsl:value-of select="normalize-space(.//mn:fmt-fn-label)"/> -->
														<xsl:apply-templates select=".//mn:fmt-fn-label/node()"/>
													</fo:inline>
												</xsl:when>
												<xsl:otherwise>
													<fo:inline id="{@id}" xsl:use-attribute-sets="figure-fmt-fn-label-style">
														<!-- <xsl:attribute name="padding-right">0mm</xsl:attribute> -->
														<!-- <xsl:value-of select="@reference"/> -->
														<xsl:value-of select="normalize-space(.//mn:fmt-fn-label)"/>
													</fo:inline>
												</xsl:otherwise>
											</xsl:choose>
											
										</fo:block>
									</fo:table-cell>
									<fo:table-cell>
										<fo:block xsl:use-attribute-sets="figure-fn-body-style">
											<xsl:if test="normalize-space($key_iso) = 'true'">
												<xsl:choose>
													<xsl:when test="$namespace = 'iec'"></xsl:when>
													<xsl:otherwise>
														<xsl:attribute name="margin-bottom">0</xsl:attribute>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:if>
											<xsl:if test="$namespace = 'plateau'">
												<xsl:attribute name="margin-left">5mm</xsl:attribute>
												<xsl:attribute name="margin-bottom">0</xsl:attribute>
											</xsl:if>
											<!-- <xsl:copy-of select="./node()"/> -->
											<xsl:apply-templates />
										</fo:block>
									</fo:table-cell>
								</fo:table-row>
							<!-- </xsl:if> -->
						</xsl:for-each>
					</fo:table-body>
				</fo:table>
			</fo:block>
		</xsl:if>
	</xsl:template> <!-- figure_fn_display -->
	
	<xsl:template match="mn:figure//mn:fmt-fn-body//mn:fmt-fn-label"> <!-- mn:fmt-footnote-container/ -->
		<xsl:param name="process">false</xsl:param>
		<xsl:if test="$process = 'true'">
			<fo:inline xsl:use-attribute-sets="figure-fn-number-style" role="SKIP">
				<xsl:attribute name="padding-right">0mm</xsl:attribute>
				
				<!-- tab is padding-right -->
				<xsl:apply-templates select=".//mn:tab">
					<xsl:with-param name="process">true</xsl:with-param>
				</xsl:apply-templates>
				
				<xsl:apply-templates />
				
			</fo:inline>
		</xsl:if>
	</xsl:template> <!--  figure//fmt-fn-body//fmt-fn-label -->
	
	<xsl:template match="mn:figure//mn:fmt-fn-body//mn:fmt-fn-label//mn:tab" priority="5">
		<xsl:param name="process">false</xsl:param>
		<xsl:if test="$process = 'true'">
			
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="mn:figure//mn:fmt-fn-body//mn:fmt-fn-label//mn:sup" priority="5">
		<fo:inline xsl:use-attribute-sets="figure-fmt-fn-label-style" role="SKIP">
			<xsl:call-template name="refine_figure-fmt-fn-label-style"/>
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>
	
	
	<!-- added for https://github.com/metanorma/isodoc/issues/607 -->
	<!-- figure's footnote label -->
	<!-- figure/dl[@key = 'true']/dt/p/sup -->
	<xsl:template match="mn:figure/mn:dl[@key = 'true']/mn:dt/
				mn:p[count(node()[normalize-space() != '']) = 1]/mn:sup" priority="3">
		<xsl:variable name="key_iso">
			<xsl:if test="$namespace = 'bsi' or $namespace = 'iso' or $namespace = 'iec'  or $namespace = 'gb' or $namespace = 'jcgm'">true</xsl:if>
		</xsl:variable>
		<xsl:if test="normalize-space($key_iso) = 'true'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:if test="$namespace = 'iec'">
				<xsl:attribute name="font-size">8pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<fo:inline xsl:use-attribute-sets="figure-fn-number-style figure-fmt-fn-label-style"> <!-- id="{@id}"  -->
			<!-- <xsl:value-of select="@reference"/> -->
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>
	
	<!-- ============================ -->
	<!-- END: figure's footnotes rendering -->
	<!-- ============================ -->
	
	<!-- caption for figure key and another caption, https://github.com/metanorma/isodoc/issues/607 -->
	<xsl:template match="mn:figure/mn:p[@keep-with-next = 'true' and mn:strong]" priority="3">
		<fo:block text-align="left" margin-bottom="12pt" keep-with-next="always" keep-with-previous="always">
			<xsl:call-template name="refine_figure_key_style"/>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	
	<xsl:template name="refine_figure_key_style">
		<xsl:if test="$namespace = 'bsi' or $namespace = 'iso' or $namespace = 'jcgm'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">0</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="font-size">8pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			<xsl:attribute name="text-indent">7.4mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-weight">normal</xsl:attribute>
			<xsl:attribute name="color">black</xsl:attribute>
		</xsl:if>
	</xsl:template> <!-- refine_figure_key_style -->
	
</xsl:stylesheet>