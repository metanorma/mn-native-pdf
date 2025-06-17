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
	
</xsl:stylesheet>