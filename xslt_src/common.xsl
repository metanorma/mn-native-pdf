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

	<!-- https://www.metanorma.org/ns/standoc -->
	<xsl:variable name="namespace_full" select="namespace-uri(//mn:metanorma[1])"/>
	
	<!-- https://www.metanorma.org/ns/xsl -->
	<xsl:variable name="namespace_mn_xsl">https://www.metanorma.org/ns/xslt</xsl:variable>
		
	<xsl:variable name="root_element">metanorma</xsl:variable>
	
	<!---examples: 2013, 2024 -->
	<xsl:variable name="document_scheme" select="normalize-space(//mn:metanorma/mn:metanorma-extension/mn:presentation-metadata[mn:name = 'document-scheme']/mn:value)"/>

	<!-- external parameters -->
	<xsl:param name="svg_images"/> <!-- svg images array -->
	<xsl:variable name="images" select="document($svg_images)"/>
	<xsl:param name="basepath"/> <!-- base path for images -->
	<xsl:param name="inputxml_basepath"/> <!-- input xml file path -->
	<xsl:param name="inputxml_filename"/> <!-- input xml file name -->
	<xsl:param name="output_path"/> <!-- output PDF file name -->
	<xsl:param name="outputpdf_basepath"/> <!-- output PDF folder -->
	<xsl:param name="external_index" /><!-- path to index xml, generated on 1st pass, based on FOP Intermediate Format -->
	<xsl:param name="syntax-highlight">false</xsl:param> <!-- syntax highlighting feature, default - off -->
	<xsl:param name="add_math_as_text">true</xsl:param> <!-- add math in text behind svg formula, to copy-paste formula from PDF as text -->
  
	<xsl:param name="table_if">false</xsl:param> <!-- generate extended table in IF for autolayout-algorithm -->
	<xsl:param name="table_widths" /> <!-- (debug: path to) xml with table's widths, generated on 1st pass, based on FOP Intermediate Format -->
	<!-- Example: <tables>
		<table page-width="509103" id="table1" width_max="223561" width_min="223560">
			<column width_max="39354" width_min="39354"/>
			<column width_max="75394" width_min="75394"/>
			<column width_max="108813" width_min="108813"/>
			<tbody>
				<tr>
					<td width_max="39354" width_min="39354">
						<p_len>39354</p_len>
						<word_len>39354</word_len>
					</td>
					
		OLD:
			<tables>
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
	
	<!-- for table auto-layout algorithm, see <xsl:template match="*[local-name()='table']" priority="2"> -->
	<xsl:param name="table_only_with_id"/> <!-- Example: 'table1' -->
	<xsl:param name="table_only_with_ids"/> <!-- Example: 'table1 table2 table3 ' -->


	<!-- don't remove and rename this variable, it's using in mn2pdf tool -->
	<xsl:variable name="isApplyAutolayoutAlgorithm_">
		<xsl:choose>
			<xsl:when test="$namespace = 'bipm' or $namespace = 'bsi' or $namespace = 'pas' or $namespace = 'csa' or $namespace = 'csd' or $namespace = 'iec' or $namespace = 'ieee' or $namespace = 'iho' or $namespace = 'iso' or $namespace = 'itu' or $namespace = 'jcgm' or $namespace = 'jis' or $namespace = 'm3d' or $namespace = 'mpfd' or $namespace = 'nist-sp' or $namespace = 'nist-cswp' or $namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'plateau' or $namespace = 'rsd' or $namespace = 'unece' or $namespace = 'unece-rec'">true</xsl:when>
			<!-- <xsl:when test="$namespace = 'plateau'">skip</xsl:when> -->
			<xsl:otherwise>false</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="isApplyAutolayoutAlgorithm" select="normalize-space($isApplyAutolayoutAlgorithm_)"/>
	
	<xsl:variable name="isGenerateTableIF"><xsl:value-of select="$table_if"/></xsl:variable>
	<!-- <xsl:variable name="isGenerateTableIF" select="normalize-space(normalize-space($table_if) = 'true' and 1 = 1)"/> -->

	<xsl:variable name="lang">
		<xsl:call-template name="getLang"/>
	</xsl:variable>

	<xsl:variable name="inputxml_filename_prefix">
		<xsl:choose>
			<xsl:when test="contains($inputxml_filename, '.presentation.xml')">
				<xsl:value-of select="substring-before($inputxml_filename, '.presentation.xml')"/>
			</xsl:when>
			<xsl:when test="contains($inputxml_filename, '.xml')">
				<xsl:value-of select="substring-before($inputxml_filename, '.xml')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$inputxml_filename"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<!-- Note 1: Each xslt has declated variable `namespace` that allows to set some properties, processing logic, etc. for concrete xslt.
	You can put such conditions by using xslt construction `xsl:if test="..."` or <xsl:choose><xsl:when test=""></xsl:when><xsl:otherwiste></xsl:otherwiste></xsl:choose>,
	BUT DON'T put any another conditions together with $namespace = '...' (such conditions will be ignored). For another conditions, please use nested xsl:if or xsl:choose -->
	

	
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
			<xsl:if test="$namespace = 'bsi' or $namespace = 'pas' or $namespace = 'iso'">
				<xsl:text>Part #:</xsl:text>
			</xsl:if>
			<xsl:if test="$namespace = 'iec' or $namespace = 'gb'">
				<xsl:text>Part #: </xsl:text>
			</xsl:if>
		</title-part>
		<title-part lang="fr">
			<xsl:if test="$namespace = 'bsi' or $namespace = 'pas' or $namespace = 'iso'">
				<xsl:text>Partie #:</xsl:text>
			</xsl:if>
			<xsl:if test="$namespace = 'iec' or $namespace = 'gb'">
				<xsl:text>Partie #:  </xsl:text>
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
	</xsl:variable>
	<xsl:variable name="titles" select="xalan:nodeset($titles_)"/>
	
	<xsl:variable name="ace_tag">ace-tag_</xsl:variable>
	
	<xsl:variable name="title-list-tables">
		<xsl:variable name="toc_table_title" select="//mn:metanorma/mn:metanorma-extension/mn:toc[@type='table']/mn:title"/>
		<xsl:value-of select="$toc_table_title"/>
		<xsl:if test="normalize-space($toc_table_title) = ''">
			<xsl:call-template name="getLocalizedString">
				<xsl:with-param name="key">toc_tables</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:variable>
	
	<xsl:variable name="title-list-figures">
		<xsl:variable name="toc_figure_title" select="//mn:metanorma/mn:metanorma-extension/mn:toc[@type='figure']/mn:title"/>
		<xsl:value-of select="$toc_figure_title"/>
		<xsl:if test="normalize-space($toc_figure_title) = ''">
			<xsl:call-template name="getLocalizedString">
				<xsl:with-param name="key">toc_figures</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:variable>
	
	<xsl:variable name="title-list-recommendations">
		<xsl:variable name="toc_requirement_title" select="//mn:metanorma/mn:metanorma-extension/mn:toc[@type='requirement']/mn:title"/>
		<xsl:value-of select="$toc_requirement_title"/>
		<xsl:if test="normalize-space($toc_requirement_title) = ''">
			<xsl:call-template name="getLocalizedString">
				<xsl:with-param name="key">toc_recommendations</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:variable>

	<xsl:variable name="bibdata">
		<xsl:copy-of select="//mn:metanorma/mn:bibdata" />
		<xsl:copy-of select="//mn:metanorma/mn:localized-strings" />
	</xsl:variable>
	
	
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
	
	<xsl:include href="./common.characters.xsl"/>
	
	<xsl:include href="./common.page.xsl"/>
	
	<xsl:include href="./common.fonts.xsl"/>

	<xsl:include href="./common.updatexml.xsl"/>

	<xsl:include href="./common.boilerplate.xsl"/>
	
	<xsl:include href="./common.link.xsl"/>
	
	<xsl:include href="./common.sourcecode.xsl"/>
	
	<!-- pre, strong, em, underline -->
	<xsl:include href="./common.richtext.xsl"/>

	<xsl:include href="./common.requirements.xsl"/>
	
	<xsl:include href="./common.terms.xsl"/>
	
	<xsl:include href="./common.example.xsl"/>
	
	<xsl:include href="./common.table.xsl"/>
	
	<xsl:include href="./common.dl.xsl"/>
	
	<xsl:include href="./common.appendix.xsl"/>

	<xsl:include href="./common.xref.xsl"/>
	
	<xsl:include href="./common.eref.xsl"/>
	
	<xsl:include href="./common.note.xsl"/>
	
	<xsl:include href="./common.quote.xsl"/>

	<xsl:include href="./common.figure.xsl"/>
	
	<xsl:include href="./common.formula.xsl"/>
	
	<xsl:include href="./common.list.xsl"/>
	
	<xsl:include href="./common.fn.xsl"/>

	<xsl:include href="./common.admonition.xsl"/>
	
	<xsl:include href="./common.bibitem.xsl"/>
	
	<xsl:include href="./common.hljs.xsl"/>
	
	<xsl:include href="./common.indexsect.xsl"/>
	
	<xsl:include href="./common.form.xsl"/>

	<xsl:include href="./common.toc.xsl"/>
	
	<xsl:include href="./common.tab.xsl"/>
	
	<xsl:include href="./common.review.xsl"/>
	
	<xsl:include href="./common.errata.xsl"/>

	<xsl:include href="./common.ruby.xsl"/>
	
	<xsl:include href="./common.annex.xsl"/>
	
	<xsl:include href="./common.p.xsl"/>
	
	<xsl:template name="processPrefaceSectionsDefault">
		<xsl:for-each select="/*/mn:preface/*[not(self::mn:note or self::mn:admonition)]">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:apply-templates select="."/>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template name="copyCommonElements">
		<!-- copy bibdata, localized-strings, metanorma-extension and boilerplate -->
		<xsl:copy-of select="/*/*[not(self::mn:preface) and not(self::mn:sections) and not(self::mn:annex) and not(self::mn:bibliography) and not(self::mn:indexsect)]"/>
	</xsl:template>
	
	<xsl:template name="processMainSectionsDefault">
		<xsl:for-each select="/*/mn:sections/* | /*/mn:bibliography/mn:references[@normative='true']">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:apply-templates select="."/>
			<xsl:if test="$namespace = 'm3d'">
				<xsl:if test="self::mn:clause and @type='scope'">
					<xsl:if test="/*/mn:bibliography/mn:references[@normative='true']">
						<fo:block break-after="page"/>			
					</xsl:if>
				</xsl:if>
			</xsl:if>
		</xsl:for-each>
		
		<xsl:for-each select="/*/mn:annex">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:apply-templates select="."/>
		</xsl:for-each>
		
		<xsl:for-each select="/*/mn:bibliography/*[not(@normative='true')] | 
								/*/mn:bibliography/mn:clause[mn:references[not(@normative='true')]]">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:apply-templates select="."/>
		</xsl:for-each>
	</xsl:template><!-- END: processMainSectionsDefault -->

	
	<xsl:template name="deleteFile">
		<xsl:param name="filepath"/>
		<xsl:variable name="xml_file" select="java:java.io.File.new($filepath)"/>
		<xsl:variable name="xml_file_path" select="java:toPath($xml_file)"/>
		<xsl:variable name="deletefile" select="java:java.nio.file.Files.deleteIfExists($xml_file_path)"/>
	</xsl:template>
	
	<xsl:template name="getPageSequenceOrientation">
		<xsl:variable name="previous_orientation" select="preceding-sibling::mn:page_sequence[@orientation][1]/@orientation"/>
		<xsl:choose>
			<xsl:when test="@orientation = 'landscape'">-<xsl:value-of select="@orientation"/></xsl:when>
			<xsl:when test="$previous_orientation = 'landscape' and not(@orientation = 'portrait')">-<xsl:value-of select="$previous_orientation"/></xsl:when>
		</xsl:choose>
	</xsl:template>
	
	
	<xsl:variable name="regex_standard_reference">([A-Z]{2,}(/[A-Z]{2,})* \d+(-\d+)*(:\d{4})?)</xsl:variable> <!-- example: ISO 1234:2000 -->
	<xsl:variable name="tag_fo_inline_keep-together_within-line_open">###fo:inline keep-together_within-line###</xsl:variable>
	<xsl:variable name="tag_fo_inline_keep-together_within-line_close">###/fo:inline keep-together_within-line###</xsl:variable>
	<xsl:template match="text()" name="text">
		<xsl:choose>
			<xsl:when test="$namespace = 'iso'"><xsl:value-of select="."/></xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="ancestor::mn:table"><xsl:value-of select="."/></xsl:when>
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
				<xsl:choose>
					<xsl:when test="local-name(..) = 'keep-together_within-line'"> <!-- prevent two nested <fo:inline keep-together.within-line="always"><fo:inline keep-together.within-line="always" -->
						<xsl:value-of select="substring-before($text_after, $tag_close)"/>
					</xsl:when>
					<xsl:otherwise>
						<fo:inline keep-together.within-line="always" role="SKIP">
							<xsl:value-of select="substring-before($text_after, $tag_close)"/>
						</fo:inline>
					</xsl:otherwise>
				</xsl:choose>
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
	
	
	<!-- keep-together for standard's name (ISO 12345:2020), added in mode="update_xml_enclose_keep-together_within-line" -->
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
				<xsl:for-each select="xalan:nodeset($items)/mnx:item">
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
	
	
	<!-- add zero spaces into table cells text -->
	<xsl:template match="*[local-name() = 'td']//text() | *[local-name() = 'th']//text() | *[local-name() = 'dt']//text() | *[local-name() = 'dd']//text()" priority="1">
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



	
	<!-- default: ignore title in sections/p -->
	<xsl:template match="mn:sections/mn:p[starts-with(@class, 'zzSTDTitle')]" priority="3" />
	

	
	<xsl:template match="mn:pagebreak">
		<fo:block break-after="page"/>
		<fo:block>&#xA0;</fo:block>
		<fo:block break-after="page"/>
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
	

	<xsl:template name="getLang">
		<xsl:variable name="language_current" select="normalize-space(//mn:bibdata//mn:language[@current = 'true'])"/>
		<xsl:variable name="language">
			<xsl:choose>
				<xsl:when test="$language_current != ''">
					<xsl:value-of select="$language_current"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="language_current_2" select="normalize-space(xalan:nodeset($bibdata)//mn:bibdata//mn:language[@current = 'true'])"/>
					<xsl:choose>
						<xsl:when test="$language_current_2 != ''">
							<xsl:value-of select="$language_current_2"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="language_current_3" select="normalize-space(//mn:bibdata//mn:language)"/>
							<xsl:choose>
								<xsl:when test="$language_current_3 != ''">
									<xsl:value-of select="$language_current_3"/>
								</xsl:when>
								<xsl:otherwise>en</xsl:otherwise>
							</xsl:choose>
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
		<xsl:variable name="language_current" select="normalize-space(.//mn:bibdata//mn:language[@current = 'true'])"/>
		<xsl:variable name="language">
			<xsl:choose>
				<xsl:when test="$language_current != ''">
					<xsl:value-of select="$language_current"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="language_current_2" select="normalize-space(xalan:nodeset($bibdata)//mn:bibdata//mn:language[@current = 'true'])"/>
					<xsl:choose>
						<xsl:when test="$language_current_2 != ''">
							<xsl:value-of select="$language_current_2"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select=".//mn:bibdata//mn:language"/>
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


	<xsl:template match="mn:localityStack"/>

	<xsl:variable name="pdfAttachmentsList_">
		<xsl:for-each select="//mn:metanorma/mn:metanorma-extension/mn:attachment">
			<attachment filename="{@name}"/>
		</xsl:for-each>
		<xsl:if test="not(//mn:metanorma/mn:metanorma-extension/mn:attachment)">
			<xsl:for-each select="//mn:bibitem[@hidden = 'true'][mn:uri[@type = 'attachment']]">
				<xsl:variable name="attachment_path" select="mn:uri[@type = 'attachment']"/>
				<attachment filename="{$attachment_path}"/>
			</xsl:for-each>
		</xsl:if>
	</xsl:variable>
	<xsl:variable name="pdfAttachmentsList" select="xalan:nodeset($pdfAttachmentsList_)"/>


	<xsl:template name="getAltText">
		<xsl:choose>
			<xsl:when test="normalize-space(.) = ''"><xsl:value-of select="@target" /></xsl:when>
			<xsl:otherwise><xsl:value-of select="normalize-space(translate(normalize-space(), '&#xa0;—', ' -'))"/></xsl:otherwise>
			<!-- <xsl:otherwise><xsl:value-of select="@target"/></xsl:otherwise> -->
		</xsl:choose>
	</xsl:template>

	
	<xsl:template name="setBlockSpanAll">
		<xsl:if test="@columns = 1 or 
			(local-name() = 'p' and *[@columns = 1])"><xsl:attribute name="span">all</xsl:attribute></xsl:if>
	</xsl:template>
	

	<xsl:template name="getSection">
		<xsl:choose>
			<xsl:when test="mn:fmt-title">
				<xsl:variable name="fmt_title_section">
					<xsl:copy-of select="mn:fmt-title//mn:span[@class = 'fmt-caption-delim'][mn:tab][1]/preceding-sibling::node()[not(self::mn:annotation)]"/>
				</xsl:variable>
				<xsl:value-of select="normalize-space($fmt_title_section)"/>
				<xsl:if test="normalize-space($fmt_title_section) = ''">
					<xsl:value-of select="mn:fmt-title/mn:tab[1]/preceding-sibling::node()"/>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="mn:title/mn:tab[1]/preceding-sibling::node()"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="getName">
		<xsl:choose>
			<xsl:when test="mn:fmt-title//mn:span[@class = 'fmt-caption-delim'][mn:tab]">
				<xsl:copy-of select="mn:fmt-title//mn:span[@class = 'fmt-caption-delim'][mn:tab][1]/following-sibling::node()"/>
			</xsl:when>
			<xsl:when test="mn:fmt-title/mn:tab">
				<xsl:copy-of select="mn:fmt-title/mn:tab[1]/following-sibling::node()"/>
			</xsl:when>
			<xsl:when test="mn:fmt-title">
				<xsl:copy-of select="mn:fmt-title/node()"/>
			</xsl:when>
			<xsl:when test="mn:title/mn:tab">
				<xsl:copy-of select="mn:title/mn:tab[1]/following-sibling::node()"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="mn:title/node()"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="extractSection">
		<xsl:value-of select="mn:tab[1]/preceding-sibling::node()"/>
	</xsl:template>

	<xsl:template name="extractTitle">
		<xsl:choose>
				<xsl:when test="mn:tab">
					<xsl:apply-templates select="mn:tab[1]/following-sibling::node()"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates />
				</xsl:otherwise>
			</xsl:choose>
	</xsl:template>
	
	
	
	<!-- main sections -->
	<xsl:template match="/*/mn:sections/*" name="sections_node" priority="2">
		<xsl:if test="$namespace = 'm3d' or $namespace = 'unece-rec'">
				<fo:block break-after="page"/>
		</xsl:if>
		<xsl:call-template name="setNamedDestination"/>
		<fo:block>
			<xsl:call-template name="setId"/>
			
			<xsl:call-template name="sections_element_style"/>
			
			<xsl:call-template name="addReviewHelper"/>
			
			<xsl:apply-templates />
		</fo:block>
		
		<xsl:if test="$namespace = 'nist-cswp' or $namespace = 'nist-sp'">
				<xsl:if test="position() != last()">
					<fo:block break-after="page"/>
				</xsl:if>
		</xsl:if>
		
	</xsl:template>
	
	<!-- note: @top-level added in mode=" update_xml_step_move_pagebreak" -->
	<xsl:template match="mn:sections/mn:page_sequence/*[not(@top-level)]" priority="2">
		<xsl:choose>
			<xsl:when test="self::mn:clause and normalize-space() = '' and count(*) = 0"></xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="sections_node"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- page_sequence/sections/clause -->
	<xsl:template match="mn:page_sequence/mn:sections/*[not(@top-level)]" priority="2">
		<xsl:choose>
			<xsl:when test="self::mn:clause and normalize-space() = '' and count(*) = 0"></xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="sections_node"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="sections_element_style">
		<xsl:if test="$namespace = 'csa'">
			<xsl:variable name="pos"><xsl:number count="mn:sections/mn:clause[not(@type='scope') and not(@type='conformance')]"/></xsl:variable>
			<xsl:if test="$pos &gt;= 2">
				<xsl:attribute name="space-before">18pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'csd'">
			<xsl:variable name="pos"><xsl:number count="mn:sections/*/mn:clause | mn:sections/*/mn:terms"/></xsl:variable>
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
		<xsl:if test="$namespace = 'bsi' or $namespace = 'pas' or $namespace = 'iso' or $namespace = 'jcgm'">
			<xsl:variable name="pos"><xsl:number count="*"/></xsl:variable>
			<xsl:if test="$pos &gt;= 2">
				<xsl:attribute name="space-before">18pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="role">Sect</xsl:attribute>
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
			<xsl:variable name="pos"><xsl:number count="m3d:sections/*/m3d:clause | m3d:sections/*/m3d:terms"/></xsl:variable>
			<xsl:if test="$pos &gt;= 2">
				<xsl:attribute name="space-before">18pt</xsl:attribute>
			</xsl:if>
		</xsl:if>			
		<xsl:if test="$namespace = 'rsd'">
			<xsl:variable name="pos"><xsl:number count="mn:sections/mn:clause[not(@type='scope') and not(@type='conformance')]"/></xsl:variable> <!--  | mn:sections/mn:terms -->
			<xsl:if test="$pos &gt;= 2">
				<xsl:attribute name="space-before">18pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:variable name="pos"><xsl:number count="mn:sections/mn:clause[not(@type='scope') and not(@type='conformance')]"/></xsl:variable> <!--  | mn:sections/mn:terms -->
			<xsl:if test="$pos &gt;= 2">
				<xsl:attribute name="space-before">18pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc-white-paper'">
			<xsl:variable name="pos"><xsl:number count="mn:sections/*/mn:clause[not(@type='scope') and not(@type='conformance')]"/></xsl:variable> <!--  | mn:sections/mn:terms -->
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
	
	<xsl:template match="//mn:metanorma/mn:preface/*" priority="2" name="preface_node"> <!-- /*/mn:preface/* -->
		<xsl:choose>
			<xsl:when test="$namespace = 'iso'">
				<xsl:choose>
					<xsl:when test="$layoutVersion = '1951' and (self::mn:clause or self::mn:introduction)"></xsl:when>
					<xsl:when test="$layoutVersion = '1987' and $doctype = 'technical-report'"></xsl:when>
					<xsl:otherwise>
						<fo:block break-after="page"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$namespace = 'jcgm'"></xsl:when>
			<xsl:otherwise>
				<fo:block break-after="page"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:call-template name="setNamedDestination"/>
		<fo:block>
			<xsl:if test="$namespace = 'iso'">
				<xsl:attribute name="role">Sect</xsl:attribute>
				<xsl:call-template name="addTagElementT"/>
			</xsl:if>
			<xsl:call-template name="setId"/>
			<xsl:call-template name="addReviewHelper"/>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	
	<!-- preface/ page_sequence/clause -->
	<xsl:template match="mn:preface/mn:page_sequence/*[not(@top-level)]" priority="2"> <!-- /*/mn:preface/* -->
		<xsl:choose>
			<xsl:when test="self::mn:clause and normalize-space() = '' and count(*) = 0"></xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="preface_node"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- page_sequence/preface/clause -->
	<xsl:template match="mn:page_sequence/mn:preface/*[not(@top-level)]" priority="2"> <!-- /*/mn:preface/* -->
		<xsl:choose>
			<xsl:when test="self::mn:clause and normalize-space() = '' and count(*) = 0"></xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="preface_node"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="mn:clause[normalize-space() != '' or mn:figure or @id]" name="template_clause"> <!-- if clause isn't empty -->
		<xsl:call-template name="setNamedDestination"/>
		<fo:block>
			<xsl:if test="parent::mn:copyright-statement">
				<xsl:attribute name="role">SKIP</xsl:attribute>
			</xsl:if>
			
			<xsl:call-template name="setId"/>
			
			<xsl:call-template name="setBlockSpanAll"/>
			
			<xsl:call-template name="refine_clause_style"/>
			
			<xsl:call-template name="addReviewHelper"/>
			
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template name="refine_clause_style">
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bsi' or $namespace = 'pas'">
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu' or $namespace = 'jcgm'">
			<xsl:if test="@inline-header='true'">
				<xsl:attribute name="text-align">justify</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template> <!-- refine_clause_style -->
	
	
	<xsl:template match="mn:annex[normalize-space() != '']">
		<xsl:choose>
			<xsl:when test="@continue = 'true'"> <!-- it's using for figure/table on top level for block span -->
				<fo:block>
					<xsl:apply-templates />
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
			
				<fo:block break-after="page"/>
				<xsl:call-template name="setNamedDestination"/>
				
				<fo:block id="{@id}">
				
					<xsl:if test="$namespace = 'iso'">
						<xsl:attribute name="role">Sect</xsl:attribute>
						<xsl:call-template name="addTagElementT"/>
					</xsl:if>
					
					<xsl:call-template name="setBlockSpanAll"/>
					
					<xsl:call-template name="refine_annex_style"/>
					
				</fo:block>
				
				<xsl:apply-templates select="mn:fmt-title[@columns = 1]"/>
				
				<fo:block>
					<xsl:apply-templates select="node()[not(self::mn:fmt-title and @columns = 1)]" />
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="refine_annex_style">
		<xsl:if test="$namespace = 'unece' or $namespace = 'unece-rec'">
			<xsl:variable name="num"><xsl:number /></xsl:variable>
			<xsl:if test="$num = 1">
				<xsl:attribute name="margin-top">3pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:name/text() | mn:fmt-name/text()">
		<!-- 0xA0 to space replacement -->
		<xsl:value-of select="java:replaceAll(java:java.lang.String.new(.),' ',' ')"/>
	</xsl:template>
	
	

	
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
	
	<xsl:template match="mn:variant-title"/> <!-- [@type = 'sub'] -->
	<xsl:template match="mn:variant-title[@type = 'sub']" mode="subtitle">
		<fo:inline padding-right="5mm">&#xa0;</fo:inline>
		<fo:inline><xsl:apply-templates /></fo:inline>
	</xsl:template>
	
	<xsl:template match="mn:blacksquare" name="blacksquare">
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
	
	<xsl:template match="mn:p[@type = 'floating-title' or @type = 'section-title']" priority="4">
		<xsl:call-template name="title"/>
	</xsl:template>
	



	
	<!-- https://github.com/metanorma/isodoc/issues/652 -->
	<xsl:template match="mn:quote/mn:source" />
	<xsl:template match="mn:quote/mn:author" />
	<xsl:template match="mn:amend" />

	<!-- fmt-title renamed to title in update_xml_step1 -->
	<!-- <xsl:template match="mn:fmt-title" /> -->

	<!-- fmt-name renamed to name in update_xml_step1 -->
	<!-- <xsl:template match="mn:fmt-name" /> -->
		
	<!-- fmt-preferred renamed to preferred in update_xml_step1 -->
	<!-- <xsl:template match="mn:fmt-preferred" /> -->
		
	<!-- fmt-admitted renamed to admitted in update_xml_step1 -->
	<!-- <xsl:template match="mn:fmt-admitted" /> -->
	
	<!-- fmt-deprecates renamed to deprecates in update_xml_step1 -->
	<!-- <xsl:template match="mn:fmt-deprecates" /> -->
	
	<!-- fmt-definition renamed to definition in update_xml_step1 -->
	<!-- <xsl:template match="mn:fmt-definition" /> -->
	
	<!-- fmt-termsource renamed to termsource in update_xml_step1 -->
	<!-- <xsl:template match="mn:fmt-termsource" /> -->
		
	<!-- fmt-source renamed to source in update_xml_step1 -->
	<!-- <xsl:template match="mn:fmt-source" /> -->
		
	<xsl:template match="mn:semx">
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="mn:fmt-xref-label" />
  
	<xsl:template match="mn:concept"/>
	
	<xsl:template match="mn:fmt-concept">
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="mn:erefstack" />
	
	<xsl:template match="mn:svgmap" />

	<xsl:template match="mn:name[following-sibling::*[1][self::mn:fmt-name]]" />

	<!-- for correct rendering combining chars, added in mode="update_xml_step2" -->
	<xsl:template match="*[local-name() = 'lang_none']">
		<fo:inline xml:lang="none"><xsl:value-of select="."/></fo:inline>
	</xsl:template>
	
	<xsl:template name="addTagElementT">
		<xsl:variable name="title_">
			<xsl:apply-templates select="mn:fmt-title"/>
		</xsl:variable>
		<xsl:variable name="title__">
			<xsl:for-each select="xalan:nodeset($title_)/*/node()">
				<xsl:choose>
					<xsl:when test="self::text()"><xsl:text> </xsl:text><xsl:value-of select="."/><xsl:text> </xsl:text></xsl:when>
					<xsl:otherwise><xsl:text> </xsl:text><xsl:copy-of select="."/><xsl:text> </xsl:text></xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="title" select="normalize-space($title__)"/>
		<xsl:if test="$title != ''">
			<xsl:attribute name="fox:title">
				<xsl:if test="ancestor::mn:sections">
					<xsl:text>Section </xsl:text>
				</xsl:if>
				<xsl:value-of select="$title"/></xsl:attribute>
		</xsl:if>
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
				<xsl:element name="inlineChar" namespace="{$namespace_full}"><xsl:value-of select="$by"/></xsl:element>
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
	
	<!-- inlineChar added in the template replaceChar -->
	<xsl:template match="mn:inlineChar">
		<fo:inline><xsl:value-of select="."/></fo:inline>
	</xsl:template>

	
	<xsl:template name="printEdition">
		<xsl:variable name="edition_i18n" select="normalize-space((//mn:metanorma)[1]/mn:bibdata/mn:edition[normalize-space(@language) != ''])"/>
		<xsl:if test="$namespace = 'jcgm'"><xsl:text>&#xA0;</xsl:text></xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:if test="$layoutVersion != '1972' and $layoutVersion != '1979' and $layoutVersion != '2024'">
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
				<xsl:variable name="edition" select="normalize-space((//mn:metanorma)[1]/mn:bibdata/mn:edition)"/>
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
				<xsl:for-each select="//mn:metanorma/mn:bibdata//mn:keyword">
					<xsl:sort data-type="text" order="ascending"/>
					<xsl:call-template name="insertKeyword">
						<xsl:with-param name="meta" select="$meta"/>
						<xsl:with-param name="charAtEnd" select="$charAtEnd"/>
						<xsl:with-param name="charDelim" select="$charDelim"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="//mn:metanorma/mn:bibdata//mn:keyword">
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
				<!-- Commented after upgrade to Apache FOP 2.10
				<rdf:Description xmlns:pdfaExtension="http://www.aiim.org/pdfa/ns/extension/" xmlns:pdfaProperty="http://www.aiim.org/pdfa/ns/property#" xmlns:pdfaSchema="http://www.aiim.org/pdfa/ns/schema#" rdf:about="">
					<pdfaExtension:schemas>
						<rdf:Bag>
							<rdf:li rdf:parseType="Resource">
								<pdfaSchema:namespaceURI>http://www.aiim.org/pdfua/ns/id/</pdfaSchema:namespaceURI>
								<pdfaSchema:prefix>pdfuaid</pdfaSchema:prefix>
								<pdfaSchema:schema>PDF/UA identification schema</pdfaSchema:schema>
								<pdfaSchema:property>
									<rdf:Seq>
										<rdf:li rdf:parseType="Resource">
											<pdfaProperty:category>internal</pdfaProperty:category>
											<pdfaProperty:description>PDF/UA version identifier</pdfaProperty:description>
											<pdfaProperty:name>part</pdfaProperty:name>
											<pdfaProperty:valueType>Integer</pdfaProperty:valueType>
										</rdf:li>
										<rdf:li rdf:parseType="Resource">
											<pdfaProperty:category>internal</pdfaProperty:category>
											<pdfaProperty:description>PDF/UA amendment identifier</pdfaProperty:description>
											<pdfaProperty:name>amd</pdfaProperty:name>
											<pdfaProperty:valueType>Text</pdfaProperty:valueType>
										</rdf:li>
										<rdf:li rdf:parseType="Resource">
											<pdfaProperty:category>internal</pdfaProperty:category>
											<pdfaProperty:description>PDF/UA corrigenda identifier</pdfaProperty:description>
											<pdfaProperty:name>corr</pdfaProperty:name>
											<pdfaProperty:valueType>Text</pdfaProperty:valueType>
										</rdf:li>
									</rdf:Seq>
								</pdfaSchema:property>
							</rdf:li>
						</rdf:Bag>
					</pdfaExtension:schemas>
				</rdf:Description> -->
				<rdf:Description rdf:about="" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:pdf="http://ns.adobe.com/pdf/1.3/">
				<!-- Dublin Core properties go here -->
					<dc:title>
						<xsl:variable name="title">
							<xsl:for-each select="(//mn:metanorma)[1]/mn:bibdata">
								<xsl:choose>
									<xsl:when test="$namespace = 'jcgm'">
										<xsl:value-of select="mn:title[@language = $lang and @type = 'title-part']"/>
									</xsl:when>
									<xsl:when test="$namespace = 'ieee'">
										<xsl:value-of select="$title_prefix"/>
										<xsl:value-of select="mn:title"/>
									</xsl:when>
									<xsl:when test="$namespace = 'iho' or $namespace = 'csa' or $namespace = 'csd' or $namespace = 'rsd' or $namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'mpfd'">
										<xsl:value-of select="mn:title[@language = $lang]"/>
									</xsl:when>
									<xsl:when test="$namespace = 'm3d'">
										<xsl:value-of select="mn:title"/>
									</xsl:when>
									<xsl:when test="$namespace = 'itu'">
										<xsl:value-of select="mn:title[@type='main']"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:choose>
											<xsl:when test="mn:title[@language = $lang and @type = 'main']">
												<!-- <xsl:value-of select="mn:title[@language = $lang and @type = 'main']"/> -->
												<xsl:variable name="bibdata_doctype" select="mn:ext/mn:doctype"/>
												<xsl:if test="$bibdata_doctype = 'amendment'">
													<xsl:variable name="bibdata_doctype_localized" select="mn:ext/mn:doctype[@language = $lang]"/>
													<xsl:variable name="bibdata_amendment_number" select="mn:ext/mn:structuredidentifier/mn:project-number/@amendment"/>
													<xsl:value-of select="normalize-space(concat($bibdata_doctype_localized, ' ', $bibdata_amendment_number))"/>
													<xsl:text> — </xsl:text>
												</xsl:if>
												<xsl:variable name="partnumber" select="mn:ext/mn:structuredidentifier/mn:project-number/@part"/>
												<xsl:for-each select="mn:title[@language = $lang and @type = 'title-intro'] |
															mn:title[@language = $lang and @type = 'title-main'] |
															mn:title[@language = $lang and @type = 'title-complementary'] |
															mn:title[@language = $lang and @type = 'title-part']">
													<xsl:if test="@type = 'title-part'">
														<xsl:call-template name="getLocalizedString"><xsl:with-param name="key">locality.part</xsl:with-param></xsl:call-template>
														<xsl:text> </xsl:text>
														<xsl:value-of select="$partnumber"/>
														<xsl:text>: </xsl:text>
													</xsl:if>
													<xsl:value-of select="."/>
													<xsl:if test="position() != last()"><xsl:text> — </xsl:text></xsl:if>
												</xsl:for-each>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="mn:title[@language = $lang and @type = 'title-main']"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
						</xsl:variable>
						<rdf:Alt>
							<rdf:li xml:lang="x-default">
								<xsl:choose>
									<xsl:when test="normalize-space($title) != ''">
										<xsl:value-of select="$title"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:text>&#xA0;</xsl:text>
									</xsl:otherwise>
								</xsl:choose>
							</rdf:li>
						</rdf:Alt>
					</dc:title>
					<xsl:variable name="dc_creator">
						<xsl:for-each select="(//mn:metanorma)[1]/mn:bibdata">
							<xsl:choose>
								<xsl:when test="$namespace = 'ieee'">
									<rdf:Seq>
										<rdf:li>
											<!-- <xsl:value-of select="mn:ext/mn:editorialgroup/mn:committee"/> -->
											<xsl:value-of select="mn:contributor[mn:role[@type = 'authorizer']/mn:description = 'committee']/mn:organization/mn:subdivision[@type = 'Committee']/mn:name"/>
										</rdf:li>
									</rdf:Seq>
								</xsl:when>
								<xsl:when test="$namespace = 'jcgm'">
									<rdf:Seq>
										<rdf:li>
											<xsl:value-of select="normalize-space(mn:ext/mn:editorialgroup/mn:committee)"/>
										</rdf:li>
									</rdf:Seq>
								</xsl:when>
								<xsl:when test="$namespace = 'nist-cswp'  or $namespace = 'nist-sp'">
									<rdf:Seq>
										<xsl:for-each select="mn:contributor[mn:role/@type='author']">
											<rdf:li>
												<xsl:value-of select="mn:person/mn:name/mn:completename"/>
											</rdf:li>
											<!-- <xsl:if test="position() != last()">; </xsl:if> -->
										</xsl:for-each>
									</rdf:Seq>
								</xsl:when>
								<xsl:otherwise>
									<rdf:Seq>
										<xsl:for-each select="mn:contributor[mn:role[not(mn:description)]/@type='author']">
											<rdf:li>
												<xsl:value-of select="mn:organization/mn:name"/>
											</rdf:li>
											<!-- <xsl:if test="position() != last()">; </xsl:if> -->										
										</xsl:for-each>
									</rdf:Seq>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</xsl:variable>
					<xsl:if test="normalize-space($dc_creator) != ''">
						<dc:creator>
							<xsl:copy-of select="$dc_creator"/>
						</dc:creator>
					</xsl:if>
						
					<xsl:variable name="dc_description">
						<xsl:variable name="abstract">
							<xsl:choose>
								<xsl:when test="$namespace = 'jcgm'">
									<xsl:value-of select="//mn:metanorma/mn:bibdata/mn:title[@language = $lang and @type = 'title-main']"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:copy-of select="//mn:metanorma/mn:preface/mn:abstract//text()[not(ancestor::mn:fmt-title) and not(ancestor::mn:title) and not(ancestor::mn:fmt-xref-label)]"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<rdf:Alt>
							<rdf:li xml:lang="x-default">
								<xsl:value-of select="normalize-space($abstract)"/>
							</rdf:li>
						</rdf:Alt>
					</xsl:variable>
					<xsl:if test="normalize-space($dc_description)">
						<dc:description>
							<xsl:copy-of select="$dc_description"/>
						</dc:description>
					</xsl:if>
					
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
		<!-- add attachments -->
		<xsl:for-each select="//mn:metanorma/mn:metanorma-extension/mn:attachment">
			<xsl:variable name="bibitem_attachment_" select="//mn:bibitem[@hidden = 'true'][mn:uri[@type = 'attachment'] = current()/@name]"/>
			<xsl:variable name="bibitem_attachment" select="xalan:nodeset($bibitem_attachment_)"/>
			<xsl:variable name="description" select="normalize-space($bibitem_attachment/mn:formattedref)"/>
			<xsl:variable name="filename" select="java:org.metanorma.fop.Util.getFilenameFromPath(@name)"/>
			<!-- Todo: need update -->
			<xsl:variable name="afrelationship" select="normalize-space($bibitem_attachment//mn:classification[@type = 'pdf-AFRelationship'])"/>
			<xsl:variable name="volatile" select="normalize-space($bibitem_attachment//mn:classification[@type = 'pdf-volatile'])"/>
			
			<pdf:embedded-file filename="{$filename}" xmlns:pdf="http://xmlgraphics.apache.org/fop/extensions/pdf" link-as-file-annotation="true">
				<xsl:attribute name="src">
					<xsl:choose>
						<xsl:when test="normalize-space() != ''">
							<xsl:variable name="src_attachment" select="java:replaceAll(java:java.lang.String.new(.),'(&#x0d;&#x0a;|&#x0d;|&#x0a;)', '')"/> <!-- remove line breaks -->
							<xsl:value-of select="$src_attachment"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="url" select="concat('url(file:///',$inputxml_basepath , @name, ')')"/>
							<xsl:value-of select="$url"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:if test="$description != ''">
					<xsl:attribute name="description"><xsl:value-of select="$description"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="$afrelationship != ''">
					<xsl:attribute name="afrelationship"><xsl:value-of select="$afrelationship"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="$volatile != ''">
					<xsl:attribute name="volatile"><xsl:value-of select="$volatile"/></xsl:attribute>
				</xsl:if>
			</pdf:embedded-file>
		</xsl:for-each>
		<!-- references to external attachments (no binary-encoded within the Metanorma XML file) -->
		<xsl:if test="not(//mn:metanorma/mn:metanorma-extension/mn:attachment)">
			<xsl:for-each select="//mn:bibitem[@hidden = 'true'][mn:uri[@type = 'attachment']]">
				<xsl:variable name="attachment_path" select="mn:uri[@type = 'attachment']"/>
				<xsl:variable name="attachment_name" select="java:org.metanorma.fop.Util.getFilenameFromPath($attachment_path)"/>
				<!-- <xsl:variable name="url" select="concat('url(file:///',$basepath, $attachment_path, ')')"/> -->
				<!-- See https://github.com/metanorma/metanorma-iso/issues/1369 -->
				<xsl:variable name="url" select="concat('url(file:///',$outputpdf_basepath, $attachment_path, ')')"/>
				<xsl:variable name="description" select="normalize-space(mn:formattedref)"/>
				<!-- Todo: need update -->
				<xsl:variable name="afrelationship" select="normalize-space(.//mn:classification[@type = 'pdf-AFRelationship'])"/>
				<xsl:variable name="volatile" select="normalize-space(.//mn:classification[@type = 'pdf-volatile'])"/>
				<pdf:embedded-file src="{$url}" filename="{$attachment_name}" xmlns:pdf="http://xmlgraphics.apache.org/fop/extensions/pdf" link-as-file-annotation="true">
					<xsl:if test="$description != ''">
						<xsl:attribute name="description"><xsl:value-of select="$description"/></xsl:attribute>
					</xsl:if>
					<xsl:if test="$afrelationship != ''">
						<xsl:attribute name="afrelationship"><xsl:value-of select="$afrelationship"/></xsl:attribute>
					</xsl:if>
					<xsl:if test="$volatile != ''">
						<xsl:attribute name="volatile"><xsl:value-of select="$volatile"/></xsl:attribute>
					</xsl:if>
				</pdf:embedded-file>
			</xsl:for-each>
		</xsl:if>
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
		<!-- <xsl:message>
			<xsl:choose>
				<xsl:when test="local-name() = 'title'">title=<xsl:value-of select="."/></xsl:when>
				<xsl:when test="local-name() = 'clause'">clause/title=<xsl:value-of select="mn:title"/></xsl:when>
			</xsl:choose>
		</xsl:message> -->
		<xsl:choose>
			<xsl:when test="normalize-space(@depth) != ''">
				<xsl:value-of select="@depth"/>
			</xsl:when>
			<xsl:when test="normalize-space($depth) != ''">
				<xsl:value-of select="$depth"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="level_total" select="count(ancestor::*[local-name() != 'page_sequence'])"/>
				<xsl:variable name="level">
					<xsl:choose>
						<xsl:when test="parent::mn:preface">
							<xsl:value-of select="$level_total - 1"/>
						</xsl:when>
						<xsl:when test="ancestor::mn:preface and not(ancestor::mn:foreword) and not(ancestor::mn:introduction)"> <!-- for preface/clause -->
							<xsl:value-of select="$level_total - 1"/>
						</xsl:when>
						<xsl:when test="ancestor::mn:preface">
							<xsl:value-of select="$level_total - 2"/>
						</xsl:when>
						<xsl:when test="ancestor::mn:sections and self::mn:fmt-title">
							<!-- determine 'depth' depends on upper clause with title/@depth -->
							<!-- <xsl:message>title=<xsl:value-of select="."/></xsl:message> -->
							<xsl:variable name="clause_with_depth_depth" select="ancestor::mn:clause[mn:fmt-title/@depth][1]/mn:fmt-title/@depth"/>
							<!-- <xsl:message>clause_with_depth_depth=<xsl:value-of select="$clause_with_depth_depth"/></xsl:message> -->
							<xsl:variable name="clause_with_depth_level" select="count(ancestor::mn:clause[mn:fmt-title/@depth][1]/ancestor::*)"/>
							<!-- <xsl:message>clause_with_depth_level=<xsl:value-of select="$clause_with_depth_level"/></xsl:message> -->
							<xsl:variable name="curr_level" select="count(ancestor::*) - 1"/>
							<!-- <xsl:message>curr_level=<xsl:value-of select="$curr_level"/></xsl:message> -->
							<!-- <xsl:variable name="upper_clause_depth" select="normalize-space(ancestor::mn:clause[2]/mn:title/@depth)"/> -->
							<xsl:variable name="curr_clause_depth" select="number($clause_with_depth_depth) + (number($curr_level) - number($clause_with_depth_level)) "/>
							<!-- <xsl:message>curr_clause_depth=<xsl:value-of select="$curr_clause_depth"/></xsl:message> -->
							<xsl:choose>
								<xsl:when test="string(number($curr_clause_depth)) != 'NaN'">
									<xsl:value-of select="number($curr_clause_depth)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$level_total - 2"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="ancestor::mn:sections and self::mn:fmt-name and parent::mn:term">
							<xsl:variable name="upper_terms_depth" select="normalize-space(ancestor::mn:terms[1]/mn:fmt-title/@depth)"/>
							<xsl:choose>
								<xsl:when test="string(number($upper_terms_depth)) != 'NaN'">
									<xsl:value-of select="number($upper_terms_depth + 1)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$level_total - 2"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="ancestor::mn:sections">
							<xsl:variable name="upper_clause_depth" select="normalize-space(ancestor::*[self::mn:clause or self::mn:terms][1]/mn:fmt-title/@depth)"/>
							<xsl:choose>
								<xsl:when test="string(number($upper_clause_depth)) != 'NaN'">
									<xsl:value-of select="number($upper_clause_depth + 1)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$level_total - 1"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="ancestor::mn:bibliography">
							<xsl:value-of select="$level_total - 1"/>
						</xsl:when>
						<xsl:when test="parent::mn:annex">
							<xsl:value-of select="$level_total - 1"/>
						</xsl:when>
						<xsl:when test="ancestor::mn:annex and self::mn:fmt-title">
							<xsl:variable name="upper_clause_depth" select="normalize-space(ancestor::mn:clause[2]/mn:fmt-title/@depth)"/>
							<xsl:choose>
								<xsl:when test="string(number($upper_clause_depth)) != 'NaN'">
									<xsl:value-of select="number($upper_clause_depth + 1)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$level_total - 1"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="ancestor::mn:annex">
							<xsl:value-of select="$level_total"/>
						</xsl:when>
						<xsl:when test="self::mn:annex">1</xsl:when>
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
					<xsl:for-each select="../preceding-sibling::mn:fmt-title[1]">
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
			<xsl:element name="item" namespace="{$namespace_mn_xsl}">
				<xsl:choose>
					<xsl:when test="$normalize-space = 'true'">
						<xsl:value-of select="normalize-space(substring-before(concat($pText, $sep), $sep))"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring-before(concat($pText, $sep), $sep)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
			<xsl:if test="$keep_sep = 'true' and contains($pText, $sep)"><xsl:element name="item" namespace="{$namespace_mn_xsl}"><xsl:value-of select="$sep"/></xsl:element></xsl:if>
			<xsl:call-template name="split">
				<xsl:with-param name="pText" select="substring-after($pText, $sep)"/>
				<xsl:with-param name="sep" select="$sep"/>
				<xsl:with-param name="normalize-space" select="$normalize-space"/>
				<xsl:with-param name="keep_sep" select="$keep_sep"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template> <!-- split -->
 
 
	<xsl:template name="getDocumentId">		
		<xsl:call-template name="getLang"/><xsl:value-of select="//mn:p[1]/@id"/>
	</xsl:template>
	
	<xsl:template name="getDocumentId_fromCurrentNode">		
		<xsl:call-template name="getLang_fromCurrentNode"/><xsl:value-of select=".//mn:p[1]/@id"/>
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
	
	<xsl:template name="setIDforNamedDestination">
		<xsl:if test="@named_dest">
			<xsl:attribute name="id"><xsl:value-of select="@named_dest"/></xsl:attribute>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="setIDforNamedDestinationInline">
		<xsl:if test="@named_dest">
			<fo:inline><xsl:call-template name="setIDforNamedDestination"/></fo:inline>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="setNamedDestination">
		<xsl:if test="$isGenerateTableIF = 'false'">
			<!-- skip GUID, e.g. _33eac3cb-9663-4291-ae26-1d4b6f4635fc -->
			<xsl:if test="@id and 
					normalize-space(java:matches(java:java.lang.String.new(@id), '_[0-9a-z]{8}-[0-9a-z]{4}-[0-9a-z]{4}-[0-9a-z]{4}-[0-9a-z]{12}')) = 'false'">
				<fox:destination internal-destination="{@id}"/>
			</xsl:if>
			<xsl:for-each select=". | mn:fmt-title | mn:fmt-name">
				<xsl:if test="@named_dest">
					<fox:destination internal-destination="{@named_dest}"/>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
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
		<xsl:param name="bibdata_updated"/>
		
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
				<xsl:when test="$formatted = 'true' and string-length($bibdata_updated) != 0">
					<xsl:apply-templates select="xalan:nodeset($bibdata_updated)//mn:localized-string[@key = $key and @language = $curr_lang]"/>
				</xsl:when>
				<xsl:when test="string-length($bibdata_updated) != 0">
					<xsl:value-of select="xalan:nodeset($bibdata_updated)//mn:localized-string[@key = $key and @language = $curr_lang]"/>
				</xsl:when>
				<xsl:when test="$formatted = 'true'">
					<xsl:apply-templates select="xalan:nodeset($bibdata)//mn:localized-string[@key = $key and @language = $curr_lang]"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space(xalan:nodeset($bibdata)//mn:localized-string[@key = $key and @language = $curr_lang])"/>
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
			<xsl:when test="/*/mn:localized-strings/mn:localized-string[@key = $key and @language = $curr_lang]">
				<xsl:choose>
					<xsl:when test="$formatted = 'true'">
						<xsl:apply-templates select="/*/mn:localized-strings/mn:localized-string[@key = $key and @language = $curr_lang]"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="/*/mn:localized-strings/mn:localized-string[@key = $key and @language = $curr_lang]"/>
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
		
		<xsl:variable name="border-block-added">2.5pt solid rgb(0, 176, 80)</xsl:variable>
		<xsl:variable name="border-block-deleted">2.5pt solid rgb(255, 0, 0)</xsl:variable>
	
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
				<xsl:when test="ancestor::mn:td/@align"><xsl:value-of select="ancestor::mn:td/@align"/></xsl:when>
				<xsl:when test="ancestor::mn:th/@align"><xsl:value-of select="ancestor::mn:th/@align"/></xsl:when>
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
		<xsl:call-template name="setKeepAttributes"/>
		<xsl:if test="node()[1][self::mn:span][contains(@style, 'line-height')]">
			<xsl:variable name="styles">
				<xsl:apply-templates select="*[1]"/>
			</xsl:variable>
			<!-- move attribute line-height from inline to block -->
			<xsl:attribute name="line-height"><xsl:value-of select="xalan:nodeset($styles)//*/@line-height"/></xsl:attribute>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="setKeepAttributes">
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
 
	<!-- insert cover page image -->
	<!-- background cover image -->
	<xsl:template name="insertBackgroundPageImage">
		<xsl:param name="number">1</xsl:param>
		<xsl:param name="name">coverpage-image</xsl:param>
		<xsl:param name="suffix"/>
		<xsl:variable name="num" select="number($number)"/>
		<!-- background image -->
		<fo:block-container absolute-position="fixed" left="0mm" top="0mm" font-size="0" id="__internal_layout__coverpage{$suffix}_{$name}_{$number}_{generate-id()}">
			<fo:block>
				<xsl:for-each select="/mn:metanorma/mn:metanorma-extension/mn:presentation-metadata[mn:name = $name][1]/mn:value/mn:image[$num]">
					
					<xsl:call-template name="insertPageImage"/>
					
				</xsl:for-each>
			</fo:block>
		</fo:block-container>
	</xsl:template>
	
	<xsl:template name="insertPageImage">
		<xsl:param name="svg_content_height" select="$pageHeight"/>
		<xsl:param name="bitmap_width" select="$pageWidth"/>
		<xsl:choose>
			<xsl:when test="*[local-name() = 'svg'] or java:endsWith(java:java.lang.String.new(@src), '.svg')">
				<fo:instream-foreign-object fox:alt-text="Image Front">
					<xsl:attribute name="content-height"><xsl:value-of select="$svg_content_height"/>mm</xsl:attribute>
					<xsl:call-template name="getSVG"/>
				</fo:instream-foreign-object>
			</xsl:when>
			<xsl:when test="starts-with(@src, 'data:application/pdf;base64')">
				<fo:external-graphic src="{@src}" fox:alt-text="Image Front"/>
			</xsl:when>
			<xsl:otherwise> <!-- bitmap image -->
				<xsl:variable name="coverimage_src" select="normalize-space(@src)"/>
				<xsl:if test="$coverimage_src != ''">
					<xsl:variable name="coverpage">
						<xsl:call-template name="getImageURL">
							<xsl:with-param name="src" select="$coverimage_src"/>
						</xsl:call-template>
					</xsl:variable>
					<fo:external-graphic src="{$coverpage}" width="{$bitmap_width}mm" content-height="scale-to-fit" scaling="uniform" fox:alt-text="Image Front"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="getImageURL">
		<xsl:param name="src"/>
		<xsl:choose>
			<xsl:when test="starts-with($src, 'data:image')">
				<xsl:value-of select="$src"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="src_external"><xsl:call-template name="getImageSrcExternal"/></xsl:variable>
				<xsl:value-of select="concat('url(file:///', $src_external, ')')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="getSVG">
		<xsl:choose>
			<xsl:when test="*[local-name() = 'svg']">
				<xsl:apply-templates select="*[local-name() = 'svg']" mode="svg_update"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="svg_content" select="document(@src)"/>
				<xsl:for-each select="xalan:nodeset($svg_content)/node()">
					<xsl:apply-templates select="." mode="svg_update"/>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- END: insert cover page image -->
 
	<!-- https://github.com/metanorma/docs/blob/main/109.adoc -->
	<xsl:variable name="regex_ja_spec_half_width_">
		\u0028  <!-- U+0028 LEFT PARENTHESIS (() -->
		\u0029 <!-- U+0029 RIGHT PARENTHESIS ()) -->
		\u007B <!-- U+007B LEFT CURLY BRACKET ({) -->
		\u007D <!-- U+007D RIGHT CURLY BRACKET (}) -->
		\uFF62 <!-- U+FF62 HALFWIDTH LEFT CORNER BRACKET (｢) -->
		\uFF63 <!-- U+FF63 HALFWIDTH RIGHT CORNER BRACKET (｣) -->
		\u005B <!-- U+005B LEFT SQUARE BRACKET ([) -->
		\u005D <!-- U+005D RIGHT SQUARE BRACKET (]) -->
	</xsl:variable>
	<xsl:variable name="regex_ja_spec_half_width" select="translate(normalize-space($regex_ja_spec_half_width_), ' ', '')"/>
	<xsl:variable name="regex_ja_spec_">[
		<!-- Rotate 90° clockwise -->
		<xsl:value-of select="$regex_ja_spec_half_width"/>
		\uFF08 <!-- U+FF08 FULLWIDTH LEFT PARENTHESIS (（) -->
		\uFF09 <!-- U+FF09 FULLWIDTH RIGHT PARENTHESIS (）) -->
		\uFF5B <!-- U+FF5B FULLWIDTH LEFT CURLY BRACKET (｛) -->
		\uFF5D <!-- U+FF5D FULLWIDTH RIGHT CURLY BRACKET (｝) -->
		\u3014 <!-- U+3014 LEFT TORTOISE SHELL BRACKET (〔) -->
		\u3015 <!-- U+3015 RIGHT TORTOISE SHELL BRACKET (〕) -->
		\u3010 <!-- U+3010 LEFT BLACK LENTICULAR BRACKET (【) -->
		\u3011 <!-- U+3011 RIGHT BLACK LENTICULAR BRACKET (】) -->
		\u300A <!-- U+300A LEFT DOUBLE ANGLE BRACKET (《) -->
		\u300B <!-- U+300B RIGHT DOUBLE ANGLE BRACKET (》) -->
		\u300C <!-- U+300C LEFT CORNER BRACKET (「) -->
		\u300D <!-- U+300D RIGHT CORNER BRACKET (」) -->
		\u300E <!-- U+300E LEFT WHITE CORNER BRACKET (『) -->
		\u300F <!-- U+300F RIGHT WHITE CORNER BRACKET (』) -->
		\uFF3B <!-- U+FF3B FULLWIDTH LEFT SQUARE BRACKET (［) -->
		\uFF3D <!-- U+FF3D FULLWIDTH RIGHT SQUARE BRACKET (］) -->
		\u3008 <!-- U+3008 LEFT ANGLE BRACKET (〈) -->
		\u3009 <!-- U+3009 RIGHT ANGLE BRACKET (〉) -->
		\u3016 <!-- U+3016 LEFT WHITE LENTICULAR BRACKET (〖) -->
		\u3017 <!-- U+3017 RIGHT WHITE LENTICULAR BRACKET (〗) -->
		\u301A <!-- U+301A LEFT WHITE SQUARE BRACKET (〚) -->
		\u301B <!-- U+301B RIGHT WHITE SQUARE BRACKET (〛) -->
		\u301C <!-- U+301C WAVE DASH (〜) -->
		\u3030 <!-- U+3030 WAVY DASH (〰 )-->
		\u30FC <!-- U+30FC KATAKANA-HIRAGANA PROLONGED SOUND MARK (ー) -->
		\u2329 <!-- U+2329 LEFT-POINTING ANGLE BRACKET (〈) -->
		\u232A <!-- U+232A RIGHT-POINTING ANGLE BRACKET (〉) -->
		\u3018 <!-- U+3018 LEFT WHITE TORTOISE SHELL BRACKET (〘) -->
		\u3019 <!-- U+3019 RIGHT WHITE TORTOISE SHELL BRACKET (〙) -->
		\u30A0 <!-- U+30A0 KATAKANA-HIRAGANA DOUBLE HYPHEN (゠) -->
		\uFE59 <!-- U+FE59 SMALL LEFT PARENTHESIS (﹙) -->
		\uFE5A <!-- U+FE5A SMALL RIGHT PARENTHESIS (﹚) -->
		\uFE5B <!-- U+FE5B SMALL LEFT CURLY BRACKET (﹛) -->
		\uFE5C <!-- U+FE5C SMALL RIGHT CURLY BRACKET (﹜) -->
		\uFE5D <!-- U+FE5D SMALL LEFT TORTOISE SHELL BRACKET (﹝) -->
		\uFE5E <!-- U+FE5E SMALL RIGHT TORTOISE SHELL BRACKET (﹞) -->
		\uFF5C <!-- U+FF5C FULLWIDTH VERTICAL LINE (｜) -->
		\uFF5F <!-- U+FF5F FULLWIDTH LEFT WHITE PARENTHESIS (｟) -->
		\uFF60 <!-- U+FF60 FULLWIDTH RIGHT WHITE PARENTHESIS (｠) -->
		\uFFE3 <!-- U+FFE3 FULLWIDTH MACRON (￣) -->
		\uFF3F <!-- U+FF3F FULLWIDTH LOW LINE (＿) -->
		\uFF5E <!-- U+FF5E FULLWIDTH TILDE (～) -->
		<!-- Rotate 180° -->
		\u309C <!-- U+309C KATAKANA-HIRAGANA SEMI-VOICED SOUND MARK (゜) -->
		\u3002 <!-- U+3002 IDEOGRAPHIC FULL STOP (。) -->
		\uFE52 <!-- U+FE52 SMALL FULL STOP (﹒) -->
		\uFF0E <!-- U+FF0E FULLWIDTH FULL STOP (．) -->
		]</xsl:variable>
	<xsl:variable name="regex_ja_spec"><xsl:value-of select="translate(normalize-space($regex_ja_spec_), ' ', '')"/></xsl:variable>
	<xsl:template name="insertVerticalChar">
		<xsl:param name="str"/>
		<xsl:param name="char_prev"/>
		<xsl:param name="writing-mode">lr-tb</xsl:param>
		<xsl:param name="reference-orientation">90</xsl:param>
		<xsl:param name="add_zero_width_space">false</xsl:param>
		<xsl:choose>
			<xsl:when test="ancestor::mn:span[@class = 'norotate']">
				<xsl:value-of select="$str"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="string-length($str) &gt; 0">
				
					<!-- <xsl:variable name="horizontal_mode" select="normalize-space(ancestor::mn:span[@class = 'horizontal'] and 1 = 1)"/> -->
					<xsl:variable name="char" select="substring($str,1,1)"/>
					<xsl:variable name="char_next" select="substring($str,2,1)"/>
					
					<xsl:variable name="char_half_width" select="normalize-space(java:matches(java:java.lang.String.new($char), concat('([', $regex_ja_spec_half_width, ']{1,})')))"/>
					
					<xsl:choose>
						<xsl:when test="$char_half_width = 'true'">
							<fo:inline>
								<xsl:attribute name="baseline-shift">7%</xsl:attribute>
								<xsl:value-of select="$char"/>
							</fo:inline>
						</xsl:when>
						<xsl:otherwise>
							<!--  namespace-uri(ancestor::mn:title) != '' to skip title from $contents  -->
							<xsl:if test="namespace-uri(ancestor::mn:fmt-title) != '' and ($char_prev = '' and ../preceding-sibling::node())">
								<fo:inline padding-left="1mm"><xsl:value-of select="$zero_width_space"/></fo:inline>
							</xsl:if>
							<fo:inline-container text-align="center"
										 alignment-baseline="central" width="1em" margin="0" padding="0"
										 text-indent="0mm" last-line-end-indent="0mm" start-indent="0mm" end-indent="0mm" role="SKIP" text-align-last="center">
								<xsl:if test="normalize-space($writing-mode) != ''">
									<xsl:attribute name="writing-mode"><xsl:value-of select="$writing-mode"/></xsl:attribute>
									<xsl:attribute name="reference-orientation">90</xsl:attribute>
								</xsl:if>
								<xsl:if test="normalize-space(java:matches(java:java.lang.String.new($char), concat('(', $regex_ja_spec, '{1,})'))) = 'true'">
									<xsl:attribute name="reference-orientation">0</xsl:attribute>
								</xsl:if>
								<xsl:if test="$char = '゜' or $char = '。' or $char = '﹒' or $char = '．'">
									<!-- Rotate 180°: 
										U+309C KATAKANA-HIRAGANA SEMI-VOICED SOUND MARK (゜)
										U+3002 IDEOGRAPHIC FULL STOP (。)
										U+FE52 SMALL FULL STOP (﹒)
										U+FF0E FULLWIDTH FULL STOP (．)
									-->
									<xsl:attribute name="reference-orientation">-90</xsl:attribute>
								</xsl:if>
								<fo:block-container width="1em" role="SKIP"><!-- border="0.5pt solid blue" -->
									<fo:block line-height="1em" role="SKIP">
										<!-- <xsl:choose>
											<xsl:when test="$horizontal_mode = 'true'">
												<xsl:value-of select="$str"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$char"/>
											</xsl:otherwise>
										</xsl:choose> -->
										<xsl:value-of select="$char"/>
									</fo:block>
								</fo:block-container>
							</fo:inline-container>
							<xsl:if test="namespace-uri(ancestor::mn:fmt-title) != '' and ($char_next != '' or ../following-sibling::node())">
								<fo:inline padding-left="1mm"><xsl:value-of select="$zero_width_space"/></fo:inline>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
					
					<xsl:if test="$add_zero_width_space = 'true' and ($char = ',' or $char = '.' or $char = ' ' or $char = '·' or $char = ')' or $char = ']' or $char = '}' or $char = '/')"><xsl:value-of select="$zero_width_space"/></xsl:if>
						<!-- <xsl:if test="$horizontal_mode = 'false'"> -->
							<xsl:call-template name="insertVerticalChar">
								<xsl:with-param name="str" select="substring($str, 2)"/>
								<xsl:with-param name="char_prev" select="$char"/>
								<xsl:with-param name="writing-mode" select="$writing-mode"/>
								<xsl:with-param name="reference-orientation" select="$reference-orientation"/>
								<xsl:with-param name="add_zero_width_space" select="$add_zero_width_space"/>
							</xsl:call-template>
						<!-- </xsl:if> -->
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="insertHorizontalChars">
		<xsl:param name="str"/>
		<xsl:param name="writing-mode">lr-tb</xsl:param>
		<xsl:param name="reference-orientation">90</xsl:param>
		<xsl:param name="add_zero_width_space">false</xsl:param>
		<fo:inline-container text-align="center"
								 alignment-baseline="central" width="1em" margin="0" padding="0"
								 text-indent="0mm" last-line-end-indent="0mm" start-indent="0mm" end-indent="0mm" role="SKIP">
			<xsl:if test="normalize-space($writing-mode) != ''">
				<xsl:attribute name="writing-mode"><xsl:value-of select="$writing-mode"/></xsl:attribute>
				<xsl:attribute name="reference-orientation">90</xsl:attribute>
			</xsl:if>
			<fo:block-container width="1em" role="SKIP"> <!-- border="0.5pt solid green" -->
				<fo:block line-height="1em" role="SKIP">
					<xsl:value-of select="$str"/>
				</fo:block>
			</fo:block-container>
		</fo:inline-container>
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
 
	<xsl:template name="getCharByCodePoint">
		<xsl:param name="codepoint"/>
		<xsl:param name="radix">16</xsl:param>
		<xsl:variable name="codepointInt" select="java:java.lang.Integer.parseInt($codepoint,$radix)"/>
		<xsl:variable name="chars" select="java:java.lang.Character.toChars($codepointInt)"/>
		<xsl:value-of select="java:java.lang.String.new($chars)"/>
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
 
	<!-- ============================================= -->
	<!--  mode="print_as_xml", for debug purposes -->
	<!-- ============================================= -->
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
	<!-- ============================================= -->
	<!-- END: mode="print_as_xml", for debug purposes -->
	<!-- ============================================= -->
	
	<!-- ============================================= -->
	<!-- mode="set_table_role_skip" -->
	<!-- ============================================= -->
	<xsl:template match="@*|node()" mode="set_table_role_skip">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="set_table_role_skip"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="*[starts-with(local-name(), 'table')]" mode="set_table_role_skip">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="set_table_role_skip"/>
			<xsl:attribute name="role">SKIP</xsl:attribute>
			<xsl:apply-templates select="node()" mode="set_table_role_skip"/>
		</xsl:copy>
	</xsl:template>
	<!-- ============================================= -->
	<!-- END: mode="set_table_role_skip" -->
	<!-- ============================================= -->
	
</xsl:stylesheet>
