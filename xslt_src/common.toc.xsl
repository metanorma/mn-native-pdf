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
	
	<xsl:template name="processPrefaceSectionsDefault_Contents">
		<xsl:variable name="nodes_preface_">
			<xsl:for-each select="/*/mn:preface/*[not(self::mn:note or self::mn:admonition or @type = 'toc')]">
				<node id="{@id}"/>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="nodes_preface" select="xalan:nodeset($nodes_preface_)"/>
		
		<xsl:for-each select="/*/mn:preface/*[not(self::mn:note or self::mn:admonition or @type = 'toc')]">
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
			<xsl:for-each select="/*/mn:sections/*">
				<node id="{@id}"/>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="nodes_sections" select="xalan:nodeset($nodes_sections_)"/>
		
		<xsl:for-each select="/*/mn:sections/* | /*/mn:bibliography/mn:references[@normative='true'] |
			/*/mn:bibliography/mn:clause[mn:references[@normative='true']]">
			<xsl:sort select="@displayorder" data-type="number"/>
			
			<!-- process Section's title -->
			<xsl:variable name="preceding-sibling_id" select="$nodes_sections/node[@id = current()/@id]/preceding-sibling::node[1]/@id"/>
			<xsl:if test="$preceding-sibling_id != ''">
				<xsl:apply-templates select="parent::*/*[@type = 'section-title' and @id = $preceding-sibling_id and not(@displayorder)]" mode="contents_no_displayorder"/>
			</xsl:if>
			
			<xsl:apply-templates select="." mode="contents"/>
		</xsl:for-each>
		
		<!-- <xsl:for-each select="/*/mn:annex">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:apply-templates select="." mode="contents"/>
		</xsl:for-each> -->
		
		<xsl:for-each select="/*/mn:annex | /*/mn:bibliography/*[not(@normative='true') and not(mn:references[@normative='true'])][count(.//mn:bibitem[not(@hidden) = 'true']) &gt; 0] | 
								/*/mn:bibliography/mn:clause[mn:references[not(@normative='true')]][count(.//mn:bibitem[not(@hidden) = 'true']) &gt; 0]">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:apply-templates select="." mode="contents"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="processTablesFigures_Contents">
		<xsl:param name="always"/>
		<xsl:if test="(//mn:metanorma/mn:metanorma-extension/mn:toc[@type='table']/mn:title) or normalize-space($always) = 'true'">
			<xsl:call-template name="processTables_Contents"/>
		</xsl:if>
		<xsl:if test="(//mn:metanorma/mn:metanorma-extension/mn:toc[@type='figure']/mn:title) or normalize-space($always) = 'true'">
			<xsl:call-template name="processFigures_Contents"/>
		</xsl:if>
	</xsl:template>

	<xsl:template name="processTables_Contents">
		<mnx:tables>
			<xsl:for-each select="//mn:table[not(ancestor::mn:metanorma-extension)][@id and mn:name and normalize-space(@id) != '']">
				<xsl:choose>
					<xsl:when test="mn:fmt-name">
						<xsl:variable name="fmt_name">
							<xsl:apply-templates select="mn:fmt-name" mode="update_xml_step1"/>
						</xsl:variable>
						<mnx:table id="{@id}" alt-text="{normalize-space($fmt_name)}">
							<xsl:copy-of select="$fmt_name"/>
						</mnx:table>
					</xsl:when>
					<xsl:otherwise>
						<mnx:table id="{@id}" alt-text="{mn:name}">
							<xsl:copy-of select="mn:name"/>
						</mnx:table>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</mnx:tables>
	</xsl:template>
	
	<xsl:template name="processFigures_Contents">
		<mnx:figures>
			<xsl:for-each select="//mn:figure[@id and mn:name and not(@unnumbered = 'true') and normalize-space(@id) != ''] | //*[@id and starts-with(mn:name, 'Figure ') and normalize-space(@id) != '']">
				<xsl:choose>
					<xsl:when test="mn:fmt-name">
						<xsl:variable name="fmt_name">
							<xsl:apply-templates select="mn:fmt-name" mode="update_xml_step1"/>
						</xsl:variable>
						<mnx:figure id="{@id}" alt-text="{normalize-space($fmt_name)}">
							<xsl:copy-of select="$fmt_name"/>
						</mnx:figure>
					</xsl:when>
					<xsl:otherwise>
						<mnx:figure id="{@id}" alt-text="{mn:name}">
							<xsl:copy-of select="mn:name"/>
						</mnx:figure>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</mnx:figures>
	</xsl:template>



	
	<xsl:template match="mn:figure/mn:name | mnx:figure/mn:name | 
														mn:table/mn:name | mnx:table/mn:name |
														mn:permission/mn:name | mnx:permission/mn:name |
														mn:recommendation/mn:name | mnx:recommendation/mn:name |
														mn:requirement/mn:name | mnx:requirement/mn:name" mode="contents">		
		<xsl:if test="not(following-sibling::*[1][self::mn:fmt-name])">
			<xsl:apply-templates mode="contents"/>
			<xsl:text> </xsl:text>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="mn:title[following-sibling::*[1][self::mn:fmt-title]]" mode="contents"/>
	
	<xsl:template match="mn:figure/mn:fmt-name | 
														mn:table/mn:fmt-name |
														mn:permission/mn:fmt-name |
														mn:recommendation/mn:fmt-name |
														mn:requirement/mn:fmt-name" mode="contents">		
		<xsl:apply-templates mode="contents"/>
		<xsl:text> </xsl:text>
	</xsl:template>
	
	<xsl:template match="mn:figure/mn:name | mnx:figure/mn:name | 
														mn:table/mn:name | mnx:table/mn:name |
														mn:permission/mn:name | mnx:permission/mn:name |
														mn:recommendation/mn:name | mnx:recommendation/mn:name |
														mn:requirement/mn:name | mnx:requirement/mn:name |
														mn:sourcecode/mn:name" mode="bookmarks">
		<xsl:if test="not(following-sibling::*[1][self::mn:fmt-name])">
			<xsl:apply-templates mode="bookmarks"/>
			<xsl:text> </xsl:text>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="mn:figure/mn:fmt-name | 
														mn:table/mn:fmt-name |
														mn:permission/mn:fmt-name |
														mn:recommendation/mn:fmt-name |
														mn:requirement/mn:fmt-name |
														mn:sourcecode/mn:fmt-name" mode="bookmarks">		
		<xsl:apply-templates mode="bookmarks"/>
		<xsl:text> </xsl:text>
	</xsl:template>
	
	<xsl:template match="*[self::mn:figure or self::mn:table or self::mn:permission or self::mn:recommendation or self::mn:requirement]/mn:name/text() |
			*[self::mnx:figure or self::mnx:table or self::mnx:permission or self::mnx:recommendation or self::mnx:requirement]/mn:name/text()" mode="contents" priority="2">
		<xsl:if test="not(../following-sibling::*[1][self::mn:fmt-name])">
			<xsl:value-of select="."/>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="*[self::mn:figure or self::mn:table or self::mn:permission or self::mn:recommendation or self::mn:requirement]/mn:fmt-name/text()" mode="contents" priority="2">
		<xsl:value-of select="."/>
	</xsl:template>
	
	<xsl:template match="*[self::mn:figure or self::mn:table or self::mn:permission or self::mn:recommendation or self::mn:requirement or self::mn:sourcecode]/mn:name//text() |
			*[self::mnx:figure or self::mnx:table or self::mnx:permission or self::mnx:recommendation or self::mnx:requirement or self::mnx:sourcecode]/mn:name//text()" mode="bookmarks" priority="2">
		<xsl:if test="not(../following-sibling::*[1][self::mn:fmt-name])">
			<xsl:value-of select="."/>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="*[self::mn:figure or self::mn:table or self::mn:permission or self::mn:recommendation or self::mn:requirement or self::mn:sourcecode]/mn:fmt-name//text()" mode="bookmarks" priority="2">
		<xsl:value-of select="."/>
	</xsl:template>
	
	<xsl:template match="mn:add/text()" mode="bookmarks" priority="3"> <!-- mn:add[starts-with(., $ace_tag)] -->
		<xsl:choose>
			<xsl:when test="starts-with(normalize-space(..), $ace_tag)"><!-- skip --></xsl:when>
			<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="node()" mode="contents">
		<xsl:apply-templates mode="contents"/>
	</xsl:template>

	<!-- special case: ignore preface/section-title and sections/section-title without @displayorder  -->
	<xsl:template match="*[self::mn:preface or self::mn:sections]/mn:p[@type = 'section-title' and not(@displayorder)]" priority="3" mode="contents"/>
	<!-- process them by demand (mode="contents_no_displayorder") -->
	<xsl:template match="mn:p[@type = 'section-title' and not(@displayorder)]" mode="contents_no_displayorder">
		<xsl:call-template name="contents_section-title"/>
	</xsl:template>
	<xsl:template match="mn:p[@type = 'section-title']" mode="contents_in_clause">
		<xsl:call-template name="contents_section-title"/>
	</xsl:template>
	
	<!-- special case: ignore section-title if @depth different than @depth of parent clause, or @depth of parent clause = 1 -->
	<xsl:template match="mn:clause/mn:p[@type = 'section-title' and (@depth != ../*[self::mn:title or self::mn:fmt-title]/@depth or ../*[self::mn:title or self::mn:fmt-title]/@depth = 1)]" priority="3" mode="contents"/>
	
	<xsl:template match="mn:p[@type = 'floating-title' or @type = 'section-title']" priority="2" name="contents_section-title" mode="contents">
		<xsl:variable name="level">
			<xsl:call-template name="getLevel">
				<xsl:with-param name="depth" select="@depth"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="section">
			<xsl:choose>
				<xsl:when test="@type = 'section-title'"></xsl:when>
				<xsl:when test="mn:span[@class = 'fmt-caption-delim']">
					<xsl:value-of select="mn:span[@class = 'fmt-caption-delim'][1]/preceding-sibling::node()"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="mn:tab[1]/preceding-sibling::node()"/>
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
					<!-- https://github.com/metanorma/mn-native-pdf/issues/770 -->
					<xsl:when test="mn:span[@class = 'fmt-caption-delim']">
						<xsl:choose>
							<xsl:when test="@type = 'section-title'">
								<xsl:value-of select="mn:span[@class = 'fmt-caption-delim'][1]/preceding-sibling::node()"/>
								<xsl:text>: </xsl:text>
								<xsl:copy-of select="mn:span[@class = 'fmt-caption-delim'][1]/following-sibling::node()[not(self::mn:fmt-xref-label)]"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:copy-of select="mn:span[@class = 'fmt-caption-delim'][1]/following-sibling::node()[not(self::mn:fmt-xref-label)]"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="mn:tab">
						<xsl:choose>
							<xsl:when test="@type = 'section-title'">
								<xsl:value-of select="mn:tab[1]/preceding-sibling::node()"/>
								<xsl:text>: </xsl:text>
								<xsl:copy-of select="mn:tab[1]/following-sibling::node()"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:copy-of select="mn:tab[1]/following-sibling::node()"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select="node()"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<xsl:variable name="root">
				<xsl:if test="ancestor-or-self::mn:preface">preface</xsl:if>
				<xsl:if test="ancestor-or-self::mn:annex">annex</xsl:if>
			</xsl:variable>
			
			<mnx:item id="{@id}" level="{$level}" section="{$section}" type="{$type}" root="{$root}" display="{$display}">
				<mnx:title>
					<xsl:apply-templates select="xalan:nodeset($title)" mode="contents_item"/>
				</mnx:title>
			</mnx:item>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="node()" mode="bookmarks">
		<xsl:apply-templates mode="bookmarks"/>
	</xsl:template>
	
	<xsl:template match="mn:stem" mode="contents"/>
	
	<xsl:template match="*[self::mn:title or self::mn:name or self::mn:fmt-title or self::mn:fmt-name]//mn:fmt-stem" mode="contents">
		<xsl:apply-templates select="."/>
	</xsl:template>
	
	<!-- prevent missing stem for table and figures in ToC -->
	<xsl:template match="*[self::mn:name or self::mn:fmt-name]//mn:stem" mode="contents">
		<xsl:if test="not(following-sibling::*[1][self::mn:fmt-stem])">
			<xsl:apply-templates select="."/>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="mn:references[@hidden='true']" mode="contents" priority="3"/>
	
	<xsl:template match="mn:references/mn:bibitem" mode="contents"/>
	
	<!-- Note: to enable the addition of character span markup with semantic styling for DIS Word output -->
	<xsl:template match="mn:span" mode="contents">
		<xsl:apply-templates mode="contents"/>
	</xsl:template>
	
	<xsl:template match="mn:semx" mode="contents">
		<xsl:apply-templates mode="contents"/>
	</xsl:template>
	
	<xsl:template match="mn:concept" mode="contents"/>
	<xsl:template match="mn:eref" mode="contents"/>
	<xsl:template match="mn:xref" mode="contents"/>
	<xsl:template match="mn:link" mode="contents"/>
	<xsl:template match="mn:origin" mode="contents"/>
	<xsl:template match="mn:erefstack" mode="contents"/>
	
	<xsl:template match="mn:requirement |
												mn:recommendation | 
												mn:permission" mode="contents" priority="3"/>
	
	<xsl:template match="mn:stem" mode="bookmarks"/>
	<xsl:template match="mn:fmt-stem" mode="bookmarks">
		<xsl:apply-templates mode="bookmarks"/>
	</xsl:template>
	
	<!-- Note: to enable the addition of character span markup with semantic styling for DIS Word output -->
	<xsl:template match="mn:span" mode="bookmarks">
		<xsl:apply-templates mode="bookmarks"/>
	</xsl:template>
	
	<xsl:template match="mn:semx" mode="bookmarks">
		<xsl:apply-templates mode="bookmarks"/>
	</xsl:template>
	
	<xsl:template match="mn:concept" mode="bookmarks"/>
	<xsl:template match="mn:eref" mode="bookmarks"/>
	<xsl:template match="mn:xref" mode="bookmarks"/>
	<xsl:template match="mn:link" mode="bookmarks"/>
	<xsl:template match="mn:origin" mode="bookmarks"/>
	<xsl:template match="mn:erefstack" mode="bookmarks"/>
	
	<xsl:template match="mn:requirement |
												mn:recommendation | 
												mn:permission" mode="bookmarks" priority="3"/>
	
	<!-- Bookmarks -->
	<xsl:template name="addBookmarks">
		<xsl:param name="contents"/>
		<xsl:param name="contents_addon"/>
		<xsl:variable name="contents_nodes" select="xalan:nodeset($contents)"/>
		<xsl:if test="$contents_nodes//mnx:item">
			<fo:bookmark-tree>
				<xsl:choose>
					<xsl:when test="$contents_nodes/mnx:doc">
						<xsl:choose>
							<xsl:when test="count($contents_nodes/mnx:doc) &gt; 1">
								
								<xsl:if test="$contents_nodes/collection">
									<fo:bookmark internal-destination="{$contents/collection/@firstpage_id}">
										<fo:bookmark-title>collection.pdf</fo:bookmark-title>
									</fo:bookmark>
								</xsl:if>
							
								<xsl:for-each select="$contents_nodes/mnx:doc">
									<fo:bookmark internal-destination="{contents/mnx:item[@display = 'true'][1]/@id}" starting-state="hide">
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
										
										<xsl:apply-templates select="contents/mnx:item" mode="bookmark"/>
										
										<xsl:call-template name="insertFigureBookmarks">
											<xsl:with-param name="contents" select="mnx:contents"/>
										</xsl:call-template>
										
										<xsl:call-template name="insertTableBookmarks">
											<xsl:with-param name="contents" select="mnx:contents"/>
											<xsl:with-param name="lang" select="@lang"/>
										</xsl:call-template>
										
									</fo:bookmark>
									
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<xsl:for-each select="$contents_nodes/mnx:doc">
								
									<xsl:apply-templates select="mnx:contents/mnx:item" mode="bookmark"/>
									
									<xsl:call-template name="insertFigureBookmarks">
										<xsl:with-param name="contents" select="mnx:contents"/>
									</xsl:call-template>
										
									<xsl:call-template name="insertTableBookmarks">
										<xsl:with-param name="contents" select="mnx:contents"/>
										<xsl:with-param name="lang" select="@lang"/>
									</xsl:call-template>
									
								</xsl:for-each>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="$contents_nodes/mnx:contents/mnx:item" mode="bookmark"/>				
						
						<xsl:call-template name="insertFigureBookmarks">
							<xsl:with-param name="contents" select="$contents_nodes/mnx:contents"/>
						</xsl:call-template>
							
						<xsl:call-template name="insertTableBookmarks">
							<xsl:with-param name="contents" select="$contents_nodes/mnx:contents"/>
							<xsl:with-param name="lang" select="@lang"/>
						</xsl:call-template>
						
					</xsl:otherwise>
				</xsl:choose>
				
				<!-- for $namespace = 'nist-sp' $namespace = 'ogc' $namespace = 'ogc-white-paper' -->
				<xsl:copy-of select="$contents_addon"/>
				
			</fo:bookmark-tree>
		</xsl:if>
	</xsl:template>
	
	
	<xsl:template name="insertFigureBookmarks">
		<xsl:param name="contents"/>
		<xsl:variable name="contents_nodes" select="xalan:nodeset($contents)"/>
		<xsl:if test="$contents_nodes/mnx:figure">
			<fo:bookmark internal-destination="{$contents_nodes/mnx:figure[1]/@id}" starting-state="hide">
				<fo:bookmark-title>Figures</fo:bookmark-title>
				<xsl:for-each select="$contents_nodes/mnx:figure">
					<fo:bookmark internal-destination="{@id}">
						<fo:bookmark-title>
							<xsl:value-of select="normalize-space(mnx:title)"/>
						</fo:bookmark-title>
					</fo:bookmark>
				</xsl:for-each>
			</fo:bookmark>	
		</xsl:if>
		
		<xsl:choose>
			<xsl:when test="$namespace = 'nist-sp' or $namespace = 'ogc' or $namespace = 'ogc-white-paper'"><!-- see template addBookmarks --></xsl:when>
			<xsl:otherwise>
				<xsl:if test="$contents_nodes//mnx:figures/mnx:figure">
					<fo:bookmark internal-destination="empty_bookmark" starting-state="hide">
					
						<xsl:if test="$namespace = 'iec'">
							<xsl:attribute name="internal-destination">
								<xsl:value-of select="$contents_nodes//mnx:figures/mnx:figure[1]/@id"/>
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
						<xsl:for-each select="$contents_nodes//mnx:figures/mnx:figure">
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
		<xsl:if test="$contents_nodes/mnx:table">
			<fo:bookmark internal-destination="{$contents_nodes/mnx:table[1]/@id}" starting-state="hide">
				<fo:bookmark-title>
					<xsl:choose>
						<xsl:when test="$lang = 'fr'">Tableaux</xsl:when>
						<xsl:otherwise>Tables</xsl:otherwise>
					</xsl:choose>
				</fo:bookmark-title>
				<xsl:for-each select="$contents_nodes/mnx:table">
					<fo:bookmark internal-destination="{@id}">
						<fo:bookmark-title>
							<xsl:value-of select="normalize-space(mnx:title)"/>
						</fo:bookmark-title>
					</fo:bookmark>
				</xsl:for-each>
			</fo:bookmark>	
		</xsl:if>
		
		<xsl:choose>
			<xsl:when test="$namespace = 'nist-sp' or $namespace = 'ogc' or $namespace = 'ogc-white-paper'"><!-- see template addBookmarks --></xsl:when>
			<xsl:otherwise>
				<xsl:if test="$contents_nodes//mnx:tables/mnx:table">
					<fo:bookmark internal-destination="empty_bookmark" starting-state="hide">
						
						<xsl:if test="$namespace = 'iec'">
							<xsl:attribute name="internal-destination">
								<xsl:value-of select="$contents_nodes//mnx:tables/mnx:table[1]/@id"/>
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
						
						<xsl:for-each select="$contents_nodes//mnx:tables/mnx:table">
							<fo:bookmark internal-destination="{@id}">
								<!-- <fo:bookmark-title><xsl:value-of select="normalize-space(.)"/></fo:bookmark-title> -->
								<fo:bookmark-title><xsl:apply-templates mode="bookmark_clean"/></fo:bookmark-title>
							</fo:bookmark>
						</xsl:for-each>
					</fo:bookmark>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- insertTableBookmarks -->
	<!-- End Bookmarks -->
	
	<!-- ============================ -->
	<!-- mode="bookmark_clean" -->
	<!-- ============================ -->
	<xsl:template match="node()" mode="bookmark_clean">
		<xsl:apply-templates select="node()" mode="bookmark_clean"/>
	</xsl:template>
	
	<xsl:template match="text()" mode="bookmark_clean">
		<xsl:value-of select="."/>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'math']" mode="bookmark_clean">
		<xsl:value-of select="normalize-space(.)"/>
	</xsl:template>
	
	<xsl:template match="mn:asciimath" mode="bookmark_clean"/>
	<!-- ============================ -->
	<!-- END: mode="bookmark_clean" -->
	<!-- ============================ -->
	

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
	
	<xsl:template match="mnx:item" mode="bookmark">
		<xsl:choose>
			<xsl:when test="@id != ''">
				<fo:bookmark internal-destination="{@id}" starting-state="hide">
					<fo:bookmark-title>
						<xsl:if test="@section != ''">
							<xsl:value-of select="@section"/> 
							<xsl:text> </xsl:text>
						</xsl:if>
						<xsl:variable name="title">
							<xsl:for-each select="mnx:title/node()">
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
	
	<xsl:template match="mnx:title" mode="bookmark"/>	
	<xsl:template match="text()" mode="bookmark"/>
	

	<!-- ====== -->
	<!-- ====== -->
	<xsl:template match="mn:title" mode="contents_item">
		<xsl:param name="mode">bookmarks</xsl:param>
		<xsl:if test="not(following-sibling::*[1][self::mn:fmt-title])">
			<xsl:apply-templates mode="contents_item">
				<xsl:with-param name="mode" select="$mode"/>
			</xsl:apply-templates>
			<!-- <xsl:text> </xsl:text> -->
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="mn:fmt-title" mode="contents_item">
		<xsl:param name="mode">bookmarks</xsl:param>
		<xsl:apply-templates mode="contents_item">
			<xsl:with-param name="mode" select="$mode"/>
		</xsl:apply-templates>
		<!-- <xsl:text> </xsl:text> -->
	</xsl:template>
	
	<xsl:template match="mn:span[
															@class = 'fmt-caption-label' or 
															@class = 'fmt-element-name' or
															@class = 'fmt-caption-delim']" mode="contents_item" priority="3">
		<xsl:apply-templates mode="contents_item"/>
	</xsl:template>
	
	<xsl:template match="mn:semx" mode="contents_item">
		<xsl:apply-templates mode="contents_item"/>
	</xsl:template>
	
	
	<xsl:template match="mn:fmt-xref-label"  mode="contents_item"/>
	
	<xsl:template match="mn:concept"  mode="contents_item"/>
	<xsl:template match="mn:eref" mode="contents_item"/>
	<xsl:template match="mn:xref" mode="contents_item"/>
	<xsl:template match="mn:link" mode="contents_item"/>
	<xsl:template match="mn:origin" mode="contents_item"/>
	<xsl:template match="mn:erefstack" mode="contents_item"/>

</xsl:stylesheet>