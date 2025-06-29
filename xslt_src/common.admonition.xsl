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
	
	<!-- admonition -->
	<xsl:attribute-set name="admonition-style">
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="border">0.5pt solid rgb(79, 129, 189)</xsl:attribute>
			<xsl:attribute name="color">rgb(79, 129, 189)</xsl:attribute>
			<xsl:attribute name="margin-left">16mm</xsl:attribute>
			<xsl:attribute name="margin-right">16mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csd'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="border">0.25pt solid black</xsl:attribute>
			<xsl:attribute name="margin-left">16mm</xsl:attribute>
			<xsl:attribute name="margin-right">16mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="border">0.5pt solid black</xsl:attribute>
			<xsl:attribute name="margin-left">-2mm</xsl:attribute>
			<xsl:attribute name="margin-right">-2mm</xsl:attribute>
			<xsl:attribute name="space-before">18pt</xsl:attribute>
			<xsl:attribute name="space-after">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="border">0.5pt solid black</xsl:attribute>
			<xsl:attribute name="space-before">12pt</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="space-after">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="border">0.5pt solid rgb(79, 129, 189)</xsl:attribute>
			<xsl:attribute name="color">rgb(79, 129, 189)</xsl:attribute>
			<xsl:attribute name="margin-left">16mm</xsl:attribute>
			<xsl:attribute name="margin-right">16mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="border">0.5pt solid black</xsl:attribute>
			<xsl:attribute name="space-before">12pt</xsl:attribute>
			<xsl:attribute name="space-after">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jcgm'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp'">
			<xsl:attribute name="border">1pt solid black</xsl:attribute>
			<xsl:attribute name="margin-left">-2mm</xsl:attribute>
			<xsl:attribute name="margin-right">-2mm</xsl:attribute>
			<xsl:attribute name="padding-top">6mm</xsl:attribute>
			<xsl:attribute name="padding-bottom">7mm</xsl:attribute>
			<xsl:attribute name="background-color">rgb(222,222,222)</xsl:attribute>
			<xsl:attribute name="space-after">24pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-sp'">
			<xsl:attribute name="border">1pt solid black</xsl:attribute>
			<xsl:attribute name="margin-left">-2mm</xsl:attribute>
			<xsl:attribute name="margin-right">-2mm</xsl:attribute>
			<xsl:attribute name="background-color">rgb(222,222,222)</xsl:attribute>
			<xsl:attribute name="space-after">24pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="border">0.5pt solid rgb(79, 129, 189)</xsl:attribute>
			<xsl:attribute name="color">rgb(79, 129, 189)</xsl:attribute>
			<xsl:attribute name="margin-left">16mm</xsl:attribute>
			<xsl:attribute name="margin-right">16mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="border">0.5pt solid rgb(79, 129, 189)</xsl:attribute>
			<xsl:attribute name="color">rgb(79, 129, 189)</xsl:attribute>
			<xsl:attribute name="margin-left">16mm</xsl:attribute>
			<xsl:attribute name="margin-right">16mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece'">
			<xsl:attribute name="border">0.25pt solid black</xsl:attribute>
			<xsl:attribute name="margin-left">-3mm</xsl:attribute>
			<xsl:attribute name="margin-right">-3mm</xsl:attribute>
			<xsl:attribute name="padding-top">4mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece-rec'">
			<xsl:attribute name="border">0.25pt solid black</xsl:attribute>
			<xsl:attribute name="margin-top">7mm</xsl:attribute>
			<xsl:attribute name="margin-left">-9mm</xsl:attribute>
			<xsl:attribute name="margin-right">-14mm</xsl:attribute>
			<xsl:attribute name="padding-top">3mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">16pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- admonition-style -->
	
	<xsl:attribute-set name="admonition-container-style">
		<xsl:attribute name="margin-left">0mm</xsl:attribute>
		<xsl:attribute name="margin-right">0mm</xsl:attribute>
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="padding">0.5mm</xsl:attribute>
			<xsl:attribute name="font-size">9pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="padding">2mm</xsl:attribute>
			<xsl:attribute name="padding-top">3mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="padding">2mm</xsl:attribute>
			<xsl:attribute name="padding-top">3mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="padding">1mm</xsl:attribute>
			<xsl:attribute name="padding-top">2mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="padding">1mm</xsl:attribute>
			<xsl:attribute name="padding-bottom">2mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="padding">2mm</xsl:attribute>
			<xsl:attribute name="padding-top">3mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="padding">2mm</xsl:attribute>
			<xsl:attribute name="padding-top">3mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp'">
			<xsl:attribute name="margin-left">8mm</xsl:attribute>
			<xsl:attribute name="margin-right">8mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-sp'">
			<xsl:attribute name="margin-left">8mm</xsl:attribute>
			<xsl:attribute name="margin-right">8mm</xsl:attribute>
			<xsl:attribute name="padding-top">6mm</xsl:attribute>
			<xsl:attribute name="padding-bottom">7mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="padding">2mm</xsl:attribute>
			<xsl:attribute name="padding-top">3mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="padding">2mm</xsl:attribute>
			<xsl:attribute name="padding-top">3mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece'">
			<xsl:attribute name="margin-left">2mm</xsl:attribute>
			<xsl:attribute name="margin-right">2mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece-rec'">
			<xsl:attribute name="margin-left">20mm</xsl:attribute>
			<xsl:attribute name="margin-right">20mm</xsl:attribute>
			<xsl:attribute name="text-indent">0mm</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- admonition-container-style -->
	
	
	<xsl:attribute-set name="admonition-name-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="font-style">italic</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="font-style">italic</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="font-family">SimHei</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="font-style">italic</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'm3d'">
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'mpfd'">
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-sp'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="font-style">italic</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="font-weight">normal</xsl:attribute>
			<xsl:attribute name="font-style">italic</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece'">
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="font-style">italic</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece-rec'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="margin-left">20mm</xsl:attribute>
			<xsl:attribute name="margin-right">25mm</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- admonition-name-style -->
	
	<xsl:attribute-set name="admonition-p-style">
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="font-style">italic</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="font-style">italic</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="text-align">justify</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="font-style">italic</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'm3d'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp' or $namespace = 'nist-sp'">
		</xsl:if>
		<xsl:if test="$namespace = 'mpfd'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="font-style">italic</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-style">italic</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece'">
			<xsl:attribute name="text-align">justify</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="line-height">122%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece-rec'">
			<xsl:attribute name="text-align">justify</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- admonition-p-style -->
	<!-- end admonition -->
	
	<!-- ================ -->
	<!-- Admonition -->
	<!-- ================ -->
	<xsl:template match="mn:admonition">
		
		<xsl:if test="$namespace = 'unece-rec'">
			<fo:block break-after="page"/>
		</xsl:if>
		
		<xsl:if test="$namespace = 'unece'"> <!-- display name before box -->
			<fo:block xsl:use-attribute-sets="admonition-name-style">
				<xsl:call-template name="displayAdmonitionName"/>
			</fo:block>
		</xsl:if>
		
		<xsl:choose>
			<xsl:when test="$namespace = 'bsi'">
			
				<xsl:choose>
					<xsl:when test="$document_type = 'PAS' or @type = 'commentary'">
						<fo:block xsl:use-attribute-sets="admonition-style">
							
							<xsl:call-template name="setBlockSpanAll"/>
							
							<xsl:if test="$document_type = 'PAS'">
								<xsl:if test="@type = 'commentary'">
									<xsl:attribute name="color"><xsl:value-of select="$color_secondary_shade_1_PAS"/></xsl:attribute>
								</xsl:if>
							</xsl:if>
							<xsl:attribute name="font-style">italic</xsl:attribute>
							
							<xsl:if test="@type = 'editorial'">
								<xsl:attribute name="color">green</xsl:attribute>
								<xsl:attribute name="font-weight">normal</xsl:attribute>
							</xsl:if>
							
							<fo:block xsl:use-attribute-sets="admonition-name-style">
								<xsl:call-template name="displayAdmonitionName"/>
							</fo:block>
							
							<xsl:apply-templates select="node()[not(self::mn:fmt-name)]" />
						</fo:block>
					</xsl:when>
					<xsl:otherwise>	<!-- BSI -->
						<xsl:call-template name="setNamedDestination"/>
						<fo:block-container id="{@id}" xsl:use-attribute-sets="admonition-style" role="SKIP">
						
							<xsl:call-template name="setBlockSpanAll"/>
						
							<xsl:if test="@type = 'caution' or @type = 'warning'">
								<xsl:attribute name="border">0.25pt solid black</xsl:attribute>
							</xsl:if>
							<xsl:attribute name="margin-right">5mm</xsl:attribute>
							<fo:block-container xsl:use-attribute-sets="admonition-container-style" role="SKIP">
								<fo:block></fo:block>
								<xsl:if test="mn:fmt-name">
									<fo:block xsl:use-attribute-sets="admonition-name-style">
										<xsl:call-template name="displayAdmonitionName"/>
									</fo:block>
								</xsl:if>
								<xsl:apply-templates select="node()[not(self::mn:fmt-name)]" />
							</fo:block-container>
						</fo:block-container>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when> <!-- BSI -->
			
			<xsl:when test="$namespace = 'csd' or $namespace = 'iso' or $namespace = 'jcgm'">
				<fo:block xsl:use-attribute-sets="admonition-style">
				
					<xsl:call-template name="setBlockSpanAll"/>
					
					<xsl:if test="@type = 'editorial'">
						<xsl:attribute name="color">green</xsl:attribute>
						<xsl:attribute name="font-weight">normal</xsl:attribute>
						<!-- <xsl:variable name="note-style">
							<style xsl:use-attribute-sets="note-style"></style>
						</xsl:variable>
						<xsl:for-each select="xalan:nodeset($note-style)//style/@*">
							<xsl:attribute name="{local-name()}"><xsl:value-of select="."/></xsl:attribute>
						</xsl:for-each> -->
					</xsl:if>
					
					<xsl:if test="$namespace = 'iso'">
						<xsl:if test="@type != 'editorial'">
							<xsl:call-template name="displayAdmonitionName"/>
								<!-- https://github.com/metanorma/isodoc/issues/614 -->
								<!-- <xsl:with-param name="sep"> — </xsl:with-param> -->
						</xsl:if>
					</xsl:if>
					
					<xsl:if test="$namespace = 'csd' or $namespace = 'jcgm'">
						<xsl:call-template name="displayAdmonitionName">
							<xsl:with-param name="sep"> — </xsl:with-param>
						</xsl:call-template>
					</xsl:if>
					
					<xsl:apply-templates select="node()[not(self::mn:fmt-name)]" />
				</fo:block>
			</xsl:when>
			
			<xsl:when test="$namespace = 'gb'">
				<fo:block xsl:use-attribute-sets="admonition-name-style">
					<xsl:call-template name="displayAdmonitionName"/>
				</fo:block>
				<xsl:apply-templates select="node()[not(self::mn:name)]" />
			</xsl:when>
			
			<xsl:otherwise> <!-- text in the box -->
				<xsl:call-template name="setNamedDestination"/>
				<fo:block-container id="{@id}" xsl:use-attribute-sets="admonition-style">
					
					<xsl:call-template name="setBlockSpanAll"/>
					
					<xsl:if test="$namespace = 'ieee'">
						<xsl:if test="@type = 'editorial'">
							<xsl:attribute name="border">none</xsl:attribute>
							<!-- 	<xsl:attribute name="font-weight">bold</xsl:attribute>
							<xsl:attribute name="font-style">italic</xsl:attribute> -->
							<xsl:attribute name="color">green</xsl:attribute>
							<xsl:attribute name="font-weight">normal</xsl:attribute>
							<xsl:attribute name="margin-top">12pt</xsl:attribute>
							<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
							<xsl:attribute name="text-align">left</xsl:attribute>
						</xsl:if>
						<xsl:if test="not(@type)">
							<xsl:attribute name="font-size">9pt</xsl:attribute>
							<xsl:attribute name="text-align">left</xsl:attribute>
						</xsl:if>
					</xsl:if>
					
					<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
						<xsl:variable name="admonition_color" select="normalize-space(/mn:metanorma/mn:metanorma-extension/mn:presentation-metadata[mn:name = concat('color-admonition-', @type)]/mn:value)"/>
						<xsl:if test="$admonition_color != ''">
							<xsl:attribute name="border">0.5pt solid <xsl:value-of select="$admonition_color"/></xsl:attribute>
							<xsl:attribute name="color"><xsl:value-of select="$admonition_color"/></xsl:attribute>
						</xsl:if>
					</xsl:if>
					
					<xsl:if test="$namespace = 'unece-rec'">
						<fo:block xsl:use-attribute-sets="admonition-name-style">
							<xsl:call-template name="displayAdmonitionName"/>
						</fo:block>
					</xsl:if>
				
					
					<xsl:choose>
					
						<xsl:when test="$namespace = 'nist-cswp' or $namespace = 'nist-sp'">
							<fo:block xsl:use-attribute-sets="admonition-container-style">
								<fo:block xsl:use-attribute-sets="admonition-name-style">
									<xsl:call-template name="displayAdmonitionName"/>
								</fo:block>
								<xsl:apply-templates select="node()[not(self::mn:fmt-name)]" />
							</fo:block>
						</xsl:when>
						
						<xsl:otherwise>
							<fo:block-container xsl:use-attribute-sets="admonition-container-style" role="SKIP">
							
								<xsl:if test="$namespace = 'ieee'">
									<xsl:if test="@type = 'editorial' or not(@type)">
										<xsl:attribute name="padding">0mm</xsl:attribute>
									</xsl:if>
									<xsl:if test="not(@type)">
										<xsl:attribute name="padding">1mm</xsl:attribute>
										<xsl:attribute name="padding-bottom">0.5mm</xsl:attribute>
									</xsl:if>
								</xsl:if>
							
								<xsl:choose>
								
									<xsl:when test="$namespace = 'bipm' or $namespace = 'iho' or $namespace = 'itu' or $namespace = 'm3d' or $namespace = 'mpfd' or $namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'rsd'">
										<fo:block xsl:use-attribute-sets="admonition-name-style">
											<xsl:call-template name="displayAdmonitionName"/>
										</fo:block>
										<fo:block xsl:use-attribute-sets="admonition-p-style">
											<xsl:apply-templates select="node()[not(self::mn:fmt-name)]" />
										</fo:block>
									</xsl:when>
									
									<xsl:when test="$namespace = 'iec'">
										<fo:block text-align="justify">
											<fo:inline>
												<xsl:call-template name="displayAdmonitionName"/>
													<!-- <xsl:with-param name="sep"> – </xsl:with-param>
												</xsl:call-template> -->
											</fo:inline>
											<xsl:apply-templates select="node()[not(self::mn:fmt-name)]" />
										</fo:block>
									</xsl:when>
									
									<xsl:when test="$namespace = 'ieee'">
										<fo:block-container margin-left="0mm" margin-right="0mm" role="SKIP">
											<fo:block xsl:use-attribute-sets="admonition-p-style">
												<fo:inline>
													<xsl:call-template name="displayAdmonitionName">
														<xsl:with-param name="sep">: </xsl:with-param>
													</xsl:call-template>
												</fo:inline>
												<xsl:apply-templates select="node()[not(self::mn:fmt-name)]" />
											</fo:block>
										</fo:block-container>
									</xsl:when>
									
									<xsl:otherwise>
										<fo:block-container margin-left="0mm" margin-right="0mm" role="SKIP">
											<fo:block>
												<xsl:apply-templates select="node()[not(self::mn:fmt-name)]" />
											</fo:block>
										</fo:block-container>
									</xsl:otherwise>
									
								</xsl:choose>
							</fo:block-container>
						</xsl:otherwise>
					</xsl:choose>
				</fo:block-container>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="displayAdmonitionName">
		<xsl:param name="sep"/> <!-- Example: ' - ' -->
		<!-- <xsl:choose>
			<xsl:when test="$namespace = 'nist-cswp' or $namespace = 'nist-sp'">
				<xsl:choose>
					<xsl:when test="@type='important'"><xsl:apply-templates select="@type"/></xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="mn:name"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="mn:name"/>
				<xsl:if test="not(mn:name)">
					<xsl:apply-templates select="@type"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose> -->
		<xsl:variable name="name">
			<xsl:apply-templates select="mn:fmt-name"/>
		</xsl:variable>
		<xsl:copy-of select="$name"/>
		<xsl:if test="normalize-space($name) != ''">
			<xsl:value-of select="$sep"/>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="mn:admonition/mn:fmt-name">
		<xsl:apply-templates />
	</xsl:template>
	
	<!-- <xsl:template match="mn:admonition/@type">
		<xsl:variable name="admonition_type_">
			<xsl:call-template name="getLocalizedString">
				<xsl:with-param name="key">admonition.<xsl:value-of select="."/></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="admonition_type" select="normalize-space(java:toUpperCase(java:java.lang.String.new($admonition_type_)))"/>
		<xsl:value-of select="$admonition_type"/>
		<xsl:if test="$admonition_type = ''">
			<xsl:value-of select="java:toUpperCase(java:java.lang.String.new(.))"/>
		</xsl:if>
	</xsl:template> -->
	
	<xsl:template match="mn:admonition/mn:p">
		<xsl:choose>
			<xsl:when test="$namespace = 'bsi' or $namespace = 'csa' or $namespace = 'iec' or $namespace = 'iho' or $namespace = 'iso' or $namespace = 'm3d' or $namespace = 'mpfd'"> <!-- processing for admonition/p found in the template for 'p' -->
				<xsl:call-template name="paragraph"/>
			</xsl:when>
			<xsl:when test="$namespace = 'gb'">
				<fo:block xsl:use-attribute-sets="admonition-p-style">
					<xsl:call-template name="paragraph"/>
				</fo:block>
			</xsl:when>
			<xsl:when test="$namespace = 'ieee'">
				<xsl:choose>
					<xsl:when test="ancestor::mn:admonition[@type = 'editorial']">
						<xsl:apply-templates />
					</xsl:when>
					<xsl:otherwise>
						<fo:block xsl:use-attribute-sets="admonition-p-style">
							<xsl:apply-templates />
						</fo:block>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<fo:block xsl:use-attribute-sets="admonition-p-style">
				
					<xsl:if test="$namespace = 'nist-sp'">
						<xsl:variable name="num"><xsl:number/></xsl:variable>
						<xsl:if test="$num &lt; count(ancestor::mn:admonition//mn:p)">
							<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
						</xsl:if>
					</xsl:if>
					
					<xsl:apply-templates />
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- ================ -->
	<!-- END Admonition -->
	<!-- ================ -->
	
</xsl:stylesheet>