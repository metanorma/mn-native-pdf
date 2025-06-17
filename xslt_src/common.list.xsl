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
	

	<xsl:attribute-set name="list-style">
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="provisional-distance-between-starts">7mm</xsl:attribute>
			<xsl:attribute name="margin-top">8pt</xsl:attribute>
			<xsl:attribute name="line-height">1.4</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="provisional-distance-between-starts">6.5mm</xsl:attribute>
			<xsl:attribute name="line-height">145%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csd'">
			<xsl:attribute name="provisional-distance-between-starts">6.5mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="provisional-distance-between-starts">4mm</xsl:attribute>
			<xsl:attribute name="margin-left">7.4mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="provisional-distance-between-starts">6mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="provisional-distance-between-starts">8mm</xsl:attribute>
			<xsl:attribute name="margin-top">8pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="provisional-distance-between-starts">6mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="provisional-distance-between-starts">7mm</xsl:attribute>
			<xsl:attribute name="margin-top">8pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jcgm'">
			<xsl:attribute name="provisional-distance-between-starts">7mm</xsl:attribute>
			<xsl:attribute name="margin-top">8pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:attribute name="provisional-distance-between-starts">7.5mm</xsl:attribute>
			<xsl:attribute name="space-after">4pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'm3d'">
			<xsl:attribute name="provisional-distance-between-starts">6mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'mpfd'">
			<xsl:attribute name="provisional-distance-between-starts">6mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp'">
		</xsl:if>
		<xsl:if test="$namespace = 'nist-sp'">
			<xsl:attribute name="space-after">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="provisional-distance-between-starts">12mm</xsl:attribute>
			<xsl:attribute name="space-after">12pt</xsl:attribute>
			<xsl:attribute name="line-height">115%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:attribute name="provisional-distance-between-starts">6.5mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="line-height">115%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'plateau'">
			<xsl:attribute name="provisional-distance-between-starts">7mm</xsl:attribute>
			<xsl:attribute name="space-after">20pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="provisional-distance-between-starts">6mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece'">
			<xsl:attribute name="provisional-distance-between-starts">4mm</xsl:attribute>
			<xsl:attribute name="margin-left">-8mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece-rec'">
			<xsl:attribute name="provisional-distance-between-starts">3.5mm</xsl:attribute>
			<xsl:attribute name="margin-left">7mm</xsl:attribute>
			<xsl:attribute name="text-indent">0mm</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- list-style -->
	
	<xsl:template name="refine_list-style">
		<xsl:if test="$namespace = 'csd'">
			<xsl:if test="ancestor::mn:ol">
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			</xsl:if>
		</xsl:if>		
		<xsl:if test="$namespace = 'iec'">
			<xsl:if test="ancestor::mn:ul or ancestor::mn:ol">
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:if test="not(ancestor::*[self::mn:ul or self::mn:ol])">
				<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-sp'">
			<xsl:if test="ancestor::mn:figure and not(following-sibling::*)">
				<xsl:attribute name="space-after">0pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'plateau'">
			<xsl:if test="ancestor::mn:table">
				<xsl:attribute name="provisional-distance-between-starts">4.5mm</xsl:attribute>
				<xsl:attribute name="space-after">0pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template> <!-- refine_list-style -->

	
	<xsl:attribute-set name="list-name-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="margin-top">8pt</xsl:attribute>
		</xsl:if>	
		<xsl:if test="$namespace = 'itu' or $namespace = 'csd' or $namespace = 'm3d'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="font-weight">normal</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="font-weight">normal</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee' or $namespace = 'iso' or $namespace = 'jcgm'">
			<xsl:attribute name="margin-top">8pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>		
		<xsl:if test="$namespace = 'nist-cswp'  or $namespace = 'nist-sp'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">							
			<xsl:attribute name="font-weight">normal</xsl:attribute>
			<xsl:attribute name="color"><xsl:value-of select="$color_text_title"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:attribute name="color">rgb(68, 84, 106)</xsl:attribute>
			<xsl:attribute name="font-weight">normal</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece'">
			<xsl:attribute name="font-weight">normal</xsl:attribute>
		</xsl:if>		
		<xsl:if test="$namespace = 'unece-rec'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'mpfd'">
		</xsl:if>
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-weight">300</xsl:attribute>
			<xsl:attribute name="color">black</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- list-name-style -->
	
	<xsl:attribute-set name="list-item-style">
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="margin-bottom">3pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="space-after">4pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:template name="refine_list-item-style">
		<xsl:if test="$namespace = 'bsi'">
			<xsl:if test="$document_type = 'PAS'">
				<xsl:attribute name="space-after">2pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template> <!-- refine_list-item-style -->
	
	<xsl:attribute-set name="list-item-label-style">
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="line-height">115%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:attribute name="line-height">1.5</xsl:attribute>
		</xsl:if>
		
		<xsl:if test="$namespace = 'nist-sp'">
			<xsl:attribute name="display-align">center</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="color"><xsl:value-of select="$color_blue"/></xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>

	
	<xsl:template name="refine_list-item-label-style">
		<xsl:if test="$namespace = 'bsi'">
			<xsl:if test="$document_type = 'PAS' and not(ancestor::*[self::mn:note or self::mn:termnote])">
				<xsl:attribute name="color"><xsl:value-of select="$color_list_label_PAS"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="$document_type = 'PAS'">
				<xsl:attribute name="id">__internal_layout__li_<xsl:value-of select="generate-id()"/>_<xsl:value-of select="ancestor::*[@id][1]/@id"/></xsl:attribute>
			</xsl:if>
		</xsl:if>
	
		<xsl:if test="$namespace = 'ieee'">
			<xsl:if test="$current_template = 'whitepaper' or $current_template = 'icap-whitepaper' or $current_template = 'industry-connection-report'">
				<xsl:attribute name="color">rgb(128,128,128)</xsl:attribute>
				<xsl:attribute name="line-height">1.1</xsl:attribute>
				<xsl:if test=".//mn:fn">
					<xsl:attribute name="line-height">1.4</xsl:attribute>
				</xsl:if>
			</xsl:if>
		</xsl:if>
	
		<xsl:if test="$namespace = 'jis'">
			<xsl:if test="parent::mn:ol and not($vertical_layout = 'true')">
				<xsl:attribute name="font-family">Times New Roman</xsl:attribute>
				<xsl:attribute name="font-weight">bold</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template> <!-- refine_list-item-label-style -->

	
	<xsl:attribute-set name="list-item-body-style">
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="line-height-shift-adjustment">disregard-shifts</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="line-height-shift-adjustment">disregard-shifts</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="line-height-shift-adjustment">disregard-shifts</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="line-height-shift-adjustment">disregard-shifts</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:template name="refine_list-item-body-style">
		<xsl:if test="$namespace = 'bsi'">
			<xsl:if test="*[last()][self::mn:note]">
				<xsl:attribute name="margin-bottom">5pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="margin-bottom">10pt</xsl:attribute>
			<xsl:if test="ancestor::mn:table[not(@class)]">
				<xsl:attribute name="margin-bottom">1mm</xsl:attribute>
			</xsl:if>
			<xsl:if test="not(following-sibling::*) and not(../following-sibling::*)">
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template> <!-- refine_list-item-body-style -->

	
</xsl:stylesheet>