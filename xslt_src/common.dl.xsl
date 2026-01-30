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
	<!-- Definition's list styles -->
	<!-- ========================== -->
	
	<xsl:attribute-set name="dl-block-style">
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'plateau'">
			<xsl:attribute name="margin-bottom">16pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:template name="refine_dl-block-style">
		<xsl:if test="(@key = 'true' or ancestor::mn:key) and ancestor::mn:figure">
			<xsl:attribute name="keep-together.within-column">always</xsl:attribute>
		</xsl:if>
	</xsl:template>
	
	<xsl:attribute-set name="dt-row-style">
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="min-height">8.5mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="min-height">7mm</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:template name="refine_dt-row-style">
		<xsl:if test="$namespace = 'ogc'">
			<xsl:if test="not(following-sibling::mn:dt) or ancestor::mn:sourcecode"> <!-- last item -->
				<xsl:attribute name="min-height">3mm</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	
	<xsl:attribute-set name="dt-cell-style">
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="padding-top">0.5mm</xsl:attribute>
			<xsl:attribute name="padding-right">5mm</xsl:attribute>
			<xsl:attribute name="padding-left">1mm</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:template name="refine_dt-cell-style">
		<xsl:if test="$namespace = 'itu'">
			<xsl:if test="ancestor::*[1][self::mn:dl]/preceding-sibling::*[1][self::mn:formula]">						
				<xsl:attribute name="padding-right">3mm</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:if test="not(ancestor::mn:sourcecode)">
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
		<xsl:if test="$namespace = 'iso'">
			<xsl:if test="$layoutVersion = '2024'">
				<xsl:attribute name="margin-bottom">9pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:if test="ancestor::*[1][self::mn:dl]/preceding-sibling::*[1][self::mn:formula]">
				<xsl:attribute name="text-align">right</xsl:attribute>							
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:if test="ancestor::mn:sourcecode">
				<xsl:attribute name="margin-bottom">2pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="not(following-sibling::mn:dt)"> <!-- last dt -->
				<xsl:attribute name="margin-bottom">0</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template> <!-- refine_dt-block-style -->

	
	<xsl:attribute-set name="dl-name-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
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
	</xsl:attribute-set> <!-- dl-name-style -->
	
	<xsl:template name="refine_dl-name-style">
		<xsl:if test="$namespace = 'plateau'">
			<xsl:if test="ancestor::mn:tfoot and (../@key = 'true' or ancestor::mn:key)">
				<xsl:attribute name="margin-left">-<xsl:value-of select="$tableAnnotationIndent"/></xsl:attribute>
				<xsl:attribute name="margin-bottom">2pt</xsl:attribute>
				<xsl:attribute name="font-weight">bold</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	
	<xsl:attribute-set name="dd-cell-style">
		<xsl:attribute name="padding-left">2mm</xsl:attribute>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="padding-top">0.5mm</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:template name="refine_dd-cell-style">
		<xsl:if test="$namespace = 'ogc'">
			<xsl:if test="not(ancestor::mn:sourcecode)">
				<xsl:attribute name="background-color"><xsl:value-of select="$color_dl_dd"/></xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template> <!-- refine_dd-cell-style -->

	
	<!-- ========================== -->
	<!-- END Definition's list styles -->
	<!-- ========================== -->
	
	<!-- ===================== -->
	<!-- Definition List -->
	<!-- ===================== -->
	
	<xsl:if test="$namespace = 'itu'">
	<!-- convert table[@class = 'dl'] to dl with colgroup/col/@colwidth -->
	<xsl:template match="mn:table[@class = 'dl' and count(.//mn:tr[1]/*) = 2]" priority="4">
		<xsl:variable name="dl">
			<xsl:element name="dl" namespace="{$namespace_full}">
				<xsl:copy-of select="@*"/>
				<xsl:element name="colgroup" namespace="{$namespace_full}">
					<xsl:for-each select=".//mn:tr[1]/*">
						<xsl:element name="col" namespace="{$namespace_full}">
							<xsl:attribute name="width"><xsl:value-of select="@width"/></xsl:attribute>
						</xsl:element>
					</xsl:for-each>
				</xsl:element>
				<xsl:apply-templates mode="table_to_dl"/>
			</xsl:element>
		</xsl:variable>
		<xsl:apply-templates select="xalan:nodeset($dl)/node()"/>
	</xsl:template>
	<xsl:template match="@*|node()" mode="table_to_dl">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="table_to_dl"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="*[local-name() = 'tbody']" mode="table_to_dl">
		<xsl:apply-templates mode="table_to_dl"/>
	</xsl:template>
	<xsl:template match="*[local-name() = 'tr']" mode="table_to_dl">
		<xsl:element name="dt" namespace="{$namespace_full}">
			<xsl:apply-templates select="*[1]/node()" mode="table_to_dl"/>
		</xsl:element>
		<xsl:element name="dd" namespace="{$namespace_full}">
			<xsl:apply-templates select="*[2]/node()" mode="table_to_dl"/>
		</xsl:element>
	</xsl:template>
	</xsl:if>
	
	<!-- for table auto-layout algorithm -->
	<xsl:template match="mn:dl" priority="2">
		<xsl:choose>
			<xsl:when test="$table_only_with_id != '' and @id = $table_only_with_id">
				<xsl:call-template name="dl"/>
			</xsl:when>
			<xsl:when test="$table_only_with_id != ''"><fo:block/><!-- to prevent empty fo:block-container --></xsl:when>
			<xsl:when test="$table_only_with_ids != '' and contains($table_only_with_ids, concat(@id, ' '))">
				<xsl:call-template name="dl"/>
			</xsl:when>
			<xsl:when test="$table_only_with_ids != ''"><fo:block/><!-- to prevent empty fo:block-container --></xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="dl"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- dl -->
	
	<xsl:template match="mn:dl" name="dl">
		<xsl:variable name="isAdded" select="@added"/>
		<xsl:variable name="isDeleted" select="@deleted"/>
		<!-- <dl><xsl:copy-of select="."/></dl> -->
		<fo:block-container xsl:use-attribute-sets="dl-block-style" role="SKIP">
		
			<xsl:call-template name="refine_dl-block-style"/>
			
			<xsl:call-template name="setBlockSpanAll"/>
		
			<xsl:choose>
				<xsl:when test="$namespace = 'bipm'">
					<xsl:if test="not(ancestor::mn:li)">
						<xsl:attribute name="margin-left">0mm</xsl:attribute>
					</xsl:if>
					<xsl:if test="ancestor::mn:li">
						<xsl:attribute name="margin-left">6.5mm</xsl:attribute><!-- 8 mm -->
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="not(ancestor::mn:quote)">
						<xsl:attribute name="margin-left">0mm</xsl:attribute>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
			
			<xsl:if test="$namespace = 'bsi' or $namespace = 'pas'">
				<xsl:attribute name="font-size">9pt</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="$namespace = 'plateau'">
				<xsl:if test="(@key = 'true' or ancestor::mn:key) and (ancestor::mn:tfoot or parent::mn:figure)">
					<xsl:attribute name="margin-left"><xsl:value-of select="$tableAnnotationIndent"/></xsl:attribute>
					<xsl:attribute name="margin-bottom">0</xsl:attribute>
				</xsl:if>
			</xsl:if>
			
			<xsl:if test="ancestor::mn:sourcecode">
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
			
			<xsl:if test="parent::mn:note">
				<xsl:attribute name="margin-left">
					<xsl:choose>
						<xsl:when test="not(ancestor::mn:table)"><xsl:value-of select="$note-body-indent"/></xsl:when>
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
					<xsl:if test="$namespace = 'bsi' or $namespace = 'pas' or $namespace = 'iso' or $namespace = 'iec'  or $namespace = 'gb' or $namespace = 'jcgm'">
						<xsl:if test="$parent = 'figure' or $parent = 'formula' or ../@key = 'true' or ancestor::mn:key">true</xsl:if>
					</xsl:if> <!-- and  (not(../@class) or ../@class !='pseudocode') -->
				</xsl:variable>
				
				<xsl:variable name="onlyOneComponent" select="normalize-space($parent = 'formula' and count(mn:dt) = 1)"/>
				
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
									<xsl:apply-templates select="preceding-sibling::*[1][self::mn:p and @keep-with-next = 'true']/node()"/>
								</fo:block>
								<fo:block>
									<xsl:if test="$namespace = 'gb'">
										<xsl:attribute name="text-indent">7.4mm</xsl:attribute>
									</xsl:if>
									<xsl:apply-templates select="mn:dt/*"/>
									<xsl:if test="$namespace = 'gb'">—</xsl:if>
									<xsl:text> </xsl:text>
									<xsl:apply-templates select="mn:dd/node()" mode="inline"/>
								</fo:block>
							</xsl:when>
							<xsl:otherwise>
								<fo:block margin-bottom="12pt" text-align="left">
									<xsl:if test="$namespace = 'bsi' or $namespace = 'pas' or $namespace = 'iso' or $namespace = 'iec' or $namespace = 'jcgm'">
										<xsl:attribute name="margin-bottom">0</xsl:attribute>
									</xsl:if>
									<!-- <xsl:variable name="title-where">
										<xsl:call-template name="getLocalizedString">
											<xsl:with-param name="key">where</xsl:with-param>
										</xsl:call-template>
									</xsl:variable>
									<xsl:value-of select="$title-where"/> -->
									<xsl:apply-templates select="preceding-sibling::*[1][self::mn:p and @keep-with-next = 'true']/node()"/>
									<xsl:text>&#xA0;</xsl:text>
									<xsl:apply-templates select="mn:dt/*"/>
									<xsl:if test="mn:dd/node()[normalize-space() != ''][1][self::text()]">
										<xsl:text> </xsl:text>
									</xsl:if>
									<xsl:apply-templates select="mn:dd/node()" mode="inline"/>
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
							<xsl:apply-templates select="preceding-sibling::*[1][self::mn:p and @keep-with-next = 'true']/node()"/>
						</fo:block>
					</xsl:when>  <!-- END: a few components -->
					<xsl:when test="$parent = 'figure' and  (not(../@class) or ../@class !='pseudocode')"> <!-- definition list in a figure -->
						<!-- Presentation XML contains 'Key' caption, https://github.com/metanorma/isodoc/issues/607 -->
						<xsl:if test="not(preceding-sibling::*[1][self::mn:p and @keep-with-next])"> <!-- for old Presentation XML -->
						
							<xsl:choose>
								<xsl:when test="$namespace = 'bsi' or $namespace = 'pas'"></xsl:when><!-- https://github.com/metanorma/isodoc/issues/607, see template<xsl:template
								match="mn:figure/mn:p[preceding-sibling::mn:p[@keep-with-next = 'true']][node()[1][self::mn:sup]]" priority="5"> -->
								<xsl:otherwise>						
									<fo:block font-weight="bold" text-align="left" margin-bottom="12pt" keep-with-next="always">
									
										<xsl:call-template name="refine_figure_key_style"/>
									
										<xsl:variable name="title-key">
											<xsl:call-template name="getLocalizedString">
												<xsl:with-param name="key">key</xsl:with-param>
											</xsl:call-template>
										</xsl:variable>
										<xsl:value-of select="$title-key"/>
									</fo:block>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:if>
					</xsl:when>  <!-- END: definition list in a figure -->
				</xsl:choose>
				
				<!-- a few components -->
				<xsl:if test="$onlyOneComponent = 'false'">
					<fo:block role="SKIP">
					
						<xsl:call-template name="refine_multicomponent_style"/>
						
						<xsl:if test="ancestor::*[self::mn:dd or self::mn:td]">
							<xsl:attribute name="margin-top">0</xsl:attribute>
						</xsl:if>
						
						<fo:block role="SKIP">
						
							<xsl:call-template name="refine_multicomponent_block_style"/>
							
							<xsl:apply-templates select="mn:fmt-name">
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
											<xsl:attribute name="font-size">9pt</xsl:attribute>
										</xsl:if>
										<xsl:if test="$namespace = 'pas'">
											<xsl:if test="parent::mn:figure">
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
											<!-- initial='<xsl:copy-of select="."/>' -->
											<xsl:variable name="dl_table">
												<mn:tbody>
													<xsl:apply-templates mode="dl_if">
														<xsl:with-param name="id" select="@id"/>
													</xsl:apply-templates>
												</mn:tbody>
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
												<mn:tbody>
													<xsl:apply-templates mode="dl">
														<xsl:with-param name="id" select="@id"/>
													</xsl:apply-templates>
												</mn:tbody>
											</xsl:variable>
											
											<xsl:copy-of select="$dl_table"/>
										</xsl:variable>
								
										<xsl:variable name="colwidths">
											<xsl:choose>
												<!-- dl from table[@class='dl'] -->
												<xsl:when test="mn:colgroup">
													<autolayout/>
													<xsl:for-each select="mn:colgroup/mn:col">
														<column><xsl:value-of select="translate(@width,'%m','')"/></column>
													</xsl:for-each>
												</xsl:when>
												<xsl:otherwise>
													<xsl:call-template name="calculate-column-widths">
														<xsl:with-param name="cols-count" select="2"/>
														<xsl:with-param name="table" select="$simple-table"/>
													</xsl:call-template>
												</xsl:otherwise>
											</xsl:choose>
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
										
										
										<xsl:choose>
											<xsl:when test="$namespace = 'plateau'">
												<xsl:choose>
													<!-- https://github.com/metanorma/metanorma-plateau/issues/171 -->
													<xsl:when test="(@key = 'true' or ancestor::mn:key) and (ancestor::mn:tfoot or parent::mn:figure)"> <!--  and not(xalan:nodeset($colwidths)//column) -->
														<xsl:variable name="dt_nodes">
															<xsl:for-each select="mn:dt">
																<xsl:apply-templates select="." mode="dt_clean"/>
															</xsl:for-each>
														</xsl:variable>
														<!-- <xsl:copy-of select="$dt_nodes"/> -->
														<xsl:variable name="dt_length_max">
															<xsl:for-each select="xalan:nodeset($dt_nodes)//mn:dt">
																<xsl:sort select="string-length(normalize-space())" data-type="number" order="descending"/>
																<xsl:if test="position() = 1"><xsl:value-of select="string-length(normalize-space())"/></xsl:if>
															</xsl:for-each>
														</xsl:variable>
														<xsl:variable name="col1_percent_" select="number($dt_length_max) + 1"/>
														<xsl:variable name="col1_percent">
															<xsl:choose>
																<xsl:when test="$col1_percent_ &gt; 50">50</xsl:when>
																<xsl:otherwise><xsl:value-of select="$col1_percent_"/></xsl:otherwise>
															</xsl:choose>
														</xsl:variable>
														<fo:table-column column-width="{$col1_percent}%"/>
														<fo:table-column column-width="{100 - $col1_percent}%"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:call-template name="setColumnWidth_dl">
															<xsl:with-param name="colwidths" select="$colwidths"/>							
															<xsl:with-param name="maxlength_dt" select="$maxlength_dt"/>
															<xsl:with-param name="isContainsKeepTogetherTag" select="$isContainsKeepTogetherTag"/>
														</xsl:call-template>
													</xsl:otherwise>
												</xsl:choose>
												<!-- $namespace = 'plateau' -->
											</xsl:when>
											<xsl:otherwise>
												<xsl:call-template name="setColumnWidth_dl">
													<xsl:with-param name="colwidths" select="$colwidths"/>							
													<xsl:with-param name="maxlength_dt" select="$maxlength_dt"/>
													<xsl:with-param name="isContainsKeepTogetherTag" select="$isContainsKeepTogetherTag"/>
												</xsl:call-template>
											</xsl:otherwise>
										</xsl:choose>
										
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
			<xsl:apply-templates select="mn:dd/mn:dl"/>
		</xsl:if>
		
		<xsl:if test="$namespace = 'jis'">
			<!-- display footnotes after after upper-level `dl` -->
			<xsl:if test="not(ancestor::mn:dl)">
				<xsl:for-each select=".//mn:fn[generate-id(.)=generate-id(key('kfn',@reference)[1])]">
					<xsl:call-template name="fn_jis"/>
				</xsl:for-each>
			</xsl:if>
		</xsl:if>
		
	</xsl:template> <!-- END: dl -->
	
	<xsl:template match="@*|node()" mode="dt_clean">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="dt_clean"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="mn:asciimath" mode="dt_clean"/>
	
	<xsl:template name="refine_dl_formula_where_style">
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="margin-bottom">3pt</xsl:attribute>
			<xsl:attribute name="font-size">10pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'pas'">
			<xsl:attribute name="margin-bottom">3pt</xsl:attribute>
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
	
	<xsl:template name="refine_multicomponent_style">
		<xsl:variable name="parent" select="local-name(..)"/>
		<xsl:if test="$namespace = 'iso' or $namespace = 'jcgm'">
			<xsl:if test="$parent = 'formula'">
				<xsl:attribute name="margin-left">4mm</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bsi' or $namespace = 'pas'">
			<xsl:if test="$parent = 'formula'">
				<xsl:attribute name="margin-left">4mm</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="line-height">1.4</xsl:attribute>
			<xsl:if test="@key = 'true' or ancestor::mn:key">
				<xsl:attribute name="margin-top">2pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:if test="$parent = 'figure' or $parent = 'formula'">
				<xsl:attribute name="margin-left">7.4mm</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp'  or $namespace = 'nist-sp'">
			<xsl:if test="not(.//mn:dt//mn:fmt-stem)">
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
			<xsl:if test="$parent = 'formula'">
				<xsl:attribute name="margin-left">-1mm</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-cswp'  or $namespace = 'nist-sp'">
			<xsl:if test="not(.//mn:dt//mn:fmt-stem)">
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
	
	<!-- dl/name -->
	<xsl:template match="mn:dl/mn:fmt-name">
		<xsl:param name="process">false</xsl:param>
		<xsl:if test="$process = 'true'">
			<fo:block xsl:use-attribute-sets="dl-name-style">
			
				<xsl:call-template name="refine_dl-name-style"/>
				
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
			<!-- <xsl:when test="@class = 'formula_dl' and local-name(..) = 'figure'">
				<fo:table-column column-width="10%"/>
				<fo:table-column column-width="90%"/>
			</xsl:when> -->
			<xsl:when test="xalan:nodeset($colwidths)/autolayout">
				<xsl:call-template name="insertTableColumnWidth">
					<xsl:with-param name="colwidths" select="$colwidths"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="ancestor::mn:dl"><!-- second level, i.e. inlined table -->
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
			<xsl:for-each select="mn:dt">
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
	<xsl:template match="mn:dl/mn:note" priority="2">
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
					<xsl:apply-templates select="mn:name" />
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
	<xsl:template match="mn:dt" mode="dl">
		<xsl:param name="id"/>
		<xsl:variable name="row_number" select="count(preceding-sibling::mn:dt) + 1"/>
		<mn:tr>
			<mn:td>
				<xsl:attribute name="id">
					<xsl:value-of select="concat($id,'@',$row_number,'_1')"/>
				</xsl:attribute>
				<xsl:apply-templates />
			</mn:td>
			<mn:td>
				<xsl:attribute name="id">
					<xsl:value-of select="concat($id,'@',$row_number,'_2')"/>
				</xsl:attribute>
				<xsl:choose>
					<xsl:when test="$namespace = 'nist-cswp' or $namespace = 'nist-sp'">
						<xsl:if test="local-name(*[1]) != 'fmt-stem'">
							<xsl:apply-templates select="following-sibling::mn:dd[1]">
								<xsl:with-param name="process">true</xsl:with-param>
							</xsl:apply-templates>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="following-sibling::mn:dd[1]">
							<xsl:with-param name="process">true</xsl:with-param>
						</xsl:apply-templates>
					</xsl:otherwise>
				</xsl:choose>
			</mn:td>
		</mn:tr>
		<xsl:if test="$namespace = 'nist-cswp' or $namespace = 'nist-sp'">
			<xsl:if test="local-name(*[1]) = 'fmt-stem'">
				<mn:tr>
					<mn:td>
						<xsl:attribute name="id">
							<xsl:value-of select="concat($id,'@',$row_number,'_1_1')"/>
						</xsl:attribute>
						<xsl:text>&#xA0;</xsl:text>
					</mn:td>
					<mn:td>
						<xsl:attribute name="id">
							<xsl:value-of select="concat($id,'@',$row_number,'_2_2')"/>
						</xsl:attribute>
						<xsl:apply-templates select="following-sibling::mn:dd[1]" mode="dl_process"/>
					</mn:td>
				</mn:tr>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	
	<!-- Definition's term -->
	<xsl:template match="mn:dt">
		<xsl:param name="key_iso"/>
		<xsl:param name="split_keep-within-line"/>
		
		<fo:table-row xsl:use-attribute-sets="dt-row-style">
			<xsl:call-template name="refine_dt-row-style"/>
			
			<xsl:call-template name="insert_dt_cell">
				<xsl:with-param name="key_iso" select="$key_iso"/>
				<xsl:with-param name="split_keep-within-line" select="$split_keep-within-line"/>
			</xsl:call-template>
			<xsl:for-each select="following-sibling::mn:dd[1]">
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
			
			<xsl:call-template name="setNamedDestination"/>
			<fo:block xsl:use-attribute-sets="dt-block-style" role="SKIP">
			
				<xsl:choose>
					<xsl:when test="$isGenerateTableIF = 'true'">
						<xsl:choose>
						<xsl:when test="$namespace = 'jis'">
							<fo:inline>
								<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
								<xsl:value-of select="$hair_space"/>
							</fo:inline>
						</xsl:when>
						<xsl:otherwise>
							<xsl:copy-of select="@id"/>
						</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select="@id"/>
					</xsl:otherwise>
				</xsl:choose>
				
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
			
				<xsl:if test="$namespace = 'itu'">
					<xsl:attribute name="text-align">justify</xsl:attribute>
				</xsl:if>
				
				<xsl:choose>
					<xsl:when test="$isGenerateTableIF = 'true'">
						<xsl:apply-templates> <!-- following-sibling::mn:dd[1] -->
							<xsl:with-param name="process">true</xsl:with-param>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="."> <!-- following-sibling::mn:dd[1] -->
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
	
	<xsl:template match="mn:dd" mode="dl"/>
	<xsl:template match="mn:dd" mode="dl_process">
		<xsl:apply-templates />
	</xsl:template>
	
	<xsl:template match="mn:dd">
		<xsl:param name="process">false</xsl:param>
		<xsl:param name="split_keep-within-line"/>
		<xsl:if test="$process = 'true'">
			<xsl:apply-templates select="@language"/>
			<xsl:apply-templates>
				<xsl:with-param name="split_keep-within-line" select="$split_keep-within-line"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:dd/*" mode="inline">
		<xsl:variable name="is_inline_element_after_where">
			<xsl:if test="self::mn:p and not(preceding-sibling::node()[normalize-space() != ''])">true</xsl:if>
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
	
	<!-- =============================== -->
	<!-- mode="dl_if" -->
	<!-- =============================== -->
	<!-- virtual html table for dl/[dt and dd] for IF (Intermediate Format) -->
	<xsl:template match="mn:dt" mode="dl_if">
		<xsl:param name="id"/>
		<mn:tr>
			<mn:td>
				<xsl:copy-of select="node()"/>
			</mn:td>
			<mn:td>
				<!-- <xsl:copy-of select="following-sibling::mn:dd[1]/node()[not(local-name() = 'dl')]"/> -->
				<xsl:apply-templates select="following-sibling::mn:dd[1]/node()[not(local-name() = 'dl')]" mode="dl_if"/>
				<!-- get paragraphs from nested 'dl' -->
				<xsl:apply-templates select="following-sibling::mn:dd[1]/mn:dl" mode="dl_if_nested"/>
			</mn:td>
		</mn:tr>
	</xsl:template>
	<xsl:template match="mn:dd" mode="dl_if"/>
	
	<xsl:template match="*" mode="dl_if">
		<xsl:copy-of select="."/>
	</xsl:template>
	
	<xsl:template match="mn:p" mode="dl_if">
		<xsl:param name="indent"/>
		<mn:p>
			<xsl:copy-of select="@*"/>
			<xsl:value-of select="$indent"/>
			<xsl:copy-of select="node()"/>
		</mn:p>
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
	
	<xsl:template match="mn:li" mode="dl_if">
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
	
	<xsl:template match="mn:dl" mode="dl_if_nested">
		<xsl:for-each select="mn:dt">
			<mn:p>
				<xsl:copy-of select="node()"/>
				<xsl:text> </xsl:text>
				<xsl:copy-of select="following-sibling::mn:dd[1]/mn:p/node()"/>
			</mn:p>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="mn:dd" mode="dl_if_nested"/>
	<!-- =============================== -->
	<!-- END mode="dl_if" -->
	<!-- =============================== -->
	<!-- ===================== -->
	<!-- END Definition List -->
	<!-- ===================== -->
	
</xsl:stylesheet>