<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
											xmlns:fo="http://www.w3.org/1999/XSL/Format"
											xmlns:mathml="http://www.w3.org/1998/Math/MathML" 
											xmlns:xalan="http://xml.apache.org/xalan"  
											xmlns:fox="http://xmlgraphics.apache.org/fop/extensions" 
											xmlns:java="http://xml.apache.org/xalan/java" 
											exclude-result-prefixes="java"
											version="1.0">

	<xsl:variable name="titles" select="xalan:nodeset($titles_)"/>
	
	<xsl:variable name="titles_">
		
		<title-table lang="en">Table </title-table>
		<title-table lang="fr">Tableau </title-table>
		<xsl:if test="$namespace = 'iso' or $namespace = 'iec' or $namespace = 'itu' or $namespace = 'unece' or $namespace = 'unece-rec' or $namespace = 'nist' or $namespace = 'ogc' or $namespace = 'rsd' or $namespace = 'csa' or $namespace = 'csd' or $namespace = 'm3d' or $namespace = 'iho'">			
			<title-table lang="zh">Table </title-table>
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">			
			<title-table lang="zh">表 </title-table>
		</xsl:if>
	
	
		<title-example lang="en">EXAMPLE </title-example>
		<title-example lang="fr">EXEMPLE </title-example>
		<xsl:if test="$namespace = 'iso' or $namespace = 'iec' or $namespace = 'itu' or $namespace = 'unece' or $namespace = 'unece-rec' or $namespace = 'nist' or $namespace = 'ogc' or $namespace = 'rsd' or $namespace = 'csa' or $namespace = 'csd' or $namespace = 'm3d' or $namespace = 'iho'">
			<title-example lang="zh">EXAMPLE </title-example>
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			<title-example lang="zh">示例 </title-example>				
		</xsl:if>
		
		<title-example-xref lang="en">Example </title-example-xref>
		<title-example-xref lang="fr">Exemple </title-example-xref>
			
		<title-section lang="en">Section </title-section>
		<title-section lang="fr">Section </title-section>
		
		<title-inequality lang="en">Inequality </title-inequality>
		<title-inequality lang="fr">Inequality </title-inequality>
		
		<title-equation lang="en">Equation </title-equation>
		<title-equation lang="fr">Equation </title-equation>
				
		<title-annex lang="en">Annex </title-annex>
		<title-annex lang="fr">Annexe </title-annex>
		<xsl:if test="$namespace = 'iso' or $namespace = 'iec' or $namespace = 'itu' or $namespace = 'unece' or $namespace = 'unece-rec' or $namespace = 'nist' or $namespace = 'ogc' or $namespace = 'rsd' or $namespace = 'csa' or $namespace = 'csd' or $namespace = 'm3d' or $namespace = 'iho'">
			<title-annex lang="zh">Annex </title-annex>
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			<title-annex lang="zh">附件 </title-annex>			
		</xsl:if>
		
		<title-appendix lang="en">Appendix </title-appendix>
		<title-appendix lang="fr">Appendix </title-appendix>
			
		<title-clause lang="en">Clause </title-clause>
		<title-clause lang="fr">Article </title-clause>
		<xsl:if test="$namespace = 'iso' or $namespace = 'iec' or $namespace = 'itu' or $namespace = 'unece' or $namespace = 'unece-rec' or $namespace = 'nist' or $namespace = 'ogc' or $namespace = 'rsd' or $namespace = 'csa' or $namespace = 'csd' or $namespace = 'm3d' or $namespace = 'iho'">
			<title-clause lang="zh">Clause </title-clause>
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			<title-clause lang="zh">条 </title-clause>			
		</xsl:if>
		
		<title-edition lang="en">
			<xsl:if test="$namespace = 'iso' or $namespace = 'iec' or $namespace = 'itu' or $namespace = 'unece' or $namespace = 'unece-rec' or $namespace = 'nist' or $namespace = 'csd' or $namespace = 'iho'">
				<xsl:text>Edition </xsl:text>
			</xsl:if>
			<xsl:if test="$namespace = 'csa' or $namespace = 'm3d' or $namespace = 'ogc' or $namespace = 'rsd'">
				<xsl:text>Version</xsl:text>
			</xsl:if>
		</title-edition>
		
		<title-formula lang="en">Formula </title-formula>
		<title-formula lang="fr">Formula </title-formula>
		
		<title-toc lang="en">
			<xsl:if test="$namespace = 'iso' or $namespace = 'iec' or $namespace = 'iho' or $namespace = 'csd' or $namespace = 'rsd' or $namespace = 'ogc' or $namespace = 'unece-rec'">
				<xsl:text>Contents</xsl:text>
			</xsl:if>
			<xsl:if test="$namespace = 'itu' or $namespace = 'csa' or $namespace = 'm3d' or $namespace = 'nist'">
				<xsl:text>Table of Contents</xsl:text>
			</xsl:if>
			<xsl:if test="$namespace = 'gb'">
				<xsl:text>Table of contents</xsl:text>
			</xsl:if>
		</title-toc>
		<title-toc lang="fr">Sommaire</title-toc>
		<xsl:if test="$namespace = 'iso' or $namespace = 'iec' or $namespace = 'itu' or $namespace = 'unece' or $namespace = 'unece-rec' or $namespace = 'nist' or $namespace = 'ogc' or $namespace = 'rsd' or $namespace = 'csa' or $namespace = 'csd' or $namespace = 'm3d' or $namespace = 'iho'">
			<title-toc lang="zh">Contents</title-toc>
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			<title-toc lang="zh">目次</title-toc>			
		</xsl:if>
		
		<title-page lang="en">Page</title-page>
		<title-page lang="fr">Page</title-page>
		
		<title-key lang="en">Key</title-key>
		<title-key lang="fr">Légende</title-key>
			
		<title-where lang="en">where</title-where>
		<title-where lang="fr">où</title-where>
					
		<title-descriptors lang="en">Descriptors</title-descriptors>
		
		<title-part lang="en">
			<xsl:if test="$namespace = 'iso'">
				<xsl:text>Part #:</xsl:text>
			</xsl:if>
			<xsl:if test="$namespace = 'iec' or $namespace = 'gb'">
				<xsl:text>Part #: </xsl:text>
			</xsl:if>
		</title-part>
		<title-part lang="fr">
			<xsl:if test="$namespace = 'iso'">
				<xsl:text>Partie #:</xsl:text>
			</xsl:if>
			<xsl:if test="$namespace = 'iec' or $namespace = 'gb'">
				<xsl:text>Partie #:  </xsl:text>
			</xsl:if>
		</title-part>		
		<title-part lang="zh">第 # 部分:</title-part>
		
		<title-modified lang="en">modified</title-modified>
		<title-modified lang="fr">modifiée</title-modified>
		<xsl:if test="$namespace = 'iso' or $namespace = 'iec' or $namespace = 'itu' or $namespace = 'unece' or $namespace = 'unece-rec' or $namespace = 'nist' or $namespace = 'ogc' or $namespace = 'rsd' or $namespace = 'csa' or $namespace = 'csd' or $namespace = 'm3d' or $namespace = 'iho'">
			<title-modified lang="zh">modified</title-modified>
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			<title-modified lang="zh">改写</title-modified>			
		</xsl:if>
		
		<title-source lang="en">SOURCE</title-source>
		
		<title-keywords lang="en">Keywords</title-keywords>
		
		<title-deprecated lang="en">DEPRECATED</title-deprecated>
		<title-deprecated lang="fr">DEPRECATED</title-deprecated>
		
		<title-submitting-organizations lang="en">Submitting Organizations</title-submitting-organizations>
		
		<title-list-tables lang="en">List of Tables</title-list-tables>
		
		<title-list-figures lang="en">List of Figures</title-list-figures>
		
		<title-recommendation lang="en">Recommendation </title-recommendation>
		
		<title-acknowledgements lang="en">Acknowledgements</title-acknowledgements>
		
		<title-abstract lang="en">Abstract</title-abstract>
		
		<title-summary lang="en">Summary</title-summary>
		
		<title-in lang="en">in </title-in>
		
		<title-box lang="en">Box </title-box>
		
		<title-partly-supercedes lang="en">Partly Supercedes </title-partly-supercedes>
		<title-partly-supercedes lang="zh">部分代替 </title-partly-supercedes>
		
		<title-completion-date lang="en">Completion date for this manuscript</title-completion-date>
		<title-completion-date lang="zh">本稿完成日期</title-completion-date>
		
		<title-issuance-date lang="en">Issuance Date: #</title-issuance-date>
		<title-issuance-date lang="zh"># 发布</title-issuance-date>
		
		<title-implementation-date lang="en">Implementation Date: #</title-implementation-date>
		<title-implementation-date lang="zh"># 实施</title-implementation-date>

		<title-obligation-normative lang="en">normative</title-obligation-normative>
		<title-obligation-normative lang="zh">规范性附录</title-obligation-normative>
		
		<title-caution lang="en">CAUTION</title-caution>
		<title-caution lang="zh">注意</title-caution>
			
		<title-warning lang="en">WARNING</title-warning>
		<title-warning lang="zh">警告</title-warning>
		
		<title-amendment lang="en">AMENDMENT</title-amendment>
	</xsl:variable>
	
	<xsl:template name="getTitle">
		<xsl:param name="name"/>
		<xsl:variable name="lang">
			<xsl:call-template name="getLang"/>
		</xsl:variable>
		<xsl:variable name="title_" select="$titles/*[local-name() = $name][@lang = $lang]"/>
		<xsl:choose>
			<xsl:when test="normalize-space($title_) != ''">
				<xsl:value-of select="$title_"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$titles/*[local-name() = $name][@lang = 'en']"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
		
	<xsl:variable name="lower">abcdefghijklmnopqrstuvwxyz</xsl:variable> 
	<xsl:variable name="upper">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>

	<xsl:variable name="en_chars" select="concat($lower,$upper,',.`1234567890-=~!@#$%^*()_+[]{}\|?/')"/>
	
	<xsl:variable name="linebreak" select="'&#x2028;'"/>
	
		
	<xsl:attribute-set name="link-style">
		<xsl:if test="$namespace = 'iso' or $namespace = 'csd' or $namespace = 'ogc' or $namespace = 'rsd' or or $namespace = 'm3d' or $namespace = 'iho'">
			<xsl:attribute name="color">blue</xsl:attribute>
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="color">rgb(33, 94, 159)</xsl:attribute>
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>

	<xsl:attribute-set name="sourcecode-style">
		<xsl:if test="$namespace = 'iso' or $namespace = 'gb'">
			<xsl:attribute name="font-family">Courier</xsl:attribute>
			<xsl:attribute name="font-size">9pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa' or $namespace = 'rsd'">
			<xsl:attribute name="font-family">SourceCodePro</xsl:attribute>
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="line-height">113%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csd'">
			<xsl:attribute name="font-family">SourceCodePro</xsl:attribute>
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>					
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="font-family">Courier</xsl:attribute>
			<xsl:attribute name="font-size">9pt</xsl:attribute>
			<xsl:attribute name="margin-top">5pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">5pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu' or $namespace = 'nist' or $namespace = 'unece' or $namespace = 'unece-rec'">
			<xsl:attribute name="font-family">Courier</xsl:attribute>
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'm3d'">
			<xsl:attribute name="font-family">Courier</xsl:attribute>			
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>		
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="font-family">Courier</xsl:attribute>
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="line-height">113%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="font-family">SFMono-Regular</xsl:attribute>
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="line-height">113%</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="termexample-style">
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="margin-top">14pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">10pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa' or $namespace = 'csd' or $namespace = 'ogc'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="font-size">9pt</xsl:attribute>
			<xsl:attribute name="margin-top">14pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">14pt</xsl:attribute>
			<xsl:attribute name="text-align">justify</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho' or $namespace = 'iso'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-top">8pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
			<xsl:attribute name="text-align">justify</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'm3d'">			
			<xsl:attribute name="margin-top">14pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">14pt</xsl:attribute>
			<xsl:attribute name="text-align">justify</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">			
			<xsl:attribute name="font-family">SourceSansPro</xsl:attribute>
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		
	</xsl:attribute-set>

	<xsl:attribute-set name="termexample-name-style">
		<xsl:if test="$namespace = 'csa' or $namespace = 'csd' or $namespace = 'iec' or $namespace = 'ogc' or $namespace = 'rsd'">
			<xsl:attribute name="padding-right">10mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="padding-right">1mm</xsl:attribute>
			<xsl:attribute name="font-family">SimHei</xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'iho' or $namespace = 'iso'">
			<xsl:attribute name="padding-right">5mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'm3d'">
			<xsl:attribute name="padding-right">1mm</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>			
		</xsl:if>
		
	</xsl:attribute-set>
	
	<xsl:attribute-set name="appendix-style">
		<xsl:if test="$namespace = 'iso' or $namespace = 'ogc' or $namespace = 'm3d' or $namespace = 'gb' or $namespace = 'csd'">		
			<xsl:attribute name="font-size">12pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="margin-top">5pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">5pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-size">12pt</xsl:attribute>
			<xsl:attribute name="font-family">SourceSansPro</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="appendix-example-style">
		<xsl:if test="$namespace = 'iso' or $namespace = 'ogc' or $namespace = 'm3d' or $namespace = 'gb' or $namespace = 'csd'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>			
			<xsl:attribute name="margin-top">8pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="margin-top">14pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">14pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-family">SourceSansPro</xsl:attribute>
			<xsl:attribute name="font-size">11pt</xsl:attribute>			
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="xref-style">
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho' or $namespace = 'iso' or $namespace = 'itu' or $namespace = 'nist' or $namespace = 'ogc' or $namespace = 'rsd'">
			<xsl:attribute name="color">blue</xsl:attribute>
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		</xsl:if>		
	</xsl:attribute-set>
	
	<xsl:attribute-set name="termnote-style">		
		<xsl:if test="$namespace = 'csa' or $namespace = 'csd' or $namespace = 'ogc' or $namespace = 'rsd'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>			
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="font-size">8pt</xsl:attribute>
			<xsl:attribute name="margin-top">5pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">5pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho' or $namespace = 'iso'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-top">8pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
			<xsl:attribute name="text-align">justify</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu' or $namespace = 'nist' or $namespace = 'unece' or $namespace = 'unece-rec'">			
			<xsl:attribute name="margin-top">4pt</xsl:attribute>			
		</xsl:if>
		
	</xsl:attribute-set>
	
	<xsl:template match="text()">
		<xsl:value-of select="."/>
	</xsl:template>

	<xsl:template match="*[local-name()='br']">
		<xsl:value-of select="$linebreak"/>
	</xsl:template>
	
	<xsl:template match="*[local-name()='td']//text() | *[local-name()='th']//text() | *[local-name()='dt']//text() | *[local-name()='dd']//text()" priority="1">
		<!-- <xsl:call-template name="add-zero-spaces"/> -->
		<xsl:call-template name="add-zero-spaces-java"/>
	</xsl:template>
	

	<xsl:template match="*[local-name()='table']">
	
		<xsl:variable name="simple-table">
			<!-- <xsl:copy> -->
				<xsl:call-template  name="getSimpleTable"/>
			<!-- </xsl:copy> -->
		</xsl:variable>
	
		<!-- DEBUG -->
		<!-- SourceTable=<xsl:copy-of select="current()"/>EndSourceTable -->
		<!-- Simpletable=<xsl:copy-of select="$simple-table"/>EndSimpltable -->
	
		<!-- <xsl:variable name="namespace" select="substring-before(name(/*), '-')"/> -->
		<xsl:if test="$namespace = 'itu'">
			<fo:block space-before="18pt">&#xA0;</fo:block>				
		</xsl:if>
		<!-- <xsl:if test="$namespace = 'iso'">
			<fo:block space-before="6pt">&#xA0;</fo:block>				
		</xsl:if> -->
		<xsl:if test="$namespace = 'iec'">
			<xsl:if test="not(ancestor::*[local-name() = 'preface'])">
				<!-- <fo:block space-before="2pt">&#xA0;</fo:block>				 -->
			</xsl:if>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="@unnumbered = 'true'"></xsl:when>
			<xsl:otherwise>
				<xsl:if test="$namespace = 'unece-rec'">
					<xsl:if test="ancestor::*[local-name() = 'sections']"></xsl:if>
				</xsl:if>
				<xsl:if test="$namespace = 'unece-rec'">
					<xsl:if test="not(ancestor::*[local-name() = 'sections'])">
						<fo:block font-weight="bold" text-align="center" margin-bottom="6pt" keep-with-next="always">
							<xsl:attribute name="text-align">left</xsl:attribute>
							<xsl:attribute name="margin-top">12pt</xsl:attribute>
							<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
							<xsl:if test="$namespace = 'unece'">
								<xsl:attribute name="font-weight">normal</xsl:attribute>
								<xsl:attribute name="font-size">11pt</xsl:attribute>
							</xsl:if>
							<xsl:variable name="title-table">
								<xsl:call-template name="getTitle">
									<xsl:with-param name="name" select="'title-table'"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:value-of select="$title-table"/>
							<xsl:choose>
								<xsl:when test="ancestor::*[local-name()='executivesummary']"> <!-- NIST -->
									<xsl:text>ES-</xsl:text><xsl:number format="1" count="*[local-name()='executivesummary']//*[local-name()='table'][not(@unnumbered) or @unnumbered != 'true']"/>
								</xsl:when>
								<xsl:when test="ancestor::*[local-name()='annex']">
									<xsl:if test="$namespace = 'iso' or $namespace = 'iec'">
										<xsl:number format="A." count="*[local-name()='annex']"/><xsl:number format="1"/>
									</xsl:if>
									<xsl:if test="$namespace = 'unece-rec'">
										<!-- <xsl:variable name="annex-id" select="ancestor::*[local-name()='annex']/@id"/>
										<xsl:number format="I." count="*[local-name()='annex']"/> -->
										<xsl:text>A</xsl:text> <!-- 'A' means Annex -->
										<xsl:number format="1" level="any" count="*[local-name()='table'][not(@unnumbered) or @unnumbered != 'true'][ancestor::*[local-name()='annex']]"/> <!-- [@id = $annex-id] -->
									</xsl:if>
								</xsl:when>
								<xsl:otherwise>
									<!-- <xsl:number format="1"/> -->
									<xsl:number format="A." count="*[local-name()='annex']"/>
									<!-- <xsl:number format="1" level="any" count="*[local-name()='sections']//*[local-name()='table'][not(@unnumbered) or @unnumbered != 'true']"/> -->
									<xsl:number format="1" level="any" count="//*[local-name()='table']
																																										[not(ancestor::*[local-name()='annex']) and not(ancestor::*[local-name()='executivesummary'])]
																																										[not(@unnumbered) or @unnumbered != 'true']"/>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:if test="*[local-name()='name']">
								<xsl:if test="$namespace = 'unece-rec'"><xsl:text>. </xsl:text></xsl:if>
								<xsl:apply-templates select="*[local-name()='name']" mode="process"/>
							</xsl:if>
						</fo:block>
					</xsl:if>
				</xsl:if>
				<xsl:if test="$namespace = 'iso' or $namespace = 'iec' or $namespace = 'itu' or  $namespace = 'nist' or $namespace = 'unece' or $namespace = 'csd' or $namespace = 'ogc'  or $namespace = 'gb' or $namespace = 'm3d' or $namespace = 'iho'">
					<fo:block font-weight="bold" text-align="center" margin-bottom="6pt" keep-with-next="always">
						<xsl:if test="$namespace = 'iso'">
							<xsl:attribute name="margin-top">12pt</xsl:attribute>
						</xsl:if>
						<xsl:if test="$namespace = 'iec'">
							<xsl:if test="ancestor::*[local-name() = 'preface']">
								<xsl:attribute name="visibility">hidden</xsl:attribute>
								<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
								<xsl:attribute name="font-size">1pt</xsl:attribute>
							</xsl:if>
							<xsl:if test="not(ancestor::*[local-name() = 'preface'])">
								<xsl:attribute name="space-before">12pt</xsl:attribute>
							</xsl:if>
						</xsl:if>
						<xsl:if test="$namespace = 'nist'">
							<xsl:attribute name="font-family">Arial</xsl:attribute>
							<xsl:attribute name="font-size">9pt</xsl:attribute>
						</xsl:if>
						<xsl:if test="$namespace = 'unece-rec'">
							<xsl:if test="not(ancestor::*[local-name() = 'sections'])">
								<xsl:attribute name="text-align">left</xsl:attribute>
								<xsl:attribute name="margin-top">12pt</xsl:attribute>
								<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
							</xsl:if>
						</xsl:if>
						<xsl:if test="$namespace = 'unece'">
							<xsl:attribute name="font-weight">normal</xsl:attribute>
							<xsl:attribute name="font-style">italic</xsl:attribute>
							<xsl:attribute name="font-size">10pt</xsl:attribute>
							<xsl:attribute name="text-align">left</xsl:attribute>
						</xsl:if>
						<xsl:if test="$namespace = 'ogc'">
							<xsl:attribute name="font-weight">normal</xsl:attribute>
							<xsl:attribute name="font-size">11pt</xsl:attribute>
						</xsl:if>
						<xsl:if test="$namespace = 'gb'">
							<xsl:attribute name="font-family">SimHei</xsl:attribute>
							<xsl:attribute name="font-weight">normal</xsl:attribute>
							<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
						</xsl:if>
						<xsl:if test="$namespace = 'iho'">							
							<xsl:attribute name="font-weight">normal</xsl:attribute>
							<xsl:attribute name="font-size">11pt</xsl:attribute>							
						</xsl:if>
						<xsl:variable name="title-table">
							<xsl:call-template name="getTitle">
								<xsl:with-param name="name" select="'title-table'"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:value-of select="$title-table"/>
						
						<xsl:call-template name="getTableNumber"/>

						
						<xsl:if test="*[local-name()='name']">
							<xsl:if test="$namespace = 'unece-rec'"><xsl:text>. </xsl:text></xsl:if>
							<xsl:if test="$namespace = 'unece'">: </xsl:if>
							<xsl:if test="$namespace = 'iso' or $namespace = 'iec' or $namespace = 'itu' or  $namespace = 'nist' or $namespace = 'csd' or $namespace = 'ogc' or $namespace = 'gb' or $namespace = 'm3d' or $namespace = 'iho'">
								<xsl:text> — </xsl:text>
							</xsl:if>
							<xsl:apply-templates select="*[local-name()='name']" mode="process"/>
						</xsl:if>
					</fo:block>
				</xsl:if>
				<xsl:if test="$namespace = 'iso' or $namespace = 'iec' or $namespace = 'itu' or  $namespace = 'unece-rec' or $namespace = 'unece' or $namespace = 'csd' or $namespace = 'ogc' or $namespace = 'gb' or $namespace = 'm3d' or $namespace = 'iho'">
					<xsl:call-template name="fn_name_display"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
		
		<xsl:variable name="cols-count" select="count(xalan:nodeset($simple-table)//tr[1]/td)"/>
		
		<!-- <xsl:variable name="cols-count">
			<xsl:choose>
				<xsl:when test="*[local-name()='thead']">
					<xsl:call-template name="calculate-columns-numbers">
						<xsl:with-param name="table-row" select="*[local-name()='thead']/*[local-name()='tr'][1]"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="calculate-columns-numbers">
						<xsl:with-param name="table-row" select="*[local-name()='tbody']/*[local-name()='tr'][1]"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable> -->
		<!-- cols-count=<xsl:copy-of select="$cols-count"/> -->
		<!-- cols-count2=<xsl:copy-of select="$cols-count2"/> -->
		
		
		
		<xsl:variable name="colwidths">
			<xsl:call-template name="calculate-column-widths">
				<xsl:with-param name="cols-count" select="$cols-count"/>
				<xsl:with-param name="table" select="$simple-table"/>
			</xsl:call-template>
		</xsl:variable>
		
		<!-- <xsl:variable name="colwidths2">
			<xsl:call-template name="calculate-column-widths">
				<xsl:with-param name="cols-count" select="$cols-count"/>
			</xsl:call-template>
		</xsl:variable> -->
		
		<!-- cols-count=<xsl:copy-of select="$cols-count"/>
		colwidthsNew=<xsl:copy-of select="$colwidths"/>
		colwidthsOld=<xsl:copy-of select="$colwidths2"/>z -->
		
		<xsl:variable name="margin-left">
			<xsl:choose>
				<xsl:when test="sum(xalan:nodeset($colwidths)//column) &gt; 75">15</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<fo:block-container margin-left="-{$margin-left}mm" margin-right="-{$margin-left}mm">			
			<xsl:if test="$namespace = 'itu' or $namespace = 'nist'">
				<xsl:attribute name="space-after">6pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="$namespace = 'iec'">
				<xsl:attribute name="space-after">12pt</xsl:attribute>
				<xsl:if test="ancestor::*[local-name() = 'preface']">
					<xsl:attribute name="space-after">16pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$namespace = 'unece-rec'">
				<xsl:attribute name="space-after">12pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="$namespace = 'unece'">
				<xsl:attribute name="space-after">18pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="$namespace = 'itu'">
				<xsl:attribute name="margin-left">0mm</xsl:attribute>
				<xsl:attribute name="margin-right">0mm</xsl:attribute>
				<xsl:attribute name="space-after">18pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="$namespace = 'ogc'">
				<xsl:attribute name="margin-left">0mm</xsl:attribute>
				<xsl:attribute name="margin-right">0mm</xsl:attribute>
				<xsl:attribute name="space-after">12pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="$namespace = 'iso'">
				<xsl:attribute name="margin-left">0mm</xsl:attribute>
				<xsl:attribute name="margin-right">0mm</xsl:attribute>
				<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="$namespace = 'iho'">
				<xsl:attribute name="space-after">18pt</xsl:attribute>
				<xsl:attribute name="margin-left">0mm</xsl:attribute>
				<xsl:attribute name="margin-right">0mm</xsl:attribute>
			</xsl:if>
			<fo:table id="{@id}" table-layout="fixed" width="100%" margin-left="{$margin-left}mm" margin-right="{$margin-left}mm" table-omit-footer-at-break="true">
				<xsl:if test="$namespace = 'iso'">
					<xsl:attribute name="border">1.5pt solid black</xsl:attribute>
					<xsl:if test="*[local-name()='thead']">
						<xsl:attribute name="border-top">1pt solid black</xsl:attribute>
					</xsl:if>
				</xsl:if>
				<xsl:if test="$namespace = 'iec'">
					<xsl:attribute name="border">0.5pt solid black</xsl:attribute>
				</xsl:if>
				<xsl:if test="$namespace = 'itu'">
					<xsl:attribute name="margin-left">0mm</xsl:attribute>
					<xsl:attribute name="margin-right">0mm</xsl:attribute>
				</xsl:if>
				<xsl:if test="$namespace = 'iso'">
					<xsl:attribute name="margin-left">0mm</xsl:attribute>
					<xsl:attribute name="margin-right">0mm</xsl:attribute>
				</xsl:if>
				<xsl:if test="$namespace = 'ogc'">
					<xsl:attribute name="margin-left">0mm</xsl:attribute>
					<xsl:attribute name="margin-right">0mm</xsl:attribute>
				</xsl:if>
				<xsl:if test="$namespace = 'nist'">
					<xsl:if test="ancestor::*[local-name()='annex'] or ancestor::*[local-name()='preface']">
						<xsl:attribute name="font-family">Times New Roman</xsl:attribute>
						<xsl:attribute name="font-size">10pt</xsl:attribute>
					</xsl:if>
					<xsl:if test="not(ancestor::*[local-name()='annex'] or ancestor::*[local-name()='preface'])">
						<xsl:attribute name="font-family">Times New Roman</xsl:attribute>
						<xsl:attribute name="font-size">12pt</xsl:attribute>
					</xsl:if>
					<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
				</xsl:if>
				<xsl:if test="$namespace = 'unece-rec'">
					<xsl:if test="ancestor::*[local-name()='sections']">
						<xsl:attribute name="border-top">1.5pt solid black</xsl:attribute>
						<xsl:attribute name="border-bottom">1.5pt solid black</xsl:attribute>
					</xsl:if>
					<xsl:if test="not(ancestor::*[local-name()='sections'])">
						<xsl:attribute name="font-size">10pt</xsl:attribute>
					</xsl:if>
				</xsl:if>
				<xsl:if test="$namespace = 'unece'">
					<xsl:attribute name="border-top">0.5pt solid black</xsl:attribute>
					<xsl:attribute name="font-size">8pt</xsl:attribute>
				</xsl:if>
				<xsl:if test="$namespace = 'iso' or $namespace = 'itu' or $namespace = 'csd' or $namespace = 'ogc' or $namespace = 'gb'">
					<xsl:attribute name="font-size">10pt</xsl:attribute>
				</xsl:if>
				<xsl:if test="$namespace = 'iec'">
					<!-- <xsl:if test="ancestor::*[local-name()='preface']"> -->
					<xsl:attribute name="font-size">8pt</xsl:attribute>
				</xsl:if>
				<xsl:if test="$namespace = 'iho'">				
					<xsl:attribute name="margin-left">0mm</xsl:attribute>
					<xsl:attribute name="margin-right">0mm</xsl:attribute>
				</xsl:if>
				<xsl:for-each select="xalan:nodeset($colwidths)//column">
					<xsl:choose>
						<xsl:when test=". = 1 or . = 0">
							<fo:table-column column-width="proportional-column-width(2)"/>
						</xsl:when>
						<xsl:otherwise>
							<fo:table-column column-width="proportional-column-width({.})"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
				
				<xsl:choose>
					<xsl:when test="not(*[local-name()='tbody']) and *[local-name()='thead']">
						<xsl:apply-templates select="*[local-name()='thead']" mode="process_tbody"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates />
					</xsl:otherwise>
				</xsl:choose>
				
			</fo:table>
			
			<xsl:if test="$namespace = 'gb'">
				<xsl:apply-templates select="*[local-name()='note']" mode="process"/>
			</xsl:if>
			
		</fo:block-container>
	</xsl:template>

	
	<xsl:template name="getTableNumber">
		<xsl:choose>
			<xsl:when test="ancestor::*[local-name()='executivesummary']"> <!-- NIST -->
				<xsl:text>ES-</xsl:text><xsl:number format="1" count="*[local-name()='executivesummary']//*[local-name()='table'][not(@unnumbered) or @unnumbered != 'true']"/>
			</xsl:when>
			<xsl:when test="ancestor::*[local-name()='annex']">
				<xsl:if test="$namespace = 'iso'">
					<xsl:variable name="annex-id" select="ancestor::*[local-name()='annex']/@id"/>
					<xsl:number format="A." count="*[local-name()='annex']"/><xsl:number format="1" level="any" count="*[local-name()='table'][(not(@unnumbered) or @unnumbered != 'true') and ancestor::*[local-name()='annex'][@id = $annex-id]]"/>
				</xsl:if>
				<xsl:if test="$namespace = 'gb'">
					<xsl:variable name="annex-id" select="ancestor::gb:annex/@id"/>
					<xsl:number format="A." count="*[local-name()='annex']"/><xsl:number format="1" level="any" count="*[local-name()='table'][(not(@unnumbered) or @unnumbered != 'true') and ancestor::gb:annex[@id = $annex-id]]"/>
				</xsl:if>
				<xsl:if test="$namespace = 'iec' or $namespace = 'ogc'">
					<xsl:number format="A." count="*[local-name()='annex']"/><xsl:number format="1"/>
				</xsl:if>
				<xsl:if test="$namespace = 'itu'">
					<xsl:choose>
						<xsl:when test="ancestor::*[local-name()='annex'][@obligation = 'informative']">
							<xsl:variable name="annex-id" select="ancestor::*[local-name()='annex']/@id"/>
							<!-- Table in Appendix -->
							<xsl:number format="I-" count="*[local-name()='annex'][@obligation = 'informative']"/>
							<xsl:number format="1" level="any" count="*[local-name()='table'][(not(@unnumbered) or @unnumbered != 'true') and ancestor::*[local-name()='annex'][@id = $annex-id]]"/>
						</xsl:when>
						<!-- Table in Annex -->
						<xsl:when test="ancestor::*[local-name()='annex'][not(@obligation) or @obligation != 'informative']">
							<xsl:variable name="annex-id" select="ancestor::*[local-name()='annex']/@id"/>
							<xsl:number format="A-" count="*[local-name()='annex'][not(@obligation) or @obligation != 'informative']"/>
							<xsl:number format="1" level="any" count="*[local-name()='table'][(not(@unnumbered) or @unnumbered != 'true') and ancestor::*[local-name()='annex'][@id = $annex-id]]"/>
						</xsl:when>
					</xsl:choose>
				</xsl:if>
				<xsl:if test="$namespace = 'nist'">
					<xsl:variable name="annex-id" select="ancestor::*[local-name()='annex']/@id"/>
					<xsl:number format="A-" count="*[local-name()='annex']"/>
					<xsl:number format="1" level="any" count="*[local-name()='table'][not(@unnumbered) or @unnumbered != 'true'][ancestor::*[local-name()='annex'][@id = $annex-id]]"/>
				</xsl:if>
				<xsl:if test="$namespace = 'unece-rec'">
					<!-- <xsl:variable name="annex-id" select="ancestor::*[local-name()='annex']/@id"/>
					<xsl:number format="I." count="*[local-name()='annex']"/> -->
					<xsl:text>A</xsl:text> <!-- 'A' means Annex -->
					<xsl:number format="1" level="any" count="*[local-name()='table'][not(@unnumbered) or @unnumbered != 'true'][ancestor::*[local-name()='annex']]"/> <!-- [@id = $annex-id] -->
				</xsl:if>
				<xsl:if test="$namespace = 'unece'">
					<xsl:variable name="annex-id" select="ancestor::*[local-name()='annex']/@id"/>
					<xsl:number format="I." count="*[local-name()='annex']"/>
					<xsl:number format="1" level="any" count="*[local-name()='table'][not(@unnumbered) or @unnumbered != 'true'][ancestor::*[local-name()='annex'][@id = $annex-id]]"/>
				</xsl:if>
				<xsl:if test="$namespace = 'csd'">
					<xsl:number format="A-1" level="multiple" count="*[local-name()='annex'] | *[local-name()='table'][not(@unnumbered) or @unnumbered != 'true'] "/>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$namespace = 'iec'">
					<xsl:number format="1" level="any" count="//*[local-name()='table']
																																		[not(ancestor::*[local-name()='annex']) 
																																		and not(ancestor::*[local-name()='executivesummary'])
																																		and not(ancestor::*[local-name()='bibdata'])
																																		and not(ancestor::*[local-name()='preface'])]
																																		[not(@unnumbered) or @unnumbered != 'true']"/>
				</xsl:if>
				<xsl:if test="$namespace = 'iso' or $namespace = 'itu' or $namespace = 'nist' or $namespace = 'csd' or $namespace = 'ogc' or $namespace = 'unece' or $namespace = 'unece-rec' $namespace = 'gb' or $namespace = 'm3d' or $namespace = 'iho'">
					<xsl:number format="A." count="*[local-name()='annex']"/>
					<xsl:number format="1" level="any" count="//*[local-name()='table']
																																						[not(ancestor::*[local-name()='annex']) 
																																						and not(ancestor::*[local-name()='executivesummary'])
																																						and not(ancestor::*[local-name()='bibdata'])]
																																						[not(@unnumbered) or @unnumbered != 'true']"/>
					</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*[local-name()='table']/*[local-name()='name']"/>
	<xsl:template match="*[local-name()='table']/*[local-name()='name']" mode="process">
		<xsl:apply-templates />
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
		<xsl:param name="curr-col" select="1"/>
		<xsl:param name="width" select="0"/>
		
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
						<xsl:for-each select="xalan:nodeset($table)//tr">
							<xsl:variable name="td_text">
								<xsl:apply-templates select="td[$curr-col]" mode="td_text"/>
							</xsl:variable>
							<xsl:variable name="words">
								<xsl:variable name="string_with_added_zerospaces">
									<xsl:call-template name="add-zero-spaces-java">
										<xsl:with-param name="text" select="$td_text"/>
									</xsl:call-template>
								</xsl:variable>
								<xsl:call-template name="tokenize">
									<!-- <xsl:with-param name="text" select="translate(td[$curr-col],'- —:', '    ')"/> -->
									<!-- 2009 thinspace -->
									<!-- <xsl:with-param name="text" select="translate(normalize-space($td_text),'- —:', '    ')"/> -->
									<xsl:with-param name="text" select="normalize-space(translate($string_with_added_zerospaces, '&#x200B;', ' '))"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:variable name="max_length">
								<xsl:call-template name="max_length">
									<xsl:with-param name="words" select="xalan:nodeset($words)"/>
								</xsl:call-template>
							</xsl:variable>
							<width>
								<xsl:variable name="divider">
									<xsl:choose>
										<xsl:when test="td[$curr-col]/@divide">
											<xsl:value-of select="td[$curr-col]/@divide"/>
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

			
			<column>
				<xsl:for-each select="xalan:nodeset($widths)//width">
					<xsl:sort select="." data-type="number" order="descending"/>
					<xsl:if test="position()=1">
							<xsl:value-of select="."/>
					</xsl:if>
				</xsl:for-each>
			</column>
			<xsl:call-template name="calculate-column-widths">
				<xsl:with-param name="cols-count" select="$cols-count"/>
				<xsl:with-param name="curr-col" select="$curr-col +1"/>
				<xsl:with-param name="table" select="$table"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="text()" mode="td_text">
		<xsl:variable name="zero-space">&#x200B;</xsl:variable>
		<xsl:value-of select="translate(., $zero-space, ' ')"/><xsl:text> </xsl:text>
	</xsl:template>
	
	<xsl:template match="*[local-name()='termsource']" mode="td_text">
		<xsl:value-of select="*[local-name()='origin']/@citeas"/>
	</xsl:template>
	
	<xsl:template match="*[local-name()='link']" mode="td_text">
		<xsl:value-of select="@target"/>
	</xsl:template>

	
	<!-- for debug purpose only -->
	<xsl:template match="*[local-name()='table2']"/>
	
	<xsl:template match="*[local-name()='thead']"/>

	<xsl:template match="*[local-name()='thead']" mode="process">
		<xsl:param name="cols-count"/>
		<!-- font-weight="bold" -->
		<fo:table-header>			
			<xsl:if test="$namespace = 'iso'">
				<fo:table-row>
					<fo:table-cell number-columns-spanned="{$cols-count}"> <!-- border-left="1pt solid white" border-right="1pt solid white" border-top="1pt solid white" -->
						<fo:block text-align="center" font-size="11pt" font-weight="bold">
							<!-- (continued) -->
							<fo:block-container position="absolute" top="-7mm">
								<fo:block>
									<fo:retrieve-table-marker retrieve-class-name="table_continued" 
										retrieve-position-within-table="first-starting" 
										retrieve-boundary-within-table="table-fragment"/>
								</fo:block>
							</fo:block-container>
							
						</fo:block>
						<!-- <fo:block>fn_name_display
							<xsl:call-template name="fn_name_display"/>
						</fo:block> -->
						
					</fo:table-cell>
				</fo:table-row>
			</xsl:if>
			<xsl:apply-templates />
		</fo:table-header>
	</xsl:template>
	
	<xsl:template match="*[local-name()='thead']" mode="process_tbody">		
		<fo:table-body>
			<xsl:apply-templates />
		</fo:table-body>
	</xsl:template>
	
	<xsl:template match="*[local-name()='tfoot']"/>

	<xsl:template match="*[local-name()='tfoot']" mode="process">
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template name="insertTableFooter">
		<xsl:param name="cols-count" />
		<xsl:variable name="isNoteOrFnExist" select="../*[local-name()='note'] or ..//*[local-name()='fn'][local-name(..) != 'name']"/>
		<xsl:if test="../*[local-name()='tfoot'] or
										$isNoteOrFnExist = 'true'">
		
			<fo:table-footer>
			
				<xsl:apply-templates select="../*[local-name()='tfoot']" mode="process"/>
				
				<!-- if there are note(s) or fn(s) then create footer row -->
				<xsl:if test="$isNoteOrFnExist = 'true'">
				
					
				
					<fo:table-row>
						<fo:table-cell border="solid black 1pt" padding-left="1mm" padding-right="1mm" padding-top="1mm" number-columns-spanned="{$cols-count}">
							<xsl:if test="$namespace = 'iso' or $namespace = 'gb'">
								<xsl:attribute name="border-top">solid black 0pt</xsl:attribute>
							</xsl:if>
							<xsl:if test="$namespace = 'iec'">
								<xsl:attribute name="border">solid black 0.5pt</xsl:attribute>
							</xsl:if>
							<xsl:if test="$namespace = 'itu'">
								<xsl:if test="ancestor::*[local-name()='preface']">
									<xsl:attribute name="border">solid black 0pt</xsl:attribute>
								</xsl:if>
							</xsl:if>
							<!-- fn will be processed inside 'note' processing -->
							<xsl:if test="$namespace = 'iec'">
								<xsl:if test="../*[local-name()='note']">
									<fo:block margin-bottom="6pt">&#xA0;</fo:block>
								</xsl:if>
							</xsl:if>
							
							<!-- except gb -->
							<xsl:if test="$namespace = 'iso' or $namespace = 'iec' or $namespace = 'itu' or $namespace = 'unece' or $namespace = 'unece-rec' or $namespace = 'nist' or $namespace = 'ogc' or $namespace = 'rsd' or $namespace = 'csa' or $namespace = 'csd' or $namespace = 'm3d' or $namespace = 'iho'">
								<xsl:apply-templates select="../*[local-name()='note']" mode="process"/>
							</xsl:if>
							
							<!-- horizontal row separator -->
							<xsl:if test="$namespace = 'iec'">
								<xsl:if test="../*[local-name()='note']">
									<fo:block-container border-top="0.5pt solid black" padding-left="1mm" padding-right="1mm">
										<fo:block font-size="1pt">&#xA0;</fo:block>
									</fo:block-container>
								</xsl:if>
							</xsl:if>
							
							<!-- fn processing -->
							<xsl:call-template name="fn_display" />
							
						</fo:table-cell>
					</fo:table-row>
					
				</xsl:if>
			</fo:table-footer>
		
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="*[local-name()='tbody']">
		
		<xsl:variable name="cols-count">
			<xsl:choose>
				<xsl:when test="../*[local-name()='thead']">					
					<xsl:call-template name="calculate-columns-numbers">
						<xsl:with-param name="table-row" select="../*[local-name()='thead']/*[local-name()='tr'][1]"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>					
					<xsl:call-template name="calculate-columns-numbers">
						<xsl:with-param name="table-row" select="./*[local-name()='tr'][1]"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:apply-templates select="../*[local-name()='thead']" mode="process">
			<xsl:with-param name="cols-count" select="$cols-count"/>
		</xsl:apply-templates>
		
		<xsl:call-template name="insertTableFooter">
			<xsl:with-param name="cols-count" select="$cols-count"/>
		</xsl:call-template>
		
		<fo:table-body>
			<xsl:apply-templates />
			<!-- <xsl:apply-templates select="../*[local-name()='tfoot']" mode="process"/> -->
		
		</fo:table-body>
		
	</xsl:template>
	
<!--	
	<xsl:template match="*[local-name()='thead']/*[local-name()='tr']">
		<fo:table-row font-weight="bold" min-height="4mm" >
			<xsl:apply-templates />
		</fo:table-row>
	</xsl:template> -->
	
	<xsl:template match="*[local-name()='tr']">
		<xsl:variable name="parent-name" select="local-name(..)"/>
		<!-- <xsl:variable name="namespace" select="substring-before(name(/*), '-')"/> -->
		<fo:table-row min-height="4mm">
				<xsl:if test="$parent-name = 'thead'">
					<xsl:attribute name="font-weight">bold</xsl:attribute>
					<xsl:if test="$namespace = 'nist'">
						<xsl:attribute name="font-family">Arial</xsl:attribute>
						<xsl:attribute name="font-size">10pt</xsl:attribute>
					</xsl:if>
					
					<xsl:if test="$namespace = 'iso'">
						<xsl:choose>
							<xsl:when test="position() = 1">
								<xsl:attribute name="border-top">solid black 1.5pt</xsl:attribute>
								<xsl:attribute name="border-bottom">solid black 1pt</xsl:attribute>
							</xsl:when>
							<xsl:when test="position() = last()">
								<xsl:attribute name="border-top">solid black 1pt</xsl:attribute>
								<xsl:attribute name="border-bottom">solid black 1.5pt</xsl:attribute>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="border-top">solid black 1pt</xsl:attribute>
								<xsl:attribute name="border-bottom">solid black 1pt</xsl:attribute>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
					<xsl:if test="$namespace = 'iec'">
						<xsl:attribute name="border-top">solid black 0.5pt</xsl:attribute>
						<xsl:attribute name="border-bottom">solid black 0.5pt</xsl:attribute>
					</xsl:if>
					
				</xsl:if>
				<xsl:if test="$parent-name = 'tfoot'">
					<xsl:if test="$namespace = 'iso'">
						<xsl:attribute name="font-size">9pt</xsl:attribute>
						<xsl:attribute name="border-left">solid black 1pt</xsl:attribute>
						<xsl:attribute name="border-right">solid black 1pt</xsl:attribute>
					</xsl:if>
					<xsl:if test="$namespace = 'iec'">
						<xsl:attribute name="border-left">solid black 0.5pt</xsl:attribute>
						<xsl:attribute name="border-right">solid black 0.5pt</xsl:attribute>
					</xsl:if>
				</xsl:if>
				<xsl:if test="$namespace = 'gb'">
					<xsl:attribute name="min-height">0mm</xsl:attribute>
					<xsl:attribute name="line-height">110%</xsl:attribute>
				</xsl:if>
				<xsl:if test="$namespace = 'unece'">
					<xsl:if test="not(*[local-name()='th'])">
						<xsl:attribute name="min-height">8mm</xsl:attribute>
					</xsl:if>
				</xsl:if>
			<xsl:apply-templates />
		</fo:table-row>
	</xsl:template>
	

	<xsl:template match="*[local-name()='th']">
		<fo:table-cell text-align="{@align}" font-weight="bold" border="solid black 1pt" padding-left="1mm" display-align="center">
			<xsl:if test="$namespace = 'iso' or $namespace = 'iec'">
				<xsl:attribute name="padding-top">1mm</xsl:attribute>
			</xsl:if>
			<xsl:if test="$namespace = 'iec'">
				<xsl:attribute name="border">solid black 0.5pt</xsl:attribute>
				<xsl:if test="ancestor::*[local-name()='preface']">
					<xsl:attribute name="font-weight">normal</xsl:attribute>
				</xsl:if>
				<xsl:attribute name="text-align">center</xsl:attribute>
			</xsl:if>
			<xsl:if test="$namespace = 'itu'">
				<xsl:if test="ancestor::*[local-name()='preface']">
					<xsl:attribute name="border">solid black 0pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$namespace = 'nist'">
				<xsl:attribute name="text-align">center</xsl:attribute>
				<xsl:attribute name="background-color">black</xsl:attribute>
				<xsl:attribute name="color">white</xsl:attribute>
			</xsl:if>
			<xsl:if test="$namespace = 'unece-rec'">
				<xsl:if test="ancestor::*[local-name()='sections']">
					<xsl:attribute name="border">solid black 0pt</xsl:attribute>
					<xsl:attribute name="display-align">before</xsl:attribute>
					<xsl:attribute name="padding-top">1mm</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$namespace = 'unece-rec'">
				<xsl:if test="ancestor::*[local-name()='annex']">
					<xsl:attribute name="font-weight">normal</xsl:attribute>
					<xsl:attribute name="padding-top">1mm</xsl:attribute>
					<xsl:attribute name="background-color">rgb(218, 218, 218)</xsl:attribute>
					<xsl:if test="starts-with(text(), '1') or starts-with(text(), '2') or starts-with(text(), '3') or starts-with(text(), '4') or starts-with(text(), '5') or
						starts-with(text(), '6') or starts-with(text(), '7') or starts-with(text(), '8') or starts-with(text(), '9')">
						<xsl:attribute name="color">rgb(46, 116, 182)</xsl:attribute>
						<xsl:attribute name="font-weight">bold</xsl:attribute>
					</xsl:if>
				</xsl:if>
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
			</xsl:if>
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
			<fo:block>
				<xsl:apply-templates />
			</fo:block>
		</fo:table-cell>
	</xsl:template>
	
	
	<xsl:template match="*[local-name()='td']">
		<fo:table-cell text-align="{@align}" display-align="center" border="solid black 1pt" padding-left="1mm">
			<xsl:if test="$namespace = 'iso' or $namespace = 'iec' or $namespace = 'iho'"> <!--  and ancestor::*[local-name() = 'thead'] -->
				<xsl:attribute name="padding-top">0.5mm</xsl:attribute>
			</xsl:if>
			<xsl:if test="$namespace = 'itu'">
				<xsl:if test="ancestor::*[local-name()='preface']">
					<xsl:attribute name="border">solid black 0pt</xsl:attribute>
				</xsl:if>
				<xsl:attribute name="display-align">before</xsl:attribute>
			</xsl:if>
			<xsl:if test="$namespace = 'iso' or $namespace = 'iec'">
				<xsl:if test="ancestor::*[local-name() = 'tfoot']">
					<xsl:attribute name="border">solid black 0</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$namespace = 'gb'">
				<xsl:if test="ancestor::*[local-name() = 'tfoot']">
					<xsl:attribute name="border-bottom">solid black 0</xsl:attribute>
				</xsl:if>
			</xsl:if>
			
			<xsl:if test="$namespace = 'iec'">
				<xsl:attribute name="border">solid black 0.5pt</xsl:attribute>
				<xsl:if test="ancestor::*[local-name()='preface']">
					<xsl:attribute name="text-align">center</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$namespace = 'unece-rec'">
				<xsl:if test="ancestor::*[local-name()='sections']">
					<xsl:attribute name="border">solid black 0pt</xsl:attribute>
					<xsl:attribute name="padding-top">1mm</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$namespace = 'unece'">
				<xsl:attribute name="display-align">before</xsl:attribute>
				<xsl:attribute name="padding-left">0mm</xsl:attribute>
				<xsl:attribute name="padding-top">2mm</xsl:attribute>
				<xsl:attribute name="padding-bottom">1mm</xsl:attribute>
				<xsl:attribute name="border">solid black 0pt</xsl:attribute>
				<xsl:attribute name="border-bottom">solid black 1.5pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="$namespace = 'nist'">
				<xsl:if test="ancestor::*[local-name()='thead']">
					<xsl:attribute name="font-weight">normal</xsl:attribute>
				</xsl:if>
			</xsl:if>
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
			<fo:block>
				<xsl:if test="$namespace = 'iso'">
					<xsl:variable name="row_number">
						<xsl:number format="1" count="*[local-name() = 'tr'] | *[local-name() = 'th']"/>
					</xsl:variable>
					<fo:marker marker-class-name="table_continued">						
						<xsl:if test="$row_number &gt; 1">
								<fo:inline>
									<xsl:variable name="title-table">
										<xsl:call-template name="getTitle">
											<xsl:with-param name="name" select="'title-table'"/>
										</xsl:call-template>
									</xsl:variable>
									<xsl:value-of select="$title-table"/>									
									<xsl:call-template name="getTableNumber"/>
									<xsl:text> </xsl:text>
									<fo:inline font-style="italic" font-weight="normal">(continued)</fo:inline>
								</fo:inline>
						</xsl:if>
					</fo:marker>
				</xsl:if>				
				<xsl:apply-templates />
			</fo:block>
			<!-- <xsl:choose>
				<xsl:when test="count(*) = 1 and *[local-name() = 'p']">
					<xsl:apply-templates />
				</xsl:when>
				<xsl:otherwise>
					<fo:block>
						<xsl:apply-templates />
					</fo:block>
				</xsl:otherwise>
			</xsl:choose> -->
			
			
		</fo:table-cell>
	</xsl:template>
	
	
	<xsl:template match="*[local-name()='table']/*[local-name()='note']"/>
	<xsl:template match="*[local-name()='table']/*[local-name()='note']" mode="process">
		
		
			<fo:block font-size="10pt" margin-bottom="12pt">
				<xsl:if test="$namespace = 'iso'">
					<xsl:attribute name="font-size">9pt</xsl:attribute>
					<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
				</xsl:if>
				<xsl:if test="$namespace = 'gb'">
					<xsl:attribute name="font-size">9pt</xsl:attribute>
					<xsl:attribute name="text-align">center</xsl:attribute>
					<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
				</xsl:if>
				<xsl:if test="$namespace = 'iec'">
					<xsl:attribute name="font-size">8pt</xsl:attribute>
					<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
				</xsl:if>
				<xsl:if test="$namespace = 'iho'">
					<xsl:attribute name="font-size">12pt</xsl:attribute>					
				</xsl:if>
				<fo:inline padding-right="2mm">
					<xsl:if test="$namespace = 'gb'">
						<xsl:attribute name="font-family">SimHei</xsl:attribute>
					</xsl:if>
					<xsl:if test="$namespace = 'iho'">
						<xsl:attribute name="font-size">11pt</xsl:attribute>					
					</xsl:if>
					<xsl:if test="$namespace = 'unece'  or $namespace = 'unece-rec'">
						<xsl:if test="@type = 'source' or @type = 'abbreviation'">
							<xsl:attribute name="font-size">9pt</xsl:attribute>							
							<fo:inline>
								<xsl:call-template name="capitalize">
									<xsl:with-param name="str" select="@type"/>
								</xsl:call-template>
								<xsl:text>: </xsl:text>
							</fo:inline>
						</xsl:if>
					</xsl:if>
				
					<xsl:apply-templates select="*[local-name() = 'name']" mode="presentation"/>
						
				</fo:inline>
				<xsl:apply-templates mode="process"/>
			</fo:block>
		
	</xsl:template>
	
	<xsl:template match="*[local-name()='table']/*[local-name()='note']/*[local-name()='name']" mode="process"/><!-- commended, because processed in mode="presentation" -->
	
	<xsl:template match="*[local-name()='table']/*[local-name()='note']/*[local-name()='p']" mode="process">
		<xsl:apply-templates/>
	</xsl:template>
	
	
	<xsl:template name="fn_display">
		<xsl:variable name="references">
			<xsl:for-each select="..//*[local-name()='fn'][local-name(..) != 'name']">
				<fn reference="{@reference}" id="{@reference}_{ancestor::*[@id][1]/@id}">
					<xsl:if test="$namespace = 'itu'">
						<xsl:if test="ancestor::*[local-name()='preface']">
							<xsl:attribute name="preface">true</xsl:attribute>
						</xsl:if>
					</xsl:if>
					<xsl:if test="$namespace = 'ogc'">
						<xsl:attribute name="id">
							<xsl:value-of select="@reference"/>
							<xsl:text>_</xsl:text>
							<xsl:value-of select="ancestor::*[local-name()='table'][1]/@id"/>
						</xsl:attribute>
					</xsl:if>
					<xsl:apply-templates />
				</fn>
			</xsl:for-each>
		</xsl:variable>
		<xsl:for-each select="xalan:nodeset($references)//fn">
			<xsl:variable name="reference" select="@reference"/>
			<xsl:if test="not(preceding-sibling::*[@reference = $reference])"> <!-- only unique reference puts in note-->
				<fo:block margin-bottom="12pt">
					<xsl:if test="$namespace = 'iso'">
						<xsl:attribute name="font-size">9pt</xsl:attribute>
						<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
					</xsl:if>
					<xsl:if test="$namespace = 'gb'">
						<xsl:attribute name="text-indent">7.4mm</xsl:attribute>
						<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
						<xsl:attribute name="line-height">130%</xsl:attribute>
					</xsl:if>
					<xsl:if test="$namespace = 'iec'">
						<xsl:attribute name="font-size">8pt</xsl:attribute>
						<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
						<xsl:attribute name="text-indent">-6mm</xsl:attribute>
						<xsl:attribute name="margin-left">6mm</xsl:attribute>
					</xsl:if>
					<xsl:if test="$namespace = 'itu'">
						<xsl:attribute name="margin-bottom">2pt</xsl:attribute>
						<xsl:attribute name="line-height-shift-adjustment">disregard-shifts</xsl:attribute>
						<xsl:attribute name="text-indent">-5mm</xsl:attribute>
						<xsl:attribute name="start-indent">5mm</xsl:attribute>
					</xsl:if>
					<fo:inline font-size="80%" padding-right="5mm" id="{@id}">
						<xsl:if test="$namespace = 'itu' or  $namespace = 'nist' or $namespace = 'unece' or $namespace = 'unece-rec'  or $namespace = 'csd' or $namespace = 'ogc' or $namespace = 'gb' or $namespace = 'm3d' or $namespace = 'iho'">
							<xsl:attribute name="vertical-align">super</xsl:attribute>
						</xsl:if>
						<xsl:if test="$namespace = 'iso'">
							<xsl:attribute name="alignment-baseline">hanging</xsl:attribute>
						</xsl:if>
						<xsl:if test="$namespace = 'iec'">
							<xsl:attribute name="baseline-shift">30%</xsl:attribute>
							<xsl:attribute name="font-size">70%</xsl:attribute>
						</xsl:if>
						<xsl:if test="$namespace = 'gb'">
							<xsl:attribute name="font-size">50%</xsl:attribute>							
						</xsl:if>
						<xsl:if test="$namespace = 'itu'">
							<xsl:attribute name="padding-right">3mm</xsl:attribute>
							<xsl:attribute name="font-size">70%</xsl:attribute>
						</xsl:if>
						<xsl:if test="$namespace = 'nist'">
							<xsl:attribute name="font-size">10pt</xsl:attribute>
						</xsl:if>
						<xsl:value-of select="@reference"/>
						<xsl:if test="$namespace = 'itu'">
							<!-- <xsl:if test="@preface = 'true'"> -->
								<xsl:text>)</xsl:text>
							<!-- </xsl:if> -->
						</xsl:if>
					</fo:inline>
					<fo:inline>
						<xsl:if test="$namespace = 'nist'">
							<xsl:attribute name="font-size">10pt</xsl:attribute>
						</xsl:if>
						<xsl:apply-templates />
					</fo:inline>
				</fo:block>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template name="fn_name_display">
		<!-- <xsl:variable name="references">
			<xsl:for-each select="*[local-name()='name']//*[local-name()='fn']">
				<fn reference="{@reference}" id="{@reference}_{ancestor::*[@id][1]/@id}">
					<xsl:apply-templates />
				</fn>
			</xsl:for-each>
		</xsl:variable>
		$references=<xsl:copy-of select="$references"/> -->
		<xsl:for-each select="*[local-name()='name']//*[local-name()='fn']">
			<xsl:variable name="reference" select="@reference"/>
			<fo:block id="{@reference}_{ancestor::*[@id][1]/@id}"><xsl:value-of select="@reference"/></fo:block>
			<fo:block margin-bottom="12pt">
				<xsl:apply-templates />
			</fo:block>
		</xsl:for-each>
	</xsl:template>
	
	
	<xsl:template name="fn_display_figure">
		<xsl:variable name="key_iso">
			<xsl:if test="$namespace = 'iso' or $namespace = 'iec'  or $namespace = 'gb'">true</xsl:if> <!-- and (not(@class) or @class !='pseudocode') -->
		</xsl:variable>
		<xsl:variable name="references">
			<xsl:for-each select=".//*[local-name()='fn']">
				<fn reference="{@reference}" id="{@reference}_{ancestor::*[@id][1]/@id}">
					<xsl:apply-templates />
				</fn>
			</xsl:for-each>
		</xsl:variable>
		
		<!-- current hierarchy is 'figure' element -->
		<xsl:variable name="following_dl_colwidths">
			<xsl:if test="*[local-name() = 'dl']"><!-- if there is a 'dl', then set the same columns width as for 'dl' -->
				<xsl:variable name="html-table">
					<xsl:variable name="ns" select="substring-before(name(/*), '-')"/>
					<xsl:element name="{$ns}:table">
						<xsl:for-each select="*[local-name() = 'dl'][1]">
							<tbody>
								<xsl:apply-templates mode="dl"/>
							</tbody>
						</xsl:for-each>
					</xsl:element>
				</xsl:variable>
				
				<xsl:call-template name="calculate-column-widths">
					<xsl:with-param name="cols-count" select="2"/>
					<xsl:with-param name="table" select="$html-table"/>
				</xsl:call-template>
				
			</xsl:if>
		</xsl:variable>
		
		
		<xsl:variable name="maxlength_dt">
			<xsl:for-each select="*[local-name() = 'dl'][1]">
				<xsl:call-template name="getMaxLength_dt"/>			
			</xsl:for-each>
		</xsl:variable>
		
		<xsl:if test="xalan:nodeset($references)//fn">
			<fo:block>
				<fo:table width="95%" table-layout="fixed">
					<xsl:if test="normalize-space($key_iso) = 'true'">
						<xsl:attribute name="font-size">10pt</xsl:attribute>
						<xsl:if test="$namespace = 'iec'">
							<xsl:attribute name="font-size">8pt</xsl:attribute>
						</xsl:if>
					</xsl:if>
					<xsl:choose>
						<!-- if there 'dl', then set same columns width -->
						<xsl:when test="xalan:nodeset($following_dl_colwidths)//column">
							<xsl:call-template name="setColumnWidth_dl">
								<xsl:with-param name="colwidths" select="$following_dl_colwidths"/>								
								<xsl:with-param name="maxlength_dt" select="$maxlength_dt"/>								
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<fo:table-column column-width="15%"/>
							<fo:table-column column-width="85%"/>
						</xsl:otherwise>
					</xsl:choose>
					<fo:table-body>
						<xsl:for-each select="xalan:nodeset($references)//fn">
							<xsl:variable name="reference" select="@reference"/>
							<xsl:if test="not(preceding-sibling::*[@reference = $reference])"> <!-- only unique reference puts in note-->
								<fo:table-row>
									<fo:table-cell>
										<fo:block>
											<fo:inline font-size="80%" padding-right="5mm" vertical-align="super" id="{@id}">
												<xsl:if test="$namespace = 'iec'">
													<!-- <xsl:attribute name="font-family">Times New Roman</xsl:attribute> -->
													<xsl:attribute name="baseline-shift">65%</xsl:attribute>
												</xsl:if>
												<xsl:value-of select="@reference"/>
											</fo:inline>
										</fo:block>
									</fo:table-cell>
									<fo:table-cell>
										<fo:block text-align="justify" margin-bottom="12pt">
											<xsl:if test="$namespace = 'iec'">
												<xsl:attribute name="margin-top">5pt</xsl:attribute>
											</xsl:if>
											<xsl:if test="normalize-space($key_iso) = 'true'">
												<xsl:attribute name="margin-bottom">0</xsl:attribute>
											</xsl:if>
											<xsl:if test="$namespace = 'iec'">
												<xsl:attribute name="margin-bottom">10pt</xsl:attribute>
											</xsl:if>
											<xsl:apply-templates />
										</fo:block>
									</fo:table-cell>
								</fo:table-row>
							</xsl:if>
						</xsl:for-each>
					</fo:table-body>
				</fo:table>
			</fo:block>
		</xsl:if>
		
	</xsl:template>
	
	<!-- *[local-name()='table']// -->
	<xsl:template match="*[local-name()='fn']">
		<!-- <xsl:variable name="namespace" select="substring-before(name(/*), '-')"/> -->
		<fo:inline font-size="80%" keep-with-previous.within-line="always">
			<xsl:if test="$namespace = 'iso' or $namespace = 'iec'">
				<xsl:if test="ancestor::*[local-name()='td']">
					<xsl:attribute name="font-weight">normal</xsl:attribute>
					<!-- <xsl:attribute name="alignment-baseline">hanging</xsl:attribute> -->
					<xsl:attribute name="baseline-shift">15%</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$namespace = 'gb'">
				<xsl:attribute name="font-size">50%</xsl:attribute>
				<xsl:attribute name="font-weight">normal</xsl:attribute>
				<xsl:attribute name="vertical-align">super</xsl:attribute>
			</xsl:if>
			<xsl:if test="$namespace = 'itu' or $namespace = 'nist' or $namespace = 'ogc'">
				<xsl:attribute name="vertical-align">super</xsl:attribute>
				<xsl:attribute name="color">blue</xsl:attribute>
			</xsl:if>
			<xsl:if test="$namespace = 'nist' or $namespace = 'ogc'">
				<xsl:attribute name="text-decoration">underline</xsl:attribute>
			</xsl:if>
			<fo:basic-link internal-destination="{@reference}_{ancestor::*[@id][1]/@id}" fox:alt-text="{@reference}"> <!-- @reference   | ancestor::*[local-name()='clause'][1]/@id-->
				<xsl:if test="$namespace = 'ogc'">
					<xsl:attribute name="internal-destination">
						<xsl:value-of select="@reference"/><xsl:text>_</xsl:text>
						<xsl:value-of select="ancestor::*[local-name()='table'][1]/@id"/>
					</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="@reference"/>
			</fo:basic-link>
		</fo:inline>
	</xsl:template>
	

	<xsl:template match="*[local-name()='fn']/*[local-name()='p']">
		<fo:inline>
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>

	<xsl:template match="*[local-name()='dl']">
		<xsl:variable name="parent" select="local-name(..)"/>
		
		<xsl:variable name="key_iso">
			<xsl:if test="$namespace = 'iso' or $namespace = 'iec'  or $namespace = 'gb'">
				<xsl:if test="$parent = 'figure' or $parent = 'formula'">true</xsl:if>
			</xsl:if> <!-- and  (not(../@class) or ../@class !='pseudocode') -->
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="$parent = 'formula' and count(*[local-name()='dt']) = 1"> <!-- only one component -->
				<xsl:if test="$namespace = 'iec' or $namespace = 'gb'">
					<fo:block text-align="left">
						<xsl:if test="$namespace = 'iec'">
							<xsl:attribute name="margin-bottom">15pt</xsl:attribute>
						</xsl:if>
						<xsl:if test="$namespace = 'gb'">
							<xsl:attribute name="margin-left">7.4mm</xsl:attribute>
						</xsl:if>
						<xsl:variable name="title-where">
							<xsl:call-template name="getTitle">
								<xsl:with-param name="name" select="'title-where'"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:value-of select="$title-where"/>
					</fo:block>
					<fo:block>
						<xsl:if test="$namespace = 'gb'">
							<xsl:attribute name="text-indent">7.4mm</xsl:attribute>
						</xsl:if>
						<xsl:apply-templates select="*[local-name()='dt']/*"/>
						<xsl:if test="$namespace = 'gb'">—</xsl:if>
						<xsl:text> </xsl:text>
						<xsl:apply-templates select="*[local-name()='dd']/*" mode="inline"/>
					</fo:block>
				</xsl:if>
				<xsl:if test="$namespace = 'iso' or $namespace = 'itu' or $namespace = 'unece' or $namespace = 'unece-rec'  or $namespace = 'nist' or $namespace = 'csd' or $namespace = 'ogc' or $namespace = 'm3d' or $namespace = 'iho'">
					<fo:block margin-bottom="12pt" text-align="left">
						<xsl:if test="$namespace = 'iso' or $namespace = 'iec'">
							<xsl:attribute name="margin-bottom">0</xsl:attribute>
						</xsl:if>
						<xsl:variable name="title-where">
							<xsl:call-template name="getTitle">
								<xsl:with-param name="name" select="'title-where'"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:value-of select="$title-where"/><xsl:text>&#xA0;</xsl:text>
						<xsl:apply-templates select="*[local-name()='dt']/*"/>
						<xsl:text></xsl:text>
						<xsl:apply-templates select="*[local-name()='dd']/*" mode="inline"/>
					</fo:block>
				</xsl:if>
			</xsl:when>
			<xsl:when test="$parent = 'formula'"> <!-- a few components -->
				<fo:block margin-bottom="12pt" text-align="left">
					<xsl:if test="$namespace = 'iso' ">
						<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
					</xsl:if>
					<xsl:if test="$namespace = 'iec'">
						<xsl:attribute name="margin-bottom">10pt</xsl:attribute>
					</xsl:if>
					<xsl:if test="$namespace = 'itu'">
						<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
					</xsl:if>
					<xsl:if test="$namespace = 'gb'">
						<xsl:attribute name="margin-left">7.4mm</xsl:attribute>
						<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
					</xsl:if>
					<xsl:variable name="title-where">
						<xsl:call-template name="getTitle">
							<xsl:with-param name="name" select="'title-where'"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:value-of select="$title-where"/><xsl:if test="$namespace = 'itu'">:</xsl:if>
				</fo:block>
			</xsl:when>
			<xsl:when test="$parent = 'figure' and  (not(../@class) or ../@class !='pseudocode')">
				<fo:block font-weight="bold" text-align="left" margin-bottom="12pt" keep-with-next="always">
					<xsl:if test="$namespace = 'iso'">
						<xsl:attribute name="font-size">10pt</xsl:attribute>
						<xsl:attribute name="margin-bottom">0</xsl:attribute>
					</xsl:if>
					<xsl:if test="$namespace = 'iec'">
						<xsl:attribute name="font-size">8pt</xsl:attribute>
						<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
					</xsl:if>
					<xsl:if test="$namespace = 'gb'">
						<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
						<xsl:attribute name="text-indent">7.4mm</xsl:attribute>
					</xsl:if>
					<xsl:variable name="title-key">
						<xsl:call-template name="getTitle">
							<xsl:with-param name="name" select="'title-key'"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:value-of select="$title-key"/>
				</fo:block>
			</xsl:when>
		</xsl:choose>
		
		<!-- a few components -->
		<xsl:if test="not($parent = 'formula' and count(*[local-name()='dt']) = 1)">
			<fo:block>
				<xsl:if test="$namespace = 'iso'">
					<xsl:if test="$parent = 'formula'">
						<xsl:attribute name="margin-left">4mm</xsl:attribute>
					</xsl:if>
					<xsl:attribute name="margin-top">12pt</xsl:attribute>
				</xsl:if>
				<xsl:if test="$namespace = 'itu'">
					<xsl:if test="$parent = 'figure' or $parent = 'formula'">
						<xsl:attribute name="margin-left">7.4mm</xsl:attribute>
					</xsl:if>
					<xsl:if test="$parent = 'li'">
						<!-- <xsl:attribute name="margin-left">-4mm</xsl:attribute> -->						
					</xsl:if>					
				</xsl:if>
				<xsl:if test="$namespace = 'nist'">
					<xsl:if test="not(.//*[local-name()='dt']//*[local-name()='stem'])">
						<xsl:attribute name="margin-left">5mm</xsl:attribute>
					</xsl:if>
				</xsl:if>
				<xsl:if test="$namespace = 'iho'">
					<xsl:attribute name="margin-left">7mm</xsl:attribute>
				</xsl:if>
				<fo:block>
					<xsl:if test="$namespace = 'nist'">
						<xsl:if test="not(.//*[local-name()='dt']//*[local-name()='stem'])">
							<xsl:attribute name="margin-left">-2.5mm</xsl:attribute>
						</xsl:if>
					</xsl:if>
					<xsl:if test="$namespace = 'gb'">
						<xsl:attribute name="margin-left">7.4mm</xsl:attribute>
						<xsl:if test="$parent = 'figure' and  (not(../@class) or ../@class !='pseudocode')">
							<xsl:attribute name="margin-left">15mm</xsl:attribute>
						</xsl:if>
					</xsl:if>
					<xsl:if test="$namespace = 'iho'">
						<xsl:attribute name="margin-left">-3.5mm</xsl:attribute>
					</xsl:if>
					
					<fo:table width="95%" table-layout="fixed">
						<xsl:if test="$namespace = 'gb'">
							<xsl:attribute name="margin-left">-3.7mm</xsl:attribute>
						</xsl:if>
						<xsl:choose>
							<xsl:when test="normalize-space($key_iso) = 'true' and $parent = 'formula'">
								<!-- <xsl:attribute name="font-size">11pt</xsl:attribute> -->
							</xsl:when>
							<xsl:when test="normalize-space($key_iso) = 'true'">
								<xsl:attribute name="font-size">10pt</xsl:attribute>
								<xsl:if test="$namespace = 'iec'">
									<xsl:attribute name="font-size">8pt</xsl:attribute>
								</xsl:if>
							</xsl:when>
						</xsl:choose>
						<!-- create virtual html table for dl/[dt and dd] -->
						<xsl:variable name="html-table">
							<xsl:variable name="ns" select="substring-before(name(/*), '-')"/>
							<xsl:element name="{$ns}:table">
								<tbody>
									<xsl:apply-templates mode="dl"/>
								</tbody>
							</xsl:element>
						</xsl:variable>
						<!-- html-table<xsl:copy-of select="$html-table"/> -->
						<xsl:variable name="colwidths">
							<xsl:call-template name="calculate-column-widths">
								<xsl:with-param name="cols-count" select="2"/>
								<xsl:with-param name="table" select="$html-table"/>
							</xsl:call-template>
						</xsl:variable>
						<!-- colwidths=<xsl:value-of select="$colwidths"/> -->
						<xsl:variable name="maxlength_dt">							
							<xsl:call-template name="getMaxLength_dt"/>							
						</xsl:variable>
						<xsl:call-template name="setColumnWidth_dl">
							<xsl:with-param name="colwidths" select="$colwidths"/>							
							<xsl:with-param name="maxlength_dt" select="$maxlength_dt"/>
						</xsl:call-template>
						<fo:table-body>
							<xsl:apply-templates>
								<xsl:with-param name="key_iso" select="normalize-space($key_iso)"/>
							</xsl:apply-templates>
						</fo:table-body>
					</fo:table>
				</fo:block>
			</fo:block>
		</xsl:if>
	</xsl:template>
	
	
	<xsl:template name="setColumnWidth_dl">
		<xsl:param name="colwidths"/>		
		<xsl:param name="maxlength_dt"/>
		<xsl:choose>
			<xsl:when test="ancestor::*[local-name()='dl']"><!-- second level, i.e. inlined table -->
				<fo:table-column column-width="50%"/>
				<fo:table-column column-width="50%"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="normalize-space($maxlength_dt) != '' and number($maxlength_dt) &lt;= 2"> <!-- if dt contains short text like t90, a, etc -->
						<fo:table-column column-width="5%"/>
						<fo:table-column column-width="95%"/>
					</xsl:when>
					<xsl:when test="normalize-space($maxlength_dt) != '' and number($maxlength_dt) &lt;= 5"> <!-- if dt contains short text like t90, a, etc -->
						<fo:table-column column-width="10%"/>
						<fo:table-column column-width="90%"/>
					</xsl:when>
					<!-- <xsl:when test="xalan:nodeset($colwidths)/column[1] div xalan:nodeset($colwidths)/column[2] &gt; 1.7">
						<fo:table-column column-width="60%"/>
						<fo:table-column column-width="40%"/>
					</xsl:when> -->
					<xsl:when test="xalan:nodeset($colwidths)/column[1] div xalan:nodeset($colwidths)/column[2] &gt; 1.3">
						<fo:table-column column-width="50%"/>
						<fo:table-column column-width="50%"/>
					</xsl:when>
					<xsl:when test="xalan:nodeset($colwidths)/column[1] div xalan:nodeset($colwidths)/column[2] &gt; 0.5">
						<fo:table-column column-width="40%"/>
						<fo:table-column column-width="60%"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each select="xalan:nodeset($colwidths)//column">
							<xsl:choose>
								<xsl:when test=". = 1 or . = 0">
									<fo:table-column column-width="proportional-column-width(2)"/>
								</xsl:when>
								<xsl:otherwise>
									<fo:table-column column-width="proportional-column-width({.})"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
				<!-- <fo:table-column column-width="15%"/>
				<fo:table-column column-width="85%"/> -->
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="getMaxLength_dt">
		<xsl:for-each select="*[local-name()='dt']">
			<xsl:sort select="string-length(normalize-space(.))" data-type="number" order="descending"/>
			<xsl:if test="position() = 1">
				<xsl:value-of select="string-length(normalize-space(.))"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="*[local-name()='dl']/*[local-name()='note']">
		<xsl:param name="key_iso"/>
		
		<!-- <tr>
			<td>NOTE</td>
			<td>
				<xsl:apply-templates />
			</td>
		</tr>
		 -->
		<fo:table-row>
			<fo:table-cell>
				<fo:block margin-top="6pt">
					<xsl:if test="normalize-space($key_iso) = 'true'">
						<xsl:attribute name="margin-top">0</xsl:attribute>
					</xsl:if>
					<xsl:apply-templates select="*[local-name() = 'name']" mode="presentation"/>
				</fo:block>
			</fo:table-cell>
			<fo:table-cell>
				<fo:block>
					<xsl:apply-templates />
				</fo:block>
			</fo:table-cell>
		</fo:table-row>
	</xsl:template>
	
	<!-- virtual html table for dl/[dt and dd]  -->
	<xsl:template match="*[local-name()='dt']" mode="dl">
		<tr>
			<td>
				<xsl:apply-templates />
			</td>
			<td>
				<xsl:if test="$namespace = 'nist'">
					<xsl:if test="local-name(*[1]) != 'stem'">
						<xsl:apply-templates select="following-sibling::*[local-name()='dd'][1]" mode="process"/>
					</xsl:if>
				</xsl:if>
				<xsl:if test="$namespace = 'iso' or $namespace = 'iec' or $namespace = 'itu' or $namespace = 'unece' or $namespace = 'unece-rec'  or $namespace = 'csd' or $namespace = 'ogc' or $namespace = 'gb' or $namespace = 'm3d' or $namespace = 'iho'">
					<xsl:apply-templates select="following-sibling::*[local-name()='dd'][1]" mode="process"/>
				</xsl:if>
			</td>
		</tr>
		<xsl:if test="$namespace = 'nist'">
			<xsl:if test="local-name(*[1]) = 'stem'">
				<tr>
					<td>
						<xsl:text>&#xA0;</xsl:text>
					</td>
					<td>
						<xsl:apply-templates select="following-sibling::*[local-name()='dd'][1]" mode="dl_process"/>
					</td>
				</tr>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="*[local-name()='dt']">
		<xsl:param name="key_iso"/>
		
		<fo:table-row>
			<fo:table-cell>
				<xsl:if test="$namespace = 'itu'">
					<xsl:if test="ancestor::*[1][local-name() = 'dl']/preceding-sibling::*[1][local-name() = 'formula']">						
						<xsl:attribute name="padding-right">3mm</xsl:attribute>
					</xsl:if>
				</xsl:if>
				<fo:block margin-top="6pt">
					<xsl:if test="$namespace = 'iso'">
						<xsl:attribute name="margin-top">0pt</xsl:attribute>
					</xsl:if>
					<xsl:if test="$namespace = 'iec'">
						<xsl:attribute name="margin-top">0pt</xsl:attribute>
					</xsl:if>
					<xsl:if test="normalize-space($key_iso) = 'true'">
						<xsl:attribute name="margin-top">0</xsl:attribute>
						<xsl:if test="$namespace = 'iec'">
							<xsl:attribute name="margin-top">0pt</xsl:attribute>
						</xsl:if>
					</xsl:if>
					<xsl:if test="$namespace = 'nist'">
						<xsl:attribute name="margin-top">0</xsl:attribute>
						<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
					</xsl:if>
					<xsl:if test="$namespace = 'csd'">
						<xsl:attribute name="margin-left">7mm</xsl:attribute>
					</xsl:if>
					<xsl:if test="$namespace = 'iho'">
						<xsl:attribute name="margin-top">0pt</xsl:attribute>
						<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
					</xsl:if>
					<xsl:if test="$namespace = 'itu'">
						<xsl:if test="ancestor::*[1][local-name() = 'dl']/preceding-sibling::*[1][local-name() = 'formula']">
							<xsl:attribute name="text-align">right</xsl:attribute>							
						</xsl:if>
					</xsl:if>
					<xsl:if test="$namespace = 'ogc'">
						<xsl:attribute name="margin-top">0pt</xsl:attribute>
						<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
					</xsl:if>
					<xsl:apply-templates />
					<!-- <xsl:if test="$namespace = 'gb'">
						<xsl:if test="ancestor::*[local-name()='formula']">
							<xsl:text>—</xsl:text>
						</xsl:if>
					</xsl:if> -->
				</fo:block>
			</fo:table-cell>
			<fo:table-cell>
				<fo:block>
					<xsl:if test="$namespace = 'itu'">
						<xsl:attribute name="text-align">justify</xsl:attribute>
					</xsl:if>
					<xsl:if test="$namespace = 'nist'">
						<xsl:if test="local-name(*[1]) != 'stem'">
							<xsl:apply-templates select="following-sibling::*[local-name()='dd'][1]" mode="process"/>
						</xsl:if>
					</xsl:if>
					<xsl:if test="$namespace = 'iso' or $namespace = 'iec' or $namespace = 'itu' or $namespace = 'unece' or $namespace = 'unece-rec'  or $namespace = 'csd' or $namespace = 'ogc' or $namespace = 'gb' or $namespace = 'm3d' or $namespace = 'iho'">
						<xsl:apply-templates select="following-sibling::*[local-name()='dd'][1]" mode="process"/>
					</xsl:if>
				</fo:block>
			</fo:table-cell>
		</fo:table-row>
		<xsl:if test="$namespace = 'nist'">
			<xsl:if test="local-name(*[1]) = 'stem'">
				<fo:table-row>
				<fo:table-cell>
					<fo:block margin-top="6pt">
						<xsl:if test="normalize-space($key_iso) = 'true'">
							<xsl:attribute name="margin-top">0</xsl:attribute>
						</xsl:if>
						<xsl:text>&#xA0;</xsl:text>
					</fo:block>
				</fo:table-cell>
				<fo:table-cell>
					<fo:block>
						<xsl:apply-templates select="following-sibling::*[local-name()='dd'][1]" mode="process"/>
					</fo:block>
				</fo:table-cell>
			</fo:table-row>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="*[local-name()='dd']" mode="dl"/>
	<xsl:template match="*[local-name()='dd']" mode="dl_process">
		<xsl:apply-templates />
	</xsl:template>
	
	<xsl:template match="*[local-name()='dd']"/>
	<xsl:template match="*[local-name()='dd']" mode="process">
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="*[local-name()='dd']/*[local-name()='p']" mode="inline">
		<fo:inline><xsl:text> </xsl:text><xsl:apply-templates /></fo:inline>
	</xsl:template>
	
	<xsl:template match="*[local-name()='em']">
		<fo:inline font-style="italic">
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>

	<xsl:template match="*[local-name()='strong']">
		<fo:inline font-weight="bold">
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="*[local-name()='sup']">
		<fo:inline font-size="80%" vertical-align="super">
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="*[local-name()='sub']">
		<fo:inline font-size="80%" vertical-align="sub">
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="*[local-name()='tt']">
		<fo:inline font-family="Courier" font-size="10pt">			
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="*[local-name()='del']">
		<fo:inline font-size="10pt" color="red" text-decoration="line-through">
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="text()[ancestor::*[local-name()='smallcap']]">
		<xsl:variable name="text" select="normalize-space(.)"/>
		<fo:inline font-size="75%">
				<xsl:if test="string-length($text) &gt; 0">
					<xsl:call-template name="recursiveSmallCaps">
						<xsl:with-param name="text" select="$text"/>
					</xsl:call-template>
				</xsl:if>
			</fo:inline> 
	</xsl:template>
	
	<xsl:template name="recursiveSmallCaps">
    <xsl:param name="text"/>
    <xsl:variable name="char" select="substring($text,1,1)"/>
    <!-- <xsl:variable name="upperCase" select="translate($char, $lower, $upper)"/> -->
		<xsl:variable name="upperCase" select="java:toUpperCase(java:java.lang.String.new($char))"/>
    <xsl:choose>
      <xsl:when test="$char=$upperCase">
        <fo:inline font-size="{100 div 0.75}%">
          <xsl:value-of select="$upperCase"/>
        </fo:inline>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$upperCase"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="string-length($text) &gt; 1">
      <xsl:call-template name="recursiveSmallCaps">
        <xsl:with-param name="text" select="substring($text,2)"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
	
	<!-- split string 'text' by 'separator' -->
	<xsl:template name="tokenize">
		<xsl:param name="text"/>
		<xsl:param name="separator" select="' '"/>
		<xsl:choose>
			<xsl:when test="not(contains($text, $separator))">
				<word>
					<xsl:variable name="str_no_en_chars" select="normalize-space(translate($text, $en_chars, ''))"/>
					<xsl:variable name="len_str_no_en_chars" select="string-length($str_no_en_chars)"/>
					<xsl:variable name="len_str_tmp" select="string-length(normalize-space($text))"/>
					<xsl:variable name="len_str">
						<xsl:choose>
							<xsl:when test="normalize-space(translate($text, $upper, '')) = ''"> <!-- english word in CAPITAL letters -->
								<xsl:value-of select="$len_str_tmp * 1.5"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$len_str_tmp"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable> 
					
					<!-- <xsl:if test="$len_str_no_en_chars div $len_str &gt; 0.8">
						<xsl:message>
							div=<xsl:value-of select="$len_str_no_en_chars div $len_str"/>
							len_str=<xsl:value-of select="$len_str"/>
							len_str_no_en_chars=<xsl:value-of select="$len_str_no_en_chars"/>
						</xsl:message>
					</xsl:if> -->
					<!-- <len_str_no_en_chars><xsl:value-of select="$len_str_no_en_chars"/></len_str_no_en_chars>
					<len_str><xsl:value-of select="$len_str"/></len_str> -->
					<xsl:choose>
						<xsl:when test="$len_str_no_en_chars div $len_str &gt; 0.8"> <!-- means non-english string -->
							<xsl:value-of select="$len_str - $len_str_no_en_chars"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$len_str"/>
						</xsl:otherwise>
					</xsl:choose>
				</word>
			</xsl:when>
			<xsl:otherwise>
				<word>
					<xsl:value-of select="string-length(normalize-space(substring-before($text, $separator)))"/>
				</word>
				<xsl:call-template name="tokenize">
					<xsl:with-param name="text" select="substring-after($text, $separator)"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- get max value in array -->
	<xsl:template name="max_length">
		<xsl:param name="words"/>
		<xsl:for-each select="$words//word">
				<xsl:sort select="." data-type="number" order="descending"/>
				<xsl:if test="position()=1">
						<xsl:value-of select="."/>
				</xsl:if>
		</xsl:for-each>
	</xsl:template>

	
	<xsl:template name="add-zero-spaces-java">
		<xsl:param name="text" select="."/>
		<!-- add zero-width space (#x200B) after characters: dash, dot, colon, equal, underscore, em dash, thin space  -->
		<xsl:value-of select="java:replaceAll(java:java.lang.String.new($text),'(-|\.|:|=|_|—| )','$1&#x200B;')"/>
	</xsl:template>​
	
	<!-- add zero space after dash character (for table's entries) -->
	<xsl:template name="add-zero-spaces">
		<xsl:param name="text" select="."/>
		<xsl:variable name="zero-space-after-chars">&#x002D;</xsl:variable>
		<xsl:variable name="zero-space-after-dot">.</xsl:variable>
		<xsl:variable name="zero-space-after-colon">:</xsl:variable>
		<xsl:variable name="zero-space-after-equal">=</xsl:variable>
		<xsl:variable name="zero-space-after-underscore">_</xsl:variable>
		<xsl:variable name="zero-space">&#x200B;</xsl:variable>
		<xsl:choose>
			<xsl:when test="contains($text, $zero-space-after-chars)">
				<xsl:value-of select="substring-before($text, $zero-space-after-chars)"/>
				<xsl:value-of select="$zero-space-after-chars"/>
				<xsl:value-of select="$zero-space"/>
				<xsl:call-template name="add-zero-spaces">
					<xsl:with-param name="text" select="substring-after($text, $zero-space-after-chars)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($text, $zero-space-after-dot)">
				<xsl:value-of select="substring-before($text, $zero-space-after-dot)"/>
				<xsl:value-of select="$zero-space-after-dot"/>
				<xsl:value-of select="$zero-space"/>
				<xsl:call-template name="add-zero-spaces">
					<xsl:with-param name="text" select="substring-after($text, $zero-space-after-dot)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($text, $zero-space-after-colon)">
				<xsl:value-of select="substring-before($text, $zero-space-after-colon)"/>
				<xsl:value-of select="$zero-space-after-colon"/>
				<xsl:value-of select="$zero-space"/>
				<xsl:call-template name="add-zero-spaces">
					<xsl:with-param name="text" select="substring-after($text, $zero-space-after-colon)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($text, $zero-space-after-equal)">
				<xsl:value-of select="substring-before($text, $zero-space-after-equal)"/>
				<xsl:value-of select="$zero-space-after-equal"/>
				<xsl:value-of select="$zero-space"/>
				<xsl:call-template name="add-zero-spaces">
					<xsl:with-param name="text" select="substring-after($text, $zero-space-after-equal)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($text, $zero-space-after-underscore)">
				<xsl:value-of select="substring-before($text, $zero-space-after-underscore)"/>
				<xsl:value-of select="$zero-space-after-underscore"/>
				<xsl:value-of select="$zero-space"/>
				<xsl:call-template name="add-zero-spaces">
					<xsl:with-param name="text" select="substring-after($text, $zero-space-after-underscore)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>   

	<xsl:template name="add-zero-spaces-equal">
		<xsl:param name="text" select="."/>
		<xsl:variable name="zero-space-after-equals">==========</xsl:variable>
		<xsl:variable name="zero-space-after-equal">=</xsl:variable>
		<xsl:variable name="zero-space">&#x200B;</xsl:variable>
		<xsl:choose>
			<xsl:when test="contains($text, $zero-space-after-equals)">
				<xsl:value-of select="substring-before($text, $zero-space-after-equals)"/>
				<xsl:value-of select="$zero-space-after-equals"/>
				<xsl:value-of select="$zero-space"/>
				<xsl:call-template name="add-zero-spaces-equal">
					<xsl:with-param name="text" select="substring-after($text, $zero-space-after-equals)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($text, $zero-space-after-equal)">
				<xsl:value-of select="substring-before($text, $zero-space-after-equal)"/>
				<xsl:value-of select="$zero-space-after-equal"/>
				<xsl:value-of select="$zero-space"/>
				<xsl:call-template name="add-zero-spaces-equal">
					<xsl:with-param name="text" select="substring-after($text, $zero-space-after-equal)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>  
	
	<!-- Table normalization (colspan,rowspan processing for adding TDs) for column width calculation -->
	<xsl:template name="getSimpleTable">
		<xsl:variable name="simple-table">
		
			<!-- Step 1. colspan processing -->
			<xsl:variable name="simple-table-colspan">
				<tbody>
					<xsl:apply-templates mode="simple-table-colspan"/>
				</tbody>
			</xsl:variable>
			
			<!-- Step 2. rowspan processing -->
			<xsl:variable name="simple-table-rowspan">
				<xsl:apply-templates select="xalan:nodeset($simple-table-colspan)" mode="simple-table-rowspan"/>
			</xsl:variable>
			
			<xsl:copy-of select="xalan:nodeset($simple-table-rowspan)"/>
					
			<!-- <xsl:choose>
				<xsl:when test="current()//*[local-name()='th'][@colspan] or current()//*[local-name()='td'][@colspan] ">
					
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="current()"/>
				</xsl:otherwise>
			</xsl:choose> -->
		</xsl:variable>
		<xsl:copy-of select="$simple-table"/>
	</xsl:template>
		
	<!-- ===================== -->
	<!-- 1. mode "simple-table-colspan" 
			1.1. remove thead, tbody, fn
			1.2. rename th -> td
			1.3. repeating N td with colspan=N
			1.4. remove namespace
			1.5. remove @colspan attribute
			1.6. add @divide attribute for divide text width in further processing 
	-->
	<!-- ===================== -->	
	<xsl:template match="*[local-name()='thead'] | *[local-name()='tbody']" mode="simple-table-colspan">
		<xsl:apply-templates mode="simple-table-colspan"/>
	</xsl:template>
	<xsl:template match="*[local-name()='fn']" mode="simple-table-colspan"/>
	
	<xsl:template match="*[local-name()='th'] | *[local-name()='td']" mode="simple-table-colspan">
		<xsl:choose>
			<xsl:when test="@colspan">
				<xsl:variable name="td">
					<xsl:element name="td">
						<xsl:attribute name="divide"><xsl:value-of select="@colspan"/></xsl:attribute>
						<xsl:apply-templates select="@*" mode="simple-table-colspan"/>
						<xsl:apply-templates mode="simple-table-colspan"/>
					</xsl:element>
				</xsl:variable>
				<xsl:call-template name="repeatNode">
					<xsl:with-param name="count" select="@colspan"/>
					<xsl:with-param name="node" select="$td"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="td">
					<xsl:apply-templates select="@*" mode="simple-table-colspan"/>
					<xsl:apply-templates mode="simple-table-colspan"/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="@colspan" mode="simple-table-colspan"/>
	
	<xsl:template match="*[local-name()='tr']" mode="simple-table-colspan">
		<xsl:element name="tr">
			<xsl:apply-templates select="@*" mode="simple-table-colspan"/>
			<xsl:apply-templates mode="simple-table-colspan"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="@*|node()" mode="simple-table-colspan">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="simple-table-colspan"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- repeat node 'count' times -->
	<xsl:template name="repeatNode">
		<xsl:param name="count"/>
		<xsl:param name="node"/>
		
		<xsl:if test="$count &gt; 0">
			<xsl:call-template name="repeatNode">
				<xsl:with-param name="count" select="$count - 1"/>
				<xsl:with-param name="node" select="$node"/>
			</xsl:call-template>
			<xsl:copy-of select="$node"/>
		</xsl:if>
	</xsl:template>
	<!-- End mode simple-table-colspan  -->
	<!-- ===================== -->
	<!-- ===================== -->
	
	<!-- ===================== -->
	<!-- 2. mode "simple-table-rowspan" 
	Row span processing, more information http://andrewjwelch.com/code/xslt/table/table-normalization.html	-->
	<!-- ===================== -->		
	<xsl:template match="@*|node()" mode="simple-table-rowspan">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="simple-table-rowspan"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="tbody" mode="simple-table-rowspan">
		<xsl:copy>
				<xsl:copy-of select="tr[1]" />
				<xsl:apply-templates select="tr[2]" mode="simple-table-rowspan">
						<xsl:with-param name="previousRow" select="tr[1]" />
				</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="tr" mode="simple-table-rowspan">
		<xsl:param name="previousRow"/>
		<xsl:variable name="currentRow" select="." />
	
		<xsl:variable name="normalizedTDs">
				<xsl:for-each select="xalan:nodeset($previousRow)//td">
						<xsl:choose>
								<xsl:when test="@rowspan &gt; 1">
										<xsl:copy>
												<xsl:attribute name="rowspan">
														<xsl:value-of select="@rowspan - 1" />
												</xsl:attribute>
												<xsl:copy-of select="@*[not(name() = 'rowspan')]" />
												<xsl:copy-of select="node()" />
										</xsl:copy>
								</xsl:when>
								<xsl:otherwise>
										<xsl:copy-of select="$currentRow/td[1 + count(current()/preceding-sibling::td[not(@rowspan) or (@rowspan = 1)])]" />
								</xsl:otherwise>
						</xsl:choose>
				</xsl:for-each>
		</xsl:variable>

		<xsl:variable name="newRow">
				<xsl:copy>
						<xsl:copy-of select="$currentRow/@*" />
						<xsl:copy-of select="xalan:nodeset($normalizedTDs)" />
				</xsl:copy>
		</xsl:variable>
		<xsl:copy-of select="$newRow" />

		<xsl:apply-templates select="following-sibling::tr[1]" mode="simple-table-rowspan">
				<xsl:with-param name="previousRow" select="$newRow" />
		</xsl:apply-templates>
	</xsl:template>
	<!-- End mode simple-table-rowspan  -->
	<!-- ===================== -->	
	<!-- ===================== -->	

	<xsl:template name="getLang">
		<xsl:variable name="language" select="//*[local-name()='bibdata']//*[local-name()='language']"/>
		<xsl:choose>
			<xsl:when test="$language = 'English'">en</xsl:when>
			<xsl:otherwise><xsl:value-of select="$language"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="capitalizeWords">
		<xsl:param name="str" />
		<xsl:variable name="str2" select="translate($str, '-', ' ')"/>
		<xsl:choose>
			<xsl:when test="contains($str2, ' ')">
				<xsl:variable name="substr" select="substring-before($str2, ' ')"/>
				<!-- <xsl:value-of select="translate(substring($substr, 1, 1), $lower, $upper)"/>
				<xsl:value-of select="substring($substr, 2)"/> -->
				<xsl:call-template name="capitalize">
					<xsl:with-param name="str" select="$substr"/>
				</xsl:call-template>
				<xsl:text> </xsl:text>
				<xsl:call-template name="capitalizeWords">
					<xsl:with-param name="str" select="substring-after($str2, ' ')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<!-- <xsl:value-of select="translate(substring($str2, 1, 1), $lower, $upper)"/>
				<xsl:value-of select="substring($str2, 2)"/> -->
				<xsl:call-template name="capitalize">
					<xsl:with-param name="str" select="$str2"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="capitalize">
		<xsl:param name="str" />
		<xsl:value-of select="java:toUpperCase(java:java.lang.String.new(substring($str, 1, 1)))"/>
		<xsl:value-of select="substring($str, 2)"/>		
	</xsl:template>
	
	<xsl:template match="mathml:math">
		<fo:inline font-family="STIX2Math">
			<fo:instream-foreign-object fox:alt-text="Math"> 
				<xsl:copy-of select="."/>
			</fo:instream-foreign-object>
		</fo:inline>
	</xsl:template>

	<xsl:template match="*[local-name()='localityStack']">
		<xsl:for-each select="*[local-name()='locality']">
			<xsl:if test="position() =1"><xsl:text>, </xsl:text></xsl:if>
			<xsl:apply-templates select="."/>
			<xsl:if test="position() != last()"><xsl:text>; </xsl:text></xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="*[local-name()='link']" name="link">
		<xsl:variable name="target">
			<xsl:choose>
				<xsl:when test="starts-with(normalize-space(@target), 'mailto:')">
					<xsl:value-of select="normalize-space(substring-after(@target, 'mailto:'))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space(@target)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<fo:inline xsl:use-attribute-sets="link-style">
			<xsl:choose>
				<xsl:when test="$target = ''">
					<xsl:apply-templates />
				</xsl:when>
				<xsl:otherwise>
					<fo:basic-link external-destination="{@target}" fox:alt-text="{@target}">
						<xsl:choose>
							<xsl:when test="normalize-space(.) = ''">
								<xsl:value-of select="$target"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates />
							</xsl:otherwise>
						</xsl:choose>
					</fo:basic-link>
				</xsl:otherwise>
			</xsl:choose>
		</fo:inline>
	</xsl:template>


	<xsl:template match="*[local-name()='bookmark']">
		<fo:inline id="{@id}"></fo:inline>
	</xsl:template>

	
	<xsl:template match="*[local-name()='appendix']">
		<fo:block id="{@id}" xsl:use-attribute-sets="appendix-style">
			<xsl:variable name="title-appendix">
				<xsl:call-template name="getTitle">
					<xsl:with-param name="name" select="'title-appendix'"/>
				</xsl:call-template>
			</xsl:variable>
			<fo:inline padding-right="5mm"><xsl:value-of select="$title-appendix"/> <xsl:number /></fo:inline>
			<xsl:apply-templates select="*[local-name()='title']" mode="process"/>
		</fo:block>
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="*[local-name()='appendix']/*[local-name()='title']"/>
	<xsl:template match="*[local-name()='appendix']/*[local-name()='title']" mode="process">
		<fo:inline><xsl:apply-templates /></fo:inline>
	</xsl:template>
	
	
	<xsl:template match="*[local-name()='appendix']//*[local-name()='example']">
		<fo:block xsl:use-attribute-sets="appendix-example-style">
			<xsl:variable name="claims_id" select="ancestor::*[local-name()='clause'][1]/@id"/>
			<xsl:variable name="title-example">
				<xsl:call-template name="getTitle">
					<xsl:with-param name="name" select="'title-example'"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:value-of select="$title-example"/>
			<xsl:if test="count(ancestor::*[local-name()='clause'][1]//*[local-name()='example']) &gt; 1">
					<xsl:number count="*[local-name()='example'][ancestor::*[local-name()='clause'][@id = $claims_id]]" level="any"/><xsl:text> </xsl:text>
				</xsl:if>
			<xsl:if test="*[local-name()='name']">
				<xsl:text>— </xsl:text><xsl:apply-templates select="*[local-name()='name']" mode="process"/>
			</xsl:if>
		</fo:block>
		<xsl:apply-templates />
	</xsl:template>
	
	<xsl:template match="*[local-name()='appendix']//*[local-name()='example']/*[local-name()='name']"/>
	<xsl:template match="*[local-name()='appendix']//*[local-name()='example']/*[local-name()='name']" mode="process">
		<fo:inline><xsl:apply-templates /></fo:inline>
	</xsl:template>
	
	
	<xsl:template match="*[local-name() = 'callout']">		
		<fo:basic-link internal-destination="{@target}" fox:alt-text="{@target}">&lt;<xsl:apply-templates />&gt;</fo:basic-link>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'annotation']">
		<xsl:variable name="annotation-id" select="@id"/>
		<xsl:variable name="callout" select="//*[@target = $annotation-id]/text()"/>		
		<fo:block id="{$annotation-id}" white-space="nowrap">			
			<fo:inline>				
				<xsl:apply-templates>
					<xsl:with-param name="callout" select="concat('&lt;', $callout, '&gt; ')"/>
				</xsl:apply-templates>
			</fo:inline>
		</fo:block>		
	</xsl:template>	

	<xsl:template match="*[local-name() = 'annotation']/*[local-name() = 'p']">
		<xsl:param name="callout"/>
		<fo:inline id="{@id}">
			<!-- for first p in annotation, put <x> -->
			<xsl:if test="not(preceding-sibling::*[local-name() = 'p'])"><xsl:value-of select="$callout"/></xsl:if>
			<xsl:apply-templates />
		</fo:inline>		
	</xsl:template>

	<xsl:template match="*[local-name() = 'modification']">
		<xsl:variable name="title-modified">
			<xsl:call-template name="getTitle">
				<xsl:with-param name="name" select="'title-modified'"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$lang = 'zh'"><xsl:text>、</xsl:text><xsl:value-of select="$title-modified"/><xsl:text>—</xsl:text></xsl:when>
			<xsl:otherwise><xsl:text>, </xsl:text><xsl:value-of select="$title-modified"/><xsl:text> — </xsl:text></xsl:otherwise>
		</xsl:choose>
		<xsl:apply-templates/>
	</xsl:template>	

	<xsl:template match="*[local-name() = 'xref']">
		<fo:basic-link internal-destination="{@target}" fox:alt-text="{@target}" xsl:use-attribute-sets="xref-style">
			<xsl:if test="$namespace = 'iho1' or $namespace = 'iso1'">
				<xsl:variable name="target" select="normalize-space(@target)"/>
				<xsl:variable name="parent_section" select="xalan:nodeset($contents)//item[@id =$target]/@parent_section"/>
				<xsl:variable name="currentSection">
					<xsl:call-template name="getSection"/>
				</xsl:variable>			
				<xsl:variable name="type" select="xalan:nodeset($contents)//item[@id = $target]/@type"/>
				<xsl:if test="$type = 'li' and contains($parent_section, $currentSection)">
					<xsl:attribute name="color">black</xsl:attribute>
					<xsl:attribute name="text-decoration">none</xsl:attribute>					
				</xsl:if>
			</xsl:if>			
			<xsl:apply-templates />
		</fo:basic-link>
	</xsl:template>
	
	<!-- ====== -->
	<!-- formula  -->
	<!-- ====== -->
	<xsl:template match="*[local-name() = 'formula']/*[local-name() = 'dt']/*[local-name() = 'stem']">
		<fo:inline>
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'formula']/*[local-name() = 'name']"/>
	
	<xsl:template match="*[local-name() = 'formula']/*[local-name() = 'name']" mode="presentation">
		<xsl:if test="normalize-space() != ''">
			<xsl:text>(</xsl:text><xsl:apply-templates /><xsl:text>)</xsl:text>
		</xsl:if>
	</xsl:template>
	<!-- ====== -->
	<!-- ====== -->
	
	
	<!-- ====== -->
	<!-- note      -->
	<!-- termnote -->
	<!-- ====== -->
	
	<xsl:template match="*[local-name() = 'termnote']">
		<fo:block id="{@id}" xsl:use-attribute-sets="termnote-style">			
			<xsl:apply-templates select="*[local-name() = 'name']" mode="presentation"/>			
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	

	
	<xsl:template match="*[local-name() = 'note']/*[local-name() = 'name'] |
														*[local-name() = 'termnote']/*[local-name() = 'name']"/>	
	
	<xsl:template match="*[local-name() = 'note']/*[local-name() = 'name']" mode="presentation">
		<xsl:param name="sfx"/>
		<xsl:variable name="suffix">
			<xsl:choose>
				<xsl:when test="$sfx != ''">
					<xsl:value-of select="$sfx"/>					
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="$namespace = 'gb' or $namespace = 'rsd' or $namespace = 'ogc'">
						<xsl:text>:</xsl:text>
					</xsl:if>
					<xsl:if test="$namespace = 'itu' or $namespace = 'nist' or $namespace = 'unece-rec' or $namespace = 'unece'">				
						<xsl:text> – </xsl:text>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="normalize-space() != ''">
			<xsl:apply-templates />
			<xsl:value-of select="$suffix"/>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'termnote']/*[local-name() = 'name']" mode="presentation">
		<xsl:if test="normalize-space() != ''">
			<xsl:apply-templates />
			<xsl:text>: </xsl:text>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'termnote']/*[local-name() = 'p']">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template>
	
	<!-- ====== -->
	<!-- ====== -->
	
	
	<!-- ====== -->
	<!-- term      -->	
	<!-- ====== -->
	<xsl:template match="*[local-name() = 'term']/*[local-name() = 'name']"/>	
	
	<xsl:template match="*[local-name() = 'term']/*[local-name() = 'name']" mode="presentation">
		<xsl:if test="normalize-space() != ''">
			<fo:inline>
				<xsl:apply-templates />
				<xsl:if test="$namespace = 'csa' or $namespace = 'csd' or $namespace = 'gb' or $namespace = 'ogc'">
					<xsl:text>.</xsl:text>
				</xsl:if>
			</fo:inline>
		</xsl:if>
	</xsl:template>
	<!-- ====== -->
	<!-- ====== -->
	
	<!-- ====== -->
	<!-- figure     -->	
	<!-- ====== -->
	<xsl:template match="*[local-name() = 'figure']/*[local-name() = 'name']"/>	
	
	<xsl:template match="*[local-name() = 'figure']/*[local-name() = 'name'] | 
														*[local-name() = 'table']/*[local-name() = 'name']" mode="contents">
		<xsl:apply-templates/>
		<xsl:text> </xsl:text>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'figure']/*[local-name() = 'name'] |
								*[local-name() = 'image']/*[local-name() = 'name']" mode="presentation">
		<xsl:if test="normalize-space() != ''">			
			<xsl:if test="$namespace = 'csa'">
				<fo:block font-size="11pt" font-weight="bold" text-align="center" margin-top="12pt" margin-bottom="6pt" keep-with-previous="always">
					<xsl:apply-templates/>
				</fo:block>
			</xsl:if>
			<xsl:if test="$namespace = 'csd'">
				<fo:block font-weight="bold" text-align="center" margin-top="12pt" margin-bottom="12pt" keep-with-previous="always">
					<xsl:apply-templates/>
				</fo:block>
			</xsl:if>
			<xsl:if test="$namespace = 'gb'">
				<fo:block font-family="SimHei" text-align="center" margin-top="12pt" margin-bottom="12pt" keep-with-previous="always">
					<xsl:apply-templates/>
				</fo:block>
			</xsl:if>
			<xsl:if test="$namespace = 'iec'">
				<fo:block font-weight="bold" text-align="center" margin-top="12pt" margin-bottom="12pt" keep-with-previous="always">
					<xsl:apply-templates/>
				</fo:block>
			</xsl:if>
			<xsl:if test="$namespace = 'iho'">
				<fo:block font-size="11pt" font-weight="bold" text-align="center" margin-top="6pt" margin-bottom="6pt" keep-with-previous="always">
					<xsl:apply-templates/>
				</fo:block>
			</xsl:if>
			<xsl:if test="$namespace = 'iso'">
				<fo:block font-weight="bold" text-align="center" margin-top="12pt" margin-bottom="12pt" keep-with-previous="always">
					<xsl:apply-templates/>
				</fo:block>
			</xsl:if>
			<xsl:if test="$namespace = 'itu'">
				<fo:block font-weight="bold" text-align="center" margin-top="6pt" margin-bottom="6pt" keep-with-previous="always">
					<xsl:apply-templates/>
				</fo:block>
			</xsl:if>
			<xsl:if test="$namespace = 'm3d'">
				<fo:block text-align="center" margin-top="12pt" margin-bottom="12pt" keep-with-previous="always">
					<xsl:apply-templates/>
				</fo:block>
			</xsl:if>
			<xsl:if test="$namespace = 'nist'">
				<fo:block font-weight="bold" text-align="center" space-before="6pt" margin-bottom="6pt" keep-with-previous="always">
					<xsl:if test="nist:dl">
						<xsl:attribute name="space-before">12pt</xsl:attribute>
					</xsl:if>
					<xsl:apply-templates/>
				</fo:block>
			</xsl:if>			
			<xsl:if test="$namespace = 'ogc'">
				<fo:block font-size="11pt" font-weight="bold" text-align="center" margin-top="12pt" margin-bottom="6pt" keep-with-previous="always">
					<xsl:apply-templates/>
				</fo:block>
			</xsl:if>
			<xsl:if test="$namespace = 'rsd'">
				<fo:block font-family="SourceSansPro" font-size="12pt" font-weight="bold" text-align="center" margin-top="12pt" margin-bottom="6pt" keep-with-previous="always">
					<xsl:apply-templates/>
				</fo:block>
			</xsl:if>
			<xsl:if test="$namespace = 'unece'">
				<fo:block text-align="center" margin-bottom="6pt" keep-with-previous="always">
					<xsl:apply-templates/>
				</fo:block>
			</xsl:if>
			<xsl:if test="$namespace = 'unece-rec'">
				<fo:block text-align="center" font-size="9pt" margin-bottom="6pt" keep-with-next="always" keep-together.within-column="always">
					<xsl:apply-templates/>
				</fo:block>
			</xsl:if>
			
		</xsl:if>
	</xsl:template>
	<!-- ====== -->
	<!-- ====== -->


	<!-- ====== -->
	<!-- sourcecode   -->	
	<!-- ====== -->	
	<xsl:template match="*[local-name()='sourcecode']" name="sourcecode">
		<fo:block xsl:use-attribute-sets="sourcecode-style">
			<!-- <xsl:choose>
				<xsl:when test="@lang = 'en'"></xsl:when>
				<xsl:otherwise> -->
					<xsl:attribute name="white-space">pre</xsl:attribute>
					<xsl:attribute name="wrap-option">wrap</xsl:attribute>
				<!-- </xsl:otherwise>
			</xsl:choose> -->
			<xsl:apply-templates/>
			<xsl:apply-templates select="*[local-name()='name']" mode="presentation"/>
		</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name()='sourcecode']/text()">
		<xsl:variable name="text">
			<xsl:call-template name="add-zero-spaces-equal"/>
		</xsl:variable>
		<xsl:call-template name="add-zero-spaces">
			<xsl:with-param name="text" select="$text"/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'sourcecode']/*[local-name() = 'name']"/>	
	
	
	<xsl:template match="*[local-name() = 'sourcecode']/*[local-name() = 'name']" mode="presentation">
		<xsl:if test="normalize-space() != ''">		
			<fo:block font-size="11pt" font-weight="bold" text-align="center" margin-bottom="12pt">
				<xsl:if test="$namespace = 'rsd'">
					<xsl:attribute name="font-size">12pt</xsl:attribute>
					<xsl:attribute name="font-family">SourceSansPro</xsl:attribute>
				</xsl:if>
				<xsl:apply-templates/>
			</fo:block>
		</xsl:if>
	</xsl:template>	
	<!-- ====== -->
	<!-- ====== -->
	
	
	<!-- ====== -->
	<!-- termexample   -->	
	<!-- ====== -->	
	
		<xsl:template match="*[local-name() = 'termexample']">
		<fo:block xsl:use-attribute-sets="termexample-style">			
			<xsl:apply-templates select="*[local-name()='name']" mode="presentation"/>			
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	
	<xsl:template match="*[local-name() = 'termexample']/*[local-name() = 'name']"/>	
	
	<xsl:template match="*[local-name() = 'termexample']/*[local-name() = 'name']" mode="presentation">
		<xsl:if test="normalize-space() != ''">
			<fo:inline xsl:use-attribute-sets="termexample-name-style">
				<xsl:apply-templates />
			</fo:inline>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'termexample']/*[local-name() = 'p']">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template>
	
	<!-- ====== -->
	<!-- ====== -->
	
	<xsl:template match="*[local-name() = 'tab']">
		<!-- zero-space char -->
		<xsl:variable name="depth">
			<xsl:call-template name="getLevel">
				<xsl:with-param name="depth" select="../@depth"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="padding">			
			<xsl:if test="$namespace = 'csd'">
				<xsl:choose>
					<xsl:when test="$depth &gt;= 3">3</xsl:when>
					<xsl:when test="$depth = 1">3</xsl:when>
					<xsl:otherwise>2</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:if test="$namespace = 'gb'">2</xsl:if>
			<xsl:if test="$namespace = 'iec'">
				<xsl:choose>
					<xsl:when test="$depth = 2 and ancestor::iec:annex">6</xsl:when>
					<xsl:when test="$depth = 2">7</xsl:when>
					<xsl:otherwise>5</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:if test="$namespace = 'iho'">
				<xsl:choose>
					<xsl:when test="$depth = 2">3</xsl:when>
					<xsl:when test="$depth = 3">3</xsl:when>
					<xsl:otherwise>4</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:if test="$namespace = 'iso'">
				<xsl:choose>
					<xsl:when test="$depth = 2">3</xsl:when>
					<xsl:otherwise>4</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:if test="$namespace = 'itu'">
				<xsl:choose>
					<xsl:when test="$depth = 5">7</xsl:when>
					<xsl:when test="$depth = 4">10</xsl:when>
					<xsl:when test="$depth = 3">6</xsl:when>
					<xsl:when test="$depth = 2">9</xsl:when>
					<xsl:otherwise>12</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:if test="$namespace = 'm3d'">								
				<xsl:variable name="references_num_current">
					<xsl:number level="any" count="m3d:references"/>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="(ancestor::m3d:sections and $depth = 1) or 
															(local-name(..) = 'references' and $references_num_current = 1)">25</xsl:when>
					<xsl:when test="ancestor::m3d:sections or ancestor::m3d:annex">3</xsl:when>						
				</xsl:choose>
			</xsl:if>
			<xsl:if test="$namespace = 'nist'">				
				<xsl:choose>
					<xsl:when test="$depth = 1 and local-name(..) != 'annex'">7.5</xsl:when>										
					<xsl:otherwise>4</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:if test="$namespace = 'ogc'">
				<xsl:choose>
					<xsl:when test="$depth &gt;= 5"/>
					<xsl:when test="$depth &gt;= 4">5</xsl:when>
					<xsl:when test="$depth &gt;= 3 and ancestor::ogc:terms">3</xsl:when>
					<xsl:when test="$depth &gt;= 2">4</xsl:when>
					<xsl:when test="$depth = 1">4</xsl:when>
					<xsl:otherwise>2</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:if test="$namespace = 'rsd'">3.5</xsl:if>
			<xsl:if test="$namespace = 'unece'">
				<xsl:choose>
					<xsl:when test="ancestor::un:sections and $depth = 1">12</xsl:when>
					<xsl:when test="ancestor::un:sections">8</xsl:when>					
				</xsl:choose>
			</xsl:if>
			<xsl:if test="$namespace = 'unece-rec'">
				<xsl:choose>
					<xsl:when test="ancestor::un:annex and $depth &gt;= 2">9.5</xsl:when>
					<xsl:when test="ancestor::un:sections">9.5</xsl:when>
				</xsl:choose>
			</xsl:if>
			
			
		</xsl:variable>
		
		<xsl:variable name="padding-right">
			<xsl:choose>
				<xsl:when test="normalize-space($padding) = ''">0</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$padding"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<fo:inline padding-right="{$padding-right}mm">&#x200B;</fo:inline>
		
	</xsl:template>
	
	
	<!-- convert YYYY-MM-DD to 'Month YYYY' or 'Month DD, YYYY' -->
	<xsl:template name="convertDate">
		<xsl:param name="date"/>
		<xsl:param name="format" select="'short'"/>
		<xsl:variable name="year" select="substring($date, 1, 4)"/>
		<xsl:variable name="month" select="substring($date, 6, 2)"/>
		<xsl:variable name="day" select="substring($date, 9, 2)"/>
		<xsl:variable name="monthStr">
			<xsl:choose>
				<xsl:when test="$month = '01'">January</xsl:when>
				<xsl:when test="$month = '02'">February</xsl:when>
				<xsl:when test="$month = '03'">March</xsl:when>
				<xsl:when test="$month = '04'">April</xsl:when>
				<xsl:when test="$month = '05'">May</xsl:when>
				<xsl:when test="$month = '06'">June</xsl:when>
				<xsl:when test="$month = '07'">July</xsl:when>
				<xsl:when test="$month = '08'">August</xsl:when>
				<xsl:when test="$month = '09'">September</xsl:when>
				<xsl:when test="$month = '10'">October</xsl:when>
				<xsl:when test="$month = '11'">November</xsl:when>
				<xsl:when test="$month = '12'">December</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="result">
			<xsl:choose>
				<xsl:when test="$format = 'short' or $day = ''">
					<xsl:value-of select="normalize-space(concat($monthStr, ' ', $year))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space(concat($monthStr, ' ', $day, ', ' , $year))"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$result"/>
	</xsl:template>

	<xsl:template name="insertKeywords">
		<xsl:param name="sorting" select="'true'"/>
		<xsl:param name="charAtEnd" select="'.'"/>
		<xsl:param name="charDelim" select="', '"/>
		<xsl:choose>
			<xsl:when test="$sorting = 'true' or $sorting = 'yes'">
				<xsl:for-each select="/*/*[local-name() = 'bibdata']//*[local-name() = 'keyword']">
					<xsl:sort data-type="text" order="ascending"/>
					<xsl:call-template name="insertKeyword">
						<xsl:with-param name="charAtEnd" select="$charAtEnd"/>
						<xsl:with-param name="charDelim" select="$charDelim"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="/*/*[local-name() = 'bibdata']//*[local-name() = 'keyword']">
					<xsl:call-template name="insertKeyword">
						<xsl:with-param name="charAtEnd" select="$charAtEnd"/>
						<xsl:with-param name="charDelim" select="$charDelim"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="insertKeyword">
		<xsl:param name="charAtEnd"/>
		<xsl:param name="charDelim"/>
		<xsl:apply-templates/>
		<xsl:choose>
			<xsl:when test="position() != last()"><xsl:value-of select="$charDelim"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$charAtEnd"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="addPDFUAmeta">
		<fo:declarations>
			<pdf:catalog xmlns:pdf="http://xmlgraphics.apache.org/fop/extensions/pdf">
					<pdf:dictionary type="normal" key="ViewerPreferences">
						<pdf:boolean key="DisplayDocTitle">true</pdf:boolean>
					</pdf:dictionary>
				</pdf:catalog>
			<x:xmpmeta xmlns:x="adobe:ns:meta/">
				<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
					<rdf:Description rdf:about="" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:pdf="http://ns.adobe.com/pdf/1.3/">
					<!-- Dublin Core properties go here -->
						<dc:title>
							<xsl:variable name="title">
								<xsl:if test="$namespace = 'iso' or $namespace = 'gb' or $namespace = 'iec' or $namespace = 'nist' or $namespace = 'unece' or $namespace = 'unece-rec'">
									<xsl:value-of select="/*/*[local-name() = 'bibdata']/*[local-name() = 'title'][@language = 'en' and @type = 'main']"/>
								</xsl:if>
								<xsl:if test="$namespace = 'iho' or $namespace = 'csa' or $namespace = 'csd' or $namespace = 'rsd' or $namespace = 'ogc'">								
									<xsl:value-of select="/*/*[local-name() = 'bibdata']/*[local-name() = 'title'][@language = 'en']"/>
								</xsl:if>
								<xsl:if test="$namespace = 'm3d'">
									<xsl:value-of select="/*/*[local-name() = 'bibdata']/*[local-name() = 'title']"/>
								</xsl:if>
								<xsl:if test="$namespace = 'itu'">
									<xsl:value-of select="/*/*[local-name() = 'bibdata']/*[local-name() = 'title'][@type='main']"/>
								</xsl:if>								
							</xsl:variable>
							<xsl:choose>
								<xsl:when test="normalize-space($title) != ''">
									<xsl:value-of select="$title"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>&#xA0;</xsl:text>
								</xsl:otherwise>
							</xsl:choose>							
						</dc:title>
						<dc:creator>
							<xsl:if test="$namespace = 'iso' or $namespace = 'itu' or $namespace = 'gb' or $namespace = 'iho' or $namespace = 'm3d'">
								<xsl:value-of select="/*/*[local-name() = 'bibdata']/*[local-name() = 'contributor'][*[local-name() = 'role']/@type='author']/*[local-name() = 'organization']/*[local-name() = 'name']"/>
							</xsl:if>
							<xsl:if test="$namespace = 'nist'">
								<xsl:for-each select="/*/*[local-name() = 'bibdata']/*[local-name() = 'contributor'][*[local-name() = 'role']/@type='author']">
									<xsl:value-of select="*[local-name() = 'person']/*[local-name() = 'name']/*[local-name() = 'completename']"/>
									<xsl:if test="position() != last()">; </xsl:if>
								</xsl:for-each>
							</xsl:if>
						</dc:creator>
						<dc:description>
							<xsl:variable name="abstract">
								<xsl:if test="$namespace = 'iso' or $namespace = 'csd' or $namespace = 'gb' or $namespace = 'iho'">
									<xsl:copy-of select="/*/*[local-name() = 'bibliography']/*[local-name() = 'references']/*[local-name() = 'bibitem']/*[local-name() = 'abstract']//text()"/>
								</xsl:if>
								<xsl:if test="$namespace = 'iec'">
									<xsl:copy-of select="/*/*[local-name() = 'bibliography']/*[local-name() = 'references']/*[local-name() = 'bibitem']/*[local-name() = 'abstract'][@language = 'en']//text()"/>
								</xsl:if>
								<xsl:if test="$namespace = 'nist' or $namespace = 'unece' or $namespace = 'unece-rec'">
									<xsl:copy-of select="/*/*[local-name() = 'preface']/*[local-name() = 'abstract']//text()"/>									
								</xsl:if>
								<xsl:if test="$namespace = 'itu' or $namespace = 'rsd' or $namespace = 'ogc' or $namespace = 'csa'">
									<xsl:copy-of select="/*/*[local-name() = 'bibdata']/*[local-name() = 'abstract']//text()"/>									
								</xsl:if>
							</xsl:variable>
							<xsl:value-of select="normalize-space($abstract)"/>
						</dc:description>
						<pdf:Keywords>
							<xsl:call-template name="insertKeywords"/>
						</pdf:Keywords>
					</rdf:Description>
					<rdf:Description rdf:about=""
							xmlns:xmp="http://ns.adobe.com/xap/1.0/">
						<!-- XMP properties go here -->
						<xmp:CreatorTool></xmp:CreatorTool>
					</rdf:Description>
				</rdf:RDF>
			</x:xmpmeta>
		</fo:declarations>
	</xsl:template>
	
	<xsl:template name="getId">
		<xsl:choose>
			<xsl:when test="../@id">
				<xsl:value-of select="../@id"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- <xsl:value-of select="concat(local-name(..), '_', text())"/> -->
				<xsl:value-of select="concat(generate-id(..), '_', text())"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="getLevel">
		<xsl:param name="depth"/>
		<xsl:choose>
			<xsl:when test="normalize-space(@depth) != ''">
				<xsl:value-of select="@depth"/>
			</xsl:when>
			<xsl:when test="normalize-space($depth) != ''">
				<xsl:value-of select="$depth"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="level_total" select="count(ancestor::*)"/>
				<xsl:variable name="level">
					<xsl:choose>
						<xsl:when test="ancestor::*[local-name() = 'preface']">
							<xsl:value-of select="$level_total - 2"/>
						</xsl:when>
						<xsl:when test="ancestor::*[local-name() = 'sections']">
							<xsl:value-of select="$level_total - 2"/>
						</xsl:when>
						<xsl:when test="ancestor::*[local-name() = 'bibliography']">
							<xsl:value-of select="$level_total - 2"/>
						</xsl:when>
						<xsl:when test="local-name(ancestor::*[1]) = 'annex'">1</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$level_total - 1"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:value-of select="$level"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="getSubSection">
		<xsl:number format=".1" 
										level="multiple" 
										count="*[local-name() = 'clause']/*[local-name() = 'clause'] | 
																*[local-name() = 'clause']/*[local-name() = 'terms'] | 
																*[local-name() = 'terms']/*[local-name() = 'term'] | 
																*[local-name() = 'clause']/*[local-name() = 'term'] |  
																*[local-name() = 'terms']/*[local-name() = 'clause'] |
																*[local-name() = 'terms']/*[local-name() = 'definitions'] |
																*[local-name() = 'definitions']/*[local-name() = 'clause'] |
																*[local-name() = 'clause']/*[local-name() = 'definitions'] |
																*[local-name() = 'definitions']/*[local-name() = 'definitions'] |
																*[local-name() = 'clause']/*[local-name() = 'references']"/>
	</xsl:template>
	
	<xsl:template name="split">
		<xsl:param name="pText" select="."/>
		<xsl:param name="sep" select="','"/>
		<xsl:if test="string-length($pText) >0">
		<item>
			<xsl:value-of select="normalize-space(substring-before(concat($pText, ','), $sep))"/>
		</item>
		<xsl:call-template name="split">
			<xsl:with-param name="pText" select="substring-after($pText, $sep)"/>
			<xsl:with-param name="sep" select="$sep"/>
		</xsl:call-template>
		</xsl:if>
	</xsl:template>
 
	<xsl:template name="getDocumentId">		
		<xsl:call-template name="getLang"/><xsl:value-of select="//*[local-name() = 'p'][1]/@id"/>
	</xsl:template>

	<xsl:template name="namespaceCheck">
		<xsl:variable name="documentNS" select="namespace-uri(/*)"/>
		<xsl:variable name="XSLNS">			
			<xsl:if test="$namespace = 'iso'">
				<xsl:value-of select="document('')//*/namespace::iso"/>
			</xsl:if>
			<xsl:if test="$namespace = 'iec'">
				<xsl:value-of select="document('')//*/namespace::iec"/>
			</xsl:if>
			<xsl:if test="$namespace = 'itu'">
				<xsl:value-of select="document('')//*/namespace::itu"/>
			</xsl:if>
			<xsl:if test="$namespace = 'unece' or $namespace = 'unece-rec'">
				<xsl:value-of select="document('')//*/namespace::un"/>
			</xsl:if>
			<xsl:if test="$namespace = 'nist'">
				<xsl:value-of select="document('')//*/namespace::nist"/>
			</xsl:if>
			<xsl:if test="$namespace = 'ogc'">
				<xsl:value-of select="document('')//*/namespace::ogc"/>
			</xsl:if>
			<xsl:if test="$namespace = 'rsd'">
				<xsl:value-of select="document('')//*/namespace::rsd"/>
			</xsl:if>
			<xsl:if test="$namespace = 'csa'">
				<xsl:value-of select="document('')//*/namespace::csa"/>
			</xsl:if>
			<xsl:if test="$namespace = 'csd'">
				<xsl:value-of select="document('')//*/namespace::csd"/>
			</xsl:if>
			<xsl:if test="$namespace = 'm3d'">
				<xsl:value-of select="document('')//*/namespace::m3d"/>
			</xsl:if>
			<xsl:if test="$namespace = 'iho'">
				<xsl:value-of select="document('')//*/namespace::iho"/>
			</xsl:if>			
			<xsl:if test="$namespace = 'gb'">
				<xsl:value-of select="document('')//*/namespace::gb"/>
			</xsl:if>			
		</xsl:variable>
		<xsl:if test="$documentNS != $XSLNS">
			<xsl:message>[WARNING]: Document namespace: '<xsl:value-of select="$documentNS"/>' doesn't equal to xslt namespace '<xsl:value-of select="$XSLNS"/>'</xsl:message>
		</xsl:if>
	</xsl:template>
 
	<xsl:template name="getLanguage">
		<xsl:param name="lang"/>		
		<xsl:variable name="language" select="java:toLowerCase(java:java.lang.String.new($lang))"/>
		<xsl:choose>
			<xsl:when test="$language = 'en'">English</xsl:when>
			<xsl:when test="$language = 'fr'">French</xsl:when>
			<xsl:when test="$language = 'de'">Deutsch</xsl:when>
			<xsl:when test="$language = 'cn'">Chinese</xsl:when>
			<xsl:otherwise><xsl:value-of select="$language"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
 
</xsl:stylesheet>
