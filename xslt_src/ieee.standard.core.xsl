<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
											xmlns:fo="http://www.w3.org/1999/XSL/Format" 
											xmlns:ieee="https://www.metanorma.org/ns/ieee" 
											xmlns:mathml="http://www.w3.org/1998/Math/MathML" 
											xmlns:xalan="http://xml.apache.org/xalan" 
											xmlns:fox="http://xmlgraphics.apache.org/fop/extensions" 
											xmlns:pdf="http://xmlgraphics.apache.org/fop/extensions/pdf"
											xmlns:xlink="http://www.w3.org/1999/xlink"
											xmlns:java="http://xml.apache.org/xalan/java"
											xmlns:barcode="http://barcode4j.krysalis.org/ns" 
											exclude-result-prefixes="java"
											version="1.0">

	<xsl:output method="xml" encoding="UTF-8" indent="no"/>
		
	<xsl:include href="./common.xsl"/>

	<!-- mandatory 'key' -->
	<xsl:key name="kfn" match="*[local-name() = 'fn'][not(ancestor::*[(local-name() = 'table' or local-name() = 'figure') and not(ancestor::*[local-name() = 'name'])])]" use="@reference"/>
	
	<!-- mandatory variable -->
	<xsl:variable name="namespace">ieee</xsl:variable>
	
	<!-- mandatory variable -->
	<xsl:variable name="namespace_full">https://www.metanorma.org/ns/ieee</xsl:variable>
	
	<!-- mandatory variable -->
	<xsl:variable name="debug">false</xsl:variable>
	
	<!-- mandatory variable -->
	<xsl:variable name="contents_">
		<xsl:variable name="bundle" select="count(//ieee:ieee-standard) &gt; 1"/>
		<xsl:for-each select="//ieee:ieee-standard">
			<xsl:variable name="num"><xsl:number level="any" count="ieee:ieee-standard"/></xsl:variable>
			<xsl:variable name="docnumber"><xsl:value-of select="ieee:bibdata/ieee:docidentifier[@type = 'IEEE']"/></xsl:variable>
			<!-- <xsl:variable name="current_document">
				<xsl:copy-of select="."/>
			</xsl:variable> -->
			<xsl:for-each select="."> <!-- xalan:nodeset($current_document) -->
				<doc num="{$num}" firstpage_id="firstpage_id_{$num}" title-part="{$docnumber}" bundle="{$bundle}"> <!-- 'bundle' means several different documents (not language versions) in one xml -->
					<contents>
						<xsl:call-template name="processPrefaceSectionsDefault_Contents"/>
						<xsl:call-template name="processMainSectionsDefault_Contents"/>
						<xsl:apply-templates select="//ieee:indexsect" mode="contents"/>
						
						<xsl:call-template name="processTablesFigures_Contents"/>
					</contents>
				</doc>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="contents" select="xalan:nodeset($contents_)"/>
	
	<!-- mandatory variable -->
	<xsl:variable name="ids">
		<xsl:for-each select="//*[@id]">
			<id><xsl:value-of select="@id"/></id>
		</xsl:for-each>
	</xsl:variable>

	
	<xsl:template match="/">
		<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format" xml:lang="{$lang}">
			<xsl:variable name="root-style">
				<root-style xsl:use-attribute-sets="root-style">
				</root-style>
			</xsl:variable>
			<xsl:call-template name="insertRootStyle">
				<xsl:with-param name="root-style" select="$root-style"/>
			</xsl:call-template>
			
			<fo:layout-master-set>
			
				<!-- ======================== -->
				<!-- IEEE pages -->
				<!-- ======================== -->
				<!-- IEEE cover page -->
				<fo:simple-page-master master-name="cover-page" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
					<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
					<fo:region-before region-name="cover-page-header" extent="{$marginTop}mm"/>
					<fo:region-after region-name="cover-page-footer" extent="{$marginBottom}mm"/>
					<fo:region-start region-name="left-region" extent="{$marginLeftRight1}mm"/>
					<fo:region-end region-name="right-region" extent="{$marginLeftRight2}mm"/>
				</fo:simple-page-master>
			
				<fo:simple-page-master master-name="document" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
					<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
					<fo:region-before region-name="header" extent="{$marginTop}mm"/>
					<fo:region-after region-name="footer" extent="{$marginBottom}mm"/>
					<fo:region-start region-name="left-region" extent="{$marginLeftRight1}mm"/>
					<fo:region-end region-name="right-region" extent="{$marginLeftRight2}mm"/>
				</fo:simple-page-master>
				
				<!-- Index pages -->
				<fo:simple-page-master master-name="page-index" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
					<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm" column-count="2" column-gap="10mm"/>
					<fo:region-before region-name="header" extent="{$marginTop}mm"/>
					<fo:region-after region-name="footer" extent="{$marginBottom}mm"/>
					<fo:region-start region-name="left-region" extent="{$marginLeftRight1}mm"/>
					<fo:region-end region-name="right-region" extent="{$marginLeftRight2}mm"/>
				</fo:simple-page-master>
				
				<!-- landscape -->
				<fo:simple-page-master master-name="document-landscape" page-width="{$pageHeight}mm" page-height="{$pageWidth}mm">
					<fo:region-body margin-top="{$marginLeftRight1}mm" margin-bottom="{$marginLeftRight2}mm" margin-left="{$marginBottom}mm" margin-right="{$marginTop}mm"/>
					<fo:region-before region-name="header" extent="{$marginLeftRight1}mm" precedence="true"/>
					<fo:region-after region-name="footer" extent="{$marginLeftRight2}mm" precedence="true"/>
					<fo:region-start region-name="left-region-landscape" extent="{$marginBottom}mm"/>
					<fo:region-end region-name="right-region-landscape" extent="{$marginTop}mm"/>
				</fo:simple-page-master>
				
				<!-- ======================== -->
				<!-- END IEEE pages -->
				<!-- ======================== -->
				
				
			
			</fo:layout-master-set>
			
			<fo:declarations>
				<xsl:call-template name="addPDFUAmeta"/>
			</fo:declarations>

			<xsl:call-template name="addBookmarks">
				<xsl:with-param name="contents" select="$contents"/>
			</xsl:call-template>
			
			<xsl:variable name="updated_xml_step1">
				<xsl:apply-templates mode="update_xml_step1"/>
			</xsl:variable>
			<!-- DEBUG: updated_xml_step1=<xsl:copy-of select="$updated_xml_step1"/> -->
			
			<xsl:variable name="updated_xml_step2">
				<xsl:apply-templates select="xalan:nodeset($updated_xml_step1)" mode="update_xml_step2"/>
			</xsl:variable>
			<!-- DEBUG: updated_xml_step2=<xsl:copy-of select="$updated_xml_step2"/> -->
			
			<xsl:for-each select="xalan:nodeset($updated_xml_step2)//ieee:ieee-standard">
				<xsl:variable name="num"><xsl:number level="any" count="ieee:ieee-standard"/></xsl:variable>
				
				
				<xsl:for-each select=".">
				
					<xsl:variable name="designation">&lt;designation&gt;</xsl:variable>
					<xsl:variable name="draft_number">&lt;draft_number&gt;</xsl:variable>
					<xsl:variable name="draft_month">&lt;draft_month&gt;</xsl:variable>
					<xsl:variable name="draft_year">&lt;draft_year&gt;</xsl:variable>
					<xsl:variable name="opt_trial_use">&lt;opt_Trial-Use&gt;</xsl:variable>
					<xsl:variable name="doctype">&lt;Gde./Rec. Prac./Std.&gt;</xsl:variable>
					<xsl:variable name="title">&lt;Complete Title Matching PAR&gt;</xsl:variable>
					<xsl:variable name="copyright_year" select="/ieee:ieee-standard/ieee:bibdata/ieee:copyright/ieee:from"/>
					<xsl:variable name="copyright_holder" select="/ieee:ieee-standard/ieee:bibdata/ieee:copyright/ieee:owner/ieee:organization/ieee:name"/>
					

					<fo:page-sequence master-reference="document" force-page-count="no-force">
						
						<xsl:call-template name="insertFootnoteSeparator"/>
						
						<xsl:call-template name="insertHeaderFooter">
							<xsl:with-param name="designation" select="$designation"/>
							<xsl:with-param name="draft_number" select="$draft_number"/>
							<xsl:with-param name="draft_month" select="$draft_month"/>
							<xsl:with-param name="draft_year" select="$draft_year"/>
							<xsl:with-param name="opt_trial_use" select="$opt_trial_use"/>
							<xsl:with-param name="doctype" select="$doctype"/>
							<xsl:with-param name="title" select="$title"/>
							<xsl:with-param name="copyright_year" select="$copyright_year"/>
							<xsl:with-param name="copyright_holder" select="$copyright_holder"/>
							<xsl:with-param name="hideFooter">true</xsl:with-param>
						</xsl:call-template>
						
						<fo:flow flow-name="xsl-region-body">
							<fo:block-container margin-top="18mm" id="firstpage_id_{$num}">
								<fo:block font-family="Arial">
									<fo:block font-size="23pt" font-weight="bold" margin-top="50pt" margin-bottom="36pt">
										<xsl:text>P</xsl:text>
										<xsl:value-of select="$designation"/>
										<xsl:text>™/D</xsl:text>
										<xsl:value-of select="$draft_number"/>
										<xsl:text>Draft</xsl:text>
										<xsl:value-of select="$opt_trial_use"/>
										<xsl:value-of select="$doctype"/>
										<xsl:text> for </xsl:text>
										<xsl:copy-of select="$title"/>
									</fo:block>
									<fo:block>Developed by the</fo:block>
									<fo:block>&#xa0;</fo:block>
									<fo:block font-size="11pt" font-weight="bold">&lt;Committee Name&gt;</fo:block>
									<fo:block>of the</fo:block>
									<fo:block font-size="11pt" font-weight="bold">IEEE &lt;Society Name&gt;</fo:block>
									<fo:block>&#xa0;</fo:block>
									<fo:block>&#xa0;</fo:block>
									<fo:block>Approved &lt;Date Approved&gt;</fo:block>
									<fo:block>&#xa0;</fo:block>
									<fo:block font-size="11pt" font-weight="bold">IEEE SA Standards Board</fo:block>
								</fo:block>
								<fo:block>
									<fo:block>&#xa0;</fo:block>
									<fo:block>Copyright © 2022 by The Institute of Electrical and Electronics Engineers, Inc.</fo:block>
									<fo:block>Three Park Avenue</fo:block>
									<fo:block>New York, New York 10016-5997, USA</fo:block>
									<fo:block margin-top="6pt" margin-bottom="6pt">All rights reserved.</fo:block>
									<fo:block margin-top="6pt" margin-bottom="6pt" text-align="justify">This document is an unapproved draft of a proposed IEEE Standard. As such, this document is subject to change. USE AT YOUR OWN RISK! IEEE copyright statements SHALL NOT BE REMOVED from draft or approved IEEE standards, or modified in any way. Because this is an unapproved draft, this document must not be utilized for any conformance/compliance purposes. Permission is hereby granted for officers from each IEEE Standards Working Group or Committee to reproduce the draft document developed by that Working Group for purposes of international standardization consideration.  IEEE Standards Department must be informed of the submission for consideration prior to any reproduction for international standardization consideration (stds-ipr@ieee.org). Prior to adoption of this document, in whole or in part, by another standards development organization, permission must first be obtained from the IEEE Standards Department (stds-ipr@ieee.org). When requesting permission, IEEE Standards Department will require a copy of the standard development organization's document highlighting the use of IEEE content. Other entities seeking permission to reproduce this document, in whole or in part, must also obtain permission from the IEEE Standards Department.</fo:block>
									<fo:block>IEEE Standards Department</fo:block>
									<fo:block>445 Hoes Lane</fo:block>
									<fo:block>Piscataway, NJ 08854, USA</fo:block>
								</fo:block>
								
								<fo:block break-after="page"/>
								
								<fo:block font-family="Arial">
									<fo:block>
										<fo:inline font-weight="bold">Abstract: </fo:inline> &lt;Select this text and type or paste Abstract—contents of the Scope may be used&gt;
									</fo:block>
									<fo:block>&#xa0;</fo:block>
									<fo:block>
										<fo:inline font-weight="bold">Keywords: </fo:inline> &lt;Select this text and type or paste keywords&gt;
									</fo:block>
								</fo:block>
								
								<fo:block>
									<fo:footnote>
										<fo:inline></fo:inline>
										<fo:footnote-body font-family="Arial" font-size="7pt">
											<fo:block>The Institute of Electrical and Electronics Engineers, Inc.</fo:block>
											<fo:block>3 Park Avenue, New York, NY 10016-5997, USA</fo:block>
											<fo:block>&#xa0;</fo:block>
											<fo:block>Copyright © 2022 by The Institute of Electrical and Electronics Engineers, Inc. </fo:block>
											<fo:block>All rights reserved. Published &lt;Date Published&gt;. Printed in the United States of America.</fo:block>
											<fo:block>&#xa0;</fo:block>
											<fo:block>IEEE is a registered trademark in the U.S. Patent &amp; Trademark Office, owned by The Institute of Electrical and Electronics &#xa; Engineers, Incorporated.</fo:block>
											<fo:block>&#xa0;</fo:block>
											<fo:block>PDF:	ISBN 978-0-XXXX-XXXX-X	STDXXXXX</fo:block>
											<fo:block>Print:	ISBN 978-0-XXXX-XXXX-X	STDPDXXXXX</fo:block>
											<fo:block>&#xa0;</fo:block>
											<fo:block font-style="italic">
												<fo:block>IEEE prohibits discrimination, harassment, and bullying.</fo:block>
												<fo:block>For more information, visit https://www.ieee.org/about/corporate/governance/p9-26.html.</fo:block>
												<fo:block>No part of this publication may be reproduced in any form, in an electronic retrieval system or otherwise, without the prior written permission of the publisher.</fo:block>
											</fo:block>
										</fo:footnote-body>
									</fo:footnote>
								</fo:block>
								
								<fo:block break-after="page"/>
								
								<fo:block text-align="justify">
									<fo:block font-family="Arial" font-size="12pt" margin-bottom="12pt" keep-with-next="always">Important Notices and Disclaimers Concerning IEEE Standards Documents</fo:block>
									<fo:block space-after="12pt">IEEE Standards documents are made available for use subject to important notices and legal disclaimers. These notices and disclaimers, or a reference to this page (https://standards.ieee.org/ipr/disclaimers.html), appear in all standards and may be found under the heading “Important Notices and Disclaimers Concerning IEEE Standards Documents.”</fo:block>
									
									<fo:block font-family="Arial" font-size="11pt" space-before="18pt" margin-bottom="12pt" keep-with-next="always">Notice and Disclaimer of Liability Concerning the Use of IEEE Standards Documents</fo:block>
									<fo:block space-after="12pt">IEEE Standards documents are developed within the IEEE Societies and the Standards Coordinating Committees of the IEEE Standards Association (IEEE SA) Standards Board. IEEE develops its standards through an accredited consensus development process, which brings together volunteers representing varied viewpoints and interests to achieve the final product. IEEE Standards are documents developed by volunteers with scientific, academic, and industry-based expertise in technical working groups. Volunteers are not necessarily members of IEEE or IEEE SA, and participate without compensation from IEEE. While IEEE administers the process and establishes rules to promote fairness in the consensus development process, IEEE does not independently evaluate, test, or verify the accuracy of any of the information or the soundness of any judgments contained in its standards.</fo:block>


									
								</fo:block>
								
							</fo:block-container>
						</fo:flow>
					</fo:page-sequence>
						
					<fo:page-sequence master-reference="document" format="i">
						<xsl:call-template name="insertFootnoteSeparator"/>
						
						<xsl:call-template name="insertHeaderFooter">
							<xsl:with-param name="designation" select="$designation"/>
							<xsl:with-param name="draft_number" select="$draft_number"/>
							<xsl:with-param name="draft_month" select="$draft_month"/>
							<xsl:with-param name="draft_year" select="$draft_year"/>
							<xsl:with-param name="opt_trial_use" select="$opt_trial_use"/>
							<xsl:with-param name="doctype" select="$doctype"/>
							<xsl:with-param name="title" select="$title"/>
							<xsl:with-param name="copyright_year" select="$copyright_year"/>
							<xsl:with-param name="copyright_holder" select="$copyright_holder"/>
						</xsl:call-template>
						
						<fo:flow flow-name="xsl-region-body">
							<fo:block font-family="Arial" font-size="12pt" font-weight="bold" margin-top="12pt" margin-bottom="12pt">Participants</fo:block>
							<fo:block margin-bottom="12pt">At the time this draft<xsl:value-of select="$opt_trial_use"/><xsl:value-of select="$doctype"/> was completed, the &lt;Working Group Name&gt; Working Group had the following membership:</fo:block>
							<fo:block text-align="center" margin-bottom="12pt">
								<fo:block>
									<fo:inline font-weight="bold">&lt;Chair Name&gt;</fo:inline>, <fo:inline font-style="italic">Chair</fo:inline>
								</fo:block>
								<fo:block>
									<fo:inline font-weight="bold">&lt;Vice-chair Name&gt;</fo:inline>, <fo:inline font-style="italic">Vice Chair</fo:inline>
								</fo:block>
							</fo:block>
							
							<fo:table width="100%" table-layout="fixed" font-size="9pt">
								<fo:table-body>
									<fo:table-row>
										<fo:table-cell>
											<fo:block>Participant1</fo:block>
										</fo:table-cell>
										<fo:table-cell>
											<fo:block>Participant4</fo:block>
										</fo:table-cell>
										<fo:table-cell>
											<fo:block>Participant7</fo:block>
										</fo:table-cell>
									</fo:table-row>
									<fo:table-row>
										<fo:table-cell>
											<fo:block>Participant2</fo:block>
										</fo:table-cell>
										<fo:table-cell>
											<fo:block>Participant5</fo:block>
										</fo:table-cell>
										<fo:table-cell>
											<fo:block>Participant8</fo:block>
										</fo:table-cell>
									</fo:table-row>
									<fo:table-row>
										<fo:table-cell>
											<fo:block>Participant3</fo:block>
										</fo:table-cell>
										<fo:table-cell>
											<fo:block>Participant6</fo:block>
										</fo:table-cell>
										<fo:table-cell>
											<fo:block>Participant9</fo:block>
										</fo:table-cell>
									</fo:table-row>
								</fo:table-body>
							</fo:table>
							
							<fo:block margin-bottom="12pt">&#xa0;</fo:block>
							
							<fo:block margin-bottom="12pt">The following members of the &lt;individual/entity&gt; Standards Association balloting group voted on this <xsl:value-of select="$opt_trial_use"/><xsl:value-of select="$doctype"/>. Balloters may have voted for approval, disapproval, or abstention.</fo:block>
							
							<fo:block margin-bottom="12pt" font-weight="bold" font-style="italic">[To be supplied by IEEE]</fo:block>
							
							<fo:table width="100%" table-layout="fixed" font-size="9pt">
								<fo:table-body>
									<fo:table-row>
										<fo:table-cell>
											<fo:block>Balloter1</fo:block>
										</fo:table-cell>
										<fo:table-cell>
											<fo:block>Balloter4</fo:block>
										</fo:table-cell>
										<fo:table-cell>
											<fo:block>Balloter7</fo:block>
										</fo:table-cell>
									</fo:table-row>
									<fo:table-row>
										<fo:table-cell>
											<fo:block>Balloter2</fo:block>
										</fo:table-cell>
										<fo:table-cell>
											<fo:block>Balloter5</fo:block>
										</fo:table-cell>
										<fo:table-cell>
											<fo:block>Balloter8</fo:block>
										</fo:table-cell>
									</fo:table-row>
									<fo:table-row>
										<fo:table-cell>
											<fo:block>Balloter3</fo:block>
										</fo:table-cell>
										<fo:table-cell>
											<fo:block>Balloter6</fo:block>
										</fo:table-cell>
										<fo:table-cell>
											<fo:block>Balloter9</fo:block>
										</fo:table-cell>
									</fo:table-row>
								</fo:table-body>
							</fo:table>
							
							<fo:block margin-bottom="12pt">&#xa0;</fo:block>
							
							<fo:block margin-bottom="12pt">When the IEEE SA Standards Board approved this <xsl:value-of select="$opt_trial_use"/><xsl:value-of select="$doctype"/> on &lt;Date Approved&gt;, it had the following membership:</fo:block>
							
							<fo:block margin-bottom="12pt" font-weight="bold" font-style="italic">[To be supplied by IEEE]</fo:block>
							
							<fo:block text-align="center">
								<fo:block>
									<fo:inline font-weight="bold">&lt;Name&gt;</fo:inline>, <fo:inline font-style="italic">Chair</fo:inline>
								</fo:block>
								<fo:block>
									<fo:inline font-weight="bold">&lt;Name&gt;</fo:inline>, <fo:inline font-style="italic">Vice Chair</fo:inline>
								</fo:block>
								<fo:block>
									<fo:inline font-weight="bold">&lt;Name&gt;</fo:inline>, <fo:inline font-style="italic">Past Chair</fo:inline>
								</fo:block>
								<fo:block>
									<fo:inline font-weight="bold">Konstantinos Karachalios</fo:inline>, <fo:inline font-style="italic">Secretary</fo:inline>
								</fo:block>
							</fo:block>
							
							<fo:table width="100%" table-layout="fixed" font-size="9pt">
								<fo:table-body>
									<fo:table-row>
										<fo:table-cell>
											<fo:block>SBMember1</fo:block>
										</fo:table-cell>
										<fo:table-cell>
											<fo:block>SBMember4</fo:block>
										</fo:table-cell>
										<fo:table-cell>
											<fo:block>SBMember7</fo:block>
										</fo:table-cell>
									</fo:table-row>
									<fo:table-row>
										<fo:table-cell>
											<fo:block>SBMember2</fo:block>
										</fo:table-cell>
										<fo:table-cell>
											<fo:block>SBMember5</fo:block>
										</fo:table-cell>
										<fo:table-cell>
											<fo:block>SBMember8</fo:block>
										</fo:table-cell>
									</fo:table-row>
									<fo:table-row>
										<fo:table-cell>
											<fo:block>SBMember3</fo:block>
										</fo:table-cell>
										<fo:table-cell>
											<fo:block>SBMember6</fo:block>
										</fo:table-cell>
										<fo:table-cell>
											<fo:block>SBMember9</fo:block>
										</fo:table-cell>
									</fo:table-row>
								</fo:table-body>
							</fo:table>
							
							<fo:block margin-left="9.4mm">*Member Emeritus</fo:block>
							
							<fo:block break-after="page"/>
							
							
							
						</fo:flow>
					
					</fo:page-sequence>
						
				
					<!-- ================================ -->
					<!-- PREFACE pages (Introduction, Contents -->
					<!-- ================================ -->
					<xsl:variable name="structured_xml_preface">
						<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name() = 'introduction']" mode="flatxml" />
					</xsl:variable>
					
					<!-- structured_xml_preface=<xsl:copy-of select="$structured_xml_preface"/> -->
					
					<xsl:variable name="paged_xml_preface">
						<xsl:call-template name="makePagedXML">
							<xsl:with-param name="structured_xml" select="$structured_xml_preface"/>
						</xsl:call-template>
					</xsl:variable>
					
					<xsl:if test="$debug = 'true'">
						<xsl:text disable-output-escaping="yes">&lt;!--</xsl:text>
							DEBUG
							contents=<xsl:copy-of select="$contents"/>
						<xsl:text disable-output-escaping="yes">--&gt;</xsl:text>
					</xsl:if>
					
					
					<!-- ===================== -->
					<!-- IEEE Contents and Preface pages-->
					<!-- ===================== -->
					<fo:page-sequence master-reference="document" id="prefaceSequence"> <!-- format="i" initial-page-number="1" -->
						
						<xsl:call-template name="insertFootnoteSeparator"/>
						
						<xsl:call-template name="insertHeaderFooter">
							<xsl:with-param name="designation" select="$designation"/>
							<xsl:with-param name="draft_number" select="$draft_number"/>
							<xsl:with-param name="draft_month" select="$draft_month"/>
							<xsl:with-param name="draft_year" select="$draft_year"/>
							<xsl:with-param name="opt_trial_use" select="$opt_trial_use"/>
							<xsl:with-param name="doctype" select="$doctype"/>
							<xsl:with-param name="title" select="$title"/>
							<xsl:with-param name="copyright_year" select="$copyright_year"/>
							<xsl:with-param name="copyright_holder" select="$copyright_holder"/>
						</xsl:call-template>
						
						<fo:flow flow-name="xsl-region-body">
							
							<fo:block>
								<xsl:for-each select="xalan:nodeset($paged_xml_preface)/*[local-name()='page']">
									<fo:block break-after="page"/>
									<xsl:apply-templates select="*" mode="page"/>
								</xsl:for-each>
							</fo:block>
								
							<fo:block text-align-last="justify" font-weight="bold" margin-top="4.5mm" margin-bottom="3.5mm">
								<fo:inline font-family="Arial" font-size="18pt" role="H1">
									<!-- Contents -->
									<xsl:call-template name="getLocalizedString">
										<xsl:with-param name="key">table_of_contents</xsl:with-param>
									</xsl:call-template>
								</fo:inline>
								<fo:inline keep-together.within-line="always">
									<fo:leader leader-pattern="space"/>
									<fo:inline>
										<!-- Page -->
										<xsl:call-template name="getLocalizedString">
										<xsl:with-param name="key">locality.page</xsl:with-param>
									</xsl:call-template>
									</fo:inline>
								</fo:inline>
							</fo:block>
						
							<fo:block role="TOC">
								<xsl:if test="$contents/doc[@num = $num]//item[@display = 'true']">
									
									<xsl:variable name="margin-left">12</xsl:variable>
									
									<xsl:for-each select="$contents/doc[@num = $num]//item[@display = 'true']">
											
										<fo:block role="TOCI">
											<xsl:if test="@level = 1">
												<xsl:attribute name="margin-top">5pt</xsl:attribute>
											</xsl:if>
											<xsl:if test="@level = 3">
												<xsl:attribute name="margin-top">-0.7pt</xsl:attribute>
											</xsl:if>
											<fo:list-block>
												<xsl:attribute name="margin-left"><xsl:value-of select="$margin-left * (@level - 1)"/>mm</xsl:attribute>
												<xsl:if test="@level &gt;= 2 or @type = 'annex'">
													<xsl:attribute name="font-weight">normal</xsl:attribute>
												</xsl:if>
												<xsl:attribute name="provisional-distance-between-starts">
													<xsl:choose>
														<!-- skip 0 section without subsections -->
														<xsl:when test="@level &gt;= 3"><xsl:value-of select="$margin-left * 1.2"/>mm</xsl:when>
														<xsl:when test="@section != ''"><xsl:value-of select="$margin-left"/>mm</xsl:when>
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
																	<fo:leader font-size="9pt" font-weight="normal" leader-pattern="dots"/>
																	<fo:inline>
																		<xsl:if test="@level = 1 and @type = 'annex'">
																			<xsl:attribute name="font-weight">bold</xsl:attribute>
																		</xsl:if>
																		<fo:page-number-citation ref-id="{@id}"/>
																	</fo:inline>
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
							
						</fo:flow>
					</fo:page-sequence>
					
					<!-- ===================== -->
					<!-- END IEEE Contents and Preface pages-->
					<!-- ===================== -->
						
				
					
					<!-- ================================ -->
					<!-- END: PREFACE pages (Table of Contents, Foreword -->
					<!-- ================================ -->


				<xsl:if test="1 = 1">
					
					<!-- item - page sequence -->
					<xsl:variable name="structured_xml_">
						
						<item>
							<xsl:apply-templates select="/*/*[local-name()='sections']/*" mode="flatxml"/>
						</item>	
						
						<!-- Annexes -->
						<item>
							<xsl:apply-templates select="/*/*[local-name()='annex']" mode="flatxml"/>
						</item>
						
						<!-- Bibliography -->
						<xsl:for-each select="/*/*[local-name()='bibliography']/*">
							<item><xsl:apply-templates select="." mode="flatxml"/></item>
						</xsl:for-each>
						
						<item>
							<xsl:copy-of select="//ieee:indexsect" />
						</item>
						
					</xsl:variable>
					
					<!-- page break before each section -->
					<xsl:variable name="structured_xml">
						<xsl:for-each select="xalan:nodeset($structured_xml_)/item[*]">
							<xsl:element name="pagebreak" namespace="https://www.metanorma.org/ns/ieee"/>
							<xsl:copy-of select="./*"/>
						</xsl:for-each>
					</xsl:variable>
					
					<!-- structured_xml=<xsl:copy-of select="$structured_xml" />=end structured_xml -->
					
					<xsl:variable name="paged_xml">
						<xsl:call-template name="makePagedXML">
							<xsl:with-param name="structured_xml" select="$structured_xml"/>
						</xsl:call-template>
					</xsl:variable>
					
					<!-- paged_xml=<xsl:copy-of select="$paged_xml"/> -->
					
					<xsl:for-each select="xalan:nodeset($paged_xml)/*[local-name()='page'][*]">
						<fo:page-sequence master-reference="document" format="1" force-page-count="no-force">
							<xsl:if test="@orientation = 'landscape'">
								<xsl:attribute name="master-reference">document-<xsl:value-of select="@orientation"/></xsl:attribute>
							</xsl:if>
							<xsl:if test="position() = 1">
								<xsl:attribute name="initial-page-number">1</xsl:attribute>
							</xsl:if>
							<xsl:if test=".//ieee:indexsect">
								<xsl:attribute name="master-reference">page-index</xsl:attribute>
							</xsl:if>
							
							<xsl:call-template name="insertFootnoteSeparator"/>
							
							<xsl:call-template name="insertHeaderFooter">
								<xsl:with-param name="designation" select="$designation"/>
								<xsl:with-param name="draft_number" select="$draft_number"/>
								<xsl:with-param name="draft_month" select="$draft_month"/>
								<xsl:with-param name="draft_year" select="$draft_year"/>
								<xsl:with-param name="opt_trial_use" select="$opt_trial_use"/>
								<xsl:with-param name="doctype" select="$doctype"/>
								<xsl:with-param name="title" select="$title"/>
								<xsl:with-param name="copyright_year" select="$copyright_year"/>
								<xsl:with-param name="copyright_holder" select="$copyright_holder"/>
								<xsl:with-param name="orientation">@orientation</xsl:with-param>
							</xsl:call-template>

							<fo:flow flow-name="xsl-region-body">
								<!-- debugpage=<xsl:copy-of select="."/> -->
								<xsl:apply-templates select="*" mode="page"/>
								<xsl:if test="position() = last()"><fo:block id="lastBlockMain"/></xsl:if>
							</fo:flow>
						</fo:page-sequence>
					</xsl:for-each>
			</xsl:if>
					<!-- ===================== -->
					<!-- End IEEE pages -->
					<!-- ===================== -->
						
				
				</xsl:for-each>
			</xsl:for-each> <!-- END of //ieee-standard iteration -->
			
			<xsl:if test="not(//ieee:ieee-standard)">
				<fo:page-sequence master-reference="document" force-page-count="no-force">
					<fo:flow flow-name="xsl-region-body">
						<fo:block><!-- prevent fop error for empty document --></fo:block>
					</fo:flow>
				</fo:page-sequence>
			</xsl:if>
			
		</fo:root>
	</xsl:template>

	

	<xsl:template match="*[local-name() = 'br']" priority="2" mode="contents_item">
		<xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="*[local-name() = 'strong']" priority="2" mode="contents_item">
		<xsl:copy>
			<xsl:apply-templates mode="contents_item"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template name="makePagedXML">
		<xsl:param name="structured_xml"/>
		<xsl:choose>
			<xsl:when test="not(xalan:nodeset($structured_xml)/*[local-name()='pagebreak'])">
				<xsl:element name="page" namespace="https://www.metanorma.org/ns/ieee">
					<xsl:copy-of select="xalan:nodeset($structured_xml)"/>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="xalan:nodeset($structured_xml)/*[local-name()='pagebreak']">
			
					<xsl:variable name="pagebreak_id" select="generate-id()"/>
					<!-- <xsl:variable name="pagebreak_previous_orientation" select="normalize-space(preceding-sibling::ieee:pagebreak[1]/@orientation)"/> -->
					
					<!-- copy elements before pagebreak -->
					<xsl:element name="page" namespace="https://www.metanorma.org/ns/ieee">
						<xsl:if test="not(preceding-sibling::ieee:pagebreak)">
							<xsl:copy-of select="../@*" />
						</xsl:if>
						<!-- copy previous pagebreak orientation -->
						<xsl:copy-of select="preceding-sibling::ieee:pagebreak[1]/@orientation"/>
						<!-- <xsl:if test="$pagebreak_previous_orientation != ''">
							<xsl:attribute name="orientation"><xsl:value-of select="$pagebreak_previous_orientation"/></xsl:attribute>
						</xsl:if> -->
						<xsl:copy-of select="preceding-sibling::node()[following-sibling::ieee:pagebreak[1][generate-id(.) = $pagebreak_id]][not(local-name() = 'pagebreak')]" />
					</xsl:element>
					
					<!-- copy elements after last page break -->
					<xsl:if test="position() = last() and following-sibling::node()">
						<xsl:element name="page" namespace="https://www.metanorma.org/ns/ieee">
							<xsl:copy-of select="@orientation" />
							<xsl:copy-of select="following-sibling::node()" />
						</xsl:element>
					</xsl:if>
	
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="node()">		
		<xsl:apply-templates />			
	</xsl:template>


	<!-- ============================= -->
	<!-- CONTENTS                      -->
	<!-- ============================= -->
	
	<!-- element with title -->
	<xsl:template match="*[ieee:title]" mode="contents">
	
		<xsl:variable name="level">
			<xsl:call-template name="getLevel">
				<xsl:with-param name="depth" select="ieee:title/@depth"/>
			</xsl:call-template>
		</xsl:variable>
		
		<!-- if previous clause contains section-title as latest element (section-title may contain  note's, admonition's, etc.),
		and if @depth of current clause equals to section-title @depth,
		then put section-title before current clause -->
		<xsl:if test="local-name() = 'clause'">
			<xsl:apply-templates select="preceding-sibling::*[1][local-name() = 'clause']//*[local-name() = 'p' and @type = 'section-title'
				and @depth = $level 
				and not(following-sibling::*[local-name()='clause'])]" mode="contents_in_clause"/>
		</xsl:if>
		
		<xsl:variable name="section">
			<xsl:call-template name="getSection"/>
		</xsl:variable>
		
		<xsl:variable name="type">
			<xsl:choose>
				<xsl:when test="local-name() = 'indexsect'">index</xsl:when>
				<xsl:when test="(ancestor-or-self::ieee:bibliography and local-name() = 'clause' and not(.//*[local-name() = 'references' and @normative='true'])) or self::ieee:references[not(@normative) or @normative='false']">bibliography</xsl:when>
				<xsl:otherwise><xsl:value-of select="local-name()"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
			
		<xsl:variable name="display">
			<xsl:choose>
				<xsl:when test="normalize-space(@id) = ''">false</xsl:when>
				
				<xsl:when test="ancestor-or-self::ieee:annex and $level &gt;= 2">false</xsl:when>
				<xsl:when test="$type = 'bibliography' and $level &gt;= 2">false</xsl:when>
				<xsl:when test="$type = 'bibliography'">true</xsl:when>
				<xsl:when test="$type = 'references' and $level &gt;= 2">false</xsl:when>
				<xsl:when test="$section = '' and $type = 'clause' and $level = 1 and ancestor::ieee:preface">true</xsl:when>
				<xsl:when test="$section = '' and $type = 'clause'">false</xsl:when>
				<xsl:when test="$level &lt;= $toc_level">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="skip">
			<xsl:choose>
				<xsl:when test="ancestor-or-self::ieee:bibitem">true</xsl:when>
				<xsl:when test="ancestor-or-self::ieee:term">true</xsl:when>				
				<xsl:when test="@type = 'corrigenda'">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		
		<xsl:if test="$skip = 'false'">		
		
			<xsl:variable name="title">
				<xsl:call-template name="getName"/>
			</xsl:variable>
			
			<xsl:variable name="root">
				<xsl:if test="ancestor-or-self::ieee:preface">preface</xsl:if>
				<xsl:if test="ancestor-or-self::ieee:annex">annex</xsl:if>
			</xsl:variable>
			
			<item id="{@id}" level="{$level}" section="{$section}" type="{$type}" root="{$root}" display="{$display}">
				<xsl:if test="$type = 'index'">
					<xsl:attribute name="level">1</xsl:attribute>
				</xsl:if>
				<title>
					<xsl:apply-templates select="xalan:nodeset($title)" mode="contents_item">
						<xsl:with-param name="mode">contents</xsl:with-param>
					</xsl:apply-templates>
				</title>
				<xsl:if test="$type != 'index'">
					<xsl:apply-templates  mode="contents" />
				</xsl:if>
			</item>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="ieee:figure[ieee:name] | ieee:table[ieee:name and not(@unnumbered = 'true' and java:endsWith(java:java.lang.String.new(ieee:name),'Key'))]" priority="2" mode="contents">		
		<xsl:variable name="level">
			<xsl:for-each select="ancestor::ieee:clause[1] | ancestor::ieee:annex[1]">
				<xsl:call-template name="getLevel">
					<xsl:with-param name="depth" select="ieee:title/@depth"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:variable>
		<item id="{@id}" level="{$level}" section="" type="{local-name()}" root="" display="true">
			<xsl:variable name="name">
				<xsl:apply-templates select="ieee:name" mode="contents_item">
					<xsl:with-param name="mode">contents</xsl:with-param>
				</xsl:apply-templates>
			</xsl:variable>
			<xsl:if test="not(contains(normalize-space($name), '—'))">
				<xsl:attribute name="display">false</xsl:attribute>
			</xsl:if>
			<title>
				<xsl:copy-of select="$name"/>
			</title>
		</item>
	</xsl:template>

	<xsl:template match="*[local-name()='add'][parent::*[local-name() = 'name'] and ancestor::*[local-name() = 'figure'] and normalize-space(following-sibling::node()) = '']" mode="contents_item" priority="2"/>

	<xsl:template match="text()" mode="contents_item">
		<xsl:choose>
			<xsl:when test="contains(., $non_breaking_hyphen)">
				<xsl:call-template name="replaceChar">
					<xsl:with-param name="text" select="."/>
					<xsl:with-param name="replace" select="$non_breaking_hyphen"/>
					<xsl:with-param name="by" select="'-'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	
	<xsl:template name="insertListOf_Title">
		<xsl:param name="title"/>
		<fo:block role="TOCI" margin-top="5pt" keep-with-next="always">
			<xsl:value-of select="$title"/>
		</fo:block>
	</xsl:template>
	
	<xsl:template name="insertListOf_Item">
		<fo:block role="TOCI" font-weight="normal" text-align-last="justify" margin-left="12mm">
			<fo:basic-link internal-destination="{@id}">
				<xsl:call-template name="setAltText">
					<xsl:with-param name="value" select="@alt-text"/>
				</xsl:call-template>
				<xsl:apply-templates select="." mode="contents"/>
				<fo:inline keep-together.within-line="always">
					<fo:leader font-size="9pt" font-weight="normal" leader-pattern="dots"/>
					<fo:inline><fo:page-number-citation ref-id="{@id}"/></fo:inline>
				</fo:inline>
			</fo:basic-link>
		</fo:block>
	</xsl:template>
	
	<!-- ============================= -->
	<!-- ============================= -->
	
	<!-- ================================= -->
	<!-- XML Flattening -->
	<!-- ================================= -->
	<xsl:template match="@*|node()" mode="flatxml">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="flatxml"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="processing-instruction()" mode="flatxml">
		<xsl:copy-of select="."/>
	</xsl:template>
	
	<xsl:template match="ieee:preface//ieee:clause[@type = 'front_notes']" mode="flatxml" priority="2">
		<!-- ignore processing (source STS is front/notes) -->
	</xsl:template>
	
	<xsl:template match="ieee:foreword |
											ieee:foreword//ieee:clause |
											ieee:preface//ieee:clause[not(@type = 'corrigenda') and not(@type = 'related-refs')] |
											ieee:introduction |
											ieee:introduction//ieee:clause |
											ieee:sections//ieee:clause | 
											ieee:annex | 
											ieee:annex//ieee:clause | 
											ieee:references |
											ieee:bibliography/ieee:clause | 
											*[local-name()='sections']//*[local-name()='terms'] | 
											*[local-name()='sections']//*[local-name()='definitions'] |
											*[local-name()='annex']//*[local-name()='definitions']" mode="flatxml" name="clause">
		<!-- From:
		<clause>
			<title>...</title>
			<p>...</p>
		</clause>
		To:
			<clause/>
			<title>...</title>
			<p>...</p>
		-->
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="flatxml"/>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:if test="local-name() = 'foreword' or local-name() = 'introduction' or
			local-name(..) = 'preface' or local-name(..) = 'sections' or 
			(local-name() = 'references' and parent::*[local-name() = 'bibliography']) or
			(local-name() = 'clause' and parent::*[local-name() = 'bibliography']) or
			local-name() = 'annex' or 
			local-name(..) = 'annex'">
				<xsl:attribute name="mainsection">true</xsl:attribute>
			</xsl:if>
			
		</xsl:copy>
		<xsl:apply-templates mode="flatxml"/>
		
	</xsl:template>
	
	<xsl:template match="ieee:term" mode="flatxml" priority="2">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="flatxml"/>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:variable name="level">
				<xsl:call-template name="getLevel"/>
			</xsl:variable>
			<xsl:attribute name="depth"><xsl:value-of select="$level"/></xsl:attribute>
			<xsl:attribute name="ancestor">sections</xsl:attribute>
			<xsl:apply-templates select="node()[not(self::ieee:term)]" mode="flatxml"/>
		</xsl:copy>
		<xsl:apply-templates select="ieee:term" mode="flatxml"/>
	</xsl:template>
	
	<xsl:template match="ieee:introduction//ieee:title | ieee:foreword//ieee:title | ieee:sections//ieee:title | ieee:annex//ieee:title | ieee:bibliography/ieee:clause/ieee:title | ieee:references/ieee:title" mode="flatxml" priority="2"> <!-- | ieee:term -->
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="flatxml"/>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:variable name="level">
				<xsl:call-template name="getLevel"/>
			</xsl:variable>
			<xsl:attribute name="depth"><xsl:value-of select="$level"/></xsl:attribute>
			<xsl:if test="parent::ieee:annex">
				<xsl:attribute name="depth">1</xsl:attribute>
			</xsl:if>
			<xsl:if test="../@inline-header = 'true'">
				<xsl:copy-of select="../@inline-header"/>
			</xsl:if>
			<xsl:attribute name="ancestor">
				<xsl:choose>
					<xsl:when test="ancestor::ieee:foreword">foreword</xsl:when>
					<xsl:when test="ancestor::ieee:introduction">introduction</xsl:when>
					<xsl:when test="ancestor::ieee:sections">sections</xsl:when>
					<xsl:when test="ancestor::ieee:annex">annex</xsl:when>
					<xsl:when test="ancestor::ieee:bibliography">bibliography</xsl:when>
				</xsl:choose>
			</xsl:attribute>
			
			<xsl:apply-templates mode="flatxml"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- recalculate table width -->
	<!-- 210 - (15+22+20) = 153 -->
	<xsl:variable name="max_table_width_mm" select="$pageWidth - ($marginLeftRight1 + $marginLeftRight2)"/> 
	<!-- 153 / 25.4 * 96 dpi = 578px-->
	<xsl:variable name="max_table_width_px" select="round($max_table_width_mm div 25.4 * 96)"/> 
	<!-- landscape table -->
	<xsl:variable name="max_table_landscape_width_mm" select="$pageHeight - ($marginTop + $marginBottom)"/> 
	<xsl:variable name="max_table_landscape_width_px" select="round($max_table_landscape_width_mm div 25.4 * 96)"/> 
	
	<xsl:template match="ieee:table/@width[contains(., 'px')]" mode="flatxml">
		<xsl:variable name="width" select="number(substring-before(., 'px'))"/>
		<xsl:variable name="isLandscapeTable" select="../preceding-sibling::*[local-name() != 'table'][1]/@orientation = 'landscape'"/>
		<xsl:attribute name="width">
			<xsl:choose>
				<xsl:when test="normalize-space($isLandscapeTable) = 'true' and $width &gt; $max_table_landscape_width_px"><xsl:value-of select="$max_table_landscape_width_px"/>px</xsl:when>
				<xsl:when test="normalize-space($isLandscapeTable) = 'false' and $width &gt; $max_table_width_px"><xsl:value-of select="$max_table_width_px"/>px</xsl:when>
				<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:template>
	
	<!-- add @to = figure, table, clause -->
	<!-- add @depth = from  -->
	<xsl:template match="ieee:xref" mode="flatxml">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="flatxml"/>
			<xsl:variable name="target" select="@target"/>
			<xsl:attribute name="to">
				<xsl:value-of select="local-name(//*[@id = current()/@target][1])"/>
			</xsl:attribute>
			<xsl:attribute name="depth">
				<xsl:value-of select="//*[@id = current()/@target][1]/ieee:title/@depth"/>
			</xsl:attribute>
			<xsl:apply-templates select="node()" mode="flatxml"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="text()" mode="flatxml">
		<xsl:choose>
			<xsl:when test="contains(., $non_breaking_hyphen)">
				<xsl:call-template name="replaceChar">
					<xsl:with-param name="text" select="."/>
					<xsl:with-param name="replace" select="$non_breaking_hyphen"/>
					<xsl:with-param name="by" select="'-'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
	
	<!-- remove newlines chars (0xd 0xa, 0xa, 0xd) in p, em, strong (except in sourcecode). -->
	<xsl:template match="*[not(ancestor::ieee:sourcecode)]/*[self::ieee:p or self::ieee:strong or self::ieee:em]/text()" mode="flatxml">
		<xsl:choose>
			<xsl:when test=". = '&#x0d;' or . = '&#x0a;' or . = '&#x0d;&#x0a;'"></xsl:when>
			<xsl:when test="contains(., $non_breaking_hyphen)">
				<xsl:call-template name="replaceChar">
					<xsl:with-param name="text" select="."/>
					<xsl:with-param name="replace" select="$non_breaking_hyphen"/>
					<xsl:with-param name="by" select="'-'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- change @reference to actual value, and add skip_footnote_body="true" for repeatable (2nd, 3rd, ...) -->
	<!--
	<fn reference="1">
			<p id="_8e5cf917-f75a-4a49-b0aa-1714cb6cf954">Formerly denoted as 15 % (m/m).</p>
		</fn>
	-->
	
	<xsl:template match="*[local-name() = 'fn'][not(ancestor::*[(local-name() = 'table' or local-name() = 'figure') and not(ancestor::*[local-name() = 'name'])])]" mode="flatxml">
		<xsl:variable name="p_fn_">
			<xsl:call-template name="get_fn_list"/>
		</xsl:variable>
		<xsl:variable name="p_fn" select="xalan:nodeset($p_fn_)"/>
		<xsl:variable name="gen_id" select="generate-id(.)"/>
		<xsl:variable name="lang" select="ancestor::*[contains(local-name(), '-standard')]/*[local-name()='bibdata']//*[local-name()='language'][@current = 'true']"/>
		<xsl:variable name="reference" select="@reference"/>
		<!-- fn sequence number in document -->
		<xsl:variable name="current_fn_number" select="count($p_fn//fn[@reference = $reference]/preceding-sibling::fn) + 1" />
		
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="flatxml"/>
			<!-- put actual reference number -->
			<xsl:attribute name="current_fn_number">
				<xsl:value-of select="$current_fn_number"/>
			</xsl:attribute>
			<xsl:attribute name="skip_footnote_body"> <!-- false for repeatable footnote -->
				<xsl:value-of select="not($p_fn//fn[@gen_id = $gen_id] and (1 = 1))"/>
			</xsl:attribute>
			<xsl:apply-templates select="node()" mode="flatxml"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[local-name() = 'bibitem']/*[local-name() = 'note']" mode="flatxml">
		<xsl:variable name="p_fn_">
			<xsl:call-template name="get_fn_list"/>
		</xsl:variable>
		<xsl:variable name="p_fn" select="xalan:nodeset($p_fn_)"/>
		<xsl:variable name="gen_id" select="generate-id(.)"/>
		<xsl:variable name="lang" select="ancestor::*[contains(local-name(), '-standard')]/*[local-name()='bibdata']//*[local-name()='language'][@current = 'true']"/>
		<xsl:variable name="reference" select="@reference"/> <!-- @reference added to bibitem/note in step 'update_xml_step2' -->
		<!-- fn sequence number in document -->
		<xsl:variable name="current_fn_number" select="count($p_fn//fn[@reference = $reference]/preceding-sibling::fn) + 1" />
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="flatxml"/>
			<!-- put actual reference number -->
			<xsl:attribute name="current_fn_number">
				<xsl:value-of select="$current_fn_number"/>
			</xsl:attribute>
			<xsl:apply-templates select="node()" mode="flatxml"/>
		</xsl:copy>
	</xsl:template>
	
	
	<xsl:template match="ieee:p[@type = 'section-title']" priority="3" mode="flatxml">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="flatxml"/>
			<xsl:if test="@depth = '1'">
				<xsl:attribute name="mainsection">true</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates select="node()" mode="flatxml"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- ================================= -->
	<!-- END of XML Flattening -->
	<!-- ================================= -->
	
	
	<xsl:template match="*" priority="3" mode="page">
		<xsl:call-template name="elementProcessing"/>
	</xsl:template>
	
	<xsl:template match="ieee:clauses_union/*" priority="3" mode="clauses_union">
		<xsl:call-template name="elementProcessing"/>
	</xsl:template>
	
	<xsl:template name="elementProcessing">
		<xsl:choose>
			<xsl:when test="local-name() = 'p' and count(node()) = count(processing-instruction())"><!-- skip --></xsl:when> <!-- empty paragraph with processing-instruction -->
			<xsl:when test="@hidden = 'true'"><!-- skip --></xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="local-name() = 'title' or local-name() = 'term'">
						<xsl:apply-templates select="."/>
					</xsl:when>
					<!-- <xsl:when test="not(node()) and @mainsection = 'true'"> -->
					<xsl:when test="@mainsection = 'true'">
						<fo:block>
							<xsl:attribute name="keep-with-next">always</xsl:attribute>
							<xsl:apply-templates select="."/>
						</fo:block>
					</xsl:when>
					<xsl:when test="local-name() = 'indexsect'">
						<xsl:apply-templates select="." mode="index"/>
					</xsl:when>
					<xsl:otherwise>
							<fo:block-container>
								<xsl:if test="not(node())">
									<xsl:attribute name="keep-with-next">always</xsl:attribute>
								</xsl:if>
								<fo:block>
									<xsl:apply-templates select="."/>
								</fo:block>
							</fo:block-container>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	

	<xsl:template match="/*/ieee:bibdata/ieee:docidentifier[@type = 'ISBN']">
		<fo:block space-after="6pt">
			<fo:inline>
				<xsl:attribute name="font-weight">bold</xsl:attribute>
				<xsl:text>ISBN </xsl:text>
			</fo:inline>
			<xsl:value-of select="."/>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="/*/ieee:bibdata/ieee:docidentifier[@type = 'ISBN']" mode="barcode">
		<fo:block text-align="center" font-weight="300">
			<fo:block font-size="6.5pt">ISBN <xsl:value-of select="translate(., ' ', '-')"/></fo:block>
			<xsl:variable name="code" select="translate(., ' ', '')"/>
			<fo:block>
				<fo:instream-foreign-object fox:alt-text="Barcode">
						<barcode:barcode
									xmlns:barcode="http://barcode4j.krysalis.org/ns"
									message="{$code}">
							<barcode:ean-13>
								<barcode:height>26mm</barcode:height>
								<barcode:module-width>0.34mm</barcode:module-width>
								<barcode:human-readable>
									<barcode:placement>bottom</barcode:placement>
								</barcode:human-readable>
							</barcode:ean-13>
						</barcode:barcode>
					</fo:instream-foreign-object>
			</fo:block>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="/*/ieee:bibdata/ieee:ext/ieee:ics" />
	<xsl:template match="/*/ieee:bibdata/ieee:ext/ieee:ics[1]" priority="2">
		<fo:block space-after="6pt">
			<fo:inline>
				<xsl:attribute name="font-weight">bold</xsl:attribute>
				<xsl:text>ICS </xsl:text>
			</fo:inline>
			<xsl:for-each select="../ieee:ics">
				<xsl:sort select="ieee:code" />
				<xsl:value-of select="ieee:code"/>
				<xsl:if test="position() != last()">; </xsl:if>
			</xsl:for-each>
		</fo:block>
	</xsl:template>
	
	
	
	<xsl:template match="ieee:copyright-statement/ieee:clause[1]/ieee:title" priority="3">
		<fo:block font-weight="bold" space-after="6pt" role="H1">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	
	<xsl:template match="ieee:preface/ieee:clause[@type = 'related-refs']" priority="3">
		<fo:block><xsl:apply-templates /></fo:block>
	</xsl:template>

	<xsl:template match="ieee:preface/ieee:clause[@type = 'corrigenda']" priority="3">
		<fo:block-container width="60%" space-before="12pt">
			<fo:block><xsl:apply-templates /></fo:block>
		</fo:block-container>
	</xsl:template>

	<xsl:template match="ieee:preface/ieee:clause[@type = 'corrigenda']/ieee:title" priority="3">
		<fo:block font-weight="bold" space-after="6pt" role="H1">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>

	<xsl:template match="ieee:feedback-statement/ieee:clause" priority="3">
		<fo:block space-after="8pt">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="ieee:feedback-statement/ieee:clause/ieee:clause" priority="3">
		<fo:block>
			<xsl:apply-templates />
		</fo:block>
		<xsl:if test="following-sibling::*">
			<fo:block>&#xa0;</fo:block>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="ieee:feedback-statement/ieee:clause/ieee:title" priority="3">
		<fo:block font-size="10pt" font-weight="bold" space-after="2pt" keep-with-next="always" role="H1">
			<xsl:if test="not(../following-sibling::*)">
				<xsl:attribute name="font-size">9pt</xsl:attribute><!-- for address -->
			</xsl:if>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="ieee:feedback-statement/ieee:clause/ieee:clause/ieee:title" priority="3">
		<fo:block font-weight="bold" keep-with-next="always" role="H2"><xsl:apply-templates /></fo:block>
	</xsl:template>
	
	<xsl:template match="ieee:feedback-statement/ieee:clause/ieee:p" priority="3">
		<fo:block space-after="6pt">
			<xsl:if test="following-sibling::ieee:ul">
				<xsl:attribute name="space-after">4</xsl:attribute>
			</xsl:if>
			<!-- for address -->
			<xsl:if test="not(../following-sibling::*)">
				<xsl:attribute name="font-size">8pt</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="ieee:feedback-statement/ieee:clause/ieee:clause/ieee:p" priority="3">
		<fo:block>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="ieee:feedback-statement/ieee:clause/ieee:ul" priority="3">
		<fo:list-block space-after="6pt" provisional-distance-between-starts="4mm">
			<xsl:apply-templates />
		</fo:list-block>
	</xsl:template>
	
	<xsl:template match="ieee:feedback-statement/ieee:clause/ieee:ul/ieee:li" priority="3">
		<fo:list-item space-after="4pt">
			<fo:list-item-label end-indent="label-end()">
				<fo:block>•</fo:block>
			</fo:list-item-label>
			<fo:list-item-body start-indent="body-start()" >
				<fo:block><xsl:apply-templates /></fo:block>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>
	
	<xsl:template match="ieee:feedback-statement/ieee:clause" mode="back_header">
		<xsl:apply-templates mode="back_header"/>
	</xsl:template>
	
	<xsl:template match="ieee:feedback-statement/ieee:clause/ieee:title" mode="back_header">
		<fo:block margin-top="3.5mm" font-size="28pt" role="H1">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="ieee:feedback-statement/ieee:clause/ieee:p" mode="back_header">
		<fo:block font-size="15pt" space-before="2pt">
			<xsl:if test="preceding-sibling::ieee:p">
				<xsl:attribute name="space-before">6pt</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
					
	<xsl:template match="*[local-name() = 'introduction'] | *[local-name() = 'foreword']">
		<fo:block>
			<xsl:call-template name="setId"/>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>


	<!-- ====== -->
	<!-- title      -->
	<!-- ====== -->
	
	<!-- <xsl:template match="ieee:annex/ieee:title">
		<fo:block font-size="16pt" text-align="center" margin-bottom="48pt" keep-with-next="always">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template> -->
	
	<!-- Bibliography -->
	<xsl:template match="ieee:references[not(@normative='true')]/ieee:title">
		<fo:block font-size="16pt" font-weight="bold" text-align="center" margin-top="6pt" margin-bottom="36pt" keep-with-next="always" role="H1">
				<xsl:apply-templates />
			</fo:block>
	</xsl:template>
	
	
	<xsl:template match="ieee:title[@inline-header = 'true'][following-sibling::*[1][local-name() = 'p']]" priority="3">
		<xsl:call-template name="title"/>
	</xsl:template>
	
	<xsl:template match="ieee:clauses_union" priority="4">
		<fo:block-container margin-left="-1.5mm" margin-right="-0.5mm">
			<fo:block-container margin="0mm" padding-left="0.5mm" padding-top="0.1mm" padding-bottom="2.5mm">
				<xsl:apply-templates mode="clauses_union"/>
			</fo:block-container>
		</fo:block-container>
	</xsl:template>
	
	
	<xsl:template match="ieee:title" priority="2" name="title">
	
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		
		<xsl:variable name="font-size">
			<xsl:choose>
				<xsl:when test="@type = 'section-title'">12pt</xsl:when>
				<xsl:when test="$level = 1">12pt</xsl:when>
				<xsl:when test="$level = 2">11pt</xsl:when>
				<xsl:otherwise>10pt</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="font-weight">bold</xsl:variable>
		
		<xsl:variable name="margin-top">
			<xsl:choose>
				<xsl:when test="$level = 1">18pt</xsl:when>
				<xsl:when test="$level = 2">18pt</xsl:when>
				<xsl:when test="$level = 3">12pt</xsl:when>
				<xsl:otherwise>0mm</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="margin-bottom">
			<xsl:choose>
				<xsl:when test="$level = 1">12pt</xsl:when>
				<xsl:otherwise>12pt</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="element-name">
			<xsl:choose>
				<xsl:when test="@inline-header = 'true'">fo:inline</xsl:when>
				<xsl:otherwise>fo:block</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:element name="{$element-name}">
			<xsl:attribute name="font-family">Arial</xsl:attribute>
			<xsl:attribute name="font-size"><xsl:value-of select="$font-size"/></xsl:attribute>
			<xsl:attribute name="font-weight"><xsl:value-of select="$font-weight"/></xsl:attribute>
			<xsl:attribute name="space-before"><xsl:value-of select="$margin-top"/></xsl:attribute>
			<xsl:attribute name="margin-bottom"><xsl:value-of select="$margin-bottom"/></xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="keep-together.within-column">always</xsl:attribute>
			
			<xsl:attribute name="role">H<xsl:value-of select="$level"/></xsl:attribute>
			
			<xsl:if test="@type = 'floating-title' or @type = 'section-title'">
				<xsl:copy-of select="@id"/>
			</xsl:if>
			
			<!-- if first and last childs are `add` ace-tag, then move start ace-tag before title -->
			<xsl:if test="*[local-name() = 'tab'][1]/following-sibling::node()[last()][local-name() = 'add'][starts-with(text(), $ace_tag)]">
				<xsl:apply-templates select="*[local-name() = 'tab'][1]/following-sibling::node()[1][local-name() = 'add'][starts-with(text(), $ace_tag)]">
					<xsl:with-param name="skip">false</xsl:with-param>
				</xsl:apply-templates> 
			</xsl:if>
			
			<xsl:apply-templates />
			<xsl:apply-templates select="following-sibling::*[1][local-name() = 'variant-title'][@type = 'sub']" mode="subtitle"/>
		</xsl:element>
			
	</xsl:template>
	
	<!-- special case -->
	<xsl:variable name="annex_integral_part_text">(This annex forms an integral part of this </xsl:variable>
	<xsl:template match="ieee:title[@ancestor = 'annex']//text()[contains(., $annex_integral_part_text)]" priority="2">
		<xsl:value-of select="substring-before(., $annex_integral_part_text)"/>
		<fo:inline font-weight="normal">
			<xsl:value-of select="$annex_integral_part_text"/>
			<xsl:value-of select="substring-before(substring-after(., $annex_integral_part_text), ')')"/>
			<xsl:text>)</xsl:text>
		</fo:inline>
		<xsl:value-of select="substring-after(substring-after(., $annex_integral_part_text), ')')"/>
	</xsl:template>
	
	
	<xsl:template match="ieee:term" priority="2">
	
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		<!-- <fo:block>$level=<xsl:value-of select="$level"/></fo:block>
		<fo:block>@ancestor=<xsl:value-of select="@ancestor"/></fo:block> -->
		<xsl:variable name="font-size">
			<xsl:choose>
				<xsl:when test="@ancestor = 'sections' and $level = '2'">11pt</xsl:when>
				<xsl:when test="@ancestor = 'sections' and $level &gt; 2">11pt</xsl:when>
				<xsl:otherwise>11.5pt</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		
		<xsl:variable name="element-name">
			<xsl:choose>
				<xsl:when test="../@inline-header = 'true'">fo:inline</xsl:when>
				<xsl:otherwise>fo:block</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<fo:block margin-bottom="16pt">
			<xsl:if test="@ancestor = 'sections' and $level &gt; 2">
				<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			</xsl:if>
			<xsl:copy-of select="@id" />
			<fo:block font-size="{$font-size}" font-weight="bold" margin-bottom="6pt" keep-with-next="always" role="H{$level}">
					<xsl:if test="@ancestor = 'sections' and $level &gt; 2">
						<xsl:attribute name="margin-bottom">2pt</xsl:attribute>
					</xsl:if>
					<!-- term/name -->
					<xsl:apply-templates select="ieee:name" />
					<xsl:text> </xsl:text>
					<xsl:apply-templates select="ieee:preferred" />
					<xsl:for-each select="ieee:admitted">
						<xsl:if test="position() = 1"><xsl:text> (</xsl:text></xsl:if>
						<xsl:apply-templates />
						<xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if>
						<xsl:if test="position() = last()"><xsl:text>)</xsl:text></xsl:if>
					</xsl:for-each>
				</fo:block>
				<xsl:apply-templates select="*[not(self::ieee:preferred) and not(self::ieee:admitted) and not(self::ieee:name)]"/> <!-- further processing child elements -->
		</fo:block>
		
	</xsl:template>
	
	<xsl:template match="ieee:preferred" priority="2">
		<xsl:apply-templates />
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'term']/*[local-name() = 'definition']" priority="2">
		<fo:block xsl:use-attribute-sets="definition-style">
			<xsl:apply-templates />
		</fo:block>
		<!-- change termsource order - show after definition before termnote -->
		<xsl:for-each select="ancestor::ieee:term[1]/ieee:termsource">
			<xsl:call-template name="termsource"/>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="*[local-name() = 'term']/*[local-name() = 'termsource']" priority="2">
		<xsl:call-template name="termsource"/>
	</xsl:template>
	
	
	<xsl:template name="titleAmendment">
		<fo:block font-size="11pt" font-style="italic" margin-bottom="12pt" keep-with-next="always">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<!-- ====== -->
	<!-- ====== -->


	<xsl:template match="*[local-name() = 'annex']" priority="2">
		<fo:block id="{@id}">
		</fo:block>
		<xsl:apply-templates />
	</xsl:template>
	
	<xsl:template match="ieee:p" name="paragraph">
		<xsl:param name="inline-header">false</xsl:param>
		<xsl:param name="split_keep-within-line"/>
	
		<xsl:choose>
		
			<xsl:when test="preceding-sibling::*[1][self::ieee:title]/@inline-header = 'true' and $inline-header = 'false'"/> <!-- paragraph displayed in title template -->
			
			<xsl:otherwise>
			
				<xsl:variable name="previous-element" select="local-name(preceding-sibling::*[1])"/>
				<xsl:variable name="element-name">fo:block</xsl:variable>
					<!-- <xsl:choose>
						<xsl:when test="$inline = 'true'">fo:inline</xsl:when> -->
						<!-- <xsl:when test="preceding-sibling::*[1]/@inline-header = 'true' and $previous-element = 'title'">fo:inline</xsl:when> --> <!-- first paragraph after inline title -->
						<!-- <xsl:when test="local-name(..) = 'admonition'">fo:inline</xsl:when> -->
					<!-- 	<xsl:otherwise>fo:block</xsl:otherwise>
					</xsl:choose>
				</xsl:variable> -->
				<xsl:element name="{$element-name}">
					<xsl:call-template name="setTextAlignment"/>
					<xsl:attribute name="margin-bottom">6pt</xsl:attribute><!-- 8pt -->
					<xsl:if test="../following-sibling::*[1][self::ieee:note or self::ieee:termnote or self::ieee:ul or self::ieee:ol] or following-sibling::*[1][self::ieee:ul or self::ieee:ol]">
						<xsl:attribute name="margin-bottom">4pt</xsl:attribute>
					</xsl:if>
					<xsl:if test="parent::ieee:li">
						<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
						<xsl:if test="ancestor::ieee:feedback-statement">
							<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
						</xsl:if>
					</xsl:if>
					<xsl:if test="parent::ieee:li and (ancestor::ieee:note or ancestor::ieee:termnote)">
						<xsl:attribute name="margin-bottom">4pt</xsl:attribute>
					</xsl:if>
					<xsl:if test="(following-sibling::*[1][self::ieee:clause or self::ieee:terms or self::ieee:references])">
						<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
					</xsl:if>
					<xsl:if test="@id">
						<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
					</xsl:if>
					<xsl:attribute name="line-height">1.4</xsl:attribute>
					<!-- bookmarks only in paragraph -->
					<xsl:if test="count(ieee:bookmark) != 0 and count(*) = count(ieee:bookmark) and normalize-space() = ''">
						<xsl:attribute name="font-size">0</xsl:attribute>
						<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
						<xsl:attribute name="line-height">0</xsl:attribute>
					</xsl:if>
					
					<!-- put inline title in the first paragraph -->
					<!-- <xsl:if test="preceding-sibling::*[1]/@inline-header = 'true' and $previous-element = 'title'">
						<xsl:attribute name="space-before">6pt</xsl:attribute>
						<xsl:for-each select="preceding-sibling::*[1]">
							<xsl:call-template name="title"/>
						</xsl:for-each>
						<xsl:text> </xsl:text>
					</xsl:if> -->
					<xsl:apply-templates>
						<xsl:with-param name="split_keep-within-line" select="$split_keep-within-line"/>
					</xsl:apply-templates>
				</xsl:element>
				<xsl:if test="$element-name = 'fo:inline' and not(local-name(..) = 'admonition')"> <!-- and not($inline = 'true')  -->
					<fo:block margin-bottom="12pt">
						 <xsl:if test="ancestor::ieee:annex or following-sibling::ieee:table">
							<xsl:attribute name="margin-bottom">0</xsl:attribute>
						 </xsl:if>
						<xsl:value-of select="$linebreak"/>
					</fo:block>
				</xsl:if>
		
			</xsl:otherwise>
		</xsl:choose>
			
	</xsl:template>
			
	<xsl:template match="ieee:li//ieee:p//text()">
		<xsl:choose>
			<xsl:when test="contains(., '&#x9;')">
				<fo:inline white-space="pre"><xsl:value-of select="."/></fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'fn'][not(ancestor::*[(local-name() = 'table' or local-name() = 'figure') and not(ancestor::*[local-name() = 'name'])])]" priority="3">
		<xsl:call-template name="fn" />
	</xsl:template>
	

	<xsl:template match="ieee:p/ieee:fn/ieee:p" priority="2">
		<xsl:choose>
			<xsl:when test="preceding-sibling::ieee:p"> <!-- for multi-paragraphs footnotes -->
				<fo:block>
					<fo:inline padding-right="4mm">&#xa0;</fo:inline>
					<xsl:apply-templates />
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	
	<xsl:template match="ieee:ul | ieee:ol" mode="list" priority="2">
		<fo:list-block xsl:use-attribute-sets="list-style">
			<xsl:if test="parent::ieee:admonition[@type = 'commentary']">
				<xsl:attribute name="margin-left">7mm</xsl:attribute>
			</xsl:if>
			<xsl:if test="preceding-sibling::*[1][self::ieee:p]">
				<xsl:attribute name="margin-top">6pt</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="ancestor::ieee:note or ancestor::ieee:termnote">
				<xsl:attribute name="provisional-distance-between-starts">4mm</xsl:attribute>
			</xsl:if>
			
			<xsl:variable name="processing_instruction_type" select="normalize-space(preceding-sibling::*[1]/processing-instruction('list-type'))"/>
			<xsl:if test="self::ieee:ul and normalize-space($processing_instruction_type) = 'simple'">
				<xsl:attribute name="provisional-distance-between-starts">0mm</xsl:attribute>
			</xsl:if>
			
			
			<xsl:apply-templates select="node()[not(local-name() = 'note')]" />
		</fo:list-block>
		<xsl:apply-templates select="./ieee:note"/>
	</xsl:template>
	

	<xsl:template match="*[local-name()='table' or local-name()='figure']/*[local-name() = 'name']/node()[1][self::text()]" priority="2">
		<xsl:choose>
			<xsl:when test="contains(., '—')">
				<xsl:variable name="substring_after" select="substring-after(., '—')"/>
				<xsl:choose>
					<xsl:when test="ancestor::ieee:table/@unnumbered = 'true' and normalize-space($substring_after) = 'Key'"><!-- no display Table - --></xsl:when>
					<xsl:otherwise>
						<fo:inline font-weight="bold" font-style="normal">
							<xsl:value-of select="substring-before(., '—')"/>
						</fo:inline>
						<xsl:text>—</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:value-of select="$substring_after"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*[local-name() = 'inlineChar']">
		<fo:inline><xsl:value-of select="."/></fo:inline>
	</xsl:template>

	


	<xsl:variable name="example_name_width">25</xsl:variable>
	<xsl:template match="ieee:termexample" priority="2">
		<fo:block id="{@id}" xsl:use-attribute-sets="termexample-style">
		
			<fo:list-block provisional-distance-between-starts="{$example_name_width}mm">						
				<fo:list-item>
					<fo:list-item-label end-indent="label-end()">
						<fo:block><xsl:apply-templates select="*[local-name()='name']" /></fo:block>
					</fo:list-item-label>
					<fo:list-item-body start-indent="body-start()">
						<fo:block>
							<xsl:apply-templates select="node()[not(local-name() = 'name')]" />
						</fo:block>
					</fo:list-item-body>
				</fo:list-item>
			</fo:list-block>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="ieee:example" priority="2">
		<fo:block id="{@id}" xsl:use-attribute-sets="example-style">
		
			<fo:list-block provisional-distance-between-starts="{$example_name_width}mm">						
				<fo:list-item>
					<fo:list-item-label end-indent="label-end()">
						<fo:block>
							<xsl:apply-templates select="*[local-name()='name']"/>
						</fo:block>
					</fo:list-item-label>
					<fo:list-item-body start-indent="body-start()">
						<fo:block>
							<xsl:apply-templates select="node()[not(local-name()='name')]"/>
						</fo:block>
					</fo:list-item-body>
				</fo:list-item>
			</fo:list-block>
		
		</fo:block>
	</xsl:template>

	<!-- =================== -->
	<!-- Index processing -->
	<!-- =================== -->
	
	<xsl:template match="ieee:indexsect" />
	<xsl:template match="ieee:indexsect" mode="index">
		<fo:block id="{@id}" span="all">
			<xsl:apply-templates select="ieee:title"/>
		</fo:block>
		<fo:block role="Index">
			<xsl:apply-templates select="*[not(local-name() = 'title')]"/>
		</fo:block>
	</xsl:template>
	
	
	<xsl:template match="ieee:xref"  priority="2">
		<xsl:if test="@target and @target != ''">
			<fo:basic-link internal-destination="{@target}" fox:alt-text="{@target}" xsl:use-attribute-sets="xref-style">
				
				<!-- no highlight term's names -->
				<xsl:if test="normalize-space() != '' and string-length(normalize-space()) = string-length(translate(normalize-space(), '0123456789', '')) and not(contains(normalize-space(), 'Annex'))">
					<xsl:attribute name="color">inherit</xsl:attribute>
					<xsl:attribute name="text-decoration">none</xsl:attribute>
				</xsl:if>
				
				<xsl:if test="not(xalan:nodeset($ids)/id = current()/@target)"> <!-- if reference can't be resolved -->
					<xsl:attribute name="color">inherit</xsl:attribute>
					<xsl:attribute name="text-decoration">none</xsl:attribute>
				</xsl:if>
				
				<xsl:if test="parent::ieee:add">
					<xsl:call-template name="append_add-style"/>
				</xsl:if>
				
				<xsl:choose>
					<xsl:when test="@pagenumber='true' and not(ancestor::ieee:indexsect)">
						<fo:inline>
							<xsl:if test="@id">
								<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
							</xsl:if>
							<fo:page-number-citation ref-id="{@target}"/>
						</fo:inline>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates />
					</xsl:otherwise>
				</xsl:choose>
			</fo:basic-link>
		</xsl:if>
	</xsl:template>
	
	<!-- Figure 1 to Figure&#xA0;<bold>1</bold> -->
	<xsl:template match="ieee:xref[@to = 'figure' or @to = 'table']/text()" priority="2">
		<xsl:value-of select="."/>
	</xsl:template>
	
	<xsl:template match="ieee:td/ieee:xref/ieee:strong"  priority="2">
		<xsl:apply-templates />
	</xsl:template>

	
	<!-- =================== -->
	<!-- End of Index processing -->
	<!-- =================== -->
	
	<xsl:template match="*[local-name() = 'origin']" priority="3">
		<xsl:variable name="current_bibitemid" select="@bibitemid"/>
		<xsl:variable name="bibitemid">
			<xsl:choose>
				<!-- <xsl:when test="key('bibitems', $current_bibitemid)/*[local-name() = 'uri'][@type = 'citation']"></xsl:when> --><!-- external hyperlink -->
				<xsl:when test="$bibitems/*[local-name() ='bibitem'][@id = $current_bibitemid]/*[local-name() = 'uri'][@type = 'citation']"></xsl:when><!-- external hyperlink -->
				<xsl:otherwise><xsl:value-of select="@bibitemid"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="normalize-space($bibitemid) != '' and not($bibitems_hidden/*[local-name() ='bibitem'][@id = $current_bibitemid])">
				<fo:basic-link internal-destination="{@bibitemid}" fox:alt-text="{@citeas}">
					<xsl:if test="normalize-space(@citeas) = ''">
						<xsl:attribute name="fox:alt-text"><xsl:value-of select="@bibitemid"/></xsl:attribute>
					</xsl:if>
					<!-- <fo:inline>
						<xsl:value-of select="$localized.source"/>
						<xsl:text>: </xsl:text>
					</fo:inline> -->
					<fo:inline xsl:use-attribute-sets="origin-style">
						<xsl:apply-templates/>
					</fo:inline>
				</fo:basic-link>
			</xsl:when>
			<xsl:otherwise>
				<fo:inline><xsl:apply-templates /></fo:inline>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>
	
	
	
	<xsl:template match="ieee:columnbreak">
		<fo:block break-after="column"/>
	</xsl:template>

	<xsl:template match="ieee:pagebreak[ancestor::ieee:table]" priority="2">
		<fo:block break-after="page"/>
	</xsl:template>


	<xsl:template name="insertFootnoteSeparator">
		<fo:static-content flow-name="xsl-footnote-separator">
			<fo:block>
				<fo:leader leader-pattern="rule" rule-thickness="0.5pt" leader-length="35%"/>
			</fo:block>
		</fo:static-content>
	</xsl:template>
	
	
	<xsl:template name="insertHeaderFooter">
		<xsl:param name="designation"/>
		<xsl:param name="draft_number"/>
		<xsl:param name="draft_month"/>
		<xsl:param name="draft_year"/>
		<xsl:param name="opt_trial_use"/>
		<xsl:param name="doctype"/>
		<xsl:param name="title"/>
		<xsl:param name="copyright_year"/>
		<xsl:param name="copyright_holder"/>
	
		<xsl:param name="docidentifier" />
		<xsl:param name="hideFooter" select="'false'"/>
		<xsl:param name="copyrightText"/>
		
		<xsl:param name="copyright_year"/>
		<xsl:param name="copyright_holder"/>
		<xsl:param name="orientation"/>
		
		
		<xsl:variable name="header">
			<fo:block font-family="Arial" font-size="8pt" text-align="center">
				<!-- P<designation>/D<draft_number>, <draft_month> <draft_year>
				Draft<opt_Trial-Use><Gde./Rec. Prac./Std.> for <Complete Title Matching PAR>
				 -->
				<fo:block>
					<xsl:text>P</xsl:text>
					<xsl:value-of select="$designation"/>
					<xsl:text>/D</xsl:text>
					<xsl:value-of select="$draft_number"/>
					<xsl:text>, </xsl:text>
					<xsl:value-of select="$draft_month"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="$draft_year"/>
				</fo:block>
				<fo:block>
					<xsl:text>Draft</xsl:text>
					<xsl:value-of select="$opt_trial_use"/>
					<xsl:value-of select="$doctype"/>
					<xsl:text> for </xsl:text>
					<xsl:copy-of select="$title"/>
				</fo:block>
			</fo:block>
		</xsl:variable>
		
		<xsl:variable name="footer">
			<fo:block text-align="center" font-size="8pt" margin-bottom="12.7mm">
				<fo:block font-family="Times New Roman" font-size="10pt" font-weight="bold">
					<fo:page-number />
				</fo:block>
				<!-- Copyright © 2022 IEEE. All rights reserved. -->
				<fo:block>
					<xsl:text>Copyright © </xsl:text>
					<xsl:value-of select="$copyright_year"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="$copyright_holder"/>
					<xsl:text>. </xsl:text>
					<xsl:variable name="all_rights_reserved">
						<xsl:call-template name="getLocalizedString">
							<xsl:with-param name="key">all_rights_reserved</xsl:with-param>
						</xsl:call-template>
					</xsl:variable>
					<xsl:value-of select="$all_rights_reserved"/>
					<xsl:text>.</xsl:text>
				</fo:block>
				<fo:block>This is an unapproved IEEE Standards Draft, subject to change.</fo:block>
			</fo:block>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="$orientation = 'landscape'">
				<fo:static-content flow-name="right-region-landscape" role="artifact">
					<fo:block-container reference-orientation="270" margin-left="13mm">
						<xsl:copy-of select="$header"/>
					</fo:block-container>
				</fo:static-content>
				
				<xsl:if test="$hideFooter = 'false'">
					<fo:static-content flow-name="left-region-landspace" role="artifact">
						<fo:block-container reference-orientation="270" margin-left="13mm">
							<xsl:copy-of select="$footer"/>
						</fo:block-container>
					</fo:static-content>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<fo:static-content flow-name="header" role="artifact">
					<fo:block-container margin-top="12.7mm">
						<xsl:copy-of select="$header"/>
					</fo:block-container>
				</fo:static-content>
				
				<xsl:if test="$hideFooter = 'false'">
					<fo:static-content flow-name="footer" role="artifact">
						<fo:block-container display-align="after" height="100%">
							<xsl:copy-of select="$footer"/>
						</fo:block-container>
					</fo:static-content>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
	
	
	<xsl:template name="replaceChar">
		<xsl:param name="text" />
		<xsl:param name="replace" />
		<xsl:param name="by" />
		<xsl:choose>
			<xsl:when test="$text = '' or $replace = '' or not($replace)" >
				<xsl:value-of select="$text" />
			</xsl:when>
			<xsl:when test="contains($text, $replace)">
				<xsl:value-of select="substring-before($text,$replace)" />
				<xsl:element name="inlineChar" namespace="https://www.metanorma.org/ns/ieee"><xsl:value-of select="$by"/></xsl:element>
				<xsl:call-template name="replaceChar">
						<xsl:with-param name="text" select="substring-after($text,$replace)" />
						<xsl:with-param name="replace" select="$replace" />
						<xsl:with-param name="by" select="$by" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	
</xsl:stylesheet>
