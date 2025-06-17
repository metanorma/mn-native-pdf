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
	
	
	<xsl:attribute-set name="fn-reference-style">
		<xsl:attribute name="font-size">80%</xsl:attribute>
		<xsl:attribute name="keep-with-previous.within-line">always</xsl:attribute>
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="font-size">70%</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
			<xsl:attribute name="font-style">italic</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="font-size">50%</xsl:attribute>
			<xsl:attribute name="font-weight">normal</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="font-size">65%</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="vertical-align">super</xsl:attribute>
			<xsl:attribute name="color">blue</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:attribute name="font-size">67%</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp' or $namespace = 'nist-sp'">
			<xsl:attribute name="vertical-align">super</xsl:attribute>
			<xsl:attribute name="color">blue</xsl:attribute>
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:attribute name="vertical-align">super</xsl:attribute>
			<xsl:attribute name="color">blue</xsl:attribute>
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'plateau'">
			<xsl:attribute name="font-size">6pt</xsl:attribute>
			<xsl:attribute name="baseline-shift">25%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-size">70%</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
			<xsl:attribute name="font-style">italic</xsl:attribute>
		</xsl:if>
		
	</xsl:attribute-set>
	
	<xsl:template name="refine_fn-reference-style">
		<xsl:if test="$namespace = 'bsi'">
			<xsl:if test="ancestor::*[local-name()='table'] or ancestor::*[local-name()='table']">
				<xsl:attribute name="font-weight">normal</xsl:attribute>
				<xsl:attribute name="baseline-shift">25%</xsl:attribute>
				<xsl:attribute name="font-size">5.5pt</xsl:attribute>
				<xsl:if test="$document_type = 'PAS'">
					<xsl:attribute name="font-size">4.5pt</xsl:attribute>
					<xsl:attribute name="padding-left">0.5mm</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="preceding-sibling::*[1][self::mn:fn]">,&#xa0;</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'iso' or $namespace = 'iec' or $namespace = 'jcgm'">
			<xsl:if test="ancestor::*[local-name()='table']">
				<xsl:attribute name="font-weight">normal</xsl:attribute>
				<xsl:attribute name="baseline-shift">15%</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:if test="not($vertical_layout = 'true')">
				<xsl:attribute name="font-family">Times New Roman</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template> <!-- refine_fn-reference-style -->
	
	<xsl:attribute-set name="fn-style">
		<xsl:attribute name="keep-with-previous.within-line">always</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="fn-num-style">
		<xsl:attribute name="keep-with-previous.within-line">always</xsl:attribute>
		<xsl:if test="$namespace = 'bipm' or $namespace = 'jcgm'">
			<xsl:attribute name="font-size">65%</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="font-size">6pt</xsl:attribute>
			<xsl:attribute name="baseline-shift">30%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="font-size">65%</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csd'">
			<xsl:attribute name="font-size">65%</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="font-size">60%</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="font-size">8pt</xsl:attribute>
			<xsl:attribute name="baseline-shift">15%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="font-size">65%</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="font-size">70%</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="font-size">80%</xsl:attribute>
			<!--<xsl:attribute name="vertical-align">super</xsl:attribute> -->
			<xsl:attribute name="baseline-shift">30%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="font-size">60%</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:attribute name="font-size">67%</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'm3d'">
			<xsl:attribute name="font-size">7pt</xsl:attribute>
			<xsl:attribute name="baseline-shift">30%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'mpfd'">
			<xsl:attribute name="font-size">7pt</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp' or $namespace = 'nist-sp'">
			<xsl:attribute name="font-size">60%</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="font-size">65%</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'plateau'">
			<xsl:attribute name="font-size">6pt</xsl:attribute>
			<xsl:attribute name="baseline-shift">25%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-size">65%</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece'">
			<xsl:attribute name="font-size">60%</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece-rec'">
			<xsl:attribute name="font-size">55%</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="fn-body-style">
		<xsl:attribute name="font-weight">normal</xsl:attribute>
		<xsl:attribute name="font-style">normal</xsl:attribute>
		<xsl:attribute name="text-indent">0</xsl:attribute>
		<xsl:attribute name="start-indent">0</xsl:attribute>
		<xsl:if test="$namespace = 'bipm' or $namespace = 'jcgm'">
			<xsl:attribute name="font-size">9pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="line-height">124%</xsl:attribute>
			<xsl:attribute name="text-align">justify</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="color">black</xsl:attribute>
			<xsl:attribute name="font-size">8pt</xsl:attribute>
			<xsl:attribute name="start-indent">5mm</xsl:attribute>
			<xsl:attribute name="text-indent">-5mm</xsl:attribute>
			<xsl:attribute name="text-align">left</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="font-family">Azo Sans Lt</xsl:attribute>
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="color">rgb(168, 170, 173)</xsl:attribute>
			<xsl:attribute name="text-align">left</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csd'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="font-size">9pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="font-size">8pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">5pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="font-size">8pt</xsl:attribute>
			<!-- <xsl:attribute name="margin-bottom">5pt</xsl:attribute> -->
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="text-align">justify</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'm3d'">
			<xsl:attribute name="font-size">9pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'mpfd'">
			<xsl:attribute name="font-size">9pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp'">
			<xsl:attribute name="font-size">9pt</xsl:attribute>
			<xsl:attribute name="font-family">Times New Roman</xsl:attribute>
			<xsl:attribute name="margin-left">-3mm</xsl:attribute>
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="text-indent">-2mm</xsl:attribute>
			<xsl:attribute name="line-height">10pt</xsl:attribute>
			<xsl:attribute name="page-break-inside">avoid</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-sp'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="font-family">Times New Roman</xsl:attribute>
			<xsl:attribute name="text-align">justify</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="color"><xsl:value-of select="$color_main"/></xsl:attribute>
			<xsl:attribute name="line-height">124%</xsl:attribute>
			<xsl:attribute name="text-align">justify</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="color">black</xsl:attribute>
			<xsl:attribute name="text-align">justify</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="color">rgb(168, 170, 173)</xsl:attribute>
			<xsl:attribute name="text-align">left</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece'">
			<xsl:attribute name="font-size">9pt</xsl:attribute>
			<xsl:attribute name="text-align">justify</xsl:attribute>
			<xsl:attribute name="line-height">125%</xsl:attribute>
			<xsl:attribute name="margin-left">8mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece-rec'">
			<xsl:attribute name="font-size">9pt</xsl:attribute>
			<xsl:attribute name="line-height">125%</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:template name="refine_fn-body-style">
		<xsl:if test="$namespace = 'bsi'">
			<xsl:if test="$document_type = 'PAS'">
				<xsl:attribute name="color"><xsl:value-of select="$color_secondary_shade_1_PAS"/></xsl:attribute>
				<xsl:attribute name="start-indent">0mm</xsl:attribute>
				<xsl:attribute name="text-indent">0mm</xsl:attribute>
				<xsl:attribute name="margin-top">6pt</xsl:attribute>
				<xsl:attribute name="margin-bottom">-7mm</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:if test="$current_template = 'whitepaper' or $current_template = 'icap-whitepaper' or $current_template = 'industry-connection-report'">
				<xsl:attribute name="font-size">7pt</xsl:attribute>
				<xsl:attribute name="line-height">1.1</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:if test="$layoutVersion = '1951'">
				<xsl:if test="$revision_date_num &gt;= 19680101">
					<xsl:attribute name="font-size">9pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$layoutVersion = '1972' or $layoutVersion = '1979' or $layoutVersion = '1987' or $layoutVersion = '1989'">
				<xsl:attribute name="font-size">9pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="$layoutVersion = '2024'">
				<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:variable name="doctype" select="ancestor::mn:metanorma/mn:bibdata/mn:ext/mn:doctype[not(@language) or @language = '']"/>
			<xsl:if test="$doctype = 'service-publication'">
				<xsl:attribute name="font-size">10pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:if test="not($vertical_layout = 'true')">
				<xsl:attribute name="font-family">IPAexMincho</xsl:attribute> <!-- prevent font for footnote in Times New Roman main text -->
			</xsl:if>
		</xsl:if>
	</xsl:template> <!-- refine_fn-body-style -->
	
	
	<xsl:attribute-set name="fn-body-num-style">
		<xsl:attribute name="keep-with-next.within-line">always</xsl:attribute>
		<xsl:if test="$namespace = 'bipm' or $namespace = 'jcgm'">
			<xsl:attribute name="font-size">60%</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
			<xsl:attribute name="padding-right">1mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="padding-right">3mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="font-size">60%</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csd'">
			<xsl:attribute name="font-size">60%</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="font-size">50%</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="baseline-shift">15%</xsl:attribute>
			<xsl:attribute name="padding-right">3mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="font-size">50%</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
			<xsl:attribute name="padding-right">1mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="font-size">60%</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
			<xsl:attribute name="padding-right">1mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="padding-right">3mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="font-size">85%</xsl:attribute>
			<xsl:attribute name="padding-right">2mm</xsl:attribute>
			<xsl:attribute name="baseline-shift">30%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:attribute name="font-size">67%</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'm3d'">
			<xsl:attribute name="font-size">6pt</xsl:attribute>
			<xsl:attribute name="baseline-shift">30%</xsl:attribute>
			<xsl:attribute name="padding-right">1mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'mpfd'">
			<xsl:attribute name="font-size">6pt</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
			<xsl:attribute name="padding-right">1mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp'">
			<xsl:attribute name="font-size">75%</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
			<xsl:attribute name="padding-right">1mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-sp'">
			<xsl:attribute name="font-size">75%</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="font-size">60%</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'plateau'">
			<xsl:attribute name="font-size">6pt</xsl:attribute>
			<xsl:attribute name="baseline-shift">25%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-size">60%</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece'">
			<xsl:attribute name="font-size">60%</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
			<xsl:attribute name="padding-right">8mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece-rec'">
			<xsl:attribute name="font-size">60%</xsl:attribute>
			<xsl:attribute name="padding-right">1mm</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- fn-body-num-style -->
	
	<xsl:template name="refine_fn-body-num-style">
		<xsl:if test="$namespace = 'bsi'">
			<xsl:if test="$document_type = 'PAS'">
				<xsl:attribute name="font-size">5pt</xsl:attribute>
				<xsl:attribute name="baseline-shift">35%</xsl:attribute>
				<xsl:attribute name="padding-right">1mm</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:if test="$current_template = 'whitepaper' or $current_template = 'icap-whitepaper' or $current_template = 'industry-connection-report'">
				<xsl:attribute name="padding-right">0.5mm</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:if test="not($vertical_layout = 'true')">
				<xsl:attribute name="font-family">Times New Roman</xsl:attribute>
			</xsl:if>
			<xsl:if test="$vertical_layout = 'true'">
				<xsl:attribute name="vertical-align">baseline</xsl:attribute>
				<xsl:attribute name="font-size">100%</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template> <!-- refine_fn-body-num-style -->
	
</xsl:stylesheet>