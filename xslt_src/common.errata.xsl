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
	

	<!-- ============ -->
	<!-- errata -->
	<!-- ============ -->
	<xsl:template match="mn:errata">
		<!-- <row>
					<date>05-07-2013</date>
					<type>Editorial</type>
					<change>Changed CA-9 Priority Code from P1 to P2 in <xref target="tabled2"/>.</change>
					<pages>D-3</pages>
				</row>
		-->
		<fo:table table-layout="fixed" width="100%" font-size="10pt" border="1pt solid black">
			<fo:table-column column-width="20mm"/>
			<fo:table-column column-width="23mm"/>
			<fo:table-column column-width="107mm"/>
			<fo:table-column column-width="15mm"/>
			<fo:table-body>
				<fo:table-row text-align="center" font-weight="bold" background-color="black" color="white">
					<xsl:if test="$namespace = 'nist-cswp' or $namespace = 'nist-sp'">
						<xsl:attribute name="font-family">Arial</xsl:attribute>
					</xsl:if>
					<fo:table-cell border="1pt solid black"><fo:block role="SKIP">Date</fo:block></fo:table-cell>
					<fo:table-cell border="1pt solid black"><fo:block role="SKIP">Type</fo:block></fo:table-cell>
					<fo:table-cell border="1pt solid black"><fo:block role="SKIP">Change</fo:block></fo:table-cell>
					<fo:table-cell border="1pt solid black"><fo:block role="SKIP">Pages</fo:block></fo:table-cell>
				</fo:table-row>
				<xsl:apply-templates />
			</fo:table-body>
		</fo:table>
	</xsl:template>
	
	<xsl:template match="mn:errata/mn:row">
		<fo:table-row>
			<xsl:apply-templates />
		</fo:table-row>
	</xsl:template>

	<xsl:template match="mn:errata/mn:row/*">
		<fo:table-cell border="1pt solid black" padding-left="1mm" padding-top="0.5mm">
			<fo:block role="SKIP"><xsl:apply-templates /></fo:block>
		</fo:table-cell>
	</xsl:template>
	<!-- ============ -->
	<!-- END errata -->
	<!-- ============ -->




</xsl:stylesheet>