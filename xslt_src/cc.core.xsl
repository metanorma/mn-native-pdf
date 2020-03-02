<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:csd="https://www.calconnect.org/standards/csd" xmlns:mathml="http://www.w3.org/1998/Math/MathML" xmlns:xalan="http://xml.apache.org/xalan" xmlns:fox="http://xmlgraphics.apache.org/fop/extensions" version="1.0">

	<xsl:output version="1.0" method="xml" encoding="UTF-8" indent="no"/>

	<xsl:variable name="pageWidth" select="'210mm'"/>
	<xsl:variable name="pageHeight" select="'297mm'"/>

	<xsl:variable name="namespace">csd</xsl:variable>
	
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
	
	<xsl:variable name="contents">
		<contents>
			<xsl:apply-templates select="/csd:csd-standard/csd:preface/node()" mode="contents"/>
				<!-- <xsl:with-param name="sectionNum" select="'0'"/>
			</xsl:apply-templates> -->
			<xsl:apply-templates select="/csd:csd-standard/csd:sections/csd:clause[1]" mode="contents"> <!-- [@id = '_scope'] -->
				<xsl:with-param name="sectionNum" select="'1'"/>
			</xsl:apply-templates>
			<xsl:apply-templates select="/csd:csd-standard/csd:bibliography/csd:references[1]" mode="contents"> <!-- [@id = '_normative_references'] -->
				<xsl:with-param name="sectionNum" select="'2'"/>
			</xsl:apply-templates>
			<xsl:apply-templates select="/csd:csd-standard/csd:sections/*[position() &gt; 1]" mode="contents"> <!-- @id != '_scope' -->
				<xsl:with-param name="sectionNumSkew" select="'1'"/>
			</xsl:apply-templates>
			<xsl:apply-templates select="/csd:csd-standard/csd:annex" mode="contents"/>
			<xsl:apply-templates select="/csd:csd-standard/csd:bibliography/csd:references[position() &gt; 1]" mode="contents"/> <!-- @id = '_bibliography' -->
			
			<xsl:apply-templates select="//csd:figure" mode="contents"/>
			
			<xsl:apply-templates select="//csd:table" mode="contents"/>
			
		</contents>
	</xsl:variable>
	
	<xsl:variable name="lang">
		<xsl:call-template name="getLang"/>
	</xsl:variable>
	
	<xsl:template match="/">
		<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format" font-family="Arial, Times New Roman, Cambria Math, HanSans" font-size="10.5pt" xml:lang="{$lang}">
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
				<!-- <fo:simple-page-master master-name="document" page-width="{$pageWidth}" page-height="{$pageHeight}">
					<fo:region-body margin-top="23.5mm" margin-bottom="10mm" margin-left="19mm" margin-right="19mm"/>
					<fo:region-before extent="23.5mm"/>
					<fo:region-after extent="10mm"/>
					<fo:region-start extent="19mm"/>
					<fo:region-end extent="19mm"/>
				</fo:simple-page-master> -->
				
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
					<fo:region-body margin-top="20.2mm" margin-bottom="20.3mm" margin-left="19mm" margin-right="19mm"/>
					<fo:region-before region-name="header-odd" extent="20.2mm"/> 
					<fo:region-after region-name="footer-odd" extent="20.3mm"/>
					<fo:region-start region-name="left-region" extent="19mm"/>
					<fo:region-end region-name="right-region" extent="19mm"/>
				</fo:simple-page-master>
				<!-- Preface even pages -->
				<fo:simple-page-master master-name="even" page-width="{$pageWidth}" page-height="{$pageHeight}">
					<fo:region-body margin-top="20.2mm" margin-bottom="20.3mm" margin-left="19mm" margin-right="19mm"/>
					<fo:region-before region-name="header-even" extent="20.2mm"/>
					<fo:region-after region-name="footer-even" extent="20.3mm"/>
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
							<dc:title><xsl:value-of select="/csd:csd-standard/csd:bibdata/csd:title[@language = 'en']"/></dc:title>
							<dc:creator></dc:creator>
							<dc:description>
								<xsl:variable name="abstract">
									<xsl:copy-of select="/csd:csd-standard/csd:bibliography/csd:references/csd:bibitem/csd:abstract//text()"/>
								</xsl:variable>
								<xsl:value-of select="normalize-space($abstract)"/>
							</dc:description>
							<pdf:Keywords></pdf:Keywords>
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
					<fo:block font-size="24pt" font-weight="bold" text-align="center">
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
			
			
			<!-- Copyright, Content, Foreword, etc. pages -->
			<fo:page-sequence master-reference="preface" initial-page-number="2" format="i" force-page-count="end-on-even">
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
					
					<fo:block margin-bottom="15pt">&#xA0;</fo:block>
					<fo:block margin-bottom="14pt">
						<xsl:text>© </xsl:text>
						<xsl:value-of select="/csd:csd-standard/csd:bibdata/csd:copyright/csd:from"/>
						<xsl:text>  The Calendaring and Scheduling Consortium, Inc.</xsl:text>
					</fo:block>
					<fo:block margin-bottom="12pt">
						<xsl:text>All rights reserved. Unless otherwise specified, no part of this publication may be reproduced or utilized otherwise in any form or by any means, electronic or mechanical, including photocopying, or posting on the internet or an intranet, without prior written permission. Permission can be requested from the address below. </xsl:text>
					</fo:block>
					<fo:block margin-bottom="12pt">
						<xsl:text>The Calendaring and Scheduling Consortium, Inc.</xsl:text>
					</fo:block>
					<fo:block>
						<xsl:text>4390 Chaffin Lane</xsl:text>
						<xsl:value-of select="$linebreak"/>
						<xsl:text>McKinleyville</xsl:text>
						<xsl:value-of select="$linebreak"/>
						<xsl:text>California 95519</xsl:text>
						<xsl:value-of select="$linebreak"/>
						<xsl:text>United States of America</xsl:text>
						<xsl:value-of select="$linebreak"/>
						<xsl:value-of select="$linebreak"/>
						<fo:basic-link external-destination="copyright@calconnect.org" color="blue" text-decoration="underline" fox:alt-text="copyright@calconnect.org">copyright@calconnect.org</fo:basic-link>
						<xsl:value-of select="$linebreak"/>
						<fo:basic-link external-destination="www.calconnect.org" color="blue" text-decoration="underline" fox:alt-text="www.calconnect.org">www.calconnect.org</fo:basic-link>
					</fo:block>
					
					<fo:block break-after="page"/>
					
					<fo:block-container font-weight="bold" line-height="115%">
						<fo:block font-size="14pt"  margin-bottom="15.5pt">Contents</fo:block>
						
						<xsl:for-each select="xalan:nodeset($contents)//item[@display = 'true' and @level &lt;= 2][not(@level = 2 and starts-with(@section, '0'))]"><!-- skip clause from preface -->
							
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
													<xsl:if test="@section and @display-section = 'false'">
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
					</fo:block-container>
					
					<!-- Foreword, Introduction -->
					<xsl:apply-templates select="/csd:csd-standard/csd:preface/node()"/>
					
				</fo:flow>
			</fo:page-sequence>
			
			
			<!-- Document Pages -->
			<fo:page-sequence master-reference="document" initial-page-number="1" format="1" force-page-count="no-force">
				<fo:static-content flow-name="xsl-footnote-separator">
					<fo:block>
						<fo:leader leader-pattern="rule" leader-length="30%"/>
					</fo:block>
				</fo:static-content>
				<xsl:call-template name="insertHeaderFooter"/>
				<fo:flow flow-name="xsl-region-body">
					<fo:block font-size="16pt" font-weight="bold" margin-bottom="17pt" >
						<xsl:value-of select="/csd:csd-standard/csd:bibdata/csd:title[@language = 'en']"/>
					</fo:block>
					<fo:block>
						<xsl:apply-templates select="/csd:csd-standard/csd:sections/csd:clause[1]"> <!-- Scope -->
							<xsl:with-param name="sectionNum" select="'1'"/>
						</xsl:apply-templates>
						<!-- Normative references  -->
						<xsl:apply-templates select="/csd:csd-standard/csd:bibliography/csd:references[1]">
							<xsl:with-param name="sectionNum" select="'2'"/>
						</xsl:apply-templates>
						
						<!-- Other Sections -->
						<xsl:apply-templates select="/csd:csd-standard/csd:sections/*[position() &gt; 1]">
							<xsl:with-param name="sectionNumSkew" select="'1'"/>
						</xsl:apply-templates>
						
						<xsl:apply-templates select="/csd:csd-standard/csd:annex"/>
						<xsl:apply-templates select="/csd:csd-standard/csd:bibliography/csd:references[position() &gt; 1]" />
						
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
	<xsl:template match="csd:csd-standard/csd:sections/*" mode="contents">
		<xsl:param name="sectionNum"/>
		<xsl:param name="sectionNumSkew" select="0"/>
		<xsl:variable name="sectionNum_">
			<xsl:choose>
				<xsl:when test="$sectionNum"><xsl:value-of select="$sectionNum"/></xsl:when>
				<xsl:when test="$sectionNumSkew != 0">
					<xsl:variable name="number"><xsl:number count="*"/></xsl:variable> <!-- csd:sections/csd:clause | csd:sections/csd:terms -->
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
	<xsl:template match="csd:title | csd:preferred" mode="contents">
		<xsl:param name="sectionNum"/>
		<!-- sectionNum=<xsl:value-of select="$sectionNum"/> -->
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
				<xsl:when test="ancestor::csd:bibitem">false</xsl:when>
				<xsl:when test="ancestor::csd:term">false</xsl:when>
				<xsl:when test="ancestor::csd:annex and $level &gt;= 2">false</xsl:when>
				<xsl:when test="$level &lt;= 3">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="display-section">
			<xsl:choose>
				<xsl:when test="ancestor::csd:annex">false</xsl:when>
				<xsl:otherwise>true</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="type">
			<xsl:value-of select="local-name(..)"/>
		</xsl:variable>

		<xsl:variable name="root">
			<xsl:choose>
				<xsl:when test="ancestor::csd:annex">annex</xsl:when>
				<xsl:when test="ancestor::csd:clause">clause</xsl:when>
			</xsl:choose>
		</xsl:variable>
		
		<item id="{$id}" level="{$level}" section="{$section}" display-section="{$display-section}" display="{$display}" type="{$type}" root="{$root}">
			<xsl:attribute name="addon">
				<xsl:if test="local-name(..) = 'annex'"><xsl:value-of select="../@obligation"/></xsl:if>
			</xsl:attribute>
			<xsl:value-of select="."/>
		</item>
		
		<xsl:apply-templates mode="contents">
			<xsl:with-param name="sectionNum" select="$sectionNum"/>
		</xsl:apply-templates>
		
	</xsl:template>
	
	
	<xsl:template match="csd:figure" mode="contents">
		<item level="" id="{@id}" display="false">
			<xsl:attribute name="section">
				<xsl:text>Figure </xsl:text><xsl:number format="A.1-1" level="multiple" count="csd:annex | csd:figure"/>
			</xsl:attribute>
		</item>
	</xsl:template>
	
	
	<xsl:template match="csd:table" mode="contents">
		<xsl:param name="sectionNum" />
		<xsl:variable name="annex-id" select="ancestor::csd:annex/@id"/>
		<item level="" id="{@id}" display="false" type="table">
			<xsl:attribute name="section">
				<xsl:text>Table </xsl:text>
				<xsl:choose>
					<xsl:when test="ancestor::*[local-name()='executivesummary']"> <!-- NIST -->
							<xsl:text>ES-</xsl:text><xsl:number format="1" count="*[local-name()='executivesummary']//*[local-name()='table']"/>
						</xsl:when>
					<xsl:when test="ancestor::*[local-name()='annex']">
						<xsl:number format="A-" count="csd:annex"/>
						<xsl:number format="1" level="any" count="csd:table[ancestor::csd:annex[@id = $annex-id]]"/>
					</xsl:when>
					<xsl:otherwise>
						<!-- <xsl:number format="1"/> -->
						<xsl:number format="1" level="any" count="*[local-name()='sections']//*[local-name()='table']"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:value-of select="csd:name/text()"/>
		</item>
	</xsl:template>
	
	
	
	<xsl:template match="csd:formula" mode="contents">
		<item level="" id="{@id}" display="false">
			<xsl:attribute name="section">
				<xsl:text>Formula (</xsl:text><xsl:number format="A.1" level="multiple" count="csd:annex | csd:formula"/><xsl:text>)</xsl:text>
			</xsl:attribute>
		</item>
	</xsl:template>
	<!-- ============================= -->
	<!-- ============================= -->
	
	
	<xsl:template match="csd:license-statement//csd:title">
		<fo:block text-align="center" font-weight="bold">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="csd:license-statement//csd:p">
		<fo:block margin-left="1.5mm" margin-right="1.5mm">
			<xsl:if test="following-sibling::csd:p">
				<xsl:attribute name="margin-top">6pt</xsl:attribute>
				<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<!-- <fo:block margin-bottom="12pt">© ISO 2019, Published in Switzerland.</fo:block>
			<fo:block font-size="10pt" margin-bottom="12pt">All rights reserved. Unless otherwise specified, no part of this publication may be reproduced or utilized otherwise in any form or by any means, electronic or mechanical, including photocopying, or posting on the internet or an intranet, without prior written permission. Permission can be requested from either ISO at the address below or ISO’s member body in the country of the requester.</fo:block>
			<fo:block font-size="10pt" text-indent="7.1mm">
				<fo:block>ISO copyright office</fo:block>
				<fo:block>Ch. de Blandonnet 8 • CP 401</fo:block>
				<fo:block>CH-1214 Vernier, Geneva, Switzerland</fo:block>
				<fo:block>Tel.  + 41 22 749 01 11</fo:block>
				<fo:block>Fax  + 41 22 749 09 47</fo:block>
				<fo:block>copyright@iso.org</fo:block>
				<fo:block>www.iso.org</fo:block>
			</fo:block> -->
	
	<xsl:template match="csd:copyright-statement//csd:p">
		<fo:block>
			<xsl:if test="preceding-sibling::csd:p">
				<!-- <xsl:attribute name="font-size">10pt</xsl:attribute> -->
			</xsl:if>
			<xsl:if test="following-sibling::csd:p">
				<!-- <xsl:attribute name="margin-bottom">12pt</xsl:attribute> -->
				<xsl:attribute name="margin-bottom">3pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="not(following-sibling::csd:p)">
				<!-- <xsl:attribute name="margin-left">7.1mm</xsl:attribute> -->
				<xsl:attribute name="margin-left">4mm</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<!-- Foreword, Introduction -->
	<xsl:template match="csd:csd-standard/csd:preface/*">
		<fo:block break-after="page"/>
		<!-- <fo:block> -->
			<xsl:apply-templates />
		<!-- </fo:block> -->
	</xsl:template>
	

	
	<!-- clause, terms, clause, ...-->
	<xsl:template match="csd:csd-standard/csd:sections/*">
		<xsl:param name="sectionNum"/>
		<xsl:param name="sectionNumSkew" select="0"/>
		<fo:block>
			<xsl:variable name="pos"><xsl:number count="csd:sections/csd:clause | csd:sections/csd:terms"/></xsl:variable>
			<xsl:if test="$pos &gt;= 2">
				<xsl:attribute name="space-before">18pt</xsl:attribute>
			</xsl:if>
			<!-- pos=<xsl:value-of select="$pos" /> -->
			<xsl:variable name="sectionNum_">
				<xsl:choose>
					<xsl:when test="$sectionNum"><xsl:value-of select="$sectionNum"/></xsl:when>
					<xsl:when test="$sectionNumSkew != 0">
						<xsl:variable name="number"><xsl:number count="csd:sections/csd:clause | csd:sections/csd:terms"/></xsl:variable>
						<xsl:value-of select="$number + $sectionNumSkew"/>
					</xsl:when>
				</xsl:choose>
			</xsl:variable>
			<xsl:if test="not(csd:title)">
				<fo:block margin-top="3pt" margin-bottom="12pt">
					<xsl:value-of select="$sectionNum_"/><xsl:number format=".1 " level="multiple" count="csd:clause" />
				</fo:block>
			</xsl:if>
			<xsl:apply-templates>
				<xsl:with-param name="sectionNum" select="$sectionNum_"/>
			</xsl:apply-templates>
		</fo:block>
	</xsl:template>
	

	
	<xsl:template match="csd:clause//csd:clause[not(csd:title)]">
		<xsl:param name="sectionNum"/>
		<xsl:variable name="section">
			<xsl:call-template name="getSection">
				<xsl:with-param name="sectionNum" select="$sectionNum"/>
			</xsl:call-template>
		</xsl:variable>
		
		<fo:block margin-top="3pt" ><!-- margin-bottom="6pt" -->
			<fo:inline font-weight="bold" padding-right="3mm">
				<xsl:value-of select="$section"/><!-- <xsl:number format=".1 "  level="multiple" count="csd:clause/csd:clause" /> -->
			</fo:inline>
			<xsl:apply-templates>
				<xsl:with-param name="sectionNum" select="$sectionNum"/>
				<xsl:with-param name="inline" select="'true'"/>
			</xsl:apply-templates>
		</fo:block>
	</xsl:template>
	
	
	<xsl:template match="csd:title">
		<xsl:param name="sectionNum"/>
		
		<xsl:variable name="parent-name"  select="local-name(..)"/>
		<xsl:variable name="references_num_current">
			<xsl:number level="any" count="csd:references"/>
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
					<xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute>
					<xsl:attribute name="font-size"><xsl:value-of select="$font-size"/></xsl:attribute>
					<xsl:attribute name="font-weight">bold</xsl:attribute>
					<!-- <xsl:attribute name="margin-top"> 
						<xsl:choose>
							<xsl:when test="$level = 2 and ancestor::annex">18pt</xsl:when>
							<xsl:when test="$level = '' or $level = 1">6pt</xsl:when>
							<xsl:otherwise>12pt</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute> -->
					<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
					<xsl:attribute name="keep-with-next">always</xsl:attribute>		
					<xsl:attribute name="color"><xsl:value-of select="$color"/></xsl:attribute>
					<xsl:if test="ancestor::csd:sections">
						<xsl:attribute name="margin-top">13.5pt</xsl:attribute>
					</xsl:if>
						<!-- DEBUG level=<xsl:value-of select="$level"/>x -->
						<!-- section=<xsl:value-of select="$sectionNum"/> -->
						<!-- <xsl:if test="$sectionNum"> -->
						<xsl:if test="$section != ''">
							<xsl:value-of select="$section"/><xsl:text>.</xsl:text>
							<xsl:choose>
								<xsl:when test="$level &gt;= 3">
									<fo:inline padding-right="2mm">&#xA0;</fo:inline>
								</xsl:when>
								<xsl:when test="$level = 1">
									<fo:inline padding-right="2mm">&#xA0;</fo:inline>
								</xsl:when>
								<xsl:otherwise>
									<fo:inline padding-right="1mm">&#xA0;</fo:inline>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:if>
						<xsl:apply-templates />
				</xsl:element>
		
		
		<xsl:choose>
			<xsl:when test="$parent-name = 'annex2'">
				<fo:block id="{$id}" font-size="16pt" font-weight="bold" text-align="center" margin-bottom="12pt" keep-with-next="always">
					<xsl:value-of select="$section"/>
					<xsl:if test=" ../@obligation">
						<xsl:value-of select="$linebreak"/>
						<fo:inline font-weight="normal">(<xsl:value-of select="../@obligation"/>)</fo:inline>
					</xsl:if>
					<fo:block margin-top="18pt" margin-bottom="48pt"><xsl:apply-templates /></fo:block>
				</fo:block>
			</xsl:when>
			<xsl:when test="$parent-name = 'references2' and $references_num_current != 1"> <!-- Bibliography -->
				<fo:block id="{$id}" font-size="16pt" font-weight="bold" color="{$color}" text-align="center" margin-top="6pt" margin-bottom="36pt" keep-with-next="always">
					<xsl:apply-templates />
				</fo:block>
			</xsl:when>
			
			<xsl:otherwise>
				
				
				<!-- <xsl:if test="$element-name = 'fo:inline' and not(following-sibling::csd:p)">
					<fo:block > 
						<xsl:value-of select="$linebreak"/>
					</fo:block>
				</xsl:if> -->
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	

	
	<xsl:template match="csd:p">
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
			<xsl:attribute name="text-align">
				<xsl:choose>
					<!-- <xsl:when test="ancestor::csd:preface">justify</xsl:when> -->
					<xsl:when test="@align"><xsl:value-of select="@align"/></xsl:when>
					<xsl:otherwise>left</xsl:otherwise><!-- justify -->
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="margin-bottom">
				<xsl:choose>
					<xsl:when test="ancestor::csd:li">0pt</xsl:when>
					<xsl:otherwise>12pt</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="line-height">115%</xsl:attribute>
			<xsl:apply-templates />
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
	
	<!--
	<fn reference="1">
			<p id="_8e5cf917-f75a-4a49-b0aa-1714cb6cf954">Formerly denoted as 15 % (m/m).</p>
		</fn>
	-->
	<xsl:template match="csd:p/csd:fn">
		<fo:footnote>
			<xsl:variable name="number">
				<xsl:number level="any" count="csd:p/csd:fn"/>
			</xsl:variable>
			<fo:inline font-size="65%" keep-with-previous.within-line="always" vertical-align="super">
				<fo:basic-link internal-destination="footnote_{@reference}" fox:alt-text="footnote {@reference}">
					<!-- <xsl:value-of select="@reference"/> -->
					<xsl:value-of select="$number + count(//csd:bibitem/csd:note)"/><!-- <xsl:text>)</xsl:text> -->
				</fo:basic-link>
			</fo:inline>
			<fo:footnote-body>
				<fo:block font-size="10pt" margin-bottom="12pt">
					<fo:inline id="footnote_{@reference}" keep-with-next.within-line="always" font-size="60%" vertical-align="super"> <!-- baseline-shift="30%" padding-right="3mm" font-size="60%"  alignment-baseline="hanging" -->
						<xsl:value-of select="$number + count(//csd:bibitem/csd:note)"/><!-- <xsl:text>)</xsl:text> -->
					</fo:inline>
					<xsl:for-each select="csd:p">
							<xsl:apply-templates />
					</xsl:for-each>
				</fo:block>
			</fo:footnote-body>
		</fo:footnote>
	</xsl:template>

	<xsl:template match="csd:p/csd:fn/csd:p">
		<xsl:apply-templates />
	</xsl:template>
	
	<xsl:template match="csd:review">
		<!-- comment 2019-11-29 -->
		<!-- <fo:block font-weight="bold">Review:</fo:block>
		<xsl:apply-templates /> -->
	</xsl:template>

	<xsl:template match="text()">
		<xsl:value-of select="."/>
	</xsl:template>
	


	<xsl:template match="csd:image">
		<fo:block-container text-align="center">
			<fo:block>
				<fo:external-graphic src="{@src}" fox:alt-text="Image {@alt}"/>
			</fo:block>
			<fo:block font-weight="bold" margin-top="12pt" margin-bottom="12pt">Figure <xsl:number format="1" level="any"/></fo:block>
		</fo:block-container>
		
	</xsl:template>

	<xsl:template match="csd:figure">
		<xsl:variable name="title">
			<xsl:text>Figure </xsl:text>
		</xsl:variable>
		
		<fo:block-container id="{@id}">
			<fo:block>
				<xsl:apply-templates />
			</fo:block>
			<xsl:call-template name="fn_display_figure"/>
			<xsl:for-each select="csd:note//csd:p">
				<xsl:call-template name="note"/>
			</xsl:for-each>
			<fo:block font-weight="bold" text-align="center" margin-top="12pt" margin-bottom="12pt" keep-with-previous="always">
				
				<xsl:choose>
					<xsl:when test="ancestor::csd:annex">
						<xsl:choose>
							<xsl:when test="local-name(..) = 'figure'">
								<xsl:number format="a) "/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$title"/><xsl:number format="A.1-1" level="multiple" count="csd:annex | csd:figure"/>
							</xsl:otherwise>
						</xsl:choose>
						
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$title"/><xsl:number format="1" level="any"/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:if test="csd:name">
					<xsl:if test="not(local-name(..) = 'figure')">
						<xsl:text> — </xsl:text>
					</xsl:if>
					<xsl:value-of select="csd:name"/>
				</xsl:if>
			</fo:block>
		</fo:block-container>
	</xsl:template>
	
	<xsl:template match="csd:figure/csd:name"/>
	<xsl:template match="csd:figure/csd:fn"/>
	<xsl:template match="csd:figure/csd:note"/>
	
	
	<xsl:template match="csd:figure/csd:image">
		<fo:block text-align="center">
			<fo:external-graphic src="{@src}" content-width="100%" content-height="scale-to-fit" scaling="uniform" fox:alt-text="Image {@alt}"/> <!-- content-width="75%"  -->
		</fo:block>
	</xsl:template>
	
	
	<xsl:template match="csd:bibitem">
		<fo:block id="{@id}" margin-bottom="6pt"> <!-- 12 pt -->
			<xsl:if test=".//csd:fn">
				<xsl:attribute name="line-height-shift-adjustment">disregard-shifts</xsl:attribute>
			</xsl:if>
				<!-- csd:docidentifier -->
			<xsl:if test="csd:docidentifier">
				<xsl:choose>
					<xsl:when test="csd:docidentifier/@type = 'metanorma'"/>
					<xsl:otherwise>
						<xsl:value-of select="csd:docidentifier"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:apply-templates select="csd:note"/>
			<xsl:if test="csd:docidentifier">, </xsl:if>
			<fo:inline font-style="italic">
				<xsl:choose>
					<xsl:when test="csd:title[@type = 'main' and @language = 'en']">
						<xsl:value-of select="csd:title[@type = 'main' and @language = 'en']"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="csd:title"/>
					</xsl:otherwise>
				</xsl:choose>
			</fo:inline>
		</fo:block>
	</xsl:template>
	
	
	<xsl:template match="csd:bibitem/csd:note">
		<fo:footnote>
			<xsl:variable name="number">
				<xsl:choose>
					<xsl:when test="ancestor::csd:references[preceding-sibling::csd:references]">
						<xsl:number level="any" count="csd:references[preceding-sibling::csd:references]//csd:bibitem/csd:note"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:number level="any" count="csd:bibitem/csd:note"/>
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
	
	
	
	<xsl:template match="csd:ul | csd:ol">
		<fo:list-block provisional-distance-between-starts="6.5mm" margin-bottom="12pt">
			<xsl:if test="ancestor::csd:ol">
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates />
		</fo:list-block>
	</xsl:template>
	
	<xsl:template match="csd:li">
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
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>
	
	<xsl:template match="csd:link">
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
	
	<xsl:template match="csd:preferred">
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
				<xsl:when test="$level &gt;= 3">11pt</xsl:when>
				<xsl:otherwise>12pt</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<fo:block font-size="{$font-size}" line-height="1.1">
			<fo:block font-weight="bold" keep-with-next="always">
				<fo:inline id="{../@id}">
					<xsl:value-of select="$section"/><xsl:text>.</xsl:text>
					<!-- <xsl:value-of select="$sectionNum"/>.<xsl:number count="csd:term"/> -->
				</fo:inline>
			</fo:block>
			<fo:block font-weight="bold" keep-with-next="always">
				<xsl:apply-templates />
			</fo:block>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="csd:admitted">
		<fo:block>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="csd:deprecates">
		<fo:block>DEPRECATED: <xsl:apply-templates /></fo:block>
	</xsl:template>
	
	<xsl:template match="csd:definition[preceding-sibling::csd:domain]">
		<xsl:apply-templates />
	</xsl:template>
	<xsl:template match="csd:definition[preceding-sibling::csd:domain]/csd:p">
		<fo:inline> <xsl:apply-templates /></fo:inline>
		<fo:block>&#xA0;</fo:block>
	</xsl:template>
	
	<xsl:template match="csd:definition">
		<fo:block margin-bottom="6pt">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="csd:termsource">
		<fo:block margin-bottom="8pt" keep-with-previous="always">
			<!-- Example: [SOURCE: ISO 5127:2017, 3.1.6.02] -->
			<fo:basic-link internal-destination="{csd:origin/@bibitemid}" fox:alt-text="{csd:origin/@citeas}">
				<xsl:text>[SOURCE: </xsl:text>
				<xsl:value-of select="csd:origin/@citeas"/>
				<xsl:if test="csd:origin/csd:locality/csd:referenceFrom">
					<xsl:text>, </xsl:text><xsl:value-of select="csd:origin/csd:locality/csd:referenceFrom"/>
				</xsl:if>
			</fo:basic-link>
			<xsl:apply-templates select="csd:modification"/>
			<xsl:text>]</xsl:text>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="csd:modification">
		<xsl:text>, modified — </xsl:text>
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="csd:modification/csd:p">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template>
	
	<xsl:template match="csd:termnote">
		<fo:block font-size="10pt" margin-bottom="12pt">
			<xsl:text>Note </xsl:text>
			<xsl:number />
			<xsl:text> to entry: </xsl:text>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="csd:termnote/csd:p">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template>
	
	<xsl:template match="csd:domain">
		<fo:inline>&lt;<xsl:apply-templates/>&gt;</fo:inline>
	</xsl:template>
	
	
	<xsl:template match="csd:termexample">
		<fo:block font-size="10pt" margin-bottom="12pt">
			<fo:inline padding-right="10mm">EXAMPLE</fo:inline>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="csd:termexample/csd:p">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template>

	
	<xsl:template match="csd:annex">
		<fo:block break-after="page"/>
		<xsl:apply-templates />
	</xsl:template>

	
	<!-- <xsl:template match="csd:references[@id = '_bibliography']"> -->
	<xsl:template match="csd:references[position() &gt; 1]">
		<fo:block break-after="page"/>
			<xsl:apply-templates />
	</xsl:template>


	<!-- Example: [1] ISO 9:1995, Information and documentation – Transliteration of Cyrillic characters into Latin characters – Slavic and non-Slavic languages -->
	<!-- <xsl:template match="csd:references[@id = '_bibliography']/csd:bibitem"> -->
	<xsl:template match="csd:references[position() &gt; 1]/csd:bibitem">
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
						<xsl:if test="csd:docidentifier">
							<xsl:choose>
								<xsl:when test="csd:docidentifier/@type = 'metanorma'"/>
								<xsl:otherwise><fo:inline><xsl:value-of select="csd:docidentifier"/><xsl:apply-templates select="csd:note"/>, </fo:inline></xsl:otherwise>
							</xsl:choose>
							
						</xsl:if>
						<xsl:choose>
							<xsl:when test="csd:title[@type = 'main' and @language = 'en']">
								<xsl:apply-templates select="csd:title[@type = 'main' and @language = 'en']"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates select="csd:title"/>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:apply-templates select="csd:formattedref"/>
					</fo:block>
				</fo:list-item-body>
			</fo:list-item>
		</fo:list-block>
	</xsl:template>
	
	<!-- <xsl:template match="csd:references[@id = '_bibliography']/csd:bibitem" mode="contents"/> -->
	<xsl:template match="csd:references[position() &gt; 1]/csd:bibitem" mode="contents"/>
	
	<!-- <xsl:template match="csd:references[@id = '_bibliography']/csd:bibitem/csd:title"> -->
	<xsl:template match="csd:references[position() &gt; 1]/csd:bibitem/csd:title">
		<fo:inline font-style="italic">
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>

	<xsl:template match="csd:quote">
		<fo:block margin-top="12pt" margin-left="12mm" margin-right="12mm">
			<xsl:apply-templates select=".//csd:p"/>
		</fo:block>
		<fo:block text-align="right">
			<!-- — ISO, ISO 7301:2011, Clause 1 -->
			<xsl:text>— </xsl:text><xsl:value-of select="csd:author"/>
			<xsl:if test="csd:source">
				<xsl:text>, </xsl:text>
				<xsl:apply-templates select="csd:source"/>
			</xsl:if>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="csd:source">
		<fo:basic-link internal-destination="{@bibitemid}" fox:alt-text="{@citeas}">
			<xsl:value-of select="@citeas" disable-output-escaping="yes"/>
			<xsl:if test="csd:locality">
				<xsl:text>, </xsl:text>
				<xsl:apply-templates select="csd:locality"/>
			</xsl:if>
		</fo:basic-link>
	</xsl:template>
	
	<xsl:template match="csd:appendix">
		<fo:block font-size="12pt" font-weight="bold" margin-top="12pt" margin-bottom="12pt">
			<fo:inline padding-right="5mm">Appendix <xsl:number /></fo:inline>
			<xsl:apply-templates select="csd:title" mode="process"/>
		</fo:block>
		<xsl:apply-templates />
	</xsl:template>
	
	<xsl:template match="csd:appendix//csd:example">
		<fo:block font-size="10pt" margin-bottom="12pt">
			<xsl:text>EXAMPLE</xsl:text>
			<xsl:if test="csd:name">
				<xsl:text> — </xsl:text><xsl:apply-templates select="csd:name" mode="process"/>
			</xsl:if>
		</fo:block>
		<xsl:apply-templates />
	</xsl:template>
	
	<xsl:template match="csd:appendix//csd:example/csd:name"/>
	<xsl:template match="csd:appendix//csd:example/csd:name" mode="process">
		<fo:inline><xsl:apply-templates /></fo:inline>
	</xsl:template>
	
	<!-- <xsl:template match="csd:callout/text()">	
		<fo:basic-link internal-destination="{@target}"><fo:inline>&lt;<xsl:apply-templates />&gt;</fo:inline></fo:basic-link>
	</xsl:template> -->
	<xsl:template match="csd:callout">		
			<fo:basic-link internal-destination="{@target}" fox:alt-text="{@target}">&lt;<xsl:apply-templates />&gt;</fo:basic-link>
	</xsl:template>
	
	<xsl:template match="csd:annotation">
		<fo:block>
			
		</fo:block>
		<xsl:apply-templates />
	</xsl:template>
	
	<xsl:template match="csd:annotation/text()"/>
	
	<xsl:template match="csd:annotation/csd:p">
		<xsl:variable name="annotation-id" select="../@id"/>
		<xsl:variable name="callout" select="//*[@target = $annotation-id]/text()"/>
		<fo:block id="{$annotation-id}">
			<xsl:value-of select="concat('&lt;', $callout, '&gt; ')"/>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	
	<xsl:template match="csd:appendix/csd:title"/>
	<xsl:template match="csd:appendix/csd:title" mode="process">
		<fo:inline><xsl:apply-templates /></fo:inline>
	</xsl:template>
	
	<xsl:template match="mathml:math">
		<!-- <fo:inline font-size="12pt" color="red">
			MathML issue! <xsl:apply-templates />
		</fo:inline> -->
		<fo:instream-foreign-object fox:alt-text="Math">
			<xsl:copy-of select="."/>
		</fo:instream-foreign-object>
	</xsl:template>
	
	<xsl:template match="csd:xref">
		<fo:basic-link internal-destination="{@target}" fox:alt-text="{@target}">
			<xsl:variable name="section" select="xalan:nodeset($contents)//item[@id = current()/@target]/@section"/>
			<xsl:if test="not(starts-with($section, 'Figure') or starts-with($section, 'Table'))">
				<xsl:attribute name="color">blue</xsl:attribute>
				<xsl:attribute name="text-decoration">underline</xsl:attribute>
			</xsl:if>
			<xsl:variable name="type" select="xalan:nodeset($contents)//item[@id = current()/@target]/@type"/>
			<xsl:variable name="root" select="xalan:nodeset($contents)//item[@id = current()/@target]/@root"/>
			<xsl:choose>
				<xsl:when test="$type = 'clause' and $root != 'annex'">Clause </xsl:when><!-- and not (ancestor::annex) -->
				<xsl:when test="$type = 'term' and $root = 'clause'">Clause </xsl:when>
				<xsl:otherwise></xsl:otherwise> <!-- <xsl:value-of select="$type"/> -->
			</xsl:choose>
			<xsl:value-of select="$section"/>
      </fo:basic-link>
	</xsl:template>

	<xsl:template match="csd:sourcecode">
		<fo:block font-family="Courier" font-size="10pt" margin-bottom="6pt" keep-with-next="always">
			<xsl:choose>
				<xsl:when test="@lang = 'en'"></xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="white-space">pre</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates/>
		</fo:block>
		<fo:block font-size="11pt" font-weight="bold" text-align="center" margin-bottom="12pt">
			<xsl:text>Figure </xsl:text>
			<xsl:number format="1" level="any"/>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="csd:example">
		<fo:block font-size="10pt" margin-bottom="12pt" font-weight="bold" keep-with-next="always">
			<xsl:text>EXAMPLE</xsl:text>
			<xsl:if test="following-sibling::csd:example or preceding-sibling::csd:example">
				<xsl:number format=" 1"/>
			</xsl:if>
		</fo:block>
		<fo:block  font-size="10pt" margin-left="12.5mm">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="csd:example/csd:p">
		<fo:block  margin-bottom="14pt">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="csd:note/csd:p" name="note">
		<fo:block font-size="10pt" margin-bottom="12pt">
			<fo:inline padding-right="6mm">NOTE <xsl:number count="csd:note"/></fo:inline>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>

	<!-- <eref type="inline" bibitemid="ISO20483" citeas="ISO 20483:2013"><locality type="annex"><referenceFrom>C</referenceFrom></locality></eref> -->
	<xsl:template match="csd:eref">
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
				<xsl:when test="@citeas">
					<xsl:value-of select="@citeas" disable-output-escaping="yes"/>
				</xsl:when>
				<xsl:when test="@bibitemid">
					<xsl:value-of select="//csd:bibitem[@id = current()/@bibitemid]/csd:docidentifier"/>
				</xsl:when>
				<xsl:otherwise></xsl:otherwise>
			</xsl:choose>
			<xsl:if test="csd:locality">
				<xsl:text>, </xsl:text>
				<!-- <xsl:choose>
						<xsl:when test="csd:locality/@type = 'section'">Section </xsl:when>
						<xsl:when test="csd:locality/@type = 'clause'">Clause </xsl:when>
						<xsl:otherwise></xsl:otherwise>
					</xsl:choose> -->
					<xsl:apply-templates select="csd:locality"/>
			</xsl:if>
		</fo:basic-link>
	</xsl:template>
	
	<xsl:template match="csd:locality">
		<xsl:choose>
			<xsl:when test="@type ='clause'">Clause </xsl:when>
			<xsl:when test="@type ='annex'">Annex </xsl:when>
			<xsl:otherwise><xsl:value-of select="@type"/></xsl:otherwise>
		</xsl:choose>
		<xsl:text> </xsl:text><xsl:value-of select="csd:referenceFrom"/>
	</xsl:template>
	
	<xsl:template match="csd:admonition">
		<fo:block margin-bottom="12pt" font-weight="bold"> <!-- text-align="center"  -->
			<xsl:value-of select="translate(@type, $lower, $upper)"/>
			<xsl:text> — </xsl:text>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="csd:formula/csd:dt/csd:stem">
		<fo:inline>
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="csd:formula/csd:stem">
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
									<xsl:when test="ancestor::csd:annex">
										<xsl:text>(</xsl:text><xsl:number format="A.1" level="multiple" count="csd:annex | csd:formula"/><xsl:text>)</xsl:text>
									</xsl:when>
									<xsl:otherwise> <!-- not(ancestor::csd:annex) -->
										<!-- <xsl:text>(</xsl:text><xsl:number level="any" count="csd:formula"/><xsl:text>)</xsl:text> -->
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
	
	
	<xsl:template match="csd:br" priority="2">
		<!-- <fo:block>&#xA0;</fo:block> -->
		<xsl:value-of select="$linebreak"/>
	</xsl:template>
	
	<xsl:template name="insertHeaderFooter">
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
								<fo:block padding-bottom="5mm" text-align="right"><fo:page-number/></fo:block>
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
				<xsl:when test="ancestor::csd:preface">
					<xsl:value-of select="$level_total - 2"/>
				</xsl:when>
				<xsl:when test="ancestor::csd:sections">
					<xsl:value-of select="$level_total - 2"/>
				</xsl:when>
				<xsl:when test="ancestor::csd:bibliography">
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
				<xsl:when test="ancestor::csd:bibliography">
					<xsl:value-of select="$sectionNum"/>
				</xsl:when>
				<xsl:when test="ancestor::csd:sections">
					<!-- 1, 2, 3, 4, ... from main section (not annex, bibliography, ...) -->
					<xsl:choose>
						<xsl:when test="$level = 1">
							<xsl:value-of select="$sectionNum"/>
						</xsl:when>
						<xsl:when test="$level &gt;= 2">
							<xsl:variable name="num">
								<xsl:number format=".1" level="multiple" count="csd:clause/csd:clause | csd:clause/csd:terms | csd:terms/csd:term | csd:clause/csd:term | csd:clause/csd:definitions | csd:definitions/csd:definitions"/>
							</xsl:variable>
							<xsl:value-of select="concat($sectionNum, $num)"/>
						</xsl:when>
						<xsl:otherwise>
							<!-- z<xsl:value-of select="$sectionNum"/>z -->
						</xsl:otherwise>
					</xsl:choose>
					<!-- <xsl:text>.</xsl:text> -->
				</xsl:when>
				<!-- <xsl:when test="ancestor::csd:annex[@obligation = 'informative']">
					<xsl:choose>
						<xsl:when test="$level = 1">
							<xsl:text>Annex  </xsl:text>
							<xsl:number format="I" level="any" count="csd:annex[@obligation = 'informative']"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:number format="I.1" level="multiple" count="csd:annex[@obligation = 'informative'] | csd:clause"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when> -->
				<xsl:when test="ancestor::csd:annex">
					<xsl:choose>
						<xsl:when test="$level = 1">
							<xsl:text>Annex </xsl:text>
							<xsl:choose>
								<xsl:when test="count(//csd:annex) = 1">
									<xsl:value-of select="/csd:csd-standard/csd:bibdata/csd:ext/csd:structuredidentifier/csd:annexid"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:number format="A." level="any" count="csd:annex"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="count(//csd:annex) = 1">
									<xsl:value-of select="/csd:csd-standard/csd:bibdata/csd:ext/csd:structuredidentifier/csd:annexid"/><xsl:number format=".1" level="multiple" count="csd:clause"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:number format="A.1." level="multiple" count="csd:annex | csd:clause"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="ancestor::csd:preface"> <!-- if preface and there is clause(s) -->
					<xsl:choose>
						<xsl:when test="$level = 1 and  ..//csd:clause">0</xsl:when>
						<xsl:when test="$level &gt;= 2">
							<xsl:variable name="num">
								<xsl:number format=".1." level="multiple" count="csd:clause"/>
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

	<xsl:template name="capitalizeWords">
		<xsl:param name="str" />
		<xsl:variable name="str2" select="translate($str, '-', ' ')"/>
		<xsl:choose>
			<xsl:when test="contains($str2, ' ')">
				<xsl:variable name="substr" select="substring-before($str2, ' ')"/>
				<xsl:value-of select="translate(substring($substr, 1, 1), $lower, $upper)"/>
				<xsl:value-of select="substring($substr, 2)"/>
				<xsl:text> </xsl:text>
				<xsl:call-template name="capitalizeWords">
					<xsl:with-param name="str" select="substring-after($str2, ' ')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="translate(substring($str2, 1, 1), $lower, $upper)"/>
				<xsl:value-of select="substring($str2, 2)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>
