<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:iso="http://riboseinc.com/isoxml" version="1.0">

	<xsl:variable name="lower">abcdefghijklmnopqrstuvwxyz</xsl:variable> 
	<xsl:variable name="upper">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>

	<xsl:variable name="pageWidth" select="'210mm'"/>
	<xsl:variable name="pageHeight" select="'297mm'"/>

	<xsl:variable name="copyrightText" select="concat('© ISO ', iso:iso-standard/iso:bibdata/iso:copyright/iso:from ,' – All rights reserved')"/>
	<xsl:variable name="ISOname" select="concat(/iso:iso-standard/iso:bibdata/iso:docidentifier, ':', /iso:iso-standard/iso:bibdata/iso:copyright/iso:from , '(', translate(substring(iso:iso-standard/iso:bibdata/iso:language,1,1),$lower, $upper), ') ')"/>
	
	<xsl:variable name="linebreak" select="'&#x2028;'"/>

	<!-- Information and documentation — Codes for transcription systems  -->
	<xsl:variable name="title-en" select="/iso:iso-standard/iso:bibdata/iso:title[@language = 'en' and @type = 'main']"/>
	<xsl:variable name="title-fr" select="/iso:iso-standard/iso:bibdata/iso:title[@language = 'fr' and @type = 'main']"/>

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
					<fo:block-container font-size="40pt" text-align="center" margin-top="12pt" margin-bottom="12pt" margin-left="1.5mm" margin-right="1.5mm" border="0.5pt solid black">
						<fo:block padding-top="2mm">WD stage</fo:block>
					</fo:block-container>
					<fo:block><xsl:value-of select="$linebreak"/></fo:block>
					<fo:block-container font-size="10pt" margin-top="12pt" margin-bottom="6pt" margin-left="1.5mm" margin-right="1.5mm" border="0.5pt solid black">
						<fo:block text-align="center" font-weight="bold">Warning for WDs and CD</fo:block>
						<fo:block margin-top="6pt" margin-bottom="6pt">This document is not an ISO International Standard. It is distributed for review and comment. It is subject to change without notice and may not be referred to as an International Standard.</fo:block>
						<fo:block>Recipients of this draft are invited to submit, with their comments, notification of any relevant patent rights of which they are aware and to provide supporting documentation.</fo:block>
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
						<fo:block>Contents</fo:block>
					</fo:block-container>
					<fo:block break-after="page"/>
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
						<xsl:apply-templates select="/iso:iso-standard/iso:sections/iso:clause[@id = '_scope']"/>
						<xsl:apply-templates select="/iso:iso-standard/iso:bibliography/iso:references[@id = '_normative_references']"/>
						
						<xsl:apply-templates select="/iso:iso-standard/iso:sections/node()[@id != '_scope']"/>
					</fo:block>
					
				</fo:flow>
			</fo:page-sequence>
			
			
		</fo:root>
	</xsl:template> 


	
	<!-- Foreword, Introduction -->
	<xsl:template match="iso:iso-standard/iso:preface/node()">
		<fo:block>
			<xsl:apply-templates />
		</fo:block>
		<xsl:if test="position() != last()">
			<fo:block break-after="page"/>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="iso:title">
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
				<xsl:when test="$level = 3">11pt</xsl:when>
				<xsl:otherwise>13pt</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<fo:block font-size="{$font-size}" font-weight="bold" margin-top="13.5pt" margin-bottom="12pt">
			<xsl:apply-templates />
		</fo:block>
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
	
	<xsl:template match="iso:iso-standard/iso:sections/node()">
		<fo:block>
			<xsl:apply-templates />
		</fo:block>
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
			<xsl:value-of select="iso:docidentifier"/>, <fo:inline font-style="italic"><xsl:value-of select="iso:title[@type = 'main' and @language = 'en']"/></fo:inline>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="iso:ul | iso:ol">
		<fo:list-block provisional-distance-between-starts="6.3mm" provisional-label-separation="5mm">
			<xsl:apply-templates />
		</fo:list-block>
	</xsl:template>
	
	<xsl:template match="iso:li">
		<fo:list-item>
			<fo:list-item-label end-indent="label-end()">
				<fo:block>&#x2014;</fo:block>
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
		<fo:block font-weight="bold">
			<xsl:apply-templates />
		</fo:block>
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
	
</xsl:stylesheet>
