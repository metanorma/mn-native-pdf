<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
											xmlns:fo="http://www.w3.org/1999/XSL/Format"
											xmlns:mathml="http://www.w3.org/1998/Math/MathML" 
											xmlns:xalan="http://xml.apache.org/xalan"  
											xmlns:fox="http://xmlgraphics.apache.org/fop/extensions" 
											xmlns:java="http://xml.apache.org/xalan/java"
											exclude-result-prefixes="java"
											version="1.0">

	<xsl:choose>
		<xsl:when test="$namespace = 'bipm'">
			<xsl:strip-space elements="bipm:xref"/>
		</xsl:when>
		<xsl:when test="$namespace = 'bsi'">
			<xsl:strip-space elements="bsi:xref"/>
		</xsl:when>
		<xsl:when test="$namespace = 'csa'">
			<xsl:strip-space elements="csa:xref"/>
		</xsl:when>
		<xsl:when test="$namespace = 'csd'">
			<xsl:strip-space elements="csd:xref"/>
		</xsl:when>
		<xsl:when test="$namespace = 'gb'">
			<xsl:strip-space elements="gb:xref"/>
		</xsl:when>
		<xsl:when test="$namespace = 'iec'">
			<xsl:strip-space elements="iec:xref"/>
		</xsl:when>
		<xsl:when test="$namespace = 'ieee'">
			<xsl:strip-space elements="ieee:xref"/>
		</xsl:when>
		<xsl:when test="$namespace = 'iho'">
			<xsl:strip-space elements="iho:xref"/>
		</xsl:when>
		<xsl:when test="$namespace = 'iso'">
			<xsl:strip-space elements="iso:xref"/>
		</xsl:when>
		<xsl:when test="$namespace = 'itu'">
			<xsl:strip-space elements="itu:xref"/>
		</xsl:when>
		<xsl:when test="$namespace = 'jcgm'">
			<xsl:strip-space elements="jcgm:xref"/>
		</xsl:when>
		<xsl:when test="$namespace = 'jis'">
			<xsl:strip-space elements="jis:xref"/>
		</xsl:when>
		<xsl:when test="$namespace = 'm3d'">
			<xsl:strip-space elements="m3d:xref"/>
		</xsl:when>
		<xsl:when test="$namespace = 'mpfd'">
			<xsl:strip-space elements="mpfd:xref"/>
		</xsl:when>
		<xsl:when test="$namespace = 'nist-cswp' or $namespace = 'nist-sp'">
			<xsl:strip-space elements="nist:xref"/>
		</xsl:when>
		<xsl:when test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:strip-space elements="ogc:xref"/>
		</xsl:when>
		<xsl:when test="$namespace = 'rsd'">
			<xsl:strip-space elements="ribose:xref"/>
		</xsl:when>
		<xsl:when test="$namespace = 'unece' or $namespace = 'unece-rec'">
			<xsl:strip-space elements="un:xref"/>
		</xsl:when>
	</xsl:choose>


	<!-- external parameters -->
	
	<xsl:param name="svg_images"/> <!-- svg images array -->
	<xsl:variable name="images" select="document($svg_images)"/>
	<xsl:param name="basepath"/> <!-- base path for images -->
	<xsl:param name="external_index" /><!-- path to index xml, generated on 1st pass, based on FOP Intermediate Format -->
	<xsl:param name="syntax-highlight">false</xsl:param> <!-- syntax highlighting feature, default - off -->
	<xsl:param name="add_math_as_text">true</xsl:param> <!-- add math in text behind svg formula, to copy-paste formula from PDF as text -->
  
	<xsl:param name="table_if">false</xsl:param> <!-- generate extended table in IF for autolayout-algorithm -->
	<xsl:param name="table_widths" /> <!-- path to xml with table's widths, generated on 1st pass, based on FOP Intermediate Format -->
	<!-- Example: <tables>
			<table id="table_if_tab-symdu" page-width="75"> - table id prefixed by 'table_if_' to simple search in IF 
				<tbody>
					<tr>
						<td id="tab-symdu_1_1">
							<p_len>6</p_len>
							<p_len>100</p_len>  for 2nd paragraph
							<word_len>6</word_len>
							<word_len>20</word_len>
						...
	-->
	
	<!-- for command line debug: <xsl:variable name="table_widths_from_if" select="document($table_widths)"/> -->
	<xsl:variable name="table_widths_from_if" select="xalan:nodeset($table_widths)"/> 
	
	
	<xsl:variable name="table_widths_from_if_calculated_">
		<xsl:for-each select="$table_widths_from_if//table">
			<xsl:copy>
				<xsl:copy-of select="@*"/>
				<xsl:call-template name="calculate-column-widths-autolayout-algorithm"/>
			</xsl:copy>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="table_widths_from_if_calculated" select="xalan:nodeset($table_widths_from_if_calculated_)"/>
	
	
	<xsl:param name="table_if_debug">false</xsl:param> <!-- set 'true' to put debug width data before table or dl -->

	<xsl:variable name="isApplyAutolayoutAlgorithm_">
		<xsl:choose>
			<xsl:when test="$namespace = 'bipm' or $namespace = 'bsi' or $namespace = 'csa' or $namespace = 'csd' or $namespace = 'iec' or $namespace = 'ieee' or $namespace = 'iho' or $namespace = 'iso' or $namespace = 'itu' or $namespace = 'jcgm' or $namespace = 'jis' or $namespace = 'm3d' or $namespace = 'mpfd' or $namespace = 'nist-sp' or $namespace = 'nist-cswp' or $namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'rsd' or $namespace = 'unece' or $namespace = 'unece-rec'">true</xsl:when>
			<xsl:otherwise>false</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="isApplyAutolayoutAlgorithm" select="normalize-space($isApplyAutolayoutAlgorithm_)"/>

	<xsl:variable name="isGenerateTableIF_">
		<xsl:choose>
			<xsl:when test="$isApplyAutolayoutAlgorithm = 'true'">
				<xsl:value-of select="normalize-space($table_if) = 'true'"/>
			</xsl:when>
			<xsl:otherwise>false</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="isGenerateTableIF" select="normalize-space($isGenerateTableIF_)"/>

	<xsl:variable name="lang">
		<xsl:call-template name="getLang"/>
	</xsl:variable>

	<!-- Note 1: Each xslt has declated variable `namespace` that allows to set some properties, processing logic, etc. for concrete xslt.
	You can put such conditions by using xslt construction `xsl:if test="..."` or <xsl:choose><xsl:when test=""></xsl:when><xsl:otherwiste></xsl:otherwiste></xsl:choose>,
	BUT DON'T put any another conditions together with $namespace = '...' (such conditions will be ignored). For another conditions, please use nested xsl:if or xsl:choose -->
	
	<!--
	<metanorma-extension>
		<presentation-metadata>
			<papersize>letter</papersize>
		</presentation-metadata>
	</metanorma-extension>
	-->
	
	<xsl:variable name="papersize" select="java:toLowerCase(java:java.lang.String.new(normalize-space(//*[contains(local-name(), '-standard')]/*[local-name() = 'metanorma-extension']/*[local-name() = 'presentation-metadata']/*[local-name() = 'papersize'])))"/>
	<xsl:variable name="papersize_width_">
		<xsl:choose>
			<xsl:when test="$papersize = 'letter'">215.9</xsl:when>
			<xsl:when test="$papersize = 'a4'">210</xsl:when>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="papersize_width" select="normalize-space($papersize_width_)"/>
	<xsl:variable name="papersize_height_">
		<xsl:choose>
			<xsl:when test="$papersize = 'letter'">279.4</xsl:when>
			<xsl:when test="$papersize = 'a4'">297</xsl:when>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="papersize_height" select="normalize-space($papersize_height_)"/>
	
	<!-- page width in mm -->
	<xsl:variable name="pageWidth_">
		<xsl:choose>
			<xsl:when test="$papersize_width != ''"><xsl:value-of select="$papersize_width"/></xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$namespace = 'csa' or $namespace = 'ieee' or $namespace = 'm3d' or $namespace = 'nist-cswp' or $namespace = 'nist-sp' or 
					$namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'rsd'">215.9</xsl:when> <!-- paper size letter -->
					<xsl:otherwise>210</xsl:otherwise> <!-- paper size A4 (default value) -->
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="pageWidth" select="normalize-space($pageWidth_)"/>
	
	<!-- page height in mm -->
	<xsl:variable name="pageHeight_">
		<xsl:choose>
			<xsl:when test="$papersize_height != ''"><xsl:value-of select="$papersize_height"/></xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$namespace = 'csa' or $namespace = 'ieee' or $namespace = 'm3d' or $namespace = 'nist-cswp' or $namespace = 'nist-sp' or 
					$namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'rsd'">279.4</xsl:when> <!-- paper size letter -->
					<xsl:otherwise>297</xsl:otherwise> <!-- paper size A4 (default value) -->
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="pageHeight" select="normalize-space($pageHeight_)"/>
	
	<!-- Page margins in mm (just digits, without 'mm')-->
	<!-- marginLeftRight1 and marginLeftRight2 - is left or right margin depends on odd/even page,
	for example, left margin on odd page and right margin on even page -->
	<xsl:variable name="marginLeftRight1_">
		<xsl:choose>
			<xsl:when test="$namespace = 'bipm'">31.7</xsl:when>
			<xsl:when test="$namespace = 'bsi'">15</xsl:when>
			<xsl:when test="$namespace = 'csa'">25</xsl:when>
			<xsl:when test="$namespace = 'csd'">19</xsl:when>
			<xsl:when test="$namespace = 'gb'">25</xsl:when>
			<xsl:when test="$namespace = 'iec'">25</xsl:when>
			<xsl:when test="$namespace = 'ieee'">31.7</xsl:when>
			<xsl:when test="$namespace = 'iho'">24.5</xsl:when>
			<xsl:when test="$namespace = 'iso'">
				<xsl:choose>
					<xsl:when test="$layoutVersion2024 = 'true'">18.7</xsl:when>
					<xsl:otherwise>25</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$namespace = 'itu'">20</xsl:when>
			<xsl:when test="$namespace = 'jcgm'">25</xsl:when>
			<xsl:when test="$namespace = 'jis'">22</xsl:when>
			<xsl:when test="$namespace = 'm3d'">17.3</xsl:when>
			<xsl:when test="$namespace = 'mpfd'">19</xsl:when>
			<xsl:when test="$namespace = 'nist-cswp' or $namespace = 'nist-sp'">25.4</xsl:when>
			<xsl:when test="$namespace = 'ogc'">35</xsl:when>
			<xsl:when test="$namespace = 'ogc-white-paper'">25.4</xsl:when>
			<xsl:when test="$namespace = 'rsd'">29</xsl:when>
			<xsl:when test="$namespace = 'unece'">40</xsl:when>
			<xsl:when test="$namespace = 'unece-rec'">40</xsl:when>
			<xsl:otherwise>25.4</xsl:otherwise> <!-- default value for page's left margin -->
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="marginLeftRight1" select="normalize-space($marginLeftRight1_)"/>
	

	<xsl:variable name="marginLeftRight2_">
		<xsl:choose>
			<xsl:when test="$namespace = 'bipm'">40</xsl:when>
			<xsl:when test="$namespace = 'bsi'">22</xsl:when>
			<xsl:when test="$namespace = 'csa'">25</xsl:when>
			<xsl:when test="$namespace = 'csd'">19</xsl:when>
			<xsl:when test="$namespace = 'gb'">20</xsl:when>
			<xsl:when test="$namespace = 'iec'">25</xsl:when>
			<xsl:when test="$namespace = 'ieee'">31.7</xsl:when>
			<xsl:when test="$namespace = 'iho'">25</xsl:when>
			<xsl:when test="$namespace = 'iso'">
				<xsl:choose>
					<xsl:when test="$layoutVersion2024 = 'true'">18.7</xsl:when>
					<xsl:otherwise>12.5</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$namespace = 'itu'">20</xsl:when>
			<xsl:when test="$namespace = 'jcgm'">15</xsl:when>
			<xsl:when test="$namespace = 'jis'">22</xsl:when>
			<xsl:when test="$namespace = 'm3d'">17.3</xsl:when>
			<xsl:when test="$namespace = 'mpfd'">19</xsl:when>
			<xsl:when test="$namespace = 'nist-cswp' or $namespace = 'nist-sp'">25.4</xsl:when>
			<xsl:when test="$namespace = 'ogc'">17</xsl:when>
			<xsl:when test="$namespace = 'ogc-white-paper'">25.4</xsl:when>
			<xsl:when test="$namespace = 'rsd'">29</xsl:when>
			<xsl:when test="$namespace = 'unece'">40</xsl:when>
			<xsl:when test="$namespace = 'unece-rec'">40</xsl:when>
			<xsl:otherwise>25.4</xsl:otherwise> <!-- default value for page's right margin -->
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="marginLeftRight2" select="normalize-space($marginLeftRight2_)"/>
	
	<xsl:variable name="marginTop_">
		<xsl:choose>
			<xsl:when test="$namespace = 'bipm'">25.4</xsl:when>
			<xsl:when test="$namespace = 'bsi'">27</xsl:when>
			<xsl:when test="$namespace = 'csa'">25</xsl:when>
			<xsl:when test="$namespace = 'csd'">20.2</xsl:when>
			<xsl:when test="$namespace = 'gb'">35</xsl:when>
			<xsl:when test="$namespace = 'iec'">31</xsl:when>
			<xsl:when test="$namespace = 'ieee'">25.4</xsl:when>
			<xsl:when test="$namespace = 'iho'">25.4</xsl:when>
			<xsl:when test="$namespace = 'iso'">27.4</xsl:when>
			<xsl:when test="$namespace = 'itu'">20</xsl:when>
			<xsl:when test="$namespace = 'jcgm'">29.5</xsl:when>
			<xsl:when test="$namespace = 'jis'">30</xsl:when>
			<xsl:when test="$namespace = 'm3d'">35</xsl:when>
			<xsl:when test="$namespace = 'mpfd'">16.5</xsl:when>
			<xsl:when test="$namespace = 'nist-cswp' or $namespace = 'nist-sp'">25.4</xsl:when>
			<xsl:when test="$namespace = 'ogc'">16.5</xsl:when>
			<xsl:when test="$namespace = 'ogc-white-paper'">25.4</xsl:when>
			<xsl:when test="$namespace = 'rsd'">14</xsl:when>
			<xsl:when test="$namespace = 'unece'">30</xsl:when>
			<xsl:when test="$namespace = 'unece-rec'">30</xsl:when>
			<xsl:otherwise>25.4</xsl:otherwise> <!-- default value for page's top margin -->
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="marginTop" select="normalize-space($marginTop_)"/>
	
	<xsl:variable name="marginBottom_">
		<xsl:choose>
			<xsl:when test="$namespace = 'bipm'">22</xsl:when>
			<xsl:when test="$namespace = 'bsi'">22</xsl:when>
			<xsl:when test="$namespace = 'csa'">21</xsl:when>
			<xsl:when test="$namespace = 'csd'">20.3</xsl:when>
			<xsl:when test="$namespace = 'gb'">20</xsl:when>
			<xsl:when test="$namespace = 'iec'">15</xsl:when>
			<xsl:when test="$namespace = 'ieee'">25.4</xsl:when>
			<xsl:when test="$namespace = 'iho'">25.4</xsl:when>
			<xsl:when test="$namespace = 'iso'">
				<xsl:choose>
					<xsl:when test="$layoutVersion2024 = 'true'">25.5</xsl:when>
					<xsl:otherwise>15</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$namespace = 'itu'">20</xsl:when>
			<xsl:when test="$namespace = 'jcgm'">23.5</xsl:when>
			<xsl:when test="$namespace = 'jis'">24.5</xsl:when>
			<xsl:when test="$namespace = 'm3d'">23</xsl:when>
			<xsl:when test="$namespace = 'mpfd'">10</xsl:when>
			<xsl:when test="$namespace = 'nist-cswp' or $namespace = 'nist-sp'">25.4</xsl:when>
			<xsl:when test="$namespace = 'ogc'">22.5</xsl:when>
			<xsl:when test="$namespace = 'ogc-white-paper'">25.4</xsl:when>
			<xsl:when test="$namespace = 'rsd'">22</xsl:when>
			<xsl:when test="$namespace = 'unece'">40</xsl:when>
			<xsl:when test="$namespace = 'unece-rec'">34</xsl:when>
			<xsl:otherwise>25.4</xsl:otherwise> <!-- default value for page's bottom margin -->
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="marginBottom" select="normalize-space($marginBottom_)"/>
	
	<!-- Note 2: almost all localized string determined in the element //localized-strings in metanorma xml, but there are a few cases when:
	 - string didn't determined yet
	 - we need to put the string on two-languages (for instance, on English and French both), but xml contains only localized strings for one language
	 - there is a difference between localized string value and text that should be displayed in PDF
	-->
	<xsl:variable name="titles_">
		
		
		<!-- These titles of Table of contents renders different than determined in localized-strings -->
		<!-- <title-toc lang="en">
			<xsl:if test="$namespace = 'csd' or $namespace = 'ieee' or $namespace = 'iho' or $namespace = 'mpfd' or $namespace = 'ogc' or $namespace = 'unece-rec'">
				<xsl:text>Contents</xsl:text>
			</xsl:if>
			<xsl:if test="$namespace = 'csa' or $namespace = 'm3d' or $namespace = 'nist-sp' or $namespace = 'ogc-white-paper'">
				<xsl:text>Table of Contents</xsl:text>
			</xsl:if>
			<xsl:if test="$namespace = 'gb'">
				<xsl:text>Table of contents</xsl:text>
			</xsl:if>
		</title-toc> -->
		<title-toc lang="en">Table of contents</title-toc>
		<!-- <title-toc lang="fr">
			<xsl:text>Sommaire</xsl:text>
		</title-toc> -->
		<!-- <title-toc lang="zh">
			<xsl:choose>
				<xsl:when test="$namespace = 'gb'">
					<xsl:text>目次</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Contents</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</title-toc> -->
		<title-toc lang="zh">目次</title-toc>
		
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
		<title-part lang="ru">
			<xsl:if test="$namespace = 'iso'">
				<xsl:text>Часть #:</xsl:text>
			</xsl:if>
			<xsl:if test="$namespace = 'iec'">
				<xsl:text>Часть #:  </xsl:text>
			</xsl:if>
		</title-part>
		<title-part lang="zh">第 # 部分:</title-part>
		
		<title-subpart lang="en">Sub-part #</title-subpart>
		<title-subpart lang="fr">Partie de sub #</title-subpart>
		
	</xsl:variable>
	<xsl:variable name="titles" select="xalan:nodeset($titles_)"/>
	
	<xsl:variable name="title-list-tables">
		<xsl:variable name="toc_table_title" select="//*[contains(local-name(), '-standard')]/*[local-name() = 'metanorma-extension']/*[local-name() = 'toc'][@type='table']/*[local-name() = 'title']"/>
		<xsl:value-of select="$toc_table_title"/>
		<xsl:if test="normalize-space($toc_table_title) = ''">
			<xsl:call-template name="getLocalizedString">
				<xsl:with-param name="key">toc_tables</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:variable>
	
	<xsl:variable name="title-list-figures">
		<xsl:variable name="toc_figure_title" select="//*[contains(local-name(), '-standard')]/*[local-name() = 'metanorma-extension']/*[local-name() = 'toc'][@type='figure']/*[local-name() = 'title']"/>
		<xsl:value-of select="$toc_figure_title"/>
		<xsl:if test="normalize-space($toc_figure_title) = ''">
			<xsl:call-template name="getLocalizedString">
				<xsl:with-param name="key">toc_figures</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:variable>
	
	<xsl:variable name="title-list-recommendations">
		<xsl:variable name="toc_requirement_title" select="//*[contains(local-name(), '-standard')]/*[local-name() = 'metanorma-extension']/*[local-name() = 'toc'][@type='requirement']/*[local-name() = 'title']"/>
		<xsl:value-of select="$toc_requirement_title"/>
		<xsl:if test="normalize-space($toc_requirement_title) = ''">
			<xsl:call-template name="getLocalizedString">
				<xsl:with-param name="key">toc_recommendations</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:variable>

	<xsl:variable name="bibdata">
		<xsl:copy-of select="//*[contains(local-name(), '-standard')]/*[local-name() = 'bibdata']" />
		<xsl:copy-of select="//*[contains(local-name(), '-standard')]/*[local-name() = 'localized-strings']" />
	</xsl:variable>
	
	<!-- Characters -->
	<xsl:variable name="linebreak">&#x2028;</xsl:variable>
	<xsl:variable name="tab_zh">&#x3000;</xsl:variable>
	<xsl:variable name="non_breaking_hyphen">&#x2011;</xsl:variable>
	<xsl:variable name="thin_space">&#x2009;</xsl:variable>	
	<xsl:variable name="zero_width_space">&#x200B;</xsl:variable>
	<xsl:variable name="hair_space">&#x200A;</xsl:variable>
	<xsl:variable name="en_dash">&#x2013;</xsl:variable>
	
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
	
	
	
	<!-- ====================================== -->
	<!-- STYLES -->
	<!-- ====================================== -->
	<xsl:variable name="font_noto_sans">Noto Sans, Noto Sans HK, Noto Sans JP, Noto Sans KR, Noto Sans SC, Noto Sans TC</xsl:variable>
	<xsl:variable name="font_noto_sans_mono">Noto Sans Mono, Noto Sans Mono CJK HK, Noto Sans Mono CJK JP, Noto Sans Mono CJK KR, Noto Sans Mono CJK SC, Noto Sans Mono CJK TC</xsl:variable>
	<xsl:variable name="font_noto_serif">Noto Serif, Noto Serif HK, Noto Serif JP, Noto Serif KR, Noto Serif SC, Noto Serif TC</xsl:variable>
	<xsl:attribute-set name="root-style">
		<xsl:if test="$namespace = 'bipm' or $namespace = 'jcgm'">
			<xsl:attribute name="font-family">Times New Roman, STIX Two Math, <xsl:value-of select="$font_noto_serif"/></xsl:attribute>
			<xsl:attribute name="font-family-generic">Serif</xsl:attribute>
			<xsl:attribute name="font-size">10.5pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="font-family">Cambria, Times New Roman, Cambria Math, <xsl:value-of select="$font_noto_serif"/></xsl:attribute>
			<xsl:attribute name="font-family-generic">Serif</xsl:attribute>
			<xsl:attribute name="font-size">10pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="font-family">Azo Sans, STIX Two Math, <xsl:value-of select="$font_noto_sans"/></xsl:attribute>
			<xsl:attribute name="font-family-generic">Sans</xsl:attribute>
			<xsl:attribute name="font-size">10pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csd'">
			<xsl:attribute name="font-family"><xsl:value-of select="$font_noto_sans"/>, STIX Two Math</xsl:attribute>
			<xsl:attribute name="font-family-generic">Sans</xsl:attribute>
			<xsl:attribute name="font-size">10.5pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="font-family">SimSun</xsl:attribute>
			<xsl:attribute name="font-family-generic">Sans</xsl:attribute>
			<xsl:attribute name="font-size">10.5pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="font-family">Arial, Times New Roman, STIX Two Math, <xsl:value-of select="$font_noto_sans"/></xsl:attribute>
			<xsl:attribute name="font-family-generic">Sans</xsl:attribute>
			<xsl:attribute name="font-size">10pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="font-family">Times New Roman, STIX Two Math, <xsl:value-of select="$font_noto_serif"/></xsl:attribute>
			<xsl:attribute name="font-family-generic">Serif</xsl:attribute>
			<xsl:attribute name="font-size">10pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="font-family">Arial, Cambria Math, <xsl:value-of select="$font_noto_sans"/></xsl:attribute>
			<xsl:attribute name="font-family-generic">Sans</xsl:attribute>
			<xsl:attribute name="font-size">10pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="font-family">Cambria, Times New Roman, Cambria Math, <xsl:value-of select="$font_noto_serif"/></xsl:attribute>
			<xsl:attribute name="font-family-generic">Serif</xsl:attribute>
			<xsl:attribute name="font-size">11pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="font-family">Times New Roman, STIX Two Math, <xsl:value-of select="$font_noto_serif"/></xsl:attribute>
			<xsl:attribute name="font-family-generic">Serif</xsl:attribute>
			<xsl:attribute name="font-size">12pt</xsl:attribute>
		</xsl:if>
    <xsl:if test="$namespace = 'jis'">
			<xsl:attribute name="font-family">IPAexMincho, STIX Two Math, <xsl:value-of select="$font_noto_serif"/></xsl:attribute>
			<xsl:attribute name="font-family-generic">Serif</xsl:attribute>
			<xsl:attribute name="font-size">10pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'm3d'">
			<xsl:attribute name="font-family">EB Garamond 12, <xsl:value-of select="$font_noto_sans"/></xsl:attribute>
			<xsl:attribute name="font-family-generic">Sans</xsl:attribute>
			<xsl:attribute name="font-size">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'mpfd'">
			<xsl:attribute name="font-family">Arial, <xsl:value-of select="$font_noto_sans"/></xsl:attribute>
			<xsl:attribute name="font-family-generic">Sans</xsl:attribute>
			<xsl:attribute name="font-size">10.5pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp' or $namespace = 'nist-sp'">
			<xsl:attribute name="font-family">Times New Roman, STIX Two Math, <xsl:value-of select="$font_noto_serif"/></xsl:attribute>
			<xsl:attribute name="font-family-generic">Serif</xsl:attribute>
			<xsl:attribute name="font-size">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="font-family">Lato, STIX Two Math, <xsl:value-of select="$font_noto_sans"/></xsl:attribute>
			<xsl:attribute name="font-family-generic">Sans</xsl:attribute>
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="color"><xsl:value-of select="$color_main"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:attribute name="font-family">Arial, STIX Two Math, <xsl:value-of select="$font_noto_sans"/></xsl:attribute>
			<xsl:attribute name="font-family-generic">Sans</xsl:attribute>
			<xsl:attribute name="font-size">11pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-family">OpenSans, STIX Two Math, <xsl:value-of select="$font_noto_sans"/></xsl:attribute>
			<xsl:attribute name="font-family-generic">Sans</xsl:attribute>
			<xsl:attribute name="font-weight">300</xsl:attribute>
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="color">rgb(88, 88, 90)</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece' or $namespace = 'unece-rec'">
			<xsl:attribute name="font-family">Times New Roman, STIX Two Math, <xsl:value-of select="$font_noto_serif"/></xsl:attribute>
			<xsl:attribute name="font-family-generic">Serif</xsl:attribute>
			<xsl:attribute name="font-size">10pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- root-style -->
		
	<xsl:template name="insertRootStyle">
		<xsl:param name="root-style"/>
		<xsl:variable name="root-style_" select="xalan:nodeset($root-style)"/>
		
		<xsl:variable name="additional_fonts_">
			<xsl:for-each select="//*[contains(local-name(), '-standard')][1]/*[local-name() = 'metanorma-extension']/*[local-name() = 'presentation-metadata'][*[local-name() = 'name'] = 'fonts']/*[local-name() = 'value'] | 
					//*[contains(local-name(), '-standard')][1]/*[local-name() = 'presentation-metadata'][*[local-name() = 'name'] = 'fonts']/*[local-name() = 'value']">
				<xsl:value-of select="."/><xsl:if test="position() != last()">, </xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="additional_fonts" select="normalize-space($additional_fonts_)"/>
		
		<xsl:variable name="font_family_generic" select="$root-style_/root-style/@font-family-generic"/>
		
		<xsl:for-each select="$root-style_/root-style/@*">
		
			<xsl:choose>
				<xsl:when test="local-name() = 'font-family-generic'"><!-- skip, it's using for determine 'sans' or 'serif' --></xsl:when>
				<xsl:when test="local-name() = 'font-family'">
				
					<xsl:variable name="font_regional_prefix">
						<xsl:choose>
							<xsl:when test="$font_family_generic = 'Sans'">Noto Sans</xsl:when>
							<xsl:otherwise>Noto Serif</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
				
					<xsl:attribute name="{local-name()}">
					
						<xsl:variable name="font_extended">
							<xsl:choose>
								<xsl:when test="$lang = 'zh'"><xsl:value-of select="$font_regional_prefix"/> SC</xsl:when>
								<xsl:when test="$lang = 'hk'"><xsl:value-of select="$font_regional_prefix"/> HK</xsl:when>
								<xsl:when test="$lang = 'jp'"><xsl:value-of select="$font_regional_prefix"/> JP</xsl:when>
								<xsl:when test="$lang = 'kr'"><xsl:value-of select="$font_regional_prefix"/> KR</xsl:when>
								<xsl:when test="$lang = 'sc'"><xsl:value-of select="$font_regional_prefix"/> SC</xsl:when>
								<xsl:when test="$lang = 'tc'"><xsl:value-of select="$font_regional_prefix"/> TC</xsl:when>
							</xsl:choose>
						</xsl:variable>
						<xsl:if test="normalize-space($font_extended) != ''">
							<xsl:value-of select="$font_regional_prefix"/><xsl:text>, </xsl:text>
							<xsl:value-of select="$font_extended"/><xsl:text>, </xsl:text>
						</xsl:if>
						
						<xsl:variable name="font_family" select="."/>
						
						<xsl:choose>
							<xsl:when test="$additional_fonts = ''">
								<xsl:value-of select="$font_family"/>
							</xsl:when>
							<xsl:otherwise> <!-- $additional_fonts != '' -->
								<xsl:choose>
									<xsl:when test="contains($font_family, ',')">
										<xsl:value-of select="substring-before($font_family, ',')"/>
										<xsl:text>, </xsl:text><xsl:value-of select="$additional_fonts"/>
										<xsl:text>, </xsl:text><xsl:value-of select="substring-after($font_family, ',')"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$font_family"/>
										<xsl:text>, </xsl:text><xsl:value-of select="$additional_fonts"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
		
			<!-- <xsl:choose>
				<xsl:when test="local-name() = 'font-family'">
					<xsl:attribute name="{local-name()}">
						<xsl:value-of select="."/>, <xsl:value-of select="$additional_fonts"/>
					</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="."/>
				</xsl:otherwise>
			</xsl:choose> -->
		</xsl:for-each>
	</xsl:template> <!-- insertRootStyle -->
	
	<!-- Preface sections styles -->
	<xsl:attribute-set name="copyright-statement-style">
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="font-size">8pt</xsl:attribute>
			<xsl:attribute name="line-height">125%</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- copyright-statement-style -->
	
	<xsl:attribute-set name="copyright-statement-title-style">
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="color"><xsl:value-of select="$color_blue"/></xsl:attribute>
			<xsl:attribute name="margin-top">24pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:attribute name="font-family">Lato</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- copyright-statement-title-style -->
	
	<xsl:attribute-set name="copyright-statement-p-style">
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="space-after">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:attribute name="text-align">left</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- copyright-statement-p-style -->
	
	
	<xsl:attribute-set name="license-statement-style">
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="font-family">Times New Roman</xsl:attribute>
			<xsl:attribute name="font-size">10.5pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="font-size">8pt</xsl:attribute>
			<xsl:attribute name="line-height">125%</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="license-statement-title-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="text-align">center</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-sp'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="color"><xsl:value-of select="$color_blue"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:attribute name="font-family">Lato</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="margin-top">4pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- license-statement-title-style -->
	
	<xsl:attribute-set name="license-statement-p-style">
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="text-align">justify</xsl:attribute>
			<xsl:attribute name="line-height">135%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="margin-left">1.5mm</xsl:attribute>
			<xsl:attribute name="margin-right">1.5mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:attribute name="font-size">8pt</xsl:attribute>
			<xsl:attribute name="margin-top">14pt</xsl:attribute>
			<xsl:attribute name="line-height">135%</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- license-statement-p-style -->
	
	
	<xsl:attribute-set name="legal-statement-style">
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="font-size">8pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
		</xsl:if>
		
	</xsl:attribute-set> <!-- legal-statement-style -->
	
	<xsl:attribute-set name="legal-statement-title-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp'">
			<xsl:attribute name="font-family">Arial</xsl:attribute>
			<xsl:attribute name="font-size">12pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="color"><xsl:value-of select="$color"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-sp'">
			<xsl:attribute name="font-family">Arial</xsl:attribute>
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:attribute name="font-family">Lato</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-weight">normal</xsl:attribute>
			<xsl:attribute name="padding-top">2mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- legal-statement-title-style -->
	
	<xsl:attribute-set name="legal-statement-p-style">
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:attribute name="text-align">left</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- legal-statement-p-style -->
	
	<xsl:attribute-set name="feedback-statement-style">
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="line-height">125%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="font-size">8pt</xsl:attribute>
			<xsl:attribute name="line-height">125%</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- feedback-statement-style -->
	
	<xsl:attribute-set name="feedback-statement-title-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- feedback-statement-title-style -->
	
	<xsl:attribute-set name="feedback-statement-p-style">
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- feedback-statement-p-style -->
	
	<!-- End Preface sections styles -->
		
	<xsl:attribute-set name="link-style">
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="color">rgb(58,88,168)</xsl:attribute>
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee' or $namespace = 'iso' or $namespace = 'csd' or $namespace = 'ogc-white-paper' or $namespace = 'm3d' or $namespace = 'iho' or $namespace = 'mpfd' or $namespace = 'bipm' or $namespace = 'jcgm'">
			<xsl:attribute name="color">blue</xsl:attribute>
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="color"><xsl:value-of select="$color_blue"/></xsl:attribute>
			<xsl:attribute name="font-weight">300</xsl:attribute><!-- bold -->
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="color">rgb(33, 94, 159)</xsl:attribute>
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>

	<xsl:template name="refine_link-style">
		<xsl:if test="$namespace = 'bsi'">
			<xsl:if test="$document_type = 'PAS'">
				<xsl:attribute name="color">inherit</xsl:attribute>
				<xsl:attribute name="text-decoration">none</xsl:attribute>
			</xsl:if>
			<xsl:if test="$doctype = 'flex-standard' and ancestor::*[local-name() = 'copyright-statement']">
				<xsl:attribute name="color"><xsl:value-of select="$color_secondary_shade_1_PAS"/></xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:if test="$current_template = 'whitepaper' or $current_template = 'icap-whitepaper' or $current_template = 'industry-connection-report'">
				<xsl:attribute name="color"><xsl:value-of select="$color_blue"/></xsl:attribute>
				<xsl:attribute name="text-decoration">none</xsl:attribute>
			</xsl:if>
			<xsl:if test="$current_template = 'standard'">
				<xsl:attribute name="color"><xsl:value-of select="$color_blue"/></xsl:attribute>
				<xsl:attribute name="text-decoration">none</xsl:attribute>
				<xsl:if test="ancestor::*[local-name() = 'feedback-statement']">
					<xsl:attribute name="text-decoration">underline</xsl:attribute>
				</xsl:if>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:if test="ancestor::*[local-name()='feedback-statement' or local-name() = 'copyright-statement']">
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
	</xsl:template> <!-- refine_link-style -->

	<xsl:attribute-set name="sourcecode-container-style">
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="space-after">12pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>

	<xsl:attribute-set name="sourcecode-style">
		<xsl:attribute name="white-space">pre</xsl:attribute>
		<xsl:attribute name="wrap-option">wrap</xsl:attribute>
		<xsl:attribute name="role">Code</xsl:attribute>
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="font-family">Courier New, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>			
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="font-family"><xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>			
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="line-height">113%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csd'">
			<xsl:attribute name="font-family"><xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>			
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>					
		</xsl:if>
		
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="font-family">Courier New, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>			
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="font-family">Courier New, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>			
			<xsl:attribute name="margin-top">5pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">5pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="font-family">Courier New, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>			
			<xsl:attribute name="margin-top">5pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">5pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="font-family">Fira Code, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>			
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="line-height">113%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="font-family">Courier New, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>			
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="font-family">Courier New, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>			
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jcgm'">
			<xsl:attribute name="font-family">Courier New, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>			
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'm3d'">
			<xsl:attribute name="font-family">Courier New, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>			
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>		
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="font-family">Fira Code, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>			
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>			
			<xsl:attribute name="line-height">113%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:attribute name="font-family">Courier New, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>			
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="line-height">113%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-family"><xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>			
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="line-height">113%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp' or $namespace = 'nist-sp'">
			<xsl:attribute name="font-family">Courier New, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>			
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece' or $namespace = 'unece-rec'">
			<xsl:attribute name="font-family">Courier New, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>			
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>

	<xsl:template name="refine_sourcecode-style">
		<xsl:if test="$namespace = 'rsd'"> <!-- background for image -->
			<xsl:if test="starts-with(*[local-name() = 'name']/text()[1], 'Figure ')">
				<xsl:attribute name="background-color">rgb(236,242,246)</xsl:attribute>
				<xsl:attribute name="padding-left">11mm</xsl:attribute>
				<xsl:attribute name="margin-left">0mm</xsl:attribute>
				<xsl:attribute name="padding-right">11mm</xsl:attribute>
				<xsl:attribute name="margin-right">0mm</xsl:attribute>
				<xsl:attribute name="padding-top">7.5mm</xsl:attribute>
				<xsl:attribute name="padding-bottom">7.5mm</xsl:attribute>
				<xsl:if test="following-sibling::*[1][local-name() = 'sourcecode'] and starts-with(*[local-name() = 'name']/text()[1], 'Figure ')">
					<xsl:attribute name="margin-bottom">16pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:if test="parent::*[local-name() = 'example']">
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template> <!-- refine_sourcecode-style -->

	<xsl:attribute-set name="pre-style">
		<xsl:attribute name="font-family">Courier New, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>
		<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="font-family"><xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>
			<xsl:attribute name="line-height">113%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csd'">
			<xsl:attribute name="font-family"><xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="margin-top">5pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">5pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="margin-top">5pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">5pt</xsl:attribute>
			<xsl:attribute name="font-size">95%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="font-family">Fira Code, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>
			<xsl:attribute name="line-height">113%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jcgm'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'm3d'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>		
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="font-family">Fira Code, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>
			<xsl:attribute name="line-height">113%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:attribute name="line-height">113%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-family"><xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>
			<xsl:attribute name="line-height">113%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp' or $namespace = 'nist-sp'">
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece' or $namespace = 'unece-rec'">
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
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
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>

	<xsl:attribute-set name="requirement-name-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>			
			<xsl:attribute name="margin-bottom">4pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>			
			<xsl:attribute name="padding-top">0.5mm</xsl:attribute>
			<xsl:attribute name="padding-bottom">1mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">1mm</xsl:attribute>
			<xsl:attribute name="background-color">rgb(165,165,165)</xsl:attribute>
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
	
	<xsl:attribute-set name="component-style">
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
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
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
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="margin-top">8pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
			<xsl:attribute name="text-align">justify</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho' or $namespace = 'iso' or $namespace = 'jcgm'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-top">8pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
			<xsl:attribute name="text-align">justify</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:attribute name="margin-top">4pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">4pt</xsl:attribute>
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
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'csd'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="margin-top">8pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
			<xsl:attribute name="text-align">justify</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb' or $namespace = 'iso' or $namespace = 'jcgm'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-top">8pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="space-before">8pt</xsl:attribute>
			<xsl:attribute name="space-after">8pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<!-- <xsl:attribute name="font-size">11pt</xsl:attribute> -->
			<xsl:attribute name="margin-top">4pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="text-align">justify</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:attribute name="margin-top">4pt</xsl:attribute>			
			<xsl:attribute name="margin-bottom">4pt</xsl:attribute>			
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
	</xsl:attribute-set> <!-- example-style -->

	<xsl:template name="refine_example-style">
		<xsl:if test="$namespace = 'rsd'">
			<xsl:if test="ancestor::ribose:ul or ancestor::ribose:ol">
				<xsl:attribute name="margin-top">6pt</xsl:attribute>
				<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template> <!-- refine_example-style -->

	<xsl:attribute-set name="example-body-style">
		<xsl:if test="$namespace = 'csa'">			
			<xsl:attribute name="margin-left">12.5mm</xsl:attribute>
			<xsl:attribute name="margin-right">12.5mm</xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'csd'">
			<xsl:attribute name="margin-left">12.5mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="margin-left">10mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">			
			<xsl:attribute name="margin-left">7mm</xsl:attribute>
			<xsl:attribute name="margin-right">7mm</xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'mpfd'">
			<xsl:attribute name="margin-left">12.5mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">18pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- example-body-style -->


	<xsl:attribute-set name="example-name-style">
		<xsl:if test="$namespace = 'csa'">			
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csd'">
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bsi' or $namespace = 'jcgm'">
			<xsl:attribute name="padding-right">5mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb' or $namespace = 'iso'">
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="padding-right">5mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="padding-right">9mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="padding-right">9mm</xsl:attribute>
			<xsl:attribute name="font-style">italic</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<!-- <xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute> -->
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:attribute name="font-family">IPAexGothic</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'm3d'">
			<xsl:attribute name="padding-right">5mm</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp'">
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>			
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-sp'">
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>			
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="color"><xsl:value-of select="$color_blue"/></xsl:attribute>
			<xsl:attribute name="padding-right">0.5mm</xsl:attribute>
		</xsl:if>		
		<xsl:if test="$namespace = 'unece' or $namespace = 'unece-rec'">
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>			
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>		
		
		<xsl:if test="$namespace = 'mpfd'">
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>			
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="font-style">italic</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- example-name-style -->

	<xsl:attribute-set name="example-p-style">
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="margin-bottom">14pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csd'">			
			<xsl:attribute name="margin-bottom">14pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb' or $namespace = 'iso' or $namespace = 'jcgm'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-top">8pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="margin-top">5pt</xsl:attribute>
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
		<xsl:if test="$namespace = 'jis'">
			<xsl:attribute name="margin-bottom">2pt</xsl:attribute>
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
		
	</xsl:attribute-set> <!-- example-p-style -->

	<xsl:template name="refine_example-p-style">
		<xsl:if test="$namespace = 'ieee'">
			<xsl:if test="not(preceding-sibling::*[local-name() = 'p'])">
				<xsl:attribute name="margin-top">6pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp' or $namespace = 'unece' or $namespace = 'unece-rec'">
			<xsl:variable name="num"><xsl:number/></xsl:variable>
			<xsl:if test="$num = 1">
				<xsl:attribute name="margin-left">5mm</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template> <!-- refine_example-p-style -->

	<xsl:attribute-set name="termexample-name-style">
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="font-style">italic</xsl:attribute>
		</xsl:if>
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
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="padding-right">9mm</xsl:attribute>
			<xsl:attribute name="font-style">italic</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:attribute name="font-family">IPAexGothic</xsl:attribute>
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
	</xsl:attribute-set> <!-- termexample-name-style -->

	<!-- ========================== -->
	<!-- Table styles -->
	<!-- ========================== -->
	<xsl:variable name="table-border_">
		<xsl:if test="$namespace = 'bsi'">0.5pt solid black</xsl:if>
		<xsl:if test="$namespace = 'ieee'">1pt solid black</xsl:if>
		<xsl:if test="$namespace = 'iho'">0.5pt solid black</xsl:if>
		<xsl:if test="$namespace = 'iso'">1pt solid black</xsl:if>
		<xsl:if test="$namespace = 'jis'">0.5pt solid black</xsl:if>
	</xsl:variable>
	<xsl:variable name="table-border" select="normalize-space($table-border_)"/>
	
	<xsl:variable name="table-cell-border_">
		<xsl:if test="$namespace = 'iso'">0.5pt solid black</xsl:if>
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
			<xsl:if test="not(ancestor::*[local-name()='note_side'])">
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
			<xsl:if test="$document_type != 'PAS' and *[local-name() = 'name']">
				<xsl:attribute name="margin-top">-14pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="not(*[local-name()='tbody']) and *[local-name()='thead']">
				<xsl:attribute name="margin-top">4pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="(ancestor::*[local-name() = 'preface'] and not(*[local-name() = 'tbody']))">
				<xsl:attribute name="margin-top">0pt</xsl:attribute>
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="$document_type = 'PAS'">
				<xsl:attribute name="font-size">9pt</xsl:attribute>
				<!-- two-columns table without name renders in column (not spanned) -->
				<xsl:choose>
					<xsl:when test="count(*[local-name()='colgroup']/*[local-name()='col']) = 2 and not(*[local-name() = 'name']) and not(*[local-name() = 'thead'])">
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
				<xsl:if test="not(*[local-name() = 'name']) and (ancestor::*[local-name()='clause'][@type = 'corrigenda'] or contains(ancestor::*[local-name()='clause'][1]/*[local-name()='title'], 'Amendments/corrigenda'))">
					<xsl:attribute name="margin-top">2pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$document_type != 'PAS' and not(following-sibling::*[2][@depth = '1']) and not (ancestor::*[local-name()='preface'] and (ancestor::*[local-name()='clause'][@type = 'corrigenda'] or contains(ancestor::*[local-name()='clause'][1]/*[local-name()='title'], 'Amendments/corrigenda')))">
				<xsl:attribute name="margin-bottom">24pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
	
		<xsl:if test="$namespace = 'iec'">
			<xsl:if test="ancestor::*[local-name() = 'preface']">
				<xsl:attribute name="space-after">16pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'ieee'">
			<xsl:if test="$current_template = 'whitepaper' or $current_template = 'icap-whitepaper' or $current_template = 'industry-connection-report'">
				<xsl:attribute name="font-size">10pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="ancestor::*[local-name() = 'feedback-statement']">
				<xsl:attribute name="font-size">inherit</xsl:attribute>
				<xsl:attribute name="margin-top">6pt</xsl:attribute>
				<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'iso'">
			<xsl:if test="not(*[local-name() = 'name'])">
				<xsl:attribute name="margin-top">12pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="starts-with(@id, 'array_')">
				<xsl:attribute name="margin-top">6pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'itu'">
			<xsl:if test="$doctype = 'service-publication' and $lang != 'ar'">
				<xsl:attribute name="font-family">Calibri</xsl:attribute>
			</xsl:if>
		</xsl:if>
	
		<xsl:if test="$namespace = 'nist-cswp'  or $namespace = 'nist-sp'">
			<xsl:if test="ancestor::*[local-name()='annex'] or ancestor::*[local-name()='preface']">
				<xsl:attribute name="font-size">10pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'ogc'">
			<!-- <xsl:if test="ancestor::*[local-name()='sections']"> -->
				<xsl:attribute name="font-size">9pt</xsl:attribute>
			<!-- </xsl:if> -->
		</xsl:if>
		
		<xsl:if test="$namespace = 'unece-rec'">
			<xsl:if test="not(ancestor::*[local-name()='sections'])">
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
			<xsl:if test="not(ancestor::*[local-name()='preface']) and not(ancestor::*[local-name()='note_side']) and not(ancestor::*[local-name() = 'annex'] and .//*[local-name() = 'xref'][@pagenumber]) and not(ancestor::*[local-name() = 'doccontrol'])">
				<xsl:attribute name="border-top">0.5pt solid black</xsl:attribute>
				<xsl:attribute name="border-bottom">0.5pt solid black</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'bsi'">
			<xsl:if test="$document_type != 'PAS'">
				<xsl:attribute name="border-bottom">2.5pt solid black</xsl:attribute>
			</xsl:if>
			<xsl:if test=".//*[local-name() = 'tr'][1]/*[local-name() = 'td'][normalize-space() = 'Key'] or
			normalize-space(substring-after(*[local-name() = 'name'], '—')) = 'Key' or 
			normalize-space(*[local-name() = 'name']) = 'Key'
			">
				<xsl:attribute name="border-bottom">none</xsl:attribute>
			</xsl:if>
			<xsl:if test="(ancestor::*[local-name()='preface'] and ancestor::*[local-name()='clause'][@type = 'corrigenda']) or
			(ancestor::*[local-name()='copyright-statement'] and contains(ancestor::*[local-name()='clause'][1]/*[local-name()='title'], 'Amendments/corrigenda'))">
				<xsl:if test="normalize-space(*[local-name() = 'tbody']) = ''">
					<xsl:attribute name="border-bottom">none</xsl:attribute>
				</xsl:if>
				<xsl:if test="$document_type != 'PAS'">
					<xsl:attribute name="border">none</xsl:attribute>
					<xsl:attribute name="border-top">none</xsl:attribute>
					<xsl:attribute name="border-bottom">none</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="ancestor::*[local-name() = 'preface']">
				<xsl:attribute name="border">0pt solid black</xsl:attribute>
				<xsl:attribute name="border-top">0pt solid black</xsl:attribute>
			</xsl:if>
			<xsl:if test="$document_type = 'PAS'">
				<xsl:if test="ancestor::*[local-name()='preface'] and ancestor::*[local-name()='clause'][@type = 'logos']">
					<xsl:attribute name="border-bottom">none</xsl:attribute>
				</xsl:if>
				<!-- two-columns table without name renders without borders -->
				<xsl:if test="count(*[local-name()='colgroup']/*[local-name()='col']) = 2 and not(*[local-name() = 'name']) and not(*[local-name() = 'thead'])">
					<xsl:attribute name="border-bottom">none</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="ancestor::*[local-name() = 'table']">
				<!-- for internal table in table cell -->
				<xsl:attribute name="border"><xsl:value-of select="$table-border"/></xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'ieee'">
			<xsl:if test="$current_template = 'whitepaper' or $current_template = 'icap-whitepaper' or $current_template = 'industry-connection-report'">
				<xsl:attribute name="border">0.5 solid black</xsl:attribute>
			</xsl:if>
			<xsl:if test="ancestor::*[local-name() = 'feedback-statement']">
				<xsl:attribute name="border">none</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'iso'">
			<xsl:if test="*[local-name()='thead']">
				<xsl:attribute name="border-top"><xsl:value-of select="$table-border"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="ancestor::*[local-name() = 'table']">
				<!-- for internal table in table cell -->
				<xsl:attribute name="border"><xsl:value-of select="$table-cell-border"/></xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:call-template name="setBordersTableArray"/>
		
		<xsl:if test="$namespace = 'itu'">
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
			<xsl:if test="ancestor::*[local-name()='preface']">
				<xsl:attribute name="border">none</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'unece-rec'">
			<xsl:if test="ancestor::*[local-name()='sections']">
				<xsl:attribute name="border-top">1.5pt solid black</xsl:attribute>
				<xsl:attribute name="border-bottom">1.5pt solid black</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template> <!-- refine_table-style -->
	
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
			<xsl:attribute name="font-family">IPAexGothic</xsl:attribute>
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
			<xsl:if test="../@unnumbered = 'true' and (ancestor::*[@type = 'corrigenda'] or contains(ancestor::*[local-name()='clause'][1]/*[local-name()='title'], 'Amendments/corrigenda'))">
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
			<xsl:attribute name="background-color">rgb(33, 55, 92)</xsl:attribute>
			<xsl:attribute name="color">white</xsl:attribute>
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
			<xsl:if test="ancestor::*[local-name() = 'preface']">
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
			<xsl:if test="$doctype = 'service-publication'">
				<xsl:attribute name="border-bottom">1.1pt solid black</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'jis'">
			<xsl:if test="ancestor::*[local-name() = 'preface']">
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
			<xsl:if test="position() = 1 and $document_type != 'PAS' and not(ancestor::*[local-name() = 'table'][1]/*[local-name() = 'thead'])">
				<!-- set border for 1st row if thead is missing -->
				<xsl:attribute name="border-top">2.5pt solid black</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="ancestor::*[local-name() = 'preface'] or ancestor::*[local-name() = 'boilerplate']">
				<xsl:attribute name="border-top">none</xsl:attribute>
				<xsl:attribute name="border-bottom">none</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="$document_type = 'PAS'">
				<xsl:variable name="number"><xsl:number/></xsl:variable>
				<xsl:attribute name="background-color">
					<xsl:choose>
						<xsl:when test="ancestor::*[local-name()='clause'][@type = 'corrigenda' or contains(*[local-name()='title'], 'Amendments/corrigenda')]">transparent</xsl:when>
						<xsl:when test="preceding::*[local-name() = 'foreword' or local-name() = 'introduction']">
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
				<xsl:if test="ancestor::*[local-name()='clause'][@type = 'corrigenda' or contains(*[local-name()='title'], 'Amendments/corrigenda')] and not(following-sibling::*[local-name() = 'tr'])">
					<xsl:attribute name="border-bottom">2pt solid <xsl:value-of select="$color_secondary_shade_1_PAS"/></xsl:attribute>
				</xsl:if>
			</xsl:if>
		</xsl:if>
	
		<xsl:if test="$namespace = 'ieee'">
			<xsl:if test="ancestor::*[local-name() = 'feedback-statement']">
				<xsl:attribute name="min-height">0mm</xsl:attribute>
			</xsl:if>
		</xsl:if>
	
		<xsl:if test="$namespace = 'iso'">
			<xsl:if test="position() = 1 and not(ancestor::*[local-name() = 'table']/*[local-name() = 'thead']) and ancestor::*[local-name() = 'table']/*[local-name() = 'name']">
				<xsl:attribute name="border-top"><xsl:value-of select="$table-border"/></xsl:attribute>
			</xsl:if>
		</xsl:if>
	
		<xsl:call-template name="setBordersTableArray"/>
	
		<xsl:if test="$namespace = 'ogc'">
			<xsl:variable name="number"><xsl:number/></xsl:variable>
			<xsl:attribute name="background-color">
				<xsl:choose>
					<xsl:when test="$number mod 2 = 0">rgb(252, 246, 222)</xsl:when>
					<xsl:otherwise>rgb(254, 252, 245)</xsl:otherwise>
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
			<xsl:if test="(ancestor::*[local-name() = 'annex'] and ancestor::*[local-name() = 'table']//*[local-name() = 'xref'][@pagenumber]) or ancestor::*[local-name() = 'doccontrol']"><!-- for Annex ToC -->
				<xsl:attribute name="border-top">solid black 0pt</xsl:attribute>
				<xsl:attribute name="border-bottom">solid black 0pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="ancestor::*[local-name() = 'doccontrol']">
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
			<xsl:if test="ancestor::*[local-name() = 'preface'] or ancestor::*[local-name() = 'boilerplate']">
				<xsl:attribute name="font-weight">normal</xsl:attribute>
				<xsl:attribute name="text-align">left</xsl:attribute>
				<xsl:if test="$document_type != 'PAS'">
					<xsl:attribute name="border">solid black 0pt</xsl:attribute>
				</xsl:if>
				<xsl:if test="ancestor::*[local-name()='clause'][@type = 'corrigenda' or contains(*[local-name()='title'], 'Amendments/corrigenda')]">
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
						
						<xsl:if test="not(ancestor::bsi:clause[@type = 'corrigenda' or contains(*[local-name()='title'], 'Amendments/corrigenda')] and ancestor::bsi:thead)">
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
			<xsl:if test="ancestor::*[local-name()='preface']">
				<xsl:attribute name="font-weight">normal</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:if test="../parent::*[local-name() = 'tbody'] and (following-sibling::*[local-name() = 'td'] or preceding-sibling::*[local-name() = 'td'])">
				<xsl:attribute name="border-top"><xsl:value-of select="$table-cell-border"/></xsl:attribute>
				<xsl:attribute name="border-bottom"><xsl:value-of select="$table-cell-border"/></xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'jis'">
			<xsl:attribute name="text-align">center</xsl:attribute>
		</xsl:if>
		
		<xsl:call-template name="setBordersTableArray"/>
		
		<xsl:if test="$namespace = 'itu'">
			<xsl:if test="ancestor::*[local-name()='preface']">
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
			<xsl:if test="ancestor::*[local-name()='preface']">
				<xsl:attribute name="border">none</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'nist-cswp' or $namespace = 'nist-sp'">
			<xsl:attribute name="text-align">center</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:if test="starts-with(ancestor::*[local-name() = 'table'][1]/@type, 'recommend') and normalize-space(@align) = ''">
				<xsl:call-template name="setTextAlignment">
					<xsl:with-param name="default">left</xsl:with-param>
				</xsl:call-template>
			</xsl:if>
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
		</xsl:if>
		
		<xsl:if test="$lang = 'ar'">
			<xsl:attribute name="padding-right">1mm</xsl:attribute>
		</xsl:if>
		
		<xsl:call-template name="setTableCellAttributes"/>
		
		<xsl:if test="$namespace = 'bsi'">
			<xsl:if test="$document_type = 'PAS'">
				<xsl:if test="ancestor::bsi:clause[@type = 'corrigenda' or contains(*[local-name()='title'], 'Amendments/corrigenda')] and ancestor::bsi:thead">
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
			<xsl:if test="not(ancestor::*[local-name()='tr']/following-sibling::*[local-name()='tr'])"> <!-- last row -->
				<xsl:attribute name="padding-bottom">2mm</xsl:attribute>
			</xsl:if>
			<xsl:if test="ancestor::*[local-name() = 'doccontrol']">
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
			(ancestor::*[local-name() = 'table'][1]//*[local-name() = 'tr'][1]/*[local-name() = 'td'][normalize-space() = 'Key'] or
			normalize-space(substring-after(ancestor::*[local-name() = 'table'][1]/*[local-name() = 'name'], '—')) = 'Key' or 
			normalize-space(ancestor::*[local-name() = 'table'][1]/*[local-name() = 'name']) = 'Key')">
				<xsl:attribute name="border">none</xsl:attribute>
				
				<xsl:if test="count(*) = 1 and local-name(*[1]) = 'figure'">
					<xsl:attribute name="padding-top">0.5mm</xsl:attribute>
					<xsl:attribute name="padding-left">0mm</xsl:attribute>
					<xsl:attribute name="padding-bottom">0mm</xsl:attribute>
					<xsl:attribute name="padding-right">0mm</xsl:attribute>
				</xsl:if>
			</xsl:if>
			
			<xsl:if test="(ancestor::*[local-name()='preface'] and ancestor::*[local-name()='clause'][@type = 'corrigenda']) or
			(ancestor::*[local-name()='copyright-statement'] and contains(ancestor::*[local-name()='clause'][1]/*[local-name()='title'], 'Amendments/corrigenda'))">
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
			
			<xsl:if test="starts-with(ancestor::*[local-name() = 'table']/@id, 'boxed-text')">
				<xsl:attribute name="padding-left">2mm</xsl:attribute>
				<xsl:attribute name="padding-right">2mm</xsl:attribute>
				<xsl:attribute name="padding-top">4mm</xsl:attribute>
				<xsl:attribute name="padding-bottom">4mm</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="ancestor::*[local-name() = 'tfoot']">
				<xsl:attribute name="border">solid black 0</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="$document_type = 'PAS'">
				<xsl:attribute name="border">0.75pt solid <xsl:value-of select="$color_secondary_shade_1_PAS"/></xsl:attribute>
				<!-- two-columns table without name renders without borders -->
				<xsl:if test="ancestor::*[local-name() = 'table'][count(*[local-name()='colgroup']/*[local-name()='col']) = 2 and not(*[local-name() = 'name']) and not(*[local-name() = 'thead'])]">
					<xsl:attribute name="border">none</xsl:attribute>
				</xsl:if>
			</xsl:if>
			
			<xsl:if test="ancestor::*[local-name()='preface'] and ancestor::*[local-name()='clause'][@type = 'logos']">
				<xsl:attribute name="border">none</xsl:attribute>
			</xsl:if>
			
		</xsl:if> <!-- bsi -->
		
		<xsl:if test="$namespace = 'gb'">
			<xsl:if test="ancestor::*[local-name() = 'tfoot']">
				<xsl:attribute name="border-bottom">solid black 0</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'iec'">
			<xsl:if test="ancestor::*[local-name()='preface']">
				<xsl:attribute name="text-align">center</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'ieee'">
			<xsl:if test="ancestor::*[local-name() = 'feedback-statement']">
				<xsl:attribute name="padding-left">0mm</xsl:attribute>
				<xsl:attribute name="padding-top">0mm</xsl:attribute>
				<xsl:attribute name="padding-right">0mm</xsl:attribute>
				<xsl:attribute name="border">none</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'iso'">
			<xsl:if test="ancestor::*[local-name() = 'tfoot']">
				<xsl:attribute name="border">solid black 0</xsl:attribute>
			</xsl:if>
			<xsl:if test="starts-with(ancestor::*[local-name() = 'table'][1]/@type, 'recommend')">
				<xsl:attribute name="display-align">before</xsl:attribute>
			</xsl:if>
			<xsl:if test="ancestor::*[local-name() = 'tbody'] and not(../preceding-sibling::*[local-name() = 'tr']) and ancestor::*[local-name() = 'table'][1]/*[local-name() = 'thead']"> <!-- cells in 1st row in the table body, and if thead exists -->
				<xsl:attribute name="border-top">0pt solid black</xsl:attribute>
			</xsl:if>
			<!-- <xsl:attribute name="page-break-inside">avoid</xsl:attribute> -->
		</xsl:if>
		
		<xsl:call-template name="setBordersTableArray"/>
		
		<xsl:if test="$namespace = 'itu'">
			<xsl:if test="ancestor::*[local-name()='preface']">
				<xsl:attribute name="border">solid black 0pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="$doctype = 'service-publication'">
				<xsl:attribute name="border">1pt solid rgb(211,211,211)</xsl:attribute>
				<xsl:attribute name="padding-top">1mm</xsl:attribute>
			</xsl:if>
		</xsl:if>

		<xsl:if test="$namespace = 'jcgm'">
			<xsl:if test="count(*) = 1 and (local-name(*[1]) = 'stem' or local-name(*[1]) = 'figure')">
				<xsl:attribute name="padding-left">0mm</xsl:attribute>
			</xsl:if>
			<xsl:if test="ancestor::*[local-name() = 'tfoot']">
				<xsl:attribute name="border">solid black 0</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'jis'">
			<xsl:if test="ancestor::*[local-name() = 'preface']">
				<xsl:attribute name="border">none</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'nist-cswp'  or $namespace = 'nist-sp'">
			<xsl:if test="ancestor::*[local-name()='thead']">
				<xsl:attribute name="font-weight">normal</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'unece-rec'">
			<xsl:if test="ancestor::*[local-name()='sections']">
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

		<xsl:if test="$namespace = 'itu'">
			<xsl:if test="ancestor::*[local-name()='preface']">
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
	</xsl:attribute-set><!-- table-note-style -->
	
	<xsl:template name="refine_table-note-style">
		<xsl:if test="$namespace = 'bipm'">					
			<xsl:if test="ancestor::bipm:preface">
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
	</xsl:attribute-set> <!-- table-fn-style -->
	
	<xsl:attribute-set name="table-fn-number-style">
		<xsl:attribute name="font-size">80%</xsl:attribute>
		<xsl:attribute name="padding-right">5mm</xsl:attribute>
		<xsl:if test="$namespace = 'csd'">
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="baseline-shift">30%</xsl:attribute>
			<xsl:attribute name="font-size">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="font-style">italic</xsl:attribute>
			<xsl:attribute name="padding-right">2.5mm</xsl:attribute>
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
			<xsl:attribute name="padding-right">3mm</xsl:attribute>
			<xsl:attribute name="font-size">70%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:attribute name="font-family">Times New Roman</xsl:attribute>
			<xsl:attribute name="font-size">67%</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
			<xsl:attribute name="padding-right">0mm</xsl:attribute>
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
		<xsl:if test="$namespace = 'unece' or $namespace = 'unece-rec'">
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- table-fn-number-style -->
	
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
		<xsl:attribute name="font-size">80%</xsl:attribute>
		<xsl:attribute name="padding-right">5mm</xsl:attribute>
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
	</xsl:attribute-set>
	
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
	
	<!-- ========================== -->
	<!-- Definition's list styles -->
	<!-- ========================== -->
	
	<xsl:attribute-set name="dl-block-style">
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="dt-row-style">
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="min-height">8.5mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="min-height">7mm</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="dt-cell-style">
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="padding-top">0.5mm</xsl:attribute>
			<xsl:attribute name="padding-right">5mm</xsl:attribute>
			<xsl:attribute name="padding-left">1mm</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:template name="refine_dt-cell-style">
		<xsl:if test="$namespace = 'itu'">
			<xsl:if test="ancestor::*[1][local-name() = 'dl']/preceding-sibling::*[1][local-name() = 'formula']">						
				<xsl:attribute name="padding-right">3mm</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:if test="not(ancestor::ogc:sourcecode)">
				<!-- <xsl:attribute name="border-left">1pt solid <xsl:value-of select="$color_design"/></xsl:attribute> -->
				<xsl:attribute name="background-color"><xsl:value-of select="$color_dl_dt"/></xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template> <!-- refine_dt-cell-style -->
	
	<xsl:attribute-set name="dt-block-style">
		<xsl:attribute name="margin-top">0pt</xsl:attribute>
		<xsl:if test="$namespace = 'csd'">
			<xsl:attribute name="margin-left">7mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="margin-left">2mm</xsl:attribute>
			<xsl:attribute name="line-height">1.2</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:attribute name="line-height">1.5</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp' or $namespace = 'nist-sp'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="color"><xsl:value-of select="$color_blue"/></xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:template name="refine_dt-block-style">
		<xsl:if test="$namespace = 'itu'">
			<xsl:if test="ancestor::*[1][local-name() = 'dl']/preceding-sibling::*[1][local-name() = 'formula']">
				<xsl:attribute name="text-align">right</xsl:attribute>							
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:if test="ancestor::ogc:sourcecode">
				<xsl:attribute name="margin-bottom">2pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="not(following-sibling::ogc:dt)"> <!-- last dt -->
				<xsl:attribute name="margin-bottom">0</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template> <!-- refine_dt-block-style -->

	
	<xsl:attribute-set name="dl-name-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		<xsl:if test="$namespace = 'bsi'">
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
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="font-famuily">Arial</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="font-weight">normal</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso' or $namespace = 'jcgm'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>		
		<xsl:if test="$namespace = 'nist-cswp'  or $namespace = 'nist-sp'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">							
			<xsl:attribute name="font-weight">normal</xsl:attribute>
			<xsl:attribute name="color"><xsl:value-of select="$color_blue"/></xsl:attribute>
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
	</xsl:attribute-set> <!-- dl-name-style -->
	
	<xsl:attribute-set name="dd-cell-style">
		<xsl:attribute name="padding-left">2mm</xsl:attribute>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="padding-top">0.5mm</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:template name="refine_dd-cell-style">
		<xsl:if test="$namespace = 'ogc'">
			<xsl:if test="not(ancestor::ogc:sourcecode)">
				<xsl:attribute name="background-color"><xsl:value-of select="$color_dl_dd"/></xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template> <!-- refine_dd-cell-style -->

	
	<!-- ========================== -->
	<!-- END Definition's list styles -->
	<!-- ========================== -->
	
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
		<xsl:if test="$namespace = 'ieee' or $namespace = 'iho' or $namespace = 'iso' or $namespace = 'itu' or $namespace = 'nist-cswp'  or $namespace = 'nist-sp' or $namespace = 'ogc-white-paper' or $namespace = 'mpfd' or $namespace = 'jcgm'">
			<xsl:attribute name="color">blue</xsl:attribute>
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:attribute name="font-family">IPAexGothic</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
		</xsl:if>
	</xsl:attribute-set>

	<xsl:attribute-set name="eref-style">
		<xsl:if test="$namespace = 'bsi'">
			<!-- <xsl:attribute name="color">rgb(58,88,168)</xsl:attribute>
			<xsl:attribute name="text-decoration">underline</xsl:attribute> -->
		</xsl:if>
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="color">rgb(33, 94, 159)</xsl:attribute>
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csd' or $namespace = 'ieee' or $namespace = 'itu' or $namespace = 'ogc-white-paper' or $namespace = 'mpfd'">
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

	<xsl:template name="refine_eref-style">
		<xsl:variable name="citeas" select="java:replaceAll(java:java.lang.String.new(@citeas),'^\[?(.+?)\]?$','$1')"/> <!-- remove leading and trailing brackets -->
		<xsl:variable name="text" select="normalize-space()"/>
		<xsl:if test="$namespace = 'bsi'">
			<xsl:if test="not($ids/id = current()/@bibitemid) or $document_type = 'PAS' or not(contains($citeas, $text))"> <!-- if reference can't be resolved or PAS document -->
				<xsl:attribute name="color">inherit</xsl:attribute>
				<xsl:attribute name="text-decoration">none</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:if test="$current_template = 'whitepaper' or $current_template = 'icap-whitepaper' or $current_template = 'industry-connection-report'">
				<xsl:attribute name="color"><xsl:value-of select="$color_blue"/></xsl:attribute>
				<xsl:attribute name="text-decoration">none</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template> <!-- refine_eref-style -->

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
			<xsl:if test="parent::*[local-name() = 'li']">
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
				<xsl:if test="following-sibling::*[1][local-name() = 'clause' or local-name() = 'term']">
					<xsl:attribute name="space-after">12pt</xsl:attribute>
					<xsl:if test="following-sibling::*[2][local-name() = 'title']/@depth = 2">
						<xsl:attribute name="space-after">24pt</xsl:attribute>
					</xsl:if>
				</xsl:if>
				<!-- note inside p or ul or ul : p/note ul/note ol/note -->
				<xsl:if test="parent::*[local-name() = 'p' or local-name() = 'ul' or local-name() = 'ol'] and not(following-sibling::*)">
					<xsl:if test="../following-sibling::*[1][local-name() = 'clause' or local-name() = 'term']">
						<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
						<xsl:if test="../following-sibling::*[2][local-name() = 'title']/@depth = 2">
							<xsl:attribute name="margin-bottom">24pt</xsl:attribute>
						</xsl:if>
					</xsl:if>
				</xsl:if>
				<!-- if 1st note -->
				<xsl:if test="parent::bsi:figure and preceding-sibling::*[1][self::bsi:image]">
					<xsl:attribute name="space-before">0pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$document_type != 'PAS'">
				<xsl:attribute name="text-align">justify</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'iso'">
			<xsl:if test="$doctype = 'amendment' and parent::*[local-name() = 'quote']">
				<xsl:attribute name="font-size">inherit</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:if test="ancestor::ogc:ul or ancestor::ogc:ol and not(ancestor::ogc:note[1]/following-sibling::*)">
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'rsd'">
			<xsl:if test="ancestor::ribose:ul or ancestor::ribose:ol and not(ancestor::ribose:note[1]/following-sibling::*)">
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
			<xsl:attribute name="font-family">IPAexGothic</xsl:attribute>
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
			<xsl:variable name="name" select="normalize-space(*[local-name() = 'name'])" />
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
			<xsl:if test="ancestor::bipm:preface">
				<xsl:attribute name="text-decoration">underline</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'bsi'">
			<xsl:if test="$document_type = 'PAS'">
				<xsl:attribute name="padding-right">1mm</xsl:attribute>
				<!-- <xsl:attribute name="font-style">italic</xsl:attribute> -->
			</xsl:if>
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
						<xsl:for-each select="ancestor::*[local-name() = 'term']/*[local-name() = 'name']">
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
			<xsl:if test="$doctype = 'amendment' and parent::*[local-name() = 'quote']">
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
			<xsl:attribute name="font-family">IPAexGothic</xsl:attribute>
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
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="padding-right">0mm</xsl:attribute>
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

	<xsl:attribute-set name="quote-style">
		<xsl:attribute name="margin-left">12mm</xsl:attribute>
		<xsl:attribute name="margin-right">12mm</xsl:attribute>
		<xsl:if test="$namespace = 'csa' or $namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'rsd'">
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-left">13mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bsi' or $namespace = 'csd' or $namespace = 'gb' or $namespace = 'iso' or $namespace = 'm3d'">
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jcgm'">
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="font-style">italic</xsl:attribute>
			<xsl:attribute name="text-align">justify</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="margin-top">5pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">10pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">			
			<xsl:attribute name="font-family">Calibri</xsl:attribute>
			<xsl:attribute name="margin-left">4.5mm</xsl:attribute>
			<xsl:attribute name="margin-right">9mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:attribute name="margin-left">0mm</xsl:attribute>
			<xsl:attribute name="margin-right">0mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'mpfd'">
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="text-align">justify</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:template name="refine_quote-style">
		<xsl:if test="$namespace = 'iso'">
			<xsl:if test="$doctype = 'amendment' and (*[local-name() = 'note'] or *[local-name() = 'termnote'])">
				<xsl:attribute name="margin-left">7mm</xsl:attribute>
				<xsl:attribute name="margin-right">0mm</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'jcgm'">
			<xsl:if test="ancestor::*[local-name() = 'boilerplate']">
				<xsl:attribute name="margin-left">7mm</xsl:attribute>
				<xsl:attribute name="margin-right">7mm</xsl:attribute>
				<xsl:attribute name="font-style">normal</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:if test="ancestor::*[local-name() = 'li']">
				<xsl:attribute name="margin-left">7.5mm</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	
	<xsl:attribute-set name="quote-source-style">		
		<xsl:attribute name="text-align">right</xsl:attribute>
		<xsl:if test="$namespace = 'csa' or $namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'rsd'">
			<xsl:attribute name="margin-right">25mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
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
		<xsl:if test="$namespace = 'jis'">
			<xsl:attribute name="margin-left">6mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:template name="refine_termsource-style">
		<xsl:if test="$namespace = 'bsi'">
			<xsl:if test="$document_type = 'PAS'">
				<xsl:attribute name="text-align">left</xsl:attribute>
				<xsl:attribute name="space-before">12pt</xsl:attribute>
				<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template> <!-- refine_termsource-style -->
	
	<xsl:attribute-set name="termsource-text-style">
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="color"><xsl:value-of select="$color_blue"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="padding-right">1mm</xsl:attribute>
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
		<xsl:if test="$namespace = 'jis'">
			<xsl:attribute name="space-before">12pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="term-name-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:if test="$namespace = 'jis'">
			<xsl:attribute name="font-family">Times New Roman</xsl:attribute>
			<xsl:attribute name="space-after">2pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>

	<xsl:attribute-set name="figure-block-style">
		<xsl:attribute name="role">SKIP</xsl:attribute>
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csd'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="space-after">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jcgm'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-sp' or $namespace = 'nist-cswp'">
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'm3d'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'mpfd'">
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece' or $namespace = 'unece-rec'">
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>

	<xsl:attribute-set name="figure-style">
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
	</xsl:attribute-set>

	<xsl:attribute-set name="figure-name-style">
		<xsl:attribute name="role">Caption</xsl:attribute>
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">left</xsl:attribute>			
			<xsl:attribute name="margin-left">19mm</xsl:attribute>
			<xsl:attribute name="text-indent">-19mm</xsl:attribute>
		</xsl:if>
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
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="space-after">6pt</xsl:attribute>
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="font-family">Arial</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="space-after">6pt</xsl:attribute>
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
		</xsl:if>		
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="color"><xsl:value-of select="$color_blue"/></xsl:attribute>
			<!-- <xsl:attribute name="margin-top">12pt</xsl:attribute> -->
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="space-after">12pt</xsl:attribute>
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
			<xsl:attribute name="space-after">6pt</xsl:attribute>
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csd' or $namespace = 'iec' or $namespace = 'iso' or $namespace = 'jcgm'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="space-after">12pt</xsl:attribute>
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="font-family">SimHei</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="space-after">12pt</xsl:attribute>
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<!-- <xsl:attribute name="font-size">11pt</xsl:attribute> -->
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-top">2pt</xsl:attribute>
			<xsl:attribute name="space-after">6pt</xsl:attribute>
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu' or $namespace = 'nist-sp'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="space-after">6pt</xsl:attribute>
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:attribute name="font-family">IPAexGothic</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="space-after">6pt</xsl:attribute>
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'm3d'">
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="space-after">12pt</xsl:attribute>
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
			<xsl:attribute name="space-after">6pt</xsl:attribute>
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece-rec'">
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="font-size">9pt</xsl:attribute>
			<xsl:attribute name="space-after">6pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="keep-together.within-column">always</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'mpfd'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="space-after">6pt</xsl:attribute>
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
		</xsl:if>	
	</xsl:attribute-set>
	
	<xsl:template name="refine_figure-name-style">
		<xsl:if test="$namespace = 'nist-cswp'  or $namespace = 'nist-sp'">
			<xsl:if test="nist:dl">
				<xsl:attribute name="space-before">12pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'bsi'">
			<xsl:if test="count(ancestor::*[local-name() = 'figure']) &gt; 1">
				<xsl:attribute name="margin-left">0mm</xsl:attribute>
				<xsl:if test="$document_type != 'PAS'">
					<!-- for sub-figures -->
					<xsl:attribute name="font-style">normal</xsl:attribute>
					<xsl:attribute name="font-size">9pt</xsl:attribute>
					<xsl:attribute name="space-before">2pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$document_type = 'PAS'">
				<xsl:attribute name="margin-left">0mm</xsl:attribute>
				<xsl:attribute name="font-size">11pt</xsl:attribute>
				<xsl:attribute name="font-style">normal</xsl:attribute>
			</xsl:if>
			<xsl:if test="../@width = 'full-page-width' or ../*[local-name() = 'figure']/@width = 'full-page-width'">
				<xsl:attribute name="margin-left">0mm</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'ieee'">
			<xsl:if test="$current_template = 'whitepaper' or $current_template = 'icap-whitepaper' or $current_template = 'industry-connection-report'">
				<xsl:attribute name="font-size">inherit</xsl:attribute>
				<xsl:attribute name="font-family">Arial Black</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'jis'">
			<xsl:if test="ancestor::jis:figure">
				<xsl:attribute name="margin-top">0</xsl:attribute>
				<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template> <!-- refine_figure-name-style -->
	
	<xsl:attribute-set name="figure-source-style">
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="font-size">6pt</xsl:attribute>
			<xsl:attribute name="font-style">italic</xsl:attribute>
			<xsl:attribute name="text-align">right</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<!-- Formula's styles -->
	<xsl:attribute-set name="formula-style">
		<xsl:attribute name="margin-top">6pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="margin-top">14pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">14pt</xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'm3d'">
			<xsl:attribute name="margin-top">14pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">14pt</xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp'">
			<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-sp'">
			<xsl:attribute name="margin-top">0pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- formula-style -->
	
	<xsl:attribute-set name="formula-stem-block-style">
		<xsl:attribute name="text-align">center</xsl:attribute>
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="text-align">left</xsl:attribute>
			<xsl:attribute name="margin-left">5mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="text-align">left</xsl:attribute>
			<xsl:attribute name="margin-left">5mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csd'">
			<xsl:attribute name="text-align">left</xsl:attribute>
			<xsl:attribute name="margin-left">5mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="text-align">center</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="text-align">left</xsl:attribute>
			<xsl:attribute name="margin-left">1mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="text-align">left</xsl:attribute>
			<xsl:attribute name="margin-left">5mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="margin-left">0mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jcgm'">
			<xsl:attribute name="text-align">left</xsl:attribute>
			<xsl:attribute name="margin-left">25mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-sp'">
			<xsl:attribute name="margin-left">7mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="text-align">left</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:attribute name="text-align">left</xsl:attribute>
			<xsl:attribute name="margin-left">5mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="text-align">left</xsl:attribute>
			<xsl:attribute name="margin-left">5mm</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- formula-stem-block-style -->
	
	<xsl:template name="refine_formula-stem-block-style">
		<xsl:if test="$namespace = 'nist-cswp' or $namespace = 'unece' or $namespace = 'unece-rec'">
			<xsl:if test="ancestor::*[local-name() ='annex']">
				<xsl:attribute name="text-align">left</xsl:attribute>
				<xsl:attribute name="margin-left">7mm</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template> <!-- refine_formula-stem-block-style -->

	
	<xsl:attribute-set name="formula-stem-number-style">
		<xsl:attribute name="text-align">right</xsl:attribute>
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="text-align">left</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="margin-right">-10mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="margin-left">0mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jcgm'">
		</xsl:if>
		<xsl:if test="$namespace = 'm3d'">
			<xsl:attribute name="text-align">left</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- formula-stem-number-style -->
	<!-- End Formula's styles -->
	
	<xsl:template name="refine_formula-stem-number-style">
		<xsl:if test="$namespace = 'iec'">
			<xsl:if test="ancestor::*[local-name() = 'table']">
				<xsl:attribute name="margin-right">0mm</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	
	<xsl:attribute-set name="image-style">
		<xsl:attribute name="role">SKIP</xsl:attribute>
		<xsl:attribute name="text-align">center</xsl:attribute>
		<xsl:if test="$namespace = 'bsi'">
			
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
			<xsl:attribute name="text-indent">0</xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'unece-rec'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>			
		</xsl:if>
	</xsl:attribute-set>

	<xsl:template name="refine_image-style">
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
	</xsl:template>


	<xsl:attribute-set name="figure-pseudocode-p-style">
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>

 
	
	<xsl:attribute-set name="image-graphic-style">
		<xsl:attribute name="width">100%</xsl:attribute>
		<xsl:attribute name="content-height">100%</xsl:attribute>
		<xsl:attribute name="scaling">uniform</xsl:attribute>			
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="content-width">scale-to-fit</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa' or $namespace = 'csd' or $namespace = 'ieee' or $namespace = 'iho' or $namespace = 'iso' or 
											$namespace = 'ogc' or $namespace = 'ogc-white-paper' or
											$namespace = 'rsd' or 
											$namespace = 'unece-rec' or 
											$namespace = 'mpfd' or $namespace = 'bipm' or $namespace = 'jcgm'">
			<xsl:attribute name="content-height">scale-to-fit</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb' or $namespace = 'm3d' or $namespace = 'unece'">
			<xsl:attribute name="content-width">scale-to-fit</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="width">75%</xsl:attribute>
			<xsl:attribute name="content-height">scale-to-fit</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu' or $namespace = 'nist-cswp' or $namespace = 'nist-sp'">
			<xsl:attribute name="width">75%</xsl:attribute>
			<xsl:attribute name="content-width">scale-to-fit</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="tt-style">
		<xsl:if test="$namespace = 'csa' or $namespace = 'csd' or $namespace = 'rsd'">
			<xsl:attribute name="font-family"><xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'bsi' or $namespace = 'gb' or $namespace = 'iec' or $namespace = 'iho' or $namespace = 'iso' or $namespace = 'm3d' or 
										 $namespace = 'ogc-white-paper' or $namespace = 'jcgm'">
			<xsl:attribute name="font-family">Courier New, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>			
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="font-family">Fira Code, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>			
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

	<xsl:attribute-set name="preferred-block-style">
		<xsl:if test="$namespace = 'csd'">
			<xsl:attribute name="line-height">1.1</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="line-height">1.1</xsl:attribute>
			<xsl:attribute name="space-before">14pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="line-height">1.1</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="line-height">1.1</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jcgm'">
			<xsl:attribute name="line-height">1.1</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
		</xsl:if>
	</xsl:attribute-set>

	<xsl:attribute-set name="preferred-term-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="line-height">1</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:attribute name="line-height">1</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:attribute name="font-weight">normal</xsl:attribute>
			<xsl:attribute name="font-family">IPAexGothic</xsl:attribute>
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
		<xsl:if test="$namespace = 'jis'">
			<xsl:attribute name="space-before">2pt</xsl:attribute>
			<xsl:attribute name="space-after">2pt</xsl:attribute>
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
		<xsl:choose>
			<xsl:when test="$namespace = 'bsi'">
				<xsl:attribute name="font-style">italic</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="color">red</xsl:attribute>
				<xsl:attribute name="text-decoration">underline</xsl:attribute>
				<!-- <xsl:attribute name="color">black</xsl:attribute>
				<xsl:attribute name="background-color"><xsl:value-of select="$color-added-text"/></xsl:attribute>
				<xsl:attribute name="padding-top">1mm</xsl:attribute>
				<xsl:attribute name="padding-bottom">0.5mm</xsl:attribute> -->
			</xsl:otherwise>
		</xsl:choose>
	</xsl:attribute-set>
  
	<xsl:variable name="add-style">
			<add-style xsl:use-attribute-sets="add-style"/>
		</xsl:variable>
	<xsl:template name="append_add-style">
		<xsl:copy-of select="xalan:nodeset($add-style)/add-style/@*"/>
	</xsl:template>

	<xsl:variable name="color-deleted-text">
		<xsl:text>red</xsl:text>
	</xsl:variable>
	<xsl:attribute-set name="del-style">
		<xsl:attribute name="color"><xsl:value-of select="$color-deleted-text"/></xsl:attribute>
		<xsl:attribute name="text-decoration">line-through</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="mathml-style">
		<xsl:attribute name="font-family">STIX Two Math</xsl:attribute>
		<xsl:if test="$namespace = 'bsi' or $namespace = 'iso' or $namespace = 'jcgm' or $namespace = 'm3d'">
			<xsl:attribute name="font-family">Cambria Math</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:template name="refine_mathml-style">
		<xsl:if test="$namespace = 'bipm'">
			<xsl:if test="ancestor::*[local-name()='table']">
				<xsl:attribute name="font-size">95%</xsl:attribute> <!-- base font in table is 10pt -->
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-sp'">
			<xsl:if test="ancestor::*[local-name()='table']">
				<xsl:attribute name="font-size">10pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	
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
			<xsl:if test="ancestor::csd:ol">
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			</xsl:if>
		</xsl:if>		
		<xsl:if test="$namespace = 'iec'">
			<xsl:if test="ancestor::iec:ul or ancestor::iec:ol">
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:if test="not(ancestor::*[local-name() = 'ul' or local-name() = 'ol'])">
				<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-sp'">
			<xsl:if test="ancestor::nist:figure and not(following-sibling::*)">
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
			<xsl:attribute name="color"><xsl:value-of select="$color_blue"/></xsl:attribute>
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
			<xsl:if test="$document_type = 'PAS' and not(ancestor::*[local-name() = 'note' or local-name() = 'termnote'])">
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
				<xsl:if test=".//ieee:fn">
					<xsl:attribute name="line-height">1.4</xsl:attribute>
				</xsl:if>
			</xsl:if>
		</xsl:if>
	
		<xsl:if test="$namespace = 'jis'">
			<xsl:if test="parent::*[local-name() = 'ol']">
				<xsl:attribute name="font-family">Times New Roman</xsl:attribute>
				<xsl:attribute name="font-weight">bold</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template> <!-- refine_list-item-label-style -->

	
	<xsl:attribute-set name="list-item-body-style">
		<xsl:if test="$namespace = 'csa'">
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
			<xsl:if test="*[last()][local-name() = 'note']">
				<xsl:attribute name="margin-bottom">5pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="margin-bottom">10pt</xsl:attribute>
			<xsl:if test="ancestor::ogc:table[not(@class)]">
				<xsl:attribute name="margin-bottom">1mm</xsl:attribute>
			</xsl:if>
			<xsl:if test="not(following-sibling::*) and not(../following-sibling::*)">
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template> <!-- refine_list-item-body-style -->

	
	<xsl:attribute-set name="toc-style">
		<xsl:attribute name="line-height">135%</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="fn-reference-style">
		<xsl:attribute name="font-size">80%</xsl:attribute>
		<xsl:attribute name="keep-with-previous.within-line">always</xsl:attribute>
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="font-size">70%</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
			<xsl:attribute name="font-style">italic</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="font-size">50%</xsl:attribute>
			<xsl:attribute name="font-weight">normal</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="vertical-align">super</xsl:attribute>
			<xsl:attribute name="color">blue</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:attribute name="font-family">Times New Roman</xsl:attribute>
			<xsl:attribute name="font-size">67%</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp' or $namespace = 'nist-sp'">
			<xsl:attribute name="vertical-align">super</xsl:attribute>
			<xsl:attribute name="color">blue</xsl:attribute>
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:attribute name="vertical-align">super</xsl:attribute>
			<xsl:attribute name="color">blue</xsl:attribute>
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-size">70%</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
			<xsl:attribute name="font-style">italic</xsl:attribute>
		</xsl:if>
		
	</xsl:attribute-set>
	
	<xsl:template name="refine_fn-reference-style">
		<xsl:if test="$namespace = 'bsi'">
			<xsl:if test="ancestor::*[local-name()='table'] or ancestor::*[local-name()='table']">
				<xsl:attribute name="font-weight">normal</xsl:attribute>
				<xsl:attribute name="baseline-shift">25%</xsl:attribute>
				<xsl:attribute name="font-size">5.5pt</xsl:attribute>
				<xsl:if test="$document_type = 'PAS'">
					<xsl:attribute name="font-size">4.5pt</xsl:attribute>
					<xsl:attribute name="padding-left">0.5mm</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="preceding-sibling::*[1][local-name() = 'fn']">,&#xa0;</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'iso' or $namespace = 'iec' or $namespace = 'jcgm'">
			<xsl:if test="ancestor::*[local-name()='table']">
				<xsl:attribute name="font-weight">normal</xsl:attribute>
				<xsl:attribute name="baseline-shift">15%</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template> <!-- refine_fn-reference-style -->
	
	<xsl:attribute-set name="fn-style">
		<xsl:attribute name="keep-with-previous.within-line">always</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="fn-num-style">
		<xsl:attribute name="keep-with-previous.within-line">always</xsl:attribute>
		<xsl:if test="$namespace = 'bipm' or $namespace = 'jcgm'">
			<xsl:attribute name="font-size">65%</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="font-size">6pt</xsl:attribute>
			<xsl:attribute name="baseline-shift">30%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="font-size">65%</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csd'">
			<xsl:attribute name="font-size">65%</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="font-size">60%</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="font-size">8pt</xsl:attribute>
			<xsl:attribute name="baseline-shift">15%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="font-size">65%</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="font-size">70%</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="font-size">80%</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="font-size">60%</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:attribute name="font-family">Times New Roman</xsl:attribute>
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
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp' or $namespace = 'nist-sp'">
			<xsl:attribute name="font-size">60%</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="font-size">65%</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-size">65%</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece'">
			<xsl:attribute name="font-size">60%</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece-rec'">
			<xsl:attribute name="font-size">55%</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="fn-body-style">
		<xsl:attribute name="font-weight">normal</xsl:attribute>
		<xsl:attribute name="font-style">normal</xsl:attribute>
		<xsl:attribute name="text-indent">0</xsl:attribute>
		<xsl:attribute name="start-indent">0</xsl:attribute>
		<xsl:if test="$namespace = 'bipm' or $namespace = 'jcgm'">
			<xsl:attribute name="font-size">9pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="line-height">124%</xsl:attribute>
			<xsl:attribute name="text-align">justify</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="color">black</xsl:attribute>
			<xsl:attribute name="font-size">8pt</xsl:attribute>
			<xsl:attribute name="start-indent">5mm</xsl:attribute>
			<xsl:attribute name="text-indent">-5mm</xsl:attribute>
			<xsl:attribute name="text-align">left</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="font-family">Azo Sans Lt</xsl:attribute>
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="color">rgb(168, 170, 173)</xsl:attribute>
			<xsl:attribute name="text-align">left</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csd'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="font-size">9pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="font-size">8pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">5pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="font-size">8pt</xsl:attribute>
			<!-- <xsl:attribute name="margin-bottom">5pt</xsl:attribute> -->
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="text-align">justify</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'm3d'">
			<xsl:attribute name="font-size">9pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'mpfd'">
			<xsl:attribute name="font-size">9pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp'">
			<xsl:attribute name="font-size">9pt</xsl:attribute>
			<xsl:attribute name="font-family">Times New Roman</xsl:attribute>
			<xsl:attribute name="margin-left">-3mm</xsl:attribute>
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="text-indent">-2mm</xsl:attribute>
			<xsl:attribute name="line-height">10pt</xsl:attribute>
			<xsl:attribute name="page-break-inside">avoid</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-sp'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="font-family">Times New Roman</xsl:attribute>
			<xsl:attribute name="text-align">justify</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="color"><xsl:value-of select="$color_main"/></xsl:attribute>
			<xsl:attribute name="line-height">124%</xsl:attribute>
			<xsl:attribute name="text-align">justify</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="color">black</xsl:attribute>
			<xsl:attribute name="text-align">justify</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="color">rgb(168, 170, 173)</xsl:attribute>
			<xsl:attribute name="text-align">left</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece'">
			<xsl:attribute name="font-size">9pt</xsl:attribute>
			<xsl:attribute name="text-align">justify</xsl:attribute>
			<xsl:attribute name="line-height">125%</xsl:attribute>
			<xsl:attribute name="margin-left">8mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece-rec'">
			<xsl:attribute name="font-size">9pt</xsl:attribute>
			<xsl:attribute name="line-height">125%</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:template name="refine_fn-body-style">
		<xsl:if test="$namespace = 'bsi'">
			<xsl:if test="$document_type = 'PAS'">
				<xsl:attribute name="color"><xsl:value-of select="$color_secondary_shade_1_PAS"/></xsl:attribute>
				<xsl:attribute name="start-indent">0mm</xsl:attribute>
				<xsl:attribute name="text-indent">0mm</xsl:attribute>
				<xsl:attribute name="margin-top">6pt</xsl:attribute>
				<xsl:attribute name="margin-bottom">-7mm</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:if test="$current_template = 'whitepaper' or $current_template = 'icap-whitepaper' or $current_template = 'industry-connection-report'">
				<xsl:attribute name="font-size">7pt</xsl:attribute>
				<xsl:attribute name="line-height">1.1</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:if test="$doctype = 'service-publication'">
				<xsl:attribute name="font-size">10pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:attribute name="font-family">IPAexMincho</xsl:attribute> <!-- prevent font for footnote in Times New Roman main text -->
		</xsl:if>
	</xsl:template> <!-- refine_fn-body-style -->
	
	
	<xsl:attribute-set name="fn-body-num-style">
		<xsl:attribute name="keep-with-next.within-line">always</xsl:attribute>
		<xsl:if test="$namespace = 'bipm' or $namespace = 'jcgm'">
			<xsl:attribute name="font-size">60%</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
			<xsl:attribute name="padding-right">1mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bsi'">
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
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="baseline-shift">15%</xsl:attribute>
			<xsl:attribute name="padding-right">3mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="font-size">50%</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
			<xsl:attribute name="padding-right">1mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="font-size">60%</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
			<xsl:attribute name="padding-right">1mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="padding-right">3mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="font-size">85%</xsl:attribute>
			<xsl:attribute name="padding-right">2mm</xsl:attribute>
			<xsl:attribute name="baseline-shift">30%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:attribute name="font-family">Times New Roman</xsl:attribute>
			<xsl:attribute name="font-size">67%</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'm3d'">
			<xsl:attribute name="font-size">6pt</xsl:attribute>
			<xsl:attribute name="baseline-shift">30%</xsl:attribute>
			<xsl:attribute name="padding-right">1mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'mpfd'">
			<xsl:attribute name="font-size">6pt</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
			<xsl:attribute name="padding-right">1mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp'">
			<xsl:attribute name="font-size">75%</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
			<xsl:attribute name="padding-right">1mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-sp'">
			<xsl:attribute name="font-size">75%</xsl:attribute>
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
		<xsl:if test="$namespace = 'unece'">
			<xsl:attribute name="font-size">60%</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
			<xsl:attribute name="padding-right">8mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece-rec'">
			<xsl:attribute name="font-size">60%</xsl:attribute>
			<xsl:attribute name="padding-right">1mm</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- fn-body-num-style -->
	
	<xsl:template name="refine_fn-body-num-style">
		<xsl:if test="$namespace = 'bsi'">
			<xsl:if test="$document_type = 'PAS'">
				<xsl:attribute name="font-size">5pt</xsl:attribute>
				<xsl:attribute name="baseline-shift">35%</xsl:attribute>
				<xsl:attribute name="padding-right">1mm</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:if test="$current_template = 'whitepaper' or $current_template = 'icap-whitepaper' or $current_template = 'industry-connection-report'">
				<xsl:attribute name="padding-right">0.5mm</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template> <!-- refine_fn-body-num-style -->

	
	<!-- admonition -->
	<xsl:attribute-set name="admonition-style">
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="border">0.5pt solid rgb(79, 129, 189)</xsl:attribute>
			<xsl:attribute name="color">rgb(79, 129, 189)</xsl:attribute>
			<xsl:attribute name="margin-left">16mm</xsl:attribute>
			<xsl:attribute name="margin-right">16mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csd'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="border">0.25pt solid black</xsl:attribute>
			<xsl:attribute name="margin-left">16mm</xsl:attribute>
			<xsl:attribute name="margin-right">16mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="border">0.5pt solid black</xsl:attribute>
			<xsl:attribute name="margin-left">-2mm</xsl:attribute>
			<xsl:attribute name="margin-right">-2mm</xsl:attribute>
			<xsl:attribute name="space-before">18pt</xsl:attribute>
			<xsl:attribute name="space-after">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="border">0.5pt solid black</xsl:attribute>
			<xsl:attribute name="space-before">12pt</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="space-after">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="border">0.5pt solid rgb(79, 129, 189)</xsl:attribute>
			<xsl:attribute name="color">rgb(79, 129, 189)</xsl:attribute>
			<xsl:attribute name="margin-left">16mm</xsl:attribute>
			<xsl:attribute name="margin-right">16mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="border">0.5pt solid black</xsl:attribute>
			<xsl:attribute name="space-before">12pt</xsl:attribute>
			<xsl:attribute name="space-after">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jcgm'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp'">
			<xsl:attribute name="border">1pt solid black</xsl:attribute>
			<xsl:attribute name="margin-left">-2mm</xsl:attribute>
			<xsl:attribute name="margin-right">-2mm</xsl:attribute>
			<xsl:attribute name="padding-top">6mm</xsl:attribute>
			<xsl:attribute name="padding-bottom">7mm</xsl:attribute>
			<xsl:attribute name="background-color">rgb(222,222,222)</xsl:attribute>
			<xsl:attribute name="space-after">24pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-sp'">
			<xsl:attribute name="border">1pt solid black</xsl:attribute>
			<xsl:attribute name="margin-left">-2mm</xsl:attribute>
			<xsl:attribute name="margin-right">-2mm</xsl:attribute>
			<xsl:attribute name="background-color">rgb(222,222,222)</xsl:attribute>
			<xsl:attribute name="space-after">24pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="border">0.5pt solid rgb(79, 129, 189)</xsl:attribute>
			<xsl:attribute name="color">rgb(79, 129, 189)</xsl:attribute>
			<xsl:attribute name="margin-left">16mm</xsl:attribute>
			<xsl:attribute name="margin-right">16mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="border">0.5pt solid rgb(79, 129, 189)</xsl:attribute>
			<xsl:attribute name="color">rgb(79, 129, 189)</xsl:attribute>
			<xsl:attribute name="margin-left">16mm</xsl:attribute>
			<xsl:attribute name="margin-right">16mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece'">
			<xsl:attribute name="border">0.25pt solid black</xsl:attribute>
			<xsl:attribute name="margin-left">-3mm</xsl:attribute>
			<xsl:attribute name="margin-right">-3mm</xsl:attribute>
			<xsl:attribute name="padding-top">4mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece-rec'">
			<xsl:attribute name="border">0.25pt solid black</xsl:attribute>
			<xsl:attribute name="margin-top">7mm</xsl:attribute>
			<xsl:attribute name="margin-left">-9mm</xsl:attribute>
			<xsl:attribute name="margin-right">-14mm</xsl:attribute>
			<xsl:attribute name="padding-top">3mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">16pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- admonition-style -->
	
	<xsl:attribute-set name="admonition-container-style">
		<xsl:attribute name="margin-left">0mm</xsl:attribute>
		<xsl:attribute name="margin-right">0mm</xsl:attribute>
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="padding">0.5mm</xsl:attribute>
			<xsl:attribute name="font-size">9pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="padding">2mm</xsl:attribute>
			<xsl:attribute name="padding-top">3mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="padding">2mm</xsl:attribute>
			<xsl:attribute name="padding-top">3mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="padding">1mm</xsl:attribute>
			<xsl:attribute name="padding-top">2mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="padding">1mm</xsl:attribute>
			<xsl:attribute name="padding-bottom">2mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="padding">2mm</xsl:attribute>
			<xsl:attribute name="padding-top">3mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="padding">2mm</xsl:attribute>
			<xsl:attribute name="padding-top">3mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp'">
			<xsl:attribute name="margin-left">8mm</xsl:attribute>
			<xsl:attribute name="margin-right">8mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-sp'">
			<xsl:attribute name="margin-left">8mm</xsl:attribute>
			<xsl:attribute name="margin-right">8mm</xsl:attribute>
			<xsl:attribute name="padding-top">6mm</xsl:attribute>
			<xsl:attribute name="padding-bottom">7mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="padding">2mm</xsl:attribute>
			<xsl:attribute name="padding-top">3mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="padding">2mm</xsl:attribute>
			<xsl:attribute name="padding-top">3mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece'">
			<xsl:attribute name="margin-left">2mm</xsl:attribute>
			<xsl:attribute name="margin-right">2mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece-rec'">
			<xsl:attribute name="margin-left">20mm</xsl:attribute>
			<xsl:attribute name="margin-right">20mm</xsl:attribute>
			<xsl:attribute name="text-indent">0mm</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- admonition-container-style -->
	
	
	<xsl:attribute-set name="admonition-name-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="font-style">italic</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="font-style">italic</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="font-family">SimHei</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="font-style">italic</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'm3d'">
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'mpfd'">
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-sp'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="font-style">italic</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="font-weight">normal</xsl:attribute>
			<xsl:attribute name="font-style">italic</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece'">
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="font-style">italic</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece-rec'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="margin-left">20mm</xsl:attribute>
			<xsl:attribute name="margin-right">25mm</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- admonition-name-style -->
	
	<xsl:attribute-set name="admonition-p-style">
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="font-style">italic</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="font-style">italic</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'gb'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="text-align">justify</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="font-style">italic</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'm3d'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp' or $namespace = 'nist-sp'">
		</xsl:if>
		<xsl:if test="$namespace = 'mpfd'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="font-style">italic</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="font-style">italic</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece'">
			<xsl:attribute name="text-align">justify</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="line-height">122%</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'unece-rec'">
			<xsl:attribute name="text-align">justify</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- admonition-p-style -->
	<!-- end admonition -->




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
		<!-- <xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="provisional-distance-between-starts">9.5mm</xsl:attribute>
		</xsl:if> -->
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
			<xsl:attribute name="font-family">Times New Roman</xsl:attribute>
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
	
	
	<!-- Highlight.js syntax GitHub styles -->
	<xsl:attribute-set name="hljs-doctag">
		<xsl:attribute name="color">#d73a49</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-keyword">
		<xsl:attribute name="color">#d73a49</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-meta_hljs-keyword">
		<xsl:attribute name="color">#d73a49</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-template-tag">
		<xsl:attribute name="color">#d73a49</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-template-variable">
		<xsl:attribute name="color">#d73a49</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-type">
		<xsl:attribute name="color">#d73a49</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-variable_and_language_">
		<xsl:attribute name="color">#d73a49</xsl:attribute>
	</xsl:attribute-set>
  
	<xsl:attribute-set name="hljs-title">
		<xsl:attribute name="color">#6f42c1</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-title_and_class_">
		<xsl:attribute name="color">#6f42c1</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-title_and_class__and_inherited__">
		<xsl:attribute name="color">#6f42c1</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-title_and_function_">
		<xsl:attribute name="color">#6f42c1</xsl:attribute>
	</xsl:attribute-set>
  
	<xsl:attribute-set name="hljs-attr">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-attribute">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-literal">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-meta">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-number">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-operator">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-variable">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-selector-attr">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-selector-class">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-selector-id">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
	</xsl:attribute-set>
  
	<xsl:attribute-set name="hljs-regexp">
		<xsl:attribute name="color">#032f62</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-string">
		<xsl:attribute name="color">#032f62</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-meta_hljs-string">
		<xsl:attribute name="color">#032f62</xsl:attribute>
	</xsl:attribute-set>
  
	<xsl:attribute-set name="hljs-built_in">
		<xsl:attribute name="color">#e36209</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-symbol">
		<xsl:attribute name="color">#e36209</xsl:attribute>
	</xsl:attribute-set>
  
	<xsl:attribute-set name="hljs-comment">
		<xsl:attribute name="color">#6a737d</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-code">
		<xsl:attribute name="color">#6a737d</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-formula">
		<xsl:attribute name="color">#6a737d</xsl:attribute>
	</xsl:attribute-set>
  
	<xsl:attribute-set name="hljs-name">
		<xsl:attribute name="color">#22863a</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-quote">
		<xsl:attribute name="color">#22863a</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-selector-tag">
		<xsl:attribute name="color">#22863a</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-selector-pseudo">
		<xsl:attribute name="color">#22863a</xsl:attribute>
	</xsl:attribute-set>
  
	<xsl:attribute-set name="hljs-subst">
		<xsl:attribute name="color">#24292e</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="hljs-section">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
	</xsl:attribute-set>
  
	<xsl:attribute-set name="hljs-bullet">
		<xsl:attribute name="color">#735c0f</xsl:attribute>
	</xsl:attribute-set>
  
	<xsl:attribute-set name="hljs-emphasis">
		<xsl:attribute name="color">#24292e</xsl:attribute>
		<xsl:attribute name="font-style">italic</xsl:attribute>
	</xsl:attribute-set>
  
	<xsl:attribute-set name="hljs-strong">
		<xsl:attribute name="color">#24292e</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
	</xsl:attribute-set>
  
	<xsl:attribute-set name="hljs-addition">
		<xsl:attribute name="color">#22863a</xsl:attribute>
		<xsl:attribute name="background-color">#f0fff4</xsl:attribute>
	</xsl:attribute-set>
  
	<xsl:attribute-set name="hljs-deletion">
		<xsl:attribute name="color">#b31d28</xsl:attribute>
		<xsl:attribute name="background-color">#ffeef0</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="hljs-char_and_escape_">
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-link">
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-params">
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-property">
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-punctuation">
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-tag">
	</xsl:attribute-set>
	<!-- End Highlight syntax styles -->
	
	<!-- Index section styles -->
	<xsl:attribute-set name="indexsect-title-style">
		<xsl:attribute name="role">H1</xsl:attribute>
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="font-size">16pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="margin-bottom">84pt</xsl:attribute>
			<xsl:attribute name="margin-left">-18mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="font-size">18pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="margin-bottom">24pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="font-size">12pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="margin-bottom">84pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="font-size">16pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="margin-bottom">84pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jcgm'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="span">all</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="indexsect-clause-title-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="margin-bottom">3pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="margin-bottom">3pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="margin-bottom">3pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="margin-bottom">3pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jcgm'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="margin-left">25mm</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	
	<!-- End Index section styles -->
	<!-- ====================================== -->
	<!-- END STYLES -->
	<!-- ====================================== -->
	
	<xsl:variable name="border-block-added">2.5pt solid rgb(0, 176, 80)</xsl:variable>
	<xsl:variable name="border-block-deleted">2.5pt solid rgb(255, 0, 0)</xsl:variable>
	
	<xsl:variable name="ace_tag">ace-tag_</xsl:variable>
	
	<xsl:template name="processPrefaceSectionsDefault_Contents">
		<xsl:variable name="nodes_preface_">
			<xsl:for-each select="/*/*[local-name()='preface']/*[not(local-name() = 'note' or local-name() = 'admonition' or @type = 'toc')]">
				<node id="{@id}"/>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="nodes_preface" select="xalan:nodeset($nodes_preface_)"/>
		
		<xsl:for-each select="/*/*[local-name()='preface']/*[not(local-name() = 'note' or local-name() = 'admonition' or @type = 'toc')]">
			<xsl:sort select="@displayorder" data-type="number"/>
			
			<!-- process Section's title -->
			<xsl:variable name="preceding-sibling_id" select="$nodes_preface/node[@id = current()/@id]/preceding-sibling::node[1]/@id"/>
			<xsl:if test="$preceding-sibling_id != ''">
				<xsl:apply-templates select="parent::*/*[@type = 'section-title' and @id = $preceding-sibling_id and not(@displayorder)]" mode="contents_no_displayorder"/>
			</xsl:if>
			
			<xsl:apply-templates select="." mode="contents"/>
		</xsl:for-each>
	</xsl:template>
	
	
	<xsl:template name="processMainSectionsDefault_Contents">
	
		<xsl:variable name="nodes_sections_">
			<xsl:for-each select="/*/*[local-name()='sections']/*">
				<node id="{@id}"/>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="nodes_sections" select="xalan:nodeset($nodes_sections_)"/>
		
		<xsl:for-each select="/*/*[local-name()='sections']/* | /*/*[local-name()='bibliography']/*[local-name()='references'][@normative='true'] |
			/*/*[local-name()='bibliography']/*[local-name()='clause'][*[local-name()='references'][@normative='true']]">
			<xsl:sort select="@displayorder" data-type="number"/>
			
			<!-- process Section's title -->
			<xsl:variable name="preceding-sibling_id" select="$nodes_sections/node[@id = current()/@id]/preceding-sibling::node[1]/@id"/>
			<xsl:if test="$preceding-sibling_id != ''">
				<xsl:apply-templates select="parent::*/*[@type = 'section-title' and @id = $preceding-sibling_id and not(@displayorder)]" mode="contents_no_displayorder"/>
			</xsl:if>
			
			<xsl:apply-templates select="." mode="contents"/>
		</xsl:for-each>
		
		<!-- <xsl:for-each select="/*/*[local-name()='annex']">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:apply-templates select="." mode="contents"/>
		</xsl:for-each> -->
		
		<xsl:for-each select="/*/*[local-name()='annex'] | /*/*[local-name()='bibliography']/*[not(@normative='true') and not(*[local-name()='references'][@normative='true'])][count(.//*[local-name() = 'bibitem'][not(@hidden) = 'true']) &gt; 0] | 
								/*/*[local-name()='bibliography']/*[local-name()='clause'][*[local-name()='references'][not(@normative='true')]][count(.//*[local-name() = 'bibitem'][not(@hidden) = 'true']) &gt; 0]">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:apply-templates select="." mode="contents"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="processTablesFigures_Contents">
		<xsl:param name="always"/>
		<xsl:if test="(//*[contains(local-name(), '-standard')]/*[local-name() = 'metanorma-extension']/*[local-name() = 'toc'][@type='table']/*[local-name() = 'title']) or normalize-space($always) = 'true'">
			<xsl:call-template name="processTables_Contents"/>
		</xsl:if>
		<xsl:if test="(//*[contains(local-name(), '-standard')]/*[local-name() = 'metanorma-extension']/*[local-name() = 'toc'][@type='figure']/*[local-name() = 'title']) or normalize-space($always) = 'true'">
			<xsl:call-template name="processFigures_Contents"/>
		</xsl:if>
	</xsl:template>

	<xsl:template name="processTables_Contents">
		<tables>
			<xsl:for-each select="//*[local-name() = 'table'][not(ancestor::*[local-name() = 'metanorma-extension'])][@id and *[local-name() = 'name'] and normalize-space(@id) != '']">
				<table id="{@id}" alt-text="{*[local-name() = 'name']}">
					<xsl:copy-of select="*[local-name() = 'name']"/>
				</table>
			</xsl:for-each>
		</tables>
	</xsl:template>
	
	<xsl:template name="processFigures_Contents">
		<figures>
			<xsl:for-each select="//*[local-name() = 'figure'][@id and *[local-name() = 'name'] and not(@unnumbered = 'true') and normalize-space(@id) != ''] | //*[@id and starts-with(*[local-name() = 'name'], 'Figure ') and normalize-space(@id) != '']">
				<figure id="{@id}" alt-text="{*[local-name() = 'name']}">
					<xsl:copy-of select="*[local-name() = 'name']"/>
				</figure>
			</xsl:for-each>
		</figures>
	</xsl:template>

	<xsl:template name="processPrefaceSectionsDefault">
		<xsl:for-each select="/*/*[local-name()='preface']/*[not(local-name() = 'note' or local-name() = 'admonition')]">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:apply-templates select="."/>
		</xsl:for-each>
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
	
	<xsl:variable name="regex_standard_reference">([A-Z]{2,}(/[A-Z]{2,})* \d+(-\d+)*(:\d{4})?)</xsl:variable>
	<xsl:variable name="tag_fo_inline_keep-together_within-line_open">###fo:inline keep-together_within-line###</xsl:variable>
	<xsl:variable name="tag_fo_inline_keep-together_within-line_close">###/fo:inline keep-together_within-line###</xsl:variable>
	<xsl:template match="text()" name="text">
		<xsl:choose>
			<xsl:when test="$namespace = 'iso'"><xsl:value-of select="."/></xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="ancestor::*[local-name() = 'table']"><xsl:value-of select="."/></xsl:when>
					<xsl:otherwise>
						<xsl:variable name="text" select="java:replaceAll(java:java.lang.String.new(.),$regex_standard_reference,concat($tag_fo_inline_keep-together_within-line_open,'$1',$tag_fo_inline_keep-together_within-line_close))"/>
						<xsl:call-template name="replace_fo_inline_tags">
							<xsl:with-param name="tag_open" select="$tag_fo_inline_keep-together_within-line_open"/>
							<xsl:with-param name="tag_close" select="$tag_fo_inline_keep-together_within-line_close"/>
							<xsl:with-param name="text" select="$text"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="replace_fo_inline_tags">
		<xsl:param name="tag_open"/>
		<xsl:param name="tag_close"/>
		<xsl:param name="text"/>
		<xsl:choose>
			<xsl:when test="contains($text, $tag_open)">
				<xsl:value-of select="substring-before($text, $tag_open)"/>
				<!-- <xsl:text disable-output-escaping="yes">&lt;fo:inline keep-together.within-line="always"&gt;</xsl:text> -->
				<xsl:variable name="text_after" select="substring-after($text, $tag_open)"/>
				<fo:inline keep-together.within-line="always">
					<xsl:value-of select="substring-before($text_after, $tag_close)"/>
				</fo:inline>
				<!-- <xsl:text disable-output-escaping="yes">&lt;/fo:inline&gt;</xsl:text> -->
				<xsl:call-template name="replace_fo_inline_tags">
					<xsl:with-param name="tag_open" select="$tag_open"/>
					<xsl:with-param name="tag_close" select="$tag_close"/>
					<xsl:with-param name="text" select="substring-after($text_after, $tag_close)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="$text"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	

	<xsl:template match="*[local-name()='br']">
		<xsl:value-of select="$linebreak"/>
	</xsl:template>
	
	<!-- keep-together for standard's name (ISO 12345:2020) -->
	<xsl:template match="*[local-name() = 'keep-together_within-line']">
		<xsl:param name="split_keep-within-line"/>
		
		<!-- <fo:inline>split_keep-within-line='<xsl:value-of select="$split_keep-within-line"/>'</fo:inline> -->
		<xsl:choose>
		
			<xsl:when test="normalize-space($split_keep-within-line) = 'true'">
				<xsl:variable name="sep">_</xsl:variable>
				<xsl:variable name="items">
					<xsl:call-template name="split">
						<xsl:with-param name="pText" select="."/>
						<xsl:with-param name="sep" select="$sep"/>
						<xsl:with-param name="normalize-space">false</xsl:with-param>
						<xsl:with-param name="keep_sep">true</xsl:with-param>
					</xsl:call-template>
				</xsl:variable>
				<xsl:for-each select="xalan:nodeset($items)/item">
					<xsl:choose>
						<xsl:when test=". = $sep">
							<xsl:value-of select="$sep"/><xsl:value-of select="$zero_width_space"/>
						</xsl:when>
						<xsl:otherwise>
							<fo:inline keep-together.within-line="always" role="SKIP"><xsl:apply-templates/></fo:inline>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</xsl:when>
			
			<xsl:otherwise>
				<fo:inline keep-together.within-line="always" role="SKIP"><xsl:apply-templates/></fo:inline>
			</xsl:otherwise>
			
		</xsl:choose>
	</xsl:template>
	
	
	<!-- ================================= -->
	<!-- Preface boilerplate sections processing -->
	<!-- ================================= -->
	<xsl:template match="*[local-name()='copyright-statement']">
		<fo:block xsl:use-attribute-sets="copyright-statement-style" role="SKIP">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template> <!-- copyright-statement -->
	
	<xsl:template match="*[local-name()='copyright-statement']//*[local-name()='title']">
		<xsl:choose>
			<xsl:when test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
				<xsl:variable name="level">
					<xsl:call-template name="getLevel"/>
				</xsl:variable>
				<fo:block role="H{$level}" xsl:use-attribute-sets="copyright-statement-title-style">
					<xsl:apply-templates />
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<!-- process in the template 'title' -->
				<xsl:call-template name="title"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- copyright-statement//title -->
	
	<xsl:template match="*[local-name()='copyright-statement']//*[local-name()='p']">
		
		<xsl:choose>
			<xsl:when test="$namespace = 'bsi' or $namespace = 'ogc' or $namespace = 'ogc-white-paper'">
				<fo:block xsl:use-attribute-sets="copyright-statement-p-style">
					
					<xsl:if test="$namespace = 'bsi'">
						<xsl:if test="$document_type = 'PAS'">
							<xsl:attribute name="space-after">2pt</xsl:attribute>
						</xsl:if>
						<xsl:if test="$doctype = 'flex-standard'">
							<xsl:attribute name="space-after">6pt</xsl:attribute>
						</xsl:if>
						<xsl:if test="ancestor::*[local-name() = 'boilerplate'] and contains(ancestor::*[local-name()='clause'][1]/*[local-name()='title'], 'Publication history')">
							<xsl:attribute name="space-after">0pt</xsl:attribute>
						</xsl:if>
					</xsl:if>
					
					<xsl:if test="$namespace = 'bsi' or $namespace = 'ogc-white-paper'">
						<xsl:if test="@align">
							<xsl:attribute name="text-align">
								<xsl:value-of select="@align"/>
							</xsl:attribute>
						</xsl:if>
					</xsl:if>
					
					<xsl:apply-templates />
				</fo:block>
				
			</xsl:when>
			<xsl:otherwise>
				<!-- process in the template 'paragraph' -->
				<xsl:call-template name="paragraph"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- copyright-statement//p -->
	
	<xsl:template match="*[local-name()='license-statement']">
		<fo:block xsl:use-attribute-sets="license-statement-style">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template> <!-- license-statement -->

	<xsl:template match="*[local-name()='license-statement']//*[local-name()='title']">
		<xsl:choose>
			<xsl:when test="$namespace = 'bipm' or $namespace = 'iso' or $namespace = 'itu' or $namespace = 'nist-sp' or $namespace = 'ogc' or $namespace = 'ogc-white-paper'">
				<xsl:variable name="level">
					<xsl:call-template name="getLevel"/>
				</xsl:variable>
				<fo:block role="H{$level}" xsl:use-attribute-sets="license-statement-title-style">
					<xsl:apply-templates />
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<!-- process in the template 'title' -->
				<xsl:call-template name="title"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- license-statement/title -->

	<xsl:template match="*[local-name()='license-statement']//*[local-name()='p']">
		<xsl:choose>
			<xsl:when test="$namespace = 'bipm' or $namespace = 'iso' or $namespace = 'ogc' or $namespace = 'ogc-white-paper'">
				<fo:block xsl:use-attribute-sets="license-statement-p-style">
		
					<xsl:if test="$namespace = 'iso'">
						<xsl:if test="following-sibling::*[local-name() = 'p']">
							<xsl:attribute name="margin-top">6pt</xsl:attribute>
							<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
						</xsl:if>
					</xsl:if>
					
					<xsl:if test="$namespace = 'ogc-white-paper'">
						<xsl:if test="following-sibling::*[local-name() = 'p']">
							<xsl:attribute name="margin-bottom">14pt</xsl:attribute>
						</xsl:if>
					</xsl:if>
					
					<xsl:apply-templates />
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<!-- process in the template 'paragraph' -->
				<xsl:call-template name="paragraph"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- license-statement/p -->
	
	
	<xsl:template match="*[local-name()='legal-statement']">
		<xsl:param name="isLegacy">false</xsl:param>
		<fo:block xsl:use-attribute-sets="legal-statement-style">
			<xsl:if test="$namespace = 'ogc'">
				<xsl:if test="$isLegacy = 'true'">
					<xsl:attribute name="font-size">9pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template> <!-- legal-statement -->
	
	<xsl:template match="*[local-name()='legal-statement']//*[local-name()='title']">
		<xsl:choose>
			<xsl:when test="$namespace = 'itu' or $namespace = 'nist-cswp' or $namespace = 'nist-sp' or $namespace = 'ogc-white-paper' or $namespace = 'rsd'">
				<!-- ogc-white-paper rsd -->
				<xsl:variable name="level">
					<xsl:call-template name="getLevel"/>
				</xsl:variable>
				<fo:block role="H{$level}" xsl:use-attribute-sets="legal-statement-title-style">
					<xsl:apply-templates />
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<!-- process in the template 'title' -->
				<xsl:call-template name="title"/>
			</xsl:otherwise>
		</xsl:choose>
	
	</xsl:template> <!-- legal-statement/title -->
	
	<xsl:template match="*[local-name()='legal-statement']//*[local-name()='p']">
		<xsl:param name="margin"/>
		<xsl:choose>
			<xsl:when test="$namespace = 'ogc-white-paper'">
				<!-- csa -->
				<fo:block xsl:use-attribute-sets="legal-statement-p-style">
					
					<xsl:if test="@align">
						<xsl:attribute name="text-align">
							<xsl:value-of select="@align"/>
						</xsl:attribute>
					</xsl:if>
					
					<xsl:apply-templates />
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<!-- process in the template 'paragraph' -->
				<xsl:call-template name="paragraph">
					<xsl:with-param name="margin" select="$margin"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- legal-statement/p -->
	
	<xsl:template match="*[local-name()='feedback-statement']">
		<fo:block xsl:use-attribute-sets="feedback-statement-style">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template> <!-- feedback-statement -->
	
	<xsl:template match="*[local-name()='feedback-statement']//*[local-name()='title']">
		<xsl:choose>
			<xsl:when test="$namespace = 'iec'">
				<xsl:variable name="level">
					<xsl:call-template name="getLevel"/>
				</xsl:variable>
				<fo:block role="H{$level}" xsl:use-attribute-sets="feedback-statement-title-style">
					<xsl:apply-templates />
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<!-- process in the template 'title' -->
				<xsl:call-template name="title"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*[local-name()='feedback-statement']//*[local-name()='p']">
		<xsl:param name="margin"/>
		<xsl:choose>
			<xsl:when test="$namespace = 'iec' or $namespace = 'ogc'">
				<fo:block xsl:use-attribute-sets="feedback-statement-p-style">
					<xsl:apply-templates/>
				</fo:block>	
			</xsl:when>
			<xsl:otherwise>
				<!-- process in the template 'paragraph' -->
				<xsl:call-template name="paragraph">
					<xsl:with-param name="margin" select="$margin"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- ================================= -->
	<!-- END Preface boilerplate sections processing -->
	<!-- ================================= -->
	
	<!-- add zero spaces into table cells text -->
	<xsl:template match="*[local-name()='td']//text() | *[local-name()='th']//text() | *[local-name()='dt']//text() | *[local-name()='dd']//text()" priority="1">
		<xsl:choose>
			<xsl:when test="parent::*[local-name() = 'keep-together_within-line']">
				<xsl:value-of select="."/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="addZeroWidthSpacesToTextNodes"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="addZeroWidthSpacesToTextNodes">
		<xsl:variable name="text"><text><xsl:call-template name="text"/></text></xsl:variable>
		<!-- <xsl:copy-of select="$text"/> -->
		<xsl:for-each select="xalan:nodeset($text)/text/node()">
			<xsl:choose>
				<xsl:when test="self::text()"><xsl:call-template name="add-zero-spaces-java"/></xsl:when>
				<xsl:otherwise><xsl:copy-of select="."/></xsl:otherwise> <!-- copy 'as-is' for <fo:inline keep-together.within-line="always" ...  -->
			</xsl:choose>
		</xsl:for-each>
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
				<xsl:call-template name="getSimpleTable">
					<xsl:with-param name="id" select="@id"/>
				</xsl:call-template>
			</xsl:variable>
			<!-- <xsl:variable name="simple-table" select="xalan:nodeset($simple-table_)"/> -->
		
			<!-- simple-table=<xsl:copy-of select="$simple-table"/> -->
		
			
			<!-- Display table's name before table as standalone block -->
			<!-- $namespace = 'iso' or  -->
			<xsl:choose>
				<xsl:when test="$namespace = 'bsi'">
					<xsl:if test="$document_type != 'PAS'">
						<xsl:apply-templates select="*[local-name()='name']" />
					</xsl:if>
				</xsl:when>
				<xsl:when test="$namespace = 'ieee' or $namespace = 'jcgm'"></xsl:when> <!-- table name will be rendered in table-header --> <!--  or $namespace = 'iso'  -->
				<xsl:when test="$namespace = 'ogc-white-paper'"></xsl:when> <!-- table's title will be rendered after table -->
				<xsl:otherwise>
					<xsl:apply-templates select="*[local-name()='name']" /> <!-- table's title rendered before table -->
				</xsl:otherwise>
			</xsl:choose>
			
			<xsl:choose>
				<xsl:when test="$namespace = 'bsi' or $namespace = 'csa' or $namespace = 'iso' or $namespace = 'jcgm' or $namespace = 'nist-cswp' or $namespace = 'nist-sp' or $namespace = 'rsd'"></xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="table_name_fn_display"/>
				</xsl:otherwise>
			</xsl:choose>
			
			<xsl:variable name="cols-count" select="count(xalan:nodeset($simple-table)/*/tr[1]/td)"/>
			
			<xsl:variable name="colwidths">
				<xsl:if test="not(*[local-name()='colgroup']/*[local-name()='col'])">
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
					<xsl:when test="sum(xalan:nodeset($colwidths)//column) &gt; 75">15</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			
			<fo:block-container xsl:use-attribute-sets="table-container-style" role="SKIP">
			
				<xsl:call-template name="refine_table-container-style">
					<xsl:with-param name="margin-side" select="$margin-side"/>
				</xsl:call-template>
			
				<!-- display table's name before table for PAS inside block-container (2-columnn layout) -->
				<xsl:if test="$namespace = 'bsi'">
					<xsl:if test="$document_type = 'PAS'">
						<xsl:apply-templates select="*[local-name()='name']" />
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
								<xsl:when test="ancestor::*[local-name() = 'feedback-statement']">50%</xsl:when>
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
					
					<xsl:variable name="isNoteOrFnExist" select="./*[local-name()='note'] or ./*[local-name()='example'] or .//*[local-name()='fn'][local-name(..) != 'name'] or ./*[local-name()='source']"/>				
					<xsl:if test="$isNoteOrFnExist = 'true'">
						<xsl:attribute name="border-bottom">0pt solid black</xsl:attribute> <!-- set 0pt border, because there is a separete table below for footer  -->
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
							<!-- Simple_table=<xsl:copy-of select="$simple-table"/> -->
							<xsl:apply-templates select="xalan:nodeset($simple-table)" mode="process_table-if"/>
							
						</xsl:when>
						<xsl:otherwise>
					
							<xsl:choose>
								<xsl:when test="*[local-name()='colgroup']/*[local-name()='col']">
									<xsl:for-each select="*[local-name()='colgroup']/*[local-name()='col']">
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
									<xsl:apply-templates select="node()[not(local-name() = 'name') and not(local-name() = 'note') and not(local-name() = 'example') and not(local-name() = 'dl') and not(local-name() = 'source') and not(local-name() = 'p')
									and not(local-name() = 'thead') and not(local-name() = 'tfoot')]" /> <!-- process all table' elements, except name, header, footer, note, source and dl which render separaterely -->
								</xsl:otherwise>
							</xsl:choose>
					
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
				
				
				<xsl:if test="$namespace = 'gb'">
					<xsl:apply-templates select="*[local-name()='note']" />
				</xsl:if>
				
				<xsl:if test="$namespace = 'ogc-white-paper'">
					<xsl:apply-templates select="*[local-name()='name']" />
				</xsl:if>
				
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
		</xsl:variable>
		
		<xsl:variable name="isAdded" select="@added"/>
		<xsl:variable name="isDeleted" select="@deleted"/>
		
		<xsl:choose>
			<xsl:when test="@width and @width != 'full-page-width' and @width != 'text-width'">
	
				<!-- centered table when table name is centered (see table-name-style) -->
				<xsl:if test="$namespace = 'bsi' or $namespace = 'csa' or $namespace = 'csd' or $namespace = 'gb' or 
								$namespace = 'iec' or $namespace = 'iho' or  $namespace = 'iso' or $namespace = 'itu' or 
								$namespace = 'jcgm' or
								$namespace = 'm3d' or $namespace = 'mpfd' or 
								$namespace = 'nist-cswp' or $namespace = 'nist-sp' or 
								$namespace = 'rsd'">
					<fo:table table-layout="fixed" width="100%" xsl:use-attribute-sets="table-container-style">
						<fo:table-column column-width="proportional-column-width(1)"/>
						<fo:table-column column-width="{@width}"/>
						<fo:table-column column-width="proportional-column-width(1)"/>
						<fo:table-body>
							<fo:table-row>
								<fo:table-cell column-number="2">
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
			<xsl:if test="starts-with(@id, 'array_') or starts-with(ancestor::*[local-name() = 'table'][1]/@id, 'array_')">
				<!-- array - table without borders -->
				<xsl:attribute name="border">none</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*[local-name()='table']/*[local-name() = 'name']">
		<xsl:param name="continued"/>
		<xsl:if test="normalize-space() != ''">
		
			<xsl:choose>
				<xsl:when test="$namespace = 'ieee'">
					<fo:inline>
				
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
					
						<xsl:attribute name="provisional-distance-between-starts">25mm</xsl:attribute>
						
						<fo:list-item>
							<fo:list-item-label end-indent="label-end()">
								<fo:block>
									<xsl:apply-templates select="./*[local-name() = 'tab'][1]/preceding-sibling::node()"/>
								</fo:block>
							</fo:list-item-label>
							<fo:list-item-body start-indent="body-start()">
								<fo:block>
									<xsl:choose>
										<xsl:when test="./*[local-name() = 'tab']">
											<xsl:apply-templates select="./*[local-name() = 'tab'][1]/following-sibling::node()"/>
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
				
					<fo:block xsl:use-attribute-sets="table-name-style" role="SKIP">

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
							<xsl:if test="not(ancestor::*[local-name() = 'table']/@class = 'corrigenda') and 
							not(contains(ancestor::*[local-name()='clause'][1]/*[local-name()='title'], 'Amendments/corrigenda'))">
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
			
				</xsl:otherwise>
			</xsl:choose>
			
		</xsl:if>
	</xsl:template> <!-- table/name -->

	
	<!-- SOURCE: ... -->
	<xsl:template match="*[local-name()='table']/*[local-name() = 'source']" priority="2">
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
								<xsl:apply-templates select="td[$curr-col]" mode="td_text"/>
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
	
	<xsl:template match="*[local-name()='termsource']" mode="td_text">
		<xsl:value-of select="*[local-name()='origin']/@citeas"/>
	</xsl:template>
	
	<xsl:template match="*[local-name()='link']" mode="td_text">
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
					<column divider="100">
						<xsl:value-of select="round(@width_min + $d * $W div $D)"/> <!--  * 10 -->
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
						<!-- <xsl:when test="parent::*[local-name() = 'dd']">2</xsl:when> -->
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
	<!-- Calculate column's width based on HTML4 algorithm -->
	<!-- ================================================== -->
	
	
	<xsl:template match="*[local-name()='thead']">
		<xsl:param name="cols-count"/>
		<fo:table-header>
			<xsl:if test="$namespace = 'iec' or $namespace = 'ieee' or $namespace = 'iso' or $namespace = 'jcgm'">
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
							<xsl:apply-templates select="ancestor::*[local-name()='table']/*[local-name()='name']">
								<xsl:with-param name="continued">true</xsl:with-param>
							</xsl:apply-templates>
							
							<fo:inline font-weight="normal" font-style="italic" role="SKIP">
								<xsl:text>&#xA0;</xsl:text>
								<fo:retrieve-table-marker retrieve-class-name="table_continued"/>
							</fo:inline>
						</fo:block>
					</xsl:when>
					<xsl:otherwise>
				
						<xsl:apply-templates select="ancestor::*[local-name()='table']/*[local-name()='name']">
							<xsl:with-param name="continued">true</xsl:with-param>
						</xsl:apply-templates>
						
						<xsl:if test="not(ancestor::*[local-name()='table']/*[local-name()='name'])"> <!-- to prevent empty fo:table-cell in case of missing table's name -->
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
	

	<xsl:template match="*[local-name()='tfoot']">
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template name="insertTableFooter">
		<xsl:param name="cols-count" />
		<xsl:if test="../*[local-name()='tfoot']">
			<fo:table-footer>			
				<xsl:apply-templates select="../*[local-name()='tfoot']" />
			</fo:table-footer>
		</xsl:if>
	</xsl:template>
	
	
	<xsl:template name="insertTableFooterInSeparateTable">
		<xsl:param name="table_attributes"/>
		<xsl:param name="colwidths"/>
		<xsl:param name="colgroup"/>
		
		<xsl:variable name="isNoteOrFnExist" select="../*[local-name()='note'] or ../*[local-name()='example'] or ../*[local-name()='dl'] or ..//*[local-name()='fn'][local-name(..) != 'name'] or ../*[local-name()='source'] or ../*[local-name()='p']"/>
		
		<xsl:variable name="isNoteOrFnExistShowAfterTable">
			<xsl:if test="$namespace = 'bsi'">
				 <xsl:value-of select="../*[local-name()='note'] or ../*[local-name()='source'] or ../*[local-name()='dl'] or ..//*[local-name()='fn']"/>
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
			
			<xsl:variable name="table_fn_block">
				<xsl:call-template name="table_fn_display" />
			</xsl:variable>
			
			<xsl:variable name="tableWithNotesAndFootnotes">
			
				<fo:table keep-with-previous="always">
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
							<!-- $colwidths=<xsl:copy-of select="$colwidths"/> -->
							<xsl:call-template name="insertTableColumnWidth">
								<xsl:with-param name="colwidths" select="$colwidths"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
					
					<fo:table-body>
						<fo:table-row>
							<fo:table-cell xsl:use-attribute-sets="table-footer-cell-style" number-columns-spanned="{$cols-count}">
								
								<xsl:call-template name="refine_table-footer-cell-style"/>
								
								<xsl:call-template name="setBordersTableArray"/>
								
								<!-- fn will be processed inside 'note' processing -->
								<xsl:if test="$namespace = 'iec'">
									<xsl:if test="../*[local-name()='note']">
										<fo:block margin-bottom="6pt" role="SKIP">&#xA0;</fo:block>
									</xsl:if>
								</xsl:if>
								
								<xsl:if test="$namespace = 'bipm'">
									<xsl:if test="count(ancestor::bipm:table//*[local-name()='note']) &gt; 1">
										<fo:block font-weight="bold" role="SKIP">
											<xsl:variable name="curr_lang" select="ancestor::bipm:bipm-standard/bipm:bibdata/bipm:language"/>
											<xsl:choose>
												<xsl:when test="$curr_lang = 'fr'">Remarques</xsl:when>
												<xsl:otherwise>Notes</xsl:otherwise>
											</xsl:choose>
										</fo:block>
									</xsl:if>
								</xsl:if>
								
								<xsl:if test="$namespace = 'itu'">
									<xsl:if test="$doctype = 'service-publication'">
										<fo:block margin-top="7pt" margin-bottom="2pt" role="SKIP"><fo:inline>____________</fo:inline></fo:block>
									</xsl:if>
								</xsl:if>
								
								<!-- for BSI (not PAS) display Notes before footnotes -->
								<xsl:if test="$namespace = 'bsi'">
									<xsl:if test="$document_type != 'PAS'">
										<xsl:apply-templates select="../*[local-name()='dl']" />
										<xsl:apply-templates select="../*[local-name()='note']" />
										<xsl:apply-templates select="../*[local-name()='source']" />
									</xsl:if>
								</xsl:if>
								
								<!-- except gb and bsi  -->
								<xsl:choose>
									<xsl:when test="$namespace = 'gb' or $namespace = 'bsi'"></xsl:when>
									<xsl:when test="$namespace = 'jis'">
										<xsl:apply-templates select="../*[local-name()='p' or local-name()='dl' or local-name()='note' or local-name()='example' or local-name()='source']" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:apply-templates select="../*[local-name()='p']" />
										<xsl:apply-templates select="../*[local-name()='dl']" />
										<xsl:apply-templates select="../*[local-name()='note']" />
										<xsl:apply-templates select="../*[local-name()='example']" />
										<xsl:apply-templates select="../*[local-name()='source']" />
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
									<xsl:if test="(../*[local-name()='note'] or ../*[local-name()='example']) and normalize-space($table_fn_block) != ''">
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
									<xsl:otherwise>
										<!-- <xsl:call-template name="table_fn_display" /> -->
										<xsl:copy-of select="$table_fn_block"/>
									</xsl:otherwise>
								</xsl:choose>
								
								
								<!-- for PAS display Notes after footnotes -->
								<xsl:if test="$namespace = 'bsi'">
									<xsl:if test="$document_type = 'PAS'">
										<xsl:apply-templates select="../*[local-name()='dl']" />
										<xsl:apply-templates select="../*[local-name()='note']" />
										<xsl:apply-templates select="../*[local-name()='source']" />
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
		
		<xsl:if test="$namespace = 'bsi' or $namespace = 'iec' or $namespace = 'ieee' or $namespace = 'iso' or $namespace = 'jcgm'">
			<!-- if there isn't 'thead' and there is a table's title -->
			<xsl:if test="not(ancestor::*[local-name()='table']/*[local-name()='thead']) and ancestor::*[local-name()='table']/*[local-name()='name']">
				<fo:table-header>
					<xsl:call-template name="table-header-title">
						<xsl:with-param name="cols-count" select="$cols-count"/>
					</xsl:call-template>
				</fo:table-header>
			</xsl:if>
		</xsl:if>
		
		<xsl:apply-templates select="../*[local-name()='thead']">
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
				
				<xsl:variable name="title_start" select="ancestor::*[local-name()='table'][1]/*[local-name()='name']/node()[1][self::text()]"/>
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
	
	<!-- ===================== -->
	<!-- Table's row processing -->
	<!-- ===================== -->
	<!-- row in table header (thead) thead/tr -->
	<xsl:template match="*[local-name()='thead']/*[local-name()='tr']" priority="2">
		<fo:table-row xsl:use-attribute-sets="table-header-row-style">
		
			<xsl:call-template name="refine_table-header-row-style"/>
			
			<xsl:call-template name="setTableRowAttributes"/>
			
			<xsl:apply-templates />
		</fo:table-row>
	</xsl:template>	
	
	<xsl:template name="setBorderUnderRow">
		<xsl:variable name="border_under_row_" select="normalize-space(ancestor::*[local-name() = 'table'][1]/@border-under-row)"/>
		<xsl:choose>
			<xsl:when test="$border_under_row_ != ''">
				<xsl:variable name="table_id" select="ancestor::*[local-name() = 'table'][1]/@id"/>
				<xsl:variable name="row_num_"><xsl:number level="any" count="*[local-name() = 'table'][@id = $table_id]//*[local-name() = 'tr']"/></xsl:variable>
				<xsl:variable name="row_num" select="number($row_num_) - 1"/> <!-- because values in border-under-row start with 0 -->
				<xsl:variable name="border_under_row">
					<xsl:call-template name="split">
						<xsl:with-param name="pText" select="$border_under_row_"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:if test="xalan:nodeset($border_under_row)/item[. = normalize-space($row_num)]">
					<xsl:attribute name="border-bottom"><xsl:value-of select="$table-border"/></xsl:attribute>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="border-bottom"><xsl:value-of select="$table-border"/></xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
		
	<!-- row in table footer (tfoot), tfoot/tr -->
	<xsl:template match="*[local-name()='tfoot']/*[local-name()='tr']" priority="2">
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
			<xsl:if test="(ancestor::*[local-name()='preface'] and ancestor::*[local-name()='clause'][@type = 'corrigenda'] and normalize-space() = '') or
			(ancestor::*[local-name()='copyright-statement'] and contains(ancestor::*[local-name()='clause'][1]/*[local-name()='title'], 'Amendments/corrigenda') and normalize-space() = '')">
				<xsl:attribute name="min-height">0mm</xsl:attribute>
			</xsl:if>
			<xsl:if test="$document_type = 'PAS'">
				<xsl:attribute name="min-height">6mm</xsl:attribute>
			</xsl:if>
		</xsl:if>

		<xsl:if test="$namespace = 'itu'">
			<xsl:if test="$doctype = 'service-publication'">
				<xsl:attribute name="min-height">5mm</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'unece'">
			<xsl:if test="not(*[local-name()='th'])">
				<xsl:attribute name="min-height">8mm</xsl:attribute>
			</xsl:if>
		</xsl:if>
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
			
			<xsl:call-template name="refine_table-header-cell-style"/>
			
			<fo:block role="SKIP">
				<xsl:apply-templates />
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
	
	<!-- cell in table body, footer -->
	<xsl:template match="*[local-name()='td']" name="td">
		<fo:table-cell xsl:use-attribute-sets="table-cell-style"> <!-- text-align="{@align}" -->
			<xsl:call-template name="setTextAlignment">
				<xsl:with-param name="default">left</xsl:with-param>
			</xsl:call-template>
			
			<xsl:call-template name="refine_table-cell-style"/>
			
			<xsl:if test=".//*[local-name() = 'table']"> <!-- if there is nested table -->
				<xsl:attribute name="padding-right">1mm</xsl:attribute>
			</xsl:if>
			
			<xsl:call-template name="setTableCellAttributes"/>
			
			<xsl:if test="$isGenerateTableIF = 'true'">
				<xsl:attribute name="border">1pt solid black</xsl:attribute> <!-- border is mandatory, to determine page width -->
				<xsl:attribute name="text-align">left</xsl:attribute>
			</xsl:if>
			
			<fo:block role="SKIP">
			
				<xsl:if test="$isGenerateTableIF = 'true'">
					<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
				</xsl:if>
			
			
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
				
				<xsl:if test="$isGenerateTableIF = 'true'">&#xa0;<fo:inline id="{@id}_end">end</fo:inline></xsl:if> <!-- to determine width of text --> <!-- <xsl:value-of select="$hair_space"/> -->
				
			</fo:block>			
		</fo:table-cell>
	</xsl:template> <!-- td -->
	

	
	<xsl:template match="*[local-name()='table']/*[local-name()='note' or local-name() = 'example']" priority="2">
		<xsl:choose>
			<xsl:when test="$namespace = 'jis'">
				<fo:list-block id="{@id}" xsl:use-attribute-sets="table-note-style" provisional-distance-between-starts="{9 + $text_indent}mm"> <!-- 12 -->
					<fo:list-item>
						<fo:list-item-label start-indent="{$text_indent}mm" end-indent="label-end()">
							<fo:block>
								<xsl:apply-templates select="*[local-name() = 'name']" />
							</fo:block>
						</fo:list-item-label>
						<fo:list-item-body start-indent="body-start()" xsl:use-attribute-sets="table-fn-body-style">
							<fo:block>
								<xsl:apply-templates select="node()[not(local-name() = 'name')]" />
							</fo:block>
						</fo:list-item-body>
					</fo:list-item>
				</fo:list-block>
				<!-- jis -->
			</xsl:when>
			<xsl:otherwise>
				<fo:block xsl:use-attribute-sets="table-note-style">

					<xsl:call-template name="refine_table-note-style"/>

					<!-- Table's note/example name (NOTE, for example) -->
					<fo:inline xsl:use-attribute-sets="table-note-name-style">
						
						<xsl:call-template name="refine_table-note-name-style"/>
						
						<xsl:apply-templates select="*[local-name() = 'name']" />
						
					</fo:inline>
					
					<xsl:if test="$namespace = 'bipm'">
						<xsl:if test="ancestor::bipm:preface">
							<fo:block>&#xA0;</fo:block>
						</xsl:if>
					</xsl:if>
					
					<xsl:apply-templates select="node()[not(local-name() = 'name')]" />
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- table/note -->
	
	
	<xsl:template match="*[local-name()='table']/*[local-name()='note' or local-name()='example']/*[local-name()='p']" priority="2">
		<xsl:apply-templates/>
	</xsl:template>
	
	<!-- ===================== -->
	<!-- Footnotes processing  -->
	<!-- ===================== -->
	<!--
	<fn reference="1">
			<p id="_8e5cf917-f75a-4a49-b0aa-1714cb6cf954">Formerly denoted as 15 % (m/m).</p>
		</fn>
	-->
	<!-- footnotes in text (title, bibliography, main body, table's, figure's names), not for tables, figures -->
	<xsl:template match="*[local-name() = 'fn'][not(ancestor::*[(local-name() = 'table' or local-name() = 'figure')] and not(ancestor::*[local-name() = 'name']))]" priority="2" name="fn">
	
		<!-- list of footnotes to calculate actual footnotes number -->
		<xsl:variable name="p_fn_">
			<xsl:call-template name="get_fn_list"/>
			<!-- <xsl:choose>
				<xsl:when test="$namespace = 'jis'">
					<xsl:call-template name="get_fn_list_for_element"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="get_fn_list"/>
				</xsl:otherwise>
			</xsl:choose> -->
		</xsl:variable>
		<xsl:variable name="p_fn" select="xalan:nodeset($p_fn_)"/>
		
		<xsl:variable name="gen_id" select="generate-id(.)"/>
		<xsl:variable name="lang" select="ancestor::*[contains(local-name(), '-standard')]/*[local-name()='bibdata']//*[local-name()='language'][@current = 'true']"/>
		<xsl:variable name="reference_">
			<xsl:value-of select="@reference"/>
			<xsl:if test="normalize-space(@reference) = ''"><xsl:value-of select="$gen_id"/></xsl:if>
		</xsl:variable>
		<xsl:variable name="reference" select="normalize-space($reference_)"/>
		<!-- fn sequence number in document -->
		<xsl:variable name="current_fn_number">
			<xsl:choose>
				<xsl:when test="@current_fn_number"><xsl:value-of select="@current_fn_number"/></xsl:when> <!-- for BSI -->
				<xsl:otherwise>
					<xsl:value-of select="count($p_fn//fn[@reference = $reference]/preceding-sibling::fn) + 1" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="current_fn_number_text">
			<xsl:value-of select="$current_fn_number"/>
			<xsl:if test="$namespace = 'bsi'">
				<xsl:if test="$document_type = 'PAS'">
					<xsl:text>)</xsl:text>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$namespace = 'iso'">
				<xsl:text>)</xsl:text>
			</xsl:if>
			<xsl:if test="$namespace = 'jis'">
				<fo:inline font-weight="normal">)</fo:inline>
			</xsl:if>
		</xsl:variable>
		
		<xsl:variable name="ref_id">
			<xsl:choose>
				<xsl:when test="normalize-space(@ref_id) != ''"><xsl:value-of select="@ref_id"/></xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat('footnote_', $lang, '_', $reference, '_', $current_fn_number)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="footnote_inline">
			<fo:inline role="Reference">
			
				<xsl:variable name="fn_styles">
					<xsl:choose>
						<xsl:when test="ancestor::*[local-name() = 'bibitem']">
							<fn_styles xsl:use-attribute-sets="bibitem-note-fn-style"/>
						</xsl:when>
						<xsl:otherwise>
							<fn_styles xsl:use-attribute-sets="fn-num-style"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
			
				<xsl:for-each select="xalan:nodeset($fn_styles)/fn_styles/@*">
					<xsl:copy-of select="."/>
				</xsl:for-each>
			
				<xsl:if test="following-sibling::*[1][local-name() = 'fn']">
					<xsl:attribute name="padding-right">0.5mm</xsl:attribute>
				</xsl:if>
			
				<xsl:if test="$namespace = 'bsi'">
					<xsl:if test="$document_type = 'PAS'">
						<xsl:attribute name="font-size">5pt</xsl:attribute>
					</xsl:if>
					<xsl:if test="following-sibling::*[1][local-name() = 'fn']">
						<xsl:attribute name="padding-right">0mm</xsl:attribute>
					</xsl:if>
					<xsl:if test="preceding-sibling::*[1][local-name() = 'fn']">,</xsl:if>
				</xsl:if>
				
				<xsl:call-template name="insert_basic_link">
					<xsl:with-param name="element">
						<fo:basic-link internal-destination="{$ref_id}" fox:alt-text="footnote {$current_fn_number}" role="Lbl">
							<xsl:copy-of select="$current_fn_number_text"/>
						</fo:basic-link>
					</xsl:with-param>
				</xsl:call-template>
			</fo:inline>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="normalize-space(@skip_footnote_body) = 'true'">
				<xsl:copy-of select="$footnote_inline"/>
			</xsl:when>
			<xsl:when test="$p_fn//fn[@gen_id = $gen_id] or normalize-space(@skip_footnote_body) = 'false'">
				<fo:footnote xsl:use-attribute-sets="fn-style" role="SKIP">
					<xsl:copy-of select="$footnote_inline"/>
					<fo:footnote-body role="Note">
						<xsl:if test="$namespace = 'bsi'">
							<xsl:if test="$document_type = 'PAS'">
								<fo:block role="SKIP">&#xa0;</fo:block>
							</xsl:if>
						</xsl:if>
						<fo:block-container xsl:use-attribute-sets="fn-container-body-style" role="SKIP">
							
							<fo:block xsl:use-attribute-sets="fn-body-style" role="SKIP">
							
								<xsl:call-template name="refine_fn-body-style"/>
							
								<fo:inline id="{$ref_id}" xsl:use-attribute-sets="fn-body-num-style" role="Lbl">
								
									<xsl:call-template name="refine_fn-body-num-style"/>
									
									<xsl:value-of select="$current_fn_number_text"/>
								</fo:inline>
								<xsl:apply-templates />
							</fo:block>
						</fo:block-container>
					</fo:footnote-body>
				</fo:footnote>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="$footnote_inline"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- fn in text -->
	
	
	
	<xsl:template name="get_fn_list">
		<xsl:choose>
			<xsl:when test="@current_fn_number"> <!-- for BSI, footnote reference number calculated already -->
				<fn gen_id="{generate-id(.)}">
					<xsl:copy-of select="@*"/>
					<xsl:copy-of select="node()"/>
				</fn>
			</xsl:when>
			<xsl:otherwise>
				<!-- itetation for:
				footnotes in bibdata/title
				footnotes in bibliography
				footnotes in document's body (except table's head/body/foot and figure text) 
				-->
				<xsl:for-each select="ancestor::*[contains(local-name(), '-standard')]/*[local-name() = 'bibdata']/*[local-name() = 'note'][@type='title-footnote']">
					<fn gen_id="{generate-id(.)}">
						<xsl:copy-of select="@*"/>
						<xsl:copy-of select="node()"/>
					</fn>
				</xsl:for-each>
				<xsl:for-each select="ancestor::*[contains(local-name(), '-standard')]/*[local-name()='boilerplate']/* | 
					ancestor::*[contains(local-name(), '-standard')]/*[local-name()='preface']/* |
					ancestor::*[contains(local-name(), '-standard')]/*[local-name()='sections']/* | 
					ancestor::*[contains(local-name(), '-standard')]/*[local-name()='annex'] |
					ancestor::*[contains(local-name(), '-standard')]/*[local-name()='bibliography']/*">
					<xsl:sort select="@displayorder" data-type="number"/>
					<!-- commented:
					 .//*[local-name() = 'bibitem'][ancestor::*[local-name() = 'references']]/*[local-name() = 'note'] |
					 because 'fn' there is in biblio-tag -->
					<xsl:for-each select=".//*[local-name() = 'fn'][not(ancestor::*[(local-name() = 'table' or local-name() = 'figure')] and not(ancestor::*[local-name() = 'name']))][generate-id(.)=generate-id(key('kfn',@reference)[1])]">
						<!-- copy unique fn -->
						<fn gen_id="{generate-id(.)}">
							<xsl:copy-of select="@*"/>
							<xsl:copy-of select="node()"/>
						</fn>
					</xsl:for-each>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="get_fn_list_for_element">
		<xsl:choose>
			<xsl:when test="@current_fn_number"> <!-- footnote reference number calculated already -->
				<fn gen_id="{generate-id(.)}">
					<xsl:copy-of select="@*"/>
					<xsl:copy-of select="node()"/>
				</fn>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="ancestor::*[local-name() = 'ul' or local-name() = 'ol'][1]">
					<xsl:variable name="element_id" select="@id"/>
					<xsl:for-each select=".//*[local-name() = 'fn'][generate-id(.)=generate-id(key('kfn',@reference)[1])]">
						<!-- copy unique fn -->
						<fn gen_id="{generate-id(.)}">
							<xsl:copy-of select="@*"/>
							<xsl:copy-of select="node()"/>
						</fn>
					</xsl:for-each>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- ============================ -->
	<!-- table's footnotes rendering -->
	<!-- ============================ -->
	<xsl:template name="table_fn_display">
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
			
				<xsl:choose>
					<xsl:when test="$namespace = 'bsi'">
						<fo:list-block id="{@id}" xsl:use-attribute-sets="table-fn-style" provisional-distance-between-starts="4mm">
							<xsl:if test="$document_type = 'PAS'">
								<xsl:attribute name="font-size">inherit</xsl:attribute>
							</xsl:if>
							<fo:list-item>
								<fo:list-item-label end-indent="label-end()">
									<fo:block>
										<xsl:attribute name="font-size">5.5pt</xsl:attribute>
										<xsl:if test="$document_type = 'PAS'">
											<xsl:attribute name="padding-right">0.5mm</xsl:attribute>
											<xsl:attribute name="font-size">4.5pt</xsl:attribute>
										</xsl:if>
										<xsl:value-of select="@reference"/>
										<xsl:text>)</xsl:text>								
									</fo:block>
								</fo:list-item-label>
								<fo:list-item-body start-indent="body-start()" xsl:use-attribute-sets="table-fn-body-style">
									<fo:block>
										<xsl:copy-of select="./node()"/>
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
										<fo:inline font-size="9pt" font-family="IPAexGothic">
											<xsl:call-template name="getLocalizedString">
												<xsl:with-param name="key">table_footnote</xsl:with-param>
											</xsl:call-template>
										</fo:inline>
										<xsl:text> </xsl:text>
										<fo:inline xsl:use-attribute-sets="table-fn-number-style">
											<xsl:value-of select="@reference"/>
											<fo:inline font-weight="normal">)</fo:inline>
										</fo:inline>
									</fo:block>
								</fo:list-item-label>
								<fo:list-item-body start-indent="body-start()" xsl:use-attribute-sets="table-fn-body-style">
									<fo:block>
										<xsl:copy-of select="./node()"/>
									</fo:block>
								</fo:list-item-body>
							</fo:list-item>
						</fo:list-block>
						<!-- jis -->
					</xsl:when>
					
					<xsl:otherwise>
						<fo:block xsl:use-attribute-sets="table-fn-style">
				
							<fo:inline id="{@id}" xsl:use-attribute-sets="table-fn-number-style">
								
								<xsl:if test="$namespace = 'bsi'">
									<xsl:if test="$document_type = 'PAS'">
										<xsl:attribute name="font-size">80%</xsl:attribute>
									</xsl:if>
								</xsl:if>
								
								<xsl:if test="$namespace = 'bipm'">
									<fo:inline font-style="normal">(</fo:inline>
								</xsl:if>
								
								<xsl:value-of select="@reference"/>
								
								<xsl:if test="$namespace = 'bipm'">
									<fo:inline font-style="normal">)</fo:inline>
								</xsl:if>
								
								<xsl:if test="$namespace = 'itu'">
									<xsl:text>)</xsl:text>
								</xsl:if>
							</fo:inline>
							<fo:inline xsl:use-attribute-sets="table-fn-body-style">
								<xsl:copy-of select="./node()"/>
							</fo:inline>
							
						</fo:block>
					</xsl:otherwise>
				</xsl:choose>
			
				
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
	
	<!-- footnotes for table's name rendering -->
	<xsl:template name="table_name_fn_display">
		<xsl:for-each select="*[local-name()='name']//*[local-name()='fn']">
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
	
	<!-- figure's footnotes rendering -->
	<xsl:template name="fn_display_figure">
	
		<!-- current figure id -->
		<xsl:variable name="figure_id_">
			<xsl:value-of select="@id"/>
			<xsl:if test="not(@id)"><xsl:value-of select="generate-id()"/></xsl:if>
		</xsl:variable>
		<xsl:variable name="figure_id" select="normalize-space($figure_id_)"/>
	
		<!-- all footnotes relates to the current figure -->
		<xsl:variable name="references">
			<xsl:for-each select=".//*[local-name()='fn'][not(parent::*[local-name()='name'])][ancestor::*[local-name() = 'figure'][1][@id = $figure_id]]">
				<fn reference="{@reference}" id="{@reference}_{ancestor::*[@id][1]/@id}">
					<xsl:apply-templates />
				</fn>
			</xsl:for-each>
		</xsl:variable>
	
		<xsl:if test="xalan:nodeset($references)//fn">
		
			<xsl:variable name="key_iso">
				<xsl:if test="$namespace = 'bsi' or $namespace = 'iso' or $namespace = 'iec'  or $namespace = 'gb' or $namespace = 'jcgm'">true</xsl:if>
			</xsl:variable>
			
			<fo:block>
				<xsl:choose>
					<xsl:when test="$namespace = 'bsi'">
						<xsl:for-each select="xalan:nodeset($references)//fn">
							<xsl:variable name="reference" select="@reference"/>
							<xsl:if test="not(preceding-sibling::*[@reference = $reference])"> <!-- only unique reference puts in note-->
								<fo:list-block id="{@id}" xsl:use-attribute-sets="table-fn-style" provisional-distance-between-starts="3mm">
									<fo:list-item>
										<fo:list-item-label end-indent="label-end()">
											<fo:block xsl:use-attribute-sets="figure-fn-number-style">
												<xsl:if test="$document_type = 'PAS'">
													<xsl:attribute name="font-size">4.5pt</xsl:attribute>
												</xsl:if>
												<xsl:value-of select="@reference"/>
												<xsl:text>)</xsl:text>								
											</fo:block>
										</fo:list-item-label>
										<fo:list-item-body start-indent="body-start()" xsl:use-attribute-sets="figure-fn-body-style">>
											<fo:block margin-bottom="0">
												<xsl:copy-of select="./node()"/>
											</fo:block>
										</fo:list-item-body>
									</fo:list-item>
								</fo:list-block>
							</xsl:if>
						</xsl:for-each>
						<!-- BSI -->
					</xsl:when>
					<xsl:otherwise>
					
						<!-- current hierarchy is 'figure' element -->
						<xsl:variable name="following_dl_colwidths">
							<xsl:if test="*[local-name() = 'dl']"><!-- if there is a 'dl', then set the same columns width as for 'dl' -->
								<xsl:variable name="simple-table">
									<!-- <xsl:variable name="doc_ns">
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
									</xsl:variable> -->
									
									<xsl:for-each select="*[local-name() = 'dl'][1]">
										<tbody>
											<xsl:apply-templates mode="dl"/>
										</tbody>
									</xsl:for-each>
								</xsl:variable>
								
								<xsl:call-template name="calculate-column-widths">
									<xsl:with-param name="cols-count" select="2"/>
									<xsl:with-param name="table" select="$simple-table"/>
								</xsl:call-template>
								
							</xsl:if>
						</xsl:variable>
						
						<xsl:variable name="maxlength_dt">
							<xsl:for-each select="*[local-name() = 'dl'][1]">
								<xsl:call-template name="getMaxLength_dt"/>			
							</xsl:for-each>
						</xsl:variable>
					
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
									<fo:table-column column-width="5%"/>
									<fo:table-column column-width="95%"/>
								</xsl:otherwise>
							</xsl:choose>
							<fo:table-body>
								<xsl:for-each select="xalan:nodeset($references)//fn">
									<xsl:variable name="reference" select="@reference"/>
									<xsl:if test="not(preceding-sibling::*[@reference = $reference])"> <!-- only unique reference puts in note-->
										<fo:table-row>
											<fo:table-cell>
												<fo:block>
													<fo:inline id="{@id}" xsl:use-attribute-sets="figure-fn-number-style">
														<xsl:value-of select="@reference"/>
													</fo:inline>
												</fo:block>
											</fo:table-cell>
											<fo:table-cell>
												<fo:block xsl:use-attribute-sets="figure-fn-body-style">
													<xsl:if test="normalize-space($key_iso) = 'true'">
														<xsl:choose>
															<xsl:when test="$namespace = 'iec'"></xsl:when>
															<xsl:otherwise>
																<xsl:attribute name="margin-bottom">0</xsl:attribute>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:if>
													<xsl:copy-of select="./node()"/>
												</fo:block>
											</fo:table-cell>
										</fo:table-row>
									</xsl:if>
								</xsl:for-each>
							</fo:table-body>
						</fo:table>
					</xsl:otherwise>
				</xsl:choose>
			</fo:block>
		</xsl:if>
		
	</xsl:template> <!-- fn_display_figure -->
	
	<!-- fn reference in the text rendering (for instance, 'some text 1) some text' ) -->
	<xsl:template match="*[local-name()='fn']">
		<fo:inline xsl:use-attribute-sets="fn-reference-style">
		
			<xsl:call-template name="refine_fn-reference-style"/>
			
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
					<xsl:text>)</xsl:text>
				</xsl:if>
				<xsl:if test="$namespace = 'jis'">
					<fo:inline font-weight="normal">)</fo:inline>
				</xsl:if>
			</fo:basic-link>
		</fo:inline>
	</xsl:template>


	
	<xsl:template match="*[local-name()='fn']/text()[normalize-space() != '']">
		<fo:inline role="SKIP"><xsl:value-of select="."/></fo:inline>
	</xsl:template>
	
	<xsl:template match="*[local-name()='fn']//*[local-name()='p']">
		<fo:inline role="P">
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>
	<!-- ===================== -->
	<!-- END Footnotes processing  -->
	<!-- ===================== -->
	
	<!-- ===================== -->
	<!-- Definition List -->
	<!-- ===================== -->
	<xsl:template match="*[local-name()='dl']">
		<xsl:variable name="isAdded" select="@added"/>
		<xsl:variable name="isDeleted" select="@deleted"/>
		<!-- <dl><xsl:copy-of select="."/></dl> -->
		<fo:block-container xsl:use-attribute-sets="dl-block-style" role="SKIP">
		
			<xsl:call-template name="setBlockSpanAll"/>
		
			<xsl:choose>
				<xsl:when test="$namespace = 'bipm'">
					<xsl:if test="not(ancestor::*[local-name() = 'li'])">
						<xsl:attribute name="margin-left">0mm</xsl:attribute>
					</xsl:if>
					<xsl:if test="ancestor::*[local-name() = 'li']">
						<xsl:attribute name="margin-left">6.5mm</xsl:attribute><!-- 8 mm -->
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="not(ancestor::*[local-name() = 'quote'])">
						<xsl:attribute name="margin-left">0mm</xsl:attribute>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
			
			<xsl:if test="$namespace = 'bsi'">
				<xsl:if test="$document_type != 'PAS'">
					<xsl:attribute name="font-size">9pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			
			<xsl:if test="ancestor::*[local-name() = 'sourcecode']">
				<!-- set font-size as sourcecode font-size -->
				<xsl:variable name="sourcecode_attributes">
					<xsl:call-template name="get_sourcecode_attributes"/>
				</xsl:variable>
				<xsl:for-each select="xalan:nodeset($sourcecode_attributes)/sourcecode_attributes/@font-size">					
					<xsl:attribute name="{local-name()}">
						<xsl:value-of select="."/>
					</xsl:attribute>
				</xsl:for-each>
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
			
			<fo:block-container margin-left="0mm" role="SKIP">
			
				<xsl:choose>
					<xsl:when test="$namespace = 'bipm'"></xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="margin-right">0mm</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
				
				<xsl:variable name="parent" select="local-name(..)"/>
				
				<xsl:variable name="key_iso">
					<xsl:if test="$namespace = 'bsi' or $namespace = 'iso' or $namespace = 'iec'  or $namespace = 'gb' or $namespace = 'jcgm'">
						<xsl:if test="$parent = 'figure' or $parent = 'formula' or ../@key = 'true'">true</xsl:if>
					</xsl:if> <!-- and  (not(../@class) or ../@class !='pseudocode') -->
				</xsl:variable>
				
				<xsl:variable name="onlyOneComponent" select="normalize-space($parent = 'formula' and count(*[local-name()='dt']) = 1)"/>
				
				<xsl:choose>
					<xsl:when test="$onlyOneComponent = 'true'"> <!-- only one component -->
						<xsl:choose>
							<xsl:when test="$namespace = 'iec' or $namespace = 'gb'">
								<fo:block text-align="left">
									<xsl:if test="$namespace = 'iec'">
										<xsl:attribute name="margin-bottom">15pt</xsl:attribute>
									</xsl:if>
									<xsl:if test="$namespace = 'gb'">
										<xsl:attribute name="margin-left">7.4mm</xsl:attribute>
									</xsl:if>
									<!-- <xsl:variable name="title-where">
										<xsl:call-template name="getLocalizedString">
											<xsl:with-param name="key">where</xsl:with-param>
										</xsl:call-template>
									</xsl:variable>
									<xsl:value-of select="$title-where"/> -->
									<xsl:apply-templates select="preceding-sibling::*[1][local-name() = 'p' and @keep-with-next = 'true']/node()"/>
								</fo:block>
								<fo:block>
									<xsl:if test="$namespace = 'gb'">
										<xsl:attribute name="text-indent">7.4mm</xsl:attribute>
									</xsl:if>
									<xsl:apply-templates select="*[local-name()='dt']/*"/>
									<xsl:if test="$namespace = 'gb'">—</xsl:if>
									<xsl:text> </xsl:text>
									<xsl:apply-templates select="*[local-name()='dd']/node()" mode="inline"/>
								</fo:block>
							</xsl:when>
							<xsl:otherwise>
								<fo:block margin-bottom="12pt" text-align="left">
									<xsl:if test="$namespace = 'bsi' or $namespace = 'iso' or $namespace = 'iec' or $namespace = 'jcgm'">
										<xsl:attribute name="margin-bottom">0</xsl:attribute>
									</xsl:if>
									<!-- <xsl:variable name="title-where">
										<xsl:call-template name="getLocalizedString">
											<xsl:with-param name="key">where</xsl:with-param>
										</xsl:call-template>
									</xsl:variable>
									<xsl:value-of select="$title-where"/> -->
									<xsl:apply-templates select="preceding-sibling::*[1][local-name() = 'p' and @keep-with-next = 'true']/node()"/>
									<xsl:text>&#xA0;</xsl:text>
									<xsl:apply-templates select="*[local-name()='dt']/*"/>
									<xsl:if test="*[local-name()='dd']/node()[normalize-space() != ''][1][self::text()]">
										<xsl:text> </xsl:text>
									</xsl:if>
									<xsl:apply-templates select="*[local-name()='dd']/node()" mode="inline"/>
								</fo:block>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when> <!-- END: only one component -->
					<xsl:when test="$parent = 'formula'"> <!-- a few components -->
						<fo:block margin-bottom="12pt" text-align="left">
						
							<xsl:call-template name="refine_dl_formula_where_style"/>
						
							<!-- <xsl:variable name="title-where">
								<xsl:call-template name="getLocalizedString">
									<xsl:with-param name="key">where</xsl:with-param>
								</xsl:call-template>
							</xsl:variable>
							<xsl:value-of select="$title-where"/><xsl:if test="$namespace = 'bsi' or $namespace = 'itu'">:</xsl:if> -->
							<!-- preceding 'p' with word 'where' -->
							<xsl:apply-templates select="preceding-sibling::*[1][local-name() = 'p' and @keep-with-next = 'true']/node()"/>
						</fo:block>
					</xsl:when>  <!-- END: a few components -->
					<xsl:when test="$parent = 'figure' and  (not(../@class) or ../@class !='pseudocode')"> <!-- definition list in a figure -->
						<fo:block font-weight="bold" text-align="left" margin-bottom="12pt" keep-with-next="always">
						
							<xsl:call-template name="refine_figure_key_style"/>
						
							<xsl:variable name="title-key">
								<xsl:call-template name="getLocalizedString">
									<xsl:with-param name="key">key</xsl:with-param>
								</xsl:call-template>
							</xsl:variable>
							<xsl:value-of select="$title-key"/>
						</fo:block>
					</xsl:when>  <!-- END: definition list in a figure -->
				</xsl:choose>
				
				<!-- a few components -->
				<xsl:if test="$onlyOneComponent = 'false'">
					<fo:block role="SKIP">
					
						<xsl:call-template name="refine_multicomponent_style"/>
						
						<xsl:if test="ancestor::*[local-name() = 'dd' or local-name() = 'td']">
							<xsl:attribute name="margin-top">0</xsl:attribute>
						</xsl:if>
						
						<fo:block role="SKIP">
						
							<xsl:call-template name="refine_multicomponent_block_style"/>
							
							<xsl:apply-templates select="*[local-name() = 'name']">
								<xsl:with-param name="process">true</xsl:with-param>
							</xsl:apply-templates>
							
							<xsl:if test="$isGenerateTableIF = 'true'">
								<!-- to determine start of table -->
								<fo:block id="{concat('table_if_start_',@id)}" keep-with-next="always" font-size="1pt">Start table '<xsl:value-of select="@id"/>'.</fo:block>
							</xsl:if>
							
							<fo:table width="95%" table-layout="fixed">
							
								<xsl:if test="$isGenerateTableIF = 'true'">
									<xsl:attribute name="wrap-option">no-wrap</xsl:attribute>
								</xsl:if>
							
								<xsl:if test="$namespace = 'gb'">
									<xsl:attribute name="margin-left">-3.7mm</xsl:attribute>
								</xsl:if>
								<xsl:choose>
									<xsl:when test="normalize-space($key_iso) = 'true' and $parent = 'formula'"></xsl:when>
									<xsl:when test="normalize-space($key_iso) = 'true'">
										<xsl:attribute name="font-size">10pt</xsl:attribute>
										<xsl:if test="$namespace = 'iec'">
											<xsl:attribute name="font-size">8pt</xsl:attribute>
										</xsl:if>
										<xsl:if test="$namespace = 'bsi'">
											<xsl:if test="$document_type != 'PAS'">
												<xsl:attribute name="font-size">9pt</xsl:attribute>
											</xsl:if>
										</xsl:if>
									</xsl:when>
								</xsl:choose>
								
								<xsl:if test="$namespace = 'iho' or $namespace = 'iso'">
									<xsl:attribute name="width">100%</xsl:attribute>
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
										
										<!-- create virtual html table for dl/[dt and dd] -->
										<xsl:variable name="simple-table">
											
											<xsl:variable name="dl_table">
												<tbody>
													<xsl:apply-templates mode="dl_if">
														<xsl:with-param name="id" select="@id"/>
													</xsl:apply-templates>
												</tbody>
											</xsl:variable>
											
											<!-- dl_table='<xsl:copy-of select="$dl_table"/>' -->
											
											<!-- Step: replace <br/> to <p>...</p> -->
											<xsl:variable name="table_without_br">
												<xsl:apply-templates select="xalan:nodeset($dl_table)" mode="table-without-br"/>
											</xsl:variable>
											
											<!-- table_without_br='<xsl:copy-of select="$table_without_br"/>' -->
											
											<!-- Step: add id to each cell -->
											<!-- add <word>...</word> for each word, image, math -->
											<xsl:variable name="simple-table-id">
												<xsl:apply-templates select="xalan:nodeset($table_without_br)" mode="simple-table-id">
													<xsl:with-param name="id" select="@id"/>
												</xsl:apply-templates>
											</xsl:variable>
											
											<!-- simple-table-id='<xsl:copy-of select="$simple-table-id"/>' -->
											
											<xsl:copy-of select="xalan:nodeset($simple-table-id)"/>
											
										</xsl:variable>
										
										<!-- DEBUG: simple-table<xsl:copy-of select="$simple-table"/> -->
										
										<xsl:apply-templates select="xalan:nodeset($simple-table)" mode="process_table-if">
											<xsl:with-param name="table_or_dl">dl</xsl:with-param>
										</xsl:apply-templates>
										
									</xsl:when>
									<xsl:otherwise>
								
										<xsl:variable name="simple-table">
										
											<xsl:variable name="dl_table">
												<tbody>
													<xsl:apply-templates mode="dl">
														<xsl:with-param name="id" select="@id"/>
													</xsl:apply-templates>
												</tbody>
											</xsl:variable>
											
											<xsl:copy-of select="$dl_table"/>
										</xsl:variable>
								
										<xsl:variable name="colwidths">
											<xsl:call-template name="calculate-column-widths">
												<xsl:with-param name="cols-count" select="2"/>
												<xsl:with-param name="table" select="$simple-table"/>
											</xsl:call-template>
										</xsl:variable>
										
										<!-- <xsl:text disable-output-escaping="yes">&lt;!- -</xsl:text>
											DEBUG
											colwidths=<xsl:copy-of select="$colwidths"/>
										<xsl:text disable-output-escaping="yes">- -&gt;</xsl:text> -->
										
										<!-- colwidths=<xsl:copy-of select="$colwidths"/> -->
										
										<xsl:variable name="maxlength_dt">
											<xsl:call-template name="getMaxLength_dt"/>							
										</xsl:variable>
										
										<xsl:variable name="isContainsKeepTogetherTag_">
											<xsl:choose>
												<xsl:when test="$namespace = 'iso'">
												 <xsl:value-of select="count(.//*[local-name() = $element_name_keep-together_within-line]) &gt; 0"/>
												</xsl:when>
												<xsl:otherwise>false</xsl:otherwise>
											</xsl:choose>
										</xsl:variable>
										<xsl:variable name="isContainsKeepTogetherTag" select="normalize-space($isContainsKeepTogetherTag_)"/>
										<!-- isContainsExpressReference=<xsl:value-of select="$isContainsExpressReference"/> -->
										
										
										<xsl:call-template name="setColumnWidth_dl">
											<xsl:with-param name="colwidths" select="$colwidths"/>							
											<xsl:with-param name="maxlength_dt" select="$maxlength_dt"/>
											<xsl:with-param name="isContainsKeepTogetherTag" select="$isContainsKeepTogetherTag"/>
										</xsl:call-template>
										
										<fo:table-body>
											
											<!-- DEBUG -->
											<xsl:if test="$table_if_debug = 'true'">
												<fo:table-row>
													<fo:table-cell number-columns-spanned="2" font-size="60%">
														<xsl:apply-templates select="xalan:nodeset($colwidths)" mode="print_as_xml"/>
													</fo:table-cell>
												</fo:table-row>
											</xsl:if>

											<xsl:apply-templates>
												<xsl:with-param name="key_iso" select="normalize-space($key_iso)"/>
												<xsl:with-param name="split_keep-within-line" select="xalan:nodeset($colwidths)/split_keep-within-line"/>
											</xsl:apply-templates>
											
										</fo:table-body>
									</xsl:otherwise>
								</xsl:choose>
							</fo:table>
						</fo:block>
					</fo:block>
				</xsl:if> <!-- END: a few components -->
			</fo:block-container>
		</fo:block-container>
		
		<xsl:if test="$isGenerateTableIF = 'true'"> <!-- process nested 'dl' -->
			<xsl:apply-templates select="*[local-name() = 'dd']/*[local-name() = 'dl']"/>
		</xsl:if>
		
	</xsl:template> <!-- END: dl -->
	
	<xsl:template name="refine_dl_formula_where_style">
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="margin-bottom">3pt</xsl:attribute>
			<xsl:if test="$document_type != 'PAS'">
				<xsl:attribute name="font-size">10pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'iso' or $namespace = 'jcgm'">
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
	</xsl:template> <!-- refine_dl_formula_where_style -->
	
	<xsl:template name="refine_figure_key_style">
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
	</xsl:template> <!-- refine_figure_key_style -->
	
	<xsl:template name="refine_multicomponent_style">
		<xsl:variable name="parent" select="local-name(..)"/>
		<xsl:if test="$namespace = 'iso' or $namespace = 'jcgm'">
			<xsl:if test="$parent = 'formula'">
				<xsl:attribute name="margin-left">4mm</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bsi'">
			<xsl:if test="$parent = 'formula'">
				<xsl:attribute name="margin-left">4mm</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:if test="$document_type != 'PAS'">
				<xsl:attribute name="line-height">1.4</xsl:attribute>
				<xsl:if test="@key = 'true'">
					<xsl:attribute name="margin-top">2pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:if test="$parent = 'figure' or $parent = 'formula'">
				<xsl:attribute name="margin-left">7.4mm</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp'  or $namespace = 'nist-sp'">
			<xsl:if test="not(.//*[local-name()='dt']//*[local-name()='stem'])">
				<xsl:attribute name="margin-left">5mm</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">
			<!-- <xsl:attribute name="margin-left">7mm</xsl:attribute> -->
		</xsl:if>
	</xsl:template> <!-- refine_multicomponent_style -->
	
	<xsl:template name="refine_multicomponent_block_style">
		<xsl:variable name="parent" select="local-name(..)"/>
		<xsl:if test="$namespace = 'bsi'">
			<xsl:if test="$document_type != 'PAS' and $parent = 'formula'">
				<xsl:attribute name="margin-left">-1mm</xsl:attribute>
			</xsl:if>
		</xsl:if>
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
			<!-- <xsl:attribute name="margin-left">-3.5mm</xsl:attribute> -->
		</xsl:if>
	</xsl:template> <!-- refine_multicomponent_block_style -->
	
	<!-- ignore 'p' with 'where' in formula, before 'dl' -->
	<xsl:template match="*[local-name() = 'formula']/*[local-name() = 'p' and @keep-with-next = 'true' and following-sibling::*[1][local-name() = 'dl']]" />
	
	<xsl:template match="*[local-name() = 'dl']/*[local-name() = 'name']">
		<xsl:param name="process">false</xsl:param>
		<xsl:if test="$process = 'true'">
			<fo:block xsl:use-attribute-sets="dl-name-style">
				<xsl:apply-templates />
			</fo:block>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="setColumnWidth_dl">
		<xsl:param name="colwidths"/>		
		<xsl:param name="maxlength_dt"/>
		<xsl:param name="isContainsKeepTogetherTag"/>
		
		<!-- <colwidths><xsl:copy-of select="$colwidths"/></colwidths> -->
		
		<xsl:choose>
			<xsl:when test="xalan:nodeset($colwidths)/autolayout">
				<xsl:call-template name="insertTableColumnWidth">
					<xsl:with-param name="colwidths" select="$colwidths"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="ancestor::*[local-name()='dl']"><!-- second level, i.e. inlined table -->
				<fo:table-column column-width="50%"/>
				<fo:table-column column-width="50%"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="xalan:nodeset($colwidths)/autolayout">
						<xsl:call-template name="insertTableColumnWidth">
							<xsl:with-param name="colwidths" select="$colwidths"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$isContainsKeepTogetherTag">
						<xsl:call-template name="insertTableColumnWidth">
							<xsl:with-param name="colwidths" select="$colwidths"/>
						</xsl:call-template>
					</xsl:when>
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
						<xsl:call-template name="insertTableColumnWidth">
							<xsl:with-param name="colwidths" select="$colwidths"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="insertTableColumnWidth">
		<xsl:param name="colwidths"/>
		
		<xsl:for-each select="xalan:nodeset($colwidths)//column">
			<xsl:choose>
				<xsl:when test=". = 1 or . = 0">
					<fo:table-column column-width="proportional-column-width(2)"/>
				</xsl:when>
				<xsl:otherwise>
					<!-- <fo:table-column column-width="proportional-column-width({.})"/> -->
					<xsl:variable name="divider">
						<xsl:value-of select="@divider"/>
						<xsl:if test="not(@divider)">1</xsl:if>
					</xsl:variable>
					<fo:table-column column-width="proportional-column-width({round(. div $divider)})"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
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
	
	<!-- note in definition list: dl/note -->
	<!-- renders in the 2-column spanned table row -->
	<xsl:template match="*[local-name()='dl']/*[local-name()='note']" priority="2">
		<xsl:param name="key_iso"/>
		<!-- <tr>
			<td>NOTE</td>
			<td>
				<xsl:apply-templates />
			</td>
		</tr>
		 -->
		<!-- OLD Variant -->
		<!-- <fo:table-row>
			<fo:table-cell>
				<fo:block margin-top="6pt">
					<xsl:if test="normalize-space($key_iso) = 'true'">
						<xsl:attribute name="margin-top">0</xsl:attribute>
					</xsl:if>
					<xsl:apply-templates select="*[local-name() = 'name']" />
				</fo:block>
			</fo:table-cell>
			<fo:table-cell>
				<fo:block>
					<xsl:apply-templates select="node()[not(local-name() = 'name')]" />
				</fo:block>
			</fo:table-cell>
		</fo:table-row> -->
		<!-- <tr>
			<td number-columns-spanned="2">NOTE <xsl:apply-templates /> </td>
		</tr> 
		-->
		<fo:table-row>
			<fo:table-cell number-columns-spanned="2">
				<fo:block role="SKIP">
					<xsl:call-template name="note"/>
				</fo:block>
			</fo:table-cell>
		</fo:table-row>
	</xsl:template> <!-- END: dl/note -->
	
	<!-- virtual html table for dl/[dt and dd]  -->
	<xsl:template match="*[local-name()='dt']" mode="dl">
		<xsl:param name="id"/>
		<xsl:variable name="row_number" select="count(preceding-sibling::*[local-name()='dt']) + 1"/>
		<tr>
			<td>
				<xsl:attribute name="id">
					<xsl:value-of select="concat($id,'_',$row_number,'_1')"/>
				</xsl:attribute>
				<xsl:apply-templates />
			</td>
			<td>
				<xsl:attribute name="id">
					<xsl:value-of select="concat($id,'_',$row_number,'_2')"/>
				</xsl:attribute>
				<xsl:choose>
					<xsl:when test="$namespace = 'nist-cswp' or $namespace = 'nist-sp'">
						<xsl:if test="local-name(*[1]) != 'stem'">
							<xsl:apply-templates select="following-sibling::*[local-name()='dd'][1]">
								<xsl:with-param name="process">true</xsl:with-param>
							</xsl:apply-templates>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="following-sibling::*[local-name()='dd'][1]">
							<xsl:with-param name="process">true</xsl:with-param>
						</xsl:apply-templates>
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
		<xsl:if test="$namespace = 'nist-cswp' or $namespace = 'nist-sp'">
			<xsl:if test="local-name(*[1]) = 'stem'">
				<tr>
					<td>
						<xsl:attribute name="id">
							<xsl:value-of select="concat($id,'_',$row_number,'_1_1')"/>
						</xsl:attribute>
						<xsl:text>&#xA0;</xsl:text>
					</td>
					<td>
						<xsl:attribute name="id">
							<xsl:value-of select="concat($id,'_',$row_number,'_2_2')"/>
						</xsl:attribute>
						<xsl:apply-templates select="following-sibling::*[local-name()='dd'][1]" mode="dl_process"/>
					</td>
				</tr>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	
	<!-- Definition's term -->
	<xsl:template match="*[local-name()='dt']">
		<xsl:param name="key_iso"/>
		<xsl:param name="split_keep-within-line"/>
		
		<fo:table-row xsl:use-attribute-sets="dt-row-style">
			<xsl:if test="$namespace = 'ogc'">
				<xsl:if test="not(following-sibling::ogc:dt) or ancestor::ogc:sourcecode"> <!-- last item -->
					<xsl:attribute name="min-height">3mm</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:call-template name="insert_dt_cell">
				<xsl:with-param name="key_iso" select="$key_iso"/>
				<xsl:with-param name="split_keep-within-line" select="$split_keep-within-line"/>
			</xsl:call-template>
			<xsl:for-each select="following-sibling::*[local-name()='dd'][1]">
				<xsl:call-template name="insert_dd_cell">
					<xsl:with-param name="split_keep-within-line" select="$split_keep-within-line"/>
				</xsl:call-template>
			</xsl:for-each>
		</fo:table-row>
	</xsl:template> <!-- END: dt -->
	
	<xsl:template name="insert_dt_cell">
		<xsl:param name="key_iso"/>
		<xsl:param name="split_keep-within-line"/>
		<fo:table-cell xsl:use-attribute-sets="dt-cell-style">
		
			<xsl:if test="$isGenerateTableIF = 'true'">
				<!-- border is mandatory, to calculate real width -->
				<xsl:attribute name="border">0.1pt solid black</xsl:attribute>
				<xsl:attribute name="text-align">left</xsl:attribute>
				
				<xsl:if test="$namespace = 'ogc'">
					<xsl:attribute name="padding-left">6mm</xsl:attribute>
					<!-- <xsl:attribute name="padding-left">6.5mm</xsl:attribute> -->
				</xsl:if>
			</xsl:if>
			
			<xsl:call-template name="refine_dt-cell-style"/>
			
			<fo:block xsl:use-attribute-sets="dt-block-style" role="SKIP">
				<xsl:copy-of select="@id"/>
				
				<xsl:if test="normalize-space($key_iso) = 'true'">
					<xsl:attribute name="margin-top">0</xsl:attribute>
				</xsl:if>
				
				<xsl:call-template name="refine_dt-block-style"/>
				
				<xsl:apply-templates>
					<xsl:with-param name="split_keep-within-line" select="$split_keep-within-line"/>
				</xsl:apply-templates>
				
				<xsl:if test="$isGenerateTableIF = 'true'"><fo:inline id="{@id}_end">end</fo:inline></xsl:if> <!-- to determine width of text --> <!-- <xsl:value-of select="$hair_space"/> -->
				
			</fo:block>
		</fo:table-cell>
	</xsl:template> <!-- insert_dt_cell -->
	
	
	<xsl:template name="insert_dd_cell">
		<xsl:param name="split_keep-within-line"/>
		<fo:table-cell xsl:use-attribute-sets="dd-cell-style">
		
			<xsl:if test="$isGenerateTableIF = 'true'">
				<!-- border is mandatory, to calculate real width -->
				<xsl:attribute name="border">0.1pt solid black</xsl:attribute>
			</xsl:if>
		
			<xsl:call-template name="refine_dd-cell-style"/>
		
			<fo:block role="SKIP">
			
				<xsl:if test="$isGenerateTableIF = 'true'">
					<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
				</xsl:if>
			
				<xsl:if test="$namespace = 'itu'">
					<xsl:attribute name="text-align">justify</xsl:attribute>
				</xsl:if>

				<xsl:choose>
					<xsl:when test="$isGenerateTableIF = 'true'">
						<xsl:apply-templates> <!-- following-sibling::*[local-name()='dd'][1] -->
							<xsl:with-param name="process">true</xsl:with-param>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="."> <!-- following-sibling::*[local-name()='dd'][1] -->
							<xsl:with-param name="process">true</xsl:with-param>
							<xsl:with-param name="split_keep-within-line" select="$split_keep-within-line"/>
						</xsl:apply-templates>
					</xsl:otherwise>
				
				</xsl:choose>
				
				<xsl:if test="$isGenerateTableIF = 'true'"><fo:inline id="{@id}_end">end</fo:inline></xsl:if> <!-- to determine width of text --> <!-- <xsl:value-of select="$hair_space"/> -->
				
			</fo:block>
		</fo:table-cell>
	</xsl:template> <!-- insert_dd_cell -->
	

	
	<!-- END Definition's term -->
	
	<xsl:template match="*[local-name()='dd']" mode="dl"/>
	<xsl:template match="*[local-name()='dd']" mode="dl_process">
		<xsl:apply-templates />
	</xsl:template>
	
	<xsl:template match="*[local-name()='dd']">
		<xsl:param name="process">false</xsl:param>
		<xsl:param name="split_keep-within-line"/>
		<xsl:if test="$process = 'true'">
			<xsl:apply-templates select="@language"/>
			<xsl:apply-templates>
				<xsl:with-param name="split_keep-within-line" select="$split_keep-within-line"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*[local-name()='dd']/*" mode="inline">
		<xsl:variable name="is_inline_element_after_where">
			<xsl:if test="(local-name() = 'p') and not(preceding-sibling::node()[normalize-space() != ''])">true</xsl:if>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$is_inline_element_after_where = 'true'">
				<fo:inline><xsl:text> </xsl:text><xsl:apply-templates /></fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<!-- virtual html table for dl/[dt and dd] for IF (Intermediate Format) -->
	<xsl:template match="*[local-name()='dt']" mode="dl_if">
		<xsl:param name="id"/>
		<tr>
			<td>
				<xsl:copy-of select="node()"/>
			</td>
			<td>
				<!-- <xsl:copy-of select="following-sibling::*[local-name()='dd'][1]/node()[not(local-name() = 'dl')]"/> -->
				<xsl:apply-templates select="following-sibling::*[local-name()='dd'][1]/node()[not(local-name() = 'dl')]" mode="dl_if"/>
				<!-- get paragraphs from nested 'dl' -->
				<xsl:apply-templates select="following-sibling::*[local-name()='dd'][1]/*[local-name() = 'dl']" mode="dl_if_nested"/>
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="*[local-name()='dd']" mode="dl_if"/>
	
	<xsl:template match="*" mode="dl_if">
		<xsl:copy-of select="."/>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'p']" mode="dl_if">
		<xsl:param name="indent"/>
		<p>
			<xsl:copy-of select="@*"/>
			<xsl:value-of select="$indent"/>
			<xsl:copy-of select="node()"/>
		</p>
		
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'ul' or local-name() = 'ol']" mode="dl_if">
		<xsl:variable name="list_rendered_">
			<xsl:apply-templates select="."/>
		</xsl:variable>
		<xsl:variable name="list_rendered" select="xalan:nodeset($list_rendered_)"/>
		
		<xsl:variable name="indent">
			<xsl:for-each select="($list_rendered//fo:block[not(.//fo:block)])[1]">
				<xsl:apply-templates select="ancestor::*[@provisional-distance-between-starts]/@provisional-distance-between-starts" mode="dl_if"/>
			</xsl:for-each>
		</xsl:variable>
		
		<xsl:apply-templates mode="dl_if">
			<xsl:with-param name="indent" select="$indent"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'li']" mode="dl_if">
		<xsl:param name="indent"/>
		<xsl:apply-templates mode="dl_if">
			<xsl:with-param name="indent" select="$indent"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="@provisional-distance-between-starts" mode="dl_if">
		<xsl:variable name="value" select="round(substring-before(.,'mm'))"/>
		<!-- emulate left indent for list item -->
		<xsl:call-template name="repeat">
			<xsl:with-param name="char" select="'x'"/>
			<xsl:with-param name="count" select="$value"/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="*[local-name()='dl']" mode="dl_if_nested">
		<xsl:for-each select="*[local-name() = 'dt']">
			<p>
				<xsl:copy-of select="node()"/>
				<xsl:text> </xsl:text>
				<xsl:copy-of select="following-sibling::*[local-name()='dd'][1]/*[local-name() = 'p']/node()"/>
			</p>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="*[local-name()='dd']" mode="dl_if_nested"/>
	<!-- ===================== -->
	<!-- END Definition List -->
	<!-- ===================== -->
	
	<!-- default: ignore title in sections/p -->
	<xsl:template match="*[local-name() = 'sections']/*[local-name() = 'p'][starts-with(@class, 'zzSTDTitle')]" priority="3" />
	
	<!-- ========================= -->
	<!-- Rich text formatting -->
	<!-- ========================= -->
	<xsl:template match="*[local-name()='em']">
		<fo:inline font-style="italic">
			<xsl:call-template name="refine_italic_style"/>
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>

	<xsl:template name="refine_italic_style">
		<xsl:if test="$namespace = 'iso'">
			<xsl:if test="ancestor::*[local-name() = 'item']">
				<xsl:attribute name="role">SKIP</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:if test="$lang = 'ar'"> <!-- to prevent rendering `###` due the missing Arabic glyphs in the italic font (Times New Roman) -->
				<xsl:attribute name="font-style">normal</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*[local-name()='strong'] | *[local-name()='b']">
		<xsl:param name="split_keep-within-line"/>
		<fo:inline font-weight="bold">
		
			<xsl:call-template name="refine_strong_style"/>
			
			<xsl:apply-templates>
				<xsl:with-param name="split_keep-within-line" select="$split_keep-within-line"/>
			</xsl:apply-templates>
		</fo:inline>
	</xsl:template>
	
	<xsl:template name="refine_strong_style">
		<xsl:if test="$namespace = 'iso'">
			<xsl:if test="ancestor::*[local-name() = 'item']">
				<xsl:attribute name="role">SKIP</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:attribute name="font-family">Times New Roman</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:if test="not(parent::*[local-name() = 'termsource'])">
				<xsl:attribute name="font-weight">normal</xsl:attribute>
				<xsl:attribute name="color">black</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="ancestor::*['preferred']">
			<xsl:attribute name="role">SKIP</xsl:attribute>
		</xsl:if>
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
				<xsl:if test="$namespace = 'iho'">9.5</xsl:if>
				<xsl:if test="$namespace = 'iso'">9</xsl:if> <!-- inherit -->
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
				<xsl:if test="$namespace = 'ogc'">
					<xsl:choose>
						<xsl:when test="ancestor::*[local-name() = 'table']">8.5</xsl:when>
						<xsl:otherwise>9.5</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
				<xsl:if test="$namespace = 'ogc-white-paper'">
					<xsl:choose>
						<xsl:when test="ancestor::*[local-name() = 'table']">8.5</xsl:when>
						<xsl:otherwise>9.5</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
				<xsl:if test="$namespace = 'rsd'">
					<xsl:choose>
						<xsl:when test="ancestor::*[local-name() = 'table']">inherit</xsl:when>
						<xsl:otherwise>95%</xsl:otherwise> <!-- 110% -->
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
						<xsl:when test="ancestor::*[local-name()='note'] or ancestor::*[local-name()='example']"><xsl:value-of select="$font-size * 0.91"/>pt</xsl:when>
						<xsl:otherwise><xsl:value-of select="$font-size"/>pt</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template> <!-- tt -->
	
	<xsl:variable name="regex_url_start">^(http://|https://|www\.)?(.*)</xsl:variable>
	<xsl:template match="*[local-name()='tt']/text()" priority="2">
		<xsl:choose>
			<xsl:when test="java:replaceAll(java:java.lang.String.new(.), $regex_url_start, '$2') != ''">
				 <!-- url -->
				<xsl:call-template name="add-zero-spaces-link-java"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="add_spaces_to_sourcecode"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<xsl:template match="*[local-name()='underline']">
		<fo:inline text-decoration="underline">
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>
	
	
	<!-- ================= -->
	<!-- Added,deleted text -->
	<!-- ================= -->
	<xsl:template match="*[local-name()='add'] | *[local-name() = 'change-open-tag'] | *[local-name() = 'change-close-tag']" name="tag_add">
		<xsl:param name="skip">true</xsl:param>
		<xsl:param name="block">false</xsl:param>
		<xsl:param name="type"/>
		<xsl:param name="text-align"/>
		<xsl:choose>
			<xsl:when test="starts-with(., $ace_tag) or local-name() = 'change-open-tag' or local-name() = 'change-close-tag'"> <!-- examples: ace-tag_A1_start, ace-tag_A2_end, C1_start, AC_start, or
							<change-open-tag>A<sub>1</sub></change-open-tag>, <change-close-tag>A<sub>1</sub></change-close-tag> -->
				<xsl:choose>
					<xsl:when test="$skip = 'true' and 
					((local-name(../..) = 'note' and not(preceding-sibling::node())) or 
					(local-name(..) = 'title' and preceding-sibling::node()[1][local-name() = 'tab']) or
					local-name(..) = 'formattedref' and not(preceding-sibling::node()))
					and 
					../node()[last()][local-name() = 'add'][starts-with(text(), $ace_tag)]"><!-- start tag displayed in template name="note" and title --></xsl:when>
					<xsl:otherwise>
						<xsl:variable name="tag">
							<xsl:call-template name="insertTag">
								<xsl:with-param name="type">
									<xsl:choose>
										<xsl:when test="local-name() = 'change-open-tag'">start</xsl:when>
										<xsl:when test="local-name() = 'change-close-tag'">end</xsl:when>
										<xsl:when test="$type = ''"><xsl:value-of select="substring-after(substring-after(., $ace_tag), '_')"/> <!-- start or end --></xsl:when>
										<xsl:otherwise><xsl:value-of select="$type"/></xsl:otherwise>
									</xsl:choose>
								</xsl:with-param>
								<xsl:with-param name="kind">
									<xsl:choose>
										<xsl:when test="local-name() = 'change-open-tag' or local-name() = 'change-close-tag'">
											<xsl:value-of select="text()"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="substring(substring-before(substring-after(., $ace_tag), '_'), 1, 1)"/> <!-- A or C -->
										</xsl:otherwise>
									</xsl:choose>
								</xsl:with-param>
								<xsl:with-param name="value">
									<xsl:choose>
										<xsl:when test="local-name() = 'change-open-tag' or local-name() = 'change-close-tag'">
											<xsl:value-of select="*[local-name() = 'sub']"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="substring(substring-before(substring-after(., $ace_tag), '_'), 2)"/> <!-- 1, 2, C -->
										</xsl:otherwise>
									</xsl:choose>
								</xsl:with-param>
							</xsl:call-template>
						</xsl:variable>
						<xsl:choose>
							<xsl:when test="$block = 'false'">
								<fo:inline>
									<xsl:copy-of select="$tag"/>									
								</fo:inline>
							</xsl:when>
							<xsl:otherwise>
								<fo:block> <!-- for around figures -->
									<xsl:if test="$text-align != ''">
										<xsl:attribute name="text-align"><xsl:value-of select="$text-align"/></xsl:attribute>
									</xsl:if>
									<xsl:copy-of select="$tag"/>
								</fo:block>
							</xsl:otherwise>
						</xsl:choose>
						
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
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
	</xsl:template> <!-- add -->
	
	<xsl:template name="insertTag">
		<xsl:param name="type"/>
		<xsl:param name="kind"/>
		<xsl:param name="value"/>
		<xsl:variable name="add_width" select="string-length($value) * 20" />
		<xsl:variable name="maxwidth" select="60 + $add_width"/>
			<fo:instream-foreign-object fox:alt-text="OpeningTag" baseline-shift="-10%"><!-- alignment-baseline="middle" -->
				<xsl:attribute name="height">3.5mm</xsl:attribute> <!-- 5mm -->
				<xsl:attribute name="content-width">100%</xsl:attribute>
				<xsl:attribute name="content-width">scale-down-to-fit</xsl:attribute>
				<xsl:attribute name="scaling">uniform</xsl:attribute>
				<!-- <svg xmlns="http://www.w3.org/2000/svg" width="{$maxwidth + 32}" height="80">
					<g>
						<xsl:if test="$type = 'closing' or $type = 'end'">
							<xsl:attribute name="transform">scale(-1 1) translate(-<xsl:value-of select="$maxwidth + 32"/>,0)</xsl:attribute>
						</xsl:if>
						<polyline points="0,0 {$maxwidth},0 {$maxwidth + 30},40 {$maxwidth},80 0,80 " stroke="black" stroke-width="5" fill="white"/>
						<line x1="0" y1="0" x2="0" y2="80" stroke="black" stroke-width="20"/>
					</g>
					<text font-family="Arial" x="15" y="57" font-size="40pt">
						<xsl:if test="$type = 'closing' or $type = 'end'">
							<xsl:attribute name="x">25</xsl:attribute>
						</xsl:if>
						<xsl:value-of select="$kind"/><tspan dy="10" font-size="30pt"><xsl:value-of select="$value"/></tspan>
					</text>
				</svg> -->
				<svg xmlns="http://www.w3.org/2000/svg" width="{$maxwidth + 32}" height="80">
					<g>
						<xsl:if test="$type = 'closing' or $type = 'end'">
							<xsl:attribute name="transform">scale(-1 1) translate(-<xsl:value-of select="$maxwidth + 32"/>,0)</xsl:attribute>
						</xsl:if>
						<polyline points="0,2.5 {$maxwidth},2.5 {$maxwidth + 20},40 {$maxwidth},77.5 0,77.5" stroke="black" stroke-width="5" fill="white"/>
						<line x1="9.5" y1="0" x2="9.5" y2="80" stroke="black" stroke-width="19"/>
					</g>
					<xsl:variable name="text_x">
						<xsl:choose>
							<xsl:when test="$type = 'closing' or $type = 'end'">28</xsl:when>
							<xsl:otherwise>22</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<text font-family="Arial" x="{$text_x}" y="50" font-size="40pt">
						<xsl:value-of select="$kind"/>
					</text>
					<text font-family="Arial" x="{$text_x + 33}" y="65" font-size="38pt">
						<xsl:value-of select="$value"/>
					</text>
				</svg>
			</fo:instream-foreign-object>
	</xsl:template>
	
	<xsl:template match="*[local-name()='del']">
		<fo:inline xsl:use-attribute-sets="del-style">
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>
	<!-- ================= -->
	<!-- END Added,deleted text -->
	<!-- ================= -->
	
	<!-- highlight text -->
	<xsl:template match="*[local-name()='hi']">
		<fo:inline background-color="yellow">
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="text()[ancestor::*[local-name()='smallcap']]">
		<xsl:variable name="text" select="normalize-space(.)"/>
		<fo:inline font-size="75%" role="SKIP">
				<xsl:if test="string-length($text) &gt; 0">
					<xsl:variable name="smallCapsText">
						<xsl:call-template name="recursiveSmallCaps">
							<xsl:with-param name="text" select="$text"/>
						</xsl:call-template>
					</xsl:variable>
					<!-- merge neighboring fo:inline -->
					<xsl:for-each select="xalan:nodeset($smallCapsText)/node()">
						<xsl:choose>
							<xsl:when test="self::fo:inline and preceding-sibling::node()[1][self::fo:inline]"><!-- <xsl:copy-of select="."/> --></xsl:when>
							<xsl:when test="self::fo:inline and @font-size">
								<xsl:variable name="curr_pos" select="count(preceding-sibling::node()) + 1"/>
								<!-- <curr_pos><xsl:value-of select="$curr_pos"/></curr_pos> -->
								<xsl:variable name="next_text_" select="count(following-sibling::node()[not(local-name() = 'inline')][1]/preceding-sibling::node())"/>
								<xsl:variable name="next_text">
									<xsl:choose>
										<xsl:when test="$next_text_ = 0">99999999</xsl:when>
										<xsl:otherwise><xsl:value-of select="$next_text_ + 1"/></xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<!-- <next_text><xsl:value-of select="$next_text"/></next_text> -->
								<fo:inline>
									<xsl:copy-of select="@*"/>
									<xsl:copy-of select="./node()"/>
									<xsl:for-each select="following-sibling::node()[position() &lt; $next_text - $curr_pos]"> <!-- [self::fo:inline] -->
										<xsl:copy-of select="./node()"/>
									</xsl:for-each>
								</fo:inline>
							</xsl:when>
							<xsl:otherwise>
								<xsl:copy-of select="."/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
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
        <fo:inline font-size="{100 div 0.75}%" role="SKIP">
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
	
	<xsl:template match="*[local-name() = 'pagebreak']">
		<fo:block break-after="page"/>
		<fo:block>&#xA0;</fo:block>
		<fo:block break-after="page"/>
	</xsl:template>
	
	
	<xsl:if test="$namespace = 'iec' or $namespace = 'iho' or $namespace = 'iso'">
		<!-- ================================================================ -->
		<!-- landscape/portrait orientation processing (post-processing step) -->
		<!-- ================================================================ -->
		<xsl:template match="@*|node()" mode="landscape_portrait">
			<xsl:copy>
					<xsl:apply-templates select="@*|node()" mode="landscape_portrait"/>
			</xsl:copy>
		</xsl:template>
		
		<xsl:template match="*[local-name() = 'pagebreak'][not(following-sibling::*[1][local-name() = 'pagebreak'])]" mode="landscape_portrait">	
		
			<!-- determine pagebreak is last element before </fo:flow> or not -->
			<xsl:variable name="isLast">
				<xsl:for-each select="ancestor-or-self::*[ancestor::fo:flow]">					
					<xsl:if test="following-sibling::*">false</xsl:if>
				</xsl:for-each>
			</xsl:variable>
		
			<xsl:if test="contains($isLast, 'false')">
		
				<xsl:variable name="orientation" select="normalize-space(@orientation)"/>
				
				<xsl:variable name="tree_">
					<xsl:for-each select="ancestor::*[ancestor::fo:flow]">
						<element pos="{position()}">					
							<xsl:value-of select="name()"/>
						</element>
					</xsl:for-each>
				</xsl:variable>
				<xsl:variable name="tree" select="xalan:nodeset($tree_)"/>
			
				<!-- close fo:page-sequence (closing preceding fo elements) -->
				<xsl:for-each select="$tree//element">
					<xsl:sort data-type="number" order="descending" select="@pos"/>
					<xsl:text disable-output-escaping="yes">&lt;/</xsl:text>
						<xsl:value-of select="."/>				
					<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
				</xsl:for-each>
				<xsl:text disable-output-escaping="yes">&lt;/fo:flow&gt;</xsl:text>
				<xsl:text disable-output-escaping="yes">&lt;/fo:page-sequence&gt;</xsl:text>
				
				<!-- <pagebreak/> -->
				<!-- create a new fo:page-sequence (opening fo elements) -->
				<xsl:text disable-output-escaping="yes">&lt;fo:page-sequence master-reference="document</xsl:text><xsl:if test="$orientation != ''">-<xsl:value-of select="$orientation"/></xsl:if><xsl:text disable-output-escaping="yes">"&gt;</xsl:text>
				<fo:static-content flow-name="xsl-footnote-separator">
					<fo:block>
						<fo:leader leader-pattern="rule" leader-length="30%"/>
					</fo:block>
				</fo:static-content>
				<xsl:call-template name="insertHeaderFooter"/>					
				<xsl:text disable-output-escaping="yes">&lt;fo:flow flow-name="xsl-region-body"&gt;</xsl:text>	
				
				<xsl:for-each select="$tree//element">
					<xsl:text disable-output-escaping="yes">&lt;</xsl:text>
						<xsl:value-of select="."/>
						<xsl:for-each select="@*[local-name() != 'pos']">
							<xsl:text> </xsl:text>
							<xsl:value-of select="local-name()"/>
							<xsl:text>="</xsl:text>
							<xsl:value-of select="."/>
							<xsl:text>"</xsl:text>
						</xsl:for-each>				
					<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
				</xsl:for-each>
					
			</xsl:if>
		</xsl:template>
		<!-- ================================================================ -->
		<!-- END: landscape/portrait orientation processing (post-processing step) -->
		<!-- ================================================================ -->
	</xsl:if>
	
	
	<!-- Example: <span style="font-family:&quot;Noto Sans JP&quot;">styled text</span> -->
	<xsl:template match="*[local-name() = 'span'][@style]" priority="2">
		<xsl:variable name="styles__">
			<xsl:call-template name="split">
				<xsl:with-param name="pText" select="concat(@style,';')"/>
				<xsl:with-param name="sep" select="';'"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="quot">"</xsl:variable>
		<xsl:variable name="styles_">
			<xsl:for-each select="xalan:nodeset($styles__)/item">
				<xsl:variable name="key" select="normalize-space(substring-before(., ':'))"/>
				<xsl:variable name="value_" select="normalize-space(substring-after(translate(.,$quot,''), ':'))"/>
				<xsl:variable name="value">
					<xsl:choose>
						<!-- if font-size is digits only -->
						<xsl:when test="$key = 'font-size' and translate($value_, '0123456789', '') = ''"><xsl:value-of select="$value_"/>pt</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$value_"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:if test="$key = 'font-family' or $key = 'font-size' or $key = 'color'">
					<style name="{$key}"><xsl:value-of select="$value"/></style>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="styles" select="xalan:nodeset($styles_)"/>
		<xsl:choose>
			<xsl:when test="$styles/style">
				<fo:inline>
					<xsl:for-each select="$styles/style">
						<xsl:attribute name="{@name}"><xsl:value-of select="."/></xsl:attribute>
						<xsl:if test="$namespace = 'jis'">
							<xsl:if test="@name = 'font-family' and . = 'MS Gothic'">
								<xsl:attribute name="{@name}">IPAexGothic</xsl:attribute>
							</xsl:if>
						</xsl:if>
					</xsl:for-each>
					<xsl:apply-templates />
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- END: span[@style] -->
	
	<!-- Note: to enable the addition of character span markup with semantic styling for DIS Word output -->
	<xsl:template match="*[local-name() = 'span']">
		<xsl:apply-templates />
	</xsl:template>
	
	<!-- Don't break standard's numbers -->
	<!-- Example : <span class="stdpublisher">ISO</span> <span class="stddocNumber">10303</span>-<span class="stddocPartNumber">1</span>:<span class="stdyear">1994</span> -->
	<xsl:template match="*[local-name() = 'span'][@class = 'stdpublisher' or @class = 'stddocNumber' or @class = 'stddocPartNumber' or @class = 'stdyear']" priority="2">
		<xsl:choose>
			<xsl:when test="ancestor::*[local-name() = 'table']"><xsl:apply-templates /></xsl:when>
			<xsl:when test="following-sibling::*[2][local-name() = 'span'][@class = 'stdpublisher' or @class = 'stddocNumber' or @class = 'stddocPartNumber' or @class = 'stdyear']">
				<fo:inline keep-with-next.within-line="always"><xsl:apply-templates /></fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="text()[not(ancestor::*[local-name() = 'table']) and preceding-sibling::*[1][local-name() = 'span'][@class = 'stdpublisher' or @class = 'stddocNumber' or @class = 'stddocPartNumber' or @class = 'stdyear'] and 
	following-sibling::*[1][local-name() = 'span'][@class = 'stdpublisher' or @class = 'stddocNumber' or @class = 'stddocPartNumber' or @class = 'stdyear']]" priority="2">
		<fo:inline keep-with-next.within-line="always"><xsl:value-of select="."/></fo:inline>
	</xsl:template>
	
	<!-- ========================= -->
	<!-- END Rich text formatting -->
	<!-- ========================= -->
	
	
	
	<!-- split string 'text' by 'separator' -->
	<xsl:template name="tokenize">
		<xsl:param name="text"/>
		<xsl:param name="separator" select="' '"/>
		<xsl:choose>
		
			<xsl:when test="$isGenerateTableIF = 'true' and not(contains($text, $separator))">
				<word><xsl:value-of select="normalize-space($text)"/></word>
			</xsl:when>
			<xsl:when test="not(contains($text, $separator))">
				<word>
					<xsl:variable name="len_str_tmp" select="string-length(normalize-space($text))"/>
					<xsl:choose>
						<xsl:when test="normalize-space(translate($text, 'X', '')) = ''"> <!-- special case for keep-together.within-line -->
							<xsl:value-of select="$len_str_tmp"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="str_no_en_chars" select="normalize-space(translate($text, $en_chars, ''))"/>
							<xsl:variable name="len_str_no_en_chars" select="string-length($str_no_en_chars)"/>
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
						</xsl:otherwise>
					</xsl:choose>
				</word>
			</xsl:when>
			<xsl:otherwise>
				<word>
					<xsl:variable name="word" select="normalize-space(substring-before($text, $separator))"/>
					<xsl:choose>
						<xsl:when test="$isGenerateTableIF = 'true'">
							<xsl:value-of select="$word"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string-length($word)"/>
						</xsl:otherwise>
					</xsl:choose>
				</word>
				<xsl:call-template name="tokenize">
					<xsl:with-param name="text" select="substring-after($text, $separator)"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<!-- split string 'text' by 'separator', enclosing in formatting tags -->
	<xsl:template name="tokenize_with_tags">
		<xsl:param name="tags"/>
		<xsl:param name="text"/>
		<xsl:param name="separator" select="' '"/>
		<xsl:choose>
		
			<xsl:when test="not(contains($text, $separator))">
				<word>
					<xsl:if test="ancestor::*[local-name() = 'p'][@from_dl = 'true']">
						<xsl:text>&#xa;&#xa0;</xsl:text> <!-- to add distance between dt and dd -->
					</xsl:if>
					<xsl:call-template name="enclose_text_in_tags">
						<xsl:with-param name="text" select="normalize-space($text)"/>
						<xsl:with-param name="tags" select="$tags"/>
					</xsl:call-template>
				</word>
			</xsl:when>
			<xsl:otherwise>
				<word>
					<xsl:if test="ancestor::*[local-name() = 'p'][@from_dl = 'true']">
						<xsl:text>&#xa;&#xa0;</xsl:text> <!-- to add distance between dt and dd -->
					</xsl:if>
					<xsl:call-template name="enclose_text_in_tags">
						<xsl:with-param name="text" select="normalize-space(substring-before($text, $separator))"/>
						<xsl:with-param name="tags" select="$tags"/>
					</xsl:call-template>
				</word>
				<xsl:call-template name="tokenize_with_tags">
					<xsl:with-param name="text" select="substring-after($text, $separator)"/>
					<xsl:with-param name="tags" select="$tags"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	

	<xsl:template name="enclose_text_in_tags">
		<xsl:param name="text"/>
		<xsl:param name="tags"/>
		<xsl:param name="num">1</xsl:param> <!-- default (start) value -->
		
		<xsl:variable name="tag_name" select="normalize-space(xalan:nodeset($tags)//tag[$num])"/>
		
		<xsl:choose>
			<xsl:when test="$tag_name = ''"><xsl:value-of select="$text"/></xsl:when>
			<xsl:otherwise>
				<xsl:element name="{$tag_name}">
					<xsl:call-template name="enclose_text_in_tags">
						<xsl:with-param name="text" select="$text"/>
						<xsl:with-param name="tags" select="$tags"/>
						<xsl:with-param name="num" select="$num + 1"/>
					</xsl:call-template>
				</xsl:element>
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
		
		<!-- add zero-width space (#x200B) after dot with next non-digit -->
		<xsl:variable name="text1" select="java:replaceAll(java:java.lang.String.new($text),'(\.)([^\d\s])','$1&#x200B;$2')"/>
		<!-- add zero-width space (#x200B) after characters: dash, equal, underscore, em dash, thin space, arrow right, ;   -->
		<xsl:variable name="text2" select="java:replaceAll(java:java.lang.String.new($text1),'(-|=|_|—| |→|;)','$1&#x200B;')"/>
		<!-- add zero-width space (#x200B) after characters: colon, if there aren't digits after -->
		<xsl:variable name="text3" select="java:replaceAll(java:java.lang.String.new($text2),'(:)(\D)','$1&#x200B;$2')"/>
		<!-- add zero-width space (#x200B) after characters: 'great than' -->
		<xsl:variable name="text4" select="java:replaceAll(java:java.lang.String.new($text3), '(\u003e)(?!\u003e)', '$1&#x200B;')"/><!-- negative lookahead: 'great than' not followed by 'great than' -->
		<!-- add zero-width space (#x200B) before characters: 'less than' -->
		<xsl:variable name="text5" select="java:replaceAll(java:java.lang.String.new($text4), '(?&lt;!\u003c)(\u003c)', '&#x200B;$1')"/> <!-- (?<!\u003c)(\u003c) --> <!-- negative lookbehind: 'less than' not preceeded by 'less than' -->
		<!-- add zero-width space (#x200B) before character: { -->
		<xsl:variable name="text6" select="java:replaceAll(java:java.lang.String.new($text5), '(?&lt;!\W)(\{)', '&#x200B;$1')"/> <!-- negative lookbehind: '{' not preceeded by 'punctuation char' -->
		<!-- add zero-width space (#x200B) after character: , -->
		<xsl:variable name="text7" select="java:replaceAll(java:java.lang.String.new($text6), '(\,)(?!\d)', '$1&#x200B;')"/> <!-- negative lookahead: ',' not followed by digit -->
		<!-- add zero-width space (#x200B) after character: '/' -->
		<xsl:variable name="text8" select="java:replaceAll(java:java.lang.String.new($text7), '(\u002f)(?!\u002f)', '$1&#x200B;')"/><!-- negative lookahead: '/' not followed by '/' -->
		
		
		<xsl:variable name="text9">
			<xsl:choose>
				<xsl:when test="$isGenerateTableIF = 'true'">
					<xsl:value-of select="java:replaceAll(java:java.lang.String.new($text8), '([\u3000-\u9FFF])', '$1&#x200B;')"/> <!-- 3000 - CJK Symbols and Punctuation ... 9FFF CJK Unified Ideographs-->
				</xsl:when>
				<xsl:otherwise><xsl:value-of select="$text8"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<!-- replace sequence #x200B to one &#x200B -->
		<xsl:variable name="text10" select="java:replaceAll(java:java.lang.String.new($text9), '\u200b{2,}', '&#x200B;')"/>
		
		<!-- replace sequence #x200B and space TO space -->
		<xsl:variable name="text11" select="java:replaceAll(java:java.lang.String.new($text10), '\u200b ', ' ')"/>
		
		<xsl:value-of select="$text11"/>
	</xsl:template>
	
	<xsl:template name="add-zero-spaces-link-java">
		<xsl:param name="text" select="."/>
		
		<xsl:value-of select="java:replaceAll(java:java.lang.String.new($text), $regex_url_start, '$1')"/> <!-- http://. https:// or www. -->
		<xsl:variable name="url_continue" select="java:replaceAll(java:java.lang.String.new($text), $regex_url_start, '$2')"/>
		<!-- add zero-width space (#x200B) after characters: dash, dot, colon, equal, underscore, em dash, thin space, comma, slash, @  -->
		<xsl:variable name="url" select="java:replaceAll(java:java.lang.String.new($url_continue),'(-|\.|:|=|_|—| |,|/|@)','$1&#x200B;')"/>
		
		<!-- replace sequence #x200B to one &#x200B -->
		<xsl:variable name="url2" select="java:replaceAll(java:java.lang.String.new($url), '\u200b{2,}', '&#x200B;')"/>
		
		<!-- remove zero-width space at the end -->
		<xsl:value-of select="java:replaceAll(java:java.lang.String.new($url2), '&#x200B;$', '')"/>
	</xsl:template>
	
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
		<xsl:variable name="regex_zero-space-after-equals">(==========)</xsl:variable>
		<xsl:variable name="zero-space-after-equal">=</xsl:variable>
		<xsl:variable name="regex_zero-space-after-equal">(=)</xsl:variable>
		<xsl:variable name="zero-space">&#x200B;</xsl:variable>
		<xsl:choose>
			<xsl:when test="contains($text, $zero-space-after-equals)">
				<!-- <xsl:value-of select="substring-before($text, $zero-space-after-equals)"/>
				<xsl:value-of select="$zero-space-after-equals"/>
				<xsl:value-of select="$zero-space"/>
				<xsl:call-template name="add-zero-spaces-equal">
					<xsl:with-param name="text" select="substring-after($text, $zero-space-after-equals)"/>
				</xsl:call-template> -->
				<xsl:value-of select="java:replaceAll(java:java.lang.String.new(.),$regex_zero-space-after-equals,concat('$1',$zero_width_space))"/>
			</xsl:when>
			<xsl:when test="contains($text, $zero-space-after-equal)">
				<!-- <xsl:value-of select="substring-before($text, $zero-space-after-equal)"/>
				<xsl:value-of select="$zero-space-after-equal"/>
				<xsl:value-of select="$zero-space"/>
				<xsl:call-template name="add-zero-spaces-equal">
					<xsl:with-param name="text" select="substring-after($text, $zero-space-after-equal)"/>
				</xsl:call-template> -->
				<xsl:value-of select="java:replaceAll(java:java.lang.String.new(.),$regex_zero-space-after-equal,concat('$1',$zero_width_space))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>  
	
	<!-- Table normalization (colspan,rowspan processing for adding TDs) for column width calculation -->
	<xsl:template name="getSimpleTable">
		<xsl:param name="id"/>
		
		<!-- <test0>
			<xsl:copy-of select="."/>
		</test0> -->
		
		<xsl:variable name="simple-table">
		
			<!-- Step 0. replace <br/> to <p>...</p> -->
			<xsl:variable name="table_without_br">
				<xsl:apply-templates mode="table-without-br"/>
			</xsl:variable>
		
			<!-- Step 1. colspan processing -->
			<xsl:variable name="simple-table-colspan">
				<tbody>
					<xsl:apply-templates select="xalan:nodeset($table_without_br)" mode="simple-table-colspan"/>
				</tbody>
			</xsl:variable>
			
			<!-- Step 2. rowspan processing -->
			<xsl:variable name="simple-table-rowspan">
				<xsl:apply-templates select="xalan:nodeset($simple-table-colspan)" mode="simple-table-rowspan"/>
			</xsl:variable>
			
			<!-- Step 3: add id to each cell -->
			<!-- add <word>...</word> for each word, image, math -->
			<xsl:variable name="simple-table-id">
				<xsl:apply-templates select="xalan:nodeset($simple-table-rowspan)" mode="simple-table-id">
					<xsl:with-param name="id" select="$id"/>
				</xsl:apply-templates>
			</xsl:variable>
			
			<xsl:copy-of select="xalan:nodeset($simple-table-id)"/>

		</xsl:variable>
		<xsl:copy-of select="$simple-table"/>
	</xsl:template>
	
	<!-- ================================== -->
	<!-- Step 0. replace <br/> to <p>...</p> -->
	<!-- ================================== -->
	<xsl:template match="@*|node()" mode="table-without-br">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="table-without-br"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="*[local-name()='th' or local-name() = 'td'][not(*[local-name()='br']) and not(*[local-name()='p']) and not(*[local-name()='sourcecode']) and not(*[local-name()='ul']) and not(*[local-name()='ol'])]" mode="table-without-br">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<p>
				<xsl:copy-of select="node()"/>
			</p>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="*[local-name()='th' or local-name()='td'][*[local-name()='br']]" mode="table-without-br">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:for-each select="*[local-name()='br']">
				<xsl:variable name="current_id" select="generate-id()"/>
				<p>
					<xsl:for-each select="preceding-sibling::node()[following-sibling::*[local-name() = 'br'][1][generate-id() = $current_id]][not(local-name() = 'br')]">
						<xsl:copy-of select="."/>
					</xsl:for-each>
				</p>
				<xsl:if test="not(following-sibling::*[local-name() = 'br'])">
					<p>
						<xsl:for-each select="following-sibling::node()">
							<xsl:copy-of select="."/>
						</xsl:for-each>
					</p>
				</xsl:if>
			</xsl:for-each>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="*[local-name()='th' or local-name()='td']/*[local-name() = 'p'][*[local-name()='br']]" mode="table-without-br">
		<xsl:for-each select="*[local-name()='br']">
			<xsl:variable name="current_id" select="generate-id()"/>
			<p>
				<xsl:for-each select="preceding-sibling::node()[following-sibling::*[local-name() = 'br'][1][generate-id() = $current_id]][not(local-name() = 'br')]">
					<xsl:copy-of select="."/>
				</xsl:for-each>
			</p>
			<xsl:if test="not(following-sibling::*[local-name() = 'br'])">
				<p>
					<xsl:for-each select="following-sibling::node()">
						<xsl:copy-of select="."/>
					</xsl:for-each>
				</p>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>


	<xsl:template match="*[local-name()='th' or local-name()='td']/*[local-name() = 'sourcecode']" mode="table-without-br">
		<xsl:apply-templates mode="table-without-br"/>
	</xsl:template>
	
	<xsl:template match="*[local-name()='th' or local-name()='td']/*[local-name() = 'sourcecode']/text()[contains(., '&#x0d;') or contains(., '&#x0a;')]" mode="table-without-br">
	
		<xsl:variable name="sep">###SOURCECODE_NEWLINE###</xsl:variable>
		<xsl:variable name="sourcecode_text" select="java:replaceAll(java:java.lang.String.new(.),'(&#x0d;&#x0a;|&#x0d;|&#x0a;)', $sep)"/>
		<xsl:variable name="items">
			<xsl:call-template name="split">
				<xsl:with-param name="pText" select="$sourcecode_text"/>
				<xsl:with-param name="sep" select="$sep"/>
				<xsl:with-param name="normalize-space">false</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:for-each select="xalan:nodeset($items)/*">
			<p>
				<sourcecode><xsl:copy-of select="node()"/></sourcecode>
			</p>
		</xsl:for-each>
	</xsl:template>
	
	<!-- remove redundant white spaces -->
	<xsl:template match="text()[not(ancestor::*[local-name() = 'sourcecode'])]" mode="table-without-br">
		<xsl:variable name="text" select="translate(.,'&#x09;&#x0a;&#x0d;','')"/>
		<xsl:value-of select="java:replaceAll(java:java.lang.String.new($text),' {2,}',' ')"/>
	</xsl:template>

	<xsl:template match="*[local-name()='th' or local-name()='td']//*[local-name() = 'ol' or local-name() = 'ul']" mode="table-without-br">
		<xsl:apply-templates mode="table-without-br"/>
	</xsl:template>
	
	<xsl:template match="*[local-name()='th' or local-name()='td']//*[local-name() = 'li']" mode="table-without-br">
		<xsl:apply-templates mode="table-without-br"/>
	</xsl:template>
	
	<!-- mode="table-without-br" -->
	<!-- ================================== -->
	<!-- END: Step 0. replace <br/> to <p>...</p> -->
	<!-- ================================== -->

	
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
					<xsl:element name="{local-name()}">
						<xsl:attribute name="divide"><xsl:value-of select="@colspan"/></xsl:attribute>
						<xsl:if test="local-name()='th'">
							<xsl:attribute name="font-weight">bold</xsl:attribute>
						</xsl:if>
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
				<xsl:element name="{local-name()}">
					<xsl:apply-templates select="@*" mode="simple-table-colspan"/>
					<xsl:if test="local-name()='th'">
						<xsl:attribute name="font-weight">bold</xsl:attribute>
					</xsl:if>
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
				<xsl:for-each select="xalan:nodeset($previousRow)//*[self::td or self::th]">
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
										<xsl:copy-of select="$currentRow/*[self::td or self::th][1 + count(current()/preceding-sibling::*[self::td or self::th][not(@rowspan) or (@rowspan = 1)])]" />
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

		<!-- optimize to prevent StackOverflowError, just copy next 'tr' -->
		<xsl:variable name="currrow_num" select="count(preceding-sibling::tr) + 1"/>
		<xsl:variable name="nextrow_without_rowspan_" select="count(following-sibling::tr[*[@rowspan and @rowspan != 1]][1]/preceding-sibling::tr) + 1"/>
		<xsl:variable name="nextrow_without_rowspan" select="$nextrow_without_rowspan_ - $currrow_num"/>
		<xsl:choose>
			<xsl:when test="not(xalan:nodeset($newRow)/*/*[@rowspan and @rowspan != 1]) and $nextrow_without_rowspan &lt;= 0">
				<xsl:copy-of select="following-sibling::tr"/>
			</xsl:when>
			<!-- <xsl:when test="xalan:nodeset($newRow)/*[not(@rowspan) or (@rowspan = 1)] and $nextrow_without_rowspan &gt; 0">
				<xsl:copy-of select="following-sibling::tr[position() &lt;= $nextrow_without_rowspan]"/>
				
				<xsl:copy-of select="following-sibling::tr[$nextrow_without_rowspan + 1]"/>
				<xsl:apply-templates select="following-sibling::tr[$nextrow_without_rowspan + 2]" mode="simple-table-rowspan">
						<xsl:with-param name="previousRow" select="following-sibling::tr[$nextrow_without_rowspan + 1]"/>
				</xsl:apply-templates>
			</xsl:when> -->
			<xsl:otherwise>
				<xsl:apply-templates select="following-sibling::tr[1]" mode="simple-table-rowspan">
						<xsl:with-param name="previousRow" select="$newRow"/>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- End mode simple-table-rowspan  -->
	
	<!-- Step 3: add id for each cell -->
	<!-- mode: simple-table-id -->
	<xsl:template match="/" mode="simple-table-id">
		<xsl:param name="id"/>
		<xsl:variable name="id_prefixed" select="concat('table_if_',$id)"/> <!-- table id prefixed by 'table_if_' to simple search in IF  -->
		<xsl:apply-templates select="@*|node()" mode="simple-table-id">
			<xsl:with-param name="id" select="$id_prefixed"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="@*|node()" mode="simple-table-id">
		<xsl:param name="id"/>
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="simple-table-id">
					<xsl:with-param name="id" select="$id"/>
				</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="*[local-name()='tbody']" mode="simple-table-id">
		<xsl:param name="id"/>
		<xsl:copy>
			<xsl:copy-of select="@*" />
			<xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute>
			<xsl:apply-templates select="node()" mode="simple-table-id">
				<xsl:with-param name="id" select="$id"/>
			</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>
	
	<xsl:variable name="font_main_root_style">
		<root-style xsl:use-attribute-sets="root-style">
		</root-style>
	</xsl:variable>
	<xsl:variable name="font_main_root_style_font_family" select="xalan:nodeset($font_main_root_style)/root-style/@font-family"/>
	<xsl:variable name="font_main">
		<xsl:choose>
			<xsl:when test="contains($font_main_root_style_font_family, ',')"><xsl:value-of select="substring-before($font_main_root_style_font_family, ',')"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$font_main_root_style_font_family"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:template match="*[local-name()='th' or local-name()='td']" mode="simple-table-id">
		<xsl:param name="id"/>
		<xsl:copy>
			<xsl:copy-of select="@*" />
			<xsl:variable name="row_number" select="count(../preceding-sibling::*) + 1"/>
			<xsl:variable name="col_number" select="count(preceding-sibling::*) + 1"/>
			<xsl:variable name="divide">
				<xsl:choose>
					<xsl:when test="@divide"><xsl:value-of select="@divide"/></xsl:when>
					<xsl:otherwise>1</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:attribute name="id">
				<xsl:value-of select="concat($id,'_',$row_number,'_',$col_number,'_',$divide)"/>
			</xsl:attribute>
			
			<xsl:for-each select="*[local-name() = 'p']">
				<xsl:copy>
					<xsl:copy-of select="@*" />
					<xsl:variable name="p_num" select="count(preceding-sibling::*[local-name() = 'p']) + 1"/>
					<xsl:attribute name="id">
						<xsl:value-of select="concat($id,'_',$row_number,'_',$col_number,'_p_',$p_num,'_',$divide)"/>
					</xsl:attribute>
					
					<!-- <xsl:copy-of select="node()" /> -->
					<xsl:apply-templates mode="simple-table-noid"/>
					
				</xsl:copy>
			</xsl:for-each>
			
			
			<xsl:if test="$isGenerateTableIF = 'true'"> <!-- split each paragraph to words, image, math -->
			
				<xsl:variable name="td_text">
					<xsl:apply-templates select="." mode="td_text_with_formatting"/>
				</xsl:variable>
				
				<!-- td_text='<xsl:copy-of select="$td_text"/>' -->
			
				<xsl:variable name="words_with_width">
					<!-- calculate width for 'word' which contain text only (without formatting tags inside) -->
					<xsl:for-each select="xalan:nodeset($td_text)//*[local-name() = 'word'][normalize-space() != ''][not(*)]">
						<xsl:copy>
							<xsl:copy-of select="@*"/>
							<xsl:attribute name="width">
								<xsl:value-of select="java:org.metanorma.fop.Util.getStringWidth(., $font_main)"/> <!-- Example: 'Times New Roman' -->
							</xsl:attribute>
							<xsl:copy-of select="node()"/>
						</xsl:copy>
					</xsl:for-each>
				</xsl:variable>
			
				<xsl:variable name="words_with_width_sorted">
					<xsl:for-each select="xalan:nodeset($words_with_width)//*[local-name() = 'word']">
						<xsl:sort select="@width" data-type="number" order="descending"/>
						<!-- select word maximal width only -->
						<xsl:if test="position() = 1">
							<xsl:copy-of select="."/>
						</xsl:if>
					</xsl:for-each>
					<!-- add 'word' with formatting tags inside -->
					<xsl:for-each select="xalan:nodeset($td_text)//*[local-name() = 'word'][normalize-space() != ''][*]">
						<xsl:copy-of select="."/>
					</xsl:for-each>
				</xsl:variable>
			
				<xsl:variable name="words">
					<xsl:for-each select=".//*[local-name() = 'image' or local-name() = 'stem']">
						<word>
							<xsl:copy-of select="."/>
						</word>
					</xsl:for-each>
					
					<xsl:for-each select="xalan:nodeset($words_with_width_sorted)//*[local-name() = 'word'][normalize-space() != '']">
						<xsl:copy-of select="."/>
					</xsl:for-each>
					<!-- <xsl:for-each select="xalan:nodeset($td_text)//*[local-name() = 'word'][normalize-space() != '']">
						<xsl:copy-of select="."/>
					</xsl:for-each> -->
					
				</xsl:variable>
				
				<xsl:for-each select="xalan:nodeset($words)/word">
					<xsl:variable name="num" select="count(preceding-sibling::word) + 1"/>
					<xsl:copy>
						<xsl:attribute name="id">
							<xsl:value-of select="concat($id,'_',$row_number,'_',$col_number,'_word_',$num,'_',$divide)"/>
						</xsl:attribute>
						<xsl:copy-of select="node()" />
					</xsl:copy>
				</xsl:for-each>
			</xsl:if>
		</xsl:copy>
		
	</xsl:template>
	
	<xsl:template match="*[local-name()='th' or local-name()='td']/*[local-name() = 'p']//*" mode="simple-table-noid">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="$isGenerateTableIF = 'true'">
					<xsl:copy-of select="@*[local-name() != 'id']"/> <!-- to prevent repeat id in colspan/rowspan cells -->
					<!-- <xsl:if test="local-name() = 'dl' or local-name() = 'table'">
						<xsl:copy-of select="@id"/>
					</xsl:if> -->
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="@*"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates select="node()" mode="simple-table-noid"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- End mode: simple-table-id -->
	<!-- ===================== -->	
	<!-- ===================== -->	

	
	<!-- =============================== -->
	<!-- mode="td_text_with_formatting" -->
	<!-- =============================== -->
	<xsl:template match="@*|node()" mode="td_text_with_formatting">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="td_text_with_formatting"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[local-name() = 'stem' or local-name() = 'image']" mode="td_text_with_formatting"/>

	<xsl:template match="*[local-name() = 'keep-together_within-line']/text()" mode="td_text_with_formatting">
		<xsl:variable name="formatting_tags">
			<xsl:call-template name="getFormattingTags"/>
		</xsl:variable>
		<word>
			<xsl:call-template name="enclose_text_in_tags">
				<xsl:with-param name="text" select="normalize-space(.)"/>
				<xsl:with-param name="tags" select="$formatting_tags"/>
			</xsl:call-template>
		</word>
	</xsl:template>

	<xsl:template match="*[local-name() != 'keep-together_within-line']/text()" mode="td_text_with_formatting">
		
		<xsl:variable name="td_text" select="."/>
		
		<xsl:variable name="string_with_added_zerospaces">
			<xsl:call-template name="add-zero-spaces-java">
				<xsl:with-param name="text" select="$td_text"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="formatting_tags">
			<xsl:call-template name="getFormattingTags"/>
		</xsl:variable>
		
		<!-- <word>text</word> -->
		<xsl:call-template name="tokenize_with_tags">
			<xsl:with-param name="tags" select="$formatting_tags"/>
			<xsl:with-param name="text" select="normalize-space(translate($string_with_added_zerospaces, '&#x200B;&#xAD;', '  '))"/> <!-- replace zero-width-space and soft-hyphen to space -->
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="*[local-name() = 'link'][normalize-space() = '']" mode="td_text_with_formatting">
		<xsl:variable name="link">
			<link_updated>
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
				<xsl:value-of select="$target_text"/>
			</link_updated>
		</xsl:variable>
		<xsl:for-each select="xalan:nodeset($link)/*">
			<xsl:apply-templates mode="td_text_with_formatting"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="getFormattingTags">
		<tags>
			<xsl:if test="ancestor::*[local-name() = 'strong']"><tag>strong</tag></xsl:if>
			<xsl:if test="ancestor::*[local-name() = 'em']"><tag>em</tag></xsl:if>
			<xsl:if test="ancestor::*[local-name() = 'sub']"><tag>sub</tag></xsl:if>
			<xsl:if test="ancestor::*[local-name() = 'sup']"><tag>sup</tag></xsl:if>
			<xsl:if test="ancestor::*[local-name() = 'tt']"><tag>tt</tag></xsl:if>
			<xsl:if test="ancestor::*[local-name() = 'sourcecode']"><tag>sourcecode</tag></xsl:if>
			<xsl:if test="ancestor::*[local-name() = 'keep-together_within-line']"><tag>keep-together_within-line</tag></xsl:if>
		</tags>
	</xsl:template>
	<!-- =============================== -->
	<!-- END mode="td_text_with_formatting" -->
	<!-- =============================== -->


	<xsl:template name="getLang">
		<xsl:variable name="language_current" select="normalize-space(//*[local-name()='bibdata']//*[local-name()='language'][@current = 'true'])"/>
		<xsl:variable name="language">
			<xsl:choose>
				<xsl:when test="$language_current != ''">
					<xsl:value-of select="$language_current"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="language_current_2" select="normalize-space(xalan:nodeset($bibdata)//*[local-name()='bibdata']//*[local-name()='language'][@current = 'true'])"/>
					<xsl:choose>
						<xsl:when test="$language_current_2 != ''">
							<xsl:value-of select="$language_current_2"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="//*[local-name()='bibdata']//*[local-name()='language']"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="$language = 'English'">en</xsl:when>
			<xsl:otherwise><xsl:value-of select="$language"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="getLang_fromCurrentNode">
		<xsl:variable name="language_current" select="normalize-space(.//*[local-name()='bibdata']//*[local-name()='language'][@current = 'true'])"/>
		<xsl:variable name="language">
			<xsl:choose>
				<xsl:when test="$language_current != ''">
					<xsl:value-of select="$language_current"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="language_current_2" select="normalize-space(xalan:nodeset($bibdata)//*[local-name()='bibdata']//*[local-name()='language'][@current = 'true'])"/>
					<xsl:choose>
						<xsl:when test="$language_current_2 != ''">
							<xsl:value-of select="$language_current_2"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select=".//*[local-name()='bibdata']//*[local-name()='language']"/>
						</xsl:otherwise>
					</xsl:choose>
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
				<xsl:call-template name="capitalize">
					<xsl:with-param name="str" select="$substr"/>
				</xsl:call-template>
				<xsl:text> </xsl:text>
				<xsl:call-template name="capitalizeWords">
					<xsl:with-param name="str" select="substring-after($str2, ' ')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
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
	
	
	<!-- ======================================= -->
	<!-- math -->
	<!-- ======================================= -->
	<xsl:template match="mathml:math">
		<xsl:variable name="isAdded" select="@added"/>
		<xsl:variable name="isDeleted" select="@deleted"/>
		
		<fo:inline xsl:use-attribute-sets="mathml-style">
		
			<!-- DEBUG -->
			<!-- <xsl:copy-of select="ancestor::*[local-name() = 'stem']/@font-family"/> -->
    
			<xsl:call-template name="refine_mathml-style"/>
		
			<xsl:if test="$isGenerateTableIF = 'true' and ancestor::*[local-name() = 'td' or local-name() = 'th' or local-name() = 'dl'] and not(following-sibling::node()[not(self::comment())][normalize-space() != ''])"> <!-- math in table cell, and math is last element -->
				<!-- <xsl:attribute name="padding-right">1mm</xsl:attribute> -->
			</xsl:if>
			
			<xsl:call-template name="setTrackChangesStyles">
				<xsl:with-param name="isAdded" select="$isAdded"/>
				<xsl:with-param name="isDeleted" select="$isDeleted"/>
			</xsl:call-template>
			
			<xsl:if test="$add_math_as_text = 'true'">
				<!-- insert helper tag -->
				<!-- set unique font-size (fiction) -->
				<xsl:variable name="font-size_sfx"><xsl:number level="any"/></xsl:variable>
				<fo:inline color="white" font-size="1.{$font-size_sfx}pt" font-style="normal" font-weight="normal"><xsl:value-of select="$zero_width_space"/></fo:inline> <!-- zero width space -->
			</xsl:if>
			
			<xsl:variable name="mathml_content">
				<xsl:apply-templates select="." mode="mathml_actual_text"/>
			</xsl:variable>
			
			<xsl:choose>
				<xsl:when test="$namespace = 'bipm'">
					<xsl:variable name="filename" select="xalan:nodeset($mathml_attachments)//attachment[. = $mathml_content]/@filename"/>
					<xsl:choose>
						<xsl:when test="$add_math_as_attachment = 'true' and normalize-space($filename) != ''">
							<xsl:variable name="url" select="concat('url(embedded-file:', $filename, ')')"/>
							<fo:basic-link external-destination="{$url}" fox:alt-text="MathLink">
								<xsl:variable name="asciimath_text">
									<!-- <xsl:call-template name="getMathml_comment_text"/> -->
									<xsl:call-template name="getMathml_asciimath_text"/>
								</xsl:variable>
								<xsl:if test="normalize-space($asciimath_text) != ''">
								<!-- put Mathin Alternate Text -->
									<xsl:attribute name="fox:alt-text">
										<xsl:value-of select="$asciimath_text"/>
									</xsl:attribute>
								</xsl:if>
								<xsl:call-template name="mathml_instream_object">
									<xsl:with-param name="asciimath_text" select="$asciimath_text"/>
									<xsl:with-param name="mathml_content" select="$mathml_content"/>
								</xsl:call-template>
							</fo:basic-link>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="mathml_instream_object">
								<xsl:with-param name="mathml_content" select="$mathml_content"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
					<!-- end BIPM -->
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="mathml_instream_object">
						<xsl:with-param name="mathml_content" select="$mathml_content"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
			
		</fo:inline>
	</xsl:template>


	<xsl:template name="getMathml_comment_text">
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
		<xsl:variable name="comment_text_2" select="java:org.metanorma.fop.Util.unescape($comment_text_)"/>
		<xsl:variable name="comment_text" select="java:trim(java:java.lang.String.new($comment_text_2))"/>
		<xsl:value-of select="$comment_text"/>
	</xsl:template>

	<xsl:template match="*[local-name() = 'asciimath']">
		<xsl:param name="process" select="'false'"/>
		<xsl:if test="$process = 'true'">
			<xsl:apply-templates />
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'latexmath']"/>
	
	<xsl:template name="getMathml_asciimath_text">
		<xsl:variable name="asciimath" select="../*[local-name() = 'asciimath']"/>
		<xsl:variable name="latexmath">
			<xsl:if test="$namespace = 'ieee'">
				<xsl:value-of select="../*[local-name() = 'latexmath']"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="asciimath_text_following">
			<xsl:choose>
				<xsl:when test="normalize-space($latexmath) != ''">
					<xsl:value-of select="$latexmath"/>
				</xsl:when>
				<xsl:when test="normalize-space($asciimath) != ''">
					<xsl:value-of select="$asciimath"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="following-sibling::node()[1][self::comment()]"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="asciimath_text_">
			<xsl:choose>
				<xsl:when test="normalize-space($asciimath_text_following) != ''">
					<xsl:value-of select="$asciimath_text_following"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space(translate(.,'&#xa0;&#8290;','  '))"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable> 
		<xsl:variable name="asciimath_text_2" select="java:org.metanorma.fop.Util.unescape($asciimath_text_)"/>
		<xsl:variable name="asciimath_text" select="java:trim(java:java.lang.String.new($asciimath_text_2))"/>
		<xsl:value-of select="$asciimath_text"/>
	</xsl:template>


	<xsl:template name="mathml_instream_object">
		<xsl:param name="asciimath_text"/>
		<xsl:param name="mathml_content"/>
	
		<xsl:variable name="asciimath_text_">
			<xsl:choose>
				<xsl:when test="normalize-space($asciimath_text) != ''"><xsl:value-of select="$asciimath_text"/></xsl:when>
				<!-- <xsl:otherwise><xsl:call-template name="getMathml_comment_text"/></xsl:otherwise> -->
				<xsl:otherwise><xsl:call-template name="getMathml_asciimath_text"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
	
		<xsl:variable name="mathml">
			<xsl:apply-templates select="." mode="mathml"/>
		</xsl:variable>
			
		<fo:instream-foreign-object fox:alt-text="Math">
					
			<xsl:call-template name="refine_mathml_insteam_object_style"/>
			
			<!-- put MathML in Actual Text -->
			<!-- DEBUG: mathml_content=<xsl:value-of select="$mathml_content"/> -->
			<xsl:attribute name="fox:actual-text">
				<xsl:value-of select="$mathml_content"/>
			</xsl:attribute>
			
			<!-- <xsl:if test="$add_math_as_text = 'true'"> -->
			<xsl:if test="normalize-space($asciimath_text_) != ''">
			<!-- put Mathin Alternate Text -->
				<xsl:attribute name="fox:alt-text">
					<xsl:value-of select="$asciimath_text_"/>
				</xsl:attribute>
			</xsl:if>
			<!-- </xsl:if> -->
		
			<xsl:copy-of select="xalan:nodeset($mathml)"/>
			
		</fo:instream-foreign-object>
	</xsl:template>

	<xsl:template name="refine_mathml_insteam_object_style">
		<xsl:if test="$namespace = 'bipm'">
			<xsl:if test="local-name(../..) = 'formula'">
				<xsl:attribute name="width">95%</xsl:attribute>
				<xsl:attribute name="content-height">100%</xsl:attribute>
				<xsl:attribute name="content-width">scale-down-to-fit</xsl:attribute>
				<xsl:attribute name="scaling">uniform</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'bsi' or $namespace = 'iso'">
			<xsl:if test="count(ancestor::*[local-name() = 'table']) &gt; 1">
				<xsl:attribute name="width">95%</xsl:attribute>
				<xsl:attribute name="content-height">100%</xsl:attribute>
				<xsl:attribute name="content-width">scale-down-to-fit</xsl:attribute>
				<xsl:attribute name="scaling">uniform</xsl:attribute>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$namespace = 'jcgm'">
			<xsl:if test="local-name(../..) = 'formula' or (local-name(../..) = 'td' and count(../../*) = 1)">
				<xsl:attribute name="width">95%</xsl:attribute>
				<xsl:attribute name="content-height">100%</xsl:attribute>
				<xsl:attribute name="content-width">scale-down-to-fit</xsl:attribute>
				<xsl:attribute name="scaling">uniform</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template> <!-- refine_mathml_insteam_object_style -->

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

	<!-- patch: slash in the mtd wrong rendering -->
	<xsl:template match="mathml:mtd/mathml:mo/text()[. = '/']" mode="mathml">
		<xsl:value-of select="."/><xsl:value-of select="$zero_width_space"/>
	</xsl:template>

	<!-- special case for:
		<math xmlns="http://www.w3.org/1998/Math/MathML">
			<mstyle displaystyle="true">
				<msup>
					<mi color="#00000000">C</mi>
					<mtext>R</mtext>
				</msup>
				<msubsup>
					<mtext>C</mtext>
					<mi>n</mi>
					<mi>k</mi>
				</msubsup>
			</mstyle>
		</math>
	-->
	<xsl:template match="mathml:msup/mathml:mi[. = '&#x200c;' or . = ''][not(preceding-sibling::*)][following-sibling::mathml:mtext]" mode="mathml">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:variable name="next_mtext" select="ancestor::mathml:msup/following-sibling::*[1][self::mathml:msubsup or self::mathml:msub or self::mathml:msup]/mathml:mtext"/>
			<xsl:if test="string-length($next_mtext) != ''">
				<xsl:attribute name="color">#00000000</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates />
			<xsl:value-of select="$next_mtext"/>
		</xsl:copy>
	</xsl:template>

	<!-- special case for:
				<msup>
					<mtext/>
					<mn>1</mn>
				</msup>
		convert to (add mspace after mtext and enclose them into mrow):
			<msup>
				<mrow>
					<mtext/>
					<mspace height="1.47ex"/>
				</mrow>
				<mn>1</mn>
			</msup>
	-->
	<xsl:template match="mathml:msup/mathml:mtext[not(preceding-sibling::*)]" mode="mathml">
		<mathml:mrow>
			<xsl:copy-of select="."/>
			<mathml:mspace height="1.47ex"/>
		</mathml:mrow>
	</xsl:template>

	<!-- add space around vertical line -->
	<xsl:template match="mathml:mo[normalize-space(text()) = '|']" mode="mathml">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="mathml"/>
			<xsl:if test="not(@lspace)">
				<xsl:attribute name="lspace">0.2em</xsl:attribute>
			</xsl:if>
			<xsl:if test="not(@rspace) and not(following-sibling::*[1][self::mathml:mo and normalize-space(text()) = '|'])">
				<xsl:attribute name="rspace">0.2em</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates mode="mathml"/>
		</xsl:copy>
	</xsl:template>

	<!-- decrease fontsize for 'Circled Times' char -->
	<xsl:template match="mathml:mo[normalize-space(text()) = '⊗']" mode="mathml">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="mathml"/>
			<xsl:if test="not(@fontsize)">
				<xsl:attribute name="fontsize">55%</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates mode="mathml"/>
		</xsl:copy>
	</xsl:template>

	<!-- increase space before '(' -->
	<xsl:template match="mathml:mo[normalize-space(text()) = '(']" mode="mathml">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="mathml"/>
			<xsl:if test="(preceding-sibling::* and not(preceding-sibling::*[1][self::mathml:mo])) or (../preceding-sibling::* and not(../preceding-sibling::*[1][self::mathml:mo]))">
				<xsl:if test="not(@lspace)">
					<xsl:attribute name="lspace">0.4em</xsl:attribute>
					<xsl:choose>
						<xsl:when test="preceding-sibling::*[1][self::mathml:mi or self::mathml:mstyle]">
							<xsl:attribute name="lspace">0.2em</xsl:attribute>
						</xsl:when>
						<xsl:when test="../preceding-sibling::*[1][self::mathml:mi or self::mathml:mstyle]">
							<xsl:attribute name="lspace">0.2em</xsl:attribute>
						</xsl:when>
					</xsl:choose>
				</xsl:if>
			</xsl:if>
			<xsl:apply-templates mode="mathml"/>
		</xsl:copy>
	</xsl:template>

	<!-- Examples: 
		<stem type="AsciiMath">x = 1</stem> 
		<stem type="AsciiMath"><asciimath>x = 1</asciimath></stem>
		<stem type="AsciiMath"><asciimath>x = 1</asciimath><latexmath>x = 1</latexmath></stem>
	-->
	<xsl:template match="*[local-name() = 'stem'][@type = 'AsciiMath'][count(*) = 0]/text() | *[local-name() = 'stem'][@type = 'AsciiMath'][*[local-name() = 'asciimath']]" priority="3">
		<fo:inline xsl:use-attribute-sets="mathml-style">
		
			<xsl:call-template name="refine_mathml-style" />
			
			<xsl:choose>
				<xsl:when test="self::text()"><xsl:value-of select="."/></xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates>
						<xsl:with-param name="process">true</xsl:with-param>
					</xsl:apply-templates>
				</xsl:otherwise>
			</xsl:choose>
			
		</fo:inline>
	</xsl:template>
	<!-- ======================================= -->
	<!-- END: math -->
	<!-- ======================================= -->

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
			
			<xsl:if test="starts-with(normalize-space(@target), 'mailto:') and not(ancestor::*[local-name() = 'td'])">
				<xsl:attribute name="keep-together.within-line">always</xsl:attribute>
			</xsl:if>
			
			<xsl:call-template name="refine_link-style"/>
			
			<xsl:choose>
				<xsl:when test="$target_text = ''">
					<xsl:apply-templates />
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="insert_basic_link">
						<xsl:with-param name="element">
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
						</xsl:with-param>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</fo:inline>
	</xsl:template> <!-- link -->

	<!-- ======================== -->
	<!-- Appendix processing -->
	<!-- ======================== -->
	<xsl:template match="*[local-name()='appendix']">
		<fo:block id="{@id}" xsl:use-attribute-sets="appendix-style">
			<xsl:apply-templates select="*[local-name()='title']" />
		</fo:block>
		<xsl:apply-templates select="node()[not(local-name()='title')]"/>
	</xsl:template>

	<xsl:template match="*[local-name()='appendix']/*[local-name()='title']" priority="2">
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		<fo:inline role="H{$level}"><xsl:apply-templates /></fo:inline>
	</xsl:template>
	<!-- ======================== -->
	<!-- END Appendix processing -->
	<!-- ======================== -->
	
	<xsl:template match="*[local-name()='appendix']//*[local-name()='example']" priority="2">
		<fo:block id="{@id}" xsl:use-attribute-sets="appendix-example-style">			
			<xsl:apply-templates select="*[local-name()='name']" />
		</fo:block>
		<xsl:apply-templates select="node()[not(local-name()='name')]"/>
	</xsl:template>
	
	
	<xsl:template match="*[local-name() = 'callout']">
		<xsl:choose>
			<xsl:when test="normalize-space(@target) = ''">&lt;<xsl:apply-templates />&gt;</xsl:when>
			<xsl:otherwise><fo:basic-link internal-destination="{@target}" fox:alt-text="{@target}">&lt;<xsl:apply-templates />&gt;</fo:basic-link></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'annotation']">
		<xsl:variable name="annotation-id" select="@id"/>
		<xsl:variable name="callout" select="//*[@target = $annotation-id]/text()"/>		
		<fo:block id="{$annotation-id}" white-space="nowrap">			
			<xsl:if test="$namespace = 'ogc'">
				<xsl:if test="not(preceding-sibling::*[local-name() = 'annotation'])">
					<xsl:attribute name="space-before">6pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
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

	<xsl:template match="*[local-name() = 'xref']">
		<xsl:call-template name="insert_basic_link">
			<xsl:with-param name="element">
				<fo:basic-link internal-destination="{@target}" fox:alt-text="{@target}" xsl:use-attribute-sets="xref-style">
					<xsl:if test="string-length(normalize-space()) &lt; 30 and not(contains(normalize-space(), 'http://')) and not(contains(normalize-space(), 'https://')) and not(ancestor::*[local-name() = 'table' or local-name() = 'dl'])">
						<xsl:attribute name="keep-together.within-line">always</xsl:attribute>
					</xsl:if>
					<xsl:if test="parent::*[local-name() = 'add']">
						<xsl:call-template name="append_add-style"/>
					</xsl:if>
					<xsl:apply-templates />
				</fo:basic-link>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	<!-- ====== -->
	<!-- formula  -->
	<!-- ====== -->	
	<xsl:template match="*[local-name() = 'formula']" name="formula">
		<fo:block-container margin-left="0mm" role="SKIP">
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
			<fo:block-container margin-left="0mm" role="SKIP">	
				<fo:block id="{@id}">
					<xsl:apply-templates select="node()[not(local-name() = 'name')]" /> <!-- formula's number will be process in 'stem' template -->
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


	<xsl:template match="*[local-name() = 'formula']/*[local-name() = 'name']"> <!-- show in 'stem' template -->
		<xsl:if test="normalize-space() != ''">
			<xsl:text>(</xsl:text><xsl:apply-templates /><xsl:text>)</xsl:text>
		</xsl:if>
	</xsl:template>
	
	
	<!-- stem inside formula with name (with formula's number) -->
	<xsl:template match="*[local-name() = 'formula'][*[local-name() = 'name']]/*[local-name() = 'stem']">
		<fo:block xsl:use-attribute-sets="formula-style">
		
			<xsl:if test="$namespace = 'gb'">
				<xsl:if test="not(ancestor::*[local-name()='note'])">
					<xsl:attribute name="font-size">11pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
		
			<fo:table table-layout="fixed" width="100%">
				<fo:table-column column-width="95%"/>
				<fo:table-column column-width="5%"/>
				<fo:table-body>
					<fo:table-row>
						<fo:table-cell display-align="center">
							<fo:block xsl:use-attribute-sets="formula-stem-block-style" role="SKIP">
							
								<xsl:call-template name="refine_formula-stem-block-style"/>
								
								<xsl:apply-templates />
							</fo:block>
						</fo:table-cell>
						<fo:table-cell display-align="center">
							<fo:block xsl:use-attribute-sets="formula-stem-number-style" role="SKIP">
							
								<xsl:call-template name="refine_formula-stem-number-style"/>
								
								<xsl:apply-templates select="../*[local-name() = 'name']"/>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</fo:table-body>
			</fo:table>
		</fo:block>
	</xsl:template>
	

	
	<!-- stem inside formula without name (without formula's number) -->
	<xsl:template match="*[local-name() = 'formula'][not(*[local-name() = 'name'])]/*[local-name() = 'stem']">
		<fo:block xsl:use-attribute-sets="formula-style">
			<fo:block xsl:use-attribute-sets="formula-stem-block-style">
				<xsl:apply-templates />
			</fo:block>
		</fo:block>
	</xsl:template>
	
	<!-- ====== -->
	<!-- ====== -->
	
	<xsl:template name="setBlockSpanAll">
		<xsl:if test="@columns = 1 or 
			(local-name() = 'p' and *[@columns = 1])"><xsl:attribute name="span">all</xsl:attribute></xsl:if>
	</xsl:template>
	
	<!-- ====== -->
	<!-- note      -->
	<!-- termnote -->
	<!-- ====== -->
	
	<xsl:template match="*[local-name() = 'note']" name="note">
	
		<fo:block-container id="{@id}" xsl:use-attribute-sets="note-style" role="SKIP">
		
			<xsl:call-template name="setBlockSpanAll"/>
			
			<xsl:call-template name="refine_note-style"/>
			
			<fo:block-container margin-left="0mm" margin-right="0mm" role="SKIP">
			
				<xsl:if test="$namespace = 'csa'">
					<xsl:if test="ancestor::csa:ul or ancestor::csa:ol and not(ancestor::csa:note[1]/following-sibling::*)">
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
											<xsl:apply-templates select="node()[not(local-name() = 'name')]" />
										</fo:block>
									</fo:table-cell>
								</fo:table-row>
							</fo:table-body>
						</fo:table>
						<!-- gb -->
					</xsl:when>
					
					<xsl:when test="$namespace = 'jis'">
						<fo:list-block>
							<xsl:attribute name="provisional-distance-between-starts">
								<xsl:choose>
									<!-- if last char is digit -->
									<xsl:when test="translate(substring(*[local-name() = 'name'], string-length(*[local-name() = 'name'])),'0123456789','') = ''"><xsl:value-of select="14 + $text_indent"/>mm</xsl:when>
									<xsl:otherwise><xsl:value-of select="10 + $text_indent"/>mm</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
							<fo:list-item>
								<fo:list-item-label start-indent="{$text_indent}mm" end-indent="label-end()">
									<fo:block xsl:use-attribute-sets="note-name-style">
										<xsl:apply-templates select="*[local-name() = 'name']" />
									</fo:block>
								</fo:list-item-label>
								<fo:list-item-body start-indent="body-start()">
									<fo:block>
										<xsl:apply-templates select="node()[not(local-name() = 'name')]" />
									</fo:block>
								</fo:list-item-body>
							</fo:list-item>
						</fo:list-block>
						<!-- jis -->
					</xsl:when>
					
					<xsl:otherwise>
						<fo:block>
							
							<xsl:call-template name="refine_note_block_style"/>
							
							<fo:inline xsl:use-attribute-sets="note-name-style" role="SKIP">
							
								<xsl:call-template name="refine_note-name-style"/>
							
								<!-- if 'p' contains all text in 'add' first and last elements in first p are 'add' -->
								<!-- <xsl:if test="*[not(local-name()='name')][1][node()[normalize-space() != ''][1][local-name() = 'add'] and node()[normalize-space() != ''][last()][local-name() = 'add']]"> -->
								<xsl:if test="*[not(local-name()='name')][1][count(node()[normalize-space() != '']) = 1 and *[local-name() = 'add']]">
									<xsl:call-template name="append_add-style"/>
								</xsl:if>
								
								<!-- if note contains only one element and first and last childs are `add` ace-tag, then move start ace-tag before NOTE's name-->
								<xsl:if test="count(*[not(local-name() = 'name')]) = 1 and *[not(local-name() = 'name')]/node()[last()][local-name() = 'add'][starts-with(text(), $ace_tag)]">
									<xsl:apply-templates select="*[not(local-name() = 'name')]/node()[1][local-name() = 'add'][starts-with(text(), $ace_tag)]">
										<xsl:with-param name="skip">false</xsl:with-param>
									</xsl:apply-templates> 
								</xsl:if>
								
								<xsl:apply-templates select="*[local-name() = 'name']" />
								
							</fo:inline>
							
							<xsl:apply-templates select="node()[not(local-name() = 'name')]" />
						</fo:block>
					</xsl:otherwise>
				</xsl:choose>
			</fo:block-container>
		</fo:block-container>
		
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
	</xsl:template>
	

	
	<xsl:template match="*[local-name() = 'note']/*[local-name() = 'p']">
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
	
	
	<xsl:template match="*[local-name() = 'termnote']">
		<fo:block id="{@id}" xsl:use-attribute-sets="termnote-style">
		
			<xsl:call-template name="setBlockSpanAll"/>
		
			<xsl:call-template name="refine_termnote-style"/>
		
			<fo:inline xsl:use-attribute-sets="termnote-name-style">
			
				<xsl:if test="not(*[local-name() = 'name']/following-sibling::node()[1][self::text()][normalize-space()=''])">
					<xsl:attribute name="padding-right">1mm</xsl:attribute>
				</xsl:if>
			
				<xsl:call-template name="refine_termnote-name-style"/>
			
				<!-- if 'p' contains all text in 'add' first and last elements in first p are 'add' -->
				<!-- <xsl:if test="*[not(local-name()='name')][1][node()[normalize-space() != ''][1][local-name() = 'add'] and node()[normalize-space() != ''][last()][local-name() = 'add']]"> -->
				<xsl:if test="*[not(local-name()='name')][1][count(node()[normalize-space() != '']) = 1 and *[local-name() = 'add']]">
					<xsl:call-template name="append_add-style"/>
				</xsl:if>
				
				<xsl:apply-templates select="*[local-name() = 'name']" />
				
			</fo:inline>
			
			<xsl:apply-templates select="node()[not(local-name() = 'name')]" />
		</fo:block>
	</xsl:template>


	<xsl:template match="*[local-name() = 'note']/*[local-name() = 'name']">
		<xsl:param name="sfx"/>
		<xsl:variable name="suffix">
			<xsl:choose>
				<xsl:when test="$sfx != ''">
					<xsl:value-of select="$sfx"/>					
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="$namespace = 'bipm'">
						<!-- <xsl:variable name="curr_lang" select="ancestor::bipm:bipm-standard/bipm:bibdata/bipm:language[@current = 'true']"/>
						<xsl:choose>
							<xsl:when test="$curr_lang = 'fr'"><xsl:text>&#xa0;: </xsl:text></xsl:when>
							<xsl:otherwise><xsl:text>: </xsl:text></xsl:otherwise>
						</xsl:choose> -->
						<xsl:text> </xsl:text>
					</xsl:if>
					<xsl:if test="$namespace = 'ieee'">
						<xsl:text>—</xsl:text>
					</xsl:if>
					<xsl:if test="$namespace = 'gb' or $namespace = 'iho' or $namespace = 'm3d' or $namespace = 'unece-rec' or $namespace = 'unece'  or $namespace = 'rsd'">
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
	
	<xsl:template match="*[local-name() = 'termnote']/*[local-name() = 'name']">
		<xsl:param name="sfx"/>
		<xsl:variable name="suffix">
			<xsl:choose>
				<xsl:when test="$sfx != ''">
					<xsl:value-of select="$sfx"/>					
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="$namespace = 'bipm'">
						<!-- <xsl:variable name="curr_lang" select="ancestor::bipm:bipm-standard/bipm:bibdata/bipm:language[@current = 'true']"/>
						<xsl:choose>
							<xsl:when test="$curr_lang = 'fr'"><xsl:text>&#xa0;: </xsl:text></xsl:when>
							<xsl:otherwise><xsl:text>: </xsl:text></xsl:otherwise>
						</xsl:choose> -->
						<xsl:text> </xsl:text>
					</xsl:if>
					<xsl:if test="$namespace = 'ieee'">
						<xsl:text>—</xsl:text>
					</xsl:if>
					<xsl:if test="$namespace = 'gb' or $namespace = 'iso' or $namespace = 'iec' or $namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'jcgm' or $namespace = 'rsd'">
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
	
	
	<!-- ====== -->
	<!-- term      -->	
	<!-- ====== -->
	
	<xsl:template match="*[local-name() = 'terms']">
		<!-- <xsl:message>'terms' <xsl:number/> processing...</xsl:message> -->
		<fo:block id="{@id}">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'term']">
		<fo:block id="{@id}" xsl:use-attribute-sets="term-style">

			<xsl:if test="$namespace = 'gb'">
				<fo:block font-family="SimHei" font-size="11pt" keep-with-next="always" margin-top="10pt" margin-bottom="8pt" line-height="1.1">
					<xsl:apply-templates select="gb:name" />
				</fo:block>
			</xsl:if>
			<xsl:if test="$namespace = 'm3d'">
				<fo:block keep-with-next="always" margin-top="10pt" margin-bottom="8pt" line-height="1.1">
					<xsl:apply-templates select="m3d:name" />
				</fo:block>
			</xsl:if>
			<xsl:if test="$namespace = 'ogc'">
				<xsl:apply-templates select="ogc:name" />
			</xsl:if>
			
			<xsl:if test="parent::*[local-name() = 'term'] and not(preceding-sibling::*[local-name() = 'term'])">
				<xsl:if test="$namespace = 'iso'">
					<xsl:attribute name="space-before">12pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:apply-templates select="node()[not(local-name() = 'name')]" />
		</fo:block>
	</xsl:template>
	
	
	<xsl:template match="*[local-name() = 'term']/*[local-name() = 'name']">
		<xsl:if test="normalize-space() != ''">
			<!-- <xsl:variable name="level">
				<xsl:call-template name="getLevelTermName"/>
			</xsl:variable>
			<fo:inline role="H{$level}">
				<xsl:apply-templates />
			</fo:inline> -->
			<xsl:apply-templates />
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
		<fo:block-container id="{@id}" xsl:use-attribute-sets="figure-block-style">
			<xsl:if test="$namespace = 'bipm'">
				<xsl:if test="*[local-name() = 'name']">
					<xsl:attribute name="space-after">12pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:call-template name="setTrackChangesStyles">
				<xsl:with-param name="isAdded" select="$isAdded"/>
				<xsl:with-param name="isDeleted" select="$isDeleted"/>
			</xsl:call-template>
			
			<xsl:if test="$namespace = 'bsi' or $namespace = 'rsd'"> <!-- show figure's name BEFORE image -->
				<xsl:apply-templates select="*[local-name() = 'name']" />
			</xsl:if>
			
			<!-- Example: Dimensions in millimeters -->
			<xsl:apply-templates select="*[local-name() = 'note'][@type = 'units']" />
			
			<fo:block xsl:use-attribute-sets="figure-style" role="SKIP">
				<xsl:apply-templates select="node()[not(local-name() = 'name') and not(local-name() = 'note' and @type = 'units')]" />
			</fo:block>
			<xsl:for-each select="*[local-name() = 'note'][not(@type = 'units')]">
				<xsl:call-template name="note"/>
			</xsl:for-each>
			<xsl:call-template name="fn_display_figure"/>
			
			<xsl:choose>
				<xsl:when test="$namespace = 'bsi' or $namespace = 'rsd'"></xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="*[local-name() = 'name']" /> <!-- show figure's name AFTER image -->
				</xsl:otherwise>
			</xsl:choose>
			
		</fo:block-container>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'figure'][@class = 'pseudocode']">
		<fo:block id="{@id}">
			<xsl:apply-templates select="node()[not(local-name() = 'name')]" />
		</fo:block>
		<xsl:apply-templates select="*[local-name() = 'name']" />
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'figure'][@class = 'pseudocode']//*[local-name() = 'p']">
		<fo:block xsl:use-attribute-sets="figure-pseudocode-p-style">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>

	<!-- SOURCE: ... -->
	<xsl:template match="*[local-name() = 'figure']/*[local-name() = 'source']" priority="2">
		<xsl:choose>
			<xsl:when test="$namespace = 'iec'">
				<fo:block xsl:use-attribute-sets="figure-source-style">
					<xsl:apply-templates />
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="termsource"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'image']">
		<xsl:variable name="isAdded" select="../@added"/>
		<xsl:variable name="isDeleted" select="../@deleted"/>
		<xsl:choose>
			<xsl:when test="ancestor::*[local-name() = 'title'] or not(parent::*[local-name() = 'figure']) or parent::*[local-name() = 'p']">
				<fo:inline padding-left="1mm" padding-right="1mm">
					<xsl:if test="not(parent::*[local-name() = 'figure']) or parent::*[local-name() = 'p']">
						<xsl:attribute name="padding-left">0mm</xsl:attribute>
						<xsl:attribute name="padding-right">0mm</xsl:attribute>
					</xsl:if>
					<xsl:variable name="src">
						<xsl:call-template name="image_src"/>
					</xsl:variable>
					<fo:external-graphic src="{$src}" fox:alt-text="Image {@alt}" vertical-align="middle"/>
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<fo:block xsl:use-attribute-sets="image-style">
					
					<xsl:call-template name="refine_image-style"/>
					
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
									
									<xsl:if test="@width != '' and @width != 'auto' and @width != 'text-width' and @width != 'full-page-width' and @width != 'narrow'">
										<xsl:attribute name="width">
											<xsl:value-of select="@width"/>
										</xsl:attribute>
									</xsl:if>
									
									<xsl:if test="@height != '' and @height != 'auto'">
										<xsl:attribute name="height">
											<xsl:value-of select="@height"/>
										</xsl:attribute>
									</xsl:if>
									
									<xsl:choose>
										<xsl:when test="@width != '' and @width != 'auto' and @height != '' and @height != 'auto'">
											<xsl:attribute name="scaling">non-uniform</xsl:attribute>
										</xsl:when>
										<xsl:otherwise>
										
											<xsl:variable name="img_src">
												<xsl:choose>
													<xsl:when test="not(starts-with(@src, 'data:'))"><xsl:value-of select="concat($basepath, @src)"/></xsl:when>
													<xsl:otherwise><xsl:value-of select="@src"/></xsl:otherwise>
												</xsl:choose>
											</xsl:variable>
											
											<xsl:variable name="image_width_effective">
												<xsl:choose>
													<xsl:when test="$namespace = 'bsi'">
														<xsl:choose>
															<xsl:when test="$document_type = 'PAS'"><xsl:value-of select="$width_effective"/></xsl:when>
															<xsl:otherwise><!-- BSI -->
																<xsl:choose>
																	<xsl:when test="../@width = 'full-page-width'"><xsl:value-of select="$width_effective - $image_border_padding * 2"/></xsl:when>
																	<xsl:otherwise><xsl:value-of select="$width_effective - $body_margin_left - $image_border_padding * 2"/></xsl:otherwise>
																</xsl:choose>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="$width_effective"/>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:variable>
											
											<xsl:variable name="scale" select="java:org.metanorma.fop.Util.getImageScale($img_src, $image_width_effective, $height_effective)"/>
											<xsl:if test="number($scale) &lt; 100">
												<xsl:choose>
													<xsl:when test="$namespace = 'unece'">
														<xsl:attribute name="content-width"><xsl:value-of select="$scale * 0.985"/>%</xsl:attribute><!-- 0.985 due border around image -->
													</xsl:when>
													<xsl:otherwise>
														<xsl:attribute name="content-width"><xsl:value-of select="$scale"/>%</xsl:attribute>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:if>
										</xsl:otherwise>
									</xsl:choose>
								
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
				<xsl:value-of select="concat('url(file:///',$basepath, @src, ')')"/>
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
					<xsl:value-of select="concat('url(file:///',$basepath, @src, ')')"/>
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
				<xsl:variable name="height" select="java:getHeight($bufferedImage)"/>
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
			
				<xsl:variable name="image_class" select="ancestor::*[local-name() = 'image']/@class"/>
				<xsl:variable name="ancestor_table_cell" select="normalize-space(ancestor::*[local-name() = 'td'] or ancestor::*[local-name() = 'th'])"/>
			
				<xsl:variable name="element">
					<xsl:choose>
						<xsl:when test="ancestor::*[local-name() = 'tr'] and $isGenerateTableIF = 'true'">
							<fo:inline xsl:use-attribute-sets="image-style" text-align="left"/>
						</xsl:when>
						<xsl:when test="not(ancestor::*[local-name() = 'figure'])">
							<fo:inline xsl:use-attribute-sets="image-style" text-align="left"/>
						</xsl:when>
						<xsl:otherwise>
							<fo:block xsl:use-attribute-sets="image-style">
								<xsl:if test="ancestor::*[local-name() = 'dt']">
									<xsl:attribute name="text-align">left</xsl:attribute>
								</xsl:if>
							</fo:block>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				
				<xsl:for-each select="xalan:nodeset($element)/*">
					<xsl:copy>
						<xsl:copy-of select="@*"/>
					<!-- <fo:block xsl:use-attribute-sets="image-style"> -->
						<fo:instream-foreign-object fox:alt-text="{$alt-text}">
						
							<xsl:choose>
								<xsl:when test="$image_class = 'corrigenda-tag'">
									<xsl:attribute name="fox:alt-text">CorrigendaTag</xsl:attribute>
									<xsl:attribute name="baseline-shift">-10%</xsl:attribute>
									<xsl:if test="$ancestor_table_cell = 'true'">
										<xsl:attribute name="baseline-shift">-25%</xsl:attribute>
									</xsl:if>
									<xsl:attribute name="height">3.5mm</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:if test="$isGenerateTableIF = 'false'">
										<xsl:attribute name="width">100%</xsl:attribute>
									</xsl:if>
									<xsl:attribute name="content-height">100%</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
							
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
					<!-- </fo:block> -->
					</xsl:copy>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- ============== -->
	<!-- svg_update     -->
	<!-- ============== -->
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
			<xsl:variable name="viewbox_">
				<xsl:call-template name="split">
					<xsl:with-param name="pText" select="@viewBox"/>
					<xsl:with-param name="sep" select="' '"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="viewbox" select="xalan:nodeset($viewbox_)"/>
			<xsl:variable name="width" select="normalize-space($viewbox//item[3])"/>
			<xsl:variable name="height" select="normalize-space($viewbox//item[4])"/>
			
			<xsl:attribute name="width">
				<xsl:choose>
					<xsl:when test="$width != ''">
						<xsl:value-of select="round($width)"/>
					</xsl:when>
					<xsl:otherwise>400</xsl:otherwise> <!-- default width -->
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="height">
				<xsl:choose>
					<xsl:when test="$height != ''">
						<xsl:value-of select="round($height)"/>
					</xsl:when>
					<xsl:otherwise>400</xsl:otherwise> <!-- default height -->
				</xsl:choose>
			</xsl:attribute>
			
			<xsl:apply-templates mode="svg_update"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- regex for 'display: inline-block;' -->
	<xsl:variable name="regex_svg_style_notsupported">display(\s|\h)*:(\s|\h)*inline-block(\s|\h)*;</xsl:variable>
	<xsl:template match="*[local-name() = 'svg']//*[local-name() = 'style']/text()" mode="svg_update">
		<xsl:value-of select="java:replaceAll(java:java.lang.String.new(.), $regex_svg_style_notsupported, '')"/>
	</xsl:template>
	
	<!-- replace
			stroke="rgba(r, g, b, alpha)" to 
			stroke="rgb(r,g,b)" stroke-opacity="alpha", and
			fill="rgba(r, g, b, alpha)" to 
			fill="rgb(r,g,b)" fill-opacity="alpha" -->
	<xsl:template match="@*[local-name() = 'stroke' or local-name() = 'fill'][starts-with(normalize-space(.), 'rgba')]" mode="svg_update">
		<xsl:variable name="components_">
			<xsl:call-template name="split">
				<xsl:with-param name="pText" select="substring-before(substring-after(., '('), ')')"/>
				<xsl:with-param name="sep" select="','"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="components" select="xalan:nodeset($components_)"/>
		<xsl:variable name="att_name" select="local-name()"/>
		<xsl:attribute name="{$att_name}"><xsl:value-of select="concat('rgb(', $components/item[1], ',', $components/item[2], ',', $components/item[3], ')')"/></xsl:attribute>
		<xsl:attribute name="{$att_name}-opacity"><xsl:value-of select="$components/item[4]"/></xsl:attribute>
	</xsl:template>
	
	<!-- ============== -->
	<!-- END: svg_update -->
	<!-- ============== -->
	
	<!-- image with svg and emf -->
	<xsl:template match="*[local-name() = 'figure']/*[local-name() = 'image'][*[local-name() = 'svg']]" priority="3">
		<xsl:variable name="name" select="ancestor::*[local-name() = 'figure']/*[local-name() = 'name']"/>
		<xsl:for-each select="*[local-name() = 'svg']">
			<xsl:call-template name="image_svg">
				<xsl:with-param name="name" select="$name"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	
	<!-- For the structures like: <dt><image src="" mimetype="image/svg+xml" height="" width=""><svg xmlns="http://www.w3.org/2000/svg" ... -->
	<xsl:template match="*[local-name() != 'figure']/*[local-name() = 'image'][*[local-name() = 'svg']]" priority="3">
		<xsl:for-each select="*[local-name() = 'svg']">
			<xsl:call-template name="image_svg" />
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
			<xsl:call-template name="insert_basic_link">
				<xsl:with-param name="element">
					<fo:basic-link internal-destination="{$dest}" fox:alt-text="svg link">
						<fo:inline-container inline-progression-dimension="100%">
							<fo:block-container height="{$height - 1}px" width="100%">
								<!-- DEBUG <xsl:if test="local-name()='polygon'">
									<xsl:attribute name="background-color">magenta</xsl:attribute>
								</xsl:if> -->
							<fo:block>&#xa0;</fo:block></fo:block-container>
						</fo:inline-container>
					</fo:basic-link>
				</xsl:with-param>
			</xsl:call-template>
		 </fo:block>
	  </fo:block-container>
	</xsl:template>
	<!-- =================== -->
	<!-- End SVG images processing -->
	<!-- =================== -->
	
	<!-- ignore emf processing (Apache FOP doesn't support EMF) -->
	<xsl:template match="*[local-name() = 'emf']"/>
	
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
														*[local-name() = 'requirement']/*[local-name() = 'name'] |
														*[local-name() = 'sourcecode']/*[local-name() = 'name']" mode="bookmarks">		
		<xsl:apply-templates mode="bookmarks"/>
		<xsl:text> </xsl:text>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'figure' or local-name() = 'table' or local-name() = 'permission' or local-name() = 'recommendation' or local-name() = 'requirement']/*[local-name() = 'name']/text()" mode="contents" priority="2">
		<xsl:value-of select="."/>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'figure' or local-name() = 'table' or local-name() = 'permission' or local-name() = 'recommendation' or local-name() = 'requirement' or local-name() = 'sourcecode']/*[local-name() = 'name']//text()" mode="bookmarks" priority="2">
		<xsl:value-of select="."/>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'add'][starts-with(., $ace_tag)]/text()" mode="bookmarks" priority="3"/>
	
	<xsl:template match="node()" mode="contents">
		<xsl:apply-templates mode="contents"/>
	</xsl:template>

	<!-- special case: ignore preface/section-title and sections/section-title without @displayorder  -->
	<xsl:template match="*[local-name() = 'preface' or local-name() = 'sections']/*[local-name() = 'p'][@type = 'section-title' and not(@displayorder)]" priority="3" mode="contents"/>
	<!-- process them by demand (mode="contents_no_displayorder") -->
	<xsl:template match="*[local-name() = 'p'][@type = 'section-title' and not(@displayorder)]" mode="contents_no_displayorder">
		<xsl:call-template name="contents_section-title"/>
	</xsl:template>
	<xsl:template match="*[local-name() = 'p'][@type = 'section-title']" mode="contents_in_clause">
		<xsl:call-template name="contents_section-title"/>
	</xsl:template>
	
	<!-- special case: ignore section-title if @depth different than @depth of parent clause, or @depth of parent clause = 1 -->
	<xsl:template match="*[local-name() = 'clause']/*[local-name() = 'p'][@type = 'section-title' and (@depth != ../*[local-name() = 'title']/@depth or ../*[local-name() = 'title']/@depth = 1)]" priority="3" mode="contents"/>
	
	<xsl:template match="*[local-name() = 'p'][@type = 'floating-title' or @type = 'section-title']" priority="2" name="contents_section-title" mode="contents">
		<xsl:variable name="level">
			<xsl:call-template name="getLevel">
				<xsl:with-param name="depth" select="@depth"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="section">
			<xsl:choose>
				<xsl:when test="@type = 'section-title'"></xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="*[local-name() = 'tab'][1]/preceding-sibling::node()"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="type"><xsl:value-of select="@type"/></xsl:variable>
			
		<xsl:variable name="display">
			<xsl:choose>
				<xsl:when test="normalize-space(@id) = ''">false</xsl:when>
				<xsl:when test="$level &lt;= $toc_level">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="skip">false</xsl:variable>

		<xsl:if test="$skip = 'false'">		
		
			<xsl:variable name="title">
				<xsl:choose>
					<xsl:when test="*[local-name() = 'tab']">
						<xsl:choose>
							<xsl:when test="@type = 'section-title'">
								<xsl:value-of select="*[local-name() = 'tab'][1]/preceding-sibling::node()"/>
								<xsl:text>: </xsl:text>
								<xsl:copy-of select="*[local-name() = 'tab'][1]/following-sibling::node()"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:copy-of select="*[local-name() = 'tab'][1]/following-sibling::node()"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select="node()"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<xsl:variable name="root">
				<xsl:if test="ancestor-or-self::*[local-name() = 'preface']">preface</xsl:if>
				<xsl:if test="ancestor-or-self::*[local-name() = 'annex']">annex</xsl:if>
			</xsl:variable>
			
			<item id="{@id}" level="{$level}" section="{$section}" type="{$type}" root="{$root}" display="{$display}">
				<title>
					<xsl:apply-templates select="xalan:nodeset($title)" mode="contents_item"/>
				</title>
			</item>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="node()" mode="bookmarks">
		<xsl:apply-templates mode="bookmarks"/>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'title' or local-name() = 'name']//*[local-name() = 'stem']" mode="contents">
		<xsl:apply-templates select="."/>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'references'][@hidden='true']" mode="contents" priority="3"/>
	
	<xsl:template match="*[local-name() = 'references']/*[local-name() = 'bibitem']" mode="contents"/>
	
	<!-- Note: to enable the addition of character span markup with semantic styling for DIS Word output -->
	<xsl:template match="*[local-name() = 'span']" mode="contents">
		<xsl:apply-templates mode="contents"/>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'stem']" mode="bookmarks">
		<xsl:apply-templates mode="bookmarks"/>
	</xsl:template>
	
	<!-- Note: to enable the addition of character span markup with semantic styling for DIS Word output -->
	<xsl:template match="*[local-name() = 'span']" mode="bookmarks">
		<xsl:apply-templates mode="bookmarks"/>
	</xsl:template>
	
	<!-- Bookmarks -->
	<xsl:template name="addBookmarks">
		<xsl:param name="contents"/>
		<xsl:variable name="contents_nodes" select="xalan:nodeset($contents)"/>
		<xsl:if test="$contents_nodes//item">
			<fo:bookmark-tree>
				<xsl:choose>
					<xsl:when test="$contents_nodes/doc">
						<xsl:choose>
							<xsl:when test="count($contents_nodes/doc) &gt; 1">
								
								<xsl:if test="$contents_nodes/collection">
									<fo:bookmark internal-destination="{$contents/collection/@firstpage_id}">
										<fo:bookmark-title>collection.pdf</fo:bookmark-title>
									</fo:bookmark>
								</xsl:if>
							
								<xsl:for-each select="$contents_nodes/doc">
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
								<xsl:for-each select="$contents_nodes/doc">
								
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
						<xsl:apply-templates select="$contents_nodes/contents/item" mode="bookmark"/>				
						
						<xsl:call-template name="insertFigureBookmarks">
							<xsl:with-param name="contents" select="$contents_nodes/contents"/>
						</xsl:call-template>
							
						<xsl:call-template name="insertTableBookmarks">
							<xsl:with-param name="contents" select="$contents_nodes/contents"/>
							<xsl:with-param name="lang" select="@lang"/>
						</xsl:call-template>
						
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
				<!-- $namespace = 'nist-sp' -->
				</xsl:if> 
				
				
				<xsl:if test="$namespace = 'ogc'">
				
					<xsl:if test="$contents//tables/table or $contents//figures/figure or //*[local-name() = 'table'][.//*[local-name() = 'p'][@class = 'RecommendationTitle']]">
						<fo:bookmark internal-destination="empty_bookmark">
							<fo:bookmark-title>—————</fo:bookmark-title>
						</fo:bookmark>
					</xsl:if>
					
					<xsl:if test="$contents//tables/table">
						<fo:bookmark internal-destination="empty_bookmark" starting-state="hide">
							<fo:bookmark-title>
								<xsl:value-of select="$title-list-tables"/>
							</fo:bookmark-title>
							<xsl:for-each select="$contents//tables/table">
								<fo:bookmark internal-destination="{@id}">
									<xsl:variable name="title">
										<xsl:apply-templates select="*[local-name() = 'name']" mode="bookmarks"/>
									</xsl:variable>
									<fo:bookmark-title><xsl:value-of select="$title"/></fo:bookmark-title>
								</fo:bookmark>
							</xsl:for-each>
						</fo:bookmark>
					</xsl:if>

					<xsl:if test="$contents//figures/figure">
						<fo:bookmark internal-destination="empty_bookmark" starting-state="hide">
							<fo:bookmark-title>
								<xsl:value-of select="$title-list-figures"/>
							</fo:bookmark-title>
							<xsl:for-each select="$contents//figures/figure">
								<fo:bookmark internal-destination="{@id}">
									<xsl:variable name="title">
										<xsl:apply-templates select="*[local-name() = 'name']" mode="bookmarks"/>
									</xsl:variable>
									<fo:bookmark-title><xsl:value-of select="$title"/></fo:bookmark-title>
								</fo:bookmark>
							</xsl:for-each>
						</fo:bookmark>
					</xsl:if>

					<xsl:if test="//*[local-name() = 'table'][.//*[local-name() = 'p'][@class = 'RecommendationTitle']]">							
						<fo:bookmark internal-destination="empty_bookmark" starting-state="hide">
							<fo:bookmark-title>
								<xsl:value-of select="$title-list-recommendations"/>
							</fo:bookmark-title>
							<xsl:for-each select="xalan:nodeset($toc_recommendations)/*">
								<fo:bookmark internal-destination="{@id}">
									<fo:bookmark-title><xsl:value-of select="bookmark"/></fo:bookmark-title>
								</fo:bookmark>
							</xsl:for-each>
						</fo:bookmark>
					</xsl:if>
					<!-- $namespace = 'ogc' -->
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
						<fo:bookmark internal-destination="empty_bookmark" starting-state="hide">
							<fo:bookmark-title>
								<xsl:call-template name="getLocalizedString">
									<xsl:with-param name="key">table_of_figures</xsl:with-param>
								</xsl:call-template>
							</fo:bookmark-title>
							<xsl:for-each select="$list_of_tables_figures//table_figure">
								<fo:bookmark internal-destination="{@id}">
									<fo:bookmark-title><xsl:value-of select="."/></fo:bookmark-title>
								</fo:bookmark>
							</xsl:for-each>
						</fo:bookmark>
					</xsl:if>
					<!-- $namespace = 'ogc-white-paper' -->
				</xsl:if> 
				
			</fo:bookmark-tree>
		</xsl:if>
	</xsl:template>
	
	
	<xsl:template name="insertFigureBookmarks">
		<xsl:param name="contents"/>
		<xsl:variable name="contents_nodes" select="xalan:nodeset($contents)"/>
		<xsl:if test="$contents_nodes/figure">
			<fo:bookmark internal-destination="{$contents_nodes/figure[1]/@id}" starting-state="hide">
				<fo:bookmark-title>Figures</fo:bookmark-title>
				<xsl:for-each select="$contents_nodes/figure">
					<fo:bookmark internal-destination="{@id}">
						<fo:bookmark-title>
							<xsl:value-of select="normalize-space(title)"/>
						</fo:bookmark-title>
					</fo:bookmark>
				</xsl:for-each>
			</fo:bookmark>	
		</xsl:if>
		
		<xsl:choose>
			<xsl:when test="$namespace = 'nist-sp' or $namespace = 'ogc' or $namespace = 'ogc-white-paper'"><!-- see template addBookmarks --></xsl:when>
			<xsl:otherwise>
				<xsl:if test="$contents_nodes//figures/figure">
					<fo:bookmark internal-destination="empty_bookmark" starting-state="hide">
					
						<xsl:if test="$namespace = 'iec'">
							<xsl:attribute name="internal-destination">
								<xsl:value-of select="$contents_nodes//figures/figure[1]/@id"/>
							</xsl:attribute>
						</xsl:if>
						
						<xsl:variable name="bookmark-title">
							<xsl:choose>
								<xsl:when test="$namespace = 'iec'">Figures</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$title-list-figures"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<fo:bookmark-title><xsl:value-of select="normalize-space($bookmark-title)"/></fo:bookmark-title>
						<xsl:for-each select="$contents_nodes//figures/figure">
							<fo:bookmark internal-destination="{@id}">
								<fo:bookmark-title><xsl:value-of select="normalize-space(.)"/></fo:bookmark-title>
							</fo:bookmark>
						</xsl:for-each>
					</fo:bookmark>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- insertFigureBookmarks -->
	
	<xsl:template name="insertTableBookmarks">
		<xsl:param name="contents"/>
		<xsl:param name="lang"/>
		<xsl:variable name="contents_nodes" select="xalan:nodeset($contents)"/>
		<xsl:if test="$contents_nodes/table">
			<fo:bookmark internal-destination="{$contents_nodes/table[1]/@id}" starting-state="hide">
				<fo:bookmark-title>
					<xsl:choose>
						<xsl:when test="$lang = 'fr'">Tableaux</xsl:when>
						<xsl:otherwise>Tables</xsl:otherwise>
					</xsl:choose>
				</fo:bookmark-title>
				<xsl:for-each select="$contents_nodes/table">
					<fo:bookmark internal-destination="{@id}">
						<fo:bookmark-title>
							<xsl:value-of select="normalize-space(title)"/>
						</fo:bookmark-title>
					</fo:bookmark>
				</xsl:for-each>
			</fo:bookmark>	
		</xsl:if>
		
		<xsl:choose>
			<xsl:when test="$namespace = 'nist-sp' or $namespace = 'ogc' or $namespace = 'ogc-white-paper'"><!-- see template addBookmarks --></xsl:when>
			<xsl:otherwise>
				<xsl:if test="$contents_nodes//tables/table">
					<fo:bookmark internal-destination="empty_bookmark" starting-state="hide">
						
						<xsl:if test="$namespace = 'iec'">
							<xsl:attribute name="internal-destination">
								<xsl:value-of select="$contents_nodes//tables/table[1]/@id"/>
							</xsl:attribute>
						</xsl:if>
						
						<xsl:variable name="bookmark-title">
							<xsl:choose>
								<xsl:when test="$namespace = 'iec'">
									<xsl:choose>
										<xsl:when test="$lang = 'fr'">Tableaux</xsl:when>
										<xsl:otherwise>Tables</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$title-list-tables"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						
						<fo:bookmark-title><xsl:value-of select="$bookmark-title"/></fo:bookmark-title>
						
						<xsl:for-each select="$contents_nodes//tables/table">
							<fo:bookmark internal-destination="{@id}">
								<fo:bookmark-title><xsl:value-of select="normalize-space(.)"/></fo:bookmark-title>
							</fo:bookmark>
						</xsl:for-each>
					</fo:bookmark>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- insertTableBookmarks -->
	<!-- End Bookmarks -->
	
	
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
						<xsl:variable name="title">
							<xsl:for-each select="title/node()">
								<xsl:choose>
									<xsl:when test="local-name() = 'add' and starts-with(., $ace_tag)"><!-- skip --></xsl:when>
									<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
						</xsl:variable>
						<xsl:value-of select="normalize-space($title)"/>
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
								*[local-name() = 'image']/*[local-name() = 'name']">
		<xsl:if test="normalize-space() != ''">			
			<fo:block xsl:use-attribute-sets="figure-name-style">
			
				<xsl:call-template name="refine_figure-name-style"/>
				
				<xsl:apply-templates />
			</fo:block>
		</xsl:if>
	</xsl:template>
					

	
	<xsl:template match="*[local-name() = 'figure']/*[local-name() = 'fn']" priority="2"/>
	<xsl:template match="*[local-name() = 'figure']/*[local-name() = 'note']"/>
	
	
	<xsl:template match="*[local-name() = 'figure']/*[local-name() = 'note'][@type = 'units'] |
								*[local-name() = 'image']/*[local-name() = 'note'][@type = 'units']" priority="2">
		<fo:block text-align="right" keep-with-next="always">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<!-- ====== -->
	<!-- ====== -->
	<xsl:template match="*[local-name() = 'title']" mode="contents_item">
		<xsl:param name="mode">bookmarks</xsl:param>
		<xsl:apply-templates mode="contents_item">
			<xsl:with-param name="mode" select="$mode"/>
		</xsl:apply-templates>
		<!-- <xsl:text> </xsl:text> -->
	</xsl:template>

	<xsl:template name="getSection">
		<xsl:value-of select="*[local-name() = 'title']/*[local-name() = 'tab'][1]/preceding-sibling::node()"/>
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

	<xsl:template match="*[local-name() = 'xref'] | *[local-name() = 'eref']" mode="contents">
		<xsl:value-of select="."/>
	</xsl:template>

	
	<xsl:template match="*[local-name() = 'review']" mode="contents_item"/>

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
	
	<xsl:template match="*[local-name() = 'sub']" mode="contents_item">
		<xsl:copy>
			<xsl:apply-templates mode="contents_item"/>
		</xsl:copy>		
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'sup']" mode="contents_item">
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

	<xsl:template match="*[local-name() = 'name']" mode="contents_item">
		<xsl:param name="mode">bookmarks</xsl:param>
		<xsl:apply-templates mode="contents_item">
			<xsl:with-param name="mode" select="$mode"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'add']" mode="contents_item">
		<xsl:param name="mode">bookmarks</xsl:param>
		<xsl:choose>
			<xsl:when test="starts-with(text(), $ace_tag)">
				<xsl:if test="$mode = 'contents'">
					<xsl:copy>
						<xsl:apply-templates mode="contents_item"/>
					</xsl:copy>		
				</xsl:if>
			</xsl:when>
			<xsl:otherwise><xsl:apply-templates mode="contents_item"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="text()" mode="contents_item">
		<xsl:variable name="text">
			<!-- to split by '_' and other chars -->
			<text><xsl:call-template name="add-zero-spaces-java"/></text>
		</xsl:variable>
		<xsl:for-each select="xalan:nodeset($text)/text/text()">
			<xsl:call-template name="keep_together_standard_number"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="*[local-name() = 'add'][starts-with(., $ace_tag)]/text()" mode="contents_item" priority="2">
		<xsl:value-of select="."/>
	</xsl:template>

	<!-- Note: to enable the addition of character span markup with semantic styling for DIS Word output -->
	<xsl:template match="*[local-name() = 'span']" mode="contents_item">
		<xsl:apply-templates mode="contents_item"/>
	</xsl:template>

	<!-- =============== -->
	<!-- sourcecode  -->
	<!-- =============== -->
	
	<xsl:variable name="source-highlighter-css_" select="//*[contains(local-name(), '-standard')]/*[local-name() = 'metanorma-extension']/*[local-name() = 'source-highlighter-css']"/>
	<xsl:variable name="sourcecode_css_" select="java:org.metanorma.fop.Util.parseCSS($source-highlighter-css_)"/>
	<xsl:variable name="sourcecode_css" select="xalan:nodeset($sourcecode_css_)"/>	
	
	<xsl:template match="*[local-name() = 'property']" mode="css">
		<xsl:attribute name="{@name}">
			<xsl:value-of select="@value"/>
		</xsl:attribute>
	</xsl:template>
	
	<xsl:template name="get_sourcecode_attributes">
		<xsl:element name="sourcecode_attributes" use-attribute-sets="sourcecode-style">
			<xsl:variable name="_font-size">
				<xsl:if test="$namespace = 'csa'">10</xsl:if>
				<xsl:if test="$namespace = 'csd'">10</xsl:if>						
				<xsl:if test="$namespace = 'gb'">9</xsl:if>
				<xsl:if test="$namespace = 'iec'">9</xsl:if>
				<xsl:if test="$namespace = 'iho'">9.5</xsl:if>
				<xsl:if test="$namespace = 'iso'">9</xsl:if><!-- inherit -->
				<xsl:if test="$namespace = 'bsi'">9</xsl:if>
				<xsl:if test="$namespace = 'jcgm'">9</xsl:if>
				<!-- <xsl:if test="$namespace = 'ieee'">							
					<xsl:if test="$current_template = 'standard'">8</xsl:if>
				</xsl:if> -->
				<xsl:if test="$namespace = 'itu'">10</xsl:if>
				<xsl:if test="$namespace = 'm3d'"></xsl:if>		
				<xsl:if test="$namespace = 'mpfd'"></xsl:if>
				<xsl:if test="$namespace = 'nist-cswp'  or $namespace = 'nist-sp'">10</xsl:if>
				<xsl:if test="$namespace = 'ogc'">
					<xsl:choose>
						<xsl:when test="ancestor::*[local-name() = 'table'][not(parent::*[local-name() = 'sourcecode'][@linenums = 'true'])]">8.5</xsl:when>
						<xsl:otherwise>9.5</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
				<xsl:if test="$namespace = 'ogc-white-paper'">
					<xsl:choose>
						<xsl:when test="ancestor::*[local-name() = 'table'][not(parent::*[local-name() = 'sourcecode'][@linenums = 'true'])]">8.5</xsl:when>
						<xsl:otherwise>9.5</xsl:otherwise>
					</xsl:choose>
				</xsl:if>						
				<xsl:if test="$namespace = 'rsd'">
					<xsl:choose>
						<xsl:when test="ancestor::*[local-name() = 'table'][not(parent::*[local-name() = 'sourcecode'][@linenums = 'true'])]">inherit</xsl:when>
						<xsl:otherwise>95%</xsl:otherwise><!-- 110% -->
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
			<xsl:apply-templates select="$sourcecode_css//class[@name = 'sourcecode']" mode="css"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="*[local-name()='sourcecode']" name="sourcecode">
	
		<xsl:variable name="sourcecode_attributes">
			<xsl:call-template name="get_sourcecode_attributes"/>
		</xsl:variable>
	
    <!-- <xsl:copy-of select="$sourcecode_css"/> -->
  
		<xsl:choose>
			<xsl:when test="$isGenerateTableIF = 'true' and (ancestor::*[local-name() = 'td'] or ancestor::*[local-name() = 'th'])">
				<xsl:for-each select="xalan:nodeset($sourcecode_attributes)/sourcecode_attributes/@*">					
					<xsl:attribute name="{local-name()}">
						<xsl:value-of select="."/>
					</xsl:attribute>
				</xsl:for-each>
				<xsl:apply-templates select="node()[not(local-name() = 'name')]" />
			</xsl:when>
			
			<xsl:otherwise>
				<fo:block-container xsl:use-attribute-sets="sourcecode-container-style" role="SKIP">
				
					<xsl:if test="not(ancestor::*[local-name() = 'li']) or ancestor::*[local-name() = 'example']">
						<xsl:attribute name="margin-left">0mm</xsl:attribute>
					</xsl:if>
					
					<xsl:if test="ancestor::*[local-name() = 'example']">
						<xsl:attribute name="margin-right">0mm</xsl:attribute>
					</xsl:if>
					
					<xsl:copy-of select="@id"/>
					
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
					<fo:block-container margin-left="0mm" role="SKIP">
				
						<xsl:if test="$namespace = 'rsd'">
							<xsl:apply-templates select="*[local-name()='name']" /> <!-- show sourcecode's name BEFORE content -->
						</xsl:if>
						
						<xsl:if test="$namespace = 'ogc'">
							<xsl:if test="parent::*[local-name() = 'example']">
								<fo:block font-size="1pt" line-height="10%" space-after="4pt">&#xa0;</fo:block>
							</xsl:if>
						</xsl:if>
						
						<fo:block xsl:use-attribute-sets="sourcecode-style">
							
							<xsl:for-each select="xalan:nodeset($sourcecode_attributes)/sourcecode_attributes/@*">					
								<xsl:attribute name="{local-name()}">
									<xsl:value-of select="."/>
								</xsl:attribute>
							</xsl:for-each>
							
							<xsl:call-template name="refine_sourcecode-style"/>
							
							<!-- remove margin between rows in the table with sourcecode line numbers -->
							<xsl:if test="ancestor::*[local-name() = 'sourcecode'][@linenums = 'true'] and ancestor::*[local-name() = 'tr'][1]/following-sibling::*[local-name() = 'tr']">
								<xsl:attribute name="margin-top">0pt</xsl:attribute>
								<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
							</xsl:if>
							
							<xsl:apply-templates select="node()[not(local-name() = 'name' or local-name() = 'dl')]" />
						</fo:block>
						
						<xsl:apply-templates select="*[local-name() = 'dl']"/> <!-- Key table -->
						
						<xsl:choose>
							<xsl:when test="$namespace = 'rsd'"></xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates select="*[local-name()='name']" /> <!-- show sourcecode's name AFTER content -->
							</xsl:otherwise>
						</xsl:choose>
							
						<xsl:if test="$namespace = 'ogc'">
							<xsl:if test="parent::*[local-name() = 'example']">
								<fo:block font-size="1pt" line-height="10%" space-before="6pt">&#xa0;</fo:block>
							</xsl:if>
						</xsl:if>
						
					</fo:block-container>
				</fo:block-container>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	

	<xsl:template match="*[local-name()='sourcecode']/text() | *[local-name()='sourcecode']//*[local-name()='span']/text()" priority="2">
		<xsl:choose>
			<!-- disabled -->
			<xsl:when test="1 = 2 and normalize-space($syntax-highlight) = 'true' and normalize-space(../@lang) != ''"> <!-- condition for turn on of highlighting -->
				<xsl:variable name="syntax" select="java:org.metanorma.fop.Util.syntaxHighlight(., ../@lang)"/>
				<xsl:choose>
					<xsl:when test="normalize-space($syntax) != ''"><!-- if there is highlighted result -->
						<xsl:apply-templates select="xalan:nodeset($syntax)" mode="syntax_highlight"/> <!-- process span tags -->
					</xsl:when>
					<xsl:otherwise> <!-- if case of non-succesfull syntax highlight (for instance, unknown lang), process without highlighting -->
						<xsl:call-template name="add_spaces_to_sourcecode"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="add_spaces_to_sourcecode"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- add sourcecode highlighting -->
	<xsl:template match="*[local-name()='sourcecode']//*[local-name()='span'][@class]" priority="2">
		<xsl:variable name="class" select="@class"/>
		
		<!-- Example: <1> -->
		<xsl:variable name="is_callout">
			<xsl:if test="parent::*[local-name() = 'dt']">
				<xsl:variable name="dt_id" select="../@id"/>
				<xsl:if test="ancestor::*[local-name() = 'sourcecode']//*[local-name() = 'callout'][@target = $dt_id]">true</xsl:if>
			</xsl:if>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="$sourcecode_css//class[@name = $class]">
				<fo:inline>
					<xsl:apply-templates select="$sourcecode_css//class[@name = $class]" mode="css"/>
					<xsl:if test="$is_callout = 'true'">&lt;</xsl:if>
					<xsl:apply-templates />
					<xsl:if test="$is_callout = 'true'">&gt;</xsl:if>
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- outer table with line numbers for sourcecode -->
	<xsl:template match="*[local-name() = 'sourcecode'][@linenums = 'true']/*[local-name()='table']" priority="2"> <!-- *[local-name()='table'][@type = 'sourcecode'] |  -->
		<fo:block>
			<fo:table width="100%" table-layout="fixed">
				<xsl:copy-of select="@id"/>
					<fo:table-column column-width="8%"/>
					<fo:table-column column-width="92%"/>
					<fo:table-body>
						<xsl:apply-templates />
					</fo:table-body>
			</fo:table>
		</fo:block>
	</xsl:template>
	<xsl:template match="*[local-name() = 'sourcecode'][@linenums = 'true']/*[local-name()='table']/*[local-name() = 'tbody']" priority="2"> <!-- *[local-name()='table'][@type = 'sourcecode']/*[local-name() = 'tbody'] |  -->
		<xsl:apply-templates />
	</xsl:template>
	<xsl:template match="*[local-name() = 'sourcecode'][@linenums = 'true']/*[local-name()='table']//*[local-name()='tr']" priority="2"> <!-- *[local-name()='table'][@type = 'sourcecode']//*[local-name()='tr'] |  -->
		<fo:table-row>
			<xsl:apply-templates />
		</fo:table-row>
	</xsl:template>
	<!-- first td with line numbers -->
	<xsl:template match="*[local-name() = 'sourcecode'][@linenums = 'true']/*[local-name()='table']//*[local-name()='tr']/*[local-name()='td'][not(preceding-sibling::*)]" priority="2"> <!-- *[local-name()='table'][@type = 'sourcecode'] -->
		<fo:table-cell>
			<fo:block>
				
				<!-- set attibutes for line numbers - same as sourcecode -->
				<xsl:variable name="sourcecode_attributes">
					<xsl:for-each select="following-sibling::*[local-name() = 'td']/*[local-name() = 'sourcecode']">
						<xsl:call-template name="get_sourcecode_attributes"/>
					</xsl:for-each>
				</xsl:variable>
				<xsl:for-each select="xalan:nodeset($sourcecode_attributes)/sourcecode_attributes/@*[not(starts-with(local-name(), 'margin-') or starts-with(local-name(), 'space-'))]">					
					<xsl:attribute name="{local-name()}">
						<xsl:value-of select="."/>
					</xsl:attribute>
				</xsl:for-each>
				
				<xsl:apply-templates />
			</fo:block>
		</fo:table-cell>
	</xsl:template>
	
	<!-- second td with sourcecode -->
	<xsl:template match="*[local-name() = 'sourcecode'][@linenums = 'true']/*[local-name()='table']//*[local-name()='tr']/*[local-name()='td'][preceding-sibling::*]" priority="2"> <!-- *[local-name()='table'][@type = 'sourcecode'] -->
		<fo:table-cell>
			<fo:block role="SKIP">
				<xsl:apply-templates />
			</fo:block>
		</fo:table-cell>
	</xsl:template>
	<!-- END outer table with line numbers for sourcecode -->
	
	<xsl:template name="add_spaces_to_sourcecode">
		<xsl:variable name="text_step1">
			<xsl:call-template name="add-zero-spaces-equal"/>
		</xsl:variable>
		<xsl:variable name="text_step2">
			<xsl:call-template name="add-zero-spaces-java">
				<xsl:with-param name="text" select="$text_step1"/>
			</xsl:call-template>
		</xsl:variable>
		
		<!-- <xsl:value-of select="$text_step2"/> -->
		
		<!-- add zero-width space after space -->
		<xsl:variable name="text_step3" select="java:replaceAll(java:java.lang.String.new($text_step2),' ',' &#x200B;')"/>
		
		<!-- split text by zero-width space -->
		<xsl:variable name="text_step4">
			<xsl:call-template name="split_for_interspers">
				<xsl:with-param name="pText" select="$text_step3"/>
				<xsl:with-param name="sep" select="$zero_width_space"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:for-each select="xalan:nodeset($text_step4)/node()">
			<xsl:choose>
				<xsl:when test="local-name() = 'interspers'"> <!-- word with length more than 30 will be interspersed with zero-width space -->
					<xsl:call-template name="interspers-java">
						<xsl:with-param name="str" select="."/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
		
	</xsl:template> <!-- add_spaces_to_sourcecode -->
	
	
	<xsl:variable name="interspers_tag_open">###interspers123###</xsl:variable>
	<xsl:variable name="interspers_tag_close">###/interspers123###</xsl:variable>
	<!-- split string by separator for interspers -->
	<xsl:template name="split_for_interspers">
		<xsl:param name="pText" select="."/>
		<xsl:param name="sep" select="','"/>
		<!-- word with length more than 30 will be interspersed with zero-width space -->
		<xsl:variable name="regex" select="concat('([^', $zero_width_space, ']{31,})')"/> <!-- sequence of characters (more 31), that doesn't contains zero-width space -->
		<xsl:variable name="text" select="java:replaceAll(java:java.lang.String.new($pText),$regex,concat($interspers_tag_open,'$1',$interspers_tag_close))"/>
		<xsl:call-template name="replace_tag_interspers">
			<xsl:with-param name="text" select="$text"/>
		</xsl:call-template>
	</xsl:template> <!-- end: split string by separator for interspers -->
	
	<xsl:template name="replace_tag_interspers">
		<xsl:param name="text"/>
		<xsl:choose>
			<xsl:when test="contains($text, $interspers_tag_open)">
				<xsl:value-of select="substring-before($text, $interspers_tag_open)"/>
				<xsl:variable name="text_after" select="substring-after($text, $interspers_tag_open)"/>
				<interspers>
					<xsl:value-of select="substring-before($text_after, $interspers_tag_close)"/>
				</interspers>
				<xsl:call-template name="replace_tag_interspers">
					<xsl:with-param name="text" select="substring-after($text_after, $interspers_tag_close)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="$text"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<!-- insert 'char' between each character in the string -->
	<xsl:template name="interspers">
		<xsl:param name="str"/>
		<xsl:param name="char" select="$zero_width_space"/>
		<xsl:if test="$str != ''">
			<xsl:value-of select="substring($str, 1, 1)"/>
			
			<xsl:variable name="next_char" select="substring($str, 2, 1)"/>
			<xsl:if test="not(contains(concat(' -.:=_— ', $char), $next_char))">
				<xsl:value-of select="$char"/>
			</xsl:if>
			
			<xsl:call-template name="interspers">
				<xsl:with-param name="str" select="substring($str, 2)"/>
				<xsl:with-param name="char" select="$char"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	
	<xsl:template name="interspers-java">
		<xsl:param name="str"/>
		<xsl:param name="char" select="$zero_width_space"/>
		<xsl:value-of select="java:replaceAll(java:java.lang.String.new($str),'([^ -.:=_—])',concat('$1', $char))"/> <!-- insert $char after each char excep space, - . : = _ etc. -->
	</xsl:template>
	
	
	<xsl:template match="*" mode="syntax_highlight">
		<xsl:apply-templates mode="syntax_highlight"/>
	</xsl:template>
	
	<xsl:variable name="syntax_highlight_styles_">
		<style class="hljs-addition" xsl:use-attribute-sets="hljs-addition"></style>
		<style class="hljs-attr" xsl:use-attribute-sets="hljs-attr"></style>
		<style class="hljs-attribute" xsl:use-attribute-sets="hljs-attribute"></style>
		<style class="hljs-built_in" xsl:use-attribute-sets="hljs-built_in"></style>
		<style class="hljs-bullet" xsl:use-attribute-sets="hljs-bullet"></style>
		<style class="hljs-char_and_escape_" xsl:use-attribute-sets="hljs-char_and_escape_"></style>
		<style class="hljs-code" xsl:use-attribute-sets="hljs-code"></style>
		<style class="hljs-comment" xsl:use-attribute-sets="hljs-comment"></style>
		<style class="hljs-deletion" xsl:use-attribute-sets="hljs-deletion"></style>
		<style class="hljs-doctag" xsl:use-attribute-sets="hljs-doctag"></style>
		<style class="hljs-emphasis" xsl:use-attribute-sets="hljs-emphasis"></style>
		<style class="hljs-formula" xsl:use-attribute-sets="hljs-formula"></style>
		<style class="hljs-keyword" xsl:use-attribute-sets="hljs-keyword"></style>
		<style class="hljs-link" xsl:use-attribute-sets="hljs-link"></style>
		<style class="hljs-literal" xsl:use-attribute-sets="hljs-literal"></style>
		<style class="hljs-meta" xsl:use-attribute-sets="hljs-meta"></style>
		<style class="hljs-meta_hljs-string" xsl:use-attribute-sets="hljs-meta_hljs-string"></style>
		<style class="hljs-meta_hljs-keyword" xsl:use-attribute-sets="hljs-meta_hljs-keyword"></style>
		<style class="hljs-name" xsl:use-attribute-sets="hljs-name"></style>
		<style class="hljs-number" xsl:use-attribute-sets="hljs-number"></style>
		<style class="hljs-operator" xsl:use-attribute-sets="hljs-operator"></style>
		<style class="hljs-params" xsl:use-attribute-sets="hljs-params"></style>
		<style class="hljs-property" xsl:use-attribute-sets="hljs-property"></style>
		<style class="hljs-punctuation" xsl:use-attribute-sets="hljs-punctuation"></style>
		<style class="hljs-quote" xsl:use-attribute-sets="hljs-quote"></style>
		<style class="hljs-regexp" xsl:use-attribute-sets="hljs-regexp"></style>
		<style class="hljs-section" xsl:use-attribute-sets="hljs-section"></style>
		<style class="hljs-selector-attr" xsl:use-attribute-sets="hljs-selector-attr"></style>
		<style class="hljs-selector-class" xsl:use-attribute-sets="hljs-selector-class"></style>
		<style class="hljs-selector-id" xsl:use-attribute-sets="hljs-selector-id"></style>
		<style class="hljs-selector-pseudo" xsl:use-attribute-sets="hljs-selector-pseudo"></style>
		<style class="hljs-selector-tag" xsl:use-attribute-sets="hljs-selector-tag"></style>
		<style class="hljs-string" xsl:use-attribute-sets="hljs-string"></style>
		<style class="hljs-strong" xsl:use-attribute-sets="hljs-strong"></style>
		<style class="hljs-subst" xsl:use-attribute-sets="hljs-subst"></style>
		<style class="hljs-symbol" xsl:use-attribute-sets="hljs-symbol"></style>		
		<style class="hljs-tag" xsl:use-attribute-sets="hljs-tag"></style>
		<!-- <style class="hljs-tag_hljs-attr" xsl:use-attribute-sets="hljs-tag_hljs-attr"></style> -->
		<!-- <style class="hljs-tag_hljs-name" xsl:use-attribute-sets="hljs-tag_hljs-name"></style> -->
		<style class="hljs-template-tag" xsl:use-attribute-sets="hljs-template-tag"></style>
		<style class="hljs-template-variable" xsl:use-attribute-sets="hljs-template-variable"></style>
		<style class="hljs-title" xsl:use-attribute-sets="hljs-title"></style>
		<style class="hljs-title_and_class_" xsl:use-attribute-sets="hljs-title_and_class_"></style>
		<style class="hljs-title_and_class__and_inherited__" xsl:use-attribute-sets="hljs-title_and_class__and_inherited__"></style>
		<style class="hljs-title_and_function_" xsl:use-attribute-sets="hljs-title_and_function_"></style>
		<style class="hljs-type" xsl:use-attribute-sets="hljs-type"></style>
		<style class="hljs-variable" xsl:use-attribute-sets="hljs-variable"></style>
		<style class="hljs-variable_and_language_" xsl:use-attribute-sets="hljs-variable_and_language_"></style>
	</xsl:variable>
	<xsl:variable name="syntax_highlight_styles" select="xalan:nodeset($syntax_highlight_styles_)"/>
	
	<xsl:template match="span" mode="syntax_highlight" priority="2">
		<!-- <fo:inline color="green" font-style="italic"><xsl:apply-templates mode="syntax_highlight"/></fo:inline> -->
		<fo:inline>
			<xsl:variable name="classes_">
				<xsl:call-template name="split">
					<xsl:with-param name="pText" select="@class"/>
					<xsl:with-param name="sep" select="' '"/>
				</xsl:call-template>
				<!-- a few classes together (_and_ suffix) -->
				<xsl:if test="contains(@class, 'hljs-char') and contains(@class, 'escape_')">
					<item>hljs-char_and_escape_</item>
				</xsl:if>
				<xsl:if test="contains(@class, 'hljs-title') and contains(@class, 'class_')">
					<item>hljs-title_and_class_</item>
				</xsl:if>
				<xsl:if test="contains(@class, 'hljs-title') and contains(@class, 'class_') and contains(@class, 'inherited__')">
					<item>hljs-title_and_class__and_inherited__</item>
				</xsl:if>
				<xsl:if test="contains(@class, 'hljs-title') and contains(@class, 'function_')">
					<item>hljs-title_and_function_</item>
				</xsl:if>
				<xsl:if test="contains(@class, 'hljs-variable') and contains(@class, 'language_')">
					<item>hljs-variable_and_language_</item>
				</xsl:if>
				<!-- with parent classes (_ suffix) -->
				<xsl:if test="contains(@class, 'hljs-keyword') and contains(ancestor::*/@class, 'hljs-meta')">
					<item>hljs-meta_hljs-keyword</item>
				</xsl:if>
				<xsl:if test="contains(@class, 'hljs-string') and contains(ancestor::*/@class, 'hljs-meta')">
					<item>hljs-meta_hljs-string</item>
				</xsl:if>
			</xsl:variable>
			<xsl:variable name="classes" select="xalan:nodeset($classes_)"/>
			
			<xsl:for-each select="$classes/item">
				<xsl:variable name="class_name" select="."/>
				<xsl:for-each select="$syntax_highlight_styles/style[@class = $class_name]/@*[not(local-name() = 'class')]">
					<xsl:attribute name="{local-name()}"><xsl:value-of select="."/></xsl:attribute>
				</xsl:for-each>
			</xsl:for-each>
			
			<!-- <xsl:variable name="class_name">
				<xsl:choose>
					<xsl:when test="@class = 'hljs-attr' and ancestor::*/@class = 'hljs-tag'">hljs-tag_hljs-attr</xsl:when>
					<xsl:when test="@class = 'hljs-name' and ancestor::*/@class = 'hljs-tag'">hljs-tag_hljs-name</xsl:when>
					<xsl:when test="@class = 'hljs-string' and ancestor::*/@class = 'hljs-meta'">hljs-meta_hljs-string</xsl:when>
					<xsl:otherwise><xsl:value-of select="@class"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:for-each select="$syntax_highlight_styles/style[@class = $class_name]/@*[not(local-name() = 'class')]">
				<xsl:attribute name="{local-name()}"><xsl:value-of select="."/></xsl:attribute>
			</xsl:for-each> -->
			
		<xsl:apply-templates mode="syntax_highlight"/></fo:inline>
	</xsl:template>
	
	<xsl:template match="text()" mode="syntax_highlight" priority="2">
		<xsl:call-template name="add_spaces_to_sourcecode"/>
	</xsl:template>
	
	<!-- end mode="syntax_highlight" -->
	
	
	
	<xsl:template match="*[local-name() = 'sourcecode']/*[local-name() = 'name']">
		<xsl:if test="normalize-space() != ''">		
			<fo:block xsl:use-attribute-sets="sourcecode-name-style">				
				<xsl:apply-templates/>
			</fo:block>
		</xsl:if>
	</xsl:template>	
	<!-- =============== -->
	<!-- END sourcecode  -->
	<!-- =============== -->
	
	
	<!-- =============== -->
	<!-- pre  -->
	<!-- =============== -->
	<xsl:template match="*[local-name()='pre']" name="pre">
		<fo:block xsl:use-attribute-sets="pre-style">
			<xsl:copy-of select="@id"/>
			<xsl:choose>
			
				<xsl:when test="ancestor::*[local-name() = 'sourcecode'][@linenums = 'true'] and ancestor::*[local-name()='td'][1][not(preceding-sibling::*)]"> <!-- pre in the first td in the table with @linenums = 'true' -->
					<xsl:if test="ancestor::*[local-name() = 'tr'][1]/following-sibling::*[local-name() = 'tr']"> <!-- is current tr isn't last -->
						<xsl:attribute name="margin-top">0pt</xsl:attribute>
						<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
					</xsl:if>
					<fo:instream-foreign-object fox:alt-text="{.}" content-width="95%">
						<math xmlns="http://www.w3.org/1998/Math/MathML">
							<mtext><xsl:value-of select="."/></mtext>
						</math>
					</fo:instream-foreign-object>
				</xsl:when>
				
				<xsl:otherwise>
					<xsl:apply-templates />
				</xsl:otherwise>
				
			</xsl:choose>		
		</fo:block>
	</xsl:template>
	<!-- =============== -->
	<!-- pre  -->
	<!-- =============== -->
	
	<!-- ========== -->
	<!-- permission -->	
	<!-- ========== -->		
	<xsl:template match="*[local-name() = 'permission']">
		<fo:block id="{@id}" xsl:use-attribute-sets="permission-style">			
			<xsl:apply-templates select="*[local-name()='name']" />
			<xsl:apply-templates select="node()[not(local-name() = 'name')]" />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'permission']/*[local-name() = 'name']">
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
			<xsl:apply-templates select="*[local-name()='name']" />
			<xsl:apply-templates select="*[local-name()='label']" />
			<xsl:apply-templates select="@obligation"/>
			<xsl:apply-templates select="*[local-name()='subject']" />
			<xsl:apply-templates select="node()[not(local-name() = 'name') and not(local-name() = 'label') and not(local-name() = 'subject')]" />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'requirement']/*[local-name() = 'name']">
		<xsl:if test="normalize-space() != ''">
			<fo:block xsl:use-attribute-sets="requirement-name-style">
				<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
					<xsl:if test="../@type = 'class'">
						<xsl:attribute name="background-color">white</xsl:attribute>
					</xsl:if>
				</xsl:if>
				<xsl:apply-templates />
				<xsl:if test="$namespace = 'iso' or $namespace = 'ogc' or $namespace = 'ogc-white-paper'">
					<xsl:text>:</xsl:text>
				</xsl:if>
			</fo:block>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'requirement']/*[local-name() = 'label']">
		<fo:block xsl:use-attribute-sets="requirement-label-style">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'requirement']/@obligation">
			<fo:block>
				<fo:inline padding-right="3mm">Obligation</fo:inline><xsl:value-of select="."/>
			</fo:block>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'requirement']/*[local-name() = 'subject']" priority="2">
		<fo:block xsl:use-attribute-sets="subject-style">
			<xsl:text>Target Type </xsl:text><xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<!-- ========== -->
	<!-- ========== -->
	
	<!-- ========== -->
	<!-- recommendation -->
	<!-- ========== -->
	<xsl:template match="*[local-name() = 'recommendation']">
		<fo:block id="{@id}" xsl:use-attribute-sets="recommendation-style">			
			<xsl:apply-templates select="*[local-name()='name']" />
			<xsl:apply-templates select="node()[not(local-name() = 'name')]" />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'recommendation']/*[local-name() = 'name']">
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
	
	
	<xsl:template match="*[local-name() = 'subject']">
		<fo:block xsl:use-attribute-sets="subject-style">
			<xsl:text>Target Type </xsl:text><xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'div']">
		<fo:block><xsl:apply-templates /></fo:block>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'inherit'] | *[local-name() = 'component'][@class = 'inherit'] |
										*[local-name() = 'div'][@type = 'requirement-inherit'] |
										*[local-name() = 'div'][@type = 'recommendation-inherit'] |
										*[local-name() = 'div'][@type = 'permission-inherit']">
		<fo:block xsl:use-attribute-sets="inherit-style">
			<xsl:text>Dependency </xsl:text><xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'description'] | *[local-name() = 'component'][@class = 'description'] |
										*[local-name() = 'div'][@type = 'requirement-description'] |
										*[local-name() = 'div'][@type = 'recommendation-description'] |
										*[local-name() = 'div'][@type = 'permission-description']">
		<fo:block xsl:use-attribute-sets="description-style">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'specification'] | *[local-name() = 'component'][@class = 'specification'] |
										*[local-name() = 'div'][@type = 'requirement-specification'] |
										*[local-name() = 'div'][@type = 'recommendation-specification'] |
										*[local-name() = 'div'][@type = 'permission-specification']">
		<fo:block xsl:use-attribute-sets="specification-style">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'measurement-target'] | *[local-name() = 'component'][@class = 'measurement-target'] |
										*[local-name() = 'div'][@type = 'requirement-measurement-target'] |
										*[local-name() = 'div'][@type = 'recommendation-measurement-target'] |
										*[local-name() = 'div'][@type = 'permission-measurement-target']">
		<fo:block xsl:use-attribute-sets="measurement-target-style">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'verification'] | *[local-name() = 'component'][@class = 'verification'] |
										*[local-name() = 'div'][@type = 'requirement-verification'] |
										*[local-name() = 'div'][@type = 'recommendation-verification'] |
										*[local-name() = 'div'][@type = 'permission-verification']">
		<fo:block xsl:use-attribute-sets="verification-style">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'import'] | *[local-name() = 'component'][@class = 'import'] |
										*[local-name() = 'div'][@type = 'requirement-import'] |
										*[local-name() = 'div'][@type = 'recommendation-import'] |
										*[local-name() = 'div'][@type = 'permission-import']">
		<fo:block xsl:use-attribute-sets="import-style">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'div'][starts-with(@type, 'requirement-component')] |
										*[local-name() = 'div'][starts-with(@type, 'recommendation-component')] |
										*[local-name() = 'div'][starts-with(@type, 'permission-component')]">
		<fo:block xsl:use-attribute-sets="component-style">
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
		<fo:block-container margin-left="0mm" margin-right="0mm" margin-bottom="12pt" role="SKIP">
			<xsl:if test="ancestor::*[local-name() = 'table'][@class = 'recommendation' or @class='requirement' or @class='permission']">
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			</xsl:if>
			<fo:block-container margin-left="0mm" margin-right="0mm" role="SKIP">
				<fo:table id="{@id}" table-layout="fixed" width="100%"> <!-- border="1pt solid black" -->
					<xsl:if test="ancestor::*[local-name() = 'table'][@class = 'recommendation' or @class='requirement' or @class='permission']">
						<!-- <xsl:attribute name="border">0.5pt solid black</xsl:attribute> -->
					</xsl:if>
					<xsl:variable name="simple-table">	
						<xsl:call-template name="getSimpleTable">
							<xsl:with-param name="id" select="@id"/>
						</xsl:call-template>
					</xsl:variable>					
					<xsl:variable name="cols-count" select="count(xalan:nodeset($simple-table)//tr[1]/td)"/>
					<xsl:if test="$cols-count = 2 and not(ancestor::*[local-name()='table'])">
						<fo:table-column column-width="30%"/>
						<fo:table-column column-width="70%"/>
					</xsl:if>
					<xsl:apply-templates mode="requirement"/>
				</fo:table>
				<!-- fn processing -->
				<xsl:if test=".//*[local-name() = 'fn']">
					<xsl:for-each select="*[local-name() = 'tbody']">
						<fo:block font-size="90%" border-bottom="1pt solid black">
							<xsl:call-template name="table_fn_display" />
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
		
			<xsl:if test="parent::*[local-name()='thead'] or starts-with(*[local-name()='td' or local-name()='th'][1], 'Requirement ') or starts-with(*[local-name()='td' or local-name()='th'][1], 'Recommendation ')">
				<xsl:attribute name="font-weight">bold</xsl:attribute>
				
				<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
					<xsl:attribute name="font-weight">normal</xsl:attribute>
					<xsl:if test="parent::*[local-name()='thead']"> <!-- and not(ancestor::*[local-name() = 'table'][@class = 'recommendation' or @class='requirement' or @class='permission']) -->
						<xsl:attribute name="background-color">rgb(33, 55, 92)</xsl:attribute>
					</xsl:if>
					<xsl:if test="starts-with(*[local-name()='td'][1], 'Requirement ')">
						<xsl:attribute name="background-color">rgb(252, 246, 222)</xsl:attribute>
					</xsl:if>
					<xsl:if test="starts-with(*[local-name()='td'][1], 'Recommendation ')">
						<xsl:attribute name="background-color">rgb(233, 235, 239)</xsl:attribute>
					</xsl:if>
				</xsl:if>
			</xsl:if>
			
			<xsl:apply-templates mode="requirement"/>
		</fo:table-row>
	</xsl:template>
	
	
	<xsl:template match="*[local-name()='th']" mode="requirement">
		<fo:table-cell text-align="{@align}" display-align="center" padding="1mm" padding-left="2mm"> <!-- border="0.5pt solid black" -->
			<xsl:call-template name="setTextAlignment">
				<xsl:with-param name="default">left</xsl:with-param>
			</xsl:call-template>
			
			<xsl:call-template name="setTableCellAttributes"/>
			
			<fo:block role="SKIP">
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
			<xsl:call-template name="setTextAlignment">
				<xsl:with-param name="default">left</xsl:with-param>
			</xsl:call-template>
			
			<xsl:if test="following-sibling::*[local-name()='td'] and not(preceding-sibling::*[local-name()='td'])">
				<xsl:attribute name="font-weight">bold</xsl:attribute>
			</xsl:if>
			
			<xsl:call-template name="setTableCellAttributes"/>
			
			<fo:block role="SKIP">			
				<xsl:apply-templates />
			</fo:block>			
		</fo:table-cell>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'p'][@class='RecommendationTitle' or @class = 'RecommendationTestTitle']" priority="2">
		<fo:block font-size="11pt">
			<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
				<!-- <xsl:attribute name="color"><xsl:value-of select="$color_design"/></xsl:attribute> -->
				<xsl:attribute name="color">white</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'p2'][ancestor::*[local-name() = 'table'][@class = 'recommendation' or @class='requirement' or @class='permission']]">
		<fo:block>
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
			
			<xsl:call-template name="setBlockSpanAll"/>
			
			<xsl:apply-templates select="*[local-name()='name']" />
			<xsl:apply-templates select="node()[not(local-name() = 'name')]" />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'termexample']/*[local-name() = 'name']">
		<xsl:if test="normalize-space() != ''">
			<fo:inline xsl:use-attribute-sets="termexample-name-style">
				<xsl:apply-templates /><xsl:if test="$namespace = 'ieee' or $namespace = 'rsd'">: </xsl:if>
			</fo:inline>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'termexample']/*[local-name() = 'p']">
		<xsl:variable name="element">inline
			<xsl:if test="$namespace = 'bsi'">block</xsl:if>
			<xsl:if test="$namespace = 'ieee'">block</xsl:if>
		</xsl:variable>		
		<xsl:choose>			
			<xsl:when test="contains($element, 'block')">
				<fo:block xsl:use-attribute-sets="example-p-style">
				
					<xsl:if test="$namespace = 'ieee'">
						<xsl:if test="not(preceding-sibling::*[local-name() = 'p'])">
							<xsl:attribute name="margin-top">6pt</xsl:attribute>
						</xsl:if>
					</xsl:if>
						
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
	
	<!-- There are a few cases:
	1. EXAMPLE text
	2. EXAMPLE
	        text
	3. EXAMPLE text line 1
	     text line 2
	4. EXAMPLE
	     text line 1
			 text line 2
	-->
	<xsl:template match="*[local-name() = 'example']">
		
		<fo:block-container id="{@id}" xsl:use-attribute-sets="example-style" role="SKIP">
		
			<xsl:call-template name="setBlockSpanAll"/>
		
			<xsl:call-template name="refine_example-style"/>
		
			<xsl:variable name="fo_element">
				<xsl:if test=".//*[local-name() = 'table'] or .//*[local-name() = 'dl'] or *[not(local-name() = 'name')][1][local-name() = 'sourcecode']">block</xsl:if> 
				<xsl:choose>			
					<xsl:when test="$namespace = 'bsi' or 
														$namespace = 'iho' or 
														$namespace = 'iso' or 
														$namespace = 'jcgm' or 
														$namespace = 'm3d' or
														$namespace = 'ogc' or 
														$namespace = 'rsd'">inline</xsl:when> <!-- display first Example paragraph on the same line as EXAMPLE title -->
					<xsl:when test="$namespace = 'iec'">
						<xsl:choose>
							<!-- if example contains only one (except 'name') element (paragraph for example), then display it on the same line as EXAMPLE title -->
							<xsl:when test="count(*[not(local-name() = 'name')]) = 1">inline</xsl:when>
							<xsl:otherwise>block</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="$namespace= 'jis'">list</xsl:when>
					<xsl:otherwise>block</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<fo:block-container margin-left="0mm" role="SKIP">
			
				<xsl:choose>
					
					<xsl:when test="contains(normalize-space($fo_element), 'block')">
					
						<!-- display name 'EXAMPLE' in a separate block  -->
						<fo:block>
							<xsl:apply-templates select="*[local-name()='name']">
								<xsl:with-param name="fo_element" select="$fo_element"/>
							</xsl:apply-templates>
						</fo:block>
						
						<fo:block-container xsl:use-attribute-sets="example-body-style" role="SKIP">
							<fo:block-container margin-left="0mm" margin-right="0mm" role="SKIP"> 
								<xsl:apply-templates select="node()[not(local-name() = 'name')]">
									<xsl:with-param name="fo_element" select="$fo_element"/>
								</xsl:apply-templates>
							</fo:block-container>
						</fo:block-container>
					</xsl:when> <!-- end block -->
					
					<xsl:when test="contains(normalize-space($fo_element), 'list')">
					
						<xsl:variable name="provisional_distance_between_starts">
							<xsl:choose>
								<xsl:when test="$namespace = 'jis'"><xsl:value-of select="10 + $text_indent"/></xsl:when>
								<xsl:otherwise>7</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="indent">
							<xsl:choose>
								<xsl:when test="$namespace = 'jis'"><xsl:value-of select="$text_indent"/></xsl:when>
								<xsl:otherwise>0</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
					
						<fo:list-block provisional-distance-between-starts="{$provisional_distance_between_starts}mm">
							<fo:list-item>
								<fo:list-item-label start-indent="{$indent}mm" end-indent="label-end()">
									<fo:block>
										<xsl:apply-templates select="*[local-name()='name']">
											<xsl:with-param name="fo_element">block</xsl:with-param>
										</xsl:apply-templates>
									</fo:block>
								</fo:list-item-label>
								<fo:list-item-body start-indent="body-start()">
									<fo:block>
										<xsl:apply-templates select="node()[not(local-name() = 'name')]">
											<xsl:with-param name="fo_element" select="$fo_element"/>
										</xsl:apply-templates>
									</fo:block>
								</fo:list-item-body>
							</fo:list-item>
						</fo:list-block>
					</xsl:when> <!-- end list -->
					
					<xsl:otherwise> <!-- inline -->
					
						<!-- display 'EXAMPLE' and first element in the same line -->
						<fo:block>
							<xsl:apply-templates select="*[local-name()='name']">
								<xsl:with-param name="fo_element" select="$fo_element"/>
							</xsl:apply-templates>
							<fo:inline>
								<xsl:apply-templates select="*[not(local-name() = 'name')][1]">
									<xsl:with-param name="fo_element" select="$fo_element"/>
								</xsl:apply-templates>
							</fo:inline>
						</fo:block> 
						
						<xsl:if test="*[not(local-name() = 'name')][position() &gt; 1]">
							<!-- display further elements in blocks -->
							<fo:block-container xsl:use-attribute-sets="example-body-style" role="SKIP">
								<fo:block-container margin-left="0mm" margin-right="0mm" role="SKIP">
									<xsl:apply-templates select="*[not(local-name() = 'name')][position() &gt; 1]">
										<xsl:with-param name="fo_element" select="'block'"/>
									</xsl:apply-templates>
								</fo:block-container>
							</fo:block-container>
						</xsl:if>
					</xsl:otherwise> <!-- end inline -->
					
				</xsl:choose>
			</fo:block-container>
		</fo:block-container>
	</xsl:template>
	
	
	<xsl:template match="*[local-name() = 'example']/*[local-name() = 'name']">
		<xsl:param name="fo_element">block</xsl:param>
	
		<xsl:choose>
			<xsl:when test="ancestor::*[local-name() = 'appendix']">
				<fo:inline>
					<xsl:apply-templates/>
				</fo:inline>
			</xsl:when>
			<xsl:when test="contains(normalize-space($fo_element), 'block')">
				<fo:block xsl:use-attribute-sets="example-name-style">
					<xsl:apply-templates/>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<fo:inline xsl:use-attribute-sets="example-name-style">
					<xsl:apply-templates/><xsl:if test="$namespace = 'ieee' or $namespace = 'iho' or $namespace = 'ogc' or $namespace = 'rsd'">: </xsl:if>
				</fo:inline>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>
	
	<xsl:template match="*[local-name() = 'table']/*[local-name() = 'example']/*[local-name() = 'name']">
		<fo:inline xsl:use-attribute-sets="example-name-style">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'example']/*[local-name() = 'p']">
		<xsl:param name="fo_element">block</xsl:param>
		
		<xsl:variable name="num"><xsl:number/></xsl:variable>
		<xsl:variable name="element">
			<xsl:if test="$namespace = 'iso' or $namespace = 'jcgm' or $namespace = 'rsd'">
				<xsl:choose>
					<xsl:when test="$num = 1 and not(contains($fo_element, 'block'))">inline</xsl:when>
					<xsl:otherwise>block</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:value-of select="$fo_element"/>
		</xsl:variable>		
		<xsl:choose>			
			<xsl:when test="starts-with(normalize-space($element), 'block')">
				<fo:block-container role="SKIP">
					<xsl:if test="ancestor::*[local-name() = 'li'] and contains(normalize-space($fo_element), 'block')">
						<xsl:attribute name="margin-left">0mm</xsl:attribute>
						<xsl:attribute name="margin-right">0mm</xsl:attribute>
					</xsl:if>
					<fo:block xsl:use-attribute-sets="example-p-style">
					
						<xsl:call-template name="refine_example-p-style"/>
						
						<xsl:apply-templates/>
					</fo:block>
				</fo:block-container>
			</xsl:when>
			<xsl:when test="starts-with(normalize-space($element), 'list')">
				<fo:block xsl:use-attribute-sets="example-p-style">
					<xsl:apply-templates/>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<fo:inline xsl:use-attribute-sets="example-p-style">
					<xsl:apply-templates/>					
				</fo:inline>
			</xsl:otherwise>
		</xsl:choose>	
	</xsl:template> <!-- example/p -->
	
	<!-- ====== -->
	<!-- ====== -->


	<!-- ====== -->
	<!-- termsource -->	
	<!-- origin -->	
	<!-- modification -->		
	<!-- ====== -->
	<xsl:template match="*[local-name() = 'termsource']" name="termsource">
		<fo:block xsl:use-attribute-sets="termsource-style">
			
			<xsl:call-template name="refine_termsource-style"/>
			
			<!-- Example: [SOURCE: ISO 5127:2017, 3.1.6.02] -->			
			<xsl:variable name="termsource_text">
				<xsl:apply-templates />
			</xsl:variable>
			<xsl:copy-of select="$termsource_text"/>
			<!-- <xsl:choose>
				<xsl:when test="starts-with(normalize-space($termsource_text), '[')">
					<xsl:copy-of select="$termsource_text"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="$namespace = 'bsi'">
						<xsl:choose>
							<xsl:when test="$document_type = 'PAS' and starts-with(*[local-name() = 'origin']/@citeas, '[')"><xsl:text>{</xsl:text></xsl:when>
							<xsl:otherwise><xsl:text>[</xsl:text></xsl:otherwise>
						</xsl:choose>
					</xsl:if>
					<xsl:if test="$namespace = 'gb' or $namespace = 'iso' or $namespace = 'iec' or $namespace = 'itu' or $namespace = 'unece' or $namespace = 'unece-rec' or $namespace = 'nist-cswp'  or $namespace = 'nist-sp' or $namespace = 'ogc-white-paper' or $namespace = 'csa' or $namespace = 'csd' or $namespace = 'm3d' or $namespace = 'iho' or $namespace = 'bipm' or $namespace = 'jcgm'">
						<xsl:text>[</xsl:text>
					</xsl:if>
					<xsl:copy-of select="$termsource_text"/>
					<xsl:if test="$namespace = 'bsi'">
						<xsl:choose>
							<xsl:when test="$document_type = 'PAS' and starts-with(*[local-name() = 'origin']/@citeas, '[')"><xsl:text>}</xsl:text></xsl:when>
							<xsl:otherwise><xsl:text>]</xsl:text></xsl:otherwise>
						</xsl:choose>
					</xsl:if>
					<xsl:if test="$namespace = 'gb' or $namespace = 'iso' or $namespace = 'iec' or $namespace = 'itu' or $namespace = 'unece' or $namespace = 'unece-rec' or $namespace = 'nist-cswp'  or $namespace = 'nist-sp' or $namespace = 'ogc-white-paper' or $namespace = 'csa' or $namespace = 'csd' or $namespace = 'm3d' or $namespace = 'iho' or $namespace = 'bipm' or $namespace = 'jcgm'">
						<xsl:text>]</xsl:text>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose> -->
		</fo:block>
	</xsl:template>

	
	<xsl:template match="*[local-name() = 'termsource']/text()[starts-with(., '[SOURCE: Adapted from: ') or
				starts-with(., '[SOURCE: Quoted from: ') or
				starts-with(., '[SOURCE: Modified from: ')]" priority="2">
		<xsl:text>[</xsl:text><xsl:value-of select="substring-after(., '[SOURCE: ')"/>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'termsource']/text()">
		<xsl:if test="normalize-space() != ''">
			<xsl:value-of select="."/>
		</xsl:if>
	</xsl:template>
	
	
	<!-- text SOURCE: -->
	<xsl:template match="*[local-name() = 'termsource']/*[local-name() = 'strong'][1][following-sibling::*[1][local-name() = 'origin']]/text()">
		<fo:inline xsl:use-attribute-sets="termsource-text-style">
			<xsl:value-of select="."/>
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'origin']">
		<xsl:call-template name="insert_basic_link">
			<xsl:with-param name="element">
				<fo:basic-link internal-destination="{@bibitemid}" fox:alt-text="{@citeas}">
					<xsl:if test="normalize-space(@citeas) = ''">
						<xsl:attribute name="fox:alt-text"><xsl:value-of select="@bibitemid"/></xsl:attribute>
					</xsl:if>
					<fo:inline xsl:use-attribute-sets="origin-style">
						<xsl:apply-templates/>
					</fo:inline>
				</fo:basic-link>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	
	<!-- not using, see https://github.com/glossarist/iev-document/issues/23 -->
	<xsl:template match="*[local-name() = 'modification']">
		<xsl:variable name="title-modified">
			<xsl:call-template name="getLocalizedString">
				<xsl:with-param name="key">modified</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		
    <xsl:variable name="text"><xsl:apply-templates/></xsl:variable>
		<xsl:choose>
			<xsl:when test="$lang = 'zh'"><xsl:text>、</xsl:text><xsl:value-of select="$title-modified"/><xsl:if test="normalize-space($text) != ''"><xsl:text>—</xsl:text></xsl:if></xsl:when>
			<xsl:otherwise><xsl:text>, </xsl:text><xsl:value-of select="$title-modified"/><xsl:if test="normalize-space($text) != ''"><xsl:text> — </xsl:text></xsl:if></xsl:otherwise>
		</xsl:choose>
		<xsl:apply-templates/>
	</xsl:template>	
	
	<xsl:template match="*[local-name() = 'modification']/*[local-name() = 'p']">
		<fo:inline><xsl:apply-templates /></fo:inline>
	</xsl:template>	
	
	<xsl:template match="*[local-name() = 'modification']/text()">
		<xsl:if test="normalize-space() != ''">
			<!-- <xsl:value-of select="."/> -->
			<xsl:call-template name="text"/>
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
		<fo:block-container margin-left="0mm" role="SKIP">
		
			<xsl:call-template name="setBlockSpanAll"/>
			
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
			<fo:block-container margin-left="0mm" role="SKIP">
				<fo:block-container xsl:use-attribute-sets="quote-style" role="SKIP">
				
					<xsl:call-template name="refine_quote-style"/>

					<fo:block-container margin-left="0mm" margin-right="0mm" role="SKIP">
						<fo:block role="BlockQuote">
							<xsl:apply-templates select="./node()[not(local-name() = 'author') and not(local-name() = 'source')]"/> <!-- process all nested nodes, except author and source -->
						</fo:block>
					</fo:block-container>
				</fo:block-container>
				<xsl:if test="*[local-name() = 'author'] or *[local-name() = 'source']">
					<fo:block xsl:use-attribute-sets="quote-source-style">
						<!-- — ISO, ISO 7301:2011, Clause 1 -->
						<xsl:apply-templates select="*[local-name() = 'author']"/>
						<xsl:apply-templates select="*[local-name() = 'source']"/>				
					</fo:block>
				</xsl:if>
				
				<xsl:if test="$namespace = 'jis'">
					<!-- render footnotes after references -->
					<xsl:apply-templates select=".//jis:fn[generate-id(.)=generate-id(key('kfn',@reference)[1])]" mode="fn_after_element">
						<xsl:with-param name="ancestor">quote</xsl:with-param>
					</xsl:apply-templates>
				</xsl:if>
        
			</fo:block-container>
		</fo:block-container>
	</xsl:template>

	
	<xsl:template match="*[local-name() = 'source']">
		<xsl:if test="../*[local-name() = 'author']">
			<xsl:text>, </xsl:text>
		</xsl:if>
		<xsl:call-template name="insert_basic_link">
			<xsl:with-param name="element">
				<fo:basic-link internal-destination="{@bibitemid}" fox:alt-text="{@citeas}">
					<xsl:apply-templates />
				</fo:basic-link>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'author']">
		<xsl:text>— </xsl:text>
		<xsl:apply-templates />
	</xsl:template>
	<!-- ====== -->
	<!-- ====== -->

	<xsl:variable name="bibitems_">
		<xsl:for-each select="//*[local-name() = 'bibitem']">
			<xsl:copy-of select="."/>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="bibitems" select="xalan:nodeset($bibitems_)"/>
	
	<!-- get all hidden bibitems to exclude them from eref/origin processing -->
	<xsl:variable name="bibitems_hidden_">
		<xsl:for-each select="//*[local-name() = 'bibitem'][@hidden='true']">
			<xsl:copy-of select="."/>
		</xsl:for-each>
		<xsl:for-each select="//*[local-name() = 'references'][@hidden='true']//*[local-name() = 'bibitem']">
			<xsl:copy-of select="."/>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="bibitems_hidden" select="xalan:nodeset($bibitems_hidden_)"/>
	<!-- ====== -->
	<!-- eref -->	
	<!-- ====== -->
	<xsl:template match="*[local-name() = 'eref']" name="eref">
		<xsl:variable name="current_bibitemid" select="@bibitemid"/>
		<!-- <xsl:variable name="external-destination" select="normalize-space(key('bibitems', $current_bibitemid)/*[local-name() = 'uri'][@type = 'citation'])"/> -->
		<xsl:variable name="external-destination" select="normalize-space($bibitems/*[local-name() ='bibitem'][@id = $current_bibitemid]/*[local-name() = 'uri'][@type = 'citation'])"/>
		<xsl:choose>
			<!-- <xsl:when test="$external-destination != '' or not(key('bibitems_hidden', $current_bibitemid))"> --> <!-- if in the bibliography there is the item with @bibitemid (and not hidden), then create link (internal to the bibitem or external) -->
			<xsl:when test="$external-destination != '' or not($bibitems_hidden/*[local-name() ='bibitem'][@id = $current_bibitemid])"> <!-- if in the bibliography there is the item with @bibitemid (and not hidden), then create link (internal to the bibitem or external) -->
				<fo:inline xsl:use-attribute-sets="eref-style">
					<xsl:if test="@type = 'footnote'">
						<xsl:attribute name="keep-together.within-line">always</xsl:attribute>
						<xsl:attribute name="keep-with-previous.within-line">always</xsl:attribute>
						<xsl:attribute name="vertical-align">super</xsl:attribute>
						<xsl:attribute name="font-size">80%</xsl:attribute>
						<xsl:if test="$namespace = 'gb' or $namespace = 'm3d'">
							<xsl:attribute name="font-size">50%</xsl:attribute>
						</xsl:if>
					</xsl:if>	
					
					<xsl:call-template name="refine_eref-style"/>
					
					<xsl:call-template name="insert_basic_link">
						<xsl:with-param name="element">
							<fo:basic-link fox:alt-text="{@citeas}">
								<xsl:if test="normalize-space(@citeas) = ''">
									<xsl:attribute name="fox:alt-text"><xsl:value-of select="."/></xsl:attribute>
								</xsl:if>
								<xsl:if test="@type = 'inline'">
									
									<xsl:call-template name="refine_basic_link_style"/>
									
								</xsl:if>
								
								<xsl:choose>
									<xsl:when test="$external-destination != ''"> <!-- external hyperlink -->
										<xsl:attribute name="external-destination"><xsl:value-of select="$external-destination"/></xsl:attribute>
									</xsl:when>
									<xsl:otherwise>
										<xsl:attribute name="internal-destination"><xsl:value-of select="@bibitemid"/></xsl:attribute>
									</xsl:otherwise>
								</xsl:choose>
								
								<xsl:apply-templates />
							</fo:basic-link>
						</xsl:with-param>
					</xsl:call-template>
					
				</fo:inline>
			</xsl:when>
			<xsl:otherwise> <!-- if there is key('bibitems_hidden', $current_bibitemid) -->
			
				<!-- if in bibitem[@hidden='true'] there is url[@type='src'], then create hyperlink  -->
				<xsl:variable name="uri_src" select="normalize-space($bibitems_hidden/*[local-name() ='bibitem'][@id = $current_bibitemid]/*[local-name() = 'uri'][@type = 'src'])"/>
				<xsl:choose>
					<xsl:when test="$uri_src != ''">
						<fo:basic-link external-destination="{$uri_src}" fox:alt-text="{$uri_src}"><xsl:apply-templates /></fo:basic-link>
					</xsl:when>
					<xsl:otherwise><fo:inline><xsl:apply-templates /></fo:inline></xsl:otherwise>
				</xsl:choose>
				
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<xsl:template name="refine_basic_link_style">
		<xsl:if test="$namespace = 'csd' or $namespace = 'iho' or $namespace = 'ogc-white-paper' or $namespace = 'mpfd'">
			<xsl:attribute name="color">blue</xsl:attribute>
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="color">blue</xsl:attribute>
			<xsl:if test="not(parent::*[local-name() = 'title'])">
				<xsl:attribute name="text-decoration">underline</xsl:attribute>
			</xsl:if>
			<xsl:if test="parent::*[local-name() = 'title']">
				<xsl:attribute name="color">inherit</xsl:attribute>
				<xsl:attribute name="font-weight">normal</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp' or 
											$namespace = 'nist-sp' or 
											$namespace = 'unece'">
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		</xsl:if>
	</xsl:template> <!-- refine_basic_link_style -->	
	
	<!-- ====== -->
	<!-- END eref -->
	<!-- ====== -->
	
	<!-- Tabulation processing -->
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
					<xsl:when test="$doctype = 'expert-commentary'">1</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="$depth = 1 and ../@ancestor = 'annex'">1.5</xsl:when>
							<xsl:when test="$depth = 2">3</xsl:when>
							<xsl:otherwise>4</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:if test="$namespace = 'ieee'">1</xsl:if>
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
					<xsl:when test="ancestor::*[local-name() = 'note'] and ancestor::*[local-name() = 'name']">1</xsl:when>
					<xsl:when test="$depth = 2">2</xsl:when>
					<xsl:otherwise>1</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:if test="$namespace = 'ogc-white-paper'">
				<xsl:choose>
					<xsl:when test="ancestor::*[local-name() = 'note'] and ancestor::*[local-name() = 'name']">4</xsl:when>
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
		
		<xsl:choose>
			<xsl:when test="$lang = 'zh'">
				<fo:inline role="SKIP"><xsl:value-of select="$tab_zh"/></fo:inline>
			</xsl:when>
			<xsl:when test="../../@inline-header = 'true'">
				<fo:inline font-size="90%" role="SKIP">
					<xsl:call-template name="insertNonBreakSpaces">
						<xsl:with-param name="count" select="$padding-right"/>
					</xsl:call-template>
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="direction"><xsl:if test="$lang = 'ar'"><xsl:value-of select="$RLM"/></xsl:if></xsl:variable>
				<fo:inline padding-right="{$padding-right}mm" role="SKIP"><xsl:value-of select="$direction"/>&#x200B;</fo:inline>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template> <!-- tab -->
	
	<xsl:template name="insertNonBreakSpaces">
		<xsl:param name="count"/>
		<xsl:if test="$count &gt; 0">
			<xsl:text>&#xA0;</xsl:text>
			<xsl:call-template name="insertNonBreakSpaces">
				<xsl:with-param name="count" select="$count - 1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<!-- Preferred, admitted, deprecated -->
	<xsl:template match="*[local-name() = 'preferred']">
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		<xsl:variable name="font-size">
			<xsl:choose>
				<xsl:when test="$namespace = 'csa'">
					<xsl:choose>
						<xsl:when test="$level &gt;= 2">11pt</xsl:when>
						<xsl:otherwise>12pt</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="$namespace = 'csd'">
					<xsl:choose>
						<xsl:when test="$level &gt;= 3">11pt</xsl:when>
						<xsl:otherwise>12pt</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="$namespace = 'ogc-white-paper'">
					<xsl:choose>
						<xsl:when test="$level &gt;= 2">11pt</xsl:when>
						<xsl:otherwise>12pt</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>inherit</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="levelTerm">
			<xsl:call-template name="getLevelTermName"/>
		</xsl:variable>
		<fo:block font-size="{normalize-space($font-size)}" role="H{$levelTerm}" xsl:use-attribute-sets="preferred-block-style">
		
			<xsl:if test="$namespace = 'iec'">
				<xsl:if test="preceding-sibling::*[1][self::iec:preferred]">
					<xsl:attribute name="space-before">1pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			
			<xsl:if test="parent::*[local-name() = 'term'] and not(preceding-sibling::*[local-name() = 'preferred'])"> <!-- if first preffered in term, then display term's name -->
				<fo:block xsl:use-attribute-sets="term-name-style" role="SKIP">
					<xsl:apply-templates select="ancestor::*[local-name() = 'term'][1]/*[local-name() = 'name']" />
				</fo:block>
			</xsl:if>
			
			<fo:block xsl:use-attribute-sets="preferred-term-style" role="SKIP">
				<xsl:call-template name="setStyle_preferred"/>
				<xsl:apply-templates />
			</fo:block>
		</fo:block>
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
		<fo:block xsl:use-attribute-sets="deprecates-style">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>

	<xsl:template name="setStyle_preferred">
		<xsl:if test="*[local-name() = 'strong']">
			<xsl:attribute name="font-weight">normal</xsl:attribute>
		</xsl:if>
	</xsl:template>
	
	<!-- regarding ISO 10241-1:2011,  If there is more than one preferred term, each preferred term follows the previous one on a new line. -->
	<!-- in metanorma xml preferred terms delimited by semicolons -->
	<xsl:template match="*[local-name() = 'preferred']/text()[contains(., ';')] | *[local-name() = 'preferred']/*[local-name() = 'strong']/text()[contains(., ';')]">
		<xsl:value-of select="java:replaceAll(java:java.lang.String.new(.), ';', $linebreak)"/>
	</xsl:template>
	<!--  End Preferred, admitted, deprecated -->
	
	<!-- ========== -->
	<!-- definition -->
	<!-- ========== -->
	<xsl:template match="*[local-name() = 'definition']">
		<fo:block xsl:use-attribute-sets="definition-style" role="SKIP">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'definition'][preceding-sibling::*[local-name() = 'domain']]">
		<xsl:apply-templates />
	</xsl:template>
	<xsl:template match="*[local-name() = 'definition'][preceding-sibling::*[local-name() = 'domain']]/*[local-name() = 'p'][1]">
		<fo:inline> <xsl:apply-templates /></fo:inline>
		<fo:block></fo:block>
	</xsl:template>
	<!-- ========== -->
	<!-- END definition -->
	<!-- ========== -->
	
	
	<!-- main sections -->
	<xsl:template match="/*/*[local-name() = 'sections']/*" priority="2">
		<xsl:if test="$namespace = 'm3d' or $namespace = 'unece-rec'">
				<fo:block break-after="page"/>
		</xsl:if>
		<fo:block>
			<xsl:call-template name="setId"/>
			
			<xsl:call-template name="sections_element_style"/>
			
			<xsl:apply-templates />
		</fo:block>
		
		<xsl:if test="$namespace = 'nist-cswp' or $namespace = 'nist-sp'">
				<xsl:if test="position() != last()">
					<fo:block break-after="page"/>
				</xsl:if>
		</xsl:if>
		
	</xsl:template>
	
	<xsl:template name="sections_element_style">
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
			<xsl:variable name="pos"><xsl:number count="ribose:sections/ribose:clause[not(@type='scope') and not(@type='conformance')]"/></xsl:variable> <!--  | ribose:sections/ribose:terms -->
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
	</xsl:template> <!-- sections_element_style -->
	
	<xsl:template match="//*[contains(local-name(), '-standard')]/*[local-name() = 'preface']/*" priority="2"> <!-- /*/*[local-name() = 'preface']/* -->
		<fo:block break-after="page"/>
		<fo:block>
			<xsl:call-template name="setId"/>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>



	
	<xsl:template match="*[local-name() = 'clause']">
		<fo:block>
			<xsl:if test="parent::*[local-name() = 'copyright-statement']">
				<xsl:attribute name="role">SKIP</xsl:attribute>
			</xsl:if>
			
			<xsl:call-template name="setId"/>
			
			<xsl:call-template name="setBlockSpanAll"/>
			
			<xsl:call-template name="refine_clause_style"/>
			
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template name="refine_clause_style">
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
	</xsl:template> <!-- refine_clause_style -->
	
	<xsl:template match="*[local-name() = 'definitions']">
		<fo:block id="{@id}">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	
	
	<xsl:template match="*[local-name() = 'annex']">
		<fo:block break-after="page"/>
		<fo:block>
		
			<xsl:call-template name="setBlockSpanAll"/>
			
			<xsl:call-template name="refine_annex_style"/>
			
		</fo:block>
		<fo:block id="{@id}">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template name="refine_annex_style">
		<xsl:if test="$namespace = 'unece' or $namespace = 'unece-rec'">
			<xsl:variable name="num"><xsl:number /></xsl:variable>
			<xsl:if test="$num = 1">
				<xsl:attribute name="margin-top">3pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'review']"> <!-- 'review' will be processed in mn2pdf/review.xsl -->
		<!-- comment 2019-11-29 -->
		<!-- <fo:block font-weight="bold">Review:</fo:block>
		<xsl:apply-templates /> -->
		
		<xsl:variable name="id_from" select="normalize-space(current()/@from)"/>

		<xsl:choose>
			<!-- if there isn't the attribute '@from', then -->
			<xsl:when test="$id_from = ''">
				<fo:block id="{@id}" font-size="1pt"><xsl:value-of select="$hair_space"/></fo:block>
			</xsl:when>
			<!-- if there isn't element with id 'from', then create 'bookmark' here -->
			<xsl:when test="ancestor::*[contains(local-name(), '-standard')] and not(ancestor::*[contains(local-name(), '-standard')]//*[@id = $id_from])">
				<fo:block id="{@from}" font-size="1pt"><xsl:value-of select="$hair_space"/></fo:block>
			</xsl:when>
			<xsl:when test="not(//*[@id = $id_from]) and not(preceding-sibling::*[@id = $id_from])">
				<fo:block id="{@from}" font-size="1pt"><xsl:value-of select="$hair_space"/></fo:block>
			</xsl:when>
		</xsl:choose>
		
	</xsl:template>

	<!-- https://github.com/metanorma/mn-samples-bsi/issues/312 -->
	<xsl:template match="*[local-name() = 'review'][@type = 'other']"/>

	<xsl:template match="*[local-name() = 'name']/text()">
		<!-- 0xA0 to space replacement -->
		<xsl:value-of select="java:replaceAll(java:java.lang.String.new(.),' ',' ')"/>
	</xsl:template>
	
	
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
				<label>&#x2014;</label> <!-- em dash -->
			</xsl:when>
			<xsl:when test="$namespace = 'jcgm'">
				<label level="1">&#x2014;</label> <!-- em dash -->
				<label level="2">&#x2212;</label><!-- minus sign -->
				<label level="3" font-size="75%">o</label> <!-- white circle -->
			</xsl:when>
			<xsl:when test="$namespace = 'jis'">
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
				<xsl:when test="$namespace = 'jis'"><xsl:value-of select="count(ancestor::*[local-name() = 'ul'])"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="count(ancestor::*[local-name() = 'ul']) + count(ancestor::*[local-name() = 'ol'])" /></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="list_level_" select="number($list_level__)"/>
		<xsl:variable name="list_level">
			<xsl:choose>
				<xsl:when test="$list_level_ &lt;= 3"><xsl:value-of select="$list_level_"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$list_level_ mod 3"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$ul_labels/label[not(@level)]"> <!-- one label for all levels -->
				<xsl:apply-templates select="$ul_labels/label[not(@level)]" mode="ul_labels"/>
			</xsl:when>
			<xsl:when test="$list_level mod 3 = 0">
				<xsl:apply-templates select="$ul_labels/label[@level = 3]" mode="ul_labels"/>
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
					<xsl:otherwise><xsl:call-template name="setULLabel"/></xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="local-name(..) = 'ol' and @label"> <!-- for ordered lists 'ol', and if there is @label, for instance label="1.1.2" -->
				
				<xsl:variable name="label">
				
					<xsl:variable name="type" select="../@type"/>
					
					<xsl:variable name="style_prefix_">
						<xsl:if test="$type = 'roman'">
							<xsl:if test="$namespace = 'bipm'">(</xsl:if> <!-- Example: (i) -->
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
				
				<xsl:value-of select="normalize-space($label)"/>
				
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
							
							<xsl:variable name="list_level_" select="count(ancestor::*[local-name() = 'ul']) + count(ancestor::*[local-name() = 'ol'])" />
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
	</xsl:template>

	<xsl:template match="*[local-name() = 'ul'] | *[local-name() = 'ol']">
		<xsl:choose>
			<xsl:when test="parent::*[local-name() = 'note'] or parent::*[local-name() = 'termnote']">
				<fo:block-container role="SKIP">
					<xsl:attribute name="margin-left">
						<xsl:choose>
							<xsl:when test="not(ancestor::*[local-name() = 'table'])"><xsl:value-of select="$note-body-indent"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="$note-body-indent-table"/></xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					
					<xsl:call-template name="refine_list_container_style"/>
					
					<fo:block-container margin-left="0mm" role="SKIP">
						<fo:block>
							<xsl:apply-templates select="." mode="list"/>
						</fo:block>
					</fo:block-container>
				</fo:block-container>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$namespace = 'jis'">
						<fo:block-container role="SKIP">
							<xsl:if test="ancestor::jis:ol or ancestor::jis:ul">
								<xsl:attribute name="margin-left">3.5mm</xsl:attribute>
							</xsl:if>
							<fo:block-container margin-left="0mm" role="SKIP">
								<fo:block>
									<xsl:apply-templates select="." mode="list"/>
								</fo:block>
							</fo:block-container>
						</fo:block-container>
					</xsl:when>
					<xsl:otherwise>
						<fo:block role="SKIP">
							<xsl:apply-templates select="." mode="list"/>
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
				<xsl:if test="ancestor::*[local-name() = 'termnote' or local-name() = 'note']">
					<xsl:attribute name="margin-left">2mm</xsl:attribute>
				</xsl:if>
				<xsl:if test="parent::*[local-name() = 'termnote' or local-name() = 'note']">
					<xsl:attribute name="margin-left">0mm</xsl:attribute>
				</xsl:if>
			</xsl:if>
		</xsl:if>
	</xsl:template> <!-- refine_list_container_style -->
	
	<xsl:template match="*[local-name()='ul'] | *[local-name()='ol']" mode="list" name="list">
	
		<xsl:apply-templates select="*[local-name() = 'name']">
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
			<xsl:if test="local-name() = 'ol'">
				<!-- Examples: xiii), xviii), xxviii) -->
				<xsl:variable name="item_numbers">
					<xsl:for-each select="*[local-name() = 'li']">
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
			
			<xsl:if test="*[local-name() = 'name']">
				<xsl:attribute name="margin-top">0pt</xsl:attribute>
			</xsl:if>
			
			<xsl:apply-templates select="node()[not(local-name() = 'note')]" />
		</fo:list-block>
		<!-- <xsl:for-each select="./iho:note">
			<xsl:call-template name="note"/>
		</xsl:for-each> -->
		<xsl:apply-templates select="./*[local-name() = 'note']"/>
	</xsl:template>
	
	<xsl:template name="refine_list-style_provisional-distance-between-starts">
		<xsl:if test="$namespace = 'iec'">
			<xsl:if test="ancestor::iec:legal-statement or ancestor::iec:clause[@type = 'boilerplate_legal']">
				<xsl:attribute name="provisional-distance-between-starts">5mm</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'gb' or $namespace = 'm3d' or $namespace = 'mpfd'">
			<xsl:if test="local-name() = 'ol'">
				<xsl:attribute name="provisional-distance-between-starts">7mm</xsl:attribute>
			</xsl:if>			
		</xsl:if>
		<xsl:if test="$namespace = 'unece' or $namespace = 'unece-rec'">
			<xsl:if test="local-name() = 'ol'">
				<xsl:attribute name="provisional-distance-between-starts">6mm</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template> <!-- refine_list-style_provisional-distance-between-starts -->
	
	
	<xsl:template match="*[local-name() = 'ol' or local-name() = 'ul']/*[local-name() = 'name']">
		<xsl:param name="process">false</xsl:param>
		<xsl:if test="$process = 'true'">
			<fo:block xsl:use-attribute-sets="list-name-style">
				<xsl:apply-templates />
			</fo:block>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="*[local-name()='li']">
		<fo:list-item xsl:use-attribute-sets="list-item-style">
			<xsl:copy-of select="@id"/>
			
			<xsl:call-template name="refine_list-item-style"/>
			
			<fo:list-item-label end-indent="label-end()">
				<fo:block xsl:use-attribute-sets="list-item-label-style" role="SKIP">
				
					<xsl:call-template name="refine_list-item-label-style"/>
					
					<!-- if 'p' contains all text in 'add' first and last elements in first p are 'add' -->
					<xsl:if test="*[1][count(node()[normalize-space() != '']) = 1 and *[local-name() = 'add']]">
						<xsl:call-template name="append_add-style"/>
					</xsl:if>
					
					<xsl:call-template name="getListItemFormat" />
					
				</fo:block>
			</fo:list-item-label>
			<fo:list-item-body start-indent="body-start()" xsl:use-attribute-sets="list-item-body-style">
				<fo:block role="SKIP">
				
					<xsl:call-template name="refine_list-item-body-style"/>
					
					<xsl:apply-templates />
				
					<!-- <xsl:apply-templates select="node()[not(local-name() = 'note')]" />
					
					<xsl:for-each select="./bsi:note">
						<xsl:call-template name="note"/>
					</xsl:for-each> -->
				</fo:block>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>

	
	<!-- ===================================== -->
	<!-- END Lists processing -->
	<!-- ===================================== -->


	<!-- =================== -->
	<!-- Index section processing -->
	<!-- =================== -->

	<xsl:variable name="index" select="document($external_index)"/>
	
	<xsl:variable name="bookmark_in_fn">
		<xsl:for-each select="//*[local-name() = 'bookmark'][ancestor::*[local-name() = 'fn']]">
			<bookmark><xsl:value-of select="@id"/></bookmark>
		</xsl:for-each>
	</xsl:variable>

	<xsl:template match="@*|node()" mode="index_add_id">
		<xsl:param name="docid"/>
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="index_add_id">
				<xsl:with-param name="docid" select="$docid"/>
			</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'xref']" mode="index_add_id">
		<xsl:param name="docid"/>
		<xsl:variable name="id">
			<xsl:call-template name="generateIndexXrefId">
				<xsl:with-param name="docid" select="$docid"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:copy> <!-- add id to xref -->
			<xsl:apply-templates select="@*" mode="index_add_id"/>
			<xsl:attribute name="id">
				<xsl:value-of select="$id"/>
			</xsl:attribute>
			<xsl:apply-templates mode="index_add_id">
				<xsl:with-param name="docid" select="$docid"/>
			</xsl:apply-templates>
		</xsl:copy>
		<!-- split <xref target="bm1" to="End" pagenumber="true"> to two xref:
		<xref target="bm1" pagenumber="true"> and <xref target="End" pagenumber="true"> -->
		<xsl:if test="@to">
			<xsl:value-of select="$en_dash"/>
			<xsl:copy>
				<xsl:copy-of select="@*"/>
				<xsl:attribute name="target"><xsl:value-of select="@to"/></xsl:attribute>
				<xsl:attribute name="id">
					<xsl:value-of select="$id"/><xsl:text>_to</xsl:text>
				</xsl:attribute>
				<xsl:apply-templates mode="index_add_id">
					<xsl:with-param name="docid" select="$docid"/>
				</xsl:apply-templates>
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
			<xsl:when test="self::text()  and (normalize-space(.) = ',' or normalize-space(.) = $en_dash) and $remove = 'true'">
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
				
				<xsl:variable name="id_next" select="following-sibling::*[local-name() = 'xref'][1]/@id"/>
				<xsl:variable name="id_prev" select="preceding-sibling::*[local-name() = 'xref'][1]/@id"/>
				
				<xsl:variable name="pages_">
					<xsl:for-each select="$index/index/item[@id = $id or @id = $id_next or @id = $id_prev]">
						<xsl:choose>
							<xsl:when test="@id = $id">
								<page><xsl:value-of select="."/></page>
							</xsl:when>
							<xsl:when test="@id = $id_next">
								<page_next><xsl:value-of select="."/></page_next>
							</xsl:when>
							<xsl:when test="@id = $id_prev">
								<page_prev><xsl:value-of select="."/></page_prev>
							</xsl:when>
						</xsl:choose>
					</xsl:for-each>
				</xsl:variable>
				<xsl:variable name="pages" select="xalan:nodeset($pages_)"/>
				
				<!-- <xsl:variable name="page" select="$index/index/item[@id = $id]"/> -->
				<xsl:variable name="page" select="$pages/page"/>
				<!-- <xsl:variable name="page_next" select="$index/index/item[@id = $id_next]"/> -->
				<xsl:variable name="page_next" select="$pages/page_next"/>
				<!-- <xsl:variable name="page_prev" select="$index/index/item[@id = $id_prev]"/> -->
				<xsl:variable name="page_prev" select="$pages/page_prev"/>
				
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
		<xsl:param name="docid" />
		
		<xsl:variable name="level" select="count(ancestor::*[local-name() = 'ul'])"/>
		
		<xsl:variable name="docid_curr">
			<xsl:value-of select="$docid"/>
			<xsl:if test="normalize-space($docid) = ''"><xsl:call-template name="getDocumentId"/></xsl:if>
		</xsl:variable>
		
		<xsl:variable name="item_number">
			<xsl:number count="*[local-name() = 'li'][ancestor::*[local-name() = 'indexsect']]" level="any" />
		</xsl:variable>
		<xsl:variable name="xref_number"><xsl:number count="*[local-name() = 'xref']"/></xsl:variable>
		<xsl:value-of select="concat($docid_curr, '_', $item_number, '_', $xref_number)"/> <!-- $level, '_',  -->
	</xsl:template>

	<xsl:template match="*[local-name() = 'indexsect']/*[local-name() = 'title']" priority="4">
		<fo:block xsl:use-attribute-sets="indexsect-title-style">
			<!-- Index -->
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'indexsect']/*[local-name() = 'clause']/*[local-name() = 'title']" priority="4">
		<!-- Letter A, B, C, ... -->
		<fo:block xsl:use-attribute-sets="indexsect-clause-title-style">
			<xsl:apply-templates />
		</fo:block>
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
	
	<xsl:template match="*[local-name() = 'indexsect']//*[local-name() = 'li']/text()">
		<!-- to split by '_' and other chars -->
		<xsl:call-template name="add-zero-spaces-java"/>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'table']/*[local-name() = 'bookmark']" priority="2"/>
	
	<xsl:template match="*[local-name() = 'bookmark']" name="bookmark">
		<!-- <fo:inline id="{@id}" font-size="1pt"/> -->
		<fo:inline id="{@id}" font-size="1pt"><xsl:value-of select="$hair_space"/></fo:inline>
		<!-- we need to add zero-width space, otherwise this fo:inline is missing in IF xml -->
		<xsl:if test="not(following-sibling::node()[normalize-space() != ''])"><fo:inline font-size="1pt">&#xA0;</fo:inline></xsl:if>
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
					<fo:table-cell border="1pt solid black"><fo:block role="SKIP">Date</fo:block></fo:table-cell>
					<fo:table-cell border="1pt solid black"><fo:block role="SKIP">Type</fo:block></fo:table-cell>
					<fo:table-cell border="1pt solid black"><fo:block role="SKIP">Change</fo:block></fo:table-cell>
					<fo:table-cell border="1pt solid black"><fo:block role="SKIP">Pages</fo:block></fo:table-cell>
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
			<fo:block role="SKIP"><xsl:apply-templates /></fo:block>
		</fo:table-cell>
	</xsl:template>
	<!-- ============ -->
	<!-- END errata -->
	<!-- ============ -->


	<!-- ======================= -->
	<!-- Bibliography rendering -->
	<!-- ======================= -->
	
	<!-- ========================================================== -->
	<!-- Reference sections (Normative References and Bibliography) -->
	<!-- ========================================================== -->
	<xsl:template match="*[local-name() = 'references'][@hidden='true']" priority="3"/>
	<xsl:template match="*[local-name() = 'bibitem'][@hidden='true']" priority="3">
		<xsl:param name="skip" select="normalize-space(preceding-sibling::*[1][local-name() = 'bibitem'] and 1 = 1)"/>
		<xsl:if test="$namespace = 'iso'">
			<xsl:if test="ancestor::*[local-name() = 'references'][not(@normative='true')] or preceding-sibling::*[local-name() = 'references'][1][not(@normative='true')]">
				<xsl:apply-templates select="following-sibling::*[1][local-name() = 'bibitem']">
					<xsl:with-param name="skip" select="$skip"/>
				</xsl:apply-templates>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<!-- don't display bibitem with @id starts with '_hidden', that was introduced for references integrity -->
	<xsl:template match="*[local-name() = 'bibitem'][starts-with(@id, 'hidden_bibitem_')]" priority="3"/>
	
	<!-- Normative references -->
	<xsl:template match="*[local-name() = 'references'][@normative='true']" priority="2">
		
		<xsl:if test="$namespace = 'nist-sp' or $namespace = 'nist-cswp'">
			<xsl:if test="not(ancestor::*[local-name() = 'annex'])">
				<fo:block break-after="page"/>
			</xsl:if>
		</xsl:if>
		
		<fo:block id="{@id}">
			<xsl:apply-templates />
			
			<xsl:if test="$namespace = 'jis'">
				<!-- render footnotes after references -->
				<xsl:apply-templates select=".//jis:fn[generate-id(.)=generate-id(key('kfn',@reference)[1])]" mode="fn_after_element">
					<xsl:with-param name="ancestor">references</xsl:with-param>
				</xsl:apply-templates>
			</xsl:if>
		</fo:block>
	</xsl:template>
	
	<!-- Bibliography (non-normative references) -->
	<xsl:template match="*[local-name() = 'references']">
		<xsl:if test="not(ancestor::*[local-name() = 'annex'])">
			<xsl:choose>
				<xsl:when test="$namespace = 'bsi' or $namespace = 'ieee' or $namespace = 'iho' or $namespace = 'nist-cswp' or $namespace = 'nist-sp' or $namespace = 'unece' or $namespace = 'unece-rec'"></xsl:when>
				<xsl:otherwise>
					<fo:block break-after="page"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		
		<!-- <xsl:if test="ancestor::*[local-name() = 'annex']">
			<xsl:if test="$namespace = 'csa' or $namespace = 'csd' or $namespace = 'gb' or $namespace = 'iec' or $namespace = 'iso' or $namespace = 'itu'">
				<fo:block break-after="page"/>
			</xsl:if>
		</xsl:if> -->
		
		<fo:block id="{@id}" xsl:use-attribute-sets="references-non-normative-style">
			<xsl:apply-templates />
			
			<xsl:if test="$namespace = 'jis'">
				<!-- render footnotes after references -->
				<xsl:apply-templates select=".//jis:fn[generate-id(.)=generate-id(key('kfn',@reference)[1])]" mode="fn_after_element">
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
	
	
	
	<xsl:template match="*[local-name() = 'bibitem']">
		<xsl:call-template name="bibitem"/>
	</xsl:template>
	
	<!-- Normative references -->
	<xsl:template match="*[local-name() = 'references'][@normative='true']/*[local-name() = 'bibitem']" name="bibitem" priority="2">
		<xsl:choose>
			<xsl:when test="$namespace = 'iho' or $namespace = 'nist-cswp'">
				<fo:list-block id="{@id}" xsl:use-attribute-sets="bibitem-normative-list-style">
					
					<xsl:variable name="docidentifier">
						<xsl:apply-templates select="*[local-name() = 'biblio-tag']">
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
				<fo:block-container margin-left="6mm" role="SKIP">
					<fo:block-container margin-left="0mm" role="SKIP">
						<fo:block id="{@id}" xsl:use-attribute-sets="bibitem-normative-style">
							<xsl:call-template name="processBibitem"/>
						</fo:block>
					</fo:block-container>
				</fo:block-container>
			</xsl:when>
			
			<xsl:otherwise>
				<fo:block id="{@id}" xsl:use-attribute-sets="bibitem-normative-style">
					<xsl:call-template name="processBibitem"/>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template> <!-- bibitem -->
	
	
	<xsl:if test="$namespace = 'iso'">
	<!-- start list for bibitem sequence -->
	<xsl:template match="*[local-name() = 'references'][not(@normative='true')]/*[local-name() = 'bibitem'][1]" priority="4">
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
	<xsl:template match="*[local-name() = 'references'][not(@normative='true')]/*[local-name() = 'bibitem']" name="bibitem_non_normative" priority="2">
		<xsl:param name="skip" select="normalize-space(preceding-sibling::*[1][local-name() = 'bibitem'] and 1 = 1)"/> <!-- current bibiitem is non-first -->
		<xsl:choose>
			<xsl:when test="$namespace = 'bipm'">
				<!-- start BIPM bibitem processing -->
				<fo:list-block id="{@id}" xsl:use-attribute-sets="bibitem-non-normative-list-style">
					<fo:list-item>
						<fo:list-item-label end-indent="label-end()">
							<fo:block>
								<fo:inline>
									<xsl:apply-templates select="*[local-name() = 'biblio-tag']">
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
				<fo:block id="{@id}" xsl:use-attribute-sets="bibitem-non-normative-style">
					<xsl:apply-templates select="*[local-name() = 'biblio-tag']"/>
					<xsl:apply-templates select="csa:formattedref"/>
				</fo:block>
				<!-- END CSA bibitem processing -->
			</xsl:when>
		
			<xsl:when test="$namespace = 'iho' or $namespace = 'nist-cswp'">
				<xsl:call-template name="bibitem"/>
			</xsl:when>
			
			<xsl:when test="$namespace = 'itu' or $namespace = 'nist-sp' or $namespace = 'unece' or $namespace = 'unece-rec'">
				<fo:block id="{@id}" xsl:use-attribute-sets="bibitem-non-normative-style">
					<xsl:call-template name="processBibitem"/>
				</fo:block>
			</xsl:when>
			
			<xsl:when test="$namespace = 'rsd'">
				<fo:list-block id="{@id}" xsl:use-attribute-sets="bibitem-non-normative-list-style">
					<fo:list-item>
						<fo:list-item-label end-indent="label-end()">
							<fo:block>
								<xsl:apply-templates select="*[local-name() = 'biblio-tag']">
									<xsl:with-param name="biblio_tag_part">first</xsl:with-param>
								</xsl:apply-templates>
							</fo:block>
						</fo:list-item-label>
						<fo:list-item-body start-indent="body-start()">
							<fo:block>
								<xsl:apply-templates select="*[local-name() = 'biblio-tag']">
									<xsl:with-param name="biblio_tag_part">last</xsl:with-param>
								</xsl:apply-templates>
								<xsl:apply-templates select="ribose:formattedref"/>
							</fo:block>
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
				<fo:list-block id="{@id}" xsl:use-attribute-sets="bibitem-non-normative-list-style">
					<xsl:if test="$namespace = 'ieee'">
						<xsl:variable name="bibitem_label">
							<xsl:apply-templates select="*[local-name() = 'biblio-tag']">
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
									<xsl:apply-templates select="*[local-name() = 'biblio-tag']">
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
	
	<xsl:template name="insertListItem_Bibitem">
		<xsl:choose>
			<xsl:when test="@hidden = 'true'"><!-- skip --></xsl:when>
			<xsl:otherwise>
				<fo:list-item id="{@id}" xsl:use-attribute-sets="bibitem-non-normative-list-item-style">
					<fo:list-item-label end-indent="label-end()">
						<fo:block role="SKIP">
							<fo:inline role="SKIP">
								<xsl:apply-templates select="*[local-name() = 'biblio-tag']">
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
			</xsl:otherwise>
		</xsl:choose>
		<xsl:apply-templates select="following-sibling::*[1][local-name() = 'bibitem']">
			<xsl:with-param name="skip">false</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template name="processBibitem">
		<xsl:param name="biblio_tag_part">both</xsl:param>
		
		<xsl:choose>
			
			<xsl:when test="$namespace ='itu'">
				<!-- start ITU bibitem processing -->
				<!-- Example: [ITU-T A.23]	ITU-T A.23, Recommendation ITU-T A.23, Annex A (2014), Guide for ITU-T and ISO/IEC JTC 1 cooperation. -->
				<xsl:if test="$doctype = 'implementers-guide'">
					<xsl:attribute name="margin-left">0mm</xsl:attribute>
					<xsl:attribute name="text-indent">0mm</xsl:attribute>
				</xsl:if>
				
				<xsl:variable name="docidentifier_metanorma_ordinal" select="normalize-space(itu:docidentifier[@type = 'metanorma-ordinal'])"/>
				
				<xsl:variable name="bibitem_label">
					<xsl:apply-templates select="*[local-name() = 'biblio-tag']">
						<xsl:with-param name="biblio_tag_part">first</xsl:with-param>
					</xsl:apply-templates>
				</xsl:variable>
				
				<xsl:variable name="bibitem_body">
					<xsl:apply-templates select="*[local-name() = 'biblio-tag']">
						<xsl:with-param name="biblio_tag_part">last</xsl:with-param>
					</xsl:apply-templates>
					<xsl:apply-templates select="itu:formattedref"/>
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
								</fo:list-item-body>
							</fo:list-item>
						</fo:list-block>
					</xsl:otherwise>
				</xsl:choose>
				<!-- end ITU bibitem processing -->
			</xsl:when>
			
			<xsl:when test="$namespace = 'jis'">
				<xsl:if test=".//*[local-name() = 'fn']">
					<xsl:attribute name="line-height-shift-adjustment">disregard-shifts</xsl:attribute>
				</xsl:if>
				<fo:inline font-family="Times New Roman" font-weight="bold">
					<xsl:apply-templates select="*[local-name() = 'biblio-tag']">
						<xsl:with-param name="biblio_tag_part" select="$biblio_tag_part"/>
					</xsl:apply-templates>
				</fo:inline>
				<xsl:apply-templates select="*[local-name() = 'formattedref']"/>
			</xsl:when>

			<xsl:when test="$namespace = 'nist-sp'">
				<!-- start NIST SP bibitem processing -->
				<xsl:variable name="docidentifier">
					<xsl:apply-templates select="*[local-name() = 'biblio-tag']">
						<xsl:with-param name="biblio_tag_part">first</xsl:with-param>
					</xsl:apply-templates>
				</xsl:variable>
				<xsl:if test="$docidentifier != ''">
					<fo:inline padding-right="5mm"><xsl:value-of select="$docidentifier"/></fo:inline>
				</xsl:if>
				<xsl:apply-templates select="*[local-name() = 'biblio-tag']">
					<xsl:with-param name="biblio_tag_part">last</xsl:with-param>
				</xsl:apply-templates>
				<xsl:apply-templates select="nist:formattedref"/>
				<!-- END NIST SP bibitem processing -->
			</xsl:when>
			
			<xsl:when test="$namespace = 'unece' or $namespace = 'unece-rec'">
				<!-- start UNECE bibitem processing -->
				<fo:inline padding-right="5mm">
					<xsl:apply-templates select="*[local-name() = 'biblio-tag']">
						<xsl:with-param name="biblio_tag_part">first</xsl:with-param>
					</xsl:apply-templates>
				</fo:inline>
				<xsl:apply-templates select="*[local-name() = 'biblio-tag']">
					<xsl:with-param name="biblio_tag_part">last</xsl:with-param>
				</xsl:apply-templates>
				
				<xsl:apply-templates select="un:formattedref"/>
				<!-- END UNECE bibitem processing -->
			</xsl:when>
			
			<!-- for bipm, csa, csd, iec, iho, iso, m3d, mpfd, nist-cswp, ogc, ogc-white-paper, rsd and other  -->
			<xsl:otherwise>
				<!-- start bibitem processing -->
				<xsl:if test=".//*[local-name() = 'fn']">
					<xsl:attribute name="line-height-shift-adjustment">disregard-shifts</xsl:attribute>
				</xsl:if>
				
				<xsl:if test="$namespace = 'bsi' or $namespace = 'jcgm'">
					<!-- move opening ace-tag before number -->
					<xsl:apply-templates select="*[local-name() = 'formattedref']/node()[1][local-name() = 'add' and contains(., '_start')]">
						<xsl:with-param name="skip">false</xsl:with-param>
					</xsl:apply-templates>
				</xsl:if>
				
				<xsl:apply-templates select="*[local-name() = 'biblio-tag']">
					<xsl:with-param name="biblio_tag_part" select="$biblio_tag_part"/>
				</xsl:apply-templates>
				<xsl:apply-templates select="*[local-name() = 'formattedref']"/>
				<!-- end bibitem processing -->
			</xsl:otherwise>
			
		</xsl:choose>
	</xsl:template> <!-- processBibitem (bibitem) -->
	
	
	<xsl:template match="*[local-name() = 'title']" mode="title">
		<fo:inline><xsl:apply-templates /></fo:inline>
	</xsl:template>

	
	<xsl:template match="*[local-name() = 'bibitem']/*[local-name() = 'docidentifier']"/>
	
	<xsl:template match="*[local-name() = 'formattedref']">
		<!-- <xsl:if test="$namespace = 'unece' or $namespace = 'unece-rec'">
			<xsl:text>, </xsl:text>
		</xsl:if> -->
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="*[local-name() = 'biblio-tag']">
		<xsl:param name="biblio_tag_part">both</xsl:param>
		<xsl:choose>
			<xsl:when test="$biblio_tag_part = 'first' and *[local-name() = 'tab']">
				<xsl:apply-templates select="./*[local-name() = 'tab'][1]/preceding-sibling::node()"/>
			</xsl:when>
			<xsl:when test="$biblio_tag_part = 'last'">
				<xsl:apply-templates select="./*[local-name() = 'tab'][1]/following-sibling::node()"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'biblio-tag']/*[local-name() = 'tab']" priority="2">
		<xsl:text> </xsl:text>
	</xsl:template>

	<!-- ======================= -->
	<!-- END Bibliography rendering -->
	<!-- ======================= -->
	
	<!-- ========================================================== -->
	<!-- END Reference sections (Normative References and Bibliography) -->
	<!-- ========================================================== -->
	
	
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
	
	<xsl:variable name="toc_level">
		<!-- https://www.metanorma.org/author/ref/document-attributes/ -->
		<xsl:variable name="pdftoclevels" select="normalize-space(//*[local-name() = 'metanorma-extension']/*[local-name() = 'presentation-metadata'][*[local-name() = 'name']/text() = 'PDF TOC Heading Levels']/*[local-name() = 'value'])"/> <!-- :toclevels-pdf  Number of table of contents levels to render in PDF output; used to override :toclevels:-->
		<xsl:variable name="toclevels" select="normalize-space(//*[local-name() = 'metanorma-extension']/*[local-name() = 'presentation-metadata'][*[local-name() = 'name']/text() = 'TOC Heading Levels']/*[local-name() = 'value'])"/> <!-- Number of table of contents levels to render -->
		<xsl:choose>
			<xsl:when test="$pdftoclevels != ''"><xsl:value-of select="number($pdftoclevels)"/></xsl:when> <!-- if there is value in xml -->
			<xsl:when test="$toclevels != ''"><xsl:value-of select="number($toclevels)"/></xsl:when>  <!-- if there is value in xml -->
			<xsl:otherwise><!-- default value -->
				<xsl:choose>
					<xsl:when test="$namespace = 'bipm' or $namespace = 'iec' or $namespace = 'iso' or $namespace = 'jcgm' or $namespace = 'm3d' or $namespace = 'nist-cswp' or 
					$namespace = 'ogc-white-paper' or $namespace = 'unece' or $namespace = 'unece-rec'">3</xsl:when>
					<xsl:when test="$namespace = 'ieee'">
						<xsl:choose>
							<xsl:when test="$current_template = 'whitepaper' or $current_template = 'icap-whitepaper' or $current_template = 'industry-connection-report'">3</xsl:when>
							<xsl:otherwise>2</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>2</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
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
					<xsl:call-template name="calculate-column-widths-proportional">
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

	<xsl:template match="*[local-name() = 'toc']//*[local-name() = 'li']" priority="2">
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
				<fo:block line-height-shift-adjustment="disregard-shifts" role="SKIP">
					<xsl:call-template name="insert_basic_link">
						<xsl:with-param name="element">
							<fo:basic-link internal-destination="{$target}" fox:alt-text="{.}">
								<xsl:for-each select="following-sibling::node()[not(self::*[local-name() = 'tab']) and preceding-sibling::*[local-name() = 'tab'][1][generate-id() = $current_id]]">
									<xsl:choose>
										<xsl:when test="self::text()"><xsl:value-of select="."/></xsl:when>
										<xsl:otherwise><xsl:apply-templates select="."/></xsl:otherwise>
									</xsl:choose>
								</xsl:for-each>
							</fo:basic-link>
						</xsl:with-param>
					</xsl:call-template>
				</fo:block>
			</fo:table-cell>
		</xsl:for-each>
		<!-- last column - for page numbers -->
		<fo:table-cell text-align="right" font-size="10pt" font-weight="bold" font-family="Arial">
			<fo:block role="SKIP">
				<xsl:call-template name="insert_basic_link">
					<xsl:with-param name="element">
						<fo:basic-link internal-destination="{$target}" fox:alt-text="{.}">
							<fo:page-number-citation ref-id="{$target}"/>
						</fo:basic-link>
					</xsl:with-param>
				</xsl:call-template>
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
	
	
	<!-- insert fo:basic-link, if external-destination or internal-destination is non-empty, otherwise insert fo:inline -->
	<xsl:template name="insert_basic_link">
		<xsl:param name="element"/>
		<xsl:variable name="element_node" select="xalan:nodeset($element)"/>
		<xsl:variable name="external-destination" select="normalize-space(count($element_node/fo:basic-link/@external-destination[. != '']) = 1)"/>
		<xsl:variable name="internal-destination" select="normalize-space(count($element_node/fo:basic-link/@internal-destination[. != '']) = 1)"/>
		<xsl:choose>
			<xsl:when test="$external-destination = 'true' or $internal-destination = 'true'">
				<xsl:copy-of select="$element_node"/>
			</xsl:when>
			<xsl:otherwise>
				<fo:inline>
					<xsl:for-each select="$element_node/fo:basic-link/@*[local-name() != 'external-destination' and local-name() != 'internal-destination' and local-name() != 'alt-text']">
						<xsl:attribute name="{local-name()}"><xsl:value-of select="."/></xsl:attribute>
					</xsl:for-each>
					<xsl:copy-of select="$element_node/fo:basic-link/node()"/>
				</fo:inline>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'variant-title']"/> <!-- [@type = 'sub'] -->
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
	
	<xsl:template match="@language">
		<xsl:copy-of select="."/>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'p'][@type = 'floating-title' or @type = 'section-title']" priority="4">
		<xsl:call-template name="title"/>
	</xsl:template>
	
	<!-- ================ -->
	<!-- Admonition -->
	<!-- ================ -->
	<xsl:template match="*[local-name() = 'admonition']">
		
		<xsl:if test="$namespace = 'unece-rec'">
			<fo:block break-after="page"/>
		</xsl:if>
		
		<xsl:if test="$namespace = 'unece'"> <!-- display name before box -->
			<fo:block xsl:use-attribute-sets="admonition-name-style">
				<xsl:call-template name="displayAdmonitionName"/>
			</fo:block>
		</xsl:if>
		
		<xsl:choose>
			<xsl:when test="$namespace = 'bsi'">
			
				<xsl:choose>
					<xsl:when test="$document_type = 'PAS' or @type = 'commentary'">
						<fo:block xsl:use-attribute-sets="admonition-style">
							
							<xsl:call-template name="setBlockSpanAll"/>
							
							<xsl:if test="$document_type = 'PAS'">
								<xsl:if test="@type = 'commentary'">
									<xsl:attribute name="color"><xsl:value-of select="$color_secondary_shade_1_PAS"/></xsl:attribute>
								</xsl:if>
							</xsl:if>
							<xsl:attribute name="font-style">italic</xsl:attribute>
							
							<xsl:if test="@type = 'editorial'">
								<xsl:attribute name="color">green</xsl:attribute>
								<xsl:attribute name="font-weight">normal</xsl:attribute>
							</xsl:if>
							
							<fo:block xsl:use-attribute-sets="admonition-name-style">
								<xsl:call-template name="displayAdmonitionName"/>
							</fo:block>
							
							<xsl:apply-templates select="node()[not(local-name() = 'name')]" />
						</fo:block>
					</xsl:when>
					<xsl:otherwise>	<!-- BSI -->
						<fo:block-container id="{@id}" xsl:use-attribute-sets="admonition-style" role="SKIP">
						
							<xsl:call-template name="setBlockSpanAll"/>
						
							<xsl:if test="@type = 'caution' or @type = 'warning'">
								<xsl:attribute name="border">0.25pt solid black</xsl:attribute>
							</xsl:if>
							<xsl:attribute name="margin-right">5mm</xsl:attribute>
							<fo:block-container xsl:use-attribute-sets="admonition-container-style" role="SKIP">
								<fo:block></fo:block>
								<xsl:if test="*[local-name() = 'name']">
									<fo:block xsl:use-attribute-sets="admonition-name-style">
										<xsl:call-template name="displayAdmonitionName"/>
									</fo:block>
								</xsl:if>
								<xsl:apply-templates select="node()[not(local-name() = 'name')]" />
							</fo:block-container>
						</fo:block-container>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			
			<xsl:when test="$namespace = 'csd' or $namespace = 'iso' or $namespace = 'jcgm'">
				<fo:block xsl:use-attribute-sets="admonition-style">
				
					<xsl:call-template name="setBlockSpanAll"/>
					
					<xsl:if test="@type = 'editorial'">
						<xsl:attribute name="color">green</xsl:attribute>
						<xsl:attribute name="font-weight">normal</xsl:attribute>
						<!-- <xsl:variable name="note-style">
							<style xsl:use-attribute-sets="note-style"></style>
						</xsl:variable>
						<xsl:for-each select="xalan:nodeset($note-style)//style/@*">
							<xsl:attribute name="{local-name()}"><xsl:value-of select="."/></xsl:attribute>
						</xsl:for-each> -->
					</xsl:if>
					
					<xsl:if test="$namespace = 'iso'">
						<xsl:if test="@type != 'editorial'">
							<xsl:call-template name="displayAdmonitionName">
								<xsl:with-param name="sep"> — </xsl:with-param>
							</xsl:call-template>
						</xsl:if>
					</xsl:if>
					
					<xsl:if test="$namespace = 'csd' or $namespace = 'jcgm'">
						<xsl:call-template name="displayAdmonitionName">
							<xsl:with-param name="sep"> — </xsl:with-param>
						</xsl:call-template>
					</xsl:if>
					
					<xsl:apply-templates select="node()[not(local-name() = 'name')]" />
				</fo:block>
			</xsl:when>
			
			<xsl:when test="$namespace = 'gb'">
				<fo:block xsl:use-attribute-sets="admonition-name-style">
					<xsl:call-template name="displayAdmonitionName"/>
				</fo:block>
				<xsl:apply-templates select="node()[not(local-name() = 'name')]" />
			</xsl:when>
			
			<xsl:otherwise> <!-- text in the box -->
				<fo:block-container id="{@id}" xsl:use-attribute-sets="admonition-style">
					
					<xsl:call-template name="setBlockSpanAll"/>
					
					<xsl:if test="$namespace = 'ieee'">
						<xsl:if test="@type = 'editorial'">
							<xsl:attribute name="border">none</xsl:attribute>
							<!-- 	<xsl:attribute name="font-weight">bold</xsl:attribute>
							<xsl:attribute name="font-style">italic</xsl:attribute> -->
							<xsl:attribute name="color">green</xsl:attribute>
							<xsl:attribute name="font-weight">normal</xsl:attribute>
							<xsl:attribute name="margin-top">12pt</xsl:attribute>
							<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
							<xsl:attribute name="text-align">left</xsl:attribute>
						</xsl:if>
						<xsl:if test="not(@type)">
							<xsl:attribute name="font-size">9pt</xsl:attribute>
							<xsl:attribute name="text-align">left</xsl:attribute>
						</xsl:if>
					</xsl:if>
					
					<xsl:if test="$namespace = 'unece-rec'">
						<fo:block xsl:use-attribute-sets="admonition-name-style">
							<xsl:call-template name="displayAdmonitionName"/>
						</fo:block>
					</xsl:if>
				
					
					<xsl:choose>
					
						<xsl:when test="$namespace = 'nist-cswp' or $namespace = 'nist-sp'">
							<fo:block xsl:use-attribute-sets="admonition-container-style">
								<fo:block xsl:use-attribute-sets="admonition-name-style">
									<xsl:call-template name="displayAdmonitionName"/>
								</fo:block>
								<xsl:apply-templates select="node()[not(local-name() = 'name')]" />
							</fo:block>
						</xsl:when>
						
						<xsl:otherwise>
							<fo:block-container xsl:use-attribute-sets="admonition-container-style" role="SKIP">
							
								<xsl:if test="$namespace = 'ieee'">
									<xsl:if test="@type = 'editorial' or not(@type)">
										<xsl:attribute name="padding">0mm</xsl:attribute>
									</xsl:if>
									<xsl:if test="not(@type)">
										<xsl:attribute name="padding">1mm</xsl:attribute>
										<xsl:attribute name="padding-bottom">0.5mm</xsl:attribute>
									</xsl:if>
								</xsl:if>
							
								<xsl:choose>
								
									<xsl:when test="$namespace = 'bipm' or $namespace = 'iho' or $namespace = 'itu' or $namespace = 'm3d' or $namespace = 'mpfd' or $namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'rsd'">
										<fo:block xsl:use-attribute-sets="admonition-name-style">
											<xsl:call-template name="displayAdmonitionName"/>
										</fo:block>
										<fo:block xsl:use-attribute-sets="admonition-p-style">
											<xsl:apply-templates select="node()[not(local-name() = 'name')]" />
										</fo:block>
									</xsl:when>
									
									<xsl:when test="$namespace = 'iec'">
										<fo:block text-align="justify">
											<fo:inline>
												<xsl:call-template name="displayAdmonitionName">
													<xsl:with-param name="sep"> – </xsl:with-param>
												</xsl:call-template>
											</fo:inline>
											<xsl:apply-templates select="node()[not(local-name() = 'name')]" />
										</fo:block>
									</xsl:when>
									
									<xsl:when test="$namespace = 'ieee'">
										<fo:block-container margin-left="0mm" margin-right="0mm" role="SKIP">
											<fo:block xsl:use-attribute-sets="admonition-p-style">
												<fo:inline>
													<xsl:call-template name="displayAdmonitionName">
														<xsl:with-param name="sep">: </xsl:with-param>
													</xsl:call-template>
												</fo:inline>
												<xsl:apply-templates select="node()[not(local-name() = 'name')]" />
											</fo:block>
										</fo:block-container>
									</xsl:when>
									
									<xsl:otherwise>
										<fo:block-container margin-left="0mm" margin-right="0mm" role="SKIP">
											<fo:block>
												<xsl:apply-templates select="node()[not(local-name() = 'name')]" />
											</fo:block>
										</fo:block-container>
									</xsl:otherwise>
									
								</xsl:choose>
							</fo:block-container>
						</xsl:otherwise>
					</xsl:choose>
				</fo:block-container>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="displayAdmonitionName">
		<xsl:param name="sep"/> <!-- Example: ' - ' -->
		<!-- <xsl:choose>
			<xsl:when test="$namespace = 'nist-cswp' or $namespace = 'nist-sp'">
				<xsl:choose>
					<xsl:when test="@type='important'"><xsl:apply-templates select="@type"/></xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="*[local-name() = 'name']"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="*[local-name() = 'name']"/>
				<xsl:if test="not(*[local-name() = 'name'])">
					<xsl:apply-templates select="@type"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose> -->
		<xsl:variable name="name">
			<xsl:apply-templates select="*[local-name() = 'name']"/>
		</xsl:variable>
		<xsl:copy-of select="$name"/>
		<xsl:if test="normalize-space($name) != ''">
			<xsl:value-of select="$sep"/>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'admonition']/*[local-name() = 'name']">
		<xsl:apply-templates />
	</xsl:template>
	
	<!-- <xsl:template match="*[local-name() = 'admonition']/@type">
		<xsl:variable name="admonition_type_">
			<xsl:call-template name="getLocalizedString">
				<xsl:with-param name="key">admonition.<xsl:value-of select="."/></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="admonition_type" select="normalize-space(java:toUpperCase(java:java.lang.String.new($admonition_type_)))"/>
		<xsl:value-of select="$admonition_type"/>
		<xsl:if test="$admonition_type = ''">
			<xsl:value-of select="java:toUpperCase(java:java.lang.String.new(.))"/>
		</xsl:if>
	</xsl:template> -->
	
	<xsl:template match="*[local-name() = 'admonition']/*[local-name() = 'p']">
		<xsl:choose>
			<xsl:when test="$namespace = 'bsi' or $namespace = 'csa' or $namespace = 'iec' or $namespace = 'iho' or $namespace = 'iso' or $namespace = 'm3d' or $namespace = 'mpfd'"> <!-- processing for admonition/p found in the template for 'p' -->
				<xsl:call-template name="paragraph"/>
			</xsl:when>
			<xsl:when test="$namespace = 'gb'">
				<fo:block xsl:use-attribute-sets="admonition-p-style">
					<xsl:call-template name="paragraph"/>
				</fo:block>
			</xsl:when>
			<xsl:when test="$namespace = 'ieee'">
				<xsl:choose>
					<xsl:when test="ancestor::*[local-name() = 'admonition'][@type = 'editorial']">
						<xsl:apply-templates />
					</xsl:when>
					<xsl:otherwise>
						<fo:block xsl:use-attribute-sets="admonition-p-style">
							<xsl:apply-templates />
						</fo:block>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<fo:block xsl:use-attribute-sets="admonition-p-style">
				
					<xsl:if test="$namespace = 'nist-sp'">
						<xsl:variable name="num"><xsl:number/></xsl:variable>
						<xsl:if test="$num &lt; count(ancestor::nist:admonition//nist:p)">
							<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
						</xsl:if>
					</xsl:if>
					
					<xsl:apply-templates />
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- ================ -->
	<!-- END Admonition -->
	<!-- ================ -->

	<!-- ===================================== -->
	<!-- Update xml -->
	<!-- ===================================== -->
	<!-- =========================================================================== -->
	<!-- STEP1:  -->
	<!--   - Re-order elements in 'preface', 'sections' based on @displayorder -->
	<!--   - Ignore 'span' without style -->
	<!-- =========================================================================== -->
	<xsl:template match="@*|node()" mode="update_xml_step1">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- change section's order based on @displayorder value -->
	<xsl:template match="*[local-name() = 'preface']" mode="update_xml_step1">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			
			<xsl:variable name="nodes_preface_">
				<xsl:for-each select="*">
					<node id="{@id}"/>
				</xsl:for-each>
			</xsl:variable>
			<xsl:variable name="nodes_preface" select="xalan:nodeset($nodes_preface_)"/>
			
			<xsl:for-each select="*">
				<xsl:sort select="@displayorder" data-type="number"/>
				
				<!-- process Section's title -->
				<xsl:variable name="preceding-sibling_id" select="$nodes_preface/node[@id = current()/@id]/preceding-sibling::node[1]/@id"/>
				<xsl:if test="$preceding-sibling_id != ''">
					<xsl:apply-templates select="parent::*/*[@type = 'section-title' and @id = $preceding-sibling_id and not(@displayorder)]" mode="update_xml_step1"/>
				</xsl:if>
				
				<xsl:choose>
					<xsl:when test="@type = 'section-title' and not(@displayorder)"><!-- skip, don't copy, because copied in above 'apply-templates' --></xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="." mode="update_xml_step1"/>
					</xsl:otherwise>
				</xsl:choose>
				
			</xsl:for-each>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'sections']" mode="update_xml_step1">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			
			<xsl:variable name="nodes_sections_">
				<xsl:for-each select="*">
					<node id="{@id}"/>
				</xsl:for-each>
			</xsl:variable>
			<xsl:variable name="nodes_sections" select="xalan:nodeset($nodes_sections_)"/>
			
			<!-- move section 'Normative references' inside 'sections' -->
			<xsl:for-each select="* | 
				ancestor::*[contains(local-name(), '-standard')]/*[local-name()='bibliography']/*[local-name()='references'][@normative='true'] |
				ancestor::*[contains(local-name(), '-standard')]/*[local-name()='bibliography']/*[local-name()='clause'][*[local-name()='references'][@normative='true']]">
				<xsl:sort select="@displayorder" data-type="number"/>
				
				<!-- process Section's title -->
				<xsl:variable name="preceding-sibling_id" select="$nodes_sections/node[@id = current()/@id]/preceding-sibling::node[1]/@id"/>
				<xsl:if test="$preceding-sibling_id != ''">
					<xsl:apply-templates select="parent::*/*[@type = 'section-title' and @id = $preceding-sibling_id and not(@displayorder)]" mode="update_xml_step1"/>
				</xsl:if>
				
				<xsl:choose>
					<xsl:when test="@type = 'section-title' and not(@displayorder)"><!-- skip, don't copy, because copied in above 'apply-templates' --></xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="." mode="update_xml_step1"/>
					</xsl:otherwise>
				</xsl:choose>
				
			</xsl:for-each>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[local-name() = 'bibliography']" mode="update_xml_step1">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<!-- copy all elements from bibliography except 'Normative references' (moved to 'sections') -->
			<xsl:for-each select="*[not(@normative='true') and not(*[@normative='true'])]">
				<xsl:sort select="@displayorder" data-type="number"/>
				<xsl:apply-templates select="." mode="update_xml_step1"/>
			</xsl:for-each>
		</xsl:copy>
	</xsl:template>
	
	<!-- Example with 'class': <span class="stdpublisher">ISO</span> <span class="stddocNumber">10303</span>-<span class="stddocPartNumber">1</span>:<span class="stdyear">1994</span> -->
	<xsl:template match="*[local-name() = 'span'][@style or @class = 'stdpublisher' or @class = 'stddocNumber' or @class = 'stddocPartNumber' or @class = 'stdyear']" mode="update_xml_step1" priority="2">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template>
	<!-- Note: to enable the addition of character span markup with semantic styling for DIS Word output -->
	<xsl:template match="*[local-name() = 'span']" mode="update_xml_step1">
		<xsl:apply-templates mode="update_xml_step1"/>
	</xsl:template>
	<xsl:template match="*[local-name() = 'sections']/*[local-name() = 'p'][starts-with(@class, 'zzSTDTitle')]/*[local-name() = 'span'][@class] | *[local-name() = 'sourcecode']//*[local-name() = 'span'][@class]" mode="update_xml_step1" priority="2">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- remove semantic xml -->
	<xsl:template match="*[local-name() = 'metanorma-extension']/*[local-name() = 'metanorma']/*[local-name() = 'source']" mode="update_xml_step1"/>
	
	<!-- remove image/emf -->
	<xsl:template match="*[local-name() = 'image']/*[local-name() = 'emf']" mode="update_xml_step1"/>
	
	<xsl:template match="*[local-name() = 'stem'] | *[local-name() = 'image']" mode="update_xml_step1">
		<xsl:copy-of select="."/>
	</xsl:template>
	
	<!-- add @id, redundant for table auto-layout algorithm -->
	<xsl:template match="*[local-name() = 'dl' or local-name() = 'table'][not(@id)]" mode="update_xml_step1">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:call-template name="add_id"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- prevent empty thead processing in XSL-FO, remove it -->
	<xsl:template match="*[local-name() = 'table']/*[local-name() = 'thead'][count(*) = 0]" mode="update_xml_step1"/>
	
	<xsl:template name="add_id">
		<xsl:if test="not(@id)">
			<!-- add @id - first element with @id plus '_element_name' -->
			<xsl:attribute name="id"><xsl:value-of select="(.//*[@id])[1]/@id"/>_<xsl:value-of select="local-name()"/></xsl:attribute>
		</xsl:if>
	</xsl:template>
	
	<!-- =========================================================================== -->
	<!-- END STEP1: Re-order elements in 'preface', 'sections' based on @displayorder -->
	<!-- =========================================================================== -->
	
	<xsl:if test="$namespace = 'ieee' or $namespace = 'iso' or $namespace = 'jis' or $namespace = 'bsi'">
		<!-- =========================================================================== -->
		<!-- STEP2: add 'fn' after 'eref' and 'origin', if referenced to bibitem with 'note' = Withdrawn.' or 'Cancelled and replaced...'  -->
		<!-- =========================================================================== -->
		<xsl:template match="@*|node()" mode="update_xml_step2">
			<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="update_xml_step2"/>
			</xsl:copy>
		</xsl:template>
		
		<xsl:variable name="localized_string_withdrawn">
			<xsl:call-template name="getLocalizedString">
				<xsl:with-param name="key">withdrawn</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="localized_string_cancelled_and_replaced">
			<xsl:variable name="str">
				<xsl:call-template name="getLocalizedString">
					<xsl:with-param name="key">cancelled_and_replaced</xsl:with-param>
				</xsl:call-template>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="contains($str, '%')"><xsl:value-of select="substring-before($str, '%')"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$str"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<!-- add 'fn' after eref and origin, to reference bibitem with note = 'Withdrawn.' or 'Cancelled and replaced...' -->
		<xsl:template match="*[local-name() = 'eref'] | *[local-name() = 'origin']" mode="update_xml_step2">
			<xsl:copy-of select="."/>
			
			<xsl:variable name="bibitemid" select="@bibitemid"/>
			<xsl:variable name="local_name" select="local-name()"/>
			<xsl:variable name="position"><xsl:number count="*[local-name() = $local_name][@bibitemid = $bibitemid]" level="any"/></xsl:variable>
			<xsl:if test="normalize-space($position) = '1'">
				<xsl:variable name="fn_text">
					<!-- <xsl:copy-of select="key('bibitems', $bibitemid)[1]/*[local-name() = 'note'][not(@type='Unpublished-Status')][normalize-space() = $localized_string_withdrawn or starts-with(normalize-space(), $localized_string_cancelled_and_replaced)]/node()" /> -->
					<xsl:copy-of select="$bibitems/*[local-name() ='bibitem'][@id = $bibitemid][1]/*[local-name() = 'note'][not(@type='Unpublished-Status')][normalize-space() = $localized_string_withdrawn or starts-with(normalize-space(), $localized_string_cancelled_and_replaced)]/node()" />
				</xsl:variable>
				<xsl:if test="normalize-space($fn_text) != ''">
					<xsl:element name="fn" namespace="{$namespace_full}">
						<xsl:attribute name="reference">bibitem_<xsl:value-of select="$bibitemid"/></xsl:attribute>
						<xsl:element name="p" namespace="{$namespace_full}">
							<xsl:copy-of select="$fn_text"/>
						</xsl:element>
					</xsl:element>
				</xsl:if>
			</xsl:if>
		</xsl:template>
		
		<!-- add id for table without id (for autolayout algorithm) -->
		<!-- <xsl:template match="*[local-name() = 'table'][not(@id)]" mode="update_xml_step2">
			<xsl:copy>
				<xsl:apply-templates select="@*" mode="update_xml_step2"/>
				<xsl:attribute name="id">_abc<xsl:value-of select="generate-id()"/></xsl:attribute>
				
				<xsl:apply-templates select="node()" mode="update_xml_step2"/>
			</xsl:copy>
		</xsl:template> -->
		
		<!-- add @reference for fn -->
		<xsl:template match="*[local-name() = 'fn'][not(@reference)]" mode="update_xml_step2">
			<xsl:copy>
				<xsl:apply-templates select="@*" mode="update_xml_step2"/>
				<xsl:attribute name="reference"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
				<xsl:apply-templates select="node()" mode="update_xml_step2"/>
			</xsl:copy>
		</xsl:template>
		
		
		<!-- add @reference for bibitem/note, similar to fn/reference -->
		<!-- <xsl:template match="*[local-name() = 'bibitem']/*[local-name() = 'note']" mode="update_xml_step2">
			<xsl:copy>
				<xsl:apply-templates select="@*" mode="update_xml_step2"/>
				
				<xsl:attribute name="reference">
					<xsl:value-of select="concat('bibitem_', ../@id, '_', count(preceding-sibling::*[local-name() = 'note']))"/>
				</xsl:attribute>
				
				<xsl:apply-templates select="node()" mode="update_xml_step2"/>
			</xsl:copy>
		</xsl:template> -->
		
		<!-- enclose sequence of 'char x' + 'combining char y' to <lang_none>xy</lang_none> -->
		<xsl:variable name="regex_combining_chars">(.[&#x300;-&#x36f;])</xsl:variable>
		<xsl:variable name="element_name_lang_none">lang_none</xsl:variable>
		<xsl:variable name="tag_element_name_lang_none_open">###<xsl:value-of select="$element_name_lang_none"/>###</xsl:variable>
		<xsl:variable name="tag_element_name_lang_none_close">###/<xsl:value-of select="$element_name_lang_none"/>###</xsl:variable>

		<xsl:template match="text()" mode="update_xml_step2">
			<xsl:variable name="text_" select="java:replaceAll(java:java.lang.String.new(.), $regex_combining_chars, concat($tag_element_name_lang_none_open,'$1',$tag_element_name_lang_none_close))"/>
			<xsl:call-template name="replace_text_tags">
				<xsl:with-param name="tag_open" select="$tag_element_name_lang_none_open"/>
				<xsl:with-param name="tag_close" select="$tag_element_name_lang_none_close"/>
				<xsl:with-param name="text" select="$text_"/>
			</xsl:call-template>
		</xsl:template>
		
		<xsl:template match="*[local-name() = 'stem'] | *[local-name() = 'image']" mode="update_xml_step2">
			<xsl:copy-of select="."/>
		</xsl:template>
		
		<!-- =========================================================================== -->
		<!-- END STEP2: add 'fn' after 'eref' and 'origin', if referenced to bibitem with 'note' = Withdrawn.' or 'Cancelled and replaced...'  -->
		<!-- =========================================================================== -->
	</xsl:if>
	
	
	<!-- =========================================================================== -->
	<!-- XML UPDATE STEP: enclose standard's name into tag 'keep-together_within-line'  -->
	<!-- keep-together_within-line for: a/b, aaa/b, a/bbb, /b -->
	<!-- keep-together_within-line for: a.b, aaa.b, a.bbb, .b  in table's cell ONLY  -->
	<!-- =========================================================================== -->
	<!-- Example: <keep-together_within-line>ISO 10303-51</keep-together_within-line> -->
	<xsl:template match="@*|node()" mode="update_xml_enclose_keep-together_within-line">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="update_xml_enclose_keep-together_within-line"/>
		</xsl:copy>
	</xsl:template>
	
	
	<xsl:variable name="express_reference_separators">_.\</xsl:variable>
	<xsl:variable name="express_reference_characters" select="concat($upper,$lower,'1234567890',$express_reference_separators)"/>
		
	<xsl:variable name="element_name_keep-together_within-line">keep-together_within-line</xsl:variable>
		
	<xsl:template match="text()[not(ancestor::*[local-name() = 'bibdata'] or 
				ancestor::*[local-name() = 'link'][not(contains(.,' '))] or 
				ancestor::*[local-name() = 'sourcecode'] or 
				ancestor::*[local-name() = 'math'] or
				ancestor::*[local-name() = 'svg'] or
				starts-with(., 'http://') or starts-with(., 'https://') or starts-with(., 'www.') )]" name="keep_together_standard_number" mode="update_xml_enclose_keep-together_within-line">
	
		<!-- enclose standard's number into tag 'keep-together_within-line' -->
		<xsl:variable name="tag_keep-together_within-line_open">###<xsl:value-of select="$element_name_keep-together_within-line"/>###</xsl:variable>
		<xsl:variable name="tag_keep-together_within-line_close">###/<xsl:value-of select="$element_name_keep-together_within-line"/>###</xsl:variable>
		<xsl:variable name="text__" select="java:replaceAll(java:java.lang.String.new(.), $regex_standard_reference, concat($tag_keep-together_within-line_open,'$1',$tag_keep-together_within-line_close))"/>
		<xsl:variable name="text_">
			<xsl:choose>
				<xsl:when test="ancestor::*[local-name() = 'table']"><xsl:value-of select="."/></xsl:when> <!-- no need enclose standard's number into tag 'keep-together_within-line' in table cells -->
				<xsl:otherwise><xsl:value-of select="$text__"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="text"><text><xsl:call-template name="replace_text_tags">
				<xsl:with-param name="tag_open" select="$tag_keep-together_within-line_open"/>
				<xsl:with-param name="tag_close" select="$tag_keep-together_within-line_close"/>
				<xsl:with-param name="text" select="$text_"/>
			</xsl:call-template></text></xsl:variable>
		
		<xsl:variable name="parent" select="local-name(..)"/>
		
		<xsl:variable name="text2">
			<text><xsl:for-each select="xalan:nodeset($text)/text/node()">
					<xsl:choose>
						
						<xsl:when test="$namespace = 'iso'">
							<xsl:choose>
								<!-- if EXPRESS reference -->
								<xsl:when test="self::text() and $parent = 'strong' and translate(., $express_reference_characters, '') = ''">
									<xsl:element name="{$element_name_keep-together_within-line}"><xsl:value-of select="."/></xsl:element>
								</xsl:when>
								<xsl:otherwise><xsl:copy-of select="."/></xsl:otherwise> <!-- copy 'as-is' for <fo:inline keep-together.within-line="always" ...  -->
							</xsl:choose>
						</xsl:when>
						
						<xsl:otherwise><xsl:copy-of select="."/></xsl:otherwise> <!-- copy 'as-is' for <fo:inline keep-together.within-line="always" ...  -->
					</xsl:choose>
				</xsl:for-each></text>
		</xsl:variable>
		
		<!-- keep-together_within-line for: a/b, aaa/b, a/bbb, /b -->
		<!-- \S matches any non-whitespace character (equivalent to [^\r\n\t\f\v ]) -->
		<!-- <xsl:variable name="regex_solidus_units">((\b((\S{1,3}\/\S+)|(\S+\/\S{1,3}))\b)|(\/\S{1,3})\b)</xsl:variable> -->
		<!-- add &lt; and &gt; to \S -->
		<xsl:variable name="regex_S">[^\r\n\t\f\v \&lt;&gt;\u3000-\u9FFF]</xsl:variable>
		<xsl:variable name="regex_solidus_units">((\b((<xsl:value-of select="$regex_S"/>{1,3}\/<xsl:value-of select="$regex_S"/>+)|(<xsl:value-of select="$regex_S"/>+\/<xsl:value-of select="$regex_S"/>{1,3}))\b)|(\/<xsl:value-of select="$regex_S"/>{1,3})\b)</xsl:variable>
		<xsl:variable name="text3">
			<text><xsl:for-each select="xalan:nodeset($text2)/text/node()">
				<xsl:choose>
					<xsl:when test="self::text()">
						<xsl:variable name="text_units_" select="java:replaceAll(java:java.lang.String.new(.),$regex_solidus_units,concat($tag_keep-together_within-line_open,'$1',$tag_keep-together_within-line_close))"/>
						<xsl:variable name="text_units"><text><xsl:call-template name="replace_text_tags">
							<xsl:with-param name="tag_open" select="$tag_keep-together_within-line_open"/>
							<xsl:with-param name="tag_close" select="$tag_keep-together_within-line_close"/>
							<xsl:with-param name="text" select="$text_units_"/>
						</xsl:call-template></text></xsl:variable>
						<xsl:copy-of select="xalan:nodeset($text_units)/text/node()"/>
					</xsl:when>
					<xsl:otherwise><xsl:copy-of select="."/></xsl:otherwise> <!-- copy 'as-is' for <fo:inline keep-together.within-line="always" ...  -->
				</xsl:choose>
			</xsl:for-each></text>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="ancestor::*[local-name() = 'td' or local-name() = 'th']">
				<!-- keep-together_within-line for: a.b, aaa.b, a.bbb, .b  in table's cell ONLY -->
				<xsl:variable name="non_white_space">[^\s\u3000-\u9FFF]</xsl:variable>
				<xsl:variable name="regex_dots_units">((\b((<xsl:value-of select="$non_white_space"/>{1,3}\.<xsl:value-of select="$non_white_space"/>+)|(<xsl:value-of select="$non_white_space"/>+\.<xsl:value-of select="$non_white_space"/>{1,3}))\b)|(\.<xsl:value-of select="$non_white_space"/>{1,3})\b)</xsl:variable>
				<xsl:for-each select="xalan:nodeset($text3)/text/node()">
					<xsl:choose>
						<xsl:when test="self::text()">
							<xsl:variable name="text_dots_" select="java:replaceAll(java:java.lang.String.new(.),$regex_dots_units,concat($tag_keep-together_within-line_open,'$1',$tag_keep-together_within-line_close))"/>
							<xsl:variable name="text_dots"><text><xsl:call-template name="replace_text_tags">
								<xsl:with-param name="tag_open" select="$tag_keep-together_within-line_open"/>
								<xsl:with-param name="tag_close" select="$tag_keep-together_within-line_close"/>
								<xsl:with-param name="text" select="$text_dots_"/>
							</xsl:call-template></text></xsl:variable>
							<xsl:copy-of select="xalan:nodeset($text_dots)/text/node()"/>
						</xsl:when>
						<xsl:otherwise><xsl:copy-of select="."/></xsl:otherwise> <!-- copy 'as-is' for <fo:inline keep-together.within-line="always" ...  -->
					</xsl:choose>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise><xsl:copy-of select="xalan:nodeset($text3)/text/node()"/></xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'stem'] | *[local-name() = 'image']" mode="update_xml_enclose_keep-together_within-line">
		<xsl:copy-of select="."/>
	</xsl:template>
	
	<xsl:template name="replace_text_tags">
		<xsl:param name="tag_open"/>
		<xsl:param name="tag_close"/>
		<xsl:param name="text"/>
		<xsl:choose>
			<xsl:when test="contains($text, $tag_open)">
				<xsl:value-of select="substring-before($text, $tag_open)"/>
				<xsl:variable name="text_after" select="substring-after($text, $tag_open)"/>
				
				<xsl:element name="{substring-before(substring-after($tag_open, '###'),'###')}">
					<xsl:value-of select="substring-before($text_after, $tag_close)"/>
				</xsl:element>
				
				<xsl:call-template name="replace_text_tags">
					<xsl:with-param name="tag_open" select="$tag_open"/>
					<xsl:with-param name="tag_close" select="$tag_close"/>
					<xsl:with-param name="text" select="substring-after($text_after, $tag_close)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="$text"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- ===================================== -->
	<!-- END XML UPDATE STEP: enclose standard's name into tag 'keep-together_within-line'  -->
	<!-- ===================================== -->

	<!-- ===================================== -->
	<!-- ===================================== -->
	<!-- Make linear XML (need for landscape orientation) -->
	<!-- ===================================== -->
	<!-- ===================================== -->
	<xsl:template match="@*|node()" mode="linear_xml">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="linear_xml"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="processing-instruction()" mode="linear_xml">
		<xsl:copy-of select="."/>
	</xsl:template>
	
	<!-- From:
		<clause>
			<title>...</title>
			<p>...</p>
		</clause>
		To:
			<clause/>
			<title>...</title>
			<p>...</p>
		-->
	<xsl:template match="*[local-name() = 'foreword'] |
											*[local-name() = 'foreword']//*[local-name() = 'clause'] |
											*[local-name() = 'preface']//*[local-name() = 'clause'][not(@type = 'corrigenda') and not(@type = 'policy') and not(@type = 'related-refs')] |
											*[local-name() = 'introduction'] |
											*[local-name() = 'introduction']//*[local-name() = 'clause'] |
											*[local-name() = 'sections']//*[local-name() = 'clause'] | 
											*[local-name() = 'annex'] | 
											*[local-name() = 'annex']//*[local-name() = 'clause'] | 
											*[local-name() = 'references'][not(@hidden = 'true')] |
											*[local-name() = 'bibliography']/*[local-name() = 'clause'] | 
											*[local-name() = 'colophon'] | 
											*[local-name() = 'colophon']//*[local-name() = 'clause'] | 
											*[local-name()='sections']//*[local-name()='terms'] | 
											*[local-name()='sections']//*[local-name()='definitions'] |
											*[local-name()='annex']//*[local-name()='definitions']" mode="linear_xml" name="clause_linear">
		
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="linear_xml"/>
			
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			
			<xsl:if test="local-name() = 'foreword' or local-name() = 'introduction' or
			local-name(..) = 'preface' or local-name(..) = 'sections' or 
			(local-name() = 'references' and parent::*[local-name() = 'bibliography']) or
			(local-name() = 'clause' and parent::*[local-name() = 'bibliography']) or
			local-name() = 'annex' or 
			local-name(..) = 'annex' or
			local-name(..) = 'colophon'">
				<xsl:attribute name="mainsection">true</xsl:attribute>
			</xsl:if>
		</xsl:copy>
		
		<xsl:apply-templates mode="linear_xml"/>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'term']" mode="linear_xml" priority="2">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="linear_xml"/>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:variable name="level">
				<xsl:call-template name="getLevel"/>
			</xsl:variable>
			<xsl:attribute name="depth"><xsl:value-of select="$level"/></xsl:attribute>
			<xsl:attribute name="ancestor">sections</xsl:attribute>
			<xsl:apply-templates select="node()[not(local-name() = 'term')]" mode="linear_xml"/>
		</xsl:copy>
		<xsl:apply-templates select="*[local-name() = 'term']" mode="linear_xml"/>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'introduction']//*[local-name() = 'title'] | 
			*[local-name() = 'foreword']//*[local-name() = 'title'] | 
			*[local-name() = 'sections']//*[local-name() = 'title'] | 
			*[local-name() = 'annex']//*[local-name() = 'title'] | 
			*[local-name() = 'bibliography']/*[local-name() = 'clause']/*[local-name() = 'title'] | 
			*[local-name() = 'references']/*[local-name() = 'title'] | 
			*[local-name() = 'colophon']//*[local-name() = 'title']" mode="linear_xml" priority="2">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="linear_xml"/>
			
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			
			<xsl:variable name="level">
				<xsl:call-template name="getLevel"/>
			</xsl:variable>
			<xsl:attribute name="depth"><xsl:value-of select="$level"/></xsl:attribute>
			
			<xsl:if test="parent::*[local-name() = 'annex']">
				<xsl:attribute name="depth">1</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="../@inline-header = 'true' and following-sibling::*[1][local-name() = 'p']">
				<xsl:copy-of select="../@inline-header"/>
			</xsl:if>
			
			<xsl:attribute name="ancestor">
				<xsl:choose>
					<xsl:when test="ancestor::*[local-name() = 'foreword']">foreword</xsl:when>
					<xsl:when test="ancestor::*[local-name() = 'introduction']">introduction</xsl:when>
					<xsl:when test="ancestor::*[local-name() = 'sections']">sections</xsl:when>
					<xsl:when test="ancestor::*[local-name() = 'annex']">annex</xsl:when>
					<xsl:when test="ancestor::*[local-name() = 'bibliography']">bibliography</xsl:when>
				</xsl:choose>
			</xsl:attribute>
			
			<xsl:apply-templates mode="linear_xml"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- add @to = figure, table, clause -->
	<!-- add @depth = from  -->
	<xsl:template match="*[local-name() = 'xref']" mode="linear_xml">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="linear_xml"/>
			<xsl:variable name="target" select="@target"/>
			<xsl:attribute name="to">
				<xsl:value-of select="local-name(//*[@id = current()/@target][1])"/>
			</xsl:attribute>
			<xsl:attribute name="depth">
				<xsl:value-of select="//*[@id = current()/@target][1]/*[local-name() = 'title']/@depth"/>
			</xsl:attribute>
			<xsl:apply-templates select="node()" mode="linear_xml"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="*[not(ancestor::*[local-name() = 'sourcecode'])]/*[local-name() = 'p' or local-name() = 'strong' or local-name() = 'em']/text()" mode="linear_xml">
		<xsl:choose>
			<xsl:when test="contains(., $non_breaking_hyphen)">
				<xsl:call-template name="replaceChar">
					<xsl:with-param name="text" select="."/>
					<xsl:with-param name="replace" select="$non_breaking_hyphen"/>
					<xsl:with-param name="by" select="'-'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="replaceChar">
		<xsl:param name="text" />
		<xsl:param name="replace" />
		<xsl:param name="by" />
		<xsl:choose>
			<xsl:when test="$text = '' or $replace = '' or not($replace)" >
				<xsl:value-of select="$text" />
			</xsl:when>
			<xsl:when test="contains($text, $replace)">
				<xsl:value-of select="substring-before($text,$replace)" />
				<xsl:element name="inlineChar" namespace="https://www.metanorma.org/ns/jis"><xsl:value-of select="$by"/></xsl:element>
				<xsl:call-template name="replaceChar">
						<xsl:with-param name="text" select="substring-after($text,$replace)" />
						<xsl:with-param name="replace" select="$replace" />
						<xsl:with-param name="by" select="$by" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'inlineChar']">
		<fo:inline><xsl:value-of select="."/></fo:inline>
	</xsl:template>
	
	<!-- change @reference to actual value, and add skip_footnote_body="true" for repeatable (2nd, 3rd, ...) -->
	<!--
	<fn reference="1">
			<p id="_8e5cf917-f75a-4a49-b0aa-1714cb6cf954">Formerly denoted as 15 % (m/m).</p>
		</fn>
	-->
	<xsl:template match="*[local-name() = 'fn'][not(ancestor::*[(local-name() = 'table' or local-name() = 'figure')] and not(ancestor::*[local-name() = 'name']))]" mode="linear_xml" name="linear_xml_fn">
		<xsl:variable name="p_fn_">
			<xsl:call-template name="get_fn_list"/>
			<!-- <xsl:choose>
				<xsl:when test="$namespace = 'jis'">
					<xsl:call-template name="get_fn_list_for_element"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="get_fn_list"/>
				</xsl:otherwise>
			</xsl:choose> -->
		</xsl:variable>
		<xsl:variable name="p_fn" select="xalan:nodeset($p_fn_)"/>
		<xsl:variable name="gen_id" select="generate-id(.)"/>
		<xsl:variable name="lang" select="ancestor::*[contains(local-name(), '-standard')]/*[local-name()='bibdata']//*[local-name()='language'][@current = 'true']"/>
		<xsl:variable name="reference" select="@reference"/>
		<!-- fn sequence number in document -->
		<xsl:variable name="current_fn_number" select="count($p_fn//fn[@reference = $reference]/preceding-sibling::fn) + 1" />
		
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="linear_xml"/>
			<!-- put actual reference number -->
			<xsl:attribute name="current_fn_number">
				<xsl:value-of select="$current_fn_number"/>
			</xsl:attribute>
			<xsl:variable name="skip_footnote_body_" select="not($p_fn//fn[@gen_id = $gen_id] and (1 = 1))"/>
			<xsl:attribute name="skip_footnote_body"> <!-- false for repeatable footnote -->
				<xsl:choose>
					<xsl:when test="$namespace = 'jis'">
						<xsl:choose>
							<xsl:when test="ancestor::*[local-name() = 'ul' or local-name() ='ol' or local-name() = 'bibitem' or local-name() = 'quote']">true</xsl:when>
							<xsl:otherwise><xsl:value-of select="$skip_footnote_body_"/></xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$skip_footnote_body_"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="ref_id">
				<xsl:value-of  select="concat('footnote_', $lang, '_', $reference, '_', $current_fn_number)"/>
			</xsl:attribute>
			<xsl:apply-templates select="node()" mode="linear_xml"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'p'][@type = 'section-title']" priority="3" mode="linear_xml">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="linear_xml"/>
			<xsl:if test="@depth = '1'">
				<xsl:attribute name="mainsection">true</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates select="node()" mode="linear_xml"/>
		</xsl:copy>
	</xsl:template>
	<!-- ===================================== -->
	<!-- ===================================== -->
	<!-- END: Make linear XML (need for landscape orientation) -->
	<!-- ===================================== -->
	<!-- ===================================== -->	

	<!-- for correct rendering combining chars -->
	<xsl:template match="*[local-name() = 'lang_none']">
		<fo:inline xml:lang="none"><xsl:value-of select="."/></fo:inline>
	</xsl:template>

	<xsl:template name="printEdition">
		<xsl:variable name="edition_i18n" select="normalize-space((//*[contains(local-name(), '-standard')])[1]/*[local-name() = 'bibdata']/*[local-name() = 'edition'][normalize-space(@language) != ''])"/>
		<xsl:if test="$namespace = 'jcgm'"><xsl:text>&#xA0;</xsl:text></xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:if test="$layoutVersion2024 = 'false'">
				<xsl:text>&#xA0;</xsl:text>
			</xsl:if>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="$edition_i18n != ''">
				<!-- Example: <edition language="fr">deuxième édition</edition> -->
				<xsl:call-template name="capitalize">
					<xsl:with-param name="str" select="$edition_i18n"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="edition" select="normalize-space((//*[contains(local-name(), '-standard')])[1]/*[local-name() = 'bibdata']/*[local-name() = 'edition'])"/>
				<xsl:if test="$edition != ''"> <!-- Example: 1.3 -->
					<xsl:call-template name="capitalize">
						<xsl:with-param name="str">
							<xsl:call-template name="getLocalizedString">
								<xsl:with-param name="key">edition</xsl:with-param>
							</xsl:call-template>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:text> </xsl:text>
					<xsl:value-of select="$edition"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	
	<!-- convert YYYY-MM-DD to 'Month YYYY' or 'Month DD, YYYY' or DD Month YYYY -->
	<xsl:template name="convertDate">
		<xsl:param name="date"/>
		<xsl:param name="format" select="'short'"/>
		<xsl:variable name="year" select="substring($date, 1, 4)"/>
		<xsl:variable name="month" select="substring($date, 6, 2)"/>
		<xsl:variable name="day" select="substring($date, 9, 2)"/>
		<xsl:variable name="monthStr">
			<xsl:call-template name="getMonthByNum">
				<xsl:with-param name="num" select="$month"/>
				<xsl:with-param name="lowercase" select="'true'"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="monthStr_localized">
			<xsl:if test="normalize-space($monthStr) != ''"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_<xsl:value-of select="$monthStr"/></xsl:with-param></xsl:call-template></xsl:if>
		</xsl:variable>
		<xsl:variable name="result">
			<xsl:choose>
				<xsl:when test="$format = 'ddMMyyyy'"> <!-- convert date from format 2007-04-01 to 1 April 2007 -->
					<xsl:if test="$day != ''"><xsl:value-of select="number($day)"/></xsl:if>
					<xsl:text> </xsl:text>
					<xsl:value-of select="normalize-space(concat($monthStr_localized, ' ' , $year))"/>
				</xsl:when>
				<xsl:when test="$format = 'ddMM'">
					<xsl:if test="$day != ''"><xsl:value-of select="number($day)"/></xsl:if>
					<xsl:text> </xsl:text><xsl:value-of select="$monthStr_localized"/>
				</xsl:when>
				<xsl:when test="$format = 'short' or $day = ''">
					<xsl:value-of select="normalize-space(concat($monthStr_localized, ' ', $year))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space(concat($monthStr_localized, ' ', $day, ', ' , $year))"/> <!-- January 01, 2022 -->
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$result"/>
	</xsl:template> <!-- convertDate -->

	<!-- return Month's name by number -->
	<xsl:template name="getMonthByNum">
		<xsl:param name="num"/>
		<xsl:param name="lang">en</xsl:param>
		<xsl:param name="lowercase">false</xsl:param> <!-- return 'january' instead of 'January' -->
		<xsl:variable name="monthStr_">
			<xsl:choose>
				<xsl:when test="$lang = 'fr'">
					<xsl:choose>
						<xsl:when test="$num = '01'">Janvier</xsl:when>
						<xsl:when test="$num = '02'">Février</xsl:when>
						<xsl:when test="$num = '03'">Mars</xsl:when>
						<xsl:when test="$num = '04'">Avril</xsl:when>
						<xsl:when test="$num = '05'">Mai</xsl:when>
						<xsl:when test="$num = '06'">Juin</xsl:when>
						<xsl:when test="$num = '07'">Juillet</xsl:when>
						<xsl:when test="$num = '08'">Août</xsl:when>
						<xsl:when test="$num = '09'">Septembre</xsl:when>
						<xsl:when test="$num = '10'">Octobre</xsl:when>
						<xsl:when test="$num = '11'">Novembre</xsl:when>
						<xsl:when test="$num = '12'">Décembre</xsl:when>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="$num = '01'">January</xsl:when>
						<xsl:when test="$num = '02'">February</xsl:when>
						<xsl:when test="$num = '03'">March</xsl:when>
						<xsl:when test="$num = '04'">April</xsl:when>
						<xsl:when test="$num = '05'">May</xsl:when>
						<xsl:when test="$num = '06'">June</xsl:when>
						<xsl:when test="$num = '07'">July</xsl:when>
						<xsl:when test="$num = '08'">August</xsl:when>
						<xsl:when test="$num = '09'">September</xsl:when>
						<xsl:when test="$num = '10'">October</xsl:when>
						<xsl:when test="$num = '11'">November</xsl:when>
						<xsl:when test="$num = '12'">December</xsl:when>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="normalize-space($lowercase) = 'true'">
				<xsl:value-of select="java:toLowerCase(java:java.lang.String.new($monthStr_))"/>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="$monthStr_"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- getMonthByNum -->
	
	<!-- return Month's name by number from localized strings -->
	<xsl:template name="getMonthLocalizedByNum">
		<xsl:param name="num"/>
		<xsl:variable name="monthStr">
			<xsl:choose>
				<xsl:when test="$num = '01'">january</xsl:when>
				<xsl:when test="$num = '02'">february</xsl:when>
				<xsl:when test="$num = '03'">march</xsl:when>
				<xsl:when test="$num = '04'">april</xsl:when>
				<xsl:when test="$num = '05'">may</xsl:when>
				<xsl:when test="$num = '06'">june</xsl:when>
				<xsl:when test="$num = '07'">july</xsl:when>
				<xsl:when test="$num = '08'">august</xsl:when>
				<xsl:when test="$num = '09'">september</xsl:when>
				<xsl:when test="$num = '10'">october</xsl:when>
				<xsl:when test="$num = '11'">november</xsl:when>
				<xsl:when test="$num = '12'">december</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:call-template name="getLocalizedString">
			<xsl:with-param name="key">month_<xsl:value-of select="$monthStr"/></xsl:with-param>
		</xsl:call-template>
	</xsl:template> <!-- getMonthLocalizedByNum -->

	<xsl:template name="insertKeywords">
		<xsl:param name="sorting" select="'true'"/>
		<xsl:param name="meta" select="'false'"/>
		<xsl:param name="charAtEnd" select="'.'"/>
		<xsl:param name="charDelim" select="', '"/>
		<xsl:choose>
			<xsl:when test="$sorting = 'true' or $sorting = 'yes'">
				<xsl:for-each select="//*[contains(local-name(), '-standard')]/*[local-name() = 'bibdata']//*[local-name() = 'keyword']">
					<xsl:sort data-type="text" order="ascending"/>
					<xsl:call-template name="insertKeyword">
						<xsl:with-param name="meta" select="$meta"/>
						<xsl:with-param name="charAtEnd" select="$charAtEnd"/>
						<xsl:with-param name="charDelim" select="$charDelim"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="//*[contains(local-name(), '-standard')]/*[local-name() = 'bibdata']//*[local-name() = 'keyword']">
					<xsl:call-template name="insertKeyword">
						<xsl:with-param name="meta" select="$meta"/>
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
		<xsl:param name="meta"/>
		<xsl:choose>
			<xsl:when test="$meta = 'true'">
				<xsl:value-of select="."/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="position() != last()"><xsl:value-of select="$charDelim"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$charAtEnd"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="addPDFUAmeta">
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
								<xsl:choose>
									<xsl:when test="$namespace = 'jcgm'">
										<xsl:value-of select="*[local-name() = 'title'][@language = $lang and @type = 'title-part']"/>
									</xsl:when>
									<xsl:when test="$namespace = 'ieee'">
										<xsl:value-of select="$title_prefix"/>
										<xsl:value-of select="*[local-name() = 'title']"/>
									</xsl:when>
									<xsl:when test="$namespace = 'iho' or $namespace = 'csa' or $namespace = 'csd' or $namespace = 'rsd' or $namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'mpfd'">								
										<xsl:value-of select="*[local-name() = 'title'][@language = $lang]"/>
									</xsl:when>
									<xsl:when test="$namespace = 'm3d'">
										<xsl:value-of select="*[local-name() = 'title']"/>
									</xsl:when>
									<xsl:when test="$namespace = 'itu'">
										<xsl:value-of select="*[local-name() = 'title'][@type='main']"/>
									</xsl:when>	
									<xsl:otherwise>
										<xsl:value-of select="*[local-name() = 'title'][@language = $lang and @type = 'main']"/>
									</xsl:otherwise>
								</xsl:choose>
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
							<xsl:choose>
								<xsl:when test="$namespace = 'ieee'">
									<xsl:value-of select="ieee:ext/ieee:editorialgroup/ieee:committee"/>
								</xsl:when>
								<xsl:when test="$namespace = 'jcgm'">
									<xsl:value-of select="normalize-space(*[local-name() = 'ext']/*[local-name() = 'editorialgroup']/*[local-name() = 'committee'])"/>
								</xsl:when>
								<xsl:when test="$namespace = 'nist-cswp'  or $namespace = 'nist-sp'">
									<xsl:for-each select="*[local-name() = 'contributor'][*[local-name() = 'role']/@type='author']">
										<xsl:value-of select="*[local-name() = 'person']/*[local-name() = 'name']/*[local-name() = 'completename']"/>
										<xsl:if test="position() != last()">; </xsl:if>
									</xsl:for-each>
								</xsl:when>
								<xsl:otherwise>
									<xsl:for-each select="*[local-name() = 'contributor'][*[local-name() = 'role']/@type='author']">
										<xsl:value-of select="*[local-name() = 'organization']/*[local-name() = 'name']"/>
										<xsl:if test="position() != last()">; </xsl:if>
									</xsl:for-each>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</dc:creator>
					<dc:description>
						<xsl:variable name="abstract">
							<xsl:choose>
								<xsl:when test="$namespace = 'jcgm'">
									<xsl:value-of select="//*[contains(local-name(), '-standard')]/*[local-name() = 'bibdata']/*[local-name() = 'title'][@language = $lang and @type = 'title-main']"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:copy-of select="//*[contains(local-name(), '-standard')]/*[local-name() = 'preface']/*[local-name() = 'abstract']//text()[not(ancestor::*[local-name() = 'title'])]"/>									
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:value-of select="normalize-space($abstract)"/>
					</dc:description>
					<pdf:Keywords>
						<xsl:call-template name="insertKeywords">
							<xsl:with-param name="meta">true</xsl:with-param>
						</xsl:call-template>
					</pdf:Keywords>
				</rdf:Description>
				<rdf:Description rdf:about=""
						xmlns:xmp="http://ns.adobe.com/xap/1.0/">
					<!-- XMP properties go here -->
					<xmp:CreatorTool></xmp:CreatorTool>
				</rdf:Description>
			</rdf:RDF>
		</x:xmpmeta>
	</xsl:template> <!-- addPDFUAmeta -->
	
	<xsl:template name="getId">
		<xsl:choose>
			<xsl:when test="../@id">
				<xsl:value-of select="../@id"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat(generate-id(..), '_', text())"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- Get or calculate depth of the element -->
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
	</xsl:template> <!-- getLevel -->

	<!-- Get or calculate depth of term's name -->
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
	</xsl:template> <!-- getLevelTermName -->

	<!-- split string by separator -->
	<xsl:template name="split">
		<xsl:param name="pText" select="."/>
		<xsl:param name="sep" select="','"/>
		<xsl:param name="normalize-space" select="'true'"/>
		<xsl:param name="keep_sep" select="'false'"/>
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
			<xsl:if test="$keep_sep = 'true' and contains($pText, $sep)"><item><xsl:value-of select="$sep"/></item></xsl:if>
			<xsl:call-template name="split">
				<xsl:with-param name="pText" select="substring-after($pText, $sep)"/>
				<xsl:with-param name="sep" select="$sep"/>
				<xsl:with-param name="normalize-space" select="$normalize-space"/>
				<xsl:with-param name="keep_sep" select="$keep_sep"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template> <!-- split -->
 
 
	<xsl:template name="getDocumentId">		
		<xsl:call-template name="getLang"/><xsl:value-of select="//*[local-name() = 'p'][1]/@id"/>
	</xsl:template>
	
	<xsl:template name="getDocumentId_fromCurrentNode">		
		<xsl:call-template name="getLang_fromCurrentNode"/><xsl:value-of select=".//*[local-name() = 'p'][1]/@id"/>
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
			<xsl:if test="$namespace = 'ieee'">
				<xsl:value-of select="document('')//*/namespace::ieee"/>
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
				<xsl:value-of select="document('')//*/namespace::ribose"/>
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
	</xsl:template> <!-- namespaceCheck -->
 
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
		<xsl:param name="prefix"/>
		<xsl:attribute name="id">
			<xsl:choose>
				<xsl:when test="@id">
					<xsl:value-of select="concat($prefix, @id)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat($prefix, generate-id())"/>
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
		<xsl:param name="lang"/>
		<xsl:param name="returnEmptyIfNotFound">false</xsl:param>
		
		<xsl:variable name="curr_lang">
			<xsl:choose>
				<xsl:when test="$lang != ''"><xsl:value-of select="$lang"/></xsl:when>
				<xsl:when test="$returnEmptyIfNotFound = 'true'"></xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="getLang"/>
				</xsl:otherwise>
			</xsl:choose>
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
			<xsl:when test="$returnEmptyIfNotFound = 'true'"></xsl:when>
			<xsl:otherwise>
				<xsl:variable name="key_">
					<xsl:call-template name="capitalize">
						<xsl:with-param name="str" select="translate($key, '_', ' ')"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:value-of select="$key_"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- getLocalizedString -->
	
	
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
					<xsl:attribute name="padding">2mm</xsl:attribute>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- setTrackChangesStyles -->
	
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
		<xsl:variable name="align" select="normalize-space(@align)"/>
		<xsl:attribute name="text-align">
			<xsl:choose>
				<xsl:when test="$lang = 'ar' and $align = 'left'">start</xsl:when>
				<xsl:when test="$lang = 'ar' and $align = 'right'">end</xsl:when>
				<xsl:when test="$align = 'justified'">justify</xsl:when>
				<xsl:when test="$align != '' and not($align = 'indent')"><xsl:value-of select="$align"/></xsl:when>
				<xsl:when test="ancestor::*[local-name() = 'td']/@align"><xsl:value-of select="ancestor::*[local-name() = 'td']/@align"/></xsl:when>
				<xsl:when test="ancestor::*[local-name() = 'th']/@align"><xsl:value-of select="ancestor::*[local-name() = 'th']/@align"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$default"/></xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
		<xsl:if test="$align = 'indent'">
			<xsl:attribute name="margin-left">7mm</xsl:attribute>
		</xsl:if>
	</xsl:template>
 
	<xsl:template name="setBlockAttributes">
		<xsl:param name="text_align_default">left</xsl:param>
		<xsl:call-template name="setTextAlignment">
			<xsl:with-param name="default" select="$text_align_default"/>
		</xsl:call-template>
		
		<!-- https://www.metanorma.org/author/topics/document-format/text/#avoiding-page-breaks -->
		<!-- Example: keep-lines-together="true" -->
		<xsl:if test="@keep-lines-together = 'true'">
			<xsl:attribute name="keep-together.within-column">always</xsl:attribute>
		</xsl:if>
		<!-- Example: keep-with-next="true" -->
		<xsl:if test="@keep-with-next =  'true'">
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
		</xsl:if>
	</xsl:template>
 
	<xsl:template name="number-to-words">
		<xsl:param name="number" />
		<xsl:param name="first"/>
		<xsl:if test="$number != ''">
			<xsl:variable name="words">
				<words>
					<xsl:choose>
						<xsl:when test="$lang = 'fr'"> <!-- https://en.wiktionary.org/wiki/Appendix:French_numbers -->
							<word cardinal="1">Une-</word>
							<word ordinal="1">Première </word>
							<word cardinal="2">Deux-</word>
							<word ordinal="2">Seconde </word>
							<word cardinal="3">Trois-</word>
							<word ordinal="3">Tierce </word>
							<word cardinal="4">Quatre-</word>
							<word ordinal="4">Quatrième </word>
							<word cardinal="5">Cinq-</word>
							<word ordinal="5">Cinquième </word>
							<word cardinal="6">Six-</word>
							<word ordinal="6">Sixième </word>
							<word cardinal="7">Sept-</word>
							<word ordinal="7">Septième </word>
							<word cardinal="8">Huit-</word>
							<word ordinal="8">Huitième </word>
							<word cardinal="9">Neuf-</word>
							<word ordinal="9">Neuvième </word>
							<word ordinal="10">Dixième </word>
							<word ordinal="11">Onzième </word>
							<word ordinal="12">Douzième </word>
							<word ordinal="13">Treizième </word>
							<word ordinal="14">Quatorzième </word>
							<word ordinal="15">Quinzième </word>
							<word ordinal="16">Seizième </word>
							<word ordinal="17">Dix-septième </word>
							<word ordinal="18">Dix-huitième </word>
							<word ordinal="19">Dix-neuvième </word>
							<word cardinal="20">Vingt-</word>
							<word ordinal="20">Vingtième </word>
							<word cardinal="30">Trente-</word>
							<word ordinal="30">Trentième </word>
							<word cardinal="40">Quarante-</word>
							<word ordinal="40">Quarantième </word>
							<word cardinal="50">Cinquante-</word>
							<word ordinal="50">Cinquantième </word>
							<word cardinal="60">Soixante-</word>
							<word ordinal="60">Soixantième </word>
							<word cardinal="70">Septante-</word>
							<word ordinal="70">Septantième </word>
							<word cardinal="80">Huitante-</word>
							<word ordinal="80">Huitantième </word>
							<word cardinal="90">Nonante-</word>
							<word ordinal="90">Nonantième </word>
							<word cardinal="100">Cent-</word>
							<word ordinal="100">Centième </word>
						</xsl:when>
						<xsl:when test="$lang = 'ru'">
							<word cardinal="1">Одна-</word>
							<word ordinal="1">Первое </word>
							<word cardinal="2">Две-</word>
							<word ordinal="2">Второе </word>
							<word cardinal="3">Три-</word>
							<word ordinal="3">Третье </word>
							<word cardinal="4">Четыре-</word>
							<word ordinal="4">Четвертое </word>
							<word cardinal="5">Пять-</word>
							<word ordinal="5">Пятое </word>
							<word cardinal="6">Шесть-</word>
							<word ordinal="6">Шестое </word>
							<word cardinal="7">Семь-</word>
							<word ordinal="7">Седьмое </word>
							<word cardinal="8">Восемь-</word>
							<word ordinal="8">Восьмое </word>
							<word cardinal="9">Девять-</word>
							<word ordinal="9">Девятое </word>
							<word ordinal="10">Десятое </word>
							<word ordinal="11">Одиннадцатое </word>
							<word ordinal="12">Двенадцатое </word>
							<word ordinal="13">Тринадцатое </word>
							<word ordinal="14">Четырнадцатое </word>
							<word ordinal="15">Пятнадцатое </word>
							<word ordinal="16">Шестнадцатое </word>
							<word ordinal="17">Семнадцатое </word>
							<word ordinal="18">Восемнадцатое </word>
							<word ordinal="19">Девятнадцатое </word>
							<word cardinal="20">Двадцать-</word>
							<word ordinal="20">Двадцатое </word>
							<word cardinal="30">Тридцать-</word>
							<word ordinal="30">Тридцатое </word>
							<word cardinal="40">Сорок-</word>
							<word ordinal="40">Сороковое </word>
							<word cardinal="50">Пятьдесят-</word>
							<word ordinal="50">Пятидесятое </word>
							<word cardinal="60">Шестьдесят-</word>
							<word ordinal="60">Шестидесятое </word>
							<word cardinal="70">Семьдесят-</word>
							<word ordinal="70">Семидесятое </word>
							<word cardinal="80">Восемьдесят-</word>
							<word ordinal="80">Восьмидесятое </word>
							<word cardinal="90">Девяносто-</word>
							<word ordinal="90">Девяностое </word>
							<word cardinal="100">Сто-</word>
							<word ordinal="100">Сотое </word>
						</xsl:when>
						<xsl:otherwise> <!-- default english -->
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
						</xsl:otherwise>
					</xsl:choose>
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
	</xsl:template> <!-- number-to-words -->
 
	<!-- st for 1, nd for 2, rd for 3, th for 4, 5, 6, ... -->
	<xsl:template name="number-to-ordinal">
		<xsl:param name="number" />
		<xsl:param name="curr_lang"/>
		<xsl:choose>
			<xsl:when test="$curr_lang = 'fr'">
				<xsl:choose>					
					<xsl:when test="$number = '1'">re</xsl:when>
					<xsl:otherwise>e</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$number = 1">st</xsl:when>
					<xsl:when test="$number = 2">nd</xsl:when>
					<xsl:when test="$number = 3">rd</xsl:when>
					<xsl:otherwise>th</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- number-to-ordinal -->
 
	<!-- add the attribute fox:alt-text, required for PDF/UA -->
	<xsl:template name="setAltText">
		<xsl:param name="value"/>
		<xsl:attribute name="fox:alt-text">
			<xsl:choose>
				<xsl:when test="normalize-space($value) != ''">
					<xsl:value-of select="$value"/>
				</xsl:when>
				<xsl:otherwise>_</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:template>
 
	<xsl:template name="substring-after-last">	
		<xsl:param name="value"/>
		<xsl:param name="delimiter"/>
		<xsl:choose>
			<xsl:when test="contains($value, $delimiter)">
				<xsl:call-template name="substring-after-last">
					<xsl:with-param name="value" select="substring-after($value, $delimiter)" />
					<xsl:with-param name="delimiter" select="$delimiter" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$value" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
 
	<xsl:template match="*" mode="print_as_xml">
		<xsl:param name="level">0</xsl:param>

		<fo:block margin-left="{2*$level}mm">
			<xsl:text>&#xa;&lt;</xsl:text>
			<xsl:value-of select="local-name()"/>
			<xsl:for-each select="@*">
				<xsl:text> </xsl:text>
				<xsl:value-of select="local-name()"/>
				<xsl:text>="</xsl:text>
				<xsl:value-of select="."/>
				<xsl:text>"</xsl:text>
			</xsl:for-each>
			<xsl:text>&gt;</xsl:text>
			
			<xsl:if test="not(*)">
				<fo:inline font-weight="bold"><xsl:value-of select="."/></fo:inline>
				<xsl:text>&lt;/</xsl:text>
					<xsl:value-of select="local-name()"/>
					<xsl:text>&gt;</xsl:text>
			</xsl:if>
		</fo:block>
		
		<xsl:if test="*">
			<fo:block>
				<xsl:apply-templates mode="print_as_xml">
					<xsl:with-param name="level" select="$level + 1"/>
				</xsl:apply-templates>
			</fo:block>
			<fo:block margin-left="{2*$level}mm">
				<xsl:text>&lt;/</xsl:text>
				<xsl:value-of select="local-name()"/>
				<xsl:text>&gt;</xsl:text>
			</fo:block>
		</xsl:if>
	</xsl:template>
	
</xsl:stylesheet>
