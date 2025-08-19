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
					<xsl:if test="following-sibling::*[2][self::mn:fmt-title]/@depth = 2">
						<xsl:attribute name="space-after">24pt</xsl:attribute>
					</xsl:if>
				</xsl:if>
				<!-- note inside p or ul or ul : p/note ul/note ol/note -->
				<xsl:if test="parent::*[self::mn:p or self::mn:ul or self::mn:ol] and not(following-sibling::*)">
					<xsl:if test="../following-sibling::*[1][self::mn:clause or self::mn:term]">
						<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
						<xsl:if test="../following-sibling::*[2][self::mn:fmt-title]/@depth = 2">
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
		
		<xsl:if test="$namespace = 'jcgm'">
			<xsl:if test="parent::mn:references">
				<xsl:attribute name="margin-top">2pt</xsl:attribute>
				<xsl:attribute name="margin-bottom">2pt</xsl:attribute>
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
			<xsl:variable name="name" select="normalize-space(mn:fmt-name)" />
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
			<xsl:variable name="note_name" select="mn:fmt-name"/>
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
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
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
						<xsl:for-each select="ancestor::mn:term/mn:fmt-name">
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
		<xsl:if test="$namespace = 'ieee'">
			<xsl:if test="preceding-sibling::*[1][self::mn:fmt-definition]">
				<xsl:attribute name="margin-top">12pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="not(following-sibling::*)">
				<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
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
			<xsl:variable name="name" select="normalize-space(mn:fmt-name)" />
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
	

	<!-- ====== -->
	<!-- note      -->
	<!-- termnote -->
	<!-- ====== -->
	
	<xsl:template match="mn:note" name="note">
	
		<xsl:choose>
			<xsl:when test="$namespace = 'jis'">
				<xsl:call-template name="setNamedDestination"/>
				<fo:block xsl:use-attribute-sets="note-style" role="SKIP">
					<xsl:if test="not(parent::mn:references)">
						<xsl:copy-of select="@id"/>
					</xsl:if>
					<xsl:call-template name="setBlockSpanAll"/>
					
					<xsl:call-template name="refine_note-style"/>
					
					<fo:list-block>
						<xsl:attribute name="provisional-distance-between-starts">
							<xsl:choose>
								<!-- if last char is digit -->
								<xsl:when test="translate(substring(mn:fmt-name, string-length(mn:fmt-name)),'0123456789','') = ''"><xsl:value-of select="16 + $text_indent"/>mm</xsl:when>
								<xsl:otherwise><xsl:value-of select="10 + $text_indent"/>mm</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<fo:list-item>
							<fo:list-item-label start-indent="{$text_indent}mm" end-indent="label-end()">
								<xsl:if test="$vertical_layout = 'true'">
									<xsl:attribute name="start-indent">0mm</xsl:attribute>
								</xsl:if>
								<fo:block xsl:use-attribute-sets="note-name-style">
									<xsl:call-template name="refine_note-name-style"/>
									<xsl:apply-templates select="mn:fmt-name" />
								</fo:block>
							</fo:list-item-label>
							<fo:list-item-body start-indent="body-start()">
								<fo:block>
									<xsl:apply-templates select="node()[not(self::mn:fmt-name)]" />
								</fo:block>
							</fo:list-item-body>
						</fo:list-item>
					</fo:list-block>
				</fo:block>
			</xsl:when> <!-- jis -->
			<xsl:otherwise>
			
				<xsl:call-template name="setNamedDestination"/>
				
				<fo:block-container xsl:use-attribute-sets="note-style" role="SKIP">
					<xsl:if test="not(parent::mn:references)">
						<xsl:copy-of select="@id"/>
					</xsl:if>
				
					<xsl:call-template name="setBlockSpanAll"/>
					
					<xsl:call-template name="refine_note-style"/>
					
					<fo:block-container margin-left="0mm" margin-right="0mm" role="SKIP">
					
						<xsl:if test="$namespace = 'csa'">
							<xsl:if test="ancestor::mn:ul or ancestor::mn:ol and not(ancestor::mn:note[1]/following-sibling::*)">
								<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
							</xsl:if>
						</xsl:if>
					
						<xsl:choose>
							<xsl:when test="$namespace = 'gb'">
								<fo:table table-layout="fixed" width="100%">
									<fo:table-column column-width="10mm"/>
									<fo:table-column column-width="155mm"/>
									<fo:table-body>
										<fo:table-row>
											<fo:table-cell>
												<fo:block font-family="SimHei" xsl:use-attribute-sets="note-name-style" role="SKIP">
													<xsl:apply-templates select="gb:name" />
												</fo:block>
											</fo:table-cell>
											<fo:table-cell>
												<fo:block text-align="justify" role="SKIP">
													<xsl:apply-templates select="node()[not(self::mn:fmt-name)]" />
												</fo:block>
											</fo:table-cell>
										</fo:table-row>
									</fo:table-body>
								</fo:table>
								<!-- gb -->
							</xsl:when>
							
							<xsl:otherwise>
								<fo:block>
									
									<xsl:call-template name="refine_note_block_style"/>
									
									<fo:inline xsl:use-attribute-sets="note-name-style" role="SKIP">
										
										<xsl:apply-templates select="mn:fmt-name/mn:tab" mode="tab"/>
									
										<xsl:call-template name="refine_note-name-style"/>
									
										<!-- if 'p' contains all text in 'add' first and last elements in first p are 'add' -->
										<!-- <xsl:if test="*[not(local-name()='name')][1][node()[normalize-space() != ''][1][local-name() = 'add'] and node()[normalize-space() != ''][last()][local-name() = 'add']]"> -->
										<xsl:if test="*[not(self::mn:fmt-name)][1][count(node()[normalize-space() != '']) = 1 and mn:add]">
											<xsl:call-template name="append_add-style"/>
										</xsl:if>
										
										<!-- if note contains only one element and first and last childs are `add` ace-tag, then move start ace-tag before NOTE's name-->
										<xsl:if test="count(*[not(self::mn:fmt-name)]) = 1 and *[not(self::mn:fmt-name)]/node()[last()][self::mn:add][starts-with(text(), $ace_tag)]">
											<xsl:apply-templates select="*[not(self::mn:fmt-name)]/node()[1][self::mn:add][starts-with(text(), $ace_tag)]">
												<xsl:with-param name="skip">false</xsl:with-param>
											</xsl:apply-templates> 
										</xsl:if>
										
										<xsl:apply-templates select="mn:fmt-name" />
										
									</fo:inline>
									
									<xsl:apply-templates select="node()[not(self::mn:fmt-name)]" />
								</fo:block>
							</xsl:otherwise>
						</xsl:choose>
					</fo:block-container>
				</fo:block-container>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="refine_note_block_style">
		<xsl:if test="$namespace = 'bipm'">
			<xsl:if test="@parent-type = 'quote'">
				<xsl:attribute name="font-family">Arial</xsl:attribute>
				<xsl:attribute name="font-size">9pt</xsl:attribute>
				<xsl:attribute name="line-height">130%</xsl:attribute>
				<xsl:attribute name="text-align">justify</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:if test="$layoutVersion = '1951' or $layoutVersion = '1987'">
				<xsl:if test="following-sibling::*[1][self::mn:note] and not(preceding-sibling::*[1][self::mn:note])">
					<!-- NOTES -->
					<fo:block font-size="9.5pt" keep-with-next="always" margin-bottom="6pt" text-transform="uppercase">
						<xsl:variable name="i18n_notes">
							<xsl:call-template name="getLocalizedString">
								<xsl:with-param name="key">Note.pl</xsl:with-param>
							</xsl:call-template>
						</xsl:variable>
						<xsl:choose>
							<xsl:when test="$layoutVersion = '1951'">
								<xsl:call-template name="smallcaps">
									<xsl:with-param name="txt" select="$i18n_notes"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$i18n_notes"/>
							</xsl:otherwise>
						</xsl:choose>
					</fo:block>
				</xsl:if>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:if test="ancestor::mn:figure">
				<xsl:attribute name="keep-with-previous">always</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'unece-rec' or $namespace = 'unece'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="text-indent">0</xsl:attribute>
			<xsl:attribute name="padding-top">1.5mm</xsl:attribute>							
			<xsl:if test="../@type = 'source' or ../@type = 'abbreviation'">
				<xsl:attribute name="font-size">9pt</xsl:attribute>
				<xsl:attribute name="text-align">justify</xsl:attribute>
				<xsl:attribute name="padding-top">0mm</xsl:attribute>					
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'plateau'">
			<xsl:if test="ancestor::mn:figure">
				<xsl:attribute name="margin-left"><xsl:value-of select="$tableAnnotationIndent"/></xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template> <!-- refine_note_block_style -->
	

	
	<xsl:template match="mn:note/mn:p">
		<xsl:variable name="num"><xsl:number/></xsl:variable>
		<xsl:choose>
			<xsl:when test="$num = 1"> <!-- display first NOTE's paragraph in the same line with label NOTE -->
				<fo:inline xsl:use-attribute-sets="note-p-style" role="SKIP">
					<xsl:apply-templates />
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<fo:block xsl:use-attribute-sets="note-p-style" role="SKIP">
					<xsl:apply-templates />
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<xsl:template match="mn:termnote">
		<xsl:call-template name="setNamedDestination"/>
		<fo:block id="{@id}" xsl:use-attribute-sets="termnote-style">
		
			<xsl:call-template name="setBlockSpanAll"/>
		
			<xsl:call-template name="refine_termnote-style"/>
		
			<fo:inline xsl:use-attribute-sets="termnote-name-style">
			
				<xsl:choose>
					<xsl:when test="$namespace = 'bipm' or $namespace = 'bsi' or $namespace = 'csa' or $namespace = 'csd' or $namespace = 'iec' or $namespace = 'ieee' or $namespace = 'iho' or $namespace = 'iso' or $namespace = 'itu' or $namespace = 'jcgm' or $namespace = 'jis' or $namespace = 'nist-sp' or $namespace = 'nist-cswp' or $namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'plateau' or $namespace = 'rsd'"></xsl:when>
					<xsl:otherwise>
						<xsl:if test="not(mn:fmt-name/following-sibling::node()[1][self::text()][normalize-space()=''])">
							<xsl:attribute name="padding-right">1mm</xsl:attribute>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			
				<xsl:call-template name="refine_termnote-name-style"/>
			
				<!-- if 'p' contains all text in 'add' first and last elements in first p are 'add' -->
				<!-- <xsl:if test="*[not(local-name()='name')][1][node()[normalize-space() != ''][1][local-name() = 'add'] and node()[normalize-space() != ''][last()][local-name() = 'add']]"> -->
				<xsl:if test="*[not(self::mn:fmt-name)][1][count(node()[normalize-space() != '']) = 1 and mn:add]">
					<xsl:call-template name="append_add-style"/>
				</xsl:if>
				
				<xsl:apply-templates select="mn:fmt-name" />
				
			</fo:inline>
			
			<xsl:apply-templates select="node()[not(self::mn:fmt-name)]" />
		</fo:block>
	</xsl:template>


	<xsl:template match="mn:note/mn:fmt-name">
		<xsl:param name="sfx"/>
		<xsl:variable name="suffix">
			<xsl:choose>
				<xsl:when test="$sfx != ''">
					<xsl:value-of select="$sfx"/>					
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="$namespace = 'bipm'">
						<!-- <xsl:variable name="curr_lang" select="ancestor::mn:bipm-standard/mn:bibdata/mn:language[@current = 'true']"/>
						<xsl:choose>
							<xsl:when test="$curr_lang = 'fr'"><xsl:text>&#xa0;: </xsl:text></xsl:when>
							<xsl:otherwise><xsl:text>: </xsl:text></xsl:otherwise>
						</xsl:choose> -->
						<xsl:text> </xsl:text>
					</xsl:if>
					<!-- https://github.com/metanorma/isodoc/issues/607 -->
					<!-- <xsl:if test="$namespace = 'ieee'">
						<xsl:text>—</xsl:text> em dash &#x2014;
					</xsl:if> -->
					<!-- <xsl:if test="$namespace = 'iho' or $namespace = 'gb' or $namespace = 'm3d' or $namespace = 'unece-rec' or $namespace = 'unece'  or $namespace = 'rsd'">
						<xsl:text>:</xsl:text>
					</xsl:if> -->
					<xsl:if test="$namespace = 'iso'">
						<xsl:if test="$layoutVersion = '1987' and . = translate(.,'1234567890','')"> <!-- NOTE without number -->
							<xsl:text> — </xsl:text>
						</xsl:if>
					</xsl:if>
					<!-- <xsl:if test="$namespace = 'itu' or $namespace = 'nist-cswp'  or $namespace = 'nist-sp'">				
						<xsl:text> – </xsl:text> en dash &#x2013;
					</xsl:if> -->
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="normalize-space() != ''">
			<xsl:apply-templates />
			<xsl:value-of select="$suffix"/>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="mn:termnote/mn:fmt-name">
		<xsl:param name="sfx"/>
		<xsl:variable name="suffix">
			<xsl:choose>
				<xsl:when test="$sfx != ''">
					<xsl:value-of select="$sfx"/>					
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="$namespace = 'bipm'">
						<!-- <xsl:variable name="curr_lang" select="ancestor::mn:bipm-standard/mn:bibdata/mn:language[@current = 'true']"/>
						<xsl:choose>
							<xsl:when test="$curr_lang = 'fr'"><xsl:text>&#xa0;: </xsl:text></xsl:when>
							<xsl:otherwise><xsl:text>: </xsl:text></xsl:otherwise>
						</xsl:choose> -->
						<xsl:text> </xsl:text>
					</xsl:if>
					<!-- https://github.com/metanorma/isodoc/issues/607 -->
					<!-- <xsl:if test="$namespace = 'ieee'">
						<xsl:text>—</xsl:text> em dash &#x2014;
					</xsl:if> -->
					<!-- <xsl:if test="$namespace = 'gb' or $namespace = 'iso' or $namespace = 'iec' or $namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'rsd' or $namespace = 'jcgm'">
						<xsl:text>:</xsl:text>
					</xsl:if> -->
					<!-- <xsl:if test="$namespace = 'itu' or $namespace = 'nist-cswp'  or $namespace = 'nist-sp' or $namespace = 'unece-rec' or $namespace = 'unece'">				
						<xsl:text> – </xsl:text> en dash &#x2013;
					</xsl:if> -->
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="normalize-space() != ''">
			<xsl:apply-templates />
			<xsl:value-of select="$suffix"/>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="mn:termnote/mn:p">
		<xsl:variable name="num"><xsl:number/></xsl:variable>
		<xsl:choose>
			<xsl:when test="$num = 1"> <!-- first paragraph renders in the same line as titlenote name -->
				<fo:inline xsl:use-attribute-sets="termnote-p-style">
					<xsl:apply-templates />
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<fo:block xsl:use-attribute-sets="termnote-p-style">						
					<xsl:apply-templates />
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- ====== -->
	<!-- ====== -->
	
</xsl:stylesheet>