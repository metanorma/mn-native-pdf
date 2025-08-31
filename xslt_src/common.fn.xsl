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
	
	<xsl:attribute-set name="footnote-separator-leader-style">
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="leader-pattern">rule</xsl:attribute>
			<xsl:attribute name="rule-thickness">0.5pt</xsl:attribute>
			<xsl:attribute name="leader-length">35%</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:template name="refine_footnote-separator-leader-style">
		<xsl:if test="$namespace = 'ieee'">
			<xsl:if test="$current_template = 'whitepaper' or $current_template= 'icap-whitepaper' or $current_template = 'industry-connection-report'">
				<xsl:attribute name="rule-thickness">1pt</xsl:attribute>
				<xsl:attribute name="leader-length">51mm</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	
	<xsl:attribute-set name="fn-container-body-style">
		<xsl:attribute name="text-indent">0</xsl:attribute>
		<xsl:attribute name="start-indent">0</xsl:attribute>
		<xsl:if test="$namespace = 'nist-cswp'">
			<xsl:attribute name="margin-left">3mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece'">
			<xsl:attribute name="margin-left">-8mm</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:template name="refine_fn-container-body-style">
	</xsl:template>
	
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
	</xsl:attribute-set> <!-- fn-reference-style -->
	
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
			<!-- <xsl:if test="preceding-sibling::*[1][self::mn:fn]">,&#xa0;</xsl:if> -->
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
		<!-- https://github.com/metanorma/metanorma-ieee/issues/595 -->
		<xsl:if test="preceding-sibling::node()[normalize-space() != ''][1][self::mn:fn]">,<xsl:if test="$namespace = 'bsi'">&#xa0;</xsl:if></xsl:if>
	</xsl:template> <!-- refine_fn-reference-style -->
	
	<xsl:attribute-set name="fn-style">
		<xsl:attribute name="keep-with-previous.within-line">always</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:template name="refine_fn-style">
	</xsl:template>
	
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
	</xsl:attribute-set> <!-- fn-num-style -->
	
	<xsl:template name="refine_fn-num-style">
		<xsl:if test="$namespace = 'jis'">
			<xsl:if test="not($vertical_layout = 'true')">
				<xsl:attribute name="font-family">Times New Roman</xsl:attribute>
			</xsl:if>
			<xsl:if test="$vertical_layout = 'true'">
				<xsl:attribute name="vertical-align">baseline</xsl:attribute>
				<xsl:attribute name="font-size">80%</xsl:attribute>
				<xsl:attribute name="baseline-shift">20%</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	
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
	</xsl:attribute-set> <!-- fn-body-style" -->
	
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
	
	<!-- ===================== -->
	<!-- Footnotes processing  -->
	<!-- ===================== -->
	
	<!-- document text (not figures, or tables) footnotes -->
	<xsl:variable name="footnotes_">
		<xsl:for-each select="//mn:fmt-footnote-container/mn:fmt-fn-body"> <!-- commented mn:metanorma/, because there are fn in figure or table name -->
			<!-- <xsl:copy-of select="."/> -->
			<xsl:variable name="update_xml_step1">
				<xsl:apply-templates select="." mode="update_xml_step1"/>
			</xsl:variable>
			<xsl:apply-templates select="xalan:nodeset($update_xml_step1)" mode="update_xml_enclose_keep-together_within-line"/>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="footnotes" select="xalan:nodeset($footnotes_)"/>
	
	<!--
	<fn reference="1">
			<p id="_8e5cf917-f75a-4a49-b0aa-1714cb6cf954">Formerly denoted as 15 % (m/m).</p>
		</fn>
	-->
	<!-- footnotes in text (title, bibliography, main body), not for tables, figures and names --> <!-- table's, figure's names -->
	<!-- fn in text -->
	<xsl:template match="mn:fn[not(ancestor::*[(self::mn:table or self::mn:figure)] and not(ancestor::mn:fmt-name))]" priority="2" name="fn">
		<xsl:param name="footnote_body_from_table">false</xsl:param>
		
		<!-- list of unique footnotes -->
		<xsl:variable name="p_fn_">
			<xsl:call-template name="get_fn_list"/>
		</xsl:variable>
		<xsl:variable name="p_fn" select="xalan:nodeset($p_fn_)"/>
		
		<xsl:variable name="gen_id" select="generate-id(.)"/>
		
		<!-- fn sequence number in document -->
		<xsl:variable name="current_fn_number" select="@reference"/>
		
		<xsl:variable name="current_fn_number_text">
			<xsl:choose>
				<xsl:when test="$namespace = 'iso'">
					<xsl:choose>
						<xsl:when test="$layoutVersion = '1951' and translate($current_fn_number, '0123456789', '') = ''">
							<!-- replace number to asterisks -->
							<xsl:call-template name="repeat">
								<xsl:with-param name="char" select="'*'"/>
								<xsl:with-param name="count" select="$current_fn_number"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise><xsl:value-of select="normalize-space(mn:fmt-fn-label)"/></xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="$namespace = 'jis'">
					<xsl:choose>
						<xsl:when test="$autonumbering_style = 'japanese'">
							<xsl:text>&#x2008;</xsl:text>
							<xsl:value-of select="$numbers_japanese//mn:localized-string[@key = $current_fn_number]"/>
							<xsl:text>&#x2008;</xsl:text>
						</xsl:when>
						<xsl:otherwise><xsl:value-of select="translate($current_fn_number, ')', '')"/><fo:inline font-weight="normal">)</fo:inline></xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="$namespace = 'plateau'">
					<xsl:value-of select="normalize-space(mn:fmt-fn-label)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$current_fn_number"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="$namespace = 'bsi'">
				<xsl:if test="$document_type = 'PAS'">
					<xsl:text>)</xsl:text>
				</xsl:if>
			</xsl:if>
		</xsl:variable>
		
		<xsl:variable name="ref_id" select="@target"/>
		
		<xsl:variable name="footnote_inline">
			<fo:inline role="Reference">
			
				<xsl:variable name="fn_styles">
					<xsl:choose>
						<xsl:when test="ancestor::mn:bibitem">
							<fn_styles xsl:use-attribute-sets="bibitem-note-fn-style">
								<xsl:call-template name="refine_bibitem-note-fn-style"/>
							</fn_styles>
						</xsl:when>
						<xsl:otherwise>
							<fn_styles xsl:use-attribute-sets="fn-num-style">
								<xsl:call-template name="refine_fn-num-style"/>
							</fn_styles>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
			
				<xsl:for-each select="xalan:nodeset($fn_styles)/fn_styles/@*">
					<xsl:copy-of select="."/>
				</xsl:for-each>
			
				<!-- https://github.com/metanorma/metanorma-ieee/issues/595 -->
				<!-- <xsl:if test="following-sibling::node()[normalize-space() != ''][1][self::mn:fn]">
					<xsl:attribute name="padding-right">0.5mm</xsl:attribute>
				</xsl:if> -->
			
				<xsl:if test="$namespace = 'bsi'">
					<xsl:if test="$document_type = 'PAS'">
						<xsl:attribute name="font-size">5pt</xsl:attribute>
					</xsl:if>
					<!-- <xsl:if test="following-sibling::*[1][self::mn:fn]">
						<xsl:attribute name="padding-right">0mm</xsl:attribute>
					</xsl:if>
					<xsl:if test="preceding-sibling::*[1][self::mn:fn]">,</xsl:if> -->
				</xsl:if>
				
				<xsl:if test="$namespace = 'iso'">
					<xsl:if test="$layoutVersion = '2024'">
						<xsl:attribute name="font-size">70%</xsl:attribute>
					</xsl:if>
				</xsl:if>
				
				<xsl:if test="preceding-sibling::node()[normalize-space() != ''][1][self::mn:fn]">,</xsl:if>
				
				<xsl:call-template name="insert_basic_link">
					<xsl:with-param name="element">
						<fo:basic-link internal-destination="{$ref_id}" fox:alt-text="footnote {$current_fn_number}"> <!-- note: role="Lbl" removed in https://github.com/metanorma/mn2pdf/issues/291 -->
							<fo:inline role="Lbl"> <!-- need for https://github.com/metanorma/metanorma-iso/issues/1003 -->
							
								<xsl:if test="$namespace = 'jis'">
									<xsl:attribute name="keep-together.within-line">always</xsl:attribute>
									<fo:inline font-family="IPAexGothic">
										<xsl:call-template name="insertVerticalChar">
											<xsl:with-param name="str" select="'&#x3014;'"/>
										</xsl:call-template>
									</fo:inline>
								</xsl:if>
								<xsl:copy-of select="$current_fn_number_text"/>
								
								<xsl:if test="$namespace = 'jis'">
									<fo:inline font-family="IPAexGothic">
										<xsl:call-template name="insertVerticalChar">
											<xsl:with-param name="str" select="'&#x3015;'"/>
										</xsl:call-template>
									</fo:inline>
								</xsl:if>
								
							</fo:inline>
						</fo:basic-link>
					</xsl:with-param>
				</xsl:call-template>
			</fo:inline>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="normalize-space(@skip_footnote_body) = 'true'">
				<xsl:copy-of select="$footnote_inline"/>
			</xsl:when>
			<!-- <xsl:when test="$footnotes//mn:fmt-fn-body[@id = $ref_id] or normalize-space(@skip_footnote_body) = 'false'"> -->
			<xsl:when test="$p_fn//fn[@gen_id = $gen_id] or normalize-space(@skip_footnote_body) = 'false' or $footnote_body_from_table = 'true'">
			
				<fo:footnote xsl:use-attribute-sets="fn-style" role="SKIP">
					<xsl:call-template name="refine_fn-style"/>
					<xsl:copy-of select="$footnote_inline"/>
					<fo:footnote-body role="Note">
						<xsl:if test="$namespace = 'bsi'">
							<xsl:if test="$document_type = 'PAS'">
								<fo:block role="SKIP">&#xa0;</fo:block>
							</xsl:if>
						</xsl:if>
						
						<fo:block-container xsl:use-attribute-sets="fn-container-body-style" role="SKIP">
							<xsl:call-template name="refine_fn-container-body-style"/>
							
							<xsl:variable name="fn_block">
								<xsl:call-template name="refine_fn-body-style"/>
									
								<fo:inline id="{$ref_id}" xsl:use-attribute-sets="fn-body-num-style" role="Lbl">
								
									<xsl:call-template name="refine_fn-body-num-style"/>
									
									<xsl:value-of select="$current_fn_number_text"/>
									
								</fo:inline>
								<!-- <xsl:apply-templates /> -->
								<!-- <ref_id><xsl:value-of select="$ref_id"/></ref_id>
								<here><xsl:copy-of select="$footnotes"/></here> -->
								<xsl:apply-templates select="$footnotes/mn:fmt-fn-body[@id = $ref_id]"/>
							</xsl:variable>
							
							<xsl:choose>
								<xsl:when test="$namespace = 'jis'">
									<xsl:choose>
										<xsl:when test="$vertical_layout = 'true'">
											<fo:list-block xsl:use-attribute-sets="fn-body-style" role="SKIP" provisional-distance-between-starts="25mm">
												<xsl:call-template name="refine_fn-body-style"/>
												<fo:list-item role="SKIP">
													<fo:list-item-label start-indent="{$text_indent}mm" end-indent="label-end()" role="SKIP">
														<fo:block role="SKIP">
															<fo:inline id="{$ref_id}" xsl:use-attribute-sets="fn-body-num-style" role="Lbl">
								
																<xsl:call-template name="refine_fn-body-num-style"/>
																
																<xsl:call-template name="insertVerticalChar">
																	<xsl:with-param name="str" select="'&#x3014;'"/>
																</xsl:call-template>
																
																<xsl:value-of select="$current_fn_number_text"/>
																
																<xsl:call-template name="insertVerticalChar">
																	<xsl:with-param name="str" select="'&#x3015;'"/>
																</xsl:call-template>
																
															</fo:inline>
														</fo:block>
													</fo:list-item-label>
													<fo:list-item-body start-indent="body-start()" xsl:use-attribute-sets="table-fn-body-style" role="SKIP">
														<fo:block role="SKIP">
															<!-- <xsl:apply-templates /> -->
															<xsl:apply-templates select="$footnotes/mn:fmt-fn-body[@id = $ref_id]"/>
														</fo:block>
													</fo:list-item-body>
												</fo:list-item>
											</fo:list-block>
										</xsl:when> <!-- $vertical_layout = 'true' -->
										<xsl:otherwise>
											<fo:block xsl:use-attribute-sets="fn-body-style" role="SKIP">
												<xsl:attribute name="text-align">left</xsl:attribute> <!-- because footer is centered -->
												<xsl:copy-of select="$fn_block"/>
											</fo:block>
										</xsl:otherwise>
									</xsl:choose>
									<!-- jis -->
								</xsl:when>
								<xsl:otherwise>
									<fo:block xsl:use-attribute-sets="fn-body-style" role="SKIP">
										<xsl:copy-of select="$fn_block"/>
									</fo:block>
								</xsl:otherwise>
							</xsl:choose>
							
							
						</fo:block-container>
					</fo:footnote-body>
				</fo:footnote>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="$footnote_inline"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- fn in text -->
	
	
	
	<xsl:template name="get_fn_list">
		<xsl:choose>
			<xsl:when test="@current_fn_number"> <!-- for BSI, footnote reference number calculated already -->
				<fn gen_id="{generate-id(.)}">
					<xsl:copy-of select="@*"/>
					<xsl:copy-of select="node()"/>
				</fn>
			</xsl:when>
			<xsl:otherwise>
				<!-- itetation for:
				footnotes in bibdata/title
				footnotes in bibliography
				footnotes in document's body (except table's head/body/foot and figure text) 
				-->
				<xsl:for-each select="ancestor::mn:metanorma/mn:bibdata/mn:note[@type='title-footnote']">
					<fn gen_id="{generate-id(.)}">
						<xsl:copy-of select="@*"/>
						<xsl:copy-of select="node()"/>
					</fn>
				</xsl:for-each>
				<xsl:for-each select="ancestor::mn:metanorma/mn:boilerplate/* | 
					ancestor::mn:metanorma//mn:preface/* |
					ancestor::mn:metanorma//mn:sections/* | 
					ancestor::mn:metanorma//mn:annex |
					ancestor::mn:metanorma//mn:bibliography/*">
					<xsl:sort select="@displayorder" data-type="number"/>
					<!-- commented:
					 .//mn:bibitem[ancestor::mn:references]/mn:note |
					 because 'fn' there is in biblio-tag -->
					<xsl:for-each select=".//mn:fn[not(ancestor::*[(self::mn:table or self::mn:figure)] and not(ancestor::mn:fmt-name))][generate-id(.)=generate-id(key('kfn',@reference)[1])]">
						<!-- copy unique fn -->
						<fn gen_id="{generate-id(.)}">
							<xsl:copy-of select="@*"/>
							<xsl:copy-of select="node()"/>
						</fn>
					</xsl:for-each>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	

	<!-- fn/text() -->
	<xsl:template match="mn:fn/text()[normalize-space() != '']">
		<fo:inline role="SKIP"><xsl:value-of select="."/></fo:inline>
	</xsl:template>
	
	<!-- fn//p fmt-fn-body//p -->
	<xsl:template match="mn:fn//mn:p | mn:fmt-fn-body//mn:p">
		<fo:inline role="P">
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>
	
	<xsl:template name="insertFootnoteSeparatorCommon">
		<xsl:param name="leader_length">30%</xsl:param>
		<fo:static-content flow-name="xsl-footnote-separator" role="artifact">
			<fo:block>
				<fo:leader leader-pattern="rule" leader-length="{$leader_length}"/>
			</fo:block>
		</fo:static-content>
	</xsl:template>
	
	<!-- ===================== -->
	<!-- END Footnotes processing  -->
	<!-- ===================== -->
	
</xsl:stylesheet>