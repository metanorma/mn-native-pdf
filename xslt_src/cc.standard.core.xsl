<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
											xmlns:fo="http://www.w3.org/1999/XSL/Format" 
											xmlns:csd="https://www.metanorma.org/ns/csd" 
											xmlns:mathml="http://www.w3.org/1998/Math/MathML" 
											xmlns:xalan="http://xml.apache.org/xalan" 
											xmlns:fox="http://xmlgraphics.apache.org/fop/extensions" 
											xmlns:java="http://xml.apache.org/xalan/java" 
											xmlns:redirect="http://xml.apache.org/xalan/redirect"
											exclude-result-prefixes="java xalan"
											extension-element-prefixes="redirect"
											version="1.0">

	<xsl:output version="1.0" method="xml" encoding="UTF-8" indent="no"/>
	
	<xsl:key name="kfn" match="*[local-name() = 'fn'][not(ancestor::*[(local-name() = 'table' or local-name() = 'figure' or local-name() = 'localized-strings')] and not(ancestor::*[local-name() = 'name']))]" use="@reference"/>
	
	<xsl:variable name="namespace">csd</xsl:variable>
	
	<xsl:variable name="debug">false</xsl:variable>
	
	<xsl:variable name="copyright">
		<xsl:text>© The Calendaring and Scheduling Consortium, Inc. </xsl:text>
		<xsl:value-of select="/csd:csd-standard/csd:bibdata/csd:copyright/csd:from"/>
		<xsl:text> – All rights reserved</xsl:text>
	</xsl:variable>
	
	<xsl:variable name="header">
		<xsl:value-of select="/csd:csd-standard/csd:bibdata/csd:docidentifier[@type = 'csd']"/>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="/csd:csd-standard/csd:bibdata/csd:copyright/csd:from"/>
	</xsl:variable>
	
	<xsl:variable name="contents_">
		<contents>
			<xsl:call-template name="processPrefaceSectionsDefault_Contents"/>
			<xsl:call-template name="processMainSectionsDefault_Contents"/>
			<xsl:call-template name="processTablesFigures_Contents"/>
		</contents>
	</xsl:variable>
	<xsl:variable name="contents" select="xalan:nodeset($contents_)"/>
	
	
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
					<fo:region-body margin-top="23.5mm" margin-bottom="10mm" margin-left="19mm" margin-right="19mm"/>
					<fo:region-before region-name="cover-page-header" extent="23.5mm" />
					<fo:region-after extent="10mm"/>
					<fo:region-start extent="19mm"/>
					<fo:region-end extent="19mm"/>
				</fo:simple-page-master>
				
				<!-- Document pages -->
				
				<xsl:variable name="prefaceMarginTop">17</xsl:variable>
				<xsl:variable name="prefaceMarginBottom">10</xsl:variable>
				<!-- Preface odd pages -->
				<fo:simple-page-master master-name="odd-preface" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
					<fo:region-body margin-top="{$prefaceMarginTop}mm" margin-bottom="{$prefaceMarginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
					<fo:region-before region-name="header-odd" extent="{$prefaceMarginTop}mm"/> 
					<fo:region-after region-name="footer-odd" extent="{$prefaceMarginBottom}mm"/>
					<fo:region-start region-name="left-region" extent="{$marginLeftRight1}mm"/>
					<fo:region-end region-name="right-region" extent="{$marginLeftRight2}mm"/>
				</fo:simple-page-master>
				<fo:simple-page-master master-name="odd-preface-landscape" page-width="{$pageHeight}mm" page-height="{$pageWidth}mm">
					<fo:region-body margin-top="{$prefaceMarginTop}mm" margin-bottom="{$prefaceMarginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
					<fo:region-before region-name="header-odd" extent="{$prefaceMarginTop}mm"/> 
					<fo:region-after region-name="footer-odd" extent="{$prefaceMarginBottom}mm"/>
					<fo:region-start region-name="left-region" extent="{$marginLeftRight1}mm"/>
					<fo:region-end region-name="right-region" extent="{$marginLeftRight2}mm"/>
				</fo:simple-page-master>
				<!-- Preface even pages -->
				<fo:simple-page-master master-name="even-preface" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
					<fo:region-body margin-top="{$prefaceMarginTop}mm" margin-bottom="{$prefaceMarginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
					<fo:region-before region-name="header-even" extent="{$prefaceMarginTop}mm"/>
					<fo:region-after region-name="footer-even" extent="{$prefaceMarginBottom}mm"/>
					<fo:region-start region-name="left-region" extent="{$marginLeftRight1}mm"/>
					<fo:region-end region-name="right-region" extent="{$marginLeftRight2}mm"/>
				</fo:simple-page-master>
				<fo:simple-page-master master-name="even-preface-landscape" page-width="{$pageHeight}mm" page-height="{$pageWidth}mm">
					<fo:region-body margin-top="{$prefaceMarginTop}mm" margin-bottom="{$prefaceMarginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
					<fo:region-before region-name="header-even" extent="{$prefaceMarginTop}mm"/>
					<fo:region-after region-name="footer-even" extent="{$prefaceMarginBottom}mm"/>
					<fo:region-start region-name="left-region" extent="{$marginLeftRight1}mm"/>
					<fo:region-end region-name="right-region" extent="{$marginLeftRight2}mm"/>
				</fo:simple-page-master>
				<fo:simple-page-master master-name="blankpage" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
					<fo:region-body margin-top="{$prefaceMarginTop}mm" margin-bottom="{$prefaceMarginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
					<fo:region-before region-name="header" extent="{$prefaceMarginTop}mm"/>
					<fo:region-after region-name="footer" extent="{$prefaceMarginBottom}mm"/>
					<fo:region-start region-name="left" extent="{$marginLeftRight1}mm"/>
					<fo:region-end region-name="right" extent="{$marginLeftRight2}mm"/>
				</fo:simple-page-master>
				<fo:simple-page-master master-name="blankpage-landscape" page-width="{$pageHeight}mm" page-height="{$pageWidth}mm">
					<fo:region-body margin-top="{$prefaceMarginTop}mm" margin-bottom="{$prefaceMarginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
					<fo:region-before region-name="header" extent="{$prefaceMarginTop}mm"/>
					<fo:region-after region-name="footer" extent="{$prefaceMarginBottom}mm"/>
					<fo:region-start region-name="left" extent="{$marginLeftRight1}mm"/>
					<fo:region-end region-name="right" extent="{$marginLeftRight2}mm"/>
				</fo:simple-page-master>
				<fo:page-sequence-master master-name="preface">
					<fo:repeatable-page-master-alternatives>
						<fo:conditional-page-master-reference master-reference="blankpage" blank-or-not-blank="blank" />
						<fo:conditional-page-master-reference odd-or-even="even" master-reference="even-preface"/>
						<fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd-preface"/>
					</fo:repeatable-page-master-alternatives>
				</fo:page-sequence-master>
				<fo:page-sequence-master master-name="preface-landscape">
					<fo:repeatable-page-master-alternatives>
						<fo:conditional-page-master-reference master-reference="blankpage-landscape" blank-or-not-blank="blank" />
						<fo:conditional-page-master-reference odd-or-even="even" master-reference="even-preface-landscape"/>
						<fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd-preface-landscape"/>
					</fo:repeatable-page-master-alternatives>
				</fo:page-sequence-master>
				
				<!-- Document odd pages -->
				<fo:simple-page-master master-name="odd" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
					<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
					<fo:region-before region-name="header-odd" extent="{$marginTop}mm"/> 
					<fo:region-after region-name="footer-odd" extent="{$marginBottom}mm"/>
					<fo:region-start region-name="left-region" extent="{$marginLeftRight1}mm"/>
					<fo:region-end region-name="right-region" extent="{$marginLeftRight2}mm"/>
				</fo:simple-page-master>
				<fo:simple-page-master master-name="odd-landscape" page-width="{$pageHeight}mm" page-height="{$pageWidth}mm">
					<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
					<fo:region-before region-name="header-odd" extent="{$marginTop}mm"/> 
					<fo:region-after region-name="footer-odd" extent="{$marginBottom}mm"/>
					<fo:region-start region-name="left-region" extent="{$marginLeftRight1}mm"/>
					<fo:region-end region-name="right-region" extent="{$marginLeftRight2}mm"/>
				</fo:simple-page-master>
				<!-- Preface even pages -->
				<fo:simple-page-master master-name="even" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
					<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
					<fo:region-before region-name="header-even" extent="{$marginTop}mm"/>
					<fo:region-after region-name="footer-even" extent="{$marginBottom}mm"/>
					<fo:region-start region-name="left-region" extent="{$marginLeftRight1}mm"/>
					<fo:region-end region-name="right-region" extent="{$marginLeftRight2}mm"/>
				</fo:simple-page-master>
				<fo:simple-page-master master-name="even-landscape" page-width="{$pageHeight}mm" page-height="{$pageWidth}mm">
					<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
					<fo:region-before region-name="header-even" extent="{$marginTop}mm"/>
					<fo:region-after region-name="footer-even" extent="{$marginBottom}mm"/>
					<fo:region-start region-name="left-region" extent="{$marginLeftRight1}mm"/>
					<fo:region-end region-name="right-region" extent="{$marginLeftRight2}mm"/>
				</fo:simple-page-master>
				<fo:page-sequence-master master-name="document">
					<fo:repeatable-page-master-alternatives>
						<fo:conditional-page-master-reference master-reference="blankpage" blank-or-not-blank="blank" />
						<fo:conditional-page-master-reference odd-or-even="even" master-reference="even"/>
						<fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd"/>
					</fo:repeatable-page-master-alternatives>
				</fo:page-sequence-master>
				<fo:page-sequence-master master-name="document-landscape">
					<fo:repeatable-page-master-alternatives>
						<fo:conditional-page-master-reference master-reference="blankpage-landscape" blank-or-not-blank="blank" />
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
					
					<fo:block text-align="right">
						<!-- CC/FDS 18011:2018 -->
						<fo:block font-size="14pt" font-weight="bold" margin-bottom="10pt">
							<xsl:value-of select="/csd:csd-standard/csd:bibdata/csd:docidentifier[@type = 'csd']"/><xsl:text> </xsl:text>
						</fo:block>
						<fo:block margin-bottom="12pt">
							<xsl:value-of select="/csd:csd-standard/csd:bibdata/csd:copyright/csd:owner/csd:organization/csd:name"/>
							<xsl:text> TC </xsl:text>
							<xsl:value-of select="/csd:csd-standard/csd:bibdata/csd:ext/csd:editorialgroup/csd:technical-committee"/>
							<xsl:text> </xsl:text>
						</fo:block>
					</fo:block>
					<fo:block font-size="24pt" font-weight="bold" text-align="center" role="H1">
						<xsl:value-of select="/csd:csd-standard/csd:bibdata/csd:title[@language = 'en']" />
						<xsl:value-of select="$linebreak"/>
					</fo:block>
					<fo:block>&#xA0;</fo:block>
					<fo:block margin-bottom="12pt">&#xA0;</fo:block>
					<fo:block-container font-size="16pt" text-align="center" border="0.5pt solid black" margin-bottom="12pt" margin-left="-1mm" margin-right="-1mm">
						<fo:block-container margin-left="0mm" margin-right="0mm">
							<fo:block padding-top="1mm">
								<xsl:call-template name="capitalizeWords">
									<!-- ex: final-draft -->
									<xsl:with-param name="str" select="/csd:csd-standard/csd:bibdata/csd:status/csd:stage"/>
								</xsl:call-template>
								<xsl:text> </xsl:text>
								<xsl:call-template name="capitalizeWords">
									<!-- ex: standard -->
									<xsl:with-param name="str" select="/csd:csd-standard/csd:bibdata/csd:ext/csd:doctype"/>
								</xsl:call-template>
							</fo:block>
						</fo:block-container>
					</fo:block-container>
					<fo:block margin-bottom="10pt">&#xA0;</fo:block>
					<fo:block-container font-size="10pt" border="0.5pt solid black" margin-bottom="12pt" margin-left="-1mm" margin-right="-1mm">
						<fo:block-container margin-left="0mm" margin-right="0mm">
							<fo:block text-align="center" font-weight="bold" padding-top="1mm" margin-bottom="6pt">Warning for drafts</fo:block>
							<fo:block margin-left="2mm" margin-right="2mm">
								<fo:block margin-bottom="6pt">This document is not a CalConnect Standard. It is distributed for review and comment, and is subject to change without notice and may not be referred to as a Standard. Recipients of this draft are invited to submit, with their comments, notification of any relevant patent rights of which they are aware and to provide supporting documentation.</fo:block>
								<fo:block margin-bottom="10pt">Recipients of this draft are invited to submit, with their comments, notification of any relevant patent rights of which they are aware and to provide supporting documentation.</fo:block>
							</fo:block>
						</fo:block-container>
					</fo:block-container>
					<fo:block text-align="center">
						<xsl:text>The Calendaring and Scheduling Consortium, Inc.&#xA0; </xsl:text>
						<xsl:value-of select="/csd:csd-standard/csd:bibdata/csd:copyright/csd:from"/>
					</fo:block>
				</fo:flow>
			</fo:page-sequence>
			<!-- End Cover Page -->
			
			<xsl:variable name="updated_xml">
				<xsl:call-template name="updateXML"/>
			</xsl:variable>
			
			<xsl:for-each select="xalan:nodeset($updated_xml)/*">
			
				<xsl:variable name="updated_xml_with_pages">
					<xsl:call-template name="processPrefaceAndMainSectionsDefault_items"/>
				</xsl:variable>
			
				<xsl:for-each select="xalan:nodeset($updated_xml_with_pages)"> <!-- set context to preface/sections -->
					<xsl:for-each select=".//*[local-name() = 'page_sequence'][parent::*[local-name() = 'preface']][normalize-space() != '' or .//image or .//svg]">
			
						<!-- Copyright, Content, Foreword, etc. pages -->
						<fo:page-sequence master-reference="preface" format="i">
						
							<xsl:attribute name="master-reference">
								<xsl:text>preface</xsl:text>
								<xsl:call-template name="getPageSequenceOrientation"/>
							</xsl:attribute>
						
							<xsl:if test="position() = 1">
								<xsl:attribute name="initial-page-number">2</xsl:attribute>
							</xsl:if>
							<xsl:if test="position() = last()">
								<xsl:attribute name="force-page-count">end-on-even</xsl:attribute>
							</xsl:if>
						
							<fo:static-content flow-name="xsl-footnote-separator">
								<fo:block>
									<fo:leader leader-pattern="rule" leader-length="30%"/>
								</fo:block>
							</fo:static-content>
							<xsl:call-template name="insertHeaderFooter"/>
							<fo:flow flow-name="xsl-region-body">
								
								<!-- <xsl:if test="$debug = 'true'">
									<redirect:write file="contents_{java:getTime(java:java.util.Date.new())}.xml">
										<xsl:copy-of select="$contents"/>
									</redirect:write>
								</xsl:if> -->
								
								<xsl:if test="position() = 1">
									<fo:block margin-bottom="15pt">&#xA0;</fo:block>
									<fo:block margin-bottom="14pt">
										<xsl:text>© </xsl:text>
										<xsl:value-of select="/csd:csd-standard/csd:bibdata/csd:copyright/csd:from"/>
										<xsl:text> </xsl:text>
										<fo:inline>
											<xsl:apply-templates select="/csd:csd-standard/csd:boilerplate/csd:feedback-statement/csd:clause/csd:p[@id = 'boilerplate-name']"/>
										</fo:inline>
									</fo:block>
									<fo:block margin-bottom="12pt">
										<xsl:apply-templates select="/csd:csd-standard/csd:boilerplate/csd:legal-statement"/>
									</fo:block>
									<fo:block margin-bottom="12pt">
										<xsl:apply-templates select="/csd:csd-standard/csd:boilerplate/csd:feedback-statement/csd:clause/csd:p[@id = 'boilerplate-name']"/>
									</fo:block>
									<fo:block>
										<xsl:apply-templates select="/csd:csd-standard/csd:boilerplate/csd:feedback-statement/csd:clause/csd:p[@id = 'boilerplate-address']"/>
									</fo:block>
									
									<fo:block break-after="page"/>
								</xsl:if>  <!-- for 1st page_sequence only -->
								
								<!-- Table of contents, Foreword, Introduction -->					
								<!-- <xsl:call-template name="processPrefaceSectionsDefault"/> -->
								<xsl:apply-templates />
								
								<fo:block/> <!-- for prevent empty preface -->
							</fo:flow>
						</fo:page-sequence>
					</xsl:for-each>
				
				
					<xsl:for-each select=".//*[local-name() = 'page_sequence'][not(parent::*[local-name() = 'preface'])][normalize-space() != '' or .//image or .//svg]">
				
						<!-- Document Pages -->
						<fo:page-sequence master-reference="document" format="1" force-page-count="no-force">
						
							<xsl:attribute name="master-reference">
								<xsl:text>document</xsl:text>
								<xsl:call-template name="getPageSequenceOrientation"/>
							</xsl:attribute>
						
							<xsl:if test="position() = 1">
								<xsl:attribute name="initial-page-number">1</xsl:attribute>
							</xsl:if>
							
							
							<fo:static-content flow-name="xsl-footnote-separator">
								<fo:block>
									<fo:leader leader-pattern="rule" leader-length="30%"/>
								</fo:block>
							</fo:static-content>
							<xsl:call-template name="insertHeaderFooter"/>
							<fo:flow flow-name="xsl-region-body">
								<!-- <fo:block font-size="16pt" font-weight="bold" margin-bottom="17pt" role="H1">
									<xsl:value-of select="/csd:csd-standard/csd:bibdata/csd:title[@language = 'en']"/>
								</fo:block> -->
								<fo:block>
									<!-- <xsl:call-template name="processMainSectionsDefault"/> -->
									<xsl:apply-templates />
								</fo:block>
							</fo:flow>
						</fo:page-sequence>
						
						<!-- End Document Pages -->
					</xsl:for-each>
				</xsl:for-each>
			
			</xsl:for-each>
			
		</fo:root>
	</xsl:template> 

	<xsl:template name="insertListOf_Title">
		<xsl:param name="title"/>
		<fo:block role="TOCI" margin-top="6pt" keep-with-next="always">
			<xsl:value-of select="$title"/>
		</fo:block>
	</xsl:template>
	
	<xsl:template name="insertListOf_Item">
		<fo:block role="TOCI">
			<fo:list-block provisional-distance-between-starts="8mm">
				<fo:list-item>
					<fo:list-item-label end-indent="label-end()">
						<fo:block></fo:block>
					</fo:list-item-label>
					<fo:list-item-body start-indent="body-start()">
						<fo:block text-align-last="justify" margin-left="12mm" text-indent="-12mm">
							<fo:basic-link internal-destination="{@id}">
								<xsl:call-template name="setAltText">
									<xsl:with-param name="value" select="@alt-text"/>
								</xsl:call-template>
								<xsl:apply-templates select="." mode="contents"/>
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
	</xsl:template>

	<xsl:template match="csd:preface//csd:clause[@type = 'toc']" priority="3">
		<fo:block-container font-weight="bold" line-height="115%">
			<fo:block role="TOC">
				
				<xsl:apply-templates />
				
				<xsl:if test="count(*) = 1 and *[local-name() = 'title']"> <!-- if there isn't user ToC -->
				
					<xsl:for-each select="$contents//item[@display = 'true']"><!-- [not(@level = 2 and starts-with(@section, '0'))] skip clause from preface -->
						
						<fo:block role="TOCI">
							<xsl:if test="@level = 1">
								<xsl:attribute name="margin-top">6pt</xsl:attribute>
							</xsl:if>
							
							<fo:list-block>
								<xsl:attribute name="provisional-distance-between-starts">
									<xsl:choose>
										<!-- skip 0 section without subsections -->
										<xsl:when test="@section != ''">8mm</xsl:when> <!-- and not(@display-section = 'false') -->
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
											<fo:basic-link internal-destination="{@id}" fox:alt-text="{title}">													
												<xsl:apply-templates select="title"/>
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
					
					<!-- List of Tables -->
					<xsl:if test="$contents//tables/table">
						<xsl:call-template name="insertListOf_Title">
							<xsl:with-param name="title" select="$title-list-tables"/>
						</xsl:call-template>
						<xsl:for-each select="$contents//tables/table">
							<xsl:call-template name="insertListOf_Item"/>
						</xsl:for-each>
					</xsl:if>
					
					<!-- List of Figures -->
					<xsl:if test="$contents//figures/figure">
						<xsl:call-template name="insertListOf_Title">
							<xsl:with-param name="title" select="$title-list-figures"/>
						</xsl:call-template>
						<xsl:for-each select="$contents//figures/figure">
							<xsl:call-template name="insertListOf_Item"/>
						</xsl:for-each>
					</xsl:if>
				</xsl:if>
			</fo:block>
		</fo:block-container>
	</xsl:template>

	<xsl:template match="csd:preface//csd:clause[@type = 'toc']/csd:title" priority="3">
		<!-- <xsl:variable name="title-toc">
			<xsl:call-template name="getTitle">
				<xsl:with-param name="name" select="'title-toc'"/>
			</xsl:call-template>
		</xsl:variable> -->
		<fo:block font-size="14pt"  margin-bottom="15.5pt" role="H1">
			<!-- <xsl:value-of select="$title-toc"/> -->
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>

	<xsl:template match="node()">
		<xsl:apply-templates />
	</xsl:template>
	
	<!-- ============================= -->
	<!-- CONTENTS                                       -->
	<!-- ============================= -->
	
	<!-- element with title -->
	<xsl:template match="*[csd:title]" mode="contents">
		<xsl:variable name="level">
			<xsl:call-template name="getLevel">
				<xsl:with-param name="depth" select="csd:title/@depth"/>
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
				<xsl:when test="ancestor-or-self::csd:bibitem">true</xsl:when>
				<xsl:when test="ancestor-or-self::csd:term">true</xsl:when>
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
			
			<item id="{@id}" level="{$level}" section="{$section}" display="{$display}">
				<title>
					<xsl:apply-templates select="xalan:nodeset($title)" mode="contents_item"/>
				</title>
				<xsl:apply-templates  mode="contents" />
			</item>
		</xsl:if>	
		
	</xsl:template>
	
	
	<!-- ============================= -->
	<!-- ============================= -->
	
	<xsl:template match="csd:sections//csd:p[@class = 'zzSTDTitle1']" priority="4">
		<fo:block font-size="16pt" font-weight="bold" margin-bottom="17pt" role="H1">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="csd:title" name="title">
		
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>

		<xsl:variable name="font-size">
			<xsl:choose>
				<xsl:when test="ancestor::csd:preface">13pt</xsl:when>
				<xsl:when test="$level = 1">13pt</xsl:when>
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
		
		<xsl:element name="{$element-name}">
			<xsl:attribute name="font-size"><xsl:value-of select="$font-size"/></xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>			
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>		
			<xsl:attribute name="color"><xsl:value-of select="$color"/></xsl:attribute>
			<xsl:if test="ancestor::csd:sections">
				<xsl:attribute name="margin-top">13.5pt</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="role">H<xsl:value-of select="$level"/></xsl:attribute>
			<xsl:apply-templates />
			<xsl:apply-templates select="following-sibling::*[1][local-name() = 'variant-title'][@type = 'sub']" mode="subtitle"/>
		</xsl:element>		
	</xsl:template>
	

	<xsl:template match="csd:p" name="paragraph">
		<xsl:param name="inline" select="'false'"/>
		<xsl:param name="split_keep-within-line"/>
		<xsl:variable name="previous-element" select="local-name(preceding-sibling::*[1])"/>
		<xsl:variable name="element-name">
			<xsl:choose>
				<xsl:when test="$inline = 'true'">fo:inline</xsl:when>
				<xsl:when test="../@inline-header = 'true' and $previous-element = 'title'">fo:inline</xsl:when> <!-- first paragraph after inline title -->
				<xsl:when test="local-name(..) = 'admonition'">fo:inline</xsl:when>
				<xsl:when test="@id = 'boilerplate-name'">fo:inline</xsl:when>
				<xsl:otherwise>fo:block</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:element name="{$element-name}">
		
			<xsl:call-template name="setBlockAttributes"/>
			
			<xsl:attribute name="margin-bottom">
				<xsl:choose>
					<xsl:when test="ancestor::csd:li">0pt</xsl:when>
					<xsl:otherwise>12pt</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="line-height">115%</xsl:attribute>
			<xsl:apply-templates>
				<xsl:with-param name="split_keep-within-line" select="$split_keep-within-line"/>
			</xsl:apply-templates>
		</xsl:element>
		<xsl:if test="$element-name = 'fo:inline' and not($inline = 'true') and not(local-name(..) = 'admonition')">
			<fo:block margin-bottom="12pt">
				 <xsl:if test="ancestor::csd:annex">
					<xsl:attribute name="margin-bottom">0</xsl:attribute>
				 </xsl:if>
				<xsl:value-of select="$linebreak"/>
			</fo:block>
		</xsl:if>
		<xsl:if test="$inline = 'true'">
			<fo:block>&#xA0;</fo:block>
		</xsl:if>
	</xsl:template>
	
	
	<xsl:template match="csd:p/csd:fn/csd:p">
		<xsl:apply-templates />
	</xsl:template>
	
		
	<xsl:template match="csd:xref" priority="2">
		<xsl:call-template name="insert_basic_link">
			<xsl:with-param name="element">
				<fo:basic-link internal-destination="{@target}" fox:alt-text="{@target}">
					<xsl:if test="not(starts-with(text(), 'Figure') or starts-with(text(), 'Table'))">
						<xsl:attribute name="color">blue</xsl:attribute>
						<xsl:attribute name="text-decoration">underline</xsl:attribute>
					</xsl:if>
					<xsl:apply-templates />
				</fo:basic-link>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	
	<xsl:template name="insertHeaderFooter">
		<fo:static-content flow-name="header-even" role="artifact">
			<fo:block-container height="17mm" display-align="before">
				<fo:block padding-top="12.5mm">
					<xsl:value-of select="$header"/>
				</fo:block>
			</fo:block-container>
		</fo:static-content>
		<fo:static-content flow-name="footer-even" role="artifact">
			<fo:block-container font-size="10pt" height="100%" display-align="after">
				<fo:table table-layout="fixed" width="100%">
					<fo:table-column column-width="10%"/>
					<fo:table-column column-width="90%"/>
					<fo:table-body>
						<fo:table-row>
							<fo:table-cell>
								<fo:block padding-bottom="5mm"><fo:page-number/></fo:block>
							</fo:table-cell>
							<fo:table-cell padding-right="2mm">
								<fo:block padding-bottom="5mm" text-align="right"><xsl:value-of select="$copyright"/></fo:block>
							</fo:table-cell>
						</fo:table-row>
					</fo:table-body>
				</fo:table>
			</fo:block-container>
		</fo:static-content>
		<fo:static-content flow-name="header-odd" role="artifact">
			<fo:block-container height="17mm" display-align="before">
				<fo:block text-align="right" padding-top="12.5mm">
					<xsl:value-of select="$header"/>
				</fo:block>
			</fo:block-container>
		</fo:static-content>
		<fo:static-content flow-name="footer-odd" role="artifact">
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
								<fo:block padding-bottom="5mm" text-align="right"><fo:page-number/></fo:block>
							</fo:table-cell>
						</fo:table-row>
					</fo:table-body>
				</fo:table>
			</fo:block-container>
		</fo:static-content>
	</xsl:template>

	
</xsl:stylesheet>
