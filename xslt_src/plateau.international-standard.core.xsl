<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
											xmlns:fo="http://www.w3.org/1999/XSL/Format" 
											xmlns:plateau="https://www.metanorma.org/ns/plateau" 
											xmlns:mathml="http://www.w3.org/1998/Math/MathML" 
											xmlns:xalan="http://xml.apache.org/xalan" 
											xmlns:fox="http://xmlgraphics.apache.org/fop/extensions" 
											xmlns:pdf="http://xmlgraphics.apache.org/fop/extensions/pdf"
											xmlns:xlink="http://www.w3.org/1999/xlink"
											xmlns:java="http://xml.apache.org/xalan/java"
											xmlns:jeuclid="http://jeuclid.sf.net/ns/ext"
											xmlns:barcode="http://barcode4j.krysalis.org/ns" 
											xmlns:redirect="http://xml.apache.org/xalan/redirect"
											exclude-result-prefixes="java"
											extension-element-prefixes="redirect"
											version="1.0">

	<xsl:output method="xml" encoding="UTF-8" indent="no"/>
		
	<xsl:include href="./common.xsl"/>

	<xsl:key name="kfn" match="*[local-name() = 'fn'][not(ancestor::*[(local-name() = 'table' or local-name() = 'figure' or local-name() = 'localized-strings')] and not(ancestor::*[local-name() = 'name']))]" use="@reference"/>
	
	<xsl:variable name="namespace">plateau</xsl:variable>
	
	<xsl:variable name="debug">false</xsl:variable>
	
	<xsl:variable name="contents_">
		<xsl:variable name="bundle" select="count(//plateau:plateau-standard) &gt; 1"/>
		
		<xsl:if test="normalize-space($bundle) = 'true'">
			<collection firstpage_id="firstpage_id_0"/>
		</xsl:if>
		
		<xsl:for-each select="//plateau:plateau-standard">
			<xsl:variable name="num"><xsl:number level="any" count="plateau:plateau-standard"/></xsl:variable>
			<xsl:variable name="docnumber"><xsl:value-of select="plateau:bibdata/plateau:docidentifier[@type = 'JIS']"/></xsl:variable>
			<xsl:variable name="current_document">
				<xsl:copy-of select="."/>
			</xsl:variable>
			
			<xsl:for-each select="xalan:nodeset($current_document)"> <!-- . -->
				<doc num="{$num}" firstpage_id="firstpage_id_{$num}" title-part="{$docnumber}" bundle="{$bundle}"> <!-- 'bundle' means several different documents (not language versions) in one xml -->
					<contents>
						<!-- <xsl:call-template name="processPrefaceSectionsDefault_Contents"/> -->
						
						<xsl:call-template name="processMainSectionsDefault_Contents"/>
						
						<xsl:apply-templates select="//plateau:indexsect" mode="contents"/>

					</contents>
				</doc>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="contents" select="xalan:nodeset($contents_)"/>
	
	<xsl:variable name="ids">
		<xsl:for-each select="//*[@id]">
			<id><xsl:value-of select="@id"/></id>
		</xsl:for-each>
	</xsl:variable>

	<xsl:template match="/">
	
		<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format" xml:lang="{$lang}">
			<xsl:variable name="root-style">
				<root-style xsl:use-attribute-sets="root-style">
				</root-style>
			</xsl:variable>
			<xsl:call-template name="insertRootStyle">
				<xsl:with-param name="root-style" select="$root-style"/>
			</xsl:call-template>
			
			<fo:layout-master-set>
			
				<!-- Cover page -->
				<fo:simple-page-master master-name="cover-page" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
					<fo:region-body margin-top="15mm" margin-bottom="45mm" margin-left="36mm" margin-right="8.5mm"/>
					<fo:region-before region-name="header" extent="15mm"/>
					<fo:region-after region-name="footer" extent="45mm"/>
					<fo:region-start region-name="left-region" extent="36mm"/>
					<fo:region-end region-name="right-region" extent="8.5mm"/>
				</fo:simple-page-master>
			
				<fo:simple-page-master master-name="document_preface" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
					<fo:region-body margin-top="50mm" margin-bottom="35mm" margin-left="26mm" margin-right="34mm"/>
					<fo:region-before region-name="header" extent="50mm"/>
					<fo:region-after region-name="footer" extent="35mm"/>
					<fo:region-start region-name="left-region" extent="26mm"/>
					<fo:region-end region-name="right-region" extent="34mm"/>
				</fo:simple-page-master>
				
				<fo:simple-page-master master-name="document_toc" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
					<fo:region-body margin-top="16.5mm" margin-bottom="22mm" margin-left="14.5mm" margin-right="22.3mm"/>
					<fo:region-before region-name="header" extent="16.5mm"/>
					<fo:region-after region-name="footer" extent="22mm"/>
					<fo:region-start region-name="left-region" extent="14.5mm"/>
					<fo:region-end region-name="right-region" extent="22.3mm"/>
				</fo:simple-page-master>
				
				<fo:simple-page-master master-name="document" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
					<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
					<fo:region-before region-name="header-odd" extent="{$marginTop}mm"/>
					<fo:region-after region-name="footer" extent="{$marginBottom}mm"/>
					<fo:region-start region-name="left-region" extent="{$marginLeftRight1}mm"/>
					<fo:region-end region-name="right-region" extent="{$marginLeftRight2}mm"/>
				</fo:simple-page-master>
				
				<!-- landscape -->
				<fo:simple-page-master master-name="document-landscape" page-width="{$pageHeight}mm" page-height="{$pageWidth}mm">
					<fo:region-body margin-top="{$marginLeftRight1}mm" margin-bottom="{$marginLeftRight2}mm" margin-left="{$marginBottom}mm" margin-right="{$marginTop}mm"/>
					<fo:region-before region-name="header-odd" extent="{$marginLeftRight1}mm" precedence="true"/>
					<fo:region-after region-name="footer" extent="{$marginLeftRight2}mm" precedence="true"/>
					<fo:region-start region-name="left-region-landscape" extent="{$marginBottom}mm"/>
					<fo:region-end region-name="right-region-landscape" extent="{$marginTop}mm"/>
				</fo:simple-page-master>
				
				<fo:simple-page-master master-name="last-page" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
					<fo:region-body margin-top="179.5mm" margin-bottom="30mm" margin-left="15mm" margin-right="22.7mm"/>
					<fo:region-before region-name="header" extent="179.5mm"/>
					<fo:region-after region-name="footer" extent="30mm"/>
					<fo:region-start region-name="left-region" extent="15mm"/>
					<fo:region-end region-name="right-region" extent="22.7mm"/>
				</fo:simple-page-master>
			</fo:layout-master-set>
			
			<fo:declarations>
				<xsl:call-template name="addPDFUAmeta"/>
			</fo:declarations>

			<xsl:call-template name="addBookmarks">
				<xsl:with-param name="contents" select="$contents"/>
			</xsl:call-template>
			
			<xsl:variable name="updated_xml_step1">
				<xsl:apply-templates mode="update_xml_step1"/>
			</xsl:variable>
			<!-- DEBUG: updated_xml_step1=<xsl:copy-of select="$updated_xml_step1"/> -->
			<!-- <xsl:message>start redirect</xsl:message>
			<redirect:write file="update_xml_step1.xml">
				<xsl:copy-of select="$updated_xml_step1"/>
			</redirect:write>
			<xsl:message>end redirect</xsl:message> -->
			
			
			<xsl:variable name="updated_xml_step2_">
				<xsl:apply-templates select="xalan:nodeset($updated_xml_step1)" mode="update_xml_step2"/>
			</xsl:variable>
			<xsl:variable name="updated_xml_step2" select="xalan:nodeset($updated_xml_step2_)"/>
			<!-- DEBUG: updated_xml_step2=<xsl:copy-of select="$updated_xml_step2"/> -->
			<!-- <xsl:message>start redirect</xsl:message>
			<redirect:write file="update_xml_step2.xml">
				<xsl:copy-of select="$updated_xml_step2"/>
			</redirect:write>
			<xsl:message>end redirect</xsl:message> -->
			
			
			<xsl:for-each select="$updated_xml_step2//plateau:plateau-standard">
				<xsl:variable name="num"><xsl:number level="any" count="plateau:plateau-standard"/></xsl:variable>
				
				<xsl:variable name="current_document">
					<xsl:copy-of select="."/>
				</xsl:variable>
				
				<xsl:for-each select="xalan:nodeset($current_document)">
				
					<xsl:call-template name="insertCoverPage">
						<xsl:with-param name="num" select="$num"/>
					</xsl:call-template>
										
					<!-- ========================== -->
					<!-- Preface and contents pages -->
					<!-- ========================== -->
					
					<xsl:variable name="structured_xml_preface_">
						<xsl:for-each select="/*/*[local-name()='preface']/*[not(@type = 'toc')]">
							<xsl:sort select="@displayorder" data-type="number"/>
							<item><xsl:apply-templates select="." mode="linear_xml"/></item>
						</xsl:for-each>
					</xsl:variable>
					
					<!-- <xsl:message>start redirect</xsl:message>
					<redirect:write file="structured_xml_preface_.xml">
						<xsl:copy-of select="$structured_xml_preface_"/>
					</redirect:write>
					<xsl:message>end redirect</xsl:message> -->
					
					<!-- structured_xml_preface=<xsl:copy-of select="$structured_xml_preface"/> -->
					
					<!-- page break before each section -->
					<xsl:variable name="structured_xml_preface">
						<xsl:for-each select="xalan:nodeset($structured_xml_preface_)/item[*]">
							<xsl:element name="pagebreak" namespace="https://www.metanorma.org/ns/plateau"/>
							<xsl:copy-of select="./*"/>
						</xsl:for-each>
					</xsl:variable>
					
					<xsl:variable name="paged_xml_preface_">
						<xsl:call-template name="makePagedXML">
							<xsl:with-param name="structured_xml" select="$structured_xml_preface"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:variable name="paged_xml_preface" select="xalan:nodeset($paged_xml_preface_)"/>
					
					<!-- <xsl:message>start redirect</xsl:message>
					<redirect:write file="paged_xml_preface.xml">
						<xsl:copy-of select="$paged_xml_preface"/>
					</redirect:write>
					<xsl:message>end redirect</xsl:message> -->
					
					<xsl:if test="$paged_xml_preface/*[local-name()='page'] and count($paged_xml_preface/*[local-name()='page']/*) != 0">
						<!-- Preface pages -->
						<fo:page-sequence master-reference="document_preface" force-page-count="no-force" font-family="Noto Sans JP">
						
							<fo:static-content flow-name="header" role="artifact" id="__internal_layout__preface_header_{generate-id()}">
								<!-- grey background  -->
								<fo:block-container absolute-position="fixed" left="24.2mm" top="40mm" height="231.4mm" width="161mm" background-color="rgb(242,242,242)" id="__internal_layout__preface_header_{$num}_{generate-id()}">
									<fo:block>&#xa0;</fo:block>
								</fo:block-container>
							</fo:static-content>
						
							<fo:flow flow-name="xsl-region-body">
								<fo:block line-height="2">
									<xsl:for-each select="$paged_xml_preface/*[local-name()='page']">
										<xsl:if test="position() != 1">
											<fo:block break-after="page"/>
										</xsl:if>
										<xsl:apply-templates select="*" mode="page"/>
									</xsl:for-each>
								</fo:block>
							</fo:flow>
						</fo:page-sequence> <!-- END Preface pages -->
					</xsl:if>
					
					<fo:page-sequence master-reference="document_toc" initial-page-number="1" force-page-count="no-force">
						<fo:flow flow-name="xsl-region-body">
							<!-- <xsl:if test="$debug = 'true'"> -->
							<!-- <xsl:message>start contents redirect</xsl:message>
							<redirect:write file="contents.xml">
								<xsl:copy-of select="$contents"/>
							</redirect:write>
							<xsl:message>end contents redirect</xsl:message> -->
							<!-- </xsl:if> -->
							
							<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name() = 'clause'][@type = 'toc']">
								<xsl:with-param name="num" select="$num"/>
							</xsl:apply-templates>
							
							<xsl:if test="not(/*/*[local-name()='preface']/*[local-name() = 'clause'][@type = 'toc'])">
								<fo:block><!-- prevent fop error for empty document --></fo:block>
							</xsl:if>
						</fo:flow>
					</fo:page-sequence>
					<!-- ========================== -->
					<!-- END Preface and contents pages -->
					<!-- ========================== -->
					
					
					<!-- item - page sequence -->
					<xsl:variable name="structured_xml_">
						
						<xsl:if test="not(/*/*[local-name()='preface']/*[local-name() = 'p' and @type = 'section-title'][following-sibling::*[1][local-name() = 'introduction']])">
							<item><xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name() = 'introduction']" mode="linear_xml" /></item>
						</xsl:if>
						
						<item>
							<xsl:choose>
								<xsl:when test="/*/*[local-name()='preface']/*[local-name() = 'p' and @type = 'section-title'][following-sibling::*[1][local-name() = 'introduction']]">
									<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name() = 'p' and @type = 'section-title'][following-sibling::*[1][local-name() = 'introduction']]" mode="linear_xml" />
									<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name() = 'introduction']" mode="linear_xml" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name() = 'p' and @type = 'section-title'][not(following-sibling::*) or following-sibling::*[1][local-name() = 'clause' and @type = 'corrigenda']]" mode="linear_xml" />
								</xsl:otherwise>
							</xsl:choose>
							
							<xsl:apply-templates select="/*/*[local-name()='sections']/*" mode="linear_xml"/>
						</item>	
						
						<!-- Annexes -->
						<!-- <xsl:for-each select="/*/*[local-name()='annex']">
							<item>
								<xsl:apply-templates select="." mode="linear_xml"/>
							</item>
						</xsl:for-each> -->
						
						<!-- Bibliography -->
						<xsl:for-each select="/*/*[local-name()='bibliography']/*[count(.//*[local-name() = 'bibitem'][not(@hidden) = 'true']) &gt; 0 and not(@hidden = 'true')]">
							<xsl:sort select="@displayorder" data-type="number"/>
							<item><xsl:apply-templates select="." mode="linear_xml"/></item>
						</xsl:for-each>
						<!-- Annexes -->
						<xsl:for-each select="/*/*[local-name()='annex']">
							<xsl:sort select="@displayorder" data-type="number"/>
							<item><xsl:apply-templates select="." mode="linear_xml"/></item>
						</xsl:for-each>
						
						<item>
							<xsl:copy-of select="//plateau:indexsect" />
						</item>
						
					</xsl:variable>
					
					<!-- page break before each section -->
					<xsl:variable name="structured_xml">
						<xsl:for-each select="xalan:nodeset($structured_xml_)/item[*]">
							<xsl:element name="pagebreak" namespace="https://www.metanorma.org/ns/plateau"/>
							<xsl:copy-of select="./*"/>
						</xsl:for-each>
					</xsl:variable>
					<!-- structured_xml=<xsl:copy-of select="$structured_xml" /> -->
					
					<xsl:variable name="paged_xml">
						<xsl:call-template name="makePagedXML">
							<xsl:with-param name="structured_xml" select="$structured_xml"/>
						</xsl:call-template>
					</xsl:variable>
					<!-- paged_xml=<xsl:copy-of select="$paged_xml"/> -->
					
					<xsl:for-each select="xalan:nodeset($paged_xml)/*[local-name()='page'][*]">
					
						<xsl:variable name="isCommentary" select="normalize-space(.//plateau:annex[@commentary = 'true'] and 1 = 1)"/> <!-- true or false -->
						<!-- DEBUG: <xsl:copy-of select="."/> -->
						<fo:page-sequence master-reference="document" force-page-count="no-force">
							
							<xsl:if test="@orientation = 'landscape'">
								<xsl:attribute name="master-reference">document-<xsl:value-of select="@orientation"/></xsl:attribute>
							</xsl:if>
							
							<xsl:if test="position() = 1">
								<xsl:attribute name="initial-page-number">1</xsl:attribute>
							</xsl:if>
							<fo:static-content flow-name="xsl-footnote-separator">
								<fo:block>
									<fo:leader leader-pattern="rule" leader-length="15%"/>
								</fo:block>
							</fo:static-content>
							
							<fo:static-content flow-name="footer">
								<fo:block-container height="24mm" display-align="after">
									<fo:block text-align="center" margin-bottom="16mm"><fo:page-number /></fo:block>
								</fo:block-container>
							</fo:static-content>
							
							<fo:flow flow-name="xsl-region-body">
								<xsl:apply-templates select="*" mode="page"/>
								
								<xsl:if test="not(*)">
									<fo:block><!-- prevent fop error for empty document --></fo:block>
								</xsl:if>
							</fo:flow>
						</fo:page-sequence>
					</xsl:for-each>
					
					
					<fo:page-sequence master-reference="last-page" force-page-count="no-force">
						<fo:flow flow-name="xsl-region-body">
							<fo:block-container width="100%" border="0.75pt solid black" font-size="10pt" line-height="1.7">
								<fo:block margin-left="4.5mm" margin-top="1mm">
									<xsl:value-of select="/*/plateau:bibdata/plateau:title[@language = 'ja' and @type = 'title-main']"/>
									<fo:inline padding-left="4mm"><xsl:value-of select="/*/plateau:bibdata/plateau:edition[@language = 'ja']"/></fo:inline>
								</fo:block>
								<fo:block margin-left="7.7mm"><xsl:value-of select="/*/plateau:bibdata/plateau:date[@type = 'published']"/><xsl:text> 発行</xsl:text></fo:block>
								<!-- MLIT Department -->
								<fo:block margin-left="7.7mm"><xsl:value-of select="/*/plateau:bibdata/plateau:contributor[plateau:role/@type = 'author']/plateau:organization/plateau:name"/></fo:block>
								<fo:block margin-left="9mm"><xsl:value-of select="/*/plateau:bibdata/plateau:ext/plateau:author-cooperation"/></fo:block>
							</fo:block-container>
						</fo:flow>
					</fo:page-sequence>


					
				</xsl:for-each>
			
			</xsl:for-each>
			
			<xsl:if test="not(//plateau:plateau-standard)">
				<fo:page-sequence master-reference="document" force-page-count="no-force">
					<fo:flow flow-name="xsl-region-body">
						<fo:block><!-- prevent fop error for empty document --></fo:block>
					</fo:flow>
				</fo:page-sequence>
			</xsl:if>
			
		</fo:root>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'references'][not(@hidden = 'true')]" mode="linear_xml" priority="2">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="linear_xml"/>
		</xsl:copy>
	</xsl:template>
	
	
	<xsl:template match="*[local-name()='preface']/*[local-name() = 'clause'][@type = 'toc']" priority="4">
		<xsl:param name="num"/>
		<xsl:apply-templates />
		<xsl:if test="count(*) = 1 and *[local-name() = 'title']"> <!-- if there isn't user ToC -->
			<!-- fill ToC -->
			<fo:block role="TOC" font-weight="bold">
				<xsl:if test="$contents/doc[@num = $num]//item[@display = 'true']">
					<xsl:for-each select="$contents/doc[@num = $num]//item[@display = 'true'][@level &lt;= $toc_level or @type='figure' or @type = 'table']">
						<fo:block role="TOCI">
							<xsl:choose>
								<xsl:when test="@type = 'annex' or @type = 'bibliography'">
									<fo:block space-after="5pt">
										<xsl:call-template name="insertTocItem"/>
									</fo:block>
								</xsl:when>
								<xsl:otherwise>
									<xsl:variable name="margin_left" select="number(@level - 1) * 3"/>
									<fo:list-block space-after="2pt" margin-left="{$margin_left}mm">
										<xsl:attribute name="provisional-distance-between-starts">
											<xsl:choose>
												<xsl:when test="@level = 1">7mm</xsl:when>
												<xsl:when test="@level = 2">10mm</xsl:when>
												<xsl:when test="@level = 3">14mm</xsl:when>
												<xsl:otherwise>14mm</xsl:otherwise>
											</xsl:choose>
										</xsl:attribute>
										<fo:list-item>
											<fo:list-item-label end-indent="label-end()">
												<fo:block>
													<xsl:value-of select="@section"/>
												</fo:block>
											</fo:list-item-label>
											<fo:list-item-body start-indent="body-start()">
												<xsl:call-template name="insertTocItem"/>
											</fo:list-item-body>
										</fo:list-item>
									</fo:list-block>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</xsl:for-each>
				</xsl:if>
			</fo:block>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'clause'][@type = 'toc']/*[local-name() = 'title']" priority="3"/>
		
	<xsl:template name="insertTocItem">
		<fo:block text-align-last="justify" role="TOCI">
			<fo:basic-link internal-destination="{@id}" fox:alt-text="{title}">
				<fo:inline><xsl:apply-templates select="title" /></fo:inline>
				<fo:inline keep-together.within-line="always">
					<fo:leader leader-pattern="dots"/>
					<fo:inline>
						<fo:page-number-citation ref-id="{@id}"/>
					</fo:inline>
				</fo:inline>
			</fo:basic-link>
		</fo:block>
	</xsl:template>
	
	<xsl:template name="insertCoverPage">
		<xsl:param name="num"/>
		<fo:page-sequence master-reference="cover-page" force-page-count="no-force" font-family="Noto Sans Condensed">
			
			<fo:static-content flow-name="header" role="artifact" id="__internal_layout__coverpage_header_{generate-id()}">
				<!-- background cover image -->
				<xsl:call-template name="insertBackgroundPageImage"/>
			</fo:static-content>
			
			<fo:static-content flow-name="footer" role="artifact">
				<fo:block-container>
					<fo:table table-layout="fixed" width="100%">
						<fo:table-column column-width="proportional-column-width(140)"/>
						<fo:table-column column-width="proportional-column-width(13.5)"/>
						<fo:table-column column-width="proportional-column-width(11)"/>
						<fo:table-body>
							<fo:table-row>
								<fo:table-cell>
									<fo:block font-size="28pt" font-family="Noto Sans JP"><xsl:apply-templates select="/*/plateau:bibdata/plateau:title[@language = 'ja' and @type = 'title-main']/node()"/></fo:block>
									<fo:block font-size="14pt" margin-top="3mm"><xsl:apply-templates select="/*/plateau:bibdata/plateau:title[@language = 'en' and @type = 'title-main']/node()"/></fo:block>
								</fo:table-cell>
								<fo:table-cell text-align="right" font-size="8.5pt" padding-right="2mm">
									<fo:block>&#xa0;</fo:block>
									<fo:block>series</fo:block>
									<fo:block>No.</fo:block>
								</fo:table-cell>
								<fo:table-cell text-align="right">
									<fo:block font-size="32pt">
										<xsl:variable name="docnumber" select="/*/plateau:bibdata/plateau:docnumber"/>
										<xsl:if test="string-length($docnumber) = 1">0</xsl:if><xsl:value-of select="$docnumber"/>
									</fo:block>
								</fo:table-cell>
							</fo:table-row>
						</fo:table-body>
					</fo:table>
				</fo:block-container>
			</fo:static-content>
		
			<fo:static-content flow-name="left-region" role="artifact" id="__internal_layout__coverpage_left_region_{generate-id()}">				
				<fo:block text-align="center" margin-top="14.5mm" margin-left="2mm">
					<fo:instream-foreign-object content-width="24mm" fox:alt-text="PLATEAU Logo">
						<xsl:copy-of select="$PLATEAU-Logo"/>
					</fo:instream-foreign-object>
				</fo:block>
				<fo:block-container reference-orientation="-90" width="205mm" height="36mm" margin-top="6mm">
					<fo:block font-size="21.2pt" margin-top="7mm"><xsl:apply-templates select="/*/plateau:bibdata/plateau:title[@language = 'en' and @type = 'title-intro']/node()"/></fo:block>
					<fo:block font-family="Noto Sans JP" font-size="14.2pt" margin-top="2mm"><xsl:apply-templates select="/*/plateau:bibdata/plateau:title[@language = 'ja' and @type = 'title-intro']/node()"/></fo:block>
				</fo:block-container>
			</fo:static-content>
			
			<fo:flow flow-name="xsl-region-body">
				<fo:block id="firstpage_id_{$num}">&#xa0;</fo:block>
			</fo:flow>
		</fo:page-sequence>
	</xsl:template> <!-- insertCoverPage -->
	
	
	<xsl:template match="plateau:p[@class = 'JapaneseIndustrialStandard']" priority="4"/>
	<xsl:template match="plateau:p[@class = 'StandardNumber']" priority="4"/>
	<xsl:template match="plateau:p[@class = 'IDT']" priority="4"/>
	<xsl:template match="plateau:p[@class = 'zzSTDTitle1']" priority="4"/>
	<xsl:template match="plateau:p[@class = 'zzSTDTitle2']" priority="4"/>
	
	<!-- for commentary annex -->
	<xsl:template match="plateau:p[@class = 'CommentaryStandardNumber']" priority="4">
		<fo:block font-size="15pt" text-align="center">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="plateau:p[@class = 'CommentaryStandardNumber']//text()[not(ancestor::plateau:span)]" priority="4">
		<fo:inline font-family="Arial">
			<xsl:choose>
				<xsl:when test="contains(., ':')">
					<xsl:value-of select="substring-before(., ':')"/>
					<fo:inline baseline-shift="10%" font-size="10pt">：</fo:inline>
					<xsl:value-of select="substring-after(., ':')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="plateau:p[@class = 'CommentaryStandardNumber']/plateau:span[@class = 'CommentaryEffectiveYear']" priority="4">
		<fo:inline  baseline-shift="10%" font-family="Noto Sans Condensed" font-size="10pt"><xsl:apply-templates/></fo:inline>
	</xsl:template>
	
	<xsl:template match="plateau:p[@class = 'CommentaryStandardName']" priority="4">
		<fo:block role="H1" font-size="16pt" text-align="center" margin-top="6mm">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	
	<!-- ============================= -->
	<!-- CONTENTS                      -->
	<!-- ============================= -->
	
	<!-- element with title -->
	<xsl:template match="*[plateau:title]" mode="contents">
	
		<xsl:variable name="level">
			<xsl:call-template name="getLevel">
				<xsl:with-param name="depth" select="plateau:title/@depth"/>
			</xsl:call-template>
		</xsl:variable>
		
		<!-- if previous clause contains section-title as latest element (section-title may contain  note's, admonition's, etc.),
		and if @depth of current clause equals to section-title @depth,
		then put section-title before current clause -->
		<xsl:if test="local-name() = 'clause'">
			<xsl:apply-templates select="preceding-sibling::*[1][local-name() = 'clause']//*[local-name() = 'p' and @type = 'section-title'
				and @depth = $level 
				and not(following-sibling::*[local-name()='clause'])]" mode="contents_in_clause"/>
		</xsl:if>
		
		<xsl:variable name="section">
			<xsl:call-template name="getSection"/>
		</xsl:variable>
		
		<xsl:variable name="type">
			<xsl:choose>
				<xsl:when test="local-name() = 'indexsect'">index</xsl:when>
				<xsl:when test="(ancestor-or-self::plateau:bibliography and local-name() = 'clause' and not(.//*[local-name() = 'references' and @normative='true'])) or self::plateau:references[not(@normative) or @normative='false']">bibliography</xsl:when>
				<xsl:otherwise><xsl:value-of select="local-name()"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
			
		<xsl:variable name="display">
			<xsl:choose>
				<xsl:when test="normalize-space(@id) = ''">false</xsl:when>
				<xsl:when test="ancestor-or-self::plateau:annex and $level &gt;= 2">false</xsl:when>
				<xsl:when test="$type = 'bibliography' and $level &gt;= 2">false</xsl:when>
				<xsl:when test="$type = 'bibliography'">true</xsl:when>
				<xsl:when test="$type = 'references' and $level &gt;= 2">false</xsl:when>
				<xsl:when test="ancestor-or-self::plateau:colophon">true</xsl:when>
				<xsl:when test="$section = '' and $type = 'clause' and $level = 1 and ancestor::plateau:preface">true</xsl:when>
				<xsl:when test="$section = '' and $type = 'clause'">false</xsl:when>
				<xsl:when test="$level &lt;= $toc_level">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="skip">
			<xsl:choose>
				<xsl:when test="ancestor-or-self::plateau:bibitem">true</xsl:when>
				<xsl:when test="ancestor-or-self::plateau:term">true</xsl:when>				
				<xsl:when test="@type = 'corrigenda'">true</xsl:when>
				<xsl:when test="@type = 'policy'">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		
		<xsl:if test="$skip = 'false'">		
		
			<xsl:variable name="title">
				<xsl:call-template name="getName"/>
			</xsl:variable>
			
			<xsl:variable name="root">
				<xsl:if test="ancestor-or-self::plateau:preface">preface</xsl:if>
				<xsl:if test="ancestor-or-self::plateau:annex">annex</xsl:if>
			</xsl:variable>
			
			<item id="{@id}" level="{$level}" section="{$section}" type="{$type}" root="{$root}" display="{$display}">
				<xsl:if test="$type = 'index'">
					<xsl:attribute name="level">1</xsl:attribute>
				</xsl:if>
				<title>
					<xsl:apply-templates select="xalan:nodeset($title)" mode="contents_item">
						<xsl:with-param name="mode">contents</xsl:with-param>
					</xsl:apply-templates>
				</title>
				<xsl:if test="$type != 'index'">
					<xsl:apply-templates  mode="contents" />
				</xsl:if>
			</item>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'preface']/*[local-name() = 'clause']" priority="3">
		<fo:block>
			<xsl:call-template name="setId"/>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="*" priority="3" mode="page">
		<xsl:call-template name="elementProcessing"/>
	</xsl:template>
	
	<xsl:template name="elementProcessing">
		<xsl:choose>
			<xsl:when test="local-name() = 'p' and count(node()) = count(processing-instruction())"><!-- skip --></xsl:when> <!-- empty paragraph with processing-instruction -->
			<xsl:when test="@hidden = 'true'"><!-- skip --></xsl:when>
			<xsl:when test="local-name() = 'title' or local-name() = 'term'">
				<xsl:apply-templates select="."/>
			</xsl:when>
			<xsl:when test="@mainsection = 'true'">
				<!-- page break before section's title -->
				<xsl:if test="local-name() = 'p' and @type='section-title'">
					<fo:block break-after="page"/>
				</xsl:if>
				<fo:block-container>
					<xsl:attribute name="keep-with-next">always</xsl:attribute>
					<fo:block><xsl:apply-templates select="."/></fo:block>
				</fo:block-container>
			</xsl:when>
			<xsl:when test="local-name() = 'indexsect'">
				<xsl:apply-templates select="." mode="index"/>
			</xsl:when>
			<xsl:otherwise>
				<fo:block>
					<xsl:if test="not(node())">
						<xsl:attribute name="keep-with-next">always</xsl:attribute>
					</xsl:if>
					<xsl:apply-templates select="."/>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<xsl:template match="plateau:title" priority="2" name="title">
	
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		
		<xsl:variable name="font-size">
			<xsl:choose>
				<xsl:when test="@parent = 'preface'">10pt</xsl:when>
				<xsl:when test="@ancestor = 'sections'">12pt</xsl:when>
				<!-- <xsl:when test="@type = 'section-title'">18pt</xsl:when>
				<xsl:when test="@ancestor = 'foreword' and $level = '1'">14pt</xsl:when>
				<xsl:when test="@ancestor = 'annex' and $level = '1' and preceding-sibling::*[local-name() = 'annex'][1][@commentary = 'true']">16pt</xsl:when>
				<xsl:when test="@ancestor = 'annex' and $level = '1'">14pt</xsl:when> -->
				<!-- <xsl:when test="@ancestor = 'foreword' and $level &gt;= '2'">12pt</xsl:when>
				<xsl:when test=". = 'Executive summary'">18pt</xsl:when>
				<xsl:when test="@ancestor = 'introduction' and $level = '1'">18pt</xsl:when>
				<xsl:when test="@ancestor = 'introduction' and $level &gt;= '2'">11pt</xsl:when>
				<xsl:when test="@ancestor = 'sections' and $level = '1'">14pt</xsl:when>
				<xsl:when test="@ancestor = 'sections' and $level = '2'">11pt</xsl:when>
				<xsl:when test="@ancestor = 'sections' and $level &gt;= '3'">10pt</xsl:when>
				<xsl:when test="@ancestor = 'sections' and $level = '2' and preceding-sibling::*[1][local-name() = 'references']">inherit</xsl:when>
				<xsl:when test="@ancestor = 'sections' and $level = '2'">11pt</xsl:when>
				<xsl:when test="@ancestor = 'sections' and $level &gt;= '3' and preceding-sibling::*[1][local-name() = 'terms']">11pt</xsl:when>
				<xsl:when test="@ancestor = 'sections' and $level = '3'">10.5pt</xsl:when>
				<xsl:when test="@ancestor = 'sections' and $level &gt;= '4'">10pt</xsl:when>
				
				<xsl:when test="@ancestor = 'annex' and $level = '2'">13pt</xsl:when>
				<xsl:when test="@ancestor = 'annex' and $level &gt;= '3'">11.5pt</xsl:when>
				<xsl:when test="@ancestor = 'bibliography' and $level = '1' and preceding-sibling::*[local-name() = 'references']">11.5pt</xsl:when>
				<xsl:when test="@ancestor = 'bibliography' and $level = '1'">13pt</xsl:when>
				<xsl:when test="@ancestor = 'bibliography' and $level &gt;= '2'">10pt</xsl:when> -->
				<xsl:otherwise>10pt</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="font-weight">
			<xsl:choose>
				<xsl:when test="@parent = 'preface'">bold</xsl:when>
				<xsl:when test="@parent = 'annex'">bold</xsl:when>
				<xsl:when test="@parent = 'bibliography'">bold</xsl:when>
				<xsl:otherwise>normal</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="text-align">
			<xsl:choose>
				<xsl:when test="@ancestor = 'foreword' and $level = 1">center</xsl:when>
				<!-- <xsl:when test="@ancestor = 'annex' and $level = 1">center</xsl:when> -->
				<xsl:otherwise>left</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		
		<xsl:variable name="margin-top">
			<xsl:choose>
				<xsl:when test="@ancestor = 'foreword' and $level = 1">9mm</xsl:when>
				<xsl:when test="@ancestor = 'annex' and $level = '1' and preceding-sibling::*[local-name() = 'annex'][1][@commentary = 'true']">1mm</xsl:when>
				<xsl:when test="@ancestor = 'annex' and $level = 1">0mm</xsl:when>
				<xsl:when test="$level = 1 and not(@parent = 'preface')">6.5mm</xsl:when>
				<xsl:when test="@ancestor = 'foreword' and $level = 2">0mm</xsl:when>
				<xsl:when test="@ancestor = 'annex' and $level = 2">4.5mm</xsl:when>
				<xsl:when test="@ancestor = 'bibliography' and $level = 2">0mm</xsl:when>
				<xsl:when test="$level = 2">2mm</xsl:when>
				<xsl:when test="$level &gt;= 3">2mm</xsl:when>
				<xsl:otherwise>0mm</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="element-name">
			<xsl:choose>
				<xsl:when test="@inline-header = 'true'">fo:inline</xsl:when>
				<xsl:otherwise>fo:block</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="margin-bottom">
			<xsl:choose>
				<xsl:when test="@ancestor = 'foreword' and $level = 1">9mm</xsl:when>
				<xsl:when test="@ancestor = 'annex' and $level = '1' and preceding-sibling::*[local-name() = 'annex'][1][@commentary = 'true']">7mm</xsl:when>
				<xsl:when test="@ancestor = 'annex' and $level = 1">1mm</xsl:when>
				<xsl:when test="$level = 1 and following-sibling::plateau:clause">8pt</xsl:when>
				<xsl:when test="$level = 1">12pt</xsl:when>
				<xsl:when test="$level = 2 and following-sibling::plateau:clause">8pt</xsl:when>
				<xsl:when test="$level &gt;= 2">12pt</xsl:when>
				<xsl:when test="@type = 'section-title'">6mm</xsl:when>
				<xsl:when test="@inline-header = 'true'">0pt</xsl:when>
				<xsl:otherwise>0mm</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
	

		<!-- to space-before Foreword -->
		<xsl:if test="@ancestor = 'foreword' and $level = '1'"><fo:block></fo:block></xsl:if>
	

		<xsl:choose>
			<xsl:when test="@inline-header = 'true' and following-sibling::*[1][self::plateau:p]">
				<fo:block role="H{$level}">
					<xsl:for-each select="following-sibling::*[1][self::plateau:p]">
						<xsl:call-template name="paragraph">
							<xsl:with-param name="inline-header">true</xsl:with-param>
						</xsl:call-template>
					</xsl:for-each>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="{$element-name}">
					<xsl:attribute name="font-size"><xsl:value-of select="$font-size"/></xsl:attribute>
					<xsl:attribute name="font-weight"><xsl:value-of select="$font-weight"/></xsl:attribute>
					<xsl:attribute name="text-align"><xsl:value-of select="$text-align"/></xsl:attribute>
					<xsl:attribute name="space-before"><xsl:value-of select="$margin-top"/></xsl:attribute>
					<xsl:attribute name="margin-bottom"><xsl:value-of select="$margin-bottom"/></xsl:attribute>
					<xsl:attribute name="keep-with-next">always</xsl:attribute>
					<xsl:attribute name="role">H<xsl:value-of select="$level"/></xsl:attribute>
					
					<xsl:if test="@type = 'floating-title' or @type = 'section-title'">
						<xsl:copy-of select="@id"/>
					</xsl:if>
					
					<!-- if first and last childs are `add` ace-tag, then move start ace-tag before title -->
					<xsl:if test="*[local-name() = 'tab'][1]/following-sibling::node()[last()][local-name() = 'add'][starts-with(text(), $ace_tag)]">
						<xsl:apply-templates select="*[local-name() = 'tab'][1]/following-sibling::node()[1][local-name() = 'add'][starts-with(text(), $ace_tag)]">
							<xsl:with-param name="skip">false</xsl:with-param>
						</xsl:apply-templates> 
					</xsl:if>
					
					<xsl:variable name="section">
						<xsl:call-template name="extractSection"/>
					</xsl:variable>
					<xsl:if test="normalize-space($section) != ''">
						<fo:inline> <!--  font-family="Noto Sans Condensed" font-weight="bold" -->
							<xsl:value-of select="$section"/>
							<fo:inline padding-right="4mm">&#xa0;</fo:inline>
						</fo:inline>
					</xsl:if>
					
					<xsl:call-template name="extractTitle"/>
					
					<xsl:apply-templates select="following-sibling::*[1][local-name() = 'variant-title'][@type = 'sub']" mode="subtitle"/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*[local-name() = 'annex']" priority="2">
		<fo:block id="{@id}">
		</fo:block>
		<xsl:apply-templates />
	</xsl:template>
	
	
	<xsl:variable name="text_indent">3</xsl:variable>
	
	<xsl:template match="plateau:p" name="paragraph">
		<xsl:param name="inline-header">false</xsl:param>
		<xsl:param name="split_keep-within-line"/>
		
		<xsl:choose>
		
			<xsl:when test="preceding-sibling::*[1][self::plateau:title]/@inline-header = 'true' and $inline-header = 'false'"/> <!-- paragraph displayed in title template -->
			
			<xsl:otherwise>
			
				<xsl:variable name="previous-element" select="local-name(preceding-sibling::*[1])"/>
				<xsl:variable name="element-name">fo:block</xsl:variable>
				
				<xsl:element name="{$element-name}">
					<xsl:call-template name="setBlockAttributes">
						<xsl:with-param name="text_align_default">justify</xsl:with-param>
					</xsl:call-template>
					<xsl:attribute name="margin-bottom">10pt</xsl:attribute>
					
					<!--
					<xsl:if test="not(parent::plateau:note or parent::plateau:li or ancestor::plateau:table)">
						<xsl:attribute name="text-indent"><xsl:value-of select="$text_indent"/>mm</xsl:attribute>
					</xsl:if>
					-->
					
					<xsl:copy-of select="@id"/>
					
					<!-- <xsl:attribute name="line-height">2</xsl:attribute> -->
					<!-- bookmarks only in paragraph -->
				
					<xsl:if test="count(plateau:bookmark) != 0 and count(*) = count(plateau:bookmark) and normalize-space() = ''">
						<xsl:attribute name="font-size">0</xsl:attribute>
						<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
						<xsl:attribute name="line-height">0</xsl:attribute>
					</xsl:if>

					<xsl:if test="ancestor::*[@key = 'true']">
						<xsl:attribute name="margin-bottom">2pt</xsl:attribute>
					</xsl:if>
					
					<xsl:if test="parent::plateau:definition">
						<xsl:attribute name="margin-bottom">2pt</xsl:attribute>
					</xsl:if>
					
					<xsl:if test="parent::plateau:li or following-sibling::*[1][self::plateau:ol or self::plateau:ul or self::plateau:note or self::plateau:example] or parent::plateau:quote">
						<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
					</xsl:if>
					
					<xsl:if test="parent::plateau:td or parent::plateau:th or parent::plateau:dd">
						<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
					</xsl:if>
					
					<xsl:if test="parent::plateau:clause[@type = 'inner-cover-note'] or ancestor::plateau:boilerplate">
						<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
					</xsl:if>
					
					
					<xsl:apply-templates>
						<xsl:with-param name="split_keep-within-line" select="$split_keep-within-line"/>
					</xsl:apply-templates>
				</xsl:element>
				<xsl:if test="$element-name = 'fo:inline' and not(local-name(..) = 'admonition')"> <!-- and not($inline = 'true')  -->
					<fo:block margin-bottom="12pt">
						 <xsl:if test="ancestor::plateau:annex or following-sibling::plateau:table">
							<xsl:attribute name="margin-bottom">0</xsl:attribute>
						 </xsl:if>
						<xsl:value-of select="$linebreak"/>
					</fo:block>
				</xsl:if>
		
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<xsl:template match="plateau:termnote" priority="2">
		<fo:block id="{@id}" xsl:use-attribute-sets="termnote-style">
			<fo:list-block provisional-distance-between-starts="{14 + $text_indent}mm">
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
		</fo:block>
	</xsl:template>
	
	<xsl:template match="*[local-name()='li']" priority="2">
		<fo:list-item xsl:use-attribute-sets="list-item-style">
			<xsl:copy-of select="@id"/>
			
			<xsl:call-template name="refine_list-item-style"/>
			
			<fo:list-item-label end-indent="label-end()">
				<fo:block xsl:use-attribute-sets="list-item-label-style">
				
					<xsl:call-template name="refine_list-item-label-style"/>
					
					<!-- <xsl:attribute name="line-height">2</xsl:attribute> -->
					
					<!-- if 'p' contains all text in 'add' first and last elements in first p are 'add' -->
					<xsl:if test="*[1][count(node()[normalize-space() != '']) = 1 and *[local-name() = 'add']]">
						<xsl:call-template name="append_add-style"/>
					</xsl:if>
					
					<xsl:variable name="list_item_label">
						<xsl:call-template name="getListItemFormat" />
					</xsl:variable>
					
					<xsl:choose>
						<xsl:when test="contains($list_item_label, ')')">
							<xsl:value-of select="substring-before($list_item_label,')')"/>
							<fo:inline font-weight="normal">)</fo:inline>
							<xsl:value-of select="substring-after($list_item_label,')')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$list_item_label"/>
						</xsl:otherwise>
					</xsl:choose>
					
				</fo:block>
			</fo:list-item-label>
			<fo:list-item-body start-indent="body-start()" xsl:use-attribute-sets="list-item-body-style">
				<fo:block>
				
					<xsl:call-template name="refine_list-item-body-style"/>
								
					<xsl:apply-templates mode="list_jis"/>
				
					<!-- <xsl:apply-templates select="node()[not(local-name() = 'note')]" />
					
					<xsl:for-each select="./bsi:note">
						<xsl:call-template name="note"/>
					</xsl:for-each> -->
				</fo:block>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>
	
	<xsl:template match="node()" priority="2" mode="list_jis">
		<xsl:apply-templates select="."/>
	</xsl:template>
	
	<!-- display footnote after last element in li, except ol or ul -->
	<xsl:template match="*[local-name()='li']/*[not(local-name() = 'ul') and not(local-name() = 'ol')][last()]" priority="3" mode="list_jis">
		<xsl:apply-templates select="."/>
		
		<xsl:variable name="list_id" select="ancestor::*[local-name() = 'ul' or local-name() = 'ol'][1]/@id"/>
		<!-- render footnotes after current list-item, if there aren't footnotes anymore in the list -->
		<!-- i.e. i.e. if list-item is latest with footnote -->
		<xsl:if test="ancestor::*[local-name() = 'li'][1]//plateau:fn[ancestor::*[local-name() = 'ul' or local-name() = 'ol'][1][@id = $list_id]] and
		not(ancestor::*[local-name() = 'li'][1]/following-sibling::*[local-name() = 'li'][.//plateau:fn[ancestor::*[local-name() = 'ul' or local-name() = 'ol'][1][@id = $list_id]]])">
			<xsl:apply-templates select="ancestor::*[local-name() = 'ul' or local-name() = 'ol'][1]//plateau:fn[ancestor::*[local-name() = 'ul' or local-name() = 'ol'][1][@id = $list_id]][generate-id(.)=generate-id(key('kfn',@reference)[1])]" mode="fn_after_element">
				<xsl:with-param name="ancestor">li</xsl:with-param>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="plateau:fn" mode="fn_after_element">
		<xsl:param name="ancestor">li</xsl:param>
		
		<xsl:variable name="ancestor_tree_">
			<xsl:for-each select="ancestor::*[local-name() != 'p' and local-name() != 'bibitem' and local-name() != 'biblio-tag']">
				<item><xsl:value-of select="local-name()"/></item>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="ancestor_tree" select="xalan:nodeset($ancestor_tree_)"/>
		<!-- <debug><xsl:copy-of select="$ancestor_tree"/></debug>
		<debug><ancestor><xsl:value-of select="$ancestor"/></ancestor></debug> -->
		
		<xsl:if test="$ancestor_tree//item[last()][. = $ancestor]">
			<fo:block-container margin-left="11mm" margin-bottom="4pt" id="{@ref_id}">
				
				<xsl:if test="position() = last()">
					<xsl:attribute name="margin-bottom">10pt</xsl:attribute>
				</xsl:if>
				<fo:block-container margin-left="0mm">
					<fo:list-block provisional-distance-between-starts="10mm">
						<fo:list-item>
							<fo:list-item-label end-indent="label-end()">
								<fo:block xsl:use-attribute-sets="note-name-style">注 <fo:inline xsl:use-attribute-sets="fn-num-style"><xsl:value-of select="@current_fn_number"/><fo:inline font-weight="normal">)</fo:inline></fo:inline></fo:block>
							</fo:list-item-label>
							<fo:list-item-body start-indent="body-start()">
								<fo:block>
									<xsl:apply-templates />
								</fo:block>
							</fo:list-item-body>
						</fo:list-item>
					</fo:list-block>
				</fo:block-container>
			</fo:block-container>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'span'][@class = 'surname' or @class = 'givenname' or @class = 'JIS' or @class = 'EffectiveYear' or @class = 'CommentaryEffectiveYear']" mode="update_xml_step1" priority="2">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()" mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'span'][@style = 'font-family:&quot;MS Gothic&quot;']" mode="update_xml_step1" priority="3">
		<xsl:copy>
			<xsl:copy-of select="@*[not(name() = 'style')]"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- remove Annex and (normative) -->
	<xsl:template match="*[local-name() = 'annex']/*[local-name() = 'title']" mode="update_xml_step1" priority="3">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="*[local-name() = 'br'][2]/following-sibling::node()" mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="plateau:clause[@type = 'contributors']//plateau:table//plateau:span[@class = 'surname']/text()[string-length() &lt; 3]" priority="2">
		<xsl:choose>
			<xsl:when test="string-length() = 1">
				<xsl:value-of select="concat(.,'&#x3000;&#x3000;')"/>
			</xsl:when>
			<xsl:when test="string-length() = 2">
				<xsl:value-of select="concat(substring(.,1,1), '&#x3000;', substring(., 2))"/>
			</xsl:when>
		</xsl:choose>
		<xsl:if test="../following-sibling::node()[1][self::plateau:span and @class = 'surname']"> <!-- if no space between surname and given name -->
			<xsl:text>&#x3000;</xsl:text>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="plateau:clause[@type = 'contributors']//plateau:table//plateau:span[@class = 'givenname']/text()[string-length() &lt; 3]" priority="2">
		<xsl:choose>
			<xsl:when test="string-length() = 1">
				<xsl:value-of select="concat('&#x3000;&#x3000;', .)"/>
			</xsl:when>
			<xsl:when test="string-length() = 2">
				<xsl:value-of select="concat(substring(.,1,1), '&#x3000;', substring(., 2))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- space between surname and givenname replace by 'ideographic space' -->
	<!-- and following-sibling::node()[1][self::plateau:span and @class = 'givenname'] -->
	<xsl:template match="plateau:clause[@type = 'contributors']//plateau:table//node()[preceding-sibling::node()[1][self::plateau:span and @class = 'surname']][. = ' ']" priority="2">
		<xsl:text>&#x3000;</xsl:text>
	</xsl:template>
	
	<xsl:template name="makePagedXML">
		<xsl:param name="structured_xml"/>
		<xsl:choose>
			<xsl:when test="not(xalan:nodeset($structured_xml)/*[local-name()='pagebreak'])">
				<xsl:element name="page" namespace="https://www.metanorma.org/ns/plateau">
					<xsl:copy-of select="xalan:nodeset($structured_xml)"/>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="xalan:nodeset($structured_xml)/*[local-name()='pagebreak']">
			
					<xsl:variable name="pagebreak_id" select="generate-id()"/>
					
					<!-- copy elements before pagebreak -->
					<xsl:element name="page" namespace="https://www.metanorma.org/ns/plateau">
						<xsl:if test="not(preceding-sibling::plateau:pagebreak)">
							<xsl:copy-of select="../@*" />
						</xsl:if>
						<!-- copy previous pagebreak orientation -->
						<xsl:copy-of select="preceding-sibling::plateau:pagebreak[1]/@orientation"/>
					
						<xsl:copy-of select="preceding-sibling::node()[following-sibling::plateau:pagebreak[1][generate-id(.) = $pagebreak_id]][not(local-name() = 'pagebreak')]" />
					</xsl:element>
					
					<!-- copy elements after last page break -->
					<xsl:if test="position() = last() and following-sibling::node()">
						<xsl:element name="page" namespace="https://www.metanorma.org/ns/plateau">
							<xsl:copy-of select="@orientation" />
							<xsl:copy-of select="following-sibling::node()" />
						</xsl:element>
					</xsl:if>
	
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ========================= -->
	<!-- Allocate non-Japanese text -->
	<!-- ========================= -->
	
	<!-- <xsl:variable name="regex_en">([^\u2160-\u2188\u25A0-\u25E5\u2F00-\u2FD5\u3000-\u9FFF\uF900-\uFFFF]{1,})</xsl:variable> -->
	<xsl:variable name="regex_en">([^\u2160-\uFFFF]{1,})</xsl:variable>
	
	<xsl:variable name="element_name_font_en">font_en</xsl:variable>
	<xsl:variable name="tag_font_en_open">###<xsl:value-of select="$element_name_font_en"/>###</xsl:variable>
	<xsl:variable name="tag_font_en_close">###/<xsl:value-of select="$element_name_font_en"/>###</xsl:variable>
	<xsl:variable name="element_name_font_en_bold">font_en_bold</xsl:variable>
	<xsl:variable name="tag_font_en_bold_open">###<xsl:value-of select="$element_name_font_en_bold"/>###</xsl:variable>
	<xsl:variable name="tag_font_en_bold_close">###/<xsl:value-of select="$element_name_font_en_bold"/>###</xsl:variable>
	
	<xsl:template match="plateau:p//text()[not(ancestor::plateau:strong)] |
						plateau:dt/text()" mode="update_xml_step1">
		<xsl:variable name="text_en_" select="java:replaceAll(java:java.lang.String.new(.), $regex_en, concat($tag_font_en_open,'$1',$tag_font_en_close))"/>
		<xsl:variable name="text_en"><text><xsl:call-template name="replace_text_tags">
			<xsl:with-param name="tag_open" select="$tag_font_en_open"/>
			<xsl:with-param name="tag_close" select="$tag_font_en_close"/>
			<xsl:with-param name="text" select="$text_en_"/>
		</xsl:call-template></text></xsl:variable>
		<xsl:copy-of select="xalan:nodeset($text_en)/text/node()"/>
	</xsl:template>
	
	<!-- plateau:term/plateau:preferred2//text() | -->
	
	<!-- <name>注記  1</name> to <name>注記<font_en>  1</font_en></name> -->
	<xsl:template match="plateau:title/text() | 
						plateau:note/plateau:name/text() | 
						plateau:termnote/plateau:name/text() |
						plateau:table/plateau:name/text() |
						plateau:figure/plateau:name/text() |
						plateau:termexample/plateau:name/text() |
						plateau:xref//text() |
						plateau:origin/text()" mode="update_xml_step1">
		<xsl:variable name="text_en_" select="java:replaceAll(java:java.lang.String.new(.), $regex_en, concat($tag_font_en_bold_open,'$1',$tag_font_en_bold_close))"/>
		<xsl:variable name="text_en"><text><xsl:call-template name="replace_text_tags">
			<xsl:with-param name="tag_open" select="$tag_font_en_bold_open"/>
			<xsl:with-param name="tag_close" select="$tag_font_en_bold_close"/>
			<xsl:with-param name="text" select="$text_en_"/>
		</xsl:call-template></text></xsl:variable>
		<xsl:copy-of select="xalan:nodeset($text_en)/text/node()"/>
	</xsl:template>
	
	<!-- for $contents -->
	<xsl:template match="title/text()">
		<xsl:variable name="regex_en_contents">([^\u3000-\u9FFF\uF900-\uFFFF\(\)]{1,})</xsl:variable>
		<xsl:variable name="text_en_" select="java:replaceAll(java:java.lang.String.new(.), $regex_en_contents, concat($tag_font_en_bold_open,'$1',$tag_font_en_bold_close))"/>
		<xsl:variable name="text_en"><text><xsl:call-template name="replace_text_tags">
			<xsl:with-param name="tag_open" select="$tag_font_en_bold_open"/>
			<xsl:with-param name="tag_close" select="$tag_font_en_bold_close"/>
			<xsl:with-param name="text" select="$text_en_"/>
		</xsl:call-template></text></xsl:variable>
		<xsl:apply-templates select="xalan:nodeset($text_en)/text/node()"/>
	</xsl:template>
	
	<!-- move example title to the first paragraph -->
	<xsl:template match="plateau:example[contains(plateau:name/text(), ' — ')]" mode="update_xml_step1">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:element name="p" namespace="https://www.metanorma.org/ns/plateau">
				<xsl:value-of select="substring-after(plateau:name/text(), ' — ')"/>
			</xsl:element>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="plateau:example/plateau:name/text()" mode="update_xml_step1">
		<xsl:variable name="example_name">
			<xsl:choose>
				<xsl:when test="contains(., ' — ')"><xsl:value-of select="substring-before(., ' — ')"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="text_en_" select="java:replaceAll(java:java.lang.String.new($example_name), $regex_en, concat($tag_font_en_bold_open,'$1',$tag_font_en_bold_close))"/>
		<xsl:variable name="text_en"><text><xsl:call-template name="replace_text_tags">
			<xsl:with-param name="tag_open" select="$tag_font_en_bold_open"/>
			<xsl:with-param name="tag_close" select="$tag_font_en_bold_close"/>
			<xsl:with-param name="text" select="$text_en_"/>
		</xsl:call-template></text></xsl:variable>
		<xsl:copy-of select="xalan:nodeset($text_en)/text/node()"/>
	</xsl:template>
	
	<xsl:template match="plateau:eref//text()" mode="update_xml_step1">
		<!-- Example: JIS Z 8301:2011 to <font_en_bold>JIS Z 8301</font_en_bold><font_en>:2011</font_en> -->
		<xsl:variable name="parts">
			<xsl:choose>
				<xsl:when test="contains(., ':')">
					<xsl:element name="{$element_name_font_en_bold}"><xsl:value-of select="substring-before(., ':')"/></xsl:element>
					<xsl:element name="{$element_name_font_en}">:<xsl:value-of select="substring-after(., ':')"/></xsl:element>
				</xsl:when>
				<xsl:otherwise>
					<xsl:element name="{$element_name_font_en_bold}"><xsl:value-of select="."/></xsl:element>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:for-each select="xalan:nodeset($parts)/*">
			<xsl:variable name="tag_open">###<xsl:value-of select="local-name()"/>###</xsl:variable>
			<xsl:variable name="tag_close">###/<xsl:value-of select="local-name()"/>###</xsl:variable>
			<xsl:variable name="text_en_" select="java:replaceAll(java:java.lang.String.new(.), $regex_en, concat($tag_open,'$1',$tag_close))"/>
			<xsl:variable name="text_en"><text><xsl:call-template name="replace_text_tags">
				<xsl:with-param name="tag_open" select="$tag_open"/>
				<xsl:with-param name="tag_close" select="$tag_close"/>
				<xsl:with-param name="text" select="$text_en_"/>
			</xsl:call-template></text></xsl:variable>
			<xsl:copy-of select="xalan:nodeset($text_en)/text/node()"/>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="plateau:strong" priority="2" mode="update_xml_step1">
		<xsl:apply-templates mode="update_xml_step1"/>
	</xsl:template>
	<xsl:template match="plateau:strong/text()" priority="2" mode="update_xml_step1">
		<xsl:variable name="text_en_" select="java:replaceAll(java:java.lang.String.new(.), $regex_en, concat($tag_font_en_bold_open,'$1',$tag_font_en_bold_close))"/>
		<xsl:variable name="text_en"><text><xsl:call-template name="replace_text_tags">
			<xsl:with-param name="tag_open" select="$tag_font_en_bold_open"/>
			<xsl:with-param name="tag_close" select="$tag_font_en_bold_close"/>
			<xsl:with-param name="text" select="$text_en_"/>
		</xsl:call-template></text></xsl:variable>
		<xsl:copy-of select="xalan:nodeset($text_en)/text/node()"/>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'font_en_bold'][normalize-space() != '']">
		<xsl:if test="ancestor::*[local-name() = 'td' or local-name() = 'th']"><xsl:value-of select="$zero_width_space"/></xsl:if>
		<fo:inline font-family="Noto Sans Condensed"> <!--  font-weight="bold" -->
			<xsl:if test="ancestor::*[local-name() = 'preferred']">
				<xsl:attribute name="font-weight">normal</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</fo:inline>
		<xsl:if test="ancestor::*[local-name() = 'td' or local-name() = 'th']"><xsl:value-of select="$zero_width_space"/></xsl:if>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'font_en'][normalize-space() != '']">
		<xsl:if test="ancestor::*[local-name() = 'td' or local-name() = 'th']"><xsl:value-of select="$zero_width_space"/></xsl:if>
		<fo:inline>
			<xsl:if test="not(ancestor::plateau:p[@class = 'zzSTDTitle2']) and not(ancestor::plateau:span[@class = 'JIS'])">
				<xsl:attribute name="font-family">Noto Sans Condensed</xsl:attribute>
			</xsl:if>
			<xsl:if test="ancestor::*[local-name() = 'preferred']">
				<xsl:attribute name="font-weight">normal</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</fo:inline>
		<xsl:if test="ancestor::*[local-name() = 'td' or local-name() = 'th']"><xsl:value-of select="$zero_width_space"/></xsl:if>
	</xsl:template>
	
	<!-- ========================= -->
	<!-- END: Allocate non-Japanese text -->
	<!-- ========================= -->
	
	
	<!-- background cover image -->
	<xsl:template name="insertBackgroundPageImage">
		<xsl:param name="number">1</xsl:param>
		<xsl:param name="name">coverpage-image</xsl:param>
		<xsl:variable name="num" select="number($number)"/>
		<!-- background image -->
		<fo:block-container absolute-position="fixed" left="0mm" top="0mm" font-size="0" id="__internal_layout__coverpage_{$name}_{$number}_{generate-id()}">
			<fo:block>
				<xsl:for-each select="/plateau:plateau-standard/plateau:metanorma-extension/plateau:presentation-metadata[plateau:name = $name][1]/plateau:value/plateau:image[$num]">
					<xsl:choose>
						<xsl:when test="*[local-name() = 'svg'] or java:endsWith(java:java.lang.String.new(@src), '.svg')">
							<fo:instream-foreign-object fox:alt-text="Image Front">
								<xsl:attribute name="content-height"><xsl:value-of select="$pageHeight"/>mm</xsl:attribute>
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
								<!-- <xsl:variable name="coverpage" select="concat('url(file:',$basepath, 'coverpage1.png', ')')"/> --> <!-- for DEBUG -->
								<fo:external-graphic src="{$coverpage}" width="{$pageWidth}mm" content-height="scale-to-fit" scaling="uniform" fox:alt-text="Image Front"/>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</fo:block>
		</fo:block-container>
	</xsl:template>
	
	<xsl:template name="getImageURL">
		<xsl:param name="src"/>
		<xsl:choose>
			<xsl:when test="starts-with($src, 'data:image')">
				<xsl:value-of select="$src"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat('url(file:///',$basepath, $src, ')')"/>
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

	
	<xsl:variable name="PLATEAU-Logo">
		<svg id="Layer_1" data-name="Layer 1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 141.72 172.64">
			<defs>
				<style>
					.cls-1 {
						fill: #0c0103;
						fill-rule: evenodd;
						stroke-width: 0px;
					}
				</style>
			</defs>
			<polygon class="cls-1" points="27.54 25.75 60.03 44.51 69.57 50.02 79.53 55.77 91.88 62.9 96.85 65.77 114.18 75.78 114.18 124.32 27.54 74.29 27.54 25.75"/>
			<polygon class="cls-1" points="69.57 0 69.57 47.05 59.39 41.17 28.83 23.52 69.57 0"/>
			<polygon class="cls-1" points="72.15 0 112.9 23.52 91.88 35.66 91.88 59.93 80.04 53.09 72.15 48.53 72.15 0"/>
			<polygon class="cls-1" points="114.18 25.75 114.18 72.8 98.4 63.69 94.45 61.41 94.45 37.14 114.18 25.75"/>
			<polygon class="cls-1" points="0 137.06 2.97 137.06 3.84 137.14 3.84 139.1 2.97 138.96 2.06 138.96 2.06 143.16 2.99 143.16 3.84 142.91 3.84 144.96 2.99 145.06 2.06 145.06 2.06 150.53 0 150.53 0 137.06"/>
			<path class="cls-1" d="m3.84,137.14l.55.05c.51.1,1.04.28,1.53.6,1.13.75,1.68,2.04,1.68,3.27,0,.79-.2,2-1.31,2.95-.54.46-1.11.72-1.68.87l-.77.08v-2.05l1.13-.34c.43-.37.65-.9.65-1.53,0-.56-.17-1.45-1.24-1.86l-.53-.08v-1.96Z"/>
			<polygon class="cls-1" points="21.93 137.06 23.99 137.06 23.99 148.59 27.95 148.59 27.95 150.53 21.93 150.53 21.93 137.06"/>
			<polygon class="cls-1" points="47.63 136.54 47.63 140.87 45.59 145.34 47.63 145.34 47.63 147.28 44.74 147.28 43.27 150.53 41.05 150.53 47.63 136.54"/>
			<polygon class="cls-1" points="47.75 136.28 54.13 150.53 51.91 150.53 50.5 147.28 47.63 147.28 47.63 145.34 49.67 145.34 47.67 140.78 47.63 140.87 47.63 136.54 47.75 136.28"/>
			<polygon class="cls-1" points="65.99 137.07 74.22 137.07 74.22 139 71.13 139 71.13 150.53 69.07 150.53 69.07 139 65.99 139 65.99 137.07"/>
			<polygon class="cls-1" points="88.4 137.07 95.83 137.07 95.83 139 90.46 139 90.46 142.42 95.67 142.42 95.67 144.35 90.46 144.35 90.46 148.59 95.83 148.59 95.83 150.53 88.4 150.53 88.4 137.07"/>
			<polygon class="cls-1" points="114.26 136.53 114.26 140.87 112.23 145.34 114.26 145.34 114.26 147.28 111.38 147.28 109.9 150.53 107.68 150.53 114.26 136.53"/>
			<polygon class="cls-1" points="114.38 136.28 120.77 150.53 118.54 150.53 117.13 147.28 114.26 147.28 114.26 145.34 116.3 145.34 114.3 140.78 114.26 140.87 114.26 136.53 114.38 136.28"/>
			<path class="cls-1" d="m131.75,137.06h2.06v8.12c0,.73.02,1.62.42,2.32.41.69,1.32,1.4,2.51,1.4s2.1-.71,2.5-1.4c.4-.7.42-1.59.42-2.32v-8.12h2.06v8.67c0,1.07-.22,2.36-1.25,3.49-.7.77-1.9,1.58-3.73,1.58s-3.03-.81-3.74-1.58c-1.03-1.13-1.25-2.42-1.25-3.49v-8.67Z"/>
			<path class="cls-1" d="m37.65,161.31h1.7v3.94c.22-.29.48-.48.77-.6l.46-.09v1.39l-.96.39c-.2.21-.37.52-.37.97s.19.75.39.94l.94.38v1.37l-.65-.16c-.26-.15-.45-.36-.58-.55v.64h-1.7v-8.62Z"/>
			<path class="cls-1" d="m40.99,164.48c.73,0,1.38.27,1.84.71.51.49.82,1.21.82,2.08,0,.82-.28,1.57-.82,2.12-.46.47-1.03.72-1.81.72l-.44-.11v-1.37h.02c.3,0,.63-.11.89-.35.25-.24.42-.58.42-.97,0-.43-.17-.77-.42-1.01-.27-.26-.57-.35-.91-.35v-1.39l.41-.08Z"/>
			<polygon class="cls-1" points="47.39 164.66 49.35 164.66 50.84 167.52 52.3 164.66 54.21 164.66 49.97 172.64 48.05 172.64 49.91 169.26 47.39 164.66"/>
			<polygon class="cls-1" points="66.6 162.05 68.11 162.05 70.07 166.76 72.03 162.05 73.55 162.05 74.81 169.93 72.99 169.93 72.36 165.23 70.39 169.93 69.75 169.93 67.78 165.23 67.15 169.93 65.33 169.93 66.6 162.05"/>
			<polygon class="cls-1" points="80.9 162.05 82.72 162.05 82.72 168.39 85.16 168.39 85.16 169.93 80.9 169.93 80.9 162.05"/>
			<polyline class="cls-1" points="91.43 162.05 93.25 162.05 93.25 169.93 91.43 169.93 91.43 162.05"/>
			<polygon class="cls-1" points="99.44 162.05 104.69 162.05 104.69 163.58 102.98 163.58 102.98 169.93 101.16 169.93 101.16 163.58 99.44 163.58 99.44 162.05"/>
		</svg>
	</xsl:variable>
	
</xsl:stylesheet>
