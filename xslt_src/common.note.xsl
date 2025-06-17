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
	
	<xsl:attribute-set name="note-style">
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="font-size">9pt</xsl:attribute>
			<xsl:attribute name="font-style">italic</xsl:attribute>
			<xsl:attribute name="space-before">5pt</xsl:attribute>
			<xsl:attribute name="space-after">5pt</xsl:attribute>
			<xsl:attribute name="margin-right">10mm</xsl:attribute>
			<xsl:attribute name="line-height">1.4</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="line-height">115%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csd'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="font-size">9pt</xsl:attribute>
			<xsl:attribute name="margin-left">7.4mm</xsl:attribute>
			<xsl:attribute name="margin-top">4pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">4pt</xsl:attribute>
			<xsl:attribute name="line-height">125%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="font-size">8pt</xsl:attribute>
			<xsl:attribute name="margin-top">5pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">9pt</xsl:attribute>
		</xsl:if>		
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="font-size">9pt</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="text-align">justify</xsl:attribute>
		</xsl:if>		
		<xsl:if test="$namespace = 'iho'">
			<!-- <xsl:attribute name="font-size">11pt</xsl:attribute> -->
			<xsl:attribute name="margin-top">4pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="text-align">justify</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso' or $namespace = 'jcgm'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-top">8pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="text-align">justify</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="space-before">4pt</xsl:attribute>
			<xsl:attribute name="text-align">justify</xsl:attribute>		
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:attribute name="text-indent">0mm</xsl:attribute>
			<xsl:attribute name="space-before">2pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'm3d'">
			<xsl:attribute name="margin-left">0mm</xsl:attribute>
			<xsl:attribute name="margin-top">4pt</xsl:attribute>			
			<xsl:attribute name="text-align">justify</xsl:attribute>
			<xsl:attribute name="line-height">125%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp' or $namespace = 'nist-sp'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="space-before">4pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">			
			<xsl:attribute name="margin-top">12pt</xsl:attribute>			
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>						
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>			
			<xsl:attribute name="margin-top">12pt</xsl:attribute>			
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>			
			<xsl:attribute name="line-height">115%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'plateau'">
			<xsl:attribute name="text-indent">0mm</xsl:attribute>
			<xsl:attribute name="space-before">2pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece'">			
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece-rec'">
			<xsl:attribute name="margin-top">3pt</xsl:attribute>			
			<xsl:attribute name="border-top">0.1mm solid black</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="text-align">justify</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="margin-top">12pt</xsl:attribute>			
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>			
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:template name="refine_note-style">
		<xsl:if test="$namespace = 'bipm'">
			<xsl:if test="parent::mn:li">
				<xsl:attribute name="margin-top">4pt</xsl:attribute>
				<xsl:attribute name="margin-bottom">4pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'bsi'">
			<xsl:if test="$document_type = 'PAS'">
				<xsl:attribute name="font-size">inherit</xsl:attribute>
				<xsl:attribute name="color"><xsl:value-of select="$color_secondary_shade_1_PAS"/></xsl:attribute>
				<xsl:attribute name="line-height">1.3</xsl:attribute>
				<xsl:attribute name="margin-right">0mm</xsl:attribute>
				<xsl:if test="following-sibling::*[1][self::mn:clause or self::mn:term]">
					<xsl:attribute name="space-after">12pt</xsl:attribute>
					<xsl:if test="following-sibling::*[2][self::mn:title]/@depth = 2">
						<xsl:attribute name="space-after">24pt</xsl:attribute>
					</xsl:if>
				</xsl:if>
				<!-- note inside p or ul or ul : p/note ul/note ol/note -->
				<xsl:if test="parent::*[self::mn:p or self::mn:ul or self::mn:ol] and not(following-sibling::*)">
					<xsl:if test="../following-sibling::*[1][self::mn:clause or self::mn:term]">
						<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
						<xsl:if test="../following-sibling::*[2][self::mn:title]/@depth = 2">
							<xsl:attribute name="margin-bottom">24pt</xsl:attribute>
						</xsl:if>
					</xsl:if>
				</xsl:if>
				<!-- if 1st note -->
				<xsl:if test="parent::mn:figure and preceding-sibling::*[1][self::mn:image]">
					<xsl:attribute name="space-before">0pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$document_type != 'PAS'">
				<xsl:attribute name="text-align">justify</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'iso'">
			<xsl:if test="$layoutVersion = '1951'">
				<!-- <xsl:if test="$revision_date_num &lt; 19680101"> -->
					<xsl:attribute name="font-size">8.5pt</xsl:attribute>
				<!-- </xsl:if> -->
			</xsl:if>
			<xsl:if test="$layoutVersion = '1972' or $layoutVersion = '1979' or $layoutVersion = '1987' or $layoutVersion = '1989'">
				<xsl:attribute name="font-size">9pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="$layoutVersion  = '1987'">
				<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="$layoutVersion  = '2024'">
				<xsl:if test="ancestor::mn:li and not(following-sibling::*)">
					<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
				</xsl:if>
				<xsl:if test="preceding-sibling::*[1][self::mn:table]">
					<xsl:attribute name="margin-top">0pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$doctype = 'amendment' and parent::mn:quote">
				<xsl:attribute name="font-size">inherit</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:if test="ancestor::mn:ul or ancestor::mn:ol and not(ancestor::mn:note[1]/following-sibling::*)">
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'rsd'">
			<xsl:if test="ancestor::mn:ul or ancestor::mn:ol and not(ancestor::mn:note[1]/following-sibling::*)">
				<xsl:attribute name="margin-top">6pt</xsl:attribute>
				<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
	
		<xsl:if test="$namespace = 'unece-rec'">
			<xsl:if test="../@type = 'source' or ../@type = 'abbreviation'">
				<xsl:attribute name="border-top">0pt solid black</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	
	<xsl:variable name="note-body-indent">10mm</xsl:variable>
	<xsl:variable name="note-body-indent-table">5mm</xsl:variable>
	
	<xsl:attribute-set name="note-name-style">
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="padding-right">1.5mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="padding-right">4mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csd'">
			<xsl:attribute name="padding-right">6mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="font-family">SimHei</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="padding-right">6mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<!-- <xsl:attribute name="font-size">11pt</xsl:attribute> -->
			<xsl:attribute name="padding-right">2mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso' or $namespace = 'jcgm'">
			<xsl:attribute name="padding-right">6mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
		</xsl:if>
		<xsl:if test="$namespace = 'm3d'">
			<xsl:attribute name="padding-right">5mm</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<!-- <xsl:attribute name="padding-right">1mm</xsl:attribute> -->
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<!-- <xsl:attribute name="padding-right">4mm</xsl:attribute> -->
		</xsl:if>
		<xsl:if test="$namespace = 'unece'">
			<xsl:attribute name="padding-right">4mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="color"><xsl:value-of select="$color_blue"/></xsl:attribute>
			<xsl:attribute name="padding-right">0.5mm</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:template name="refine_note-name-style">
		<xsl:if test="$namespace = 'bsi'">
			<xsl:variable name="name" select="normalize-space(mn:name)" />
			<!-- if NOTE without number -->
			<xsl:if test="translate(substring($name, string-length($name)), '0123456789', '') != ''">
				<xsl:attribute name="padding-right">3.5mm</xsl:attribute>
			</xsl:if>
			<xsl:if test="$document_type = 'PAS'">
				<xsl:attribute name="padding-right">1mm</xsl:attribute>
				<xsl:attribute name="font-weight">bold</xsl:attribute>
			</xsl:if>
			<xsl:if test="@type = 'assessed-capability'">
				<xsl:attribute name="padding-right">1mm</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:variable name="note_name" select="mn:name"/>
			<xsl:if test="$layoutVersion = '1951'">
				<xsl:if test="$revision_date_num"> <!--  &lt; 19610101 -->
					<xsl:attribute name="padding-right">0mm</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$layoutVersion = '1987'">
				<xsl:attribute name="padding-right">1mm</xsl:attribute>
				<xsl:if test="not(translate($note_name,'0123456789','') = $note_name)"> <!-- NOTE with number -->
					<xsl:attribute name="padding-right">3mm</xsl:attribute>
				</xsl:if>
				<xsl:if test="translate($note_name,'0123456789','') = $note_name"> <!-- NOTE without number -->
					<xsl:attribute name="font-size">9.5pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$layoutVersion = '2024' and translate($note_name,'0123456789','') = $note_name"> <!-- NOTE without number -->
				<xsl:attribute name="padding-right">8mm</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:if test="not($vertical_layout = 'true')">
				<xsl:attribute name="font-family">IPAexGothic</xsl:attribute>
			</xsl:if>
			<xsl:if test="$vertical_layout = 'true'">
				<xsl:attribute name="font-family">Noto Sans JP</xsl:attribute>
				<xsl:attribute name="font-weight">500</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'plateau'">
			<xsl:if test="ancestor::mn:figure">
				<xsl:attribute name="font-weight">bold</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template> <!-- refine_note-name-style -->
	
	<xsl:attribute-set name="table-note-name-style">
		<xsl:attribute name="padding-right">2mm</xsl:attribute>
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="font-family">SimHei</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<!-- <xsl:attribute name="font-size">11pt</xsl:attribute> -->
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="color"><xsl:value-of select="$color_blue"/></xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:template name="refine_table-note-name-style">
		<xsl:if test="$namespace = 'bipm'">
			<xsl:if test="ancestor::mn:preface">
				<xsl:attribute name="text-decoration">underline</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'bsi'">
			<xsl:if test="$document_type = 'PAS'">
				<xsl:attribute name="padding-right">1mm</xsl:attribute>
				<!-- <xsl:attribute name="font-style">italic</xsl:attribute> -->
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'plateau'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		
		<xsl:if test="$namespace = 'unece' or $namespace = 'unece-rec'">
			<xsl:if test="@type = 'source' or @type = 'abbreviation'">
				<xsl:attribute name="font-size">9pt</xsl:attribute>							
			</xsl:if>
		</xsl:if>
	</xsl:template> <!-- refine_table-note-name-style -->
				
	
	<xsl:attribute-set name="note-p-style">
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csd'">			
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="margin-top">4pt</xsl:attribute>
			<xsl:attribute name="line-height">125%</xsl:attribute>
			<xsl:attribute name="text-align">justify</xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="margin-top">5pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="text-align">justify</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">			
			<xsl:attribute name="margin-top">8pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'bsi' or $namespace = 'iso' or $namespace = 'jcgm'">			
			<xsl:attribute name="margin-top">8pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">			
			<xsl:attribute name="space-before">4pt</xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'm3d'">
			<xsl:attribute name="margin-left">0mm</xsl:attribute>
			<xsl:attribute name="margin-top">4pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'rsd'">
			<xsl:attribute name="margin-top">12pt</xsl:attribute>			
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp'">			
			<xsl:attribute name="space-before">4pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece-rec'">
			<xsl:attribute name="margin-top">3pt</xsl:attribute>			
			<!-- <xsl:attribute name="border-top">0.1mm solid black</xsl:attribute> -->
			<xsl:attribute name="space-after">12pt</xsl:attribute>			
			<xsl:attribute name="text-indent">0</xsl:attribute>
			<xsl:attribute name="padding-top">1.5mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece'">			
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="text-indent">0</xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="text-align">justify</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="termnote-style">
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="text-align">justify</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="font-size">9pt</xsl:attribute>
			<xsl:attribute name="font-style">italic</xsl:attribute>
			<xsl:attribute name="space-before">5pt</xsl:attribute>
			<xsl:attribute name="space-after">5pt</xsl:attribute>
			<xsl:attribute name="line-height">1.4</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa' or $namespace = 'csd' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>			
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="font-size">9pt</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="text-align">justify</xsl:attribute>
		</xsl:if>		
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="font-size">8pt</xsl:attribute>
			<xsl:attribute name="margin-top">5pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">5pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho' or $namespace = 'iso' or $namespace = 'jcgm'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-top">8pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
			<xsl:attribute name="text-align">justify</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu' or $namespace = 'nist-cswp'  or $namespace = 'nist-sp' or $namespace = 'unece' or $namespace = 'unece-rec'">			
			<xsl:attribute name="margin-top">4pt</xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:attribute name="text-indent">0mm</xsl:attribute>
			<xsl:attribute name="space-before">4pt</xsl:attribute>
			<xsl:attribute name="space-after">4pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">			
			<xsl:attribute name="margin-top">12pt</xsl:attribute>			
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>						
		</xsl:if>
		<xsl:if test="$namespace = 'plateau'">
			<xsl:attribute name="text-indent">0mm</xsl:attribute>
			<xsl:attribute name="space-before">4pt</xsl:attribute>
			<xsl:attribute name="space-after">4pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>

	<xsl:template name="refine_termnote-style">
		<xsl:if test="$namespace = 'bsi'">
			<xsl:if test="$document_type = 'PAS'">
				<xsl:attribute name="space-before">0pt</xsl:attribute>
				<xsl:if test="not(following-sibling::*)">
					<xsl:attribute name="space-after">24pt</xsl:attribute>
					<xsl:variable name="level">
						<xsl:for-each select="ancestor::mn:term/mn:name">
							<xsl:call-template name="getLevelTermName"/>
						</xsl:for-each>
					</xsl:variable>
					<xsl:if test="$level &gt; 2">
						<xsl:attribute name="space-after">16pt</xsl:attribute>
					</xsl:if>
				</xsl:if>
				<xsl:attribute name="color"><xsl:value-of select="$color_secondary_shade_1_PAS"/></xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:if test="$layoutVersion = '1972' or $layoutVersion = '1979' or $layoutVersion = '1987' or $layoutVersion = '1989'">
				<xsl:attribute name="font-size">9pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="$doctype = 'amendment' and parent::mn:quote">
				<xsl:attribute name="font-size">inherit</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template> <!-- refine_termnote-style -->

	<xsl:attribute-set name="termnote-name-style">
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="padding-right">1.5mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="padding-right">1mm</xsl:attribute>
		</xsl:if>		
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="padding-right">1mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="color"><xsl:value-of select="$color_blue"/></xsl:attribute>
			<xsl:attribute name="padding-right">0.5mm</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>

	<xsl:template name="refine_termnote-name-style">
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="padding-right">1.5mm</xsl:attribute>
			<xsl:variable name="name" select="normalize-space(mn:name)" />
			<!-- if NOTE without number -->
			<xsl:if test="translate(substring($name, string-length($name)), '0123456789', '') != ''">
				<xsl:attribute name="padding-right">3.5mm</xsl:attribute>
			</xsl:if>
			<xsl:if test="$document_type = 'PAS'">
				<xsl:attribute name="padding-right">1mm</xsl:attribute>
				<xsl:attribute name="font-weight">bold</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:if test="not($vertical_layout = 'true')">
				<xsl:attribute name="font-family">IPAexGothic</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	
	<xsl:attribute-set name="termnote-p-style">
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="text-align">justify</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="space-before">4pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
</xsl:stylesheet>