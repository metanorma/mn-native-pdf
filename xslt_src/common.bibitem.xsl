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
	
	
		<!-- ======================= -->
	<!-- Bibliography rendering -->
	<!-- ======================= -->
	
	<!-- ========================================================== -->
	<!-- Reference sections (Normative References and Bibliography) -->
	<!-- ========================================================== -->
	<xsl:template match="mn:references[@hidden='true']" priority="3"/>
	<xsl:template match="mn:bibitem[@hidden='true']" priority="3">
		<xsl:param name="skip" select="normalize-space(preceding-sibling::*[1][self::mn:bibitem] and 1 = 1)"/>
		<xsl:if test="$namespace = 'iso'">
			<xsl:if test="ancestor::mn:references[not(@normative='true')] or preceding-sibling::mn:references[1][not(@normative='true')]">
				<xsl:apply-templates select="following-sibling::*[1][self::mn:bibitem]">
					<xsl:with-param name="skip" select="$skip"/>
				</xsl:apply-templates>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<!-- don't display bibitem with @id starts with '_hidden', that was introduced for references integrity -->
	<xsl:template match="mn:bibitem[starts-with(@id, 'hidden_bibitem_')]" priority="3"/>
	
	<!-- Normative references -->
	<xsl:template match="mn:references[@normative='true']" priority="2">
		
		<xsl:if test="$namespace = 'nist-sp' or $namespace = 'nist-cswp'">
			<xsl:if test="not(ancestor::mn:annex)">
				<fo:block break-after="page"/>
			</xsl:if>
		</xsl:if>
		
		<xsl:call-template name="setNamedDestination"/>
		<fo:block id="{@id}">
			<xsl:apply-templates />
			
			<xsl:if test="$namespace = 'jis'">
				<!-- render footnotes after references -->
				<xsl:apply-templates select=".//mn:fn[generate-id(.)=generate-id(key('kfn',@reference)[1])]" mode="fn_after_element">
					<xsl:with-param name="ancestor">references</xsl:with-param>
				</xsl:apply-templates>
			</xsl:if>
		</fo:block>
	</xsl:template>
	
	<!-- Bibliography (non-normative references) -->
	<xsl:template match="mn:references">
		<xsl:if test="not(ancestor::mn:annex)">
			<xsl:choose>
				<xsl:when test="$namespace = 'bsi' or $namespace = 'ieee' or $namespace = 'iho' or $namespace = 'nist-cswp' or $namespace = 'nist-sp' or $namespace = 'unece' or $namespace = 'unece-rec'"></xsl:when>
				<xsl:when test="$namespace = 'jis'">
					<xsl:choose>
						<xsl:when test="following-sibling::mn:references or preceding-sibling::mn:references"></xsl:when>
						<xsl:otherwise>
							<fo:block break-after="page"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<fo:block break-after="page"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		
		<!-- <xsl:if test="ancestor::mn:annex">
			<xsl:if test="$namespace = 'csa' or $namespace = 'csd' or $namespace = 'gb' or $namespace = 'iec' or $namespace = 'iso' or $namespace = 'itu'">
				<fo:block break-after="page"/>
			</xsl:if>
		</xsl:if> -->
		
		<xsl:call-template name="setNamedDestination"/>
		<fo:block id="{@id}"/>
		
		<xsl:apply-templates select="mn:fmt-title[@columns = 1]"/>
		
		<fo:block xsl:use-attribute-sets="references-non-normative-style">
			<xsl:apply-templates select="node()[not(self::mn:fmt-title and @columns = 1)]" />
			
			<xsl:if test="$namespace = 'jis'">
				<!-- render footnotes after references -->
				<xsl:apply-templates select=".//mn:fn[generate-id(.)=generate-id(key('kfn',@reference)[1])]" mode="fn_after_element">
					<xsl:with-param name="ancestor">references</xsl:with-param>
				</xsl:apply-templates>
			</xsl:if>
		</fo:block>
		
		<xsl:if test="$namespace = 'gb' or $namespace = 'm3d'">
			<!-- horizontal line -->
			<fo:block-container text-align="center">
				<fo:block-container margin-left="63mm" width="42mm" border-bottom="2pt solid black">
					<fo:block>&#xA0;</fo:block>
				</fo:block-container>
			</fo:block-container>
		</xsl:if>
		
		<xsl:if test="$namespace = 'iec'">
			<!-- horizontal line -->
			<fo:block-container text-align="center" margin-top="10mm">
				<fo:block>_____________</fo:block>
			</fo:block-container>
		</xsl:if>
	</xsl:template> <!-- references -->
	
	
	
	<xsl:template match="mn:bibitem">
		<xsl:call-template name="bibitem"/>
	</xsl:template>
	
	<!-- Normative references -->
	<xsl:template match="mn:references[@normative='true']/mn:bibitem" name="bibitem" priority="2">
		<xsl:param name="skip" select="normalize-space(preceding-sibling::*[1][self::mn:bibitem] and 1 = 1)"/> <!-- current bibiitem is non-first -->
		<xsl:choose>
			<xsl:when test="$namespace = 'iho' or $namespace = 'nist-cswp'">
				<xsl:call-template name="setNamedDestination"/>
				<fo:list-block id="{@id}" xsl:use-attribute-sets="bibitem-normative-list-style">
					
					<xsl:variable name="docidentifier">
						<xsl:apply-templates select="mn:biblio-tag">
							<xsl:with-param name="biblio_tag_part">first</xsl:with-param>
						</xsl:apply-templates>
					</xsl:variable>
					
					<xsl:if test="$namespace = 'iho'">
						<xsl:attribute name="provisional-distance-between-starts">
							<xsl:choose>
								<xsl:when test="string-length($docidentifier) = 0">0mm</xsl:when>
								<xsl:when test="string-length($docidentifier) &gt; 19">46.5mm</xsl:when>
								<xsl:when test="string-length($docidentifier) &gt; 10">37mm</xsl:when>
								<xsl:otherwise>24.5mm</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
					</xsl:if>
					
					<fo:list-item>
						<fo:list-item-label end-indent="label-end()">
							<fo:block>
								<fo:inline>
									<xsl:copy-of select="$docidentifier"/>
								</fo:inline>
							</fo:block>
						</fo:list-item-label>
						<fo:list-item-body start-indent="body-start()">
							<fo:block xsl:use-attribute-sets="bibitem-normative-list-body-style">
								<xsl:call-template name="processBibitem">
									<xsl:with-param name="biblio_tag_part">last</xsl:with-param>
								</xsl:call-template>
							</fo:block>
						</fo:list-item-body>
					</fo:list-item>
				</fo:list-block>
			</xsl:when>
			
			<xsl:when test="$namespace = 'jis'">
				<xsl:call-template name="setNamedDestination"/>
				<fo:block-container margin-left="6mm" role="SKIP">
					<fo:block-container margin-left="0mm" role="SKIP">
						<fo:block id="{@id}" xsl:use-attribute-sets="bibitem-normative-style">
							<xsl:call-template name="processBibitem"/>
						</fo:block>
					</fo:block-container>
				</fo:block-container>
			</xsl:when>
			
			<xsl:when test="$namespace = 'itu'">
				<xsl:choose>
					<xsl:when test="$skip = 'true'"><!-- skip bibitem --></xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="setNamedDestination"/>
						<fo:block id="{@id}" xsl:use-attribute-sets="bibitem-normative-style">
							<xsl:call-template name="processBibitem"/>
						</fo:block>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			
			<xsl:otherwise>
				<xsl:call-template name="setNamedDestination"/>
				<fo:block id="{@id}" xsl:use-attribute-sets="bibitem-normative-style">
					<xsl:if test="$namespace = 'iso'">
						<xsl:if test="$layoutVersion = '2024'">
							<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
						</xsl:if>
					</xsl:if>
					<xsl:call-template name="processBibitem"/>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template> <!-- bibitem -->
	
	
	<xsl:if test="$namespace = 'iso'">
	<!-- start list for bibitem sequence -->
	<xsl:template match="mn:references[not(@normative='true')]/mn:bibitem[1]" priority="4">
		<xsl:variable name="list_items">
			<xsl:call-template name="insertListItem_Bibitem"/>
		</xsl:variable>
		<xsl:if test="normalize-space($list_items) != ''">
			<fo:list-block xsl:use-attribute-sets="bibitem-non-normative-list-style">
				<xsl:copy-of select="$list_items"/>
			</fo:list-block>
		</xsl:if>
	</xsl:template>
	</xsl:if>
	
	<!-- Bibliography (non-normative references) -->
	<xsl:template match="mn:references[not(@normative='true')]/mn:bibitem" name="bibitem_non_normative" priority="2">
		<xsl:param name="skip" select="normalize-space(preceding-sibling::*[not(self::mn:note)][1][self::mn:bibitem] and 1 = 1)"/> <!-- current bibiitem is non-first -->
		<xsl:choose>
			<xsl:when test="$namespace = 'bipm'">
				<!-- start BIPM bibitem processing -->
				<xsl:call-template name="setNamedDestination"/>
				<fo:list-block id="{@id}" xsl:use-attribute-sets="bibitem-non-normative-list-style">
					<fo:list-item>
						<fo:list-item-label end-indent="label-end()">
							<fo:block>
								<fo:inline>
									<xsl:apply-templates select="mn:biblio-tag">
										<xsl:with-param name="biblio_tag_part">first</xsl:with-param>
									</xsl:apply-templates>
								</fo:inline>
							</fo:block>
						</fo:list-item-label>
						<fo:list-item-body start-indent="body-start()">
							<fo:block>
								<xsl:call-template name="processBibitem">
									<xsl:with-param name="biblio_tag_part">last</xsl:with-param>
								</xsl:call-template>
							</fo:block>
						</fo:list-item-body>
					</fo:list-item>
				</fo:list-block>
				<!-- END BIPM bibitem processing -->
			</xsl:when>
			
			<xsl:when test="$namespace = 'csa'">
				<!-- start CSA bibitem processing -->
				<xsl:call-template name="setNamedDestination"/>
				<fo:block id="{@id}" xsl:use-attribute-sets="bibitem-non-normative-style">
					<xsl:apply-templates select="mn:biblio-tag"/>
					<xsl:apply-templates select="mn:formattedref"/>
					<!-- <xsl:call-template name="processBibliographyNote"/> -->
				</fo:block>
				<xsl:call-template name="processBibitemFollowingNotes"/>
				<!-- END CSA bibitem processing -->
			</xsl:when>
		
			<xsl:when test="$namespace = 'iho' or $namespace = 'nist-cswp'">
				<xsl:call-template name="bibitem"/>
			</xsl:when>
			
			<xsl:when test="$namespace = 'itu'">
				<xsl:choose>
					<xsl:when test="$skip = 'true'"><!-- skip bibitem --></xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="setNamedDestination"/>
						<fo:block id="{@id}" xsl:use-attribute-sets="bibitem-non-normative-style">
							<xsl:call-template name="processBibitem"/>
						</fo:block>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			
			<xsl:when test="$namespace = 'nist-sp' or $namespace = 'unece' or $namespace = 'unece-rec'">
				<xsl:call-template name="setNamedDestination"/>
				<fo:block id="{@id}" xsl:use-attribute-sets="bibitem-non-normative-style">
					<xsl:call-template name="processBibitem"/>
				</fo:block>
			</xsl:when>
			
			<xsl:when test="$namespace = 'rsd'">
				<xsl:call-template name="setNamedDestination"/>
				<fo:list-block id="{@id}" xsl:use-attribute-sets="bibitem-non-normative-list-style">
					<fo:list-item>
						<fo:list-item-label end-indent="label-end()">
							<fo:block>
								<xsl:apply-templates select="mn:biblio-tag">
									<xsl:with-param name="biblio_tag_part">first</xsl:with-param>
								</xsl:apply-templates>
							</fo:block>
						</fo:list-item-label>
						<fo:list-item-body start-indent="body-start()">
							<fo:block>
								<xsl:apply-templates select="mn:biblio-tag">
									<xsl:with-param name="biblio_tag_part">last</xsl:with-param>
								</xsl:apply-templates>
								<xsl:apply-templates select="mn:formattedref"/>
								<!-- <xsl:call-template name="processBibliographyNote"/> -->
							</fo:block>
							<xsl:call-template name="processBibitemFollowingNotes"/>
						</fo:list-item-body>
					</fo:list-item>
				</fo:list-block>
				 <!-- rsd -->
			</xsl:when>
			
			<xsl:when test="$namespace = 'iso'">
				<xsl:choose>
					<xsl:when test="$skip = 'true'"><!-- skip bibitem --></xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="insertListItem_Bibitem"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			
			<xsl:otherwise> <!-- $namespace = 'csd' or $namespace = 'gb' or $namespace = 'iec' or $namespace = 'ieee' or $namespace = 'iso' or $namespace = 'jcgm' or $namespace = 'm3d' or 
			$namespace = 'mpfd' or $namespace = 'ogc' or $namespace = 'ogc-white-paper' -->
				<!-- Example: [1] ISO 9:1995, Information and documentation – Transliteration of Cyrillic characters into Latin characters – Slavic and non-Slavic languages -->	
				<xsl:call-template name="setNamedDestination"/>
				<fo:list-block id="{@id}" xsl:use-attribute-sets="bibitem-non-normative-list-style">
					<xsl:if test="$namespace = 'ieee'">
						<xsl:variable name="bibitem_label">
							<xsl:apply-templates select="mn:biblio-tag">
								<xsl:with-param name="biblio_tag_part">first</xsl:with-param>
							</xsl:apply-templates>
						</xsl:variable>
						<xsl:if test="string-length(normalize-space($bibitem_label)) &gt; 5">
							<xsl:attribute name="provisional-distance-between-starts">12mm</xsl:attribute>
						</xsl:if>
					</xsl:if>
					<fo:list-item>
						<fo:list-item-label end-indent="label-end()">
							<fo:block role="SKIP">
								<fo:inline role="SKIP">
									<xsl:if test="$namespace = 'ieee'">
										<xsl:if test="($current_template = 'whitepaper' or $current_template = 'icap-whitepaper' or $current_template = 'industry-connection-report')">
											<xsl:attribute name="color"><xsl:value-of select="$color_blue"/></xsl:attribute>
										</xsl:if>
									</xsl:if>
									<xsl:apply-templates select="mn:biblio-tag">
										<xsl:with-param name="biblio_tag_part">first</xsl:with-param>
									</xsl:apply-templates>
								</fo:inline>
							</fo:block>
						</fo:list-item-label>
						<fo:list-item-body start-indent="body-start()">
							<fo:block xsl:use-attribute-sets="bibitem-non-normative-list-body-style" role="SKIP">
								<xsl:call-template name="processBibitem">
									<xsl:with-param name="biblio_tag_part">last</xsl:with-param>
								</xsl:call-template>
							</fo:block>
						</fo:list-item-body>
					</fo:list-item>
				</fo:list-block>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template> <!-- references[not(@normative='true')]/bibitem -->
	
	<!-- bibitem's notes will be processing in 'processBibitemFollowingNotes' -->
	<xsl:template match="mn:references/mn:note" priority="2"/> <!-- [not(@normative='true')] -->
	
	<xsl:template name="insertListItem_Bibitem">
		<xsl:choose>
			<xsl:when test="@hidden = 'true'"><!-- skip --></xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="setNamedDestination"/>
				<fo:list-item id="{@id}" xsl:use-attribute-sets="bibitem-non-normative-list-item-style">
					<xsl:if test="$namespace = 'iso'">
						<xsl:if test="$layoutVersion = '2024'">
							<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
						</xsl:if>
					</xsl:if>
					<fo:list-item-label end-indent="label-end()">
						<fo:block role="SKIP">
							<fo:inline role="SKIP">
								<xsl:apply-templates select="mn:biblio-tag">
									<xsl:with-param name="biblio_tag_part">first</xsl:with-param>
								</xsl:apply-templates>
							</fo:inline>
						</fo:block>
					</fo:list-item-label>
					<fo:list-item-body start-indent="body-start()">
						<fo:block xsl:use-attribute-sets="bibitem-non-normative-list-body-style"> <!-- role="SKIP" -->
							<xsl:call-template name="processBibitem">
								<xsl:with-param name="biblio_tag_part">last</xsl:with-param>
							</xsl:call-template>
						</fo:block>
						<xsl:call-template name="processBibitemFollowingNotes"/>
					</fo:list-item-body>
				</fo:list-item>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:apply-templates select="following-sibling::*[self::mn:bibitem][1]">
			<xsl:with-param name="skip">false</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template name="processBibitem">
		<xsl:param name="biblio_tag_part">both</xsl:param>
		
		<xsl:choose>
			
			<xsl:when test="$namespace ='itu'">
				<!-- start ITU bibitem processing -->
				<!-- Example: [ITU-T A.23]	ITU-T A.23, Recommendation ITU-T A.23, Annex A (2014), Guide for ITU-T and ISO/IEC JTC 1 cooperation. -->
				<xsl:variable name="doctype" select="ancestor::mn:metanorma/mn:bibdata/mn:ext/mn:doctype[not(@language) or @language = '']"/>
				<xsl:if test="$doctype = 'implementers-guide'">
					<xsl:attribute name="margin-left">0mm</xsl:attribute>
					<xsl:attribute name="text-indent">0mm</xsl:attribute>
				</xsl:if>
				
				<xsl:variable name="docidentifier_metanorma_ordinal" select="normalize-space(mn:docidentifier[@type = 'metanorma-ordinal'])"/>
				
				<xsl:variable name="bibitem_label">
					<xsl:apply-templates select="mn:biblio-tag">
						<xsl:with-param name="biblio_tag_part">first</xsl:with-param>
					</xsl:apply-templates>
				</xsl:variable>
				
				<xsl:variable name="bibitem_body">
					<xsl:apply-templates select="mn:biblio-tag">
						<xsl:with-param name="biblio_tag_part">last</xsl:with-param>
					</xsl:apply-templates>
					<xsl:apply-templates select="mn:formattedref"/>
					<xsl:call-template name="processBibitemFollowingNotes"/>
				</xsl:variable>
				
				<xsl:choose>
					<xsl:when test="$doctype = 'implementers-guide'">
						<fo:table width="100%" table-layout="fixed">
							<fo:table-column column-width="20%"/>
							<fo:table-column column-width="80%"/>
							<fo:table-body>
								<fo:table-row>
									<fo:table-cell><fo:block role="SKIP"><xsl:value-of select="$bibitem_label"/></fo:block></fo:table-cell>
									<fo:table-cell><fo:block role="SKIP"><xsl:copy-of select="$bibitem_body"/></fo:block></fo:table-cell>
								</fo:table-row>
							</fo:table-body>
						</fo:table>
					</xsl:when> <!-- $doctype = 'implementers-guide' -->
					<xsl:when test="$bibitem_label != $docidentifier_metanorma_ordinal">
						<xsl:attribute name="margin-left">14mm</xsl:attribute>
						<xsl:attribute name="text-indent">-14mm</xsl:attribute>
						<xsl:copy-of select="$bibitem_label"/>
						<xsl:copy-of select="$bibitem_body"/>
					</xsl:when>
					<xsl:otherwise>
						<fo:list-block provisional-distance-between-starts="14mm">
							<fo:list-item>
								<fo:list-item-label end-indent="label-end()">
									<fo:block>
										<xsl:value-of select="$bibitem_label"/>
									</fo:block>
								</fo:list-item-label>
								<fo:list-item-body start-indent="body-start()">
									<fo:block>
										<xsl:copy-of select="$bibitem_body"/>
									</fo:block>
									<xsl:call-template name="processBibitemFollowingNotes"/>
								</fo:list-item-body>
							</fo:list-item>
						</fo:list-block>
					</xsl:otherwise>
				</xsl:choose>
				<!-- end ITU bibitem processing -->
			</xsl:when>
			
			<xsl:when test="$namespace = 'jis'">
				<xsl:if test=".//mn:fn">
					<xsl:attribute name="line-height-shift-adjustment">disregard-shifts</xsl:attribute>
				</xsl:if>
				<fo:inline font-weight="bold">
					<xsl:if test="not($vertical_layout = 'true')">
						<xsl:attribute name="font-family">Times New Roman</xsl:attribute>
					</xsl:if>
					<xsl:apply-templates select="mn:biblio-tag">
						<xsl:with-param name="biblio_tag_part" select="$biblio_tag_part"/>
					</xsl:apply-templates>
				</fo:inline>
				<xsl:apply-templates select="mn:formattedref"/>
				<xsl:call-template name="processBibitemFollowingNotes"/>
			</xsl:when>

			<xsl:when test="$namespace = 'nist-sp'">
				<!-- start NIST SP bibitem processing -->
				<xsl:variable name="docidentifier">
					<xsl:apply-templates select="mn:biblio-tag">
						<xsl:with-param name="biblio_tag_part">first</xsl:with-param>
					</xsl:apply-templates>
				</xsl:variable>
				<xsl:if test="$docidentifier != ''">
					<fo:inline padding-right="5mm"><xsl:value-of select="$docidentifier"/></fo:inline>
				</xsl:if>
				<xsl:apply-templates select="mn:biblio-tag">
					<xsl:with-param name="biblio_tag_part">last</xsl:with-param>
				</xsl:apply-templates>
				<xsl:apply-templates select="mn:formattedref"/>
				<xsl:call-template name="processBibitemFollowingNotes"/>
				<!-- END NIST SP bibitem processing -->
			</xsl:when>
			
			<xsl:when test="$namespace = 'unece' or $namespace = 'unece-rec'">
				<!-- start UNECE bibitem processing -->
				<fo:inline padding-right="5mm">
					<xsl:apply-templates select="mn:biblio-tag">
						<xsl:with-param name="biblio_tag_part">first</xsl:with-param>
					</xsl:apply-templates>
				</fo:inline>
				<xsl:apply-templates select="mn:biblio-tag">
					<xsl:with-param name="biblio_tag_part">last</xsl:with-param>
				</xsl:apply-templates>
				
				<xsl:apply-templates select="un:formattedref"/>
				<xsl:call-template name="processBibitemFollowingNotes"/>
				<!-- END UNECE bibitem processing -->
			</xsl:when>
			
			<!-- for bipm, csa, csd, iec, iho, iso, m3d, mpfd, nist-cswp, ogc, ogc-white-paper, rsd and other  -->
			<xsl:otherwise>
				<!-- start bibitem processing -->
				<xsl:if test=".//mn:fn">
					<xsl:attribute name="line-height-shift-adjustment">disregard-shifts</xsl:attribute>
				</xsl:if>
				
				<xsl:if test="$namespace = 'bsi' or $namespace = 'jcgm'">
					<!-- move opening ace-tag before number -->
					<xsl:apply-templates select="mn:formattedref/node()[1][self::mn:add and contains(., '_start')]">
						<xsl:with-param name="skip">false</xsl:with-param>
					</xsl:apply-templates>
				</xsl:if>
				
				<xsl:apply-templates select="mn:biblio-tag">
					<xsl:with-param name="biblio_tag_part" select="$biblio_tag_part"/>
				</xsl:apply-templates>
				<xsl:apply-templates select="mn:formattedref"/>
				
				<xsl:choose>
					<xsl:when test="$namespace = 'iso'">
						<xsl:if test="ancestor::mn:references[@normative = 'true']">
							<xsl:call-template name="processBibitemFollowingNotes"/>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="processBibitemFollowingNotes"/>
					</xsl:otherwise>
				</xsl:choose>
				<!-- end bibitem processing -->
			</xsl:otherwise>
			
		</xsl:choose>
		
		<!-- <xsl:call-template name="processBibliographyNote"/> -->
	</xsl:template> <!-- processBibitem (bibitem) -->
	
	<xsl:template name="processBibliographyNote">
		<xsl:if test="self::mn:note">
			<xsl:call-template name="note"/>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="processBibitemFollowingNotes">
		<!-- current context is bibitem element -->
		<xsl:variable name="bibitem_id" select="@id"/>
		<xsl:for-each select="following-sibling::mn:note[preceding-sibling::mn:bibitem[1][@id = $bibitem_id]]">
			<xsl:call-template name="note"/>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="mn:title" mode="title">
		<fo:inline><xsl:apply-templates /></fo:inline>
	</xsl:template>

	
	<xsl:template match="mn:bibitem/mn:docidentifier"/>
	
	<xsl:template match="mn:formattedref">
		<!-- <xsl:if test="$namespace = 'unece' or $namespace = 'unece-rec'">
			<xsl:text>, </xsl:text>
		</xsl:if> -->
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="mn:biblio-tag">
		<xsl:param name="biblio_tag_part">both</xsl:param>
		<xsl:choose>
			<xsl:when test="$biblio_tag_part = 'first' and mn:tab">
				<xsl:apply-templates select="./mn:tab[1]/preceding-sibling::node()"/>
			</xsl:when>
			<xsl:when test="$biblio_tag_part = 'last'">
				<xsl:apply-templates select="./mn:tab[1]/following-sibling::node()"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="mn:biblio-tag/mn:tab" priority="2">
		<xsl:text> </xsl:text>
	</xsl:template>

	<!-- ======================= -->
	<!-- END Bibliography rendering -->
	<!-- ======================= -->
	
	<!-- ========================================================== -->
	<!-- END Reference sections (Normative References and Bibliography) -->
	<!-- ========================================================== -->
	
</xsl:stylesheet>