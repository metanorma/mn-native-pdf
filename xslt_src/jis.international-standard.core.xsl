<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
											xmlns:fo="http://www.w3.org/1999/XSL/Format" 
											xmlns:jis="https://www.metanorma.org/ns/jis" 
											xmlns:mathml="http://www.w3.org/1998/Math/MathML" 
											xmlns:xalan="http://xml.apache.org/xalan" 
											xmlns:fox="http://xmlgraphics.apache.org/fop/extensions" 
											xmlns:pdf="http://xmlgraphics.apache.org/fop/extensions/pdf"
											xmlns:xlink="http://www.w3.org/1999/xlink"
											xmlns:java="http://xml.apache.org/xalan/java"
											xmlns:jeuclid="http://jeuclid.sf.net/ns/ext"
											xmlns:barcode="http://barcode4j.krysalis.org/ns" 
											exclude-result-prefixes="java"
											version="1.0">

	<xsl:output method="xml" encoding="UTF-8" indent="no"/>
		
	<xsl:include href="./common.xsl"/>

	<xsl:key name="kfn" match="*[local-name() = 'fn'][not(ancestor::*[(local-name() = 'table' or local-name() = 'figure' or local-name() = 'localized-strings')] and not(ancestor::*[local-name() = 'name']))]" use="@reference"/>
	
	<xsl:variable name="namespace">jis</xsl:variable>
	
	<xsl:variable name="namespace_full">https://www.metanorma.org/ns/jis</xsl:variable>
	
	<xsl:variable name="debug">false</xsl:variable>
	
	<xsl:variable name="contents_">
		<xsl:variable name="bundle" select="count(//jis:jis-standard) &gt; 1"/>
		
		<xsl:if test="normalize-space($bundle) = 'true'">
			<collection firstpage_id="firstpage_id_0"/>
		</xsl:if>
		
		<xsl:for-each select="//jis:jis-standard">
			<xsl:variable name="num"><xsl:number level="any" count="jis:jis-standard"/></xsl:variable>
			<xsl:variable name="docnumber"><xsl:value-of select="jis:bibdata/jis:docidentifier[@type = 'JIS']"/></xsl:variable>
			<xsl:variable name="current_document">
				<xsl:copy-of select="."/>
			</xsl:variable>
			
			<xsl:for-each select="xalan:nodeset($current_document)"> <!-- . -->
				<doc num="{$num}" firstpage_id="firstpage_id_{$num}" title-part="{$docnumber}" bundle="{$bundle}"> <!-- 'bundle' means several different documents (not language versions) in one xml -->
					<contents>
						<!-- <xsl:call-template name="processPrefaceSectionsDefault_Contents"/> -->
						
						<xsl:call-template name="processMainSectionsDefault_Contents"/>
						
						<xsl:apply-templates select="//jis:indexsect" mode="contents"/>

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
					<fo:region-body margin-top="28.5mm" margin-bottom="25mm" margin-left="22mm" margin-right="22mm"/>
					<fo:region-before region-name="header" extent="28.5mm"/>
					<fo:region-after region-name="footer" extent="25mm"/>
					<fo:region-start region-name="left-region" extent="22mm"/>
					<fo:region-end region-name="right-region" extent="22mm"/>
				</fo:simple-page-master>
			
				<fo:simple-page-master master-name="first_page" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
					<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
					<fo:region-before region-name="header" extent="{$marginTop}mm"/>
					<fo:region-after region-name="footer" extent="{$marginBottom}mm"/>
					<fo:region-start region-name="left-region" extent="{$marginLeftRight1}mm"/>
					<fo:region-end region-name="right-region" extent="{$marginLeftRight2}mm"/>
				</fo:simple-page-master>
				<fo:simple-page-master master-name="odd" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
					<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
					<fo:region-before region-name="header-odd" extent="{$marginTop}mm"/>
					<fo:region-after region-name="footer" extent="{$marginBottom}mm"/>
					<fo:region-start region-name="left-region" extent="{$marginLeftRight1}mm"/>
					<fo:region-end region-name="right-region" extent="{$marginLeftRight2}mm"/>
				</fo:simple-page-master>
				<fo:simple-page-master master-name="even" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
					<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
					<fo:region-before region-name="header-even" extent="{$marginTop}mm"/>
					<fo:region-after region-name="footer" extent="{$marginBottom}mm"/>
					<fo:region-start region-name="left-region" extent="{$marginLeftRight1}mm"/>
					<fo:region-end region-name="right-region" extent="{$marginLeftRight2}mm"/>
				</fo:simple-page-master>
				
				<fo:page-sequence-master master-name="document_preface">
					<fo:repeatable-page-master-alternatives>
						<fo:conditional-page-master-reference odd-or-even="even" master-reference="even"/>
						<fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd"/>
					</fo:repeatable-page-master-alternatives>
				</fo:page-sequence-master>
				
				<fo:page-sequence-master master-name="document_first_section">
					<fo:repeatable-page-master-alternatives>
						<fo:conditional-page-master-reference page-position="first" master-reference="first_page"/>
						<fo:conditional-page-master-reference odd-or-even="even" master-reference="even"/>
						<fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd"/>
					</fo:repeatable-page-master-alternatives>
				</fo:page-sequence-master>
				
				<fo:page-sequence-master master-name="document">
					<fo:repeatable-page-master-alternatives>
						<fo:conditional-page-master-reference odd-or-even="even" master-reference="even"/>
						<fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd"/>
					</fo:repeatable-page-master-alternatives>
				</fo:page-sequence-master>
			
				<!-- landscape -->
				<fo:simple-page-master master-name="odd-landscape" page-width="{$pageHeight}mm" page-height="{$pageWidth}mm">
					<fo:region-body margin-top="{$marginLeftRight1}mm" margin-bottom="{$marginLeftRight2}mm" margin-left="{$marginBottom}mm" margin-right="{$marginTop}mm"/>
					<fo:region-before region-name="header" extent="{$marginLeftRight1}mm" precedence="true"/>
					<fo:region-after region-name="footer" extent="{$marginLeftRight2}mm" precedence="true"/>
					<fo:region-start region-name="left-region-landscape" extent="{$marginBottom}mm"/>
					<fo:region-end region-name="right-region-landscape" extent="{$marginTop}mm"/>
				</fo:simple-page-master>
				<fo:simple-page-master master-name="even-landscape" page-width="{$pageHeight}mm" page-height="{$pageWidth}mm">
					<fo:region-body margin-top="{$marginLeftRight2}mm" margin-bottom="{$marginLeftRight1}mm" margin-left="{$marginBottom}mm" margin-right="{$marginTop}mm"/>
					<fo:region-before region-name="header" extent="{$marginLeftRight2}mm" precedence="true"/>
					<fo:region-after region-name="footer" extent="{$marginLeftRight1}mm" precedence="true"/>
					<fo:region-start region-name="left-region-landscape" extent="{$marginBottom}mm"/>
					<fo:region-end region-name="right-region-landspace" extent="{$marginTop}mm"/>
				</fo:simple-page-master>
				<fo:page-sequence-master master-name="document-landscape">
					<fo:repeatable-page-master-alternatives>
						<fo:conditional-page-master-reference odd-or-even="even" master-reference="even-landscape"/>
						<fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd-landscape"/>
					</fo:repeatable-page-master-alternatives>
				</fo:page-sequence-master>
			
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
			
			<xsl:variable name="updated_xml_step2_">
				<xsl:apply-templates select="xalan:nodeset($updated_xml_step1)" mode="update_xml_step2"/>
			</xsl:variable>
			<xsl:variable name="updated_xml_step2" select="xalan:nodeset($updated_xml_step2_)"/>
			<!-- DEBUG: updated_xml_step2=<xsl:copy-of select="$updated_xml_step2"/> -->
			
			
			<xsl:for-each select="$updated_xml_step2//jis:jis-standard">
				<xsl:variable name="num"><xsl:number level="any" count="jis:jis-standard"/></xsl:variable>
				
				<xsl:variable name="current_document">
					<xsl:copy-of select="."/>
				</xsl:variable>
				
				<xsl:for-each select="xalan:nodeset($current_document)">
				
					<xsl:variable name="docnumber" select="/*/jis:bibdata/jis:docnumber"/>
				
					<xsl:variable name="year_published" select="substring(/*/jis:bibdata/jis:date[@type = 'published']/jis:on, 1, 4)"/>
					
					<xsl:variable name="docidentifier">
						<fo:inline><xsl:value-of select="$docnumber"/></fo:inline>
						<fo:inline font-family="IPAexGothic">：</fo:inline>
						<fo:inline><xsl:value-of select="$year_published"/></fo:inline>
					</xsl:variable>
					
					
					<xsl:variable name="copyrightText">著作権法により無断での複製，転載等は禁止されております。</xsl:variable>
				
					<xsl:variable name="doctype" select="/*/jis:bibdata/jis:ext/jis:doctype"/>
					
					<xsl:variable name="title_ja" select="/*/jis:bibdata/jis:title[@language = 'ja' and @type = 'main']"/>
					<xsl:variable name="title_en" select="/*/jis:bibdata/jis:title[@language = 'en' and @type = 'main']"/>
				
					<xsl:call-template name="insertCoverPage">
						<xsl:with-param name="num" select="$num"/>
						<xsl:with-param name="copyrightText" select="$copyrightText"/>
					</xsl:call-template>
										
					<xsl:call-template name="insertInnerCoverPage">
						<xsl:with-param name="docidentifier" select="$docidentifier"/>
						<xsl:with-param name="copyrightText" select="$copyrightText"/>
					</xsl:call-template>
				
				
					<!-- ========================== -->
					<!-- Contents and preface pages -->
					<!-- ========================== -->
					
					<fo:page-sequence master-reference="document_preface" initial-page-number="1" force-page-count="no-force">
						
						
						<xsl:call-template name="insertHeaderFooter">
							<xsl:with-param name="docidentifier" select="$docidentifier"/>
							<xsl:with-param name="copyrightText" select="$copyrightText"/>
							<xsl:with-param name="section">preface</xsl:with-param>
						</xsl:call-template>
						
						<fo:flow flow-name="xsl-region-body">
						
							<xsl:if test="$debug = 'true'">
								<xsl:text disable-output-escaping="yes">&lt;!--</xsl:text>
									DEBUG
									contents=<xsl:copy-of select="$contents"/>
								<xsl:text disable-output-escaping="yes">--&gt;</xsl:text>
							</xsl:if>
							
							<fo:block text-align="center" font-size="14pt" font-family="IPAexGothic" margin-top="8.5mm">
								<!-- Contents -->
								<!-- <xsl:call-template name="getLocalizedString">
									<xsl:with-param name="key">table_of_contents</xsl:with-param>
								</xsl:call-template> -->
								<xsl:text>目 次</xsl:text>
							</fo:block>
							
							<fo:block text-align="right" font-size="8pt" font-family="IPAexMincho" margin-top="10mm">
								<!-- Page -->
								<!-- <xsl:call-template name="getLocalizedString">
									<xsl:with-param name="key">locality.page</xsl:with-param>
								</xsl:call-template> -->
								<xsl:text>ページ</xsl:text>
							</fo:block>
						
							<fo:block role="TOC" font-family="IPAexGothic">
								<xsl:if test="$contents/doc[@num = $num]//item[@display = 'true']">
									<xsl:for-each select="$contents/doc[@num = $num]//item[@display = 'true'][@level &lt;= $toc_level or @type='figure' or @type = 'table']">
										<fo:block role="TOCI">
											<xsl:choose>
												<xsl:when test="@type = 'bibliography'">
												</xsl:when>
												<xsl:when test="@type = 'annex'">
													<fo:block space-after="5pt">
														<xsl:call-template name="insertTocItem"/>
													</fo:block>
												</xsl:when>
												<xsl:otherwise>
													<fo:list-block space-after="5pt">
														<xsl:attribute name="provisional-distance-between-starts">
															<xsl:choose>
																<xsl:when test="string-length(@section) = 1">5mm</xsl:when>
																<xsl:when test="string-length(@section) &gt;= 2"><xsl:value-of select="5 + (string-length(@section) - 1) * 2"/>mm</xsl:when>
																<xsl:when test="@type = 'annex'">16mm</xsl:when>
																<xsl:otherwise>5mm</xsl:otherwise>
															</xsl:choose>
														</xsl:attribute>
														<fo:list-item>
															<fo:list-item-label end-indent="label-end()">
																<fo:block>
																	<xsl:if test="@section != '' and @type != 'annex'">
																		<xsl:attribute name="font-family">Times New Roman</xsl:attribute>
																		<xsl:attribute name="font-weight">bold</xsl:attribute>
																	</xsl:if>
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
							
						</fo:flow>
						
					</fo:page-sequence>
					
					
					<xsl:variable name="structured_xml_preface">

						<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name() = 'foreword']" mode="linear_xml" />
						
					</xsl:variable>
					
					<!-- structured_xml_preface=<xsl:copy-of select="$structured_xml_preface"/> -->
					
					<xsl:variable name="paged_xml_preface_">
						<xsl:call-template name="makePagedXML">
							<xsl:with-param name="structured_xml" select="$structured_xml_preface"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:variable name="paged_xml_preface" select="xalan:nodeset($paged_xml_preface_)"/>
					
					<xsl:if test="$paged_xml_preface/*[local-name()='page'] and count($paged_xml_preface/*[local-name()='page']/*) != 0">
						<!-- BSI Preface pages -->
						<fo:page-sequence master-reference="document_preface" force-page-count="no-force">
							
							<fo:static-content flow-name="xsl-footnote-separator">
								<fo:block text-align="center" margin-bottom="6pt">
									<fo:leader leader-pattern="rule" leader-length="80mm"/>
								</fo:block>
							</fo:static-content>
							
							<xsl:call-template name="insertHeaderFooter">
								<xsl:with-param name="docidentifier" select="$docidentifier"/>
								<xsl:with-param name="copyrightText" select="$copyrightText"/>
								<xsl:with-param name="section">preface</xsl:with-param>
							</xsl:call-template>
							
							<fo:flow flow-name="xsl-region-body">
							
								<fo:block>
									<xsl:for-each select="$paged_xml_preface/*[local-name()='page']">
										<xsl:if test="position() != 1">
											<fo:block break-after="page"/>
										</xsl:if>
										<xsl:apply-templates select="*" mode="page"/>
									</xsl:for-each>
								</fo:block>
							</fo:flow>
						</fo:page-sequence> <!-- END BSI Preface pages -->
					</xsl:if>
					
					
					<!-- Document type rendering -->
					<fo:page-sequence master-reference="document_preface" force-page-count="no-force">
						<xsl:call-template name="insertHeaderFooter">
							<xsl:with-param name="docidentifier" select="$docidentifier"/>
							<xsl:with-param name="copyrightText" select="$copyrightText"/>
							<xsl:with-param name="section">preface</xsl:with-param>
						</xsl:call-template>
						
						<fo:flow flow-name="xsl-region-body">
							<fo:block-container margin-left="70mm">
								<fo:block-container margin-left="0mm" margin-top="30mm" width="26.5mm" height="8.5mm" text-align="center" display-align="center" border="1pt solid black">
									<fo:block>
										<xsl:text>白 紙</xsl:text>
									</fo:block>
								</fo:block-container>
							</fo:block-container>
						</fo:flow>
					</fo:page-sequence>
					
					<!-- ========================== -->
					<!-- END Contents and preface pages -->
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
						<xsl:for-each select="/*/*[local-name()='annex']">
							<item>
								<xsl:apply-templates select="." mode="linear_xml"/>
							</item>
						</xsl:for-each>
						
						<!-- Bibliography -->
						<xsl:for-each select="/*/*[local-name()='bibliography']/*[count(.//*[local-name() = 'bibitem'][not(@hidden) = 'true']) &gt; 0 and not(@hidden = 'true')]">
							<item><xsl:apply-templates select="." mode="linear_xml"/></item>
						</xsl:for-each>
						
						<item>
							<xsl:copy-of select="//jis:indexsect" />
						</item>
						
					</xsl:variable>
					
					<!-- page break before each section -->
					<xsl:variable name="structured_xml">
						<xsl:for-each select="xalan:nodeset($structured_xml_)/item[*]">
							<xsl:element name="pagebreak" namespace="https://www.metanorma.org/ns/jis"/>
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
						<fo:page-sequence master-reference="document" force-page-count="no-force">
							<xsl:if test="position() = 1">
								<xsl:attribute name="master-reference">document_first_section</xsl:attribute>
							</xsl:if>
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
							
							<xsl:call-template name="insertHeaderFooter">
								<xsl:with-param name="docidentifier" select="$docidentifier"/>
								<xsl:with-param name="copyrightText" select="$copyrightText"/>
								<xsl:with-param name="section">main</xsl:with-param>
							</xsl:call-template>
							
							<fo:flow flow-name="xsl-region-body">
								
								<xsl:if test="position() = 1">
									<fo:table table-layout="fixed" width="100%">
										<fo:table-column column-width="proportional-column-width(35)"/>
										<fo:table-column column-width="proportional-column-width(97)"/>
										<fo:table-column column-width="proportional-column-width(23)"/>
										<fo:table-column column-width="proportional-column-width(12)"/>
										<fo:table-body>
											<fo:table-row>
												<fo:table-cell><fo:block></fo:block></fo:table-cell>
												<fo:table-cell font-family="IPAexGothic" font-size="14pt" text-align="center">
													<fo:block>
														<xsl:call-template name="getLocalizedString">
															<xsl:with-param name="key">doctype_dict.<xsl:value-of select="$doctype"/></xsl:with-param>
														</xsl:call-template>
													</fo:block>
													</fo:table-cell>
												<fo:table-cell text-align="right">
													<fo:block font-family="Arial" font-size="16pt">
														<xsl:value-of select="java:replaceAll(java:java.lang.String.new($docnumber), '^(JIS)(.*)', '$1')"/>
														<fo:block/>
														<xsl:value-of select="java:replaceAll(java:java.lang.String.new($docnumber), '^(JIS)?(.*)', '$2')"/>
													</fo:block>
												</fo:table-cell>
												<fo:table-cell display-align="after">
													<fo:block font-size="10pt">
														<fo:inline baseline-shift="40%">
															<fo:inline font-family="IPAexMincho">：</fo:inline><fo:inline font-family="Times New Roman"><xsl:value-of select="$year_published"/></fo:inline>
														</fo:inline>
													</fo:block>
												</fo:table-cell>
												
											</fo:table-row>
										</fo:table-body>
									</fo:table>
									
									<fo:block font-family="IPAexGothic" font-size="19pt" text-align="center" margin-top="12mm" margin-bottom="4mm"><xsl:value-of select="$title_ja"/></fo:block>
									<fo:block font-family="Arial" font-size="13pt" text-align="center" margin-bottom="10mm"><xsl:value-of select="$title_en"/></fo:block>
									
								</xsl:if>
								
								
								<xsl:apply-templates select="*" mode="page"/>
								
							</fo:flow>
						</fo:page-sequence>
					</xsl:for-each>
					
					
				
				</xsl:for-each>
			
			</xsl:for-each>
			
			<xsl:if test="not(//jis:jis-standard)">
				<fo:page-sequence master-reference="document" force-page-count="no-force">
					<fo:flow flow-name="xsl-region-body">
						<fo:block><!-- prevent fop error for empty document --></fo:block>
					</fo:flow>
				</fo:page-sequence>
			</xsl:if>
			
		</fo:root>
	</xsl:template>
	
	<xsl:template name="insertTocItem">
		<fo:block text-align-last="justify" role="TOCI">
			<fo:basic-link internal-destination="{@id}" fox:alt-text="{title}">
				<fo:inline><xsl:apply-templates select="title" /></fo:inline>
				<fo:inline keep-together.within-line="always">
					<fo:leader leader-pattern="dots"/>
					<fo:inline font-size="8pt" font-family="Times New Roman">
						<fo:page-number-citation ref-id="{@id}"/>
					</fo:inline>
				</fo:inline>
			</fo:basic-link>
		</fo:block>
	</xsl:template>
	
	
	<xsl:template name="insertCoverPage">
		<xsl:param name="num"/>
		<xsl:param name="copyrightText"/>
		<fo:page-sequence master-reference="cover-page" force-page-count="no-force">
			<xsl:call-template name="insertFooter">
				<xsl:with-param name="copyrightText" select="$copyrightText"/>
			</xsl:call-template>
				
			<fo:flow flow-name="xsl-region-body">
				<!-- JIS -->
				<fo:block id="firstpage_id_{$num}">
					<fo:instream-foreign-object content-width="81mm" fox:alt-text="JIS Logo">
						<xsl:copy-of select="$JIS-Logo"/>
					</fo:instream-foreign-object>
				</fo:block>
				
				<fo:block-container text-align="center">
					<!-- title -->
					<fo:block role="H1" font-family="IPAexGothic" font-size="22pt" margin-top="27mm"><xsl:apply-templates select="/*/jis:bibdata/jis:title[@language = 'ja' and @type = 'main']/node()"/></fo:block>
					<!-- docidentifier, 3 part: number, colon and year-->
					<fo:block font-family="IPAexGothic" font-size="20pt" margin-top="15mm"><fo:inline font-family="Arial">JIS Z 8301</fo:inline><fo:inline baseline-shift="20%"><fo:inline font-size="10pt">：</fo:inline><fo:inline font-family="Times New Roman" font-size="10pt">2019</fo:inline></fo:inline></fo:block>
					<fo:block font-family="Arial" font-size="14pt" margin-top="12mm"><fo:inline font-family="IPAexMincho">（</fo:inline>JSA<fo:inline font-family="IPAexMincho">）</fo:inline></fo:block>
				</fo:block-container>
				
				<fo:block-container absolute-position="fixed" left="0mm" top="200mm" height="69mm" text-align="center" display-align="after" font-family="IPAexMincho">
					<!-- Revised on July 22, 2019 -->
					<fo:block font-size="9pt">令和元年<fo:inline font-family="Times New Roman"> 7 </fo:inline>月<fo:inline font-family="Times New Roman"> 22 </fo:inline>日 改正</fo:block>
					<!-- Japan Industrial Standards Survey Council deliberations -->
					<fo:block font-size="14pt" margin-top="7mm">日本産業標準調査会 審議</fo:block>
					<!-- (Issued by the Japan Standards Association) -->
					<fo:block font-size="9pt" margin-top="6.5mm">（日本規格協会 発行）</fo:block>
				</fo:block-container>
			</fo:flow>
		</fo:page-sequence>
	</xsl:template> <!-- insertCoverPage -->
	
	<xsl:template name="insertInnerCoverPage">
		<xsl:param name="docidentifier"/>
		<xsl:param name="copyrightText"/>
		<fo:page-sequence master-reference="document" force-page-count="no-force">
		
			<fo:static-content flow-name="xsl-footnote-separator">
				<fo:block text-align="center" margin-bottom="6pt">
					<fo:leader leader-pattern="rule" leader-length="80mm"/>
				</fo:block>
			</fo:static-content>
			
			<xsl:call-template name="insertHeaderFooter">
				<xsl:with-param name="docidentifier" select="$docidentifier"/>
				<xsl:with-param name="copyrightText" select="$copyrightText"/>
			</xsl:call-template>
				
			<fo:flow flow-name="xsl-region-body">
				<fo:block-container font-size="9pt" margin-top="5mm">
					
					<xsl:apply-templates select="/*/*[local-name() = 'preface']/*[local-name() = 'clause'][@type = 'contributors']" />
					
					<fo:block>
						<fo:footnote>
							<fo:inline></fo:inline>
							<fo:footnote-body>
								<fo:block font-size="8.5pt">
									<xsl:apply-templates select="/*/*[local-name() = 'preface']/*[local-name() = 'clause'][@type = 'inner-cover-note']/*[not(local-name() = 'title')]" />
								</fo:block>
							</fo:footnote-body>
						</fo:footnote>
					</fo:block>
				</fo:block-container>
			</fo:flow>
		</fo:page-sequence>
	</xsl:template> <!-- insertInnerCoverPage -->
	
	<!-- ============================= -->
	<!-- CONTENTS                      -->
	<!-- ============================= -->
	
	<!-- element with title -->
	<xsl:template match="*[jis:title]" mode="contents">
	
		<xsl:variable name="level">
			<xsl:call-template name="getLevel">
				<xsl:with-param name="depth" select="jis:title/@depth"/>
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
				<xsl:when test="(ancestor-or-self::jis:bibliography and local-name() = 'clause' and not(.//*[local-name() = 'references' and @normative='true'])) or self::jis:references[not(@normative) or @normative='false']">bibliography</xsl:when>
				<xsl:otherwise><xsl:value-of select="local-name()"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
			
		<xsl:variable name="display">
			<xsl:choose>
				<xsl:when test="normalize-space(@id) = ''">false</xsl:when>
				<xsl:when test="ancestor-or-self::jis:annex and $level &gt;= 2">false</xsl:when>
				<xsl:when test="$type = 'bibliography' and $level &gt;= 2">false</xsl:when>
				<xsl:when test="$type = 'bibliography'">true</xsl:when>
				<xsl:when test="$type = 'references' and $level &gt;= 2">false</xsl:when>
				<xsl:when test="ancestor-or-self::jis:colophon">true</xsl:when>
				<xsl:when test="$section = '' and $type = 'clause' and $level = 1 and ancestor::jis:preface">true</xsl:when>
				<xsl:when test="$section = '' and $type = 'clause'">false</xsl:when>
				<xsl:when test="$level &lt;= $toc_level">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="skip">
			<xsl:choose>
				<xsl:when test="ancestor-or-self::jis:bibitem">true</xsl:when>
				<xsl:when test="ancestor-or-self::jis:term">true</xsl:when>				
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
				<xsl:if test="ancestor-or-self::jis:preface">preface</xsl:if>
				<xsl:if test="ancestor-or-self::jis:annex">annex</xsl:if>
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
	
	
	<xsl:template match="jis:title" priority="2" name="title">
	
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		
		<xsl:variable name="font-family">IPAexGothic</xsl:variable>
		
		<xsl:variable name="font-size">
			<xsl:choose>
				<xsl:when test="@type = 'section-title'">18pt</xsl:when>
				<xsl:when test="@ancestor = 'foreword' and $level = '1'">14pt</xsl:when>
				<xsl:when test="@ancestor = 'annex' and $level = '1'">14pt</xsl:when>
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
		
		<xsl:variable name="font-weight">normal</xsl:variable>
		
		<xsl:variable name="text-align">
			<xsl:choose>
				<xsl:when test="@ancestor = 'foreword' and $level = 1">center</xsl:when>
				<xsl:when test="@ancestor = 'annex' and $level = 1">center</xsl:when>
				<xsl:otherwise>left</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		
		<xsl:variable name="margin-top">
			<xsl:choose>
				<xsl:when test="@ancestor = 'foreword' and $level = 1">9mm</xsl:when>
				<xsl:when test="$level = 1">4.5mm</xsl:when>
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
				<xsl:when test="$level = 1">12pt</xsl:when>
				<xsl:when test="$level &gt;= 2">12pt</xsl:when>
				<xsl:when test="@type = 'section-title'">6mm</xsl:when>
				<xsl:when test="@inline-header = 'true'">0pt</xsl:when>
				<xsl:when test="@ancestor = 'annex' and $level = 1">6mm</xsl:when>
				<xsl:otherwise>0mm</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
	

		<!-- to space-before Foreword -->
		<xsl:if test="@ancestor = 'foreword' and $level = '1'"><fo:block></fo:block></xsl:if>
	

		<xsl:choose>
			<xsl:when test="@inline-header = 'true' and following-sibling::*[1][self::jis:p]">
				<fo:block role="H{$level}">
					<xsl:for-each select="following-sibling::*[1][self::jis:p]">
						<xsl:call-template name="paragraph">
							<xsl:with-param name="inline-header">true</xsl:with-param>
						</xsl:call-template>
					</xsl:for-each>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="{$element-name}">
					<xsl:attribute name="font-family"><xsl:value-of select="$font-family"/></xsl:attribute>
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
						<fo:inline font-family="Times New Roman" font-weight="bold">
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
	
	<xsl:template match="jis:p" name="paragraph">
		<xsl:param name="inline-header">false</xsl:param>
		<xsl:param name="split_keep-within-line"/>
		
		<xsl:choose>
		
			<xsl:when test="preceding-sibling::*[1][self::jis:title]/@inline-header = 'true' and $inline-header = 'false'"/> <!-- paragraph displayed in title template -->
			
			<xsl:otherwise>
			
				<xsl:variable name="previous-element" select="local-name(preceding-sibling::*[1])"/>
				<xsl:variable name="element-name">fo:block</xsl:variable>
				
				<xsl:element name="{$element-name}">
					<xsl:call-template name="setBlockAttributes">
						<xsl:with-param name="text_align_default">justify</xsl:with-param>
					</xsl:call-template>
					<xsl:attribute name="margin-bottom">10pt</xsl:attribute>
					
					<xsl:if test="not(parent::jis:note or parent::jis:li or ancestor::jis:table)">
						<xsl:attribute name="text-indent"><xsl:value-of select="$text_indent"/>mm</xsl:attribute>
					</xsl:if>
					
					<xsl:copy-of select="@id"/>
					
					<xsl:attribute name="line-height">1.5</xsl:attribute>
					<!-- bookmarks only in paragraph -->
				
					<xsl:if test="count(jis:bookmark) != 0 and count(*) = count(jis:bookmark) and normalize-space() = ''">
						<xsl:attribute name="font-size">0</xsl:attribute>
						<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
						<xsl:attribute name="line-height">0</xsl:attribute>
					</xsl:if>

					<xsl:if test="ancestor::*[@key = 'true']">
						<xsl:attribute name="margin-bottom">2pt</xsl:attribute>
					</xsl:if>
					
					<xsl:if test="parent::jis:definition">
						<xsl:attribute name="margin-bottom">2pt</xsl:attribute>
					</xsl:if>
					
					<xsl:if test="parent::jis:li or following-sibling::*[1][self::jis:ol or self::jis:ul]">
						<xsl:attribute name="margin-bottom">4pt</xsl:attribute>
					</xsl:if>
					
					
					<xsl:apply-templates>
						<xsl:with-param name="split_keep-within-line" select="$split_keep-within-line"/>
					</xsl:apply-templates>
				</xsl:element>
				<xsl:if test="$element-name = 'fo:inline' and not(local-name(..) = 'admonition')"> <!-- and not($inline = 'true')  -->
					<fo:block margin-bottom="12pt">
						 <xsl:if test="ancestor::jis:annex or following-sibling::jis:table">
							<xsl:attribute name="margin-bottom">0</xsl:attribute>
						 </xsl:if>
						<xsl:value-of select="$linebreak"/>
					</fo:block>
				</xsl:if>
		
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<xsl:template match="jis:termnote" priority="2">
		<fo:block id="{@id}" xsl:use-attribute-sets="termnote-style">
			<xsl:attribute name="text-indent">0mm</xsl:attribute>
			<xsl:attribute name="space-before">2pt</xsl:attribute>
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
	
	
	
	<xsl:template name="makePagedXML">
		<xsl:param name="structured_xml"/>
		<xsl:choose>
			<xsl:when test="not(xalan:nodeset($structured_xml)/*[local-name()='pagebreak'])">
				<xsl:element name="page" namespace="https://www.metanorma.org/ns/jis">
					<xsl:copy-of select="xalan:nodeset($structured_xml)"/>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="xalan:nodeset($structured_xml)/*[local-name()='pagebreak']">
			
					<xsl:variable name="pagebreak_id" select="generate-id()"/>
					
					<!-- copy elements before pagebreak -->
					<xsl:element name="page" namespace="https://www.metanorma.org/ns/jis">
						<xsl:if test="not(preceding-sibling::jis:pagebreak)">
							<xsl:copy-of select="../@*" />
						</xsl:if>
						<!-- copy previous pagebreak orientation -->
						<xsl:copy-of select="preceding-sibling::jis:pagebreak[1]/@orientation"/>
					
						<xsl:copy-of select="preceding-sibling::node()[following-sibling::jis:pagebreak[1][generate-id(.) = $pagebreak_id]][not(local-name() = 'pagebreak')]" />
					</xsl:element>
					
					<!-- copy elements after last page break -->
					<xsl:if test="position() = last() and following-sibling::node()">
						<xsl:element name="page" namespace="https://www.metanorma.org/ns/jis">
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
	
	<xsl:variable name="regex_en">([^\u3000-\u9FFF\uF900-\uFFFF]{1,})</xsl:variable>
	
	<xsl:template match="jis:p//text()" mode="update_xml_step1">
		<xsl:variable name="element_name_font_en">font_en</xsl:variable>
		<xsl:variable name="tag_font_en_open">###<xsl:value-of select="$element_name_font_en"/>###</xsl:variable>
		<xsl:variable name="tag_font_en_close">###/<xsl:value-of select="$element_name_font_en"/>###</xsl:variable>
		<xsl:variable name="text_en_" select="java:replaceAll(java:java.lang.String.new(.), $regex_en, concat($tag_font_en_open,'$1',$tag_font_en_close))"/>
		<xsl:variable name="text_en"><text><xsl:call-template name="replace_text_tags">
			<xsl:with-param name="tag_open" select="$tag_font_en_open"/>
			<xsl:with-param name="tag_close" select="$tag_font_en_close"/>
			<xsl:with-param name="text" select="$text_en_"/>
		</xsl:call-template></text></xsl:variable>
		<xsl:copy-of select="xalan:nodeset($text_en)/text/node()"/>
	</xsl:template>
	
	<!-- <name>注記  1</name> to <name>注記<font_en>  1</font_en></name> -->
	<xsl:template match="jis:note/jis:name/text() | 
						jis:term/jis:preferred//text() |
						jis:termnote/jis:name/text() |
						jis:table/jis:name/text() |
						jis:example/jis:name/text() | 
						jis:termexample/jis:name/text() |
						jis:xref//text() |
						jis:origin/text() |
						jis:strong/text()" mode="update_xml_step1">
		<xsl:variable name="element_name_font_en">font_en_bold</xsl:variable>
		<xsl:variable name="tag_font_en_open">###<xsl:value-of select="$element_name_font_en"/>###</xsl:variable>
		<xsl:variable name="tag_font_en_close">###/<xsl:value-of select="$element_name_font_en"/>###</xsl:variable>
		<xsl:variable name="text_en_" select="java:replaceAll(java:java.lang.String.new(.), $regex_en, concat($tag_font_en_open,'$1',$tag_font_en_close))"/>
		<xsl:variable name="text_en"><text><xsl:call-template name="replace_text_tags">
			<xsl:with-param name="tag_open" select="$tag_font_en_open"/>
			<xsl:with-param name="tag_close" select="$tag_font_en_close"/>
			<xsl:with-param name="text" select="$text_en_"/>
		</xsl:call-template></text></xsl:variable>
		<xsl:copy-of select="xalan:nodeset($text_en)/text/node()"/>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'font_en_bold']">
		<fo:inline font-family="Times New Roman" font-weight="bold">
			<xsl:if test="ancestor::*[local-name() = 'preferred']">
				<xsl:attribute name="font-weight">normal</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'font_en']">
		<fo:inline font-family="Times New Roman">
			<xsl:if test="ancestor::*[local-name() = 'preferred']">
				<xsl:attribute name="font-weight">normal</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>
	
	<!-- ========================= -->
	<!-- END: Allocate non-Japanese text -->
	<!-- ========================= -->
	
	<xsl:template name="insertHeaderFooter">
		<xsl:param name="docidentifier" />
		<xsl:param name="hidePageNumber">false</xsl:param>
		<xsl:param name="section"/>
		<xsl:param name="copyrightText"/>
		<fo:static-content flow-name="header-odd" role="artifact">
			<fo:block-container font-family="Arial" font-size="9pt" height="26mm" display-align="after" text-align="right">
				<xsl:if test="$section = 'main'"><fo:block><fo:page-number /></fo:block></xsl:if>
				<fo:block><xsl:copy-of select="$docidentifier"/></fo:block>
			</fo:block-container>
		</fo:static-content>
		<fo:static-content flow-name="header-even" role="artifact">
			<fo:block-container font-family="Arial" font-size="9pt" height="26mm" display-align="after">
				<xsl:if test="$section = 'main'"><fo:block><fo:page-number /></fo:block></xsl:if>
				<fo:block><xsl:copy-of select="$docidentifier"/></fo:block>
			</fo:block-container>
		</fo:static-content>
		<xsl:call-template name="insertFooter">
			<xsl:with-param name="section" select="$section"/>
			<xsl:with-param name="copyrightText" select="$copyrightText"/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template name="insertFooter">
		<xsl:param name="section"/>
		<xsl:param name="copyrightText"/>
		<fo:static-content flow-name="footer">
			<fo:block-container height="24.5mm" display-align="after">
				<xsl:if test="$section = 'preface'">
					<fo:block font-size="9pt" text-align="center" space-after="10pt">(<fo:inline font-family="Times New Roman"><fo:page-number /></fo:inline>)</fo:block>
				</xsl:if>
				<!-- copyright restriction -->
				<fo:block font-size="7pt" text-align="center" font-family="IPAexMincho" margin-bottom="13mm"><xsl:value-of select="$copyrightText"/></fo:block>
			</fo:block-container>
		</fo:static-content>
	</xsl:template>
	
	<xsl:variable name="JIS-Logo">
		<svg width="80.94133mm" height="47.963669mm" viewBox="0 0 80.94133 47.963669" version="1.1" id="svg781" xmlns="http://www.w3.org/2000/svg" xmlns:svg="http://www.w3.org/2000/svg">
		<defs id="defs778" />
			<g id="layer1" transform="translate(-0.51630433,-0.32770559)">
				<path
					 d="m 35.949294,46.979025 h 11.64167 V 1.4071956 h -11.64167 z"
					 style="display:inline;fill:#231f20;fill-opacity:1;fill-rule:nonzero;stroke:none;stroke-width:0.352778"
					 id="path94" />
				<path
					 d="m 76.419964,22.870205 c 3.175,2.37067 5.03767,6.35 5.03767,10.8585 0,7.6835 -6.096,13.7795 -13.75834,13.7795 -3.175,0 -6.096,-1.05833 -8.21266,-2.64583 l -7.13317,-5.03767 6.87917,-9.017 7.13316,5.03767 c 0.52917,0.254 1.05834,0.52916 1.5875,0.52916 1.5875,0 2.921,-1.05833 2.921,-2.64583 0,-1.05833 -0.52916,-1.86267 -1.3335,-2.39183 l -9.24983,-6.35 c -3.175,-2.667 -5.0165,-6.62517 -5.0165,-10.87967 0,-7.6834994 6.07483,-13.77949941 13.73717,-13.77949941 2.64583,0 5.82083,1.33350001 7.9375,2.92100001 l 2.921,2.39183 -6.87917,8.4666694 -2.64583,-2.11667 c -0.52917,-0.52916 -1.05834,-0.78316 -1.5875,-0.78316 -1.5875,0 -2.921,1.31233 -2.921,2.89983 0,0.80433 0.52916,1.60867 1.3335,2.13783 l 9.24983,6.62517"
					 style="display:inline;fill:#231f20;fill-opacity:1;fill-rule:nonzero;stroke:none;stroke-width:0.352778"
					 id="path244" />
				<path
					 d="m 28.816134,33.728705 c 0,9.271 -7.15433,14.56267 -14.2875,14.56267 -7.1331697,0 -10.5833297,-4.7625 -10.5833297,-4.7625 l -3.42899997,-3.45017 8.19149997,-8.21267 3.1749997,3.45017 0.80433,0.78317 c 0.508,0.52916 1.03717,1.05833 2.0955,1.05833 1.3335,0 2.64583,-1.31233 2.64583,-2.89983 0,0 0,0 0,-0.27517 V 1.4072066 h 11.38767 V 32.670375 c 0,0 0,-8.21267 0,1.05833"
					 style="display:inline;fill:#231f20;fill-opacity:1;fill-rule:nonzero;stroke:none;stroke-width:0.352778"
					 id="path364" />
			</g>
		</svg>
	</xsl:variable>
	
</xsl:stylesheet>
