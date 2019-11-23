<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:iso="http://riboseinc.com/isoxml" xmlns:mathml="http://www.w3.org/1998/Math/MathML" xmlns:xalan="http://xml.apache.org/xalan" version="1.0">

	<xsl:output method="xml" encoding="UTF-8" indent="yes"/>
	
	<xsl:variable name="lower">abcdefghijklmnopqrstuvwxyz</xsl:variable> 
	<xsl:variable name="upper">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>

	<xsl:variable name="pageWidth" select="'210mm'"/>
	<xsl:variable name="pageHeight" select="'297mm'"/>

	<xsl:variable name="copyrightText" select="concat('© ISO ', iso:iso-standard/iso:bibdata/iso:copyright/iso:from ,' – All rights reserved')"/>
	<xsl:variable name="ISOname" select="concat(/iso:iso-standard/iso:bibdata/iso:docidentifier, ':', /iso:iso-standard/iso:bibdata/iso:copyright/iso:from , '(', translate(substring(iso:iso-standard/iso:bibdata/iso:language,1,1),$lower, $upper), ') ')"/>
	
	<xsl:variable name="linebreak" select="'&#x2028;'"/>

	<!-- Information and documentation — Codes for transcription systems  -->
	<xsl:variable name="title-en" select="concat(/iso:iso-standard/iso:bibdata/iso:title[@language = 'en' and @type = 'title-intro'], ' &#x2014; ' ,/iso:iso-standard/iso:bibdata/iso:title[@language = 'en' and @type = 'title-main'])"/>
	<xsl:variable name="title-fr" select="concat(/iso:iso-standard/iso:bibdata/iso:title[@language = 'fr' and @type = 'title-intro'],  ' &#x2014; ' ,/iso:iso-standard/iso:bibdata/iso:title[@language = 'fr' and @type = 'title-main'])"/>

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
		</contents>
	</xsl:variable>
	
	<xsl:template match="/">
		<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format" font-family="Cambria" font-size="11pt">
			<fo:layout-master-set>
				<!-- cover page -->
				<fo:simple-page-master master-name="cover-page" page-width="{$pageWidth}" page-height="{$pageHeight}">
					<fo:region-body margin-top="25.4mm" margin-bottom="25.4mm" margin-left="31.7mm" margin-right="31.7mm"/>
					<fo:region-before region-name="cover-page-header" extent="25.4mm" display-align="center"/>
					<fo:region-after/>
					<fo:region-start region-name="cover-left-region" extent="31.7mm"/>
					<fo:region-end region-name="cover-right-region" extent="31.7mm"/>
				</fo:simple-page-master>
				<!-- contents pages -->
				<!-- odd pages -->
				<fo:simple-page-master master-name="odd" page-width="{$pageWidth}" page-height="{$pageHeight}">
					<fo:region-body margin-top="25.4mm" margin-bottom="15mm" margin-left="19mm" margin-right="19mm"/>
					<fo:region-before region-name="header-odd" extent="25.4mm"  display-align="center"/>
					<fo:region-after region-name="footer-odd" extent="15mm"/>
					<fo:region-start region-name="left-region" extent="19mm"/>
					<fo:region-end region-name="right-region" extent="19mm"/>
				</fo:simple-page-master>
				<!-- even pages -->
				<fo:simple-page-master master-name="even" page-width="{$pageWidth}" page-height="{$pageHeight}">
					<fo:region-body margin-top="25.4mm" margin-bottom="15mm" margin-left="19mm" margin-right="19mm"/>
					<fo:region-before region-name="header-even" extent="25.4mm"  display-align="center"/>
					<fo:region-after region-name="footer-even" extent="15mm"/>
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
				<fo:block>
					<xsl:value-of select="$copyrightText"/>
				</fo:block>
			</fo:static-content>
        <fo:flow flow-name="xsl-region-body">
            <fo:block-container text-align="right">
						<!-- ISO/WD 24229(E)  -->
						<fo:block font-size="14pt" font-weight="bold" margin-bottom="12pt">
							<xsl:value-of select="concat(/iso:iso-standard/iso:bibdata/iso:docidentifier, '(', translate(substring(iso:iso-standard/iso:bibdata/iso:language,1,1),$lower, $upper), ') ')"/>
						</fo:block>
						<!-- ISO/TC 46/WG 3  -->
						<fo:block margin-bottom="12pt">
							<xsl:value-of select="concat('ISO/', /iso:iso-standard/iso:bibdata/iso:ext/iso:editorialgroup/iso:technical-committee/@type, ' ',
																																/iso:iso-standard/iso:bibdata/iso:ext/iso:editorialgroup/iso:technical-committee/@number, '/', 
																																/iso:iso-standard/iso:bibdata/iso:ext/iso:editorialgroup/iso:workgroup/@type, ' ',
																																/iso:iso-standard/iso:bibdata/iso:ext/iso:editorialgroup/iso:workgroup/@number)"/>
						</fo:block>
						<!-- Secretariat: AFNOR  -->
						<fo:block margin-bottom="100pt">
							<xsl:value-of select="concat('Secretariat: ', /iso:iso-standard/iso:bibdata/iso:ext/iso:editorialgroup/iso:secretariat)"/>
						</fo:block>
            </fo:block-container>
					<fo:block-container font-size="16pt">
						<!-- Information and documentation — Codes for transcription systems  -->
							<fo:block font-weight="bold">
								<xsl:value-of select="$title-en"/>
							</fo:block>
							<fo:block><xsl:value-of select="$linebreak"/></fo:block>
							<fo:block>
								<xsl:value-of select="$title-fr"/>
							</fo:block>
					</fo:block-container>
					<fo:block><xsl:value-of select="$linebreak"/></fo:block>
					<fo:block-container font-size="40pt" text-align="center" margin-top="12pt" margin-bottom="12pt" border="0.5pt solid black">
						<fo:block padding-top="2mm">WD stage</fo:block>
					</fo:block-container>
					<fo:block><xsl:value-of select="$linebreak"/></fo:block>
					<fo:block-container font-size="10pt" margin-top="12pt" margin-bottom="6pt" border="0.5pt solid black">
						<fo:block padding-top="1mm">
							<fo:block text-align="center" font-weight="bold">Warning for WDs and CD</fo:block>
							<fo:block margin-top="6pt" margin-bottom="6pt" margin-left="1.5mm" margin-right="1.5mm">This document is not an ISO International Standard. It is distributed for review and comment. It is subject to change without notice and may not be referred to as an International Standard.</fo:block>
							<fo:block margin-left="1.5mm" margin-right="1.5mm">Recipients of this draft are invited to submit, with their comments, notification of any relevant patent rights of which they are aware and to provide supporting documentation.</fo:block>
						</fo:block>
					</fo:block-container>
        </fo:flow>
      </fo:page-sequence>
			
			<fo:page-sequence master-reference="document" format="i" force-page-count="no-force">
				<xsl:call-template name="insertHeaderFooter"/>
				<fo:flow flow-name="xsl-region-body">
					<fo:block-container margin-top="12pt" margin-bottom="6pt" margin-left="1.5mm" margin-right="1.5mm" border="0.5pt solid black">
						<fo:block margin-bottom="12pt">© ISO 2019, Published in Switzerland.</fo:block>
						<fo:block font-size="10pt" margin-bottom="12pt">All rights reserved. Unless otherwise specified, no part of this publication may be reproduced or utilized otherwise in any form or by any means, electronic or mechanical, including photocopying, or posting on the internet or an intranet, without prior written permission. Permission can be requested from either ISO at the address below or ISO’s member body in the country of the requester.</fo:block>
						<fo:block font-size="10pt" text-indent="7.1mm">
							<fo:block>ISO copyright office</fo:block>
							<fo:block>Ch. de Blandonnet 8 • CP 401</fo:block>
							<fo:block>CH-1214 Vernier, Geneva, Switzerland</fo:block>
							<fo:block>Tel.  + 41 22 749 01 11</fo:block>
							<fo:block>Fax  + 41 22 749 09 47</fo:block>
							<fo:block>copyright@iso.org</fo:block>
							<fo:block>www.iso.org</fo:block>
						</fo:block>
					</fo:block-container>
					<fo:block break-after="page"/>
					<fo:block-container font-weight="bold">
						<fo:block font-size="14pt" margin-bottom="15.5pt">Contents</fo:block>
							<!-- <xsl:copy-of select="xalan:nodeset($contents)"/> -->
							<xsl:for-each select="xalan:nodeset($contents)//item">
								<xsl:if test="@display = 'true'">
									<fo:block text-align-last="justify">
										<xsl:if test="@level = 1">
											<xsl:attribute name="margin-top">6pt</xsl:attribute>
										</xsl:if>
										<fo:basic-link internal-destination="{@id}">
											<xsl:if test="@section">
												<xsl:value-of select="@section"/><xsl:text>&#xA0;&#xA0;</xsl:text>
											</xsl:if>
											<xsl:value-of select="text()"/>
											<fo:inline keep-together.within-line="always">
												<fo:leader leader-pattern="dots"/>
												<fo:page-number-citation ref-id="{@id}"/>
											</fo:inline>
										</fo:basic-link>
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
	
	<!-- Foreword, Introduction -->
	<xsl:template match="iso:iso-standard/iso:preface/*">
		<fo:block break-before="page"/>
		<fo:block>
			<xsl:apply-templates />
		</fo:block>
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
			<xsl:apply-templates>
				<xsl:with-param name="sectionNum" select="$sectionNum_"/>
			</xsl:apply-templates>
		</fo:block>
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
		<fo:block font-size="{$font-size}" font-weight="bold" margin-bottom="12pt" keep-with-next="always">
			<xsl:attribute name="margin-top">
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
						<xsl:when test="$level = 2">
							<xsl:number format=".1 " count="iso:clause" />
						</xsl:when>
						<xsl:when test="$level = 3">
							<xsl:number format=".1 " level="multiple" count="iso:clause/iso:clause" />
						</xsl:when>
						<xsl:when test="$level = 4">
							<xsl:number format=".1 " level="multiple" count="iso:clause/iso:clause | iso:clause/iso:clause/iso:clause" />
						</xsl:when>
					</xsl:choose>
					<xsl:text>&#xA0;&#xA0;</xsl:text>
				</xsl:if>
				<xsl:apply-templates />
			</fo:inline>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="iso:title" mode="contents">
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
		<item level="{$level}" id="{$id}">
			<xsl:if test="$sectionNum">
				<xsl:attribute name="section">
					<xsl:value-of select="$sectionNum"/>
					<xsl:choose>
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
					<xsl:when test="$level &lt;= 2">true</xsl:when>
					<xsl:otherwise>false</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:value-of select="text()"/>
		</item>
	</xsl:template>
	
	<xsl:template match="iso:p">
		<fo:block text-align="justify" margin-bottom="12pt">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="iso:em">
		<fo:inline font-style="italic">
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="text()">
		<xsl:value-of select="."/>
	</xsl:template>
	
	<xsl:template match="iso:td//text() | iso:th//text()">
		<xsl:call-template name="add-zero-spaces"/>
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
	
	<xsl:template match="iso:bibitem">
		<fo:block margin-bottom="12pt">
			<fo:inline id="{iso:docidentifier}"><xsl:value-of select="iso:docidentifier"/></fo:inline>, <fo:inline font-style="italic"><xsl:value-of select="iso:title[@type = 'main' and @language = 'en']"/></fo:inline>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="iso:bibitem" mode="contents"/>
	
	<xsl:template match="iso:ul | iso:ol">
		<fo:list-block >
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
		<fo:inline><xsl:value-of select="@target"/></fo:inline>
	</xsl:template>
	
	<xsl:template match="iso:preferred">
		<xsl:param name="sectionNum"/>
		<fo:block font-weight="bold">
			<fo:inline id="{../@id}">
				<xsl:value-of select="$sectionNum"/>.<xsl:number count="iso:term"/>
			</fo:inline>
		</fo:block>
		<fo:block font-weight="bold">
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
	
	<xsl:template match="iso:definition">
		<fo:block margin-bottom="12pt">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="iso:termsource">
		<fo:block margin-bottom="12pt" keep-with-previous="always">
			<!-- Example: [SOURCE: ISO 5127:2017, 3.1.6.02] -->
			<fo:basic-link internal-destination="{iso:origin/@citeas}">
			<xsl:text>[SOURCE: </xsl:text>
			<xsl:value-of select="iso:origin/@citeas"/>
			<xsl:if test="iso:origin/iso:locality/iso:referenceFrom">
				<xsl:text>, </xsl:text><xsl:value-of select="iso:origin/iso:locality/iso:referenceFrom"/>
			</xsl:if>
			<xsl:text>]</xsl:text>
			</fo:basic-link>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="iso:annex">
		<fo:block break-before="page"/>
		<fo:block font-size="13pt" text-align="center">
			<fo:block font-weight="bold">
				<fo:inline id="{@id}"><xsl:value-of select="'Annex '"/><xsl:number format="A" level="any"/></fo:inline>
			</fo:block>
			<fo:block>(<xsl:value-of select="@obligation"/>)</fo:block>
			<fo:block><xsl:value-of select="$linebreak"/></fo:block>
		</fo:block>
		<xsl:apply-templates />
	</xsl:template>
	
	<xsl:template match="iso:annex" mode="contents">
		<item id="{@id}" level="1" display="true">
			<xsl:variable name="value">
				<xsl:value-of select="'Annex '"/><xsl:number format="A" level="any"/>
			</xsl:variable>
			<xsl:attribute name="section">
				<xsl:value-of select="$value"/>
			</xsl:attribute>
			<xsl:text> (</xsl:text><xsl:value-of select="@obligation"/><xsl:text>) </xsl:text>
			<xsl:value-of select="iso:title"/>
		</item>
		<xsl:apply-templates select="iso:clause" mode="contents"/>
	</xsl:template>
	
	<xsl:template match="iso:annex/iso:title">
		<fo:block font-size="13pt" text-align="center" font-weight="bold" margin-bottom="12pt" keep-with-next="always">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="iso:annex/iso:clause">
		<xsl:apply-templates />
	</xsl:template>
	
	<xsl:template match="iso:annex/iso:clause" mode="contents">
		<item id="{@id}" display="true">
			<xsl:variable name="value">
				<xsl:number format="A.1" level="multiple" count="iso:annex | iso:clause"/>
			</xsl:variable>
			<xsl:attribute name="section">
				<xsl:value-of select="$value"/>
			</xsl:attribute>
			<xsl:value-of select="iso:title"/>
		</item>
	</xsl:template>
	
	<xsl:template match="iso:annex/iso:clause/iso:title">
		<fo:block font-weight="bold" margin-bottom="12pt" keep-with-next="always">
			<fo:inline id="{../@id}">
				<xsl:number format="A.1 " level="multiple" count="iso:annex | iso:clause"/>
				<xsl:value-of select="'&#xA0;&#xA0;'"/>
			</fo:inline>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="iso:table">
		<fo:block font-weight="bold" text-align="center" margin-bottom="6pt">
			<xsl:text>Table </xsl:text><xsl:number format="A." count="iso:annex"/><xsl:number format="1"/>
		</fo:block>
		
		<xsl:variable name="colwidths">
			<xsl:variable name="cols-count" select="count(iso:thead/iso:tr/iso:th)"/>
			<xsl:call-template name="calculate-column-widths">
				<xsl:with-param name="cols-count" select="$cols-count"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="margin-left">
			<xsl:choose>
				<xsl:when test="sum(xalan:nodeset($colwidths)//column) &gt; 75">15</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<fo:block-container margin-left="-{$margin-left}mm" margin-right="-{$margin-left}mm">
			<fo:table table-layout="fixed" font-size="10pt" width="100%" margin-left="{$margin-left}mm" margin-right="{$margin-left}mm">
				<xsl:for-each select="xalan:nodeset($colwidths)//column">
					<xsl:choose>
						<xsl:when test=". = 1">
							<fo:table-column column-width="proportional-column-width(2)"/>
						</xsl:when>
						<xsl:otherwise>
							<fo:table-column column-width="proportional-column-width({.})"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
				<xsl:apply-templates />
			</fo:table>
		</fo:block-container>
	</xsl:template>
	
	<xsl:template name="calculate-column-widths">
		<xsl:param name="cols-count"/>
		<xsl:param name="curr-col" select="1"/>
		<xsl:param name="width" select="0"/>
		
		<xsl:if test="$curr-col &lt;= $cols-count">
			<xsl:variable name="widths">
				<xsl:for-each select="iso:thead//iso:tr">
					<width>
						<xsl:variable name="words">
							<xsl:call-template name="tokenize">
								<xsl:with-param name="text" select="translate(iso:th[$curr-col],'- —', '   ')"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:call-template name="max_length">
							<xsl:with-param name="words" select="xalan:nodeset($words)"/>
						</xsl:call-template>
					</width>
				</xsl:for-each>
				<xsl:for-each select="iso:tbody//iso:tr">
					<width>
						<xsl:variable name="words">
							<xsl:call-template name="tokenize">
								<xsl:with-param name="text" select="translate(iso:td[$curr-col],'- —', '   ')"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:call-template name="max_length">
							<xsl:with-param name="words" select="xalan:nodeset($words)"/>
						</xsl:call-template>
					</width>
				</xsl:for-each>
			</xsl:variable>
			
			<column>
				<xsl:for-each select="xalan:nodeset($widths)//width">
					<xsl:sort select="." data-type="number" order="descending"/>
					<xsl:if test="position()=1">
							<xsl:value-of select="."/>
					</xsl:if>
				</xsl:for-each>
			</column>
			<xsl:call-template name="calculate-column-widths">
				<xsl:with-param name="cols-count" select="$cols-count"/>
				<xsl:with-param name="curr-col" select="$curr-col +1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<!-- for debug purpose only -->
	<xsl:template match="iso:table2"/>
	
	<xsl:template match="iso:thead"/>
	
	<xsl:template match="iso:thead" mode="process">
		<!-- <fo:table-header font-weight="bold">
			<xsl:apply-templates />
		</fo:table-header> -->
			<xsl:apply-templates />
	</xsl:template>
	
	<xsl:template match="iso:tbody">
		<fo:table-body>
			<xsl:apply-templates select="../iso:thead" mode="process"/>
			<xsl:apply-templates />
			<xsl:apply-templates select="../iso:note" mode="process"/>
		</fo:table-body>
	</xsl:template>
	
	<xsl:template match="iso:thead/iso:tr">
		<fo:table-row font-weight="bold" min-height="4mm" border-top="solid black 1.5pt" border-bottom="solid black 1.5pt">
			<xsl:apply-templates />
		</fo:table-row>
	</xsl:template>
	
	<xsl:template match="iso:tr">
		<fo:table-row min-height="4mm">
			<xsl:apply-templates />
		</fo:table-row>
	</xsl:template>
	
	<xsl:template match="iso:th">
		<fo:table-cell border="solid black 1pt" padding-left="1mm" display-align="center">
			<fo:block>
				<xsl:apply-templates />
			</fo:block>
		</fo:table-cell>
	</xsl:template>
	
	<xsl:template match="iso:td">
		<fo:table-cell border="solid black 1pt" padding-left="1mm">
			<fo:block>
				<xsl:apply-templates />
			</fo:block>
		</fo:table-cell>
	</xsl:template>
	
	<xsl:template match="iso:table/iso:note"/>
	<xsl:template match="iso:table/iso:note" mode="process">
		<xsl:variable name="cols-count" select="count(../iso:thead/iso:tr/iso:th)"/>
		<!-- <fo:table-footer> -->
			<fo:table-row>
				<fo:table-cell border="solid black 1pt" padding-left="1mm" padding-right="1mm" padding-top="1mm" number-columns-spanned="{$cols-count}">
					<xsl:apply-templates />
						<xsl:for-each select="..//iso:fn">
							<fo:block margin-bottom="12pt">
								<fo:inline font-size="80%" padding-right="5mm" vertical-align="super" id="{@reference}">
									<xsl:value-of select="@reference"/>
								</fo:inline>
								<xsl:apply-templates />
							</fo:block>
						</xsl:for-each>
				</fo:table-cell>
			</fo:table-row>
		<!-- </fo:table-footer> -->
	</xsl:template>

	<xsl:template match="iso:fn">
		<fo:inline font-size="80%" keep-with-previous.within-line="always" vertical-align="super">
			<fo:basic-link internal-destination="{@reference}">
				<xsl:value-of select="@reference"/>
			</fo:basic-link>
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="iso:fn/iso:p">
		<fo:inline>
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="iso:references[@id = '_bibliography']">
		<fo:block break-before="page"/>
			<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="iso:references[@id = '_bibliography']" mode="contents">
		<xsl:apply-templates mode="contents"/>
	</xsl:template>
	
	<!-- Example: [1] ISO 9:1995, Information and documentation – Transliteration of Cyrillic characters into Latin characters – Slavic and non-Slavic languages -->
	<xsl:template match="iso:references[@id = '_bibliography']/iso:bibitem">
		<fo:list-block margin-bottom="12pt">
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
						<xsl:value-of select="iso:docidentifier"/>
						<xsl:text>, </xsl:text>
						<xsl:apply-templates select="iso:title[@type = 'main' and @language = 'en']"/>
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

	<xsl:template match="mathml:math">
		<fo:inline font-size="12pt" color="red">
			MathML issue! <xsl:apply-templates />
		</fo:inline>
		<!-- <fo:instream-foreign-object>
			<xsl:copy-of select="."/>
		</fo:instream-foreign-object> -->
	</xsl:template>
	
	<xsl:template match="iso:xref">
		<fo:basic-link internal-destination="{@target}">
			<xsl:value-of select="xalan:nodeset($contents)//item[@id = current()/@target]/@section"/>
      </fo:basic-link>
	</xsl:template>

	<xsl:template match="iso:sourcecode">
		<fo:block font-family="Courier" font-size="9pt" margin-bottom="12pt">
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
	
	<xsl:template match="iso:note/iso:p">
		<fo:block font-size="10pt" margin-bottom="12pt">
			<fo:inline padding-right="4mm">NOTE</fo:inline>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>

	<xsl:template match="iso:eref">
		<fo:inline>
			<fo:basic-link internal-destination="{@bibitemid}">
				<xsl:value-of select="@citeas" disable-output-escaping="yes"/>
			</fo:basic-link>
		</fo:inline>
	</xsl:template>
	
	<xsl:template name="insertHeaderFooter">
		<fo:static-content flow-name="header-even">
			<fo:block font-weight="bold"><xsl:value-of select="$ISOname"/></fo:block>
		</fo:static-content>
		<fo:static-content flow-name="footer-even" font-size="10pt">
			<fo:table table-layout="fixed" width="100%">
				<fo:table-column column-width="50%"/>
				<fo:table-column column-width="50%"/>
				<fo:table-body>
					<fo:table-row>
						<fo:table-cell>
							<fo:block><fo:page-number/></fo:block>
						</fo:table-cell>
						<fo:table-cell>
							<fo:block text-align="right"><xsl:value-of select="$copyrightText"/></fo:block>
						</fo:table-cell>
					</fo:table-row>
				</fo:table-body>
			</fo:table>
		</fo:static-content>
		<fo:static-content flow-name="header-odd">
			<fo:block font-weight="bold" text-align="right"><xsl:value-of select="$ISOname"/></fo:block>
		</fo:static-content>
		<fo:static-content flow-name="footer-odd" font-size="10pt">
			<fo:table table-layout="fixed" width="100%">
				<fo:table-column column-width="50%"/>
				<fo:table-column column-width="50%"/>
				<fo:table-body>
					<fo:table-row>
						<fo:table-cell>
							<fo:block><xsl:value-of select="$copyrightText"/></fo:block>
						</fo:table-cell>
						<fo:table-cell>
							<fo:block text-align="right"><fo:page-number/></fo:block>
						</fo:table-cell>
					</fo:table-row>
				</fo:table-body>
			</fo:table>
		</fo:static-content>
	</xsl:template>

	<!-- split string 'text' by 'separator' -->
	<xsl:template name="tokenize">
		<xsl:param name="text"/>
		<xsl:param name="separator" select="' '"/>
		<xsl:choose>
			<xsl:when test="not(contains($text, $separator))">
				<word>
					<xsl:value-of select="string-length(normalize-space($text))"/>
				</word>
			</xsl:when>
			<xsl:otherwise>
				<word>
					<xsl:value-of select="string-length(normalize-space(substring-before($text, $separator)))"/>
				</word>
				<xsl:call-template name="tokenize">
					<xsl:with-param name="text" select="substring-after($text, $separator)"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- get max value in array -->
	<xsl:template name="max_length">
		<xsl:param name="words"/>
		<xsl:for-each select="$words//word">
				<xsl:sort select="." data-type="number" order="descending"/>
				<xsl:if test="position()=1">
						<xsl:value-of select="."/>
				</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<!-- add zero space after dash character (for table's entries) -->
	<xsl:template name="add-zero-spaces">
		<xsl:param name="text" select="."/>
		<xsl:variable name="zero-space-after-chars">&#x002D;</xsl:variable>
		<xsl:variable name="zero-space">&#x200B;</xsl:variable>
		<xsl:choose>
			<xsl:when test="contains($text, $zero-space-after-chars)">
				<xsl:value-of select="substring-before($text, $zero-space-after-chars)"/>
				<xsl:value-of select="$zero-space-after-chars"/>
				<xsl:value-of select="$zero-space"/>
				<xsl:call-template name="add-zero-spaces">
					<xsl:with-param name="text" select="substring-after($text, $zero-space-after-chars)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>   
	
</xsl:stylesheet>
