<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:ogc="https://www.metanorma.org/ns/ogc" xmlns:mathml="http://www.w3.org/1998/Math/MathML" xmlns:xalan="http://xml.apache.org/xalan" xmlns:fox="http://xmlgraphics.apache.org/fop/extensions" version="1.0">

	<xsl:output version="1.0" method="xml" encoding="UTF-8" indent="no"/>

	<xsl:variable name="pageWidth" select="'210mm'"/>
	<xsl:variable name="pageHeight" select="'297mm'"/>

	<xsl:variable name="namespace">ogc</xsl:variable>
	
	<xsl:variable name="copyright">
		<xsl:text>© Open Geospatial Consortium </xsl:text>
		<xsl:value-of select="/ogc:ogc-standard/ogc:bibdata/ogc:copyright/ogc:from"/>
		<xsl:text> – All rights reserved</xsl:text>
	</xsl:variable>
	<xsl:variable name="copyright_short">
		<xsl:text>© </xsl:text>
		<xsl:value-of select="/ogc:ogc-standard/ogc:bibdata/ogc:copyright/ogc:from"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="/ogc:ogc-standard/ogc:bibdata/ogc:contributor/ogc:organization/ogc:name"/>
	</xsl:variable>
	

	<xsl:variable name="doctype">
		<xsl:call-template name="capitalizeWords">
			<xsl:with-param name="str" select="/ogc:ogc-standard/ogc:bibdata/ogc:ext/ogc:doctype"/>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="header">
		<xsl:text>Open Geospatial Consortium </xsl:text>
		<xsl:value-of select="/ogc:ogc-standard/ogc:bibdata/ogc:docidentifier[@type = 'ogc-internal']"/>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="/ogc:ogc-standard/ogc:bibdata/ogc:copyright/ogc:from"/>
	</xsl:variable>
	
	<xsl:variable name="contents">
		<contents>
		
			
			<!-- Abstract, Keywords, Preface, Submitting Organizations, Submitters -->
			<xsl:apply-templates select="/ogc:ogc-standard/ogc:preface/ogc:abstract" mode="contents"/>
			<xsl:apply-templates select="/ogc:ogc-standard/ogc:bibdata/ogc:keyword[1]" mode="contents">
				<xsl:with-param name="sectionNum" select="count(/ogc:ogc-standard/ogc:preface/ogc:abstract) + 1"/>
			</xsl:apply-templates>
			<xsl:apply-templates select="/ogc:ogc-standard/ogc:preface/ogc:foreword" mode="contents">
				<xsl:with-param name="sectionNum" select="count(/ogc:ogc-standard/ogc:preface/ogc:abstract) + 
																																				count (/ogc:ogc-standard/ogc:bibdata/ogc:keyword[1])+ 1"/>
			</xsl:apply-templates>
			<xsl:apply-templates select="/ogc:ogc-standard/ogc:preface/ogc:introduction" mode="contents"/>
			<xsl:apply-templates select="/ogc:ogc-standard/ogc:bibdata/ogc:contributor[ogc:role/@type='author'][1]/ogc:organization/ogc:name" mode="contents">
				<xsl:with-param name="sectionNum" select="count(/ogc:ogc-standard/ogc:preface/ogc:abstract) + 
																																				count (/ogc:ogc-standard/ogc:bibdata/ogc:keyword[1])+ 
																																				count(/ogc:ogc-standard/ogc:preface/ogc:foreword) + 1"/>
			</xsl:apply-templates>
			<xsl:apply-templates select="/ogc:ogc-standard/ogc:preface/ogc:submitters" mode="contents">
				<xsl:with-param name="sectionNum" select="count(/ogc:ogc-standard/ogc:preface/ogc:abstract) + 
																																				count (/ogc:ogc-standard/ogc:bibdata/ogc:keyword[1])+ 
																																				count(/ogc:ogc-standard/ogc:preface/ogc:foreword) +
																																				count(/ogc:ogc-standard/ogc:bibdata/ogc:contributor[ogc:role/@type='author'][1]/ogc:organization/ogc:name) + 1"/>
			</xsl:apply-templates>
			
			<xsl:apply-templates select="/ogc:ogc-standard/ogc:sections/ogc:clause[@id='_scope']" mode="contents">
				<xsl:with-param name="sectionNum" select="'1'"/>
			</xsl:apply-templates>
			
			<xsl:apply-templates select="/ogc:ogc-standard/ogc:sections/ogc:clause[@id='conformance' or @id='_conformance']" mode="contents">
				<xsl:with-param name="sectionNum" select="count(/ogc:ogc-standard/ogc:sections/ogc:clause[@id='_scope']) + 1"/>
			</xsl:apply-templates>
			
			<!-- Normative references  -->
			<xsl:apply-templates select="/ogc:ogc-standard/ogc:bibliography/ogc:references[@id = '_normative_references' or @id = '_references']" mode="contents">
				<xsl:with-param name="sectionNum" select="count(/ogc:ogc-standard/ogc:sections/ogc:clause[@id='_scope']) +
																																				count(/ogc:ogc-standard/ogc:sections/ogc:clause[@id='conformance' or @id='_conformance']) + 1"/>
			</xsl:apply-templates>
			
			<xsl:apply-templates select="/ogc:ogc-standard/ogc:sections/ogc:terms" mode="contents"> <!-- Terms and definitions -->
				<xsl:with-param name="sectionNum" select="count(/ogc:ogc-standard/ogc:sections/ogc:clause[@id='_scope']) +
																																				count(/ogc:ogc-standard/ogc:sections/ogc:clause[@id='conformance' or @id='_conformance']) + 
																																				count(/ogc:ogc-standard/ogc:bibliography/ogc:references[@id = '_normative_references' or @id = '_references']) + 1"/>
			</xsl:apply-templates>
			
		
			<xsl:apply-templates select="/ogc:ogc-standard/ogc:sections/*[local-name() != 'terms' and not(@id='_scope') and not(@id='conformance') and not(@id='_conformance')]" mode="contents">
				<xsl:with-param name="sectionNumSkew" select="count(/ogc:ogc-standard/ogc:sections/ogc:clause[@id='_scope']) +
																																				count(/ogc:ogc-standard/ogc:sections/ogc:clause[@id='conformance' or @id='_conformance']) + 
																																				count(/ogc:ogc-standard/ogc:bibliography/ogc:references[@id = '_normative_references' or @id = '_references']) +
																																				count(/ogc:ogc-standard/ogc:sections/ogc:terms)"/>	
			</xsl:apply-templates>
			
			
			<xsl:apply-templates select="/ogc:ogc-standard/ogc:annex" mode="contents"/>
			<xsl:apply-templates select="/ogc:ogc-standard/ogc:bibliography/ogc:references[@id != '_normative_references' and @id != '_references']" mode="contents"/> <!-- [position() &gt; 1] -->
			
			
		</contents>
	</xsl:variable>
	
	<xsl:variable name="lang">
		<xsl:call-template name="getLang"/>
	</xsl:variable>
	
	<xsl:template match="/">
		<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format" font-family="Times New Roman, Cambria Math, HanSans" font-size="10.5pt" xml:lang="{$lang}">
			<fo:layout-master-set>
				<!-- Cover page -->
				<fo:simple-page-master master-name="cover-page" page-width="{$pageWidth}" page-height="{$pageHeight}">
					<fo:region-body margin-top="23.5mm" margin-bottom="10mm" margin-left="19mm" margin-right="19mm"/>
					<fo:region-before region-name="cover-page-header" extent="23.5mm" />
					<fo:region-after extent="10mm"/>
					<fo:region-start extent="19mm"/>
					<fo:region-end extent="19mm"/>
				</fo:simple-page-master>
				
				<!-- Document pages -->
				<!-- Preface odd pages -->
				<fo:simple-page-master master-name="odd-preface" page-width="{$pageWidth}" page-height="{$pageHeight}">
					<fo:region-body margin-top="17mm" margin-bottom="10mm" margin-left="19mm" margin-right="19mm"/>
					<fo:region-before region-name="header-odd" extent="17mm"/> 
					<fo:region-after region-name="footer-odd" extent="10mm"/>
					<fo:region-start region-name="left-region" extent="19mm"/>
					<fo:region-end region-name="right-region" extent="19mm"/>
				</fo:simple-page-master>
				<!-- Preface even pages -->
				<fo:simple-page-master master-name="even-preface" page-width="{$pageWidth}" page-height="{$pageHeight}">
					<fo:region-body margin-top="17mm" margin-bottom="10mm" margin-left="19mm" margin-right="19mm"/>
					<fo:region-before region-name="header-even" extent="17mm"/>
					<fo:region-after region-name="footer-even" extent="10mm"/>
					<fo:region-start region-name="left-region" extent="19mm"/>
					<fo:region-end region-name="right-region" extent="19mm"/>
				</fo:simple-page-master>
				<fo:simple-page-master master-name="blankpage" page-width="{$pageWidth}" page-height="{$pageHeight}">
					<fo:region-body margin-top="17mm" margin-bottom="10mm" margin-left="19mm" margin-right="19mm"/>
					<fo:region-before region-name="header" extent="17mm"/>
					<fo:region-after region-name="footer" extent="10mm"/>
					<fo:region-start region-name="left" extent="19mm"/>
					<fo:region-end region-name="right" extent="19mm"/>
				</fo:simple-page-master>
				<fo:page-sequence-master master-name="preface">
					<fo:repeatable-page-master-alternatives>
						<fo:conditional-page-master-reference master-reference="blankpage" blank-or-not-blank="blank" />
						<fo:conditional-page-master-reference odd-or-even="even" master-reference="even-preface"/>
						<fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd-preface"/>
					</fo:repeatable-page-master-alternatives>
				</fo:page-sequence-master>
				
				<!-- Document odd pages -->
				<fo:simple-page-master master-name="odd" page-width="{$pageWidth}" page-height="{$pageHeight}">
					<fo:region-body margin-top="17mm" margin-bottom="10mm" margin-left="19mm" margin-right="19mm"/>
					<fo:region-before region-name="header-odd" extent="17mm"/> 
					<fo:region-after region-name="footer-odd" extent="10mm"/>
					<fo:region-start region-name="left-region" extent="19mm"/>
					<fo:region-end region-name="right-region" extent="19mm"/>
				</fo:simple-page-master>
				<!-- Document even pages -->
				<fo:simple-page-master master-name="even" page-width="{$pageWidth}" page-height="{$pageHeight}">
					<fo:region-body margin-top="17mm" margin-bottom="9mm" margin-left="19mm" margin-right="19mm"/>
					<fo:region-before region-name="header-even" extent="17mm"/>
					<fo:region-after region-name="footer-even" extent="10mm"/>
					<fo:region-start region-name="left-region" extent="19mm"/>
					<fo:region-end region-name="right-region" extent="19mm"/>
				</fo:simple-page-master>
				<fo:page-sequence-master master-name="document">
					<fo:repeatable-page-master-alternatives>
						<fo:conditional-page-master-reference master-reference="blankpage" blank-or-not-blank="blank" />
						<fo:conditional-page-master-reference odd-or-even="even" master-reference="even"/>
						<fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd"/>
					</fo:repeatable-page-master-alternatives>
				</fo:page-sequence-master>
				
			</fo:layout-master-set>
			
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
							<dc:title><xsl:value-of select="/ogc:ogc-standard/ogc:bibdata/ogc:title[@language = 'en']"/></dc:title>
							<dc:creator></dc:creator>
							<dc:description>
								<xsl:variable name="abstract">
									<xsl:copy-of select="/ogc:ogc-standard/ogc:bibdata/ogc:abstract//text()"/>
								</xsl:variable>
								<xsl:value-of select="normalize-space($abstract)"/>
							</dc:description>
							<pdf:Keywords>
								<xsl:for-each select="/ogc:ogc-standard/ogc:bibdata//ogc:keyword">
									<xsl:sort data-type="text" order="ascending"/>
									<xsl:apply-templates/>
									<xsl:choose>
										<xsl:when test="position() != last()">, </xsl:when>
										<xsl:otherwise>.</xsl:otherwise>
									</xsl:choose>
								</xsl:for-each>
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
			
			<!-- Cover Page -->
			<fo:page-sequence master-reference="cover-page" force-page-count="no-force">				
				<fo:static-content flow-name="xsl-footnote-separator">
					<fo:block>
						<fo:leader leader-pattern="rule" leader-length="30%"/>
					</fo:block>
				</fo:static-content>
				<fo:static-content flow-name="cover-page-header" font-size="10pt">
					<fo:block-container height="23.5mm" display-align="before">
						<fo:block padding-top="12.5mm">
							<xsl:value-of select="$copyright"/>
						</fo:block>
					</fo:block-container>
				</fo:static-content>
					
				<fo:flow flow-name="xsl-region-body">
					
					<fo:block text-align="right" font-size="10pt">
						<!-- CC/FDS 18011:2018 -->
						<fo:block font-size="18pt" font-weight="bold" margin-bottom="10pt">
							<xsl:text>Open Geospatial Consortium </xsl:text>
						</fo:block>
						<fo:block line-height="115%">
							<fo:block margin-bottom="12pt">
								<xsl:text>Submission Date: </xsl:text>
								<xsl:choose>
									<xsl:when test="/ogc:ogc-standard/ogc:bibdata/ogc:date[@type = 'received']/ogc:on">
										<xsl:value-of select="/ogc:ogc-standard/ogc:bibdata/ogc:date[@type = 'received']/ogc:on"/>
									</xsl:when>
									<xsl:otherwise>XXX</xsl:otherwise>
								</xsl:choose>
								<xsl:text> </xsl:text>
							</fo:block>
							<fo:block margin-bottom="12pt">
								<xsl:text>Approval Date: </xsl:text>
								<xsl:choose>
									<xsl:when test="/ogc:ogc-standard/ogc:bibdata/ogc:date[@type = 'issued']/ogc:on">
										<xsl:value-of select="/ogc:ogc-standard/ogc:bibdata/ogc:date[@type = 'issued']/ogc:on"/>
									</xsl:when>
									<xsl:otherwise>XXX</xsl:otherwise>
								</xsl:choose>
								<xsl:text> </xsl:text>
							</fo:block>
							<fo:block margin-bottom="12pt">
								<xsl:text>Publication Date: </xsl:text>
								<xsl:value-of select="/ogc:ogc-standard/ogc:bibdata/ogc:date[@type = 'published']/ogc:on"/><xsl:text> </xsl:text>
							</fo:block>
							<fo:block margin-bottom="12pt">
								<xsl:text>External identifier of this OGC® document: </xsl:text>
								<xsl:value-of select="/ogc:ogc-standard/ogc:bibdata/ogc:docidentifier[@type='ogc-external']"/><xsl:text> </xsl:text>
							</fo:block>
							<fo:block margin-bottom="12pt">
								<xsl:text>Internal reference number of this OGC® document: </xsl:text>
								<xsl:value-of select="/ogc:ogc-standard/ogc:bibdata/ogc:docidentifier[@type='ogc-internal']"/><xsl:text> </xsl:text>
							</fo:block>
							<xsl:apply-templates select="/ogc:ogc-standard/ogc:bibdata/ogc:uri[not(@type)]"/>
							<xsl:apply-templates select="/ogc:ogc-standard/ogc:bibdata/ogc:edition"/>
							
							<fo:block margin-bottom="12pt">
								<xsl:text>Category: </xsl:text>
								<xsl:value-of select="$doctype"/>
								 <xsl:text> </xsl:text>
							</fo:block>
							<fo:block margin-bottom="12pt">
								<xsl:text>Editor: </xsl:text>
								<xsl:for-each select="/ogc:ogc-standard/ogc:bibdata/ogc:contributor[ogc:role/@type='editor']/ogc:person/ogc:name/ogc:completename">
									<xsl:value-of select="."/>
									<xsl:if test="position() != last()">, </xsl:if>
								</xsl:for-each>
								<xsl:text> </xsl:text>
							</fo:block>
						</fo:block>
					</fo:block>
					<fo:block font-size="24pt" font-weight="bold" text-align="center" margin-top="15pt" line-height="115%">
						<xsl:text>OGC </xsl:text><xsl:value-of select="/ogc:ogc-standard/ogc:bibdata/ogc:title[@language = 'en']" />
					</fo:block>
					<fo:block margin-bottom="12pt">&#xA0;</fo:block>
					<!-- Copyright notice -->
					<xsl:apply-templates select="/ogc:ogc-standard/ogc:boilerplate/ogc:copyright-statement"/>
					
					<xsl:apply-templates select="/ogc:ogc-standard/ogc:boilerplate/ogc:legal-statement"/>
					
					<fo:block-container absolute-position="fixed" left="14mm" top="250mm" font-size="10pt">
						<fo:table table-layout="fixed" width="100%">
							<fo:table-column column-width="35mm"/>
							<fo:table-column column-width="70mm"/>
							<fo:table-body>
								<fo:table-row height="9mm">
									<fo:table-cell>
										<fo:block>Document type: </fo:block>
									</fo:table-cell>
									<fo:table-cell>
										<fo:block line-height-shift-adjustment="disregard-shifts">OGC<fo:inline font-size="65%" vertical-align="super">®</fo:inline><xsl:text> </xsl:text><xsl:value-of select="$doctype"/></fo:block>
									</fo:table-cell>
								</fo:table-row>
								<fo:table-row height="9mm">
									<fo:table-cell>
										<fo:block>Document stage: </fo:block>
									</fo:table-cell>
									<fo:table-cell>
										<fo:block>
											<xsl:variable name="stage" select="/ogc:ogc-standard/ogc:bibdata/ogc:status/ogc:stage"/>
											<xsl:value-of select="translate(substring($stage, 1, 1), $lower, $upper)"/>
											<xsl:value-of select="substring($stage, 2)"/>
										</fo:block>
									</fo:table-cell>
								</fo:table-row>
								<fo:table-row height="9mm">
									<fo:table-cell>
										<fo:block>Document language: </fo:block>
									</fo:table-cell>
									<fo:table-cell>
										<fo:block><xsl:value-of select="$lang"/></fo:block>
									</fo:table-cell>
								</fo:table-row>
							</fo:table-body>
						</fo:table>
					</fo:block-container>
					
				</fo:flow>
			</fo:page-sequence>
			<!-- End Cover Page -->
			
			
			<!-- Copyright, Content, Foreword, etc. pages -->
			<fo:page-sequence master-reference="preface" initial-page-number="2" format="i" force-page-count="end-on-even"> <!--  -->
				<fo:static-content flow-name="xsl-footnote-separator">
					<fo:block>
						<fo:leader leader-pattern="rule" leader-length="30%"/>
					</fo:block>
				</fo:static-content>
				<xsl:call-template name="insertHeaderFooter"/>
				<fo:flow flow-name="xsl-region-body">
					<xsl:text disable-output-escaping="yes">&lt;!--</xsl:text>
						DEBUG
						contents=<xsl:copy-of select="xalan:nodeset($contents)"/> 
					<xsl:text disable-output-escaping="yes">--&gt;</xsl:text>
					
					<xsl:apply-templates select="/ogc:ogc-standard/ogc:boilerplate/ogc:license-statement"/>
					<xsl:apply-templates select="/ogc:ogc-standard/ogc:boilerplate/ogc:feedback-statement"/>
					
					<fo:block break-after="page"/>
					<fo:block>&#xA0;</fo:block>
					<fo:block break-after="page"/>
					
					<fo:block-container font-weight="bold" line-height="115%">
						<fo:block font-size="14pt" margin-top="2pt"  margin-bottom="15.5pt">Contents</fo:block>
						
						<xsl:for-each select="xalan:nodeset($contents)//item[@display = 'true' and @level &lt;= 2]"><!-- skip clause from preface [not(@level = 2 and starts-with(@section, '0'))] -->
							
							<fo:block>
								<xsl:if test="@level = 1">
									<xsl:attribute name="margin-top">6pt</xsl:attribute>
								</xsl:if>
								<fo:list-block>
									<xsl:attribute name="provisional-distance-between-starts">
										<xsl:choose>
											<!-- skip 0 section without subsections -->
											<xsl:when test="@section != '' and not(@display-section = 'false')">8mm</xsl:when>
											<xsl:otherwise>0mm</xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
									<fo:list-item>
										<fo:list-item-label end-indent="label-end()">
											<fo:block>
												<xsl:if test="@section and not(@display-section = 'false')"> <!-- output below   -->
													<xsl:value-of select="@section"/><xsl:text>.</xsl:text>
												</xsl:if>
											</fo:block>
										</fo:list-item-label>
										<fo:list-item-body start-indent="body-start()">
											<fo:block text-align-last="justify" margin-left="12mm" text-indent="-12mm">
												<fo:basic-link internal-destination="{@id}" fox:alt-text="{text()}">
													<xsl:if test="@section and @display-section = 'false' and not(@section = '0')">
														<xsl:value-of select="@section"/><xsl:text> </xsl:text>
													</xsl:if>
													<xsl:if test="@addon != ''">
														<xsl:text>(</xsl:text><xsl:value-of select="@addon"/><xsl:text>)</xsl:text>
													</xsl:if>
													<xsl:text> </xsl:text><xsl:value-of select="text()"/>
													<fo:inline keep-together.within-line="always">
														<fo:leader leader-pattern="dots"/>
														<fo:inline><fo:page-number-citation ref-id="{@id}"/></fo:inline>
													</fo:inline>
												</fo:basic-link>
											</fo:block>
										</fo:list-item-body>
									</fo:list-item>
								</fo:list-block>
							</fo:block>
						</xsl:for-each>
						
						<xsl:if test="xalan:nodeset($contents)//item[@type = 'table']">
							<fo:block font-size="12pt">&#xA0;</fo:block>
							<fo:block font-size="12pt">&#xA0;</fo:block>
							<fo:block font-size="14pt" font-weight="bold" space-before="48pt" margin-bottom="15.5pt">List of Tables</fo:block>
							<xsl:for-each select="xalan:nodeset($contents)//item[@type = 'table']">
								<fo:block text-align-last="justify" margin-top="6pt">
									<fo:basic-link internal-destination="{@id}" fox:alt-text="{@section}">
										<xsl:value-of select="@section"/>
										<xsl:if test="text() != ''">
											<xsl:text> — </xsl:text>
											<xsl:value-of select="text()"/>
										</xsl:if>
										<xsl:text> </xsl:text>
										<fo:inline keep-together.within-line="always">
											<fo:leader leader-pattern="dots"/>
											<fo:page-number-citation ref-id="{@id}"/>
										</fo:inline>
									</fo:basic-link>
								</fo:block>
							</xsl:for-each>
						</xsl:if>
						
						<xsl:if test="xalan:nodeset($contents)//item[@type = 'figure']">
							<fo:block font-size="12pt">&#xA0;</fo:block>
							<fo:block font-size="12pt">&#xA0;</fo:block>
							<fo:block font-size="14pt" font-weight="bold" space-before="48pt" margin-bottom="15.5pt">List of Figures</fo:block>
							<xsl:for-each select="xalan:nodeset($contents)//item[@type = 'figure']">
								<fo:block text-align-last="justify" margin-top="6pt">
									<fo:basic-link internal-destination="{@id}" fox:alt-text="{@section}">
										<xsl:value-of select="@section"/>
										<xsl:if test="text() != ''">
											<xsl:text> — </xsl:text>
											<xsl:value-of select="text()"/>
										</xsl:if>
										<xsl:text> </xsl:text>
										<fo:inline keep-together.within-line="always">
											<fo:leader leader-pattern="dots"/>
											<fo:page-number-citation ref-id="{@id}"/>
										</fo:inline>
									</fo:basic-link>
								</fo:block>
							</xsl:for-each>
						</xsl:if>
						
					</fo:block-container>
					
					
					<!-- Abstract, Keywords, Preface, Submitting Organizations, Submitters -->
					<xsl:apply-templates select="/ogc:ogc-standard/ogc:preface/ogc:abstract" mode="abstract"/>
					<xsl:apply-templates select="/ogc:ogc-standard/ogc:bibdata/ogc:keyword[1]">
						<xsl:with-param name="sectionNum" select="count(/ogc:ogc-standard/ogc:preface/ogc:abstract) + 1"/>
					</xsl:apply-templates>
					<xsl:apply-templates select="/ogc:ogc-standard/ogc:preface/ogc:foreword" mode="preface">
						<xsl:with-param name="sectionNum" select="count(/ogc:ogc-standard/ogc:preface/ogc:abstract) + 
																																						count (/ogc:ogc-standard/ogc:bibdata/ogc:keyword[1])+ 1"/>
					</xsl:apply-templates>
					<xsl:apply-templates select="/ogc:ogc-standard/ogc:preface/ogc:introduction" mode="introduction"/>
					<xsl:apply-templates select="/ogc:ogc-standard/ogc:bibdata/ogc:contributor[ogc:role/@type='author'][1]/ogc:organization/ogc:name">
						<xsl:with-param name="sectionNum" select="count(/ogc:ogc-standard/ogc:preface/ogc:abstract) + 
																																						count (/ogc:ogc-standard/ogc:bibdata/ogc:keyword[1])+ 
																																						count(/ogc:ogc-standard/ogc:preface/ogc:foreword) + 1"/>
					</xsl:apply-templates>
					<xsl:apply-templates select="/ogc:ogc-standard/ogc:preface/ogc:submitters">
						<xsl:with-param name="sectionNum" select="count(/ogc:ogc-standard/ogc:preface/ogc:abstract) + 
																																						count (/ogc:ogc-standard/ogc:bibdata/ogc:keyword[1])+ 
																																						count(/ogc:ogc-standard/ogc:preface/ogc:foreword) +
																																						count(/ogc:ogc-standard/ogc:bibdata/ogc:contributor[ogc:role/@type='author'][1]/ogc:organization/ogc:name) + 1"/>
					</xsl:apply-templates>
					
					
				</fo:flow>
			</fo:page-sequence>
			
			
			<!-- Document Pages -->
			<fo:page-sequence master-reference="document" initial-page-number="1" format="1" force-page-count="no-force">
				<fo:static-content flow-name="xsl-footnote-separator">
					<fo:block>
						<fo:leader leader-pattern="rule" leader-length="30%"/>
					</fo:block>
				</fo:static-content>
				<xsl:call-template name="insertHeaderFooter">
					<xsl:with-param name="pagenum-font-weight">bold</xsl:with-param>
				</xsl:call-template>
				<fo:flow flow-name="xsl-region-body">
					<fo:block font-size="16pt" font-weight="bold" margin-bottom="18pt">
						<xsl:value-of select="/ogc:ogc-standard/ogc:bibdata/ogc:title[@language = 'en']"/>
					</fo:block>
					
					<fo:block line-height="125%">
					
						<xsl:apply-templates select="/ogc:ogc-standard/ogc:sections/ogc:clause[@id='_scope']">
							<xsl:with-param name="sectionNum" select="'1'"/>
						</xsl:apply-templates>
						
						<xsl:apply-templates select="/ogc:ogc-standard/ogc:sections/ogc:clause[@id='conformance' or @id='_conformance']">
							<xsl:with-param name="sectionNum" select="count(/ogc:ogc-standard/ogc:sections/ogc:clause[@id='_scope']) + 1"/>
						</xsl:apply-templates>
						
						<!-- Normative references  -->
						<xsl:apply-templates select="/ogc:ogc-standard/ogc:bibliography/ogc:references[@id = '_normative_references' or @id = '_references']">
							<xsl:with-param name="sectionNum" select="count(/ogc:ogc-standard/ogc:sections/ogc:clause[@id='_scope']) +
																																							count(/ogc:ogc-standard/ogc:sections/ogc:clause[@id='conformance' or @id='_conformance']) + 1"/>
						</xsl:apply-templates>
						
						<xsl:apply-templates select="/ogc:ogc-standard/ogc:sections/ogc:terms"> <!-- Terms and definitions -->
							<xsl:with-param name="sectionNum" select="count(/ogc:ogc-standard/ogc:sections/ogc:clause[@id='_scope']) +
																																							count(/ogc:ogc-standard/ogc:sections/ogc:clause[@id='conformance' or @id='_conformance']) + 
																																							count(/ogc:ogc-standard/ogc:bibliography/ogc:references[@id = '_normative_references' or @id = '_references']) + 1"/>
						</xsl:apply-templates>
						
						
						<xsl:apply-templates select="/ogc:ogc-standard/ogc:sections/*[local-name() != 'terms' and not(@id='_scope') and not(@id='conformance') and not(@id='_conformance')]">
							<xsl:with-param name="sectionNumSkew" select="count(/ogc:ogc-standard/ogc:sections/ogc:clause[@id='_scope']) +
																																				count(/ogc:ogc-standard/ogc:sections/ogc:clause[@id='conformance' or @id='_conformance']) + 
																																				count(/ogc:ogc-standard/ogc:bibliography/ogc:references[@id = '_normative_references' or @id = '_references']) +
																																				count(/ogc:ogc-standard/ogc:sections/ogc:terms)"/>
						</xsl:apply-templates>
						
						
						<xsl:apply-templates select="/ogc:ogc-standard/ogc:annex"/>
						<xsl:apply-templates select="/ogc:ogc-standard/ogc:bibliography/ogc:references[@id != '_normative_references' and @id != '_references']" /> <!-- [position() &gt; 1] -->
						
					</fo:block>
				</fo:flow>
			</fo:page-sequence>
			
			<!-- End Document Pages -->
			
		</fo:root>
	</xsl:template> 

	<!-- for pass the paremeter 'sectionNum' over templates, like 'tunnel' parameter in XSLT 2.0 -->
	<xsl:template match="node()">
		<xsl:param name="sectionNum"/>
		<xsl:param name="sectionNumSkew"/>
		<xsl:apply-templates>
			<xsl:with-param name="sectionNum" select="$sectionNum"/>
			<xsl:with-param name="sectionNumSkew" select="$sectionNumSkew"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<!-- ============================= -->
	<!-- CONTENTS                                       -->
	<!-- ============================= -->
	<xsl:template match="node()" mode="contents">
		<xsl:param name="sectionNum"/>
		<xsl:param name="sectionNumSkew"/>
		<xsl:apply-templates mode="contents">
			<xsl:with-param name="sectionNum" select="$sectionNum"/>
			<xsl:with-param name="sectionNumSkew" select="$sectionNumSkew"/>
		</xsl:apply-templates>
	</xsl:template>

	
	<!-- calculate main section number (1,2,3) and pass it deep into templates -->
	<!-- it's necessary, because there is itu:bibliography/itu:references from other section, but numbering should be sequental -->
	<xsl:template match="ogc:ogc-standard/ogc:sections/*" mode="contents">
		<xsl:param name="sectionNum"/>
		<xsl:param name="sectionNumSkew" select="0"/>
		<xsl:variable name="sectionNum_">
			<xsl:choose>
				<xsl:when test="$sectionNum"><xsl:value-of select="$sectionNum"/></xsl:when>
				<xsl:when test="$sectionNumSkew != 0">
					<xsl:variable name="number"><xsl:number count="ogc:sections/ogc:clause[not(@id='_scope') and not(@id='conformance') and not(@id='_conformance')]"/></xsl:variable> <!-- * ogc:sections/ogc:clause | ogc:sections/ogc:terms -->
					<xsl:value-of select="$number + $sectionNumSkew"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:number count="*"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:apply-templates mode="contents">
			<xsl:with-param name="sectionNum" select="$sectionNum_"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="ogc:ogc-standard/ogc:sections/ogc:terms" mode="contents">
		<xsl:param name="sectionNum"/>
		<xsl:param name="sectionNumSkew" select="0"/>
		<xsl:variable name="sectionNum_">
			<xsl:choose>
				<xsl:when test="$sectionNum"><xsl:value-of select="$sectionNum"/></xsl:when>
				<xsl:when test="$sectionNumSkew != 0">
					<xsl:variable name="number"><xsl:number count="*"/></xsl:variable> <!-- ogc:sections/ogc:clause | ogc:sections/ogc:terms -->
					<xsl:value-of select="$number + $sectionNumSkew"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:number count="*"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:apply-templates mode="contents">
			<xsl:with-param name="sectionNum" select="$sectionNum_"/>
		</xsl:apply-templates>
	</xsl:template>
	
	
	<!-- Any node with title element - clause, definition, annex,... -->
	<xsl:template match="ogc:title | ogc:preferred" mode="contents">
		<xsl:param name="sectionNum"/>
		<xsl:variable name="id">
			<xsl:call-template name="getId"/>
		</xsl:variable>
		
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		
		<xsl:variable name="section">
			<xsl:call-template name="getSection">
				<xsl:with-param name="sectionNum" select="$sectionNum"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="display">
			<xsl:choose>
				<xsl:when test="ancestor::ogc:bibitem">false</xsl:when>
				<xsl:when test="ancestor::ogc:term">false</xsl:when>
				<xsl:when test="ancestor::ogc:annex and $level &gt;= 3">false</xsl:when>
				<xsl:when test="$level &lt;= 3">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="display-section">
			<xsl:choose>
				<xsl:when test="ancestor::ogc:annex and $level &gt;= 2">true</xsl:when>
				<xsl:when test="ancestor::ogc:annex">false</xsl:when>
				<xsl:when test="$section = '0'">false</xsl:when>
				<xsl:otherwise>true</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="type">
			<xsl:value-of select="local-name(..)"/>
		</xsl:variable>

		<xsl:variable name="root">
			<xsl:choose>
				<xsl:when test="ancestor::ogc:annex">annex</xsl:when>
				<xsl:when test="ancestor::ogc:clause">clause</xsl:when>
				<xsl:when test="ancestor::ogc:terms">terms</xsl:when>
			</xsl:choose>
		</xsl:variable>
		
		<item id="{$id}" level="{$level}" section="{$section}" display-section="{$display-section}" display="{$display}" type="{$type}" root="{$root}">
			<xsl:attribute name="addon">
				<xsl:if test="local-name(..) = 'annex'"><xsl:value-of select="../@obligation"/></xsl:if>
			</xsl:attribute>
			<xsl:apply-templates />
		</item>
		
		<xsl:apply-templates mode="contents">
			<xsl:with-param name="sectionNum" select="$sectionNum"/>
		</xsl:apply-templates>
		
	</xsl:template>
	
	<xsl:template match="ogc:ogc-standard/ogc:preface/*" mode="contents">
		<xsl:param name="sectionNum" select="'1'"/>
		<xsl:variable name="section">
			<xsl:number format="i" value="$sectionNum"/>
		</xsl:variable>
		<xsl:variable name="id">
			<xsl:choose>
				<xsl:when test="@id">
					<xsl:value-of select="@id"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="local-name()"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="not(ogc:title)">
			<item id="{$id}" level="1" section="{$section}" display-section="true" display="true" type="abstract" root="preface">
				<xsl:if test="local-name() = 'foreword'">
					<xsl:attribute name="display">false</xsl:attribute>
				</xsl:if>
				<xsl:choose>
					<xsl:when test="not(ogc:title)">
						<xsl:variable name="name" select="local-name()"/>
						<xsl:value-of select="translate(substring($name, 1, 1), $lower, $upper)"/><xsl:value-of select="substring($name, 2)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="ogc:title"/>
					</xsl:otherwise>
				</xsl:choose>
			</item>
		</xsl:if>
		<xsl:apply-templates mode="contents">
			<xsl:with-param name="sectionNum" select="$sectionNum"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<!-- Keywords -->
	<xsl:template match="/ogc:ogc-standard/ogc:bibdata/ogc:keyword" mode="contents">
		<xsl:param name="sectionNum" select="'1'"/>
		<xsl:variable name="section">
			<xsl:number format="i" value="$sectionNum"/>
		</xsl:variable>
		<item id="keywords" level="1" section="{$section}" display-section="true" display="true" type="abstract" root="preface">
			<xsl:text>Keywords</xsl:text>
		</item>
	</xsl:template>
	<!-- Submitting Organizations -->
	<xsl:template match="/ogc:ogc-standard/ogc:bibdata/ogc:contributor[ogc:role/@type='author']/ogc:organization/ogc:name" mode="contents">
		<xsl:param name="sectionNum" select="'1'"/>
		<xsl:variable name="section">
			<xsl:number format="i" value="$sectionNum"/>
		</xsl:variable>
		<item id="submitting_orgs" level="1" section="{$section}" display-section="true" display="true" type="abstract" root="preface">
			<xsl:text>Submitting Organizations</xsl:text>
		</item>
	</xsl:template>
	
	<xsl:template match="ogc:figure" mode="contents">
		<xsl:param name="sectionNum" />
		<item level="" id="{@id}" type="figure">
			<xsl:attribute name="section">
				<xsl:text>Figure </xsl:text>
				<xsl:choose>
					<xsl:when test="ancestor::ogc:annex">
						<xsl:choose>
							<xsl:when test="count(//ogc:annex) = 1">
								<xsl:value-of select="/ogc:nist-standard/ogc:bibdata/ogc:ext/ogc:structuredidentifier/ogc:annexid"/><xsl:number format="-1" level="any" count="ogc:annex//ogc:figure"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:number format="A.1-1" level="multiple" count="ogc:annex | ogc:figure"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="ancestor::ogc:figure">
						<xsl:for-each select="parent::*[1]">
							<xsl:number format="1" level="any" count="ogc:figure[not(parent::ogc:figure)]"/>
						</xsl:for-each>
						<xsl:number format="-a"  count="ogc:figure"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:number format="1" level="any" count="ogc:figure[not(parent::ogc:figure)] | ogc:sourcecode[not(@unnumbered = 'true') and not(ancestor::ogc:example)]"/>
						<!-- <xsl:number format="1.1-1" level="multiple" count="ogc:annex | ogc:figure"/> -->
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:value-of select="ogc:name"/>
		</item>
	</xsl:template>

	
	
	<xsl:template match="ogc:table[not(@unnumbered='true')]" mode="contents">
		<xsl:param name="sectionNum" />
		<xsl:variable name="annex-id" select="ancestor::ogc:annex/@id"/>
		<item level="" id="{@id}" display="false" type="table">
			<xsl:attribute name="section">
				<xsl:text>Table </xsl:text>
				<xsl:choose>
					<xsl:when test="ancestor::*[local-name()='executivesummary']">
							<xsl:text>ES-</xsl:text><xsl:number format="1" count="*[local-name()='executivesummary']//*[local-name()='table'][not(@unnumbered='true')]"/>
						</xsl:when>
					<xsl:when test="ancestor::*[local-name()='annex']">
						<xsl:number format="A-" count="ogc:annex"/>
						<xsl:number format="1" level="any" count="ogc:table[ancestor::ogc:annex[@id = $annex-id]][not(@unnumbered='true')]"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:number format="1" level="any" count="*[local-name()='sections']//*[local-name()='table'][not(@unnumbered='true')] | *[local-name()='preface']//*[local-name()='table'][not(@unnumbered='true')]"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:value-of select="ogc:name/text()"/>
		</item>
	</xsl:template>
	
	
	
	<xsl:template match="ogc:formula" mode="contents">
		<item level="" id="{@id}" display="false">
			<xsl:attribute name="section">
				<xsl:text>Formula (</xsl:text><xsl:number format="A.1" level="multiple" count="ogc:annex | ogc:formula"/><xsl:text>)</xsl:text>
			</xsl:attribute>
		</item>
	</xsl:template>
	
	<xsl:template match="ogc:fn" mode="contents"/>
	<!-- ============================= -->
	<!-- ============================= -->
	
	<xsl:template match="/ogc:ogc-standard/ogc:bibdata/ogc:uri[not(@type)]">
		<fo:block margin-bottom="12pt">
			<xsl:text>URL for this OGC® document: </xsl:text>
			<xsl:value-of select="."/><xsl:text> </xsl:text>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="/ogc:ogc-standard/ogc:bibdata/ogc:edition">
		<fo:block margin-bottom="12pt">
			<xsl:text>Version: </xsl:text>
			<xsl:value-of select="."/><xsl:text> </xsl:text>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="ogc:license-statement//ogc:title">
		<fo:block text-align="center" font-weight="bold" margin-top="4pt">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="ogc:license-statement//ogc:p">
		<fo:block font-size="8pt" margin-top="14pt" line-height="115%">
			<xsl:if test="following-sibling::ogc:p">
				<xsl:attribute name="margin-bottom">14pt</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="ogc:feedback-statement">
		<fo:block margin-top="12pt" margin-bottom="12pt">
			<xsl:apply-templates select="ogc:clause[1]"/>
		</fo:block>
	</xsl:template>
		
	<xsl:template match="ogc:copyright-statement//ogc:title">
		<fo:block font-weight="bold" text-align="center">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	<xsl:template match="ogc:copyright-statement//ogc:p">
		<fo:block margin-bottom="12pt">
			<xsl:if test="not(following-sibling::p)">
				<xsl:attribute name="margin-bottom">10pt</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="text-align">
				<xsl:choose>
					<xsl:when test="@align"><xsl:value-of select="@align"/></xsl:when>
					<xsl:otherwise>left</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="ogc:legal-statement">
		<fo:block-container border="0.5pt solid black" margin-bottom="12pt" margin-left="-2mm" margin-right="-2mm">
			<fo:block-container margin-left="0mm" margin-right="0mm">
				<fo:block margin-left="2mm" margin-right="2mm">
					<xsl:apply-templates/>
				</fo:block>
			</fo:block-container>
		</fo:block-container>
	</xsl:template>

	
	<xsl:template match="ogc:legal-statement//ogc:title">
		<fo:block text-align="center" font-weight="bold" padding-top="2mm" margin-bottom="6pt">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="ogc:legal-statement//ogc:p">
		<fo:block margin-bottom="6pt">
			<xsl:if test="not(following-sibling::ogc:p)">
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="text-align">
				<xsl:choose>
					<xsl:when test="@align"><xsl:value-of select="@align"/></xsl:when>
					<xsl:otherwise>left</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	
	<!-- Introduction -->
	<xsl:template match="ogc:ogc-standard/ogc:preface/ogc:introduction" mode="introduction">
		<fo:block break-after="page"/>
		<xsl:apply-templates select="current()"/>
	</xsl:template>
	<!-- Abstract -->
	<xsl:template match="ogc:ogc-standard/ogc:preface/ogc:abstract" mode="abstract">
		<fo:block break-after="page"/>
		<xsl:apply-templates select="current()"/>
	</xsl:template>
	<!-- Preface -->
	<xsl:template match="ogc:ogc-standard/ogc:preface/ogc:foreword" mode="preface">
		<xsl:param name="sectionNum"/>
		<fo:block break-after="page"/>
		<xsl:apply-templates select="current()">
			<xsl:with-param name="sectionNum" select="$sectionNum"/>
		</xsl:apply-templates>
	</xsl:template>
	<!-- Abstract, Preface -->
	<xsl:template match="ogc:ogc-standard/ogc:preface/*">
		<xsl:param name="sectionNum" select="'1'"/>
		<xsl:if test="not(ogc:title)">
			<xsl:variable name="id">
				<xsl:choose>
					<xsl:when test="@id">
						<xsl:value-of select="@id"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="local-name()"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<fo:block id="{$id}" font-size="13pt" font-weight="bold" margin-bottom="12pt" color="rgb(14, 26, 133)">
				<xsl:number format="i." value="$sectionNum"/><fo:inline padding-right="3mm">&#xA0;</fo:inline>
				<xsl:variable name="name" select="local-name()"/>
				<xsl:value-of select="translate(substring($name, 1, 1), $lower, $upper)"/><xsl:value-of select="substring($name, 2)"/>
			</fo:block>
		</xsl:if>
		<xsl:apply-templates />
	</xsl:template>
	<!-- Keywords -->
	<xsl:template match="/ogc:ogc-standard/ogc:bibdata/ogc:keyword">
		<xsl:param name="sectionNum" select="'1'"/>
		<fo:block id="keywords" font-size="13pt" font-weight="bold" margin-top="13.5pt" margin-bottom="12pt" color="rgb(14, 26, 133)">
			<xsl:number format="i." value="$sectionNum"/><fo:inline padding-right="2mm">&#xA0;</fo:inline>
			<xsl:text>Keywords</xsl:text>
		</fo:block>
		<fo:block margin-bottom="12pt">The following are keywords to be used by search engines and document catalogues.</fo:block>
		<fo:block margin-bottom="12pt">
			<xsl:for-each select="/ogc:ogc-standard/ogc:bibdata/ogc:keyword">
				<xsl:value-of select="."/>
				<xsl:if test="position() != last()">, </xsl:if>
			</xsl:for-each>
		</fo:block>
	</xsl:template>
	<!-- Submitting Organizations -->
	<xsl:template match="/ogc:ogc-standard/ogc:bibdata/ogc:contributor[ogc:role/@type='author']/ogc:organization/ogc:name">
		<xsl:param name="sectionNum" select="'1'"/>
		<fo:block id="submitting_orgs" font-size="13pt" font-weight="bold" color="rgb(14, 26, 133)" margin-top="13.5pt" margin-bottom="12pt">
			<xsl:number format="i." value="$sectionNum"/><fo:inline padding-right="3mm">&#xA0;</fo:inline>
			<xsl:text>Submitting Organizations</xsl:text>
		</fo:block>
		<fo:block margin-bottom="12pt">The following organizations submitted this Document to the Open Geospatial Consortium (OGC):</fo:block>
		<fo:list-block provisional-distance-between-starts="6.5mm" margin-bottom="12pt" line-height="115%">
			<xsl:for-each select="/ogc:ogc-standard/ogc:bibdata/ogc:contributor[ogc:role/@type='author']/ogc:organization/ogc:name">
				<fo:list-item>
					<fo:list-item-label end-indent="label-end()">
						<fo:block>&#x2014;</fo:block>
					</fo:list-item-label>
					<fo:list-item-body start-indent="body-start()" line-height-shift-adjustment="disregard-shifts">
						<fo:block>
							<xsl:apply-templates />
						</fo:block>
					</fo:list-item-body>
				</fo:list-item>
			</xsl:for-each>
		</fo:list-block>
	</xsl:template>

	
	<!-- clause, terms, clause, ...-->
	<xsl:template match="ogc:ogc-standard/ogc:sections/*">
		<xsl:param name="sectionNum"/>
		<xsl:param name="sectionNumSkew" select="0"/>
		<fo:block>
			<xsl:variable name="pos"><xsl:number count="ogc:sections/ogc:clause[not(@id='_scope') and not(@id='conformance') and not(@id='_conformance')]"/></xsl:variable> <!--  | ogc:sections/ogc:terms -->
			<xsl:if test="$pos &gt;= 2">
				<xsl:attribute name="space-before">18pt</xsl:attribute>
			</xsl:if>
			<xsl:variable name="sectionNum_">
				<xsl:choose>
					<xsl:when test="$sectionNum"><xsl:value-of select="$sectionNum"/></xsl:when>
					<xsl:when test="$sectionNumSkew != 0">
						<xsl:variable name="number"><xsl:number count="ogc:sections/ogc:clause[not(@id='_scope') and not(@id='conformance') and not(@id='_conformance')]"/></xsl:variable> <!--  | ogc:sections/ogc:terms -->
						<xsl:value-of select="$number + $sectionNumSkew"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:number count="*"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:if test="not(ogc:title)">
				<fo:block margin-top="3pt" margin-bottom="12pt">
					<xsl:value-of select="$sectionNum_"/><xsl:number format=".1 " level="multiple" count="ogc:clause[not(@id='_scope') and not(@id='conformance') and not(@id='_conformance')]" />
				</fo:block>
			</xsl:if>
			<xsl:apply-templates>
				<xsl:with-param name="sectionNum" select="$sectionNum_"/>
			</xsl:apply-templates>
		</fo:block>
	</xsl:template>
	

	
	<xsl:template match="ogc:clause//ogc:clause[not(ogc:title)]">
		<xsl:param name="sectionNum"/>
		<xsl:variable name="section">
			<xsl:call-template name="getSection">
				<xsl:with-param name="sectionNum" select="$sectionNum"/>
			</xsl:call-template>
		</xsl:variable>
		
		<fo:block margin-top="3pt" >
			<fo:inline font-weight="bold" padding-right="3mm">
				<xsl:value-of select="$section"/>
			</fo:inline>
			<xsl:apply-templates>
				<xsl:with-param name="sectionNum" select="$sectionNum"/>
				<xsl:with-param name="inline" select="'true'"/>
			</xsl:apply-templates>
		</fo:block>
	</xsl:template>
	
	
	<xsl:template match="ogc:title">
		<xsl:param name="sectionNum"/>
		
		<xsl:variable name="parent-name"  select="local-name(..)"/>
		<xsl:variable name="references_num_current">
			<xsl:number level="any" count="ogc:references"/>
		</xsl:variable>
		
		<xsl:variable name="id">
			<xsl:call-template name="getId"/>
		</xsl:variable>
		
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		
		<xsl:variable name="section">
			<xsl:call-template name="getSection">
				<xsl:with-param name="sectionNum" select="$sectionNum"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="font-size">
			<xsl:choose>
				<xsl:when test="ancestor::ogc:preface and $level &gt;= 2">12pt</xsl:when>
				<xsl:when test="ancestor::ogc:preface">13pt</xsl:when>
				<xsl:when test="$level = 1">13pt</xsl:when>
				<xsl:when test="$level = 2 and ancestor::ogc:terms">11pt</xsl:when>
				<xsl:when test="$level = 2">12pt</xsl:when>
				<xsl:when test="$level &gt;= 3">11pt</xsl:when>
				<xsl:otherwise>16pt</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="element-name">
			<xsl:choose>
				<xsl:when test="../@inline-header = 'true'">fo:inline</xsl:when>
				<xsl:otherwise>fo:block</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="color" select="'rgb(14, 26, 133)'"/>
		
		<xsl:choose>
			<xsl:when test="$parent-name = 'annex'">
				<fo:block id="{$id}" font-size="12pt" font-weight="bold" text-align="center" margin-bottom="12pt" keep-with-next="always" color="{$color}">
					<xsl:value-of select="$section"/>
					<xsl:if test=" ../@obligation">
						<xsl:value-of select="$linebreak"/>
						<fo:inline font-weight="normal">(<xsl:value-of select="../@obligation"/>)</fo:inline>
					</xsl:if>
					<xsl:value-of select="$linebreak"/>
					<xsl:apply-templates />
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="{$element-name}">
					<xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute>
					<xsl:attribute name="font-size"><xsl:value-of select="$font-size"/></xsl:attribute>
					<xsl:attribute name="font-weight">bold</xsl:attribute>
					<xsl:attribute name="space-before">13.5pt</xsl:attribute>
					<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
					<xsl:attribute name="keep-with-next">always</xsl:attribute>		
					<xsl:attribute name="color"><xsl:value-of select="$color"/></xsl:attribute>
					<xsl:if test="$section != ''">
						<xsl:if test="$section != '0'">
							<xsl:value-of select="$section"/><xsl:text>.</xsl:text>
							<xsl:choose>
								<xsl:when test="$level &gt;= 5"/>
								<xsl:when test="$level &gt;= 4">
									<fo:inline padding-right="4mm">&#xA0;</fo:inline>
								</xsl:when>
								<xsl:when test="$level &gt;= 3 and ancestor::ogc:terms">
									<fo:inline padding-right="2mm">&#xA0;</fo:inline>
								</xsl:when>
								<xsl:when test="$level &gt;= 2">
									<fo:inline padding-right="3mm">&#xA0;</fo:inline>
								</xsl:when>
								<xsl:when test="$level = 1">
									<fo:inline padding-right="3mm">&#xA0;</fo:inline>
								</xsl:when>
								<xsl:otherwise>
									<fo:inline padding-right="1mm">&#xA0;</fo:inline>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:if>
					</xsl:if>
					<xsl:apply-templates />
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
	
	<xsl:template match="ogc:p">
		<xsl:param name="inline" select="'false'"/>
		<xsl:variable name="previous-element" select="local-name(preceding-sibling::*[1])"/>
		<xsl:variable name="element-name">
			<xsl:choose>
				<xsl:when test="$inline = 'true'">fo:inline</xsl:when>
				<xsl:when test="../@inline-header = 'true' and $previous-element = 'title'">fo:inline</xsl:when> <!-- first paragraph after inline title -->
				<xsl:when test="local-name(..) = 'admonition'">fo:inline</xsl:when>
				<xsl:otherwise>fo:block</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:element name="{$element-name}">
			<xsl:attribute name="id">
				<xsl:value-of select="@id"/>
			</xsl:attribute>
			<xsl:attribute name="text-align">
				<xsl:choose>
					<!-- <xsl:when test="ancestor::ogc:preface">justify</xsl:when> -->
					<xsl:when test="@align"><xsl:value-of select="@align"/></xsl:when>
					<xsl:otherwise>left</xsl:otherwise><!-- justify -->
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="space-after">
				<xsl:choose>
					<xsl:when test="ancestor::ogc:li">0pt</xsl:when>
					<xsl:otherwise>12pt</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="line-height">115%</xsl:attribute>
			<xsl:apply-templates />
		</xsl:element>
		<xsl:if test="$element-name = 'fo:inline' and not($inline = 'true') and not(local-name(..) = 'admonition')">
			<fo:block margin-bottom="12pt">
				 <xsl:if test="ancestor::ogc:annex">
					<xsl:attribute name="margin-bottom">0</xsl:attribute>
				 </xsl:if>
				<xsl:value-of select="$linebreak"/>
			</fo:block>
		</xsl:if>
		<xsl:if test="$inline = 'true'">
			<fo:block>&#xA0;</fo:block>
		</xsl:if>
	</xsl:template>
	
	<!--
	<fn reference="1">
			<p id="_8e5cf917-f75a-4a49-b0aa-1714cb6cf954">Formerly denoted as 15 % (m/m).</p>
		</fn>
	-->
	<xsl:template match="ogc:title/ogc:fn | ogc:p/ogc:fn[not(ancestor::ogc:table)]" priority="2">
		<fo:footnote keep-with-previous.within-line="always">
			<xsl:variable name="number" select="@reference"/>
			
			<fo:inline font-size="65%" keep-with-previous.within-line="always" vertical-align="super">
				<fo:basic-link internal-destination="footnote_{@reference}" fox:alt-text="footnote {@reference}">
					<xsl:value-of select="$number"/><!--  + count(//ogc:bibitem/ogc:note) -->
				</fo:basic-link>
			</fo:inline>
			<fo:footnote-body>
				<fo:block font-size="10pt" margin-bottom="12pt" font-weight="normal" text-indent="0" start-indent="0" color="black" text-align="justify">
					<fo:inline id="footnote_{@reference}" keep-with-next.within-line="always" font-size="60%" vertical-align="super"> <!-- baseline-shift="30%" padding-right="3mm" font-size="60%"  alignment-baseline="hanging" -->
						<xsl:value-of select="$number "/><!-- + count(//ogc:bibitem/ogc:note) -->
					</fo:inline>
					<xsl:for-each select="ogc:p">
							<xsl:apply-templates />
					</xsl:for-each>
				</fo:block>
			</fo:footnote-body>
		</fo:footnote>
	</xsl:template>

	<xsl:template match="ogc:fn/ogc:p">
		<fo:block>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="ogc:review">
		<!-- comment 2019-11-29 -->
		<!-- <fo:block font-weight="bold">Review:</fo:block>
		<xsl:apply-templates /> -->
	</xsl:template>

	<xsl:template match="text()">
		<xsl:value-of select="."/>
	</xsl:template>
	

	<xsl:template match="ogc:image"> <!-- only for without outer figure -->
		<fo:block margin-top="12pt" margin-bottom="6pt">
			<fo:external-graphic src="{@src}" width="100%" content-height="scale-to-fit" scaling="uniform" fox:alt-text="Image {@alt}"/> <!-- content-width="75%"  -->
		</fo:block>
	</xsl:template>

	<xsl:template match="ogc:figure">
		<xsl:variable name="title">
			<xsl:text>Figure </xsl:text>
		</xsl:variable>
		
		<fo:block-container id="{@id}">
			<fo:block>
				<xsl:apply-templates />
			</fo:block>
			<xsl:call-template name="fn_display_figure"/>
			<xsl:for-each select="ogc:note//ogc:p">
				<xsl:call-template name="note"/>
			</xsl:for-each>
			<fo:block font-size="11pt" font-weight="bold" text-align="center" margin-top="12pt" margin-bottom="6pt" keep-with-previous="always">
				
				<xsl:choose>
					<xsl:when test="ancestor::ogc:annex">
						<xsl:choose>
							<xsl:when test="local-name(..) = 'figure'">
								<xsl:number format="a) "/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$title"/><xsl:number format="A.1-1" level="multiple" count="ogc:annex | ogc:figure"/>
							</xsl:otherwise>
						</xsl:choose>
						
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$title"/><xsl:number format="1" level="any" count="ogc:sourcecode[not(@unnumbered='true') and not(ancestor::ogc:example)] | ogc:figure"/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:if test="ogc:name">
					<xsl:if test="not(local-name(..) = 'figure')">
						<xsl:text> — </xsl:text>
					</xsl:if>
					<xsl:value-of select="ogc:name"/>
				</xsl:if>
			</fo:block>
		</fo:block-container>
	</xsl:template>
	
	<xsl:template match="ogc:figure/ogc:name"/>
	<xsl:template match="ogc:figure/ogc:fn"/>
	<xsl:template match="ogc:figure/ogc:note"/>
	
	
	<xsl:template match="ogc:figure/ogc:image">
		<fo:block text-align="center">
			<fo:external-graphic src="{@src}" width="100%" content-height="scale-to-fit" scaling="uniform" fox:alt-text="Image {@alt}"/> <!-- content-width="75%"  -->
		</fo:block>
	</xsl:template>
	
	
	<xsl:template match="ogc:bibitem">
		<fo:block id="{@id}" margin-bottom="12pt" start-indent="12mm" text-indent="-12mm" line-height="115%">
			<xsl:if test=".//ogc:fn">
				<xsl:attribute name="line-height-shift-adjustment">disregard-shifts</xsl:attribute>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="ogc:formattedref">
					<xsl:apply-templates select="ogc:formattedref"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:for-each select="ogc:contributor[ogc:role/@type='publisher']/ogc:organization/ogc:name">
						<xsl:apply-templates />
						<xsl:if test="position() != last()">, </xsl:if>
						<xsl:if test="position() = last()">: </xsl:if>
					</xsl:for-each>
						<!-- ogc:docidentifier -->
					<xsl:if test="ogc:docidentifier">
						<xsl:value-of select="ogc:docidentifier/@type"/><xsl:text> </xsl:text>
						<xsl:value-of select="ogc:docidentifier"/>
					</xsl:if>
					<xsl:apply-templates select="ogc:note"/>
					<xsl:if test="ogc:docidentifier">, </xsl:if>
					<fo:inline font-style="italic">
						<xsl:choose>
							<xsl:when test="ogc:title[@type = 'main' and @language = 'en']">
								<xsl:value-of select="ogc:title[@type = 'main' and @language = 'en']"/><xsl:text>. </xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="ogc:title"/><xsl:text>. </xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</fo:inline>
					<xsl:for-each select="ogc:contributor[ogc:role/@type='publisher']/ogc:organization/ogc:name">
						<xsl:apply-templates />
						<xsl:if test="position() != last()">, </xsl:if>
					</xsl:for-each>
					<xsl:if test="ogc:date[@type='published']/ogc:on">
						<xsl:text>(</xsl:text><xsl:value-of select="ogc:date[@type='published']/ogc:on"/><xsl:text>)</xsl:text>
					</xsl:if>
			</xsl:otherwise>
			</xsl:choose>
		</fo:block>
	</xsl:template>
	
	
	<xsl:template match="ogc:bibitem/ogc:note">
		<fo:footnote>
			<xsl:variable name="number">
				<xsl:choose>
					<xsl:when test="ancestor::ogc:references[preceding-sibling::ogc:references]">
						<xsl:number level="any" count="ogc:references[preceding-sibling::ogc:references]//ogc:bibitem/ogc:note"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:number level="any" count="ogc:bibitem/ogc:note"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<fo:inline font-size="65%" keep-with-previous.within-line="always" vertical-align="super"> <!--  60% baseline-shift="35%"   -->
				<fo:basic-link internal-destination="footnote_{../@id}" fox:alt-text="footnote {$number}">
					<xsl:value-of select="$number"/><!-- <xsl:text>)</xsl:text> -->
				</fo:basic-link>
			</fo:inline>
			<fo:footnote-body>
				<fo:block font-size="10pt" margin-bottom="12pt" start-indent="0pt">
					<fo:inline id="footnote_{../@id}" keep-with-next.within-line="always" font-size="60%" vertical-align="super"><!-- baseline-shift="30%" padding-right="9mm"  alignment-baseline="hanging" -->
						<xsl:value-of select="$number"/><!-- <xsl:text>)</xsl:text> -->
					</fo:inline>
					<xsl:apply-templates />
				</fo:block>
			</fo:footnote-body>
		</fo:footnote>
	</xsl:template>
	
	
	
	<xsl:template match="ogc:ul | ogc:ol">
		<fo:list-block provisional-distance-between-starts="6.5mm" margin-bottom="12pt" line-height="115%">
			<xsl:if test="ancestor::ogc:ul | ancestor::ogc:ol">
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="following-sibling::*[1][local-name() = 'ul' or local-name() = 'ol']">
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates />
		</fo:list-block>
	</xsl:template>
	
	<xsl:template match="ogc:li">
		<fo:list-item>
			<fo:list-item-label end-indent="label-end()">
				<fo:block>
					<xsl:choose>
						<xsl:when test="local-name(..) = 'ul'">&#x2014;</xsl:when> <!-- dash -->
						<xsl:otherwise> <!-- for ordered lists -->
							<xsl:choose>
								<xsl:when test="../@type = 'arabic'">
									<xsl:number format="a)"/>
								</xsl:when>
								<xsl:when test="../@type = 'alphabet'">
									<xsl:number format="1)"/>
								</xsl:when>
								<xsl:when test="../@type = 'alphabet_upper'">
									<xsl:number format="A)"/>
								</xsl:when>
								
								<xsl:when test="../@type = 'roman'">
									<xsl:number format="i)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:number format="1)"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</fo:block>
			</fo:list-item-label>
			<fo:list-item-body start-indent="body-start()" line-height-shift-adjustment="disregard-shifts">
				<xsl:apply-templates />
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>
	
	<xsl:template match="ogc:ul/ogc:note | ogc:ol/ogc:note">
		<fo:list-item font-size="10pt">
			<fo:list-item-label><fo:block></fo:block></fo:list-item-label>
			<fo:list-item-body>
				<xsl:apply-templates />
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>
	
	<xsl:template match="ogc:link">
		<fo:inline>
			<fo:basic-link external-destination="{@target}" color="blue" text-decoration="underline" fox:alt-text="{@target}">
				<xsl:choose>
					<xsl:when test="normalize-space(.) = ''">
						<xsl:value-of select="@target"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates />
					</xsl:otherwise>
				</xsl:choose>
			</fo:basic-link>
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="ogc:preferred">
		<xsl:param name="sectionNum"/>
		<xsl:variable name="section">
			<xsl:call-template name="getSection">
				<xsl:with-param name="sectionNum" select="$sectionNum"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		<xsl:variable name="font-size">
			<xsl:choose>
				<xsl:when test="$level &gt;= 2">11pt</xsl:when>
				<xsl:otherwise>12pt</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<fo:block font-size="{$font-size}">
			<fo:block font-weight="bold" keep-with-next="always">
				<fo:inline id="{../@id}">
					<xsl:value-of select="$section"/><xsl:text>.</xsl:text>
				</fo:inline>
			</fo:block>
			<fo:block font-weight="bold" keep-with-next="always" line-height="1">
				<xsl:apply-templates />
			</fo:block>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="ogc:admitted">
		<fo:block font-size="11pt">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="ogc:deprecates">
		<fo:block>DEPRECATED: <xsl:apply-templates /></fo:block>
	</xsl:template>
	
	<xsl:template match="ogc:definition[preceding-sibling::ogc:domain]">
		<xsl:apply-templates />
	</xsl:template>
	<xsl:template match="ogc:definition[preceding-sibling::ogc:domain]/ogc:p">
		<fo:inline> <xsl:apply-templates /></fo:inline>
		<fo:block>&#xA0;</fo:block>
	</xsl:template>
	
	<xsl:template match="ogc:definition">
		<fo:block space-after="6pt">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="ogc:termsource">
		<fo:block margin-bottom="12pt" keep-with-previous="always">
			<!-- Example: [SOURCE: ISO 5127:2017, 3.1.6.02] -->
			<fo:basic-link internal-destination="{ogc:origin/@bibitemid}" fox:alt-text="{ogc:origin/@citeas}">
				<xsl:text>[SOURCE: </xsl:text>
				<fo:inline color="blue" text-decoration="underline">
					<xsl:value-of select="ogc:origin/@citeas"/>
					<xsl:if test="ogc:origin/ogc:locality/ogc:referenceFrom">
						<xsl:text>, </xsl:text><xsl:value-of select="ogc:origin/ogc:locality/ogc:referenceFrom"/>
					</xsl:if>
				</fo:inline>
			</fo:basic-link>
			<xsl:apply-templates select="ogc:modification"/>
			<xsl:text>]</xsl:text>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="ogc:modification">
		<xsl:text>, modified — </xsl:text>
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="ogc:modification/ogc:p">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template>
	
	<xsl:template match="ogc:termnote">
		<fo:block font-size="10pt" margin-bottom="12pt">
			<xsl:text>Note </xsl:text>
			<xsl:number />
			<xsl:text> to entry: </xsl:text>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="ogc:termnote/ogc:p">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template>
	
	<xsl:template match="ogc:domain">
		<fo:inline>&lt;<xsl:apply-templates/>&gt;</fo:inline>
	</xsl:template>
	
	
	<xsl:template match="ogc:termexample">
		<fo:block font-size="10pt" margin-bottom="12pt">
			<fo:inline padding-right="10mm">EXAMPLE</fo:inline>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="ogc:termexample/ogc:p">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template>

	
	<xsl:template match="ogc:annex">
		<fo:block break-after="page"/>
		<xsl:apply-templates />
	</xsl:template>

	
	<!-- [position() &gt; 1] -->
	<xsl:template match="ogc:references[@id != '_normative_references' and @id != '_references']">
		<fo:block break-after="page"/>
		<fo:block line-height="120%">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>


	<!-- Example: [1] ISO 9:1995, Information and documentation – Transliteration of Cyrillic characters into Latin characters – Slavic and non-Slavic languages -->
	<!-- <xsl:template match="ogc:references[@id = '_bibliography']/ogc:bibitem"> [position() &gt; 1] -->
	<xsl:template match="ogc:references[@id != '_normative_references' and @id != '_references']/ogc:bibitem">
		<fo:list-block margin-bottom="12pt" provisional-distance-between-starts="12mm">
			<fo:list-item>
				<fo:list-item-label end-indent="label-end()">
					<fo:block>
						<fo:inline id="{@id}">
							<xsl:number format="[1]"/>
						</fo:inline>
					</fo:block>
				</fo:list-item-label>
				<fo:list-item-body start-indent="body-start()">
					<fo:block>
						
						<xsl:if test="not(ogc:formattedref)">
							<xsl:choose>
								<xsl:when test="ogc:contributor[ogc:role/@type='publisher']/ogc:organization/ogc:abbreviation">
									<xsl:for-each select="ogc:contributor[ogc:role/@type='publisher']/ogc:organization/ogc:abbreviation">
										<xsl:value-of select="."/>
										<xsl:if test="position() != last()">/</xsl:if>
									</xsl:for-each>
									<xsl:text>: </xsl:text>
								</xsl:when>
								<xsl:when test="ogc:contributor[ogc:role/@type='publisher']/ogc:organization/ogc:name">
									<xsl:value-of select="ogc:contributor[ogc:role/@type='publisher']/ogc:organization/ogc:name"/>
									<xsl:text>: </xsl:text>
								</xsl:when>
							</xsl:choose>
							
						</xsl:if>
						
						<xsl:if test="ogc:docidentifier">
							<xsl:choose>
								<xsl:when test="ogc:docidentifier/@type = 'ISO' and ogc:formattedref"/>
								<xsl:when test="ogc:docidentifier/@type = 'OGC' and ogc:formattedref"/>
								<xsl:otherwise><fo:inline>
									<xsl:if test="ogc:docidentifier/@type = 'OGC'">OGC </xsl:if>
									<xsl:value-of select="ogc:docidentifier"/><xsl:apply-templates select="ogc:note"/>, </fo:inline></xsl:otherwise>
							</xsl:choose>
						</xsl:if>
						
					
						
						<xsl:choose>
							<xsl:when test="ogc:title[@type = 'main' and @language = 'en']">
								<xsl:apply-templates select="ogc:title[@type = 'main' and @language = 'en']"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates select="ogc:title"/>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:if test="ogc:contributor[ogc:role/@type='publisher']/ogc:organization/ogc:name">
							<xsl:text>, </xsl:text>
							<xsl:for-each select="ogc:contributor[ogc:role/@type='publisher']/ogc:organization/ogc:name">
								<xsl:if test="position() != last()">and </xsl:if>
								<xsl:value-of select="."/>
							</xsl:for-each>
							
						</xsl:if>
						<xsl:if test="ogc:place">
							<xsl:text>, </xsl:text>
							<xsl:value-of select="ogc:place"/>
						</xsl:if>
						<xsl:if test="ogc:date[@type='published']/ogc:on">
							<xsl:text> (</xsl:text><xsl:value-of select="ogc:date[@type='published']/ogc:on"/><xsl:text>).</xsl:text>
						</xsl:if>
						<xsl:apply-templates select="ogc:formattedref"/>
					</fo:block>
				</fo:list-item-body>
			</fo:list-item>
		</fo:list-block>
	</xsl:template>
	
	<!-- <xsl:template match="ogc:references[@id = '_bibliography']/ogc:bibitem" mode="contents"/> [position() &gt; 1] -->
	<xsl:template match="ogc:references[@id != '_normative_references' and @id != '_references']/ogc:bibitem" mode="contents"/>
	
	<!-- <xsl:template match="ogc:references[@id = '_bibliography']/ogc:bibitem/ogc:title"> [position() &gt; 1]-->
	<xsl:template match="ogc:references[@id != '_normative_references' and  @id != '_references']/ogc:bibitem/ogc:title">
		<fo:inline font-style="italic">
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>

	<xsl:template match="ogc:quote">
		<fo:block margin-top="12pt" margin-left="13mm" margin-right="12mm">
			<xsl:apply-templates select=".//ogc:p"/>
		</fo:block>
		<xsl:if test="ogc:author or ogc:source">
			<fo:block text-align="right" margin-right="25mm">
				<!-- — ISO, ISO 7301:2011, Clause 1 -->
				<xsl:if test="ogc:author">
					<xsl:text>— </xsl:text><xsl:value-of select="ogc:author"/>
				</xsl:if>
				<xsl:if test="ogc:source">
					<xsl:text>, </xsl:text>
					<xsl:apply-templates select="ogc:source"/>
				</xsl:if>
			</fo:block>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="ogc:source">
		<fo:basic-link internal-destination="{@bibitemid}" fox:alt-text="{@citeas}">
			<xsl:value-of select="@citeas" disable-output-escaping="yes"/>
			<xsl:if test="ogc:locality">
				<xsl:text>, </xsl:text>
				<xsl:apply-templates select="ogc:locality"/>
			</xsl:if>
		</fo:basic-link>
	</xsl:template>
	
	<xsl:template match="ogc:appendix">
		<fo:block font-size="12pt" font-weight="bold" margin-top="12pt" margin-bottom="12pt">
			<fo:inline padding-right="5mm">Appendix <xsl:number /></fo:inline>
			<xsl:apply-templates select="ogc:title" mode="process"/>
		</fo:block>
		<xsl:apply-templates />
	</xsl:template>
	
	<xsl:template match="ogc:appendix//ogc:example">
		<fo:block font-size="10pt" margin-bottom="12pt">
			<xsl:text>EXAMPLE</xsl:text>
			<xsl:if test="ogc:name">
				<xsl:text> — </xsl:text><xsl:apply-templates select="ogc:name" mode="process"/>
			</xsl:if>
		</fo:block>
		<xsl:apply-templates />
	</xsl:template>
	
	<xsl:template match="ogc:appendix//ogc:example/ogc:name"/>
	<xsl:template match="ogc:appendix//ogc:example/ogc:name" mode="process">
		<fo:inline><xsl:apply-templates /></fo:inline>
	</xsl:template>
	
	<xsl:template match="ogc:callout">		
			<fo:basic-link internal-destination="{@target}" fox:alt-text="{@target}">&lt;<xsl:apply-templates />&gt;</fo:basic-link>
	</xsl:template>
	
	<xsl:template match="ogc:annotation">
		<fo:block>
			
		</fo:block>
		<xsl:apply-templates />
	</xsl:template>
	
	<xsl:template match="ogc:annotation/text()"/>
	
	<xsl:template match="ogc:annotation/ogc:p">
		<xsl:variable name="annotation-id" select="../@id"/>
		<xsl:variable name="callout" select="//*[@target = $annotation-id]/text()"/>
		<fo:block id="{$annotation-id}">
			<xsl:value-of select="concat('&lt;', $callout, '&gt; ')"/>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	
	<xsl:template match="ogc:appendix/ogc:title"/>
	<xsl:template match="ogc:appendix/ogc:title" mode="process">
		<fo:inline><xsl:apply-templates /></fo:inline>
	</xsl:template>
	
	<xsl:template match="mathml:math">
		<fo:instream-foreign-object fox:alt-text="Math">
			<xsl:copy-of select="."/>
		</fo:instream-foreign-object>
	</xsl:template>
	
	<xsl:template match="ogc:xref">
		<fo:basic-link internal-destination="{@target}" fox:alt-text="{@target}">
			<xsl:variable name="section" select="xalan:nodeset($contents)//item[@id = current()/@target]/@section"/>
			<!-- <xsl:if test="not(starts-with($section, 'Figure') or starts-with($section, 'Table'))"> -->
				<xsl:attribute name="color">blue</xsl:attribute>
				<xsl:attribute name="text-decoration">underline</xsl:attribute>
			<!-- </xsl:if> -->
			<xsl:variable name="type" select="xalan:nodeset($contents)//item[@id = current()/@target]/@type"/>
			<xsl:variable name="root" select="xalan:nodeset($contents)//item[@id = current()/@target]/@root"/>
			
			<xsl:choose>
				<xsl:when test="normalize-space(.) != ''">
					<xsl:apply-templates/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="$type = 'clause' and $root != 'annex'">Clause </xsl:when><!-- and not (ancestor::annex) -->
						<xsl:when test="$type = 'term' and ($root = 'clause' or $root = 'terms')">Clause </xsl:when>
						<xsl:when test="$type = 'clause' and $root = 'annex'">Annex </xsl:when>
						<xsl:otherwise></xsl:otherwise> <!-- <xsl:value-of select="$type"/> -->
					</xsl:choose>
					<xsl:value-of select="$section"/>
				</xsl:otherwise>
			</xsl:choose>
      </fo:basic-link>
	</xsl:template>

	<xsl:template match="ogc:sourcecode">
		<fo:block font-family="Courier" font-size="10pt" margin-bottom="6pt" keep-with-next="always" line-height="113%">
			<xsl:choose>
				<xsl:when test="@lang = 'en'"></xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="white-space">pre</xsl:attribute>
					<xsl:attribute name="wrap-option">wrap</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates/>
		</fo:block>
		<xsl:choose>
			<xsl:when test="@unnumbered='true'"></xsl:when>
			<xsl:when test="ancestor::ogc:example"/>
			<xsl:when test="ancestor::ogc:td"/>
			<xsl:when test="ancestor::ogc:annex">
				<xsl:variable name="id_annex" select="ancestor::ogc:annex/@id"/>
				<xsl:choose>
					<xsl:when test="count(//ogc:annex) = 1">
						<xsl:value-of select="/ogc:nist-standard/ogc:bibdata/ogc:ext/ogc:structuredidentifier/ogc:annexid"/><xsl:number format="-1" level="any" count="ogc:annex//ogc:sourcecode"/>
					</xsl:when>
					<xsl:otherwise>
						<fo:block font-size="11pt" font-weight="bold" text-align="center" margin-bottom="12pt">
							<xsl:text>Figure </xsl:text>
							<xsl:number format="A." level="multiple" count="ogc:annex"/>
							<xsl:number format="1" level="any" count="ogc:sourcecode[ancestor::ogc:annex/@id = $id_annex and not(@unnumbered='true') and not(ancestor::ogc:example)]"/>
							<xsl:if test="ogc:name">
								<xsl:text> — </xsl:text>
								<xsl:apply-templates select="ogc:name/*"/>
							</xsl:if>
						</fo:block>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<fo:block font-size="11pt" font-weight="bold" text-align="center" margin-bottom="12pt">
					<xsl:text>Figure </xsl:text>
					<xsl:number format="1" level="any" count="ogc:sourcecode[not(@unnumbered='true') and not(ancestor::ogc:example)] | ogc:figure"/>
					<xsl:if test="ogc:name">
						<xsl:text> — </xsl:text>
						<xsl:apply-templates select="ogc:name/*"/>
					</xsl:if>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="ogc:sourcecode/text()">
		<xsl:variable name="text">
			<xsl:call-template name="add-zero-spaces-equal"/>
		</xsl:variable>
		<xsl:call-template name="add-zero-spaces">
			<xsl:with-param name="text" select="$text"/>
		</xsl:call-template>
	</xsl:template>
	
	
		<xsl:template match="ogc:sourcecode/ogc:name"/>
	
	<xsl:template match="ogc:example">
		<fo:block font-size="10pt" margin-top="12pt" margin-bottom="12pt" font-weight="bold" keep-with-next="always">
			<xsl:text>EXAMPLE</xsl:text>
			<xsl:if test="following-sibling::ogc:example or preceding-sibling::ogc:example">
				<xsl:number format=" 1"/>
			</xsl:if>
			<xsl:if test="ogc:name">
				<xsl:text> — </xsl:text>
				<xsl:apply-templates select="ogc:name/node()"/>
			</xsl:if>
		</fo:block>
		<fo:block  font-size="10pt" margin-left="12.5mm" margin-right="12.5mm">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="ogc:example/ogc:name"/>
	
	<xsl:template match="ogc:example/ogc:p">
		<fo:block  margin-bottom="14pt">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	
	
	<xsl:template match="ogc:note/ogc:p" name="note">
		<fo:block font-size="10pt" margin-top="12pt" margin-bottom="12pt" line-height="115%">
			<xsl:if test="ancestor::ogc:ul or ancestor::ogc:ol and not(ancestor::ogc:note[1]/following-sibling::*)">
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			</xsl:if>
			<xsl:variable name="clauseid" select="ancestor::ogc:clause[1]/@id"/>
			<fo:inline padding-right="4mm">
				<xsl:text>NOTE </xsl:text>
				<xsl:if test="count(//ogc:note[ancestor::ogc:clause[1][@id = $clauseid]]) &gt; 1">
					<xsl:number count="ogc:note[ancestor::ogc:clause[1][@id = $clauseid]]" level="any"/>
				</xsl:if>
			</fo:inline>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>

	<!-- <eref type="inline" bibitemid="ISO20483" citeas="ISO 20483:2013"><locality type="annex"><referenceFrom>C</referenceFrom></locality></eref> -->
	<xsl:template match="ogc:eref">
		<fo:basic-link internal-destination="{@bibitemid}" fox:alt-text="{@citeas}" color="blue" text-decoration="underline"> <!-- font-size="9pt" color="blue" vertical-align="super" -->
			<xsl:if test="@type = 'footnote'">
				<xsl:attribute name="keep-together.within-line">always</xsl:attribute>
				<xsl:attribute name="font-size">80%</xsl:attribute>
				<xsl:attribute name="keep-with-previous.within-line">always</xsl:attribute>
				<xsl:attribute name="vertical-align">super</xsl:attribute>
			</xsl:if>
			<xsl:if test="@type = 'inline'">
				<xsl:attribute name="color">blue</xsl:attribute>
				<xsl:attribute name="text-decoration">underline</xsl:attribute>
			</xsl:if>
			<!-- <xsl:if test="@type = 'inline'">
				<xsl:attribute name="text-decoration">underline</xsl:attribute>
			</xsl:if> -->
			<xsl:choose>
				<xsl:when test="@citeas and normalize-space(text()) = ''">
					<xsl:value-of select="@citeas" disable-output-escaping="yes"/>
				</xsl:when>
				<xsl:when test="@bibitemid and normalize-space(text()) = ''">
					<xsl:value-of select="//ogc:bibitem[@id = current()/@bibitemid]/ogc:docidentifier"/>
				</xsl:when>
				<xsl:otherwise></xsl:otherwise>
			</xsl:choose>
			<xsl:if test="ogc:locality">
				<xsl:text>, </xsl:text>
				<!-- <xsl:choose>
						<xsl:when test="ogc:locality/@type = 'section'">Section </xsl:when>
						<xsl:when test="ogc:locality/@type = 'clause'">Clause </xsl:when>
						<xsl:otherwise></xsl:otherwise>
					</xsl:choose> -->
					<xsl:apply-templates select="ogc:locality"/>
			</xsl:if>
			<xsl:apply-templates select="text()"/>
		</fo:basic-link>
	</xsl:template>
	
	<xsl:template match="ogc:locality">
		<xsl:choose>
			<xsl:when test="@type ='clause'">Clause </xsl:when>
			<xsl:when test="@type ='annex'">Annex </xsl:when>
			<xsl:otherwise><xsl:value-of select="@type"/></xsl:otherwise>
		</xsl:choose>
		<xsl:text> </xsl:text><xsl:value-of select="ogc:referenceFrom"/>
	</xsl:template>
	
	<xsl:template match="ogc:admonition">
		<fo:block-container border="0.5pt solid rgb(79, 129, 189)" color="rgb(79, 129, 189)" margin-left="16mm" margin-right="16mm" margin-bottom="12pt">
			<fo:block-container margin-left="0mm" margin-right="0mm" padding="2mm" padding-top="3mm">
				<fo:block font-size="11pt" margin-bottom="6pt" font-weight="bold" font-style="italic" text-align="center">
					<xsl:value-of select="translate(@type, $lower, $upper)"/>
				</fo:block>
				<fo:block font-style="italic">
					<xsl:apply-templates />
				</fo:block>
			</fo:block-container>
		</fo:block-container>
		
		
	</xsl:template>
	
	<xsl:template match="ogc:formula/ogc:dt/ogc:stem">
		<fo:inline>
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="ogc:formula/ogc:stem">
		<fo:block id="{../@id}" margin-top="6pt" margin-bottom="12pt">
			<fo:table table-layout="fixed" width="100%">
				<fo:table-column column-width="95%"/>
				<fo:table-column column-width="5%"/>
				<fo:table-body>
					<fo:table-row>
						<fo:table-cell display-align="center">
							<fo:block text-align="left" margin-left="5mm">
								<xsl:apply-templates />
							</fo:block>
						</fo:table-cell>
						<fo:table-cell display-align="center">
							<fo:block text-align="right">
								<xsl:choose>
									<xsl:when test="ancestor::ogc:annex">
										<xsl:text>(</xsl:text><xsl:number format="A.1" level="multiple" count="ogc:annex | ogc:formula"/><xsl:text>)</xsl:text>
									</xsl:when>
									<xsl:otherwise> <!-- not(ancestor::ogc:annex) -->
										<!-- <xsl:text>(</xsl:text><xsl:number level="any" count="ogc:formula"/><xsl:text>)</xsl:text> -->
									</xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</fo:table-body>
			</fo:table>
			<fo:inline keep-together.within-line="always">
			</fo:inline>
		</fo:block>
	</xsl:template>
	
	
	<xsl:template match="ogc:br" priority="2">
		<!-- <fo:block>&#xA0;</fo:block> -->
		<xsl:value-of select="$linebreak"/>
	</xsl:template>
	
	<xsl:template match="ogc:pagebreak">
		<fo:block break-after="page"/>
		<fo:block>&#xA0;</fo:block>
		<fo:block break-after="page"/>
	</xsl:template>
	
	<xsl:template match="ogc:bookmark">
		<fo:inline id="{@id}"></fo:inline>
	</xsl:template>
	
	<xsl:template name="insertHeaderFooter">
		<xsl:param name="pagenum-font-weight" select="'normal'"/>
		<fo:static-content flow-name="header-even">
			<fo:block-container height="17mm" display-align="before">
				<fo:block padding-top="12.5mm">
					<xsl:value-of select="$header"/>
				</fo:block>
			</fo:block-container>
		</fo:static-content>
		<fo:static-content flow-name="footer-even">
			<fo:block-container font-size="10pt" height="100%" display-align="after">
				<fo:table table-layout="fixed" width="100%">
					<fo:table-column column-width="10%"/>
					<fo:table-column column-width="90%"/>
					<fo:table-body>
						<fo:table-row>
							<fo:table-cell>
								<fo:block padding-bottom="5mm" font-weight="{$pagenum-font-weight}">
									<fo:page-number/>
								</fo:block>
							</fo:table-cell>
							<fo:table-cell padding-right="2mm">
								<fo:block padding-bottom="5mm" text-align="right">
								<xsl:value-of select="$copyright_short"/></fo:block>
							</fo:table-cell>
						</fo:table-row>
					</fo:table-body>
				</fo:table>
			</fo:block-container>
		</fo:static-content>
		<fo:static-content flow-name="header-odd">
			<fo:block-container height="17mm" display-align="before">
				<fo:block text-align="right" padding-top="12.5mm">
					<xsl:value-of select="$header"/>
				</fo:block>
			</fo:block-container>
		</fo:static-content>
		<fo:static-content flow-name="footer-odd">
			<fo:block-container font-size="10pt" height="100%" display-align="after">
				<fo:table table-layout="fixed" width="100%">
					<fo:table-column column-width="90%"/>
					<fo:table-column column-width="10%"/>
					<fo:table-body>
						<fo:table-row>
							<fo:table-cell>
								<fo:block padding-bottom="5mm"><xsl:value-of select="$copyright"/></fo:block>
							</fo:table-cell>
							<fo:table-cell padding-right="2mm">
								<fo:block padding-bottom="5mm" text-align="right" font-weight="{$pagenum-font-weight}"><fo:page-number/></fo:block>
							</fo:table-cell>
						</fo:table-row>
					</fo:table-body>
				</fo:table>
			</fo:block-container>
		</fo:static-content>
	</xsl:template>

	<xsl:template name="getId">
		<xsl:choose>
			<xsl:when test="../@id">
				<xsl:value-of select="../@id"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="text()"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="getLevel">
		<xsl:variable name="level_total" select="count(ancestor::*)"/>
		<xsl:variable name="level">
			<xsl:choose>
				<xsl:when test="ancestor::ogc:preface">
					<xsl:value-of select="$level_total - 2"/>
				</xsl:when>
				<xsl:when test="ancestor::ogc:sections">
					<xsl:value-of select="$level_total - 2"/>
				</xsl:when>
				<xsl:when test="ancestor::ogc:bibliography">
					<xsl:value-of select="$level_total - 2"/>
				</xsl:when>
				<xsl:when test="local-name(ancestor::*[1]) = 'annex'">1</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$level_total - 1"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$level"/>
	</xsl:template>

	<xsl:template name="getSection">
		<xsl:param name="sectionNum"/>
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		<xsl:variable name="section">
			<xsl:choose>
				<xsl:when test="ancestor::ogc:bibliography">
					<xsl:value-of select="$sectionNum"/>
				</xsl:when>
				<xsl:when test="ancestor::ogc:sections">
					<!-- 1, 2, 3, 4, ... from main section (not annex, bibliography, ...) -->
					<xsl:choose>
						<xsl:when test="$level = 1">
							<xsl:value-of select="$sectionNum"/>
						</xsl:when>
						<xsl:when test="$level &gt;= 2">
							<xsl:variable name="num">
								<xsl:number format=".1" level="multiple" count="ogc:clause/ogc:clause | ogc:clause/ogc:terms | ogc:terms/ogc:term | ogc:clause/ogc:term | ogc:clause/ogc:definitions | ogc:definitions/ogc:definitions | ogc:terms/ogc:definitions"/>
							</xsl:variable>
							<xsl:value-of select="concat($sectionNum, $num)"/>
						</xsl:when>
						<xsl:otherwise>
							<!-- z<xsl:value-of select="$sectionNum"/>z -->
						</xsl:otherwise>
					</xsl:choose>
					<!-- <xsl:text>.</xsl:text> -->
				</xsl:when>
				<!-- <xsl:when test="ancestor::ogc:annex[@obligation = 'informative']">
					<xsl:choose>
						<xsl:when test="$level = 1">
							<xsl:text>Annex  </xsl:text>
							<xsl:number format="I" level="any" count="ogc:annex[@obligation = 'informative']"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:number format="I.1" level="multiple" count="ogc:annex[@obligation = 'informative'] | ogc:clause"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when> -->
				<xsl:when test="ancestor::ogc:annex">
					<xsl:choose>
						<xsl:when test="$level = 1">
							<xsl:text>Annex </xsl:text>
							<xsl:choose>
								<xsl:when test="count(//ogc:annex) = 1">
									<xsl:value-of select="/ogc:ogc-standard/ogc:bibdata/ogc:ext/ogc:structuredidentifier/ogc:annexid"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:number format="A" level="any" count="ogc:annex"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="count(//ogc:annex) = 1">
									<xsl:value-of select="/ogc:ogc-standard/ogc:bibdata/ogc:ext/ogc:structuredidentifier/ogc:annexid"/><xsl:number format=".1" level="multiple" count="ogc:clause"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:number format="A.1" level="multiple" count="ogc:annex | ogc:clause"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="ancestor::ogc:preface"> <!-- if preface and there is clause(s) -->
					<xsl:choose>
						<xsl:when test="$level = 1 and  ..//ogc:clause">0</xsl:when>
						<xsl:when test="$level &gt;= 2">
							<xsl:variable name="num">
								<xsl:number format=".1" level="multiple" count="ogc:clause"/>
							</xsl:variable>
							<xsl:value-of select="concat('0', $num)"/>
						</xsl:when>
						<xsl:otherwise>
							<!-- z<xsl:value-of select="$sectionNum"/>z -->
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$section"/>
	</xsl:template>
	
</xsl:stylesheet>
