<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
											xmlns:fo="http://www.w3.org/1999/XSL/Format" 
											xmlns:mn="https://www.metanorma.org/ns/standoc" 
											xmlns:mnx="https://www.metanorma.org/ns/xslt" 
											xmlns:mathml="http://www.w3.org/1998/Math/MathML" 
											xmlns:xalan="http://xml.apache.org/xalan" 
											xmlns:fox="http://xmlgraphics.apache.org/fop/extensions" 
											xmlns:pdf="http://xmlgraphics.apache.org/fop/extensions/pdf"
											xmlns:java="http://xml.apache.org/xalan/java" 
											xmlns:redirect="http://xml.apache.org/xalan/redirect"
											exclude-result-prefixes="java"
											extension-element-prefixes="redirect"
											version="1.0">

	<xsl:output version="1.0" method="xml" encoding="UTF-8" indent="no"/>
	
	<xsl:param name="initial_page_number"/>
	<xsl:param name="doc_split_by_language"/>
	
	<xsl:param name="add_math_as_attachment">true</xsl:param>
	<xsl:param name="final_transform">true</xsl:param>
	
	<xsl:key name="kfn" match="mn:fn[not(ancestor::*[self::mn:table or self::mn:figure or self::mn:localized-strings] and not(ancestor::mn:fmt-name))]" use="@reference"/>
	
	<xsl:variable name="first_pass" select="count($index//item) = 0"/>
	
	<xsl:variable name="namespace">bipm</xsl:variable>

	<!-- DON'T DELETE IT -->
	<!-- IT USES for mn2pdf -->
	<xsl:variable name="coverpages_count">2</xsl:variable><!-- DON'T DELETE IT -->
	
	
	<xsl:variable name="debug">false</xsl:variable>
	
	<xsl:variable name="copyrightYear" select="//mn:metanorma/mn:bibdata/mn:copyright/mn:from"/>
	
	<xsl:variable name="doc_first_language" select="(//mn:metanorma)[1]/mn:bibdata/mn:language[@current = 'true']"/>

	<xsl:variable name="root-element" select="local-name(/*)"/>

	<xsl:variable name="contents_">
		<xsl:choose>
			<xsl:when test="$root-element = 'metanorma-collection'">
				<xsl:choose>
					<xsl:when test="$doc_split_by_language = ''"><!-- all documents -->
						<xsl:for-each select="//mn:metanorma">
							<xsl:variable name="lang" select="mn:bibdata/mn:language[@current = 'true']"/>
							<xsl:variable name="num"><xsl:number level="any" count="mn:metanorma"/></xsl:variable>
							<xsl:variable name="title-part"><xsl:value-of select="mn:bibdata/mn:title[@type = 'title-part']"/></xsl:variable>
							<xsl:variable name="current_document">
								<xsl:copy-of select="."/>
							</xsl:variable>				
							<xsl:for-each select="xalan:nodeset($current_document)">
								<xsl:variable name="docid">
									<xsl:call-template name="getDocumentId"/>
								</xsl:variable>
								<mnx:doc id="{$docid}" lang="{$lang}" doctype="{$doctype}" title-part="{$title-part}">
									<xsl:call-template name="generateContents"/>
								</mnx:doc>
							</xsl:for-each>				
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each select="(//mn:metanorma)[mn:bibdata/mn:language[@current = 'true'] = $doc_split_by_language]">
							<xsl:variable name="lang" select="mn:bibdata/mn:language[@current = 'true']"/>
							<xsl:variable name="num"><xsl:number level="any" count="mn:metanorma"/></xsl:variable>
							<xsl:variable name="current_document">
								<xsl:copy-of select="."/>
							</xsl:variable>				
							<xsl:for-each select="xalan:nodeset($current_document)">
								<xsl:variable name="docid">
									<xsl:call-template name="getDocumentId"/>
								</xsl:variable>
								<mnx:doc id="{$docid}" lang="{$lang}">
									<xsl:call-template name="generateContents"/>
								</mnx:doc>
							</xsl:for-each>				
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
			
			</xsl:when>			
			<xsl:otherwise>
				<xsl:variable name="docid">
					<xsl:call-template name="getDocumentId"/>
				</xsl:variable>
				<mnx:doc id="{$docid}" lang="{$lang}">
					<xsl:call-template name="generateContents"/>
				</mnx:doc>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="contents" select="xalan:nodeset($contents_)"/>

	<xsl:variable name="indexes">
		<xsl:choose>
			<xsl:when test="$doc_split_by_language = ''"><!-- all documents -->
				<xsl:for-each select="//mn:metanorma">
					
					<!-- <xsl:variable name="current_document">
						<xsl:copy-of select="."/>
					</xsl:variable>
					
					<xsl:for-each select="xalan:nodeset($current_document)"> -->
					
						<xsl:variable name="docid">
							<xsl:call-template name="getDocumentId_fromCurrentNode"/>
							<!-- <xsl:call-template name="getDocumentId"/> -->
						</xsl:variable>

						<!-- add id to xref and split xref with @to into two xref -->
						<xsl:variable name="current_document_index_id">
							<xsl:apply-templates select=".//mn:indexsect" mode="index_add_id">
								<xsl:with-param name="docid" select="$docid"/>
							</xsl:apply-templates>
						</xsl:variable>
						
						<!-- <xsl:variable name="current_document_index">
							<xsl:apply-templates select="xalan:nodeset($current_document_index_id)" mode="index_update"/>
						</xsl:variable>
						
						<xsl:for-each select="xalan:nodeset($current_document_index)">
							<doc id="{$docid}">
								<xsl:copy-of select="."/>
							</doc>
						</xsl:for-each> -->
						
						<doc id="{$docid}">
							<xsl:apply-templates select="xalan:nodeset($current_document_index_id)" mode="index_update"/>
						</doc>
						
					<!-- </xsl:for-each> -->
					
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="(//mn:metanorma)[mn:bibdata/mn:language[@current = 'true'] = $doc_split_by_language]">
				
					<!-- <xsl:variable name="current_document">
						<xsl:copy-of select="."/>
					</xsl:variable>
				
					<xsl:for-each select="xalan:nodeset($current_document)"> -->
					
						<xsl:variable name="docid">
							<!-- <xsl:call-template name="getDocumentId"/> -->
							<xsl:call-template name="getDocumentId_fromCurrentNode"/>
						</xsl:variable>
						
						<xsl:variable name="current_document_index_id">
							<xsl:apply-templates select=".//mn:indexsect" mode="index_add_id">
								<xsl:with-param name="docid" select="$docid"/>
							</xsl:apply-templates>
						</xsl:variable>
						
						<!-- <xsl:variable name="current_document_index">
							<xsl:apply-templates select="xalan:nodeset($current_document_index_id)" mode="index_update"/>
						</xsl:variable>
						
						<xsl:for-each select="xalan:nodeset($current_document_index)">
							<doc id="{$docid}">
								<xsl:copy-of select="."/>
							</doc>
						</xsl:for-each> -->
						
						<doc id="{$docid}">
							<xsl:apply-templates select="xalan:nodeset($current_document_index_id)" mode="index_update"/>
						</doc>
						
						
					<!-- </xsl:for-each> -->
					
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	
	<xsl:variable name="ids">
		<xsl:for-each select="//*[@id]">
			<id><xsl:value-of select="@id"/></id>
		</xsl:for-each>
		<xsl:for-each select="//mn:locality[@type='anchor']/mn:referenceFrom">
			<referenceFrom><xsl:value-of select="."/></referenceFrom>
		</xsl:for-each>
	</xsl:variable>
	
	
	
	<xsl:variable name="independentAppendix" select="normalize-space((//mn:metanorma)[1]/mn:bibdata/mn:ext/mn:structuredidentifier/mn:appendix)"/>
	
	<xsl:variable name="doctype" select="//mn:metanorma/mn:bibdata/mn:ext/mn:doctype"/>

	<xsl:template name="generateContents">
		<mnx:contents>

			<xsl:apply-templates select="/*/mn:preface/*[not(self::mn:note or self::mn:admonition or (self::mn:clause and @type = 'toc'))][position() &gt; 1]" mode="contents" />
			
			<xsl:apply-templates select="/*/mn:sections/*" mode="contents" />
			<xsl:apply-templates select="/*/mn:bibliography/mn:references[@normative='true']" mode="contents"/>
			<xsl:apply-templates select="/*/mn:annex" mode="contents"/>
			<xsl:if test="/*/mn:bibliography/mn:references[not(@normative='true')]/mn:bibitem[not(contains(mn:docidentifier, 'si-brochure-'))]">
				<xsl:apply-templates select="/*/mn:bibliography/mn:references[not(@normative='true')]" mode="contents"/> 
			</xsl:if>
			
			<!-- Index -->
			<xsl:apply-templates select="//mn:indexsect" mode="contents"/>
			
			<xsl:call-template name="processTablesFigures_Contents"/>
			
		</mnx:contents>
	</xsl:template>
	
	
	<xsl:variable name="mathml_attachments">
		<xsl:if test="$add_math_as_attachment = 'true' and $final_transform = 'true'">
			<xsl:for-each select="//mathml:math[ancestor::mn:fmt-stem]">
						
				<xsl:variable name="sequence_number"><xsl:number level="any" format="00001" count="mathml:math[ancestor::mn:fmt-stem]"/></xsl:variable>
				
				<!-- <xsl:variable name="clause_title_number" select="ancestor-or-self::mn:clause[mn:title[mn:tab]][1]/mn:title/node()[1]"/> -->
				<!-- <fmt-title depth="1"><span class="fmt-caption-label"><semx element="autonum" source="_introduction">1</semx><span class="fmt-autonum-delim">.</span></span> -->
				<xsl:variable name="clause_title_number" select="normalize-space(ancestor-or-self::mn:clause[mn:fmt-title[mn:span[@class = 'fmt-caption-label']]][1]/mn:fmt-title/mn:span[@class = 'fmt-caption-label'][1])"/>
				
				<xsl:variable name="mathml_filename">
					<xsl:text>math</xsl:text>
					<xsl:if test="$clause_title_number != '' and translate($clause_title_number, '.123456789', '') = ''">
						<xsl:text>_</xsl:text>
						<xsl:value-of select="$clause_title_number"/>
						<xsl:text>_</xsl:text>
					</xsl:if>
					<xsl:value-of select="$sequence_number"/>
					<xsl:text>.mml</xsl:text>
				</xsl:variable>
				
				<xsl:variable name="mathml_content">
					<xsl:apply-templates select="." mode="mathml_actual_text"/>
				</xsl:variable>
				
				<attachment filename="{$mathml_filename}">
					<xsl:value-of select="$mathml_content"/>
				</attachment>
				
			</xsl:for-each>
		</xsl:if>
	</xsl:variable>
	
	<xsl:template name="layout-master-set">
		<fo:layout-master-set>
			<!-- blank page -->
			<fo:simple-page-master master-name="blankpage" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
				<fo:region-before region-name="header-blank" extent="{$marginTop}mm"/> 
				<fo:region-after region-name="footer-blank" extent="{$marginBottom}mm"/>
				<fo:region-start region-name="left-region" extent="17mm"/>
				<fo:region-end region-name="right-region" extent="26.5mm"/>
			</fo:simple-page-master>
			
			<!-- Cover page -->
			<fo:simple-page-master master-name="simple-cover-page" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="36mm" margin-bottom="43mm" margin-left="49mm" margin-right="48mm"/>
				<fo:region-before region-name="header" extent="36mm" />
				<fo:region-after extent="43mm"/>
				<fo:region-start extent="49mm"/>
				<fo:region-end extent="48mm"/>
			</fo:simple-page-master>
			
			<fo:page-sequence-master master-name="cover-page">
				<fo:repeatable-page-master-alternatives>
					<fo:conditional-page-master-reference master-reference="blankpage" blank-or-not-blank="blank"/>
					<fo:conditional-page-master-reference master-reference="simple-cover-page" odd-or-even="odd"/>
					<fo:conditional-page-master-reference master-reference="simple-cover-page" odd-or-even="even"/>
				</fo:repeatable-page-master-alternatives>
			</fo:page-sequence-master>
			
			<!-- Cover page -->
			<fo:simple-page-master master-name="simple-cover-page-appendix" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="90mm" margin-bottom="40mm" margin-left="12.5mm" margin-right="53mm"/>
				<fo:region-before region-name="header" extent="60mm" />
				<fo:region-after extent="40mm"/>
				<fo:region-start extent="12.5mm"/>
				<fo:region-end extent="53mm"/>
			</fo:simple-page-master>
			
			<fo:page-sequence-master master-name="cover-page-appendix">
				<fo:repeatable-page-master-alternatives>
					<fo:conditional-page-master-reference master-reference="blankpage" blank-or-not-blank="blank"/>
					<fo:conditional-page-master-reference master-reference="simple-cover-page-appendix" odd-or-even="odd"/>
					<fo:conditional-page-master-reference master-reference="simple-cover-page-appendix" odd-or-even="even"/>
				</fo:repeatable-page-master-alternatives>
			</fo:page-sequence-master>
			
			<!-- Title page  -->
			<fo:simple-page-master master-name="simple-title-page" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="38mm" margin-bottom="25mm" margin-left="95mm" margin-right="12mm"/>
				<fo:region-before region-name="header" extent="38mm" />
				<fo:region-after extent="25mm"/>
				<fo:region-start extent="95mm"/>
				<fo:region-end extent="12mm"/>
			</fo:simple-page-master>
			
			<fo:page-sequence-master master-name="title-page">
				<fo:repeatable-page-master-alternatives>
					<fo:conditional-page-master-reference master-reference="blankpage" blank-or-not-blank="blank"/>
					<fo:conditional-page-master-reference master-reference="simple-title-page" odd-or-even="odd"/>
					<fo:conditional-page-master-reference master-reference="simple-title-page" odd-or-even="even"/>
				</fo:repeatable-page-master-alternatives>
			</fo:page-sequence-master>
			
			<!-- Document pages -->
			<fo:simple-page-master master-name="document-odd" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
				<fo:region-before region-name="header-odd" extent="{$marginTop}mm"/> 
				<fo:region-after region-name="footer" extent="{$marginBottom}mm"/> <!-- debug:  background-color="green" -->
				<fo:region-start region-name="left-region" extent="17mm"/>
				<fo:region-end region-name="right-region" extent="26.5mm"/>
			</fo:simple-page-master>
			<fo:simple-page-master master-name="document-even" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
				<fo:region-before region-name="header-even" extent="{$marginTop}mm"/> 
				<fo:region-after region-name="footer" extent="{$marginBottom}mm"/> <!-- debug:  background-color="green" -->
				<fo:region-start region-name="left-region" extent="17mm"/>
				<fo:region-end region-name="right-region" extent="26.5mm"/>
			</fo:simple-page-master>
			<fo:page-sequence-master master-name="document">
				<fo:repeatable-page-master-alternatives>						
					<fo:conditional-page-master-reference master-reference="blankpage" blank-or-not-blank="blank"/>
					<fo:conditional-page-master-reference odd-or-even="even" master-reference="document-even"/>
					<fo:conditional-page-master-reference odd-or-even="odd" master-reference="document-odd"/>
				</fo:repeatable-page-master-alternatives>
			</fo:page-sequence-master>
			
			<!-- Document pages (landscape orientation) -->
			<fo:simple-page-master master-name="document-landscape-odd" page-width="{$pageHeight}mm" page-height="{$pageWidth}mm">
				<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
				<fo:region-before region-name="header-odd" extent="{$marginTop}mm"/> 
				<fo:region-after region-name="footer" extent="{$marginBottom}mm"/> <!-- debug:  background-color="green" -->
				<fo:region-start region-name="left-region" extent="17mm"/>
				<fo:region-end region-name="right-region" extent="26.5mm"/>
			</fo:simple-page-master>
			<fo:simple-page-master master-name="document-landscape-even" page-width="{$pageHeight}mm" page-height="{$pageWidth}mm">
				<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
				<fo:region-before region-name="header-even" extent="{$marginTop}mm"/> 
				<fo:region-after region-name="footer" extent="{$marginBottom}mm"/> <!-- debug:  background-color="green" -->
				<fo:region-start region-name="left-region" extent="17mm"/>
				<fo:region-end region-name="right-region" extent="26.5mm"/>
			</fo:simple-page-master>
			<fo:page-sequence-master master-name="document-landscape">
				<fo:repeatable-page-master-alternatives>
					<fo:conditional-page-master-reference master-reference="blankpage" blank-or-not-blank="blank"/>
					<fo:conditional-page-master-reference odd-or-even="even" master-reference="document-landscape-even"/>
					<fo:conditional-page-master-reference odd-or-even="odd" master-reference="document-landscape-odd"/>
				</fo:repeatable-page-master-alternatives>
			</fo:page-sequence-master>
			
			<!-- Index pages -->
			<fo:simple-page-master master-name="index-odd" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="41.7mm" column-count="2" column-gap="10mm"/>
				<fo:region-before region-name="header-odd" extent="{$marginTop}mm"/> 
				<fo:region-after region-name="footer" extent="{$marginBottom}mm"/>
				<fo:region-start region-name="left-region" extent="17mm"/>
				<fo:region-end region-name="right-region" extent="26.5mm"/>
			</fo:simple-page-master>
			<fo:simple-page-master master-name="index-even" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="41.7mm" column-count="2" column-gap="10mm"/>
				<fo:region-before region-name="header-even" extent="{$marginTop}mm"/> 
				<fo:region-after region-name="footer" extent="{$marginBottom}mm"/>
				<fo:region-start region-name="left-region" extent="17mm"/>
				<fo:region-end region-name="right-region" extent="26.5mm"/>
			</fo:simple-page-master>
			<fo:page-sequence-master master-name="index">
				<fo:repeatable-page-master-alternatives>
					<fo:conditional-page-master-reference master-reference="blankpage" blank-or-not-blank="blank"/>
					<fo:conditional-page-master-reference odd-or-even="even" master-reference="index-even"/>
					<fo:conditional-page-master-reference odd-or-even="odd" master-reference="index-odd"/>
				</fo:repeatable-page-master-alternatives>
			</fo:page-sequence-master>
		</fo:layout-master-set>
	</xsl:template> <!-- END: layout-master-set -->
	
	<xsl:template match="/">
		<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format" xml:lang="{$lang}">
			<xsl:variable name="root-style">
				<root-style xsl:use-attribute-sets="root-style"/>
			</xsl:variable>
			<xsl:call-template name="insertRootStyle">
				<xsl:with-param name="root-style" select="$root-style"/>
			</xsl:call-template>
			
			<xsl:call-template name="layout-master-set"/>
			
			<fo:declarations>
				<xsl:call-template name="addPDFUAmeta"/>
				
				<xsl:if test="$add_math_as_attachment = 'true' and $final_transform = 'true'">
					<!-- DEBUG: mathml_attachments=<xsl:copy-of select="$mathml_attachments"/> -->
					<xsl:for-each select="xalan:nodeset($mathml_attachments)//attachment">
						
						<xsl:variable name="mathml_filename" select="@filename"/>
						<xsl:variable name="mathml_content" select="."/>
						
						<!-- <xsl:variable name="basepath" select="java:org.metanorma.fop.Util.saveFileToDisk($mathml_filename,$mathml_content)"/> -->
						
						<!-- <xsl:variable name="url" select="concat('url(file:',$basepath, ')')"/> -->
						
						<xsl:variable name="base64" select="java:org.metanorma.fop.Util.encodeBase64($mathml_content)"/>
						
						<xsl:variable name="url" select="concat('data:application/xml;base64,',$base64)"/>
						
						<!-- <xsl:if test="normalize-space($url) != ''"> -->
						<xsl:if test="normalize-space($base64) != ''">
							<pdf:embedded-file src="{$url}" filename="{$mathml_filename}"/>
						</xsl:if>
					</xsl:for-each>
				</xsl:if>
        
			</fo:declarations>
			
			<xsl:call-template name="addBookmarks">
				<xsl:with-param name="contents" select="$contents"/>
			</xsl:call-template>

			<xsl:if test="$debug = 'true'">
				<redirect:write file="contents_.xml">
					<xsl:copy-of select="$contents"/>
				</redirect:write>
			</xsl:if>
			
			<xsl:call-template name="cover-page"/>
			
			<xsl:choose>
				<xsl:when test="$root-element = 'metanorma-collection'">
					
					
					<xsl:choose>
						<xsl:when test="$doc_split_by_language = ''"><!-- all documents -->
							<xsl:for-each select="//mn:metanorma">
								<xsl:variable name="lang" select="mn:bibdata//mn:language[@current = 'true']"/>						
								<xsl:variable name="num"><xsl:number level="any" count="mn:metanorma"/></xsl:variable>
								
								<!-- <xsl:variable name="title_eref">
									<xsl:apply-templates select="." mode="title_eref"/>
								</xsl:variable> -->
								
								<xsl:variable name="update_xml_step1">
									<xsl:apply-templates select="." mode="update_xml_step1"/>
								</xsl:variable>
								
								<xsl:if test="$debug = 'true'">
									<redirect:write file="update_xml_step1.xml">
										<xsl:copy-of select="xalan:nodeset($update_xml_step1)"/>
									</redirect:write>
								</xsl:if>
								
								<xsl:message>START flatxml_</xsl:message>
								<xsl:variable name="startTime2" select="java:getTime(java:java.util.Date.new())"/>
								<xsl:variable name="flatxml__">
									<!-- <xsl:apply-templates select="xalan:nodeset($title_eref)" mode="flatxml"/> -->
									<!-- <xsl:apply-templates select="." mode="flatxml"/> -->
									<xsl:apply-templates select="xalan:nodeset($update_xml_step1)" mode="flatxml"/>
								</xsl:variable>
								<!-- save flatxml into the file and reload it -->
								<xsl:variable name="updated_flatxml_filename" select="concat($output_path,'_flatxml_', java:getTime(java:java.util.Date.new()), '.xml')"/>
								<redirect:write file="{$updated_flatxml_filename}">
									<xsl:copy-of select="xalan:nodeset($flatxml__)"/>
								</redirect:write>
								<xsl:variable name="flatxml_">
									<xsl:copy-of select="document($updated_flatxml_filename)"/>
								</xsl:variable>
								<xsl:call-template name="deleteFile">
									<xsl:with-param name="filepath" select="$updated_flatxml_filename"/>
								</xsl:call-template>
								<xsl:variable name="endTime2" select="java:getTime(java:java.util.Date.new())"/>
								
								<xsl:variable name="flatxml">
									<xsl:apply-templates select="xalan:nodeset($flatxml_)" mode="pagebreak"/>
								</xsl:variable>
								
								<!-- flatxml=<xsl:copy-of select="$flatxml"/> -->
								
								<xsl:apply-templates select="xalan:nodeset($flatxml)/mn:metanorma" mode="bipm-standard">
									<xsl:with-param name="curr_docnum" select="$num"/>
								</xsl:apply-templates>
								
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<xsl:for-each select="(//mn:metanorma)[mn:bibdata/mn:language[@current = 'true'] = $doc_split_by_language]">
								<xsl:variable name="lang" select="mn:bibdata//mn:language[@current = 'true']"/>						
								<xsl:variable name="num"><xsl:number level="any" count="mn:metanorma"/></xsl:variable>
								
								<!-- <xsl:variable name="title_eref">
									<xsl:apply-templates select="." mode="title_eref"/>
								</xsl:variable> -->
								
								<xsl:variable name="update_xml_step1">
									<xsl:apply-templates select="." mode="update_xml_step1"/>
								</xsl:variable>
								
								<xsl:if test="$debug = 'true'">
									<redirect:write file="update_xml_step1.xml">
										<xsl:copy-of select="xalan:nodeset($update_xml_step1)"/>
									</redirect:write>
								</xsl:if>
								
								<xsl:variable name="flatxml__">
									<!-- <xsl:apply-templates select="xalan:nodeset($title_eref)" mode="flatxml"/> -->
									<!-- <xsl:apply-templates select="." mode="flatxml"/> -->
									<xsl:apply-templates select="xalan:nodeset($update_xml_step1)" mode="flatxml"/>
								</xsl:variable>
								<!-- save flatxml into the file and reload it -->
								<xsl:variable name="updated_flatxml_filename" select="concat($output_path,'_flatxml_', java:getTime(java:java.util.Date.new()), '.xml')"/>
								<redirect:write file="{$updated_flatxml_filename}">
									<xsl:copy-of select="xalan:nodeset($flatxml__)"/>
								</redirect:write>
								<xsl:variable name="flatxml_">
									<xsl:copy-of select="document($updated_flatxml_filename)"/>
								</xsl:variable>
								<xsl:call-template name="deleteFile">
									<xsl:with-param name="filepath" select="$updated_flatxml_filename"/>
								</xsl:call-template>
								
								<xsl:variable name="flatxml">
									<xsl:apply-templates select="xalan:nodeset($flatxml_)" mode="pagebreak"/>
								</xsl:variable>
								
								<xsl:apply-templates select="xalan:nodeset($flatxml)/mn:metanorma" mode="bipm-standard">
									<xsl:with-param name="curr_docnum" select="$num"/>
								</xsl:apply-templates>
								
							</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose>
					
					
				</xsl:when>			
				<xsl:otherwise>
				
					<!-- <xsl:variable name="title_eref">
						<xsl:apply-templates mode="title_eref"/>
					</xsl:variable> -->
					
					<xsl:variable name="update_xml_step1">
						<xsl:apply-templates mode="update_xml_step1"/>
					</xsl:variable>
					
					<xsl:if test="$debug = 'true'">
						<redirect:write file="update_xml_step1.xml">
							<xsl:copy-of select="xalan:nodeset($update_xml_step1)"/>
						</redirect:write>
					</xsl:if>
					
					<xsl:variable name="flatxml__">
						<!-- <xsl:apply-templates select="xalan:nodeset($title_eref)" mode="flatxml"/> -->
						<!-- <xsl:apply-templates select="." mode="flatxml"/> -->
						<xsl:apply-templates select="xalan:nodeset($update_xml_step1)" mode="flatxml"/>
					</xsl:variable>

					<!-- save flatxml into the file and reload it -->
					<xsl:variable name="updated_flatxml_filename" select="concat($output_path,'_flatxml_', java:getTime(java:java.util.Date.new()), '.xml')"/>
					<redirect:write file="{$updated_flatxml_filename}">
						<xsl:copy-of select="xalan:nodeset($flatxml__)"/>
					</redirect:write>
					<xsl:variable name="flatxml_">
						<xsl:copy-of select="document($updated_flatxml_filename)"/>
					</xsl:variable>
					<xsl:call-template name="deleteFile">
						<xsl:with-param name="filepath" select="$updated_flatxml_filename"/>
					</xsl:call-template>

					<xsl:variable name="flatxml">
						<xsl:apply-templates select="xalan:nodeset($flatxml_)" mode="pagebreak"/>
					</xsl:variable>
					
					<!-- flatxml=<xsl:copy-of select="$flatxml"/> -->
					
					<!-- indexes=<xsl:copy-of select="$indexes"/> -->
					
				
					<xsl:if test="$debug = 'true'">
						<redirect:write file="flatxml.xml">
							<xsl:copy-of select="$flatxml"/>
						</redirect:write>
					</xsl:if>
				
					<xsl:apply-templates select="xalan:nodeset($flatxml)/mn:metanorma" mode="bipm-standard">
						<xsl:with-param name="curr_docnum" select="1"/>
					</xsl:apply-templates>
				</xsl:otherwise>
			</xsl:choose>
			
			
		</fo:root>
	</xsl:template>
	
	<!-- ================================= -->
	<!-- Move eref inside title -->
	<!-- ================================= -->	
	<!-- <xsl:template match="@*|node()" mode="title_eref">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="title_eref"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="mn:fmt-title[following-sibling::*[1][self::mn:eref]]" mode="title_eref">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="title_eref"/>
			- - move next eref inside title - -
			<xsl:copy-of select="following-sibling::*[1][self::mn:eref]"/>
		</xsl:copy>
	</xsl:template>
	- - remove eref immediately after title - -
	<xsl:template match="mn:eref[preceding-sibling::*[1][self::mn:fmt-title]]" mode="title_eref"/> -->
	<!-- ================================= -->
	<!-- END Move eref inside title -->
	<!-- ================================= -->	
	
	
	<xsl:template match="mn:clause/mn:fmt-footnote-container" priority="3" mode="update_xml_step1"/>
	
	<xsl:template match="mn:li/mn:fmt-name" priority="3" mode="update_xml_step1">
		<xsl:choose>
			<!-- no need li labels in BIPM brochure preface -->
			<xsl:when test="ancestor::*[mn:preface] and ancestor::mn:clause[not(@type = 'toc')]"></xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="label"><xsl:value-of select="."/></xsl:attribute>
				<xsl:attribute name="full">true</xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="mn:span[@class = 'fmt-label-delim']" priority="2" mode="update_xml_step1">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- ================================= -->
	<!-- Flattening xml for fit notes at page sides (margins) -->
	<!-- ================================= -->	
	<xsl:template match="@*|node()" mode="flatxml">
		<xsl:copy>
			<xsl:if test="ancestor::mn:quote">
				<xsl:attribute name="parent-type">quote</xsl:attribute>				
			</xsl:if>
			<xsl:apply-templates select="@*|node()" mode="flatxml"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="mn:semantic__bipm-standard" mode="flatxml" priority="2"/>
	
	<xsl:template match="mathml:math" mode="flatxml" priority="2">
		<xsl:copy-of select="."/>
	</xsl:template>

	<!-- split math by element with @linebreak into maths -->
	<xsl:template match="mathml:math[.//mathml:mo[@linebreak] or .//mathml:mspace[@linebreak]]" mode="flatxml" priority="3">
		<xsl:variable name="maths">
			<xsl:apply-templates select="." mode="mathml_linebreak"/>
		</xsl:variable>
		<xsl:copy-of select="$maths"/>
	</xsl:template>

	<xsl:template match="mn:preface/mn:clause[@type = 'toc']" mode="flatxml" priority="2"/>

	<!-- enclosing starting elements annex/... in clause -->
	<xsl:template match="mn:annex" mode="flatxml">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="flatxml"/>
			
				<xsl:variable name="pos_first_clause_" select="count(mn:clause[1]/preceding-sibling::*)"/>
			
				<xsl:variable name="pos_first_clause">
					<xsl:choose>
						<xsl:when test="$pos_first_clause_ = 0">
							<xsl:value-of select="count(*)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$pos_first_clause_"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:choose>
				
						<xsl:when test="$pos_first_clause &gt; 0">
							<xsl:element name="clause" namespace="{$namespace_full}">
								<xsl:attribute name="id"><xsl:value-of select="concat(@id,'_clause')"/></xsl:attribute>
								<xsl:for-each select="*[position() &gt; 0 and position() &lt;= $pos_first_clause]">
									<xsl:apply-templates select="." mode="flatxml"/>									
								</xsl:for-each>								
							</xsl:element>
							<xsl:for-each select="*[position() &gt; $pos_first_clause]">
								<xsl:apply-templates select="." mode="flatxml"/>									
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates mode="flatxml"/>
						</xsl:otherwise>
				</xsl:choose>
		
		</xsl:copy>
	</xsl:template>

	<xsl:template match="mn:annex/mn:fmt-title" mode="flatxml">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="flatxml"/>
			<xsl:attribute name="depth">1</xsl:attribute>
			<xsl:apply-templates mode="flatxml"/>
		</xsl:copy>
	</xsl:template>
	

	<!-- flattening clauses from 2nd level -->
	<xsl:template match="mn:clause[not(parent::mn:sections) and not(parent::mn:annex) and not(parent::mn:preface) and not(ancestor::mn:boilerplate)]" mode="flatxml">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="flatxml"/>
			
		</xsl:copy>		
		<xsl:apply-templates mode="flatxml"/>
	</xsl:template>
	
	
	<!-- move note(s) inside element -->
	<!-- but ignore quote, move inside element which before quote -->
	<xsl:template match="mn:clause/*
		[not(self::mn:quote)]
		[following-sibling::*
			[not(self::mn:quote)]
			[1][self::mn:note]]"  mode="flatxml"> <!-- find element, which has next 'note' -->
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="flatxml"/>
			<xsl:variable name="element-id" select="generate-id(.)"/>
			<xsl:for-each select="following-sibling::mn:note[generate-id(preceding-sibling::*[not(self::mn:note) and not(self::mn:quote)][1]) = $element-id]">			
				<xsl:call-template name="change_note_kind"/>
			</xsl:for-each>
			
			<!-- if current node is title level is 3 with notes, and next level is 4 -->
			<xsl:if test="self::mn:fmt-title and @depth = 3 and
						../mn:clause/mn:fmt-title/@depth = 4 and count(following-sibling::*[1][self::mn:note]) &gt; 0">
				<!-- then move here footnotes from clause level 4 -->
				<xsl:for-each select="../mn:clause//mn:fn[ancestor::mn:quote or not(ancestor::mn:table)]"> 
					<!-- <debug><xsl:for-each select="ancestor::*"><xsl:value-of select="local-name()"/>@<xsl:value-of select="@id"/><xsl:text>/</xsl:text></xsl:for-each>
					</debug> -->
					<xsl:call-template name="fn_to_note_side"/>
				</xsl:for-each>
			</xsl:if>
			
		</xsl:copy>
	</xsl:template>
	
	<!-- remove note(s), which was moved into element in previous template -->
	<xsl:template match="mn:clause/mn:note" mode="flatxml" priority="2"/>
	
	
	<!-- move clause/note inside title, p, ul or ol -->
	<xsl:template match="mn:clause2/*[local-name() != 'quote' and local-name() != 'note' and local-name() != 'clause'][last()]" mode="flatxml">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="flatxml"/>
			
			<xsl:for-each select="following-sibling::mn:note">
				<xsl:call-template name="change_note_kind"/>
			</xsl:for-each>
			<xsl:if test="@depth = 3 and local-name() = 'fmt-title' and ../mn:clause/mn:fmt-title/@depth = 4 and count(following-sibling::*[1][local-name() = 'note']) &gt; 0"> <!-- it means that current node is title level is 3 with notes, next level is 4 -->
				<!-- <put_note_side_level4_here/> -->
				<xsl:for-each select="../mn:clause//mn:fn[ancestor::mn:quote or not(ancestor::mn:table)]"> <!-- move here footnotes from clause level 4 -->
					<xsl:call-template name="fn_to_note_side"/>
				</xsl:for-each>
			</xsl:if>
		</xsl:copy>	
	</xsl:template>
		
	
	<xsl:template match="mn:note[not(parent::mn:preface)]" name="change_note_kind" mode="flatxml">
		<xsl:variable name="element">
			<xsl:choose>
				<xsl:when test="ancestor::mn:quote">note</xsl:when>
				<xsl:when test="ancestor::mn:preface and ancestor::mn:table">note</xsl:when>
				<xsl:otherwise>note_side</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!-- <xsl:copy> -->
		<xsl:element name="{$element}" namespace="{$namespace_full}">
			<xsl:if test="ancestor::mn:quote">
				<xsl:attribute name="parent-type">quote</xsl:attribute>				
			</xsl:if>
			<xsl:apply-templates select="@*|node()" mode="flatxml"/>
		</xsl:element>
		<!-- </xsl:copy> -->
	</xsl:template>
	
	
	<!-- change fn to xref with asterisks --> <!-- all fn except fn in table (but not quote table) -->
	<xsl:template match="mn:fn[ancestor::mn:quote or not(ancestor::mn:table)]" mode="flatxml">
		<xsl:choose>		
			<!-- see template above with @depth = 4 -->
			<xsl:when test="ancestor::mn:clause[1]/mn:fmt-title/@depth = 4 and 																
																count(ancestor::mn:clause[2]/mn:fmt-title[@depth = 3]/following-sibling::*[1][self::mn:note]) &gt; 0">
				<xsl:apply-templates select="." mode="fn_to_xref"/>
			</xsl:when>
			<xsl:when test="ancestor::mn:li">
				<xsl:apply-templates select="." mode="fn_to_xref"/> <!-- displays asterisks with link to side note -->
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="fn_to_xref"/> <!-- displays asterisks with link to side note -->
				<xsl:call-template name="fn_to_note_side"/> <!-- convert footnote to side note with asterisk at start  -->
			</xsl:otherwise>
		</xsl:choose>		
	</xsl:template>
	
	<!-- change fn to xref with asterisks --> <!-- all fn except fn in table (but not quote table) -->
	<xsl:template match="mn:fn[ancestor::mn:quote or not(ancestor::mn:table)]" mode="flatxml_list">
		<xsl:choose>
			<!-- see template above with @depth = 4 -->
			<xsl:when test="ancestor::mn:clause[1]/mn:fmt-title/@depth = 4 and 																
																count(ancestor::mn:clause[2]/mn:fmt-title[@depth = 3]/following-sibling::*[1][self::mn:note]) &gt; 0">
				<xsl:apply-templates select="." mode="fn_to_xref"/>
			</xsl:when>
			<xsl:when test="ancestor::mn:li">
				<xsl:apply-templates select="." mode="fn_to_xref"/> <!-- displays asterisks with link to side note -->	
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="fn_to_xref"/>  <!-- displays asterisks with link to side note -->
				<xsl:call-template name="fn_to_note_side"/> <!-- convert footnote to side note with asterisk at start  -->					
				
			</xsl:otherwise>
		</xsl:choose>		
	</xsl:template>
	
	<xsl:template match="mn:fn" mode="fn_to_xref">
		<xsl:element name="fmt-xref" namespace="{$namespace_full}">
			
			<xsl:copy-of select="@target"/>
			
			<xsl:element name="sup_fn" namespace="{$namespace_full}">
				<!-- <xsl:value-of select="concat('(',$number,')')"/> -->
			<!-- https://github.com/metanorma/isodoc/issues/658#issuecomment-2726450824 -->
			<xsl:apply-templates select="mn:fmt-fn-label/node()" mode="flatxml"/>
			</xsl:element>
			
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="mn:preface/mn:clause[not(@type = 'toc')][position() &gt; 1]" mode="flatxml">
		<xsl:copy-of select="."/>
	</xsl:template>
	
	<xsl:template match="mn:quote" mode="flatxml" priority="2">
		<xsl:apply-templates mode="flatxml"/>
	</xsl:template>
	
	
	<!-- flat lists -->
	<xsl:template match="mn:ul | mn:ol" mode="flatxml" priority="2">
		<xsl:apply-templates mode="flatxml_list"/>
	</xsl:template>

	<xsl:template match="@*|node()" mode="flatxml_list">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="flatxml_list"/>
		</xsl:copy>
	</xsl:template>	
	
	<xsl:template match="mathml:math" mode="flatxml_list" priority="2">
		<xsl:copy-of select="."/>
	</xsl:template>
	
	<!-- copy 'ol' 'ul' properties to each 'li' -->
	<!-- OBSOLETE: move note for list (list level note)  into latest 'li' -->
	<!-- NOW: move note for list (list level note)  into first 'li' -->
	<!-- move fn for list-item (list-item level footnote)  into first 'li' -->	
	<xsl:template match="mn:li" mode="flatxml_list">	
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="flatxml_list"/>
			<xsl:attribute name="list_type">
				<xsl:value-of select="local-name(..)"/>
			</xsl:attribute>
			
			<xsl:call-template name="setListItemLabel"/>
			
			<xsl:if test="ancestor::mn:quote">
				<xsl:attribute name="parent-type">quote</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates mode="flatxml_list"/>
			
			
			<!-- if current li is first -->
			<xsl:if test="not(preceding-sibling::mn:li)">
				
				<xsl:if test="not(ancestor::mn:quote)">
					<!-- move note for list (list level note) into first 'li' -->
					<xsl:for-each select="following-sibling::mn:li[last()]/following-sibling::*">
						<xsl:choose>
							<xsl:when test="self::mn:note">
								<xsl:call-template name="change_note_kind"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:copy-of select="."/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				
					<!-- move note(s) after ul/ol into first 'li' -->
					<xsl:variable name="list_id" select="generate-id(..)"/>
					<xsl:for-each select="../following-sibling::mn:note[generate-id(preceding-sibling::*[not(self::mn:note) and not(self::mn:quote)][1]) = $list_id]">			
						<xsl:call-template name="change_note_kind"/>
					</xsl:for-each>
				</xsl:if>
				
			
				<xsl:if test="ancestor::mn:quote or not(ancestor::mn:table)">
				
					<xsl:choose>
						<!-- see template above with @depth = 4 -->
						<xsl:when test="ancestor::mn:clause[1]/mn:fmt-title/@depth = 4 and 																
																count(ancestor::mn:clause[2]/mn:fmt-title[@depth = 3]/following-sibling::*[1][self::mn:note]) &gt; 0"></xsl:when>
						<xsl:otherwise>
				
							<!-- move all footnotes in the current list (not only current list item) into first 'li' -->
							<xsl:variable name="curr_list_id" select="../@id"/>
							<xsl:for-each select="..//mn:fn[ancestor::mn:ol[1]/@id = $curr_list_id or ancestor::mn:ul[1]/@id = $curr_list_id]">
								<xsl:call-template name="fn_to_note_side" />
							</xsl:for-each>
							
						</xsl:otherwise>
					</xsl:choose>
					
				</xsl:if>
				
			</xsl:if>
			
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="mn:note[ancestor::mn:quote]" mode="flatxml_list">
		<xsl:copy>
			<xsl:attribute name="parent-type">quote</xsl:attribute>
			<xsl:apply-templates select="@*|node()" mode="flatxml_list"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template name="fn_to_note_side">
		<xsl:variable name="target" select="@target"/>
		<xsl:choose>
			<!-- skip side note, see the comment https://github.com/metanorma/isodoc/issues/658#issuecomment-2768874528: -->
			<!-- every repeated footnote is only rendered at the first instance -->
			<xsl:when test="preceding::*[@target = $target]"></xsl:when>
			<xsl:otherwise>
				<xsl:element name="note_side" namespace="{$namespace_full}">
			
					<xsl:attribute name="id">
						<xsl:value-of select="@target"/>
					</xsl:attribute>
					
					<xsl:variable name="curr_id" select="@target"/>
					
					<xsl:element name="sup_fn" namespace="{$namespace_full}">
						<!-- <xsl:value-of select="concat('(',$number,')')"/> -->
						<!-- https://github.com/metanorma/isodoc/issues/658#issuecomment-2726450824 -->
						<xsl:apply-templates select="mn:fmt-fn-label/node()" mode="flatxml"/>
					</xsl:element>
					<xsl:text> </xsl:text>
					
					<!-- <xsl:apply-templates mode="flatxml"/> -->
					<xsl:apply-templates select="$footnotes/mn:fmt-fn-body[@id = $curr_id]/node()" mode="flatxml"/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- remove latest elements (after li), because they moved into latest 'li' -->
	<xsl:template match="mn:ul/*[not(self::mn:li) and not(following-sibling::mn:li) and not(ancestor::mn:quote)]" mode="flatxml_list"/>
	<xsl:template match="mn:ol/*[not(self::mn:li) and not(following-sibling::mn:li) and not(ancestor::mn:quote)]" mode="flatxml_list"/>
	
	<xsl:template name="setListItemLabel">
		<xsl:attribute name="label">
			<xsl:call-template name="getListItemFormat"/>
		</xsl:attribute>
		<xsl:choose>
			<xsl:when test="parent::mn:ul and ../ancestor::mn:ul"></xsl:when> <!-- &#x2014; dash -->
			<xsl:when test="parent::mn:ul">
				<xsl:attribute name="font-size">15pt</xsl:attribute>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="mn:indexsect" mode="flatxml"/>
	
	<xsl:template match="mn:passthrough" mode="flatxml">
		<!-- <xsl:if test="contains(@formats, 'pdf')">  -->
		<xsl:if test="normalize-space(java:matches(java:java.lang.String.new(@formats), $regex_passthrough)) = 'true'">
			<xsl:apply-templates  mode="flatxml"/>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="mn:fn/mn:fmt-fn-label//mn:sup" priority="5" mode="flatxml">
		<xsl:apply-templates mode="flatxml"/>
	</xsl:template>
	
	<!-- ================================= -->
	<!-- END: Flattening xml for fit notes at page sides (margins) -->
	<!-- ================================= -->	
	
	<!-- ================================= -->
	<!-- Page breaks processing (close previous elements (clause) and start new) -->
	<!-- ================================= -->	
	<xsl:template match="@*|node()" mode="pagebreak">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="pagebreak"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="node()[mn:pagebreak[@orientation]]" mode="pagebreak">
		<xsl:variable name="element_name" select="local-name()"/>
		<xsl:for-each select="mn:pagebreak[@orientation]">
			<xsl:variable name="pagebreak_id" select="generate-id()"/>
			<xsl:variable name="pagebreak_previous_orientation" select="preceding-sibling::mn:pagebreak[@orientation][1]/@orientation"/>
			
			<!-- copy elements before page break -->
			<xsl:element name="{$element_name}" namespace="{$namespace_full}">
				<xsl:if test="not(preceding-sibling::mn:pagebreak[@orientation])">
					<xsl:apply-templates select="../@*" mode="pagebreak"/>
				</xsl:if>
				<xsl:if test="$pagebreak_previous_orientation != ''">
					<xsl:attribute name="orientation"><xsl:value-of select="$pagebreak_previous_orientation"/></xsl:attribute>
				</xsl:if>
				
				<xsl:apply-templates select="preceding-sibling::node()[following-sibling::mn:pagebreak[@orientation][1][generate-id(.) = $pagebreak_id]][not(local-name() = 'pagebreak' and @orientation)]" mode="pagebreak"/>
			</xsl:element>
			
			<!-- copy elements after last page break -->
			<xsl:if test="position() = last() and following-sibling::node()">
				<xsl:element name="{$element_name}" namespace="{$namespace_full}">
					<xsl:attribute name="orientation"><xsl:value-of select="@orientation"/></xsl:attribute>
					<xsl:apply-templates select="following-sibling::node()" mode="pagebreak"/>
				</xsl:element>
			</xsl:if>
			
		</xsl:for-each>
		
	</xsl:template>
	
	<!-- ================================= -->
	<!-- END: Page breaks processing  -->
	<!-- ================================= -->	
	
	<xsl:template match="mn:metanorma"/>
	<xsl:template match="mn:metanorma" mode="bipm-standard">
		<xsl:param name="curr_docnum"/>
		<xsl:variable name="curr_xml">
			<xsl:copy-of select="."/>
		</xsl:variable>
		
		<xsl:variable name="curr_lang" select="mn:bibdata/mn:language[@current = 'true']"/>
		
		<xsl:choose>
			<xsl:when test="$independentAppendix = '' and not($doctype = 'guide')">
			
				<!-- Document pages -->
				<fo:page-sequence master-reference="document" force-page-count="no-force">
					<!-- initial page number for English section -->
					<xsl:if test="$initial_page_number != ''">
						<xsl:attribute name="initial-page-number">
							<xsl:value-of select="$initial_page_number"/>
						</xsl:attribute>
					</xsl:if>
					
					<xsl:call-template name="insertFootnoteSeparator"/>
					
					<xsl:call-template name="insertHeaderDraftWatermark">
						<xsl:with-param name="lang" select="$curr_lang"/>
					</xsl:call-template>
					
					<fo:flow flow-name="xsl-region-body" font-family="Arial">
						
						<fo:block-container font-size="12pt" font-weight="bold" border-top="1pt solid black" width="82mm" margin-top="2mm" padding-top="2mm">						
							<fo:block-container width="45mm">
								<fo:block>
									<xsl:value-of select="mn:bibdata/mn:contributor[mn:role/@type='publisher']/mn:organization/mn:name"/>
								</fo:block>						
							</fo:block-container>
						</fo:block-container>
						
						<fo:block-container font-size="12pt" line-height="130%">
							<fo:block margin-bottom="10pt" >&#xA0;</fo:block>
							<fo:block margin-bottom="10pt" >&#xA0;</fo:block>
							<fo:block margin-bottom="10pt" >&#xA0;</fo:block>
							<fo:block margin-bottom="10pt" >&#xA0;</fo:block>
							<fo:block margin-bottom="10pt" >&#xA0;</fo:block>
							<fo:block margin-bottom="10pt" >&#xA0;</fo:block>
							<fo:block margin-bottom="10pt" >&#xA0;</fo:block>
							<fo:block margin-bottom="10pt" >&#xA0;</fo:block>
							<fo:block margin-bottom="10pt" >&#xA0;</fo:block>
						</fo:block-container>
						
						<fo:block-container font-size="18pt" font-weight="bold" text-align="center">
							<fo:block role="H1">						
								<xsl:value-of select="//mn:metanorma/mn:bibdata/mn:title[@language = $curr_lang and @type='title-cover']"/>
							</fo:block>	
						</fo:block-container>
						
						<fo:block-container absolute-position="fixed" left="69.5mm" top="241mm" width="99mm">						
							<fo:block-container font-size="9pt" border-bottom="1pt solid black" width="68mm" text-align="center" margin-bottom="14pt">
								<fo:block font-weight="bold" margin-bottom="2.5mm">
									<fo:inline padding-right="10mm">
										<xsl:apply-templates select="mn:bibdata/mn:edition[normalize-space(@language) = '']">
											<xsl:with-param name="font-size" select="'70%'"/>
											<xsl:with-param name="baseline-shift" select="'45%'"/>
											<xsl:with-param name="curr_lang" select="$curr_lang"/>
										</xsl:apply-templates>
									</fo:inline>
									<xsl:value-of select="$copyrightYear"/>
								</fo:block>
							</fo:block-container>
							<fo:block font-size="9pt">
								<fo:block>&#xA0;</fo:block>
								<fo:block>&#xA0;</fo:block>
								<fo:block>&#xA0;</fo:block>							
								<fo:block text-align="right"><xsl:value-of select="mn:bibdata/mn:version/mn:draft"/></fo:block>						
							</fo:block>
						</fo:block-container>
						
						<fo:block break-after="page"/>
						
						<xsl:apply-templates select="mn:boilerplate/mn:license-statement"/>
						
						<fo:block-container absolute-position="fixed" top="200mm" height="69mm" font-family="Times New Roman" text-align="center" display-align="after">
							<fo:block>
								<xsl:apply-templates select="mn:boilerplate/mn:feedback-statement"/>
								<xsl:variable name="ISBN" select="normalize-space(mn:bibdata/mn:docidentifier[@type='ISBN'])"/>
								<xsl:if test="$ISBN != ''">
									<fo:block margin-top="15mm">
										<xsl:text>ISBN </xsl:text><xsl:value-of select="$ISBN"/>
									</fo:block>
								</xsl:if>
							</fo:block>
						</fo:block-container>
						
					</fo:flow>
				</fo:page-sequence>
				
				
				<xsl:if test="mn:preface/*[not(self::mn:note or self::mn:admonition)]">
					<fo:page-sequence master-reference="document" force-page-count="no-force">
						<xsl:call-template name="insertFootnoteSeparator"/>
						
						<xsl:variable name="header-title">
							<xsl:choose>
								<xsl:when test="mn:preface/*[not(self::mn:note or self::mn:admonition)][1]/mn:fmt-title[1]/mn:tab">
									<xsl:apply-templates select="mn:preface/*[not(self::mn:note or self::mn:admonition)][1]/mn:fmt-title[1]/mn:tab[1]/following-sibling::node()" mode="header"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:apply-templates select="mn:preface/*[not(self::mn:note or self::mn:admonition)][1]/mn:fmt-title[1]" mode="header"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:call-template name="insertHeaderFooter">
							<xsl:with-param name="header-title" select="$header-title"/>
						</xsl:call-template>
						
						<fo:flow flow-name="xsl-region-body">
							<fo:block line-height="135%">
								<xsl:apply-templates select="mn:preface/*[not(self::mn:note or self::mn:admonition)][1]" />
							</fo:block>
						</fo:flow>
					</fo:page-sequence>
				</xsl:if>

				
				<xsl:variable name="docid">
					<xsl:call-template name="getDocumentId"/>
				</xsl:variable>
				
				<fo:page-sequence master-reference="document" force-page-count="no-force">
					<xsl:call-template name="insertFootnoteSeparator"/>
					
					<xsl:variable name="title-toc">
						<fo:inline>
							<xsl:call-template name="getLocalizedString">
								<xsl:with-param name="key">table_of_contents</xsl:with-param>
							</xsl:call-template>
						</fo:inline>
					</xsl:variable>
					<xsl:call-template name="insertHeaderFooter">
						<xsl:with-param name="header-title"><xsl:value-of select="$title-toc"/></xsl:with-param>
					</xsl:call-template>
					
					<fo:flow flow-name="xsl-region-body">
					
						<!-- <fo:block-container margin-left="-14mm"  margin-right="0mm">
							<fo:block-container margin-left="0mm" margin-right="0mm"> -->
								<fo:block xsl:use-attribute-sets="toc-title-style">
									<fo:inline><xsl:value-of select="//mn:metanorma/mn:bibdata/mn:title[@language = $curr_lang and @type='title-main']"/></fo:inline>
									<fo:inline keep-together.within-line="always">
										<fo:leader leader-pattern="space"/>
										<fo:inline>
											<xsl:value-of select="$title-toc"/>
										</fo:inline>
									</fo:inline>
								</fo:block>
							<!-- </fo:block-container>
						</fo:block-container> -->
					
						<fo:block-container xsl:use-attribute-sets="toc-style">
							<fo:block role="TOC">
								<!-- <xsl:copy-of select="$contents"/> -->
								
								<xsl:if test="$contents/mnx:doc[@id = $docid]//mnx:item[@display='true']">
									<fo:table table-layout="fixed" width="100%" id="__internal_layout__toc_{generate-id()}" role="SKIP">
										<fo:table-column column-width="127mm"/>
										<fo:table-column column-width="12mm"/>
										<fo:table-body role="SKIP">											
											<xsl:for-each select="$contents/mnx:doc[@id = $docid]//mnx:item[@display='true' and not(@type = 'annex') and not(@type = 'index') and not(@parent = 'annex')]">
												<xsl:call-template name="insertContentItem"/>								
											</xsl:for-each>
											<!-- insert page break between main sections and appendixes in ToC -->
											<!-- <xsl:if test="$doctype ='brochure'">
												<fo:table-row>
													<fo:table-cell number-columns-spanned="2">
														<fo:block break-after="page"/>
													</fo:table-cell>
												</fo:table-row>
											</xsl:if> -->
											<xsl:for-each select="$contents/mnx:doc[@id = $docid]//mnx:item[@display='true' and (@type = 'annex')]"> <!--  or (@level = 2 and @parent = 'annex') -->
												<xsl:call-template name="insertContentItem">
													<xsl:with-param name="keep-with-next">true</xsl:with-param>
												</xsl:call-template>
											</xsl:for-each>
											<xsl:for-each select="$contents/mnx:doc[@id = $docid]//mnx:item[@display='true' and (@type = 'index')]">
												<xsl:call-template name="insertContentItem"/>								
											</xsl:for-each>
											
											<!-- List of Tables -->
											<xsl:if test="$contents/mnx:doc[@id = $docid]//mnx:tables/mnx:table">
												<xsl:call-template name="insertListOf_Title">
													<xsl:with-param name="title" select="$title-list-tables"/>
												</xsl:call-template>
												<xsl:for-each select="$contents/mnx:doc[@id = $docid]//mnx:tables/mnx:table">
													<xsl:call-template name="insertListOf_Item"/>
												</xsl:for-each>
											</xsl:if>
											
											<!-- List of Figures -->
											<xsl:if test="$contents/doc[@id = $docid]//mnx:figures/mnx:figure">
												<xsl:call-template name="insertListOf_Title">
													<xsl:with-param name="title" select="$title-list-figures"/>
												</xsl:call-template>
												<xsl:for-each select="$contents/mnx:doc[@id = $docid]//mnx:figures/mnx:figure">
													<xsl:call-template name="insertListOf_Item"/>
												</xsl:for-each>
											</xsl:if>
											
										</fo:table-body>
									</fo:table>
								</xsl:if>
							</fo:block>
						</fo:block-container>
				
					</fo:flow>
					
				</fo:page-sequence>
				
				
				<xsl:apply-templates select="mn:preface/*[not(self::mn:note or self::mn:admonition)][position() &gt; 1]" mode="sections" /> <!-- mn:clause -->
				
				
				
				<!-- Document Pages -->
				<xsl:apply-templates select="mn:sections/*" mode="sections" />
				
				
				<!-- Normative references  -->
				
				<xsl:apply-templates select="mn:bibliography/mn:references[@normative='true']" mode="sections"/>

				<xsl:apply-templates select="mn:annex" mode="sections"/>
				
				<!-- Bibliography -->
				<xsl:if test="mn:bibliography/mn:references[not(@normative='true')][not(@hidden='true')]/mn:bibitem[not(contains(mn:docidentifier, 'si-brochure-'))]">
					<xsl:apply-templates select="mn:bibliography/mn:references[not(@normative='true')]" mode="sections"/> 
				</xsl:if>
				
				<!-- Document Control -->
				<xsl:apply-templates select="mn:doccontrol | mn:colophon" mode="sections"/> 
				
				<!-- Index -->
				<xsl:apply-templates select="xalan:nodeset($indexes)/doc[@id = $docid]//mn:indexsect" mode="index">
					<xsl:with-param name="isDraft" select="normalize-space(//mn:metanorma/mn:bibdata/mn:version/mn:draft or
						contains(//mn:metanorma/mn:bibdata/mn:status/mn:stage, 'draft') or
						contains(//mn:metanorma/mn:bibdata/mn:status/mn:stage, 'projet'))"/>
					<xsl:with-param name="lang" select="$curr_lang"/>
				</xsl:apply-templates>
				
				<!-- End Document Pages -->
				
				
				<xsl:if test="($doc_split_by_language = '' and $curr_docnum = 1) or $doc_split_by_language = $doc_first_language">
					<xsl:call-template name="insertSeparatorPage"/>
				</xsl:if>
		
			</xsl:when> <!-- EMD: $independentAppendix = '' and not($doctype = 'guide') -->
			<xsl:otherwise> <!-- independentAppendix != '' -->
			
		
				<xsl:variable name="docid">
					<xsl:call-template name="getDocumentId"/>
				</xsl:variable>
				
				<fo:page-sequence master-reference="document" force-page-count="no-force">
					
					<xsl:call-template name="insertHeaderDraftWatermark"/>
					
					<fo:flow flow-name="xsl-region-body" font-family="Arial">
						
						<fo:block-container font-size="12pt" font-weight="bold" border-top="1pt solid black" width="82mm" margin-top="2mm" padding-top="2mm">						
							<fo:block-container width="45mm">
								<fo:block>
									<xsl:value-of select="mn:bibdata/mn:contributor[mn:role/@type='publisher']/mn:organization/mn:name"/>
								</fo:block>						
							</fo:block-container>
						</fo:block-container>
						
						<fo:block-container font-size="12pt" line-height="130%">
							<fo:block margin-bottom="10pt" >&#xA0;</fo:block>
							<fo:block margin-bottom="10pt" >&#xA0;</fo:block>
							<fo:block margin-bottom="10pt" >&#xA0;</fo:block>
							<fo:block margin-bottom="10pt" >&#xA0;</fo:block>
							<fo:block margin-bottom="10pt" >&#xA0;</fo:block>
							<fo:block margin-bottom="10pt" >&#xA0;</fo:block>
							<fo:block margin-bottom="10pt" >&#xA0;</fo:block>
							<fo:block margin-bottom="10pt" >&#xA0;</fo:block>
							<fo:block margin-bottom="10pt" >&#xA0;</fo:block>
						</fo:block-container>
						
						<fo:block-container font-size="18pt" font-weight="bold" text-align="center">
							<fo:block role="H1">
								
								<xsl:choose>
									<xsl:when test="$independentAppendix != ''">
										<xsl:apply-templates select="//mn:metanorma/mn:bibdata/mn:title[@language = $curr_lang and @type='title-appendix']" mode="title"/>
										<fo:block>
											<xsl:apply-templates select="//mn:metanorma/mn:bibdata/mn:title[@language = $curr_lang and @type='title-annex']" mode="title"/>
										</fo:block>
									</xsl:when>
									<xsl:otherwise> <!-- doctype = 'guide' -->
										<xsl:apply-templates select="//mn:metanorma/mn:bibdata/mn:title[@language = $curr_lang and @type='title-main']" mode="title"/>
									</xsl:otherwise>
								</xsl:choose>
								
								
							</fo:block>
							
							
							<!-- <xsl:variable name="part_num" select="normalize-space(/mn:metanorma/mn:bibdata/mn:ext/mn:structuredidentifier/mn:part)"/> -->
							<xsl:if test="/mn:metanorma/mn:bibdata/mn:title[@language = $curr_lang and @type = 'title-part-with-numbering']">
								<fo:block role="H2">
									<!-- <xsl:if test="$part_num != ''">
										<xsl:call-template name="getLocalizedString">
											<xsl:with-param name="key">Part.sg</xsl:with-param>
											<xsl:with-param name="lang" select="$curr_lang"/>
										</xsl:call-template>
										<xsl:text> </xsl:text>
										<xsl:value-of select="$part_num"/>
									</xsl:if>
									<xsl:text>: </xsl:text> -->
									<xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:title[@language = $curr_lang and @type = 'title-part-with-numbering']" mode="title"/>
								</fo:block>
							</xsl:if>
							<!-- <xsl:variable name="subpart_num" select="normalize-space(/mn:metanorma/mn:bibdata/mn:ext/mn:structuredidentifier/mn:subpart)"/> -->
							<xsl:if test="/mn:metanorma/mn:bibdata/mn:title[@language = $curr_lang and @type = 'title-subpart-with-numbering']">
								<fo:block role="H3">
									<!-- <xsl:if test="$subpart_num != ''">
										<xsl:value-of select="java:replaceAll(java:java.lang.String.new($titles/title-subpart[@lang=$curr_lang]),'#',$subpart_num)"/>
									</xsl:if>
									<xsl:text>: </xsl:text> -->
									<xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:title[@language = $curr_lang and @type = 'title-subpart-with-numbering']" mode="title"/>
								</fo:block>
							</xsl:if>
							
							
							<fo:block>&#xA0;</fo:block>
							<fo:block font-size="9pt">
								<xsl:value-of select="/mn:metanorma/mn:bibdata/mn:ext/mn:editorialgroup/mn:committee/mn:variant[@language = $curr_lang]"/>
							</fo:block>
						</fo:block-container>
						
						<fo:block-container absolute-position="fixed" left="69.5mm" top="241mm" width="99mm">						
							<fo:block-container font-size="9pt" border-bottom="1pt solid black" width="68mm" text-align="center" margin-bottom="14pt">
								<fo:block font-weight="bold" margin-bottom="2.5mm">
									<fo:inline padding-right="10mm">
										<xsl:apply-templates select="mn:bibdata/mn:edition[normalize-space(@language) = '']">
											<xsl:with-param name="font-size" select="'70%'"/>
											<xsl:with-param name="baseline-shift" select="'45%'"/>
											<xsl:with-param name="curr_lang" select="$curr_lang"/>
										</xsl:apply-templates>
									</fo:inline>
									<xsl:value-of select="$copyrightYear"/>
								</fo:block>
							</fo:block-container>
							<fo:block font-size="9pt" margin-left="-35mm">
								<fo:block>&#xA0;</fo:block>
								<fo:block>&#xA0;</fo:block>
								<fo:block>&#xA0;</fo:block>
								<fo:block text-align="right"><xsl:value-of select="mn:bibdata/mn:version/mn:draft"/></fo:block>
								<fo:block text-align-last="justify">
									<fo:inline>
										<xsl:if test="/mn:metanorma/mn:bibdata/mn:ext/mn:structuredidentifier/mn:appendix">
											<xsl:choose>
												<xsl:when test="$lang = 'fr'">Annexe </xsl:when>
												<xsl:otherwise>Appendix </xsl:otherwise>
											</xsl:choose>
											<xsl:value-of select="/mn:metanorma/mn:bibdata/mn:ext/mn:structuredidentifier/mn:appendix"/>
										</xsl:if>
									</fo:inline>
									<fo:inline keep-together.within-line="always">
										<fo:leader leader-pattern="space"/>
										<xsl:call-template name="printRevisionDate">
											<xsl:with-param name="date" select="/mn:metanorma/mn:bibdata/mn:version/mn:revision-date"/>
											<xsl:with-param name="lang" select="$lang"/>
											<xsl:with-param name="variant" select="'true'"/>
										</xsl:call-template>
									</fo:inline>
								</fo:block>
								
							</fo:block>
						</fo:block-container>
						
						
					</fo:flow>
				</fo:page-sequence>
				
				
				<xsl:apply-templates select="mn:preface/*[not(self::mn:note or self::mn:admonition)]" mode="sections" />
				
				<!-- Document Pages -->
				<xsl:apply-templates select="mn:sections/*" mode="sections" />
				
				<!-- Normative references  -->
				<xsl:apply-templates select="mn:bibliography/mn:references[@normative='true']" mode="sections"/>

				<xsl:apply-templates select="mn:annex" mode="sections"/>
				
				<xsl:if test="mn:bibliography/mn:references[not(@normative='true')][not(@hidden='true')]/mn:bibitem[not(contains(mn:docidentifier, 'si-brochure-'))]">
					<xsl:apply-templates select="mn:bibliography/mn:references[not(@normative='true')]" mode="sections"/> 
				</xsl:if>
				
				<!-- Document Control -->
				<xsl:apply-templates select="mn:doccontrol | mn:colophon" mode="sections"/> 
				
				<!-- Index -->
				<xsl:apply-templates select="xalan:nodeset($indexes)/doc[@id = $docid]//mn:indexsect" mode="index">
					<xsl:with-param name="isDraft" select="normalize-space(//mn:metanorma/mn:bibdata/mn:version/mn:draft or
						contains(//mn:metanorma/mn:bibdata/mn:status/mn:stage, 'draft') or
						contains(//mn:metanorma/mn:bibdata/mn:status/mn:stage, 'projet'))"/>
					<xsl:with-param name="lang" select="$curr_lang"/>
				</xsl:apply-templates>
				
			</xsl:otherwise><!-- END: independentAppendix != '' -->
		</xsl:choose>
		
	</xsl:template>
	
	
	<xsl:template name="cover-page">
		<xsl:choose>
			<xsl:when test="$doctype = 'guide'">
				<xsl:call-template name="insertCoverPageAppendix"/>				
			</xsl:when>
			<xsl:when test="$independentAppendix = ''">
				<xsl:call-template name="insertCoverPage"/>
				<xsl:call-template name="insertInnerCoverPage"/>
			</xsl:when>
			<xsl:when test="$independentAppendix != ''">
				<xsl:call-template name="insertCoverPageAppendix"/>				
			</xsl:when>
		</xsl:choose>
	</xsl:template> <!-- END: cover-page -->
			
	
	<!-- Cover Pages -->
	<xsl:template name="insertCoverPage">	
	
		<fo:page-sequence master-reference="cover-page" force-page-count="even">
			
			<xsl:call-template name="insertHeaderDraftWatermark"/>
			
			<fo:flow flow-name="xsl-region-body">
			
				<xsl:call-template name="insertCoverPageCommon"/>
				
				<fo:block-container height="100%" display-align="center" border="0pt solid black"><!--  -->
					<fo:block font-family="Work Sans" font-size="50pt" line-height="115%">
					
						<xsl:variable name="languages">
							<xsl:call-template name="getLanguages"/>
						</xsl:variable>						
						<xsl:variable name="editionFO">
							<xsl:apply-templates select="(//mn:metanorma)[1]/mn:bibdata/mn:edition[normalize-space(@language) = '']">
								<xsl:with-param name="curr_lang" select="xalan:nodeset($languages)/lang[1]"/>
							</xsl:apply-templates>
						</xsl:variable>
						
						<xsl:variable name="titles">
							<xsl:for-each select="(//mn:metanorma)[1]/mn:bibdata/mn:title">
								<xsl:copy-of select="."/>
							</xsl:for-each>
						</xsl:variable>
						
						<xsl:for-each select="xalan:nodeset($languages)/lang">
							<xsl:variable name="title_num" select="position()"/>							
							<xsl:variable name="curr_lang" select="."/>
							<xsl:variable name="title-cover" select="xalan:nodeset($titles)//mn:title[@language = $curr_lang and @type='title-main']"/>							
							<xsl:variable name="title-cover_" select="java:replaceAll(java:java.lang.String.new($title-cover),'( (of )| (and )| (or ))','#$2')"/>
							<xsl:variable name="titleParts">
								<xsl:call-template name="splitTitle">
									<xsl:with-param name="pText" select="$title-cover_"/>
									<xsl:with-param name="sep" select="' '"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:variable name="titleSplitted">							
								<xsl:call-template name="splitByParts">
									<xsl:with-param name="items" select="$titleParts"/>
									<xsl:with-param name="mergeEach" select="round(count(xalan:nodeset($titleParts)/item) div 4 + 0.49)"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:variable name="font-weight-initial">
								<xsl:choose>
									<xsl:when test="position() = 1">0</xsl:when>
									<xsl:otherwise>400</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<fo:block role="H1">
								<xsl:if test="$title_num != 1">
									<xsl:attribute name="text-align">right</xsl:attribute>
								</xsl:if>
								<xsl:for-each select="xalan:nodeset($titleSplitted)/part">
									<fo:block font-weight="{$font-weight-initial + 100 * position()}">										
										<xsl:value-of select="translate(., '#', ' ')"/>
										<xsl:if test="$title_num = 1 and position() = last()">
											<fo:inline font-size="11.7pt" font-weight="normal" padding-left="5mm" baseline-shift="15%" line-height="125%">
												<xsl:copy-of select="$editionFO"/>
												<xsl:text> </xsl:text>
												<xsl:value-of select="$copyrightYear"/>
											</fo:inline>
										</xsl:if>
									</fo:block>
								</xsl:for-each>
							</fo:block>
						</xsl:for-each>
						
						
					</fo:block>
				</fo:block-container>
				
			</fo:flow>
		</fo:page-sequence>	
	</xsl:template>
	
	<xsl:template name="insertCoverPageAppendix">	
	
		<fo:page-sequence master-reference="cover-page-appendix" force-page-count="even" initial-page-number="1">
			
			<fo:flow flow-name="xsl-region-body" font-family="Work Sans">
			
				<xsl:call-template name="insertCoverPageCommon"/>
				
				<xsl:variable name="weight-normal">300</xsl:variable>
				<xsl:variable name="weight-bold">500</xsl:variable>
				
				<fo:block-container absolute-position="fixed" left="12.5mm" top="60mm">
					
					<fo:block font-size="22.2pt" font-weight="{$weight-normal}" role="H1"><xsl:value-of select="(//mn:metanorma)[1]/mn:bibdata/mn:title[@language = 'fr' and @type = 'title-main']"/></fo:block>
					<fo:block font-size="22.2pt" font-weight="{$weight-bold}" margin-top="1mm" role="H1"><xsl:value-of select="(//mn:metanorma)[1]/mn:bibdata/mn:title[@language = 'en' and @type = 'title-main']"/></fo:block>
					
					<xsl:variable name="edition_str">édition</xsl:variable>
						
					<fo:block font-size="14pt" font-weight="{$weight-bold}" margin-top="4mm"><xsl:value-of select="concat((//mn:metanorma)[1]/mn:bibdata/mn:edition[normalize-space(@language) = ''], ' ', $edition_str, ' ', $copyrightYear)"/></fo:block>				
				</fo:block-container>
				
				<fo:block-container absolute-position="fixed" left="12.5mm" top="92mm" height="170mm" width="144mm" display-align="center">
					<fo:block role="H1">
					
						<xsl:variable name="title_appendix_fr">
							<xsl:apply-templates select="(//mn:metanorma)[1]/mn:bibdata/mn:title[@language = 'fr' and @type = 'title-appendix']" mode="title"/>
						</xsl:variable>
						<xsl:variable name="title_appendix_en">
							<xsl:apply-templates select="(//mn:metanorma)[1]/mn:bibdata/mn:title[@language = 'en' and @type = 'title-appendix']" mode="title"/>
						</xsl:variable>
						<xsl:variable name="title_annex_fr">
							<xsl:apply-templates select="(//mn:metanorma)[1]/mn:bibdata/mn:title[@language = 'fr' and @type = 'title-annex']" mode="title"/>
						</xsl:variable>
						<xsl:variable name="title_annex_en">
							<xsl:apply-templates select="(//mn:metanorma)[1]/mn:bibdata/mn:title[@language = 'en' and @type = 'title-annex']" mode="title"/>
						</xsl:variable>
						<xsl:variable name="title_part_fr">
							<xsl:apply-templates select="(//mn:metanorma)[1]/mn:bibdata/mn:title[@language = 'fr' and @type = 'title-part']" mode="title"/>
						</xsl:variable>
						<xsl:variable name="title_part_en">
							<xsl:apply-templates select="(//mn:metanorma)[1]/mn:bibdata/mn:title[@language = 'en' and @type = 'title-part']" mode="title"/>
						</xsl:variable>
						<xsl:variable name="title_subpart_fr">
							<xsl:apply-templates select="(//mn:metanorma)[1]/mn:bibdata/mn:title[@language = 'fr' and @type = 'title-subpart']" mode="title"/>
						</xsl:variable>
						<xsl:variable name="title_subpart_en">
							<xsl:apply-templates select="(//mn:metanorma)[1]/mn:bibdata/mn:title[@language = 'en' and @type = 'title-subpart']" mode="title"/>
						</xsl:variable>
						
						<xsl:variable name="titles_length" select="string-length($title_appendix_fr) + 
																													string-length($title_appendix_en) +
																													string-length($title_annex_fr) +
																													string-length($title_annex_en) +
																													string-length($title_part_fr) +
																													string-length($title_part_en) +
																													string-length($title_subpart_fr) +
																													string-length($title_subpart_fr)"/>
																													
						
						<xsl:variable name="space-factor">
							<xsl:choose>
								<xsl:when test="$titles_length &gt; 250">0.3</xsl:when>
								<xsl:when test="$titles_length &gt; 200">0.5</xsl:when>
								<xsl:when test="$titles_length &gt; 150">0.7</xsl:when>
								<xsl:otherwise>1</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						
						<xsl:variable name="font-size-factor">
							<xsl:choose>
								<xsl:when test="$titles_length &gt; 350">0.5</xsl:when>
								<xsl:when test="$titles_length &gt; 250">0.55</xsl:when>
								<xsl:when test="$titles_length &gt; 180">0.65</xsl:when>
								<xsl:when test="$titles_length &gt; 130">0.8</xsl:when>
								<xsl:otherwise>1</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						
						<xsl:variable name="font-size-number-factor">
							<xsl:choose>
								<xsl:when test="$font-size-factor &lt; 1"><xsl:value-of select="$font-size-factor *1.3"/></xsl:when>
								<xsl:otherwise>1</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						
						<!-- see https://github.com/metanorma/metanorma-bipm/issues/99 -->
						<!-- Example: Appendix -->
						<xsl:variable name="title_level2_ancillary"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">level2_ancillary</xsl:with-param></xsl:call-template></xsl:variable>
						<!-- Example: Annexe -->
						<xsl:variable name="title_level2_ancillary_alt"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">level2_ancillary_alt</xsl:with-param></xsl:call-template></xsl:variable>
						
						<!-- Appendix titles processing -->
						<xsl:variable name="appendix_num" select="normalize-space((//mn:metanorma)[1]/mn:bibdata/mn:ext/mn:structuredidentifier/mn:appendix)"/>
						<xsl:if test="$appendix_num != ''">
							<fo:block font-size="{$font-size-number-factor * 17}pt" font-weight="{$weight-normal}"><xsl:value-of select="concat($title_level2_ancillary_alt, ' ', $appendix_num)"/></fo:block>
							<fo:block font-size="{$font-size-number-factor * 17}pt" font-weight="{$weight-bold}"><xsl:value-of select="concat($title_level2_ancillary, ' ', $appendix_num)"/></fo:block>
						</xsl:if>

						<xsl:if test="(//mn:metanorma)[1]/mn:bibdata/mn:title[@type = 'title-appendix']">
							<fo:block font-size="{$font-size-factor * 30.4}pt">
								<fo:block font-size="{$space-factor * 30.4}pt">&#xA0;</fo:block>
								<fo:block font-weight="{$weight-normal}"><xsl:copy-of select="$title_appendix_fr"/></fo:block>
								<fo:block font-size="{$space-factor * 30.4}pt">&#xA0;</fo:block>
								<fo:block font-weight="{$weight-bold}">
									<xsl:copy-of select="$title_appendix_en"/>
								</fo:block>
							</fo:block>
						</xsl:if>
						<!-- End Appendix titles processing -->
						
						<!-- see https://github.com/metanorma/metanorma-bipm/issues/99 -->
						<!-- Example: Annex -->
						<xsl:variable name="title_level3_ancillary"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">level3_ancillary</xsl:with-param></xsl:call-template></xsl:variable>
						<!-- Example: Annexe -->
						<xsl:variable name="title_level3_ancillary_alt"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">level3_ancillary_alt</xsl:with-param></xsl:call-template></xsl:variable>
						
						<!-- Annex title processing -->
						<xsl:if test="(//mn:metanorma)[1]/mn:bibdata/mn:title[@type = 'title-annex']">
							<xsl:variable name="annex_num" select="normalize-space((//mn:metanorma)[1]/mn:bibdata/mn:ext/mn:structuredidentifier/mn:annexid)"/>					
							<xsl:if test="$annex_num != ''">
								<fo:block font-size="{$space-factor * 30.4}pt">&#xA0;</fo:block>
								<!-- Annexe -->
								<fo:block font-size="{$font-size-number-factor * 17}pt" font-weight="{$weight-normal}"><xsl:value-of select="concat($title_level3_ancillary_alt, ' ', $annex_num)"/></fo:block>
								<!-- Annex -->
								<fo:block font-size="{$font-size-number-factor * 17}pt" font-weight="{$weight-bold}"><xsl:value-of select="concat($title_level3_ancillary, ' ', $annex_num)"/></fo:block>
							</xsl:if>
						
							<fo:block font-size="{$font-size-factor * 30.4}pt">
								
								<xsl:if test="normalize-space($title_annex_fr) != ''">
									<fo:block font-size="{$space-factor * 30.4}pt">&#xA0;</fo:block>
									<fo:block font-weight="{$weight-normal}"><xsl:copy-of select="$title_annex_fr"/></fo:block>
								</xsl:if>
								
								<xsl:if test="normalize-space($title_annex_en) != ''">
									<fo:block font-size="{$space-factor * 30.4}pt">&#xA0;</fo:block>
									<fo:block font-weight="{$weight-bold}">
										<xsl:copy-of select="$title_annex_en"/>
									</fo:block>
								</xsl:if>
							</fo:block>
						</xsl:if>
						<!-- End Annex titles  processing -->
						
						<xsl:variable name="part_num_" select="normalize-space((//mn:metanorma)[1]/mn:bibdata/mn:ext/mn:structuredidentifier/mn:part)"/>
						<!--  Part titles processing -->
						<xsl:if test="(//mn:metanorma)[1]/mn:bibdata/mn:title[@type = 'title-part']">
							<xsl:variable name="part_num">
								<xsl:choose>
									<xsl:when test="contains($part_num_, '.')"><xsl:value-of select="substring-before($part_num_, '.')"/></xsl:when>
									<xsl:otherwise><xsl:value-of select="$part_num_"/></xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:if test="normalize-space($part_num) != ''">
								<fo:block font-size="{$space-factor * 30.4}pt">&#xA0;</fo:block>
								
								<!-- see https://github.com/metanorma/metanorma-bipm/issues/99 -->
								<!-- Example: Part -->
								<xsl:variable name="title_level4_ancillary"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">level4_ancillary</xsl:with-param></xsl:call-template></xsl:variable>
								<!-- Example: Partie -->
								<xsl:variable name="title_level4_ancillary_alt"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">level4_ancillary_alt</xsl:with-param></xsl:call-template></xsl:variable>
								
								<!-- Part -->
								<fo:block font-size="{$font-size-number-factor * 17}pt" font-weight="{$weight-normal}">
									<!-- <xsl:value-of select="java:replaceAll(java:java.lang.String.new($titles/title-part[@lang='fr']),'#',$part_num)"/> -->
									<xsl:value-of select="concat($title_level4_ancillary_alt, ' ', $part_num)"/>
								</fo:block>
								<!-- Partie -->
								<fo:block font-size="{$font-size-number-factor * 17}pt" font-weight="{$weight-bold}">
									<!-- <xsl:value-of select="java:replaceAll(java:java.lang.String.new($titles/title-part[@lang='en']),'#',$part_num)"/> -->
									<xsl:value-of select="concat($title_level4_ancillary, ' ', $part_num)"/>
								</fo:block>
							</xsl:if>
						
							<fo:block font-size="{$font-size-factor * 30.4}pt">
								
								<xsl:if test="normalize-space($title_part_fr) != ''">
									<fo:block font-size="{$space-factor * 30.4}pt">&#xA0;</fo:block>
									<fo:block font-weight="{$weight-normal}"><xsl:copy-of select="$title_part_fr"/></fo:block>
								</xsl:if>
								
								<xsl:if test="normalize-space($title_part_en) != ''">
									<fo:block font-size="{$space-factor * 30.4}pt">&#xA0;</fo:block>
									<fo:block font-weight="{$weight-bold}">
										<xsl:copy-of select="$title_part_en"/>
									</fo:block>
								</xsl:if>
							</fo:block>
						</xsl:if>
						<!-- End Part titles  processing -->
						
						<!-- Sub-part titles  processing -->
						<xsl:if test="(//mn:metanorma)[1]/mn:bibdata/mn:title[@type = 'title-subpart']">
							<!-- <xsl:variable name="subpart_num" select="normalize-space((//mn:metanorma)[1]/mn:bibdata/mn:ext/mn:structuredidentifier/mn:subpart)"/> -->
							<xsl:variable name="subpart_num" select="normalize-space(substring-after($part_num_, '.'))"/>
							
							<xsl:if test="$subpart_num != ''">
								<fo:block font-size="{$space-factor * 30.4}pt">&#xA0;</fo:block>
								
								<!-- see https://github.com/metanorma/metanorma-bipm/issues/99 -->
								<!-- Example: Part -->
								<xsl:variable name="title_level5_ancillary"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">level5_ancillary</xsl:with-param></xsl:call-template></xsl:variable>
								<!-- Example: Partie de sub -->
								<xsl:variable name="title_level5_ancillary_alt"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">level5_ancillary_alt</xsl:with-param></xsl:call-template></xsl:variable>
								
								<!-- Partie de sub -->
								<!-- <fo:block font-size="{$font-size-number-factor * 17}pt" font-weight="{$weight-normal}"><xsl:value-of select="java:replaceAll(java:java.lang.String.new($titles/title-subpart[@lang='fr']),'#',$subpart_num)"/> <xsl:value-of select="$subpart_num"/></fo:block> -->
								<fo:block font-size="{$font-size-number-factor * 17}pt" font-weight="{$weight-normal}"><xsl:value-of select="concat($title_level5_ancillary_alt, ' ', $subpart_num)"/></fo:block>
								<!-- Sub-part -->
								<!-- <fo:block font-size="{$font-size-number-factor * 17}pt" font-weight="{$weight-bold}"><xsl:value-of select="java:replaceAll(java:java.lang.String.new($titles/title-subpart[@lang='en']),'#',$subpart_num)"/>  <xsl:value-of select="$subpart_num"/></fo:block> -->
								<fo:block font-size="{$font-size-number-factor * 17}pt" font-weight="{$weight-bold}"><xsl:value-of select="concat($title_level5_ancillary, ' ', $subpart_num)"/></fo:block>
							</xsl:if>
						
							<fo:block font-size="{$font-size-factor * 30.4}pt">
								
								<xsl:if test="normalize-space($title_subpart_fr) != ''">
									<fo:block font-size="{$space-factor * 30.4}pt">&#xA0;</fo:block>
									<fo:block font-weight="{$weight-normal}"><xsl:copy-of select="$title_subpart_fr"/></fo:block>
								</xsl:if>
								
								<xsl:if test="normalize-space($title_subpart_en) != ''">
									<fo:block font-size="{$space-factor * 30.4}pt">&#xA0;</fo:block>
									<fo:block font-weight="{$weight-bold}">
										<xsl:copy-of select="$title_subpart_en"/>
										
									</fo:block>
								</xsl:if>
							</fo:block>
						</xsl:if>
						<!-- End Sub-part titles processing -->
				
					</fo:block>
				</fo:block-container>
				
				
				<fo:block-container absolute-position="fixed" left="12mm" top="242mm" height="42mm" width="140mm" display-align="after">
					<fo:block font-size="12pt">
						<fo:block><xsl:value-of select="(//mn:metanorma)[1]/mn:bibdata/mn:ext/mn:editorialgroup/mn:committee/mn:variant[@language = 'fr']"/></fo:block>
						<fo:block><xsl:value-of select="(//mn:metanorma)[1]/mn:bibdata/mn:ext/mn:editorialgroup/mn:committee/mn:variant[@language = 'en']"/></fo:block>
						<fo:block>&#xA0;</fo:block>
				
						<fo:block>
							<xsl:call-template name="printRevisionDate">
								<xsl:with-param name="date" select="(//mn:metanorma)[1]/mn:bibdata/mn:version/mn:revision-date"/>
								<xsl:with-param name="lang" select="'en'"/>
							</xsl:call-template>
						</fo:block>
						<fo:block>
							<xsl:call-template name="printRevisionDate">
								<xsl:with-param name="date" select="(//mn:metanorma)[1]/mn:bibdata/mn:version/mn:revision-date"/>
								<xsl:with-param name="lang" select="'fr'"/>
							</xsl:call-template>
						</fo:block>
					</fo:block>
				</fo:block-container>
	
			</fo:flow>
		</fo:page-sequence>	
	</xsl:template> <!-- END: insertCoverPageAppendix -->
	
	<xsl:template name="insertCoverPageCommon">
		<!-- background color -->
		<fo:block-container absolute-position="fixed" left="0" top="-1mm">
			<fo:block>
				<fo:instream-foreign-object content-height="{$pageHeight}mm" fox:alt-text="Background color">
					<svg xmlns="http://www.w3.org/2000/svg" version="1.0" width="{$pageWidth}mm" height="{$pageHeight}mm">
						<rect width="{$pageWidth}mm" height="{$pageHeight}mm" style="fill:rgb(214,226,239);stroke-width:0"/>
					</svg>
				</fo:instream-foreign-object>
			</fo:block>
		</fo:block-container>
	
		<xsl:call-template name="insertDraftWatermark">
			<xsl:with-param name="lang" select="$doc_split_by_language"/>
		</xsl:call-template>
		
		<!-- BIPM logo -->
		<fo:block-container absolute-position="fixed" left="12.8mm" top="12.2mm">
			<fo:block>
				<fo:external-graphic src="{concat('data:image/png;base64,', normalize-space($Image-Logo-BIPM))}" width="35mm" content-height="scale-to-fit" scaling="uniform" fox:alt-text="Image Logo"/>
			</fo:block>
		</fo:block-container>
		
		<!-- SI logo -->
		<fo:block-container absolute-position="fixed" left="166.5mm" top="253mm">
			<fo:block>
				<fo:instream-foreign-object content-height="32mm" content-width="32mm"  fox:alt-text="Image Logo">
					<xsl:copy-of select="$Image-Logo-SI"/>
				</fo:instream-foreign-object>	
				
			</fo:block>
		</fo:block-container>
	</xsl:template>
	
	<xsl:template name="insertInnerCoverPage">
		
		<xsl:if test="(//mn:metanorma)[1]/mn:bibdata/mn:title[@type='title-cover']">
	
			<fo:page-sequence master-reference="title-page" format="1" initial-page-number="1" force-page-count="even">
				
				<xsl:call-template name="insertHeaderDraftWatermark"/>
				
				<fo:flow flow-name="xsl-region-body" font-family="Arial">
				
					<xsl:variable name="languages">
						<xsl:call-template name="getLanguages"/>
					</xsl:variable>
				
					<xsl:variable name="titles">
						<xsl:for-each select="(//mn:metanorma)[1]/mn:bibdata/mn:title">
							<xsl:copy-of select="."/>
						</xsl:for-each>
					</xsl:variable>
				
					<xsl:for-each select="xalan:nodeset($languages)/lang">
						<xsl:variable name="curr_lang" select="."/>
						<xsl:variable name="title" select="xalan:nodeset($titles)//mn:title[@language = $curr_lang and @type='title-cover']"/>
						<xsl:choose>
							<xsl:when test="position() = 1">				
								<fo:block-container font-size="12pt" font-weight="bold" width="55mm">
										<fo:block>
											<xsl:call-template name="add-letter-spacing">
												<xsl:with-param name="text" select="$title"/>
												<xsl:with-param name="letter-spacing" select="0.09"/>
											</xsl:call-template>
										</fo:block>									
										<fo:block font-size="10pt">
											<fo:block margin-bottom="6pt">&#xA0;</fo:block>
											<fo:block margin-bottom="6pt">&#xA0;</fo:block>
											<fo:block margin-bottom="6pt">&#xA0;</fo:block>
											<fo:block margin-bottom="6pt" line-height="2.4">&#xA0;</fo:block>							
										</fo:block>
									</fo:block-container>
								</xsl:when>
								<xsl:otherwise>
									<fo:block font-size="10pt" margin-bottom="3pt">
										<xsl:variable name="lang_version">
											<xsl:call-template name="getLangVersion">
												<xsl:with-param name="lang" select="$curr_lang"/>
											</xsl:call-template>
										</xsl:variable>
										<xsl:call-template name="add-letter-spacing">
											<xsl:with-param name="text" select="normalize-space($lang_version)"/>
											<xsl:with-param name="letter-spacing" select="0.09"/>
										</xsl:call-template>
									</fo:block>
									<fo:block-container font-size="12pt" font-weight="bold" border-top="0.5pt solid black" padding-top="2mm" width="45mm">						
										<fo:block role="H1">										
											<xsl:call-template name="add-letter-spacing">
												<xsl:with-param name="text" select="$title"/>
												<xsl:with-param name="letter-spacing" select="0.09"/>
											</xsl:call-template>
										</fo:block>
									</fo:block-container>
								</xsl:otherwise>
								
							</xsl:choose>
						</xsl:for-each>
					
					
				</fo:flow>
			</fo:page-sequence>
		</xsl:if>
	</xsl:template>
	<!-- End Cover Pages -->
		
	
	<xsl:template match="mn:metanorma/mn:bibdata/mn:title[@language = 'en']/text()" priority="3">
		<xsl:variable name="mep_text" select="'Mise en pratique'"/>
		<xsl:choose>
			<xsl:when test="contains(., $mep_text)">
				<xsl:value-of select="substring-before(., $mep_text)"/>
				<xsl:text> </xsl:text><fo:inline font-style="italic"><xsl:value-of select="$mep_text"/></fo:inline><xsl:text> </xsl:text>
				<xsl:value-of select="substring-after(., $mep_text)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	
		
	<xsl:template name="insertSeparatorPage">
		<!-- 3 Pages with BIPM Metro logo -->
		<fo:page-sequence master-reference="document" force-page-count="no-force">
			<fo:flow flow-name="xsl-region-body">
				<fo:block>&#xA0;</fo:block>
				<fo:block break-after="page"/>
				
				<xsl:call-template name="insert_Logo-BIPM-Metro"/>
				
				<fo:block break-after="page"/>
				<fo:block>&#xA0;</fo:block>
			</fo:flow>
		</fo:page-sequence>
	</xsl:template>
		
	<xsl:template name="getLanguages">
		<xsl:choose>
			<xsl:when test="$doc_split_by_language = ''"><!-- all documents -->
				<xsl:for-each select="//mn:metanorma/mn:bibdata">
					<lang><xsl:value-of select="mn:language[@current = 'true']"/></lang>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<lang><xsl:value-of select="$doc_split_by_language"/></lang>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
		
	<xsl:template name="insertContentItem">
		<xsl:param name="keep-with-next"/>
		<fo:table-row xsl:use-attribute-sets="toc-item-style">
			<xsl:if test="$keep-with-next = 'true'">
				<xsl:attribute name="keep-with-next">always</xsl:attribute>
			</xsl:if>
			<xsl:variable name="space-before">
				<xsl:if test="@level = 1">
					<xsl:if test="@type = 'annex'">14pt</xsl:if>
				</xsl:if>
			</xsl:variable>
			<xsl:variable name="space-after">
				<xsl:choose>
					<xsl:when test="@level = 1 and @type = 'annex'">0pt</xsl:when>
					<xsl:when test="@level = 1">6pt</xsl:when>
					<xsl:when test="@level = 2 and not(following-sibling::mnx:item[@display='true']) and not(mnx:item[@display='true']) and not(position() = last())">12pt</xsl:when>
					<xsl:when test="@level = 3 and not(following-sibling::mnx:item[@display='true']) and not(../following-sibling::mnx:item[@display='true']) and not(position() = last())">12pt</xsl:when>
				</xsl:choose>
			</xsl:variable>
			
			<fo:table-cell role="SKIP">
				<xsl:if test="normalize-space($space-before) != ''">
					<xsl:attribute name="padding-top"><xsl:value-of select="normalize-space($space-before)"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="normalize-space($space-after) != ''">
					<xsl:attribute name="padding-bottom"><xsl:value-of select="normalize-space($space-after)"/></xsl:attribute>
				</xsl:if>				
				<fo:block role="SKIP">
					
					<xsl:call-template name="refine_toc-item-style"/>
					
					<fo:list-block role="SKIP">
						<xsl:attribute name="provisional-distance-between-starts">
							<xsl:choose>
								<xsl:when test="@section = '' or @level &gt; 3">0mm</xsl:when>
								<xsl:when test="@level = 2 and @parent = 'annex'">0mm</xsl:when>
								<xsl:when test="@level = 2">8mm</xsl:when>								
								<xsl:when test="@type = 'annex' and @level = 1">25mm</xsl:when>
								<xsl:otherwise>7mm</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						
						<fo:list-item role="SKIP">
						
							<fo:list-item-label end-indent="label-end()" role="SKIP">
								<fo:block role="SKIP">
									<xsl:if test="@level = 1 or (@level = 2 and not(@parent = 'annex'))">
										<xsl:value-of select="@section"/>
										<xsl:if test="normalize-space(@section) != '' and @type = 'annex'">.</xsl:if>
									</xsl:if>
								</fo:block>
							</fo:list-item-label>
							
							<fo:list-item-body start-indent="body-start()" role="SKIP">
								<fo:block role="SKIP">
									<xsl:if test="@level &gt;= 3">
										<xsl:attribute name="margin-left">11mm</xsl:attribute>
										<xsl:attribute name="text-indent">-11mm</xsl:attribute>
									</xsl:if>
									<fo:basic-link internal-destination="{@id}" fox:alt-text="{mnx:title}" role="SKIP">
										<xsl:if test="@level &gt;= 3">
											<fo:inline padding-right="2mm" role="SKIP"><xsl:value-of select="@section"/></fo:inline>
										</xsl:if>
										
										<fo:inline role="SKIP">
											<xsl:apply-templates select="mnx:title"/>
										</fo:inline>
										
									</fo:basic-link>
								</fo:block>
							</fo:list-item-body>
						</fo:list-item>
					</fo:list-block>
				</fo:block>				
			</fo:table-cell>
			<fo:table-cell text-align="right" role="SKIP">
				<xsl:if test="normalize-space($space-before) != ''">
					<xsl:attribute name="padding-top"><xsl:value-of select="normalize-space($space-before)"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="normalize-space($space-after) != ''">
					<xsl:attribute name="padding-bottom"><xsl:value-of select="normalize-space($space-after)"/></xsl:attribute>
				</xsl:if>
				<fo:block role="SKIP">
					<fo:basic-link internal-destination="{@id}" fox:alt-text="{mnx:title}" role="SKIP">
						<fo:inline xsl:use-attribute-sets="toc-pagenumber-style" role="SKIP"><fo:wrapper role="artifact"><fo:page-number-citation ref-id="{@id}" /></fo:wrapper></fo:inline>
					</fo:basic-link>
				</fo:block>
			</fo:table-cell>
		</fo:table-row>
	</xsl:template>
	
	<xsl:template name="insertListOf_Title">
		<xsl:param name="title"/>
		<fo:table-row keep-with-next="always">
			<fo:table-cell xsl:use-attribute-sets="toc-listof-title-style">
				<fo:block role="TOCI">
					<xsl:value-of select="$title"/>
				</fo:block>				
			</fo:table-cell>
			<fo:table-cell>
				<fo:block></fo:block>
			</fo:table-cell>
		</fo:table-row>
	</xsl:template>
	
	<xsl:template name="insertListOf_Item">
		<fo:table-row>
			<fo:table-cell>
				<fo:block xsl:use-attribute-sets="toc-listof-item-style">
					<fo:list-block provisional-distance-between-starts="8mm">
						<fo:list-item>
							<fo:list-item-label end-indent="label-end()">
								<fo:block></fo:block>
							</fo:list-item-label>
							<fo:list-item-body start-indent="body-start()">
								<fo:block>
									<fo:basic-link internal-destination="{@id}">
										<xsl:call-template name="setAltText">
											<xsl:with-param name="value" select="@alt-text"/>
										</xsl:call-template>
										<fo:inline>
											<xsl:apply-templates select="." mode="contents"/>
										</fo:inline>
									</fo:basic-link>
								</fo:block>
							</fo:list-item-body>
						</fo:list-item>
					</fo:list-block>
				</fo:block>				
			</fo:table-cell>
			<fo:table-cell xsl:use-attribute-sets="toc-pagenumber-style" text-align="right">
				<fo:block>
					<fo:basic-link internal-destination="{@id}">
						<xsl:call-template name="setAltText">
							<xsl:with-param name="value" select="@alt-text"/>
						</xsl:call-template>
						<fo:inline><fo:page-number-citation ref-id="{@id}"/></fo:inline>
					</fo:basic-link>
				</fo:block>
			</fo:table-cell>
		</fo:table-row>
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
		
		<xsl:variable name="display">
			<xsl:choose>				
				<xsl:when test="$level &gt; $toc_level">false</xsl:when>
				<xsl:otherwise>true</xsl:otherwise>
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
			<xsl:variable name="section">
				<xsl:call-template name="getSection"/>
			</xsl:variable>
			
			<xsl:variable name="title">
				<xsl:call-template name="getName"/>
			</xsl:variable>
			
			<xsl:variable name="type">
				<xsl:choose>
					<xsl:when test="@type = 'index'">index</xsl:when>
					<xsl:when test="self::mn:indexsect">index</xsl:when>
					<xsl:otherwise><xsl:value-of select="local-name()"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<mnx:item id="{@id}" level="{$level}" section="{$section}" type="{$type}" display="{$display}">
				<xsl:if test="ancestor::mn:annex">
					<xsl:attribute name="parent">annex</xsl:attribute>
				</xsl:if>
				<mnx:title>
					<xsl:apply-templates select="xalan:nodeset($title)" mode="contents_item"/>
				</mnx:title>
				<xsl:if test="$type != 'index'">
					<xsl:apply-templates  mode="contents" />
				</xsl:if>
			</mnx:item>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="mn:strong" mode="contents_item" priority="2">
		<!-- <xsl:copy> -->
			<xsl:apply-templates mode="contents_item"/>
		<!-- </xsl:copy>	 -->	
	</xsl:template>
	
	<!-- ============================= -->
	<!-- ============================= -->
	
	
	<xsl:template match="node()" mode="sections">
		<fo:page-sequence master-reference="document" force-page-count="no-force">
			<xsl:if test="@orientation = 'landscape'">
				<xsl:attribute name="master-reference">document-landscape</xsl:attribute>
			</xsl:if>

			<xsl:call-template name="insertFootnoteSeparator"/>
			
			<xsl:variable name="header-title">
				<xsl:choose>
					<xsl:when test="parent::mn:sections">
						<xsl:choose>
							<xsl:when test="./mn:fmt-title[1]/mn:tab">
								<xsl:apply-templates select="./mn:fmt-title[1]/mn:tab[1]/following-sibling::node()" mode="header"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates select="./mn:fmt-title[1]" mode="header"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					
					<xsl:when test="self::mn:annex">
						<xsl:choose>
							<xsl:when test="./*[1]/mn:fmt-title[1]/mn:tab">
								<xsl:variable name="title_annex">
										<xsl:value-of select="normalize-space(./*[1]/mn:fmt-title[1]/mn:tab[1]/preceding-sibling::node())"/>
									</xsl:variable>
									<xsl:choose>
										<xsl:when test="substring($title_annex, string-length($title_annex)) = '.'">
											<xsl:value-of select="substring($title_annex, 1, string-length($title_annex) - 1)"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$title_annex"/>
										</xsl:otherwise>
									</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates select="./*[1]/mn:fmt-title[1]" mode="header"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					
					<xsl:otherwise>
						<xsl:apply-templates select="./mn:fmt-title[1]" mode="header"/>
					</xsl:otherwise>
					
				</xsl:choose>
			</xsl:variable>
			<xsl:call-template name="insertHeaderFooter">
				<xsl:with-param name="header-title" select="$header-title"/>
				<xsl:with-param name="orientation" select="@orientation"/>
			</xsl:call-template>
			
			<fo:flow flow-name="xsl-region-body">
				<fo:block line-height="125%">
					<xsl:apply-templates select="."/>
				</fo:block>
			</fo:flow>
		</fo:page-sequence>
	</xsl:template>
	
	<xsl:template  name="sections_appendix">
		<fo:page-sequence master-reference="document" force-page-count="no-force">
			<xsl:call-template name="insertFootnoteSeparator"/>
			
			<xsl:variable name="curr_lang" select="/mn:metanorma/mn:bibdata/mn:language[@current = 'true']"/>
												
			<xsl:variable name="header-title">
				<xsl:choose>
					<xsl:when test="$lang = 'fr'">Annexe </xsl:when>
					<xsl:otherwise>Appendix </xsl:otherwise>
				</xsl:choose>
				<xsl:value-of select="/mn:metanorma/mn:bibdata/mn:ext/mn:structuredidentifier/mn:appendix"/>
			</xsl:variable>
			<xsl:call-template name="insertHeaderFooter">
				<xsl:with-param name="header-title" select="$header-title"/>
			</xsl:call-template>
			
			<fo:flow flow-name="xsl-region-body">
				<fo:block line-height="125%">
					
					<xsl:for-each select=" mn:sections/*">				
						<xsl:apply-templates select="."/>
					</xsl:for-each>
				</fo:block>
			</fo:flow>
		</fo:page-sequence>
	</xsl:template>
	
	<xsl:template match="mn:metanorma/mn:bibdata/mn:edition">
		<xsl:param name="font-size" select="'65%'"/>
		<xsl:param name="baseline-shift" select="'30%'"/>
		<xsl:param name="curr_lang" select="'fr'"/>
		<fo:inline>
			<xsl:value-of select="."/>
			<fo:inline font-size="{$font-size}" baseline-shift="{$baseline-shift}">
				<xsl:call-template name="number-to-ordinal">
					<xsl:with-param name="number" select="."/>
					<xsl:with-param name="curr_lang" select="$curr_lang"/>
				</xsl:call-template>
			</fo:inline>
			<xsl:text> </xsl:text>			
			<xsl:call-template name="getLocalizedString">
				<xsl:with-param name="key">edition</xsl:with-param>
			</xsl:call-template>
			<xsl:text></xsl:text>
		</fo:inline>
	</xsl:template>

	
	<xsl:template match="mn:feedback-statement//mn:p" priority="2">
		<fo:block margin-top="6pt">
			<xsl:variable name="p_num"><xsl:number/></xsl:variable>			
			<xsl:if test="$p_num = 1">Édité par le </xsl:if>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>

	<!-- ====== -->
	<!-- title      -->
	<!-- ====== -->
	
	
	<xsl:template match="mn:fmt-title" name="title">
		
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		
		<xsl:variable name="font-size">
			<xsl:choose>
				<xsl:when test="$level = 1">16pt</xsl:when>
				<xsl:when test="$level = 2 and ancestor::mn:annex and ../@type = 'toc'">16pt</xsl:when>
				<xsl:when test="$level = 2 and ancestor::mn:annex">10.5pt</xsl:when>
				<xsl:when test="$level = 2">14pt</xsl:when>
				<xsl:when test="$level &gt;= 3 and ancestor::mn:annex and ../@type = 'toc'">9pt</xsl:when>
				<xsl:when test="$level = 3 and ancestor::mn:annex">10pt</xsl:when>
				<xsl:when test="$level &gt;= 4 and ancestor::mn:annex">9pt</xsl:when>
				<xsl:when test="$level = 3">12pt</xsl:when>
				<xsl:otherwise>11pt</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		
		<xsl:variable name="element-name">
			<xsl:choose>
				<xsl:when test="../@inline-header = 'true'">fo:inline</xsl:when>
				<xsl:otherwise>fo:block</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<fo:block-container margin-left="-14mm" font-family="Arial" font-size="{$font-size}" font-weight="bold" keep-with-next="always"  line-height="130%">				 <!-- line-height="145%" -->
			<xsl:if test="local-name(preceding-sibling::*[1]) = 'clause'">
				<xsl:attribute name="id"><xsl:value-of select="preceding-sibling::*[1]/@id"/></xsl:attribute>
			</xsl:if>
			<xsl:attribute name="margin-bottom">
				<xsl:choose>
					<xsl:when test="$level = 1 and (parent::mn:annex or ancestor::mn:annex or parent::mn:abstract or ancestor::mn:preface)">84pt</xsl:when>
					<xsl:when test="$level = 1">6pt</xsl:when>
					<xsl:when test="$level = 2 and ancestor::mn:annex and ../@type = 'toc'">29mm</xsl:when>
					<xsl:when test="$level = 2 and ancestor::mn:annex">6pt</xsl:when>
					<xsl:when test="$level = 2">10pt</xsl:when>
					<xsl:otherwise>6pt</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>			
			
			<xsl:if test="$level = 2 and ancestor::mn:annex">
				<xsl:attribute name="space-before">18pt</xsl:attribute> <!-- 24 pt -->
			</xsl:if>
			<xsl:if test="$level = 2 and not(ancestor::mn:annex)">
				<xsl:attribute name="space-before">30pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="$level = 3 and ancestor::mn:annex">
				<xsl:attribute name="space-before">12pt</xsl:attribute> <!-- 6pt -->
			</xsl:if>
			<xsl:if test="$level = 4 and ancestor::mn:annex">
				<xsl:attribute name="space-before">12pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="$level = 3 and not(ancestor::mn:annex)">
				<xsl:attribute name="space-before">20pt</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="$level &gt;= 3 and ancestor::mn:annex and ../@type = 'toc'">
				<xsl:attribute name="space-before">0pt</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="@type = 'quoted'">
				<xsl:attribute name="font-weight">normal</xsl:attribute>
			</xsl:if>
			
			<fo:block-container margin-left="0mm">
				
				<xsl:choose>
					<xsl:when test="mn:tab and not(ancestor::mn:annex) "><!-- split number and title -->
						<fo:table table-layout="fixed" width="100%" role="H{$level}">
							<fo:table-column column-width="14mm"/>
							<fo:table-column column-width="136mm"/>
							<fo:table-body>
								<fo:table-row>
									<fo:table-cell>
										<fo:block role="H{$level}">
											<xsl:value-of select="mn:tab[1]/preceding-sibling::node()"/>
										</fo:block>
									</fo:table-cell>
									<fo:table-cell>
										<fo:block line-height-shift-adjustment="disregard-shifts" role="H{$level}">
											<xsl:call-template name="extractTitle"/>
											<xsl:apply-templates select="following-sibling::*[1][self::mn:variant-title][@type = 'sub']" mode="subtitle"/>
										</fo:block>
									</fo:table-cell>
								</fo:table-row>
							</fo:table-body>
						</fo:table>
					</xsl:when>
					<xsl:otherwise>
						<fo:block role="H{$level}">
							
							<xsl:if test="ancestor::mn:clause[@type = 'toc'] and $level &gt;= 3">
								<xsl:attribute name="role">Caption</xsl:attribute>
							</xsl:if>
							
							<xsl:choose>
								<xsl:when test="ancestor::mn:annex and $level &gt;= 2">
									<xsl:if test="$level &gt;= 3">
										<xsl:attribute name="margin-left">14mm</xsl:attribute>
									</xsl:if>
									<xsl:if test="$level = 4">
										<xsl:attribute name="text-align">center</xsl:attribute>
									</xsl:if>
									<xsl:if test="../@type = 'toc'">
										<xsl:attribute name="text-align">left</xsl:attribute>
									</xsl:if>
									
									<xsl:apply-templates />
									<xsl:apply-templates select="following-sibling::*[1][self::mn:variant-title][@type = 'sub']" mode="subtitle"/>
								</xsl:when>
								<xsl:otherwise>
									
									<xsl:apply-templates />
									<xsl:apply-templates select="following-sibling::*[1][self::mn:variant-title][@type = 'sub']" mode="subtitle"/>
										
								</xsl:otherwise>
							</xsl:choose>
							<xsl:if test=".//mn:note_side">
								<fo:inline>*</fo:inline>
							</xsl:if>
						</fo:block>
					</xsl:otherwise>
				</xsl:choose>
			</fo:block-container>
		</fo:block-container>

	</xsl:template>
	
	
	<xsl:template match="*" mode="header">
		<xsl:apply-templates mode="header"/>
	</xsl:template>

	<xsl:template match="mn:fmt-stem" mode="header">
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="mn:br" mode="header">
		<xsl:text> </xsl:text>
	</xsl:template>
	
	<xsl:template match="mn:sub" mode="header">
		<xsl:apply-templates select="."/>
	</xsl:template>
	
	<xsl:template match="mn:sup" mode="header">
		<xsl:apply-templates select="."/>
	</xsl:template>
	
	<!-- ====== -->
	<!-- ====== -->


	<xsl:template match="mn:preface/*[not(self::mn:note or self::mn:admonition)][1]" priority="3">
		<fo:block keep-with-next="always">
			<xsl:call-template name="setId"/>
			<xsl:call-template name="addReviewHelper"/>
		</fo:block>
		<fo:table table-layout="fixed" width="173.5mm">
			<xsl:call-template name="setId">
				<xsl:with-param name="prefix">__internal_layout__</xsl:with-param>
			</xsl:call-template>
			<fo:table-column column-width="137mm"/>
			<fo:table-column column-width="2.5mm"/>
			<fo:table-column column-width="34mm"/>
			<fo:table-body>
			
				<xsl:variable name="rows2">
					<xsl:for-each select="*">
						<xsl:variable name="position" select="position()"/>
						<!-- if this is  first element -->
						<xsl:variable name="isFirstRow" select="not(preceding-sibling::*)"/>  
						<!--  first element without note -->					
						<xsl:variable name="isFirstCellAfterNote" select="$isFirstRow = true() or count(preceding-sibling::*[1][.//mn:note]) = 1"/>					
						<xsl:variable name="curr_id" select="generate-id()"/>						
						<xsl:variable name="rowsUntilNote" select="count(following-sibling::*[.//mn:note[not(ancestor::mn:table)]][1]/preceding-sibling::*[preceding-sibling::*[generate-id() = $curr_id]])"/>
						
						<xsl:if test="$isFirstCellAfterNote = true()">
							<num span_start="{$position}" span_num="{$rowsUntilNote + 2}" display-align="after">
								<xsl:if test="count(following-sibling::*[.//mn:note[not(ancestor::mn:table)]]) = 0"><!-- if there aren't notes more, then set -1 -->
									<xsl:attribute name="span_start"><xsl:value-of select="$position"/>_no_more_notes</xsl:attribute>
								</xsl:if>
								<xsl:if test="count(following-sibling::*[.//mn:note[not(ancestor::mn:table)]]) = 1"> <!-- if there is only one note, then set -1, because notes will be display near accoring text-->							
									<xsl:attribute name="span_start"><xsl:value-of select="$position"/>_last_note</xsl:attribute>
								</xsl:if>
							</num>
						</xsl:if>
						<xsl:if test=".//mn:note[not(ancestor::mn:table)] and count(following-sibling::*[.//mn:note[not(ancestor::mn:table)]]) = 0"> <!-- if current row there is note, and no more notes below -->
							<num span_start="{$position}" span_num="{count(following-sibling::*) + 1}" display-align="before"/>
						</xsl:if>
						<xsl:if test=".//mn:note[not(ancestor::mn:table)] and following-sibling::*[1][.//mn:note[not(ancestor::mn:table)]] and preceding-sibling::*[1][.//mn:note[not(ancestor::mn:table)]]">
							<num span_start="{$position}" span_num="1" display-align="before"/>
						</xsl:if>
						
					</xsl:for-each>
				</xsl:variable>
				
				
				<xsl:variable name="total_rows" select="count(*)"/>
				
				<xsl:variable name="rows_with_notes">					
					<xsl:for-each select="*">						
						<xsl:if test=".//mn:note_side"> <!-- virtual element note_side -->
							<row_num><xsl:value-of select="position()"/></row_num>
						</xsl:if>
					</xsl:for-each>
				</xsl:variable>
				
				<xsl:variable name="rows">
					<xsl:for-each select="xalan:nodeset($rows_with_notes)/row_num">
						<xsl:variable name="num" select="number(.)"/>
						<xsl:choose>
							<xsl:when test="position() = 1">
								<num span_start="1" span_num="{$num}" display-align="after"/>
							</xsl:when>
							<xsl:when test="position() = last()">
								<num span_start="{$num}" span_num="{$total_rows - $num + 1}" display-align="before"/>
							</xsl:when>
							<xsl:otherwise><!-- 2nd, 3rd, ... Nth-1 -->
								<xsl:variable name="prev_num" select="number(preceding-sibling::*/text())"/>
								<num span_start="{$prev_num + 1}" span_num="{$num - $prev_num}" display-align="after"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:variable>
				
				<xsl:variable name="rows3">					
					<xsl:for-each select="xalan:nodeset($rows_with_notes)/row_num">
						<xsl:variable name="num" select="number(.)"/>
						<xsl:choose>						
							<xsl:when test="position() = last()">
								<num span_start="{$num}" span_num="{$total_rows - $num + 1}" display-align="before"/>
							</xsl:when>
							<xsl:otherwise><!-- 2nd, 3rd, ... Nth-1 -->		
								<xsl:variable name="next_num" select="number(following-sibling::*/text())"/>
								<num span_start="{$num}" span_num="{$next_num - $num}" display-align="before"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:variable>

				
				<xsl:apply-templates mode="clause_table">
					<xsl:with-param name="rows" select="$rows"/>
				</xsl:apply-templates>
			</fo:table-body>
		</fo:table>
	</xsl:template>
	

	<xsl:template match="mn:preface/*[not(self::mn:note or self::mn:admonition)][1]/*" mode="clause_table">
		<xsl:param name="rows"/>
		
		<xsl:variable name="current_row"><xsl:number count="*"/></xsl:variable>
		
		<fo:table-row >
			<fo:table-cell  >				
				<fo:block>					
					<xsl:apply-templates select="."/>
				</fo:block>
			</fo:table-cell>
			<fo:table-cell><fo:block>&#xA0;</fo:block></fo:table-cell>
			
			
			<xsl:if test="xalan:nodeset($rows)/num[@span_start = $current_row]">
				<fo:table-cell font-size="8pt" line-height="120%" display-align="before">
				
					<xsl:variable name="current_row_with_note" select="xalan:nodeset($rows)/num[@span_start = $current_row]"/>
					
					<xsl:attribute name="display-align">
						<xsl:value-of select="$current_row_with_note/@display-align"/>
					</xsl:attribute>
					
					<xsl:variable name="number-rows-spanned" select="$current_row_with_note/@span_num"/>
					<xsl:attribute name="number-rows-spanned">
						<xsl:value-of select="$number-rows-spanned"/>
					</xsl:attribute>
					
					<xsl:variable name="start_row" select="$current_row"/>
					<xsl:variable name="end_row" select="$current_row + $number-rows-spanned"/>
					<fo:block>
						
						<xsl:for-each select="ancestor::mn:preface/*[not(self::mn:note or self::mn:admonition)][1]/*[position() &gt;= $start_row and position() &lt; $end_row]//mn:note_side">
							<xsl:apply-templates select="." mode="note_side"/>
						</xsl:for-each>
					</fo:block>
					
					
				</fo:table-cell>
				
			</xsl:if>
			
			
		</fo:table-row>
	</xsl:template>
	
	
	<xsl:template match="mn:sections/mn:clause | mn:annex/mn:clause" priority="3">
			
		<xsl:variable name="space-before"> <!-- margin-top for title, see mn:title -->
			<xsl:if test="local-name(*[1]) = 'fmt-title'">
					<xsl:if test="*[1]/@depth = 1 and not(*[1]/ancestor::mn:annex) and $independentAppendix != ''">30pt</xsl:if>
					<xsl:if test="*[1]/@depth = 2 and not(*[1]/ancestor::mn:annex)">30pt</xsl:if>
					<xsl:if test="*[1]/@depth = 2 and *[1]/ancestor::mn:annex">18pt</xsl:if> <!-- 24pt -->
					<xsl:if test="*[1]/@depth = 3 and not(*[1]/ancestor::mn:annex)">20pt</xsl:if>
					<xsl:if test="*[1]/@depth = 3 and *[1]/ancestor::mn:annex">6pt</xsl:if> <!-- 6pt-->
					<xsl:if test="*[1]/@depth = 4 and *[1]/ancestor::mn:annex">12pt</xsl:if> <!-- 6pt-->
			</xsl:if>						
		</xsl:variable>					
		<xsl:variable name="space-before-value" select="normalize-space($space-before)"/>			
		
		<fo:block keep-with-next="always">
			<xsl:call-template name="setId"/>
			<xsl:call-template name="addReviewHelper"/>
		</fo:block>
		<fo:table table-layout="fixed" width="174mm" line-height="135%">
			<xsl:if test="@orientation = 'landscape'">
				<xsl:attribute name="width">261mm</xsl:attribute> <!-- 87 = (297 - 210) -->
			</xsl:if>
			<xsl:call-template name="setId">
				<xsl:with-param name="prefix">__internal_layout__</xsl:with-param>
			</xsl:call-template>
			<xsl:if test="$space-before-value != ''">
				<xsl:attribute name="space-before"><xsl:value-of select="$space-before-value"/></xsl:attribute>
			</xsl:if>
			
			<xsl:choose>
				<xsl:when test="@orientation = 'landscape'"> 
					<fo:table-column column-width="224mm"/> <!-- +87  -->
				</xsl:when>
				<xsl:otherwise>
					<fo:table-column column-width="137mm"/>
				</xsl:otherwise>
			</xsl:choose>
			<fo:table-column column-width="5mm"/>
			<fo:table-column column-width="32mm"/>
			
			<fo:table-body>
				
				<xsl:variable name="total_rows" select="count(*)"/>
				
				<xsl:variable name="rows_with_notes">					
					<xsl:for-each select="*">						
						<xsl:if test=".//mn:note_side"> <!-- virtual element note_side -->
							<row_num><xsl:value-of select="position()"/></row_num>
						</xsl:if>
					</xsl:for-each>
				</xsl:variable>
				
				<xsl:variable name="rows3">
					<xsl:for-each select="xalan:nodeset($rows_with_notes)/row_num">
						<xsl:variable name="num" select="number(.)"/>
						<xsl:choose>
							<xsl:when test="position() = 1">
								<num span_start="1" span_num="{$num}" display-align="after"/>
							</xsl:when>
							<xsl:when test="position() = last()">
								<num span_start="{$num}" span_num="{$total_rows - $num + 1}" display-align="before"/>
							</xsl:when>
							<xsl:otherwise><!-- 2nd, 3rd, ... Nth-1 -->
								<xsl:variable name="prev_num" select="number(preceding-sibling::*/text())"/>
								<num span_start="{$prev_num + 1}" span_num="{$num - $prev_num}" display-align="after"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:variable>
				
				<xsl:variable name="rows">
					
					<xsl:variable name="first_num" select="normalize-space(xalan:nodeset($rows_with_notes)/row_num[1])"/>
					<xsl:choose>
						<xsl:when test="$first_num = ''">
							<num span_start="1" span_num="{$total_rows}" display-align="before"/>
						</xsl:when>
						<xsl:when test="number($first_num) != 1">
							<num span_start="1" span_num="{$first_num -1}" display-align="before"/>
						</xsl:when>
					</xsl:choose>
					
					<xsl:for-each select="xalan:nodeset($rows_with_notes)/row_num">
						<xsl:variable name="num" select="number(.)"/>
						<xsl:choose>								
							<xsl:when test="position() = last()">
								<num span_start="{$num}" span_num="{$total_rows - $num + 1}" display-align="before"/>
							</xsl:when>
							<xsl:otherwise><!-- 2nd, 3rd, ... Nth-1 -->		
								<xsl:variable name="next_num" select="number(following-sibling::*/text())"/>
								<num span_start="{$num}" span_num="{$next_num - $num}" display-align="before"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:variable>
				
				<!-- updated strategy: consolidated show all block with note, instead of spanned rows -->
				
				<xsl:call-template name="insertClauses">
					<xsl:with-param name="rows" select="$rows"/>
				</xsl:call-template>
					
			</fo:table-body>
		</fo:table>

	</xsl:template>
	
	
	<xsl:template name="insertClauses">
			<xsl:param name="rows"/>
			<xsl:param name="curr_row_num" select="1"/>
			
			<xsl:if test="$curr_row_num &lt;=  count(xalan:nodeset($rows)/num)">
				<xsl:variable name="start_row" select="xalan:nodeset($rows)/num[$curr_row_num]/@span_start"/>
				<xsl:variable name="end_row" select="$start_row + xalan:nodeset($rows)/num[$curr_row_num]/@span_num - 1"/>
				<fo:table-row > <!-- DEBUG border-top="1.5pt solid blue" border-bottom="1.5pt solid blue" -->
					<xsl:if test="local-name(*[$end_row]) = 'fmt-title'"> <!-- if last element is title, then keep row with next--> <!--  or local-name(*[$end_row]) = 'clause' or clause, then keep row with next -->
						<xsl:attribute  name="keep-with-next.within-page">always</xsl:attribute>
					</xsl:if>
					
					
					<xsl:variable name="start_row_next" select="normalize-space(xalan:nodeset($rows)/num[$curr_row_num + 1]/@span_start)" />
					<xsl:variable name="start_row_next_num" select="number($start_row_next)"/>
					
					<xsl:variable name="table-row-padding-bottom">						
						<xsl:if test="$start_row_next != '' and local-name(*[$start_row_next_num]) = 'fmt-title'">
								<xsl:if test="*[$start_row_next_num]/@depth = 2 and not(*[$start_row_next_num]/ancestor::mn:annex)">30pt</xsl:if>
								<xsl:if test="*[$start_row_next_num]/@depth = 2 and *[$start_row_next_num]/ancestor::mn:annex">18pt</xsl:if> <!-- 24pt -->
								<xsl:if test="*[$start_row_next_num]/@depth = 3 and not(*[$start_row_next_num]/ancestor::mn:annex)">20pt</xsl:if>
								<xsl:if test="*[$start_row_next_num]/@depth = 3 and *[$start_row_next_num]/ancestor::mn:annex">6pt</xsl:if> <!-- 6pt -->
								<xsl:if test="*[$start_row_next_num]/@depth = 4 and *[$start_row_next_num]/ancestor::mn:annex">12pt</xsl:if> <!-- 6pt -->
						</xsl:if>						
					</xsl:variable>					
					
					<xsl:variable name="table-row-padding-bottom-value" select="normalize-space($table-row-padding-bottom)"/>
					
					<fo:table-cell>	
						
						<xsl:if test="$table-row-padding-bottom-value != ''">
							<xsl:attribute name="padding-bottom"><xsl:value-of select="$table-row-padding-bottom-value"/></xsl:attribute>
						</xsl:if>
						
						
						<fo:block>
							<!-- insert elements from sections/clause annex/clause -->
							<xsl:apply-templates select="*[position() &gt;= number($start_row) and position() &lt;= $end_row]"/>							
						</fo:block>
					</fo:table-cell>
					<fo:table-cell>
						<xsl:if test="$table-row-padding-bottom-value != ''">
							<xsl:attribute name="padding-bottom"><xsl:value-of select="$table-row-padding-bottom-value"/></xsl:attribute>
						</xsl:if>
						<fo:block>&#xA0;</fo:block>
					</fo:table-cell> <!-- <fo:block/> <fo:block>&#xA0;</fo:block> -->
					<fo:table-cell font-size="8pt" line-height="120%" display-align="before" padding-bottom="6pt">
						<xsl:if test="$table-row-padding-bottom-value != ''">
							<xsl:attribute name="padding-bottom"><xsl:value-of select="$table-row-padding-bottom-value"/></xsl:attribute>
						</xsl:if>
						
						<xsl:attribute name="display-align">
							<xsl:value-of select="xalan:nodeset($rows)/num[$curr_row_num]/@display-align"/>
						</xsl:attribute>
							
							<fo:block>												
								<xsl:for-each select="*[position() &gt;= $start_row and position() &lt;= $end_row]//mn:note_side">												
									<xsl:apply-templates select="." mode="note_side"/>
								</xsl:for-each>
							</fo:block>
					</fo:table-cell>
				</fo:table-row>	
				<xsl:call-template name="insertClauses">
					<xsl:with-param name="rows" select="$rows"/>
					<xsl:with-param name="curr_row_num" select="$curr_row_num + 1"/>
				</xsl:call-template>
			</xsl:if>
			
		</xsl:template>

	<xsl:template match="mn:sections/mn:clause/* | mn:annex/mn:clause/*" mode="clause_table">
		<xsl:param name="rows"/>
		
		
		<xsl:variable name="current_row"><xsl:number count="*"/></xsl:variable>
		
	
		<fo:table-row>
			<fo:table-cell>
				<fo:block>					
					<xsl:apply-templates select="."/>					
				</fo:block>
			</fo:table-cell>
			<fo:table-cell><fo:block>&#xA0;</fo:block></fo:table-cell> <!-- <fo:block/> <fo:block>&#xA0;</fo:block> -->
			
			
			<xsl:if test="xalan:nodeset($rows)/num[@span_start = $current_row]">
				<fo:table-cell font-size="8pt" line-height="120%" display-align="before" padding-bottom="6pt">
					
					<xsl:variable name="current_row_with_note" select="xalan:nodeset($rows)/num[@span_start = $current_row]"/>
				
					<xsl:attribute name="display-align">
						<xsl:value-of select="$current_row_with_note/@display-align"/>
					</xsl:attribute>
					
					<xsl:variable name="number-rows-spanned" select="$current_row_with_note/@span_num"/>
					<xsl:attribute name="number-rows-spanned">
						<xsl:value-of select="$number-rows-spanned"/>
					</xsl:attribute>
					
					<xsl:variable name="start_row" select="$current_row"/>
					<xsl:variable name="end_row" select="$current_row + $number-rows-spanned"/>
					
					<fo:block>
						
						<xsl:for-each select="ancestor::*[1]/*[position() &gt;= $start_row and position() &lt; $end_row]//mn:note_side">
							
							<xsl:apply-templates select="." mode="note_side"/>
						</xsl:for-each>
					</fo:block>
				
				</fo:table-cell>
			</xsl:if>
		
		</fo:table-row>
	</xsl:template>

	<!-- from common.xsl -->
	<xsl:template match="mn:clause" priority="2">
		<xsl:choose>
			<xsl:when test="count(./node()) = 0"> <!-- if empty clause, then move id into next title -->
				<xsl:choose>
					<xsl:when test="local-name(following-sibling::*[1]) = 'fmt-title'"/> <!-- id will set in title -->
					<xsl:otherwise>
						<fo:block>
							<xsl:call-template name="setId"/>
							<xsl:call-template name="addReviewHelper"/>
							<xsl:apply-templates />
						</fo:block>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<fo:block>
					<xsl:call-template name="setId"/>
					<xsl:call-template name="addReviewHelper"/>
					<xsl:apply-templates />
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>


	<!-- skip, because it process in note_side template -->
	<xsl:template match="mn:preface/*[not(self::mn:note or self::mn:admonition)][1]//mn:note_side" priority="3"/>
	
	
	<xsl:template match="mn:sections//mn:note_side | mn:annex//mn:note_side" priority="3">
	
	</xsl:template>
	
	
	<xsl:template match="mn:note_side" mode="note_side">
		<fo:block line-height-shift-adjustment="disregard-shifts" space-after="4pt">
			<xsl:call-template name="setId"/>
			
			<xsl:if test="ancestor::mn:table"><!-- move table note lower than title -->
				<xsl:variable name="table_id" select="ancestor::mn:table[1]/@id"/>
				<xsl:variable name="num">
					<xsl:number count="//mn:table[@id = $table_id]//mn:note_side" level="any"/>
				</xsl:variable>
				<xsl:if test="$num = 1 and ancestor::mn:table[1]/mn:fmt-name/mn:tab" >
					<xsl:attribute name="margin-top">48pt</xsl:attribute>				
				</xsl:if>
				
			</xsl:if>
			
			<xsl:call-template name="addReviewHelper"/>
			
			<!-- if note relates to title, but not fn -->
			<xsl:if test="ancestor::mn:fmt-title and not(mn:sup_fn)"><fo:inline>* </fo:inline></xsl:if>
			
			<xsl:apply-templates mode="note_side"/>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="mn:note_side/mn:fmt-name" mode="note_side" priority="2"/>	
	<xsl:template match="mn:note_side/*" mode="note_side">
		<xsl:apply-templates select="."/>
	</xsl:template>

	<!-- note_side/fmt-fn-label in text -->
	<xsl:template match="mn:note_side//mn:fmt-fn-label"/>


	<xsl:template match="mn:note_side/mn:p">
		<xsl:variable name="num"><xsl:number/></xsl:variable>
		<xsl:choose>
			<xsl:when test="$num = 1">
				<fo:inline xsl:use-attribute-sets="note-p-style">
					<xsl:attribute name="text-align">left</xsl:attribute>
					<xsl:apply-templates />
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<fo:block xsl:use-attribute-sets="note-p-style">						
					<xsl:attribute name="text-align">left</xsl:attribute>
					<xsl:apply-templates />
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<xsl:template match="mn:fn/mn:p">
		<fo:block>
			<xsl:apply-templates />
		</fo:block>
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
		
		<xsl:element name="{$element-name}">
			<xsl:attribute name="id">
				<xsl:value-of select="@id"/>
			</xsl:attribute>
			<xsl:attribute name="text-align">
				<xsl:choose>
					<xsl:when test="@align"><xsl:value-of select="@align"/></xsl:when>
					<xsl:when test="ancestor::mn:note_side">left</xsl:when>
					<xsl:when test="../@align"><xsl:value-of select="../@align"/></xsl:when>
					<xsl:otherwise>justify</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:call-template name="setKeepAttributes"/>
			<xsl:copy-of select="@font-family"/>
			<xsl:if test="not(ancestor::mn:table)">
				<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="ancestor::mn:table and ancestor::mn:preface">
				<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="parent::mn:li">
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="@align = 'center'">
				<xsl:attribute name="keep-with-next">always</xsl:attribute>
			</xsl:if>
			<xsl:if test="*[1][self::mn:strong] and normalize-space(.) = normalize-space(*[1])">
				<xsl:attribute name="keep-with-next">always</xsl:attribute>
			</xsl:if>
			<xsl:if test="@parent-type = 'quote'">
				<xsl:attribute name="font-family">Arial</xsl:attribute>
				<xsl:attribute name="font-size">9pt</xsl:attribute>
				<xsl:attribute name="line-height">130%</xsl:attribute>
				<xsl:attribute name="role">BlockQuote</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="line-height-shift-adjustment">disregard-shifts</xsl:attribute>
			<xsl:apply-templates>
				<xsl:with-param name="split_keep-within-line" select="$split_keep-within-line"/>
			</xsl:apply-templates>
		</xsl:element>
		<xsl:if test="$element-name = 'fo:inline' and not($inline = 'true') and not(parent::mn:admonition)">
			<fo:block margin-bottom="6pt">
				 <xsl:if test="ancestor::mn:annex">
					<xsl:attribute name="margin-bottom">0</xsl:attribute>
				 </xsl:if>
				<xsl:value-of select="$linebreak"/>
			</fo:block>
		</xsl:if>
		<xsl:if test="$inline = 'true'">
			<fo:block>&#xA0;</fo:block>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:table/mn:note/mn:p" priority="4">
		<xsl:choose>
			<xsl:when test="ancestor::mn:preface">
				<xsl:call-template name="paragraph"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates />
			</xsl:otherwise>
		</xsl:choose>		
	</xsl:template>


	<xsl:template match="mn:ul | mn:ol" mode="list" priority="2">
		<xsl:apply-templates /><!-- for second level -->
	</xsl:template>
	
	<!-- process list item as individual list --> <!-- flat list -->
	<xsl:template match="mn:li" priority="2">
		<fo:block-container margin-left="0mm"> <!-- debug:  border="0.5pt solid black" -->
			<xsl:if test="ancestor::mn:li">
				<xsl:attribute name="margin-left">6.5mm</xsl:attribute><!-- 8 mm -->
			</xsl:if>
			<xsl:if test="@parent-type = 'quote'">
				<xsl:attribute name="font-family">Arial</xsl:attribute>
				<xsl:attribute name="font-size">9pt</xsl:attribute>
				<xsl:attribute name="line-height">130%</xsl:attribute>
				<xsl:attribute name="role">BlockQuote</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="ancestor::mn:preface">
				<xsl:attribute name="space-after">6pt</xsl:attribute>
			</xsl:if>
			
			<!-- last item -->		
			<xsl:if test="not(following-sibling::*[1][self::mn:li])">
				<xsl:attribute name="space-after">6pt</xsl:attribute>
				<xsl:if test="../ancestor::mn:ul | ../ancestor::mn:ol">					
					<xsl:attribute name="space-after">0pt</xsl:attribute>
				</xsl:if>
				<xsl:if test="../following-sibling::*[1][self::mn:ul or self::mn:ol]">					
					<xsl:attribute name="space-after">0pt</xsl:attribute>
				</xsl:if>						
			</xsl:if>
			
			<fo:block-container margin-left="0mm">
				<fo:list-block provisional-distance-between-starts="6.5mm"> <!-- debug: border="0.5pt solid blue" -->

					<xsl:if test="ancestor::mn:note_side">
						<xsl:attribute name="provisional-distance-between-starts">0mm</xsl:attribute>
					</xsl:if>
	
					<fo:list-item id="{@id}">
						<fo:list-item-label end-indent="label-end()">
							<fo:block> <!-- debug: border="0.5pt solid green" -->
								<fo:inline>
									<xsl:if test="@list_type = 'ul'">
										<xsl:variable name="li_label" select="@label"/>
										<xsl:copy-of select="$ul_labels//label[. = $li_label]/@*[not(local-name() = 'level')]"/>
									</xsl:if>
									
									<xsl:copy-of select="@font-size"/>
									<xsl:copy-of select="@baseline-shift"/>
									<xsl:if test="@list_type = 'ul' and ancestor::mn:note_side">
										<xsl:attribute name="font-size">10pt</xsl:attribute>
									</xsl:if>
									
									<xsl:value-of select="@label"/>
								</fo:inline>
							</fo:block>
						</fo:list-item-label>
						<fo:list-item-body start-indent="body-start()" line-height-shift-adjustment="disregard-shifts">
							<fo:block margin-bottom="0pt"> <!-- debug:   border="0.5pt solid red" -->
								<xsl:if test="@list_type = 'ol'">
									<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
								</xsl:if>
								<xsl:if test="ancestor::mn:note_side">
									<xsl:attribute name="text-indent">3mm</xsl:attribute>
								</xsl:if>
								
								<xsl:apply-templates />
							</fo:block>
						</fo:list-item-body>
					</fo:list-item>
				</fo:list-block>
		
			</fo:block-container>
		</fo:block-container>
		
		<xsl:if test="not(following-sibling::*[1][self::mn:li]) and 
								not(../ancestor::mn:ul | ../ancestor::mn:ol) and not (../following-sibling::*[1][self::mn:ul or self::mn:ol])"> 		
			<fo:block/>
		</xsl:if>
		
	</xsl:template>

	
	<xsl:template match="mn:example | mn:termexample" priority="2">
		<fo:block keep-together.within-column="1" xsl:use-attribute-sets="example-style">
			<fo:table table-layout="fixed" width="100%">
				<fo:table-column column-width="proportional-column-width(27)"/>
				<fo:table-column column-width="proportional-column-width(108)"/>
				<fo:table-body>
					<fo:table-row>
						<fo:table-cell>
							<fo:block>
								<xsl:apply-templates select="mn:fmt-name"/>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell>
							<fo:block>
								<xsl:apply-templates select="node()[not(self::mn:fmt-name)]"/>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</fo:table-body>
			</fo:table>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:fmt-preferred" priority="2">		
		<fo:block font-weight="bold" keep-with-next="always" space-before="8pt" margin-bottom="6pt">
			<xsl:call-template name="setStyle_preferred"/>
			<xsl:if test="ancestor::mn:term[1]/mn:fmt-name">
				<xsl:variable name="level">
					<xsl:call-template name="getLevelTermName"/>
				</xsl:variable>
				<fo:inline role="H{$level}" font-weight="bold" padding-right="2mm">
					<xsl:apply-templates select="ancestor::mn:term[1]/mn:fmt-name" />
				</fo:inline>
			</xsl:if>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>


	
	<xsl:template match="mn:references/mn:bibitem/mn:docidentifier[(@type='metanorma' or @type='metanorma-ordinal') and ../mn:formattedref]"/>
	

	<xsl:template match="mn:pagebreak" priority="2">
		<fo:block break-after="page"/>
	</xsl:template>

	
	<xsl:template match="mn:xref | mn:fmt-xref" priority="2">
		<xsl:call-template name="insert_basic_link">
			<xsl:with-param name="element">
				<fo:basic-link internal-destination="{@target}" fox:alt-text="{@target}">
				
					<xsl:if test="parent::mn:fmt-title">
						<xsl:attribute name="font-weight">normal</xsl:attribute>
					</xsl:if>
					
					<xsl:choose>
						<xsl:when test="@pagenumber='true'"><!-- ToC in Appendix, and page in references like this: « Le BIPM et la Convention du Mètre » (page 5). -->
							<fo:inline>
								<!-- DEBUG -->
								<xsl:if test="@id">
									<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
								</xsl:if>
								<fo:page-number-citation ref-id="{@target}"/>
								<!-- <xsl:if test="@to">&#x2013;<fo:page-number-citation ref-id="{@to}"/></xsl:if> -->
							</fo:inline>
						</xsl:when>
						<xsl:when test="starts-with(normalize-space(following-sibling::node()[1]), ')')">										
							<!-- add , see p. N -->				
							<!-- add , voir p. N -->
							<xsl:apply-templates />	
							
							<xsl:variable name="nopage" select="normalize-space(@nopage)"/>
							
							<xsl:if test="$nopage != 'true'">
								<xsl:text>, </xsl:text>
								<xsl:variable name="nosee" select="normalize-space(@nosee)"/>
								<xsl:if test="$nosee != 'true'">
									<xsl:variable name="curr_lang" select="ancestor::mn:metanorma/mn:bibdata/mn:language[@current = 'true']"/>					
									<fo:inline>
										<xsl:if test="ancestor::mn:note_side">
											<xsl:attribute name="font-style">italic</xsl:attribute>
										</xsl:if>
										<xsl:value-of select="ancestor::mn:metanorma/mn:localized-strings/mn:localized-string[@key='see' and @language=$curr_lang]"/>
									</fo:inline>
									<xsl:text> </xsl:text>
								</xsl:if>
								<xsl:text>p. </xsl:text>
								<fo:page-number-citation ref-id="{@target}"/>
							</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<fo:inline><xsl:apply-templates /></fo:inline>
						</xsl:otherwise>
					</xsl:choose>
				</fo:basic-link>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="mn:fmt-eref[.//mn:locality[@type = 'anchor']]" priority="2">
		<xsl:variable name="target" select=".//mn:locality[@type = 'anchor']/mn:referenceFrom"/>
		<xsl:call-template name="insert_basic_link">
			<xsl:with-param name="element">
				<fo:basic-link internal-destination="{$target}" fox:alt-text="{$target}">
					<xsl:if test="xalan:nodeset($ids)//id = $target">
						<fo:page-number-citation ref-id="{$target}"/>
					</xsl:if>
				</fo:basic-link>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="mn:note[not(ancestor::mn:preface)]/mn:fmt-name" priority="2">
		<xsl:choose>
			<xsl:when test="not(../preceding-sibling::mn:note) and not((../following-sibling::mn:note))">
				<!-- <xsl:variable name="curr_lang" select="ancestor::mn:metanorma/mn:bibdata/mn:language[@current = 'true']"/>
				<xsl:choose>
					<xsl:when test="$curr_lang = 'fr'">
						<xsl:choose>
							<xsl:when test="ancestor::mn:li">Remarque&#xa0;: </xsl:when>
							<xsl:otherwise>Note&#xa0;: </xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>Note: </xsl:otherwise>
				</xsl:choose> -->
				<xsl:apply-templates />
				<xsl:text> </xsl:text>
			</xsl:when>
			<xsl:when test="ancestor::mn:table and count(ancestor::mn:table//mn:note) &gt; 0">
				<xsl:variable name="table_id" select="ancestor::mn:table/@id"/>
				<xsl:number count="//mn:table[@id = $table_id]//mn:note"/><xsl:text>. </xsl:text>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="mn:note/mn:p" priority="3">
		<xsl:variable name="num"><xsl:number/></xsl:variable>
		<xsl:choose>
			<xsl:when test="$num = 1"> <!-- display first NOTE's paragraph in the same line with label NOTE -->
				<fo:inline xsl:use-attribute-sets="note-p-style">
					<xsl:apply-templates />
				</fo:inline>
			</xsl:when>
			<xsl:when test="ancestor::mn:preface">
				<fo:block xsl:use-attribute-sets="note-p-style">
					<xsl:attribute name="space-before">6pt</xsl:attribute>
					<xsl:apply-templates />
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<fo:inline xsl:use-attribute-sets="note-p-style">
					<xsl:apply-templates />
				</fo:inline>
				<fo:inline><xsl:value-of select="$linebreak"/></fo:inline>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="mn:fmt-name/text()" priority="2">
		<xsl:value-of select="."/>
	</xsl:template>

	<!-- <xsl:template match="mn:sup_fn/mn:sup"> -->
	<xsl:template match="mn:sup_fn">
		<fo:inline font-size="65%" keep-with-previous.within-line="always" vertical-align="super">
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="mn:fmt-fn-body//mn:sup_fn">
		<fo:inline xsl:use-attribute-sets="table-fmt-fn-label-style">
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>

	<!-- see <xsl:template match="*[local-name()='fn']"> -->
	<xsl:template match="mn:fn/mn:fmt-fn-label//mn:sup" priority="5">
		<xsl:apply-templates />
	</xsl:template>
	<!-- For: <fo:inline font-style="normal">(</fo:inline>a<fo:inline font-style="normal">)</fo:inline> -->
	<xsl:template match="mn:fmt-fn-label//mn:span[@class = 'fmt-label-delim']" priority="5">
		<fo:inline font-style="normal"><xsl:apply-templates /></fo:inline>
	</xsl:template>

	<!-- DEBUG -->
	<!-- <xsl:template match="mathml:math" priority="10"/> -->

	<!-- for chemical expressions, when prefix superscripted -->
	<xsl:template match="mathml:msup[count(*) = 2 and count(mathml:mrow) = 2]/mathml:mrow[1][count(*) = 1 and mathml:mtext and (mathml:mtext/text() = '' or not(mathml:mtext/text()))]/mathml:mtext" mode="mathml" priority="2">
		<mathml:mspace height="1ex"/>
	</xsl:template>
	<xsl:template match="mathml:msup[count(*) = 2 and count(mathml:mrow) = 2]/mathml:mrow[1][count(*) = 1 and mathml:mtext and (mathml:mtext/text() = ' ' or mathml:mtext/text() = '&#xa0;')]/mathml:mtext" mode="mathml" priority="2">
		<mathml:mspace width="1ex" height="1ex"/>
	</xsl:template>

	<!-- set height for sup -->
	<!-- <xsl:template match="mathml:msup[count(*) = 2 and count(mathml:mrow) = 2]/mathml:mrow[1][count(*) = 1 and mathml:mtext and (mathml:mtext/text() != '' and mathml:mtext/text() != ' ' and mathml:mtext/text() != '&#xa0;')]/mathml:mtext" mode="mtext"> -->
	<xsl:template match="mathml:msup[count(*) = 2 and count(mathml:mrow) = 2]/mathml:mrow[1][count(*) = 1 and not(mathml:mfenced)]/*" mode="mathml" priority="3">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="mathml"/>
		</xsl:copy>
		<!-- <xsl:copy-of select="."/> -->
		<mathml:mspace height="1.47ex"/>
	</xsl:template>

	<!-- set script minimal font-size -->
	<xsl:template match="mathml:math" mode="mathml" priority="2">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="mathml"/>
			<mathml:mstyle scriptminsize="6pt">
				<xsl:apply-templates select="node()" mode="mathml"/>
			</mathml:mstyle>
		</xsl:copy>
	</xsl:template>

	<!-- issue 'over bar above equation with sub' fixing -->
	<xsl:template match="mathml:msub/mathml:mrow[1][mathml:mover and count(following-sibling::*) = 1 and following-sibling::mathml:mrow]"  mode="mathml" priority="2">
		<mathml:mstyle>
			<xsl:copy-of select="."/>
		</mathml:mstyle>
	</xsl:template>

	<!-- Decrease space between ()
	from: 
	<mfenced open="(" close=")">
		<mrow>
			<mtext>Cu</mtext>
		</mrow>
	</mfenced> 
	to:
	<mfenced open="(" close=")" separators="">
		<mathml:mo rspace="-0.35em"></mathml:mo>
		<mathml:mspace width="-0.15em"/>
		<mrow>
			<mtext>Cu</mtext>
		</mrow>
		<mathml:mspace width="-0.1em"/>
	</mfenced> 
	-->
	<xsl:template match="mathml:mfenced[count(*) = 1]" mode="mathml" priority="2"> 
		<xsl:if test="preceding-sibling::*">
			<mathml:mo rspace="-0.35em"></mathml:mo><!-- decrease space before opening bracket -->
		</xsl:if>
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="mathml"/>
			<xsl:if test="not(@separators)">
				<xsl:attribute name="separators"></xsl:attribute>
			</xsl:if>
			<mathml:mspace width="-0.15em"/> <!-- decrease space between opening brackets  and inside text-->
			
			<!-- if there is previous or next mfenced with superscript, then increase height of Parentheses -->
			<xsl:if test="following-sibling::mathml:mfenced[.//mathml:msup] or preceding-sibling::mathml:mfenced[.//mathml:msup] or
			ancestor::*[following-sibling::mathml:mfenced[.//mathml:msup] or preceding-sibling::mathml:mfenced[.//mathml:msup]]">
				<mathml:mspace height="1.15em"/> <!-- increase height of parentheses -->
			</xsl:if>
			
			<xsl:apply-templates mode="mathml"/>
			<mathml:mspace width="-0.1em"/> <!-- decrease space between inside text and closing brackets -->
		</xsl:copy>
	</xsl:template>
		
	<!-- to: 
		<mrow>
			<mtext>(Cu)</mtext>
		</mrow> -->
		<!-- <xsl:template match="mathml:mfenced[count(*) = 1 and *[count(*) = 1] and */*[count(*) = 0]] |
																	mathml:mfenced[count(*) = 1 and *[count(*) = 1] and */*[count(*) = 1] and */*/*[count(*) = 0]]" mode="mathml" priority="2">
		<xsl:apply-templates mode="mathml"/>
	</xsl:template>
	<xsl:template match="mathml:mfenced[count(*) = 1]/*[count(*) = 1]/*[count(*) = 0] |
																	mathml:mfenced[count(*) = 1]/*[count(*) = 1]/*[count(*) = 1]/*[count(*) = 0]" mode="mathml" priority="2"> 
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="mathml"/>
			<xsl:value-of select="ancestor::mathml:mfenced[1]/@open"/>
			<xsl:value-of select="."/>
			<xsl:value-of select="ancestor::mathml:mfenced[1]/@close"/>
		</xsl:copy>
	</xsl:template> -->

	<!-- Decrease height of / and | -->
	<!-- Decrease space before and after / -->
	<xsl:template match="mathml:mo[normalize-space(text()) = '/' or normalize-space(text()) = '|']" mode="mathml" priority="2">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="mathml"/>
			<xsl:if test="not(@stretchy) and not(preceding-sibling::*[1][local-name() = 'mfrac'] and following-sibling::*[1][local-name() = 'mfrac'])">
				<xsl:attribute name="stretchy">false</xsl:attribute>
			</xsl:if>
			<xsl:if test="normalize-space(text()) = '/'">
				<xsl:if test="not(@lspace)">
					<xsl:attribute name="lspace">0em</xsl:attribute>
					<xsl:if test="preceding-sibling::*[1][local-name() = 'msub']">
						<xsl:attribute name="lspace">0.1em</xsl:attribute>
					</xsl:if>
				</xsl:if>
				<xsl:if test="not(@rspace)">
					<xsl:attribute name="rspace">0em</xsl:attribute>
					<xsl:if test="following-sibling::*[1][local-name() = 'mfenced']">
						<xsl:attribute name="rspace">-0.1em</xsl:attribute>
					</xsl:if>
				</xsl:if>
			</xsl:if>
			<xsl:apply-templates mode="mathml"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- Increase space before and after multiplication sign -->
	<xsl:template match="mathml:mo[normalize-space(text()) = '&#215;']" mode="mathml"> <!-- multiplication sign -->
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="mathml"/>
			<xsl:if test="not(@lspace)">
				<xsl:attribute name="lspace">0.5em</xsl:attribute>
			</xsl:if>
			<xsl:if test="not(@rspace)">
				<xsl:attribute name="rspace">0.5em</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates mode="mathml"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- Decrease a distance before and after of delta -->
	<xsl:template match="mathml:mo[normalize-space(text()) = 'Δ']" mode="mathml">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="mathml"/>
			<xsl:if test="not(@rspace)">
				<xsl:attribute name="rspace">0em</xsl:attribute>
			</xsl:if>
			<xsl:if test="not(@lspace) and (preceding-sibling::*[1][local-name() = 'mo'] or not(preceding-sibling::*))">
				<xsl:attribute name="lspace">0em</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates mode="mathml"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- decrease space before and after sign 'minus' -->
	<xsl:template match="mathml:mo[normalize-space(text()) = '&#8722;']" mode="mathml"> <!-- minus sign -->
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="mathml"/>
			<xsl:choose>
				<xsl:when test="not(preceding-sibling::*)"><!-- example: -0.234 -->
					<xsl:if test="not(@rspace)">
						<xsl:attribute name="rspace">0em</xsl:attribute>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="not(@lspace)">
						<xsl:attribute name="lspace">0.2em</xsl:attribute>
					</xsl:if>
					<xsl:if test="not(@rspace)">
						<xsl:attribute name="rspace">0.2em</xsl:attribute>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates mode="mathml"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="mathml:mi[string-length(normalize-space()) &gt; 1]" mode="mathml" priority="2">
		<xsl:if test="preceding-sibling::* and preceding-sibling::*[1][not(local-name() = 'mfenced' or local-name() = 'mo')]">
			<mathml:mspace width="0.3em"/>
		</xsl:if>
		<xsl:copy-of select="."/>
		<xsl:if test="following-sibling::* and following-sibling::*[1][not(local-name() = 'mfenced' or local-name() = 'mo')]">
			<mathml:mspace width="0.3em"/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mathml:mn/text()" mode="mathml">
		<xsl:value-of select="translate(., '&#8239;', ' ')"/>
	</xsl:template>


	<!-- =================== -->
	<!-- Table of Contents (ToC) processing -->
	<!-- =================== -->
	<xsl:template match="mn:clause[@type = 'toc']" priority="3">
		<fo:block>
			<xsl:copy-of select="@id"/>
			<xsl:apply-templates select="mn:fmt-title[1]"/>
			
			<!-- create virtual table to determine column's width -->
			<xsl:variable name="toc_table_simple">
				<mn:tbody>
					<xsl:apply-templates mode="toc_table_width" />
				</mn:tbody>
			</xsl:variable>
			<!-- <debug_toc_table_simple><xsl:copy-of select="$toc_table_simple"/></debug_toc_table_simple> -->
			<xsl:variable name="cols-count" select="count(xalan:nodeset($toc_table_simple)/*/mn:tr[1]/mn:td)"/>
			<xsl:variable name="colwidths">
				<xsl:call-template name="calculate-column-widths-proportional">
					<xsl:with-param name="cols-count" select="$cols-count"/>
					<xsl:with-param name="table" select="$toc_table_simple"/>
				</xsl:call-template>
			</xsl:variable>
			<!-- <debug_colwidths><xsl:copy-of select="$colwidths"/></debug_colwidths> -->
			
			<fo:table width="100%" table-layout="fixed" role="TOC">
				<fo:table-column column-width="100%" />
				<fo:table-header role="SKIP">
					<fo:table-row font-weight="bold" role="SKIP">
						<fo:table-cell xsl:use-attribute-sets="toc-title-page-style">
							<fo:block role="Caption">
								<xsl:variable name="page">
									<xsl:call-template name="getLocalizedString">
										<xsl:with-param name="key">Page.sg</xsl:with-param>
									</xsl:call-template>
								</xsl:variable>
								<xsl:value-of select="java:toLowerCase(java:java.lang.String.new($page))"/>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</fo:table-header>
				<fo:table-body role="SKIP">
					<fo:table-row role="SKIP">
						<fo:table-cell role="SKIP">
							<fo:block role="SKIP">
								<xsl:variable name="title_id" select="generate-id(mn:fmt-title[1])"/>
								<xsl:apply-templates select="*[not(generate-id() = $title_id)]">
									<xsl:with-param name="colwidths" select="$colwidths"/>
								</xsl:apply-templates>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</fo:table-body>
			</fo:table>
		</fo:block>
	</xsl:template>
	
	
	<!-- ignore section number before tab -->
	<xsl:template match="mn:clause[@type = 'toc']//mn:fmt-title/text()[1][not(preceding-sibling::mn:tab) and following-sibling::*[1][self::mn:tab]]"/>
	<xsl:template match="mn:clause[@type = 'toc']//mn:fmt-title/mn:tab" priority="2"/>

	<xsl:template match="mn:fmt-xref" mode="toc_table_width" priority="2">
		<!-- <xref target="cgpm9th1948r6">1.6.3<tab/>&#8220;9th CGPM, 1948:<tab/>decision to establish the SI&#8221;</xref> -->
		<!-- New format - one tab <xref target="cgpm9th1948r6">&#8220;9th CGPM, 1948:<tab/>decision to establish the SI&#8221;</xref> -->
		<xsl:for-each select="mn:tab">
			<xsl:variable name="pos" select="position()"/>
			<xsl:variable name="current_id" select="generate-id()"/>
			
			<xsl:if test="$pos = 1">
				<mn:td>
					<xsl:for-each select="preceding-sibling::node()">
						<xsl:choose>
							<xsl:when test="self::text()"><xsl:value-of select="translate(., ' ', '&#xa0;')"/></xsl:when>
							<xsl:otherwise><xsl:copy-of select="."/></xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</mn:td>
			</xsl:if>
			
			<mn:td>
				<xsl:for-each select="following-sibling::node()[not(self::mn:tab) and preceding-sibling::mn:tab[1][generate-id() = $current_id]]">
					<xsl:choose>
						<!-- <xsl:when test="$pos = 1 and self::text()"><xsl:value-of select="translate(., ' ', '&#xa0;')"/></xsl:when> -->
						<xsl:when test="self::text()"><xsl:value-of select="."/></xsl:when>
						<xsl:otherwise><xsl:copy-of select="."/></xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</mn:td>
		</xsl:for-each>
		<mn:td>333</mn:td> <!-- page number, just for fill -->
	</xsl:template>

	<!-- =================== -->
	<!-- End Table of Contents (ToC) processing -->
	<!-- =================== -->


	<xsl:template name="insertHeaderFooter">
		<xsl:param name="header-title"/>
		<xsl:param name="orientation"/>
		<xsl:param name="isDraft"/>
		<xsl:param name="lang"/>
		<fo:static-content flow-name="header-odd" role="artifact">
			<xsl:call-template name="insertDraftWatermark">
				<xsl:with-param name="isDraft" select="$isDraft"/>
				<xsl:with-param name="lang" select="$lang"/>
			</xsl:call-template>
			<fo:block-container font-family="Arial" font-size="8pt" padding-top="12.5mm">
				<fo:block text-align="right">
					<!-- <xsl:copy-of select="$header-title"/> -->
					<xsl:apply-templates select="xalan:nodeset($header-title)" mode="header_title_remove_link_embedded"/>
					<xsl:text>&#xA0;&#xA0;</xsl:text>
					<fo:inline font-size="13pt" baseline-shift="-15%">•</fo:inline>
					<xsl:text>&#xA0;&#xA0;</xsl:text>
					<fo:inline font-weight="bold"><fo:page-number/></fo:inline>			
				</fo:block>
			</fo:block-container>
			<fo:block-container font-size="1pt" border-top="0.5pt solid black" margin-left="81mm" width="86mm">
				<xsl:if test="$orientation = 'landscape'">
					<xsl:attribute name="margin-left">168mm</xsl:attribute>
				</xsl:if>
				<fo:block>&#xA0;</fo:block>
			</fo:block-container>
		</fo:static-content>		
		<fo:static-content flow-name="header-even" role="artifact">
			<xsl:call-template name="insertDraftWatermark">
				<xsl:with-param name="isDraft" select="$isDraft"/>
				<xsl:with-param name="lang" select="$lang"/>
			</xsl:call-template>
			<fo:block-container font-family="Arial" font-size="8pt" padding-top="12.5mm">
				<fo:block>
					<fo:inline font-weight="bold"><fo:page-number/></fo:inline>
					<xsl:text>&#xA0;&#xA0;</xsl:text>
					<fo:inline font-size="13pt" baseline-shift="-15%">•</fo:inline>
					<xsl:text>&#xA0;&#xA0;</xsl:text>		
					<!-- <xsl:copy-of select="$header-title"/> -->
					<xsl:apply-templates select="xalan:nodeset($header-title)" mode="header_title_remove_link_embedded"/>
				</fo:block>
				<fo:block-container font-size="1pt" border-top="0.5pt solid black" width="86.6mm">
					<fo:block>&#xA0;</fo:block>
				</fo:block-container>
			</fo:block-container>
		</fo:static-content>
		<fo:static-content flow-name="header-blank" role="artifact">
			<xsl:call-template name="insertDraftWatermark">
				<xsl:with-param name="isDraft" select="$isDraft"/>
				<xsl:with-param name="lang" select="$lang"/>
			</xsl:call-template>
			<fo:block></fo:block>
		</fo:static-content>
	</xsl:template>

	<xsl:template match="@*|node()" mode="header_title_remove_link_embedded">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="header_title_remove_link_embedded"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="fo:basic-link[contains(@external-destination,'embedded-file')]" mode="header_title_remove_link_embedded">
		<xsl:apply-templates mode="header_title_remove_link_embedded"/>
	</xsl:template>

	<xsl:template name="insertDraftWatermark">
		<xsl:param name="isDraft"/>
		<xsl:param name="lang"/>
		<xsl:if test="$isDraft = 'true' or normalize-space(//mn:metanorma/mn:bibdata/mn:version/mn:draft or
		contains(//mn:metanorma/mn:bibdata/mn:status/mn:stage, 'draft') or
		contains(//mn:metanorma/mn:bibdata/mn:status/mn:stage, 'projet')) = 'true'">
			<!-- DRAFT -->
			<xsl:variable name="draft_label">
				<xsl:choose>
					<xsl:when test="normalize-space($lang) != ''">
						<xsl:call-template name="getLocalizedString">
							<xsl:with-param name="key">draft_label</xsl:with-param>
							<xsl:with-param name="lang" select="$lang"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="getLocalizedString">
							<xsl:with-param name="key">draft_label</xsl:with-param>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<fo:block-container absolute-position="fixed" left="0mm" top="30mm">
				<fo:block line-height="0">
					<fo:instream-foreign-object fox:alt-text="DRAFT">
							<svg:svg width="200mm" height="250mm" xmlns:svg="http://www.w3.org/2000/svg">
								<svg:g transform="rotate(-45) scale(0.6, 1)">
									<xsl:variable name="font-size">
										<xsl:choose>
											<xsl:when test="string-length($draft_label) &gt; 5">150</xsl:when>
											<xsl:otherwise>260</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
										<svg:text x="-175mm" y="205mm"  style="font-family:Arial;font-size:{$font-size}pt;font-weight:normal;fill:rgb(223, 223, 223);">
											<xsl:if test="string-length($draft_label) &gt; 5">
												<xsl:attribute name="x">-175mm</xsl:attribute>
												<xsl:attribute name="y">180mm</xsl:attribute>
											</xsl:if>
											<xsl:value-of select="java:toUpperCase(java:java.lang.String.new($draft_label))"/>
										</svg:text>
								</svg:g>
							</svg:svg>
					</fo:instream-foreign-object>
				</fo:block>
			</fo:block-container>
		</xsl:if>
	</xsl:template>

	<xsl:template name="insertHeaderDraftWatermark">
		<xsl:variable name="isDraft" select="normalize-space(//mn:metanorma/mn:bibdata/mn:version/mn:draft or
		contains(//mn:metanorma/mn:bibdata/mn:status/mn:stage, 'draft') or
		contains(//mn:metanorma/mn:bibdata/mn:status/mn:stage, 'projet'))"/>
		<xsl:variable name="curr_lang" select="$doc_split_by_language"/>
		<xsl:if test="$isDraft = 'true'">
			<fo:static-content flow-name="header-blank" role="artifact">
				<xsl:call-template name="insertDraftWatermark">
					<xsl:with-param name="isDraft" select="$isDraft"/>
					<xsl:with-param name="lang" select="$curr_lang"/>
				</xsl:call-template>
			</fo:static-content>
			<fo:static-content flow-name="header" role="artifact">
				<xsl:call-template name="insertDraftWatermark">
					<xsl:with-param name="isDraft" select="$isDraft"/>
					<xsl:with-param name="lang" select="$curr_lang"/>
				</xsl:call-template>
			</fo:static-content>
			<fo:static-content flow-name="header-odd" role="artifact">
				<xsl:call-template name="insertDraftWatermark">
					<xsl:with-param name="isDraft" select="$isDraft"/>
					<xsl:with-param name="lang" select="$curr_lang"/>
				</xsl:call-template>
			</fo:static-content>
			<fo:static-content flow-name="header-even" role="artifact">
				<xsl:call-template name="insertDraftWatermark">
					<xsl:with-param name="isDraft" select="$isDraft"/>
					<xsl:with-param name="lang" select="$curr_lang"/>
				</xsl:call-template>
			</fo:static-content>
		</xsl:if>
	</xsl:template>


	<xsl:template name="printRevisionDate">
		<xsl:param name="date"/>
		<xsl:param name="lang"/>
		<xsl:param name="variant"/>
		<!-- <revision-date>2019-05-20</revision-date> -->
		<xsl:variable name="year" select="substring($date, 1, 4)"/>
		<xsl:variable name="month" select="substring($date, 6, 2)"/>
		<xsl:variable name="day" select="substring($date, 9, 2)"/>
		<xsl:variable name="monthStr">
			<xsl:call-template name="getMonthByNum">
				<xsl:with-param name="num" select="$month"/>
				<xsl:with-param name="lang" select="$lang"/>
				<xsl:with-param name="lowercase" select="$lang = 'fr'"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$lang = 'fr' or $variant = 'true'">
				<xsl:value-of select="concat($day, ' ', $monthStr, ' ', $year)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$monthStr"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="$day"/>
				<xsl:if test="$day != '' and $year != ''"><xsl:text>, </xsl:text></xsl:if>
				<xsl:value-of select="$year"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<xsl:template name="insertFootnoteSeparator">
		<fo:static-content flow-name="xsl-footnote-separator">
			<fo:block>
				<fo:leader leader-pattern="rule" leader-length="30%"/>
			</fo:block>
		</fo:static-content>
	</xsl:template>
 
	 
	<!-- =================== -->
	<!-- Index processing -->
	<!-- =================== -->
	
	<xsl:template match="mn:indexsect" />
	<xsl:template match="mn:indexsect" mode="index">
		<xsl:param name="isDraft"/>
		<xsl:param name="lang"/>
	
		<fo:page-sequence master-reference="index" force-page-count="no-force">
			<xsl:variable name="header-title">
				<xsl:choose>
					<xsl:when test="./mn:title[1]/mn:tab">
						<xsl:apply-templates select="./mn:title[1]/mn:tab[1]/following-sibling::node()" mode="header"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="./mn:title[1]" mode="header"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:call-template name="insertHeaderFooter">
				<xsl:with-param name="header-title" select="$header-title"/>
				<xsl:with-param name="isDraft" select="$isDraft"/>
				<xsl:with-param name="lang" select="$lang"/>
			</xsl:call-template>
			
			<fo:flow flow-name="xsl-region-body">
				<fo:block id="{@id}" span="all">
					<xsl:apply-templates select="mn:title"/>
				</fo:block>
				<fo:block role="Index">
					<xsl:apply-templates select="*[not(self::mn:title)]"/>
					
					<!-- TEST <xsl:variable name="alphabet" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
					<xsl:for-each select="(document('')//node())[position() &lt; 26]">
						<xsl:variable name="letter" select="substring($alphabet, position(), 1)"/>
						<xsl:if test="position() &lt;= 3">
							<fo:block font-size="10pt" font-weight="bold" margin-bottom="3pt" keep-with-next="always"><xsl:value-of select="$letter"/>, DEBUG</fo:block>
							
							<fo:block>accélération due à la pesanteur (gn), 33</fo:block>
							<fo:block>activité d’un radionucléide, 26, 27</fo:block>
							<fo:block>ampère (A), 13, 16, 18, 20, 28, 44, 49, 51, 52, 54, 55, 71, 81, 83-86, 89, 91-94, 97, 99, 100, 101, 103-104</fo:block>
							<fo:block>angle, 25, 26, 33, 37 38, 40, 48, 55, 65</fo:block>
							<fo:block>atmosphère normale, 52</fo:block>
							<fo:block>atome gramme, 104</fo:block>
							<fo:block>atome de césium, niveaux hyperfins, 15, 17, 18, 56, 58, 83, 85, 92, 94, 97, 98, 102</fo:block>
							<xsl:if test="position() != last()"><fo:block>&#xA0;</fo:block></xsl:if>
						</xsl:if>
					</xsl:for-each> -->
				</fo:block>
			</fo:flow>
		</fo:page-sequence>
	</xsl:template>
	
	
	<xsl:template match="mn:fmt-stem/text()">
		<xsl:value-of select="normalize-space()"/>
	</xsl:template>
	
	<!-- =================== -->
	<!-- End of Index processing -->
	<!-- =================== -->
	
	<xsl:variable name="Image-Logo-BIPM">
		<xsl:text>iVBORw0KGgoAAAANSUhEUgAAAaIAAADRCAYAAACOyra0AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA2dpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNi1jMDE0IDc5LjE1Njc5NywgMjAxNC8wOC8yMC0wOTo1MzowMiAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDpGOTdGMTE3NDA3MjA2ODExODIyQUJFNEQ3OTI1MkI2OSIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDpCMTdGMTkxM0YzNEIxMUVBOEZCREQ0ODFDQjY0QzlCNyIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDpCMTdGMTkxMkYzNEIxMUVBOEZCREQ0ODFDQjY0QzlCNyIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBJbkRlc2lnbiBDUzYgKE1hY2ludG9zaCkiPiA8eG1wTU06RGVyaXZlZEZyb20gc3RSZWY6aW5zdGFuY2VJRD0idXVpZDoyNGQ2ZDM1ZS1kNDc4LTcxNGItYjYwZi1iMDMyYWFmYzM3OTYiIHN0UmVmOmRvY3VtZW50SUQ9InhtcC5pZDoxNjcwQkZBMDExMjA2ODExODIyQUJFNEQ3OTI1MkI2OSIvPiA8L3JkZjpEZXNjcmlw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</xsl:text>
	</xsl:variable>
	
	<xsl:variable name="Image-Logo-SI">
		<xsl:variable name="si-aspect" select="java:toLowerCase(java:java.lang.String.new(normalize-space(//mn:metanorma/mn:bibdata//mn:si-aspect)))"/>		
		<xsl:choose>
			<xsl:when test="$si-aspect = 'a_e_deltanu'">
				<svg
					 xmlns:dc="http://purl.org/dc/elements/1.1/"
					 xmlns:cc="http://creativecommons.org/ns#"
					 xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
					 xmlns:svg="http://www.w3.org/2000/svg"
					 xmlns="http://www.w3.org/2000/svg"
					 id="svg85"
					 version="1.2"
					 viewBox="0 0 595.28 595.28"
					 height="595.28pt"
					 width="595.28pt">
					<metadata
						 id="metadata91">
						<rdf:RDF>
							<cc:Work
								 rdf:about="">
								<dc:format>image/svg+xml</dc:format>
								<dc:type
									 rdf:resource="http://purl.org/dc/dcmitype/StillImage" />
							</cc:Work>
						</rdf:RDF>
					</metadata>
					<defs
						 id="defs89" />
					<g
						 id="surface1">
						<path
							 id="path2"
							 d="M 220.046875 146.335938 L 170.816406 44.109375 C 97.332031 80.933594 42.089844 148.753906 22.21875 230.429688 L 132.796875 255.671875 C 144.914062 207.964844 177.210938 168.34375 220.046875 146.335938 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(74.113464%,73.643494%,73.75946%);fill-opacity:1;" />
						<path
							 id="path4"
							 d="M 467.71875 297.667969 C 467.71875 336.242188 454.859375 371.804688 433.214844 400.335938 L 521.890625 471.050781 C 559.003906 423.121094 581.105469 362.976562 581.105469 297.667969 C 581.105469 277.453125 578.972656 257.738281 574.949219 238.722656 L 464.363281 263.960938 C 466.554688 274.859375 467.71875 286.125 467.71875 297.667969 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(74.113464%,73.643494%,73.75946%);fill-opacity:1;" />
						<path
							 id="path6"
							 d="M 297.640625 14.203125 C 255.074219 14.203125 214.707031 23.601562 178.476562 40.414062 L 227.707031 142.640625 C 249.042969 133 272.703125 127.589844 297.640625 127.589844 C 322.574219 127.589844 346.234375 133 367.570312 142.640625 L 416.800781 40.410156 C 380.570312 23.601562 340.207031 14.203125 297.640625 14.203125 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(74.113464%,73.643494%,73.75946%);fill-opacity:1;" />
						<path
							 id="path8"
							 d="M 462.480469 255.671875 L 573.058594 230.429688 C 553.1875 148.753906 497.945312 80.933594 424.460938 44.105469 L 375.230469 146.335938 C 418.070312 168.34375 450.363281 207.964844 462.480469 255.671875 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(74.113464%,73.643494%,73.75946%);fill-opacity:1;" />
						<path
							 id="path10"
							 d="M 127.5625 297.667969 C 127.5625 286.125 128.722656 274.859375 130.914062 263.964844 L 20.328125 238.722656 C 16.308594 257.738281 14.175781 277.453125 14.175781 297.667969 C 14.175781 362.976562 36.277344 423.117188 73.390625 471.050781 L 162.0625 400.335938 C 140.421875 371.800781 127.5625 336.242188 127.5625 297.667969 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(74.113464%,73.643494%,73.75946%);fill-opacity:1;" />
						<path
							 id="path12"
							 d="M 293.386719 581.078125 L 293.386719 467.636719 C 242.8125 466.390625 197.722656 443.105469 167.371094 406.976562 L 78.683594 477.703125 C 129.835938 539.839844 206.925781 579.804688 293.386719 581.078125 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(74.113464%,73.643494%,73.75946%);fill-opacity:1;" />
						<path
							 id="path14"
							 d="M 301.890625 581.078125 C 388.351562 579.804688 465.441406 539.839844 516.59375 477.703125 L 427.90625 406.976562 C 397.558594 443.105469 352.464844 466.394531 301.890625 467.636719 L 301.890625 581.078125 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(34.230042%,69.973755%,20.703125%);fill-opacity:1;" />
						<path
							 id="path16"
							 d="M 367.570312 142.640625 C 346.234375 133 322.574219 127.589844 297.640625 127.589844 C 272.703125 127.589844 249.042969 133 227.707031 142.640625 L 297.636719 287.855469 L 367.570312 142.640625 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(87.068176%,86.833191%,86.891174%);fill-opacity:1;" />
						<path
							 id="path18"
							 d="M 130.914062 263.964844 C 128.722656 274.859375 127.5625 286.125 127.5625 297.667969 C 127.5625 336.242188 140.421875 371.800781 162.0625 400.335938 L 288.082031 299.835938 L 130.914062 263.964844 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(87.068176%,86.833191%,86.891174%);fill-opacity:1;" />
						<path
							 id="path20"
							 d="M 301.890625 467.636719 C 352.464844 466.394531 397.558594 443.105469 427.90625 406.976562 L 301.890625 306.484375 L 301.890625 467.636719 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(66.633606%,83.750916%,53.329468%);fill-opacity:1;" />
						<path
							 id="path22"
							 d="M 464.363281 263.960938 L 307.191406 299.835938 L 433.214844 400.335938 C 454.859375 371.804688 467.71875 336.242188 467.71875 297.667969 C 467.71875 286.125 466.554688 274.859375 464.363281 263.960938 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(98.464966%,79.545593%,46.995544%);fill-opacity:1;" />
						<path
							 id="path24"
							 d="M 220.046875 146.335938 C 177.210938 168.34375 144.914062 207.964844 132.796875 255.671875 L 289.976562 291.546875 L 220.046875 146.335938 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(87.068176%,86.833191%,86.891174%);fill-opacity:1;" />
						<path
							 id="path26"
							 d="M 462.480469 255.671875 C 450.363281 207.964844 418.070312 168.34375 375.230469 146.335938 L 305.300781 291.546875 L 462.480469 255.671875 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(87.068176%,86.833191%,86.891174%);fill-opacity:1;" />
						<path
							 id="path28"
							 d="M 167.371094 406.976562 C 197.722656 443.105469 242.8125 466.390625 293.386719 467.636719 L 293.386719 306.484375 L 167.371094 406.976562 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(87.068176%,86.833191%,86.891174%);fill-opacity:1;" />
						<path
							 id="path30"
							 d="M 78.683594 477.703125 C 76.882812 475.515625 75.125 473.292969 73.390625 471.050781 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(92.549133%,0%,54.899597%);fill-opacity:1;" />
						<path
							 id="path32"
							 d="M 396.851562 297.667969 C 396.851562 352.460938 352.433594 396.878906 297.640625 396.878906 C 242.847656 396.878906 198.425781 352.460938 198.425781 297.667969 C 198.425781 242.871094 242.847656 198.453125 297.640625 198.453125 C 352.433594 198.453125 396.851562 242.871094 396.851562 297.667969 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,100%,100%);fill-opacity:1;" />
						<path
							 id="path34"
							 d="M 242.8125 336.71875 L 250.292969 328.042969 C 257.320312 335.375 267.195312 340.308594 277.367188 340.308594 C 290.230469 340.308594 297.859375 333.878906 297.859375 324.304688 C 297.859375 314.28125 290.828125 311.140625 281.554688 306.953125 L 267.492188 300.820312 C 258.21875 296.929688 247.597656 289.902344 247.597656 275.539062 C 247.597656 260.582031 260.613281 249.511719 278.414062 249.511719 C 290.082031 249.511719 300.402344 254.449219 307.429688 261.628906 L 300.699219 269.707031 C 294.71875 264.023438 287.539062 260.433594 278.414062 260.433594 C 267.492188 260.433594 260.164062 265.96875 260.164062 274.792969 C 260.164062 284.21875 268.691406 287.804688 276.46875 291.097656 L 290.378906 297.082031 C 301.746094 302.015625 310.574219 308.746094 310.574219 323.257812 C 310.574219 338.8125 297.859375 351.230469 277.214844 351.230469 C 263.453125 351.230469 251.339844 345.546875 242.8125 336.71875 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(22.322083%,20.909119%,21.260071%);fill-opacity:1;" />
						<path
							 id="path36"
							 d="M 329.871094 251.308594 L 342.285156 251.308594 L 342.285156 349.433594 L 329.871094 349.433594 L 329.871094 251.308594 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(22.322083%,20.909119%,21.260071%);fill-opacity:1;" />
						<path
							 id="path38"
							 d="M 105.394531 177.816406 C 97.296875 172.222656 96.578125 163.339844 101.046875 156.875 C 103.195312 153.765625 105.914062 152.363281 108.671875 151.640625 L 110.464844 156.964844 C 108.441406 157.464844 106.949219 158.253906 105.890625 159.785156 C 103.199219 163.683594 104.53125 168.617188 109.417969 171.992188 C 114.253906 175.335938 119.304688 174.886719 121.929688 171.085938 C 123.226562 169.207031 123.480469 166.832031 123.300781 164.664062 L 128.65625 164.9375 C 129.0625 168.574219 128.070312 172.117188 126.160156 174.882812 C 121.589844 181.496094 113.4375 183.375 105.394531 177.816406 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,100%,100%);fill-opacity:1;" />
						<path
							 id="path40"
							 d="M 139.015625 145.140625 L 128.839844 135.90625 C 126.136719 136.210938 124.316406 137.230469 122.984375 138.699219 C 120.445312 141.496094 121.011719 146.140625 125.589844 150.296875 C 130.296875 154.566406 134.441406 155.089844 137.304688 151.933594 C 138.835938 150.246094 139.371094 148.136719 139.015625 145.140625 Z M 120.835938 155.621094 C 113.726562 149.171875 113.441406 140.734375 117.757812 135.980469 C 120.015625 133.492188 122.359375 132.78125 125.355469 132.425781 L 121.683594 129.417969 L 113.777344 122.242188 L 118.410156 117.132812 L 149.78125 145.59375 L 145.953125 149.8125 L 143.273438 148.03125 L 143.113281 148.210938 C 143.261719 151.261719 142.535156 154.652344 140.398438 157.007812 C 135.4375 162.472656 128.035156 162.152344 120.835938 155.621094 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,100%,100%);fill-opacity:1;" />
						<path
							 id="path42"
							 d="M 269.574219 44.261719 L 276.339844 43.828125 L 278.027344 70.234375 L 278.207031 70.222656 L 288.238281 55.992188 L 295.78125 55.511719 L 286.488281 68.128906 L 298.679688 84.84375 L 291.195312 85.324219 L 282.835938 73.050781 L 278.5625 78.613281 L 279.039062 86.101562 L 272.273438 86.53125 L 269.574219 44.261719 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,100%,100%);fill-opacity:1;" />
						<path
							 id="path44"
							 d="M 318.769531 66.742188 C 319.042969 63.09375 316.992188 60.773438 314.117188 60.558594 C 311.246094 60.34375 308.816406 62.269531 308.539062 65.976562 C 308.257812 69.746094 310.371094 72.070312 313.242188 72.285156 C 316.054688 72.496094 318.488281 70.515625 318.769531 66.742188 Z M 320.617188 90.347656 C 320.785156 88.074219 318.980469 87.277344 315.628906 87.027344 L 311.621094 86.726562 C 310.003906 86.605469 308.757812 86.390625 307.644531 86.007812 C 305.996094 87.089844 305.179688 88.351562 305.078125 89.726562 C 304.882812 92.359375 307.636719 94.128906 312.304688 94.480469 C 317.03125 94.832031 320.425781 92.859375 320.617188 90.347656 Z M 299.257812 90.3125 C 299.441406 87.859375 301.097656 85.820312 303.917969 84.34375 L 303.933594 84.105469 C 302.511719 83.035156 301.488281 81.394531 301.667969 79.003906 C 301.839844 76.730469 303.542969 74.871094 305.308594 73.796875 L 305.324219 73.558594 C 303.460938 71.917969 301.816406 68.964844 302.078125 65.492188 C 302.582031 58.734375 308.308594 55.371094 314.472656 55.832031 C 316.089844 55.953125 317.5625 56.363281 318.726562 56.871094 L 329.257812 57.660156 L 328.878906 62.746094 L 323.492188 62.34375 C 324.363281 63.550781 324.949219 65.398438 324.796875 67.433594 C 324.308594 73.957031 319.144531 77.058594 312.917969 76.59375 C 311.664062 76.5 310.246094 76.152344 308.96875 75.515625 C 308.011719 76.226562 307.421875 76.90625 307.324219 78.222656 C 307.199219 79.898438 308.316406 81.003906 311.90625 81.273438 L 317.113281 81.660156 C 324.175781 82.1875 327.722656 84.621094 327.34375 89.707031 C 326.910156 95.511719 320.464844 99.601562 310.890625 98.886719 C 303.890625 98.363281 298.875 95.460938 299.257812 90.3125 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,100%,100%);fill-opacity:1;" />
						<path
							 id="path46"
							 d="M 473.050781 130.691406 L 476.570312 135.171875 L 473.707031 138.035156 L 473.855469 138.222656 C 477.453125 138.523438 480.882812 139.492188 483.144531 142.367188 C 485.816406 145.761719 485.777344 148.921875 484.039062 152.046875 C 488.140625 152.40625 491.746094 153.308594 494.046875 156.234375 C 497.902344 161.136719 496.335938 166.035156 490.488281 170.632812 L 475.960938 182.054688 L 471.660156 176.582031 L 485.476562 165.71875 C 489.296875 162.714844 489.824219 160.46875 487.933594 158.0625 C 486.78125 156.601562 484.578125 155.742188 481.234375 155.46875 L 465.058594 168.1875 L 460.796875 162.765625 L 474.613281 151.898438 C 478.433594 148.894531 478.957031 146.652344 477.027344 144.199219 C 475.917969 142.785156 473.675781 141.875 470.332031 141.601562 L 454.15625 154.324219 L 449.894531 148.898438 L 473.050781 130.691406 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,100%,100%);fill-opacity:1;" />
						<path
							 id="path48"
							 d="M 508.691406 333.113281 L 512.269531 337.28125 C 509.683594 339.386719 507.878906 341.550781 507.195312 344.472656 C 506.46875 347.566406 507.585938 349.367188 509.570312 349.835938 C 511.964844 350.398438 513.742188 347.550781 515.625 344.785156 C 517.917969 341.320312 521.078125 337.5625 525.867188 338.6875 C 530.890625 339.867188 533.507812 344.734375 532 351.15625 C 531.066406 355.128906 528.675781 357.957031 526.316406 359.867188 L 522.957031 355.8125 C 524.882812 354.171875 526.355469 352.359375 526.890625 350.082031 C 527.5625 347.21875 526.535156 345.558594 524.722656 345.136719 C 522.445312 344.601562 520.898438 347.257812 519.0625 350.089844 C 516.683594 353.660156 513.800781 357.546875 508.425781 356.285156 C 503.519531 355.132812 500.46875 350.285156 502.167969 343.042969 C 503.085938 339.132812 505.753906 335.382812 508.691406 333.113281 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,100%,100%);fill-opacity:1;" />
						<path
							 id="path50"
							 d="M 77.484375 394.226562 L 75.640625 388.835938 L 79.285156 387.078125 L 79.207031 386.851562 C 75.914062 385.378906 72.996094 383.335938 71.808594 379.871094 C 70.410156 375.785156 71.484375 372.816406 74.160156 370.441406 C 70.410156 368.746094 67.300781 366.703125 66.09375 363.1875 C 64.074219 357.28125 67.171875 353.179688 74.207031 350.769531 L 91.691406 344.78125 L 93.945312 351.367188 L 77.316406 357.0625 C 72.71875 358.636719 71.480469 360.578125 72.472656 363.476562 C 73.074219 365.234375 74.871094 366.773438 77.9375 368.136719 L 97.40625 361.46875 L 99.640625 367.996094 L 83.007812 373.691406 C 78.414062 375.265625 77.175781 377.210938 78.1875 380.160156 C 78.769531 381.863281 80.585938 383.464844 83.652344 384.820312 L 103.117188 378.15625 L 105.355469 384.683594 L 77.484375 394.226562 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,100%,100%);fill-opacity:1;" />
						<path
							 id="path52"
							 d="M 73.742188 321.398438 C 67.863281 322.234375 64.375 325.398438 64.984375 329.679688 C 65.59375 333.953125 69.820312 335.957031 75.699219 335.117188 C 81.523438 334.289062 85.019531 331.183594 84.410156 326.90625 C 83.800781 322.628906 79.566406 320.566406 73.742188 321.398438 Z M 76.699219 342.128906 C 66.957031 343.519531 60.433594 337.722656 59.398438 330.472656 C 58.355469 323.167969 63 315.777344 72.742188 314.386719 C 82.425781 313.003906 88.953125 318.804688 89.992188 326.109375 C 91.027344 333.355469 86.382812 340.746094 76.699219 342.128906 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,100%,100%);fill-opacity:1;" />
						<path
							 id="path54"
							 d="M 79.8125 306.777344 L 45.03125 307.851562 L 44.816406 300.953125 L 79.960938 299.871094 C 81.640625 299.820312 82.214844 299.023438 82.195312 298.300781 C 82.183594 298.003906 82.175781 297.761719 82.039062 297.226562 L 87.171875 296.167969 C 87.558594 296.996094 87.832031 298.1875 87.882812 299.808594 C 88.035156 304.726562 84.910156 306.621094 79.8125 306.777344 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,100%,100%);fill-opacity:1;" />
						<path
							 id="path56"
							 d="M 198.953125 476.394531 L 205.207031 479.449219 L 197.382812 495.460938 L 197.546875 495.539062 L 217.929688 485.664062 L 224.882812 489.0625 L 207.332031 497.515625 L 209.492188 525.214844 L 202.59375 521.84375 L 201.160156 500.574219 L 193.011719 504.410156 L 187.980469 514.707031 L 181.726562 511.652344 L 198.953125 476.394531 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,100%,100%);fill-opacity:1;" />
						<path
							 id="path58"
							 d="M 391.300781 503.335938 L 400.359375 499.046875 L 397.058594 495.300781 C 394.148438 492.097656 391.191406 488.519531 388.3125 485.101562 L 388.097656 485.203125 C 388.992188 489.625 389.863281 494.125 390.496094 498.40625 Z M 382.316406 481.96875 L 389.691406 478.472656 L 418.03125 508.472656 L 411.414062 511.605469 L 404.105469 503.316406 L 392.175781 508.964844 L 393.953125 519.871094 L 387.554688 522.902344 L 382.316406 481.96875 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,100%,100%);fill-opacity:1;" />
						<path
							 id="path60"
							 d="M 169.769531 218.679688 L 172.167969 215.085938 L 180.710938 223.621094 L 180.796875 223.488281 L 177.296875 207.398438 L 179.9375 203.4375 L 183.242188 217.230469 L 199.617188 221.085938 L 197.128906 224.8125 L 183.726562 221.402344 L 185.101562 227.992188 L 191.046875 233.933594 L 188.648438 237.527344 L 169.769531 218.679688 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(22.322083%,20.909119%,21.260071%);fill-opacity:1;" />
						<path
							 id="path62"
							 d="M 207.03125 224.421875 C 204.148438 221.90625 204.265625 218.441406 206.273438 216.140625 C 207.242188 215.035156 208.355469 214.613281 209.453125 214.457031 L 209.910156 216.59375 C 209.105469 216.695312 208.492188 216.933594 208.019531 217.480469 C 206.804688 218.867188 207.101562 220.828125 208.839844 222.351562 C 210.5625 223.855469 212.53125 223.902344 213.714844 222.550781 C 214.296875 221.882812 214.5 220.976562 214.527344 220.132812 L 216.585938 220.472656 C 216.582031 221.894531 216.042969 223.222656 215.183594 224.203125 C 213.125 226.558594 209.894531 226.925781 207.03125 224.421875 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(22.322083%,20.909119%,21.260071%);fill-opacity:1;" />
						<path
							 id="path64"
							 d="M 220.28125 214 L 216.582031 210.148438 C 215.527344 210.195312 214.792969 210.542969 214.238281 211.074219 C 213.179688 212.09375 213.273438 213.910156 214.9375 215.640625 C 216.652344 217.425781 218.246094 217.738281 219.4375 216.589844 C 220.078125 215.976562 220.339844 215.171875 220.28125 214 Z M 212.953125 217.582031 C 210.367188 214.890625 210.484375 211.609375 212.28125 209.882812 C 213.222656 208.976562 214.152344 208.765625 215.324219 208.707031 L 213.980469 207.441406 L 211.105469 204.449219 L 213.039062 202.589844 L 224.445312 214.460938 L 222.847656 215.996094 L 221.859375 215.234375 L 221.789062 215.300781 C 221.765625 216.488281 221.394531 217.78125 220.503906 218.640625 C 218.433594 220.628906 215.570312 220.304688 212.953125 217.582031 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(22.322083%,20.909119%,21.260071%);fill-opacity:1;" />
						<path
							 id="path66"
							 d="M 294.023438 145.214844 L 298.300781 145.234375 L 296.539062 153.546875 L 295.765625 156.382812 L 295.925781 156.382812 C 297.933594 154.671875 300.058594 153.363281 302.417969 153.375 C 305.699219 153.390625 307.050781 155.199219 307.03125 158.355469 C 307.027344 159.277344 306.945312 160.078125 306.699219 161.113281 L 304.15625 173.5 L 299.875 173.476562 L 302.335938 161.652344 C 302.5 160.734375 302.664062 160.175781 302.667969 159.574219 C 302.675781 157.894531 301.878906 157.050781 300.199219 157.042969 C 298.839844 157.035156 297.316406 157.949219 295.226562 160.054688 L 292.519531 173.441406 L 288.199219 173.417969 L 294.023438 145.214844 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(22.322083%,20.909119%,21.260071%);fill-opacity:1;" />
						<path
							 id="path68"
							 d="M 396.144531 209.976562 C 401.679688 205.625 409.238281 206.242188 413.019531 211.054688 C 414.503906 212.941406 414.664062 214.953125 414.324219 216.59375 L 410.796875 216.3125 C 411.046875 214.949219 410.929688 214.023438 410.113281 212.984375 C 407.9375 210.21875 402.828125 210.320312 398.992188 213.335938 C 396.664062 215.164062 396.128906 217.265625 397.761719 219.339844 C 398.703125 220.535156 400.007812 221.03125 401.257812 221.324219 L 400.253906 224.449219 C 398.492188 223.957031 396.3125 223.125 394.484375 220.800781 C 391.8125 217.402344 392.15625 213.117188 396.144531 209.976562 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(22.322083%,20.909119%,21.260071%);fill-opacity:1;" />
						<path
							 id="path70"
							 d="M 422.964844 323.359375 L 433.734375 321.671875 L 442.15625 320.492188 L 442.183594 320.332031 L 434.566406 316.578125 L 424.882812 311.59375 Z M 424.582031 306.476562 L 446.304688 318.410156 L 445.425781 323.820312 L 421.039062 328.195312 L 418.277344 327.742188 L 421.816406 306.027344 L 424.582031 306.476562 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(22.322083%,20.909119%,21.260071%);fill-opacity:1;" />
						<path
							 id="path72"
							 d="M 414.972656 335.429688 L 428.492188 335.417969 C 429.382812 335.417969 430.292969 335.324219 431.222656 335.140625 C 432.148438 334.957031 432.742188 334.476562 433.003906 333.699219 C 433.128906 333.328125 433.183594 332.894531 433.171875 332.398438 L 433.910156 332.355469 L 434.246094 337.601562 L 433.972656 338.414062 L 418.101562 338.5 L 423.253906 343.589844 C 424.175781 344.519531 424.953125 345.089844 425.582031 345.300781 C 426.089844 345.472656 426.832031 345.601562 427.816406 345.699219 C 428.539062 345.761719 429.066406 345.851562 429.398438 345.964844 C 430.621094 346.375 431.007812 347.242188 430.566406 348.558594 C 430.171875 349.734375 429.417969 350.132812 428.308594 349.761719 C 427.210938 349.390625 425.386719 347.871094 422.835938 345.199219 L 414.597656 336.539062 L 414.972656 335.429688 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(22.322083%,20.909119%,21.260071%);fill-opacity:1;" />
						<path
							 id="path74"
							 transform="matrix(0.1,0,0,-0.1,0,595.28)"
							 d="M 4149.726562 2598.503125 L 4284.921875 2598.620313 C 4293.828125 2598.620313 4302.929688 2599.557813 4312.226562 2601.39375 C 4321.484375 2603.229688 4327.421875 2608.034375 4330.039062 2615.807813 C 4331.289062 2619.51875 4331.835938 2623.854688 4331.71875 2628.815625 L 4339.101562 2629.245313 L 4342.460938 2576.784375 L 4339.726562 2568.659375 L 4181.015625 2567.8 L 4232.539062 2516.901563 C 4241.757812 2507.604688 4249.53125 2501.901563 4255.820312 2499.792188 C 4260.898438 2498.073438 4268.320312 2496.784375 4278.164062 2495.807813 C 4285.390625 2495.182813 4290.664062 2494.284375 4293.984375 2493.151563 C 4306.210938 2489.05 4310.078125 2480.378125 4305.664062 2467.214063 C 4301.71875 2455.45625 4294.179688 2451.471875 4283.085938 2455.182813 C 4272.109375 2458.89375 4253.867188 2474.089063 4228.359375 2500.807813 L 4145.976562 2587.409375 Z M 4149.726562 2598.503125 "
							 style="fill:none;stroke-width:5;stroke-linecap:butt;stroke-linejoin:miter;stroke:rgb(22.322083%,20.909119%,21.260071%);stroke-opacity:1;stroke-miterlimit:10;" />
						<path
							 id="path76"
							 d="M 154.769531 343.476562 L 153.640625 339.386719 L 166.898438 330.429688 L 171.929688 327.46875 L 171.886719 327.3125 C 169.21875 327.714844 165.878906 328.386719 162.980469 328.5625 L 150.902344 329.441406 L 149.800781 325.429688 L 176.40625 323.539062 L 177.523438 327.585938 L 164.296875 336.496094 L 159.183594 339.480469 L 159.226562 339.636719 C 162.011719 339.199219 165.179688 338.660156 168.078125 338.484375 L 180.273438 337.574219 L 181.367188 341.546875 L 154.769531 343.476562 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(22.322083%,20.909119%,21.260071%);fill-opacity:1;" />
						<path
							 id="path78"
							 d="M 182.082031 313.910156 L 181.605469 310.042969 L 179.820312 310.804688 C 178.285156 311.488281 176.601562 312.140625 174.988281 312.785156 L 175.003906 312.878906 C 176.742188 313.085938 178.507812 313.316406 180.164062 313.605469 Z M 173.101562 314.617188 L 172.710938 311.472656 L 187.238281 304.671875 L 187.589844 307.496094 L 183.636719 309.179688 L 184.265625 314.273438 L 188.507812 314.949219 L 188.84375 317.679688 L 173.101562 314.617188 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(22.322083%,20.909119%,21.260071%);fill-opacity:1;" />
						<path
							 id="path80"
							 d="M 243.261719 403.507812 L 247.109375 405.386719 L 236.113281 419.78125 L 236.257812 419.851562 L 248.078125 415.433594 L 252.386719 417.539062 L 241.585938 421.609375 L 240.855469 433.761719 L 236.972656 431.863281 L 237.785156 422.558594 L 232.628906 424.355469 L 229.640625 428.28125 L 225.761719 426.386719 L 243.261719 403.507812 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(22.322083%,20.909119%,21.260071%);fill-opacity:1;" />
						<path
							 id="path82"
							 d="M 359.894531 418.46875 C 359.78125 417.945312 359.613281 417.40625 359.339844 416.828125 C 358.519531 415.09375 357.058594 413.882812 354.890625 414.90625 C 352.757812 415.917969 351.480469 418.734375 352.046875 422.183594 Z M 353.941406 411.683594 C 358.0625 409.734375 360.933594 411.871094 362.675781 415.558594 C 363.414062 417.113281 363.675781 418.980469 363.695312 419.679688 L 352.886719 424.792969 C 354.269531 428.742188 357.117188 429.339844 359.792969 428.074219 C 361.058594 427.476562 362.109375 426.140625 362.742188 424.953125 L 365.367188 426.765625 C 364.402344 428.460938 362.714844 430.320312 360.183594 431.519531 C 355.953125 433.519531 351.761719 432.140625 349.503906 427.367188 C 346.371094 420.753906 349.277344 413.890625 353.941406 411.683594 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(22.322083%,20.909119%,21.260071%);fill-opacity:1;" />
					</g>
				</svg>
			</xsl:when>
			<xsl:when test="$si-aspect = 'a_e'">
				<svg
					 xmlns:dc="http://purl.org/dc/elements/1.1/"
					 xmlns:cc="http://creativecommons.org/ns#"
					 xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
					 xmlns:svg="http://www.w3.org/2000/svg"
					 xmlns="http://www.w3.org/2000/svg"
					 viewBox="0 0 793.70667 793.70667"
					 height="793.70667"
					 width="793.70667"
					 xml:space="preserve"
					 id="svg2"
					 version="1.1"><metadata
						 id="metadata8"><rdf:RDF><cc:Work
								 rdf:about=""><dc:format>image/svg+xml</dc:format><dc:type
									 rdf:resource="http://purl.org/dc/dcmitype/StillImage" /></cc:Work></rdf:RDF></metadata><defs
						 id="defs6" /><g
						 transform="matrix(1.3333333,0,0,-1.3333333,0,793.70667)"
						 id="g10"><g
							 transform="scale(0.1)"
							 id="g12"><path
								 id="path14"
								 style="fill:#bdbcbc;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 2200.47,4489.45 -492.3,1022.27 C 973.336,5143.46 420.902,4465.26 222.191,3648.49 L 1327.98,3396.1 c 121.18,477.04 444.11,873.25 872.49,1093.35" /><path
								 id="path16"
								 style="fill:#bdbcbc;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 4677.18,2976.13 c 0,-385.75 -128.61,-741.36 -345.02,-1026.69 l 886.73,-707.16 c 371.14,479.32 592.15,1080.74 592.15,1733.85 0,202.15 -21.32,399.29 -61.55,589.46 L 4643.65,3313.18 c 21.91,-108.96 33.53,-221.64 33.53,-337.05" /><path
								 id="path18"
								 style="fill:#bdbcbc;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 2976.4,5810.78 c -425.67,0 -829.33,-94.01 -1191.63,-262.11 l 492.3,-1022.27 c 213.37,96.41 449.97,150.52 699.33,150.52 249.36,0 485.93,-54.11 699.3,-150.51 L 4168,5548.68 c -362.28,168.09 -765.93,262.1 -1191.6,262.1" /><path
								 id="path20"
								 style="fill:#bdbcbc;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="M 4624.81,3396.1 5730.6,3648.5 C 5531.88,4465.28 4979.44,5143.48 4244.59,5511.74 L 3752.3,4489.46 c 428.38,-220.09 751.33,-616.3 872.51,-1093.36" /><path
								 id="path22"
								 style="fill:#bdbcbc;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 1275.61,2976.13 c 0,115.41 11.63,228.09 33.54,337.04 L 203.297,3565.58 c -40.227,-190.17 -61.543,-387.3 -61.543,-589.45 0,-653.1 221.016,-1254.52 592.137,-1733.83 l 886.739,707.15 c -216.42,285.34 -345.02,640.94 -345.02,1026.68" /><path
								 id="path24"
								 style="fill:#bdbcbc;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="M 2933.86,142.031 V 1276.42 c -505.75,12.46 -956.65,245.33 -1260.13,606.61 L 786.852,1175.77 C 1298.35,554.398 2069.24,154.762 2933.86,142.031" /><path
								 id="path26"
								 style="fill:#57b235;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 3018.9,142.02 c 864.63,12.73 1635.51,412.371 2147.04,1033.73 l -886.89,707.27 C 3975.57,1521.73 3524.66,1288.86 3018.9,1276.42 V 142.02" /><path
								 id="path28"
								 style="fill:#deddde;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 3675.7,4526.41 c -213.37,96.4 -449.94,150.51 -699.3,150.51 -249.36,0 -485.96,-54.11 -699.33,-150.52 l 699.31,-1452.14 699.32,1452.15" /><path
								 id="path30"
								 style="fill:#deddde;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 1309.15,3313.17 c -21.91,-108.95 -33.54,-221.63 -33.54,-337.04 0,-385.74 128.6,-741.34 345.02,-1026.68 l 1260.2,1004.99 -1571.68,358.73" /><path
								 id="path32"
								 style="fill:#aad688;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 3018.9,1276.42 c 505.76,12.44 956.67,245.31 1260.15,606.6 L 3018.9,2887.95 V 1276.42" /><path
								 id="path34"
								 style="fill:#deddde;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 4643.65,3313.18 -1571.72,-358.74 1260.23,-1005 c 216.41,285.33 345.02,640.94 345.02,1026.69 0,115.41 -11.62,228.09 -33.53,337.05" /><path
								 id="path36"
								 style="fill:#deddde;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="M 2200.47,4489.45 C 1772.09,4269.35 1449.16,3873.14 1327.98,3396.1 l 1571.78,-358.75 -699.29,1452.1" /><path
								 id="path38"
								 style="fill:#deddde;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 4624.81,3396.1 c -121.18,477.06 -444.13,873.27 -872.51,1093.36 L 3053,3037.35 4624.81,3396.1" /><path
								 id="path40"
								 style="fill:#deddde;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 1673.73,1883.03 c 303.48,-361.28 754.38,-594.15 1260.13,-606.61 V 2887.95 L 1673.73,1883.03" /><path
								 id="path42"
								 style="fill:#ec008c;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 786.852,1175.77 c -18.02,21.87 -35.598,44.11 -52.961,66.53" /><path
								 id="path44"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 3968.53,2976.13 c 0,-547.93 -444.19,-992.12 -992.13,-992.12 -547.94,0 -992.13,444.19 -992.13,992.12 0,547.94 444.19,992.13 992.13,992.13 547.94,0 992.13,-444.19 992.13,-992.13" /><path
								 id="path46"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 2428.12,2585.6 74.8,86.76 c 70.3,-73.3 169.03,-122.66 270.75,-122.66 128.63,0 204.92,64.32 204.92,160.05 0,100.22 -70.31,131.64 -163.05,173.52 l -140.6,61.33 c -92.74,38.89 -198.95,109.19 -198.95,252.79 0,149.58 130.14,260.28 308.15,260.28 116.68,0 219.88,-49.37 290.17,-121.17 l -67.3,-80.77 c -59.83,56.84 -131.62,92.74 -222.87,92.74 -109.2,0 -182.5,-55.35 -182.5,-143.6 0,-94.24 85.27,-130.13 163.04,-163.04 l 139.12,-59.84 c 113.68,-49.36 201.94,-116.67 201.94,-261.77 0,-155.56 -127.15,-279.71 -333.58,-279.71 -137.61,0 -258.77,56.84 -344.04,145.09" /><path
								 id="path48"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 3298.71,3439.72 h 124.16 v -981.26 h -124.16 v 981.26" /><path
								 id="path50"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 1053.94,4174.64 c -80.956,55.93 -88.143,144.75 -43.46,209.41 21.49,31.1 48.68,45.13 76.25,52.33 l 17.93,-53.22 c -20.23,-4.99 -35.17,-12.9 -45.74,-28.2 -26.93,-39 -13.61,-88.32 35.25,-122.08 48.38,-33.42 98.89,-28.93 125.14,9.08 12.97,18.76 15.51,42.51 13.71,64.18 l 53.56,-2.72 c 4.04,-36.35 -5.86,-71.8 -24.96,-99.44 -45.71,-66.15 -127.23,-84.93 -207.68,-29.34" /><path
								 id="path52"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 1390.15,4501.41 -101.76,92.31 c -27.03,-3.01 -45.23,-13.24 -58.53,-27.9 -25.39,-28 -19.75,-74.44 26.03,-115.97 47.09,-42.73 88.54,-47.93 117.17,-16.38 15.31,16.88 20.67,37.95 17.09,67.94 z m -181.8,-104.83 c -71.09,64.5 -73.92,148.88 -30.78,196.43 22.58,24.88 46.02,31.96 76,35.55 l -36.72,30.07 -79.08,71.75 46.35,51.1 313.71,-284.61 -38.3,-42.21 -26.78,17.81 -1.6,-1.78 c 1.46,-30.51 -5.8,-64.42 -27.17,-87.97 -49.59,-54.65 -123.63,-51.45 -195.63,13.86" /><path
								 id="path54"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 2695.74,5510.2 67.65,4.32 16.88,-264.05 1.8,0.12 100.31,142.27 75.45,4.83 -92.93,-126.18 121.89,-167.15 -74.82,-4.79 -83.62,122.72 -42.73,-55.64 4.78,-74.85 -67.65,-4.32 -27.01,422.72" /><path
								 id="path56"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 3187.71,5285.37 c 2.73,36.49 -17.79,59.7 -46.52,61.84 -28.71,2.15 -53.01,-17.1 -55.8,-54.18 -2.82,-37.7 18.32,-60.94 47.03,-63.1 28.12,-2.1 52.48,17.73 55.29,55.44 z m 18.46,-236.05 c 1.7,22.74 -16.37,30.72 -49.87,33.22 l -40.09,3 c -16.16,1.21 -28.64,3.34 -39.77,7.18 -16.46,-10.8 -24.63,-23.43 -25.64,-37.19 -1.98,-26.33 25.58,-44.03 72.26,-47.52 47.27,-3.54 81.21,16.2 83.11,41.31 z m -213.58,0.34 c 1.84,24.53 18.4,44.95 46.58,59.7 l 0.18,2.39 c -14.24,10.68 -24.45,27.1 -22.66,51.02 1.7,22.74 18.73,41.33 36.39,52.05 l 0.18,2.39 c -18.64,16.42 -35.08,45.93 -32.48,80.65 5.05,67.6 62.32,101.23 123.94,96.62 16.17,-1.21 30.9,-5.32 42.56,-10.4 l 105.31,-7.87 -3.81,-50.87 -53.86,4.04 c 8.73,-12.09 14.57,-30.58 13.04,-50.93 -4.88,-65.21 -56.52,-96.24 -118.77,-91.59 -12.55,0.93 -26.73,4.4 -39.49,10.77 -9.57,-7.11 -15.49,-13.88 -16.46,-27.05 -1.25,-16.75 9.94,-27.82 45.84,-30.5 l 52.07,-3.89 c 70.6,-5.28 106.09,-29.59 102.28,-80.46 -4.33,-58.04 -68.77,-98.94 -164.51,-91.79 -70,5.24 -120.18,34.25 -116.33,85.72" /><path
								 id="path58"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 4730.5,4645.88 35.22,-44.81 -28.64,-28.61 1.49,-1.89 c 35.96,-3.02 70.27,-12.68 92.89,-41.45 26.7,-33.95 26.33,-65.52 8.93,-96.77 41.01,-3.62 77.09,-12.63 100.09,-41.88 38.56,-49.04 22.87,-98.01 -35.6,-143.99 l -145.26,-114.22 -43,54.71 138.16,108.65 c 38.2,30.04 43.46,52.48 24.55,76.54 -11.5,14.62 -33.55,23.23 -66.97,25.95 l -161.76,-127.19 -42.64,54.24 138.17,108.64 c 38.2,30.04 43.45,52.49 24.16,77 -11.12,14.15 -33.52,23.24 -66.96,25.97 l -161.75,-127.2 -42.64,54.23 231.56,182.08" /><path
								 id="path60"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 5086.91,2621.67 35.8,-41.69 c -25.88,-21.04 -43.91,-42.69 -50.76,-71.89 -7.27,-30.94 3.9,-48.98 23.77,-53.64 23.94,-5.62 41.72,22.86 60.52,50.49 22.93,34.67 54.56,72.24 102.45,60.98 50.23,-11.79 76.38,-60.45 61.31,-124.7 -9.34,-39.72 -33.23,-68 -56.82,-87.11 l -33.62,40.56 c 19.26,16.43 34.01,34.54 39.34,57.31 6.72,28.62 -3.55,45.22 -21.66,49.46 -22.77,5.36 -38.24,-21.22 -56.62,-49.55 -23.79,-35.71 -52.62,-74.54 -106.35,-61.93 -49.06,11.53 -79.59,59.98 -62.6,132.4 9.2,39.12 35.88,76.61 65.24,99.31" /><path
								 id="path62"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 774.859,2010.55 -18.457,53.91 36.465,17.56 -0.781,2.28 c -32.93,14.71 -62.129,35.15 -73.984,69.77 -14.004,40.87 -3.243,70.57 23.515,94.3 -37.519,16.96 -68.613,37.39 -80.664,72.57 -20.215,59.03 10.762,100.08 81.133,124.18 l 174.824,59.86 22.539,-65.84 -166.289,-56.95 c -45.976,-15.74 -58.34,-35.19 -48.418,-64.14 6.016,-17.6 23.965,-33 54.629,-46.61 l 194.688,66.67 22.343,-65.27 -166.308,-56.95 c -45.957,-15.74 -58.34,-35.19 -48.223,-64.71 5.84,-17.02 23.984,-33.01 54.649,-46.6 l 194.67,66.66 22.36,-65.27 -278.691,-95.42" /><path
								 id="path64"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 737.438,2738.83 c -58.809,-8.39 -93.692,-40.03 -87.598,-82.81 6.113,-42.77 48.359,-62.8 107.168,-54.41 58.222,8.3 93.203,39.35 87.09,82.12 -6.094,42.77 -48.438,63.41 -106.66,55.1 z m 29.57,-207.32 c -97.422,-13.9 -162.676,44.08 -173.008,116.56 -10.43,73.06 36.016,146.97 133.438,160.86 96.835,13.82 162.089,-44.17 172.5,-117.23 10.332,-72.47 -36.094,-146.38 -132.93,-160.19" /><path
								 id="path66"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 798.141,2885.01 -347.832,-10.72 -2.129,68.96 351.445,10.84 c 16.777,0.51 22.539,8.49 22.324,15.69 -0.097,2.99 -0.176,5.4 -1.543,10.76 l 51.309,10.59 c 3.867,-8.28 6.621,-20.21 7.129,-36.4 1.504,-49.18 -29.727,-68.15 -80.703,-69.72" /><path
								 id="path68"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 1989.53,1188.87 62.54,-30.55 -78.23,-160.121 1.62,-0.777 203.83,98.748 69.55,-33.98 -175.52,-84.542 21.62,-276.988 -69.01,33.699 -14.31,212.68 -81.51,-38.328 -50.29,-102.969 -62.54,30.547 172.25,352.581" /><path
								 id="path70"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 3913.02,919.441 90.57,42.879 -33.01,37.481 c -29.1,32.009 -58.65,67.819 -87.44,101.989 l -2.17,-1.03 c 8.97,-44.21 17.66,-89.22 24.01,-132.018 z m -89.86,213.689 73.75,34.93 283.4,-299.99 -66.16,-31.32 -73.1,82.902 -119.3,-56.492 17.78,-109.078 -63.99,-30.293 -52.38,409.341" /><path
								 id="path72"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 1697.71,3766 23.98,35.94 85.41,-85.35 0.88,1.33 -35,160.9 26.41,39.6 33.03,-137.93 163.75,-38.55 -24.87,-37.27 -134.02,34.1 13.75,-65.91 59.45,-59.38 -23.98,-35.94 -188.79,188.46" /><path
								 id="path74"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 2070.31,3708.57 c -28.81,25.18 -27.66,59.8 -7.56,82.81 9.67,11.07 20.8,15.28 31.78,16.85 l 4.57,-21.35 c -8.03,-1.04 -14.16,-3.43 -18.91,-8.87 -12.13,-13.88 -9.16,-33.51 8.22,-48.71 17.23,-15.05 36.92,-15.54 48.75,-2.02 5.82,6.68 7.85,15.74 8.13,24.19 l 20.56,-3.41 c -0.03,-14.22 -5.43,-27.48 -14.02,-37.31 -20.58,-23.54 -52.89,-27.2 -81.52,-2.18" /><path
								 id="path76"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 2202.83,3812.8 -37,38.51 c -10.56,-0.45 -17.91,-3.94 -23.45,-9.27 -10.59,-10.18 -9.63,-28.34 7.01,-45.66 17.13,-17.83 33.07,-20.95 45,-9.47 6.41,6.14 9.02,14.17 8.44,25.89 z m -73.28,-35.82 c -25.86,26.91 -24.71,59.71 -6.72,77 9.41,9.05 18.69,11.17 30.43,11.76 l -13.44,12.64 -28.77,29.93 19.34,18.58 114.08,-118.71 -15.98,-15.35 -9.9,7.62 -0.68,-0.65 c -0.24,-11.87 -3.95,-24.83 -12.88,-33.39 -20.68,-19.88 -49.31,-16.67 -75.48,10.57" /><path
								 id="path78"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 2940.23,4500.67 42.79,-0.22 -17.63,-83.11 -7.74,-28.35 h 1.6 c 20.08,17.09 41.35,30.18 64.94,30.06 32.8,-0.17 46.31,-18.23 46.14,-49.82 -0.04,-9.2 -0.88,-17.2 -3.34,-27.58 l -25.43,-123.85 -42.8,0.22 24.61,118.25 c 1.64,9.19 3.28,14.78 3.3,20.78 0.08,16.8 -7.87,25.23 -24.66,25.32 -13.6,0.07 -28.83,-9.05 -49.75,-30.13 l -27.07,-133.84 -43.18,0.21 58.22,282.06" /><path
								 id="path80"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 3961.46,3853.03 c 55.33,43.51 130.94,37.33 168.75,-10.77 14.84,-18.86 16.43,-38.98 13.03,-55.38 l -35.26,2.79 c 2.48,13.65 1.31,22.91 -6.83,33.28 -21.76,27.66 -72.85,26.66 -111.21,-3.51 -23.29,-18.29 -28.64,-39.29 -12.31,-60.05 9.4,-11.94 22.46,-16.92 34.94,-19.84 l -10.02,-31.26 c -17.63,4.95 -39.41,13.25 -57.71,36.52 -26.72,33.95 -23.28,76.82 16.62,108.22" /><path
								 id="path82"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 4229.64,2719.2 107.72,16.89 84.22,11.8 0.25,1.58 -76.15,37.56 -96.86,49.82 z m 16.18,168.82 217.24,-119.33 -8.81,-54.09 -243.85,-43.75 -27.63,4.51 35.41,217.16 27.64,-4.5" /><path
								 id="path84"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 4149.72,2598.5 135.2,0.12 c 8.92,0.01 18.02,0.93 27.3,2.77 9.28,1.83 15.22,6.63 17.81,14.4 1.25,3.71 1.82,8.05 1.7,13.04 l 7.37,0.41 3.38,-52.44 -2.74,-8.15 -158.73,-0.85 51.52,-50.9 c 9.24,-9.28 17.02,-14.99 23.3,-17.1 5.06,-1.71 12.5,-3.03 22.35,-4.01 7.21,-0.62 12.48,-1.5 15.8,-2.63 12.23,-4.1 16.11,-12.77 11.68,-25.96 -3.95,-11.73 -11.47,-15.74 -22.58,-12.01 -10.98,3.7 -29.22,18.9 -54.73,45.61 l -82.38,86.59 3.75,11.11" /><path
								 id="path86"
								 style="fill:none;stroke:#393536;stroke-width:5;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:10;stroke-dasharray:none;stroke-opacity:1"
								 d="m 4149.72,2598.5 135.2,0.12 c 8.92,0.01 18.02,0.93 27.3,2.77 9.28,1.83 15.22,6.63 17.81,14.4 1.25,3.71 1.82,8.05 1.7,13.04 l 7.37,0.41 3.38,-52.44 -2.74,-8.15 -158.73,-0.85 51.52,-50.9 c 9.24,-9.28 17.02,-14.99 23.3,-17.1 5.06,-1.71 12.5,-3.03 22.35,-4.01 7.21,-0.62 12.48,-1.5 15.8,-2.63 12.23,-4.1 16.11,-12.77 11.68,-25.96 -3.95,-11.73 -11.47,-15.74 -22.58,-12.01 -10.98,3.7 -29.22,18.9 -54.73,45.61 l -82.38,86.59 z" /><path
								 id="path88"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 1547.69,2518.04 -11.27,40.88 132.56,89.59 50.33,29.62 -0.43,1.54 c -26.68,-4.03 -60.08,-10.74 -89.06,-12.49 l -120.78,-8.78 -11.04,40.1 266.08,18.92 11.15,-40.49 -132.27,-89.1 -51.11,-29.84 0.43,-1.54 c 27.83,4.35 59.53,9.76 88.5,11.52 l 121.95,9.09 10.94,-39.71 -265.98,-19.31" /><path
								 id="path90"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 1820.83,2813.71 -4.76,38.65 -17.87,-7.6 c -15.35,-6.84 -32.17,-13.36 -48.3,-19.82 l 0.13,-0.93 c 17.39,-2.08 35.06,-4.37 51.63,-7.25 z m -89.8,-7.09 -3.91,31.47 145.28,67.98 3.49,-28.22 -39.51,-16.86 6.29,-50.91 42.42,-6.76 3.36,-27.31 -157.42,30.61" /><path
								 id="path92"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 2432.63,1917.71 38.46,-18.79 -109.96,-143.92 1.44,-0.7 118.21,44.18 43.1,-21.08 -108.03,-40.69 -7.3,-121.54 -38.83,18.98 8.13,93.08 -51.55,-17.99 -29.88,-39.26 -38.81,18.97 175.02,228.76" /><path
								 id="path94"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 3598.94,1768.11 c -1.13,5.22 -2.81,10.62 -5.55,16.4 -8.2,17.36 -22.79,29.48 -44.49,19.22 -21.33,-10.1 -34.1,-38.26 -28.42,-72.75 z m -59.53,67.86 c 41.21,19.5 69.92,-1.88 87.36,-38.75 7.37,-15.55 10,-34.21 10.2,-41.21 l -108.11,-51.15 c 13.83,-39.48 42.33,-45.47 69.08,-32.81 12.66,5.99 23.15,19.36 29.48,31.21 l 26.27,-18.11 c -9.67,-16.96 -26.53,-35.56 -51.86,-47.53 -42.3,-20.02 -84.22,-6.23 -106.8,41.49 -31.3,66.17 -2.26,134.78 44.38,156.86" /></g></g></svg>
			</xsl:when>
			<xsl:when test="$si-aspect = 'cd_kcd_h_deltanu'">
				<svg
					 xmlns:dc="http://purl.org/dc/elements/1.1/"
					 xmlns:cc="http://creativecommons.org/ns#"
					 xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
					 xmlns:svg="http://www.w3.org/2000/svg"
					 xmlns="http://www.w3.org/2000/svg"
					 viewBox="0 0 793.70667 793.70667"
					 height="793.70667"
					 width="793.70667"
					 xml:space="preserve"
					 id="svg2"
					 version="1.1"><metadata
						 id="metadata8"><rdf:RDF><cc:Work
								 rdf:about=""><dc:format>image/svg+xml</dc:format><dc:type
									 rdf:resource="http://purl.org/dc/dcmitype/StillImage" /></cc:Work></rdf:RDF></metadata><defs
						 id="defs6" /><g
						 transform="matrix(1.3333333,0,0,-1.3333333,0,793.70667)"
						 id="g10"><g
							 transform="scale(0.1)"
							 id="g12"><path
								 id="path14"
								 style="fill:#3a2e91;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 2200.47,4489.45 -492.3,1022.27 C 973.336,5143.46 420.906,4465.25 222.195,3648.49 L 1327.99,3396.1 c 121.17,477.04 444.11,873.25 872.48,1093.35" /><path
								 id="path16"
								 style="fill:#bdbcbc;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 4677.18,2976.13 c 0,-385.75 -128.6,-741.35 -345.02,-1026.7 l 886.73,-707.15 c 371.14,479.32 592.16,1080.74 592.16,1733.85 0,202.15 -21.33,399.29 -61.56,589.46 L 4643.65,3313.18 c 21.91,-108.96 33.53,-221.64 33.53,-337.05" /><path
								 id="path18"
								 style="fill:#bdbcbc;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 2976.4,5810.78 c -425.67,0 -829.34,-94.01 -1191.63,-262.11 l 492.29,-1022.28 c 213.38,96.42 449.97,150.52 699.34,150.52 249.35,0 485.93,-54.1 699.3,-150.5 L 4168,5548.68 c -362.28,168.09 -765.94,262.1 -1191.6,262.1" /><path
								 id="path20"
								 style="fill:#bdbcbc;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="M 4624.82,3396.1 5730.6,3648.5 C 5531.89,4465.27 4979.45,5143.48 4244.59,5511.74 L 3752.3,4489.46 c 428.39,-220.09 751.34,-616.3 872.52,-1093.36" /><path
								 id="path22"
								 style="fill:#bdbcbc;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 1275.61,2976.13 c 0,115.41 11.63,228.09 33.54,337.04 L 203.297,3565.58 c -40.223,-190.17 -61.543,-387.3 -61.543,-589.45 0,-653.11 221.016,-1254.52 592.141,-1733.83 l 886.735,707.15 c -216.41,285.34 -345.02,640.94 -345.02,1026.68" /><path
								 id="path24"
								 style="fill:#bdbcbc;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="M 2933.86,142.031 V 1276.42 c -505.75,12.46 -956.65,245.33 -1260.13,606.61 L 786.852,1175.77 C 1298.36,554.398 2069.24,154.762 2933.86,142.031" /><path
								 id="path26"
								 style="fill:#bdbcbc;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 3018.9,142.031 c 864.63,12.719 1635.52,412.36 2147.04,1033.719 l -886.88,707.26 C 3975.57,1521.73 3524.66,1288.86 3018.9,1276.42 V 142.031" /><path
								 id="path28"
								 style="fill:#e7807c;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 3675.7,4526.41 c -213.37,96.4 -449.95,150.5 -699.3,150.5 -249.37,0 -485.96,-54.1 -699.34,-150.52 l 699.32,-1452.13 699.32,1452.15" /><path
								 id="path30"
								 style="fill:#deddde;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 1309.15,3313.17 c -21.91,-108.95 -33.54,-221.63 -33.54,-337.04 0,-385.74 128.61,-741.34 345.02,-1026.68 l 1260.2,1004.99 -1571.68,358.73" /><path
								 id="path32"
								 style="fill:#deddde;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 3018.9,1276.42 c 505.76,12.44 956.67,245.31 1260.16,606.59 L 3018.9,2887.95 V 1276.42" /><path
								 id="path34"
								 style="fill:#fbcb78;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="M 4643.65,3313.18 3071.93,2954.44 4332.16,1949.43 c 216.42,285.35 345.02,640.95 345.02,1026.7 0,115.41 -11.62,228.09 -33.53,337.05" /><path
								 id="path36"
								 style="fill:#8d78c3;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="M 2200.47,4489.45 C 1772.1,4269.35 1449.16,3873.14 1327.99,3396.1 l 1571.77,-358.75 -699.29,1452.1" /><path
								 id="path38"
								 style="fill:#deddde;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 4624.82,3396.1 c -121.18,477.06 -444.13,873.27 -872.52,1093.36 L 3053,3037.35 4624.82,3396.1" /><path
								 id="path40"
								 style="fill:#deddde;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 1673.73,1883.03 c 303.48,-361.28 754.38,-594.15 1260.13,-606.61 V 2887.95 L 1673.73,1883.03" /><path
								 id="path42"
								 style="fill:#ec008c;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 786.852,1175.77 c -18.016,21.88 -35.594,44.11 -52.957,66.53" /><path
								 id="path44"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 3968.52,2976.13 c 0,-547.94 -444.19,-992.13 -992.12,-992.13 -547.94,0 -992.13,444.19 -992.13,992.13 0,547.94 444.19,992.13 992.13,992.13 547.93,0 992.12,-444.19 992.12,-992.13" /><path
								 id="path46"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 2428.12,2585.6 74.81,86.76 c 70.29,-73.3 169.02,-122.66 270.74,-122.66 128.63,0 204.92,64.32 204.92,160.06 0,100.22 -70.31,131.63 -163.05,173.51 l -140.6,61.33 c -92.74,38.89 -198.95,109.19 -198.95,252.79 0,149.58 130.14,260.28 308.15,260.28 116.68,0 219.88,-49.37 290.17,-121.17 l -67.3,-80.77 c -59.82,56.84 -131.62,92.74 -222.87,92.74 -109.2,0 -182.5,-55.35 -182.5,-143.6 0,-94.24 85.27,-130.13 163.05,-163.04 l 139.12,-59.84 c 113.67,-49.36 201.93,-116.67 201.93,-261.77 0,-155.56 -127.15,-279.71 -333.57,-279.71 -137.62,0 -258.77,56.84 -344.05,145.09" /><path
								 id="path48"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 3298.71,3439.72 h 124.16 v -981.26 h -124.16 v 981.26" /><path
								 id="path50"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 1053.94,4174.64 c -80.956,55.93 -88.143,144.75 -43.45,209.41 21.48,31.1 48.67,45.13 76.25,52.33 l 17.93,-53.22 c -20.24,-4.99 -35.18,-12.9 -45.75,-28.2 -26.93,-39 -13.61,-88.31 35.26,-122.07 48.38,-33.43 98.88,-28.94 125.13,9.07 12.97,18.76 15.51,42.51 13.71,64.18 l 53.56,-2.72 c 4.04,-36.35 -5.86,-71.8 -24.96,-99.44 -45.7,-66.15 -127.23,-84.93 -207.68,-29.34" /><path
								 id="path52"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 1390.15,4501.41 -101.75,92.31 c -27.04,-3.01 -45.24,-13.24 -58.54,-27.9 -25.39,-28 -19.75,-74.44 26.04,-115.97 47.09,-42.73 88.53,-47.93 117.16,-16.38 15.32,16.88 20.67,37.95 17.09,67.94 z m -181.79,-104.83 c -71.1,64.5 -73.93,148.88 -30.78,196.43 22.57,24.88 46.01,31.97 75.99,35.55 l -36.72,30.07 -79.08,71.76 46.35,51.09 313.71,-284.61 -38.3,-42.21 -26.78,17.81 -1.6,-1.78 c 1.46,-30.5 -5.8,-64.42 -27.17,-87.97 -49.59,-54.65 -123.63,-51.45 -195.62,13.86" /><path
								 id="path54"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 2695.74,5510.2 67.66,4.32 16.87,-264.05 1.8,0.12 100.31,142.27 75.45,4.83 -92.93,-126.18 121.89,-167.15 -74.82,-4.79 -83.61,122.72 -42.74,-55.64 4.79,-74.85 -67.66,-4.32 -27.01,422.72" /><path
								 id="path56"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 3187.71,5285.37 c 2.74,36.5 -17.79,59.7 -46.52,61.84 -28.71,2.16 -53.01,-17.1 -55.8,-54.18 -2.81,-37.7 18.32,-60.94 47.03,-63.1 28.12,-2.1 52.48,17.74 55.29,55.44 z m 18.46,-236.04 c 1.7,22.73 -16.37,30.71 -49.86,33.21 l -40.1,3 c -16.15,1.21 -28.63,3.34 -39.77,7.18 -16.46,-10.8 -24.63,-23.43 -25.64,-37.19 -1.97,-26.33 25.58,-44.03 72.26,-47.52 47.27,-3.54 81.21,16.2 83.11,41.32 z m -213.57,0.33 c 1.83,24.53 18.39,44.95 46.58,59.7 l 0.17,2.39 c -14.24,10.68 -24.45,27.1 -22.65,51.02 1.7,22.74 18.73,41.33 36.38,52.05 l 0.18,2.39 c -18.63,16.42 -35.08,45.93 -32.48,80.65 5.06,67.6 62.32,101.23 123.94,96.62 16.18,-1.21 30.9,-5.32 42.56,-10.4 l 105.32,-7.87 -3.81,-50.87 -53.87,4.04 c 8.73,-12.09 14.57,-30.58 13.05,-50.93 -4.89,-65.21 -56.53,-96.24 -118.77,-91.59 -12.56,0.93 -26.74,4.4 -39.5,10.77 -9.57,-7.11 -15.48,-13.88 -16.46,-27.05 -1.25,-16.75 9.94,-27.82 45.84,-30.5 l 52.07,-3.89 c 70.61,-5.28 106.09,-29.59 102.29,-80.46 -4.34,-58.04 -68.77,-98.94 -164.52,-91.79 -70,5.24 -120.17,34.26 -116.32,85.72" /><path
								 id="path58"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 4730.51,4645.88 35.21,-44.81 -28.63,-28.61 1.48,-1.89 c 35.96,-3.02 70.28,-12.68 92.89,-41.45 26.7,-33.95 26.33,-65.52 8.93,-96.77 41.01,-3.62 77.09,-12.63 100.1,-41.88 38.55,-49.03 22.87,-98.01 -35.61,-143.99 l -145.25,-114.21 -43.01,54.7 138.16,108.65 c 38.21,30.04 43.46,52.49 24.55,76.54 -11.5,14.62 -33.55,23.24 -66.97,25.95 l -161.76,-127.19 -42.63,54.24 138.16,108.64 c 38.2,30.04 43.46,52.49 24.16,77.01 -11.11,14.14 -33.52,23.23 -66.95,25.96 l -161.76,-127.2 -42.64,54.23 231.57,182.08" /><path
								 id="path60"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 5086.91,2621.67 35.8,-41.69 c -25.88,-21.03 -43.9,-42.69 -50.76,-71.88 -7.26,-30.95 3.91,-48.99 23.77,-53.65 23.95,-5.62 41.72,22.86 60.53,50.49 22.93,34.67 54.55,72.24 102.44,60.98 50.23,-11.79 76.39,-60.45 61.31,-124.7 -9.34,-39.72 -33.23,-68 -56.82,-87.11 l -33.61,40.56 c 19.26,16.43 34,34.54 39.33,57.31 6.72,28.63 -3.55,45.22 -21.66,49.47 -22.77,5.35 -38.24,-21.23 -56.62,-49.56 -23.79,-35.71 -52.61,-74.54 -106.35,-61.93 -49.06,11.53 -79.58,59.98 -62.59,132.4 9.2,39.12 35.88,76.61 65.23,99.31" /><path
								 id="path62"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 774.859,2010.55 -18.457,53.91 36.465,17.56 -0.781,2.28 c -32.93,14.71 -62.129,35.15 -73.984,69.77 -14.004,40.87 -3.243,70.57 23.515,94.3 -37.519,16.96 -68.613,37.39 -80.664,72.57 -20.215,59.04 10.762,100.08 81.133,124.18 l 174.824,59.87 22.539,-65.84 -166.289,-56.96 c -45.976,-15.74 -58.34,-35.19 -48.418,-64.14 6.016,-17.6 23.965,-33 54.633,-46.6 l 194.684,66.66 22.343,-65.27 -166.308,-56.95 c -45.957,-15.74 -58.34,-35.19 -48.219,-64.71 5.836,-17.02 23.98,-33.01 54.645,-46.6 l 194.67,66.66 22.36,-65.27 -278.691,-95.42" /><path
								 id="path64"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 737.438,2738.83 c -58.809,-8.39 -93.688,-40.03 -87.598,-82.8 6.113,-42.78 48.359,-62.81 107.168,-54.42 58.222,8.3 93.203,39.35 87.09,82.12 -6.094,42.77 -48.438,63.41 -106.66,55.1 z m 29.57,-207.32 c -97.422,-13.9 -162.676,44.08 -173.008,116.56 -10.43,73.06 36.016,146.97 133.438,160.86 96.835,13.82 162.089,-44.16 172.5,-117.23 10.332,-72.47 -36.094,-146.38 -132.93,-160.19" /><path
								 id="path66"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 798.141,2885.01 -347.832,-10.72 -2.129,68.96 351.445,10.84 c 16.777,0.51 22.543,8.49 22.324,15.69 -0.097,2.99 -0.176,5.4 -1.543,10.76 l 51.309,10.59 c 3.867,-8.28 6.621,-20.21 7.129,-36.4 1.504,-49.18 -29.727,-68.15 -80.703,-69.72" /><path
								 id="path68"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 1989.53,1188.87 62.54,-30.55 -78.22,-160.121 1.62,-0.777 203.82,98.748 69.56,-33.98 -175.53,-84.53 21.62,-277 -69,33.699 -14.32,212.68 -81.51,-38.328 -50.29,-102.969 -62.54,30.547 172.25,352.581" /><path
								 id="path70"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 3913.02,919.441 90.57,42.879 -33.01,37.481 c -29.1,32.019 -58.65,67.819 -87.44,101.989 l -2.17,-1.03 c 8.97,-44.21 17.66,-89.22 24.01,-132.018 z m -89.86,213.689 73.75,34.93 283.4,-299.978 -66.15,-31.332 -73.11,82.902 -119.29,-56.492 17.77,-109.078 -63.99,-30.293 -52.38,409.341" /><path
								 id="path72"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 1697.71,3766 23.99,35.94 85.41,-85.35 0.88,1.33 -35,160.9 26.4,39.6 33.03,-137.93 163.75,-38.55 -24.86,-37.27 -134.03,34.1 13.75,-65.91 59.46,-59.38 -23.99,-35.94 -188.79,188.46" /><path
								 id="path74"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 2070.31,3708.57 c -28.81,25.18 -27.66,59.8 -7.56,82.81 9.67,11.07 20.8,15.28 31.78,16.85 l 4.57,-21.35 c -8.03,-1.04 -14.16,-3.43 -18.91,-8.87 -12.13,-13.88 -9.16,-33.51 8.23,-48.71 17.22,-15.05 36.91,-15.54 48.75,-2.02 5.82,6.68 7.85,15.74 8.12,24.19 l 20.57,-3.41 c -0.04,-14.22 -5.43,-27.48 -14.03,-37.31 -20.58,-23.54 -52.89,-27.2 -81.52,-2.18" /><path
								 id="path76"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 2202.83,3812.8 -36.99,38.51 c -10.57,-0.45 -17.91,-3.94 -23.46,-9.27 -10.59,-10.18 -9.63,-28.34 7.01,-45.66 17.13,-17.83 33.07,-20.95 45,-9.47 6.41,6.14 9.03,14.17 8.44,25.89 z m -73.28,-35.82 c -25.86,26.91 -24.71,59.71 -6.72,77 9.41,9.05 18.69,11.17 30.43,11.76 l -13.44,12.64 -28.77,29.93 19.34,18.58 114.08,-118.71 -15.98,-15.35 -9.9,7.62 -0.68,-0.65 c -0.24,-11.87 -3.95,-24.82 -12.87,-33.39 -20.69,-19.88 -49.32,-16.67 -75.49,10.57" /><path
								 id="path78"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 2940.23,4500.67 42.79,-0.22 -17.63,-83.11 -7.74,-28.35 h 1.61 c 20.07,17.09 41.34,30.18 64.94,30.06 32.79,-0.17 46.31,-18.23 46.13,-49.82 -0.04,-9.2 -0.88,-17.2 -3.34,-27.58 l -25.43,-123.85 -42.79,0.22 24.61,118.25 c 1.64,9.19 3.28,14.78 3.3,20.78 0.08,16.8 -7.87,25.23 -24.67,25.32 -13.59,0.07 -28.83,-9.05 -49.75,-30.13 l -27.07,-133.84 -43.18,0.21 58.22,282.06" /><path
								 id="path80"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 3961.46,3853.03 c 55.33,43.51 130.94,37.33 168.75,-10.76 14.85,-18.87 16.43,-38.99 13.03,-55.39 l -35.25,2.79 c 2.48,13.65 1.3,22.91 -6.84,33.28 -21.76,27.66 -72.85,26.66 -111.21,-3.51 -23.28,-18.29 -28.63,-39.29 -12.31,-60.05 9.4,-11.94 22.47,-16.92 34.95,-19.83 l -10.02,-31.27 c -17.64,4.95 -39.42,13.25 -57.72,36.52 -26.72,33.95 -23.28,76.82 16.62,108.22" /><path
								 id="path82"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 4229.65,2719.2 107.71,16.89 84.22,11.81 0.25,1.57 -76.15,37.56 -96.85,49.83 z m 16.17,168.82 217.24,-119.33 -8.8,-54.09 -243.85,-43.75 -27.64,4.51 35.41,217.16 27.64,-4.5" /><path
								 id="path84"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 4149.72,2598.51 135.2,0.11 c 8.93,0.01 18.03,0.93 27.3,2.77 9.28,1.83 15.22,6.63 17.82,14.41 1.25,3.7 1.81,8.04 1.7,13.03 l 7.36,0.41 3.38,-52.44 -2.74,-8.15 -158.73,-0.85 51.53,-50.9 c 9.23,-9.28 17.01,-14.99 23.3,-17.1 5.06,-1.7 12.5,-3.03 22.34,-4.01 7.21,-0.62 12.48,-1.5 15.8,-2.63 12.23,-4.1 16.12,-12.76 11.68,-25.96 -3.94,-11.73 -11.46,-15.74 -22.58,-12 -10.97,3.69 -29.22,18.89 -54.72,45.6 l -82.39,86.59 3.75,11.12" /><path
								 id="path86"
								 style="fill:none;stroke:#393536;stroke-width:5;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:10;stroke-dasharray:none;stroke-opacity:1"
								 d="m 4149.72,2598.51 135.2,0.11 c 8.93,0.01 18.03,0.93 27.3,2.77 9.28,1.83 15.22,6.63 17.82,14.41 1.25,3.7 1.81,8.04 1.7,13.03 l 7.36,0.41 3.38,-52.44 -2.74,-8.15 -158.73,-0.85 51.53,-50.9 c 9.23,-9.28 17.01,-14.99 23.3,-17.1 5.06,-1.7 12.5,-3.03 22.34,-4.01 7.21,-0.62 12.48,-1.5 15.8,-2.63 12.23,-4.1 16.12,-12.76 11.68,-25.96 -3.94,-11.73 -11.46,-15.74 -22.58,-12 -10.97,3.69 -29.22,18.89 -54.72,45.6 l -82.39,86.59 z" /><path
								 id="path88"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 1547.69,2518.04 -11.27,40.88 132.56,89.59 50.33,29.62 -0.43,1.54 c -26.68,-4.03 -60.07,-10.74 -89.06,-12.49 l -120.78,-8.78 -11.03,40.1 266.07,18.92 11.15,-40.49 -132.26,-89.1 -51.12,-29.84 0.43,-1.54 c 27.83,4.36 59.53,9.77 88.5,11.52 l 121.95,9.09 10.94,-39.71 -265.98,-19.31" /><path
								 id="path90"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 1820.84,2813.72 -4.77,38.64 -17.87,-7.6 c -15.35,-6.84 -32.17,-13.36 -48.3,-19.82 l 0.14,-0.93 c 17.38,-2.08 35.06,-4.37 51.62,-7.25 z m -89.81,-7.1 -3.9,31.48 145.27,67.97 3.5,-28.22 -39.52,-16.86 6.29,-50.91 42.43,-6.76 3.35,-27.3 -157.42,30.6" /><path
								 id="path92"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 2432.63,1917.71 38.46,-18.78 -109.96,-143.93 1.45,-0.7 118.2,44.18 43.1,-21.08 -108.02,-40.69 -7.31,-121.53 -38.83,18.97 8.13,93.09 -51.54,-18 -29.89,-39.26 -38.81,18.97 175.02,228.76" /><path
								 id="path94"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 3598.94,1768.11 c -1.13,5.22 -2.81,10.62 -5.54,16.4 -8.21,17.36 -22.8,29.48 -44.5,19.22 -21.32,-10.1 -34.1,-38.26 -28.41,-72.74 z m -59.53,67.86 c 41.21,19.5 69.92,-1.88 87.36,-38.75 7.37,-15.55 10,-34.21 10.2,-41.2 l -108.11,-51.16 c 13.83,-39.48 42.33,-45.47 69.09,-32.81 12.65,5.99 23.14,19.37 29.47,31.21 l 26.27,-18.1 c -9.67,-16.97 -26.52,-35.57 -51.86,-47.54 -42.3,-20.02 -84.22,-6.23 -106.79,41.49 -31.31,66.17 -2.27,134.79 44.37,156.86" /></g></g></svg>
			</xsl:when>
			<xsl:when test="$si-aspect = 'cd_kcd'">
				<svg
					 xmlns:dc="http://purl.org/dc/elements/1.1/"
					 xmlns:cc="http://creativecommons.org/ns#"
					 xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
					 xmlns:svg="http://www.w3.org/2000/svg"
					 xmlns="http://www.w3.org/2000/svg"
					 id="svg85"
					 version="1.2"
					 viewBox="0 0 595.28 595.28"
					 height="595.28pt"
					 width="595.28pt">
					<metadata
						 id="metadata91">
						<rdf:RDF>
							<cc:Work
								 rdf:about="">
								<dc:format>image/svg+xml</dc:format>
								<dc:type
									 rdf:resource="http://purl.org/dc/dcmitype/StillImage" />
							</cc:Work>
						</rdf:RDF>
					</metadata>
					<defs
						 id="defs89" />
					<g
						 id="surface1">
						<path
							 id="path2"
							 d="M 220.046875 146.335938 L 170.816406 44.109375 C 97.332031 80.933594 42.089844 148.753906 22.21875 230.429688 L 132.796875 255.671875 C 144.914062 207.964844 177.210938 168.34375 220.046875 146.335938 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(22.715759%,17.915344%,56.864929%);fill-opacity:1;" />
						<path
							 id="path4"
							 d="M 467.71875 297.667969 C 467.71875 336.242188 454.859375 371.804688 433.214844 400.335938 L 521.890625 471.050781 C 559.003906 423.121094 581.105469 362.976562 581.105469 297.667969 C 581.105469 277.453125 578.972656 257.738281 574.949219 238.722656 L 464.367188 263.960938 C 466.554688 274.859375 467.71875 286.125 467.71875 297.667969 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(74.113464%,73.643494%,73.75946%);fill-opacity:1;" />
						<path
							 id="path6"
							 d="M 297.640625 14.203125 C 255.074219 14.203125 214.707031 23.601562 178.476562 40.414062 L 227.707031 142.640625 C 249.042969 133 272.703125 127.589844 297.640625 127.589844 C 322.574219 127.589844 346.234375 133 367.570312 142.640625 L 416.800781 40.410156 C 380.570312 23.601562 340.207031 14.203125 297.640625 14.203125 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(74.113464%,73.643494%,73.75946%);fill-opacity:1;" />
						<path
							 id="path8"
							 d="M 462.480469 255.671875 L 573.058594 230.429688 C 553.1875 148.753906 497.945312 80.933594 424.460938 44.105469 L 375.230469 146.335938 C 418.070312 168.34375 450.363281 207.964844 462.480469 255.671875 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(74.113464%,73.643494%,73.75946%);fill-opacity:1;" />
						<path
							 id="path10"
							 d="M 127.5625 297.667969 C 127.5625 286.125 128.722656 274.859375 130.914062 263.964844 L 20.328125 238.722656 C 16.308594 257.738281 14.175781 277.453125 14.175781 297.667969 C 14.175781 362.976562 36.277344 423.117188 73.390625 471.050781 L 162.0625 400.335938 C 140.421875 371.800781 127.5625 336.242188 127.5625 297.667969 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(74.113464%,73.643494%,73.75946%);fill-opacity:1;" />
						<path
							 id="path12"
							 d="M 293.386719 581.078125 L 293.386719 467.636719 C 242.8125 466.390625 197.722656 443.105469 167.371094 406.976562 L 78.683594 477.703125 C 129.835938 539.839844 206.925781 579.804688 293.386719 581.078125 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(74.113464%,73.643494%,73.75946%);fill-opacity:1;" />
						<path
							 id="path14"
							 d="M 301.890625 581.078125 C 388.351562 579.804688 465.441406 539.839844 516.59375 477.703125 L 427.90625 406.976562 C 397.558594 443.105469 352.464844 466.394531 301.890625 467.636719 L 301.890625 581.078125 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(74.113464%,73.643494%,73.75946%);fill-opacity:1;" />
						<path
							 id="path16"
							 d="M 367.570312 142.640625 C 346.234375 133 322.574219 127.589844 297.640625 127.589844 C 272.703125 127.589844 249.042969 133 227.707031 142.640625 L 297.636719 287.855469 L 367.570312 142.640625 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(87.068176%,86.833191%,86.891174%);fill-opacity:1;" />
						<path
							 id="path18"
							 d="M 130.914062 263.964844 C 128.722656 274.859375 127.5625 286.125 127.5625 297.667969 C 127.5625 336.242188 140.421875 371.800781 162.0625 400.335938 L 288.082031 299.835938 L 130.914062 263.964844 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(87.068176%,86.833191%,86.891174%);fill-opacity:1;" />
						<path
							 id="path20"
							 d="M 301.890625 467.636719 C 352.464844 466.394531 397.558594 443.105469 427.90625 406.976562 L 301.890625 306.484375 L 301.890625 467.636719 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(87.068176%,86.833191%,86.891174%);fill-opacity:1;" />
						<path
							 id="path22"
							 d="M 464.367188 263.960938 L 307.191406 299.835938 L 433.214844 400.335938 C 454.859375 371.804688 467.71875 336.242188 467.71875 297.667969 C 467.71875 286.125 466.554688 274.859375 464.367188 263.960938 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(87.068176%,86.833191%,86.891174%);fill-opacity:1;" />
						<path
							 id="path24"
							 d="M 220.046875 146.335938 C 177.210938 168.34375 144.914062 207.964844 132.796875 255.671875 L 289.976562 291.546875 L 220.046875 146.335938 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(55.33905%,46.882629%,76.387024%);fill-opacity:1;" />
						<path
							 id="path26"
							 d="M 462.480469 255.671875 C 450.363281 207.964844 418.070312 168.34375 375.230469 146.335938 L 305.300781 291.546875 L 462.480469 255.671875 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(87.068176%,86.833191%,86.891174%);fill-opacity:1;" />
						<path
							 id="path28"
							 d="M 167.371094 406.976562 C 197.722656 443.105469 242.8125 466.390625 293.386719 467.636719 L 293.386719 306.484375 L 167.371094 406.976562 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(87.068176%,86.833191%,86.891174%);fill-opacity:1;" />
						<path
							 id="path30"
							 d="M 78.683594 477.703125 C 76.882812 475.515625 75.125 473.292969 73.390625 471.050781 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(92.549133%,0%,54.899597%);fill-opacity:1;" />
						<path
							 id="path32"
							 d="M 396.851562 297.667969 C 396.851562 352.460938 352.433594 396.878906 297.640625 396.878906 C 242.847656 396.878906 198.425781 352.460938 198.425781 297.667969 C 198.425781 242.871094 242.847656 198.453125 297.640625 198.453125 C 352.433594 198.453125 396.851562 242.871094 396.851562 297.667969 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,100%,100%);fill-opacity:1;" />
						<path
							 id="path34"
							 d="M 242.8125 336.71875 L 250.292969 328.042969 C 257.320312 335.375 267.195312 340.308594 277.367188 340.308594 C 290.230469 340.308594 297.859375 333.878906 297.859375 324.304688 C 297.859375 314.28125 290.828125 311.140625 281.554688 306.953125 L 267.492188 300.820312 C 258.21875 296.929688 247.597656 289.902344 247.597656 275.539062 C 247.597656 260.582031 260.613281 249.511719 278.414062 249.511719 C 290.082031 249.511719 300.402344 254.449219 307.429688 261.628906 L 300.699219 269.707031 C 294.71875 264.023438 287.539062 260.433594 278.414062 260.433594 C 267.492188 260.433594 260.164062 265.96875 260.164062 274.792969 C 260.164062 284.21875 268.691406 287.804688 276.46875 291.097656 L 290.378906 297.082031 C 301.746094 302.015625 310.574219 308.746094 310.574219 323.257812 C 310.574219 338.8125 297.859375 351.230469 277.214844 351.230469 C 263.453125 351.230469 251.339844 345.546875 242.8125 336.71875 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(22.322083%,20.909119%,21.260071%);fill-opacity:1;" />
						<path
							 id="path36"
							 d="M 329.871094 251.308594 L 342.285156 251.308594 L 342.285156 349.433594 L 329.871094 349.433594 L 329.871094 251.308594 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(22.322083%,20.909119%,21.260071%);fill-opacity:1;" />
						<path
							 id="path38"
							 d="M 105.394531 177.816406 C 97.296875 172.222656 96.578125 163.339844 101.046875 156.875 C 103.195312 153.765625 105.914062 152.363281 108.671875 151.640625 L 110.464844 156.964844 C 108.441406 157.464844 106.949219 158.253906 105.890625 159.785156 C 103.199219 163.683594 104.53125 168.617188 109.417969 171.992188 C 114.253906 175.335938 119.304688 174.886719 121.929688 171.085938 C 123.226562 169.207031 123.480469 166.832031 123.300781 164.664062 L 128.65625 164.9375 C 129.0625 168.574219 128.070312 172.117188 126.160156 174.882812 C 121.589844 181.496094 113.4375 183.375 105.394531 177.816406 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,100%,100%);fill-opacity:1;" />
						<path
							 id="path40"
							 d="M 139.015625 145.140625 L 128.839844 135.90625 C 126.136719 136.210938 124.316406 137.230469 122.984375 138.699219 C 120.445312 141.496094 121.011719 146.140625 125.589844 150.296875 C 130.296875 154.566406 134.441406 155.089844 137.304688 151.933594 C 138.839844 150.246094 139.371094 148.136719 139.015625 145.140625 Z M 120.835938 155.621094 C 113.726562 149.171875 113.441406 140.734375 117.757812 135.980469 C 120.015625 133.492188 122.359375 132.78125 125.355469 132.425781 L 121.683594 129.417969 L 113.777344 122.242188 L 118.410156 117.132812 L 149.78125 145.59375 L 145.953125 149.8125 L 143.273438 148.03125 L 143.113281 148.210938 C 143.261719 151.261719 142.535156 154.652344 140.398438 157.007812 C 135.4375 162.472656 128.035156 162.152344 120.835938 155.621094 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,100%,100%);fill-opacity:1;" />
						<path
							 id="path42"
							 d="M 269.574219 44.261719 L 276.339844 43.828125 L 278.027344 70.234375 L 278.207031 70.222656 L 288.238281 55.992188 L 295.78125 55.511719 L 286.488281 68.128906 L 298.679688 84.84375 L 291.195312 85.324219 L 282.835938 73.050781 L 278.5625 78.613281 L 279.039062 86.101562 L 272.273438 86.53125 L 269.574219 44.261719 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,100%,100%);fill-opacity:1;" />
						<path
							 id="path44"
							 d="M 318.769531 66.742188 C 319.042969 63.09375 316.992188 60.773438 314.117188 60.558594 C 311.246094 60.34375 308.816406 62.269531 308.539062 65.976562 C 308.257812 69.746094 310.371094 72.070312 313.242188 72.285156 C 316.054688 72.496094 318.488281 70.515625 318.769531 66.742188 Z M 320.617188 90.347656 C 320.785156 88.074219 318.980469 87.277344 315.628906 87.027344 L 311.621094 86.726562 C 310.003906 86.605469 308.757812 86.390625 307.644531 86.007812 C 305.996094 87.089844 305.179688 88.351562 305.078125 89.726562 C 304.882812 92.359375 307.636719 94.128906 312.304688 94.480469 C 317.03125 94.832031 320.425781 92.859375 320.617188 90.347656 Z M 299.257812 90.3125 C 299.441406 87.859375 301.097656 85.820312 303.917969 84.34375 L 303.933594 84.105469 C 302.511719 83.035156 301.488281 81.394531 301.667969 79.003906 C 301.839844 76.730469 303.542969 74.871094 305.308594 73.796875 L 305.324219 73.558594 C 303.460938 71.917969 301.816406 68.964844 302.078125 65.492188 C 302.582031 58.734375 308.308594 55.371094 314.472656 55.832031 C 316.089844 55.953125 317.5625 56.363281 318.726562 56.871094 L 329.257812 57.660156 L 328.878906 62.746094 L 323.492188 62.34375 C 324.363281 63.550781 324.949219 65.398438 324.796875 67.433594 C 324.308594 73.957031 319.144531 77.058594 312.917969 76.59375 C 311.664062 76.5 310.246094 76.152344 308.96875 75.515625 C 308.011719 76.226562 307.421875 76.90625 307.324219 78.222656 C 307.199219 79.898438 308.316406 81.003906 311.90625 81.273438 L 317.113281 81.660156 C 324.175781 82.1875 327.722656 84.621094 327.34375 89.707031 C 326.910156 95.511719 320.464844 99.601562 310.890625 98.886719 C 303.890625 98.363281 298.875 95.460938 299.257812 90.3125 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,100%,100%);fill-opacity:1;" />
						<path
							 id="path46"
							 d="M 473.050781 130.691406 L 476.570312 135.171875 L 473.707031 138.035156 L 473.855469 138.222656 C 477.453125 138.523438 480.882812 139.492188 483.144531 142.367188 C 485.816406 145.761719 485.777344 148.921875 484.039062 152.046875 C 488.140625 152.40625 491.746094 153.308594 494.046875 156.234375 C 497.902344 161.136719 496.335938 166.035156 490.488281 170.632812 L 475.960938 182.054688 L 471.660156 176.582031 L 485.476562 165.71875 C 489.296875 162.714844 489.824219 160.46875 487.933594 158.0625 C 486.78125 156.601562 484.578125 155.742188 481.234375 155.46875 L 465.058594 168.1875 L 460.796875 162.765625 L 474.613281 151.898438 C 478.433594 148.894531 478.957031 146.652344 477.027344 144.199219 C 475.917969 142.785156 473.675781 141.875 470.332031 141.601562 L 454.15625 154.324219 L 449.894531 148.898438 L 473.050781 130.691406 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,100%,100%);fill-opacity:1;" />
						<path
							 id="path48"
							 d="M 508.691406 333.113281 L 512.269531 337.28125 C 509.683594 339.386719 507.878906 341.550781 507.195312 344.472656 C 506.46875 347.566406 507.585938 349.367188 509.570312 349.835938 C 511.964844 350.398438 513.742188 347.550781 515.625 344.785156 C 517.917969 341.320312 521.078125 337.5625 525.867188 338.6875 C 530.890625 339.867188 533.507812 344.734375 532 351.15625 C 531.066406 355.128906 528.675781 357.957031 526.316406 359.867188 L 522.957031 355.8125 C 524.882812 354.171875 526.355469 352.359375 526.890625 350.082031 C 527.5625 347.21875 526.535156 345.558594 524.722656 345.136719 C 522.445312 344.601562 520.898438 347.257812 519.0625 350.089844 C 516.683594 353.660156 513.800781 357.546875 508.425781 356.285156 C 503.519531 355.132812 500.46875 350.285156 502.167969 343.042969 C 503.085938 339.132812 505.753906 335.382812 508.691406 333.113281 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,100%,100%);fill-opacity:1;" />
						<path
							 id="path50"
							 d="M 77.484375 394.226562 L 75.640625 388.835938 L 79.285156 387.078125 L 79.207031 386.851562 C 75.914062 385.378906 72.996094 383.335938 71.808594 379.871094 C 70.410156 375.785156 71.484375 372.816406 74.160156 370.441406 C 70.410156 368.746094 67.300781 366.703125 66.09375 363.1875 C 64.074219 357.28125 67.171875 353.179688 74.207031 350.769531 L 91.691406 344.78125 L 93.945312 351.367188 L 77.316406 357.0625 C 72.71875 358.636719 71.480469 360.578125 72.472656 363.476562 C 73.074219 365.234375 74.871094 366.773438 77.9375 368.136719 L 97.40625 361.46875 L 99.640625 367.996094 L 83.007812 373.691406 C 78.414062 375.265625 77.175781 377.210938 78.1875 380.160156 C 78.769531 381.863281 80.585938 383.464844 83.652344 384.820312 L 103.117188 378.15625 L 105.355469 384.683594 L 77.484375 394.226562 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,100%,100%);fill-opacity:1;" />
						<path
							 id="path52"
							 d="M 73.742188 321.398438 C 67.863281 322.234375 64.375 325.398438 64.984375 329.679688 C 65.59375 333.953125 69.820312 335.957031 75.699219 335.117188 C 81.523438 334.289062 85.019531 331.183594 84.410156 326.90625 C 83.800781 322.628906 79.566406 320.566406 73.742188 321.398438 Z M 76.699219 342.128906 C 66.957031 343.519531 60.433594 337.722656 59.398438 330.472656 C 58.355469 323.167969 63 315.777344 72.742188 314.386719 C 82.425781 313.003906 88.953125 318.804688 89.992188 326.109375 C 91.027344 333.355469 86.382812 340.746094 76.699219 342.128906 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,100%,100%);fill-opacity:1;" />
						<path
							 id="path54"
							 d="M 79.8125 306.777344 L 45.03125 307.851562 L 44.816406 300.953125 L 79.960938 299.871094 C 81.640625 299.820312 82.214844 299.023438 82.195312 298.300781 C 82.183594 298.003906 82.175781 297.761719 82.039062 297.226562 L 87.171875 296.167969 C 87.558594 296.996094 87.832031 298.1875 87.882812 299.808594 C 88.035156 304.726562 84.910156 306.621094 79.8125 306.777344 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,100%,100%);fill-opacity:1;" />
						<path
							 id="path56"
							 d="M 198.953125 476.394531 L 205.207031 479.449219 L 197.382812 495.460938 L 197.546875 495.539062 L 217.929688 485.664062 L 224.882812 489.0625 L 207.332031 497.515625 L 209.492188 525.214844 L 202.59375 521.84375 L 201.160156 500.574219 L 193.011719 504.410156 L 187.980469 514.707031 L 181.726562 511.652344 L 198.953125 476.394531 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,100%,100%);fill-opacity:1;" />
						<path
							 id="path58"
							 d="M 391.300781 503.335938 L 400.359375 499.046875 L 397.058594 495.300781 C 394.148438 492.097656 391.191406 488.519531 388.3125 485.101562 L 388.097656 485.203125 C 388.992188 489.625 389.863281 494.125 390.496094 498.40625 Z M 382.316406 481.96875 L 389.691406 478.472656 L 418.03125 508.472656 L 411.414062 511.605469 L 404.105469 503.316406 L 392.175781 508.964844 L 393.953125 519.871094 L 387.554688 522.902344 L 382.316406 481.96875 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,100%,100%);fill-opacity:1;" />
						<path
							 id="path60"
							 d="M 169.769531 218.679688 L 172.171875 215.085938 L 180.710938 223.621094 L 180.796875 223.488281 L 177.296875 207.398438 L 179.9375 203.4375 L 183.242188 217.230469 L 199.617188 221.085938 L 197.128906 224.8125 L 183.726562 221.402344 L 185.101562 227.992188 L 191.046875 233.933594 L 188.648438 237.527344 L 169.769531 218.679688 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(22.322083%,20.909119%,21.260071%);fill-opacity:1;" />
						<path
							 id="path62"
							 d="M 207.03125 224.421875 C 204.148438 221.90625 204.265625 218.441406 206.273438 216.140625 C 207.242188 215.035156 208.355469 214.613281 209.453125 214.457031 L 209.910156 216.59375 C 209.105469 216.695312 208.492188 216.933594 208.019531 217.480469 C 206.804688 218.867188 207.101562 220.828125 208.839844 222.351562 C 210.5625 223.855469 212.53125 223.902344 213.714844 222.550781 C 214.296875 221.882812 214.5 220.976562 214.527344 220.132812 L 216.585938 220.472656 C 216.582031 221.894531 216.042969 223.222656 215.183594 224.203125 C 213.125 226.558594 209.894531 226.925781 207.03125 224.421875 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(22.322083%,20.909119%,21.260071%);fill-opacity:1;" />
						<path
							 id="path64"
							 d="M 220.28125 214 L 216.582031 210.148438 C 215.527344 210.195312 214.792969 210.542969 214.238281 211.074219 C 213.179688 212.09375 213.273438 213.910156 214.9375 215.640625 C 216.652344 217.425781 218.246094 217.738281 219.4375 216.589844 C 220.078125 215.976562 220.339844 215.171875 220.28125 214 Z M 212.953125 217.582031 C 210.367188 214.890625 210.484375 211.609375 212.28125 209.882812 C 213.222656 208.976562 214.152344 208.765625 215.324219 208.707031 L 213.980469 207.441406 L 211.105469 204.449219 L 213.039062 202.589844 L 224.445312 214.460938 L 222.847656 215.996094 L 221.859375 215.234375 L 221.789062 215.300781 C 221.765625 216.488281 221.394531 217.78125 220.503906 218.640625 C 218.433594 220.628906 215.570312 220.304688 212.953125 217.582031 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(22.322083%,20.909119%,21.260071%);fill-opacity:1;" />
						<path
							 id="path66"
							 d="M 294.023438 145.214844 L 298.300781 145.234375 L 296.539062 153.546875 L 295.765625 156.382812 L 295.925781 156.382812 C 297.933594 154.671875 300.058594 153.363281 302.417969 153.375 C 305.699219 153.390625 307.050781 155.199219 307.03125 158.355469 C 307.027344 159.277344 306.945312 160.078125 306.699219 161.113281 L 304.15625 173.5 L 299.875 173.476562 L 302.335938 161.652344 C 302.5 160.734375 302.664062 160.175781 302.667969 159.574219 C 302.675781 157.894531 301.878906 157.050781 300.199219 157.042969 C 298.839844 157.035156 297.316406 157.949219 295.226562 160.054688 L 292.519531 173.441406 L 288.199219 173.417969 L 294.023438 145.214844 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(22.322083%,20.909119%,21.260071%);fill-opacity:1;" />
						<path
							 id="path68"
							 d="M 396.144531 209.976562 C 401.679688 205.625 409.238281 206.242188 413.019531 211.054688 C 414.503906 212.941406 414.664062 214.953125 414.324219 216.59375 L 410.796875 216.3125 C 411.046875 214.949219 410.929688 214.023438 410.113281 212.984375 C 407.9375 210.21875 402.828125 210.320312 398.992188 213.335938 C 396.664062 215.164062 396.128906 217.265625 397.761719 219.339844 C 398.703125 220.535156 400.007812 221.03125 401.257812 221.324219 L 400.253906 224.449219 C 398.492188 223.957031 396.3125 223.125 394.484375 220.800781 C 391.8125 217.402344 392.15625 213.117188 396.144531 209.976562 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(22.322083%,20.909119%,21.260071%);fill-opacity:1;" />
						<path
							 id="path70"
							 d="M 422.964844 323.359375 L 433.734375 321.671875 L 442.15625 320.492188 L 442.183594 320.332031 L 434.566406 316.578125 L 424.882812 311.59375 Z M 424.582031 306.476562 L 446.304688 318.410156 L 445.425781 323.820312 L 421.039062 328.195312 L 418.277344 327.742188 L 421.816406 306.027344 L 424.582031 306.476562 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(22.322083%,20.909119%,21.260071%);fill-opacity:1;" />
						<path
							 id="path72"
							 d="M 414.972656 335.429688 L 428.492188 335.417969 C 429.382812 335.417969 430.292969 335.324219 431.222656 335.140625 C 432.148438 334.957031 432.742188 334.476562 433.003906 333.699219 C 433.128906 333.328125 433.183594 332.894531 433.171875 332.398438 L 433.910156 332.355469 L 434.246094 337.601562 L 433.972656 338.414062 L 418.101562 338.5 L 423.253906 343.589844 C 424.175781 344.519531 424.953125 345.089844 425.582031 345.300781 C 426.089844 345.472656 426.832031 345.601562 427.816406 345.699219 C 428.539062 345.761719 429.066406 345.851562 429.398438 345.964844 C 430.621094 346.375 431.007812 347.242188 430.566406 348.558594 C 430.171875 349.734375 429.417969 350.132812 428.308594 349.761719 C 427.210938 349.390625 425.386719 347.871094 422.835938 345.199219 L 414.597656 336.539062 L 414.972656 335.429688 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(22.322083%,20.909119%,21.260071%);fill-opacity:1;" />
						<path
							 id="path74"
							 transform="matrix(0.1,0,0,-0.1,0,595.28)"
							 d="M 4149.726562 2598.503125 L 4284.921875 2598.620313 C 4293.828125 2598.620313 4302.929688 2599.557813 4312.226562 2601.39375 C 4321.484375 2603.229688 4327.421875 2608.034375 4330.039062 2615.807813 C 4331.289062 2619.51875 4331.835938 2623.854688 4331.71875 2628.815625 L 4339.101562 2629.245313 L 4342.460938 2576.784375 L 4339.726562 2568.659375 L 4181.015625 2567.8 L 4232.539062 2516.901563 C 4241.757812 2507.604688 4249.53125 2501.901563 4255.820312 2499.792188 C 4260.898438 2498.073438 4268.320312 2496.784375 4278.164062 2495.807813 C 4285.390625 2495.182813 4290.664062 2494.284375 4293.984375 2493.151563 C 4306.210938 2489.05 4310.078125 2480.378125 4305.664062 2467.214063 C 4301.71875 2455.45625 4294.179688 2451.471875 4283.085938 2455.182813 C 4272.109375 2458.89375 4253.867188 2474.089063 4228.359375 2500.807813 L 4145.976562 2587.409375 Z M 4149.726562 2598.503125 "
							 style="fill:none;stroke-width:5;stroke-linecap:butt;stroke-linejoin:miter;stroke:rgb(22.322083%,20.909119%,21.260071%);stroke-opacity:1;stroke-miterlimit:10;" />
						<path
							 id="path76"
							 d="M 154.769531 343.476562 L 153.640625 339.386719 L 166.898438 330.429688 L 171.929688 327.46875 L 171.886719 327.3125 C 169.21875 327.714844 165.878906 328.386719 162.980469 328.5625 L 150.902344 329.441406 L 149.800781 325.429688 L 176.40625 323.539062 L 177.523438 327.585938 L 164.296875 336.496094 L 159.183594 339.480469 L 159.226562 339.636719 C 162.011719 339.199219 165.179688 338.660156 168.078125 338.484375 L 180.273438 337.574219 L 181.367188 341.546875 L 154.769531 343.476562 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(22.322083%,20.909119%,21.260071%);fill-opacity:1;" />
						<path
							 id="path78"
							 d="M 182.085938 313.910156 L 181.605469 310.042969 L 179.820312 310.804688 C 178.285156 311.488281 176.601562 312.140625 174.988281 312.785156 L 175.003906 312.878906 C 176.742188 313.085938 178.507812 313.316406 180.164062 313.605469 Z M 173.101562 314.617188 L 172.714844 311.472656 L 187.238281 304.671875 L 187.589844 307.496094 L 183.636719 309.179688 L 184.265625 314.273438 L 188.507812 314.949219 L 188.84375 317.679688 L 173.101562 314.617188 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(22.322083%,20.909119%,21.260071%);fill-opacity:1;" />
						<path
							 id="path80"
							 d="M 243.261719 403.507812 L 247.109375 405.386719 L 236.113281 419.78125 L 236.257812 419.851562 L 248.078125 415.433594 L 252.386719 417.539062 L 241.585938 421.609375 L 240.855469 433.761719 L 236.972656 431.863281 L 237.785156 422.558594 L 232.628906 424.355469 L 229.640625 428.28125 L 225.761719 426.386719 L 243.261719 403.507812 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(22.322083%,20.909119%,21.260071%);fill-opacity:1;" />
						<path
							 id="path82"
							 d="M 359.894531 418.46875 C 359.78125 417.945312 359.613281 417.40625 359.339844 416.828125 C 358.519531 415.09375 357.058594 413.882812 354.890625 414.90625 C 352.757812 415.917969 351.480469 418.734375 352.046875 422.183594 Z M 353.941406 411.683594 C 358.0625 409.734375 360.933594 411.871094 362.675781 415.558594 C 363.414062 417.113281 363.675781 418.980469 363.695312 419.679688 L 352.886719 424.792969 C 354.269531 428.742188 357.117188 429.339844 359.792969 428.074219 C 361.058594 427.476562 362.109375 426.140625 362.742188 424.953125 L 365.367188 426.765625 C 364.402344 428.460938 362.714844 430.320312 360.183594 431.519531 C 355.953125 433.519531 351.761719 432.140625 349.503906 427.367188 C 346.371094 420.753906 349.277344 413.890625 353.941406 411.683594 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(22.322083%,20.909119%,21.260071%);fill-opacity:1;" />
					</g>
				</svg>
			</xsl:when>
			<xsl:when test="$si-aspect = 'full' or $si-aspect = ''">
				<svg
					 xmlns:dc="http://purl.org/dc/elements/1.1/"
					 xmlns:cc="http://creativecommons.org/ns#"
					 xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
					 xmlns:svg="http://www.w3.org/2000/svg"
					 xmlns="http://www.w3.org/2000/svg"
					 viewBox="0 0 793.70667 793.70667"
					 height="793.70667"
					 width="793.70667"
					 xml:space="preserve"
					 id="svg2"
					 version="1.1"><metadata
						 id="metadata8"><rdf:RDF><cc:Work
								 rdf:about=""><dc:format>image/svg+xml</dc:format><dc:type
									 rdf:resource="http://purl.org/dc/dcmitype/StillImage" /></cc:Work></rdf:RDF></metadata><defs
						 id="defs6" /><g
						 transform="matrix(1.3333333,0,0,-1.3333333,0,793.70667)"
						 id="g10"><g
							 transform="scale(0.1)"
							 id="g12"><path
								 id="path14"
								 style="fill:#3a2e91;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 2200.47,4489.45 -492.3,1022.27 C 973.336,5143.46 420.902,4465.26 222.191,3648.48 L 1327.98,3396.1 c 121.18,477.04 444.11,873.25 872.49,1093.35" /><path
								 id="path16"
								 style="fill:#f79f0e;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 4677.18,2976.13 c 0,-385.75 -128.61,-741.36 -345.02,-1026.69 l 886.73,-707.15 c 371.14,479.31 592.15,1080.72 592.15,1733.84 0,202.15 -21.32,399.29 -61.55,589.46 L 4643.65,3313.18 c 21.91,-108.96 33.53,-221.64 33.53,-337.05" /><path
								 id="path18"
								 style="fill:#d41938;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 2976.4,5810.77 c -425.67,0 -829.33,-94 -1191.63,-262.1 l 492.3,-1022.28 c 213.37,96.42 449.97,150.53 699.33,150.53 249.36,0 485.93,-54.11 699.3,-150.51 L 4168,5548.68 c -362.28,168.1 -765.93,262.09 -1191.6,262.09" /><path
								 id="path20"
								 style="fill:#f2592d;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="M 4624.81,3396.11 5730.6,3648.49 C 5531.88,4465.28 4979.44,5143.48 4244.59,5511.74 L 3752.3,4489.46 c 428.38,-220.09 751.33,-616.3 872.51,-1093.35" /><path
								 id="path22"
								 style="fill:#a22a9a;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 1275.61,2976.13 c 0,115.41 11.63,228.09 33.54,337.04 L 203.297,3565.58 c -40.227,-190.16 -61.543,-387.31 -61.543,-589.45 0,-653.11 221.016,-1254.52 592.137,-1733.82 l 886.739,707.14 c -216.42,285.34 -345.02,640.94 -345.02,1026.68" /><path
								 id="path24"
								 style="fill:#1a66b5;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="M 2933.86,142.031 V 1276.42 c -505.75,12.46 -956.65,245.33 -1260.13,606.61 L 786.852,1175.77 C 1298.35,554.41 2069.24,154.762 2933.86,142.031" /><path
								 id="path26"
								 style="fill:#57b235;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 3018.9,142.02 c 864.63,12.73 1635.51,412.371 2147.04,1033.73 l -886.89,707.26 C 3975.57,1521.74 3524.66,1288.86 3018.9,1276.42 V 142.02" /><path
								 id="path28"
								 style="fill:#e7807c;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 3675.7,4526.41 c -213.37,96.4 -449.94,150.51 -699.3,150.51 -249.36,0 -485.96,-54.11 -699.33,-150.53 l 699.31,-1452.13 699.32,1452.15" /><path
								 id="path30"
								 style="fill:#cb89cb;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 1309.15,3313.17 c -21.91,-108.95 -33.54,-221.63 -33.54,-337.04 0,-385.74 128.6,-741.34 345.02,-1026.68 l 1260.2,1004.99 -1571.68,358.73" /><path
								 id="path32"
								 style="fill:#aad688;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 3018.9,1276.42 c 505.76,12.44 956.67,245.32 1260.15,606.59 L 3018.9,2887.95 V 1276.42" /><path
								 id="path34"
								 style="fill:#fbcb78;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 4643.65,3313.18 -1571.72,-358.74 1260.23,-1005 c 216.41,285.33 345.02,640.94 345.02,1026.69 0,115.41 -11.62,228.09 -33.53,337.05" /><path
								 id="path36"
								 style="fill:#8d78c3;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="M 2200.47,4489.45 C 1772.09,4269.35 1449.16,3873.14 1327.98,3396.1 l 1571.78,-358.75 -699.29,1452.1" /><path
								 id="path38"
								 style="fill:#f8a67f;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 4624.81,3396.11 c -121.18,477.05 -444.13,873.26 -872.51,1093.35 L 3053,3037.35 4624.81,3396.11" /><path
								 id="path40"
								 style="fill:#83a0d6;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 1673.73,1883.03 c 303.48,-361.28 754.38,-594.15 1260.13,-606.61 V 2887.95 L 1673.73,1883.03" /><path
								 id="path42"
								 style="fill:#ec008c;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 786.852,1175.77 c -18.02,21.88 -35.598,44.11 -52.961,66.54" /><path
								 id="path44"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 3968.53,2976.13 c 0,-547.93 -444.19,-992.12 -992.13,-992.12 -547.94,0 -992.13,444.19 -992.13,992.12 0,547.93 444.19,992.12 992.13,992.12 547.94,0 992.13,-444.19 992.13,-992.12" /><path
								 id="path46"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 2428.12,2585.6 74.8,86.76 c 70.3,-73.3 169.03,-122.66 270.75,-122.66 128.63,0 204.92,64.32 204.92,160.05 0,100.22 -70.31,131.63 -163.05,173.52 l -140.6,61.33 c -92.74,38.89 -198.95,109.19 -198.95,252.79 0,149.58 130.14,260.27 308.15,260.27 116.68,0 219.88,-49.36 290.17,-121.16 l -67.3,-80.78 c -59.83,56.85 -131.62,92.75 -222.87,92.75 -109.2,0 -182.5,-55.35 -182.5,-143.6 0,-94.24 85.27,-130.14 163.04,-163.05 l 139.12,-59.83 c 113.68,-49.36 201.94,-116.67 201.94,-261.77 0,-155.56 -127.15,-279.71 -333.58,-279.71 -137.61,0 -258.77,56.84 -344.04,145.09" /><path
								 id="path48"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 3298.71,3439.71 h 124.16 v -981.26 h -124.16 v 981.26" /><path
								 id="path50"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 1053.94,4174.64 c -80.956,55.92 -88.143,144.75 -43.46,209.41 21.49,31.1 48.68,45.13 76.25,52.32 l 17.93,-53.21 c -20.23,-4.99 -35.17,-12.9 -45.74,-28.2 -26.93,-39 -13.61,-88.32 35.25,-122.08 48.38,-33.42 98.89,-28.93 125.14,9.08 12.97,18.76 15.51,42.51 13.71,64.18 l 53.56,-2.72 c 4.04,-36.35 -5.86,-71.8 -24.96,-99.44 -45.71,-66.15 -127.23,-84.93 -207.68,-29.34" /><path
								 id="path52"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 1390.15,4501.4 -101.76,92.32 c -27.03,-3.01 -45.23,-13.24 -58.53,-27.9 -25.39,-28 -19.75,-74.45 26.03,-115.97 47.09,-42.73 88.54,-47.93 117.17,-16.39 15.31,16.89 20.67,37.96 17.09,67.94 z m -181.8,-104.83 c -71.09,64.51 -73.92,148.89 -30.78,196.44 22.58,24.88 46.02,31.96 76,35.55 l -36.72,30.07 -79.08,71.75 46.35,51.1 313.71,-284.61 -38.3,-42.21 -26.78,17.81 -1.6,-1.78 c 1.46,-30.51 -5.8,-64.42 -27.17,-87.97 -49.59,-54.65 -123.63,-51.45 -195.63,13.85" /><path
								 id="path54"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 2695.74,5510.2 67.65,4.32 16.88,-264.06 1.8,0.12 100.31,142.28 75.45,4.83 -92.93,-126.18 121.89,-167.15 -74.82,-4.79 -83.62,122.71 -42.73,-55.63 4.78,-74.85 -67.65,-4.32 -27.01,422.72" /><path
								 id="path56"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 3187.71,5285.37 c 2.73,36.49 -17.79,59.7 -46.52,61.84 -28.71,2.15 -53.01,-17.1 -55.8,-54.18 -2.82,-37.7 18.32,-60.95 47.03,-63.1 28.12,-2.1 52.48,17.73 55.29,55.44 z m 18.46,-236.05 c 1.7,22.74 -16.37,30.72 -49.87,33.22 l -40.09,3 c -16.16,1.21 -28.64,3.34 -39.77,7.18 -16.46,-10.8 -24.63,-23.43 -25.64,-37.19 -1.98,-26.33 25.58,-44.03 72.26,-47.53 47.27,-3.53 81.21,16.21 83.11,41.32 z m -213.58,0.34 c 1.84,24.53 18.4,44.95 46.58,59.7 l 0.18,2.39 c -14.24,10.68 -24.45,27.09 -22.66,51.02 1.7,22.73 18.73,41.32 36.39,52.04 l 0.18,2.39 c -18.64,16.43 -35.08,45.94 -32.48,80.66 5.05,67.6 62.32,101.23 123.94,96.62 16.17,-1.21 30.9,-5.32 42.56,-10.4 l 105.31,-7.88 -3.81,-50.86 -53.86,4.03 c 8.73,-12.09 14.57,-30.57 13.04,-50.92 -4.88,-65.21 -56.52,-96.25 -118.77,-91.59 -12.55,0.93 -26.73,4.4 -39.49,10.77 -9.57,-7.11 -15.49,-13.89 -16.46,-27.05 -1.25,-16.76 9.94,-27.82 45.84,-30.5 l 52.07,-3.9 c 70.6,-5.27 106.09,-29.59 102.28,-80.45 -4.33,-58.05 -68.77,-98.94 -164.51,-91.8 -70,5.25 -120.18,34.26 -116.33,85.73" /><path
								 id="path58"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 4730.5,4645.88 35.22,-44.81 -28.64,-28.62 1.49,-1.88 c 35.96,-3.02 70.27,-12.68 92.89,-41.45 26.7,-33.96 26.33,-65.52 8.93,-96.77 41.01,-3.62 77.09,-12.64 100.09,-41.88 38.56,-49.04 22.87,-98.01 -35.6,-143.99 l -145.26,-114.22 -43,54.71 138.16,108.65 c 38.2,30.04 43.46,52.48 24.55,76.54 -11.5,14.61 -33.55,23.23 -66.97,25.95 l -161.76,-127.19 -42.64,54.23 138.17,108.65 c 38.2,30.04 43.45,52.49 24.16,77 -11.12,14.15 -33.52,23.24 -66.96,25.96 l -161.75,-127.19 -42.64,54.23 231.56,182.08" /><path
								 id="path60"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 5086.91,2621.67 35.8,-41.69 c -25.88,-21.04 -43.91,-42.69 -50.76,-71.89 -7.27,-30.94 3.9,-48.99 23.77,-53.64 23.94,-5.62 41.72,22.86 60.52,50.48 22.93,34.68 54.56,72.24 102.45,60.99 50.23,-11.8 76.38,-60.45 61.31,-124.7 -9.34,-39.72 -33.23,-68 -56.82,-87.11 l -33.62,40.56 c 19.26,16.43 34.01,34.54 39.34,57.31 6.72,28.62 -3.55,45.21 -21.66,49.46 -22.77,5.35 -38.24,-21.22 -56.62,-49.55 -23.79,-35.71 -52.62,-74.54 -106.35,-61.93 -49.06,11.53 -79.59,59.98 -62.6,132.4 9.2,39.12 35.88,76.61 65.24,99.31" /><path
								 id="path62"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 774.859,2010.54 -18.457,53.92 36.465,17.56 -0.781,2.27 c -32.93,14.72 -62.129,35.16 -73.984,69.78 -14.004,40.87 -3.243,70.57 23.515,94.3 -37.519,16.96 -68.613,37.39 -80.664,72.57 -20.215,59.03 10.762,100.08 81.133,124.18 l 174.824,59.86 22.539,-65.84 -166.289,-56.95 c -45.976,-15.74 -58.34,-35.2 -48.418,-64.15 6.016,-17.59 23.965,-32.99 54.629,-46.6 l 194.688,66.67 22.343,-65.27 -166.308,-56.95 c -45.957,-15.75 -58.34,-35.19 -48.223,-64.71 5.84,-17.02 23.984,-33.01 54.649,-46.6 l 194.67,66.66 22.36,-65.28 -278.691,-95.42" /><path
								 id="path64"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 737.438,2738.83 c -58.809,-8.39 -93.692,-40.03 -87.598,-82.81 6.113,-42.77 48.359,-62.8 107.168,-54.41 58.222,8.29 93.203,39.35 87.09,82.12 -6.094,42.77 -48.438,63.41 -106.66,55.1 z m 29.57,-207.32 c -97.422,-13.9 -162.676,44.07 -173.008,116.56 -10.43,73.06 36.016,146.97 133.438,160.86 96.835,13.82 162.089,-44.17 172.5,-117.23 10.332,-72.47 -36.094,-146.38 -132.93,-160.19" /><path
								 id="path66"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 798.141,2885.01 -347.832,-10.73 -2.129,68.96 351.445,10.84 c 16.777,0.52 22.539,8.5 22.324,15.7 -0.097,2.99 -0.176,5.4 -1.543,10.76 l 51.309,10.59 c 3.867,-8.29 6.621,-20.21 7.129,-36.4 1.504,-49.18 -29.727,-68.15 -80.703,-69.72" /><path
								 id="path68"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 1989.53,1188.86 62.54,-30.54 -78.23,-160.121 1.62,-0.777 203.83,98.748 69.55,-33.99 -175.52,-84.532 21.62,-276.988 -69.01,33.699 -14.31,212.68 -81.51,-38.328 -50.29,-102.969 -62.54,30.547 172.25,352.571" /><path
								 id="path70"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 3913.02,919.441 90.57,42.879 -33.01,37.481 c -29.1,32.009 -58.65,67.809 -87.44,101.979 l -2.17,-1.02 c 8.97,-44.21 17.66,-89.22 24.01,-132.018 z m -89.86,213.689 73.75,34.92 283.4,-299.98 -66.16,-31.32 -73.1,82.902 -119.3,-56.492 17.78,-109.078 -63.99,-30.293 -52.38,409.341" /><path
								 id="path72"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 1697.71,3766 23.98,35.94 85.41,-85.35 0.88,1.33 -35,160.9 26.41,39.6 33.03,-137.93 163.75,-38.55 -24.87,-37.27 -134.02,34.1 13.75,-65.91 59.45,-59.38 -23.98,-35.94 -188.79,188.46" /><path
								 id="path74"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 2070.31,3708.57 c -28.81,25.18 -27.66,59.8 -7.56,82.81 9.67,11.06 20.8,15.28 31.78,16.85 l 4.57,-21.35 c -8.03,-1.04 -14.16,-3.43 -18.91,-8.87 -12.13,-13.88 -9.16,-33.52 8.22,-48.72 17.23,-15.04 36.92,-15.53 48.75,-2.01 5.82,6.68 7.85,15.74 8.13,24.19 l 20.56,-3.42 c -0.03,-14.21 -5.43,-27.47 -14.02,-37.31 -20.58,-23.53 -52.89,-27.19 -81.52,-2.17" /><path
								 id="path76"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 2202.83,3812.8 -37,38.51 c -10.56,-0.45 -17.91,-3.94 -23.45,-9.27 -10.59,-10.18 -9.63,-28.34 7.01,-45.66 17.13,-17.83 33.07,-20.95 45,-9.47 6.41,6.13 9.02,14.17 8.44,25.89 z m -73.28,-35.82 c -25.86,26.9 -24.71,59.71 -6.72,77 9.41,9.04 18.69,11.17 30.43,11.76 l -13.44,12.64 -28.77,29.93 19.34,18.58 114.08,-118.71 -15.98,-15.36 -9.9,7.63 -0.68,-0.65 c -0.24,-11.87 -3.95,-24.83 -12.88,-33.39 -20.68,-19.88 -49.31,-16.67 -75.48,10.57" /><path
								 id="path78"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 2940.23,4500.67 42.79,-0.22 -17.63,-83.11 -7.74,-28.35 h 1.6 c 20.08,17.09 41.35,30.18 64.94,30.06 32.8,-0.17 46.31,-18.23 46.14,-49.82 -0.04,-9.2 -0.88,-17.2 -3.34,-27.58 l -25.43,-123.85 -42.8,0.21 24.61,118.26 c 1.64,9.19 3.28,14.78 3.3,20.78 0.08,16.8 -7.87,25.23 -24.66,25.32 -13.6,0.07 -28.83,-9.05 -49.75,-30.14 l -27.07,-133.83 -43.18,0.21 58.22,282.06" /><path
								 id="path80"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 3961.46,3853.03 c 55.33,43.51 130.94,37.33 168.75,-10.77 14.84,-18.86 16.43,-38.98 13.03,-55.38 l -35.26,2.79 c 2.48,13.65 1.31,22.91 -6.83,33.28 -21.76,27.66 -72.85,26.66 -111.21,-3.51 -23.29,-18.29 -28.64,-39.3 -12.31,-60.05 9.4,-11.94 22.46,-16.92 34.94,-19.84 l -10.02,-31.27 c -17.63,4.96 -39.41,13.26 -57.71,36.53 -26.72,33.95 -23.28,76.82 16.62,108.22" /><path
								 id="path82"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 4229.64,2719.2 107.72,16.89 84.22,11.8 0.25,1.58 -76.15,37.55 -96.86,49.83 z m 16.18,168.81 217.24,-119.33 -8.81,-54.08 -243.85,-43.75 -27.63,4.5 35.41,217.17 27.64,-4.51" /><path
								 id="path84"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 4149.72,2598.5 135.2,0.12 c 8.92,0.01 18.02,0.93 27.3,2.76 9.28,1.84 15.22,6.63 17.81,14.41 1.25,3.71 1.82,8.05 1.7,13.04 l 7.37,0.41 3.38,-52.45 -2.74,-8.14 -158.73,-0.85 51.52,-50.9 c 9.24,-9.29 17.02,-14.99 23.3,-17.1 5.06,-1.71 12.5,-3.04 22.35,-4.01 7.21,-0.63 12.48,-1.51 15.8,-2.63 12.23,-4.1 16.11,-12.77 11.68,-25.97 -3.95,-11.72 -11.47,-15.73 -22.58,-12 -10.98,3.7 -29.22,18.9 -54.73,45.61 l -82.38,86.59 3.75,11.11" /><path
								 id="path86"
								 style="fill:none;stroke:#393536;stroke-width:5;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:10;stroke-dasharray:none;stroke-opacity:1"
								 d="m 4149.72,2598.5 135.2,0.12 c 8.92,0.01 18.02,0.93 27.3,2.76 9.28,1.84 15.22,6.63 17.81,14.41 1.25,3.71 1.82,8.05 1.7,13.04 l 7.37,0.41 3.38,-52.45 -2.74,-8.14 -158.73,-0.85 51.52,-50.9 c 9.24,-9.29 17.02,-14.99 23.3,-17.1 5.06,-1.71 12.5,-3.04 22.35,-4.01 7.21,-0.63 12.48,-1.51 15.8,-2.63 12.23,-4.1 16.11,-12.77 11.68,-25.97 -3.95,-11.72 -11.47,-15.73 -22.58,-12 -10.98,3.7 -29.22,18.9 -54.73,45.61 l -82.38,86.59 z" /><path
								 id="path88"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 1547.69,2518.04 -11.27,40.88 132.56,89.59 50.33,29.62 -0.43,1.54 c -26.68,-4.03 -60.08,-10.74 -89.06,-12.5 l -120.78,-8.77 -11.04,40.1 266.08,18.92 11.15,-40.49 -132.27,-89.11 -51.11,-29.83 0.43,-1.54 c 27.83,4.35 59.53,9.76 88.5,11.52 l 121.95,9.09 10.94,-39.71 -265.98,-19.31" /><path
								 id="path90"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 1820.83,2813.71 -4.76,38.65 -17.87,-7.6 c -15.35,-6.84 -32.17,-13.37 -48.3,-19.83 l 0.13,-0.92 c 17.39,-2.08 35.06,-4.37 51.63,-7.25 z m -89.8,-7.09 -3.91,31.47 145.28,67.98 3.49,-28.23 -39.51,-16.86 6.29,-50.9 42.42,-6.76 3.36,-27.31 -157.42,30.61" /><path
								 id="path92"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 2432.63,1917.71 38.46,-18.79 -109.96,-143.92 1.44,-0.71 118.21,44.18 43.1,-21.07 -108.03,-40.69 -7.3,-121.54 -38.83,18.98 8.13,93.08 -51.55,-17.99 -29.88,-39.26 -38.81,18.97 175.02,228.76" /><path
								 id="path94"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 3598.94,1768.11 c -1.13,5.22 -2.81,10.62 -5.55,16.4 -8.2,17.36 -22.79,29.48 -44.49,19.22 -21.33,-10.1 -34.1,-38.26 -28.42,-72.75 z m -59.53,67.85 c 41.21,19.51 69.92,-1.87 87.36,-38.75 7.37,-15.54 10,-34.2 10.2,-41.2 l -108.11,-51.15 c 13.83,-39.48 42.33,-45.47 69.08,-32.81 12.66,5.98 23.15,19.36 29.48,31.21 l 26.27,-18.11 c -9.67,-16.96 -26.53,-35.56 -51.86,-47.54 -42.3,-20.02 -84.22,-6.23 -106.8,41.5 -31.3,66.17 -2.26,134.78 44.38,156.85" /></g></g></svg>
			</xsl:when>
			<xsl:when test="$si-aspect = 'k_k_deltanu'">
				<svg
					 xmlns:dc="http://purl.org/dc/elements/1.1/"
					 xmlns:cc="http://creativecommons.org/ns#"
					 xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
					 xmlns:svg="http://www.w3.org/2000/svg"
					 xmlns="http://www.w3.org/2000/svg"
					 viewBox="0 0 793.70667 793.70667"
					 height="793.70667"
					 width="793.70667"
					 xml:space="preserve"
					 id="svg2"
					 version="1.1"><metadata
						 id="metadata8"><rdf:RDF><cc:Work
								 rdf:about=""><dc:format>image/svg+xml</dc:format><dc:type
									 rdf:resource="http://purl.org/dc/dcmitype/StillImage" /></cc:Work></rdf:RDF></metadata><defs
						 id="defs6" /><g
						 transform="matrix(1.3333333,0,0,-1.3333333,0,793.70667)"
						 id="g10"><g
							 transform="scale(0.1)"
							 id="g12"><path
								 id="path14"
								 style="fill:#bdbcbc;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 2200.47,4489.45 -492.3,1022.27 C 973.336,5143.46 420.906,4465.25 222.195,3648.49 L 1327.98,3396.1 c 121.17,477.04 444.11,873.25 872.49,1093.35" /><path
								 id="path16"
								 style="fill:#bdbcbc;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 4677.18,2976.13 c 0,-385.75 -128.6,-741.35 -345.02,-1026.7 l 886.73,-707.15 c 371.14,479.32 592.15,1080.74 592.15,1733.85 0,202.15 -21.32,399.29 -61.55,589.46 L 4643.66,3313.18 c 21.9,-108.96 33.52,-221.64 33.52,-337.05" /><path
								 id="path18"
								 style="fill:#bdbcbc;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 2976.4,5810.78 c -425.67,0 -829.34,-94.01 -1191.63,-262.11 l 492.29,-1022.28 c 213.38,96.42 449.97,150.52 699.34,150.52 249.36,0 485.93,-54.1 699.3,-150.5 L 4168,5548.68 c -362.28,168.09 -765.94,262.1 -1191.6,262.1" /><path
								 id="path20"
								 style="fill:#bdbcbc;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 4624.82,3396.1 1105.77,252.4 c -198.71,816.77 -751.14,1494.98 -1486,1863.24 L 3752.3,4489.46 c 428.39,-220.09 751.34,-616.3 872.52,-1093.36" /><path
								 id="path22"
								 style="fill:#bdbcbc;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 1275.61,2976.13 c 0,115.41 11.63,228.09 33.53,337.04 L 203.301,3565.58 c -40.227,-190.17 -61.543,-387.3 -61.543,-589.45 0,-653.11 221.015,-1254.52 592.133,-1733.83 l 886.739,707.15 c -216.42,285.34 -345.02,640.94 -345.02,1026.68" /><path
								 id="path24"
								 style="fill:#1a66b5;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="M 2933.86,142.031 V 1276.42 c -505.75,12.46 -956.65,245.33 -1260.14,606.61 L 786.848,1175.77 C 1298.35,554.398 2069.24,154.762 2933.86,142.031" /><path
								 id="path26"
								 style="fill:#bdbcbc;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 3018.9,142.031 c 864.63,12.719 1635.52,412.36 2147.04,1033.719 l -886.88,707.26 C 3975.57,1521.73 3524.66,1288.86 3018.9,1276.42 V 142.031" /><path
								 id="path28"
								 style="fill:#e7807c;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 3675.7,4526.41 c -213.37,96.4 -449.94,150.5 -699.3,150.5 -249.37,0 -485.96,-54.1 -699.34,-150.52 l 699.32,-1452.13 699.32,1452.15" /><path
								 id="path30"
								 style="fill:#deddde;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 1309.14,3313.17 c -21.9,-108.95 -33.53,-221.63 -33.53,-337.04 0,-385.74 128.6,-741.34 345.02,-1026.68 l 1260.2,1004.99 -1571.69,358.73" /><path
								 id="path32"
								 style="fill:#deddde;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 3018.9,1276.42 c 505.76,12.44 956.67,245.31 1260.16,606.59 L 3018.9,2887.95 V 1276.42" /><path
								 id="path34"
								 style="fill:#fbcb78;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="M 4643.66,3313.18 3071.93,2954.44 4332.16,1949.43 c 216.42,285.35 345.02,640.95 345.02,1026.7 0,115.41 -11.62,228.09 -33.52,337.05" /><path
								 id="path36"
								 style="fill:#deddde;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="M 2200.47,4489.45 C 1772.09,4269.35 1449.15,3873.14 1327.98,3396.1 l 1571.78,-358.75 -699.29,1452.1" /><path
								 id="path38"
								 style="fill:#deddde;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 4624.82,3396.1 c -121.18,477.06 -444.13,873.27 -872.52,1093.36 L 3053,3037.35 4624.82,3396.1" /><path
								 id="path40"
								 style="fill:#83a0d6;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 1673.72,1883.03 c 303.49,-361.28 754.39,-594.15 1260.14,-606.61 V 2887.95 L 1673.72,1883.03" /><path
								 id="path42"
								 style="fill:#ec008c;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 786.848,1175.77 c -18.016,21.88 -35.594,44.11 -52.957,66.53" /><path
								 id="path44"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 3968.52,2976.13 c 0,-547.94 -444.19,-992.13 -992.12,-992.13 -547.93,0 -992.12,444.19 -992.12,992.13 0,547.94 444.19,992.13 992.12,992.13 547.93,0 992.12,-444.19 992.12,-992.13" /><path
								 id="path46"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 2428.12,2585.6 74.8,86.76 c 70.3,-73.3 169.03,-122.66 270.75,-122.66 128.63,0 204.92,64.32 204.92,160.06 0,100.22 -70.31,131.63 -163.05,173.51 l -140.6,61.33 c -92.74,38.89 -198.95,109.19 -198.95,252.79 0,149.58 130.14,260.28 308.14,260.28 116.68,0 219.89,-49.37 290.18,-121.17 l -67.3,-80.77 c -59.83,56.84 -131.63,92.74 -222.88,92.74 -109.19,0 -182.5,-55.35 -182.5,-143.6 0,-94.24 85.28,-130.13 163.05,-163.04 l 139.12,-59.84 c 113.67,-49.36 201.94,-116.67 201.94,-261.77 0,-155.56 -127.15,-279.71 -333.58,-279.71 -137.62,0 -258.77,56.84 -344.04,145.09" /><path
								 id="path48"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 3298.7,3439.72 h 124.16 V 2458.46 H 3298.7 v 981.26" /><path
								 id="path50"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 1053.94,4174.64 c -80.96,55.93 -88.143,144.75 -43.46,209.41 21.49,31.1 48.67,45.13 76.25,52.33 l 17.93,-53.22 c -20.23,-4.99 -35.17,-12.9 -45.74,-28.2 -26.93,-39 -13.61,-88.31 35.25,-122.07 48.38,-33.43 98.89,-28.94 125.14,9.07 12.97,18.76 15.51,42.51 13.71,64.18 l 53.56,-2.72 c 4.04,-36.35 -5.86,-71.8 -24.97,-99.44 -45.7,-66.15 -127.22,-84.93 -207.67,-29.34" /><path
								 id="path52"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 1390.15,4501.41 -101.76,92.31 c -27.03,-3.01 -45.23,-13.24 -58.53,-27.9 -25.39,-28 -19.75,-74.44 26.03,-115.97 47.09,-42.73 88.54,-47.93 117.17,-16.38 15.31,16.88 20.66,37.95 17.09,67.94 z m -181.8,-104.83 c -71.09,64.5 -73.92,148.88 -30.78,196.43 22.58,24.88 46.02,31.97 76,35.55 l -36.72,30.07 -79.08,71.76 46.34,51.09 313.72,-284.61 -38.3,-42.21 -26.78,17.81 -1.6,-1.78 c 1.46,-30.5 -5.8,-64.42 -27.17,-87.97 -49.59,-54.65 -123.63,-51.45 -195.63,13.86" /><path
								 id="path54"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 2695.74,5510.2 67.65,4.32 16.88,-264.05 1.79,0.12 100.32,142.27 75.45,4.83 -92.93,-126.18 121.89,-167.15 -74.82,-4.79 -83.62,122.72 -42.73,-55.64 4.78,-74.85 -67.65,-4.32 -27.01,422.72" /><path
								 id="path56"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 3187.71,5285.37 c 2.73,36.5 -17.79,59.7 -46.52,61.84 -28.72,2.16 -53.01,-17.1 -55.81,-54.18 -2.81,-37.7 18.32,-60.94 47.04,-63.1 28.12,-2.1 52.48,17.74 55.29,55.44 z m 18.46,-236.04 c 1.69,22.73 -16.37,30.71 -49.87,33.21 l -40.1,3 c -16.15,1.21 -28.63,3.34 -39.76,7.18 -16.47,-10.8 -24.63,-23.43 -25.65,-37.19 -1.97,-26.33 25.59,-44.03 72.27,-47.52 47.27,-3.54 81.21,16.2 83.11,41.32 z m -213.58,0.33 c 1.84,24.53 18.4,44.95 46.58,59.7 l 0.18,2.39 c -14.24,10.68 -24.45,27.1 -22.66,51.02 1.7,22.74 18.73,41.33 36.39,52.05 l 0.18,2.39 c -18.64,16.42 -35.08,45.93 -32.48,80.65 5.05,67.6 62.32,101.23 123.94,96.62 16.17,-1.21 30.9,-5.32 42.56,-10.4 l 105.31,-7.87 -3.81,-50.87 -53.86,4.04 c 8.73,-12.09 14.57,-30.58 13.04,-50.93 -4.88,-65.21 -56.52,-96.24 -118.77,-91.59 -12.56,0.93 -26.74,4.4 -39.49,10.77 -9.57,-7.11 -15.49,-13.88 -16.46,-27.05 -1.25,-16.75 9.94,-27.82 45.84,-30.5 l 52.07,-3.89 c 70.6,-5.28 106.09,-29.59 102.28,-80.46 -4.33,-58.04 -68.77,-98.94 -164.51,-91.79 -70,5.24 -120.18,34.26 -116.33,85.72" /><path
								 id="path58"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 4730.5,4645.88 35.22,-44.81 -28.64,-28.61 1.49,-1.89 c 35.96,-3.02 70.27,-12.68 92.89,-41.45 26.7,-33.95 26.33,-65.52 8.92,-96.77 41.02,-3.62 77.09,-12.63 100.1,-41.88 38.56,-49.03 22.87,-98.01 -35.6,-143.99 l -145.26,-114.21 -43.01,54.7 138.17,108.65 c 38.2,30.04 43.46,52.49 24.55,76.54 -11.5,14.62 -33.55,23.24 -66.97,25.95 l -161.76,-127.19 -42.64,54.24 138.17,108.64 c 38.2,30.04 43.45,52.49 24.16,77.01 -11.12,14.14 -33.52,23.23 -66.96,25.96 l -161.75,-127.2 -42.64,54.23 231.56,182.08" /><path
								 id="path60"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 5086.91,2621.67 35.8,-41.69 c -25.88,-21.03 -43.91,-42.69 -50.76,-71.88 -7.27,-30.95 3.9,-48.99 23.77,-53.65 23.94,-5.62 41.72,22.86 60.52,50.49 22.93,34.67 54.55,72.24 102.45,60.98 50.23,-11.79 76.38,-60.45 61.3,-124.7 -9.33,-39.72 -33.22,-68 -56.81,-87.11 l -33.62,40.56 c 19.26,16.43 34.01,34.54 39.34,57.31 6.72,28.63 -3.55,45.22 -21.66,49.47 -22.77,5.35 -38.24,-21.23 -56.62,-49.56 -23.79,-35.71 -52.62,-74.54 -106.35,-61.93 -49.06,11.53 -79.59,59.98 -62.6,132.4 9.2,39.12 35.88,76.61 65.24,99.31" /><path
								 id="path62"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 774.855,2010.55 -18.457,53.91 36.465,17.56 -0.777,2.28 c -32.934,14.71 -62.133,35.15 -73.988,69.77 -14.004,40.87 -3.243,70.57 23.515,94.3 -37.519,16.96 -68.609,37.39 -80.664,72.57 -20.215,59.04 10.766,100.08 81.137,124.18 l 174.82,59.87 22.539,-65.84 -166.289,-56.96 c -45.976,-15.74 -58.34,-35.19 -48.418,-64.14 6.02,-17.6 23.965,-33 54.629,-46.6 l 194.688,66.66 22.343,-65.27 -166.304,-56.95 c -45.957,-15.74 -58.34,-35.19 -48.227,-64.71 5.844,-17.02 23.985,-33.01 54.649,-46.6 l 194.674,66.66 22.36,-65.27 -278.695,-95.42" /><path
								 id="path64"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 737.434,2738.83 c -58.805,-8.39 -93.692,-40.03 -87.594,-82.8 6.109,-42.78 48.355,-62.81 107.168,-54.42 58.219,8.3 93.203,39.35 87.086,82.12 -6.09,42.77 -48.438,63.41 -106.66,55.1 z m 29.574,-207.32 c -97.422,-13.9 -162.68,44.08 -173.012,116.56 -10.43,73.06 36.016,146.97 133.438,160.86 96.836,13.82 162.089,-44.16 172.5,-117.23 10.332,-72.47 -36.09,-146.38 -132.926,-160.19" /><path
								 id="path66"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 798.137,2885.01 -347.832,-10.72 -2.129,68.96 351.449,10.84 c 16.773,0.51 22.535,8.49 22.32,15.69 -0.097,2.99 -0.175,5.4 -1.543,10.76 l 51.313,10.59 c 3.863,-8.28 6.621,-20.21 7.129,-36.4 1.5,-49.18 -29.731,-68.15 -80.707,-69.72" /><path
								 id="path68"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 1989.53,1188.87 62.53,-30.55 -78.22,-160.121 1.62,-0.777 203.83,98.748 69.55,-33.98 -175.53,-84.53 21.63,-277 -69.01,33.699 -14.32,212.68 -81.5,-38.328 -50.29,-102.969 -62.54,30.547 172.25,352.581" /><path
								 id="path70"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 3913.02,919.441 90.57,42.879 -33.01,37.481 c -29.1,32.019 -58.65,67.819 -87.44,101.989 l -2.17,-1.03 c 8.97,-44.21 17.66,-89.22 24,-132.018 z m -89.86,213.689 73.75,34.93 283.4,-299.978 -66.16,-31.332 -73.1,82.902 -119.3,-56.492 17.78,-109.078 -63.99,-30.293 -52.38,409.341" /><path
								 id="path72"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 1697.71,3766 23.98,35.94 85.41,-85.35 0.88,1.33 -35,160.9 26.41,39.6 33.03,-137.93 163.75,-38.55 -24.87,-37.27 -134.02,34.1 13.75,-65.91 59.45,-59.38 -23.98,-35.94 -188.79,188.46" /><path
								 id="path74"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 2070.31,3708.57 c -28.81,25.18 -27.66,59.8 -7.56,82.81 9.67,11.07 20.8,15.28 31.78,16.85 l 4.57,-21.35 c -8.03,-1.04 -14.16,-3.43 -18.91,-8.87 -12.13,-13.88 -9.16,-33.51 8.22,-48.71 17.23,-15.05 36.92,-15.54 48.75,-2.02 5.82,6.68 7.85,15.74 8.13,24.19 l 20.56,-3.41 c -0.04,-14.22 -5.43,-27.48 -14.02,-37.31 -20.59,-23.54 -52.89,-27.2 -81.52,-2.18" /><path
								 id="path76"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 2202.83,3812.8 -37,38.51 c -10.56,-0.45 -17.91,-3.94 -23.45,-9.27 -10.59,-10.18 -9.63,-28.34 7.01,-45.66 17.13,-17.83 33.06,-20.95 45,-9.47 6.4,6.14 9.02,14.17 8.44,25.89 z m -73.29,-35.82 c -25.85,26.91 -24.7,59.71 -6.71,77 9.41,9.05 18.69,11.17 30.43,11.76 l -13.44,12.64 -28.77,29.93 19.33,18.58 114.09,-118.71 -15.98,-15.35 -9.9,7.62 -0.69,-0.65 c -0.23,-11.87 -3.94,-24.82 -12.87,-33.39 -20.68,-19.88 -49.31,-16.67 -75.49,10.57" /><path
								 id="path78"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 2940.23,4500.67 42.79,-0.22 -17.64,-83.11 -7.73,-28.35 h 1.6 c 20.08,17.09 41.35,30.18 64.94,30.06 32.8,-0.17 46.31,-18.23 46.14,-49.82 -0.04,-9.2 -0.88,-17.2 -3.34,-27.58 l -25.43,-123.85 -42.8,0.22 24.61,118.25 c 1.64,9.19 3.28,14.78 3.3,20.78 0.08,16.8 -7.87,25.23 -24.66,25.32 -13.6,0.07 -28.83,-9.05 -49.75,-30.13 l -27.07,-133.84 -43.18,0.21 58.22,282.06" /><path
								 id="path80"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 3961.46,3853.03 c 55.33,43.51 130.94,37.33 168.75,-10.76 14.84,-18.87 16.42,-38.99 13.03,-55.39 l -35.26,2.79 c 2.48,13.65 1.31,22.91 -6.83,33.28 -21.76,27.66 -72.86,26.66 -111.21,-3.51 -23.29,-18.29 -28.64,-39.29 -12.31,-60.05 9.4,-11.94 22.46,-16.92 34.94,-19.83 l -10.02,-31.27 c -17.63,4.95 -39.41,13.25 -57.71,36.52 -26.72,33.95 -23.28,76.82 16.62,108.22" /><path
								 id="path82"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 4229.64,2719.2 107.72,16.89 84.22,11.81 0.25,1.57 -76.15,37.56 -96.86,49.83 z m 16.17,168.82 217.25,-119.33 -8.81,-54.09 -243.85,-43.75 -27.63,4.51 35.41,217.16 27.63,-4.5" /><path
								 id="path84"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 4149.72,2598.51 135.2,0.11 c 8.92,0.01 18.02,0.93 27.3,2.77 9.28,1.83 15.22,6.63 17.81,14.41 1.25,3.7 1.82,8.04 1.7,13.03 l 7.37,0.41 3.37,-52.44 -2.73,-8.15 -158.73,-0.85 51.52,-50.9 c 9.24,-9.28 17.01,-14.99 23.3,-17.1 5.06,-1.7 12.5,-3.03 22.35,-4.01 7.2,-0.62 12.48,-1.5 15.8,-2.63 12.22,-4.1 16.11,-12.76 11.68,-25.96 -3.95,-11.73 -11.47,-15.74 -22.58,-12 -10.98,3.69 -29.22,18.89 -54.73,45.6 l -82.38,86.59 3.75,11.12" /><path
								 id="path86"
								 style="fill:none;stroke:#393536;stroke-width:5;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:10;stroke-dasharray:none;stroke-opacity:1"
								 d="m 4149.72,2598.51 135.2,0.11 c 8.92,0.01 18.02,0.93 27.3,2.77 9.28,1.83 15.22,6.63 17.81,14.41 1.25,3.7 1.82,8.04 1.7,13.03 l 7.37,0.41 3.37,-52.44 -2.73,-8.15 -158.73,-0.85 51.52,-50.9 c 9.24,-9.28 17.01,-14.99 23.3,-17.1 5.06,-1.7 12.5,-3.03 22.35,-4.01 7.2,-0.62 12.48,-1.5 15.8,-2.63 12.22,-4.1 16.11,-12.76 11.68,-25.96 -3.95,-11.73 -11.47,-15.74 -22.58,-12 -10.98,3.69 -29.22,18.89 -54.73,45.6 l -82.38,86.59 z" /><path
								 id="path88"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 1547.69,2518.04 -11.27,40.88 132.56,89.59 50.33,29.62 -0.43,1.54 c -26.68,-4.03 -60.08,-10.74 -89.06,-12.49 l -120.78,-8.78 -11.04,40.1 266.08,18.92 11.15,-40.49 -132.27,-89.1 -51.11,-29.84 0.43,-1.54 c 27.83,4.36 59.53,9.77 88.5,11.52 l 121.95,9.09 10.94,-39.71 -265.98,-19.31" /><path
								 id="path90"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 1820.83,2813.72 -4.76,38.64 -17.87,-7.6 c -15.35,-6.84 -32.17,-13.36 -48.3,-19.82 l 0.13,-0.93 c 17.39,-2.08 35.06,-4.37 51.62,-7.25 z m -89.8,-7.1 -3.91,31.48 145.28,67.97 3.49,-28.22 -39.51,-16.86 6.29,-50.91 42.42,-6.76 3.36,-27.3 -157.42,30.6" /><path
								 id="path92"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 2432.63,1917.71 38.46,-18.78 -109.96,-143.93 1.44,-0.7 118.21,44.18 43.1,-21.08 -108.03,-40.69 -7.3,-121.53 -38.83,18.97 8.13,93.09 -51.55,-18 -29.88,-39.26 -38.81,18.97 175.02,228.76" /><path
								 id="path94"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 3598.94,1768.11 c -1.13,5.22 -2.81,10.62 -5.55,16.4 -8.2,17.36 -22.79,29.48 -44.49,19.22 -21.33,-10.1 -34.1,-38.26 -28.42,-72.74 z m -59.53,67.86 c 41.21,19.5 69.92,-1.88 87.36,-38.75 7.36,-15.55 10,-34.21 10.2,-41.2 l -108.11,-51.16 c 13.83,-39.48 42.33,-45.47 69.08,-32.81 12.66,5.99 23.15,19.37 29.48,31.21 l 26.27,-18.1 c -9.67,-16.97 -26.53,-35.57 -51.86,-47.54 -42.3,-20.02 -84.22,-6.23 -106.8,41.49 -31.31,66.17 -2.26,134.79 44.38,156.86" /></g></g></svg>
			</xsl:when>
			<xsl:when test="$si-aspect = 'k_k'">
				<svg
				 xmlns:dc="http://purl.org/dc/elements/1.1/"
				 xmlns:cc="http://creativecommons.org/ns#"
				 xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
				 xmlns:svg="http://www.w3.org/2000/svg"
				 xmlns="http://www.w3.org/2000/svg"
				 viewBox="0 0 793.70667 793.70667"
				 height="793.70667"
				 width="793.70667"
				 xml:space="preserve"
				 id="svg2"
				 version="1.1"><metadata
					 id="metadata8"><rdf:RDF><cc:Work
							 rdf:about=""><dc:format>image/svg+xml</dc:format><dc:type
								 rdf:resource="http://purl.org/dc/dcmitype/StillImage" /></cc:Work></rdf:RDF></metadata><defs
					 id="defs6" /><g
					 transform="matrix(1.3333333,0,0,-1.3333333,0,793.70667)"
					 id="g10"><g
						 transform="scale(0.1)"
						 id="g12"><path
							 id="path14"
							 style="fill:#bdbcbc;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 2200.47,4489.45 -492.3,1022.27 C 973.336,5143.46 420.906,4465.26 222.195,3648.49 L 1327.98,3396.1 c 121.17,477.04 444.11,873.25 872.49,1093.35" /><path
							 id="path16"
							 style="fill:#bdbcbc;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 4677.18,2976.13 c 0,-385.75 -128.6,-741.36 -345.02,-1026.69 l 886.73,-707.16 c 371.14,479.32 592.15,1080.74 592.15,1733.85 0,202.15 -21.32,399.29 -61.55,589.46 L 4643.66,3313.18 c 21.9,-108.96 33.52,-221.64 33.52,-337.05" /><path
							 id="path18"
							 style="fill:#bdbcbc;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 2976.4,5810.78 c -425.67,0 -829.34,-94.01 -1191.63,-262.11 L 2277.06,4526.4 c 213.38,96.41 449.97,150.52 699.34,150.52 249.36,0 485.93,-54.11 699.3,-150.51 L 4168,5548.68 c -362.28,168.09 -765.94,262.1 -1191.6,262.1" /><path
							 id="path20"
							 style="fill:#bdbcbc;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 4624.82,3396.1 1105.77,252.4 c -198.71,816.78 -751.14,1494.98 -1486,1863.24 L 3752.3,4489.46 c 428.39,-220.09 751.34,-616.3 872.52,-1093.36" /><path
							 id="path22"
							 style="fill:#bdbcbc;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 1275.61,2976.13 c 0,115.41 11.63,228.09 33.53,337.04 L 203.301,3565.58 c -40.227,-190.17 -61.543,-387.3 -61.543,-589.45 0,-653.1 221.015,-1254.52 592.133,-1733.83 l 886.739,707.15 c -216.42,285.34 -345.02,640.94 -345.02,1026.68" /><path
							 id="path24"
							 style="fill:#1a66b5;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="M 2933.86,142.031 V 1276.42 c -505.75,12.46 -956.65,245.33 -1260.14,606.61 L 786.848,1175.77 C 1298.35,554.398 2069.24,154.762 2933.86,142.031" /><path
							 id="path26"
							 style="fill:#bdbcbc;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 3018.9,142.02 c 864.63,12.73 1635.52,412.371 2147.04,1033.73 l -886.88,707.27 C 3975.57,1521.73 3524.66,1288.86 3018.9,1276.42 V 142.02" /><path
							 id="path28"
							 style="fill:#deddde;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 3675.7,4526.41 c -213.37,96.4 -449.94,150.51 -699.3,150.51 -249.37,0 -485.96,-54.11 -699.34,-150.52 l 699.32,-1452.14 699.32,1452.15" /><path
							 id="path30"
							 style="fill:#deddde;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 1309.14,3313.17 c -21.9,-108.95 -33.53,-221.63 -33.53,-337.04 0,-385.74 128.6,-741.34 345.02,-1026.68 l 1260.2,1004.99 -1571.69,358.73" /><path
							 id="path32"
							 style="fill:#deddde;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 3018.9,1276.42 c 505.76,12.44 956.67,245.31 1260.16,606.6 L 3018.9,2887.95 V 1276.42" /><path
							 id="path34"
							 style="fill:#deddde;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 4643.66,3313.18 -1571.73,-358.74 1260.23,-1005 c 216.42,285.33 345.02,640.94 345.02,1026.69 0,115.41 -11.62,228.09 -33.52,337.05" /><path
							 id="path36"
							 style="fill:#deddde;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="M 2200.47,4489.45 C 1772.09,4269.35 1449.15,3873.14 1327.98,3396.1 l 1571.78,-358.75 -699.29,1452.1" /><path
							 id="path38"
							 style="fill:#deddde;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 4624.82,3396.1 c -121.18,477.06 -444.13,873.27 -872.52,1093.36 L 3053,3037.35 4624.82,3396.1" /><path
							 id="path40"
							 style="fill:#83a0d6;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 1673.72,1883.03 c 303.49,-361.28 754.39,-594.15 1260.14,-606.61 V 2887.95 L 1673.72,1883.03" /><path
							 id="path42"
							 style="fill:#ec008c;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 786.848,1175.77 c -18.016,21.87 -35.594,44.11 -52.957,66.53" /><path
							 id="path44"
							 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 3968.52,2976.13 c 0,-547.93 -444.19,-992.12 -992.12,-992.12 -547.93,0 -992.12,444.19 -992.12,992.12 0,547.94 444.19,992.13 992.12,992.13 547.93,0 992.12,-444.19 992.12,-992.13" /><path
							 id="path46"
							 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 2428.12,2585.6 74.8,86.76 c 70.3,-73.3 169.03,-122.66 270.75,-122.66 128.63,0 204.92,64.32 204.92,160.05 0,100.22 -70.31,131.64 -163.05,173.52 l -140.6,61.33 c -92.74,38.89 -198.95,109.19 -198.95,252.79 0,149.58 130.14,260.28 308.14,260.28 116.68,0 219.89,-49.37 290.18,-121.17 l -67.3,-80.77 c -59.83,56.84 -131.63,92.74 -222.88,92.74 -109.19,0 -182.5,-55.35 -182.5,-143.6 0,-94.24 85.28,-130.13 163.05,-163.04 l 139.12,-59.84 c 113.67,-49.36 201.94,-116.67 201.94,-261.77 0,-155.56 -127.15,-279.71 -333.58,-279.71 -137.62,0 -258.77,56.84 -344.04,145.09" /><path
							 id="path48"
							 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 3298.7,3439.72 h 124.16 V 2458.46 H 3298.7 v 981.26" /><path
							 id="path50"
							 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 1053.94,4174.64 c -80.96,55.93 -88.143,144.75 -43.46,209.41 21.49,31.1 48.67,45.13 76.25,52.33 l 17.93,-53.22 c -20.23,-4.99 -35.17,-12.9 -45.74,-28.2 -26.93,-39 -13.61,-88.32 35.25,-122.08 48.38,-33.42 98.89,-28.93 125.14,9.08 12.97,18.76 15.51,42.51 13.71,64.18 l 53.56,-2.72 c 4.04,-36.35 -5.86,-71.8 -24.97,-99.44 -45.7,-66.15 -127.22,-84.93 -207.67,-29.34" /><path
							 id="path52"
							 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 1390.15,4501.41 -101.76,92.31 c -27.03,-3.01 -45.23,-13.24 -58.53,-27.9 -25.39,-28 -19.75,-74.44 26.03,-115.97 47.09,-42.73 88.54,-47.93 117.17,-16.38 15.31,16.88 20.66,37.95 17.09,67.94 z m -181.8,-104.83 c -71.09,64.5 -73.92,148.88 -30.78,196.43 22.58,24.88 46.02,31.96 76,35.55 l -36.72,30.07 -79.08,71.75 46.34,51.1 313.72,-284.61 -38.3,-42.21 -26.78,17.81 -1.6,-1.78 c 1.46,-30.51 -5.8,-64.42 -27.17,-87.97 -49.59,-54.65 -123.63,-51.45 -195.63,13.86" /><path
							 id="path54"
							 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 2695.74,5510.2 67.65,4.32 16.88,-264.05 1.79,0.12 100.32,142.27 75.45,4.83 -92.93,-126.18 121.89,-167.15 -74.82,-4.79 -83.62,122.72 -42.73,-55.64 4.78,-74.85 -67.65,-4.32 -27.01,422.72" /><path
							 id="path56"
							 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 3187.71,5285.37 c 2.73,36.49 -17.79,59.7 -46.52,61.84 -28.72,2.15 -53.01,-17.1 -55.81,-54.18 -2.81,-37.7 18.32,-60.94 47.04,-63.1 28.12,-2.1 52.48,17.73 55.29,55.44 z m 18.46,-236.05 c 1.69,22.74 -16.37,30.72 -49.87,33.22 l -40.1,3 c -16.15,1.21 -28.63,3.34 -39.76,7.18 -16.47,-10.8 -24.63,-23.43 -25.65,-37.19 -1.97,-26.33 25.59,-44.03 72.27,-47.52 47.27,-3.54 81.21,16.2 83.11,41.31 z m -213.58,0.34 c 1.84,24.53 18.4,44.95 46.58,59.7 l 0.18,2.39 c -14.24,10.68 -24.45,27.1 -22.66,51.02 1.7,22.74 18.73,41.33 36.39,52.05 l 0.18,2.39 c -18.64,16.42 -35.08,45.93 -32.48,80.65 5.05,67.6 62.32,101.23 123.94,96.62 16.17,-1.21 30.9,-5.32 42.56,-10.4 l 105.31,-7.87 -3.81,-50.87 -53.86,4.04 c 8.73,-12.09 14.57,-30.58 13.04,-50.93 -4.88,-65.21 -56.52,-96.24 -118.77,-91.59 -12.56,0.93 -26.74,4.4 -39.49,10.77 -9.57,-7.11 -15.49,-13.88 -16.46,-27.05 -1.25,-16.75 9.94,-27.82 45.84,-30.5 l 52.07,-3.89 c 70.6,-5.28 106.09,-29.59 102.28,-80.46 -4.33,-58.04 -68.77,-98.94 -164.51,-91.79 -70,5.24 -120.18,34.25 -116.33,85.72" /><path
							 id="path58"
							 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 4730.5,4645.88 35.22,-44.81 -28.64,-28.61 1.49,-1.89 c 35.96,-3.02 70.27,-12.68 92.89,-41.45 26.7,-33.95 26.33,-65.52 8.92,-96.77 41.02,-3.62 77.09,-12.63 100.1,-41.88 38.56,-49.04 22.87,-98.01 -35.6,-143.99 l -145.26,-114.22 -43.01,54.71 138.17,108.65 c 38.2,30.04 43.46,52.48 24.55,76.54 -11.5,14.62 -33.55,23.23 -66.97,25.95 l -161.76,-127.19 -42.64,54.24 138.17,108.64 c 38.2,30.04 43.45,52.49 24.16,77 -11.12,14.15 -33.52,23.24 -66.96,25.97 l -161.75,-127.2 -42.64,54.23 231.56,182.08" /><path
							 id="path60"
							 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 5086.91,2621.67 35.8,-41.69 c -25.88,-21.04 -43.91,-42.69 -50.76,-71.89 -7.27,-30.94 3.9,-48.98 23.77,-53.64 23.94,-5.62 41.72,22.86 60.52,50.49 22.93,34.67 54.55,72.24 102.45,60.98 50.23,-11.79 76.38,-60.45 61.3,-124.7 -9.33,-39.72 -33.22,-68 -56.81,-87.11 l -33.62,40.56 c 19.26,16.43 34.01,34.54 39.34,57.31 6.72,28.62 -3.55,45.22 -21.66,49.46 -22.77,5.36 -38.24,-21.22 -56.62,-49.55 -23.79,-35.71 -52.62,-74.54 -106.35,-61.93 -49.06,11.53 -79.59,59.98 -62.6,132.4 9.2,39.12 35.88,76.61 65.24,99.31" /><path
							 id="path62"
							 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 774.855,2010.55 -18.457,53.91 36.465,17.56 -0.777,2.28 c -32.934,14.71 -62.133,35.15 -73.988,69.77 -14.004,40.87 -3.243,70.57 23.515,94.3 -37.519,16.96 -68.609,37.39 -80.664,72.57 -20.215,59.03 10.766,100.08 81.137,124.18 l 174.82,59.86 22.539,-65.84 -166.289,-56.95 c -45.976,-15.74 -58.34,-35.19 -48.418,-64.14 6.02,-17.6 23.965,-33 54.629,-46.61 l 194.688,66.67 22.343,-65.27 -166.304,-56.95 c -45.957,-15.74 -58.34,-35.19 -48.227,-64.71 5.844,-17.02 23.985,-33.01 54.649,-46.6 l 194.674,66.66 22.36,-65.27 -278.695,-95.42" /><path
							 id="path64"
							 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 737.434,2738.83 c -58.805,-8.39 -93.692,-40.03 -87.594,-82.81 6.109,-42.77 48.355,-62.8 107.168,-54.41 58.219,8.3 93.203,39.35 87.086,82.12 -6.09,42.77 -48.438,63.41 -106.66,55.1 z m 29.574,-207.32 c -97.422,-13.9 -162.68,44.08 -173.012,116.56 -10.43,73.06 36.016,146.97 133.438,160.86 96.836,13.82 162.089,-44.17 172.5,-117.23 10.332,-72.47 -36.09,-146.38 -132.926,-160.19" /><path
							 id="path66"
							 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 798.137,2885.01 -347.832,-10.72 -2.129,68.96 351.449,10.84 c 16.773,0.51 22.535,8.49 22.32,15.69 -0.097,2.99 -0.175,5.4 -1.543,10.76 l 51.313,10.59 c 3.863,-8.28 6.621,-20.21 7.129,-36.4 1.5,-49.18 -29.731,-68.15 -80.707,-69.72" /><path
							 id="path68"
							 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 1989.53,1188.87 62.53,-30.55 -78.22,-160.121 1.62,-0.777 203.83,98.748 69.55,-33.98 -175.53,-84.542 21.63,-276.988 -69.01,33.699 -14.32,212.68 -81.5,-38.328 -50.29,-102.969 -62.54,30.547 172.25,352.581" /><path
							 id="path70"
							 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 3913.02,919.441 90.57,42.879 -33.01,37.481 c -29.1,32.009 -58.65,67.819 -87.44,101.989 l -2.17,-1.03 c 8.97,-44.21 17.66,-89.22 24,-132.018 z m -89.86,213.689 73.75,34.93 283.4,-299.99 -66.16,-31.32 -73.1,82.902 -119.3,-56.492 17.78,-109.078 -63.99,-30.293 -52.38,409.341" /><path
							 id="path72"
							 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 1697.71,3766 23.98,35.94 85.41,-85.35 0.88,1.33 -35,160.9 26.41,39.6 33.03,-137.93 163.75,-38.55 -24.87,-37.27 -134.02,34.1 13.75,-65.91 59.45,-59.38 -23.98,-35.94 -188.79,188.46" /><path
							 id="path74"
							 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 2070.31,3708.57 c -28.81,25.18 -27.66,59.8 -7.56,82.81 9.67,11.07 20.8,15.28 31.78,16.85 l 4.57,-21.35 c -8.03,-1.04 -14.16,-3.43 -18.91,-8.87 -12.13,-13.88 -9.16,-33.51 8.22,-48.71 17.23,-15.05 36.92,-15.54 48.75,-2.02 5.82,6.68 7.85,15.74 8.13,24.19 l 20.56,-3.41 c -0.04,-14.22 -5.43,-27.48 -14.02,-37.31 -20.59,-23.54 -52.89,-27.2 -81.52,-2.18" /><path
							 id="path76"
							 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 2202.83,3812.8 -37,38.51 c -10.56,-0.45 -17.91,-3.94 -23.45,-9.27 -10.59,-10.18 -9.63,-28.34 7.01,-45.66 17.13,-17.83 33.06,-20.95 45,-9.47 6.4,6.14 9.02,14.17 8.44,25.89 z m -73.29,-35.82 c -25.85,26.91 -24.7,59.71 -6.71,77 9.41,9.05 18.69,11.17 30.43,11.76 l -13.44,12.64 -28.77,29.93 19.33,18.58 114.09,-118.71 -15.98,-15.35 -9.9,7.62 -0.69,-0.65 c -0.23,-11.87 -3.94,-24.83 -12.87,-33.39 -20.68,-19.88 -49.31,-16.67 -75.49,10.57" /><path
							 id="path78"
							 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 2940.23,4500.67 42.79,-0.22 -17.64,-83.11 -7.73,-28.35 h 1.6 c 20.08,17.09 41.35,30.18 64.94,30.06 32.8,-0.17 46.31,-18.23 46.14,-49.82 -0.04,-9.2 -0.88,-17.2 -3.34,-27.58 l -25.43,-123.85 -42.8,0.22 24.61,118.25 c 1.64,9.19 3.28,14.78 3.3,20.78 0.08,16.8 -7.87,25.23 -24.66,25.32 -13.6,0.07 -28.83,-9.05 -49.75,-30.13 l -27.07,-133.84 -43.18,0.21 58.22,282.06" /><path
							 id="path80"
							 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 3961.46,3853.03 c 55.33,43.51 130.94,37.33 168.75,-10.77 14.84,-18.86 16.42,-38.98 13.03,-55.38 l -35.26,2.79 c 2.48,13.65 1.31,22.91 -6.83,33.28 -21.76,27.66 -72.86,26.66 -111.21,-3.51 -23.29,-18.29 -28.64,-39.29 -12.31,-60.05 9.4,-11.94 22.46,-16.92 34.94,-19.84 l -10.02,-31.26 c -17.63,4.95 -39.41,13.25 -57.71,36.52 -26.72,33.95 -23.28,76.82 16.62,108.22" /><path
							 id="path82"
							 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 4229.64,2719.2 107.72,16.89 84.22,11.8 0.25,1.58 -76.15,37.56 -96.86,49.82 z m 16.17,168.82 217.25,-119.33 -8.81,-54.09 -243.85,-43.75 -27.63,4.51 35.41,217.16 27.63,-4.5" /><path
							 id="path84"
							 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 4149.72,2598.5 135.2,0.12 c 8.92,0.01 18.02,0.93 27.3,2.77 9.28,1.83 15.22,6.63 17.81,14.4 1.25,3.71 1.82,8.05 1.7,13.04 l 7.37,0.41 3.37,-52.44 -2.73,-8.15 -158.73,-0.85 51.52,-50.9 c 9.24,-9.28 17.01,-14.99 23.3,-17.1 5.06,-1.71 12.5,-3.03 22.35,-4.01 7.2,-0.62 12.48,-1.5 15.8,-2.63 12.22,-4.1 16.11,-12.77 11.68,-25.96 -3.95,-11.73 -11.47,-15.74 -22.58,-12.01 -10.98,3.7 -29.22,18.9 -54.73,45.61 l -82.38,86.59 3.75,11.11" /><path
							 id="path86"
							 style="fill:none;stroke:#393536;stroke-width:5;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:10;stroke-dasharray:none;stroke-opacity:1"
							 d="m 4149.72,2598.5 135.2,0.12 c 8.92,0.01 18.02,0.93 27.3,2.77 9.28,1.83 15.22,6.63 17.81,14.4 1.25,3.71 1.82,8.05 1.7,13.04 l 7.37,0.41 3.37,-52.44 -2.73,-8.15 -158.73,-0.85 51.52,-50.9 c 9.24,-9.28 17.01,-14.99 23.3,-17.1 5.06,-1.71 12.5,-3.03 22.35,-4.01 7.2,-0.62 12.48,-1.5 15.8,-2.63 12.22,-4.1 16.11,-12.77 11.68,-25.96 -3.95,-11.73 -11.47,-15.74 -22.58,-12.01 -10.98,3.7 -29.22,18.9 -54.73,45.61 l -82.38,86.59 z" /><path
							 id="path88"
							 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 1547.69,2518.04 -11.27,40.88 132.56,89.59 50.33,29.62 -0.43,1.54 c -26.68,-4.03 -60.08,-10.74 -89.06,-12.49 l -120.78,-8.78 -11.04,40.1 266.08,18.92 11.15,-40.49 -132.27,-89.1 -51.11,-29.84 0.43,-1.54 c 27.83,4.35 59.53,9.76 88.5,11.52 l 121.95,9.09 10.94,-39.71 -265.98,-19.31" /><path
							 id="path90"
							 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 1820.83,2813.71 -4.76,38.65 -17.87,-7.6 c -15.35,-6.84 -32.17,-13.36 -48.3,-19.82 l 0.13,-0.93 c 17.39,-2.08 35.06,-4.37 51.62,-7.25 z m -89.8,-7.09 -3.91,31.47 145.28,67.98 3.49,-28.22 -39.51,-16.86 6.29,-50.91 42.42,-6.76 3.36,-27.31 -157.42,30.61" /><path
							 id="path92"
							 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 2432.63,1917.71 38.46,-18.79 -109.96,-143.92 1.44,-0.7 118.21,44.18 43.1,-21.08 -108.03,-40.69 -7.3,-121.54 -38.83,18.98 8.13,93.08 -51.55,-17.99 -29.88,-39.26 -38.81,18.97 175.02,228.76" /><path
							 id="path94"
							 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 3598.94,1768.11 c -1.13,5.22 -2.81,10.62 -5.55,16.4 -8.2,17.36 -22.79,29.48 -44.49,19.22 -21.33,-10.1 -34.1,-38.26 -28.42,-72.75 z m -59.53,67.86 c 41.21,19.5 69.92,-1.88 87.36,-38.75 7.36,-15.55 10,-34.21 10.2,-41.21 l -108.11,-51.15 c 13.83,-39.48 42.33,-45.47 69.08,-32.81 12.66,5.99 23.15,19.36 29.48,31.21 l 26.27,-18.11 c -9.67,-16.96 -26.53,-35.56 -51.86,-47.53 -42.3,-20.02 -84.22,-6.23 -106.8,41.49 -31.31,66.17 -2.26,134.78 44.38,156.86" /></g></g></svg>
			</xsl:when>
			<xsl:when test="$si-aspect = 'kg_h_c_deltanu'">
				<svg
				 xmlns:dc="http://purl.org/dc/elements/1.1/"
				 xmlns:cc="http://creativecommons.org/ns#"
				 xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
				 xmlns:svg="http://www.w3.org/2000/svg"
				 xmlns="http://www.w3.org/2000/svg"
				 viewBox="0 0 793.70667 793.70667"
				 height="793.70667"
				 width="793.70667"
				 xml:space="preserve"
				 id="svg2"
				 version="1.1"><metadata
					 id="metadata8"><rdf:RDF><cc:Work
							 rdf:about=""><dc:format>image/svg+xml</dc:format><dc:type
								 rdf:resource="http://purl.org/dc/dcmitype/StillImage" /></cc:Work></rdf:RDF></metadata><defs
					 id="defs6" /><g
					 transform="matrix(1.3333333,0,0,-1.3333333,0,793.70667)"
					 id="g10"><g
						 transform="scale(0.1)"
						 id="g12"><path
							 id="path14"
							 style="fill:#bdbcbc;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 2200.47,4489.45 -492.3,1022.27 C 973.336,5143.46 420.902,4465.25 222.191,3648.49 L 1327.98,3396.1 c 121.18,477.04 444.11,873.25 872.49,1093.35" /><path
							 id="path16"
							 style="fill:#bdbcbc;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 4677.18,2976.13 c 0,-385.75 -128.61,-741.35 -345.02,-1026.7 l 886.73,-707.15 c 371.14,479.32 592.15,1080.74 592.15,1733.85 0,202.15 -21.32,399.29 -61.55,589.46 L 4643.65,3313.18 c 21.91,-108.96 33.53,-221.64 33.53,-337.05" /><path
							 id="path18"
							 style="fill:#d41938;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 2976.4,5810.78 c -425.67,0 -829.33,-94.01 -1191.63,-262.11 l 492.3,-1022.28 c 213.37,96.42 449.97,150.52 699.33,150.52 249.36,0 485.93,-54.1 699.3,-150.5 L 4168,5548.68 c -362.28,168.09 -765.93,262.1 -1191.6,262.1" /><path
							 id="path20"
							 style="fill:#bdbcbc;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="M 4624.81,3396.1 5730.6,3648.5 C 5531.88,4465.27 4979.44,5143.48 4244.59,5511.74 L 3752.3,4489.46 c 428.38,-220.09 751.33,-616.3 872.51,-1093.36" /><path
							 id="path22"
							 style="fill:#bdbcbc;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 1275.61,2976.13 c 0,115.41 11.63,228.09 33.54,337.04 L 203.297,3565.58 c -40.227,-190.17 -61.543,-387.3 -61.543,-589.45 0,-653.11 221.016,-1254.52 592.137,-1733.83 l 886.739,707.15 c -216.42,285.34 -345.02,640.94 -345.02,1026.68" /><path
							 id="path24"
							 style="fill:#bdbcbc;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="M 2933.86,142.031 V 1276.42 c -505.75,12.46 -956.65,245.33 -1260.13,606.61 L 786.852,1175.77 C 1298.35,554.398 2069.24,154.762 2933.86,142.031" /><path
							 id="path26"
							 style="fill:#bdbcbc;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 3018.9,142.031 c 864.63,12.719 1635.51,412.36 2147.04,1033.719 l -886.89,707.26 C 3975.57,1521.73 3524.66,1288.86 3018.9,1276.42 V 142.031" /><path
							 id="path28"
							 style="fill:#e7807c;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 3675.7,4526.41 c -213.37,96.4 -449.94,150.5 -699.3,150.5 -249.36,0 -485.96,-54.1 -699.33,-150.52 l 699.31,-1452.13 699.32,1452.15" /><path
							 id="path30"
							 style="fill:#deddde;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 1309.15,3313.17 c -21.91,-108.95 -33.54,-221.63 -33.54,-337.04 0,-385.74 128.6,-741.34 345.02,-1026.68 l 1260.2,1004.99 -1571.68,358.73" /><path
							 id="path32"
							 style="fill:#deddde;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 3018.9,1276.42 c 505.76,12.44 956.67,245.31 1260.15,606.59 L 3018.9,2887.95 V 1276.42" /><path
							 id="path34"
							 style="fill:#fbcb78;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="M 4643.65,3313.18 3071.93,2954.44 4332.16,1949.43 c 216.41,285.35 345.02,640.95 345.02,1026.7 0,115.41 -11.62,228.09 -33.53,337.05" /><path
							 id="path36"
							 style="fill:#deddde;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="M 2200.47,4489.45 C 1772.09,4269.35 1449.16,3873.14 1327.98,3396.1 l 1571.78,-358.75 -699.29,1452.1" /><path
							 id="path38"
							 style="fill:#f8a67f;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 4624.81,3396.1 c -121.18,477.06 -444.13,873.27 -872.51,1093.36 L 3053,3037.35 4624.81,3396.1" /><path
							 id="path40"
							 style="fill:#deddde;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 1673.73,1883.03 c 303.48,-361.28 754.38,-594.15 1260.13,-606.61 V 2887.95 L 1673.73,1883.03" /><path
							 id="path42"
							 style="fill:#ec008c;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 786.852,1175.77 c -18.02,21.88 -35.598,44.11 -52.961,66.53" /><path
							 id="path44"
							 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 3968.53,2976.13 c 0,-547.94 -444.19,-992.13 -992.13,-992.13 -547.94,0 -992.13,444.19 -992.13,992.13 0,547.94 444.19,992.13 992.13,992.13 547.94,0 992.13,-444.19 992.13,-992.13" /><path
							 id="path46"
							 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 2428.12,2585.6 74.8,86.76 c 70.3,-73.3 169.03,-122.66 270.75,-122.66 128.63,0 204.92,64.32 204.92,160.06 0,100.22 -70.31,131.63 -163.05,173.51 l -140.6,61.33 c -92.74,38.89 -198.95,109.19 -198.95,252.79 0,149.58 130.14,260.28 308.15,260.28 116.68,0 219.88,-49.37 290.17,-121.17 l -67.3,-80.77 c -59.83,56.84 -131.62,92.74 -222.87,92.74 -109.2,0 -182.5,-55.35 -182.5,-143.6 0,-94.24 85.27,-130.13 163.04,-163.04 l 139.12,-59.84 c 113.68,-49.36 201.94,-116.67 201.94,-261.77 0,-155.56 -127.15,-279.71 -333.58,-279.71 -137.61,0 -258.77,56.84 -344.04,145.09" /><path
							 id="path48"
							 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 3298.71,3439.72 h 124.16 v -981.26 h -124.16 v 981.26" /><path
							 id="path50"
							 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 1053.94,4174.64 c -80.956,55.93 -88.143,144.75 -43.46,209.41 21.49,31.1 48.68,45.13 76.25,52.33 l 17.93,-53.22 c -20.23,-4.99 -35.17,-12.9 -45.74,-28.2 -26.93,-39 -13.61,-88.31 35.25,-122.07 48.38,-33.43 98.89,-28.94 125.14,9.07 12.97,18.76 15.51,42.51 13.71,64.18 l 53.56,-2.72 c 4.04,-36.35 -5.86,-71.8 -24.96,-99.44 -45.71,-66.15 -127.23,-84.93 -207.68,-29.34" /><path
							 id="path52"
							 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 1390.15,4501.41 -101.76,92.31 c -27.03,-3.01 -45.23,-13.24 -58.53,-27.9 -25.39,-28 -19.75,-74.44 26.03,-115.97 47.09,-42.73 88.54,-47.93 117.17,-16.38 15.31,16.88 20.67,37.95 17.09,67.94 z m -181.8,-104.83 c -71.09,64.5 -73.92,148.88 -30.78,196.43 22.58,24.88 46.02,31.97 76,35.55 l -36.72,30.07 -79.08,71.76 46.35,51.09 313.71,-284.61 -38.3,-42.21 -26.78,17.81 -1.6,-1.78 c 1.46,-30.5 -5.8,-64.42 -27.17,-87.97 -49.59,-54.65 -123.63,-51.45 -195.63,13.86" /><path
							 id="path54"
							 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 2695.74,5510.2 67.65,4.32 16.88,-264.05 1.8,0.12 100.31,142.27 75.45,4.83 -92.93,-126.18 121.89,-167.15 -74.82,-4.79 -83.62,122.72 -42.73,-55.64 4.78,-74.85 -67.65,-4.32 -27.01,422.72" /><path
							 id="path56"
							 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 3187.71,5285.37 c 2.73,36.5 -17.79,59.7 -46.52,61.84 -28.71,2.16 -53.01,-17.1 -55.8,-54.18 -2.82,-37.7 18.32,-60.94 47.03,-63.1 28.12,-2.1 52.48,17.74 55.29,55.44 z m 18.46,-236.04 c 1.7,22.73 -16.37,30.71 -49.87,33.21 l -40.09,3 c -16.16,1.21 -28.64,3.34 -39.77,7.18 -16.46,-10.8 -24.63,-23.43 -25.64,-37.19 -1.98,-26.33 25.58,-44.03 72.26,-47.52 47.27,-3.54 81.21,16.2 83.11,41.32 z m -213.58,0.33 c 1.84,24.53 18.4,44.95 46.58,59.7 l 0.18,2.39 c -14.24,10.68 -24.45,27.1 -22.66,51.02 1.7,22.74 18.73,41.33 36.39,52.05 l 0.18,2.39 c -18.64,16.42 -35.08,45.93 -32.48,80.65 5.05,67.6 62.32,101.23 123.94,96.62 16.17,-1.21 30.9,-5.32 42.56,-10.4 l 105.31,-7.87 -3.81,-50.87 -53.86,4.04 c 8.73,-12.09 14.57,-30.58 13.04,-50.93 -4.88,-65.21 -56.52,-96.24 -118.77,-91.59 -12.55,0.93 -26.73,4.4 -39.49,10.77 -9.57,-7.11 -15.49,-13.88 -16.46,-27.05 -1.25,-16.75 9.94,-27.82 45.84,-30.5 l 52.07,-3.89 c 70.6,-5.28 106.09,-29.59 102.28,-80.46 -4.33,-58.04 -68.77,-98.94 -164.51,-91.79 -70,5.24 -120.18,34.26 -116.33,85.72" /><path
							 id="path58"
							 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 4730.5,4645.88 35.22,-44.81 -28.64,-28.61 1.49,-1.89 c 35.96,-3.02 70.27,-12.68 92.89,-41.45 26.7,-33.95 26.33,-65.52 8.93,-96.77 41.01,-3.62 77.09,-12.63 100.09,-41.88 38.56,-49.03 22.87,-98.01 -35.6,-143.99 l -145.26,-114.21 -43,54.7 138.16,108.65 c 38.2,30.04 43.46,52.49 24.55,76.54 -11.5,14.62 -33.55,23.24 -66.97,25.95 l -161.76,-127.19 -42.64,54.24 138.17,108.64 c 38.2,30.04 43.45,52.49 24.16,77.01 -11.12,14.14 -33.52,23.23 -66.96,25.96 l -161.75,-127.2 -42.64,54.23 231.56,182.08" /><path
							 id="path60"
							 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 5086.91,2621.67 35.8,-41.69 c -25.88,-21.03 -43.91,-42.69 -50.76,-71.88 -7.27,-30.95 3.9,-48.99 23.77,-53.65 23.94,-5.62 41.72,22.86 60.52,50.49 22.93,34.67 54.56,72.24 102.45,60.98 50.23,-11.79 76.38,-60.45 61.31,-124.7 -9.34,-39.72 -33.23,-68 -56.82,-87.11 l -33.62,40.56 c 19.26,16.43 34.01,34.54 39.34,57.31 6.72,28.63 -3.55,45.22 -21.66,49.47 -22.77,5.35 -38.24,-21.23 -56.62,-49.56 -23.79,-35.71 -52.62,-74.54 -106.35,-61.93 -49.06,11.53 -79.59,59.98 -62.6,132.4 9.2,39.12 35.88,76.61 65.24,99.31" /><path
							 id="path62"
							 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 774.859,2010.55 -18.457,53.91 36.465,17.56 -0.781,2.28 c -32.93,14.71 -62.129,35.15 -73.984,69.77 -14.004,40.87 -3.243,70.57 23.515,94.3 -37.519,16.96 -68.613,37.39 -80.664,72.57 -20.215,59.04 10.762,100.08 81.133,124.18 l 174.824,59.87 22.539,-65.84 -166.289,-56.96 c -45.976,-15.74 -58.34,-35.19 -48.418,-64.14 6.016,-17.6 23.965,-33 54.629,-46.6 l 194.688,66.66 22.343,-65.27 -166.308,-56.95 c -45.957,-15.74 -58.34,-35.19 -48.223,-64.71 5.84,-17.02 23.984,-33.01 54.649,-46.6 l 194.67,66.66 22.36,-65.27 -278.691,-95.42" /><path
							 id="path64"
							 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 737.438,2738.83 c -58.809,-8.39 -93.692,-40.03 -87.598,-82.8 6.113,-42.78 48.359,-62.81 107.168,-54.42 58.222,8.3 93.203,39.35 87.09,82.12 -6.094,42.77 -48.438,63.41 -106.66,55.1 z m 29.57,-207.32 c -97.422,-13.9 -162.676,44.08 -173.008,116.56 -10.43,73.06 36.016,146.97 133.438,160.86 96.835,13.82 162.089,-44.16 172.5,-117.23 10.332,-72.47 -36.094,-146.38 -132.93,-160.19" /><path
							 id="path66"
							 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 798.141,2885.01 -347.832,-10.72 -2.129,68.96 351.445,10.84 c 16.777,0.51 22.539,8.49 22.324,15.69 -0.097,2.99 -0.176,5.4 -1.543,10.76 l 51.309,10.59 c 3.867,-8.28 6.621,-20.21 7.129,-36.4 1.504,-49.18 -29.727,-68.15 -80.703,-69.72" /><path
							 id="path68"
							 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 1989.53,1188.87 62.54,-30.55 -78.23,-160.121 1.62,-0.777 203.83,98.748 69.55,-33.98 -175.52,-84.53 21.62,-277 -69.01,33.699 -14.31,212.68 -81.51,-38.328 -50.29,-102.969 -62.54,30.547 172.25,352.581" /><path
							 id="path70"
							 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 3913.02,919.441 90.57,42.879 -33.01,37.481 c -29.1,32.019 -58.65,67.819 -87.44,101.989 l -2.17,-1.03 c 8.97,-44.21 17.66,-89.22 24.01,-132.018 z m -89.86,213.689 73.75,34.93 283.4,-299.978 -66.16,-31.332 -73.1,82.902 -119.3,-56.492 17.78,-109.078 -63.99,-30.293 -52.38,409.341" /><path
							 id="path72"
							 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 1697.71,3766 23.98,35.94 85.41,-85.35 0.88,1.33 -35,160.9 26.41,39.6 33.03,-137.93 163.75,-38.55 -24.87,-37.27 -134.02,34.1 13.75,-65.91 59.45,-59.38 -23.98,-35.94 -188.79,188.46" /><path
							 id="path74"
							 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 2070.31,3708.57 c -28.81,25.18 -27.66,59.8 -7.56,82.81 9.67,11.07 20.8,15.28 31.78,16.85 l 4.57,-21.35 c -8.03,-1.04 -14.16,-3.43 -18.91,-8.87 -12.13,-13.88 -9.16,-33.51 8.22,-48.71 17.23,-15.05 36.92,-15.54 48.75,-2.02 5.82,6.68 7.85,15.74 8.13,24.19 l 20.56,-3.41 c -0.03,-14.22 -5.43,-27.48 -14.02,-37.31 -20.58,-23.54 -52.89,-27.2 -81.52,-2.18" /><path
							 id="path76"
							 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 2202.83,3812.8 -37,38.51 c -10.56,-0.45 -17.91,-3.94 -23.45,-9.27 -10.59,-10.18 -9.63,-28.34 7.01,-45.66 17.13,-17.83 33.07,-20.95 45,-9.47 6.41,6.14 9.02,14.17 8.44,25.89 z m -73.28,-35.82 c -25.86,26.91 -24.71,59.71 -6.72,77 9.41,9.05 18.69,11.17 30.43,11.76 l -13.44,12.64 -28.77,29.93 19.34,18.58 114.08,-118.71 -15.98,-15.35 -9.9,7.62 -0.68,-0.65 c -0.24,-11.87 -3.95,-24.82 -12.88,-33.39 -20.68,-19.88 -49.31,-16.67 -75.48,10.57" /><path
							 id="path78"
							 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 2940.23,4500.67 42.79,-0.22 -17.63,-83.11 -7.74,-28.35 h 1.6 c 20.08,17.09 41.35,30.18 64.94,30.06 32.8,-0.17 46.31,-18.23 46.14,-49.82 -0.04,-9.2 -0.88,-17.2 -3.34,-27.58 l -25.43,-123.85 -42.8,0.22 24.61,118.25 c 1.64,9.19 3.28,14.78 3.3,20.78 0.08,16.8 -7.87,25.23 -24.66,25.32 -13.6,0.07 -28.83,-9.05 -49.75,-30.13 l -27.07,-133.84 -43.18,0.21 58.22,282.06" /><path
							 id="path80"
							 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 3961.46,3853.03 c 55.33,43.51 130.94,37.33 168.75,-10.76 14.84,-18.87 16.43,-38.99 13.03,-55.39 l -35.26,2.79 c 2.48,13.65 1.31,22.91 -6.83,33.28 -21.76,27.66 -72.85,26.66 -111.21,-3.51 -23.29,-18.29 -28.64,-39.29 -12.31,-60.05 9.4,-11.94 22.46,-16.92 34.94,-19.83 l -10.02,-31.27 c -17.63,4.95 -39.41,13.25 -57.71,36.52 -26.72,33.95 -23.28,76.82 16.62,108.22" /><path
							 id="path82"
							 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 4229.64,2719.2 107.72,16.89 84.22,11.81 0.25,1.57 -76.15,37.56 -96.86,49.83 z m 16.18,168.82 217.24,-119.33 -8.81,-54.09 -243.85,-43.75 -27.63,4.51 35.41,217.16 27.64,-4.5" /><path
							 id="path84"
							 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 4149.72,2598.51 135.2,0.11 c 8.92,0.01 18.02,0.93 27.3,2.77 9.28,1.83 15.22,6.63 17.81,14.41 1.25,3.7 1.82,8.04 1.7,13.03 l 7.37,0.41 3.38,-52.44 -2.74,-8.15 -158.73,-0.85 51.52,-50.9 c 9.24,-9.28 17.02,-14.99 23.3,-17.1 5.06,-1.7 12.5,-3.03 22.35,-4.01 7.21,-0.62 12.48,-1.5 15.8,-2.63 12.23,-4.1 16.11,-12.76 11.68,-25.96 -3.95,-11.73 -11.47,-15.74 -22.58,-12 -10.98,3.69 -29.22,18.89 -54.73,45.6 l -82.38,86.59 3.75,11.12" /><path
							 id="path86"
							 style="fill:none;stroke:#393536;stroke-width:5;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:10;stroke-dasharray:none;stroke-opacity:1"
							 d="m 4149.72,2598.51 135.2,0.11 c 8.92,0.01 18.02,0.93 27.3,2.77 9.28,1.83 15.22,6.63 17.81,14.41 1.25,3.7 1.82,8.04 1.7,13.03 l 7.37,0.41 3.38,-52.44 -2.74,-8.15 -158.73,-0.85 51.52,-50.9 c 9.24,-9.28 17.02,-14.99 23.3,-17.1 5.06,-1.7 12.5,-3.03 22.35,-4.01 7.21,-0.62 12.48,-1.5 15.8,-2.63 12.23,-4.1 16.11,-12.76 11.68,-25.96 -3.95,-11.73 -11.47,-15.74 -22.58,-12 -10.98,3.69 -29.22,18.89 -54.73,45.6 l -82.38,86.59 z" /><path
							 id="path88"
							 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 1547.69,2518.04 -11.27,40.88 132.56,89.59 50.33,29.62 -0.43,1.54 c -26.68,-4.03 -60.08,-10.74 -89.06,-12.49 l -120.78,-8.78 -11.04,40.1 266.08,18.92 11.15,-40.49 -132.27,-89.1 -51.11,-29.84 0.43,-1.54 c 27.83,4.36 59.53,9.77 88.5,11.52 l 121.95,9.09 10.94,-39.71 -265.98,-19.31" /><path
							 id="path90"
							 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 1820.83,2813.72 -4.76,38.64 -17.87,-7.6 c -15.35,-6.84 -32.17,-13.36 -48.3,-19.82 l 0.13,-0.93 c 17.39,-2.08 35.06,-4.37 51.63,-7.25 z m -89.8,-7.1 -3.91,31.48 145.28,67.97 3.49,-28.22 -39.51,-16.86 6.29,-50.91 42.42,-6.76 3.36,-27.3 -157.42,30.6" /><path
							 id="path92"
							 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 2432.63,1917.71 38.46,-18.78 -109.96,-143.93 1.44,-0.7 118.21,44.18 43.1,-21.08 -108.03,-40.69 -7.3,-121.53 -38.83,18.97 8.13,93.09 -51.55,-18 -29.88,-39.26 -38.81,18.97 175.02,228.76" /><path
							 id="path94"
							 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
							 d="m 3598.94,1768.11 c -1.13,5.22 -2.81,10.62 -5.55,16.4 -8.2,17.36 -22.79,29.48 -44.49,19.22 -21.33,-10.1 -34.1,-38.26 -28.42,-72.74 z m -59.53,67.86 c 41.21,19.5 69.92,-1.88 87.36,-38.75 7.37,-15.55 10,-34.21 10.2,-41.2 l -108.11,-51.16 c 13.83,-39.48 42.33,-45.47 69.08,-32.81 12.66,5.99 23.15,19.37 29.48,31.21 l 26.27,-18.1 c -9.67,-16.97 -26.53,-35.57 -51.86,-47.54 -42.3,-20.02 -84.22,-6.23 -106.8,41.49 -31.3,66.17 -2.26,134.79 44.38,156.86" /></g></g></svg>
			</xsl:when>
			<xsl:when test="$si-aspect = 'kg_h'">
				<svg
					 xmlns:dc="http://purl.org/dc/elements/1.1/"
					 xmlns:cc="http://creativecommons.org/ns#"
					 xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
					 xmlns:svg="http://www.w3.org/2000/svg"
					 xmlns="http://www.w3.org/2000/svg"
					 id="svg85"
					 version="1.2"
					 viewBox="0 0 595.28 595.28"
					 height="595.28pt"
					 width="595.28pt">
					<metadata
						 id="metadata91">
						<rdf:RDF>
							<cc:Work
								 rdf:about="">
								<dc:format>image/svg+xml</dc:format>
								<dc:type
									 rdf:resource="http://purl.org/dc/dcmitype/StillImage" />
							</cc:Work>
						</rdf:RDF>
					</metadata>
					<defs
						 id="defs89" />
					<g
						 id="surface1">
						<path
							 id="path2"
							 d="M 220.046875 146.335938 L 170.816406 44.109375 C 97.332031 80.933594 42.089844 148.753906 22.21875 230.433594 L 132.796875 255.671875 C 144.914062 207.964844 177.210938 168.34375 220.046875 146.335938 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(74.113464%,73.643494%,73.75946%);fill-opacity:1;" />
						<path
							 id="path4"
							 d="M 467.71875 297.667969 C 467.71875 336.242188 454.859375 371.804688 433.214844 400.335938 L 521.890625 471.050781 C 559.003906 423.121094 581.105469 362.980469 581.105469 297.667969 C 581.105469 277.453125 578.972656 257.738281 574.949219 238.722656 L 464.367188 263.960938 C 466.554688 274.859375 467.71875 286.125 467.71875 297.667969 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(74.113464%,73.643494%,73.75946%);fill-opacity:1;" />
						<path
							 id="path6"
							 d="M 297.640625 14.203125 C 255.074219 14.203125 214.707031 23.601562 178.476562 40.414062 L 227.707031 142.640625 C 249.042969 133 272.703125 127.589844 297.640625 127.589844 C 322.574219 127.589844 346.234375 133 367.570312 142.640625 L 416.800781 40.410156 C 380.570312 23.601562 340.207031 14.203125 297.640625 14.203125 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(83.06427%,9.985352%,21.838379%);fill-opacity:1;" />
						<path
							 id="path8"
							 d="M 462.480469 255.667969 L 573.058594 230.429688 C 553.1875 148.753906 497.945312 80.933594 424.460938 44.105469 L 375.230469 146.335938 C 418.070312 168.34375 450.363281 207.964844 462.480469 255.667969 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(74.113464%,73.643494%,73.75946%);fill-opacity:1;" />
						<path
							 id="path10"
							 d="M 127.5625 297.667969 C 127.5625 286.125 128.722656 274.859375 130.914062 263.964844 L 20.328125 238.722656 C 16.308594 257.738281 14.175781 277.453125 14.175781 297.667969 C 14.175781 362.976562 36.277344 423.117188 73.390625 471.050781 L 162.0625 400.335938 C 140.421875 371.800781 127.5625 336.242188 127.5625 297.667969 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(74.113464%,73.643494%,73.75946%);fill-opacity:1;" />
						<path
							 id="path12"
							 d="M 293.386719 581.078125 L 293.386719 467.636719 C 242.8125 466.390625 197.722656 443.105469 167.371094 406.976562 L 78.683594 477.703125 C 129.835938 539.839844 206.925781 579.804688 293.386719 581.078125 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(74.113464%,73.643494%,73.75946%);fill-opacity:1;" />
						<path
							 id="path14"
							 d="M 301.890625 581.078125 C 388.351562 579.804688 465.441406 539.839844 516.59375 477.703125 L 427.90625 406.980469 C 397.558594 443.105469 352.464844 466.394531 301.890625 467.636719 L 301.890625 581.078125 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(74.113464%,73.643494%,73.75946%);fill-opacity:1;" />
						<path
							 id="path16"
							 d="M 367.570312 142.640625 C 346.234375 133 322.574219 127.589844 297.640625 127.589844 C 272.703125 127.589844 249.042969 133 227.707031 142.640625 L 297.636719 287.855469 L 367.570312 142.640625 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(90.582275%,50.18158%,48.53363%);fill-opacity:1;" />
						<path
							 id="path18"
							 d="M 130.914062 263.964844 C 128.722656 274.859375 127.5625 286.125 127.5625 297.667969 C 127.5625 336.242188 140.421875 371.800781 162.0625 400.335938 L 288.082031 299.835938 L 130.914062 263.964844 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(87.068176%,86.833191%,86.891174%);fill-opacity:1;" />
						<path
							 id="path20"
							 d="M 301.890625 467.636719 C 352.464844 466.394531 397.558594 443.105469 427.90625 406.980469 L 301.890625 306.484375 L 301.890625 467.636719 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(87.068176%,86.833191%,86.891174%);fill-opacity:1;" />
						<path
							 id="path22"
							 d="M 464.367188 263.960938 L 307.191406 299.835938 L 433.214844 400.335938 C 454.859375 371.804688 467.71875 336.242188 467.71875 297.667969 C 467.71875 286.125 466.554688 274.859375 464.367188 263.960938 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(87.068176%,86.833191%,86.891174%);fill-opacity:1;" />
						<path
							 id="path24"
							 d="M 220.046875 146.335938 C 177.210938 168.34375 144.914062 207.964844 132.796875 255.671875 L 289.976562 291.546875 L 220.046875 146.335938 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(87.068176%,86.833191%,86.891174%);fill-opacity:1;" />
						<path
							 id="path26"
							 d="M 462.480469 255.667969 C 450.363281 207.964844 418.070312 168.34375 375.230469 146.335938 L 305.300781 291.546875 L 462.480469 255.667969 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(87.068176%,86.833191%,86.891174%);fill-opacity:1;" />
						<path
							 id="path28"
							 d="M 167.371094 406.976562 C 197.722656 443.105469 242.8125 466.390625 293.386719 467.636719 L 293.386719 306.484375 L 167.371094 406.976562 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(87.068176%,86.833191%,86.891174%);fill-opacity:1;" />
						<path
							 id="path30"
							 d="M 78.683594 477.703125 C 76.882812 475.515625 75.125 473.292969 73.390625 471.050781 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(92.549133%,0%,54.899597%);fill-opacity:1;" />
						<path
							 id="path32"
							 d="M 396.851562 297.667969 C 396.851562 352.460938 352.433594 396.878906 297.640625 396.878906 C 242.847656 396.878906 198.425781 352.460938 198.425781 297.667969 C 198.425781 242.875 242.847656 198.453125 297.640625 198.453125 C 352.433594 198.453125 396.851562 242.875 396.851562 297.667969 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,100%,100%);fill-opacity:1;" />
						<path
							 id="path34"
							 d="M 242.8125 336.71875 L 250.292969 328.042969 C 257.320312 335.375 267.195312 340.308594 277.367188 340.308594 C 290.230469 340.308594 297.859375 333.878906 297.859375 324.304688 C 297.859375 314.28125 290.828125 311.140625 281.554688 306.953125 L 267.492188 300.820312 C 258.21875 296.929688 247.597656 289.902344 247.597656 275.539062 C 247.597656 260.582031 260.613281 249.515625 278.414062 249.515625 C 290.082031 249.515625 300.402344 254.449219 307.429688 261.628906 L 300.699219 269.707031 C 294.71875 264.023438 287.539062 260.433594 278.414062 260.433594 C 267.492188 260.433594 260.164062 265.96875 260.164062 274.792969 C 260.164062 284.21875 268.691406 287.808594 276.46875 291.097656 L 290.378906 297.082031 C 301.746094 302.015625 310.574219 308.746094 310.574219 323.257812 C 310.574219 338.8125 297.859375 351.230469 277.214844 351.230469 C 263.453125 351.230469 251.339844 345.546875 242.8125 336.71875 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(22.322083%,20.909119%,21.260071%);fill-opacity:1;" />
						<path
							 id="path36"
							 d="M 329.871094 251.308594 L 342.285156 251.308594 L 342.285156 349.433594 L 329.871094 349.433594 L 329.871094 251.308594 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(22.322083%,20.909119%,21.260071%);fill-opacity:1;" />
						<path
							 id="path38"
							 d="M 105.394531 177.816406 C 97.296875 172.222656 96.578125 163.339844 101.046875 156.875 C 103.195312 153.765625 105.914062 152.363281 108.671875 151.644531 L 110.464844 156.964844 C 108.441406 157.464844 106.949219 158.253906 105.890625 159.785156 C 103.199219 163.683594 104.53125 168.617188 109.417969 171.992188 C 114.253906 175.335938 119.304688 174.886719 121.929688 171.085938 C 123.226562 169.207031 123.480469 166.832031 123.300781 164.664062 L 128.65625 164.9375 C 129.0625 168.574219 128.070312 172.117188 126.160156 174.882812 C 121.589844 181.496094 113.4375 183.375 105.394531 177.816406 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,100%,100%);fill-opacity:1;" />
						<path
							 id="path40"
							 d="M 139.015625 145.140625 L 128.839844 135.90625 C 126.136719 136.210938 124.316406 137.230469 122.984375 138.699219 C 120.445312 141.496094 121.011719 146.144531 125.589844 150.296875 C 130.296875 154.566406 134.441406 155.089844 137.304688 151.933594 C 138.839844 150.246094 139.371094 148.136719 139.015625 145.140625 Z M 120.835938 155.621094 C 113.726562 149.171875 113.441406 140.734375 117.757812 135.980469 C 120.015625 133.492188 122.359375 132.78125 125.355469 132.425781 L 121.683594 129.417969 L 113.777344 122.242188 L 118.410156 117.132812 L 149.78125 145.59375 L 145.953125 149.8125 L 143.273438 148.03125 L 143.113281 148.210938 C 143.261719 151.261719 142.535156 154.652344 140.398438 157.007812 C 135.4375 162.472656 128.035156 162.152344 120.835938 155.621094 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,100%,100%);fill-opacity:1;" />
						<path
							 id="path42"
							 d="M 269.574219 44.261719 L 276.339844 43.828125 L 278.027344 70.234375 L 278.207031 70.222656 L 288.238281 55.992188 L 295.78125 55.511719 L 286.488281 68.128906 L 298.679688 84.84375 L 291.195312 85.324219 L 282.835938 73.050781 L 278.5625 78.613281 L 279.039062 86.101562 L 272.273438 86.53125 L 269.574219 44.261719 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,100%,100%);fill-opacity:1;" />
						<path
							 id="path44"
							 d="M 318.769531 66.742188 C 319.042969 63.09375 316.992188 60.773438 314.117188 60.558594 C 311.246094 60.34375 308.816406 62.269531 308.539062 65.976562 C 308.257812 69.746094 310.371094 72.070312 313.242188 72.285156 C 316.054688 72.496094 318.488281 70.515625 318.769531 66.742188 Z M 320.617188 90.347656 C 320.785156 88.074219 318.980469 87.277344 315.628906 87.027344 L 311.621094 86.726562 C 310.003906 86.605469 308.757812 86.390625 307.644531 86.007812 C 305.996094 87.089844 305.179688 88.351562 305.078125 89.726562 C 304.882812 92.359375 307.636719 94.128906 312.304688 94.480469 C 317.03125 94.832031 320.425781 92.859375 320.617188 90.347656 Z M 299.257812 90.3125 C 299.441406 87.859375 301.097656 85.820312 303.917969 84.34375 L 303.933594 84.105469 C 302.511719 83.035156 301.488281 81.394531 301.667969 79.003906 C 301.839844 76.730469 303.542969 74.871094 305.308594 73.800781 L 305.324219 73.558594 C 303.460938 71.917969 301.816406 68.964844 302.078125 65.492188 C 302.582031 58.734375 308.308594 55.371094 314.472656 55.832031 C 316.089844 55.953125 317.5625 56.363281 318.726562 56.871094 L 329.257812 57.660156 L 328.878906 62.746094 L 323.492188 62.34375 C 324.363281 63.550781 324.949219 65.398438 324.796875 67.433594 C 324.308594 73.957031 319.144531 77.058594 312.917969 76.59375 C 311.664062 76.5 310.246094 76.152344 308.96875 75.515625 C 308.011719 76.226562 307.421875 76.90625 307.324219 78.222656 C 307.199219 79.898438 308.316406 81.003906 311.90625 81.273438 L 317.113281 81.660156 C 324.175781 82.1875 327.722656 84.621094 327.34375 89.707031 C 326.910156 95.511719 320.464844 99.601562 310.890625 98.886719 C 303.890625 98.363281 298.875 95.460938 299.257812 90.3125 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,100%,100%);fill-opacity:1;" />
						<path
							 id="path46"
							 d="M 473.050781 130.691406 L 476.570312 135.171875 L 473.707031 138.035156 L 473.855469 138.222656 C 477.453125 138.523438 480.882812 139.492188 483.144531 142.367188 C 485.816406 145.765625 485.777344 148.921875 484.039062 152.046875 C 488.140625 152.40625 491.746094 153.308594 494.046875 156.234375 C 497.902344 161.136719 496.335938 166.035156 490.488281 170.632812 L 475.960938 182.054688 L 471.660156 176.582031 L 485.476562 165.71875 C 489.296875 162.714844 489.824219 160.46875 487.933594 158.0625 C 486.78125 156.601562 484.578125 155.742188 481.234375 155.46875 L 465.058594 168.1875 L 460.796875 162.765625 L 474.613281 151.898438 C 478.433594 148.894531 478.957031 146.652344 477.027344 144.199219 C 475.917969 142.785156 473.675781 141.875 470.332031 141.605469 L 454.15625 154.324219 L 449.894531 148.898438 L 473.050781 130.691406 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,100%,100%);fill-opacity:1;" />
						<path
							 id="path48"
							 d="M 508.691406 333.113281 L 512.269531 337.28125 C 509.683594 339.386719 507.878906 341.550781 507.195312 344.472656 C 506.46875 347.566406 507.585938 349.371094 509.570312 349.835938 C 511.964844 350.398438 513.742188 347.550781 515.625 344.785156 C 517.917969 341.320312 521.078125 337.5625 525.867188 338.6875 C 530.890625 339.867188 533.507812 344.734375 532 351.15625 C 531.066406 355.128906 528.675781 357.957031 526.316406 359.867188 L 522.957031 355.8125 C 524.882812 354.171875 526.355469 352.359375 526.890625 350.082031 C 527.5625 347.21875 526.535156 345.5625 524.722656 345.136719 C 522.445312 344.601562 520.898438 347.257812 519.0625 350.089844 C 516.683594 353.660156 513.800781 357.546875 508.425781 356.285156 C 503.519531 355.132812 500.46875 350.285156 502.167969 343.042969 C 503.085938 339.132812 505.753906 335.382812 508.691406 333.113281 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,100%,100%);fill-opacity:1;" />
						<path
							 id="path50"
							 d="M 77.484375 394.226562 L 75.640625 388.835938 L 79.285156 387.078125 L 79.207031 386.851562 C 75.914062 385.378906 72.996094 383.335938 71.808594 379.871094 C 70.410156 375.785156 71.484375 372.816406 74.160156 370.441406 C 70.410156 368.746094 67.300781 366.703125 66.09375 363.1875 C 64.074219 357.28125 67.171875 353.179688 74.207031 350.769531 L 91.691406 344.78125 L 93.945312 351.367188 L 77.316406 357.0625 C 72.71875 358.636719 71.480469 360.582031 72.472656 363.476562 C 73.074219 365.234375 74.871094 366.773438 77.9375 368.136719 L 97.40625 361.46875 L 99.640625 367.996094 L 83.007812 373.691406 C 78.414062 375.265625 77.175781 377.210938 78.1875 380.160156 C 78.769531 381.863281 80.585938 383.464844 83.652344 384.820312 L 103.117188 378.15625 L 105.355469 384.683594 L 77.484375 394.226562 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,100%,100%);fill-opacity:1;" />
						<path
							 id="path52"
							 d="M 73.742188 321.398438 C 67.863281 322.234375 64.375 325.398438 64.984375 329.679688 C 65.59375 333.953125 69.820312 335.957031 75.699219 335.117188 C 81.523438 334.289062 85.019531 331.183594 84.410156 326.90625 C 83.800781 322.628906 79.566406 320.566406 73.742188 321.398438 Z M 76.699219 342.128906 C 66.957031 343.519531 60.433594 337.722656 59.398438 330.472656 C 58.355469 323.167969 63 315.777344 72.742188 314.386719 C 82.425781 313.003906 88.953125 318.804688 89.992188 326.109375 C 91.027344 333.355469 86.382812 340.746094 76.699219 342.128906 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,100%,100%);fill-opacity:1;" />
						<path
							 id="path54"
							 d="M 79.8125 306.777344 L 45.03125 307.851562 L 44.816406 300.957031 L 79.960938 299.871094 C 81.640625 299.820312 82.214844 299.023438 82.195312 298.300781 C 82.183594 298.003906 82.175781 297.761719 82.039062 297.226562 L 87.171875 296.167969 C 87.558594 296.996094 87.832031 298.1875 87.882812 299.808594 C 88.035156 304.726562 84.910156 306.621094 79.8125 306.777344 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,100%,100%);fill-opacity:1;" />
						<path
							 id="path56"
							 d="M 198.953125 476.394531 L 205.207031 479.449219 L 197.382812 495.460938 L 197.546875 495.539062 L 217.929688 485.664062 L 224.882812 489.0625 L 207.332031 497.515625 L 209.492188 525.214844 L 202.59375 521.84375 L 201.160156 500.574219 L 193.011719 504.410156 L 187.980469 514.707031 L 181.726562 511.652344 L 198.953125 476.394531 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,100%,100%);fill-opacity:1;" />
						<path
							 id="path58"
							 d="M 391.300781 503.335938 L 400.359375 499.046875 L 397.058594 495.300781 C 394.148438 492.097656 391.191406 488.519531 388.3125 485.101562 L 388.097656 485.203125 C 388.992188 489.625 389.863281 494.125 390.496094 498.40625 Z M 382.316406 481.96875 L 389.691406 478.476562 L 418.03125 508.472656 L 411.414062 511.605469 L 404.105469 503.316406 L 392.175781 508.964844 L 393.953125 519.871094 L 387.554688 522.902344 L 382.316406 481.96875 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,100%,100%);fill-opacity:1;" />
						<path
							 id="path60"
							 d="M 169.769531 218.679688 L 172.171875 215.085938 L 180.710938 223.621094 L 180.796875 223.488281 L 177.296875 207.398438 L 179.9375 203.4375 L 183.242188 217.230469 L 199.617188 221.085938 L 197.128906 224.8125 L 183.726562 221.402344 L 185.101562 227.992188 L 191.046875 233.933594 L 188.648438 237.527344 L 169.769531 218.679688 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(22.322083%,20.909119%,21.260071%);fill-opacity:1;" />
						<path
							 id="path62"
							 d="M 207.03125 224.421875 C 204.148438 221.90625 204.265625 218.441406 206.273438 216.140625 C 207.242188 215.035156 208.355469 214.613281 209.453125 214.457031 L 209.910156 216.59375 C 209.105469 216.695312 208.492188 216.933594 208.019531 217.480469 C 206.804688 218.867188 207.101562 220.832031 208.839844 222.351562 C 210.5625 223.855469 212.53125 223.902344 213.714844 222.550781 C 214.296875 221.882812 214.5 220.976562 214.527344 220.132812 L 216.585938 220.476562 C 216.582031 221.894531 216.042969 223.222656 215.183594 224.207031 C 213.125 226.558594 209.894531 226.925781 207.03125 224.421875 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(22.322083%,20.909119%,21.260071%);fill-opacity:1;" />
						<path
							 id="path64"
							 d="M 220.28125 214 L 216.582031 210.148438 C 215.527344 210.195312 214.792969 210.542969 214.238281 211.074219 C 213.179688 212.09375 213.273438 213.910156 214.9375 215.640625 C 216.652344 217.425781 218.246094 217.738281 219.4375 216.589844 C 220.078125 215.976562 220.339844 215.171875 220.28125 214 Z M 212.953125 217.582031 C 210.367188 214.890625 210.484375 211.609375 212.28125 209.882812 C 213.222656 208.976562 214.152344 208.765625 215.324219 208.707031 L 213.980469 207.441406 L 211.105469 204.449219 L 213.039062 202.589844 L 224.445312 214.460938 L 222.847656 215.996094 L 221.859375 215.234375 L 221.789062 215.300781 C 221.765625 216.488281 221.394531 217.78125 220.503906 218.640625 C 218.433594 220.628906 215.570312 220.304688 212.953125 217.582031 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(22.322083%,20.909119%,21.260071%);fill-opacity:1;" />
						<path
							 id="path66"
							 d="M 294.023438 145.214844 L 298.300781 145.234375 L 296.539062 153.546875 L 295.765625 156.382812 L 295.925781 156.382812 C 297.933594 154.671875 300.058594 153.363281 302.417969 153.375 C 305.699219 153.390625 307.050781 155.199219 307.03125 158.355469 C 307.027344 159.277344 306.945312 160.078125 306.699219 161.113281 L 304.15625 173.5 L 299.875 173.480469 L 302.335938 161.652344 C 302.5 160.734375 302.664062 160.175781 302.667969 159.574219 C 302.675781 157.894531 301.878906 157.050781 300.199219 157.042969 C 298.839844 157.035156 297.316406 157.949219 295.226562 160.058594 L 292.519531 173.441406 L 288.199219 173.417969 L 294.023438 145.214844 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(22.322083%,20.909119%,21.260071%);fill-opacity:1;" />
						<path
							 id="path68"
							 d="M 396.144531 209.976562 C 401.679688 205.625 409.238281 206.242188 413.019531 211.054688 C 414.503906 212.941406 414.664062 214.953125 414.324219 216.59375 L 410.796875 216.3125 C 411.046875 214.949219 410.929688 214.023438 410.113281 212.984375 C 407.9375 210.21875 402.828125 210.320312 398.992188 213.335938 C 396.664062 215.164062 396.128906 217.265625 397.761719 219.339844 C 398.703125 220.535156 400.007812 221.03125 401.257812 221.324219 L 400.253906 224.453125 C 398.492188 223.957031 396.3125 223.125 394.484375 220.800781 C 391.8125 217.402344 392.15625 213.117188 396.144531 209.976562 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(22.322083%,20.909119%,21.260071%);fill-opacity:1;" />
						<path
							 id="path70"
							 d="M 422.964844 323.359375 L 433.734375 321.671875 L 442.15625 320.492188 L 442.183594 320.332031 L 434.566406 316.578125 L 424.882812 311.59375 Z M 424.582031 306.480469 L 446.304688 318.410156 L 445.425781 323.820312 L 421.039062 328.195312 L 418.277344 327.746094 L 421.816406 306.027344 L 424.582031 306.480469 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(22.322083%,20.909119%,21.260071%);fill-opacity:1;" />
						<path
							 id="path72"
							 d="M 414.972656 335.429688 L 428.492188 335.417969 C 429.382812 335.417969 430.292969 335.324219 431.222656 335.140625 C 432.148438 334.957031 432.742188 334.480469 433.003906 333.699219 C 433.128906 333.328125 433.183594 332.894531 433.171875 332.398438 L 433.910156 332.355469 L 434.246094 337.601562 L 433.972656 338.414062 L 418.101562 338.5 L 423.253906 343.589844 C 424.175781 344.519531 424.953125 345.089844 425.582031 345.300781 C 426.089844 345.472656 426.832031 345.605469 427.816406 345.699219 C 428.539062 345.765625 429.066406 345.851562 429.398438 345.964844 C 430.621094 346.375 431.007812 347.242188 430.566406 348.5625 C 430.171875 349.734375 429.417969 350.132812 428.308594 349.761719 C 427.210938 349.390625 425.386719 347.871094 422.835938 345.199219 L 414.597656 336.539062 L 414.972656 335.429688 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(22.322083%,20.909119%,21.260071%);fill-opacity:1;" />
						<path
							 id="path74"
							 transform="matrix(0.1,0,0,-0.1,0,595.28)"
							 d="M 4149.726562 2598.503125 L 4284.921875 2598.620313 C 4293.828125 2598.620313 4302.929688 2599.557813 4312.226562 2601.39375 C 4321.484375 2603.229688 4327.421875 2607.995313 4330.039062 2615.807813 C 4331.289062 2619.51875 4331.835938 2623.854688 4331.71875 2628.815625 L 4339.101562 2629.245313 L 4342.460938 2576.784375 L 4339.726562 2568.659375 L 4181.015625 2567.8 L 4232.539062 2516.901563 C 4241.757812 2507.604688 4249.53125 2501.901563 4255.820312 2499.792188 C 4260.898438 2498.073438 4268.320312 2496.745313 4278.164062 2495.807813 C 4285.390625 2495.14375 4290.664062 2494.284375 4293.984375 2493.151563 C 4306.210938 2489.05 4310.078125 2480.378125 4305.664062 2467.175 C 4301.71875 2455.45625 4294.179688 2451.471875 4283.085938 2455.182813 C 4272.109375 2458.89375 4253.867188 2474.089063 4228.359375 2500.807813 L 4145.976562 2587.409375 Z M 4149.726562 2598.503125 "
							 style="fill:none;stroke-width:5;stroke-linecap:butt;stroke-linejoin:miter;stroke:rgb(22.322083%,20.909119%,21.260071%);stroke-opacity:1;stroke-miterlimit:10;" />
						<path
							 id="path76"
							 d="M 154.769531 343.476562 L 153.640625 339.386719 L 166.898438 330.429688 L 171.929688 327.46875 L 171.886719 327.3125 C 169.21875 327.714844 165.878906 328.386719 162.980469 328.5625 L 150.902344 329.441406 L 149.800781 325.429688 L 176.40625 323.539062 L 177.523438 327.585938 L 164.296875 336.496094 L 159.183594 339.480469 L 159.226562 339.636719 C 162.011719 339.199219 165.179688 338.660156 168.078125 338.484375 L 180.273438 337.574219 L 181.367188 341.546875 L 154.769531 343.476562 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(22.322083%,20.909119%,21.260071%);fill-opacity:1;" />
						<path
							 id="path78"
							 d="M 182.085938 313.910156 L 181.605469 310.042969 L 179.820312 310.804688 C 178.285156 311.488281 176.601562 312.140625 174.988281 312.785156 L 175.003906 312.878906 C 176.742188 313.085938 178.507812 313.316406 180.164062 313.605469 Z M 173.101562 314.617188 L 172.714844 311.472656 L 187.238281 304.671875 L 187.589844 307.496094 L 183.636719 309.183594 L 184.265625 314.273438 L 188.507812 314.949219 L 188.84375 317.679688 L 173.101562 314.617188 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(22.322083%,20.909119%,21.260071%);fill-opacity:1;" />
						<path
							 id="path80"
							 d="M 243.261719 403.507812 L 247.109375 405.386719 L 236.113281 419.78125 L 236.257812 419.851562 L 248.078125 415.433594 L 252.386719 417.539062 L 241.585938 421.609375 L 240.855469 433.761719 L 236.972656 431.863281 L 237.785156 422.558594 L 232.628906 424.355469 L 229.640625 428.28125 L 225.761719 426.386719 L 243.261719 403.507812 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(22.322083%,20.909119%,21.260071%);fill-opacity:1;" />
						<path
							 id="path82"
							 d="M 359.894531 418.46875 C 359.78125 417.945312 359.613281 417.40625 359.339844 416.828125 C 358.519531 415.09375 357.058594 413.882812 354.890625 414.90625 C 352.757812 415.917969 351.480469 418.734375 352.046875 422.183594 Z M 353.941406 411.683594 C 358.0625 409.734375 360.933594 411.871094 362.675781 415.558594 C 363.414062 417.113281 363.675781 418.980469 363.695312 419.679688 L 352.886719 424.792969 C 354.269531 428.742188 357.117188 429.339844 359.792969 428.074219 C 361.058594 427.476562 362.109375 426.140625 362.742188 424.953125 L 365.367188 426.765625 C 364.402344 428.460938 362.714844 430.320312 360.183594 431.519531 C 355.953125 433.519531 351.761719 432.140625 349.503906 427.367188 C 346.371094 420.753906 349.277344 413.890625 353.941406 411.683594 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(22.322083%,20.909119%,21.260071%);fill-opacity:1;" />
					</g>
				</svg>
			</xsl:when>
			<xsl:when test="$si-aspect = 'm_c_deltanu'">
				<svg
					 xmlns:dc="http://purl.org/dc/elements/1.1/"
					 xmlns:cc="http://creativecommons.org/ns#"
					 xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
					 xmlns:svg="http://www.w3.org/2000/svg"
					 xmlns="http://www.w3.org/2000/svg"
					 viewBox="0 0 793.70667 793.70667"
					 height="793.70667"
					 width="793.70667"
					 xml:space="preserve"
					 id="svg2"
					 version="1.1"><metadata
						 id="metadata8"><rdf:RDF><cc:Work
								 rdf:about=""><dc:format>image/svg+xml</dc:format><dc:type
									 rdf:resource="http://purl.org/dc/dcmitype/StillImage" /></cc:Work></rdf:RDF></metadata><defs
						 id="defs6" /><g
						 transform="matrix(1.3333333,0,0,-1.3333333,0,793.70667)"
						 id="g10"><g
							 transform="scale(0.1)"
							 id="g12"><path
								 id="path14"
								 style="fill:#bdbcbc;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 2200.47,4489.45 -492.3,1022.27 C 973.332,5143.46 420.902,4465.26 222.191,3648.49 L 1327.98,3396.1 c 121.17,477.04 444.11,873.25 872.49,1093.35" /><path
								 id="path16"
								 style="fill:#bdbcbc;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 4677.18,2976.13 c 0,-385.75 -128.6,-741.36 -345.02,-1026.69 l 886.73,-707.16 c 371.14,479.32 592.16,1080.74 592.16,1733.85 0,202.15 -21.33,399.29 -61.56,589.46 L 4643.65,3313.18 c 21.91,-108.96 33.53,-221.64 33.53,-337.05" /><path
								 id="path18"
								 style="fill:#bdbcbc;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 2976.4,5810.78 c -425.67,0 -829.34,-94.01 -1191.63,-262.11 L 2277.06,4526.4 c 213.38,96.41 449.97,150.52 699.34,150.52 249.35,0 485.93,-54.11 699.3,-150.51 L 4168,5548.68 c -362.28,168.09 -765.94,262.1 -1191.6,262.1" /><path
								 id="path20"
								 style="fill:#f2592d;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="M 4624.82,3396.1 5730.6,3648.5 C 5531.89,4465.28 4979.45,5143.48 4244.59,5511.74 L 3752.3,4489.46 c 428.39,-220.09 751.34,-616.3 872.52,-1093.36" /><path
								 id="path22"
								 style="fill:#bdbcbc;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 1275.61,2976.13 c 0,115.41 11.63,228.09 33.53,337.04 L 203.293,3565.58 c -40.223,-190.17 -61.543,-387.3 -61.543,-589.45 0,-653.1 221.016,-1254.52 592.141,-1733.83 l 886.739,707.15 c -216.42,285.34 -345.02,640.94 -345.02,1026.68" /><path
								 id="path24"
								 style="fill:#bdbcbc;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="M 2933.86,142.031 V 1276.42 c -505.75,12.46 -956.65,245.33 -1260.14,606.61 L 786.848,1175.77 C 1298.35,554.398 2069.24,154.762 2933.86,142.031" /><path
								 id="path26"
								 style="fill:#bdbcbc;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 3018.9,142.02 c 864.63,12.73 1635.52,412.371 2147.04,1033.73 l -886.88,707.27 C 3975.57,1521.73 3524.66,1288.86 3018.9,1276.42 V 142.02" /><path
								 id="path28"
								 style="fill:#deddde;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 3675.7,4526.41 c -213.37,96.4 -449.95,150.51 -699.3,150.51 -249.37,0 -485.96,-54.11 -699.34,-150.52 l 699.32,-1452.14 699.32,1452.15" /><path
								 id="path30"
								 style="fill:#deddde;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 1309.14,3313.17 c -21.9,-108.95 -33.53,-221.63 -33.53,-337.04 0,-385.74 128.6,-741.34 345.02,-1026.68 l 1260.2,1004.99 -1571.69,358.73" /><path
								 id="path32"
								 style="fill:#deddde;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 3018.9,1276.42 c 505.76,12.44 956.67,245.31 1260.16,606.6 L 3018.9,2887.95 V 1276.42" /><path
								 id="path34"
								 style="fill:#fbcb78;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 4643.65,3313.18 -1571.72,-358.74 1260.23,-1005 c 216.42,285.33 345.02,640.94 345.02,1026.69 0,115.41 -11.62,228.09 -33.53,337.05" /><path
								 id="path36"
								 style="fill:#deddde;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="M 2200.47,4489.45 C 1772.09,4269.35 1449.15,3873.14 1327.98,3396.1 l 1571.78,-358.75 -699.29,1452.1" /><path
								 id="path38"
								 style="fill:#f8a67f;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 4624.82,3396.1 c -121.18,477.06 -444.13,873.27 -872.52,1093.36 L 3053,3037.35 4624.82,3396.1" /><path
								 id="path40"
								 style="fill:#deddde;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 1673.72,1883.03 c 303.49,-361.28 754.39,-594.15 1260.14,-606.61 V 2887.95 L 1673.72,1883.03" /><path
								 id="path42"
								 style="fill:#ec008c;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 786.848,1175.77 c -18.016,21.87 -35.594,44.11 -52.957,66.53" /><path
								 id="path44"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 3968.53,2976.13 c 0,-547.93 -444.19,-992.12 -992.13,-992.12 -547.94,0 -992.13,444.19 -992.13,992.12 0,547.94 444.19,992.13 992.13,992.13 547.94,0 992.13,-444.19 992.13,-992.13" /><path
								 id="path46"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 2428.12,2585.6 74.8,86.76 c 70.3,-73.3 169.03,-122.66 270.74,-122.66 128.64,0 204.93,64.32 204.93,160.05 0,100.22 -70.32,131.64 -163.05,173.52 l -140.61,61.33 c -92.73,38.89 -198.94,109.19 -198.94,252.79 0,149.58 130.14,260.28 308.14,260.28 116.68,0 219.89,-49.37 290.18,-121.17 L 3007,3255.73 c -59.82,56.84 -131.62,92.74 -222.87,92.74 -109.2,0 -182.5,-55.35 -182.5,-143.6 0,-94.24 85.28,-130.13 163.05,-163.04 l 139.12,-59.84 c 113.67,-49.36 201.93,-116.67 201.93,-261.77 0,-155.56 -127.14,-279.71 -333.57,-279.71 -137.62,0 -258.77,56.84 -344.04,145.09" /><path
								 id="path48"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 3298.7,3439.72 h 124.16 V 2458.46 H 3298.7 v 981.26" /><path
								 id="path50"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 1053.94,4174.64 c -80.96,55.93 -88.147,144.75 -43.46,209.41 21.49,31.1 48.67,45.13 76.25,52.33 l 17.93,-53.22 c -20.23,-4.99 -35.18,-12.9 -45.74,-28.2 -26.94,-39 -13.61,-88.32 35.25,-122.08 48.38,-33.42 98.89,-28.93 125.14,9.08 12.97,18.76 15.51,42.51 13.71,64.18 l 53.55,-2.72 c 4.05,-36.35 -5.85,-71.8 -24.96,-99.44 -45.7,-66.15 -127.22,-84.93 -207.67,-29.34" /><path
								 id="path52"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 1390.15,4501.41 -101.76,92.31 c -27.03,-3.01 -45.23,-13.24 -58.53,-27.9 -25.39,-28 -19.75,-74.44 26.03,-115.97 47.09,-42.73 88.54,-47.93 117.17,-16.38 15.31,16.88 20.66,37.95 17.09,67.94 z m -181.8,-104.83 c -71.09,64.5 -73.92,148.88 -30.78,196.43 22.58,24.88 46.02,31.96 76,35.55 l -36.72,30.07 -79.08,71.75 46.34,51.1 313.71,-284.61 -38.3,-42.21 -26.77,17.81 -1.6,-1.78 c 1.46,-30.51 -5.81,-64.42 -27.17,-87.97 -49.59,-54.65 -123.64,-51.45 -195.63,13.86" /><path
								 id="path54"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 2695.73,5510.2 67.66,4.32 16.88,-264.05 1.79,0.12 100.32,142.27 75.44,4.83 -92.92,-126.18 121.89,-167.15 -74.82,-4.79 -83.62,122.72 -42.73,-55.64 4.78,-74.85 -67.65,-4.32 -27.02,422.72" /><path
								 id="path56"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 3187.71,5285.37 c 2.73,36.49 -17.8,59.7 -46.53,61.84 -28.71,2.15 -53,-17.1 -55.8,-54.18 -2.81,-37.7 18.32,-60.94 47.03,-63.1 28.13,-2.1 52.49,17.73 55.3,55.44 z m 18.45,-236.05 c 1.7,22.74 -16.36,30.72 -49.86,33.22 l -40.1,3 c -16.15,1.21 -28.63,3.34 -39.76,7.18 -16.47,-10.8 -24.63,-23.43 -25.65,-37.19 -1.97,-26.33 25.59,-44.03 72.27,-47.52 47.26,-3.54 81.21,16.2 83.1,41.31 z m -213.57,0.34 c 1.84,24.53 18.4,44.95 46.58,59.7 l 0.18,2.39 c -14.24,10.68 -24.45,27.1 -22.66,51.02 1.7,22.74 18.73,41.33 36.39,52.05 l 0.17,2.39 c -18.63,16.42 -35.07,45.93 -32.48,80.65 5.06,67.6 62.33,101.23 123.95,96.62 16.17,-1.21 30.9,-5.32 42.56,-10.4 l 105.31,-7.87 -3.81,-50.87 -53.87,4.04 c 8.74,-12.09 14.57,-30.58 13.05,-50.93 -4.88,-65.21 -56.52,-96.24 -118.77,-91.59 -12.56,0.93 -26.74,4.4 -39.49,10.77 -9.57,-7.11 -15.49,-13.88 -16.47,-27.05 -1.25,-16.75 9.95,-27.82 45.84,-30.5 l 52.08,-3.89 c 70.6,-5.28 106.09,-29.59 102.28,-80.46 -4.34,-58.04 -68.77,-98.94 -164.51,-91.79 -70,5.24 -120.18,34.25 -116.33,85.72" /><path
								 id="path58"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 4730.5,4645.88 35.22,-44.81 -28.64,-28.61 1.49,-1.89 c 35.95,-3.02 70.27,-12.68 92.89,-41.45 26.7,-33.95 26.33,-65.52 8.92,-96.77 41.02,-3.62 77.09,-12.63 100.1,-41.88 38.56,-49.04 22.87,-98.01 -35.6,-143.99 l -145.26,-114.22 -43.01,54.71 138.17,108.65 c 38.2,30.04 43.45,52.48 24.55,76.54 -11.51,14.62 -33.56,23.23 -66.97,25.95 l -161.76,-127.19 -42.64,54.24 138.17,108.64 c 38.2,30.04 43.45,52.49 24.16,77 -11.12,14.15 -33.52,23.24 -66.96,25.97 l -161.76,-127.2 -42.63,54.23 231.56,182.08" /><path
								 id="path60"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 5086.91,2621.67 35.8,-41.69 c -25.88,-21.04 -43.91,-42.69 -50.76,-71.89 -7.27,-30.94 3.9,-48.98 23.77,-53.64 23.94,-5.62 41.71,22.86 60.52,50.49 22.93,34.67 54.55,72.24 102.44,60.98 50.24,-11.79 76.39,-60.45 61.31,-124.7 -9.33,-39.72 -33.22,-68 -56.81,-87.11 l -33.62,40.56 c 19.26,16.43 34.01,34.54 39.34,57.31 6.72,28.62 -3.56,45.22 -21.66,49.46 -22.77,5.36 -38.24,-21.22 -56.62,-49.55 -23.79,-35.71 -52.62,-74.54 -106.35,-61.93 -49.06,11.53 -79.59,59.98 -62.6,132.4 9.2,39.12 35.88,76.61 65.24,99.31" /><path
								 id="path62"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 774.855,2010.55 -18.457,53.91 36.465,17.56 -0.781,2.28 c -32.93,14.71 -62.129,35.15 -73.984,69.77 -14.004,40.87 -3.243,70.57 23.515,94.3 -37.519,16.96 -68.613,37.39 -80.664,72.57 -20.215,59.03 10.762,100.08 81.133,124.18 l 174.824,59.86 22.539,-65.84 -166.289,-56.95 c -45.976,-15.74 -58.34,-35.19 -48.418,-64.14 6.016,-17.6 23.965,-33 54.629,-46.61 l 194.688,66.67 22.343,-65.27 -166.308,-56.95 c -45.957,-15.74 -58.34,-35.19 -48.223,-64.71 5.84,-17.02 23.985,-33.01 54.649,-46.6 l 194.664,66.66 22.37,-65.27 -278.695,-95.42" /><path
								 id="path64"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 737.434,2738.83 c -58.809,-8.39 -93.692,-40.03 -87.598,-82.81 6.113,-42.77 48.359,-62.8 107.168,-54.41 58.223,8.3 93.203,39.35 87.09,82.12 -6.094,42.77 -48.438,63.41 -106.66,55.1 z m 29.57,-207.32 c -97.422,-13.9 -162.676,44.08 -173.008,116.56 -10.43,73.06 36.016,146.97 133.438,160.86 96.836,13.82 162.089,-44.17 172.5,-117.23 10.332,-72.47 -36.094,-146.38 -132.93,-160.19" /><path
								 id="path66"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 798.137,2885.01 -347.832,-10.72 -2.129,68.96 351.445,10.84 c 16.777,0.51 22.539,8.49 22.324,15.69 -0.097,2.99 -0.175,5.4 -1.543,10.76 l 51.309,10.59 c 3.867,-8.28 6.621,-20.21 7.129,-36.4 1.504,-49.18 -29.727,-68.15 -80.703,-69.72" /><path
								 id="path68"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 1989.52,1188.87 62.54,-30.55 -78.22,-160.121 1.62,-0.777 203.83,98.748 69.55,-33.98 -175.53,-84.542 21.62,-276.988 -69,33.699 -14.32,212.68 -81.5,-38.328 -50.29,-102.969 -62.54,30.547 172.24,352.581" /><path
								 id="path70"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 3913.02,919.441 90.57,42.879 -33.01,37.481 c -29.1,32.009 -58.65,67.819 -87.44,101.989 l -2.17,-1.03 c 8.96,-44.21 17.66,-89.22 24,-132.018 z m -89.86,213.689 73.75,34.93 283.4,-299.99 -66.16,-31.32 -73.1,82.902 -119.3,-56.492 17.77,-109.078 -63.98,-30.293 -52.38,409.341" /><path
								 id="path72"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 1697.71,3766 23.98,35.94 85.41,-85.35 0.88,1.33 -35,160.9 26.41,39.6 33.02,-137.93 163.75,-38.55 -24.86,-37.27 -134.02,34.1 13.75,-65.91 59.45,-59.38 -23.98,-35.94 -188.79,188.46" /><path
								 id="path74"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 2070.31,3708.57 c -28.81,25.18 -27.66,59.8 -7.56,82.81 9.66,11.07 20.8,15.28 31.77,16.85 l 4.57,-21.35 c -8.02,-1.04 -14.16,-3.43 -18.9,-8.87 -12.13,-13.88 -9.16,-33.51 8.22,-48.71 17.23,-15.05 36.91,-15.54 48.75,-2.02 5.82,6.68 7.85,15.74 8.13,24.19 l 20.56,-3.41 c -0.04,-14.22 -5.43,-27.48 -14.02,-37.31 -20.59,-23.54 -52.89,-27.2 -81.52,-2.18" /><path
								 id="path76"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 2202.82,3812.8 -36.99,38.51 c -10.56,-0.45 -17.91,-3.94 -23.45,-9.27 -10.59,-10.18 -9.63,-28.34 7.01,-45.66 17.13,-17.83 33.06,-20.95 45,-9.47 6.4,6.14 9.02,14.17 8.43,25.89 z m -73.28,-35.82 c -25.86,26.91 -24.7,59.71 -6.72,77 9.42,9.05 18.7,11.17 30.43,11.76 l -13.43,12.64 -28.77,29.93 19.33,18.58 114.09,-118.71 -15.98,-15.35 -9.9,7.62 -0.69,-0.65 c -0.23,-11.87 -3.94,-24.83 -12.87,-33.39 -20.68,-19.88 -49.31,-16.67 -75.49,10.57" /><path
								 id="path78"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 2940.23,4500.67 42.79,-0.22 -17.64,-83.11 -7.73,-28.35 h 1.6 c 20.08,17.09 41.35,30.18 64.94,30.06 32.79,-0.17 46.31,-18.23 46.13,-49.82 -0.03,-9.2 -0.87,-17.2 -3.34,-27.58 l -25.42,-123.85 -42.8,0.22 24.61,118.25 c 1.64,9.19 3.28,14.78 3.3,20.78 0.08,16.8 -7.87,25.23 -24.67,25.32 -13.59,0.07 -28.82,-9.05 -49.74,-30.13 l -27.07,-133.84 -43.19,0.21 58.23,282.06" /><path
								 id="path80"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 3961.46,3853.03 c 55.33,43.51 130.94,37.33 168.75,-10.77 14.84,-18.86 16.42,-38.98 13.02,-55.38 l -35.25,2.79 c 2.48,13.65 1.31,22.91 -6.83,33.28 -21.76,27.66 -72.86,26.66 -111.22,-3.51 -23.28,-18.29 -28.63,-39.29 -12.3,-60.05 9.39,-11.94 22.46,-16.92 34.94,-19.84 l -10.02,-31.26 c -17.64,4.95 -39.41,13.25 -57.71,36.52 -26.72,33.95 -23.28,76.82 16.62,108.22" /><path
								 id="path82"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 4229.64,2719.2 107.72,16.89 84.21,11.8 0.26,1.58 -76.15,37.56 -96.86,49.82 z m 16.17,168.82 217.25,-119.33 -8.81,-54.09 -243.85,-43.75 -27.63,4.51 35.41,217.16 27.63,-4.5" /><path
								 id="path84"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 4149.72,2598.5 135.19,0.12 c 8.93,0.01 18.03,0.93 27.31,2.77 9.28,1.83 15.21,6.63 17.81,14.4 1.25,3.71 1.82,8.05 1.7,13.04 l 7.36,0.41 3.38,-52.44 -2.73,-8.15 -158.73,-0.85 51.52,-50.9 c 9.24,-9.28 17.01,-14.99 23.3,-17.1 5.06,-1.71 12.5,-3.03 22.35,-4.01 7.2,-0.62 12.48,-1.5 15.8,-2.63 12.22,-4.1 16.11,-12.77 11.68,-25.96 -3.95,-11.73 -11.47,-15.74 -22.58,-12.01 -10.98,3.7 -29.22,18.9 -54.73,45.61 l -82.38,86.59 3.75,11.11" /><path
								 id="path86"
								 style="fill:none;stroke:#393536;stroke-width:5;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:10;stroke-dasharray:none;stroke-opacity:1"
								 d="m 4149.72,2598.5 135.19,0.12 c 8.93,0.01 18.03,0.93 27.31,2.77 9.28,1.83 15.21,6.63 17.81,14.4 1.25,3.71 1.82,8.05 1.7,13.04 l 7.36,0.41 3.38,-52.44 -2.73,-8.15 -158.73,-0.85 51.52,-50.9 c 9.24,-9.28 17.01,-14.99 23.3,-17.1 5.06,-1.71 12.5,-3.03 22.35,-4.01 7.2,-0.62 12.48,-1.5 15.8,-2.63 12.22,-4.1 16.11,-12.77 11.68,-25.96 -3.95,-11.73 -11.47,-15.74 -22.58,-12.01 -10.98,3.7 -29.22,18.9 -54.73,45.61 l -82.38,86.59 z" /><path
								 id="path88"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 1547.69,2518.04 -11.27,40.88 132.56,89.59 50.33,29.62 -0.43,1.54 c -26.68,-4.03 -60.08,-10.74 -89.06,-12.49 l -120.78,-8.78 -11.04,40.1 266.07,18.92 11.16,-40.49 -132.27,-89.1 -51.11,-29.84 0.43,-1.54 c 27.83,4.35 59.53,9.76 88.49,11.52 l 121.96,9.09 10.93,-39.71 -265.97,-19.31" /><path
								 id="path90"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 1820.83,2813.71 -4.76,38.65 -17.87,-7.6 c -15.36,-6.84 -32.17,-13.36 -48.3,-19.82 l 0.13,-0.93 c 17.38,-2.08 35.06,-4.37 51.62,-7.25 z m -89.8,-7.09 -3.91,31.47 145.28,67.98 3.49,-28.22 -39.51,-16.86 6.29,-50.91 42.42,-6.76 3.36,-27.31 -157.42,30.61" /><path
								 id="path92"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 2432.63,1917.71 38.46,-18.79 -109.96,-143.92 1.44,-0.7 118.2,44.18 43.11,-21.08 -108.03,-40.69 -7.3,-121.54 -38.83,18.98 8.12,93.08 -51.54,-17.99 -29.88,-39.26 -38.81,18.97 175.02,228.76" /><path
								 id="path94"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 3598.94,1768.11 c -1.13,5.22 -2.81,10.62 -5.55,16.4 -8.2,17.36 -22.79,29.48 -44.49,19.22 -21.33,-10.1 -34.1,-38.26 -28.42,-72.75 z m -59.53,67.86 c 41.21,19.5 69.92,-1.88 87.36,-38.75 7.36,-15.55 10,-34.21 10.2,-41.21 l -108.11,-51.15 c 13.83,-39.48 42.32,-45.47 69.08,-32.81 12.66,5.99 23.15,19.36 29.47,31.21 l 26.27,-18.11 c -9.66,-16.96 -26.52,-35.56 -51.85,-47.53 -42.31,-20.02 -84.22,-6.23 -106.8,41.49 -31.31,66.17 -2.26,134.78 44.38,156.86" /></g></g></svg>
			</xsl:when>
			<xsl:when test="$si-aspect = 'm_c'">
				<svg
					 xmlns:dc="http://purl.org/dc/elements/1.1/"
					 xmlns:cc="http://creativecommons.org/ns#"
					 xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
					 xmlns:svg="http://www.w3.org/2000/svg"
					 xmlns="http://www.w3.org/2000/svg"
					 viewBox="0 0 793.70667 793.70667"
					 height="793.70667"
					 width="793.70667"
					 xml:space="preserve"
					 id="svg2"
					 version="1.1"><metadata
						 id="metadata8"><rdf:RDF><cc:Work
								 rdf:about=""><dc:format>image/svg+xml</dc:format><dc:type
									 rdf:resource="http://purl.org/dc/dcmitype/StillImage" /></cc:Work></rdf:RDF></metadata><defs
						 id="defs6" /><g
						 transform="matrix(1.3333333,0,0,-1.3333333,0,793.70667)"
						 id="g10"><g
							 transform="scale(0.1)"
							 id="g12"><path
								 id="path14"
								 style="fill:#bdbcbc;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 2200.47,4489.45 -492.3,1022.27 C 973.332,5143.46 420.902,4465.26 222.191,3648.48 L 1327.98,3396.1 c 121.17,477.04 444.11,873.25 872.49,1093.35" /><path
								 id="path16"
								 style="fill:#bdbcbc;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 4677.18,2976.13 c 0,-385.75 -128.6,-741.36 -345.02,-1026.69 l 886.73,-707.15 c 371.14,479.31 592.16,1080.72 592.16,1733.84 0,202.15 -21.33,399.29 -61.56,589.46 L 4643.65,3313.18 c 21.91,-108.96 33.53,-221.64 33.53,-337.05" /><path
								 id="path18"
								 style="fill:#bdbcbc;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 2976.4,5810.77 c -425.67,0 -829.34,-94 -1191.63,-262.1 l 492.29,-1022.28 c 213.38,96.42 449.97,150.53 699.34,150.53 249.35,0 485.93,-54.11 699.3,-150.51 L 4168,5548.68 c -362.28,168.1 -765.94,262.09 -1191.6,262.09" /><path
								 id="path20"
								 style="fill:#f2592d;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="M 4624.82,3396.11 5730.6,3648.49 C 5531.89,4465.28 4979.45,5143.48 4244.59,5511.74 L 3752.3,4489.46 c 428.39,-220.09 751.34,-616.3 872.52,-1093.35" /><path
								 id="path22"
								 style="fill:#bdbcbc;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 1275.61,2976.13 c 0,115.41 11.63,228.09 33.53,337.04 L 203.293,3565.58 C 163.07,3375.42 141.75,3178.27 141.75,2976.13 c 0,-653.11 221.016,-1254.52 592.141,-1733.82 l 886.739,707.14 c -216.42,285.34 -345.02,640.94 -345.02,1026.68" /><path
								 id="path24"
								 style="fill:#bdbcbc;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="M 2933.86,142.031 V 1276.42 c -505.75,12.46 -956.65,245.33 -1260.14,606.61 L 786.848,1175.77 C 1298.35,554.41 2069.24,154.762 2933.86,142.031" /><path
								 id="path26"
								 style="fill:#bdbcbc;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 3018.9,142.02 c 864.63,12.73 1635.52,412.371 2147.04,1033.73 l -886.88,707.26 C 3975.57,1521.74 3524.66,1288.86 3018.9,1276.42 V 142.02" /><path
								 id="path28"
								 style="fill:#deddde;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 3675.7,4526.41 c -213.37,96.4 -449.95,150.51 -699.3,150.51 -249.37,0 -485.96,-54.11 -699.34,-150.53 l 699.32,-1452.13 699.32,1452.15" /><path
								 id="path30"
								 style="fill:#deddde;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 1309.14,3313.17 c -21.9,-108.95 -33.53,-221.63 -33.53,-337.04 0,-385.74 128.6,-741.34 345.02,-1026.68 l 1260.2,1004.99 -1571.69,358.73" /><path
								 id="path32"
								 style="fill:#deddde;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 3018.9,1276.42 c 505.76,12.44 956.67,245.32 1260.16,606.59 L 3018.9,2887.95 V 1276.42" /><path
								 id="path34"
								 style="fill:#deddde;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 4643.65,3313.18 -1571.72,-358.74 1260.23,-1005 c 216.42,285.33 345.02,640.94 345.02,1026.69 0,115.41 -11.62,228.09 -33.53,337.05" /><path
								 id="path36"
								 style="fill:#deddde;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="M 2200.47,4489.45 C 1772.09,4269.35 1449.15,3873.14 1327.98,3396.1 l 1571.78,-358.75 -699.29,1452.1" /><path
								 id="path38"
								 style="fill:#f8a67f;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 4624.82,3396.11 c -121.18,477.05 -444.13,873.26 -872.52,1093.35 L 3053,3037.35 4624.82,3396.11" /><path
								 id="path40"
								 style="fill:#deddde;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 1673.72,1883.03 c 303.49,-361.28 754.39,-594.15 1260.14,-606.61 V 2887.95 L 1673.72,1883.03" /><path
								 id="path42"
								 style="fill:#ec008c;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 786.848,1175.77 c -18.016,21.88 -35.594,44.11 -52.957,66.54" /><path
								 id="path44"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 3968.52,2976.13 c 0,-547.93 -444.19,-992.12 -992.12,-992.12 -547.94,0 -992.13,444.19 -992.13,992.12 0,547.93 444.19,992.12 992.13,992.12 547.93,0 992.12,-444.19 992.12,-992.12" /><path
								 id="path46"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 2428.12,2585.6 74.8,86.76 c 70.3,-73.3 169.03,-122.66 270.74,-122.66 128.64,0 204.93,64.32 204.93,160.05 0,100.22 -70.32,131.63 -163.05,173.52 l -140.61,61.33 c -92.73,38.89 -198.94,109.19 -198.94,252.79 0,149.58 130.14,260.27 308.14,260.27 116.68,0 219.89,-49.36 290.18,-121.16 L 3007,3255.72 c -59.82,56.85 -131.62,92.75 -222.87,92.75 -109.2,0 -182.5,-55.35 -182.5,-143.6 0,-94.24 85.28,-130.14 163.05,-163.05 l 139.12,-59.83 c 113.67,-49.36 201.93,-116.67 201.93,-261.77 0,-155.56 -127.14,-279.71 -333.57,-279.71 -137.62,0 -258.77,56.84 -344.04,145.09" /><path
								 id="path48"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 3298.7,3439.71 h 124.16 V 2458.45 H 3298.7 v 981.26" /><path
								 id="path50"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 1053.94,4174.64 c -80.96,55.92 -88.147,144.75 -43.46,209.41 21.49,31.1 48.67,45.13 76.25,52.32 l 17.93,-53.21 c -20.23,-4.99 -35.18,-12.9 -45.74,-28.2 -26.94,-39 -13.61,-88.32 35.25,-122.08 48.38,-33.42 98.89,-28.93 125.14,9.08 12.97,18.76 15.51,42.51 13.71,64.18 l 53.55,-2.72 c 4.05,-36.35 -5.85,-71.8 -24.96,-99.44 -45.7,-66.15 -127.22,-84.93 -207.67,-29.34" /><path
								 id="path52"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 1390.15,4501.4 -101.76,92.32 c -27.03,-3.01 -45.23,-13.24 -58.53,-27.9 -25.39,-28 -19.75,-74.45 26.03,-115.97 47.09,-42.73 88.54,-47.93 117.17,-16.39 15.31,16.89 20.66,37.96 17.09,67.94 z m -181.8,-104.83 c -71.09,64.51 -73.92,148.89 -30.78,196.44 22.58,24.88 46.02,31.96 76,35.55 l -36.72,30.07 -79.08,71.75 46.34,51.1 313.71,-284.61 -38.3,-42.21 -26.77,17.81 -1.6,-1.78 c 1.46,-30.51 -5.81,-64.42 -27.17,-87.97 -49.59,-54.65 -123.64,-51.45 -195.63,13.85" /><path
								 id="path54"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 2695.73,5510.2 67.66,4.32 16.88,-264.06 1.79,0.12 100.32,142.28 75.44,4.83 -92.92,-126.18 121.89,-167.15 -74.82,-4.79 -83.62,122.71 -42.73,-55.63 4.78,-74.85 -67.65,-4.32 -27.02,422.72" /><path
								 id="path56"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 3187.71,5285.37 c 2.73,36.49 -17.8,59.7 -46.53,61.84 -28.71,2.15 -53,-17.1 -55.8,-54.18 -2.81,-37.7 18.32,-60.95 47.03,-63.1 28.13,-2.1 52.49,17.73 55.3,55.44 z m 18.45,-236.05 c 1.7,22.74 -16.36,30.72 -49.86,33.22 l -40.1,3 c -16.15,1.21 -28.63,3.34 -39.76,7.18 -16.47,-10.8 -24.63,-23.43 -25.65,-37.19 -1.97,-26.33 25.59,-44.03 72.27,-47.53 47.26,-3.53 81.21,16.21 83.1,41.32 z m -213.57,0.34 c 1.84,24.53 18.4,44.95 46.58,59.7 l 0.18,2.39 c -14.24,10.68 -24.45,27.09 -22.66,51.02 1.7,22.73 18.73,41.32 36.39,52.04 l 0.17,2.39 c -18.63,16.43 -35.07,45.94 -32.48,80.66 5.06,67.6 62.33,101.23 123.95,96.62 16.17,-1.21 30.9,-5.32 42.56,-10.4 l 105.31,-7.88 -3.81,-50.86 -53.87,4.03 c 8.74,-12.09 14.57,-30.57 13.05,-50.92 -4.88,-65.21 -56.52,-96.25 -118.77,-91.59 -12.56,0.93 -26.74,4.4 -39.49,10.77 -9.57,-7.11 -15.49,-13.89 -16.47,-27.05 -1.25,-16.76 9.95,-27.82 45.84,-30.5 l 52.08,-3.9 c 70.6,-5.27 106.09,-29.59 102.28,-80.45 -4.34,-58.05 -68.77,-98.94 -164.51,-91.8 -70,5.25 -120.18,34.26 -116.33,85.73" /><path
								 id="path58"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 4730.5,4645.88 35.22,-44.81 -28.64,-28.62 1.49,-1.88 c 35.95,-3.02 70.27,-12.68 92.89,-41.45 26.7,-33.96 26.33,-65.52 8.92,-96.77 41.02,-3.62 77.09,-12.64 100.1,-41.88 38.56,-49.04 22.87,-98.01 -35.6,-143.99 l -145.26,-114.22 -43.01,54.71 138.17,108.65 c 38.2,30.04 43.45,52.48 24.55,76.54 -11.51,14.61 -33.56,23.23 -66.97,25.95 l -161.76,-127.19 -42.64,54.23 138.17,108.65 c 38.2,30.04 43.45,52.49 24.16,77 -11.12,14.15 -33.52,23.24 -66.96,25.96 l -161.76,-127.19 -42.63,54.23 231.56,182.08" /><path
								 id="path60"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 5086.91,2621.67 35.8,-41.69 c -25.88,-21.04 -43.91,-42.69 -50.76,-71.89 -7.27,-30.94 3.9,-48.99 23.77,-53.64 23.94,-5.62 41.71,22.86 60.52,50.48 22.93,34.68 54.55,72.24 102.44,60.99 50.24,-11.8 76.39,-60.45 61.31,-124.7 -9.33,-39.72 -33.22,-68 -56.81,-87.11 l -33.62,40.56 c 19.26,16.43 34.01,34.54 39.34,57.31 6.72,28.62 -3.56,45.21 -21.66,49.46 -22.77,5.35 -38.24,-21.22 -56.62,-49.55 -23.79,-35.71 -52.62,-74.54 -106.35,-61.93 -49.06,11.53 -79.59,59.98 -62.6,132.4 9.2,39.12 35.88,76.61 65.24,99.31" /><path
								 id="path62"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 774.855,2010.54 -18.457,53.92 36.465,17.56 -0.781,2.27 c -32.93,14.72 -62.129,35.16 -73.984,69.78 -14.004,40.87 -3.243,70.57 23.515,94.3 -37.519,16.96 -68.613,37.39 -80.664,72.57 -20.215,59.03 10.762,100.08 81.133,124.18 l 174.824,59.86 22.539,-65.84 -166.289,-56.95 c -45.976,-15.74 -58.34,-35.2 -48.418,-64.15 6.016,-17.59 23.965,-32.99 54.629,-46.6 l 194.688,66.67 22.343,-65.27 -166.308,-56.95 c -45.957,-15.75 -58.34,-35.19 -48.223,-64.71 5.84,-17.02 23.985,-33.01 54.649,-46.6 l 194.664,66.66 22.37,-65.28 -278.695,-95.42" /><path
								 id="path64"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 737.434,2738.83 c -58.809,-8.39 -93.692,-40.03 -87.598,-82.81 6.113,-42.77 48.359,-62.8 107.168,-54.41 58.223,8.29 93.203,39.35 87.09,82.12 -6.094,42.77 -48.438,63.41 -106.66,55.1 z m 29.57,-207.32 c -97.422,-13.9 -162.676,44.07 -173.008,116.56 -10.43,73.06 36.016,146.97 133.438,160.86 96.836,13.82 162.089,-44.17 172.5,-117.23 10.332,-72.47 -36.094,-146.38 -132.93,-160.19" /><path
								 id="path66"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 798.137,2885.01 -347.832,-10.73 -2.129,68.96 351.445,10.84 c 16.777,0.52 22.539,8.5 22.324,15.7 -0.097,2.99 -0.175,5.4 -1.543,10.76 l 51.309,10.59 c 3.867,-8.29 6.621,-20.21 7.129,-36.4 1.504,-49.18 -29.727,-68.15 -80.703,-69.72" /><path
								 id="path68"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 1989.52,1188.86 62.54,-30.54 -78.22,-160.121 1.62,-0.777 203.83,98.748 69.55,-33.99 -175.53,-84.532 21.62,-276.988 -69,33.699 -14.32,212.68 -81.5,-38.328 -50.29,-102.969 -62.54,30.547 172.24,352.571" /><path
								 id="path70"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 3913.02,919.441 90.57,42.879 -33.01,37.481 c -29.1,32.009 -58.65,67.809 -87.44,101.979 l -2.17,-1.02 c 8.96,-44.21 17.66,-89.22 24,-132.018 z m -89.86,213.689 73.75,34.92 283.4,-299.98 -66.16,-31.32 -73.1,82.902 -119.3,-56.492 17.77,-109.078 -63.98,-30.293 -52.38,409.341" /><path
								 id="path72"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 1697.71,3766 23.98,35.94 85.41,-85.35 0.88,1.33 -35,160.9 26.41,39.6 33.02,-137.93 163.75,-38.55 -24.86,-37.27 -134.02,34.1 13.75,-65.91 59.45,-59.38 -23.98,-35.94 -188.79,188.46" /><path
								 id="path74"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 2070.31,3708.57 c -28.81,25.18 -27.66,59.8 -7.56,82.81 9.66,11.06 20.8,15.28 31.77,16.85 l 4.57,-21.35 c -8.02,-1.04 -14.16,-3.43 -18.9,-8.87 -12.13,-13.88 -9.16,-33.52 8.22,-48.72 17.23,-15.04 36.91,-15.53 48.75,-2.01 5.82,6.68 7.85,15.74 8.13,24.19 l 20.56,-3.42 c -0.04,-14.21 -5.43,-27.47 -14.02,-37.31 -20.59,-23.53 -52.89,-27.19 -81.52,-2.17" /><path
								 id="path76"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 2202.82,3812.8 -36.99,38.51 c -10.56,-0.45 -17.91,-3.94 -23.45,-9.27 -10.59,-10.18 -9.63,-28.34 7.01,-45.66 17.13,-17.83 33.06,-20.95 45,-9.47 6.4,6.13 9.02,14.17 8.43,25.89 z m -73.28,-35.82 c -25.86,26.9 -24.7,59.71 -6.72,77 9.42,9.04 18.7,11.17 30.43,11.76 l -13.43,12.64 -28.77,29.93 19.33,18.58 114.09,-118.71 -15.98,-15.36 -9.9,7.63 -0.69,-0.65 c -0.23,-11.87 -3.94,-24.83 -12.87,-33.39 -20.68,-19.88 -49.31,-16.67 -75.49,10.57" /><path
								 id="path78"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 2940.23,4500.67 42.79,-0.22 -17.64,-83.11 -7.73,-28.35 h 1.6 c 20.08,17.09 41.35,30.18 64.94,30.06 32.79,-0.17 46.31,-18.23 46.13,-49.82 -0.03,-9.2 -0.87,-17.2 -3.34,-27.58 l -25.42,-123.85 -42.8,0.21 24.61,118.26 c 1.64,9.19 3.28,14.78 3.3,20.78 0.08,16.8 -7.87,25.23 -24.67,25.32 -13.59,0.07 -28.82,-9.05 -49.74,-30.14 l -27.07,-133.83 -43.19,0.21 58.23,282.06" /><path
								 id="path80"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 3961.46,3853.03 c 55.33,43.51 130.94,37.33 168.75,-10.77 14.84,-18.86 16.42,-38.98 13.02,-55.38 l -35.25,2.79 c 2.48,13.65 1.31,22.91 -6.83,33.28 -21.76,27.66 -72.86,26.66 -111.22,-3.51 -23.28,-18.29 -28.63,-39.3 -12.3,-60.05 9.39,-11.94 22.46,-16.92 34.94,-19.84 l -10.02,-31.27 c -17.64,4.96 -39.41,13.26 -57.71,36.53 -26.72,33.95 -23.28,76.82 16.62,108.22" /><path
								 id="path82"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 4229.64,2719.2 107.72,16.89 84.21,11.8 0.26,1.58 -76.15,37.55 -96.86,49.83 z m 16.17,168.81 217.25,-119.33 -8.81,-54.08 -243.85,-43.75 -27.63,4.5 35.41,217.17 27.63,-4.51" /><path
								 id="path84"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 4149.72,2598.5 135.19,0.12 c 8.93,0.01 18.03,0.93 27.31,2.76 9.28,1.84 15.21,6.63 17.81,14.41 1.25,3.71 1.82,8.05 1.7,13.04 l 7.36,0.41 3.38,-52.45 -2.73,-8.14 -158.73,-0.85 51.52,-50.9 c 9.24,-9.29 17.01,-14.99 23.3,-17.1 5.06,-1.71 12.5,-3.04 22.35,-4.01 7.2,-0.63 12.48,-1.51 15.8,-2.63 12.22,-4.1 16.11,-12.77 11.68,-25.97 -3.95,-11.72 -11.47,-15.73 -22.58,-12 -10.98,3.7 -29.22,18.9 -54.73,45.61 l -82.38,86.59 3.75,11.11" /><path
								 id="path86"
								 style="fill:none;stroke:#393536;stroke-width:5;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:10;stroke-dasharray:none;stroke-opacity:1"
								 d="m 4149.72,2598.5 135.19,0.12 c 8.93,0.01 18.03,0.93 27.31,2.76 9.28,1.84 15.21,6.63 17.81,14.41 1.25,3.71 1.82,8.05 1.7,13.04 l 7.36,0.41 3.38,-52.45 -2.73,-8.14 -158.73,-0.85 51.52,-50.9 c 9.24,-9.29 17.01,-14.99 23.3,-17.1 5.06,-1.71 12.5,-3.04 22.35,-4.01 7.2,-0.63 12.48,-1.51 15.8,-2.63 12.22,-4.1 16.11,-12.77 11.68,-25.97 -3.95,-11.72 -11.47,-15.73 -22.58,-12 -10.98,3.7 -29.22,18.9 -54.73,45.61 l -82.38,86.59 z" /><path
								 id="path88"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 1547.69,2518.04 -11.27,40.88 132.56,89.59 50.33,29.62 -0.43,1.54 c -26.68,-4.03 -60.08,-10.74 -89.06,-12.5 l -120.78,-8.77 -11.04,40.1 266.07,18.92 11.16,-40.49 -132.27,-89.11 -51.11,-29.83 0.43,-1.54 c 27.83,4.35 59.53,9.76 88.49,11.52 l 121.96,9.09 10.93,-39.71 -265.97,-19.31" /><path
								 id="path90"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 1820.83,2813.71 -4.76,38.65 -17.87,-7.6 c -15.36,-6.84 -32.17,-13.37 -48.3,-19.83 l 0.13,-0.92 c 17.38,-2.08 35.06,-4.37 51.62,-7.25 z m -89.8,-7.09 -3.91,31.47 145.28,67.98 3.49,-28.23 -39.51,-16.86 6.29,-50.9 42.42,-6.76 3.36,-27.31 -157.42,30.61" /><path
								 id="path92"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 2432.63,1917.71 38.46,-18.79 -109.96,-143.92 1.44,-0.71 118.2,44.18 43.11,-21.07 -108.03,-40.69 -7.3,-121.54 -38.83,18.98 8.12,93.08 -51.54,-17.99 -29.88,-39.26 -38.81,18.97 175.02,228.76" /><path
								 id="path94"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 3598.94,1768.11 c -1.13,5.22 -2.81,10.62 -5.55,16.4 -8.2,17.36 -22.79,29.48 -44.49,19.22 -21.33,-10.1 -34.1,-38.26 -28.42,-72.75 z m -59.53,67.85 c 41.21,19.51 69.92,-1.87 87.36,-38.75 7.36,-15.54 10,-34.2 10.2,-41.2 l -108.11,-51.15 c 13.83,-39.48 42.32,-45.47 69.08,-32.81 12.66,5.98 23.15,19.36 29.47,31.21 l 26.27,-18.11 c -9.66,-16.96 -26.52,-35.56 -51.85,-47.54 -42.31,-20.02 -84.22,-6.23 -106.8,41.5 -31.31,66.17 -2.26,134.78 44.38,156.85" /></g></g></svg>
			</xsl:when>
			<xsl:when test="$si-aspect = 'mol_na'">
				<svg
					 xmlns:dc="http://purl.org/dc/elements/1.1/"
					 xmlns:cc="http://creativecommons.org/ns#"
					 xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
					 xmlns:svg="http://www.w3.org/2000/svg"
					 xmlns="http://www.w3.org/2000/svg"
					 id="svg85"
					 version="1.2"
					 viewBox="0 0 595.28 595.28"
					 height="595.28pt"
					 width="595.28pt">
					<metadata
						 id="metadata91">
						<rdf:RDF>
							<cc:Work
								 rdf:about="">
								<dc:format>image/svg+xml</dc:format>
								<dc:type
									 rdf:resource="http://purl.org/dc/dcmitype/StillImage" />
							</cc:Work>
						</rdf:RDF>
					</metadata>
					<defs
						 id="defs89" />
					<g
						 id="surface1">
						<path
							 id="path2"
							 d="M 220.046875 146.335938 L 170.816406 44.109375 C 97.332031 80.933594 42.089844 148.753906 22.21875 230.429688 L 132.800781 255.671875 C 144.914062 207.964844 177.210938 168.34375 220.046875 146.335938 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(74.113464%,73.643494%,73.75946%);fill-opacity:1;" />
						<path
							 id="path4"
							 d="M 467.71875 297.667969 C 467.71875 336.242188 454.859375 371.804688 433.214844 400.335938 L 521.890625 471.050781 C 559.003906 423.121094 581.105469 362.976562 581.105469 297.667969 C 581.105469 277.453125 578.972656 257.738281 574.949219 238.722656 L 464.363281 263.960938 C 466.554688 274.859375 467.71875 286.125 467.71875 297.667969 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(74.113464%,73.643494%,73.75946%);fill-opacity:1;" />
						<path
							 id="path6"
							 d="M 297.640625 14.203125 C 255.074219 14.203125 214.707031 23.601562 178.476562 40.414062 L 227.707031 142.640625 C 249.042969 133 272.703125 127.589844 297.640625 127.589844 C 322.574219 127.589844 346.234375 133 367.570312 142.640625 L 416.800781 40.410156 C 380.570312 23.601562 340.207031 14.203125 297.640625 14.203125 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(74.113464%,73.643494%,73.75946%);fill-opacity:1;" />
						<path
							 id="path8"
							 d="M 462.480469 255.671875 L 573.058594 230.429688 C 553.1875 148.753906 497.945312 80.933594 424.460938 44.105469 L 375.230469 146.335938 C 418.070312 168.34375 450.363281 207.964844 462.480469 255.671875 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(74.113464%,73.643494%,73.75946%);fill-opacity:1;" />
						<path
							 id="path10"
							 d="M 127.5625 297.667969 C 127.5625 286.125 128.722656 274.859375 130.914062 263.964844 L 20.328125 238.722656 C 16.308594 257.738281 14.175781 277.453125 14.175781 297.667969 C 14.175781 362.976562 36.277344 423.117188 73.390625 471.050781 L 162.0625 400.335938 C 140.421875 371.800781 127.5625 336.242188 127.5625 297.667969 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(63.513184%,16.471863%,60.523987%);fill-opacity:1;" />
						<path
							 id="path12"
							 d="M 293.386719 581.078125 L 293.386719 467.636719 C 242.8125 466.390625 197.722656 443.105469 167.371094 406.976562 L 78.683594 477.703125 C 129.835938 539.839844 206.925781 579.804688 293.386719 581.078125 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(74.113464%,73.643494%,73.75946%);fill-opacity:1;" />
						<path
							 id="path14"
							 d="M 301.890625 581.078125 C 388.351562 579.804688 465.441406 539.839844 516.59375 477.703125 L 427.90625 406.976562 C 397.558594 443.105469 352.464844 466.394531 301.890625 467.636719 L 301.890625 581.078125 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(74.113464%,73.643494%,73.75946%);fill-opacity:1;" />
						<path
							 id="path16"
							 d="M 367.570312 142.640625 C 346.234375 133 322.574219 127.589844 297.640625 127.589844 C 272.703125 127.589844 249.042969 133 227.707031 142.640625 L 297.636719 287.855469 L 367.570312 142.640625 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(87.068176%,86.833191%,86.891174%);fill-opacity:1;" />
						<path
							 id="path18"
							 d="M 130.914062 263.964844 C 128.722656 274.859375 127.5625 286.125 127.5625 297.667969 C 127.5625 336.242188 140.421875 371.800781 162.0625 400.335938 L 288.082031 299.835938 L 130.914062 263.964844 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(79.573059%,53.837585%,79.524231%);fill-opacity:1;" />
						<path
							 id="path20"
							 d="M 301.890625 467.636719 C 352.464844 466.394531 397.558594 443.105469 427.90625 406.976562 L 301.890625 306.484375 L 301.890625 467.636719 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(87.068176%,86.833191%,86.891174%);fill-opacity:1;" />
						<path
							 id="path22"
							 d="M 464.363281 263.960938 L 307.191406 299.835938 L 433.214844 400.335938 C 454.859375 371.804688 467.71875 336.242188 467.71875 297.667969 C 467.71875 286.125 466.554688 274.859375 464.363281 263.960938 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(87.068176%,86.833191%,86.891174%);fill-opacity:1;" />
						<path
							 id="path24"
							 d="M 220.046875 146.335938 C 177.210938 168.34375 144.914062 207.964844 132.800781 255.671875 L 289.976562 291.546875 L 220.046875 146.335938 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(87.068176%,86.833191%,86.891174%);fill-opacity:1;" />
						<path
							 id="path26"
							 d="M 462.480469 255.671875 C 450.363281 207.964844 418.070312 168.34375 375.230469 146.335938 L 305.300781 291.546875 L 462.480469 255.671875 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(87.068176%,86.833191%,86.891174%);fill-opacity:1;" />
						<path
							 id="path28"
							 d="M 167.371094 406.976562 C 197.722656 443.105469 242.8125 466.390625 293.386719 467.636719 L 293.386719 306.484375 L 167.371094 406.976562 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(87.068176%,86.833191%,86.891174%);fill-opacity:1;" />
						<path
							 id="path30"
							 d="M 78.683594 477.703125 C 76.882812 475.515625 75.125 473.292969 73.390625 471.050781 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(92.549133%,0%,54.899597%);fill-opacity:1;" />
						<path
							 id="path32"
							 d="M 396.851562 297.667969 C 396.851562 352.460938 352.433594 396.878906 297.640625 396.878906 C 242.847656 396.878906 198.425781 352.460938 198.425781 297.667969 C 198.425781 242.871094 242.847656 198.453125 297.640625 198.453125 C 352.433594 198.453125 396.851562 242.871094 396.851562 297.667969 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,100%,100%);fill-opacity:1;" />
						<path
							 id="path34"
							 d="M 242.8125 336.71875 L 250.292969 328.042969 C 257.320312 335.375 267.195312 340.308594 277.367188 340.308594 C 290.230469 340.308594 297.859375 333.878906 297.859375 324.304688 C 297.859375 314.28125 290.828125 311.140625 281.554688 306.953125 L 267.492188 300.820312 C 258.21875 296.929688 247.597656 289.902344 247.597656 275.539062 C 247.597656 260.582031 260.613281 249.511719 278.414062 249.511719 C 290.082031 249.511719 300.402344 254.449219 307.429688 261.628906 L 300.699219 269.707031 C 294.71875 264.023438 287.539062 260.433594 278.414062 260.433594 C 267.492188 260.433594 260.164062 265.96875 260.164062 274.792969 C 260.164062 284.21875 268.691406 287.804688 276.46875 291.097656 L 290.382812 297.082031 C 301.746094 302.015625 310.574219 308.746094 310.574219 323.257812 C 310.574219 338.8125 297.859375 351.230469 277.21875 351.230469 C 263.453125 351.230469 251.339844 345.546875 242.8125 336.71875 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(22.322083%,20.909119%,21.260071%);fill-opacity:1;" />
						<path
							 id="path36"
							 d="M 329.871094 251.308594 L 342.285156 251.308594 L 342.285156 349.433594 L 329.871094 349.433594 L 329.871094 251.308594 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(22.322083%,20.909119%,21.260071%);fill-opacity:1;" />
						<path
							 id="path38"
							 d="M 105.394531 177.816406 C 97.296875 172.222656 96.578125 163.339844 101.050781 156.875 C 103.195312 153.765625 105.914062 152.363281 108.675781 151.640625 L 110.46875 156.964844 C 108.441406 157.464844 106.949219 158.253906 105.890625 159.785156 C 103.199219 163.683594 104.53125 168.617188 109.417969 171.992188 C 114.257812 175.335938 119.304688 174.886719 121.929688 171.085938 C 123.226562 169.207031 123.480469 166.832031 123.300781 164.664062 L 128.65625 164.9375 C 129.0625 168.574219 128.070312 172.117188 126.160156 174.882812 C 121.59375 181.496094 113.4375 183.375 105.394531 177.816406 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,100%,100%);fill-opacity:1;" />
						<path
							 id="path40"
							 d="M 139.015625 145.140625 L 128.839844 135.90625 C 126.136719 136.210938 124.316406 137.230469 122.984375 138.699219 C 120.445312 141.496094 121.011719 146.140625 125.589844 150.296875 C 130.300781 154.566406 134.441406 155.089844 137.304688 151.933594 C 138.839844 150.246094 139.371094 148.136719 139.015625 145.140625 Z M 120.835938 155.621094 C 113.726562 149.171875 113.441406 140.734375 117.757812 135.980469 C 120.015625 133.492188 122.359375 132.78125 125.355469 132.425781 L 121.683594 129.417969 L 113.777344 122.242188 L 118.410156 117.132812 L 149.78125 145.59375 L 145.953125 149.8125 L 143.273438 148.03125 L 143.113281 148.210938 C 143.261719 151.261719 142.535156 154.652344 140.398438 157.007812 C 135.4375 162.472656 128.035156 162.152344 120.835938 155.621094 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,100%,100%);fill-opacity:1;" />
						<path
							 id="path42"
							 d="M 269.574219 44.261719 L 276.339844 43.828125 L 278.027344 70.234375 L 278.207031 70.222656 L 288.238281 55.992188 L 295.78125 55.511719 L 286.488281 68.128906 L 298.679688 84.84375 L 291.195312 85.324219 L 282.835938 73.050781 L 278.5625 78.613281 L 279.039062 86.101562 L 272.273438 86.53125 L 269.574219 44.261719 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,100%,100%);fill-opacity:1;" />
						<path
							 id="path44"
							 d="M 318.769531 66.742188 C 319.046875 63.09375 316.992188 60.773438 314.117188 60.558594 C 311.246094 60.34375 308.816406 62.269531 308.539062 65.976562 C 308.257812 69.746094 310.371094 72.070312 313.242188 72.285156 C 316.054688 72.496094 318.488281 70.515625 318.769531 66.742188 Z M 320.617188 90.347656 C 320.785156 88.074219 318.980469 87.277344 315.632812 87.027344 L 311.621094 86.726562 C 310.007812 86.605469 308.757812 86.390625 307.644531 86.007812 C 305.996094 87.089844 305.179688 88.351562 305.078125 89.726562 C 304.882812 92.359375 307.636719 94.128906 312.304688 94.480469 C 317.03125 94.832031 320.425781 92.859375 320.617188 90.347656 Z M 299.261719 90.3125 C 299.441406 87.859375 301.097656 85.820312 303.917969 84.34375 L 303.933594 84.105469 C 302.511719 83.035156 301.488281 81.394531 301.671875 79.003906 C 301.839844 76.730469 303.542969 74.871094 305.308594 73.796875 L 305.324219 73.558594 C 303.464844 71.917969 301.816406 68.964844 302.078125 65.492188 C 302.585938 58.734375 308.308594 55.371094 314.472656 55.832031 C 316.089844 55.953125 317.5625 56.363281 318.726562 56.871094 L 329.261719 57.660156 L 328.878906 62.746094 L 323.492188 62.34375 C 324.363281 63.550781 324.949219 65.398438 324.796875 67.433594 C 324.308594 73.957031 319.144531 77.058594 312.921875 76.59375 C 311.664062 76.5 310.246094 76.152344 308.96875 75.515625 C 308.011719 76.226562 307.421875 76.90625 307.324219 78.222656 C 307.199219 79.898438 308.316406 81.003906 311.90625 81.273438 L 317.113281 81.660156 C 324.175781 82.1875 327.722656 84.621094 327.34375 89.707031 C 326.910156 95.511719 320.46875 99.601562 310.890625 98.886719 C 303.890625 98.363281 298.875 95.460938 299.261719 90.3125 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,100%,100%);fill-opacity:1;" />
						<path
							 id="path46"
							 d="M 473.050781 130.691406 L 476.570312 135.171875 L 473.710938 138.035156 L 473.855469 138.222656 C 477.453125 138.523438 480.886719 139.492188 483.144531 142.367188 C 485.816406 145.761719 485.777344 148.921875 484.039062 152.046875 C 488.140625 152.40625 491.746094 153.308594 494.050781 156.234375 C 497.902344 161.136719 496.335938 166.035156 490.488281 170.632812 L 475.964844 182.054688 L 471.660156 176.582031 L 485.476562 165.71875 C 489.300781 162.714844 489.824219 160.46875 487.933594 158.0625 C 486.78125 156.601562 484.578125 155.742188 481.234375 155.46875 L 465.058594 168.1875 L 460.796875 162.765625 L 474.613281 151.898438 C 478.433594 148.894531 478.960938 146.652344 477.027344 144.199219 C 475.917969 142.785156 473.675781 141.875 470.335938 141.601562 L 454.15625 154.324219 L 449.894531 148.898438 L 473.050781 130.691406 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,100%,100%);fill-opacity:1;" />
						<path
							 id="path48"
							 d="M 508.691406 333.113281 L 512.269531 337.28125 C 509.683594 339.386719 507.882812 341.550781 507.195312 344.472656 C 506.46875 347.566406 507.585938 349.367188 509.570312 349.835938 C 511.96875 350.398438 513.742188 347.550781 515.625 344.785156 C 517.917969 341.320312 521.078125 337.5625 525.867188 338.6875 C 530.890625 339.867188 533.507812 344.734375 532 351.15625 C 531.066406 355.128906 528.675781 357.957031 526.316406 359.867188 L 522.957031 355.8125 C 524.882812 354.171875 526.355469 352.359375 526.890625 350.082031 C 527.5625 347.21875 526.535156 345.558594 524.722656 345.136719 C 522.445312 344.601562 520.898438 347.257812 519.0625 350.089844 C 516.683594 353.660156 513.800781 357.546875 508.425781 356.285156 C 503.519531 355.132812 500.46875 350.285156 502.167969 343.042969 C 503.089844 339.132812 505.757812 335.382812 508.691406 333.113281 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,100%,100%);fill-opacity:1;" />
						<path
							 id="path50"
							 d="M 77.484375 394.226562 L 75.640625 388.835938 L 79.285156 387.078125 L 79.207031 386.851562 C 75.914062 385.378906 72.996094 383.335938 71.808594 379.871094 C 70.410156 375.785156 71.484375 372.816406 74.160156 370.441406 C 70.410156 368.746094 67.300781 366.703125 66.09375 363.1875 C 64.074219 357.28125 67.171875 353.179688 74.207031 350.769531 L 91.691406 344.78125 L 93.945312 351.367188 L 77.316406 357.0625 C 72.71875 358.636719 71.480469 360.578125 72.472656 363.476562 C 73.074219 365.234375 74.871094 366.773438 77.9375 368.136719 L 97.40625 361.46875 L 99.640625 367.996094 L 83.007812 373.691406 C 78.414062 375.265625 77.175781 377.210938 78.1875 380.160156 C 78.769531 381.863281 80.585938 383.464844 83.652344 384.820312 L 103.117188 378.15625 L 105.355469 384.683594 L 77.484375 394.226562 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,100%,100%);fill-opacity:1;" />
						<path
							 id="path52"
							 d="M 73.742188 321.398438 C 67.863281 322.234375 64.375 325.398438 64.984375 329.679688 C 65.59375 333.953125 69.820312 335.957031 75.699219 335.117188 C 81.523438 334.289062 85.019531 331.183594 84.410156 326.90625 C 83.800781 322.628906 79.566406 320.566406 73.742188 321.398438 Z M 76.699219 342.128906 C 66.957031 343.519531 60.433594 337.722656 59.398438 330.472656 C 58.355469 323.167969 63 315.777344 72.742188 314.386719 C 82.425781 313.003906 88.953125 318.804688 89.992188 326.109375 C 91.027344 333.355469 86.382812 340.746094 76.699219 342.128906 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,100%,100%);fill-opacity:1;" />
						<path
							 id="path54"
							 d="M 79.8125 306.777344 L 45.03125 307.851562 L 44.816406 300.953125 L 79.960938 299.871094 C 81.640625 299.820312 82.21875 299.023438 82.195312 298.300781 C 82.183594 298.003906 82.175781 297.761719 82.039062 297.226562 L 87.171875 296.167969 C 87.558594 296.996094 87.832031 298.1875 87.882812 299.808594 C 88.035156 304.726562 84.910156 306.621094 79.8125 306.777344 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,100%,100%);fill-opacity:1;" />
						<path
							 id="path56"
							 d="M 198.953125 476.394531 L 205.207031 479.449219 L 197.386719 495.460938 L 197.546875 495.539062 L 217.929688 485.664062 L 224.886719 489.0625 L 207.332031 497.515625 L 209.492188 525.214844 L 202.59375 521.84375 L 201.160156 500.574219 L 193.011719 504.410156 L 187.980469 514.707031 L 181.726562 511.652344 L 198.953125 476.394531 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,100%,100%);fill-opacity:1;" />
						<path
							 id="path58"
							 d="M 391.300781 503.335938 L 400.359375 499.046875 L 397.058594 495.300781 C 394.148438 492.097656 391.191406 488.519531 388.3125 485.101562 L 388.097656 485.203125 C 388.992188 489.625 389.863281 494.125 390.496094 498.40625 Z M 382.316406 481.96875 L 389.691406 478.472656 L 418.03125 508.472656 L 411.414062 511.605469 L 404.105469 503.316406 L 392.175781 508.964844 L 393.953125 519.871094 L 387.554688 522.902344 L 382.316406 481.96875 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(100%,100%,100%);fill-opacity:1;" />
						<path
							 id="path60"
							 d="M 169.769531 218.679688 L 172.171875 215.085938 L 180.710938 223.621094 L 180.800781 223.488281 L 177.300781 207.398438 L 179.9375 203.4375 L 183.242188 217.230469 L 199.617188 221.085938 L 197.132812 224.8125 L 183.726562 221.402344 L 185.101562 227.992188 L 191.050781 233.933594 L 188.648438 237.527344 L 169.769531 218.679688 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(22.322083%,20.909119%,21.260071%);fill-opacity:1;" />
						<path
							 id="path62"
							 d="M 207.03125 224.421875 C 204.148438 221.90625 204.265625 218.441406 206.273438 216.140625 C 207.242188 215.035156 208.355469 214.613281 209.453125 214.457031 L 209.910156 216.59375 C 209.105469 216.695312 208.492188 216.933594 208.019531 217.480469 C 206.804688 218.867188 207.101562 220.828125 208.84375 222.351562 C 210.5625 223.855469 212.53125 223.902344 213.71875 222.550781 C 214.300781 221.882812 214.503906 220.976562 214.527344 220.132812 L 216.585938 220.472656 C 216.582031 221.894531 216.042969 223.222656 215.183594 224.203125 C 213.125 226.558594 209.894531 226.925781 207.03125 224.421875 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(22.322083%,20.909119%,21.260071%);fill-opacity:1;" />
						<path
							 id="path64"
							 d="M 220.28125 214 L 216.585938 210.148438 C 215.527344 210.195312 214.792969 210.542969 214.238281 211.074219 C 213.179688 212.09375 213.273438 213.910156 214.9375 215.640625 C 216.652344 217.425781 218.246094 217.738281 219.4375 216.589844 C 220.078125 215.976562 220.34375 215.171875 220.28125 214 Z M 212.953125 217.582031 C 210.367188 214.890625 210.484375 211.609375 212.28125 209.882812 C 213.222656 208.976562 214.152344 208.765625 215.324219 208.707031 L 213.980469 207.441406 L 211.105469 204.449219 L 213.039062 202.589844 L 224.445312 214.460938 L 222.847656 215.996094 L 221.859375 215.234375 L 221.789062 215.300781 C 221.765625 216.488281 221.394531 217.78125 220.503906 218.640625 C 218.433594 220.628906 215.570312 220.304688 212.953125 217.582031 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(22.322083%,20.909119%,21.260071%);fill-opacity:1;" />
						<path
							 id="path66"
							 d="M 294.023438 145.214844 L 298.300781 145.234375 L 296.539062 153.546875 L 295.765625 156.382812 L 295.925781 156.382812 C 297.933594 154.671875 300.058594 153.363281 302.421875 153.375 C 305.699219 153.390625 307.050781 155.199219 307.03125 158.355469 C 307.027344 159.277344 306.945312 160.078125 306.699219 161.113281 L 304.15625 173.5 L 299.878906 173.476562 L 302.339844 161.652344 C 302.503906 160.734375 302.664062 160.175781 302.667969 159.574219 C 302.675781 157.894531 301.882812 157.050781 300.199219 157.042969 C 298.84375 157.035156 297.316406 157.949219 295.226562 160.054688 L 292.519531 173.441406 L 288.199219 173.417969 L 294.023438 145.214844 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(22.322083%,20.909119%,21.260071%);fill-opacity:1;" />
						<path
							 id="path68"
							 d="M 396.144531 209.976562 C 401.679688 205.625 409.238281 206.242188 413.019531 211.054688 C 414.507812 212.941406 414.664062 214.953125 414.324219 216.59375 L 410.800781 216.3125 C 411.046875 214.949219 410.929688 214.023438 410.113281 212.984375 C 407.9375 210.21875 402.828125 210.320312 398.992188 213.335938 C 396.664062 215.164062 396.132812 217.265625 397.761719 219.339844 C 398.703125 220.535156 400.011719 221.03125 401.257812 221.324219 L 400.257812 224.449219 C 398.492188 223.957031 396.3125 223.125 394.484375 220.800781 C 391.8125 217.402344 392.15625 213.117188 396.144531 209.976562 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(22.322083%,20.909119%,21.260071%);fill-opacity:1;" />
						<path
							 id="path70"
							 d="M 422.964844 323.359375 L 433.734375 321.671875 L 442.15625 320.492188 L 442.183594 320.332031 L 434.566406 316.578125 L 424.882812 311.59375 Z M 424.582031 306.476562 L 446.304688 318.410156 L 445.425781 323.820312 L 421.039062 328.195312 L 418.277344 327.742188 L 421.816406 306.027344 L 424.582031 306.476562 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(22.322083%,20.909119%,21.260071%);fill-opacity:1;" />
						<path
							 id="path72"
							 d="M 414.972656 335.429688 L 428.492188 335.417969 C 429.386719 335.417969 430.296875 335.324219 431.222656 335.140625 C 432.148438 334.957031 432.742188 334.476562 433.003906 333.699219 C 433.128906 333.328125 433.183594 332.894531 433.175781 332.398438 L 433.910156 332.355469 L 434.246094 337.601562 L 433.972656 338.414062 L 418.101562 338.5 L 423.253906 343.589844 C 424.175781 344.519531 424.953125 345.089844 425.585938 345.300781 C 426.089844 345.472656 426.835938 345.601562 427.816406 345.699219 C 428.539062 345.761719 429.066406 345.851562 429.398438 345.964844 C 430.621094 346.375 431.011719 347.242188 430.566406 348.558594 C 430.171875 349.734375 429.421875 350.132812 428.308594 349.761719 C 427.210938 349.390625 425.386719 347.871094 422.835938 345.199219 L 414.597656 336.539062 L 414.972656 335.429688 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(22.322083%,20.909119%,21.260071%);fill-opacity:1;" />
						<path
							 id="path74"
							 transform="matrix(0.1,0,0,-0.1,0,595.28)"
							 d="M 4149.726562 2598.503125 L 4284.921875 2598.620313 C 4293.867188 2598.620313 4302.96875 2599.557813 4312.226562 2601.39375 C 4321.484375 2603.229688 4327.421875 2608.034375 4330.039062 2615.807813 C 4331.289062 2619.51875 4331.835938 2623.854688 4331.757812 2628.815625 L 4339.101562 2629.245313 L 4342.460938 2576.784375 L 4339.726562 2568.659375 L 4181.015625 2567.8 L 4232.539062 2516.901563 C 4241.757812 2507.604688 4249.53125 2501.901563 4255.859375 2499.792188 C 4260.898438 2498.073438 4268.359375 2496.784375 4278.164062 2495.807813 C 4285.390625 2495.182813 4290.664062 2494.284375 4293.984375 2493.151563 C 4306.210938 2489.05 4310.117188 2480.378125 4305.664062 2467.214063 C 4301.71875 2455.45625 4294.21875 2451.471875 4283.085938 2455.182813 C 4272.109375 2458.89375 4253.867188 2474.089063 4228.359375 2500.807813 L 4145.976562 2587.409375 Z M 4149.726562 2598.503125 "
							 style="fill:none;stroke-width:5;stroke-linecap:butt;stroke-linejoin:miter;stroke:rgb(22.322083%,20.909119%,21.260071%);stroke-opacity:1;stroke-miterlimit:10;" />
						<path
							 id="path76"
							 d="M 154.769531 343.476562 L 153.640625 339.386719 L 166.898438 330.429688 L 171.929688 327.46875 L 171.886719 327.3125 C 169.21875 327.714844 165.882812 328.386719 162.980469 328.5625 L 150.902344 329.441406 L 149.800781 325.429688 L 176.40625 323.539062 L 177.523438 327.585938 L 164.296875 336.496094 L 159.183594 339.480469 L 159.226562 339.636719 C 162.011719 339.199219 165.179688 338.660156 168.078125 338.484375 L 180.273438 337.574219 L 181.367188 341.546875 L 154.769531 343.476562 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(22.322083%,20.909119%,21.260071%);fill-opacity:1;" />
						<path
							 id="path78"
							 d="M 182.085938 313.910156 L 181.605469 310.042969 L 179.820312 310.804688 C 178.285156 311.488281 176.601562 312.140625 174.988281 312.785156 L 175.003906 312.878906 C 176.742188 313.085938 178.511719 313.316406 180.164062 313.605469 Z M 173.101562 314.617188 L 172.714844 311.472656 L 187.238281 304.671875 L 187.589844 307.496094 L 183.636719 309.179688 L 184.265625 314.273438 L 188.511719 314.949219 L 188.84375 317.679688 L 173.101562 314.617188 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(22.322083%,20.909119%,21.260071%);fill-opacity:1;" />
						<path
							 id="path80"
							 d="M 243.261719 403.507812 L 247.109375 405.386719 L 236.113281 419.78125 L 236.257812 419.851562 L 248.078125 415.433594 L 252.386719 417.539062 L 241.585938 421.609375 L 240.855469 433.761719 L 236.972656 431.863281 L 237.785156 422.558594 L 232.632812 424.355469 L 229.640625 428.28125 L 225.761719 426.386719 L 243.261719 403.507812 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(22.322083%,20.909119%,21.260071%);fill-opacity:1;" />
						<path
							 id="path82"
							 d="M 359.894531 418.46875 C 359.78125 417.945312 359.613281 417.40625 359.339844 416.828125 C 358.519531 415.09375 357.058594 413.882812 354.890625 414.90625 C 352.757812 415.917969 351.480469 418.734375 352.050781 422.183594 Z M 353.941406 411.683594 C 358.0625 409.734375 360.933594 411.871094 362.675781 415.558594 C 363.414062 417.113281 363.675781 418.980469 363.695312 419.679688 L 352.886719 424.792969 C 354.269531 428.742188 357.117188 429.339844 359.796875 428.074219 C 361.058594 427.476562 362.109375 426.140625 362.742188 424.953125 L 365.367188 426.765625 C 364.402344 428.460938 362.71875 430.320312 360.183594 431.519531 C 355.953125 433.519531 351.761719 432.140625 349.503906 427.367188 C 346.371094 420.753906 349.277344 413.890625 353.941406 411.683594 "
							 style=" stroke:none;fill-rule:nonzero;fill:rgb(22.322083%,20.909119%,21.260071%);fill-opacity:1;" />
					</g>
				</svg>
			</xsl:when>
			<xsl:when test="$si-aspect = 's_deltanu'">
				<svg
					 xmlns:dc="http://purl.org/dc/elements/1.1/"
					 xmlns:cc="http://creativecommons.org/ns#"
					 xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
					 xmlns:svg="http://www.w3.org/2000/svg"
					 xmlns="http://www.w3.org/2000/svg"
					 viewBox="0 0 793.70667 793.70667"
					 height="793.70667"
					 width="793.70667"
					 xml:space="preserve"
					 id="svg2"
					 version="1.1"><metadata
						 id="metadata8"><rdf:RDF><cc:Work
								 rdf:about=""><dc:format>image/svg+xml</dc:format><dc:type
									 rdf:resource="http://purl.org/dc/dcmitype/StillImage" /></cc:Work></rdf:RDF></metadata><defs
						 id="defs6" /><g
						 transform="matrix(1.3333333,0,0,-1.3333333,0,793.70667)"
						 id="g10"><g
							 transform="scale(0.1)"
							 id="g12"><path
								 id="path14"
								 style="fill:#bdbcbc;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 2302.61,4606.17 -492.3,1022.28 C 1075.48,5260.18 523.051,4581.98 324.34,3765.21 l 1105.79,-252.39 c 121.17,477.05 444.1,873.26 872.48,1093.35" /><path
								 id="path16"
								 style="fill:#f79f0e;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 4779.32,3092.85 c 0,-385.74 -128.6,-741.35 -345.02,-1026.69 l 886.73,-707.15 c 371.14,479.31 592.16,1080.73 592.16,1733.84 0,202.15 -21.33,399.3 -61.56,589.46 L 4745.79,3429.9 c 21.91,-108.96 33.53,-221.64 33.53,-337.05" /><path
								 id="path18"
								 style="fill:#bdbcbc;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 3078.54,5927.5 c -425.68,0 -829.34,-94.01 -1191.63,-262.11 L 2379.2,4643.12 c 213.38,96.41 449.97,150.52 699.34,150.52 249.35,0 485.93,-54.1 699.29,-150.51 l 492.31,1022.27 c -362.29,168.1 -765.94,262.1 -1191.6,262.1" /><path
								 id="path20"
								 style="fill:#bdbcbc;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 4726.96,3512.83 1105.78,252.39 C 5634.03,4582 5081.58,5260.2 4346.73,5628.46 L 3854.44,4606.19 c 428.38,-220.09 751.33,-616.3 872.52,-1093.36" /><path
								 id="path22"
								 style="fill:#bdbcbc;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 1377.76,3092.85 c 0,115.41 11.63,228.09 33.53,337.04 L 305.441,3682.3 c -40.222,-190.16 -61.543,-387.3 -61.543,-589.45 0,-653.1 221.016,-1254.51 592.141,-1733.82 l 886.731,707.15 c -216.41,285.34 -345.01,640.94 -345.01,1026.67" /><path
								 id="path24"
								 style="fill:#bdbcbc;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 3036,258.75 v 1134.4 c -505.75,12.45 -956.65,245.32 -1260.14,606.61 L 888.996,1292.5 C 1400.5,671.129 2171.38,271.492 3036,258.75" /><path
								 id="path26"
								 style="fill:#bdbcbc;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 3121.04,258.75 c 864.63,12.73 1635.52,412.371 2147.04,1033.73 l -886.89,707.26 C 4077.71,1638.46 3626.8,1405.59 3121.04,1393.15 V 258.75" /><path
								 id="path28"
								 style="fill:#deddde;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 3777.83,4643.13 c -213.36,96.41 -449.94,150.51 -699.29,150.51 -249.37,0 -485.96,-54.11 -699.34,-150.52 l 699.32,-1452.14 699.31,1452.15" /><path
								 id="path30"
								 style="fill:#deddde;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 1411.29,3429.89 c -21.9,-108.95 -33.53,-221.63 -33.53,-337.04 0,-385.73 128.6,-741.33 345.01,-1026.67 l 1260.2,1004.98 -1571.68,358.73" /><path
								 id="path32"
								 style="fill:#deddde;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 3121.04,1393.15 c 505.76,12.44 956.67,245.31 1260.15,606.59 L 3121.04,3004.68 V 1393.15" /><path
								 id="path34"
								 style="fill:#fbcb78;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 4745.79,3429.9 -1571.73,-358.74 1260.24,-1005 c 216.42,285.34 345.02,640.95 345.02,1026.69 0,115.41 -11.62,228.09 -33.53,337.05" /><path
								 id="path36"
								 style="fill:#deddde;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="M 2302.61,4606.17 C 1874.23,4386.08 1551.3,3989.87 1430.13,3512.82 l 1571.77,-358.75 -699.29,1452.1" /><path
								 id="path38"
								 style="fill:#deddde;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 4726.96,3512.83 c -121.19,477.06 -444.14,873.27 -872.52,1093.36 l -699.3,-1452.12 1571.82,358.76" /><path
								 id="path40"
								 style="fill:#deddde;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="M 1775.86,1999.76 C 2079.35,1638.47 2530.25,1405.6 3036,1393.15 V 3004.68 L 1775.86,1999.76" /><path
								 id="path42"
								 style="fill:#ec008c;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 888.996,1292.5 c -18.016,21.87 -35.594,44.11 -52.957,66.53" /><path
								 id="path44"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 4070.67,3092.85 c 0,-547.93 -444.19,-992.12 -992.13,-992.12 -547.93,0 -992.12,444.19 -992.12,992.12 0,547.94 444.19,992.13 992.12,992.13 547.94,0 992.13,-444.19 992.13,-992.13" /><path
								 id="path46"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 2530.27,2702.32 74.8,86.76 c 70.29,-73.3 169.02,-122.66 270.74,-122.66 128.64,0 204.92,64.32 204.92,160.06 0,100.22 -70.31,131.63 -163.04,173.51 l -140.61,61.33 c -92.73,38.89 -198.94,109.19 -198.94,252.79 0,149.58 130.13,260.28 308.14,260.28 116.68,0 219.88,-49.37 290.18,-121.17 l -67.31,-80.77 c -59.82,56.84 -131.62,92.74 -222.87,92.74 -109.2,0 -182.5,-55.34 -182.5,-143.6 0,-94.23 85.28,-130.13 163.05,-163.04 l 139.12,-59.84 c 113.67,-49.36 201.93,-116.67 201.93,-261.76 0,-155.57 -127.15,-279.72 -333.57,-279.72 -137.62,0 -258.77,56.84 -344.04,145.09" /><path
								 id="path48"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 3400.85,3556.44 h 124.16 v -981.26 h -124.16 v 981.26" /><path
								 id="path50"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 1156.09,4291.36 c -80.96,55.93 -88.15,144.75 -43.46,209.41 21.48,31.1 48.67,45.13 76.25,52.33 l 17.93,-53.22 c -20.24,-4.99 -35.18,-12.9 -45.74,-28.2 -26.94,-39 -13.62,-88.31 35.25,-122.07 48.38,-33.43 98.89,-28.94 125.14,9.07 12.97,18.76 15.51,42.51 13.71,64.18 l 53.55,-2.72 c 4.05,-36.35 -5.86,-71.8 -24.96,-99.44 -45.7,-66.15 -127.22,-84.93 -207.67,-29.34" /><path
								 id="path52"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 1492.3,4618.13 -101.76,92.31 c -27.03,-3.01 -45.23,-13.24 -58.54,-27.9 -25.39,-28 -19.74,-74.44 26.04,-115.97 47.09,-42.72 88.53,-47.93 117.17,-16.38 15.31,16.88 20.66,37.95 17.09,67.94 z M 1310.5,4513.3 c -71.09,64.5 -73.93,148.88 -30.78,196.43 22.58,24.88 46.01,31.97 76,35.55 l -36.72,30.07 -79.09,71.76 46.35,51.1 313.71,-284.62 -38.3,-42.21 -26.77,17.81 -1.61,-1.78 c 1.47,-30.5 -5.8,-64.41 -27.16,-87.96 -49.59,-54.66 -123.64,-51.46 -195.63,13.85" /><path
								 id="path54"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 2797.88,5626.92 67.66,4.32 16.87,-264.05 1.8,0.12 100.31,142.27 75.45,4.83 -92.93,-126.18 121.9,-167.15 -74.83,-4.79 -83.61,122.72 -42.73,-55.64 4.78,-74.84 -67.65,-4.33 -27.02,422.72" /><path
								 id="path56"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 3289.86,5402.09 c 2.73,36.5 -17.8,59.7 -46.53,61.84 -28.71,2.16 -53.01,-17.1 -55.8,-54.18 -2.81,-37.7 18.32,-60.95 47.03,-63.1 28.13,-2.1 52.48,17.74 55.3,55.44 z m 18.45,-236.04 c 1.7,22.73 -16.36,30.71 -49.86,33.21 l -40.1,3 c -16.15,1.21 -28.63,3.34 -39.76,7.19 -16.47,-10.81 -24.63,-23.44 -25.65,-37.2 -1.97,-26.33 25.59,-44.02 72.27,-47.52 47.26,-3.53 81.21,16.2 83.1,41.32 z m -213.57,0.33 c 1.83,24.53 18.4,44.95 46.58,59.7 l 0.18,2.39 c -14.24,10.68 -24.46,27.1 -22.66,51.03 1.7,22.73 18.73,41.32 36.39,52.04 l 0.17,2.39 c -18.63,16.43 -35.08,45.94 -32.48,80.65 5.06,67.6 62.33,101.23 123.95,96.62 16.17,-1.21 30.9,-5.32 42.56,-10.4 l 105.31,-7.87 -3.81,-50.87 -53.87,4.04 c 8.73,-12.09 14.57,-30.58 13.05,-50.93 -4.88,-65.21 -56.52,-96.24 -118.77,-91.59 -12.56,0.94 -26.74,4.4 -39.49,10.78 -9.57,-7.12 -15.49,-13.9 -16.47,-27.06 -1.25,-16.75 9.94,-27.82 45.84,-30.5 l 52.07,-3.89 c 70.61,-5.28 106.1,-29.59 102.29,-80.46 -4.34,-58.04 -68.77,-98.94 -164.51,-91.79 -70,5.24 -120.18,34.25 -116.33,85.72" /><path
								 id="path58"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 4832.65,4762.6 35.21,-44.8 -28.63,-28.62 1.49,-1.89 c 35.95,-3.02 70.27,-12.68 92.89,-41.45 26.7,-33.95 26.32,-65.52 8.92,-96.77 41.02,-3.62 77.09,-12.63 100.1,-41.88 38.55,-49.03 22.87,-98.01 -35.61,-143.99 l -145.25,-114.21 -43.01,54.7 138.17,108.66 c 38.2,30.04 43.45,52.48 24.55,76.53 -11.51,14.62 -33.56,23.24 -66.98,25.96 l -161.75,-127.2 -42.64,54.24 138.16,108.64 c 38.21,30.04 43.46,52.49 24.16,77.01 -11.11,14.14 -33.51,23.23 -66.95,25.96 l -161.76,-127.2 -42.63,54.23 231.56,182.08" /><path
								 id="path60"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 5189.06,2738.39 35.8,-41.69 c -25.88,-21.03 -43.91,-42.69 -50.77,-71.88 -7.26,-30.95 3.91,-48.99 23.77,-53.65 23.95,-5.62 41.72,22.87 60.53,50.49 22.93,34.67 54.55,72.24 102.44,60.98 50.24,-11.79 76.39,-60.45 61.31,-124.7 -9.33,-39.72 -33.22,-68 -56.82,-87.11 l -33.61,40.56 c 19.26,16.43 34.01,34.54 39.34,57.31 6.72,28.63 -3.56,45.22 -21.66,49.47 -22.78,5.35 -38.24,-21.22 -56.62,-49.56 -23.79,-35.71 -52.62,-74.54 -106.35,-61.93 -49.06,11.53 -79.59,59.98 -62.6,132.4 9.2,39.13 35.88,76.62 65.24,99.31" /><path
								 id="path62"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 877.004,2127.27 -18.457,53.91 36.465,17.56 -0.782,2.28 c -32.929,14.71 -62.128,35.15 -73.984,69.77 -14.004,40.87 -3.242,70.57 23.516,94.3 -37.52,16.96 -68.614,37.39 -80.664,72.57 -20.215,59.04 10.761,100.08 81.132,124.18 l 174.83,59.87 22.53,-65.84 -166.285,-56.96 c -45.977,-15.74 -58.34,-35.19 -48.418,-64.14 6.015,-17.6 23.965,-33 54.629,-46.6 l 194.684,66.66 22.35,-65.27 -166.312,-56.95 c -45.957,-15.74 -58.34,-35.19 -48.222,-64.71 5.839,-17.02 23.984,-33.01 54.648,-46.6 l 194.666,66.66 22.37,-65.27 -278.696,-95.42" /><path
								 id="path64"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 839.582,2855.55 c -58.809,-8.38 -93.691,-40.03 -87.598,-82.8 6.114,-42.78 48.36,-62.81 107.168,-54.42 58.223,8.3 93.203,39.35 87.09,82.12 -6.094,42.77 -48.437,63.41 -106.66,55.1 z m 29.57,-207.32 c -97.422,-13.9 -162.675,44.08 -173.007,116.56 -10.43,73.06 36.015,146.97 133.437,160.86 96.836,13.82 162.09,-44.16 172.498,-117.23 10.33,-72.47 -36.092,-146.38 -132.928,-160.19" /><path
								 id="path66"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 900.285,3001.74 -347.832,-10.73 -2.129,68.96 351.446,10.84 c 16.777,0.52 22.539,8.49 22.324,15.69 -0.098,2.99 -0.176,5.4 -1.543,10.76 l 51.308,10.59 c 3.868,-8.28 6.621,-20.21 7.129,-36.4 1.504,-49.18 -29.726,-68.15 -80.703,-69.71" /><path
								 id="path68"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 2091.67,1305.59 62.54,-30.55 -78.22,-160.12 1.62,-0.78 203.83,98.75 69.55,-33.98 -175.53,-84.53 21.62,-277.001 -69,33.711 -14.32,212.67 -81.5,-38.33 -50.29,-102.969 -62.54,30.551 172.24,352.578" /><path
								 id="path70"
								 style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 4015.17,1036.16 90.56,42.89 -33,37.48 c -29.1,32.01 -58.66,67.81 -87.44,101.98 l -2.17,-1.03 c 8.96,-44.21 17.65,-89.22 24,-132.02 z m -89.86,213.7 73.75,34.92 283.39,-299.979 -66.15,-31.332 -73.1,82.901 -119.3,-56.491 17.77,-109.078 -63.98,-30.289 -52.38,409.348" /><path
								 id="path72"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 1799.86,3882.72 23.98,35.94 85.41,-85.35 0.88,1.33 -35,160.9 26.41,39.6 33.02,-137.93 163.75,-38.55 -24.86,-37.27 -134.02,34.11 13.75,-65.92 59.45,-59.38 -23.98,-35.94 -188.79,188.46" /><path
								 id="path74"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 2172.45,3825.3 c -28.8,25.17 -27.65,59.8 -7.55,82.8 9.66,11.07 20.8,15.29 31.77,16.85 l 4.57,-21.35 c -8.02,-1.03 -14.16,-3.43 -18.9,-8.87 -12.13,-13.88 -9.16,-33.51 8.22,-48.71 17.23,-15.05 36.91,-15.54 48.75,-2.01 5.82,6.67 7.85,15.73 8.12,24.18 l 20.57,-3.41 c -0.04,-14.22 -5.43,-27.48 -14.02,-37.31 -20.59,-23.54 -52.89,-27.19 -81.53,-2.17" /><path
								 id="path76"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 2304.97,3929.52 -36.99,38.51 c -10.57,-0.45 -17.91,-3.94 -23.46,-9.27 -10.58,-10.18 -9.62,-28.34 7.02,-45.66 17.12,-17.82 33.06,-20.94 45,-9.47 6.4,6.14 9.02,14.17 8.43,25.89 z m -73.28,-35.82 c -25.86,26.91 -24.71,59.71 -6.72,77 9.42,9.05 18.69,11.17 30.43,11.76 l -13.43,12.64 -28.77,29.93 19.33,18.59 114.08,-118.72 -15.97,-15.35 -9.91,7.62 -0.68,-0.65 c -0.23,-11.87 -3.94,-24.82 -12.87,-33.39 -20.68,-19.88 -49.32,-16.67 -75.49,10.57" /><path
								 id="path78"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 3042.38,4617.39 42.79,-0.22 -17.64,-83.11 -7.73,-28.34 h 1.6 c 20.08,17.09 41.35,30.17 64.94,30.05 32.79,-0.17 46.31,-18.23 46.13,-49.82 -0.04,-9.19 -0.88,-17.2 -3.34,-27.58 l -25.43,-123.85 -42.79,0.22 24.61,118.25 c 1.64,9.19 3.28,14.78 3.3,20.78 0.08,16.8 -7.87,25.24 -24.67,25.32 -13.59,0.07 -28.83,-9.05 -49.74,-30.13 l -27.07,-133.84 -43.19,0.21 58.23,282.06" /><path
								 id="path80"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 4063.61,3969.75 c 55.33,43.51 130.93,37.33 168.75,-10.76 14.84,-18.87 16.42,-38.99 13.02,-55.39 l -35.25,2.79 c 2.48,13.66 1.31,22.91 -6.84,33.29 -21.75,27.66 -72.85,26.65 -111.21,-3.52 -23.28,-18.29 -28.63,-39.29 -12.3,-60.04 9.39,-11.95 22.46,-16.93 34.94,-19.84 l -10.02,-31.27 c -17.64,4.95 -39.41,13.25 -57.72,36.52 -26.71,33.95 -23.28,76.82 16.63,108.22" /><path
								 id="path82"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 4331.79,2835.92 107.71,16.89 84.22,11.81 0.26,1.57 -76.16,37.56 -96.85,49.83 z m 16.17,168.82 217.25,-119.33 -8.81,-54.09 -243.85,-43.74 -27.64,4.5 35.41,217.16 27.64,-4.5" /><path
								 id="path84"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 4251.87,2715.23 135.19,0.11 c 8.93,0.01 18.03,0.93 27.31,2.77 9.28,1.83 15.21,6.63 17.81,14.41 1.25,3.7 1.82,8.04 1.7,13.03 l 7.36,0.41 3.38,-52.44 -2.73,-8.15 -158.73,-0.85 51.52,-50.89 c 9.24,-9.29 17.01,-15 23.3,-17.1 5.06,-1.71 12.5,-3.04 22.34,-4.02 7.21,-0.62 12.49,-1.5 15.81,-2.63 12.22,-4.1 16.11,-12.76 11.68,-25.96 -3.95,-11.73 -11.47,-15.73 -22.58,-12 -10.98,3.69 -29.22,18.89 -54.73,45.6 l -82.38,86.59 3.75,11.12" /><path
								 id="path86"
								 style="fill:none;stroke:#393536;stroke-width:5;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:10;stroke-dasharray:none;stroke-opacity:1"
								 d="m 4251.87,2715.23 135.19,0.11 c 8.93,0.01 18.03,0.93 27.31,2.77 9.28,1.83 15.21,6.63 17.81,14.41 1.25,3.7 1.82,8.04 1.7,13.03 l 7.36,0.41 3.38,-52.44 -2.73,-8.15 -158.73,-0.85 51.52,-50.89 c 9.24,-9.29 17.01,-15 23.3,-17.1 5.06,-1.71 12.5,-3.04 22.34,-4.02 7.21,-0.62 12.49,-1.5 15.81,-2.63 12.22,-4.1 16.11,-12.76 11.68,-25.96 -3.95,-11.73 -11.47,-15.73 -22.58,-12 -10.98,3.69 -29.22,18.89 -54.73,45.6 l -82.38,86.59 z" /><path
								 id="path88"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 1649.84,2634.76 -11.27,40.88 132.56,89.59 50.33,29.62 -0.43,1.54 c -26.68,-4.03 -60.08,-10.74 -89.06,-12.49 l -120.79,-8.78 -11.03,40.1 266.07,18.92 11.16,-40.49 -132.27,-89.1 -51.11,-29.84 0.43,-1.54 c 27.83,4.36 59.53,9.77 88.49,11.52 l 121.96,9.09 10.93,-39.71 -265.97,-19.31" /><path
								 id="path90"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 1922.98,2930.44 -4.76,38.64 -17.88,-7.6 c -15.35,-6.83 -32.16,-13.36 -48.3,-19.82 l 0.14,-0.93 c 17.38,-2.08 35.06,-4.37 51.62,-7.25 z m -89.8,-7.1 -3.91,31.48 145.27,67.98 3.5,-28.23 -39.51,-16.86 6.29,-50.91 42.42,-6.75 3.36,-27.31 -157.42,30.6" /><path
								 id="path92"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 2534.78,2034.44 38.45,-18.79 -109.96,-143.93 1.45,-0.7 118.2,44.18 43.11,-21.08 -108.03,-40.69 -7.3,-121.53 -38.83,18.97 8.12,93.09 -51.54,-18 -29.88,-39.26 -38.81,18.98 175.02,228.76" /><path
								 id="path94"
								 style="fill:#393536;fill-opacity:1;fill-rule:nonzero;stroke:none"
								 d="m 3701.09,1884.84 c -1.14,5.21 -2.82,10.61 -5.55,16.39 -8.2,17.37 -22.79,29.49 -44.49,19.22 -21.33,-10.1 -34.1,-38.26 -28.42,-72.74 z m -59.53,67.85 c 41.21,19.5 69.92,-1.88 87.36,-38.75 7.36,-15.55 10,-34.21 10.19,-41.2 l -108.1,-51.16 c 13.83,-39.48 42.32,-45.46 69.08,-32.81 12.66,5.99 23.14,19.37 29.47,31.21 l 26.27,-18.1 c -9.67,-16.97 -26.52,-35.57 -51.85,-47.54 -42.31,-20.02 -84.22,-6.23 -106.8,41.49 -31.31,66.17 -2.27,134.79 44.38,156.86" /></g></g></svg>
			</xsl:when>
			<xsl:otherwise><!-- empty -->
				<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" xml:space="preserve"
				viewBox="0 0 2 2">
					<rect x="0" y="0" width="2" height="2" style="fill:#fff;fill-opacity:0;stroke:none"/>
				</svg>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:variable>

	<xsl:variable name="Image-Logo-BIPM-Metro">
		<xsl:text>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</xsl:text>
	</xsl:variable>

	<xsl:template name="insert_Logo-BIPM-Metro">
		<fo:block-container absolute-position="fixed" left="47mm" top="67mm">
			<fo:block>
				<fo:instream-foreign-object content-width="118.6mm" fox:alt-text="Image Logo">								
					<svg xmlns="http://www.w3.org/2000/svg" height="547.66" width="547.66" version="1.0">
						<path id="path4" d="m543.54 276.94a276.23 276.23 0 1 1 -552.47 0 276.23 276.23 0 1 1 552.47 0z" transform="matrix(.95831 0 0 .95831 17.669 8.4373)" fill="#fff"/>
						 <path id="path6" d="m382 55.094c-2.56 0-7.13 3.091-7.91 5.344-1.88 5.447-2.31 5.759-1.81 1.312 0.32-2.85 0.14-4.688-0.47-4.688-2.15 0-6.03 2.346-6.03 3.657 0 0.988-0.64 1.191-2.22 0.687-4.12-1.314-5.15-0.987-5.47 1.75-0.16 1.461 0.23 3.597 0.85 4.75 0.92 1.723 0.79 2.38-0.69 3.5-0.99 0.75-2.98 1.358-4.44 1.375-3.34 0.04-4.08 1.18-2.28 3.563 1.98 2.616 1.81 4.344-0.44 4.344-1.05 0-2.17 0.416-2.5 0.937-0.36 0.596-33.67 0.916-90.06 0.844-82.35-0.106-89.47-0.26-89.47-1.75 0-1.939-1.85-3.969-3.62-3.969-0.71 0-1.31 0.772-1.32 1.719 0 0.947-0.37 2.298-0.84 3.031-0.49 0.774-0.64-1.666-0.34-5.812 0.5-6.969 0.47-7.112-1.63-6.563-1.78 0.467-2.29 0.077-2.78-2.375-1.05-5.272-5.15-4.555-5.19 0.906-0.01 2.427-1.12 2.744-4.03 1.188-1.33-0.711-2.52-0.695-3.93 0.062l-2.04 1.063 1.97 3.312c2.08 3.518 1.88 4.438-1 4.438-2.27 0-2.32 1.74-0.09 4.281 1.61 1.837 1.61 1.92 0.03 1.344-1.57-0.571-4.73 1.495-4.69 3.062 0.01 0.367 1.42 1.65 3.13 2.844l3.12 2.156-2.59 0.969c-2.98 1.134-4.92 4.21-4.06 6.437 0.76 1.988 5.9 2.038 6.65 0.063 0.81-2.113 2.25-1.806 2.88 0.594 0.4 1.561 1.05 1.891 2.59 1.411 1.47-0.47 2.03-0.24 2.03 0.87 0 0.85 0.59 1.56 1.31 1.56 2.14 0 4.64-3.438 5.26-7.216 0.71-4.436 3.15-5.477 5.62-2.438 1.02 1.251 2.55 3.165 3.44 4.25 0.88 1.085 2.71 2.704 4.09 3.594 3 1.93 4.29 6.75 6.38 23.94 0.79 6.5 2.47 14.74 3.71 18.34 2.3 6.64 7.35 15.6 8.79 15.6 0.43 0 0.75 0.48 0.75 1.09s0.79 1.84 1.75 2.72c2.04 1.88 7.53 9.13 7.71 10.19 0.07 0.4 0.27 5.06 0.41 10.34l0.25 9.59 0.72-7.12c0.85-8.07 1.56-10.46 2.81-9.69 0.48 0.29 1.2 1.98 1.6 3.75 1.61 7.17 2.93 36.36 1.43 31.75-0.52-1.62-0.85-4.58-0.75-6.59 0.11-2.02-0.12-3.97-0.5-4.35-1.93-1.93-0.29 22.53 1.94 28.85 0.48 1.35 0.35 1.49-0.56 0.65-0.66-0.6-1.81-6.12-2.59-12.28-2.86-22.5-2.99-23.12-3.85-21.19-0.48 1.08 0.02 7.74 1.19 16.22 1.09 7.93 1.83 14.58 1.66 14.78-0.18 0.2-2.01 0.05-4.07-0.37-3.7-0.77-3.71-0.81-0.9-1.38l2.81-0.56-4.28-4.66c-5.51-5.94-10.39-8-16.75-7.12l-4.78 0.66v-4.04c0-2.21 0.4-4.03 0.9-4.03s2.31-1.2 4.03-2.65c2.79-2.35 3.09-3.05 2.63-6.5-0.35-2.57-1.6-4.97-3.69-7.13l-3.12-3.28 3.06-3.91c3.29-4.15 3.83-6.44 1.84-7.71-2.35-1.51-8.11-3.24-10.84-3.25-3.68-0.02-7.98 4.18-7.1 6.96 0.58 1.8 0.42 1.95-1.34 1-2.83-1.51-6.21-1.31-8.81 0.5-2.11 1.48-2.41 1.41-4.81-1-1.4-1.4-3.51-2.53-4.72-2.53-8.22 0-17.78 11.67-10.32 12.6 1.35 0.17 4.34 1.01 6.66 1.87 4.2 1.56 4.22 1.57 2.34 3.63-3 3.3-4.29 6.47-3.65 9 0.81 3.21 6.27 9.28 8.37 9.28 1.57 0 4.94 2.84 4.94 4.15 0 0.31-1.2 0.86-2.69 1.22-4.9 1.21-11.85 6.72-13.75 10.88-0.98 2.16-3.11 6.27-4.72 9.12-2.38 4.25-3.36 5.14-5.37 5-2.59-0.17-5.55 0.81-7.66 2.54-0.69 0.56-1.84 1.49-2.53 2.03-0.68 0.54-2.64 2.28-4.34 3.84l-3.1 2.81-6.09-5.28c-4.892-4.24-6.849-6.83-9.842-13.16-2.583-5.45-4.963-8.9-7.719-11.15-2.288-1.87-3.969-4.1-3.969-5.25 0-1.19-0.819-2.22-2-2.53-1.382-0.36-1.825-1.06-1.438-2.28 0.308-0.97 0.127-2.06-0.437-2.41-0.599-0.37-0.815-2.15-0.469-4.31 0.402-2.52 0.143-4.21-0.781-5.16-0.87-0.89-1.324-3.59-1.313-7.5 0.022-7.2-1.811-9.49-6.937-8.62-2.025 0.34-3.481 0.05-4.281-0.91-1.067-1.29-1.505-1.31-3.594 0.06-1.303 0.86-2.375 2.4-2.375 3.41s-1.116 2.55-2.469 3.44c-1.612 1.05-2.425 2.52-2.406 4.21 0.036 3.2 4.833 8.68 8.375 9.57 1.719 0.43 3.11 1.76 4.031 3.97 0.768 1.83 2.635 4.13 4.156 5.06 1.522 0.93 2.587 2.18 2.376 2.81-0.212 0.63 0.247 1.75 1.031 2.47 1.028 0.95 1.3 2.72 0.937 6.28-0.425 4.18-0.11 5.6 2.188 9.41 1.494 2.47 3.954 5.32 5.468 6.34 1.68 1.13 3.554 3.92 4.782 7.13 2.146 5.6 4.968 10.29 4.968 8.25 0.001-0.68-1.116-3.49-2.5-6.22-1.383-2.73-2.312-5.46-2.093-6.1 0.337-0.97 4.593 7.05 4.593 8.66 0.001 0.31 0.943 2.55 2.094 5 2.328 4.95 1.909 7.13-0.531 2.75l-1.563-2.81 0.25 3.93c0.205 3.26-0.134 4.1-1.968 4.91-1.218 0.54-2.219 1.34-2.219 1.75s-0.684 0.72-1.531 0.72c-2.435 0-7.956 4.71-9.282 7.91-1.519 3.66-0.294 5.42 4.469 6.31 3.207 0.6 4.862 2.52 2.188 2.53-1.81 0.01-5.807 6.32-5.125 8.09 0.679 1.77 4.408 3.3 8.656 3.57 1.268 0.08 1.676 0.79 1.469 2.37-0.335 2.56 3.4 9.09 5.687 9.97 1.669 0.64-0.08 2.88-7.718 10.13-4.699 4.45-5.423 7.06-6.25 21.84-0.39 6.96-1.275 13.29-2.032 14.75-0.729 1.41-4.971 7-9.437 12.47-6.854 8.38-10.685 12.09-17.969 17.34-0.541 0.39-2.246 1.85-3.812 3.22-1.567 1.37-2.966 2.47-3.094 2.47-0.063 0-0.337-0.44-0.75-1.22l0.531 7.94 4.937 2.87c-0.651-1.08 0.805-1.44 5-1.44 4.263 0 6.007-0.53 8.876-2.71 1.958-1.5 3.562-3.13 3.562-3.63s1.116-2.1 2.469-3.56c1.352-1.46 2.437-3.19 2.437-3.84 0-0.66 1.468-2.56 3.219-4.19l3.156-2.94 1.188 2.25c1.015 1.94 0.694 3.19-2.188 9.06-1.842 3.75-3.358 7.8-3.375 9-0.019 1.43-1.049 2.74-3 3.75-3.26 1.69-5.038 5.05-4.25 8.07 0.437 1.67 0.104 1.85-2.75 1.46-2.273-0.31-2.996-0.12-2.312 0.6 0.541 0.57 3.181 1.17 5.844 1.34 2.762 0.18 4.987 0.83 5.218 1.53 0.223 0.68-0.334 1.25-1.281 1.25s-1.434 0.29-1.063 0.66c0.967 0.97 9.794 0.39 10.907-0.72 0.587-0.58-0.241-0.94-2.219-0.94-1.731 0-3.156-0.38-3.156-0.87 0-0.5 3.12-0.84 6.906-0.75 3.786 0.08 6.874 0.5 6.875 0.9 0.001 0.41 1.949 0.72 4.313 0.72 5.443 0 20.842 2.68 23.432 4.06 2.75 1.48 17.39 1.13 27.35-0.62 4.6-0.81 10.13-1.47 12.31-1.47s5.03-0.72 6.31-1.62l2.35-1.66-0.6 3.63c-0.7 4.31-0.01 4.46 7.28 1.59 3.16-1.24 6.15-1.8 7.82-1.44 2.52 0.55 2.6 0.8 1.59 3.47-1.49 3.96-0.34 4.6 5.03 2.78 3.75-1.27 6.93-1.45 16.91-0.9 6.76 0.37 13.05 0.32 13.94-0.1 0.88-0.42 2.89-0.78 4.43-0.75 1.55 0.03 4.79 0.07 7.22 0.06 7.22-0.01 23.66 4.03 20.25 4.82l4.94 4.93 8.34-5.9c-0.23-0.08-0.37-0.13-0.28-0.22 0.85-0.84 5.83-1.52 14.75-1.97 7.42-0.37 17.25-0.99 21.85-1.34 4.63-0.36 10.21-0.2 12.53 0.34 2.44 0.57 4.43 0.61 4.75 0.09 0.3-0.48 2.2-0.87 4.25-0.87 2.24 0 5.8-1.15 8.9-2.85 4.65-2.53 5.94-2.8 13.07-2.56 5.77 0.2 9.37-0.22 13.34-1.59 6.9-2.37 10.77-2.37 12.84 0 1.82 2.07 9 3.56 9 1.87 0-0.67 0.53-0.6 1.44 0.16 2.03 1.69 18.25-0.15 18.25-2.06 0-0.47 1.66-0.85 3.66-0.85 3.94 0 3.48-1.44-0.72-2.31-1.35-0.28-0.7-0.34 1.47-0.12 5.01 0.5 7.91 1.04 12.69 2.28 2.23 0.58 5.93 0.67 8.87 0.22 2.77-0.43 8.02-0.66 11.69-0.5 4.31 0.18 7.93-0.21 10.22-1.16 2.5-1.05 3.84-1.18 4.59-0.44 1.29 1.3 6.53 1.4 6.53 0.13 0-0.51-1.43-1.13-3.19-1.35l-3.18-0.37 3.53-0.16c2.89-0.13 3.71 0.27 4.62 2.28 1.11 2.43 1.35 2.47 12.88 2.47 6.43 0 13.04 0.27 14.68 0.6l2.76 0.59 7.21-2.59 5.13-17.63c-2.18 3.66-3.05 3.89-5.78 4.09-6.24 0.48-8.37-3.32-11.5-20.46-0.94-5.14-2.33-11.35-3.06-13.78-1.2-3.95-2.51-11.38-3.85-21.63-0.66-5.08-2.05-11.56-3.94-18.22-0.91-3.24-2.07-8.53-2.56-11.78s-1.35-7.91-1.87-10.34c-0.53-2.44-0.95-8.45-0.97-13.35-0.03-4.89-0.45-9.33-0.91-9.84-0.76-0.85-2.08-5.49-3.53-12.44-0.87-4.17 0.46-10.41 3-13.87 2.99-4.08 3.76-5.83 5.81-13.13 1.36-4.82 2.69-6.96 6.47-10.62 3.7-3.59 4.87-5.49 5.35-8.69 1.49-9.97-0.81-15.22-5.6-12.66-8.57 4.58-10.26 5.94-12.09 9.75-1.08 2.24-2.87 4.34-3.97 4.63-4.51 1.17-11.34 9.84-11.34 14.4-0.01 1.79-2.28 4.16-3.16 3.29-0.3-0.3-2.08 1.04-3.94 2.96-2.45 2.53-3.72 5.06-4.62 9.16-1.94 8.75-2.09 8.88-9.63 9.34-3.89 0.24-9.34 1.44-13.12 2.91-5.51 2.14-7.21 2.38-11.6 1.69-2.83-0.45-5.92-1.05-6.84-1.35-2.21-0.71-8.22-13.57-8.81-18.84l-0.47-4.13 3.78-0.53c2.09-0.3 6.93-0.86 10.72-1.21 3.78-0.36 7.33-0.96 7.87-1.35s2.74-1.22 4.91-1.84c2.16-0.63 5.18-2.14 6.72-3.38 2.47-1.99 2.91-3.24 3.78-10.62 0.54-4.59 0.68-14.75 0.34-22.6-0.57-13.08-0.84-14.77-3.5-20.34-5.49-11.5-20.47-24.43-25.9-22.34-1.57 0.6-1.57 0.76 0 2.5 0.91 1.01 2.18 1.84 2.84 1.84s1.73 0.6 2.34 1.34c0.86 1.03 0.72 1.68-0.5 2.69-1.26 1.05-1.45 2.38-0.97 6.5 0.73 6.2-0.04 7.8-6.81 14.41-6.03 5.89-13.39 10.69-18.78 12.25-5.68 1.64-5.63 1.67-4.94-3.41 0.52-3.76 0.18-5.52-1.97-9.91-1.43-2.92-3.97-6.32-5.65-7.56-3.93-2.9-10.69-5.5-14.28-5.5-4.8 0-12.93 3.17-16.19 6.32-2.96 2.85-2.97 3-0.94 3.31 1.17 0.18 2.36 1.01 2.69 1.87 0.68 1.77-2.01 5.22-4.06 5.22-0.75 0-1.6 0.66-1.91 1.47-0.76 1.97-2.31 1.89-2.31-0.13 0-1.93 2.76-4.2 5.15-4.24 0.95-0.02 1.72-0.52 1.72-1.1 0-0.59-0.82-0.77-1.87-0.44-1.32 0.42-2.02 0.05-2.28-1.18-0.3-1.4-0.8-1.04-2.5 1.68-1.47 2.35-2.19 5.03-2.19 8.38 0 5.38 3.29 15.28 5.5 16.53 2.08 1.18 1.66 3.62-0.97 5.69-1.8 1.41-2.41 3.02-2.75 7.09-0.3 3.64-1.12 6.01-2.59 7.59-1.18 1.27-2.16 3.02-2.16 3.88s-0.58 2.43-1.31 3.5-2.78 5.71-4.53 10.31-3.54 9.13-4.03 10.07c-0.5 0.93-0.96 2.71-1 3.93-0.04 1.23-0.93 3.57-1.97 5.19s-2.74 4.71-3.78 6.88c-1.6 3.3-1.91 3.56-1.97 1.59-0.04-1.29 0.82-3.83 1.94-5.63 1.81-2.93 1.97-4.36 1.53-14.12-0.53-11.61 0.39-16.32 3.31-17.25 3.39-1.08 6.74-7.7 9.22-18.22 3.95-16.74 4.56-22.39 4.56-40.78v-17.47l6-6.09c6.7-6.86 8.44-10.16 11.69-22.22 2.75-10.21 3.97-17.17 4.59-25.57 0.47-6.3 0.59-6.45 6.1-11.53 3.07-2.828 5.88-5.144 6.24-5.152 0.37-0.009 0.98-2.577 1.38-5.688 0.65-5.09 0.8-5.393 1.5-2.812 1.07 3.911 4.81 6.298 4.81 3.062 0-1.654 2.5-2.02 3.44-0.5 0.33 0.541 1.48 0.969 2.53 0.969 2.66 0 2.48-3.649-0.31-6.688l-2.22-2.406 2.22 1.344c1.22 0.742 2.22 1.665 2.22 2.062 0 0.825 5.3 3.719 6.81 3.719 0.55 0 1.5-0.934 2.12-2.094 0.98-1.828 0.69-2.519-2.03-5.062-2.4-2.249-3.01-3.457-2.56-5.25 0.45-1.783 0.2-2.344-1.09-2.344-1.32 0-1.42-0.238-0.5-1.156 0.65-0.649 1.18-2.026 1.18-3.063 0-1.513 0.42-1.767 2.19-1.187 1.22 0.397 3.57 0.803 5.19 0.875 2.78 0.122 2.94-0.083 2.94-3.594 0-2.175 0.58-4.115 1.4-4.625 2.04-1.257-0.4-3.969-3.56-3.969-1.96 0-2.29-0.367-1.78-1.969 0.45-1.429 0.19-1.968-1-1.968zm-2.31 2.156c0.8-0.108 0.85 1.148-0.5 3.219-0.9 1.369-2.04 2.5-2.57 2.5-1.42 0-1.16-1.206 0.94-3.938 0.9-1.169 1.64-1.716 2.13-1.781zm-10.94 2.781c0.54 0 0.98 0.543 0.97 1.219s-0.45 1.907-0.97 2.719c-0.74 1.15-0.96 0.858-0.97-1.25-0.01-1.488 0.43-2.688 0.97-2.688zm15.69 1.344c0.29-0.018 0.54-0.015 0.75 0.063 0.84 0.324 1.33 0.79 1.09 1.031-1.16 1.164-7.72 3.367-7.72 2.593 0-1.319 3.84-3.56 5.88-3.687zm-23.66 1.719c0.44-0.019 1.21 0.547 2.34 1.687 1.88 1.877 1.96 2.323 0.69 3.125-2.24 1.426-2.65 1.184-3.22-1.75-0.39-2.053-0.37-3.038 0.19-3.062zm-204.72 3.281c0.07-0.016 0.11-0.016 0.19 0.031 0.54 0.335 1 2.598 1 5 0 2.403-0.46 4.344-1 4.344s-0.97-2.232-0.97-4.969c0-2.684 0.3-4.294 0.78-4.406zm225.66 0.719c1.32-0.047 2.75 0.724 2.75 1.75 0 1.227-1.95 1.316-3.78 0.156-0.98-0.617-1.05-1.05-0.22-1.562 0.35-0.218 0.81-0.329 1.25-0.344zm-12.97 2.844c0.81-0.03 2.13 0.381 2.94 0.906 1.8 1.162 0.23 1.162-2.47 0-1.3-0.558-1.44-0.871-0.47-0.906zm-221.22 0.937c0.57 0.001 1.66 0.356 3.28 1.094 1.38 0.628 2.5 1.973 2.5 2.969 0 2.4-0.31 2.299-4.09-1.157-2.1-1.915-2.63-2.908-1.69-2.906zm13.13 1.5c0.36-0.043 0.52 1.09 0.53 3.625 0.01 2.57-0.13 4.688-0.31 4.688-1.77 0-2.26-5.45-0.69-7.876 0.17-0.266 0.34-0.423 0.47-0.437zm195.28 1.406c2.58 0 6.99 2.538 5.78 3.313-0.2 0.127-1.12 0.806-2.06 1.531-0.95 0.725-1.75 0.948-1.75 0.469s-0.95-1.341-2.13-1.875c-3.46-1.562-3.38-3.438 0.16-3.438zm13.22 0c0.23 0 0.72 0.459 1.06 1 0.33 0.541 0.13 0.969-0.44 0.969s-1.03-0.428-1.03-0.969 0.17-1 0.41-1zm2.03 3.969c1.96 0.016 1.96 0.054 0 1.219-2.56 1.512-6.38 2.031-6.38 0.875 0-1.005 3.36-2.119 6.38-2.094zm-223.63 1.125c0.33-0.012 0.67-0.006 1.06 0.031 1.76 0.17 3.22 0.74 3.22 1.282 0 1.1-3.29 1.604-5.18 0.812-2.15-0.897-1.4-2.043 0.9-2.125zm18.03 2.437c0.33 0.009 0.56 0.835 0.91 2.688 0.7 3.744 1.43 4.289 3.25 2.469 0.6-0.602 1.61-0.768 2.25-0.375 0.78 0.481 0.47 1.091-1.03 1.844-2.45 1.23-4.07 4.241-1.78 3.312 4.83-1.964 5.29-1.89 2.81 0.312-2.3 2.044-2.32 2.125-0.31 1.5 1.99-0.619 2.07-0.507 1 1.813-0.64 1.372-1.41 2.527-1.72 2.531-1.05 0.015-5.96-8.222-6.5-10.906-0.3-1.47-0.09-3.438 0.44-4.375 0.29-0.53 0.49-0.818 0.68-0.813zm207.72 0.844c0.09-0.012 0.18-0.004 0.28 0 0.23 0.011 0.5 0.076 0.82 0.188 2.18 0.775 5.15 3.288 5.15 4.375 0 1.281-2.23 0.897-4.68-0.813-2.19-1.521-2.81-3.562-1.57-3.75zm-221.53 0.719c3.12-0.082 5.7 0.327 6.28 1.031 0.76 0.914-0.27 1.188-4.4 1.188-7.32 0-9.03-2.031-1.88-2.219zm31.13 0.75c3.19 0 3.84 0.336 3.84 1.969 0 1.729-0.65 1.968-5.41 1.968-3.96 0-5.4-0.369-5.4-1.374 0-1.77 2.16-2.563 6.97-2.563zm103.59 0c5.33 0 7.42 0.364 7.81 1.375 0.29 0.759 0.26 1.645-0.06 1.969-0.32 0.323-3.84 0.593-7.81 0.593-6.56 0-7.22-0.18-7.22-1.968 0-1.79 0.66-1.969 7.28-1.969zm64.28 0c1.22-0.008 2.22 0.459 2.22 1 0 1.232-1.03 1.232-2.94 0-1.19-0.771-1.07-0.988 0.72-1zm-85.03 0.125c0.9-0.008 2.04 0.029 3.5 0.094 5.28 0.233 6.58 0.604 6.84 2 0.29 1.515-0.52 1.718-7 1.718-6.92 0-7.37-0.108-6.87-2 0.35-1.355 0.84-1.788 3.53-1.812zm-73.78 0.438c0.15-0.016 0.3-0.006 0.47 0 11.3 0.361 12.03 0.477 12.03 1.843 0 1.951-0.55 2.052-8.19 1.719-5.7-0.248-6.62-0.545-6.34-1.969 0.17-0.884 0.95-1.487 2.03-1.593zm23.72 0.437c5.37 0 7.42 0.346 7.81 1.375 0.29 0.767-0.15 1.653-0.97 1.969-0.82 0.315-4.34 0.562-7.81 0.562-5.66 0-6.31-0.174-6.31-1.937 0-1.79 0.66-1.969 7.28-1.969zm18.28 0c5.46 0 6.91 0.298 6.91 1.469s-1.45 1.468-6.91 1.468c-5.47 0-6.88-0.297-6.88-1.468s1.41-1.469 6.88-1.469zm16.72 0c5.46 0 6.9 0.298 6.9 1.469s-1.44 1.468-6.9 1.468c-5.47 0-6.88-0.297-6.88-1.468s1.41-1.469 6.88-1.469zm74.84 0c4.55 0 7.78 0.396 7.78 0.969 0 0.579-3.45 1-8.4 1-5.37 0-8.2-0.374-7.82-1 0.34-0.541 4.14-0.969 8.44-0.969zm14.75 0c2.41 0 3.74 0.375 3.38 0.969-0.34 0.541-2.14 1-4 1-1.87 0-3.38-0.459-3.38-1s1.81-0.969 4-0.969zm25.81 0.375c0.36-0.067 1.08 0.515 2.38 1.812 1.46 1.46 2.43 2.882 2.15 3.157-0.9 0.901-4.84-2.475-4.84-4.157 0-0.482 0.1-0.772 0.31-0.812zm-60.5 0.062c4.08-0.069 8.12 0.264 8.32 1.032 0.14 0.584-3.3 1.08-8.47 1.25-6.77 0.222-8.58 0.018-8.25-0.969 0.26-0.775 4.33-1.243 8.4-1.313zm49.82 0c0.47 0.033 0.53 0.614 0.53 1.969 0 4.746-4.95 12.24-9.91 14.939-5.56 3.02-6.77 5.42-7.78 15.59-1.5 15.08-6.35 32.05-8.75 30.56-0.44-0.27-2.07 0.92-3.59 2.63-1.72 1.93-2.32 3.26-1.6 3.5 0.75 0.25 0.23 1.67-1.47 4-2.96 4.09-8.22 8.68-8.22 7.19 0.01-0.55 1.35-1.97 2.97-3.13 1.63-1.15 2.94-2.51 2.94-3.03s-1.29 0.02-2.91 1.22c-3.28 2.43-3.92 2.23-3.96-1.22-0.07-5.98 1.51-10.52 4.65-13.16 1.76-1.47 3.22-3.29 3.22-4.06 0-0.76 0.46-1.37 1.03-1.37 0.58 0 0.8-0.45 0.47-0.97-0.32-0.53-1.88 0.48-3.47 2.22-3.95 4.35-3.7 1.83 0.72-6.53 3.65-6.92 4.52-8.28 6.91-10.94 0.67-0.76 1.22-1.77 1.22-2.28 0-0.52 0.68-1.52 1.53-2.22 0.84-0.7 2.22-2.52 3-4.03 1.24-2.41 1.22-2.67-0.03-2.19-1.22 0.47-1.25 0.07-0.25-2.72 1.5-4.2 3.19-6.04 8.15-8.87 5.07-2.905 10.22-7.264 10.22-8.629 0-0.576-0.92-1.062-2.03-1.062-1.22 0-1.74-0.414-1.34-1.063 0.36-0.593 1.94-0.916 3.5-0.687s2.84 0.098 2.84-0.313c0-1.242-3.77-2.058-6.12-1.312-1.97 0.622-2.1 0.563-0.91-0.875 0.74-0.89 2.23-1.625 3.28-1.625s2.77-0.471 3.81-1.032c0.62-0.33 1.06-0.519 1.35-0.5zm-211.29 0.532c1.07 0 2.77 0.589 3.76 1.312 2.85 2.089 1.38 3.506-1.69 1.625-3.86-2.364-4.27-2.937-2.07-2.937zm218.54 0.406c0.06 0.011 0.11 0.051 0.18 0.094 0.54 0.334 0.97 1.45 0.97 2.5s-0.43 1.906-0.97 1.906-1-1.115-1-2.5c0-1.071 0.27-1.815 0.63-1.969 0.06-0.025 0.13-0.042 0.19-0.031zm-208.13 0.594c2.43 0.011 2.84 0.245 1.72 0.968-1.93 1.25-4.91 1.25-4.91 0 0-0.541 1.43-0.977 3.19-0.968zm149.47 6.031c31.7-0.018 35.18 0.524 32.44 2.219-0.47 0.289-0.68 1.576-0.44 2.812 0.28 1.459-0.47 3.244-2.12 5.154-1.41 1.62-2.8 4.06-3.1 5.41s-0.98 3.64-1.53 5.09c-0.55 1.46-0.69 3.19-0.28 3.85 0.42 0.68 0.33 0.96-0.22 0.62-0.53-0.32-2.24 1.92-3.78 5-1.55 3.08-3.03 5.82-3.35 6.1-0.31 0.27-1.8 2.93-3.28 5.9-3.21 6.47-11.09 13.68-19.56 17.91-3.26 1.63-6.18 3.59-6.47 4.34-0.3 0.79-1.91 1.35-3.84 1.35-1.84-0.01-3.35 0.45-3.35 1 0.01 1.39-7.2 1.23-8.62-0.19-0.65-0.65-1.22-2.02-1.22-3.07 0-2.35 5.43-13.25 7.97-16 2.56-2.77 2.39-4.85-1.06-11.93-1.91-3.91-3.77-6.31-5.19-6.75-1.21-0.38-3.44-1.72-4.97-3s-3.19-2.35-3.69-2.35-1.82-0.88-2.9-1.97c-1.48-1.47-1.86-2.88-1.53-5.53 0.81-6.52-2.44-8.801-8.29-5.78-2.87 1.49-3.02 2.16-1.59 8.38 0.23 0.98-4.12 5.87-5.22 5.87-1.75 0-7.89 4.33-7.9 5.56-0.01 0.62-0.72 1.41-1.53 1.72-0.82 0.32-1.47 1.36-1.47 2.38 0 1.01-0.68 3.28-1.53 5-2.6 5.2 0.43 16.84 4.37 16.84 0.98 0 2.34 1.05 3.03 2.35 1.04 1.94 1.01 3.1-0.16 6.59-0.77 2.33-1.7 3.77-2.06 3.19s-2.44-1.37-4.65-1.72c-2.45-0.39-6.08-2.16-9.22-4.53-2.85-2.15-5.71-3.91-6.35-3.91-0.63 0-1.93-0.43-2.87-0.94-0.94-0.5-2.38-1.15-3.19-1.47-0.81-0.31-2.64-1.34-4.06-2.28s-3.98-2.61-5.69-3.68c-1.72-1.08-3.32-3.08-3.59-4.44s-0.92-3.81-1.44-5.47-0.96-3.63-0.97-4.41c-0.01-2.37-11.79-24.93-13.87-26.56-1.49-1.16-1.82-2.173-1.32-4.186 0.37-1.463 1.12-2.903 1.63-3.219s34.73-0.812 76.09-1.063c17.66-0.106 31.37-0.181 41.94-0.187zm-156.12 0.094c0.07-0.001 0.15 0.03 0.18 0.062 0.29 0.287-0.4 1.436-1.53 2.563-1.74 1.746-6 2.924-6 1.656 0-0.752 6.15-4.271 7.35-4.281zm193.59 0c0.72 0.037 1.48 0.418 2.19 1.125 2 2.008 1.92 2.23-1.63 4-3.92 1.955-3.66 2.031-3.56-1.406 0.07-2.372 1.42-3.801 3-3.719zm-184.28 0.25c0.71-0.117 1.03 0.479 1.03 1.812 0 2.856-2.38 6.289-3.31 4.781-0.97-1.571 0.31-5.875 1.93-6.5 0.12-0.045 0.25-0.077 0.35-0.093zm21.72 1c0.98-0.125 2.93 1.434 2.93 2.562 0 0.475-0.88 0.875-1.96 0.875-1.9 0-2.66-1.903-1.32-3.25 0.1-0.093 0.21-0.169 0.35-0.187zm-27.07 1.469c0.82 0 1.47 0.253 1.47 0.562s-0.65 1.22-1.47 2.031c-1.31 1.312-1.46 1.249-1.46-0.562-0.01-1.156 0.63-2.031 1.46-2.031zm26.57 6.002 2.43 0.56c3.38 0.79 6.72 4.75 8 9.56 1.03 3.85 2.84 8.29 6.88 16.75 2.28 4.77 2.44 7.89 0.37 7.1-0.9-0.35-1.47-0.01-1.47 0.87 0 0.8 0.43 1.44 0.94 1.44s1.65 1.23 2.53 2.72c0.89 1.49 3.35 3.94 5.47 5.47 3.98 2.85 5.07 5.59 2.25 5.59-1.21 0-1.32 0.29-0.5 1.28 0.6 0.72 0.91 3.49 0.72 6.16-0.19 2.66 0.08 5.68 0.59 6.65 2.14 4.08-0.02 3-5.31-2.59-3.1-3.28-5.91-5.68-6.22-5.38-0.3 0.31 0.98 2.25 2.88 4.32s3.25 3.97 2.97 4.25c-0.87 0.87-7.26-7.23-6.78-8.6 0.25-0.71-1.09-2.94-2.97-4.93-1.89-1.99-3.4-4.11-3.41-4.72 0-0.61-0.66-1.63-1.4-2.25-1.68-1.39-2.38-4.56-4.07-17.78-1.23-9.65-2.05-14.21-3.87-20.97-0.71-2.64-0.65-2.72 2.06-2.06l2.81 0.65-2.47-2.03-2.43-2.06zm79.87 1.87c2.07 0.04 3.43 1.87 2.81 3.81-0.76 2.41-3.29 2.77-4.12 0.6-0.65-1.68 0.16-4.43 1.31-4.41zm0.06 9.81c0.74-0.03 2.31 0.58 4.25 1.72 3.04 1.8 3.83 4.19 1.38 4.19-0.81 0-1.47 0.52-1.47 1.13 0 0.66-1.05 0.87-2.66 0.56-1.46-0.28-3.61-0.14-4.81 0.31-1.97 0.75-2.17 0.55-2.03-2.22 0.09-1.68 0.7-3.24 1.38-3.47 0.76-0.25 1.04 0.19 0.68 1.13-0.49 1.28-0.23 1.34 1.88 0.34 1.83-0.86 2.2-1.51 1.44-2.43-0.67-0.81-0.61-1.22-0.04-1.26zm0.69 4.41c-0.69 0-1.44 0.45-1.44 1.09 0 0.24 0.69 0.41 1.53 0.41 0.85 0 1.25-0.45 0.91-1-0.21-0.34-0.58-0.5-1-0.5zm-12.34 2.31c0.7-0.11 1.55 0.87 3.43 3.6 2.15 3.1 3.74 4.46 5.35 4.47 1.39 0 2.12 0.47 1.87 1.21-0.24 0.74-2.14 1.22-4.75 1.22-3.21 0-4.54 0.45-5.06 1.72-0.77 1.89-3.23 2.31-4.22 0.72-0.34-0.55-0.35-2.33 0-3.94 0.51-2.3 1.2-2.9 3.16-2.9h2.47l-2.28-1.85c-1.98-1.59-2.09-2.11-0.94-3.5 0.37-0.44 0.65-0.7 0.97-0.75zm20.22 1.32c0.88-0.05 2.05 0.28 4.15 0.93 5.03 1.57 6.83 3.85 3.03 3.85-1.29 0-2.85 0.43-3.5 0.97-0.85 0.71-0.93 0.67-0.21-0.19 1.54-1.86 1.14-3.47-1-4.03-1.99-0.52-2.37 0.14-2 3.59 0.1 1.02-0.38 2.26-1.1 2.72-2.42 1.53-5.75 0.51-5.75-1.78 0-1.01-0.62-1.34-1.91-1-1.05 0.28-2.71-0.18-3.68-0.97-1.64-1.33-1.57-1.39 0.87-0.87 1.46 0.3 2.9 0.17 3.22-0.35s1.25-0.72 2.06-0.41c0.82 0.32 2.37-0.21 3.44-1.18 0.9-0.81 1.49-1.24 2.38-1.28zm6.31 7.72c0.84-0.09 2.04 0.45 2.4 1.4 0.31 0.8 1.35 1.18 2.41 0.91 1.02-0.27 2.39 0.21 3.09 1.06 1.18 1.41 0.18 2.3-1.12 1-0.31-0.31-1.18-0.73-1.91-0.91-3.68-0.88-5.75-1.81-5.75-2.59 0-0.53 0.37-0.82 0.88-0.87zm-33.56 1.71c0.68 0.03 1.42 0.79 2.12 2.25 0.78 1.61 1.78 2.91 2.22 2.91s0.78 0.69 0.78 1.5c0 0.82-0.87 1.47-1.97 1.47-1.15 0-1.93-0.66-1.93-1.6 0-1.12-0.61-1.44-2.07-1.06-1.81 0.48-1.98 0.22-1.4-2.09 0.57-2.27 1.37-3.41 2.25-3.38zm20.18 0.85c1.95-0.19 4.45 1.08 6.32 3.34 0.85 1.03 1.19 1.11 1.22 0.25 0.04-1.8 2.46-1.48 4.31 0.56 2.71 3 1.2 14.29-2.66 19.72-3.39 4.78-6.39 6.33-10.19 5.38-1.63-0.41-2.31-0.25-1.9 0.4 0.34 0.56 1.85 1.22 3.34 1.47 1.5 0.26 3.59 0.84 4.63 1.28 1.33 0.57 1.66 0.44 1.15-0.37-0.39-0.63-0.26-1.16 0.32-1.16 0.57 0 1.03 0.71 1.03 1.53 0 0.83 1.11 1.98 2.47 2.6 2.36 1.07 3.35 2.78 1.62 2.78-0.46 0-2.54 1.69-4.66 3.75-4.47 4.35-7.36 4.44-10.96 0.34-3.59-4.06-5.19-8.73-5.19-15.31 0-3.98-0.52-6.85-1.57-8.34-0.91-1.32-1.64-4.35-1.68-7.22-0.07-4.25 0.34-5.29 2.65-7.28 1.49-1.28 3.57-2.35 4.66-2.35s2.84-0.44 3.87-1c0.38-0.2 0.78-0.33 1.22-0.37zm15.44 2.34c0.54 0 1 0.46 1 1s-0.46 0.97-1 0.97-0.97-0.43-0.97-0.97 0.43-1 0.97-1zm-6.28 2.97c-3.67 0-6.17 3.28-5.22 6.91 0.4 1.5-0.18 2.84-1.97 4.5l-2.53 2.37h3.1c2.87 0 3.06-0.27 3.06-3.44 0-3.38 2.34-5.8 5-5.18 0.62 0.14 1.26-0.98 1.44-2.47 0.29-2.47 0.04-2.69-2.88-2.69zm-14.59 0.16c-2.06 0.1-2.6 1.32-2.07 4.03 0.47 2.38 1 2.68 4.25 2.68 2.98 0 3.84-0.43 4.29-2.15 0.76-2.92 0.17-3.55-3.88-4.31-1.04-0.2-1.91-0.29-2.59-0.25zm-16.13 1.15c0.32-0.06 1 0.41 1.6 1.13 0.77 0.93 0.83 1.5 0.18 1.5-1.19 0-2.55-1.88-1.87-2.57 0.03-0.03 0.05-0.05 0.09-0.06zm70.13 11.56c0.29 0.01 0.31 2.27 0 5.32-0.33 3.24-0.93 11.34-1.29 17.97-0.35 6.62-1 12.03-1.46 12.03-0.47 0-0.76 3-0.66 6.65l0.16 6.63 0.37-5.66c0.2-3.11 0.8-5.65 1.31-5.65 0.52 0 0.91-1.98 0.91-4.41 0-2.6 0.45-4.44 1.09-4.44 0.69 0 0.9 1.04 0.54 2.72-0.32 1.49-0.89 10.2-1.26 19.41-0.57 14.49-0.43 17.19 0.97 19.9 2.01 3.89 2.03 5.19 0.13 5.19-0.81 0-1.48-0.11-1.5-0.25-0.02-0.13-0.31-2.03-0.63-4.19-0.31-2.16-1.15-4.8-1.9-5.87-1.22-1.74-1.36-1.27-1.35 4.44 0.02 7.38 0.74 10.76 2.32 10.81 0.61 0.02 1.89 0.66 2.87 1.4 0.98 0.75 1.44 1.53 1 1.76-1.59 0.8-5.2-1.72-6.31-4.41-1.62-3.92-1.8-16.21-0.25-18.25 1.77-2.34 1.63-10.14-0.28-13.97-1.59-3.19-1.59-9.11 0.06-30.5 0.32-4.22 3.74-15.32 5.09-16.59 0.03-0.02 0.05-0.04 0.07-0.04zm-95.53 0.63c0.07-0.01 0.14 0 0.21 0 0.35 0.02 0.64 0.25 0.72 0.75 0.09 0.54-0.03 0.59-0.28 0.12-0.24-0.46-0.86-0.23-1.37 0.5-0.64 0.91-0.84 0.96-0.63 0.13 0.22-0.84 0.81-1.4 1.35-1.5zm51.06 1.47c-2.16-0.07-5.38 1.09-5.38 2.34 0 1.67 1.18 1.8 2.66 0.32 0.77-0.78 1.27-0.78 1.75 0 0.37 0.59-0.05 1.06-0.91 1.06-1.83 0-2.05 1.61-0.31 2.31 2.27 0.92 2.75 0.66 3.75-1.97 0.62-1.63 0.67-2.96 0.09-3.53-0.33-0.33-0.93-0.51-1.65-0.53zm-44.75 1.37c0.47-0.02 1.13 0.03 2 0.16 2.78 0.41 4.78 2 8.43 6.63 1.44 1.82 1.53 1.81 0.97 0.09-0.5-1.58-0.37-1.65 0.91-0.59 0.83 0.68 2.92 1.52 4.62 1.87 3.62 0.74 4.24 2.76 2.16 6.94-0.92 1.84-1.96 2.69-2.87 2.34-0.79-0.3-1.44 0.03-1.44 0.72s-0.27 0.95-0.59 0.63c-0.33-0.33 0.13-2.02 1-3.76 1.96-3.93 2-3.66-0.91-3.5-2.26 0.14-2.44 0.56-2.44 4.85 0 2.57-0.46 4.65-1 4.65-1.08 0-1.22-0.51-1.09-3.43 0.05-1.08-0.18-1.46-0.47-0.81-0.29 0.64-1.16 0.95-1.94 0.65-0.9-0.35-1.42 0.11-1.47 1.28-0.04 1.09-0.61 0.43-1.4-1.62-1.62-4.21-1.81-6.22-0.5-5.41 1.55 0.96 1.16-1.12-0.47-2.47-0.91-0.75-1.23-2.08-0.88-3.5 0.42-1.65-0.04-2.63-1.53-3.56-2.16-1.35-2.51-2.09-1.09-2.16zm-3.91 0.38c0.53 0 1.24 1.23 1.6 2.72 0.35 1.49 0.95 3.14 1.31 3.69 0.36 0.54 0.57 3.47 0.5 6.56-0.07 3.08 0.27 5.4 0.72 5.12 0.44-0.27 0.82-1.7 0.87-3.15l0.1-2.63 0.84 2.75c1.77 5.9 2.78 23.44 2.16 37.56-0.66 14.76-0.66 14.77-1.32 6.41-0.36-4.6-0.73-13.78-0.78-20.41-0.06-7.31-0.5-12.06-1.09-12.06-0.97 0-1.15 4.45-1.47 33.44-0.16 14.42-0.84 19.25-3.19 21.91-0.83 0.94-1.81 1.71-2.15 1.71-1.02 0-3.01-2.24-2.97-3.37 0.04-1.33 4.87-4.92 4.87-3.63 0 0.54-0.43 1.26-0.97 1.6-1.19 0.73-1.31 3.43-0.15 3.43 1.19 0.01 3.19-6.7 3.37-11.31 0.5-12.61-0.38-43.78-1.25-43.78-0.62 0-1.06 7.9-1.16 21.41l-0.15 21.37-0.69-13.75c-0.38-7.57-1.03-21.1-1.44-30.03-0.4-8.93-0.93-16.55-1.18-16.97s-0.14-2.19 0.25-3.94c0.61-2.77 0.82-2.94 1.5-1.21 0.67 1.71 0.78 1.63 0.84-0.72 0.04-1.49 0.5-2.72 1.03-2.72zm85.97 0c0.91 0 0.46 11.8-0.47 12.37-0.48 0.3-0.9 1.8-0.9 3.35-0.01 1.54-0.45 2.96-1.04 3.15-0.58 0.2-1.41 2.79-1.84 5.75s-0.87 4.13-0.94 2.57c-0.06-1.57-0.73-3.34-1.5-3.94-1.06-0.83-1.22-2.23-0.65-5.81 0.77-4.88-0.26-7.31-1.47-3.47-0.38 1.2-1.34 2.83-2.13 3.62-1.23 1.23-1.55 1.23-2.34 0.03-0.51-0.76-0.76-2.6-0.56-4.09 0.22-1.71-0.12-2.72-0.91-2.72-2.51 0-2.41-1.99 0.16-2.97 1.78-0.68 3.03-0.67 3.84 0 0.87 0.72 1.51 0.32 2.31-1.43 0.73-1.59 1.65-2.23 2.63-1.85 0.96 0.37 1.5 0.02 1.5-0.97 0-1.33 2.7-3.59 4.31-3.59zm-53.78 1.41c0.14-0.1 0.05 0.88-0.22 3.03-0.27 2.16-0.52 5.15-0.5 6.65 0.03 2.86-4.01 7.6-6.5 7.6-0.73 0-1.34 0.48-1.34 1.03 0 0.56 1 0.7 2.31 0.37 3.23-0.81 3.97 1.73 1.84 6.25-0.94 2-2.49 3.79-3.44 3.97-1.49 0.29-1.71-0.5-1.71-5.9 0-5.04 0.48-6.96 2.47-9.88 1.35-1.99 2.43-3.92 2.43-4.31s0.64-1.4 1.38-2.25c0.74-0.86 1.83-2.91 2.43-4.53 0.47-1.26 0.74-1.96 0.85-2.03zm79.94 2.81c0.02 0 0.03 0.04 0.03 0.06 0 0.19-0.89 1.15-1.97 2.13-1.08 0.97-1.97 1.36-1.97 0.87s0.89-1.48 1.97-2.16c0.95-0.59 1.75-0.95 1.94-0.9zm-17.79 4.25c0.39 0.06 0.54 2.48 0.35 5.62-0.54 9.12-1 9.91-1.13 1.97-0.06-3.89 0.25-7.29 0.69-7.56 0.03-0.02 0.07-0.04 0.09-0.03zm-39.84 0.68c0.27-0.07 0.66 0.43 0.94 1.16 0.66 1.73 0.09 2.01-0.88 0.44-0.35-0.58-0.44-1.27-0.18-1.53 0.03-0.03 0.08-0.05 0.12-0.07zm26.69 1.35c-0.2 0.17-0.48 2.01-0.81 5.5-0.25 2.57-0.07 4.65 0.4 4.65 0.48 0 0.86-2.54 0.82-5.65-0.05-3.17-0.21-4.67-0.41-4.5zm-17.09 0.41c0.91-0.12 2.34 0.66 4.09 2.28 1.95 1.8 2.45 3 2.06 5.12-0.28 1.53-1.04 3.12-1.69 3.53-2.58 1.65-3.62 0.74-3.62-3.15 0-2.17-0.46-3.94-1-3.94s-0.97-0.89-0.97-1.97c0-1.16 0.41-1.79 1.13-1.87zm40.87 0.5c0.17-0.04 0.28-0.02 0.28 0.09 0 1.44-5.46 7.26-6.15 6.56-1.23-1.22-0.79-2.05 2.71-4.72 1.42-1.08 2.64-1.82 3.16-1.93zm84.53 2.37c0.85 0 11.19 10.66 11.19 11.53 0 0.26 0.94 1.79 2.09 3.41 1.15 1.61 2.49 4.51 3 6.5 1.24 4.84 1.89 32.64 0.82 35.12-0.83 1.92-0.84 1.93-0.91 0.07-0.09-2.52-1.61-0.9-2.44 2.62-0.63 2.67 0.73 3.88 1.69 1.5 0.27-0.68 0.55-0.28 0.59 0.91 0.08 2.28-5.06 6.95-8.4 7.62-1.01 0.2-3.08 0.83-4.57 1.41-1.69 0.65-2.72 0.69-2.72 0.09 0-0.53-0.45-0.94-1.03-0.94-0.57 0-0.77 0.43-0.43 0.97 0.33 0.54-0.55 1.43-1.97 1.97-3.56 1.35-4.45 1.23-3.78-0.5 0.46-1.21-0.49-1.47-5.25-1.47-6.02 0-8.19-1.08-8.19-4.12 0-0.98-0.43-1.78-0.97-1.78s-1-0.37-1-0.85c0-0.47 1.97-1.36 4.38-1.97 5.31-1.34 6.43-1.37 4.5-0.12-2.09 1.35 2.93 1.32 6.5-0.03 1.97-0.75 2.86-0.71 3.4 0.15 0.54 0.88 1.16 0.75 2.38-0.46 2.08-2.09 3.36-2.06 5.09 0.09 1.24 1.55 1.35 1.4 0.81-1.38-0.36-1.86 0.02-4.55 0.94-6.75 0.84-2 1.32-3.96 1.06-4.37-0.25-0.41 0.41-1.58 1.5-2.56 1.09-0.99 1.75-2.37 1.47-3.1-0.49-1.29-0.19-2.17 2.35-7.03 0.74-1.42 0.8-2.06 0.15-1.66-1.29 0.8-1.35-0.4-0.12-2.34 0.49-0.78 0.58-1.9 0.21-2.47-1.16-1.79-0.79-5.47 0.54-5.47 2.44 0 1.26-2.73-1.72-3.96-1.65-0.69-3.68-2.55-4.5-4.13-1.16-2.24-2.07-2.8-4.06-2.56-1.42 0.17-2.74-0.23-2.97-0.91s0.27-1.25 1.09-1.25 1.8-0.5 2.19-1.12c0.48-0.78-0.12-0.98-1.94-0.63-2.61 0.5-2.61 0.49-1-1.97 1.49-2.27 1.49-2.43 0.03-1.87-2.1 0.8-2.04-0.26 0.1-1.82 1.42-1.04 1.45-1.47 0.34-2.81-0.72-0.87-0.9-1.56-0.44-1.56zm-138.5 0.25c-0.6 0.09-1.26 0.62-1.56 1.53-0.22 0.64 0.3 1.16 1.16 1.16 0.85 0 1.53-0.71 1.53-1.57s-0.52-1.21-1.13-1.12zm-61.5 2.12c0.44 0.02 1.52 0.85 2.63 2.04 1.26 1.35 1.89 2.46 1.34 2.46-1.26 0-4.75-3.78-4.09-4.43 0.03-0.04 0.06-0.07 0.12-0.07zm71.06 0.13c0.3-0.02 0.54 0 0.69 0.09 1.52 0.92 0.64 1.98-3.03 3.6-4.61 2.03-6.18 2.09-5.47 0.25 0.51-1.34 5.72-3.82 7.81-3.94zm-27.12 1.44c0.53 0 1.74 1.2 2.69 2.69 0.94 1.48 2 2.94 2.34 3.21s1.14 1.47 1.78 2.69 1.93 2.22 2.91 2.22c0.97 0 2.27 1.09 2.87 2.41 0.97 2.13 0.81 2.48-1.4 3.21l-2.47 0.85 2.06 1.84c1.81 1.64 2.03 1.63 2.03 0.19 0-1.89 1.51-2.14 2.56-0.44 0.4 0.65 0.18 1.35-0.47 1.56-0.64 0.22-1.76 1.02-2.53 1.79-0.76 0.76-1.6 1.06-1.84 0.65s-2.35-4.29-4.66-8.62c-2.3-4.33-4.76-8.59-5.5-9.44-1.54-1.8-1.78-4.81-0.37-4.81zm-13.44 1.72c1.22-0.17 1.64 2.13 1.1 6.71-0.48 3.99-0.28 5.36 1.09 6.72 1.64 1.64 2.82 1.65 6.59 0.1 1.26-0.52 1.99 0.01 2.91 2.03 0.98 2.16 1 2.8 0.03 3.12-0.67 0.23-1.22 1.25-1.22 2.25 0 1.01-0.46 2.08-1 2.41-1.24 0.77-1.28 2.47-0.06 2.47 0.96 0 2.59-3.83 2.22-5.22-0.12-0.45 0.22-0.53 0.78-0.19 1.25 0.78 1.34 3.72 0.12 4.97-0.5 0.52-1.22 2.71-1.62 4.88-0.62 3.34-0.54 3.73 0.66 2.75 1.18-0.98 1.37-0.54 1.06 2.71-0.68 7.14 1.41 3.97 2.62-3.96 1.35-8.83 0.44-14.51-2.9-17.85-2.1-2.09-1.86-3.25 1-4.78 1.52-0.82 2.18-0.26 4.22 3.69 11.7 22.64 14.52 28.48 14.53 29.97 0 0.94 0.45 1.72 0.97 1.72 0.51 0 1.2 1.53 1.56 3.43 0.35 1.9 1.05 3.71 1.53 4 0.48 0.3 0.87 1.65 0.87 2.97s0.35 2.38 0.78 2.38c0.44 0 1.64 1.89 2.63 4.19 0.99 2.29 2.51 4.9 3.37 5.78 0.87 0.88 2.34 2.48 3.22 3.56 0.89 1.08 2.2 2.21 2.94 2.47s1.11 0.73 0.81 1.06c-0.71 0.79-8.84-3.2-8.84-4.34 0-0.49-0.83-1.74-1.84-2.75-2.07-2.07-7.05-12.31-8.91-18.32-0.67-2.16-2.07-5.8-3.12-8.06-1.06-2.26-2.17-5.34-2.44-6.87-0.28-1.53-0.9-2.93-1.38-3.1-0.47-0.17-1.63-2.6-2.56-5.4s-2.4-6.28-3.28-7.72c-1.53-2.52-1.59-2.11-1.56 9.03 0.01 6.39 0.12 11.5 0.25 11.37s0.88-1.94 1.62-4.06l1.35-3.87 1.03 8.34 1.06 8.38-0.25-6.66c-0.23-6.94 0.32-8.13 2.03-4.41 3.87 8.46 6.32 14.62 7.28 18.44 0.61 2.43 1.4 4.64 1.75 4.91s1.41 2.15 2.34 4.18c1.59 3.43 1.6 3.69 0.07 3.69-1.43 0-1.41 0.21 0.25 1.53 1.66 1.33 1.47 1.3-1.35-0.06-1.77-0.86-2.99-1.91-2.71-2.34 0.6-0.98-2.94-10.89-4.41-12.35-0.77-0.75-0.79-0.28-0.06 1.66 0.56 1.48 0.77 3.35 0.47 4.15-0.31 0.81 0.13 2.14 1 3 0.86 0.87 1.56 2.05 1.56 2.6 0 1.86-2.44 0.2-3.78-2.56-1.12-2.29-1.1-2.89 0-3.57 0.72-0.44 0.95-1.14 0.53-1.56s-1.18-0.12-1.66 0.66c-0.71 1.14-1.34 0.86-3.37-1.5-3.17-3.68-3.33-1.96-0.19 1.97 1.9 2.38 2.07 3.11 1.03 4.15-1.8 1.8-2.72 1.6-5.72-1.19-1.45-1.34-2.96-2.34-3.34-2.24-1.77 0.44-6.99-1.44-7.47-2.69-0.3-0.77-1.16-1.18-1.94-0.88-0.8 0.31-2.07-0.43-2.97-1.72-1.54-2.2-1.59-2.21-1.59-0.18 0 3.1-3.63 3.69-5.47 0.87-1.13-1.72-1.35-3.89-0.91-9.03 0.94-10.76 3.56-26.32 4.66-27.69 0.56-0.69 0.69-1.56 0.31-1.94-0.37-0.37-1.09-0.01-1.59 0.79-0.64 1-0.9-0.1-0.91-3.6-0.01-3.3 0.48-5.48 1.44-6.28 0.81-0.67 1.47-1.68 1.47-2.22 0-0.55-0.65-0.43-1.47 0.25-2.18 1.82-1.76-0.3 0.66-3.37 0.87-1.12 1.57-1.71 2.12-1.78zm-63.56 1.53c0.75-0.02 1.65 0.08 2.69 0.25 8.14 1.34 10.2 4.34 3 4.34-2.44 0-4.41-0.43-4.41-0.97s-0.43-0.97-0.94-0.97-1.05 1.66-1.22 3.69l-0.31 3.69-1.31-3.72c-1.5-4.23-0.78-6.22 2.5-6.31zm69.16 0.68c-0.55 0-1 0.43-1 0.97s0.45 1 1 1c0.54 0 0.96-0.46 0.96-1s-0.42-0.97-0.96-0.97zm34.9 0.13c1.23-0.03 1.47 0.62 1.47 1.91 0 1.78 0.39 2 2.72 1.37 5.37-1.46 9.09-1.26 9.09 0.47 0 2.01 3.8 12.94 5 14.41 0.92 1.11 3.13 31.96 2.35 32.75-0.25 0.24-0.47-0.64-0.47-1.97 0-1.34-0.49-2.96-1.1-3.57-1.52-1.52-2.77-9.01-1.62-9.71 0.51-0.32 0.64-1.3 0.28-2.19s-0.86-2.51-1.09-3.6c-1.78-8.18-2.18-8.73-1.82-2.46 0.98 16.78 2.11 26.18 3.53 28.84 0.53 0.97 0.83 2.95 0.66 4.41-0.24 2.11-0.49 2.36-1.25 1.18-0.91-1.4-1.52-4.7-3.37-18.34-0.45-3.31-1.18-6.59-1.63-7.31-0.44-0.72-0.91-3.65-1.06-6.53-0.51-9.51-2-9.04-2.63 0.84-0.55 8.75-2.14 14.61-4 14.63-0.47 0-0.54-1.01-0.15-2.22 1.44-4.56 1.64-7.42 0.59-8.07-0.65-0.4-1.06 0.15-1.06 1.41 0 1.3-0.43 1.84-1.13 1.41-1.12-0.7-0.79-6.02 1.07-18.13 0.45-2.97 0.51-5.76 0.12-6.19-0.39-0.42-0.78-0.19-0.87 0.5-0.8 6.08-1.4 9.38-1.88 10.63-0.31 0.81-0.46 2.45-0.34 3.66 0.35 3.61-0.9 4.5-2.97 2.12-1.19-1.37-1.81-3.48-1.72-5.72 0.12-2.97 0.19-3.08 0.53-0.81 0.74 4.89 2.39 2.88 2.09-2.56-0.21-3.97-0.65-5.23-1.78-5.16-0.82 0.05-1.78 0.75-2.15 1.56-0.49 1.07-0.67 0.88-0.72-0.72-0.04-1.21-0.58-2.21-1.16-2.21-0.57 0-0.75-0.46-0.43-0.97 0.31-0.52 1.33-0.66 2.21-0.32 1.18 0.46 1.43 0.22 1-0.9-0.32-0.85 0.08-2.45 0.88-3.6 0.8-1.14 1.04-2.09 0.53-2.09s-1.64 1.12-2.53 2.47-2.26 2.44-3.06 2.44c-2.02 0-1.83-0.98 0.75-3.72l2.22-2.31-2.97 0.65c-1.63 0.39-3.17 0.73-3.44 0.72-3.99-0.08-3.88-1.4 0.25-3.13 6.27-2.61 9.48-3.83 11.06-3.87zm43.56 1.84c1.12 0 0.52 20.14-0.81 27.53-0.63 3.52-1.63 6.72-2.25 7.13-0.82 0.54-0.78 0.97 0.19 1.59 1.36 0.88 0.99 5.24-0.81 9.47-0.46 1.08-1.08 2.74-1.38 3.69s-0.94 1.72-1.4 1.72c-1.19 0-0.15-6.23 1.18-7.1 0.71-0.46 0.23-1.28-1.31-2.37l-2.34-1.69 2.12-0.75c2.06-0.76 2.12-1.32 2.19-17.31 0.04-9.08 0.44-17.39 0.9-18.47 0.73-1.68 0.85-1.72 0.91-0.25 0.11 2.71 2.03 2 2.03-0.75 0-1.35 0.37-2.44 0.78-2.44zm-173.81 1.94c3.47 0 4.21 1.23 3.41 5.5-0.68 3.63-2.5 4.65-2.5 1.41 0-2.98-5.95-3.12-9.22-0.22-1.85 1.64-1.86 1.59-0.78-0.47 1.72-3.28 6.03-6.22 9.09-6.22zm202.03 1.97c2.18 0 1.85 1.73-0.47 2.47-1.08 0.34-1.97 1.21-1.97 1.94 0 0.72-1.31 1.77-2.93 2.34-1.63 0.57-2.97 1.49-2.97 2.06s-0.77 1.02-1.72 1c-1.36-0.03-1.14-0.5 1-2.25 1.49-1.22 2.69-2.72 2.69-3.31 0-1.35 4.35-4.25 6.37-4.25zm-186.37 1.09c1.17-0.09 1.97 0.15 1.97 0.88 0 0.54-0.89 1-1.97 1-3.75 0-1.96 1.87 2.43 2.53 4.68 0.7 5.16 2.36 0.69 2.38-1.45 0-4.63 0.65-7.06 1.4-2.43 0.76-5.32 1.66-6.41 2.03-1.66 0.58-1.58 0.41 0.41-1.22 1.63-1.33 1.97-2.12 1.16-2.62-0.89-0.55-0.89-1.06-0.03-2.09 1.79-2.17 6.22-4.08 8.81-4.29zm156.4 0.88c-0.54 0-1 0.92-1 2.03s0.46 1.77 1 1.44c0.54-0.34 0.97-1.25 0.97-2.03s-0.43-1.44-0.97-1.44zm19.32 0c0.81 0 1.17 0.46 0.84 1s-1.28 0.97-2.09 0.97c-0.82 0-1.18-0.43-0.85-0.97 0.34-0.54 1.28-1 2.1-1zm17.47 0.09c0.66 0 1.24 0.19 1.68 0.63 0.46 0.45-0.36 0.91-1.81 1.03-3.21 0.26-5.51 2.16-2.66 2.19 1.57 0.01 1.65 0.22 0.47 0.97-2.14 1.35-0.54 2.33 1.78 1.09 2.5-1.34 5.37-1.4 4.57-0.09-0.34 0.54-1.68 1-3 1s-2.41 0.42-2.41 0.96 0.54 1 1.22 1c0.82 0.01 0.76 0.34-0.22 0.97-2.77 1.79-6.91 0.16-6.91-2.75 0-3.25 4.39-6.98 7.29-7zm-180 2.22c0.35-0.06 0.56 0.17 0.56 0.6 0 0.57-0.43 1.03-0.97 1.03s-0.97-0.17-0.97-0.41 0.43-0.73 0.97-1.06c0.13-0.09 0.29-0.14 0.41-0.16zm-33.85 0.66c0.54 0 0.97 0.43 0.97 0.97s-0.43 1-0.97 1-1-0.46-1-1 0.46-0.97 1-0.97zm263.72 0c2.69 0 2.78 1.14 0.5 6.37-0.71 1.63-1.91 4.38-2.66 6.13-1.27 3-3.54 4.86-4.62 3.78-0.27-0.27 0.08-1.19 0.78-2.03s1.05-1.77 0.75-2.07c-0.3-0.29-1.96 1.52-3.69 4.04-4.26 6.19-13.5 15.15-16.37 15.87-1.29 0.32-2.97 0.33-3.75 0.03s-1.61-0.02-1.88 0.63c-0.37 0.9-0.47 0.91-0.53 0-0.04-0.65 1.53-1.94 3.5-2.88 3.16-1.49 11.86-7.51 14.6-10.06 0.54-0.5 2.08-2.34 3.43-4.06 1.36-1.73 3.36-4.15 4.44-5.41 3.95-4.6 5.41-6.85 5.41-8.31 0-1.8-7.8 5.71-7.85 7.56-0.02 0.68-0.46 1.22-1 1.22s-1 0.5-1 1.13c0 1.83-7.31 8.01-12.97 10.93-6.04 3.12-7.49 3.37-5.59 1.03 1.16-1.42 1.14-1.55-0.13-1.09-5.02 1.84-5.87 1.91-5.31 0.44 0.31-0.82 1.98-1.77 3.69-2.13 1.71-0.35 5.03-1.78 7.38-3.12 2.34-1.35 4.41-2.27 4.62-2.06 0.21 0.2-1.59 1.46-4 2.78-3.72 2.03-5.62 3.9-3.94 3.9 2.04 0 13.32-7.65 13.32-9.03-0.01-0.61-0.71-0.51-1.72 0.28-0.95 0.74 1.73-2.06 5.96-6.25 4.24-4.19 8.13-7.62 8.63-7.62zm-176.53 1.84c0.14-0.11 0.15 1.36 0.22 4.78 0.07 3.38-0.01 6.16-0.22 6.16-0.94 0-1.24-3.89-0.6-7.91 0.31-1.9 0.49-2.94 0.6-3.03zm-84.25 0.13c0.54 0 1 0.2 1 0.43 0 0.24-0.46 0.7-1 1.04-0.54 0.33-0.97 0.13-0.97-0.44 0-0.58 0.43-1.03 0.97-1.03zm268.72 0.53c0.09 0 0.19 0 0.28 0.03 2.94 1.13 2.03 13.28-1.72 23.53-0.79 2.17-1.71 5.8-2.09 8.06-0.75 4.45-1.84 5.06-10.32 5.69-2.09 0.16-4.27 0.57-4.87 0.94s-1.13 0.4-1.13 0.09c0-1.11 2.48-4.98 3.69-5.75 0.68-0.43 1.25-1.43 1.25-2.22 0-0.78 0.37-1.4 0.84-1.4 0.48 0 1.44-1.43 2.1-3.19s1.98-4.76 2.97-6.66c2.01-3.86 4.94-11.5 5.25-13.75 0.34-2.48 2.11-5.08 3.47-5.34 0.09-0.02 0.18-0.04 0.28-0.03zm-344.19 1.53c0.28 0.04 0.677 0.45 1.312 1.31 0.773 1.05 1.376 2.71 1.376 3.69-0.001 0.98-0.447 1.78-0.969 1.78-1.496 0-3.173-3.93-2.469-5.75 0.288-0.74 0.47-1.07 0.75-1.03zm248.59 0.87c-1.1 0-1.3 3.26-0.28 4.28 1.09 1.09 1.28 0.77 1.28-1.81 0-1.35-0.46-2.47-1-2.47zm-161.31 1c0.54 0 0.97 0.17 0.97 0.41s-0.43 0.73-0.97 1.06c-0.54 0.34-1 0.14-1-0.43 0-0.58 0.46-1.04 1-1.04zm134.38 0c-1.58 0-3.77 2.4-2.94 3.22 0.87 0.87 3.11-0.22 3.72-1.81 0.3-0.78-0.04-1.41-0.78-1.41zm-216.47 0.32c0.152 0.02 0.338 0.15 0.562 0.37 1.215 1.22-0.372 7.48-2.562 10.13-0.673 0.81-1.483 2.12-1.782 2.93-0.357 0.97-0.542 1.06-0.594 0.22-0.042-0.7 0.793-3 1.876-5.12 1.082-2.12 1.968-5.08 1.968-6.57 0-1.23 0.126-1.83 0.406-1.93 0.043-0.02 0.075-0.04 0.126-0.03zm288.22 0.12c1.71-0.13 2.4 0.52 2.4 2.06 0 1.69-2.65 1.8-5.37 0.22-1.85-1.07-1.79-1.15 0.9-1.87 0.81-0.22 1.49-0.36 2.07-0.41zm-17.88 0.75c2.02-0.04 3.69 0.16 4.03 0.72 0.35 0.57 1.4 1.03 2.32 1.03 0.91 0 3.62 1.67 6 3.72 3.71 3.2 4.15 4.03 3.24 5.72-0.95 1.78-0.42 5.47 2.54 17.37 0.1 0.41 0.18 1.47 0.18 2.35 0 1.22 0.65 1.46 2.72 1.03 1.49-0.31 4.15-0.85 5.91-1.22 2.57-0.53 3.19-0.38 3.19 0.91 0 0.88-0.49 1.51-1.1 1.37-0.61-0.13-1.3 0.25-1.53 0.88-0.23 0.62 1.54 1.89 3.94 2.81 4.78 1.82 7.8 6.01 5.41 7.53-2.05 1.29-2.8 1-5.72-2.13-1.52-1.62-3.48-2.96-4.35-2.96-2.22 0-1.98 0.87 1.07 3.68l2.68 2.47-3.62 3.31c-3.82 3.5-7.51 4.25-9.78 1.97-0.75-0.74-2.71-2.04-4.38-2.9s-3.31-2.3-3.66-3.19c-0.34-0.91-1.25-1.37-2.06-1.06-0.79 0.3-1.71 0.14-2.03-0.38-0.32-0.51-1.53-0.89-2.72-0.84-1.84 0.07-1.73 0.24 0.85 1.37 3.26 1.44 7.04 5.01 4.09 3.88-1.13-0.43-1.51-0.05-1.41 1.37 0.12 1.54 1.08 2.1 4.38 2.6 4.49 0.67 4.87 2.47 0.53 2.47-1.41 0-2.26 0.33-1.87 0.71 0.38 0.39 2.48 0.57 4.62 0.41 2.3-0.16 3.88 0.16 3.88 0.78 0 0.6-1.93 1.07-4.41 1.07-3.39-0.01-4.63-0.46-5.44-1.97-0.58-1.09-1.47-1.97-2-1.97s-1.7 0.88-2.62 1.97c-1.99 2.32-6.19 2.66-6.19 0.5 0-0.82-0.46-1.5-1-1.5s-0.97 0.42-0.97 0.93 0.43 1.2 0.97 1.54c0.54 0.33 1 1.02 1 1.53 0 1.87-1.68 0.84-2.91-1.79-1.18-2.53-1.31-2.56-2.06-0.71-0.99 2.45-1.19-6.06-0.28-11.57 0.71-4.29 5.18-9.2 9.22-10.09 1.91-0.42 2.87-1.38 3.28-3.25 0.34-1.6 2.14-3.74 4.53-5.41 2.18-1.52 3.94-3.21 3.94-3.75 0-0.53-1.51 0.2-3.38 1.63-2.5 1.91-3.99 2.4-5.65 1.87-6.86-2.17-12.59-9.92-12.57-16.96 0.01-2.55 0.37-5.25 0.85-6 0.66-1.05 4.98-1.79 8.34-1.85zm-78.69 0.41c0.3 0.02 0.51 0.22 0.72 0.56 0.94 1.52 0.19 2.75-1.65 2.75-0.78 0-1.41 0.46-1.41 1s0.66 0.97 1.47 0.97 1.47-0.43 1.47-0.97 0.46-1 1-1 0.97 0.66 0.97 1.47-0.38 1.5-0.88 1.5-1.59 0.22-2.41 0.53c-0.9 0.35-1.9-0.24-2.59-1.53-0.95-1.78-0.77-2.41 1.09-4.03 1.04-0.9 1.72-1.29 2.22-1.25zm-104.87 0.44c2.05 0.05 1.66 0.34-1.75 1.28-2.44 0.66-6.41 2.46-8.84 4-2.44 1.54-4.73 3.31-5.13 3.9-0.52 0.78-0.74 0.78-0.75-0.03-0.05-3.49 10.39-9.31 16.47-9.15zm-98.658 0.28c0.209-0.01 0.492 0.18 0.907 0.53 0.753 0.62 1.597 2.03 1.875 3.09 0.278 1.07 0.153 2.13-0.25 2.38-1.246 0.77-3-1.68-3-4.19 0-1.2 0.121-1.8 0.468-1.81zm115.53 0.62c0.58 0 1.07 0.46 1.07 1s-0.2 0.97-0.44 0.97-0.7-0.43-1.03-0.97c-0.34-0.54-0.17-1 0.4-1zm99.82 0.19c-0.21 0.07-0.32 0.6-0.28 1.37 0.04 1.15 0.24 1.38 0.56 0.6 0.28-0.71 0.26-1.55-0.06-1.88-0.09-0.08-0.16-0.12-0.22-0.09zm-219.13 0.09c0.256-0.12 0.328 0.46 0.344 1.88 0.03 2.64 1.638 4.85 4.75 6.59 2.331 1.31 1.163 1.88-1.406 0.69-3.151-1.46-5.619-6.09-4.375-8.22 0.325-0.56 0.534-0.86 0.687-0.94zm178.59 0.38c-0.92 0.08-0.93 0.56-0.56 1.75 0.35 1.11 1.03 2.19 1.5 2.37s0.85 1.36 0.85 2.63c0 3.1 2.58 15.47 4.56 21.97 1.1 3.61 1.89 4.89 2.59 4.18 0.7-0.7 0.56-2.33-0.53-5.25-0.86-2.32-1.85-5.99-2.15-8.15-0.46-3.18 0.05-2.43 2.65 3.94 1.77 4.32 3.59 8.48 4.06 9.21 0.56 0.86 0.37 1.64-0.5 2.19-0.74 0.47-0.88 0.88-0.34 0.88 2.95 0 3.1-1.64 0.69-6.88-2.6-5.64-3.96-10.08-4.82-15.47-0.27-1.75-0.88-2.97-1.34-2.69-1.1 0.69-2.28-5.75-1.5-8.21 0.52-1.65 0.1-1.97-2.84-2.32-0.79-0.09-1.39-0.14-1.85-0.15-0.17-0.01-0.33-0.01-0.47 0zm-66.21 0.68-2.6 2.26c-2.15 1.85-2.55 2.95-2.31 6.28 0.16 2.21-0.26 4.65-0.91 5.43-0.93 1.13-0.91 1.4 0.16 1.41 1.1 0.01 1.09 0.21-0.06 0.94-1.17 0.74-1.19 1.15-0.13 2.44 1.42 1.7 5.97 2.13 5.97 0.56 0-0.54-0.54-0.96-1.22-0.97-0.82-0.01-0.73-0.35 0.25-1 1.06-0.7 1.13-1.19 0.32-1.72-0.63-0.41-1.29-2.29-1.47-4.19-0.31-3.12-0.08-3.47 2.37-3.75 3.25-0.37 3.63-2.09 0.5-2.25-1.59-0.08-1.73-0.24-0.53-0.56 0.92-0.24 1.95-1.3 2.28-2.34 1.07-3.39 2.19-2.03 2.88 3.46 0.76 6.09-0.54 9.71-5.38 15.04-1.6 1.75-3.01 3.18-3.15 3.12-0.15-0.05-1.77-0.47-3.6-0.9-7.12-1.69-11.27-7.03-11.37-14.66-0.06-3.82 0.29-4.51 2.93-6 1.65-0.93 5.71-1.92 9.04-2.16l6.03-0.44zm160.75 0.97c0.22-0.04 0.41 0.01 0.53 0.13 0.26 0.26-0.58 2.03-1.88 3.94-2.64 3.88-3.84 4.36-3.84 1.56 0-1.63 3.64-5.35 5.19-5.63zm15.84 0.66c-4.78 0-8.29 3.24-4.56 4.22 2.93 0.76 3.2 0.72 5.68-0.91 2.85-1.86 2.35-3.31-1.12-3.31zm15.53 0.06c0.92-0.04 1.95 0.37 2.28 0.91 0.7 1.13 0.67 1.13-1.97 0-1.6-0.69-1.66-0.85-0.31-0.91zm-180.81 0.1c0.07-0.03 0.17 0.01 0.25 0.09 0.33 0.33 0.35 1.16 0.06 1.88-0.31 0.78-0.55 0.58-0.59-0.57-0.03-0.78 0.08-1.33 0.28-1.4zm135.03 0.18c-0.44-0.09-0.6 0.72-0.56 2.66 0.06 3.19 0.14 3.23 1.15 1.13 0.8-1.67 0.79-2.53-0.06-3.38-0.22-0.22-0.38-0.37-0.53-0.41zm-33.84 1.07c-0.07 0-0.15 0.02-0.22 0.06-0.54 0.33-1 1.71-1 3.06 0 1.39 0.44 2.19 1 1.84 0.54-0.33 0.97-1.7 0.97-3.06 0-1.21-0.3-1.96-0.75-1.9zm-57.1 1.75c0.2-0.08 0.53 0.12 0.97 0.56 0.64 0.64 0.94 1.38 0.66 1.65-0.28 0.28-0.77 0.24-1.13-0.12s-0.69-1.13-0.69-1.69c0-0.23 0.07-0.36 0.19-0.4zm75.13 0.34c0.05-0.11 0.12 0.24 0.18 1.13 0.2 2.82 0.2 7.68 0 10.81-0.19 3.13-0.37 0.82-0.37-5.13 0-4.09 0.08-6.57 0.19-6.81zm-142.5 0.41c-2.56 0-4.63 0.48-4.63 1.06 0 0.61 1.62 0.87 3.94 0.66 5.63-0.53 6.11-1.72 0.69-1.72zm179.15 0c-0.99-0.01-1.81 0.81-1.81 2.46 0 1.98 0.51 2.47 2.5 2.47 1.75 0 2.75 0.75 3.41 2.47 1.07 2.81 2.2 3.1 3.93 1 1.01-1.21 0.77-1.65-1.37-2.47-1.42-0.54-3.07-2.07-3.69-3.43-0.75-1.66-1.97-2.5-2.97-2.5zm-68.21 0.12c0.91 0 1.59 1.25 2.68 4.06 0.89 2.3 2.51 6.43 3.6 9.19l1.96 5.06-2.87-0.12c-3.44-0.12-3.75-1.29-0.69-2.59 2.05-0.88 2.03-0.91-0.62-0.69-3.38 0.28-4.77-2.1-1.69-2.91 2.11-0.55 2.61-1.45 1.44-2.62-0.36-0.37-1.44 0.05-2.38 0.9-2.45 2.22-3.23 0.12-0.93-2.53 2.28-2.63 1.77-3.94-1.54-3.94-2.75 0-2.94-0.52-0.96-2.5 0.81-0.82 1.45-1.31 2-1.31zm-35.94 1.41c-0.44 0.03-0.92 1-1.13 2.4-0.34 2.34-0.16 2.68 0.88 1.82 1.49-1.24 1.72-3.4 0.43-4.19-0.06-0.04-0.12-0.04-0.18-0.03zm164.09 0.65c1.56-0.2-5.23 9.87-10.03 14.32-4.29 3.96-6.47 5.09-6.47 3.4 0-0.42 3.12-3.6 6.91-7.09 3.78-3.49 6.87-6.85 6.87-7.47s0.66-1.7 1.47-2.38c0.59-0.49 1.03-0.75 1.25-0.78zm-237.34 0.13c-0.57-0.1-1.66 0.25-3.1 1.03l-2.78 1.5 2.63 0.06c1.45 0.02 2.98-0.45 3.34-1.03 0.57-0.93 0.48-1.46-0.09-1.56zm170.12 0.06c0.47-0.01 0.57 1.09 0.57 4.03 0 4.1 0.43 5.19 2.71 7.06 3.39 2.77 2.43 3.03-1.06 0.29-3.38-2.67-5.12-8.69-3.09-10.72 0.4-0.41 0.66-0.65 0.87-0.66zm69.13 1.72c0.21-0.04 0.27 0.3 0.28 0.97 0.02 0.88-0.66 2.14-1.47 2.81-1.89 1.57-1.91-0.01-0.03-2.5 0.61-0.8 1-1.24 1.22-1.28zm-173.41 0.34 0.5 9.85c0.3 5.41 0.28 17.13-0.06 26.06s-0.9 24.66-1.25 34.94-1.05 21.54-1.56 25.06c-1.94 13.24-1.9 15.68 0.25 17.19 1.19 0.83 1.73 2.01 1.37 2.93-0.32 0.85-0.17 1.54 0.31 1.54 0.49 0 1.02-1.23 1.19-2.72 0.57-4.97 7.69-3.53 7.69 1.56 0 1.08-0.47 2.11-1.06 2.31-0.6 0.2-1.1 2.04-1.1 4.07 0 2.55-0.55 3.98-1.81 4.65-2.54 1.36-3.02 1.2-3.59-1-0.28-1.06-1.25-2.18-2.16-2.47s-1.73-1.45-1.81-2.59c-0.09-1.14-0.85-2.82-1.69-3.75-2.07-2.28-2.11-28.15-0.06-42.72 0.81-5.78 1.51-14.14 1.56-18.59 0.05-4.46 0.74-14.3 1.5-21.88 0.76-7.57 1.46-18.41 1.56-24.09l0.22-10.35zm-77.28 0.57c0.28-0.06 0.52-0.01 0.72 0.18 0.25 0.25 0.18 1.18-0.16 2.07-0.76 1.99-2.37 2.14-2.37 0.21 0-1.1 0.98-2.28 1.81-2.46zm88.13 0.09c-0.4 0.13-1.09 1.74-2.19 5.16-1.21 3.74-2.19 7.6-2.19 8.59 0 3.04 0.85 2.05 1.97-2.34 0.58-2.3 1.53-5.12 2.09-6.25 0.57-1.14 0.89-3.14 0.69-4.44-0.08-0.54-0.2-0.78-0.37-0.72zm-164.29 0.28c0.065 0.01 0.142 0.09 0.218 0.28 0.273 0.68 0.273 1.79 0 2.47-0.272 0.68-0.499 0.14-0.5-1.22 0-0.84 0.087-1.38 0.219-1.5 0.02-0.01 0.041-0.03 0.063-0.03zm-3 2.38c0.294 0.01 0.781 0.65 1.25 1.65 0.635 1.36 0.734 2.41 0.218 2.41-1.093 0-2.169-2.48-1.687-3.88 0.047-0.13 0.121-0.19 0.219-0.18zm278.29 1.34c-1.22-0.03-4.22 1.72-4.22 2.66 0 1.07 3.78 0.16 4.56-1.1 0.32-0.51 0.34-1.16 0.06-1.43-0.08-0.09-0.23-0.13-0.4-0.13zm-13.66 0.09c0.35-0.06 1 0.58 1.53 1.57 1.29 2.4 0.83 2.69-0.94 0.56-0.68-0.83-1.02-1.76-0.72-2.06 0.04-0.04 0.08-0.06 0.13-0.07zm-258.6 1.07c0.1-0.03 0.206-0.02 0.281 0.06 0.303 0.3 0.016 1.11-0.656 1.78-0.972 0.96-1.096 0.84-0.562-0.56 0.277-0.73 0.637-1.21 0.937-1.28zm291.88 0c0.45-0.1 0.75 0.49 0.75 1.43 0 1.09-0.43 2.26-0.97 2.6-0.54 0.33-1-0.26-1-1.35 0-1.08 0.46-2.26 1-2.59 0.07-0.04 0.16-0.08 0.22-0.09zm-115.31 0.59c-0.54 0-1 0.89-1 1.97s0.46 1.97 1 1.97 0.97-0.89 0.97-1.97-0.43-1.97-0.97-1.97zm143.19 0.25c0.28-0.02 0.11 0.44-0.47 1.53-0.6 1.12-1.57 2.32-2.16 2.69-0.77 0.48-0.78 0.11 0-1.35 0.6-1.11 1.6-2.32 2.19-2.68 0.19-0.12 0.34-0.18 0.44-0.19zm-48.38 2.06c-0.12 0.02-0.24 0.04-0.38 0.13-0.54 0.33-1 0.82-1 1.06s0.46 0.44 1 0.44c0.55 0 0.97-0.49 0.97-1.06 0-0.43-0.24-0.63-0.59-0.57zm67.88 0c-0.12 0.02-0.24 0.04-0.38 0.13-0.54 0.33-1 0.82-1 1.06s0.46 0.44 1 0.44 0.97-0.49 0.97-1.06c0-0.43-0.24-0.63-0.59-0.57zm65 0.16 0.78 5.25c0.83 5.77-1.18 11.94-3.88 11.94-1.19 0-1.13-0.28 0.19-1.6 0.87-0.87 1.29-1.86 0.97-2.18-0.33-0.33-0.99 0.07-1.5 0.87-0.82 1.27-1.07 1.26-1.97-0.03-0.85-1.23-0.99-1.14-0.75 0.47 0.19 1.29-0.37 2.02-1.69 2.25-1.62 0.27-1.71 0.15-0.5-0.69 1-0.69 1.08-1.05 0.25-1.06-0.69-0.01-1.22-1.21-1.22-2.75 0-1.52 0.54-3.34 1.22-4.06 1.01-1.09 0.94-1.25-0.47-0.76-2.47 0.88-2.23-1.93 0.28-3.28 1.12-0.59 2.55-0.92 3.16-0.72 0.61 0.21 2.02-0.54 3.13-1.65l2-2zm-295.41 1.03c0.09-0.02 0.29 0 0.65 0.09 0.73 0.19 1.96 0.35 2.72 0.35 2.56 0 1.43 1.9-1.93 3.31-1.83 0.76-3.64 1.9-4 2.5-0.84 1.35-3.5 1.42-3.5 0.09 0-0.54 0.59-1 1.31-1 1.65 0 6.02-4.53 4.94-5.12-0.23-0.12-0.28-0.2-0.19-0.22zm210.22 2.72c0.07 0.01 0.1 0.09 0.09 0.22-0.02 0.51-0.67 1.79-1.47 2.84-0.79 1.05-1.42 1.48-1.4 0.97 0.01-0.51 0.67-1.76 1.47-2.81 0.59-0.79 1.1-1.26 1.31-1.22zm-4.07 0.19c0.16-0.01 0.26 0.08 0.26 0.28 0 0.51-0.66 1.48-1.47 2.15-0.82 0.68-1.47 0.94-1.47 0.57 0-0.38 0.65-1.38 1.47-2.19 0.5-0.51 0.95-0.8 1.21-0.81zm-230.62 1.9c3.48-0.07 8.56 1.25 8.56 2.53 0 0.52-1.77 0.94-3.94 0.94-2.16 0-3.93-0.43-3.93-0.97s-0.43-0.97-0.97-0.97-1 0.66-1 1.47c0 0.84-0.88 1.47-2.03 1.47-2.95 0-2.02-3.07 1.25-4.16 0.54-0.18 1.26-0.29 2.06-0.31zm28.81 0.57c0.15-0.01 0.28-0.02 0.41 0 0.61 0.06 1 0.36 1 0.87 0 0.5-0.57 1.15-1.25 1.47-0.98 0.46-0.98 0.7 0 1.16 2.16 1 1.33 2.37-1.47 2.4-2.59 0.03-2.61 0.09-0.78 1.47 1.79 1.36 1.68 1.44-1.66 1.44-1.95 0-4.12 0.15-4.84 0.34-2.09 0.55-21.5-1.45-21.5-2.22 0-1.1 8.72-2.94 16.72-3.53 4.04-0.3 8.32-1.21 9.53-2 1.35-0.89 2.82-1.37 3.84-1.4zm152.19 0.03c0.5 0.03-0.27 1.3-2.53 3.5-2.01 1.95-3.66 3.95-3.66 4.43s-0.44 0.85-1 0.85c-1.49 0 0.71-3.77 3.81-6.5 1.83-1.61 2.99-2.31 3.38-2.28zm-147.69 0.15c0.19-0.08 0.61 0.2 1.31 0.78 0.82 0.68 1.5 1.59 1.5 2.07 0 1.46-1.71 0.96-2.34-0.69-0.52-1.35-0.71-2.05-0.47-2.16zm29 0.78c0.21 0 0.35 1.32 0.35 2.94s-0.34 2.94-0.78 2.94c-0.45 0-0.65-1.32-0.41-2.94s0.63-2.94 0.84-2.94zm54.35 0c0.84-0.04 2.1 1.14 3 3.19 1.85 4.25 7.73 13.35 10.78 16.72 1.34 1.49 3.44 2.72 4.65 2.72 2.31 0 6.29-4.18 6.29-6.59-0.01-0.78 0.42-1.15 0.96-0.82 0.54 0.34 1 0.05 1-0.65 0.01-0.71 0.98-0.13 2.19 1.31 1.22 1.43 2.91 2.81 3.72 3.09 0.95 0.33 0.68 0.55-0.72 0.6-1.24 0.04-2.61-0.78-3.22-1.91-1.41-2.63-3.11-1.5-2.34 1.56 0.45 1.8 0.18 2.41-1 2.41-0.87 0-1.59 0.69-1.59 1.56-0.01 1-0.54 1.39-1.47 1.03-0.89-0.34-1.47-0.01-1.47 0.82 0 2.07-1.59 2.68-2.91 1.09-0.64-0.77-2.46-1.69-4.03-2.03-3.35-0.74-11.3-9.19-13.47-14.28-0.8-1.9-1.86-4.21-2.34-5.16-0.55-1.08-0.5-1.72 0.12-1.72 0.55 0 0.97-0.66 0.97-1.47 0-0.99 0.37-1.44 0.88-1.47zm53.43 0.1c0.57-0.09 0.81 0.29 0.6 0.94-0.24 0.71-1.01 1.48-1.72 1.71-0.74 0.25-1.09-0.1-0.85-0.84 0.24-0.71 1.01-1.51 1.72-1.75 0.1-0.03 0.17-0.05 0.25-0.06zm-138.47 0.87c0.24 0 0.7 0.43 1.04 0.97 0.33 0.54 0.16 1-0.41 1s-1.06-0.46-1.06-1 0.2-0.97 0.43-0.97zm-44.24 1.07c0.36 0.05 0.25 0.49-0.07 1.31-0.58 1.53-5.31 2.78-5.31 1.4 0-0.48 1.14-1.31 2.53-1.84 1.63-0.62 2.48-0.93 2.85-0.87zm91.4 0c-0.22-0.08-0.14 0.31 0.19 1.18 0.37 0.97 0.91 1.52 1.22 1.22 0.3-0.3 0.01-1.11-0.66-1.78-0.36-0.36-0.61-0.58-0.75-0.62zm-24.56 0.28c0.35 0.01 0.59 0.43 0.59 1.06 0 0.84-0.46 1.53-1 1.53s-0.97-0.43-0.97-0.94 0.43-1.19 0.97-1.53c0.14-0.08 0.29-0.13 0.41-0.12zm-63.34 0.62c0.54 0 0.96 0.43 0.96 0.97s-0.42 1-0.96 1c-0.55 0-1-0.46-1-1s0.45-0.97 1-0.97zm-66.818 1.97c0.445-0.09 1.434 0.21 2.844 0.97 2.394 1.28 5.906 7.07 5.906 9.72 0.001 1.15-0.395 2.09-0.906 2.09-1.459 0-4-4.14-4-6.53 0-1.19-1.168-3.1-2.594-4.22-1.5-1.18-1.821-1.92-1.25-2.03zm213.5 0.13c0.14-0.07 0.46 0.28 0.97 1.15 0.58 0.99 0.85 2.03 0.59 2.28-0.25 0.26-0.75-0.24-1.09-1.12-0.53-1.39-0.65-2.23-0.47-2.31zm53.19 0.09c-0.12 0.04-0.19 0.17-0.19 0.41 0 0.55 0.3 1.32 0.66 1.68s0.88 0.41 1.16 0.13c0.27-0.28-0.02-1.02-0.66-1.66-0.44-0.44-0.77-0.63-0.97-0.56zm116.22 0.19c0.23 0.06 0.43 0.74 0.78 2.06 0.9 3.36 0.59 4-1 2.09-0.63-0.75-0.82-2.19-0.44-3.19 0.22-0.57 0.41-0.87 0.57-0.93 0.03-0.02 0.06-0.04 0.09-0.03zm-389.5 0.12c0.079 0.04 0.168 0.25 0.281 0.69 0.409 1.57 1.519 2.16 3.5 1.84 0.406-0.06 0.75 0.34 0.75 0.88s-0.428 0.97-0.969 0.97c-1.75 0-1.06 1.98 0.719 2.06 1.028 0.05 1.235 0.26 0.5 0.56-1.74 0.7-1.52 2.31 0.312 2.31 0.918 0 1.237 0.44 0.813 1.13-0.415 0.67 0.471 2.09 2.125 3.4 1.554 1.24 2.604 2.49 2.344 2.76-0.602 0.6-6.209-4.36-7.156-6.32-0.393-0.81-1.374-2.58-2.157-3.94-0.782-1.35-1.367-3.55-1.312-4.9 0.042-1.04 0.117-1.51 0.25-1.44zm68.281 2.1c1.8-0.12 3.97 1.38 9.53 5.71 5.13 4 13.99 9.37 15.53 9.41 0.67 0.02 2.96 0.86 5.13 1.91 2.16 1.04 4.72 1.92 5.68 1.93 1.35 0.03 1.67 0.68 1.38 2.75-0.35 2.47-0.69 2.71-4.19 2.5-2.11-0.12-5.32 0.02-7.15 0.32-3.13 0.5-3.27 0.61-1.72 2.15 1.28 1.28 3.5 1.66 9.9 1.66 6.99 0 8.41 0.32 9.38 1.87 0.82 1.32 0.86 2.12 0.09 2.88-0.76 0.76-1.06 0.58-1.06-0.66 0-2.47-1.63-1.12-2.19 1.81-0.36 1.9-0.09 2.47 1.25 2.47 0.96 0 1.95-0.54 2.19-1.21 0.24-0.68 0.8-0.89 1.25-0.47s-1.41 3.08-4.16 5.9c-2.74 2.83-5.51 6.12-6.12 7.31-0.77 1.51-1.63 1.96-2.81 1.5-1.61-0.61-1.62-0.49-0.07 1.88 1.33 2.03 1.48 3.31 0.72 6.69-1.03 4.6-3.88 8.32-4.62 6.09-0.3-0.89-0.9-0.56-1.97 0.97-1.12 1.6-1.22 2.31-0.38 2.59 1.44 0.48 1.61 11.66 0.19 12.54-1.16 0.71-1.33 3.43-0.22 3.43 0.42 0 1.49-2.31 2.38-5.15 1.31-4.2 1.65-4.64 1.72-2.32 0.08 3.18-4.02 10.87-6.25 11.72-2.23 0.86-3.88-1.77-2.07-3.28 0.82-0.68 1.48-1.93 1.47-2.81 0-1.03-0.7-0.56-1.97 1.34-1.07 1.63-1.74 3.5-1.5 4.16 0.25 0.66-0.29 1.65-1.21 2.19-1.55 0.9-1.53 0.97 0.15 1 1.5 0.02 1.27 0.5-1.15 2.62-3.14 2.75-17.82 9.65-18.69 8.78-0.29-0.28 1.2-1.23 3.31-2.09 7.46-3.05 14.09-6.34 14.69-7.31 0.84-1.37 0.11-1.23-4.07 0.75-2.68 1.27-3.73 1.41-4.03 0.53-0.41-1.22-0.64-1.14-6.68 1.94-1.63 0.82-4.49 1.79-6.38 2.18-1.89 0.4-3.9 1.09-4.44 1.5-1.06 0.81-8.35 2.5-14.87 3.47-3.01 0.45-5.25 1.73-8.6 4.94-2.49 2.39-4.56 4.49-4.56 4.65 0 0.17 0.91 0.36 2 0.44 1.1 0.08 1.73-0.29 1.41-0.81s-0.04-0.84 0.65-0.69c0.7 0.15 1.29-0.21 1.32-0.84 0.05-1.46 4.86-5.25 6.65-5.25 0.76 0 1.83-0.48 2.41-1.06s2.52-0.93 4.31-0.75c3.23 0.31 3.25 0.35 0.88 1.5-1.32 0.63-3.67 1.42-5.19 1.75-2.88 0.62-14.44 11.2-14.44 13.21 0 0.64-2.89 4.06-6.4 7.6-3.52 3.53-6.379 6.64-6.379 6.94 0 0.29 1.085 0.32 2.438 0.06 1.352-0.26 2.471-0.12 2.471 0.28 0 1.15-4.792 1.79-5.159 0.69-0.18-0.54-2.509 0.61-5.187 2.62-7.641 5.73-8.438 6.47-7.875 7.38 0.29 0.47-0.195 1.11-1.031 1.43-1.02 0.4-1.274 0.23-0.813-0.59 0.527-0.93 0.39-0.97-0.563-0.09-0.683 0.63-1.747 2.17-2.374 3.44-0.628 1.26-2.12 2.45-3.313 2.62-1.571 0.23-2.487 1.39-3.344 4.25-1.009 3.37-1.525 3.87-3.469 3.5-1.253-0.24-2.281-0.06-2.281 0.41 0 0.46 0.428 0.87 0.969 0.87 1.817 0 1.012 1.61-1.469 2.94-1.352 0.72-2.468 1.87-2.469 2.53 0 0.66-1.084 1.4-2.437 1.66-1.649 0.31-2.469 0.02-2.469-0.88 0-0.74-0.427-1.34-0.968-1.34-0.542 0-1 0.88-1 1.97 0 1.08-0.428 1.97-0.969 1.97s-1.015-0.78-1.031-1.72c-0.029-1.64-0.046-1.64-1 0-1.41 2.42-3.836 2.23-3.188-0.25 0.283-1.09 1.127-1.97 1.875-1.97s1.375-0.43 1.375-0.97c0-1.79-2.819-1.04-4.375 1.19-1.696 2.42-2.097 1.65-0.594-1.16 1.346-2.52 15.913-13.09 19.657-14.28 1.442-0.46 1.935-1.2 1.562-2.38-0.361-1.13 0.883-3.28 3.656-6.31 5.035-5.49 5.546-6.12 8.625-10.53 1.322-1.89 5.128-6.1 8.469-9.34 3.341-3.25 7.48-8.54 9.219-11.78 3.161-5.91 11.801-15.26 19.161-20.72 2.14-1.6 4.7-3.69 5.68-4.66 0.99-0.97 2.81-2.17 4-2.69 1.2-0.52 2.82-1.33 3.63-1.81s2.58-1.35 3.93-1.88c1.36-0.52 4.02-1.59 5.91-2.4s7.37-2.07 12.16-2.78c5.51-0.82 9.51-1.95 10.84-3.1l2.06-1.81-2.84 0.66c-2.02 0.46-2.65 0.33-2.16-0.47 0.42-0.67 0.08-1.16-0.87-1.16-1.48 0-1.47-0.12 0-1.59 2.69-2.69 0.65-2.86-2.22-0.19-5.06 4.71-12.02 4.37-10.47-0.53 0.55-1.73 0.46-1.91-0.75-0.91-1.14 0.95-1.94 0.87-3.84-0.43-3.19-2.18-3.83-3.23-3.85-6.29-0.02-3.69 3.41-7.56 7.38-8.31 1.86-0.35 3.12-1.03 2.81-1.53s-2.12-0.64-4.03-0.28c-3.27 0.61-3.36 0.55-2.34-1.34 0.59-1.11 1.52-2.19 2.09-2.38s1.46-3.15 1.94-6.56c1.07-7.58 2.13-9 6.84-9 4.22 0 9.88-1.73 9.88-3.03 0-1.21-4.65-1.13-5.41 0.09-0.8 1.29-4.44 1.26-4.44-0.03 0-0.55-1.24-0.9-2.75-0.78-4.03 0.31-4.99-0.73-5.68-6-0.56-4.22-0.9-4.75-3.04-4.75-1.83 0-2.25 0.37-1.75 1.59 1.78 4.3 1.67 4.94-1.15 5.57-4.63 1.01-5.32 1.35-5.32 2.53 0 0.62 0.85 0.89 1.88 0.62 2.32-0.6 4.78 0.7 3.19 1.69-0.6 0.37-1.13 0.17-1.13-0.44s-2.66 1.46-5.9 4.66c-3.25 3.19-5.88 6.22-5.88 6.68 0 0.47 1.32-0.44 2.94-2 1.62-1.55 2.94-2.39 2.94-1.84s-2.11 2.72-4.72 4.84c-2.62 2.13-4.6 4.46-4.38 5.13 0.4 1.19-2.8 1.76-3.87 0.69-0.69-0.69 2.85-13.74 4.69-17.28 0.79-1.53 2.89-4.22 4.71-6 1.83-1.79 3.66-4.34 4.07-5.69 1.62-5.43 5.75-10.91 10.62-14.06 0.95-0.62 1.65-0.98 2.47-1.03zm52.34 0.34c1.16 0 2.75 0.34 3.97 1 1.04 0.55 2.42 1.98 3.06 3.19 1.06 1.98 1.02 2.06-0.46 0.84-0.9-0.74-1.66-0.99-1.66-0.56s-1.12-0.26-2.47-1.53c-1.97-1.85-2.47-1.99-2.47-0.72 0 0.87 0.46 1.85 1 2.18 0.54 0.34 0.97 1.03 0.97 1.54 0 0.9-2.18 1.31-3 0.56-0.22-0.21-6.41-0.72-13.72-1.1-7.3-0.37-15.71-1.32-18.69-2.15-6.47-1.81-8.99-3.68-3.93-2.91 9.2 1.41 13.66 1.74 21.03 1.56 4.4-0.1 9.71-0.13 11.78-0.06 2.36 0.09 3.52-0.21 3.12-0.84-0.4-0.66 0.32-1 1.47-1zm264.5 0c0.87 0 1.1 0.52 0.69 1.59-0.35 0.91-0.06 2.01 0.63 2.44 1 0.62 0.97 1.03 0 2-0.68 0.67-1.22 1.93-1.22 2.75 0 1.05 0.46 0.81 1.53-0.72 1.83-2.61 4.34-2.87 4.5-0.47 0.06 0.95 0.26 3 0.44 4.53 0.24 2.09-0.05 2.65-1.1 2.25-0.77-0.29-1.75 0.15-2.22 0.97-1.07 1.92-5.32 2.42-7.43 0.88-1.73-1.27-2.17-3.44-0.72-3.44 0.48 0 1.13-0.8 1.47-1.75 0.33-0.95 0.84-2.26 1.15-2.94 0.33-0.69-0.06-1.22-0.9-1.22-0.82 0-1.79 0.89-2.13 1.97s-1.29 1.97-2.12 1.97c-1.06 0-1.31-0.52-0.82-1.72 0.39-0.94 0.95-2.53 1.22-3.47s0.87-1.45 1.35-1.15c0.47 0.29 0.54-0.23 0.18-1.16-0.5-1.31-0.25-1.57 1.07-1.06 0.93 0.36 1.45 0.26 1.15-0.22-0.29-0.48 0.15-1.14 1-1.47 0.99-0.38 1.76-0.56 2.28-0.56zm-242.87 0.97c0.54 0 0.97 0.65 0.97 1.47 0 0.81-0.43 1.46-0.97 1.46s-0.97-0.65-0.97-1.46c0-0.82 0.43-1.47 0.97-1.47zm-66.13 0.28c0.54 0.02 1.63 0.4 3.16 1.19 4.97 2.57 21.54 5.36 32.47 5.5 4.81 0.06 9.5 1.25 14.5 3.62 3.56 1.7 4.39 3.67 1.09 2.63-1.76-0.56-1.98-0.38-1.43 1.15 0.55 1.55 0.36 1.5-1.1-0.28-1.24-1.5-2.3-1.89-3.69-1.37-1.07 0.39-3.5 0.38-5.4-0.07-4.45-1.03-4.94-1.03-4.94 0 0 0.48 1.68 1.12 3.72 1.44 3.98 0.64 13 5.84 13 7.5 0 1.32-1.03 1.24-3.44-0.37-1.87-1.26-11.03-3.98-21.65-6.41-5.08-1.16-21.16-8.6-21.16-9.78 0-0.37-1.34-1.49-3-2.47-2.44-1.44-3.03-2.32-2.13-2.28zm177.63 0.19c0.29-0.04 0.24 0.42-0.03 1.46-0.65 2.47-2.28 3.67-2.28 1.69 0-0.77 0.63-1.95 1.4-2.59 0.43-0.36 0.74-0.54 0.91-0.56zm-102.19 0.81c0.07-0.11 0.47 0.26 1.22 0.94 1.17 1.05 3.49 1.71 6 1.71 3.66 0.01 4.16 0.27 4.69 2.69 1.13 5.18 1.69 5.81 2.44 2.72 0.53-2.21 0.72-1.29 0.81 3.69 0.06 3.65 0 6.62-0.16 6.62-0.96 0-2.65-2.59-2.65-4.09 0-0.97-0.45-1.78-0.97-1.78-1.67 0-7.68-5.84-9.91-9.63-1.08-1.84-1.56-2.74-1.47-2.87zm193.85 0.65c0.33 0.01 0.39 0.32-0.04 1-0.33 0.54-1.56 1.48-2.75 2.1-2.14 1.12-2.14 1.16-0.28-0.94 1.18-1.32 2.5-2.17 3.07-2.16zm-126.16 0.44c0.21 0.02 0.61 0.3 1.22 0.91 0.81 0.81 1.47 1.75 1.47 2.06 0 0.77-1.48 0.71-2.29-0.09-0.36-0.36-0.68-1.3-0.68-2.06 0-0.58 0.06-0.83 0.28-0.82zm30.28 2.72c1.19 0.03 1.25 3.44-0.06 4.25-0.54 0.34-0.97 1.45-0.97 2.47 0 2.96-2.2 6.98-3.53 6.47-0.73-0.28-1.9 1.2-2.88 3.65-1.43 3.57-2.09 6.39-3.94 16.91-0.19 1.08-1.05 5.67-1.93 10.19-1.5 7.67-1.46 10.27 0.15 8.66 0.38-0.38 1.26-4.33 1.94-8.79 1.06-6.89 1.15-7.12 0.66-1.68-0.32 3.51-0.74 10.94-0.88 16.53-0.14 5.58-0.43 10.37-0.68 10.62-0.26 0.26-0.67-2.29-0.91-5.65-0.41-5.65-0.75-6.34-4.22-9.25-3.46-2.91-3.7-3.46-3.22-7.07 0.29-2.15 1.2-5.41 2.03-7.25 0.84-1.83 2.24-5.55 3.13-8.25 0.88-2.69 1.96-5.35 2.4-5.9 0.44-0.56 1.57-3.43 2.47-6.41 1.93-6.35 8.49-18.9 10.19-19.47 0.09-0.03 0.17-0.03 0.25-0.03zm89.91 0.88c0.56-0.03 0.39 0.4-0.44 1.4-1.36 1.64-2.97 1.96-2.97 0.6 0-0.49 0.71-1.18 1.56-1.5 0.9-0.35 1.51-0.49 1.85-0.5zm-86.75 1.9c0.12 0 0.08 6.27-0.1 13.97-0.38 16.47 0.31 22.86 2.38 22.06 1.82-0.7 1.95 6.79 0.15 8.69-0.67 0.71-1.95 2.17-2.84 3.25-0.89 1.09-2.42 2.44-3.37 2.97-2.15 1.2-3.41 12-1.41 12 0.85 0 1.03-1.02 0.59-3.38-0.36-1.95-0.21-3.6 0.38-3.96 0.59-0.37 1 0.42 1 1.93 0 1.47 0.44 2.32 1 1.97 0.54-0.33 0.97-1.71 0.97-3.06 0-1.39 0.44-2.19 1-1.84 0.54 0.33 0.97 2.28 0.97 4.34 0 5.21 1.06 9.91 2.21 9.91 0.56 0 0.74-1.36 0.41-3.19-1.69-9.37-1.55-11.69 0.28-4.69 1.06 4.06 2.13 8.49 2.41 9.85 0.3 1.46 2.52 3.99 5.5 6.21 2.74 2.05 4.72 4.17 4.37 4.72-0.34 0.56-2.35 0.9-4.44 0.75-2.08-0.15-4.08 0.03-4.46 0.41-0.87 0.87-1.34 0.79-3.82-0.63-3.82-2.19-6.04-4.12-8.28-7.18-2.05-2.82-2.28-4.23-2.4-15.44-0.13-11.28 0.02-12.5 1.81-13.81 1.34-0.99 2.18-1.07 2.62-0.35 0.45 0.72 1.13 0.6 2.1-0.37 2.01-2.01 2.8-5.04 1.75-6.72-0.74-1.18-1.35-1.23-3.56-0.22-4.23 1.92-4.87 0.42-3.57-8.41 0.62-4.2 1.42-10.54 1.78-14.06 0.37-3.52 0.73-6.83 0.85-7.37 0.27-1.3 3.42-8.35 3.72-8.35zm-120.85 0.32c0.36-0.07 0.57 0.12 0.57 0.53 0 0.54-0.43 1.26-0.97 1.59s-1 0.2-1-0.34 0.46-1.29 1-1.63c0.13-0.08 0.28-0.13 0.4-0.15zm39.31 0.46c0.29-0.06 0.61 0.01 1.04 0.16 1.69 0.6 1.72 0.72 0.25 1.28-1.14 0.44-1.66 1.79-1.66 4.28 0 4.23 0.9 3.88 1.94-0.78 0.6-2.71 0.86-1.91 1.5 4.88 1.05 11.17 2.74 11.65 1.97 0.56-0.47-6.62-0.34-8.3 0.5-6.97 0.6 0.96 1.37 7.22 1.68 13.91 0.63 13.36 0.74 12.97-5.96 20.22-1.97 2.12-3.59 4.68-3.6 5.65-0.05 4.19-4.44 10.99-11.37 17.66-9.69 9.32-9.61 11.33 0.5 12.47 6.95 0.78 8.51 2.3 7 6.72-1.07 3.1-7.94 8.83-7.94 6.62 0-0.54 1.35-1.7 2.97-2.62 3.36-1.92 3.88-5.09 0.97-5.85-1.09-0.28-1.97-0.82-1.97-1.19s-2.22-1.45-4.94-2.43l-4.97-1.79 0.56-19.34c0.32-10.62 0.8-21.97 1.03-25.22 0.24-3.24 0.74-10.88 1.1-16.97 0.66-11.18 1.9-15.43 1.72-5.9-0.08 4.24-0.02 4.43 0.31 1 0.57-6.04 3.22-4.96 3.22 1.31 0 1.46 0.56 2.38 1.47 2.38 1.29-0.01 1.43 2.71 0.87 21.62-0.47 15.97-0.33 21.66 0.5 21.66 0.81 0 1.1-5.44 1.1-19.19 0-11.2 0.4-19.19 0.93-19.19 0.55 0 0.77 6.24 0.57 15.25-0.2 8.62 0.05 15.5 0.56 15.81 0.53 0.33 0.91-5.69 0.91-14.75 0-9.54 0.35-15.31 0.96-15.31 0.54 0 1.02 2.32 1.07 5.16 0.04 2.84 0.45 7.39 0.87 10.09 0.72 4.59 0.78 4.37 0.91-3.37 0.09-5.95 0.43-8.04 1.19-7.28 0.58 0.58 1.29 2.89 1.59 5.12s0.94 4.03 1.44 4.03c0.49 0 0.83-0.54 0.75-1.22-0.09-0.67-0.12-1.87-0.04-2.69 0.12-1.16 0.38-1.12 1.19 0.29 0.77 1.32 0.66 2.38-0.5 4.15-1.78 2.72-2.02 4.41-0.59 4.41 0.54 0 0.97-0.66 0.97-1.47s0.42-1.5 0.9-1.5c0.49 0 1.15-1.14 1.5-2.56 0.48-1.92-0.03-3.65-2.06-6.66-5.6-8.33-5.89-9.35-4.78-16.44 0.68-4.35 1.03-5.8 1.87-6zm98.97 0.19c-0.54 0-0.97 0.49-0.97 1.06 0 0.58 0.43 0.74 0.97 0.41s1-0.79 1-1.03-0.46-0.44-1-0.44zm45.25 0.13c0.63 0 1.25 0.06 1.72 0.18 0.95 0.25 0.18 0.47-1.72 0.47-1.89 0-2.66-0.22-1.72-0.47 0.48-0.12 1.1-0.18 1.72-0.18zm-16.72 0.87c1.62 0 1.15 3.64-1 7.47-1.1 1.97-1.81 3.78-1.53 4.06 0.76 0.76 3.63-1.81 4.57-4.12 0.77-1.91 0.81-1.88 0.87 0.28 0.04 1.35-1.23 3.42-3.12 5.16-1.75 1.59-2.75 2.93-2.22 3 0.52 0.06 1.62 0.17 2.43 0.24 0.88 0.08 1.63 1.32 1.82 3.07 0.45 4.19 1.9 5.23 2.72 1.97l0.65-2.72 1.28 2.34c1.17 2.17 1 2.36-2.37 3.53-4.81 1.68-4.66 1.76-4.53-2.15 0.07-2.27-0.33-3.44-1.19-3.44-0.72 0-1.3 0.54-1.31 1.22-0.01 0.82-0.27 0.89-0.75 0.18-0.4-0.58-1.52-1.33-2.47-1.68-1.26-0.47-1.72-1.75-1.72-4.69 0-2.22-0.44-4.89-1-5.94-0.85-1.58-0.69-1.9 0.94-1.9 3.26 0 6.97-2.15 6.97-4.07 0-0.99 0.42-1.81 0.96-1.81zm13.72 0.97c0.58 0 1.04 0.46 1.04 1s-0.2 0.97-0.44 0.97-0.7-0.43-1.03-0.97c-0.34-0.54-0.14-1 0.43-1zm75.25 0.31c-0.53 0.09-1.28 1.15-1.68 2.69-0.44 1.67-0.31 1.83 0.84 0.88 0.77-0.64 1.41-1.82 1.41-2.6 0-0.74-0.25-1.02-0.57-0.97zm-371.46 0.72c0.579 0.03 1.413 0.54 2.187 1.47 0.685 0.82 0.942 1.78 0.594 2.12-0.347 0.35-0.625 0.1-0.625-0.53s-0.657-1.12-1.469-1.12c-0.811 0-1.5-0.46-1.5-1 0.001-0.55 0.246-0.83 0.594-0.91 0.073-0.01 0.136-0.03 0.219-0.03zm366.5 1.28c-0.11 0.02-0.23 0.08-0.37 0.16-0.54 0.33-1 0.79-1 1.03s0.46 0.44 1 0.44 0.97-0.46 0.97-1.03c0-0.43-0.24-0.66-0.6-0.6zm-7.15 0.57c0.49-0.09 1.31 0.73 2.53 2.53 3.15 4.63 2.43 6.69-0.88 2.47-1.4-1.8-2.31-3.91-2.03-4.66 0.09-0.23 0.22-0.32 0.38-0.34zm-193.91 0.15c0.5-0.05 1.05 0.98 1.13 3.13 0.23 6.67 1.04 7.84 1.84 2.68 0.61-3.91 0.68-3.53 0.81 3.22 0.09 4.2-0.07 7.63-0.34 7.63s-0.47-1.12-0.47-2.47-0.39-2.47-0.84-2.47c-1.35 0-3.1-4.76-3.1-8.41 0-2.15 0.47-3.26 0.97-3.31zm-36.15 0.13-0.63 4.59c-0.36 2.51-1.08 9.57-1.62 15.69-0.55 6.11-1.43 12.2-1.94 13.56-0.52 1.36-0.97 5.68-0.97 9.62 0 3.95-0.28 9.9-0.63 13.22-0.56 5.42-0.84 6.07-2.81 6.07-1.21 0-2.76 0.65-3.43 1.47-0.68 0.81-1.62 1.5-2.1 1.5-1.12-0.01-1.12-2.33 0-3.54 1.55-1.67 3.99-15.42 4.63-26 0.34-5.68 0.94-10.77 1.28-11.31s0.82-6.27 1.09-12.75l0.5-11.78 3.31-0.19 3.32-0.15zm-95.03 0.15c0.8 0.03 1.34 0.22 1.34 0.6 0 0.55-0.11 1-0.25 1s-1.68 0.43-3.44 0.93c-3 0.86-4.4-0.03-2.19-1.4 1.18-0.73 3.2-1.17 4.54-1.13zm80.21 0.03c0.17-0.05 0.52 0.53 0.91 1.5 0.52 1.3 0.75 2.51 0.53 2.72-0.49 0.5-1.64-2.43-1.56-3.97 0.01-0.15 0.07-0.23 0.12-0.25zm260.29 0.66c0.28-0.1 0.01 0.4-0.66 1.66-1.22 2.29-2.06 2.84-2.06 1.34 0-0.47 0.75-1.44 1.65-2.19 0.56-0.46 0.9-0.75 1.07-0.81zm-377.16 1c0.134 0.05 0.385 0.26 0.75 0.62 0.672 0.67 0.959 1.48 0.656 1.79-0.303 0.3-0.849-0.25-1.219-1.22-0.333-0.88-0.411-1.27-0.187-1.19zm356.31 0.38c0.06-0.01 0.11-0.02 0.16 0 0.2 0.07 0.27 0.47 0.28 1.09 0.01 1.56 0.16 1.62 0.91 0.44 0.5-0.8 1.26-1.11 1.65-0.72s-0.26 1.72-1.44 2.97c-2.14 2.28-2.88 5.59-1.25 5.59 0.49 0 1.15-1.02 1.47-2.31 0.84-3.34 3.53-4.23 3.53-1.16 0 1.3-0.42 2.67-0.96 3-0.55 0.34-1 3.63-1 7.34-0.01 7.13-0.56 9.85-2.1 9.85-0.51 0-0.64-0.46-0.28-1.03 0.86-1.4-0.43-7.82-1.56-7.82-0.49 0-0.83 2.62-0.82 5.82 0.02 3.85-0.55 6.69-1.65 8.37-0.92 1.4-2.05 2.53-2.53 2.53-1.33 0-1.04-1.11 0.78-3.12 1.21-1.34 1.66-3.77 1.72-9.19 0.04-4.5-0.34-7.23-0.94-7.03-0.54 0.18-1.12 1.14-1.31 2.12-0.19 0.99-0.75 2.29-1.25 2.88-0.51 0.59-1.55 1.95-2.32 3.03-1.26 1.79-1.33 1.65-0.5-1.47 0.51-1.89 1.61-6.26 2.44-9.72 1.04-4.31 2.45-7.21 4.47-9.28 1.39-1.42 2.11-2.12 2.5-2.18zm-352.25 1.28c0.427-0.03 1.697 1.08 4.313 3.62 2.756 2.67 5.286 4.56 5.626 4.22s-0.53-1.69-1.94-3c-3.723-3.45-3.18-4.16 0.84-1.09 4.1 3.12 4.28 4.27 1 7.12-1.35 1.18-2.81 2.16-3.21 2.16-0.91 0-5.627-8.47-6.598-11.81-0.224-0.78-0.287-1.21-0.031-1.22zm25.279 0.68c0.88-0.15-4.22 5.72-7.87 9-5.91 5.31-7.07 6.54-7.07 7.38 0 0.48 0.22 0.87 0.5 0.87 0.74 0 7.13-5.78 10.72-9.71 5.16-5.65 5.59-6.04 7.28-6.04 1.15 0 0.56 1-1.9 3.22-2.55 2.3-4.72 6.03-7.72 13.28-2.3 5.56-4.58 10.32-5.03 10.6s-1.3-0.42-1.91-1.56c-0.93-1.74-0.63-2.75 1.69-6.16 4.53-6.65 4.68-7.24 1.13-3.88-3.87 3.66-6.32 4.1-7.22 1.25-0.42-1.3 0.14-2.93 1.62-4.71 2.31-2.8 12.71-11.81 15.5-13.44 0.11-0.07 0.22-0.09 0.28-0.1zm262.91 0.88c0.04-0.01 0.07-0.01 0.12 0 0.14 0.03 0.34 0.18 0.53 0.37 0.78 0.78 0.79 1.58 0.04 2.88-0.93 1.59-1.1 1.48-1.13-1.06-0.01-1.39 0.13-2.1 0.44-2.19zm-115.25 0.03c0.21-0.05 0.56 0.37 1.16 1.16 1.42 1.88 1.43 1.88 1.59-0.07 0.08-1.08 0.51 0.92 0.97 4.44 0.92 7.18 2.89 12.03 3.81 9.41 0.5-1.42 0.78-1.4 2.78 0 1.21 0.84 2.17 2.27 2.16 3.19-0.03 1.45-0.24 1.42-1.5-0.26-1.43-1.89-1.43-1.89-1.44 0-0.01 1.62-0.17 1.69-1.03 0.44-0.84-1.21-0.98-1.12-0.72 0.5 0.23 1.43 1.06 1.98 3.12 2 2.02 0.03 3.12 0.68 3.69 2.22 0.45 1.2 1.23 2.16 1.72 2.16 0.5 0 1.12 0.88 1.41 1.97 0.28 1.08 0.95 1.97 1.53 1.97 1.2 0 0.53-2.14-2-6.38-2.21-3.71-4.75-9.33-4.75-10.47 0-0.47-0.44-0.84-0.97-0.84-1.14 0-3.98-6.43-3.87-8.75 0.04-0.88 0.61-0.25 1.24 1.37 1.2 3.07 3.64 7.09 6.88 11.31 1.75 2.28 1.83 2.29 1.22 0.29-0.64-2.1-0.58-2.12 2.22-0.72 2.49 1.24 2.99 2.16 3.56 6.75 0.36 2.92 0.36 6.9 0 8.84-0.46 2.44-0.31 3.53 0.5 3.53 0.78 0 1 1.06 0.62 3.19l-0.56 3.19 1.47-3.19c2.29-4.99 3.43-3.76 1.66 1.78-1.55 4.86-1.55 5.11 0.69 9.6 2.67 5.36 3.57 7.47 5.03 11.46 0.82 2.27 1.25 2.6 1.93 1.5 0.98-1.58 0.84-1.89 2.91 5.72 0.66 2.43 0.85 6.08 0.47 8.63-0.5 3.34-0.29 4.73 0.81 5.62 1.8 1.46 2.97 4.63 1.72 4.63-0.51 0-1.39-0.89-1.97-1.97s-1.56-1.97-2.19-1.97c-0.85 0-0.84 0.28 0.03 1.16 0.65 0.65 1.19 3.19 1.19 5.65 0 2.69 0.79 5.75 1.94 7.63 1.05 1.72 2.19 4.76 2.56 6.75 0.48 2.52 0.91 3.21 1.5 2.28 0.68-1.07 0.87-1.01 0.88 0.22 0.01 0.84-0.5 2.02-1.13 2.65-0.86 0.87-0.87 2.07-0.03 4.88 0.61 2.05 1.4 6.21 1.75 9.25 0.41 3.46 0.27 5.73-0.37 6.12-1.12 0.69-7.1-5.94-7.1-7.87 0-0.65-0.57-1.8-1.25-2.53-2.33-2.54-12.3-21.26-12.87-24.16-0.19-0.93-0.67-2.42-1.07-3.34-0.39-0.92-0.44-2.15-0.09-2.72s-0.05-1.06-0.87-1.06c-0.99 0-2.05-1.96-3.13-5.66-0.9-3.1-2-6.31-2.41-7.13-0.4-0.81-1.51-4.78-2.46-8.84s-2.01-7.83-2.38-8.37c-1.17-1.74-2.98-8.98-2.97-11.91 0.01-2.19 0.23-2.52 0.97-1.38 0.53 0.82 0.96 2.48 0.97 3.69 0.01 1.22 0.38 2.22 0.81 2.22 0.44 0 1.61 2.93 2.63 6.47 1.01 3.54 2.23 6.67 2.72 6.97 1.76 1.09 1.87-0.57 0.25-4.25-2.32-5.26-3.74-9.14-7.13-19.5-0.88-2.71-2.08-5.22-2.62-5.6-1.31-0.89-1.82-8.68-0.57-8.68 0.54 0 1 0.77 1 1.72 0.03 2.99 5.3 18.51 9.28 27.31 0.74 1.62 2.73 6.06 4.44 9.84 5.95 13.14 9.08 19.19 9.91 19.19 0.46 0-0.65-3-2.47-6.66-5.87-11.74-9.21-19.35-9.81-22.37-0.55-2.74-0.54-2.8 0.53-0.75 0.63 1.22 1.47 2.22 1.84 2.22 0.38 0 1.55 1.89 2.56 4.18 1.02 2.3 2.12 4.39 2.44 4.66 0.33 0.27 1.46 2.05 2.5 3.94 2.76 5 5.34 8.35 5.25 6.78-0.04-0.75-0.93-2.69-1.97-4.31-1.03-1.63-2.45-4.06-3.12-5.41s-1.51-2.67-1.88-2.94c-0.36-0.27-1.75-2.93-3.09-5.9-1.34-2.98-3.15-6.3-4-7.38-1.48-1.87-1.56-1.87-1.59-0.12-0.06 3.23-2.4 0.15-3.82-5-0.72-2.61-1.9-6.07-2.62-7.69-1.49-3.36-4.39-12.95-4.44-14.63-0.02-0.61-0.63-1.91-1.4-2.93-1.28-1.68-1.38-1.5-0.85 1.97 0.33 2.1 0.32 3.57 0 3.28s-0.8-3.15-1.09-6.32c-0.3-3.16-1.22-7.05-2.03-8.68-0.82-1.63-1.5-4.56-1.5-6.47 0-1.84 0.04-2.66 0.31-2.72zm78.5 0.59c0.56-0.02 0.87 0.2 0.87 0.69 0 1.27-3.77 5.22-5 5.22-0.55 0-1.68 0.66-2.5 1.47-0.81 0.81-2.04 1.5-2.75 1.5-0.7 0-1.85-0.69-2.53-1.5-0.84-1.02-0.89-1.47-0.12-1.47 0.6 0 1.13 0.57 1.15 1.25 0.03 0.68 1.49-0.42 3.25-2.41 2.27-2.55 5.94-4.68 7.63-4.75zm-111.78 0.5c-0.17 0.02-0.27 0.76-0.25 1.97 0.02 1.63 0.22 2.15 0.47 1.19s0.23-2.27-0.04-2.94c-0.06-0.16-0.13-0.22-0.18-0.22zm87.18 0c0.36-0.06 0.47 0.53 0.22 1.47-0.6 2.3-1.31 2.6-1.31 0.57 0-0.78 0.42-1.67 0.91-1.97 0.06-0.04 0.13-0.06 0.18-0.07zm35.38 0.57c2.08 0 4.41 1.57 7.75 4.97 2.74 2.77 4.97 5.57 4.97 6.18s1.16 2.3 2.53 3.78c2.16 2.33 3.27 2.69 8.13 2.69 5.82 0 17.52 2.01 21.81 3.72 1.35 0.54 5.78 1.3 9.84 1.69 4.43 0.42 9.41 1.64 12.47 3.06 2.81 1.3 5.65 2.38 6.28 2.38s2.46 1.08 4.06 2.43c2.71 2.28 2.4 2.99-1.06 2.5-0.86-0.12-1.13 0.39-0.75 1.38s0.04 1.56-0.94 1.56c-0.96 0-1.42 0.77-1.31 2.19 0.1 1.21 0.12 2.79 0.06 3.47-0.21 2.45-2.66 1.17-2.62-1.38 0.03-2.02-0.5-2.67-2.41-2.97-1.34-0.21-4.01-1.51-5.93-2.84-1.93-1.34-4.14-2.41-4.88-2.41s-2.16-0.72-3.16-1.62c-1.59-1.45-2.11-1.48-4.4-0.25-3.14 1.68-24.07 1.82-26.1 0.18-0.71-0.57-2.8-1.38-4.65-1.78-3.99-0.85-9.42-3.72-9.44-5-0.02-1.19-3.64-5.31-4.66-5.31-0.44 0-0.33 0.89 0.25 1.97 1.75 3.26 0.1 2.25-5.18-3.19-2.76-2.84-4.69-4.61-4.28-3.93 0.4 0.67 0.29 1.21-0.26 1.21-1.44 0-1.98-1.23-2.18-5-0.24-4.46 0.23-5.97 2.47-8.03 1.19-1.09 2.34-1.66 3.59-1.65zm-73.53 0.62c0.58-0.03 0.69 0.46 0.69 1.66 0 1.18 0.71 3.12 1.56 4.34 1.79 2.56 1.52 4.87-0.34 3-0.67-0.67-1.24-1.68-1.26-2.25-0.01-0.57-0.74-1.92-1.59-3-1.51-1.92-1.53-1.94-0.84 0.34 0.43 1.46 0.35 2.13-0.25 1.76-2.13-1.32-1.91-4.16 0.4-5.26 0.78-0.36 1.28-0.57 1.63-0.59zm-18.47 0.5c0.05 0.04 0.13 0.23 0.19 0.53 0.23 1.22 0.23 3.22 0 4.44-0.24 1.22-0.44 0.22-0.44-2.22 0-1.82 0.1-2.87 0.25-2.75zm120.69 1.53c0.3-0.13 0.68 0.82 1.47 3.16 1.58 4.69 1.26 5.76-1.07 3.44-1.78-1.79-1.84-1.98-0.97-5.25 0.22-0.79 0.38-1.27 0.57-1.35zm-176.38 0.22c0.58 0 1.07 0.46 1.07 1s-0.2 0.97-0.44 0.97-0.73-0.43-1.06-0.97c-0.34-0.54-0.14-1 0.43-1zm63.94 0c0.45 0 1.09 1.23 1.37 2.72 0.58 2.97 0.26 3.91-0.74 2.28-1.08-1.74-1.5-5-0.63-5zm185.78 0c0.42 0 0.86 1.12 0.97 2.47 0.23 2.8-0.25 3.2-1.12 0.91-0.82-2.12-0.77-3.38 0.15-3.38zm-285.25 0.1c1.94-0.06 3.02 0.31 2.66 0.9-0.34 0.54-0.71 0.93-0.82 0.88-0.1-0.06-1.27-0.45-2.62-0.88-2.31-0.74-2.28-0.81 0.78-0.9zm19.25 0.03c0.73-0.07 1.85 0.04 3.59 0.21 8.5 0.85 10.44 5.73 9.54 24.26-0.6 12.18-3.86 25.92-8.04 33.96-0.76 1.47-1.15 3.22-0.9 3.88s-0.25 1.77-1.1 2.47c-1.19 0.99-1.27 1.58-0.37 2.65 0.87 1.05 0.86 1.67 0 2.54-0.63 0.62-1.13 1.74-1.13 2.46 0 0.73-0.83 2.23-1.87 3.35-2.07 2.22-1.73 4.98 0.5 4.12 0.77-0.29 1.37-0.03 1.37 0.57 0 1.96-4.08 1.16-4.62-0.91-0.28-1.08-0.9-1.97-1.38-1.97-1.13 0-1.12 0.7 0.13 3.03 0.78 1.47 0.7 1.88-0.37 1.88-0.77 0-1.73-0.97-2.13-2.19l-0.72-2.22-0.44 2.22c-0.54 2.74-2.28 2.93-2.28 0.25 0-1.09-0.65-1.97-1.47-1.97-0.91 0-1.46 0.91-1.46 2.44 0 1.35-0.46 2.47-1 2.47-2.77 0 0.84-7.21 6.78-13.57 1.65-1.77 3.51-5.09 4.09-7.37 0.58-2.29 1.25-4.74 1.5-5.47s0.68-6.27 0.97-12.28c0.33-6.79 1.26-13.11 2.44-16.69l1.87-5.75-2.44-9.03c-1.33-4.97-2.4-10.08-2.4-11.34 0-1.36 0.12-1.9 1.34-2zm-52.75 1.84c0.11 0-0.06 0.49-0.37 1.47-0.35 1.08-2.24 3.67-4.19 5.75-4.37 4.64-8.97 8.04-8.97 6.62 0-0.57 0.42-1.06 0.91-1.06 0.87 0 8.44-7.52 11.37-11.31 0.76-0.98 1.14-1.47 1.25-1.47zm159.72 0c2.14 0 2.17 0.1 0.97 3.25-0.51 1.34-0.51 2.94-0.03 3.72 0.59 0.96 1.03 0.12 1.5-2.78 0.36-2.28 0.94-3.95 1.31-3.72 0.92 0.57 0.08 7.3-1 7.97-0.48 0.29-0.91 1.61-0.91 2.93 0 1.33-0.46 2.41-1.06 2.41-0.64 0-0.86-0.92-0.53-2.25 0.34-1.37-0.19-3.5-1.34-5.4-2.15-3.54-1.69-6.13 1.09-6.13zm46.31 0c2.28 0 2.21 1.22-0.56 10.84-1.93 6.7-2 10.85-0.22 13.29 1.14 1.55 1.61 1.64 2.88 0.59 0.83-0.7 1.33-1.77 1.09-2.41-0.24-0.63 0.71-1.67 2.09-2.31 2.48-1.15 2.54-1.11 1.88 1.97-0.37 1.72-1.11 3.67-1.66 4.34-1.41 1.76-5.25 1.53-7.22-0.44-2.1-2.1-4.39-7.35-3.68-8.5 0.76-1.24 0.9-9.5 0.15-9.5-0.34 0.01-0.94 1.66-1.34 3.69l-0.75 3.69-1.28-2.94c-2.26-5.12-1.79-7.33 1.97-8.9 1.85-0.78 3.66-1.86 4-2.41s1.54-1 2.65-1zm-133.62 1.19c0.06-0.03 0.17 0.01 0.25 0.09 0.32 0.33 0.34 1.17 0.06 1.88-0.31 0.78-0.52 0.55-0.56-0.6-0.03-0.78 0.05-1.3 0.25-1.37zm-76.28 0.28c0.36 0 0.35 0.46-0.25 1.44-0.36 0.57-1.63 1.54-2.82 2.15-2.05 1.07-2.05 0.97 0.22-1.5 1.28-1.38 2.38-2.09 2.85-2.09zm182.53 0.69c0.06-0.03 0.17 0.01 0.25 0.09 0.32 0.33 0.34 1.16 0.06 1.88-0.31 0.78-0.55 0.55-0.59-0.6-0.04-0.78 0.08-1.3 0.28-1.37zm-85.06 0.81c-0.89 0-1.99 5.88-1.32 6.97 0.94 1.51 1.21 1.03 1.6-3.03 0.2-2.17 0.07-3.94-0.28-3.94zm-71.16 0.47c-0.41 0.12-1.21 0.72-2.5 1.81-1.72 1.45-3.67 2.62-4.38 2.62-0.7 0-1.85 0.66-2.53 1.47-1.58 1.92-0.57 1.86 3.28-0.15 1.71-0.89 3.79-1.9 4.6-2.28 0.81-0.39 1.65-1.52 1.84-2.5 0.15-0.74 0.1-1.1-0.31-0.97zm169.09 0.34c0.02-0.01 0.04-0.01 0.07 0 0.05 0.03 0.09 0.17 0.15 0.41 0.25 0.94 0.25 2.49 0 3.44-0.25 0.94-0.44 0.17-0.44-1.72 0-1.25 0.09-2.02 0.22-2.13zm-72.15 0.72c0.89 0.01 1.55 13.99 1 21.91-0.13 1.8 0.29 3.88 0.9 4.62 0.62 0.74 0.84 2.2 0.5 3.25-0.33 1.05-0.12 4.97 0.47 8.66s0.84 7.59 0.56 8.69c-0.76 3.05-5.5 9.12-5.5 7.06 0-0.94 0.61-1.94 1.35-2.22 1.56-0.6 4.21-7.95 3.22-8.94-1.9-1.9-6.69-0.97-9.75 1.91-4.03 3.78-8.89 4.92-15.57 3.65-2.84-0.53-5.31-1.12-5.5-1.31-0.77-0.78 0.98-3.56 2.25-3.56 0.76 0 1.38-0.49 1.38-1.06 0-0.6 0.84-0.8 1.97-0.44 1.56 0.5 1.83 0.3 1.31-1.06-0.4-1.05-0.28-1.45 0.34-1.07 0.56 0.35 2.03-0.47 3.29-1.81 2.94-3.13 4.08-3.09 2.87 0.09s-1.25 9.29-0.06 9.29c0.49 0 1.09-2.55 1.31-5.66 0.3-4.21 0.01-5.99-1.09-6.91-0.94-0.78-1.03-1.22-0.29-1.22 0.65 0.01 1.16-1.08 1.16-2.4s0.35-2.61 0.78-2.88c0.43-0.26 0.59 1.02 0.38 2.88-0.24 2.05 0.05 3.37 0.72 3.37 0.62 0 1.13-1.97 1.22-4.65 0.1-3.31 0.29-3.81 0.59-1.72 0.85 5.99 2.24 4.81 2.41-2.03 0.09-4.01 0.3-5.29 0.53-3.13 0.21 2.03 0.82 3.69 1.34 3.69 0.56 0 0.73-1.83 0.37-4.44-0.39-2.89-0.25-4.43 0.44-4.43 0.7 0 1.06 3.74 1.06 10.96 0.01 6.05 0.27 10.74 0.6 10.41s0.61-6.03 0.62-12.69c0.02-9.06 0.23-11 0.82-7.68 0.42 2.43 0.8 7.83 0.84 12.03 0.04 4.37 0.5 7.62 1.06 7.62 1.2 0 1.21-0.25 0-21.06-0.64-11.08-0.65-17.04 0-17.69 0.03-0.03 0.07-0.03 0.1-0.03zm192.96 0.59c0.16 0.04 0.42 0.39 0.85 1.13 0.57 0.99 0.85 1.99 0.62 2.22-0.69 0.69-1.75-0.78-1.71-2.44 0.01-0.64 0.09-0.94 0.24-0.91zm-161.18 0.19c0.35 0.02 0.56 0.43 0.56 1.06 0 0.85-0.43 1.53-0.97 1.53s-1-0.39-1-0.9 0.46-1.23 1-1.56c0.14-0.09 0.29-0.13 0.41-0.13zm64.47 0.63c-1.4 0-1.13 1.33 0.78 3.72 1.83 2.29 3.19 2.82 3.19 1.21-0.01-0.54-0.41-1-0.91-1-0.51 0-1.19-0.88-1.53-1.97-0.35-1.08-1.03-1.96-1.53-1.96zm-258.19 0.31c0.07-0.06 0.236 0.03 0.437 0.15 1.037 0.65 9.384 17.59 10.434 21.19 0.4 1.36 1.17 3.03 1.72 3.72s0.78 1.47 0.5 1.75c-0.27 0.28-1.17-0.97-2-2.75s-3.44-7.19-5.78-12.06c-4.448-9.25-5.616-11.75-5.311-12zm67.811 1.09c-0.13 0.06 0.07 0.66 0.47 1.72 0.54 1.45 1.54 3.54 2.22 4.63 0.68 1.08 1.6 1.73 2.03 1.47 1.26-0.78 0.87-1.63-2.28-5.29-1.54-1.78-2.26-2.6-2.44-2.53zm100.5 0.06 0.72 11.82c0.39 6.49 1.13 15.36 1.66 19.68 1.87 15.48 1.96 17.34 0.97 16.72-0.54-0.33-0.97-2.1-0.97-3.93s-0.38-3.56-0.85-3.85c-0.46-0.28-0.65 3.77-0.44 9.03 0.55 13.44 1.29 20 2.26 19.41 0.45-0.28 0.71-1.64 0.56-3.03s0.05-2.16 0.47-1.72c0.41 0.44 0.9 2.9 1.09 5.47 0.37 4.95-0.11 5.66-2.19 3.16-0.7-0.86-2.92-2.41-4.93-3.44-4.1-2.09-5.48-5.59-4.32-11.03 1.48-6.91 4.41-7.04 4.41-0.22 0 2.37 0.43 4.57 0.97 4.9 1.18 0.74 1.19 0.24 0.03-14.75-1.17-15.14-1.22-28.2-0.22-39.34l0.78-8.88zm-125.12 0.5c1.13 0 0.52 1.8-3.85 11.66l-3.62 8.22 1.78 4.06c0.97 2.25 2.71 5.44 3.87 7.06 2.41 3.35 3.65 7.38 2.32 7.38-0.49 0-0.88-0.74-0.88-1.66 0-1.72-4.66-7.22-6.12-7.22-0.46 0 0.04 1.24 1.09 2.72 3.31 4.69 3.42 6.71 0.5 9-3.86 3.04-4.67 2.64-3.94-1.93 0.57-3.52 0.29-4.5-2.44-7.94-2.88-3.64-3.07-4.32-2.59-9.66 0.36-4 1.31-6.89 3.13-9.53 2.56-3.71 2.6-3.73 1.93-0.84-0.37 1.62-1.1 3.73-1.59 4.68-0.55 1.07-0.49 2.39 0.12 3.44 0.9 1.53 0.98 1.51 1-0.4 0.02-1.18 0.73-3.38 1.54-4.91s2.15-4.36 3-6.25c2.59-5.82 3.85-7.88 4.75-7.88zm41.9 0c-0.54 0-0.97 0.46-0.97 1 0 0.55 0.43 0.97 0.97 0.97s1-0.42 1-0.97c0-0.54-0.46-1-1-1zm25.69 0c0.49 0 0.88 0.89 0.88 1.97 0 1.09-0.17 1.97-0.38 1.97s-0.59-0.88-0.88-1.97c-0.28-1.08-0.11-1.97 0.38-1.97zm247.38 2.13c0.28-0.07 0.69 0.42 1 1.22 0.35 0.91 0.42 1.88 0.15 2.15-0.27 0.28-0.8-0.24-1.15-1.15-0.36-0.91-0.37-1.89-0.1-2.16 0.04-0.03 0.05-0.05 0.1-0.06zm-130.82 0.19c-0.32 0.12-0.59 1.8-0.59 4.09 0 2.62 0.18 4.54 0.41 4.31 0.76-0.78 1.01-7.67 0.31-8.37-0.05-0.05-0.08-0.05-0.13-0.03zm-164.94 0.9c-0.34 0.01-0.68 0.09-1 0.28-0.75 0.47-0.68 0.95 0.26 1.54 1.75 1.11 2.78 1.08 2.78-0.07 0-1.02-1-1.76-2.04-1.75zm293.1 1.22 0.06 2.82c0.04 1.61-0.68 3.41-1.66 4.15-2.29 1.74-4.18 1.72-4.18-0.06 0-0.8 0.57-1.21 1.28-0.94 0.75 0.29 1.97-0.86 2.9-2.75l1.6-3.22zm-356 0.1c1.016 0.04 1.64 0.71 2.5 2.37 1.871 3.61 1.851 6.75-0.031 7.47-0.812 0.31-1.469 1.13-1.469 1.75s-1.03 2.21-2.281 3.56c-1.252 1.35-2.743 3.33-3.344 4.41-0.965 1.72-1.125 1.49-1.406-1.97-0.247-3.03-0.699-3.87-1.969-3.66-0.906 0.15-1.938-0.16-2.281-0.71-0.344-0.56-1.91-1.04-3.469-1.04s-3.061-0.35-3.344-0.81c-1.13-1.83 10.041-9.71 15.906-11.22 0.44-0.11 0.849-0.17 1.188-0.15zm19.311 0.31c0.37 0.01 0.43 0.69-0.06 2.28-0.38 1.22-0.93 3.22-1.22 4.44-0.29 1.21-0.9 2.22-1.37 2.22-0.48 0-0.91 0.65-0.91 1.47 0 0.81-0.43 1.46-0.97 1.46-1.46 0-1.22-1.55 1.09-6.93 1.31-3.03 2.82-4.95 3.44-4.94zm181.38 0.06c1.46 0 1.18 3.55-0.38 4.85-0.75 0.61-1.6 2.33-1.91 3.81-0.53 2.59-3.53 7.44-3.59 5.81-0.02-0.44 1.09-3.23 2.44-6.19 1.35-2.95 2.47-6.01 2.47-6.81s0.43-1.47 0.97-1.47zm-35.19 0.5 0.87 3.85c0.91 3.86 0.81 5.08-0.4 3.87-0.36-0.36-0.65-2.25-0.6-4.19l0.13-3.53zm-71.91 0.09c0.07-0.01 0.15-0.01 0.19 0.04 0.34 0.34-0.66 2.48-2.22 4.75-3.2 4.65-5.97 7.27-5.97 5.65 0-0.58 0.67-1.41 1.44-1.84s2.44-2.7 3.75-5c1.14-2.01 2.31-3.48 2.81-3.6zm238.66 0.41c2.74 0.01 3.32 0.26 2.22 0.97-1.94 1.25-5.91 1.25-5.91 0 0-0.54 1.66-0.98 3.69-0.97zm-80 1.35c0.35 0 0.59 0.36 0.59 0.96 0 0.8 0.54 1.63 1.19 1.85 0.92 0.3 0.92 0.55 0 1.12-0.65 0.4-1.19 0.23-1.19-0.37 0-0.61-0.46-0.81-1-0.47-0.54 0.33-0.97-0.06-0.97-0.88 0-0.81 0.43-1.76 0.97-2.09 0.14-0.08 0.29-0.13 0.41-0.12zm92.47 0.12c0.02-0.01 0.04-0.01 0.06 0 0.11 0.05 0.24 0.34 0.34 0.84 0.22 1.01-0.07 2.26-0.59 2.78-0.62 0.62-0.74-0.04-0.37-1.84 0.22-1.12 0.4-1.7 0.56-1.78zm-233.1 0.34c0.35-0.05 0.73 0.47 1.16 1.6 0.8 2.09-2.56 25.12-4.16 28.47-0.75 1.57-1.37 3.46-1.37 4.18 0 0.73-0.46 1.32-1 1.32-1.25 0-1.26-2.43-0.03-4.66 2-3.65 4.17-15.81 4.12-23.09-0.03-4.85 0.52-7.7 1.28-7.82zm70.75 0.25c-0.22-0.08-0.14 0.28 0.19 1.16 0.37 0.97 0.92 1.55 1.22 1.25s0.02-1.11-0.66-1.78c-0.36-0.36-0.61-0.58-0.75-0.63zm-125.5 0.16c-0.32 0-0.61 0.01-0.87 0.03-5.95 0.56-5.74 1.69 0.31 1.69 3.55 0 5.86 0.48 6.63 1.41 0.8 0.96 3.08 1.4 7.09 1.34 3.35-0.05 5.49-0.45 5-0.94-1.31-1.31-13.27-3.57-18.16-3.53zm217.29 0.72c-0.71 0.01-0.58 0.43 0.31 1 1.89 1.22 2.22 1.22 1.47 0-0.34-0.54-1.14-1.01-1.78-1zm-93.94 0.12c-0.17 0.04-0.19 0.55-0.19 1.63 0 1.21 0.44 2.97 0.94 3.9 0.5 0.94 1.14 2.53 1.43 3.47 0.3 0.95 0.79 1.72 1.1 1.72 0.95 0-0.67-7.24-2.1-9.31-0.65-0.95-1.01-1.44-1.18-1.41zm179.62 0.03c0.18 0.01 0.39 0.01 0.6 0.04 1.79 0.25 2.11 1.05 2.37 5.65 0.17 2.95 0.06 6.38-0.25 7.63-0.31 1.24-1.07 2.28-1.66 2.28-0.58 0-0.76-0.7-0.43-1.56 1.46-3.8 1.72-6.32 0.69-6.32-0.6 0-1.09 1.23-1.1 2.72-0.01 2.02-0.26 2.35-0.94 1.28-0.54-0.86-0.52-2.08 0.04-3.12 0.5-0.94 0.87-3.21 0.81-5-0.07-2.07-0.33-2.53-0.63-1.28-0.8 3.32-1.91 3.69-1.44 0.47 0.32-2.13 0.72-2.81 1.94-2.79zm-26.34 0.97c0.44 0 0.88 0.09 1.22 0.22 0.67 0.28 0.13 0.47-1.22 0.47s-1.93-0.19-1.25-0.47c0.34-0.13 0.8-0.22 1.25-0.22zm-93 0.1c0.22-0.23 0.88 1.52 1.5 3.87 3.2 12.2 14.82 29.35 19.84 29.35 0.96 0 3.35 1.11 5.35 2.47l3.62 2.46h-4.44c-2.75 0-4.93-0.58-5.68-1.5-1.57-1.89-4.91-1.91-4.91-0.03 0 2.54 3.18 3.28 14.97 3.44 10.28 0.14 12.23-0.14 18.19-2.44 9.18-3.54 16.95-7.33 20.62-10.06 1.7-1.26 4.04-2.46 5.22-2.69s3.11-0.71 4.28-1.06c1.63-0.48 1.32 0.1-1.31 2.41-1.89 1.65-3.99 2.8-4.69 2.56s-1.55 0.34-1.9 1.28c-0.73 1.9-4.2 5.04-5.6 5.09-0.5 0.02-1.61 0.65-2.47 1.41-2.16 1.91-13.45 7.73-18.78 9.69-2.43 0.89-7.07 2.08-10.28 2.65-7.82 1.4-9.13 1.39-7.63-0.12 2.07-2.06 1.33-2.47-5.71-3.13-5.22-0.48-7.8-1.3-10.75-3.34-2.15-1.48-3.95-3.08-3.97-3.56s-1.08-1.83-2.35-3c-2.51-2.33-4.44-11.38-2.43-11.38 0.59 0 0.84-0.88 0.56-1.97-0.28-1.08-0.15-1.97 0.34-1.97 0.49 0.01 0.91 0.69 0.91 1.54 0 0.84 1.11 3.95 2.47 6.9 1.35 2.96 2.43 5.75 2.43 6.19 0 1 3.47 5.03 4.32 5.03 1.33 0 0.51-2.3-1.82-5.06-1.33-1.59-2.92-4.73-3.53-7-0.6-2.28-1.5-4.65-2-5.25-0.49-0.6-1.32-4.38-1.84-8.38-0.52-3.99-1.39-8.76-1.94-10.62s-0.82-3.56-0.59-3.78zm-153.16 0.31c0.05 0 0.1 0 0.13 0.03 0.26 0.26-0.31 1.22-1.28 2.16-1.7 1.62-1.75 1.6-0.5-0.47 0.62-1.04 1.32-1.73 1.65-1.72zm253.75 0.56c0.36-0.11 0.35 0.31 0.16 1.32-0.2 1.02-0.92 2.02-1.59 2.24-1.76 0.59-1.54-1.22 0.34-2.78 0.51-0.42 0.88-0.71 1.09-0.78zm-282.69 1c-0.83 0.08-1.69 0.94-1.81 2.56-0.11 1.55 0.4 2.22 1.66 2.22 1.28 0 1.78-0.7 1.78-2.5 0-1.61-0.79-2.35-1.63-2.28zm-28.71 0.85c0.4 0 0.24 1.46-0.35 3.21-1.6 4.81-2.66 5.41-1.44 0.82 0.59-2.21 1.39-4.03 1.79-4.03zm249.78 1.09c-0.76 0.01-0.93 0.26-0.63 0.75 0.38 0.61 2.09 1.16 3.82 1.22 1.72 0.05 4.24 0.44 5.59 0.87 3.37 1.08 9.84 1.19 9.84 0.16 0-0.46-3-1.14-6.65-1.5-3.66-0.36-8.14-0.92-9.97-1.25-0.89-0.16-1.55-0.26-2-0.25zm-187.72 0.03c0.48 0 0.17 0.79-0.85 2.19-1.02 1.41-2.24 2.54-2.71 2.56-1.22 0.05 1.76-4.17 3.31-4.69 0.1-0.03 0.18-0.06 0.25-0.06zm177.91 0.13c0.03-0.06 0.56 0.17 1.62 0.68 1.22 0.59 2.22 1.28 2.22 1.54 0 0.75-0.53 0.54-2.53-1.07-0.92-0.73-1.35-1.09-1.31-1.15zm-206.19 0.4c-1.63 0.03-1.88 0.6-0.81 1.66 0.9 0.91 3.51 0.77 5.12-0.25 0.93-0.59 0.25-0.99-2.22-1.28-0.85-0.1-1.55-0.14-2.09-0.13zm-59.5 1.32c1.84 0 4.95 3.68 5.5 6.5 0.48 2.52 0.06 3.59-2.41 6.12-1.65 1.69-3.3 4.66-3.66 6.56-0.35 1.9-1.014 3.44-1.495 3.44s-0.906 1.31-0.906 2.94c0 2.26-0.441 2.97-1.907 2.97-2.482 0-3.336-1.5-3.968-6.91-0.487-4.17-0.687-4.41-3.594-4.5-6.712-0.21-8.173-2.99-3.781-7.16 3.048-2.89 3.216-1.59 0.219 1.66l-2.219 2.38 2.469-0.72c1.352-0.41 3.003-1.17 3.656-1.69 0.652-0.52 1.573-0.72 2.031-0.44 1.313 0.81 7.917-5.8 8.625-8.62 0.35-1.4 1.02-2.53 1.44-2.53zm181.97 0c-0.54 0-0.97 0.42-0.97 0.96s0.43 1 0.97 1 1-0.46 1-1-0.46-0.96-1-0.96zm168.37 0c0.5 0 0.43 0.88-0.15 1.96-0.58 1.09-1.21 1.97-1.41 1.97s-0.13-0.88 0.15-1.97c0.29-1.08 0.91-1.96 1.41-1.96zm-92.69 0.43c1.81 0 3.56 0.65 4.94 2.03 1.28 1.29 1.24 1.48-0.47 1.57-1.06 0.05-0.24 0.48 1.81 0.97 2.06 0.48 6.27 2.07 9.35 3.53l5.59 2.65-5.65 1.69c-4.13 1.22-6.65 1.41-9.35 0.78-4.8-1.11-5.42-1.09-4.68 0.09 0.33 0.55 1.92 1 3.53 1 2.57 0.01 2.86 0.3 2.47 2.47-0.4 2.16-0.11 2.44 2.37 2.44 3.25 0 4.84-1.57 2.25-2.25-1.08-0.28-0.75-0.49 0.94-0.56 1.58-0.07 2.72-0.68 2.72-1.47s1.51-1.58 3.68-1.94c5.67-0.93 20.87-0.72 25.82 0.38 6.79 1.51 7.4 1.82 6.12 3.09-0.82 0.82-1.47 0.83-2.47 0-1.82-1.51-14.68-3.28-19.19-2.62-2 0.29-5.16 0.7-7.03 0.87-4.56 0.43-4.94 2.21-0.56 2.72 2.82 0.33 3.42 0.12 2.97-1.06-0.41-1.07-0.02-0.95 1.44 0.37 1.95 1.77 2 1.76 2.03-0.06 0.03-1.83 0.06-1.83 1.47 0.03 0.79 1.05 1.44 1.33 1.44 0.66 0-0.68 0.52-0.91 1.12-0.53 0.6 0.37 1.47 0.05 1.94-0.69 0.72-1.15 0.86-1.14 0.87 0 0.01 1.04 0.32 1.1 1.38 0.22s1.75-0.78 2.97 0.43c0.87 0.87 1.56 1.08 1.56 0.5 0-0.57 0.66-1.03 1.47-1.03s1.47 0.47 1.47 1.07 0.73 0.83 1.59 0.5 1.97-0.33 2.5 0c1.84 1.13-11.36 7.02-16.19 7.22-1.08 0.04-1.52 0.52-1.09 1.21 0.5 0.82-0.43 0.97-3.41 0.57-3.66-0.49-4-0.39-2.87 0.96 1.11 1.34 0.95 1.43-1.19 0.76-1.35-0.43-3.13-0.99-3.94-1.29-1.26-0.46-1.25-0.33-0.09 1.1 2.61 3.21-4.73 1.96-10.66-1.81-2.95-1.88-5.95-3.41-6.69-3.41-0.73 0-1.04-0.45-0.68-1.03s-0.29-1.96-1.44-3.03-3.44-4.77-5.12-8.22l-3.1-6.28 2.84-2.53c1.55-1.39 3.42-2.06 5.22-2.07zm-240.25 0.22c1.91 0.01 3.25 2.54 3.25 7.09 0 2.56-0.53 5.2-1.18 5.85-1.77 1.76-3.45 1.41-5.16-1.03-1.59-2.28-2.03-7.42-0.78-9.13 1.39-1.89 2.73-2.79 3.87-2.78zm50.66 1.69c-0.07 0.02-0.12 0.05-0.19 0.09-0.54 0.34-1 1.06-1 1.57 0 0.5 0.46 0.9 1 0.9s0.97-0.69 0.97-1.53c0-0.63-0.24-1.02-0.59-1.03-0.06 0-0.12-0.02-0.19 0zm12.87 0.06c0.29-0.12 0.23 0.59-0.03 2.34-0.25 1.71-0.86 3.13-1.34 3.13-1.3 0-1.07-2.34 0.44-4.41 0.45-0.61 0.77-0.99 0.93-1.06zm193.6 0.66c0.34-0.02 0.71 0.04 1.06 0.18 0.79 0.32 0.58 0.55-0.56 0.6-1.04 0.04-1.64-0.17-1.31-0.5 0.16-0.16 0.47-0.27 0.81-0.28zm18.59 1.97c0.63 0 1.25 0.06 1.72 0.18 0.95 0.25 0.18 0.47-1.72 0.47-1.89 0-2.66-0.22-1.72-0.47 0.48-0.12 1.1-0.18 1.72-0.18zm-289.65 0.21c-1.45 0.11-8.41 5.58-8.41 6.76 0 1.09 5.52-2.06 7.63-4.38 0.86-0.95 1.32-1.99 1-2.31-0.05-0.05-0.13-0.07-0.22-0.07zm342.46 0.94c2.02-0.1 4.19 0.61 6.72 2.1 3.23 1.88 4.41 3.24 4.41 4.87 0 3.19-1 3.83-3.09 1.94-2.6-2.35-3.46-0.79-1.44 2.62 1.46 2.48 1.48 2.81 0.19 2.32-0.84-0.33-1.57-0.06-1.57 0.56 0 0.61 0.71 1.37 1.54 1.69 1.1 0.42 1.21 0.9 0.43 1.84-0.75 0.91-0.77 1.46 0 1.94 0.72 0.44 0.78 1.06 0.13 1.84-0.61 0.73-0.63 1.73-0.06 2.63 0.5 0.79 0.9 2.75 0.9 4.37 0 2.71-0.2 2.53-2.56-2.22-1.42-2.84-2.96-5.15-3.44-5.15s-0.35 1 0.28 2.21c2.45 4.73 2.78 5.71 2.78 7.57 0 1.05 0.46 2.19 1 2.53 1.24 0.76 1.32 4.4 0.1 4.4-0.5 0.01-1.5 0.19-2.22 0.41-1.61 0.5-5.58-0.66-8.47-2.47-1.75-1.09-2.77-1.11-5.31-0.15-1.74 0.65-3.29 1.05-3.47 0.87-0.57-0.57 5.01-5.76 7.06-6.56 1.9-0.74 1.93-0.78 0.13-1.5-1.27-0.51-2.26-0.2-3.07 0.9-2.9 3.98-4.43 0.26-4.43-10.84 0-7.14 0.66-8.81 5.75-14.22 2.74-2.91 5.13-4.37 7.71-4.5zm-306.18 0.03c-0.12 0.03-0.27 0.08-0.41 0.16-0.54 0.33-1 1.08-1 1.63 0 0.54 0.46 0.67 1 0.34 0.54-0.34 0.97-1.05 0.97-1.6 0-0.4-0.21-0.59-0.56-0.53zm158.75 0.66c0.43 0 0.77 1.18 0.75 2.63-0.03 1.44-0.68 2.83-1.44 3.09-0.97 0.32-1.21-0.03-0.75-1.22 0.36-0.93 0.66-2.36 0.66-3.13 0-0.76 0.35-1.37 0.78-1.37zm113.75 0.13c0.44 0 0.56 0.29 0.56 0.74 0 0.47-1.9 1.56-4.22 2.44-6.29 2.4-7.83 1.79-2.19-0.87 3.44-1.62 5.1-2.32 5.85-2.31zm-131.32 0.87c-0.57 0-0.77 0.43-0.43 0.97 0.33 0.54 0.79 1 1.03 1s0.44-0.46 0.44-1-0.46-0.97-1.04-0.97zm77.47 0c-3.22-0.03-0.78 1.66 3.5 2.44 2.32 0.42 4.5 0.73 4.91 0.65s0.75 0.28 0.75 0.82 0.25 1 0.56 1c0.32 0 0.42-0.47 0.22-1.07-0.4-1.2-7.14-3.82-9.94-3.84zm43.85 0.13c0.52 0 0.72 0.26 0.72 0.84 0 0.54-1.23 0.97-2.72 0.94-2.4-0.07-2.46-0.19-0.72-0.94 1.34-0.58 2.19-0.84 2.72-0.84zm-11.1 0.96c0.45 0 0.92 0.09 1.25 0.22 0.68 0.28 0.11 0.5-1.25 0.5-1.35 0-1.89-0.22-1.22-0.5 0.34-0.13 0.78-0.22 1.22-0.22zm-117.65 0.07c0.06-0.03 0.13 0.01 0.22 0.09 0.32 0.33 0.34 1.16 0.06 1.88-0.32 0.78-0.52 0.55-0.56-0.6-0.04-0.78 0.08-1.3 0.28-1.37zm141.93 0.15c0.28 0 0.54 0.18 0.76 0.53 0.34 0.57-0.7 1.7-2.32 2.53-3.63 1.89-4.03 1.88-4.03 0.04 0-0.82 0.81-1.47 1.78-1.47 0.98 0 2.26-0.48 2.85-1.07 0.36-0.36 0.69-0.55 0.96-0.56zm-227.34 1.28c0.79 0.02 0.93 2.74 0.63 11-0.23 6.3-0.78 11.93-1.19 12.47-0.42 0.54-1.05 2.37-1.41 4.07-0.36 1.69-1.76 4.12-3.15 5.4-4.08 3.77-7.23 9.39-7.88 14.13-0.65 4.76 0.29 5.62 3.13 2.78 1.38-1.39 2.28-1.48 5.59-0.6 3.21 0.86 4.47 0.73 6.72-0.56 2.86-1.64 5.84-6.71 5.84-9.91 0-2.42 1-2.61 11.1-2.21l8.59 0.34v5.87 5.85l-3.69-0.66c-2.03-0.37-3.91-1.01-4.18-1.4-0.28-0.39-1.52-1.05-2.79-1.44-1.7-0.53-2.79-0.13-4.25 1.44-1.08 1.16-4.35 3.14-7.28 4.43-2.93 1.3-5.34 2.74-5.34 3.22s-1.12 1.47-2.47 2.19-2.47 1.72-2.47 2.19-0.87 1.79-1.94 2.94c-1.06 1.14-2.28 3.88-2.72 6.09-0.61 3.15-1.3 4.09-3.06 4.34-1.23 0.18-2.45 0.95-2.75 1.72-0.68 1.78-1.75 1.7-7.09-0.47-5.02-2.03-7.22-4.5-6.81-7.81 0.22-1.85 1.29-2.68 4.97-3.84 2.56-0.82 4.65-2.07 4.65-2.75 0-0.69 0.5-1.41 1.06-1.6 0.67-0.22 0.49-1.61-0.5-3.97-0.9-2.16-1.32-5.01-1-7.03 0.61-3.84-0.52-5.02-3.97-4.15-1.74 0.43-2.45 1.5-2.93 4.28-0.36 2.03-1.65 4.94-2.91 6.5-2.14 2.65-2.39 2.73-3.28 1-0.66-1.28-0.47-3.45 0.59-6.97 1.72-5.71 4.78-8.04 13.19-10.16 2.57-0.64 4.66-1.58 4.66-2.06s0.69-0.88 1.5-0.88c0.81 0.01 1.47-0.36 1.47-0.84s0.94-1.14 2.06-1.44c1.12-0.29 2.24-1.44 2.53-2.56s1.02-2.03 1.56-2.03 0.72-0.89 0.44-1.97-0.13-1.74 0.31-1.47c1.56 0.97 2.87-5.97 2.47-13.09-0.43-7.66-0.08-9.6 1.84-10.34 0.06-0.03 0.11-0.04 0.16-0.04zm255.63 0.41c-0.48 0.04-1.31 0.38-2.82 1.06-1.37 0.63-2.53 1.48-2.53 1.91 0 0.42 1.35 0.35 2.97-0.22s2.94-1.42 2.94-1.91c0-0.57-0.09-0.88-0.56-0.84zm-126.57 0.56c0.51-0.31 1.23 4.42 1.6 10.88 0.63 11.05 0.38 14.18-0.75 10.43-1.05-3.46-1.74-20.76-0.85-21.31zm138 0.35c-0.2-0.02-0.4 0.06-0.62 0.28-0.33 0.32-0.27 1.12 0.16 1.81 0.61 1 0.85 1 1.18 0 0.36-1.07-0.1-2.03-0.72-2.09zm-36.34 0.5c0.53-0.06 0.88 0.13 0.88 0.53 0 0.52-0.66 0.93-1.47 0.93-0.82 0-1.47-0.16-1.47-0.37s0.65-0.66 1.47-0.97c0.2-0.08 0.41-0.1 0.59-0.12zm-240.31 0.5c0.12 0 0.15 0.31 0.12 0.96-0.03 0.82-0.47 2.39-0.93 3.47-0.85 1.97-0.83 1.97-0.88 0-0.03-1.08 0.35-2.65 0.88-3.47 0.42-0.65 0.68-0.96 0.81-0.96zm-29.07 1.37c-0.15 0.01-0.37 0.08-0.65 0.19-0.78 0.3-1.64 1.17-1.94 1.94-0.82 2.13 1.16 1.68 2.35-0.54 0.62-1.17 0.71-1.62 0.24-1.59zm145.91 0.06c0.03-0.01 0.06 0 0.09 0 0.18 0.03 0.45 0.24 0.88 0.6 0.77 0.64 1.41 1.55 1.41 2.03 0 1.71-1.74 0.79-2.25-1.19-0.24-0.91-0.31-1.36-0.13-1.44zm-170.97 0.19 2.66 2.88c2.26 2.43 2.55 3.41 2.03 6.65-0.57 3.57-2.58 6.19-6.66 8.57-1.35 0.78-1.58 0.67-1.12-0.54 0.49-1.28 0.11-1.25-2.47 0.22-2.01 1.14-2.59 1.86-1.62 2.06 0.8 0.18 1.5 0.63 1.5 1 0 1.26-3.85 3.1-5.32 2.54-0.8-0.31-2.27-0.14-3.25 0.43-1.59 0.93-1.51 1.07 0.66 1.1 2.3 0.03 2.34 0.12 0.72 1.75-0.94 0.94-2.48 1.71-3.41 1.72-0.93 0-1.72 0.68-1.72 1.53 0 1.96-3.11 5.18-4.31 4.43-0.5-0.3-2.17-0.07-3.688 0.5-1.688 0.65-2.31 1.3-1.624 1.72 0.806 0.5 0.616 2.11-0.688 5.82-2.386 6.77-6.636 12.56-10.625 14.46-1.777 0.86-3.366 1.54-3.531 1.54-0.66 0 0.625-21.17 1.312-21.63 0.406-0.27 1.029-1.61 1.375-2.97 0.551-2.15 17.349-20.65 18.749-20.65 0.29 0 2.81-2.15 5.56-4.79 3.26-3.1 6.83-5.4 10.22-6.56l5.25-1.78zm-15.53 0.44c0.53-0.03 1 0.5 1.41 1.56 0.42 1.1-0.38 2.55-2.38 4.38-3.36 3.07-3.98 1.7-1.47-3.16 0.96-1.84 1.76-2.75 2.44-2.78zm44.63 0.22c-0.48 0-1.19 0.37-1.85 1.03-1.73 1.73-0.88 2.12 1.44 0.65 0.8-0.5 1.18-1.19 0.81-1.56-0.09-0.09-0.24-0.12-0.4-0.12zm-48.91 0.09c0.21-0.04 0.34 0.03 0.34 0.22 0 0.5-0.88 1.67-1.97 2.59-1.08 0.93-1.96 1.33-1.96 0.88s0.88-1.65 1.96-2.63c0.68-0.61 1.28-0.98 1.63-1.06zm69.84 0.97c0.25 0.05 0.34 0.76 0.35 2.25 0.01 1.73-0.46 3.42-1 3.75-1.26 0.78-1.26-3.46 0-5.41 0.27-0.42 0.51-0.62 0.65-0.59zm5.63 0.44c0.29 0.11 0.14 3.1-0.56 7.09-0.62 3.49-1.49 6.74-1.94 7.25-1.12 1.28-1.05-2.04 0.12-5.78 0.53-1.66 1.25-4.26 1.57-5.81 0.35-1.75 0.58-2.59 0.75-2.72 0.02-0.02 0.04-0.04 0.06-0.03zm241.4 0.28c0.19 0.03 0.22 0.39 0.22 1.12 0 0.93-0.33 1.69-0.75 1.69-0.69 0-5.54 6.71-9.12 12.63-0.84 1.37-2.12 2.68-2.88 2.93-1.24 0.42 8.2-14.07 11.41-17.5 0.59-0.63 0.94-0.91 1.12-0.87zm-70.96 0.69c0.18-0.02 0.76 0.46 1.75 1.56 1.41 1.57 2.53 3 2.53 3.19 0 0.73-0.72 0.26-2.13-1.38-1.67-1.95-2.45-3.34-2.15-3.37zm-48.6 1.15c0.95 0 1.87 1.91 2.69 5.6 1.22 5.43 1.3 5.51 2.59 3.18 1.47-2.64 1.7-1.74 0.78 2.85-0.33 1.65-1.24 3.26-2.03 3.56-1.01 0.39-1.25 0.03-0.87-1.19 0.61-1.93-1.77-10.64-3.47-12.68-0.85-1.03-0.79-1.32 0.31-1.32zm156.56 0.19c0.07-0.02 0.14 0.01 0.22 0.09 0.33 0.33 0.35 1.17 0.07 1.88-0.32 0.78-0.52 0.55-0.57-0.6-0.03-0.77 0.08-1.3 0.28-1.37zm-120.5 0.78c-1.13 0-1.1 0.71 0.19 3.13 0.59 1.09 1.27 1.8 1.47 1.59 0.67-0.67-0.76-4.72-1.66-4.72zm-183.09 0.09c3.29 0.09 3.41 0.21 1.22 0.91-3.52 1.13-4.94 1.13-4.94 0 0-0.54 1.69-0.96 3.72-0.91zm270.72 0.79c0.35 0-0.47 1.24-2.63 4.15-2.16 2.93-4.67 6.63-5.59 8.25-2.18 3.85-6.08 9.28-8.75 12.13-1.67 1.78-1.84 2.42-0.81 3.06 0.91 0.57 0.98 1 0.22 1.47-0.6 0.37-1.1 0.17-1.1-0.47 0-0.82-0.48-0.77-1.68 0.19-1.6 1.26-1.61 1.18-0.16-1.13 5.33-8.49 5.3-8.46 9.03-13.28 1.26-1.62 3.49-4.94 5-7.37 1.51-2.44 3.91-5.28 5.28-6.32 0.63-0.46 1.03-0.69 1.19-0.68zm-99.31 0.12c-1.39 0-1.25 5.96 0.22 9.13 0.67 1.45 1.57 2.68 2 2.68 0.42 0.01 0.34-0.86-0.22-1.9-0.56-1.05-1.03-3.71-1.03-5.91s-0.43-4-0.97-4zm102.72 1.97c1.3 0 0.4 2.64-1.69 4.91-3.25 3.52-13.92 20.85-16.06 26.06-1.01 2.43-2.22 4.43-2.66 4.44-1.01 0 0.15-3.8 1.94-6.38 0.74-1.07 1.31-2.7 1.31-3.62 0-0.93 0.63-2.26 1.38-3 0.74-0.74 1.59-2.23 1.93-3.32 0.35-1.08 2.63-5.04 5.07-8.75 2.43-3.7 4.4-7.09 4.4-7.53 0-0.76 3.2-2.81 4.38-2.81zm30.43 0.41c0.15-0.04 0.36 0.14 0.63 0.56 0.52 0.81 0.96 2.27 0.97 3.22 0.01 0.94-0.43 1.72-0.97 1.72s-0.98-1.46-0.97-3.22c0.01-1.52 0.1-2.22 0.34-2.28zm-159.75 0.56c0.53 0 0.72 0.66 0.41 1.47s-0.76 1.5-0.97 1.5-0.4-0.69-0.4-1.5c-0.01-0.81 0.44-1.47 0.96-1.47zm141.35 1c-1.69 0-6.57 3.72-6.57 5.03 0.01 0.54 1.78 0 3.94-1.22 3.98-2.23 5.09-3.81 2.63-3.81zm9.19 0c-0.55 0-1 0.46-1 1.03-0.01 0.57 0.45 0.77 1 0.44 0.54-0.34 0.96-0.83 0.96-1.06 0-0.24-0.42-0.41-0.96-0.41zm-177.16 0.97c0.41 0 1.25 1.89 1.84 4.18 0.6 2.3 1.93 6.85 3 10.1 1.08 3.24 2.73 8.53 3.66 11.78 3.13 10.91 12.31 29.52 22.4 45.47 2.92 4.61 13.88 16.19 16.82 17.75 1.82 0.97 1.81 1.03-0.22 2.12-1.76 0.94-2.04 0.88-1.56-0.37 0.31-0.83 0.16-1.5-0.38-1.5-0.53 0-3.11-2.01-5.75-4.44-2.63-2.43-5.11-4.43-5.53-4.44-1.41-0.02 2.19 4.44 5.62 6.91 3.84 2.77 4.43 3.98 1.54 3.22-2.67-0.7-10.68-9.57-17.16-19-4.51-6.57-4.53-6.53-4.53-4.69 0 0.82 1.15 2.74 2.53 4.31 1.38 1.58 3.13 4.29 3.88 6.04 0.74 1.74 4.66 6.52 8.71 10.59 6.04 6.05 7.03 7.41 5.25 7.41-5.77 0-24.32-16.82-34.31-31.1-1.85-2.65-4.69-7.16-6.28-10s-3.25-5.15-3.69-5.16c-0.44 0-0.6 0.35-0.37 0.76 4.48 8.09 9.79 16.67 13.15 21.24 2.34 3.18 4.25 6.11 4.25 6.54 0 1.18 5.01 6.19 8.85 8.84 1.89 1.31 3.66 2.66 3.94 3 0.27 0.34 2.5 1.78 4.93 3.22 2.44 1.44 3.88 2.65 3.19 2.66-0.69 0-2.89-1.03-4.91-2.29-6.28-3.91-8.06-4.2-4.75-0.75 1.59 1.66 3.63 3.04 4.5 3.04 0.88 0 2.45 0.64 3.5 1.43 1.05 0.8 2.8 1.43 3.88 1.44 1.59 0.01 1.67-0.13 0.5-0.87-2.34-1.49-0.75-1.79 1.94-0.38 1.35 0.71 1.89 1.3 1.18 1.31-0.7 0.01-1.02 0.43-0.68 0.97 0.33 0.54 0.07 1-0.57 1-0.86 0-0.85 0.37 0.07 1.47 1.43 1.73 1.28 1.71-1.97-0.09-1.36-0.75-3.21-1.37-4.16-1.38s-1.72-0.46-1.72-1-0.52-0.97-1.12-0.97c-2.05 0-12.11-6.71-18.72-12.47-6.26-5.45-16.43-16.75-21.31-23.72-1.44-2.04-2.17-4.31-1.97-6.15 0.29-2.83 0.44-2.73 4.47 3.25 2.28 3.38 5.17 7.24 6.4 8.59 1.24 1.36 3.94 4.56 6 7.13 2.07 2.56 4.2 4.68 4.75 4.68 0.96 0-1.73-3.85-6.03-8.59-1.09-1.2-2-2.46-2-2.81s-2.2-3.43-4.9-6.88c-2.71-3.44-4.94-6.54-4.94-6.87 0-0.34-0.82-1.78-1.82-3.22-1.95-2.81-3.3-7.05-2.24-7.03 0.35 0 1.51 1.83 2.56 4.03 1.75 3.66 6.44 10.68 6.44 9.66-0.01-0.24-1.53-3.53-3.41-7.32-1.89-3.78-3.43-7.19-3.44-7.56-0.02-0.99 3.89-2.08 7.81-2.19 3.3-0.08 3.58 0.2 7.63 7.78 2.31 4.33 4.53 8.54 4.94 9.35 2.7 5.41 12.61 20.86 15.47 24.12 1.89 2.17 3.45 4.25 3.46 4.66 0.03 0.97 1.97 0.97 1.97 0 0-0.41-0.99-1.84-2.22-3.19-2.08-2.3-4.84-6.07-7.12-9.72-0.55-0.87-1.87-2.87-2.91-4.4-3.26-4.85-5.4-8.78-8.97-16.38-1.9-4.06-4.29-9.15-5.31-11.31-1.01-2.16-2.11-5.71-2.44-7.87l-0.59-3.94 2.44 4.94c1.35 2.7 2.48 5.67 2.5 6.62 0.03 1.63 2 2.59 2 0.97 0-0.42-1.58-4.52-3.5-9.06-1.92-4.55-3.31-9.17-3.1-10.29 0.31-1.6 0.56-1.36 1.16 1.16 0.42 1.76 1.15 3.22 1.63 3.22 1.1 0 1.1-1.51 0-3.69-1.53-3-2.93-6.6-3.44-8.93-0.41-1.88-0.22-2.06 0.94-1.1 1.78 1.48 1.74 1.28-0.54-6.94-1.04-3.78-1.54-6.9-1.12-6.9zm-60.28 3.94c3.13 0 2.95 0.68-1.06 4.59-3.29 3.19-7.44 4.4-7.44 2.19 0-1.94 6.08-6.78 8.5-6.78zm196.22 0c0.9 0-2.94 6.6-5.91 10.15-1.21 1.45-1.24 1.91-0.19 2.56 0.91 0.57 0.98 1.03 0.22 1.5-0.6 0.37-1.14 0.09-1.16-0.62-0.05-2.44-4.87 4.23-4.87 6.75 0 2 0.27 2.3 1.31 1.44 2.37-1.97 2.64 0.05 0.41 3.18-1.2 1.69-2.06 3.72-1.91 4.54 0.25 1.29 0.17 1.3-0.68 0.03-0.7-1.03-0.53-1.95 0.59-3.19 0.87-0.96 1.31-2.06 0.97-2.41-0.79-0.78-4.45 3.69-4.16 5.07 0.12 0.55 0.01 0.68-0.22 0.28-0.67-1.21-3.22-0.87-3.75 0.5-0.27 0.69-1.48 1.35-2.69 1.43l-2.15 0.13 2.22-1.81c1.22-1.01 2.8-2.01 3.47-2.25s0.95-0.69 0.68-0.97c-0.6-0.64-13.13 5.17-13.59 6.31-0.18 0.45-0.98 0.81-1.75 0.81s-3.27 0.87-5.56 1.94c-2.3 1.07-6.1 2.64-8.47 3.47-4.76 1.66-10.25 2.11-6.53 0.53 1.08-0.46 4.19-1.41 6.87-2.09 3.45-0.89 5.84-2.35 8.28-5 1.9-2.07 4.06-3.75 4.75-3.75 0.7 0 1.25-0.41 1.25-0.88s2.62-2 5.82-3.44c6.84-3.07 16.45-11.2 14.97-12.68-0.65-0.65-2.47-0.27-5.44 1.12-2.46 1.16-4.79 2.09-5.16 2.09-1.47 0.01-8.22 3.39-8.22 4.13 0 0.44-1.94 0.81-4.31 0.81s-5.96 0.69-7.97 1.53c-4.02 1.69-11.46 1.57-12.03-0.18-0.23-0.71 2.07-1.38 6.34-1.82 8.65-0.89 20.44-4.21 25.1-7.09 2.02-1.25 4.16-2.28 4.75-2.28s4.04-2.1 7.65-4.63c3.62-2.52 5.99-3.96 5.32-3.21-2.43 2.66-1.16 3.05 1.81 0.56 1.66-1.4 3.43-2.56 3.94-2.56zm-95.13 0.24c0.17 0 0.4 0.15 0.69 0.44 0.59 0.59 0.9 1.8 0.72 2.72-0.44 2.16-1.82 0.79-1.82-1.81 0.01-0.91 0.13-1.33 0.41-1.35zm-18.59 2c-0.07 0-0.12 0.03-0.16 0.07-0.3 0.3 0.39 1.83 1.53 3.43 1.14 1.61 2.07 3.41 2.07 4-0.01 0.6 0.22 1.07 0.5 1.07 0.27 0 0.5-0.54 0.5-1.22-0.01-1.62-3.47-7.2-4.44-7.35zm134.97 0.54c0.14 0.02 0.28 0.12 0.4 0.31 1.39 2.19 0.98 6.12-1.09 10.19-3 5.88-2.56 9.48 1.66 14.18 2.27 2.54 4.44 4 5.9 4 1.27 0 3.09 0.4 4.03 0.88s3.45 1.71 5.6 2.72c2.15 1 4.78 2.62 5.84 3.56s2.62 1.91 3.47 2.19c0.85 0.27 2.28 2.27 3.19 4.43 0.93 2.23 2.31 3.94 3.18 3.94 0.9 0 1.57 0.84 1.57 1.97 0 2.83-2.41 2.4-5.19-0.91-1.7-2.01-2.81-2.58-3.78-1.96-2.19 1.38-2.69 1.12-5.72-3.07-1.58-2.17-3.03-3.38-3.25-2.71-0.22 0.66-4.94-3.36-10.53-8.88l-10.19-10.03 0.56-6.69c0.57-6.74 2.8-13.8 4.22-14.09 0.05-0.01 0.08-0.04 0.13-0.03zm-215.63 0.68 0.63 6.41c0.34 3.51 0.46 6.52 0.25 6.75s-0.38-0.09-0.38-0.72c0-0.78-2.53-1.16-7.87-1.16-7.26 0.01-7.88-0.15-7.88-2 0-2.27 0.77-2.65 6.69-3.31 3.14-0.35 4.82-1.2 6.4-3.22l2.16-2.75zm-15.9 0.85c0.26 0 0.28 0.37 0.03 1.03-0.66 1.7-1.35 2.04-1.35 0.62 0-0.51 0.44-1.2 0.97-1.53 0.14-0.08 0.26-0.12 0.35-0.12zm54.34 0.22c0.02-0.01 0.06 0.02 0.09 0.06 0.45 0.62 0.98 10.23 1.16 21.37 0.18 11.15 0.06 20.28-0.25 20.28-0.32 0-0.6-4.16-0.6-9.21 0-5.06-0.21-14.67-0.53-21.38-0.29-6.29-0.25-11.07 0.13-11.12zm-79.84 0.37c0.33-0.01 0.56 0.23 0.56 0.88 0 0.47-0.61 1.39-1.38 2.03-1.14 0.95-1.28 0.78-0.84-0.88 0.32-1.23 1.1-2.01 1.66-2.03zm134.15 0.13c1.06-0.23 2.15 2.3 1.56 4.18-0.41 1.32-0.22 1.64 0.66 1.1 0.93-0.57 1.07-0.08 0.56 1.93-0.39 1.58-0.31 2.43 0.22 2.1 0.5-0.31 1.16 0.33 1.44 1.4 0.32 1.23 0.04 1.97-0.78 1.97-0.72 0-1.62-1.32-1.97-2.93s-1.13-2.81-1.75-2.69-1.32-0.79-1.5-2c-0.26-1.67 0.05-2.04 1.22-1.59 0.85 0.32 1.53 0.11 1.53-0.44 0-0.56-0.54-1.2-1.22-1.44s-0.87-0.85-0.44-1.31c0.15-0.16 0.32-0.25 0.47-0.28zm-131.91 0.28c0.16-0.1 0.19 0.33 0.22 1.19 0.05 1.13-0.82 2.86-1.9 3.84-1.12 1.01-1.94 1.27-1.94 0.62 0-0.62 0.41-1.12 0.91-1.12 0.49 0 1.33-1.23 1.87-2.72 0.41-1.13 0.69-1.72 0.84-1.81zm93.29 0.15c0.06 0.01 0.11 0.22 0.18 0.69 0.23 1.5 0.24 3.7 0 4.91-0.23 1.21-0.44 0.02-0.43-2.69 0-1.86 0.12-2.92 0.25-2.91zm-18.63 0.19c0.33-0.13 0.75 1.52 0.91 3.69 0.46 6.42 1.74 37.69 1.9 46.53 0.29 15.53-1.75 9.06-2.71-8.66-0.17-2.97-0.43-0.54-0.57 5.41-0.2 8.8-0.44 10.37-1.31 8.38-0.86-1.99-1.14-2.14-1.47-0.79-0.31 1.31-1.1 1.59-3.53 1.16-11.74-2.06-19.38-11.29-19.38-23.41 0-3.87 0.22-4.27 1.97-3.81 2.82 0.74 4.91-1.42 4.91-5.06 0-3.62 3.02-8.13 9.38-14 3.05-2.82 4.4-4.85 4.4-6.63 0-2.08 0.48-2.56 2.47-2.56 1.35 0 2.71-0.11 3.03-0.25zm212.06 1.69c1.15-0.04 1.99 4.83 1.25 7.78-0.5 1.99-0.28 2.59 0.94 2.59 1.88 0 2.1 1.53 0.35 2.35-0.99 0.46-0.99 0.73 0 1.18 0.67 0.32 1.24 0.91 1.24 1.35s-0.57 1.01-1.28 1.28c-2.3 0.89-4.94-15.06-2.72-16.44 0.08-0.05 0.15-0.09 0.22-0.09zm-55.72 0.94c0.1-0.03 0.21-0.02 0.29 0.06 0.3 0.3-0.02 1.11-0.69 1.78-0.97 0.96-1.07 0.84-0.53-0.56 0.27-0.73 0.64-1.21 0.93-1.28zm16.16 0.03c0.04 0 0.03 0.05 0.03 0.12 0.01 0.58-0.64 1.89-1.43 2.94-1.88 2.47-1.91 3.97-0.07 2.44 1.18-0.98 1.56-0.75 2.07 1.28 0.34 1.36 0.41 3.26 0.15 4.25-0.25 0.99-0.54 0.27-0.62-1.63l-0.13-3.43-1.5 2.72c-1.31 2.41-1.65 2.53-2.94 1.24-1.29-1.28-1.11-1.98 1.5-6.15 1.43-2.27 2.66-3.81 2.94-3.78zm31.78 0.72c0.18-0.07 0.44 0.13 0.85 0.53 0.6 0.6 0.92 1.59 0.71 2.22-0.48 1.46-1.81 0.14-1.81-1.82 0-0.55 0.08-0.87 0.25-0.93zm-284.53 0.81c0.54 0 0.97 0.2 0.97 0.44 0 0.23-0.43 0.69-0.97 1.03-0.54 0.33-1 0.13-1-0.44s0.46-1.03 1-1.03zm189.35 2.81-7.88 4.09c-4.33 2.26-8.3 4.48-8.84 4.91-2.1 1.65-8.18 2.44-15.25 1.97l-7.38-0.5-0.28-4.09-0.31-4.13 5.25-0.56c2.87-0.3 11.82-0.78 19.93-1.1l14.76-0.59zm-254.29 2.09c-0.54 0.01-0.97 0.46-0.97 1 0 0.55 0.43 0.97 0.97 0.97s0.97-0.42 0.97-0.97c0-0.54-0.43-1-0.97-1zm46.57 0.1c0.48-0.01 0.43 0.44-0.35 1.37-0.67 0.82-1.9 1.5-2.75 1.5-1.23 0-1.15-0.31 0.38-1.47 1.25-0.94 2.23-1.39 2.72-1.4zm287.4 0.06c0.98-0.09 2.45 0.2 4.44 0.81 2.42 0.75 2.39 0.8-1.22 2.38-4.1 1.8-7.41 2-9.59 0.62-1.17-0.74-1.23-1.18-0.25-2.15 0.92-0.93 1.22-0.93 1.22-0.03 0 0.65 0.88 1.18 1.96 1.18 1.1 0 1.97-0.68 1.97-1.5 0-0.78 0.49-1.22 1.47-1.31zm15.47 0.91c0.06-0.06 0.5 0.31 1.35 1.12 0.97 0.94 1.54 1.93 1.28 2.19s-1.07-0.49-1.78-1.69c-0.63-1.03-0.91-1.56-0.85-1.62zm-66.69 1c0.08-0.01 0.16-0.01 0.22 0 0.29 0.04 0.35 0.33 0.35 0.81 0 0.49-1.42 1.37-3.13 1.97-4.46 1.55-4.68 1.32-1.03-0.91 1.98-1.2 3.04-1.79 3.59-1.87zm-295 0.9c-0.712 0-1.551 0.69-1.875 1.53-0.325 0.85-0.989 1.31-1.438 1.04-0.783-0.49-4.125 2.7-4.125 3.93 0 0.33 0.632 0.12 1.375-0.5 0.743-0.61 2.021-0.84 2.844-0.53 1.001 0.39 1.993-0.45 3-2.47 1.191-2.38 1.244-3 0.219-3zm52.596 0.1c0.81 0-0.25 0.84-2.38 1.9-2.12 1.06-4.36 1.93-4.94 1.91-1.58-0.06 5.61-3.81 7.32-3.81zm303.87 0.12c0.61-0.06 1.27 0.34 2.47 1.13 1.39 0.91 2.53 2.29 2.53 3.09 0 1.65-1.55 1.95-2.47 0.47-0.33-0.54-2-0.97-3.72-0.97h-3.09l2.13-2.12c1.01-1.02 1.55-1.54 2.15-1.6zm-338.87 0.75c-0.24 0-0.44 0.46-0.44 1s0.49 0.97 1.06 0.97c0.58 0 0.77-0.43 0.44-0.97s-0.82-1-1.06-1zm306.31 0c0.12 0 0.13 0.35 0.09 1-0.04 0.81-0.47 2.59-0.9 3.94l-0.75 2.44-0.1-2.44c-0.04-1.35 0.32-3.13 0.85-3.94 0.42-0.65 0.69-1 0.81-1zm-108 0.78c0.01 0 0.05 0.02 0.06 0.04 1.52 1.8 2.86 9.32 2.28 12.9-0.64 4.03-2.23 5.47-2.53 2.28-0.42-4.57-0.27-15.1 0.19-15.22zm97.44 1.69-1.5 3.13c-1.79 3.69-1.88 4.25-0.57 4.25 0.55 0 1.06-0.78 1.1-1.72 0.04-0.95 0.3-1.23 0.56-0.6 0.26 0.64-1.14 3.23-3.06 5.75-1.93 2.52-3.5 3.94-3.5 3.13s0.5-1.67 1.12-1.88c0.99-0.33 1.43-1.82 1.75-6.28 0.05-0.61 0.99-2.16 2.1-3.43l2-2.35zm34.34 0.5c0.54 0 1 0.43 1 0.97s-0.46 1-1 1-0.97-0.46-0.97-1 0.43-0.97 0.97-0.97zm-305.47 0.13c0.5 0 0.43 0.26-0.47 0.84-0.81 0.52-2.12 0.94-2.93 0.91-0.98-0.04-0.8-0.35 0.5-0.91 1.35-0.58 2.4-0.84 2.9-0.84zm241.91 0.93c0.7-0.01 0.59 0.26 0.59 0.79 0 0.93-9.29 5.22-14.75 6.81-6.4 1.87-8.73 2.16-9.31 1.22-0.51-0.83 2.7-2.01 8.84-3.25 1.09-0.22-1.05-0.39-4.75-0.35-5.06 0.06-7-0.29-7.87-1.47-0.63-0.86-1.81-1.86-2.63-2.22-0.81-0.35 0.28-0.38 2.44-0.06 5.63 0.85 16.05 0.59 22.13-0.56 3.14-0.6 4.61-0.89 5.31-0.91zm-238.35 0.03c0.35-0.01 0.74 0.05 1.1 0.19 0.78 0.32 0.55 0.55-0.6 0.6-1.03 0.04-1.6-0.18-1.28-0.5 0.17-0.17 0.44-0.27 0.78-0.29zm-43.682 0.1c-0.224 0.07-0.569 1.04-1.032 2.97-0.385 1.6-0.22 2.72 0.375 2.72 0.552 0 0.969-1.38 0.969-3.1 0-1.79-0.089-2.66-0.312-2.59zm191.34 0c-0.12 0.04-0.19 0.17-0.19 0.4 0 0.56 0.33 1.33 0.69 1.69s0.85 0.41 1.13 0.13-0.02-1.02-0.66-1.66c-0.44-0.44-0.77-0.63-0.97-0.56zm-132.5 0.22c0.33-0.09 0.5 0.51 0.5 1.75 0 2.26-5.29 12.9-8.09 16.28-0.57 0.69-0.8 1.48-0.5 1.78 0.74 0.74 5.62-6.57 5.62-8.41 0-0.91 1.1-0.25 2.91 1.72 1.59 1.75 3.07 3.16 3.28 3.16 1.43 0 6.62-9.18 6.62-11.72 0-1.67 0.43-3.03 0.97-3.03s1.04 1.43 1.07 3.19c0.02 1.75 0.58 4.53 1.28 6.15 1.21 2.82 1.14 3.05-1.94 5.16-1.78 1.22-3.87 2.22-4.62 2.22-1.95 0-4.63 3.24-4.63 5.59 0 1.09 0.82 2.92 1.81 4.06 2.13 2.46 11.4 7.29 13.19 6.88 2.41-0.55 5.46 3.99 7.19 10.69l1.75 6.75-3 6.37c-1.65 3.51-4.03 8.84-5.28 11.81-3.06 7.28-5.25 9.58-12.22 12.91-6.5 3.11-10.28 3.48-14.75 1.44-1.63-0.75-4.94-2.26-7.38-3.38-2.43-1.11-6.21-2.69-8.37-3.47-7.55-2.72-15.25-6.51-15.25-7.5 0-0.54-0.54-0.99-1.22-1-1.4-0.01-10.45-10-12.31-13.59-0.68-1.3-1.22-2.93-1.22-3.59 0-0.67-0.686-2.62-1.534-4.32-2.095-4.2-1.472-7.91 1.754-10.31 2.6-1.93 2.75-1.94 4.68-0.19 1.1 0.99 1.97 2.62 1.97 3.6 0 3.78 8.96 16.59 11.6 16.59 0.52 0 2.02 0.83 3.31 1.85 3.13 2.44 7.51 3.13 24.65 3.9 7.94 0.36 14.73 1 15.13 1.41 1.46 1.47-1.74 8.18-4.94 10.37-5.13 3.52-9.12-0.02-4.62-4.09 2.35-2.13 5.21-2.17 4.4-0.06-0.39 1.03-0.83 1.19-1.28 0.47-0.45-0.73-1.23-0.46-2.37 0.81-2.36 2.6-0.45 3.55 3.28 1.62 3.34-1.72 4.85-5.68 3-7.9-1.57-1.89-2.44-1.86-5.06 0.25-8.8 7.04-10.11 12.15-4 15.56 3.62 2.02 3.73 2.03 8.5 0.28 6.4-2.34 8.26-4.11 6.31-6.06-1.15-1.15-1.78-1.2-3.13-0.22-2.31 1.69-2.08 2.78 0.32 1.5 1.08-0.58 1.96-0.69 1.96-0.25 0 1.11-6.76 4.64-7.5 3.91-0.33-0.34 1-2.45 2.91-4.69 1.92-2.24 3.85-5.69 4.31-7.66 0.76-3.18 1.22-3.57 4.25-3.81 6.71-0.53 7.45-1.71 2.94-4.72-1.62-1.08-2.97-2.5-2.97-3.19 0-0.68-0.5-2.23-1.12-3.43-0.63-1.21-1.46-2.91-1.85-3.72-0.73-1.52-3.14-1.63-10.31-0.57-9.77 1.45-9.77 1.43-10.31-2.59-0.27-2.02-1.25-4.57-2.19-5.66-2.03-2.35-6.85-2.64-8.97-0.53-1.63 1.64-3.62 1.96-3.62 0.6 0-0.49-1.11-1.15-2.5-1.5-1.89-0.48-3.71 0.15-7.07 2.37-2.48 1.64-4.74 2.76-5 2.5-0.25-0.25 0.96-2.34 2.66-4.66 12.92-17.61 15.25-21 22.63-32.59 2.5-3.93 4.03-4.31 2.03-0.5-2.08 3.97-8.17 12.92-10.5 15.44-1.23 1.33-2.25 2.79-2.25 3.25s-0.87 1.74-1.97 2.84c-1.93 1.93-1.84 4.56 0.12 3.35 0.85-0.53 4.41-5.61 7.28-10.47 0.56-0.93 2.86-4.38 5.16-7.66s4.19-6.34 4.19-6.78 0.98-1.63 2.15-2.66c2.47-2.15 2.33-1.92-4 8.44-2.47 4.06-4.86 7.54-5.28 7.72-0.41 0.18-0.75 0.79-0.75 1.34 0 0.56-1.11 2.3-2.47 3.91-1.35 1.61-2.46 3.31-2.46 3.81 0 2.05 1.66 0.66 4.4-3.75 1.6-2.57 3.17-4.88 3.5-5.15s2.19-3.13 4.13-6.38c9.06-15.21 8.87-14.91 8.22-11.97-0.34 1.54-1.74 4.49-3.07 6.6-1.33 2.1-2.4 4.11-2.4 4.47 0 0.35-2.15 3.57-4.78 7.15-4.69 6.38-7.04 10.17-7.04 11.44 0.01 2.51 14.47-19.13 17-25.44 1.6-3.96 2.61-5.95 3.16-6.09zm66.06 0.06 0.69 8.84c0.37 4.87 1.12 11.57 1.66 14.88 0.53 3.31 0.93 7.2 0.93 8.62 0 1.43-0.42 2.57-0.96 2.57s-1-1.52-1-3.38-0.45-3.69-1-4.03c-0.56-0.34-0.92-1.11-0.82-1.75 0.11-0.64-0.11-4.05-0.5-7.56-0.38-3.52-0.31-9.04 0.16-12.28l0.84-5.91zm-83.56 0.62c0.42-0.01 0.02 0.37-1.12 1.29-1.05 0.84-2.56 1.53-3.38 1.53-2.08 0-0.22-1.6 2.81-2.41 0.89-0.23 1.44-0.4 1.69-0.41zm315.75 0.85c0.65-0.01 1.45 0.46 1.78 1 0.76 1.22 0.42 1.22-1.47 0-0.88-0.57-1.01-0.99-0.31-1zm-12.06 1c0.84 0 1.56 0.43 1.56 0.97s-0.43 0.97-0.94 0.97-1.19-0.43-1.53-0.97c-0.33-0.54 0.07-0.97 0.91-0.97zm25.31 0.44c0.08-0.01 0.18 0.01 0.31 0.03 0.53 0.08 1.32 1.86 1.75 3.97 0.44 2.11 0.63 4.51 0.41 5.34-0.36 1.31-0.45 1.32-0.66 0.03-0.12-0.81-0.13-2.06-0.03-2.81 0.13-0.94-0.36-1.16-1.59-0.69-1.44 0.55-1.58 0.4-0.59-0.59 1.35-1.37 1.65-4.36 0.5-5-0.31-0.17-0.33-0.28-0.1-0.28zm-363 0.56c-1.34 0.03-1.32 0.25 0.28 1.47 2.49 1.88 4.1 1.86 2.53-0.03-0.67-0.82-1.93-1.46-2.81-1.44zm157.81 0c0.05 0 0.11 0.1 0.16 0.28 0.33 1.27 1.2 1.69 3.06 1.47 2.21-0.26 2.68 0.11 2.94 2.34 0.24 2.11-0.3 2.97-2.66 4.19-1.63 0.84-3.2 1.53-3.5 1.53-0.29 0-0.5-2.54-0.43-5.66 0.05-2.52 0.23-4.16 0.43-4.15zm164.94 0.31c0.87-0.03 4.86 3.46 11.35 10.13 8.87 9.12 11.77 11.44 18.06 14.47 4.11 1.97 8.43 3.59 9.59 3.59 1.2 0 2.09 0.61 2.09 1.44 0 0.88-0.6 1.25-1.5 0.9-2.07-0.79-1.93 2.94 0.19 5.07 0.92 0.91 2.92 2.12 4.44 2.65 1.72 0.6 2.75 1.65 2.75 2.81 0 1.03-0.2 1.88-0.47 1.88s-0.5-0.43-0.5-0.97-0.47-1-1.03-1c-1.08 0-2.54-1.05-6.44-4.63-1.3-1.19-2.37-1.73-2.37-1.18s-0.54 0.67-1.22 0.25-2.12-0.9-3.19-1.07c-4.52-0.7-16.98-11.34-22.19-18.93-2.84-4.15-3.87-5.46-6.12-7.94-0.95-1.04-1.43-1.91-1.09-1.91 0.33 0-0.15-1.16-1.07-2.56-1.32-2.02-1.74-2.98-1.28-3zm-82 0.03c0.19 0.03 0.39 0.22 0.56 0.5 0.38 0.61 0.14 1.1-0.5 1.1-0.86 0-0.85 0.37 0.07 1.47 0.77 0.93 0.84 1.46 0.18 1.46-1.65 0-2.36-1.8-1.37-3.56 0.31-0.55 0.61-0.85 0.87-0.94 0.07-0.02 0.13-0.04 0.19-0.03zm-116.31 0.03c0.05-0.01 0.1-0.01 0.16 0 0.06 0.02 0.11 0.06 0.18 0.1 0.54 0.33 1 1.25 1 2.03s-0.46 1.41-1 1.41c-0.54-0.01-0.97-0.92-0.97-2.04 0-0.85 0.26-1.42 0.63-1.5zm107.56 0.5v3.5 3.47h-5.66c-6.71-0.02-8.38-0.9-7.93-4.06 0.31-2.18 0.81-2.36 6.97-2.63l6.62-0.28zm14.75 0.57-0.47 5.9c-0.63 8.15-1.57 13.58-2.53 14.78-0.45 0.56-1.68 5.17-2.78 10.22-1.1 5.06-2.42 9.68-2.91 10.28-0.82 1.03-1.31 3.4-2.72 12.69-0.3 2.03-0.98 3.92-1.46 4.22-0.49 0.3-0.88 1.65-0.88 2.97s-0.49 2.41-1.06 2.41c-1.24 0-0.28-7.62 1.59-12.82 0.69-1.89 1.97-6.98 2.88-11.31 0.9-4.33 2.05-8.65 2.56-9.59s0.92-2.91 0.94-4.41c0.02-2.52 2-10.17 5.4-20.91l1.44-4.43zm-212.62 0.47c0.16 0.02 0.17 0.29-0.07 0.78-2.16 4.55-3.3 6.71-3.72 7.12-0.27 0.27-2.12 3.05-4.15 6.16-3.65 5.58-4.69 6.58-4.69 4.65 0-0.54 0.46-0.97 1-0.97s0.97-0.66 0.97-1.43c0-0.78 0.54-1.99 1.22-2.72 1.82-1.98 3.69-5.51 3.69-6.94 0-0.69 1.15-2.42 2.53-3.91 1.64-1.77 2.85-2.8 3.22-2.74zm-35.88 0.21c-0.2 0.08-0.28 0.6-0.25 1.38 0.05 1.14 0.25 1.38 0.56 0.59 0.29-0.71 0.27-1.55-0.06-1.87-0.08-0.08-0.18-0.12-0.25-0.1zm313.97 0.69c0.78 0.14 1.44 2.32 1.44 6.5 0 3.61-0.42 6.41-0.97 6.41-0.6 0-0.95 4.08-0.88 10.56 0.11 9.57 0.23 10.05 0.97 5.16 0.45-2.98 0.57-6.95 0.32-8.85-0.44-3.18-0.37-3.24 0.62-0.97 0.59 1.36 0.94 5.45 0.75 9.1s-0.02 6.62 0.41 6.62c1.27 0 0.85 8.53-0.47 9.6-0.68 0.54-2.58 1.27-4.22 1.62-3.85 0.82-15.12 10.87-13.75 12.25 1.15 1.17 6.4 0.32 6.4-1.03 0.01-0.51 0.47-0.63 1.04-0.28s1.85-0.3 2.84-1.44c1.1-1.26 2.4-1.81 3.38-1.44 1.16 0.45 1.59 0.06 1.59-1.5 0-1.31 0.45-1.88 1.12-1.47 0.61 0.38 1.47 0.06 1.94-0.68 0.69-1.09 0.86-1.04 0.88 0.28 0 0.9-0.48 1.82-1.1 2.03-0.84 0.28-0.81 2.06 0.16 6.94 1.22 6.13 1.17 6.67-0.59 8.62-1.54 1.7-2.69 2.04-6.1 1.66-4.48-0.51-5.96 0.32-3.78 2.12 2.08 1.73 9.58 1.65 13.12-0.12 3.02-1.51 3.19-1.49 3.19 0.19 0 1.01-0.93 2.03-2.19 2.37-2.3 0.62-10.34 0.7-12.06 0.13-0.54-0.18-2.2-0.58-3.68-0.91-2.32-0.51-2.72-1.07-2.72-3.97 0-2.38 0.58-3.73 1.96-4.47 1.28-0.68 1.97-0.7 1.97-0.06 0 0.54 0.72 0.73 1.57 0.41 0.84-0.33 2.57-0.04 3.87 0.65 1.92 1.03 2.67 1.03 3.91 0 2.45-2.03 0.05-3.76-6.19-4.43-11.61-1.26-12.95-1.59-12.94-3.29 0.02-2.27 4.7-20.95 5.44-21.68 0.33-0.33 0.32 1.03-0.06 3.06-0.52 2.77-0.38 3.73 0.62 3.81 11.93 1.01 14.63 0.53 14.63-2.62 0-2.89-2.55-3.17-8.88-0.94-2.3 0.81-4.33 1.5-4.53 1.5-0.75 0-0.35-4.13 0.56-5.84 0.52-0.98 2.11-6.16 3.5-11.5 1.4-5.35 2.95-10.84 3.44-12.19 0.49-1.36 1.08-4.09 1.31-6.07 0.49-4.09 1.38-5.98 2.16-5.84zm-211.75 0.1c0.51-0.01 0.65 1 0.28 2.21-2.66 8.76-3.65 13.54-3.81 18.35l-0.19 5.53 9.59 0.25c5.31 0.15 9.6 0.72 9.6 1.25 0 0.55-4.32 0.94-10.22 0.94-11.54 0-11.38 0.13-11.41-8.72-0.01-4.74 4.67-19.81 6.16-19.81zm249.03 0c0.24-0.01 0.73 0.45 1.06 1 0.34 0.54 0.14 0.96-0.43 0.96-0.58 0-1.07-0.42-1.07-0.96 0-0.55 0.2-1 0.44-1zm-44.06 0.9c0.21 0 0.36 0.17 0.53 0.47 0.6 1.08 0.13 2.84-1.59 5.75-1.38 2.31-3 5.42-3.6 6.91-1.29 3.24-3.28 3.67-2.31 0.5 0.37-1.22 2.02-5.04 3.66-8.47 1.74-3.65 2.67-5.15 3.31-5.16zm-277.81 1.06c0.42 0 0.75 0.35 0.75 0.75-0.01 1.06-4.84 6.82-4.88 5.82-0.05-1.29 3.26-6.57 4.13-6.57zm236.47 0c0.81 0 1.2 0.46 0.87 1s-1.28 0.97-2.09 0.97c-0.82 0-1.18-0.43-0.85-0.97 0.34-0.54 1.25-1 2.07-1zm88.9 0c0.54 0 1 0.46 1 1s-0.46 0.97-1 0.97-0.97-0.43-0.97-0.97 0.43-1 0.97-1zm-245.22 0.1c1.69 0.04 3.48 0.55 4.72 1.5 1.89 1.45 1.85 1.48-0.75 0.84-2.98-0.73-3.86 0.99-0.97 1.91 0.95 0.3 2.35 1.59 3.1 2.81l1.34 2.19-2.41-2.19c-3.8-3.5-4.01-1.4-0.25 2.56 1.87 1.97 3.37 4.6 3.38 5.85 0.01 3.1-1.58 1.9-2.31-1.75-0.33-1.64-1-2.97-1.5-2.97-0.51 0-0.18 2.16 0.71 4.81 0.9 2.65 1.94 4.63 2.35 4.38 0.4-0.26 0.75-0.02 0.75 0.56 0 0.57-1.27 1.06-2.81 1.06-1.55 0-4.75 0.21-7.13 0.47-5.32 0.57-6.78-0.04-6.78-2.78 0-4.18 3.06-16.59 4.41-17.94 0.9-0.9 2.46-1.35 4.15-1.31zm-84.9 1.28c0.35 0.01 0.59 0.36 0.59 0.97 0 0.81-0.43 1.76-0.97 2.09-0.54 0.34-1-0.03-1-0.84s0.46-1.76 1-2.1c0.14-0.08 0.26-0.12 0.38-0.12zm298.03 0c0.28-0.12 1.19 1.3 2.87 4.53 4.39 8.42 5.92 10.84 6.97 10.84 0.48 0 0.44-0.57-0.06-1.25-0.5-0.67-1.44-2.56-2.09-4.18l-1.19-2.94 2.56 2.94c8.12 9.44 11.84 13.28 12.87 13.28 0.65 0 1.32 0.34 1.5 0.75 0.54 1.19 7.45 6.15 8.6 6.15 0.58 0 1.06 0.41 1.06 0.91s1 1.21 2.22 1.59 2.42 0.98 2.69 1.32c0.9 1.11 7.05 4.06 8.47 4.06 2.05 0 1.67 2.3-0.6 3.72-2.2 1.37-2.64 5.33-0.75 6.84 0.68 0.54 2.34 1.28 3.69 1.66 8.11 2.23 10.79 4.77 3.69 3.47-2.82-0.52-5.18-0.35-7.28 0.53-2.68 1.12-3.42 1.08-5.41-0.28-2.16-1.49-2.2-1.48-0.94 0.09 1.72 2.13 0.77 2.11-2.62-0.03-2.63-1.66-2.63-1.65-1 0.25 1.58 1.85 1.51 1.94-1.16 1.94-1.53 0-3.67-0.85-4.81-1.88s-2.09-1.51-2.09-1.06c-0.01 0.45-1.12-0.23-2.47-1.5-3.89-3.65-3.73-1.8 0.28 3.22 3.78 4.74 7.02 5.85 10.93 3.75 0.96-0.51 4.13-1.25 7.07-1.63l5.34-0.69-2.91 2.35c-1.6 1.28-5.34 3.54-8.34 5.03-7.31 3.64-9.25 3.51-11.78-0.78-1.14-1.93-2.06-3.86-2.06-4.31 0-0.46-1.5-3.52-3.35-6.79-1.84-3.26-3.68-6.94-4.06-8.18-0.8-2.64-3.19-8.41-4.53-10.94-0.51-0.97-0.67-2.15-0.38-2.62 0.3-0.48-1-3.54-2.9-6.79-3.83-6.53-4.13-7.49-2.03-6.68 0.95 0.36 1.24 0.04 0.87-0.91-0.3-0.78-1.04-1.4-1.65-1.41-1.2-0.01-4.49-8.33-5.25-13.28-0.11-0.68-0.1-1.04 0.03-1.09zm-225.47 0.5c0.64-0.01 0.89 0.41 0.5 1.34-0.29 0.68-1.05 3.11-1.69 5.41-0.71 2.58-1.73 4.19-2.65 4.19-2.12 0-4.12 2.93-4.16 6.12-0.03 2.34-0.41 2.72-2.97 2.72-2.02 0-2.97-0.48-2.97-1.53 0-0.9-0.43-1.25-1.09-0.85-1.71 1.06-0.14-4.42 2.28-7.96 2.91-4.27 10.45-9.43 12.75-9.44zm144.87 0.09c0.24 0 0.7 0.46 1.03 1 0.34 0.54 0.17 0.97-0.4 0.97s-1.06-0.43-1.06-0.97 0.2-1 0.43-1zm18 0.28c0.61 0.03 0.54 0.23-0.21 0.57-3.45 1.54-8.98 2.43-7.88 1.28 0.54-0.57 2.97-1.29 5.41-1.6 0.75-0.09 1.36-0.18 1.84-0.22 0.36-0.02 0.64-0.04 0.84-0.03zm-111.4 0.57c-0.13 0.11-0.22 0.88-0.22 2.12 0 1.89 0.16 2.67 0.41 1.72 0.24-0.95 0.24-2.49 0-3.44-0.07-0.23-0.08-0.37-0.13-0.4-0.02-0.02-0.04-0.02-0.06 0zm-141.94 1.12c-0.51 0-1.48 0.69-2.16 1.5-0.67 0.81-0.9 1.47-0.53 1.47 0.38 0 1.35-0.66 2.16-1.47s1.04-1.5 0.53-1.5zm9.25 0c0.78 0 1.06 0.99 0.78 2.72-0.24 1.49-0.68 6.23-0.97 10.56-0.28 4.33-0.89 8.76-1.34 9.85-0.45 1.08-1.37 3.41-2.03 5.18-1.78 4.72-2.68 4.72-3.94 0-1.22-4.58-3.45-7.65-5.53-7.65-1.81 0-1.67-1.88 0.19-2.6 0.82-0.31 2.86-3.5 4.56-7.09 3.3-6.98 6.31-10.97 8.28-10.97zm223.31 0.31c1.23-0.17 4.31 0.99 4.31 1.79 0 1.23-3.65 1.07-4.43-0.19-0.36-0.58-0.5-1.23-0.28-1.44 0.08-0.08 0.23-0.13 0.4-0.16zm-243.15 0.69c-0.238 0-0.406 0.43-0.406 0.97s0.458 1 1.031 1 0.772-0.46 0.438-1c-0.335-0.54-0.824-0.97-1.063-0.97zm290.93 0c0.46 0 0.82 5.75 0.82 12.78 0 14.33-0.89 17.54-1.16 4.19-0.1-4.73-0.23-10.48-0.31-12.78-0.09-2.3 0.2-4.19 0.65-4.19zm3.03 0.97c0.41 0 0.75 4.55 0.76 10.09 0 5.55 0.28 11.76 0.62 13.78 0.38 2.33 0.22 3.69-0.44 3.69-0.57 0-1.29-2.34-1.59-5.19-0.73-6.88-0.27-22.37 0.65-22.37zm-74.74 0.03c0.12-0.03 0.28 0.04 0.46 0.19 0.68 0.56 1.22 2.47 1.22 4.25s0.69 6.7 1.5 10.94 1.47 10.29 1.47 13.43c0 3.15 0.46 6.59 1.03 7.66 1.1 2.06 0.89 9.98-0.22 8.28-0.35-0.54-0.97-2.79-1.37-4.94-0.59-3.11-0.86-3.49-1.41-1.93-0.38 1.07-0.48-2.38-0.22-7.66 0.42-8.46 0.29-9.59-1.15-9.59-1.3 0-1.43-0.37-0.63-1.88 0.56-1.05 0.61-2.04 0.13-2.22s-1.03-4.15-1.22-8.84c-0.22-5.47-0.15-7.54 0.41-7.69zm62.06 0.16c0.06-0.03 0.17 0.01 0.25 0.09 0.32 0.33 0.34 1.17 0.06 1.88-0.31 0.78-0.55 0.55-0.59-0.6-0.04-0.78 0.08-1.3 0.28-1.37zm3.4 0.22c0.05 0 0.05 0.03 0.1 0.06 0.59 0.37 1.06 3.8 1.06 7.9 0 10.18-1.52 10.05-1.84-0.15-0.17-5.42 0.06-7.9 0.68-7.81zm-56.37 0.59c0.35-0.01 0.77 0 1.22 0 3.62 0.01 3.69 0.08 3.84 3.97 0.09 2.47 1.01 5.14 2.5 7.12 1.31 1.75 2.71 3.93 3.06 4.88 0.56 1.51-0.06 1.72-5.03 1.72h-5.65l-1.19-5.19c-0.67-2.86-1.22-6.83-1.22-8.84 0-3.13 0.04-3.6 2.47-3.66zm143.34 0c0.41 0 0.75 0.66 0.75 1.47v2.22c0 0.4-0.34 0.83-0.75 0.97-0.4 0.13-0.72-0.87-0.72-2.22 0-1.36 0.32-2.44 0.72-2.44zm-347.75 0.41c0.09 0.03 0.13 0.22 0.13 0.56-0.02 0.81-0.41 2.58-0.85 3.94-0.63 1.97-0.75 2.08-0.78 0.5-0.01-1.09 0.32-2.86 0.78-3.94 0.26-0.6 0.49-0.95 0.63-1.03 0.03-0.02 0.07-0.05 0.09-0.03zm125.5 0.28c-0.09 0.12-0.14 1.13-0.18 2.9-0.07 2.26 0.16 4.84 0.5 5.72 1.14 2.99 1.38 0.84 0.5-4.5-0.5-2.96-0.7-4.28-0.82-4.12zm65 0.9c0.31-0.07 0.95 1.65 1.56 4.19 1.03 4.24 1.03 5.38 0.04 6-0.79 0.49-1 1.75-0.6 3.38 0.66 2.6 0.5 3.08-0.68 1.9-1.05-1.04-0.81-7.03 0.31-7.4 0.68-0.23 0.65-1.39-0.1-3.53-0.6-1.75-0.88-3.69-0.65-4.38 0.03-0.09 0.08-0.15 0.12-0.16zm73.82 0.16c0.39 0.06 0.51 1.82 0.53 5.88 0.01 3.92-0.11 7.12-0.32 7.12-1 0-1.63-10.93-0.71-12.5 0.19-0.33 0.36-0.52 0.5-0.5zm-259.47 0.53c0.21 0.04 0.34 0.23 0.34 0.53 0 0.54-0.43 1.26-0.97 1.6-0.54 0.33-1 0.19-1-0.35s0.46-1.29 1-1.62c0.14-0.09 0.26-0.1 0.38-0.13 0.08-0.01 0.17-0.04 0.25-0.03zm270.28 0.72c0.25-0.11 0.61 0.19 1.03 0.87 0.31 0.51 0.14 1.2-0.41 1.54s-1.03-0.1-1.03-0.94c0-0.87 0.15-1.36 0.41-1.47zm-17.75 0.13c0.06-0.03 0.17 0.01 0.25 0.09 0.32 0.33 0.34 1.16 0.06 1.87-0.31 0.79-0.55 0.56-0.59-0.59-0.04-0.78 0.08-1.3 0.28-1.37zm82.68 0.81c0.24 0 0.73 0.43 1.07 0.97 0.33 0.54 0.13 1-0.44 1s-1.03-0.46-1.03-1 0.17-0.97 0.4-0.97zm-67.96 0.75c0.16-0.21 0.39 1.84 0.78 6.12 0.46 5.14 0.7 9.81 0.53 10.35-0.52 1.59-1.61-9.45-1.47-14.79 0.03-1.02 0.08-1.59 0.16-1.68zm24.28 0.22c0.54 0 0.97 0.2 0.97 0.43 0 0.24-0.43 0.7-0.97 1.03-0.54 0.34-1 0.17-1-0.4s0.46-1.06 1-1.06zm-295.69 0.43c0.06 0.01 0.14 0.13 0.22 0.32 0.27 0.67 0.27 1.76 0 2.43-0.27 0.68-0.47 0.14-0.47-1.22 0-0.84 0.06-1.38 0.19-1.5 0.02-0.01 0.04-0.03 0.06-0.03zm241.84 0.66c0.16 0.03 0.29 0.56 0.47 1.63 0.46 2.59 2.96 2.88 4.66 0.56 1.43-1.96 3.47-0.94 3.47 1.72 0 1.94 0.74 2.22 4.65 1.9 1.85-0.15 2.22 0.34 2.22 2.82 0 3.36 0.94 4.31 2.97 3.06 2.31-1.43 4 0.72 2.75 3.47-1.38 3.03-0.48 5.16 2.34 5.59 1.43 0.22 2.15 0.9 1.91 1.81-1.32 5.04-1.27 5.85 0.5 6.5 2.74 1.01 3.37 2.55 1.59 3.85-1.36 0.99-1.4 1.57-0.31 4.22 0.7 1.68 1.68 2.85 2.16 2.56 0.48-0.3 0.84 0.38 0.84 1.53 0 1.14-0.36 1.83-0.84 1.53-0.49-0.3-1.17 0.15-1.5 1-0.97 2.53-0.69 5.11 0.62 5.66 0.87 0.36 0.65 0.99-0.71 2.09-1.07 0.86-1.99 2.77-2.1 4.25s-0.24 2.98-0.28 3.38c-0.04 0.39-1.46 0.45-3.12 0.12-2.58-0.51-2.97-0.33-2.69 1.22 0.34 1.97-2.93 3.3-4 1.62-0.34-0.52-1.63-1.24-2.85-1.62-1.64-0.52-2.18-0.31-2.18 0.84 0 2.47-2.91 1.78-3.94-0.94-0.77-2.03-1.41-2.35-3.44-1.84-2.16 0.54-2.47 0.28-2.47-1.9 0-2.79-1.57-4.18-4.19-3.76-1.84 0.31-2.37-1.31-0.74-2.31 1.57-0.97-1.69-6.42-3.44-5.75-1.16 0.45-1.47-0.31-1.47-3.53 0-3.15-0.6-4.65-2.59-6.5-2.02-1.86-2.34-2.71-1.47-3.75 0.82-0.99 0.81-2.16 0-4.5-0.61-1.75-0.83-4.92-0.47-7.12 0.39-2.48 0.23-4.53-0.47-5.38-0.91-1.09-0.72-1.34 0.91-1.34 2.58 0 5.04-3.46 4.34-6.13-0.46-1.75-0.21-1.96 1.81-1.47 2.64 0.65 5.03-0.74 6.31-3.72 0.41-0.94 0.59-1.4 0.75-1.37zm58.41 0.31c0.06 0 0.14 0.06 0.25 0.19 0.4 0.47 1.33 2.85 2.03 5.28 0.71 2.44 1.85 6.21 2.56 8.38 0.71 2.16 2.28 7.37 3.47 11.56 1.2 4.19 2.59 7.62 3.13 7.62 1.39 0 3.59 3.12 3.62 5.16 0.02 0.95 0.49 1.72 1.03 1.72 1.37 0 1.32-0.19-1.62-6.59-1.44-3.13-2.55-6.04-2.47-6.44 0.08-0.41-0.25-0.72-0.75-0.72s-1.21-1.46-1.56-3.22c-0.36-1.76-0.86-4.07-1.13-5.16-0.27-1.08 1.1 1.09 3.03 4.85 1.94 3.75 3.5 7.19 3.5 7.62s2.22 5.35 4.91 10.91 5 11.17 5.16 12.5c0.5 4.42-3.76 3.56-5.41-1.1-0.32-0.9-1.82-2.27-3.34-3-3.26-1.55-5.61-5.88-7.53-14.06-0.77-3.24-2.81-11.22-4.57-17.72-3.78-13.99-4.71-17.73-4.31-17.78zm-83.28 0.56c0.54 0.01 1 0.66 1 1.47 0 0.82-0.46 1.5-1 1.5s-0.97-0.68-0.97-1.5c0-0.81 0.43-1.47 0.97-1.47zm130.28 0c0.24 0.01 0.73 0.46 1.06 1 0.34 0.55 0.14 0.97-0.44 0.97-0.57 0-1.06-0.42-1.06-0.97 0-0.54 0.2-1 0.44-1zm-274.88 1.16c1.11-0.03 1.37 2.65 0.41 5.16-0.33 0.85-1.01 1.56-1.53 1.56-1.38 0-0.57-6.18 0.88-6.66 0.08-0.02 0.17-0.06 0.24-0.06zm-73.5 2.13c0.22-0.1 0.57 0.13 1.16 0.62 1.28 1.06 1.3 1.55 0 4.06-1.75 3.4-2.86 3.77-2.03 0.66 0.33-1.22 0.59-3.05 0.59-4.06 0.01-0.76 0.07-1.19 0.28-1.28zm137.16 1.56c0.07-0.01 0.14 0.02 0.22 0.15 1.21 1.93 1.57 26.5 0.41 27.35-0.46 0.33-1.61 2.17-2.57 4.06-0.95 1.89-3.02 5.52-4.62 8.09-1.6 2.58-3.33 6.12-3.81 7.88-0.79 2.84-0.96 3-1.66 1.25-0.44-1.08-1.07-2.21-1.37-2.5-0.31-0.29-2.41-2.49-4.66-4.91-4.06-4.36-4.1-4.47-5.22-15.22-0.62-5.95-1.37-11.92-1.69-13.28l-0.59-2.46 2.59 2.4c1.43 1.31 2.65 3.28 2.69 4.41 0.07 1.98 0.07 1.98 0.81 0.09 0.69-1.75 0.89-1.64 1.85 1 0.86 2.38 1.06 2.49 1.12 0.78 0.11-2.84 4.4-3.9 7.5-1.87 1.66 1.09 2.46 2.78 2.91 6.19 0.34 2.58 0.68 5.32 0.78 6.09s0.8 1.62 1.56 1.87c1.08 0.36 1.25-0.3 0.75-2.9-0.39-2.06-0.28-2.8 0.25-1.97 1.91 2.97 2.71-2.31 2.35-14.97-0.23-7.78-0.08-11.45 0.4-11.53zm146.5 0.34c0.2 0.02 0.3 0.16 0.28 0.41-0.04 0.44-0.44 1.7-0.9 2.78-0.82 1.9-0.84 1.89-0.91-0.19-0.04-1.18 0.37-2.44 0.91-2.78 0.13-0.08 0.29-0.15 0.4-0.19 0.09-0.02 0.15-0.03 0.22-0.03zm30.81 0.22c-0.46-0.03-0.58 0.35-0.31 1.06 0.3 0.79 0.99 1.41 1.47 1.41 1.41 0 0.99-1.72-0.56-2.31-0.24-0.09-0.44-0.15-0.6-0.16zm-333.31 0.5c0.54 0 0.71 0.43 0.38 0.97-0.34 0.54-1.06 1-1.6 1s-0.71-0.46-0.37-1c0.33-0.54 1.05-0.97 1.59-0.97zm295.47 0.22c0.02-0.02 0.01-0.01 0.03 0 0.05 0.04 0.13 0.23 0.19 0.53 0.23 1.22 0.23 3.19 0 4.41-0.24 1.21-0.44 0.21-0.44-2.22 0-1.6 0.1-2.58 0.22-2.72zm-82.91 1.25 0.91 4.44c0.49 2.43 0.77 5.52 0.63 6.87l-0.26 2.47-0.74-2.47c-0.4-1.35-0.68-4.44-0.63-6.87l0.09-4.44zm51 0.41c-2.63 0-5.17 1.16-7.5 3.56-3.11 3.21-3.37 3.91-3.37 9.78 0 3.48 0.42 7.32 0.91 8.56 5.13 13.25 10.04 20.99 15.65 24.63 3.61 2.34 10.33 1.72 13.5-1.25 2.16-2.03 2.41-3.07 2.41-10.28 0-6.16-0.56-9.39-2.41-14.1-5.26-13.41-12.47-20.91-19.19-20.9zm41.07 0.15c0.13 0.03 0.18 0.38 0.18 1.1 0.01 0.91-0.42 1.94-0.97 2.28-1.24 0.77-1.24-0.54 0-2.47 0.42-0.64 0.65-0.93 0.79-0.91zm-275.94 0.25c-0.46 0.03-1.09 0.38-1.72 1.22-0.79 1.04-1.45 2.3-1.47 2.75-0.05 1.28 2.18 0.2 3.31-1.59 0.93-1.48 0.64-2.42-0.12-2.38zm48.75 1.13c0.79-0.04 1.75-0.01 2.87 0.12 5.04 0.6 6.13 1.05 6.13 2.44 0 1.24-10.54 1.19-11.31-0.06-0.93-1.51-0.07-2.38 2.31-2.5zm185.78 0.5c1.39-0.02 2.37 1.1 2.78 3.31 0.34 1.81 0.49 4.58 0.31 6.16l-0.34 2.84-3.66-4.91c-3.3-4.45-3.5-5.04-2.03-6.15 1.11-0.84 2.1-1.24 2.94-1.25zm37.53 1.28c0.08 0.01 0.09 0.18 0.09 0.47 0.03 0.67-1.28 5.94-2.9 11.72-1.62 5.77-3.22 10.74-3.56 11.06s-0.37-0.29-0.07-1.38c0.3-1.08 1.34-5.28 2.29-9.34 1.49-6.43 3.6-12.64 4.15-12.53zm-146.87 0.09c0.05-0.04 0.12 0.24 0.18 0.88 0.22 2.03 0.22 5.34 0 7.37-0.21 2.03-0.37 0.37-0.37-3.68 0-2.79 0.07-4.46 0.19-4.57zm-64.35 0.13-0.65 2.47c-0.37 1.35-1.74 5.15-3.04 8.43-1.29 3.29-2.34 6.54-2.34 7.22s-0.89 1.98-1.97 2.88-2.86 3.4-3.97 5.56c-2.74 5.37-1.29 0.42 2-6.88 1.47-3.24 3.43-7.9 4.35-10.34 0.92-2.43 2.56-5.52 3.65-6.87l1.97-2.47zm36.07 0.5c0.54 0 1.49 1.43 2.12 3.18 1.5 4.21 3.98 18.02 4 22.38 0.02 3.39 1.9 10.15 3.22 11.47 0.37 0.37 0.69 4.59 0.69 9.41 0 10.08 1.47 10.85 2.5 1.28 0.37-3.51 1.08-6.41 1.56-6.41s0.84 2.89 0.84 6.41c0 3.51 0.43 6.37 0.91 6.37 1.06 0 2.06-2.41 2.06-4.94 0-1.01 1.13-3.02 2.47-4.47 1.34-1.44 2.69-4.13 3.03-5.96 0.35-1.84 1.1-3.63 1.66-3.97 1.2-0.75 0.28 6.28-1.47 11.19-1.33 3.7-0.7 4.8 1.97 3.37 1.4-0.75 2.07-2.54 2.56-6.69 0.85-7.19 1.59-10.15 2.56-10.15 0.42 0 0.53 3.66 0.25 8.18-0.32 5.1-0.12 8.49 0.5 8.88 0.66 0.41 1.14-4.26 1.38-13.59 0.23-8.99 0.78-14.66 1.5-15.38 1.15-1.15 1.39-0.06 2.62 11.59 0.34 3.23 0.14 3.98-0.93 3.57-1.03-0.4-1.25 0.2-0.91 2.31 0.25 1.54 0.69 5.21 1 8.19s1.03 6.1 1.59 6.9c1.03 1.48 0.91-1.53-0.53-11.31-0.43-2.91-0.32-3.43 0.38-1.97 0.52 1.08 1.21 4.12 1.56 6.75 0.42 3.22 0.96 4.45 1.62 3.78 0.67-0.66 0.49-2.84-0.5-6.72-1.29-5.09-2.28-13.1-3.03-24-0.13-1.89-0.37-3.86-0.53-4.4-0.15-0.54-0.18-2.32-0.06-3.94 0.2-2.74 0.25-2.68 1 0.97 0.44 2.16 1.12 6.48 1.47 9.59 0.34 3.11 1.1 5.66 1.65 5.66 0.64 0 0.77-1.89 0.38-5.16-0.4-3.27-0.32-4.62 0.25-3.69 0.49 0.82 1.22 4.99 1.59 9.29 0.38 4.29 0.98 8.27 1.35 8.84 0.36 0.57 0.74 2.15 0.81 3.5 0.37 6.91 1.73 14.78 2.59 14.78 0.61 0 0.76-3.06 0.41-8.12-0.32-4.59-0.22-6.8 0.22-5.1 0.89 3.51 4.11 9.28 5.19 9.28 0.4 0 0.49 0.66 0.18 1.47-0.68 1.77 0.76 1.96 2.41 0.32 1.8-1.81 1.39-3.76-0.78-3.76-1.16 0-2.55-1.18-3.44-2.9-1.66-3.22-3.41-13.91-3.41-20.72 0-4.34 0.05-4.25 2.82 3.94 1.55 4.6 3.33 10.27 3.96 12.62 1.55 5.77 2.35 4.5 2.22-3.53l-0.12-6.62 1.9 3.93c1.05 2.17 2.19 5.37 2.54 7.13 0.4 2.05 1.98 4.35 4.43 6.37 2.11 1.74 3.82 3.52 3.82 3.94 0 0.43-1.79 0.75-3.97 0.75-2.19 0-5.15 0.77-6.6 1.72-3.88 2.54-19.99 2.43-24.81-0.16-4.01-2.15-15.38-2.35-19-0.37-2.02 1.11-14.47 1.94-14.47 0.97 0-0.24 1.32-1.94 2.94-3.78 2.05-2.34 2.94-4.34 2.88-6.53l-0.1-3.16-0.9 2.97c-1.15 3.76-7.38 10.77-8.29 9.31-0.85-1.37 0.32-7.61 1.57-8.38 0.52-0.32 0.9 0.59 0.9 2 0 1.42 0.41 2.36 0.88 2.07 0.46-0.29 0.71-4.87 0.53-10.16-0.28-7.95-0.2-8.96 0.62-5.72 0.55 2.16 1.5 4.39 2.1 4.94 0.78 0.72 0.91 0.3 0.47-1.47-0.34-1.35-0.62-3.9-0.63-5.72-0.01-2.63-0.35-3.2-1.62-2.72-1.42 0.55-1.49-0.29-0.94-7.53 0.58-7.71-0.24-16.89-1.85-20.65-0.41-0.99-0.31-1.72 0.26-1.72zm106.43 0.53c5.2-0.03 5.41 0.04 5.13 2.41-0.89 7.3-1.49 10.42-2.16 11.31-0.41 0.54-1.77 5.51-3.03 11.06-1.86 8.22-2.61 10.09-4.06 10.09-1.4 0-1.78-0.78-1.78-3.68-0.01-2.03-0.64-7.67-1.44-12.54-0.8-4.86-1.46-10.74-1.47-13.06-0.02-4.96 0.89-5.55 8.81-5.59zm70.38 1.84c0.03-0.02 0.07 0 0.09 0 0.16 0.05 0.08 0.69-0.22 2.03-0.81 3.62-1.39 4.43-1.37 1.91 0.01-1.04 0.48-2.56 1.03-3.37 0.2-0.31 0.36-0.5 0.47-0.57zm-34.44 0.41c0.05 0.03 0.09 0.17 0.16 0.4 0.24 0.95 0.24 2.5 0 3.44-0.25 0.95-0.44 0.18-0.44-1.72 0-1.42 0.12-2.21 0.28-2.12zm2.91 0.37c0.01-0.02 0.01-0.01 0.03 0 0.05 0.04 0.13 0.23 0.19 0.53 0.23 1.22 0.23 3.23 0 4.44-0.24 1.22-0.44 0.22-0.44-2.22 0-1.59 0.1-2.6 0.22-2.75zm-150.5 0.63-3.19 3.03c-3.28 3.09-3.34 4.34-0.06 1.37 0.99-0.89 2.13-1.3 2.53-0.9 0.86 0.87-4.91 5.85-9.22 7.94-2.96 1.43-6.24 4.43-4.84 4.43 1.47 0 10.03-5.36 13.06-8.18 1.76-1.65 3.18-2.69 3.18-2.32 0 0.94-2.73 3.54-7.37 7.03-2.13 1.61-4.66 3.73-5.63 4.69-2.2 2.21-2.95 2.2-4.34-0.03-1.51-2.41-3.61-12.78-2.94-14.53 0.3-0.77 1.58-1.37 2.82-1.34 1.23 0.02 5.33-0.23 9.12-0.57l6.88-0.62zm-133.72 0.16c0.843 0 1.271 0.42 0.937 0.96s-1.053 1-1.563 1c-0.509 0-0.906-0.46-0.906-1s0.688-0.96 1.532-0.96zm95.282 0c0.87 0 1.57 0.54 1.56 1.21-0.02 1.6-1.92 4.57-1.94 3.03 0-0.63-0.29-1.83-0.62-2.68-0.39-1.02-0.04-1.56 1-1.56zm291.03 0.21c0.12 0.05 0.36 0.74 0.78 2.16 0.9 2.99 0.77 4.02-0.37 2.87-0.36-0.36-0.64-1.78-0.6-3.18 0.04-1.25 0.07-1.89 0.19-1.85zm-372.22 0.91c-0.63-0.05-0.69 0.68-0.25 2.47 0.38 1.54 1.04 2.94 1.5 3.12s0.84 1.09 0.84 2.03c0 0.95 1.36 3.82 3.04 6.35 2.12 3.2 3.67 4.52 5.15 4.47 1.43-0.05 1.66-0.22 0.69-0.6-3.25-1.28-7.47-8.25-8.81-14.5-0.34-1.58-1.19-3.05-1.88-3.28-0.11-0.04-0.19-0.05-0.28-0.06zm243.94 0.09c1.09 0.14 1.29 4.69 1.25 24.6-0.02 11.45-0.25 11.78-5.31 9.03-2.48-1.35-2.69-1.95-2.69-7.28 0-3.2 0.37-6.06 0.84-6.35 0.73-0.44 1.67-4.03 2.69-10.4 0.83-5.2 2.08-9.27 2.97-9.57 0.08-0.02 0.18-0.04 0.25-0.03zm12.31 0.1c0.11-0.07 0.23-0.02 0.41 0.15 0.56 0.54 1.19 3.75 1.37 7.13s-0.03 6.16-0.44 6.15c-0.4 0-0.74-1.06-0.74-2.34-0.01-1.28-0.26-4.48-0.6-7.12-0.32-2.5-0.31-3.77 0-3.97zm-178.69 0.15c0.28 0.04 0.65 0.65 1.16 1.88 0.65 1.58 0.99 3.58 0.78 4.44-0.26 1.06-0.75 0.65-1.56-1.32-0.65-1.58-0.99-3.55-0.78-4.4 0.09-0.4 0.24-0.62 0.4-0.6zm11.5 0.1c0.49-0.16 0.49 2.32-0.37 6.47-0.6 2.88-1.74 8.99-2.5 13.59-0.77 4.6-1.84 9.92-2.38 11.81-0.81 2.89-0.93 2.33-0.59-3.43 0.62-10.57 1.65-18.6 2.5-19.69 0.42-0.54 1.3-2.97 1.97-5.41 0.6-2.21 1.08-3.25 1.37-3.34zm184.53 0.4c0.55 0 0.97 1.09 0.97 2.44s-0.42 2.47-0.97 2.47c-0.54 0-1-1.12-1-2.47s0.46-2.44 1-2.44zm-177.62 0.25c0.1-0.01 0.22 0.04 0.38 0.13 0.55 0.34 1.31 2.48 1.68 4.78 0.38 2.3 1.24 5.5 1.94 7.12 0.7 1.63 1.53 3.75 1.84 4.69 0.35 1.06 0.05 1.72-0.75 1.72-0.81 0-1.92-2.83-3-7.62-0.94-4.2-1.94-8.46-2.21-9.47-0.23-0.83-0.18-1.31 0.12-1.35zm-61.66 0.03c0.68-0.03 1.33 0.42 2.57 1.32 1.88 1.37 2.54 2.73 2.56 5.37 0.04 4.43 2.44 6.85 6.15 6.13 1.49-0.29 2.72-0.91 2.72-1.38s1.01-0.85 2.22-0.81c1.22 0.04 3.85-0.25 5.82-0.63 3.48-0.67 3.57-0.57 4.74 3.13 0.67 2.09 1.73 4.24 2.35 4.78s1.72 1.77 2.47 2.72c1.24 1.58 1 1.72-3.03 1.72-2.41 0-4.68-0.3-5.03-0.66-0.36-0.35-6.24-0.57-13.07-0.47-8.34 0.13-12.9-0.19-13.84-0.96-0.77-0.64-3.54-1.52-6.19-1.94-2.64-0.42-5.78-1.64-6.97-2.69s-3.01-2.62-4.03-3.5c-2.82-2.45-2.22-3.75 3.63-7.81 4.87-3.39 5.55-3.6 6.93-2.22 2.07 2.06 3.9 1.95 7.25-0.53 1.39-1.03 2.07-1.53 2.75-1.57zm220.19 0.35c0.25-0.08 0.28 0.97 0.31 3.53 0.04 2.57-0.11 4.69-0.37 4.69-1.1 0-1.52-4.66-0.63-6.91 0.32-0.8 0.54-1.26 0.69-1.31zm79.09 0.34c-0.05 0.05 0.24 0.47 0.85 1.25 1.28 1.64 2.09 2.16 2.09 1.35 0-0.21-0.77-0.98-1.72-1.72-0.78-0.61-1.16-0.93-1.22-0.88zm-240.03 0.07c0.55-0.07 0.97 0.71 0.97 2.34 0 1.33 0.54 3.54 1.16 4.9 0.87 1.92 0.84 2.81-0.13 3.97-0.68 0.83-1.76 1.45-2.37 1.41-0.7-0.05-0.65-0.22 0.12-0.53 1.93-0.78 1.48-1.92-1.31-3.19-1.82-0.83-2.27-1.49-1.59-2.34 0.52-0.67 1.2-2.42 1.56-3.91 0.4-1.68 1.05-2.59 1.59-2.65zm229.5 2.21c0.03 0.02 0.05 0.09 0.1 0.19 0.23 0.54 1.41 5.4 2.59 10.81 1.19 5.41 2.39 10.5 2.69 11.32 0.3 0.81 0.71 2.58 0.94 3.93 0.47 2.89 2.72 5.62 5.31 6.44 1.13 0.36 1.84 1.5 1.84 2.97 0 2.2-0.36 2.41-4.72 2.41-7.28 0-8.59-1.5-8.34-9.47 0.12-3.66-0.18-7.12-0.66-7.69-0.47-0.57-0.89-2.15-0.93-3.5-0.05-1.35-0.28-4.67-0.53-7.38-0.46-4.84-0.44-4.88 0.59-1.24 0.57 2.02 1.48 3.68 2.03 3.68s0.68-0.77 0.31-1.72c-0.67-1.74-1.67-10.95-1.22-10.75zm-31.34 0.13c0.06 0.01 0.14 0.12 0.22 0.31 0.27 0.68 0.27 1.76 0 2.44s-0.5 0.13-0.5-1.22c0-0.85 0.09-1.38 0.22-1.5 0.02-0.02 0.04-0.03 0.06-0.03zm-80.22 0.62c0.49-0.05 1.09 0.44 1.5 1.5 0.33 0.86 0.56 1.65 0.56 1.78 0 0.14-0.65 0.26-1.47 0.26-0.81-0.01-1.46-0.79-1.46-1.79 0-1.1 0.38-1.7 0.87-1.75zm64.41 0.13c0.06-0.03 0.17-0.02 0.25 0.06 0.32 0.33 0.34 1.17 0.06 1.88-0.31 0.78-0.55 0.58-0.59-0.57-0.04-0.77 0.08-1.3 0.28-1.37zm-15.35 0.22c0.07-0.01 0.15 0.01 0.22 0.06 0.54 0.33 1 2.37 1 4.5s-0.46 3.87-1 3.87-0.97-2.03-0.97-4.5c0-2.39 0.28-3.86 0.75-3.93zm-271.59 0.25c0.154-0.01 0.144 1.16 0.031 3.75-0.17 3.88-0.63 5.11-2.219 5.81-2.286 1.01-4.826 7.47-2.937 7.47 0.623 0 1.65-0.49 2.281-1.13 1.428-1.42 2.516 0.87 2.032 4.28-0.232 1.64-0.989 2.27-2.626 2.29-2.523 0.02-5.997 3.89-6.031 6.68-0.056 4.56-4.873 8.68-7.531 6.47-1.102-0.91-1.7-0.92-2.562-0.06-1.371 1.37-2.75 1.48-2.75 0.22-0.001-1.4 2.955-4 4.531-4 1.006 0 1.375-1.2 1.375-4.31 0-4.39 2.911-12.6 4.875-13.82 0.586-0.36 1.045-2.31 1.062-4.31 0.023-2.7 0.678-4.07 2.469-5.37 2.202-1.61 2.335-1.62 1.75-0.1-0.433 1.13-0.247 1.45 0.531 0.97 0.633-0.39 1.125-1.34 1.125-2.12s0.454-1.41 1.032-1.41c0.602 0 0.795 0.84 0.437 1.97-0.351 1.1-0.168 1.94 0.406 1.94 0.562 0 1.466-1.43 2-3.19 0.398-1.31 0.6-2.03 0.719-2.03zm-16.281 0.37c-0.502 0-1.4 0.45-2.625 1.38-1.871 1.41-1.878 1.47 0.187 1.5 1.16 0.01 2.376-0.66 2.688-1.47 0.359-0.94 0.252-1.4-0.25-1.41zm296 1.1c2.67 0.18 5.87 3.95 5.87 8.56 0 3.78-0.2 4.08-2.71 4.06-1.49-0.01-3.23-0.41-3.91-0.84-1.94-1.23-3.23-6.83-2.19-9.57 0.63-1.64 1.73-2.3 2.94-2.21zm-89.16 0.12c-0.05 0.01-0.08 0.03-0.12 0.06-0.31 0.31 0.03 1.24 0.72 2.07 1.76 2.13 2.25 1.87 0.96-0.54-0.52-0.98-1.2-1.65-1.56-1.59zm-13.72 1.13c0.07 0 0.15 0.12 0.22 0.31 0.28 0.68 0.28 1.76 0 2.44-0.27 0.67-0.5 0.13-0.5-1.22 0-0.85 0.09-1.39 0.22-1.5 0.02-0.02 0.04-0.04 0.06-0.03zm112.32 0.68c1.84 0.13 2.92 3.83 1.22 4.91-2.09 1.32-2.82 1.01-2.82-1.13 0-1.08-0.06-2.28-0.15-2.68-0.1-0.41 0.51-0.9 1.37-1.06 0.13-0.03 0.25-0.04 0.38-0.04zm-284.97 0.54c0.634-0.17 1.062 0.58 1.062 2.28 0 1.02 1.288 4.06 2.87 6.75 2.25 3.81 2.73 5.52 2.16 7.68-0.58 2.18-1.39 2.86-3.78 3.1-2.681 0.26-3.142-0.1-4.031-2.97-2.239-7.23-2.361-9.81-0.625-13.66 0.869-1.93 1.709-3.02 2.344-3.18zm275.93 0.5c-0.25-0.02-0.53 0.03-0.78 0.12-2.09 0.8-2.06 2.68 0.1 5.38 1.99 2.49 3.56 2.33 3.97-0.38 0.35-2.36-1.49-5.01-3.29-5.12zm105.63 0c0.1-0.01 0.16 0.1 0.16 0.31 0 0.54-0.45 1.62-0.97 2.43-0.53 0.82-0.94 1.05-0.94 0.5 0-0.54 0.41-1.65 0.94-2.46 0.33-0.51 0.64-0.78 0.81-0.78zm-233.81 2.28c-0.07-0.02-0.13-0.01-0.19 0.03-1.21 0.75-0.16 16.21 1.22 17.87 1.81 2.18 3.05 1.43 2.34-1.44-0.77-3.11-1.39-6.86-2.12-12.81-0.25-2.02-0.78-3.52-1.25-3.65zm231.62 2.72c0.28 0.02 0.41 0.5 0.41 1.5 0 2.37-0.48 2.74-1.5 1.09-0.36-0.59-0.2-1.56 0.41-2.16 0.3-0.3 0.51-0.45 0.68-0.43zm-114.15 0.71h1.47c4.98 0 6.28 2.33 2.81 5-3.16 2.43-3.53 2.39-5.28-1-1.79-3.46-1.99-3.94 1-4zm-140.66 0.97c0.38 0 0.11 0.69-0.56 1.5-0.68 0.81-1.61 1.47-2.13 1.47-0.51 0-0.28-0.66 0.53-1.47 0.82-0.81 1.78-1.5 2.16-1.5zm-26.63 0.1c0.56-0.12 1.63 0.36 3.44 1.4 1.36 0.78 1.81 1.36 1 1.32-2.76-0.15-4.9-0.97-4.9-1.88 0-0.47 0.13-0.78 0.46-0.84zm189.44 0.09c0.88 0.07 1.32 1.85 1.69 5.69 0.51 5.35-0.07 5.89-3.47 3.06-2.71-2.26-2.77-4.06-0.31-7.09 0.9-1.11 1.57-1.7 2.09-1.66zm-169.78 0.94c0.5 0 0.43 0.26-0.47 0.84-0.81 0.53-2.12 0.94-2.93 0.91-0.98-0.04-0.83-0.35 0.46-0.91 1.36-0.58 2.44-0.84 2.94-0.84zm-29.72 0.84c0.41 0 0.72 2.23 0.72 4.94 0 4.31-0.39 5.33-3.19 7.87-1.75 1.6-3.91 2.89-4.78 2.91-1.23 0.02-0.68-1.7 2.47-7.84 2.22-4.33 4.38-7.87 4.78-7.88zm20.91 2.47c3.95 0 6.65 0.35 6.03 0.75s-3.33 0.69-6.03 0.69c-2.71 0-5.44-0.29-6.06-0.69-0.63-0.4 2.1-0.75 6.06-0.75zm217.25 0.69c0.07-0.03 0.17 0.01 0.25 0.09 0.33 0.33 0.35 1.17 0.06 1.88-0.31 0.78-0.55 0.55-0.59-0.6-0.03-0.78 0.08-1.3 0.28-1.37zm-230.53 0.78c0.54 0 0.97 0.2 0.97 0.44 0 0.23-0.43 0.69-0.97 1.03-0.54 0.33-1 0.16-1-0.41s0.46-1.06 1-1.06zm184.69 1c1.34 0.01 7 5.84 7.65 7.91 0.36 1.11 0.13 2.61-0.47 3.34-0.6 0.72-2.16 1.53-3.47 1.78-2.15 0.41-2.47-0.01-3.4-4.38-1.22-5.67-1.34-8.66-0.31-8.65zm-159.5 0.47 0.18 9.12c0.17 8.21-0.08 10.49-0.97 8.35-0.16-0.41-0.05-4.5 0.25-9.1l0.54-8.37zm-12.29 0.5c1.88 0 2.74 0.41 2.32 1.09-0.37 0.59-1.55 0.81-2.6 0.53-1.19-0.31-1.77-0.03-1.53 0.69 0.47 1.42 2.56 1.57 5 0.37 1.37-0.67 1.73-0.55 1.41 0.44-0.63 1.91-6.11 2.2-7.6 0.41-1.72-2.08-0.47-3.53 3-3.53zm161.19 0c1.53 0 1.97 0.67 1.97 2.97 0 3.49-0.07 3.52-2.25 0.97-2.23-2.61-2.13-3.94 0.28-3.94zm3.34 0.18c0.07-0.02 0.14 0.02 0.22 0.1 0.33 0.33 0.35 1.16 0.07 1.87-0.32 0.79-0.52 0.56-0.57-0.59-0.03-0.78 0.08-1.3 0.28-1.38zm-155.62 0.32c0.59-0.22 0.81 1.32 0.81 5.22 0 3.35-0.18 6.09-0.4 6.09-1.06 0-1.69-10.1-0.69-11.09 0.1-0.1 0.2-0.19 0.28-0.22zm60.03 0.59c0.13 0.02 0.37 0.18 0.72 0.5 0.67 0.62 1.01 2.57 0.78 4.44-0.33 2.7-0.43 2.85-0.56 0.72-0.09-1.45-0.43-3.45-0.78-4.44-0.31-0.86-0.38-1.26-0.16-1.22zm-53.81 0.25c0.24-0.11 0.35 1.4 0.4 4.81 0.06 3.66-0.06 6.63-0.28 6.63-0.82 0-1.2-7.47-0.53-10.28 0.17-0.7 0.3-1.11 0.41-1.16zm4.84 0.63c0.24 0 0.73 0.46 1.06 1 0.34 0.54 0.14 0.97-0.43 0.97-0.58 0-1.07-0.43-1.07-0.97s0.2-1 0.44-1zm-57.4 1c-1.12 0-2.04 0.42-2.04 0.97 0 0.54 0.63 1 1.41 1s1.7-0.46 2.03-1c0.34-0.55-0.29-0.97-1.4-0.97zm206.03 0.53c0.06 0 0.11 0.22 0.19 0.68 0.22 1.5 0.23 3.7 0 4.91-0.24 1.21-0.45 0.02-0.44-2.69 0-1.86 0.12-2.91 0.25-2.9zm105.84 0.31c2.28-0.05 5.32 0.86 7.35 2.59 1.57 1.36 3.75 2.44 4.81 2.44 1.46 0 1.62 0.29 0.75 1.16s-0.75 1.47 0.53 2.4c0.93 0.68 1.37 1.57 0.97 1.97-0.41 0.41-0.75 0.2-0.75-0.43 0-0.79-1.69-1.05-5.38-0.79-4.97 0.36-5.65 0.17-8.37-2.62-1.63-1.67-2.97-3.83-2.97-4.81 0-1.25 1.29-1.87 3.06-1.91zm-370.47 1.13c0.81 0 1.47 0.13 1.47 0.34 0 0.2-0.66 0.95-1.47 1.62-1.21 1.01-1.5 0.94-1.5-0.37 0-0.88 0.69-1.59 1.5-1.59zm181.25 0c0.03-0.02 0.09 0 0.13 0 0.85 0 2.18 2.45 4.5 8.24 1.78 4.48 1.54 5.29-0.85 2.66-1.84-2.04-4.69-10.39-3.78-10.9zm29.16 0c0.21 0 0.66 0.65 0.97 1.46 0.31 0.82 0.12 1.47-0.41 1.47-0.52 0-0.97-0.65-0.97-1.47 0-0.81 0.2-1.46 0.41-1.46zm-121.85 0.96c0.06-0.04 0.12 0.2 0.19 0.75 0.22 1.76 0.22 4.62 0 6.38s-0.37 0.33-0.37-3.19c0-2.42 0.06-3.85 0.18-3.94zm24.6 0c0.05-0.04 0.12 0.2 0.19 0.75 0.21 1.76 0.21 4.62 0 6.38-0.22 1.76-0.38 0.33-0.38-3.19 0-2.42 0.07-3.85 0.19-3.94zm-103.41 0.07c-0.28 0.02-0.4 0.29-0.4 0.78 0 0.46 1 1.32 2.21 1.9 3.2 1.54 3.34 1.42 0.97-0.78-1.42-1.33-2.31-1.94-2.78-1.9zm353.81 1.12c0.53 0.03 1.17 0.39 2.19 1.06 1.32 0.86 2.62 2.48 2.91 3.6 0.48 1.85 0.08 2.03-4.38 2.03-4.61 0-4.81-0.13-4.18-2.22 0.36-1.22 1.24-2.83 1.96-3.59 0.57-0.6 0.98-0.9 1.5-0.88zm-269.15 0.09c0.59-0.14 1.55 1.44 1.65 3.47 0.12 2.32 0.16 2.35 0.54 0.41 0.66-3.46 2.25-2.57 2.25 1.25 0 1.89 0.48 3.44 1.06 3.44 0.61 0 0.79-0.93 0.44-2.22l-0.6-2.22 2.03 2.34c1.11 1.28 2 3.53 2 5.03 0 2.45-0.39 2.82-3.68 3.13-4.99 0.47-11.1-0.13-11.1-1.06 0-0.42 1.12-2.93 2.47-5.6 1.35-2.66 2.47-5.61 2.47-6.59 0-0.87 0.2-1.31 0.47-1.38zm-7.81 0.29c0.05-0.04 0.11 0.19 0.18 0.65 0.23 1.49 0.23 3.92 0 5.41-0.22 1.49-0.4 0.26-0.4-2.72 0-2.05 0.09-3.27 0.22-3.34zm-100 0.06c2.187-0.05 5.444 0.57 10.254 1.84 5.5 1.45 11.57 3.47 13.47 4.47 1.89 1 4.32 2.15 5.4 2.56 1.44 0.56 0.69 0.85-2.87 1.1-2.68 0.18-5.88-0.21-7.13-0.88-1.24-0.66-2.52-0.94-2.84-0.62-1.42 1.42 4.54 2.94 13.47 3.44 9.47 0.52 11.97 1.39 7.5 2.59-1.22 0.32-2.65 0.51-3.19 0.47-3.7-0.32-19.96-3-21.16-3.5-0.81-0.34-2.58-0.78-3.94-1-1.35-0.22-2.86-0.84-3.37-1.35-0.51-0.5-1.739-0.9-2.688-0.9-3.441 0-6.718-2.24-6.718-4.57 0-2.42 1.001-3.59 3.812-3.65zm202.65 0.34c0.49 0 1.21 2.32 1.6 5.16 0.75 5.6 1.97 8.62 3.47 8.62 1.41 0 1.08-3.17-0.57-5.34-3.13-4.14-0.78-4.76 4.07-1.06 3.35 2.56 4.94 3.01 5.5 1.62 0.4-1.01 13.59 0.96 13.59 2.03 0 0.43-1.48 0.78-3.25 0.78-3.35 0-5.96 1.46-10 5.5-3.39 3.39-6.77 3.05-9.81-0.93-3.71-4.86-6.95-16.38-4.6-16.38zm30 0.03c4.33-0.05 13.56 2.36 18.03 5.25 3.57 2.31 4.28 4.05 1.28 3.1-1.5-0.48-2.04-0.05-2.53 1.9-0.66 2.67-0.59 2.67-10.03 1.82-4.02-0.37-5.6-2.23-3.18-3.72 1.53-0.95 1.14-4.44-0.5-4.44-0.82 0-1.47-0.46-1.47-1s-0.89-0.97-1.97-0.97-1.97-0.46-1.97-1c0-0.65 0.9-0.92 2.34-0.94zm-240.22 1.41c1.838-0.22 2.882 1.54 2.594 4.56-0.282 2.95-0.699 3.39-3.438 3.66-3.744 0.36-5.021-1.29-2.875-3.66 0.865-0.95 1.563-2.2 1.563-2.78-0.001-0.57 0.587-1.28 1.312-1.56 0.294-0.11 0.581-0.19 0.844-0.22zm377.57 0.53c0.54 0 0.96 0.4 0.96 0.91s-0.42 1.23-0.96 1.56-1-0.09-1-0.94c0-0.84 0.46-1.53 1-1.53zm-393.32 0.06c0.493-0.09 0.812 0.32 0.812 1.28 0 0.75-0.856 1.61-1.906 1.88-1.657 0.43-1.758 0.27-0.75-1.34 0.682-1.1 1.35-1.72 1.844-1.82zm423.04 0c0.36-0.03 0.81 0 1.34 0.1 1.54 0.3 1.54 0.47 0.16 1.62-1.11 0.92-1.74 0.95-2.22 0.16-0.68-1.09-0.37-1.77 0.72-1.88zm-369.85 0.04c-0.34-0.03-0.1 0.24 0.56 0.96 0.7 0.76 2.68 1.93 4.41 2.57 3.58 1.31 6.28 1.62 5.28 0.62-0.37-0.37-2.09-1.2-3.84-1.84s-4.11-1.49-5.19-1.91c-0.62-0.24-1.01-0.39-1.22-0.4zm229.44 0.12c0.02-0.02 0.01-0.01 0.03 0 0.05 0.04 0.13 0.23 0.19 0.53 0.23 1.22 0.23 3.19 0 4.41-0.24 1.21-0.44 0.21-0.44-2.22 0-1.6 0.1-2.58 0.22-2.72zm-32.06 0.69c0.2-0.02 0.47 0.09 0.71 0.34 0.33 0.33 0.39 1.13 0.16 1.81-0.33 1-0.57 1.01-1.19 0-0.61-0.99-0.3-2.09 0.32-2.15zm-3.91 0.06c0.57 0 1.06 0.46 1.06 1s-0.2 0.97-0.44 0.97c-0.23 0-0.69-0.43-1.03-0.97-0.33-0.54-0.16-1 0.41-1zm-94.97 0.47c0.08-0.07 0.18 0.03 0.28 0.28 0.28 0.68 0.28 1.79 0 2.47-0.27 0.68-0.5 0.1-0.5-1.25 0-0.85 0.09-1.39 0.22-1.5zm-38.37 0.72c0.06-0.03 0.16 0.01 0.25 0.09 0.32 0.33 0.34 1.17 0.06 1.88-0.32 0.78-0.55 0.55-0.59-0.6-0.04-0.78 0.07-1.3 0.28-1.37zm130.56 0.9c0.34-0.01 0.71 0.05 1.06 0.19 0.79 0.32 0.58 0.55-0.56 0.59-1.04 0.05-1.64-0.17-1.31-0.5 0.16-0.16 0.47-0.26 0.81-0.28zm-178.53 1.85c-0.51 0.04-0.64 0.29-0.19 0.75 0.4 0.4 2.16 1.27 3.88 1.9 4.89 1.81 6.39 1.4 2.59-0.68-2.31-1.27-5.17-2.07-6.28-1.97zm82.4 0.19c0.07-0.03 0.17 0.01 0.25 0.09 0.33 0.33 0.35 1.16 0.07 1.87-0.32 0.79-0.55 0.59-0.6-0.56-0.03-0.78 0.08-1.33 0.28-1.4zm-125.37 1.06c0.41 0.01 0.97 0.15 1.687 0.53 1 0.52 2.929 1.44 4.284 2l2.47 1.03-2.972 0.03c-1.624 0.02-3.77-0.62-4.813-1.41-1.431-1.08-1.687-1.97-1.031-2.15 0.098-0.03 0.238-0.04 0.375-0.03zm384.9 1.62c2.36-0.02 4.34-0.02 5.44 0.03 0.68 0.04 1.25 0.95 1.25 2.03 0 1.86-0.66 1.97-11.84 1.97-9.76 0-11.96-0.24-12.44-1.5-0.32-0.83-0.37-1.72-0.15-1.93 0.24-0.24 10.67-0.54 17.74-0.6zm-290.46 1.06c0.38 0 1.5 0.62 2.5 1.35 1.25 0.92 1.47 1.54 0.68 2.03-0.62 0.39-1.15 1.79-1.15 3.12 0 1.7-0.77 2.71-2.53 3.38-3.27 1.24-3.38 1.22-3.38-0.5 0-2.03 3.04-9.38 3.88-9.38zm-100.28 0.1c0.973 0.03 0.829 0.35-0.469 0.9-2.704 1.17-4.267 1.17-2.468 0 0.811-0.52 2.125-0.93 2.937-0.9zm89.845 0.31c2.54 0.03 4.59 0.77 4.59 2.31 0 1.12-0.68 1.32-2.87 0.88-1.66-0.33-4.41 0.05-6.38 0.87-4.85 2.03-5.77 1.81-4-0.9 1.36-2.07 5.39-3.19 8.66-3.16zm42.28 0.59c0.89 0 2.08 0.89 2.66 1.97 0.8 1.51 0.75 1.97-0.25 1.97-0.73 0-1.85-0.54-2.5-1.18-0.92-0.92-1.19-0.59-1.19 1.43 0 1.43-0.46 2.88-1.06 3.25-0.74 0.46-0.91-0.07-0.47-1.65 0.62-2.23 0.57-2.24-1.44 0.34-2.02 2.61-2.44 2.72-11.13 2.69-10.28-0.04-13-1.01-11.4-4 0.57-1.07 1.47-1.63 2.03-1.28 0.56 0.34 4.95 0.6 9.75 0.56 7.69-0.07 8.64 0.08 8.09 1.5-0.41 1.07-0.2 1.35 0.57 0.87 0.63-0.39 1.12-1.27 1.12-1.97 0-1.71 3.24-4.5 5.22-4.5zm103.91 1.26c0.96-0.06 1.81 0.05 2.43 0.4 1.44 0.8 1.3 1.09-0.93 2.28-2.03 1.09-2.91 1.13-4.41 0.19-1.67-1.04-1.86-0.92-1.66 1.03 0.17 1.61-0.36 2.31-1.9 2.53-1.17 0.17-2.35-0.09-2.63-0.53-1.34-2.16 4.92-5.66 9.1-5.9zm69.34 0.18c0.91-0.05 1.56 0.09 1.56 0.5 0 0.55-0.4 1-0.87 1-0.48 0-2.36 0.26-4.19 0.56-2.27 0.39-2.85 0.26-1.84-0.37 1.53-0.95 3.82-1.59 5.34-1.69zm-282.66 0.66c0.35-0.02 0.74 0.04 1.1 0.19 0.78 0.31 0.55 0.51-0.6 0.56-1.03 0.04-1.6-0.14-1.28-0.47 0.17-0.16 0.44-0.27 0.78-0.28zm7.07 0.97c2.03-0.07 3.68 0.33 3.68 0.87 0 1.09-0.17 1.09-4.43 0-2.94-0.74-2.93-0.76 0.75-0.87zm316.06 0.09c-1.93 0.05-2.53 0.41-2.53 1.31 0 1.2 1 1.49 4.62 1.25 6.22-0.4 6.44-2.23 0.31-2.53-0.96-0.04-1.76-0.05-2.4-0.03zm-296.22 0.22c1.97 0.01 3.28 0.13 3.12 0.38-0.3 0.49-4.62 0.99-9.62 1.09s-8.91-0.02-8.66-0.25c0.63-0.55 7.83-1.08 13-1.19 0.78-0.02 1.5-0.03 2.16-0.03zm223.84 0.69c-0.8 0-1.58 0.04-2.18 0.15-1.22 0.24-0.25 0.41 2.18 0.41 2.44 0 3.44-0.17 2.22-0.41-0.61-0.11-1.41-0.15-2.22-0.15zm-268.53 0.84c-5.246 0-8.874 0.42-8.874 1-0.001 0.58 3.628 0.97 8.874 0.97 5.247 0 8.848-0.39 8.848-0.97s-3.601-1-8.848-1zm298.53 1c-2.68 0-3.08 0.92-1.25 2.75 1.43 1.42 12.57 1.59 12.57 0.19 0-0.54-1.98-0.97-4.41-0.97s-4.44-0.46-4.44-1-1.11-0.97-2.47-0.97zm-39.81 0.13c-0.44 0-0.91 0.05-1.25 0.18-0.68 0.28-0.1 0.5 1.25 0.5s1.9-0.22 1.22-0.5c-0.34-0.13-0.77-0.18-1.22-0.18zm-99.5 0.28c1.17-0.05 3.18 0.42 4.78 1.09 3.26 1.36 3.29 1.43 1.75 3.78-0.87 1.33-2.24 2.65-3 2.94-1.94 0.74-2.83-1.12-1.37-2.87 1.84-2.22 0.3-2.88-2.47-1.07-2.29 1.5-2.4 1.5-1.81-0.03 0.42-1.1 0.27-1.38-0.5-0.9-0.64 0.39-1.19 0.21-1.19-0.38 0-0.77-0.56-0.79-1.97-0.03-1.3 0.69-1.97 0.72-1.97 0.06 0-0.9 1-1.25 7.31-2.53 0.13-0.03 0.27-0.06 0.44-0.06zm-159.22 1.56c-1.623 0-2.968 0.32-2.968 0.75s1.345 0.91 2.968 1.03c1.624 0.12 2.938-0.23 2.938-0.78s-1.314-1-2.938-1zm266.72 0c-2.08 0.06-5.36 0.5-6.53 1.03-1.32 0.6-0.37 0.69 2.94 0.28 2.7-0.33 5.12-0.77 5.34-0.97 0.32-0.28-0.5-0.38-1.75-0.34zm-202.69 0.12c-0.34 0.02-0.65 0.09-0.81 0.26-0.33 0.32 0.28 0.54 1.31 0.5 1.15-0.05 1.35-0.28 0.57-0.6-0.36-0.14-0.72-0.17-1.07-0.16zm-11.4 1.85c-1.9 0-3.44 0.43-3.44 0.97s1.54 0.97 3.44 0.97c1.89 0 3.44-0.43 3.44-0.97s-1.55-0.97-3.44-0.97z"/>
						 <rect id="rect8" height="10.014" width="420.03" y="430.82" x="63.422"/>
						 <path id="path10" d="m543.54 276.94a276.23 276.23 0 1 1 -552.47 0 276.23 276.23 0 1 1 552.47 0z" transform="matrix(.95831 0 0 .95831 17.669 8.4373)" stroke="#000" stroke-linecap="round" stroke-miterlimit="2.41" stroke-width="9.7" fill="none"/>
						 <path id="path12" d="m207.05 63.887c0 1.932 0 3.667-0.03 5.205-0.02 1.537-0.08 2.752-0.18 3.646-0.07 0.612-0.19 1.122-0.35 1.532-0.17 0.409-0.45 0.66-0.85 0.753-0.19 0.043-0.41 0.081-0.66 0.114s-0.53 0.05-0.84 0.052c-0.24 0.001-0.42 0.03-0.52 0.088s-0.15 0.14-0.14 0.244c0 0.284 0.28 0.423 0.83 0.416 0.42-0.004 0.88-0.017 1.38-0.042 0.51-0.024 1-0.038 1.48-0.041 0.51-0.02 0.97-0.032 1.39-0.037 0.42-0.004 0.75-0.006 0.98-0.005 0.33 0 0.77 0.011 1.33 0.031 0.56 0.021 1.15 0.052 1.79 0.094 0.62 0.023 1.19 0.049 1.72 0.078 0.53 0.028 0.92 0.044 1.19 0.047 3.8-0.1 6.61-1.054 8.41-2.862s2.7-3.874 2.68-6.196c-0.1-2.428-0.94-4.386-2.5-5.875-1.57-1.488-3.26-2.521-5.06-3.1 1.18-0.89 2.17-1.905 2.98-3.044 0.8-1.139 1.22-2.548 1.26-4.227 0.1-1.224-0.44-2.538-1.61-3.943-1.17-1.404-3.58-2.168-7.24-2.29-0.7 0.005-1.47 0.026-2.3 0.062-0.84 0.037-1.76 0.057-2.77 0.063-0.46-0.006-1.23-0.026-2.31-0.063-1.08-0.036-2.2-0.057-3.34-0.062-0.31-0.003-0.54 0.023-0.69 0.078-0.15 0.054-0.23 0.153-0.23 0.296s0.06 0.241 0.18 0.296c0.13 0.055 0.3 0.08 0.53 0.078 0.3 0 0.6 0.01 0.9 0.031s0.54 0.052 0.72 0.094c0.67 0.137 1.13 0.392 1.38 0.763 0.24 0.371 0.38 0.906 0.41 1.605 0.04 0.554 0.06 1.399 0.07 2.534 0.01 1.136 0.01 3.228 0.01 6.275v7.312zm4.99-16.869c-0.01-0.224 0.02-0.389 0.07-0.493 0.06-0.105 0.16-0.176 0.3-0.213 0.2-0.04 0.41-0.064 0.62-0.073 0.22-0.009 0.47-0.012 0.75-0.01 1.78 0.094 3.09 0.819 3.94 2.176 0.84 1.356 1.26 2.778 1.25 4.264 0 1.02-0.15 1.899-0.44 2.638-0.3 0.74-0.72 1.328-1.26 1.766-0.35 0.306-0.76 0.515-1.25 0.629-0.48 0.113-1.06 0.167-1.74 0.161-0.48 0-0.87-0.011-1.2-0.032-0.32-0.02-0.57-0.051-0.75-0.093-0.09-0.016-0.16-0.056-0.21-0.12-0.05-0.063-0.08-0.175-0.08-0.337v-10.263zm9.51 21.855c-0.09 2.113-0.7 3.539-1.81 4.28-1.12 0.741-2.19 1.087-3.22 1.039-0.47 0.008-0.96-0.018-1.45-0.078-0.5-0.06-1.02-0.2-1.58-0.421-0.64-0.231-1.05-0.62-1.23-1.168-0.17-0.548-0.25-1.488-0.22-2.821v-9.847c0-0.201 0.08-0.298 0.25-0.291 0.3-0.001 0.58 0.001 0.84 0.005 0.27 0.005 0.58 0.017 0.94 0.037 0.8 0.039 1.47 0.137 2.01 0.296 0.53 0.158 1.02 0.392 1.44 0.701 1.55 1.147 2.62 2.478 3.2 3.994s0.86 2.94 0.83 4.274zm14.88-4.986c0 2.032-0.01 3.827-0.03 5.386s-0.08 2.783-0.18 3.672c-0.05 0.604-0.17 1.08-0.34 1.429-0.17 0.348-0.46 0.565-0.87 0.649-0.18 0.043-0.4 0.081-0.65 0.114s-0.53 0.05-0.84 0.052c-0.25 0.001-0.42 0.03-0.52 0.088s-0.15 0.14-0.15 0.244c0.01 0.284 0.29 0.423 0.84 0.416 0.88-0.005 1.84-0.026 2.88-0.062 1.03-0.037 1.82-0.058 2.35-0.063 0.59 0.005 1.47 0.026 2.63 0.063 1.17 0.036 2.45 0.057 3.85 0.062 0.24 0.001 0.42-0.032 0.57-0.099 0.14-0.066 0.22-0.172 0.22-0.317 0.01-0.214-0.21-0.325-0.66-0.332-0.33-0.002-0.69-0.019-1.08-0.052s-0.74-0.071-1.04-0.114c-0.61-0.088-1.03-0.307-1.25-0.66-0.23-0.352-0.37-0.811-0.41-1.376-0.08-0.909-0.13-2.145-0.15-3.708-0.02-1.564-0.02-3.361-0.02-5.392v-7.312c0-3.047 0-5.139 0.01-6.275 0.01-1.135 0.03-1.98 0.07-2.534 0.03-0.722 0.16-1.273 0.38-1.652s0.61-0.618 1.16-0.716c0.24-0.042 0.46-0.073 0.65-0.094 0.2-0.021 0.39-0.031 0.6-0.031 0.21 0.003 0.37-0.024 0.48-0.083 0.12-0.059 0.18-0.17 0.18-0.333 0-0.123-0.08-0.209-0.23-0.259-0.16-0.05-0.37-0.075-0.64-0.073-0.84 0.005-1.75 0.026-2.74 0.062-0.99 0.037-1.76 0.057-2.33 0.063-0.65-0.006-1.51-0.026-2.56-0.063-1.05-0.036-2-0.057-2.84-0.062-0.33-0.002-0.58 0.022-0.75 0.073-0.17 0.05-0.25 0.136-0.25 0.259 0 0.163 0.06 0.274 0.18 0.333 0.11 0.059 0.28 0.086 0.49 0.083 0.25-0.001 0.5 0.011 0.76 0.036s0.5 0.069 0.73 0.13c0.46 0.1 0.79 0.337 1.02 0.712 0.22 0.374 0.36 0.913 0.39 1.615 0.04 0.554 0.07 1.399 0.08 2.534 0.01 1.136 0.01 3.228 0.01 6.275v7.312zm18.74 0c0.01 1.932 0 3.667-0.02 5.205-0.02 1.537-0.08 2.752-0.18 3.646-0.07 0.612-0.19 1.122-0.36 1.532-0.16 0.409-0.45 0.66-0.85 0.753-0.19 0.043-0.4 0.081-0.65 0.114s-0.53 0.05-0.84 0.052c-0.25 0.001-0.42 0.03-0.52 0.088s-0.15 0.14-0.15 0.244c0.01 0.284 0.28 0.423 0.83 0.416 0.89-0.005 1.85-0.026 2.88-0.062 1.04-0.037 1.82-0.058 2.36-0.063 0.57 0.005 1.43 0.026 2.59 0.063 1.17 0.036 2.45 0.057 3.85 0.062 0.23 0.001 0.42-0.032 0.56-0.099 0.15-0.066 0.22-0.172 0.23-0.317 0-0.214-0.22-0.325-0.67-0.332-0.32-0.002-0.68-0.019-1.07-0.052-0.4-0.033-0.74-0.071-1.05-0.114-0.6-0.094-1.01-0.343-1.23-0.748-0.21-0.405-0.34-0.904-0.39-1.496-0.1-0.913-0.16-2.141-0.18-3.682-0.02-1.542-0.03-3.278-0.03-5.21v-16.62c0.01-0.45 0.12-0.713 0.34-0.789 0.19-0.062 0.43-0.105 0.71-0.13 0.29-0.025 0.59-0.037 0.91-0.036 0.5-0.019 1.12 0.08 1.87 0.296 0.75 0.215 1.51 0.657 2.28 1.324 1.12 1.083 1.82 2.21 2.1 3.381s0.4 2.122 0.35 2.852c-0.08 2.139-0.72 3.812-1.91 5.017-1.18 1.205-2.4 1.818-3.65 1.838-0.43-0.001-0.74 0.033-0.91 0.104-0.18 0.071-0.26 0.189-0.26 0.353 0.01 0.141 0.07 0.234 0.17 0.281 0.11 0.047 0.22 0.078 0.33 0.093 0.12 0.02 0.26 0.032 0.44 0.037 0.17 0.004 0.32 0.006 0.43 0.005 3.01-0.05 5.45-0.989 7.33-2.815 1.87-1.827 2.84-4.24 2.9-7.24-0.03-1.115-0.27-2.105-0.7-2.971-0.44-0.866-0.9-1.524-1.38-1.974-0.29-0.371-1.01-0.844-2.17-1.418-1.15-0.573-3.01-0.89-5.56-0.95-0.98 0.005-2.01 0.026-3.09 0.062-1.08 0.037-2.06 0.057-2.94 0.063-0.62-0.006-1.48-0.026-2.6-0.063-1.11-0.036-2.24-0.057-3.38-0.062-0.31-0.003-0.54 0.023-0.69 0.078-0.15 0.054-0.22 0.153-0.22 0.296s0.06 0.241 0.18 0.296 0.29 0.08 0.52 0.078c0.3 0 0.61 0.01 0.91 0.031s0.54 0.052 0.71 0.094c0.67 0.137 1.13 0.392 1.38 0.763s0.39 0.906 0.41 1.605c0.04 0.554 0.06 1.399 0.07 2.534 0.01 1.136 0.02 3.228 0.01 6.275v7.312zm24.61 7.895c-0.08 0.739-0.25 1.432-0.49 2.077-0.24 0.646-0.64 1.048-1.21 1.205-0.3 0.06-0.55 0.096-0.73 0.109-0.19 0.013-0.36 0.019-0.52 0.016-0.21-0.001-0.37 0.022-0.48 0.068-0.12 0.045-0.18 0.12-0.18 0.223 0 0.183 0.08 0.305 0.22 0.369 0.14 0.063 0.31 0.092 0.53 0.088 0.7-0.005 1.45-0.026 2.26-0.062 0.8-0.037 1.42-0.058 1.85-0.063 0.4 0.005 1 0.026 1.81 0.063 0.8 0.036 1.66 0.057 2.55 0.062 0.32 0.004 0.56-0.025 0.74-0.088 0.17-0.064 0.26-0.186 0.26-0.369 0-0.103-0.07-0.178-0.19-0.223-0.12-0.046-0.26-0.069-0.43-0.068-0.21 0.002-0.46-0.012-0.75-0.042-0.29-0.029-0.62-0.084-1-0.166-0.36-0.078-0.65-0.222-0.89-0.431-0.23-0.208-0.35-0.508-0.35-0.898 0-0.326 0.01-0.641 0.03-0.946 0.02-0.304 0.05-0.64 0.09-1.007l2.16-16.537h0.17c0.79 1.693 1.65 3.511 2.56 5.453 0.92 1.943 1.51 3.2 1.76 3.771 0.2 0.447 0.61 1.293 1.24 2.538 0.63 1.244 1.28 2.53 1.97 3.858 0.68 1.327 1.2 2.339 1.57 3.036 0.33 0.632 0.6 1.134 0.83 1.506s0.44 0.563 0.62 0.571c0.17 0.025 0.35-0.118 0.55-0.431 0.2-0.312 0.53-0.944 0.99-1.895l9.06-18.864h0.16l2.5 18.282c0.08 0.578 0.09 1.011 0.05 1.298-0.05 0.288-0.13 0.45-0.26 0.489-0.15 0.06-0.26 0.126-0.34 0.197s-0.12 0.157-0.12 0.26c-0.01 0.123 0.07 0.219 0.25 0.29 0.17 0.071 0.49 0.127 0.96 0.167 0.6 0.042 1.5 0.082 2.69 0.12 1.19 0.037 2.34 0.068 3.46 0.092s1.88 0.036 2.28 0.037c0.3 0.002 0.55-0.033 0.76-0.104 0.2-0.071 0.31-0.189 0.32-0.353 0-0.121-0.07-0.201-0.19-0.239-0.13-0.038-0.28-0.055-0.47-0.052-0.27 0.006-0.62-0.016-1.04-0.067-0.43-0.052-0.94-0.168-1.54-0.348-0.61-0.175-1.06-0.594-1.35-1.257s-0.52-1.643-0.69-2.94l-3.78-25.678c-0.12-0.866-0.37-1.295-0.74-1.288-0.19 0-0.34 0.083-0.48 0.249-0.13 0.166-0.28 0.416-0.44 0.748l-11.3 23.725-11.34-23.434c-0.27-0.526-0.48-0.876-0.64-1.049-0.17-0.173-0.33-0.253-0.49-0.239-0.34 0.007-0.57 0.367-0.7 1.08l-4.12 27.091z"/>
						 <path id="path14" d="m162.68 489.86c-0.34 0.57-0.72 1.09-1.16 1.53-0.43 0.45-0.9 0.64-1.43 0.56-0.27-0.06-0.49-0.11-0.64-0.17-0.16-0.06-0.3-0.11-0.43-0.17-0.18-0.08-0.32-0.12-0.43-0.12-0.11-0.01-0.19 0.03-0.23 0.12-0.06 0.15-0.04 0.28 0.05 0.38s0.23 0.19 0.41 0.27c0.58 0.24 1.21 0.5 1.88 0.76 0.68 0.26 1.2 0.46 1.56 0.61 0.33 0.15 0.82 0.39 1.47 0.71s1.35 0.64 2.09 0.97c0.26 0.12 0.47 0.18 0.64 0.19 0.16 0.01 0.28-0.06 0.35-0.21 0.03-0.09 0.01-0.17-0.08-0.25-0.08-0.08-0.19-0.15-0.33-0.21-0.18-0.08-0.38-0.18-0.61-0.31s-0.48-0.29-0.76-0.49c-0.27-0.2-0.46-0.42-0.58-0.68-0.11-0.26-0.11-0.55 0.03-0.87 0.12-0.27 0.24-0.53 0.37-0.77 0.12-0.25 0.27-0.51 0.44-0.8l7.74-12.88 0.14 0.06c0.04 1.68 0.09 3.49 0.15 5.43 0.06 1.93 0.09 3.18 0.09 3.74 0.01 0.44 0.04 1.29 0.11 2.55 0.07 1.25 0.15 2.55 0.24 3.89 0.09 1.35 0.15 2.37 0.2 3.08 0.05 0.64 0.1 1.15 0.15 1.54 0.06 0.39 0.16 0.63 0.31 0.7 0.13 0.08 0.33 0.03 0.61-0.16 0.27-0.19 0.77-0.59 1.49-1.21l14.29-12.32 0.13 0.06-4.53 16c-0.14 0.51-0.28 0.87-0.42 1.09-0.14 0.23-0.27 0.33-0.39 0.31-0.14 0-0.26 0.01-0.35 0.05-0.09 0.03-0.16 0.08-0.19 0.17-0.06 0.09-0.02 0.2 0.09 0.32 0.12 0.13 0.37 0.29 0.74 0.49 0.48 0.25 1.21 0.61 2.18 1.07s1.91 0.9 2.83 1.32c0.91 0.43 1.54 0.71 1.87 0.85 0.24 0.11 0.46 0.18 0.66 0.19 0.2 0.02 0.33-0.04 0.39-0.17 0.04-0.11 0.02-0.19-0.07-0.27s-0.21-0.15-0.37-0.21c-0.22-0.1-0.5-0.24-0.83-0.43-0.34-0.2-0.72-0.48-1.15-0.85-0.44-0.36-0.66-0.87-0.66-1.52s0.16-1.54 0.49-2.68l6.13-22.57c0.21-0.77 0.16-1.21-0.15-1.34-0.15-0.06-0.31-0.05-0.48 0.04s-0.39 0.24-0.64 0.46l-17.89 15.53-0.92-23.45c-0.03-0.53-0.08-0.9-0.15-1.1s-0.18-0.33-0.31-0.37c-0.29-0.12-0.61 0.09-0.98 0.64l-13.16 20.9zm39.96 8.38c-0.48 1.67-0.93 3.17-1.33 4.49-0.41 1.33-0.77 2.36-1.08 3.11-0.22 0.51-0.45 0.93-0.69 1.24-0.25 0.31-0.56 0.46-0.93 0.44-0.17-0.01-0.37-0.04-0.6-0.07-0.22-0.04-0.47-0.09-0.74-0.17-0.21-0.06-0.37-0.08-0.47-0.05-0.1 0.02-0.16 0.08-0.19 0.17-0.06 0.25 0.14 0.44 0.62 0.57 0.37 0.1 0.77 0.21 1.21 0.31 0.44 0.11 0.87 0.22 1.29 0.34 0.44 0.11 0.85 0.22 1.21 0.32s0.65 0.18 0.85 0.24c0.53 0.16 1.09 0.33 1.69 0.52 0.59 0.2 1.26 0.42 2.02 0.68 0.76 0.25 1.65 0.53 2.66 0.85s2.19 0.68 3.53 1.07c0.65 0.22 1.13 0.31 1.42 0.29s0.56-0.24 0.79-0.66c0.22-0.4 0.52-1.02 0.87-1.86 0.36-0.85 0.61-1.51 0.76-1.99 0.06-0.18 0.09-0.34 0.1-0.47s-0.06-0.22-0.2-0.26c-0.12-0.04-0.22-0.02-0.3 0.04-0.08 0.07-0.16 0.2-0.25 0.38-0.33 0.7-0.68 1.22-1.05 1.56-0.38 0.35-0.82 0.56-1.34 0.63-0.55 0.07-1.15 0.03-1.8-0.11s-1.22-0.29-1.71-0.44c-1.79-0.49-2.9-1.03-3.34-1.6-0.43-0.58-0.46-1.47-0.09-2.68 0.16-0.62 0.42-1.52 0.78-2.72 0.35-1.2 0.64-2.15 0.84-2.85l0.83-2.84c0.03-0.11 0.07-0.2 0.12-0.25 0.05-0.06 0.11-0.07 0.2-0.05 0.55 0.16 1.42 0.42 2.61 0.79 1.2 0.37 2.02 0.64 2.47 0.81 0.63 0.26 1.06 0.56 1.29 0.9s0.34 0.7 0.31 1.09c-0.02 0.25-0.05 0.49-0.1 0.71-0.05 0.23-0.1 0.44-0.13 0.62-0.03 0.09-0.03 0.18 0 0.25 0.03 0.08 0.1 0.13 0.23 0.17 0.15 0.03 0.27-0.02 0.35-0.15 0.07-0.14 0.13-0.28 0.17-0.44 0.05-0.16 0.17-0.5 0.36-1.01 0.18-0.51 0.35-0.96 0.48-1.36 0.34-0.87 0.59-1.49 0.76-1.86 0.17-0.36 0.27-0.59 0.3-0.68 0.03-0.1 0.03-0.19-0.01-0.24-0.03-0.06-0.09-0.1-0.16-0.12-0.09-0.02-0.19-0.01-0.3 0.05s-0.25 0.14-0.41 0.25c-0.21 0.13-0.47 0.19-0.77 0.19-0.31-0.01-0.68-0.06-1.11-0.15-0.33-0.07-0.89-0.22-1.7-0.44-0.81-0.23-1.62-0.46-2.42-0.69s-1.35-0.39-1.66-0.48c-0.1-0.03-0.16-0.08-0.18-0.16-0.01-0.08 0.01-0.18 0.04-0.31l2.66-9.09c0.06-0.25 0.18-0.35 0.35-0.29 0.28 0.08 0.78 0.24 1.51 0.46 0.72 0.23 1.43 0.45 2.14 0.69 0.71 0.23 1.18 0.39 1.42 0.48 0.84 0.36 1.38 0.7 1.64 1.01s0.39 0.64 0.39 0.99c0.02 0.25 0.01 0.51-0.03 0.77-0.05 0.25-0.09 0.45-0.13 0.59-0.05 0.16-0.07 0.29-0.04 0.39 0.02 0.1 0.09 0.17 0.21 0.2 0.13 0.04 0.23 0.02 0.3-0.05 0.08-0.07 0.14-0.15 0.18-0.24 0.11-0.25 0.27-0.64 0.46-1.18 0.19-0.53 0.33-0.91 0.41-1.14 0.29-0.78 0.52-1.33 0.68-1.64 0.16-0.3 0.25-0.51 0.29-0.61 0.03-0.09 0.04-0.17 0.03-0.24-0.02-0.07-0.06-0.12-0.15-0.15-0.09-0.02-0.2-0.03-0.31-0.02h-0.31c-0.16-0.01-0.38-0.03-0.65-0.07-0.28-0.05-0.6-0.1-0.96-0.17-0.31-0.07-1.1-0.3-2.38-0.66-1.29-0.37-2.59-0.75-3.93-1.14-1.33-0.38-2.23-0.65-2.69-0.78-0.25-0.08-0.57-0.18-0.96-0.31-0.39-0.12-0.81-0.27-1.28-0.42-0.45-0.14-0.93-0.28-1.43-0.44l-1.47-0.45c-0.27-0.08-0.48-0.11-0.62-0.1-0.14 0-0.23 0.07-0.27 0.2-0.03 0.12-0.01 0.22 0.08 0.3 0.09 0.07 0.24 0.14 0.44 0.2 0.26 0.07 0.52 0.16 0.77 0.25 0.26 0.1 0.46 0.18 0.6 0.26 0.54 0.29 0.88 0.63 1 1.01 0.12 0.39 0.1 0.88-0.05 1.49-0.11 0.49-0.3 1.23-0.58 2.22-0.28 0.98-0.8 2.79-1.57 5.43l-1.85 6.33zm26.73 6.73c-0.31 1.72-0.6 3.25-0.87 4.61s-0.52 2.43-0.75 3.21c-0.15 0.53-0.33 0.97-0.55 1.3-0.22 0.34-0.51 0.51-0.89 0.53-0.17 0.01-0.37 0.01-0.6-0.01-0.22-0.01-0.48-0.04-0.75-0.09-0.22-0.04-0.38-0.04-0.48 0-0.09 0.03-0.15 0.1-0.17 0.19-0.03 0.25 0.19 0.42 0.67 0.5 0.79 0.14 1.65 0.28 2.57 0.42 0.93 0.13 1.62 0.24 2.1 0.32 0.54 0.1 1.32 0.27 2.35 0.49 1.04 0.22 2.17 0.45 3.41 0.68 0.21 0.04 0.38 0.04 0.52 0 0.14-0.03 0.22-0.11 0.25-0.24 0.04-0.19-0.14-0.33-0.54-0.4-0.28-0.06-0.6-0.13-0.94-0.22-0.34-0.1-0.65-0.19-0.91-0.27-0.52-0.19-0.84-0.47-0.97-0.87-0.13-0.39-0.16-0.85-0.1-1.39 0.06-0.82 0.2-1.92 0.43-3.29s0.51-2.91 0.82-4.63l2.76-15.1 4.62 0.96c1.61 0.35 2.69 0.79 3.25 1.31 0.57 0.53 0.81 1.04 0.73 1.55l-0.04 0.41c-0.04 0.27-0.04 0.47 0 0.59 0.03 0.12 0.12 0.2 0.27 0.22 0.11 0.02 0.2-0.02 0.26-0.12 0.07-0.09 0.13-0.23 0.18-0.41 0.1-0.55 0.26-1.28 0.46-2.2 0.2-0.91 0.34-1.6 0.43-2.05 0.05-0.28 0.07-0.48 0.06-0.61-0.02-0.13-0.09-0.2-0.21-0.22-0.08-0.01-0.19-0.02-0.36-0.01-0.16 0-0.39 0-0.67 0.01-0.28-0.01-0.64-0.03-1.06-0.07s-0.93-0.11-1.52-0.21l-14.59-2.66c-0.62-0.12-1.25-0.25-1.89-0.4s-1.22-0.31-1.76-0.46c-0.44-0.13-0.77-0.28-0.98-0.44s-0.39-0.25-0.52-0.29c-0.11-0.02-0.21 0.02-0.3 0.12-0.08 0.1-0.18 0.27-0.27 0.5-0.06 0.12-0.2 0.48-0.44 1.05-0.23 0.58-0.46 1.17-0.69 1.78s-0.37 1.03-0.42 1.26c-0.04 0.2-0.04 0.36-0.01 0.46 0.03 0.11 0.11 0.17 0.23 0.19 0.11 0.02 0.21 0 0.28-0.06 0.08-0.06 0.15-0.17 0.21-0.31s0.16-0.31 0.3-0.51 0.33-0.42 0.56-0.66c0.33-0.35 0.78-0.55 1.34-0.59 0.57-0.05 1.38 0.01 2.43 0.17l5.52 0.86-2.76 15.1zm20.29 3.06c-0.13 1.74-0.26 3.29-0.38 4.68-0.13 1.38-0.26 2.46-0.41 3.26-0.11 0.54-0.25 1-0.43 1.35-0.17 0.36-0.44 0.57-0.81 0.62-0.17 0.03-0.37 0.05-0.6 0.06s-0.48 0.01-0.76-0.01c-0.22-0.02-0.38 0-0.47 0.04-0.1 0.05-0.15 0.12-0.15 0.21-0.01 0.26 0.23 0.4 0.72 0.43 0.8 0.06 1.66 0.1 2.59 0.14 0.94 0.04 1.64 0.08 2.12 0.11 0.51 0.04 1.29 0.12 2.33 0.23s2.19 0.22 3.45 0.32c0.21 0.02 0.38 0 0.52-0.05 0.13-0.05 0.21-0.14 0.22-0.27 0.02-0.19-0.17-0.31-0.57-0.34-0.3-0.03-0.62-0.07-0.97-0.12-0.35-0.06-0.66-0.12-0.93-0.18-0.53-0.12-0.89-0.37-1.05-0.75-0.17-0.38-0.25-0.84-0.25-1.37-0.03-0.83 0-1.94 0.09-3.33 0.08-1.38 0.2-2.95 0.33-4.68l1.14-14.94c0.04-0.4 0.15-0.63 0.35-0.69 0.18-0.04 0.4-0.06 0.66-0.06 0.25-0.01 0.53 0 0.81 0.03 0.45 0.01 1 0.15 1.67 0.39 0.66 0.25 1.31 0.69 1.95 1.35 0.94 1.05 1.49 2.11 1.66 3.18s0.21 1.93 0.12 2.59c-0.22 1.91-0.91 3.37-2.06 4.38-1.15 1-2.29 1.46-3.41 1.4-0.39-0.03-0.66-0.02-0.83 0.03-0.16 0.05-0.24 0.15-0.25 0.3 0 0.13 0.04 0.21 0.14 0.26 0.09 0.05 0.18 0.09 0.28 0.11s0.23 0.05 0.39 0.06c0.16 0.02 0.29 0.03 0.39 0.04 2.71 0.16 4.97-0.52 6.78-2.03 1.81-1.52 2.84-3.62 3.1-6.31 0.05-1.01-0.09-1.91-0.42-2.72s-0.7-1.43-1.11-1.87c-0.23-0.35-0.85-0.83-1.85-1.42-1-0.6-2.64-1.01-4.93-1.24-0.88-0.06-1.81-0.11-2.78-0.15-0.98-0.04-1.86-0.09-2.65-0.15-0.55-0.04-1.33-0.12-2.33-0.23s-2.01-0.21-3.04-0.29c-0.27-0.02-0.48-0.01-0.62 0.02-0.14 0.04-0.21 0.13-0.22 0.26-0.01 0.12 0.04 0.22 0.14 0.27 0.1 0.06 0.26 0.1 0.47 0.11 0.27 0.02 0.54 0.05 0.81 0.09s0.48 0.08 0.63 0.13c0.6 0.17 0.99 0.43 1.19 0.78s0.28 0.84 0.26 1.47c0 0.5-0.04 1.27-0.11 2.29s-0.21 2.9-0.42 5.64l-0.5 6.57zm18.94-2.51c0.1 2.19 0.73 4.28 1.91 6.25 1.17 1.97 2.88 3.56 5.13 4.76l-2.96 0.13c-0.73 0.03-1.41-0.03-2.04-0.21-0.63-0.17-1.1-0.46-1.42-0.88-0.12-0.16-0.25-0.41-0.39-0.73s-0.26-0.72-0.36-1.18c-0.05-0.21-0.1-0.35-0.16-0.43-0.06-0.09-0.15-0.13-0.28-0.12-0.14 0.01-0.23 0.08-0.25 0.21-0.03 0.13-0.04 0.29-0.02 0.48 0.02 0.33 0.07 0.89 0.16 1.7 0.09 0.8 0.18 1.6 0.29 2.39s0.21 1.33 0.28 1.61c0.13 0.46 0.34 0.74 0.61 0.83 0.28 0.09 0.77 0.11 1.45 0.06 1.5-0.07 3.11-0.15 4.83-0.25s3.03-0.18 3.93-0.24c0.38 0.02 0.6 0.03 0.67 0.04 0.06 0 0.28-0.01 0.64-0.02 0.11-0.01 0.18-0.05 0.21-0.12s0.04-0.17 0.03-0.31l-0.07-1.79c-2.09-1.08-3.76-2.86-4.99-5.33-1.24-2.47-1.93-5.03-2.06-7.68-0.09-1.66 0.11-3.38 0.6-5.15 0.49-1.78 1.42-3.31 2.77-4.59s3.27-2 5.75-2.16c3.51-0.05 6.07 1.06 7.69 3.32 1.63 2.26 2.49 5.07 2.6 8.42 0.12 3.58-0.38 6.33-1.48 8.27-1.11 1.93-2.57 3.47-4.37 4.62l0.07 1.79c0.01 0.14 0.03 0.24 0.06 0.31 0.04 0.07 0.11 0.1 0.22 0.09 0.36-0.01 0.58-0.02 0.64-0.03 0.07-0.01 0.29-0.04 0.67-0.1 0.89-0.01 2.2-0.05 3.93-0.1 1.73-0.04 3.34-0.1 4.83-0.16 0.69-0.01 1.17-0.07 1.44-0.19 0.27-0.11 0.45-0.4 0.54-0.87 0.06-0.32 0.11-0.88 0.15-1.68s0.07-1.6 0.08-2.4c0.02-0.8 0.02-1.35 0.01-1.67 0-0.19-0.02-0.35-0.06-0.47-0.04-0.13-0.13-0.19-0.27-0.19-0.13 0-0.22 0.05-0.27 0.14s-0.09 0.24-0.12 0.44c-0.05 0.47-0.14 0.89-0.26 1.26s-0.27 0.67-0.47 0.91c-0.35 0.42-0.84 0.72-1.48 0.9s-1.36 0.28-2.18 0.31l-2.88 0.12c2.02-1.68 3.62-3.53 4.8-5.53 1.17-2.01 1.72-4.27 1.64-6.78-0.19-3.97-1.54-7.09-4.05-9.36s-6.01-3.34-10.51-3.21c-2.27 0.09-4.59 0.68-6.97 1.77-2.37 1.08-4.36 2.69-5.96 4.81s-2.36 4.78-2.3 7.99zm59.66-16.67c0.36-0.93 0.7-1.68 1.01-2.26s0.66-0.97 1.05-1.17c0.48-0.26 0.9-0.43 1.27-0.5 0.19-0.04 0.32-0.1 0.41-0.18s0.13-0.17 0.11-0.28c-0.03-0.11-0.11-0.18-0.24-0.21-0.12-0.03-0.29-0.02-0.49 0.02-0.7 0.16-1.37 0.32-2.02 0.49-0.65 0.18-1.16 0.31-1.55 0.39-0.37 0.08-0.89 0.17-1.57 0.28-0.67 0.11-1.38 0.25-2.11 0.4-0.52 0.11-0.75 0.27-0.7 0.49 0.03 0.13 0.09 0.21 0.19 0.24s0.2 0.03 0.32 0c0.15-0.04 0.34-0.07 0.56-0.11 0.22-0.03 0.43-0.04 0.63-0.03 0.2 0.02 0.37 0.08 0.51 0.18s0.23 0.21 0.26 0.34c0.03 0.16 0.04 0.37 0.04 0.64-0.01 0.26-0.06 0.55-0.15 0.84-0.13 0.44-0.41 1.23-0.85 2.38-0.43 1.15-0.89 2.34-1.36 3.57-0.48 1.23-0.85 2.18-1.11 2.85-0.99-1.09-2.02-2.22-3.1-3.4-1.08-1.17-2.18-2.4-3.29-3.7-0.15-0.18-0.28-0.36-0.39-0.54s-0.17-0.33-0.2-0.44-0.02-0.23 0.02-0.36c0.05-0.12 0.14-0.23 0.29-0.32s0.31-0.16 0.5-0.23c0.19-0.06 0.34-0.1 0.46-0.13 0.17-0.03 0.3-0.08 0.38-0.15 0.09-0.07 0.12-0.17 0.1-0.3-0.03-0.12-0.1-0.2-0.23-0.22s-0.32-0.01-0.57 0.05c-0.73 0.16-1.48 0.34-2.27 0.54-0.78 0.21-1.33 0.34-1.63 0.41-0.93 0.2-1.97 0.4-3.11 0.61s-1.97 0.37-2.48 0.48c-0.24 0.05-0.41 0.11-0.53 0.18-0.11 0.07-0.16 0.16-0.14 0.27 0.03 0.12 0.08 0.21 0.16 0.25 0.08 0.05 0.18 0.06 0.29 0.03 0.18-0.04 0.42-0.07 0.7-0.08 0.27-0.02 0.57-0.02 0.89 0.01 0.67 0.06 1.3 0.27 1.88 0.62 0.58 0.34 1.16 0.84 1.75 1.47l8.54 9.09-4.85 11.5c-0.42 0.99-0.8 1.74-1.16 2.26-0.35 0.51-0.77 0.89-1.25 1.13-0.27 0.13-0.52 0.24-0.76 0.31-0.24 0.08-0.42 0.13-0.56 0.16-0.15 0.03-0.26 0.09-0.35 0.16-0.08 0.08-0.11 0.17-0.09 0.28 0.05 0.22 0.25 0.29 0.62 0.21l0.62-0.13c0.34-0.08 0.84-0.2 1.49-0.38 0.65-0.17 1.17-0.3 1.56-0.39 0.54-0.11 1.2-0.23 2-0.37s1.29-0.23 1.47-0.26l0.66-0.14c0.24-0.05 0.42-0.11 0.53-0.19 0.11-0.07 0.16-0.17 0.13-0.3-0.03-0.11-0.09-0.18-0.19-0.22-0.1-0.03-0.2-0.04-0.32-0.01-0.15 0.03-0.3 0.05-0.45 0.07-0.16 0.02-0.29 0.03-0.41 0.03-0.18 0-0.34-0.04-0.5-0.11-0.16-0.08-0.27-0.2-0.33-0.36-0.06-0.2-0.07-0.44-0.04-0.72s0.11-0.59 0.23-0.93l3.54-9.91c1.15 1.21 2.4 2.56 3.77 4.07 1.36 1.5 2.74 3.05 4.15 4.65 0.17 0.21 0.26 0.4 0.25 0.55 0 0.16-0.05 0.26-0.14 0.3-0.16 0.07-0.28 0.15-0.35 0.23s-0.1 0.18-0.08 0.29c0.02 0.12 0.13 0.19 0.32 0.2 0.2 0.02 0.53-0.02 1.01-0.1 1.46-0.28 2.8-0.55 4.03-0.8 1.23-0.26 2.09-0.44 2.57-0.55l1.1-0.23c0.21-0.05 0.37-0.11 0.48-0.2 0.12-0.08 0.16-0.19 0.14-0.32-0.03-0.11-0.09-0.17-0.19-0.2-0.1-0.02-0.22-0.02-0.35 0.01-0.16 0.04-0.36 0.07-0.6 0.09-0.23 0.01-0.51 0.01-0.84-0.01-0.5-0.04-0.93-0.15-1.31-0.32s-0.76-0.43-1.14-0.76c-0.48-0.42-1.46-1.41-2.97-2.99-1.51-1.57-3.04-3.18-4.59-4.82-1.55-1.63-2.63-2.75-3.23-3.36l4.15-9.93zm12.65 10.58c0.54 1.65 1.02 3.14 1.43 4.47 0.41 1.32 0.7 2.38 0.86 3.17 0.11 0.55 0.15 1.02 0.13 1.41-0.03 0.4-0.2 0.69-0.52 0.89-0.15 0.09-0.33 0.18-0.53 0.28-0.21 0.09-0.44 0.19-0.71 0.28-0.21 0.07-0.35 0.14-0.42 0.22-0.07 0.07-0.09 0.16-0.06 0.25 0.09 0.24 0.37 0.28 0.83 0.12 0.76-0.25 1.58-0.54 2.46-0.86 0.87-0.32 1.54-0.55 2-0.71 0.48-0.15 1.23-0.38 2.24-0.67 1-0.29 2.11-0.63 3.31-1.02 0.2-0.06 0.35-0.14 0.46-0.24 0.1-0.1 0.14-0.21 0.1-0.33-0.05-0.19-0.27-0.22-0.66-0.1-0.28 0.08-0.59 0.17-0.94 0.25-0.34 0.08-0.65 0.15-0.92 0.19-0.55 0.09-0.97-0.01-1.27-0.29-0.3-0.29-0.55-0.68-0.75-1.18-0.34-0.75-0.73-1.79-1.18-3.1-0.45-1.32-0.94-2.8-1.48-4.46l-4.64-14.24c-0.12-0.39-0.1-0.65 0.07-0.77 0.14-0.11 0.34-0.21 0.57-0.31 0.24-0.11 0.5-0.2 0.77-0.29 0.42-0.15 0.98-0.24 1.69-0.27 0.7-0.02 1.48 0.14 2.32 0.5 1.26 0.62 2.18 1.39 2.74 2.31 0.57 0.93 0.94 1.71 1.1 2.35 0.53 1.86 0.45 3.47-0.24 4.83-0.68 1.37-1.55 2.23-2.62 2.6-0.37 0.12-0.62 0.23-0.75 0.34s-0.17 0.24-0.12 0.38c0.05 0.11 0.13 0.18 0.23 0.19s0.21 0 0.31-0.01c0.1-0.02 0.23-0.05 0.38-0.09 0.15-0.05 0.28-0.09 0.38-0.12 2.56-0.88 4.39-2.37 5.49-4.46 1.09-2.09 1.25-4.42 0.46-7.01-0.34-0.95-0.81-1.73-1.43-2.35-0.61-0.62-1.19-1.06-1.73-1.31-0.35-0.24-1.1-0.44-2.25-0.61s-2.83 0.08-5.04 0.74c-0.84 0.28-1.71 0.58-2.63 0.91-0.91 0.34-1.75 0.63-2.5 0.88-0.53 0.16-1.28 0.39-2.24 0.67-0.97 0.28-1.94 0.58-2.92 0.89-0.27 0.08-0.46 0.17-0.57 0.26s-0.15 0.19-0.11 0.31c0.04 0.13 0.12 0.19 0.24 0.21 0.12 0.01 0.28-0.02 0.47-0.08 0.26-0.09 0.52-0.16 0.79-0.23 0.26-0.06 0.47-0.1 0.64-0.12 0.61-0.07 1.07 0.02 1.39 0.27s0.58 0.67 0.8 1.26c0.19 0.47 0.44 1.18 0.77 2.16 0.32 0.97 0.91 2.76 1.76 5.37l2.04 6.27zm16.57-9.55c0.92 2 2.3 3.69 4.14 5.06 1.84 1.38 4.02 2.2 6.56 2.46l-2.69 1.24c-0.66 0.31-1.32 0.5-1.96 0.58-0.65 0.08-1.2-0.01-1.65-0.27-0.18-0.11-0.4-0.28-0.65-0.53-0.25-0.24-0.51-0.56-0.78-0.96-0.12-0.17-0.22-0.28-0.31-0.33-0.09-0.06-0.19-0.06-0.3 0-0.13 0.06-0.18 0.16-0.16 0.29 0.03 0.12 0.08 0.27 0.17 0.44 0.14 0.3 0.4 0.8 0.79 1.51s0.78 1.41 1.18 2.1 0.69 1.16 0.88 1.39c0.29 0.38 0.58 0.56 0.88 0.53 0.29-0.02 0.74-0.18 1.36-0.49 1.35-0.63 2.81-1.32 4.37-2.07s2.74-1.32 3.54-1.71c0.36-0.13 0.57-0.2 0.63-0.22 0.07-0.02 0.26-0.11 0.59-0.26 0.1-0.05 0.15-0.11 0.15-0.19s-0.03-0.18-0.09-0.3l-0.75-1.63c-2.34-0.2-4.56-1.22-6.64-3.03-2.09-1.82-3.69-3.92-4.82-6.32-0.72-1.5-1.18-3.17-1.4-5s0.05-3.6 0.81-5.29c0.77-1.7 2.27-3.09 4.51-4.19 3.22-1.37 6.01-1.33 8.37 0.15 2.36 1.47 4.23 3.74 5.61 6.8 1.46 3.27 2.05 6 1.76 8.21s-1.05 4.19-2.28 5.94l0.75 1.63c0.05 0.12 0.11 0.21 0.17 0.26s0.14 0.05 0.24 0c0.33-0.15 0.52-0.24 0.58-0.27 0.06-0.04 0.25-0.15 0.58-0.34 0.82-0.36 2.02-0.89 3.6-1.59s3.05-1.36 4.4-1.99c0.64-0.27 1.06-0.51 1.26-0.72 0.21-0.2 0.27-0.54 0.17-1.01-0.06-0.32-0.23-0.86-0.5-1.61-0.26-0.76-0.54-1.51-0.83-2.25-0.29-0.75-0.5-1.26-0.63-1.55-0.08-0.17-0.16-0.31-0.24-0.42-0.08-0.1-0.18-0.12-0.32-0.06-0.11 0.05-0.18 0.12-0.19 0.23-0.02 0.1 0 0.25 0.05 0.45 0.13 0.46 0.21 0.88 0.24 1.27 0.03 0.38 0 0.72-0.09 1.01-0.16 0.52-0.5 0.99-1.03 1.4-0.52 0.4-1.15 0.78-1.89 1.11l-2.62 1.21c1.23-2.32 2.01-4.64 2.33-6.94s-0.03-4.6-1.05-6.9c-1.69-3.59-4.13-5.97-7.31-7.11-3.18-1.15-6.83-0.81-10.94 1.02-2.06 0.95-3.99 2.38-5.77 4.28-1.79 1.91-3.01 4.15-3.69 6.72-0.67 2.57-0.37 5.32 0.91 8.26z"/>
					</svg>
				</fo:instream-foreign-object>
			</fo:block>
		</fo:block-container>
		<!-- grey opacity -->
		<fo:block-container absolute-position="fixed" left="0" top="0" id="{concat('__internal_layout__', 'Logo-BIPM-Metro_', generate-id())}">
			<fo:block>
				<fo:instream-foreign-object content-height="{$pageHeight}mm" fox:alt-text="Background color">
					<svg xmlns="http://www.w3.org/2000/svg" version="1.0" width="215.9mm" height="279.4mm">
						<rect width="215.9mm" height="279.4mm" style="fill:rgb(255,255,255);stroke-width:0;fill-opacity:0.73"/>
						</svg>
					</fo:instream-foreign-object>
				</fo:block>
			</fo:block-container>
	</xsl:template>
	
	<xsl:template name="splitTitle">
		<xsl:param name="pText" select="."/>
		<xsl:param name="sep" select="','"/>
		<xsl:if test="string-length($pText) &gt; 0">
		<item>
			<xsl:value-of select="normalize-space(substring-before(concat($pText, $sep), $sep))"/>
		</item>
		<xsl:call-template name="splitTitle">
			<xsl:with-param name="pText" select="substring-after($pText, $sep)"/>
			<xsl:with-param name="sep" select="$sep"/>
		</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="splitByParts">
		<xsl:param name="items"/>
		<xsl:param name="start" select="1"/>
		<xsl:param name="mergeEach"/>
		<xsl:if test="xalan:nodeset($items)/item[$start]">
			<part>
				<xsl:for-each select="xalan:nodeset($items)/item[position() &gt;= $start and position() &lt;  ($start + $mergeEach)]">
					<xsl:value-of select="."/><xsl:text> </xsl:text>
				</xsl:for-each>
			</part>
		</xsl:if>
		<xsl:if test="$start &lt;= count(xalan:nodeset($items)/item)">
			<xsl:call-template name="splitByParts">
				<xsl:with-param name="items" select="$items"/>
				<xsl:with-param name="start" select="$start + $mergeEach"/>
				<xsl:with-param name="mergeEach" select="$mergeEach"/>
			</xsl:call-template>
		</xsl:if>		
	</xsl:template>

	<xsl:include href="./common.xsl"/>
	
</xsl:stylesheet>
