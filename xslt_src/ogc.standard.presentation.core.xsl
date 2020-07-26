<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
											xmlns:fo="http://www.w3.org/1999/XSL/Format" 
											xmlns:ogc="https://www.metanorma.org/ns/ogc" 
											xmlns:mathml="http://www.w3.org/1998/Math/MathML" 
											xmlns:xalan="http://xml.apache.org/xalan" 
											xmlns:fox="http://xmlgraphics.apache.org/fop/extensions" 
											xmlns:java="http://xml.apache.org/xalan/java" 
											exclude-result-prefixes="java"
											version="1.0">

	<xsl:output version="1.0" method="xml" encoding="UTF-8" indent="no"/>
	
	<xsl:param name="svg_images"/>
	<xsl:variable name="images" select="document($svg_images)"/>
	
	<xsl:variable name="pageWidth" select="'210mm'"/>
	<xsl:variable name="pageHeight" select="'297mm'"/>

	<xsl:variable name="namespace">ogc</xsl:variable>

	<xsl:variable name="debug">false</xsl:variable>
	
	<xsl:variable name="copyright">
		<xsl:text>© Open Geospatial Consortium </xsl:text>
		<xsl:value-of select="/ogc:ogc-standard/ogc:bibdata/ogc:copyright/ogc:from"/>
		<xsl:text> – All rights reserved</xsl:text>
	</xsl:variable>
	<xsl:variable name="copyright_short">
		<xsl:text>© </xsl:text>
		<xsl:value-of select="/ogc:ogc-standard/ogc:bibdata/ogc:copyright/ogc:from"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="/ogc:ogc-standard/ogc:bibdata/ogc:contributor[ogc:role/@type = 'publisher']/ogc:organization/ogc:name"/>
	</xsl:variable>
	
	<xsl:variable name="doctitle" select="/ogc:ogc-standard/ogc:bibdata/ogc:title[@language = 'en']"/>

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

	<xsl:variable name="color" select="'rgb(14, 26, 133)'"/>
	
	<xsl:variable name="contents">
		<contents>
		
			<!-- Abstract, Keywords, Preface, Submitting Organizations, Submitters -->
			
			<xsl:apply-templates select="/ogc:ogc-standard/ogc:preface/*" mode="contents"/>
			
			<xsl:apply-templates select="/ogc:ogc-standard/ogc:sections/ogc:clause[@id='_scope']" mode="contents" />
				
			<xsl:apply-templates select="/ogc:ogc-standard/ogc:sections/ogc:clause[@id='conformance' or @id='_conformance']" mode="contents" />
				
			<!-- Normative references  -->
			<xsl:apply-templates select="/ogc:ogc-standard/ogc:bibliography/ogc:references[@id = '_normative_references' or @id = '_references' or @id = 'references']" mode="contents" />
			
			<!-- Terms and definitions -->
			<xsl:apply-templates select="/ogc:ogc-standard/ogc:sections/ogc:terms" mode="contents" />
		
			<xsl:apply-templates select="/ogc:ogc-standard/ogc:sections/*[local-name() != 'terms' and not(@id='_scope') and not(@id='conformance') and not(@id='_conformance')]" mode="contents" />

			<xsl:apply-templates select="/ogc:ogc-standard/ogc:annex" mode="contents"/>
			
			<!-- Bibliography -->
			<xsl:apply-templates select="/ogc:ogc-standard/ogc:bibliography/ogc:references[@id != '_normative_references' and @id != '_references' and @id != 'references']" mode="contents"/> <!-- [position() &gt; 1] -->
			
			
		</contents>
	</xsl:variable>
	
	<xsl:variable name="lang">
		<xsl:call-template name="getLang"/>
	</xsl:variable>
	
	<xsl:template match="/">
		<xsl:call-template name="namespaceCheck"/>
		<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format" font-family="Times New Roman, STIX2Math, HanSans" font-size="10.5pt" xml:lang="{$lang}">
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
			
			<xsl:call-template name="addPDFUAmeta"/>
			
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
						<xsl:value-of select="$doctitle" />
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
										<fo:block>Document number: </fo:block>
									</fo:table-cell>
									<fo:table-cell>
										<fo:block>
											<xsl:value-of select="/ogc:ogc-standard/ogc:bibdata/ogc:docnumber"/>											
										</fo:block>
									</fo:table-cell>
								</fo:table-row>
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
										<fo:block>Document subtype: </fo:block>
									</fo:table-cell>
									<fo:table-cell>
										<fo:block>
											<xsl:call-template name="capitalizeWords">
												<xsl:with-param name="str" select="/ogc:ogc-standard/ogc:bibdata/ogc:ext/ogc:docsubtype"/>
											</xsl:call-template>
										</fo:block>
									</fo:table-cell>
								</fo:table-row>
								<fo:table-row height="9mm">
									<fo:table-cell>
										<fo:block>Document stage: </fo:block>
									</fo:table-cell>
									<fo:table-cell>
										<fo:block>
											<xsl:variable name="stage" select="/ogc:ogc-standard/ogc:bibdata/ogc:status/ogc:stage"/>
											<xsl:call-template name="capitalize">
												<xsl:with-param name="str" select="$stage"/>
											</xsl:call-template>											
										</fo:block>
									</fo:table-cell>
								</fo:table-row>
								<fo:table-row height="9mm">
									<fo:table-cell>
										<fo:block>Document language: </fo:block>
									</fo:table-cell>
									<fo:table-cell>
										<fo:block>
											<xsl:call-template name="getLanguage">
												<xsl:with-param name="lang" select="$lang"/>
											</xsl:call-template>											
										</fo:block>
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
				
					<xsl:if test="$debug = 'true'">
						<xsl:text disable-output-escaping="yes">&lt;!--</xsl:text>
							DEBUG
							contents=<!-- <xsl:copy-of select="xalan:nodeset($contents)"/> --> 
						<xsl:text disable-output-escaping="yes">--&gt;</xsl:text>
					</xsl:if>
					
					<xsl:apply-templates select="/ogc:ogc-standard/ogc:boilerplate/ogc:license-statement"/>
					<xsl:apply-templates select="/ogc:ogc-standard/ogc:boilerplate/ogc:feedback-statement"/>
					
					<fo:block break-after="page"/>
					<fo:block>&#xA0;</fo:block>
					<fo:block break-after="page"/>
					
					<fo:block-container font-weight="bold" line-height="115%" margin-bottom="36pt">
						<xsl:variable name="title-toc">
							<xsl:call-template name="getTitle">
								<xsl:with-param name="name" select="'title-toc'"/>
							</xsl:call-template>
						</xsl:variable>
						<fo:block font-size="14pt" margin-top="2pt"  margin-bottom="15.5pt"><xsl:value-of select="$title-toc"/></fo:block>
						
						<xsl:for-each select="xalan:nodeset($contents)//item">
							
							<fo:block>
								<xsl:if test="@level = 1">
									<xsl:attribute name="margin-top">6pt</xsl:attribute>
								</xsl:if>
								<fo:list-block>
									<xsl:attribute name="provisional-distance-between-starts">
										<xsl:choose>											
											<xsl:when test="@section != ''">8mm</xsl:when>
											<xsl:otherwise>0mm</xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
									<fo:list-item>
										<fo:list-item-label end-indent="label-end()">
											<fo:block>
												<xsl:value-of select="@section"/>
											</fo:block>
										</fo:list-item-label>
										<fo:list-item-body start-indent="body-start()">
											<fo:block text-align-last="justify" margin-left="12mm" text-indent="-12mm">
												<fo:basic-link internal-destination="{@id}" fox:alt-text="{text()}">
													
													<xsl:apply-templates />
													
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
						
						<xsl:if test="//ogc:table[@id and ogc:name]">
							<fo:block font-size="12pt">&#xA0;</fo:block>
							<fo:block font-size="12pt">&#xA0;</fo:block>
							<xsl:variable name="title-list-tables">
								<xsl:call-template name="getTitle">
									<xsl:with-param name="name" select="'title-list-tables'"/>
								</xsl:call-template>
							</xsl:variable>
							<fo:block font-size="14pt" font-weight="bold" space-before="48pt" margin-bottom="15.5pt"><xsl:value-of select="$title-list-tables"/></fo:block>
							<xsl:for-each select="//ogc:table[@id and ogc:name]">
								<fo:block text-align-last="justify" margin-top="6pt">
									<fo:basic-link internal-destination="{@id}" fox:alt-text="{@section}">
										<xsl:apply-templates select="ogc:name" mode="contents"/>										
										<fo:inline keep-together.within-line="always">
											<fo:leader leader-pattern="dots"/>
											<fo:page-number-citation ref-id="{@id}"/>
										</fo:inline>
									</fo:basic-link>
								</fo:block>
							</xsl:for-each>
						</xsl:if>
						
						<xsl:if test="//ogc:figure[@id and ogc:name]">
							<fo:block font-size="12pt">&#xA0;</fo:block>
							<fo:block font-size="12pt">&#xA0;</fo:block>
							<xsl:variable name="title-list-figures">
								<xsl:call-template name="getTitle">
									<xsl:with-param name="name" select="'title-list-figures'"/>
								</xsl:call-template>
							</xsl:variable>
							<fo:block font-size="14pt" font-weight="bold" space-before="48pt" margin-bottom="15.5pt"><xsl:value-of select="$title-list-figures"/></fo:block>
							<xsl:for-each select="//ogc:figure[@id and ogc:name]">
								<fo:block text-align-last="justify" margin-top="6pt">
									<fo:basic-link internal-destination="{@id}" fox:alt-text="{@section}">
										<xsl:apply-templates select="ogc:name" mode="contents"/>										
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
					<xsl:apply-templates select="/ogc:ogc-standard/ogc:preface/*" mode="preface"/>
						
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
						<xsl:value-of select="$doctitle"/>
					</fo:block>
					
					<fo:block line-height="125%">
					
						<xsl:apply-templates select="/ogc:ogc-standard/ogc:sections/ogc:clause[@id='_scope']" />
						
						<xsl:apply-templates select="/ogc:ogc-standard/ogc:sections/ogc:clause[@id='conformance' or @id='_conformance']" />
						
						<!-- Normative references  -->
						<xsl:apply-templates select="/ogc:ogc-standard/ogc:bibliography/ogc:references[@id = '_normative_references' or @id = '_references' or @id = 'references']" />

						<!-- Terms and definitions -->
						<xsl:apply-templates select="/ogc:ogc-standard/ogc:sections/ogc:terms" />
						
						<xsl:apply-templates select="/ogc:ogc-standard/ogc:sections/*[local-name() != 'terms' and not(@id='_scope') and not(@id='conformance') and not(@id='_conformance')]" />
						
						<xsl:apply-templates select="/ogc:ogc-standard/ogc:annex"/>
						
						<!-- Bibliography -->
						<xsl:apply-templates select="/ogc:ogc-standard/ogc:bibliography/ogc:references[@id != '_normative_references' and @id != '_references' and @id != 'references']" /> <!-- [position() &gt; 1] -->
						
					</fo:block>
				</fo:flow>
			</fo:page-sequence>
			
			<!-- End Document Pages -->
			
		</fo:root>
	</xsl:template> 

	<xsl:template match="node()">		
		<xsl:apply-templates />			
	</xsl:template>
	
	<!-- ============================= -->
	<!-- CONTENTS                                       -->
	<!-- ============================= -->
	<xsl:template match="node()" mode="contents">		
		<xsl:apply-templates mode="contents" />			
	</xsl:template>

	<!-- element with title -->
	<xsl:template match="*[ogc:title]" mode="contents">
		<xsl:variable name="level">
			<xsl:call-template name="getLevel">
				<xsl:with-param name="depth" select="ogc:title/@depth"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="display">
			<xsl:choose>
				<xsl:when test="ancestor-or-self::ogc:bibitem">false</xsl:when>
				<xsl:when test="ancestor-or-self::ogc:term">false</xsl:when>				
				<xsl:when test="$level &gt;= 3">false</xsl:when>
				<xsl:otherwise>true</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		
		<xsl:if test="$display = 'true'">		
		
			<xsl:variable name="section">
				<xsl:call-template name="getSection"/>
			</xsl:variable>
			
			<xsl:variable name="title">
				<xsl:call-template name="getName"/>
			</xsl:variable>
			
			<xsl:variable name="type">
				<xsl:value-of select="local-name()"/>
			</xsl:variable>
			
			<item id="{@id}" level="{$level}" section="{$section}" type="{$type}">
				<xsl:apply-templates select="xalan:nodeset($title)" mode="contents_item"/>
			</item>
			<xsl:apply-templates  mode="contents" />
		</xsl:if>	
		
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
			<xsl:variable name="title-edition">
				<xsl:call-template name="getTitle">
					<xsl:with-param name="name" select="'title-edition'"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:value-of select="$title-edition"/><xsl:text>: </xsl:text>
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
					<xsl:otherwise>center</xsl:otherwise>
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
	
	<xsl:template match="/*/*[local-name() = 'preface']/*" priority="3">		
		<fo:block>
			<xsl:call-template name="setId"/>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="ogc:ogc-standard/ogc:preface/*" mode="preface">
		<xsl:if test="local-name() = 'introduction' or 
											local-name() = 'abstract' or 
											local-name() = 'foreword'">
			<fo:block break-after="page"/>
		</xsl:if>
		<xsl:apply-templates select="current()"/>
	</xsl:template>
	

	

	
	<!-- ====== -->
	<!-- title      -->
	<!-- ====== -->
	
	<xsl:template match="ogc:annex/ogc:title">
		<fo:block font-size="12pt" text-align="center" margin-bottom="12pt" keep-with-next="always" color="{$color}">			
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="ogc:title">
		
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
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
		
		<xsl:element name="{$element-name}">
			<xsl:attribute name="font-size"><xsl:value-of select="$font-size"/></xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="space-before">13.5pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>		
			<xsl:attribute name="color"><xsl:value-of select="$color"/></xsl:attribute>			
			<xsl:apply-templates />
		</xsl:element>
			
	</xsl:template>
	<!-- ====== -->
	<!-- ====== -->
	
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
			<xsl:if test="ancestor::ogc:dd and not(ancestor::ogc:table)">
				<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			</xsl:if>
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
	<xsl:template match="ogc:title/ogc:fn | 
																ogc:p/ogc:fn[not(ancestor::ogc:table)] | 
																ogc:p/*/ogc:fn[not(ancestor::ogc:table)] |
																ogc:sourcecode/ogc:fn[not(ancestor::ogc:table)]" priority="2">
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
	
	
	<xsl:template match="ogc:bibitem/ogc:note" priority="2">
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
				<fo:basic-link internal-destination="{generate-id()}" fox:alt-text="footnote {$number}">
					<xsl:value-of select="$number"/><!-- <xsl:text>)</xsl:text> -->
				</fo:basic-link>
			</fo:inline>
			<fo:footnote-body>
				<fo:block font-size="10pt" margin-bottom="12pt" start-indent="0pt">
					<fo:inline id="{generate-id()}" keep-with-next.within-line="always" font-size="60%" vertical-align="super"><!-- baseline-shift="30%" padding-right="9mm"  alignment-baseline="hanging" -->
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
		<fo:list-item id="{@id}">
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
				<fo:block>
					<xsl:apply-templates />
				</fo:block>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>
	
	<xsl:template match="ogc:ul/ogc:note | ogc:ol/ogc:note" priority="2">
		<fo:list-item font-size="10pt">
			<fo:list-item-label><fo:block></fo:block></fo:list-item-label>
			<fo:list-item-body>
				<fo:block>
					<xsl:apply-templates select="ogc:name" mode="presentation"/>
					<xsl:apply-templates />
				</fo:block>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>
	

	
	<xsl:template match="ogc:preferred">		
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
				<xsl:apply-templates select="ancestor::ogc:term/ogc:name" mode="presentation"/>
			</fo:block>
			<fo:block font-weight="bold" keep-with-next="always" line-height="1">
				<xsl:apply-templates />
			</fo:block>
		</fo:block>
	</xsl:template>
	

	

	
	<!-- [position() &gt; 1] -->
	<xsl:template match="ogc:references[@id != '_normative_references' and @id != '_references'  and @id != 'references']">
		<fo:block break-after="page"/>
		<fo:block id="{@id}" line-height="120%">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>

	<xsl:template match="ogc:annex//ogc:references">
		<fo:block id="{@id}">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>

	<!-- Example: [1] ISO 9:1995, Information and documentation – Transliteration of Cyrillic characters into Latin characters – Slavic and non-Slavic languages -->
	<!-- <xsl:template match="ogc:references[@id = '_bibliography']/ogc:bibitem"> [position() &gt; 1] -->
	<xsl:template match="ogc:references[@id != '_normative_references' and @id != '_references' and @id != 'references']/ogc:bibitem">
		<fo:list-block id="{@id}" margin-bottom="12pt" provisional-distance-between-starts="12mm">
			<fo:list-item>
				<fo:list-item-label end-indent="label-end()">
					<fo:block>
						<fo:inline>
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
	<xsl:template match="ogc:references[@id != '_normative_references' and @id != '_references' and @id != 'references']/ogc:bibitem" mode="contents"/>
	
	<!-- <xsl:template match="ogc:references[@id = '_bibliography']/ogc:bibitem/ogc:title"> [position() &gt; 1]-->
	<xsl:template match="ogc:references[@id != '_normative_references' and  @id != '_references' and @id != 'references']/ogc:bibitem/ogc:title">
		<fo:inline font-style="italic">
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>




	
	<xsl:template match="ogc:admonition">
		<fo:block-container border="0.5pt solid rgb(79, 129, 189)" color="rgb(79, 129, 189)" margin-left="16mm" margin-right="16mm" margin-bottom="12pt">
			<fo:block-container margin-left="0mm" margin-right="0mm" padding="2mm" padding-top="3mm">
				<fo:block font-size="11pt" margin-bottom="6pt" font-weight="bold" font-style="italic" text-align="center">					
					<xsl:value-of select="java:toUpperCase(java:java.lang.String.new(@type))"/>
				</fo:block>
				<fo:block font-style="italic">
					<xsl:apply-templates />
				</fo:block>
			</fo:block-container>
		</fo:block-container>
		
		
	</xsl:template>


	<xsl:template match="ogc:formula/ogc:stem">
		<fo:block margin-top="6pt" margin-bottom="12pt">
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
								<xsl:apply-templates select="../ogc:name" mode="presentation"/>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</fo:table-body>
			</fo:table>			
		</fo:block>
	</xsl:template>
	
	
	
	<xsl:template match="ogc:pagebreak">
		<fo:block break-after="page"/>
		<fo:block>&#xA0;</fo:block>
		<fo:block break-after="page"/>
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
	
</xsl:stylesheet>
