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
			<xsl:attribute name="provisional-distance-between-starts">7mm</xsl:attribute>
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
		<xsl:if test="$namespace = 'ieee'">
			<xsl:if test="parent::mn:admonition[@type = 'commentary']">
				<xsl:attribute name="margin-left">7mm</xsl:attribute>
			</xsl:if>
			<xsl:if test="preceding-sibling::*[1][self::mn:p]">
				<!-- <xsl:attribute name="margin-top">6pt</xsl:attribute> -->
				<xsl:attribute name="margin-top">12pt</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="ancestor::mn:note or ancestor::mn:termnote">
				<xsl:attribute name="provisional-distance-between-starts">4mm</xsl:attribute>
			</xsl:if>
			
			<xsl:variable name="processing_instruction_type" select="normalize-space(preceding-sibling::*[1]/processing-instruction('list-type'))"/>
			<xsl:if test="self::mn:ul and normalize-space($processing_instruction_type) = 'simple'">
				<xsl:attribute name="provisional-distance-between-starts">0mm</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="$current_template = 'whitepaper' or $current_template = 'icap-whitepaper' or $current_template = 'industry-connection-report'">
				<xsl:attribute name="line-height">1.3</xsl:attribute>
				<xsl:attribute name="margin-left">6.2mm</xsl:attribute>
				<xsl:attribute name="provisional-distance-between-starts">6.5mm</xsl:attribute>
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
		<xsl:if test="$namespace = 'iho'">
			<xsl:if test="ancestor::mn:table">
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
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


	<!-- ===================================== -->
	<!-- Lists processing -->
	<!-- ===================================== -->
	<xsl:variable name="ul_labels_">
		<xsl:choose>
			<xsl:when test="$namespace = 'bipm'">
				<label level="1" font-size="15pt">•</label>
				<label level="2">&#x2212;</label><!-- &#x2212; - minus sign.  &#x2014; - en dash -->
				<label level="3" font-size="75%">o</label> <!-- white circle -->
			</xsl:when>
			<xsl:when test="$namespace = 'bsi'">
				<label>
					<xsl:choose>
						<xsl:when test="$document_type = 'PAS'">•</xsl:when> <!-- bullet -->
						<xsl:otherwise>•</xsl:otherwise> <!-- &#x2014; em dash -->
					</xsl:choose>
				</label>
			</xsl:when>
			<xsl:when test="$namespace = 'csa'">
				<label level="1">•</label>
				<label level="2">-</label><!-- minus -->
				<label level="3" font-size="75%">o</label> <!-- white circle -->
			</xsl:when>
			<xsl:when test="$namespace = 'csd'">
				<label>&#x2014;</label> <!-- em dash -->
			</xsl:when>
			<xsl:when test="$namespace = 'gb'">
				<label>&#x2014;</label> <!-- em dash -->
			</xsl:when>
			<xsl:when test="$namespace = 'iec'">
				<label level="1" font-size="10pt">•</label>
				<label level="2" font-size="10pt">&#x2014;</label><!-- em dash -->
				<label level="3" font-size="75%">o</label> <!-- white circle -->
			</xsl:when>
			<xsl:when test="$namespace = 'ieee'">
				<xsl:choose>
					<xsl:when test="$current_template = 'whitepaper' or $current_template = 'icap-whitepaper' or $current_template = 'industry-connection-report'">
						<label level="1" font-size="14pt" color="rgb(128,128,128)">▪</label> <!-- Black small square 25AA  18pt  line-height="1.5" -->
						<label level="2">&#x2014;</label><!-- em dash --> 
					</xsl:when>
					<xsl:otherwise>
						<label>–</label>
						<!-- <label level="1">–</label>
						<label level="2">•</label>
						<label level="3" font-size="75%">o</label> --> <!-- white circle -->
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$namespace = 'iho'">
				<!-- <label>&#x2014;</label> --> <!-- em dash -->
				<label level="1" font-size="150%" line-height="80%">•</label>
				<label level="2">&#x2014;</label><!-- em dash -->
				<label level="3" font-size="75%">o</label> <!-- white circle -->
			</xsl:when>
			<xsl:when test="$namespace = 'iso'">
				<xsl:choose>
					<xsl:when test="$layoutVersion = '1951'">
						<label>&#x2013;</label> <!-- en dash -->
					</xsl:when>
					<xsl:otherwise>
						<label>&#x2014;</label> <!-- em dash -->
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$namespace = 'jcgm'">
				<label level="1">&#x2014;</label> <!-- em dash -->
				<label level="2">&#x2212;</label><!-- minus sign -->
				<label level="3" font-size="75%">o</label> <!-- white circle -->
			</xsl:when>
			<xsl:when test="$namespace = 'jis' or $namespace = 'plateau'">
				<label level="1">－</label> <!-- full-width hyphen minus -->
				<label level="2" font-size="130%" line-height="1.2">・</label> <!-- Katakana Middle Dot -->
			</xsl:when>
			<xsl:when test="$namespace = 'm3d'">
				<label font-size="18pt" margin-top="-0.5mm">•</label> <!-- margin-top to vertical align big dot -->
			</xsl:when>
			<xsl:when test="$namespace = 'mpfd'">
				<label>&#x2014;</label> <!-- em dash -->
			</xsl:when>
			<xsl:when test="$namespace = 'nist-cswp'">
				<label>•</label>
			</xsl:when>
			<xsl:when test="$namespace = 'nist-sp'">
				<label>•</label>
			</xsl:when>
			<xsl:when test="$namespace = 'ogc'">
				<label color="{$color_design}">•</label>
			</xsl:when>
			<xsl:when test="$namespace = 'ogc-white-paper'">
				<label>&#x2014;</label> <!-- em dash -->
			</xsl:when>
			<!-- <xsl:when test="$namespace = 'plateau'">
				<xsl:choose>
					<xsl:when test="$doctype = 'technical-report'">
						<label level="1" font-size="130%" line-height="1.2">・</label> - Katakana Middle Dot -
						<label level="2">→</label> - will be replaced in the template 'li' -
						<label level="3">☆</label> - will be replaced in the template 'li' -
					</xsl:when>
					<xsl:otherwise>
						<label level="1" font-size="130%" line-height="1.2">・</label> - Katakana Middle Dot -
						<label level="2">－</label> - full-width hyphen minus -
						<label level="3" font-size="130%" line-height="1.2">・</label>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when> -->
			<xsl:when test="$namespace = 'rsd'">
				<label level="1" font-size="75%">o</label> <!-- white circle -->
				<label level="2">&#x2014;</label> <!-- em dash -->
				<label level="3" font-size="140%">&#x2022;</label> <!-- bullet -->
			</xsl:when>
			<xsl:when test="$namespace = 'unece'">
				<label>•</label>
			</xsl:when>
			<xsl:when test="$namespace = 'unece-rec'">
				<label>•</label>
			</xsl:when>
			<xsl:otherwise>
				<label level="1">–</label>
				<label level="2">•</label>
				<label level="3" font-size="75%">o</label> <!-- white circle -->
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="ul_labels" select="xalan:nodeset($ul_labels_)"/>

	<xsl:template name="setULLabel">
		<xsl:variable name="list_level__">
			<xsl:choose>
				<xsl:when test="$namespace = 'jis' or $namespace = 'plateau'"><xsl:value-of select="count(ancestor::mn:ul)"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="count(ancestor::mn:ul) + count(ancestor::mn:ol)" /></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="list_level_" select="number($list_level__)"/>
		<xsl:variable name="list_level">
			<xsl:choose>
				<xsl:when test="$list_level_ &lt;= 3"><xsl:value-of select="$list_level_"/></xsl:when>
				<xsl:when test="$ul_labels/label[@level = 3]"><xsl:value-of select="$list_level_ mod 3"/></xsl:when>
				<xsl:when test="$list_level_ mod 2 = 0">2</xsl:when>
				<xsl:otherwise><xsl:value-of select="$list_level_ mod 2"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$ul_labels/label[not(@level)]"> <!-- one label for all levels -->
				<xsl:apply-templates select="$ul_labels/label[not(@level)]" mode="ul_labels"/>
			</xsl:when>
			<xsl:when test="$list_level mod 3 = 0 and $ul_labels/label[@level = 3]">
				<xsl:apply-templates select="$ul_labels/label[@level = 3]" mode="ul_labels"/>
			</xsl:when>
			<xsl:when test="$list_level mod 3 = 0">
				<xsl:apply-templates select="$ul_labels/label[@level = 1]" mode="ul_labels"/>
			</xsl:when>
			<xsl:when test="$list_level mod 2 = 0">
				<xsl:apply-templates select="$ul_labels/label[@level = 2]" mode="ul_labels"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="$ul_labels/label[@level = 1]" mode="ul_labels"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="label" mode="ul_labels">
		<xsl:copy-of select="@*[not(local-name() = 'level')]"/>
		<xsl:value-of select="."/>
	</xsl:template>

	<xsl:template name="getListItemFormat">
		<!-- Example: for BSI <?list-type loweralpha?> -->
		<xsl:variable name="processing_instruction_type" select="normalize-space(../preceding-sibling::*[1]/processing-instruction('list-type'))"/>
		<xsl:choose>
			<xsl:when test="local-name(..) = 'ul'">
				<xsl:choose>
					<xsl:when test="normalize-space($processing_instruction_type) = 'simple'"></xsl:when>
					<!-- https://github.com/metanorma/isodoc/issues/675 -->
					<xsl:when test="@label"><xsl:value-of select="@label"/></xsl:when>
					<xsl:otherwise><xsl:call-template name="setULLabel"/></xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<!-- https://github.com/metanorma/isodoc/issues/675 -->
			<xsl:when test="local-name(..) = 'ol' and @label and @full = 'true'"> <!-- @full added in the template li/fmt-name -->
				<xsl:value-of select="@label"/>
			</xsl:when>
			<xsl:when test="local-name(..) = 'ol' and @label"> <!-- for ordered lists 'ol', and if there is @label, for instance label="1.1.2" -->
				
				<xsl:variable name="type" select="../@type"/>
				
				<xsl:variable name="label">
					
					<xsl:variable name="style_prefix_">
						<xsl:if test="$type = 'roman'">
							<xsl:if test="$namespace = 'bipm'">(</xsl:if> <!-- Example: (i) -->
						</xsl:if>
						<xsl:if test="$type = 'alphabet'">
							<xsl:if test="$namespace = 'iso'">
								<xsl:if test="$layoutVersion = '1951'">(</xsl:if> <!-- Example: (a) -->
							</xsl:if>
						</xsl:if>
					</xsl:variable>
					<xsl:variable name="style_prefix" select="normalize-space($style_prefix_)"/>
					
					<xsl:variable name="style_suffix_">
						<xsl:choose>
							<xsl:when test="$type = 'arabic'">
								<xsl:choose>
									<xsl:when test="$namespace = 'bipm' or $namespace = 'jcgm' or $namespace = 'm3d' or 
									$namespace = 'mpfd' or $namespace = 'ogc' or $namespace = 'rsd' or $namespace = 'unece' or $namespace = 'nist-cswp' or $namespace = 'nist-sp'">.</xsl:when> <!-- Example: 1. -->
									<xsl:otherwise>)</xsl:otherwise> <!-- Example: 1) -->
								</xsl:choose>
							</xsl:when>
							<xsl:when test="$type = 'alphabet' or $type = 'alphabetic'">
								<xsl:choose>
									<xsl:when test="$namespace = 'rsd'">.</xsl:when> <!-- Example: a. -->
									<xsl:otherwise>)</xsl:otherwise> <!-- Example: a) -->
								</xsl:choose>
							</xsl:when>
							<xsl:when test="$type = 'alphabet_upper' or $type = 'alphabetic_upper'">
								<xsl:choose>
									<xsl:when test="$namespace = 'csa' or $namespace = 'nist-cswp' or $namespace = 'nist-sp' or $namespace = 'ogc' or $namespace = 'ogc-white-paper'">)</xsl:when> <!-- Example: A) -->
									<xsl:otherwise>.</xsl:otherwise> <!-- Example: A. -->
								</xsl:choose>
							</xsl:when>
							<xsl:when test="$type = 'roman'">
								<xsl:choose>
									<xsl:when test="$namespace = 'rsd'">.</xsl:when> <!-- Example: i. -->
									<xsl:otherwise>)</xsl:otherwise> <!-- Example: (i) or i) -->
								</xsl:choose>
							</xsl:when>
							<xsl:when test="$type = 'roman_upper'">.</xsl:when> <!-- Example: I. -->
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="style_suffix" select="normalize-space($style_suffix_)"/>
					
					<xsl:if test="$style_prefix != '' and not(starts-with(@label, $style_prefix))">
						<xsl:value-of select="$style_prefix"/>
					</xsl:if>
					
					<xsl:value-of select="@label"/>
					
					<xsl:if test="not(java:endsWith(java:java.lang.String.new(@label),$style_suffix))">
						<xsl:value-of select="$style_suffix"/>
					</xsl:if>
				</xsl:variable>
				
				
				<xsl:choose>
					<xsl:when test="$namespace = 'iso'">
						<xsl:choose>
							<xsl:when test="$layoutVersion = '1951' and $type = 'alphabet'">(<fo:inline font-style="italic"><xsl:value-of select="@label"/></fo:inline>)</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="normalize-space($label)"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="normalize-space($label)"/>
					</xsl:otherwise>
				</xsl:choose>
				
			</xsl:when>
			<xsl:otherwise> <!-- for ordered lists 'ol' -->
			
				<!-- Example: for BSI <?list-start 2?> -->
				<xsl:variable name="processing_instruction_start" select="normalize-space(../preceding-sibling::*[1]/processing-instruction('list-start'))"/>

				<xsl:variable name="start_value">
					<xsl:choose>
						<xsl:when test="normalize-space($processing_instruction_start) != ''">
							<xsl:value-of select="number($processing_instruction_start) - 1"/><!-- if start="3" then start_value=2 + xsl:number(1) = 3 -->
						</xsl:when>
						<xsl:when test="normalize-space(../@start) != ''">
							<xsl:value-of select="number(../@start) - 1"/><!-- if start="3" then start_value=2 + xsl:number(1) = 3 -->
						</xsl:when>
						<xsl:otherwise>0</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				
				<xsl:variable name="curr_value"><xsl:number/></xsl:variable>
				
				<xsl:variable name="type">
					<xsl:choose>
						<xsl:when test="normalize-space($processing_instruction_type) != ''"><xsl:value-of select="$processing_instruction_type"/></xsl:when>
						<xsl:when test="normalize-space(../@type) != ''"><xsl:value-of select="../@type"/></xsl:when>
						
						<xsl:otherwise> <!-- if no @type or @class = 'steps' -->
							
							<xsl:variable name="list_level_" select="count(ancestor::mn:ul) + count(ancestor::mn:ol)" />
							<xsl:variable name="list_level">
								<xsl:choose>
									<xsl:when test="$list_level_ &lt;= 5"><xsl:value-of select="$list_level_"/></xsl:when>
									<xsl:otherwise><xsl:value-of select="$list_level_ mod 5"/></xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							
							<xsl:choose>
								<xsl:when test="$list_level mod 5 = 0">roman_upper</xsl:when> <!-- level 5 -->
								<xsl:when test="$list_level mod 4 = 0">alphabet_upper</xsl:when> <!-- level 4 -->
								<xsl:when test="$list_level mod 3 = 0">roman</xsl:when> <!-- level 3 -->
								<xsl:when test="$list_level mod 2 = 0 and ancestor::*/@class = 'steps'">alphabet</xsl:when> <!-- level 2 and @class = 'steps'-->
								<xsl:when test="$list_level mod 2 = 0">arabic</xsl:when> <!-- level 2 -->
								<xsl:otherwise> <!-- level 1 -->
									<xsl:choose>
										<xsl:when test="ancestor::*/@class = 'steps'">arabic</xsl:when>
										<xsl:otherwise>alphabet</xsl:otherwise>
									</xsl:choose>
								</xsl:otherwise>
							</xsl:choose>
							
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				
				<xsl:variable name="format">
					<xsl:choose>
						<xsl:when test="$type = 'arabic'">
							<xsl:choose>
								<xsl:when test="$namespace = 'bipm' or $namespace = 'jcgm' or $namespace = 'm3d' or 
								$namespace = 'mpfd' or $namespace = 'ogc' or $namespace = 'rsd' or $namespace = 'unece' or $namespace = 'nist-cswp' or $namespace = 'nist-sp'">1.</xsl:when>
								<xsl:otherwise>1)</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="$type = 'alphabet' or $type = 'alphabetic'">
							<xsl:choose>
								<xsl:when test="$namespace = 'rsd'">a.</xsl:when>
								<xsl:otherwise>a)</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="$type = 'alphabet_upper' or $type = 'alphabetic_upper'">
							<xsl:choose>
								<xsl:when test="$namespace = 'csa' or $namespace = 'nist-cswp' or $namespace = 'nist-sp' or $namespace = 'ogc' or $namespace = 'ogc-white-paper'">A)</xsl:when>
								<xsl:otherwise>A.</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="$type = 'roman'">
							<xsl:choose>
								<xsl:when test="$namespace = 'bipm'">(i)</xsl:when>
								<xsl:when test="$namespace = 'rsd'">i.</xsl:when>
								<xsl:otherwise>i)</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="$type = 'roman_upper'">I.</xsl:when>
						<xsl:otherwise>1.</xsl:otherwise> <!-- for any case, if $type has non-determined value, not using -->
					</xsl:choose>
				</xsl:variable>
				
				<xsl:number value="$start_value + $curr_value" format="{normalize-space($format)}" lang="en"/>
				
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- getListItemFormat -->

	<xsl:template match="mn:ul | mn:ol">
		<xsl:param name="indent">0</xsl:param>
		<xsl:choose>
			<xsl:when test="parent::mn:note or parent::mn:termnote">
				<fo:block-container role="SKIP">
					<xsl:attribute name="margin-left">
						<xsl:choose>
							<xsl:when test="not(ancestor::mn:table)"><xsl:value-of select="$note-body-indent"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="$note-body-indent-table"/></xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					
					<xsl:call-template name="refine_list_container_style"/>
					
					<fo:block-container margin-left="0mm" role="SKIP">
						<fo:block>
							<xsl:apply-templates select="." mode="list">
								<xsl:with-param name="indent" select="$indent"/>
							</xsl:apply-templates>
						</fo:block>
					</fo:block-container>
				</fo:block-container>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$namespace = 'ieee'">
						<fo:block-container margin-left="4mm">
							<fo:block-container margin-left="0mm">
								<fo:block role="SKIP">
									<xsl:apply-templates select="." mode="list">
										<xsl:with-param name="indent" select="$indent"/>
									</xsl:apply-templates>
								</fo:block>
							</fo:block-container>
						</fo:block-container>
					</xsl:when>
					<xsl:when test="$namespace = 'iso'">
						<xsl:choose>
							<xsl:when test="$layoutVersion = '1951' and self::mn:ul">
								<fo:block-container margin-left="8mm">
									<xsl:if test="ancestor::*[self::mn:sections or self::mn:annex]">
										<xsl:variable name="level">
											<xsl:for-each select="ancestor::*[1]">
												<xsl:call-template name="getLevel"/>
											</xsl:for-each>
										</xsl:variable>
										<!-- 5 + 6 (from list-block provisional-distance-between-starts) mm -->
										<xsl:attribute name="margin-left">
											<xsl:value-of select="5 + (($level - 1) * 6)"/>mm
										</xsl:attribute>
									</xsl:if>
									<fo:block-container margin-left="0">
										<fo:block role="SKIP">
											<xsl:apply-templates select="." mode="list">
												<xsl:with-param name="indent" select="$indent"/>
											</xsl:apply-templates>
										</fo:block>
									</fo:block-container>
								</fo:block-container>
							</xsl:when>
							<xsl:otherwise>
								<fo:block role="SKIP">
									<xsl:apply-templates select="." mode="list">
										<xsl:with-param name="indent" select="$indent"/>
									</xsl:apply-templates>
								</fo:block>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="$namespace = 'jis'">
						<xsl:choose>
							<xsl:when test="$vertical_layout = 'true'">
								<fo:block role="SKIP">
									<xsl:if test="ancestor::mn:ol or ancestor::mn:ul">
										<xsl:attribute name="margin-left">-3.5mm</xsl:attribute>
									</xsl:if>
									<xsl:apply-templates select="." mode="list">
										<xsl:with-param name="indent" select="$indent"/>
									</xsl:apply-templates>
								</fo:block>
							</xsl:when>
							<xsl:otherwise>
								<fo:block-container role="SKIP">
									<xsl:if test="ancestor::mn:ol or ancestor::mn:ul">
										<xsl:attribute name="margin-left">3.5mm</xsl:attribute>
									</xsl:if>
									<fo:block-container margin-left="0mm" role="SKIP">
										<fo:block>
											<xsl:apply-templates select="." mode="list">
												<xsl:with-param name="indent" select="$indent"/>
											</xsl:apply-templates>
										</fo:block>
									</fo:block-container>
								</fo:block-container>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="$namespace = 'plateau'">
						<fo:block-container role="SKIP">
							<xsl:if test="self::mn:ol and (ancestor::mn:li)">
								<xsl:attribute name="margin-left"><xsl:value-of select="count(ancestor::mn:li) * 6 + 6"/>mm</xsl:attribute>
							</xsl:if>
							<fo:block-container margin-left="0mm" role="SKIP">
								<fo:block>
									<xsl:apply-templates select="." mode="list">
										<xsl:with-param name="indent" select="$indent"/>
									</xsl:apply-templates>
								</fo:block>
							</fo:block-container>
						</fo:block-container>
					</xsl:when>
					<xsl:otherwise>
						<fo:block role="SKIP">
							<xsl:apply-templates select="." mode="list">
								<xsl:with-param name="indent" select="$indent"/>
							</xsl:apply-templates>
						</fo:block>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="refine_list_container_style">
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="margin-left">0mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="margin-left">0mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="margin-left">12mm</xsl:attribute>
			<xsl:if test="$document_type = 'PAS'">
				<xsl:if test="ancestor::*[self::mn:termnote or self::mn:note]">
					<xsl:attribute name="margin-left">2mm</xsl:attribute>
				</xsl:if>
				<xsl:if test="parent::*[self::mn:termnote or self::mn:note]">
					<xsl:attribute name="margin-left">0mm</xsl:attribute>
				</xsl:if>
			</xsl:if>
		</xsl:if>
	</xsl:template> <!-- refine_list_container_style -->
	
	<xsl:template match="mn:ul | mn:ol" mode="list" name="list">
	
		<xsl:apply-templates select="mn:fmt-name">
			<xsl:with-param name="process">true</xsl:with-param>
		</xsl:apply-templates>
	
		<fo:list-block xsl:use-attribute-sets="list-style">
		
			<xsl:variable name="provisional_distance_between_starts_">
				<attributes xsl:use-attribute-sets="list-style">
					<xsl:call-template name="refine_list-style_provisional-distance-between-starts"/>
				</attributes>
			</xsl:variable>
			<xsl:variable name="provisional_distance_between_starts" select="normalize-space(xalan:nodeset($provisional_distance_between_starts_)/attributes/@provisional-distance-between-starts)"/>
			<xsl:if test="$provisional_distance_between_starts != ''">
				<xsl:attribute name="provisional-distance-between-starts"><xsl:value-of select="$provisional_distance_between_starts"/></xsl:attribute>
			</xsl:if>
			<xsl:variable name="provisional_distance_between_starts_value" select="substring-before($provisional_distance_between_starts, 'mm')"/>
			
			<!-- increase provisional-distance-between-starts for long lists -->
			<xsl:if test="self::mn:ol">
				<!-- Examples: xiii), xviii), xxviii) -->
				<xsl:variable name="item_numbers">
					<xsl:for-each select="mn:li">
						<item><xsl:call-template name="getListItemFormat"/></item>
					</xsl:for-each>
				</xsl:variable>
	
				<xsl:variable name="max_length">
					<xsl:for-each select="xalan:nodeset($item_numbers)/item">
						<xsl:sort select="string-length(.)" data-type="number" order="descending"/>
						<xsl:if test="position() = 1"><xsl:value-of select="string-length(.)"/></xsl:if>
					</xsl:for-each>
				</xsl:variable>
				
				<!-- base width (provisional-distance-between-starts) for 4 chars -->
				<xsl:variable name="addon" select="$max_length - 4"/>
				<xsl:if test="$addon &gt; 0">
					<xsl:attribute name="provisional-distance-between-starts"><xsl:value-of select="$provisional_distance_between_starts_value + $addon * 2"/>mm</xsl:attribute>
				</xsl:if>
				<!-- DEBUG -->
				<!-- <xsl:copy-of select="$item_numbers"/>
				<max_length><xsl:value-of select="$max_length"/></max_length>
				<addon><xsl:value-of select="$addon"/></addon> -->
			</xsl:if>
		
			<xsl:call-template name="refine_list-style"/>
			
			<xsl:if test="mn:fmt-name">
				<xsl:attribute name="margin-top">0pt</xsl:attribute>
			</xsl:if>
			
			<xsl:apply-templates select="node()[not(self::mn:note)]" />
		</fo:list-block>
		<!-- <xsl:for-each select="./iho:note">
			<xsl:call-template name="note"/>
		</xsl:for-each> -->
		<xsl:apply-templates select="./mn:note"/>
	</xsl:template>
	
	<xsl:template name="refine_list-style_provisional-distance-between-starts">
		<xsl:if test="$namespace = 'iec'">
			<xsl:if test="ancestor::mn:legal-statement or ancestor::mn:clause[@type = 'boilerplate_legal']">
				<xsl:attribute name="provisional-distance-between-starts">5mm</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'iso'">
			<xsl:if test="$layoutVersion = '1951' and self::mn:ul">
				<xsl:attribute name="provisional-distance-between-starts">5mm</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'jis'">
			<xsl:if test="self::mn:ol and $vertical_layout = 'true' and @type = 'arabic'">
				<xsl:copy-of select="@provisional-distance-between-starts"/> <!-- add in update_xml_step1 -->
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'gb' or $namespace = 'm3d' or $namespace = 'mpfd'">
			<xsl:if test="self::mn:ol">
				<xsl:attribute name="provisional-distance-between-starts">7mm</xsl:attribute>
			</xsl:if>			
		</xsl:if>
		<xsl:if test="$namespace = 'unece' or $namespace = 'unece-rec'">
			<xsl:if test="self::mn:ol">
				<xsl:attribute name="provisional-distance-between-starts">6mm</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template> <!-- refine_list-style_provisional-distance-between-starts -->
	
	
	<xsl:template match="*[self::mn:ol or self::mn:ul]/mn:fmt-name">
		<xsl:param name="process">false</xsl:param>
		<xsl:if test="$process = 'true'">
			<fo:block xsl:use-attribute-sets="list-name-style">
				<xsl:apply-templates />
			</fo:block>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="mn:li">
		<xsl:param name="indent">0</xsl:param>
		<!-- <fo:list-item xsl:use-attribute-sets="list-item-style">
			<fo:list-item-label end-indent="label-end()"><fo:block>x</fo:block></fo:list-item-label>
			<fo:list-item-body start-indent="body-start()" xsl:use-attribute-sets="list-item-body-style">
				<fo:block>debug li indent=<xsl:value-of select="$indent"/></fo:block>
			</fo:list-item-body>
		</fo:list-item> -->
		<fo:list-item xsl:use-attribute-sets="list-item-style">
			<xsl:copy-of select="@id"/>
			
			<xsl:call-template name="refine_list-item-style"/>
			
			<fo:list-item-label end-indent="label-end()">
				<fo:block xsl:use-attribute-sets="list-item-label-style" role="SKIP">
				
					<xsl:call-template name="refine_list-item-label-style"/>
					
					<xsl:if test="local-name(..) = 'ul'">
						<xsl:variable name="li_label" select="@label"/>
						<xsl:copy-of select="$ul_labels//label[. = $li_label]/@*[not(local-name() = 'level')]"/>
					</xsl:if>
					
					<!-- if 'p' contains all text in 'add' first and last elements in first p are 'add' -->
					<xsl:if test="*[1][count(node()[normalize-space() != '']) = 1 and mn:add]">
						<xsl:call-template name="append_add-style"/>
					</xsl:if>
					
					<xsl:call-template name="getListItemFormat" />
					
				</fo:block>
			</fo:list-item-label>
			<fo:list-item-body start-indent="body-start()" xsl:use-attribute-sets="list-item-body-style">
				<fo:block role="SKIP">
				
					<xsl:call-template name="refine_list-item-body-style"/>
					
					<xsl:apply-templates>
						<xsl:with-param name="indent" select="$indent"/>
					</xsl:apply-templates>
				
					<!-- <xsl:apply-templates select="node()[not(local-name() = 'note')]" />
					
					<xsl:for-each select="./mn:note">
						<xsl:call-template name="note"/>
					</xsl:for-each> -->
				</fo:block>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>

	
	<!-- ===================================== -->
	<!-- END Lists processing -->
	<!-- ===================================== -->

</xsl:stylesheet>