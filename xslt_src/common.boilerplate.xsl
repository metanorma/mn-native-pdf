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

	<!-- boilerplate sections styles -->
	<xsl:attribute-set name="copyright-statement-style">
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="line-height">1.1</xsl:attribute>
			<xsl:attribute name="font-size">9pt</xsl:attribute>
			<xsl:attribute name="text-align">justify</xsl:attribute>
			<xsl:attribute name="role">SKIP</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="font-size">8pt</xsl:attribute>
			<xsl:attribute name="line-height">125%</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- copyright-statement-style -->
	
	<xsl:template name="refine_copyright-statement-style">
		<xsl:if test="$namespace = 'iso'">
			<xsl:if test="$layoutVersion = '1989'">
				<xsl:attribute name="font-size">8pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	
	<xsl:attribute-set name="copyright-statement-title-style">
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="margin-left">0.5mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">3mm</xsl:attribute>
			<xsl:attribute name="font-size">12pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="role">H1</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="color"><xsl:value-of select="$color_text_title"/></xsl:attribute>
			<xsl:attribute name="margin-top">24pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:attribute name="font-family">Lato</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- copyright-statement-title-style -->
	
	<xsl:template name="refine_copyright-statement-title-style">
		<xsl:if test="$namespace = 'iso'">
			<xsl:if test="$layoutVersion = '1989'">
					<xsl:attribute name="font-size">11pt</xsl:attribute>
				</xsl:if>
			<xsl:if test="$layoutVersion = '2024'">
				<xsl:attribute name="margin-bottom">3.5mm</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	
	<xsl:attribute-set name="copyright-statement-p-style">
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="space-after">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'pas'">
			<xsl:attribute name="space-after">2pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="margin-left">0.5mm</xsl:attribute>
			<xsl:attribute name="margin-right">0.5mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:attribute name="text-align">left</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- copyright-statement-p-style -->

	<xsl:template name="refine_copyright-statement-p-style">
		<xsl:if test="$namespace = 'bsi'">
			<xsl:if test="ancestor::mn:boilerplate and contains(ancestor::mn:clause[1]/mn:fmt-title, 'Publication history')">
				<xsl:attribute name="space-after">0pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'pas'">
			<xsl:if test="$doctype = 'flex-standard'">
				<xsl:attribute name="space-after">6pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="ancestor::mn:boilerplate and contains(ancestor::mn:clause[1]/mn:fmt-title, 'Publication history')">
				<xsl:attribute name="space-after">0pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'bsi' or $namespace = 'pas' or $namespace = 'ogc-white-paper'">
			<xsl:if test="@align">
				<xsl:attribute name="text-align">
					<xsl:value-of select="@align"/>
				</xsl:attribute>
			</xsl:if>
		</xsl:if>
	
		<xsl:if test="$namespace = 'iec'">
			<xsl:if test="following-sibling::mn:p">
				<xsl:attribute name="margin-bottom">3pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="not(following-sibling::mn:p)">
				<xsl:attribute name="margin-left">4mm</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="text-align">justify</xsl:attribute>
		</xsl:if>
		
		<xsl:if test="$namespace = 'iso'">
			<xsl:if test="following-sibling::mn:p">
				<xsl:attribute name="margin-bottom">3pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="contains(@id, 'address') or contains(normalize-space(), 'Tel:') or contains(normalize-space(), 'Phone:')">
				<xsl:attribute name="margin-left">4.5mm</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'itu'">
			<xsl:if test="not(preceding-sibling::mn:p)"> <!-- first para -->
				<xsl:attribute name="text-align">center</xsl:attribute>
				<xsl:attribute name="margin-top">6pt</xsl:attribute>
				<xsl:attribute name="margin-bottom">14pt</xsl:attribute>
				<xsl:attribute name="keep-with-next">always</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
	</xsl:template>

	<xsl:attribute-set name="license-statement-style">
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="font-family">Times New Roman</xsl:attribute>
			<xsl:attribute name="font-size">10.5pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="font-size">8pt</xsl:attribute>
			<xsl:attribute name="line-height">125%</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- license-statement-style -->
	
	<xsl:template name="refine_license-statement-style">
	</xsl:template>
	
	<xsl:attribute-set name="license-statement-title-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="text-align">center</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-sp'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="color"><xsl:value-of select="$color_text_title"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:attribute name="font-family">Lato</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="margin-top">4pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- license-statement-title-style -->
	
	<xsl:template name="refine_license-statement-title-style">
	</xsl:template>
	
	<xsl:attribute-set name="license-statement-p-style">
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="text-align">justify</xsl:attribute>
			<xsl:attribute name="line-height">135%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="text-align">justify</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="margin-left">1.5mm</xsl:attribute>
			<xsl:attribute name="margin-right">1.5mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:attribute name="font-size">8pt</xsl:attribute>
			<xsl:attribute name="margin-top">14pt</xsl:attribute>
			<xsl:attribute name="line-height">135%</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- license-statement-p-style -->

	<xsl:template name="refine_license-statement-p-style">
		
	</xsl:template>

	<xsl:attribute-set name="legal-statement-style">
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="font-size">8pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
		</xsl:if>
	</xsl:attribute-set> <!-- legal-statement-style -->
	
	<xsl:template name="refine_legal-statement-style">
	</xsl:template>
	
	<xsl:attribute-set name="legal-statement-title-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="font-family">Arial</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="space-before">18pt</xsl:attribute>
			<xsl:attribute name="keep-together.within-column">always</xsl:attribute>
			<xsl:attribute name="span">all</xsl:attribute>
			<xsl:attribute name="font-size">11pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp'">
			<xsl:attribute name="font-family">Arial</xsl:attribute>
			<xsl:attribute name="font-size">12pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="color"><xsl:value-of select="$color"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-sp'">
			<xsl:attribute name="font-family">Arial</xsl:attribute>
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:attribute name="font-family">Lato</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-weight">normal</xsl:attribute>
			<xsl:attribute name="padding-top">2mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- legal-statement-title-style -->
	
	<xsl:template name="refine_legal-statement-title-style">
		<xsl:if test="$namespace = 'ieee'">
			<xsl:variable name="level">
				<xsl:call-template name="getLevel"/>
			</xsl:variable>
			<xsl:if test="$level = '1'">
				<xsl:attribute name="font-size">12pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="$current_template = 'whitepaper' or $current_template = 'icap-whitepaper' or $current_template = 'industry-connection-report'">
				<xsl:attribute name="font-family">Arial Black</xsl:attribute>
				<xsl:attribute name="font-size">13pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	
	<xsl:attribute-set name="legal-statement-p-style">
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:attribute name="text-align">left</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- legal-statement-p-style -->
	
	<xsl:template name="refine_legal-statement-p-style">
		<xsl:if test="@align">
			<xsl:attribute name="text-align">
				<xsl:value-of select="@align"/>
			</xsl:attribute>
		</xsl:if>
	</xsl:template>
	
	<xsl:attribute-set name="feedback-statement-style">
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="line-height">125%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			 <xsl:attribute name="font-family">Arial</xsl:attribute>
			 <xsl:attribute name="font-size">7pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="font-size">8pt</xsl:attribute>
			<xsl:attribute name="line-height">125%</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- feedback-statement-style -->
	
	<xsl:template name="refine_feedback-statement-style">
		<xsl:if test="$namespace = 'ieee'">
			<xsl:if test="$current_template = 'whitepaper' or $current_template = 'icap-whitepaper' or $current_template = 'industry-connection-report'">
				<xsl:attribute name="font-family">Calibri Light</xsl:attribute>
				<xsl:attribute name="font-size">9pt</xsl:attribute>
				<xsl:attribute name="line-height">1.2</xsl:attribute>
			</xsl:if>
			<!-- <xsl:if test="$current_template = 'standard'">
				<xsl:attribute name="font-size">8pt</xsl:attribute>
			</xsl:if> -->
		</xsl:if>
	</xsl:template>
	
	<xsl:attribute-set name="feedback-statement-title-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- feedback-statement-title-style -->
	
	<xsl:template name="refine_feedback-statement-title-style">
	
	</xsl:template>
	
	<xsl:attribute-set name="feedback-statement-p-style">
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- feedback-statement-p-style -->

	<xsl:template name="refine_feedback-statement-p-style">
	</xsl:template>

	<!-- End boilerplate sections styles -->

	<!-- ================================= -->
	<!-- Preface boilerplate sections processing -->
	<!-- ================================= -->
	<xsl:template match="mn:copyright-statement">
		<fo:block xsl:use-attribute-sets="copyright-statement-style" role="SKIP">
			<xsl:call-template name="refine_copyright-statement-style"/>
			
			<xsl:apply-templates />
		</fo:block>
	</xsl:template> <!-- copyright-statement -->
	
	<xsl:template match="mn:copyright-statement//mn:fmt-title">
		<xsl:choose>
			<xsl:when test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
				<xsl:variable name="level">
					<xsl:call-template name="getLevel"/>
				</xsl:variable>
				<fo:block role="H{$level}" xsl:use-attribute-sets="copyright-statement-title-style">
					<xsl:apply-templates />
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<!-- process in the template 'title' -->
				<xsl:call-template name="title"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- copyright-statement//title -->
	
	<xsl:template match="mn:copyright-statement//mn:p">
		
		<xsl:choose>
			<xsl:when test="$namespace = 'bsi' or $namespace = 'pas' or $namespace = 'ogc' or $namespace = 'ogc-white-paper'">
				<fo:block xsl:use-attribute-sets="copyright-statement-p-style">
					<xsl:call-template name="refine_copyright-statement-p-style"/>
					
					<xsl:apply-templates />
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<!-- process in the template 'paragraph' -->
				<xsl:call-template name="paragraph"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- copyright-statement//p -->
	
	<xsl:template match="mn:license-statement">
		<fo:block xsl:use-attribute-sets="license-statement-style">
			<xsl:call-template name="refine_license-statement-style"/>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template> <!-- license-statement -->

	<xsl:template match="mn:license-statement//mn:fmt-title">
		<xsl:choose>
			<xsl:when test="$namespace = 'bipm' or $namespace = 'iso' or $namespace = 'itu' or $namespace = 'nist-sp' or $namespace = 'ogc' or $namespace = 'ogc-white-paper'">
				<xsl:variable name="level">
					<xsl:call-template name="getLevel"/>
				</xsl:variable>
				<fo:block role="H{$level}" xsl:use-attribute-sets="license-statement-title-style">
					<xsl:call-template name="refine_license-statement-title-style"/>
					<xsl:apply-templates />
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<!-- process in the template 'title' -->
				<xsl:call-template name="title"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- license-statement/title -->

	<xsl:template match="mn:license-statement//mn:p">
		<xsl:choose>
			<xsl:when test="$namespace = 'bipm' or $namespace = 'iso' or $namespace = 'ogc' or $namespace = 'ogc-white-paper'">
				<fo:block xsl:use-attribute-sets="license-statement-p-style">
		
					<xsl:if test="$namespace = 'iso'">
						<xsl:if test="following-sibling::mn:p">
							<xsl:attribute name="margin-top">6pt</xsl:attribute>
							<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
						</xsl:if>
					</xsl:if>
					
					<xsl:if test="$namespace = 'ogc-white-paper'">
						<xsl:if test="following-sibling::mn:p">
							<xsl:attribute name="margin-bottom">14pt</xsl:attribute>
						</xsl:if>
					</xsl:if>
					
					<xsl:apply-templates />
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<!-- process in the template 'paragraph' -->
				<xsl:call-template name="paragraph"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- license-statement/p -->
	
	
	<xsl:template match="mn:legal-statement">
		<xsl:param name="isLegacy">false</xsl:param>
		<fo:block xsl:use-attribute-sets="legal-statement-style">
			<xsl:call-template name="refine_legal-statement-style"/>
			<xsl:if test="$namespace = 'ogc'">
				<xsl:if test="$isLegacy = 'true'">
					<xsl:attribute name="font-size">9pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template> <!-- legal-statement -->
	
	<xsl:template match="mn:legal-statement//mn:fmt-title">
		<xsl:choose>
			<xsl:when test="$namespace = 'itu' or $namespace = 'nist-cswp' or $namespace = 'nist-sp' or $namespace = 'ogc-white-paper' or $namespace = 'rsd'">
				<!-- ogc-white-paper rsd -->
				<xsl:variable name="level">
					<xsl:call-template name="getLevel"/>
				</xsl:variable>
				<fo:block role="H{$level}" xsl:use-attribute-sets="legal-statement-title-style">
					<xsl:apply-templates />
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<!-- process in the template 'title' -->
				<xsl:call-template name="title"/>
			</xsl:otherwise>
		</xsl:choose>
	
	</xsl:template> <!-- legal-statement/title -->
	
	<xsl:template match="mn:legal-statement//mn:p">
		<xsl:param name="margin"/>
		<xsl:choose>
			<xsl:when test="$namespace = 'ogc-white-paper'">
				<!-- csa -->
				<fo:block xsl:use-attribute-sets="legal-statement-p-style">
					<xsl:call-template name="refine_legal-statement-p-style"/>
					
					<xsl:apply-templates />
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<!-- process in the template 'paragraph' -->
				<xsl:call-template name="paragraph">
					<xsl:with-param name="margin" select="$margin"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- legal-statement/p -->
	
	<xsl:template match="mn:feedback-statement">
		<fo:block xsl:use-attribute-sets="feedback-statement-style">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template> <!-- feedback-statement -->
	
	<xsl:template match="mn:feedback-statement//mn:fmt-title">
		<xsl:choose>
			<xsl:when test="$namespace = 'iec'">
				<xsl:variable name="level">
					<xsl:call-template name="getLevel"/>
				</xsl:variable>
				<fo:block role="H{$level}" xsl:use-attribute-sets="feedback-statement-title-style">
					<xsl:call-template name="refine_feedback-statement-title-style"/>
					<xsl:apply-templates />
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<!-- process in the template 'title' -->
				<xsl:call-template name="title"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="mn:feedback-statement//mn:p">
		<xsl:param name="margin"/>
		<xsl:choose>
			<xsl:when test="$namespace = 'iec' or $namespace = 'ogc'">
				<fo:block xsl:use-attribute-sets="feedback-statement-p-style">
					<xsl:call-template name="refine_feedback-statement-p-style"/>
					<!-- <xsl:copy-of select="@id"/> -->
					<xsl:apply-templates/>
				</fo:block>	
			</xsl:when>
			<xsl:otherwise>
				<!-- process in the template 'paragraph' -->
				<xsl:call-template name="paragraph">
					<xsl:with-param name="margin" select="$margin"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- ================================= -->
	<!-- END Preface boilerplate sections processing -->
	<!-- ================================= -->

</xsl:stylesheet>