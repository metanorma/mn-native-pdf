<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:nist="https://www.metanorma.org/ns/nist" xmlns:mathml="http://www.w3.org/1998/Math/MathML" xmlns:xalan="http://xml.apache.org/xalan" xmlns:fox="http://xmlgraphics.apache.org/fop/extensions" version="1.0">

	<xsl:output version="1.0" method="xml" encoding="UTF-8" indent="no"/>

	<xsl:include href="./common.xsl"/>

	<xsl:variable name="namespace">nist</xsl:variable>
	
	<xsl:variable name="pageWidth" select="'8.5in'"/>
	<xsl:variable name="pageHeight" select="'11in'"/>

	<xsl:variable name="debug">false</xsl:variable>
	
	<xsl:variable name="title" select="/nist:nist-standard/nist:bibdata/nist:title[@language = 'en' and @type = 'main']"/>
	<xsl:variable name="sub-title" select="/nist:nist-standard/nist:bibdata/nist:title[@language = 'en' and @type = 'subtitle']"/>

	<!-- stage possible values: draft-internal, draft-wip, draft-prelim, draft-public, final, final-review -->
	<xsl:variable name="stage" select="/nist:nist-standard/nist:bibdata/nist:status/nist:stage"/>
	<!-- substage possible values: active, withdrawn, retired -->
	<xsl:variable name="substagetmp" select="/nist:nist-standard/nist:bibdata/nist:status/nist:substage"/>
	<xsl:variable name="substage">
		<xsl:variable name="withdrawn-date" select="translate(/nist:nist-standard/nist:bibdata/nist:date[@type = 'withdrawn']/nist:on, '-','')"/>
		 <xsl:variable name="published-date" select="translate(/nist:nist-standard/nist:bibdata/nist:date[@type = 'published']/nist:on, '-','')"/>
		<xsl:choose>
			<xsl:when test="$substagetmp = 'withdrawn' and  $withdrawn-date &gt; $published-date">withdrawn-pending</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$substagetmp"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable> 
	<xsl:variable name="iteration" select="normalize-space(/nist:nist-standard/nist:bibdata/nist:status/nist:iteration)"/>

	<!-- Example:
		<item level="1" id="Foreword" display="true">Foreword</item>
		<item id="term-script" display="false">3.2</item>
	-->
	<xsl:variable name="contents">
		<contents>
			<xsl:apply-templates select="/nist:nist-standard/nist:preface/nist:executivesummary" mode="contents"/>
			<xsl:apply-templates select="/nist:nist-standard/nist:sections/*" mode="contents"/> <!-- /* Main sections -->
			<xsl:apply-templates select="/nist:nist-standard/nist:annex" mode="contents"/>
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
					<fo:region-body margin-top="1in" margin-bottom="1in" margin-left="1in" margin-right="1in"/>
					<fo:region-before extent="1in"/>
					<fo:region-after extent="1in"/>
					<fo:region-start extent="1in"/>
					<fo:region-end extent="1in"/>
				</fo:simple-page-master>

				<!-- Document pages -->
				<fo:simple-page-master master-name="document" page-width="{$pageWidth}" page-height="{$pageHeight}">
					<fo:region-body margin-top="1in" margin-bottom="1in" margin-left="1in" margin-right="1in"/>
					<fo:region-before region-name="header" extent="1in"/>
					<fo:region-after region-name="footer" extent="1in"/>
					<fo:region-start region-name="left" extent="1in"/>
					<fo:region-end region-name="right" extent="1in"/>
				</fo:simple-page-master>
				<!-- Document Annex pages -->
				<fo:simple-page-master master-name="document-annex" page-width="{$pageWidth}" page-height="{$pageHeight}">
					<fo:region-body margin-top="1in" margin-bottom="1in" margin-left="1in" margin-right="1in"/>
					<fo:region-before region-name="header" extent="1in"/>
					<fo:region-after region-name="footer-annex" extent="1in"/>
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
				<fo:flow flow-name="xsl-region-body">

					
					
					<xsl:variable name="stage-str">
						<xsl:choose>
							<xsl:when test="$stage = 'draft-internal'">Internal Draft</xsl:when>
							<xsl:when test="$stage = 'draft-wip'">Work-in-Progress Draft</xsl:when>
							<xsl:when test="$stage = 'draft-prelim'">Preliminary Draft</xsl:when>
							<xsl:when test="$stage = 'draft-public'">
								<xsl:choose>
									<xsl:when test="$iteration = '' or $iteration = 'initial'">Initial Public Draft (IPD)</xsl:when>
									<xsl:when test="$iteration = 'final'">Final Public Draft (FPD)</xsl:when>
									<!-- iteration 2 - Second Public Draft (2PD) -->
									<!-- iteration 3 - Third Public Draft (3PD) -->
									<xsl:when test="string(number($iteration)) != 'NaN'">
										<xsl:call-template name="number-to-words">
											<xsl:with-param name="number" select="$iteration"/>
										</xsl:call-template>
										<xsl:text>Public Draft (</xsl:text><xsl:value-of select="$iteration"/><xsl:text>PD)</xsl:text>
									</xsl:when>
									<xsl:otherwise><xsl:value-of select="$iteration"/></xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>Draft</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:variable name="substage-str">
						<xsl:choose>
							<xsl:when test="contains ($stage, 'draft') and $substage = 'withdrawn'">Withdrawn Draft</xsl:when>
							<xsl:when test="contains ($stage, 'draft') and $substage = 'retired'">Retired Draft</xsl:when>
							<xsl:when test="$substage = 'withdrawn-pending'">Withdrawal Pending</xsl:when>
							<xsl:otherwise></xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:variable name="revision" select="/nist:nist-standard/nist:bibdata/nist:docidentifier[@type = 'nist-long']"/>
					<xsl:variable name="revision-part1" select="normalize-space(substring-before($revision, 'Revision'))"/>
					<xsl:variable name="revision-part2" select="normalize-space(concat('Revision ', substring-after($revision, 'Revision')))"/>
					<xsl:variable name="revision-text">
						<xsl:choose>
							<xsl:when test="$revision-part1 != ''">
								<xsl:value-of select="$revision-part1"/>
								<xsl:value-of select="$linebreak"/>
								<xsl:value-of select="$revision-part2"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$revision"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:choose>
						<xsl:when test="$stage = 'final' and $substage = 'withdrawn'">
							<!-- logo -->
							<fo:block-container absolute-position="fixed" left="133mm" top="1mm">
								<fo:block>
									<fo:external-graphic src="{concat('data:image/png;base64,', normalize-space($Image-NIST-Logo))}" width="55mm" content-height="23.3mm" content-width="scale-to-fit" scaling="uniform" fox:alt-text="Image"/>
								</fo:block>
							</fo:block-container>
							
							<fo:block-container absolute-position="fixed" left="25mm" top="260mm">
								<fo:block font-size="12pt">
									<xsl:text>Date updated: March 21, 2018</xsl:text>
								</fo:block>
							</fo:block-container>
							
							<fo:block-container border="1.5pt solid black" display-align="center" margin-left="-2.5mm" margin-right="-2.5mm">
								<fo:block font-size="22pt" font-weight="bold" text-align="center" padding-top="2mm" padding-bottom="2mm">
									<xsl:text>Withdrawn NIST Technical</xsl:text>
									<xsl:value-of select="$linebreak"/>
									<xsl:text>Series Publication</xsl:text>
								</fo:block>
							</fo:block-container>
						</xsl:when>
					
						<xsl:when test="contains($stage,'draft') or $substage = 'withdrawn' or $substage = 'withdrawn-pending' or $substage = 'retired'">
							<!-- logo -->
							<fo:block-container absolute-position="fixed" left="133mm" top="229mm">
								<fo:block>
									<fo:external-graphic src="{concat('data:image/png;base64,', normalize-space($Image-NIST-Logo))}" width="55mm" content-height="23.3mm" content-width="scale-to-fit" scaling="uniform" fox:alt-text="Image"/>
								</fo:block>
							</fo:block-container>
							
							<xsl:variable name="outstring">
								<xsl:choose>
									<xsl:when test="contains ($stage, 'draft') and ($substage = 'withdrawn' or $substage = 'retired')">
										<xsl:value-of select="$substage-str"/>
									</xsl:when>
									<xsl:when test="contains($stage,'draft')">
										<xsl:value-of select="$stage-str"/>
									</xsl:when>
									<xsl:when test="$substage = 'withdrawn' or $substage = 'withdrawn-pending'">
										<xsl:value-of select="$substage-str"/>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:if test="normalize-space($outstring) != ''">
								<fo:block-container border="1.5pt solid black" height="15mm" display-align="center" margin-left="-2.5mm" margin-right="-2.5mm">
									<fo:block font-size="24pt" font-weight="bold" text-align="center" padding-top="2mm">
										<xsl:value-of select="$outstring"/>
									</fo:block>
								</fo:block-container>
							</xsl:if>
						</xsl:when>
					</xsl:choose>
					
					<xsl:variable name="newpage">
						<xsl:choose>
							<xsl:when test="$stage = 'final' and $substage = 'withdrawn'">true</xsl:when>
							<xsl:when test="contains ($stage, 'draft') and $substage = 'withdrawn'">true</xsl:when>
							<xsl:when test="contains ($stage, 'draft') and $substage = 'retired'">true</xsl:when>
							<xsl:when test="contains($stage,'draft')">true</xsl:when>
							<xsl:when test="$substage = 'withdrawn' or $substage = 'withdrawn-pending'">true</xsl:when>
							<xsl:otherwise>false</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					
					<xsl:choose>
						<!-- Additional NIST PDF cover pages according to status draft -->
						
						<xsl:when test="$stage = 'final' and $substage = 'withdrawn'">
							<fo:block font-size="24pt">&#xA0;</fo:block>
							<fo:block-container margin-left="-2.5mm" margin-right="-2.5mm">
								<fo:block margin-left="2.5mm" margin-right="2.5mm">
									<fo:table table-layout="fixed" width="100%" border="1.5pt solid black">
										<fo:table-column column-width="23%"/>
										<fo:table-column column-width="77%"/>
										<fo:table-body>
											<fo:table-row height="11mm">
												<fo:table-cell font-weight="bold" text-align="center" number-columns-spanned="2">
													<fo:block padding-top="1mm">Warning Notice</fo:block>
												</fo:table-cell>
											</fo:table-row>
											<fo:table-row>
												<fo:table-cell number-columns-spanned="2"  padding-left="1.5mm">
													<fo:block margin-bottom="12pt">
														<xsl:text>The attached publication has been withdrawn (archived), and is provided solely for historical purposes. It may have been superseded by another publication (indicated below).</xsl:text>
													</fo:block>
												</fo:table-cell>
											</fo:table-row>
											<fo:table-row height="9mm">
												<fo:table-cell font-weight="bold"  padding-left="1.5mm" display-align="center" number-columns-spanned="2" background-color="rgb(217, 217, 217)" border="1pt solid black">
													<fo:block>Withdrawn Publication</fo:block>
												</fo:table-cell>
											</fo:table-row>
											<fo:table-row>
												<fo:table-cell padding-left="1.5mm" padding-top="1mm" border="0.5pt solid black">
													<fo:block font-weight="bold">Series/Number</fo:block>
												</fo:table-cell>
												<fo:table-cell padding-left="1.5mm" padding-top="1mm" border="0.5pt solid black">
													<fo:block><xsl:value-of select="/nist:nist-standard/nist:bibdata/nist:docidentifier[@type = 'NIST']"/></fo:block>
												</fo:table-cell>
											</fo:table-row>
											<fo:table-row>
												<fo:table-cell padding-left="1.5mm" padding-top="1mm" border="0.5pt solid black">
													<fo:block font-weight="bold">Title</fo:block>
												</fo:table-cell>
												<fo:table-cell padding-left="1.5mm" padding-top="1mm" border="0.5pt solid black">
													<fo:block><xsl:value-of select="$title"/></fo:block>
												</fo:table-cell>
											</fo:table-row>
											<fo:table-row>
												<fo:table-cell padding-left="1.5mm" padding-top="1mm" border="0.5pt solid black">
													<fo:block font-weight="bold">Publication Date(s)</fo:block>
												</fo:table-cell>
												<fo:table-cell padding-left="1.5mm" padding-top="1mm" border="0.5pt solid black">
													<fo:block>November 2016 (including updates as of January 3, 2018)</fo:block>
												</fo:table-cell>
											</fo:table-row>
											<fo:table-row>
												<fo:table-cell padding-left="1.5mm" padding-top="1mm" border="0.5pt solid black">
													<fo:block font-weight="bold">Withdrawal Date</fo:block>
												</fo:table-cell>
												<fo:table-cell padding-left="1.5mm" padding-top="1mm" border="0.5pt solid black">
													<fo:block>
														<xsl:call-template name="formatDate">
															<xsl:with-param name="date" select="/nist:nist-standard/nist:bibdata/nist:date[@type = 'withdrawn']/nist:on"/>
															<xsl:with-param name="format" select="'full'"/>
														</xsl:call-template>
													</fo:block>
												</fo:table-cell>
											</fo:table-row>
											<fo:table-row>
												<fo:table-cell padding-left="1.5mm" padding-top="1mm" border="0.5pt solid black">
													<fo:block font-weight="bold">Withdrawal Note</fo:block>
												</fo:table-cell>
												<fo:table-cell padding-left="1.5mm" padding-top="1mm" border="0.5pt solid black">
													<fo:block>SP 800-160 (1/3/18 update) is superseded in its entirety by the publication of SP 800-160 Volume 1 (3/21/18 update).</fo:block>
												</fo:table-cell>
											</fo:table-row>
											<fo:table-row height="9mm">
												<fo:table-cell font-weight="bold"  padding-left="1.5mm" display-align="center" number-columns-spanned="2" background-color="rgb(217, 217, 217)" border="1pt solid black">
													<fo:block>Superseding Publication(s)<fo:inline font-weight="normal" font-style="italic"> (if applicable)</fo:inline></fo:block>
												</fo:table-cell>
											</fo:table-row>
											<fo:table-row height="9mm">
												<fo:table-cell padding-left="1.5mm" display-align="center" number-columns-spanned="2" border="1pt solid black">
													<fo:block>The attached publication has been <fo:inline font-weight="bold">superseded by</fo:inline> the following publication(s):</fo:block>
												</fo:table-cell>
											</fo:table-row>
											<fo:table-row>
												<fo:table-cell padding-left="1.5mm" padding-top="1mm" border="0.5pt solid black">
													<fo:block font-weight="bold">Series/Number</fo:block>
												</fo:table-cell>
												<fo:table-cell padding-left="1.5mm" padding-top="1mm" border="0.5pt solid black">
													<fo:block><xsl:value-of select="/nist:nist-standard/nist:bibdata/nist:docidentifier[@type = 'NIST']"/></fo:block>
												</fo:table-cell>
											</fo:table-row>
											<fo:table-row>
												<fo:table-cell padding-left="1.5mm" padding-top="1mm" border="0.5pt solid black">
													<fo:block font-weight="bold">Title</fo:block>
												</fo:table-cell>
												<fo:table-cell padding-left="1.5mm" padding-top="1mm" border="0.5pt solid black">
													<fo:block><xsl:value-of select="$title"/></fo:block>
												</fo:table-cell>
											</fo:table-row>
											<fo:table-row>
												<fo:table-cell padding-left="1.5mm" padding-top="1mm" border="0.5pt solid black">
													<fo:block font-weight="bold">Author(s)</fo:block>
												</fo:table-cell>
												<fo:table-cell padding-left="1.5mm" padding-top="1mm" border="0.5pt solid black">
													<fo:block>Ron Ross; Michael McEvilley; Janet Carrier Owen</fo:block>
												</fo:table-cell>
											</fo:table-row>
											<fo:table-row>
												<fo:table-cell padding-left="1.5mm" padding-top="1mm" border="0.5pt solid black">
													<fo:block font-weight="bold">Publication Date(s)</fo:block>
												</fo:table-cell>
												<fo:table-cell padding-left="1.5mm" padding-top="1mm" border="0.5pt solid black">
													<fo:block>November 2016 (updated 3/21/2018)</fo:block>
												</fo:table-cell>
											</fo:table-row>
											<fo:table-row>
												<fo:table-cell padding-left="1.5mm" padding-top="1mm" border="0.5pt solid black">
													<fo:block font-weight="bold">URL/DOI</fo:block>
												</fo:table-cell>
												<fo:table-cell padding-left="1.5mm" padding-top="1mm" border="0.5pt solid black">
													<fo:block color="blue" text-decoration="underline">https://doi.org/10.6028/NIST.SP.800-160v1</fo:block>
												</fo:table-cell>
											</fo:table-row>
											<fo:table-row height="9mm">
												<fo:table-cell font-weight="bold"  padding-left="1.5mm" display-align="center" number-columns-spanned="2" background-color="rgb(217, 217, 217)" border="1pt solid black">
													<fo:block>Additional Information<fo:inline font-weight="normal" font-style="italic"> (if applicable)</fo:inline></fo:block>
												</fo:table-cell>
											</fo:table-row>
											<fo:table-row>
												<fo:table-cell padding-left="1.5mm" padding-top="1mm" border="0.5pt solid black">
													<fo:block font-weight="bold">Contact</fo:block>
												</fo:table-cell>
												<fo:table-cell padding-left="1.5mm" padding-top="1mm" border="0.5pt solid black">
													<fo:block>Computer Security Division (Information Technology Laboratory)</fo:block>
												</fo:table-cell>
											</fo:table-row>
											<fo:table-row>
												<fo:table-cell padding-left="1.5mm" padding-top="1mm" border="0.5pt solid black">
													<fo:block font-weight="bold">Latest revision of the attached publication</fo:block>
												</fo:table-cell>
												<fo:table-cell padding-left="1.5mm" padding-top="1mm" border="0.5pt solid black">
													<fo:block></fo:block>
												</fo:table-cell>
											</fo:table-row>
											<fo:table-row>
												<fo:table-cell padding-left="1.5mm" padding-right="1.5mm" padding-top="1mm" border="0.5pt solid black">
													<fo:block font-weight="bold">Related Information</fo:block>
												</fo:table-cell>
												<fo:table-cell padding-left="1.5mm" padding-top="1mm" border="0.5pt solid black">
													<fo:block>https://csrc.nist.gov/projects/systems-security-engineering-project</fo:block>
												</fo:table-cell>
											</fo:table-row>
											<fo:table-row>
												<fo:table-cell padding-left="1.5mm"  padding-right="1.5mm" padding-top="1mm" border="0.5pt solid black">
													<fo:block font-weight="bold">Withdrawal Announcement Link</fo:block>
												</fo:table-cell>
												<fo:table-cell padding-left="1.5mm" padding-top="1mm" border="0.5pt solid black">
													<fo:block></fo:block>
												</fo:table-cell>
											</fo:table-row>
										</fo:table-body>
									</fo:table>
								</fo:block>
							</fo:block-container>
						</xsl:when>
						
						<xsl:when test="contains ($stage, 'draft') and $substage = 'withdrawn'">
							<!-- Warning block -->
							<fo:block font-size="12pt">&#xA0;</fo:block>
							<fo:block font-size="12pt">&#xA0;</fo:block>
							<fo:block-container border="1pt solid black" margin-left="-2mm" margin-right="-2mm">
								<fo:block font-size="12pt" margin-left="4.5mm" margin-right="4.5mm" padding-top="1mm">
									<fo:block font-weight="bold" text-align="center">
										<xsl:text>Warning Notice</xsl:text>
									</fo:block>
									<fo:block>&#xA0;</fo:block>
									<fo:block text-align="left">
										<xsl:text>The attached draft document has been withdrawn, and is provided solely for historical purposes. It has been superseded by the document identified below.</xsl:text>
									</fo:block>
									<fo:block font-size="12pt" margin-top="6pt">
										<fo:table table-layout="fixed" width="100%">
											<fo:table-column column-width="50%"/>
											<fo:table-column column-width="50%"/>
											<fo:table-body>
												<fo:table-row height="10mm">
													<fo:table-cell font-weight="bold" text-align="right" margin-right="2mm">
														<fo:block>Withdrawal Date</fo:block>
													</fo:table-cell>
													<fo:table-cell padding-left="1mm"  margin-left="1mm">
														<fo:block>
															<xsl:call-template name="formatDate">
																<xsl:with-param name="date" select="/nist:nist-standard/nist:bibdata/nist:date[@type = 'withdrawn']/nist:on"/>
																<xsl:with-param name="format" select="'full'"/>
															</xsl:call-template>
														</fo:block>
													</fo:table-cell>
												</fo:table-row>
												<fo:table-row height="10mm">
													<fo:table-cell font-weight="bold" text-align="right" margin-right="2mm">
														<fo:block>Original Release Date</fo:block>
													</fo:table-cell>
													<fo:table-cell padding-left="1mm"  margin-left="1mm">
														<fo:block>
															<xsl:call-template name="formatDate">
																<xsl:with-param name="date" select="/nist:nist-standard/nist:bibdata/nist:date[@type = 'original']/nist:on"/>
																<xsl:with-param name="format" select="'full'"/>
															</xsl:call-template>
														</fo:block>
													</fo:table-cell>
												</fo:table-row>
											</fo:table-body>
										</fo:table>
									</fo:block>
								</fo:block>
							</fo:block-container>
							<fo:block font-size="14pt">&#xA0;</fo:block>
							<fo:block font-size="14pt">&#xA0;</fo:block>
							<xsl:call-template name="insertSupersedingDocument"/>
						</xsl:when>
						
						
						<xsl:when test="contains ($stage, 'draft') and $substage = 'retired'">
							<!-- Warning block -->
							<fo:block font-size="12pt">&#xA0;</fo:block>
							<fo:block font-size="12pt">&#xA0;</fo:block>
							<fo:block-container border="1pt solid black" margin-left="-2mm" margin-right="-2mm">
								<fo:block font-size="12pt" margin-left="4.5mm" margin-right="4.5mm" padding-top="1mm">
									<fo:block font-weight="bold" text-align="center">
										<xsl:text>Warning Notice</xsl:text>
									</fo:block>
									<fo:block>&#xA0;</fo:block>
									<fo:block text-align="left">
										<xsl:text>The attached draft document has been RETIRED. NIST has discontinued additional development of this document, which is provided here in its entirety for historical purposes.</xsl:text>
									</fo:block>
									<fo:block font-size="12pt" margin-top="6pt">
										<fo:table table-layout="fixed" width="100%">
											<fo:table-column column-width="50%"/>
											<fo:table-column column-width="50%"/>
											<fo:table-body>
												<fo:table-row height="10mm">
													<fo:table-cell font-weight="bold" text-align="right" margin-right="2mm">
														<fo:block>Retired Date</fo:block>
													</fo:table-cell>
													<fo:table-cell padding-left="1mm"  margin-left="1mm">
														<fo:block>
															<xsl:call-template name="formatDate">
																<xsl:with-param name="date" select="/nist:nist-standard/nist:bibdata/nist:date[@type = 'retired']/nist:on"/>
																<xsl:with-param name="format" select="'full'"/>
															</xsl:call-template>
														</fo:block>
													</fo:table-cell>
												</fo:table-row>
												<fo:table-row height="10mm">
													<fo:table-cell font-weight="bold" text-align="right" margin-right="2mm">
														<fo:block>Original Release Date</fo:block>
													</fo:table-cell>
													<fo:table-cell padding-left="1mm"  margin-left="1mm">
														<fo:block>
															<xsl:call-template name="formatDate">
																<xsl:with-param name="date" select="/nist:nist-standard/nist:bibdata/nist:date[@type = 'original']/nist:on"/>
																<xsl:with-param name="format" select="'full'"/>
															</xsl:call-template>
														</fo:block>
													</fo:table-cell>
												</fo:table-row>
											</fo:table-body>
										</fo:table>
									</fo:block>
								</fo:block>
							</fo:block-container>
							<fo:block font-size="14pt">&#xA0;</fo:block>
							<fo:block font-size="14pt">&#xA0;</fo:block>
							<xsl:call-template name="insertSupersedingDocument">
								<xsl:with-param name="type" select="'Retired'"/>
							</xsl:call-template>
						</xsl:when>
						
						
						<xsl:when test="contains($stage,'draft')"> 
							
							<fo:block font-size="20pt">&#xA0;</fo:block>
							<fo:block font-size="18pt">&#xA0;</fo:block>
							
							<fo:block font-size="18pt" font-weight="bold" text-align="right">
								<xsl:value-of select="$revision-text"/>
							</fo:block>
							
							<fo:block font-size="20pt" font-weight="bold" margin-top="18pt" margin-bottom="6pt" text-align="right">
								<xsl:value-of select="$title"/>
							</fo:block>
							
							<fo:block font-size="18pt" font-weight="bold" font-style="italic" margin-bottom="18pt" text-align="right">
								<xsl:value-of select="$sub-title"/>
							</fo:block>
							
							<xsl:choose>
								<xsl:when test="$stage = 'draft-public'">
									<fo:block font-size="12pt">&#xA0;</fo:block>
								</xsl:when>
								<xsl:otherwise>
									<fo:block font-size="14pt">&#xA0;</fo:block>
									<fo:block font-size="12pt">&#xA0;</fo:block>
								</xsl:otherwise>
							</xsl:choose>
							
							<!-- Warning block -->
							<fo:block-container border="0.5pt solid black" margin-left="-2mm" margin-right="-2mm">
								<fo:block font-size="12pt" margin-left="4.5mm" margin-right="4.5mm" padding-top="2mm" padding-bottom="3mm">
									<xsl:choose>
										<xsl:when test="$stage = 'draft-internal'">
											<fo:block font-size="12pt" font-weight="bold" text-align="center">
												<xsl:text>Warning Notice</xsl:text>
											</fo:block>
											<fo:block>&#xA0;</fo:block>
											<fo:block font-size="14pt" text-align="center">
												<xsl:text>This document is currently under development and is</xsl:text>
												<xsl:value-of select="$linebreak"/>
												<fo:inline font-weight="bold">NOT INTENDED FOR PUBLIC RELEASE.</fo:inline>
											</fo:block>
											<fo:block font-size="12pt">&#xA0;</fo:block>
										</xsl:when>
										<xsl:when test="$stage = 'draft-wip'">
											<fo:block font-size="12pt" font-weight="bold"  text-align="center" >
												<xsl:text>Warning Notice</xsl:text>
											</fo:block>
											<fo:block>&#xA0;</fo:block>
											<fo:block font-size="12pt" text-align="justify">
												<xsl:text>This document is currently under development. The draft is not yet complete, and organizations should not attempt to implement it. The content is in an early stage of development, rough, incomplete and experimental; it has not been extensively edited or vetted. This provides an insider view of the iterative process to develop the content and it gives NIST an opportunity to share early thoughts, ideas, and approaches with the community. NIST welcomes early informal feedback and comments, which will be adjudicated after the specified public comment period.</xsl:text>
											</fo:block>
											<fo:block font-size="12pt" margin-top="18pt" margin-bottom="12pt">
												<fo:table table-layout="fixed" width="100%">
													<fo:table-column column-width="50%"/>
													<fo:table-column column-width="50%"/>
													<fo:table-body>
														<fo:table-row>
															<fo:table-cell font-weight="bold" text-align="right" margin-right="2mm">
																<fo:block>Original Release Date</fo:block>
															</fo:table-cell>
															<fo:table-cell padding-left="1mm"  margin-left="1mm">
																<fo:block>
																	<xsl:call-template name="formatDate">
																		<xsl:with-param name="date" select="/nist:nist-standard/nist:bibdata/nist:date[@type = 'original']/nist:on"/>
																		<xsl:with-param name="format" select="'full'"/>
																	</xsl:call-template>
																</fo:block>
															</fo:table-cell>
														</fo:table-row>
													</fo:table-body>
												</fo:table>
											</fo:block>
										</xsl:when>
										<xsl:when test="$stage = 'draft-prelim'">
											<fo:block font-size="12pt" font-weight="bold"  text-align="center" >
												<xsl:text>Warning Notice</xsl:text>
											</fo:block>
											<fo:block>&#xA0;</fo:block>
											<fo:block text-align="justify">
												<xsl:text>This document incorporates comments from the work-in-progress draft. It is a relatively cohesive document and is considered stable, although there are gaps in the content and the overall document is incomplete. Some changes are expected. Organizations may consider experimenting with guidelines, with the understanding that they will identify gaps and challenges. NIST welcomes early informal feedback and comments, which will be adjudicated after the specified public comment period; a full public draft is expected to follow.</xsl:text>
											</fo:block>
											<fo:block font-size="12pt" margin-top="18pt" margin-bottom="12pt">
												<fo:table table-layout="fixed" width="100%">
													<fo:table-column column-width="50%"/>
													<fo:table-column column-width="50%"/>
													<fo:table-body>
														<fo:table-row>
															<fo:table-cell font-weight="bold" text-align="right" margin-right="2mm">
																<fo:block>Original Release Date</fo:block>
															</fo:table-cell>
															<fo:table-cell padding-left="1mm"  margin-left="1mm">
																<fo:block>
																	<xsl:call-template name="formatDate">
																		<xsl:with-param name="date" select="/nist:nist-standard/nist:bibdata/nist:date[@type = 'original']/nist:on"/>
																		<xsl:with-param name="format" select="'full'"/>
																	</xsl:call-template>
																</fo:block>
															</fo:table-cell>
														</fo:table-row>
													</fo:table-body>
												</fo:table>
											</fo:block>
										</xsl:when>
										<xsl:when test="$stage = 'draft-public'">
											<fo:block font-size="12pt" font-weight="bold"  text-align="center" >
												<xsl:text>Warning Notice</xsl:text>
											</fo:block>
											<fo:block>&#xA0;</fo:block>
											<fo:block text-align="justify">
												<xsl:text>This draft represents a complete document that is released for public comment as part of NIST’s official review process, in support of an open and transparent process for developing guidelines and standards. The language is normalized and is consistent throughout the document. Comments received during previous review cycles (if any) have been adjudicated and are addressed in this release. Early adopters may attempt to implement the guidelines in a test or development environment; however, comments received on this draft may cause NIST to determine that a subsequent public draft and comment period are necessary. The content of this document will not be considered “final” until it is formally published and announced by NIST.</xsl:text>
											</fo:block>
											<fo:block font-size="12pt" margin-top="18pt" margin-bottom="12pt">
												<fo:table table-layout="fixed" width="100%">
													<fo:table-column column-width="50%"/>
													<fo:table-column column-width="50%"/>
													<fo:table-body>
														<fo:table-row>
															<fo:table-cell font-weight="bold" text-align="right" margin-right="2mm">
																<fo:block>Original Release Date</fo:block>
															</fo:table-cell>
															<fo:table-cell padding-left="1mm"  margin-left="1mm">
																<fo:block>
																	<xsl:call-template name="formatDate">
																		<xsl:with-param name="date" select="/nist:nist-standard/nist:bibdata/nist:date[@type = 'original']/nist:on"/>
																		<xsl:with-param name="format" select="'full'"/>
																	</xsl:call-template>
																</fo:block>
															</fo:table-cell>
														</fo:table-row>
													</fo:table-body>
												</fo:table>
											</fo:block>
										</xsl:when>
									</xsl:choose>
								</fo:block>
							</fo:block-container>

							<xsl:if test="$stage = 'draft-internal' or $stage = 'draft-wip' or $stage = 'draft-prelim' or $stage = 'draft-public'">
								<xsl:call-template name="insertSecurityBlock"/>
							</xsl:if>
							<xsl:if test="$stage = 'draft-public'">
								<fo:block font-size="12pt">&#xA0;</fo:block>
								<xsl:if test="/nist:nist-standard/nist:bibdata/nist:uri[@type = 'doi']">
									<fo:block font-size="12pt" text-align="center">
										<fo:block>This publication is available free of charge from:</fo:block>
										<fo:block color="blue" text-decoration="underline">
											<xsl:value-of select="/nist:nist-standard/nist:bibdata/nist:uri[@type = 'doi']"/>
										</fo:block>
									</fo:block>
								</xsl:if>
							</xsl:if>
						</xsl:when>
						
						
						<xsl:when test="$substage = 'withdrawn' or $substage = 'withdrawn-pending'">
							<fo:block font-size="12pt">&#xA0;</fo:block>
							<fo:block font-size="12pt">&#xA0;</fo:block>
							<!-- Warning block -->
							<fo:block-container border="1pt solid black" margin-left="-2mm" margin-right="-2mm">
								<fo:block font-size="12pt" margin-left="4.5mm" margin-right="4.5mm" padding-top="1mm">
									<fo:block font-weight="bold" text-align="center">
										<xsl:text>Warning Notice</xsl:text>
									</fo:block>
									<fo:block>&#xA0;</fo:block>
									<fo:block text-align="left">
										<xsl:text>This document has been superseded by the document identified below. It will remain active until the withdrawal date, when it will be officially withdrawn.</xsl:text>
									</fo:block>
									<fo:block font-size="12pt" margin-top="6pt">
										<fo:table table-layout="fixed" width="100%">
											<fo:table-column column-width="50%"/>
											<fo:table-column column-width="50%"/>
											<fo:table-body>
												<fo:table-row height="10mm">
													<fo:table-cell font-weight="bold" text-align="right" margin-right="2mm">
														<fo:block>Withdrawal Date</fo:block>
													</fo:table-cell>
													<fo:table-cell padding-left="1mm"  margin-left="1mm">
														<fo:block>
															<xsl:call-template name="formatDate">
																<xsl:with-param name="date" select="/nist:nist-standard/nist:bibdata/nist:date[@type = 'withdrawn']/nist:on"/>
																<xsl:with-param name="format" select="'full'"/>
															</xsl:call-template>
														</fo:block>
													</fo:table-cell>
												</fo:table-row>
												<fo:table-row height="10mm">
													<fo:table-cell font-weight="bold" text-align="right" margin-right="2mm">
														<fo:block>Superseded Date</fo:block>
													</fo:table-cell>
													<fo:table-cell padding-left="1mm"  margin-left="1mm">
														<fo:block>
															<xsl:call-template name="formatDate">
																<xsl:with-param name="date" select="/nist:nist-standard/nist:bibdata/nist:date[@type = 'superseded']/nist:on"/>
																<xsl:with-param name="format" select="'full'"/>
															</xsl:call-template>
														</fo:block>
													</fo:table-cell>
												</fo:table-row>
												<fo:table-row height="10mm">
													<fo:table-cell font-weight="bold" text-align="right" margin-right="2mm">
														<fo:block>Original Release Date</fo:block>
													</fo:table-cell>
													<fo:table-cell padding-left="1mm"  margin-left="1mm">
														<fo:block>
															<xsl:call-template name="formatDate">
																<xsl:with-param name="date" select="/nist:nist-standard/nist:bibdata/nist:date[@type = 'original']/nist:on"/>
																<xsl:with-param name="format" select="'full'"/>
															</xsl:call-template>
														</fo:block>
													</fo:table-cell>
												</fo:table-row>
											</fo:table-body>
										</fo:table>
									</fo:block>
								</fo:block>
							</fo:block-container>
							<fo:block font-size="14pt">&#xA0;</fo:block>
							<fo:block font-size="14pt">&#xA0;</fo:block>
							<xsl:call-template name="insertSupersedingDocument"/>
						</xsl:when>
					</xsl:choose>

					<xsl:if test="$newpage = 'true'">
						<fo:block break-after="page"/>
					</xsl:if>
					
					<!-- Show logo at second page -->
					<xsl:if test="$newpage = 'true' or not(contains($stage,'draft') or $substage = 'withdrawn' or $substage = 'withdrawn-pending' or $substage = 'retired')">
						<!-- logo -->
						<fo:block-container absolute-position="fixed" left="130mm" top="220mm">
							<fo:block>
								<fo:external-graphic src="{concat('data:image/png;base64,', normalize-space($Image-NIST-Logo))}" width="63.2mm" content-height="26.8mm" content-width="scale-to-fit" scaling="uniform" fox:alt-text="Image"/>
							</fo:block>
						</fo:block-container>
					</xsl:if>


					<fo:block text-align="right">
						<!-- Example: NIST Special Publication 800-116
								 Revision 1  -->
						<fo:block font-size="20pt" font-weight="bold" line-height="90%">
							<xsl:value-of select="$revision-text"/>
						</fo:block>

						<!-- Example: Guidelines for the Use of PIV Credentials in Facility Access -->
						<fo:block-container margin-top="18pt" margin-bottom="6pt" border-top="3pt solid black"  border-bottom="1.5pt solid black">
							<fo:block font-size="28pt" font-weight="bold" padding-top="3mm" letter-spacing="-0.5pt">
								<xsl:value-of select="$title"/><xsl:text> </xsl:text>
							</fo:block>
							<xsl:if test="$sub-title != ''">
								<fo:block font-size="18pt" font-style="italic" margin-bottom="18pt">
									<xsl:value-of select="$sub-title"/>
								</fo:block>
							</xsl:if>
						</fo:block-container>

						<fo:block font-size="14pt" margin-bottom="12pt">&#xA0;</fo:block>

						<!-- Authors list -->
						<fo:block font-size="14pt">
							<xsl:for-each select="/nist:nist-standard/nist:bibdata/nist:contributor[nist:role/@type = 'author']">
								<fo:block><xsl:value-of select="nist:person/nist:name/nist:completename"/></fo:block>
							</xsl:for-each>
						</fo:block>
						<fo:block font-size="14pt">&#xA0;</fo:block>
						<fo:block font-size="14pt">&#xA0;</fo:block>

						<fo:block font-size="14pt">This publication is available free of charge from:</fo:block>
						<fo:block font-size="14pt">
							<xsl:value-of select="/nist:nist-standard/nist:bibdata/nist:uri[@type = 'doi']"/>
						</fo:block>
						<fo:block font-size="14pt">&#xA0;</fo:block>
						<fo:block font-size="14pt">&#xA0;</fo:block>
						<fo:block font-size="14pt">&#xA0;</fo:block>

						<xsl:if test="/nist:nist-standard/nist:bibdata/nist:title[@language = 'en' and @type = 'document-class']">
							<!-- EXAMPLE: INFORMATION SECURITY -->
							<fo:block-container border-top="1.5pt solid black" border-bottom="1.5pt solid black">
								<!-- Used Helvetica font (https://stackoverflow.com/questions/25261949/xsl-fo-letter-spacing-with-text-align) -->
								<fo:block font-family="Arial" font-size="16pt" text-align="center" padding-top="1mm">
									<!-- <fo:inline letter-spacing="10pt"><xsl:value-of select="translate(/nist:nist-standard/nist:bibdata/nist:title[@language = 'en' and @type = 'document-class'], $lower, $upper)"/></fo:inline> -->
									<xsl:call-template name="addLetterSpacing">
										<xsl:with-param name="text" select="translate(/nist:nist-standard/nist:bibdata/nist:title[@language = 'en' and @type = 'document-class'], $lower, $upper)"/>
									</xsl:call-template>
								</fo:block>
							</fo:block-container>
						</xsl:if>

						<fo:block break-after="page"/>
						<!-- second page Cover -->

						<!-- Text container -->
						<fo:block-container absolute-position="fixed" left="50mm" top="180mm" width="135mm" height="70mm" text-align="right">
							<fo:block font-size="14pt">This publication is available free of charge from:</fo:block>
							<fo:block font-size="14pt">
								<xsl:value-of select="/nist:nist-standard/nist:bibdata/nist:uri[@type = 'doi']"/>
							</fo:block>
							<fo:block font-size="14pt">&#xA0;</fo:block>
							<fo:block font-size="14pt">
								<xsl:call-template name="formatDate">
									<xsl:with-param name="date" select="/nist:nist-standard/nist:bibdata/nist:date[@type = 'issued']/nist:on"/>
								</xsl:call-template>
							</fo:block>
							<fo:block font-size="14pt">&#xA0;
								<xsl:if test="/nist:nist-standard/nist:bibdata/nist:date[@type='updated']/nist:on">
									<fo:basic-link internal-destination="'_errata'" color="blue" text-decoration="underline" fox:alt-text="Errata">
										<xsl:text>INCLUDES UPDATES AS OF </xsl:text>
										<xsl:call-template name="formatDateDigits">
											<xsl:with-param name="date" select="/nist:nist-standard/nist:bibdata/nist:date[@type='updated']/nist:on"/>
										</xsl:call-template>
										</fo:basic-link>
								</xsl:if>
							</fo:block>
							<fo:block>
								<fo:external-graphic src="{concat('data:image/png;base64,', normalize-space($Image-Dep-Commerce-Logo))}" width="24.1mm" content-height="23.8mm" content-width="scale-to-fit" scaling="uniform" fox:alt-text="Logo"/>
							</fo:block>
							<fo:block font-size="11pt">U.S. Department of Commerce</fo:block>

							<fo:block font-size="10pt">
								<fo:block font-style="italic">Wilbur L. Ross, Jr., Secretary</fo:block>
								<fo:block>&#xA0;</fo:block>
								<fo:block>National Institute of Standards and Technology </fo:block>
								<fo:block font-style="italic">Walter Copan, NIST Director and Under Secretary of Commerce for Standards and Technology</fo:block>
							</fo:block>
						</fo:block-container>

						<!-- Example: NIST Special Publication 800-116
								 Revision 1  -->
						<fo:block font-size="20pt" font-weight="bold" line-height="90%" margin-bottom="12pt">
							<xsl:value-of select="$revision-text"/>
						</fo:block>

						<fo:block font-size="14pt">&#xA0;</fo:block>

						<!-- Example: Guidelines for the Use of PIV Credentials in Facility Access -->
						<fo:block-container margin-top="18pt" margin-bottom="6pt">
							<fo:block font-size="28pt" font-weight="bold" padding-top="3mm" letter-spacing="-0.5pt">
								<xsl:value-of select="$title"/><xsl:text> </xsl:text>
							</fo:block>
							<xsl:if test="$sub-title != ''">
								<fo:block font-size="18pt" font-style="italic" margin-bottom="18pt">
									<xsl:value-of select="$sub-title"/>
								</fo:block>
							</xsl:if>
						</fo:block-container>

						<!-- Authors list -->
						<fo:block font-size="14pt">
							<xsl:for-each select="/nist:nist-standard/nist:bibdata/nist:contributor[nist:role/@type = 'author']">
								<fo:block>
									<fo:block><xsl:value-of select="nist:person/nist:name/nist:completename"/></fo:block>
									<xsl:variable name="org-name" select="nist:person/nist:affiliation/nist:organization/nist:name"/>
									<xsl:variable name="org-address" select="nist:person/nist:affiliation/nist:organization/nist:address/nist:formattedAddress"/>
									<xsl:if test="concat(following-sibling::nist:contributor[nist:role/@type = 'author'][1]/nist:person/nist:affiliation/nist:organization/nist:name,
									                               following-sibling::nist:contributor[nist:role/@type = 'author'][1]/nist:person/nist:affiliation/nist:organization/nist:address/nist:formattedAddress) !=
																		concat($org-name, $org-address)">
										<fo:block font-style="italic" margin-bottom="12pt">
											<xsl:value-of select="$org-name"/>
											<xsl:if test="normalize-space($org-address) != ''">
												<fo:inline>, <xsl:value-of select="$org-address"/></fo:inline>
											</xsl:if>
										</fo:block>
									</xsl:if>
								</fo:block>
							</xsl:for-each>
						</fo:block>

					</fo:block>
				</fo:flow>
			</fo:page-sequence>


			<fo:page-sequence master-reference="document" initial-page-number="3" format="i" force-page-count="no-force">
				<fo:static-content flow-name="xsl-footnote-separator">
					<fo:block>
						<fo:leader leader-pattern="rule" leader-length="30%"/>
					</fo:block>
				</fo:static-content>
				<xsl:call-template name="insertHeaderFooter"/>
				<fo:flow flow-name="xsl-region-body">

					<xsl:if test="/nist:nist-standard/nist:boilerplate">
						<xsl:apply-templates select="/nist:nist-standard/nist:boilerplate"/>
						<fo:block break-after="page"/>
					</xsl:if>


					<xsl:apply-templates select="/nist:nist-standard/nist:preface/nist:foreword"/>

					<xsl:if test="/nist:nist-standard/nist:preface/nist:abstract">
						<fo:block font-family="Arial" text-align="center" font-weight="bold" margin-bottom="12pt">Abstract</fo:block>
						<xsl:apply-templates select="/nist:nist-standard/nist:preface/nist:abstract"/>
					</xsl:if>


					<!-- Keywords -->
					<xsl:if test="/nist:nist-standard/nist:bibdata/nist:keyword">
						<fo:block font-family="Arial" font-weight="bold" text-align="center" margin-bottom="12pt">
							<xsl:text>Keywords</xsl:text>
						</fo:block>
						<fo:block>
							<xsl:for-each select="/nist:nist-standard/nist:bibdata//nist:keyword">
								<xsl:sort data-type="text" order="ascending"/>
								<xsl:apply-templates/>
								<xsl:choose>
									<xsl:when test="position() != last()">; </xsl:when>
									<xsl:otherwise>.</xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
						</fo:block>
					</xsl:if>
					<fo:block break-after="page"/>
					<xsl:apply-templates select="/nist:nist-standard/nist:preface/nist:acknowledgements"/>
					<xsl:apply-templates select="/nist:nist-standard/nist:preface/nist:clause"/>
					<fo:block break-after="page"/>


					<!-- Executive summary -->
					<xsl:apply-templates select="/nist:nist-standard/nist:preface/nist:executivesummary"/>

					<xsl:if test="$debug = 'true'">
						<xsl:text disable-output-escaping="yes">&lt;!--</xsl:text>
							DEBUG
							contents=<xsl:copy-of select="xalan:nodeset($contents)"/>
						<xsl:text disable-output-escaping="yes">--&gt;</xsl:text>
					</xsl:if>
					
					<!-- CONTENTS -->
					<fo:block break-after="page"/>
					<fo:block-container font-family="Arial" font-size="11pt">
						<fo:block font-size="12pt" margin-bottom="12pt" text-align="center" font-weight="bold">Table of Contents</fo:block>
							<xsl:for-each select="xalan:nodeset($contents)//item[not(@type = 'table') and not(@type = 'figure')]">
								<xsl:if test="@display = 'true'">
									<fo:block>
										<xsl:if test="@level = 1">
											<xsl:attribute name="margin-top">6pt</xsl:attribute>
											<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
										</xsl:if>
										<fo:block text-align-last="justify" margin-left="12mm" text-indent="-12mm">
											<xsl:if test="@level &gt;= 2 and @section != ''">
												<xsl:attribute name="margin-left">22mm</xsl:attribute>
												<!-- <xsl:attribute name="text-indent">-24mm</xsl:attribute> -->
											</xsl:if>
											<xsl:if test="@type = 'annex'">
												<xsl:attribute name="font-weight">bold</xsl:attribute>
											</xsl:if>
											<fo:basic-link internal-destination="{@id}" fox:alt-text="{text()}">
												<xsl:if test="@section != '' and not(@display-section = 'false')"> <!--   -->
													<xsl:value-of select="@section"/>
													<xsl:choose>
														<xsl:when test="@type = 'annex'">
															<xsl:text> — </xsl:text>
														</xsl:when>
														<xsl:otherwise>
															<xsl:text>. </xsl:text>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:if>
												<xsl:value-of select="text()"/>
												<fo:inline keep-together.within-line="always">
													<fo:leader leader-pattern="dots"/>
													<xsl:if test="@type = 'annex'">
														<xsl:value-of select="@annexnum"/><xsl:text>-</xsl:text>
													</xsl:if>
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
												<xsl:if test="@parent = 'annex'">
													<xsl:value-of select="@annexnum"/><xsl:text>-</xsl:text>
												</xsl:if>
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
												<xsl:if test="@parent = 'annex'">
													<xsl:value-of select="@annexnum"/><xsl:text>-</xsl:text>
												</xsl:if>
												<fo:page-number-citation ref-id="{@id}"/>
											</fo:inline>
										</fo:basic-link>
									</fo:block>
								</xsl:for-each>
							</xsl:if>
					</fo:block-container>
				</fo:flow>
			</fo:page-sequence>

			<!-- BODY -->
			<fo:page-sequence master-reference="document" initial-page-number="1" force-page-count="no-force">
				<fo:static-content flow-name="xsl-footnote-separator">
					<fo:block>
						<fo:leader leader-pattern="rule" leader-length="30%"/>
					</fo:block>
				</fo:static-content>

				<xsl:call-template name="insertHeaderFooter"/>

				<fo:flow flow-name="xsl-region-body">
					<!-- Clause(s) -->
					<fo:block>
						<xsl:apply-templates select="/nist:nist-standard/nist:sections/*"/>

						<!-- <xsl:apply-templates select="/nist:nist-standard/nist:annex"/> --> <!-- last() -->

					</fo:block>

				</fo:flow>
			</fo:page-sequence>

			<xsl:for-each select="/nist:nist-standard/nist:annex">
				<fo:page-sequence master-reference="document-annex" initial-page-number="1" force-page-count="no-force">
					<fo:static-content flow-name="xsl-footnote-separator">
						<fo:block>
							<fo:leader leader-pattern="rule" leader-length="30%"/>
						</fo:block>
					</fo:static-content>
					<xsl:call-template name="insertHeaderFooterAnnex"/>
					<fo:flow flow-name="xsl-region-body">
						<fo:marker marker-class-name="annex_number"><xsl:number format="A"/></fo:marker>
						<fo:block>
							<xsl:apply-templates />
						</fo:block>
					</fo:flow>
				</fo:page-sequence>
			</xsl:for-each>

		</fo:root>
	</xsl:template>

	
	<xsl:template name="insertSupersedingDocument">
		<xsl:param name="type" select="'Superseding'"/>
		<fo:block font-size="12pt">
			<fo:table table-layout="fixed" width="100%">
				<fo:table-column column-width="28%"/>
				<fo:table-column column-width="72%"/>
				<fo:table-body>
					<fo:table-row height="9mm">
						<fo:table-cell font-weight="bold" text-align="center" display-align="center" number-columns-spanned="2" background-color="rgb(217, 217, 217)">
							<fo:block><xsl:value-of select="$type"/> Document</fo:block>
						</fo:table-cell>
					</fo:table-row>
					<fo:table-row height="10mm">
						<fo:table-cell font-weight="bold" text-align="right" display-align="center" margin-right="2mm">
							<fo:block>Status</fo:block>
						</fo:table-cell>
						<fo:table-cell padding-left="1mm" display-align="center" margin-left="1mm">
							<fo:block>
								<xsl:choose>
									<xsl:when test="$iteration = '' or $iteration = 'initial'">Initial Public Draft (IPD)</xsl:when>
									<xsl:when test="$iteration = 'final'">Final</xsl:when>
									<!-- iteration 2 - Second Public Draft (2PD) -->
									<!-- iteration 3 - Third Public Draft (3PD) -->
									<xsl:when test="string(number($iteration)) != 'NaN'">
										<xsl:call-template name="number-to-words-short">
											<xsl:with-param name="number" select="$iteration"/>
										</xsl:call-template>
										<xsl:text>Public Draft (</xsl:text><xsl:value-of select="$iteration"/><xsl:text>PD)</xsl:text>
									</xsl:when>
									<xsl:otherwise><xsl:value-of select="$iteration"/></xsl:otherwise>
								</xsl:choose>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
					<fo:table-row height="10mm">
						<fo:table-cell font-weight="bold" text-align="right" display-align="center" margin-right="2mm">
							<fo:block>Series/Number</fo:block>
						</fo:table-cell>
						<fo:table-cell padding-left="1mm" display-align="center" margin-left="1mm">
							<fo:block><xsl:value-of select="/nist:nist-standard/nist:bibdata/nist:docidentifier[@type = 'NIST']"/></fo:block>
						</fo:table-cell>
					</fo:table-row>
					<fo:table-row height="10mm">
						<fo:table-cell font-weight="bold" text-align="right" display-align="center" margin-right="2mm">
							<fo:block>Title</fo:block>
						</fo:table-cell>
						<fo:table-cell padding-left="1mm" display-align="center" margin-left="1mm">
							<fo:block><xsl:value-of select="$title"/></fo:block>
						</fo:table-cell>
					</fo:table-row>
					<fo:table-row height="10mm">
						<fo:table-cell font-weight="bold" text-align="right" display-align="center" margin-right="2mm">
							<fo:block>Publication Date</fo:block>
						</fo:table-cell>
						<fo:table-cell padding-left="1mm" display-align="center" margin-left="1mm">
							<fo:block>
								<xsl:call-template name="formatDate">
									<xsl:with-param name="date" select="/nist:nist-standard/nist:bibdata/nist:date[@type = 'published']/nist:on"/>
								</xsl:call-template>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
					<xsl:if test="$type = 'Superseding'">
						<fo:table-row height="10mm">
							<fo:table-cell font-weight="bold" text-align="right" display-align="center" margin-right="2mm">
								<fo:block>DOI</fo:block>
							</fo:table-cell>
							<fo:table-cell padding-left="1mm" display-align="center" margin-left="1mm">
								<fo:block color="blue" text-decoration="underline"><xsl:value-of select="/nist:nist-standard/nist:bibdata/nist:uri[@type = 'doi']"/><xsl:text> </xsl:text></fo:block>
							</fo:table-cell>
						</fo:table-row>
						<fo:table-row height="10mm">
							<fo:table-cell font-weight="bold" text-align="right" display-align="center" margin-right="2mm">
								<fo:block>CSRC URL</fo:block>
							</fo:table-cell>
							<fo:table-cell padding-left="1mm" display-align="center" margin-left="1mm">
								<fo:block color="blue" text-decoration="underline"><xsl:value-of select="/nist:nist-standard/nist:bibdata/nist:uri[@type = 'csrc']"/><xsl:text> </xsl:text></fo:block>
							</fo:table-cell>
						</fo:table-row>
					</xsl:if>
					<fo:table-row height="10mm">
						<fo:table-cell font-weight="bold" text-align="right" display-align="center" margin-right="2mm">
							<fo:block>Additional Information</fo:block>
						</fo:table-cell>
						<fo:table-cell padding-left="1mm" display-align="center" margin-left="1mm">
							<fo:block>
								<xsl:if test="$type = 'Retired'">
									See <fo:inline color="blue" text-decoration="underline">https://csrc.nist.gov</fo:inline> for information on NIST cybersecurity publications and programs.
								</xsl:if>
								<xsl:text> </xsl:text>
								</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</fo:table-body>
			</fo:table>
		</fo:block>
	</xsl:template>
	
	<xsl:template name="insertSecurityBlock">
		<xsl:if test="/nist:nist-standard/nist:bibdata/nist:title[@language = 'en' and @type = 'document-class']">
			<!-- EXAMPLE: C  O  M  P  U  T  E  R      S  E  C  U  R  I  T  Y -->
			<!-- absolute-position="fixed" top="193mm" left="25.4mm" width="166mm"   -->
			<fo:block-container absolute-position="fixed" top="202mm" left="26mm" height="7mm" width="165mm" border-top="1.5pt solid black" border-bottom="1.5pt solid black">
				<fo:block font-family="Arial" font-size="16pt" text-align="center" padding-top="0.7mm">
					<xsl:call-template name="addLetterSpacing">
						<xsl:with-param name="text" select="translate(/nist:nist-standard/nist:bibdata/nist:title[@language = 'en' and @type = 'document-class'], $lower, $upper)"/>
					</xsl:call-template>
				</fo:block>
			</fo:block-container>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="nist:preface/nist:acknowledgements[not(nist:title)]">
		<fo:block id="{@id}" font-family="Arial" font-size="12pt" font-weight="bold" text-align="center" space-before="12pt" margin-bottom="12pt">
			<xsl:text>Acknowledgements</xsl:text>
		</fo:block>
		<xsl:apply-templates />
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
		<!-- sectionNum=<xsl:value-of select="$sectionNum"/> -->
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

		<!-- <xsl:message>
			level=<xsl:value-of select="$level"/>=<xsl:value-of select="."/>
		</xsl:message> -->

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
			<xsl:if test="$type = 'clause' and ancestor::nist:annex">
				<xsl:attribute name="parent">annex</xsl:attribute>
			</xsl:if>
			<xsl:if test="ancestor::nist:annex">
				<xsl:attribute name="annexnum">
					<xsl:call-template name="getAnnexNum">
						<xsl:with-param name="str" select="$section"/>
					</xsl:call-template>
				</xsl:attribute>
			</xsl:if>
			<xsl:value-of select="."/>
		</item>

		<xsl:apply-templates mode="contents">
			<xsl:with-param name="sectionNum" select="$sectionNum"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:variable name="annexprefix" select="'Appendix '"/>
	 
	<xsl:template name="getAnnexNum">
		<xsl:param name="str"/>
		<xsl:choose>
			<xsl:when test="contains($str, $annexprefix)">
				<xsl:value-of select="normalize-space(substring-after($str, $annexprefix))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$str"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="nist:bibitem" mode="contents"/>

	<xsl:template match="nist:references" mode="contents">
		<xsl:param name="sectionNum" />
		<xsl:apply-templates mode="contents">
			<xsl:with-param name="sectionNum" select="$sectionNum"/>
		</xsl:apply-templates>
	</xsl:template>


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
			<xsl:if test="ancestor::nist:annex">
				<xsl:variable name="section">
					<xsl:for-each select="ancestor::nist:annex[1]/*[1]">
						<xsl:call-template name="getSection"/>
					</xsl:for-each>
				</xsl:variable>
				<xsl:attribute name="annexnum">
					<xsl:call-template name="getAnnexNum">
						<xsl:with-param name="str" select="$section"/>
					</xsl:call-template>
				</xsl:attribute>
				<xsl:attribute name="parent">annex</xsl:attribute>
			</xsl:if>
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
			<xsl:if test="ancestor::nist:annex">
				<xsl:variable name="section">
					<xsl:for-each select="ancestor::nist:annex[1]/*[1]">
						<xsl:call-template name="getSection"/>
					</xsl:for-each>
				</xsl:variable>
				<xsl:attribute name="annexnum">
					<xsl:call-template name="getAnnexNum">
						<xsl:with-param name="str" select="$section"/>
					</xsl:call-template>
				</xsl:attribute>
				<xsl:attribute name="parent">annex</xsl:attribute>
			</xsl:if>
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
					<xsl:value-of select="$annexprefix"/><xsl:number format="A" count="nist:annex"/>
				</xsl:attribute>
			</xsl:if>
		</item>
	</xsl:template>

	<xsl:template match="nist:references" mode="contents">
		<item level="" id="{@id}" display="false" type="References">
			<xsl:if test="ancestor::nist:annex">
				<xsl:attribute name="section">
					<xsl:value-of select="$annexprefix"/><xsl:number format="A" count="nist:annex"/>
				</xsl:attribute>
			</xsl:if>
		</item>
	</xsl:template>

	<!-- ============================= -->
	<!-- ============================= -->



	<!-- ============================= -->
	<!-- Authority -->
	<!-- ============================= -->
	<xsl:template match="/nist:nist-standard/nist:boilerplate/nist:legal-statement/nist:clause">
		<fo:block font-size="11pt">
			<xsl:variable name="num"><xsl:number/></xsl:variable>
			<xsl:choose>
				<xsl:when test="$num = 1">
					<xsl:apply-templates>
						<xsl:with-param name="margin">12pt</xsl:with-param>
					</xsl:apply-templates>
				</xsl:when>
				<xsl:when test="$num = 2">
					<xsl:attribute name="font-family">Arial</xsl:attribute>
					<xsl:apply-templates>
						<xsl:with-param name="margin">12pt</xsl:with-param>
					</xsl:apply-templates>
				</xsl:when>
				<xsl:when test="$num = 3">
					<!-- <xsl:attribute name="margin-top">6pt</xsl:attribute>
					<xsl:attribute name="space-after">6pt</xsl:attribute> -->
					<fo:block-container border="1pt solid black" background-color="lightgray" padding="2mm">
						<xsl:apply-templates>
						<xsl:with-param name="margin">6pt</xsl:with-param>
					</xsl:apply-templates>
					</fo:block-container>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates />
				</xsl:otherwise>
			</xsl:choose>
		</fo:block>
	</xsl:template>

	<xsl:template match="/nist:nist-standard/nist:boilerplate/nist:feedback-statement/nist:clause">
		<fo:block font-family="Arial" font-size="11pt" space-before="6pt">
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
		<fo:block-container border="1pt solid black" margin-left="-2mm" margin-right="-2mm" background-color="rgb(222,222,222)">
			<fo:block margin-left="8mm" margin-right="8mm" padding-top="6mm" padding-bottom="7mm">
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
		<xsl:variable name="num"><xsl:number/></xsl:variable>
		<fo:block>
			<xsl:if test="$num &lt; count(ancestor::nist:admonition//nist:p)">
				<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>

	<!-- ============================= -->
	<!-- ============================= -->


	<!-- ============================= -->
	<!-- Bibliography -->
	<!-- ============================= -->

	<!-- Example: [ITU-T A.23]	ITU-T A.23, Recommendation ITU-T A.23, Annex A (2014), Guide for ITU-T and ISO/IEC JTC 1 cooperation. -->
	<xsl:template match="nist:bibitem">
		<fo:block  id="{@id}" margin-top="6pt" margin-left="14mm" text-indent="-14mm">
			<fo:inline padding-right="5mm">[<xsl:value-of select="nist:docidentifier"/>]</fo:inline><xsl:value-of select="nist:docidentifier"/>
				<xsl:if test="nist:title">
				<fo:inline font-style="italic">
						<xsl:text>, </xsl:text>
						<xsl:choose>
							<xsl:when test="nist:title[@type = 'main' and @language = 'en']">
								<xsl:value-of select="nist:title[@type = 'main' and @language = 'en']"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="nist:title"/>
							</xsl:otherwise>
						</xsl:choose>
					</fo:inline>
				</xsl:if>
				<xsl:apply-templates select="nist:formattedref"/>
			</fo:block>
	</xsl:template>
	<xsl:template match="nist:bibitem/nist:docidentifier"/>

	<xsl:template match="nist:bibitem/nist:title"/>

	<xsl:template match="nist:formattedref">
		<xsl:text>, </xsl:text><xsl:apply-templates />
	</xsl:template>


	<!-- ============================= -->
	<!-- ============================= -->

	<xsl:variable name="thinspace" select="'&#x2009;'"/>
	<xsl:variable name="nonbreakhyphen" select="'&#x2011;'"/>
	
	<xsl:template match="text()" priority="1">
		<xsl:value-of select="translate(., concat($thinspace, $nonbreakhyphen), ' -')"/>
	</xsl:template>

	<xsl:template match="*[local-name()='td']//text() | *[local-name()='th']//text()" priority="2">
		<xsl:variable name="content">
			<xsl:call-template name="add-zero-spaces"/>
		</xsl:variable>
		<xsl:value-of select="translate($content, concat($thinspace, $nonbreakhyphen), ' -')"/>
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
				<xsl:when test="$level = 2">11pt</xsl:when>
				<xsl:when test="$level &gt;= 3">11pt</xsl:when>
				<xsl:otherwise>11pt</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="space">
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
				<fo:block id="{$id}" font-family="Arial" font-size="11pt" font-weight="bold" text-align="center" margin-bottom="12pt">
					<xsl:apply-templates />
				</fo:block>
			</xsl:when>
			<xsl:when test="ancestor::nist:executivesummary">
				<fo:block-container color="white" background-color="black" margin-bottom="12pt" margin-left="-2mm" margin-right="-2mm">
					<fo:block id="{$id}" font-family="Arial" font-size="12pt" font-weight="bold" text-align="left" margin-left="4mm" padding-top="1mm">
						<xsl:apply-templates />
					</fo:block>
				</fo:block-container>
			</xsl:when>
			<xsl:when test="ancestor::nist:preface">
				<fo:block id="{$id}" font-family="Arial" font-size="12pt" font-weight="bold" text-align="center" space-before="12pt" margin-bottom="12pt">
					<xsl:apply-templates />
				</fo:block>
			</xsl:when>
			<xsl:when test="$parent-name = 'references'"> <!--  and $references_num_current != 1 -->
				<fo:block id="{$id}" font-family="Arial" font-size="12pt" font-weight="bold" text-align="center" margin-bottom="18pt">
					<xsl:apply-templates />
				</fo:block>
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
				<fo:block-container color="white" background-color="black" margin-bottom="12pt" margin-left="-2mm" margin-right="-2mm" keep-with-next="always">
					<fo:block id="{$id}" font-family="Arial" font-size="{$font-size}" font-weight="bold" text-align="left" margin-left="4mm" padding-top="1mm" keep-with-next="always">
						<xsl:choose>
							<xsl:when test="$parent-name != 'annex'">
								<fo:inline padding-right="5mm"><xsl:value-of select="$section"/>.</fo:inline>
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
				<fo:block id="{$id}" font-family="Arial" font-size="{$font-size}" font-weight="bold" text-align="left" space-before="{$space}" space-after="{$space}" keep-with-next="always">
						<fo:inline><xsl:value-of select="$section"/>. </fo:inline>
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
		<!-- <xsl:if test="following-sibling::itu:table">
			<fo:block space-after="18pt">&#xA0;</fo:block>
		</xsl:if> -->
	</xsl:template>

	<xsl:template match="nist:definition2/nist:p"/>
	<xsl:template match="nist:definition2/nist:formula"/>

	<xsl:template match="nist:definition2/nist:p" mode="process"> <!--   -->
		<xsl:choose>
			<xsl:when test="position() = 1">
				<fo:inline>
					<xsl:apply-templates />
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<fo:block margin-top="6pt" text-align="justify">
					<xsl:apply-templates/>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="nist:p/nist:fn[not(ancestor::nist:table)] | nist:title/nist:fn | nist:table/nist:name/nist:fn" priority="2">
		<fo:footnote>
			<xsl:variable name="number">
				<xsl:number level="any" count="nist:p/nist:fn[not(ancestor::nist:table)] | nist:title/nist:fn | nist:table/nist:name/nist:fn"/>
			</xsl:variable>
			<fo:inline font-size="60%" keep-with-previous.within-line="always" vertical-align="super">
				<fo:basic-link internal-destination="footnote_{@reference}_{$number}" fox:alt-text="footnote {@reference} {$number}">
					<!-- <xsl:value-of select="@reference"/> -->
					<xsl:value-of select="$number + count(//nist:bibitem/nist:note)"/>
				</fo:basic-link>
			</fo:inline>
			<fo:footnote-body>
				<fo:block font-size="10pt" font-family="Times New Roman" font-style="normal" font-weight="normal" text-align="justify" margin-bottom="12pt" start-indent="0">
					<fo:inline id="footnote_{@reference}_{$number}" font-size="75%" keep-with-next.within-line="always" vertical-align="super"> <!-- alignment-baseline="hanging" -->
						<xsl:value-of select="$number + count(//nist:bibitem/nist:note)"/>
					</fo:inline>
					<xsl:for-each select="nist:p">
						<xsl:apply-templates />
					</xsl:for-each>
				</fo:block>
			</fo:footnote-body>
		</fo:footnote>
	</xsl:template>


	<xsl:template match="*[local-name()='tt']" priority="2">
		<xsl:variable name="element-name">
			<xsl:choose>
				<xsl:when test="normalize-space(ancestor::nist:p[1]//text()[not(parent::nist:tt)]) != ''">fo:inline</xsl:when>
				<xsl:when test="ancestor::nist:title">fo:inline</xsl:when>
				<xsl:otherwise>fo:block</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:element name="{$element-name}">
			<xsl:attribute name="font-family">Courier</xsl:attribute>
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:if test="not(ancestor::nist:td)">
				<xsl:attribute name="text-align">center</xsl:attribute>
			</xsl:if>
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
			<fo:block font-weight="bold" text-align="center" space-before="6pt" margin-bottom="6pt" keep-with-previous="always">
				<xsl:if test="nist:dl">
					<xsl:attribute name="space-before">12pt</xsl:attribute>
				</xsl:if>
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




	<!-- itu:figure/itu:image -->
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
					<xsl:variable name="date">
						<xsl:choose>
							<xsl:when test="nist:date[@type='issued']">
								<xsl:call-template name="formatDate">
									<xsl:with-param name="date" select="nist:date[@type='issued']/nist:on"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="formatDate">
									<xsl:with-param name="date" select="nist:date/nist:on"/>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
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
		<xsl:param name="margin"/>
		<fo:list-block>
			<xsl:attribute name="space-after">
				<xsl:choose>
					<xsl:when test="$margin != ''"><xsl:value-of select="$margin"/></xsl:when>
					<xsl:otherwise>12pt</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
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
				<fo:block display-align="center">
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
								<xsl:when test="../@type = 'roman'">
									<xsl:number format="i)"/>
								</xsl:when>
								<xsl:when test="../@type = 'alphabet_upper'">
									<xsl:number format="A)"/>
								</xsl:when>
								<xsl:when test="ancestor::*[nist:annex]">
									<!-- <xsl:variable name="level">
										<xsl:number level="multiple" count="itu:ol"/>
									</xsl:variable> -->
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
		<fo:block> <!-- margin-bottom="6pt" -->
			<xsl:if test="$num &gt;= 2">
				<xsl:attribute name="font-size">11pt</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>

	<xsl:template match="nist:link" priority="2">
		<fo:inline color="blue">
			<xsl:choose>
				<xsl:when test="ancestor::nist:annex">
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="local-name(..) = 'formattedref' or ancestor::nist:preface">
						<xsl:attribute name="font-family">Arial</xsl:attribute>
						<xsl:attribute name="font-size">8pt</xsl:attribute>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:call-template name="link"/>
		</fo:inline>
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
		<fo:block id="{@id}" margin-bottom="12pt"> <!-- margin-top="6pt"   text-align="center" -->
			<fo:table table-layout="fixed" width="100%">
				<fo:table-column column-width="95%"/>
				<fo:table-column column-width="5%"/>
				<fo:table-body>
					<fo:table-row>
						<fo:table-cell>
							<fo:block text-align="left" margin-left="7mm">
								<!-- <xsl:if test="ancestor::nist:annex">
									<xsl:attribute name="text-align">left</xsl:attribute>
									<xsl:attribute name="margin-left">7mm</xsl:attribute>
								</xsl:if> -->
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

	<xsl:template match="mathml:math" priority="2">
		<fo:inline font-family="STIX2Math">
			<xsl:if test="ancestor::nist:table">
				<xsl:attribute name="font-size">10pt</xsl:attribute>
			</xsl:if>
			<fo:instream-foreign-object fox:alt-text="Math">
				<xsl:copy-of select="."/>
			</fo:instream-foreign-object>
		</fo:inline>
	</xsl:template>

	<xsl:template match="nist:xref">
		<xsl:param name="sectionNum"/>

		<xsl:variable name="section" select="xalan:nodeset($contents)//item[@id = current()/@target]/@section"/>

		<fo:basic-link internal-destination="{@target}" text-decoration="underline" color="blue" fox:alt-text="{$section}">
			<xsl:variable name="type" select="xalan:nodeset($contents)//item[@id = current()/@target]/@type"/>
			<xsl:variable name="parent" select="xalan:nodeset($contents)//item[@id = current()/@target]/@parent"/>
			<xsl:choose>
				<xsl:when test="$type = 'clause' and $parent = 'annex'"><xsl:value-of select="$annexprefix"/></xsl:when>
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
		<fo:block id="{@id}" font-size="10pt" font-weight="bold" margin-top="12pt" margin-bottom="12pt">EXAMPLE</fo:block>
		<fo:block font-size="10pt" margin-top="12pt" margin-bottom="12pt" margin-left="25.4mm" margin-right="12.7mm">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	<xsl:template match="nist:example/nist:p">
		<!-- <xsl:variable name="num"><xsl:number/></xsl:variable> -->
		<fo:block> <!-- margin-bottom="12pt" -->
			<!-- <xsl:if test="$num = 1">
				<xsl:attribute name="margin-left">5mm</xsl:attribute>
			</xsl:if> -->
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
			<xsl:text>[</xsl:text><xsl:value-of select="@citeas" disable-output-escaping="yes"/><xsl:text>]</xsl:text>
			
			<xsl:apply-templates select="nist:localityStack"/>
			
		</fo:basic-link>
		<!-- </fo:inline> -->
	</xsl:template>

	<xsl:template match="nist:locality">
		<xsl:choose>
			<xsl:when test="@type = 'section'">Section </xsl:when>
			<xsl:when test="@type = 'clause'">Clause </xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
		<xsl:text> </xsl:text><xsl:value-of select="nist:referenceFrom"/>
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

	<xsl:template match="nist:dd//nist:stem[count(ancestor::nist:dd/nist:p) = 1 and normalize-space(ancestor::nist:dd/nist:p/text()) = '']">
		<fo:block text-align="center">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="nist:references">
		<fo:block>
			<xsl:if test="not(nist:title)">
				<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
			</xsl:if>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>

	<xsl:template match="nist:dl[@type = 'glossary']" priority="2">
		<xsl:apply-templates />
	</xsl:template>
	
	<xsl:template match="nist:dt[../@type = 'glossary']"  priority="2">
		<fo:block margin-bottom="12pt">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="nist:dd[../@type = 'glossary']"  priority="2">
		<fo:block margin-bottom="12pt" margin-left="12.7mm">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template name="insertHeaderFooter">
		<xsl:call-template name="insertHeader"/>
		<xsl:call-template name="insertFooter"/>
	</xsl:template>
	
	<xsl:template name="insertHeader">
		<fo:static-content flow-name="header" font-family="Arial" font-size="9pt">
			<fo:block-container height="1in" display-align="before">
				<!--Example:
				NIST SP 800-116 Revision 1
				Guidelines for the Use of PIV Credentials in Facility Access
				Page number -->
				<fo:block padding-top="0.5in">
				<fo:table table-layout="fixed" width="169mm">
					<fo:table-column column-width="proportional-column-width(1)"/>
					<fo:table-column column-width="proportional-column-width(3)"/>
					<fo:table-body>
						<fo:table-row>
							<fo:table-cell>
								<fo:block>
									<xsl:value-of select="/nist:nist-standard/nist:bibdata/nist:docidentifier[@type = 'NIST']"/>
								</fo:block>
							</fo:table-cell>
							<fo:table-cell text-align="right">
								<fo:block>
									<xsl:value-of select="$title"/>
									<!-- SCAP Version 1.3  -->
									<xsl:if test="$sub-title != ''">
										<xsl:value-of select="$linebreak"/>
										<xsl:value-of select="$sub-title"/>
									</xsl:if>
								</fo:block>
							</fo:table-cell>
						</fo:table-row>
					</fo:table-body>
				</fo:table>
				</fo:block>
				<!-- <fo:block text-align-last="justify" padding-top="0.5in" margin-right="-4mm">
					<xsl:value-of select="/nist:nist-standard/nist:bibdata/nist:docidentifier[@type = 'NIST']"/>
					<fo:inline keep-together.within-line="always">
						<fo:leader leader-pattern="space"/>
						<xsl:value-of select="$title"/>
					</fo:inline>
					<xsl:value-of select="$linebreak"/>
				</fo:block> -->
			</fo:block-container>
		</fo:static-content>
	</xsl:template>
	
	<xsl:template name="insertFooter">
		<fo:static-content flow-name="footer" font-family="Times New Roman" font-size="10pt">
			<fo:block-container height="1in" display-align="after">
				<fo:block text-align="right" padding-bottom="0.5in" margin-right="-4mm"><fo:page-number/></fo:block>
			</fo:block-container>
		</fo:static-content>
	</xsl:template>

	<xsl:template name="insertHeaderFooterAnnex">
		<xsl:call-template name="insertHeader"/>
		<xsl:call-template name="insertFooterAnnex"/>
	</xsl:template>
	
	<xsl:template name="insertFooterAnnex">
		<fo:static-content flow-name="footer-annex" font-family="Times New Roman" font-size="10pt">
			<fo:block-container height="1in" display-align="after">
				<fo:block padding-bottom="0.5in">
					<fo:table table-layout="fixed" width="169mm">
						<fo:table-column column-width="proportional-column-width(1)"/>
						<fo:table-column column-width="proportional-column-width(1)"/>
						<fo:table-body>
							<fo:table-row>
								<fo:table-cell>
									<fo:block>
										<xsl:text>APPENDIX </xsl:text><fo:retrieve-marker retrieve-class-name="annex_number"/>
									</fo:block>
								</fo:table-cell>
								<fo:table-cell text-align="right">
									<fo:block margin-right="-4mm">
										<xsl:text>PAGE </xsl:text>
										<fo:retrieve-marker retrieve-class-name="annex_number"/>
										<xsl:text>-</xsl:text>
										<fo:page-number/>
									</fo:block>
								</fo:table-cell>
							</fo:table-row>
						</fo:table-body>
					</fo:table>
				</fo:block>
			</fo:block-container>
		</fo:static-content>
	</xsl:template>
	
	<xsl:variable name="Image-NIST-Logo">
		<xsl:text>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</xsl:text>
	</xsl:variable>

	<xsl:variable name="Image-Dep-Commerce-Logo">
		<xsl:text>
			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
			gaA30D8BBgDycm8MNnf/WgAAAABJRU5ErkJggg==
		</xsl:text>
	</xsl:variable>

	<!-- convert YYYY-MM-DD to (Month YYYY) -->
	<xsl:template name="formatDate">
		<xsl:param name="date"/>
		<xsl:param name="format" select="'short'"/>
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
		<xsl:variable name="result">
			<xsl:choose>
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
							<!-- z<xsl:value-of select="$sectionNum"/>z -->
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="ancestor::nist:annex[@obligation = 'informative']">
					<xsl:choose>
						<xsl:when test="$level = 1">
							<xsl:value-of select="$annexprefix"/>
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
							<xsl:value-of select="$annexprefix"/>
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

	<xsl:template name="number-to-words-short">
		<xsl:param name="number" />
		<xsl:value-of select="$number"/>
		<fo:inline font-size="60%" keep-with-previous.within-line="always" vertical-align="super">
		<xsl:choose>
			<xsl:when test="$number = 1">st</xsl:when>
			<xsl:when test="$number = 2">nd</xsl:when>
			<xsl:when test="$number = 3">rd</xsl:when>
			<xsl:otherwise>th</xsl:otherwise>
		</xsl:choose>
		</fo:inline>
		<fo:inline>&#xA0;</fo:inline>
	</xsl:template>

	<xsl:template name="number-to-words">
		<xsl:param name="number" />
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
	</xsl:template>

	<xsl:template name="addLetterSpacing">
		<xsl:param name="text"/>
		<xsl:if test="string-length($text) &gt; 0">
			<xsl:variable name="char" select="substring($text, 1, 1)"/>
			<xsl:value-of select="$char"/><fo:inline font-size="15pt" padding-right="2mm"><xsl:value-of select="'&#xA0;'"/></fo:inline>
			<xsl:call-template name="addLetterSpacing">
				<xsl:with-param name="text" select="substring($text, 2)"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>