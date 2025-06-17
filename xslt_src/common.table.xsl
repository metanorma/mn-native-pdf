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
	
	<!-- ========================== -->
	<!-- Table styles -->
	<!-- ========================== -->
	<xsl:variable name="table-border_">
		<xsl:if test="$namespace = 'bsi'">0.5pt solid black</xsl:if>
		<xsl:if test="$namespace = 'ieee'">1pt solid black</xsl:if>
		<xsl:if test="$namespace = 'iho'">0.5pt solid black</xsl:if>
		<xsl:if test="$namespace = 'iso'">1pt solid black</xsl:if>
		<xsl:if test="$namespace = 'jis'">0.5pt solid black</xsl:if>
		<xsl:if test="$namespace = 'plateau''">1pt solid black</xsl:if>
	</xsl:variable>
	<xsl:variable name="table-border" select="normalize-space($table-border_)"/>
	
	<xsl:variable name="table-cell-border_">
		<xsl:if test="$namespace = 'iso'">0.5pt solid black</xsl:if>
		<xsl:if test="$namespace = 'plateau''">0.5pt solid black</xsl:if>
	</xsl:variable>
	<xsl:variable name="table-cell-border" select="normalize-space($table-cell-border_)"/>
	
	<xsl:attribute-set name="table-container-style">
		<xsl:attribute name="margin-left">0mm</xsl:attribute>
		<xsl:attribute name="margin-right">0mm</xsl:attribute>
		
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="space-after">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="font-size">9pt</xsl:attribute>
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa'">
			
		</xsl:if>
		<xsl:if test="$namespace = 'csd'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="font-size">8pt</xsl:attribute>
			<xsl:attribute name="space-after">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="font-size">9pt</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="font-size">9pt</xsl:attribute>
			<xsl:attribute name="space-after">18pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<!-- <xsl:attribute name="margin-top">12pt</xsl:attribute> -->
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="space-after">18pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jcgm'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:attribute name="font-size">9pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'm3d'">
			
		</xsl:if>
		<xsl:if test="$namespace = 'mpfd'">
			<xsl:attribute name="space-after">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp'">
			<xsl:attribute name="space-after">6pt</xsl:attribute>
			<xsl:attribute name="font-family">Times New Roman</xsl:attribute>
			<xsl:attribute name="font-size">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-sp'">
			<xsl:attribute name="space-after">6pt</xsl:attribute>
			<xsl:attribute name="font-family">Times New Roman</xsl:attribute>
			<xsl:attribute name="font-size">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="space-after">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="space-after">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'plateau'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece'">
			<xsl:attribute name="margin-bottom">18pt</xsl:attribute>
			<xsl:attribute name="font-size">8pt</xsl:attribute>
		</xsl:if>			
		
		<xsl:if test="$namespace = 'unece-rec'">
			<xsl:attribute name="space-after">12pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- table-container-style -->
	
	<xsl:template name="refine_table-container-style">
		<xsl:param name="margin-side"/>
		<xsl:if test="$namespace = 'csa' or $namespace = 'csd' or $namespace = 'gb' or $namespace = 'iec' or $namespace = 'm3d' or $namespace = 'nist-cswp' or $namespace = 'nist-sp' or $namespace = 'unece' or $namespace = 'unece-rec'">
			<xsl:attribute name="margin-left"><xsl:value-of select="-$margin-side"/>mm</xsl:attribute>
			<xsl:attribute name="margin-right"><xsl:value-of select="-$margin-side"/>mm</xsl:attribute>
		</xsl:if>
	
		<xsl:if test="$namespace = 'bipm'">
			<xsl:if test="not(ancestor::mn:note_side)">
				<xsl:attribute name="font-size">10pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="ancestor-or-self::*[@parent-type = 'quote']">
				<xsl:attribute name="font-family">Arial</xsl:attribute>
				<xsl:attribute name="font-size">9pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
	
		<xsl:if test="$namespace = 'bsi'">
			<xsl:if test="starts-with(@id, 'boxed-text')">
				<xsl:attribute name="font-size">inherit</xsl:attribute>
			</xsl:if>
			<xsl:if test="$document_type != 'PAS' and mn:name">
				<xsl:attribute name="margin-top">-14pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="not(mn:tbody) and mn:thead">
				<xsl:attribute name="margin-top">4pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="ancestor::mn:preface and not(mn:tbody)">
				<xsl:attribute name="margin-top">0pt</xsl:attribute>
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="$document_type = 'PAS'">
				<xsl:attribute name="font-size">9pt</xsl:attribute>
				<!-- two-columns table without name renders in column (not spanned) -->
				<xsl:choose>
					<xsl:when test="count(mn:colgroup/mn:col) = 2 and not(mn:name) and not(mn:thead)">
						<xsl:attribute name="font-size">inherit</xsl:attribute>
					</xsl:when>
					<xsl:when test="@width = 'text-width'"><!-- renders in column, not spanned --></xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="span">all</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:attribute name="margin-top">12pt</xsl:attribute>
				<xsl:attribute name="space-before">12pt</xsl:attribute>
				<xsl:attribute name="space-after">12pt</xsl:attribute>
				<xsl:if test="not(mn:name) and (ancestor::mn:clause[@type = 'corrigenda'] or contains(ancestor::mn:clause[1]/mn:title, 'Amendments/corrigenda'))">
					<xsl:attribute name="margin-top">2pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$document_type != 'PAS' and not(following-sibling::*[2][@depth = '1']) and not (ancestor::mn:preface and (ancestor::mn:clause[@type = 'corrigenda'] or contains(ancestor::mn:clause[1]/mn:title, 'Amendments/corrigenda')))">
				<xsl:attribute name="margin-bottom">24pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
	
		<xsl:if test="$namespace = 'iec'">
			<xsl:if test="ancestor::mn:preface">
				<xsl:attribute name="space-after">16pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'ieee'">
			<xsl:if test="$current_template = 'whitepaper' or $current_template = 'icap-whitepaper' or $current_template = 'industry-connection-report'">
				<xsl:attribute name="font-size">10pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="ancestor::mn:feedback-statement">
				<xsl:attribute name="font-size">inherit</xsl:attribute>
				<xsl:attribute name="margin-top">6pt</xsl:attribute>
				<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'iso'">
			<xsl:if test="not(mn:name)">
				<xsl:attribute name="margin-top">12pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="starts-with(@id, 'array_')">
				<xsl:attribute name="margin-top">6pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="$layoutVersion = '1951'">
				<xsl:attribute name="font-size">inherit</xsl:attribute>
			</xsl:if>
			<xsl:if test="$layoutVersion = '1972' or $layoutVersion = '1979' or $layoutVersion = '1987' or $layoutVersion = '1989'">
				<xsl:if test="normalize-space(@width) != 'text-width'">
					<xsl:attribute name="span">all</xsl:attribute>
				</xsl:if>
				<xsl:attribute name="font-size">9pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'itu'">
			<xsl:variable name="doctype" select="ancestor::mn:metanorma/mn:bibdata/mn:ext/mn:doctype[not(@language) or @language = '']"/>
			<xsl:if test="$doctype = 'service-publication' and $lang != 'ar'">
				<xsl:attribute name="font-family">Calibri</xsl:attribute>
			</xsl:if>
		</xsl:if>
	
		<xsl:if test="$namespace = 'nist-cswp'  or $namespace = 'nist-sp'">
			<xsl:if test="ancestor::mn:annex or ancestor::mn:preface">
				<xsl:attribute name="font-size">10pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'ogc'">
			<!-- <xsl:if test="ancestor::mn:sections"> -->
				<xsl:attribute name="font-size">9pt</xsl:attribute>
			<!-- </xsl:if> -->
		</xsl:if>
		
		<xsl:if test="$namespace = 'unece-rec'">
			<xsl:if test="not(ancestor::mn:sections)">
				<xsl:attribute name="font-size">10pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<!-- end table block-container attributes -->
	</xsl:template> <!-- refine_table-container-style -->
	
	<xsl:attribute-set name="table-style">
		<xsl:attribute name="table-omit-footer-at-break">true</xsl:attribute>
		<xsl:attribute name="table-layout">fixed</xsl:attribute>
		
		<xsl:if test="$namespace = 'bipm'">
		
		</xsl:if>
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="border">none</xsl:attribute>
			<xsl:attribute name="border-bottom"><xsl:value-of select="$table-border"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa'">
			
		</xsl:if>
		<xsl:if test="$namespace = 'csd'">
			
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="border">0.5pt solid black</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="border"><xsl:value-of select="$table-border"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="border"><xsl:value-of select="$table-border"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="border"><xsl:value-of select="$table-border"/></xsl:attribute>
		</xsl:if>
		
		<xsl:if test="$namespace = 'jcgm'">
			<xsl:attribute name="border">1.5pt solid black</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:attribute name="border"><xsl:value-of select="$table-border"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'm3d'">
			
		</xsl:if>
		<xsl:if test="$namespace = 'mpfd'">
			<xsl:attribute name="border-top">2pt solid black</xsl:attribute>
			<xsl:attribute name="border-bottom">2pt solid black</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp'">
			
		</xsl:if>
		<xsl:if test="$namespace = 'nist-sp'">
			
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			
		</xsl:if>
		<xsl:if test="$namespace = 'plateau'">
			<xsl:attribute name="border"><xsl:value-of select="$table-border"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="border">0pt solid black</xsl:attribute>
			<xsl:attribute name="font-size">9.5pt</xsl:attribute> <!-- 8pt -->
		</xsl:if>
		<xsl:if test="$namespace = 'unece'">
			<xsl:attribute name="border-top">0.5pt solid black</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece-rec'">
			
		</xsl:if>
	</xsl:attribute-set><!-- table-style -->
	
	
	<xsl:template name="refine_table-style">
		<xsl:param name="margin-side"/>
		<xsl:if test="$namespace = 'csa' or $namespace = 'csd' or $namespace = 'gb' or $namespace = 'iec' or $namespace = 'm3d' or $namespace = 'nist-cswp' or $namespace = 'nist-sp' or $namespace = 'unece' or $namespace = 'unece-rec'">
			<xsl:if test="$margin-side != 0">
				<xsl:attribute name="margin-left"><xsl:value-of select="$margin-side"/>mm</xsl:attribute>
				<xsl:attribute name="margin-right"><xsl:value-of select="$margin-side"/>mm</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'bipm'">					
			<xsl:if test="not(ancestor::mn:preface) and not(ancestor::mn:note_side) and not(ancestor::mn:annex and .//mn:xref[@pagenumber]) and not(ancestor::mn:doccontrol) and not(ancestor::mn:colophon)">
				<xsl:attribute name="border-top">0.5pt solid black</xsl:attribute>
				<xsl:attribute name="border-bottom">0.5pt solid black</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'bsi'">
			<xsl:if test="$document_type != 'PAS'">
				<xsl:attribute name="border-bottom">2.5pt solid black</xsl:attribute>
			</xsl:if>
			<xsl:if test=".//*[local-name() = 'tr'][1]/*[local-name() = 'td'][normalize-space() = 'Key'] or
			normalize-space(substring-after(mn:name, '—')) = 'Key' or 
			normalize-space(mn:name) = 'Key'
			">
				<xsl:attribute name="border-bottom">none</xsl:attribute>
			</xsl:if>
			<xsl:if test="(ancestor::mn:preface and ancestor::mn:clause[@type = 'corrigenda']) or
			(ancestor::mn:copyright-statement and contains(ancestor::mn:clause[1]/mn:title, 'Amendments/corrigenda'))">
				<xsl:if test="normalize-space(*[local-name() = 'tbody']) = ''">
					<xsl:attribute name="border-bottom">none</xsl:attribute>
				</xsl:if>
				<xsl:if test="$document_type != 'PAS'">
					<xsl:attribute name="border">none</xsl:attribute>
					<xsl:attribute name="border-top">none</xsl:attribute>
					<xsl:attribute name="border-bottom">none</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="ancestor::mn:preface">
				<xsl:attribute name="border">0pt solid black</xsl:attribute>
				<xsl:attribute name="border-top">0pt solid black</xsl:attribute>
			</xsl:if>
			<xsl:if test="$document_type = 'PAS'">
				<xsl:if test="ancestor::mn:preface and ancestor::mn:clause[@type = 'logos']">
					<xsl:attribute name="border-bottom">none</xsl:attribute>
				</xsl:if>
				<!-- two-columns table without name renders without borders -->
				<xsl:if test="count(mn:colgroup/mn:col) = 2 and not(mn:name) and not(*[local-name() = 'thead'])">
					<xsl:attribute name="border-bottom">none</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="ancestor::mn:table">
				<!-- for internal table in table cell -->
				<xsl:attribute name="border"><xsl:value-of select="$table-border"/></xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'ieee'">
			<xsl:if test="$current_template = 'whitepaper' or $current_template = 'icap-whitepaper' or $current_template = 'industry-connection-report'">
				<xsl:attribute name="border">0.5 solid black</xsl:attribute>
			</xsl:if>
			<xsl:if test="ancestor::mn:feedback-statement">
				<xsl:attribute name="border">none</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'iso'">
			<xsl:if test="*[local-name()='thead']">
				<xsl:attribute name="border-top"><xsl:value-of select="$table-border"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="ancestor::mn:table">
				<!-- for internal table in table cell -->
				<xsl:attribute name="border"><xsl:value-of select="$table-cell-border"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="$layoutVersion = '1951'">
				<xsl:if test="@unnumbered = 'true' and ancestor::mn:preface">
					<xsl:attribute name="border">none</xsl:attribute>
				</xsl:if>
			</xsl:if>
		</xsl:if>
		
		<xsl:call-template name="setBordersTableArray"/>
		
		<xsl:if test="$namespace = 'itu'">
			<xsl:variable name="doctype" select="ancestor::mn:metanorma/mn:bibdata/mn:ext/mn:doctype[not(@language) or @language = '']"/>
			<xsl:if test="$doctype = 'service-publication'">
				<xsl:attribute name="border">1pt solid rgb(211,211,211)</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'jcgm'">
			<xsl:if test="*[local-name()='thead']">
				<xsl:attribute name="border-top">1pt solid black</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'jis'">
			<xsl:if test="ancestor::mn:preface">
				<xsl:attribute name="border">none</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'unece-rec'">
			<xsl:if test="ancestor::mn:sections">
				<xsl:attribute name="border-top">1.5pt solid black</xsl:attribute>
				<xsl:attribute name="border-bottom">1.5pt solid black</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template> <!-- refine_table-style -->
	
	<xsl:attribute-set name="table-name-style">
		<xsl:attribute name="role">Caption</xsl:attribute>
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="font-weight">normal</xsl:attribute>
			<xsl:attribute name="font-style">italic</xsl:attribute>
			<xsl:attribute name="text-align">left</xsl:attribute>
			<xsl:attribute name="margin-left">-20mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
		</xsl:if>	
		<xsl:if test="$namespace = 'itu' or $namespace = 'csd' or $namespace = 'm3d'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="font-family">SimHei</xsl:attribute>
			<xsl:attribute name="font-weight">normal</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<!-- <xsl:attribute name="margin-bottom">6pt</xsl:attribute> -->
			<xsl:attribute name="margin-bottom">-12pt</xsl:attribute>
			<xsl:attribute name="space-before">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="font-family">Arial</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>		
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="font-size">10pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-bottom">-12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jcgm'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-bottom">4pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp'  or $namespace = 'nist-sp'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="font-family">Arial</xsl:attribute>
			<xsl:attribute name="font-size">9pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">							
			<xsl:attribute name="text-align">left</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="font-weight">normal</xsl:attribute>
			<xsl:attribute name="color"><xsl:value-of select="$color_text_title"/></xsl:attribute>
			<xsl:attribute name="font-size">11pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="text-align">left</xsl:attribute>
			<xsl:attribute name="color">rgb(68, 84, 106)</xsl:attribute>
			<xsl:attribute name="font-weight">normal</xsl:attribute>
			<xsl:attribute name="font-style">italic</xsl:attribute>
			<xsl:attribute name="margin-top">0pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'plateau'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-top">20pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">4pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece'">
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="font-weight">normal</xsl:attribute>
			<xsl:attribute name="font-style">italic</xsl:attribute>
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="text-align">left</xsl:attribute>
			<xsl:attribute name="text-indent">0mm</xsl:attribute>
		</xsl:if>		
		<xsl:if test="$namespace = 'unece-rec'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">left</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="text-indent">0mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'mpfd'">
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="font-size">11pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">left</xsl:attribute>
			<xsl:attribute name="margin-top">24pt</xsl:attribute>
			<!-- <xsl:attribute name="margin-left">25mm</xsl:attribute>
			<xsl:attribute name="text-indent">-25mm</xsl:attribute> -->
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-size">13pt</xsl:attribute>
			<xsl:attribute name="font-weight">300</xsl:attribute>
			<xsl:attribute name="color">black</xsl:attribute>
			<xsl:attribute name="text-align">left</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- table-name-style -->

	<xsl:template name="refine_table-name-style">
		<xsl:param name="continued"/>
		<xsl:if test="$continued = 'true'">
			<xsl:attribute name="role">SKIP</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bsi'">
			<xsl:if test="$continued != 'true'">
				<xsl:attribute name="margin-top">6pt</xsl:attribute>
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			</xsl:if>
		
			<xsl:if test="$document_type = 'PAS'">
				<xsl:attribute name="margin-left">0.5mm</xsl:attribute>
				<xsl:attribute name="font-size">11pt</xsl:attribute>
				<xsl:attribute name="font-style">normal</xsl:attribute>
				<xsl:attribute name="margin-bottom">-16pt</xsl:attribute> <!-- to overlap title on empty header row -->
				<xsl:if test="$continued = 'true'"> <!-- in continued table header -->
					<xsl:attribute name="margin-left">0mm</xsl:attribute>
					<xsl:attribute name="margin-top">0pt</xsl:attribute>
					<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="../@width = 'full-page-width'">
				<xsl:attribute name="margin-left">0mm</xsl:attribute>
			</xsl:if>
			<xsl:if test="../@unnumbered = 'true' and (ancestor::*[@type = 'corrigenda'] or contains(ancestor::mn:clause[1]/mn:title, 'Amendments/corrigenda'))">
				<xsl:attribute name="margin-left">0mm</xsl:attribute>
				<xsl:attribute name="font-size">9pt</xsl:attribute>
				<xsl:attribute name="font-weight">bold</xsl:attribute>
				<xsl:attribute name="font-style">normal</xsl:attribute>
				<xsl:attribute name="margin-bottom">4pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'iec'">
			<xsl:if test="$continued = 'true'">
				<xsl:attribute name="font-size">10pt</xsl:attribute>
				<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'iso'">
			<xsl:if test="$continued = 'true'">
				<xsl:attribute name="margin-bottom">2pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="$layoutVersion = '1951'">
				<xsl:attribute name="font-size">inherit</xsl:attribute>
			</xsl:if>
			<xsl:if test="$layoutVersion = '1972' or $layoutVersion = '1979' or $layoutVersion = '1987' or $layoutVersion = '1989'">
				<xsl:attribute name="font-size">10pt</xsl:attribute>
				<xsl:if test="normalize-space(../@width) != 'text-width'">
					<xsl:attribute name="span">all</xsl:attribute>
					<xsl:attribute name="margin-top">6pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:if test="not($vertical_layout = 'true')">
				<xsl:attribute name="font-family">IPAexGothic</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'plateau'">
			<xsl:if test="$doctype = 'technical-report'">
				<xsl:attribute name="font-weight">normal</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template> <!-- refine_table-name-style -->
	

	<xsl:attribute-set name="table-row-style">
		<xsl:attribute name="min-height">4mm</xsl:attribute>
		
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="min-height">0mm</xsl:attribute>
			<xsl:attribute name="line-height">110%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="min-height">3mm</xsl:attribute> <!-- + padding-top + padding-bottom -->
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="min-height">8.5mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="min-height">8.5mm</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="table-header-row-style" use-attribute-sets="table-row-style">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="font-weight">normal</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="border-top"><xsl:value-of select="$table-border"/></xsl:attribute>
			<xsl:attribute name="border-bottom"><xsl:value-of select="$table-border"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jcgm'">
			<xsl:attribute name="border-top">solid black 1pt</xsl:attribute>
			<xsl:attribute name="border-bottom">solid black 1pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="border-top">solid black 0.5pt</xsl:attribute>
			<xsl:attribute name="border-bottom">solid black 0.5pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="background-color">rgb(217, 217, 217)</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:attribute name="border-top"><xsl:value-of select="$table-border"/></xsl:attribute>
			<xsl:attribute name="border-bottom"><xsl:value-of select="$table-border"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp'  or $namespace = 'nist-sp'">
			<xsl:attribute name="font-family">Arial</xsl:attribute>
			<xsl:attribute name="font-size">10pt</xsl:attribute>
		</xsl:if>
		
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="background-color"><xsl:value-of select="$color_table_header_row"/></xsl:attribute>
			<xsl:attribute name="color">white</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'plateau'">
			<xsl:attribute name="border-top"><xsl:value-of select="$table-cell-border"/></xsl:attribute>
			<xsl:attribute name="border-bottom"><xsl:value-of select="$table-cell-border"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-weight">normal</xsl:attribute>
			<xsl:attribute name="background-color">rgb(32, 98, 169)</xsl:attribute>
			<xsl:attribute name="color">white</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:template name="refine_table-header-row-style">
		
		<xsl:if test="$namespace = 'bsi'">
			<xsl:call-template name="setBorderUnderRow" />
		
			<xsl:if test="$document_type = 'PAS'">
				<xsl:attribute name="border-top"><xsl:value-of select="$table-border"/></xsl:attribute>
				<xsl:attribute name="border-bottom"><xsl:value-of select="$table-border"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="position() = 1 and $document_type != 'PAS'">
				<xsl:attribute name="border-top">2.5pt solid black</xsl:attribute>
			</xsl:if>
			<xsl:if test="position() = last() and $document_type = 'PAS'">
				<xsl:attribute name="border-bottom">none</xsl:attribute>
			</xsl:if>
			<xsl:if test="ancestor::mn:preface">
				<xsl:attribute name="border-top">solid black 0pt</xsl:attribute>
				<xsl:attribute name="border-bottom">solid black 0pt</xsl:attribute>
				<xsl:attribute name="font-weight">normal</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'iso'">
			<xsl:choose>
				<xsl:when test="position() = 1">
					<xsl:attribute name="border-top"><xsl:value-of select="$table-border"/></xsl:attribute>
					<xsl:attribute name="border-bottom"><xsl:value-of select="$table-cell-border"/></xsl:attribute>
				</xsl:when>
				<xsl:when test="position() = last()">
					<xsl:attribute name="border-top"><xsl:value-of select="$table-cell-border"/></xsl:attribute>
					<xsl:attribute name="border-bottom"><xsl:value-of select="$table-border"/></xsl:attribute>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
		
		<xsl:call-template name="setBordersTableArray"/>
		
		<xsl:if test="$namespace = 'jcgm'">
			<xsl:choose>
				<xsl:when test="position() = 1">
					<xsl:attribute name="border-top">solid black 1.5pt</xsl:attribute>
					<xsl:attribute name="border-bottom">solid black 1pt</xsl:attribute>
				</xsl:when>
				<xsl:when test="position() = last()">
					<xsl:attribute name="border-top">solid black 1pt</xsl:attribute>
					<xsl:attribute name="border-bottom">solid black 1.5pt</xsl:attribute>
				</xsl:when>
			</xsl:choose>
		</xsl:if>

		<xsl:if test="$namespace = 'ieee'">
			<xsl:if test="position() = last()">
				<xsl:attribute name="border-bottom"><xsl:value-of select="$table-border"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="$current_template = 'whitepaper' or $current_template = 'icap-whitepaper' or $current_template = 'industry-connection-report'">
				<xsl:attribute name="border-bottom">0.5 solid black</xsl:attribute>
			</xsl:if>
		</xsl:if>

		<xsl:if test="$namespace = 'itu'">
			<xsl:variable name="doctype" select="ancestor::mn:metanorma/mn:bibdata/mn:ext/mn:doctype[not(@language) or @language = '']"/>
			<xsl:if test="$doctype = 'service-publication'">
				<xsl:attribute name="border-bottom">1.1pt solid black</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'jis'">
			<xsl:if test="ancestor::mn:preface">
				<xsl:attribute name="border-top">none</xsl:attribute>
				<xsl:attribute name="border-bottom">none</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template> <!-- refine_table-header-row-style -->
	
	<xsl:attribute-set name="table-footer-row-style" use-attribute-sets="table-row-style">
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="font-size">9pt</xsl:attribute>
			<!-- <xsl:attribute name="border-left"><xsl:value-of select="$table-border"/></xsl:attribute>
			<xsl:attribute name="border-right"><xsl:value-of select="$table-border"/></xsl:attribute> -->
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="border-left">solid black 0.5pt</xsl:attribute>
			<xsl:attribute name="border-right">solid black 0.5pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="font-size">9pt</xsl:attribute>
			<xsl:attribute name="border-left"><xsl:value-of select="$table-border"/></xsl:attribute>
			<xsl:attribute name="border-right"><xsl:value-of select="$table-border"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:attribute name="border-left"><xsl:value-of select="$table-border"/></xsl:attribute>
			<xsl:attribute name="border-right"><xsl:value-of select="$table-border"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jcgm'">
			<xsl:attribute name="font-size">9pt</xsl:attribute>
			<xsl:attribute name="border-left">solid black 1pt</xsl:attribute>
			<xsl:attribute name="border-right">solid black 1pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'plateau'">
			<xsl:attribute name="border-left"><xsl:value-of select="$table-cell-border"/></xsl:attribute>
			<xsl:attribute name="border-right"><xsl:value-of select="$table-cell-border"/></xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:template name="refine_table-footer-row-style">
		<xsl:if test="$namespace = 'bsi'">
			<xsl:if test="$document_type = 'PAS'">
				<xsl:attribute name="font-size">inherit</xsl:attribute>
				<xsl:attribute name="border-left"><xsl:value-of select="$table-border"/></xsl:attribute>
				<xsl:attribute name="border-right"><xsl:value-of select="$table-border"/></xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template> <!-- refine_table-footer-row-style -->

	
	<xsl:attribute-set name="table-body-row-style" use-attribute-sets="table-row-style">

	</xsl:attribute-set>

	<xsl:template name="refine_table-body-row-style">
		
		<xsl:if test="$namespace = 'bsi'">
			<xsl:call-template name="setBorderUnderRow" />
			<xsl:if test="position() = 1 and $document_type != 'PAS' and not(ancestor::mn:table[1]/*[local-name() = 'thead'])">
				<!-- set border for 1st row if thead is missing -->
				<xsl:attribute name="border-top">2.5pt solid black</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="ancestor::mn:preface or ancestor::mn:boilerplate">
				<xsl:attribute name="border-top">none</xsl:attribute>
				<xsl:attribute name="border-bottom">none</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="$document_type = 'PAS'">
				<xsl:variable name="number"><xsl:number/></xsl:variable>
				<xsl:attribute name="background-color">
					<xsl:choose>
						<xsl:when test="ancestor::mn:clause[@type = 'corrigenda' or contains(mn:title, 'Amendments/corrigenda')]">transparent</xsl:when>
						<xsl:when test="preceding::*[self::mn:foreword or self::mn:introduction]">
							<!-- for preface sections -->
							<xsl:choose>
								<xsl:when test="$number mod 2 = 0"><xsl:value-of select="$color_secondary_shade_4_PAS"/></xsl:when>
								<xsl:otherwise><xsl:value-of select="$color_secondary_shade_3_PAS"/></xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<!-- for main sections -->
							<xsl:choose>
								<xsl:when test="$number mod 2 = 0"><xsl:value-of select="$color_secondary_shade_3_PAS"/></xsl:when>
								<xsl:otherwise><xsl:value-of select="$color_secondary_shade_4_PAS"/></xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:if test="ancestor::mn:clause[@type = 'corrigenda' or contains(mn:title, 'Amendments/corrigenda')] and not(following-sibling::*[local-name() = 'tr'])">
					<xsl:attribute name="border-bottom">2pt solid <xsl:value-of select="$color_secondary_shade_1_PAS"/></xsl:attribute>
				</xsl:if>
			</xsl:if>
		</xsl:if>
	
		<xsl:if test="$namespace = 'ieee'">
			<xsl:if test="ancestor::mn:feedback-statement">
				<xsl:attribute name="min-height">0mm</xsl:attribute>
			</xsl:if>
		</xsl:if>
	
		<xsl:if test="$namespace = 'iso'">
			<xsl:if test="position() = 1 and not(ancestor::mn:table/*[local-name() = 'thead']) and ancestor::mn:table/mn:name">
				<xsl:attribute name="border-top"><xsl:value-of select="$table-border"/></xsl:attribute>
			</xsl:if>
		</xsl:if>
	
		<xsl:call-template name="setBordersTableArray"/>
	
		<xsl:if test="$namespace = 'ogc'">
			<xsl:variable name="number"><xsl:number/></xsl:variable>
			<xsl:attribute name="background-color">
				<xsl:choose>
					<xsl:when test="$number mod 2 = 0"><xsl:value-of select="$color_table_row_even"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="$color_table_row_odd"/></xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
		</xsl:if>
	
		<xsl:if test="$namespace = 'rsd'">
			<xsl:variable name="number"><xsl:number/></xsl:variable>
			<xsl:if test="$number mod 2 = 0">
				<xsl:attribute name="background-color">rgb(254, 247, 228)</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template> <!-- refine_table-body-row-style -->

	<xsl:attribute-set name="table-header-cell-style">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="padding-left">1mm</xsl:attribute>
		<xsl:attribute name="padding-right">1mm</xsl:attribute>
		<xsl:attribute name="display-align">center</xsl:attribute>
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="font-weight">normal</xsl:attribute>
			<xsl:attribute name="border">solid black 0pt</xsl:attribute>				
			<xsl:attribute name="border-bottom">solid black 0.5pt</xsl:attribute>
			<xsl:attribute name="height">8mm</xsl:attribute>
			<xsl:attribute name="padding-top">2mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="font-weight">normal</xsl:attribute>
			<xsl:attribute name="padding-top">1mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="border">solid black 1pt</xsl:attribute>
			<xsl:attribute name="padding-top">0.5mm</xsl:attribute>
			<xsl:attribute name="border-left"><xsl:value-of select="$table-cell-border"/></xsl:attribute>
			<xsl:attribute name="border-right"><xsl:value-of select="$table-cell-border"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="padding-top">1mm</xsl:attribute>
			<xsl:attribute name="border">solid black 0.5pt</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="padding-top">1mm</xsl:attribute>
			<xsl:attribute name="border">solid black 0.5pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="padding-top">1.5mm</xsl:attribute>
			<xsl:attribute name="padding-left">2mm</xsl:attribute>
			<xsl:attribute name="padding-bottom">1.5mm</xsl:attribute>
			<xsl:attribute name="padding-right">1.5mm</xsl:attribute>
			<xsl:attribute name="border"><xsl:value-of select="$table-border"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jcgm'">
			<xsl:attribute name="border">solid black 1pt</xsl:attribute>
			<xsl:attribute name="padding-top">1mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:attribute name="font-weight">normal</xsl:attribute>
			<xsl:attribute name="border"><xsl:value-of select="$table-border"/></xsl:attribute>
			<xsl:attribute name="padding-top">0.5mm</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'mpfd'">
			<xsl:attribute name="border">solid black 1pt</xsl:attribute>
			<xsl:attribute name="border-top">solid black 2pt</xsl:attribute>
			<xsl:attribute name="border-bottom">solid black 2pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp' or $namespace = 'nist-sp'">
			<xsl:attribute name="border">solid black 1pt</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="background-color">black</xsl:attribute>
			<xsl:attribute name="color">white</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="padding-top">1mm</xsl:attribute>
			<xsl:attribute name="padding-bottom">1mm</xsl:attribute>
			<xsl:attribute name="border">solid black 0pt</xsl:attribute>				
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:attribute name="padding">1mm</xsl:attribute>
			<xsl:attribute name="background-color">rgb(0, 51, 102)</xsl:attribute>
			<xsl:attribute name="color">white</xsl:attribute>
			<xsl:attribute name="border">solid 0.5pt rgb(153, 153, 153)</xsl:attribute>
			<xsl:attribute name="height">5mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'plateau'">
			<xsl:attribute name="font-weight">normal</xsl:attribute>
			<xsl:attribute name="border"><xsl:value-of select="$table-cell-border"/></xsl:attribute>
			<xsl:attribute name="padding-top">0.5mm</xsl:attribute>
			<xsl:attribute name="background-color">rgb(206,206,206)</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-weight">normal</xsl:attribute>
			<xsl:attribute name="border">0pt solid black</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece'">
			<xsl:attribute name="display-align">center</xsl:attribute>
			<xsl:attribute name="font-style">italic</xsl:attribute>
			<xsl:attribute name="font-weight">normal</xsl:attribute>
			<xsl:attribute name="padding-top">2mm</xsl:attribute>
			<xsl:attribute name="padding-left">2mm</xsl:attribute>
			<xsl:attribute name="border">solid black 0pt</xsl:attribute>
			<xsl:attribute name="border-top">solid black 0.2pt</xsl:attribute>
			<xsl:attribute name="border-bottom">solid black 1.5pt</xsl:attribute>
			<xsl:attribute name="text-indent">0mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece-rec'">
			<xsl:attribute name="border">solid black 1pt</xsl:attribute>
			<xsl:attribute name="text-indent">0mm</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- table-header-cell-style -->

	<xsl:template name="refine_table-header-cell-style">
			
		<xsl:if test="$namespace = 'bipm'">
			<xsl:if test="(ancestor::mn:annex and ancestor::mn:table//mn:xref[@pagenumber]) or ancestor::mn:doccontrol or ancestor::mn:colophon"><!-- for Annex ToC -->
				<xsl:attribute name="border-top">solid black 0pt</xsl:attribute>
				<xsl:attribute name="border-bottom">solid black 0pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="ancestor::mn:doccontrol or ancestor::mn:colophon">
				<xsl:call-template name="setTextAlignment">
					<xsl:with-param name="default">left</xsl:with-param>
				</xsl:call-template>
				<xsl:attribute name="display-align">before</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'bsi'">
			<xsl:if test="$document_type != 'PAS'">
				<!-- <xsl:attribute name="border">none</xsl:attribute>
				<xsl:attribute name="border-top"><xsl:value-of select="$table-border"/></xsl:attribute>
				<xsl:attribute name="border-bottom"><xsl:value-of select="$table-border"/></xsl:attribute> -->
			</xsl:if>
			<xsl:if test="ancestor::mn:preface or ancestor::mn:boilerplate">
				<xsl:attribute name="font-weight">normal</xsl:attribute>
				<xsl:attribute name="text-align">left</xsl:attribute>
				<xsl:if test="$document_type != 'PAS'">
					<xsl:attribute name="border">solid black 0pt</xsl:attribute>
				</xsl:if>
				<xsl:if test="ancestor::mn:clause[@type = 'corrigenda' or contains(mn:title, 'Amendments/corrigenda')]">
					<xsl:if test="$document_type != 'PAS'">
						<xsl:attribute name="border-top">none</xsl:attribute>
						<xsl:attribute name="border-bottom">solid black 1pt</xsl:attribute>
					</xsl:if>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$document_type = 'PAS'">
				<xsl:attribute name="border">0.75pt solid <xsl:value-of select="$color_secondary_shade_1_PAS"/></xsl:attribute>
				
				<!-- row number -->
				<xsl:variable name="number">
					<xsl:for-each select="parent::*">
						<xsl:number/>
					</xsl:for-each>
				</xsl:variable>
				<xsl:variable name="background_color">
					<xsl:choose>
						<xsl:when test="$number mod 2 = 0"><xsl:value-of select="$color_secondary_shade_2_PAS"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="$color_secondary_shade_1_PAS"/></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				
				<xsl:attribute name="background-color"><xsl:value-of select="$background_color"/></xsl:attribute>
					
				<xsl:choose>
					<xsl:when test="$background_color = 'transparent'">
						<xsl:attribute name="color"><xsl:value-of select="$color_secondary_shade_1_PAS"/></xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="color">white</xsl:attribute>
						
						<xsl:if test="not(ancestor::mn:clause[@type = 'corrigenda' or contains(mn:title, 'Amendments/corrigenda')] and ancestor::mn:thead)">
							<xsl:if test="following-sibling::*[1][local-name() = 'th']">
								<xsl:attribute name="border-right">0.75pt solid white</xsl:attribute>
							</xsl:if>
							<xsl:if test="preceding-sibling::*[1][local-name() = 'th']">
								<xsl:attribute name="border-left">0.75pt solid white</xsl:attribute>
							</xsl:if>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
				
			</xsl:if>
			<!-- bsi -->
		</xsl:if>

		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:if test="ancestor::mn:preface">
				<xsl:attribute name="font-weight">normal</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:if test="../parent::*[local-name() = 'tbody'] and (following-sibling::*[local-name() = 'td'] or preceding-sibling::*[local-name() = 'td'])">
				<xsl:attribute name="border-top"><xsl:value-of select="$table-cell-border"/></xsl:attribute>
				<xsl:attribute name="border-bottom"><xsl:value-of select="$table-cell-border"/></xsl:attribute>
			</xsl:if>
			<!-- vertical table header -->
			<xsl:if test="ancestor::*[local-name() = 'tbody'] and not(following-sibling::*[local-name() = 'th'])">
				<xsl:attribute name="border-right"><xsl:value-of select="$table-border"/></xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'jis'">
			<xsl:attribute name="text-align">center</xsl:attribute>
		</xsl:if>
		
		<xsl:call-template name="setBordersTableArray"/>
		
		<xsl:if test="$namespace = 'itu'">
			<xsl:variable name="doctype" select="ancestor::mn:metanorma/mn:bibdata/mn:ext/mn:doctype[not(@language) or @language = '']"/>
			<xsl:if test="ancestor::mn:preface">
				<xsl:if test="$doctype != 'service-publication'">
					<xsl:attribute name="border">solid black 0pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$doctype = 'service-publication'">
				<xsl:attribute name="border">1pt solid rgb(211,211,211)</xsl:attribute>
				<xsl:attribute name="border-bottom">1pt solid black</xsl:attribute>
				<xsl:attribute name="padding-top">1mm</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'jis'">
			<xsl:if test="ancestor::mn:preface">
				<xsl:attribute name="border">none</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'nist-cswp' or $namespace = 'nist-sp'">
			<xsl:attribute name="text-align">center</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:if test="starts-with(ancestor::mn:table[1]/@type, 'recommend') and normalize-space(@align) = ''">
				<xsl:call-template name="setTextAlignment">
					<xsl:with-param name="default">left</xsl:with-param>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'unece-rec'">				
			<xsl:if test="ancestor::mn:sections">
				<xsl:attribute name="border">solid black 0pt</xsl:attribute>
				<xsl:attribute name="display-align">before</xsl:attribute>
				<xsl:attribute name="padding-top">1mm</xsl:attribute>
			</xsl:if>
			<xsl:if test="ancestor::mn:annex">
				<xsl:attribute name="font-weight">normal</xsl:attribute>
				<xsl:attribute name="padding-top">1mm</xsl:attribute>
				<xsl:attribute name="background-color">rgb(218, 218, 218)</xsl:attribute>
				<xsl:variable name="header_text" select="normalize-space()"/>
				<xsl:if test="starts-with($header_text, '1') or starts-with($header_text, '2') or starts-with($header_text, '3') or starts-with($header_text, '4') or starts-with($header_text, '5') or
					starts-with($header_text, '6') or starts-with($header_text, '7') or starts-with($header_text, '8') or starts-with($header_text, '9')">
					<xsl:attribute name="color">rgb(46, 116, 182)</xsl:attribute>
					<xsl:attribute name="font-weight">bold</xsl:attribute>
				</xsl:if>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$lang = 'ar'">
			<xsl:attribute name="padding-right">1mm</xsl:attribute>
		</xsl:if>
		
		<xsl:call-template name="setTableCellAttributes"/>
		
		<xsl:if test="$namespace = 'bsi'">
			<xsl:if test="$document_type = 'PAS'">
				<xsl:if test="ancestor::mn:clause[@type = 'corrigenda' or contains(mn:title, 'Amendments/corrigenda')] and ancestor::mn:thead">
					<xsl:attribute name="display-align">center</xsl:attribute>
					<xsl:attribute name="font-weight">bold</xsl:attribute>
					<xsl:attribute name="padding-left">3mm</xsl:attribute>
				</xsl:if>
			</xsl:if>
		</xsl:if>
	</xsl:template> <!-- refine_table-header-cell-style -->

	<xsl:attribute-set name="table-cell-style">
		<xsl:attribute name="display-align">center</xsl:attribute>
		<xsl:attribute name="padding-left">1mm</xsl:attribute>
		<xsl:attribute name="padding-right">1mm</xsl:attribute>
		
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="border">solid 0pt white</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="padding-top">0.5mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="padding-top">0.5mm</xsl:attribute>
			<xsl:attribute name="border"><xsl:value-of select="$table-cell-border"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="padding-top">0.5mm</xsl:attribute>
			<xsl:attribute name="border">solid black 0.5pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="padding-top">0.5mm</xsl:attribute>
			<xsl:attribute name="border">solid black 0.5pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="padding-top">1.5mm</xsl:attribute>
			<xsl:attribute name="padding-left">2mm</xsl:attribute>
			<xsl:attribute name="padding-bottom">1.5mm</xsl:attribute>
			<xsl:attribute name="padding-right">1.5mm</xsl:attribute>
			<xsl:attribute name="border"><xsl:value-of select="$table-border"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="border">solid black 1pt</xsl:attribute>
			<xsl:attribute name="display-align">before</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jcgm'">
			<xsl:attribute name="border">solid black 1pt</xsl:attribute>
			<xsl:attribute name="padding-top">0.5mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:attribute name="padding-top">0.5mm</xsl:attribute>
			<xsl:attribute name="border"><xsl:value-of select="$table-border"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="border">solid 0pt white</xsl:attribute>
			<xsl:attribute name="padding-top">1mm</xsl:attribute>			
			<xsl:attribute name="padding-bottom">1mm</xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:attribute name="padding-top">1mm</xsl:attribute>			
			<xsl:attribute name="border">solid 0.5pt rgb(153, 153, 153)</xsl:attribute>
			<xsl:attribute name="height">5mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'plateau'">
			<xsl:attribute name="padding-top">0.5mm</xsl:attribute>
			<xsl:attribute name="border"><xsl:value-of select="$table-cell-border"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="border">0pt solid black</xsl:attribute>
			<xsl:attribute name="padding-top">0.5mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece'">
			<xsl:attribute name="display-align">before</xsl:attribute>
			<xsl:attribute name="padding-left">0mm</xsl:attribute>
			<xsl:attribute name="padding-top">2mm</xsl:attribute>
			<xsl:attribute name="padding-bottom">1mm</xsl:attribute>
			<xsl:attribute name="border">solid black 0pt</xsl:attribute>
			<xsl:attribute name="border-bottom">solid black 1.5pt</xsl:attribute>
			<xsl:attribute name="text-indent">0mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece-rec'">
			<xsl:attribute name="border">solid black 1pt</xsl:attribute>
			<xsl:attribute name="text-indent">0mm</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- table-cell-style -->

	<xsl:template name="refine_table-cell-style">
			
		<xsl:if test="$lang = 'ar'">
			<xsl:attribute name="padding-right">1mm</xsl:attribute>
		</xsl:if>
		
		<xsl:if test="$namespace = 'bipm'">
			<xsl:variable name="rownum"><xsl:number count="*[local-name()='tr']"/></xsl:variable>
			<xsl:if test="$rownum = 1">
				<xsl:attribute name="padding-top">3mm</xsl:attribute>
			</xsl:if>
			<xsl:if test="preceding-sibling::*[local-name() = 'th']">
				<xsl:attribute name="padding-top">2mm</xsl:attribute>
			</xsl:if>
			<xsl:if test="not(ancestor::*[local-name()='tr']/following-sibling::*[local-name()='tr'])"> <!-- last row -->
				<xsl:attribute name="padding-bottom">2mm</xsl:attribute>
			</xsl:if>
			<xsl:if test="ancestor::mn:doccontrol or ancestor::mn:colophon">
				<xsl:attribute name="display-align">before</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'bsi'">
			<xsl:if test="$document_type != 'PAS'">
				<!-- <xsl:attribute name="border">none</xsl:attribute>
				<xsl:attribute name="border-top"><xsl:value-of select="$table-border"/></xsl:attribute>
				<xsl:attribute name="border-bottom"><xsl:value-of select="$table-border"/></xsl:attribute> -->
			</xsl:if>

			<xsl:if test="$document_type = 'PAS'">
				<xsl:attribute name="padding-left">1.5mm</xsl:attribute>
				<xsl:attribute name="padding-right">1.5mm</xsl:attribute>
				<xsl:attribute name="padding-top">1mm</xsl:attribute>
				<xsl:attribute name="padding-bottom">1mm</xsl:attribute>
			</xsl:if>

			<xsl:if test="not(ancestor::mn:preface) and ancestor::mn:table/*[local-name() = 'thead'] and not(ancestor::*[local-name() = 'tr']/preceding-sibling::*[local-name() = 'tr'])">
				<!-- first row in table body, and if exists header -->
				<xsl:attribute name="border-top">0pt solid black</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="count(*) = 1 and local-name(*[1]) = 'figure'">
				<xsl:attribute name="padding-top">3mm</xsl:attribute>
				<xsl:attribute name="padding-left">3mm</xsl:attribute>
				<xsl:attribute name="padding-bottom">3mm</xsl:attribute>
				<xsl:attribute name="padding-right">3mm</xsl:attribute>
			</xsl:if>
			
			<!-- Key table for figure -->
			<xsl:if test="ancestor::mn:table[1]/preceding-sibling::*[1][self::mn:figure] and 
			(ancestor::mn:table[1]//*[local-name() = 'tr'][1]/*[local-name() = 'td'][normalize-space() = 'Key'] or
			normalize-space(substring-after(ancestor::mn:table[1]/mn:name, '—')) = 'Key' or 
			normalize-space(ancestor::mn:table[1]/mn:name) = 'Key')">
				<xsl:attribute name="border">none</xsl:attribute>
				
				<xsl:if test="count(*) = 1 and local-name(*[1]) = 'figure'">
					<xsl:attribute name="padding-top">0.5mm</xsl:attribute>
					<xsl:attribute name="padding-left">0mm</xsl:attribute>
					<xsl:attribute name="padding-bottom">0mm</xsl:attribute>
					<xsl:attribute name="padding-right">0mm</xsl:attribute>
				</xsl:if>
			</xsl:if>
			
			<xsl:if test="(ancestor::mn:preface and ancestor::mn:clause[@type = 'corrigenda']) or
			(ancestor::mn:copyright-statement and contains(ancestor::mn:clause[1]/mn:title, 'Amendments/corrigenda'))">
				<xsl:if test="normalize-space(parent::*[local-name() = 'tr']) = ''">
					<xsl:attribute name="border">none</xsl:attribute>
					<xsl:if test="$document_type != 'PAS'">
						<xsl:attribute name="border-top">none</xsl:attribute>
						<xsl:attribute name="border-bottom">none</xsl:attribute>
					</xsl:if>
				</xsl:if>
				<xsl:if test="$document_type != 'PAS'">
					<xsl:attribute name="border">none</xsl:attribute>
					<xsl:if test="$document_type != 'PAS'">
						<xsl:attribute name="border-top">none</xsl:attribute>
						<xsl:attribute name="border-bottom">none</xsl:attribute>
					</xsl:if>
					<xsl:attribute name="padding-top">1mm</xsl:attribute>
				</xsl:if>
				
				<xsl:if test="$document_type = 'PAS'">
					<!-- if left column -->
					<xsl:if test="not(preceding-sibling::*)">
						<xsl:attribute name="background-color"><xsl:value-of select="$color_secondary_shade_3_PAS"/></xsl:attribute>
					</xsl:if>
					<xsl:attribute name="border-right">none</xsl:attribute>
					<xsl:attribute name="border-left">none</xsl:attribute>
				</xsl:if>
			</xsl:if>
			
			<xsl:if test="starts-with(ancestor::mn:table/@id, 'boxed-text')">
				<xsl:attribute name="padding-left">2mm</xsl:attribute>
				<xsl:attribute name="padding-right">2mm</xsl:attribute>
				<xsl:attribute name="padding-top">4mm</xsl:attribute>
				<xsl:attribute name="padding-bottom">4mm</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="ancestor::mn:tfoot">
				<xsl:attribute name="border">solid black 0</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="$document_type = 'PAS'">
				<xsl:attribute name="border">0.75pt solid <xsl:value-of select="$color_secondary_shade_1_PAS"/></xsl:attribute>
				<!-- two-columns table without name renders without borders -->
				<xsl:if test="ancestor::mn:table[count(mn:colgroup/mn:col) = 2 and not(mn:name) and not(*[local-name() = 'thead'])]">
					<xsl:attribute name="border">none</xsl:attribute>
				</xsl:if>
			</xsl:if>
			
			<xsl:if test="ancestor::mn:preface and ancestor::mn:clause[@type = 'logos']">
				<xsl:attribute name="border">none</xsl:attribute>
			</xsl:if>
			<!-- bsi -->
		</xsl:if>
		
		<xsl:if test="$namespace = 'gb'">
			<xsl:if test="ancestor::mn:tfoot">
				<xsl:attribute name="border-bottom">solid black 0</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'iec'">
			<xsl:if test="ancestor::mn:preface">
				<xsl:attribute name="text-align">center</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'ieee'">
			<xsl:if test="ancestor::mn:feedback-statement">
				<xsl:attribute name="padding-left">0mm</xsl:attribute>
				<xsl:attribute name="padding-top">0mm</xsl:attribute>
				<xsl:attribute name="padding-right">0mm</xsl:attribute>
				<xsl:attribute name="border">none</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'iso'">
			<xsl:if test="ancestor::mn:tfoot">
				<xsl:attribute name="border">solid black 0</xsl:attribute>
			</xsl:if>
			<xsl:if test="starts-with(ancestor::mn:table[1]/@type, 'recommend')">
				<xsl:attribute name="display-align">before</xsl:attribute>
			</xsl:if>
			<xsl:if test="ancestor::*[local-name() = 'tbody'] and not(../preceding-sibling::*[local-name() = 'tr']) and ancestor::mn:table[1]/*[local-name() = 'thead']"> <!-- cells in 1st row in the table body, and if thead exists -->
				<xsl:attribute name="border-top">0pt solid black</xsl:attribute>
			</xsl:if>
			<xsl:if test="$layoutVersion = '1951'">
				<xsl:if test="ancestor::mn:table[1]/@unnumbered = 'true' and ancestor::mn:preface">
					<xsl:attribute name="border">none</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<!-- <xsl:attribute name="page-break-inside">avoid</xsl:attribute> -->
		</xsl:if>
		
		<xsl:call-template name="setBordersTableArray"/>
		
		<xsl:if test="$namespace = 'itu'">
			<xsl:if test="ancestor::mn:preface">
				<xsl:attribute name="border">solid black 0pt</xsl:attribute>
			</xsl:if>
			<xsl:variable name="doctype" select="ancestor::mn:metanorma/mn:bibdata/mn:ext/mn:doctype[not(@language) or @language = '']"/>
			<xsl:if test="$doctype = 'service-publication'">
				<xsl:attribute name="border">1pt solid rgb(211,211,211)</xsl:attribute>
				<xsl:attribute name="padding-top">1mm</xsl:attribute>
			</xsl:if>
		</xsl:if>

		<xsl:if test="$namespace = 'jcgm'">
			<xsl:if test="count(*) = 1 and (local-name(*[1]) = 'stem' or local-name(*[1]) = 'figure')">
				<xsl:attribute name="padding-left">0mm</xsl:attribute>
			</xsl:if>
			<xsl:if test="ancestor::mn:tfoot">
				<xsl:attribute name="border">solid black 0</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'jis'">
			<xsl:if test="ancestor::mn:preface">
				<xsl:attribute name="border">none</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'nist-cswp'  or $namespace = 'nist-sp'">
			<xsl:if test="ancestor::*[local-name()='thead']">
				<xsl:attribute name="font-weight">normal</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'unece-rec'">
			<xsl:if test="ancestor::mn:sections">
				<xsl:attribute name="border">solid black 0pt</xsl:attribute>
				<xsl:attribute name="padding-top">1mm</xsl:attribute>					
			</xsl:if>
		</xsl:if>
		
	</xsl:template> <!-- refine_table-cell-style -->

	<xsl:attribute-set name="table-footer-cell-style">
		<xsl:attribute name="border">solid black 1pt</xsl:attribute>
		<xsl:attribute name="padding-left">1mm</xsl:attribute>
		<xsl:attribute name="padding-right">1mm</xsl:attribute>
		<xsl:attribute name="padding-top">1mm</xsl:attribute>
		
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="border">solid black 0pt</xsl:attribute>
		</xsl:if>
		
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="border"><xsl:value-of select="$table-border"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="border-top">solid black 0pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="border"><xsl:value-of select="$table-border"/></xsl:attribute>
			<xsl:attribute name="border-top">solid black 0pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="border">solid black 0.5pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="border">solid black 0.5pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="border"><xsl:value-of select="$table-border"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jcgm'">
			<xsl:attribute name="border-top">solid black 0pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:attribute name="border"><xsl:value-of select="$table-border"/></xsl:attribute>
			<xsl:attribute name="border-top">solid black 0pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="border">solid black 0pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'plateau'">
			<xsl:attribute name="border"><xsl:value-of select="$table-cell-border"/></xsl:attribute>
			<xsl:attribute name="border-top">solid black 0pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="border">solid black 0pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- table-footer-cell-style -->
	
	<xsl:template name="refine_table-footer-cell-style">
		<xsl:if test="$namespace = 'bsi'">
			<xsl:if test="$document_type != 'PAS'">
				<xsl:attribute name="border">none</xsl:attribute>
				<xsl:attribute name="border-top"><xsl:value-of select="$table-border"/></xsl:attribute>
				<xsl:attribute name="border-bottom"><xsl:value-of select="$table-border"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="$document_type = 'PAS'">
				<xsl:attribute name="border">0.75pt solid <xsl:value-of select="$color_secondary_shade_1_PAS"/></xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:if test="$layoutVersion = '2024'">
				<xsl:attribute name="border-top"><xsl:value-of select="$table-border"/></xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:variable name="doctype" select="ancestor::mn:metanorma/mn:bibdata/mn:ext/mn:doctype[not(@language) or @language = '']"/>
			<xsl:if test="ancestor::mn:preface">
				<xsl:if test="$doctype != 'service-publication'">
					<xsl:attribute name="border">solid black 0pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$doctype = 'service-publication'">
				<xsl:attribute name="border">none</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template> <!-- refine_table-footer-cell-style -->

	
	<xsl:attribute-set name="table-note-style">
		<xsl:attribute name="font-size">10pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="text-align">justify</xsl:attribute>
			<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="font-size">9pt</xsl:attribute>
			<xsl:attribute name="font-style">italic</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="font-size">9pt</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="font-size">9pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="font-size">8pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="font-size">inherit</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="font-size">inherit</xsl:attribute>
			<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			<xsl:attribute name="space-after">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jcgm'">
			<xsl:attribute name="font-size">9pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:attribute name="font-size">inherit</xsl:attribute>
			<xsl:attribute name="margin-bottom">1pt</xsl:attribute>
			<xsl:attribute name="margin-left"><xsl:value-of select="$text_indent"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-size">8pt</xsl:attribute>					
		</xsl:if>
		<xsl:if test="$namespace = 'plateau'">
			<xsl:attribute name="font-size">inherit</xsl:attribute>
			<xsl:attribute name="margin-bottom">1pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set><!-- table-note-style -->
	
	<xsl:template name="refine_table-note-style">
		<xsl:if test="$namespace = 'bipm'">					
			<xsl:if test="ancestor::mn:preface">
				<xsl:attribute name="margin-top">18pt</xsl:attribute>
				<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'bsi'">
			<xsl:if test="$document_type = 'PAS'">
				<xsl:attribute name="font-size">inherit</xsl:attribute>
				<xsl:attribute name="color"><xsl:value-of select="$color_secondary_shade_1_PAS"/></xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'plateau'">
			<xsl:attribute name="margin-left"><xsl:value-of select="$tableAnnotationIndent"/></xsl:attribute>
		</xsl:if>
	</xsl:template> <!-- refine_table-note-style -->
	
	<xsl:attribute-set name="table-fn-style">
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="font-size">9pt</xsl:attribute>
			<xsl:attribute name="text-indent">-6.5mm</xsl:attribute>
			<xsl:attribute name="margin-left">6.5mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="font-size">9pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="text-indent">7.4mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			<xsl:attribute name="line-height">130%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso' or $namespace = 'jcgm'">
			<xsl:attribute name="font-size">9pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="font-size">inherit</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="text-indent">-3mm</xsl:attribute>
			<xsl:attribute name="margin-left">3mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="font-size">8pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="text-indent">-6mm</xsl:attribute>
			<xsl:attribute name="margin-left">6mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="margin-bottom">2pt</xsl:attribute>
			<xsl:attribute name="line-height-shift-adjustment">disregard-shifts</xsl:attribute>
			<xsl:attribute name="text-indent">-5mm</xsl:attribute>
			<xsl:attribute name="start-indent">5mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:attribute name="font-size">inherit</xsl:attribute>
			<xsl:attribute name="margin-bottom">1pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'plateau'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">1pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- table-fn-style -->
	
	<xsl:template name="refine_table-fn-style">
		<xsl:if test="$namespace = 'iso'">
			<xsl:if test="$layoutVersion = '2024'">
				<xsl:attribute name="margin-bottom">5pt</xsl:attribute>
				<xsl:if test="position() = last()">
					<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'plateau'">
			<xsl:attribute name="margin-left"><xsl:value-of select="$tableAnnotationIndent"/></xsl:attribute>
		</xsl:if>
	</xsl:template>
	
	<xsl:attribute-set name="table-fn-number-style">
		<!-- <xsl:attribute name="padding-right">5mm</xsl:attribute> -->
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="font-style">italic</xsl:attribute>
			<!-- <xsl:attribute name="padding-right">2.5mm</xsl:attribute> -->
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<!-- <xsl:attribute name="padding-right">3mm</xsl:attribute> -->
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<!-- <xsl:attribute name="padding-right">0mm</xsl:attribute> -->
		</xsl:if>
		<xsl:if test="$namespace = 'plateau'">
			<xsl:attribute name="font-size">100%</xsl:attribute>
			<!-- <xsl:attribute name="padding-right">2mm</xsl:attribute> -->
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- table-fn-number-style -->
	
	<xsl:attribute-set name="table-fmt-fn-label-style">
		<xsl:attribute name="font-size">80%</xsl:attribute>
		<xsl:if test="$namespace = 'csd'">
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="baseline-shift">30%</xsl:attribute>
			<!--<xsl:attribute name="font-size">6pt</xsl:attribute> -->
			<xsl:attribute name="font-size">5.5pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bipm'">
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="font-size">50%</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'iso' or $namespace = 'jcgm'">
			<xsl:attribute name="alignment-baseline">hanging</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="baseline-shift">30%</xsl:attribute>
			<xsl:attribute name="font-size">70%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="baseline-shift">30%</xsl:attribute>
			<xsl:attribute name="font-size">6.5pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="vertical-align">super</xsl:attribute>
			<xsl:attribute name="font-size">70%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="font-size">67%</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'm3d'">
			<xsl:attribute name="baseline-shift">30%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp' or $namespace = 'nist-sp'">
			<xsl:attribute name="vertical-align">super</xsl:attribute>
			<xsl:attribute name="font-size">10pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'plateau'">
			<xsl:attribute name="font-size">60%</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece' or $namespace = 'unece-rec'">
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- table-fmt-fn-label-style -->
	
	<xsl:template name="refine_table-fmt-fn-label-style">
		<xsl:if test="$namespace = 'bsi'">
			<xsl:if test="$document_type = 'PAS'">
				<!-- <xsl:attribute name="font-size">80%</xsl:attribute> -->
				<xsl:attribute name="font-size">4.5pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:if test="$layoutVersion = '2024'">
				<xsl:attribute name="alignment-baseline">auto</xsl:attribute>
				<xsl:attribute name="baseline-shift">15%</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:if test="not($vertical_layout = 'true')">
				<xsl:attribute name="font-family">Times New Roman</xsl:attribute>
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
	
	<xsl:attribute-set name="table-fn-body-style">
		<xsl:if test="$namespace = 'nist-cswp' or $namespace = 'nist-sp'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="figure-fn-number-style">
		<xsl:attribute name="padding-right">5mm</xsl:attribute>
	</xsl:attribute-set> <!-- figure-fn-number-style -->
	
	<xsl:attribute-set name="figure-fmt-fn-label-style">
		<xsl:attribute name="font-size">80%</xsl:attribute>
		<xsl:attribute name="vertical-align">super</xsl:attribute>
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="baseline-shift">30%</xsl:attribute>
			<xsl:attribute name="font-size">5.5pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="baseline-shift">65%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'm3d'">
			<xsl:attribute name="baseline-shift">30%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'plateau'">
			<xsl:attribute name="font-size">60%</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- figure-fmt-fn-label-style -->
	
	<xsl:template name="refine_figure-fmt-fn-label-style">
		<xsl:if test="$namespace = 'bsi'">
			<xsl:if test="$document_type = 'PAS'">
				<xsl:attribute name="font-size">4.5pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	
	<xsl:attribute-set name="figure-fn-body-style">
		<xsl:attribute name="text-align">justify</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="margin-top">5pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">10pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	<!-- ========================== -->
	<!-- END Table styles -->
	<!-- ========================== -->
	
	<xsl:template match="*[local-name()='table']" priority="2">
		<xsl:choose>
			<xsl:when test="$table_only_with_id != '' and @id = $table_only_with_id">
				<xsl:call-template name="table"/>
			</xsl:when>
			<xsl:when test="$table_only_with_id != ''"><fo:block/><!-- to prevent empty fo:block-container --></xsl:when>
			<xsl:when test="$table_only_with_ids != '' and contains($table_only_with_ids, concat(@id, ' '))">
				<xsl:call-template name="table"/>
			</xsl:when>
			<xsl:when test="$table_only_with_ids != ''"><fo:block/><!-- to prevent empty fo:block-container --></xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="table"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*[local-name()='table']" name="table">
	
		<xsl:variable name="table-preamble">
			<xsl:if test="$namespace = 'itu'">
				<xsl:variable name="doctype" select="ancestor::mn:metanorma/mn:bibdata/mn:ext/mn:doctype[not(@language) or @language = '']"/>
				<xsl:if test="$doctype != 'service-publication'">
					<fo:block space-before="18pt">&#xA0;</fo:block>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$namespace = 'ogc'">
				<fo:block>&#xA0;</fo:block>
			</xsl:if>
		</xsl:variable>
		
		<xsl:variable name="table">
	
			<xsl:variable name="simple-table">
				<xsl:if test="$isGenerateTableIF = 'true' and $isApplyAutolayoutAlgorithm = 'true'">
					<xsl:call-template name="getSimpleTable">
						<xsl:with-param name="id" select="@id"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:variable>
			
			<xsl:if test="$debug = 'true' and normalize-space($simple-table) != ''">
				<!-- <redirect:write file="simple-table_{@id}.xml">
					<xsl:copy-of select="$simple-table"/>
				</redirect:write> -->
			</xsl:if>
			<!-- <xsl:variable name="simple-table" select="xalan:nodeset($simple-table_)"/> -->
		
			<!-- simple-table=<xsl:copy-of select="$simple-table"/> -->
		
			
			<!-- Display table's name before table as standalone block -->
			<!-- $namespace = 'iso' or  -->
			<xsl:choose>
				<xsl:when test="$namespace = 'bsi'">
					<xsl:if test="$document_type != 'PAS'">
						<xsl:apply-templates select="mn:name" />
					</xsl:if>
				</xsl:when>
				<xsl:when test="$namespace = 'ieee' or $namespace = 'jcgm'"></xsl:when> <!-- table name will be rendered in table-header --> <!--  or $namespace = 'iso'  -->
				<xsl:when test="$namespace = 'ogc-white-paper'"></xsl:when> <!-- table's title will be rendered after table -->
				<xsl:otherwise>
					<xsl:apply-templates select="mn:name" /> <!-- table's title rendered before table -->
				</xsl:otherwise>
			</xsl:choose>
			
			<xsl:choose>
				<xsl:when test="$namespace = 'bsi' or $namespace = 'csa' or $namespace = 'iso' or $namespace = 'jcgm' or $namespace = 'nist-cswp' or $namespace = 'nist-sp' or $namespace = 'rsd'"></xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="table_name_fn_display"/>
				</xsl:otherwise>
			</xsl:choose>
			
			<xsl:variable name="cols-count" select="count(xalan:nodeset($simple-table)/*/mn:tr[1]/mn:td)"/>
			
			<xsl:variable name="colwidths">
				<xsl:if test="not(mn:colgroup/mn:col) and not(@class = 'dl')">
					<xsl:call-template name="calculate-column-widths">
						<xsl:with-param name="cols-count" select="$cols-count"/>
						<xsl:with-param name="table" select="$simple-table"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:variable>
			<!-- <xsl:variable name="colwidths" select="xalan:nodeset($colwidths_)"/> -->
			
			<!-- DEBUG -->
			<xsl:if test="$table_if_debug = 'true'">
				<fo:block font-size="60%">
					<xsl:apply-templates select="xalan:nodeset($colwidths)" mode="print_as_xml"/>
				</fo:block>
			</xsl:if>
			
			
			<!-- <xsl:copy-of select="$colwidths"/> -->
			
			<!-- <xsl:text disable-output-escaping="yes">&lt;!- -</xsl:text>
			DEBUG
			colwidths=<xsl:copy-of select="$colwidths"/>
		<xsl:text disable-output-escaping="yes">- -&gt;</xsl:text> -->
			
			
			
			<xsl:variable name="margin-side">
				<xsl:choose>
					<xsl:when test="$isApplyAutolayoutAlgorithm = 'true'">0</xsl:when>
					<xsl:when test="$isApplyAutolayoutAlgorithm = 'skip'">0</xsl:when>
					<xsl:when test="sum(xalan:nodeset($colwidths)//column) &gt; 75">15</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:call-template name="setNamedDestination"/>
			
			<fo:block-container xsl:use-attribute-sets="table-container-style" role="SKIP">
			
				<xsl:for-each select="mn:name">
					<xsl:call-template name="setIDforNamedDestination"/>
				</xsl:for-each>
			
				<xsl:call-template name="refine_table-container-style">
					<xsl:with-param name="margin-side" select="$margin-side"/>
				</xsl:call-template>
			
				<!-- display table's name before table for PAS inside block-container (2-columnn layout) -->
				<xsl:if test="$namespace = 'bsi'">
					<xsl:if test="$document_type = 'PAS'">
						<xsl:apply-templates select="mn:name" />
					</xsl:if>
				</xsl:if>
				
				<xsl:variable name="table_width_default">100%</xsl:variable>
				<xsl:variable name="table_width">
					<!-- for centered table always 100% (@width will be set for middle/second cell of outer table) -->
					<xsl:choose>
						<xsl:when test="$namespace = 'bipm' or $namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'unece' or $namespace = 'unece-rec'">
							<xsl:choose>
								<xsl:when test="@width = 'full-page-width' or @width = 'text-width'">100%</xsl:when>
								<xsl:when test="@width"><xsl:value-of select="@width"/></xsl:when>
								<xsl:otherwise><xsl:value-of select="$table_width_default"/></xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="$namespace = 'ieee'">
							<xsl:choose>
								<xsl:when test="ancestor::mn:feedback-statement">50%</xsl:when>
								<xsl:when test="@width = 'full-page-width' or @width = 'text-width'">100%</xsl:when>
								<xsl:when test="@width"><xsl:value-of select="@width"/></xsl:when>
								<xsl:otherwise><xsl:value-of select="$table_width_default"/></xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise><xsl:value-of select="$table_width_default"/></xsl:otherwise> <!-- bsi, csa, csd, gb, iec, iho, iso, itu, jcgm, m3d, mpfd, nist-cswp, nist-sp, rsd -->
					</xsl:choose>
				</xsl:variable>
				
				
				<xsl:variable name="table_attributes">
				
					<xsl:element name="table_attributes" use-attribute-sets="table-style">
						
						<xsl:if test="$margin-side != 0">
							<xsl:attribute name="margin-left">0mm</xsl:attribute>
							<xsl:attribute name="margin-right">0mm</xsl:attribute>
						</xsl:if>
					
						<xsl:attribute name="width"><xsl:value-of select="normalize-space($table_width)"/></xsl:attribute>
						
						<xsl:call-template name="refine_table-style">
							<xsl:with-param name="margin-side" select="$margin-side"/>
						</xsl:call-template>
						
					</xsl:element>
				</xsl:variable>
				
				<xsl:if test="$isGenerateTableIF = 'true'">
					<!-- to determine start of table -->
					<fo:block id="{concat('table_if_start_',@id)}" keep-with-next="always" font-size="1pt">Start table '<xsl:value-of select="@id"/>'.</fo:block>
				</xsl:if>
				
				<fo:table id="{@id}">
					
					<xsl:if test="$isGenerateTableIF = 'true'">
						<xsl:attribute name="wrap-option">no-wrap</xsl:attribute>
					</xsl:if>
					
					<xsl:for-each select="xalan:nodeset($table_attributes)/table_attributes/@*">
						<xsl:attribute name="{local-name()}">
							<xsl:value-of select="."/>
						</xsl:attribute>
					</xsl:for-each>
					
					<xsl:variable name="isNoteOrFnExist" select="./mn:note[not(@type = 'units')] or ./mn:example or .//mn:fn[local-name(..) != 'name'] or ./mn:source"/>				
					<xsl:if test="$isNoteOrFnExist = 'true'">
						<!-- <xsl:choose>
							<xsl:when test="$namespace = 'plateau'"></xsl:when>
							<xsl:otherwise>
								
							</xsl:otherwise>
						</xsl:choose> -->
						<xsl:attribute name="border-bottom">0pt solid black</xsl:attribute><!-- set 0pt border, because there is a separete table below for footer -->
					</xsl:if>
					
					
					<xsl:choose>
						<xsl:when test="$isGenerateTableIF = 'true'">
							<!-- generate IF for table widths -->
							<!-- example:
								<tr>
									<td valign="top" align="left" id="tab-symdu_1_1">
										<p>Symbol</p>
										<word id="tab-symdu_1_1_word_1">Symbol</word>
									</td>
									<td valign="top" align="left" id="tab-symdu_1_2">
										<p>Description</p>
										<word id="tab-symdu_1_2_word_1">Description</word>
									</td>
								</tr>
							-->
							<!-- <debug-simple-table><xsl:copy-of select="$simple-table"/></debug-simple-table> -->
							
							<xsl:apply-templates select="xalan:nodeset($simple-table)" mode="process_table-if"/>
							
						</xsl:when>
						<xsl:otherwise>
					
							<xsl:choose>
								<xsl:when test="mn:colgroup/mn:col">
									<xsl:for-each select="mn:colgroup/mn:col">
										<fo:table-column column-width="{@width}"/>
									</xsl:for-each>
								</xsl:when>
								<xsl:when test="@class = 'dl'">
									<xsl:for-each select=".//*[local-name()='tr'][1]/*">
										<fo:table-column column-width="{@width}"/>
									</xsl:for-each>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="insertTableColumnWidth">
										<xsl:with-param name="colwidths" select="$colwidths"/>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
							
							<xsl:choose>
								<xsl:when test="not(*[local-name()='tbody']) and *[local-name()='thead']">
									<xsl:apply-templates select="*[local-name()='thead']" mode="process_tbody"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:apply-templates select="node()[not(self::mn:name) and not(self::mn:note) and not(self::mn:example) and not(self::mn:dl) and not(self::mn:source) and not(self::mn:p)
									and not(self::mn:thead) and not(self::mn:tfoot) and not(self::mn:fmt-footnote-container)]" /> <!-- process all table' elements, except name, header, footer, note, source and dl which render separaterely -->
								</xsl:otherwise>
							</xsl:choose>
					
						</xsl:otherwise>
					</xsl:choose>
					
				</fo:table>
				
				<xsl:variable name="colgroup" select="mn:colgroup"/>
				
				<!-- https://github.com/metanorma/metanorma-plateau/issues/171 -->
				<xsl:choose>
					<xsl:when test="$namespace = 'plateau'"><!-- table footer after table --></xsl:when>
					<xsl:otherwise>
						
					</xsl:otherwise>
				</xsl:choose>
				
				<xsl:for-each select="*[local-name()='tbody']"><!-- select context to tbody -->
					<xsl:call-template name="insertTableFooterInSeparateTable">
						<xsl:with-param name="table_attributes" select="$table_attributes"/>
						<xsl:with-param name="colwidths" select="$colwidths"/>				
						<xsl:with-param name="colgroup" select="$colgroup"/>				
					</xsl:call-template>
				</xsl:for-each>
				
				<xsl:if test="$namespace = 'gb'">
					<xsl:apply-templates select="mn:note" />
				</xsl:if>
				
				<xsl:if test="$namespace = 'ogc-white-paper'">
					<xsl:apply-templates select="mn:name" />
				</xsl:if>
				
				<!-- https://github.com/metanorma/metanorma-plateau/issues/171
				<xsl:if test="$namespace = 'plateau'">
					<xsl:apply-templates select="*[not(local-name()='thead') and not(local-name()='tbody') and not(local-name()='tfoot') and not(local-name()='name')]" />
					<xsl:for-each select="*[local-name()='tbody']"> - select context to tbody -
						<xsl:variable name="table_fn_block">
							<xsl:call-template name="table_fn_display" />
						</xsl:variable>
						<xsl:copy-of select="$table_fn_block"/>
					</xsl:for-each>
				</xsl:if> -->
				
				<xsl:if test="*[local-name()='bookmark']"> <!-- special case: table/bookmark -->
					<fo:block keep-with-previous="always" line-height="0.1">
						<xsl:for-each select="*[local-name()='bookmark']">
							<xsl:call-template name="bookmark"/>
						</xsl:for-each>
					</fo:block>
				</xsl:if>
				
				<xsl:if test="$namespace = 'bsi'">
					<!-- clear 'table_number' and 'table_continued' to fix Apache FOP issue: https://github.com/metanorma/metanorma-bsi/issues/381 -->
					<xsl:if test="$document_type = 'PAS'">
						<fo:block font-size="0">
							<fo:marker marker-class-name="table_number"/>
							<fo:marker marker-class-name="table_continued"/>
						</fo:block>
					</xsl:if>
				</xsl:if>
				
			</fo:block-container>
		</xsl:variable> <!-- END: variable name="table" -->
		
		<xsl:variable name="isAdded" select="@added"/>
		<xsl:variable name="isDeleted" select="@deleted"/>
		
		<xsl:choose>
			<xsl:when test="@width and @width != 'full-page-width' and @width != 'text-width'">
	
				<!-- centered table when table name is centered (see table-name-style) -->
				<xsl:if test="$namespace = 'bsi' or $namespace = 'csa' or $namespace = 'csd' or $namespace = 'gb' or 
								$namespace = 'iec' or $namespace = 'iho' or  $namespace = 'iso' or $namespace = 'itu' or 
								$namespace = 'jcgm' or $namespace = 'jis' 
								$namespace = 'm3d' or $namespace = 'mpfd' or 
								$namespace = 'plateau' or 
								$namespace = 'nist-cswp' or $namespace = 'nist-sp' or 
								$namespace = 'rsd'">
					<fo:table table-layout="fixed" width="100%" xsl:use-attribute-sets="table-container-style" role="SKIP">
						<xsl:if test="$namespace = 'iso'">
							<xsl:if test="$layoutVersion = '1951'">
								<xsl:attribute name="font-size">inherit</xsl:attribute>
							</xsl:if>
							<xsl:if test="$layoutVersion = '2024'">
								<xsl:attribute name="margin-top">12pt</xsl:attribute>
								<xsl:attribute name="margin-bottom">2pt</xsl:attribute>
							</xsl:if>
						</xsl:if>
						<fo:table-column column-width="proportional-column-width(1)"/>
						<fo:table-column column-width="{@width}"/>
						<fo:table-column column-width="proportional-column-width(1)"/>
						<fo:table-body role="SKIP">
							<fo:table-row role="SKIP">
								<fo:table-cell column-number="2" role="SKIP">
									<xsl:copy-of select="$table-preamble"/>
									<fo:block role="SKIP">
										<xsl:call-template name="setTrackChangesStyles">
											<xsl:with-param name="isAdded" select="$isAdded"/>
											<xsl:with-param name="isDeleted" select="$isDeleted"/>
										</xsl:call-template>
										<xsl:copy-of select="$table"/>
									</fo:block>
								</fo:table-cell>
							</fo:table-row>
						</fo:table-body>
					</fo:table>
				</xsl:if>
				
				<xsl:if test="$namespace = 'bipm' or $namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'unece' or $namespace = 'unece-rec'">
					<xsl:choose>
						<xsl:when test="$isAdded = 'true' or $isDeleted = 'true'">
							<xsl:copy-of select="$table-preamble"/>
							<fo:block>
								<xsl:call-template name="setTrackChangesStyles">
									<xsl:with-param name="isAdded" select="$isAdded"/>
									<xsl:with-param name="isDeleted" select="$isDeleted"/>
								</xsl:call-template>
								<xsl:copy-of select="$table"/>
							</fo:block>
						</xsl:when>
						<xsl:otherwise>
							<xsl:copy-of select="$table-preamble"/>
							<xsl:copy-of select="$table"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
				
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$isAdded = 'true' or $isDeleted = 'true'">
						<xsl:copy-of select="$table-preamble"/>
						<fo:block>
							<xsl:call-template name="setTrackChangesStyles">
								<xsl:with-param name="isAdded" select="$isAdded"/>
								<xsl:with-param name="isDeleted" select="$isDeleted"/>
							</xsl:call-template>
							<xsl:copy-of select="$table"/>
						</fo:block>
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select="$table-preamble"/>
						<xsl:copy-of select="$table"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>


	<xsl:template name="setBordersTableArray">
		<xsl:if test="$namespace = 'iec' or $namespace = 'iso'">
			<xsl:if test="starts-with(@id, 'array_') or starts-with(ancestor::mn:table[1]/@id, 'array_')">
				<!-- array - table without borders -->
				<xsl:attribute name="border">none</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	
	<!-- table/name-->
	<xsl:template match="*[local-name()='table']/mn:name">
		<xsl:param name="continued"/>
		<xsl:param name="cols-count"/>
		<xsl:if test="normalize-space() != ''">
		
			<xsl:choose>
				<xsl:when test="$namespace = 'ieee'">
					<fo:inline role="SKIP">
				
						<xsl:if test="$current_template = 'whitepaper' or $current_template = 'icap-whitepaper' or $current_template = 'industry-connection-report'">
							<xsl:attribute name="font-size">11pt</xsl:attribute>
							<xsl:attribute name="font-family">Arial Black</xsl:attribute>
						</xsl:if>
						
						<xsl:apply-templates />
					</fo:inline>
				</xsl:when>
				
				<xsl:when test="$namespace = 'bipm'">
					<fo:list-block xsl:use-attribute-sets="table-name-style">
					
						<xsl:if test="not(*[local-name()='tab'])"> <!-- table without number -->
							<xsl:attribute name="margin-top">0pt</xsl:attribute>
						</xsl:if>
						<xsl:if test="not(../preceding-sibling::*) and ancestor::node()[@orientation]">
							<xsl:attribute name="margin-top">0pt</xsl:attribute>
						</xsl:if>
						
						<xsl:if test="$namespace = 'jis'">
							<xsl:if test="not($vertical_layout = 'true')">
								<xsl:attribute name="font-family">IPAexGothic</xsl:attribute>
							</xsl:if>
						</xsl:if>
					
						<xsl:attribute name="provisional-distance-between-starts">25mm</xsl:attribute>
						
						<fo:list-item>
							<fo:list-item-label end-indent="label-end()">
								<fo:block>
									<xsl:apply-templates select="./mn:tab[1]/preceding-sibling::node()"/>
								</fo:block>
							</fo:list-item-label>
							<fo:list-item-body start-indent="body-start()">
								<fo:block>
									<xsl:choose>
										<xsl:when test="./mn:tab">
											<xsl:apply-templates select="./mn:tab[1]/following-sibling::node()"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:apply-templates />
										</xsl:otherwise>
									</xsl:choose>
								</fo:block>
							</fo:list-item-body>
						</fo:list-item>
					</fo:list-block>
					<!-- bipm -->
				</xsl:when>
				
				<xsl:otherwise>
				
					<fo:block xsl:use-attribute-sets="table-name-style">

						<xsl:call-template name="refine_table-name-style">
							<xsl:with-param name="continued" select="$continued"/>
						</xsl:call-template>
					
						<xsl:choose>
							<xsl:when test="$continued = 'true'"> 
								<xsl:if test="$namespace = 'jcgm'"> <!-- $namespace = 'iso' or  -->
									<xsl:apply-templates />
								</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates />
							</xsl:otherwise>
						</xsl:choose>
						
						<xsl:if test="$namespace = 'bsi'">
							<xsl:if test="not(ancestor::mn:table/@class = 'corrigenda') and 
							not(contains(ancestor::mn:clause[1]/mn:title, 'Amendments/corrigenda'))">
								<xsl:if test="$continued = 'true'">
									<fo:inline font-weight="bold" font-style="normal" role="SKIP">
										<xsl:if test="$document_type = 'PAS'">
											<xsl:attribute name="color"><xsl:value-of select="$color_secondary_shade_1_PAS"/></xsl:attribute>
										</xsl:if>
										<fo:retrieve-table-marker retrieve-class-name="table_number"/>
									</fo:inline>
									<fo:inline font-style="italic" role="SKIP">
										<xsl:text> </xsl:text>
										<fo:retrieve-table-marker retrieve-class-name="table_continued"/>
									</fo:inline>
								</xsl:if>
							</xsl:if>
						</xsl:if>
						
						<xsl:if test="$namespace = 'iec' or $namespace = 'iso'">
							<xsl:if test="$continued = 'true'">
								<fo:inline font-weight="bold" font-style="normal" role="SKIP">
									<fo:retrieve-table-marker retrieve-class-name="table_number"/>
								</fo:inline>
								<fo:inline font-weight="normal" font-style="italic" role="SKIP">
									<xsl:text> </xsl:text>
									<fo:retrieve-table-marker retrieve-class-name="table_continued"/>
								</fo:inline>
							</xsl:if>
						</xsl:if>
						
					</fo:block>
					
					<!-- <xsl:if test="$namespace = 'bsi' or $namespace = 'iec' or $namespace = 'iso'"> -->
					<xsl:if test="$continued = 'true'">
					
						<!-- to prevent the error 'THead element may contain only TR elements' -->
						
						<xsl:choose>
							<xsl:when test="string(number($cols-count)) != 'NaN'">
								<fo:table width="100%" table-layout="fixed" role="SKIP">
									<fo:table-body role="SKIP">
										<fo:table-row>
											<fo:table-cell role="TH" number-columns-spanned="{$cols-count}">
												<fo:block text-align="right" role="SKIP">
													<xsl:apply-templates select="../mn:note[@type = 'units']/node()" />
												</fo:block>
											</fo:table-cell>
										</fo:table-row>
									</fo:table-body>
								</fo:table>
							</xsl:when>
							<xsl:otherwise>
								<fo:block text-align="right">
									<xsl:apply-templates select="../mn:note[@type = 'units']/node()" />
								</fo:block>
							</xsl:otherwise>
						</xsl:choose>
						
					
						
					</xsl:if>
					<!-- </xsl:if> -->
					
				</xsl:otherwise>
			</xsl:choose>
			
		</xsl:if>
	</xsl:template> <!-- table/name -->

	<!-- workaround solution for https://github.com/metanorma/metanorma-iso/issues/1151#issuecomment-2033087938 -->
	<xsl:template match="*[local-name()='table']/mn:note[@type = 'units']/mn:p/text()" priority="4">
		<xsl:choose>
			<xsl:when test="preceding-sibling::mn:br">
				<!-- remove CR or LF at start -->
				<xsl:value-of select="java:replaceAll(java:java.lang.String.new(.),'^(&#x0d;&#x0a;|&#x0d;|&#x0a;)', '')"/>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- SOURCE: ... -->
	<xsl:template match="*[local-name()='table']/mn:source" priority="2">
		<xsl:call-template name="termsource"/>
	</xsl:template>
	
	<xsl:template name="calculate-columns-numbers">
		<xsl:param name="table-row" />
		<xsl:variable name="columns-count" select="count($table-row/*)"/>
		<xsl:variable name="sum-colspans"  select="sum($table-row/*/@colspan)"/>
		<xsl:variable name="columns-with-colspan" select="count($table-row/*[@colspan])"/>
		<xsl:value-of select="$columns-count + $sum-colspans - $columns-with-colspan"/>
	</xsl:template>


	<xsl:template name="calculate-column-widths">
		<xsl:param name="table"/>
		<xsl:param name="cols-count"/>
		<xsl:choose>
			<xsl:when test="$isApplyAutolayoutAlgorithm = 'true'">
				<xsl:call-template name="get-calculated-column-widths-autolayout-algorithm"/>
			</xsl:when>
			<xsl:when test="$isApplyAutolayoutAlgorithm = 'skip'"></xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="calculate-column-widths-proportional">
					<xsl:with-param name="cols-count" select="$cols-count"/>
					<xsl:with-param name="table" select="$table"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- ================================================== -->
	<!-- Calculate column's width based on text string max widths -->
	<!-- ================================================== -->
	<xsl:template name="calculate-column-widths-proportional">
		<xsl:param name="table"/>
		<xsl:param name="cols-count"/>
		<xsl:param name="curr-col" select="1"/>
		<xsl:param name="width" select="0"/>
		
		<!-- table=<xsl:copy-of select="$table"/> -->
		
		<xsl:if test="$curr-col &lt;= $cols-count">
			<xsl:variable name="widths">
				<xsl:choose>
					<xsl:when test="not($table)"><!-- this branch is not using in production, for debug only -->
						<xsl:for-each select="*[local-name()='thead']//*[local-name()='tr']">
							<xsl:variable name="words">
								<xsl:call-template name="tokenize">
									<xsl:with-param name="text" select="translate(*[local-name()='th'][$curr-col],'- —:', '    ')"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:variable name="max_length">
								<xsl:call-template name="max_length">
									<xsl:with-param name="words" select="xalan:nodeset($words)"/>
								</xsl:call-template>
							</xsl:variable>
							<width>
								<xsl:value-of select="$max_length"/>
							</width>
						</xsl:for-each>
						<xsl:for-each select="*[local-name()='tbody']//*[local-name()='tr']">
							<xsl:variable name="words">
								<xsl:call-template name="tokenize">
									<xsl:with-param name="text" select="translate(*[local-name()='td'][$curr-col],'- —:', '    ')"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:variable name="max_length">
								<xsl:call-template name="max_length">
									<xsl:with-param name="words" select="xalan:nodeset($words)"/>
								</xsl:call-template>
							</xsl:variable>
							<width>
								<xsl:value-of select="$max_length"/>
							</width>
							
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<!-- <curr_col><xsl:value-of select="$curr-col"/></curr_col> -->
						
						<!-- <table><xsl:copy-of select="$table"/></table>
						 -->
						<xsl:for-each select="xalan:nodeset($table)/*/*[local-name()='tr']">
							<xsl:variable name="td_text">
								<xsl:apply-templates select="*[local-name()='td'][$curr-col]" mode="td_text"/>
							</xsl:variable>
							<!-- <td_text><xsl:value-of select="$td_text"/></td_text> -->
							<xsl:variable name="words">
								<xsl:variable name="string_with_added_zerospaces">
									<xsl:call-template name="add-zero-spaces-java">
										<xsl:with-param name="text" select="$td_text"/>
									</xsl:call-template>
								</xsl:variable>
								<!-- <xsl:message>string_with_added_zerospaces=<xsl:value-of select="$string_with_added_zerospaces"/></xsl:message> -->
								<xsl:call-template name="tokenize">
									<!-- <xsl:with-param name="text" select="translate(td[$curr-col],'- —:', '    ')"/> -->
									<!-- 2009 thinspace -->
									<!-- <xsl:with-param name="text" select="translate(normalize-space($td_text),'- —:', '    ')"/> -->
									<xsl:with-param name="text" select="normalize-space(translate($string_with_added_zerospaces, '&#x200B;&#xAD;', '  '))"/> <!-- replace zero-width-space and soft-hyphen to space -->
								</xsl:call-template>
							</xsl:variable>
							<!-- words=<xsl:copy-of select="$words"/> -->
							<xsl:variable name="max_length">
								<xsl:call-template name="max_length">
									<xsl:with-param name="words" select="xalan:nodeset($words)"/>
								</xsl:call-template>
							</xsl:variable>
							<!-- <xsl:message>max_length=<xsl:value-of select="$max_length"/></xsl:message> -->
							<width>
								<xsl:variable name="divider">
									<xsl:choose>
										<xsl:when test="*[local-name()='td'][$curr-col]/@divide">
											<xsl:value-of select="*[local-name()='td'][$curr-col]/@divide"/>
										</xsl:when>
										<xsl:otherwise>1</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:value-of select="$max_length div $divider"/>
							</width>
							
						</xsl:for-each>
					
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<!-- widths=<xsl:copy-of select="$widths"/> -->
			
			<column>
				<xsl:for-each select="xalan:nodeset($widths)//width">
					<xsl:sort select="." data-type="number" order="descending"/>
					<xsl:if test="position()=1">
							<xsl:value-of select="."/>
					</xsl:if>
				</xsl:for-each>
			</column>
			<xsl:call-template name="calculate-column-widths-proportional">
				<xsl:with-param name="cols-count" select="$cols-count"/>
				<xsl:with-param name="curr-col" select="$curr-col +1"/>
				<xsl:with-param name="table" select="$table"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template> <!-- calculate-column-widths-proportional -->
	
	<!-- ================================= -->
	<!-- mode="td_text" -->
	<!-- ================================= -->
	<!-- replace each each char to 'X', just to process the tag 'keep-together_within-line' as whole word in longest word calculation -->
	<xsl:template match="*[@keep-together.within-line or local-name() = 'keep-together_within-line']/text()" priority="2" mode="td_text">
		<!-- <xsl:message>DEBUG t1=<xsl:value-of select="."/></xsl:message>
		<xsl:message>DEBUG t2=<xsl:value-of select="java:replaceAll(java:java.lang.String.new(.),'.','X')"/></xsl:message> -->
		<xsl:value-of select="java:replaceAll(java:java.lang.String.new(.),'.','X')"/>
		
		<!-- if all capitals english letters or digits -->
		<xsl:if test="normalize-space(translate(., concat($upper,'0123456789'), '')) = ''">
			<xsl:call-template name="repeat">
				<xsl:with-param name="char" select="'X'"/>
				<xsl:with-param name="count" select="string-length(normalize-space(.)) * 0.5"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="text()" mode="td_text">
		<xsl:value-of select="translate(., $zero_width_space, ' ')"/><xsl:text> </xsl:text>
	</xsl:template>
	
	<xsl:template match="mn:termsource" mode="td_text">
		<xsl:value-of select="*[local-name()='origin']/@citeas"/>
	</xsl:template>
	
	<xsl:template match="mn:link" mode="td_text">
		<xsl:value-of select="@target"/>
	</xsl:template>

	<xsl:template match="*[local-name()='math']" mode="td_text" name="math_length">
		<xsl:if test="$isGenerateTableIF = 'false'">
			<xsl:variable name="mathml_">
				<xsl:for-each select="*">
					<xsl:if test="local-name() != 'unit' and local-name() != 'prefix' and local-name() != 'dimension' and local-name() != 'quantity'">
						<xsl:copy-of select="."/>
					</xsl:if>
				</xsl:for-each>
			</xsl:variable>
			<xsl:variable name="mathml" select="xalan:nodeset($mathml_)"/>

			<xsl:variable name="math_text">
				<xsl:value-of select="normalize-space($mathml)"/>
				<xsl:for-each select="$mathml//@open"><xsl:value-of select="."/></xsl:for-each>
				<xsl:for-each select="$mathml//@close"><xsl:value-of select="."/></xsl:for-each>
			</xsl:variable>
			<xsl:value-of select="translate($math_text, ' ', '#')"/><!-- mathml images as one 'word' without spaces -->
		</xsl:if>
	</xsl:template>
	<!-- ================================= -->
	<!-- END mode="td_text" -->
	<!-- ================================= -->
	<!-- ================================================== -->
	<!-- END Calculate column's width based on text string max widths -->
	<!-- ================================================== -->
	
	<!-- ================================================== -->
	<!-- Calculate column's width based on HTML4 algorithm -->
	<!-- (https://www.w3.org/TR/REC-html40/appendix/notes.html#h-B.5.2) -->
	<!-- ================================================== -->
	
	<!-- INPUT: table with columns widths, generated by table_if.xsl  -->
	<xsl:template name="calculate-column-widths-autolayout-algorithm">
		<xsl:param name="parent_table_page-width"/> <!-- for nested tables, in re-calculate step -->
		
		<!-- via intermediate format -->

		<!-- The algorithm uses two passes through the table data and scales linearly with the size of the table -->
	 
		<!-- In the first pass, line wrapping is disabled, and the user agent keeps track of the minimum and maximum width of each cell. -->
	 
		<!-- Since line wrap has been disabled, paragraphs are treated as long lines unless broken by BR elements. -->
		
		<xsl:variable name="page_width">
			<xsl:choose>
				<xsl:when test="$parent_table_page-width != ''">
					<xsl:value-of select="$parent_table_page-width"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@page-width"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:if test="$table_if_debug = 'true'">
			<page_width><xsl:value-of select="$page_width"/></page_width>
		</xsl:if>
		
		<!-- There are three cases: -->
		<xsl:choose>
			<!-- 1. The minimum table width is equal to or wider than the available space -->
			<xsl:when test="@width_min &gt;= $page_width and 1 = 2"> <!-- this condition isn't working see case 3 below -->
				<!-- call old algorithm -->
				<case1/>
				<!-- <xsl:variable name="cols-count" select="count(xalan:nodeset($table)/*/tr[1]/td)"/>
				<xsl:call-template name="calculate-column-widths-proportional">
					<xsl:with-param name="cols-count" select="$cols-count"/>
					<xsl:with-param name="table" select="$table"/>
				</xsl:call-template> -->
			</xsl:when>
			<!-- 2. The maximum table width fits within the available space. In this case, set the columns to their maximum widths. -->
			<xsl:when test="@width_max &lt;= $page_width">
				<case2/>
				<autolayout/>
				<xsl:for-each select="column/@width_max">
					<column divider="100"><xsl:value-of select="."/></column>
				</xsl:for-each>
			</xsl:when>
			<!-- 3. The maximum width of the table is greater than the available space, but the minimum table width is smaller. 
			In this case, find the difference between the available space and the minimum table width, lets call it W. 
			Lets also call D the difference between maximum and minimum width of the table. 
			For each column, let d be the difference between maximum and minimum width of that column. 
			Now set the column's width to the minimum width plus d times W over D. 
			This makes columns with large differences between minimum and maximum widths wider than columns with smaller differences. -->
			<xsl:when test="(@width_max &gt; $page_width and @width_min &lt; $page_width) or (@width_min &gt;= $page_width)">
				<!-- difference between the available space and the minimum table width -->
				<_width_min><xsl:value-of select="@width_min"/></_width_min>
				<xsl:variable name="W" select="$page_width - @width_min"/>
				<W><xsl:value-of select="$W"/></W>
				<!-- difference between maximum and minimum width of the table -->
				<xsl:variable name="D" select="@width_max - @width_min"/>
				<D><xsl:value-of select="$D"/></D>
				<case3/>
				<autolayout/>
				<xsl:if test="@width_min &gt;= $page_width">
					<split_keep-within-line>true</split_keep-within-line>
				</xsl:if>
				<xsl:for-each select="column">
					<!-- difference between maximum and minimum width of that column.  -->
					<xsl:variable name="d" select="@width_max - @width_min"/>
					<d><xsl:value-of select="$d"/></d>
					<width_min><xsl:value-of select="@width_min"/></width_min>
					<e><xsl:value-of select="$d * $W div $D"/></e>
					<!-- set the column's width to the minimum width plus d times W over D.  -->
					<xsl:variable name="column_width_" select="round(@width_min + $d * $W div $D)"/> <!--  * 10 -->
					<xsl:variable name="column_width" select="$column_width_*($column_width_ >= 0) - $column_width_*($column_width_ &lt; 0)"/> <!-- absolute value -->
					<column divider="100">
						<xsl:value-of select="$column_width"/>
					</column>
				</xsl:for-each>
				
			</xsl:when>
			<xsl:otherwise><unknown_case/></xsl:otherwise>
		</xsl:choose>
		
	</xsl:template> <!-- calculate-column-widths-autolayout-algorithm -->
	
	
	<xsl:template name="get-calculated-column-widths-autolayout-algorithm">
		
		<!-- if nested 'dl' or 'table' -->
		<xsl:variable name="parent_table_id" select="normalize-space(ancestor::*[local-name() = 'table' or local-name() = 'dl'][1]/@id)"/>
		<parent_table_id><xsl:value-of select="$parent_table_id"/></parent_table_id>
			
		<parent_element><xsl:value-of select="local-name(..)"/></parent_element>
		
		<ancestor_tree>
			<xsl:for-each select="ancestor::*">
				<ancestor><xsl:value-of select="local-name()"/></ancestor>
			</xsl:for-each>
		</ancestor_tree>
		
		<xsl:variable name="parent_table_page-width_">
			<xsl:if test="$parent_table_id != ''">
				<!-- determine column number in the parent table -->
				<xsl:variable name="parent_table_column_number">
					<xsl:choose>
						<!-- <xsl:when test="parent::mn:dd">2</xsl:when> -->
						<xsl:when test="(ancestor::*[local-name() = 'dd' or local-name() = 'table' or local-name() = 'dl'])[last()][local-name() = 'dd' or local-name() = 'dl']">2</xsl:when>
						<xsl:otherwise> <!-- parent is table -->
							<xsl:value-of select="count(ancestor::*[local-name() = 'td'][1]/preceding-sibling::*[local-name() = 'td']) + 1"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<!-- find table by id in the file 'table_widths' and get all Nth `<column>...</column> -->
				
				<xsl:variable name="parent_table_column_" select="$table_widths_from_if_calculated//table[@id = $parent_table_id]/column[number($parent_table_column_number)]"/>
				<xsl:variable name="parent_table_column" select="xalan:nodeset($parent_table_column_)"/>
				<!-- <xsl:variable name="divider">
					<xsl:value-of select="$parent_table_column/@divider"/>
					<xsl:if test="not($parent_table_column/@divider)">1</xsl:if>
				</xsl:variable> -->
				<xsl:value-of select="$parent_table_column/text()"/> <!--  * 10 -->
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="parent_table_page-width" select="normalize-space($parent_table_page-width_)"/>
		
		<parent_table_page-width><xsl:value-of select="$parent_table_page-width"/></parent_table_page-width>
		
		<!-- get current table id -->
		<xsl:variable name="table_id" select="@id"/>
		
		<xsl:choose>
			<xsl:when test="$parent_table_id = '' or $parent_table_page-width = ''">
				<!-- find table by id in the file 'table_widths' and get all `<column>...</column> -->
				<xsl:copy-of select="$table_widths_from_if_calculated//table[@id = $table_id]/node()"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- recalculate columns width based on parent table width -->
				<xsl:for-each select="$table_widths_from_if//table[@id = $table_id]">
					<xsl:call-template name="calculate-column-widths-autolayout-algorithm">
						<xsl:with-param name="parent_table_page-width" select="$parent_table_page-width"/> <!-- padding-left = 2mm  = 50000-->
					</xsl:call-template>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template> <!-- get-calculated-column-widths-autolayout-algorithm -->
	
	<!-- ================================================== -->
	<!-- END: Calculate column's width based on HTML4 algorithm -->
	<!-- ================================================== -->
	
	<xsl:template match="mn:thead">
		<xsl:param name="cols-count"/>
		<fo:table-header>
			<xsl:if test="$namespace = 'iec' or $namespace = 'ieee' or $namespace = 'iso' or $namespace = 'jcgm'">
				<xsl:call-template name="table-header-title">
					<xsl:with-param name="cols-count" select="$cols-count"/>
				</xsl:call-template>				
			</xsl:if>
			<xsl:if test="$namespace = 'bsi'">
				<xsl:if test="ancestor::mn:table/mn:name">
					<xsl:call-template name="table-header-title">
						<xsl:with-param name="cols-count" select="$cols-count"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:if>
			<xsl:apply-templates />
		</fo:table-header>
	</xsl:template> <!-- thead -->
	
	<!-- template is using for iec, iso, jcgm, bsi only -->
	<xsl:template name="table-header-title">
		<xsl:param name="cols-count"/>
		<!-- row for title -->
		<fo:table-row role="SKIP">
			<fo:table-cell number-columns-spanned="{$cols-count}" border-left="1.5pt solid white" border-right="1.5pt solid white" border-top="1.5pt solid white" border-bottom="1.5pt solid black" role="SKIP">
			
				<xsl:call-template name="refine_table-header-title-style"/>
			
				<xsl:choose>
					<xsl:when test="$namespace = 'ieee'">
					
						<xsl:if test="$current_template = 'whitepaper' or $current_template = 'icap-whitepaper' or $current_template = 'industry-connection-report'">
							<xsl:attribute name="border-bottom">0.5 solid black</xsl:attribute>
						</xsl:if>
					
						<fo:block xsl:use-attribute-sets="table-name-style" role="SKIP">
						
							<xsl:if test="$namespace = 'jis'">
								<xsl:if test="not($vertical_layout = 'true')">
									<xsl:attribute name="font-family">IPAexGothic</xsl:attribute>
								</xsl:if>
							</xsl:if>
							
							<xsl:apply-templates select="ancestor::mn:table/mn:name">
								<xsl:with-param name="continued">true</xsl:with-param>
							</xsl:apply-templates>
							
							<fo:inline font-weight="normal" font-style="italic" role="SKIP">
								<xsl:text>&#xA0;</xsl:text>
								<fo:retrieve-table-marker retrieve-class-name="table_continued"/>
							</fo:inline>
						</fo:block>
					</xsl:when>
					<xsl:otherwise>
				
						<xsl:apply-templates select="ancestor::mn:table/mn:name">
							<xsl:with-param name="continued">true</xsl:with-param>
							<xsl:with-param name="cols-count" select="$cols-count"/>
						</xsl:apply-templates>
						
						<xsl:if test="not(ancestor::mn:table/mn:name)"> <!-- to prevent empty fo:table-cell in case of missing table's name -->
							<fo:block role="SKIP"></fo:block>
						</xsl:if>
						
						<xsl:if test="$namespace = 'iso'">
							<xsl:for-each select="ancestor::*[local-name()='table'][1]">
								<xsl:call-template name="table_name_fn_display"/>
							</xsl:for-each>	
						</xsl:if>
						
						<xsl:if test="$namespace = 'jcgm'">
							<xsl:for-each select="ancestor::*[local-name()='table'][1]">
								<xsl:call-template name="table_name_fn_display"/>
							</xsl:for-each>

							<fo:block text-align="right" font-style="italic" role="SKIP">
								<xsl:text>&#xA0;</xsl:text>
								<fo:retrieve-table-marker retrieve-class-name="table_continued"/>
							</fo:block>
						</xsl:if>
				
					</xsl:otherwise>
				</xsl:choose>
				
			</fo:table-cell>
		</fo:table-row>
	</xsl:template> <!-- table-header-title -->
	
	<xsl:template name="refine_table-header-title-style">
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="border-bottom">none</xsl:attribute>
			<xsl:attribute name="border-left">none</xsl:attribute>
			<xsl:attribute name="border-right">none</xsl:attribute>
			<xsl:attribute name="border-top">none</xsl:attribute>
		</xsl:if>
		
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="border-left">1pt solid white</xsl:attribute>
			<xsl:attribute name="border-right">1pt solid white</xsl:attribute>
			<xsl:attribute name="border-top">1pt solid white</xsl:attribute>
			<xsl:attribute name="border-bottom">none</xsl:attribute>
		</xsl:if>
		
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="border-left">1pt solid white</xsl:attribute>
			<xsl:attribute name="border-right">1pt solid white</xsl:attribute>
			<xsl:attribute name="border-top">1pt solid white</xsl:attribute>
			<!-- <xsl:attribute name="border-bottom">0.5pt solid white</xsl:attribute> -->
			<xsl:attribute name="border-bottom">none</xsl:attribute>
		</xsl:if>
	</xsl:template> <!-- refine_table-header-title-style -->
	
	<xsl:template match="*[local-name()='thead']" mode="process_tbody">		
		<fo:table-body>
			<xsl:apply-templates />
		</fo:table-body>
	</xsl:template>
	

	<xsl:template match="mn:tfoot">
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template name="insertTableFooter">
		<xsl:param name="cols-count" />
		<xsl:if test="../mn:tfoot">
			<fo:table-footer>			
				<xsl:apply-templates select="../mn:tfoot" />
			</fo:table-footer>
		</xsl:if>
	</xsl:template>
	
	
	<xsl:template name="insertTableFooterInSeparateTable">
		<xsl:param name="table_attributes"/>
		<xsl:param name="colwidths"/>
		<xsl:param name="colgroup"/>
		
		<xsl:variable name="isNoteOrFnExist" select="../mn:note[not(@type = 'units')] or ../mn:example or ../mn:dl or ..//mn:fn[local-name(..) != 'name'] or ../mn:source or ../mn:p"/>
		
		<xsl:variable name="isNoteOrFnExistShowAfterTable">
			<xsl:if test="$namespace = 'bsi'">
				 <xsl:value-of select="../mn:note[not(@type = 'units')] or ../mn:source or ../mn:dl or ..//mn:fn"/>
			</xsl:if>
		</xsl:variable>
		
		<xsl:if test="$isNoteOrFnExist = 'true' or normalize-space($isNoteOrFnExistShowAfterTable) = 'true'">
		
			<xsl:variable name="cols-count">
				<xsl:choose>
					<xsl:when test="xalan:nodeset($colgroup)//mn:col">
						<xsl:value-of select="count(xalan:nodeset($colgroup)//mn:col)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="count(xalan:nodeset($colwidths)//column)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<xsl:variable name="table_fn_block">
				<xsl:call-template name="table_fn_display" />
			</xsl:variable>
			
			<xsl:variable name="tableWithNotesAndFootnotes">
			
				<fo:table keep-with-previous="always" role="SKIP">
					<xsl:for-each select="xalan:nodeset($table_attributes)/table_attributes/@*">
						<xsl:variable name="name" select="local-name()"/>
						<xsl:choose>
							<xsl:when test="$name = 'border-top'">
								<xsl:attribute name="{$name}">0pt solid black</xsl:attribute>
							</xsl:when>
							<xsl:when test="$name = 'border'">
								<xsl:attribute name="{$name}"><xsl:value-of select="."/></xsl:attribute>
								<xsl:attribute name="border-top">0pt solid black</xsl:attribute>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="{$name}"><xsl:value-of select="."/></xsl:attribute>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
					
					<xsl:if test="$namespace = 'itu'">
						<xsl:variable name="doctype" select="ancestor::mn:metanorma/mn:bibdata/mn:ext/mn:doctype[not(@language) or @language = '']"/>
						<xsl:if test="$doctype = 'service-publication'">
							<xsl:attribute name="border">none</xsl:attribute>
							<xsl:attribute name="font-family">Arial</xsl:attribute>
							<xsl:attribute name="font-size">8pt</xsl:attribute>
						</xsl:if>
					</xsl:if>
					
					<xsl:choose>
						<xsl:when test="xalan:nodeset($colgroup)//mn:col">
							<xsl:for-each select="xalan:nodeset($colgroup)//mn:col">
								<fo:table-column column-width="{@width}"/>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<!-- $colwidths=<xsl:copy-of select="$colwidths"/> -->
							<xsl:call-template name="insertTableColumnWidth">
								<xsl:with-param name="colwidths" select="$colwidths"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
					
					<fo:table-body role="SKIP">
						<fo:table-row role="SKIP">
							<fo:table-cell xsl:use-attribute-sets="table-footer-cell-style" number-columns-spanned="{$cols-count}" role="SKIP">
								
								<xsl:call-template name="refine_table-footer-cell-style"/>
								
								<xsl:call-template name="setBordersTableArray"/>
								
								<!-- fn will be processed inside 'note' processing -->
								<xsl:if test="$namespace = 'iec'">
									<xsl:if test="../mn:note[not(@type = 'units')]">
										<fo:block margin-bottom="6pt" role="SKIP">&#xA0;</fo:block>
									</xsl:if>
								</xsl:if>
								
								<xsl:if test="$namespace = 'bipm'">
									<xsl:if test="count(ancestor::mn:table//mn:note[not(@type = 'units')]) &gt; 1">
										<fo:block font-weight="bold" role="SKIP">
											<xsl:variable name="curr_lang" select="ancestor::mn:metanorma/mn:bibdata/mn:language"/>
											<xsl:choose>
												<xsl:when test="$curr_lang = 'fr'">Remarques</xsl:when>
												<xsl:otherwise>Notes</xsl:otherwise>
											</xsl:choose>
										</fo:block>
									</xsl:if>
								</xsl:if>
								
								<xsl:if test="$namespace = 'itu'">
									<xsl:variable name="doctype" select="ancestor::mn:metanorma/mn:bibdata/mn:ext/mn:doctype[not(@language) or @language = '']"/>
									<xsl:if test="$doctype = 'service-publication'">
										<fo:block margin-top="7pt" margin-bottom="2pt" role="SKIP"><fo:inline>____________</fo:inline></fo:block>
									</xsl:if>
								</xsl:if>
								
								<xsl:if test="$namespace = 'bsi'">
									<!-- for BSI (not PAS) display Notes before footnotes -->
									<xsl:if test="$document_type != 'PAS'">
										<xsl:apply-templates select="../mn:dl" />
										<xsl:apply-templates select="../mn:note[not(@type = 'units')]" />
										<xsl:apply-templates select="../mn:source" />
									</xsl:if>
								</xsl:if>
								
								<xsl:choose>
									<xsl:when test="$namespace = 'gb' or $namespace = 'bsi'"><!-- except gb and bsi  --></xsl:when>
									<xsl:when test="$namespace = 'jis'">
										<xsl:apply-templates select="../*[self::mn:p or self::mn:dl or (self::mn:note and not(@type = 'units')) or self::mn:example or self::mn:source]" />
									</xsl:when>
									<!-- <xsl:when test="$namespace = 'plateau'">
										- https://github.com/metanorma/metanorma-plateau/issues/171 : the order is: definition list, text paragraphs, EXAMPLEs, NOTEs, footnotes, then source at the end -
										<xsl:apply-templates select="../mn:dl" />
										<xsl:apply-templates select="../mn:p" />
										<xsl:apply-templates select="../mn:example" />
										<xsl:apply-templates select="../mn:note[not(@type = 'units')]" />
										- <xsl:copy-of select="$table_fn_block"/> -
										<xsl:apply-templates select="../mn:source" />
										- renders in tfoot -
									</xsl:when> -->
									<xsl:otherwise>
										<xsl:apply-templates select="../mn:p" />
										<xsl:apply-templates select="../mn:dl" />
										<xsl:apply-templates select="../mn:note[not(@type = 'units')]" />
										<xsl:apply-templates select="../mn:example" />
										<xsl:apply-templates select="../mn:source" />
									</xsl:otherwise>
								</xsl:choose>
								
								
								<xsl:variable name="isDisplayRowSeparator">
									<xsl:if test="$namespace = 'iec'">true</xsl:if>
									<xsl:if test="$namespace = 'bsi'">
										<xsl:if test="$document_type != 'PAS'">true</xsl:if>
									</xsl:if>
								</xsl:variable>
								
								<!-- horizontal row separator -->
								<xsl:if test="normalize-space($isDisplayRowSeparator) = 'true'">
									<xsl:if test="(../mn:note[not(@type = 'units')] or ../mn:example) and normalize-space($table_fn_block) != ''">
										<fo:block-container border-top="0.5pt solid black" padding-left="1mm" padding-right="1mm">
											<xsl:if test="$namespace = 'bsi'">
												<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
											</xsl:if>
											<xsl:call-template name="setBordersTableArray"/>
											<fo:block font-size="1pt">&#xA0;</fo:block>
										</fo:block-container>
									</xsl:if>
								</xsl:if>
								
								
								<!-- fn processing -->
								<xsl:choose>
									<xsl:when test="$namespace = 'ieee'"><fo:block></fo:block><!-- display fn after table --></xsl:when>
									<xsl:when test="$namespace = 'plateau'"><fo:block></fo:block><!-- display fn before 'source', see above --></xsl:when>
									<xsl:otherwise>
										<!-- <xsl:call-template name="table_fn_display" /> -->
										<xsl:copy-of select="$table_fn_block"/>
									</xsl:otherwise>
								</xsl:choose>
								
								<xsl:if test="$namespace = 'bsi'">
									<!-- for PAS display Notes after footnotes -->
									<xsl:if test="$document_type = 'PAS'">
										<xsl:apply-templates select="../mn:dl" />
										<xsl:apply-templates select="../mn:note[not(@type = 'units')]" />
										<xsl:apply-templates select="../mn:source" />
									</xsl:if>
								</xsl:if>
								
							</fo:table-cell>
						</fo:table-row>
					</fo:table-body>
					
				</fo:table>
			</xsl:variable>
			
			<xsl:if test="normalize-space($tableWithNotesAndFootnotes) != ''">
				<xsl:copy-of select="$tableWithNotesAndFootnotes"/>
			</xsl:if>
			
			<xsl:if test="$namespace = 'ieee'">
				<!-- <xsl:call-template name="table_fn_display" /> -->
				<xsl:copy-of select="$table_fn_block"/>
			</xsl:if>
			
		</xsl:if>
	</xsl:template> <!-- insertTableFooterInSeparateTable -->
	
	
	<xsl:template match="mn:tbody">
		
		<xsl:variable name="cols-count">
			<xsl:choose>
				<xsl:when test="../mn:thead">					
					<xsl:call-template name="calculate-columns-numbers">
						<xsl:with-param name="table-row" select="../mn:thead/mn:tr[1]"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>					
					<xsl:call-template name="calculate-columns-numbers">
						<xsl:with-param name="table-row" select="./mn:tr[1]"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:if test="$namespace = 'bsi' or $namespace = 'iec' or $namespace = 'ieee' or $namespace = 'iso' or $namespace = 'jcgm'">
			<!-- if there isn't 'thead' and there is a table's title -->
			<xsl:if test="not(ancestor::mn:table/mn:thead) and ancestor::mn:table/mn:name">
				<fo:table-header>
					<xsl:if test="$namespace = 'jcgm'">
						<xsl:attribute name="role">Caption</xsl:attribute>
					</xsl:if>
					<xsl:call-template name="table-header-title">
						<xsl:with-param name="cols-count" select="$cols-count"/>
					</xsl:call-template>
				</fo:table-header>
			</xsl:if>
		</xsl:if>
		
		<xsl:apply-templates select="../mn:thead">
			<xsl:with-param name="cols-count" select="$cols-count"/>
		</xsl:apply-templates>
		
		<xsl:call-template name="insertTableFooter">
			<xsl:with-param name="cols-count" select="$cols-count"/>
		</xsl:call-template>
		
		<fo:table-body>
			<xsl:if test="$namespace = 'bsi' or $namespace = 'iec' or $namespace = 'ieee' or $namespace = 'iso' or $namespace = 'jcgm'">				
				<xsl:variable name="title_continued_">
					<xsl:call-template name="getLocalizedString">
						<xsl:with-param name="key">continued</xsl:with-param>
					</xsl:call-template>
				</xsl:variable>
        
				<xsl:variable name="title_continued_in_parenthesis" select="concat('(',$title_continued_,')')"/>
				<xsl:variable name="title_continued">
					<xsl:if test="$namespace = 'iec' or $namespace = 'ieee' or $namespace = 'iso' or $namespace = 'jcgm'"><xsl:value-of select="$title_continued_in_parenthesis"/></xsl:if>
					<xsl:if test="$namespace = 'bsi'">
						<xsl:choose>
							<xsl:when test="$document_type = 'PAS'">— <xsl:value-of select="$title_continued_"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="$title_continued_in_parenthesis"/></xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:variable>
				
				<xsl:variable name="title_start" select="ancestor::mn:table[1]/mn:name/node()[1][self::text()]"/>
				<xsl:variable name="table_number" select="substring-before($title_start, '—')"/>
				
				<fo:table-row height="0" keep-with-next.within-page="always" role="SKIP">
					<fo:table-cell role="SKIP">
					
						<xsl:if test="$namespace = 'bsi' or $namespace = 'iec' or $namespace = 'iso'">
							<fo:marker marker-class-name="table_number" />
							<fo:marker marker-class-name="table_continued" />
						</xsl:if>
						
						<xsl:if test="$namespace = 'ieee' or $namespace = 'jcgm'">
							<fo:marker marker-class-name="table_continued" />
						</xsl:if>
						
						<fo:block role="SKIP"/>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row height="0" keep-with-next.within-page="always" role="SKIP">
					<fo:table-cell role="SKIP">
						<xsl:if test="$namespace = 'bsi'">
							<fo:marker marker-class-name="table_number"><xsl:value-of select="$table_number"/></fo:marker>
						</xsl:if>
						<xsl:if test="$namespace = 'iec' or $namespace = 'iso'">
							<fo:marker marker-class-name="table_number"><xsl:value-of select="normalize-space(translate($table_number, '&#xa0;', ' '))"/></fo:marker>
						</xsl:if>
						<fo:marker marker-class-name="table_continued">
							<xsl:value-of select="$title_continued"/>
						</fo:marker>
						 <fo:block role="SKIP"/>
					</fo:table-cell>
				</fo:table-row>
			</xsl:if>

			<xsl:apply-templates />
			
		</fo:table-body>
		
	</xsl:template> <!-- tbody -->
	
	<!-- ======================================== -->
	<!-- mode="process_table-if"                  -->
	<!-- ======================================== -->
	<xsl:template match="/" mode="process_table-if">
		<xsl:param name="table_or_dl">table</xsl:param>
		<xsl:apply-templates mode="process_table-if">
			<xsl:with-param name="table_or_dl" select="$table_or_dl"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="*[local-name()='tbody']" mode="process_table-if">
		<xsl:param name="table_or_dl">table</xsl:param>
		
		<fo:table-body>
			<xsl:for-each select="*[local-name() = 'tr']">
				<xsl:variable name="col_count" select="count(*)"/>

				<!-- iteration for each tr/td -->
				
				<xsl:choose>
					<xsl:when test="$table_or_dl = 'table'">
						<xsl:for-each select="*[local-name() = 'td' or local-name() = 'th']/*">
							<fo:table-row number-columns-spanned="{$col_count}">
								<xsl:copy-of select="../@font-weight"/>
								<!-- <test_table><xsl:copy-of select="."/></test_table> -->
								<xsl:call-template name="td"/>
							</fo:table-row>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise> <!-- $table_or_dl = 'dl' -->
						<xsl:for-each select="*[local-name() = 'td' or local-name() = 'th']">
							<xsl:variable name="is_dt" select="position() = 1"/>
							
							<xsl:for-each select="*">
								<!-- <test><xsl:copy-of select="."/></test> -->
								<fo:table-row number-columns-spanned="{$col_count}">
									<xsl:choose>
										<xsl:when test="$is_dt">
											<xsl:call-template name="insert_dt_cell"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="insert_dd_cell"/>
										</xsl:otherwise>
									</xsl:choose>
								</fo:table-row>
							</xsl:for-each>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
				
			</xsl:for-each>
		</fo:table-body>
	</xsl:template> <!-- process_table-if -->
	<!-- ======================================== -->
	<!-- END: mode="process_table-if"             -->
	<!-- ======================================== -->
	
	<!-- ===================== -->
	<!-- Table's row processing -->
	<!-- ===================== -->
	<!-- row in table header (thead) thead/tr -->
	<xsl:template match="mn:thead/mn:tr" priority="2">
		<fo:table-row xsl:use-attribute-sets="table-header-row-style">
		
			<xsl:call-template name="refine_table-header-row-style"/>
			
			<xsl:call-template name="setTableRowAttributes"/>
			
			<xsl:apply-templates />
		</fo:table-row>
	</xsl:template>	
	
	<xsl:template name="setBorderUnderRow">
		<xsl:variable name="border_under_row_" select="normalize-space(ancestor::mn:table[1]/@border-under-row)"/>
		<xsl:choose>
			<xsl:when test="$border_under_row_ != ''">
				<xsl:variable name="table_id" select="ancestor::mn:table[1]/@id"/>
				<xsl:variable name="row_num_"><xsl:number level="any" count="mn:table[@id = $table_id]//mn:tr"/></xsl:variable>
				<xsl:variable name="row_num" select="number($row_num_) - 1"/> <!-- because values in border-under-row start with 0 -->
				<xsl:variable name="border_under_row">
					<xsl:call-template name="split">
						<xsl:with-param name="pText" select="$border_under_row_"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:if test="xalan:nodeset($border_under_row)/mnx:item[. = normalize-space($row_num)]">
					<xsl:attribute name="border-bottom"><xsl:value-of select="$table-border"/></xsl:attribute>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="border-bottom"><xsl:value-of select="$table-border"/></xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
		
	<!-- row in table footer (tfoot), tfoot/tr -->
	<xsl:template match="mn:tfoot/mn:tr" priority="2">
		<fo:table-row xsl:use-attribute-sets="table-footer-row-style">
		
			<xsl:call-template name="refine_table-footer-row-style"/>
		
			<xsl:call-template name="setTableRowAttributes"/>
			<xsl:apply-templates />
		</fo:table-row>
	</xsl:template>
	
	
	<!-- row in table's body (tbody) -->
	<xsl:template match="*[local-name()='tr']">
		<fo:table-row xsl:use-attribute-sets="table-body-row-style">
		
			<xsl:if test="count(*) = count(*[local-name() = 'th'])"> <!-- row contains 'th' only -->
				<xsl:attribute name="keep-with-next">always</xsl:attribute>
			</xsl:if>
		
			<xsl:call-template name="refine_table-body-row-style"/>
		
			<xsl:call-template name="setTableRowAttributes"/>
			
			<xsl:apply-templates />
		</fo:table-row>
	</xsl:template>
	
	<xsl:template name="setTableRowAttributes">
	
		<xsl:if test="$namespace = 'bipm'">
			<xsl:if test="count(*) = 1 and local-name(*[1]) = 'th'">
				<xsl:attribute  name="keep-with-next.within-page">always</xsl:attribute>
			</xsl:if>
			<xsl:if test="not(ancestor::*[local-name()='note_side'])">
			 <xsl:attribute name="min-height">5mm</xsl:attribute>
			 </xsl:if>
		</xsl:if>
	
		<xsl:if test="$namespace = 'bsi'">
			<xsl:if test="(ancestor::mn:preface and ancestor::mn:clause[@type = 'corrigenda'] and normalize-space() = '') or
			(ancestor::mn:copyright-statement and contains(ancestor::mn:clause[1]/mn:title, 'Amendments/corrigenda') and normalize-space() = '')">
				<xsl:attribute name="min-height">0mm</xsl:attribute>
			</xsl:if>
			<xsl:if test="$document_type = 'PAS'">
				<xsl:attribute name="min-height">6mm</xsl:attribute>
			</xsl:if>
		</xsl:if>

		<xsl:if test="$namespace = 'itu'">
			<xsl:variable name="doctype" select="ancestor::mn:metanorma/mn:bibdata/mn:ext/mn:doctype[not(@language) or @language = '']"/>
			<xsl:if test="$doctype = 'service-publication'">
				<xsl:attribute name="min-height">5mm</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'unece'">
			<xsl:if test="not(*[local-name()='th'])">
				<xsl:attribute name="min-height">8mm</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:call-template name="setColors"/>
		
	</xsl:template> <!-- setTableRowAttributes -->
	<!-- ===================== -->
	<!-- END Table's row processing -->
	<!-- ===================== -->
	
	<!-- cell in table header row -->
	<xsl:template match="*[local-name()='th']">
		<fo:table-cell xsl:use-attribute-sets="table-header-cell-style"> <!-- text-align="{@align}" -->
			<xsl:call-template name="setTextAlignment">
				<xsl:with-param name="default">center</xsl:with-param>
			</xsl:call-template>
			
			<xsl:copy-of select="@keep-together.within-line"/>
			
			<xsl:call-template name="refine_table-header-cell-style"/>
			
			<!-- experimental feature, see https://github.com/metanorma/metanorma-plateau/issues/30#issuecomment-2145461828 -->
			<!-- <xsl:choose>
				<xsl:when test="count(node()) = 1 and mn:span[contains(@style, 'text-orientation')]">
					<fo:block-container reference-orientation="270">
						<fo:block role="SKIP" text-align="start">
							<xsl:apply-templates />
						</fo:block>
					</fo:block-container>
				</xsl:when>
				<xsl:otherwise>
					<fo:block role="SKIP">
						<xsl:apply-templates />
					</fo:block>
				</xsl:otherwise>
			</xsl:choose> -->
			
			<fo:block role="SKIP">
				<xsl:apply-templates />
				<xsl:if test="$isGenerateTableIF = 'false' and count(node()) = 0">&#xa0;</xsl:if>
			</fo:block>
		</fo:table-cell>
	</xsl:template> <!-- cell in table header row - 'th' -->
	
	
	<xsl:template name="setTableCellAttributes">
		<xsl:if test="@colspan">
			<xsl:attribute name="number-columns-spanned">
				<xsl:value-of select="@colspan"/>
			</xsl:attribute>
		</xsl:if>
		<xsl:if test="@rowspan">
			<xsl:attribute name="number-rows-spanned">
				<xsl:value-of select="@rowspan"/>
			</xsl:attribute>
		</xsl:if>
		<xsl:call-template name="display-align" />
		<xsl:call-template name="setColors"/>
	</xsl:template>
	
	<xsl:template name="display-align">
		<xsl:if test="@valign">
			<xsl:attribute name="display-align">
				<xsl:choose>
					<xsl:when test="@valign = 'top'">before</xsl:when>
					<xsl:when test="@valign = 'middle'">center</xsl:when>
					<xsl:when test="@valign = 'bottom'">after</xsl:when>
					<xsl:otherwise>before</xsl:otherwise>
				</xsl:choose>					
			</xsl:attribute>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="setColors">
		<xsl:variable name="styles__">
			<xsl:call-template name="split">
				<xsl:with-param name="pText" select="concat(@style,';')"/>
				<xsl:with-param name="sep" select="';'"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="quot">"</xsl:variable>
		<xsl:variable name="styles_">
			<xsl:for-each select="xalan:nodeset($styles__)/mnx:item">
				<xsl:variable name="key" select="normalize-space(substring-before(., ':'))"/>
				<xsl:variable name="value" select="normalize-space(substring-after(translate(.,$quot,''), ':'))"/>
				<xsl:if test="$key = 'color' or 
					$key = 'background-color' or
					$key = 'border' or
					$key = 'border-top' or
					$key = 'border-right' or
					$key = 'border-left' or
					$key = 'border-bottom' or
					$key = 'border-style' or
					$key = 'border-width' or
					$key = 'border-color' or
					$key = 'border-top-style' or
					$key = 'border-top-width' or
					$key = 'border-top-color' or
					$key = 'border-right-style' or
					$key = 'border-right-width' or
					$key = 'border-right-color' or
					$key = 'border-left-style' or
					$key = 'border-left-width' or
					$key = 'border-left-color' or
					$key = 'border-bottom-style' or
					$key = 'border-bottom-width' or
					$key = 'border-bottom-color'">
					<style name="{$key}"><xsl:value-of select="java:replaceAll(java:java.lang.String.new($value), 'currentColor', 'inherit')"/></style>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="styles" select="xalan:nodeset($styles_)"/>
		<xsl:for-each select="$styles/style">
			<xsl:attribute name="{@name}"><xsl:value-of select="."/></xsl:attribute>
		</xsl:for-each>
	</xsl:template> <!-- setColors -->
	
	<!-- cell in table body, footer -->
	<xsl:template match="*[local-name()='td']" name="td">
		<fo:table-cell xsl:use-attribute-sets="table-cell-style"> <!-- text-align="{@align}" -->
			<xsl:call-template name="setTextAlignment">
				<xsl:with-param name="default">left</xsl:with-param>
			</xsl:call-template>
			
			<xsl:copy-of select="@keep-together.within-line"/>
			
			<xsl:call-template name="refine_table-cell-style"/>
			
			<xsl:call-template name="setTableCellAttributes"/>
			
			<xsl:if test=".//mn:table"> <!-- if there is nested table -->
				<xsl:attribute name="padding-right">1mm</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="$isGenerateTableIF = 'true'">
				<xsl:attribute name="border">1pt solid black</xsl:attribute> <!-- border is mandatory, to determine page width -->
				<xsl:attribute name="text-align">left</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="$isGenerateTableIF = 'false'">
				<xsl:if test="@colspan and mn:note[@type = 'units']">
					<xsl:attribute name="text-align">right</xsl:attribute>
					<xsl:attribute name="border">none</xsl:attribute>
					<xsl:attribute name="border-bottom"><xsl:value-of select="$table-border"/></xsl:attribute>
					<xsl:attribute name="border-top">1pt solid white</xsl:attribute>
					<xsl:attribute name="border-left">1pt solid white</xsl:attribute>
					<xsl:attribute name="border-right">1pt solid white</xsl:attribute>
				</xsl:if>
			</xsl:if>
			
			<fo:block role="SKIP">
			
				<xsl:if test="$isGenerateTableIF = 'true'">
					<xsl:choose>
						<xsl:when test="$namespace = 'jis'">
							<fo:inline>
								<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
								<xsl:value-of select="$hair_space"/>
							</fo:inline>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			
				<xsl:if test="$namespace = 'bipm'">
					<xsl:if test="not(.//mn:image)">
						<xsl:attribute name="line-stacking-strategy">font-height</xsl:attribute>
					</xsl:if>
					<!-- hanging indent for left column -->
					<xsl:if test="not(preceding-sibling::*[local-name() = 'td'])">
						<xsl:attribute name="text-indent">-3mm</xsl:attribute>
						<xsl:attribute name="start-indent">3mm</xsl:attribute>
					</xsl:if>
				</xsl:if>
				
				<xsl:apply-templates />
				
				<xsl:if test="$isGenerateTableIF = 'true'">&#xa0;<fo:inline id="{@id}_end">end</fo:inline></xsl:if> <!-- to determine width of text --> <!-- <xsl:value-of select="$hair_space"/> -->
				
				<xsl:if test="$isGenerateTableIF = 'false' and count(node()) = 0">&#xa0;</xsl:if>
				
			</fo:block>			
		</fo:table-cell>
	</xsl:template> <!-- td -->
	

	<!-- table/note, table/example, table/tfoot//note, table/tfoot//example -->
	<xsl:template match="mn:table/*[self::mn:note or self::mn:example] |
						mn:table/mn:tfoot//*[self::mn:note or self::mn:example]" priority="2">
		<xsl:choose>
			<xsl:when test="$namespace = 'jis'">
				<xsl:call-template name="setNamedDestination"/>
				<fo:list-block id="{@id}" xsl:use-attribute-sets="table-note-style" provisional-distance-between-starts="{9 + $text_indent}mm"> <!-- 12 -->
					<fo:list-item>
						<fo:list-item-label start-indent="{$text_indent}mm" end-indent="label-end()">
							<fo:block>
								<xsl:apply-templates select="mn:name" />
							</fo:block>
						</fo:list-item-label>
						<fo:list-item-body start-indent="body-start()" xsl:use-attribute-sets="table-fn-body-style">
							<fo:block>
								<xsl:apply-templates select="node()[not(self::mn:name)]" />
							</fo:block>
						</fo:list-item-body>
					</fo:list-item>
				</fo:list-block>
				<!-- jis -->
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="setNamedDestination"/>
				<fo:block xsl:use-attribute-sets="table-note-style">
					<xsl:copy-of select="@id"/>

					<xsl:call-template name="refine_table-note-style"/>

					<!-- Table's note/example name (NOTE, for example) -->
					<fo:inline xsl:use-attribute-sets="table-note-name-style">
						
						<xsl:call-template name="refine_table-note-name-style"/>
						
						<xsl:apply-templates select="mn:name" />
						
					</fo:inline>
					
					<xsl:if test="$namespace = 'bipm'">
						<xsl:if test="ancestor::mn:preface">
							<fo:block>&#xA0;</fo:block>
						</xsl:if>
					</xsl:if>
					
					<xsl:apply-templates select="node()[not(self::mn:name)]" />
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- table/note -->
	
	
	<xsl:template match="mn:table/*[self::mn:note or self::mn:example]/mn:p |
	mn:table/mn:tfoot//*[self::mn:note or self::mn:example]/mn:p" priority="2">
		<xsl:apply-templates/>
	</xsl:template>
	
	
	
	<!-- ============================ -->
	<!-- table's footnotes rendering -->
	<!-- ============================ -->
	
	<!-- table/fmt-footnote-container -->
	<xsl:template match="mn:table/mn:fmt-footnote-container"/>
	
	
	<xsl:template match="mn:table/mn:tfoot//mn:fmt-footnote-container">
		<xsl:for-each select=".">
			<xsl:call-template name="table_fn_display"/>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template name="table_fn_display">
		<!-- <xsl:variable name="references">
			<xsl:if test="$namespace = 'bsi'">
				<xsl:for-each select="..//mn:fn[local-name(..) = 'name']">
					<xsl:call-template name="create_fn" />
				</xsl:for-each>
			</xsl:if>
			<xsl:for-each select="..//mn:fn[local-name(..) != 'name']">
				<xsl:call-template name="create_fn" />
			</xsl:for-each>
		</xsl:variable> -->
		<!-- <xsl:for-each select="xalan:nodeset($references)//fn">
			<xsl:variable name="reference" select="@reference"/>
			<xsl:if test="not(preceding-sibling::*[@reference = $reference])">  --> <!-- only unique reference puts in note-->
		<xsl:for-each select="..//mn:fmt-footnote-container/mn:fmt-fn-body">
			
				<xsl:choose>
					<xsl:when test="$namespace = 'bsi'">
						<fo:list-block id="{@id}" xsl:use-attribute-sets="table-fn-style" provisional-distance-between-starts="4mm">
							<xsl:if test="$document_type = 'PAS'">
								<xsl:attribute name="font-size">inherit</xsl:attribute>
							</xsl:if>
							<fo:list-item>
								<fo:list-item-label end-indent="label-end()">
									<fo:block>
										<!-- <xsl:attribute name="font-size">5.5pt</xsl:attribute>
										<xsl:if test="$document_type = 'PAS'">
											<xsl:attribute name="padding-right">0.5mm</xsl:attribute>
											<xsl:attribute name="font-size">4.5pt</xsl:attribute>
										</xsl:if> -->
										<!-- <xsl:value-of select="@reference"/>
										<xsl:text>)</xsl:text> -->
										<!-- <xsl:value-of select="normalize-space(.//mn:fmt-fn-label)"/> -->
										<xsl:apply-templates select=".//mn:fmt-fn-label">
											<xsl:with-param name="process">true</xsl:with-param>
										</xsl:apply-templates>
										
									</fo:block>
								</fo:list-item-label>
								<fo:list-item-body start-indent="body-start()" xsl:use-attribute-sets="table-fn-body-style">
									<fo:block>
										<!-- <xsl:copy-of select="./node()"/> -->
										<xsl:apply-templates />
									</fo:block>
								</fo:list-item-body>
							</fo:list-item>
						</fo:list-block>
						<!-- bsi -->
					</xsl:when>
					
					<xsl:when test="$namespace = 'jis'">
						<fo:list-block id="{@id}" xsl:use-attribute-sets="table-fn-style" provisional-distance-between-starts="{9 + $text_indent}mm"> <!-- 12 -->
							<fo:list-item>
								<fo:list-item-label start-indent="{$text_indent}mm" end-indent="label-end()">
									<fo:block>
										<!-- <fo:inline font-size="9pt">
											<xsl:if test="not($vertical_layout = 'true')">
												<xsl:attribute name="font-family">IPAexGothic</xsl:attribute>
											</xsl:if>
											<xsl:call-template name="getLocalizedString">
												<xsl:with-param name="key">table_footnote</xsl:with-param>
											</xsl:call-template>
										</fo:inline>
										<xsl:text> </xsl:text> -->
										
										<xsl:apply-templates select=".//mn:fmt-fn-label">
											<xsl:with-param name="process">true</xsl:with-param>
										</xsl:apply-templates>
										
										<!-- <fo:inline xsl:use-attribute-sets="table-fn-number-style table-fmt-fn-label-style"> -->
											<!-- <xsl:if test="not($vertical_layout = 'true')">
												<xsl:attribute name="font-family">Times New Roman</xsl:attribute>
											</xsl:if> -->
											<!-- <xsl:value-of select="@reference"/> -->
											<!-- <xsl:apply-templates select=".//mn:fmt-fn-label">
												<xsl:with-param name="process">true</xsl:with-param>
											</xsl:apply-templates> -->
											<!-- <xsl:value-of select="normalize-space(.//mn:fmt-fn-label)"/> -->
											<!-- <xsl:apply-templates select=".//mn:fmt-fn-label">
												<xsl:with-param name="process">true</xsl:with-param>
											</xsl:apply-templates> -->
											
											<!-- <fo:inline font-weight="normal">)</fo:inline> --> <!-- commented, https://github.com/metanorma/isodoc/issues/614 -->
										<!-- </fo:inline> -->
									</fo:block>
								</fo:list-item-label>
								<fo:list-item-body start-indent="body-start()" xsl:use-attribute-sets="table-fn-body-style">
									<fo:block>
										<!-- <xsl:copy-of select="./node()"/> -->
										<xsl:apply-templates />
									</fo:block>
								</fo:list-item-body>
							</fo:list-item>
						</fo:list-block>
						<!-- jis -->
					</xsl:when>
					
					<xsl:otherwise>
						<fo:block xsl:use-attribute-sets="table-fn-style">
							<xsl:copy-of select="@id"/>
							<xsl:call-template name="refine_table-fn-style"/>
							
							<xsl:apply-templates select=".//mn:fmt-fn-label">
								<xsl:with-param name="process">true</xsl:with-param>
							</xsl:apply-templates>
							
							<fo:inline xsl:use-attribute-sets="table-fn-body-style">
								<!-- <xsl:copy-of select="./node()"/> -->
								<xsl:apply-templates />
							</fo:inline>
							
						</fo:block>
					</xsl:otherwise>
				</xsl:choose>
			
			<!-- </xsl:if> -->
		</xsl:for-each>
	</xsl:template> <!-- table_fn_display -->
	
	
	<!-- fmt-fn-body/fmt-fn-label in text -->
	<xsl:template match="mn:fmt-fn-body//mn:fmt-fn-label"/>
	
	<!-- table//fmt-fn-body//fmt-fn-label -->
	<xsl:template match="mn:table//mn:fmt-fn-body//mn:fmt-fn-label"> <!-- mn:fmt-footnote-container/ -->
		<xsl:param name="process">false</xsl:param>
		<xsl:if test="$process = 'true'">
			<fo:inline xsl:use-attribute-sets="table-fn-number-style" role="SKIP">
				
				<!-- tab is padding-right -->
				<xsl:apply-templates select=".//mn:tab">
					<xsl:with-param name="process">true</xsl:with-param>
				</xsl:apply-templates>
				
				<!-- <xsl:if test="$namespace = 'bipm'">
					<fo:inline font-style="normal">(</fo:inline>
				</xsl:if> -->
				
				<!-- <xsl:if test="$namespace = 'plateau'">
					<xsl:text>※</xsl:text>
				</xsl:if> -->
				
				<!-- <xsl:value-of select="@reference"/> -->
				<!-- <xsl:value-of select="normalize-space()"/> -->
				<xsl:apply-templates />
				
				<!-- <xsl:if test="$namespace = 'bipm'">
					<fo:inline font-style="normal">)</fo:inline>
				</xsl:if> -->
				
				<!-- commented https://github.com/metanorma/isodoc/issues/614 -->
				<!-- <xsl:if test="$namespace = 'itu'">
					<xsl:text>)</xsl:text>
				</xsl:if> -->
				
				<!-- <xsl:if test="$namespace = 'plateau'">
					<xsl:text>：</xsl:text>
				</xsl:if> -->
				
			</fo:inline>
		</xsl:if>
	</xsl:template> <!--  fmt-fn-body//fmt-fn-label -->
	
	<xsl:template match="mn:table//mn:fmt-fn-body//mn:fmt-fn-label//mn:tab" priority="5">
		<xsl:param name="process">false</xsl:param>
		<xsl:if test="$process = 'true'">
			<xsl:attribute name="padding-right">5mm</xsl:attribute>
			<xsl:if test="$namespace = 'bipm'">
				<xsl:attribute name="padding-right">2.5mm</xsl:attribute>
			</xsl:if>
			<xsl:if test="$namespace = 'bsi'">
				<xsl:attribute name="padding-right">0mm</xsl:attribute>
				<xsl:if test="$document_type = 'PAS'">
					<xsl:attribute name="padding-right">0.5mm</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$namespace = 'itu'">
				<xsl:attribute name="padding-right">3mm</xsl:attribute>
			</xsl:if>
			<xsl:if test="$namespace = 'jis'">
				<xsl:attribute name="padding-right">0mm</xsl:attribute>
			</xsl:if>
			<xsl:if test="$namespace = 'plateau'">
				<xsl:attribute name="padding-right">2mm</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="mn:table//mn:fmt-fn-body//mn:fmt-fn-label//mn:sup" priority="5">
		<fo:inline xsl:use-attribute-sets="table-fmt-fn-label-style" role="SKIP">
			<xsl:call-template name="refine_table-fmt-fn-label-style"/>
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>
	
	<!-- <xsl:template match="mn:fmt-footnote-container/mn:fmt-fn-body//mn:fmt-fn-label//mn:tab"/> -->
	<!-- 
	<xsl:template name="create_fn">
		<fn reference="{@reference}" id="{@reference}_{ancestor::*[@id][1]/@id}">
			<xsl:if test="ancestor::*[local-name()='table'][1]/@id">  - for footnotes in tables -
				<xsl:attribute name="id">
					<xsl:value-of select="concat(@reference, '_', ancestor::*[local-name()='table'][1]/@id)"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="$namespace = 'itu'">
				<xsl:if test="ancestor::mn:preface">
					<xsl:attribute name="preface">true</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
				<xsl:attribute name="id">
					<xsl:value-of select="@reference"/>
					<xsl:text>_</xsl:text>
					<xsl:value-of select="ancestor::*[local-name()='table'][1]/@id"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates />
		</fn>
	</xsl:template> -->
	
	<!-- footnotes for table's name rendering -->
	<xsl:template name="table_name_fn_display">
		<xsl:for-each select="mn:name//mn:fn">
			<xsl:variable name="reference" select="@reference"/>
			<fo:block id="{@reference}_{ancestor::*[@id][1]/@id}"><xsl:value-of select="@reference"/></fo:block>
			<fo:block margin-bottom="12pt">
				<xsl:apply-templates />
			</fo:block>
		</xsl:for-each>
	</xsl:template>
	<!-- ============================ -->
	<!-- EMD table's footnotes rendering -->
	<!-- ============================ -->
	
	
	<!-- fn reference in the table rendering (for instance, 'some text 1) some text' ) -->
	<!-- fn --> <!-- in table --> <!-- for figure see <xsl:template match="mn:figure/mn:fn" priority="2"/> -->
	<xsl:template match="mn:fn">
		<xsl:variable name="target" select="@target"/>
		<xsl:choose>
			<!-- case for footnotes in Requirement tables (https://github.com/metanorma/metanorma-ogc/issues/791) -->
			<xsl:when test="not(ancestor::mn:table[1]//mn:fmt-footnote-container/mn:fmt-fn-body[@id = $target]) and
							$footnotes/mn:fmt-fn-body[@id = $target]">
				<xsl:call-template name="fn">
					<xsl:with-param name="footnote_body_from_table">true</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
			
				<fo:inline xsl:use-attribute-sets="fn-reference-style">
				
					<xsl:call-template name="refine_fn-reference-style"/>
					
					<!-- <fo:basic-link internal-destination="{@reference}_{ancestor::*[@id][1]/@id}" fox:alt-text="footnote {@reference}"> --> <!-- @reference   | ancestor::mn:clause[1]/@id-->
					<fo:basic-link internal-destination="{@target}" fox:alt-text="footnote {@reference}">
						<!-- <xsl:if test="ancestor::*[local-name()='table'][1]/@id"> --> <!-- for footnotes in tables -->
						<!-- 	<xsl:attribute name="internal-destination">
								<xsl:value-of select="concat(@reference, '_', ancestor::*[local-name()='table'][1]/@id)"/>
							</xsl:attribute>
						</xsl:if>
						<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
							<xsl:attribute name="internal-destination">
								<xsl:value-of select="@reference"/><xsl:text>_</xsl:text>
								<xsl:value-of select="ancestor::*[local-name()='table'][1]/@id"/>
							</xsl:attribute>
						</xsl:if> -->
						<!-- <xsl:if test="$namespace = 'plateau'">
							<xsl:text>※</xsl:text>
						</xsl:if> -->
						<!-- <xsl:value-of select="@reference"/> -->
						
						<xsl:choose>
							<xsl:when test="$namespace = 'bipm'">
								<fo:inline font-style="normal">&#xA0;</fo:inline>
								<!-- Example: <fmt-fn-label><sup><span class="fmt-label-delim">(</span>a<span class="fmt-label-delim">)</span></sup></fmt-fn-label> -->
								<!-- to <fo:inline font-style="normal">(</fo:inline> ... -->
								<xsl:apply-templates select="mn:fmt-fn-label/node()"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="normalize-space(mn:fmt-fn-label)"/>
							</xsl:otherwise>
						</xsl:choose>
						
						<!-- <xsl:if test="$namespace = 'bsi'">
							<xsl:text>)</xsl:text>
						</xsl:if> -->
						<!-- commented, https://github.com/metanorma/isodoc/issues/614 -->
						<!-- <xsl:if test="$namespace = 'jis'">
							<fo:inline font-weight="normal">)</fo:inline>
						</xsl:if> -->
					</fo:basic-link>
				</fo:inline>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- fn -->
	
</xsl:stylesheet>