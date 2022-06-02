<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
											xmlns:fo="http://www.w3.org/1999/XSL/Format" 
											xmlns:un="https://www.metanorma.org/ns/un" 
											xmlns:mathml="http://www.w3.org/1998/Math/MathML" 
											xmlns:xalan="http://xml.apache.org/xalan" 
											xmlns:fox="http://xmlgraphics.apache.org/fop/extensions" 
											xmlns:barcode="http://barcode4j.krysalis.org/ns" 
											xmlns:java="http://xml.apache.org/xalan/java" 
											exclude-result-prefixes="java"
											version="1.0">

	<xsl:output version="1.0" method="xml" encoding="UTF-8" indent="no"/>

	<xsl:key name="kfn" match="*[local-name() = 'fn'][not(ancestor::*[(local-name() = 'table' or local-name() = 'figure') and not(ancestor::*[local-name() = 'name'])])]" use="@reference"/>
	
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
				<!-- Document even pages -->
				<fo:simple-page-master master-name="even" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
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
												<fo:external-graphic src="{concat('data:image/png;base64,', normalize-space($Image-Logo))}" width="28mm" content-height="scale-to-fit" scaling="uniform" fox:alt-text="Image Front"/>
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
					
					<fo:block-container absolute-position="fixed" left="20mm" top="258mm" width="30mm" text-align="center">
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
			
			
			<!-- Document Pages -->
			<fo:page-sequence master-reference="document" initial-page-number="2" format="1" force-page-count="no-force" line-height="115%">
				<fo:static-content flow-name="xsl-footnote-separator">
					<fo:block-container margin-left="-8mm">
						<fo:block margin-left="8mm">
							<fo:leader leader-pattern="rule" leader-length="20%"/>
						</fo:block>
					</fo:block-container>
				</fo:static-content>
				<xsl:call-template name="insertHeaderFooter"/>
				<fo:flow flow-name="xsl-region-body">
					
					<xsl:if test="$debug = 'true'">
						<xsl:text disable-output-escaping="yes">&lt;!--</xsl:text>
							DEBUG
							contents=<xsl:copy-of select="$contents"/>
						<xsl:text disable-output-escaping="yes">--&gt;</xsl:text>
					</xsl:if>
					
					<!-- Preface Pages (except Abstract, that showed in Summary on cover page`) -->
					<xsl:if test="/un:un-standard/un:preface/*[not(local-name() = 'abstract' or local-name() != 'note' or local-name() != 'admonition')]">
						<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='foreword']" />
						<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='introduction']" />
						<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name() != 'abstract' and local-name() != 'foreword' and local-name() != 'introduction' and local-name() != 'acknowledgements' and local-name() != 'note' and local-name() != 'admonition']" />
						<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='acknowledgements']" />
						<fo:block break-after="page"/>
					</xsl:if>
					
					<fo:block>
						<xsl:apply-templates select="/un:un-standard/un:sections/*"/>
						<xsl:apply-templates select="/un:un-standard/un:annex"/>
						<xsl:apply-templates select="/un:un-standard/un:bibliography/un:references"/>
					</fo:block>
					
					<fo:block-container margin-left="50mm" width="30mm" border-bottom="0.5pt solid black" margin-top="12pt" keep-with-previous="always">
						<fo:block>&#xA0;</fo:block>
					</fo:block-container>
					
				</fo:flow>
			</fo:page-sequence>
			<!-- End Document Pages -->
			
		</fo:root>
	</xsl:template> 



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
						<fo:table-cell padding-left="6mm" padding-top="2.5mm">
							<fo:block font-size="12pt" font-style="italic" margin-bottom="6pt" role="H2">
								<xsl:apply-templates select="un:title/node()"/>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell>
							<fo:block>&#xA0;</fo:block>
						</fo:table-cell>
						<fo:table-cell>
							<fo:block>&#xA0;</fo:block>
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
			<xsl:attribute name="text-align">
				<xsl:choose>
					<xsl:when test="@align"><xsl:value-of select="@align"/></xsl:when>
					<xsl:otherwise>justify</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
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
		<fo:block-container id="{@id}">
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


	
	<xsl:template match="un:dl" priority="2">
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


	<xsl:variable name="Image-Logo">
		<xsl:text>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/GMzLdsAADsgaVRYdFhNTDpjb20uYWRvYmUueG1wAAAAAAA8P3hwYWNrZXQgYmVnaW49Iu+7vyIgaWQ9Ilc1TTBNcENlaGlIenJlU3pOVGN6a2M5ZCI/Pgo8eDp4bXBtZXRhIHhtbG5zOng9ImFkb2JlOm5zOm1ldGEvIiB4OnhtcHRrPSJBZG9iZSBYTVAgQ29yZSA1LjYtYzAxNCA3OS4xNTY3OTcsIDIwMTQvMDgvMjAtMDk6NTM6MDIgICAgICAgICI+CiAgIDxyZGY6UkRGIHhtbG5zOnJkZj0iaHR0cDovL3d3dy53My5vcmcvMTk5OS8wMi8yMi1yZGYtc3ludGF4LW5zIyI+CiAgICAgIDxyZGY6RGVzY3JpcHRpb24gcmRmOmFib3V0PSIiCiAgICAgICAgICAgIHhtbG5zOnhtcD0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wLyIKICAgICAgICAgICAgeG1sbnM6ZGM9Imh0dHA6Ly9wdXJsLm9yZy9kYy9lbGVtZW50cy8xLjEvIgogICAgICAgICAgICB4bWxuczpwaG90b3Nob3A9Imh0dHA6Ly9ucy5hZG9iZS5jb20vcGhvdG9zaG9wLzEuMC8iCiAgICAgICAgICAgIHhtbG5zOnhtcE1NPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvbW0vIgogICAgICAgICAgICB4bWxuczpzdEV2dD0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL3NUeXBlL1Jlc291cmNlRXZlbnQjIgogICAgICAgICAgICB4bWxuczp0aWZmPSJodHRwOi8vbnMuYWRvYmUuY29tL3RpZmYvMS4wLyIKICAgICAgICAgICAgeG1sbnM6ZXhpZj0iaHR0cDovL25zLmFkb2JlLmNvbS9leGlmLzEuMC8iPgogICAgICAgICA8eG1wOkNyZWF0b3JUb29sPkFkb2JlIFBob3Rvc2hvcCBDQyAyMDE0IChXaW5kb3dzKTwveG1wOkNyZWF0b3JUb29sPgogICAgICAgICA8eG1wOkNyZWF0ZURhdGU+MjAyMC0wMy0yNVQyMTowNTo0MSswMzowMDwveG1wOkNyZWF0ZURhdGU+CiAgICAgICAgIDx4bXA6TW9kaWZ5RGF0ZT4yMDIwLTAzLTI1VDIxOjA3OjQzKzAzOjAwPC94bXA6TW9kaWZ5RGF0ZT4KICAgICAgICAgPHhtcDpNZXRhZGF0YURhdGU+MjAyMC0wMy0yNVQyMTowNzo0MyswMzowMDwveG1wOk1ldGFkYXRhRGF0ZT4KICAgICAgICAgPGRjOmZvcm1hdD5pbWFnZS9wbmc8L2RjOmZvcm1hdD4KICAgICAgICAgPHBob3Rvc2hvcDpDb2xvck1vZGU+MzwvcGhvdG9zaG9wOkNvbG9yTW9kZT4KICAgICAgICAgPHBob3Rvc2hvcDpJQ0NQcm9maWxlPnNSR0IgSUVDNjE5NjYtMi4xPC9waG90b3Nob3A6SUNDUHJvZmlsZT4KICAgICAgICAgPHhtcE1NOkluc3RhbmNlSUQ+eG1wLmlpZDpjMTQ1NzAyOS1iYTI0LWIwNDYtYmU5NC0wOTY5ZDRkOGRkNTE8L3htcE1NOkluc3RhbmNlSUQ+CiAgICAgICAgIDx4bXBNTTpEb2N1bWVudElEPmFkb2JlOmRvY2lkOnBob3Rvc2hvcDo4NWRmOTdiMi02ZWMzLTExZWEtOGRjNC1kOTAxZWM0NGU2YWM8L3htcE1NOkRvY3VtZW50SUQ+CiAgICAgICAgIDx4bXBNTTpPcmlnaW5hbERvY3VtZW50SUQ+eG1wLmRpZDo3NTMzOTU5ZS1hYzZjLTQwNGYtOWZlNi0wZDg0ZGNkOGRkZGQ8L3htcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD4KICAgICAgICAgPHhtcE1NOkhpc3Rvcnk+CiAgICAgICAgICAgIDxyZGY6U2VxPgogICAgICAgICAgICAgICA8cmRmOmxpIHJkZjpwYXJzZVR5cGU9IlJlc291cmNlIj4KICAgICAgICAgICAgICAgICAgPHN0RXZ0OmFjdGlvbj5jcmVhdGVkPC9zdEV2dDphY3Rpb24+CiAgICAgICAgICAgICAgICAgIDxzdEV2dDppbnN0YW5jZUlEPnhtcC5paWQ6NzUzMzk1OWUtYWM2Yy00MDRmLTlmZTYtMGQ4NGRjZDhkZGRkPC9zdEV2dDppbnN0YW5jZUlEPgogICAgICAgICAgICAgICAgICA8c3RFdnQ6d2hlbj4yMDIwLTAzLTI1VDIxOjA1OjQxKzAzOjAwPC9zdEV2dDp3aGVuPgogICAgICAgICAgICAgICAgICA8c3RFdnQ6c29mdHdhcmVBZ2VudD5BZG9iZSBQaG90b3Nob3AgQ0MgMjAxNCAoV2luZG93cyk8L3N0RXZ0OnNvZnR3YXJlQWdlbnQ+CiAgICAgICAgICAgICAgIDwvcmRmOmxpPgogICAgICAgICAgICAgICA8cmRmOmxpIHJkZjpwYXJzZVR5cGU9IlJlc291cmNlIj4KICAgICAgICAgICAgICAgICAgPHN0RXZ0OmFjdGlvbj5jb252ZXJ0ZWQ8L3N0RXZ0OmFjdGlvbj4KICAgICAgICAgICAgICAgICAgPHN0RXZ0OnBhcmFtZXRlcnM+ZnJvbSBhcHBsaWNhdGlvbi92bmQuYWRvYmUucGhvdG9zaG9wIHRvIGltYWdlL3BuZzwvc3RFdnQ6cGFyYW1ldGVycz4KICAgICAgICAgICAgICAgPC9yZGY6bGk+CiAgICAgICAgICAgICAgIDxyZGY6bGkgcmRmOnBhcnNlVHlwZT0iUmVzb3VyY2UiPgogICAgICAgICAgICAgICAgICA8c3RFdnQ6YWN0aW9uPnNhdmVkPC9zdEV2dDphY3Rpb24+CiAgICAgICAgICAgICAgICAgIDxzdEV2dDppbnN0YW5jZUlEPnhtcC5paWQ6YzE0NTcwMjktYmEyNC1iMDQ2LWJlOTQtMDk2OWQ0ZDhkZDUxPC9zdEV2dDppbnN0YW5jZUlEPgogICAgICAgICAgICAgICAgICA8c3RFdnQ6d2hlbj4yMDIwLTAzLTI1VDIxOjA3OjQzKzAzOjAwPC9zdEV2dDp3aGVuPgogICAgICAgICAgICAgICAgICA8c3RFdnQ6c29mdHdhcmVBZ2VudD5BZG9iZSBQaG90b3Nob3AgQ0MgMjAxNCAoV2luZG93cyk8L3N0RXZ0OnNvZnR3YXJlQWdlbnQ+CiAgICAgICAgICAgICAgICAgIDxzdEV2dDpjaGFuZ2VkPi88L3N0RXZ0OmNoYW5nZWQ+CiAgICAgICAgICAgICAgIDwvcmRmOmxpPgogICAgICAgICAgICA8L3JkZjpTZXE+CiAgICAgICAgIDwveG1wTU06SGlzdG9yeT4KICAgICAgICAgPHRpZmY6T3JpZW50YXRpb24+MTwvdGlmZjpPcmllbnRhdGlvbj4KICAgICAgICAgPHRpZmY6WFJlc29sdXRpb24+MzAwMDAwMC8xMDAwMDwvdGlmZjpYUmVzb2x1dGlvbj4KICAgICAgICAgPHRpZmY6WVJlc29sdXRpb24+MzAwMDAwMC8xMDAwMDwvdGlmZjpZUmVzb2x1dGlvbj4KICAgICAgICAgPHRpZmY6UmVzb2x1dGlvblVuaXQ+MjwvdGlmZjpSZXNvbHV0aW9uVW5pdD4KICAgICAgICAgPGV4aWY6Q29sb3JTcGFjZT4xPC9leGlmOkNvbG9yU3BhY2U+CiAgICAgICAgIDxleGlmOlBpeGVsWERpbWVuc2lvbj4yMjU8L2V4aWY6UGl4ZWxYRGltZW5zaW9uPgogICAgICAgICA8ZXhpZjpQaXhlbFlEaW1lbnNpb24+MTgwPC9leGlmOlBpeGVsWURpbWVuc2lvbj4KICAgICAgPC9yZGY6RGVzY3JpcHRpb24+CiAgIDwvcmRmOlJERj4KPC94OnhtcG1ldGE+CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgCjw/eHBhY2tldCBlbmQ9InciPz4xznjNAAAAIGNIUk0AAHolAACAgwAA+f8AAIDpAAB1MAAA6mAAADqYAAAXb5JfxUYAAFWJSURBVHja7F1nWBVHFz50sCCxghUFFOzG2EuIBTti7OKnRI01xhrFEmOMRmOP3aixE1vsGmOvKMaCqNhQUBBBUBAREYTz/di5uHd2Zsu9l2LCeZ55Ermzs7Ozc3ZmznnPe8wg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</xsl:text>
	</xsl:variable>

	<xsl:variable name="Image-Recycle">
		<xsl:text>iVBORw0KGgoAAAANSUhEUgAAAJkAAAAmCAYAAADXwDkaAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA+lpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNi1jMDE0IDc5LjE1Njc5NywgMjAxNC8wOC8yMC0wOTo1MzowMiAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczpkYz0iaHR0cDovL3B1cmwub3JnL2RjL2VsZW1lbnRzLzEuMS8iIHhtbG5zOnhtcE1NPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvbW0vIiB4bWxuczpzdFJlZj0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL3NUeXBlL1Jlc291cmNlUmVmIyIgeG1wOkNyZWF0b3JUb29sPSJNaWNyb3NvZnTCriBXb3JkIDIwMTYiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6MzM0NUVBQ0U2RUMzMTFFQUIzQjg4RDg3OEE1NEI2QzAiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6MzM0NUVBQ0Y2RUMzMTFFQUIzQjg4RDg3OEE1NEI2QzAiPiA8ZGM6Y3JlYXRvcj4gPHJkZjpTZXE+IDxyZGY6bGk+RGhhbmplZTwvcmRmOmxpPiA8L3JkZjpTZXE+IDwvZGM6Y3JlYXRvcj4gPGRjOnRpdGxlPiA8cmRmOkFsdD4gPHJkZjpsaSB4bWw6bGFuZz0ieC1kZWZhdWx0Ij4xODAxNzYzPC9yZGY6bGk+IDwvcmRmOkFsdD4gPC9kYzp0aXRsZT4gPHhtcE1NOkRlcml2ZWRGcm9tIHN0UmVm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</xsl:text>
	</xsl:variable>
	
</xsl:stylesheet>
