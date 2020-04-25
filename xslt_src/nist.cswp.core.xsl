<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:nist="https://www.metanorma.org/ns/nist" xmlns:mathml="http://www.w3.org/1998/Math/MathML" xmlns:xalan="http://xml.apache.org/xalan" xmlns:fox="http://xmlgraphics.apache.org/fop/extensions" version="1.0">

	<xsl:output version="1.0" method="xml" encoding="UTF-8" indent="no"/>

	<xsl:include href="./common.xsl"/>

	<xsl:variable name="namespace">nist</xsl:variable>
	
	<xsl:variable name="pageWidth" select="'8.5in'"/>
	<xsl:variable name="pageHeight" select="'11in'"/>

	<xsl:variable name="title" select="/nist:nist-standard/nist:bibdata/nist:title[@language = 'en' and @type = 'main']"/>

	<xsl:variable name="date">
		<xsl:choose>
			<xsl:when test="/nist:nist-standard/nist:bibdata/nist:date[@type='issued']">
				<xsl:call-template name="formatDate">
					<xsl:with-param name="date" select="/nist:nist-standard/nist:bibdata/nist:date[@type='issued']/nist:on"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="formatDate">
					<xsl:with-param name="date" select="/nist:nist-standard/nist:bibdata/nist:date/nist:on"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="color">rgb(36, 64, 97)</xsl:variable>
	<xsl:variable name="seriestitle" select="/nist:nist-standard/nist:bibdata/nist:series[@type = 'main']/nist:title"/>
	<!-- Example:
		<item level="1" id="Foreword" display="true">Foreword</item>
		<item id="term-script" display="false">3.2</item>
	-->
	<xsl:variable name="contents">
		<contents>
			<xsl:apply-templates select="/nist:nist-standard/nist:preface/nist:executivesummary" mode="contents"/>
			<xsl:apply-templates select="/nist:nist-standard/nist:sections/*" mode="contents"/> <!-- /* Main sections -->
			<xsl:apply-templates select="/nist:nist-standard/nist:annex" mode="contents"/>
			<xsl:apply-templates select="/nist:nist-standard/nist:bibliography/nist:references" mode="contents"/>
		</contents>
	</xsl:variable>

	<xsl:variable name="lang">
		<xsl:call-template name="getLang"/>
	</xsl:variable>

	<xsl:template match="/">
		<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format" font-family="Times New Roman, STIX2Math" font-size="12pt" xml:lang="{$lang}">
			<fo:layout-master-set>
				<!-- Cover pages -->
				<fo:simple-page-master master-name="cover-page" page-width="{$pageWidth}" page-height="{$pageHeight}">
					<fo:region-body margin-top="1.75in" margin-bottom="1in" margin-left="1in" margin-right="1in"/>
					<fo:region-before region-name="header-cover" extent="1.75in"/>
					<fo:region-after extent="1in"/>
					<fo:region-start extent="1in"/>
					<fo:region-end extent="1in"/>
				</fo:simple-page-master>
				
				<!-- Preface page(s) -->
				<fo:simple-page-master master-name="preface" page-width="{$pageWidth}" page-height="{$pageHeight}">
					<fo:region-body margin-top="1.15in" margin-bottom="1in" margin-left="1in" margin-right="1in"/>
					<fo:region-before region-name="header-preface" extent="1.15in"/>
					<fo:region-after region-name="footer" extent="1in"/>
					<fo:region-start region-name="left" extent="1in"/>
					<fo:region-end region-name="right" extent="1in"/>
				</fo:simple-page-master>
				
				<!-- Document pages -->
				<fo:simple-page-master master-name="document" page-width="{$pageWidth}" page-height="{$pageHeight}">
					<fo:region-body margin-top="1in" margin-bottom="1in" margin-left="1in" margin-right="1in"/>
					<fo:region-before region-name="header" extent="1in"/>
					<fo:region-after region-name="footer" extent="1in"/>
					<fo:region-start region-name="left" extent="1in"/>
					<fo:region-end region-name="right" extent="1in"/>
				</fo:simple-page-master>
				
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
							<dc:title><xsl:value-of select="$title"/></dc:title>
							<dc:creator>
								<xsl:for-each select="/nist:nist-standard/nist:bibdata/nist:contributor[nist:role/@type = 'author']">
									<xsl:value-of select="nist:person/nist:name/nist:completename"/>
									<xsl:if test="position() != last()">; </xsl:if>
								</xsl:for-each>
							</dc:creator>
							<dc:description>
								<xsl:variable name="abstract">
									<xsl:copy-of select="/nist:nist-standard/nist:preface/nist:abstract//text()"/>
								</xsl:variable>
								<xsl:value-of select="normalize-space($abstract)"/>
							</dc:description>
							<pdf:Keywords>
								<xsl:for-each select="/nist:nist-standard/nist:bibdata//nist:keyword">
									<xsl:sort data-type="text" order="ascending"/>
									<xsl:apply-templates/>
									<xsl:if test="position() != last()">, </xsl:if>
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

			<!-- cover page -->
			<fo:page-sequence master-reference="cover-page" force-page-count="no-force">
				<!-- header -->
				<fo:static-content flow-name="header-cover" font-family="Times New Roman" font-size="11pt" font-weight="bold" font-style="italic">
					<fo:block-container color="white" background-color="{$color}" margin-left="-1mm" margin-right="-1mm" margin-top="1in" display-align="after" height="5mm">
						<fo:block text-align-last="justify" margin-left="1mm" margin-right="1mm" padding-left="0.5mm" padding-top="0.5mm">
							<fo:inline padding-left="0.5mm"> <!-- font-size="7.5pt" -->
								<!-- <xsl:call-template name="recursiveSmallCaps">
									<xsl:with-param name="text" select="$seriestitle"/>
								</xsl:call-template> -->
								<xsl:value-of select="$seriestitle"/>
							</fo:inline>
							<fo:inline keep-together.within-line="always">
								<fo:leader leader-pattern="space"/>
								<xsl:text>csrc.nist.gov&#xA0;&#xA0;</xsl:text>
								<!-- <xsl:call-template name="recursiveSmallCaps">
									<xsl:with-param name="text" select="'csrc.nist.gov&#xA0;&#xA0;'"/>
								</xsl:call-template> -->
							</fo:inline>
						</fo:block>
					</fo:block-container>
				</fo:static-content>

				<fo:flow flow-name="xsl-region-body" color="rgb(36, 64, 97)">
					<!-- logo -->
					<fo:block-container absolute-position="fixed" left="25.4mm" top="229mm">
						<fo:block>
							<fo:external-graphic src="{concat('data:image/png;base64,', normalize-space($Image-NIST-Logo))}" width="57mm" content-height="25.4mm" content-width="scale-to-fit" scaling="uniform" fox:alt-text="Image"/>
						</fo:block>
					</fo:block-container>

					<xsl:if test="contains(/nist:nist-standard/nist:bibdata/nist:status/nist:stage, 'draft')">
							<!-- <fo:block-container absolute-position="fixed" left="20mm" top="170mm" fox:transform="rotate(-45)">
								<fo:block font-family="Calibri" font-size="180pt" color="rgb(223, 223, 223)">DRAFT</fo:block>
							</fo:block-container> -->
							<fo:block-container absolute-position="fixed" left="0mm" top="0mm">
								<fo:block line-height="0">
									<fo:instream-foreign-object fox:alt-text="DRAFT">
											<svg:svg width="200mm" height="250mm" xmlns:svg="http://www.w3.org/2000/svg">
													<svg:g transform="rotate(-45) scale(0.6, 1)">
															<svg:text x="-175mm" y="205mm"  style="font-family:Calibri;font-size:260pt;font-weight:normal;fill:rgb(223, 223, 223);">
																	DRAFT
															</svg:text>
													</svg:g>
											</svg:svg>
									</fo:instream-foreign-object>
								</fo:block>
							</fo:block-container>
					</xsl:if>


					<fo:block>
						<fo:block font-family="Arial" font-size="24pt" font-weight="bold" margin-top="12pt" margin-bottom="18pt" letter-spacing="-0.5pt" margin-right="-2mm">
							<xsl:value-of select="$title"/>
						</fo:block>
						<fo:block margin-bottom="12pt">&#xA0;</fo:block>
						<fo:block margin-bottom="20pt">&#xA0;</fo:block>
						
						<!-- Authors list -->
						<fo:block line-height="116%">
							<xsl:for-each select="/nist:nist-standard/nist:bibdata/nist:contributor[nist:role/@type = 'author']">
								<xsl:value-of select="nist:person/nist:name/nist:completename"/>
								<xsl:variable name="org-name" select="nist:person/nist:affiliation/nist:organization/nist:name"/>
								<xsl:variable name="org-address" select="nist:person/nist:affiliation/nist:organization/nist:address/nist:formattedAddress"/>
								<xsl:if test="concat(following-sibling::nist:contributor[nist:role/@type = 'author'][1]/nist:person/nist:affiliation/nist:organization/nist:name,
																							 following-sibling::nist:contributor[nist:role/@type = 'author'][1]/nist:person/nist:affiliation/nist:organization/nist:address/nist:formattedAddress) !=
																	concat($org-name, $org-address)">
																	
									<xsl:for-each select="xalan:tokenize($org-name, ',')">
										<fo:block>
											<fo:inline font-style="italic">
												<xsl:value-of select="."/>
												<!-- <xsl:if test="normalize-space($org-address) != ''">
													<fo:inline>, <xsl:value-of select="$org-address"/></fo:inline>
												</xsl:if> -->
											</fo:inline>
										</fo:block>
									</xsl:for-each>
									
									<xsl:if test="normalize-space($org-address) != ''">
										<fo:block>
											<fo:inline font-style="italic">
												<xsl:value-of select="$org-address"/>
											</fo:inline>
										</fo:block>
									</xsl:if>
								</xsl:if>
								<xsl:value-of select="$linebreak"/>
							</xsl:for-each>
						</fo:block>
						<fo:block margin-bottom="22pt">&#xA0;</fo:block>
						<fo:block margin-bottom="12pt"> <!-- font-size="14pt"  -->
							<xsl:value-of select="$date"/>
						</fo:block>
						<fo:block margin-bottom="12pt">&#xA0;</fo:block>

						<!-- <xsl:if test="/nist:nist-standard/nist:bibdata/nist:uri[@type = 'doi']">
							<fo:block>
								<xsl:text>This publication is available free of charge from:</xsl:text>
								<xsl:value-of select="$linebreak"/>
								<xsl:value-of select="/nist:nist-standard/nist:bibdata/nist:uri[@type = 'doi']"/>
							</fo:block>
						</xsl:if> -->

					</fo:block>
				</fo:flow>
			</fo:page-sequence>


			<fo:page-sequence master-reference="preface" initial-page-number="2" format="i" force-page-count="no-force" line-height="116%">

				<fo:static-content flow-name="xsl-footnote-separator">
					<fo:block margin-bottom="4mm">
						<fo:leader leader-pattern="rule" leader-length="30%"/>
					</fo:block>
				</fo:static-content>
				<xsl:call-template name="insertFooter"/>

				<fo:flow flow-name="xsl-region-body">
					<fo:block margin-top="18pt">
					
						<!-- Abstract -->
						<xsl:if test="/nist:nist-standard/nist:preface/nist:abstract">
							<fo:block font-family="Arial" text-align="center" font-weight="bold" color="{$color}" margin-bottom="12pt">Abstract</fo:block>
							<xsl:apply-templates select="/nist:nist-standard/nist:preface/nist:abstract"/>
						</xsl:if>

						<!-- Keywords -->
						<xsl:if test="/nist:nist-standard/nist:bibdata/nist:keyword">
							<fo:block font-family="Arial" text-align="center" font-weight="bold" color="{$color}" margin-bottom="12pt">
								<xsl:text>Keywords</xsl:text>
							</fo:block>
							<fo:block margin-bottom="12pt" text-align="justify">
								<xsl:for-each select="/nist:nist-standard/nist:bibdata//nist:keyword">
									<xsl:sort data-type="text" order="ascending"/>
									<xsl:apply-templates/>
									<xsl:choose>
										<xsl:when test="position() != last()">; </xsl:when>
										<xsl:otherwise></xsl:otherwise>
									</xsl:choose>
								</xsl:for-each>
							</fo:block>
						</xsl:if>

						<xsl:if test="/nist:nist-standard/nist:preface/nist:acknowledgements">
							<fo:block font-family="Arial" text-align="center" font-weight="bold" color="{$color}" margin-top="18pt" margin-bottom="12pt">Acknowledgements</fo:block>
							<xsl:apply-templates select="/nist:nist-standard/nist:preface/nist:acknowledgements"/>
						</xsl:if>
						
						
						<!-- Disclaimer -->
						<!-- Additional Information -->
						<!-- Comments on this publication may be submitted to -->
						<xsl:if test="/nist:nist-standard/nist:boilerplate/nist:legal-statement">
							<xsl:apply-templates select="/nist:nist-standard/nist:boilerplate/nist:legal-statement"/>
						</xsl:if>

						<fo:block font-family="Arial" text-align="center" font-weight="bold" color="{$color}" margin-bottom="12pt">Feedback</fo:block>
						<xsl:text>Feedback on this publication is welcome, and can be sent to: code-signing@nist.gov.</xsl:text>
						
						<xsl:apply-templates select="/nist:nist-standard/nist:preface/nist:clause"/>

						<fo:block break-after="page"/>

						<!-- <xsl:apply-templates select="/nist:nist-standard/nist:preface/nist:foreword"/> -->

						<!-- Executive summary -->
						<!-- <xsl:apply-templates select="/nist:nist-standard/nist:preface/nist:executivesummary"/> -->

						<xsl:text disable-output-escaping="yes">&lt;!--</xsl:text>
							DEBUG
							contents=<xsl:copy-of select="xalan:nodeset($contents)"/>
						<xsl:text disable-output-escaping="yes">--&gt;</xsl:text>

						<!-- CONTENTS -->
						<!-- <fo:block break-after="page"/>
						<fo:block-container font-family="Arial">
							<fo:block font-family="Arial Black" font-size="12pt" margin-top="4pt" margin-bottom="12pt" text-align="center">Table of Contents</fo:block>
								<xsl:for-each select="xalan:nodeset($contents)//item[not(@type = 'table') and not(@type = 'figure')]">
									<xsl:if test="@display = 'true'">
										<fo:block color="{$color}">
											<xsl:attribute name="margin-top">6pt</xsl:attribute>
											<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
											<xsl:if test="@level = 1">
												<xsl:attribute name="font-weight">bold</xsl:attribute>
											</xsl:if>
											<fo:block text-align-last="justify" margin-left="12mm" text-indent="-12mm">
												<xsl:if test="@level &gt;= 2 and @section != ''">
													<xsl:attribute name="margin-left">21.5mm</xsl:attribute>
												</xsl:if>
												<xsl:if test="@type = 'annex'">
													<xsl:attribute name="font-weight">bold</xsl:attribute>
												</xsl:if>
												<fo:basic-link internal-destination="{@id}" fox:alt-text="{@section}">
													<xsl:if test="@section != '' and not(@display-section = 'false')">
														<fo:inline>
															<xsl:if test="not(@type = 'annex')">
																<xsl:attribute name="padding-right">
																	<xsl:choose>
																		<xsl:when test="@level = 1">6mm</xsl:when>
																		<xsl:otherwise>5mm</xsl:otherwise>
																	</xsl:choose>
																</xsl:attribute>
															</xsl:if>
															<xsl:value-of select="@section"/>
															<xsl:choose>
																<xsl:when test="@type = 'annex'">
																	<xsl:text> — </xsl:text>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:text>. </xsl:text>
																</xsl:otherwise>
															</xsl:choose>
														</fo:inline>
													</xsl:if>
													<xsl:value-of select="text()"/><xsl:text> </xsl:text>
													<fo:inline keep-together.within-line="always">
														<fo:leader leader-pattern="dots"/>
														<fo:page-number-citation ref-id="{@id}"/>
													</fo:inline>
												</fo:basic-link>
											</fo:block>
										</fo:block>
									</xsl:if>
								</xsl:for-each>

								<xsl:if test="xalan:nodeset($contents)//item[@type = 'figure']">
									<fo:block font-size="12pt">&#xA0;</fo:block>
									<fo:block font-size="12pt">&#xA0;</fo:block>
									<fo:block font-size="12pt" font-weight="bold" text-align="center" margin-bottom="12pt">List of Figures</fo:block>
									<xsl:for-each select="xalan:nodeset($contents)//item[@type = 'figure']">
										<fo:block text-align-last="justify" margin-top="6pt" margin-bottom="6pt">
											<fo:basic-link internal-destination="{@id}" fox:alt-text="{@section}">
												<xsl:value-of select="@section"/>
												<xsl:if test="text() != ''">
													<xsl:text> — </xsl:text>
													<xsl:value-of select="text()"/>
												</xsl:if>
												<fo:inline keep-together.within-line="always">
													<fo:leader leader-pattern="dots"/>
													<fo:page-number-citation ref-id="{@id}"/>
												</fo:inline>
											</fo:basic-link>
										</fo:block>
									</xsl:for-each>
								</xsl:if>

								<xsl:if test="xalan:nodeset($contents)//item[@type = 'table']">
									<fo:block font-size="12pt">&#xA0;</fo:block>
									<fo:block font-size="12pt">&#xA0;</fo:block>
									<fo:block font-size="12pt" font-weight="bold" text-align="center" margin-bottom="12pt">List of Tables</fo:block>
									<xsl:for-each select="xalan:nodeset($contents)//item[@type = 'table']">
										<fo:block text-align-last="justify" margin-top="6pt" margin-bottom="6pt">
											<fo:basic-link internal-destination="{@id}" fox:alt-text="{@section}">
												<xsl:value-of select="@section"/>
												<xsl:if test="text() != ''">
													<xsl:text> — </xsl:text>
													<xsl:value-of select="text()"/>
												</xsl:if>
												<fo:inline keep-together.within-line="always">
													<fo:leader leader-pattern="dots"/>
													<fo:page-number-citation ref-id="{@id}"/>
												</fo:inline>
											</fo:basic-link>
										</fo:block>
									</xsl:for-each>
								</xsl:if>
						</fo:block-container> -->
					</fo:block>
				</fo:flow>
			</fo:page-sequence>

			<!-- BODY -->
			<fo:page-sequence master-reference="document" initial-page-number="1" force-page-count="no-force" line-height="116%">
				<fo:static-content flow-name="xsl-footnote-separator">
					<fo:block margin-bottom="4mm">
						<fo:leader leader-pattern="rule" leader-length="30%"/>
					</fo:block>
				</fo:static-content>

				<xsl:call-template name="insertHeaderFooter"/>

				<fo:flow flow-name="xsl-region-body">
					<!-- Clause(s) -->
					<fo:block>
						<xsl:apply-templates select="/nist:nist-standard/nist:sections/*"/>

						<xsl:apply-templates select="/nist:nist-standard/nist:annex"/>

						<!-- Bibliography -->
						<xsl:apply-templates select="/nist:nist-standard/nist:bibliography/nist:references"/>

					</fo:block>

				</fo:flow>
			</fo:page-sequence>


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
	<xsl:template match="nist:nist-standard/nist:sections/*" mode="contents">
		<xsl:param name="sectionNum"/>
		<xsl:param name="sectionNumSkew" select="0"/>
		<xsl:variable name="sectionNum_">
			<xsl:choose>
				<xsl:when test="$sectionNum"><xsl:value-of select="$sectionNum"/></xsl:when>
				<xsl:when test="$sectionNumSkew != 0">
					<xsl:variable name="number"><xsl:number count="*"/></xsl:variable>
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
	<xsl:template match="nist:title | nist:preferred" mode="contents">
		<xsl:param name="sectionNum"/>

		<xsl:variable name="id">
			<xsl:choose>
				<xsl:when test="../@id">
					<xsl:value-of select="../@id"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="text()"/>
				</xsl:otherwise>
			</xsl:choose>
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
				<!-- <xsl:when test="ancestor::itu:annex">true</xsl:when> -->
				<xsl:when test="ancestor::nist:annex and $level &gt;= 2">false</xsl:when>
				<xsl:when test="$level &lt;= 2">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="type">
			<xsl:value-of select="local-name(..)"/>
		</xsl:variable>

		<item id="{$id}" level="{$level}" section="{$section}" display="{$display}" type="{$type}">
			<xsl:value-of select="."/>
		</item>

		<xsl:apply-templates mode="contents">
			<xsl:with-param name="sectionNum" select="$sectionNum"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="nist:bibitem" mode="contents"/>

	<xsl:template match="nist:figure" mode="contents">
		<xsl:param name="sectionNum" />
		<item level="" id="{@id}" type="figure">
			<xsl:attribute name="section">
				<xsl:text>Figure </xsl:text>
				<xsl:choose>
					<xsl:when test="ancestor::nist:annex">
						<xsl:choose>
							<xsl:when test="count(//nist:annex) = 1">
								<xsl:value-of select="/nist:nist-standard/nist:bibdata/nist:ext/nist:structuredidentifier/nist:annexid"/><xsl:number format="-1" level="any" count="nist:annex//nist:figure"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:number format="A.1-1" level="multiple" count="nist:annex | nist:figure"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="ancestor::nist:figure">
						<xsl:for-each select="parent::*[1]">
							<xsl:number format="1" level="any" count="nist:figure[not(parent::nist:figure)]"/>
						</xsl:for-each>
						<xsl:number format="-a"  count="nist:figure"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:number format="1" level="any" count="nist:figure[not(parent::nist:figure)]"/>
						<!-- <xsl:number format="1.1-1" level="multiple" count="nist:annex | nist:figure"/> -->
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:value-of select="nist:name"/>
		</item>
	</xsl:template>

	<xsl:template match="nist:table" mode="contents">
		<xsl:param name="sectionNum" />
		<xsl:variable name="annex-id" select="ancestor::nist:annex/@id"/>
		<item level="" id="{@id}" display="false" type="table">
			<xsl:attribute name="section">
				<xsl:text>Table </xsl:text>
				<xsl:choose>
					<xsl:when test="ancestor::*[local-name()='executivesummary']"> <!-- NIST -->
							<xsl:text>ES-</xsl:text><xsl:number format="1" count="*[local-name()='executivesummary']//*[local-name()='table']"/>
						</xsl:when>
					<xsl:when test="ancestor::*[local-name()='annex']">
						<xsl:number format="A-" count="nist:annex"/>
						<xsl:number format="1" level="any" count="nist:table[ancestor::nist:annex[@id = $annex-id]]"/>
					</xsl:when>
					<xsl:otherwise>
						<!-- <xsl:number format="1"/> -->
						<xsl:number format="1" level="any" count="*[local-name()='sections']//*[local-name()='table']"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:value-of select="nist:name/text()"/>
		</item>
	</xsl:template>

	<xsl:template match="nist:formula" mode="contents">
		<xsl:param name="sectionNum" />
		<item level="" id="{@id}" display="false">
			<xsl:attribute name="section">
				<xsl:text>Formula (</xsl:text><xsl:number format="A.1" level="multiple" count="nist:annex | nist:formula"/><xsl:text>)</xsl:text>
			</xsl:attribute>
		</item>
	</xsl:template>

	<xsl:template match="nist:example" mode="contents">
		<xsl:param name="sectionNum" />
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		<xsl:variable name="section">
			<xsl:call-template name="getSection">
				<xsl:with-param name="sectionNum" select="$sectionNum"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="parent-element" select="local-name(..)"/>
		<item level="" id="{@id}" display="false" type="Example" section="{$section}">
			<xsl:attribute name="parent">
				<xsl:choose>
					<xsl:when test="$parent-element = 'clause'">Clause</xsl:when>
					<xsl:otherwise></xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
		</item>
		<xsl:apply-templates mode="contents">
			<xsl:with-param name="sectionNum" select="$sectionNum"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="nist:terms" mode="contents">
		<item level="" id="{@id}" display="false" type="Terms">
			<xsl:if test="ancestor::nist:annex">
				<xsl:attribute name="section">
					<xsl:text>Appendix </xsl:text><xsl:number format="A" count="nist:annex"/>
				</xsl:attribute>
			</xsl:if>
		</item>
	</xsl:template>

	<xsl:template match="nist:references" mode="contents">
		<item level="" id="{@id}" display="false" type="References">
			<xsl:choose>
				<xsl:when test="ancestor::nist:annex">
					<xsl:attribute name="section">
						<xsl:text>Appendix </xsl:text><xsl:number format="A" count="nist:annex"/>
					</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="level">1</xsl:attribute>
					<xsl:attribute name="display">true</xsl:attribute>
					<xsl:text>References</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</item>
	</xsl:template>

	<!-- ============================= -->
	<!-- ============================= -->



	<!-- ============================= -->
	<!-- Authority -->
	<!-- ============================= -->
	<xsl:template match="/nist:nist-standard/nist:boilerplate/nist:feedback-statement/nist:clause">
		<fo:block font-family="Arial" font-size="12pt" space-before="6pt">
		<xsl:apply-templates>
			<xsl:with-param name="margin">12pt</xsl:with-param>
		</xsl:apply-templates>
		</fo:block>
	</xsl:template>
	<!-- ============================= -->
	<!-- ============================= -->



	<!-- ============================= -->
	<!-- PARAGRAPHS                                    -->
	<!-- ============================= -->
	<xsl:template match="nist:p">
		<xsl:param name="margin"/>
		<fo:block>
			<xsl:attribute name="margin-bottom">
				<xsl:choose>
					<xsl:when test="(local-name(..) = 'td' or local-name(..) = 'th') and ancestor::nist:annex">0</xsl:when>
					<xsl:when test="$margin != ''"><xsl:value-of select="$margin"/></xsl:when>
					<xsl:otherwise>12pt</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="text-align">
				<xsl:choose>
					<xsl:when test="@align"><xsl:value-of select="@align"/></xsl:when>
					<xsl:when test="ancestor::nist:preface or ancestor::nist:boilerplate">justify</xsl:when>
					<xsl:otherwise>left</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>

	<xsl:template match="nist:note/nist:p" name="note">
		<fo:block font-size="11pt" space-before="4pt" >
			<xsl:text>NOTE </xsl:text>
			<xsl:if test="../following-sibling::nist:note or ../preceding-sibling::nist:note">
					<xsl:number count="nist:note"/><xsl:text> </xsl:text>
				</xsl:if>
			<xsl:text>– </xsl:text>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>

	<xsl:template match="nist:recommendation">
		<fo:block margin-left="20mm">
			<fo:block font-weight="bold">
				<xsl:text>Recommendation </xsl:text>
				<xsl:choose>
					<xsl:when test="ancestor::nist:sections">
						<xsl:number level="any" count="nist:sections//nist:recommendation"/>
					</xsl:when>
					<xsl:when test="ancestor::*[local-name()='annex']">
						<xsl:variable name="annex-id" select="ancestor::*[local-name()='annex']/@id"/>
						<xsl:number format="A-" count="nist:annex"/>
						<xsl:number format="1" level="any" count="nist:recommendation[ancestor::nist:annex[@id = $annex-id]]"/>
						<!-- <xsl:number format="A-1" level="multiple" count="nist:annex | nist:recommendation"/> -->
					</xsl:when>
				</xsl:choose>
				<xsl:text>:</xsl:text>
			</fo:block>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>

	<xsl:template match="nist:admonition">
		<fo:block-container border="1pt solid black" margin-left="-2mm" margin-right="-2mm" padding-top="6mm" padding-bottom="7mm" background-color="rgb(222,222,222)">
			<fo:block margin-left="8mm" margin-right="8mm">
				<fo:block font-size="11pt" font-weight="bold" text-align="center" margin-bottom="6pt" keep-with-next="always">
					<xsl:choose>
						<xsl:when test="@type='important'">IMPORTANT</xsl:when>
						<xsl:when test="@type='tip'">
							<xsl:apply-templates select="nist:name" mode="process"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="nist:name" mode="process"/>
						</xsl:otherwise>
					</xsl:choose>
				</fo:block>
				<xsl:apply-templates />
			</fo:block>
		</fo:block-container>
		<fo:block margin-bottom="6pt">&#xA0;</fo:block>
	</xsl:template>

	<xsl:template match="nist:admonition/nist:name"/>
	<xsl:template match="nist:admonition/nist:name" mode="process">
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="nist:admonition/nist:p">
		<fo:block><xsl:apply-templates /></fo:block>
	</xsl:template>

	<!-- ============================= -->
	<!-- ============================= -->


	<!-- ============================= -->
	<!-- Bibliography -->
	<!-- ============================= -->


	<xsl:template match="nist:references">
		<fo:block break-after="page"/>
		<fo:block>
			<xsl:if test="not(nist:title)">
				<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
			</xsl:if>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>


	<!-- Example: [ITU-T A.23]	ITU-T A.23, Recommendation ITU-T A.23, Annex A (2014), Guide for ITU-T and ISO/IEC JTC 1 cooperation. -->
	<xsl:template match="nist:bibitem">

		<fo:list-block margin-bottom="12pt" provisional-distance-between-starts="12mm">
			<fo:list-item>
				<fo:list-item-label end-indent="label-end()">
					<fo:block>
						<fo:inline id="{@id}">
							<!-- <xsl:number format="[1]"/> -->
							<xsl:value-of select="nist:docidentifier"/>
						</fo:inline>
					</fo:block>
				</fo:list-item-label>
				<fo:list-item-body start-indent="body-start()">
					<fo:block>
						<xsl:choose>
							<xsl:when test="nist:title[@type = 'main' and @language = 'en']">
								<xsl:apply-templates select="nist:title[@type = 'main' and @language = 'en']"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates select="nist:title"/>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:apply-templates select="nist:formattedref"/>
					</fo:block>
				</fo:list-item-body>
			</fo:list-item>
		</fo:list-block>
	</xsl:template>

	<!-- ============================= -->
	<!-- ============================= -->


	<xsl:template match="text()">
		<xsl:value-of select="."/>
	</xsl:template>


	<!-- calculate main section number (1,2,3) and pass it deep into templates -->
	<!-- it's necessary, because there is itu:bibliography/itu:references from other section, but numbering should be sequental -->
	<xsl:template match="nist:nist-standard/nist:sections/*">
		<xsl:param name="sectionNum"/>
		<xsl:param name="sectionNumSkew" select="0"/>
		<fo:block>
			<xsl:variable name="sectionNum_">
				<xsl:choose>
					<xsl:when test="$sectionNum"><xsl:value-of select="$sectionNum"/></xsl:when>
					<xsl:when test="$sectionNumSkew != 0">
						<xsl:variable name="number"><xsl:number count="*"/></xsl:variable>
						<xsl:value-of select="$number + $sectionNumSkew"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:number count="*"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:apply-templates>
				<xsl:with-param name="sectionNum" select="$sectionNum_"/>
			</xsl:apply-templates>
		</fo:block>
		<xsl:if test="position() != last()">
			<fo:block break-after="page"/>
		</xsl:if>
	</xsl:template>


	<xsl:template match="nist:title">
		<xsl:param name="sectionNum"/>
		<xsl:variable name="id">
			<xsl:choose>
				<xsl:when test="../@id">
					<xsl:value-of select="../@id"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="text()"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="parent-name"  select="local-name(..)"/>
		<xsl:variable name="references_num_current">
			<xsl:number level="any" count="nist:references"/>
		</xsl:variable>

		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>

		<xsl:variable name="font-size">
			<xsl:choose>
				<xsl:when test="$level = 1">12pt</xsl:when>
				<xsl:when test="$level &gt;= 2">11pt</xsl:when>
				<xsl:otherwise>11pt</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="space-after">
			<xsl:choose>
					<xsl:when test="$level = 2">12pt</xsl:when>
					<xsl:otherwise>6pt</xsl:otherwise>
				</xsl:choose>
		</xsl:variable>

		<xsl:variable name="section">
			<xsl:call-template name="getSection">
				<xsl:with-param name="sectionNum" select="$sectionNum"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="ancestor::nist:legal-statement">
				<fo:block id="{$id}" font-family="Arial" font-size="12pt" font-weight="bold" text-align="center" margin-bottom="12pt" color="{$color}">
					<xsl:apply-templates />
				</fo:block>
			</xsl:when>
			<xsl:when test="ancestor::nist:executivesummary">
				<fo:block-container color="white" background-color="black" margin-bottom="12pt">
					<fo:block id="{$id}" font-family="Arial" font-size="12pt" font-weight="bold" text-align="left" margin-left="4mm" padding-top="1mm">
						<xsl:apply-templates />
					</fo:block>
				</fo:block-container>
			</xsl:when>
			<xsl:when test="ancestor::nist:preface">
				<fo:block id="{$id}" font-family="Arial" font-size="12pt" font-weight="bold" text-align="center" space-before="12pt" margin-bottom="12pt" color="{$color}">
					<xsl:apply-templates />
				</fo:block>
			</xsl:when>
			<xsl:when test="$parent-name = 'references'"> <!--  and $references_num_current != 1 -->
				<fo:block-container color="white" background-color="{$color}" margin-bottom="12pt" keep-with-next="always" height="5mm" margin-left="-0.5mm" margin-right="-0.5mm">
					<fo:block id="{$id}" font-family="Arial" font-size="12pt" font-weight="bold" margin-left="1mm" padding-top="0.3mm">
						<!-- <xsl:apply-templates /> -->
						<xsl:text>References</xsl:text>
					</fo:block>
				</fo:block-container>
			</xsl:when>
			<xsl:when test="ancestor::nist:annex and $level &gt;= 3">
				<fo:block id="{$id}" font-family="Arial" font-size="11pt" font-weight="bold" margin-top="3pt" margin-bottom="12pt">
					<xsl:if test="$parent-name != 'references'">
						<xsl:value-of select="$section"/><xsl:text>. </xsl:text>
					</xsl:if>
					<xsl:apply-templates />
				</fo:block>
			</xsl:when>
			<xsl:when test="ancestor::nist:annex and $level &gt;= 2">
				<fo:block id="{$id}" font-family="Arial" font-size="12pt" font-weight="bold" text-align="center" margin-top="3pt" margin-bottom="12pt">
					<xsl:if test="$parent-name != 'references'">
						<xsl:value-of select="$section"/><xsl:text>. </xsl:text>
					</xsl:if>
					<xsl:apply-templates />
				</fo:block>
			</xsl:when>
			<xsl:when test="$level = 1">
				<fo:block-container color="white" background-color="{$color}" margin-bottom="12pt" keep-with-next="always" height="6mm" margin-left="-2mm" margin-right="-2mm">
					<fo:block id="{$id}" font-family="Arial" font-size="{$font-size}" font-weight="bold" text-align="left" keep-with-next="always" margin-left="4mm" padding-top="1mm">
						<xsl:choose>
							<xsl:when test="$parent-name != 'annex'">
								<fo:inline padding-right="7.5mm"><xsl:value-of select="$section"/></fo:inline> <!-- . -->
							</xsl:when>
							<xsl:otherwise>
								<fo:inline><xsl:value-of select="$section"/> — </fo:inline>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:apply-templates />
					</fo:block>
				</fo:block-container>
			</xsl:when>
			<xsl:otherwise>
				<fo:block id="{$id}" font-family="Arial" font-size="{$font-size}" color="{$color}" font-weight="bold" text-align="left" space-after="{$space-after}" keep-with-next="always">
						<fo:inline padding-right="4mm"><xsl:value-of select="$section"/>.</fo:inline>
						<xsl:apply-templates />
					</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<xsl:template match="nist:preferred2">
		<xsl:param name="sectionNum"/>
		<!-- DEBUG need -->
		<fo:block space-before="6pt" text-align="justify">
			<fo:inline id="{../@id}" padding-right="5mm" font-weight="bold">
				<!-- <xsl:value-of select="$sectionNum"/><xsl:number format=".1" level="multiple" count="itu:clause/itu:clause | itu:clause/itu:terms | itu:terms/itu:term"/> -->
				<xsl:variable name="section">
					<xsl:call-template name="getSection">
						<xsl:with-param name="sectionNum" select="$sectionNum"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:value-of select="$section"/>
			</fo:inline>
			<fo:inline font-weight="bold">
				<xsl:apply-templates />
			</fo:inline>
			<xsl:if test="../nist:termsource/nist:origin">
				<xsl:text> [</xsl:text><xsl:value-of select="../nist:termsource/nist:origin/@citeas"/><xsl:text>]</xsl:text>
			</xsl:if>
			<xsl:text>: </xsl:text>
			<xsl:apply-templates select="following-sibling::nist:definition/node()" mode="process"/> <!--   -->
		</fo:block>
	</xsl:template>


	<xsl:template match="nist:p//nist:fn[not(ancestor::nist:table)] | nist:title/nist:fn | nist:table/nist:name/nist:fn" priority="2">
		<fo:footnote>
			<xsl:variable name="number">
				<xsl:number level="any" count="nist:p//nist:fn[not(ancestor::nist:table)] | nist:title/nist:fn | nist:table/nist:name/nist:fn"/>
			</xsl:variable>
			<fo:inline font-size="60%" keep-with-previous.within-line="always" vertical-align="super">
				<fo:basic-link internal-destination="footnote_{@reference}_{$number}" fox:alt-text="footnote {@reference} {$number}">
					<xsl:value-of select="$number + count(//nist:bibitem/nist:note)"/>
				</fo:basic-link>
			</fo:inline>
			<fo:footnote-body>
				<fo:block-container margin-left="3mm">
					<fo:block font-size="9pt" font-family="Times New Roman" font-style="normal" font-weight="normal" margin-left="-3mm" margin-top="6pt" margin-bottom="12pt" start-indent="0mm" text-indent="-2mm"   line-height="10pt" page-break-inside="avoid">
						<fo:inline id="footnote_{@reference}_{$number}" font-size="75%" keep-with-next.within-line="always" vertical-align="super" padding-right="1mm"> <!-- alignment-baseline="hanging" -->
							<xsl:value-of select="$number + count(//nist:bibitem/nist:note)"/>
						</fo:inline>
						<xsl:for-each select="nist:p">
							<xsl:apply-templates />
						</xsl:for-each>
					</fo:block>
				</fo:block-container>
			</fo:footnote-body>
		</fo:footnote>
	</xsl:template>


	<xsl:template match="*[local-name()='tt']" priority="2">
		<xsl:variable name="element-name">
			<xsl:choose>
				<xsl:when test="normalize-space(ancestor::nist:p[1]//text()[not(parent::nist:tt)]) != ''">fo:inline</xsl:when>
				<xsl:otherwise>fo:block</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:element name="{$element-name}">
			<xsl:attribute name="font-family">Courier</xsl:attribute>
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:apply-templates />
		</xsl:element>
	</xsl:template>


	<xsl:template match="nist:figure">
		<fo:block-container id="{@id}">
			<fo:block>
				<xsl:apply-templates />
			</fo:block>
			<xsl:call-template name="fn_display_figure"/>
			<xsl:for-each select="nist:note//nist:p">
				<xsl:call-template name="note"/>
			</xsl:for-each>
			<fo:block font-weight="bold" text-align="center" margin-bottom="6pt" keep-with-previous="always">
				<xsl:text>Figure </xsl:text>
				<xsl:choose>
					<xsl:when test="ancestor::nist:annex">
						<xsl:choose>
							<xsl:when test="count(//nist:annex) = 1">
								<xsl:value-of select="/nist:nist-standard/nist:bibdata/nist:ext/nist:structuredidentifier/nist:annexid"/><xsl:number format="-1" level="any" count="nist:annex//nist:figure"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:number format="A-1-1" level="multiple" count="nist:annex | nist:figure"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="ancestor::nist:figure">
						<xsl:for-each select="parent::*[1]">
							<xsl:number format="1" level="any" count="nist:figure[not(parent::nist:figure)]"/>
						</xsl:for-each>
						<xsl:number format="-a"  count="nist:figure"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:number format="1" level="any" count="nist:figure[not(parent::nist:figure)]"/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:if test="nist:name">
					<xsl:text> — </xsl:text>
					<xsl:value-of select="nist:name"/>
				</xsl:if>
			</fo:block>
		</fo:block-container>
	</xsl:template>

	<xsl:template match="nist:figure/nist:name"/>
	<xsl:template match="nist:figure/nist:fn" priority="2"/>
	<xsl:template match="nist:figure/nist:note"/>


	<xsl:template match="nist:figure2[@class = 'pseudocode']">
		<fo:block>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>

	<xsl:template match="nist:figure2[@class = 'pseudocode']//nist:p">
		<fo:block font-size="10pt" margin-top="6pt" margin-bottom="6pt">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>


	<xsl:template match="nist:image">
		<fo:block text-align="center">
			<!-- <fo:external-graphic src="{@src}" content-width="75%" content-height="scale-to-fit" scaling="uniform"/> -->
			<fo:external-graphic src="{@src}"
				width="75%"
				content-height="100%"
				content-width="scale-to-fit" scaling="uniform" fox:alt-text="Image"/>
		</fo:block>
	</xsl:template>


	<!-- Examples:
	[b-ASM]	b-ASM, http://www.eecs.umich.edu/gasm/ (accessed 20 March 2018).
	[b-Börger & Stärk]	b-Börger & Stärk, Börger, E., and Stärk, R. S. (2003), Abstract State Machines: A Method for High-Level System Design and Analysis, Springer-Verlag.
	-->
	<xsl:template match="nist:annex//nist:bibitem">
		<fo:block id="{@id}" margin-top="6pt" margin-left="12mm" text-indent="-12mm">
				<xsl:if test="nist:formattedref">
					<xsl:choose>
						<xsl:when test="nist:docidentifier[@type = 'metanorma']">
							<xsl:attribute name="margin-left">0</xsl:attribute>
							<xsl:attribute name="text-indent">0</xsl:attribute>
							<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
							<!-- create list -->
							<fo:list-block >
								<fo:list-item>
									<fo:list-item-label end-indent="label-end()">
										<fo:block>
											<xsl:apply-templates select="nist:docidentifier[@type = 'metanorma']" mode="process"/>
										</fo:block>
									</fo:list-item-label>
									<fo:list-item-body start-indent="body-start()">
										<fo:block margin-left="3mm">
											<xsl:apply-templates select="nist:formattedref"/>
										</fo:block>
									</fo:list-item-body>
								</fo:list-item>
							</fo:list-block>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="nist:formattedref"/>
							<xsl:apply-templates select="nist:docidentifier[@type != 'metanorma' or not(@type)]" mode="process"/>
						</xsl:otherwise>
					</xsl:choose>


				</xsl:if>
				<xsl:if test="nist:title">
					<xsl:for-each select="nist:contributor">
						<xsl:value-of select="nist:organization/nist:name"/>
						<xsl:if test="position() != last()">, </xsl:if>
					</xsl:for-each>
					<xsl:text> (</xsl:text>

					<xsl:value-of select="$date"/>
					<xsl:text>) </xsl:text>
					<fo:inline font-style="italic"><xsl:value-of select="nist:title"/></fo:inline>
					<xsl:if test="nist:contributor[nist:role/@type='publisher']/nist:organization/nist:name">
						<xsl:text> (</xsl:text><xsl:value-of select="nist:contributor[nist:role/@type='publisher']/nist:organization/nist:name"/><xsl:text>)</xsl:text>
					</xsl:if>
					<xsl:text>, </xsl:text>
					<xsl:value-of select="$date"/>
					<xsl:text>. </xsl:text>
					<xsl:value-of select="nist:docidentifier"/>
					<xsl:value-of select="$linebreak"/>
					<xsl:value-of select="nist:uri"/>
				</xsl:if>
		</fo:block>
	</xsl:template>

	<xsl:template match="nist:annex//nist:bibitem//nist:formattedref">
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="nist:docidentifier[@type = 'metanorma']" mode="process">
		<xsl:apply-templates />
	</xsl:template>
	<xsl:template match="nist:docidentifier[@type != 'metanorma' or not(@type)]" mode="process">
		<xsl:text> [</xsl:text><xsl:apply-templates /><xsl:text>]</xsl:text>
	</xsl:template>
	<xsl:template match="nist:docidentifier"/>



	<xsl:template match="nist:annex//nist:note/nist:p">
		<fo:block font-size="11pt" margin-top="4pt">
			<xsl:text>NOTE </xsl:text>
			<xsl:if test="../following-sibling::nist:note or ../preceding-sibling::nist:note">
					<xsl:number count="nist:note"/><xsl:text> </xsl:text>
				</xsl:if>
			<xsl:text>– </xsl:text>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>

	<xsl:template match="nist:ul | nist:ol">
		<fo:list-block >
			<xsl:apply-templates />
		</fo:list-block>
		<xsl:apply-templates select="./nist:note" mode="process"/>
	</xsl:template>

	<xsl:template match="nist:ul//nist:note |  nist:ol//nist:note"/>
	<xsl:template match="nist:ul//nist:note/nist:p  | nist:ol//nist:note/nist:p" mode="process">
		<fo:block font-size="11pt" margin-top="4pt">
			<xsl:text>NOTE </xsl:text>
			<xsl:if test="../following-sibling::nist:note or ../preceding-sibling::nist:note">
					<xsl:number count="nist:note"/><xsl:text> </xsl:text>
				</xsl:if>
			<xsl:text>– </xsl:text>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>

	<xsl:template match="nist:li">
		<xsl:variable name="level">
			<xsl:variable name="numtmp">
				<xsl:number level="multiple" count="nist:ol"/>
			</xsl:variable>
			<!-- level example: 1.1
				calculate counts of '.' in numtmp value - level of nested lists
			-->
			<xsl:value-of select="string-length($numtmp) - string-length(translate($numtmp, '.', '')) + 1"/>
		</xsl:variable>
		<fo:list-item>
			<fo:list-item-label end-indent="label-end()">
				<fo:block>
					<xsl:choose>
						<!-- <xsl:when test="local-name(..) = 'ul'">&#x2014;</xsl:when>--> <!-- dash -->
						<xsl:when test="local-name(..) = 'ul'">•</xsl:when>
						<xsl:otherwise> <!-- for ordered lists -->
							<xsl:choose>
								<xsl:when test="../@type = 'arabic'">
									<xsl:number format="a)"/>
								</xsl:when>
								<xsl:when test="../@type = 'alphabet'">
									<xsl:number format="1)"/>
								</xsl:when>
								<xsl:when test="ancestor::*[nist:annex]">
									<xsl:choose>
										<xsl:when test="$level = 1">
											<xsl:number format="a)"/>
										</xsl:when>
										<xsl:when test="$level = 2">
											<xsl:number format="i)"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:number format="1.)"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<xsl:otherwise>
									<xsl:number format="1."/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</fo:block>
			</fo:list-item-label>
			<fo:list-item-body start-indent="body-start()">
				<xsl:apply-templates />
				<xsl:apply-templates select=".//nist:note" mode="process"/>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>

	<xsl:template match="nist:li//nist:p">
		<xsl:variable name="num"><xsl:number/></xsl:variable>
		<fo:block margin-bottom="6pt">
			<xsl:if test="$num &gt;= 2">
				<xsl:attribute name="font-size">11pt</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>

	<xsl:template match="nist:link">
		<xsl:if test="ancestor::nist:formattedref">
			<xsl:value-of select="$linebreak"/>
		</xsl:if>
		<fo:basic-link external-destination="{@target}" color="blue" text-decoration="underline" fox:alt-text="link {@target}">
			<xsl:choose>
				<xsl:when test="normalize-space(.) = ''">
					<xsl:choose>
						<xsl:when test="starts-with(@target, 'mailto:')">
							<xsl:value-of select="substring-after(@target, 'mailto:')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="@target"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates />
				</xsl:otherwise>
			</xsl:choose>
		</fo:basic-link>
		<!-- </fo:inline> -->
	</xsl:template>


	<xsl:template match="nist:termnote">
		<fo:block margin-top="4pt">
			<xsl:text>NOTE </xsl:text>
				<xsl:if test="following-sibling::nist:termnote or preceding-sibling::nist:termnote">
					<xsl:number/><xsl:text> </xsl:text>
				</xsl:if>
				<xsl:text>– </xsl:text>
				<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	<xsl:template match="nist:termnote/nist:p">
		<xsl:apply-templates />
	</xsl:template>


	<xsl:template match="nist:annex">
		<fo:block break-after="page"/>
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="nist:formula" name="formula">
		<fo:block id="{@id}" margin-top="6pt"> <!--  text-align="center" -->
			<fo:table table-layout="fixed" width="100%">
				<fo:table-column column-width="95%"/>
				<fo:table-column column-width="5%"/>
				<fo:table-body>
					<fo:table-row>
						<fo:table-cell>
							<fo:block text-align="center">
								<xsl:if test="ancestor::nist:annex">
									<xsl:attribute name="text-align">left</xsl:attribute>
									<xsl:attribute name="margin-left">7mm</xsl:attribute>
								</xsl:if>
								<xsl:apply-templates />
							</fo:block>
						</fo:table-cell>
						<fo:table-cell> <!--  display-align="center" -->
							<fo:block text-align="right">
								<xsl:if test="not(ancestor::nist:annex)">
									<xsl:text>(</xsl:text><xsl:number level="any"/><xsl:text>)</xsl:text>
								</xsl:if>
								<xsl:if test="ancestor::nist:annex">
									<xsl:variable name="annex-id" select="ancestor::nist:annex/@id"/>
									<xsl:text>(</xsl:text>
									<xsl:number format="A-" count="nist:annex"/>
									<xsl:number format="1" level="any" count="nist:formula[ancestor::nist:annex[@id = $annex-id]]"/>
									<xsl:text>)</xsl:text>
								</xsl:if>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</fo:table-body>
			</fo:table>
			<fo:inline keep-together.within-line="always">
			</fo:inline>
		</fo:block>
	</xsl:template>

	<xsl:template match="nist:formula" mode="process">
		<xsl:call-template name="formula"/>
	</xsl:template>

	<xsl:template match="nist:xref">
		<xsl:param name="sectionNum"/>

		<xsl:variable name="section" select="xalan:nodeset($contents)//item[@id = current()/@target]/@section"/>

		<fo:basic-link internal-destination="{@target}" text-decoration="underline" color="blue" fox:alt-text="{@target}">
			<xsl:variable name="type" select="xalan:nodeset($contents)//item[@id = current()/@target]/@type"/>
			<xsl:choose>
				<xsl:when test="$type = 'clause'">Section </xsl:when><!-- and not (ancestor::annex) -->
				<xsl:when test="$type = 'Example'">Example </xsl:when>
				<xsl:otherwise></xsl:otherwise> <!-- <xsl:value-of select="$type"/> -->
			</xsl:choose>

			<xsl:choose>
				<xsl:when test="$type = 'Example'">
					<xsl:variable name="currentSection">
						<xsl:call-template name="getSection"/>
					</xsl:variable>
					<xsl:if test="not(contains($section, $currentSection))">
						<xsl:text>in </xsl:text>
						<xsl:value-of select="xalan:nodeset($contents)//item[@id = current()/@target]/@parent"/>
						<xsl:text> </xsl:text>
						<xsl:value-of select="$section"/>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="$section != ''"><xsl:value-of select="$section"/></xsl:when>
						<xsl:otherwise>???</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>

      </fo:basic-link>
	</xsl:template>


	<xsl:template match="nist:example">
		<fo:block id="{@id}" font-size="10pt" font-weight="bold" margin-bottom="12pt">EXAMPLE</fo:block>
		<fo:block font-size="11pt" margin-top="12pt" margin-bottom="12pt" margin-left="15mm" >
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	<xsl:template match="nist:example/nist:p">
		<xsl:variable name="num"><xsl:number/></xsl:variable>
		<fo:block margin-bottom="12pt">
			<xsl:if test="$num = 1">
				<xsl:attribute name="margin-left">5mm</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>

<!-- 	<xsl:template match="itu:example/itu:name">
		<fo:block font-weight="bold">
			<xsl:text>EXAMPLE</xsl:text>
			<xsl:if test="count(ancestor::itu:clause[1]/itu:example) &gt; 1">
				<xsl:text> </xsl:text><xsl:number count="itu:example"/>
			</xsl:if>
			<xsl:text> — </xsl:text>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template> -->




	<xsl:template match="nist:eref">
		<!-- <fo:inline color="blue"> -->
		<fo:basic-link internal-destination="{@bibitemid}" color="blue" fox:alt-text="{@citeas}">
			<xsl:if test="@type = 'footnote'">
				<xsl:attribute name="keep-together.within-line">always</xsl:attribute>
				<xsl:attribute name="font-size">80%</xsl:attribute>
				<xsl:attribute name="keep-with-previous.within-line">always</xsl:attribute>
				<xsl:attribute name="vertical-align">super</xsl:attribute>
			</xsl:if>
			<xsl:if test="@type = 'inline'">
				<xsl:attribute name="text-decoration">underline</xsl:attribute>
			</xsl:if>
			<!-- <xsl:text>[</xsl:text> --><xsl:value-of select="@citeas" disable-output-escaping="yes"/><!-- <xsl:text>]</xsl:text> -->
			<xsl:if test="nist:locality">
				<xsl:text>, </xsl:text>
				<xsl:choose>
					<xsl:when test="nist:locality/@type = 'section'">Section </xsl:when>
					<xsl:when test="nist:locality/@type = 'clause'">Clause </xsl:when>
					<xsl:otherwise></xsl:otherwise>
				</xsl:choose>
				<xsl:apply-templates select="nist:locality"/>
			</xsl:if>
		</fo:basic-link>
		<!-- </fo:inline> -->
	</xsl:template>


	<xsl:template match="nist:terms[nist:term[nist:preferred and nist:definition]]">
		<fo:block id="{@id}">
			<fo:table width="100%" table-layout="fixed">
				<fo:table-column column-width="22%"/>
				<fo:table-column column-width="78%"/>
				<fo:table-body>
					<xsl:apply-templates mode="table"/>
				</fo:table-body>
			</fo:table>
		</fo:block>
	</xsl:template>
	<xsl:template match="nist:term" mode="table">
		<fo:table-row>
			<fo:table-cell padding-right="1mm">
				<fo:block margin-bottom="12pt">
					<xsl:apply-templates select="nist:preferred"/>
				</fo:block>
			</fo:table-cell>
			<fo:table-cell>
				<fo:block margin-bottom="12pt">
					<xsl:apply-templates select="nist:*[local-name(.) != 'preferred']"/>
				</fo:block>
			</fo:table-cell>
		</fo:table-row>
	</xsl:template>
	<xsl:template match="nist:preferred">
		<fo:inline id="{../@id}">
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>
	<xsl:template match="nist:definition/nist:p">
		<fo:block>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>

	<xsl:template match="nist:errata">
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
				<fo:table-row font-family="Arial" text-align="center" font-weight="bold" background-color="black" color="white">
					<fo:table-cell border="1pt solid black"><fo:block>Date</fo:block></fo:table-cell>
					<fo:table-cell border="1pt solid black"><fo:block>Type</fo:block></fo:table-cell>
					<fo:table-cell border="1pt solid black"><fo:block>Change</fo:block></fo:table-cell>
					<fo:table-cell border="1pt solid black"><fo:block>Pages</fo:block></fo:table-cell>
				</fo:table-row>
				<xsl:apply-templates />
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<xsl:template match="nist:errata/nist:row">
		<fo:table-row>
			<xsl:apply-templates />
		</fo:table-row>
	</xsl:template>

	<xsl:template match="nist:errata/nist:row/*">
		<fo:table-cell border="1pt solid black" padding-left="1mm" padding-top="0.5mm">
			<fo:block><xsl:apply-templates /></fo:block>
		</fo:table-cell>
	</xsl:template>

	<xsl:template match="nist:quote">
		<fo:block-container margin-left="7mm" margin-right="7mm">
			<xsl:apply-templates />
			<xsl:apply-templates select="nist:author" mode="process"/>
		</fo:block-container>
	</xsl:template>

	<xsl:template match="nist:quote/nist:author"/>
	<xsl:template match="nist:quote/nist:p">
		<fo:block text-align="justify" margin-bottom="12pt">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	<xsl:template match="nist:quote/nist:author" mode="process">
		<fo:block text-align="right" margin-left="0.5in" margin-right="0.5in">
			<fo:inline>— </fo:inline>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>

	<xsl:template match="nist:sourcecode">
		<fo:block font-family="Courier" font-size="10pt" margin-top="6pt" margin-bottom="6pt">
		<!-- 	<xsl:choose>
				<xsl:when test="@lang = 'en'"></xsl:when>
				<xsl:otherwise> -->
					<xsl:attribute name="white-space">pre</xsl:attribute>
					<xsl:attribute name="wrap-option">wrap</xsl:attribute>
				<!-- </xsl:otherwise>
			</xsl:choose> -->
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<!-- <xsl:template match="nist:dt//nist:stem">
		<xsl:apply-templates />
		<xsl:value-of select="$linebreak"/>
	</xsl:template> -->



	<xsl:template name="insertHeaderFooter">
		<xsl:call-template name="insertHeader"/>
		<xsl:call-template name="insertFooter"/>
	</xsl:template>

	<xsl:template name="insertHeader">
		<fo:static-content flow-name="header" font-family="Arial" font-size="7.5pt">
			<fo:block-container height="1in" display-align="before" color="{$color}">
				<fo:block padding-top="0.5in" margin-bottom="7pt" line-height="115%"> <!-- text-align-last="justify" -->
					<fo:table table-layout="fixed" width="100%">
						<fo:table-column column-width="70%"/>
						<fo:table-column column-width="30%"/>
						<fo:table-body>
							<fo:table-row>
								<fo:table-cell>
									<fo:block>
										<xsl:call-template name="recursiveSmallCaps">
											<xsl:with-param name="text" select="$seriestitle"/>
										</xsl:call-template>
									</fo:block>
								</fo:table-cell>
								<fo:table-cell>
									<fo:block text-align="right">
										<xsl:call-template name="recursiveSmallCaps">
											<xsl:with-param name="text" select="$title"/>
										</xsl:call-template>
									</fo:block>
								</fo:table-cell>
							</fo:table-row>
						</fo:table-body>
					</fo:table>
					<!-- <xsl:call-template name="recursiveSmallCaps">
						<xsl:with-param name="text" select="$seriestitle"/>
					</xsl:call-template>
					<fo:inline keep-together.within-line="always">
						<fo:leader leader-pattern="space"/>
						<xsl:call-template name="recursiveSmallCaps">
							<xsl:with-param name="text" select="$title"/>
						</xsl:call-template>
					</fo:inline> -->
				</fo:block>
				<!-- <fo:block>
					<xsl:call-template name="recursiveSmallCaps">
						<xsl:with-param name="text" select="$date"/>
					</xsl:call-template>
				</fo:block> -->
			</fo:block-container>
		</fo:static-content>
	</xsl:template>
	
	<xsl:template name="insertFooter">
		<fo:static-content flow-name="footer" font-size="11pt">
			<fo:block-container height="1in" display-align="after" color="{$color}">
				<fo:block text-align="center" padding-bottom="0.65in"><fo:page-number/></fo:block>
			</fo:block-container>
		</fo:static-content>
	</xsl:template>
	
	<xsl:variable name="Image-NIST-Logo">
		<xsl:text>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
			</xsl:text>
	</xsl:variable>


	<!-- convert YYYY-MM-DD to (Month YYYY) -->
	<xsl:template name="formatDate">
		<xsl:param name="date"/>
		<xsl:variable name="year" select="substring($date, 1, 4)"/>
		<xsl:variable name="month" select="substring($date, 6, 2)"/>
		<xsl:variable name="day" select="substring($date, 9)"/>
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
		<xsl:variable name="result" select="normalize-space(concat($monthStr, ' ', $day, ', ', $year))"/>
		<xsl:value-of select="$result"/>
	</xsl:template>

	<!-- convert YYYY-MM-DD to MM-DD-YYYY -->
	<xsl:template name="formatDateDigits">
		<xsl:param name="date"/>
		<xsl:variable name="year" select="substring($date, 1, 4)"/>
		<xsl:variable name="month" select="substring($date, 6, 2)"/>
		<xsl:variable name="day" select="substring($date, 9, 2)"/>
		<xsl:if test="$year != ''">
			<xsl:value-of select="$month"/>-<xsl:value-of select="$day"/>-<xsl:value-of select="$year"/>
		</xsl:if>
	</xsl:template>

	<xsl:template name="getLevel">
		<xsl:variable name="level_total" select="count(ancestor::*)"/>
		<xsl:variable name="level">
			<xsl:choose>
				<xsl:when test="ancestor::nist:sections">
					<xsl:value-of select="$level_total - 2"/>
				</xsl:when>
				<xsl:when test="ancestor::nist:bibliography">
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
				<xsl:when test="ancestor::nist:bibliography">
					<xsl:value-of select="$sectionNum"/>
				</xsl:when>
				<xsl:when test="ancestor::nist:sections">
					<!-- 1, 2, 3, 4, ... from main section (not annex, bibliography, ...) -->
					<xsl:choose>
						<xsl:when test="$level = 1">
							<xsl:value-of select="$sectionNum"/>
						</xsl:when>
						<xsl:when test="$level &gt;= 2">
							<xsl:variable name="num">
								<xsl:number format=".1" level="multiple" count="nist:clause/nist:clause | nist:clause/nist:terms | nist:terms/nist:term | nist:clause/nist:term"/>
							</xsl:variable>
							<xsl:value-of select="concat($sectionNum, $num)"/>
						</xsl:when>
						<xsl:otherwise>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="ancestor::nist:annex[@obligation = 'informative']">
					<xsl:choose>
						<xsl:when test="$level = 1">
							<xsl:text>Appendix  </xsl:text>
							<xsl:number format="I" level="any" count="nist:annex[@obligation = 'informative']"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:number format="I.1" level="multiple" count="nist:annex[@obligation = 'informative'] | nist:clause"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="ancestor::nist:annex">
					<xsl:choose>
						<xsl:when test="$level = 1">
							<xsl:text>Appendix </xsl:text>
							<xsl:choose>
								<xsl:when test="count(//nist:annex) = 1">
									<xsl:value-of select="/nist:nist-standard/nist:bibdata/nist:ext/nist:structuredidentifier/nist:annexid"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:number format="A" level="any" count="nist:annex"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="count(//nist:annex) = 1">
									<xsl:value-of select="/nist:nist-standard/nist:bibdata/nist:ext/nist:structuredidentifier/nist:annexid"/><xsl:number format=".1" level="multiple" count="nist:clause"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:number format="A.1" level="multiple" count="nist:annex | nist:clause"/>
								</xsl:otherwise>
							</xsl:choose>
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
