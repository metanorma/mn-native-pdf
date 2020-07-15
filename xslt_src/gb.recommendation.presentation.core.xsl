<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
											xmlns:fo="http://www.w3.org/1999/XSL/Format" 
											xmlns:gb="https://www.metanorma.org/ns/gb"
											xmlns:mathml="http://www.w3.org/1998/Math/MathML" 
											xmlns:xalan="http://xml.apache.org/xalan" 
											xmlns:fox="http://xmlgraphics.apache.org/fop/extensions" 
											xmlns:java="http://xml.apache.org/xalan/java" 
											exclude-result-prefixes="java"
											version="1.0">

	<xsl:output method="xml" encoding="UTF-8" indent="no"/>
	
	<xsl:param name="svg_images"/>
	<xsl:variable name="images" select="document($svg_images)"/>
	
	<xsl:include href="./common.xsl"/>

	<xsl:key name="kfn" match="gb:p/gb:fn" use="@reference"/>
	
	<xsl:variable name="namespace">gb</xsl:variable>
	
	<xsl:variable name="debug">false</xsl:variable>
	<xsl:variable name="pageWidth" select="'210mm'"/>
	<xsl:variable name="pageHeight" select="'297mm'"/>

	<xsl:variable name="part" select="normalize-space(/gb:gb-standard/gb:bibdata/gb:ext/gb:structuredidentifier/gb:project-number/@part)"/>
	
	<xsl:variable name="standard-name">			
		<xsl:call-template name="capitalize">
			<xsl:with-param name="str" select="/gb:gb-standard/gb:bibdata/gb:ext/gb:gbtype/gb:gbscope"/>
		</xsl:call-template>
		<xsl:text> standard (</xsl:text>		
		<xsl:call-template name="capitalize">
			<xsl:with-param name="str" select="/gb:gb-standard/gb:bibdata/gb:ext/gb:gbtype/gb:gbmandate"/>
		</xsl:call-template>
		<xsl:text>)</xsl:text>
	</xsl:variable>
	
	<xsl:variable name="language" select="/gb:gb-standard/gb:bibdata/gb:language"/>
	
		
	<!-- Example:
		<item level="1" id="Foreword" display="true">Foreword</item>
		<item id="term-script" display="false">3.2</item>
	-->
	<xsl:variable name="contents">
		<contents>
			<xsl:apply-templates select="/gb:gb-standard/gb:preface/node()" mode="contents"/>
				
			<xsl:apply-templates select="/gb:gb-standard/gb:sections/gb:clause[1]" mode="contents"> <!-- [@id = '_scope'] -->
				<xsl:with-param name="sectionNum" select="'1'"/>
			</xsl:apply-templates>
			<xsl:apply-templates select="/gb:gb-standard/gb:bibliography/gb:references[1]" mode="contents"> <!-- [@id = '_normative_references'] -->
				<xsl:with-param name="sectionNum" select="'2'"/>
			</xsl:apply-templates>
			<xsl:apply-templates select="/gb:gb-standard/gb:sections/*[position() &gt; 1]" mode="contents"> <!-- @id != '_scope' -->
				<xsl:with-param name="sectionNumSkew" select="'1'"/>
			</xsl:apply-templates>
			<xsl:apply-templates select="/gb:gb-standard/gb:annex" mode="contents"/>
			<xsl:apply-templates select="/gb:gb-standard/gb:bibliography/gb:references[position() &gt; 1]" mode="contents"/> <!-- @id = '_bibliography' -->
			
			<xsl:apply-templates select="//gb:figure" mode="contents"/>
			
			<xsl:apply-templates select="//gb:table" mode="contents"/>
		</contents>
	</xsl:variable>
	
	<xsl:variable name="lang">
		<xsl:call-template name="getLang"/>
	</xsl:variable>
	
	<xsl:template match="/">
		<xsl:call-template name="namespaceCheck"/>
		<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format" font-family="SimSun" font-size="10.5pt" xml:lang="{$lang}"> <!--   -->
			<fo:layout-master-set>
				
				<!-- cover page -->
				<fo:simple-page-master master-name="cover" page-width="{$pageWidth}" page-height="{$pageHeight}">
					<fo:region-body margin-top="10mm" margin-bottom="24mm" margin-left="25mm" margin-right="23mm"/>
					<fo:region-before region-name="cover-header" extent="10mm" />
					<fo:region-after region-name="cover-footer" extent="24mm" />
					<fo:region-start region-name="cover-left-region" extent="25mm"/>
					<fo:region-end region-name="cover-right-region" extent="23mm"/>
				</fo:simple-page-master>
				
				<!-- contents pages -->
				<!-- odd pages -->
				<fo:simple-page-master master-name="odd" page-width="{$pageWidth}" page-height="{$pageHeight}">
					<fo:region-body margin-top="35mm" margin-bottom="20mm" margin-left="25mm" margin-right="20mm"/>
					<fo:region-before region-name="header" extent="35mm"/>
					<fo:region-after region-name="footer-odd" extent="20mm"/>
					<fo:region-start region-name="left-region" extent="25mm"/>
					<fo:region-end region-name="right-region" extent="20mm"/>
				</fo:simple-page-master>
				<!-- even pages -->
				<fo:simple-page-master master-name="even" page-width="{$pageWidth}" page-height="{$pageHeight}">
					<fo:region-body margin-top="35mm" margin-bottom="25mm" margin-left="20mm" margin-right="25mm"/>
					<fo:region-before region-name="header" extent="35mm"/>
					<fo:region-after region-name="footer-even" extent="20mm"/>
					<fo:region-start region-name="left-region" extent="20mm"/>
					<fo:region-end region-name="right-region" extent="25mm"/>
				</fo:simple-page-master>
				<fo:page-sequence-master master-name="preface">
					<fo:repeatable-page-master-alternatives>
						<fo:conditional-page-master-reference odd-or-even="even" master-reference="even"/>
						<fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd"/>
					</fo:repeatable-page-master-alternatives>
				</fo:page-sequence-master>
				<fo:page-sequence-master master-name="document">
					<fo:repeatable-page-master-alternatives>
						<fo:conditional-page-master-reference odd-or-even="even" master-reference="even"/>
						<fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd"/>
					</fo:repeatable-page-master-alternatives>
				</fo:page-sequence-master>
				
				<fo:simple-page-master master-name="last-odd" page-width="215.9mm" page-height="279.4mm">
					<fo:region-body margin-top="20mm" margin-bottom="20mm" margin-left="30mm" margin-right="15mm"/>
					<fo:region-before region-name="header" extent="20mm"/>
					<fo:region-after region-name="footer-odd" extent="20mm"/>
					<fo:region-start region-name="left-region" extent="30mm"/>
					<fo:region-end region-name="right-region" extent="15mm"/>
				</fo:simple-page-master>
				<fo:simple-page-master master-name="last-even" page-width="215.9mm" page-height="279.4mm">
					<fo:region-body margin-top="20mm" margin-bottom="20mm" margin-left="15mm" margin-right="30mm"/>
					<fo:region-before region-name="header" extent="20mm"/>
					<fo:region-after region-name="footer-odd" extent="20mm"/>
					<fo:region-start region-name="left-region" extent="15mm"/>
					<fo:region-end region-name="right-region" extent="30mm"/>
				</fo:simple-page-master>
				<fo:page-sequence-master master-name="last">
					<fo:repeatable-page-master-alternatives>
						<fo:conditional-page-master-reference odd-or-even="even" master-reference="last-even"/>
						<fo:conditional-page-master-reference odd-or-even="odd" master-reference="last-odd"/>
					</fo:repeatable-page-master-alternatives>
				</fo:page-sequence-master>	
			</fo:layout-master-set>

			<xsl:call-template name="addPDFUAmeta"/>
			
			<fo:page-sequence master-reference="cover" force-page-count="no-force">
				<fo:flow flow-name="xsl-region-body">
					<fo:block-container>
						<xsl:variable name="ccs" select="normalize-space(/gb:gb-standard/gb:bibdata/gb:ext/gb:ccs)"/>
						<fo:block font-weight="bold" line-height="130%">
							<xsl:if test="$ccs != ''">
								<xsl:text>ICS</xsl:text>
							</xsl:if>
							<xsl:text> </xsl:text>
							<xsl:value-of select="$linebreak"/>
							<xsl:value-of select="substring($ccs, 1, 1)"/>
							<xsl:text> </xsl:text>
							<fo:inline font-family="SimHei" font-weight="normal"><xsl:value-of select="substring($ccs, 2)"/></fo:inline>
							<xsl:text> </xsl:text>
						</fo:block>
					</fo:block-container>
					<!-- GB Logo -->
					<fo:block-container position="absolute" top="3mm" left="119mm"> <!-- top="8mm"  -->
						<fo:block>
							<xsl:variable name="gbprefix" select="normalize-space(java:toLowerCase(java:java.lang.String.new(/gb:gb-standard/gb:bibdata/gb:ext/gb:gbtype/gb:gbprefix)))"/>							
							<xsl:choose>
								<xsl:when test="$gbprefix = 'db' or $gbprefix = '81'">
									<fo:instream-foreign-object fox:alt-text="Logo">
										<svg id="图层_1" data-name="图层 1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 133.2 66.6"><title>gb-standard-db</title><path d="M56.5,0H0V66.6H56.5A8.5,8.5,0,0,0,65,58.1V8.5A8.5,8.5,0,0,0,56.5,0ZM42.4,56.3a2.9,2.9,0,0,1-2.9,2.9H22.8V7.5H39.5a2.8,2.8,0,0,1,2.9,2.8Z"/><path d="M133.2,24.7V8.5A8.5,8.5,0,0,0,124.7,0H68.2V66.6h56.5a8.5,8.5,0,0,0,8.5-8.5V41.3a8.6,8.6,0,0,0-6.9-8.3A8.6,8.6,0,0,0,133.2,24.7ZM110.6,56.3a2.9,2.9,0,0,1-2.9,2.9H91.1v-22h16.6a2.9,2.9,0,0,1,2.9,2.8Zm0-29.6a2.9,2.9,0,0,1-2.9,2.9H91.1V7.5h16.6a2.8,2.8,0,0,1,2.9,2.8Z"/></svg>
									</fo:instream-foreign-object>
								</xsl:when>
								<xsl:when test="$gbprefix = 'gb'">
									<fo:instream-foreign-object fox:alt-text="Logo">
										<svg width="29.9mm"  id="图层_1" data-name="图层 1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 232.1 117"><defs><style>.cls-1{fill:#fff;}.cls-1,.cls-2,.cls-3{stroke:#000;stroke-linecap:round;stroke-linejoin:round;stroke-width:1.32px;}.cls-3{fill:none;}</style></defs><title>gb-standard-gb</title><path class="cls-1" d="M201.6,36.5c0,5.6-4.3,8.4-8.8,8.4H147.9L136,58.5h55.2c14,0,22.7-9.1,23.7-19.8.7-6.5-.9-14.1-6-19l-9.6,11A7.6,7.6,0,0,1,201.6,36.5Z"/><path class="cls-1" d="M133.6,102.7V14.6h61c6.4,0,11,2,14.3,5.1L218.1,9C212.5,4.1,204.4.7,192.8.7H120.1V116.3l13.6-13.6Z"/><path class="cls-1" d="M216.6,81.1c0-11.9-7.1-16-7.1-16a82,82,0,0,1-9.5,9.5,6.1,6.1,0,0,1,2.3,5c0,3.3-.7,8.9-12.3,8.9H147.9l-14.2,14.2h50.8C203.9,102.7,216.6,95.7,216.6,81.1Z"/><path class="cls-2" d="M223.1,56.7s8.3-11.6,7-23.5c-.8-7.1-3.8-17.2-12-24.2l-9.2,10.7c5.1,4.9,6.7,12.5,6,19-1,10.7-9.7,19.8-23.7,19.8H136l11.9-13.6V28.6h44.9a9.4,9.4,0,0,1,6.5,2.1l9.6-11c-3.3-3.1-7.9-5.1-14.3-5.1h-61v88.1h.1l14.2-14.2V72.8h44.9c3.5,0,5.8.7,7.2,1.8a82,82,0,0,0,9.5-9.5s7.1,4.1,7.1,16c0,14.6-12.7,21.6-32.1,21.6H133.7l-13.6,13.6h72.7c20.6,0,35-13.6,37.4-25.5S232.1,67,223.1,56.7Z"/><line class="cls-3" x1="133.6" y1="14.6" x2="120.1" y2="0.7"/><polygon class="cls-2" points="70.9 59.6 57.8 74.7 85.1 74.7 98.8 59.6 70.9 59.6"/><path class="cls-2" d="M52,15.9c-8.8,0-35,9.3-36,38-.6,16,4.3,28.2,11.3,36.3l10.8-9.8c-5.2-4.8-9.2-12.2-9.2-23.1,0-21.4,21-27.3,28.9-27.3H113L98.8,15.9Z"/><path class="cls-1" d="M49.8,101.6h49v-42L85.1,74.7V88.5H57.8a31,31,0,0,1-19.7-8.1L27.3,90.2C33.8,97.6,42.2,101.6,49.8,101.6Z"/><polygon class="cls-1" points="57.8 45.4 57.8 74.7 70.9 59.6 98.8 59.6 113 45.4 85.1 45.4 57.8 45.4"/><path class="cls-2" d="M98.8,101.6h-49c-7.6,0-16-4-22.5-11.4L17,99.5c9.3,10.1,22.7,16.8,40.8,16.8H113V45.4L98.8,59.6Z"/><path class="cls-1" d="M16,53.9c1-28.7,27.2-38,36-38H98.8L113,30V.7H57.8C34.2.7.7,22,.7,52.9.7,69.8,5.8,87.2,17,99.5l10.3-9.3C20.3,82.1,15.4,69.9,16,53.9Z"/><line class="cls-3" x1="57.8" y1="45.4" x2="70.9" y2="59.6"/><line class="cls-3" x1="85.1" y1="88.5" x2="98.8" y2="101.6"/><line class="cls-3" x1="98.8" y1="15.9" x2="113" y2="0.7"/></svg>
									</fo:instream-foreign-object>
								</xsl:when>								
								<xsl:when test="$gbprefix = 'gjb'">
									<fo:instream-foreign-object fox:alt-text="Logo">
										<svg id="图层_1" data-name="图层 1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 232.2 88.4"><defs><style>.cls-1{fill:#fff;}.cls-1,.cls-2,.cls-3{stroke:#000;stroke-linecap:round;stroke-linejoin:round;}.cls-3{fill:none;}</style></defs><title>gb-standard-gjb</title><path class="cls-1" d="M209.1,27.6c0,4.2-3.3,6.4-6.7,6.4H168.5l-9,10.2h41.7c10.6,0,17.2-6.9,18-14.9.5-4.9-.7-10.7-4.6-14.4l-7.2,8.3A5.9,5.9,0,0,1,209.1,27.6Z"/><path class="cls-1" d="M157.7,77.6V11h46.1a15.4,15.4,0,0,1,10.8,3.9l7-8.1C217.3,3.1,211.2.5,202.4.5H147.5V87.9l10.3-10.3Z"/><path class="cls-1" d="M220.4,61.3c0-9-5.3-12.1-5.3-12.1a70.7,70.7,0,0,1-7.2,7.2,4.5,4.5,0,0,1,1.7,3.7c0,2.5-.5,6.8-9.3,6.8H168.5L157.8,77.6h38.4C210.9,77.6,220.4,72.3,220.4,61.3Z"/><path class="cls-2" d="M225.4,42.9s6.2-8.8,5.2-17.8c-.6-5.4-2.8-13-9-18.3l-7,8.1c3.9,3.7,5.1,9.5,4.6,14.4-.8,8-7.4,14.9-18,14.9H159.5l9-10.2V21.6h33.9a7.5,7.5,0,0,1,5,1.6l7.2-8.3A15.4,15.4,0,0,0,203.8,11H157.7V77.6h.1l10.7-10.7V55h33.9a9.1,9.1,0,0,1,5.5,1.4,70.7,70.7,0,0,0,7.2-7.2s5.3,3.1,5.3,12.1c0,11-9.5,16.3-24.2,16.3H157.8L147.5,87.9h54.9c15.6,0,26.5-10.3,28.3-19.3S232.1,50.6,225.4,42.9Z"/><line class="cls-3" x1="157.7" y1="11" x2="147.5" y2="0.5"/><path class="cls-2" d="M121.4,87.9c10.3,0,20.3-12.1,20.3-24.5V.5h-21V57.6c0,3.9,0,9.3-7.3,9.3H87.7v21h33.7Z"/><path class="cls-1" d="M120.7,57.6c0,3.9,0,9.3-7.3,9.3H87.7v21L98.8,77.4h19.3c8.3,0,13.3-6,13.3-19V11L141.7.5h-21Z"/><line class="cls-3" x1="131.4" y1="11" x2="120.7" y2="0.5"/><line class="cls-3" x1="98.8" y1="77.4" x2="87.7" y2="66.9"/><polygon class="cls-2" points="51.4 45.1 41.5 56.5 62.2 56.5 72.5 45.1 51.4 45.1"/><path class="cls-2" d="M39.3,12c-6.6,0-26.5,7-27.2,28.7-.4,12.1,3.2,21.4,8.5,27.4l8.2-7.3c-3.9-3.7-7-9.3-7-17.5,0-16.2,15.9-20.6,21.9-20.6H83.3L72.6,12Z"/><path class="cls-1" d="M37.6,76.7h35V45.1L62.2,56.5V66.9H43.7a23.8,23.8,0,0,1-14.9-6.1l-8.2,7.3C25.6,73.8,31.9,76.7,37.6,76.7Z"/><polygon class="cls-1" points="41.5 34.3 41.5 56.5 51.4 45.1 72.5 45.1 83.3 34.3 62.2 34.3 41.5 34.3"/><path class="cls-2" d="M72.6,76.7h-35c-5.7,0-12-2.9-17-8.6l-7.7,7.1c7,7.7,17.1,12.7,30.8,12.7H83.3V34.3L72.6,45.1Z"/><path class="cls-1" d="M12.1,40.7C12.8,19,32.7,12,39.3,12H72.6L83.3,22.7V.5H43.7C25.9.5.5,16.6.5,40c0,12.8,3.9,25.9,12.4,35.2l7.7-7.1C15.3,62.1,11.7,52.8,12.1,40.7Z"/><line class="cls-3" x1="41.5" y1="34.3" x2="51.4" y2="45.1"/><line class="cls-3" x1="62.2" y1="66.9" x2="72.6" y2="76.7"/><line class="cls-3" x1="72.6" y1="12" x2="83.3" y2="0.5"/></svg>
									</fo:instream-foreign-object>
								</xsl:when>
								<xsl:when test="$gbprefix = 'gm'">
									<fo:instream-foreign-object fox:alt-text="Logo">
										<svg id="图层_1" data-name="图层 1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 187.2 95.1"><title>gb-standard-gm</title><polygon points="160 0 141.8 32.9 123.6 0 96.3 0 96.3 11.3 96.3 95.1 123.6 95.1 123.6 60.7 125 63.3 141.8 93.6 158.5 63.3 160 60.7 160 95.1 187.2 95.1 187.2 11.3 187.2 0 160 0"/><path d="M81.3,0H9.9A10,10,0,0,0,0,9.9V85.2a9.9,9.9,0,0,0,9.9,9.9h43a9.9,9.9,0,0,0,6.8-2.7v2.7H91.2V43.2H48.8v9.5H59.7V78.9A5.7,5.7,0,0,1,54,84.5H37.2a5.7,5.7,0,0,1-5.7-5.6V16.3a5.8,5.8,0,0,1,5.7-5.7H54a5.8,5.8,0,0,1,5.7,5.7V31.2H91.2V9.9A10,10,0,0,0,81.3,0Z"/></svg>
									</fo:instream-foreign-object>
								</xsl:when>
								<xsl:when test="$gbprefix = 'jjf'">
									<fo:instream-foreign-object fox:alt-text="Logo">
										<svg id="图层_1" data-name="图层 1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 226.8 89.6"><defs><style>.cls-1,.cls-2,.cls-3{stroke:#000;stroke-linecap:round;stroke-linejoin:round;stroke-width:1.2px;}.cls-2{fill:#fff;}.cls-3{fill:none;}</style></defs><title>gb-standard-jjf</title><polygon class="cls-1" points="84.3 12.3 75.1 23.9 144.4 23.9 144.4 0.6 133.7 12.3 84.3 12.3"/><polygon class="cls-2" points="75.1 23.9 84.3 12.3 133.7 12.3 144.4 0.6 75.1 0.6 75.1 23.9"/><path class="cls-2" d="M92,73.6c2.6,2.2,6.2,3.4,11.3,3.4,13.4,0,19.1-7.3,19.1-22.2V13.5L110.7,23.7V62s-1,4.6-5.5,4.6a7.5,7.5,0,0,1-3.9-1h0Z" transform="translate(0)"/><path class="cls-1" d="M86.8,57c0,7.1,1.2,13,5.2,16.6l9.3-8h0c-1.9-1.1-2.8-3.3-2.8-6.2V44L86.8,51.7Z" transform="translate(0)"/><path class="cls-1" d="M110.7,12.3V23.7l11.7-10.2V54.8c0,14.9-5.7,22.2-19.1,22.2-5.1,0-8.7-1.2-11.3-3.4l-7.9,6.8c5,4.5,12,7.4,20.8,7.4,19,0,29.1-14.2,29.1-25.8V12.3Z" transform="translate(0)"/><path class="cls-2" d="M86.8,57V51.7L98.5,44H75.1V59.4a28.7,28.7,0,0,0,9,21L92,73.6C88,70,86.8,64.1,86.8,57Z" transform="translate(0)"/><polyline class="cls-3" points="88.4 53.6 86.8 51.7 75.1 44"/><line class="cls-3" x1="84.3" y1="12.3" x2="75.1" y2="0.6"/><polygon class="cls-1" points="9.8 12.3 0.6 23.9 69.9 23.9 69.9 0.6 59.1 12.3 9.8 12.3"/><polygon class="cls-2" points="0.6 23.9 9.8 12.3 59.1 12.3 69.9 0.6 0.6 0.6 0.6 23.9"/><path class="cls-2" d="M17.5,73.6C20,75.8,23.7,77,28.8,77c13.4,0,19-7.3,19-22.2V13.5L36.2,23.7V62s-1.1,4.6-5.5,4.6a8.2,8.2,0,0,1-4-1h0Z" transform="translate(0)"/><path class="cls-1" d="M12.3,57c0,7.1,1.2,13,5.2,16.6l9.2-8h0c-1.8-1.1-2.8-3.3-2.8-6.2V44L12.3,51.7Z" transform="translate(0)"/><path class="cls-1" d="M36.2,12.3V23.7L47.8,13.5V54.8c0,14.9-5.6,22.2-19,22.2-5.1,0-8.8-1.2-11.3-3.4L9.6,80.4c5,4.5,12,7.4,20.7,7.4,19,0,29.2-14.2,29.2-25.8V12.3Z" transform="translate(0)"/><path class="cls-2" d="M12.3,57V51.7L23.9,44H.6V59.4a28.4,28.4,0,0,0,9,21l7.9-6.8C13.5,70,12.3,64.1,12.3,57Z" transform="translate(0)"/><polyline class="cls-3" points="13.9 53.6 12.3 51.7 0.6 44"/><line class="cls-3" x1="9.8" y1="12.3" x2="0.6" y2="0.6"/><polygon class="cls-1" points="226.2 0.6 173.4 0.6 152.4 0.6 149.1 0.6 149.1 89 173.4 89 173.4 24.9 226.2 24.9 226.2 0.6"/><rect class="cls-1" x="161.3" y="36.6" width="64.9" height="24.33"/><polygon class="cls-2" points="162.1 48.8 216.1 48.8 226.2 36.6 173.4 36.6 162.1 48.8"/><polygon class="cls-2" points="152.4 0.6 149.1 0.6 149.1 89 161.3 79.1 161.3 12.3 216.8 12.3 226.2 0.6 173.4 0.6 152.4 0.6"/><line class="cls-3" x1="161.3" y1="12.3" x2="149.1" y2="0.6"/></svg>
									</fo:instream-foreign-object>
								</xsl:when>
								<xsl:when test="$gbprefix = 'zb'">
									<fo:instream-foreign-object fox:alt-text="Logo">
										<svg version="1.1" id="图层_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
											 viewBox="0 0 157.1 81.9" style="enable-background:new 0 0 157.1 81.9;" xml:space="preserve">
										<g>
											<rect x="80.8" width="32.2" height="81.9"/>
											<polygon points="74.9,46.2 42.7,81.9 74.9,81.9 	"/>
											<polygon points="33.6,0 0,0 0,37.8 	"/>
											<path d="M157.1,61.1c0-8.6-6-17.5-15.4-21c7.7-1.1,14.6-10.4,14.6-21.2c0-10.8-9.5-19-27.7-19h-11.7v81.1
												c5.3,0.4,11.4,0.8,17.7,0.8C153,81.9,157.1,69.8,157.1,61.1z"/>
											<polygon points="75.6,0 40.6,0 0,81.9 35,81.9 	"/>
										</g>
										</svg>
									</fo:instream-foreign-object>
								</xsl:when>
								<xsl:when test="$gbprefix = 'ls' or $gbprefix = 'abc'">
									<xsl:attribute name="text-align">right</xsl:attribute>
									<xsl:attribute name="font-weight">bold</xsl:attribute>
									<fo:inline font-size="36pt"><xsl:value-of select="/gb:gb-standard/gb:bibdata/gb:ext/gb:gbtype/gb:gbprefix"/></fo:inline>
								</xsl:when>
								<!-- <xsl:when test="$gbprefix = 'gb'">
									<fo:external-graphic src="{concat('data:image/gif;base64,', normalize-space($Image-GB-Logo))}" width="29.9mm" content-height="14.8mm" content-width="scale-to-fit" scaling="uniform" fox:alt-text="Image GB Logo"/>
								</xsl:when> -->
								<xsl:otherwise>&#xA0;</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:block-container>
					<!-- National standard (Recommended) -->
					<fo:block-container position="absolute" left="0mm" top="28mm" width="170mm" text-align="center">
						<fo:block font-weight="bold" font-size="12pt"> <!-- font-stretch="wider" not supported by FOP-->
							<xsl:call-template name="addLetterSpacing">
								<xsl:with-param name="text" select="$standard-name"/>
								<xsl:with-param name="letter-spacing" select="0.7"/>
							</xsl:call-template>
						</fo:block>
					</fo:block-container>
					<fo:block-container position="absolute" left="0mm" top="43mm" height="46.4mm" width="165mm" text-align="right">
						<fo:block>
							<!-- GB/T/303 80021.1 -->
							<fo:block font-family="SimHei" font-size="14pt">
								<xsl:value-of select="/gb:gb-standard/gb:bibdata/gb:docidentifier[@type = 'gb']"/>							
							</fo:block>
							<!-- Partly Supercedes GB/T 88021-2016 -->
							<fo:block margin-top="2.85pt">
								<xsl:variable name="title-partly-supercedes">
									<xsl:call-template name="getTitle">
										<xsl:with-param name="name" select="'title-partly-supercedes'"/>
									</xsl:call-template>
								</xsl:variable>
								<xsl:value-of select="$title-partly-supercedes"/>								
								<xsl:value-of select="/gb:gb-standard/gb:bibdata/gb:relation[@type='obsoletes']/gb:bibitem/gb:docidentifier"/>
							</fo:block>
						</fo:block>
					</fo:block-container>
					<fo:block-container position="absolute" left="0mm" top="66mm" height="2mm" width="170mm" border-top="1pt solid black">
						<fo:block>&#xA0;</fo:block>
					</fo:block-container>
					<fo:block-container position="absolute" left="-2.5mm" top="106mm" height="124mm" width="165mm" text-align="center">
						<!-- Cereals and pulses—Specifications and test methods—Part 1: Rice -->
						<fo:block font-size="26pt" line-height="130%">
							<xsl:attribute name="font-family">
								<xsl:choose>
									<xsl:when test="$lang = 'zh'">SimSun</xsl:when>
									<xsl:otherwise>Cambria</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
							<xsl:call-template name="insertTitle">
								<xsl:with-param name="lang" select="$language"/>
							</xsl:call-template>
						</fo:block>
						<fo:block font-size="14pt" margin-top="28.35pt" margin-bottom="28.35pt">							
							<xsl:variable name="secondlang">
								<xsl:choose>
									<xsl:when test="$language = 'en'">zh</xsl:when>
									<xsl:when test="$language = 'zh'">en</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:if test="$secondlang = 'en'">
								<xsl:attribute name="font-family">SimHei</xsl:attribute>
							</xsl:if>
							<xsl:call-template name="insertTitle">
								<xsl:with-param name="lang" select="$secondlang"/>
							</xsl:call-template>
						</fo:block>
						<!-- (ISO 17301-1:2016, IDT) -->
						<fo:block font-size="14pt" margin-top="30pt">
							<xsl:text>&#xA0;</xsl:text>
								<xsl:if test="/gb:gb-standard/gb:bibdata/gb:relation[@type='adoptedFrom']/gb:bibitem/gb:docidentifier">
									<xsl:text>(</xsl:text>
										<xsl:value-of select="/gb:gb-standard/gb:bibdata/gb:relation[@type='adoptedFrom']/gb:bibitem/gb:docidentifier"/>
										<xsl:text>, </xsl:text>
										<xsl:text> IDT</xsl:text>
									<xsl:text>)</xsl:text>
								</xsl:if>
							<xsl:text>&#xA0;</xsl:text>
						</fo:block>
						<!-- （CD） -->
						<fo:block font-size="12pt" margin-top="30pt">
							<xsl:text>(</xsl:text>
							<xsl:value-of select="/gb:gb-standard/gb:bibdata/gb:status/gb:stage/@abbreviation"/>
							<xsl:text>)</xsl:text>
						</fo:block>
						<fo:block text-align="justify">
							<!-- When submitting feedback, please attach any relevant patents that you are aware of, together with supporting documents. -->
							<xsl:apply-templates select="/gb:gb-standard/gb:boilerplate/gb:legal-statement"/>
						</fo:block>
						<fo:block margin-top="9.05pt">
							<xsl:text>（</xsl:text>
							<xsl:variable name="title-completion-date">
								<xsl:call-template name="getTitle">
									<xsl:with-param name="name" select="'title-completion-date'"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:value-of select="$title-completion-date"/>							
							<xsl:text>: </xsl:text>
								<xsl:value-of select="/gb:gb-standard/gb:bibdata/gb:version/gb:revision-date"/>
							<xsl:text>)</xsl:text>
						</fo:block>
					</fo:block-container>
					<fo:block-container position="absolute" left="0mm" top="239mm" width="170mm" border-bottom="1pt solid black">
						<fo:block font-family="SimHei" font-size="14pt" text-align-last="justify" margin-bottom="2.5mm">
							<xsl:variable name="title-issuance-date">
								<xsl:call-template name="getTitle">
									<xsl:with-param name="name" select="'title-issuance-date'"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:value-of select="java:replaceAll(java:java.lang.String.new($title-issuance-date),'#',/gb:gb-standard/gb:bibdata/gb:date[@type='issued']/gb:on)"/>
							
							<fo:inline keep-together.within-line="always">
								<fo:leader  leader-pattern="space"/>
							</fo:inline>
							
							<xsl:variable name="title-implementation-date">
								<xsl:call-template name="getTitle">
									<xsl:with-param name="name" select="'title-implementation-date'"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:value-of select="java:replaceAll(java:java.lang.String.new($title-implementation-date),'#',/gb:gb-standard/gb:bibdata/gb:date[@type='implemented']/gb:on)"/>
							
						</fo:block>
					</fo:block-container>
					<fo:block break-after="page"/>
					<fo:block>&#xA0;</fo:block>
				</fo:flow>
			</fo:page-sequence>
			
			
			
			<fo:page-sequence master-reference="preface" format="I" initial-page-number="1" force-page-count="no-force">
				<xsl:call-template name="insertHeaderFooter"/>
				<fo:flow flow-name="xsl-region-body">
					<fo:block-container>
						
						<fo:block font-family="SimHei" font-size="16pt" margin-top="6pt" margin-bottom="32pt" text-align="center">
							<xsl:variable name="title-toc">
								<xsl:call-template name="getTitle">
									<xsl:with-param name="name" select="'title-toc'"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:value-of select="$title-toc"/>
						</fo:block>
						
						<xsl:if test="$debug = 'true'">
							<xsl:text disable-output-escaping="yes">&lt;!--</xsl:text>
								DEBUG
								contents=<xsl:copy-of select="xalan:nodeset($contents)"/>
							<xsl:text disable-output-escaping="yes">--&gt;</xsl:text>
						</xsl:if>
						
						<fo:block line-height="220%">
							<xsl:variable name="margin-left">12</xsl:variable>
							<xsl:for-each select="xalan:nodeset($contents)//item[@display = 'true'][not(@level = 2 and starts-with(@section, '0'))]"><!-- skip clause from preface -->							
								<fo:block text-align-last="justify">
									<xsl:if test="@level =2">
										<xsl:attribute name="margin-left">3.7mm</xsl:attribute>
									</xsl:if>
									<fo:basic-link internal-destination="{@id}" fox:alt-text="{text()}">
										<xsl:if test="normalize-space(@section) != '' and not(@display-section = 'false')">
											<fo:inline>
												<xsl:if test="@type = 'annex' and @level = 1">
													<xsl:attribute name="font-weight">bold</xsl:attribute>
												</xsl:if>
												<xsl:value-of select="@section"/>											
											</fo:inline>
											<xsl:if test="not(@type = 'annex' and @level = 1)">
												<xsl:text>.&#x3000;</xsl:text>
											</xsl:if>
											<xsl:if test="@type = 'annex' and @level = 1">
												<xsl:text>&#xA0;</xsl:text>
											</xsl:if>
										</xsl:if>
										<xsl:if test="@addon != ''">
											<fo:inline font-weight="normal">(<xsl:value-of select="@addon"/>)</fo:inline>
											<xsl:text>&#xA0;</xsl:text>
										</xsl:if>
										<xsl:value-of select="text()"/>
										<xsl:text> </xsl:text>
										<fo:inline keep-together.within-line="always">
											<fo:leader font-weight="normal" leader-pattern="dots"/>
											<fo:inline><fo:page-number-citation ref-id="{@id}"/></fo:inline>
										</fo:inline>
									</fo:basic-link>
									
								</fo:block>
								
							</xsl:for-each>
						</fo:block>
					</fo:block-container>
					
					<!-- Foreword, Introduction -->
					<fo:block line-height="150%">
						<xsl:apply-templates select="/gb:gb-standard/gb:preface/node()"/>
					</fo:block>
					
				</fo:flow>
			</fo:page-sequence>
			
			<fo:page-sequence master-reference="document" format="1" initial-page-number="1" force-page-count="no-force">
				<fo:static-content flow-name="xsl-footnote-separator">
					<fo:block margin-left="7.4mm">
						<fo:leader leader-pattern="rule" leader-length="30%"/>
					</fo:block>
				</fo:static-content>
				<xsl:call-template name="insertHeaderFooter"/>
				<fo:flow flow-name="xsl-region-body">
					<fo:block line-height="150%">
					
						<!-- Cereals and pulses—Specifications and test methods—Part 1: Rice -->
						<fo:block font-family="SimHei" font-size="16pt" text-align="center" line-height="130%" margin-bottom="18pt">
							<xsl:call-template name="insertTitle">
								<xsl:with-param name="lang" select="$language"/>
							</xsl:call-template>
						</fo:block>
					
						<xsl:apply-templates select="/gb:gb-standard/gb:sections/gb:clause[1]"> <!-- Scope -->
							<xsl:with-param name="sectionNum" select="'1'"/>
						</xsl:apply-templates>
						
						<!-- Normative references  -->
						<xsl:apply-templates select="/gb:gb-standard/gb:bibliography/gb:references[1]">
							<xsl:with-param name="sectionNum" select="'2'"/>
						</xsl:apply-templates>
						
						<!-- Main sections -->
						<xsl:apply-templates select="/gb:gb-standard/gb:sections/*[position() &gt; 1]">
							<xsl:with-param name="sectionNumSkew" select="'1'"/>
						</xsl:apply-templates>
						
						<!-- Annex(s) -->
						<xsl:apply-templates select="/gb:gb-standard/gb:annex"/>
						
						<!-- Bibliography -->
						<xsl:apply-templates select="/gb:gb-standard/gb:bibliography/gb:references[position() &gt; 1]"/>
						
					</fo:block>
				</fo:flow>
			</fo:page-sequence>
	
			<fo:page-sequence master-reference="last" force-page-count="no-force">
				<fo:flow flow-name="xsl-region-body">
					<fo:block-container font-size="12pt">
						<fo:block margin-top="14pt" margin-bottom="14pt">
							<xsl:value-of select="$standard-name"/>
						</fo:block>
						<fo:block margin-top="14pt" margin-bottom="14pt">
							<xsl:value-of select="/gb:gb-standard/gb:bibdata/gb:title[@language = 'zh' and @type = 'title-main']"/>
						</fo:block>
						<fo:block margin-top="14pt" margin-bottom="14pt">
							<xsl:value-of select="/gb:gb-standard/gb:bibdata/gb:docidentifier[@type = 'gb']"/>
						</fo:block>
					</fo:block-container>
				</fo:flow>				
			</fo:page-sequence>
	
		</fo:root>
	</xsl:template> 

	<xsl:template name="insertTitle">
		<xsl:param name="lang" select="'en'"/>
		<xsl:variable name="delimeter">
			<xsl:choose>
				<xsl:when test="$lang = 'zh'">&#xA0;</xsl:when>
				<xsl:otherwise>—</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:value-of select="/gb:gb-standard/gb:bibdata/gb:title[@language = $lang and @type='title-intro']"/>
		<xsl:variable name="title-main" select="/gb:gb-standard/gb:bibdata/gb:title[@language = $lang and @type = 'title-main']"/>
		<xsl:if test="normalize-space($title-main) != ''">
			<xsl:value-of select="$delimeter"/>
			<xsl:value-of select="$title-main"/>
		</xsl:if>
		<xsl:variable name="title-part" select="/gb:gb-standard/gb:bibdata/gb:title[@language = $lang and @type = 'title-part']"/>
		<xsl:if test="normalize-space($title-part) != ''">
			<xsl:value-of select="$delimeter"/>
			<xsl:if test="$part != ''">
				<xsl:choose>
					<xsl:when test="$lang = 'zh'">
						<xsl:value-of select="java:replaceAll(java:java.lang.String.new($titles/title-part[@lang='zh']),'#',$part)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="java:replaceAll(java:java.lang.String.new($titles/title-part[@lang='en']),'#',$part)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:value-of select="$title-part"/>
		</xsl:if>		
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
	<xsl:template match="gb:gb-standard/gb:sections/*" mode="contents">
		<xsl:param name="sectionNum"/>
		<xsl:param name="sectionNumSkew" select="0"/>
		<xsl:variable name="sectionNum_">
			<xsl:choose>
				<xsl:when test="$sectionNum"><xsl:value-of select="$sectionNum"/></xsl:when>
				<xsl:when test="$sectionNumSkew != 0">
					<xsl:variable name="number"><xsl:number count="*"/></xsl:variable> <!-- gb:sections/gb:clause | gb:sections/gb:terms -->
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
	<xsl:template match="gb:title | gb:preferred" mode="contents">
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
				<xsl:when test="ancestor::gb:bibitem">false</xsl:when>
				<xsl:when test="ancestor::gb:term">false</xsl:when>
				<xsl:when test="ancestor::gb:annex and $level &gt;= 3">false</xsl:when>
				<xsl:when test="$level &lt;= 3">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="display-section">true</xsl:variable>
		
		<xsl:variable name="type">
			<xsl:value-of select="local-name(..)"/>
		</xsl:variable>

		<xsl:variable name="root">
			<xsl:choose>
				<xsl:when test="ancestor::gb:annex">annex</xsl:when>
			</xsl:choose>
		</xsl:variable>
		
		<item id="{$id}" level="{$level}" section="{$section}" display-section="{$display-section}" display="{$display}" type="{$type}" root="{$root}">
			<xsl:attribute name="addon">
				<xsl:if test="local-name(..) = 'annex'">
					<xsl:variable name="obligation" select="../@obligation"/>
					<xsl:variable name="title-obligation-normative">
						<xsl:call-template name="getTitle">
							<xsl:with-param name="name" select="'title-obligation-normative'"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:choose>
						<xsl:when test="$obligation = 'normative'"><xsl:value-of select="$title-obligation-normative"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="$obligation"/></xsl:otherwise>
					</xsl:choose>					
				</xsl:if>
			</xsl:attribute>
			<xsl:value-of select="."/>
		</item>
		
		<xsl:apply-templates mode="contents">
			<xsl:with-param name="sectionNum" select="$sectionNum"/>
		</xsl:apply-templates>
		
	</xsl:template>
	
	
	<xsl:template match="gb:figure" mode="contents">
		<item level="" id="{@id}" display="false">
			<xsl:attribute name="section">
				<xsl:call-template name="getFigureNumber"/>
			</xsl:attribute>
		</item>
	</xsl:template>
	
	<xsl:template match="gb:table" mode="contents">
		<xsl:param name="sectionNum" />
		<xsl:variable name="annex-id" select="ancestor::gb:annex/@id"/>
		<item level="" id="{@id}" display="false" type="table">
			<xsl:attribute name="section">
				<xsl:variable name="title-table">
					<xsl:call-template name="getTitle">
						<xsl:with-param name="name" select="'title-table'"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:value-of select="$title-table"/>
				<xsl:choose>
					<xsl:when test="ancestor::*[local-name()='executivesummary']"> <!-- NIST -->
							<xsl:text>ES-</xsl:text><xsl:number format="1" count="*[local-name()='executivesummary']//*[local-name()='table']"/>
						</xsl:when>
					<xsl:when test="ancestor::*[local-name()='annex']">
						<xsl:number format="A-" count="gb:annex"/>
						<xsl:number format="1" level="any" count="gb:table[ancestor::gb:annex[@id = $annex-id]]"/>
					</xsl:when>
					<xsl:otherwise>
						<!-- <xsl:number format="1"/> -->
						<xsl:number format="1" level="any" count="*[local-name()='sections']//*[local-name()='table']"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:value-of select="gb:name/text()"/>
		</item>
	</xsl:template>
	
	<xsl:template match="gb:formula" mode="contents">
		<item level="" id="{@id}" display="false">
			<xsl:attribute name="section">
				<xsl:variable name="title-formula">
					<xsl:call-template name="getTitle">
						<xsl:with-param name="name" select="'title-formula'"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:value-of select="$title-formula"/><xsl:number format="(A.1)" level="multiple" count="gb:annex | gb:formula"/>
			</xsl:attribute>
		</item>
	</xsl:template>
	
	<xsl:template match="gb:li" mode="contents">
		<xsl:param name="sectionNum" />
		<item level="" id="{@id}" display="false" type="li">
			<xsl:attribute name="section">
				<xsl:call-template name="getListItemFormat"/>
			</xsl:attribute>
			<xsl:attribute name="parent_section">
				<xsl:for-each select="ancestor::*[not(local-name() = 'p' or local-name() = 'ol')][1]">
					<xsl:call-template name="getSection">
						<xsl:with-param name="sectionNum" select="$sectionNum"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:attribute>
		</item>
		<xsl:apply-templates mode="contents">
			<xsl:with-param name="sectionNum" select="$sectionNum"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template name="getListItemFormat">
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
	</xsl:template>

	<!-- ============================= -->
	<!-- ============================= -->
	
	
	<xsl:template match="gb:license-statement//gb:title">
		<fo:block text-align="center" font-weight="bold">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="gb:license-statement//gb:p">
		<fo:block margin-left="1.5mm" margin-right="1.5mm">
			<xsl:if test="following-sibling::gb:p">
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
	
	<xsl:template match="gb:copyright-statement//gb:p">
		<fo:block>
			<xsl:if test="preceding-sibling::gb:p">
				<!-- <xsl:attribute name="font-size">10pt</xsl:attribute> -->
			</xsl:if>
			<xsl:if test="following-sibling::gb:p">
				<!-- <xsl:attribute name="margin-bottom">12pt</xsl:attribute> -->
				<xsl:attribute name="margin-bottom">3pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="contains(@id, 'address')"> <!-- not(following-sibling::gb:p) -->
				<!-- <xsl:attribute name="margin-left">7.1mm</xsl:attribute> -->
				<xsl:attribute name="margin-left">4mm</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<!-- Foreword, Introduction -->
	<xsl:template match="gb:gb-standard/gb:preface/*">
		<fo:block break-after="page"/>
		<xsl:apply-templates />
	</xsl:template>
	
	
	<!-- clause, terms, clause, ...-->
	<xsl:template match="gb:gb-standard/gb:sections/*">
		<xsl:param name="sectionNum"/>
		<xsl:param name="sectionNumSkew" select="0"/>
		<fo:block>
			<xsl:variable name="pos"><xsl:number count="gb:sections/gb:clause | gb:sections/gb:terms"/></xsl:variable>
			<xsl:if test="$pos &gt;= 2">
				<xsl:attribute name="space-before">18pt</xsl:attribute>
			</xsl:if>
			<!-- pos=<xsl:value-of select="$pos" /> -->
			<xsl:variable name="sectionNum_">
				<xsl:choose>
					<xsl:when test="$sectionNum"><xsl:value-of select="$sectionNum"/></xsl:when>
					<xsl:when test="$sectionNumSkew != 0">
						<xsl:variable name="number"><xsl:number count="gb:sections/gb:clause | gb:sections/gb:terms"/></xsl:variable>
						<xsl:value-of select="$number + $sectionNumSkew"/>
					</xsl:when>
				</xsl:choose>
			</xsl:variable>
			<xsl:if test="not(gb:title)">
				<fo:block margin-top="3pt" margin-bottom="12pt">
					<xsl:value-of select="$sectionNum_"/><xsl:number format=".1 " level="multiple" count="gb:clause" />
				</fo:block>
			</xsl:if>
			<xsl:apply-templates>
				<xsl:with-param name="sectionNum" select="$sectionNum_"/>
			</xsl:apply-templates>
		</fo:block>
	</xsl:template>
	
	
	<xsl:template match="gb:clause//gb:clause[not(gb:title)]">
		<xsl:param name="sectionNum"/>
		<xsl:variable name="section">
			<xsl:call-template name="getSection">
				<xsl:with-param name="sectionNum" select="$sectionNum"/>
			</xsl:call-template>
		</xsl:variable>
		<fo:block margin-top="6pt" margin-bottom="6pt" keep-with-next="always">
			<fo:inline font-family="SimHei">
				<xsl:value-of select="$section"/><xsl:text>.</xsl:text>
			</fo:inline>			
		</fo:block>
		<xsl:apply-templates>
			<xsl:with-param name="sectionNum" select="$sectionNum"/>
		</xsl:apply-templates>
	</xsl:template>
	
	
	<xsl:template match="gb:title">
		<xsl:param name="sectionNum"/>
		
		<xsl:variable name="parent-name"  select="local-name(..)"/>
		<xsl:variable name="references_num_current">
			<xsl:number level="any" count="gb:references"/>
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
		
		<xsl:variable name="font-family">
			<xsl:choose>
				<xsl:when test="ancestor::gb:annex and $level &gt;= 3">SimSun</xsl:when>
				<xsl:otherwise>SimHei</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="font-size">
			<xsl:choose>
				<xsl:when test="ancestor::gb:preface">16pt</xsl:when>
				<xsl:otherwise>10.5pt</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="element-name">
			<xsl:choose>
				<xsl:when test="../@inline-header = 'true'">fo:inline</xsl:when>
				<xsl:otherwise>fo:block</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="$parent-name = 'annex'">
				<fo:block id="{$id}" font-family="{$font-family}" font-size="{$font-size}"  text-align="center" margin-bottom="12pt" keep-with-next="always">
					<xsl:value-of select="$section"/>
					<xsl:if test=" ../@obligation">
						<xsl:value-of select="$linebreak"/>
						<fo:inline font-weight="normal">
							<xsl:text>(</xsl:text>
							<xsl:variable name="obligation" select="../@obligation"/>
							<xsl:variable name="title-obligation-normative">
								<xsl:call-template name="getTitle">
									<xsl:with-param name="name" select="'title-obligation-normative'"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:choose>
								<xsl:when test="$obligation = 'normative'"><xsl:value-of select="$title-obligation-normative"/></xsl:when>
								<xsl:otherwise><xsl:value-of select="$obligation"/></xsl:otherwise>
							</xsl:choose>							
							<xsl:text>)</xsl:text>
						</fo:inline>
					</xsl:if>
					<fo:block margin-top="14pt" margin-bottom="24pt"><xsl:apply-templates /></fo:block>
				</fo:block>
			</xsl:when>
			<xsl:when test="$parent-name = 'references' and $references_num_current != 1"> <!-- Bibliography -->
				<fo:block id="{$id}" font-family="{$font-family}" text-align="center" margin-top="6pt" margin-bottom="16pt" keep-with-next="always">
					<xsl:apply-templates />
				</fo:block>
			</xsl:when>
			
			<xsl:otherwise>
				<xsl:element name="{$element-name}">
					<xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute>
					<xsl:attribute name="font-size"><xsl:value-of select="$font-size"/></xsl:attribute>
					<xsl:attribute name="font-family"><xsl:value-of select="$font-family"/></xsl:attribute>
					<xsl:attribute name="margin-top">
						<xsl:choose>
							<xsl:when test="ancestor::gb:preface">8pt</xsl:when>
							<xsl:when test="$level = 2 and ancestor::gb:annex">10pt</xsl:when>
							<xsl:when test="$level = 1">16pt</xsl:when>
							<xsl:when test="$level = ''">6pt</xsl:when>
							<xsl:otherwise>12pt</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="margin-bottom">
						<xsl:choose>
							<xsl:when test="ancestor::gb:preface">24pt</xsl:when>
							<xsl:when test="$level = 1">16pt</xsl:when>
							<xsl:otherwise>8pt</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="keep-with-next">always</xsl:attribute>		
					<xsl:if test="ancestor::gb:preface">
						<xsl:attribute name="text-align">center</xsl:attribute>
						<xsl:attribute name="font-family">SimHei</xsl:attribute>
					</xsl:if>
					<xsl:if test="$element-name = 'fo:inline'">
						<xsl:attribute name="padding-left">7.4mm</xsl:attribute>
					</xsl:if>
						
					<xsl:value-of select="$section"/>
					<xsl:if test="$section != ''">.&#x3000;</xsl:if>
					
					<xsl:apply-templates />
				</xsl:element>
				
				<xsl:if test="$element-name = 'fo:inline' and not(following-sibling::gb:p)">
					<!-- <fo:block> -->
						<xsl:value-of select="$linebreak"/>
					<!-- </fo:block> -->
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>		
	</xsl:template>
	

	
	<xsl:template match="gb:p">
		<xsl:param name="inline" select="'false'"/>
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
			<xsl:attribute name="text-align">
				<xsl:choose>
					<xsl:when test="@align"><xsl:value-of select="@align"/></xsl:when>
					<xsl:when test="ancestor::gb:td/@align"><xsl:value-of select="ancestor::gb:td/@align"/></xsl:when>
					<xsl:when test="ancestor::gb:th/@align"><xsl:value-of select="ancestor::gb:th/@align"/></xsl:when>
					<xsl:otherwise>justify</xsl:otherwise><!-- left -->
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="text-indent">
				<xsl:choose>
					<xsl:when test="parent::gb:li">0mm</xsl:when>
					<xsl:when test="parent::gb:dd">0mm</xsl:when>
					<xsl:otherwise>7.4mm</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:if test="parent::gb:dd and ancestor::*[local-name()='formula']">
				<xsl:text>— </xsl:text>
			</xsl:if>
			<xsl:apply-templates />
		</xsl:element>
		<xsl:if test="$element-name = 'fo:inline' and not($inline = 'true') and not(local-name(..) = 'admonition')">
			<xsl:choose>
				<xsl:when test="ancestor::gb:annex">
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
	
	<xsl:template match="gb:li//gb:p//text()">
		<xsl:choose>
			<xsl:when test="contains(., '&#x9;')">
				<fo:inline white-space="pre"><xsl:value-of select="."/></fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
	<!--
	<fn reference="1">
			<p id="_8e5cf917-f75a-4a49-b0aa-1714cb6cf954">Formerly denoted as 15 % (m/m).</p>
		</fn>
	-->
	
	<xsl:variable name="p_fn">
		<xsl:for-each select="//gb:p/gb:fn[generate-id(.)=generate-id(key('kfn',@reference)[1])]">
			<!-- copy unique fn -->
			<fn gen_id="{generate-id(.)}">
				<xsl:copy-of select="@*"/>
				<xsl:copy-of select="node()"/>
			</fn>
		</xsl:for-each>
	</xsl:variable>
	
	<xsl:template match="gb:p/gb:fn" priority="2">
		<xsl:variable name="gen_id" select="generate-id(.)"/>
		<xsl:variable name="reference" select="@reference"/>
		<xsl:variable name="number">
			<xsl:value-of select="count(xalan:nodeset($p_fn)//fn[@reference = $reference]/preceding-sibling::fn) + 1" />
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="xalan:nodeset($p_fn)//fn[@gen_id = $gen_id]">
				<fo:footnote>
					<fo:inline font-size="60%" keep-with-previous.within-line="always" vertical-align="super">
						<fo:basic-link internal-destination="footnote_{@reference}_{$number}" fox:alt-text="footnote {@reference} {$number}">
							<!-- <xsl:value-of select="@reference"/> -->
							<xsl:value-of select="$number + count(//gb:bibitem[ancestor::gb:references[@id='_normative_references' or not(preceding-sibling::gb:references)]]/gb:note)"/>
						</fo:basic-link>
					</fo:inline>
					<fo:footnote-body>
						<fo:block font-size="9pt" margin-bottom="12pt">
							<fo:inline font-size="50%" id="footnote_{@reference}_{$number}" keep-with-next.within-line="always" vertical-align="super">
								<xsl:value-of select="$number + count(//gb:bibitem[ancestor::gb:references[@id='_normative_references' or not(preceding-sibling::gb:references)]]/gb:note)"/>
							</fo:inline>
							<xsl:for-each select="gb:p">
									<xsl:apply-templates />
							</xsl:for-each>
						</fo:block>
					</fo:footnote-body>
				</fo:footnote>
			</xsl:when>
			<xsl:otherwise>
				<fo:inline font-size="50%" keep-with-previous.within-line="always" vertical-align="super">
					<fo:basic-link internal-destination="footnote_{@reference}_{$number}" fox:alt-text="footnote {@reference} {$number}">
						<xsl:value-of select="$number + count(//gb:bibitem/gb:note)"/>
					</fo:basic-link>
				</fo:inline>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="gb:p/gb:fn/gb:p">
		<xsl:apply-templates />
	</xsl:template>
	
	<xsl:template match="gb:review">
		<!-- comment 2019-11-29 -->
		<!-- <fo:block font-weight="bold">Review:</fo:block>
		<xsl:apply-templates /> -->
	</xsl:template>

	<xsl:template match="text()">
		<xsl:value-of select="."/>
	</xsl:template>

	<xsl:template match="gb:image">
		<fo:block-container text-align="center">
			<fo:block>
				<fo:external-graphic src="{@src}" fox:alt-text="Image {@alt}"/>
			</fo:block>
			<fo:block font-family="SimHei" margin-top="12pt" margin-bottom="12pt">
				<xsl:variable name="title-figure">
					<xsl:call-template name="getTitle">
						<xsl:with-param name="name" select="'title-figure'"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:value-of select="$title-figure"/>
				<xsl:call-template name="getFigureNumber"/>
			</fo:block>
		</fo:block-container>
	</xsl:template>

	<xsl:template match="gb:figure">
		<fo:block-container id="{@id}">
			<fo:block>
				<xsl:apply-templates />
			</fo:block>
			<xsl:call-template name="fn_display_figure"/>
			<xsl:for-each select="gb:note//gb:p">
				<xsl:call-template name="note"/>
			</xsl:for-each>
			<fo:block font-family="SimHei" text-align="center" margin-top="12pt" margin-bottom="12pt" keep-with-previous="always">
				<xsl:call-template name="getFigureNumber"/>
				<xsl:if test="gb:name">
					<!-- <xsl:if test="not(local-name(..) = 'figure')"> -->
						<xsl:text> — </xsl:text>
					<!-- </xsl:if> -->
					<xsl:value-of select="gb:name"/>
				</xsl:if>
			</fo:block>
		</fo:block-container>
	</xsl:template>
	
	<xsl:template name="getFigureNumber">
		<xsl:variable name="title-figure">
			<xsl:call-template name="getTitle">
				<xsl:with-param name="name" select="'title-figure'"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="ancestor::gb:annex">
				<xsl:value-of select="$title-figure"/><xsl:number format="A.1-1" level="multiple" count="gb:annex | gb:figure"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$title-figure"/><xsl:number format="1" level="any"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="gb:figure/gb:name"/>
	<xsl:template match="gb:figure/gb:fn" priority="2"/>
	<xsl:template match="gb:figure/gb:note"/>
	
	
	<xsl:template match="gb:figure/gb:image">
		<fo:block text-align="center">
			<xsl:variable name="src">
				<xsl:choose>
					<xsl:when test="@mimetype = 'image/svg+xml' and $images/images/image[@id = current()/@id]">
						<xsl:value-of select="$images/images/image[@id = current()/@id]/@src"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="@src"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>		
			<fo:external-graphic  src="{$src}" width="100%" content-height="100%" content-width="scale-to-fit" scaling="uniform" fox:alt-text="Image {@alt}"/>  <!-- src="{@src}" -->
		</fo:block>
	</xsl:template>
	
	
	<xsl:template match="gb:bibitem">
		<fo:block id="{@id}" font-size="11pt" margin-bottom="12pt" text-indent="-11.7mm" margin-left="11.7mm"> <!-- 12 pt -->
				<!-- gb:docidentifier -->
			<xsl:if test="gb:docidentifier">
				<xsl:choose>
					<xsl:when test="gb:docidentifier/@type = 'metanorma'"/>
					<xsl:otherwise><fo:inline><xsl:value-of select="gb:docidentifier"/></fo:inline></xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:apply-templates select="gb:note"/>
			<xsl:if test="gb:docidentifier">, </xsl:if>
			<fo:inline font-style="italic">
				<xsl:choose>
					<xsl:when test="gb:title[@type = 'main' and @language = 'en']">
						<xsl:value-of select="gb:title[@type = 'main' and @language = 'en']"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="gb:title"/>
					</xsl:otherwise>
				</xsl:choose>
			</fo:inline>
		</fo:block>
	</xsl:template>
	
	
	<xsl:template match="gb:bibitem/gb:note">
		<fo:footnote>
			<xsl:variable name="number">
				<xsl:number level="any" count="gb:bibitem/gb:note"/>
			</xsl:variable>
			<fo:inline font-size="50%" keep-with-previous.within-line="always" baseline-shift="30%">
				<fo:basic-link internal-destination="{generate-id()}" fox:alt-text="footnote {$number}">
					<xsl:value-of select="$number"/>
				</fo:basic-link>
			</fo:inline>
			<fo:footnote-body>
				<fo:block font-size="9pt" margin-bottom="4pt" start-indent="0pt" text-indent="7.4mm">
					<fo:inline font-size="50%" id="{generate-id()}" keep-with-next.within-line="always" baseline-shift="30%"><!-- alignment-baseline="hanging" font-size="60%"  -->
						<xsl:value-of select="$number"/>
					</fo:inline>
					<xsl:apply-templates />
				</fo:block>
			</fo:footnote-body>
		</fo:footnote>
	</xsl:template>
	
	
	
	<xsl:template match="gb:ul | gb:ol">
		<fo:list-block margin-bottom="12pt" margin-left="7.4mm" provisional-distance-between-starts="4mm"> <!--   margin-bottom="8pt" -->
			<xsl:if test="local-name() = 'ol'">
				<xsl:attribute name="provisional-distance-between-starts">7mm</xsl:attribute>
			</xsl:if>			
			<xsl:apply-templates />
		</fo:list-block>
		<xsl:for-each select="./gb:note//gb:p">
			<xsl:call-template name="note"/>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="gb:ul//gb:note |  gb:ol//gb:note"/>
	
	<xsl:template match="gb:li">
		<fo:list-item id="{@id}">
			<fo:list-item-label end-indent="label-end()">
				<fo:block>
					<xsl:call-template name="getListItemFormat"/>
				</fo:block>
			</fo:list-item-label>
			<fo:list-item-body start-indent="body-start()">
				<xsl:apply-templates />
				<xsl:apply-templates select=".//gb:note" mode="process"/>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>
	
	
	<xsl:template match="gb:term">
		<xsl:param name="sectionNum"/>
		<fo:block id="{@id}" font-family="SimHei" font-size="11pt" keep-with-next="always" margin-top="10pt" margin-bottom="8pt" line-height="1.1">
			<fo:inline>
				<xsl:variable name="section">
					<xsl:for-each select="*[1]">
						<xsl:call-template name="getSection">
							<xsl:with-param name="sectionNum" select="$sectionNum"/>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:variable>
				<xsl:value-of select="$section"/><xsl:text>.</xsl:text>
			</fo:inline>
		</fo:block>
		<fo:block>
			<xsl:apply-templates>
				<xsl:with-param name="sectionNum" select="$sectionNum"/>
			</xsl:apply-templates>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="gb:preferred">
		<xsl:param name="sectionNum"/>

		<fo:inline font-family="SimHei" font-size="11pt">
			<xsl:if test="not(preceding-sibling::*[1][local-name() = 'preferred'])">
				<xsl:attribute name="padding-left">7.4mm</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates /><xsl:text>&#x3000;</xsl:text>
		</fo:inline>
		
		<xsl:if test="not(following-sibling::*[1][local-name() = 'preferred'])">
			<xsl:value-of select="$linebreak"/>
		</xsl:if>

	</xsl:template>
	
	<xsl:template match="gb:admitted">
		<xsl:param name="sectionNum"/>
		
		<fo:inline font-size="11pt">
			<xsl:if test="not(preceding-sibling::*[1][local-name() = 'admitted'])">
				<xsl:attribute name="padding-left">7.4mm</xsl:attribute>
			</xsl:if>			
			<xsl:apply-templates /><xsl:text>&#x3000;</xsl:text>
		</fo:inline>
		
		<xsl:if test="not(following-sibling::*[1][local-name() = 'admitted'])">
			<xsl:value-of select="$linebreak"/>
		</xsl:if>
			
	</xsl:template>
	
	<xsl:template match="gb:deprecates">
		<xsl:param name="sectionNum"/>		
		<fo:inline font-size="11pt">
			<xsl:if test="not(preceding-sibling::*[1][local-name() = 'deprecates'])">
				<xsl:attribute name="padding-left">7.4mm</xsl:attribute>
				<xsl:variable name="title-deprecated">
					<xsl:call-template name="getTitle">
						<xsl:with-param name="name" select="'title-deprecated'"/>
					</xsl:call-template>
				</xsl:variable>
				<fo:inline><xsl:value-of select="$title-deprecated"/>: </fo:inline>
			</xsl:if>
			<xsl:apply-templates />
		</fo:inline>
		<xsl:if test="not(following-sibling::*[1][local-name() = 'deprecates'])">
			<xsl:value-of select="$linebreak"/>
		</xsl:if>
		
	</xsl:template>
	
	<xsl:template match="gb:definition[preceding-sibling::gb:domain]">
		<xsl:apply-templates />
	</xsl:template>
	<xsl:template match="gb:definition[preceding-sibling::gb:domain]/gb:p">
		<fo:inline> <xsl:apply-templates /></fo:inline>
		<fo:block>&#xA0;</fo:block>
	</xsl:template>
	
	<xsl:template match="gb:definition">
		<fo:block>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="gb:termsource">
		<fo:block text-indent="7.4mm"> 
			<!-- Example: [SOURCE: ISO 5127:2017, 3.1.6.02] -->
			<fo:basic-link internal-destination="{gb:origin/@bibitemid}" fox:alt-text="{gb:origin/@citeas}">
				<xsl:text>[</xsl:text> <!-- SOURCE:  -->
				<xsl:value-of select="gb:origin/@citeas"/>
				
				<xsl:apply-templates select="gb:origin/gb:localityStack"/>
				
			</fo:basic-link>
			<xsl:apply-templates select="gb:modification"/>
			<xsl:text>]</xsl:text>
		</fo:block>
	</xsl:template>
	

	<xsl:template match="gb:modification/gb:p">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="gb:modification/text()">
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="gb:termnote">
		<fo:block-container font-size="9pt" margin-left="7.4mm" margin-top="4pt" line-height="125%">
			<fo:block-container margin-left="0mm">
				<fo:table table-layout="fixed" width="100%">
					<fo:table-column column-width="27mm"/>
					<fo:table-column column-width="138mm"/>
					<fo:table-body>
						<fo:table-row>
							<fo:table-cell>
								<fo:block font-family="SimHei">
									<xsl:variable name="num"><xsl:number /></xsl:variable>			
									<xsl:variable name="title-note-to-entry">
										<xsl:call-template name="getTitle">
											<xsl:with-param name="name" select="'title-note-to-entry'"/>
										</xsl:call-template>
									</xsl:variable>
									<xsl:value-of select="java:replaceAll(java:java.lang.String.new($title-note-to-entry),'#',$num)"/>									
								</fo:block>
							</fo:table-cell>
							<fo:table-cell>
								<fo:block>
									<xsl:apply-templates />
								</fo:block>
							</fo:table-cell>
						</fo:table-row>
					</fo:table-body>
				</fo:table>
			</fo:block-container>
		</fo:block-container>
	</xsl:template>
	
	<xsl:template match="gb:termnote/gb:p">
		<fo:inline><xsl:apply-templates/></fo:inline>		
	</xsl:template>
	
	<xsl:template match="gb:domain">
		<fo:inline padding-left="7.4mm">&lt;<xsl:apply-templates/>&gt; </fo:inline>
	</xsl:template>
	
	
	<xsl:template match="gb:termexample">
		<fo:block font-size="9pt" margin-top="14pt" margin-bottom="14pt"  text-align="justify">
			<fo:inline padding-right="1mm" font-family="SimHei">
				<xsl:variable name="title-example">
					<xsl:call-template name="getTitle">
						<xsl:with-param name="name" select="'title-example'"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:value-of select="$title-example"/>
				<xsl:if test="count(ancestor::gb:term[1]//gb:termexample) &gt; 1">
					<xsl:number />
				</xsl:if>
				<xsl:text>:</xsl:text>
			</fo:inline>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="gb:termexample/gb:p">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template>

	
	<xsl:template match="gb:annex">
		<fo:block break-after="page"/>
		<xsl:apply-templates />
	</xsl:template>

	
	<!-- <xsl:template match="gb:references[@id = '_bibliography']"> -->
	<xsl:template match="gb:references[position() &gt; 1]">
		<fo:block break-after="page"/>
		<xsl:apply-templates />
		<fo:block-container text-align="center">
			<fo:block-container margin-left="63mm" width="42mm" border-bottom="2pt solid black">
				<fo:block>&#xA0;</fo:block>
			</fo:block-container>
		</fo:block-container>
	</xsl:template>


	<!-- Example: [1] ISO 9:1995, Information and documentation – Transliteration of Cyrillic characters into Latin characters – Slavic and non-Slavic languages -->
	<!-- <xsl:template match="gb:references[@id = '_bibliography']/gb:bibitem"> -->
	<xsl:template match="gb:references[position() &gt; 1]/gb:bibitem">
		<fo:list-block font-size="11pt" margin-bottom="12pt" provisional-distance-between-starts="12mm">
			<fo:list-item>
				<fo:list-item-label end-indent="label-end()">
					<fo:block>
						<fo:inline id="{@id}">
							<xsl:number format="[1]"/>
						</fo:inline>
					</fo:block>
				</fo:list-item-label>
				<fo:list-item-body start-indent="body-start()">
					<fo:block text-align="justify">
						<xsl:variable name="docidentifier">
							<xsl:if test="gb:docidentifier">
								<xsl:choose>
									<xsl:when test="gb:docidentifier/@type = 'metanorma'"/>
									<xsl:otherwise><xsl:value-of select="gb:docidentifier"/></xsl:otherwise>
								</xsl:choose>
							</xsl:if>
						</xsl:variable>
						<fo:inline><xsl:value-of select="$docidentifier"/></fo:inline>
						<xsl:apply-templates select="gb:note"/>
						<xsl:if test="normalize-space($docidentifier) != ''">, </xsl:if>
						<xsl:choose>
							<xsl:when test="gb:title[@type = 'main' and @language = 'en']">
								<xsl:apply-templates select="gb:title[@type = 'main' and @language = 'en']"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates select="gb:title"/>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:apply-templates select="gb:formattedref"/>
					</fo:block>
				</fo:list-item-body>
			</fo:list-item>
		</fo:list-block>
	</xsl:template>
	
	<!-- <xsl:template match="gb:references[@id = '_bibliography']/gb:bibitem" mode="contents"/> -->
	<xsl:template match="gb:references[position() &gt; 1]/gb:bibitem" mode="contents"/>
	
	<!-- <xsl:template match="gb:references[@id = '_bibliography']/gb:bibitem/gb:title"> -->
	<xsl:template match="gb:references[position() &gt; 1]/gb:bibitem/gb:title">
		<fo:inline font-style="italic">
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>

	<xsl:template match="gb:quote">
		<fo:block margin-top="12pt" margin-left="12mm" margin-right="12mm">
			<xsl:apply-templates select=".//gb:p"/>
		</fo:block>
		<fo:block text-align="right">
			<!-- — ISO, ISO 7301:2011, Clause 1 -->
			<xsl:text>— </xsl:text><xsl:value-of select="gb:author"/>
			<xsl:if test="gb:source">
				<xsl:text>, </xsl:text>
				<xsl:apply-templates select="gb:source"/>
			</xsl:if>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="gb:source">
		<fo:basic-link internal-destination="{@bibitemid}" fox:alt-text="{@citeas}">
			<xsl:value-of select="@citeas"/> <!--  disable-output-escaping="yes" -->
			<xsl:apply-templates select="gb:localityStack"/>
		</fo:basic-link>
	</xsl:template>
	

	<xsl:template match="mathml:math" priority="2">
		<fo:inline font-family="Cambria Math">
			<fo:instream-foreign-object fox:alt-text="Math">
				<xsl:copy-of select="."/>
			</fo:instream-foreign-object>
		</fo:inline>
	</xsl:template>
	

	
	<xsl:template match="gb:example/gb:p">
		<fo:block font-size="10pt" margin-top="8pt" margin-bottom="8pt">
			<!-- <xsl:if test="ancestor::gb:li">
				<xsl:attribute name="font-size">11pt</xsl:attribute>
			</xsl:if> -->
			<xsl:variable name="claims_id" select="ancestor::gb:clause[1]/@id"/>
			<fo:inline padding-right="5mm">
				<xsl:variable name="title-example">
					<xsl:call-template name="getTitle">
						<xsl:with-param name="name" select="'title-example'"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:value-of select="$title-example"/>
				<xsl:if test="count(ancestor::gb:clause[1]//gb:example) &gt; 1">
					<xsl:number count="gb:example[ancestor::gb:clause[@id = $claims_id]]" level="any"/>
				</xsl:if>
			</fo:inline>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="gb:note/gb:p" name="note">
		<xsl:variable name="claims_id" select="ancestor::gb:clause[1]/@id"/>
		<fo:block-container font-size="9pt" margin-left="7.4mm" margin-top="4pt" line-height="125%">
			<fo:block-container margin-left="0mm">
				<fo:table table-layout="fixed" width="100%">
					<fo:table-column column-width="10mm"/>
					<fo:table-column column-width="155mm"/>
					<fo:table-body>
						<fo:table-row>
							<fo:table-cell>
								<fo:block font-family="SimHei">
									<xsl:variable name="title-note">
										<xsl:call-template name="getTitle">
											<xsl:with-param name="name" select="'title-note'"/>
										</xsl:call-template>
									</xsl:variable>
									<xsl:value-of select="normalize-space($title-note)"/>									
									<xsl:if test="count(ancestor::gb:clause[1]//gb:note) &gt; 1">
										<xsl:text> </xsl:text><xsl:number count="gb:note[ancestor::gb:clause[@id = $claims_id]]" level="any"/>
									</xsl:if>
									<xsl:text>:</xsl:text>
								</fo:block>
							</fo:table-cell>
							<fo:table-cell>
								<fo:block text-align="justify">
									<xsl:apply-templates />
								</fo:block>
							</fo:table-cell>
						</fo:table-row>
					</fo:table-body>
				</fo:table>
			</fo:block-container>
		</fo:block-container>
	</xsl:template>

	<!-- <eref type="inline" bibitemid="IEC60050-113" citeas="IEC 60050-113:2011"><localityStack><locality type="clause"><referenceFrom>113-01-12</referenceFrom></locality></localityStack></eref> -->
	<xsl:template match="gb:eref">
		<fo:basic-link internal-destination="{@bibitemid}" fox:alt-text="{@citeas}"> <!-- font-size="9pt" color="blue" vertical-align="super" -->
			<xsl:if test="@type = 'footnote'">
				<xsl:attribute name="keep-together.within-line">always</xsl:attribute>
				<xsl:attribute name="font-size">50%</xsl:attribute>
				<xsl:attribute name="keep-with-previous.within-line">always</xsl:attribute>
				<xsl:attribute name="vertical-align">super</xsl:attribute>
			</xsl:if>
			<!-- <xsl:if test="@type = 'inline'">
				<xsl:attribute name="color">blue</xsl:attribute>
				<xsl:attribute name="text-decoration">underline</xsl:attribute>
			</xsl:if> -->
			
			<xsl:choose>
				<xsl:when test="@citeas and normalize-space(text()) = ''">
					<xsl:value-of select="@citeas"/> <!--  disable-output-escaping="yes" -->
				</xsl:when>
				<xsl:when test="@bibitemid and normalize-space(text()) = ''">
					<xsl:value-of select="//gb:bibitem[@id = current()/@bibitemid]/gb:docidentifier"/>
				</xsl:when>
				<xsl:otherwise></xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates select="gb:localityStack"/>
			<xsl:apply-templates select="text()"/>
		</fo:basic-link>
	</xsl:template>
	
	<xsl:template match="gb:locality">
		<xsl:variable name="title-clause">
			<xsl:call-template name="getTitle">
				<xsl:with-param name="name" select="'title-clause'"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="title-annex">
			<xsl:call-template name="getTitle">
				<xsl:with-param name="name" select="'title-annex'"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="title-table">
			<xsl:call-template name="getTitle">
				<xsl:with-param name="name" select="'title-table'"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="@type ='section' and ancestor::gb:termsource">SOURCE Section </xsl:when>
			<xsl:when test="ancestor::gb:termsource"></xsl:when>
			<xsl:when test="@type ='clause' and ancestor::gb:eref"></xsl:when>
			<xsl:when test="@type ='clause'"><xsl:value-of select="$title-clause"/></xsl:when>
			<xsl:when test="@type ='annex'"><xsl:value-of select="$title-annex"/></xsl:when>
			<xsl:when test="@type ='table'"><xsl:value-of select="$title-table"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="@type"/></xsl:otherwise>
		</xsl:choose>
		<xsl:text> </xsl:text><xsl:value-of select="gb:referenceFrom"/>
	</xsl:template>
	
	<xsl:template match="gb:admonition">
		<xsl:variable name="title-caution">
			<xsl:call-template name="getTitle">
				<xsl:with-param name="name" select="'title-caution'"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="title-warning">
			<xsl:call-template name="getTitle">
				<xsl:with-param name="name" select="'title-warning'"/>
			</xsl:call-template>
		</xsl:variable>
		<fo:block font-family="SimHei" text-align="center" margin-bottom="12pt" font-weight="bold">
			<xsl:choose>
				<xsl:when test="@type = 'caution'"><xsl:value-of select="$title-caution"/></xsl:when>
				<xsl:when test="@type = 'warning'"><xsl:value-of select="$title-warning"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="java:toUpperCase(java:java.lang.String.new(@type))"/></xsl:otherwise>
			</xsl:choose>			
		</fo:block>
		<fo:block font-weight="bold">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="gb:formula">
		<fo:block id="{@id}">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	

	<xsl:template match="gb:formula/gb:stem">
		<fo:block font-size="11pt" margin-top="14pt" margin-bottom="14pt">
			<fo:table table-layout="fixed" width="170mm">
				<fo:table-column column-width="165mm"/>
				<fo:table-column column-width="5mm"/>
				<fo:table-body>
					<fo:table-row>
						<fo:table-cell display-align="center">
							<fo:block text-align="center">
								<xsl:apply-templates />
							</fo:block>
						</fo:table-cell>
						<fo:table-cell display-align="center">
							<fo:block text-align="left">
								<xsl:apply-templates select="../gb:name" mode="formula"/>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</fo:table-body>
			</fo:table>			
		</fo:block>
	</xsl:template>
	
	
	<xsl:template match="gb:br" priority="2">
		<!-- <fo:block>&#xA0;</fo:block> -->
		<xsl:value-of select="$linebreak"/>
	</xsl:template>
	
	<xsl:template name="insertHeaderFooter">
		<fo:static-content flow-name="header">
			<fo:block-container height="30mm" display-align="after">
				<fo:block font-family="SimHei" font-size="12pt">
					<xsl:value-of select="/gb:gb-standard/gb:bibdata/gb:docidentifier[@type = 'gb']"/>
					<xsl:text>—</xsl:text>
					<xsl:value-of select="/gb:gb-standard/gb:bibdata/gb:copyright/gb:from"/>
				</fo:block>
			</fo:block-container>
		</fo:static-content>
		<fo:static-content flow-name="footer-odd">
			<fo:block-container height="100%" display-align="after">
				<fo:block-container height="14.5mm" display-align="before">
					<fo:block font-size="9pt" text-align="right" margin-right="3.5mm">
						<fo:page-number/>
					</fo:block>
				</fo:block-container>
			</fo:block-container>
		</fo:static-content>
		<fo:static-content flow-name="footer-even">
			<fo:block-container height="100%" display-align="after">
				<fo:block-container height="14.5mm" display-align="before">
					<fo:block font-size="9pt">
						<fo:page-number/>
					</fo:block>
				</fo:block-container>
			</fo:block-container>
		</fo:static-content>
	</xsl:template>
	

	<xsl:template name="getSection">
		<xsl:param name="sectionNum"/>
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		<xsl:variable name="section">
			<xsl:choose>
				<xsl:when test="ancestor::gb:bibliography">
					<xsl:value-of select="$sectionNum"/>
				</xsl:when>
				<xsl:when test="ancestor::gb:sections">
					<!-- 1, 2, 3, 4, ... from main section (not annex, bibliography, ...) -->
					<xsl:choose>
						<xsl:when test="$level = 1">
							<xsl:value-of select="$sectionNum"/>
						</xsl:when>
						<xsl:when test="$level &gt;= 2">
							<xsl:variable name="num">
								<xsl:call-template name="getSubSection"/>								
							</xsl:variable>
							<xsl:value-of select="concat($sectionNum, $num)"/>
						</xsl:when>
						<xsl:otherwise>
							<!-- z<xsl:value-of select="$sectionNum"/>z -->
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>				
				<xsl:when test="ancestor::gb:annex">
					<xsl:variable name="annexid" select="normalize-space(/gb:gb-standard/gb:bibdata/gb:ext/gb:structuredidentifier/gb:annexid)"/>
					<xsl:choose>
						<xsl:when test="$level = 1">
							<xsl:variable name="title-annex">
								<xsl:call-template name="getTitle">
									<xsl:with-param name="name" select="'title-annex'"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:value-of select="$title-annex"/>							
							<xsl:choose>
								<xsl:when test="count(//gb:annex) = 1 and $annexid != ''">
									<xsl:value-of select="$annexid"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:number format="A" level="any" count="gb:annex"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="count(//gb:annex) = 1 and $annexid != ''">
									<xsl:value-of select="$annexid"/><xsl:number format=".1" level="multiple" count="gb:clause"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:number format="A.1" level="multiple" count="gb:annex | gb:clause"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="ancestor::gb:preface"> <!-- if preface and there is clause(s) -->
					<xsl:choose>
						<xsl:when test="$level = 1 and  ..//gb:clause">0</xsl:when>
						<xsl:when test="$level &gt;= 2">
							<xsl:variable name="num">
								<xsl:number format=".1" level="multiple" count="gb:clause"/>
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

<!-- 	<xsl:variable name="Image-GB-Logo">
		<xsl:text>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</xsl:text>
	</xsl:variable> -->
	
	<xsl:template name="addLetterSpacing">
		<xsl:param name="text"/>
		<xsl:param name="letter-spacing" select="'0.15'"/>
		<xsl:if test="string-length($text) &gt; 0">
			<xsl:variable name="char" select="substring($text, 1, 1)"/>
			<fo:inline padding-right="{$letter-spacing}mm"><xsl:value-of select="$char"/></fo:inline>
			<xsl:call-template name="addLetterSpacing">
				<xsl:with-param name="text" select="substring($text, 2)"/>
				<xsl:with-param name="letter-spacing" select="$letter-spacing"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
</xsl:stylesheet>
