<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:iso="http://riboseinc.com/isoxml" xmlns:mathml="http://www.w3.org/1998/Math/MathML" xmlns:xalan="http://xml.apache.org/xalan" version="1.0">

	<xsl:output method="xml" encoding="UTF-8" indent="yes"/>
	
	<xsl:include href="./common.xsl"/>
	
	<xsl:variable name="pageWidth" select="'210mm'"/>
	<xsl:variable name="pageHeight" select="'297mm'"/>

	<xsl:variable name="copyrightText" select="concat('© ISO ', iso:iso-standard/iso:bibdata/iso:copyright/iso:from ,' – All rights reserved')"/>
	<xsl:variable name="ISOname" select="concat(/iso:iso-standard/iso:bibdata/iso:docidentifier, ':', /iso:iso-standard/iso:bibdata/iso:copyright/iso:from , '(', translate(substring(iso:iso-standard/iso:bibdata/iso:language,1,1),$lower, $upper), ') ')"/>
	
	<!-- Information and documentation — Codes for transcription systems  -->
	<!-- <xsl:variable name="title-en" select="concat(/iso:iso-standard/iso:bibdata/iso:title[@language = 'en' and @type = 'title-intro'], ' &#x2014; ' ,/iso:iso-standard/iso:bibdata/iso:title[@language = 'en' and @type = 'title-main'])"/> -->
	<xsl:variable name="title-en" select="/iso:iso-standard/iso:bibdata/iso:title[@language = 'en' and @type = 'main']"/>
	<!-- <xsl:variable name="title-fr" select="concat(/iso:iso-standard/iso:bibdata/iso:title[@language = 'fr' and @type = 'title-intro'],  ' &#x2014; ' ,/iso:iso-standard/iso:bibdata/iso:title[@language = 'fr' and @type = 'title-main'])"/> -->
	<xsl:variable name="title-fr" select="/iso:iso-standard/iso:bibdata/iso:title[@language = 'fr' and @type = 'main']"/>

	<!-- Example:
		<item level="1" id="Foreword" display="true">Foreword</item>
		<item id="term-script" display="false">3.2</item>
	-->
	<xsl:variable name="contents">
		<contents>
			<xsl:apply-templates select="/iso:iso-standard/iso:preface/node()" mode="contents"/>
			<xsl:apply-templates select="/iso:iso-standard/iso:sections/iso:clause[@id = '_scope']" mode="contents">
				<xsl:with-param name="sectionNum" select="'1'"/>
			</xsl:apply-templates>
			<xsl:apply-templates select="/iso:iso-standard/iso:bibliography/iso:references[@id = '_normative_references']" mode="contents">
				<xsl:with-param name="sectionNum" select="'2'"/>
			</xsl:apply-templates>
			<xsl:apply-templates select="/iso:iso-standard/iso:sections/node()[@id != '_scope']" mode="contents">
				<xsl:with-param name="sectionNumSkew" select="'1'"/>
			</xsl:apply-templates>
			<xsl:apply-templates select="/iso:iso-standard/iso:annex" mode="contents"/>
			<xsl:apply-templates select="/iso:iso-standard/iso:bibliography/iso:references[@id = '_bibliography']" mode="contents"/>
			
			<xsl:apply-templates select="//iso:figure" mode="contents"/>
			
			<xsl:apply-templates select="//iso:table" mode="contents"/>
			
		</contents>
	</xsl:variable>
	
	<xsl:template match="/">
		<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format" font-family="Cambria, FreeSerif, NanumGothic, DroidSans" font-size="11pt">
			<fo:layout-master-set>
				<!-- cover page -->
				<fo:simple-page-master master-name="cover-page" page-width="{$pageWidth}" page-height="{$pageHeight}">
					<fo:region-body margin-top="25.4mm" margin-bottom="25.4mm" margin-left="31.7mm" margin-right="31.7mm"/>
					<fo:region-before region-name="cover-page-header" extent="25.4mm" /> <!-- display-align="center" -->
					<fo:region-after/>
					<fo:region-start region-name="cover-left-region" extent="31.7mm"/>
					<fo:region-end region-name="cover-right-region" extent="31.7mm"/>
				</fo:simple-page-master>
				<!-- contents pages -->
				<!-- odd pages -->
				<fo:simple-page-master master-name="odd" page-width="{$pageWidth}" page-height="{$pageHeight}">
					<fo:region-body margin-top="27.4mm" margin-bottom="11mm" margin-left="19mm" margin-right="19mm"/>
					<fo:region-before region-name="header-odd" extent="27.4mm"/> <!--   display-align="center" -->
					<fo:region-after region-name="footer-odd" extent="11mm"/>
					<fo:region-start region-name="left-region" extent="19mm"/>
					<fo:region-end region-name="right-region" extent="19mm"/>
				</fo:simple-page-master>
				<!-- even pages -->
				<fo:simple-page-master master-name="even" page-width="{$pageWidth}" page-height="{$pageHeight}">
					<fo:region-body margin-top="27.4mm" margin-bottom="11mm" margin-left="19mm" margin-right="19mm"/>
					<fo:region-before region-name="header-even" extent="27.4mm"/> <!--   display-align="center" -->
					<fo:region-after region-name="footer-even" extent="11mm"/>
					<fo:region-start region-name="left-region" extent="19mm"/>
					<fo:region-end region-name="right-region" extent="19mm"/>
				</fo:simple-page-master>
				<fo:page-sequence-master master-name="document">
					<fo:repeatable-page-master-alternatives>
						<fo:conditional-page-master-reference odd-or-even="even" master-reference="even"/>
						<fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd"/>
					</fo:repeatable-page-master-alternatives>
				</fo:page-sequence-master>
			</fo:layout-master-set>

			<!-- cover page -->
      <fo:page-sequence master-reference="cover-page" force-page-count="no-force">
			<fo:static-content flow-name="cover-page-header" font-size="10pt">
				<fo:block-container height="24mm" display-align="before">
					<fo:block padding-top="12.5mm">
						<xsl:value-of select="$copyrightText"/>
					</fo:block>
				</fo:block-container>
			</fo:static-content>
        <fo:flow flow-name="xsl-region-body">
            <fo:block-container text-align="right">
						
						<xsl:choose>
							<xsl:when test="/iso:iso-standard/iso:bibdata/iso:docidentifier[@type = 'iso-tc']">
								<!-- 17301  -->
								<fo:block font-size="14pt" font-weight="bold" margin-bottom="12pt">
									<xsl:value-of select="/iso:iso-standard/iso:bibdata/iso:docidentifier[@type = 'iso-tc']"/>
								</fo:block>
								<!-- Date: 2016-05-01  -->
								<fo:block margin-bottom="12pt">
									<xsl:text>Date: </xsl:text><xsl:value-of select="/iso:iso-standard/iso:bibdata/iso:version/iso:revision-date"/>
								</fo:block>
							
							
								<!-- ISO/CD 17301-1(E)  -->
								<fo:block margin-bottom="12pt">
									<xsl:value-of select="concat(/iso:iso-standard/iso:bibdata/iso:docidentifier, '(', translate(substring(iso:iso-standard/iso:bibdata/iso:language,1,1),$lower, $upper), ') ')"/>
								</fo:block>
							</xsl:when>
							<xsl:otherwise>
								<fo:block font-size="14pt" font-weight="bold" margin-bottom="12pt">
									<!-- ISO/WD 24229(E)  -->
									<xsl:value-of select="concat(/iso:iso-standard/iso:bibdata/iso:docidentifier, '(', translate(substring(iso:iso-standard/iso:bibdata/iso:language,1,1),$lower, $upper), ') ')"/>
								</fo:block>
								
							</xsl:otherwise>
						</xsl:choose>
						
						<!-- ISO/TC 46/WG 3  -->
								<!-- <fo:block margin-bottom="12pt">
									<xsl:value-of select="concat('ISO/', /iso:iso-standard/iso:bibdata/iso:ext/iso:editorialgroup/iso:technical-committee/@type, ' ',
																																		/iso:iso-standard/iso:bibdata/iso:ext/iso:editorialgroup/iso:technical-committee/@number, '/', 
																																		/iso:iso-standard/iso:bibdata/iso:ext/iso:editorialgroup/iso:workgroup/@type, ' ',
																																		/iso:iso-standard/iso:bibdata/iso:ext/iso:editorialgroup/iso:workgroup/@number)"/>
						 -->
						<!-- ISO/TC 34/SC 4/WG 3 -->
						<fo:block margin-bottom="12pt">
							<xsl:text>ISO</xsl:text>
							<xsl:for-each select="/iso:iso-standard/iso:bibdata/iso:ext/iso:editorialgroup/iso:technical-committee[@number]">
								<xsl:text>/TC </xsl:text><xsl:value-of select="@number"/>
							</xsl:for-each>
							<xsl:for-each select="/iso:iso-standard/iso:bibdata/iso:ext/iso:editorialgroup/iso:subcommittee[@number]">
								<xsl:text>/SC </xsl:text>
								<xsl:value-of select="@number"/>
							</xsl:for-each>
							<xsl:for-each select="/iso:iso-standard/iso:bibdata/iso:ext/iso:editorialgroup/iso:workgroup[@number]">
								<xsl:text>/WG </xsl:text>
								<xsl:value-of select="@number"/>
							</xsl:for-each>
						</fo:block>
						
						<!-- Secretariat: AFNOR  -->
						
						<fo:block margin-bottom="100pt">
							<xsl:text>Secretariat: </xsl:text>
							<xsl:choose>
								<xsl:when test="/iso:iso-standard/iso:bibdata/iso:ext/iso:editorialgroup/iso:secretariat">
									<xsl:value-of select="/iso:iso-standard/iso:bibdata/iso:ext/iso:editorialgroup/iso:secretariat"/>
								</xsl:when>
								<xsl:otherwise>XXXX</xsl:otherwise>
							</xsl:choose>
						</fo:block>
							
						
						
            </fo:block-container>
					<fo:block-container font-size="16pt">
						<!-- Information and documentation — Codes for transcription systems  -->
							<fo:block font-weight="bold">
								<xsl:value-of select="/iso:iso-standard/iso:bibdata/iso:title[@language = 'en' and @type = 'title-intro']"/>
								<xsl:text> — </xsl:text>
								<xsl:value-of select="/iso:iso-standard/iso:bibdata/iso:title[@language = 'en' and @type = 'title-main']"/>
								<xsl:if test="/iso:iso-standard/iso:bibdata/iso:ext/iso:structuredidentifier/iso:project-number[@part]">
									<xsl:text> — </xsl:text>
									<fo:block margin-top="6pt">
										<xsl:text>Part </xsl:text><xsl:value-of select="/iso:iso-standard/iso:bibdata/iso:ext/iso:structuredidentifier/iso:project-number/@part"/>
										<xsl:text>:</xsl:text>
									</fo:block>
								</xsl:if>
								<xsl:value-of select="/iso:iso-standard/iso:bibdata/iso:title[@language = 'en' and @type = 'title-part']"/>
							</fo:block>
							
							<fo:block font-size="12pt"><xsl:value-of select="$linebreak"/></fo:block>
							<fo:block>
								<xsl:value-of select="/iso:iso-standard/iso:bibdata/iso:title[@language = 'fr' and @type = 'title-intro']"/>
								<xsl:text> — </xsl:text>
								<xsl:value-of select="/iso:iso-standard/iso:bibdata/iso:title[@language = 'fr' and @type = 'title-main']"/>
								<xsl:if test="/iso:iso-standard/iso:bibdata/iso:ext/iso:structuredidentifier/iso:project-number[@part]">
									<xsl:text> — </xsl:text>
									<fo:block margin-top="6pt" font-weight="normal">
										<xsl:text>Partie </xsl:text><xsl:value-of select="/iso:iso-standard/iso:bibdata/iso:ext/iso:structuredidentifier/iso:project-number/@part"/>
										<xsl:text>:</xsl:text>
									</fo:block>
								</xsl:if>
								<xsl:value-of select="/iso:iso-standard/iso:bibdata/iso:title[@language = 'fr' and @type = 'title-part']"/>
								
								
							</fo:block>
					</fo:block-container>
					<fo:block font-size="11pt" margin-bottom="8pt"><xsl:value-of select="$linebreak"/></fo:block>
					<fo:block-container font-size="40pt" text-align="center" margin-bottom="12pt" border="0.5pt solid black">
						<xsl:variable name="stage" select="substring-after(substring-before(/iso:iso-standard/iso:bibdata/iso:docidentifier[@type = 'iso'], ' '), '/')"/>
						<fo:block padding-top="2mm"><xsl:value-of select="$stage"/><xsl:text> stage</xsl:text></fo:block>
					</fo:block-container>
					<fo:block><xsl:value-of select="$linebreak"/></fo:block>
					
					<xsl:if test="/iso:iso-standard/iso:boilerplate/iso:license-statement">
						<fo:block-container font-size="10pt" margin-top="12pt" margin-bottom="6pt" border="0.5pt solid black">
							<fo:block padding-top="1mm">
								<xsl:apply-templates select="/iso:iso-standard/iso:boilerplate/iso:license-statement"/>
								
								
								
							</fo:block>
						</fo:block-container>
					</xsl:if>
        </fo:flow>
      </fo:page-sequence>
			
			<fo:page-sequence master-reference="document" format="i" force-page-count="no-force">
				<xsl:call-template name="insertHeaderFooter"/>
				<fo:flow flow-name="xsl-region-body">
					<xsl:if test="/iso:iso-standard/iso:boilerplate/iso:copyright-statement">
						<fo:block-container margin-top="12pt" margin-bottom="6pt" margin-left="1.5mm" margin-right="1.5mm" border="0.5pt solid black">
							<xsl:apply-templates select="/iso:iso-standard/iso:boilerplate/iso:copyright-statement"/>
							
						</fo:block-container>
						<fo:block break-after="page"/>
					</xsl:if>
					
					<fo:block-container font-weight="bold">
						<fo:block font-size="14pt" margin-bottom="15.5pt">Contents</fo:block>
							<xsl:copy-of select="xalan:nodeset($contents)"/>
							
							
							<xsl:for-each select="xalan:nodeset($contents)//item">
								<xsl:if test="@display = 'true'">
									<fo:block>
										<xsl:if test="@level = 1">
											<xsl:attribute name="margin-top">6pt</xsl:attribute>
										</xsl:if>
										<fo:list-block provisional-label-separation="3mm">
											<xsl:attribute name="provisional-distance-between-starts">
												<xsl:choose>
													<xsl:when test="@section != '' and not(@display-section = 'false')">7mm</xsl:when> <!--   -->
													<xsl:otherwise>0mm</xsl:otherwise>
												</xsl:choose>
											</xsl:attribute>
											<fo:list-item>
												<fo:list-item-label end-indent="label-end()">
													<fo:block>
														<xsl:if test="@section and not(@display-section = 'false')"> <!--   -->
															<xsl:value-of select="@section"/>
														</xsl:if>
													</fo:block>
												</fo:list-item-label>
													<fo:list-item-body start-indent="body-start()">
														<fo:block text-align-last="justify" margin-left="12mm" text-indent="-12mm">
															<fo:basic-link internal-destination="{@id}">
																<xsl:value-of select="text()"/>
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
								</xsl:if>
							</xsl:for-each>
					</fo:block-container>
					<!-- Foreword, Introduction -->
					<xsl:apply-templates select="/iso:iso-standard/iso:preface/node()"/>
						
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
					<fo:block-container>
						<!-- Information and documentation — Codes for transcription systems -->
						<fo:block font-size="16pt" font-weight="bold" margin-bottom="18pt">
							<xsl:value-of select="$title-en"/>
						</fo:block>
					</fo:block-container>
					<!-- Clause(s) -->
					<fo:block>
						<xsl:apply-templates select="/iso:iso-standard/iso:sections/iso:clause[@id = '_scope']">
							<xsl:with-param name="sectionNum" select="'1'"/>
						</xsl:apply-templates>
						<xsl:apply-templates select="/iso:iso-standard/iso:bibliography/iso:references[@id = '_normative_references']">
							<xsl:with-param name="sectionNum" select="'2'"/>
						</xsl:apply-templates>
						
						<xsl:apply-templates select="/iso:iso-standard/iso:sections/node()[@id != '_scope']">
							<xsl:with-param name="sectionNumSkew" select="'1'"/>
						</xsl:apply-templates>
						
						<!-- Annex(s) -->
						<xsl:apply-templates select="/iso:iso-standard/iso:annex"/>
						
						<!-- Bibliography -->
						<xsl:apply-templates select="/iso:iso-standard/iso:bibliography/iso:references[@id = '_bibliography']"/>
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
	
	<xsl:template match="node()" mode="contents">
		<xsl:param name="sectionNum"/>
		<xsl:param name="sectionNumSkew"/>
		<xsl:apply-templates mode="contents">
			<xsl:with-param name="sectionNum" select="$sectionNum"/>
			<xsl:with-param name="sectionNumSkew" select="$sectionNumSkew"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="iso:license-statement//iso:title">
		<fo:block text-align="center" font-weight="bold">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="iso:license-statement//iso:p">
		<fo:block margin-left="1.5mm" margin-right="1.5mm">
			<xsl:if test="following-sibling::iso:p">
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
	
	<xsl:template match="iso:copyright-statement//iso:p">
		<fo:block>
			<xsl:if test="preceding-sibling::iso:p">
				<xsl:attribute name="font-size">10pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="following-sibling::iso:p">
				<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="not(following-sibling::iso:p)">
				<xsl:attribute name="margin-left">7.1mm</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<!-- Foreword, Introduction -->
	<xsl:template match="iso:iso-standard/iso:preface/*">
		<fo:block break-after="page"/>
		<!-- <fo:block> -->
			<xsl:apply-templates />
		<!-- </fo:block> -->
	</xsl:template>
	
	<xsl:template match="iso:iso-standard/iso:preface/*" mode="contents">
		<xsl:apply-templates mode="contents"/>
	</xsl:template>
	
	<!-- clause, terms, clause, ...-->
	<xsl:template match="iso:iso-standard/iso:sections/*">
		<xsl:param name="sectionNum"/>
		<xsl:param name="sectionNumSkew" select="0"/>
		<fo:block>
			<xsl:variable name="sectionNum_">
				<xsl:choose>
					<xsl:when test="$sectionNum"><xsl:value-of select="$sectionNum"/></xsl:when>
					<xsl:when test="$sectionNumSkew != 0">
						<xsl:variable name="number"><xsl:number count="iso:sections/iso:clause | iso:sections/iso:terms"/></xsl:variable>
						<xsl:value-of select="$number + $sectionNumSkew"/>
					</xsl:when>
				</xsl:choose>
			</xsl:variable>
			<xsl:if test="not(iso:title)">
				<fo:block margin-top="3pt" margin-bottom="12pt">
					<xsl:value-of select="$sectionNum_"/><xsl:number format=".1 " level="multiple" count="iso:clause" />
				</fo:block>
			</xsl:if>
			<xsl:apply-templates>
				<xsl:with-param name="sectionNum" select="$sectionNum_"/>
			</xsl:apply-templates>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="iso:clause//iso:clause">
		<xsl:param name="sectionNum"/>
		<xsl:if test="not(iso:title)">
			<fo:block font-weight="bold" margin-top="3pt" margin-bottom="12pt">
				<xsl:value-of select="$sectionNum"/><xsl:number format=".1 "  level="multiple" count="iso:clause/iso:clause" /> <!--  -->
			</fo:block>
		</xsl:if>
		<xsl:apply-templates>
			<xsl:with-param name="sectionNum" select="$sectionNum"/>
		</xsl:apply-templates>
	</xsl:template>
	
	
	<xsl:template match="iso:title">
		<xsl:param name="sectionNum"/>
		<xsl:variable name="parentName"  select="local-name(..)"/>
		<xsl:variable name="level">
			<xsl:choose>
				<xsl:when test="local-name (..) = 'clause'">
					<xsl:value-of select="count(ancestor::iso:clause)"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="font-size">
			<xsl:choose>
				<xsl:when test="$level = 2">12pt</xsl:when>
				<xsl:when test="$level &gt;= 3">11pt</xsl:when>
				<xsl:otherwise>13pt</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
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
		
		<xsl:variable name="element-name">
			<xsl:choose>
				<xsl:when test="../@inline-header = 'true'">fo:inline</xsl:when>
				<xsl:otherwise>fo:block</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:element name="{$element-name}">
			<xsl:attribute name="font-size"><xsl:value-of select="$font-size"/></xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>		
			<xsl:attribute name="space-before"> <!-- margin-top -->
				<xsl:choose>
					<xsl:when test="$level = '' or $level = 1">13.5pt</xsl:when>
					<xsl:otherwise>12pt</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<fo:inline id="{$id}">
				<!-- DEBUG level=<xsl:value-of select="$level"/>x -->
				<xsl:if test="$sectionNum">
					<xsl:value-of select="$sectionNum"/>
					<xsl:choose>
						<xsl:when test="$level = 2 and ancestor::iso:annex">
							<xsl:number format=".1" level="multiple" count="iso:clause" />
						</xsl:when>
						<xsl:when test="$level = 2">
							<xsl:number format=".1" count="iso:clause" />
						</xsl:when>
						<xsl:when test="$level = 3">
							<xsl:number format=".1 " level="multiple" count="iso:clause/iso:clause" />
						</xsl:when>
						<xsl:when test="$level = 4">
							<xsl:number format=".1 " level="multiple" count="iso:clause/iso:clause | iso:clause/iso:clause/iso:clause" />
						</xsl:when>
					</xsl:choose>
					<xsl:choose>
						<xsl:when test="$level = 2">
							<fo:inline padding-right="2mm">&#xA0;</fo:inline>
						</xsl:when>
						<xsl:otherwise>
							<fo:inline padding-right="3mm">&#xA0;</fo:inline>
						</xsl:otherwise>
					</xsl:choose>
					<!-- <xsl:text>&#xA0;&#xA0;</xsl:text> -->
				</xsl:if>
				<xsl:apply-templates />
			</fo:inline>
		</xsl:element>
		<xsl:if test="$element-name = 'fo:inline' and not(following-sibling::iso:p)">
			<fo:block margin-bottom="12pt">
				<xsl:value-of select="$linebreak"/>
			</fo:block>
		</xsl:if>
		
	</xsl:template>
	
	<xsl:template match="iso:preface//iso:title | iso:bibliography/iso:references[@id = '_normative_references' or @id='_bibliography']/iso:title" mode="contents">
		<xsl:param name="sectionNum"/>
		<item level="1" type="preface" display="true"> <!-- display-section="false" -->
			<xsl:attribute name="id">
				<xsl:choose>
					<xsl:when test="../@id">
						<xsl:value-of select="../@id"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="."/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="section">
				<xsl:choose>
					<xsl:when test="$sectionNum != ''">
						<xsl:value-of select="$sectionNum"/>
					</xsl:when>
					<xsl:otherwise>
						<!-- <xsl:value-of select="."/> -->
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:value-of select="."/>
		</item>
	</xsl:template>
	

	
	<xsl:template match="iso:sections//iso:title" mode="contents">
		<xsl:param name="sectionNum"/>
		<xsl:variable name="level">
			<xsl:choose>
				<xsl:when test="local-name (..) = 'clause'">
					<xsl:value-of select="count(ancestor::iso:clause)"/>
				</xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
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
		<item level="{$level}" id="{$id}" type="{local-name(..)}">
			<xsl:if test="$sectionNum">
				<xsl:attribute name="section">
					<xsl:value-of select="$sectionNum"/>
					<xsl:choose>
						<!-- <xsl:when test="$level = 2 and ancestor::iso:annex">
							<xsl:number format=".1" level="multiple" count="iso:clause" />
						</xsl:when> -->
						<xsl:when test="$level = 2">
							<xsl:number format=".1" count="iso:clause" />
						</xsl:when>
						<xsl:when test="$level = 3">
							<xsl:number format=".1" level="multiple" count="iso:clause/iso:clause" />
						</xsl:when>
						<xsl:when test="$level = 4">
							<xsl:number format=".1" level="multiple" count="iso:clause/iso:clause | iso:clause/iso:clause/iso:clause" />
						</xsl:when>
					</xsl:choose>
				</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="display">
				<xsl:choose>
					<xsl:when test="ancestor::iso:annex and $level &gt;= 2">false</xsl:when>
					<!-- <xsl:when test="ancestor::*[iso:annex]">false</xsl:when> --> <!-- $level &lt;= 2 and  -->
					<xsl:when test="$level &lt;= 2">true</xsl:when>
					<xsl:otherwise>false</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<!-- <ancestor>isannex=<xsl:value-of select="local-name(ancestor::iso:annex)"/><xsl:value-of select="$level"/></ancestor> -->
			<xsl:value-of select="text()"/>
		</item>
	</xsl:template>
	
	<xsl:template match="iso:p">
		<xsl:variable name="previous-element" select="local-name(preceding-sibling::*[1])"/>
		<xsl:variable name="element-name">
			<xsl:choose>
				<xsl:when test="../@inline-header = 'true' and $previous-element = 'title'">fo:inline</xsl:when> <!-- first paragraph after inline title -->
				<xsl:otherwise>fo:block</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:element name="{$element-name}">
			<xsl:attribute name="text-align">justify</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:apply-templates />
		</xsl:element>
		<xsl:if test="$element-name = 'fo:inline'">
			<fo:block margin-bottom="12pt">
				<xsl:value-of select="$linebreak"/>
			</fo:block>
		</xsl:if>
	</xsl:template>
	
	<!--
	<fn reference="1">
			<p id="_8e5cf917-f75a-4a49-b0aa-1714cb6cf954">Formerly denoted as 15 % (m/m).</p>
		</fn>
	-->
	<xsl:template match="iso:p/iso:fn">
		<fo:footnote>
			<xsl:variable name="number">
				<xsl:number level="any" count="iso:p/iso:fn"/>
			</xsl:variable>
			<fo:inline font-size="60%" keep-with-previous.within-line="always" vertical-align="super">
				<fo:basic-link internal-destination="footnote_{@reference}">
					<!-- <xsl:value-of select="@reference"/> -->
					<xsl:value-of select="$number + count(//iso:bibitem/iso:note)"/>
				</fo:basic-link>
			</fo:inline>
			<fo:footnote-body>
				<fo:block font-size="10pt" margin-bottom="12pt">
					<fo:inline id="footnote_{@reference}" font-size="60%" keep-with-next.within-line="always" alignment-baseline="hanging">
						<xsl:value-of select="$number + count(//iso:bibitem/iso:note)"/>
					</fo:inline>
					<xsl:for-each select="iso:p">
							<xsl:apply-templates />
					</xsl:for-each>
				</fo:block>
			</fo:footnote-body>
		</fo:footnote>
	</xsl:template>

	<xsl:template match="iso:p/iso:fn/iso:p">
		<xsl:apply-templates />
	</xsl:template>
	
	<xsl:template match="iso:review">
		<fo:block font-weight="bold">Review:</fo:block>
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="text()">
		<xsl:value-of select="."/>
	</xsl:template>
	
	<xsl:template match="iso:iso-standard/iso:sections/*" mode="contents">
		<xsl:param name="sectionNum"/>
		<xsl:param name="sectionNumSkew" select="0"/>
		<xsl:variable name="sectionNum_">
			<xsl:choose>
				<xsl:when test="$sectionNum"><xsl:value-of select="$sectionNum"/></xsl:when>
				<xsl:when test="$sectionNumSkew != 0">
					<xsl:variable name="number"><xsl:number count="iso:sections/iso:clause | iso:sections/iso:terms"/></xsl:variable>
					<xsl:value-of select="$number + $sectionNumSkew"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:apply-templates mode="contents">
			<xsl:with-param name="sectionNum" select="$sectionNum_"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="iso:image">
		<fo:block-container text-align="center">
			<fo:block>
				<fo:external-graphic src="{@src}"/>
			</fo:block>
			<fo:block font-weight="bold" margin-top="6pt" margin-bottom="6pt">Figure <xsl:number format="1" level="any"/></fo:block>
		</fo:block-container>
		
	</xsl:template>

	<xsl:template match="iso:figure">
		<!-- <xsl:choose>
			<xsl:when test="iso:figure">
				<xsl:apply-templates />
			</xsl:when>
			<xsl:otherwise> -->
				<fo:block-container id="{@id}">
					<fo:block>
						<xsl:apply-templates />
					</fo:block>
					<xsl:call-template name="fn_display_figure"/>
					<xsl:for-each select="iso:note//iso:p">
						<xsl:call-template name="note"/>
					</xsl:for-each>
					<fo:block font-weight="bold" text-align="center" margin-top="6pt" margin-bottom="6pt" keep-with-previous="always">
						<xsl:text>Figure </xsl:text>
						<xsl:choose>
							<xsl:when test="ancestor::iso:annex">
								<xsl:number format="A.1-1" level="multiple" count="iso:annex | iso:figure"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:number format="1" level="any"/>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:if test="iso:name">
							<xsl:text> — </xsl:text>
							<xsl:value-of select="iso:name"/>
						</xsl:if>
					</fo:block>
				</fo:block-container>
		<!-- </xsl:otherwise>
		</xsl:choose> -->
	</xsl:template>
	
	<xsl:template match="iso:figure/iso:name"/>
	<xsl:template match="iso:figure/iso:fn"/>
	<xsl:template match="iso:figure/iso:note"/>
	
	
	<xsl:template match="iso:figure/iso:image">
		<fo:block text-align="center">
			<fo:external-graphic src="{@src}" content-width="75%" content-height="scale-to-fit" scaling="uniform"/>
		</fo:block>
	</xsl:template>
	
	
	<xsl:template match="iso:figure" mode="contents">
		<item level="" id="{@id}" display="false">
			<xsl:attribute name="section">
				<xsl:text>Figure </xsl:text><xsl:number format="A.1-1" level="multiple" count="iso:annex | iso:figure"/>
			</xsl:attribute>
		</item>
	</xsl:template>
	
	<xsl:template match="iso:table" mode="contents">
		<item level="" id="{@id}" display="false">
			<xsl:attribute name="section">
				<xsl:text>Table </xsl:text><xsl:number format="1"/>
			</xsl:attribute>
		</item>
	</xsl:template>
	
	
	<xsl:template match="iso:formula" mode="contents">
		<item level="" id="{@id}" display="false">
			<xsl:attribute name="section">
				<xsl:text>Formula (</xsl:text><xsl:number format="A.1" level="multiple" count="iso:annex | iso:formula"/><xsl:text>)</xsl:text>
			</xsl:attribute>
		</item>
	</xsl:template>
	
	
	<xsl:template match="iso:bibitem">
		<fo:block id="{@id}" margin-bottom="12pt">
				<!-- iso:docidentifier -->
			<xsl:if test="iso:docidentifier">
				<xsl:choose>
					<xsl:when test="iso:docidentifier/@type = 'metanorma'"/>
					<xsl:otherwise><fo:inline><xsl:value-of select="iso:docidentifier"/></fo:inline></xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:if test="iso:docidentifier">, </xsl:if>
			<xsl:apply-templates select="iso:note"/>
			<fo:inline font-style="italic">
				<xsl:choose>
					<xsl:when test="iso:title[@type = 'main' and @language = 'en']">
						<xsl:value-of select="iso:title[@type = 'main' and @language = 'en']"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="iso:title"/>
					</xsl:otherwise>
				</xsl:choose>
			</fo:inline>
		</fo:block>
	</xsl:template>
	
	<!-- <xsl:template match="iso:bibitem" mode="contents">
		<xsl:if test="iso:note">
			<xsl:variable name=""
			<item id="_4" level="3" type="annex" display="false" section="B.5.2"/>
		</xsl:if>
	</xsl:template> -->
	
	<xsl:template match="iso:bibitem/iso:note">
		<fo:footnote>
			<xsl:variable name="number">
				<xsl:number level="any" count="iso:bibitem/iso:note"/>
			</xsl:variable>
			<fo:inline font-size="60%" keep-with-previous.within-line="always" vertical-align="super">
				<fo:basic-link internal-destination="footnote_{../@id}">
					<xsl:value-of select="$number"/>
				</fo:basic-link>
			</fo:inline>
			<fo:footnote-body>
				<fo:block font-size="10pt" margin-bottom="12pt">
					<fo:inline id="footnote_{../@id}" font-size="60%" keep-with-next.within-line="always" alignment-baseline="hanging">
						<xsl:value-of select="$number"/>
					</fo:inline>
					<xsl:apply-templates />
				</fo:block>
			</fo:footnote-body>
		</fo:footnote>
	</xsl:template>
	
	
	
	<xsl:template match="iso:ul | iso:ol">
		<fo:list-block provisional-distance-between-starts="7mm">
			<xsl:apply-templates />
		</fo:list-block>
	</xsl:template>
	
	<xsl:template match="iso:li">
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
									<xsl:number format="a)"/>
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
	
	<xsl:template match="iso:link">
		<fo:inline>
			<fo:basic-link external-destination="{@target}">
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
	
	<xsl:template match="iso:preferred">
		<xsl:param name="sectionNum"/>
		<fo:block font-weight="bold" keep-with-next="always">
			<fo:inline id="{../@id}">
				<xsl:value-of select="$sectionNum"/>.<xsl:number count="iso:term"/>
			</fo:inline>
		</fo:block>
		<fo:block font-weight="bold" keep-with-next="always">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	<xsl:template match="iso:preferred" mode="contents">
		<xsl:param name="sectionNum"/>
		<item id="{../@id}" display="false">
			<xsl:variable name="value">
				<xsl:value-of select="$sectionNum"/>.<xsl:number count="iso:term"/>
			</xsl:variable>
			<xsl:attribute name="section">
				<xsl:value-of select="$value"/>
			</xsl:attribute>
		</item>
	</xsl:template>
	
	<xsl:template match="iso:admitted">
		<fo:block>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="iso:deprecates">
		<fo:block>DEPRECATED: <xsl:apply-templates /></fo:block>
	</xsl:template>
	
	<xsl:template match="iso:definition">
		<fo:block margin-bottom="12pt">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="iso:termsource">
		<fo:block margin-bottom="12pt" keep-with-previous="always">
			<!-- Example: [SOURCE: ISO 5127:2017, 3.1.6.02] -->
			<fo:basic-link internal-destination="{iso:origin/@bibitemid}">
				<xsl:text>[SOURCE: </xsl:text>
				<xsl:value-of select="iso:origin/@citeas"/>
				<xsl:if test="iso:origin/iso:locality/iso:referenceFrom">
					<xsl:text>, </xsl:text><xsl:value-of select="iso:origin/iso:locality/iso:referenceFrom"/>
				</xsl:if>
			</fo:basic-link>
			<xsl:apply-templates select="iso:modification"/>
			<xsl:text>]</xsl:text>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="iso:modification/iso:p">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template>
	
	<xsl:template match="iso:termnote">
		<fo:block font-size="10pt" margin-bottom="12pt">
			<xsl:text>Note </xsl:text>
			<xsl:number />
			<xsl:text> to entry: </xsl:text>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="iso:termnote/iso:p">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template>
	
	<xsl:template match="iso:domain">
		<xsl:text>&lt;</xsl:text><xsl:apply-templates/><xsl:text>&gt;</xsl:text>
	</xsl:template>
	
	
	<xsl:template match="iso:termexample">
		<fo:block font-size="10pt" margin-bottom="12pt">
			<fo:inline padding-right="10mm">EXAMPLE</fo:inline>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="iso:termexample/iso:p">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template>

	
	<xsl:template match="iso:annex">
		<fo:block break-after="page"/>
		<fo:block font-size="13pt" text-align="center" space-before="13.5pt">
			<fo:block font-weight="bold">
				<fo:inline id="{@id}"><xsl:value-of select="'Annex '"/><xsl:number format="A" level="any"/></fo:inline>
			</fo:block>
			<fo:block>(<xsl:value-of select="@obligation"/>)</fo:block>
			<fo:block><xsl:value-of select="$linebreak"/></fo:block>
		</fo:block>
		<xsl:variable name="sectionNum">
			<xsl:number format="A" level="any"/>
		</xsl:variable>
		<xsl:apply-templates>
			<xsl:with-param name="sectionNum" select="$sectionNum"/>
		</xsl:apply-templates>
	</xsl:template>
	
	
	<!-- <item id="AnnexA" level="1" display="true" display-section="false" section="Annex A">Annex A (normative) Determination of defects</item> -->
	<xsl:template match="iso:annex" mode="contents">
		<xsl:variable name="sectionNum">
			<xsl:number format="A" level="any"/>
		</xsl:variable>
		<item id="{@id}" level="1" display="true" type="annex" display-section="false">
			<xsl:variable name="value">
				<xsl:value-of select="'Annex '"/><xsl:value-of select="$sectionNum"/>
			</xsl:variable>
			<xsl:attribute name="section">
				<xsl:value-of select="$value"/>
			</xsl:attribute>
			<xsl:value-of select="$value"/><xsl:text> (</xsl:text><xsl:value-of select="@obligation"/><xsl:text>) </xsl:text>
			<xsl:value-of select="iso:title"/>
		</item>
		<xsl:apply-templates mode="contents">
			<xsl:with-param name="sectionNum" select="$sectionNum"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="iso:annex//iso:clause" mode="contents">
		<xsl:param name="sectionNum"/>
		<xsl:variable name="level" select="count(ancestor::*)"/>
		<item id="{@id}" level="{$level}" type="annex">
			<xsl:attribute name="display">
				<xsl:choose>
					<xsl:when test="$level &lt;= 2">true</xsl:when>
					<xsl:otherwise>false</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:variable name="value">
				<xsl:number format="A.1" level="multiple" count="iso:annex | iso:clause"/>
			</xsl:variable>
			<xsl:attribute name="section">
				<xsl:value-of select="$value"/>
			</xsl:attribute>
			<xsl:value-of select="iso:title"/>
		</item>
		<xsl:apply-templates mode="contents">
			<xsl:with-param name="sectionNum" select="$sectionNum"/>
		</xsl:apply-templates>
	</xsl:template>
	
	
	<xsl:template match="iso:annex/iso:title">
		<fo:block font-size="13pt" text-align="center" font-weight="bold" margin-bottom="12pt" keep-with-next="always">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="iso:annex//iso:clause">
		<xsl:param name="sectionNum"/>
		<xsl:if test="not(iso:title)">
			<fo:block font-weight="bold" margin-top="3pt" margin-bottom="12pt">
				<xsl:number format="A.1 "  level="multiple" count="iso:annex | iso:clause" /> <!--  -->
			</fo:block>
		</xsl:if>
		<xsl:apply-templates>
			<xsl:with-param name="sectionNum" select="$sectionNum"/>
		</xsl:apply-templates>
	</xsl:template>
	
		
	
	
	<xsl:template match="iso:annex/iso:clause/iso:title">
		<fo:block font-size="12pt" font-weight="bold" margin-bottom="12pt" keep-with-next="always">
			<fo:inline id="{../@id}">
				<xsl:number format="A.1 " level="multiple" count="iso:annex | iso:clause"/>
				<xsl:value-of select="'&#xA0;&#xA0;'"/>
			</fo:inline>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	


	
	<xsl:template match="iso:references[@id = '_bibliography']">
		<fo:block break-after="page"/>
			<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="iso:references[@id = '_bibliography']" mode="contents">
		<xsl:apply-templates mode="contents"/>
	</xsl:template>
	
	<!-- Example: [1] ISO 9:1995, Information and documentation – Transliteration of Cyrillic characters into Latin characters – Slavic and non-Slavic languages -->
	<xsl:template match="iso:references[@id = '_bibliography']/iso:bibitem">
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
						<xsl:if test="iso:docidentifier">
							<xsl:choose>
								<xsl:when test="iso:docidentifier/@type = 'metanorma'"/>
								<xsl:otherwise><fo:inline><xsl:value-of select="iso:docidentifier"/>, </fo:inline></xsl:otherwise>
							</xsl:choose>
						</xsl:if>
						<xsl:choose>
							<xsl:when test="iso:title[@type = 'main' and @language = 'en']">
								<xsl:apply-templates select="iso:title[@type = 'main' and @language = 'en']"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates select="iso:title"/>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:apply-templates select="iso:formattedref"/>
					</fo:block>
				</fo:list-item-body>
			</fo:list-item>
		</fo:list-block>
	</xsl:template>
	
	<xsl:template match="iso:references[@id = '_bibliography']/iso:bibitem" mode="contents"/>
	
	<xsl:template match="iso:references[@id = '_bibliography']/iso:bibitem/iso:title">
		<fo:inline font-style="italic">
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>

	<xsl:template match="iso:quote">
		<fo:block margin-top="12pt" margin-left="12mm" margin-right="12mm">
			<xsl:apply-templates select=".//iso:p"/>
		</fo:block>
		<fo:block text-align="right">
			<!-- — ISO, ISO 7301:2011, Clause 1 -->
			<xsl:text>— </xsl:text><xsl:value-of select="iso:author"/>
			<xsl:if test="iso:source">
				<xsl:text>, </xsl:text>
				<xsl:apply-templates select="iso:source"/>
			</xsl:if>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="iso:source">
		<fo:basic-link internal-destination="{@bibitemid}">
			<xsl:value-of select="@citeas" disable-output-escaping="yes"/>
			<xsl:if test="iso:locality">
				<xsl:text>, </xsl:text>
				<xsl:apply-templates select="iso:locality"/>
			</xsl:if>
		</fo:basic-link>
	</xsl:template>
	
	<xsl:template match="iso:appendix">
		<fo:block font-size="12pt" font-weight="bold" margin-top="12pt" margin-bottom="12pt">
			<fo:inline padding-right="5mm">Appendix <xsl:number /></fo:inline>
			<xsl:apply-templates select="iso:title" mode="process"/>
		</fo:block>
		<xsl:apply-templates />
	</xsl:template>
	
	<xsl:template match="iso:appendix//iso:example">
		<fo:block font-size="10pt" font-family="Courier" margin-bottom="12pt">
			<xsl:text>EXAMPLE</xsl:text>
			<xsl:if test="iso:name">
				<xsl:text> — </xsl:text><xsl:apply-templates select="iso:name" mode="process"/>
			</xsl:if>
		</fo:block>
		<xsl:apply-templates />
	</xsl:template>
	
	<xsl:template match="iso:appendix//iso:example/iso:name"/>
	<xsl:template match="iso:appendix//iso:example/iso:name" mode="process">
		<fo:inline><xsl:apply-templates /></fo:inline>
	</xsl:template>
	
	<!-- <xsl:template match="iso:callout/text()">	
		<fo:basic-link internal-destination="{@target}"><fo:inline>&lt;<xsl:apply-templates />&gt;</fo:inline></fo:basic-link>
	</xsl:template> -->
	<xsl:template match="iso:callout">		
			<fo:basic-link internal-destination="{@target}">&lt;<xsl:apply-templates />&gt;</fo:basic-link>
	</xsl:template>
	
	<xsl:template match="iso:annotation">
		<fo:block>
			
		</fo:block>
		<xsl:apply-templates />
	</xsl:template>
	
	<xsl:template match="iso:annotation/text()"/>
	
	<xsl:template match="iso:annotation/iso:p">
		<xsl:variable name="annotation-id" select="../@id"/>
		<xsl:variable name="callout" select="//*[@target = $annotation-id]/text()"/>
		<fo:block id="{$annotation-id}">
			<xsl:value-of select="concat('&lt;', $callout, '&gt; ')"/>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	
	<xsl:template match="iso:appendix/iso:title"/>
	<xsl:template match="iso:appendix/iso:title" mode="process">
		<fo:inline><xsl:apply-templates /></fo:inline>
	</xsl:template>
	
	<xsl:template match="mathml:math">
		<!-- <fo:inline font-size="12pt" color="red">
			MathML issue! <xsl:apply-templates />
		</fo:inline> -->
		<fo:instream-foreign-object>
			<xsl:copy-of select="."/>
		</fo:instream-foreign-object>
	</xsl:template>
	
	<xsl:template match="iso:xref">
		<fo:basic-link internal-destination="{@target}">
			<xsl:variable name="type" select="xalan:nodeset($contents)//item[@id = current()/@target]/@type"/>
			<xsl:choose>
				<xsl:when test="$type = 'clause'">Clause </xsl:when><!-- and not (ancestor::annex) -->
				<xsl:otherwise></xsl:otherwise> <!-- <xsl:value-of select="$type"/> -->
			</xsl:choose>
			<xsl:text></xsl:text>
			<xsl:value-of select="xalan:nodeset($contents)//item[@id = current()/@target]/@section"/>
      </fo:basic-link>
	</xsl:template>

	<xsl:template match="iso:sourcecode">
		<fo:block font-family="Courier" font-size="9pt" margin-bottom="12pt" white-space="pre">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="iso:example/iso:p">
		<fo:block font-size="10pt">
			<fo:inline padding-right="9mm">EXAMPLE</fo:inline>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="iso:tt">
		<fo:inline font-family="Courier" font-size="10pt">
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="iso:note/iso:p" name="note">
		<fo:block font-size="10pt" margin-bottom="12pt">
			<fo:inline padding-right="4mm">NOTE</fo:inline>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>

	<!-- <eref type="inline" bibitemid="ISO20483" citeas="ISO 20483:2013"><locality type="annex"><referenceFrom>C</referenceFrom></locality></eref> -->
	<xsl:template match="iso:eref">
		<fo:inline>
			<xsl:if test="@type = 'footnote'">
				<xsl:attribute name="keep-together.within-line">always</xsl:attribute>
				<xsl:attribute name="font-size">80%</xsl:attribute>
				<xsl:attribute name="keep-with-previous.within-line">always</xsl:attribute>
				<xsl:attribute name="vertical-align">super</xsl:attribute>
			</xsl:if>
			<fo:basic-link internal-destination="{@bibitemid}">
				<xsl:value-of select="@citeas" disable-output-escaping="yes"/>
				<xsl:if test="iso:locality">
					<xsl:text>, </xsl:text>
					<xsl:apply-templates select="iso:locality"/>
				</xsl:if>
			</fo:basic-link>
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="iso:locality">
		<xsl:choose>
			<xsl:when test="@type ='clause'">Clause</xsl:when>
			<xsl:when test="@type ='annex'">Annex</xsl:when>
			<xsl:otherwise><xsl:value-of select="@type"/></xsl:otherwise>
		</xsl:choose>
		<xsl:text> </xsl:text><xsl:value-of select="iso:referenceFrom"/>
	</xsl:template>
	
	<xsl:template match="iso:admonition">
		<fo:block text-align="center" margin-bottom="6pt" font-weight="bold">
			<xsl:value-of select="translate(@type, $lower, $upper)"/>
		</fo:block>
		<fo:block font-weight="bold">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="iso:formula/iso:stem">
		<fo:block id="{../@id}" margin-top="6pt">
			<fo:table table-layout="fixed" width="100%">
				<fo:table-column column-width="95%"/>
				<fo:table-column column-width="5%"/>
				<fo:table-body>
					<fo:table-row>
						<fo:table-cell>
							<fo:block text-align="center">
								<xsl:apply-templates />
							</fo:block>
						</fo:table-cell>
						<fo:table-cell>
							<fo:block text-align="right">
								<xsl:if test="not(ancestor::iso:annex)">
									<xsl:text>(</xsl:text><xsl:number level="any" count="iso:formula"/><xsl:text>)</xsl:text>
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
	
	
	
	
	<xsl:template name="insertHeaderFooter">
		<fo:static-content flow-name="header-even">
			<fo:block-container height="24mm" display-align="before">
				<fo:block font-weight="bold" padding-top="12.5mm"><xsl:value-of select="$ISOname"/></fo:block>
			</fo:block-container>
		</fo:static-content>
		<fo:static-content flow-name="footer-even" font-size="10pt">
			<fo:block-container height="11mm"> <!--  display-align="after" -->
				<fo:table table-layout="fixed" width="100%">
					<fo:table-column column-width="50%"/>
					<fo:table-column column-width="50%"/>
					<fo:table-body>
						<fo:table-row>
							<fo:table-cell padding-top="0mm">
								<fo:block><fo:page-number/></fo:block>
							</fo:table-cell>
							<fo:table-cell padding-top="0mm">
								<fo:block text-align="right"><xsl:value-of select="$copyrightText"/></fo:block>
							</fo:table-cell>
						</fo:table-row>
					</fo:table-body>
				</fo:table>
			</fo:block-container>
		</fo:static-content>
		<fo:static-content flow-name="header-odd">
			<fo:block-container height="24mm" display-align="before">
				<fo:block font-weight="bold" text-align="right" padding-top="12.5mm"><xsl:value-of select="$ISOname"/></fo:block>
			</fo:block-container>
		</fo:static-content>
		<fo:static-content flow-name="footer-odd" font-size="10pt">
			<fo:block-container height="11mm"> <!--  display-align="after" -->
				<fo:table table-layout="fixed" width="100%">
					<fo:table-column column-width="50%"/>
					<fo:table-column column-width="50%"/>
					<fo:table-body>
						<fo:table-row>
							<fo:table-cell padding-top="0mm">
								<fo:block><xsl:value-of select="$copyrightText"/></fo:block>
							</fo:table-cell>
							<fo:table-cell padding-top="0mm">
								<fo:block text-align="right"><fo:page-number/></fo:block>
							</fo:table-cell>
						</fo:table-row>
					</fo:table-body>
				</fo:table>
			</fo:block-container>
		</fo:static-content>
	</xsl:template>



</xsl:stylesheet>
