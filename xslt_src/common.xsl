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
				
		<title-annex lang="en">Annex </title-annex>
		<title-annex lang="fr">Annexe </title-annex>
		<xsl:if test="$namespace = 'bsi' or $namespace = 'iso' or $namespace = 'iec' or $namespace = 'itu' or $namespace = 'unece' or $namespace = 'unece-rec' or $namespace = 'nist-cswp'  or $namespace = 'nist-sp' or $namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'rsd' or $namespace = 'csa' or $namespace = 'csd' or $namespace = 'm3d' or $namespace = 'iho' or $namespace = 'bipm'">
			<title-annex lang="zh">Annex </title-annex>
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			<title-annex lang="zh">附件 </title-annex>			
		</xsl:if>
				
		<title-edition lang="en">
			<xsl:if test="$namespace = 'bsi' or $namespace = 'iso' or $namespace = 'iec' or $namespace = 'itu' or $namespace = 'unece' or $namespace = 'unece-rec' or $namespace = 'nist-cswp'  or $namespace = 'nist-sp' or $namespace = 'csd' or $namespace = 'iho' or $namespace = 'mpfd' or $namespace = 'bipm' or $namespace = 'jcgm'">
				<xsl:text>Edition </xsl:text>
			</xsl:if>
			<xsl:if test="$namespace = 'csa' or $namespace = 'm3d' or $namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'rsd'">
				<xsl:text>Version</xsl:text>
			</xsl:if>
		</title-edition>
		
		<title-edition lang="fr">
			<xsl:if test="$namespace = 'bsi' or $namespace = 'iso' or $namespace = 'iec' or $namespace = 'itu' or $namespace = 'unece' or $namespace = 'unece-rec' or $namespace = 'nist-cswp'  or $namespace = 'nist-sp' or $namespace = 'csd' or $namespace = 'iho' or $namespace = 'mpfd' or $namespace = 'csa' or $namespace = 'm3d' or $namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'rsd' or $namespace = 'bipm' or $namespace = 'jcgm'">
				<xsl:text>Édition </xsl:text>
			</xsl:if>
		</title-edition>
		

		<title-toc lang="en">
			<xsl:if test="$namespace = 'bsi' or $namespace = 'iso' or $namespace = 'iec' or $namespace = 'iho' or $namespace = 'csd' or $namespace = 'rsd' or $namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'unece-rec' or $namespace = 'mpfd' or $namespace = 'bipm'">
				<xsl:text>Contents</xsl:text>
			</xsl:if>
			<xsl:if test="$namespace = 'itu' or $namespace = 'csa' or $namespace = 'm3d' or $namespace = 'nist-cswp'  or $namespace = 'nist-sp'">
				<xsl:text>Table of Contents</xsl:text>
			</xsl:if>
			<xsl:if test="$namespace = 'gb'">
				<xsl:text>Table of contents</xsl:text>
			</xsl:if>
		</title-toc>
		<title-toc lang="fr">
			<xsl:if test="$namespace = 'bsi' or $namespace = 'iso' or $namespace = 'iec' or $namespace = 'iho' or $namespace = 'csd' or $namespace = 'rsd' or $namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'unece-rec' or $namespace = 'mpfd' or $namespace = 'itu' or $namespace = 'csa' or $namespace = 'm3d' or $namespace = 'nist-cswp'  or $namespace = 'nist-sp' or $namespace = 'gb'">
				<xsl:text>Sommaire</xsl:text>
			</xsl:if>
			<xsl:if test="$namespace = 'bipm'">
				<xsl:text>Table des matières</xsl:text>
			</xsl:if>
			</title-toc>
		<xsl:if test="$namespace = 'bsi' or $namespace = 'iso' or $namespace = 'iec' or $namespace = 'itu' or $namespace = 'unece' or $namespace = 'unece-rec' or $namespace = 'nist-cswp'  or $namespace = 'nist-sp' or $namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'rsd' or $namespace = 'csa' or $namespace = 'csd' or $namespace = 'm3d' or $namespace = 'iho' or $namespace = 'bipm'">
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
			<xsl:if test="$namespace = 'bsi' or $namespace = 'iso'">
				<xsl:text>Part #:</xsl:text>
			</xsl:if>
			<xsl:if test="$namespace = 'iec' or $namespace = 'gb'">
				<xsl:text>Part #: </xsl:text>
			</xsl:if>
			<xsl:if test="$namespace = 'bipm'">
				<xsl:text>Part #</xsl:text>
			</xsl:if>
		</title-part>
		<title-part lang="fr">
			<xsl:if test="$namespace = 'bsi' or $namespace = 'iso'">
				<xsl:text>Partie #:</xsl:text>
			</xsl:if>
			<xsl:if test="$namespace = 'iec' or $namespace = 'gb'">
				<xsl:text>Partie #:  </xsl:text>
			</xsl:if>
			<xsl:if test="$namespace = 'bipm'">
				<xsl:text>Partie #</xsl:text>
			</xsl:if>
		</title-part>		
		<title-part lang="zh">第 # 部分:</title-part>
		
		<title-subpart lang="en">			
			<xsl:if test="$namespace = 'bipm'">
				<xsl:text>Sub-part #</xsl:text>
			</xsl:if>
		</title-subpart>
		<title-subpart lang="fr">		
			<xsl:if test="$namespace = 'bipm'">
				<xsl:text>Partie de sub #</xsl:text>
			</xsl:if>
		</title-subpart>
		
		<title-modified lang="en">modified</title-modified>
		<title-modified lang="fr">modifiée</title-modified>
		<xsl:if test="$namespace = 'bsi' or $namespace = 'iso' or $namespace = 'iec' or $namespace = 'itu' or $namespace = 'unece' or $namespace = 'unece-rec' or $namespace = 'nist-cswp'  or $namespace = 'nist-sp' or $namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'rsd' or $namespace = 'csa' or $namespace = 'csd' or $namespace = 'm3d' or $namespace = 'iho' or $namespace = 'mpfd' or $namespace = 'bipm'">
			<title-modified lang="zh">modified</title-modified>
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			<title-modified lang="zh">改写</title-modified>			
		</xsl:if>
		
		<title-source lang="en">
			<xsl:if test="$namespace = 'bsi' or $namespace = 'gb' or $namespace = 'iso' or $namespace = 'iec' or $namespace = 'itu' or $namespace = 'unece' or $namespace = 'unece-rec' or $namespace = 'nist-cswp'  or $namespace = 'nist-sp' or $namespace = 'ogc-white-paper' or $namespace = 'rsd' or $namespace = 'csa' or $namespace = 'csd' or $namespace = 'm3d' or $namespace = 'iho' or $namespace = 'mpfd' or $namespace = 'bipm'">
				<xsl:text>SOURCE</xsl:text>
			</xsl:if>			
			 <xsl:if test="$namespace = 'ogc'">
				<xsl:text>Source</xsl:text>
			 </xsl:if>
		</title-source>
		
		<title-keywords lang="en">Keywords</title-keywords>
		
		<title-deprecated lang="en">DEPRECATED</title-deprecated>
		<title-deprecated lang="fr">DEPRECATED</title-deprecated>
				
		<title-list-tables lang="en">List of Tables</title-list-tables>
		
		<title-list-figures lang="en">List of Figures</title-list-figures>
		
		<title-table-figures lang="en">Table of Figures</title-table-figures>
		
		<title-list-recommendations lang="en">List of Recommendations</title-list-recommendations>
		
		<title-acknowledgements lang="en">Acknowledgements</title-acknowledgements>
		
		<title-abstract lang="en">Abstract</title-abstract>
		
		<title-summary lang="en">Summary</title-summary>
		
		<title-in lang="en">in </title-in>
		
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
		
		<title-continued  lang="en">(continued)</title-continued>
		<title-continued  lang="fr">(continué)</title-continued>
		
	</xsl:variable>

	<xsl:variable name="bibdata">
		<xsl:copy-of select="//*[contains(local-name(), '-standard')]/*[local-name() = 'bibdata']" />
		<xsl:copy-of select="//*[contains(local-name(), '-standard')]/*[local-name() = 'localized-strings']" />
	</xsl:variable>
	
	<xsl:variable name="tab_zh">&#x3000;</xsl:variable>
	
	<xsl:template name="getTitle">
		<xsl:param name="name"/>
		<xsl:param name="lang"/>
		<xsl:variable name="lang_">
			<xsl:choose>
				<xsl:when test="$lang != ''">
					<xsl:value-of select="$lang"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="getLang"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="language" select="normalize-space($lang_)"/>
		<xsl:variable name="title_" select="$titles/*[local-name() = $name][@lang = $language]"/>
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
	
	<xsl:attribute-set name="root-style">
		<xsl:if test="$namespace = 'bipm' or $namespace = 'jcgm'">
			<xsl:attribute name="font-family">Times New Roman, STIX Two Math, Source Han Sans</xsl:attribute>
			<xsl:attribute name="font-size">10.5pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="font-family">Times New Roman, STIX Two Math</xsl:attribute>
			<xsl:attribute name="font-size">12pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
		
	<xsl:attribute-set name="link-style">
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="color">rgb(58,88,168)</xsl:attribute>
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso' or $namespace = 'csd' or $namespace = 'ogc-white-paper' or $namespace = 'm3d' or $namespace = 'iho' or $namespace = 'mpfd' or $namespace = 'bipm' or $namespace = 'jcgm'">
			<xsl:attribute name="color">blue</xsl:attribute>
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="color"><xsl:value-of select="$color_blue"/></xsl:attribute>
			<xsl:attribute name="font-weight">300</xsl:attribute><!-- bold -->
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<!-- <xsl:attribute name="color">rgb(33, 55, 92)</xsl:attribute> -->
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="color">rgb(33, 94, 159)</xsl:attribute>
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>

	<xsl:attribute-set name="sourcecode-style">
		<xsl:attribute name="white-space">pre</xsl:attribute>
		<xsl:attribute name="wrap-option">wrap</xsl:attribute>
		<xsl:attribute name="role">Code</xsl:attribute>
		<xsl:if test="$namespace = 'bsi' or $namespace = 'iso' or $namespace = 'gb' or $namespace = 'jcgm'">
			<xsl:attribute name="font-family">Courier New</xsl:attribute>			
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa' or $namespace = 'rsd'">
			<xsl:attribute name="font-family">Source Code Pro</xsl:attribute>			
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="line-height">113%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csd'">
			<xsl:attribute name="font-family">Source Code Pro</xsl:attribute>			
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>					
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="font-family">Courier New</xsl:attribute>			
			<xsl:attribute name="margin-top">5pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">5pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu' or $namespace = 'nist-cswp'  or $namespace = 'nist-sp' or $namespace = 'unece' or $namespace = 'unece-rec'">
			<xsl:attribute name="font-family">Courier New</xsl:attribute>			
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'm3d'">
			<xsl:attribute name="font-family">Courier New</xsl:attribute>			
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>		
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="font-family">Fira Code</xsl:attribute>			
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>			
			<xsl:attribute name="line-height">113%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:attribute name="font-family">Courier New</xsl:attribute>			
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="line-height">113%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="font-family">Fira Code</xsl:attribute>			
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="line-height">113%</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>


	<xsl:attribute-set name="permission-style">
		<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>

	<xsl:attribute-set name="permission-name-style">
		<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>			
			<xsl:attribute name="padding-top">0.5mm</xsl:attribute>
			<xsl:attribute name="padding-bottom">1mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">1mm</xsl:attribute>
			<xsl:attribute name="background-color">rgb(165,165,165)</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>

	<xsl:attribute-set name="permission-label-style">
		<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>

	<xsl:attribute-set name="requirement-style">
		<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>

	<xsl:attribute-set name="requirement-name-style">
		<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>			
			<xsl:attribute name="padding-top">0.5mm</xsl:attribute>
			<xsl:attribute name="padding-bottom">1mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">1mm</xsl:attribute>
			<xsl:attribute name="background-color">rgb(165,165,165)</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>

	<xsl:attribute-set name="requirement-label-style">
		<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>

	<xsl:attribute-set name="subject-style">
	</xsl:attribute-set>
	
	<xsl:attribute-set name="inherit-style">
	</xsl:attribute-set>
	
	<xsl:attribute-set name="description-style">
	</xsl:attribute-set>
	
	<xsl:attribute-set name="specification-style">
	</xsl:attribute-set>
	
	<xsl:attribute-set name="measurement-target-style">
	</xsl:attribute-set>
	
	<xsl:attribute-set name="verification-style">
	</xsl:attribute-set>
	
	<xsl:attribute-set name="import-style">
	</xsl:attribute-set>
	
	<xsl:attribute-set name="recommendation-style">
		<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-sp'">
			<xsl:attribute name="margin-left">20mm</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="recommendation-name-style">
		<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>			
			<xsl:attribute name="padding-top">0.5mm</xsl:attribute>
			<xsl:attribute name="padding-bottom">1mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">1mm</xsl:attribute>
			<xsl:attribute name="background-color">rgb(165,165,165)</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-sp'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="recommendation-label-style">
		<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	
	<xsl:attribute-set name="termexample-style">
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="margin-top">14pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">10pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa' or $namespace = 'csd' or $namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="font-size">9pt</xsl:attribute>
			<xsl:attribute name="margin-top">14pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">14pt</xsl:attribute>
			<xsl:attribute name="text-align">justify</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bsi' or $namespace = 'iho' or $namespace = 'iso' or $namespace = 'jcgm'">
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
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>

	</xsl:attribute-set>

	<xsl:attribute-set name="example-style">
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'csd'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'bsi' or $namespace = 'gb' or $namespace = 'iso' or $namespace = 'jcgm'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-top">8pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="margin-top">8pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'm3d'">
			<xsl:attribute name="margin-top">8pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">			
			<xsl:attribute name="margin-top">10pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">10pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>			
			<xsl:attribute name="margin-left">12.5mm</xsl:attribute>
			<xsl:attribute name="margin-right">12.5mm</xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="margin-left">15mm</xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'nist-sp'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="margin-left">12.5mm</xsl:attribute>			
			<xsl:attribute name="margin-right">12.5mm</xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="margin-top">12pt</xsl:attribute>			
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>			
		</xsl:if>
	</xsl:attribute-set>

	<xsl:attribute-set name="example-body-style">
		<xsl:if test="$namespace = 'csa'">			
			<xsl:attribute name="margin-left">12.5mm</xsl:attribute>
			<xsl:attribute name="margin-right">12.5mm</xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'csd'">
			<xsl:attribute name="margin-left">12.5mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'mpfd'">
			<xsl:attribute name="margin-left">12.5mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">18pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	

	<xsl:attribute-set name="example-name-style">
		<xsl:if test="$namespace = 'csa'">			
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csd'">			
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bsi' or $namespace = 'gb' or $namespace = 'iso' or $namespace = 'jcgm'">
			 <xsl:attribute name="padding-right">5mm</xsl:attribute>
			 <xsl:attribute name="keep-with-next">always</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="padding-right">9mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'm3d'">
			<xsl:attribute name="padding-right">5mm</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>			
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-sp'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>			 
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>			
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>			 
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="color"><xsl:value-of select="$color_blue"/></xsl:attribute>
			<xsl:attribute name="padding-right">0.5mm</xsl:attribute>
		</xsl:if>		
		<xsl:if test="$namespace = 'unece' or $namespace = 'unece-rec'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>			
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
		</xsl:if>		
		
		<xsl:if test="$namespace = 'mpfd'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>			
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="font-style">italic</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>

	<xsl:attribute-set name="example-p-style">
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="margin-bottom">14pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csd'">			
			<xsl:attribute name="margin-bottom">14pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb' or $namespace = 'iso' or $namespace = 'jcgm'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-top">8pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="margin-left">12.7mm</xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'bsi' or $namespace = 'iso'">
			<xsl:attribute name="text-align">justify</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'm3d'">
			<xsl:attribute name="margin-top">8pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'rsd'">			
			<xsl:attribute name="margin-bottom">14pt</xsl:attribute>
		</xsl:if>
		
		<xsl:if test="$namespace = 'unece' or $namespace = 'unece-rec'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="margin-left">15mm</xsl:attribute>			
		</xsl:if>
		
		<xsl:if test="$namespace = 'mpfd'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>			
		</xsl:if>
		
	</xsl:attribute-set>

	<xsl:attribute-set name="termexample-name-style">
		<xsl:if test="$namespace = 'csa' or $namespace = 'csd' or $namespace = 'iec' or $namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="padding-right">10mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="padding-right">1mm</xsl:attribute>
			<xsl:attribute name="font-family">SimHei</xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'bsi' or $namespace = 'iho' or $namespace = 'iso' or $namespace = 'jcgm'">
			<xsl:attribute name="padding-right">5mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'm3d'">
			<xsl:attribute name="padding-right">1mm</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>			
		</xsl:if>		
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="color"><xsl:value-of select="$color_blue"/></xsl:attribute>
			<xsl:attribute name="padding-right">0.5mm</xsl:attribute>
		</xsl:if>		
	</xsl:attribute-set>

	<xsl:variable name="table-border_">
		<xsl:if test="$namespace = 'bsi'">0.5pt solid black</xsl:if>
	</xsl:variable>
	<xsl:variable name="table-border" select="normalize-space($table-border_)"/>
	
	<xsl:attribute-set name="table-name-style">
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
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="space-before">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="font-weight">normal</xsl:attribute>
			<xsl:attribute name="font-size">11pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso' or $namespace = 'jcgm'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<!-- <xsl:attribute name="margin-top">12pt</xsl:attribute> -->
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>			
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
			<xsl:attribute name="color"><xsl:value-of select="$color_blue"/></xsl:attribute>
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
			<xsl:attribute name="margin-left">25mm</xsl:attribute>
			<xsl:attribute name="text-indent">-25mm</xsl:attribute>
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
	</xsl:attribute-set>

	<xsl:attribute-set name="table-footer-cell-style">
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="border">solid black 0pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	
	<xsl:attribute-set name="appendix-style">
		<xsl:if test="$namespace = 'bsi' or $namespace = 'iso' or $namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'm3d' or $namespace = 'gb' or $namespace = 'csd' or $namespace = 'jcgm'">		
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
			<xsl:attribute name="font-weight">normal</xsl:attribute>
			<xsl:attribute name="color">black</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="appendix-example-style">
		<xsl:if test="$namespace = 'bsi' or $namespace = 'iso' or $namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'm3d' or $namespace = 'gb' or $namespace = 'csd' or $namespace = 'jcgm'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>			
			<xsl:attribute name="margin-top">8pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="margin-top">14pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">14pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-weight">normal</xsl:attribute>
			<xsl:attribute name="color">black</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="xref-style">
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="color">rgb(58,88,168)</xsl:attribute>
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho' or $namespace = 'iso' or $namespace = 'itu' or $namespace = 'nist-cswp'  or $namespace = 'nist-sp' or $namespace = 'ogc-white-paper' or $namespace = 'mpfd' or $namespace = 'jcgm'">
			<xsl:attribute name="color">blue</xsl:attribute>
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
		</xsl:if>
	</xsl:attribute-set>

	<xsl:attribute-set name="eref-style">
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="color">rgb(58,88,168)</xsl:attribute>
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="color">rgb(33, 94, 159)</xsl:attribute>
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csd' or $namespace = 'itu' or $namespace = 'ogc-white-paper' or $namespace = 'mpfd'">
			<xsl:attribute name="color">blue</xsl:attribute>
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp' or $namespace = 'nist-sp' or $namespace = 'unece'">
			<xsl:attribute name="color">blue</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
		</xsl:if>
	</xsl:attribute-set>


	<xsl:attribute-set name="note-style">
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="font-size">9pt</xsl:attribute>
			<xsl:attribute name="font-style">italic</xsl:attribute>
			<xsl:attribute name="space-before">5pt</xsl:attribute>
			<xsl:attribute name="space-after">5pt</xsl:attribute>
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
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="margin-top">8pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
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
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="margin-top">12pt</xsl:attribute>			
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>			
		</xsl:if>
	</xsl:attribute-set>
	
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
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="padding-right">2mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso' or $namespace = 'jcgm'">
			<xsl:attribute name="padding-right">6mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
		</xsl:if>
		<xsl:if test="$namespace = 'm3d'">
			<xsl:attribute name="padding-right">5mm</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="padding-right">1mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:attribute name="padding-right">4mm</xsl:attribute>
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
	
	<xsl:attribute-set name="table-note-name-style">
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="font-family">SimHei</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="padding-right">3mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="color"><xsl:value-of select="$color_blue"/></xsl:attribute>
			<xsl:attribute name="padding-right">0.5mm</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	
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
		<xsl:if test="$namespace = 'ogc'">			
			<xsl:attribute name="margin-top">12pt</xsl:attribute>			
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>						
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>

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
		<xsl:if test="$namespace = 'rsd'">
				<xsl:attribute name="font-weight">bold</xsl:attribute>
				<xsl:attribute name="color"><xsl:value-of select="$color_blue"/></xsl:attribute>
				<xsl:attribute name="padding-right">0.5mm</xsl:attribute>
			</xsl:if>
	</xsl:attribute-set>

	<xsl:attribute-set name="quote-style">
		<xsl:attribute name="role">BlockQuote</xsl:attribute>
		<xsl:if test="$namespace = 'csa' or $namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'rsd'">
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-left">13mm</xsl:attribute>
			<xsl:attribute name="margin-right">12mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bsi' or $namespace = 'csd' or $namespace = 'gb' or $namespace = 'iso' or $namespace = 'm3d'">
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-left">12mm</xsl:attribute>
			<xsl:attribute name="margin-right">12mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jcgm'">
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-left">12mm</xsl:attribute>
			<xsl:attribute name="margin-right">12mm</xsl:attribute>
			<xsl:attribute name="font-style">italic</xsl:attribute>
			<xsl:attribute name="text-align">justify</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="margin-top">5pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">10pt</xsl:attribute>
			<xsl:attribute name="margin-left">12mm</xsl:attribute>
			<xsl:attribute name="margin-right">12mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">			
			<xsl:attribute name="margin-left">12.5mm</xsl:attribute>
			<xsl:attribute name="margin-right">14mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="margin-left">12mm</xsl:attribute>
			<xsl:attribute name="margin-right">12mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'mpfd'">
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-left">12mm</xsl:attribute>
			<xsl:attribute name="margin-right">12mm</xsl:attribute>
			<xsl:attribute name="text-align">justify</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	
	<xsl:attribute-set name="quote-source-style">		
		<xsl:if test="$namespace = 'csa' or $namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'rsd'">
			<xsl:attribute name="text-align">right</xsl:attribute>
			<xsl:attribute name="margin-right">25mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bsi' or $namespace = 'csd' or $namespace = 'gb' or $namespace = 'iho' or $namespace = 'iso' or $namespace = 'itu' or $namespace = 'm3d' or $namespace = 'jcgm'">
			<xsl:attribute name="text-align">right</xsl:attribute>			
		</xsl:if>		
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="text-align">right</xsl:attribute>
			<xsl:attribute name="margin-top">15pt</xsl:attribute>
			<xsl:attribute name="margin-left">12mm</xsl:attribute>
			<xsl:attribute name="margin-right">12mm</xsl:attribute>			 
		</xsl:if>		
	</xsl:attribute-set>

	<xsl:attribute-set name="termsource-style">
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="text-align">right</xsl:attribute>
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa' or $namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csd' or $namespace = 'iec'">
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="text-indent">7.4mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso' or $namespace = 'jcgm'">
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="origin-style">
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="color">rgb(33, 94, 159)</xsl:attribute>
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="color">blue</xsl:attribute>
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
		</xsl:if>
	</xsl:attribute-set>

	<xsl:attribute-set name="term-style">
		<xsl:if test="$namespace = 'bsi' or $namespace = 'iho' or $namespace = 'iso' or $namespace = 'jcgm'">
			<xsl:attribute name="margin-bottom">10pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>

	<xsl:attribute-set name="figure-name-style">
		<xsl:if test="$namespace = 'bsi'">			
			<xsl:attribute name="font-weight">normal</xsl:attribute>
			<xsl:attribute name="font-style">italic</xsl:attribute>
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="text-align">left</xsl:attribute>
			<xsl:attribute name="space-before">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">2pt</xsl:attribute>
			<xsl:attribute name="margin-left">-20mm</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">left</xsl:attribute>			
			<xsl:attribute name="margin-left">19mm</xsl:attribute>
			<xsl:attribute name="text-indent">-19mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
		</xsl:if>		
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="color"><xsl:value-of select="$color_blue"/></xsl:attribute>
			<!-- <xsl:attribute name="margin-top">12pt</xsl:attribute> -->
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<!-- <xsl:attribute name="margin-bottom">6pt</xsl:attribute> -->
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<!-- <xsl:attribute name="keep-with-next">always</xsl:attribute> -->
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
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
		
		<xsl:if test="$namespace = 'csd' or $namespace = 'iec' or $namespace = 'iso' or $namespace = 'jcgm'">			
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">			
			<xsl:attribute name="font-family">SimHei</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu' or $namespace = 'nist-sp'">			
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>			
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'm3d'">			
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
		</xsl:if>
		
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-size">13pt</xsl:attribute>
			<xsl:attribute name="font-weight">300</xsl:attribute>
			<xsl:attribute name="color">black</xsl:attribute>
			<xsl:attribute name="text-align">left</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
		</xsl:if>
		

		<xsl:if test="$namespace = 'unece'">
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
		</xsl:if>
		
		<xsl:if test="$namespace = 'unece-rec'">
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="font-size">9pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="keep-together.within-column">always</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'mpfd'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
		</xsl:if>	
	</xsl:attribute-set>
	
	<xsl:attribute-set name="formula-style">
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>			
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="image-style">
		<xsl:attribute name="text-align">center</xsl:attribute>
		<xsl:if test="$namespace = 'bsi'">
			<!-- <xsl:attribute name="border">0.5pt solid black</xsl:attribute>
			<xsl:attribute name="padding">5mm</xsl:attribute> -->
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="space-before">12pt</xsl:attribute>
			<xsl:attribute name="space-after">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:attribute name="space-before">12pt</xsl:attribute>
			<xsl:attribute name="space-after">0pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="border">2pt solid black</xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'unece-rec'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>			
		</xsl:if>
		
	</xsl:attribute-set>

	<xsl:attribute-set name="figure-pseudocode-p-style">
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>

 
	
	<xsl:attribute-set name="image-graphic-style">
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="width">100%</xsl:attribute>
			<xsl:attribute name="content-height">100%</xsl:attribute>
			<xsl:attribute name="content-width">scale-to-fit</xsl:attribute>
			<xsl:attribute name="scaling">uniform</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa' or $namespace = 'csd' or $namespace = 'iho' or $namespace = 'iso' or 
											$namespace = 'ogc' or $namespace = 'ogc-white-paper' or
											$namespace = 'rsd' or 
											$namespace = 'unece-rec' or 
											$namespace = 'mpfd' or $namespace = 'bipm' or $namespace = 'jcgm'">
			<xsl:attribute name="width">100%</xsl:attribute>
			<xsl:attribute name="content-height">scale-to-fit</xsl:attribute>
			<xsl:attribute name="scaling">uniform</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb' or $namespace = 'm3d' or $namespace = 'unece'">
			<xsl:attribute name="width">100%</xsl:attribute>
			<xsl:attribute name="content-height">100%</xsl:attribute>
			<xsl:attribute name="content-width">scale-to-fit</xsl:attribute>
			<xsl:attribute name="scaling">uniform</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="width">75%</xsl:attribute>
			<xsl:attribute name="content-height">scale-to-fit</xsl:attribute>
			<xsl:attribute name="scaling">uniform</xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'itu' or $namespace = 'nist-cswp' or $namespace = 'nist-sp'">
			<xsl:attribute name="width">75%</xsl:attribute>
			<xsl:attribute name="content-height">100%</xsl:attribute>
			<xsl:attribute name="content-width">scale-to-fit</xsl:attribute>
			<xsl:attribute name="scaling">uniform</xsl:attribute>			
		</xsl:if>		

	</xsl:attribute-set>
	
	<xsl:attribute-set name="tt-style">
		<xsl:if test="$namespace = 'csa' or $namespace = 'csd' or $namespace = 'rsd'">
			<xsl:attribute name="font-family">Source Code Pro</xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'bsi' or $namespace = 'gb' or $namespace = 'iec' or $namespace = 'iho' or $namespace = 'iso' or $namespace = 'm3d' or 
										 $namespace = 'ogc-white-paper' or $namespace = 'jcgm'">
			<xsl:attribute name="font-family">Courier New</xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="font-family">Fira Code</xsl:attribute>			
		</xsl:if>
	</xsl:attribute-set>

	<xsl:attribute-set name="sourcecode-name-style">
		<xsl:attribute name="font-size">11pt</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="text-align">center</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		<xsl:attribute name="keep-with-previous">always</xsl:attribute>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-size">13pt</xsl:attribute>
			<xsl:attribute name="font-weight">300</xsl:attribute>
			<xsl:attribute name="color">black</xsl:attribute>
			<xsl:attribute name="text-align">left</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>

	<xsl:attribute-set name="domain-style">
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="padding-left">7.4mm</xsl:attribute>
		</xsl:if>		
	</xsl:attribute-set>

	<xsl:attribute-set name="admitted-style">
		<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jcgm'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="color">black</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>

	<xsl:attribute-set name="deprecates-style">
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="font-size">8pt</xsl:attribute>
			<xsl:attribute name="margin-top">5pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">5pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="color">black</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>


	<xsl:attribute-set name="definition-style">
		<xsl:if test="$namespace = 'csa' or $namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="space-after">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csd' or $namespace = 'iec' or $namespace = 'iho' or $namespace = 'iso' or $namespace = 'jcgm'">
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
			<xsl:attribute name="space-before">12pt</xsl:attribute>
			<xsl:attribute name="space-after">6pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>

	<xsl:variable name="color-added-text">
		<xsl:text>rgb(0, 255, 0)</xsl:text>
	</xsl:variable>
	<xsl:attribute-set name="add-style">
		<xsl:attribute name="color">red</xsl:attribute>
		<xsl:attribute name="text-decoration">underline</xsl:attribute>
		<!-- <xsl:attribute name="color">black</xsl:attribute>
		<xsl:attribute name="background-color"><xsl:value-of select="$color-added-text"/></xsl:attribute>
		<xsl:attribute name="padding-top">1mm</xsl:attribute>
		<xsl:attribute name="padding-bottom">0.5mm</xsl:attribute> -->
	</xsl:attribute-set>

	<xsl:variable name="color-deleted-text">
		<xsl:text>red</xsl:text>
	</xsl:variable>
	<xsl:attribute-set name="del-style">
		<xsl:attribute name="color"><xsl:value-of select="$color-deleted-text"/></xsl:attribute>
		<xsl:attribute name="text-decoration">line-through</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="mathml-style">
		<xsl:attribute name="font-family">STIX Two Math</xsl:attribute>
		<xsl:if test="$namespace = 'bsi' or $namespace = 'iso'">
			<xsl:attribute name="font-family">Cambria Math</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name= "font-size">11pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="list-style">
		<xsl:if test="$namespace = 'bsi'">
			
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="toc-style">
		<xsl:attribute name="line-height">135%</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:variable name="border-block-added">2.5pt solid rgb(0, 176, 80)</xsl:variable>
	<xsl:variable name="border-block-deleted">2.5pt solid rgb(255, 0, 0)</xsl:variable>
		
	<xsl:template name="OLD_processPrefaceSectionsDefault_Contents">
		<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='abstract']" mode="contents"/>
		<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='foreword']" mode="contents"/>
		<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='introduction']" mode="contents"/>
		<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name() != 'abstract' and local-name() != 'foreword' and local-name() != 'introduction' and local-name() != 'acknowledgements']" mode="contents"/>
		<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='acknowledgements']" mode="contents"/>
	</xsl:template>
	
	<xsl:template name="processPrefaceSectionsDefault_Contents">
		<xsl:for-each select="/*/*[local-name()='preface']/*">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:apply-templates select="." mode="contents"/>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template name="OLD_processMainSectionsDefault_Contents">
		<xsl:apply-templates select="/*/*[local-name()='sections']/*[local-name()='clause'][@type='scope']" mode="contents"/>			
		
		<!-- Normative references  -->
		<xsl:apply-templates select="/*/*[local-name()='bibliography']/*[local-name()='references'][@normative='true'] |
		/*/*[local-name()='bibliography']/*[local-name()='clause'][*[local-name()='references'][@normative='true']]" mode="contents"/>	
		<!-- Terms and definitions -->
		<xsl:apply-templates select="/*/*[local-name()='sections']/*[local-name()='terms'] | 
																						/*/*[local-name()='sections']/*[local-name()='clause'][.//*[local-name()='terms']] |
																						/*/*[local-name()='sections']/*[local-name()='definitions'] | 
																						/*/*[local-name()='sections']/*[local-name()='clause'][.//*[local-name()='definitions']]" mode="contents"/>		
		<!-- Another main sections -->
		<xsl:apply-templates select="/*/*[local-name()='sections']/*[local-name() != 'terms' and 
																																														local-name() != 'definitions' and 
																																														not(@type='scope') and
																																														not(local-name() = 'clause' and .//*[local-name()='terms']) and
																																														not(local-name() = 'clause' and .//*[local-name()='definitions'])]" mode="contents"/>
		<xsl:apply-templates select="/*/*[local-name()='annex']" mode="contents"/>		
		<!-- Bibliography -->
		<xsl:apply-templates select="/*/*[local-name()='bibliography']/*[local-name()='references'][not(@normative='true')] | 
					/*/*[local-name()='bibliography']/*[local-name()='clause'][*[local-name()='references'][not(@normative='true')]]" mode="contents"/>
		
	</xsl:template>


	<xsl:template name="processMainSectionsDefault_Contents">
		<xsl:for-each select="/*/*[local-name()='sections']/* | /*/*[local-name()='bibliography']/*[local-name()='references'][@normative='true']">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:apply-templates select="." mode="contents"/>
		</xsl:for-each>
		
		<xsl:for-each select="/*/*[local-name()='annex']">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:apply-templates select="." mode="contents"/>
		</xsl:for-each>
		
		<xsl:for-each select="/*/*[local-name()='bibliography']/*[not(@normative='true')] | 
								/*/*[local-name()='bibliography']/*[local-name()='clause'][*[local-name()='references'][not(@normative='true')]]">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:apply-templates select="." mode="contents"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="OLD_processPrefaceSectionsDefault">
		<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='abstract']" />
		<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='foreword']" />
		<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='introduction']" />
		<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name() != 'abstract' and local-name() != 'foreword' and local-name() != 'introduction' and local-name() != 'acknowledgements']" />
		<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='acknowledgements']" />
	</xsl:template>
	
	<xsl:template name="processPrefaceSectionsDefault">
		<xsl:for-each select="/*/*[local-name()='preface']/*">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:apply-templates select="."/>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template name="OLD_processMainSectionsDefault">			
		<xsl:apply-templates select="/*/*[local-name()='sections']/*[local-name()='clause'][@type='scope']" />
		<xsl:if test="$namespace = 'm3d'">
			<xsl:if test="/*/*[local-name()='bibliography']/*[local-name()='references'][@normative='true']">
			<fo:block break-after="page"/>			
			</xsl:if>
		</xsl:if>
		<!-- Normative references  -->
		<xsl:apply-templates select="/*/*[local-name()='bibliography']/*[local-name()='references'][@normative='true']" />
		<!-- Terms and definitions -->
		<xsl:apply-templates select="/*/*[local-name()='sections']/*[local-name()='terms'] | 
																						/*/*[local-name()='sections']/*[local-name()='clause'][.//*[local-name()='terms']] |
																						/*/*[local-name()='sections']/*[local-name()='definitions'] | 
																						/*/*[local-name()='sections']/*[local-name()='clause'][.//*[local-name()='definitions']]" />
		<!-- Another main sections -->
		<xsl:apply-templates select="/*/*[local-name()='sections']/*[local-name() != 'terms' and 
																																														local-name() != 'definitions' and 
																																														not(@type='scope') and
																																														not(local-name() = 'clause' and .//*[local-name()='terms']) and
																																														not(local-name() = 'clause' and .//*[local-name()='definitions'])]" />
		<xsl:apply-templates select="/*/*[local-name()='annex']" />
		<!-- Bibliography -->
		<xsl:apply-templates select="/*/*[local-name()='bibliography']/*[local-name()='references'][not(@normative='true')]" />
	</xsl:template>
	
	
	<xsl:template name="processMainSectionsDefault">
		<xsl:for-each select="/*/*[local-name()='sections']/* | /*/*[local-name()='bibliography']/*[local-name()='references'][@normative='true']">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:apply-templates select="."/>
			<xsl:if test="$namespace = 'm3d'">
				<xsl:if test="local-name()='clause' and @type='scope'">
					<xsl:if test="/*/*[local-name()='bibliography']/*[local-name()='references'][@normative='true']">
						<fo:block break-after="page"/>			
					</xsl:if>
				</xsl:if>
			</xsl:if>
		</xsl:for-each>
		
		<xsl:for-each select="/*/*[local-name()='annex']">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:apply-templates select="."/>
		</xsl:for-each>
		
		<xsl:for-each select="/*/*[local-name()='bibliography']/*[not(@normative='true')] | 
								/*/*[local-name()='bibliography']/*[local-name()='clause'][*[local-name()='references'][not(@normative='true')]]">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:apply-templates select="."/>
		</xsl:for-each>
	</xsl:template>
	
	
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
	

	<xsl:template match="*[local-name()='table']" name="table">
	
		<xsl:variable name="table-preamble">
			<xsl:if test="$namespace = 'itu'">
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
				<xsl:call-template  name="getSimpleTable"/>
			</xsl:variable>
		
			<!-- <xsl:if test="$namespace = 'bipm'">
				<fo:block>&#xA0;</fo:block>
			</xsl:if> -->
			
			
			<!-- Display table's name before table as standalone block -->
			<!-- $namespace = 'iso' or  -->
			<xsl:if test="$namespace = 'csa' or $namespace = 'csd' or $namespace = 'gb' or $namespace = 'iec' or $namespace = 'iho' or 											
												$namespace = 'itu' or 
												$namespace = 'm3d' or 
												$namespace = 'nist-cswp' or 
												$namespace = 'nist-sp' or 
												$namespace = 'ogc' or 
												$namespace = 'rsd' or 
												$namespace = 'unece' or 
												$namespace = 'unece-rec' or
												$namespace = 'mpfd' or 
												$namespace = 'bipm'">
				<xsl:apply-templates select="*[local-name()='name']" mode="presentation"/>
			</xsl:if>
			
			<xsl:if test="$namespace = 'bsi'">
				<xsl:if test="$document_type != 'PAS'">
					<xsl:apply-templates select="*[local-name()='name']" mode="presentation"/>
				</xsl:if>
			</xsl:if>
			
			<xsl:if test="$namespace = 'iec' or $namespace = 'itu' or $namespace = 'unece-rec' or $namespace = 'unece' or $namespace = 'csd' or $namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'gb' or $namespace = 'm3d' or $namespace = 'iho' or $namespace = 'mpfd' or $namespace = 'bipm'">
				<xsl:call-template name="fn_name_display"/>
			</xsl:if>
				
			
			<xsl:variable name="cols-count" select="count(xalan:nodeset($simple-table)/*/tr[1]/td)"/>
			
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
				<xsl:if test="not(*[local-name()='colgroup']/*[local-name()='col'])">
					<xsl:call-template name="calculate-column-widths">
						<xsl:with-param name="cols-count" select="$cols-count"/>
						<xsl:with-param name="table" select="$simple-table"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:variable>
			<!-- colwidths=<xsl:copy-of select="$colwidths"/> -->
			
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
				<xsl:if test="$namespace = 'bsi'">
					<xsl:attribute name="font-size">9pt</xsl:attribute>
					<xsl:if test="ancestor::*[local-name() = 'preface']">
						<xsl:attribute name="font-size">9pt</xsl:attribute>
					</xsl:if>
					<xsl:if test="$document_type = 'PAS'">
						<xsl:attribute name="span">all</xsl:attribute>
						<xsl:attribute name="font-size">8pt</xsl:attribute>
					</xsl:if>
				</xsl:if>
				<xsl:if test="$namespace = 'iso' or $namespace = 'itu' or $namespace = 'csd' or $namespace = 'ogc-white-paper' or $namespace = 'gb' or $namespace = 'jcgm'">
					<xsl:attribute name="font-size">10pt</xsl:attribute>
				</xsl:if>
				<xsl:if test="$namespace = 'itu' or $namespace = 'nist-cswp'  or $namespace = 'nist-sp'">
					<xsl:attribute name="space-after">6pt</xsl:attribute>
				</xsl:if>
				<xsl:if test="$namespace = 'iec'">
					<xsl:attribute name="font-size">8pt</xsl:attribute>
					<xsl:attribute name="space-after">12pt</xsl:attribute>
					<xsl:if test="ancestor::*[local-name() = 'preface']">
						<xsl:attribute name="space-after">16pt</xsl:attribute>
					</xsl:if>
				</xsl:if>			
				<xsl:if test="$namespace = 'unece-rec'">
					<xsl:attribute name="space-after">12pt</xsl:attribute>
					<xsl:if test="not(ancestor::*[local-name()='sections'])">
						<xsl:attribute name="font-size">10pt</xsl:attribute>
					</xsl:if>
				</xsl:if>			
				<xsl:if test="$namespace = 'unece'">
					<xsl:attribute name="margin-bottom">18pt</xsl:attribute>
					<xsl:attribute name="font-size">8pt</xsl:attribute>
				</xsl:if>			
				<xsl:if test="$namespace = 'itu'">
					<xsl:attribute name="margin-left">0mm</xsl:attribute>
					<xsl:attribute name="margin-right">0mm</xsl:attribute>
					<xsl:attribute name="space-after">18pt</xsl:attribute>
				</xsl:if>
				<xsl:if test="$namespace = 'nist-cswp'  or $namespace = 'nist-sp'">
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
				<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
					<xsl:attribute name="margin-left">0mm</xsl:attribute>
					<xsl:attribute name="margin-right">0mm</xsl:attribute>
					<xsl:attribute name="space-after">12pt</xsl:attribute>
				</xsl:if>						
				<xsl:if test="$namespace = 'ogc'">
					<xsl:if test="ancestor::*[local-name()='sections']">
						<xsl:attribute name="font-size">9pt</xsl:attribute>
					</xsl:if>
				</xsl:if>
				<xsl:if test="$namespace = 'bsi'">
					<xsl:attribute name="margin-top">6pt</xsl:attribute>
					<xsl:if test="$document_type != 'PAS' and *[local-name() = 'name']">
						<xsl:attribute name="margin-top">-14pt</xsl:attribute>
					</xsl:if>
					<xsl:attribute name="margin-left">0mm</xsl:attribute>
					<xsl:attribute name="margin-right">0mm</xsl:attribute>
					<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
				</xsl:if>
				<xsl:if test="$namespace = 'iso' or $namespace = 'jcgm'">
					<xsl:attribute name="margin-top">12pt</xsl:attribute>
					<xsl:attribute name="margin-left">0mm</xsl:attribute>
					<xsl:attribute name="margin-right">0mm</xsl:attribute>
					<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
				</xsl:if>
				<xsl:if test="$namespace = 'bsi'">
					<xsl:if test="ancestor::*[local-name() = 'preface'] and not(*[local-name() = 'tbody'])">
						<xsl:attribute name="margin-top">0pt</xsl:attribute>
						<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
					</xsl:if>
				</xsl:if>
				<xsl:if test="$namespace = 'iho'">
					<xsl:attribute name="space-after">18pt</xsl:attribute>
					<xsl:attribute name="margin-left">0mm</xsl:attribute>
					<xsl:attribute name="margin-right">0mm</xsl:attribute>
				</xsl:if>
				<xsl:if test="$namespace = 'mpfd'">
					<xsl:attribute name="space-after">12pt</xsl:attribute>
					<xsl:attribute name="margin-left">0mm</xsl:attribute>
					<xsl:attribute name="margin-right">0mm</xsl:attribute>
				</xsl:if>
				<xsl:if test="$namespace = 'bipm'">
					<xsl:attribute name="space-after">12pt</xsl:attribute>
					<xsl:attribute name="margin-left">0mm</xsl:attribute>
					<xsl:attribute name="margin-right">0mm</xsl:attribute>
					<xsl:if test="not(ancestor::*[local-name()='note_side'])">
						<xsl:attribute name="font-size">10pt</xsl:attribute>
					</xsl:if>
					<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
					<xsl:if test="@parent-type = 'quote'">
						<xsl:attribute name="font-family">Arial</xsl:attribute>
						<xsl:attribute name="font-size">9pt</xsl:attribute>
					</xsl:if>
				</xsl:if>
				<xsl:if test="$namespace = 'rsd'">
					<xsl:attribute name="margin-left">0mm</xsl:attribute>
					<xsl:attribute name="margin-right">0mm</xsl:attribute>
					<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
				</xsl:if>
				
				<xsl:if test="$namespace = 'itu'">
					<xsl:if test="$doctype = 'service-publication' and $lang != 'ar'">
						<xsl:attribute name="font-family">Calibri</xsl:attribute>
					</xsl:if>
				</xsl:if>
				
				<!-- display table's name before table for PAS inside block-container (2-columnn layout) -->
				<xsl:if test="$namespace = 'bsi'">
					<xsl:if test="$document_type = 'PAS'">
						<xsl:apply-templates select="*[local-name()='name']" mode="presentation"/>
					</xsl:if>
				</xsl:if>
				
				<xsl:variable name="table_width">
					<!-- for centered table always 100% (@width will be set for middle/second cell of outer table) -->
					<xsl:if test="$namespace = 'bsi' or $namespace = 'csa' or $namespace = 'csd' or $namespace = 'gb' or 
							$namespace = 'iec' or $namespace = 'iho' or  $namespace = 'iso' or $namespace = 'itu' or 
							$namespace = 'jcgm' or
							$namespace = 'm3d' or $namespace = 'mpfd' or 
							$namespace = 'nist-cswp' or $namespace = 'nist-sp' or 
							$namespace = 'rsd'">100%</xsl:if>
							
					<xsl:if test="$namespace = 'bipm' or $namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'unece' or $namespace = 'unece-rec'">
						<xsl:choose>
						<xsl:when test="@width"><xsl:value-of select="@width"/></xsl:when>
						<xsl:otherwise>100%</xsl:otherwise>
					</xsl:choose>
					</xsl:if>
				</xsl:variable>
				
				<xsl:variable name="table_attributes">
					<attribute name="table-layout">fixed</attribute>
					<attribute name="width"><xsl:value-of select="normalize-space($table_width)"/></attribute>
					<attribute name="margin-left"><xsl:value-of select="$margin-left"/>mm</attribute>
					<attribute name="margin-right"><xsl:value-of select="$margin-left"/>mm</attribute>
					<xsl:if test="$namespace = 'bsi'">
						<!-- <attribute name="border"><xsl:value-of select="$table-border"/></attribute> -->
						<attribute name="border">none</attribute>
						<attribute name="border-bottom"><xsl:value-of select="$table-border"/></attribute>
						<xsl:if test=".//*[local-name() = 'tr'][1]/*[local-name() = 'td'][normalize-space() = 'Key']">
							<attribute name="border-bottom">none</attribute>
						</xsl:if>
						<xsl:if test="*[local-name()='thead']">
							<!-- <attribute name="border-top"><xsl:value-of select="$table-border"/></attribute> -->
						</xsl:if>
						<xsl:if test="ancestor::*[local-name() = 'preface']">
							<attribute name="border">0pt solid black</attribute>
							<attribute name="border-top">0pt solid black</attribute>
						</xsl:if>
						<xsl:if test="$document_type = 'PAS'">
							<attribute name="border">1pt solid <xsl:value-of select="$color_PAS"/></attribute>
						</xsl:if>
					</xsl:if>
					<xsl:if test="$namespace = 'iso' or $namespace = 'jcgm'">
						<attribute name="border">1.5pt solid black</attribute>
						<xsl:if test="*[local-name()='thead']">
							<attribute name="border-top">1pt solid black</attribute>
						</xsl:if>
					</xsl:if>
					<xsl:if test="$namespace = 'bsi'">
						<xsl:if test="ancestor::*[local-name() = 'table']">
							<!-- for internal table in table cell -->
							<attribute name="border"><xsl:value-of select="$table-border"/></attribute>
						</xsl:if>
					</xsl:if>
					<xsl:if test="$namespace = 'iso'">
						<xsl:if test="ancestor::*[local-name() = 'table']">
							<!-- for internal table in table cell -->
							<attribute name="border">0.5pt solid black</attribute>
						</xsl:if>
					</xsl:if>
					<xsl:if test="$namespace = 'iec'">
						<attribute name="border">0.5pt solid black</attribute>
					</xsl:if>
					<xsl:if test="$namespace = 'itu'">
						<attribute name="margin-left">0mm</attribute>
						<attribute name="margin-right">0mm</attribute>
						<xsl:if test="$doctype = 'service-publication'">
							<attribute name="border">1pt solid rgb(211,211,211)</attribute>
						</xsl:if>
					</xsl:if>
					<xsl:if test="$namespace = 'bsi' or $namespace = 'iso' or $namespace = 'jcgm'">
						<attribute name="margin-left">0mm</attribute>
						<attribute name="margin-right">0mm</attribute>
					</xsl:if>
					<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
						<attribute name="margin-left">0mm</attribute>
						<attribute name="margin-right">0mm</attribute>
					</xsl:if>				
					<xsl:if test="$namespace = 'unece-rec'">
						<xsl:if test="ancestor::*[local-name()='sections']">
							<attribute name="border-top">1.5pt solid black</attribute>
							<attribute name="border-bottom">1.5pt solid black</attribute>
						</xsl:if>					
					</xsl:if>				
					<xsl:if test="$namespace = 'unece'">
						<attribute name="border-top">0.5pt solid black</attribute>					
					</xsl:if>				
					<xsl:if test="$namespace = 'iho'">				
						<attribute name="margin-left">0mm</attribute>
						<attribute name="margin-right">0mm</attribute>
					</xsl:if>
					<xsl:if test="$namespace = 'mpfd'">
						<attribute name="border-top">2pt solid black</attribute>
						<attribute name="border-bottom">2pt solid black</attribute>
					</xsl:if>				
					<xsl:if test="$namespace = 'bipm'">					
						<xsl:if test="not(ancestor::*[local-name()='preface']) and not(ancestor::*[local-name()='note_side']) and not(ancestor::*[local-name() = 'annex'] and .//*[local-name() = 'xref'][@pagenumber]) and not(ancestor::*[local-name() = 'doccontrol'])">
							<attribute name="border-top">0.5pt solid black</attribute>
							<attribute name="border-bottom">0.5pt solid black</attribute>
						</xsl:if>
						<attribute name="margin-left">0mm</attribute>
						<attribute name="margin-right">0mm</attribute>					
						<!-- <attribute name="keep-together.within-column">1</attribute> --> <!-- integer value  instead 'always'! -->
					</xsl:if>
					<xsl:if test="$namespace = 'rsd'">
						<attribute name="border">0pt solid black</attribute>
						<attribute name="font-size">8pt</attribute>
					</xsl:if>
				</xsl:variable>
				
				
				<fo:table id="{@id}" table-omit-footer-at-break="true">
					
					<xsl:for-each select="xalan:nodeset($table_attributes)/attribute">					
						<xsl:attribute name="{@name}">
							<xsl:value-of select="."/>
						</xsl:attribute>
					</xsl:for-each>
					
					<xsl:variable name="isNoteOrFnExist" select="./*[local-name()='note'] or .//*[local-name()='fn'][local-name(..) != 'name']"/>				
					<xsl:if test="$isNoteOrFnExist = 'true'">
						<xsl:attribute name="border-bottom">0pt solid black</xsl:attribute> <!-- set 0pt border, because there is a separete table below for footer  -->
					</xsl:if>
					
					<xsl:if test="$namespace = 'bsi'">
						<xsl:if test=".//*[local-name()='fn']"> <!-- show fn in name after table -->
							<!-- <xsl:attribute name="border-bottom">0pt solid black</xsl:attribute> --> <!-- set 0pt border, because there is a separete table below for footer  -->
						</xsl:if>
					</xsl:if>
					
					<xsl:choose>
						<xsl:when test="*[local-name()='colgroup']/*[local-name()='col']">
							<xsl:for-each select="*[local-name()='colgroup']/*[local-name()='col']">
								<fo:table-column column-width="{@width}"/>
							</xsl:for-each>
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
					
					<xsl:choose>
						<xsl:when test="not(*[local-name()='tbody']) and *[local-name()='thead']">
							<xsl:apply-templates select="*[local-name()='thead']" mode="process_tbody"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates />
						</xsl:otherwise>
					</xsl:choose>
					
				</fo:table>
				
				<xsl:variable name="colgroup" select="*[local-name()='colgroup']"/>				
				<xsl:for-each select="*[local-name()='tbody']"><!-- select context to tbody -->
					<xsl:call-template name="insertTableFooterInSeparateTable">
						<xsl:with-param name="table_attributes" select="$table_attributes"/>
						<xsl:with-param name="colwidths" select="$colwidths"/>				
						<xsl:with-param name="colgroup" select="$colgroup"/>				
					</xsl:call-template>
				</xsl:for-each>
				
				<!-- insert footer as table -->
				<!-- <fo:table>
					<xsl:for-each select="xalan::nodeset($table_attributes)/attribute">
						<xsl:attribute name="{@name}">
							<xsl:value-of select="."/>
						</xsl:attribute>
					</xsl:for-each>
					
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
				</fo:table>-->
				
				<xsl:if test="$namespace = 'gb'">
					<xsl:apply-templates select="*[local-name()='note']" mode="process"/>
				</xsl:if>
				
				<xsl:if test="$namespace = 'ogc-white-paper'">
					<xsl:apply-templates select="*[local-name()='name']" mode="presentation"/>
				</xsl:if>
				
			</fo:block-container>
		</xsl:variable>
		
		<xsl:variable name="isAdded" select="@added"/>
		<xsl:variable name="isDeleted" select="@deleted"/>
		
		<xsl:choose>
			<xsl:when test="@width">
	
				<!-- centered table when table name is centered (see table-name-style) -->
				<xsl:if test="$namespace = 'bsi' or $namespace = 'csa' or $namespace = 'csd' or $namespace = 'gb' or 
								$namespace = 'iec' or $namespace = 'iho' or  $namespace = 'iso' or $namespace = 'itu' or 
								$namespace = 'jcgm' or
								$namespace = 'm3d' or $namespace = 'mpfd' or 
								$namespace = 'nist-cswp' or $namespace = 'nist-sp' or 
								$namespace = 'rsd'">
					<fo:table table-layout="fixed" width="100%" >
						<fo:table-column column-width="proportional-column-width(1)"/>
						<fo:table-column column-width="{@width}"/>
						<fo:table-column column-width="proportional-column-width(1)"/>
						<fo:table-body>
							<fo:table-row>
								<fo:table-cell column-number="2">
									<xsl:copy-of select="$table-preamble"/>
									<fo:block>
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


	
	<xsl:template match="*[local-name()='table']/*[local-name() = 'name']"/>
	<xsl:template match="*[local-name()='table']/*[local-name() = 'name']" mode="presentation">
		<xsl:param name="continued"/>
		<xsl:if test="normalize-space() != ''">
			<fo:block xsl:use-attribute-sets="table-name-style">
				<xsl:if test="$namespace = 'iso' or $namespace = 'jcgm'">
					<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
				</xsl:if>
				<xsl:if test="$namespace = 'bipm'">
					<xsl:if test="not(*[local-name()='tab'])"> <!-- table without number -->
						<xsl:attribute name="margin-top">0pt</xsl:attribute>
					</xsl:if>
					<xsl:if test="not(../preceding-sibling::*) and ancestor::node()[@orientation]">
						<xsl:attribute name="margin-top">0pt</xsl:attribute>
					</xsl:if>
				</xsl:if>
				
				<xsl:if test="$namespace = 'bsi'">
					<xsl:if test="$continued != 'true'">
						<xsl:attribute name="margin-top">6pt</xsl:attribute>
						<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
					</xsl:if>
				
					<xsl:if test="$document_type = 'PAS'">
						<xsl:attribute name="margin-left">0.5mm</xsl:attribute>
						<xsl:attribute name="font-size">12pt</xsl:attribute>
						<xsl:attribute name="font-style">normal</xsl:attribute>
						<xsl:attribute name="margin-bottom">-16pt</xsl:attribute> <!-- to overlap title on empty header row -->
						<xsl:if test="$continued = 'true'"> <!-- in continued table header -->
							<xsl:attribute name="margin-left">0mm</xsl:attribute>
							<xsl:attribute name="margin-top">0pt</xsl:attribute>
							<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
						</xsl:if>
					</xsl:if>
				</xsl:if>
				
				<xsl:choose>
					<xsl:when test="$continued = 'true'"> 
						<!-- <xsl:if test="$namespace = 'bsi'"></xsl:if> -->
						<xsl:if test="$namespace = 'iso' or $namespace = 'jcgm'">
							<xsl:apply-templates />
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates />
					</xsl:otherwise>
				</xsl:choose>
				
				<xsl:if test="$namespace = 'bsi'">
					<xsl:if test="$continued = 'true'">
						<fo:inline font-weight="bold" font-style="normal">
							<xsl:if test="$document_type = 'PAS'">
								<xsl:attribute name="color"><xsl:value-of select="$color_PAS"/></xsl:attribute>
							</xsl:if>
							<fo:retrieve-table-marker retrieve-class-name="table_number"/>
						</fo:inline>
						<fo:inline font-style="italic">
							<!-- <xsl:if test="$document_type = 'PAS'">
								<xsl:attribute name="font-style">normal</xsl:attribute>
							</xsl:if> -->
							<xsl:text> </xsl:text>
							<fo:retrieve-table-marker retrieve-class-name="table_continued"/>
						</fo:inline>
					</xsl:if>
				</xsl:if>
			</fo:block>
		</xsl:if>
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
						<xsl:for-each select="xalan:nodeset($table)/*/tr">
							<xsl:variable name="td_text">
								<xsl:apply-templates select="td[$curr-col]" mode="td_text"/>
								
								<!-- <xsl:if test="$namespace = 'bipm'">
									<xsl:for-each select="*[local-name()='td'][$curr-col]//*[local-name()='math']">									
										<word><xsl:value-of select="normalize-space(.)"/></word>
									</xsl:for-each>
								</xsl:if> -->
								
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

	<xsl:template match="*[local-name()='math']" mode="td_text">
		<xsl:variable name="mathml">
			<xsl:for-each select="*">
				<xsl:if test="local-name() != 'unit' and local-name() != 'prefix' and local-name() != 'dimension' and local-name() != 'quantity'">
					<xsl:copy-of select="."/>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		
		<xsl:variable name="math_text" select="normalize-space(xalan:nodeset($mathml))"/>
		<xsl:value-of select="translate($math_text, ' ', '#')"/><!-- mathml images as one 'word' without spaces -->
	</xsl:template>
	
	<!-- for debug purpose only -->
	<xsl:template match="*[local-name()='table2']"/>
	
	<xsl:template match="*[local-name()='thead']"/>

	<xsl:template match="*[local-name()='thead']" mode="process">
		<xsl:param name="cols-count"/>
		<!-- font-weight="bold" -->
		<fo:table-header>
			<xsl:if test="$namespace = 'iso' or $namespace = 'jcgm'">				
				<xsl:call-template name="table-header-title">
					<xsl:with-param name="cols-count" select="$cols-count"/>
				</xsl:call-template>				
			</xsl:if>
			<xsl:if test="$namespace = 'bsi'">				
				<xsl:if test="ancestor::*[local-name()='table']/*[local-name()='name']">
					<xsl:call-template name="table-header-title">
						<xsl:with-param name="cols-count" select="$cols-count"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:if>
			<xsl:apply-templates />
		</fo:table-header>
	</xsl:template>
	
	<!-- template is using for iso, jcgm, bsi only -->
	<xsl:template name="table-header-title">
		<xsl:param name="cols-count"/>
		<!-- row for title -->
		<fo:table-row>
			<fo:table-cell number-columns-spanned="{$cols-count}" border-left="1.5pt solid white" border-right="1.5pt solid white" border-top="1.5pt solid white" border-bottom="1.5pt solid black">
				<xsl:if test="$namespace = 'bsi'">
					<!-- <xsl:attribute name="border-bottom">0pt solid black</xsl:attribute> -->
					<xsl:attribute name="border-bottom">none</xsl:attribute>
					<xsl:attribute name="border-left">none</xsl:attribute>
					<xsl:attribute name="border-right">none</xsl:attribute>
					<xsl:attribute name="border-top">none</xsl:attribute>
				</xsl:if>
				<xsl:apply-templates select="ancestor::*[local-name()='table']/*[local-name()='name']" mode="presentation">
					<xsl:with-param name="continued">true</xsl:with-param>
				</xsl:apply-templates>
				
				<xsl:if test="$namespace = 'iso' or $namespace = 'jcgm'">
					<xsl:for-each select="ancestor::*[local-name()='table'][1]">
						<xsl:call-template name="fn_name_display"/>
					</xsl:for-each>
				</xsl:if>
				
				<xsl:if test="$namespace = 'iso' or $namespace = 'jcgm'">
					<fo:block text-align="right" font-style="italic">
						<xsl:text>&#xA0;</xsl:text>
						<fo:retrieve-table-marker retrieve-class-name="table_continued"/>
					</fo:block>
				</xsl:if>
			</fo:table-cell>
		</fo:table-row>
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
		<xsl:if test="../*[local-name()='tfoot']">
			<fo:table-footer>			
				<xsl:apply-templates select="../*[local-name()='tfoot']" mode="process"/>
			</fo:table-footer>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="insertTableFooter2">
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
							<xsl:if test="$namespace = 'bsi' or $namespace = 'iso' or $namespace = 'gb' or $namespace = 'jcgm'">
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
							<xsl:if test="$namespace = 'ogc'">
								<xsl:attribute name="border">solid black 0pt</xsl:attribute>
							</xsl:if>
							<xsl:if test="$namespace = 'bipm'">
								<xsl:attribute name="border">solid black 0pt</xsl:attribute>
							</xsl:if>
							
							
							
							<!-- except gb -->
							<xsl:if test="$namespace = 'bsi' or $namespace = 'iso' or $namespace = 'iec' or $namespace = 'itu' or $namespace = 'unece' or $namespace = 'unece-rec' or $namespace = 'nist-cswp'  or $namespace = 'nist-sp' or $namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'rsd' or $namespace = 'csa' or $namespace = 'csd' or $namespace = 'm3d' or $namespace = 'iho' or $namespace = 'mpfd' or $namespace = 'bipm' or $namespace = 'jcgm'">
								<xsl:apply-templates select="../*[local-name()='note']" mode="process"/>
							</xsl:if>
							
							<!-- show Note under table in preface (ex. abstract) sections -->
							<!-- empty, because notes show at page side in main sections -->
							<!-- <xsl:if test="$namespace = 'bipm'">
								<xsl:choose>
									<xsl:when test="ancestor::*[local-name()='preface']">										
										<xsl:apply-templates select="../*[local-name()='note']" mode="process"/>
									</xsl:when>
									<xsl:otherwise>										
									<fo:block/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:if> -->
							
							
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
	
	
	<xsl:template name="insertTableFooterInSeparateTable">
		<xsl:param name="table_attributes"/>
		<xsl:param name="colwidths"/>
		<xsl:param name="colgroup"/>
		
		<xsl:variable name="isNoteOrFnExist" select="../*[local-name()='note'] or ..//*[local-name()='fn'][local-name(..) != 'name']"/>
		
		<xsl:variable name="isNoteOrFnExistShowAfterTable">
			<xsl:if test="$namespace = 'bsi'">
				 <xsl:value-of select="../*[local-name()='note'] or ..//*[local-name()='fn']"/>
			</xsl:if>
		</xsl:variable>
		
		<xsl:if test="$isNoteOrFnExist = 'true' or normalize-space($isNoteOrFnExistShowAfterTable) = 'true'">
		
			<xsl:variable name="cols-count">
				<xsl:choose>
					<xsl:when test="xalan:nodeset($colgroup)//*[local-name()='col']">
						<xsl:value-of select="count(xalan:nodeset($colgroup)//*[local-name()='col'])"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="count(xalan:nodeset($colwidths)//column)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<fo:table keep-with-previous="always">
				<xsl:for-each select="xalan:nodeset($table_attributes)/attribute">
					<xsl:choose>
						<xsl:when test="@name = 'border-top'">
							<xsl:attribute name="{@name}">0pt solid black</xsl:attribute>
						</xsl:when>
						<xsl:when test="@name = 'border'">
							<xsl:attribute name="{@name}"><xsl:value-of select="."/></xsl:attribute>
							<xsl:attribute name="border-top">0pt solid black</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="{@name}"><xsl:value-of select="."/></xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
				
				<xsl:if test="$namespace = 'itu'">
					<xsl:if test="$doctype = 'service-publication'">
						<xsl:attribute name="border">none</xsl:attribute>
						<xsl:attribute name="font-family">Arial</xsl:attribute>
						<xsl:attribute name="font-size">8pt</xsl:attribute>
					</xsl:if>
				</xsl:if>
				
				<xsl:choose>
					<xsl:when test="xalan:nodeset($colgroup)//*[local-name()='col']">
						<xsl:for-each select="xalan:nodeset($colgroup)//*[local-name()='col']">
							<fo:table-column column-width="{@width}"/>
						</xsl:for-each>
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
				
				<fo:table-body>
					<fo:table-row>
						<fo:table-cell border="solid black 1pt" padding-left="1mm" padding-right="1mm" padding-top="1mm" number-columns-spanned="{$cols-count}">
							<xsl:if test="$namespace = 'bsi'">
								<xsl:attribute name="border"><xsl:value-of select="$table-border"/></xsl:attribute>
								<xsl:if test="$document_type = 'PAS'">
									<xsl:attribute name="border">1pt solid <xsl:value-of select="$color_PAS"/></xsl:attribute>
								</xsl:if>
								<!-- <xsl:attribute name="border-top">solid black 0pt</xsl:attribute> -->
							</xsl:if>
							<xsl:if test="$namespace = 'iso' or $namespace = 'gb' or $namespace = 'jcgm'">
								<xsl:attribute name="border-top">solid black 0pt</xsl:attribute>
							</xsl:if>
							<xsl:if test="$namespace = 'iec'">
								<xsl:attribute name="border">solid black 0.5pt</xsl:attribute>
							</xsl:if>
							<xsl:if test="$namespace = 'itu'">
								<xsl:if test="ancestor::*[local-name()='preface']">
									<xsl:attribute name="border">solid black 0pt</xsl:attribute>
								</xsl:if>
								<xsl:if test="$doctype = 'service-publication'">
									<xsl:attribute name="border">none</xsl:attribute>
								</xsl:if>
							</xsl:if>
							<!-- fn will be processed inside 'note' processing -->
							<xsl:if test="$namespace = 'iec'">
								<xsl:if test="../*[local-name()='note']">
									<fo:block margin-bottom="6pt">&#xA0;</fo:block>
								</xsl:if>
							</xsl:if>
							<xsl:if test="$namespace = 'ogc'">
								<xsl:attribute name="border">solid black 0pt</xsl:attribute>
							</xsl:if>
							<xsl:if test="$namespace = 'bipm'">
								<xsl:attribute name="border">solid black 0pt</xsl:attribute>
							</xsl:if>
							
							<xsl:if test="$namespace = 'bipm'">
								<xsl:if test="count(ancestor::bipm:table//*[local-name()='note']) &gt; 1">
									<fo:block font-weight="bold">
										<xsl:variable name="curr_lang" select="ancestor::bipm:bipm-standard/bipm:bibdata/bipm:language"/>
										<xsl:choose>
											<xsl:when test="$curr_lang = 'fr'">Remarques</xsl:when>
											<xsl:otherwise>Notes</xsl:otherwise>
										</xsl:choose>
									</fo:block>
								</xsl:if>
							</xsl:if>
							<xsl:if test="$namespace = 'rsd'">
								<xsl:attribute name="border">solid black 0pt</xsl:attribute>
							</xsl:if>
							
							<xsl:if test="$namespace = 'itu'">
								<xsl:if test="$doctype = 'service-publication'">
									<fo:block margin-top="7pt" margin-bottom="2pt"><fo:inline>____________</fo:inline></fo:block>
								</xsl:if>
							</xsl:if>
							
							<!-- for BSI (not PAS) display Notes before footnotes -->
							<xsl:if test="$namespace = 'bsi'">
								<xsl:if test="$document_type != 'PAS'">
									<xsl:apply-templates select="../*[local-name()='note']" mode="process"/>
								</xsl:if>
							</xsl:if>
							
							<!-- except gb  -->
							<xsl:if test="$namespace = 'iso' or $namespace = 'iec' or $namespace = 'itu' or $namespace = 'unece' or $namespace = 'unece-rec' or $namespace = 'nist-cswp'  or $namespace = 'nist-sp' or $namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'rsd' or $namespace = 'csa' or $namespace = 'csd' or $namespace = 'm3d' or $namespace = 'iho' or $namespace = 'mpfd' or $namespace = 'bipm' or $namespace = 'jcgm'">
								<xsl:apply-templates select="../*[local-name()='note']" mode="process"/>
							</xsl:if>
							
							<!-- <xsl:if test="$namespace = 'bipm'">
								<xsl:choose>
									<xsl:when test="ancestor::*[local-name()='preface']">
										show Note under table in preface (ex. abstract) sections
										<xsl:apply-templates select="../*[local-name()='note']" mode="process"/>
									</xsl:when>
									<xsl:otherwise>
										empty, because notes show at page side in main sections
									<fo:block/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:if> -->
							
							
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
							
							
							<!-- for PAS display Notes after footnotes -->
							<xsl:if test="$namespace = 'bsi'">
								<xsl:if test="$document_type = 'PAS'">
									<xsl:apply-templates select="../*[local-name()='note']" mode="process"/>
								</xsl:if>
							</xsl:if>
							
						</fo:table-cell>
					</fo:table-row>
				</fo:table-body>
				
			</fo:table>
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
		
		<xsl:if test="$namespace = 'bsi' or $namespace = 'iso' or $namespace = 'jcgm'">
			<!-- if there isn't 'thead' and there is a table's title -->
			<xsl:if test="not(ancestor::*[local-name()='table']/*[local-name()='thead']) and ancestor::*[local-name()='table']/*[local-name()='name']">
				<fo:table-header>
					<xsl:call-template name="table-header-title">
						<xsl:with-param name="cols-count" select="$cols-count"/>
					</xsl:call-template>
				</fo:table-header>
			</xsl:if>
		</xsl:if>
		
		<xsl:apply-templates select="../*[local-name()='thead']" mode="process">
			<xsl:with-param name="cols-count" select="$cols-count"/>
		</xsl:apply-templates>
		
		<xsl:call-template name="insertTableFooter">
			<xsl:with-param name="cols-count" select="$cols-count"/>
		</xsl:call-template>
		
		<fo:table-body>
			<xsl:if test="$namespace = 'bsi' or $namespace = 'iso' or $namespace = 'jcgm'">				
				<xsl:variable name="title_continued_">
					<xsl:call-template name="getTitle">
						<xsl:with-param name="name" select="'title-continued'"/>
					</xsl:call-template>
				</xsl:variable>
				
				<xsl:variable name="title_continued">
					<xsl:if test="$namespace = 'iso' or $namespace = 'jcgm'"><xsl:value-of select="$title_continued_"/></xsl:if>
					<xsl:if test="$namespace = 'bsi'">
						<xsl:choose>
							<xsl:when test="$document_type = 'PAS'">— <xsl:value-of select="translate($title_continued_, '()', '')"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="$title_continued_"/></xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:variable>
				
				<xsl:variable name="title_start" select="ancestor::*[local-name()='table'][1]/*[local-name()='name']/node()[1][self::text()]"/>
				<xsl:variable name="table_number" select="substring-before($title_start, '—')"/>
				
				<fo:table-row height="0" keep-with-next.within-page="always">
					<fo:table-cell>
					
						<xsl:if test="$namespace = 'bsi'">
							<fo:marker marker-class-name="table_number" />
								<!-- <xsl:if test="$document_type != 'PAS'">
									<xsl:value-of select="$table_number"/>
								</xsl:if>
							</fo:marker> -->
							
							<fo:marker marker-class-name="table_continued" />
							<!-- <fo:inline>
								<xsl:if test="$document_type != 'PAS'">
									<xsl:apply-templates select="ancestor::*[local-name()='table'][1]/*[local-name()='name']" mode="presentation_name"/>
								</xsl:if>
								</fo:inline>
							</fo:marker> -->
						 <!-- end BSI -->
						</xsl:if>
						
						<xsl:if test="$namespace = 'iso' or $namespace = 'jcgm'">
							<fo:marker marker-class-name="table_continued" />
						</xsl:if>
						
						<fo:block/>
					</fo:table-cell>
				</fo:table-row>
				<fo:table-row height="0" keep-with-next.within-page="always">
					<fo:table-cell>
						<xsl:if test="$namespace = 'bsi'">
							<fo:marker marker-class-name="table_number"><xsl:value-of select="$table_number"/></fo:marker>
						</xsl:if>
						<fo:marker marker-class-name="table_continued">
							<xsl:value-of select="$title_continued"/>
						</fo:marker>
						 <fo:block/>
					</fo:table-cell>
				</fo:table-row>
			</xsl:if>

			<xsl:apply-templates />
			<!-- <xsl:apply-templates select="../*[local-name()='tfoot']" mode="process"/> -->
		
		</fo:table-body>
		
	</xsl:template>
	
	<xsl:template match="*[local-name()='table']/*[local-name()='name']/text()[1]" priority="2" mode="presentation_name">
		<xsl:choose>
			<xsl:when test="substring-after(., '—') != ''">
				<xsl:text>—</xsl:text><xsl:value-of select="substring-after(., '—')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="*[local-name()='table']/*[local-name()='name']" mode="presentation_name">
		<xsl:apply-templates mode="presentation_name"/>
	</xsl:template>
	<xsl:template match="*[local-name()='table']/*[local-name()='name']/node()" mode="presentation_name">
		<xsl:apply-templates select="." />
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
					<xsl:if test="$namespace = 'nist-cswp'  or $namespace = 'nist-sp'">
						<xsl:attribute name="font-family">Arial</xsl:attribute>
						<xsl:attribute name="font-size">10pt</xsl:attribute>
					</xsl:if>
					
					<xsl:if test="$namespace = 'iso' or $namespace = 'jcgm'">
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
					<xsl:if test="$namespace = 'bsi'">
						<xsl:attribute name="border-top"><xsl:value-of select="$table-border"/></xsl:attribute>
						<xsl:attribute name="border-bottom"><xsl:value-of select="$table-border"/></xsl:attribute>
						<xsl:if test="position() = last()">
							<xsl:attribute name="border-bottom">none</xsl:attribute>
						</xsl:if>
						<xsl:if test="ancestor::*[local-name() = 'preface']">
							<xsl:attribute name="border-top">solid black 0pt</xsl:attribute>
							<xsl:attribute name="border-bottom">solid black 0pt</xsl:attribute>
							<xsl:attribute name="font-weight">normal</xsl:attribute>
						</xsl:if>
					</xsl:if>
					<xsl:if test="$namespace = 'iec'">
						<xsl:attribute name="border-top">solid black 0.5pt</xsl:attribute>
						<xsl:attribute name="border-bottom">solid black 0.5pt</xsl:attribute>
					</xsl:if>
					<xsl:if test="$namespace = 'rsd'">
						<xsl:attribute name="font-weight">normal</xsl:attribute>
						<xsl:attribute name="color">black</xsl:attribute>
					</xsl:if>
					<xsl:if test="$namespace = 'itu'">
						<xsl:if test="$doctype = 'service-publication'">
							<xsl:attribute name="border-bottom">1.1pt solid black</xsl:attribute>
						</xsl:if>
					</xsl:if>
					
				</xsl:if>
				<xsl:if test="$parent-name = 'tfoot'">
					<xsl:if test="$namespace = 'bsi'">
						<xsl:attribute name="font-size">9pt</xsl:attribute>
						<xsl:attribute name="border-left"><xsl:value-of select="$table-border"/></xsl:attribute>
						<xsl:attribute name="border-right"><xsl:value-of select="$table-border"/></xsl:attribute>
						<xsl:if test="$document_type = 'PAS'">
							<xsl:attribute name="font-size">inherit</xsl:attribute>
						</xsl:if>
					</xsl:if>
					<xsl:if test="$namespace = 'iso' or $namespace = 'jcgm'">
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
				<xsl:if test="$namespace = 'ogc'">
					<xsl:attribute name="min-height">8.5mm</xsl:attribute>
					<xsl:if test="$parent-name = 'thead'">
						<xsl:attribute name="background-color">rgb(33, 55, 92)</xsl:attribute>
						<xsl:attribute name="color">white</xsl:attribute>
					</xsl:if>
					<xsl:if test="$parent-name = 'tbody'">
						<xsl:variable name="number"><xsl:number/></xsl:variable>
						<xsl:if test="$number mod 2 = 0">
							<xsl:attribute name="background-color">rgb(252, 246, 222)</xsl:attribute>
						</xsl:if>
					</xsl:if>					
				</xsl:if>
				<xsl:if test="$namespace = 'bipm'">
					<xsl:if test="count(*) = 1 and local-name(*[1]) = 'th'">
						<xsl:attribute  name="keep-with-next.within-page">always</xsl:attribute>
					</xsl:if>
					<xsl:if test="not(ancestor::*[local-name()='note_side'])">
					 <xsl:attribute name="min-height">5mm</xsl:attribute>
					 </xsl:if>
				</xsl:if>
				<xsl:if test="$namespace = 'rsd'">
					<xsl:attribute name="min-height">8.5mm</xsl:attribute>
					<xsl:if test="$parent-name = 'thead'">
						<xsl:attribute name="background-color">rgb(32, 98, 169)</xsl:attribute>
						<xsl:attribute name="color">white</xsl:attribute>
					</xsl:if>
					<xsl:if test="$parent-name = 'tbody'">
						<xsl:variable name="number"><xsl:number/></xsl:variable>
						<xsl:if test="$number mod 2 = 0">
							<xsl:attribute name="background-color">rgb(254, 247, 228)</xsl:attribute>
						</xsl:if>
					</xsl:if>					
				</xsl:if>
				
				<xsl:if test="$namespace = 'bsi'">
					<xsl:if test="$document_type = 'PAS'">
						<xsl:attribute name="min-height">6mm</xsl:attribute>
					</xsl:if>
				</xsl:if>
				
				<xsl:if test="$namespace = 'itu'">
					<xsl:if test="$doctype = 'service-publication'">
						<xsl:attribute name="min-height">5mm</xsl:attribute>
					</xsl:if>
				</xsl:if>
				
				<!-- <xsl:if test="$namespace = 'bipm'">
					<xsl:attribute name="height">8mm</xsl:attribute>
				</xsl:if> -->
				
			<xsl:apply-templates />
		</fo:table-row>
	</xsl:template>
	

	<xsl:template match="*[local-name()='th']">
		<fo:table-cell text-align="{@align}" font-weight="bold" border="solid black 1pt" padding-left="1mm" display-align="center">
			<xsl:attribute name="text-align">
				<xsl:choose>
					<xsl:when test="@align">
						<xsl:call-template name="setAlignment"/>
						<!-- <xsl:value-of select="@align"/> -->
					</xsl:when>
					<xsl:otherwise>center</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:if test="$namespace = 'bsi'">
				<xsl:attribute name="border"><xsl:value-of select="$table-border"/></xsl:attribute>
				<xsl:attribute name="padding-top">1mm</xsl:attribute>
				
				<xsl:if test="ancestor::*[local-name() = 'preface']">
					<xsl:attribute name="font-weight">normal</xsl:attribute>
					<xsl:attribute name="border">solid black 0pt</xsl:attribute>
				</xsl:if>
				<xsl:if test="$document_type = 'PAS'">
					<xsl:attribute name="border">1pt solid <xsl:value-of select="$color_PAS"/></xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$namespace = 'iso' or $namespace = 'iec' or $namespace = 'jcgm'">
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
				<xsl:if test="$doctype = 'service-publication'">
					<xsl:attribute name="border">1pt solid rgb(211,211,211)</xsl:attribute>
					<xsl:attribute name="border-bottom">1pt solid black</xsl:attribute>
					<xsl:attribute name="padding-top">1mm</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$namespace = 'nist-cswp'  or $namespace = 'nist-sp'">
				<xsl:attribute name="text-align">center</xsl:attribute>
				<xsl:attribute name="background-color">black</xsl:attribute>
				<xsl:attribute name="color">white</xsl:attribute>
			</xsl:if>
			<xsl:if test="$namespace = 'ogc'">				
				<xsl:attribute name="border">solid black 0pt</xsl:attribute>				
			</xsl:if>
			<xsl:if test="$namespace = 'ogc-white-paper'">
				<xsl:attribute name="padding">1mm</xsl:attribute>
				<xsl:attribute name="background-color">rgb(0, 51, 102)</xsl:attribute>
				<xsl:attribute name="color">white</xsl:attribute>
				<xsl:attribute name="border">solid 0.5pt rgb(153, 153, 153)</xsl:attribute>
				<xsl:attribute name="height">5mm</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="$namespace = 'unece-rec'">				
				<xsl:if test="ancestor::*[local-name()='sections']">
					<xsl:attribute name="border">solid black 0pt</xsl:attribute>
					<xsl:attribute name="display-align">before</xsl:attribute>
					<xsl:attribute name="padding-top">1mm</xsl:attribute>
				</xsl:if>
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
				<xsl:attribute name="text-indent">0mm</xsl:attribute>
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
			<xsl:if test="$namespace = 'mpfd'">								
				<xsl:attribute name="border-top">solid black 2pt</xsl:attribute>
				<xsl:attribute name="border-bottom">solid black 2pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="$namespace = 'bipm'">
				<xsl:attribute name="font-weight">normal</xsl:attribute>
				<xsl:attribute name="border">solid black 0pt</xsl:attribute>				
				<!-- <xsl:attribute name="border-top">solid black 0.5pt</xsl:attribute> -->
				<xsl:attribute name="border-bottom">solid black 0.5pt</xsl:attribute>
				<xsl:attribute name="height">8mm</xsl:attribute>
				<xsl:attribute name="padding-top">2mm</xsl:attribute>
				<xsl:if test="(ancestor::*[local-name() = 'annex'] and ancestor::*[local-name() = 'table']//*[local-name() = 'xref'][@pagenumber]) or ancestor::*[local-name() = 'doccontrol']"><!-- for Annex ToC -->
					<xsl:attribute name="border-top">solid black 0pt</xsl:attribute>
					<xsl:attribute name="border-bottom">solid black 0pt</xsl:attribute>
				</xsl:if>
				<xsl:if test="ancestor::*[local-name() = 'doccontrol']">
					<xsl:attribute name="text-align">
						<xsl:choose>
							<xsl:when test="@align">
								<xsl:value-of select="@align"/>
							</xsl:when>
							<xsl:otherwise>left</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="display-align">before</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$namespace = 'rsd'">
				<xsl:attribute name="font-weight">normal</xsl:attribute>
				<xsl:attribute name="border">0pt solid black</xsl:attribute>
			</xsl:if>
			<xsl:if test="$lang = 'ar'">
				<xsl:attribute name="padding-right">1mm</xsl:attribute>
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
			<xsl:call-template name="display-align" />
			<fo:block>
				<xsl:apply-templates />
			</fo:block>
		</fo:table-cell>
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
	
	<xsl:template match="*[local-name()='td']">
		<fo:table-cell text-align="{@align}" display-align="center" border="solid black 1pt" padding-left="1mm">
			<xsl:attribute name="text-align">
				<xsl:choose>
					<xsl:when test="@align">
						<xsl:call-template name="setAlignment"/>
						<!-- <xsl:value-of select="@align"/> -->
					</xsl:when>
					<xsl:otherwise>left</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:if test="$lang = 'ar'">
				<xsl:attribute name="padding-right">1mm</xsl:attribute>
			</xsl:if>
			<xsl:if test="$namespace = 'bsi' or $namespace = 'iso' or $namespace = 'iec' or $namespace = 'iho' or $namespace = 'jcgm'"> <!--  and ancestor::*[local-name() = 'thead'] -->
				<xsl:attribute name="padding-top">0.5mm</xsl:attribute>
			</xsl:if>
			<xsl:if test="$namespace = 'bsi'">
				<xsl:attribute name="border"><xsl:value-of select="$table-border"/></xsl:attribute>
				
				<xsl:if test="not(ancestor::*[local-name()='preface']) and ancestor::*[local-name() = 'table']/*[local-name() = 'thead'] and not(ancestor::*[local-name() = 'tr']/preceding-sibling::*[local-name() = 'tr'])">
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
				<xsl:if test="ancestor::*[local-name() = 'table'][1]/preceding-sibling::*[1][local-name() = 'figure'] and 
				ancestor::*[local-name() = 'table'][1]//*[local-name() = 'tr'][1]/*[local-name() = 'td'][normalize-space() = 'Key']">
					<xsl:attribute name="border">none</xsl:attribute>
					
					<xsl:if test="count(*) = 1 and local-name(*[1]) = 'figure'">
						<xsl:attribute name="padding-top">0.5mm</xsl:attribute>
						<xsl:attribute name="padding-left">0mm</xsl:attribute>
						<xsl:attribute name="padding-bottom">0mm</xsl:attribute>
						<xsl:attribute name="padding-right">0mm</xsl:attribute>
					</xsl:if>
				</xsl:if>
				
				
			</xsl:if>
			<xsl:if test="$namespace = 'jcgm'">
				<xsl:if test="count(*) = 1 and (local-name(*[1]) = 'stem' or local-name(*[1]) = 'figure')">
					<xsl:attribute name="padding-left">0mm</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$namespace = 'itu'">
				<xsl:if test="ancestor::*[local-name()='preface']">
					<xsl:attribute name="border">solid black 0pt</xsl:attribute>
				</xsl:if>
				<xsl:attribute name="display-align">before</xsl:attribute>
				<xsl:if test="$doctype = 'service-publication'">
					<xsl:attribute name="border">1pt solid rgb(211,211,211)</xsl:attribute>
					<xsl:attribute name="padding-top">1mm</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$namespace = 'bsi' or $namespace = 'iso' or $namespace = 'iec' or $namespace = 'jcgm'">
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
			<xsl:if test="$namespace = 'unece-rec'">
				<xsl:if test="ancestor::*[local-name()='sections']">
					<xsl:attribute name="border">solid black 0pt</xsl:attribute>
					<xsl:attribute name="padding-top">1mm</xsl:attribute>					
				</xsl:if>
				<xsl:attribute name="text-indent">0mm</xsl:attribute>
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
			<xsl:if test="$namespace = 'nist-cswp'  or $namespace = 'nist-sp'">
				<xsl:if test="ancestor::*[local-name()='thead']">
					<xsl:attribute name="font-weight">normal</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$namespace = 'bipm'">
				<xsl:attribute name="border">solid 0pt white</xsl:attribute>
				<xsl:variable name="rownum"><xsl:number count="*[local-name()='tr']"/></xsl:variable>
				<xsl:if test="$rownum = 1">
					<xsl:attribute name="padding-top">3mm</xsl:attribute>
				</xsl:if>
				<xsl:if test="not(ancestor::*[local-name()='tr']/following-sibling::*[local-name()='tr'])"> <!-- last row -->
					<xsl:attribute name="padding-bottom">2mm</xsl:attribute>
				</xsl:if>
				<xsl:if test="ancestor::*[local-name() = 'doccontrol']">
					<xsl:attribute name="display-align">before</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$namespace = 'rsd'">
				<xsl:attribute name="border">0pt solid black</xsl:attribute>
				<xsl:attribute name="padding-top">0.5mm</xsl:attribute>
			</xsl:if>
			<xsl:if test="$namespace = 'bsi'">
				<xsl:if test="$document_type = 'PAS'">
					<xsl:attribute name="border">1pt solid <xsl:value-of select="$color_PAS"/></xsl:attribute>
				</xsl:if>
			</xsl:if>
			
			<xsl:if test=".//*[local-name() = 'table']">
				<xsl:attribute name="padding-right">1mm</xsl:attribute>
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
			<xsl:call-template name="display-align" />
			<fo:block>
				<xsl:if test="$namespace = 'bipm'">
					<xsl:if test="not(.//bipm:image)">
						<xsl:attribute name="line-stacking-strategy">font-height</xsl:attribute>
					</xsl:if>
					<!-- hanging indent for left column -->
					<xsl:if test="not(preceding-sibling::*[local-name() = 'td'])">
						<xsl:attribute name="text-indent">-3mm</xsl:attribute>
						<xsl:attribute name="start-indent">3mm</xsl:attribute>
					</xsl:if>
				</xsl:if>				
				<xsl:apply-templates />
			</fo:block>			
		</fo:table-cell>
	</xsl:template>
	
	
	<xsl:template match="*[local-name()='table']/*[local-name()='note']" priority="2"/>
	<xsl:template match="*[local-name()='table']/*[local-name()='note']" mode="process">
		
		
			<fo:block font-size="10pt" margin-bottom="12pt">
				<xsl:if test="$namespace = 'bsi'">
					<xsl:attribute name="font-size">9pt</xsl:attribute>
					<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
					<xsl:if test="$document_type = 'PAS'">
						<xsl:attribute name="font-size">inherit</xsl:attribute>
						<xsl:attribute name="color"><xsl:value-of select="$color_PAS"/></xsl:attribute>
					</xsl:if>
				</xsl:if>
				<xsl:if test="$namespace = 'iso' or $namespace = 'jcgm'">
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
				<xsl:if test="$namespace = 'bipm'">					
					<xsl:attribute name="text-align">justify</xsl:attribute>
					<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
					<xsl:if test="ancestor::bipm:preface">
						<xsl:attribute name="margin-top">18pt</xsl:attribute>
						<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
					</xsl:if>
				</xsl:if>
				<xsl:if test="$namespace = 'rsd'">
					<xsl:attribute name="font-size">8pt</xsl:attribute>					
				</xsl:if>
				
				<!-- Table's note name (NOTE, for example) -->

				<fo:inline padding-right="2mm" xsl:use-attribute-sets="table-note-name-style">
					<xsl:if test="$namespace = 'bsi'">
						<xsl:if test="$document_type = 'PAS'">
							<xsl:attribute name="padding-right">1mm</xsl:attribute>
							<xsl:attribute name="font-style">italic</xsl:attribute>
						</xsl:if>
					</xsl:if>
					
					<xsl:if test="$namespace = 'unece'  or $namespace = 'unece-rec'">
						<xsl:if test="@type = 'source' or @type = 'abbreviation'">
							<xsl:attribute name="font-size">9pt</xsl:attribute>							
							<!-- <fo:inline>
								<xsl:call-template name="capitalize">
									<xsl:with-param name="str" select="@type"/>
								</xsl:call-template>
								<xsl:text>: </xsl:text>
							</fo:inline> -->
						</xsl:if>
					</xsl:if>
					<xsl:if test="$namespace = 'bipm'">
						<xsl:if test="ancestor::bipm:preface">
							<xsl:attribute name="text-decoration">underline</xsl:attribute>
						</xsl:if>
					</xsl:if>
					
					<xsl:apply-templates select="*[local-name() = 'name']" mode="presentation"/>
						
				</fo:inline>
				
				<xsl:if test="$namespace = 'bipm'">
					<xsl:if test="ancestor::bipm:preface">
						<fo:block>&#xA0;</fo:block>
					</xsl:if>
				</xsl:if>
				
				<xsl:apply-templates mode="process"/>
			</fo:block>
		
	</xsl:template>
	
	<xsl:template match="*[local-name()='table']/*[local-name()='note']/*[local-name()='name']" mode="process" /><!-- commended, because processed in mode="presentation" -->
	
	<xsl:template match="*[local-name()='table']/*[local-name()='note']/*[local-name()='p']" mode="process">
		<xsl:apply-templates/>
	</xsl:template>
	
	
	<xsl:template name="fn_display">
		<xsl:variable name="references">
			<xsl:if test="$namespace = 'bsi'">
				<xsl:for-each select="..//*[local-name()='fn'][local-name(..) = 'name']">
					<xsl:call-template name="create_fn" />
				</xsl:for-each>
			</xsl:if>
			<xsl:for-each select="..//*[local-name()='fn'][local-name(..) != 'name']">
				<xsl:call-template name="create_fn" />
			</xsl:for-each>
		</xsl:variable>
		
		<xsl:for-each select="xalan:nodeset($references)//fn">
			<xsl:variable name="reference" select="@reference"/>
			<xsl:if test="not(preceding-sibling::*[@reference = $reference])"> <!-- only unique reference puts in note-->
				<fo:block margin-bottom="12pt">
				
					<xsl:if test="$namespace = 'bsi'">
						<xsl:attribute name="font-size">9pt</xsl:attribute>
						<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
						<xsl:if test="$document_type = 'PAS'">
							<xsl:attribute name="font-size">inherit</xsl:attribute>
						</xsl:if>
					</xsl:if>
					<xsl:if test="$namespace = 'iso' or $namespace = 'jcgm'">
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
					<xsl:if test="$namespace = 'bipm'">
						<xsl:attribute name="font-size">9pt</xsl:attribute>
						<xsl:attribute name="text-indent">-6.5mm</xsl:attribute>
						<xsl:attribute name="margin-left">6.5mm</xsl:attribute>
						<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
					</xsl:if>
					<fo:inline font-size="80%" padding-right="5mm" id="{@id}">
						<xsl:if test="$namespace = 'itu' or $namespace = 'nist-cswp'  or $namespace = 'nist-sp' or $namespace = 'unece' or $namespace = 'unece-rec'  or $namespace = 'csd' or $namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'gb' or $namespace = 'm3d' or $namespace = 'iho'">
							<xsl:attribute name="vertical-align">super</xsl:attribute>
						</xsl:if>
						<xsl:if test="$namespace = 'iso' or $namespace = 'jcgm'">
							<xsl:attribute name="alignment-baseline">hanging</xsl:attribute>
						</xsl:if>
						<xsl:if test="$namespace = 'bsi'">
							<xsl:attribute name="baseline-shift">30%</xsl:attribute>
							<xsl:attribute name="font-size">80%</xsl:attribute>
							<xsl:if test="$document_type = 'PAS'">
								<xsl:attribute name="padding-right">0.5mm</xsl:attribute>
								<xsl:attribute name="font-size">4.5pt</xsl:attribute>
							</xsl:if>
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
						<xsl:if test="$namespace = 'nist-cswp'  or $namespace = 'nist-sp'">
							<xsl:attribute name="font-size">10pt</xsl:attribute>
						</xsl:if>
						<xsl:if test="$namespace = 'bipm'">
							<xsl:attribute name="font-style">italic</xsl:attribute>
							
							<xsl:attribute name="padding-right">2.5mm</xsl:attribute>
							<fo:inline font-style="normal">(</fo:inline>
						</xsl:if>
						<xsl:value-of select="@reference"/>
						<xsl:if test="$namespace = 'bipm'">
							<fo:inline font-style="normal">)</fo:inline>
						</xsl:if>
						<xsl:if test="$namespace = 'itu'">
							<!-- <xsl:if test="@preface = 'true'"> -->
								<xsl:text>)</xsl:text>
							<!-- </xsl:if> -->
						</xsl:if>
						<xsl:if test="$namespace = 'bsi'">
							<xsl:if test="$document_type = 'PAS'">
								<xsl:text>)</xsl:text>
							</xsl:if>
						</xsl:if>
					</fo:inline>
					<fo:inline>
						<xsl:if test="$namespace = 'nist-cswp'  or $namespace = 'nist-sp'">
							<xsl:attribute name="font-size">10pt</xsl:attribute>
						</xsl:if>
						<!-- <xsl:apply-templates /> -->
						<xsl:copy-of select="./node()"/>
					</fo:inline>
				</fo:block>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template name="create_fn">
		<fn reference="{@reference}" id="{@reference}_{ancestor::*[@id][1]/@id}">
			<xsl:if test="$namespace = 'itu'">
				<xsl:if test="ancestor::*[local-name()='preface']">
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
			<xsl:if test="$namespace = 'bsi' or $namespace = 'iso' or $namespace = 'iec'  or $namespace = 'gb' or $namespace = 'jcgm'">true</xsl:if> <!-- and (not(@class) or @class !='pseudocode') -->
		</xsl:variable>
		<xsl:variable name="references">
			<xsl:for-each select=".//*[local-name()='fn'][not(parent::*[local-name()='name'])]">
				<fn reference="{@reference}" id="{@reference}_{ancestor::*[@id][1]/@id}">
					<xsl:apply-templates />
				</fn>
			</xsl:for-each>
		</xsl:variable>
		
		<!-- current hierarchy is 'figure' element -->
		<xsl:variable name="following_dl_colwidths">
			<xsl:if test="*[local-name() = 'dl']"><!-- if there is a 'dl', then set the same columns width as for 'dl' -->
				<xsl:variable name="html-table">
					<xsl:variable name="doc_ns">
						<xsl:if test="$namespace = 'bipm'">bipm</xsl:if>
					</xsl:variable>
					<xsl:variable name="ns">
						<xsl:choose>
							<xsl:when test="normalize-space($doc_ns)  != ''">
								<xsl:value-of select="normalize-space($doc_ns)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring-before(name(/*), '-')"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<!-- <xsl:variable name="ns" select="substring-before(name(/*), '-')"/> -->
					<!-- <xsl:element name="{$ns}:table"> -->
						<xsl:for-each select="*[local-name() = 'dl'][1]">
							<tbody>
								<xsl:apply-templates mode="dl"/>
							</tbody>
						</xsl:for-each>
					<!-- </xsl:element> -->
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
											<!-- <xsl:apply-templates /> -->
											<xsl:copy-of select="./node()"/>
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
			<xsl:if test="$namespace = 'bsi'">
				<xsl:if test="ancestor::*[local-name()='table'] or ancestor::*[local-name()='table']">
					<xsl:attribute name="font-weight">normal</xsl:attribute>
					<xsl:attribute name="baseline-shift">25%</xsl:attribute>
					<xsl:if test="$document_type = 'PAS'">
						<xsl:attribute name="font-size">4.5pt</xsl:attribute>
						<xsl:attribute name="padding-left">0.5mm</xsl:attribute>
					</xsl:if>
				</xsl:if>
			</xsl:if>
			
			<xsl:if test="$namespace = 'iso' or $namespace = 'iec' or $namespace = 'jcgm'">
				<xsl:if test="ancestor::*[local-name()='table']">
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
			<xsl:if test="$namespace = 'ogc'">
				<xsl:attribute name="vertical-align">super</xsl:attribute>
			</xsl:if>
			<xsl:if test="$namespace = 'itu' or $namespace = 'nist-cswp'  or $namespace = 'nist-sp' or $namespace = 'ogc-white-paper'">
				<xsl:attribute name="vertical-align">super</xsl:attribute>
				<xsl:attribute name="color">blue</xsl:attribute>
			</xsl:if>
			<xsl:if test="$namespace = 'nist-cswp'  or $namespace = 'nist-sp' or $namespace = 'ogc-white-paper'">
				<xsl:attribute name="text-decoration">underline</xsl:attribute>
			</xsl:if>
			<xsl:if test="$namespace = 'bipm'">
				<xsl:attribute name="font-size">70%</xsl:attribute>
				<xsl:attribute name="vertical-align">super</xsl:attribute>
				<xsl:attribute name="font-style">italic</xsl:attribute>
			</xsl:if>
			<xsl:if test="$namespace = 'rsd'">
				<xsl:attribute name="font-size">70%</xsl:attribute>
				<xsl:attribute name="vertical-align">super</xsl:attribute>
				<xsl:attribute name="font-style">italic</xsl:attribute>
			</xsl:if>
			<fo:basic-link internal-destination="{@reference}_{ancestor::*[@id][1]/@id}" fox:alt-text="{@reference}"> <!-- @reference   | ancestor::*[local-name()='clause'][1]/@id-->
				<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
					<xsl:attribute name="internal-destination">
						<xsl:value-of select="@reference"/><xsl:text>_</xsl:text>
						<xsl:value-of select="ancestor::*[local-name()='table'][1]/@id"/>
					</xsl:attribute>
				</xsl:if>
				<xsl:if test="$namespace = 'bipm'">
					<fo:inline font-style="normal">&#xA0;(</fo:inline>
				</xsl:if>
				<xsl:value-of select="@reference"/>
				<xsl:if test="$namespace = 'bipm'">
					<fo:inline font-style="normal">)</fo:inline>
				</xsl:if>
				<xsl:if test="$namespace = 'bsi'">
					<xsl:if test="$document_type = 'PAS'">
						<xsl:text>)</xsl:text>
					</xsl:if>
				</xsl:if>
			</fo:basic-link>
		</fo:inline>
	</xsl:template>
	

	<xsl:template match="*[local-name()='fn']/*[local-name()='p']">
		<fo:inline>
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>

	<!-- Definition List -->
	<xsl:template match="*[local-name()='dl']">
		<xsl:variable name="isAdded" select="@added"/>
		<xsl:variable name="isDeleted" select="@deleted"/>
		<fo:block-container>
			<xsl:if test="$namespace = 'bsi' or $namespace = 'csa' or $namespace = 'csd' or $namespace = 'gb' or $namespace = 'iec' or $namespace = 'iho' or $namespace = 'iso' or $namespace = 'itu' or $namespace = 'm3d' or $namespace = 'mpfd' or $namespace = 'nist-cswp'  or $namespace = 'nist-sp' or $namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'rsd' or $namespace = 'unece' or $namespace = 'unece-rec' or $namespace = 'jcgm'">
				<xsl:if test="not(ancestor::*[local-name() = 'quote'])">
					<xsl:attribute name="margin-left">0mm</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$namespace = 'bipm'">
				<xsl:if test="not(ancestor::*[local-name() = 'li'])">
					<xsl:attribute name="margin-left">0mm</xsl:attribute>
				</xsl:if>
				<xsl:if test="ancestor::*[local-name() = 'li']">
					<xsl:attribute name="margin-left">6.5mm</xsl:attribute><!-- 8 mm -->
				</xsl:if>
			</xsl:if>
			<xsl:if test="parent::*[local-name() = 'note']">
				<xsl:attribute name="margin-left">
					<xsl:choose>
						<xsl:when test="not(ancestor::*[local-name() = 'table'])"><xsl:value-of select="$note-body-indent"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="$note-body-indent-table"/></xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:if test="$namespace = 'gb'">
					<xsl:attribute name="margin-left">0mm</xsl:attribute>
				</xsl:if>
			</xsl:if>
			
			<xsl:call-template name="setTrackChangesStyles">
				<xsl:with-param name="isAdded" select="$isAdded"/>
				<xsl:with-param name="isDeleted" select="$isDeleted"/>
			</xsl:call-template>
			
			<fo:block-container>
				<xsl:if test="$namespace = 'bsi' or $namespace = 'csa' or $namespace = 'csd' or $namespace = 'gb' or $namespace = 'iec' or $namespace = 'iho' or $namespace = 'iso' or $namespace = 'itu' or $namespace = 'm3d' or $namespace = 'mpfd' or $namespace = 'nist-cswp'  or $namespace = 'nist-sp' or $namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'rsd' or $namespace = 'unece' or $namespace = 'unece-rec' or $namespace = 'jcgm'">
					<xsl:attribute name="margin-left">0mm</xsl:attribute>
					<xsl:attribute name="margin-right">0mm</xsl:attribute>
				</xsl:if>
				<xsl:if test="$namespace = 'bipm'">
					<!-- <xsl:if test="not(ancestor::*[local-name() = 'li'])"> -->
						<xsl:attribute name="margin-left">0mm</xsl:attribute>
					<!-- </xsl:if> -->
				</xsl:if>
				<xsl:variable name="parent" select="local-name(..)"/>
				
				<xsl:variable name="key_iso">
					<xsl:if test="$namespace = 'bsi' or $namespace = 'iso' or $namespace = 'iec'  or $namespace = 'gb' or $namespace = 'jcgm'">
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
									<xsl:if test="$namespace = 'bsi' or $namespace = 'iso' or $namespace = 'jcgm'">
										<xsl:call-template name="getLocalizedString">
											<xsl:with-param name="key">where</xsl:with-param>
										</xsl:call-template>
									</xsl:if>
									<xsl:if test="$namespace = 'bipm' or $namespace = 'csa' or $namespace = 'csd' or $namespace = 'gb' or $namespace = 'iec' or $namespace = 'iho' or $namespace = 'itu' or $namespace = 'm3d' or $namespace = 'mpfd' or $namespace = 'nist-cswp'  or $namespace = 'nist-sp' or $namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'rsd' or $namespace = 'unece' or $namespace = 'unece-rec'">
										<xsl:call-template name="getTitle">
											<xsl:with-param name="name" select="'title-where'"/>
										</xsl:call-template>
									</xsl:if>
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
						<xsl:if test="$namespace = 'bsi' or $namespace = 'iso' or $namespace = 'itu' or $namespace = 'unece' or $namespace = 'unece-rec'  or $namespace = 'nist-cswp'  or $namespace = 'nist-sp' or $namespace = 'csa' or $namespace = 'csd' or $namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'm3d' or $namespace = 'iho' or $namespace = 'mpfd' or $namespace = 'rsd' or $namespace = 'bipm' or $namespace = 'jcgm'">
							<fo:block margin-bottom="12pt" text-align="left">
								<xsl:if test="$namespace = 'bsi' or $namespace = 'iso' or $namespace = 'iec' or $namespace = 'jcgm'">
									<xsl:attribute name="margin-bottom">0</xsl:attribute>
								</xsl:if>
								<xsl:variable name="title-where">
									<xsl:if test="$namespace = 'bsi' or $namespace = 'iso' or $namespace = 'jcgm'">
										<xsl:call-template name="getLocalizedString">
											<xsl:with-param name="key">where</xsl:with-param>
										</xsl:call-template>
									</xsl:if>
									<xsl:if test="$namespace = 'bipm' or $namespace = 'csa' or $namespace = 'csd' or $namespace = 'gb' or $namespace = 'iec' or $namespace = 'iho' or $namespace = 'itu' or $namespace = 'm3d' or $namespace = 'mpfd' or $namespace = 'nist-cswp'  or $namespace = 'nist-sp' or $namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'rsd' or $namespace = 'unece' or $namespace = 'unece-rec'">
										<xsl:call-template name="getTitle">
											<xsl:with-param name="name" select="'title-where'"/>
										</xsl:call-template>
									</xsl:if>
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
							<xsl:if test="$namespace = 'bsi' or $namespace = 'iso' or $namespace = 'jcgm'">
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
								<xsl:if test="$namespace = 'bsi' or $namespace = 'iso' or $namespace = 'jcgm'">
									<xsl:call-template name="getLocalizedString">
										<xsl:with-param name="key">where</xsl:with-param>
									</xsl:call-template>
								</xsl:if>
								<xsl:if test="$namespace = 'bipm' or $namespace = 'csa' or $namespace = 'csd' or $namespace = 'gb' or $namespace = 'iec' or $namespace = 'iho' or $namespace = 'itu' or $namespace = 'm3d' or $namespace = 'mpfd' or $namespace = 'nist-cswp'  or $namespace = 'nist-sp' or $namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'rsd' or $namespace = 'unece' or $namespace = 'unece-rec'">
									<xsl:call-template name="getTitle">
										<xsl:with-param name="name" select="'title-where'"/>
									</xsl:call-template>
								</xsl:if>								
							</xsl:variable>
							<xsl:value-of select="$title-where"/><xsl:if test="$namespace = 'itu'">:</xsl:if>
						</fo:block>
					</xsl:when>
					<xsl:when test="$parent = 'figure' and  (not(../@class) or ../@class !='pseudocode')">
						<fo:block font-weight="bold" text-align="left" margin-bottom="12pt" keep-with-next="always">
							<xsl:if test="$namespace = 'bsi' or $namespace = 'iso' or $namespace = 'jcgm'">
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
							<xsl:if test="$namespace = 'rsd'">
								<xsl:attribute name="font-weight">normal</xsl:attribute>
								<xsl:attribute name="color">black</xsl:attribute>
							</xsl:if>
							<xsl:variable name="title-key">
								<xsl:if test="$namespace = 'bsi' or $namespace = 'iso' or $namespace = 'jcgm'">
									<xsl:call-template name="getLocalizedString">
										<xsl:with-param name="key">key</xsl:with-param>
									</xsl:call-template>
								</xsl:if>
								<xsl:if test="$namespace = 'bipm' or $namespace = 'csa' or $namespace = 'csd' or $namespace = 'gb' or $namespace = 'iec' or $namespace = 'iho' or $namespace = 'itu' or $namespace = 'm3d' or $namespace = 'mpfd' or $namespace = 'nist-cswp'  or $namespace = 'nist-sp' or $namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'rsd' or $namespace = 'unece' or $namespace = 'unece-rec'">
									<xsl:call-template name="getTitle">
										<xsl:with-param name="name" select="'title-key'"/>
									</xsl:call-template>
								</xsl:if>
							</xsl:variable>
							<xsl:value-of select="$title-key"/>
						</fo:block>
					</xsl:when>
				</xsl:choose>
				
				<!-- a few components -->
				<xsl:if test="not($parent = 'formula' and count(*[local-name()='dt']) = 1)">
					<fo:block>
						<xsl:if test="$namespace = 'bsi' or $namespace = 'iso' or $namespace = 'jcgm'">
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
						<xsl:if test="$namespace = 'nist-cswp'  or $namespace = 'nist-sp'">
							<xsl:if test="not(.//*[local-name()='dt']//*[local-name()='stem'])">
								<xsl:attribute name="margin-left">5mm</xsl:attribute>
							</xsl:if>
						</xsl:if>
						<xsl:if test="$namespace = 'iho'">
							<xsl:attribute name="margin-left">7mm</xsl:attribute>
						</xsl:if>
						<fo:block>
							<xsl:if test="$namespace = 'nist-cswp'  or $namespace = 'nist-sp'">
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
									<xsl:variable name="doc_ns">
										<xsl:if test="$namespace = 'bipm'">bipm</xsl:if>
									</xsl:variable>
									<xsl:variable name="ns">
										<xsl:choose>
											<xsl:when test="normalize-space($doc_ns)  != ''">
												<xsl:value-of select="normalize-space($doc_ns)"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="substring-before(name(/*), '-')"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<!-- <xsl:variable name="ns" select="substring-before(name(/*), '-')"/> -->
									<!-- <xsl:element name="{$ns}:table"> -->
										<tbody>
											<xsl:apply-templates mode="dl"/>
										</tbody>
									<!-- </xsl:element> -->
								</xsl:variable>
								<!-- html-table<xsl:copy-of select="$html-table"/> -->
								<xsl:variable name="colwidths">
									<xsl:call-template name="calculate-column-widths">
										<xsl:with-param name="cols-count" select="2"/>
										<xsl:with-param name="table" select="$html-table"/>
									</xsl:call-template>
								</xsl:variable>
								<!-- colwidths=<xsl:copy-of select="$colwidths"/> -->
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
			</fo:block-container>
		</fo:block-container>
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
					<!-- to set width check most wide chars like `W` -->
					<xsl:when test="normalize-space($maxlength_dt) != '' and number($maxlength_dt) &lt;= 2"> <!-- if dt contains short text like t90, a, etc -->
						<fo:table-column column-width="7%"/>
						<fo:table-column column-width="93%"/>
					</xsl:when>
					<xsl:when test="normalize-space($maxlength_dt) != '' and number($maxlength_dt) &lt;= 5"> <!-- if dt contains short text like ABC, etc -->
						<fo:table-column column-width="15%"/>
						<fo:table-column column-width="85%"/>
					</xsl:when>
					<xsl:when test="normalize-space($maxlength_dt) != '' and number($maxlength_dt) &lt;= 7"> <!-- if dt contains short text like ABCDEF, etc -->
						<fo:table-column column-width="20%"/>
						<fo:table-column column-width="80%"/>
					</xsl:when>
					<xsl:when test="normalize-space($maxlength_dt) != '' and number($maxlength_dt) &lt;= 10"> <!-- if dt contains short text like ABCDEFEF, etc -->
						<fo:table-column column-width="25%"/>
						<fo:table-column column-width="75%"/>
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
		<xsl:variable name="lengths">
			<xsl:for-each select="*[local-name()='dt']">
				<xsl:variable name="maintext_length" select="string-length(normalize-space(.))"/>
				<xsl:variable name="attributes">
					<xsl:for-each select=".//@open"><xsl:value-of select="."/></xsl:for-each>
					<xsl:for-each select=".//@close"><xsl:value-of select="."/></xsl:for-each>
				</xsl:variable>
				<length><xsl:value-of select="string-length(normalize-space(.)) + string-length($attributes)"/></length>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="maxLength">
			<!-- <xsl:for-each select="*[local-name()='dt']">
				<xsl:sort select="string-length(normalize-space(.))" data-type="number" order="descending"/>
				<xsl:if test="position() = 1">
					<xsl:value-of select="string-length(normalize-space(.))"/>
				</xsl:if>
			</xsl:for-each> -->
			<xsl:for-each select="xalan:nodeset($lengths)/length">
				<xsl:sort select="." data-type="number" order="descending"/>
				<xsl:if test="position() = 1">
					<xsl:value-of select="."/>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<!-- <xsl:message>DEBUG:<xsl:value-of select="$maxLength"/></xsl:message> -->
		<xsl:value-of select="$maxLength"/>
	</xsl:template>
	
	<xsl:template match="*[local-name()='dl']/*[local-name()='note']" priority="2">
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
				<xsl:if test="$namespace = 'nist-cswp'  or $namespace = 'nist-sp'">
					<xsl:if test="local-name(*[1]) != 'stem'">
						<xsl:apply-templates select="following-sibling::*[local-name()='dd'][1]" mode="process"/>
					</xsl:if>
				</xsl:if>
				<xsl:if test="$namespace = 'bsi' or $namespace = 'iso' or $namespace = 'iec' or $namespace = 'itu' or $namespace = 'unece' or $namespace = 'unece-rec'  or $namespace = 'csa' or $namespace = 'csd' or $namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'gb' or $namespace = 'm3d' or $namespace = 'iho' or $namespace = 'mpfd' or $namespace = 'rsd' or $namespace = 'bipm' or $namespace = 'jcgm'">
					<xsl:apply-templates select="following-sibling::*[local-name()='dd'][1]" mode="process"/>
				</xsl:if>
			</td>
		</tr>
		<xsl:if test="$namespace = 'nist-cswp'  or $namespace = 'nist-sp'">
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
			<xsl:if test="$namespace = 'ogc'">
				<xsl:attribute name="min-height">8.5mm</xsl:attribute>
			</xsl:if>
			<xsl:if test="$namespace = 'rsd'">
				<xsl:attribute name="min-height">7mm</xsl:attribute>
			</xsl:if>
			<fo:table-cell>
				<xsl:if test="$namespace = 'itu'">
					<xsl:if test="ancestor::*[1][local-name() = 'dl']/preceding-sibling::*[1][local-name() = 'formula']">						
						<xsl:attribute name="padding-right">3mm</xsl:attribute>
					</xsl:if>
				</xsl:if>
				<fo:block margin-top="6pt">
					<xsl:if test="$namespace = 'bsi' or $namespace = 'iso' or $namespace = 'jcgm'">
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
					<xsl:if test="$namespace = 'nist-cswp'  or $namespace = 'nist-sp'">
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
					<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
						<xsl:attribute name="margin-top">0pt</xsl:attribute>
						<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
					</xsl:if>
					<xsl:if test="$namespace = 'bipm'">
						<xsl:attribute name="margin-top">0pt</xsl:attribute>
						<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
					</xsl:if>
					<xsl:if test="$namespace = 'rsd'">
						<xsl:attribute name="margin-top">0pt</xsl:attribute>
						<xsl:attribute name="font-weight">bold</xsl:attribute>
						<xsl:attribute name="color"><xsl:value-of select="$color_blue"/></xsl:attribute>
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
					<!-- <xsl:if test="$namespace = 'nist-cswp'  or $namespace = 'nist-sp'">
						<xsl:if test="local-name(*[1]) != 'stem'">
							<xsl:apply-templates select="following-sibling::*[local-name()='dd'][1]" mode="process"/>
						</xsl:if>
					</xsl:if> -->
					<xsl:if test="$namespace = 'bsi' or $namespace = 'iso' or $namespace = 'iec' or $namespace = 'itu' or $namespace = 'unece' or $namespace = 'unece-rec' or $namespace = 'csa'  or $namespace = 'csd' or $namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'gb' or $namespace = 'm3d' or $namespace = 'iho' or $namespace = 'mpfd' or $namespace = 'nist-cswp'  or $namespace = 'nist-sp' or $namespace = 'rsd' or $namespace = 'bipm' or $namespace = 'jcgm'">
						<xsl:apply-templates select="following-sibling::*[local-name()='dd'][1]" mode="process"/>
					</xsl:if>
				</fo:block>
			</fo:table-cell>
		</fo:table-row>
		<!-- <xsl:if test="$namespace = 'nist-cswp'  or $namespace = 'nist-sp'">
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
		</xsl:if> -->
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

	<xsl:template match="*[local-name()='strong'] | *[local-name()='b']">
		<fo:inline font-weight="bold">
			<xsl:if test="$namespace = 'rsd'">
				<xsl:attribute name="font-weight">normal</xsl:attribute>
				<xsl:attribute name="color">black</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="*[local-name()='padding']">
		<fo:inline padding-right="{@value}">&#xA0;</fo:inline>
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
		<fo:inline xsl:use-attribute-sets="tt-style">
			<xsl:variable name="_font-size">
				<xsl:if test="$namespace = 'csa'">10</xsl:if>
				<xsl:if test="$namespace = 'csd'">10</xsl:if>
				<xsl:if test="$namespace = 'gb'">10</xsl:if>
				<xsl:if test="$namespace = 'iec'">10</xsl:if>
				<xsl:if test="$namespace = 'iho'">10</xsl:if>
				<xsl:if test="$namespace = 'iso'">10</xsl:if>
				<xsl:if test="$namespace = 'bsi'">10</xsl:if>
				<xsl:if test="$namespace = 'jcgm'">10</xsl:if>
				<xsl:if test="$namespace = 'itu'"></xsl:if>
				<xsl:if test="$namespace = 'm3d'">
					<xsl:choose>
						<xsl:when test="not(ancestor::*[local-name()='note'])">10</xsl:when>
						<xsl:otherwise>11</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
				<xsl:if test="$namespace = 'mpfd'"></xsl:if>
				<xsl:if test="$namespace = 'nist-cswp'  or $namespace = 'nist-sp'"></xsl:if>
				<xsl:if test="$namespace = 'ogc'">10</xsl:if>
				<xsl:if test="$namespace = 'ogc-white-paper'">10</xsl:if>
				<xsl:if test="$namespace = 'rsd'">
					<xsl:choose>
						<xsl:when test="ancestor::*[local-name() = 'table']">inherit</xsl:when>
						<xsl:otherwise>110%</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
				<xsl:if test="$namespace = 'unece' or $namespace = 'unece-rec'"></xsl:if>		
			</xsl:variable>
			<xsl:variable name="font-size" select="normalize-space($_font-size)"/>		
			<xsl:if test="$font-size != ''">
				<xsl:attribute name="font-size">
					<xsl:choose>
						<xsl:when test="$font-size = 'inherit'"><xsl:value-of select="$font-size"/></xsl:when>
						<xsl:when test="contains($font-size, '%')"><xsl:value-of select="$font-size"/></xsl:when>
						<xsl:when test="ancestor::*[local-name()='note']"><xsl:value-of select="$font-size * 0.91"/>pt</xsl:when>
						<xsl:otherwise><xsl:value-of select="$font-size"/>pt</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="*[local-name()='underline']">
		<fo:inline text-decoration="underline">
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="*[local-name()='add']">
		<xsl:choose>
			<xsl:when test="@amendment">
				<fo:inline>
					<xsl:call-template name="insertTag">
						<xsl:with-param name="kind">A</xsl:with-param>
						<xsl:with-param name="value"><xsl:value-of select="@amendment"/></xsl:with-param>
					</xsl:call-template>
					<xsl:apply-templates />
					<xsl:call-template name="insertTag">
						<xsl:with-param name="type">closing</xsl:with-param>
						<xsl:with-param name="kind">A</xsl:with-param>
						<xsl:with-param name="value"><xsl:value-of select="@amendment"/></xsl:with-param>
					</xsl:call-template>
				</fo:inline>
			</xsl:when>
			<xsl:when test="@corrigenda">
				<fo:inline>
					<xsl:call-template name="insertTag">
						<xsl:with-param name="kind">C</xsl:with-param>
						<xsl:with-param name="value"><xsl:value-of select="@corrigenda"/></xsl:with-param>
					</xsl:call-template>
					<xsl:apply-templates />
					<xsl:call-template name="insertTag">
						<xsl:with-param name="type">closing</xsl:with-param>
						<xsl:with-param name="kind">C</xsl:with-param>
						<xsl:with-param name="value"><xsl:value-of select="@corrigenda"/></xsl:with-param>
					</xsl:call-template>
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<fo:inline xsl:use-attribute-sets="add-style">
					<xsl:apply-templates />
				</fo:inline>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
	<xsl:template name="insertTag">
		<xsl:param name="type"/>
		<xsl:param name="kind"/>
		<xsl:param name="value"/>
		<xsl:variable name="add_width" select="string-length($value) * 20" />
		<xsl:variable name="maxwidth" select="60 + $add_width"/>
			<fo:instream-foreign-object fox:alt-text="OpeningTag" baseline-shift="-20%"><!-- alignment-baseline="middle" -->
				<!-- <xsl:attribute name="width">7mm</xsl:attribute>
				<xsl:attribute name="content-height">100%</xsl:attribute> -->
				<xsl:attribute name="height">5mm</xsl:attribute>
				<xsl:attribute name="content-width">100%</xsl:attribute>
				<xsl:attribute name="content-width">scale-down-to-fit</xsl:attribute>
				<xsl:attribute name="scaling">uniform</xsl:attribute>
				<svg xmlns="http://www.w3.org/2000/svg" width="{$maxwidth + 32}" height="80">
					<g>
						<xsl:if test="$type = 'closing'">
							<xsl:attribute name="transform">scale(-1 1) translate(-<xsl:value-of select="$maxwidth + 32"/>,0)</xsl:attribute>
						</xsl:if>
						<polyline points="0,0 {$maxwidth},0 {$maxwidth + 30},40 {$maxwidth},80 0,80 " stroke="black" stroke-width="5" fill="white"/>
						<line x1="0" y1="0" x2="0" y2="80" stroke="black" stroke-width="20"/>
					</g>
					<text font-family="Arial" x="15" y="57" font-size="40pt">
						<xsl:if test="$type = 'closing'">
							<xsl:attribute name="x">25</xsl:attribute>
						</xsl:if>
						<xsl:value-of select="$kind"/><tspan dy="10" font-size="30pt"><xsl:value-of select="$value"/></tspan>
					</text>
				</svg>
			</fo:instream-foreign-object>
	</xsl:template>
	
	<xsl:template match="*[local-name()='del']">
		<fo:inline xsl:use-attribute-sets="del-style">
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>
	
	<!-- highlight text -->
	<xsl:template match="*[local-name()='hi']">
		<fo:inline background-color="yellow">
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
	
	<xsl:template name="add-zero-spaces-link-java">
		<xsl:param name="text" select="."/>
		<!-- add zero-width space (#x200B) after characters: dash, dot, colon, equal, underscore, em dash, thin space  -->
		<xsl:value-of select="java:replaceAll(java:java.lang.String.new($text),'(-|\.|:|=|_|—| |,)','$1&#x200B;')"/>
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
		<xsl:variable name="language_current" select="normalize-space(//*[local-name()='bibdata']//*[local-name()='language'][@current = 'true'])"/>
		<xsl:variable name="language_current_2" select="normalize-space(xalan:nodeset($bibdata)//*[local-name()='bibdata']//*[local-name()='language'][@current = 'true'])"/>
		<xsl:variable name="language">
			<xsl:choose>
				<xsl:when test="$language_current != ''">
					<xsl:value-of select="$language_current"/>
				</xsl:when>
				<xsl:when test="$language_current_2 != ''">
					<xsl:value-of select="$language_current_2"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="//*[local-name()='bibdata']//*[local-name()='language']"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
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
		<xsl:variable name="isAdded" select="@added"/>
		<xsl:variable name="isDeleted" select="@deleted"/>
		
		<fo:inline xsl:use-attribute-sets="mathml-style">
			<xsl:if test="$namespace = 'bipm'">
				<xsl:if test="ancestor::*[local-name()='table']">
					<xsl:attribute name="font-size">95%</xsl:attribute> <!-- base font in table is 10pt -->
				</xsl:if>
			</xsl:if>
			
			<xsl:call-template name="setTrackChangesStyles">
				<xsl:with-param name="isAdded" select="$isAdded"/>
				<xsl:with-param name="isDeleted" select="$isDeleted"/>
			</xsl:call-template>
			
			<xsl:if test="$namespace = 'bipm'"> <!-- insert helper tag -->
				<xsl:if test="$add_math_as_text = 'true'">
					<fo:inline color="white" font-size="1pt" font-style="normal" font-weight="normal">&#x200b;</fo:inline> <!-- zero width space -->
				</xsl:if>
			</xsl:if>
			
			<xsl:variable name="mathml">
				<xsl:apply-templates select="." mode="mathml"/>
			</xsl:variable>
			<fo:instream-foreign-object fox:alt-text="Math">
				<xsl:if test="$namespace = 'bipm'">
					<xsl:if test="local-name(../..) = 'formula'">
						<xsl:attribute name="width">95%</xsl:attribute>
						<xsl:attribute name="content-height">100%</xsl:attribute>
						<xsl:attribute name="content-width">scale-down-to-fit</xsl:attribute>
						<xsl:attribute name="scaling">uniform</xsl:attribute>
					</xsl:if>
					
					<xsl:if test="$add_math_as_text = 'true'">
						<!-- <xsl:variable name="comment_text" select="following-sibling::node()[1][self::comment()]"/> -->
						<xsl:variable name="comment_text" select="normalize-space(translate(.,'&#xa0;&#8290;','  '))"/>
						<!-- <xsl:variable name="comment_text" select="normalize-space(.)"/> -->
						<xsl:if test="normalize-space($comment_text) != ''">
						<!-- put Mathin Alternate Text -->
							<xsl:attribute name="fox:alt-text">
								<xsl:value-of select="java:org.metanorma.fop.Util.unescape($comment_text)"/>
								<!-- <xsl:value-of select="$comment_text"/> -->
							</xsl:attribute>
						</xsl:if>
					</xsl:if>
				</xsl:if>
				
				<xsl:variable name="comment_text_following" select="following-sibling::node()[1][self::comment()]"/>
				<xsl:variable name="comment_text_">
					<xsl:choose>
						<xsl:when test="normalize-space($comment_text_following) != ''">
							<xsl:value-of select="$comment_text_following"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="normalize-space(translate(.,'&#xa0;&#8290;','  '))"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable> 
				<xsl:variable name="comment_text" select="java:org.metanorma.fop.Util.unescape($comment_text_)"/>
				
				<xsl:if test="normalize-space($comment_text) != ''">
				<!-- put Mathin Alternate Text -->
					<xsl:attribute name="fox:alt-text">
						<xsl:value-of select="java:org.metanorma.fop.Util.unescape($comment_text)"/>
					</xsl:attribute>
				</xsl:if>
				
				<xsl:variable name="mathml_content">
					<xsl:apply-templates select="." mode="mathml_actual_text"/>
				</xsl:variable>
				<!-- put MathML in Actual Text -->
				<xsl:attribute name="fox:actual-text">
					<xsl:value-of select="$mathml_content"/>
				</xsl:attribute>
				
				<xsl:if test="$namespace = 'bsi' or $namespace = 'iso'">
					<xsl:if test="count(ancestor::*[local-name() = 'table']) &gt; 1">
						<xsl:attribute name="width">95%</xsl:attribute>
						<xsl:attribute name="content-height">100%</xsl:attribute>
						<xsl:attribute name="content-width">scale-down-to-fit</xsl:attribute>
						<xsl:attribute name="scaling">uniform</xsl:attribute>
					</xsl:if>
				</xsl:if>
				<!-- <xsl:copy-of select="."/> -->
				<xsl:copy-of select="xalan:nodeset($mathml)"/>
			</fo:instream-foreign-object>			
		</fo:inline>
	</xsl:template>

	<xsl:template match="mathml:*" mode="mathml_actual_text">
		<!-- <xsl:text>a+b</xsl:text> -->
		<xsl:text>&lt;</xsl:text>
		<xsl:value-of select="local-name()"/>
		<xsl:if test="local-name() = 'math'">
			<xsl:text> xmlns="http://www.w3.org/1998/Math/MathML"</xsl:text>
		</xsl:if>
		<xsl:for-each select="@*">
			<xsl:text> </xsl:text>
			<xsl:value-of select="local-name()"/>
			<xsl:text>="</xsl:text>
			<xsl:value-of select="."/>
			<xsl:text>"</xsl:text>
		</xsl:for-each>
		<xsl:text>&gt;</xsl:text>		
		<xsl:apply-templates mode="mathml_actual_text"/>		
		<xsl:text>&lt;/</xsl:text>
		<xsl:value-of select="local-name()"/>
		<xsl:text>&gt;</xsl:text>
	</xsl:template>
	
	<xsl:template match="text()" mode="mathml_actual_text">
		<xsl:value-of select="normalize-space()"/>
	</xsl:template>

	<xsl:template match="@*|node()" mode="mathml">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="mathml"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="mathml:mtext" mode="mathml">
		<xsl:copy>
			<!-- replace start and end spaces to non-break space -->
			<xsl:value-of select="java:replaceAll(java:java.lang.String.new(.),'(^ )|( $)','&#xA0;')"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- <xsl:template match="mathml:mi[. = ',' and not(following-sibling::*[1][local-name() = 'mtext' and text() = '&#xa0;'])]" mode="mathml">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="mathml"/>
		</xsl:copy>
		<xsl:choose>
			if in msub, then don't add space
			<xsl:when test="ancestor::mathml:mrow[parent::mathml:msub and preceding-sibling::*[1][self::mathml:mrow]]"></xsl:when>
			if next char in digit,  don't add space
			<xsl:when test="translate(substring(following-sibling::*[1]/text(),1,1),'0123456789','') = ''"></xsl:when>
			<xsl:otherwise>
				<mathml:mspace width="0.5ex"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> -->

	<xsl:template match="mathml:math/*[local-name()='unit']" mode="mathml"/>
	<xsl:template match="mathml:math/*[local-name()='prefix']" mode="mathml"/>
	<xsl:template match="mathml:math/*[local-name()='dimension']" mode="mathml"/>
	<xsl:template match="mathml:math/*[local-name()='quantity']" mode="mathml"/>

	<xsl:template match="*[local-name()='localityStack']"/>

	<xsl:template match="*[local-name()='link']" name="link">
		<xsl:variable name="target">
			<xsl:choose>
				<xsl:when test="@updatetype = 'true'">
					<xsl:value-of select="concat(normalize-space(@target), '.pdf')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space(@target)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="target_text">
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
			<xsl:if test="$namespace = 'iec'">
				<xsl:if test="ancestor::*[local-name()='feedback-statement']">
					<xsl:attribute name="color">blue</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$namespace = 'rsd'">
				<xsl:if test="ancestor::*[local-name() = 'bibitem']">
					<xsl:attribute name="color">black</xsl:attribute>
					<xsl:attribute name="text-decoration">none</xsl:attribute>
					<xsl:attribute name="font-weight">300</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$namespace = 'bsi'">
				<xsl:if test="$document_type = 'PAS'">
					<xsl:attribute name="color">inherit</xsl:attribute>
					<xsl:attribute name="text-decoration">none</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="$target_text = ''">
					<xsl:apply-templates />
				</xsl:when>
				<xsl:otherwise>
					<fo:basic-link external-destination="{$target}" fox:alt-text="{$target}">
						<xsl:choose>
							<xsl:when test="normalize-space(.) = ''">
								<xsl:call-template name="add-zero-spaces-link-java">
									<xsl:with-param name="text" select="$target_text"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:otherwise>
								<!-- output text from <link>text</link> -->
								<xsl:apply-templates />
							</xsl:otherwise>
						</xsl:choose>
					</fo:basic-link>
				</xsl:otherwise>
			</xsl:choose>
		</fo:inline>
	</xsl:template>

	
	<xsl:template match="*[local-name()='appendix']">
		<fo:block id="{@id}" xsl:use-attribute-sets="appendix-style">
			<xsl:apply-templates select="*[local-name()='title']" mode="process"/>
		</fo:block>
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="*[local-name()='appendix']/*[local-name()='title']"/>
	<xsl:template match="*[local-name()='appendix']/*[local-name()='title']" mode="process">
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		<fo:inline role="H{$level}"><xsl:apply-templates /></fo:inline>
	</xsl:template>
	
	
	<xsl:template match="*[local-name()='appendix']//*[local-name()='example']" priority="2">
		<fo:block id="{@id}" xsl:use-attribute-sets="appendix-example-style">			
			<xsl:apply-templates select="*[local-name()='name']" mode="presentation"/>
		</fo:block>
		<xsl:apply-templates />
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
			<xsl:if test="$namespace = 'bsi' or $namespace = 'iso' or $namespace = 'jcgm'">
				<xsl:call-template name="getLocalizedString">
					<xsl:with-param name="key">modified</xsl:with-param>
				</xsl:call-template>
			</xsl:if>
			<xsl:if test="$namespace = 'bipm' or $namespace = 'csa' or $namespace = 'csd' or $namespace = 'gb' or $namespace = 'iec' or $namespace = 'iho' or $namespace = 'itu' or $namespace = 'm3d' or $namespace = 'mpfd' or $namespace = 'nist-cswp'  or $namespace = 'nist-sp' or $namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'rsd' or $namespace = 'unece' or $namespace = 'unece-rec'">
				<xsl:call-template name="getTitle">
					<xsl:with-param name="name" select="'title-modified'"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:variable>
		
    <xsl:variable name="text"><xsl:apply-templates/></xsl:variable>
		<xsl:choose>
			<xsl:when test="$lang = 'zh'"><xsl:text>、</xsl:text><xsl:value-of select="$title-modified"/><xsl:if test="normalize-space($text) != ''"><xsl:text>—</xsl:text></xsl:if></xsl:when>
			<xsl:otherwise><xsl:text>, </xsl:text><xsl:value-of select="$title-modified"/><xsl:if test="normalize-space($text) != ''"><xsl:text> — </xsl:text></xsl:if></xsl:otherwise>
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
	<xsl:template match="*[local-name() = 'formula']" name="formula">
		<fo:block-container margin-left="0mm">
			<xsl:if test="parent::*[local-name() = 'note']">
				<xsl:attribute name="margin-left">
					<xsl:choose>
						<xsl:when test="not(ancestor::*[local-name() = 'table'])"><xsl:value-of select="$note-body-indent"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="$note-body-indent-table"/></xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:if test="$namespace = 'gb'">
					<xsl:attribute name="margin-left">0mm</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<fo:block-container margin-left="0mm">	
				<fo:block id="{@id}" xsl:use-attribute-sets="formula-style">
					<xsl:apply-templates />
				</fo:block>
			</fo:block-container>
		</fo:block-container>
	</xsl:template>

	
	<xsl:template match="*[local-name() = 'formula']/*[local-name() = 'dt']/*[local-name() = 'stem']">
		<fo:inline>
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'admitted']/*[local-name() = 'stem']">
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
	
	<xsl:template match="*[local-name() = 'note']" name="note">
	
		<fo:block-container id="{@id}" xsl:use-attribute-sets="note-style">
			<xsl:if test="$namespace = 'unece-rec'">
				<xsl:if test="../@type = 'source' or ../@type = 'abbreviation'">
					<xsl:attribute name="border-top">0pt solid black</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
				<xsl:if test="ancestor::ogc:ul or ancestor::ogc:ol and not(ancestor::ogc:note[1]/following-sibling::*)">
					<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$namespace = 'rsd'">
				<xsl:if test="ancestor::rsd:ul or ancestor::rsd:ol and not(ancestor::rsd:note[1]/following-sibling::*)">
					<xsl:attribute name="margin-top">6pt</xsl:attribute>
					<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$namespace = 'bsi'">
				<xsl:if test="$document_type = 'PAS'">
					<xsl:attribute name="font-size">inherit</xsl:attribute>
					<xsl:attribute name="color"><xsl:value-of select="$color_PAS"/></xsl:attribute>
					<xsl:attribute name="line-height">1.3</xsl:attribute>
					<xsl:if test="following-sibling::*[1][local-name() = 'clause']">
						<xsl:attribute name="space-after">12pt</xsl:attribute>
						<xsl:if test="following-sibling::*[2][local-name() = 'title']/@depth = 2">
							<xsl:attribute name="space-after">24pt</xsl:attribute>
						</xsl:if>
					</xsl:if>
					<!-- <xsl:if test="not(following-sibling::*[local-name() = 'note'])">
						<xsl:attribute name="space-after">24pt</xsl:attribute>
					</xsl:if> -->
				</xsl:if>
			</xsl:if>
			<xsl:if test="$namespace = 'bipm'">
				<xsl:if test="parent::*[local-name() = 'li']">
					<xsl:attribute name="margin-top">4pt</xsl:attribute>
					<xsl:attribute name="margin-bottom">4pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<fo:block-container margin-left="0mm">
				<xsl:if test="$namespace = 'gb'">
					<fo:table table-layout="fixed" width="100%">
						<fo:table-column column-width="10mm"/>
						<fo:table-column column-width="155mm"/>
						<fo:table-body>
							<fo:table-row>
								<fo:table-cell>
									<fo:block font-family="SimHei" xsl:use-attribute-sets="note-name-style">
										<xsl:apply-templates select="gb:name" mode="presentation"/>
									</fo:block>
								</fo:table-cell>
								<fo:table-cell>
									<fo:block text-align="justify">
										<xsl:apply-templates />
									</fo:block>
								</fo:table-cell>
							</fo:table-row>
						</fo:table-body>
					</fo:table>
				</xsl:if>
				
				
				<xsl:if test="$namespace = 'csa'">
					<xsl:if test="ancestor::csa:ul or ancestor::csa:ol and not(ancestor::csa:note[1]/following-sibling::*)">
						<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
					</xsl:if>
				</xsl:if>
				
				<xsl:if test="$namespace = 'iho'">
					<xsl:if test="ancestor::iho:td">
						<xsl:attribute name="font-size">12pt</xsl:attribute>
					</xsl:if>
				</xsl:if>

				<xsl:if test="$namespace = 'bsi' or $namespace = 'csa' or $namespace = 'csd' or $namespace = 'iec' or $namespace = 'iho' or $namespace = 'iso' or $namespace = 'itu' or
							$namespace = 'm3d' or $namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'rsd' or $namespace = 'nist-cswp' or $namespace = 'nist-sp' or $namespace = 'unece-rec' or $namespace = 'unece' or $namespace = 'mpfd' or $namespace = 'bipm' or $namespace = 'jcgm'">
					<fo:block>
						<xsl:if test="$namespace = 'itu'">
							<xsl:if test="ancestor::itu:figure">
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
						
						<xsl:if test="$namespace = 'bipm'">
							<xsl:if test="@parent-type = 'quote'">
								<xsl:attribute name="font-family">Arial</xsl:attribute>
								<xsl:attribute name="font-size">9pt</xsl:attribute>
								<xsl:attribute name="line-height">130%</xsl:attribute>
								<xsl:attribute name="text-align">justify</xsl:attribute>
							</xsl:if>
						</xsl:if>
						
						
						<fo:inline xsl:use-attribute-sets="note-name-style">
							<xsl:if test="$namespace = 'bsi'">
								<xsl:variable name="name" select="normalize-space(*[local-name() = 'name'])" />
								<!-- if NOTE without number -->
								<xsl:if test="translate(substring($name, string-length($name)), '0123456789', '') != ''">
									<xsl:attribute name="padding-right">3.5mm</xsl:attribute>
								</xsl:if>
								<xsl:if test="$document_type = 'PAS'">
									<xsl:attribute name="padding-right">0.5mm</xsl:attribute>
									<xsl:attribute name="font-weight">bold</xsl:attribute>
								</xsl:if>
							</xsl:if>
							<xsl:apply-templates select="*[local-name() = 'name']" mode="presentation"/>
						</fo:inline>
						<xsl:apply-templates />
					</fo:block>
				</xsl:if>
				
			</fo:block-container>
		</fo:block-container>
		
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'note']/*[local-name() = 'p']">
		<xsl:variable name="num"><xsl:number/></xsl:variable>
		<xsl:choose>
			<xsl:when test="$num = 1">
				<fo:inline xsl:use-attribute-sets="note-p-style">
					<xsl:apply-templates />
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<fo:block xsl:use-attribute-sets="note-p-style">						
					<xsl:apply-templates />
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<xsl:template match="*[local-name() = 'termnote']">
		<fo:block id="{@id}" xsl:use-attribute-sets="termnote-style">			
			<xsl:if test="$namespace = 'bsi'">
				<xsl:if test="$document_type = 'PAS'">
					<xsl:attribute name="space-before">0pt</xsl:attribute>
						<xsl:if test="not(following-sibling::*)">
							<xsl:attribute name="space-after">24pt</xsl:attribute>
						</xsl:if>
					<xsl:attribute name="color"><xsl:value-of select="$color_PAS"/></xsl:attribute>
				</xsl:if>
			</xsl:if>
			<fo:inline xsl:use-attribute-sets="termnote-name-style">
				<xsl:if test="$namespace = 'bsi'">
					<xsl:variable name="name" select="normalize-space(*[local-name() = 'name'])" />
					<!-- if NOTE without number -->
					<xsl:if test="translate(substring($name, string-length($name)), '0123456789', '') != ''">
						<xsl:attribute name="padding-right">3.5mm</xsl:attribute>
					</xsl:if>
					<xsl:if test="$document_type = 'PAS'">
						<xsl:attribute name="padding-right">1mm</xsl:attribute>
						<xsl:attribute name="font-weight">bold</xsl:attribute>
						
					</xsl:if>
				</xsl:if>
				<xsl:apply-templates select="*[local-name() = 'name']" mode="presentation"/>
			</fo:inline>
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
					<xsl:if test="$namespace = 'gb' or $namespace = 'm3d' or  $namespace = 'ogc' or $namespace = 'unece-rec' or $namespace = 'unece'  or $namespace = 'bipm' or $namespace = 'rsd'">
						<xsl:text>:</xsl:text>
					</xsl:if>
					<xsl:if test="$namespace = 'itu' or $namespace = 'nist-cswp'  or $namespace = 'nist-sp'">				
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
		<xsl:param name="sfx"/>
		<xsl:variable name="suffix">
			<xsl:choose>
				<xsl:when test="$sfx != ''">
					<xsl:value-of select="$sfx"/>					
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="$namespace = 'gb' or $namespace = 'iso' or $namespace = 'iec' or $namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'bipm' or $namespace = 'jcgm' or $namespace = 'rsd'">
						<xsl:text>:</xsl:text>
					</xsl:if>
					<xsl:if test="$namespace = 'itu' or $namespace = 'nist-cswp'  or $namespace = 'nist-sp' or $namespace = 'unece-rec' or $namespace = 'unece'">				
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
	
	<xsl:template match="*[local-name() = 'termnote']/*[local-name() = 'p']">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template>
	
	<!-- ====== -->
	<!-- ====== -->
	
	
	<!-- ====== -->
	<!-- term      -->	
	<!-- ====== -->
	
	<xsl:template match="*[local-name() = 'terms']">
		<fo:block id="{@id}">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'term']">
		<fo:block id="{@id}" xsl:use-attribute-sets="term-style">
			<xsl:if test="$namespace = 'gb'">
				<fo:block font-family="SimHei" font-size="11pt" keep-with-next="always" margin-top="10pt" margin-bottom="8pt" line-height="1.1">
					<xsl:apply-templates select="gb:name" mode="presentation"/>
				</fo:block>
			</xsl:if>
			<xsl:if test="$namespace = 'm3d'">
				<fo:block keep-with-next="always" margin-top="10pt" margin-bottom="8pt" line-height="1.1">
					<xsl:apply-templates select="m3d:name" mode="presentation"/>
				</fo:block>
			</xsl:if>
			
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'term']/*[local-name() = 'name']"/>	
	
	<xsl:template match="*[local-name() = 'term']/*[local-name() = 'name']" mode="presentation">
		<xsl:if test="normalize-space() != ''">
			<xsl:variable name="level">
				<xsl:call-template name="getLevelTermName"/>
			</xsl:variable>
			<fo:inline role="H{$level}">
				<xsl:apply-templates />
				<!-- <xsl:if test="$namespace = 'gb' or $namespace = 'ogc'">
					<xsl:text>.</xsl:text>
				</xsl:if> -->
			</fo:inline>
		</xsl:if>
	</xsl:template>
	<!-- ====== -->
	<!-- ====== -->
	
	<!-- ====== -->
	<!-- figure    -->
	<!-- image    -->
	<!-- ====== -->
	
	<xsl:template match="*[local-name() = 'figure']" name="figure">
		<xsl:variable name="isAdded" select="@added"/>
		<xsl:variable name="isDeleted" select="@deleted"/>
		<fo:block-container id="{@id}">			
			<xsl:if test="$namespace = 'bipm'">
				<xsl:if test="*[local-name() = 'name']">
					<xsl:attribute name="space-after">12pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:call-template name="setTrackChangesStyles">
				<xsl:with-param name="isAdded" select="$isAdded"/>
				<xsl:with-param name="isDeleted" select="$isDeleted"/>
			</xsl:call-template>
			<xsl:if test="$namespace = 'bsi' or $namespace = 'rsd'">
				<xsl:apply-templates select="*[local-name() = 'name']" mode="presentation"/>
			</xsl:if>
			<fo:block>
				<xsl:if test="$namespace = 'rsd'"> <!-- background for image -->
					<xsl:attribute name="background-color">rgb(236,242,246)</xsl:attribute>
					<xsl:attribute name="padding-left">11mm</xsl:attribute>
					<xsl:attribute name="margin-left">0mm</xsl:attribute>
					<xsl:attribute name="padding-right">11mm</xsl:attribute>
					<xsl:attribute name="margin-right">0mm</xsl:attribute>
					<xsl:attribute name="padding-top">7.5mm</xsl:attribute>
					<xsl:attribute name="padding-bottom">7.5mm</xsl:attribute>
					<xsl:attribute name="margin-bottom">3mm</xsl:attribute>
				</xsl:if>
				<xsl:apply-templates />
			</fo:block>
			<xsl:call-template name="fn_display_figure"/>
			<xsl:for-each select="*[local-name() = 'note']">
				<xsl:call-template name="note"/>
			</xsl:for-each>
			
			<xsl:if test="$namespace = 'bipm' or $namespace = 'csa' or $namespace = 'csd' or $namespace = 'gb' or $namespace = 'iec' or $namespace = 'iho' or $namespace = 'iso' or $namespace = 'itu' or $namespace = 'jcgm' or $namespace = 'm3d' or $namespace = 'mpfd' or $namespace = 'nist-cswp'  or $namespace = 'nist-sp' or $namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'unece' or $namespace = 'unece-rec'">
				<xsl:apply-templates select="*[local-name() = 'name']" mode="presentation"/>
			</xsl:if>
		</fo:block-container>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'figure'][@class = 'pseudocode']">
		<fo:block id="{@id}">
			<xsl:apply-templates />
		</fo:block>
		<xsl:apply-templates select="*[local-name() = 'name']" mode="presentation"/>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'figure'][@class = 'pseudocode']//*[local-name() = 'p']">
		<fo:block xsl:use-attribute-sets="figure-pseudocode-p-style">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>

	
	<xsl:template match="*[local-name() = 'image']">
		<xsl:variable name="isAdded" select="../@added"/>
		<xsl:variable name="isDeleted" select="../@deleted"/>
		<xsl:choose>
			<xsl:when test="ancestor::*[local-name() = 'title']">
				<fo:inline padding-left="1mm" padding-right="1mm">
					<xsl:variable name="src">
						<xsl:call-template name="image_src"/>
					</xsl:variable>
					<fo:external-graphic src="{$src}" fox:alt-text="Image {@alt}" vertical-align="middle"/>
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<fo:block xsl:use-attribute-sets="image-style">
					<xsl:if test="$namespace = 'bsi'">
						<xsl:if test="ancestor::*[local-name() = 'table']">
							<xsl:attribute name="text-align">inherit</xsl:attribute>
						</xsl:if>
					</xsl:if>
					<xsl:if test="$namespace = 'unece-rec'">
						<xsl:if test="ancestor::un:admonition">
							<xsl:attribute name="margin-top">-12mm</xsl:attribute>
							<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
						</xsl:if>
					</xsl:if>
					<xsl:variable name="src">
						<xsl:call-template name="image_src"/>
					</xsl:variable>
					
					<xsl:choose>
						<xsl:when test="$isDeleted = 'true'">
							<!-- enclose in svg -->
							<fo:instream-foreign-object fox:alt-text="Image {@alt}">
								<xsl:attribute name="width">100%</xsl:attribute>
								<xsl:attribute name="content-height">100%</xsl:attribute>
								<xsl:attribute name="content-width">scale-down-to-fit</xsl:attribute>
								<xsl:attribute name="scaling">uniform</xsl:attribute>
								
								
									<xsl:apply-templates select="." mode="cross_image"/>
									
							</fo:instream-foreign-object>
						</xsl:when>
						<xsl:otherwise>
							<fo:external-graphic src="{$src}" fox:alt-text="Image {@alt}" xsl:use-attribute-sets="image-graphic-style">
								<xsl:if test="not(@mimetype = 'image/svg+xml') and ../*[local-name() = 'name'] and not(ancestor::*[local-name() = 'table'])">
										
									<xsl:variable name="img_src">
										<xsl:choose>
											<xsl:when test="not(starts-with(@src, 'data:'))"><xsl:value-of select="concat($basepath, @src)"/></xsl:when>
											<xsl:otherwise><xsl:value-of select="@src"/></xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									
									<xsl:variable name="scale" select="java:org.metanorma.fop.Util.getImageScale($img_src, $width_effective, $height_effective)"/>
									<xsl:if test="number($scale) &lt; 100">
										<xsl:attribute name="content-width"><xsl:value-of select="$scale"/>%</xsl:attribute>
									</xsl:if>
								
								</xsl:if>
							
							</fo:external-graphic>
						</xsl:otherwise>
					</xsl:choose>
					
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	

	<xsl:template name="image_src">
		<xsl:choose>
			<xsl:when test="@mimetype = 'image/svg+xml' and $images/images/image[@id = current()/@id]">
				<xsl:value-of select="$images/images/image[@id = current()/@id]/@src"/>
			</xsl:when>
			<xsl:when test="not(starts-with(@src, 'data:'))">
				<xsl:value-of select="concat('url(file:',$basepath, @src, ')')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="@src"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'image']" mode="cross_image">
		<xsl:choose>
			<xsl:when test="@mimetype = 'image/svg+xml' and $images/images/image[@id = current()/@id]">
				<xsl:variable name="src">
					<xsl:value-of select="$images/images/image[@id = current()/@id]/@src"/>
				</xsl:variable>
				<xsl:variable name="width" select="document($src)/@width"/>
				<xsl:variable name="height" select="document($src)/@height"/>
				<svg xmlns="http://www.w3.org/2000/svg" xml:space="preserve" style="enable-background:new 0 0 595.28 841.89;" height="{$height}" width="{$width}" viewBox="0 0 {$width} {$height}" y="0px" x="0px" id="Layer_1" version="1.1">
					<image xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="{$src}" style="overflow:visible;"/>
				</svg>
			</xsl:when>
			<xsl:when test="not(starts-with(@src, 'data:'))">
				<xsl:variable name="src">
					<xsl:value-of select="concat('url(file:',$basepath, @src, ')')"/>
				</xsl:variable>
				<xsl:variable name="file" select="java:java.io.File.new(@src)"/>
				<xsl:variable name="bufferedImage" select="java:javax.imageio.ImageIO.read($file)"/>
				<xsl:variable name="width" select="java:getWidth($bufferedImage)"/>
				<xsl:variable name="height" select="java:getHeight($bufferedImage)"/>
				<svg xmlns="http://www.w3.org/2000/svg" xml:space="preserve" style="enable-background:new 0 0 595.28 841.89;" height="{$height}" width="{$width}" viewBox="0 0 {$width} {$height}" y="0px" x="0px" id="Layer_1" version="1.1">
					<image xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="{$src}" style="overflow:visible;"/>
				</svg>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="base64String" select="substring-after(@src, 'base64,')"/>
				<xsl:variable name="decoder" select="java:java.util.Base64.getDecoder()"/>
				<xsl:variable name="fileContent" select="java:decode($decoder, $base64String)"/>
				<xsl:variable name="bis" select="java:java.io.ByteArrayInputStream.new($fileContent)"/>
				<xsl:variable name="bufferedImage" select="java:javax.imageio.ImageIO.read($bis)"/>
				<xsl:variable name="width" select="java:getWidth($bufferedImage)"/>
				<!-- width=<xsl:value-of select="$width"/> -->
				<xsl:variable name="height" select="java:getHeight($bufferedImage)"/>
				<!-- height=<xsl:value-of select="$height"/> -->
				<svg xmlns="http://www.w3.org/2000/svg" xml:space="preserve" style="enable-background:new 0 0 595.28 841.89;" height="{$height}" width="{$width}" viewBox="0 0 {$width} {$height}" y="0px" x="0px" id="Layer_1" version="1.1">
					<image xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="{@src}" height="{$height}" width="{$width}" style="overflow:visible;"/>
					<xsl:call-template name="svg_cross">
						<xsl:with-param name="width" select="$width"/>
						<xsl:with-param name="height" select="$height"/>
					</xsl:call-template>
				</svg>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
	<xsl:template name="svg_cross">
		<xsl:param name="width"/>
		<xsl:param name="height"/>
		<line xmlns="http://www.w3.org/2000/svg" x1="0" y1="0" x2="{$width}" y2="{$height}" style="stroke: rgb(255, 0, 0); stroke-width:4px; " />
		<line xmlns="http://www.w3.org/2000/svg" x1="0" y1="{$height}" x2="{$width}" y2="0" style="stroke: rgb(255, 0, 0); stroke-width:4px; " />
	</xsl:template>
	
	
	<!-- =================== -->
	<!-- SVG images processing -->
	<!-- =================== -->
	<xsl:variable name="figure_name_height">14</xsl:variable>
	<xsl:variable name="width_effective" select="$pageWidth - $marginLeftRight1 - $marginLeftRight2"/><!-- paper width minus margins -->
	<xsl:variable name="height_effective" select="$pageHeight - $marginTop - $marginBottom - $figure_name_height"/><!-- paper height minus margins and title height -->
	<xsl:variable name="image_dpi" select="96"/>
	<xsl:variable name="width_effective_px" select="$width_effective div 25.4 * $image_dpi"/>
	<xsl:variable name="height_effective_px" select="$height_effective div 25.4 * $image_dpi"/>
	
	<xsl:template match="*[local-name() = 'figure'][not(*[local-name() = 'image']) and *[local-name() = 'svg']]/*[local-name() = 'name']/*[local-name() = 'bookmark']" priority="2"/>
	<xsl:template match="*[local-name() = 'figure'][not(*[local-name() = 'image'])]/*[local-name() = 'svg']" priority="2" name="image_svg">
		<xsl:param name="name"/>
		
		<xsl:variable name="svg_content">
			<xsl:apply-templates select="." mode="svg_update"/>
		</xsl:variable>
		
		<xsl:variable name="alt-text">
			<xsl:choose>
				<xsl:when test="normalize-space(../*[local-name() = 'name']) != ''">
					<xsl:value-of select="../*[local-name() = 'name']"/>
				</xsl:when>
				<xsl:when test="normalize-space($name) != ''">
					<xsl:value-of select="$name"/>
				</xsl:when>
				<xsl:otherwise>Figure</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test=".//*[local-name() = 'a'][*[local-name() = 'rect'] or *[local-name() = 'polygon'] or *[local-name() = 'circle'] or *[local-name() = 'ellipse']]">
				<fo:block>
					<xsl:variable name="width" select="@width"/>
					<xsl:variable name="height" select="@height"/>
					
					<xsl:variable name="scale_x">
						<xsl:choose>
							<xsl:when test="$width &gt; $width_effective_px">
								<xsl:value-of select="$width_effective_px div $width"/>
							</xsl:when>
							<xsl:otherwise>1</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					
					<xsl:variable name="scale_y">
						<xsl:choose>
							<xsl:when test="$height * $scale_x &gt; $height_effective_px">
								<xsl:value-of select="$height_effective_px div ($height * $scale_x)"/>
							</xsl:when>
							<xsl:otherwise>1</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					
					<xsl:variable name="scale">
						<xsl:choose>
							<xsl:when test="$scale_y != 1">
								<xsl:value-of select="$scale_x * $scale_y"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$scale_x"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					 
					<xsl:variable name="width_scale" select="round($width * $scale)"/>
					<xsl:variable name="height_scale" select="round($height * $scale)"/>
					
					<fo:table table-layout="fixed" width="100%" >
						<fo:table-column column-width="proportional-column-width(1)"/>
						<fo:table-column column-width="{$width_scale}px"/>
						<fo:table-column column-width="proportional-column-width(1)"/>
						<fo:table-body>
							<fo:table-row>
								<fo:table-cell column-number="2">
									<fo:block>
										<fo:block-container width="{$width_scale}px" height="{$height_scale}px">
											<xsl:if test="../*[local-name() = 'name']/*[local-name() = 'bookmark']">
												<fo:block  line-height="0" font-size="0">
													<xsl:for-each select="../*[local-name() = 'name']/*[local-name() = 'bookmark']">
														<xsl:call-template name="bookmark"/>
													</xsl:for-each>
												</fo:block>
											</xsl:if>
											<fo:block text-depth="0" line-height="0" font-size="0">

												<fo:instream-foreign-object fox:alt-text="{$alt-text}">
													<xsl:attribute name="width">100%</xsl:attribute>
													<xsl:attribute name="content-height">100%</xsl:attribute>
													<xsl:attribute name="content-width">scale-down-to-fit</xsl:attribute>
													<xsl:attribute name="scaling">uniform</xsl:attribute>

													<xsl:apply-templates select="xalan:nodeset($svg_content)" mode="svg_remove_a"/>
												</fo:instream-foreign-object>
											</fo:block>
											
											<xsl:apply-templates select=".//*[local-name() = 'a'][*[local-name() = 'rect'] or *[local-name() = 'polygon'] or *[local-name() = 'circle'] or *[local-name() = 'ellipse']]" mode="svg_imagemap_links">
												<xsl:with-param name="scale" select="$scale"/>
											</xsl:apply-templates>
										</fo:block-container>
									</fo:block>
								</fo:table-cell>
							</fo:table-row>
						</fo:table-body>
					</fo:table>
				</fo:block>
				
			</xsl:when>
			<xsl:otherwise>
				<fo:block xsl:use-attribute-sets="image-style">
					<fo:instream-foreign-object fox:alt-text="{$alt-text}">
						<xsl:attribute name="width">100%</xsl:attribute>
						<xsl:attribute name="content-height">100%</xsl:attribute>
						<xsl:attribute name="content-width">scale-down-to-fit</xsl:attribute>
						<xsl:variable name="svg_width" select="xalan:nodeset($svg_content)/*/@width"/>
						<xsl:variable name="svg_height" select="xalan:nodeset($svg_content)/*/@height"/>
						<!-- effective height 297 - 27.4 - 13 =  256.6 -->
						<!-- effective width 210 - 12.5 - 25 = 172.5 -->
						<!-- effective height / width = 1.48, 1.4 - with title -->
						<xsl:if test="$svg_height &gt; ($svg_width * 1.4)"> <!-- for images with big height -->
							<xsl:variable name="width" select="(($svg_width * 1.4) div $svg_height) * 100"/>
							<xsl:attribute name="width"><xsl:value-of select="$width"/>%</xsl:attribute>
						</xsl:if>
						<xsl:attribute name="scaling">uniform</xsl:attribute>
						<xsl:copy-of select="$svg_content"/>
					</fo:instream-foreign-object>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="@*|node()" mode="svg_update">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="svg_update"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'image']/@href" mode="svg_update">
		<xsl:attribute name="href" namespace="http://www.w3.org/1999/xlink">
			<xsl:value-of select="."/>
		</xsl:attribute>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'svg'][not(@width and @height)]" mode="svg_update">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="svg_update"/>
			<xsl:variable name="viewbox">
				<xsl:call-template name="split">
					<xsl:with-param name="pText" select="@viewBox"/>
					<xsl:with-param name="sep" select="' '"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:attribute name="width">
				<xsl:value-of select="round(xalan:nodeset($viewbox)//item[3])"/>
			</xsl:attribute>
			<xsl:attribute name="height">
				<xsl:value-of select="round(xalan:nodeset($viewbox)//item[4])"/>
			</xsl:attribute>
			<xsl:apply-templates  mode="svg_update"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- image with svg and emf -->
	<xsl:template match="*[local-name() = 'figure']/*[local-name() = 'image'][*[local-name() = 'svg']]" priority="3">
		<xsl:variable name="name" select="ancestor::*[local-name() = 'figure']/*[local-name() = 'name']"/>
		<xsl:for-each select="*[local-name() = 'svg']">
			<xsl:call-template name="image_svg">
				<xsl:with-param name="name" select="$name"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'figure']/*[local-name() = 'image'][@mimetype = 'image/svg+xml' and @src[not(starts-with(., 'data:image/'))]]" priority="2">
		<xsl:variable name="svg_content" select="document(@src)"/>
		<xsl:variable name="name" select="ancestor::*[local-name() = 'figure']/*[local-name() = 'name']"/>
		<xsl:for-each select="xalan:nodeset($svg_content)/node()">
			<xsl:call-template name="image_svg">
				<xsl:with-param name="name" select="$name"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="@*|node()" mode="svg_remove_a">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="svg_remove_a"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[local-name() = 'a']" mode="svg_remove_a">
		<xsl:apply-templates mode="svg_remove_a"/>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'a']" mode="svg_imagemap_links">
		<xsl:param name="scale" />
		<xsl:variable name="dest">
			<xsl:choose>
				<xsl:when test="starts-with(@href, '#')">
					<xsl:value-of select="substring-after(@href, '#')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@href"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:for-each select="./*[local-name() = 'rect']">
			<xsl:call-template name="insertSVGMapLink">
				<xsl:with-param name="left" select="floor(@x * $scale)"/>
				<xsl:with-param name="top" select="floor(@y * $scale)"/>
				<xsl:with-param name="width" select="floor(@width * $scale)"/>
				<xsl:with-param name="height" select="floor(@height * $scale)"/>
				<xsl:with-param name="dest" select="$dest"/>
			</xsl:call-template>
		</xsl:for-each>
		
		<xsl:for-each select="./*[local-name() = 'polygon']">
			<xsl:variable name="points">
				<xsl:call-template name="split">
					<xsl:with-param name="pText" select="@points"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="x_coords">
				<xsl:for-each select="xalan:nodeset($points)//item[position() mod 2 = 1]">
					<xsl:sort select="." data-type="number"/>
					<x><xsl:value-of select="."/></x>
				</xsl:for-each>
			</xsl:variable>
			<xsl:variable name="y_coords">
				<xsl:for-each select="xalan:nodeset($points)//item[position() mod 2 = 0]">
					<xsl:sort select="." data-type="number"/>
					<y><xsl:value-of select="."/></y>
				</xsl:for-each>
			</xsl:variable>
			<xsl:variable name="x" select="xalan:nodeset($x_coords)//x[1]"/>
			<xsl:variable name="y" select="xalan:nodeset($y_coords)//y[1]"/>
			<xsl:variable name="width" select="xalan:nodeset($x_coords)//x[last()] - $x"/>
			<xsl:variable name="height" select="xalan:nodeset($y_coords)//y[last()] - $y"/>
			<xsl:call-template name="insertSVGMapLink">
				<xsl:with-param name="left" select="floor($x * $scale)"/>
				<xsl:with-param name="top" select="floor($y * $scale)"/>
				<xsl:with-param name="width" select="floor($width * $scale)"/>
				<xsl:with-param name="height" select="floor($height * $scale)"/>
				<xsl:with-param name="dest" select="$dest"/>
			</xsl:call-template>
		</xsl:for-each>
		
		<xsl:for-each select="./*[local-name() = 'circle']">
			<xsl:call-template name="insertSVGMapLink">
				<xsl:with-param name="left" select="floor((@cx - @r) * $scale)"/>
				<xsl:with-param name="top" select="floor((@cy - @r) * $scale)"/>
				<xsl:with-param name="width" select="floor(@r * 2 * $scale)"/>
				<xsl:with-param name="height" select="floor(@r * 2 * $scale)"/>
				<xsl:with-param name="dest" select="$dest"/>
			</xsl:call-template>
		</xsl:for-each>
		<xsl:for-each select="./*[local-name() = 'ellipse']">
			<xsl:call-template name="insertSVGMapLink">
				<xsl:with-param name="left" select="floor((@cx - @rx) * $scale)"/>
				<xsl:with-param name="top" select="floor((@cy - @ry) * $scale)"/>
				<xsl:with-param name="width" select="floor(@rx * 2 * $scale)"/>
				<xsl:with-param name="height" select="floor(@ry * 2 * $scale)"/>
				<xsl:with-param name="dest" select="$dest"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template name="insertSVGMapLink">
		<xsl:param name="left"/>
		<xsl:param name="top"/>
		<xsl:param name="width"/>
		<xsl:param name="height"/>
		<xsl:param name="dest"/>
		<fo:block-container position="absolute" left="{$left}px" top="{$top}px" width="{$width}px" height="{$height}px">
		 <fo:block font-size="1pt">
			<fo:basic-link internal-destination="{$dest}" fox:alt-text="svg link">
				<fo:inline-container inline-progression-dimension="100%">
					<fo:block-container height="{$height - 1}px" width="100%">
						<!-- DEBUG <xsl:if test="local-name()='polygon'">
							<xsl:attribute name="background-color">magenta</xsl:attribute>
						</xsl:if> -->
					<fo:block>&#xa0;</fo:block></fo:block-container>
				</fo:inline-container>
			</fo:basic-link>
		 </fo:block>
	  </fo:block-container>
	</xsl:template>
	<!-- =================== -->
	<!-- End SVG images processing -->
	<!-- =================== -->
	
	<!-- ignore emf processing (Apache FOP doesn't support EMF) -->
	<xsl:template match="*[local-name() = 'emf']"/>
	
	
	<xsl:template match="*[local-name() = 'figure']/*[local-name() = 'name']"/>	
	
	<xsl:template match="*[local-name() = 'figure']/*[local-name() = 'name'] | 
														*[local-name() = 'table']/*[local-name() = 'name'] |
														*[local-name() = 'permission']/*[local-name() = 'name'] |
														*[local-name() = 'recommendation']/*[local-name() = 'name'] |
														*[local-name() = 'requirement']/*[local-name() = 'name']" mode="contents">		
		<xsl:apply-templates mode="contents"/>
		<xsl:text> </xsl:text>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'figure']/*[local-name() = 'name'] | 
														*[local-name() = 'table']/*[local-name() = 'name'] |
														*[local-name() = 'permission']/*[local-name() = 'name'] |
														*[local-name() = 'recommendation']/*[local-name() = 'name'] |
														*[local-name() = 'requirement']/*[local-name() = 'name']" mode="bookmarks">		
		<xsl:apply-templates mode="bookmarks"/>
		<xsl:text> </xsl:text>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'figure' or local-name() = 'table' or local-name() = 'permission' or local-name() = 'recommendation' or local-name() = 'requirement']/*[local-name() = 'name']/text()" mode="contents" priority="2">
		<xsl:value-of select="."/>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'figure' or local-name() = 'table' or local-name() = 'permission' or local-name() = 'recommendation' or local-name() = 'requirement']/*[local-name() = 'name']//text()" mode="bookmarks" priority="2">
		<xsl:value-of select="."/>
	</xsl:template>
	
	<xsl:template match="node()" mode="contents">
		<xsl:apply-templates mode="contents"/>
	</xsl:template>
	
	<xsl:template match="node()" mode="bookmarks">
		<xsl:apply-templates mode="bookmarks"/>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'title' or local-name() = 'name']//*[local-name() = 'stem']" mode="contents">
		<xsl:apply-templates select="."/>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'references'][@hidden='true']" mode="contents" priority="3"/>
	
	<xsl:template match="*[local-name() = 'stem']" mode="bookmarks">
		<xsl:apply-templates mode="bookmarks"/>
	</xsl:template>
	
	
	<xsl:template name="addBookmarks">
		<xsl:param name="contents"/>
		<xsl:if test="xalan:nodeset($contents)//item">
			<fo:bookmark-tree>
				<xsl:choose>
					<xsl:when test="xalan:nodeset($contents)/doc">
						<xsl:choose>
							<xsl:when test="count(xalan:nodeset($contents)/doc) &gt; 1">
								<xsl:for-each select="xalan:nodeset($contents)/doc">
									<fo:bookmark internal-destination="{contents/item[1]/@id}" starting-state="hide">
										<xsl:if test="@bundle = 'true'">
											<xsl:attribute name="internal-destination"><xsl:value-of select="@firstpage_id"/></xsl:attribute>
										</xsl:if>
										<fo:bookmark-title>
											<xsl:choose>
												<xsl:when test="not(normalize-space(@bundle) = 'true')"> <!-- 'bundle' means several different documents (not language versions) in one xml -->
													<xsl:variable name="bookmark-title_">
														<xsl:call-template name="getLangVersion">
															<xsl:with-param name="lang" select="@lang"/>
															<xsl:with-param name="doctype" select="@doctype"/>
															<xsl:with-param name="title" select="@title-part"/>
														</xsl:call-template>
													</xsl:variable>
													<xsl:choose>
														<xsl:when test="normalize-space($bookmark-title_) != ''">
															<xsl:value-of select="normalize-space($bookmark-title_)"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:choose>
																<xsl:when test="@lang = 'en'">English</xsl:when>
																<xsl:when test="@lang = 'fr'">Français</xsl:when>
																<xsl:when test="@lang = 'de'">Deutsche</xsl:when>
																<xsl:otherwise><xsl:value-of select="@lang"/> version</xsl:otherwise>
															</xsl:choose>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="@title-part"/>
												</xsl:otherwise>
											</xsl:choose>
										</fo:bookmark-title>
										
										<xsl:apply-templates select="contents/item" mode="bookmark"/>
										
										<xsl:call-template name="insertFigureBookmarks">
											<xsl:with-param name="contents" select="contents"/>
										</xsl:call-template>
										
										<xsl:call-template name="insertTableBookmarks">
											<xsl:with-param name="contents" select="contents"/>
											<xsl:with-param name="lang" select="@lang"/>
										</xsl:call-template>
										
									</fo:bookmark>
									
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<xsl:for-each select="xalan:nodeset($contents)/doc">
								
									<xsl:apply-templates select="contents/item" mode="bookmark"/>
									
									<xsl:call-template name="insertFigureBookmarks">
										<xsl:with-param name="contents" select="contents"/>
									</xsl:call-template>
										
									<xsl:call-template name="insertTableBookmarks">
										<xsl:with-param name="contents" select="contents"/>
										<xsl:with-param name="lang" select="@lang"/>
									</xsl:call-template>
									
								</xsl:for-each>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="xalan:nodeset($contents)/contents/item" mode="bookmark"/>				
					</xsl:otherwise>
				</xsl:choose>
				
				<xsl:if test="$namespace = 'nist-sp'">
					<xsl:if test="//*[local-name() = 'figure'][@id and *[local-name() = 'name']]">					
						<fo:bookmark internal-destination="{//*[local-name() = 'figure'][@id and *[local-name() = 'name']][1]/@id}" starting-state="hide">
							<fo:bookmark-title>Figures</fo:bookmark-title>
							<xsl:for-each select="//*[local-name() = 'figure'][@id and *[local-name() = 'name']]">
								<fo:bookmark internal-destination="{@id}">
									<fo:bookmark-title><xsl:apply-templates select="*[local-name() = 'name']/text()" mode="bookmarks"/></fo:bookmark-title>
								</fo:bookmark>
							</xsl:for-each>
						</fo:bookmark>
					</xsl:if>
				</xsl:if>
				
				<xsl:if test="$namespace = 'nist-sp'">
					<xsl:if test="//*[local-name() = 'table'][@id and *[local-name() = 'name']]">					
						<fo:bookmark internal-destination="{//*[local-name() = 'table'][@id and *[local-name() = 'name']][1]/@id}" starting-state="hide">
							<fo:bookmark-title>
								<xsl:choose>
									<xsl:when test="$lang = 'fr'">Tableaux</xsl:when>
									<xsl:otherwise>Tables</xsl:otherwise>
								</xsl:choose>
							</fo:bookmark-title>
							<xsl:for-each select="//*[local-name() = 'table'][@id and *[local-name() = 'name']]">
								<fo:bookmark internal-destination="{@id}">
									<fo:bookmark-title><xsl:apply-templates select="*[local-name() = 'name']//text()" mode="bookmarks"/></fo:bookmark-title>
								</fo:bookmark>
							</xsl:for-each>
						</fo:bookmark>
					</xsl:if>
				</xsl:if>
				
				
				<xsl:if test="$namespace = 'ogc'">
				
					<xsl:variable name="list_of_tables_">
						<xsl:for-each select="//*[local-name() = 'table'][@id and *[local-name() = 'name'] and contains(*[local-name() = 'name'], '—')]">
							<table id="{@id}"><xsl:apply-templates select="*[local-name() = 'name']" mode="bookmarks"/></table>
						</xsl:for-each>
					</xsl:variable>
					<xsl:variable name="list_of_tables" select="xalan:nodeset($list_of_tables_)"/>
					
					<xsl:variable name="list_of_figures_">
						<xsl:for-each select="//*[local-name() = 'figure'][@id and *[local-name() = 'name'] and contains(*[local-name() = 'name'], '—')]">
							<figure id="{@id}"><xsl:apply-templates select="*[local-name() = 'name']" mode="bookmarks"/></figure>
						</xsl:for-each>
					</xsl:variable>
					<xsl:variable name="list_of_figures" select="xalan:nodeset($list_of_figures_)"/>
										
					<xsl:if test="$list_of_tables//table or $list_of_figures/figure or //*[local-name() = 'table'][.//*[local-name() = 'p'][@class = 'RecommendationTitle']]">
						<fo:bookmark internal-destination="empty_bookmark">
							<fo:bookmark-title>—————</fo:bookmark-title>
						</fo:bookmark>
					</xsl:if>
					
					<xsl:if test="$list_of_tables//table">
						<fo:bookmark internal-destination="empty_bookmark" starting-state="hide"> <!-- {$list_of_tables//table[1]/@id} -->
							<fo:bookmark-title>
								<xsl:call-template name="getTitle">
									<xsl:with-param name="name" select="'title-list-tables'"/>
								</xsl:call-template>
							</fo:bookmark-title>
							<xsl:for-each select="$list_of_tables//table">
								<fo:bookmark internal-destination="{@id}">
									<fo:bookmark-title><xsl:value-of select="."/></fo:bookmark-title>
								</fo:bookmark>
							</xsl:for-each>
						</fo:bookmark>
					</xsl:if>

					<xsl:if test="$list_of_figures//figure">
						<fo:bookmark internal-destination="empty_bookmark" starting-state="hide"> <!-- {$list_of_figures//figure[1]/@id} -->
							<fo:bookmark-title>
								<xsl:if test="$namespace = 'ogc'">
									<xsl:call-template name="getTitle">
										<xsl:with-param name="name" select="'title-list-figures'"/>
									</xsl:call-template>
								</xsl:if>
								<xsl:if test="$namespace = 'ogc-white-paper'">
									<xsl:call-template name="getTitle">
										<xsl:with-param name="name" select="'title-table-figures'"/>
									</xsl:call-template>
								</xsl:if>
							</fo:bookmark-title>
							<xsl:for-each select="$list_of_figures//figure">
								<fo:bookmark internal-destination="{@id}">
									<fo:bookmark-title><xsl:value-of select="."/></fo:bookmark-title>
								</fo:bookmark>
							</xsl:for-each>
						</fo:bookmark>
					</xsl:if>

					
					<xsl:if test="//*[local-name() = 'table'][.//*[local-name() = 'p'][@class = 'RecommendationTitle']]">							
						<fo:bookmark internal-destination="empty_bookmark" starting-state="hide"> <!-- {//*[local-name() = 'table'][.//*[local-name() = 'p'][@class = 'RecommendationTitle']][1]/@id} -->
							<fo:bookmark-title>
								<xsl:call-template name="getTitle">
									<xsl:with-param name="name" select="'title-list-recommendations'"/>
								</xsl:call-template>
							</fo:bookmark-title>
							<xsl:for-each select="//*[local-name() = 'table'][.//*[local-name() = 'p'][@class = 'RecommendationTitle']]">
								<xsl:variable name="table_id" select="@id"/>
								<fo:bookmark internal-destination="{@id}">
									<fo:bookmark-title><xsl:value-of select=".//*[local-name() = 'p'][@class = 'RecommendationTitle'][ancestor::*[local-name() = 'table'][1][@id= $table_id]]/node()"/></fo:bookmark-title>
								</fo:bookmark>
							</xsl:for-each>
						</fo:bookmark>
					</xsl:if>
				</xsl:if>
				
				<xsl:if test="$namespace = 'ogc-white-paper'">
					<xsl:variable name="list_of_tables_figures_">
						<xsl:for-each select="//*[local-name() = 'table'][@id and *[local-name() = 'name']] | //*[local-name() = 'figure'][@id and *[local-name() = 'name']]">
							<table_figure id="{@id}"><xsl:apply-templates select="*[local-name() = 'name']" mode="bookmarks"/></table_figure>
						</xsl:for-each>
					</xsl:variable>
					<xsl:variable name="list_of_tables_figures" select="xalan:nodeset($list_of_tables_figures_)"/>
				
					
					<xsl:if test="$list_of_tables_figures/table_figure">
						<fo:bookmark internal-destination="empty_bookmark">
							<fo:bookmark-title>—————</fo:bookmark-title>
						</fo:bookmark>
					</xsl:if>
					
					<xsl:if test="$list_of_tables_figures//table_figure">
						<fo:bookmark internal-destination="empty_bookmark" starting-state="hide"> <!-- {$list_of_figures//figure[1]/@id} -->
							<fo:bookmark-title>
								<xsl:if test="$namespace = 'ogc'">
									<xsl:call-template name="getTitle">
										<xsl:with-param name="name" select="'title-list-figures'"/>
									</xsl:call-template>
								</xsl:if>
								<xsl:if test="$namespace = 'ogc-white-paper'">
									<xsl:call-template name="getTitle">
										<xsl:with-param name="name" select="'title-table-figures'"/>
									</xsl:call-template>
								</xsl:if>
							</fo:bookmark-title>
							<xsl:for-each select="$list_of_tables_figures//table_figure">
								<fo:bookmark internal-destination="{@id}">
									<fo:bookmark-title><xsl:value-of select="."/></fo:bookmark-title>
								</fo:bookmark>
							</xsl:for-each>
						</fo:bookmark>
					</xsl:if>
				
				</xsl:if>
				
			</fo:bookmark-tree>
		</xsl:if>
	</xsl:template>
	
	
	<xsl:template name="insertFigureBookmarks">
		<xsl:param name="contents"/>
		<xsl:if test="xalan:nodeset($contents)/figure">
			<fo:bookmark internal-destination="{xalan:nodeset($contents)/figure[1]/@id}" starting-state="hide">
				<fo:bookmark-title>Figures</fo:bookmark-title>
				<xsl:for-each select="xalan:nodeset($contents)/figure">
					<fo:bookmark internal-destination="{@id}">
						<fo:bookmark-title>
							<xsl:value-of select="normalize-space(title)"/>
						</fo:bookmark-title>
					</fo:bookmark>
				</xsl:for-each>
			</fo:bookmark>	
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="insertTableBookmarks">
		<xsl:param name="contents"/>
		<xsl:param name="lang"/>
		<xsl:if test="xalan:nodeset($contents)/table">
			<fo:bookmark internal-destination="{xalan:nodeset($contents)/table[1]/@id}" starting-state="hide">
				<fo:bookmark-title>
					<xsl:choose>
						<xsl:when test="$lang = 'fr'">Tableaux</xsl:when>
						<xsl:otherwise>Tables</xsl:otherwise>
					</xsl:choose>
				</fo:bookmark-title>
				<xsl:for-each select="xalan:nodeset($contents)/table">
					<fo:bookmark internal-destination="{@id}">
						<fo:bookmark-title>
							<xsl:value-of select="normalize-space(title)"/>
						</fo:bookmark-title>
					</fo:bookmark>
				</xsl:for-each>
			</fo:bookmark>	
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="getLangVersion">
		<xsl:param name="lang"/>
		<xsl:param name="doctype" select="''"/>
		<xsl:param name="title" select="''"/>
		<xsl:choose>
			<xsl:when test="$lang = 'en'">
				<xsl:if test="$namespace = 'iec'">English</xsl:if>
				<xsl:if test="$namespace = 'bipm'">
					<xsl:choose>
						<xsl:when test="$doctype = 'guide'">
							<xsl:value-of select="$title"/>
						</xsl:when>
						<xsl:otherwise>English version</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
				</xsl:when>
			<xsl:when test="$lang = 'fr'">
				<xsl:if test="$namespace = 'iec'">Français</xsl:if>
				<xsl:if test="$namespace = 'bipm'">
					<xsl:choose>
						<xsl:when test="$doctype = 'guide'">
							<xsl:value-of select="$title"/>
						</xsl:when>
						<xsl:otherwise>Version française</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</xsl:when>
			<xsl:when test="$lang = 'de'">Deutsche</xsl:when>
			<xsl:otherwise><xsl:value-of select="$lang"/> version</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="item" mode="bookmark">
		<xsl:choose>
			<xsl:when test="@id != ''">
				<fo:bookmark internal-destination="{@id}" starting-state="hide">
					<fo:bookmark-title>
						<xsl:if test="@section != ''">
							<xsl:value-of select="@section"/> 
							<xsl:text> </xsl:text>
						</xsl:if>
						<xsl:value-of select="normalize-space(title)"/>
					</fo:bookmark-title>
					<xsl:apply-templates mode="bookmark"/>
				</fo:bookmark>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates mode="bookmark"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>	
	
	<xsl:template match="title" mode="bookmark"/>	
	<xsl:template match="text()" mode="bookmark"/>
	
	
	
	<xsl:template match="*[local-name() = 'figure']/*[local-name() = 'name'] |
								*[local-name() = 'image']/*[local-name() = 'name']" mode="presentation">
		<xsl:if test="normalize-space() != ''">			
			<fo:block xsl:use-attribute-sets="figure-name-style">
				<xsl:if test="$namespace = 'nist-cswp'  or $namespace = 'nist-sp'">
					<xsl:if test="nist:dl">
						<xsl:attribute name="space-before">12pt</xsl:attribute>
					</xsl:if>
				</xsl:if>
				<xsl:if test="$namespace = 'bsi'">
					<xsl:if test="count(ancestor::*[local-name() = 'figure']) &gt; 1">
						<xsl:attribute name="margin-left">0mm</xsl:attribute>
					</xsl:if>
					<xsl:if test="$document_type = 'PAS'">
						<xsl:attribute name="margin-left">0mm</xsl:attribute>
						<xsl:attribute name="font-size">12pt</xsl:attribute>
						<xsl:attribute name="font-style">normal</xsl:attribute>
					</xsl:if>
				</xsl:if>
				<xsl:apply-templates/>
			</fo:block>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'figure']/*[local-name() = 'fn']" priority="2"/>
	<xsl:template match="*[local-name() = 'figure']/*[local-name() = 'note']"/>
	
	<!-- ====== -->
	<!-- ====== -->
	<xsl:template match="*[local-name() = 'title']" mode="contents_item">
		<xsl:apply-templates mode="contents_item"/>
		<!-- <xsl:text> </xsl:text> -->
	</xsl:template>

	<xsl:template name="getSection">
		<xsl:value-of select="*[local-name() = 'title']/*[local-name() = 'tab'][1]/preceding-sibling::node()"/>
		<!-- 
		<xsl:for-each select="*[local-name() = 'title']/*[local-name() = 'tab'][1]/preceding-sibling::node()">
			<xsl:value-of select="."/>
		</xsl:for-each>
		-->
		
	</xsl:template>

	<xsl:template name="getName">
		<xsl:choose>
			<xsl:when test="*[local-name() = 'title']/*[local-name() = 'tab']">
				<xsl:copy-of select="*[local-name() = 'title']/*[local-name() = 'tab'][1]/following-sibling::node()"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="*[local-name() = 'title']/node()"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="insertTitleAsListItem">
		<xsl:param name="provisional-distance-between-starts" select="'9.5mm'"/>
		<xsl:variable name="section">						
			<xsl:for-each select="..">
				<xsl:call-template name="getSection"/>
			</xsl:for-each>
		</xsl:variable>							
		<fo:list-block provisional-distance-between-starts="{$provisional-distance-between-starts}">						
			<fo:list-item>
				<fo:list-item-label end-indent="label-end()">
					<fo:block>
						<xsl:value-of select="$section"/>
					</fo:block>
				</fo:list-item-label>
				<fo:list-item-body start-indent="body-start()">
					<fo:block>						
						<xsl:choose>
							<xsl:when test="*[local-name() = 'tab']">
								<xsl:apply-templates select="*[local-name() = 'tab'][1]/following-sibling::node()"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates />
								<xsl:apply-templates select="following-sibling::*[1][local-name() = 'variant-title'][@type = 'sub']" mode="subtitle"/>
							</xsl:otherwise>
						</xsl:choose>
					</fo:block>
				</fo:list-item-body>
			</fo:list-item>
		</fo:list-block>
	</xsl:template>
	
	<xsl:template name="extractSection">
		<xsl:value-of select="*[local-name() = 'tab'][1]/preceding-sibling::node()"/>
	</xsl:template>

	<xsl:template name="extractTitle">
		<xsl:choose>
				<xsl:when test="*[local-name() = 'tab']">
					<xsl:apply-templates select="*[local-name() = 'tab'][1]/following-sibling::node()"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates />
				</xsl:otherwise>
			</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'fn']" mode="contents"/>
	<xsl:template match="*[local-name() = 'fn']" mode="bookmarks"/>
	
	<xsl:template match="*[local-name() = 'fn']" mode="contents_item"/>

	<xsl:template match="*[local-name() = 'tab']" mode="contents_item">
		<xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="*[local-name() = 'strong']" mode="contents_item">
		<xsl:copy>
			<xsl:apply-templates mode="contents_item"/>
		</xsl:copy>		
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'em']" mode="contents_item">
		<xsl:copy>
			<xsl:apply-templates mode="contents_item"/>
		</xsl:copy>		
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'stem']" mode="contents_item">
		<xsl:copy-of select="." />
	</xsl:template>

	<xsl:template match="*[local-name() = 'br']" mode="contents_item">
		<xsl:text> </xsl:text>
	</xsl:template>

	<!-- ====== -->
	<!-- sourcecode   -->	
	<!-- ====== -->	
	<xsl:template match="*[local-name()='sourcecode']" name="sourcecode">
	
		<fo:block-container margin-left="0mm">
			<xsl:copy-of select="@id"/>
			<xsl:if test="$namespace = 'rsd'"><xsl:attribute name="space-after">12pt</xsl:attribute></xsl:if>
			<xsl:if test="parent::*[local-name() = 'note']">
				<xsl:attribute name="margin-left">
					<xsl:choose>
						<xsl:when test="not(ancestor::*[local-name() = 'table'])"><xsl:value-of select="$note-body-indent"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="$note-body-indent-table"/></xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:if test="$namespace = 'gb'">
					<xsl:attribute name="margin-left">0mm</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<fo:block-container margin-left="0mm">
		
				<xsl:if test="$namespace = 'rsd'">
					<xsl:apply-templates select="*[local-name()='name']" mode="presentation"/>
				</xsl:if>
				
				<fo:block xsl:use-attribute-sets="sourcecode-style">
					<xsl:variable name="_font-size">
						<xsl:if test="$namespace = 'csa'">10</xsl:if>
						<xsl:if test="$namespace = 'csd'">10</xsl:if>						
						<xsl:if test="$namespace = 'gb'">9</xsl:if>
						<xsl:if test="$namespace = 'iec'">9</xsl:if>
						<xsl:if test="$namespace = 'iho'">10</xsl:if>
						<xsl:if test="$namespace = 'iso'">9</xsl:if>
						<xsl:if test="$namespace = 'bsi'">9</xsl:if>
						<xsl:if test="$namespace = 'jcgm'">9</xsl:if>
						<xsl:if test="$namespace = 'itu'">10</xsl:if>
						<xsl:if test="$namespace = 'm3d'"></xsl:if>		
						<xsl:if test="$namespace = 'mpfd'"></xsl:if>
						<xsl:if test="$namespace = 'nist-cswp'  or $namespace = 'nist-sp'">10</xsl:if>
						<xsl:if test="$namespace = 'ogc'"></xsl:if>
						<xsl:if test="$namespace = 'ogc-white-paper'">10</xsl:if>						
						<xsl:if test="$namespace = 'rsd'">
							<xsl:choose>
								<xsl:when test="ancestor::*[local-name() = 'table']">inherit</xsl:when>
								<xsl:otherwise>110%</xsl:otherwise>
							</xsl:choose>
						</xsl:if>
						<xsl:if test="$namespace = 'unece' or $namespace = 'unece-rec'">10</xsl:if>		
				</xsl:variable>
				<xsl:variable name="font-size" select="normalize-space($_font-size)"/>		
				<xsl:if test="$font-size != ''">
					<xsl:attribute name="font-size">
						<xsl:choose>
							<xsl:when test="$font-size = 'inherit'"><xsl:value-of select="$font-size"/></xsl:when>
							<xsl:when test="contains($font-size, '%')"><xsl:value-of select="$font-size"/></xsl:when>
							<xsl:when test="ancestor::*[local-name()='note']"><xsl:value-of select="$font-size * 0.91"/>pt</xsl:when>
							<xsl:otherwise><xsl:value-of select="$font-size"/>pt</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
				</xsl:if>
				
				<xsl:if test="$namespace = 'rsd'"> <!-- background for image -->
					<xsl:if test="starts-with(*[local-name() = 'name']/text()[1], 'Figure ')">
						<xsl:attribute name="background-color">rgb(236,242,246)</xsl:attribute>
						<xsl:attribute name="padding-left">11mm</xsl:attribute>
						<xsl:attribute name="margin-left">0mm</xsl:attribute>
						<xsl:attribute name="padding-right">11mm</xsl:attribute>
						<xsl:attribute name="margin-right">0mm</xsl:attribute>
						<xsl:attribute name="padding-top">7.5mm</xsl:attribute>
						<xsl:attribute name="padding-bottom">7.5mm</xsl:attribute>
						<!-- <xsl:attribute name="margin-bottom">3mm</xsl:attribute> -->
						<xsl:if test="following-sibling::*[1][local-name() = 'sourcecode'] and starts-with(*[local-name() = 'name']/text()[1], 'Figure ')">
							<xsl:attribute name="margin-bottom">16pt</xsl:attribute>
						</xsl:if>
					</xsl:if>
				</xsl:if>
				
				<xsl:apply-templates/>			
			</fo:block>
				
			<xsl:if test="$namespace = 'bsi' or  $namespace = 'bipm' or $namespace = 'csa' or $namespace = 'csd' or $namespace = 'gb' or $namespace = 'iec' or $namespace = 'iho' or $namespace = 'iso' or $namespace = 'itu' or $namespace = 'jcgm' or $namespace = 'm3d' or $namespace = 'mpfd' or $namespace = 'nist-cswp'  or $namespace = 'nist-sp' or $namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'unece' or $namespace = 'unece-rec'">
				<xsl:apply-templates select="*[local-name()='name']" mode="presentation"/>
			</xsl:if>	
				
			</fo:block-container>
		</fo:block-container>
	</xsl:template>

	<xsl:template match="*[local-name()='sourcecode']/text()" priority="2">
		<xsl:variable name="text">
			<xsl:call-template name="add-zero-spaces-equal"/>
		</xsl:variable>
		<xsl:call-template name="add-zero-spaces-java">
			<xsl:with-param name="text" select="$text"/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'sourcecode']/*[local-name() = 'name']"/>	
	
	
	<xsl:template match="*[local-name() = 'sourcecode']/*[local-name() = 'name']" mode="presentation">
		<xsl:if test="normalize-space() != ''">		
			<fo:block xsl:use-attribute-sets="sourcecode-name-style">				
				<xsl:apply-templates/>
			</fo:block>
		</xsl:if>
	</xsl:template>	
	<!-- ====== -->
	<!-- ====== -->
	
	<!-- ========== -->
	<!-- permission -->	
	<!-- ========== -->		
	<xsl:template match="*[local-name() = 'permission']">
		<fo:block id="{@id}" xsl:use-attribute-sets="permission-style">			
			<xsl:apply-templates select="*[local-name()='name']" mode="presentation"/>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'permission']/*[local-name() = 'name']"/>	
	<xsl:template match="*[local-name() = 'permission']/*[local-name() = 'name']" mode="presentation">
		<xsl:if test="normalize-space() != ''">
			<fo:block xsl:use-attribute-sets="permission-name-style">
				<xsl:apply-templates />
				<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
					<xsl:text>:</xsl:text>
				</xsl:if>
			</fo:block>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'permission']/*[local-name() = 'label']">
		<fo:block xsl:use-attribute-sets="permission-label-style">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	<!-- ========== -->
	<!-- ========== -->
	
	<!-- ========== -->
	<!-- requirement -->
<!-- ========== -->
	<xsl:template match="*[local-name() = 'requirement']">
		<fo:block id="{@id}" xsl:use-attribute-sets="requirement-style">			
			<xsl:apply-templates select="*[local-name()='name']" mode="presentation"/>
			<xsl:apply-templates select="*[local-name()='label']" mode="presentation"/>
			<xsl:apply-templates select="@obligation" mode="presentation"/>
			<xsl:apply-templates select="*[local-name()='subject']" mode="presentation"/>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'requirement']/*[local-name() = 'name']"/>	
	<xsl:template match="*[local-name() = 'requirement']/*[local-name() = 'name']" mode="presentation">
		<xsl:if test="normalize-space() != ''">
			<fo:block xsl:use-attribute-sets="requirement-name-style">
				<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
					<xsl:if test="../@type = 'class'">
						<xsl:attribute name="background-color">white</xsl:attribute>
					</xsl:if>
				</xsl:if>
				<xsl:apply-templates />
				<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
					<xsl:text>:</xsl:text>
				</xsl:if>
			</fo:block>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'requirement']/*[local-name() = 'label']"/>
	<xsl:template match="*[local-name() = 'requirement']/*[local-name() = 'label']" mode="presentation">
		<fo:block xsl:use-attribute-sets="requirement-label-style">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'requirement']/@obligation" mode="presentation">
			<fo:block>
				<fo:inline padding-right="3mm">Obligation</fo:inline><xsl:value-of select="."/>
			</fo:block>
	</xsl:template>
	<!-- ========== -->
	<!-- ========== -->
	
	<!-- ========== -->
	<!-- recommendation -->
	<!-- ========== -->
	<xsl:template match="*[local-name() = 'recommendation']">
		<fo:block id="{@id}" xsl:use-attribute-sets="recommendation-style">			
			<xsl:apply-templates select="*[local-name()='name']" mode="presentation"/>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'recommendation']/*[local-name() = 'name']"/>	
	<xsl:template match="*[local-name() = 'recommendation']/*[local-name() = 'name']" mode="presentation">
		<xsl:if test="normalize-space() != ''">
			<fo:block xsl:use-attribute-sets="recommendation-name-style">
				<xsl:apply-templates />
				<xsl:if test="$namespace = 'nist-sp'">
					<xsl:text>:</xsl:text>
				</xsl:if>
			</fo:block>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'recommendation']/*[local-name() = 'label']">
		<fo:block xsl:use-attribute-sets="recommendation-label-style">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	<!-- ========== -->
	<!-- END recommendation -->
	<!-- ========== -->
	
	<!-- ========== -->
	<!-- ========== -->
	<xsl:template match="*[local-name() = 'requirement']/*[local-name() = 'subject']" priority="2"/>
	<xsl:template match="*[local-name() = 'requirement']/*[local-name() = 'subject']" mode="presentation">
		<fo:block xsl:use-attribute-sets="subject-style">
			<xsl:text>Target Type </xsl:text><xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'subject']">
		<fo:block xsl:use-attribute-sets="subject-style">
			<xsl:text>Target Type </xsl:text><xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'inherit'] | *[local-name() = 'component'][@class = 'inherit']">
		<fo:block xsl:use-attribute-sets="inherit-style">
			<xsl:text>Dependency </xsl:text><xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'description'] | *[local-name() = 'component'][@class = 'description']">
		<fo:block xsl:use-attribute-sets="description-style">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'specification'] | *[local-name() = 'component'][@class = 'specification']">
		<fo:block xsl:use-attribute-sets="specification-style">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'measurement-target'] | *[local-name() = 'component'][@class = 'measurement-target']">
		<fo:block xsl:use-attribute-sets="measurement-target-style">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'verification'] | *[local-name() = 'component'][@class = 'verification']">
		<fo:block xsl:use-attribute-sets="verification-style">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'import'] | *[local-name() = 'component'][@class = 'import']">
		<fo:block xsl:use-attribute-sets="import-style">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	<!-- ========== -->
	<!-- END  -->
	<!-- ========== -->
	
	<!-- ========== -->
	<!-- requirement, recommendation, permission table -->
	<!-- ========== -->
	<xsl:template match="*[local-name() = 'table'][@class = 'recommendation' or @class='requirement' or @class='permission']">
		<fo:block-container margin-left="0mm" margin-right="0mm" margin-bottom="12pt">
			<xsl:if test="ancestor::*[local-name() = 'table'][@class = 'recommendation' or @class='requirement' or @class='permission']">
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			</xsl:if>
			<fo:block-container margin-left="0mm" margin-right="0mm">
				<fo:table id="{@id}" table-layout="fixed" width="100%"> <!-- border="1pt solid black" -->
					<xsl:if test="ancestor::*[local-name() = 'table'][@class = 'recommendation' or @class='requirement' or @class='permission']">
						<!-- <xsl:attribute name="border">0.5pt solid black</xsl:attribute> -->
					</xsl:if>
					<xsl:variable name="simple-table">	
						<xsl:call-template  name="getSimpleTable"/>			
					</xsl:variable>					
					<xsl:variable name="cols-count" select="count(xalan:nodeset($simple-table)//tr[1]/td)"/>
					<xsl:if test="$cols-count = 2 and not(ancestor::*[local-name()='table'])">
						<!-- <fo:table-column column-width="35mm"/>
						<fo:table-column column-width="115mm"/> -->
						<fo:table-column column-width="30%"/>
						<fo:table-column column-width="70%"/>
					</xsl:if>
					<xsl:apply-templates mode="requirement"/>
				</fo:table>
				<!-- fn processing -->
				<xsl:if test=".//*[local-name() = 'fn']">
					<xsl:for-each select="*[local-name() = 'tbody']">
						<fo:block font-size="90%" border-bottom="1pt solid black">
							<xsl:call-template name="fn_display" />
						</fo:block>
					</xsl:for-each>
				</xsl:if>
			</fo:block-container>
		</fo:block-container>
	</xsl:template>
	
	<xsl:template match="*[local-name()='thead']" mode="requirement">		
		<fo:table-header>			
			<xsl:apply-templates mode="requirement"/>
		</fo:table-header>
	</xsl:template>
	
	<xsl:template match="*[local-name()='tbody']" mode="requirement">		
		<fo:table-body>
			<xsl:apply-templates mode="requirement"/>
		</fo:table-body>
	</xsl:template>
	
	<xsl:template match="*[local-name()='tr']" mode="requirement">
		<fo:table-row height="7mm" border-bottom="0.5pt solid grey">			
			<xsl:if test="parent::*[local-name()='thead']"> <!-- and not(ancestor::*[local-name() = 'table'][@class = 'recommendation' or @class='requirement' or @class='permission']) -->
				<!-- <xsl:attribute name="border">1pt solid black</xsl:attribute> -->
				<xsl:attribute name="background-color">rgb(33, 55, 92)</xsl:attribute>
			</xsl:if>
			<xsl:if test="starts-with(*[local-name()='td'][1], 'Requirement ')">
				<xsl:attribute name="background-color">rgb(252, 246, 222)</xsl:attribute>
			</xsl:if>
			<xsl:if test="starts-with(*[local-name()='td'][1], 'Recommendation ')">
				<xsl:attribute name="background-color">rgb(233, 235, 239)</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates mode="requirement"/>
		</fo:table-row>
	</xsl:template>
	
	
	<xsl:template match="*[local-name()='th']" mode="requirement">
		<fo:table-cell text-align="{@align}" display-align="center" padding="1mm" padding-left="2mm"> <!-- border="0.5pt solid black" -->
			<xsl:attribute name="text-align">
				<xsl:choose>
					<xsl:when test="@align">
						<xsl:value-of select="@align"/>
					</xsl:when>
					<xsl:otherwise>left</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
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
			
			<!-- <xsl:if test="ancestor::*[local-name()='table']/@type = 'recommend'">
				<xsl:attribute name="padding-top">0.5mm</xsl:attribute>
				<xsl:attribute name="background-color">rgb(165, 165, 165)</xsl:attribute>				
			</xsl:if>
			<xsl:if test="ancestor::*[local-name()='table']/@type = 'recommendtest'">
				<xsl:attribute name="padding-top">0.5mm</xsl:attribute>
				<xsl:attribute name="background-color">rgb(201, 201, 201)</xsl:attribute>				
			</xsl:if> -->
			
			<fo:block>
				<xsl:apply-templates />
			</fo:block>
		</fo:table-cell>
	</xsl:template>
	
	
	<xsl:template match="*[local-name()='td']" mode="requirement">
		<fo:table-cell text-align="{@align}" display-align="center" padding="1mm" padding-left="2mm" > <!-- border="0.5pt solid black" -->
			<xsl:if test="*[local-name() = 'table'][@class = 'recommendation' or @class='requirement' or @class='permission']">
				<xsl:attribute name="padding">0mm</xsl:attribute>
				<xsl:attribute name="padding-left">0mm</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="text-align">
				<xsl:choose>
					<xsl:when test="@align">
						<xsl:value-of select="@align"/>
					</xsl:when>
					<xsl:otherwise>left</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:if test="following-sibling::*[local-name()='td'] and not(preceding-sibling::*[local-name()='td'])">
				<xsl:attribute name="font-weight">bold</xsl:attribute>
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
			<xsl:call-template name="display-align" />
			
			<!-- <xsl:if test="ancestor::*[local-name()='table']/@type = 'recommend'">
				<xsl:attribute name="padding-left">0.5mm</xsl:attribute>
				<xsl:attribute name="padding-top">0.5mm</xsl:attribute>				 
				<xsl:if test="parent::*[local-name()='tr']/preceding-sibling::*[local-name()='tr'] and not(*[local-name()='table'])">
					<xsl:attribute name="background-color">rgb(201, 201, 201)</xsl:attribute>					
				</xsl:if>
			</xsl:if> -->
			<!-- 2nd line and below -->
			
			<fo:block>			
				<xsl:apply-templates />
			</fo:block>			
		</fo:table-cell>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'p'][@class='RecommendationTitle' or @class = 'RecommendationTestTitle']" priority="2">
		<fo:block font-size="11pt" color="rgb(237, 193, 35)"> <!-- font-weight="bold" margin-bottom="4pt" text-align="center"  -->
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'p2'][ancestor::*[local-name() = 'table'][@class = 'recommendation' or @class='requirement' or @class='permission']]">
		<fo:block> <!-- margin-bottom="10pt" -->
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	<!-- ========== -->
	<!-- END requirement, recommendation, permission table -->
	<!-- ========== -->
	
	<!-- ====== -->
	<!-- termexample -->	
	<!-- ====== -->
	<xsl:template match="*[local-name() = 'termexample']">
		<fo:block id="{@id}" xsl:use-attribute-sets="termexample-style">			
			<xsl:apply-templates select="*[local-name()='name']" mode="presentation"/>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	
	<xsl:template match="*[local-name() = 'termexample']/*[local-name() = 'name']"/>	
	
	<xsl:template match="*[local-name() = 'termexample']/*[local-name() = 'name']" mode="presentation">
		<xsl:if test="normalize-space() != ''">
			<fo:inline xsl:use-attribute-sets="termexample-name-style">
				<xsl:apply-templates /><xsl:if test="$namespace = 'rsd'">: </xsl:if>
			</fo:inline>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'termexample']/*[local-name() = 'p']">
		<xsl:variable name="element">inline
			<xsl:if test="$namespace = 'bsi'">block</xsl:if>
		</xsl:variable>		
		<xsl:choose>			
			<xsl:when test="contains($element, 'block')">
				<fo:block xsl:use-attribute-sets="example-p-style">
					<xsl:apply-templates/>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<fo:inline><xsl:apply-templates/></fo:inline>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>	
	<!-- ====== -->
	<!-- ====== -->
	
	<!-- ====== -->
	<!-- example -->	
	<!-- ====== -->
	
	<xsl:template match="*[local-name() = 'example']">
		<fo:block id="{@id}" xsl:use-attribute-sets="example-style">
			<xsl:if test="$namespace = 'rsd'">
				<xsl:if test="ancestor::rsd:ul or ancestor::rsd:ol">
					<xsl:attribute name="margin-top">6pt</xsl:attribute>
					<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			
			<xsl:apply-templates select="*[local-name()='name']" mode="presentation"/>
			
			<xsl:variable name="element">
				<xsl:if test="$namespace = 'csa' or 
													$namespace = 'csd' or 
													$namespace = 'gb' or 													
													$namespace = 'iho' or 
													$namespace = 'itu'  or 
													$namespace = 'nist-cswp' or 
													$namespace = 'nist-sp'or 
													$namespace = 'ogc-white-paper' or 
													$namespace = 'unece' or 
													$namespace = 'unece-rec' or $namespace = 'mpfd' or $namespace = 'bipm'">block</xsl:if>				
				<xsl:if test="$namespace = 'iec' or 
													$namespace = 'iso' or 
													$namespace = 'bsi' or 
													$namespace = 'jcgm' or 
													$namespace = 'ogc' or 
													$namespace = 'rsd' or 
													$namespace = 'm3d'">inline</xsl:if>
				<xsl:if test=".//*[local-name() = 'table']">block</xsl:if> 
			</xsl:variable>
			
			<xsl:choose>
				<xsl:when test="contains(normalize-space($element), 'block')">
					<fo:block xsl:use-attribute-sets="example-body-style">
						<xsl:apply-templates/>
					</fo:block>
				</xsl:when>
				<xsl:otherwise>
					<fo:inline>
						<xsl:apply-templates/>
					</fo:inline>
				</xsl:otherwise>
			</xsl:choose>
			
		</fo:block>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'example']/*[local-name() = 'name']"/>
	
	<xsl:template match="*[local-name() = 'example']/*[local-name() = 'name']" mode="presentation">

		<xsl:variable name="element">
			<xsl:if test="$namespace = 'csa' or 
												$namespace = 'csd' or 
												$namespace = 'iho' or 
												$namespace = 'itu' or 
												$namespace = 'nist-cswp' or 
												$namespace = 'nist-sp' or 
												$namespace = 'ogc-white-paper' or 
												$namespace = 'unece' or 
												$namespace = 'unece-rec' or $namespace = 'mpfd' or $namespace = 'bipm'">block</xsl:if>
			<xsl:if test="$namespace = 'gb' or 
												$namespace = 'iec' or 
												$namespace = 'iso' or 
												$namespace = 'bsi' or 
												$namespace = 'ogc' or
												$namespace = 'rsd' or 
												$namespace = 'm3d' or 
												$namespace = 'jcgm'">inline</xsl:if>
			<xsl:if test="following-sibling::*[1][local-name() = 'table']">block</xsl:if> 
		</xsl:variable>		
		<xsl:choose>
			<xsl:when test="ancestor::*[local-name() = 'appendix']">
				<fo:inline>
					<xsl:apply-templates/>
				</fo:inline>
			</xsl:when>
			<xsl:when test="contains(normalize-space($element), 'block')">
				<fo:block xsl:use-attribute-sets="example-name-style">
					<xsl:apply-templates/>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<fo:inline xsl:use-attribute-sets="example-name-style">
					<xsl:apply-templates/><xsl:if test="$namespace = 'ogc' or $namespace = 'rsd'">: </xsl:if>
				</fo:inline>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>
	
	<xsl:template match="*[local-name() = 'example']/*[local-name() = 'p']">
		<xsl:variable name="num"><xsl:number/></xsl:variable>
		<xsl:variable name="element">
			<xsl:if test="$namespace = 'bsi' or 
												$namespace = 'csa' or 
												$namespace = 'csd' or 
												$namespace = 'gb' or 
												$namespace = 'iec' or 
												$namespace = 'iho' or 
												$namespace = 'itu' or 
												$namespace = 'nist-cswp' or 
												$namespace = 'nist-sp' or 
												$namespace = 'ogc-white-paper' or 
												$namespace = 'unece' or 
												$namespace = 'unece-rec' or 
												$namespace = 'mpfd' or
												$namespace = 'm3d' or 
												$namespace = 'bipm'">block</xsl:if>
			<xsl:if test="$namespace = 'iso' or $namespace = 'jcgm' or $namespace = 'rsd'">
				<xsl:choose>
					<xsl:when test="$num = 1">inline</xsl:when>
					<xsl:otherwise>block</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:if test="$namespace = 'ogc' ">inline</xsl:if>
		</xsl:variable>		
		<xsl:choose>			
			<xsl:when test="normalize-space($element) = 'block'">
				<fo:block xsl:use-attribute-sets="example-p-style">
					<xsl:if test="$namespace = 'nist-cswp' or $namespace = 'unece' or $namespace = 'unece-rec'">
						<xsl:variable name="num"><xsl:number/></xsl:variable>
						<xsl:if test="$num = 1">
							<xsl:attribute name="margin-left">5mm</xsl:attribute>
						</xsl:if>
					</xsl:if>
					<xsl:apply-templates/>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<fo:inline xsl:use-attribute-sets="example-p-style">
					<xsl:apply-templates/>					
				</fo:inline>
			</xsl:otherwise>
		</xsl:choose>	
	</xsl:template>
	<!-- ====== -->
	<!-- ====== -->


	<!-- ====== -->
	<!-- termsource -->	
	<!-- origin -->	
	<!-- modification -->		
	<!-- ====== -->
	<xsl:template match="*[local-name() = 'termsource']" name="termsource">
		<fo:block xsl:use-attribute-sets="termsource-style">
			<!-- Example: [SOURCE: ISO 5127:2017, 3.1.6.02] -->			
			<xsl:variable name="termsource_text">
				<xsl:apply-templates />
			</xsl:variable>
			
			<xsl:choose>
				<xsl:when test="starts-with(normalize-space($termsource_text), '[')">
					<!-- <xsl:apply-templates /> -->
					<xsl:copy-of select="$termsource_text"/>
				</xsl:when>
				<xsl:otherwise>					
					<xsl:if test="$namespace = 'bsi' or $namespace = 'gb' or $namespace = 'iso' or $namespace = 'iec' or $namespace = 'itu' or $namespace = 'unece' or $namespace = 'unece-rec' or $namespace = 'nist-cswp'  or $namespace = 'nist-sp' or $namespace = 'ogc-white-paper' or $namespace = 'csa' or $namespace = 'csd' or $namespace = 'm3d' or $namespace = 'iho' or $namespace = 'bipm' or $namespace = 'jcgm'">
						<xsl:text>[</xsl:text>
					</xsl:if>
					<!-- <xsl:apply-templates />					 -->
					<xsl:copy-of select="$termsource_text"/>
					<xsl:if test="$namespace = 'bsi' or $namespace = 'gb' or $namespace = 'iso' or $namespace = 'iec' or $namespace = 'itu' or $namespace = 'unece' or $namespace = 'unece-rec' or $namespace = 'nist-cswp'  or $namespace = 'nist-sp' or $namespace = 'ogc-white-paper' or $namespace = 'csa' or $namespace = 'csd' or $namespace = 'm3d' or $namespace = 'iho' or $namespace = 'bipm' or $namespace = 'jcgm'">
						<xsl:text>]</xsl:text>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'termsource']/text()">
		<xsl:if test="normalize-space() != ''">
			<xsl:value-of select="."/>
		</xsl:if>
	</xsl:template>
	
	<xsl:variable name="localized.source">
		<xsl:call-template name="getLocalizedString">
			<xsl:with-param name="key">source</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	<xsl:template match="*[local-name() = 'origin']">
		<fo:basic-link internal-destination="{@bibitemid}" fox:alt-text="{@citeas}">
			<xsl:if test="normalize-space(@citeas) = ''">
				<xsl:attribute name="fox:alt-text"><xsl:value-of select="@bibitemid"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="$namespace = 'csa' or 
											$namespace = 'csd' or 
											$namespace = 'iho' or 
											$namespace = 'iec' or 
											$namespace = 'iso' or 
											$namespace = 'bsi' or 
											$namespace = 'ogc' or $namespace = 'ogc-white-paper' or 
											$namespace = 'rsd' or $namespace = 'mpfd' or $namespace = 'bipm' or $namespace = 'jcgm'">
				<xsl:if test="$namespace = 'ogc'"><xsl:text>[</xsl:text></xsl:if>
				<fo:inline>
					<xsl:if test="$namespace = 'ogc'">
						<xsl:attribute name="font-weight">bold</xsl:attribute>
						<xsl:attribute name="padding-right">1mm</xsl:attribute>
					</xsl:if>
					<xsl:if test="$namespace = 'rsd'">
						<xsl:attribute name="font-weight">bold</xsl:attribute>
						<xsl:attribute name="color"><xsl:value-of select="$color_blue"/></xsl:attribute>
					</xsl:if>
					
					
					<xsl:if test="$namespace = 'bsi' or $namespace = 'iso' or $namespace = 'rsd' or $namespace = 'ogc'">
						<xsl:value-of select="$localized.source"/>
						<xsl:text>: </xsl:text>
					</xsl:if>
					<xsl:if test="$namespace = 'bipm' or $namespace = 'jcgm'">
						<xsl:value-of select="$localized.source"/>
						<xsl:text> </xsl:text>
					</xsl:if>
					<xsl:if test="$namespace = 'csa' or $namespace = 'csd' or $namespace = 'gb' or $namespace = 'iec' or $namespace = 'iho' or $namespace = 'itu' or $namespace = 'm3d' or $namespace = 'mpfd' or $namespace = 'nist-cswp'  or $namespace = 'nist-sp' or $namespace = 'ogc-white-paper' or $namespace = 'unece' or $namespace = 'unece-rec'">
						<xsl:call-template name="getTitle">
							<xsl:with-param name="name" select="'title-source'"/>
						</xsl:call-template>
						<xsl:text>: </xsl:text>
					</xsl:if>
					
				</fo:inline>
			</xsl:if>
			<fo:inline xsl:use-attribute-sets="origin-style">
				<xsl:apply-templates/>
			</fo:inline>
			<xsl:if test="$namespace = 'ogc'"><xsl:text>]</xsl:text></xsl:if>
			</fo:basic-link>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'modification']/*[local-name() = 'p']">
		<fo:inline><xsl:apply-templates /></fo:inline>
	</xsl:template>	
	
	<xsl:template match="*[local-name() = 'modification']/text()">
		<xsl:if test="normalize-space() != ''">
			<xsl:value-of select="."/>
		</xsl:if>
	</xsl:template>
	
	<!-- ====== -->
	<!-- ====== -->


	<!-- ====== -->
	<!-- qoute -->	
	<!-- source -->	
	<!-- author  -->	
	<!-- ====== -->
	<xsl:template match="*[local-name() = 'quote']">		
		<fo:block-container margin-left="0mm">
			<xsl:if test="parent::*[local-name() = 'note']">
				<xsl:if test="not(ancestor::*[local-name() = 'table'])">
					<xsl:attribute name="margin-left">5mm</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$namespace = 'gb'">
				<xsl:attribute name="margin-left">0mm</xsl:attribute>
			</xsl:if>
			<xsl:if test="$namespace = 'jcgm'">
				<xsl:if test="not(*)">
					<xsl:attribute name="space-after">12pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<fo:block-container margin-left="0mm">
		
				<fo:block xsl:use-attribute-sets="quote-style">
					<!-- <xsl:apply-templates select=".//*[local-name() = 'p']"/> -->
					<xsl:if test="$namespace = 'jcgm'">
						<xsl:if test="ancestor::*[local-name() = 'boilerplate']">
							<xsl:attribute name="margin-left">7mm</xsl:attribute>
							<xsl:attribute name="margin-right">7mm</xsl:attribute>
							<xsl:attribute name="font-style">normal</xsl:attribute>
						</xsl:if>
					</xsl:if>
					<xsl:apply-templates select="./node()[not(local-name() = 'author') and not(local-name() = 'source')]"/> <!-- process all nested nodes, except author and source -->
				</fo:block>
				<xsl:if test="*[local-name() = 'author'] or *[local-name() = 'source']">
					<fo:block xsl:use-attribute-sets="quote-source-style">
						<!-- — ISO, ISO 7301:2011, Clause 1 -->
						<xsl:apply-templates select="*[local-name() = 'author']"/>
						<xsl:apply-templates select="*[local-name() = 'source']"/>				
					</fo:block>
				</xsl:if>
				
			</fo:block-container>
		</fo:block-container>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'source']">
		<xsl:if test="../*[local-name() = 'author']">
			<xsl:text>, </xsl:text>
		</xsl:if>
		<fo:basic-link internal-destination="{@bibitemid}" fox:alt-text="{@citeas}">
			<xsl:apply-templates />
		</fo:basic-link>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'author']">
		<xsl:text>— </xsl:text>
		<xsl:apply-templates />
	</xsl:template>
	<!-- ====== -->
	<!-- ====== -->


	<!-- ====== -->
	<!-- eref -->	
	<!-- source -->	
	<!-- author  -->	
	<!-- ====== -->
	<xsl:template match="*[local-name() = 'eref']">
	
		<xsl:variable name="bibitemid">
			<xsl:choose>
				<xsl:when test="//*[local-name() = 'bibitem'][@hidden='true' and @id = current()/@bibitemid]"></xsl:when>
				<xsl:when test="//*[local-name() = 'references'][@hidden='true']/*[local-name() = 'bibitem'][@id = current()/@bibitemid]"></xsl:when>
				<xsl:otherwise><xsl:value-of select="@bibitemid"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
	
		<xsl:choose>
			<xsl:when test="normalize-space($bibitemid) != ''">
				<fo:inline xsl:use-attribute-sets="eref-style">
					<xsl:if test="@type = 'footnote'">
						<xsl:if test="$namespace = 'bsi' or $namespace = 'csa' or $namespace = 'csd' or $namespace = 'iec' or $namespace = 'iho' or $namespace = 'itu' or $namespace = 'iso' or 
															$namespace = 'nist-cswp' or
															$namespace = 'nist-sp' or
															$namespace = 'ogc' or $namespace = 'ogc-white-paper' or 
															$namespace = 'rsd' or 
															$namespace = 'unece' or 
															$namespace = 'unece-rec' or $namespace = 'mpfd' or $namespace = 'bipm' or $namespace = 'jcgm'">
							<xsl:attribute name="keep-together.within-line">always</xsl:attribute>
							<xsl:attribute name="font-size">80%</xsl:attribute>
							<xsl:attribute name="keep-with-previous.within-line">always</xsl:attribute>
							<xsl:attribute name="vertical-align">super</xsl:attribute>
						</xsl:if>					
						<xsl:if test="$namespace = 'gb' or $namespace = 'm3d'">
							<xsl:attribute name="keep-together.within-line">always</xsl:attribute>
							<xsl:attribute name="font-size">50%</xsl:attribute>
							<xsl:attribute name="keep-with-previous.within-line">always</xsl:attribute>
							<xsl:attribute name="vertical-align">super</xsl:attribute>
						</xsl:if>
					</xsl:if>	
					
					<xsl:variable name="citeas" select="java:replaceAll(java:java.lang.String.new(@citeas),'^\[?(.+?)\]?$','$1')"/> <!-- remove leading and trailing brackets -->
					<xsl:variable name="text" select="normalize-space()"/>
					
					<xsl:if test="$namespace = 'bsi'">
						<xsl:if test="not(xalan:nodeset($ids)/id = current()/@bibitemid) or $document_type = 'PAS' or not(contains($citeas, $text))"> <!-- if reference can't be resolved or PAS document -->
							<xsl:attribute name="color">inherit</xsl:attribute>
							<xsl:attribute name="text-decoration">none</xsl:attribute>
						</xsl:if>
					</xsl:if>
            
					<fo:basic-link internal-destination="{@bibitemid}" fox:alt-text="{@citeas}">
						<xsl:if test="normalize-space(@citeas) = ''">
							<xsl:attribute name="fox:alt-text"><xsl:value-of select="."/></xsl:attribute>
						</xsl:if>
						<xsl:if test="@type = 'inline'">
							<xsl:if test="$namespace = 'csd' or $namespace = 'iho' or $namespace = 'ogc-white-paper' or $namespace = 'mpfd' or $namespace = 'bipm'">
								<xsl:attribute name="color">blue</xsl:attribute>
								<xsl:attribute name="text-decoration">underline</xsl:attribute>
							</xsl:if>
							<xsl:if test="$namespace = 'bipm'">
								<xsl:if test="parent::*[local-name() = 'title']">
									<xsl:attribute name="color">inherit</xsl:attribute>
									<xsl:attribute name="text-decoration">inherit</xsl:attribute>
									<xsl:attribute name="font-weight">normal</xsl:attribute>
								</xsl:if>
							</xsl:if>
							<xsl:if test="$namespace = 'ogc'">
							</xsl:if>
							<xsl:if test="$namespace = 'nist-cswp' or 
																$namespace = 'nist-sp' or 
																$namespace = 'unece'">
								<xsl:attribute name="text-decoration">underline</xsl:attribute>
							</xsl:if>
						</xsl:if>
						
						<xsl:if test="$namespace = 'bsi'">
							<xsl:if test="not(contains($citeas, $text))">
								<fo:inline xsl:use-attribute-sets="eref-style"><xsl:value-of select="$citeas"/></fo:inline><xsl:text>, </xsl:text>
							</xsl:if>
						</xsl:if>
						
						<xsl:apply-templates />
					</fo:basic-link>
							
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<fo:inline><xsl:apply-templates /></fo:inline>
			</xsl:otherwise>
		</xsl:choose>
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
			<xsl:if test="$namespace = 'csa'">2</xsl:if>
			<xsl:if test="$namespace = 'csd'">
				<xsl:choose>
					<xsl:when test="$depth &gt;= 3">3</xsl:when>
					<xsl:when test="$depth = 1">3</xsl:when>
					<xsl:otherwise>2</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:if test="$namespace = 'gb'">3</xsl:if>
			<xsl:if test="$namespace = 'iec'">
				<xsl:choose>
					<xsl:when test="parent::iec:appendix">5</xsl:when>
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
			<xsl:if test="$namespace = 'bsi'">
				<xsl:choose>
					<xsl:when test="$document_type = 'PAS'">
						<xsl:choose>
							<xsl:when test="$depth = 1">1.5</xsl:when>
							<xsl:otherwise>1</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="$depth = 1 and ../@ancestor = 'annex'">1.5</xsl:when>
							<xsl:when test="$depth = 2">3</xsl:when>
							<xsl:otherwise>4</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:if test="$namespace = 'iso' or $namespace = 'jcgm'">
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
					<xsl:when test="(ancestor-or-self::m3d:sections and $depth = 1) or 
															(local-name(../..) = 'references' and $references_num_current = 1)">25</xsl:when>
					<xsl:when test="ancestor-or-self::m3d:sections or ancestor-or-self::m3d:annex">3</xsl:when>
				</xsl:choose>
			</xsl:if>
			<xsl:if test="$namespace = 'nist-sp'">
				<xsl:choose>
					<xsl:when test="ancestor-or-self::nist:annex and $depth &gt;= 2">1</xsl:when>
					<xsl:when test="$depth = 1 and local-name(..) != 'annex'">5</xsl:when>
					<xsl:otherwise>1</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			
			<xsl:if test="$namespace = 'nist-cswp'">				
				<xsl:choose>
					<xsl:when test="$depth = 1 and local-name(..) != 'annex'">7.5</xsl:when>										
					<xsl:otherwise>4</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:if test="$namespace = 'ogc'">
				<xsl:choose>					
					<xsl:when test="$depth = 2">2</xsl:when>
					<xsl:otherwise>1</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:if test="$namespace = 'ogc-white-paper'">
				<xsl:choose>
					<xsl:when test="$depth &gt;= 5"/>
					<xsl:when test="$depth &gt;= 4">5</xsl:when>
					<xsl:when test="$depth &gt;= 3 and ancestor::ogc:terms">3</xsl:when>
					<xsl:when test="$depth &gt;= 2">4</xsl:when>
					<xsl:when test="$depth = 1">4</xsl:when>
					<xsl:otherwise>2</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:if test="$namespace = 'rsd'">1.5</xsl:if>
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
			<xsl:if test="$namespace = 'mpfd'">3</xsl:if>
			<xsl:if test="$namespace = 'bipm'">
				<xsl:choose>
					<xsl:when test="ancestor::bipm:annex">2</xsl:when>
					<xsl:otherwise>8</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:variable>
		
		<xsl:variable name="padding-right">
			<xsl:choose>
				<xsl:when test="normalize-space($padding) = ''">0</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space($padding)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="language" select="//*[local-name()='bibdata']//*[local-name()='language']"/>
		
		<xsl:choose>
			<xsl:when test="$language = 'zh'">
				<fo:inline><xsl:value-of select="$tab_zh"/></fo:inline>
			</xsl:when>
			<xsl:when test="../../@inline-header = 'true'">
				<fo:inline font-size="90%">
					<xsl:call-template name="insertNonBreakSpaces">
						<xsl:with-param name="count" select="$padding-right"/>
					</xsl:call-template>
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="direction"><xsl:if test="$lang = 'ar'"><xsl:value-of select="$RLM"/></xsl:if></xsl:variable>
				<fo:inline padding-right="{$padding-right}mm"><xsl:value-of select="$direction"/>&#x200B;</fo:inline>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
	<xsl:template name="insertNonBreakSpaces">
		<xsl:param name="count"/>
		<xsl:if test="$count &gt; 0">
			<xsl:text>&#xA0;</xsl:text>
			<xsl:call-template name="insertNonBreakSpaces">
				<xsl:with-param name="count" select="$count - 1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'domain']">
		<fo:inline xsl:use-attribute-sets="domain-style">&lt;<xsl:apply-templates/>&gt;</fo:inline>
		<xsl:text> </xsl:text>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'admitted']">
		<fo:block xsl:use-attribute-sets="admitted-style">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'deprecates']">
		<xsl:variable name="title-deprecated">
			<xsl:if test="$namespace = 'bsi' or $namespace = 'iso' or $namespace = 'jcgm' or $namespace = 'rsd' ">
				<xsl:call-template name="getLocalizedString">
					<xsl:with-param name="key">deprecated</xsl:with-param>
				</xsl:call-template>
			</xsl:if>
			<xsl:if test="$namespace = 'bipm' or $namespace = 'csa' or $namespace = 'csd' or $namespace = 'gb' or $namespace = 'iec' or $namespace = 'iho' or $namespace = 'itu' or $namespace = 'm3d' or $namespace = 'mpfd' or $namespace = 'nist-cswp'  or $namespace = 'nist-sp' or $namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'unece' or $namespace = 'unece-rec'">
				<xsl:call-template name="getTitle">
					<xsl:with-param name="name" select="'title-deprecated'"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:variable>
		<fo:block xsl:use-attribute-sets="deprecates-style">
			<xsl:value-of select="$title-deprecated"/>: <xsl:apply-templates />
		</fo:block>
	</xsl:template>


	
	<!-- ========== -->
	<!-- definition -->
	<!-- ========== -->
	<xsl:template match="*[local-name() = 'definition']">
		<fo:block xsl:use-attribute-sets="definition-style">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'definition'][preceding-sibling::*[local-name() = 'domain']]">
		<xsl:apply-templates />
	</xsl:template>
	<xsl:template match="*[local-name() = 'definition'][preceding-sibling::*[local-name() = 'domain']]/*[local-name() = 'p']">
		<fo:inline> <xsl:apply-templates /></fo:inline>
		<fo:block>&#xA0;</fo:block>
	</xsl:template>
	<!-- ========== -->
	<!-- ========== -->
	
	
	<!-- main sections -->
	<xsl:template match="/*/*[local-name() = 'sections']/*" priority="2">
		<xsl:if test="$namespace = 'm3d' or $namespace = 'unece-rec'">
				<fo:block break-after="page"/>
		</xsl:if>
		<fo:block>
			<xsl:call-template name="setId"/>
			<xsl:if test="$namespace = 'csa'">
				<xsl:variable name="pos"><xsl:number count="csa:sections/csa:clause[not(@type='scope') and not(@type='conformance')]"/></xsl:variable>
				<xsl:if test="$pos &gt;= 2">
					<xsl:attribute name="space-before">18pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$namespace = 'csd'">
				<xsl:variable name="pos"><xsl:number count="csd:sections/csd:clause | csd:sections/csd:terms"/></xsl:variable>
				<xsl:if test="$pos &gt;= 2">
					<xsl:attribute name="space-before">18pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$namespace = 'gb'">
				<xsl:variable name="pos"><xsl:number count="gb:sections/gb:clause | gb:sections/gb:terms"/></xsl:variable>
				<xsl:if test="$pos &gt;= 2">
					<xsl:attribute name="space-before">18pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$namespace = 'bsi' or $namespace = 'iso' or $namespace = 'jcgm'">
				<xsl:variable name="pos"><xsl:number count="*"/></xsl:variable>
				<xsl:if test="$pos &gt;= 2">
					<xsl:attribute name="space-before">18pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$namespace = 'itu'">
				<xsl:if test="*[1][@class='supertitle']">
					<xsl:attribute name="space-before">36pt</xsl:attribute>
				</xsl:if>
				<xsl:if test="@inline-header='true'">
					<xsl:attribute name="text-align">justify</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$namespace = 'm3d'">
				<xsl:variable name="pos"><xsl:number count="m3d:sections/m3d:clause | m3d:sections/m3d:terms"/></xsl:variable>
				<xsl:if test="$pos &gt;= 2">
					<xsl:attribute name="space-before">18pt</xsl:attribute>
				</xsl:if>
			</xsl:if>			
			<xsl:if test="$namespace = 'rsd'">
				<xsl:variable name="pos"><xsl:number count="rsd:sections/rsd:clause[not(@type='scope') and not(@type='conformance')]"/></xsl:variable> <!--  | rsd:sections/rsd:terms -->
				<xsl:if test="$pos &gt;= 2">
					<xsl:attribute name="space-before">18pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
				<xsl:variable name="pos"><xsl:number count="ogc:sections/ogc:clause[not(@type='scope') and not(@type='conformance')]"/></xsl:variable> <!--  | ogc:sections/ogc:terms -->
				<xsl:if test="$pos &gt;= 2">
					<xsl:attribute name="space-before">18pt</xsl:attribute>
				</xsl:if>
			</xsl:if>			
			<xsl:if test="$namespace = 'unece'">
				<xsl:variable name="num"><xsl:number /></xsl:variable>
				<xsl:if test="$num = 1">
					<xsl:attribute name="margin-top">20pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$namespace = 'unece-rec'">
				<xsl:variable name="num"><xsl:number /></xsl:variable>
				<xsl:if test="$num = 1">
					<xsl:attribute name="margin-top">3pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:apply-templates />
		</fo:block>
		
		<xsl:if test="$namespace = 'nist-cswp' or $namespace = 'nist-sp'">
				<xsl:if test="position() != last()">
					<fo:block break-after="page"/>
				</xsl:if>
		</xsl:if>
		
	</xsl:template>
	
	<xsl:template match="//*[contains(local-name(), '-standard')]/*[local-name() = 'preface']/*" priority="2"> <!-- /*/*[local-name() = 'preface']/* -->
		<fo:block break-after="page"/>
		<fo:block>
			<xsl:call-template name="setId"/>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>



	
	<xsl:template match="*[local-name() = 'clause']">
		<fo:block>
			<xsl:call-template name="setId"/>
			<xsl:if test="$namespace = 'bipm'">
				<xsl:attribute name="keep-with-next">always</xsl:attribute>
			</xsl:if>
			<xsl:if test="$namespace = 'bsi'">
				<xsl:attribute name="keep-with-next">always</xsl:attribute>
			</xsl:if>
			<xsl:if test="$namespace = 'itu' or $namespace = 'jcgm'">
				<xsl:if test="@inline-header='true'">
					<xsl:attribute name="text-align">justify</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'definitions']">
		<fo:block id="{@id}">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'references'][@hidden='true']" priority="3"/>
	<xsl:template match="*[local-name() = 'bibitem'][@hidden='true']" priority="3"/>
	
	<xsl:template match="/*/*[local-name() = 'bibliography']/*[local-name() = 'references'][@normative='true']">
		<xsl:if test="$namespace = 'nist-sp' or $namespace = 'nist-cswp'">
			<fo:block break-after="page"/>
		</xsl:if>
		<fo:block id="{@id}">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	
	<xsl:template match="*[local-name() = 'annex']">
		<fo:block break-after="page"/>
		<fo:block id="{@id}">
			<xsl:if test="$namespace = 'unece' or $namespace = 'unece-rec'">
				<xsl:variable name="num"><xsl:number /></xsl:variable>
				<xsl:if test="$num = 1">
					<xsl:attribute name="margin-top">3pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
		</fo:block>
		<xsl:apply-templates />
	</xsl:template>
	
	
	<xsl:template match="*[local-name() = 'review']">
		<!-- comment 2019-11-29 -->
		<!-- <fo:block font-weight="bold">Review:</fo:block>
		<xsl:apply-templates /> -->
	</xsl:template>

	<xsl:template match="*[local-name() = 'name']/text()">
		<!-- 0xA0 to space replacement -->
		<xsl:value-of select="java:replaceAll(java:java.lang.String.new(.),' ',' ')"/>
	</xsl:template>
	

	<xsl:template match="*[local-name() = 'ul'] | *[local-name() = 'ol']">
		<xsl:choose>
			<xsl:when test="parent::*[local-name() = 'note'] or parent::*[local-name() = 'termnote']">
				<fo:block-container>
					<xsl:attribute name="margin-left">
						<xsl:choose>
							<xsl:when test="not(ancestor::*[local-name() = 'table'])"><xsl:value-of select="$note-body-indent"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="$note-body-indent-table"/></xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:if test="$namespace = 'gb'">
						<xsl:attribute name="margin-left">0mm</xsl:attribute>
					</xsl:if>
					<xsl:if test="$namespace = 'bipm'">
						<xsl:attribute name="margin-left">0mm</xsl:attribute>
					</xsl:if>
					<xsl:if test="$namespace = 'bsi'">
						<xsl:attribute name="margin-left">12mm</xsl:attribute>
					</xsl:if>
					<fo:block-container margin-left="0mm">
						<fo:block>
							<xsl:apply-templates select="." mode="ul_ol"/>
						</fo:block>
					</fo:block-container>
				</fo:block-container>
			</xsl:when>
			<xsl:otherwise>
				<fo:block>
					<xsl:apply-templates select="." mode="ul_ol"/>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- =================== -->
	<!-- Index section processing -->
	<!-- =================== -->

	<xsl:variable name="index" select="document($external_index)"/>
	
	<xsl:variable name="dash" select="'&#x2013;'"/>
	
	<xsl:variable name="bookmark_in_fn">
		<xsl:for-each select="//*[local-name() = 'bookmark'][ancestor::*[local-name() = 'fn']]">
			<bookmark><xsl:value-of select="@id"/></bookmark>
		</xsl:for-each>
	</xsl:variable>

	<xsl:template match="@*|node()" mode="index_add_id">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="index_add_id"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'xref']" mode="index_add_id">
		<xsl:variable name="id">
			<xsl:call-template name="generateIndexXrefId"/>
		</xsl:variable>
		<xsl:copy> <!-- add id to xref -->
			<xsl:apply-templates select="@*" mode="index_add_id"/>
			<xsl:attribute name="id">
				<xsl:value-of select="$id"/>
			</xsl:attribute>
			<xsl:apply-templates mode="index_add_id"/>
		</xsl:copy>
		<!-- split <xref target="bm1" to="End" pagenumber="true"> to two xref:
		<xref target="bm1" pagenumber="true"> and <xref target="End" pagenumber="true"> -->
		<xsl:if test="@to">
			<xsl:value-of select="$dash"/>
			<xsl:copy>
				<xsl:copy-of select="@*"/>
				<xsl:attribute name="target"><xsl:value-of select="@to"/></xsl:attribute>
				<xsl:attribute name="id">
					<xsl:value-of select="$id"/><xsl:text>_to</xsl:text>
				</xsl:attribute>
				<xsl:apply-templates mode="index_add_id"/>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<xsl:template match="@*|node()" mode="index_update">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="index_update"/>
		</xsl:copy>
	</xsl:template>
	
	
	<xsl:template match="*[local-name() = 'indexsect']//*[local-name() = 'li']" mode="index_update">
		<xsl:copy>
			<xsl:apply-templates select="@*"  mode="index_update"/>
		<xsl:apply-templates select="node()[1]" mode="process_li_element"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[local-name() = 'indexsect']//*[local-name() = 'li']/node()" mode="process_li_element" priority="2">
		<xsl:param name="element" />
		<xsl:param name="remove" select="'false'"/>
		<xsl:param name="target"/>
		<!-- <node></node> -->
		<xsl:choose>
			<xsl:when test="self::text()  and (normalize-space(.) = ',' or normalize-space(.) = $dash) and $remove = 'true'">
				<!-- skip text (i.e. remove it) and process next element -->
				<!-- [removed_<xsl:value-of select="."/>] -->
				<xsl:apply-templates select="following-sibling::node()[1]" mode="process_li_element">
					<xsl:with-param name="target"><xsl:value-of select="$target"/></xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="self::text()">
				<xsl:value-of select="."/>
				<xsl:apply-templates select="following-sibling::node()[1]" mode="process_li_element"/>
			</xsl:when>
			<xsl:when test="self::* and local-name(.) = 'xref'">
				<xsl:variable name="id" select="@id"/>
				<xsl:variable name="page" select="$index//item[@id = $id]"/>
				<xsl:variable name="id_next" select="following-sibling::*[local-name() = 'xref'][1]/@id"/>
				<xsl:variable name="page_next" select="$index//item[@id = $id_next]"/>
				
				<xsl:variable name="id_prev" select="preceding-sibling::*[local-name() = 'xref'][1]/@id"/>
				<xsl:variable name="page_prev" select="$index//item[@id = $id_prev]"/>
				
				<xsl:choose>
					<!-- 2nd pass -->
					<!-- if page is equal to page for next and page is not the end of range -->
					<xsl:when test="$page != '' and $page_next != '' and $page = $page_next and not(contains($page, '_to'))">  <!-- case: 12, 12-14 -->
						<!-- skip element (i.e. remove it) and remove next text ',' -->
						<!-- [removed_xref] -->
						
						<xsl:apply-templates select="following-sibling::node()[1]" mode="process_li_element">
							<xsl:with-param name="remove">true</xsl:with-param>
							<xsl:with-param name="target">
								<xsl:choose>
									<xsl:when test="$target != ''"><xsl:value-of select="$target"/></xsl:when>
									<xsl:otherwise><xsl:value-of select="@target"/></xsl:otherwise>
								</xsl:choose>
							</xsl:with-param>
						</xsl:apply-templates>
					</xsl:when>
					
					<xsl:when test="$page != '' and $page_prev != '' and $page = $page_prev and contains($page_prev, '_to')"> <!-- case: 12-14, 14, ... -->
						<!-- remove xref -->
						<xsl:apply-templates select="following-sibling::node()[1]" mode="process_li_element">
							<xsl:with-param name="remove">true</xsl:with-param>
						</xsl:apply-templates>
					</xsl:when>

					<xsl:otherwise>
						<xsl:apply-templates select="." mode="xref_copy">
							<xsl:with-param name="target" select="$target"/>
						</xsl:apply-templates>
						<xsl:apply-templates select="following-sibling::node()[1]" mode="process_li_element"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="self::* and local-name(.) = 'ul'">
				<!-- ul -->
				<xsl:apply-templates select="." mode="index_update"/>
			</xsl:when>
			<xsl:otherwise>
			 <xsl:apply-templates select="." mode="xref_copy">
					<xsl:with-param name="target" select="$target"/>
				</xsl:apply-templates>
				<xsl:apply-templates select="following-sibling::node()[1]" mode="process_li_element"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="@*|node()" mode="xref_copy">
		<xsl:param name="target"/>
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="xref_copy"/>
			<xsl:if test="$target != '' and not(xalan:nodeset($bookmark_in_fn)//bookmark[. = $target])">
				<xsl:attribute name="target"><xsl:value-of select="$target"/></xsl:attribute>
			</xsl:if>
			<xsl:apply-templates select="node()" mode="xref_copy"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template name="generateIndexXrefId">
		<xsl:variable name="level" select="count(ancestor::*[local-name() = 'ul'])"/>
		
		<xsl:variable name="docid">
			<xsl:call-template name="getDocumentId"/>
		</xsl:variable>
		<xsl:variable name="item_number">
			<xsl:number count="*[local-name() = 'li'][ancestor::*[local-name() = 'indexsect']]" level="any" />
		</xsl:variable>
		<xsl:variable name="xref_number"><xsl:number count="*[local-name() = 'xref']"/></xsl:variable>
		<xsl:value-of select="concat($docid, '_', $item_number, '_', $xref_number)"/> <!-- $level, '_',  -->
	</xsl:template>

	<xsl:template match="*[local-name() = 'indexsect']/*[local-name() = 'clause']" priority="4">
		<xsl:apply-templates />
		<fo:block>
		<xsl:if test="following-sibling::*[local-name() = 'clause']">
			<fo:block>&#xA0;</fo:block>
		</xsl:if>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'indexsect']//*[local-name() = 'ul']" priority="4">
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="*[local-name() = 'indexsect']//*[local-name() = 'li']" priority="4">
		<xsl:variable name="level" select="count(ancestor::*[local-name() = 'ul'])" />
		<fo:block start-indent="{5 * $level}mm" text-indent="-5mm">
			<xsl:if test="$namespace = 'bsi'">
				<xsl:if test="count(ancestor::bsi:ul) = 1">
					<xsl:variable name="prev_first_char" select="java:toLowerCase(java:java.lang.String.new(substring(normalize-space(preceding-sibling::bsi:li[1]), 1, 1)))"/>
					<xsl:variable name="curr_first_char" select="java:toLowerCase(java:java.lang.String.new(substring(normalize-space(), 1, 1)))"/>
					<xsl:if test="$curr_first_char != $prev_first_char and preceding-sibling::bsi:li">
						<xsl:attribute name="space-before">12pt</xsl:attribute>
					</xsl:if>
				</xsl:if>
			</xsl:if>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'bookmark']" name="bookmark">
		<fo:inline id="{@id}" font-size="1pt"/>
	</xsl:template>
	<!-- =================== -->
	<!-- End of Index processing -->
	<!-- =================== -->
	
	<!-- ============ -->
	<!-- errata -->
	<!-- ============ -->
	<xsl:template match="*[local-name() = 'errata']">
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
					<fo:table-cell border="1pt solid black"><fo:block>Date</fo:block></fo:table-cell>
					<fo:table-cell border="1pt solid black"><fo:block>Type</fo:block></fo:table-cell>
					<fo:table-cell border="1pt solid black"><fo:block>Change</fo:block></fo:table-cell>
					<fo:table-cell border="1pt solid black"><fo:block>Pages</fo:block></fo:table-cell>
				</fo:table-row>
				<xsl:apply-templates />
			</fo:table-body>
		</fo:table>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'errata']/*[local-name() = 'row']">
		<fo:table-row>
			<xsl:apply-templates />
		</fo:table-row>
	</xsl:template>

	<xsl:template match="*[local-name() = 'errata']/*[local-name() = 'row']/*">
		<fo:table-cell border="1pt solid black" padding-left="1mm" padding-top="0.5mm">
			<fo:block><xsl:apply-templates /></fo:block>
		</fo:table-cell>
	</xsl:template>
	
	<!-- ============ -->
	<!-- ============ -->

	<xsl:template name="processBibitem">
		
		<xsl:if test="$namespace = 'bipm'">
			<!-- start BIPM bibtem processing -->
			<xsl:choose>
				<xsl:when test="*[local-name() = 'formattedref']">
					<xsl:apply-templates select="*[local-name() = 'formattedref']"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="docidentifier" select="*[local-name() = 'docidentifier'][not(@type = 'URN' or @type = 'metanorma' or @type = 'BIPM' or @type = 'ISBN' or @type = 'ISSN')]"/>
					
					<xsl:value-of select="$docidentifier"/>
					<xsl:if test="$docidentifier != '' and *[local-name() = 'title']">, </xsl:if>
					
					<xsl:variable name="curr_lang" select="ancestor::bipm:bipm-standard/bipm:bibdata/bipm:language"/>
					
					<xsl:choose>
						<xsl:when test="*[local-name() = 'title'][@type = 'main' and @language = $curr_lang]">
							<xsl:apply-templates select="*[local-name() = 'title'][@type = 'main' and @language = $curr_lang]"/>
						</xsl:when>
						<xsl:when test="*[local-name() = 'title'][@type = 'main' and @language = 'en']">
							<xsl:apply-templates select="*[local-name() = 'title'][@type = 'main' and @language = 'en']"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="*[local-name() = 'title']"/>
						</xsl:otherwise>
					</xsl:choose>
					
				</xsl:otherwise>
			</xsl:choose>
			<!-- end BIPM bibitem processing-->
		</xsl:if>
		
		<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<!-- start OGC bibtem processing -->
			<xsl:choose>
				<xsl:when test="*[local-name() = 'formattedref']">
					<xsl:apply-templates select="*[local-name() = 'formattedref']"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="personalAuthors">
						<xsl:for-each select="*[local-name() = 'contributor'][*[local-name() = 'role']/@type='author']/*[local-name() = 'person']">
							<xsl:call-template name="processPersonalAuthor"/>
						</xsl:for-each>
						<xsl:if test="not(*[local-name() = 'contributor'][*[local-name() = 'role']/@type='author']/*[local-name() = 'person'])">
							<xsl:for-each select="*[local-name() = 'contributor'][*[local-name() = 'role']/@type='editor']/*[local-name() = 'person']">
								<xsl:call-template name="processPersonalAuthor"/>
							</xsl:for-each>
						</xsl:if>
					</xsl:variable>
					
					<xsl:variable name="city" select="*[local-name() = 'place']"/>
					<xsl:variable name="year">
						<xsl:choose>
							<xsl:when test="*[local-name() = 'date'][@type = 'published']">
								<xsl:for-each select="*[local-name() = 'date'][@type = 'published']">
									<xsl:call-template name="renderDate"/>									
								</xsl:for-each>								
							</xsl:when>
							<xsl:when test="*[local-name() = 'date'][@type = 'issued']">
								<xsl:for-each select="*[local-name() = 'date'][@type = 'issued']">
									<xsl:call-template name="renderDate"/>									
								</xsl:for-each>
							</xsl:when>
							<xsl:when test="*[local-name() = 'date'][@type = 'circulated']">
								<xsl:for-each select="*[local-name() = 'date'][@type = 'circulated']">
									<xsl:call-template name="renderDate"/>									
								</xsl:for-each>								
							</xsl:when>
							<xsl:otherwise>
								<xsl:for-each select="*[local-name() = 'date']">
									<xsl:call-template name="renderDate"/>
								</xsl:for-each>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					
					<xsl:variable name="uri" select="*[local-name() = 'uri']"/>
					
					
					<!-- citation structure:
					{personal names | organisation}: {document identifier}, {title}. {publisher}, {city} ({year})
					-->
					
					<!-- Author(s) -->
					<xsl:choose>
						<xsl:when test="xalan:nodeset($personalAuthors)//author">
							<xsl:for-each select="xalan:nodeset($personalAuthors)//author">
								<xsl:apply-templates />
								<xsl:if test="position() != last()">, </xsl:if>
							</xsl:for-each>
							<xsl:text>: </xsl:text>
						</xsl:when>
						<xsl:when test="*[local-name() = 'contributor'][*[local-name() = 'role']/@type = 'publisher']/*[local-name() = 'organization']/*[local-name() = 'abbreviation']">
							<xsl:for-each select="*[local-name() = 'contributor'][*[local-name() = 'role']/@type = 'publisher']/*[local-name() = 'organization']/*[local-name() = 'abbreviation']">
								<xsl:value-of select="."/>
								<xsl:if test="position() != last()">/</xsl:if>
							</xsl:for-each>
							<xsl:text>: </xsl:text>
						</xsl:when>
						<xsl:when test="*[local-name() = 'contributor'][*[local-name() = 'role']/@type = 'publisher']/*[local-name() = 'organization']/*[local-name() = 'name']">									
							<xsl:for-each select="*[local-name() = 'contributor'][*[local-name() = 'role']/@type = 'publisher']/*[local-name() = 'organization']/*[local-name() = 'name']">
								<xsl:value-of select="."/>
								<xsl:if test="position() != last()">, </xsl:if>
							</xsl:for-each>
							<xsl:text>: </xsl:text>
						</xsl:when>
					</xsl:choose>
					
					
					<xsl:variable name="document_identifier">
						<xsl:call-template name="processBibitemDocId"/>
					</xsl:variable>
					
					<xsl:value-of select="$document_identifier"/>
					
					<xsl:apply-templates select="*[local-name() = 'note']"/>
					
					<xsl:variable name="isDraft">
						<xsl:variable name="stage" select="normalize-space(*[local-name() = 'status']/*[local-name() = 'stage'])"/>						
						<xsl:if test="*[local-name() = 'contributor'][*[local-name() = 'role']/@type = 'publisher']/*[local-name() = 'organization'][*[local-name() = 'name']/text() = 'Open Geospatial Consortium'] and
											$stage != '' and
											$stage != 'published' and $stage != 'deprecated' and $stage != 'retired'">true</xsl:if>
					</xsl:variable>	 
					
					<xsl:if test="$isDraft = 'true'">
						<xsl:text> (Draft)</xsl:text>
					</xsl:if>
					
					<xsl:text>, </xsl:text>
					
					<xsl:choose>
						<xsl:when test="*[local-name() = 'title'][@type = 'main' and @language = 'en']">
							<xsl:apply-templates select="*[local-name() = 'title'][@type = 'main' and @language = 'en']"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="*[local-name() = 'title']"/>
						</xsl:otherwise>
					</xsl:choose>
					
					<xsl:text>. </xsl:text>
					
					<xsl:if test="*[local-name() = 'contributor'][*[local-name() = 'role']/@type = 'publisher']/*[local-name() = 'organization']/*[local-name() = 'name']">									
						<xsl:for-each select="*[local-name() = 'contributor'][*[local-name() = 'role']/@type = 'publisher']/*[local-name() = 'organization']/*[local-name() = 'name']">
							<xsl:value-of select="."/>
							<xsl:if test="position() != last()">, </xsl:if>
						</xsl:for-each>
						<xsl:if test="normalize-space($city) != ''">, </xsl:if>
					</xsl:if>
					
					<xsl:value-of select="$city"/>
					
					<xsl:if test="(*[local-name() = 'contributor'][*[local-name() = 'role']/@type = 'publisher']/*[local-name() = 'organization']/*[local-name() = 'name'] or normalize-space($city) != '') and normalize-space($year) != ''">
						<xsl:text> </xsl:text>
					</xsl:if>
					
					<xsl:if test="normalize-space($year) != ''">
						<xsl:text>(</xsl:text>
						<xsl:value-of select="$year"/>
						<xsl:text>). </xsl:text>
					</xsl:if>
					
					<xsl:if test="normalize-space($uri) != ''">
						<fo:inline>
							<xsl:if test="$namespace = 'ogc'">
								<xsl:attribute name="text-decoration">underline</xsl:attribute>
							</xsl:if>
							<xsl:text> </xsl:text>
							<fo:basic-link external-destination="{$uri}" fox:alt-text="{$uri}">
								<xsl:value-of select="$uri"/>							
							</fo:basic-link>
						</fo:inline>
					</xsl:if>
					
				</xsl:otherwise>
			</xsl:choose>
			<!-- end OGC bibitem processing-->
		</xsl:if> 
		
		
		<xsl:if test="$namespace = 'iho'">
			<!-- start IHO bibtem processing -->
			<xsl:choose>
				<xsl:when test="iho:formattedref">
					<xsl:apply-templates select="iho:formattedref"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
				<!-- IHO documents -->
				<!-- {docID} edition {edition}: {title}, {author/organization} -->
						<xsl:when test="iho:docidentifier[1]/@type='IHO'">						
							<xsl:value-of select="iho:docidentifier[1]"/>							
							<xsl:apply-templates select="iho:edition"/>							
							<xsl:if test="iho:title or iho:contributor or iho:url">
								<xsl:text>: </xsl:text>
							</xsl:if>							
						</xsl:when>
						
						<!-- Non-IHO documents -->
						<!-- title and publisher -->
						<xsl:otherwise>						
							<xsl:variable name="docID">
								<xsl:call-template name="processBibitemDocId"/>
							</xsl:variable>							
							<xsl:value-of select="normalize-space($docID)"/>
							<xsl:if test="normalize-space($docID) != ''"><xsl:text>: </xsl:text></xsl:if>							
						</xsl:otherwise>						
					</xsl:choose>
					
					<xsl:choose>
						<xsl:when test="iho:title[@type = 'main' and @language = 'en']">
							<xsl:apply-templates select="iho:title[@type = 'main' and @language = 'en']"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="iho:title"/>
						</xsl:otherwise>
					</xsl:choose>
					
					<xsl:if test="iho:title and iho:contributor">
						<xsl:text>, </xsl:text>
					</xsl:if>
					
					<xsl:variable name="authors">
						<xsl:choose>
							<xsl:when test="*[local-name() = 'contributor'][*[local-name() = 'role']/@type='author']">
								<xsl:for-each select="*[local-name() = 'contributor'][*[local-name() = 'role']/@type='author']">
									<xsl:copy-of select="."/>
								</xsl:for-each>
							</xsl:when>
							<xsl:when test="*[local-name() = 'contributor'][*[local-name() = 'role']/@type='editor']">
								<xsl:for-each select="*[local-name() = 'contributor'][*[local-name() = 'role']/@type='editor']">
									<xsl:copy-of select="."/>
								</xsl:for-each>
							</xsl:when>							
							<xsl:when test="*[local-name() = 'contributor'][*[local-name() = 'role']/@type='publisher'][*[local-name() = 'organization']]">
								<xsl:for-each select="*[local-name() = 'contributor'][*[local-name() = 'role']/@type='publisher'][*[local-name() = 'organization']]">
									<xsl:copy>
										<xsl:choose>
											<xsl:when test="position() != 1 and position() != last()">, </xsl:when>
											<xsl:when test="position() != 1 and position() = last()"> and </xsl:when>
										</xsl:choose>
										<xsl:value-of select="*[local-name() = 'organization']/*[local-name() = 'name']"/>
									</xsl:copy>
								</xsl:for-each>
							</xsl:when>
						</xsl:choose>						
					</xsl:variable>
					
					<xsl:for-each select="xalan:nodeset($authors)/*">
						<xsl:choose>							
							<xsl:when test="not(*[local-name() = 'role'])"><!-- publisher organisation -->								
								<xsl:value-of select="."/>
							</xsl:when>
							<xsl:otherwise> <!-- author, editor -->
								<xsl:choose>
									<xsl:when test="*[local-name() = 'organization']/*[local-name() = 'name']">										
										<xsl:value-of select="*[local-name() = 'organization']/*[local-name() = 'name']"/>
									</xsl:when>
									<xsl:otherwise>										
										<xsl:for-each select="*[local-name() = 'person']">
											<xsl:variable name="author">
												<xsl:call-template name="processPersonalAuthor"/>
											</xsl:variable>
											<xsl:value-of select="xalan:nodeset($author)/author"/>
										</xsl:for-each>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:if test="*[local-name() = 'organization']/*[local-name() = 'name'] and position() != last()">
							<xsl:text>, </xsl:text>
						</xsl:if>						
					</xsl:for-each>
					
					<xsl:apply-templates select="*[local-name() = 'uri'][1]"/>
					
				</xsl:otherwise>
			</xsl:choose>
			<!-- end IHO bibitem processing -->
		</xsl:if> 
		
		<xsl:if test="$namespace = 'iso'">
			<!-- start ISO bibtem processing -->
			<xsl:variable name="docidentifier">
				<xsl:if test="*[local-name() = 'docidentifier']">
					<xsl:choose>
						<xsl:when test="*[local-name() = 'docidentifier']/@type = 'metanorma'"/>
						<xsl:otherwise><xsl:value-of select="*[local-name() = 'docidentifier']"/></xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</xsl:variable>
			<xsl:value-of select="$docidentifier"/>
			<xsl:apply-templates select="*[local-name() = 'note']"/>			
			<xsl:if test="normalize-space($docidentifier) != ''">, </xsl:if>
			<xsl:choose>
				<xsl:when test="*[local-name() = 'title'][@type = 'main' and @language = $lang]">
					<xsl:apply-templates select="*[local-name() = 'title'][@type = 'main' and @language = $lang]"/>
				</xsl:when>
				<xsl:when test="*[local-name() = 'title'][@type = 'main' and @language = 'en']">
					<xsl:apply-templates select="*[local-name() = 'title'][@type = 'main' and @language = 'en']"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="*[local-name() = 'title']"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates select="*[local-name() = 'formattedref']"/>
			<!-- end ISO bibitem processing -->
		</xsl:if>
		
		<xsl:if test="$namespace = 'bsi'">
			<!-- start BSI bibtem processing -->
			<xsl:variable name="docidentifier">
				<xsl:if test="*[local-name() = 'docidentifier']">
					<xsl:choose>
						<xsl:when test="*[local-name() = 'docidentifier'][not(@type = 'metanorma')] and $document_type = 'PAS'">
							<xsl:value-of select="*[local-name() = 'docidentifier'][not(@type = 'metanorma')]"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="count(*[local-name() = 'docidentifier']) &gt; 1">
									<xsl:value-of select="*[local-name() = 'docidentifier'][not(@type = 'metanorma')][1]"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="*[local-name() = 'docidentifier']"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</xsl:variable>
			
			<!-- string starts with [ -->
			<xsl:variable name="isStartsWithOpeningBracket" select="starts-with($docidentifier,'[')"/>
			<!-- string ends with [ -->
			<xsl:variable name="isEndsWithClosingBracket" select="java:endsWith(java:java.lang.String.new($docidentifier),']')"/>
			<xsl:variable name="removeBrackets">
				<xsl:choose>
					<xsl:when test="$isStartsWithOpeningBracket = 'true' and $isEndsWithClosingBracket">
						<xsl:choose>
							<!-- [1] [2] ... -->
							<xsl:when test="normalize-space(java:replaceAll(java:java.lang.String.new($docidentifier), '^\[[0-9]+\]$', '')) = ''">false</xsl:when>
							<xsl:otherwise>true</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>false</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="docidentifier_">
				<xsl:choose>
					<xsl:when test="contains($removeBrackets, 'true')">
						<xsl:value-of select="substring($docidentifier, 2, string-length($docidentifier) - 2)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$docidentifier"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<xsl:if test="count(*[local-name() = 'docidentifier']) &gt; 1 and *[local-name() = 'docidentifier'][@type = 'metanorma']">
				<xsl:value-of select="*[local-name() = 'docidentifier'][@type = 'metanorma']"/><xsl:text> </xsl:text>
			</xsl:if>
			
			<xsl:value-of select="$docidentifier_"/>
			
			<xsl:apply-templates select="*[local-name() = 'note']"/>			
			<xsl:if test="normalize-space($docidentifier_) != ''">
				<!-- <xsl:if test="preceding-sibling::*[local-name() = 'references'][1][@normative = 'true']">,</xsl:if> -->
				<xsl:if test="not(starts-with($docidentifier_, '['))">,</xsl:if>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="*[local-name() = 'title'][@type = 'main' and @language = $lang]">
					<xsl:apply-templates select="*[local-name() = 'title'][@type = 'main' and @language = $lang]"/>
				</xsl:when>
				<xsl:when test="*[local-name() = 'title'][@type = 'main' and @language = 'en']">
					<xsl:apply-templates select="*[local-name() = 'title'][@type = 'main' and @language = 'en']"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="*[local-name() = 'title']"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates select="*[local-name() = 'formattedref']"/>
			<!-- end BSI bibitem processing -->
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="processBibitemDocId">
		<xsl:variable name="_doc_ident" select="*[local-name() = 'docidentifier'][not(@type = 'DOI' or @type = 'metanorma' or @type = 'ISSN' or @type = 'ISBN' or @type = 'rfc-anchor')]"/>
		<xsl:choose>
			<xsl:when test="normalize-space($_doc_ident) != ''">
				<!-- <xsl:variable name="type" select="*[local-name() = 'docidentifier'][not(@type = 'DOI' or @type = 'metanorma' or @type = 'ISSN' or @type = 'ISBN' or @type = 'rfc-anchor')]/@type"/>
				<xsl:if test="$type != '' and not(contains($_doc_ident, $type))">
					<xsl:value-of select="$type"/><xsl:text> </xsl:text>
				</xsl:if> -->
				<xsl:value-of select="$_doc_ident"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- <xsl:variable name="type" select="*[local-name() = 'docidentifier'][not(@type = 'metanorma')]/@type"/>
				<xsl:if test="$type != ''">
					<xsl:value-of select="$type"/><xsl:text> </xsl:text>
				</xsl:if> -->
				<xsl:value-of select="*[local-name() = 'docidentifier'][not(@type = 'metanorma')]"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="processPersonalAuthor">
		<xsl:choose>
			<xsl:when test="*[local-name() = 'name']/*[local-name() = 'completename']">
				<author>
					<xsl:apply-templates select="*[local-name() = 'name']/*[local-name() = 'completename']"/>
				</author>
			</xsl:when>
			<xsl:when test="*[local-name() = 'name']/*[local-name() = 'surname'] and *[local-name() = 'name']/*[local-name() = 'initial']">
				<author>
					<xsl:apply-templates select="*[local-name() = 'name']/*[local-name() = 'surname']"/>
					<xsl:text> </xsl:text>
					<xsl:apply-templates select="*[local-name() = 'name']/*[local-name() = 'initial']" mode="strip"/>
				</author>
			</xsl:when>
			<xsl:when test="*[local-name() = 'name']/*[local-name() = 'surname'] and *[local-name() = 'name']/*[local-name() = 'forename']">
				<author>
					<xsl:apply-templates select="*[local-name() = 'name']/*[local-name() = 'surname']"/>
					<xsl:text> </xsl:text>
					<xsl:apply-templates select="*[local-name() = 'name']/*[local-name() = 'forename']" mode="strip"/>
				</author>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="renderDate">		
			<xsl:if test="normalize-space(*[local-name() = 'on']) != ''">
				<xsl:value-of select="*[local-name() = 'on']"/>
			</xsl:if>
			<xsl:if test="normalize-space(*[local-name() = 'from']) != ''">
				<xsl:value-of select="concat(*[local-name() = 'from'], '–', *[local-name() = 'to'])"/>
			</xsl:if>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'name']/*[local-name() = 'initial']/text()" mode="strip">
		<xsl:value-of select="translate(.,'. ','')"/>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'name']/*[local-name() = 'forename']/text()" mode="strip">
		<xsl:value-of select="substring(.,1,1)"/>
	</xsl:template>


	<xsl:template match="*[local-name() = 'title']" mode="title">
		<fo:inline><xsl:apply-templates /></fo:inline>
	</xsl:template>
	
	<!-- =================== -->
	<!-- Form's elements processing -->
	<!-- =================== -->
	<xsl:template match="*[local-name() = 'form']">
		<fo:block>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'form']//*[local-name() = 'label']">
		<fo:inline><xsl:apply-templates /></fo:inline>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'form']//*[local-name() = 'input'][@type = 'text' or @type = 'date' or @type = 'file' or @type = 'password']">
		<fo:inline>
			<xsl:call-template name="text_input"/>
		</fo:inline>
	</xsl:template>
	
	<xsl:template name="text_input">
		<xsl:variable name="count">
			<xsl:choose>
				<xsl:when test="normalize-space(@maxlength) != ''"><xsl:value-of select="@maxlength"/></xsl:when>
				<xsl:when test="normalize-space(@size) != ''"><xsl:value-of select="@size"/></xsl:when>
				<xsl:otherwise>10</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:call-template name="repeat">
			<xsl:with-param name="char" select="'_'"/>
			<xsl:with-param name="count" select="$count"/>
		</xsl:call-template>
		<xsl:text> </xsl:text>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'form']//*[local-name() = 'input'][@type = 'button']">
		<xsl:variable name="caption">
			<xsl:choose>
				<xsl:when test="normalize-space(@value) != ''"><xsl:value-of select="@value"/></xsl:when>
				<xsl:otherwise>BUTTON</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<fo:inline>[<xsl:value-of select="$caption"/>]</fo:inline>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'form']//*[local-name() = 'input'][@type = 'checkbox']">
		<fo:inline padding-right="1mm">
			<fo:instream-foreign-object fox:alt-text="Box" baseline-shift="-10%">
				<xsl:attribute name="height">3.5mm</xsl:attribute>
				<xsl:attribute name="content-width">100%</xsl:attribute>
				<xsl:attribute name="content-width">scale-down-to-fit</xsl:attribute>
				<xsl:attribute name="scaling">uniform</xsl:attribute>
				<svg xmlns="http://www.w3.org/2000/svg" width="80" height="80">
					<polyline points="0,0 80,0 80,80 0,80 0,0" stroke="black" stroke-width="5" fill="white"/>
				</svg>
			</fo:instream-foreign-object>
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'form']//*[local-name() = 'input'][@type = 'radio']">
		<fo:inline padding-right="1mm">
			<fo:instream-foreign-object fox:alt-text="Box" baseline-shift="-10%">
				<xsl:attribute name="height">3.5mm</xsl:attribute>
				<xsl:attribute name="content-width">100%</xsl:attribute>
				<xsl:attribute name="content-width">scale-down-to-fit</xsl:attribute>
				<xsl:attribute name="scaling">uniform</xsl:attribute>
				<svg xmlns="http://www.w3.org/2000/svg" width="80" height="80">
					<circle cx="40" cy="40" r="30" stroke="black" stroke-width="5" fill="white"/>
					<circle cx="40" cy="40" r="15" stroke="black" stroke-width="5" fill="white"/>
				</svg>
			</fo:instream-foreign-object>
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'form']//*[local-name() = 'select']">
		<fo:inline>
			<xsl:call-template name="text_input"/>
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'form']//*[local-name() = 'textarea']">
		<fo:block-container border="1pt solid black" width="50%">
			<fo:block>&#xA0;</fo:block>
		</fo:block-container>
	</xsl:template>

	<!-- =================== -->
	<!-- End Form's elements processing -->
	<!-- =================== -->
	
	<!-- =================== -->
	<!-- Table of Contents (ToC) processing -->
	<!-- =================== -->
	<xsl:template match="*[local-name() = 'toc']">
		<xsl:param name="colwidths"/>
		<xsl:variable name="colwidths_">
			<xsl:choose>
				<xsl:when test="not($colwidths)">
					<xsl:variable name="toc_table_simple">
						<tbody>
							<xsl:apply-templates mode="toc_table_width" />
						</tbody>
					</xsl:variable>
					<xsl:variable name="cols-count" select="count(xalan:nodeset($toc_table_simple)/*/tr[1]/td)"/>
					<xsl:call-template name="calculate-column-widths">
						<xsl:with-param name="cols-count" select="$cols-count"/>
						<xsl:with-param name="table" select="$toc_table_simple"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="$colwidths"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<fo:block role="TOCI" space-after="16pt">
			<fo:table width="100%" table-layout="fixed">
				<xsl:for-each select="xalan:nodeset($colwidths_)/column">
					<fo:table-column column-width="proportional-column-width({.})"/>
				</xsl:for-each>
				<fo:table-body>
					<xsl:apply-templates />
				</fo:table-body>
			</fo:table>
		</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'toc']//*[local-name() = 'li']">
		<fo:table-row min-height="5mm">
			<xsl:apply-templates />
		</fo:table-row>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'toc']//*[local-name() = 'li']/*[local-name() = 'p']">
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="*[local-name() = 'toc']//*[local-name() = 'xref']" priority="3">
		<!-- <xref target="cgpm9th1948r6">1.6.3<tab/>&#8220;9th CGPM, 1948:<tab/>decision to establish the SI&#8221;</xref> -->
		<xsl:variable name="target" select="@target"/>
		<xsl:for-each select="*[local-name() = 'tab']">
			<xsl:variable name="current_id" select="generate-id()"/>
			<fo:table-cell>
				<fo:block>
					<fo:basic-link internal-destination="{$target}" fox:alt-text="{.}">
						<xsl:for-each select="following-sibling::node()[not(self::*[local-name() = 'tab']) and preceding-sibling::*[local-name() = 'tab'][1][generate-id() = $current_id]]">
							<xsl:choose>
								<xsl:when test="self::text()"><xsl:value-of select="."/></xsl:when>
								<xsl:otherwise><xsl:apply-templates select="."/></xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</fo:basic-link>
				</fo:block>
			</fo:table-cell>
		</xsl:for-each>
		<!-- last column - for page numbers -->
		<fo:table-cell text-align="right" font-size="10pt" font-weight="bold" font-family="Arial">
			<fo:block>
				<fo:basic-link internal-destination="{$target}" fox:alt-text="{.}">
					<fo:page-number-citation ref-id="{$target}"/>
				</fo:basic-link>
			</fo:block>
		</fo:table-cell>
	</xsl:template>
	
	<!-- ================================== -->
	<!-- calculate ToC table columns widths -->
	<!-- ================================== -->
	<xsl:template match="*" mode="toc_table_width">
		<xsl:apply-templates mode="toc_table_width" />
	</xsl:template>

	<xsl:template match="*[local-name() = 'clause'][@type = 'toc']/*[local-name() = 'title']" mode="toc_table_width"/>
	<xsl:template match="*[local-name() = 'clause'][not(@type = 'toc')]/*[local-name() = 'title']" mode="toc_table_width" />
	
	<xsl:template match="*[local-name() = 'li']" mode="toc_table_width">
		<tr>
			<xsl:apply-templates mode="toc_table_width"/>
		</tr>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'xref']" mode="toc_table_width">
		<!-- <xref target="cgpm9th1948r6">1.6.3<tab/>&#8220;9th CGPM, 1948:<tab/>decision to establish the SI&#8221;</xref> -->
		<xsl:for-each select="*[local-name() = 'tab']">
			<xsl:variable name="current_id" select="generate-id()"/>
			<td>
				<xsl:for-each select="following-sibling::node()[not(self::*[local-name() = 'tab']) and preceding-sibling::*[local-name() = 'tab'][1][generate-id() = $current_id]]">
					<xsl:copy-of select="."/>
				</xsl:for-each>
			</td>
		</xsl:for-each>
		<td>333</td> <!-- page number, just for fill -->
	</xsl:template>
	
	<!-- ================================== -->
	<!-- END: calculate ToC table columns widths -->
	<!-- ================================== -->
	
	<!-- =================== -->
	<!-- End Table of Contents (ToC) processing -->
	<!-- =================== -->
	
	
	<xsl:template match="*[local-name() = 'variant-title'][@type = 'sub']"/>
	<xsl:template match="*[local-name() = 'variant-title'][@type = 'sub']" mode="subtitle">
		<fo:inline padding-right="5mm">&#xa0;</fo:inline>
		<fo:inline><xsl:apply-templates /></fo:inline>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'blacksquare']" name="blacksquare">
		<fo:inline padding-right="2.5mm" baseline-shift="5%">
			<fo:instream-foreign-object content-height="2mm" content-width="2mm"  fox:alt-text="Quad">
					<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" xml:space="preserve"
					viewBox="0 0 2 2">
						<rect x="0" y="0" width="2" height="2" fill="black"  />
					</svg>
				</fo:instream-foreign-object>	
		</fo:inline>
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
				<xsl:when test="$format = 'ddMMyyyy'">
					<xsl:if test="$day != ''"><xsl:value-of select="number($day)"/></xsl:if>
					<xsl:text> </xsl:text>
					<xsl:value-of select="normalize-space(concat($monthStr, ' ' , $year))"/>
				</xsl:when>
				<xsl:when test="$format = 'ddMM'">
					<xsl:if test="$day != ''"><xsl:value-of select="number($day)"/></xsl:if>
					<xsl:text> </xsl:text><xsl:value-of select="$monthStr"/>
				</xsl:when>
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
	
	<!-- convert YYYY-MM-DD to 'Month YYYY' or 'Month DD, YYYY' or DD Month YYYY -->
	<xsl:template name="convertDateLocalized">
		<xsl:param name="date"/>
		<xsl:param name="format" select="'short'"/>
		<xsl:variable name="year" select="substring($date, 1, 4)"/>
		<xsl:variable name="month" select="substring($date, 6, 2)"/>
		<xsl:variable name="day" select="substring($date, 9, 2)"/>
		<xsl:variable name="monthStr">
			<xsl:choose>
				<xsl:when test="$month = '01'"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_january</xsl:with-param></xsl:call-template></xsl:when>
				<xsl:when test="$month = '02'"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_february</xsl:with-param></xsl:call-template></xsl:when>
				<xsl:when test="$month = '03'"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_march</xsl:with-param></xsl:call-template></xsl:when>
				<xsl:when test="$month = '04'"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_april</xsl:with-param></xsl:call-template></xsl:when>
				<xsl:when test="$month = '05'"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_may</xsl:with-param></xsl:call-template></xsl:when>
				<xsl:when test="$month = '06'"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_june</xsl:with-param></xsl:call-template></xsl:when>
				<xsl:when test="$month = '07'"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_july</xsl:with-param></xsl:call-template></xsl:when>
				<xsl:when test="$month = '08'"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_august</xsl:with-param></xsl:call-template></xsl:when>
				<xsl:when test="$month = '09'"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_september</xsl:with-param></xsl:call-template></xsl:when>
				<xsl:when test="$month = '10'"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_october</xsl:with-param></xsl:call-template></xsl:when>
				<xsl:when test="$month = '11'"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_november</xsl:with-param></xsl:call-template></xsl:when>
				<xsl:when test="$month = '12'"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_december</xsl:with-param></xsl:call-template></xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="result">
			<xsl:choose>
				<xsl:when test="$format = 'ddMMyyyy'">
					<xsl:if test="$day != ''"><xsl:value-of select="number($day)"/></xsl:if>
					<xsl:text> </xsl:text>
					<xsl:value-of select="normalize-space(concat($monthStr, ' ' , $year))"/>
				</xsl:when>
				<xsl:when test="$format = 'ddMM'">
					<xsl:if test="$day != ''"><xsl:value-of select="number($day)"/></xsl:if>
					<xsl:text> </xsl:text><xsl:value-of select="$monthStr"/>
				</xsl:when>
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
				<xsl:for-each select="//*[contains(local-name(), '-standard')]/*[local-name() = 'bibdata']//*[local-name() = 'keyword']">
					<xsl:sort data-type="text" order="ascending"/>
					<xsl:call-template name="insertKeyword">
						<xsl:with-param name="charAtEnd" select="$charAtEnd"/>
						<xsl:with-param name="charDelim" select="$charDelim"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="//*[contains(local-name(), '-standard')]/*[local-name() = 'bibdata']//*[local-name() = 'keyword']">
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
		<xsl:variable name="lang">
			<xsl:call-template name="getLang"/>
		</xsl:variable>
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
							<xsl:for-each select="(//*[contains(local-name(), '-standard')])[1]/*[local-name() = 'bibdata']">
								<xsl:if test="$namespace = 'bsi' or $namespace = 'iso' or $namespace = 'gb' or $namespace = 'iec' or $namespace = 'nist-cswp'  or $namespace = 'nist-sp' or $namespace = 'unece' or $namespace = 'unece-rec'">
									<xsl:value-of select="*[local-name() = 'title'][@language = $lang and @type = 'main']"/>
								</xsl:if>
								<xsl:if test="$namespace = 'bipm'">
									<xsl:value-of select="*[local-name() = 'title'][@language = $lang and @type = 'main']"/>
								</xsl:if>
								<xsl:if test="$namespace = 'jcgm'">
									<xsl:value-of select="*[local-name() = 'title'][@language = $lang and @type = 'part']"/>
								</xsl:if>
								<xsl:if test="$namespace = 'iho' or $namespace = 'csa' or $namespace = 'csd' or $namespace = 'rsd' or $namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'mpfd'">								
									<xsl:value-of select="*[local-name() = 'title'][@language = $lang]"/>
								</xsl:if>
								<xsl:if test="$namespace = 'm3d'">
									<xsl:value-of select="*[local-name() = 'title']"/>
								</xsl:if>
								<xsl:if test="$namespace = 'itu'">
									<xsl:value-of select="*[local-name() = 'title'][@type='main']"/>
								</xsl:if>								
							</xsl:for-each>
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
						<xsl:for-each select="(//*[contains(local-name(), '-standard')])[1]/*[local-name() = 'bibdata']">
							<xsl:if test="$namespace = 'bsi' or $namespace = 'bipm' or $namespace = 'csa' or $namespace = 'csd' or $namespace = 'gb' or $namespace = 'iec' or $namespace = 'iho' or $namespace = 'iso' or $namespace = 'itu' or $namespace = 'm3d' or $namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'rsd' or $namespace = 'unece' or $namespace = 'unece-rec'">
								<xsl:for-each select="*[local-name() = 'contributor'][*[local-name() = 'role']/@type='author']">
									<xsl:value-of select="*[local-name() = 'organization']/*[local-name() = 'name']"/>
									<xsl:if test="position() != last()">; </xsl:if>
								</xsl:for-each>
							</xsl:if>
							<xsl:if test="$namespace = 'jcgm'">
								<xsl:value-of select="normalize-space(*[local-name() = 'ext']/*[local-name() = 'editorialgroup']/*[local-name() = 'committee'])"/>
							</xsl:if>
							<xsl:if test="$namespace = 'nist-cswp'  or $namespace = 'nist-sp'">
								<xsl:for-each select="*[local-name() = 'contributor'][*[local-name() = 'role']/@type='author']">
									<xsl:value-of select="*[local-name() = 'person']/*[local-name() = 'name']/*[local-name() = 'completename']"/>
									<xsl:if test="position() != last()">; </xsl:if>
								</xsl:for-each>
							</xsl:if>
						</xsl:for-each>
					</dc:creator>
					<dc:description>
						<xsl:variable name="abstract">
							<xsl:if test="$namespace = 'bsi' or $namespace = 'bipm' or $namespace = 'csa' or $namespace = 'csd' or $namespace = 'gb' or $namespace = 'iec' or $namespace = 'iho' or  $namespace = 'iso' or $namespace = 'itu' or $namespace = 'm3d' or $namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'rsd' or $namespace = 'nist-cswp' or $namespace = 'nist-sp' or $namespace = 'unece' or $namespace = 'unece-rec'">
								<xsl:copy-of select="//*[contains(local-name(), '-standard')]/*[local-name() = 'preface']/*[local-name() = 'abstract']//text()"/>									
							</xsl:if>
							<xsl:if test="$namespace = 'jcgm'">
								<xsl:value-of select="//*[contains(local-name(), '-standard')]/*[local-name() = 'bibdata']/*[local-name() = 'title'][@language = $lang and @type = 'main']"/>
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
						<xsl:when test="parent::*[local-name() = 'preface']">
							<xsl:value-of select="$level_total - 1"/>
						</xsl:when>
						<xsl:when test="ancestor::*[local-name() = 'preface'] and not(ancestor::*[local-name() = 'foreword']) and not(ancestor::*[local-name() = 'introduction'])"> <!-- for preface/clause -->
							<xsl:value-of select="$level_total - 1"/>
						</xsl:when>
						<xsl:when test="ancestor::*[local-name() = 'preface']">
							<xsl:value-of select="$level_total - 2"/>
						</xsl:when>
						<!-- <xsl:when test="parent::*[local-name() = 'sections']">
							<xsl:value-of select="$level_total - 1"/>
						</xsl:when> -->
						<xsl:when test="ancestor::*[local-name() = 'sections']">
							<xsl:value-of select="$level_total - 1"/>
						</xsl:when>
						<xsl:when test="ancestor::*[local-name() = 'bibliography']">
							<xsl:value-of select="$level_total - 1"/>
						</xsl:when>
						<xsl:when test="parent::*[local-name() = 'annex']">
							<xsl:value-of select="$level_total - 1"/>
						</xsl:when>
						<xsl:when test="ancestor::*[local-name() = 'annex']">
							<xsl:value-of select="$level_total"/>
						</xsl:when>
						<xsl:when test="local-name() = 'annex'">1</xsl:when>
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

	<xsl:template name="getLevelTermName">
		<xsl:choose>
			<xsl:when test="normalize-space(../@depth) != ''">
				<xsl:value-of select="../@depth"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="title_level_">
					<xsl:for-each select="../preceding-sibling::*[local-name() = 'title'][1]">
						<xsl:call-template name="getLevel"/>
					</xsl:for-each>
				</xsl:variable>
				<xsl:variable name="title_level" select="normalize-space($title_level_)"/>
				<xsl:choose>
					<xsl:when test="$title_level != ''"><xsl:value-of select="$title_level + 1"/></xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="getLevel"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="split">
		<xsl:param name="pText" select="."/>
		<xsl:param name="sep" select="','"/>
		<xsl:param name="normalize-space" select="'true'"/>
		<xsl:if test="string-length($pText) >0">
		<item>
			<xsl:choose>
				<xsl:when test="$normalize-space = 'true'">
					<xsl:value-of select="normalize-space(substring-before(concat($pText, $sep), $sep))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="substring-before(concat($pText, $sep), $sep)"/>
				</xsl:otherwise>
			</xsl:choose>
		</item>
		<xsl:call-template name="split">
			<xsl:with-param name="pText" select="substring-after($pText, $sep)"/>
			<xsl:with-param name="sep" select="$sep"/>
			<xsl:with-param name="normalize-space" select="$normalize-space"/>
		</xsl:call-template>
		</xsl:if>
	</xsl:template>
 
	<xsl:template name="getDocumentId">		
		<xsl:call-template name="getLang"/><xsl:value-of select="//*[local-name() = 'p'][1]/@id"/>
	</xsl:template>

	<xsl:template name="namespaceCheck">
		<xsl:variable name="documentNS" select="namespace-uri(/*)"/>
		<xsl:variable name="XSLNS">			
			<xsl:if test="$namespace = 'bsi'">
				<xsl:value-of select="document('')//*/namespace::bsi"/>
			</xsl:if>
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
			<xsl:if test="$namespace = 'nist-cswp'  or $namespace = 'nist-sp'">
				<xsl:value-of select="document('')//*/namespace::nist"/>
			</xsl:if>
			<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
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
			<xsl:if test="$namespace = 'mpfd'">
				<xsl:value-of select="document('')//*/namespace::mpfd"/>
			</xsl:if>
			<xsl:if test="$namespace = 'bipm'">
				<xsl:value-of select="document('')//*/namespace::bipm"/>
			</xsl:if>
			<xsl:if test="$namespace = 'jcgm'">
				<xsl:value-of select="document('')//*/namespace::bipm"/>
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

	<xsl:template name="setId">
		<xsl:attribute name="id">
			<xsl:choose>
				<xsl:when test="@id">
					<xsl:value-of select="@id"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="generate-id()"/>
				</xsl:otherwise>
			</xsl:choose>					
		</xsl:attribute>
	</xsl:template>

	<xsl:template name="add-letter-spacing">
		<xsl:param name="text"/>
		<xsl:param name="letter-spacing" select="'0.15'"/>
		<xsl:if test="string-length($text) &gt; 0">
			<xsl:variable name="char" select="substring($text, 1, 1)"/>
			<fo:inline padding-right="{$letter-spacing}mm">
				<xsl:if test="$char = '®'">
					<xsl:attribute name="font-size">58%</xsl:attribute>
					<xsl:attribute name="baseline-shift">30%</xsl:attribute>
				</xsl:if>				
				<xsl:value-of select="$char"/>
			</fo:inline>
			<xsl:call-template name="add-letter-spacing">
				<xsl:with-param name="text" select="substring($text, 2)"/>
				<xsl:with-param name="letter-spacing" select="$letter-spacing"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template name="repeat">
		<xsl:param name="char" select="'*'"/>
		<xsl:param name="count" />
		<xsl:if test="$count &gt; 0">
			<xsl:value-of select="$char" />
			<xsl:call-template name="repeat">
				<xsl:with-param name="char" select="$char" />
				<xsl:with-param name="count" select="$count - 1" />
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template name="getLocalizedString">
		<xsl:param name="key"/>
		<xsl:param name="formatted">false</xsl:param>
		
		<xsl:variable name="curr_lang">
			<xsl:call-template name="getLang"/>
		</xsl:variable>
		
		<xsl:variable name="data_value">
			<xsl:choose>
				<xsl:when test="$formatted = 'true'">
					<xsl:apply-templates select="xalan:nodeset($bibdata)//*[local-name() = 'localized-string'][@key = $key and @language = $curr_lang]"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space(xalan:nodeset($bibdata)//*[local-name() = 'localized-string'][@key = $key and @language = $curr_lang])"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="normalize-space($data_value) != ''">
				<xsl:choose>
					<xsl:when test="$formatted = 'true'"><xsl:copy-of select="$data_value"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="$data_value"/></xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/*/*[local-name() = 'localized-strings']/*[local-name() = 'localized-string'][@key = $key and @language = $curr_lang]">
				<xsl:choose>
					<xsl:when test="$formatted = 'true'">
						<xsl:apply-templates select="/*/*[local-name() = 'localized-strings']/*[local-name() = 'localized-string'][@key = $key and @language = $curr_lang]"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="/*/*[local-name() = 'localized-strings']/*[local-name() = 'localized-string'][@key = $key and @language = $curr_lang]"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="key_">
					<xsl:call-template name="capitalize">
						<xsl:with-param name="str" select="translate($key, '_', ' ')"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:value-of select="$key_"/>
			</xsl:otherwise>
		</xsl:choose>
			
	</xsl:template>
	
	
	<xsl:template name="setTrackChangesStyles">
		<xsl:param name="isAdded"/>
		<xsl:param name="isDeleted"/>
		<xsl:choose>
			<xsl:when test="local-name() = 'math'">
				<xsl:if test="$isAdded = 'true'">
					<xsl:attribute name="background-color"><xsl:value-of select="$color-added-text"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="$isDeleted = 'true'">
					<xsl:attribute name="background-color"><xsl:value-of select="$color-deleted-text"/></xsl:attribute>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$isAdded = 'true'">
					<xsl:attribute name="border"><xsl:value-of select="$border-block-added"/></xsl:attribute>
					<xsl:attribute name="padding">2mm</xsl:attribute>
				</xsl:if>
				<xsl:if test="$isDeleted = 'true'">
					<xsl:attribute name="border"><xsl:value-of select="$border-block-deleted"/></xsl:attribute>
					<xsl:if test="local-name() = 'table'">
						<xsl:attribute name="background-color">rgb(255, 185, 185)</xsl:attribute>
					</xsl:if>
					<!-- <xsl:attribute name="color"><xsl:value-of select="$color-deleted-text"/></xsl:attribute> -->
					<xsl:attribute name="padding">2mm</xsl:attribute>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--  see https://xmlgraphics.apache.org/fop/2.5/complexscripts.html#bidi_controls-->
	<xsl:variable name="LRM" select="'&#x200e;'"/> <!-- U+200E - LEFT-TO-RIGHT MARK (LRM) -->
	<xsl:variable name="RLM" select="'&#x200f;'"/> <!-- U+200F - RIGHT-TO-LEFT MARK (RLM) -->
	<xsl:template name="setWritingMode">
		<xsl:if test="$lang = 'ar'">
			<xsl:attribute name="writing-mode">rl-tb</xsl:attribute>
		</xsl:if>
	</xsl:template>
 
	<xsl:template name="setAlignment">
		<xsl:param name="align" select="normalize-space(@align)"/>
		<xsl:choose>
			<xsl:when test="$lang = 'ar' and $align = 'left'">start</xsl:when>
			<xsl:when test="$lang = 'ar' and $align = 'right'">end</xsl:when>
			<xsl:when test="$align != ''">
				<xsl:value-of select="$align"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
 
	<xsl:template name="setTextAlignment">
		<xsl:param name="default">left</xsl:param>
		<xsl:attribute name="text-align">
			<xsl:choose>
				<xsl:when test="@align"><xsl:value-of select="@align"/></xsl:when>
				<xsl:when test="ancestor::*[local-name() = 'td']/@align"><xsl:value-of select="ancestor::*[local-name() = 'td']/@align"/></xsl:when>
				<xsl:when test="ancestor::*[local-name() = 'th']/@align"><xsl:value-of select="ancestor::*[local-name() = 'th']/@align"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$default"/></xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:template>
 
	<xsl:template name="number-to-words">
		<xsl:param name="number" />
		<xsl:param name="first"/>
		<xsl:if test="$number != ''">
			<xsl:variable name="words">
								<words>
					<word cardinal="1">One-</word>
					<word ordinal="1">First </word>
					<word cardinal="2">Two-</word>
					<word ordinal="2">Second </word>
					<word cardinal="3">Three-</word>
					<word ordinal="3">Third </word>
					<word cardinal="4">Four-</word>
					<word ordinal="4">Fourth </word>
					<word cardinal="5">Five-</word>
					<word ordinal="5">Fifth </word>
					<word cardinal="6">Six-</word>
					<word ordinal="6">Sixth </word>
					<word cardinal="7">Seven-</word>
					<word ordinal="7">Seventh </word>
					<word cardinal="8">Eight-</word>
					<word ordinal="8">Eighth </word>
					<word cardinal="9">Nine-</word>
					<word ordinal="9">Ninth </word>
					<word ordinal="10">Tenth </word>
					<word ordinal="11">Eleventh </word>
					<word ordinal="12">Twelfth </word>
					<word ordinal="13">Thirteenth </word>
					<word ordinal="14">Fourteenth </word>
					<word ordinal="15">Fifteenth </word>
					<word ordinal="16">Sixteenth </word>
					<word ordinal="17">Seventeenth </word>
					<word ordinal="18">Eighteenth </word>
					<word ordinal="19">Nineteenth </word>
					<word cardinal="20">Twenty-</word>
					<word ordinal="20">Twentieth </word>
					<word cardinal="30">Thirty-</word>
					<word ordinal="30">Thirtieth </word>
					<word cardinal="40">Forty-</word>
					<word ordinal="40">Fortieth </word>
					<word cardinal="50">Fifty-</word>
					<word ordinal="50">Fiftieth </word>
					<word cardinal="60">Sixty-</word>
					<word ordinal="60">Sixtieth </word>
					<word cardinal="70">Seventy-</word>
					<word ordinal="70">Seventieth </word>
					<word cardinal="80">Eighty-</word>
					<word ordinal="80">Eightieth </word>
					<word cardinal="90">Ninety-</word>
					<word ordinal="90">Ninetieth </word>
					<word cardinal="100">Hundred-</word>
					<word ordinal="100">Hundredth </word>
				</words>
			</xsl:variable>

			<xsl:variable name="ordinal" select="xalan:nodeset($words)//word[@ordinal = $number]/text()"/>
			
			<xsl:variable name="value">
				<xsl:choose>
					<xsl:when test="$ordinal != ''">
						<xsl:value-of select="$ordinal"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="$number &lt; 100">
								<xsl:variable name="decade" select="concat(substring($number,1,1), '0')"/>
								<xsl:variable name="digit" select="substring($number,2)"/>
								<xsl:value-of select="xalan:nodeset($words)//word[@cardinal = $decade]/text()"/>
								<xsl:value-of select="xalan:nodeset($words)//word[@ordinal = $digit]/text()"/>
							</xsl:when>
							<xsl:otherwise>
								<!-- more 100 -->
								<xsl:variable name="hundred" select="substring($number,1,1)"/>
								<xsl:variable name="digits" select="number(substring($number,2))"/>
								<xsl:value-of select="xalan:nodeset($words)//word[@cardinal = $hundred]/text()"/>
								<xsl:value-of select="xalan:nodeset($words)//word[@cardinal = '100']/text()"/>
								<xsl:call-template name="number-to-words">
									<xsl:with-param name="number" select="$digits"/>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="$first = 'true'">
					<xsl:variable name="value_lc" select="java:toLowerCase(java:java.lang.String.new($value))"/>
					<xsl:call-template name="capitalize">
						<xsl:with-param name="str" select="$value_lc"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$value"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
 
</xsl:stylesheet>
