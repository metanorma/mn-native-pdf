<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
											xmlns:fo="http://www.w3.org/1999/XSL/Format" 
											xmlns:mn="https://www.metanorma.org/ns/standoc" 
											xmlns:mnx="https://www.metanorma.org/ns/xslt" 
											xmlns:mathml="http://www.w3.org/1998/Math/MathML" 
											xmlns:xalan="http://xml.apache.org/xalan" 
											xmlns:fox="http://xmlgraphics.apache.org/fop/extensions" 
											xmlns:pdf="http://xmlgraphics.apache.org/fop/extensions/pdf"
											xmlns:xlink="http://www.w3.org/1999/xlink"
											xmlns:java="http://xml.apache.org/xalan/java"
											xmlns:barcode="http://barcode4j.krysalis.org/ns" 
											xmlns:redirect="http://xml.apache.org/xalan/redirect"
											exclude-result-prefixes="java"
											extension-element-prefixes="redirect"
											version="1.0">

	<xsl:output method="xml" encoding="UTF-8" indent="no"/>

	<xsl:key name="kfn" match="mn:fn[not(ancestor::*[self::mn:table or self::mn:figure or self::mn:localized-strings] and not(ancestor::mn:fmt-name))]" use="@reference"/>
	
	<xsl:key name="kid" match="*" use="@id"/>
	
	<xsl:key name="attachments" match="mn:fmt-eref[java:endsWith(java:java.lang.String.new(@bibitemid),'.exp')]" use="@bibitemid"/>
	<xsl:key name="attachments2" match="mn:fmt-eref[contains(@bibitemid,'.exp_')]" use="@bibitemid"/>
	
	<xsl:variable name="namespace">iso</xsl:variable>
	
	<xsl:variable name="debug">false</xsl:variable>
	
	<xsl:variable name="column_gap">8.5mm</xsl:variable>
	
	<xsl:variable name="docidentifier_iso" select="/mn:metanorma/mn:bibdata/mn:docidentifier[@type = 'iso'] | /mn:metanorma/mn:bibdata/mn:docidentifier[@type = 'ISO']"/>
	
	<xsl:variable name="docidentifier_undated_" select="normalize-space(/mn:metanorma/mn:bibdata/mn:docidentifier[@type = 'iso-undated'])"/>
	<xsl:variable name="docidentifier_undated"><xsl:value-of select="$docidentifier_undated_"/><xsl:if test="$docidentifier_undated_ = ''"><xsl:value-of select="$docidentifier_iso"/></xsl:if></xsl:variable>
	<xsl:variable name="docidentifierISO_undated_">
		<xsl:if test="not($stage-abbreviation = 'FDAMD' or $stage-abbreviation = 'FDAM' or $stage-abbreviation = 'DAMD' or $stage-abbreviation = 'DAM')">
			<xsl:value-of select="$docidentifier_undated_"/>
		</xsl:if>
	</xsl:variable>
	<xsl:variable name="docidentifierISO_undated" select="normalize-space($docidentifierISO_undated_)"/>
	<xsl:variable name="docidentifierISO_">
		<xsl:value-of select="$docidentifierISO_undated"/>
		<xsl:if test="$docidentifierISO_undated = ''">
			<xsl:value-of select="$docidentifier_iso"/>
		</xsl:if>
	</xsl:variable>
	<xsl:variable name="docidentifierISO" select="normalize-space($docidentifierISO_)"/>
	<xsl:variable name="docidentifierISO_with_break" select="java:replaceAll(java:java.lang.String.new($docidentifierISO),'^([^\d]+) (\d)', concat('$1', $linebreak, '$2'))"/> <!-- add line break before 1st sequence 'space digit' -->

	<xsl:variable name="docidentifier_another_">
		<xsl:for-each select="/mn:metanorma/mn:bibdata/mn:docidentifier[@type != '' and @type != 'ISO' and not(starts-with(@type, 'iso-')) and @type != 'URN']">
			<xsl:value-of select="."/>
			<xsl:if test="position() != last()"><xsl:value-of select="$linebreak"/></xsl:if>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="docidentifier_another">
		<xsl:if test="normalize-space($docidentifier_another_) != ''">
			<fo:block margin-top="12pt">
				<xsl:value-of select="java:replaceAll(java:java.lang.String.new($docidentifier_another_),'^([^\d]+) (\d)', concat('$1', $linebreak, '$2'))"/>
			</fo:block>
		</xsl:if>
	</xsl:variable>

	<xsl:variable name="copyrightYear" select="/mn:metanorma/mn:bibdata/mn:copyright/mn:from"/>
	<xsl:variable name="copyrightAbbr__">
		<xsl:for-each select="/mn:metanorma/mn:bibdata/mn:copyright/mn:owner/mn:organization[normalize-space(mn:abbreviation) != 'IEEE']">
			<abbr>
				<xsl:choose>
					<xsl:when test="mn:abbreviation"><xsl:value-of select="mn:abbreviation"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="mn:name"/></xsl:otherwise>
				</xsl:choose>
			</abbr>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="copyrightAbbr_">
		<xsl:for-each select="xalan:nodeset($copyrightAbbr__)//*">
			<xsl:value-of select="."/>
			<xsl:if test="position() != last()">
				<xsl:choose>
					<xsl:when test="following-sibling::*[1]/text() = 'IDF'"> and </xsl:when>
					<xsl:otherwise>/</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="copyrightAbbr" select="normalize-space($copyrightAbbr_)"/>
	<xsl:variable name="copyrightAbbrIEEE" select="normalize-space(/mn:metanorma/mn:bibdata/mn:copyright/mn:owner/mn:organization/mn:abbreviation[. = 'IEEE'])"/>
	<xsl:variable name="copyrightText">
		<xsl:value-of select="concat('© ', $copyrightAbbr, ' ', $copyrightYear ,' – ', $i18n_all_rights_reserved)"/>
		<xsl:if test="$copyrightAbbrIEEE != ''">
			<xsl:value-of select="$linebreak"/>
			<xsl:value-of select="concat('© ', $copyrightAbbrIEEE, ' ', $copyrightYear ,' – ', $i18n_all_rights_reserved)"/>
		</xsl:if>
	</xsl:variable>
	
	<xsl:variable name="copyrightTextLastPage2024">
		<xsl:value-of select="concat('© ', $copyrightAbbr, ' ', $copyrightYear)"/>
		<xsl:if test="$copyrightAbbrIEEE != ''">
			<xsl:value-of select="$linebreak"/>
			<xsl:value-of select="concat('© ', $copyrightAbbrIEEE, ' ', $copyrightYear)"/>
		</xsl:if>
		<xsl:value-of select="$linebreak"/>
		<xsl:value-of select="$i18n_all_rights_reserved"/>
	</xsl:variable>

	<xsl:variable name="iso_reference_" select="normalize-space(/mn:metanorma/mn:bibdata/mn:docidentifier[@type = 'iso-reference'])"/>
	<xsl:variable name="iso_reference"><xsl:value-of select="$iso_reference_"/><xsl:if test="$iso_reference_ = ''"><xsl:value-of select="$docidentifier_iso"/></xsl:if></xsl:variable>
  
	<xsl:variable name="docidentifier_iso_with_lang_" select="normalize-space(/mn:metanorma/mn:bibdata/mn:docidentifier[@type = 'iso-with-lang'])"/>
	<xsl:variable name="docidentifier_iso_with_lang"><xsl:value-of select="$docidentifier_iso_with_lang_"/><xsl:if test="$docidentifier_iso_with_lang_ = ''"><xsl:value-of select="$iso_reference"/></xsl:if></xsl:variable>
	
	<xsl:variable name="lang-1st-letter_tmp" select="substring-before(substring-after($docidentifier_iso_with_lang, '('), ')')"/>
	<xsl:variable name="lang-1st-letter" select="concat('(', $lang-1st-letter_tmp , ')')"/>
  
	<xsl:variable name="anotherNumbers">
		<xsl:variable name="year_iso_reference" select="concat(':',substring-after($iso_reference,':'))"/> 
		<xsl:for-each select="/mn:metanorma/mn:bibdata/mn:docidentifier[@type != '' and @type != 'ISO' and not(starts-with(@type, 'iso-')) and @type != 'URN']">
			<xsl:value-of select="$linebreak"/><xsl:value-of select="concat(., $year_iso_reference)"/>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="ISOnumber">
		<xsl:choose>
			<xsl:when test="$layoutVersion = '2024' and $docidentifier_iso_with_lang != ''">
				<xsl:value-of select="$docidentifier_iso_with_lang"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- part separator '-' replace to '/' -->
				<xsl:variable name="iso_reference_tmp" select="java:replaceAll(java:java.lang.String.new($iso_reference),'-','/')"/>
				<xsl:choose>
					<!-- year separator replace to '-' -->
					<xsl:when test="$layoutVersion = '1951'">
						<xsl:variable name="iso_reference_tmp_" select="java:replaceAll(java:java.lang.String.new($iso_reference_tmp),':',' - ')"/>
						<!-- insert space before ( -->
						<xsl:value-of select="java:replaceAll(java:java.lang.String.new($iso_reference_tmp_),'\(',' \(')"/>
					</xsl:when>
					<xsl:when test="$layoutVersion = '1972' or $layoutVersion = '1979'">
						<xsl:value-of select="java:replaceAll(java:java.lang.String.new($iso_reference_tmp),':','-')"/>
					</xsl:when>
					<xsl:when test="$layoutVersion = '1987'">
						<!-- insert space around : -->
						<xsl:variable name="iso_reference_tmp_" select="java:replaceAll(java:java.lang.String.new($iso_reference_tmp),':',' : ')"/>
						<!-- insert space before ( -->
						<xsl:value-of select="java:replaceAll(java:java.lang.String.new($iso_reference_tmp_),'\(',' \(')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$iso_reference"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:value-of select="$anotherNumbers"/>
	</xsl:variable>

	<xsl:variable name="part" select="normalize-space(/mn:metanorma/mn:bibdata/mn:ext/mn:structuredidentifier/mn:project-number/@part)"/>
	
	<xsl:variable name="doctype" select="/mn:metanorma/mn:bibdata/mn:ext/mn:doctype"/>	 
	<xsl:variable name="doctype_localized_" select="/mn:metanorma/mn:bibdata/mn:ext/mn:doctype[@language = $lang]"/>
	<xsl:variable name="doctype_localized">
		<xsl:choose>
			<xsl:when test="$doctype_localized_ != ''">
				<xsl:value-of select="translate(normalize-space($doctype_localized_),'-',' ')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="translate(normalize-space($doctype),'-',' ')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
  
	<xsl:variable name="doctype_uppercased" select="java:toUpperCase(java:java.lang.String.new($doctype_localized))"/>
	
	<xsl:variable name="stage" select="number(/mn:metanorma/mn:bibdata/mn:status/mn:stage)"/>
	<xsl:variable name="substage" select="number(/mn:metanorma/mn:bibdata/mn:status/mn:substage)"/>	
	<xsl:variable name="stagename" select="normalize-space(/mn:metanorma/mn:bibdata/mn:ext/mn:stagename)"/>
	<xsl:variable name="stagename_abbreviation" select="normalize-space(/mn:metanorma/mn:bibdata/mn:ext/mn:stagename/@abbreviation)"/>
	<xsl:variable name="stagename_localized" select="normalize-space(/mn:metanorma/mn:bibdata/mn:status/mn:stage[@language = $lang])"/>
	<xsl:variable name="stagename_localized_coverpage"><xsl:copy-of select="/mn:metanorma/mn:bibdata/mn:status/mn:stage[@language = $lang and @type = 'coverpage']/node()"/></xsl:variable>
	<xsl:variable name="stagename_localized_firstpage"><xsl:copy-of select="/mn:metanorma/mn:bibdata/mn:status/mn:stage[@language = $lang and @type = 'firstpage']/node()"/></xsl:variable>
	<xsl:variable name="abbreviation" select="normalize-space(/mn:metanorma/mn:bibdata/mn:status/mn:stage/@abbreviation)"/>
	<xsl:variable name="abbreviation_uppercased" select="java:toUpperCase(java:java.lang.String.new($abbreviation))"/>
		
	<xsl:variable name="stage-abbreviation">
		<xsl:choose>
			<xsl:when test="$abbreviation_uppercased != ''">
				<xsl:value-of select="$abbreviation_uppercased"/>
			</xsl:when>
			<xsl:when test="$stage = 0 and $substage = 0">PWI</xsl:when>
			<xsl:when test="$stage = 0">NWIP</xsl:when> <!-- NWIP (NP) -->
			<xsl:when test="$stage = 10">AWI</xsl:when>
			<xsl:when test="$stage = 20">WD</xsl:when>
			<xsl:when test="$stage = 30">CD</xsl:when>
			<xsl:when test="$stage = 40">DIS</xsl:when>
			<xsl:when test="$stage = 50">FDIS</xsl:when>
			<xsl:when test="$stage = 60 and $substage = 0">PRF</xsl:when>
			<xsl:when test="$stage = 60 and $substage = 60">IS</xsl:when>
			<xsl:when test="$stage &gt;=60">published</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="stage-fullname">
		<xsl:choose>
			<xsl:when test="$stagename_localized != ''"> <!--  and $layoutVersion != '2024' -->
				<xsl:value-of select="$stagename_localized"/>
			</xsl:when>
			<xsl:when test="$stagename != ''">
				<xsl:value-of select="$stagename"/>
			</xsl:when>
			<xsl:when test="$stage-abbreviation = 'NWIP' or
															$stage-abbreviation = 'NP'">NEW WORK ITEM PROPOSAL</xsl:when>
			<xsl:when test="$stage-abbreviation = 'PWI'">PRELIMINARY WORK ITEM</xsl:when>
			<xsl:when test="$stage-abbreviation = 'AWI'">APPROVED WORK ITEM</xsl:when>
			<xsl:when test="$stage-abbreviation = 'WD'">WORKING DRAFT</xsl:when>
			<xsl:when test="$stage-abbreviation = 'CD'">COMMITTEE DRAFT</xsl:when>
			<xsl:when test="$stage-abbreviation = 'DIS'">DRAFT INTERNATIONAL STANDARD</xsl:when>
			<xsl:when test="$stage-abbreviation = 'FDIS'">FINAL DRAFT INTERNATIONAL STANDARD</xsl:when>
			<xsl:otherwise><xsl:value-of select="$doctype_localized"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="stage-fullname-uppercased" select="java:toUpperCase(java:java.lang.String.new($stage-fullname))"/>
	
	<xsl:variable name="stagename-header-firstpage">
		<xsl:choose>
			<!-- $stage-abbreviation = 'PRF'  -->
			<xsl:when test="$stagename_abbreviation = 'PRF'"><xsl:value-of select="$doctype_localized"/></xsl:when>
			<xsl:when test="$layoutVersion = '2024' and $stagename_localized != ''">
				<xsl:value-of select="$stagename_localized"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$stage-fullname"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="stagename-header-firstpage-uppercased" select="java:toUpperCase(java:java.lang.String.new($stagename-header-firstpage))"/>
		
	<xsl:variable name="stagename-header-coverpage">
		<xsl:choose>
			<xsl:when test="$stage-abbreviation = 'DIS' or $stage-abbreviation = 'DAMD' or $stage-abbreviation = 'DAM' or starts-with($stage-abbreviation, 'DTS') or starts-with($stage-abbreviation, 'DTR') or $stagename_abbreviation = 'DIS'">DRAFT</xsl:when>
			<xsl:when test="$stage-abbreviation = 'FDIS' or $stage-abbreviation = 'FDAMD' or $stage-abbreviation = 'FDAM' or starts-with($stage-abbreviation, 'FDTS') or starts-with($stage-abbreviation, 'FDTR') or $stagename_abbreviation = 'FDIS'">FINAL DRAFT</xsl:when>
			<xsl:when test="$stage-abbreviation = 'PRF'"></xsl:when>
			<xsl:when test="$stage-abbreviation = 'IS'"></xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$stage-fullname-uppercased"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<!-- UPPERCASED stage name -->	
	<!-- <item name="NWIP" show="true" header="PRELIMINARY WORK ITEM" shortname="NEW WORK ITEM PROPOSAL">NEW WORK ITEM PROPOSAL</item>
	<item name="PWI" show="true" header="PRELIMINARY WORK ITEM" shortname="PRELIMINARY WORK ITEM">PRELIMINARY WORK ITEM</item>		
	<item name="NP" show="true" header="PRELIMINARY WORK ITEM" shortname="NEW WORK ITEM PROPOSAL">NEW WORK ITEM PROPOSAL</item>
	<item name="AWI" show="true" header="APPROVED WORK ITEM" shortname="APPROVED WORK ITEM">APPROVED WORK ITEM</item>
	<item name="WD" show="true" header="WORKING DRAFT" shortname="WORKING DRAFT">WORKING DRAFT</item>
	<item name="CD" show="true" header="COMMITTEE DRAFT" shortname="COMMITTEE DRAFT">COMMITTEE DRAFT</item>
	<item name="DIS" show="true" header="DRAFT INTERNATIONAL STANDARD" shortname="DRAFT">DRAFT INTERNATIONAL STANDARD</item>
	<item name="FDIS" show="true" header="FINAL DRAFT INTERNATIONAL STANDARD" shortname="FINAL DRAFT">FINAL DRAFT INTERNATIONAL STANDARD</item>
	<item name="PRF">PROOF</item> -->
	
	
	<!-- 
		<status>
    <stage>30</stage>
    <substage>92</substage>
  </status>
	  The <stage> and <substage> values are well defined, 
		as the International Harmonized Stage Codes (https://www.iso.org/stage-codes.html):
		stage 60 means published, everything before is a Draft (90 means withdrawn, but the document doesn't change anymore) -->
	<xsl:variable name="isPublished">
		<xsl:choose>
			<xsl:when test="string($stage) = 'NaN'">false</xsl:when>
			<xsl:when test="$stage &gt;=60">true</xsl:when>
			<xsl:when test="normalize-space($stage-abbreviation) != ''">true</xsl:when>
			<xsl:otherwise>false</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="document-master-reference_addon"><xsl:if test="$stage-abbreviation = ''">-nonpublished</xsl:if></xsl:variable>

	<xsl:variable name="force-page-count-preface">
		<xsl:choose>
			<xsl:when test="$document-master-reference_addon = ''">end-on-even</xsl:when>
			<xsl:otherwise>no-force</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="proof-text">PROOF/ÉPREUVE</xsl:variable>

	<xsl:variable name="docnumber_with_prefix">
		<xsl:if test="$doctype = 'recommendation'">R&#xa0;</xsl:if><xsl:value-of select="/mn:metanorma/mn:bibdata/mn:docnumber"/>
	</xsl:variable>

	<xsl:variable name="ISO_title_en">INTERNATIONAL ORGANIZATION FOR STANDARDIZATION</xsl:variable>
	<xsl:variable name="ISO_title_ru">МЕЖДУНАРОДНАЯ ОРГАНИЗАЦИЯ ПО СТАНДАРТИЗАЦИИ</xsl:variable>
	<xsl:variable name="ISO_title_fr">ORGANISATION INTERNATIONALE DE NORMALISATION</xsl:variable>

	<xsl:variable name="i18n_reference_number_abbrev"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">reference_number_abbrev</xsl:with-param></xsl:call-template></xsl:variable>
	<xsl:variable name="i18n_reference_number"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">reference_number</xsl:with-param></xsl:call-template></xsl:variable>
	<xsl:variable name="i18n_descriptors"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">Descriptor.pl</xsl:with-param></xsl:call-template></xsl:variable>	
	<xsl:variable name="i18n_voting_begins_on"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">voting_begins_on</xsl:with-param></xsl:call-template></xsl:variable>
	<xsl:variable name="i18n_voting_terminates_on"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">voting_terminates_on</xsl:with-param></xsl:call-template></xsl:variable>
	<xsl:variable name="i18n_price_based_on"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">price_based_on</xsl:with-param></xsl:call-template></xsl:variable>
	<xsl:variable name="i18n_price"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">price</xsl:with-param></xsl:call-template></xsl:variable>
	<xsl:variable name="i18n_date_first_printing"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">date_first_printing</xsl:with-param></xsl:call-template></xsl:variable>
	<xsl:variable name="i18n_date_printing"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">date_printing</xsl:with-param></xsl:call-template></xsl:variable>
	<xsl:variable name="i18n_corrected_version"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">corrected_version</xsl:with-param></xsl:call-template></xsl:variable>
	<xsl:variable name="i18n_fast_track_procedure"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">fast-track-procedure</xsl:with-param></xsl:call-template></xsl:variable>
	<xsl:variable name="i18n_iso_cen_parallel"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">iso-cen-parallel</xsl:with-param></xsl:call-template></xsl:variable>
	<xsl:variable name="i18n_all_rights_reserved"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">all_rights_reserved</xsl:with-param></xsl:call-template></xsl:variable>	
	<xsl:variable name="i18n_locality_page"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">locality.page</xsl:with-param></xsl:call-template></xsl:variable>
	<xsl:variable name="i18n_locality_part"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">locality.part</xsl:with-param></xsl:call-template></xsl:variable>
	<xsl:variable name="i18n_secretariat"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">secretariat</xsl:with-param></xsl:call-template></xsl:variable>
	<xsl:variable name="i18n_classification_UDC"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">classification-UDC</xsl:with-param></xsl:call-template></xsl:variable>
	<xsl:variable name="i18n_draft_comment_1"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">draft_comment_1</xsl:with-param></xsl:call-template></xsl:variable>
	<xsl:variable name="i18n_draft_comment_2"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">draft_comment_2</xsl:with-param></xsl:call-template></xsl:variable>
	<xsl:variable name="i18n_draft_comment_3"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">draft_comment_3</xsl:with-param></xsl:call-template></xsl:variable>
	
	<!-- Example:
		<item level="1" id="Foreword" display="true">Foreword</item>
		<item id="term-script" display="false">3.2</item>
	-->
	<xsl:variable name="contents_">
		<mnx:contents>
			<xsl:if test="$isGenerateTableIF = 'false'">
				<xsl:call-template name="processPrefaceSectionsDefault_Contents"/>
				<xsl:call-template name="processMainSectionsDefault_Contents"/>
				<xsl:apply-templates select="//mn:indexsect" mode="contents"/>
				<xsl:call-template name="processTablesFigures_Contents"/>
			</xsl:if>
		</mnx:contents>
	</xsl:variable>
	<xsl:variable name="contents" select="xalan:nodeset($contents_)"/>
	
	<xsl:variable name="lang_other">
		<xsl:for-each select="/mn:metanorma/mn:bibdata/mn:title[@language != $lang]">
			<xsl:if test="not(preceding-sibling::mn:title[@language = current()/@language])">
				<xsl:element name="lang" namespace="{$namespace_mn_xsl}"><xsl:value-of select="@language"/></xsl:element>
			</xsl:if>
		</xsl:for-each>
	</xsl:variable>
	
	<xsl:variable name="editorialgroup_">
		<!-- Example: ISO/TC 46/SC 2 -->
		<!-- ISO/SG SMART/SG TS/AG 1 -->
		<xsl:variable name="approvalgroup" select="normalize-space(/mn:metanorma/mn:bibdata/mn:ext/mn:approvalgroup/@identifier)"/>
		<xsl:variable name="parts_by_slash">
			<xsl:call-template name="split">
				<xsl:with-param name="pText" select="$approvalgroup"/>
				<xsl:with-param name="sep" select="'/'"/>
				<xsl:with-param name="normalize-space">false</xsl:with-param>
				<xsl:with-param name="keep_sep">true</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="parts_with_subparts">
			<xsl:for-each select="xalan:nodeset($parts_by_slash)//mnx:item">
				<xsl:element name="subitem" namespace="{$namespace_mn_xsl}">
					<xsl:call-template name="split">
						<xsl:with-param name="pText" select="."/>
						<xsl:with-param name="sep" select="' '"/>
						<xsl:with-param name="normalize-space">false</xsl:with-param>
						<xsl:with-param name="keep_sep">true</xsl:with-param>
					</xsl:call-template>
				</xsl:element>
			</xsl:for-each>
		</xsl:variable>
		<xsl:for-each select="xalan:nodeset($parts_with_subparts)//mnx:subitem">
			<xsl:choose>
				<xsl:when test="position() = 1">
					<xsl:value-of select="."/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:for-each select="mnx:item">
						<xsl:choose>
							<xsl:when test="position() = last()">
								<fo:inline font-weight="bold"><xsl:value-of select="."/></fo:inline>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="."/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="editorialgroup" select="xalan:nodeset($editorialgroup_)" />
	
	<xsl:variable name="secretariat_">
		<xsl:variable name="value" select="normalize-space(/mn:metanorma/mn:bibdata/mn:ext/mn:editorialgroup/mn:secretariat)"/>
		<xsl:if test="$value != ''">
			<xsl:value-of select="concat($i18n_secretariat, ': ')"/>
			<fo:inline font-weight="bold"><xsl:value-of select="$value"/></fo:inline>
		</xsl:if>
	</xsl:variable>
	<xsl:variable name="secretariat" select="xalan:nodeset($secretariat_)" />
	
	<xsl:variable name="ics_">
		<xsl:for-each select="/mn:metanorma/mn:bibdata/mn:ext/mn:ics/mn:code">
			<xsl:if test="position() = 1"><fo:inline>ICS: </fo:inline></xsl:if>
			<xsl:value-of select="."/>
			<xsl:if test="position() != last()"><xsl:text>; </xsl:text></xsl:if>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="ics" select="xalan:nodeset($ics_)"/>
	<xsl:variable name="udc">
		<xsl:variable name="classification_udc" select="normalize-space(/mn:metanorma/mn:bibdata/mn:classification[@type = 'UDC'])"/>
		<xsl:choose>
			<xsl:when test="$classification_udc != ''">
				<xsl:value-of select="concat($i18n_classification_UDC, '&#xa0;')"/>
				<xsl:value-of select="java:replaceAll(java:java.lang.String.new($classification_udc),'(:)',' $1 ')"/>
			</xsl:when>
			<xsl:otherwise>&#xa0;</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="revision_date" select="normalize-space(/mn:metanorma/mn:bibdata/mn:version/mn:revision-date)"/>
	<xsl:variable name="revision_date_num" select="number(translate($revision_date,'-',''))"/>
	
	<xsl:variable name="layoutVersion_">
		<xsl:choose>
			<xsl:when test="$document_scheme = ''">2024</xsl:when>
			<xsl:when test="$document_scheme = '1951' or $document_scheme = '1972' or $document_scheme = '1979' or $document_scheme = '1987' or $document_scheme = '1989' or $document_scheme = '2012' or $document_scheme = '2013' or $document_scheme = '2024'"><xsl:value-of select="$document_scheme"/></xsl:when>
			<xsl:otherwise>default</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="layoutVersion" select="normalize-space($layoutVersion_)"/>
	<xsl:variable name="cover_page_border">0.5pt solid black</xsl:variable>
	<xsl:variable name="color_red">rgb(237, 28, 36)</xsl:variable>
	<xsl:variable name="color_secondary_value" select="normalize-space(/mn:metanorma/mn:metanorma-extension/mn:presentation-metadata/mn:color-secondary)"/>
	<xsl:variable name="color_secondary">
		<xsl:choose>
			<xsl:when test="$color_secondary_value != ''"><xsl:value-of select="$color_secondary_value"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$color_red"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="XML" select="/"/>
	
	<xsl:template name="layout-master-set">
		<fo:layout-master-set>
			
			<xsl:variable name="marginLeftRight_cover_page_1951">16.5</xsl:variable> <!-- 12.5 -->
			<xsl:variable name="marginTop_cover_page_1951">19.5</xsl:variable>
			<xsl:variable name="marginBottom_cover_page_1951">94.5</xsl:variable>
			
			<xsl:variable name="marginLeft_cover_page_1972">21</xsl:variable>
			<xsl:variable name="marginRight_cover_page_1972">12</xsl:variable>
			<xsl:variable name="marginTop_cover_page_1972">15</xsl:variable>
			<xsl:variable name="marginBottom_cover_page_1972">33</xsl:variable>
			
			<xsl:variable name="marginLeft_cover_page_1987">20</xsl:variable>
			<xsl:variable name="marginRight_cover_page_1987">37</xsl:variable>
			<xsl:variable name="marginTopBottom_cover_page_1987">20</xsl:variable>
			
			<xsl:variable name="marginLeftRight_cover_page_2024">9.9</xsl:variable>
			<xsl:variable name="marginTopBottom_cover_page_2024">9.9</xsl:variable>
			
			<!-- cover page -->
			<fo:simple-page-master master-name="cover-page-nonpublished" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="25.4mm" margin-bottom="25.4mm" margin-left="31.7mm" margin-right="31.7mm"/>
				<fo:region-before region-name="cover-page-header" extent="25.4mm" />
				<fo:region-after/>
				<fo:region-start region-name="cover-left-region" extent="31.7mm"/>
				<fo:region-end region-name="cover-right-region" extent="31.7mm"/>
			</fo:simple-page-master>
			
			<fo:simple-page-master master-name="cover-page-published" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="12.7mm" margin-bottom="75mm" margin-left="78mm" margin-right="18.5mm"/>
				<fo:region-before region-name="cover-page-header" extent="12.7mm" />
				<fo:region-after region-name="cover-page-footer" extent="75mm" display-align="after" />
				<fo:region-start region-name="cover-left-region" extent="78mm"/>
				<fo:region-end region-name="cover-right-region" extent="18.5mm"/>
			</fo:simple-page-master>
			
			<fo:simple-page-master master-name="cover-page-odd" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="12.7mm" margin-bottom="75mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
				<fo:region-before region-name="cover-page-header" extent="12.7mm" />
				<fo:region-after region-name="cover-page-footer" extent="75mm" display-align="after" />
				<fo:region-start region-name="cover-left-region" extent="{$marginLeftRight1}mm"/>
				<fo:region-end region-name="cover-right-region" extent="{$marginLeftRight2}mm"/>
			</fo:simple-page-master>
			<fo:simple-page-master master-name="cover-page-even" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="12.7mm" margin-bottom="75mm" margin-left="{$marginLeftRight2}mm" margin-right="{$marginLeftRight1}mm"/>
				<fo:region-before region-name="cover-page-header" extent="12.7mm" />
				<fo:region-after region-name="cover-page-footer" extent="75mm" display-align="after" />
				<fo:region-start region-name="cover-left-region" extent="{$marginLeftRight2}mm"/>
				<fo:region-end region-name="cover-right-region" extent="{$marginLeftRight1}mm"/>
			</fo:simple-page-master>
			<fo:page-sequence-master master-name="cover-page">
				<fo:repeatable-page-master-alternatives>
					<fo:conditional-page-master-reference odd-or-even="even" master-reference="cover-page-even"/>
					<fo:conditional-page-master-reference odd-or-even="odd" master-reference="cover-page-odd"/>
				</fo:repeatable-page-master-alternatives>
			</fo:page-sequence-master>
			
			<fo:simple-page-master master-name="cover-page_1951" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="{$marginTop_cover_page_1951}mm" margin-bottom="{$marginBottom_cover_page_1951}mm" margin-left="{$marginLeftRight_cover_page_1951}mm" margin-right="{$marginLeftRight_cover_page_1951}mm"/>
				<fo:region-before region-name="cover-page-header" extent="{$marginTop_cover_page_1951}mm"/>
				<fo:region-after region-name="cover-page-footer" extent="{$marginBottom_cover_page_1951}mm"/>
				<fo:region-start region-name="left-region" extent="{$marginLeftRight_cover_page_1951}mm"/>
				<fo:region-end region-name="right-region" extent="{$marginLeftRight_cover_page_1951}mm"/>
			</fo:simple-page-master>
			
			<fo:simple-page-master master-name="cover-page_1972" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="{$marginTop_cover_page_1972}mm" margin-bottom="{$marginBottom_cover_page_1972}mm" margin-left="{$marginLeft_cover_page_1972}mm" margin-right="{$marginRight_cover_page_1972}mm"/>
				<fo:region-before region-name="cover-page-header" extent="{$marginTop_cover_page_1972}mm"/>
				<fo:region-after region-name="cover-page-footer" extent="{$marginBottom_cover_page_1972}mm"/>
				<fo:region-start region-name="left-region" extent="{$marginLeft_cover_page_1972}mm"/>
				<fo:region-end region-name="right-region" extent="{$marginRight_cover_page_1972}mm"/>
			</fo:simple-page-master>
			
			<fo:simple-page-master master-name="cover-page_1987" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="{$marginTopBottom_cover_page_1987}mm" margin-bottom="{$marginTopBottom_cover_page_1987}mm" margin-left="{$marginLeft_cover_page_1987}mm" margin-right="{$marginRight_cover_page_1987}mm"/>
				<fo:region-before region-name="cover-page-header" extent="{$marginTopBottom_cover_page_1987}mm" precedence="true"/>
				<fo:region-after region-name="cover-page-footer" extent="{$marginTopBottom_cover_page_1987}mm" precedence="true"/>
				<fo:region-start region-name="left-region" extent="{$marginLeft_cover_page_1987}mm"/>
				<fo:region-end region-name="right-region" extent="{$marginRight_cover_page_1987}mm"/>
			</fo:simple-page-master>
			
			<fo:simple-page-master master-name="cover-page_2024" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="{$marginTopBottom_cover_page_2024}mm" margin-bottom="{$marginTopBottom_cover_page_2024}mm" margin-left="{$marginLeftRight_cover_page_2024}mm" margin-right="{$marginLeftRight_cover_page_2024}mm"/>
				<fo:region-before region-name="header" extent="{$marginTopBottom_cover_page_2024}mm"/>
				<fo:region-after region-name="footer" extent="{$marginTopBottom_cover_page_2024}mm"/>
				<fo:region-start region-name="left-region" extent="{$marginLeftRight_cover_page_2024}mm"/>
				<fo:region-end region-name="right-region" extent="{$marginLeftRight_cover_page_2024}mm"/>
			</fo:simple-page-master>

			<!-- contents pages -->
			<!-- odd pages -->
			<fo:simple-page-master master-name="odd-nonpublished" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="27.4mm" margin-bottom="{$marginBottom}mm" margin-left="19mm" margin-right="19mm"/>
				<fo:region-before region-name="header-odd" extent="27.4mm"/> <!--   display-align="center" -->
				<fo:region-after region-name="footer-odd" extent="{$marginBottom - 2}mm" />
				<fo:region-start region-name="left-region" extent="19mm"/>
				<fo:region-end region-name="right-region" extent="19mm"/>
			</fo:simple-page-master>
			<fo:simple-page-master master-name="odd-nonpublished-landscape" page-width="{$pageHeight}mm" page-height="{$pageWidth}mm">
				<fo:region-body margin-top="27.4mm" margin-bottom="{$marginBottom}mm" margin-left="19mm" margin-right="19mm"/>
				<fo:region-before region-name="header-odd" extent="27.4mm"/>
				<fo:region-after region-name="footer-odd" extent="{$marginBottom - 2}mm"/>
				<fo:region-start region-name="left-region" extent="19mm"/>
				<fo:region-end region-name="right-region" extent="19mm"/>
			</fo:simple-page-master>
			<!-- even pages -->
			<fo:simple-page-master master-name="even-nonpublished" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="27.4mm" margin-bottom="{$marginBottom}mm" margin-left="19mm" margin-right="19mm"/>
				<fo:region-before region-name="header-even" extent="27.4mm"/> <!--   display-align="center" -->
				<fo:region-after region-name="footer-even" extent="{$marginBottom - 2}mm"/>
				<fo:region-start region-name="left-region" extent="19mm"/>
				<fo:region-end region-name="right-region" extent="19mm"/>
			</fo:simple-page-master>
			<fo:simple-page-master master-name="even-nonpublished-landscape" page-width="{$pageHeight}mm" page-height="{$pageWidth}mm">
				<fo:region-body margin-top="27.4mm" margin-bottom="{$marginBottom}mm" margin-left="19mm" margin-right="19mm"/>
				<fo:region-before region-name="header-even" extent="27.4mm"/> <!--   display-align="center" -->
				<fo:region-after region-name="footer-even" extent="{$marginBottom - 2}mm"/>
				<fo:region-start region-name="left-region" extent="19mm"/>
				<fo:region-end region-name="right-region" extent="19mm"/>
			</fo:simple-page-master>
			<fo:page-sequence-master master-name="preface-nonpublished">
				<fo:repeatable-page-master-alternatives>
					<fo:conditional-page-master-reference odd-or-even="even" master-reference="even-nonpublished"/>
					<fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd-nonpublished"/>
				</fo:repeatable-page-master-alternatives>
			</fo:page-sequence-master>
			<fo:page-sequence-master master-name="preface-nonpublished-landscape">
				<fo:repeatable-page-master-alternatives>
					<fo:conditional-page-master-reference odd-or-even="even" master-reference="even-nonpublished-landscape"/>
					<fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd-nonpublished-landscape"/>
				</fo:repeatable-page-master-alternatives>
			</fo:page-sequence-master>
			<fo:page-sequence-master master-name="document-nonpublished">
				<fo:repeatable-page-master-alternatives>
					<fo:conditional-page-master-reference odd-or-even="even" master-reference="even-nonpublished"/>
					<fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd-nonpublished"/>
				</fo:repeatable-page-master-alternatives>
			</fo:page-sequence-master>
			<fo:page-sequence-master master-name="document-nonpublished-landscape">
				<fo:repeatable-page-master-alternatives>
					<fo:conditional-page-master-reference odd-or-even="even" master-reference="even-nonpublished-landscape"/>
					<fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd-nonpublished-landscape"/>
				</fo:repeatable-page-master-alternatives>
			</fo:page-sequence-master>
			
			
			<fo:simple-page-master master-name="first-preface_1972-1998" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="{$marginTop}mm" margin-bottom="95mm" margin-left="{$marginLeftRight2}mm" margin-right="82mm"/>
				<fo:region-before region-name="header-even" extent="{$marginTop}mm"/>
				<fo:region-after region-name="footer-preface-first_1972-1998" extent="95mm"/>
				<fo:region-start region-name="left-region" extent="{$marginLeftRight2}mm"/>
				<fo:region-end region-name="right-region" extent="82mm"/>
			</fo:simple-page-master>
			<fo:simple-page-master master-name="odd-preface_1972-1998" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="82mm" margin-right="{$marginLeftRight2}mm"/>
				<fo:region-before region-name="header-odd" extent="{$marginTop}mm"/> <!--   display-align="center" -->
				<fo:region-after region-name="footer-odd" extent="{$marginBottom - 2}mm"/>
				<fo:region-start region-name="left-region" extent="82mm"/>
				<fo:region-end region-name="right-region" extent="{$marginLeftRight2}mm"/>
			</fo:simple-page-master>
			<fo:simple-page-master master-name="even-preface_1972-1998" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight2}mm" margin-right="82mm"/>
				<fo:region-before region-name="header-even" extent="{$marginTop}mm"/>
				<fo:region-after region-name="footer-even" extent="{$marginBottom - 2}mm"/>
				<fo:region-start region-name="left-region" extent="{$marginLeftRight2}mm"/>
				<fo:region-end region-name="right-region" extent="82mm"/>
			</fo:simple-page-master>
			<fo:page-sequence-master master-name="preface-1972-1998">
				<fo:repeatable-page-master-alternatives>
					<fo:conditional-page-master-reference master-reference="blankpage" blank-or-not-blank="blank" />
					<fo:conditional-page-master-reference master-reference="first-preface_1972-1998" page-position="first"/>
					<fo:conditional-page-master-reference odd-or-even="even" master-reference="even-preface_1972-1998"/>
					<fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd-preface_1972-1998"/>
				</fo:repeatable-page-master-alternatives>
			</fo:page-sequence-master>
			
			<!-- first page -->
			<fo:simple-page-master master-name="firstpage" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm" column-count="{$layout_columns}" column-gap="{$column_gap}"/>
				<fo:region-before region-name="header-first" extent="{$marginTop}mm">
					<xsl:if test="(($layoutVersion = '1987' and $doctype = 'technical-report') or ($layoutVersion = '1979' and $doctype = 'addendum'))">
						<xsl:attribute name="region-name">header-odd</xsl:attribute>
					</xsl:if>
				</fo:region-before>
				<fo:region-after region-name="footer-odd" extent="{$marginBottom - 2}mm"/>
				<fo:region-start region-name="left-region" extent="{$marginLeftRight1}mm"/>
				<fo:region-end region-name="right-region" extent="{$marginLeftRight2}mm"/>
			</fo:simple-page-master>
			<!-- odd pages -->
			<fo:simple-page-master master-name="odd" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm" column-count="{$layout_columns}" column-gap="{$column_gap}"/>
				<fo:region-before region-name="header-odd" extent="{$marginTop}mm">
					<xsl:if test="$layoutVersion = '1951'">
						<xsl:attribute name="precedence">true</xsl:attribute>
					</xsl:if>
				</fo:region-before>
				<fo:region-after region-name="footer-odd" extent="{$marginBottom - 2}mm"/>
				<fo:region-start region-name="left-region" extent="{$marginLeftRight1}mm"/>
				<fo:region-end region-name="right-region" extent="{$marginLeftRight2}mm"/>
			</fo:simple-page-master>
			
			<fo:simple-page-master master-name="odd-landscape" page-width="{$pageHeight}mm" page-height="{$pageWidth}mm">
				<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm" column-count="{$layout_columns}" column-gap="{$column_gap}"/>
				<fo:region-before region-name="header-odd" extent="{$marginTop}mm"/> <!--   display-align="center" -->
				<fo:region-after region-name="footer-odd" extent="{$marginBottom - 2}mm"/>
				<fo:region-start region-name="left-region" extent="{$marginLeftRight1}mm"/>
				<fo:region-end region-name="right-region" extent="{$marginLeftRight2}mm"/>
			</fo:simple-page-master>
			<!-- even pages -->
			<fo:simple-page-master master-name="even" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight2}mm" margin-right="{$marginLeftRight1}mm" column-count="{$layout_columns}" column-gap="{$column_gap}"/>
				<fo:region-before region-name="header-even" extent="{$marginTop}mm">
					<xsl:if test="$layoutVersion = '1951'">
						<xsl:attribute name="precedence">true</xsl:attribute>
					</xsl:if>
				</fo:region-before>
				<fo:region-after region-name="footer-even" extent="{$marginBottom - 2}mm"/>
				<fo:region-start region-name="left-region" extent="{$marginLeftRight2}mm"/>
				<fo:region-end region-name="right-region" extent="{$marginLeftRight1}mm"/>
			</fo:simple-page-master>
			
			<!-- for 1951 layout only -->
			<fo:simple-page-master master-name="even-last" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight2}mm" margin-right="{$marginLeftRight1}mm" column-count="{$layout_columns}" column-gap="{$column_gap}"/>
				<fo:region-before region-name="header-even" extent="{$marginTop}mm" precedence="true"/>
				<fo:region-after region-name="footer-even-last" extent="{$marginBottom - 2}mm"/>
				<fo:region-start region-name="left-region" extent="{$marginLeftRight2}mm"/>
				<fo:region-end region-name="right-region" extent="{$marginLeftRight1}mm"/>
			</fo:simple-page-master>
			
			<fo:simple-page-master master-name="even-landscape" page-width="{$pageHeight}mm" page-height="{$pageWidth}mm">
				<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight2}mm" margin-right="{$marginLeftRight1}mm" column-count="{$layout_columns}" column-gap="{$column_gap}"/>
				<fo:region-before region-name="header-even" extent="{$marginTop}mm"/>
				<fo:region-after region-name="footer-even" extent="{$marginBottom - 2}mm"/>
				<fo:region-start region-name="left-region" extent="{$marginLeftRight2}mm"/>
				<fo:region-end region-name="right-region" extent="{$marginLeftRight1}mm"/>
			</fo:simple-page-master>
			<fo:simple-page-master master-name="blankpage" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight2}mm" margin-right="{$marginLeftRight1}mm"/>
				<fo:region-before region-name="header" extent="{$marginTop}mm"/>
				<fo:region-after region-name="footer" extent="{$marginBottom - 2}mm"/>
				<fo:region-start region-name="left" extent="{$marginLeftRight2}mm"/>
				<fo:region-end region-name="right" extent="{$marginLeftRight1}mm"/>
			</fo:simple-page-master>
			<fo:page-sequence-master master-name="preface">
				<fo:repeatable-page-master-alternatives>
					<fo:conditional-page-master-reference master-reference="blankpage" blank-or-not-blank="blank" />
					<fo:conditional-page-master-reference odd-or-even="even" master-reference="even"/>
					<fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd"/>
				</fo:repeatable-page-master-alternatives>
			</fo:page-sequence-master>
			<fo:page-sequence-master master-name="preface-landscape">
				<fo:repeatable-page-master-alternatives>
					<fo:conditional-page-master-reference master-reference="blankpage" blank-or-not-blank="blank" />
					<fo:conditional-page-master-reference odd-or-even="even" master-reference="even-landscape"/>
					<fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd-landscape"/>
				</fo:repeatable-page-master-alternatives>
			</fo:page-sequence-master>
			
			<!-- First pages for Technical Report (layout 1987) -->
			<fo:simple-page-master master-name="first-preface_1987_TR" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="13mm" margin-bottom="30mm" margin-left="19mm" margin-right="10.5mm"/>
				<fo:region-before region-name="header-empty" extent="13mm"/>
				<fo:region-after region-name="footer-preface-first_1987_TR" extent="30mm" display-align="after"/>
				<fo:region-start region-name="left-region-first_1987_TR" extent="19mm"/>
				<fo:region-end region-name="right-region" extent="10.5mm"/>
			</fo:simple-page-master>
			<fo:page-sequence-master master-name="preface-1987_TR">
				<fo:repeatable-page-master-alternatives>
					<fo:conditional-page-master-reference master-reference="first-preface_1987_TR" page-position="first"/>
					<fo:conditional-page-master-reference odd-or-even="even" master-reference="even"/>
					<fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd"/>
				</fo:repeatable-page-master-alternatives>
			</fo:page-sequence-master>

			<fo:page-sequence-master master-name="document_first_sequence">
				<fo:repeatable-page-master-alternatives>
					<xsl:if test="not($layoutVersion = '1951')">
						<fo:conditional-page-master-reference master-reference="firstpage" page-position="first"/>
					</xsl:if>
					<xsl:if test="$layoutVersion = '1951'">
						<fo:conditional-page-master-reference page-position="last" master-reference="even-last"/> <!-- odd-or-even="even" -->
					</xsl:if>
					<fo:conditional-page-master-reference odd-or-even="even" master-reference="even"/>
					<fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd"/>
				</fo:repeatable-page-master-alternatives>
			</fo:page-sequence-master>

			<fo:page-sequence-master master-name="document">
				<fo:repeatable-page-master-alternatives>
					<xsl:if test="$layoutVersion = '1951'">
						<fo:conditional-page-master-reference page-position="last" master-reference="even-last"/> <!-- odd-or-even="even" -->
					</xsl:if>
					<fo:conditional-page-master-reference odd-or-even="even" master-reference="even"/>
					<fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd"/>
				</fo:repeatable-page-master-alternatives>
			</fo:page-sequence-master>
			
			<fo:page-sequence-master master-name="document-landscape_first_sequence">
				<fo:repeatable-page-master-alternatives>
					<xsl:if test="not($layoutVersion = '1951')">
						<fo:conditional-page-master-reference master-reference="firstpage" page-position="first"/>
					</xsl:if>
					<fo:conditional-page-master-reference odd-or-even="even" master-reference="even-landscape"/>
					<fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd-landscape"/>
				</fo:repeatable-page-master-alternatives>
			</fo:page-sequence-master>
			<fo:page-sequence-master master-name="document-landscape">
				<fo:repeatable-page-master-alternatives>
					<fo:conditional-page-master-reference odd-or-even="even" master-reference="even-landscape"/>
					<fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd-landscape"/>
				</fo:repeatable-page-master-alternatives>
			</fo:page-sequence-master>
			
			<fo:simple-page-master master-name="back-page" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight2}mm" margin-right="{$marginLeftRight1}mm"/>
				<fo:region-before region-name="header-even" extent="{$marginTop}mm"/>
				<fo:region-after region-name="back-page-footer" extent="{$marginBottom - 2}mm"/>
				<fo:region-start region-name="left-region" extent="{$marginLeftRight2}mm"/>
				<fo:region-end region-name="right-region" extent="{$marginLeftRight1}mm"/>
			</fo:simple-page-master>
			
			<fo:simple-page-master master-name="back-page_2024" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="{$marginTopBottom_cover_page_2024}mm" margin-bottom="{$marginTopBottom_cover_page_2024}mm" margin-left="{$marginLeftRight_cover_page_2024}mm" margin-right="{$marginLeftRight_cover_page_2024}mm"/>
				<fo:region-before region-name="header" extent="{$marginTopBottom_cover_page_2024}mm"/>
				<fo:region-after region-name="footer" extent="{$marginTopBottom_cover_page_2024}mm"/>
				<fo:region-start region-name="left-region" extent="{$marginLeftRight_cover_page_2024}mm"/>
				<fo:region-end region-name="right-region" extent="{$marginLeftRight_cover_page_2024}mm"/>
			</fo:simple-page-master>
			
			<!-- Index pages -->
			<fo:simple-page-master master-name="index-odd" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm" column-count="2" column-gap="10mm"/>
				<fo:region-before region-name="header-odd" extent="{$marginTop}mm"/>
				<fo:region-after region-name="footer-odd" extent="{$marginBottom - 2}mm"/>
				<fo:region-start region-name="left-region" extent="{$marginLeftRight1}mm"/>
				<fo:region-end region-name="right-region" extent="{$marginLeftRight2}mm"/>
			</fo:simple-page-master>
			<fo:simple-page-master master-name="index-even" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight2}mm" margin-right="{$marginLeftRight1}mm" column-count="2" column-gap="10mm"/>
				<fo:region-before region-name="header-even" extent="{$marginTop}mm"/>
				<fo:region-after region-name="footer-even" extent="{$marginBottom - 2}mm"/>
				<fo:region-start region-name="left-region" extent="{$marginLeftRight2}mm"/>
				<fo:region-end region-name="right-region" extent="{$marginLeftRight1}mm"/>
			</fo:simple-page-master>
			<fo:page-sequence-master master-name="index">
				<fo:repeatable-page-master-alternatives>						
					<fo:conditional-page-master-reference odd-or-even="even" master-reference="index-even"/>
					<fo:conditional-page-master-reference odd-or-even="odd" master-reference="index-odd"/>
				</fo:repeatable-page-master-alternatives>
			</fo:page-sequence-master>
		</fo:layout-master-set>
	</xsl:template> <!-- END: layout-master-set -->

	
	<xsl:template match="/">
		
		<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format" xml:lang="{$lang}">
			
			<xsl:variable name="root-style">
				<root-style xsl:use-attribute-sets="root-style">
				
					<xsl:if test="$layoutVersion = '1951'">
						<xsl:attribute name="font-size">10pt</xsl:attribute>
						<xsl:if test="$revision_date_num &gt;= 19680101">
							<xsl:attribute name="font-size">9pt</xsl:attribute>
						</xsl:if>
					</xsl:if>
				
					<xsl:if test="$layoutVersion = '1972' or $layoutVersion = '1979'">
						<xsl:attribute name="font-family">Univers, Times New Roman, Cambria Math, <xsl:value-of select="$font_noto_sans"/></xsl:attribute>
						<xsl:attribute name="font-family-generic">Sans</xsl:attribute>
						<xsl:attribute name="font-size">10pt</xsl:attribute>
						<xsl:if test="$layout_columns = 2">
							<xsl:attribute name="font-size">9pt</xsl:attribute>
						</xsl:if>
					</xsl:if>
					<xsl:if test="$layoutVersion = '1987' or $layoutVersion = '1989'">
						<xsl:attribute name="font-family">Arial, Times New Roman, Cambria Math, <xsl:value-of select="$font_noto_sans"/></xsl:attribute>
						<xsl:attribute name="font-family-generic">Sans</xsl:attribute>
						<xsl:attribute name="font-size">10pt</xsl:attribute>
					</xsl:if>
					
					<xsl:if test="(($layoutVersion = '1987' and $doctype = 'technical-report') or ($layoutVersion = '1979' and $doctype = 'addendum'))">
						<xsl:attribute name="font-size">8.5pt</xsl:attribute>
					 </xsl:if>
					
					<xsl:if test="$lang = 'zh'">
						<!-- <xsl:attribute name="font-family">Source Han Sans, Times New Roman, Cambria Math</xsl:attribute> -->
						<xsl:attribute name="font-selection-strategy">character-by-character</xsl:attribute>
					</xsl:if>
				</root-style>
			</xsl:variable>
			<xsl:call-template name="insertRootStyle">
				<xsl:with-param name="root-style" select="$root-style"/>
			</xsl:call-template>
			
			<xsl:if test="$layoutVersion = '2024' and /mn:metanorma/mn:bibdata/mn:contributor[mn:role/@type = 'author']/mn:organization/mn:abbreviation = 'ISO'">
				<xsl:attribute name="color">rgb(35,31,32)</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="/mn:metanorma/mn:metanorma-extension/mn:presentation-metadata/mn:linenumbers = 'true'">
				<xsl:processing-instruction name="add_line_numbers">true</xsl:processing-instruction>
			</xsl:if>
			
			<xsl:call-template name="layout-master-set"/>

			<fo:declarations>
				<xsl:call-template name="addPDFUAmeta"/>
				<xsl:for-each select="//mn:fmt-eref[generate-id(.)=generate-id(key('attachments',@bibitemid)[1])]">
					<xsl:variable name="url" select="concat('url(file:',$basepath, @bibitemid, ')')"/>
					<pdf:embedded-file src="{$url}" filename="{@bibitemid}"/>
				</xsl:for-each>
				<xsl:for-each select="//mn:fmt-eref[generate-id(.)=generate-id(key('attachments2',@bibitemid)[1])]">
					<xsl:variable name="bibitemid" select="@bibitemid" />
					<xsl:variable name="uri" select="normalize-space($bibitems/mn:bibitem[@hidden = 'true'][@id = $bibitemid][1]/mn:uri[@type='citation'])"/>
					<xsl:if test="$uri != ''">
						<xsl:variable name="url" select="concat('url(file:',$basepath, $uri, ')')"/>
						<xsl:variable name="filename" select="concat(substring-before($bibitemid, '.exp_'), '.exp')"/>
						<pdf:embedded-file src="{$url}" filename="{$filename}"/>
					</xsl:if>
				</xsl:for-each>
			</fo:declarations>

			<xsl:call-template name="addBookmarks">
				<xsl:with-param name="contents" select="$contents"/>
			</xsl:call-template>
			
			<xsl:call-template name="cover-page"/>
			
			<xsl:if test="$debug = 'true'">
				<xsl:message>START updated_xml</xsl:message>
			</xsl:if>
			<xsl:variable name="startTime0" select="java:getTime(java:java.util.Date.new())"/>
			
			<xsl:variable name="updated_xml">
				<xsl:call-template name="updateXML"/>
			</xsl:variable>
			
			<xsl:if test="$debug = 'true'">
				<redirect:write file="updated_xml.xml">
					<xsl:copy-of select="$updated_xml"/>
				</redirect:write>
				<xsl:message>End updated_xml</xsl:message>
				<xsl:message>DEBUG: processing time <xsl:value-of select="java:getTime(java:java.util.Date.new()) - $startTime0"/> msec.</xsl:message>
			</xsl:if>
			
			<xsl:for-each select="xalan:nodeset($updated_xml)/*">
			
				<xsl:if test="$debug = 'true'">
					<xsl:message>START updated_xml_with_pages</xsl:message>
				</xsl:if>
				<xsl:variable name="startTimeA" select="java:getTime(java:java.util.Date.new())"/>
				
				<xsl:variable name="updated_xml_with_pages">
					<xsl:call-template name="processPrefaceAndMainSectionsISO_items"/>
				</xsl:variable>
				
				<xsl:if test="$debug = 'true'">
					<xsl:message>END updated_xml_with_pages</xsl:message>
					<xsl:message>DEBUG: processing time <xsl:value-of select="java:getTime(java:java.util.Date.new()) - $startTimeA"/> msec.</xsl:message>
				</xsl:if>
			
				<xsl:choose>
					<xsl:when test="$layoutVersion = '1951'">
						<fo:page-sequence master-reference="document{$document-master-reference_addon}" initial-page-number="auto" force-page-count="no-force">
							<fo:static-content flow-name="xsl-footnote-separator">
								<fo:block>
									<fo:leader leader-pattern="rule" leader-length="30%"/>
								</fo:block>
							</fo:static-content>
							<xsl:call-template name="insertHeaderFooter">
								<xsl:with-param name="is_header">false</xsl:with-param>
								<xsl:with-param name="insert_footer_last">false</xsl:with-param>
							</xsl:call-template>
							<fo:flow flow-name="xsl-region-body">
								<fo:block>
									<!-- <xsl:call-template name="processPrefaceSectionsDefault"/> -->
									<!-- Introduction will be showed in the main section -->
									<xsl:for-each select="/*/mn:preface/*[not(self::mn:note or self::mn:admonition or self::mn:introduction)]">
										<xsl:sort select="@displayorder" data-type="number"/>
										<xsl:apply-templates select="."/>
									</xsl:for-each>
									
									<fo:block span="all" text-align="center" margin-top="15mm" keep-with-next="always" role="SKIP">
										<fo:leader leader-pattern="rule" leader-length="22mm"/>
									</fo:block>
									
								</fo:block>
							</fo:flow>
						</fo:page-sequence>
					</xsl:when><!-- END: preface sections (Foreword, Brief history for layout 1951 ($layoutVersion = '1951') -->
					
					<xsl:when test="(($layoutVersion = '1987' and $doctype = 'technical-report') or ($layoutVersion = '1979' and $doctype = 'addendum'))">
						<fo:page-sequence master-reference="preface-1987_TR"  format="i" force-page-count="no-force">
							
							<xsl:call-template name="insertHeaderFooter">
								<xsl:with-param name="font-weight">normal</xsl:with-param>
								<xsl:with-param name="is_footer">false</xsl:with-param>
							</xsl:call-template>
							
							<fo:static-content flow-name="left-region-first_1987_TR" role="artifact">
								<fo:block-container reference-orientation="90">
									<fo:block font-size="8pt" margin-left="5mm" margin-top="8mm">
										<xsl:value-of select="$ISOnumber"/>
									</fo:block>
								</fo:block-container>
							</fo:static-content>
							
							<fo:static-content flow-name="footer-preface-first_1987_TR" role="artifact">
								<fo:block-container font-size="8pt" margin-bottom="3mm">
									<xsl:call-template name="insertSingleLine"/>
									<fo:block font-size="11pt" font-weight="bold" text-align-last="justify" margin-top="0.5mm" margin-right="1mm">
										<fo:inline keep-together.within-line="always" role="SKIP">
											<xsl:value-of select="$udc"/>
											<fo:leader leader-pattern="space"/>
											<fo:inline role="SKIP">
												<xsl:value-of select="concat($i18n_reference_number_abbrev, '&#xa0;', $ISOnumber)"/>
											</fo:inline>
										</fo:inline>
									</fo:block>
									
									<xsl:if test="/mn:metanorma/mn:bibdata/mn:keyword">
										<fo:block margin-top="6pt">
											<fo:inline font-weight="bold"><xsl:value-of select="$i18n_descriptors"/> : </fo:inline>
											<xsl:call-template name="insertKeywords">
												<xsl:with-param name="sorting">no</xsl:with-param>
												<xsl:with-param name="charDelim" select="',  '"/>
											</xsl:call-template>
										</fo:block>
									</xsl:if>
								
									<fo:table table-layout="fixed" width="100%" margin-top="14pt" font-size="7.5pt">
										<fo:table-body>
											<fo:table-row>
												<fo:table-cell>
													<fo:block>
														<xsl:apply-templates select="/mn:metanorma/mn:boilerplate/mn:copyright-statement"/>
													</fo:block>
												</fo:table-cell>
												<fo:table-cell display-align="after" text-align="right">
													<fo:block>
														<xsl:call-template name="insertPriceBasedOn"/>
													</fo:block>
												</fo:table-cell>
											</fo:table-row>
										</fo:table-body>
									</fo:table>
								</fo:block-container>
							</fo:static-content> <!-- footer-preface-first_1987_TR -->
							
							<fo:flow flow-name="xsl-region-body">
								<fo:table table-layout="fixed" width="100%">
									<fo:table-column column-width="proportional-column-width(68)"/>
									<fo:table-column column-width="proportional-column-width(112)"/>
									<fo:table-body>
										<fo:table-row>
											<fo:table-cell number-rows-spanned="2">
												<fo:block font-size="0">
													<xsl:variable name="content-height">25</xsl:variable>
													<fo:external-graphic src="{concat('data:image/png;base64,', normalize-space($Image-ISO-Logo-1987))}" content-height="{$content-height}mm" content-width="scale-to-fit" scaling="uniform" fox:alt-text="Image ISO Logo"/>
												</fo:block>
											</fo:table-cell>
											<fo:table-cell font-size="11pt" font-weight="bold">
												<fo:block>
													<xsl:choose>
														<xsl:when test="$doctype = 'addendum'">
															<xsl:variable name="doctype_international_standard">
																<xsl:call-template name="getLocalizedString"><xsl:with-param name="key">doctype_dict.international-standard</xsl:with-param></xsl:call-template>
															</xsl:variable>
															<xsl:value-of select="java:toUpperCase(java:java.lang.String.new($doctype_international_standard))"/>
															<xsl:text>&#xa0;</xsl:text>
															<xsl:value-of select="translate(substring-before($docidentifier_undated, '/'),':','-')"/>
															<xsl:text>/</xsl:text>
															<xsl:value-of select="$doctype_localized"/>
															<xsl:text>&#xa0;</xsl:text>
															<xsl:value-of select="/mn:metanorma/mn:bibdata/mn:ext/mn:structuredidentifier/mn:project-number/@addendum"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="$doctype_uppercased"/>&#xa0;<xsl:value-of select="/mn:metanorma/mn:bibdata/mn:docnumber"/>
														</xsl:otherwise>
													</xsl:choose>
												</fo:block>
											</fo:table-cell>
										</fo:table-row>
										<fo:table-row display-align="after">
											<fo:table-cell>
												<fo:block margin-bottom="-1mm">Published <xsl:value-of select="/mn:metanorma/mn:bibdata/mn:date[@type = 'published']"/></fo:block>
											</fo:table-cell>
										</fo:table-row>
									</fo:table-body>
								</fo:table>
								
								<fo:block font-size="6pt" margin-top="8mm" margin-bottom="18mm" text-align-last="justify"><xsl:value-of select="$ISO_title_en"/>&#x25cf;<xsl:value-of select="$ISO_title_ru"/>&#x25cf;<xsl:value-of select="$ISO_title_fr"/></fo:block>
								
								<fo:block-container margin-bottom="22mm" role="SKIP">
									<fo:block font-size="18pt" font-weight="bold" role="H1" line-height="1.05">
										<xsl:call-template name="insertTitlesLangMain"/>
									</fo:block>
									<xsl:choose>
										<xsl:when test="$doctype = 'addendum'">
											<fo:block font-size="12pt" font-weight="bold" role="H2" line-height="1.05" margin-top="6pt">
												<xsl:call-template name="printAddendumTitle"/>
											</fo:block>
											
											<xsl:apply-templates select="/mn:metanorma/mn:preface/mn:clause[@type = 'provenance']">
												<xsl:with-param name="process">true</xsl:with-param>
											</xsl:apply-templates>
											
										</xsl:when>
										<xsl:otherwise>
											<xsl:for-each select="xalan:nodeset($lang_other)/mnx:lang">
												<xsl:variable name="lang_other" select="."/>
												<fo:block font-size="12pt" role="SKIP"><xsl:value-of select="$linebreak"/></fo:block>
												<fo:block role="H1" font-style="italic" line-height="1.2">
													<!-- Example: title-intro fr -->
													<xsl:call-template name="insertTitlesLangOther">
														<xsl:with-param name="lang_other" select="$lang_other"/>
													</xsl:call-template>
												</fo:block>
											</xsl:for-each>
										</xsl:otherwise>
									</xsl:choose>
								</fo:block-container>
								
								<xsl:if test="$doctype = 'addendum'">
									<fo:block break-after="page"/>
								</xsl:if>
								
								<!-- ToC, Foreword, Introduction -->					
								<xsl:call-template name="processPrefaceSectionsDefault"/>
								
							</fo:flow>
						</fo:page-sequence>
					</xsl:when> <!-- (($layoutVersion = '1987' and $doctype = 'technical-report') or ($layoutVersion = '1979' and $doctype = 'addendum')) -->
					<xsl:otherwise>
					
						<xsl:variable name="copyright-statement">
							<xsl:apply-templates select="/mn:metanorma/mn:boilerplate/mn:copyright-statement"/>
						</xsl:variable>
						
						<xsl:for-each select="xalan:nodeset($updated_xml_with_pages)"> <!-- set context to preface/sections -->
						
							<xsl:for-each select=".//mn:page_sequence[parent::mn:preface][normalize-space() != '' or .//mn:image or .//*[local-name() = 'svg']]">
							
								<fo:page-sequence format="i" force-page-count="no-force">
								
									<xsl:attribute name="master-reference">
										<xsl:value-of select="concat('preface',$document-master-reference_addon)"/>
										<xsl:call-template name="getPageSequenceOrientation"/>
									</xsl:attribute>
								
									<xsl:if test="position() = last()">
										<xsl:attribute name="force-page-count"><xsl:value-of select="$force-page-count-preface"/></xsl:attribute> <!-- to prevent empty pages -->
									</xsl:if>
								
									<xsl:if test="$layoutVersion = '1972' or $layoutVersion = '1979' or $layoutVersion = '1987' or ($layoutVersion = '1989' and $revision_date_num &lt;= 19981231)">
										<xsl:attribute name="master-reference">preface-1972-1998</xsl:attribute>
									</xsl:if>
									<xsl:if test="$layoutVersion = '2024'">
										<fo:static-content flow-name="xsl-footnote-separator">
											<fo:block margin-bottom="6pt">
												<fo:leader leader-pattern="rule" leader-length="51mm" rule-thickness="0.5pt"/>
											</fo:block>
										</fo:static-content>
									</xsl:if>
									<xsl:call-template name="insertHeaderFooter">
										<xsl:with-param name="font-weight">normal</xsl:with-param>
										<xsl:with-param name="is_footer">true</xsl:with-param>
									</xsl:call-template>
									<fo:flow flow-name="xsl-region-body" line-height="115%">
									
										<xsl:if test="position() = 1">
									
											<xsl:if test="$layoutVersion = '1989' and $revision_date_num &gt;= 19990101">
												<!-- PDF disclaimer -->
												<fo:block-container position="absolute" left="0mm" top="0mm" width="172mm" role="SKIP" border="0.5pt solid black">
													<fo:block-container border="0.5pt solid black">
														<fo:block font-size="8pt" text-align="justify" line-height="1.2" margin="1.8mm">
															<xsl:choose>
																<xsl:when test="$lang = 'fr'">
																	<fo:block text-align="center" font-size="9pt" font-weight="bold" margin-bottom="6pt">PDF — Exonération de responsabilité</fo:block>
																	<fo:block margin-bottom="4pt">Le présent fichier PDF peut contenir des polices de caractères intégrées. Conformément aux conditions de licence d'Adobe, ce fichier peut
																	être imprimé ou visualisé, mais ne doit pas être modifié à moins que l'ordinateur employé à cet effet ne bénéficie d'une licence autorisant l'utilisation
																	de ces polices et que celles-ci y soient installées. Lors du téléchargement de ce fichier, les parties concernées acceptent de fait la responsabilité
																	de ne pas enfreindre les conditions de licence d'Adobe. Le Secrétariat central de l'ISO décline toute responsabilité en la matière. </fo:block>
																	<fo:block margin-bottom="4pt">Adobe est une marque déposée d'Adobe Systems Incorporated.</fo:block>
																	<fo:block>Les détails relatifs aux produits logiciels utilisés pour la création du présent fichier PDF sont disponibles dans la rubrique General Info du fichier;
																	les paramètres de création PDF ont été optimisés pour l'impression. Toutes les mesures ont été prises pour garantir l'exploitation de ce 
																	fichier par les comités membres de l'ISO. Dans le cas peu probable où surviendrait un problème d'utilisation, veuillez en informer le Secrétariat
																	central à l'adresse donnée ci-dessous.</fo:block>
																</xsl:when>
																<xsl:when test="$lang = 'ru'">
																	<fo:block text-align="center" font-size="9pt" font-weight="bold" margin-bottom="6pt">Oткaз oт oтвeтствeннoсти при рaбoтe в PDF</fo:block>
																	<fo:block margin-bottom="4pt">Нaстoящий фaйл PDF мoжeт сoдeржaть интeгрирoвaнныe шрифты. В сooтвeтствии с услoвиями лицeнзирoвaния, принятыми 
																	фирмoй Adobe, этoт фaйл мoжeт быть oтпeчaтaн или прoсмoтрeн нa экрaнe, oднaкo oн нe дoлжeн быть измeнeн, пoкa нe будeт 
																	пoлучeнa лицeнзия нa интeгрирoвaнныe шрифты и oни нe будут устaнoвлeны нa кoмпьютeрe, нa кoтoрoм вeдeтся рeдaктирoвaниe. 
																	В случae зaгрузки нaстoящeгo фaйлa зaинтeрeсoвaнныe стoрoны принимaют нa сeбя oтвeтствeннoсть зa сoблюдeниe лицeнзиoнныx 
																	услoвий фирмы Adobe. Цeнтрaльный сeкрeтaриaт ИСO нe нeсeт никaкoй oтвeтствeннoсти в этoм oтнoшeнии.</fo:block>
																	<fo:block margin-bottom="4pt">Adobe являeтся тoргoвым знaкoм фирмы Adobe Systems Incorporated.</fo:block>
																	<fo:block>Пoдрoбнoсти, oтнoсящиeся к прoгрaммным прoдуктaм, испoльзoвaнныe для сoздaния нaстoящeгo фaйлa PDF, мoгут быть нaйдeны 
																	в рубрикe General Info фaйлa; пaрaмeтры для сoздaния PDF были oптимизирoвaны для пeчaти. Были приняты вo внимaниe всe 
																	мeры прeдoстoрoжнoсти с тeм,чтoбы oбeспeчить пригoднoсть нaстoящeгo фaйлa для испoльзoвaния кoмитeтaми-члeнaми ИСO. В 
																	рeдкиx случaяx вoзникнoвeния прoблeмы, связaннoй сo скaзaнным вышe, прoсьбa прoинфoрмирoвaть Цeнтрaльный сeкрeтaриaт пo 
																	aдрeсу, привeдeннoму нижe.</fo:block>
																</xsl:when>
																<xsl:otherwise> <!-- by default -->
																	<fo:block text-align="center" font-size="9pt" font-weight="bold" margin-bottom="6pt">PDF disclaimer</fo:block>
																	<fo:block margin-bottom="4pt">This PDF file may contain embedded typefaces. In accordance with Adobe's licensing policy, this file may be printed or viewed but 
																		shall not be edited unless the typefaces which are embedded are licensed to and installed on the computer performing the editing. In 
																		downloading this file, parties accept therein the responsibility of not infringing Adobe's licensing policy. The ISO Central Secretariat
																		accepts no liability in this area.</fo:block>
																	<fo:block margin-bottom="4pt">Adobe is a trademark of Adobe Systems Incorporated.</fo:block>
																	<fo:block>Details of the software products used to create this PDF file can be found in the General Info relative to the file; the PDF-creation 
																		parameters were optimized for printing. Every care has been taken to ensure that the file is suitable for use by ISO member bodies. In
																		the unlikely event that a problem relating to it is found, please inform the Central Secretariat at the address given below.</fo:block>
																</xsl:otherwise>
															</xsl:choose>
														</fo:block>
													</fo:block-container>
												</fo:block-container>
											</xsl:if>
											
											
											<xsl:choose>
												<xsl:when test="$layoutVersion = '1972' or $layoutVersion = '1979' or $layoutVersion = '1987' or ($layoutVersion = '1989' and $revision_date_num &lt;= 19981231)"><!-- copyright renders in the footer footer-preface-first_1987-1998--></xsl:when>
												<xsl:otherwise>
												
													<!-- <xsl:if test="/mn:metanorma/mn:boilerplate/mn:copyright-statement"> -->
													<xsl:if test="normalize-space($copyright-statement) != ''">
													
														<fo:block-container height="252mm" display-align="after" role="SKIP">
															<xsl:if test="$layoutVersion = '1989'">
																<xsl:attribute name="height">241.5mm</xsl:attribute>
															</xsl:if>
															<xsl:if test="$layoutVersion = '2024'">
																<xsl:attribute name="width">172mm</xsl:attribute>
															</xsl:if>
															<!-- <fo:block margin-bottom="3mm">
																<fo:external-graphic src="{concat('data:image/png;base64,', normalize-space($Image-Attention))}" width="14mm" content-height="13mm" content-width="scale-to-fit" scaling="uniform" fox:alt-text="Image {@alt}"/>								
																<fo:inline padding-left="6mm" font-size="12pt" font-weight="bold"></fo:inline>
															</fo:block> -->
															<fo:block line-height="90%" role="SKIP">
																<fo:block font-size="9pt" text-align="justify" role="SKIP">
																	<xsl:if test="$layoutVersion = '1989'">
																		<xsl:attribute name="font-size">8pt</xsl:attribute>
																	</xsl:if>
																	<!-- <xsl:if test="$layoutVersion = '2024'">
																		<xsl:attribute name="font-size">8.6pt</xsl:attribute>
																	</xsl:if> -->
																	<!-- <xsl:apply-templates select="/mn:metanorma/mn:boilerplate/mn:copyright-statement"/> -->
																	<xsl:copy-of select="$copyright-statement"/>
																</fo:block>
															</fo:block>
														</fo:block-container>
														<!-- <xsl:if test="/mn:metanorma/mn:preface/*"> -->
														<!-- <xsl:copy-of select="."/> -->
														
														<xsl:if test="//mn:preface/*">
															<fo:block break-after="page"/>
														</xsl:if>
													</xsl:if>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:if> <!-- for 1st page_sequence only -->
										
										<!-- ToC, Foreword, Introduction -->					
										<!-- <xsl:call-template name="processPrefaceSectionsDefault"/> -->
										
										<xsl:apply-templates />
										
										<fo:block/> <!-- for prevent empty preface -->
									</fo:flow>
								</fo:page-sequence>
							
							</xsl:for-each>
						</xsl:for-each>
						
					</xsl:otherwise>
				</xsl:choose>
				
				
				<!-- for layout 1951 -->
				<xsl:variable name="preface_introduction">
					<xsl:apply-templates select="/*/mn:preface/mn:introduction"/>
				</xsl:variable>
		
		
				<xsl:if test="$debug = 'true'">
					<xsl:message>START xalan:nodeset($updated_xml_with_pages) for sections</xsl:message>
				</xsl:if>
				<xsl:variable name="startTimeC" select="java:getTime(java:java.util.Date.new())"/>
				
				<xsl:for-each select="xalan:nodeset($updated_xml_with_pages)"> <!-- set context to sections, if top element in 'sections' -->
				
					<xsl:for-each select=".//mn:page_sequence[not(parent::mn:preface)][normalize-space() != '' or .//mn:image or .//*[local-name() = 'svg']]">
				
						<!-- BODY -->
						<fo:page-sequence force-page-count="no-force">
						
							<!-- Example: msster-reference document-landscape_first_sequence -->
							<xsl:attribute name="master-reference">
								<xsl:value-of select="concat('document',$document-master-reference_addon)"/>
								<!-- <xsl:variable name="previous_orientation" select="preceding-sibling::page_sequence[@orientation][1]/@orientation"/>
								<xsl:if test="(@orientation = 'landscape' or $previous_orientation = 'landscape') and not(@orientation = 'portrait')">-<xsl:value-of select="@orientation"/></xsl:if> -->
								<xsl:call-template name="getPageSequenceOrientation"/>
								<xsl:if test="position() = 1">
									<xsl:if test="normalize-space($document-master-reference_addon) = ''">_first_sequence</xsl:if>
								</xsl:if>
							</xsl:attribute>
							<xsl:if test="position() = 1">
								<xsl:attribute name="initial-page-number">1</xsl:attribute>
							</xsl:if>
							<xsl:if test="$layoutVersion = '1951'">
								<xsl:attribute name="initial-page-number">auto</xsl:attribute>
								<xsl:attribute name="force-page-count">end-on-even</xsl:attribute>
							</xsl:if>
							<fo:static-content flow-name="xsl-footnote-separator">
								<fo:block>
									<xsl:if test="$layoutVersion = '2024'">
										<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
									</xsl:if>
									<fo:leader leader-pattern="rule" leader-length="30%">
										<xsl:if test="$layoutVersion = '2024'">
											<xsl:attribute name="leader-length">51mm</xsl:attribute>
											<xsl:attribute name="rule-thickness">0.5pt</xsl:attribute>
										</xsl:if>
									</fo:leader>
								</fo:block>
							</fo:static-content>
							
							<xsl:variable name="border_around_page"><xsl:if test="$layoutVersion = '1951'">true</xsl:if></xsl:variable>
							<xsl:call-template name="insertHeaderFooter">
								<xsl:with-param name="border_around_page" select="$border_around_page"/>
								<xsl:with-param name="insert_header_first" select="normalize-space(position() = 1)"/>
							</xsl:call-template>
							<fo:flow flow-name="xsl-region-body">
							
								
								<!-- Information and documentation — Codes for transcription systems -->
								<!-- <fo:block-container>
									
									<fo:block font-size="18pt" font-weight="bold" margin-top="40pt" margin-bottom="20pt" line-height="1.1" role="H1">
									
										<fo:block role="SKIP">
										
											<xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:title[@language = $lang and @type = 'title-intro']"/>
											
											<xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:title[@language = $lang and @type = 'title-main']"/>
											
											<xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:title[@language = $lang and @type = 'title-part']">
												<xsl:with-param name="isMainLang">true</xsl:with-param>
												<xsl:with-param name="isMainBody">true</xsl:with-param>
											</xsl:apply-templates>
											
										</fo:block>
										<fo:block role="SKIP">
											<xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:title[@language = $lang and @type = 'title-part']/node()"/>
										</fo:block>
										
										<xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:title[@language = $lang and @type = 'title-amd']">
											<xsl:with-param name="isMainLang">true</xsl:with-param>
											<xsl:with-param name="isMainBody">true</xsl:with-param>
										</xsl:apply-templates>
										
									</fo:block>
								
								</fo:block-container> -->
								<!-- Clause(s) -->
								<!-- <fo:block> -->
									
								<xsl:if test="position() = 1 and $layoutVersion = '1951'">
									<!-- first page header -->
									<!-- Example: ISO Recommendation R 453 November 1965 -->
									<fo:block-container margin-top="-8mm" margin-left="-12mm" margin-right="-12mm">
										<xsl:if test="$revision_date_num &gt;= 19690101">
											<xsl:attribute name="margin-top">-9mm</xsl:attribute>
											<xsl:attribute name="margin-left">-12.5mm</xsl:attribute>
											<xsl:attribute name="margin-right">-12.5mm</xsl:attribute>
										</xsl:if>
										<fo:block-container margin-left="0" margin-right="0" border-bottom="1.25pt solid black">
											<fo:table table-layout="fixed" width="100%" font-family="Arial" font-size="13pt">
												<xsl:if test="$revision_date_num &gt;= 19690101">
													<xsl:attribute name="font-size">10pt</xsl:attribute>
												</xsl:if>
												<fo:table-column column-width="proportional-column-width(9.5)"/>
												<fo:table-column column-width="proportional-column-width(65)"/>
												<fo:table-column column-width="proportional-column-width(34)"/>
												<fo:table-column column-width="proportional-column-width(50)"/>
												<fo:table-column column-width="proportional-column-width(9.5)"/>
												<fo:table-body>
													<fo:table-row height="10mm">
														<xsl:if test="$revision_date_num &gt;= 19690101">
															<xsl:attribute name="height">7mm</xsl:attribute>
														</xsl:if>
														<fo:table-cell><fo:block>&#xa0;</fo:block></fo:table-cell>
														<fo:table-cell>
															<fo:block>
																<xsl:value-of select="$doctype_localized"/>
															</fo:block>
														</fo:table-cell>
														<fo:table-cell text-align="center"><fo:block><xsl:value-of select="$docnumber_with_prefix"/></fo:block></fo:table-cell>
														<fo:table-cell text-align="right">
															<fo:block>
																<xsl:call-template name="convertDate">
																	<xsl:with-param name="date" select="$revision_date"/>
																</xsl:call-template>
															</fo:block>
														</fo:table-cell>
														<fo:table-cell><fo:block>&#xa0;</fo:block></fo:table-cell>
													</fo:table-row>
												</fo:table-body>
											</fo:table>
										</fo:block-container>
									</fo:block-container>
									
									<!-- Show Introduction in the main section -->
									<!-- <xsl:apply-templates select="/*/mn:preface/mn:introduction"/> -->
									<xsl:copy-of select="$preface_introduction"/>
								</xsl:if> <!-- $layoutVersion = '1951' -->
									
									<!-- <xsl:choose>
										<xsl:when test="($layoutVersion = '1951' or $layoutVersion = '1972' or $layoutVersion = '1979' or $layoutVersion = '1987' or $layoutVersion = '1989') and $layout_columns != 1">
											<xsl:choose>
												<xsl:when test="$doctype = 'amendment'">
													<xsl:variable name="flatxml">
														<xsl:apply-templates select="/mn:metanorma/mn:sections/*" mode="flatxml"/>
													</xsl:variable>
													<xsl:apply-templates select="xalan:nodeset($flatxml)/*"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:call-template name="processMainSectionsDefault_flatxml"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:when> ($layoutVersion = '1972' or $layoutVersion = '1979' or $layoutVersion = '1987' or $layoutVersion = '1989') and $layout_columns != 1 
										<xsl:otherwise>
											<xsl:choose>
												<xsl:when test="$doctype = 'amendment'">
													<xsl:apply-templates select="/mn:metanorma/mn:sections/*"/>
												</xsl:when>
												<xsl:otherwise>  -->
													<!-- <xsl:call-template name="processMainSectionsDefault"/> -->
													<!-- 	<xsl:apply-templates />
												</xsl:otherwise>
											</xsl:choose>
										</xsl:otherwise>
									</xsl:choose> -->
									
									<xsl:apply-templates />
									
									<xsl:if test="position() = last()">
										<xsl:call-template name="insertSmallHorizontalLine"/>
										<xsl:call-template name="insertLastBlock"/>
									</xsl:if>
									
							</fo:flow>
						</fo:page-sequence>
				
					</xsl:for-each>
				</xsl:for-each>
				
				<xsl:if test="$debug = 'true'">
					<xsl:message>END  xalan:nodeset($updated_xml_with_pages) for sections</xsl:message>
					<xsl:message>DEBUG: processing time <xsl:value-of select="java:getTime(java:java.util.Date.new()) - $startTimeC"/> msec.</xsl:message>
				</xsl:if>
				
				
				<!-- Index -->
				<!-- <xsl:message>START current_document_index_id</xsl:message> -->
				
				<xsl:variable name="docid">
					<xsl:call-template name="getDocumentId"/>
				</xsl:variable>
		
				<xsl:variable name="current_document_index_id">
					<xsl:apply-templates select="//mn:indexsect" mode="index_add_id">
						<xsl:with-param name="docid" select="$docid"/>
					</xsl:apply-templates>
				</xsl:variable>
				<!-- <xsl:message>END current_document_index_id</xsl:message> -->
				
				<!-- <xsl:message>START current_document_index</xsl:message> -->
				<xsl:variable name="startTime1" select="java:getTime(java:java.util.Date.new())"/>
				<xsl:variable name="current_document_index">
					<xsl:apply-templates select="xalan:nodeset($current_document_index_id)" mode="index_update"/>
				</xsl:variable>
				<!-- <xsl:variable name="endTime1" select="java:getTime(java:java.util.Date.new())"/>
				<xsl:message>DEBUG: processing time <xsl:value-of select="$endTime1 - $startTime1"/> msec.</xsl:message>
				<xsl:message>END current_document_index</xsl:message> -->
				
				
				<!-- <xsl:variable name="startTime2" select="java:getTime(java:java.util.Date.new())"/>
				<xsl:message>START xalan:nodeset</xsl:message> -->
				<!-- <xsl:apply-templates select="//mn:indexsect" mode="index"/> -->
				<xsl:apply-templates select="xalan:nodeset($current_document_index)" mode="index"/>
				<!-- <xsl:variable name="endTime2" select="java:getTime(java:java.util.Date.new())"/>
				<xsl:message>DEBUG: processing time <xsl:value-of select="$endTime2 - $startTime2"/> msec.</xsl:message>
				<xsl:message>END xalan:nodeset</xsl:message> -->
				
				<xsl:call-template name="back-page"/>
				
			</xsl:for-each>
		</fo:root>
		
	</xsl:template>
	

	<xsl:template name="printAddendumTitle">
		<xsl:value-of select="java:toUpperCase(java:java.lang.String.new($doctype))"/>
		<xsl:text>&#xa0;</xsl:text>
		<xsl:value-of select="/mn:metanorma/mn:bibdata/mn:ext/mn:structuredidentifier/mn:project-number/@addendum"/>
		<xsl:text>&#xa0;:&#xa0;</xsl:text>
		<xsl:value-of select="/mn:metanorma/mn:bibdata/mn:title[@type = 'title-add']"/>
	</xsl:template>

	<xsl:template match="mn:preface/mn:clause[@type = 'provenance']" priority="5">
		<xsl:param name="process">false</xsl:param>
		<xsl:if test="$process = 'true'">
			<fo:block margin-top="30mm" role="SKIP" font-size="8pt">
				<xsl:apply-templates />
			</fo:block>
		</xsl:if>
	</xsl:template>


	<xsl:template name="insertMainSectionsAmendmentPageSequences">
		<xsl:element name="sections" namespace="{$namespace_full}"> <!-- save context element -->
			<xsl:element name="page_sequence" namespace="{$namespace_full}">
				<xsl:for-each select="/*/mn:sections/*">
					<xsl:sort select="@displayorder" data-type="number"/>
					<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak"/>
				</xsl:for-each>
			</xsl:element>
		</xsl:element>
	</xsl:template> <!-- END: processMainSectionsAmendmentDefault_items -->


	<xsl:template name="processPrefaceAndMainSectionsISO_items">
			
		<!-- <xsl:if test="$debug = 'true'"><xsl:message>START updated_xml_step_move_pagebreak</xsl:message></xsl:if>
		<xsl:variable name="startTime1" select="java:getTime(java:java.util.Date.new())"/> -->
		
		<xsl:variable name="updated_xml_step_move_pagebreak">
			<xsl:element name="{$root_element}" namespace="{$namespace_full}">
				<xsl:call-template name="copyCommonElements"/>
				<xsl:call-template name="insertPrefaceSectionsPageSequences"/>
				<xsl:choose>
					<xsl:when test="$doctype = 'amendment'">
						<xsl:call-template name="insertMainSectionsAmendmentPageSequences"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="insertMainSectionsPageSequences"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
		</xsl:variable>
		<!-- <xsl:variable name="endTime1" select="java:getTime(java:java.util.Date.new())"/>
		<xsl:if test="$debug = 'true'">
			<xsl:message>DEBUG: processing time <xsl:value-of select="$endTime1 - $startTime1"/> msec.</xsl:message>
			<xsl:message>END updated_xml_step_move_pagebreak</xsl:message>
		</xsl:if> -->
		
		<xsl:variable name="updated_xml_step_move_pagebreak_filename" select="concat($output_path,'_main_', java:getTime(java:java.util.Date.new()), '.xml')"/>
		
	<!-- 	<xsl:if test="$debug = 'true'"><xsl:message>START write updated_xml_step_move_pagebreak</xsl:message></xsl:if>
		<xsl:variable name="startTime2" select="java:getTime(java:java.util.Date.new())"/> -->
		<redirect:write file="{$updated_xml_step_move_pagebreak_filename}">
			<xsl:copy-of select="$updated_xml_step_move_pagebreak"/>
		</redirect:write>
		<!-- <xsl:variable name="endTime2" select="java:getTime(java:java.util.Date.new())"/>
		<xsl:if test="$debug = 'true'">
			<xsl:message>DEBUG: processing time <xsl:value-of select="$endTime2 - $startTime2"/> msec.</xsl:message>
			<xsl:message>END write updated_xml_step_move_pagebreak</xsl:message>
		</xsl:if> -->
		
		
		<!-- <xsl:if test="$debug = 'true'"><xsl:message>START loading document() updated_xml_step_move_pagebreak</xsl:message></xsl:if>
		<xsl:variable name="startTime3" select="java:getTime(java:java.util.Date.new())"/> -->
		<xsl:copy-of select="document($updated_xml_step_move_pagebreak_filename)"/>
		
		<!-- <xsl:variable name="endTime3" select="java:getTime(java:java.util.Date.new())"/>
		<xsl:if test="$debug = 'true'">
			<xsl:message>DEBUG: processing time <xsl:value-of select="$endTime3 - $startTime3"/> msec.</xsl:message>
			<xsl:message>END loading document() updated_xml_step_move_pagebreak</xsl:message>
		</xsl:if>
		 -->
		
		<xsl:if test="$debug = 'true'">
			<redirect:write file="page_sequence_preface_and_main.xml">
				<xsl:copy-of select="$updated_xml_step_move_pagebreak"/>
			</redirect:write>
		</xsl:if>
		
		<xsl:call-template name="deleteFile">
			<xsl:with-param name="filepath" select="$updated_xml_step_move_pagebreak_filename"/>
		</xsl:call-template>
	</xsl:template> <!-- END: processPrefaceAndMainSectionsISO_items -->

	<xsl:template name="cover-page">
		<xsl:if test="$isGenerateTableIF = 'false'"> <!-- no need cover page for auto-layout algorithm -->
			<xsl:variable name="fo_cover_page">
			<!-- cover page -->
			<xsl:choose>
				<xsl:when test="$layoutVersion = '1951'">
					<fo:page-sequence master-reference="cover-page_1951" force-page-count="no-force">
						<fo:static-content flow-name="cover-page-header" font-family="Times New Roman" font-size="8.5pt" font-weight="bold">
							<xsl:if test="$revision_date_num &lt; 19680101">
								<xsl:attribute name="font-family">Arial</xsl:attribute>
								<xsl:attribute name="font-size">8pt</xsl:attribute>
							</xsl:if>
							<fo:block-container height="99%" display-align="after">
								<fo:block text-align-last="justify" role="SKIP">
									<!-- Example: UDC 669.7 : 620.178.1 -->
									<xsl:value-of select="$udc"/>
									<fo:inline keep-together.within-line="always" role="SKIP">
										<fo:leader leader-pattern="space"/>
										<fo:inline font-weight="normal"><xsl:value-of select="concat($i18n_reference_number_abbrev, ' : ')"/></fo:inline><xsl:value-of select="$ISOnumber"/> <!-- font-family="Arial" -->
									</fo:inline>
								</fo:block>
							</fo:block-container>
						</fo:static-content>
						<fo:static-content flow-name="cover-page-footer" font-size="9.5pt">
							<fo:block text-align="center">
								<!-- COPYRIGHT RESERVED -->
								<xsl:apply-templates select="/mn:metanorma/mn:boilerplate/mn:copyright-statement"/>
							</fo:block>
						</fo:static-content>
						<fo:flow flow-name="xsl-region-body">
							<fo:block text-align="center" font-family="Arial" margin-top="14mm">
								<fo:block>
									<fo:instream-foreign-object content-width="23mm" fox:alt-text="Image ISO Logo">
										<xsl:copy-of select="$Image-ISO-Logo-1951-SVG"/>
									</fo:instream-foreign-object>
								</fo:block>
								<fo:block margin-top="2mm" font-size="8pt" font-weight="bold">
									<xsl:call-template name="add-letter-spacing">
										<xsl:with-param name="text">
											<xsl:choose>
												<xsl:when test="$lang = 'fr'"><xsl:value-of select="java:toUpperCase(java:java.lang.String.new('Organisation Internationale de Normalisation'))"/></xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="java:toUpperCase(java:java.lang.String.new(/mn:metanorma/mn:bibdata/mn:copyright/mn:owner/mn:organization/mn:name))"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:with-param>
										<xsl:with-param name="letter-spacing" select="0.55"/>
									</xsl:call-template>
								</fo:block>
								
								<fo:block font-size="20pt" margin-top="31mm">
									<!-- ISO RECOMMENDATION -->
									<xsl:call-template name="add-letter-spacing">
										<xsl:with-param name="text" select="$doctype_uppercased"/>
										<xsl:with-param name="letter-spacing" select="0.35"/>
									</xsl:call-template>
								</fo:block>
								<fo:block font-size="24pt" margin-top="5mm">
									<xsl:value-of select="$docnumber_with_prefix"/>
								</fo:block>
								
								<fo:block-container height="39mm" display-align="center">
									<fo:block font-size="11pt">
										<xsl:if test="$revision_date_num &lt; 19680101">
											<xsl:attribute name="font-size">14pt</xsl:attribute>
										</xsl:if>
										
										<xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:title[@language = $lang and @type = 'title-intro']"/>
										<xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:title[@language = $lang and @type = 'title-main']"/>
										<xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:title[@language = $lang and @type = 'title-complementary']"/>
										<fo:block font-size="11pt" text-transform="uppercase" margin-top="2mm">
											<xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:title[@language = $lang and @type = 'title-part']/node()"/>
										</fo:block>
										
									</fo:block>
								</fo:block-container>
								
								<fo:block-container margin-top="8.5mm" font-size="10pt"> <!--  height="40mm" display-align="center"  -->
									<!-- Example: 1st EDITION -->
									<!-- <fo:block><xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:edition[@language != '']" /></fo:block> -->
									<fo:block><xsl:value-of select="/mn:metanorma/mn:bibdata/mn:edition[@language != '']" /></fo:block> <!--  font-weight="bold" -->
									<!-- <fo:block>&#xa0;</fo:block> -->
									<!-- Example: October 1971 -->
									<fo:block margin-top="2mm" font-size="9pt">
										<xsl:call-template name="convertDate">
											<xsl:with-param name="date" select="/mn:metanorma/mn:bibdata/mn:version/mn:revision-date"/>
										</xsl:call-template>
									</fo:block>
									<fo:block margin-top="14mm">
										<xsl:value-of select="/mn:metanorma/mn:bibdata/mn:ext/mn:edn-replacement"/>
									</fo:block>
								</fo:block-container>
							</fo:block>
						</fo:flow>
					</fo:page-sequence>
				</xsl:when> <!-- END: $layoutVersion = '1951' -->
				
				<xsl:when test="$layoutVersion = '1972' or ($layoutVersion = '1979' and not($doctype = 'addendum'))">
					<fo:page-sequence master-reference="cover-page_1972" force-page-count="no-force">
						<fo:static-content flow-name="cover-page-footer" font-size="7pt">
							<xsl:call-template name="insertSingleLine"/>
							<fo:block font-size="11pt" font-weight="bold" text-align-last="justify" margin-right="1mm">
								<fo:inline keep-together.within-line="always" role="SKIP">
									<xsl:value-of select="$udc"/>
									<fo:leader leader-pattern="space"/>
									<fo:inline role="SKIP">
										<xsl:value-of select="concat($i18n_reference_number, '&#xa0;&#xa0;', $ISOnumber)"/>
									</fo:inline>
								</fo:inline>
							</fo:block>
							
							<xsl:if test="/mn:metanorma/mn:bibdata/mn:keyword">
								<fo:block margin-top="10pt">
									<fo:inline font-weight="bold"><xsl:value-of select="$i18n_descriptors"/> : </fo:inline>
									<xsl:call-template name="insertKeywords">
										<xsl:with-param name="sorting">no</xsl:with-param>
										<xsl:with-param name="charDelim" select="',  '"/>
									</xsl:call-template>
								</fo:block>
							</xsl:if>
							<fo:block-container position="absolute" left="0mm" top="0mm" height="25mm" text-align="right" display-align="after" role="SKIP">
								<fo:block>
									<xsl:call-template name="insertPriceBasedOn"/>
								</fo:block>
							</fo:block-container>
						</fo:static-content>
						<fo:static-content flow-name="left-region" >
							<fo:block-container reference-orientation="90">
								<fo:block font-size="8pt" margin-left="7mm" margin-top="10mm">
									<xsl:value-of select="$ISOnumber"/>
								</fo:block>
							</fo:block-container>
						</fo:static-content>
						<fo:flow flow-name="xsl-region-body">
							<xsl:variable name="docnumber">
								<xsl:variable name="value" select="/mn:metanorma/mn:bibdata/mn:docnumber"/>
								<xsl:value-of select="$value"/>
								<xsl:if test="$part != ''">/<xsl:value-of select="$part"/></xsl:if>
							</xsl:variable>
							<fo:table table-layout="fixed" width="100%" border-top="2pt solid black" border-bottom="2pt solid black">
								<xsl:choose>
									<xsl:when test="string-length($docnumber) &gt; 4">
										<fo:table-column column-width="proportional-column-width(110)"/>
										<fo:table-column column-width="proportional-column-width(28)"/>
										<fo:table-column column-width="proportional-column-width(43)"/>
									</xsl:when>
									<xsl:otherwise>
										<fo:table-column column-width="proportional-column-width(123)"/>
										<fo:table-column column-width="proportional-column-width(28)"/>
										<fo:table-column column-width="proportional-column-width(30)"/>
									</xsl:otherwise>
								</xsl:choose>
								
								<fo:table-body>
									<fo:table-row height="39mm" display-align="center">
										<xsl:if test="$layoutVersion = '1972'">
											<xsl:attribute name="height">42mm</xsl:attribute>
											<xsl:attribute name="font-family">Univers 59 Ultra Condensed</xsl:attribute>
											<xsl:attribute name="text-transform">uppercase</xsl:attribute>
										</xsl:if>
										<fo:table-cell>
											<fo:block font-size="32pt" margin-top="2mm">
												<xsl:if test="string-length($docnumber) &gt; 4">
													<xsl:attribute name="font-size">29pt</xsl:attribute>
												</xsl:if>
												<xsl:if test="$layoutVersion = '1972'">
													<xsl:attribute name="font-size">40pt</xsl:attribute>
												</xsl:if>
												<xsl:if test="$layoutVersion = '1979'">
													<xsl:attribute name="letter-spacing">-0.02em</xsl:attribute>
												</xsl:if>
												<xsl:value-of select="$doctype_localized"/>
											</fo:block>
										</fo:table-cell>
										<fo:table-cell>
											<fo:block font-size="0">
												<xsl:variable name="content-height">
													<xsl:choose>
														<xsl:when test="$layoutVersion = '1972'">33</xsl:when>
														<xsl:otherwise>27</xsl:otherwise>
													</xsl:choose>
												</xsl:variable>
												<fo:external-graphic src="{concat('data:image/png;base64,', normalize-space($Image-ISO-Logo-1972))}" content-height="{$content-height}mm" content-width="scale-to-fit" scaling="uniform" fox:alt-text="Image ISO Logo"/>
											</fo:block>
										</fo:table-cell>
										<fo:table-cell text-align="right">
											<fo:block font-size="34pt" margin-top="2mm">
												<xsl:if test="$layoutVersion = '1972'">
													<xsl:attribute name="font-size">38pt</xsl:attribute>
												</xsl:if>
												<xsl:value-of select="$docnumber"/>
											</fo:block>
										</fo:table-cell>
									</fo:table-row>
									<fo:table-row border-top="2pt solid black" height="4.5mm" display-align="center">
										<fo:table-cell number-columns-spanned="3" font-size="5.6pt" text-align-last="justify">
											<!-- <fo:block><xsl:value-of select="$ISO_title_en"/>&#x25cf;<xsl:value-of select="$ISO_title_ru"/>&#x25cf;<xsl:value-of select="$ISO_title_fr"/></fo:block> -->
											<fo:block>
												<xsl:value-of select="$ISO_title_en"/>
												<xsl:call-template name="insertBlackCircle"/>
												<xsl:value-of select="$ISO_title_ru"/>
												<xsl:call-template name="insertBlackCircle"/>
												<xsl:value-of select="$ISO_title_fr"/></fo:block>
										</fo:table-cell>
									</fo:table-row>
								</fo:table-body>
							</fo:table>
							
							<fo:block font-size="18pt" font-family="Univers" font-weight="bold" margin-top="44mm" margin-bottom="6mm" role="H1">
								<xsl:call-template name="insertTitlesLangMain"/>
							</fo:block>
							
							<xsl:for-each select="xalan:nodeset($lang_other)/mnx:lang">
								<xsl:variable name="lang_other" select="."/>
								<fo:block font-size="8pt" font-style="italic" line-height="1.1" role="H1">
									<!-- Example: title-intro fr -->
									<xsl:call-template name="insertTitlesLangOther">
										<xsl:with-param name="lang_other" select="$lang_other"/>
									</xsl:call-template>
								</fo:block>
							</xsl:for-each>
							
							<fo:block margin-top="6mm" font-weight="bold">
								<xsl:call-template name="printEdition"/>
								<xsl:value-of select="$nonbreak_space_em_dash_space"/>
								<xsl:value-of select="/mn:metanorma/mn:bibdata/mn:version/mn:revision-date"/>
							</fo:block>
							
						</fo:flow>
					</fo:page-sequence>
				</xsl:when> <!-- END: $layoutVersion = '1972' or ($layoutVersion = '1979' and not($doctype = 'addendum')) -->
				<xsl:when test="(($layoutVersion = '1987' and $doctype = 'technical-report') or ($layoutVersion = '1979' and $doctype = 'addendum'))"><!-- see preface pages below --></xsl:when>
				<xsl:when test="$layoutVersion = '1987'">
					<fo:page-sequence master-reference="cover-page_1987" force-page-count="no-force">
						<fo:static-content flow-name="right-region" >
							<fo:block-container height="50%">
								<fo:block-container margin-top="8mm" margin-left="2mm">
									<fo:block-container margin-top="0" margin-left="0" font-family="Times New Roman">
										<fo:block font-size="24pt" line-height="1.1">
											<xsl:value-of select="$docidentifierISO_with_break"/>
										</fo:block>
										<fo:block line-height="1">
											<xsl:call-template name="printEdition"/>
											<xsl:value-of select="$linebreak"/>
											<xsl:text>&#xa0;</xsl:text><xsl:value-of select="/mn:metanorma/mn:bibdata/mn:version/mn:revision-date"/>
										</fo:block>
								</fo:block-container>
								</fo:block-container>
							</fo:block-container>
							<fo:block-container height="50%" display-align="after">
								<fo:block-container margin-left="3mm">
									<fo:block-container margin-left="0" font-family="Times New Roman">
										<fo:block font-size="8pt" font-family="Times New Roman" margin-bottom="-0.5mm">
											<xsl:value-of select="$i18n_reference_number"/>
											<xsl:value-of select="$linebreak"/>
											<xsl:value-of select="$ISOnumber"/>
										</fo:block>
									</fo:block-container>
								</fo:block-container>
							</fo:block-container>
						</fo:static-content>
						<fo:flow flow-name="xsl-region-body">
							<fo:block-container height="99.5%" border="1.25pt solid black">
								<fo:block-container margin-left="11mm" margin-top="16mm" margin-right="10.5mm">
									<fo:block-container margin-left="0" margin-top="0" margin-right="0">
										<fo:block font-family="Times New Roman" font-size="24pt">
											<!-- INTERNATIONAL STANDARD -->
											<xsl:call-template name="add-letter-spacing">
												<xsl:with-param name="text" select="$doctype_uppercased"/>
												<xsl:with-param name="letter-spacing" select="0.1"/>
											</xsl:call-template>
										</fo:block>
										<fo:table table-layout="fixed" width="100%" margin-top="16mm">
											<fo:table-column column-width="proportional-column-width(23)"/>
											<fo:table-column column-width="proportional-column-width(108)"/>
											<fo:table-body>
												<fo:table-row>
													<fo:table-cell>
														<fo:block margin-top="-0.5mm" font-size="0">
															<xsl:variable name="content-height">18</xsl:variable>
															<fo:external-graphic src="{concat('data:image/png;base64,', normalize-space($Image-ISO-Logo-1987))}" content-height="{$content-height}mm" content-width="scale-to-fit" scaling="uniform" fox:alt-text="Image ISO Logo"/>
														</fo:block>
													</fo:table-cell>
													<fo:table-cell font-size="7.5pt" border-top="0.5pt solid black" border-bottom="0.5pt solid black" text-align-last="justify" display-align="center" line-height="1.6" padding-left="32mm">
														<fo:block><xsl:value-of select="$ISO_title_en"/></fo:block>
														<fo:block><xsl:value-of select="$ISO_title_fr"/></fo:block>
														<fo:block><xsl:value-of select="$ISO_title_ru"/></fo:block>
													</fo:table-cell>
												</fo:table-row>
											</fo:table-body>
										</fo:table>
										
										<fo:block font-size="13pt" font-weight="bold" margin-top="32mm" margin-bottom="9mm" role="H1">
											<xsl:call-template name="insertTitlesLangMain"/>
										</fo:block>
										
										<xsl:for-each select="xalan:nodeset($lang_other)/mnx:lang">
											<xsl:variable name="lang_other" select="."/>
											<fo:block font-size="8pt" font-style="italic" line-height="1.1" role="H1">
												<!-- Example: title-intro fr -->
												<xsl:call-template name="insertTitlesLangOther">
													<xsl:with-param name="lang_other" select="$lang_other"/>
												</xsl:call-template>
											</fo:block>
										</xsl:for-each>
										
									</fo:block-container>
								</fo:block-container>
							</fo:block-container>
						</fo:flow>
					</fo:page-sequence>
				</xsl:when> <!-- END: $layoutVersion = '1987' -->
			
				<xsl:when test="$layoutVersion = '2024'">
					<fo:page-sequence master-reference="cover-page_2024" force-page-count="no-force">
						<fo:flow flow-name="xsl-region-body">
							<fo:table table-layout="fixed" width="100%">
								<xsl:call-template name="insertInterFont"/>
								<fo:table-column column-width="proportional-column-width(113.8)"/>
								<fo:table-column column-width="proportional-column-width(2)"/>
								<fo:table-column column-width="proportional-column-width(2)"/>
								<fo:table-column column-width="proportional-column-width(72.2)"/>
								<fo:table-body>
								
									<fo:table-row>
										<fo:table-cell number-columns-spanned="2" border-right="{$cover_page_border}">
											<fo:block-container height="44mm">
												<fo:block>
													<xsl:call-template name="insertLogoImages2024"/>
												</fo:block>
											</fo:block-container>
										</fo:table-cell>
										<!-- International 
										Standard -->
										<fo:table-cell number-columns-spanned="2" padding-left="6mm">
											<fo:block-container height="46mm" role="SKIP">
												<fo:block font-size="20pt" font-weight="bold" line-height="1.25" margin-top="3mm">
												
													<xsl:variable name="updates-document-type" select="/mn:metanorma/mn:bibdata/mn:ext/mn:updates-document-type"/>
													<xsl:variable name="updates-document-type_localized">
														<xsl:call-template name="getLocalizedString">
															<xsl:with-param name="key" select="concat('doctype_dict.',$updates-document-type)"/>
														</xsl:call-template>
													</xsl:variable>
													<xsl:variable name="updates-document-type_str">
														<xsl:choose>
															<xsl:when test="$updates-document-type != '' and $updates-document-type_localized != $updates-document-type">
																<xsl:value-of select="$updates-document-type_localized"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="java:toUpperCase(java:java.lang.String.new(translate($updates-document-type,'-',' ')))"/>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:variable>
													
													<xsl:choose>
														<xsl:when test="$stage-abbreviation = 'DIS'"> <!--  or $stage-abbreviation = 'DAMD' or $stage-abbreviation = 'DAM' -->
															<xsl:choose>
																<xsl:when test="normalize-space($stagename_localized_coverpage) != ''">
																	<!-- DRAFT<br/>International Standard-->
																	<xsl:apply-templates select="xalan:nodeset($stagename_localized_coverpage)/node()"/>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:value-of select="java:toUpperCase(java:java.lang.String.new($stagename))"/>
																	<xsl:value-of select="$linebreak"/>
																	<xsl:value-of select="$doctype_localized"/>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:when>
														<!-- <xsl:when test="$stage-abbreviation = 'FDAmd' or $stage-abbreviation = 'FDAM'"><xsl:value-of select="$doctype_uppercased"/></xsl:when> -->
														<xsl:when test="$stagename-header-coverpage != ''">
															<xsl:attribute name="margin-top">12pt</xsl:attribute>
															
															<xsl:value-of select="$stagename-header-coverpage"/>
															
															<!-- if there is iteration number, then print it -->
															<xsl:variable name="iteration" select="number(/mn:metanorma/mn:bibdata/mn:status/mn:iteration)"/>
															<xsl:if test="number($iteration) = $iteration and 
																																							($stage-abbreviation = 'NWIP' or 
																																							$stage-abbreviation = 'NP' or 
																																							$stage-abbreviation = 'PWI' or 
																																							$stage-abbreviation = 'AWI' or 
																																							$stage-abbreviation = 'WD' or 
																																							$stage-abbreviation = 'CD')">
																<xsl:text>&#xA0;</xsl:text><xsl:value-of select="$iteration"/>
															</xsl:if>
															
															<xsl:value-of select="$linebreak"/>
															
															<xsl:choose>
																<xsl:when test="$doctype = 'amendment'">
																	<xsl:value-of select="$updates-document-type_str"/>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:value-of select="$doctype_localized"/>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:when>
														<xsl:when test="$doctype = 'amendment'">
															<xsl:value-of select="$updates-document-type_str"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="$doctype_localized"/>
														</xsl:otherwise>
													</xsl:choose>
													
												</fo:block>
											</fo:block-container>
										</fo:table-cell>
									</fo:table-row>
									
									<fo:table-row height="46mm">
										<fo:table-cell number-columns-spanned="2" border-right="{$cover_page_border}">
											<fo:block role="SKIP"><fo:wrapper role="artifact">&#xA0;</fo:wrapper></fo:block>
										</fo:table-cell>
										<fo:table-cell number-columns-spanned="2" display-align="after" padding-left="6mm">
											<fo:block font-size="19pt" font-weight="bold" line-height="1">
												<xsl:if test="$stage &gt;=60 and $substage != 0">
													<xsl:attribute name="color"><xsl:value-of select="$color_secondary"/></xsl:attribute>
												</xsl:if>
												<xsl:choose>
													<xsl:when test="contains($docidentifierISO, ' ')">
														<xsl:value-of select="substring-before($docidentifierISO, ' ')"/>
														<xsl:text>&#xa0;&#xa0;</xsl:text>
														<xsl:value-of select="substring-after($docidentifierISO, ' ')"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="$docidentifierISO"/>
													</xsl:otherwise>
												</xsl:choose>
											</fo:block>
										</fo:table-cell>
									</fo:table-row>
									
									<fo:table-row height="1.4mm" font-size="0pt">
										<fo:table-cell border-bottom="{$cover_page_border}"><fo:block role="SKIP"><fo:wrapper role="artifact">&#xA0;</fo:wrapper></fo:block></fo:table-cell>
										<fo:table-cell number-columns-spanned="2"><fo:block role="SKIP"><fo:wrapper role="artifact">&#xA0;</fo:wrapper></fo:block></fo:table-cell>
										<fo:table-cell border-bottom="{$cover_page_border}"><fo:block role="SKIP"><fo:wrapper role="artifact">&#xA0;</fo:wrapper></fo:block></fo:table-cell>
									</fo:table-row>
									<fo:table-row height="1.4mm" font-size="0pt">
										<fo:table-cell number-columns-spanned="4"><fo:block role="SKIP"><fo:wrapper role="artifact">&#xA0;</fo:wrapper></fo:block></fo:table-cell>
									</fo:table-row>
									
									<fo:table-row>
										<fo:table-cell number-columns-spanned="2" border-right="{$cover_page_border}" padding-right="4mm">
										
											<fo:block-container font-family="Cambria" line-height="1.1" role="SKIP" height="110mm">
												<fo:block margin-right="3.5mm" role="SKIP">
													<fo:block font-size="18pt" font-weight="bold" margin-top="2.5mm" role="H1">
														<xsl:call-template name="insertTitlesLangMain"/>
													</fo:block>
																
													<xsl:if test="not($stage-abbreviation = 'FDAMD' or $stage-abbreviation = 'FDAM')"> <!--  or $stage-abbreviation = 'PRF' -->
														<xsl:for-each select="xalan:nodeset($lang_other)/mnx:lang">
															<xsl:variable name="lang_other" select="."/>
															<fo:block font-size="12pt" role="SKIP"><xsl:value-of select="$linebreak"/></fo:block>
															<fo:block font-size="11pt" font-style="italic" line-height="1.1" role="H1">
																<!-- Example: title-intro fr -->
																<xsl:call-template name="insertTitlesLangOther">
																	<xsl:with-param name="lang_other" select="$lang_other"/>
																</xsl:call-template>
															</fo:block>
														</xsl:for-each>
													</xsl:if>
													
													<xsl:if test="$stage-abbreviation = 'NWIP' or $stage-abbreviation = 'NP' or $stage-abbreviation = 'PWI' or $stage-abbreviation = 'AWI' or $stage-abbreviation = 'WD' or $stage-abbreviation = 'CD' or $stage-abbreviation = 'FDIS' or $stagename_abbreviation = 'FDIS' 
														or $stage-abbreviation = 'DIS' or $stage-abbreviation = 'DAMD' or $stage-abbreviation = 'DAM' or $stagename_abbreviation = 'DIS'">
														<fo:block margin-top="20mm" font-size="11pt">
															<xsl:call-template name="insertInterFont"/>
															<xsl:copy-of select="$ics"/>
														</fo:block>
													</xsl:if>
													
												</fo:block>
											</fo:block-container>
										</fo:table-cell>
										<fo:table-cell number-columns-spanned="2" padding-left="6mm">
											<fo:block margin-top="2.5mm" line-height="1.1" role="SKIP">
											
												<xsl:if test="not($stage-abbreviation = 'DIS' or $stage-abbreviation = 'DAMD' or $stage-abbreviation = 'DAM')">
													<xsl:variable name="edition_and_date">
														<xsl:call-template name="insertEditionAndDate"/>
													</xsl:variable>
													<xsl:if test="normalize-space($edition_and_date) != ''">
														<fo:block font-size="18pt" font-weight="bold" margin-bottom="3mm">
															<xsl:value-of select="$edition_and_date"/>
														</fo:block>
													</xsl:if>
												</xsl:if>
											
												<xsl:if test="$doctype = 'amendment'"> <!-- and not($stage-abbreviation = 'FDAMD' or $stage-abbreviation = 'FDAM') -->
													<fo:block font-size="15pt" font-weight="bold" margin-bottom="3mm">
														<xsl:value-of select="$doctype_uppercased"/>
														<xsl:text> </xsl:text>
														<xsl:variable name="amendment-number" select="/mn:metanorma/mn:bibdata/mn:ext/mn:structuredidentifier/mn:project-number/@amendment"/>
														<xsl:if test="normalize-space($amendment-number) != ''">
															<xsl:value-of select="$amendment-number"/><xsl:text> </xsl:text>
														</xsl:if>
													</fo:block>
												<!-- </xsl:if>
											
												<xsl:if test="$doctype = 'amendment' and not($stage-abbreviation = 'FDAMD' or $stage-abbreviation = 'FDAM')"> -->
													<xsl:if test="/mn:metanorma/mn:bibdata/mn:date[@type = 'updated']">																		
														<fo:block font-size="18pt" font-weight="bold" margin-bottom="3mm">
															<xsl:value-of select="/mn:metanorma/mn:bibdata/mn:date[@type = 'updated']"/>
														</fo:block>
													</xsl:if>
												</xsl:if>
											
												<xsl:variable name="date_corrected" select="normalize-space(/mn:metanorma/mn:bibdata/mn:date[@type = 'corrected'])"/>
												<xsl:if test="$date_corrected != ''">
													<fo:block font-size="18pt" font-weight="bold" margin-bottom="3mm">
														<xsl:value-of select="$i18n_corrected_version"/>
														<xsl:value-of select="$linebreak"/>
														<xsl:value-of select="$date_corrected"/>
													</fo:block>
												</xsl:if>
											
												
												
												<xsl:if test="$stage-abbreviation = 'DIS' or $stage-abbreviation = 'DAMD' or $stage-abbreviation = 'DAM' or $stagename_abbreviation = 'DIS' or
													$stage-abbreviation = 'FDIS' or $stage-abbreviation = 'FDAMD' or $stage-abbreviation = 'FDAM' or $stagename_abbreviation = 'FDIS' or
													$stage-abbreviation = 'NWIP' or $stage-abbreviation = 'NP' or $stage-abbreviation = 'PWI' or $stage-abbreviation = 'AWI' or $stage-abbreviation = 'WD' or $stage-abbreviation = 'CD'">
													<xsl:if test="normalize-space($editorialgroup) != ''">
														<fo:block margin-bottom="3mm">
															<xsl:copy-of select="$editorialgroup"/>
														</fo:block>
													</xsl:if>
													<xsl:if test="normalize-space($secretariat) != ''">
														<fo:block margin-bottom="3mm">
															<xsl:copy-of select="$secretariat"/>
														</fo:block>
													</xsl:if>
												</xsl:if>
												
												<xsl:if test="$stage-abbreviation = 'DIS' or $stage-abbreviation = 'DAMD' or $stage-abbreviation = 'DAM' or $stagename_abbreviation = 'DIS' or
																		$stage-abbreviation = 'FDIS' or $stage-abbreviation = 'FDAMD' or $stage-abbreviation = 'FDAM' or $stagename_abbreviation = 'FDIS'">
													
													<fo:block margin-bottom="3mm">
													<!-- Voting begins on: -->
														<xsl:value-of select="concat($i18n_voting_begins_on, ':')"/>
														<fo:block font-weight="bold">
															<xsl:variable name="v_date">
																<xsl:call-template name="split">
																	<xsl:with-param name="pText">
																		<xsl:call-template name="insertVoteStarted"/>
																	</xsl:with-param>
																	<xsl:with-param name="sep" select="'-'"/>
																	<xsl:with-param name="keep_sep">true</xsl:with-param>
																</xsl:call-template>
															</xsl:variable>
															<xsl:for-each select="xalan:nodeset($v_date)/mnx:item">
																<xsl:choose>
																	<xsl:when test=". = '-'"><fo:inline font-weight="normal"><xsl:value-of select="."/></fo:inline></xsl:when>
																	<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
																</xsl:choose>
															</xsl:for-each>
														</fo:block>
													</fo:block>
												
													<fo:block margin-bottom="3mm">
														<!-- Voting terminates on: -->
														<xsl:value-of select="concat($i18n_voting_terminates_on, ':')"/>
														<fo:block font-weight="bold">
															<xsl:variable name="v_date">
																<xsl:call-template name="split">
																	<xsl:with-param name="pText">
																		<xsl:call-template name="insertVoteEnded"/>
																	</xsl:with-param>
																	<xsl:with-param name="sep" select="'-'"/>
																	<xsl:with-param name="keep_sep">true</xsl:with-param>
																</xsl:call-template>
															</xsl:variable>
															<xsl:for-each select="xalan:nodeset($v_date)/mnx:item">
																<xsl:choose>
																	<xsl:when test=". = '-'"><fo:inline font-weight="normal"><xsl:value-of select="."/></fo:inline></xsl:when>
																	<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
																</xsl:choose>
															</xsl:for-each>
														</fo:block>
													</fo:block>
												</xsl:if>
											</fo:block>
											
										</fo:table-cell>
									</fo:table-row>
									
									<fo:table-row height="60mm">
										<fo:table-cell number-columns-spanned="2" border-right="{$cover_page_border}" display-align="after" padding-right="4mm">
										
											<xsl:variable name="additionalNotes">
												<xsl:call-template name="insertCoverPageAdditionalNotes"/>
											</xsl:variable>
											
											<xsl:variable name="feedback_link" select="normalize-space(/mn:metanorma/mn:metanorma-extension/mn:semantic-metadata/mn:feedback-link)"/>
											
											<xsl:if test="normalize-space($additionalNotes) != ''"> <!--  or $stage-abbreviation = 'PRF' -->
												<xsl:attribute name="display-align">center</xsl:attribute>
												<fo:block margin-bottom="6.5mm">
													<xsl:copy-of select="$additionalNotes"/>												
												</fo:block>
											</xsl:if>
											
											<xsl:if test="$stage-abbreviation = 'PRF'">
												<fo:block font-size="34pt" font-weight="bold">
													<xsl:if test="normalize-space($additionalNotes) = '' and $feedback_link = ''">
														<xsl:attribute name="margin-bottom">3.5mm</xsl:attribute>
													</xsl:if>
													<xsl:call-template name="add-letter-spacing">
														<xsl:with-param name="text" select="$proof-text"/>
														<xsl:with-param name="letter-spacing" select="0.65"/>
													</xsl:call-template>
												</fo:block>
											</xsl:if>
											
											<fo:block>
												<xsl:if test="$stage &gt;=60 and $feedback_link != ''">
													<fo:block-container width="69mm" background-color="rgb(242,242,242)" display-align="before">
														<fo:table table-layout="fixed" width="100%" role="SKIP">
															<fo:table-column column-width="proportional-column-width(26)"/>
															<fo:table-column column-width="proportional-column-width(43.5)"/>
															<fo:table-body>
																<fo:table-row>
																	<fo:table-cell text-align="right" padding-top="3mm">
																		<fo:block>
																			<fo:instream-foreign-object fox:alt-text="QRcode">
																				<!-- Todo: link generation -->
																				<barcode:barcode
																							xmlns:barcode="http://barcode4j.krysalis.org/ns"
																							message="{$feedback_link}">
																					<barcode:qr>
																						<barcode:module-width>0.7mm</barcode:module-width>
																						<barcode:ec-level>M</barcode:ec-level>
																					</barcode:qr>
																				</barcode:barcode>
																			</fo:instream-foreign-object>
																		</fo:block>
																	</fo:table-cell>
																	<fo:table-cell padding="4mm">
																		<fo:block color="black" font-size="7.5pt" line-height="1.35">
																			<xsl:text>Please share your feedback about the standard. Scan the QR code with your phone or click the link</xsl:text>
																			<fo:block margin-top="2pt">
																				<fo:basic-link external-destination="{$feedback_link}" fox:alt-text="{$feedback_link}">
																					<xsl:call-template name="add-zero-spaces-link-java">
																						<xsl:with-param name="text" select="$feedback_link"/>
																					</xsl:call-template>
																				</fo:basic-link>
																			</fo:block>
																		</fo:block>
																	</fo:table-cell>
																</fo:table-row>
															</fo:table-body>
														</fo:table>
													</fo:block-container>
												</xsl:if>
											</fo:block>
										</fo:table-cell>
										<fo:table-cell number-columns-spanned="2" padding-top="-3mm" padding-left="5mm" display-align="after">
											<xsl:if test="$lang = 'fr'">
												<xsl:attribute name="padding-top">-18mm</xsl:attribute>
											</xsl:if>
											<fo:block font-size="7pt" margin-right="20mm" font-family="Cambria">
												<xsl:call-template name="insertDraftComments"/>
											</fo:block>
										</fo:table-cell>
									</fo:table-row>
									
									<fo:table-row height="13mm">
										<fo:table-cell number-columns-spanned="2" border-right="{$cover_page_border}" display-align="after" padding-bottom="-1mm" line-height="1.1">>
											<fo:block font-size="10pt">
												<!-- Reference number -->
												<xsl:value-of select="$i18n_reference_number"/>
											</fo:block>
											<fo:block font-size="10pt">
												<xsl:value-of select="$ISOnumber"/>
											</fo:block>
										</fo:table-cell>
										<fo:table-cell number-columns-spanned="2" padding-left="6mm" display-align="after" padding-bottom="-1mm">
											<fo:block font-size="10pt" line-height="1.1">
												<xsl:value-of select="concat('© ', $copyrightAbbr, ' ', $copyrightYear)"/>
												<xsl:if test="$copyrightAbbrIEEE != ''">
													<xsl:value-of select="$linebreak"/>
													<xsl:value-of select="concat('© ', $copyrightAbbrIEEE, ' ', $copyrightYear)"/>
												</xsl:if>
											</fo:block>
										</fo:table-cell>
									</fo:table-row>
								</fo:table-body>
							</fo:table>
						</fo:flow>
					</fo:page-sequence>
				</xsl:when> <!-- END: $layoutVersion = '2024' -->
				
				<xsl:when test="$stage-abbreviation != ''">
					<fo:page-sequence master-reference="cover-page" force-page-count="no-force">
						<fo:static-content flow-name="cover-page-footer" font-size="10pt">
							<xsl:if test="$layoutVersion = '1989'">
								<xsl:attribute name="font-size">9pt</xsl:attribute>
							</xsl:if>
							<fo:table table-layout="fixed" width="100%" role="SKIP">
								<fo:table-column column-width="52mm"/>
								<fo:table-column column-width="7.5mm"/>
								<fo:table-column column-width="112.5mm"/>
								<fo:table-body role="SKIP">
									<fo:table-row role="SKIP">
										<fo:table-cell font-size="6.5pt" text-align="justify" display-align="after" padding-bottom="8mm" role="SKIP">
											<xsl:if test="$stage-abbreviation = 'DAMD' or $stage-abbreviation = 'DAM'">
												<xsl:attribute name="font-size">7pt</xsl:attribute>
											</xsl:if>
											<!-- margin-top="-30mm"  -->
											<fo:block> <!-- margin-top="-100mm" -->
												<xsl:call-template name="insertDraftComments"/>
											</fo:block>
										</fo:table-cell>
										<fo:table-cell role="SKIP">
											<fo:block role="SKIP"><fo:wrapper role="artifact">&#xA0;</fo:wrapper></fo:block>
										</fo:table-cell>
										<fo:table-cell display-align="after" padding-bottom="3mm" role="SKIP">
											<fo:block-container height="22.5mm" display-align="center" role="SKIP">
											
												<xsl:variable name="iso-fast-track" select="normalize-space(/mn:metanorma/mn:bibdata/mn:ext/mn:fast-track)"/>
												<xsl:if test="normalize-space($iso-fast-track) = 'true'">
													<xsl:attribute name="height">28mm</xsl:attribute>
												</xsl:if>
												
												<xsl:variable name="iso-cen-parallel" select="normalize-space(/mn:metanorma/mn:bibdata/mn:ext/mn:iso-cen-parallel)"/>
												<xsl:if test="normalize-space($iso-cen-parallel) = 'true'">
													<xsl:attribute name="height">35mm</xsl:attribute>
												</xsl:if>
												
												<fo:block>
													<xsl:call-template name="insertCoverPageAdditionalNotes"/>
												</fo:block>
											</fo:block-container>
											<fo:block role="SKIP">
												<xsl:call-template name="insertTripleLine"/>
												<fo:table table-layout="fixed" width="100%" role="SKIP"> <!-- margin-bottom="3mm" -->
													<fo:table-column column-width="50%"/>
													<fo:table-column column-width="50%"/>
													<fo:table-body role="SKIP">
														<fo:table-row height="34mm" role="SKIP">
															<fo:table-cell display-align="center" role="SKIP">
															
																<xsl:if test="$copyrightAbbrIEEE != ''">
																	<xsl:attribute name="display-align">before</xsl:attribute>
																</xsl:if>
																
																<fo:block text-align="left" margin-top="2mm">
																	
																	<xsl:if test="$copyrightAbbrIEEE != ''">
																		<xsl:attribute name="margin-top">0</xsl:attribute>
																	</xsl:if>
																
																	<!-- <xsl:variable name="docid" select="substring-before(/mn:metanorma/mn:bibdata/mn:docidentifier, ' ')"/>
																	<xsl:for-each select="xalan:tokenize($docid, '/')"> -->
																	<xsl:variable name="content-height">
																		<xsl:choose>
																			<xsl:when test="$copyrightAbbrIEEE != ''">13.9</xsl:when>
																			<xsl:otherwise>19</xsl:otherwise>
																		</xsl:choose>
																	</xsl:variable>
																	
																	<xsl:for-each select="/mn:metanorma/mn:bibdata/mn:copyright/mn:owner/mn:organization">
																		<xsl:choose>
																			<xsl:when test="mn:logo/mn:image">
																				<xsl:apply-templates select="mn:logo/mn:image"/>
																			</xsl:when>
																			<xsl:when test="mn:abbreviation = 'ISO'">
																				<xsl:choose>
																					<xsl:when test="$layoutVersion = '1989' and $revision_date_num &lt; 19930101">
																						<fo:external-graphic src="{concat('data:image/png;base64,', normalize-space($Image-ISO-Logo-1987))}" content-height="{$content-height}mm" content-width="scale-to-fit" scaling="uniform" fox:alt-text="Image ISO Logo"/>
																					</xsl:when>
																					<xsl:otherwise>
																						<fo:external-graphic src="{concat('data:image/png;base64,', normalize-space($Image-ISO-Logo))}" content-height="{$content-height}mm" content-width="scale-to-fit" scaling="uniform" fox:alt-text="Image ISO Logo"/>
																					</xsl:otherwise>
																				</xsl:choose>
																			</xsl:when>
																			<xsl:when test="mn:abbreviation = 'IEC'">
																				<xsl:choose>
																					<xsl:when test="$layoutVersion = '1989' and $revision_date_num &lt; 19930101">
																						<fo:external-graphic src="{concat('data:image/png;base64,', normalize-space($Image-IEC-Logo-1989))}" content-height="{$content-height}mm" content-width="scale-to-fit" scaling="uniform" fox:alt-text="Image IEC Logo"/>
																					</xsl:when>
																					<xsl:otherwise>
																						<fo:external-graphic src="{concat('data:image/png;base64,', normalize-space($Image-IEC-Logo))}" content-height="{$content-height}mm" content-width="scale-to-fit" scaling="uniform" fox:alt-text="Image IEC Logo"/>
																					</xsl:otherwise>
																				</xsl:choose>
																			</xsl:when>
																			<xsl:when test="mn:abbreviation = 'IEEE'"></xsl:when>
																			<xsl:when test="mn:abbreviation = 'IDF' or mn:name = 'IDF'">
																				<fo:external-graphic src="{concat('data:image/png;base64,', normalize-space($Image-IDF-Logo))}" content-height="{$content-height}mm" content-width="scale-to-fit" scaling="uniform" fox:alt-text="Image IDF Logo"/>
																			</xsl:when>
																			<xsl:otherwise></xsl:otherwise>
																		</xsl:choose>
																		<xsl:if test="position() != last()">
																			<fo:inline padding-right="1mm" role="SKIP">&#xA0;</fo:inline>
																		</xsl:if>
																	</xsl:for-each>
																	<xsl:if test="$copyrightAbbrIEEE != ''">
																		<fo:block>
																			<fo:external-graphic src="{concat('data:image/png;base64,', normalize-space($Image-IEEE-Logo))}" content-height="11mm" content-width="scale-to-fit" scaling="uniform" fox:alt-text="Image {@alt}"/>
																		</fo:block>
																	</xsl:if>
																</fo:block>
															</fo:table-cell>
															<fo:table-cell  display-align="center" role="SKIP">
																<fo:block text-align="right" role="SKIP">																	
																	<!-- Reference number -->
																	<fo:block>
																		<xsl:value-of select="$i18n_reference_number"/>
																	</fo:block>
																	<fo:block>
																		<xsl:value-of select="$ISOnumber"/>
																	</fo:block>
																	<fo:block space-before="28pt">
																		<xsl:if test="$copyrightAbbrIEEE != ''">
																			<xsl:attribute name="space-before">14pt</xsl:attribute>
																		</xsl:if>
																		<fo:inline font-size="9pt">©</fo:inline><xsl:value-of select="concat(' ', $copyrightAbbr, ' ', $copyrightYear)"/>
																		<xsl:if test="$copyrightAbbrIEEE != ''">
																			<xsl:value-of select="$linebreak"/>
																			<fo:inline font-size="9pt">©</fo:inline>
																			<xsl:value-of select="concat(' ', $copyrightAbbrIEEE, ' ', $copyrightYear)"/>
																		</xsl:if>
																	</fo:block>
																</fo:block>
															</fo:table-cell>
														</fo:table-row>
													</fo:table-body>
												</fo:table>
											</fo:block>
										</fo:table-cell>
									</fo:table-row>
								</fo:table-body>
							</fo:table>
						</fo:static-content>
						
						<xsl:choose>
							<!-- COVER PAGE for DIS document only -->
							<xsl:when test="$stage-abbreviation = 'DIS' or $stage-abbreviation = 'DAMD' or $stage-abbreviation = 'DAM' or $stagename_abbreviation = 'DIS'">
								<fo:flow flow-name="xsl-region-body">
									<fo:block-container role="SKIP">
										<fo:block margin-top="-1mm" font-size="20pt" text-align="right">
											<xsl:value-of select="$stage-fullname-uppercased"/>
										</fo:block>
										<fo:block font-size="20pt" font-weight="bold" text-align="right">
											<xsl:value-of select="$docidentifierISO"/>
										</fo:block>
										
										
										<fo:table table-layout="fixed" width="100%" margin-top="18mm">
											<fo:table-column column-width="59.5mm"/>
											<fo:table-column column-width="52mm"/>
											<fo:table-column column-width="59mm"/>
											<fo:table-body>
												<fo:table-row>
													<fo:table-cell>
														<fo:block>&#xA0;</fo:block>
													</fo:table-cell>
													<fo:table-cell>
														<fo:block margin-bottom="3mm">
															<xsl:copy-of select="$editorialgroup"/>
														</fo:block>
													</fo:table-cell>
													<fo:table-cell>
														<fo:block margin-bottom="3mm">
															<xsl:copy-of select="$secretariat"/>
														</fo:block>
													</fo:table-cell>
												</fo:table-row>
												<fo:table-row>
													<fo:table-cell>
														<fo:block>&#xA0;</fo:block>
													</fo:table-cell>
													<fo:table-cell>
														<fo:block>
															<!-- Voting begins on: -->
															<xsl:value-of select="concat($i18n_voting_begins_on, ':')"/>
														</fo:block>
													</fo:table-cell>
													<fo:table-cell>
														<fo:block>
															<!-- Voting terminates on: -->
															<xsl:value-of select="concat($i18n_voting_terminates_on, ':')"/>
														</fo:block>
													</fo:table-cell>
												</fo:table-row>
												<fo:table-row>
													<fo:table-cell>
														<fo:block>&#xA0;</fo:block>
													</fo:table-cell>
													<fo:table-cell>
														<fo:block font-weight="bold">
															<xsl:call-template name="insertVoteStarted"/>
														</fo:block>
													</fo:table-cell>
													<fo:table-cell>
														<fo:block font-weight="bold">
															<xsl:call-template name="insertVoteEnded"/>
														</fo:block>
													</fo:table-cell>
												</fo:table-row>
											</fo:table-body>
										</fo:table>
										
										<fo:block-container line-height="1.1" margin-top="3mm" role="SKIP">
											<xsl:call-template name="insertTripleLine"/>
											<fo:block margin-right="5mm" role="SKIP">
												<fo:block font-size="18pt" font-weight="bold" margin-top="6pt" role="H1">
													<xsl:if test="$layoutVersion = '1989'">
														<xsl:attribute name="font-size">16pt</xsl:attribute>
													</xsl:if>
													<xsl:call-template name="insertTitlesLangMain"/>
												</fo:block>
												
												
												<xsl:for-each select="xalan:nodeset($lang_other)/mnx:lang">
													<xsl:variable name="lang_other" select="."/>
												
													<fo:block font-size="12pt" role="SKIP"><xsl:value-of select="$linebreak"/></fo:block>
													<fo:block font-size="11pt" font-style="italic" line-height="1.1" role="H1">
														<xsl:if test="$layoutVersion = '1989'">
															<xsl:attribute name="font-size">10pt</xsl:attribute>
														</xsl:if>
														<!-- Example: title-intro fr -->
														<xsl:call-template name="insertTitlesLangOther">
															<xsl:with-param name="lang_other" select="$lang_other"/>
														</xsl:call-template>
													</fo:block>
												</xsl:for-each>
											</fo:block>
											
											<fo:block margin-top="10mm">
												<xsl:copy-of select="$ics"/>
											</fo:block>
											
										</fo:block-container>
										
										
									</fo:block-container>
								</fo:flow>
							
							</xsl:when> <!-- END: $stage-abbreviation = 'DIS' 'DAMD' 'DAM'-->
							<xsl:otherwise>
						
								<!-- COVER PAGE  for all documents except DIS, DAMD and DAM -->
								<fo:flow flow-name="xsl-region-body">
									<fo:block-container role="SKIP">
										<fo:table table-layout="fixed" width="100%" font-size="24pt" line-height="1" role="SKIP"> <!-- margin-bottom="35mm" -->
											<xsl:if test="$layoutVersion = '1989'">
												<xsl:attribute name="line-height">1.14</xsl:attribute>
											</xsl:if>
											<xsl:if test="$layoutVersion = '1989'">
												<xsl:attribute name="font-size">22pt</xsl:attribute>
											</xsl:if>
											<fo:table-column column-width="59.5mm"/>
											<fo:table-column column-width="67.5mm"/>
											<fo:table-column column-width="45.5mm"/>
											<fo:table-body role="SKIP">
												<fo:table-row role="SKIP">
													<fo:table-cell role="SKIP">
														<fo:block font-size="18pt">
															
															<xsl:value-of select="translate($stagename-header-coverpage, ' ', $linebreak)"/>
															
															<!-- if there is iteration number, then print it -->
															<xsl:variable name="iteration" select="number(/mn:metanorma/mn:bibdata/mn:status/mn:iteration)"/>	
															
															<xsl:if test="number($iteration) = $iteration and 
																																							($stage-abbreviation = 'NWIP' or 
																																							$stage-abbreviation = 'NP' or 
																																							$stage-abbreviation = 'PWI' or 
																																							$stage-abbreviation = 'AWI' or 
																																							$stage-abbreviation = 'WD' or 
																																							$stage-abbreviation = 'CD')">
																<xsl:text>&#xA0;</xsl:text><xsl:value-of select="$iteration"/>
															</xsl:if>
															<!-- <xsl:if test="$stage-name = 'draft'">DRAFT</xsl:if>
															<xsl:if test="$stage-name = 'final-draft'">FINAL<xsl:value-of select="$linebreak"/>DRAFT</xsl:if> -->
														</fo:block>
													</fo:table-cell>
													
													<xsl:variable name="lastWord">
														<xsl:call-template name="substring-after-last">
															<xsl:with-param name="value" select="$doctype_uppercased"/>
															<xsl:with-param name="delimiter" select="' '"/>
														</xsl:call-template>
													</xsl:variable>
													<xsl:variable name="font-size"><xsl:if test="string-length($lastWord) &gt;= 12">90%</xsl:if></xsl:variable> <!-- to prevent overlapping 'NORME INTERNATIONALE' to number -->
													
													<fo:table-cell role="SKIP">
														<fo:block text-align="left">
															<xsl:choose>
																<xsl:when test="$stage-abbreviation = 'FDAMD' or $stage-abbreviation = 'FDAM'"><xsl:value-of select="$doctype_uppercased"/></xsl:when>
																<xsl:when test="$doctype = 'amendment'">
																	<xsl:value-of select="java:toUpperCase(java:java.lang.String.new(translate(/mn:metanorma/mn:bibdata/mn:ext/mn:updates-document-type,'-',' ')))"/>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:if test="$font-size != ''">
																		<xsl:attribute name="font-size"><xsl:value-of select="$font-size"/></xsl:attribute>
																	</xsl:if>
																	
																	<xsl:choose>
																		<xsl:when test="$doctype = 'addendum'">
																			<xsl:variable name="doctype_international_standard">
																				<xsl:call-template name="getLocalizedString"><xsl:with-param name="key">doctype_dict.international-standard</xsl:with-param></xsl:call-template>
																			</xsl:variable>
																			<xsl:value-of select="java:toUpperCase(java:java.lang.String.new($doctype_international_standard))"/>
																		</xsl:when>
																		<xsl:otherwise>
																			<xsl:value-of select="$doctype_uppercased"/>
																		</xsl:otherwise>
																	</xsl:choose>
																</xsl:otherwise>
															</xsl:choose>
														</fo:block>
													</fo:table-cell>
													<fo:table-cell role="SKIP">
														<fo:block text-align="right" font-weight="bold" margin-bottom="13mm">
															<xsl:if test="$font-size != ''">
																<xsl:attribute name="font-size"><xsl:value-of select="$font-size"/></xsl:attribute>
															</xsl:if>
															<xsl:choose>
																<xsl:when test="$doctype = 'addendum'">
																	<xsl:value-of select="substring-before($docidentifierISO_with_break, ':')"/>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:value-of select="$docidentifierISO_with_break"/>
																	<xsl:copy-of select="$docidentifier_another"/>
																</xsl:otherwise>
															</xsl:choose>
														</fo:block>
													</fo:table-cell>
												</fo:table-row>
												<fo:table-row height="25mm" role="SKIP">
													<fo:table-cell number-columns-spanned="3" font-size="10pt" line-height="1.2" role="SKIP">
														<xsl:if test="$layoutVersion = '1989'">
															<xsl:attribute name="font-size">9pt</xsl:attribute>
														</xsl:if>
														<fo:block text-align="right">
															<xsl:call-template name="insertEditionAndDate"/>
														</fo:block>
														<!-- <xsl:value-of select="$linebreak"/>
														<xsl:value-of select="/mn:metanorma/mn:bibdata/mn:version/mn:revision-date"/> -->
														<xsl:if test="$doctype = 'addendum'">
															<fo:block text-align="right" margin-right="0.5mm" role="SKIP">
																<fo:block font-weight="bold" margin-top="16pt">
																	<xsl:value-of select="$doctype_uppercased"/>
																		<xsl:text> </xsl:text>
																		<xsl:variable name="addendum-number" select="/mn:metanorma/mn:bibdata/mn:ext/mn:structuredidentifier/mn:project-number/@addendum"/>
																		<xsl:if test="normalize-space($addendum-number) != ''">
																			<xsl:value-of select="$addendum-number"/><xsl:text> </xsl:text>
																		</xsl:if>
																</fo:block>
																<fo:block>
																	<xsl:if test="/mn:metanorma/mn:bibdata/mn:date[@type = 'updated']">																		
																		<xsl:value-of select="/mn:metanorma/mn:bibdata/mn:date[@type = 'updated']"/>
																	</xsl:if>
																</fo:block>
															</fo:block>
														</xsl:if>
														<xsl:if test="$doctype = 'amendment' and not($stage-abbreviation = 'FDAMD' or $stage-abbreviation = 'FDAM')">
															<fo:block text-align="right" margin-right="0.5mm" role="SKIP">
																<fo:block font-weight="bold" margin-top="4pt" role="H1">
																	<xsl:value-of select="$doctype_uppercased"/>
																	<xsl:text> </xsl:text>
																	<xsl:variable name="amendment-number" select="/mn:metanorma/mn:bibdata/mn:ext/mn:structuredidentifier/mn:project-number/@amendment"/>
																	<xsl:if test="normalize-space($amendment-number) != ''">
																		<xsl:value-of select="$amendment-number"/><xsl:text> </xsl:text>
																	</xsl:if>
																</fo:block>
																<fo:block>
																	<xsl:if test="/mn:metanorma/mn:bibdata/mn:date[@type = 'updated']">																		
																		<xsl:value-of select="/mn:metanorma/mn:bibdata/mn:date[@type = 'updated']"/>
																	</xsl:if>
																</fo:block>
															</fo:block>
														</xsl:if>
														<xsl:variable name="date_corrected" select="normalize-space(/mn:metanorma/mn:bibdata/mn:date[@type = 'corrected'])"/>
														<xsl:if test="$date_corrected != ''">
															<fo:block text-align="right" font-size="9.5pt">
																<xsl:value-of select="$linebreak"/>
																<xsl:value-of select="$linebreak"/>
																<xsl:value-of select="$i18n_corrected_version"/>
																<xsl:value-of select="$linebreak"/>
																<xsl:value-of select="$date_corrected"/>
															</fo:block>
														</xsl:if>
													</fo:table-cell>
												</fo:table-row>
												<fo:table-row height="17mm" role="SKIP">
													<fo:table-cell role="SKIP"><fo:block role="SKIP"></fo:block></fo:table-cell>
													<fo:table-cell number-columns-spanned="2" font-size="10pt" line-height="1.2" display-align="center" role="SKIP">
														<fo:block role="SKIP">
															<xsl:if test="$stage-abbreviation = 'NWIP' or $stage-abbreviation = 'NP' or $stage-abbreviation = 'PWI' or $stage-abbreviation = 'AWI' or $stage-abbreviation = 'WD' or $stage-abbreviation = 'CD'">
																<fo:table table-layout="fixed" width="100%" role="SKIP">
																	<fo:table-column column-width="50%"/>
																	<fo:table-column column-width="50%"/>
																	<fo:table-body role="SKIP">
																		<fo:table-row role="SKIP">
																			<fo:table-cell role="SKIP">
																				<fo:block>
																					<xsl:copy-of select="$editorialgroup"/>
																				</fo:block>
																			</fo:table-cell>
																			<fo:table-cell role="SKIP">
																				<fo:block>
																					<xsl:copy-of select="$secretariat"/>
																				</fo:block>
																			</fo:table-cell>
																		</fo:table-row>
																	</fo:table-body>
																</fo:table>
															</xsl:if>
														</fo:block>
													</fo:table-cell>
												</fo:table-row>
												
											</fo:table-body>
										</fo:table>
										
										
										<fo:table table-layout="fixed" width="100%" role="SKIP">
											<fo:table-column column-width="52mm"/>
											<fo:table-column column-width="7.5mm"/>
											<fo:table-column column-width="112.5mm"/>
											<fo:table-body role="SKIP">
												<fo:table-row role="SKIP"> <!--  border="1pt solid black" height="150mm"  -->
													<fo:table-cell font-size="11pt" role="SKIP">
														<fo:block role="SKIP">
															<xsl:if test="$stage-abbreviation = 'FDIS' or $stage-abbreviation = 'FDAMD' or $stage-abbreviation = 'FDAM' or $stagename_abbreviation = 'FDIS'">
																<fo:block-container border="0.5mm solid black" width="51mm" role="SKIP">
																	<fo:block margin="2mm" role="SKIP">
																			<fo:block margin-bottom="8pt"><xsl:copy-of select="$editorialgroup"/></fo:block>
																			<fo:block margin-bottom="6pt"><xsl:copy-of select="$secretariat"/></fo:block>
																			<fo:block margin-bottom="6pt">
																				<!-- Voting begins on: -->
																				<xsl:value-of select="concat($i18n_voting_begins_on, ':')"/>
																				<xsl:value-of select="$linebreak"/>
																				<fo:inline font-weight="bold">
																					<xsl:call-template name="insertVoteStarted"/>
																				</fo:inline>
																			</fo:block>
																			<fo:block>
																				<!-- Voting terminates on: -->
																				<xsl:value-of select="concat($i18n_voting_terminates_on, ':')"/>
																				<xsl:value-of select="$linebreak"/>
																				<fo:inline font-weight="bold">
																					<xsl:call-template name="insertVoteEnded"/>
																				</fo:inline>
																			</fo:block>
																	</fo:block>
																</fo:block-container>
															</xsl:if>
														</fo:block>
													</fo:table-cell>
													<fo:table-cell role="SKIP">
														<fo:block role="SKIP"><fo:wrapper role="artifact">&#xA0;</fo:wrapper></fo:block>
													</fo:table-cell>
													<fo:table-cell role="SKIP">
														<xsl:call-template name="insertTripleLine"/>
														<fo:block-container line-height="1.1" role="SKIP">
															<fo:block margin-right="3.5mm" role="SKIP">
																<xsl:variable name="font_size">
																	<xsl:choose>
																		<xsl:when test="$layoutVersion = '1989'">16pt</xsl:when>
																		<xsl:otherwise>18pt</xsl:otherwise>
																	</xsl:choose>
																</xsl:variable>
																<fo:block font-size="{$font_size}" font-weight="bold" margin-top="12pt" role="H1">
																	<xsl:call-template name="insertTitlesLangMain"/>
																</fo:block>
																
																<xsl:choose>
																	<xsl:when test="$doctype = 'addendum'">
																		<fo:block font-size="{$font_size}" margin-top="6pt" role="H2">
																			<xsl:value-of select="$doctype_uppercased"/>
																			<xsl:text>&#xa0;</xsl:text>
																			<xsl:value-of select="/mn:metanorma/mn:bibdata/mn:ext/mn:structuredidentifier/mn:project-number/@addendum"/>
																			<xsl:text>:</xsl:text>
																		</fo:block>
																		<fo:block font-size="{$font_size}" font-weight="bold" margin-top="6pt" role="H2">
																			<xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:title[@language = $lang and @type = 'title-add']/node()"/>
																		</fo:block>
																	</xsl:when>
																	<xsl:otherwise>
																		<xsl:if test="not($stage-abbreviation = 'FDAMD' or $stage-abbreviation = 'FDAM')">
																			<xsl:for-each select="xalan:nodeset($lang_other)/mnx:lang">
																				<xsl:variable name="lang_other" select="."/>
																				
																				<fo:block font-size="12pt" role="SKIP"><xsl:value-of select="$linebreak"/></fo:block>
																				<fo:block font-size="11pt" font-style="italic" line-height="1.1" role="H1">
																					<xsl:if test="$layoutVersion = '1989'">
																						<xsl:attribute name="font-size">10pt</xsl:attribute>
																					</xsl:if>
																					<!-- Example: title-intro fr -->
																					<xsl:call-template name="insertTitlesLangOther">
																						<xsl:with-param name="lang_other" select="$lang_other"/>
																					</xsl:call-template>
																				</fo:block>
																			</xsl:for-each>
																		</xsl:if>
																		
																	</xsl:otherwise>
																</xsl:choose>
																
																<xsl:if test="$stage-abbreviation = 'NWIP' or $stage-abbreviation = 'NP' or $stage-abbreviation = 'PWI' or $stage-abbreviation = 'AWI' or $stage-abbreviation = 'WD' or $stage-abbreviation = 'CD' or $stage-abbreviation = 'FDIS' or $stagename_abbreviation = 'FDIS'">
																	<fo:block margin-top="10mm">
																		<xsl:copy-of select="$ics"/>
																	</fo:block>
																</xsl:if>
																
															</fo:block>
														</fo:block-container>
													</fo:table-cell>
												</fo:table-row>
											</fo:table-body>
										</fo:table>
									</fo:block-container>
									<fo:block-container position="absolute" left="60mm" top="222mm" height="25mm" display-align="after" role="SKIP">
										<fo:block margin-bottom="2mm" role="SKIP">
											<xsl:if test="$stage-abbreviation = 'PRF'">
												<fo:block font-size="36pt" font-weight="bold" margin-left="1mm">
													<xsl:call-template name="add-letter-spacing">
														<xsl:with-param name="text" select="$proof-text"/>
														<xsl:with-param name="letter-spacing" select="0.65"/>
													</xsl:call-template>
												</fo:block>
											</xsl:if>
										</fo:block>
									</fo:block-container>
								</fo:flow>
							</xsl:otherwise>
						</xsl:choose>
						
						
					</fo:page-sequence>
				</xsl:when> <!-- $stage-abbreviation != '' -->
					
				<xsl:when test="$isPublished = 'true'">
					<fo:page-sequence master-reference="cover-page-published" force-page-count="no-force">
						<fo:static-content flow-name="cover-page-footer" font-size="10pt">
							<xsl:call-template name="insertTripleLine"/>
							<fo:table table-layout="fixed" width="100%" margin-bottom="3mm" role="SKIP">
								<fo:table-column column-width="50%"/>
								<fo:table-column column-width="50%"/>
								<fo:table-body role="SKIP">
									<fo:table-row height="32mm" role="SKIP">
										<fo:table-cell display-align="center" role="SKIP">
											<fo:block text-align="left">
												<fo:external-graphic src="{concat('data:image/png;base64,', normalize-space($Image-ISO-Logo))}" width="21mm" content-height="21mm" content-width="scale-to-fit" scaling="uniform" fox:alt-text="Image {@alt}"/>
											</fo:block>
										</fo:table-cell>
										<fo:table-cell display-align="center" role="SKIP">
											<fo:block text-align="right" role="SKIP">
												<fo:block>
													<xsl:value-of select="$i18n_reference_number"/>
												</fo:block>
												<fo:block><xsl:value-of select="$ISOnumber"/></fo:block>
												<fo:block role="SKIP">&#xA0;</fo:block>
												<fo:block role="SKIP">&#xA0;</fo:block>
												<fo:block><fo:inline font-size="9pt">©</fo:inline><xsl:value-of select="concat(' ', $copyrightAbbr, ' ', $copyrightYear)"/>
													<xsl:if test="$copyrightAbbrIEEE != ''">
														<xsl:value-of select="$linebreak"/>
														<fo:inline font-size="9pt">©</fo:inline>
														<xsl:value-of select="concat(' ', $copyrightAbbrIEEE, ' ', $copyrightYear)"/>
													</xsl:if>
												</fo:block>
											</fo:block>
										</fo:table-cell>
									</fo:table-row>
								</fo:table-body>
							</fo:table>
						</fo:static-content>
						<fo:flow flow-name="xsl-region-body">
							<fo:block-container role="SKIP">
								<fo:table table-layout="fixed" width="100%" font-size="24pt" line-height="1" margin-bottom="35mm" role="SKIP">
									<xsl:if test="$layoutVersion = '1989'">
										<xsl:attribute name="font-size">22pt</xsl:attribute>
									</xsl:if>
									<fo:table-column column-width="60%"/>
									<fo:table-column column-width="40%"/>
									<fo:table-body role="SKIP">
										<fo:table-row role="SKIP">
											<fo:table-cell role="SKIP">
												<fo:block text-align="left">
													<xsl:value-of select="$doctype_uppercased"/>
												</fo:block>
											</fo:table-cell>
											<fo:table-cell role="SKIP">
												<fo:block text-align="right" font-weight="bold" margin-bottom="13mm">
													<xsl:value-of select="$docidentifierISO_with_break"/>
													<xsl:copy-of select="$docidentifier_another"/>
												</fo:block>
											</fo:table-cell>
										</fo:table-row>
										<fo:table-row role="SKIP">
											<fo:table-cell number-columns-spanned="2" font-size="10pt" line-height="1.2" role="SKIP">
												<fo:block text-align="right">
													<xsl:call-template name="printEdition"/>
													<xsl:value-of select="$linebreak"/>
													<xsl:value-of select="/mn:metanorma/mn:bibdata/mn:version/mn:revision-date"/></fo:block>
											</fo:table-cell>
										</fo:table-row>
									</fo:table-body>
								</fo:table>
								
								<xsl:call-template name="insertTripleLine"/>
								<fo:block-container line-height="1.1" role="SKIP">
									<fo:block margin-right="40mm" role="SKIP">
										<fo:block font-size="18pt" font-weight="bold" margin-top="12pt" role="H1">
											<xsl:if test="$layoutVersion = '1989'">
												<xsl:attribute name="font-size">16pt</xsl:attribute>
											</xsl:if>
											<xsl:call-template name="insertTitlesLangMain"/>
										</fo:block>
											
										<xsl:for-each select="xalan:nodeset($lang_other)/mnx:lang">
											<xsl:variable name="lang_other" select="."/>
											
											<fo:block font-size="12pt" role="SKIP"><xsl:value-of select="$linebreak"/></fo:block>
											<fo:block font-size="11pt" font-style="italic" line-height="1.1" role="H1">
												<xsl:if test="$layoutVersion = '1989'">
													<xsl:attribute name="font-size">10pt</xsl:attribute>
												</xsl:if>
												<!-- Example: title-intro fr -->
												<xsl:call-template name="insertTitlesLangOther">
													<xsl:with-param name="lang_other" select="$lang_other"/>
												</xsl:call-template>
											</fo:block>
										</xsl:for-each>
									</fo:block>
								</fo:block-container>
							</fo:block-container>
						</fo:flow>
					</fo:page-sequence>
				</xsl:when> <!-- $isPublished = 'true' -->
				<xsl:otherwise>
					<fo:page-sequence master-reference="cover-page-nonpublished" force-page-count="no-force">
						<fo:static-content flow-name="cover-page-header" font-size="10pt">
							<fo:block-container height="24mm" display-align="before">
								<fo:block padding-top="12.5mm">
									<xsl:value-of select="$copyrightText"/>
								</fo:block>
							</fo:block-container>
						</fo:static-content>
						<fo:flow flow-name="xsl-region-body">
							<fo:block-container text-align="right" role="SKIP">
								<xsl:choose>
									<xsl:when test="/mn:metanorma/mn:bibdata/mn:docidentifier[@type = 'iso-tc']">
										<!-- 17301  -->
										<fo:block font-size="14pt" font-weight="bold" margin-bottom="12pt">
											<xsl:value-of select="/mn:metanorma/mn:bibdata/mn:docidentifier[@type = 'iso-tc']"/>
										</fo:block>
										<!-- Date: 2016-05-01  -->
										<fo:block margin-bottom="12pt">
											<xsl:text>Date: </xsl:text><xsl:value-of select="/mn:metanorma/mn:bibdata/mn:version/mn:revision-date"/>
										</fo:block>
									
										<!-- ISO/CD 17301-1(E)  -->
										<fo:block margin-bottom="12pt">
											<xsl:value-of select="concat(/mn:metanorma/mn:bibdata/mn:docidentifier, $lang-1st-letter)"/>
										</fo:block>
									</xsl:when>
									<xsl:otherwise>
										<fo:block font-size="14pt" font-weight="bold" margin-bottom="12pt">
											<!-- ISO/WD 24229(E)  -->
											<xsl:value-of select="concat(/mn:metanorma/mn:bibdata/mn:docidentifier, $lang-1st-letter)"/>
										</fo:block>
										
									</xsl:otherwise>
								</xsl:choose>
								
								 
								<xsl:if test="normalize-space($editorialgroup) != ''">
									<!-- ISO/TC 34/SC 4/WG 3 -->
									<fo:block margin-bottom="12pt">
										<xsl:copy-of select="$editorialgroup"/>
									</fo:block>
								</xsl:if>
								
								<!-- Secretariat: AFNOR  -->
								<fo:block margin-bottom="100pt">
									<xsl:value-of select="$secretariat"/>
									<xsl:text>&#xA0;</xsl:text>
								</fo:block>
							</fo:block-container>
							
							<fo:block-container font-size="16pt" role="SKIP">
								<!-- Information and documentation — Codes for transcription systems  -->
									<fo:block font-weight="bold" role="H1">
										<xsl:call-template name="insertTitlesLangMain"/>
									</fo:block>
									
									<xsl:for-each select="xalan:nodeset($lang_other)/mnx:lang">
										<xsl:variable name="lang_other" select="."/>
									
										<fo:block font-size="12pt" role="SKIP"><xsl:value-of select="$linebreak"/></fo:block>
										<fo:block role="H1">
											<!-- Example: title-intro fr -->
											<xsl:call-template name="insertTitlesLangOther">
												<xsl:with-param name="lang_other" select="$lang_other"/>
											</xsl:call-template>
										</fo:block>
										
									</xsl:for-each>
									
							</fo:block-container>
							<fo:block font-size="11pt" margin-bottom="8pt" role="SKIP"><xsl:value-of select="$linebreak"/></fo:block>
							<fo:block-container font-size="40pt" text-align="center" margin-bottom="12pt" border="0.5pt solid black" role="SKIP">
								<xsl:variable name="stage-title" select="substring-after(substring-before($docidentifierISO, ' '), '/')"/>
								<xsl:choose>
									<xsl:when test="normalize-space($stage-title) != ''">
										<fo:block padding-top="2mm"><xsl:value-of select="$stage-title"/><xsl:text> stage</xsl:text></fo:block>
									</xsl:when>
									<xsl:otherwise>
										<xsl:attribute name="border">0pt solid white</xsl:attribute>
										<fo:block role="SKIP">&#xa0;</fo:block>
									</xsl:otherwise>
								</xsl:choose>
							</fo:block-container>
							<fo:block role="SKIP"><xsl:value-of select="$linebreak"/></fo:block>
							
							<xsl:if test="/mn:metanorma/mn:boilerplate/mn:license-statement">
								<fo:block-container font-size="10pt" margin-top="12pt" margin-bottom="6pt" border="0.5pt solid black" role="SKIP">
									<fo:block padding-top="1mm">
										<xsl:apply-templates select="/mn:metanorma/mn:boilerplate/mn:license-statement"/>
									</fo:block>
								</fo:block-container>
							</xsl:if>
						</fo:flow>
					</fo:page-sequence>
				</xsl:otherwise>
			</xsl:choose>
			</xsl:variable>
			
			<xsl:apply-templates select="xalan:nodeset($fo_cover_page)" mode="set_table_role_skip"/>
			
		</xsl:if> <!-- $isGenerateTableIF = 'false' -->
	</xsl:template> <!-- END cover-page -->
		
	
	<xsl:template match="mn:preface/mn:introduction" mode="update_xml_step1" priority="3">
		<xsl:param name="process">false</xsl:param>
		<xsl:choose>
			<xsl:when test="$layoutVersion = '1951'">
				<xsl:if test="$process = 'true'">
					<xsl:copy>
						<xsl:apply-templates select="@*" mode="update_xml_step1"/>
						<xsl:attribute name="displayorder">
							<xsl:value-of select="concat(../../mn:sections/mn:p[@class = 'zzSTDTitle1']/@displayorder, '.1')"/>
						</xsl:attribute>
						<xsl:apply-templates select="node()" mode="update_xml_step1"/>
					</xsl:copy>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy>
					<xsl:apply-templates select="@*|node()" mode="update_xml_step1"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="mn:sections/mn:p[@class = 'zzSTDTitle1']" mode="update_xml_step1" priority="3">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="update_xml_step1"/>
		</xsl:copy>
		<xsl:if test="$layoutVersion = '1951'">
			<xsl:apply-templates select="../../mn:preface/mn:introduction" mode="update_xml_step1">
				<xsl:with-param name="process">true</xsl:with-param>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>
		
	<!-- transform NOTE to Note for smallcaps feature working -->
	<xsl:template match="mn:note/mn:name/text() | mn:example/mn:name/text() | mn:note/mn:fmt-name/text() | mn:example/mn:fmt-name/text()" mode="update_xml_step1" priority="3">
		<xsl:choose>
			<xsl:when test="$layoutVersion = '1951'"> <!--  and $revision_date_num &lt; 19680101 -->
				<xsl:value-of select="substring(., 1, 1)"/>
				<xsl:value-of select="java:toLowerCase(java:java.lang.String.new(substring(., 2)))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
		
	<xsl:template name="insertLogoImages2024">
		<xsl:variable name="content-height">20</xsl:variable>
		<xsl:for-each select="/mn:metanorma/mn:bibdata/mn:copyright/mn:owner/mn:organization">
			<xsl:variable name="owner_number" select="count(ancestor::mn:copyright/preceding-sibling::mn:copyright) + 1"/>
			<!-- https://github.com/metanorma/metanorma-iso/issues/1386 -->
			<xsl:variable name="logo_width_">
				<xsl:for-each select="/mn:metanorma/mn:metanorma-extension/mn:presentation-metadata/*[starts-with(local-name(), 'logo-publisher-pdf-width-')]">
					<xsl:if test="local-name() = concat('logo-publisher-pdf-width-', $owner_number)">
						<xsl:value-of select="."/>
					</xsl:if>
				</xsl:for-each>
			</xsl:variable>
			<xsl:variable name="logo_width">
				<xsl:choose>
					<xsl:when test="normalize-space($logo_width_) != '' and normalize-space(translate($logo_width_, '1234567890', '')) = ''"><xsl:value-of select="$logo_width_"/>px</xsl:when>
					<xsl:otherwise><xsl:value-of select="$logo_width_"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="logo_height_">
				<xsl:for-each select="/mn:metanorma/mn:metanorma-extension/mn:presentation-metadata/*[starts-with(local-name(), 'logo-publisher-pdf-height-')]">
					<xsl:if test="local-name() = concat('logo-publisher-pdf-height-', $owner_number)">
						<xsl:value-of select="."/>
					</xsl:if>
				</xsl:for-each>
			</xsl:variable>
			<xsl:variable name="logo_height">
				<xsl:choose>
					<xsl:when test="normalize-space($logo_height_) != '' and normalize-space(translate($logo_height_, '1234567890', '')) = ''"><xsl:value-of select="$logo_height_"/>px</xsl:when>
					<xsl:otherwise><xsl:value-of select="$logo_height_"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
		<!-- 	<fo:block>logo_width=<xsl:value-of select="$logo_width"/></fo:block>
			<fo:block>logo_height=<xsl:value-of select="$logo_height"/></fo:block> -->
			<xsl:choose>
				<xsl:when test="mn:logo/mn:image">
					<xsl:choose>
						<xsl:when test="normalize-space($logo_width) != '' or normalize-space($logo_height) != ''">
							<xsl:variable name="logo_image">
								<xsl:for-each select="mn:logo/mn:image"> <!-- set context to logo/image -->
									<xsl:element name="logo" namespace="{$namespace_full}">
										<xsl:element name="image" namespace="{$namespace_full}">
											<xsl:copy-of select="@*"/>
											<xsl:if test="$logo_width != ''">
												<xsl:attribute name="width"><xsl:value-of select="$logo_width"/></xsl:attribute>
											</xsl:if>
											<xsl:if test="$logo_height != ''">
												<xsl:attribute name="height"><xsl:value-of select="$logo_height"/></xsl:attribute>
											</xsl:if>
											<xsl:copy-of select="node()"/>
										</xsl:element>
									</xsl:element>
								</xsl:for-each>
							</xsl:variable>
							<xsl:apply-templates select="xalan:nodeset($logo_image)//mn:logo/mn:image"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="mn:logo/mn:image"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="mn:abbreviation = 'ISO'">
					<fo:instream-foreign-object content-height="{$content-height}mm" fox:alt-text="Image ISO Logo">
						<xsl:copy-of select="$Image-ISO-Logo-SVG"/>
					</fo:instream-foreign-object>
				</xsl:when>
				<xsl:when test="mn:abbreviation = 'IEC'">
					<fo:instream-foreign-object content-height="{$content-height}mm" fox:alt-text="Image IEC Logo">
						<xsl:copy-of select="$Image-IEC-Logo-SVG"/>
					</fo:instream-foreign-object>
				</xsl:when>
				<xsl:when test="mn:abbreviation = 'IEEE'"></xsl:when>
				<xsl:when test="mn:abbreviation = 'IDF' or mn:name = 'IDF'">
					<fo:external-graphic src="{concat('data:image/png;base64,', normalize-space($Image-IDF-Logo))}" content-height="{$content-height}mm" content-width="scale-to-fit" scaling="uniform" fox:alt-text="Image IDF Logo"/>
				</xsl:when>
				<xsl:otherwise></xsl:otherwise>
			</xsl:choose>
			<xsl:if test="position() != last()">
				<fo:inline padding-right="1mm" role="SKIP">&#xA0;</fo:inline>
			</xsl:if>
		</xsl:for-each>
		<xsl:if test="$copyrightAbbrIEEE != ''">
			<fo:block margin-top="2mm">
				<fo:external-graphic src="{concat('data:image/png;base64,', normalize-space($Image-IEEE-Logo2))}" content-width="{$content-height * 2 + 2}mm" content-height="scale-to-fit" scaling="uniform" fox:alt-text="Image IEEE Logo"/>
			</fo:block>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="insertTitlesLangMain">
		<xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:title[@language = $lang and @type = 'title-intro']"/>
		<xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:title[@language = $lang and @type = 'title-main']"/>
		<xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:title[@language = $lang and @type = 'title-complementary']"/>
		<xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:title[@language = $lang and @type = 'title-part']">
			<xsl:with-param name="isMainLang">true</xsl:with-param>
		</xsl:apply-templates>
		<xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:title[@language = $lang and @type = 'title-amd']">
			<xsl:with-param name="isMainLang">true</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template name="insertTitlesLangOther">
		<xsl:param name="lang_other"/>
		<xsl:apply-templates select="$XML/mn:metanorma/mn:bibdata/mn:title[@language = $lang_other and @type = 'title-intro']"/>
		<xsl:apply-templates select="$XML/mn:metanorma/mn:bibdata/mn:title[@language = $lang_other and @type = 'title-main']"/>
		<xsl:apply-templates select="$XML/mn:metanorma/mn:bibdata/mn:title[@language = $lang_other and @type = 'title-complementary']"/>
		<xsl:apply-templates select="$XML/mn:metanorma/mn:bibdata/mn:title[@language = $lang_other and @type = 'title-part']">
			<xsl:with-param name="curr_lang" select="$lang_other"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="$XML/mn:metanorma/mn:bibdata/mn:title[@language = $lang_other and @type = 'title-amd']">
			<xsl:with-param name="curr_lang" select="$lang_other"/>
		</xsl:apply-templates>																
	</xsl:template>
	
	<!-- for 1951 layout -->
	<xsl:template match="mn:edition/text()" priority="3">
		<xsl:choose>
			<xsl:when test="contains(., ' ')"><xsl:value-of select="substring-before(., ' ')"/><xsl:text> </xsl:text><fo:inline font-weight="bold"><xsl:value-of select="substring-after(., ' ')"/></fo:inline></xsl:when>
			<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="insertEditionAndDate">
		<xsl:variable name="edition">
			<xsl:if test="$stage-abbreviation = 'PRF' or 
												$stage-abbreviation = 'IS' or 
												$stage-abbreviation = 'D' or 
												$stage-abbreviation = 'published'">
				<xsl:call-template name="printEdition"/>
			</xsl:if>
		</xsl:variable>
		<xsl:value-of select="$edition"/>
		<xsl:variable name="date">
			<xsl:choose>
				<xsl:when test="($stage-abbreviation = 'NWIP' or $stage-abbreviation = 'NP' or $stage-abbreviation = 'PWI' or $stage-abbreviation = 'AWI' or $stage-abbreviation = 'WD' or $stage-abbreviation = 'CD' or $stage-abbreviation = 'FDIS' or $stagename_abbreviation = 'FDIS') and /mn:metanorma/mn:bibdata/mn:version/mn:revision-date">
					<xsl:value-of select="/mn:metanorma/mn:bibdata/mn:version/mn:revision-date"/>
				</xsl:when>
				<xsl:when test="$stage-abbreviation = 'IS' and /mn:metanorma/mn:bibdata/mn:date[@type = 'published']">
					<xsl:value-of select="/mn:metanorma/mn:bibdata/mn:date[@type = 'published']"/>
				</xsl:when>
				<xsl:when test="($stage-abbreviation = 'IS' or $stage-abbreviation = 'D') and /mn:metanorma/mn:bibdata/mn:date[@type = 'created']">
					<xsl:value-of select="/mn:metanorma/mn:bibdata/mn:date[@type = 'created']"/>
				</xsl:when>
				<xsl:when test="$stage-abbreviation = 'IS' or $stage-abbreviation = 'published' or $stage-abbreviation = 'PRF'">
					<xsl:value-of select="substring(/mn:metanorma/mn:bibdata/mn:version/mn:revision-date,1, 7)"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="normalize-space($date) != ''">
			<xsl:choose>
				<xsl:when test="$layoutVersion = '2024'">
					<xsl:if test="normalize-space($edition) != ''">
						<xsl:value-of select="$linebreak"/>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$linebreak"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:value-of select="$date"/>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="insertDraftComments">
		<xsl:if test="$stagename_abbreviation = 'DIS' or 
											$stage-abbreviation = 'DIS' or 
											$stage-abbreviation = 'DAMD' or 
											$stage-abbreviation = 'DAM' or 
											$stage-abbreviation = 'NWIP' or 
											$stage-abbreviation = 'NP' or 
											$stage-abbreviation = 'PWI' or 
											$stage-abbreviation = 'AWI' or 
											$stage-abbreviation = 'WD' or 
											$stage-abbreviation = 'CD'">
			<fo:block margin-bottom="1.5mm">
				<!-- <xsl:text>THIS DOCUMENT IS A DRAFT CIRCULATED FOR COMMENT AND APPROVAL. IT IS THEREFORE SUBJECT TO CHANGE AND MAY NOT BE REFERRED TO AS AN INTERNATIONAL STANDARD UNTIL PUBLISHED AS SUCH.</xsl:text> -->
				<xsl:value-of select="java:toUpperCase(java:java.lang.String.new($i18n_draft_comment_1))"/>
			</fo:block>
		</xsl:if>
		<xsl:if test="$stagename_abbreviation = 'DIS' or
											$stagename_abbreviation = 'FDIS' or
											$stage-abbreviation = 'FDIS' or 
											$stage-abbreviation = 'DIS' or 
											$stage-abbreviation = 'FDAMD' or 
											$stage-abbreviation = 'FDAM' or 
											$stage-abbreviation = 'DAMD' or 
											$stage-abbreviation = 'DAM' or 
											$stage-abbreviation = 'NWIP' or 
											$stage-abbreviation = 'NP' or 
											$stage-abbreviation = 'PWI' or 
											$stage-abbreviation = 'AWI' or 
											$stage-abbreviation = 'WD' or 
											$stage-abbreviation = 'CD'">
			<fo:block margin-bottom="1.5mm">
				<!-- <xsl:text>RECIPIENTS OF THIS DRAFT ARE INVITED TO
									SUBMIT, WITH THEIR COMMENTS, NOTIFICATION
									OF ANY RELEVANT PATENT RIGHTS OF WHICH
									THEY ARE AWARE AND TO PROVIDE SUPPORTING
									DOCUMENTATION.</xsl:text> -->
				<xsl:value-of select="java:toUpperCase(java:java.lang.String.new($i18n_draft_comment_2))"/>
			</fo:block>
			<fo:block>
				<!-- <xsl:text>IN ADDITION TO THEIR EVALUATION AS
						BEING ACCEPTABLE FOR INDUSTRIAL, TECHNOLOGICAL,
						COMMERCIAL AND USER PURPOSES,
						DRAFT INTERNATIONAL STANDARDS MAY ON
						OCCASION HAVE TO BE CONSIDERED IN THE
						LIGHT OF THEIR POTENTIAL TO BECOME STANDARDS
						TO WHICH REFERENCE MAY BE MADE IN
						NATIONAL REGULATIONS.</xsl:text> -->
				<xsl:value-of select="java:toUpperCase(java:java.lang.String.new($i18n_draft_comment_3))"/>
			</fo:block>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="insertVoteStarted">
		<xsl:variable name="vote_started" select="normalize-space(/mn:metanorma/mn:bibdata/mn:date[@type = 'vote-started']/mn:on)"/>
		<xsl:choose>
			<xsl:when test="$vote_started != ''">
				<xsl:value-of select="$vote_started"/>
			</xsl:when>
			<xsl:otherwise>YYYY-MM-DD</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="insertVoteEnded">
		<xsl:variable name="vote_ended" select="normalize-space(/mn:metanorma/mn:bibdata/mn:date[@type = 'vote-ended']/mn:on)"/>
		<xsl:choose>
			<xsl:when test="$vote_ended != ''">
				<xsl:value-of select="$vote_ended"/>
			</xsl:when>
			<xsl:otherwise>YYYY-MM-DD</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="insertCoverPageAdditionalNotes">
		<xsl:if test="$stage-abbreviation = 'NWIP' or $stage-abbreviation = 'NP' or $stage-abbreviation = 'PWI' or $stage-abbreviation = 'AWI' or $stage-abbreviation = 'WD' or $stage-abbreviation = 'CD' or $stage-abbreviation = 'FCD' or 
											$stage-abbreviation = 'DIS' or $stage-abbreviation = 'FDIS' or $stage-abbreviation = 'DAMD' or $stage-abbreviation = 'DAM' or $stagename_abbreviation = 'DIS' or $stagename_abbreviation = 'FDIS'">
			<xsl:variable name="text">
				<xsl:for-each select="/mn:metanorma/mn:preface/mn:note[@coverpage='true']/mn:p">
					<fo:block>
						<xsl:apply-templates />
					</fo:block>
				</xsl:for-each>
			</xsl:variable>
			<xsl:if test="normalize-space($text) != ''">
				<fo:block-container margin-left="1mm" role="SKIP"> <!-- margin-bottom="7mm" margin-top="-15mm" -->
					<fo:block font-size="9pt" border="0.5pt solid black" fox:border-radius="5pt" padding-left="2mm" padding-top="2mm" padding-bottom="2mm">
						<xsl:if test="$layoutVersion = '2024'">
							<!-- <xsl:attribute name="font-size">9pt</xsl:attribute> -->
							<xsl:attribute name="fox:border-radius">0pt</xsl:attribute>
							<xsl:attribute name="border">1pt solid black</xsl:attribute>
						</xsl:if>
						<!-- <xsl:text>This document is circulated as received from the committee secretariat.</xsl:text> -->
						<xsl:copy-of select="xalan:nodeset($text)/node()"/>
					</fo:block>
				</fo:block-container>
			</xsl:if>
			
			<xsl:variable name="iso-fast-track" select="normalize-space(/mn:metanorma/mn:bibdata/mn:ext/mn:fast-track)"/>
			
			<xsl:if test="normalize-space($iso-fast-track) = 'true'">
				<fo:block-container space-before="2mm" role="SKIP">
					<fo:block background-color="rgb(77,77,77)" color="white" fox:border-radius="5pt" text-align="center" display-align="center" font-size="19pt" font-weight="bold" role="SKIP">
						<xsl:if test="$layoutVersion = '2024'">
							<xsl:attribute name="fox:border-radius">0pt</xsl:attribute>
						</xsl:if>
						<fo:block-container height="13.2mm" role="SKIP">
							<xsl:if test="$layoutVersion = '2024'">
								<xsl:attribute name="height">11.2mm</xsl:attribute>
								<xsl:attribute name="padding-top">2mm</xsl:attribute>
							</xsl:if>
							<fo:block>
								<!-- <xsl:text>FAST TRACK PROCEDURE</xsl:text>  -->
								<xsl:value-of select="java:toUpperCase(java:java.lang.String.new($i18n_fast_track_procedure))"/>
							</fo:block>
						</fo:block-container>
					</fo:block>
				</fo:block-container>
			</xsl:if>
			
			<xsl:variable name="iso-cen-parallel" select="normalize-space(/mn:metanorma/mn:bibdata/mn:ext/mn:iso-cen-parallel)"/>
			
			<xsl:if test="normalize-space($iso-cen-parallel) = 'true'">
				<fo:block-container space-before="4mm" role="SKIP">
					<fo:block background-color="rgb(77,77,77)" color="white" fox:border-radius="5pt" text-align="center" display-align="center" font-size="19pt" font-weight="bold" role="SKIP">
						<xsl:if test="$layoutVersion = '2024'">
							<xsl:attribute name="background-color">rgb(88,88,88)</xsl:attribute>
							<xsl:attribute name="fox:border-radius">0pt</xsl:attribute>
							<xsl:attribute name="font-size">16pt</xsl:attribute>
						</xsl:if>
						<fo:block-container height="13.2mm" role="SKIP">
							<xsl:if test="$layoutVersion = '2024'">
								<xsl:attribute name="height">11.2mm</xsl:attribute>
								<xsl:attribute name="padding-top">2mm</xsl:attribute>
							</xsl:if>
							<fo:block>
								<!-- <xsl:text>ISO/CEN PARALLEL PROCESSING</xsl:text>  -->
								<xsl:call-template name="add-letter-spacing">
									<xsl:with-param name="text" select="java:toUpperCase(java:java.lang.String.new($i18n_iso_cen_parallel))"/>
									<xsl:with-param name="letter-spacing" select="0.13"/>
								</xsl:call-template>
							</fo:block>
						</fo:block-container>
					</fo:block>
				</fo:block-container>
			</xsl:if>
			
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="mn:preface//mn:clause[@type = 'toc']" name="toc" priority="3">
		<xsl:choose>
			<xsl:when test="$isGenerateTableIF = 'true'"/>
			<xsl:when test="$toc_level = 0"/>
			<xsl:when test="$doctype = 'amendment'"></xsl:when><!-- ToC shouldn't be generated in amendments. -->
			<xsl:when test="$layoutVersion = '1987' and $doctype = 'technical-report'"></xsl:when>
			<xsl:otherwise>
				
				<fo:block-container xsl:use-attribute-sets="toc-style">
				
					<xsl:call-template name="refine_toc-style"/>
				
					<!-- render 'Contents' outside if role="TOC" -->
					<xsl:apply-templates select="mn:fmt-title"/>
				
					<fo:block role="TOC">
					
						<xsl:apply-templates select="node()[not(self::mn:fmt-title)]"/>
					
						<xsl:if test="count(*) = 1 and mn:fmt-title"> <!-- if there isn't user ToC -->
			
							<xsl:if test="$debug = 'true'">
								<redirect:write file="contents_.xml">
									<xsl:copy-of select="$contents"/>
								</redirect:write>
							</xsl:if>
							
							<xsl:variable name="margin-left">12</xsl:variable>
							
							<xsl:for-each select="$contents//mnx:item[@display = 'true']"><!-- [not(@level = 2 and starts-with(@section, '0'))] skip clause from preface -->
								
								<xsl:if test="$layoutVersion = '1987'">
									<xsl:if test="@type = 'annex'	and @level = 1 and not(preceding-sibling::mnx:item[@type = 'annex' and @level = 1])">
										<fo:block role="TOCI" font-weight="bold" margin-top="12pt" margin-bottom="6pt" keep-with-next="always">
											<xsl:call-template name="getLocalizedString">
												<xsl:with-param name="key">Annex.pl</xsl:with-param>
											</xsl:call-template>
										</fo:block>
									</xsl:if>
								</xsl:if>
								
								<fo:block role="TOCI" xsl:use-attribute-sets="toc-item-style">
								
									<xsl:call-template name="refine_toc-item-style"/>
									
									<fo:basic-link internal-destination="{@id}" fox:alt-text="{@section} {mnx:title}"> <!-- link at this level needs for PDF structure tags -->
									
										<fo:list-block role="SKIP">
											<xsl:attribute name="margin-left"><xsl:value-of select="$margin-left * (@level - 1)"/>mm</xsl:attribute>
											
											<xsl:if test="$layoutVersion = '1987'">
												<xsl:attribute name="margin-left">0</xsl:attribute>
												<xsl:if test="@level &gt;= 3">
													<xsl:attribute name="margin-left"><xsl:value-of select="$margin-left div 2 * 1.2 * (@level - 2)"/>mm</xsl:attribute>
												</xsl:if>
											</xsl:if>
											
											<xsl:if test="@level &gt;= 2 or @type = 'annex'">
												<xsl:attribute name="font-weight">normal</xsl:attribute>
											</xsl:if>
											<xsl:variable name="provisional_distance_between_starts">
												<xsl:choose>
													<!-- skip 0 section without subsections -->
													<xsl:when test="$layoutVersion = '1987' and @level &gt;= 3"><xsl:value-of select="$margin-left div 2 * 1.2"/></xsl:when>
													<xsl:when test="@level &gt;= 3"><xsl:value-of select="$margin-left * 1.2"/></xsl:when>
													<xsl:when test="$layoutVersion = '1987' and @type = 'section'">0</xsl:when>
													<xsl:when test="$layoutVersion = '1987' and @section != ''"><xsl:value-of select="$margin-left div 2 * 1.2"/></xsl:when>
													<xsl:when test="@section != ''"><xsl:value-of select="$margin-left"/></xsl:when>
													<xsl:otherwise>0</xsl:otherwise>
												</xsl:choose>
											</xsl:variable>
											<xsl:variable name="section_length_str" select="string-length(normalize-space(@section))"/>
											<xsl:variable name="section_length_mm" select="$section_length_str * 2.1"/>
											
											<!-- refine the distance depends on the section string length -->
											<xsl:attribute name="provisional-distance-between-starts">
												<xsl:choose>
													<xsl:when test="$layoutVersion = '1987' and @type = 'section'">0</xsl:when>
													<xsl:when test="$section_length_mm &gt; $provisional_distance_between_starts">
														<xsl:value-of select="concat($section_length_mm, 'mm')"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="concat($provisional_distance_between_starts, 'mm')"/>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:attribute>
											
											<fo:list-item role="SKIP">
												<fo:list-item-label end-indent="label-end()" role="SKIP">
													<fo:block role="SKIP">
														<xsl:if test="$layoutVersion = '1987'">
															<xsl:attribute name="font-weight">bold</xsl:attribute>
														</xsl:if>
														<xsl:choose>
															<xsl:when test="$layoutVersion = '1987' and @type = 'section'"></xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="@section"/>
															</xsl:otherwise>
														</xsl:choose>
													</fo:block>
												</fo:list-item-label>
												<fo:list-item-body start-indent="body-start()" role="SKIP">
													<fo:block text-align-last="justify" margin-left="12mm" text-indent="-12mm" role="SKIP">
													
														<xsl:if test="$layoutVersion = '1987' and @type = 'section'">
															<xsl:attribute name="font-weight">bold</xsl:attribute>
														</xsl:if>
													
														<fo:basic-link internal-destination="{@id}" fox:alt-text="{mnx:title}" role="SKIP">
														
															<xsl:if test="$layoutVersion = '1987' and @type = 'section'">
																<xsl:value-of select="concat(@section, ' ')"/>
															</xsl:if>
															<xsl:apply-templates select="mnx:title"/>
															
															<fo:inline keep-together.within-line="always" role="SKIP">
																<fo:leader xsl:use-attribute-sets="toc-leader-style"/>
																<fo:inline role="SKIP">
																	<xsl:if test="@level = 1 and @type = 'annex'">
																		<xsl:attribute name="font-weight">bold</xsl:attribute>
																	</xsl:if>
																	<xsl:if test="$layoutVersion = '1987'">
																		<xsl:attribute name="font-weight">normal</xsl:attribute>
																	</xsl:if>
																	<fo:wrapper role="artifact">
																		<fo:page-number-citation ref-id="{@id}"/>
																	</fo:wrapper>
																</fo:inline>
															</fo:inline>
														</fo:basic-link>
													</fo:block>
												</fo:list-item-body>
											</fo:list-item>
										</fo:list-block>
									</fo:basic-link>
								</fo:block>
								
							</xsl:for-each>
							
							<!-- List of Tables -->
							<xsl:for-each select="$contents//mnx:tables/mnx:table">
								<xsl:if test="position() = 1">
									<xsl:call-template name="insertListOf_Title">
										<xsl:with-param name="title" select="$title-list-tables"/>
									</xsl:call-template>
								</xsl:if>
								<xsl:call-template name="insertListOf_Item"/>
							</xsl:for-each>
							
							<!-- List of Figures -->
							<xsl:for-each select="$contents//mnx:figures/mnx:figure">
								<xsl:if test="position() = 1">
									<xsl:call-template name="insertListOf_Title">
										<xsl:with-param name="title" select="$title-list-figures"/>
									</xsl:call-template>
								</xsl:if>
								<xsl:call-template name="insertListOf_Item"/>
							</xsl:for-each>
						
						</xsl:if>
					</fo:block>
				</fo:block-container>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="mn:preface//mn:clause[@type = 'toc']/mn:fmt-title" priority="3">
		<fo:block xsl:use-attribute-sets="toc-title-style">
			<xsl:if test="$layoutVersion = '2024'">
				<xsl:attribute name="margin-top">0</xsl:attribute>
			</xsl:if>
			<fo:inline role="SKIP">
				<xsl:if test="$layoutVersion = '1987'">
					<xsl:attribute name="font-size">14pt</xsl:attribute>
				</xsl:if>
				<!-- <xsl:if test="$layoutVersion = '2024'">
					<xsl:attribute name="font-size">15.3pt</xsl:attribute>
				</xsl:if> -->
				<!-- Contents -->
				<!-- <xsl:call-template name="getLocalizedString">
					<xsl:with-param name="key">table_of_contents</xsl:with-param>
				</xsl:call-template> -->
				<xsl:apply-templates />
			</fo:inline>
			<fo:inline font-weight="normal" keep-together.within-line="always" role="SKIP">
				<fo:leader leader-pattern="space"/>
				<fo:inline xsl:use-attribute-sets="toc-title-page-style">
					<xsl:if test="$layoutVersion = '1987'">
						<xsl:attribute name="font-size">8pt</xsl:attribute>
					</xsl:if>
					<!-- <xsl:if test="$layoutVersion = '2024'">
						<xsl:attribute name="font-size">9.6pt</xsl:attribute>
					</xsl:if> -->
					<!-- Page -->
					<xsl:value-of select="$i18n_locality_page"/>
				</fo:inline>
			</fo:inline>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="mn:pagebreak" priority="2">
		<xsl:choose>
			<xsl:when test="ancestor::mn:annex">
				<xsl:variable name="annex_id" select="ancestor::mn:annex/@id"/>
				<xsl:choose>
					<xsl:when test="following::*[ancestor::mn:annex[@id = $annex_id]]">
						<xsl:copy-of select="."/>
					</xsl:when>
					<xsl:otherwise><!-- skip --></xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="insertListOf_Title">
		<xsl:param name="title"/>
		<fo:block xsl:use-attribute-sets="toc-listof-title-style">
			<xsl:value-of select="$title"/>
		</fo:block>
	</xsl:template>
	
	<xsl:template name="insertListOf_Item">
		<fo:block xsl:use-attribute-sets="toc-listof-item-style">
			<fo:basic-link internal-destination="{@id}">
				<xsl:call-template name="setAltText">
					<xsl:with-param name="value" select="@alt-text"/>
				</xsl:call-template>
				<xsl:apply-templates select="." mode="contents"/>
				<fo:inline keep-together.within-line="always">
					<fo:leader xsl:use-attribute-sets="toc-leader-style"/>
					<fo:inline><fo:page-number-citation ref-id="{@id}"/></fo:inline>
				</fo:inline>
			</fo:basic-link>
		</fo:block>
	</xsl:template>

	
	<!-- ==================== -->
	<!-- display titles       -->
	<!-- ==================== -->
	<xsl:template match="mn:bibdata/mn:title[@type = 'title-intro']">
		<xsl:choose>
			<xsl:when test="$layoutVersion = '1951'">
				<fo:block text-transform="uppercase"><xsl:apply-templates /></fo:block>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates />
				<xsl:value-of select="$nonbreak_space_em_dash_space"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="mn:bibdata/mn:title[@type = 'title-main']">
		<xsl:param name="body">false</xsl:param>
		<xsl:choose>
			<xsl:when test="$layoutVersion = '1951'">
				<fo:block text-transform="uppercase" font-weight="bold" margin-top="5mm">
					<xsl:if test="$revision_date_num &lt; 19680101">
						<xsl:if test="$body = 'false'">
							<xsl:attribute name="font-weight">normal</xsl:attribute>
						</xsl:if>
						<xsl:if test="../mn:title[@type = 'title-intro']"> <!-- in title-intro and title-main exist both -->
							<xsl:attribute name="font-size">11pt</xsl:attribute>
						</xsl:if>
						<xsl:attribute name="margin-top">3mm</xsl:attribute>
					</xsl:if>
					<xsl:apply-templates />
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="mn:bibdata/mn:title[@type = 'title-complementary']">
		<xsl:param name="body">false</xsl:param>
		<xsl:value-of select="$nonbreak_space_em_dash_space"/>
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="mn:bibdata/mn:title[@type = 'title-part']">
		<xsl:param name="curr_lang" select="$lang"/>
		<xsl:param name="isMainLang">false</xsl:param>
		<xsl:choose>
			<xsl:when test="$part != ''">
				<!-- <xsl:text> — </xsl:text> -->
				<xsl:choose>
					<xsl:when test="$layoutVersion = '1951'"></xsl:when>
					<xsl:otherwise><xsl:value-of select="$nonbreak_space_em_dash_space"/></xsl:otherwise>
				</xsl:choose>
				<xsl:variable name="part-word">
					<xsl:choose>
						<xsl:when test="$isMainLang = 'true'">
							<xsl:value-of select="concat($i18n_locality_part, ' ', $part, ':')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="java:replaceAll(java:java.lang.String.new($titles/title-part[@lang=$curr_lang]),'#',$part)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="$isMainLang = 'true'">
						<xsl:choose>
							<xsl:when test="$layoutVersion = '1951'">
								<xsl:value-of select="$part-word"/>
								<xsl:apply-templates />
							</xsl:when>
							<xsl:when test="$layoutVersion = '1972' or $layoutVersion = '1979'">
								<fo:block font-weight="bold" role="SKIP">
									<xsl:value-of select="$part-word"/>
									<xsl:text>&#xa0;</xsl:text>
									<xsl:apply-templates />
								</fo:block>
							</xsl:when>
							<xsl:when test="$layoutVersion = '1987'">
								<fo:block font-weight="bold" margin-top="12pt" role="SKIP">
									<xsl:value-of select="$part-word"/>
								</fo:block>
							</xsl:when>
							<xsl:otherwise>
							<fo:block font-weight="normal" margin-top="6pt" role="SKIP">
								<xsl:value-of select="$part-word"/>
							</fo:block>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<!-- <xsl:value-of select="$linebreak"/> -->
						<xsl:choose>
							<xsl:when test="$layoutVersion = '1972' or $layoutVersion = '1979'"></xsl:when>
							<xsl:otherwise>
								<fo:block font-size="1pt" margin-top="5pt" role="SKIP">&#xa0;</fo:block>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:value-of select="$part-word"/>
						<xsl:text>&#xa0;</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise> <!-- $part = '' -->
				<xsl:choose>
					<xsl:when test="$layoutVersion = '1951'"></xsl:when>
					<xsl:otherwise><xsl:value-of select="$nonbreak_space_em_dash_space"/></xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="$layoutVersion = '1951'"><fo:inline font-weight="normal"><xsl:apply-templates /></fo:inline></xsl:when>
			<xsl:when test="($layoutVersion = '1972' or $layoutVersion = '1979') and $isMainLang = 'true'"/>
			<xsl:when test="($layoutVersion = '1972' or $layoutVersion = '1979') and $isMainLang = 'false'">
				<fo:inline font-weight="normal"><xsl:apply-templates /></fo:inline>
			</xsl:when>
			<xsl:when test="$layoutVersion = '1987'">
				<fo:inline font-weight="normal"><xsl:apply-templates /></fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="mn:bibdata/mn:title[@type = 'title-amd']">
		<xsl:param name="isMainLang">false</xsl:param>
		<xsl:param name="curr_lang" select="$lang"/>
		<xsl:param name="isMainBody">false</xsl:param>
		<xsl:if test="$doctype = 'amendment'">
			<fo:block margin-right="-5mm" margin-top="6pt" role="H1">
				<xsl:if test="$isMainLang = 'true'">
					<xsl:attribute name="margin-top">12pt</xsl:attribute>
				</xsl:if>
				<xsl:if test="$stage-abbreviation = 'DIS' or $isMainBody = 'true'">
					<xsl:attribute name="margin-right">0mm</xsl:attribute>
				</xsl:if>
				
				<fo:block font-weight="normal" line-height="1.1" role="SKIP">
					<xsl:choose>
						<xsl:when test="$isMainLang = 'false' and $curr_lang = 'fr'">AMENDEMENT</xsl:when>
						<xsl:otherwise><xsl:value-of select="$doctype_uppercased"/></xsl:otherwise>
					</xsl:choose>
					<xsl:variable name="amendment-number" select="/mn:metanorma/mn:bibdata/mn:ext/mn:structuredidentifier/mn:project-number/@amendment"/>
					<xsl:if test="normalize-space($amendment-number) != ''">
						<xsl:text> </xsl:text><xsl:value-of select="$amendment-number"/>
					</xsl:if>
					
					<xsl:if test="not($stage-abbreviation = 'DAMD' or $stage-abbreviation = 'DAM')">
						<xsl:text>: </xsl:text>
						<xsl:apply-templates />
					</xsl:if>
				</fo:block>
				
			</fo:block>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="mn:sections//mn:p[@class = 'zzSTDTitle1']" priority="4">
		<xsl:choose>
			<xsl:when test="$layoutVersion = '1951'">
				<fo:block font-size="13pt" font-weight="bold" text-align="center" margin-top="49mm" margin-bottom="20mm" text-transform="uppercase" line-height="1.1" role="H1">
					<xsl:if test="$revision_date_num &gt;= 19680101">
						<xsl:attribute name="font-family">Arial</xsl:attribute>
						<xsl:attribute name="font-size">10.5pt</xsl:attribute>
						<xsl:attribute name="margin-top">24mm</xsl:attribute>
					</xsl:if>
					<xsl:if test="following-sibling::*[1][self::mn:p][starts-with(@class, 'zzSTDTitle')]">
						<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
					</xsl:if>
					
					<xsl:choose>
						<xsl:when test="$revision_date_num &gt;= 19680101">
							<fo:block font-weight="normal"><xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:title[@language = $lang and @type = 'title-intro']"/></fo:block>
							<fo:block space-before="24pt"><xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:title[@language = $lang and @type = 'title-main']"/></fo:block>
							<fo:block space-before="24pt"><xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:title[@language = $lang and @type = 'title-complementary']"/></fo:block>
						</xsl:when>
						<xsl:otherwise>
						
							<xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:title[@language = $lang and @type = 'title-intro']"/>
							<xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:title[@language = $lang and @type = 'title-main']">
								<xsl:with-param name="body">true</xsl:with-param>
							</xsl:apply-templates>
							<xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:title[@language = $lang and @type = 'title-complementary']"/>
							<fo:block font-size="11pt" text-transform="uppercase" margin-top="2mm">
								<xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:title[@language = $lang and @type = 'title-part']/node()"/>
							</fo:block>
						
							<!-- <xsl:apply-templates/> -->
						</xsl:otherwise>
					</xsl:choose>
					
				</fo:block>
			</xsl:when>
			<xsl:when test="$layoutVersion = '1987' and $doctype = 'technical-report'"></xsl:when>
			<xsl:when test="$layoutVersion = '1972' or $layoutVersion = '1979' or $layoutVersion = '1987' or $layoutVersion = '1989'">
				<fo:block font-size="16pt" font-weight="bold" margin-top="40pt" margin-bottom="40pt" line-height="1.1" role="H1" span="all">
					<xsl:if test="following-sibling::*[1][self::mn:p][starts-with(@class, 'zzSTDTitle')]">
						<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
					</xsl:if>
					<xsl:if test="$doctype = 'addendum'">
						<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
					</xsl:if>
					<xsl:apply-templates />
				</fo:block>
				<xsl:if test="$doctype = 'addendum'">
					<fo:block font-size="12pt" font-weight="bold" role="H2" line-height="1.05" margin-top="6pt" margin-bottom="40pt">
						<xsl:call-template name="printAddendumTitle"/>
					</fo:block>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<fo:block font-size="18pt" font-weight="bold" margin-top="40pt" margin-bottom="20pt" line-height="1.1" role="H1">
					<xsl:if test="$layoutVersion = '2024'">
						<xsl:attribute name="margin-top">50pt</xsl:attribute>
					</xsl:if>
					<xsl:if test="following-sibling::*[1][self::mn:p][starts-with(@class, 'zzSTDTitle')]">
						<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
					</xsl:if>
					<xsl:apply-templates />
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="mn:sections//mn:p[@class = 'zzSTDTitle1']/mn:span[@class = 'nonboldtitle']" priority="3">
		<!-- Example: <span class="nonboldtitle">Part 1:</span> -->
		<xsl:choose>
			<xsl:when test="$layoutVersion = '1972' or $layoutVersion = '1979'">
				<fo:inline font-weight="bold" role="SKIP">
					<xsl:apply-templates />
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<fo:block font-weight="normal" margin-top="12pt" line-height="1.1" role="SKIP">
					<xsl:apply-templates />
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="mn:sections//mn:p[@class = 'zzSTDTitle2']" priority="4">
		<!-- Example: <p class="zzSTDTitle2" displayorder="3">AMENDMENT 1: Mass fraction of extraneous matter, milled rice (nonglutinous), sample dividers and recommendations relating to storage and transport conditions</p> -->
		<xsl:if test="$doctype = 'amendment'">
			<fo:block font-size="18pt" margin-top="12pt" margin-bottom="20pt" margin-right="0mm" font-weight="normal" line-height="1.1" role="H1">
				<xsl:if test="$layoutVersion = '1972' or $layoutVersion = '1979' or $layoutVersion = '1987' or $layoutVersion = '1989'">
				<xsl:attribute name="font-size">16pt</xsl:attribute>
			</xsl:if>
				<!-- <xsl:if test="$layoutVersion = '2024'">
					<xsl:attribute name="font-size">17.2pt</xsl:attribute>
				</xsl:if> -->
				<xsl:apply-templates />
			</fo:block>
		</xsl:if>
	</xsl:template>
	
	<!-- ==================== -->
	<!-- END display titles   -->
	<!-- ==================== -->
	
	<xsl:template match="mn:fmt-title/mn:span[contains(@style, 'text-transform:none')]//text()" priority="6">
		<fo:inline font-weight="normal"><xsl:value-of select="."/></fo:inline>
	</xsl:template>
	
	<xsl:template match="node()">		
		<xsl:apply-templates />			
	</xsl:template>
	
	<!-- ============================= -->
	<!-- CONTENTS                                       -->
	<!-- ============================= -->
	
	<!-- element with title -->
	<xsl:template match="*[mn:title or mn:fmt-title]" mode="contents">
		<xsl:variable name="level">
			<xsl:call-template name="getLevel">
				<xsl:with-param name="depth" select="mn:fmt-title/@depth | mn:title/@depth"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="section">
			<xsl:call-template name="getSection"/>
		</xsl:variable>
		
		<xsl:variable name="type">
			<xsl:choose>
				<xsl:when test="self::mn:indexsect">index</xsl:when>
				<xsl:when test="@type = 'section'"><xsl:value-of select="@type"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="local-name()"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
			
		<xsl:variable name="display">
			<xsl:choose>				
				<xsl:when test="ancestor-or-self::mn:annex and $level &gt;= 2">false</xsl:when>
				<xsl:when test="ancestor-or-self::mn:introduction and $level &gt;= 2">false</xsl:when>
				<xsl:when test="$section = '' and $type = 'clause'">false</xsl:when>
				<xsl:when test="$level &lt;= $toc_level">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="skip">
			<xsl:choose>
				<xsl:when test="ancestor-or-self::mn:bibitem">true</xsl:when>
				<xsl:when test="ancestor-or-self::mn:term">true</xsl:when>				
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		
		<xsl:if test="$skip = 'false'">		
		
			<xsl:variable name="title">
				<xsl:call-template name="getName"/>
			</xsl:variable>
			
			<xsl:variable name="root">
				<xsl:if test="ancestor-or-self::mn:preface">preface</xsl:if>
				<xsl:if test="ancestor-or-self::mn:annex">annex</xsl:if>
			</xsl:variable>
			
			<mnx:item id="{@id}" level="{$level}" section="{$section}" type="{$type}" root="{$root}" display="{$display}">
				<xsl:if test="$type = 'index'">
					<xsl:attribute name="level">1</xsl:attribute>
				</xsl:if>
				<mnx:title>
					<xsl:apply-templates select="xalan:nodeset($title)" mode="contents_item">
						<xsl:with-param name="element">
							<xsl:if test="$level = 1"><xsl:value-of select="$root"/></xsl:if>
						</xsl:with-param>
					</xsl:apply-templates>
				</mnx:title>
				<xsl:if test="$type != 'index'">
					<xsl:apply-templates  mode="contents" />
				</xsl:if>
			</mnx:item>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="mn:p | mn:termsource | mn:termnote" mode="contents" />

	<xsl:template match="/" mode="contents_item">
		<xsl:param name="element"/>
		<xsl:apply-templates mode="contents_item">
			<xsl:with-param name="element" select="$element"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="mn:strong/text()" mode="contents_item">
		<xsl:param name="element"/>
		<xsl:choose>
			<xsl:when test="$layoutVersion = '1987' and $element = 'annex' and not(../preceding-sibling::node())"> <!-- omit Annex -->
					<xsl:value-of select="substring-after(., ' ')"/><xsl:text>&#xa0;&#xa0;</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="mn:span[@class = 'obligation']/text()" mode="contents_item">
		<xsl:param name="element"/>
		<xsl:choose>
			<xsl:when test="$layoutVersion = '1987' and $element = 'annex'"></xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	
	<!-- ============================= -->
	<!-- ============================= -->

	
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
	
	<xsl:template match="mn:copyright-statement/mn:clause[1]/mn:fmt-title" priority="2">
		<xsl:choose>
			<xsl:when test="$layoutVersion = '1951'">
				<fo:block><xsl:apply-templates /></fo:block> <!--  font-weight="bold" -->
				<fo:block>&#xa0;</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<fo:block margin-left="0.5mm" margin-bottom="3mm" role="H1">
					<xsl:if test="$layoutVersion = '2024'">
							<xsl:attribute name="margin-bottom">3.5mm</xsl:attribute>
						</xsl:if>
					<fo:external-graphic src="{concat('data:image/png;base64,', normalize-space($Image-Attention))}" width="14mm" content-height="13mm" content-width="scale-to-fit" scaling="uniform" fox:alt-text="Image {@alt}">
						<!-- <xsl:if test="$layoutVersion = '2024'">
							<xsl:attribute name="width">13mm</xsl:attribute>
							<xsl:attribute name="content-height">11.5mm</xsl:attribute>
							<xsl:attribute name="margin-bottom">-1mm</xsl:attribute>
						</xsl:if> -->
					</fo:external-graphic>
					<!-- <fo:inline padding-left="6mm" font-size="12pt" font-weight="bold">COPYRIGHT PROTECTED DOCUMENT</fo:inline> -->
					<fo:inline padding-left="6mm" font-size="12pt" font-weight="bold" role="SKIP">
						<xsl:if test="$layoutVersion = '1989'">
							<xsl:attribute name="font-size">11pt</xsl:attribute>
						</xsl:if>
						<xsl:if test="$layoutVersion = '2024'">
							<xsl:attribute name="baseline-shift">5%</xsl:attribute>
						</xsl:if>
					<xsl:apply-templates /></fo:inline>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="mn:copyright-statement/mn:clause" priority="3">
		<fo:block role="SKIP">
			<xsl:if test="@id = 'boilerplate-copyright-default' and ../mn:clause[not(@id = 'boilerplate-copyright-default')]">
				<xsl:attribute name="color">blue</xsl:attribute>
				<xsl:attribute name="border">1pt solid blue</xsl:attribute>
				<xsl:attribute name="padding">1mm</xsl:attribute>
			</xsl:if>
			<xsl:if test="not(@id = 'boilerplate-copyright-default') and preceding-sibling::mn:clause">
				<xsl:attribute name="margin-top">5mm</xsl:attribute>
			</xsl:if>
			<xsl:copy-of select="@id"/>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="mn:copyright-statement//mn:p" priority="2">
		<xsl:choose>
			<xsl:when test="$layoutVersion = '1951'">
				<xsl:choose>
					<xsl:when test="@id = 'boilerplate-message'">
						<fo:block-container width="87mm" margin-left="45mm" margin-right="45mm">
							<fo:block-container margin-left="0" margin-right="0">
								<fo:block text-align="justify" text-align-last="center">
								<!-- The copyright of ISO Recommendations and 1SO Standards
								belongs to ISO Member Bodies. Reproduction of these 
								documents, in any country, may be authorized therefore only
								by the national standards organization of that country, being
								a member of ISO. -->
									<xsl:apply-templates />
								</fo:block>
							</fo:block-container>
						</fo:block-container>
						<fo:block>&#xa0;</fo:block>
						<fo:block>&#xa0;</fo:block>
						<fo:block>&#xa0;</fo:block>
					</xsl:when>
					<xsl:when test="@id = 'boilerplate-place'">
						<fo:block>&#xa0;</fo:block>
						<fo:block>&#xa0;</fo:block>
						<fo:block><xsl:apply-templates /></fo:block>
						<fo:block>&#xa0;</fo:block>
						<fo:block>&#xa0;</fo:block>
					</xsl:when>
					<xsl:otherwise>
						<fo:block><xsl:apply-templates /></fo:block>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$layoutVersion = '1972' or $layoutVersion = '1979' or $layoutVersion = '1987'">
				<xsl:if test="@id = 'boilerplate-place'">
						<fo:block margin-top="6pt"><xsl:if test="(($layoutVersion = '1987' and $doctype = 'technical-report') or ($layoutVersion = '1979' and $doctype = 'addendum'))"><xsl:attribute name="margin-top">0</xsl:attribute></xsl:if>&#xa0;</fo:block>
				</xsl:if>
				<fo:block><xsl:apply-templates /></fo:block>
			</xsl:when>
			<xsl:otherwise>
				<fo:block>
					<xsl:if test="following-sibling::mn:p">
						<xsl:attribute name="margin-bottom">3pt</xsl:attribute>
					</xsl:if>
					<xsl:attribute name="margin-left">0.5mm</xsl:attribute>
					<xsl:attribute name="margin-right">0.5mm</xsl:attribute>
					<xsl:if test="contains(@id, 'address') or contains(normalize-space(), 'Tel:') or contains(normalize-space(), 'Phone:')">
						<xsl:attribute name="margin-left">4.5mm</xsl:attribute>
					</xsl:if>
					<xsl:apply-templates />
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	


	
	<!-- ====== -->
	<!-- title      -->
	<!-- ====== -->
	
	<xsl:template match="mn:annex/mn:fmt-title">
		<xsl:choose>
			<xsl:when test="$doctype = 'amendment'">
				<xsl:call-template name="titleAmendment"/>				
			</xsl:when>
			<xsl:otherwise>
				<fo:block font-size="16pt" text-align="center" margin-bottom="48pt" keep-with-next="always" role="H1">
					<xsl:call-template name="setIDforNamedDestination"/>
					<xsl:if test="$layoutVersion = '2024'">
						<xsl:attribute name="line-height">1.1</xsl:attribute>
						<!-- <xsl:attribute name="margin-bottom">52pt</xsl:attribute> -->
					</xsl:if>
					<xsl:if test="$layoutVersion = '1972' or $layoutVersion = '1979' or $layoutVersion = '1987' or $layoutVersion = '1989'">
						<xsl:attribute name="span">all</xsl:attribute>
					</xsl:if>
					<xsl:apply-templates />
					<xsl:apply-templates select="following-sibling::*[1][self::mn:variant-title][@type = 'sub']" mode="subtitle"/>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- Bibliography -->
	<xsl:template match="mn:references[not(@normative='true')]/mn:fmt-title">
		<xsl:choose>
			<xsl:when test="$doctype = 'amendment'">
				<xsl:call-template name="titleAmendment"/>				
			</xsl:when>
			<xsl:otherwise>
				<fo:block font-size="16pt" font-weight="bold" text-align="center" margin-top="6pt" margin-bottom="36pt" keep-with-next="always" role="H1">
					<xsl:if test="$layoutVersion = '1972' or $layoutVersion = '1979' or $layoutVersion = '1987' or $layoutVersion = '1989'">
						<xsl:attribute name="font-size">14pt</xsl:attribute>
						<xsl:attribute name="span">all</xsl:attribute>
					</xsl:if>
					<xsl:if test="$layoutVersion = '2024'">
						<xsl:attribute name="margin-top">0pt</xsl:attribute>
						<xsl:attribute name="margin-bottom">30pt</xsl:attribute>
					</xsl:if>
					<xsl:apply-templates />
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="mn:fmt-title" name="title">
		<xsl:param name="without_number">false</xsl:param>
		
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		
		<xsl:variable name="font-size">
			<xsl:choose>
				<xsl:when test="$layoutVersion = '1951'">
					<xsl:choose>
						<xsl:when test="$level = 1 and ancestor::mn:preface and $revision_date_num &gt;= 19680101">9.5pt</xsl:when> <!-- BRIEF HISTORY, FOREWORD -->
						<xsl:when test="$level = 1 and ancestor::mn:preface">13pt</xsl:when>
						<xsl:when test="$revision_date_num &lt; 19680101 and ancestor::mn:sections and not(ancestor::mn:introduction)">9pt</xsl:when>
						<!-- <xsl:when test="$level = 1">9pt</xsl:when> -->
						<xsl:otherwise>inherit</xsl:otherwise>
						<!-- <xsl:when test="$level = 2">10pt</xsl:when>
						<xsl:when test="$level &gt;= 3">9pt</xsl:when> -->
					</xsl:choose>
				</xsl:when>
				<xsl:when test="$layoutVersion = '1972'">
					<xsl:choose>
						<xsl:when test="$level = 1">9pt</xsl:when>
						<xsl:otherwise>9pt</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="(($layoutVersion = '1987' and $doctype = 'technical-report') or ($layoutVersion = '1979' and $doctype = 'addendum'))">
					<xsl:choose>
						<xsl:when test="$level = 1">11pt</xsl:when>
						<xsl:when test="$level = 2">10pt</xsl:when>
						<xsl:when test="$level &gt;= 3">9pt</xsl:when>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="$layoutVersion = '1972' or $layoutVersion = '1979' or $layoutVersion = '1987' or $layoutVersion = '1989'">
					<xsl:choose>
						<xsl:when test="ancestor::mn:annex and $level = 2">12pt</xsl:when>
						<xsl:when test="ancestor::mn:annex and $level = 3">11pt</xsl:when>
						<xsl:when test="ancestor::mn:introduction and $level &gt;= 2">10pt</xsl:when>
						<xsl:when test="ancestor::mn:preface">14pt</xsl:when>
						<xsl:when test="$level = 2">10pt</xsl:when>
						<xsl:when test="$level &gt;= 3">10pt</xsl:when>
						<xsl:otherwise>12pt</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<!-- <xsl:when test="$layoutVersion = '2024'">
					<xsl:choose>
						<xsl:when test="ancestor::mn:annex and $level = 2">12.5pt</xsl:when>
						<xsl:when test="ancestor::mn:annex and $level = 3">11.5pt</xsl:when>
						<xsl:when test="ancestor::mn:introduction and $level &gt;= 2">10.5pt</xsl:when>
						<xsl:when test="ancestor::mn:preface">15.3pt</xsl:when>
						<xsl:when test="$level = 2">11.5pt</xsl:when>
						<xsl:when test="$level &gt;= 3">10.5pt</xsl:when>
						<xsl:otherwise>12.5pt</xsl:otherwise>
					</xsl:choose>
				</xsl:when> -->
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="ancestor::mn:annex and $level = 2">13pt</xsl:when>
						<xsl:when test="ancestor::mn:annex and $level = 3">12pt</xsl:when>
						<xsl:when test="ancestor::mn:introduction and $level &gt;= 2">11pt</xsl:when>
						<xsl:when test="ancestor::mn:preface">16pt</xsl:when>
						<xsl:when test="$level = 2">12pt</xsl:when>
						<xsl:when test="$level &gt;= 3">11pt</xsl:when>
						<xsl:otherwise>13pt</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable> <!-- font-size -->
		
		<xsl:variable name="element-name">
			<xsl:choose>
				<xsl:when test="@inline-header = 'true'">fo:inline</xsl:when>
				<xsl:when test="../@inline-header = 'true'">fo:inline</xsl:when>
				<xsl:otherwise>fo:block</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="(($layoutVersion = '1987' and $doctype = 'technical-report') or ($layoutVersion = '1979' and $doctype = 'addendum')) and parent::mn:foreword"><!-- skip Foreword title --></xsl:when>
			<xsl:when test="$doctype = 'amendment' and not(ancestor::mn:preface)">
				<fo:block font-size="11pt" font-style="italic" margin-bottom="12pt" keep-with-next="always" role="H{$level}">
					<xsl:call-template name="setIDforNamedDestination"/>
					<!-- <xsl:if test="$layoutVersion = '2024'">
						<xsl:attribute name="font-size">10.5pt</xsl:attribute>
					</xsl:if> -->
					<xsl:apply-templates />
					<xsl:apply-templates select="following-sibling::*[1][self::mn:variant-title][@type = 'sub']" mode="subtitle"/>
				</fo:block>
			</xsl:when>
			
			<xsl:otherwise>
			
				<xsl:if test="(($layoutVersion = '1987' and $doctype = 'technical-report') or ($layoutVersion = '1979' and $doctype = 'addendum')) and parent::mn:introduction">
					<fo:block span="all" text-align="center" margin-top="15mm" keep-with-previous="always" role="SKIP">
						<fo:leader leader-pattern="rule" leader-length="12%"/>
					</fo:block>
				</xsl:if>
				
			
				<xsl:element name="{$element-name}">
				
					<xsl:if test="$layoutVersion = '1951' or $layoutVersion = '1972' or $layoutVersion = '1979' or $layoutVersion = '1987' or $layoutVersion = '1989'">
						<!-- copy @id from empty preceding clause -->
						<xsl:copy-of select="preceding-sibling::*[1][self::mn:clause and count(node()) = 0]/@id"/>
					</xsl:if>
				
					<xsl:attribute name="font-size"><xsl:value-of select="$font-size"/></xsl:attribute>
					<xsl:attribute name="font-weight">bold</xsl:attribute>
					<xsl:variable name="attribute-name-before">
						<xsl:choose>
							<xsl:when test="ancestor::mn:preface and $level = 1">margin-top</xsl:when> <!-- for Foreword and Introduction titles -->
							<xsl:otherwise>space-before</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:attribute name="{$attribute-name-before}"> <!-- space-before or margin-top -->
						<xsl:choose>
							<xsl:when test="$layoutVersion = '1951' and ancestor::mn:preface and $level = 1">20mm</xsl:when>
							<xsl:when test="$layoutVersion = '1951' and $level = 1 and $revision_date_num &gt;= 19680101">12pt</xsl:when>
							<xsl:when test="ancestor::mn:introduction and $level &gt;= 2 and ../preceding-sibling::mn:clause">30pt</xsl:when>
							<xsl:when test="(($layoutVersion = '1987' and $doctype = 'technical-report') or ($layoutVersion = '1979' and $doctype = 'addendum')) and ancestor::mn:preface and $level = 1">10mm</xsl:when>
							<xsl:when test="($layoutVersion = '1972' or $layoutVersion = '1979' or $layoutVersion = '1987' or ($layoutVersion = '1989' and $revision_date_num &lt;= 19981231)) and ancestor::mn:preface and $level = 1">62mm</xsl:when>
							<xsl:when test="$layoutVersion = '1972' and $level = 1">30pt</xsl:when>
							<xsl:when test="$layoutVersion = '1989' and ancestor::mn:preface and $level = 1">56pt</xsl:when>
							<xsl:when test="$layoutVersion = '2024' and ancestor::mn:preface and $level = 1">0pt</xsl:when>
							<xsl:when test="ancestor::mn:preface">8pt</xsl:when>
							<xsl:when test="$level = 2 and ancestor::mn:annex">18pt</xsl:when>
							<xsl:when test="$level = 1">18pt</xsl:when>
							<xsl:when test="($level = 2 or $level = 3) and not(../preceding-sibling::mn:clause) and $layoutVersion = '2024'">12pt</xsl:when> <!-- first title in 3rd level clause -->
							<xsl:when test="($level = 2 or $level = 3) and not(../preceding-sibling::mn:clause)">14pt</xsl:when> <!-- first title in 3rd level clause -->
							<xsl:when test="$level = 3">14pt</xsl:when>
							<xsl:when test="$level &gt; 3">3pt</xsl:when>
							<xsl:when test="$level = ''">6pt</xsl:when>
							<xsl:otherwise>12pt</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="space-after"> <!-- margin-bottom -->
						<xsl:choose>
							<xsl:when test="$layoutVersion = '1951' and $level = 1 and ancestor::mn:preface">14.7mm</xsl:when>
							<xsl:when test="$layoutVersion = '1951' and parent::mn:introduction and $revision_date_num &lt; 19680101">6mm</xsl:when>
							<xsl:when test="$layoutVersion = '1951' and parent::mn:introduction">2mm</xsl:when>
							<!-- <xsl:when test="$layoutVersion = '1951' and $revision_date_num &gt;= 19680101">4pt</xsl:when> -->
							<xsl:when test="$layoutVersion = '1951' and $level = 1">12pt</xsl:when>
							<xsl:when test="ancestor::mn:introduction and $level &gt;= 2">8pt</xsl:when>
							<xsl:when test="ancestor::mn:preface">18pt</xsl:when>
							<xsl:when test="$level = 3">9pt</xsl:when>
							<!-- <xsl:when test="$level = 2 and ancestor::mn:annex and $layoutVersion = '2024'">2pt</xsl:when> -->
							<!-- <xsl:otherwise>12pt</xsl:otherwise> -->
							<xsl:otherwise>8pt</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="keep-with-next">always</xsl:attribute>		
					<xsl:attribute name="role">H<xsl:value-of select="$level"/></xsl:attribute>
					<xsl:if test="@type = 'floating-title' or @type = 'section-title'">
						<xsl:copy-of select="@id"/>
					</xsl:if>
					<xsl:if test="$layoutVersion = '1951'">
						<xsl:if test="$element-name = 'fo:block' and ($level  = 1 or parent::mn:introduction)">
						
							<xsl:if test="($revision_date_num &lt; 19690101) or ancestor::mn:preface or (parent::mn:introduction and $revision_date_num &gt;= 19680101)">
							<xsl:attribute name="text-align">center</xsl:attribute>
							</xsl:if>
							
							<xsl:attribute name="text-transform">uppercase</xsl:attribute>
								
							<xsl:if test="ancestor::mn:preface or ancestor::mn:introduction">
								<xsl:attribute name="font-weight">normal</xsl:attribute>
							</xsl:if>
						</xsl:if>
					</xsl:if>
					
					<xsl:if test="$layoutVersion = '1972'">
						<xsl:if test="$level = 1">
							<xsl:attribute name="text-transform">uppercase</xsl:attribute>
						</xsl:if>
					</xsl:if>
					
					<xsl:if test="$layoutVersion = '1987' and ../@type = 'section'">
						<xsl:attribute name="font-size">14pt</xsl:attribute>
						<xsl:attribute name="text-align">center</xsl:attribute>
						<xsl:attribute name="margin-bottom">18pt</xsl:attribute>
						<xsl:attribute name="keep-with-next">always</xsl:attribute>
					</xsl:if>
					<xsl:if test="$element-name = 'fo:inline'">
						<xsl:choose>
							<xsl:when test="$lang = 'zh'">
								<xsl:value-of select="$tab_zh"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="padding-right">2mm</xsl:attribute>
							</xsl:otherwise>
						</xsl:choose>						
					</xsl:if>
					
					<xsl:call-template name="setIDforNamedDestinationInline"/>
					
					<xsl:choose>
						<xsl:when test="$layoutVersion = '1951' and ((ancestor::mn:preface and $level  = 1) or (parent::mn:introduction and $revision_date_num &lt; 19680101))">
							<xsl:call-template name="add-letter-spacing">
								<xsl:with-param name="text" select="."/>
								<xsl:with-param name="letter-spacing" select="0.65"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="($layoutVersion = '1951' or $layoutVersion = '1972') and ($level = 3 or $level = 4) and mn:tab">
							<xsl:if test="$without_number = 'false'">
								<fo:inline>
									<xsl:apply-templates select="mn:tab[1]/preceding-sibling::node() | node()"/>
								</fo:inline>
								<xsl:apply-templates select="mn:tab[1]"/>
							</xsl:if>
							<xsl:choose>
								<xsl:when test="$level = 3">
									<fo:inline font-weight="normal" font-style="italic"><xsl:apply-templates select="mn:tab[1]/following-sibling::node()"/></fo:inline>
								</xsl:when>
								<xsl:otherwise> <!-- i.e. $level = 4 -->
								
									<!-- small caps text with letter spacing -->
									<fo:inline font-weight="normal">
										<xsl:for-each select="mn:tab[1]/following-sibling::node()">
											<xsl:choose>
												<xsl:when test="self::text()">
													<fo:inline font-size="70%" letter-spacing="0.1em">
														<xsl:variable name="textSmallCaps">
															<xsl:call-template name="recursiveSmallCaps">
																<xsl:with-param name="text" select="."/>
																<xsl:with-param name="ratio" select="0.70"/>
																<xsl:with-param name="letter-spacing" select="'0.1em'"/>
															</xsl:call-template>
														</xsl:variable>
														<xsl:for-each select="xalan:nodeset($textSmallCaps)/node()">
															<xsl:choose>
																<xsl:when test="self::fo:inline">
																	<xsl:copy>
																		<xsl:copy-of select="@*"/>
																		<xsl:call-template name="add-letter-spacing">
																			<xsl:with-param name="text" select="."/>
																			<xsl:with-param name="letter-spacing">0.2</xsl:with-param>
																		</xsl:call-template>
																	</xsl:copy>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:call-template name="add-letter-spacing">
																		<xsl:with-param name="text" select="."/>
																		<xsl:with-param name="letter-spacing">0.2</xsl:with-param>
																	</xsl:call-template>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:for-each>
													</fo:inline>
												</xsl:when>
												<xsl:otherwise>
													<xsl:apply-templates select="."/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:for-each>
									</fo:inline> <!-- END:  small caps text with letter spacing -->
								
								</xsl:otherwise> <!-- END: $level = 4 -->
							</xsl:choose>
							
						</xsl:when> <!-- $layoutVersion = '1972' and ($level = 3 or $level = 4) -->
						
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="$without_number = 'true'">
									<xsl:apply-templates select="mn:tab[1]/following-sibling::node()"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:apply-templates />
								</xsl:otherwise>
							</xsl:choose>
							
						</xsl:otherwise>
					</xsl:choose>
					<xsl:apply-templates select="following-sibling::*[1][self::mn:variant-title][@type = 'sub']" mode="subtitle"/>
					
					
					<!-- because @id from preceding clause applied, see above -->
					<!-- <xsl:if test="$layoutVersion = '1951' or $layoutVersion = '1972' or $layoutVersion = '1979' or $layoutVersion = '1987' or $layoutVersion = '1989' or
							@type = 'floating-title' or @type = 'section-title'">
						<xsl:if test="@named_dest">
							<fo:inline>
								<xsl:call-template name="setIDforNamedDestination"/>
								<xsl:value-of select="$zero_width_space"/>
							</fo:inline>
						</xsl:if>
					</xsl:if> -->
				</xsl:element>
				
				<xsl:if test="$element-name = 'fo:inline' and not(following-sibling::mn:p)">
					<fo:block role="SKIP"> <!-- margin-bottom="12pt" -->
						<xsl:value-of select="$linebreak"/>
					</fo:block>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="mn:fmt-title[../@inline-header = 'true'][following-sibling::*[1][self::mn:p]]" priority="3">
		<xsl:param name="without_number">false</xsl:param>
		<xsl:choose>
			<xsl:when test="($layoutVersion = '1951' or $layoutVersion = '1972' or $layoutVersion = '1979' or $layoutVersion = '1987' or $layoutVersion = '1989') and $layout_columns != 1"/> <!-- don't show 'title' with inline-header='true' if next element is 'p' -->
			<xsl:otherwise>
				<xsl:call-template name="title">
					<xsl:with-param name="without_number" select="$without_number"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="titleAmendment">
		<!-- <xsl:variable name="id">
			<xsl:call-template name="getId"/>
		</xsl:variable> id="{$id}"  -->
		<fo:block font-size="11pt" font-style="italic" margin-bottom="12pt" keep-with-next="always">
			<xsl:call-template name="setIDforNamedDestination"/>
			<!-- <xsl:if test="$layoutVersion = '2024'">
				<xsl:attribute name="font-size">10.5pt</xsl:attribute>
			</xsl:if> -->
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<!-- ====== -->
	<!-- ====== -->

	<xsl:template match="mn:clause[normalize-space() != '' or mn:figure]" priority="2">
		<xsl:choose>
			<xsl:when test="($layoutVersion = '1951' or $layoutVersion = '1972' or $layoutVersion = '1979' or $layoutVersion = '1987' or $layoutVersion = '1989') and
				self::mn:clause and count(node()) = 0 and following-sibling::*[1][self::mn:fmt-title and not(@id)]"></xsl:when> <!-- @id will be added to title -->
			<xsl:otherwise>
				<xsl:call-template name="template_clause_iso"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	
	<xsl:template match="mn:p" name="paragraph">
		<xsl:param name="inline" select="'false'"/>
		<xsl:param name="split_keep-within-line"/>
		<xsl:variable name="previous-element" select="local-name(preceding-sibling::*[1])"/>
		<xsl:variable name="element-name">
			<xsl:choose>
				<xsl:when test="$inline = 'true'">fo:inline</xsl:when>
				<xsl:when test="../@inline-header = 'true' and $previous-element = 'fmt-title'">fo:inline</xsl:when> <!-- first paragraph after inline title -->
				<xsl:when test="parent::mn:admonition">fo:inline</xsl:when>
				<xsl:otherwise>fo:block</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:call-template name="setNamedDestination"/>
		<xsl:element name="{$element-name}">
			
			<xsl:call-template name="setBlockAttributes">
				<xsl:with-param name="text_align_default">justify</xsl:with-param>
			</xsl:call-template>
			
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
			<xsl:if test="count(ancestor::mn:li) = 1 and not(ancestor::mn:li[1]/following-sibling::mn:li) and not(following-sibling::mn:p)">
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="starts-with(ancestor::mn:table[1]/@type, 'recommend') and not(following-sibling::mn:p)">
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="parent::*[self::mn:td or self::mn:th]">
				<xsl:choose>
					<xsl:when test="not(following-sibling::*)"> <!-- last paragraph in table cell -->
						<xsl:attribute name="margin-bottom">2pt</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="margin-bottom">5pt</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
				<!-- Special case: if paragraph in 'strong', i.e. it's sub-header, then keeps with next -->
				<xsl:if test="count(node()) = count(mn:strong) and following-sibling::*">
					<xsl:attribute name="keep-with-next">always</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="@id">
				<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
			</xsl:if>
			
			<!-- bookmarks only in paragraph -->
			<xsl:if test="count(mn:bookmark) != 0 and count(*) = count(mn:bookmark) and normalize-space() = ''">
				<xsl:attribute name="font-size">0</xsl:attribute>
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
				<xsl:attribute name="line-height">0</xsl:attribute>
			</xsl:if>
			<xsl:if test="$element-name = 'fo:inline'">
				<xsl:attribute name="role">P</xsl:attribute>
			</xsl:if>
			<xsl:if test="ancestor::*[self::mn:li or self::mn:td or self::mn:th or self::mn:dd]">
				<xsl:attribute name="role">SKIP</xsl:attribute>
			</xsl:if>
			<!-- <xsl:apply-templates>
				<xsl:with-param name="split_keep-within-line" select="$split_keep-within-line"/>
			</xsl:apply-templates> -->
			<!-- <xsl:apply-templates select="node()[not(self::mn:note[not(following-sibling::*) or count(following-sibling::*) = count(../mn:note) - 1])]"> -->
			
			<xsl:if test="$layoutVersion = '1951'">
				<xsl:if test="not(ancestor::*[self::mn:li or self::mn:td or self::mn:th or self::mn:dd])">
					<!-- for paragraphs in the main text -->
					<xsl:choose>
						<xsl:when test="$revision_date_num &lt; 19600101">
							<xsl:attribute name="margin-bottom">14pt</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
				<xsl:if test="(ancestor::mn:preface and parent::mn:clause) or ancestor::mn:foreword">
					<xsl:attribute name="text-indent">7.1mm</xsl:attribute>
				</xsl:if>
			</xsl:if>
			
			<xsl:if test="$layoutVersion = '2024'">
				<xsl:attribute name="line-height">1.13</xsl:attribute>
				<xsl:if test="parent::mn:li/following-sibling::* or parent::mn:dd">
					<xsl:attribute name="margin-bottom">9pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			
			<!-- put inline title in the first paragraph -->
			<xsl:if test="($layoutVersion = '1951' or $layoutVersion = '1972' or $layoutVersion = '1979' or $layoutVersion = '1987' or $layoutVersion = '1989') and $layout_columns != 1">
				<!-- <xsl:if test="preceding-sibling::*[1]/@inline-header = 'true' and preceding-sibling::*[1][self::mn:title]"> -->
				<xsl:if test="ancestor::*[1]/@inline-header = 'true' and preceding-sibling::*[1][self::mn:fmt-title]">
					<xsl:attribute name="space-before">0pt</xsl:attribute>
					<xsl:for-each select="preceding-sibling::*[1]">
						<xsl:call-template name="title"/>
					</xsl:for-each>
					<xsl:text> </xsl:text>
				</xsl:if>
			</xsl:if>
			
			<xsl:apply-templates select="node()[not(self::mn:note)]"> <!-- note renders below paragraph for correct PDF tags order (see https://github.com/metanorma/metanorma-iso/issues/1003) -->
				<xsl:with-param name="split_keep-within-line" select="$split_keep-within-line"/>
			</xsl:apply-templates>
		</xsl:element>
		
		<xsl:apply-templates select="mn:note"/> <!-- [not(following-sibling::*) or count(following-sibling::*) = count(../mn:note) - 1] -->
		
		<xsl:if test="$element-name = 'fo:inline' and not($inline = 'true') and not(parent::mn:admonition)">
			<fo:block margin-bottom="12pt" role="SKIP">
				 <xsl:if test="ancestor::mn:sections or ancestor::mn:annex or following-sibling::mn:table">
					<xsl:attribute name="margin-bottom">0</xsl:attribute>
				 </xsl:if>
				<xsl:value-of select="$linebreak"/>
			</fo:block>
		</xsl:if>
		<xsl:if test="$inline = 'true'">
			<fo:block role="SKIP">&#xA0;</fo:block>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="mn:li//mn:p//text()">
		<xsl:choose>
			<xsl:when test="contains(., '&#x9;')">
				<!-- <fo:inline white-space="pre"><xsl:value-of select="translate(., $thin_space, ' ')"/></fo:inline> -->
				<fo:inline white-space="pre"><xsl:value-of select="."/></fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<!-- <xsl:value-of select="translate(., $thin_space, ' ')"/> -->
				<!-- <xsl:value-of select="."/> -->
				<xsl:call-template name="text"/>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
	
	<!-- For express listings PDF attachments -->
	<xsl:template match="mn:fmt-eref[java:endsWith(java:java.lang.String.new(@bibitemid),'.exp')]" priority="2">
		<fo:inline xsl:use-attribute-sets="eref-style">
			<xsl:variable name="url" select="concat('url(embedded-file:', @bibitemid, ')')"/>
			<fo:basic-link external-destination="{$url}" fox:alt-text="{@citeas}">
				<xsl:if test="normalize-space(@citeas) = ''">
					<xsl:attribute name="fox:alt-text"><xsl:value-of select="."/></xsl:attribute>
				</xsl:if>
				<xsl:apply-templates />
			</fo:basic-link>
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="mn:fmt-eref[contains(@bibitemid,'.exp_')]" priority="2">
		<xsl:variable name="bibitemid" select="@bibitemid" />
		<xsl:variable name="uri" select="normalize-space($bibitems/mn:bibitem[@hidden = 'true'][@id = $bibitemid][1]/mn:uri[@type='citation'])"/>
		<xsl:choose>
			<xsl:when test="$uri != ''">
				<xsl:variable name="filename" select="concat(substring-before($bibitemid, '.exp_'), '.exp')"/>
				<fo:inline xsl:use-attribute-sets="eref-style">
					<xsl:variable name="url" select="concat('url(embedded-file:', $filename, ')')"/>
					<fo:basic-link external-destination="{$url}" fox:alt-text="{@citeas}">
						<xsl:if test="normalize-space(@citeas) = ''">
							<xsl:attribute name="fox:alt-text"><xsl:value-of select="."/></xsl:attribute>
						</xsl:if>
						<xsl:apply-templates />
					</fo:basic-link>
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="eref"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="mn:note/mn:fmt-name/text()" priority="5">
		<xsl:choose>
			<xsl:when test="$layoutVersion = '1951' and not(translate(.,'0123456789','') = .)"> <!-- NOTE with number -->
				<fo:inline padding-right="2mm" role="SKIP">
					<xsl:value-of select="substring-after(., ' ')"/>
					<xsl:text>. </xsl:text>
				</fo:inline>
			</xsl:when>
			<xsl:when test="$layoutVersion = '1951'"> <!-- and $revision_date_num &lt; 19610101 -->
				<xsl:call-template name="smallcaps"/>
				<xsl:value-of select="concat('. ', $em_dash, ' ')"/>
			</xsl:when>
			<xsl:when test="$layoutVersion = '1987' and not(translate(.,'0123456789','') = .)"> <!-- NOTE with number -->
				<xsl:value-of select="substring-after(., ' ')"/>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="mn:example/mn:fmt-name/text()" priority="5">
		<xsl:choose>
			<xsl:when test="$layoutVersion = '1951'"> <!--  and $revision_date_num &lt; 19610101 -->
				<xsl:call-template name="smallcaps"/>
				<xsl:text>:</xsl:text>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="mn:figure/mn:fmt-name/text()" priority="5">
		<xsl:choose>
			<xsl:when test="$layoutVersion = '1951' and not(ancestor::mn:figure[1]/@unnumbered = 'true') and not(preceding-sibling::node())">
				<xsl:choose>
					<xsl:when test="contains(., '—')">
						<xsl:call-template name="smallcaps">
							<xsl:with-param name="txt" select="substring-before(., '—')"/>
						</xsl:call-template>
						<xsl:text>— </xsl:text>
						<xsl:value-of select="substring-after(., '—')"/>
					</xsl:when>
					<xsl:otherwise><xsl:call-template name="smallcaps"/></xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="mn:table/mn:fmt-name/text()" priority="5">
		<xsl:choose>
			<xsl:when test="$layoutVersion = '1951' and not(ancestor::mn:table[1]/@unnumbered = 'true') and not(preceding-sibling::node())">
				<xsl:choose>
					<xsl:when test="contains(., '—')">
						<xsl:call-template name="smallcaps">
							<xsl:with-param name="txt" select="substring-before(., '—')"/>
						</xsl:call-template>
						<xsl:text>— </xsl:text>
						<xsl:value-of select="substring-after(., '—')"/>
					</xsl:when>
					<xsl:otherwise><xsl:call-template name="smallcaps"/></xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<xsl:template match="mn:clause[@type = 'section']" priority="3">
		<xsl:choose>
			<!-- skip empty clause after templates mode="update_xml_step_move_pagebreak" -->
			<xsl:when test="not(mn:fmt-title) and normalize-space() = ''"></xsl:when>
			<xsl:otherwise>
				<xsl:if test="preceding-sibling::mn:clause[@type = 'section']">
					<fo:block break-after="page"/>
				</xsl:if>
				<fo:block span="all">
					<xsl:copy-of select="@id"/>
					<xsl:apply-templates select="mn:fmt-title"/>
				</fo:block>
				<xsl:apply-templates select="*[not(self::mn:fmt-title)]"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- main sections -->
	<xsl:template match="/*/mn:sections/*" name="sections_node_iso" priority="3">
		<xsl:call-template name="setNamedDestination"/>
		<fo:block>
			<xsl:call-template name="setId"/>
			
			<xsl:call-template name="sections_element_style"/>
			
			<xsl:if test="$layoutVersion = '1951' and $revision_date_num &gt;= 19680101">
				<xsl:attribute name="space-before">6pt</xsl:attribute>
				<xsl:if test="self::mn:introduction">
					<xsl:attribute name="space-after">36pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			
			<xsl:call-template name="addReviewHelper"/>
						
			<xsl:call-template name="processElementContent"/>
		</fo:block>
	</xsl:template>
	
	
	<xsl:template match="*[self::mn:sections or self::mn:annex]//mn:clause[normalize-space() != '' or mn:figure or @id]" name="template_clause_iso"> <!-- if clause isn't empty -->
		<xsl:call-template name="setNamedDestination"/>
		<fo:block>
			<xsl:if test="parent::mn:copyright-statement">
				<xsl:attribute name="role">SKIP</xsl:attribute>
			</xsl:if>
			
			<xsl:call-template name="setId"/>
			
			<xsl:call-template name="setBlockSpanAll"/>
			
			<xsl:call-template name="refine_clause_style"/>
			
			<xsl:call-template name="addReviewHelper"/>
			
			<xsl:call-template name="processElementContent"/>
			
		</fo:block>
	</xsl:template>
	
	
	<xsl:template name="processElementContent">
		<xsl:variable name="level">
			<xsl:call-template name="getLevel">
				<xsl:with-param name="depth" select="mn:fmt-title/@depth"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$layoutVersion = '1951' and ($revision_date_num &gt;= 19690101 or $level &gt;= 2) and ancestor::*[self::mn:sections or self::mn:annex] and not(self::mn:introduction)">
			
				<fo:list-block role="SKIP">
					<xsl:attribute name="provisional-distance-between-starts">
						<xsl:choose>
							<xsl:when test="$level = 2">8mm</xsl:when>
							<xsl:when test="$level = 3">12mm</xsl:when>
							<xsl:when test="$level = 4">14mm</xsl:when>
							<xsl:when test="$level &gt; 4">16mm</xsl:when>
							<xsl:otherwise>6mm</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					
					<fo:list-item>
						<fo:list-item-label end-indent="label-end()">
							<fo:block>
								<xsl:variable name="element_title">
									<xsl:apply-templates select="mn:fmt-title"/>
								</xsl:variable>
								<xsl:for-each select="xalan:nodeset($element_title)/*[1]"> <!-- process fo: element -->
									<xsl:copy-of select="@font-size"/>
									<xsl:copy-of select="@role"/>
									<xsl:copy-of select="@font-weight"/>
									<xsl:copy-of select="@font-style"/>
								</xsl:for-each>
								<xsl:value-of select="xalan:nodeset($element_title)/*[1]/node()[1]"/>
							</fo:block>
						</fo:list-item-label>
						<fo:list-item-body start-indent="body-start()">
							<fo:block>
								<xsl:apply-templates select="mn:fmt-title">
									<xsl:with-param name="without_number">true</xsl:with-param>
								</xsl:apply-templates>
								<xsl:apply-templates select="node()[not(self::mn:fmt-title)]"/>
							</fo:block>
						</fo:list-item-body>
					</fo:list-item>
				</fo:list-block>

			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<!-- page_sequence/sections/clause -->
	<xsl:template match="mn:sections/mn:page_sequence/*[not(@top-level)]" priority="3">
		<xsl:choose>
			<xsl:when test="self::mn:clause and normalize-space() = '' and count(*) = 0"></xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="sections_node_iso"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- =================== -->
	<!-- Index processing -->
	<!-- =================== -->
	
	<xsl:template match="mn:indexsect" />
	<xsl:template match="mn:indexsect" mode="index">
	
		<fo:page-sequence master-reference="index" force-page-count="no-force">
			<!-- <xsl:variable name="header-title">
				<xsl:choose>
					<xsl:when test="./mn:title[1]/mn:tab">
						<xsl:apply-templates select="./mn:title[1]/mn:tab[1]/following-sibling::node()" mode="header"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="./mn:title[1]" mode="header"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable> -->
			<xsl:call-template name="insertHeaderFooter">
				<!-- <xsl:with-param name="header-title" select="$header-title"/> -->
				<xsl:with-param name="font-weight">normal</xsl:with-param>
			</xsl:call-template>
			
			<fo:flow flow-name="xsl-region-body">
				<fo:block id="{@id}" text-align="center" span="all">
					<xsl:apply-templates select="mn:fmt-title"/>
				</fo:block>
				<fo:block role="Index">
					<xsl:apply-templates select="*[not(self::mn:fmt-title)]"/>
				</fo:block>
			</fo:flow>
		</fo:page-sequence>
	</xsl:template>
	
	
	<xsl:template match="mn:xref | mn:fmt-xref" priority="2">
		<xsl:call-template name="insert_basic_link">
			<xsl:with-param name="element">
				<fo:basic-link internal-destination="{@target}" fox:alt-text="{@target}" xsl:use-attribute-sets="xref-style">
					<xsl:if test="$layoutVersion = '2024' and (ancestor::mn:fmt-termsource or $bibitems/mn:bibitem[@id = current()/@target and @type = 'standard'])">
						<xsl:attribute name="color">inherit</xsl:attribute>
						<xsl:attribute name="text-decoration">none</xsl:attribute>
					</xsl:if>
					<xsl:choose>
						<xsl:when test="@pagenumber='true'">
							<fo:inline>
								<xsl:if test="@id">
									<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
								</xsl:if>
								<fo:page-number-citation ref-id="{@target}"/>
							</fo:inline>
						</xsl:when>
						<xsl:when test="$layoutVersion = '2024' and $bibitems/mn:bibitem[@id = current()/@target and not(@type = 'standard')]"> <!-- if reference to bibitem -->
							<!-- <fo:inline baseline-shift="30%" font-size="80%"> -->
								<xsl:choose>
									<xsl:when test="contains(., '[') and contains(., ']')">
										<fo:inline color="black" text-decoration="none">[</fo:inline>
										<xsl:value-of select="translate(.,'[]','')"/>
										<fo:inline color="black" text-decoration="none">]</fo:inline>
									</xsl:when>
									<xsl:otherwise>
										<xsl:apply-templates />
									</xsl:otherwise>
								</xsl:choose>
							<!-- </fo:inline> -->
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates />
						</xsl:otherwise>
					</xsl:choose>
				</fo:basic-link>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="mn:sup[mn:fmt-xref[@type = 'footnote']]" priority="2">
		<fo:inline font-size="80%">
			<xsl:choose>
				<xsl:when test="$layoutVersion = '2024'">
					<xsl:attribute name="baseline-shift">20%</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="vertical-align">super</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>
	
	<!-- =================== -->
	<!-- End of Index processing -->
	<!-- =================== -->

	<!-- add columns=1 for elements which should be rendered in <block span="all"> -->
	<xsl:template match="mn:annex/mn:fmt-title" mode="update_xml_step_move_pagebreak">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:if test="$layout_columns != 1">
				<xsl:attribute name="columns">1</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates mode="update_xml_step_move_pagebreak"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="mn:references[not(@normative='true')]/mn:fmt-title" mode="update_xml_step_move_pagebreak">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:if test="$layout_columns != 1">
				<xsl:attribute name="columns">1</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates mode="update_xml_step_move_pagebreak"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- 
	<xsl:template match="text()[contains(., $thin_space)]">
		<xsl:value-of select="translate(., $thin_space, ' ')"/>
	</xsl:template> -->
	
	
	<xsl:template name="insertHeaderFooter">
		<xsl:param name="font-weight" select="'bold'"/>
		<xsl:param name="is_footer">false</xsl:param>
		<xsl:param name="is_header">true</xsl:param>
		<xsl:param name="border_around_page">false</xsl:param>
		<xsl:param name="insert_header_first">true</xsl:param>
		<xsl:param name="insert_footer_last">true</xsl:param>
		<xsl:if test="($layoutVersion = '1972' or $layoutVersion = '1979' or $layoutVersion = '1987' or ($layoutVersion = '1989' and $revision_date_num &lt;= 19981231)) and $is_footer = 'true'">
			<xsl:call-template name="insertFooterFirst1972_1998">
				<xsl:with-param name="font-weight" select="$font-weight"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:call-template name="insertHeaderEven">
			<xsl:with-param name="border_around_page" select="$border_around_page"/>
			<xsl:with-param name="is_header" select="$is_header"/>
		</xsl:call-template>
		<xsl:call-template name="insertFooterEven">
			<xsl:with-param name="font-weight" select="$font-weight"/>
			<xsl:with-param name="insert_footer_last" select="$insert_footer_last"/>
		</xsl:call-template>
		<xsl:choose>
			<xsl:when test="$layoutVersion = '1951'"></xsl:when>
			<xsl:when test="not((($layoutVersion = '1987' and $doctype = 'technical-report') or ($layoutVersion = '1979' and $doctype = 'addendum'))) and $insert_header_first = 'true'">
				<xsl:call-template name="insertHeaderFirst"/>
			</xsl:when>
		</xsl:choose>
		<xsl:call-template name="insertHeaderOdd">
			<xsl:with-param name="border_around_page" select="$border_around_page"/>
			<xsl:with-param name="is_header" select="$is_header"/>
		</xsl:call-template>
		<xsl:call-template name="insertFooterOdd">
			<xsl:with-param name="font-weight" select="$font-weight"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:variable name="font-size_header">
		<xsl:choose>
			<xsl:when test="$layoutVersion = '1972' or $layoutVersion = '1979' or $layoutVersion = '1987' or $layoutVersion = '1989'">11pt</xsl:when>
			<xsl:otherwise>12pt</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:template name="insertHeaderEven">
		<xsl:param name="is_header">true</xsl:param>
		<xsl:param name="border_around_page">false</xsl:param>
		<fo:static-content flow-name="header-even" role="artifact">
			<xsl:if test="$layoutVersion = '1951' and $border_around_page = 'true'">
				<!-- box around page -->
				<fo:block-container position="absolute" left="16.5mm" top="15mm" height="270mm" width="170mm" border="1.25pt solid black" role="SKIP">					
					<fo:block>&#xa0;</fo:block>
				</fo:block-container>
			</xsl:if>
			<fo:block-container height="24mm" display-align="before">
				<xsl:if test="$layoutVersion = '2024'">
					<xsl:attribute name="height">23mm</xsl:attribute>
				</xsl:if>
				<xsl:choose>
					<xsl:when test="$layoutVersion = '1951'">
						<xsl:call-template name="insertHeader1951">
							<xsl:with-param name="is_header" select="$is_header"/>
							<xsl:with-param name="odd_or_even">even</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<fo:block font-size="{$font-size_header}" font-weight="bold" padding-top="12.5mm" line-height="1.1">
							<xsl:call-template name="insertLayoutVersionAttributesTop">
								<xsl:with-param name="odd_or_even">even</xsl:with-param>
							</xsl:call-template>
							<xsl:if test="$is_header = 'true'">
								<xsl:value-of select="$ISOnumber"/>
							</xsl:if>
						</fo:block>
					</xsl:otherwise>
				</xsl:choose>
			</fo:block-container>
		</fo:static-content>
	</xsl:template>
	<xsl:template name="insertHeaderFirst">
		<fo:static-content flow-name="header-first" role="artifact">
			<xsl:choose>
				<xsl:when test="$stage-abbreviation = 'FDAMD' or $stage-abbreviation = 'FDAM' or $stage-abbreviation = 'DAMD' or $stage-abbreviation = 'DAM'">
					<fo:block-container height="24mm" display-align="before">
						<xsl:if test="$layoutVersion = '2024'">
							<xsl:attribute name="height">23mm</xsl:attribute>
						</xsl:if>
						<fo:block font-size="{$font-size_header}" font-weight="bold" text-align="right" padding-top="12.5mm" line-height="1.1">
							<xsl:call-template name="insertLayoutVersionAttributesTop"/>
							<xsl:value-of select="$ISOnumber"/>
						</fo:block>
					</fo:block-container>
				</xsl:when>
				<xsl:otherwise>
					<fo:block-container margin-top="13mm" width="172mm" border-top="0.5mm solid black" border-bottom="0.5mm solid black" display-align="center" background-color="white">
						<xsl:if test="$layoutVersion = '1972' or $layoutVersion = '1979' or $layoutVersion = '1987' or $layoutVersion = '1989'">
							<xsl:attribute name="border-top">0.5mm solid black</xsl:attribute>
							<xsl:attribute name="border-bottom">0.5mm solid black</xsl:attribute>
						</xsl:if>
						<xsl:if test=" $layoutVersion = '2024'">
							<xsl:attribute name="width">180mm</xsl:attribute>
							<xsl:attribute name="border-top">0.8mm solid black</xsl:attribute>
							<xsl:attribute name="border-bottom">0.8mm solid black</xsl:attribute>
						</xsl:if>
						<!-- <fo:block text-align-last="justify" font-size="{$font-size_header}" font-weight="bold" line-height="1.1">
							<xsl:choose>
								<xsl:when test="$layoutVersion = '2024'">
									<xsl:choose>
										<xsl:when test="$doctype = 'committee-document'"><xsl:value-of select="$doctype_localized"/></xsl:when>
										<xsl:otherwise><xsl:value-of select="$stagename-header-firstpage"/></xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$stagename-header-firstpage-uppercased"/>
								</xsl:otherwise>
							</xsl:choose>
							<fo:inline keep-together.within-line="always">
								<fo:leader leader-pattern="space"/>
								<fo:inline><xsl:value-of select="$ISOnumber"/></fo:inline>
							</fo:inline>
						</fo:block> -->
						<fo:table table-layout="fixed" width="100%" font-size="{$font-size_header}" font-weight="bold" line-height="1.1">
							<fo:table-column column-width="50%"/>
							<fo:table-column column-width="50%"/>
							<fo:table-body>
								<fo:table-row display-align="center" height="9mm">
									<xsl:if test="$layoutVersion = '1972' or $layoutVersion = '1979'">
										<xsl:attribute name="height">11mm</xsl:attribute>
									</xsl:if>
									<xsl:if test="$layoutVersion = '2024'">
										<xsl:attribute name="height">8.5mm</xsl:attribute>
									</xsl:if>
									<fo:table-cell>
										<fo:block>
											<xsl:choose>
												<xsl:when test="$layoutVersion = '2024'">
													<xsl:choose>
														<xsl:when test="$doctype = 'committee-document'"><xsl:value-of select="$doctype_localized"/></xsl:when>
														<xsl:when test="normalize-space($stagename_localized_firstpage) != ''"><xsl:apply-templates select="xalan:nodeset($stagename_localized_firstpage)/node()"/></xsl:when>
														<xsl:otherwise><xsl:value-of select="$stagename-header-firstpage"/></xsl:otherwise>
													</xsl:choose>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="$stagename-header-firstpage-uppercased"/>
												</xsl:otherwise>
											</xsl:choose>
										</fo:block>
									</fo:table-cell>
									<fo:table-cell text-align="right"> <!-- padding-top="2mm" padding-bottom="2mm" -->
										<xsl:if test="contains($ISOnumber, $linebreak)">
											<xsl:attribute name="padding-top">2mm</xsl:attribute>
											<xsl:attribute name="padding-bottom">2mm</xsl:attribute>
										</xsl:if>
										<fo:block><xsl:value-of select="$ISOnumber"/></fo:block>
									</fo:table-cell>
								</fo:table-row>
							</fo:table-body>
						</fo:table>
					</fo:block-container>
				</xsl:otherwise>
			</xsl:choose>
		</fo:static-content>
	</xsl:template>
	<xsl:template name="insertHeaderOdd">
		<xsl:param name="is_header">true</xsl:param>
		<xsl:param name="border_around_page">false</xsl:param>
		<fo:static-content flow-name="header-odd" role="artifact">
			<xsl:if test="$layoutVersion = '1951' and $border_around_page = 'true'">
				<!-- box around page -->
				<fo:block-container position="absolute" left="23.5mm" top="15mm" height="270mm" width="170mm" border="1.25pt solid black" role="SKIP">
					<fo:block>&#xa0;</fo:block>
				</fo:block-container>
			</xsl:if>
			<fo:block-container height="24mm" display-align="before">
				<xsl:if test="$layoutVersion = '2024'">
					<xsl:attribute name="height">23mm</xsl:attribute>
				</xsl:if>
				<xsl:choose>
					<xsl:when test="$layoutVersion = '1951'">
						<xsl:call-template name="insertHeader1951">
							<xsl:with-param name="is_header" select="$is_header"/>
							<xsl:with-param name="odd_or_even">odd</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<fo:block font-size="{$font-size_header}" font-weight="bold" text-align="right" padding-top="12.5mm" line-height="1.1">
							<xsl:call-template name="insertLayoutVersionAttributesTop">
								<xsl:with-param name="odd_or_even">odd</xsl:with-param>
							</xsl:call-template>
							<xsl:if test="$is_header = 'true'">
								<xsl:value-of select="$ISOnumber"/>
							</xsl:if>
						</fo:block>
					</xsl:otherwise>
				</xsl:choose>
			</fo:block-container>
		</fo:static-content>
	</xsl:template>
	
	<xsl:template name="insertHeader1951">
		<xsl:param name="is_header"/>
		<xsl:param name="odd_or_even"/>
		<fo:block-container font-size="{$font-size_header}" font-weight="bold" text-align="right" padding-top="12.5mm" line-height="1.1">
			<xsl:call-template name="insertLayoutVersionAttributesTop">
				<xsl:with-param name="odd_or_even" select="$odd_or_even"/>
			</xsl:call-template>
			<fo:block-container margin-left="0mm" margin-right="0mm">
				<fo:table table-layout="fixed" width="100%">
					<fo:table-column column-width="proportional-column-width(1)"/>
					<fo:table-column column-width="proportional-column-width(1)"/>
					<fo:table-column column-width="proportional-column-width(1)"/>
					<fo:table-body>
						<fo:table-row>
							<fo:table-cell>
								<fo:block>&#xa0;</fo:block>
							</fo:table-cell>
							<fo:table-cell padding-top="-0.5mm">
								<fo:block font-size="9.5pt" font-weight="normal" text-align="center">
									<xsl:if test="$revision_date_num &gt;= 19690101">
										<xsl:value-of select="$en_dash"/>&#xa0;&#xa0;<fo:page-number/>&#xa0;&#xa0;<xsl:value-of select="$en_dash"/>
									</xsl:if>
								</fo:block>
							</fo:table-cell>
							<fo:table-cell>
								<fo:block>
									<xsl:if test="$is_header = 'true'">
										<xsl:value-of select="$ISOnumber"/>
									</xsl:if>
								</fo:block>
							</fo:table-cell>
						</fo:table-row>
					</fo:table-body>
				</fo:table>
			</fo:block-container>
		</fo:block-container>
	</xsl:template>
	
	<xsl:variable name="font-size_footer_copyright">
		<xsl:choose>
			<xsl:when test="$layoutVersion = '1972' or $layoutVersion = '1979' or $layoutVersion = '1987' or $layoutVersion = '1989'">8pt</xsl:when>
			<xsl:otherwise>9pt</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:template name="insertFooterFirst1972_1998">
		<xsl:param name="font-weight" select="'bold'"/>
		<fo:static-content flow-name="footer-preface-first_1972-1998" role="artifact">
			<fo:block-container display-align="after" height="86mm">
				
				<fo:block line-height="90%" role="SKIP" margin-bottom="9mm">
					<xsl:if test="$layoutVersion = '1972' or $layoutVersion = '1979' or $layoutVersion = '1987'">
						<xsl:attribute name="margin-bottom">5mm</xsl:attribute>
					</xsl:if>
					<fo:block font-size="8pt" text-align="justify" role="SKIP">
						<xsl:apply-templates select="/mn:metanorma/mn:boilerplate/mn:copyright-statement"/>
					</fo:block>
				</fo:block>
			
				<fo:table table-layout="fixed" width="100%">
					<fo:table-column column-width="33%"/>
					<fo:table-column column-width="33%"/>
					<fo:table-column column-width="34%"/>
					<fo:table-body>
						<fo:table-row>
							<fo:table-cell display-align="center" padding-top="0mm" font-size="11pt" font-weight="{$font-weight}">
								<xsl:if test="contains($copyrightText, 'IEEE')">
									<xsl:attribute name="display-align">before</xsl:attribute>
								</xsl:if>
								<fo:block><fo:page-number/></fo:block>
							</fo:table-cell>
							<fo:table-cell display-align="center">
								<fo:block font-size="10pt" font-weight="bold" text-align="center">
									<xsl:if test="$stage-abbreviation = 'PRF'">
										<xsl:value-of select="$proof-text"/>
									</xsl:if>
								</fo:block>
							</fo:table-cell>
							<fo:table-cell display-align="center" padding-top="0mm" font-size="{$font-size_footer_copyright}">
								<fo:block text-align="right"></fo:block>
							</fo:table-cell>
						</fo:table-row>
					</fo:table-body>
				</fo:table>
			</fo:block-container>
		</fo:static-content>
	</xsl:template>
	<xsl:template name="insertFooterEven">
		<xsl:param name="font-weight" select="'bold'"/>
		<xsl:param name="insert_footer_last">true</xsl:param>
		<fo:static-content flow-name="footer-even" role="artifact">
			<fo:block-container>
				<xsl:choose>
					<xsl:when test="$layoutVersion = '1951'">
						<xsl:call-template name="insertFooter1951"/>
					</xsl:when>
					<xsl:when test="$layoutVersion = '2024'">
						<xsl:call-template name="insertFooter2024">
							<xsl:with-param name="font-weight" select="$font-weight"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<fo:table table-layout="fixed" width="100%">
							<fo:table-column column-width="33%"/>
							<fo:table-column column-width="33%"/>
							<fo:table-column column-width="34%"/>
							<fo:table-body>
								<fo:table-row>
									<fo:table-cell display-align="center" padding-top="0mm" font-size="11pt" font-weight="{$font-weight}">
										<xsl:if test="contains($copyrightText, 'IEEE')">
											<xsl:attribute name="display-align">before</xsl:attribute>
										</xsl:if>
										<fo:block><fo:page-number/></fo:block>
									</fo:table-cell>
									<fo:table-cell display-align="center">
										<fo:block font-size="10pt" font-weight="bold" text-align="center">
											<xsl:if test="$stage-abbreviation = 'PRF'">
												<xsl:value-of select="$proof-text"/>
											</xsl:if>
										</fo:block>
									</fo:table-cell>
									<fo:table-cell display-align="center" padding-top="0mm" font-size="{$font-size_footer_copyright}">
										<fo:block text-align="right">
											<xsl:choose>
												<xsl:when test="$layoutVersion = '1972' or $layoutVersion = '1979' or $layoutVersion = '1987' or ($layoutVersion = '1989' and $revision_date_num &lt;= 19981231)"></xsl:when>
												<xsl:otherwise><xsl:value-of select="$copyrightText"/></xsl:otherwise>
											</xsl:choose>
										</fo:block>
									</fo:table-cell>
								</fo:table-row>
							</fo:table-body>
						</fo:table>
					</xsl:otherwise>
				</xsl:choose>
			</fo:block-container>
		</fo:static-content>
		<!-- for layout 1951 only -->
		<xsl:if test="$layoutVersion = '1951'">
			<fo:static-content flow-name="footer-even-last" role="artifact">
				<fo:block-container>
					<xsl:call-template name="insertFooter1951">
						<xsl:with-param name="insert_footer_last" select="$insert_footer_last"/>
					</xsl:call-template>
				</fo:block-container>
			</fo:static-content>
		</xsl:if>
	</xsl:template>
	<xsl:template name="insertFooterOdd">
		<xsl:param name="font-weight" select="'bold'"/>
		<fo:static-content flow-name="footer-odd" role="artifact">
			<fo:block-container>
				<xsl:choose>
					<xsl:when test="$layoutVersion = '1951'">
						<xsl:call-template name="insertFooter1951"/>
					</xsl:when>
					<xsl:when test="$layoutVersion = '2024'">
						<xsl:call-template name="insertFooter2024">
							<xsl:with-param name="font-weight" select="$font-weight"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<fo:table table-layout="fixed" width="100%">
							<fo:table-column column-width="33%"/>
							<fo:table-column column-width="33%"/>
							<fo:table-column column-width="34%"/>
							<fo:table-body>
								<fo:table-row>
									<fo:table-cell display-align="center" padding-top="0mm" font-size="{$font-size_footer_copyright}">
										<fo:block>
											<xsl:choose>
												<xsl:when test="$layoutVersion = '1972' or $layoutVersion = '1979' or $layoutVersion = '1987' or ($layoutVersion = '1989' and $revision_date_num &lt;= 19981231)"></xsl:when>
												<xsl:otherwise><xsl:value-of select="$copyrightText"/></xsl:otherwise>
											</xsl:choose>
										</fo:block>
									</fo:table-cell>
									<fo:table-cell display-align="center">
										<fo:block font-size="10pt" font-weight="bold" text-align="center">
											<xsl:if test="$stage-abbreviation = 'PRF'">
												<xsl:value-of select="$proof-text"/>
											</xsl:if>
										</fo:block>
									</fo:table-cell>
									<fo:table-cell display-align="center" padding-top="0mm" font-size="11pt" font-weight="{$font-weight}">
										<xsl:if test="contains($copyrightText, 'IEEE')">
											<xsl:attribute name="display-align">before</xsl:attribute>
										</xsl:if>
										<fo:block text-align="right"><fo:page-number/></fo:block>
									</fo:table-cell>
								</fo:table-row>
							</fo:table-body>
						</fo:table>
					</xsl:otherwise>
				</xsl:choose>
			</fo:block-container>
		</fo:static-content>
	</xsl:template>
	<xsl:template name="insertFooter1951">
		<xsl:param name="insert_footer_last">false</xsl:param>
		<xsl:attribute name="height"><xsl:value-of select="$marginBottom - 2"/>mm</xsl:attribute>
		<xsl:attribute name="display-align">after</xsl:attribute>
		<xsl:attribute name="text-align">center</xsl:attribute>
		<fo:block-container margin-left="-13mm" margin-right="-13mm">
			<fo:block-container margin-left="0mm" margin-right="0mm">
				<fo:table table-layout="fixed" width="100%" margin-bottom="5mm">
					<fo:table-column column-width="proportional-column-width(35)"/>
					<fo:table-column column-width="proportional-column-width(100)"/>
					<fo:table-column column-width="proportional-column-width(35)"/>
					<fo:table-body>
						<fo:table-row>
							<fo:table-cell font-size="8pt">
								<fo:block line-height="1" margin-top="2mm">
									<!-- <xsl:variable name="date_first_printing" select="normalize-space(/mn:metanorma/mn:metanorma-extension/mn:presentation-metadata/mn:first-printing-date)"/> -->
									<xsl:variable name="number_printing" select="normalize-space(/mn:metanorma/mn:metanorma-extension/mn:presentation-metadata[mn:printing-date][1]/mn:printing-date)"/>
									<xsl:variable name="date_printing" select="normalize-space(/mn:metanorma/mn:metanorma-extension/mn:presentation-metadata[mn:printing-date][last()]/mn:printing-date)"/>
									<xsl:if test="$insert_footer_last = 'true' and $date_printing != ''">
										<xsl:variable name="date_number_printing">
											<xsl:choose>
												<xsl:when test="$number_printing != $date_printing">
													<!-- <xsl:value-of select="java:replaceAll(java:java.lang.String.new($i18n_date_printing), '%', $number_printing)"/> -->
													<xsl:value-of select="/mn:metanorma/mn:bibdata/mn:ext/mn:date-printing"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="$i18n_date_first_printing"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:variable>
										<fo:block><xsl:value-of select="$date_number_printing"/>:</fo:block>
										<fo:block>
											<!-- Example: December 1965 -->
											<xsl:call-template name="convertDate">
												<xsl:with-param name="date" select="$date_printing"/>
											</xsl:call-template>
										</fo:block>
									</xsl:if>
								</fo:block>
							</fo:table-cell>
							<fo:table-cell>
								<fo:block font-size="9.5pt" font-weight="bold">
									<xsl:if test="$revision_date_num &lt; 19690101">
										<xsl:value-of select="$em_dash"/>&#xa0;&#xa0;<fo:page-number/>&#xa0;&#xa0;<xsl:value-of select="$em_dash"/>
									</xsl:if>
								</fo:block>
							</fo:table-cell>
							<fo:table-cell>
								<fo:block font-size="8.5pt" text-align="right" font-weight="bold">
									<xsl:variable name="price_" select="normalize-space(/mn:metanorma/mn:metanorma-extension/mn:presentation-metadata/mn:price)"/>
									<xsl:variable name="price" select="java:replaceAll(java:java.lang.String.new($price_), '-{2}', $em_dash)"/>
									<xsl:if test="$insert_footer_last = 'true'">
									
										<xsl:choose>
											<xsl:when test="$price != ''">
												<!-- Example: Price: Sw. fr. 3.- -->
												<xsl:value-of select="concat($i18n_price, ': ', $price)"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="font-size">7pt</xsl:attribute>
												<xsl:attribute name="font-weight">normal</xsl:attribute>
												<xsl:call-template name="insertPriceBasedOn"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:if>
								</fo:block>
							</fo:table-cell>
						</fo:table-row>
					</fo:table-body>
				</fo:table>
			</fo:block-container>
		</fo:block-container>
	</xsl:template><!-- END: insertFooter1951 -->
	<xsl:template name="insertFooter2024">
		<xsl:param name="font-weight" select="'bold'"/>
		<xsl:attribute name="text-align">center</xsl:attribute>
		<xsl:attribute name="line-height">1.1</xsl:attribute>
		<xsl:if test="$stage-abbreviation = 'PRF'">
			<fo:block font-size="10pt" font-weight="bold" text-align="center">
				<xsl:value-of select="$proof-text"/>
			</fo:block>
		</xsl:if>
		<fo:block font-size="9pt">
			<!-- <xsl:call-template name="insertInterFont"/> -->
			<xsl:value-of select="$copyrightText"/>
		</fo:block>
		<xsl:if test="$copyrightAbbrIEEE = '' and $stage-abbreviation != 'PRF'"><fo:block>&#xa0;</fo:block></xsl:if>
		<fo:block font-size="11pt" font-weight="{$font-weight}">
			<xsl:if test="$stage-abbreviation = 'PRF'">
				<xsl:attribute name="margin-top">1mm</xsl:attribute>
			</xsl:if>
			<fo:page-number/>
		</fo:block>
	</xsl:template>
	<xsl:template name="insertLayoutVersionAttributesTop">
		<xsl:param name="odd_or_even"/>
		<xsl:if test="$layoutVersion = '1951'">
			<xsl:attribute name="font-family">Arial</xsl:attribute>
			<xsl:attribute name="font-size">8pt</xsl:attribute>
			<xsl:attribute name="text-align">right</xsl:attribute>
			<xsl:attribute name="padding-top">8mm</xsl:attribute>
			<xsl:if test="$revision_date_num &gt;= 19690101">
				<xsl:attribute name="padding-top">11mm</xsl:attribute>
				<xsl:attribute name="font-family">Times New Roman</xsl:attribute>
			</xsl:if>
			<xsl:if test="$odd_or_even = 'odd'">
				<xsl:attribute name="margin-right">16.5mm</xsl:attribute>
				<xsl:if test="$revision_date_num &gt;= 19690101">
					<xsl:attribute name="margin-left">23.5mm</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$odd_or_even = 'even'">
				<xsl:attribute name="margin-right">23.5mm</xsl:attribute>
				<xsl:if test="$revision_date_num &gt;= 19690101">
					<xsl:attribute name="margin-left">16.5mm</xsl:attribute>
				</xsl:if>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$layoutVersion = '2024'">
			<!-- <xsl:attribute name="font-size">11.5pt</xsl:attribute> -->
			<xsl:attribute name="padding-top">12.2mm</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
		</xsl:if>
	</xsl:template>
	
	
	<xsl:variable name="price_based_on_items">
		<xsl:call-template name="split">
			<xsl:with-param name="pText" select="$i18n_price_based_on"/>
			<xsl:with-param name="sep" select="'%'"/>
			<xsl:with-param name="normalize-space">false</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:template name="insertPriceBasedOn">
		<xsl:for-each select="xalan:nodeset($price_based_on_items)/mnx:item">
			<xsl:value-of select="."/>
			<xsl:if test="position() != last()">
				<fo:page-number-citation ref-id="lastBlock"/>
			</xsl:if>										
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template name="back-page">
		<xsl:choose>
			<xsl:when test="$isGenerateTableIF = 'true'"><!-- skip last page --></xsl:when>
			<xsl:when test="$layoutVersion = '1951'"/>
			<xsl:when test="$layoutVersion = '1972'"/>
			<xsl:when test="$layoutVersion = '1979'"/>
			<xsl:when test="(($layoutVersion = '1987' and $doctype = 'technical-report') or ($layoutVersion = '1979' and $doctype = 'addendum'))"><!-- UDC, Keywords and Price renders on the first page for technical-report --></xsl:when>
			<xsl:when test="$layoutVersion = '2024'">
				<xsl:call-template name="insertLastPage_2024"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$isPublished = 'true'">
				<xsl:call-template name="insertLastPage"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="insertLastPage">
		<fo:page-sequence master-reference="back-page" force-page-count="no-force">
			<xsl:call-template name="insertHeaderEven"/>
			<fo:static-content flow-name="back-page-footer" font-size="10pt">
				<fo:table table-layout="fixed" width="100%">
					<fo:table-column column-width="33%"/>
					<fo:table-column column-width="33%"/>
					<fo:table-column column-width="34%"/>
					<fo:table-body>
						<fo:table-row>
							<fo:table-cell display-align="center">
								<fo:block font-size="{$font-size_footer_copyright}">
									<xsl:choose>
										<xsl:when test="$layoutVersion = '1972' or $layoutVersion = '1979' or $layoutVersion = '1987' or ($layoutVersion = '1989' and $revision_date_num &lt;= 19981231)"></xsl:when>
										<xsl:otherwise><xsl:value-of select="$copyrightText"/></xsl:otherwise>
									</xsl:choose>
								</fo:block>
							</fo:table-cell>
							<fo:table-cell>
								<fo:block font-size="10pt" font-weight="bold" text-align="center">
									<xsl:if test="$stage-abbreviation = 'PRF'">
										<xsl:value-of select="$proof-text"/>
									</xsl:if>
								</fo:block>
							</fo:table-cell>
							<fo:table-cell>
								<fo:block>&#xA0;</fo:block>
							</fo:table-cell>
						</fo:table-row>
					</fo:table-body>
				</fo:table>
			</fo:static-content>
			<fo:flow flow-name="xsl-region-body">
				<fo:block-container height="252mm" display-align="after">
					<xsl:if test="/mn:metanorma/mn:boilerplate/mn:feedback-statement">
						<fo:block font-size="16pt" margin-bottom="3mm" margin-right="5mm">
							<xsl:apply-templates select="/mn:metanorma/mn:boilerplate/mn:feedback-statement"/>
						</fo:block>
					</xsl:if>
					<xsl:choose>
						<xsl:when test="$layoutVersion = '1972' or $layoutVersion = '1979' or $layoutVersion = '1987'">
							<xsl:call-template name="insertSingleLine"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="insertTripleLine"/>
						</xsl:otherwise>
					</xsl:choose>
					<fo:block-container>
						<fo:block font-size="12pt" font-weight="bold" padding-top="3.5mm" padding-bottom="0.5mm">
							<xsl:if test="$layoutVersion = '1972' or $layoutVersion = '1979' or $layoutVersion = '1987'">
								<xsl:attribute name="font-size">11pt</xsl:attribute>
								<xsl:attribute name="padding-top">1mm</xsl:attribute>
								<xsl:attribute name="padding-bottom">1mm</xsl:attribute>
							</xsl:if>
							<xsl:if test="$layoutVersion = '1989'">
								<xsl:attribute name="font-size">11pt</xsl:attribute>
								<xsl:attribute name="padding-top">5.5mm</xsl:attribute>
								<xsl:attribute name="padding-bottom">1mm</xsl:attribute>
								<xsl:if test="$revision_date_num &lt;= 19981231">
									<xsl:attribute name="padding-top">2mm</xsl:attribute>
									<xsl:attribute name="padding-bottom">2mm</xsl:attribute>
								</xsl:if>
							</xsl:if>
							<xsl:if test="$layoutVersion = '1972' or $layoutVersion = '1979' or $layoutVersion = '1987' or ($layoutVersion = '1989' and $revision_date_num &lt;= 19981231)">
								<fo:block margin-bottom="6pt">
									<xsl:value-of select="$udc"/>
								</fo:block>
							</xsl:if>
							<xsl:for-each select="/mn:metanorma/mn:bibdata/mn:ext/mn:ics/mn:code">
								<xsl:if test="position() = 1"><fo:inline>ICS&#xA0;&#xA0;</fo:inline></xsl:if>
								<xsl:value-of select="."/>
								<xsl:if test="position() != last()">
									<xsl:choose>
										<xsl:when test="$layoutVersion = '1972' or $layoutVersion = '1979' or $layoutVersion = '1987' or $layoutVersion = '1989'"><xsl:text>: </xsl:text></xsl:when>
										<xsl:otherwise><xsl:text>; </xsl:text></xsl:otherwise>
									</xsl:choose>
								</xsl:if>
							</xsl:for-each>&#xA0;
							<!-- <xsl:choose>
								<xsl:when test="$stage-name = 'FDIS'">ICS&#xA0;&#xA0;01.140.30</xsl:when>
								<xsl:when test="$stage-name = 'PRF'">ICS&#xA0;&#xA0;35.240.63</xsl:when>
								<xsl:when test="$stage-name = 'published'">ICS&#xA0;&#xA0;35.240.30</xsl:when>
								<xsl:otherwise>ICS&#xA0;&#xA0;67.060</xsl:otherwise>
							</xsl:choose> -->
						</fo:block>
						<xsl:if test="/mn:metanorma/mn:bibdata/mn:keyword">
							<fo:block font-size="{$font-size_footer_copyright}" margin-bottom="6pt">
								<fo:inline font-weight="bold"><xsl:value-of select="$i18n_descriptors"/>: </fo:inline>
								<xsl:call-template name="insertKeywords">
									<xsl:with-param name="sorting">no</xsl:with-param>
								</xsl:call-template>
							</fo:block>
						</xsl:if>
						<!-- Price based on ... pages -->
						<fo:block font-size="{$font-size_footer_copyright}">
							<xsl:call-template name="insertPriceBasedOn"/>
						</fo:block>
						<xsl:if test="$layoutVersion = '1989' and $revision_date_num &gt;= 19990101">
							<fo:block>&#xa0;</fo:block>
						</xsl:if>
					</fo:block-container>
					<xsl:choose>
						<xsl:when test="$layoutVersion = '1972' or $layoutVersion = '1979' or $layoutVersion = '1987'">
							<xsl:call-template name="insertSingleLine"/>
						</xsl:when>
						<xsl:when test="$layoutVersion = '1989' and $revision_date_num &lt;= 19981231">
							<xsl:call-template name="insertTripleLine"/>
						</xsl:when>
					</xsl:choose>
				</fo:block-container>
			</fo:flow>
		</fo:page-sequence>
	</xsl:template> <!-- END: insertLastPage -->
	
	<xsl:template name="insertLastPage_2024">
		<fo:page-sequence master-reference="back-page_2024" force-page-count="no-force">
			<fo:flow flow-name="xsl-region-body">
				<xsl:variable name="fo_last_page">
				<fo:table table-layout="fixed" width="100%" margin-bottom="-1mm">
					<xsl:call-template name="insertInterFont"/>
					<fo:table-column column-width="proportional-column-width(73)"/>
					<fo:table-column column-width="proportional-column-width(1.45)"/>
					<fo:table-column column-width="proportional-column-width(1.45)"/>
					<fo:table-column column-width="proportional-column-width(114.3)"/>
					<fo:table-body>
						<fo:table-row height="91.8mm">
							<fo:table-cell number-columns-spanned="2" border-right="{$cover_page_border}">
								<fo:block>
									<xsl:call-template name="insertLogoImages2024"/>
								</fo:block>
							</fo:table-cell>
							<fo:table-cell number-columns-spanned="2"><fo:block role="SKIP"><fo:wrapper role="artifact">&#xA0;</fo:wrapper></fo:block></fo:table-cell>
						</fo:table-row>
						<fo:table-row height="1.4mm" font-size="0pt">
							<fo:table-cell border-bottom="{$cover_page_border}"><fo:block role="SKIP"><fo:wrapper role="artifact">&#xA0;</fo:wrapper></fo:block></fo:table-cell>
							<fo:table-cell number-columns-spanned="2"><fo:block role="SKIP"><fo:wrapper role="artifact">&#xA0;</fo:wrapper></fo:block></fo:table-cell>
							<fo:table-cell border-bottom="{$cover_page_border}"><fo:block role="SKIP"><fo:wrapper role="artifact">&#xA0;</fo:wrapper></fo:block></fo:table-cell>
						</fo:table-row>
						<fo:table-row height="2mm" font-size="0pt">
							<fo:table-cell number-columns-spanned="4"><fo:block role="SKIP"><fo:wrapper role="artifact">&#xA0;</fo:wrapper></fo:block></fo:table-cell>
						</fo:table-row>
						<fo:table-row height="182mm"> <!-- 174 -->
							<fo:table-cell number-columns-spanned="2" display-align="after" border-right="{$cover_page_border}">
								<fo:block font-size="12pt" font-weight="bold">
									<xsl:for-each select="/mn:metanorma/mn:bibdata/mn:ext/mn:ics/mn:code">
										<xsl:if test="position() = 1"><fo:inline>ICS&#xA0;&#xA0;</fo:inline></xsl:if>
										<xsl:value-of select="."/>
										<xsl:if test="position() != last()"><xsl:text>; </xsl:text></xsl:if>
									</xsl:for-each>&#xA0;
								</fo:block>
								
								<!-- Price based on ... pages -->
								<fo:block font-size="9pt" space-before="2pt">
									<fo:block>
										<xsl:call-template name="insertPriceBasedOn"/>
									</fo:block>
									<fo:block margin-top="18pt" margin-bottom="-1mm" line-height="1.1"><xsl:value-of select="$copyrightTextLastPage2024"/></fo:block>
								</fo:block>
							</fo:table-cell>
							<fo:table-cell number-columns-spanned="2" display-align="after">
								<xsl:choose>
									<xsl:when test="/mn:metanorma/mn:boilerplate/mn:feedback-statement">
										<fo:block font-size="16pt" margin-bottom="1mm" margin-right="1.5mm">
											<xsl:apply-templates select="/mn:metanorma/mn:boilerplate/mn:feedback-statement"/>
										</fo:block>
									</xsl:when>
									<xsl:otherwise>
										<xsl:attribute name="text-align">right</xsl:attribute>
										<fo:block font-size="16pt" font-weight="bold" margin-bottom="1mm" margin-right="1.5mm">
											<xsl:if test="$stage &gt;=60 and $substage != 0">
												<xsl:attribute name="color"><xsl:value-of select="$color_red"/></xsl:attribute>
											</xsl:if>
											<xsl:text>iso.org</xsl:text>
										</fo:block>
									</xsl:otherwise>
								</xsl:choose>
							</fo:table-cell>
						</fo:table-row>
					</fo:table-body>
				</fo:table>
				</xsl:variable>
				<xsl:apply-templates select="xalan:nodeset($fo_last_page)" mode="set_table_role_skip"/>
			</fo:flow>
		</fo:page-sequence>
	</xsl:template> <!-- END: insertLastPage_2024 -->
	
	<xsl:template name="insertSingleLine">
		<fo:block font-size="1.25pt" role="SKIP">
			<fo:block role="SKIP"><fo:leader leader-pattern="rule" rule-thickness="1.25pt" leader-length="100%"/></fo:block>
		</fo:block>
	</xsl:template>
			
	<xsl:template name="insertTripleLine">
		<fo:block font-size="1.25pt" role="SKIP">
			<fo:block role="SKIP"><fo:leader leader-pattern="rule" rule-thickness="0.75pt" leader-length="100%"/></fo:block>
			<fo:block role="SKIP"><fo:leader leader-pattern="rule" rule-thickness="0.75pt" leader-length="100%"/></fo:block>
			<fo:block role="SKIP"><fo:leader leader-pattern="rule" rule-thickness="0.75pt" leader-length="100%"/></fo:block>
		</fo:block>
	</xsl:template>

	<xsl:variable name="Image-ISO-Logo">
		<xsl:text>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</xsl:text>
	</xsl:variable>
	
	<xsl:variable name="Image-ISO-Logo-1987">
		<xsl:text>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</xsl:text>
	</xsl:variable>
	
	<xsl:variable name="Image-ISO-Logo-SVG">
		<xsl:variable name="logo_color">
			<xsl:choose>
				<xsl:when test="$stage &gt;=60 and $substage != 0"><xsl:value-of select="$color_red"/></xsl:when>
				<xsl:otherwise>rgb(88,88,90)</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<svg id="Layer_1" data-name="Layer 1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 54.9 54.9">
			<defs>
				<style>
					.cls-1 {
						fill: <xsl:value-of select="$logo_color"/>; <!-- #ed1c24 -->
					}
					.cls-1, .cls-2, .cls-3 {
						stroke-width: 0px;
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
					<rect class="cls-2" width="54.9" height="54.9"/>
				</clipPath>
			</defs>
			<rect class="cls-1" width="54.9" height="54.9"/>
			<g class="cls-4">
				<path class="cls-3" d="m42.26,37.75c-.88,1.26-1.92,2.4-3.09,3.4-1.79-.5-3.82-.88-5.96-1.12.24-.72.46-1.48.65-2.28h-1.18c-.2.77-.41,1.49-.65,2.16-1.52-.14-3.1-.21-4.68-.21s-3.01.06-4.45.18c-.23-.66-.44-1.37-.64-2.13h-1.18c.19.78.41,1.53.64,2.24-2.15.23-4.18.61-6.01,1.11-1.14-.98-2.16-2.11-3.03-3.35h-1.39c3.42,5.34,9.39,8.88,16.17,8.88s12.76-3.54,16.18-8.88h-1.39Zm-25.38,4.25c1.61-.39,3.4-.69,5.27-.89.71,1.81,1.63,3.29,2.55,4.23-2.85-.46-5.58-1.69-7.82-3.34m10.6,3.57c-1.45,0-2.95-1.71-4.13-4.56,1.31-.1,2.66-.16,4.01-.16,1.44,0,2.86.06,4.24.18-1.18,2.84-2.68,4.54-4.12,4.54m2.77-.23c.91-.93,1.84-2.41,2.54-4.2,1.86.2,3.62.51,5.22.91-2.23,1.62-4.93,2.84-7.76,3.3"/>
				<path class="cls-3" d="m27.47,8.27c-6.78,0-12.75,3.54-16.18,8.88h1.39c.88-1.26,1.92-2.4,3.09-3.4,1.79.5,3.82.88,5.97,1.13-.24.72-.46,1.48-.65,2.27h1.18c.2-.77.41-1.49.65-2.15,1.52.14,3.09.21,4.68.21s3.01-.06,4.45-.19c.23.66.44,1.37.64,2.13h1.18c-.19-.78-.41-1.53-.64-2.24,2.15-.24,4.18-.61,6.01-1.11,1.14.98,2.16,2.11,3.03,3.35h1.39c-3.42-5.34-9.39-8.88-16.18-8.88m-5.31,5.5c-1.86-.2-3.62-.51-5.22-.9,2.23-1.63,4.93-2.84,7.76-3.3-.91.93-1.84,2.41-2.54,4.2m5.43.29c-1.44,0-2.86-.06-4.24-.18,1.18-2.84,2.68-4.54,4.12-4.54s2.95,1.71,4.13,4.56c-1.31.1-2.66.16-4.01.16m5.2-.27c-.71-1.81-1.63-3.29-2.55-4.23,2.85.46,5.58,1.7,7.82,3.34-1.61.39-3.4.69-5.27.88"/>
				<path class="cls-3" d="m23.78,32.46c2.08,0,2.93-.47,2.93-1.32,0-2.75-10.6.45-10.6-6.91,0-3.74,3.17-5.43,7.79-5.43,1.12,0,2.24.12,3.72.29h4.01v5h-4.01v-1.06c-.59-.31-1.99-.65-3.44-.65-1.87,0-2.6.55-2.6,1.26,0,2.93,10.7-.43,10.7,6.89,0,3.03-2.03,5.51-8.1,5.51-1.12,0-2.46-.12-3.94-.3h-4.01v-5h4.01v1.06c.59.31,1.97.65,3.54.65"/>
				<polygon class="cls-3" points="4.3 31.65 7 31.65 7 23.26 4.3 23.26 4.3 19.13 15.03 19.13 15.03 23.26 12.33 23.26 12.33 31.65 15.03 31.65 15.03 35.78 4.3 35.78 4.3 31.65"/>
				<path class="cls-3" d="m42.1,18.8c-5.31,0-9.11,3.09-9.11,8.62s3.8,8.62,9.11,8.62,9.11-3.09,9.11-8.62-3.8-8.62-9.11-8.62m-.05,13.32c-2.1,0-3.43-1.34-3.43-4.7s1.33-4.7,3.43-4.7,3.43,1.34,3.43,4.7-1.33,4.7-3.43,4.7"/>
			</g>
		</svg>
	</xsl:variable>
	
	<xsl:variable name="Image-ISO-Logo-1951-SVG">
		<svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
				 viewBox="0 0 409.26 159.54" style="enable-background:new 0 0 409.26 159.54;" xml:space="preserve">
			<style type="text/css">
				.st0{fill:#FFFFFF;}
			</style>
			<g>
				<g>
					<path class="st0" d="M425.02,177.02c-144.63,0-289.26,0-434,0c0-59.94,0-119.89,0-180c144.59,0,289.3,0,434,0
						C425.02,56.94,425.02,116.97,425.02,177.02z M281.66,80.31c-0.16,0-0.31,0-0.47,0c0,8.67-0.42,17.37,0.12,26.01
						c0.49,7.9,0.93,16.09,3.34,23.52c3.56,10.92,11.18,17.83,22.67,22.28c16.03,6.21,32.21,6.25,48.59,5.63
						c7.95-0.3,16.23-1.86,23.64-4.71c18.19-7,26.11-21.99,27.4-40.54c0.86-12.35,0.62-24.81,0.27-37.2
						c-0.35-12.57-0.67-25.23-2.52-37.62c-0.97-6.51-4.31-13.16-8.17-18.63C389.53,9.1,378.28,5.68,366.91,3.9
						c-18.61-2.91-37.33-3.25-55.64,2.05c-8.98,2.6-16.23,8.11-21.66,15.88c-5.35,7.67-7.04,16.65-7.75,25.51
						C281,58.27,281.66,69.32,281.66,80.31z M193.27,8.97c-2.33-1.09-3.47-1.65-4.62-2.17c-3.84-1.74-7.57-4.55-11.56-5
						c-12.99-1.46-25.92-2.79-38.67,2.99c-13.27,6.01-19.18,16.86-21.36,29.98c-1.43,8.58-1.81,17.73,2.05,25.98
						c2.37,5.07,4.97,10.91,9.21,14.04c10.92,8.05,22.82,14.75,34.3,22.03c6.74,4.28,13.67,8.33,20.04,13.12
						c3.39,2.55,2.32,8.35-1.09,10.14c-6.02,3.16-16.82,0.39-19.99-5.84c-2.23-4.37-3.72-9.33-4.47-14.18
						c-0.53-3.46-1.83-3.99-4.77-3.95c-7.8,0.11-15.6-0.02-23.4-0.04c-3.94-0.01-7.88,0-11.86,0c0,19.96,0,39.33,0,58.63
						c3.58,0,6.66-0.01,9.73,0c7.38,0.04,14.76,0.17,22.14,0.11c4.34-0.03,9.33,1.21,11.07-5.36c2.95,1.72,5.32,3.52,7.99,4.58
						c14.11,5.59,28.68,5.73,42.97,1.58c5.56-1.62,11.68-5.17,15.01-9.7c4.53-6.16,8.24-13.83,9.49-21.32
						c3.84-23.04-2.94-40.97-24.14-52.69c-13.69-7.56-27.71-14.52-41.33-22.2c-2.25-1.27-4.12-4.75-4.41-7.41
						c-0.2-1.83,2.23-4.59,4.18-5.88c4.76-3.15,13.35-1,17,4.7c2.74,4.28,4.03,9.47,6.18,14.16c0.64,1.39,1.92,3.44,3.01,3.51
						c11.11,0.71,22.24,1.07,33.36,1.54c3.49,0.15,4.74-1.52,4.46-4.92c-0.54-6.42-1.14-12.85-1.28-19.28
						c-0.22-9.78-0.1-19.57-0.06-29.35c0.01-3.59-0.96-5.33-5.21-5.07c-9.29,0.55-18.65,0.92-27.94,0.42
						C194.36,1.84,191.77,2.27,193.27,8.97z M12.03,119.58c-1,0.2-1.63,0.39-2.26,0.43c-6.65,0.41-7.04,0.83-7.02,7.24
						c0.02,6.43-0.06,12.86-0.03,19.29c0.03,7.27,0.23,7.41,7.7,7.53c19.46,0.3,38.93,0.63,58.39,0.95c2.78,0.05,4.24-0.96,4.18-4.11
						c-0.16-8.5-0.15-17.01,0-25.51c0.07-3.92-1.15-6.02-5.42-5.42c-4.64,0.65-5.81-2.05-5.5-5.97c0.29-3.62,0.94-7.24,0.95-10.86
						c0.1-19.8,0.08-39.61,0.03-59.41c-0.02-7.35-0.12-7.34,6.97-6.82c0.8,0.06,1.62-0.08,2.9-0.15c0-9.25,0-18.37,0-27.49
						c0-6.74,0-6.69-6.92-6.79c-10.8-0.16-21.6-0.49-32.4-0.61C23.5,1.75,13.39,1.84,2.1,1.84c0,10.7-0.11,21.04,0.17,31.38
						c0.03,1.06,2.32,2.75,3.74,2.96c5.9,0.87,6.77,2,6.64,7.68c-0.35,15.92-0.47,31.85-0.61,47.78
						C11.97,100.91,12.03,110.18,12.03,119.58z"/>
					<path d="M281.66,80.31c0-11-0.66-22.04,0.21-32.97c0.71-8.87,2.39-17.84,7.75-25.51c5.42-7.77,12.67-13.29,21.66-15.88
						c18.31-5.29,37.03-4.96,55.64-2.05c11.37,1.78,22.62,5.2,29.63,15.14c3.85,5.47,7.19,12.12,8.17,18.63
						c1.86,12.39,2.17,25.05,2.52,37.62c0.35,12.39,0.58,24.85-0.27,37.2c-1.28,18.55-9.21,33.54-27.4,40.54
						c-7.41,2.85-15.69,4.41-23.64,4.71c-16.37,0.62-32.56,0.58-48.59-5.63c-11.5-4.45-19.12-11.36-22.67-22.28
						c-2.42-7.42-2.85-15.62-3.34-23.52c-0.54-8.64-0.12-17.34-0.12-26.01C281.35,80.31,281.51,80.31,281.66,80.31z M353.95,79.45
						c0.03,0,0.05,0,0.08,0c0-11.16,0.06-22.33-0.02-33.49c-0.05-6.47-4.26-10.52-10.55-10.39c-6.43,0.13-8.57,2.49-8.66,9.93
						c-0.23,20.27-0.39,40.54-0.56,60.82c-0.02,2.99-0.2,6.02,0.2,8.97c0.86,6.31,4.85,10.14,10.18,9.61
						c6.37-0.63,9.45-3.97,9.37-10.44C353.84,102.78,353.95,91.11,353.95,79.45z"/>
					<path d="M193.27,8.97c-1.5-6.7,1.09-7.13,6.01-6.87c9.28,0.5,18.64,0.13,27.94-0.42c4.26-0.25,5.23,1.48,5.21,5.07
						c-0.04,9.78-0.16,19.57,0.06,29.35c0.14,6.43,0.74,12.86,1.28,19.28c0.29,3.4-0.97,5.07-4.46,4.92
						c-11.12-0.47-22.25-0.83-33.36-1.54c-1.09-0.07-2.38-2.12-3.01-3.51c-2.15-4.69-3.44-9.88-6.18-14.16
						c-3.65-5.71-12.24-7.86-17-4.7c-1.95,1.29-4.38,4.05-4.18,5.88c0.29,2.65,2.17,6.14,4.41,7.41c13.62,7.68,27.64,14.63,41.33,22.2
						c21.2,11.72,27.98,29.65,24.14,52.69c-1.25,7.49-4.96,15.17-9.49,21.32c-3.34,4.53-9.45,8.08-15.01,9.7
						c-14.29,4.15-28.86,4.01-42.97-1.58c-2.67-1.06-5.04-2.86-7.99-4.58c-1.74,6.57-6.73,5.33-11.07,5.36
						c-7.38,0.06-14.76-0.07-22.14-0.11c-3.07-0.02-6.15,0-9.73,0c0-19.3,0-38.67,0-58.63c3.98,0,7.92-0.01,11.86,0
						c7.8,0.02,15.6,0.15,23.4,0.04c2.94-0.04,4.24,0.49,4.77,3.95c0.75,4.86,2.24,9.81,4.47,14.18c3.17,6.23,13.97,9,19.99,5.84
						c3.42-1.8,4.48-7.6,1.09-10.14c-6.37-4.79-13.3-8.83-20.04-13.12c-11.48-7.29-23.38-13.99-34.3-22.03
						c-4.24-3.13-6.84-8.97-9.21-14.04c-3.86-8.25-3.48-17.41-2.05-25.98c2.18-13.12,8.09-23.96,21.36-29.98
						c12.75-5.78,25.68-4.45,38.67-2.99c3.99,0.45,7.72,3.26,11.56,5C189.8,7.32,190.94,7.88,193.27,8.97z"/>
					<path d="M12.03,119.58c0-9.4-0.07-18.67,0.01-27.95c0.14-15.93,0.26-31.86,0.61-47.78c0.12-5.69-0.75-6.81-6.64-7.68
						c-1.42-0.21-3.71-1.9-3.74-2.96C1.99,22.88,2.1,12.53,2.1,1.84c11.29,0,21.4-0.08,31.51,0.02c10.8,0.11,21.6,0.44,32.4,0.61
						c6.91,0.1,6.92,0.05,6.92,6.79c0,9.12,0,18.24,0,27.49c-1.28,0.07-2.1,0.21-2.9,0.15c-7.09-0.52-6.99-0.53-6.97,6.82
						c0.05,19.8,0.07,39.61-0.03,59.41c-0.02,3.62-0.67,7.24-0.95,10.86c-0.31,3.93,0.86,6.63,5.5,5.97c4.28-0.6,5.49,1.5,5.42,5.42
						c-0.15,8.5-0.16,17.01,0,25.51c0.06,3.15-1.4,4.16-4.18,4.11c-19.46-0.32-38.93-0.64-58.39-0.95c-7.46-0.12-7.67-0.26-7.7-7.53
						c-0.03-6.43,0.05-12.86,0.03-19.29c-0.02-6.41,0.37-6.83,7.02-7.24C10.41,119.98,11.03,119.78,12.03,119.58z"/>
					<path class="st0" d="M353.95,79.45c0,11.67-0.1,23.33,0.04,35c0.08,6.48-3,9.81-9.37,10.44c-5.32,0.53-9.32-3.3-10.18-9.61
						c-0.4-2.94-0.22-5.98-0.2-8.97c0.16-20.27,0.33-40.54,0.56-60.82c0.08-7.44,2.23-9.79,8.66-9.93c6.29-0.13,10.5,3.92,10.55,10.39
						c0.08,11.16,0.02,22.33,0.02,33.49C354,79.45,353.98,79.45,353.95,79.45z"/>
				</g>
			</g>
			</svg>
	</xsl:variable>
	
	<xsl:variable name="Image-ISO-Logo-1972">
		<xsl:text>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</xsl:text>
	</xsl:variable>
	
	<xsl:variable name="Image-ISO-Logo-1993-SVG">
		<svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
			 viewBox="0 0 65.04 59.24" style="enable-background:new 0 0 65.04 59.24;" xml:space="preserve">
		<g>
			<defs>
				<rect id="SVGID_1_" width="65.04" height="59.24"/>
			</defs>
			<path style="fill:#231F20;" d="M3.09,2.83h58.87V2.6
				H3.09V2.83z M61.95,4.88H3.09v0.23h58.87V4.88z M3.09,7.17h58.87V7.4H3.09V7.17z M3.09,20.87h2.85v0.23H3.09V20.87z M3.09,23.15
				h2.85v0.23H3.09V23.15z M3.09,25.44h2.85v0.23H3.09V25.44z M3.09,27.72h5.53v0.23H3.09V27.72z M3.09,30h5.53v0.23H3.09V30z
				 M3.09,32.29h5.53v0.23H3.09V32.29z M3.09,34.57h2.85v0.23H3.09V34.57z M3.09,36.85h2.85v0.23H3.09V36.85z M3.09,39.14h2.85v0.23
				H3.09V39.14z M3.09,52.84h58.87v0.23H3.09V52.84z M3.09,55.12h58.87v0.23H3.09V55.12z M3.09,57.4h58.87v0.23H3.09V57.4z
				 M22.46,9.68H3.09V9.45h19.88L22.46,9.68 M19.03,11.73l-0.31,0.23H3.09v-0.23H19.03 M16.34,14.02l-0.23,0.23H3.09v-0.23H16.34
				 M14.33,16.3l-0.18,0.23H3.09V16.3H14.33 M12.78,18.58l-0.13,0.23H3.09v-0.23H12.78 M42.05,9.68l-0.5-0.23h20.4v0.23H42.05
				 M45.81,11.97l-0.32-0.23h16.46v0.23H45.81 M48.18,14.02l0.23,0.23h13.54v-0.23H48.18 M50.19,16.3l0.18,0.23h11.59V16.3H50.19
				 M51.73,18.58l0.13,0.23h10.09v-0.23H51.73 M55.79,20.87l0.32,0.23h5.85v-0.23H55.79 M58.06,23.15l0.16,0.23h3.73v-0.23H58.06
				 M59.24,25.44l0.07,0.23h2.64v-0.23H59.24 M59.8,27.72l0.04,0.23h2.12v-0.23H59.8 M61.95,30h-1.93l0,0.12l0,0.11h1.93V30
				 M61.95,32.29v0.23h-2.14l0.04-0.23H61.95 M61.95,34.57v0.23h-2.68l0.07-0.23H61.95 M61.95,36.85v0.23h-3.81l0.15-0.23H61.95
				 M61.95,39.14v0.23h-6.01l0.31-0.23H61.95 M61.95,41.42v0.23H51.73l0.13-0.23H61.95 M61.95,43.7v0.23H50.19l0.18-0.23H61.95
				 M61.95,45.98v0.23H48.18l0.23-0.23H61.95 M61.95,48.27v0.23H45.49l0.32-0.23H61.95 M61.95,50.55v0.23h-20.4l0.5-0.23H61.95
				 M3.09,41.42h9.56l0.13,0.23h-9.7V41.42 M3.09,43.7h11.07l0.18,0.23H3.09V43.7 M3.09,45.98h13.02l0.23,0.23H3.09V45.98 M3.09,48.27
				h15.63l0.31,0.23H3.09V48.27 M3.09,50.55h19.38l0.5,0.23H3.09V50.55 M8.01,20.87h12.06v4.52h-2.97v9.59h2.97v4.38H8.01v-4.38h2.82
				V25.4H8.01V20.87 M33.14,22.28v-1.12h3.8v6.31h-3.62c-0.54-0.68-1.2-1.26-1.93-1.73c-0.36-0.32-0.77-0.59-1.21-0.78
				c-0.57-0.25-1.18-0.38-1.8-0.38c-0.03,0-0.06,0-0.09,0c-0.21,0-0.42,0.03-0.62,0.1c-0.31,0.1-0.59,0.27-0.84,0.49
				c-0.12,0.11-0.19,0.27-0.19,0.44c0,0.21,0.11,0.41,0.29,0.51c0.42,0.24,0.86,0.43,1.32,0.58c1.59,0.46,3.15,0.99,4.7,1.59
				c1.31,0.51,2.5,1.29,3.49,2.3c0.81,0.92,1.26,2.1,1.26,3.33c0,0.03,0,0.07,0,0.1h0c0,1.4-0.54,2.74-1.51,3.74
				c-0.77,0.76-1.71,1.31-2.74,1.63c-0.84,0.22-1.71,0.33-2.58,0.33c-0.81,0-1.62-0.1-2.41-0.29c-1.14-0.33-2.27-0.68-3.4-1.07v1.01
				h-3.91v-6.8h3.31c0.62,1.15,1.61,2.07,2.8,2.6h0c0.67,0.28,1.39,0.45,2.12,0.5v0c0.15,0.01,0.31,0.02,0.46,0.02
				c0.47,0,0.93-0.05,1.39-0.14h0c0.23-0.05,0.43-0.17,0.58-0.35v0c0.06-0.07,0.09-0.17,0.09-0.26c0-0.11-0.04-0.21-0.11-0.29v0
				c-0.28-0.3-0.61-0.56-0.96-0.77c-0.35-0.21-0.73-0.38-1.13-0.49c-1.25-0.37-2.5-0.74-3.74-1.12c-0.65-0.2-1.26-0.5-1.81-0.89
				c-0.54-0.38-1.08-0.78-1.61-1.18c-0.56-0.43-0.97-1.02-1.16-1.7c-0.23-0.65-0.37-1.33-0.39-2.02c0-0.07-0.01-0.14-0.01-0.21
				c0-0.68,0.14-1.36,0.41-1.99c0.34-0.78,0.85-1.48,1.49-2.05h0c0.61-0.54,1.34-0.93,2.13-1.15c0.87-0.25,1.77-0.37,2.68-0.37
				c0.38,0,0.76,0.02,1.14,0.06C30.34,20.94,31.83,21.46,33.14,22.28 M45.53,26.94c0.47-1,1.46-1.64,2.57-1.66
				c1.1,0.02,2.1,0.66,2.57,1.66c0.34,0.91,0.51,1.87,0.51,2.84c0,0.13,0,0.26-0.01,0.39c0.01,0.13,0.01,0.26,0.01,0.39
				c0,0.97-0.17,1.93-0.51,2.84c-0.47,1-1.46,1.64-2.57,1.66c-1.1-0.02-2.1-0.67-2.57-1.66c-0.34-0.91-0.51-1.87-0.51-2.84
				c0-0.13,0-0.26,0.01-0.39c-0.01-0.13-0.01-0.26-0.01-0.39C45.02,28.81,45.19,27.85,45.53,26.94 M40.78,23.21
				c1.39-1.21,3.09-2.02,4.9-2.34v0c0.75-0.14,1.51-0.21,2.27-0.21c0.14,0,0.27,0,0.41,0.01c1.53,0,3.05,0.31,4.46,0.91
				c0.95,0.39,1.82,0.94,2.59,1.63c1.31,1.28,2.13,2.97,2.33,4.79c0.14,0.72,0.22,1.45,0.22,2.18s-0.07,1.46-0.22,2.18
				c-0.2,1.82-1.02,3.51-2.33,4.79c-0.76,0.68-1.64,1.24-2.59,1.63v0c-1.41,0.6-2.93,0.91-4.46,0.91c-0.15,0.01-0.31,0.01-0.46,0.01
				c-1.56,0-3.1-0.31-4.54-0.92c-0.95-0.39-1.82-0.95-2.59-1.63c-0.78-0.76-1.38-1.67-1.79-2.67c-0.47-1.39-0.72-2.84-0.76-4.3
				c0.04-1.46,0.29-2.91,0.76-4.3C39.4,24.87,40,23.96,40.78,23.21 M27.85,10.83c1.45-0.33,2.93-0.51,4.41-0.51
				c1.48,0.01,2.96,0.18,4.41,0.51c-1.3,0.88-2.84,1.35-4.41,1.35C30.69,12.18,29.15,11.71,27.85,10.83 M20.83,14
				c0.67,0.47,1.37,0.91,2.1,1.29c0.69-0.71,1.41-1.37,2.18-1.99c0.77-0.62,1.57-1.18,2.41-1.7c-0.24-0.16-0.48-0.32-0.7-0.5
				c-1.07,0.31-2.12,0.71-3.12,1.2S21.73,13.35,20.83,14 M23.7,15.68c0.5,0.24,1,0.45,1.52,0.65c0.52,0.19,1.04,0.37,1.57,0.52
				c0.35-0.76,0.73-1.51,1.15-2.24c0.42-0.73,0.86-1.44,1.35-2.13c-0.32-0.12-0.63-0.25-0.93-0.4c-0.85,0.5-1.66,1.05-2.44,1.65
				C25.13,14.33,24.39,14.98,23.7,15.68 M27.59,17.07c0.7,0.17,1.4,0.3,2.11,0.39c0.71,0.09,1.43,0.15,2.14,0.16v-4.63
				c-0.59-0.03-1.17-0.12-1.74-0.26v0c-0.49,0.68-0.94,1.38-1.36,2.11C28.33,15.56,27.94,16.31,27.59,17.07 M32.67,17.62v-4.63
				c0.59-0.03,1.17-0.12,1.74-0.26v0c0.48,0.68,0.94,1.39,1.36,2.11c0.42,0.72,0.8,1.47,1.15,2.23C35.53,17.4,34.1,17.59,32.67,17.62
				 M35.24,12.48c0.32-0.12,0.63-0.25,0.93-0.4c0.85,0.5,1.66,1.05,2.44,1.65c0.78,0.6,1.51,1.26,2.21,1.96
				c-0.99,0.48-2.03,0.87-3.08,1.17c-0.35-0.76-0.73-1.51-1.15-2.24C36.17,13.88,35.72,13.17,35.24,12.48 M36.99,11.6
				c0.24-0.16,0.48-0.32,0.7-0.5c1.07,0.31,2.12,0.71,3.12,1.2s1.97,1.06,2.88,1.7c-0.67,0.47-1.37,0.91-2.1,1.29l0,0
				c-0.68-0.71-1.41-1.37-2.18-1.99C38.64,12.69,37.83,12.12,36.99,11.6 M15.98,18.94h-0.99c3.79-5.87,10.28-9.42,17.27-9.44
				c6.98,0.02,13.48,3.58,17.27,9.44h-0.99c-0.57-0.84-1.21-1.63-1.9-2.37c-0.69-0.74-1.45-1.43-2.25-2.05
				c-0.71,0.51-1.44,0.98-2.21,1.4c0.85,0.94,1.62,1.96,2.31,3.02H43.5c-0.31-0.46-0.65-0.92-0.99-1.35
				c-0.35-0.44-0.71-0.86-1.09-1.28c-1.08,0.53-2.2,0.97-3.35,1.31l0.51,1.32H37.7l-0.44-1.1c-1.5,0.38-3.04,0.58-4.59,0.61v0.49
				h-0.83v-0.49c-1.55-0.03-3.09-0.24-4.59-0.61h0l-0.44,1.1h-0.88l0.51-1.32c-1.15-0.34-2.27-0.77-3.35-1.31
				c-0.76,0.83-1.45,1.7-2.08,2.63h-0.99c0.69-1.07,1.46-2.08,2.31-3.02c-0.77-0.42-1.5-0.89-2.21-1.4
				C18.53,15.77,17.13,17.26,15.98,18.94 M27.85,49.4c1.45,0.33,2.93,0.51,4.41,0.51c1.48-0.01,2.96-0.18,4.41-0.51
				c-1.3-0.88-2.84-1.35-4.41-1.35C30.69,48.05,29.15,48.52,27.85,49.4 M20.83,46.23c0.67-0.47,1.37-0.91,2.1-1.29
				c0.69,0.71,1.41,1.37,2.18,1.99c0.77,0.62,1.57,1.18,2.41,1.7c-0.24,0.16-0.48,0.32-0.7,0.5c-1.07-0.31-2.12-0.71-3.12-1.2
				S21.73,46.88,20.83,46.23 M23.7,44.55c0.5-0.24,1-0.45,1.52-0.65c0.52-0.2,1.04-0.37,1.57-0.52c0.35,0.76,0.73,1.51,1.15,2.24
				c0.42,0.73,0.86,1.44,1.35,2.13c-0.32,0.12-0.63,0.25-0.93,0.4c-0.85-0.5-1.66-1.05-2.44-1.65C25.13,45.9,24.39,45.25,23.7,44.55
				 M27.59,43.17c0.7-0.17,1.4-0.3,2.11-0.39c0.71-0.09,1.43-0.15,2.14-0.16v4.63c-0.59,0.03-1.17,0.12-1.74,0.26v0
				c-0.49-0.68-0.94-1.38-1.36-2.11C28.33,44.67,27.94,43.93,27.59,43.17 M32.67,42.61v4.63c0.59,0.03,1.17,0.12,1.74,0.26
				c0.48-0.68,0.94-1.38,1.36-2.11c0.42-0.72,0.8-1.47,1.15-2.23C35.53,42.83,34.1,42.64,32.67,42.61 M35.24,47.76
				c0.32,0.12,0.63,0.25,0.93,0.4c0.85-0.5,1.66-1.05,2.44-1.65c0.78-0.6,1.51-1.26,2.21-1.96c-0.99-0.47-2.03-0.87-3.08-1.17
				c-0.35,0.77-0.73,1.52-1.15,2.25C36.17,46.36,35.72,47.07,35.24,47.76 M36.99,48.63c0.24,0.16,0.48,0.32,0.7,0.5
				c1.07-0.31,2.12-0.71,3.12-1.2s1.97-1.06,2.88-1.7c-0.67-0.48-1.37-0.91-2.1-1.29h0c-0.68,0.71-1.41,1.37-2.18,1.99
				C38.64,47.55,37.83,48.11,36.99,48.63 M15.98,41.3h-0.99c3.79,5.87,10.28,9.42,17.27,9.44c6.98-0.02,13.48-3.58,17.27-9.44h-0.99
				c-0.57,0.84-1.21,1.63-1.9,2.37c-0.69,0.74-1.45,1.43-2.25,2.05c-0.71-0.51-1.44-0.98-2.21-1.4c0.85-0.94,1.62-1.96,2.31-3.02H43.5
				c-0.31,0.46-0.65,0.91-0.99,1.35c-0.35,0.44-0.71,0.86-1.09,1.28v0c-1.08-0.53-2.2-0.97-3.35-1.31l0.51-1.32H37.7l-0.44,1.1
				c-1.5-0.38-3.04-0.58-4.59-0.61V41.3h-0.83v0.49c-1.55,0.03-3.09,0.24-4.59,0.61h0l-0.44-1.1h-0.88l0.51,1.32
				c-1.15,0.34-2.27,0.77-3.35,1.31v0c-0.76-0.83-1.45-1.7-2.08-2.63h-0.99c0.69,1.07,1.46,2.08,2.31,3.02
				c-0.77,0.42-1.5,0.88-2.21,1.4C18.53,44.46,17.13,42.97,15.98,41.3"/>
			<path style="fill:#FFFFFF;" d="M45.53,26.94
				c0.47-1,1.46-1.64,2.57-1.66c1.1,0.02,2.1,0.66,2.57,1.66c0.34,0.91,0.52,1.87,0.52,2.84c0,0.13,0,0.26-0.01,0.39
				c0.01,0.13,0.01,0.26,0.01,0.39c0,0.97-0.18,1.93-0.52,2.84c-0.47,1-1.46,1.64-2.57,1.66c-1.1-0.02-2.1-0.67-2.57-1.66
				c-0.34-0.91-0.51-1.87-0.51-2.84c0-0.13,0-0.26,0.01-0.39c-0.01-0.13-0.01-0.26-0.01-0.39C45.02,28.81,45.19,27.85,45.53,26.94
				 M27.85,10.83c1.45-0.34,2.92-0.51,4.41-0.51c1.48,0.01,2.96,0.18,4.41,0.51c-1.3,0.88-2.84,1.35-4.41,1.35
				C30.69,12.18,29.15,11.71,27.85,10.83 M32.67,17.62v-4.63c0.59-0.03,1.17-0.12,1.74-0.26v0c0.49,0.68,0.94,1.38,1.36,2.11
				c0.42,0.72,0.81,1.47,1.15,2.23C35.53,17.4,34.1,17.59,32.67,17.62 M35.24,12.48c0.32-0.12,0.63-0.25,0.93-0.4
				c0.85,0.5,1.66,1.05,2.44,1.65c0.78,0.6,1.51,1.26,2.2,1.96c-0.99,0.47-2.03,0.87-3.08,1.17c-0.35-0.76-0.73-1.51-1.15-2.24
				C36.17,13.88,35.72,13.17,35.24,12.48 M36.99,11.6c0.24-0.16,0.47-0.32,0.7-0.5c1.07,0.31,2.12,0.71,3.12,1.2
				c1.01,0.49,1.97,1.06,2.88,1.7c-0.67,0.47-1.37,0.91-2.1,1.29h0c-0.69-0.71-1.41-1.37-2.18-1.99
				C38.64,12.69,37.83,12.12,36.99,11.6 M27.85,49.4c1.45,0.33,2.92,0.51,4.41,0.51c1.48-0.01,2.96-0.18,4.41-0.51
				c-1.3-0.88-2.84-1.35-4.41-1.35C30.69,48.05,29.15,48.52,27.85,49.4 M32.67,42.61v4.63c0.59,0.03,1.17,0.12,1.74,0.26
				c0.49-0.68,0.94-1.38,1.36-2.11c0.42-0.72,0.81-1.47,1.15-2.23C35.53,42.83,34.1,42.64,32.67,42.61 M35.24,47.76
				c0.32,0.12,0.63,0.25,0.93,0.4c0.85-0.5,1.66-1.05,2.44-1.65c0.78-0.6,1.51-1.26,2.2-1.96c-0.99-0.48-2.03-0.87-3.08-1.17
				c-0.35,0.77-0.73,1.51-1.15,2.25C36.17,46.36,35.72,47.07,35.24,47.76 M36.99,48.63c0.24,0.16,0.47,0.33,0.7,0.51
				c1.07-0.31,2.12-0.71,3.12-1.2c1.01-0.49,1.97-1.06,2.88-1.7c-0.67-0.47-1.37-0.9-2.1-1.29h0c-0.69,0.71-1.41,1.37-2.18,1.99
				C38.64,47.55,37.83,48.11,36.99,48.63"/>
		</g>
		</svg>

	</xsl:variable>
	
	<xsl:variable name="Image-IEC-Logo-1989">
		<xsl:text>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</xsl:text>
	</xsl:variable>
	
	<xsl:variable name="Image-IEC-Logo">
		<xsl:text>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</xsl:text>
	</xsl:variable>
	
	<xsl:variable name="Image-IEC-Logo-SVG">
		<xsl:variable name="logo_color">
			<xsl:choose>
				<xsl:when test="$stage &gt;=60 and $layoutVersion = '2024'">rgb(0,96,170)</xsl:when>
				<xsl:otherwise>rgb(35,31,32)</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<svg version="1.0" viewBox="0 0 400 400" xmlns="http://www.w3.org/2000/svg">
			<path d="m0 400h400v-400h-400z" fill="{$logo_color}"/>
			<g fill="#fff">
				<path d="m76.201 86.521h-32.884v162.03h32.884z"/>
				<path d="m218.56 82.719h-80.086c-7.7143 0-19.12 8.6576-19.12 20.867v118.79c0 9.6844 8.797 25.917 23.865 25.917h76.895v-13.68h-54.556c-9.6569 0-14.263-4.6618-14.263-10.545v-44.315c0-4.634-1.9703-12.237 3.8297-12.237h47.979v-12.237h-46.814c-6.1879 0-4.995-4.4398-4.995-8.2136v-37.35c0-4.2178-0.13854-11.488 7.9919-11.488h59.274z"/>
				<path d="m359.78 109.72s-17.815-30.385-58.052-30.385c-32.855 0-75.813 30.801-75.813 87.77 0 62.019 48.729 84.801 78.144 84.801 44.872 0 61.133-41.762 61.133-41.762l-7.7421-7.187s-20.618 36.934-51.365 36.934c-18.953 0-49.228-18.786-49.228-72.785 0-59.938 25.641-75.116 49.228-75.116 29.026 0 45.565 26.167 45.565 26.167z"/>
				<path d="m338.83 334.48c12.515 0 22.672-10.6 22.672-23.697 0-13.098-10.157-23.725-22.672-23.725-12.543 0-22.672 10.628-22.672 23.725 0 13.097 10.128 23.697 22.672 23.697"/>
				<path d="m43.317 326.63v6.8539l271.53 0.11082c-1.9425-2.0534-3.5521-4.3843-4.9672-6.8539zm262.74-20.257h-262.74v7.7974h262.62c-0.1119-1.1377-0.33033-2.2199-0.33033-3.3853 0-1.5262 0.2504-2.9692 0.44218-4.4121m-262.74-18.398v6.965h266.37s0.16518-0.22217 0.44222-0.555c1.332-2.3032 2.8585-4.4953 4.6902-6.41z"/>
			</g>
		</svg>
	</xsl:variable>
	
	<xsl:variable name="Image-IDF-Logo">
		<xsl:text>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</xsl:text>
	</xsl:variable>
	
	<xsl:variable name="Image-IEEE-Logo">
		<xsl:text>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</xsl:text>
	</xsl:variable>
	
	<xsl:variable name="Image-IEEE-Logo2">
		<xsl:choose>
			<!-- color logo -->
			<xsl:when test="$stage &gt;=60"><xsl:text>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</xsl:text></xsl:when>
			<!-- grey logo -->
			<xsl:otherwise><xsl:text>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ikfOmd+JycYI5zFM/fNY88XC+b4Y0EYa2nhJI+sX9T93xy4TH3xKicnGCMM5Uj4lNuX2wAHoIa/y12GTNCMcjwng+9c1gMnGMAKwSZphqDHZGIYak41hqDHZGIYak41hqDHZGIYak41hqDHZGIYak41hqDHZGIYak41hqDHZGIYak41hqDHZGIYak41hqDHZGIYak41hqDHZGIYak41hqDHZGIYak41hqDHZGIYak41hqDHZGIYak41hqDHZGIYak41hqDHZGIYak41hqDHZGIYak41hqDHZGIYak41hqDHZGIYak41hqDHZGIYak41hqDHZGIYak41hqDHZGIYak41hqDHZGIYak41hqDHZGIYak41hqDHZGIYak41hqDHZGIYak41hqDHZGIYak41hqDHZGIYak41hqDHZGIYak41hqPkPYIC3LoZhfAQMBjP+VO6vtG1pDOMjcAMM/QVxzUC5cXEM4xOgjJgYf8FAvXVhDOMzqE8Ag80kYBhyMjABZLIxDBUM8H9mCzAMLf+Z7dkwFBBA+EtmETAMBba2MYwgTDaGocZkYxhqTDaGocZkYxhqTDaGocZkYxhqTDaGocZkYxhqTDaGocZkYxhqTDaGocZkYxhqTDaGocZkYxhqTDaGocZkYxhqTDaGocZkYxhqTDaGocZkYxhqTDaGocZkYxhqTDaGocZkYxhqTDaGocZkYxhqTDaGocZkYxhqTDaGocZkYxhqTDaGocZkYxhqTDaGocZkYxhqTDaGocZkYxhqTDaGocZkYxhqTDaGocZkYxhqTDaGocZkYxhqTDaGocZkYxhqTDaGocZkYxhqTDaGocZkYxhqTDaGocZkYxhqTDaGocZkYxhqTDaGocZkYxhq/vLWJTCMz6EGg4C/AJBtXRjD+BgI4D8VQAzQ1oUxjA+gnZz9ffyrYRhvIMafigCAbbQxjPcwiAH8D/3TuZLhZZQlAAAAAElFTkSuQmCC</xsl:text></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="Image-Attention">
		<xsl:text>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</xsl:text>
	</xsl:variable>

	<xsl:template name="insertInterFont">
		<xsl:variable name="font_family">
			<font-family>
				<xsl:variable name="inter-font-style">
					<root-style>
						<xsl:attribute name="font-family">Cambria Math, <xsl:value-of select="$font_noto_sans"/></xsl:attribute>
						<xsl:attribute name="font-family-generic">Sans</xsl:attribute>
					</root-style>
				</xsl:variable>
				<xsl:call-template name="insertRootStyle">
					<xsl:with-param name="root-style" select="$inter-font-style"/>
				</xsl:call-template>
			</font-family>
		</xsl:variable>
		<xsl:attribute name="font-family">
			<xsl:text>Inter, </xsl:text>
			<xsl:value-of select="xalan:nodeset($font_family)/*/@font-family"/>
		</xsl:attribute>
	</xsl:template>

	<xsl:template name="insertSmallHorizontalLine">
		<xsl:if test="($layoutVersion = '1951' or $layoutVersion = '1972' or $layoutVersion = '1979' or $layoutVersion = '1987' or $layoutVersion = '1989')">
			<!-- small horizontal line -->
			<fo:block text-align="center" margin-top="12mm" keep-with-previous="always" role="SKIP">
				<xsl:if test="$layout_columns != 1">
					<xsl:attribute name="span">all</xsl:attribute>
				</xsl:if>
				<fo:leader leader-pattern="rule" leader-length="20%"/>
			</fo:block>
		</xsl:if>
	</xsl:template>

	<xsl:template name="insertBlackCircle">
		<fo:instream-foreign-object content-width="1.3mm" fox:alt-text="black circle">	
			<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 20 20">
				<circle cx="10" cy="10" r="5" stroke="black" stroke-width="5" fill="black"/>
			</svg>
		</fo:instream-foreign-object>
	</xsl:template>

	<xsl:template name="insertLastBlock">
		<fo:block id="lastBlock" font-size="1pt" keep-with-previous="always" role="SKIP"><fo:wrapper role="artifact">&#xA0;</fo:wrapper></fo:block>
	</xsl:template>

	<xsl:include href="./common.xsl"/>

</xsl:stylesheet>
