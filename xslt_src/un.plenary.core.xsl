<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
											xmlns:fo="http://www.w3.org/1999/XSL/Format" 
											xmlns:un="https://www.metanorma.org/ns/un" 
											xmlns:mathml="http://www.w3.org/1998/Math/MathML" 
											xmlns:xalan="http://xml.apache.org/xalan" 
											xmlns:fox="http://xmlgraphics.apache.org/fop/extensions" 
											xmlns:redirect="http://xml.apache.org/xalan/redirect"
											xmlns:barcode="http://barcode4j.krysalis.org/ns" 
											xmlns:java="http://xml.apache.org/xalan/java" 
											exclude-result-prefixes="java redirect"
											extension-element-prefixes="redirect"
											version="1.0">

	<xsl:output version="1.0" method="xml" encoding="UTF-8" indent="no"/>

	<xsl:key name="kfn" match="*[local-name() = 'fn'][not(ancestor::*[(local-name() = 'table' or local-name() = 'figure' or local-name() = 'localized-strings')] and not(ancestor::*[local-name() = 'name'])) and not(ancestor::*[local-name() = 'bibdata'] and ancestor::*[local-name() = 'abstract'])]" use="@reference"/>
	
	<xsl:include href="./common.xsl"/>
	
	<xsl:variable name="namespace">unece</xsl:variable>
	
	<xsl:variable name="debug">false</xsl:variable>
	
	<xsl:variable name="contents_">
		<contents>			
			<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='foreword']" mode="contents"/>
			<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='introduction']" mode="contents"/>
			<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name() != 'abstract' and local-name() != 'foreword' and local-name() != 'introduction' and local-name() != 'acknowledgements' and local-name() != 'note' and local-name() != 'admonition']" mode="contents"/>
			<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='acknowledgements']" mode="contents"/>
			
			<xsl:apply-templates select="/un:un-standard/un:sections/*" mode="contents"/>
			<xsl:apply-templates select="/un:un-standard/un:annex" mode="contents"/>
			<xsl:apply-templates select="/un:un-standard/un:bibliography/un:references" mode="contents"/>
			
			<xsl:call-template name="processTablesFigures_Contents"/>
		</contents>
	</xsl:variable>
	<xsl:variable name="contents" select="xalan:nodeset($contents_)"/>

	<xsl:variable name="title" select="/un:un-standard/un:bibdata/un:title[@language = 'en' and @type = 'main']"/>

	<xsl:variable name="id" select="/un:un-standard/un:bibdata/un:ext/un:session/un:id"/>
	
	<xsl:template match="/">
		<xsl:call-template name="namespaceCheck"/>
		<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format" xml:lang="{$lang}">
			<xsl:variable name="root-style">
				<root-style xsl:use-attribute-sets="root-style"/>
			</xsl:variable>
			<xsl:call-template name="insertRootStyle">
				<xsl:with-param name="root-style" select="$root-style"/>
			</xsl:call-template>
			<fo:layout-master-set>
				<!-- Cover page -->
				<fo:simple-page-master master-name="cover-page" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
					<fo:region-body margin-top="17.5mm" margin-bottom="10mm" margin-left="20mm" margin-right="20mm"/>
					<fo:region-before extent="17.5mm"/>
					<fo:region-after extent="10mm"/>
					<fo:region-start extent="20mm"/>
					<fo:region-end extent="20mm"/>
				</fo:simple-page-master>
				
				<!-- Document odd pages -->
				<fo:simple-page-master master-name="odd" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
					<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
					<fo:region-before region-name="header-odd" extent="26mm"/> 
					<fo:region-after region-name="footer-odd" extent="{$marginBottom}mm"/>
					<fo:region-start region-name="left-region" extent="{$marginLeftRight1}mm"/>
					<fo:region-end region-name="right-region" extent="{$marginLeftRight2}mm"/>
				</fo:simple-page-master>
				<fo:simple-page-master master-name="odd-landscape" page-width="{$pageHeight}mm" page-height="{$pageWidth}mm">
					<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
					<fo:region-before region-name="header-odd" extent="26mm"/> 
					<fo:region-after region-name="footer-odd" extent="{$marginBottom}mm"/>
					<fo:region-start region-name="left-region" extent="{$marginLeftRight1}mm"/>
					<fo:region-end region-name="right-region" extent="{$marginLeftRight2}mm"/>
				</fo:simple-page-master>
				<!-- Document even pages -->
				<fo:simple-page-master master-name="even" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
					<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight2}mm" margin-right="{$marginLeftRight1}mm"/>
					<fo:region-before region-name="header-even" extent="26mm"/>
					<fo:region-after region-name="footer-even" extent="{$marginBottom}mm"/>
					<fo:region-start region-name="left-region" extent="{$marginLeftRight2}mm"/>
					<fo:region-end region-name="right-region" extent="{$marginLeftRight1}mm"/>
				</fo:simple-page-master>
				<fo:simple-page-master master-name="even-landscape" page-width="{$pageHeight}mm" page-height="{$pageWidth}mm">
					<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight2}mm" margin-right="{$marginLeftRight1}mm"/>
					<fo:region-before region-name="header-even" extent="26mm"/>
					<fo:region-after region-name="footer-even" extent="{$marginBottom}mm"/>
					<fo:region-start region-name="left-region" extent="{$marginLeftRight2}mm"/>
					<fo:region-end region-name="right-region" extent="{$marginLeftRight1}mm"/>
				</fo:simple-page-master>
				<fo:page-sequence-master master-name="document">
					<fo:repeatable-page-master-alternatives>
						<fo:conditional-page-master-reference odd-or-even="even" master-reference="even"/>
						<fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd"/>
					</fo:repeatable-page-master-alternatives>
				</fo:page-sequence-master>
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
			
			<!-- Cover Page -->
			<fo:page-sequence master-reference="cover-page" force-page-count="no-force">				
				<fo:flow flow-name="xsl-region-body">
					<fo:block-container border-bottom="0.5pt solid black" margin-bottom="6pt">
						<fo:block text-align-last="justify">
							<fo:inline padding-right="22mm">&#x200a;</fo:inline>
							<fo:inline font-size="14pt" baseline-shift="15%"><xsl:value-of select="/un:un-standard/un:bibdata/un:contributor/un:organization/un:name"/></fo:inline>
							<fo:inline keep-together.within-line="always">
								<fo:leader leader-pattern="space"/>
								<fo:inline font-size="20pt"><xsl:value-of select="substring-before($id, '/')"/></fo:inline>
								<fo:inline font-size="10pt">/<xsl:value-of select="substring-after($id, '/')"/></fo:inline>
							</fo:inline>
						</fo:block>
					</fo:block-container>
					<fo:block-container height="48mm">
						<fo:block>
							<fo:table table-layout="fixed" width="100%">
								<fo:table-column column-width="22mm"/>
								<fo:table-column column-width="98mm"/>
								<fo:table-column column-width="50mm"/>
								<fo:table-body>
									<fo:table-row>
										<fo:table-cell padding-left="0.5mm">
											<fo:block>
												<!-- <fo:external-graphic src="{concat('data:image/png;base64,', normalize-space($Image-Logo))}" width="28mm" content-height="scale-to-fit" scaling="uniform" fox:alt-text="Image Front"/> -->
												<fo:instream-foreign-object content-width="19.5mm" fox:alt-text="Image Logo UN">
													<xsl:copy-of select="$Image-Logo-SVG"/>
												</fo:instream-foreign-object>
											</fo:block>
										</fo:table-cell>
										<fo:table-cell>
											<fo:block font-size="20pt" font-weight="bold">Economic and Social Council</fo:block>
										</fo:table-cell>
										<fo:table-cell font-size="10pt">
											<fo:block margin-top="8pt">
												<xsl:text>Distr.: </xsl:text><xsl:value-of select="/un:un-standard/un:bibdata/un:ext/un:distribution"/>
											</fo:block>
											<fo:block margin-bottom="12pt">
												<xsl:call-template name="convertDate">
													<xsl:with-param name="date" select="/un:un-standard/un:bibdata/un:version/un:revision-date"/>
													<xsl:with-param name="format">ddMMyyyy</xsl:with-param>
												</xsl:call-template>
											</fo:block>
											<fo:block>
												<xsl:text>Original: </xsl:text>
												<xsl:call-template name="getLanguage">
													<xsl:with-param name="lang" select="/un:un-standard/un:bibdata/un:language"/>
												</xsl:call-template>
											</fo:block>
										</fo:table-cell>
									</fo:table-row>
								</fo:table-body>
							</fo:table>
						</fo:block>
					</fo:block-container>
					<!-- <fo:block margin-bottom="24pt">&#xA0;</fo:block> -->
					<fo:block-container font-weight="bold" border-top="1.5pt solid black">
						<fo:block font-size="14pt" padding-top="0.5mm" margin-top="6pt" margin-bottom="6pt">Economic Commission for Europe</fo:block>
						<fo:block font-size="12pt" margin-bottom="6pt">UNECE Executive Committee</fo:block>
						<fo:block font-size="12pt" margin-bottom="6pt"><xsl:value-of select="/un:un-standard/un:bibdata/un:ext/un:editorialgroup/un:committee"/></fo:block>
						<fo:block font-size="10pt">
							<fo:block font-weight="bold">
								<!-- Example: 24 -> Twenty-fourth session -->
								<xsl:call-template name="number-to-words">
									<xsl:with-param name="number" select="/un:un-standard/un:bibdata/un:ext/un:session/un:number"/>
									<xsl:with-param name="first" select="'true'"/>
								</xsl:call-template>
								<xsl:text>session</xsl:text>
							</fo:block>
							<fo:block font-weight="normal">
								<xsl:value-of select="/un:un-standard/un:bibdata/un:ext/un:session/un:date"/>
							</fo:block>
							<fo:block font-weight="normal">
								<xsl:text>Item 1 of the </xsl:text><xsl:value-of select="java:toLowerCase(java:java.lang.String.new(/un:un-standard/un:sections/un:clause[1]/un:title))"/>
							</fo:block>
							<fo:block>
								<xsl:value-of select="translate(/un:un-standard/un:sections/un:clause[1]/un:ol[1]/un:li[1]/un:p[1], '.', '')"/>
							</fo:block>
							<fo:block role="H1"><xsl:value-of select="$title"/></fo:block>
						</fo:block>
					</fo:block-container>
					
					<!-- <xsl:apply-templates select="/un:un-standard/un:preface/un:foreword"/> -->

					<fo:block-container font-weight="bold" margin-left="20mm" margin-top="10pt">
						<fo:block margin-left="-20mm">
							<fo:block font-size="17pt" margin-bottom="16pt">
								<xsl:value-of select="$title"/>
								
								<xsl:for-each select="/un:un-standard/un:bibdata/un:note[@type = 'title-footnote']">
									<xsl:variable name="number" select="position()"/>									
									<fo:inline font-size="14pt" baseline-shift="15%"  font-weight="normal">
										<xsl:if test="$number = 1">
											<xsl:text> </xsl:text>
										</xsl:if>
										<fo:basic-link internal-destination="title-footnote_{$number}" fox:alt-text="title footnote">
											<xsl:call-template name="repeat">
												<xsl:with-param name="char" select="'*'"/>
												<xsl:with-param name="count" select="$number"/>
											</xsl:call-template>
										</fo:basic-link>
										<xsl:if test="position() != last()"><fo:inline  baseline-shift="20%">,</fo:inline></xsl:if>
									</fo:inline>
								</xsl:for-each>
								
								<xsl:for-each select="/un:un-standard/un:bibdata/un:note[@type = 'title-footnote']">
									<xsl:variable name="number" select="position()"/>
									<fo:block id="title-footnote_{$number}" font-size="14pt" font-weight="normal">
										<xsl:if test="$number = 1">
											<xsl:attribute name="margin-top">12pt</xsl:attribute>
										</xsl:if>
										<xsl:call-template name="repeat">
											<xsl:with-param name="char" select="'*'"/>
											<xsl:with-param name="count" select="$number"/>
										</xsl:call-template>
										<xsl:text> </xsl:text>
										<xsl:apply-templates />
									</fo:block>
								</xsl:for-each>
								
							</fo:block>
							
							<fo:block font-size="14pt" margin-bottom="16pt">
								<xsl:value-of select="/un:un-standard/un:bibdata/un:title[@language = 'en' and @type = 'subtitle']"/>
							</fo:block>
							<xsl:if test="/un:un-standard/un:bibdata/un:ext/un:session/un:collaborator">
								<fo:block font-size="14pt"  margin-bottom="22pt">
									<xsl:text>Developed in Collaboration with the </xsl:text><xsl:value-of select="/un:un-standard/un:bibdata/un:ext/un:session/un:collaborator"/>
								</fo:block>
							</xsl:if>
						</fo:block>
					</fo:block-container>
					
					<xsl:apply-templates select="/un:un-standard/un:preface/un:abstract"/>
					
					<xsl:variable name="charsToRemove" select="concat($upper, $lower, '.()~!@#$%^*-+:')"/>
					<xsl:variable name="code" select="translate(/un:un-standard/un:bibdata/un:docidentifier, $charsToRemove,'')"/>
					
					<fo:block-container absolute-position="fixed" left="20mm" top="258mm" width="30mm" text-align="center" id="__internal_layout__barcode_{generate-id()}">
						<fo:block font-size="10pt" text-align="left">
							<xsl:value-of select="/un:un-standard/un:bibdata/un:docidentifier"/>
						</fo:block>
						
						<fo:block padding-top="1mm">
							<xsl:if test="normalize-space($code) != ''">
								<fo:instream-foreign-object fox:alt-text="Barcode">
									<barcode:barcode
												xmlns:barcode="http://barcode4j.krysalis.org/ns"
												message="{$code}">
										<barcode:code39>
											<barcode:height>8.5mm</barcode:height>
											<barcode:module-width>0.24mm</barcode:module-width>
											<barcode:human-readable>
												<barcode:placement>none</barcode:placement>
												<!--<barcode:pattern>* _ _ _ _ _ _ _ _ _ *</barcode:pattern>
												<barcode:font-name>Arial</barcode:font-name>
												<barcode:font-size>9.7pt</barcode:font-size> -->
											</barcode:human-readable>
										</barcode:code39>
									</barcode:barcode>
								</fo:instream-foreign-object>
							</xsl:if>
						</fo:block>
						<fo:block padding-top="-0.8mm" text-align="left" font-family="Arial" font-size="8pt" letter-spacing="1.8mm">
							<xsl:value-of select="concat('*', $code, '*')"/>
						</fo:block>
					</fo:block-container>
					
					<fo:block-container absolute-position="fixed" left="143mm" top="262mm">
						<fo:block>
							<fo:external-graphic src="{concat('data:image/png;base64,', normalize-space($Image-Recycle))}" width="26mm" content-height="scale-to-fit" scaling="uniform" fox:alt-text="Recycle"/>
						</fo:block>
					</fo:block-container>
					<fo:block-container absolute-position="fixed" left="170mm" top="253mm">
						<fo:block>
							<xsl:if test="normalize-space(/un:un-standard/un:bibdata/un:ext/un:session/un:id) != ''">
								<fo:instream-foreign-object fox:alt-text="Barcode">
									<barcode:barcode
												xmlns:barcode="http://barcode4j.krysalis.org/ns"
												message="{concat('http://undocs.org/', /un:un-standard/un:bibdata/un:ext/un:session/un:id)}">
										<barcode:qr>
											<barcode:module-width>0.55mm</barcode:module-width>
											<barcode:ec-level>M</barcode:ec-level>
										</barcode:qr>
									</barcode:barcode>
								</fo:instream-foreign-object>
							</xsl:if>
						</fo:block>
					</fo:block-container>
					
				</fo:flow>
			</fo:page-sequence>
			<!-- End Cover Page -->
			
			<xsl:variable name="updated_xml">
				<xsl:call-template name="updateXML"/>
				<!-- <xsl:copy-of select="."/> -->
			</xsl:variable>
			
			<xsl:for-each select="xalan:nodeset($updated_xml)/*">
			
				<xsl:variable name="updated_xml_with_pages">
					<xsl:call-template name="processPrefaceAndMainSectionsUN_items"/>
				</xsl:variable>
			
				<xsl:for-each select="xalan:nodeset($updated_xml_with_pages)"> <!-- set context to preface -->
				
					<xsl:for-each select=".//*[local-name() = 'page_sequence'][normalize-space() != '' or .//image or .//svg]">
			
						<!-- Document Pages -->
						<fo:page-sequence master-reference="document" format="1" force-page-count="no-force" line-height="115%">
						
							<xsl:attribute name="master-reference">
								<xsl:text>document</xsl:text>
								<xsl:call-template name="getPageSequenceOrientation"/>
							</xsl:attribute>
							
							<xsl:if test="position() = 1">
								<xsl:attribute name="initial-page-number">2</xsl:attribute>
							</xsl:if>
						
							<fo:static-content flow-name="xsl-footnote-separator">
								<fo:block-container margin-left="-8mm">
									<fo:block margin-left="8mm">
										<fo:leader leader-pattern="rule" leader-length="20%"/>
									</fo:block>
								</fo:block-container>
							</fo:static-content>
							<xsl:call-template name="insertHeaderFooter"/>
							<fo:flow flow-name="xsl-region-body">
								
								<!-- <xsl:if test="$debug = 'true'">
									<redirect:write file="contents_{java:getTime(java:java.util.Date.new())}.xml">
										<xsl:copy-of select="$contents"/>
									</redirect:write>
								</xsl:if> -->					
								
								<!-- Preface Pages (except Abstract, that showed in Summary on cover page`) -->
								<!-- <xsl:if test="/un:un-standard/un:preface/*[not(local-name() = 'abstract' or local-name() = 'note' or local-name() = 'admonition' or (local-name() = 'clause' and @type = 'toc'))]">
									<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='foreword']" />
									<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='introduction']" />
									<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name() != 'abstract' and local-name() != 'foreword' and local-name() != 'introduction' and local-name() != 'acknowledgements' and local-name() != 'note' and local-name() != 'admonition' and
									not(local-name() = 'clause' and @type = 'toc')]" />
									<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='acknowledgements']" />
									<fo:block break-after="page"/>
								</xsl:if>
								
								<fo:block>
									<xsl:apply-templates select="/un:un-standard/un:sections/*"/>
									<xsl:apply-templates select="/un:un-standard/un:annex"/>
									<xsl:apply-templates select="/un:un-standard/un:bibliography/un:references"/>
								</fo:block> -->
								
								<xsl:apply-templates />
								
								<fo:block/> <!-- prevent empty fo:flow -->
								
								<xsl:if test="position() = last()">
									<fo:block-container margin-left="50mm" width="30mm" border-bottom="0.5pt solid black" margin-top="12pt" keep-with-previous="always">
										<fo:block>&#xA0;</fo:block>
									</fo:block-container>
								</xsl:if>
							</fo:flow>
						</fo:page-sequence>
						<!-- End Document Pages -->
					</xsl:for-each>
				</xsl:for-each>
			</xsl:for-each>
			
		</fo:root>
	</xsl:template> 


	<xsl:template name="processPrefaceAndMainSectionsUN_items">
		<xsl:variable name="updated_xml_step_move_pagebreak">
		
			<xsl:element name="{$root_element}" namespace="{$namespace_full}">
			
				<xsl:call-template name="copyCommonElements"/>
				
				<xsl:element name="page_sequence" namespace="{$namespace_full}">
					<xsl:element name="preface" namespace="{$namespace_full}"> <!-- save context element -->
						
						<!-- Preface Pages (except Abstract, that showed in Summary on cover page`) -->
						<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='foreword']" mode="update_xml_step_move_pagebreak"/>
						<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='introduction']" mode="update_xml_step_move_pagebreak"/>
						<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name() != 'abstract' and local-name() != 'foreword' and local-name() != 'introduction' and local-name() != 'acknowledgements' and local-name() != 'note' and local-name() != 'admonition' and
						not(local-name() = 'clause' and @type = 'toc')]" mode="update_xml_step_move_pagebreak"/>
						<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='acknowledgements']" mode="update_xml_step_move_pagebreak"/>
					
					</xsl:element> <!-- preface -->
				</xsl:element>  
				
				<xsl:element name="page_sequence" namespace="{$namespace_full}">
					<xsl:call-template name="insertMainSections"/>
				</xsl:element>
				
			</xsl:element>
		</xsl:variable>
		
		<xsl:variable name="updated_xml_step_move_pagebreak_filename" select="concat($output_path,'_preface_', java:getTime(java:java.util.Date.new()), '.xml')"/>
		
		<redirect:write file="{$updated_xml_step_move_pagebreak_filename}">
			<xsl:copy-of select="$updated_xml_step_move_pagebreak"/>
		</redirect:write>
		
		<xsl:copy-of select="document($updated_xml_step_move_pagebreak_filename)"/>
		
		<!-- TODO: instead of 
		<xsl:for-each select=".//*[local-name() = 'page_sequence'][normalize-space() != '' or .//image or .//svg]">
		in each template, add removing empty page_sequence here
		-->
		
		<xsl:if test="$debug = 'true'">
			<redirect:write file="page_sequence.xml">
				<xsl:copy-of select="$updated_xml_step_move_pagebreak"/>
			</redirect:write>
		</xsl:if>
		
		<xsl:call-template name="deleteFile">
			<xsl:with-param name="filepath" select="$updated_xml_step_move_pagebreak_filename"/>
		</xsl:call-template>
	</xsl:template> <!-- END: processPrefaceAndMainSectionsUN_items -->


	<!-- ============================= -->
	<!-- CONTENTS                                       -->
	<!-- ============================= -->

	<!-- element with title -->
	<xsl:template match="*[un:title]" mode="contents">
		<xsl:variable name="level">
			<xsl:call-template name="getLevel">
				<xsl:with-param name="depth" select="un:title/@depth"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="display">
			<xsl:choose>				
				<xsl:when test="$level &gt; $toc_level">false</xsl:when>
				<xsl:otherwise>true</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="skip">
			<xsl:choose>
				<xsl:when test="@type = 'toc'">true</xsl:when>
				<xsl:when test="ancestor-or-self::un:bibitem">true</xsl:when>
				<xsl:when test="ancestor-or-self::un:term">true</xsl:when>
				<xsl:when test="@inline-header = 'true'">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:if test="$skip = 'false'">		
		
			<xsl:variable name="section">
				<xsl:call-template name="getSection"/>
			</xsl:variable>
			
			<xsl:variable name="title">
				<xsl:call-template name="getName"/>
			</xsl:variable>
			
			<xsl:variable name="type">
				<xsl:value-of select="local-name()"/>
			</xsl:variable>
			
			<item id="{@id}" level="{$level}" section="{$section}" type="{$type}" display="{$display}">
				<title>
					<xsl:apply-templates select="xalan:nodeset($title)" mode="contents_item"/>
				</title>
				<xsl:apply-templates mode="contents" />
			</item>
		</xsl:if>	
		
	</xsl:template>
	<!-- ============================= -->
	<!-- ============================= -->

		
	<!-- ============================= -->
	<!-- PARAGRAPHS                                    -->
	<!-- ============================= -->	
	
	<xsl:template match="un:preface/un:abstract" priority="3">
		<fo:block>
			<fo:table table-layout="fixed" width="100%" border="0.5pt solid black">
				<fo:table-column column-width="19mm"/>
				<fo:table-column column-width="134mm"/>
				<fo:table-column column-width="17mm"/>
				<fo:table-body>
					<fo:table-row>
						<fo:table-cell padding-left="6mm" padding-top="2.5mm" number-columns-spanned="3">
							<fo:block font-size="12pt" font-style="italic" margin-bottom="6pt" role="H2">
								<xsl:apply-templates select="un:title/node()"/>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
					<fo:table-row>
						<fo:table-cell>
							<fo:block>&#xA0;</fo:block>
						</fo:table-cell>
						<fo:table-cell text-align="justify" padding-bottom="12pt" padding-right="3mm">
							<fo:block font-size="10pt" line-height="120%"><xsl:apply-templates select="node()[not(self::un:title)]"/></fo:block>
						</fo:table-cell>
						<fo:table-cell>
							<fo:block>&#xA0;</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</fo:table-body>
			</fo:table>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="un:abstract//un:p" priority="3">
		<fo:block margin-bottom="6pt">
			<xsl:attribute name="text-align">
				<xsl:choose>
					<xsl:when test="@align"><xsl:value-of select="@align"/></xsl:when>
					<xsl:otherwise>justify</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="un:preface//un:p" priority="2">
		<fo:block margin-bottom="12pt">
			<xsl:attribute name="text-align">
				<xsl:choose>
					<xsl:when test="@align"><xsl:value-of select="@align"/></xsl:when>
					<xsl:otherwise>left</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	
	<xsl:template match="un:clause[@inline-header = 'true']" priority="3">
		<fo:block-container margin-left="1mm">
			<fo:block-container margin-left="0mm">
				<fo:list-block provisional-distance-between-starts="9mm">				
					<xsl:call-template name="setId"/>
					<xsl:attribute name="text-align">
						<xsl:choose>
							<xsl:when test="child::*/@align"><xsl:value-of select="child::*/@align"/></xsl:when>
							<xsl:otherwise>justify</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<fo:list-item>
						<fo:list-item-label end-indent="label-end()">
							<fo:block>
								<xsl:apply-templates select="un:title" mode="inline-header"/>
							</fo:block>
						</fo:list-item-label>
						<fo:list-item-body text-indent="body-start()">
							<fo:block>
								<xsl:apply-templates />
							</fo:block>
						</fo:list-item-body>
					</fo:list-item>
				</fo:list-block>		
			</fo:block-container>
		</fo:block-container>
	</xsl:template>
	
	<xsl:template match="un:title" mode="inline-header">
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		<fo:inline role="H{$level}">
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>
	
	
	<xsl:template match="un:p[ancestor::un:table]">
		<fo:block>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="un:p" name="paragraph">
		<xsl:param name="split_keep-within-line"/>
		<fo:block margin-bottom="6pt" line-height="122%">
			<xsl:if test="following-sibling::*">
				<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			</xsl:if>
			
			<xsl:call-template name="setBlockAttributes">
				<xsl:with-param name="text_align_default">justify</xsl:with-param>
			</xsl:call-template>
			
			<xsl:apply-templates>
				<xsl:with-param name="split_keep-within-line" select="$split_keep-within-line"/>
			</xsl:apply-templates>
		</fo:block>
	</xsl:template>
	
	
	<xsl:template match="un:fn/un:p">
		<fo:block>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="un:ul | un:ol" mode="list" priority="2">
		<fo:block-container margin-left="8mm" text-indent="0mm">
			<xsl:call-template name="list"/>
		</fo:block-container>
	</xsl:template>
	
	
	<xsl:template match="un:li//un:p" >
		<fo:block margin-bottom="6pt" line-height="122%" text-align="justify">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="un:link" priority="2">
		<fo:inline>
			<xsl:if test="ancestor::un:fn and string-length(@target) &gt; 110">
				<xsl:attribute name="font-size">8pt</xsl:attribute>
			</xsl:if>
			<xsl:call-template name="link"/>
		</fo:inline>
	</xsl:template>
	
	
	<!-- ============================= -->	
	<!-- ============================= -->	
	

	
	
	<!-- ====== -->
	<!-- title      -->
	<!-- ====== -->
	
	<xsl:template match="un:preface//un:title" priority="3">	
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		<xsl:variable name="font-size">
			<xsl:choose>
				<xsl:when test="$level = 1">14pt</xsl:when>				
				<xsl:when test="$level = 2">12pt</xsl:when>
				<xsl:when test="$level = 3">10pt</xsl:when>
				<xsl:otherwise>11pt</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<fo:block font-size="{$font-size}" font-weight="bold" margin-top="3pt" margin-bottom="16pt" keep-with-next="always" role="H{$level}">
			<xsl:apply-templates />
			<xsl:apply-templates select="following-sibling::*[1][local-name() = 'variant-title'][@type = 'sub']" mode="subtitle"/>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="un:annex//un:title">
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		<xsl:variable name="font-size">
			<xsl:choose>				
				<xsl:when test="$level = 1">12pt</xsl:when>
				<xsl:when test="$level = 2">10pt</xsl:when>				
				<xsl:when test="$level = 3">10pt</xsl:when>
				<xsl:otherwise>11pt</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$level = 1">
				<fo:block font-size="{$font-size}" font-weight="bold" space-before="3pt" keep-with-next="always" role="H{$level}">					
					<fo:block margin-bottom="12pt">
						<xsl:apply-templates />
						<xsl:apply-templates select="following-sibling::*[1][local-name() = 'variant-title'][@type = 'sub']" mode="subtitle"/>
					</fo:block>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>			
				<fo:block font-size="{$font-size}" font-weight="bold" margin-left="1mm" space-before="3pt" margin-bottom="6pt" keep-with-next="always" role="H{$level}">
					<xsl:apply-templates />
					<xsl:apply-templates select="following-sibling::*[1][local-name() = 'variant-title'][@type = 'sub']" mode="subtitle"/>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="un:title[parent::un:clause[@inline-header = 'true']]" priority="3"/>
	
	<xsl:template match="un:title" name="title">

		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		
		<xsl:variable name="font-size">
			<xsl:choose>				
				<xsl:when test="$level = 1">14pt</xsl:when>
				<xsl:when test="$level = 2">12pt</xsl:when>
				<xsl:when test="$level = 3">10pt</xsl:when>
				<xsl:otherwise>11pt</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		
		<xsl:choose>			
			<xsl:when test="ancestor::un:sections and $level = 1">
				<fo:block-container margin-left="-16mm">
					<fo:block font-size="{$font-size}" font-weight="bold" margin-left="16mm" space-before="16pt" margin-bottom="13pt" keep-with-next="always" role="H{$level}">
						<fo:table table-layout="fixed" width="100%">
							<fo:table-column column-width="16mm"/>
							<fo:table-column column-width="130mm"/>
							<fo:table-body>
								<fo:table-row>
									<fo:table-cell>
										<xsl:variable name="section">						
											<xsl:for-each select="..">
												<xsl:call-template name="getSection"/>
											</xsl:for-each>
										</xsl:variable>
										<fo:block text-align="center">
											<xsl:value-of select="$section"/>
										</fo:block>
									</fo:table-cell>
									<fo:table-cell>
										<fo:block>
											<xsl:call-template name="extractTitle"/>
											<xsl:apply-templates select="following-sibling::*[1][local-name() = 'variant-title'][@type = 'sub']" mode="subtitle"/>
										</fo:block>
									</fo:table-cell>
								</fo:table-row>
							</fo:table-body>
						</fo:table>
					</fo:block>
				</fo:block-container>
			</xsl:when>
			<xsl:when test="ancestor::un:sections">
				<fo:block font-size="{$font-size}" font-weight="bold" space-before="16pt" margin-bottom="13pt" text-indent="-8mm" keep-with-next="always" role="H{$level}">
					<xsl:if test="$level = 2">
						<xsl:attribute name="margin-left">1mm</xsl:attribute>
						<xsl:attribute name="space-before">12pt</xsl:attribute>
						<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
					</xsl:if>
					<xsl:if test="$level = 3">
						<xsl:attribute name="space-before">12pt</xsl:attribute>
						<xsl:attribute name="margin-left">1mm</xsl:attribute>
						<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
					</xsl:if>
					<xsl:call-template name="insertTitleAsListItem">
						<xsl:with-param name="provisional-distance-between-starts" select="'8mm'"/>
					</xsl:call-template>
				</fo:block>
			</xsl:when>			
			<xsl:otherwise>
				<fo:block font-size="{$font-size}" font-weight="bold" text-align="left" keep-with-next="always" role="H{$level}">						
					<xsl:apply-templates />
					<xsl:apply-templates select="following-sibling::*[1][local-name() = 'variant-title'][@type = 'sub']" mode="subtitle"/>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- ====== -->
	<!-- ====== -->
	
	
	<!-- ============================ -->
	<!-- for further use -->
	<!-- ============================ -->


	<xsl:template match="un:figure" priority="2">
		<fo:block-container id="{@id}" xsl:use-attribute-sets="figure-block-style">
			<fo:block>
				<xsl:apply-templates select="node()[not(local-name() = 'name')]" />
			</fo:block>			
			<xsl:apply-templates select="un:name" />
			<!-- <xsl:call-template name="fn_display_figure"/> -->
			<xsl:for-each select="un:note">
				<xsl:call-template name="note"/>
			</xsl:for-each>
		</fo:block-container>
	</xsl:template>


	
	<xsl:template match="un:dl" priority="3">
		<fo:block-container margin-left="0mm">
			<xsl:if test="parent::*[local-name() = 'note']">
				<xsl:attribute name="margin-left">
					<xsl:choose>
						<xsl:when test="not(ancestor::*[local-name() = 'table'])"><xsl:value-of select="$note-body-indent"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="$note-body-indent-table"/></xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>				
			</xsl:if>
			<fo:block-container margin-left="0mm">
	
				<fo:block line-height="122%" margin-bottom="6pt" text-indent="0mm" text-align="justify">
					<xsl:apply-templates />
				</fo:block>
				
			</fo:block-container>	
		</fo:block-container>	
	</xsl:template>
	
	<xsl:template match="un:dt" priority="2">
		<fo:block margin-bottom="6pt">
			<xsl:apply-templates />
			<xsl:text> </xsl:text>
			<xsl:apply-templates select="following-sibling::un:dd[1]" mode="dd"/>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="un:dd"/>
	<xsl:template match="un:dd" mode="dd">
		<fo:inline><xsl:apply-templates /></fo:inline>
	</xsl:template>
	
	<xsl:template match="un:dd//un:p" priority="3">
		<fo:inline><xsl:apply-templates /></fo:inline>
	</xsl:template>
	<!-- ============================ -->
	<!-- ============================ -->	
	
	<xsl:template name="insertHeaderFooter">
		<fo:static-content flow-name="header-odd" role="artifact">
			<fo:block-container height="25mm" display-align="after" border-bottom="0.5pt solid black" margin-left="-20.5mm" margin-right="-20.5mm">
				<fo:block font-size="9pt" font-weight="bold" text-align="right" margin-left="21mm" margin-right="21mm" padding-bottom="0.5mm">
					<xsl:value-of select="$id"/>
				</fo:block>
			</fo:block-container>
		</fo:static-content>
		<fo:static-content flow-name="footer-odd" role="artifact">
			<fo:block-container height="40mm" margin-left="-20.5mm" margin-right="-20.5mm">
				<fo:block font-size="9pt" font-weight="bold" text-align="right" margin-left="21mm" margin-right="21mm" padding-top="12mm"><fo:page-number/></fo:block>
			</fo:block-container>
		</fo:static-content>
		<fo:static-content flow-name="header-even" role="artifact">
			<fo:block-container height="25mm" display-align="after" border-bottom="0.5pt solid black" margin-left="-20.5mm" margin-right="-20.5mm">
				<fo:block font-size="9pt" font-weight="bold" margin-left="21mm" margin-right="21mm" padding-bottom="0.5mm">
					<xsl:value-of select="$id"/>
				</fo:block>
			</fo:block-container>
		</fo:static-content>
		<fo:static-content flow-name="footer-even" role="artifact">
			<fo:block-container height="40mm" margin-left="-20.5mm" margin-right="-20.5mm">
				<fo:block font-size="9pt" font-weight="bold" margin-left="21mm" margin-right="21mm" padding-top="12mm"><fo:page-number/></fo:block>
			</fo:block-container>
		</fo:static-content>
	</xsl:template>


	<!--<xsl:variable name="Image-Logo">
		<xsl:text>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/GMzLdsAADsgaVRYdFhNTDpjb20uYWRvYmUueG1wAAAAAAA8P3hwYWNrZXQgYmVnaW49Iu+7vyIgaWQ9Ilc1TTBNcENlaGlIenJlU3pOVGN6a2M5ZCI/Pgo8eDp4bXBtZXRhIHhtbG5zOng9ImFkb2JlOm5zOm1ldGEvIiB4OnhtcHRrPSJBZG9iZSBYTVAgQ29yZSA1LjYtYzAxNCA3OS4xNTY3OTcsIDIwMTQvMDgvMjAtMDk6NTM6MDIgICAgICAgICI+CiAgIDxyZGY6UkRGIHhtbG5zOnJkZj0iaHR0cDovL3d3dy53My5vcmcvMTk5OS8wMi8yMi1yZGYtc3ludGF4LW5zIyI+CiAgICAgIDxyZGY6RGVzY3JpcHRpb24gcmRmOmFib3V0PSIiCiAgICAgICAgICAgIHhtbG5zOnhtcD0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wLyIKICAgICAgICAgICAgeG1sbnM6ZGM9Imh0dHA6Ly9wdXJsLm9yZy9kYy9lbGVtZW50cy8xLjEvIgogICAgICAgICAgICB4bWxuczpwaG90b3Nob3A9Imh0dHA6Ly9ucy5hZG9iZS5jb20vcGhvdG9zaG9wLzEuMC8iCiAgICAgICAgICAgIHhtbG5zOnhtcE1NPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvbW0vIgogICAgICAgICAgICB4bWxuczpzdEV2dD0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL3NUeXBlL1Jlc291cmNlRXZlbnQjIgogICAgICAgICAgICB4bWxuczp0aWZmPSJodHRwOi8vbnMuYWRvYmUuY29tL3RpZmYvMS4wLyIKICAgICAgICAgICAgeG1sbnM6ZXhpZj0iaHR0cDovL25zLmFkb2JlLmNvbS9leGlmLzEuMC8iPgogICAgICAgICA8eG1wOkNyZWF0b3JUb29sPkFkb2JlIFBob3Rvc2hvcCBDQyAyMDE0IChXaW5kb3dzKTwveG1wOkNyZWF0b3JUb29sPgogICAgICAgICA8eG1wOkNyZWF0ZURhdGU+MjAyMC0wMy0yNVQyMTowNTo0MSswMzowMDwveG1wOkNyZWF0ZURhdGU+CiAgICAgICAgIDx4bXA6TW9kaWZ5RGF0ZT4yMDIwLTAzLTI1VDIxOjA3OjQzKzAzOjAwPC94bXA6TW9kaWZ5RGF0ZT4KICAgICAgICAgPHhtcDpNZXRhZGF0YURhdGU+MjAyMC0wMy0yNVQyMTowNzo0MyswMzowMDwveG1wOk1ldGFkYXRhRGF0ZT4KICAgICAgICAgPGRjOmZvcm1hdD5pbWFnZS9wbmc8L2RjOmZvcm1hdD4KICAgICAgICAgPHBob3Rvc2hvcDpDb2xvck1vZGU+MzwvcGhvdG9zaG9wOkNvbG9yTW9kZT4KICAgICAgICAgPHBob3Rvc2hvcDpJQ0NQcm9maWxlPnNSR0IgSUVDNjE5NjYtMi4xPC9waG90b3Nob3A6SUNDUHJvZmlsZT4KICAgICAgICAgPHhtcE1NOkluc3RhbmNlSUQ+eG1wLmlpZDpjMTQ1NzAyOS1iYTI0LWIwNDYtYmU5NC0wOTY5ZDRkOGRkNTE8L3htcE1NOkluc3RhbmNlSUQ+CiAgICAgICAgIDx4bXBNTTpEb2N1bWVudElEPmFkb2JlOmRvY2lkOnBob3Rvc2hvcDo4NWRmOTdiMi02ZWMzLTExZWEtOGRjNC1kOTAxZWM0NGU2YWM8L3htcE1NOkRvY3VtZW50SUQ+CiAgICAgICAgIDx4bXBNTTpPcmlnaW5hbERvY3VtZW50SUQ+eG1wLmRpZDo3NTMzOTU5ZS1hYzZjLTQwNGYtOWZlNi0wZDg0ZGNkOGRkZGQ8L3htcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD4KICAgICAgICAgPHhtcE1NOkhpc3Rvcnk+CiAgICAgICAgICAgIDxyZGY6U2VxPgogICAgICAgICAgICAgICA8cmRmOmxpIHJkZjpwYXJzZVR5cGU9IlJlc291cmNlIj4KICAgICAgICAgICAgICAgICAgPHN0RXZ0OmFjdGlvbj5jcmVhdGVkPC9zdEV2dDphY3Rpb24+CiAgICAgICAgICAgICAgICAgIDxzdEV2dDppbnN0YW5jZUlEPnhtcC5paWQ6NzUzMzk1OWUtYWM2Yy00MDRmLTlmZTYtMGQ4NGRjZDhkZGRkPC9zdEV2dDppbnN0YW5jZUlEPgogICAgICAgICAgICAgICAgICA8c3RFdnQ6d2hlbj4yMDIwLTAzLTI1VDIxOjA1OjQxKzAzOjAwPC9zdEV2dDp3aGVuPgogICAgICAgICAgICAgICAgICA8c3RFdnQ6c29mdHdhcmVBZ2VudD5BZG9iZSBQaG90b3Nob3AgQ0MgMjAxNCAoV2luZG93cyk8L3N0RXZ0OnNvZnR3YXJlQWdlbnQ+CiAgICAgICAgICAgICAgIDwvcmRmOmxpPgogICAgICAgICAgICAgICA8cmRmOmxpIHJkZjpwYXJzZVR5cGU9IlJlc291cmNlIj4KICAgICAgICAgICAgICAgICAgPHN0RXZ0OmFjdGlvbj5jb252ZXJ0ZWQ8L3N0RXZ0OmFjdGlvbj4KICAgICAgICAgICAgICAgICAgPHN0RXZ0OnBhcmFtZXRlcnM+ZnJvbSBhcHBsaWNhdGlvbi92bmQuYWRvYmUucGhvdG9zaG9wIHRvIGltYWdlL3BuZzwvc3RFdnQ6cGFyYW1ldGVycz4KICAgICAgICAgICAgICAgPC9yZGY6bGk+CiAgICAgICAgICAgICAgIDxyZGY6bGkgcmRmOnBhcnNlVHlwZT0iUmVzb3VyY2UiPgogICAgICAgICAgICAgICAgICA8c3RFdnQ6YWN0aW9uPnNhdmVkPC9zdEV2dDphY3Rpb24+CiAgICAgICAgICAgICAgICAgIDxzdEV2dDppbnN0YW5jZUlEPnhtcC5paWQ6YzE0NTcwMjktYmEyNC1iMDQ2LWJlOTQtMDk2OWQ0ZDhkZDUxPC9zdEV2dDppbnN0YW5jZUlEPgogICAgICAgICAgICAgICAgICA8c3RFdnQ6d2hlbj4yMDIwLTAzLTI1VDIxOjA3OjQzKzAzOjAwPC9zdEV2dDp3aGVuPgogICAgICAgICAgICAgICAgICA8c3RFdnQ6c29mdHdhcmVBZ2VudD5BZG9iZSBQaG90b3Nob3AgQ0MgMjAxNCAoV2luZG93cyk8L3N0RXZ0OnNvZnR3YXJlQWdlbnQ+CiAgICAgICAgICAgICAgICAgIDxzdEV2dDpjaGFuZ2VkPi88L3N0RXZ0OmNoYW5nZWQ+CiAgICAgICAgICAgICAgIDwvcmRmOmxpPgogICAgICAgICAgICA8L3JkZjpTZXE+CiAgICAgICAgIDwveG1wTU06SGlzdG9yeT4KICAgICAgICAgPHRpZmY6T3JpZW50YXRpb24+MTwvdGlmZjpPcmllbnRhdGlvbj4KICAgICAgICAgPHRpZmY6WFJlc29sdXRpb24+MzAwMDAwMC8xMDAwMDwvdGlmZjpYUmVzb2x1dGlvbj4KICAgICAgICAgPHRpZmY6WVJlc29sdXRpb24+MzAwMDAwMC8xMDAwMDwvdGlmZjpZUmVzb2x1dGlvbj4KICAgICAgICAgPHRpZmY6UmVzb2x1dGlvblVuaXQ+MjwvdGlmZjpSZXNvbHV0aW9uVW5pdD4KICAgICAgICAgPGV4aWY6Q29sb3JTcGFjZT4xPC9leGlmOkNvbG9yU3BhY2U+CiAgICAgICAgIDxleGlmOlBpeGVsWERpbWVuc2lvbj4yMjU8L2V4aWY6UGl4ZWxYRGltZW5zaW9uPgogICAgICAgICA8ZXhpZjpQaXhlbFlEaW1lbnNpb24+MTgwPC9leGlmOlBpeGVsWURpbWVuc2lvbj4KICAgICAgPC9yZGY6RGVzY3JpcHRpb24+CiAgIDwvcmRmOlJERj4KPC94OnhtcG1ldGE+CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgCjw/eHBhY2tldCBlbmQ9InciPz4xznjNAAAAIGNIUk0AAHolAACAgwAA+f8AAIDpAAB1MAAA6mAAADqYAAAXb5JfxUYAAFWJSURBVHja7F1nWBVHFz50sCCxghUFFOzG2EuIBTti7OKnRI01xhrFEmOMRmOP3aixE1vsGmOvKMaCqNhQUBBBUBAREYTz/di5uHd2Zsu9l2LCeZ55Ermzs7Ozc3ZmznnPe8wg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</xsl:text>
	</xsl:variable>-->
	
	<xsl:variable name="Image-Logo-SVG">
		<svg id="Layer_1" data-name="Layer 1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 56.25 46.5" width="56.25" height="46.5">
			<defs>
				<style>
					.cls-1, .cls-2, .cls-3 {
						stroke-width: 0px;
					}

					.cls-1, .cls-3 {
						fill-rule: evenodd;
					}

					.cls-2 {
						fill: none;
					}

					.cls-3 {
						fill: #fff;
					}

					.cls-4 {
						clip-path: url(#clippath);
					}
				</style>
				<clipPath id="clippath">
					<rect class="cls-2" width="56.25" height="46.5"/>
				</clipPath>
			</defs>
			<g class="cls-4">
				<polygon class="cls-1" points="22.27 45.34 22.6 44.98 22.93 44.61 23.27 44.24 23.62 43.89 23.96 43.55 24.32 43.22 24.67 42.9 25.06 42.58 25.41 42.28 25.82 42 26.2 41.73 26.6 41.47 26.99 41.24 27.42 41.01 27.82 40.78 28.25 40.6 28.63 40.76 28.99 40.97 29.37 41.15 29.75 41.34 30.09 41.57 30.42 41.82 30.78 42.07 31.11 42.3 31.42 42.58 31.78 42.86 32.09 43.13 32.4 43.46 32.71 43.75 33.07 44.05 33.38 44.35 33.68 44.7 33.85 44.86 33.99 45.02 34.14 45.16 34.33 45.3 35.43 44.35 35.07 44.03 34.71 43.69 34.38 43.39 33.99 43.11 33.64 42.83 33.28 42.56 32.92 42.28 32.54 42.03 32.18 41.82 31.8 41.57 31.42 41.34 31.04 41.13 30.63 40.9 30.23 40.71 29.82 40.48 29.39 40.3 29.68 40.23 29.99 40.18 30.28 40.16 30.61 40.16 30.9 40.18 31.18 40.23 31.49 40.3 31.78 40.41 31.9 40.48 32.04 40.55 32.14 40.62 32.28 40.69 32.4 40.76 32.54 40.85 32.66 40.9 32.78 40.99 33.21 41.29 33.64 41.59 34.09 41.89 34.57 42.16 35.09 42.44 35.62 42.69 36.14 42.93 36.71 43.11 37.26 43.27 37.86 43.41 38.43 43.5 39.05 43.55 39.65 43.52 40.24 43.48 40.84 43.36 41.43 43.18 41.93 42.97 42.41 42.79 42.84 42.56 43.27 42.35 43.67 42.07 44.08 41.8 44.44 41.45 44.82 41.11 44.86 41.01 44.91 40.97 44.96 40.9 44.98 40.85 44.36 41.24 43.7 41.54 43.05 41.73 42.36 41.87 41.65 41.93 40.96 41.89 40.24 41.82 39.53 41.7 38.79 41.54 38.07 41.34 37.36 41.11 36.67 40.85 35.95 40.6 35.26 40.32 34.61 40.05 33.95 39.79 33.81 39.77 33.66 39.72 33.5 39.68 33.35 39.65 33.21 39.63 33.07 39.61 32.92 39.58 32.78 39.54 32.21 39.49 31.63 39.47 31.06 39.47 30.49 39.47 29.92 39.52 29.37 39.63 28.8 39.75 28.25 39.91 27.89 39.79 27.51 39.72 27.13 39.63 26.77 39.58 26.39 39.54 25.98 39.52 25.63 39.49 25.25 39.49 24.67 39.52 24.1 39.58 23.53 39.65 22.98 39.77 22.41 39.91 21.88 40.09 21.34 40.28 20.81 40.48 20.34 40.71 19.83 40.97 19.33 41.15 18.81 41.38 18.26 41.54 17.74 41.7 17.19 41.87 16.64 41.98 16.07 42.07 15.52 42.1 14.95 42.1 14.4 42.07 13.87 41.98 13.33 41.84 12.8 41.66 12.3 41.4 12.09 41.31 11.92 41.24 11.75 41.15 11.59 41.04 11.68 41.2 11.8 41.38 11.94 41.52 12.11 41.68 12.3 41.82 12.49 41.96 12.63 42.07 12.8 42.16 13.02 42.3 13.21 42.44 13.4 42.58 13.61 42.69 14.02 42.93 14.45 43.11 14.83 43.25 15.3 43.39 15.76 43.5 16.21 43.59 16.66 43.64 17.12 43.66 17.59 43.66 18.07 43.64 18.52 43.59 18.98 43.5 19.45 43.41 19.88 43.27 20.31 43.11 20.74 42.93 21.12 42.76 21.53 42.56 21.91 42.35 22.27 42.1 22.62 41.84 22.98 41.57 23.36 41.31 23.7 41.06 24.08 40.83 24.48 40.62 24.89 40.44 25.27 40.3 25.75 40.18 26.2 40.16 26.68 40.16 27.2 40.23 27.2 40.28 27.2 40.3 26.77 40.48 26.37 40.69 25.96 40.87 25.56 41.11 25.2 41.31 24.82 41.54 24.46 41.8 24.1 42.03 23.74 42.28 23.36 42.53 22.98 42.81 22.62 43.11 22.24 43.41 21.88 43.75 21.5 44.08 21.12 44.45 21.24 44.56 21.38 44.65 21.53 44.79 21.67 44.91 21.81 45.02 21.96 45.14 22.12 45.25 22.27 45.34"/>
				<polygon class="cls-1" points="14.11 40.9 14.49 40.9 14.88 40.87 15.23 40.87 15.61 40.85 15.97 40.78 16.35 40.76 16.74 40.71 17.09 40.64 17.4 40.58 17.74 40.51 18.05 40.44 18.33 40.34 18.64 40.28 18.95 40.18 19.26 40.09 19.55 40.02 19.88 39.93 20.19 39.88 20.48 39.79 20.79 39.75 21.07 39.68 21.38 39.63 21.67 39.58 21.98 39.54 22.03 39.54 21.98 39.52 21.38 39.45 20.81 39.31 20.26 39.1 19.76 38.92 19.26 38.66 18.79 38.39 18.33 38.09 17.9 37.74 17.45 37.4 17.05 37.03 16.62 36.68 16.19 36.29 15.78 35.9 15.35 35.51 14.92 35.11 14.47 34.75 14.23 34.54 14.04 34.35 13.8 34.19 13.61 34.01 13.37 33.85 13.18 33.69 12.94 33.55 12.73 33.41 13.04 33.85 13.33 34.33 13.59 34.79 13.83 35.3 14.09 35.78 14.35 36.29 14.61 36.77 14.9 37.23 15.09 37.46 15.33 37.72 15.54 37.95 15.81 38.13 16.07 38.34 16.33 38.52 16.59 38.66 16.83 38.8 17.05 38.89 17.24 38.96 17.47 39.05 17.69 39.1 17.9 39.17 18.12 39.22 18.36 39.31 18.55 39.35 18.55 39.38 18.59 39.38 18.59 39.4 18.31 39.38 18.02 39.35 17.74 39.33 17.45 39.26 17.12 39.24 16.83 39.19 16.54 39.17 16.26 39.1 15.97 39.08 15.69 39.03 15.4 38.99 15.11 38.94 14.8 38.92 14.52 38.89 14.23 38.89 13.95 38.85 13.49 38.85 13.04 38.82 12.54 38.8 12.09 38.75 11.61 38.69 11.16 38.64 10.66 38.55 10.23 38.43 9.77 38.29 9.35 38.16 8.92 37.97 8.51 37.79 8.11 37.53 7.75 37.28 7.39 36.98 7.08 36.64 7.39 37.19 7.77 37.7 8.2 38.2 8.68 38.66 9.23 39.08 9.77 39.47 10.32 39.81 10.87 40.09 11.23 40.28 11.63 40.41 12.04 40.55 12.47 40.62 12.87 40.74 13.3 40.78 13.73 40.85 14.11 40.9"/>
				<polygon class="cls-1" points="41.43 40.74 41.96 40.74 42.43 40.71 42.93 40.64 43.41 40.58 43.91 40.48 44.36 40.34 44.84 40.21 45.27 40.05 45.7 39.86 46.13 39.63 46.53 39.38 46.94 39.12 47.35 38.82 47.68 38.52 48.01 38.23 48.37 37.86 48.51 37.67 48.68 37.51 48.8 37.3 48.94 37.14 49.06 36.96 49.16 36.75 49.28 36.57 49.39 36.34 49.01 36.73 48.63 37.05 48.2 37.37 47.77 37.6 47.27 37.83 46.8 38.02 46.25 38.2 45.68 38.34 45.2 38.41 44.7 38.48 44.22 38.52 43.77 38.57 43.27 38.64 42.79 38.66 42.29 38.71 41.81 38.78 41.34 38.82 40.84 38.89 40.36 38.94 39.91 38.99 39.41 39.05 38.93 39.12 38.43 39.22 37.95 39.31 37.93 39.26 37.93 39.24 38.48 39.08 39 38.92 39.53 38.69 40 38.48 40.43 38.16 40.86 37.86 41.24 37.46 41.58 37.03 41.77 36.75 41.93 36.45 42.1 36.15 42.27 35.85 42.43 35.48 42.62 35.11 42.79 34.79 42.96 34.42 43.13 34.1 43.34 33.78 43.53 33.46 43.77 33.16 43.44 33.36 43.13 33.55 42.82 33.8 42.53 34.01 42.22 34.29 41.93 34.54 41.62 34.81 41.34 35.07 40.96 35.44 40.58 35.81 40.22 36.17 39.84 36.54 39.48 36.87 39.1 37.19 38.69 37.53 38.33 37.83 37.9 38.13 37.47 38.39 37.05 38.64 36.57 38.85 36.09 39.05 35.62 39.19 35.07 39.33 34.52 39.4 34.52 39.45 34.52 39.47 34.76 39.49 35 39.52 35.23 39.54 35.5 39.58 35.71 39.63 35.95 39.65 36.21 39.72 36.43 39.77 36.76 39.86 37.07 39.91 37.38 40 37.69 40.07 38 40.16 38.33 40.23 38.64 40.3 38.95 40.37 39.26 40.44 39.57 40.51 39.91 40.58 40.19 40.62 40.5 40.64 40.81 40.69 41.12 40.71 41.43 40.74"/>
				<polygon class="cls-1" points="14.97 38.36 15.02 38.36 15.04 38.36 14.76 38.11 14.49 37.86 14.23 37.58 13.97 37.28 13.76 37 13.54 36.7 13.35 36.4 13.21 36.06 12.75 34.93 12.32 33.8 11.87 32.72 11.4 31.64 10.89 30.62 10.32 29.63 9.65 28.73 8.89 27.9 9.3 29.12 9.61 30.37 9.87 31.64 10.11 32.88 10.49 34.1 11.01 35.21 11.75 36.17 12.78 36.98 12.8 36.98 12.8 37 12.8 37.03 12.78 37.05 12.4 36.89 12.06 36.68 11.75 36.45 11.4 36.2 11.09 35.94 10.78 35.71 10.44 35.48 10.08 35.3 9.61 35.02 9.11 34.77 8.63 34.54 8.11 34.29 7.6 34.05 7.08 33.8 6.6 33.55 6.08 33.27 5.63 32.99 5.17 32.7 4.72 32.35 4.31 31.98 3.93 31.59 3.6 31.17 3.29 30.69 3.03 30.18 3.15 30.74 3.29 31.24 3.48 31.75 3.72 32.21 3.96 32.7 4.22 33.13 4.53 33.55 4.86 33.94 5.32 34.49 5.79 35.02 6.32 35.46 6.89 35.85 7.46 36.2 8.06 36.54 8.68 36.77 9.35 37.03 10.01 37.26 10.68 37.44 11.37 37.6 12.09 37.79 12.8 37.93 13.52 38.09 14.26 38.23 14.97 38.36"/>
				<polygon class="cls-1" points="27.39 38.23 27.68 38.23 27.96 38.23 28.23 38.23 28.51 38.23 28.8 38.23 29.08 38.2 29.37 38.2 29.66 38.16 29.94 38.13 30.23 38.11 30.51 38.09 30.82 38.06 31.11 37.99 31.4 37.97 31.68 37.93 31.97 37.86 32.95 37.65 33.9 37.37 34.81 37.1 35.69 36.73 36.55 36.36 37.38 35.92 38.19 35.48 38.95 34.98 39.69 34.49 40.41 33.92 41.1 33.32 41.77 32.72 42.39 32.05 43.01 31.36 43.58 30.64 44.13 29.91 44.53 29.29 44.91 28.66 45.27 28 45.63 27.28 45.94 26.54 46.25 25.81 46.51 25.02 46.73 24.24 46.82 23.87 46.92 23.5 46.99 23.18 47.06 22.86 47.23 21.82 47.35 20.81 47.37 19.77 47.3 18.76 47.23 17.7 47.08 16.68 46.84 15.67 46.58 14.65 46.25 13.69 45.87 12.72 45.49 11.82 45.01 10.92 44.51 10.07 43.96 9.24 43.39 8.5 42.79 7.79 42.41 7.37 42.05 6.98 41.67 6.61 41.29 6.27 40.91 5.9 40.53 5.58 40.12 5.25 39.76 4.95 39.36 4.68 38.95 4.4 38.55 4.13 38.12 3.87 37.69 3.64 37.29 3.41 36.83 3.18 36.4 2.97 35.38 2.53 34.35 2.14 33.28 1.84 32.21 1.57 31.11 1.36 29.99 1.25 28.89 1.18 27.8 1.18 26.68 1.22 25.6 1.34 24.48 1.5 23.41 1.73 22.36 2.03 21.31 2.4 20.31 2.76 19.31 3.25 18.9 3.46 18.48 3.69 18.07 3.94 17.66 4.19 17.24 4.42 16.83 4.7 16.45 5.02 16.07 5.33 15.66 5.62 15.3 5.95 14.9 6.29 14.54 6.64 14.18 7.01 13.83 7.4 13.49 7.79 13.16 8.16 12.83 8.57 12.52 8.99 12.21 9.4 11.94 9.82 11.66 10.23 11.4 10.69 11.16 11.15 10.89 11.61 10.01 13.66 9.39 15.81 9.06 18.02 9.01 20.23 9.2 22.4 9.65 24.59 10.37 26.66 11.32 28.66 11.49 28.96 11.66 29.24 11.82 29.52 12.04 29.79 12.21 30.07 12.4 30.35 12.61 30.6 12.8 30.88 13.4 31.57 14.02 32.26 14.64 32.88 15.26 33.46 15.95 34.05 16.64 34.56 17.36 35.07 18.09 35.51 18.83 35.94 19.64 36.34 20.45 36.7 21.31 37.03 22.17 37.3 23.05 37.58 23.98 37.81 24.94 37.99 25.25 38.02 25.56 38.09 25.89 38.11 26.18 38.13 26.49 38.16 26.8 38.2 27.08 38.23 27.39 38.23"/>
				<polygon class="cls-1" points="41.43 38.2 42.27 38.06 43.1 37.88 43.93 37.72 44.72 37.53 45.53 37.3 46.3 37.05 47.08 36.77 47.8 36.47 48.51 36.15 49.2 35.76 49.82 35.34 50.42 34.88 50.99 34.35 51.52 33.78 51.97 33.16 52.4 32.46 52.57 32.19 52.71 31.87 52.88 31.57 52.99 31.2 53.14 30.88 53.23 30.51 53.3 30.14 53.4 29.79 53.11 30.35 52.8 30.88 52.42 31.34 51.99 31.75 51.54 32.14 51.06 32.49 50.54 32.83 50.02 33.13 49.49 33.41 48.94 33.69 48.37 33.96 47.82 34.24 47.27 34.52 46.77 34.81 46.25 35.09 45.77 35.44 45.63 35.53 45.49 35.62 45.34 35.74 45.2 35.85 45.01 35.99 44.84 36.13 44.65 36.27 44.49 36.4 44.29 36.5 44.1 36.64 43.91 36.75 43.7 36.87 43.7 36.84 43.67 36.84 43.67 36.82 44.2 36.36 44.65 35.9 45.06 35.39 45.41 34.91 45.72 34.38 45.99 33.8 46.22 33.18 46.39 32.53 46.51 31.91 46.58 31.29 46.68 30.67 46.8 30.05 46.92 29.42 47.06 28.82 47.23 28.2 47.49 27.63 46.94 28.13 46.44 28.71 46.01 29.31 45.65 29.95 45.34 30.64 45.01 31.36 44.72 32.12 44.44 32.83 44.2 33.57 43.91 34.33 43.58 35.05 43.24 35.76 42.86 36.43 42.43 37.05 41.96 37.67 41.41 38.2 41.43 38.2"/>
				<polygon class="cls-3" points="28.65 37.37 29.08 37.3 29.49 37.26 29.92 37.19 30.37 37.12 30.8 37.05 31.23 36.98 31.68 36.89 32.11 36.82 32.56 36.73 32.99 36.61 33.42 36.5 33.9 36.36 34.33 36.22 34.71 36.08 35.14 35.92 35.54 35.76 35.93 35.6 36.26 35.39 36.62 35.23 36.95 35.05 37.29 34.88 37.64 34.68 37.95 34.47 38.26 34.26 38.57 34.05 38.91 33.85 39.22 33.59 39.53 33.39 39.84 33.13 40.15 32.88 40.48 32.63 40.79 32.35 40.53 32.12 40.24 31.89 39.96 31.64 39.67 31.36 39.41 31.11 39.14 30.88 38.93 30.6 38.76 30.32 38.4 30.69 38.05 31.04 37.67 31.34 37.26 31.61 36.83 31.89 36.43 32.14 36.07 32.42 35.69 32.72 35.64 32.86 35.57 32.97 35.5 33.09 35.43 33.18 35.38 33.25 35.33 33.29 35.26 33.36 35.23 33.41 35.14 33.55 35.07 33.64 34.95 33.73 34.83 33.87 34.69 33.96 34.54 34.08 34.42 34.19 34.33 34.29 34.18 34.4 34.07 34.52 33.92 34.61 33.76 34.68 33.56 34.81 33.38 34.91 33.14 34.95 32.95 34.95 32.76 34.88 32.56 34.79 32.4 34.68 32.23 34.56 32.09 34.47 31.92 34.35 31.71 34.26 31.52 34.22 31.37 34.24 31.23 34.26 31.11 34.29 30.97 34.29 30.85 34.33 30.7 34.35 30.61 34.35 30.47 34.38 30.23 34.4 29.99 34.42 29.78 34.47 29.56 34.49 29.35 34.52 29.11 34.52 28.89 34.52 28.65 34.47 28.63 37.37 28.65 37.37"/>
				<polygon class="cls-3" points="27.68 37.3 27.56 37.1 27.56 36.45 27.56 35.78 27.56 35.11 27.65 34.49 27.27 34.52 26.91 34.52 26.53 34.49 26.2 34.47 25.82 34.4 25.46 34.33 25.08 34.26 24.75 34.22 24.2 34.1 23.67 33.94 23.17 33.8 22.67 33.59 22.19 33.41 21.69 33.23 21.24 33.02 20.81 32.81 20.41 32.56 19.98 32.3 19.6 32.05 19.19 31.77 18.81 31.5 18.4 31.17 18.05 30.88 17.64 30.51 17.4 30.76 17.16 31.01 16.93 31.24 16.66 31.5 16.4 31.75 16.16 32 15.9 32.26 15.64 32.49 16.07 32.86 16.52 33.18 16.95 33.52 17.4 33.85 17.88 34.15 18.33 34.47 18.81 34.75 19.31 35.02 19.79 35.3 20.31 35.51 20.81 35.76 21.36 35.99 21.91 36.17 22.48 36.36 23.08 36.57 23.7 36.73 24.22 36.84 24.7 36.96 25.22 37.03 25.75 37.1 26.22 37.14 26.7 37.19 27.2 37.26 27.68 37.3"/>
				<polygon class="cls-1" points="9.75 34.24 9.75 34.24 9.75 34.22 9.11 32.88 8.73 31.47 8.49 30.05 8.32 28.55 8.2 27.05 8.01 25.58 7.65 24.15 7.15 22.74 7.2 23.46 7.15 24.17 7.03 24.88 6.89 25.62 6.75 26.36 6.6 27.07 6.51 27.79 6.51 28.55 6.58 28.99 6.65 29.45 6.77 29.91 6.91 30.32 7.08 30.74 7.29 31.11 7.49 31.5 7.72 31.84 7.68 31.84 7.68 31.87 7.65 31.87 7.37 31.57 7.1 31.22 6.89 30.9 6.65 30.55 6.44 30.23 6.17 29.93 5.94 29.58 5.65 29.26 5.44 29.01 5.2 28.76 4.96 28.53 4.74 28.29 4.51 28.04 4.24 27.79 4.03 27.58 3.77 27.33 3.31 26.89 2.91 26.41 2.5 25.97 2.17 25.48 1.86 24.95 1.62 24.42 1.43 23.85 1.31 23.2 1.22 23.87 1.24 24.56 1.31 25.28 1.43 25.99 1.57 26.54 1.76 27.07 2 27.6 2.24 28.11 2.53 28.57 2.86 29.03 3.22 29.49 3.6 29.91 4.01 30.28 4.39 30.67 4.82 31.04 5.24 31.36 5.72 31.7 6.17 32 6.63 32.28 7.08 32.56 7.44 32.74 7.75 32.97 8.08 33.16 8.44 33.36 8.75 33.55 9.08 33.78 9.39 33.99 9.73 34.24 9.75 34.24"/>
				<polygon class="cls-1" points="46.68 33.99 47.27 33.59 47.92 33.18 48.54 32.76 49.2 32.4 49.82 31.93 50.49 31.5 51.11 31.04 51.71 30.55 52.28 30.05 52.83 29.52 53.35 28.94 53.81 28.29 54.21 27.63 54.55 26.94 54.81 26.17 55 25.37 55.09 24.72 55.14 24.06 55.14 23.43 55.09 22.79 54.92 23.57 54.69 24.26 54.35 24.88 53.95 25.51 53.45 26.08 52.95 26.64 52.4 27.19 51.8 27.76 51.3 28.25 50.87 28.73 50.52 29.22 50.16 29.7 49.82 30.18 49.49 30.64 49.13 31.11 48.73 31.59 48.7 31.59 48.7 31.57 49.11 30.88 49.59 29.84 49.8 28.8 49.82 27.74 49.71 26.66 49.54 25.58 49.37 24.52 49.25 23.46 49.25 22.4 48.7 23.83 48.4 25.25 48.2 26.73 48.06 28.2 47.92 29.7 47.68 31.15 47.3 32.58 46.68 33.94 46.68 33.96 46.68 33.99"/>
				<polygon class="cls-3" points="27.68 33.66 27.56 32.99 27.53 32.33 27.53 31.64 27.56 30.94 27.18 30.97 26.77 30.97 26.39 30.94 25.98 30.9 25.6 30.81 25.2 30.74 24.79 30.62 24.41 30.48 24.05 30.35 23.67 30.21 23.31 30.05 22.96 29.86 22.62 29.7 22.27 29.54 21.96 29.35 21.67 29.17 21.55 29.08 21.46 28.99 21.31 28.89 21.19 28.8 21.26 28.96 21.36 29.1 21.46 29.26 21.41 29.42 21.41 29.45 21.41 29.49 21.38 29.52 21.31 29.58 21.22 29.63 21.1 29.65 20.98 29.68 20.88 29.68 20.76 29.68 20.64 29.68 20.53 29.7 20.31 29.72 20.1 29.79 19.88 29.84 19.64 29.93 19.41 30 19.19 30.05 18.95 30.05 18.74 29.95 18.62 29.84 18.5 29.77 18.36 29.72 18.19 29.68 18.33 29.77 18.48 29.84 18.59 29.95 18.74 30.09 18.95 30.28 19.19 30.46 19.41 30.62 19.62 30.78 19.83 30.92 20.05 31.06 20.26 31.2 20.48 31.34 20.84 31.59 21.22 31.8 21.65 32.03 22.08 32.21 22.5 32.4 22.96 32.58 23.41 32.72 23.91 32.86 24.36 32.99 24.84 33.13 25.34 33.25 25.82 33.36 26.32 33.43 26.77 33.52 27.22 33.59 27.68 33.66"/>
				<polygon class="cls-3" points="28.65 33.59 28.94 33.55 29.2 33.5 29.49 33.43 29.78 33.41 30.06 33.39 30.35 33.36 30.63 33.32 30.92 33.29 30.68 33.23 30.49 33.09 30.28 32.97 30.09 32.88 29.94 32.67 29.8 32.44 29.7 32.21 29.7 31.98 29.78 31.84 29.85 31.73 29.89 31.61 29.89 31.47 29.78 31.43 29.63 31.38 29.49 31.36 29.32 31.36 29.18 31.36 28.99 31.36 28.85 31.34 28.7 31.29 28.68 31.24 28.65 31.2 28.61 31.17 28.51 31.15 28.63 31.73 28.68 32.35 28.65 32.99 28.65 33.59"/>
				<polygon class="cls-3" points="14.9 31.8 15.11 31.57 15.38 31.29 15.64 31.04 15.9 30.78 16.16 30.51 16.4 30.28 16.69 30.07 16.97 29.84 16.78 29.65 16.59 29.42 16.35 29.22 16.16 28.99 16.02 28.94 15.88 28.85 15.76 28.76 15.64 28.69 15.52 28.57 15.4 28.46 15.33 28.34 15.26 28.2 15.26 28.16 15.26 28.11 15.26 28.04 15.23 28 15.16 28.06 15.07 28.13 14.95 28.16 14.83 28.16 14.68 28.06 14.59 27.97 14.47 27.86 14.33 27.74 14.26 27.63 14.18 27.49 14.11 27.37 14.09 27.23 14.09 27.21 14.07 27.21 13.78 27.21 13.52 26.94 13.35 26.94 13.25 26.89 13.23 26.8 13.18 26.73 13.09 26.66 13.04 26.61 13.02 26.52 12.97 26.47 12.94 26.41 12.92 26.41 12.92 26.38 12.9 26.38 12.87 26.41 12.87 26.47 12.87 26.5 12.87 26.54 12.83 26.59 12.8 26.64 12.75 26.66 12.68 26.66 12.49 26.59 12.35 26.47 12.21 26.34 12.06 26.2 12.04 26.17 12.04 26.13 12.02 26.11 11.94 26.13 11.87 26.17 11.8 26.2 11.73 26.13 11.54 25.92 11.47 25.67 11.37 25.39 11.25 25.14 11.23 24.84 11.23 24.54 11.25 24.24 11.37 23.99 11.44 23.89 11.49 23.78 11.51 23.71 11.61 23.62 11.73 23.59 11.82 23.57 11.94 23.57 12.04 23.59 12.09 23.64 12.11 23.69 12.16 23.71 12.18 23.73 12.44 23.69 12.47 23.62 12.47 23.57 12.47 23.55 12.47 23.48 12.59 23.36 12.73 23.32 12.87 23.3 13.04 23.27 13.18 23.36 13.25 23.55 13.37 23.69 13.49 23.83 13.35 23.46 13.25 23.06 13.18 22.67 13.09 22.3 13.02 21.91 12.97 21.5 12.94 21.11 12.87 20.74 12.92 20.25 12.59 20.3 12.23 20.3 11.87 20.32 11.49 20.32 11.11 20.3 10.78 20.3 10.39 20.28 10.04 20.28 10.08 21.11 10.18 21.96 10.3 22.79 10.47 23.62 10.8 24.86 11.2 26.04 11.68 27.1 12.21 28.13 12.8 29.1 13.45 30 14.11 30.92 14.88 31.8 14.9 31.8"/>
				<polygon class="cls-3" points="41.53 31.75 41.79 31.36 42.08 31.01 42.36 30.64 42.65 30.28 42.93 29.95 43.2 29.58 43.44 29.24 43.67 28.85 43.82 28.66 43.93 28.43 44.06 28.25 44.15 28.02 44.27 27.79 44.39 27.58 44.53 27.37 44.65 27.17 44.86 26.64 45.1 26.11 45.34 25.55 45.51 25 45.68 24.45 45.84 23.87 45.96 23.32 46.08 22.77 46.2 22.1 46.25 21.43 46.34 20.78 46.49 20.16 46.11 20.18 45.77 20.23 45.39 20.23 45.01 20.23 44.65 20.23 44.27 20.23 43.93 20.18 43.56 20.18 43.53 20.16 43.51 20.16 43.48 20.14 43.48 20.88 43.41 21.66 43.27 22.44 43.1 23.23 42.86 23.99 42.62 24.75 42.29 25.48 41.98 26.17 41.86 26.41 41.72 26.64 41.62 26.87 41.48 27.07 41.36 27.3 41.22 27.51 41.07 27.72 40.93 27.93 40.86 28 40.81 28.06 40.79 28.16 40.72 28.2 40.58 28.41 40.43 28.59 40.29 28.8 40.12 28.96 39.98 29.15 39.81 29.35 39.65 29.54 39.43 29.7 39.41 29.7 39.38 29.7 39.57 29.86 39.81 30.05 40 30.23 40.22 30.41 40.43 30.62 40.65 30.83 40.84 31.04 41.05 31.24 41.19 31.36 41.29 31.47 41.41 31.61 41.5 31.75 41.53 31.75"/>
				<polygon class="cls-3" points="36.11 31.29 36.33 31.08 36.52 30.9 36.76 30.69 37 30.53 37.24 30.37 37.5 30.18 37.72 29.98 37.93 29.77 37.95 29.72 37.98 29.72 37.83 29.77 37.69 29.77 37.55 29.72 37.43 29.65 37.38 29.4 37.24 29.15 37.09 28.94 36.9 28.71 36.67 28.48 36.47 28.27 36.26 28.06 36.07 27.86 36.07 27.83 35.97 27.97 35.85 28.11 35.76 28.2 35.62 28.34 35.64 28.66 35.81 28.8 36 28.87 36.21 28.99 36.38 29.12 36.5 29.22 36.57 29.29 36.67 29.4 36.71 29.52 36.64 29.7 36.5 29.86 36.36 30.05 36.26 30.21 36.21 30.28 36.14 30.37 36.09 30.46 36.09 30.53 36.14 30.64 36.24 30.76 36.26 30.83 36.26 30.97 36.24 31.06 36.19 31.11 36.11 31.2 36.09 31.29 36.11 31.29"/>
				<polygon class="cls-3" points="26.6 29.86 26.6 29.86 26.6 29.84 26.41 29.79 26.25 29.7 26.1 29.63 25.96 29.52 25.82 29.4 25.7 29.26 25.63 29.12 25.51 28.96 25.41 28.8 25.34 28.62 25.27 28.48 25.27 28.32 25.34 28.27 25.41 28.2 25.48 28.16 25.51 28.11 25.6 27.83 25.7 27.58 25.89 27.35 26.1 27.21 26.25 27.17 26.39 27.14 26.53 27.07 26.68 27.05 26.32 27.14 25.94 27.1 25.56 27.05 25.22 26.91 24.89 26.77 24.53 26.61 24.22 26.45 23.91 26.27 23.77 26.17 23.62 26.08 23.48 25.99 23.36 25.9 23.22 25.81 23.1 25.67 22.98 25.55 22.91 25.39 22.7 25.62 22.48 25.85 22.24 26.11 21.98 26.36 21.77 26.61 21.5 26.82 21.24 27.07 20.98 27.28 21.34 27.49 21.67 27.72 22.03 27.93 22.34 28.16 22.65 28.39 22.98 28.59 23.36 28.8 23.74 28.96 24.08 29.12 24.41 29.24 24.79 29.38 25.17 29.45 25.53 29.56 25.91 29.65 26.25 29.77 26.6 29.86"/>
				<polygon class="cls-3" points="38.69 29.08 38.98 28.76 39.24 28.43 39.5 28.13 39.76 27.79 39.98 27.49 40.19 27.19 40.41 26.87 40.65 26.54 41 25.85 41.36 25.12 41.65 24.38 41.93 23.57 42.12 22.77 42.34 21.94 42.43 21.13 42.51 20.32 42.65 20.18 42.29 20.18 41.96 20.23 41.58 20.23 41.22 20.23 40.86 20.23 40.5 20.23 40.12 20.18 39.79 20.16 39.79 20.55 39.72 20.97 39.69 21.36 39.65 21.77 39.69 21.89 39.79 21.98 39.86 22.07 39.96 22.19 39.98 22.26 39.98 22.37 39.98 22.47 39.93 22.53 39.84 22.6 39.72 22.63 39.62 22.63 39.53 22.6 39.5 22.58 39.48 22.53 39.24 23.2 38.98 23.85 38.69 24.45 38.4 25.02 38.07 25.62 37.72 26.13 37.33 26.64 36.85 27.14 36.83 27.14 36.81 27.14 36.78 27.17 36.76 27.17 37.57 27.9 37.62 27.9 37.64 27.88 37.67 27.58 37.69 27.56 37.76 27.51 37.78 27.51 37.83 27.51 37.95 27.56 38.05 27.58 38.12 27.6 38.19 27.63 38.38 27.9 38.5 28.18 38.57 28.53 38.69 28.85 38.67 28.89 38.67 28.96 38.67 29.03 38.67 29.1 38.69 29.08"/>
				<polygon class="cls-3" points="21.1 28.71 20.88 28.46 20.93 28.59 21.1 28.71"/>
				<polygon class="cls-3" points="20.81 28.34 20.79 28.32 20.79 28.29 20.76 28.29 20.79 28.34 20.81 28.34"/>
				<polygon class="cls-1" points="5.75 28.2 5.63 27.42 5.63 26.59 5.72 25.78 5.89 24.98 6.1 24.17 6.37 23.34 6.6 22.53 6.82 21.75 7.08 20.65 7.29 19.49 7.44 18.39 7.51 17.28 7.51 17.14 7.51 17.01 7.49 16.87 7.49 16.73 7.25 17.51 6.94 18.18 6.6 18.8 6.22 19.4 5.86 20 5.48 20.6 5.17 21.24 4.89 21.96 4.65 22.93 4.6 23.87 4.67 24.82 4.89 25.76 4.86 25.76 4.86 25.78 4.82 25.78 4.79 25.78 4.77 25.76 4.6 25.23 4.46 24.68 4.34 24.12 4.22 23.57 3.93 22.53 3.53 21.57 3.1 20.6 2.65 19.63 2.29 18.64 2 17.65 1.88 16.64 1.95 15.55 1.64 16.38 1.43 17.26 1.29 18.18 1.22 19.08 1.29 19.95 1.38 20.81 1.57 21.66 1.79 22.49 2.1 23.34 2.53 24.12 3.05 24.84 3.6 25.53 4.17 26.2 4.72 26.87 5.24 27.51 5.72 28.25 5.75 28.2"/>
				<polygon class="cls-1" points="50.68 27.88 51.11 27.35 51.54 26.82 51.99 26.27 52.42 25.69 52.85 25.12 53.26 24.52 53.66 23.89 54 23.27 54.3 22.6 54.59 21.94 54.83 21.24 55 20.53 55.09 19.82 55.14 19.06 55.09 18.3 54.97 17.49 54.88 16.98 54.78 16.5 54.64 15.99 54.45 15.48 54.43 15.42 54.4 15.32 54.35 15.25 54.3 15.18 54.4 16.15 54.35 17.07 54.14 17.97 53.83 18.87 53.45 19.75 53.09 20.65 52.71 21.52 52.4 22.44 52.21 23.06 52.09 23.73 51.95 24.4 51.73 25.07 51.57 25.44 51.54 25.44 51.54 25.41 51.68 24.82 51.78 24.19 51.8 23.59 51.78 22.95 51.68 22.35 51.54 21.75 51.3 21.15 51.01 20.6 50.73 20.09 50.44 19.61 50.13 19.12 49.82 18.64 49.51 18.16 49.25 17.63 49.01 17.05 48.82 16.43 48.8 17.74 48.97 19.03 49.25 20.32 49.63 21.64 50.02 22.93 50.37 24.24 50.66 25.53 50.78 26.82 50.78 27.1 50.73 27.35 50.68 27.63 50.66 27.9 50.68 27.88"/>
				<polygon class="cls-3" points="19.76 27.17 19.79 27.07 19.83 27.03 19.88 27 19.93 26.91 20.22 26.64 20.5 26.36 20.79 26.08 21.07 25.81 21.36 25.53 21.62 25.25 21.93 24.98 22.22 24.72 21.91 24.4 21.62 24.03 21.36 23.69 21.17 23.27 20.95 22.86 20.76 22.4 20.6 21.96 20.45 21.47 20.45 21.41 20.45 21.36 20.41 21.34 20.41 21.27 20.12 21.11 20.07 21.29 20.05 21.52 19.98 21.75 19.95 21.96 19.95 21.98 19.93 21.98 19.91 22.03 19.88 22.05 19.76 22.03 19.69 21.98 19.67 21.94 19.62 21.91 19.52 21.89 19.45 21.82 19.38 21.77 19.33 21.66 19.31 21.57 19.33 21.52 19.36 21.47 19.38 21.43 19.41 21.43 19.48 21.41 19.52 21.43 19.6 21.47 19.64 21.47 19.69 21.24 19.69 21.01 19.67 20.81 19.64 20.58 19.64 20.55 19.67 20.53 19.69 20.53 19.74 20.51 19.83 20.53 19.93 20.58 20.02 20.69 20.07 20.78 20.19 20.81 20.31 20.78 20.41 20.71 20.53 20.69 20.55 20.67 20.55 20.65 20.6 20.65 20.6 20.6 20.67 20.28 20.64 20.25 20.62 20.25 20.6 20.23 20.55 20.18 20.6 20.02 20.62 19.86 20.62 19.68 20.55 19.49 20.6 19.33 20.55 19.19 20.5 19.06 20.41 18.94 20.24 18.87 20.05 18.87 19.83 18.89 19.67 18.94 19.64 18.99 19.62 19.01 19.6 19.01 19.52 19.08 19.5 19.19 19.52 19.31 19.52 19.42 19.64 19.59 19.74 19.77 19.76 19.98 19.74 20.16 19.69 20.18 19.67 20.23 19.62 20.25 19.55 20.28 19.48 20.25 19.38 20.25 19.26 20.25 19.19 20.25 19.1 20.39 19.1 20.55 19.07 20.71 18.98 20.85 18.83 20.92 18.67 20.92 18.5 20.97 18.38 21.08 18.4 21.29 18.5 21.5 18.52 21.71 18.5 21.96 18.69 22.17 18.9 22.37 19.05 22.6 19.12 22.88 19.21 23.16 19.26 23.43 19.31 23.71 19.48 23.92 19.48 24.06 19.48 24.19 19.48 24.31 19.5 24.45 19.52 25.02 19.76 25.53 19.95 26.04 19.98 26.59 19.91 26.68 19.76 26.77 19.67 26.82 19.62 26.96 19.6 27 19.6 27.03 19.62 27.03 19.67 27.03 19.69 27.05 19.74 27.05 19.76 27.07 19.76 27.1 19.76 27.14 19.76 27.17"/>
				<polygon class="cls-3" points="30.25 26.96 30.35 26.96 30.42 26.91 30.51 26.89 30.54 26.8 30.54 26.73 30.56 26.64 30.63 26.59 30.68 26.52 30.82 26.5 30.97 26.45 31.11 26.41 31.25 26.36 31.8 25.99 31.94 25.83 32.06 25.65 32.14 25.44 32.11 25.21 32.11 25.16 32.09 25.14 32.06 25.14 32.04 25.12 31.68 25.23 31.63 25.35 31.54 25.41 31.47 25.51 31.32 25.55 31.18 25.53 31.06 25.44 30.94 25.37 30.85 25.3 30.82 25.3 30.8 25.35 30.8 25.37 30.8 25.39 30.82 25.39 30.85 25.41 30.9 25.48 30.92 25.53 30.92 25.62 30.92 25.67 30.56 25.81 30.18 25.58 30.13 25.58 30.11 25.58 30.06 25.83 29.89 25.76 29.7 25.65 29.51 25.55 29.32 25.51 29.27 25.48 29.25 25.44 29.25 25.41 29.23 25.39 29.18 25.37 29.11 25.35 29.06 25.37 28.99 25.39 28.92 25.44 28.82 25.51 28.7 25.53 28.61 25.55 28.61 25.58 28.61 25.62 28.56 25.65 28.56 25.67 28.54 25.71 28.51 25.76 28.46 25.81 28.39 25.83 28.18 26.17 27.99 26.2 27.82 26.31 27.65 26.38 27.49 26.45 27.51 26.59 27.68 26.64 27.84 26.66 28.04 26.66 28.18 26.64 28.25 26.52 28.37 26.47 28.49 26.41 28.61 26.41 28.77 26.45 28.94 26.45 29.11 26.45 29.27 26.45 29.32 26.45 29.35 26.47 29.37 26.52 29.39 26.54 29.49 26.8 29.66 26.82 29.89 26.82 30.09 26.89 30.25 26.96"/>
				<polygon class="cls-3" points="33.92 26.89 35.23 26.77 35.33 26.5 35.43 26.24 35.54 25.99 35.71 25.78 35.81 25.71 35.83 25.71 35.9 25.78 35.93 25.81 35.95 25.85 36 25.99 36.05 26.13 36.07 26.27 36.09 26.41 36.47 26.04 36.78 25.62 37.09 25.21 37.36 24.75 37.62 24.29 37.83 23.83 38.07 23.32 38.26 22.77 38.26 22.74 38.24 22.74 38.05 22.77 37.81 22.79 37.62 22.86 37.38 22.88 37.19 22.9 36.95 22.9 36.76 22.88 36.55 22.79 36.38 23.09 36.33 23.16 36.26 23.16 36.14 23.18 36.07 23.16 36 23.09 35.95 23.02 35.9 22.93 35.85 22.81 35.81 23.04 35.69 23.23 35.52 23.43 35.4 23.64 35.26 23.76 35.12 23.83 34.95 23.87 34.78 23.89 34.66 24.01 34.57 24.17 34.47 24.29 34.28 24.38 34.18 24.38 34.07 24.38 33.95 24.4 33.85 24.45 33.83 24.45 33.83 24.47 33.85 24.54 33.9 24.56 33.95 24.59 33.99 24.59 34.07 24.59 34.09 24.59 34.14 24.59 34.18 24.59 34.47 24.47 34.52 24.45 34.57 24.42 34.64 24.4 34.66 24.33 34.69 24.24 34.76 24.12 34.81 24.01 34.9 23.92 35.04 23.89 35.14 23.85 35.28 23.83 35.4 23.85 35.52 23.99 35.62 24.12 35.69 24.29 35.69 24.47 35.69 24.65 35.66 24.79 35.62 24.93 35.54 25.02 35.52 25.23 35.5 25.41 35.47 25.58 35.38 25.71 35.35 25.85 35.33 25.99 35.23 26.08 35.14 26.2 35.12 26.24 35.12 26.31 35.12 26.36 35.09 26.41 34.97 26.47 34.83 26.52 34.69 26.54 34.54 26.54 34.33 26.47 34.09 26.38 33.9 26.34 33.66 26.27 33.42 26.24 33.23 26.2 32.99 26.13 32.78 26.08 32.61 26.06 32.42 26.04 32.28 26.04 32.14 26.06 32.09 26.13 32.09 26.2 32.11 26.22 32.18 26.24 32.21 26.27 32.42 26.31 32.66 26.36 32.9 26.45 33.11 26.5 33.33 26.59 33.52 26.68 33.71 26.77 33.92 26.89"/>
				<polygon class="cls-3" points="27.11 26.2 27.11 26.2 27.13 26.2 27.18 25.97 27.2 25.71 27.22 25.51 27.37 25.3 27.51 25.25 27.63 25.25 27.77 25.25 27.89 25.23 27.92 25.16 27.92 25.14 27.92 25.09 27.92 25.02 27.84 24.98 27.8 24.95 27.75 24.86 27.7 24.79 27.68 24.68 27.65 24.56 27.68 24.45 27.77 24.4 27.75 23.85 27.77 23.83 27.8 23.76 27.84 23.73 27.92 23.71 27.68 23.78 27.42 23.78 27.2 23.78 26.94 23.71 26.68 23.62 26.46 23.55 26.2 23.43 25.98 23.32 25.84 23.27 25.7 23.18 25.56 23.06 25.48 22.93 25.48 22.9 25.48 22.88 25.39 23.04 25.27 23.18 25.13 23.32 24.98 23.43 24.82 23.59 24.67 23.73 24.51 23.89 24.34 24.06 24.2 24.24 24.03 24.38 23.89 24.54 23.74 24.68 24.08 24.93 24.46 25.16 24.82 25.39 25.22 25.62 25.65 25.78 26.1 25.94 26.56 26.06 27.06 26.17 27.08 26.2 27.11 26.2"/>
				<polygon class="cls-3" points="30.99 24.7 31.71 24.29 31.71 24.26 31.75 24.24 31.75 24.17 31.75 24.15 31.25 24.24 31.23 24.24 31.23 24.26 31.21 24.29 31.11 24.33 31.04 24.4 30.97 24.47 30.92 24.59 30.97 24.68 30.99 24.7"/>
				<polygon class="cls-3" points="14.47 23.99 14.59 23.71 14.61 23.64 14.68 23.62 14.76 23.59 14.78 23.55 14.76 23.43 14.8 23.32 14.83 23.2 14.83 23.09 14.8 23 14.8 22.88 14.83 22.79 14.83 22.67 14.95 22.44 15.07 22.17 15.23 21.94 15.47 21.77 15.69 21.66 15.88 21.5 16.02 21.34 16.21 21.2 16.33 21.2 16.47 21.2 16.54 21.24 16.64 21.34 16.69 21.38 16.76 21.43 16.81 21.52 16.83 21.57 16.69 21.29 16.64 20.97 16.62 20.65 16.64 20.32 16.66 20.3 16.66 20.28 16.66 20.25 16.33 20.28 15.97 20.3 15.64 20.32 15.3 20.32 14.95 20.32 14.61 20.3 14.23 20.3 13.9 20.28 13.87 20.28 13.87 20.25 13.83 20.25 13.8 20.25 13.97 21.15 14.16 22.1 14.3 23.04 14.45 23.99 14.47 23.99"/>
				<polygon class="cls-3" points="22.98 23.99 23.17 23.73 23.36 23.55 23.6 23.32 23.79 23.09 23.55 22.17 23.53 22.12 23.51 22.12 23.48 22.12 23.46 22.21 23.48 22.33 23.51 22.44 23.53 22.51 23.53 22.53 23.51 22.58 23.48 22.6 23.41 22.6 23.36 22.6 23.34 22.58 23.31 22.53 23.31 22.51 23.24 22.49 23.22 22.47 23.17 22.47 23.08 22.37 22.96 22.3 22.89 22.21 22.81 22.07 22.89 21.96 22.65 21.77 22.62 21.8 22.6 21.82 22.55 21.84 22.5 21.84 22.48 21.84 22.46 21.84 22.41 21.84 22.39 21.82 22.36 21.75 22.31 21.64 22.24 21.54 22.12 21.52 21.98 21.5 21.84 21.47 21.69 21.41 21.6 21.36 21.67 21.57 21.79 21.8 21.88 22.05 21.96 22.33 22.08 22.53 22.19 22.77 22.34 23 22.46 23.18 22.6 23.36 22.7 23.57 22.84 23.76 22.96 23.99 22.98 23.99"/>
				<polygon class="cls-3" points="32.68 23.64 32.71 23.64 32.78 23.64 32.8 23.62 32.83 23.59 32.85 23.46 32.83 23.34 32.78 23.2 32.68 23.09 32.33 22.88 32.35 22.74 32.33 22.74 32.28 22.72 32.23 22.72 32.21 22.72 32.18 22.74 32.14 22.79 32.09 22.81 32.06 22.88 32.09 23 32.11 23.09 32.14 23.18 32.23 23.27 32.28 23.3 32.37 23.32 32.42 23.34 32.49 23.36 32.52 23.46 32.54 23.5 32.61 23.59 32.66 23.64 32.68 23.64"/>
				<polygon class="cls-3" points="28.08 22.86 28.56 22.77 28.68 22.49 28.8 22.21 28.94 21.94 29.13 21.71 29.25 21.71 29.37 21.71 29.49 21.75 29.61 21.75 29.68 21.75 29.8 21.75 29.92 21.71 29.99 21.68 30.11 21.5 30.2 21.27 30.25 21.06 30.28 20.83 30.09 20.6 30.04 20.32 29.99 20.05 29.85 19.82 29.85 19.77 29.82 19.72 29.82 19.7 29.8 19.68 29.75 19.61 29.66 19.59 29.61 19.56 29.54 19.49 29.54 19.4 29.61 19.29 29.63 19.19 29.66 19.08 29.68 19.06 29.68 19.03 29.8 18.99 29.82 18.94 29.82 18.89 29.82 18.87 29.8 18.8 29.75 18.73 29.68 18.62 29.68 18.53 29.68 18.43 29.7 18.39 29.7 18.36 29.7 18.34 29.75 18.32 29.47 18.2 29.35 18.09 29.23 17.95 29.11 17.83 28.96 17.74 28.92 17.67 28.89 17.6 28.82 17.56 28.75 17.54 28.61 17.51 28.49 17.49 28.34 17.49 28.2 17.51 28.13 17.47 28.08 17.4 28.06 17.35 28.04 17.28 27.89 17.21 27.77 17.12 27.68 17.01 27.63 16.84 27.65 16.73 27.75 16.68 27.82 16.66 27.94 16.66 28.06 16.66 28.11 16.68 28.13 16.68 28.2 16.68 28.23 16.68 28.23 16.66 28.2 16.66 28.18 16.66 28.13 16.64 28.11 16.57 28.08 16.54 28.06 16.52 27.46 16.57 27.46 16.59 27.42 16.59 27.42 16.64 27.53 16.73 27.65 17.35 27.56 17.47 27.49 17.56 27.37 17.65 27.22 17.74 27.11 17.81 26.96 17.88 26.82 17.93 26.68 17.97 26.63 17.97 26.56 18.02 26.51 18.02 26.46 18.04 26.27 18.39 26.13 18.46 25.98 18.57 25.89 18.66 25.77 18.8 25.7 19.15 25.68 19.47 25.63 19.82 25.6 20.14 25.6 20.16 25.56 20.18 25.53 20.23 25.51 20.23 25.41 20.23 25.34 20.23 25.25 20.18 25.2 20.14 25.13 19.98 25.08 19.82 25.03 19.63 24.91 19.54 24.82 19.68 24.79 19.7 24.75 19.7 24.65 19.68 24.63 19.63 24.53 19.59 24.46 19.56 24.36 19.56 24.27 19.59 24.1 19.75 24.03 19.95 23.93 20.16 23.84 20.37 23.79 20.39 23.74 20.42 23.7 20.44 23.65 20.51 23.67 20.53 23.7 20.55 23.77 20.55 23.82 20.55 23.96 20.53 24.1 20.51 24.24 20.46 24.39 20.44 24.53 20.42 24.67 20.42 24.82 20.39 24.96 20.39 24.98 20.39 25.06 20.32 25.08 20.3 25.1 20.28 25.27 20.3 25.32 20.32 25.36 20.39 25.39 20.44 25.39 20.53 25.41 20.53 25.48 20.46 25.56 20.42 25.6 20.37 25.63 20.28 25.63 20.16 25.63 20.09 25.65 20 25.7 19.91 25.98 19.86 26.08 20.14 26.22 20.25 26.1 20.46 25.96 20.67 25.84 20.88 25.79 21.15 25.77 21.22 25.7 21.27 25.63 21.29 25.56 21.29 25.53 21.29 25.51 21.27 25.48 21.27 25.46 21.24 25.46 21.22 25.46 21.2 25.41 21.15 25.41 21.13 25.39 21.13 25.39 21.15 25.36 21.15 25.36 21.2 25.63 21.54 25.77 21.38 25.91 21.2 26.08 21.06 26.32 20.95 26.34 20.83 26.39 20.39 26.51 20.28 26.7 20.23 26.89 20.23 27.08 20.18 27.32 20.18 27.53 20.23 27.75 20.28 27.92 20.39 27.92 20.42 27.94 20.42 27.94 20.44 27.94 20.51 27.92 20.53 27.89 20.58 27.84 20.6 27.96 20.78 27.65 21.43 27.65 21.52 27.65 21.61 27.63 21.68 27.56 21.77 27.53 21.77 27.51 21.8 27.46 21.96 27.37 22.05 27.27 22.1 27.18 22.12 27.06 22.17 26.94 22.17 26.82 22.19 26.7 22.21 26.6 22.24 26.53 22.24 26.49 22.24 26.41 22.24 26.37 22.24 26.46 22.35 26.6 22.44 26.77 22.51 26.91 22.6 27.06 22.65 27.2 22.67 27.37 22.74 27.51 22.77 27.65 22.79 27.8 22.79 27.94 22.81 28.08 22.86"/>
				<polygon class="cls-3" points="24.22 22.72 24.36 22.58 24.51 22.44 24.67 22.3 24.89 22.24 24.6 22.07 24.51 22.24 24.41 22.4 24.34 22.53 24.2 22.65 24.2 22.67 24.2 22.72 24.22 22.72"/>
				<polygon class="cls-3" points="17.81 22.21 17.88 22.05 17.95 21.91 18.05 21.77 18.17 21.66 18.17 21.64 18.07 21.52 17.97 21.38 17.95 21.24 17.97 21.08 18.07 20.92 18.09 20.74 18.17 20.58 18.21 20.42 18.45 20.28 18.33 20.28 18.21 20.3 18.07 20.32 17.95 20.3 17.83 20.3 17.76 20.28 17.64 20.25 17.55 20.18 17.69 20.65 17.78 21.13 17.81 21.64 17.81 22.12 17.81 22.17 17.81 22.19 17.81 22.21"/>
				<polygon class="cls-3" points="38.43 22.05 38.55 21.64 38.64 21.22 38.69 20.81 38.76 20.39 38.76 20.37 38.79 20.3 38.79 20.28 38.81 20.25 38.62 20.25 38.38 20.25 38.19 20.25 37.95 20.25 37.72 20.25 37.52 20.23 37.29 20.16 37.09 20.09 37.19 20.18 37.29 20.3 37.38 20.42 37.47 20.53 37.52 20.65 37.55 20.74 37.57 20.88 37.62 20.99 37.86 21.22 38.09 21.47 38.26 21.71 38.4 22.05 38.43 22.05"/>
				<polygon class="cls-1" points="4.31 21.52 4.53 20.58 4.89 19.72 5.32 18.92 5.79 18.18 6.32 17.47 6.82 16.77 7.34 16.04 7.82 15.32 8.06 14.93 8.25 14.52 8.44 14.1 8.61 13.64 8.77 13.2 8.89 12.72 9.01 12.26 9.08 11.82 8.75 12.37 8.32 12.86 7.82 13.36 7.29 13.82 6.75 14.31 6.22 14.79 5.77 15.3 5.36 15.85 5.17 16.13 5.01 16.45 4.86 16.8 4.72 17.12 4.62 17.49 4.51 17.83 4.46 18.23 4.39 18.59 4.36 18.62 4.39 17.14 4.46 15.67 4.39 14.15 4.15 12.65 4.08 11.68 4.15 10.65 4.36 9.68 4.79 8.83 4.74 8.83 4.67 8.85 4.62 8.92 4.58 8.96 4.46 9.13 4.34 9.26 4.22 9.45 4.1 9.59 4.03 9.75 3.91 9.89 3.81 10.05 3.72 10.21 3.34 10.85 3.05 11.55 2.79 12.24 2.62 12.97 2.53 13.73 2.48 14.47 2.5 15.21 2.62 15.97 2.79 16.68 3 17.37 3.24 18.04 3.5 18.73 3.77 19.4 4.01 20.09 4.17 20.78 4.29 21.5 4.29 21.52 4.29 21.54 4.31 21.52"/>
				<polygon class="cls-1" points="52.09 21.2 52.16 20.55 52.3 19.91 52.52 19.31 52.71 18.66 52.95 18.06 53.16 17.42 53.38 16.82 53.57 16.18 53.73 15.14 53.78 14.08 53.66 13.04 53.42 12.01 53.07 11.01 52.59 10.09 52.06 9.24 51.42 8.5 51.4 8.48 51.37 8.48 51.35 8.48 51.3 8.44 51.54 8.83 51.73 9.24 51.87 9.72 51.99 10.21 52.02 12.21 51.87 14.2 51.83 16.22 51.99 18.2 51.99 18.23 51.97 18.25 51.95 18.25 51.87 18.18 51.87 18.04 51.85 17.9 51.83 17.77 51.8 17.65 51.8 17.54 51.78 17.42 51.73 17.33 51.64 16.84 51.44 16.41 51.26 15.99 50.99 15.6 50.7 15.25 50.4 14.89 50.06 14.56 49.71 14.22 49.35 13.89 48.97 13.59 48.58 13.25 48.25 12.93 47.92 12.58 47.58 12.26 47.35 11.89 47.08 11.52 47.15 12.03 47.3 12.58 47.49 13.11 47.68 13.64 47.92 14.17 48.15 14.63 48.42 15.07 48.7 15.48 49.2 16.15 49.71 16.82 50.23 17.47 50.68 18.11 51.13 18.8 51.52 19.54 51.83 20.32 52.06 21.2 52.06 21.22 52.09 21.2"/>
				<polygon class="cls-3" points="16.69 19.31 16.64 18.5 16.76 17.7 16.97 16.87 17.21 16.08 17.45 15.48 17.69 14.93 17.95 14.45 18.24 13.94 18.55 13.48 18.88 13.04 19.24 12.56 19.64 12.12 19.38 11.89 19.12 11.68 18.88 11.43 18.62 11.17 18.36 10.97 18.12 10.71 17.88 10.44 17.66 10.18 17.36 10.65 17.02 11.11 16.66 11.55 16.35 11.96 16.04 12.4 15.76 12.83 15.47 13.34 15.23 13.82 14.95 14.47 14.68 15.14 14.49 15.83 14.33 16.52 14.16 17.21 14.04 17.9 13.95 18.59 13.9 19.29 14.23 19.29 14.59 19.29 14.95 19.26 15.3 19.26 15.64 19.26 16.02 19.26 16.35 19.29 16.69 19.31"/>
				<polygon class="cls-3" points="17.59 19.31 17.74 19.29 17.88 19.26 18.02 19.22 18.17 19.22 18.31 19.22 18.45 19.22 18.59 19.26 18.74 19.29 18.67 19.03 18.62 18.76 18.59 18.48 18.64 18.23 18.76 18.04 18.83 17.81 18.95 17.6 19.1 17.42 19.17 17.28 19.21 17.12 19.31 17.01 19.41 16.94 19.6 16.94 19.76 16.94 19.91 16.91 20.02 16.8 20.05 16.73 20.05 16.68 20.02 16.64 19.98 16.57 20.05 16.5 20.12 16.41 20.24 16.36 20.34 16.29 20.45 16.27 20.55 16.24 20.64 16.18 20.74 16.13 20.88 15.9 21.05 15.74 21.24 15.6 21.46 15.48 21.67 15.35 21.88 15.21 22.03 15.05 22.17 14.86 22.22 14.79 22.31 14.77 22.39 14.75 22.48 14.75 22.22 14.56 21.93 14.31 21.67 14.08 21.38 13.82 21.12 13.59 20.88 13.34 20.62 13.09 20.38 12.83 20.24 13 20.12 13.13 19.98 13.32 19.83 13.48 19.69 13.64 19.6 13.8 19.45 14.01 19.33 14.17 18.98 14.7 18.67 15.28 18.4 15.9 18.19 16.57 17.97 17.26 17.81 17.95 17.66 18.64 17.55 19.31 17.59 19.31"/>
				<polygon class="cls-3" points="10.01 19.31 10.37 19.29 10.75 19.26 11.09 19.26 11.47 19.26 11.82 19.26 12.21 19.26 12.54 19.29 12.92 19.29 12.97 17.93 13.21 16.59 13.54 15.3 14.04 14.03 14.61 12.83 15.26 11.71 16.02 10.69 16.83 9.75 16.9 9.72 16.93 9.68 16.97 9.66 17.02 9.63 16.78 9.4 16.52 9.17 16.26 8.92 15.97 8.67 15.73 8.41 15.47 8.13 15.23 7.86 15.04 7.56 14.76 7.86 14.49 8.13 14.23 8.44 13.97 8.76 13.73 9.06 13.49 9.38 13.25 9.68 13.04 10 12.66 10.58 12.32 11.15 11.97 11.75 11.68 12.37 11.37 13.04 11.11 13.69 10.89 14.38 10.66 15.12 10.54 15.48 10.47 15.88 10.37 16.24 10.3 16.64 10.18 17.28 10.11 17.95 10.06 18.62 10.01 19.31"/>
				<polygon class="cls-3" points="43.48 19.29 43.84 19.22 44.2 19.17 44.55 19.15 44.94 19.15 45.29 19.15 45.7 19.15 46.08 19.17 46.44 19.17 46.37 18.34 46.25 17.51 46.11 16.71 45.91 15.9 45.7 15.12 45.44 14.33 45.15 13.55 44.84 12.81 44.51 12.1 44.15 11.38 43.77 10.69 43.34 10.02 42.86 9.38 42.39 8.76 41.91 8.16 41.36 7.58 41.34 7.56 41.34 7.54 41.29 7.51 41.27 7.47 41.15 7.7 39.34 9.47 39.1 9.47 39.07 9.47 39.07 9.49 39.07 9.52 39.1 9.52 39.12 9.54 39.14 9.54 39.14 9.59 39.19 9.59 39.29 9.75 39.43 9.91 39.62 10.07 39.79 10.21 39.93 10.35 40.1 10.51 40.24 10.69 40.36 10.88 40.5 11.01 40.62 11.13 40.72 11.24 40.86 11.34 41 11.57 41.15 11.8 41.34 11.98 41.43 12.24 41.69 12.51 41.86 12.81 42.05 13.13 42.15 13.48 42.27 13.8 42.41 14.17 42.53 14.52 42.7 14.86 42.86 15.42 43.05 15.97 43.2 16.52 43.29 17.07 43.41 17.63 43.48 18.2 43.51 18.73 43.48 19.29"/>
				<polygon class="cls-3" points="39.81 19.22 40.15 19.19 40.5 19.17 40.84 19.17 41.19 19.17 41.53 19.17 41.86 19.17 42.22 19.17 42.55 19.17 42.48 18.66 42.41 18.2 42.34 17.67 42.27 17.19 42.15 16.66 42.05 16.15 41.86 15.62 41.69 15.14 41.58 14.89 41.5 14.61 41.38 14.38 41.24 14.2 41.1 14.24 40.93 14.31 40.76 14.31 40.62 14.29 40.53 14.05 40.33 13.87 40.15 13.64 39.98 13.46 39.79 13.25 39.65 13.13 39.5 13.06 39.36 12.97 39.22 12.9 39.07 12.83 38.93 12.77 38.79 12.67 38.64 12.56 38.43 12.49 38.29 12.37 38.19 12.24 38.09 12.1 38.09 12.03 38.09 12.01 38.09 11.96 38.07 11.94 37.93 11.87 37.78 11.84 37.62 11.82 37.5 11.73 37.38 11.71 37.29 11.61 37.24 11.55 37.19 11.43 37.09 11.01 37 10.6 36.85 10.23 36.57 9.95 36.5 9.93 36.38 9.91 36.28 9.93 36.21 9.95 36.09 10.05 35.97 10.14 35.83 10.16 35.69 10.16 35.62 10 35.54 9.79 35.52 9.63 35.38 9.47 35.35 9.31 35.4 9.13 35.43 8.96 35.4 8.8 35.23 8.69 35.12 8.5 35.04 8.27 34.97 8.06 34.95 7.97 34.92 7.88 34.85 7.81 34.83 7.72 34.54 7.44 34.21 7.24 33.83 7.03 33.42 6.84 32.99 6.71 32.56 6.57 32.11 6.45 31.68 6.32 31.35 6.22 30.99 6.18 30.68 6.13 30.35 6.06 30.04 6.02 29.7 5.99 29.37 5.95 29.06 5.92 29.04 5.92 28.96 5.92 28.94 5.92 28.92 5.92 28.56 5.81 28.63 6.45 28.65 7.14 28.63 7.83 28.56 8.5 28.56 8.52 28.61 8.52 28.99 8.52 29.39 8.55 29.8 8.62 30.2 8.67 30.61 8.76 30.97 8.83 31.37 8.94 31.78 9.06 32.14 9.2 32.52 9.33 32.9 9.49 33.25 9.63 33.61 9.79 33.92 10 34.23 10.16 34.54 10.35 34.61 10.42 34.66 10.48 34.71 10.55 34.81 10.58 34.69 10.44 34.57 10.3 34.47 10.16 34.38 9.95 34.38 9.93 34.38 9.91 34.4 9.91 34.49 9.89 34.47 9.68 34.35 9.54 34.23 9.4 34.14 9.24 34.14 9.2 34.18 9.17 34.23 9.13 34.26 9.1 34.28 9.1 34.33 9.1 34.35 9.1 34.49 9.22 34.61 9.33 34.71 9.47 34.83 9.59 34.92 9.68 35 9.82 35.12 9.93 35.23 10.05 35.4 10.05 35.57 10.09 35.69 10.21 35.83 10.32 35.9 10.51 35.95 10.69 36 10.88 36.09 11.04 36.24 11.41 36.5 11.68 36.69 11.98 36.78 12.35 36.85 12.37 36.95 12.37 37 12.42 37.09 12.51 37.21 12.67 37.36 12.81 37.47 12.95 37.52 13.13 37.5 13.2 37.5 13.23 37.5 13.27 37.52 13.32 37.55 13.34 37.57 13.36 37.62 13.41 37.64 13.46 37.81 13.48 37.95 13.41 38.09 13.34 38.26 13.27 38.33 13.32 38.36 13.34 38.4 13.41 38.43 13.48 38.43 13.62 38.38 13.69 38.33 13.8 38.26 13.92 38.26 13.94 38.29 13.97 38.4 13.94 38.5 13.92 38.62 13.92 38.69 13.97 38.71 14.03 38.71 14.08 38.69 14.17 38.67 14.22 38.62 14.29 38.57 14.33 38.52 14.36 38.5 14.38 38.52 14.61 38.55 14.61 38.57 14.63 38.67 14.63 38.79 14.63 38.86 14.7 38.95 14.75 39 14.93 39.1 15.14 39.14 15.35 39.22 15.55 39.07 15.95 39.1 16.36 39.12 16.77 39.05 17.14 38.91 17.4 38.79 17.67 38.67 17.95 38.48 18.18 38.43 18.25 38.38 18.32 38.36 18.36 38.26 18.39 38.14 18.43 38.07 18.43 37.95 18.46 37.83 18.48 37.78 18.57 37.78 18.71 37.81 18.8 37.83 18.92 37.9 19.03 37.83 19.15 37.81 19.17 38.83 19.19 38.71 18.99 38.69 18.73 38.69 18.46 38.71 18.2 38.86 17.88 38.98 17.54 39.12 17.24 39.24 16.94 39.34 16.84 39.41 16.8 39.5 16.73 39.57 16.71 39.62 16.71 39.65 16.73 39.65 16.8 39.67 16.82 39.67 17.05 39.65 17.28 39.57 17.51 39.5 17.74 39.67 18.06 39.76 18.43 39.79 18.85 39.79 19.22 39.81 19.22"/>
				<polygon class="cls-3" points="37.69 18.02 37.81 18.02 37.93 17.97 38.05 17.93 38.12 17.83 38.21 17.67 38.33 17.54 38.4 17.37 38.5 17.21 38.38 16.84 38.26 16.45 38.12 16.13 37.95 15.83 37.83 15.76 37.69 15.69 37.57 15.6 37.5 15.53 37.38 15.46 37.26 15.39 37.12 15.3 37 15.25 36.95 15.18 36.93 15.14 36.9 15.07 36.9 15 36.98 14.84 37.07 14.65 37.12 14.49 37.12 14.33 37 14.15 36.85 13.92 36.69 13.73 36.55 13.53 36.38 13.34 36.21 13.13 36.05 12.93 35.9 12.72 35.71 12.95 35.52 13.2 35.28 13.41 35.07 13.62 34.83 13.82 34.57 14.05 34.35 14.29 34.12 14.49 33.99 14.63 33.9 14.77 33.76 14.91 33.64 15.02 33.52 15.16 33.38 15.3 33.25 15.42 33.14 15.55 33.25 15.74 33.38 15.83 33.4 15.74 33.42 15.67 33.47 15.6 33.52 15.53 33.54 15.42 33.56 15.32 33.56 15.25 33.61 15.16 33.66 15.07 33.76 15.05 33.85 15 33.97 14.98 34.12 15.05 34.23 15.07 34.38 15.12 34.52 15.12 34.66 15.12 34.81 15.12 34.95 15.14 35.09 15.16 35.23 15.16 35.35 15.16 35.5 15.16 35.64 15.18 35.76 15.21 35.85 15.25 35.97 15.3 36.07 15.42 36.14 15.53 36.21 15.67 36.26 15.81 36.38 15.9 36.4 15.9 36.43 15.95 36.47 15.97 36.5 15.99 36.52 16.01 36.52 16.04 36.52 16.11 36.55 16.13 36.38 16.36 36.38 16.38 36.55 16.59 36.57 16.59 36.57 16.57 36.62 16.57 36.76 16.45 36.93 16.36 37.12 16.29 37.36 16.31 37.52 16.41 37.64 16.52 37.76 16.66 37.83 16.77 38.07 16.84 38.09 16.91 38.09 16.96 38.09 17.01 38.07 17.1 38 17.12 37.95 17.14 37.9 17.21 37.83 17.24 37.83 17.35 37.81 17.49 37.76 17.6 37.67 17.7 37.67 17.79 37.64 17.83 37.64 17.93 37.64 18.02 37.67 18.02 37.69 18.02"/>
				<polygon class="cls-3" points="30.51 16.64 30.9 16.54 30.92 16.52 30.92 16.41 30.94 16.31 30.99 16.24 31.09 16.15 31.23 16.01 31.4 15.9 31.56 15.81 31.75 15.71 31.9 15.6 32.06 15.48 32.21 15.35 32.33 15.18 32.14 15.21 31.92 15.07 31.9 15.05 31.9 15 31.9 14.93 31.92 14.91 32.06 14.86 32.18 14.75 32.33 14.63 32.47 14.59 32.35 14.52 32.23 14.47 32.11 14.38 31.99 14.33 31.9 14.29 31.8 14.2 31.68 14.15 31.56 14.08 31.25 13.89 30.92 13.76 30.54 13.62 30.13 13.5 29.75 13.39 29.37 13.32 28.96 13.23 28.61 13.13 28.65 13.62 28.68 14.05 28.65 14.52 28.68 15 29.39 15.28 29.54 15.14 29.7 14.98 29.89 14.86 30.11 14.75 30.13 14.7 30.2 14.63 30.25 14.59 30.35 14.56 30.4 14.56 30.49 14.61 30.54 14.63 30.56 14.7 30.61 14.93 30.56 15.16 30.49 15.39 30.4 15.58 30.28 15.69 30.2 15.76 30.09 15.83 29.97 15.9 29.89 15.97 29.78 16.01 29.66 16.08 29.54 16.13 29.27 16.31 29.27 16.36 29.49 16.36 29.63 16.27 29.78 16.22 29.97 16.24 30.09 16.29 30.18 16.38 30.25 16.43 30.35 16.5 30.37 16.54 30.4 16.57 30.47 16.59 30.51 16.64"/>
				<polygon class="cls-3" points="25.68 16.01 26.13 15.9 26.2 15.83 26.25 15.74 26.27 15.67 26.37 15.58 26.39 15.39 26.41 15.18 26.51 15.02 26.65 14.89 26.68 14.86 26.75 14.86 26.77 14.86 26.8 14.86 26.84 14.91 26.84 15 26.82 15.07 26.82 15.16 26.99 15.18 27.18 15.16 27.34 15.12 27.51 15.07 27.68 15.21 27.65 15.14 27.63 15.02 27.61 14.91 27.56 14.79 27.53 14.38 27.53 14.01 27.53 13.62 27.56 13.2 27.03 13.27 26.49 13.41 25.94 13.55 25.46 13.76 24.96 14.01 24.51 14.24 24.08 14.56 23.7 14.89 23.65 14.93 23.62 14.98 23.55 15.02 23.51 15.05 23.7 15.07 24.24 15.32 24.48 15.55 24.48 15.58 24.48 15.6 24.48 15.62 24.46 15.69 24.39 15.71 24.34 15.74 24.32 15.81 24.51 15.95 24.6 15.95 24.63 15.88 24.65 15.85 24.65 15.81 24.67 15.76 24.67 15.74 24.7 15.74 24.75 15.71 24.77 15.71 24.89 15.74 24.96 15.81 25.03 15.9 25.13 15.97 25.22 15.97 25.32 15.95 25.39 15.9 25.48 15.88 25.51 15.9 25.53 15.9 25.56 15.95 25.6 15.97 25.65 16.04 25.68 16.01"/>
				<polygon class="cls-1" points="5.08 15.18 5.44 14.63 5.82 14.15 6.29 13.64 6.77 13.2 7.25 12.77 7.77 12.31 8.3 11.89 8.8 11.45 9.32 11.01 9.77 10.55 10.2 10.07 10.58 9.54 10.89 8.99 11.16 8.39 11.32 7.72 11.4 7.01 11.18 7.42 10.89 7.83 10.54 8.23 10.2 8.62 9.8 8.94 9.39 9.24 8.96 9.54 8.58 9.79 8.15 10.09 7.75 10.44 7.34 10.78 6.96 11.15 6.63 11.57 6.32 11.98 6.06 12.42 5.86 12.9 5.82 12.9 5.79 12.9 5.91 12.49 6.03 12.03 6.17 11.61 6.34 11.17 6.48 10.74 6.6 10.3 6.72 9.89 6.79 9.45 6.82 9.24 6.89 9.08 6.91 8.92 6.94 8.76 7.03 8.34 7.15 7.95 7.25 7.56 7.39 7.19 7.58 6.84 7.77 6.5 8.01 6.2 8.25 5.92 8.82 5.46 8.37 5.6 7.94 5.76 7.53 6.02 7.18 6.27 6.79 6.57 6.48 6.89 6.17 7.26 5.89 7.6 5.39 8.48 5.15 9.38 5.03 10.35 5.01 11.32 5.05 12.28 5.1 13.27 5.1 14.24 5.05 15.18 5.08 15.18"/>
				<polygon class="cls-1" points="51.23 14.86 51.13 13.97 51.11 13.06 51.11 12.17 51.16 11.27 51.21 10.69 51.16 10.09 51.09 9.52 50.97 8.94 50.8 8.39 50.56 7.86 50.28 7.37 49.97 6.96 49.66 6.61 49.37 6.32 49.06 6.04 48.7 5.79 48.37 5.6 48.01 5.39 47.63 5.25 47.2 5.16 47.58 5.44 47.94 5.76 48.23 6.13 48.49 6.5 48.68 6.96 48.87 7.42 49.01 7.88 49.13 8.39 49.25 8.92 49.37 9.45 49.51 9.95 49.68 10.48 49.85 10.99 50.06 11.52 50.23 12.01 50.42 12.51 50.42 12.54 50.4 12.54 50.4 12.56 50.37 12.56 50.35 12.54 50.06 11.94 49.68 11.38 49.23 10.85 48.73 10.37 48.2 9.93 47.66 9.52 47.11 9.17 46.56 8.83 46.25 8.62 45.96 8.39 45.7 8.13 45.44 7.88 45.22 7.6 45.01 7.3 44.84 7.03 44.67 6.73 44.72 7.17 44.84 7.6 44.98 8.06 45.15 8.5 45.34 8.92 45.56 9.31 45.8 9.66 46.06 10 46.37 10.32 46.68 10.62 47.01 10.9 47.37 11.2 47.73 11.48 48.09 11.75 48.44 12.01 48.8 12.28 49.16 12.56 49.51 12.86 49.82 13.13 50.13 13.46 50.44 13.78 50.7 14.15 50.97 14.49 51.21 14.89 51.23 14.86"/>
				<polygon class="cls-3" points="33.25 14.01 33.5 13.76 33.71 13.5 33.95 13.25 34.21 12.97 34.47 12.72 34.76 12.49 35 12.28 35.28 12.12 35.26 12.1 35.21 12.08 35.14 12.03 35.09 12.03 34.78 11.8 34.47 11.55 34.12 11.32 33.76 11.11 33.38 10.88 32.97 10.69 32.56 10.48 32.18 10.32 31.75 10.18 31.32 10.02 30.9 9.91 30.42 9.79 29.99 9.68 29.54 9.61 29.08 9.54 28.63 9.49 28.61 9.47 28.56 9.47 28.63 10.14 28.65 10.78 28.63 11.48 28.63 12.14 29.25 12.21 29.89 12.31 30.49 12.44 31.09 12.67 31.66 12.93 32.21 13.2 32.68 13.5 33.14 13.82 33.19 13.87 33.21 13.92 33.23 13.94 33.23 14.01 33.25 14.01"/>
				<polygon class="cls-3" points="23.1 14.01 23.1 14.01 23.1 13.97 23.36 13.73 23.65 13.5 23.96 13.27 24.27 13.09 24.63 12.93 24.96 12.77 25.34 12.63 25.7 12.49 25.94 12.42 26.18 12.35 26.39 12.28 26.65 12.24 26.89 12.21 27.11 12.17 27.34 12.14 27.56 12.17 27.53 11.52 27.51 10.83 27.53 10.16 27.61 9.47 27.13 9.52 26.7 9.61 26.27 9.68 25.82 9.79 25.39 9.91 24.96 10.05 24.55 10.18 24.17 10.32 23.77 10.48 23.36 10.69 22.98 10.85 22.62 11.06 22.27 11.27 21.93 11.48 21.62 11.73 21.31 11.98 21.22 12.01 21.17 12.08 21.12 12.1 21.07 12.14 21.34 12.35 21.6 12.56 21.84 12.79 22.1 13.04 22.36 13.27 22.6 13.53 22.84 13.78 23.08 14.01 23.1 14.01"/>
				<polygon class="cls-3" points="20.34 11.48 20.36 11.48 20.36 11.45 20.38 11.45 20.62 11.24 20.88 11.01 21.12 10.83 21.38 10.6 21.65 10.44 21.91 10.23 22.19 10.07 22.48 9.93 22.77 9.77 23.05 9.63 23.36 9.49 23.67 9.36 23.98 9.24 24.34 9.13 24.67 9.03 25.03 8.92 25.34 8.83 25.65 8.76 25.96 8.69 26.27 8.64 26.6 8.57 26.94 8.55 27.22 8.52 27.53 8.52 27.53 7.88 27.51 7.26 27.51 6.59 27.53 5.95 27.53 5.92 27.06 5.95 26.56 5.99 26.06 6.04 25.56 6.13 25.08 6.22 24.55 6.34 24.08 6.48 23.6 6.61 23.1 6.78 22.65 6.96 22.19 7.14 21.77 7.37 21.34 7.56 20.91 7.79 20.53 8 20.17 8.25 19.93 8.39 19.69 8.55 19.48 8.76 19.26 8.92 19.05 9.1 18.81 9.26 18.59 9.4 18.36 9.54 18.33 9.54 18.33 9.59 18.36 9.59 18.62 9.77 18.88 9.95 19.12 10.21 19.38 10.44 19.64 10.69 19.91 10.97 20.12 11.2 20.34 11.45 20.34 11.48"/>
				<polygon class="cls-1" points="7.44 9.82 7.77 9.52 8.15 9.22 8.49 8.94 8.87 8.64 9.23 8.36 9.58 8.02 9.94 7.72 10.3 7.37 10.75 6.82 11.18 6.27 11.59 5.67 11.97 5.12 12.44 4.56 12.9 4.06 13.4 3.5 14.02 2.97 13.52 3.14 13.04 3.3 12.54 3.5 12.09 3.69 11.63 3.92 11.18 4.13 10.78 4.38 10.37 4.66 9.96 4.95 9.63 5.25 9.3 5.62 9.01 5.99 8.73 6.36 8.46 6.78 8.25 7.26 8.08 7.72 7.94 8.27 7.8 8.83 7.6 9.36 7.39 9.86 7.44 9.82"/>
				<polygon class="cls-1" points="48.7 9.52 48.54 8.85 48.35 8.25 48.11 7.65 47.84 7.05 47.53 6.55 47.23 6.02 46.84 5.53 46.42 5.09 45.99 4.68 45.51 4.29 45.01 3.94 44.49 3.64 43.91 3.32 43.29 3.09 42.65 2.86 41.98 2.7 42.43 3.14 42.84 3.57 43.27 4.01 43.65 4.47 44.06 4.93 44.41 5.37 44.8 5.85 45.2 6.29 45.56 6.73 45.96 7.17 46.37 7.6 46.8 8.02 47.23 8.41 47.68 8.8 48.2 9.17 48.7 9.52"/>
				<polygon class="cls-3" points="17.74 8.92 18.05 8.62 18.36 8.29 18.69 8.02 19.02 7.79 19.36 7.54 19.69 7.3 20.05 7.1 20.41 6.87 20.76 6.68 21.12 6.5 21.53 6.32 21.93 6.15 22.34 5.99 22.74 5.81 23.17 5.64 23.62 5.51 23.65 5.51 23.67 5.51 24.17 5.35 24.63 5.23 25.1 5.12 25.6 5.02 26.08 4.95 26.6 4.91 27.08 4.89 27.56 4.84 27.51 4.66 27.49 4.47 27.46 4.24 27.46 4.06 27.46 3.83 27.46 3.6 27.46 3.39 27.46 3.16 27.46 2.91 27.46 2.63 27.46 2.4 27.51 2.14 26.75 2.19 25.98 2.26 25.22 2.35 24.48 2.49 23.74 2.7 22.98 2.88 22.24 3.11 21.55 3.37 20.84 3.64 20.17 3.94 19.5 4.24 18.88 4.61 18.26 4.95 17.69 5.35 17.12 5.74 16.62 6.15 16.47 6.27 16.35 6.34 16.23 6.48 16.09 6.59 15.97 6.71 15.83 6.78 15.69 6.87 15.54 6.96 15.83 7.12 16.16 7.33 16.45 7.58 16.69 7.83 16.97 8.11 17.24 8.39 17.5 8.67 17.74 8.92"/>
				<polygon class="cls-3" points="38.79 8.64 38.93 8.39 39.1 8.16 39.29 7.93 39.5 7.7 39.72 7.47 39.98 7.28 40.22 7.1 40.48 6.91 40.5 6.91 40.53 6.89 40.43 6.78 40.29 6.68 40.19 6.55 40.05 6.43 39.5 5.95 38.91 5.51 38.29 5.09 37.67 4.7 36.98 4.36 36.28 3.99 35.57 3.69 34.83 3.39 34.09 3.14 33.33 2.88 32.54 2.7 31.78 2.49 30.97 2.33 30.18 2.21 29.37 2.12 28.56 2.05 28.61 2.12 28.63 2.19 28.65 2.28 28.63 2.4 28.63 2.95 28.63 3.5 28.63 4.01 28.56 4.56 28.65 4.4 28.68 4.38 28.7 4.36 28.75 4.36 28.8 4.36 28.85 4.38 28.92 4.42 28.96 4.52 28.99 4.56 28.99 4.66 28.99 4.75 28.99 4.82 28.96 4.89 28.94 4.89 28.94 4.91 29.47 4.91 29.97 4.93 30.51 4.98 31.06 5.09 31.56 5.21 32.11 5.35 32.64 5.51 33.14 5.67 33.35 5.76 33.54 5.85 33.76 5.92 33.95 6.02 34.14 6.08 34.35 6.18 34.54 6.27 34.71 6.34 35.21 6.59 35.23 6.61 35.23 6.59 35.23 6.57 35.26 6.57 35.47 6.45 35.66 6.41 35.85 6.36 36.07 6.36 36.26 6.41 36.47 6.45 36.67 6.48 36.85 6.5 37 6.64 37.12 6.78 37.26 6.91 37.43 6.98 37.57 7.03 37.69 7.12 37.78 7.24 37.9 7.33 37.98 7.44 38.09 7.56 38.19 7.67 38.29 7.74 38.36 8.02 38.48 8.25 38.62 8.44 38.79 8.64"/>
				<polygon class="cls-1" points="37.41 6.71 37.64 6.71 37.67 6.71 37.69 6.68 37.72 6.64 37.72 6.61 37.67 6.45 37.62 6.27 37.57 6.08 37.5 5.92 37.38 5.88 37.24 5.85 37.12 5.85 36.98 5.88 36.93 5.85 36.85 5.81 36.81 5.79 36.76 5.81 36.71 5.85 36.69 5.85 36.67 5.85 36.64 5.88 36.64 5.99 36.67 6.06 36.69 6.15 36.78 6.2 36.93 6.29 37.05 6.41 37.14 6.5 37.24 6.61 37.41 6.71"/>
				<polygon class="cls-1" points="29.63 4.66 29.8 4.66 29.97 4.63 30.13 4.63 30.28 4.63 30.42 4.56 30.56 4.54 30.68 4.52 30.8 4.49 30.99 4.49 31.21 4.49 31.4 4.49 31.56 4.47 31.78 4.42 31.94 4.36 32.09 4.26 32.23 4.15 32.23 4.13 32.25 4.13 32.25 4.1 32.25 4.06 32.23 4.01 32.18 3.96 32.14 3.94 31.99 3.85 31.85 3.78 31.68 3.69 31.52 3.64 31.35 3.57 31.13 3.55 30.97 3.53 30.78 3.53 30.61 3.6 30.42 3.67 30.23 3.73 30.04 3.83 29.85 3.92 29.68 3.99 29.51 4.06 29.32 4.1 29.25 4.08 29.2 4.06 29.11 4.06 29.06 4.08 29.04 4.1 28.99 4.13 28.96 4.15 28.94 4.22 29.08 4.36 29.25 4.47 29.42 4.56 29.63 4.66"/>
			</g>
		</svg>
	</xsl:variable>

	<xsl:variable name="Image-Recycle">
		<xsl:text>iVBORw0KGgoAAAANSUhEUgAAAJkAAAAmCAYAAADXwDkaAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA+lpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNi1jMDE0IDc5LjE1Njc5NywgMjAxNC8wOC8yMC0wOTo1MzowMiAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczpkYz0iaHR0cDovL3B1cmwub3JnL2RjL2VsZW1lbnRzLzEuMS8iIHhtbG5zOnhtcE1NPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvbW0vIiB4bWxuczpzdFJlZj0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL3NUeXBlL1Jlc291cmNlUmVmIyIgeG1wOkNyZWF0b3JUb29sPSJNaWNyb3NvZnTCriBXb3JkIDIwMTYiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6MzM0NUVBQ0U2RUMzMTFFQUIzQjg4RDg3OEE1NEI2QzAiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6MzM0NUVBQ0Y2RUMzMTFFQUIzQjg4RDg3OEE1NEI2QzAiPiA8ZGM6Y3JlYXRvcj4gPHJkZjpTZXE+IDxyZGY6bGk+RGhhbmplZTwvcmRmOmxpPiA8L3JkZjpTZXE+IDwvZGM6Y3JlYXRvcj4gPGRjOnRpdGxlPiA8cmRmOkFsdD4gPHJkZjpsaSB4bWw6bGFuZz0ieC1kZWZhdWx0Ij4xODAxNzYzPC9yZGY6bGk+IDwvcmRmOkFsdD4gPC9kYzp0aXRsZT4gPHhtcE1NOkRlcml2ZWRGcm9tIHN0UmVm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</xsl:text>
	</xsl:variable>
	
</xsl:stylesheet>
