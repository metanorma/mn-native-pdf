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
	
	<!-- bibitem in Normative References (references/@normative="true") -->
	<xsl:attribute-set name="bibitem-normative-style">
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="start-indent">25mm</xsl:attribute>
			<xsl:attribute name="text-indent">-25mm</xsl:attribute>
			<xsl:attribute name="line-height">115%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="start-indent">12mm</xsl:attribute>
			<xsl:attribute name="text-indent">-12mm</xsl:attribute>
			<xsl:attribute name="line-height">145%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csd'">
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="text-indent">-11.7mm</xsl:attribute>
			<xsl:attribute name="margin-left">11.7mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="margin-top">5pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">10pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="margin-left">14mm</xsl:attribute>
			<xsl:attribute name="text-indent">-14mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jcgm'">
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="start-indent">6mm</xsl:attribute>
			<xsl:attribute name="text-indent">-6mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'm3d'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="text-indent">-11.7mm</xsl:attribute>
			<xsl:attribute name="margin-left">11.7mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'mpfd'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="text-indent">-11.7mm</xsl:attribute>
			<xsl:attribute name="margin-left">11.7mm</xsl:attribute>
		</xsl:if>
		
		<xsl:if test="$namespace = 'nist-sp'">
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="margin-left">12mm</xsl:attribute>
			<xsl:attribute name="text-indent">-12mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="start-indent">25mm</xsl:attribute>
			<xsl:attribute name="text-indent">-25mm</xsl:attribute>
			<xsl:attribute name="line-height">115%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="start-indent">12mm</xsl:attribute>
			<xsl:attribute name="text-indent">-12mm</xsl:attribute>
			<xsl:attribute name="line-height">115%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'plateau'">
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="start-indent">6mm</xsl:attribute>
			<xsl:attribute name="text-indent">-6mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="font-weight">normal</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece' or $namespace = 'unece-rec'">
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="margin-left">14mm</xsl:attribute>
			<xsl:attribute name="text-indent">-14mm</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- bibitem-normative-style -->
	
	<!-- bibitem in Normative References (references/@normative="true"), renders as list -->
	<xsl:attribute-set name="bibitem-normative-list-style">
		<xsl:attribute name="provisional-distance-between-starts">12mm</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="provisional-distance-between-starts">13mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csd'">
			
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="margin-top">5pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">14pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<!-- <xsl:attribute name="line-height">115%</xsl:attribute> -->
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jcgm'">
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp'">
			
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			
			<xsl:attribute name="provisional-distance-between-starts">13mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="margin-bottom">4pt</xsl:attribute>
			<xsl:attribute name="provisional-distance-between-starts">8mm</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- bibitem-normative-list-style -->
	
	<xsl:attribute-set name="bibitem-non-normative-style">
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="line-height">145%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-sp'">
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="margin-left">12mm</xsl:attribute>
			<xsl:attribute name="text-indent">-12mm</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- bibitem-non-normative-style -->
	
	<!-- bibitem in bibliography section (references/@normative="false"), renders as list -->
	<xsl:attribute-set name="bibitem-non-normative-list-style">
		<xsl:attribute name="provisional-distance-between-starts">12mm</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="provisional-distance-between-starts">13mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="provisional-distance-between-starts">10mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="line-height">1.4</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csd'">
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="margin-top">5pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">14pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="provisional-distance-between-starts">9.5mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="line-height">115%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jcgm'">
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp'">
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="provisional-distance-between-starts">13mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
		</xsl:if>
		<xsl:if test="$namespace = 'plateau'">
			<xsl:attribute name="provisional-distance-between-starts">9.5mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">2pt</xsl:attribute>
			<xsl:attribute name="line-height">1.5</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="margin-bottom">4pt</xsl:attribute>
			<xsl:attribute name="provisional-distance-between-starts">8mm</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- bibitem-non-normative-list-style -->
	
	<xsl:attribute-set name="bibitem-non-normative-list-item-style">
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		<xsl:if test="$namespace = 'bipm'">
		</xsl:if>
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csd'">
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="margin-top">5pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">14pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jcgm'">
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp'">
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="margin-bottom">4pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<!-- bibitem in bibliography section (references/@normative="false"), list body -->
	<xsl:attribute-set name="bibitem-normative-list-body-style">
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="text-align">justify</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="line-height-shift-adjustment">disregard-shifts</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="margin-left">14mm</xsl:attribute>
			<xsl:attribute name="text-indent">-14mm</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="bibitem-non-normative-list-body-style">
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="text-align">justify</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="line-height-shift-adjustment">disregard-shifts</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="margin-left">14mm</xsl:attribute>
			<xsl:attribute name="text-indent">-14mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'm3d'">
			<xsl:attribute name="text-align">justify</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- bibitem-non-normative-list-body-style -->
	
	<!-- footnote reference number for bibitem, in the text  -->
	<xsl:attribute-set name="bibitem-note-fn-style">
		<xsl:attribute name="keep-with-previous.within-line">always</xsl:attribute>
		<xsl:attribute name="font-size">65%</xsl:attribute>
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="font-size">6pt</xsl:attribute>
			<xsl:attribute name="baseline-shift">30%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csd'">
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="font-size">50%</xsl:attribute>
			<xsl:attribute name="baseline-shift">30%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="font-size">8pt</xsl:attribute>
			<xsl:attribute name="baseline-shift">15%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="font-size">8pt</xsl:attribute>
			<xsl:attribute name="baseline-shift">30%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="font-size">8pt</xsl:attribute>
			<xsl:attribute name="baseline-shift">30%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="font-size">8pt</xsl:attribute>
			<xsl:attribute name="baseline-shift">30%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="font-size">8pt</xsl:attribute>
			<xsl:attribute name="baseline-shift">30%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jcgm'">
			<xsl:attribute name="font-size">8pt</xsl:attribute>
			<xsl:attribute name="baseline-shift">30%</xsl:attribute>
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
			<xsl:attribute name="baseline-shift">30%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp' or $namespace = 'nist-sp'">
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'plateau'">
			<xsl:attribute name="font-size">6pt</xsl:attribute>
			<xsl:attribute name="baseline-shift">25%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece' or $namespace = 'unece-rec'">
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- bibitem-note-fn-style -->
	
	<!-- footnote number on the page bottom -->
	<xsl:attribute-set name="bibitem-note-fn-number-style">
		<xsl:attribute name="keep-with-next.within-line">always</xsl:attribute>
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="font-size">60%</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="alignment-baseline">hanging</xsl:attribute>
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
			<xsl:attribute name="baseline-shift">30%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="baseline-shift">15%</xsl:attribute>
			<xsl:attribute name="padding-right">3mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="alignment-baseline">hanging</xsl:attribute>
			<xsl:attribute name="padding-right">1mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="alignment-baseline">hanging</xsl:attribute>
			<xsl:attribute name="padding-right">3mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="alignment-baseline">hanging</xsl:attribute>
			<xsl:attribute name="padding-right">3mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="alignment-baseline">hanging</xsl:attribute>
			<xsl:attribute name="padding-right">3mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jcgm'">
			<xsl:attribute name="alignment-baseline">hanging</xsl:attribute>
			<xsl:attribute name="padding-right">3mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'm3d'">
			<xsl:attribute name="font-size">6pt</xsl:attribute>
			<xsl:attribute name="baseline-shift">30%</xsl:attribute>
			<xsl:attribute name="padding-right">1mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'mpfd'">
			<xsl:attribute name="font-size">6pt</xsl:attribute>
			<xsl:attribute name="baseline-shift">30%</xsl:attribute>
			<xsl:attribute name="padding-right">1mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp' or $namespace = 'nist-sp'">
			<xsl:attribute name="font-size">60%</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="font-size">60%</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-size">60%</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece' or $namespace = 'unece-rec'">
			<xsl:attribute name="font-size">60%</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- bibitem-note-fn-number-style -->
	
	<!-- footnote body (text) on the page bottom -->
	<xsl:attribute-set name="bibitem-note-fn-body-style">
		<xsl:attribute name="font-size">10pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		<xsl:attribute name="start-indent">0pt</xsl:attribute>
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="margin-bottom">4pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="font-family">Azo Sans Lt</xsl:attribute>
			<xsl:attribute name="color">rgb(168, 170, 173)</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="font-size">9pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">4pt</xsl:attribute>
			<xsl:attribute name="text-indent">7.4mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="font-size">8pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">5pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="font-size">8pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">5pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="margin-bottom">4pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="margin-bottom">4pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="margin-bottom">4pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jcgm'">
			<xsl:attribute name="margin-bottom">4pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'm3d'">
			<xsl:attribute name="font-size">9pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">4pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'mpfd'">
			<xsl:attribute name="font-size">9pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">4pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="color">rgb(168, 170, 173)</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- bibitem-note-fn-body-style -->
	
	
	<xsl:attribute-set name="references-non-normative-style">
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="line-height">120%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="line-height">145%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="line-height">120%</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- references-non-normative-style -->
	
</xsl:stylesheet>