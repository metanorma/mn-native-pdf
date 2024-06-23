<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
											xmlns:fo="http://www.w3.org/1999/XSL/Format" 
											xmlns:mpfd="https://www.metanorma.org/ns/mpfd" 
											xmlns:mathml="http://www.w3.org/1998/Math/MathML" 
											xmlns:xalan="http://xml.apache.org/xalan" 
											xmlns:fox="http://xmlgraphics.apache.org/fop/extensions" 
											xmlns:redirect="http://xml.apache.org/xalan/redirect"
											xmlns:java="http://xml.apache.org/xalan/java" 
											exclude-result-prefixes="java redirect"
											extension-element-prefixes="redirect"
											version="1.0">

	<xsl:output method="xml" encoding="UTF-8" indent="no"/>
	
	<xsl:key name="kfn" match="*[local-name() = 'fn'][not(ancestor::*[(local-name() = 'table' or local-name() = 'figure' or local-name() = 'localized-strings')] and not(ancestor::*[local-name() = 'name']))]" use="@reference"/>
	
	<xsl:variable name="namespace">mpfd</xsl:variable>
	
	<xsl:variable name="debug">false</xsl:variable>

	<xsl:variable name="copyrightHolder">Ribose Group Inc.</xsl:variable>

	<xsl:variable name="copyright">
		<xsl:text>© </xsl:text>
		<xsl:value-of select="$copyrightHolder"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="/mpfd:mpfd-standard/mpfd:bibdata/mpfd:copyright/mpfd:from"/>
		<xsl:text> – All rights reserved</xsl:text>
	</xsl:variable>
	
	<xsl:variable name="docidentifier" select="/mpfd:mpfd-standard/mpfd:bibdata/mpfd:docidentifier"/>
	<xsl:variable name="copyrightShort">
		<xsl:value-of select="$copyrightHolder"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="$docidentifier"/>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="/mpfd:mpfd-standard/mpfd:bibdata/mpfd:copyright/mpfd:from"/>
	</xsl:variable>
	
	<xsl:variable name="title-en" select="/mpfd:mpfd-standard/mpfd:bibdata/mpfd:title[@language = 'en']"/>
	<!-- Example:
		<item level="1" id="Foreword" display="true">Foreword</item>
		<item id="term-script" display="false">3.2</item>
	-->
	<xsl:variable name="contents_">
		<contents>			
			<xsl:apply-templates select="/mpfd:mpfd-standard/mpfd:preface/*[not(local-name() = 'terms' or local-name() = 'note' or local-name() = 'admonition')]" mode="contents"/>
			<xsl:apply-templates select="/mpfd:mpfd-standard/mpfd:preface/mpfd:terms" mode="contents"/>
				
			<xsl:apply-templates select="/mpfd:mpfd-standard/mpfd:sections/*" mode="contents" />
				
			<xsl:apply-templates select="/mpfd:mpfd-standard/mpfd:annex" mode="contents"/>
			
			<xsl:apply-templates select="/mpfd:mpfd-standard/mpfd:bibliography" mode="contents"/>
			
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
				
				<!-- cover page -->
				<fo:simple-page-master master-name="cover" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
					<fo:region-body margin-top="24mm" margin-bottom="10mm" margin-left="19mm" margin-right="19mm"/>
					<fo:region-before region-name="cover-header" extent="24mm" />
					<fo:region-after region-name="footer" extent="10mm" />
					<fo:region-start region-name="left-region" extent="19mm"/>
					<fo:region-end region-name="right-region" extent="19mm"/>
				</fo:simple-page-master>
				
				<!-- document pages -->				
				<fo:simple-page-master master-name="odd" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
					<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
					<fo:region-before region-name="header-odd" extent="{$marginTop}mm" />
					<fo:region-after region-name="footer-odd" extent="{$marginBottom}mm" />
					<fo:region-start region-name="left-region" extent="{$marginLeftRight1}mm"/>
					<fo:region-end region-name="right-region" extent="{$marginLeftRight2}mm"/>
				</fo:simple-page-master>
				<fo:simple-page-master master-name="odd-landscape" page-width="{$pageHeight}mm" page-height="{$pageWidth}mm">
					<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
					<fo:region-before region-name="header-odd" extent="{$marginTop}mm" />
					<fo:region-after region-name="footer-odd" extent="{$marginBottom}mm" />
					<fo:region-start region-name="left-region" extent="{$marginLeftRight1}mm"/>
					<fo:region-end region-name="right-region" extent="{$marginLeftRight2}mm"/>
				</fo:simple-page-master>
				<fo:simple-page-master master-name="even" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
					<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight2}mm" margin-right="{$marginLeftRight1}mm"/>
					<fo:region-before region-name="header-even" extent="{$marginTop}mm" />
					<fo:region-after region-name="footer-even" extent="{$marginBottom}mm" />
					<fo:region-start region-name="left-region" extent="{$marginLeftRight2}mm"/>
					<fo:region-end region-name="right-region" extent="{$marginLeftRight1}mm"/>
				</fo:simple-page-master>
				<fo:simple-page-master master-name="even-landscape" page-width="{$pageHeight}mm" page-height="{$pageWidth}mm">
					<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight2}mm" margin-right="{$marginLeftRight1}mm"/>
					<fo:region-before region-name="header-even" extent="{$marginTop}mm" />
					<fo:region-after region-name="footer-even" extent="{$marginBottom}mm" />
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
			
			<fo:page-sequence master-reference="cover" force-page-count="no-force">
				<fo:static-content flow-name="cover-header">
					<fo:block-container height="100%">						
							<fo:block font-size="10pt" padding-top="12.5mm">
								<xsl:value-of select="$copyright"/>								
							</fo:block>						
					</fo:block-container>
				</fo:static-content>
				<fo:flow flow-name="xsl-region-body">
					<xsl:if test="normalize-space($docidentifier) != ''">
						<fo:block font-size="14pt" text-align="right" font-weight="bold"  margin-bottom="12pt">
							<xsl:value-of select="$docidentifier"/>
							<xsl:if test="/mpfd:mpfd-standard/mpfd:bibdata/mpfd:version/mpfd:draft">
								<xsl:text> (</xsl:text>
								<xsl:text>draft </xsl:text>
								<xsl:value-of select="/mpfd:mpfd-standard/mpfd:bibdata/mpfd:version/mpfd:draft"/>
								<xsl:text>, </xsl:text>
								<xsl:value-of select="/mpfd:mpfd-standard/mpfd:bibdata/mpfd:version/mpfd:revision-date"/>
								<xsl:text>)</xsl:text>
							</xsl:if>
						</fo:block>
					</xsl:if>
					<fo:block>						
						<fo:external-graphic src="{concat('data:image/png;base64,', normalize-space($Image-MPFD-Logo))}" width="13.2mm" content-height="13mm" content-width="scale-to-fit" scaling="uniform" fox:alt-text="Image MPFD Logo"/>
					</fo:block>
					<fo:block-container text-align="center">
						<fo:block role="H1">								
							<fo:inline font-size="24pt" font-weight="bold">
								<xsl:call-template name="capitalizeWords">
									<xsl:with-param name="str" select="java:replaceAll(java:java.lang.String.new(/mpfd:mpfd-standard/mpfd:bibdata/mpfd:ext/mpfd:doctype),'MPF','')"/>
								</xsl:call-template>
							</fo:inline>
							<xsl:value-of select="$linebreak"/>
							<fo:inline font-size="16pt"><xsl:value-of select="$title-en"/></fo:inline>							
						</fo:block>
					</fo:block-container>
					<fo:block margin-bottom="12pt">&#xA0;</fo:block>
					<fo:block-container text-align="center" border="0.5pt solid black" margin-bottom="12pt">
						<fo:block font-size="16pt" margin-bottom="12pt" padding-top="1mm">
							<xsl:variable name="edition" select="normalize-space(/mpfd:mpfd-standard/mpfd:bibdata/mpfd:edition[normalize-space(@language) = ''])"/>
							<xsl:if test="$edition != ''">
								<xsl:value-of select="$edition"/>
								<xsl:text> </xsl:text>
								<xsl:call-template name="capitalize">
									<xsl:with-param name="str">
										<xsl:call-template name="getLocalizedString">
											<xsl:with-param name="key">edition</xsl:with-param>
										</xsl:call-template>
									</xsl:with-param>
								</xsl:call-template>
								<xsl:value-of select="$linebreak"/>
							</xsl:if>
							<xsl:call-template name="convertDate">
								<xsl:with-param name="date" select="/mpfd:mpfd-standard/mpfd:bibdata/mpfd:version/mpfd:revision-date"/>
								<xsl:with-param name="format">ddMMyyyy</xsl:with-param>
							</xsl:call-template>
							
						</fo:block>
						<fo:block>Hong Kong</fo:block>
					</fo:block-container>
					<fo:block margin-bottom="12pt">&#xA0;</fo:block>
					<fo:block text-align="center">Ribose Group Inc.  <xsl:value-of select="/mpfd:mpfd-standard/mpfd:bibdata/mpfd:copyright/mpfd:from"/></fo:block>
				</fo:flow>
			</fo:page-sequence>
			
			<xsl:variable name="updated_xml">
				<xsl:call-template name="updateXML"/>
				<!-- <xsl:copy-of select="."/> -->
			</xsl:variable>
			
			<xsl:for-each select="xalan:nodeset($updated_xml)/*">
			
				<xsl:variable name="updated_xml_with_pages">
					<xsl:call-template name="processPrefaceAndMainSectionsMPFA_items"/>
				</xsl:variable>
			
				<xsl:for-each select="xalan:nodeset($updated_xml_with_pages)"> <!-- set context to preface -->
				
					<xsl:for-each select=".//*[local-name() = 'page_sequence'][parent::*[local-name() = 'preface']][normalize-space() != '' or .//image or .//svg]">
			
						<fo:page-sequence master-reference="document" format="i" force-page-count="no-force">
						
							<xsl:attribute name="master-reference">
								<xsl:text>document</xsl:text>
								<xsl:call-template name="getPageSequenceOrientation"/>
							</xsl:attribute>
							
							<xsl:if test="position() = 1">
								<xsl:attribute name="initial-page-number">2</xsl:attribute>
							</xsl:if>
						
							<xsl:call-template name="insertHeaderFooter"/>
							
							<fo:flow flow-name="xsl-region-body">
							
								<!-- <xsl:if test="$debug = 'true'">
									<redirect:write file="contents_{java:getTime(java:java.util.Date.new())}.xml">
										<xsl:copy-of select="$contents"/>
									</redirect:write>
								</xsl:if> -->

								<!-- Table of content -->
								<!-- <xsl:apply-templates select="/*/mpfd:preface/mpfd:clause[@type = 'toc']"/> -->
								
								<!-- <xsl:if test="/mpfd:mpfd-standard/mpfd:preface/*[not(local-name() = 'note' or local-name() = 'admonition' or (local-name() = 'clause' and @type = 'toc'))]">
									<fo:block break-after="page"/> -->
									<!-- Foreword, Introduction -->
									<!-- <fo:block>
										<xsl:apply-templates select="/mpfd:mpfd-standard/mpfd:preface/*[not(local-name() = 'terms' or local-name() = 'note' or local-name() = 'admonition' or (local-name() = 'clause' and @type = 'toc'))]"/>
										<xsl:apply-templates select="/mpfd:mpfd-standard/mpfd:preface/mpfd:terms"/>
									</fo:block>
								</xsl:if> -->
								
								<xsl:apply-templates />
								
								<fo:block/> <!-- prevent empty toc -->
							</fo:flow>
						</fo:page-sequence>
					</xsl:for-each>
				</xsl:for-each>
			
				<xsl:for-each select="xalan:nodeset($updated_xml_with_pages)"> <!-- set context to preface -->
							
					<xsl:for-each select=".//*[local-name() = 'page_sequence'][not(parent::*[local-name() = 'preface'])][normalize-space() != '' or .//image or .//svg]">
			
						<fo:page-sequence master-reference="document" format="1" force-page-count="no-force">
						
							<xsl:attribute name="master-reference">
								<xsl:text>document</xsl:text>
								<xsl:call-template name="getPageSequenceOrientation"/>
							</xsl:attribute>
						
							<xsl:if test="position() = 1">
								<xsl:attribute name="initial-page-number">1</xsl:attribute>
							</xsl:if>
						
							<xsl:call-template name="insertHeaderFooter">
								<xsl:with-param name="font-weight">bold</xsl:with-param>
							</xsl:call-template>
							<fo:flow flow-name="xsl-region-body">
								<fo:block-container>
									
									<!-- <fo:block font-size="16pt" font-weight="bold" margin-bottom="18pt" role="H1">
										<xsl:value-of select="$title-en"/>
									</fo:block> -->
									
									<!-- Main sections -->
									<!-- <xsl:apply-templates select="/mpfd:mpfd-standard/mpfd:sections/*"/> -->
									
									<!-- Annex(s) -->
									<!-- <xsl:apply-templates select="/mpfd:mpfd-standard/mpfd:annex"/> -->
									
									<!-- Bibliography -->
									<!-- <xsl:apply-templates select="/mpfd:mpfd-standard/mpfd:bibliography"/> -->
									<xsl:apply-templates />
									
									<fo:block/> <!-- prevent empty toc -->
								</fo:block-container>
							</fo:flow>
						</fo:page-sequence>
					</xsl:for-each>
				</xsl:for-each>
			</xsl:for-each>
		</fo:root>
	</xsl:template> 
	
	<xsl:template name="processPrefaceAndMainSectionsMPFA_items">
		<xsl:variable name="updated_xml_step_move_pagebreak">
		
			<xsl:element name="{$root_element}" namespace="{$namespace_full}">
			
				<xsl:call-template name="copyCommonElements"/>
				
				<xsl:element name="preface" namespace="{$namespace_full}"> <!-- save context element -->
					<!-- Table of Contents -->
					<xsl:element name="page_sequence" namespace="{$namespace_full}">
						<xsl:copy-of select="/*/*[local-name()='preface']/*[local-name()='clause'][@type = 'toc']" />
					</xsl:element>
						
					<xsl:element name="page_sequence" namespace="{$namespace_full}">
						<xsl:apply-templates select="/mpfd:mpfd-standard/mpfd:preface/*[not(local-name() = 'terms' or local-name() = 'note' or local-name() = 'admonition' or (local-name() = 'clause' and @type = 'toc'))]" mode="update_xml_step_move_pagebreak"/>
						<xsl:apply-templates select="/mpfd:mpfd-standard/mpfd:preface/mpfd:terms" mode="update_xml_step_move_pagebreak"/>
					</xsl:element>
				</xsl:element> <!-- preface -->
				
				<xsl:call-template name="insertMainSectionsPageSequences"/>
				
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
	</xsl:template> <!-- END: processPrefaceAndMainSectionsMPFA_items -->
	
	
	<xsl:template name="insertListOf_Title">
		<xsl:param name="title"/>
		<fo:block margin-top="6pt" keep-with-next="always">
			<xsl:value-of select="$title"/>
		</fo:block>
	</xsl:template>
	
	<xsl:template name="insertListOf_Item">
		<fo:block role="TOCI" text-align-last="justify" >
			<fo:basic-link internal-destination="{@id}">
				<xsl:call-template name="setAltText">
					<xsl:with-param name="value" select="@alt-text"/>
				</xsl:call-template>
				<xsl:apply-templates select="." mode="contents"/>
				<fo:inline keep-together.within-line="always">
					<fo:leader leader-pattern="dots"/>
					<fo:page-number-citation ref-id="{@id}"/>
				</fo:inline>
			</fo:basic-link>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="mpfd:preface//mpfd:clause[@type = 'toc']" priority="3">
		<!-- Table of content -->
		<fo:block-container font-weight="bold">
		
			<xsl:apply-templates />
		
			<xsl:if test="count(*) = 1 and *[local-name() = 'title']"> <!-- if there isn't user ToC -->
			
				<fo:block line-height="115%" role="TOC">
					<xsl:for-each select="$contents//item[@display = 'true']">
						<fo:block role="TOCI">
							<xsl:if test="@level = 1">
								<xsl:attribute name="margin-top">6pt</xsl:attribute>
							</xsl:if>								
							<fo:list-block provisional-label-separation="3mm">
								<xsl:attribute name="provisional-distance-between-starts">
									<xsl:choose>
										<xsl:when test="@section != ''">7mm</xsl:when>
										<xsl:otherwise>0mm</xsl:otherwise>
									</xsl:choose>
								</xsl:attribute>
								<fo:list-item>
									<fo:list-item-label end-indent="label-end()">											
										<fo:block>
											<xsl:if test="@section">															
												<xsl:value-of select="@section"/>
											</xsl:if>
										</fo:block>
									</fo:list-item-label>
									<fo:list-item-body start-indent="body-start()">
										<fo:block text-align-last="justify">															
											<fo:basic-link internal-destination="{@id}" fox:alt-text="{title}">
												<xsl:apply-templates select="title"/>
												<fo:inline keep-together.within-line="always">
													<fo:leader leader-pattern="dots"/>
													<fo:page-number-citation ref-id="{@id}"/>
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
					
				</fo:block>
			</xsl:if>
			<fo:block/> <!-- prevent empty toc -->
		</fo:block-container>
	</xsl:template>
	
	<xsl:template match="mpfd:preface//mpfd:clause[@type = 'toc']/mpfd:title" priority="3">
		<!-- <xsl:variable name="title-toc">
			<xsl:call-template name="getTitle">
				<xsl:with-param name="name" select="'title-toc'"/>
			</xsl:call-template> 
		</xsl:variable> -->
		<fo:block font-size="14pt" margin-bottom="15.5pt" role="H1">
			<!-- <xsl:value-of select="$title-toc"/> -->
			<xsl:apply-templates />
		</fo:block>	
	</xsl:template>
	
	<xsl:template match="mpfd:p[@class = 'zzSTDTitle1']" priority="4">
		<fo:block font-size="16pt" font-weight="bold" margin-bottom="18pt" role="H1">
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
	<xsl:template match="*[mpfd:title]" mode="contents">
		<xsl:variable name="level">
			<xsl:call-template name="getLevel">
				<xsl:with-param name="depth" select="mpfd:title/@depth"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="section">
			<xsl:call-template name="getSection"/>
		</xsl:variable>
		
		<xsl:variable name="type">
			<xsl:value-of select="local-name()"/>
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
				<xsl:when test="ancestor-or-self::mpfd:bibitem">true</xsl:when>
				<xsl:when test="ancestor-or-self::mpfd:term">true</xsl:when>				
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:if test="$skip = 'false'">		
			
			<xsl:variable name="title">
				<xsl:call-template name="getName"/>
			</xsl:variable>
			
			<item level="{$level}" section="{$section}" type="{$type}" display="{$display}">
				<xsl:call-template name="setId"/>
				<title>
					<xsl:apply-templates select="xalan:nodeset($title)" mode="contents_item"/>
				</title>
				<xsl:apply-templates  mode="contents" />
			</item>
			
		</xsl:if>	
		
	</xsl:template>

	<xsl:template match="mpfd:br" mode="contents_item" priority="2">
		<fo:inline>&#xA0;</fo:inline>
	</xsl:template>
	

	<xsl:template match="mpfd:references" mode="contents">
		<xsl:apply-templates mode="contents" />			
	</xsl:template>


	<!-- ============================= -->
	<!-- ============================= -->
	
	
	
	<xsl:template match="mpfd:title" name="title">
		
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		
		<xsl:variable name="font-size">
			<xsl:choose>
				<xsl:when test="$level = 1">13pt</xsl:when>
				<xsl:when test="$level = 2">11pt</xsl:when>
				<xsl:when test="$level &gt;= 3">12pt</xsl:when>
				<xsl:otherwise>12pt</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="space-before">
			<xsl:choose>
					<xsl:when test="parent::mpfd:annex">0pt</xsl:when>
					<xsl:when test="$level = 1">13.5pt</xsl:when>
					<xsl:when test="$level &gt;= 2">3pt</xsl:when>
					<xsl:otherwise>6pt</xsl:otherwise>
				</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="space-after">
			<xsl:choose>
				<xsl:when test="$level = 1">12pt</xsl:when>
				<xsl:when test="$level &gt;= 2">12pt</xsl:when>
				<xsl:otherwise>6pt</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<fo:block font-size="{$font-size}" color="rgb(14, 26, 133)" font-weight="bold" space-before="{$space-before}" space-after="{$space-after}" keep-with-next="always" role="H{$level}">
			<xsl:if test="parent::mpfd:annex">
				<xsl:attribute name="text-align">center</xsl:attribute>
				<xsl:attribute name="font-size">12pt</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates />
			<xsl:apply-templates select="following-sibling::*[1][local-name() = 'variant-title'][@type = 'sub']" mode="subtitle"/>
		</fo:block>
			
	</xsl:template>

	
	<xsl:template match="mpfd:p" name="paragraph">
		<xsl:param name="inline" select="'false'"/>
		<xsl:param name="split_keep-within-line"/>
		<xsl:variable name="previous-element" select="local-name(preceding-sibling::*[1])"/>
		<xsl:variable name="element-name">
			<xsl:choose>
				<xsl:when test="$inline = 'true'">fo:inline</xsl:when>
				<xsl:when test="../@inline-header = 'true' and $previous-element = 'title'">fo:inline</xsl:when> <!-- first paragraph after inline title -->
				<!-- <xsl:when test="local-name(..) = 'admonition'">fo:inline</xsl:when> -->
				<xsl:otherwise>fo:block</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:element name="{$element-name}">
			<xsl:attribute name="text-indent">0mm</xsl:attribute>
			
			<xsl:call-template name="setBlockAttributes"/>
			
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:if test="parent::mpfd:li">
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="line-height">115%</xsl:attribute>
			<xsl:apply-templates>
				<xsl:with-param name="split_keep-within-line" select="$split_keep-within-line"/>
			</xsl:apply-templates>
		</xsl:element>
		<xsl:if test="$element-name = 'fo:inline' and not($inline = 'true') and not(local-name(..) = 'admonition')">
			<xsl:choose>
				<xsl:when test="ancestor::mpfd:annex">
					<xsl:value-of select="$linebreak"/>
				</xsl:when>
				<xsl:otherwise>
					<fo:block margin-bottom="12pt">
						<xsl:value-of select="$linebreak"/>
					</fo:block>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		<xsl:if test="$inline = 'true'">
			<fo:block>&#xA0;</fo:block>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="mpfd:li//mpfd:p//text()">
		<xsl:choose>
			<xsl:when test="contains(., '&#x9;')">
				<fo:inline white-space="pre"><xsl:value-of select="."/></fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
	
	<xsl:template match="mpfd:ul | mpfd:ol" mode="list" priority="2">
		<fo:block-container margin-left="0mm">
			<xsl:variable name="margin-left">
				<xsl:variable name="countAncestorLists" select="count(ancestor::mpfd:ul) + count(ancestor::mpfd:ol)"/>					 
				<xsl:value-of select="$countAncestorLists * 7"/>
			</xsl:variable>
			<xsl:attribute name="margin-left">
					<xsl:value-of select="concat(normalize-space($margin-left),'mm')"/>
			</xsl:attribute>
			
			<fo:block-container margin-left="0mm">
				<xsl:call-template name="list" />
			</fo:block-container>
		</fo:block-container>
	</xsl:template>
	
	
	<xsl:template match="mpfd:preferred" priority="2">		
		<fo:inline font-weight="bold">
			<xsl:call-template name="setStyle_preferred"/>
			<xsl:apply-templates />
		</fo:inline>
		<xsl:if test="not(following-sibling::*[1][local-name() = 'preferred'])">
			<xsl:value-of select="$linebreak"/>
		</xsl:if>
	</xsl:template>

	
	<xsl:template match="mpfd:annex">
		<fo:block break-after="page"/>
		<fo:block id="{@id}">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>

	
	<xsl:template match="mpfd:formula/mpfd:stem" priority="2">
		<fo:block margin-top="14pt" margin-bottom="14pt" text-align-last="justify">
			<fo:inline padding-left="5mm"><xsl:apply-templates /></fo:inline>
			<fo:inline keep-together.within-line="always">
				<fo:leader leader-pattern="space"/>
				<xsl:apply-templates select="../mpfd:name" />
			</fo:inline>
		</fo:block>		
	</xsl:template>

	<xsl:variable name="Image-MPFD-Logo">
		<xsl:text>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</xsl:text>
	</xsl:variable>
	
	<xsl:template name="insertHeaderFooter">
		<xsl:param name="font-weight">normal</xsl:param>
		<fo:static-content flow-name="header-even" role="artifact">
			<fo:block-container height="100%" display-align="after">
				<fo:block>
					<xsl:value-of select="$copyrightShort"/>
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
							<fo:table-cell font-weight="{$font-weight}">
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
			<fo:block-container height="100%" display-align="after">
				<fo:block text-align="right">
					<xsl:value-of select="$copyrightShort"/>
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
							<fo:table-cell font-weight="{$font-weight}" padding-right="2mm">
								<fo:block padding-bottom="5mm" text-align="right"><fo:page-number/></fo:block>
							</fo:table-cell>
						</fo:table-row>
					</fo:table-body>
				</fo:table>
			</fo:block-container>
		</fo:static-content>
	</xsl:template>


</xsl:stylesheet>
