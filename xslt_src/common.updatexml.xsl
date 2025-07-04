<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
											xmlns:fo="http://www.w3.org/1999/XSL/Format"
											xmlns:mn="https://www.metanorma.org/ns/standoc" 
											xmlns:mnx="https://www.metanorma.org/ns/xslt" 
											xmlns:mathml="http://www.w3.org/1998/Math/MathML" 
											xmlns:xalan="http://xml.apache.org/xalan"  
											xmlns:fox="http://xmlgraphics.apache.org/fop/extensions" 
											xmlns:redirect="http://xml.apache.org/xalan/redirect"
											xmlns:java="http://xml.apache.org/xalan/java"
											exclude-result-prefixes="java redirect"
											extension-element-prefixes="redirect"
											version="1.0">
	
	<!-- ===================================== -->
	<!-- Update xml -->
	<!-- ===================================== -->
	
	<xsl:template name="updateXML">
		<xsl:if test="$debug = 'true'"><xsl:message>START updated_xml_step1</xsl:message></xsl:if>
		<xsl:variable name="startTime1" select="java:getTime(java:java.util.Date.new())"/>
		
		<!-- STEP1: Re-order elements in 'preface', 'sections' based on @displayorder -->
		<xsl:variable name="updated_xml_step1">
			<xsl:if test="$table_if = 'false'">
				<xsl:apply-templates mode="update_xml_step1"/>
			</xsl:if>
		</xsl:variable>
		
		<xsl:variable name="endTime1" select="java:getTime(java:java.util.Date.new())"/>
		<xsl:if test="$debug = 'true'">
			<xsl:message>DEBUG: processing time <xsl:value-of select="$endTime1 - $startTime1"/> msec.</xsl:message>
			<xsl:message>END updated_xml_step1</xsl:message>
			<!-- <redirect:write file="updated_xml_step1_{java:getTime(java:java.util.Date.new())}.xml">
				<xsl:copy-of select="$updated_xml_step1"/>
			</redirect:write> -->
		</xsl:if>
		
		
		<xsl:if test="$debug = 'true'"><xsl:message>START updated_xml_step2</xsl:message></xsl:if>
		<xsl:variable name="startTime2" select="java:getTime(java:java.util.Date.new())"/>
		
		<!-- STEP2: add 'fn' after 'eref' and 'origin', if referenced to bibitem with 'note' = Withdrawn.' or 'Cancelled and replaced...'  -->
		<xsl:variable name="updated_xml_step2">
			<xsl:choose>
				<xsl:when test="$namespace = 'ieee' or $namespace = 'iso' or $namespace = 'jis' or $namespace = 'plateau' or $namespace = 'bsi'">
					<xsl:if test="$table_if = 'false'">
						<xsl:apply-templates select="xalan:nodeset($updated_xml_step1)" mode="update_xml_step2"/>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="$table_if = 'false'">
						<xsl:copy-of select="$updated_xml_step1"/>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="endTime2" select="java:getTime(java:java.util.Date.new())"/>
		<xsl:if test="$debug = 'true'">
			<xsl:message>DEBUG: processing time <xsl:value-of select="$endTime2 - $startTime2"/> msec.</xsl:message>
			<xsl:message>END updated_xml_step2</xsl:message>
			<!-- <redirect:write file="updated_xml_step2_{java:getTime(java:java.util.Date.new())}.xml">
				<xsl:copy-of select="$updated_xml_step2"/>
			</redirect:write> -->
		</xsl:if>
		
		<xsl:if test="$debug = 'true'"><xsl:message>START updated_xml_step3</xsl:message></xsl:if>
		<xsl:variable name="startTime3" select="java:getTime(java:java.util.Date.new())"/>
		
		<xsl:variable name="updated_xml_step3">
			<xsl:choose>
				<xsl:when test="$table_if = 'false'">
					<xsl:apply-templates select="xalan:nodeset($updated_xml_step2)" mode="update_xml_enclose_keep-together_within-line"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="." mode="update_xml_enclose_keep-together_within-line"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="endTime3" select="java:getTime(java:java.util.Date.new())"/>
		<xsl:if test="$debug = 'true'">
			<xsl:message>DEBUG: processing time <xsl:value-of select="$endTime3 - $startTime3"/> msec.</xsl:message>
			<xsl:message>END updated_xml_step3</xsl:message>
			<!-- <redirect:write file="updated_xml_step3_{java:getTime(java:java.util.Date.new())}.xml">
				<xsl:copy-of select="$updated_xml_step3"/>
			</redirect:write> -->
		</xsl:if>
		
		<!-- <xsl:if test="$debug = 'true'"><xsl:message>START copying updated_xml_step3</xsl:message></xsl:if>
		<xsl:variable name="startTime4" select="java:getTime(java:java.util.Date.new())"/>  -->
		<xsl:copy-of select="$updated_xml_step3"/>	
		<!-- <xsl:variable name="endTime4" select="java:getTime(java:java.util.Date.new())"/>
		<xsl:if test="$debug = 'true'">
			<xsl:message>DEBUG: processing time <xsl:value-of select="$endTime4 - $startTime4"/> msec.</xsl:message>
			<xsl:message>END copying updated_xml_step3</xsl:message>
		</xsl:if> -->
		
	
	</xsl:template>

	<!-- =========================================================================== -->
	<!-- STEP1:  -->
	<!--   - Re-order elements in 'preface', 'sections' based on @displayorder -->
	<!--   - Put Section title in the correct position -->
	<!--   - Ignore 'span' without style -->
	<!--   - Remove semantic xml part -->
	<!--   - Remove image/emf (EMF vector image for Word) -->
	<!--   - add @id, redundant for table auto-layout algorithm -->
	<!--   - process 'passthrough' element -->
	<!--   - split math by element with @linebreak into maths -->
	<!--   - rename fmt-title to title, fmt-name to name and another changes to convert new presentation XML to  -->
	<!--   - old XML without significant changes in XSLT -->
	<!-- =========================================================================== -->
	<xsl:template match="@*|node()" mode="update_xml_step1">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- change section's order based on @displayorder value -->
	<xsl:template match="mn:preface" mode="update_xml_step1">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			
			<xsl:variable name="nodes_preface_">
				<xsl:for-each select="*">
					<node id="{@id}"/>
				</xsl:for-each>
			</xsl:variable>
			<xsl:variable name="nodes_preface" select="xalan:nodeset($nodes_preface_)"/>
			
			<xsl:for-each select="*">
				<xsl:sort select="@displayorder" data-type="number"/>
				
				<!-- process Section's title -->
				<xsl:variable name="preceding-sibling_id" select="$nodes_preface/node[@id = current()/@id]/preceding-sibling::node[1]/@id"/>
				<xsl:if test="$preceding-sibling_id != ''">
					<xsl:apply-templates select="parent::*/*[@type = 'section-title' and @id = $preceding-sibling_id and not(@displayorder)]" mode="update_xml_step1"/>
				</xsl:if>
				
				<xsl:choose>
					<xsl:when test="@type = 'section-title' and not(@displayorder)"><!-- skip, don't copy, because copied in above 'apply-templates' --></xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="." mode="update_xml_step1"/>
					</xsl:otherwise>
				</xsl:choose>
				
			</xsl:for-each>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="mn:sections" mode="update_xml_step1">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			
			<xsl:variable name="nodes_sections_">
				<xsl:for-each select="*">
					<node id="{@id}"/>
				</xsl:for-each>
			</xsl:variable>
			<xsl:variable name="nodes_sections" select="xalan:nodeset($nodes_sections_)"/>
			
			<!-- move section 'Normative references' inside 'sections' -->
			<xsl:for-each select="* | 
				ancestor::mn:metanorma/mn:bibliography/mn:references[@normative='true'] |
				ancestor::mn:metanorma/mn:bibliography/mn:clause[mn:references[@normative='true']]">
				<xsl:sort select="@displayorder" data-type="number"/>
				
				<!-- process Section's title -->
				<xsl:variable name="preceding-sibling_id" select="$nodes_sections/node[@id = current()/@id]/preceding-sibling::node[1]/@id"/>
				<xsl:if test="$preceding-sibling_id != ''">
					<xsl:apply-templates select="parent::*/*[@type = 'section-title' and @id = $preceding-sibling_id and not(@displayorder)]" mode="update_xml_step1"/>
				</xsl:if>
				
				<xsl:choose>
					<xsl:when test="@type = 'section-title' and not(@displayorder)"><!-- skip, don't copy, because copied in above 'apply-templates' --></xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="." mode="update_xml_step1"/>
					</xsl:otherwise>
				</xsl:choose>
				
			</xsl:for-each>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="mn:bibliography" mode="update_xml_step1">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<!-- copy all elements from bibliography except 'Normative references' (moved to 'sections') -->
			<xsl:for-each select="*[not(@normative='true') and not(*[@normative='true'])]">
				<xsl:sort select="@displayorder" data-type="number"/>
				<xsl:apply-templates select="." mode="update_xml_step1"/>
			</xsl:for-each>
		</xsl:copy>
	</xsl:template>
	
	<!-- Example with 'class': <span class="stdpublisher">ISO</span> <span class="stddocNumber">10303</span>-<span class="stddocPartNumber">1</span>:<span class="stdyear">1994</span> -->
	<xsl:template match="mn:span[@style or @class = 'stdpublisher' or @class = 'stddocNumber' or @class = 'stddocPartNumber' or @class = 'stdyear' or @class = 'fmt-hi' or @class = 'horizontal' or @class = 'norotate' or @class = 'halffontsize']" mode="update_xml_step1" priority="2">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template>
	<!-- Note: to enable the addition of character span markup with semantic styling for DIS Word output -->
	<xsl:template match="mn:span" mode="update_xml_step1">
		<xsl:apply-templates mode="update_xml_step1"/>
	</xsl:template>
	<xsl:template match="mn:sections/mn:p[starts-with(@class, 'zzSTDTitle')]/mn:span[@class] | mn:sourcecode//mn:span[@class]" mode="update_xml_step1" priority="2">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- remove semantic xml -->
	<xsl:template match="mn:metanorma-extension/mn:metanorma/mn:source" mode="update_xml_step1"/>
	
	<!-- remove UnitML elements, big section especially in BIPM xml -->
	<xsl:template match="mn:metanorma-extension/*[local-name() = 'UnitsML']" mode="update_xml_step1"/>
	
	<!-- remove image/emf -->
	<xsl:template match="mn:image/mn:emf" mode="update_xml_step1"/>
	
	<!-- remove preprocess-xslt -->
	<xsl:template match="mn:preprocess-xslt" mode="update_xml_step1"/>

	<xsl:template match="mn:stem" mode="update_xml_step1"/>
	
	<xsl:template match="mn:fmt-stem" mode="update_xml_step1">
		<!-- <xsl:element name="stem" namespace="{$namespace_full}"> -->
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:choose>
				<xsl:when test="mn:semx and count(node()) = 1">
					<xsl:choose>
						<xsl:when test="not(.//mn:passthrough) and not(.//*[@linebreak])">
							<xsl:copy-of select="mn:semx/node()"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="mn:semx/node()" mode="update_xml_step1"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="not(.//mn:passthrough) and not(.//*[@linebreak])">
							<xsl:copy-of select="node()"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="node()" mode="update_xml_step1"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
		<!-- </xsl:element> -->
	</xsl:template>
	
	<xsl:template match="mn:image[not(.//mn:passthrough)] | 
						mn:bibdata[not(.//mn:passthrough)] | 
						mn:localized-strings" mode="update_xml_step1">
		<xsl:copy-of select="."/>
	</xsl:template>
	
	<!-- https://github.com/metanorma/isodoc/issues/651 -->
	<!-- mn:sourcecode[not(.//mn:passthrough) and not(.//mn:fmt-name)] -->
	<xsl:template match="mn:sourcecode" mode="update_xml_step1">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="mn:fmt-name" mode="update_xml_step1"/>
			<xsl:choose>
				<xsl:when test="mn:fmt-sourcecode">
					<xsl:choose>
						<xsl:when test="mn:fmt-sourcecode[not(.//mn:passthrough)] and not(.//mn:fmt-name)">
							<xsl:copy-of select="mn:fmt-sourcecode/node()"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="mn:fmt-sourcecode/node()" mode="update_xml_step1"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise> <!-- If fmt-sourcecode is not present -->
					<xsl:choose>
						<xsl:when test="not(.//mn:passthrough) and not(.//mn:fmt-name)">
							<xsl:copy-of select="node()"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="node()[not(self::mn:fmt-name)]" mode="update_xml_step1"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>
	
	<!-- https://github.com/metanorma/isodoc/issues/651 -->
	<xsl:template match="mn:figure[mn:fmt-figure]" mode="update_xml_step1" priority="2">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="mn:fmt-name" mode="update_xml_step1"/>
			<xsl:apply-templates select="mn:fmt-figure/node()" mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- https://github.com/metanorma/isodoc/issues/652 -->
	<xsl:template match="mn:quote/mn:source" mode="update_xml_step1"/>
	<xsl:template match="mn:quote/mn:author" mode="update_xml_step1"/>
	<xsl:template match="mn:amend" mode="update_xml_step1"/>
	<!-- https://github.com/metanorma/isodoc/issues/687 -->
	<xsl:template match="mn:source" mode="update_xml_step1"/>
	
	
	<xsl:template match="mn:metanorma-extension/mn:attachment" mode="update_xml_step1">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:if test="1 = 2"> <!-- remove attachment/text(), because attachments added in the template 'addPDFUAmeta' before applying 'update_xml_step1' -->
				<xsl:variable name="name_filepath" select="concat($inputxml_basepath, @name)"/>
				<xsl:variable name="file_exists" select="normalize-space(java:exists(java:java.io.File.new($name_filepath)))"/>
				<xsl:if test="$file_exists = 'false'"> <!-- copy attachment content only if file on disk doesnt exist -->
					<xsl:value-of select="normalize-space(.)"/>
				</xsl:if>
			</xsl:if>
		</xsl:copy>
	</xsl:template>
	
	<!-- add @id, mandatory for table auto-layout algorithm -->
	<xsl:template match="*[self::mn:dl or self::mn:table][not(@id)]" mode="update_xml_step1">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:call-template name="add_id"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- prevent empty thead processing in XSL-FO, remove it -->
	<xsl:template match="mn:table/mn:thead[count(*) = 0]" mode="update_xml_step1"/>
	
	<xsl:template name="add_id">
		<xsl:if test="not(@id)">
			<!-- add @id - first element with @id plus '_element_name' -->
			<xsl:variable name="prefix_id_" select="(.//*[@id])[1]/@id"/>
			<xsl:variable name="prefix_id"><xsl:value-of select="$prefix_id_"/><xsl:if test="normalize-space($prefix_id_) = ''"><xsl:value-of select="generate-id()"/></xsl:if></xsl:variable>
			<xsl:variable name="document_suffix" select="ancestor::mn:metanorma/@document_suffix"/>
			<xsl:attribute name="id"><xsl:value-of select="concat($prefix_id, '_', local-name(), '_', $document_suffix)"/></xsl:attribute>
		</xsl:if>
	</xsl:template>
	
	<!-- optimization: remove clause if table_only_with_id isn't empty and clause doesn't contain table or dl with table_only_with_id -->
	<xsl:template match="*[self::mn:clause or self::mn:p or self::mn:definitions or self::mn:annex]" mode="update_xml_step1">
		<xsl:choose>
			<xsl:when test="($table_only_with_id != '' or $table_only_with_ids != '') and self::mn:p and (ancestor::*[self::mn:table or self::mn:dl or self::mn:toc])">
				<xsl:copy>
					<xsl:copy-of select="@*"/>
					<xsl:apply-templates mode="update_xml_step1"/>
				</xsl:copy>
			</xsl:when>
			<!-- for table auto-layout algorithm -->
			<xsl:when test="$table_only_with_id != '' and not(.//*[self::mn:table or self::mn:dl][@id = $table_only_with_id])">
				<xsl:copy>
					<xsl:copy-of select="@*"/>
				</xsl:copy>
			</xsl:when>
			<!-- for table auto-layout algorithm -->
			<xsl:when test="$table_only_with_ids != '' and not(.//*[self::mn:table or self::mn:dl][contains($table_only_with_ids, concat(@id, ' '))])">
				<xsl:copy>
					<xsl:copy-of select="@*"/>
				</xsl:copy>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy>
					<xsl:copy-of select="@*"/>
					<xsl:apply-templates mode="update_xml_step1"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:variable name="regex_passthrough">.*\bpdf\b.*</xsl:variable>
	<xsl:template match="mn:passthrough" mode="update_xml_step1">
		<!-- <xsl:if test="contains(@formats, ' pdf ')"> -->
		<xsl:if test="normalize-space(java:matches(java:java.lang.String.new(@formats), $regex_passthrough)) = 'true'">
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:if>
	</xsl:template>
	
	<!-- split math by element with @linebreak into maths -->
	<xsl:template match="mathml:math[.//mathml:mo[@linebreak] or .//mathml:mspace[@linebreak]]" mode="update_xml_step1">
		<xsl:variable name="maths">
			<xsl:apply-templates select="." mode="mathml_linebreak"/>
		</xsl:variable>
		<xsl:copy-of select="$maths"/>
	</xsl:template>
	
	<!-- update new Presentation XML -->
	<xsl:template match="mn:title[following-sibling::*[1][self::mn:fmt-title]]" mode="update_xml_step1"/>
	<xsl:template match="mn:name[following-sibling::*[1][self::mn:fmt-name]]" mode="update_xml_step1"/>
	<xsl:template match="mn:section-title[following-sibling::*[1][self::mn:p][@type = 'section-title' or @type = 'floating-title']]" mode="update_xml_step1"/>
	<!-- <xsl:template match="mn:preferred[following-sibling::*[not(local-name() = 'preferred')][1][local-name() = 'fmt-preferred']]" mode="update_xml_step1"/> -->
	<xsl:template match="mn:preferred" mode="update_xml_step1"/>
	<!-- <xsl:template match="mn:admitted[following-sibling::*[not(local-name() = 'admitted')][1][local-name() = 'fmt-admitted']]" mode="update_xml_step1"/> -->
	<xsl:template match="mn:admitted" mode="update_xml_step1"/>
	<!-- <xsl:template match="mn:deprecates[following-sibling::*[not(local-name() = 'deprecates')][1][local-name() = 'fmt-deprecates']]" mode="update_xml_step1"/> -->
	<xsl:template match="mn:deprecates" mode="update_xml_step1"/>
	<xsl:template match="mn:related" mode="update_xml_step1"/>
	<!-- <xsl:template match="mn:definition[following-sibling::*[1][local-name() = 'fmt-definition']]" mode="update_xml_step1"/> -->
	<xsl:template match="mn:definition" mode="update_xml_step1"/>
	<!-- <xsl:template match="mn:termsource[following-sibling::*[1][local-name() = 'fmt-termsource']]" mode="update_xml_step1"/> -->
	<xsl:template match="mn:termsource" mode="update_xml_step1"/>
	
	<xsl:template match="mn:term[@unnumbered = 'true'][not(.//*[starts-with(local-name(), 'fmt-')])]" mode="update_xml_step1"/>
	
	<xsl:template match="mn:p[@type = 'section-title' or @type = 'floating-title'][preceding-sibling::*[1][self::mn:section-title]]" mode="update_xml_step1">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="update_xml_step1"/>
			<xsl:copy-of select="preceding-sibling::*[1][self::mn:section-title]/@depth"/>
			<xsl:apply-templates select="node()" mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="mn:fmt-title" mode="update_xml_step1">
		<!-- <xsl:element name="title" namespace="{$namespace_full}"> -->
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:call-template name="addNamedDestinationAttribute"/>
			
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:copy>
		<!-- </xsl:element> -->
	</xsl:template>
	
	<xsl:template name="addNamedDestinationAttribute">
		<xsl:if test="$namespace = 'iso'">
		<xsl:variable name="docnum"><xsl:number level="any" count="mn:metanorma"/></xsl:variable>
		<xsl:variable name="caption_label" select="translate(normalize-space(.//mn:span[@class = 'fmt-caption-label']), ' ()', '')"/>
		
		<xsl:variable name="named_dest_">
			<xsl:choose>
				<xsl:when test="count(ancestor::mn:figure) &gt; 1"></xsl:when> <!-- prevent id 'a)' -->
				<xsl:when test="ancestor::mn:note or ancestor::mn:example or
							ancestor::mn:termnote or ancestor::mn:termexample"></xsl:when>
				<xsl:when test="$caption_label = '' and parent::mn:foreword">
					<xsl:variable name="foreword_number"><xsl:number count="mn:foreword" level="any"/></xsl:variable>
					<xsl:if test="$foreword_number = 1">Foreword</xsl:if>
				</xsl:when>
				<xsl:when test="$caption_label = '' and parent::mn:introduction">
					<xsl:variable name="introduction_number"><xsl:number count="mn:introduction" level="any"/></xsl:variable>
					<xsl:if test="$introduction_number = 1">Introduction</xsl:if>
				</xsl:when>
				<xsl:when test="$caption_label = ''"></xsl:when>
				<xsl:when test="../@unnumbered = 'true'"></xsl:when>
				<xsl:otherwise>
					<xsl:if test="parent::mn:formula">Formula</xsl:if>
					<xsl:value-of select="$caption_label"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="named_dest" select="normalize-space($named_dest_)"/>
		<xsl:if test="$named_dest != ''">
			<xsl:variable name="named_dest_doc_">
				<xsl:value-of select="$named_dest"/>
				<xsl:if test="$docnum != '1'">_<xsl:value-of select="$docnum"/></xsl:if>
			</xsl:variable>
			<xsl:variable name="named_dest_doc" select="normalize-space($named_dest_doc_)"/>
			<xsl:if test="not(key('kid', $named_dest_doc))"> <!-- if element with id '$named_dest_doc' doesn't exist in the document -->
				<xsl:attribute name="named_dest"><xsl:value-of select="normalize-space($named_dest_doc)"/></xsl:attribute>
			</xsl:if>
		</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:fmt-name" mode="update_xml_step1">
		<xsl:choose>
			<xsl:when test="local-name(..) = 'p' and ancestor::mn:table">
				<xsl:apply-templates mode="update_xml_step1"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- <xsl:element name="name" namespace="{$namespace_full}"> -->
				<xsl:copy>
					<xsl:copy-of select="@*"/>
					<xsl:call-template name="addNamedDestinationAttribute"/>
					
					<xsl:apply-templates mode="update_xml_step1"/>
				</xsl:copy>
				<!-- </xsl:element> -->
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- li/fmt-name -->
	<xsl:template match="mn:li/mn:fmt-name" priority="2" mode="update_xml_step1">
		<xsl:attribute name="label"><xsl:value-of select="."/></xsl:attribute>
		<xsl:attribute name="full">true</xsl:attribute>
	</xsl:template>
	
	<xsl:template match="mn:fmt-preferred[mn:p]" mode="update_xml_step1">
		<xsl:apply-templates mode="update_xml_step1"/>
	</xsl:template>
	<xsl:template match="mn:fmt-preferred[not(mn:p)] | mn:fmt-preferred/mn:p" mode="update_xml_step1">
		<xsl:element name="fmt-preferred" namespace="{$namespace_full}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="mn:fmt-admitted[mn:p]" mode="update_xml_step1">
		<xsl:apply-templates mode="update_xml_step1"/>
	</xsl:template>
	<xsl:template match="mn:fmt-admitted[not(mn:p)] | mn:fmt-admitted/mn:p" mode="update_xml_step1">
		<xsl:element name="fmt-admitted" namespace="{$namespace_full}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="mn:fmt-deprecates[mn:p]" mode="update_xml_step1">
		<xsl:apply-templates mode="update_xml_step1"/>
	</xsl:template>
	<xsl:template match="mn:fmt-deprecates[not(mn:p)] | mn:fmt-deprecates/mn:p" mode="update_xml_step1">
		<xsl:element name="fmt-deprecates" namespace="{$namespace_full}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:element>
	</xsl:template>
	
	<!-- <xsl:template match="mn:fmt-definition" mode="update_xml_step1">
		<xsl:element name="definition" namespace="{$namespace_full}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="mn:fmt-termsource" mode="update_xml_step1">
		<xsl:element name="termsource" namespace="{$namespace_full}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="mn:fmt-source" mode="update_xml_step1">
		<xsl:element name="source" namespace="{$namespace_full}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:element>
	</xsl:template> -->
	
	<xsl:template match="mn:span[
															@class = 'fmt-caption-label' or 
															@class = 'fmt-element-name' or
															@class = 'fmt-caption-delim' or
															@class = 'fmt-autonum-delim']" mode="update_xml_step1" priority="3">
		<xsl:apply-templates mode="update_xml_step1"/>
	</xsl:template>
	
	<xsl:template match="mn:semx" mode="update_xml_step1">
		<xsl:apply-templates mode="update_xml_step1"/>
	</xsl:template>
	
	<xsl:template match="mn:fmt-xref-label" mode="update_xml_step1"/>
	
	<xsl:template match="mn:requirement | mn:recommendation | mn:permission" mode="update_xml_step1">
		<xsl:apply-templates mode="update_xml_step1"/>
	</xsl:template>
	
	<xsl:template match="mn:requirement/*[not(starts-with(local-name(), 'fmt-'))] |
												mn:recommendation/*[not(starts-with(local-name(), 'fmt-'))] | 
												mn:permission/*[not(starts-with(local-name(), 'fmt-'))]" mode="update_xml_step1"/>
											
	<xsl:template match="mn:fmt-provision" mode="update_xml_step1">
		<xsl:apply-templates mode="update_xml_step1"/>
	</xsl:template>
	
	<xsl:template match="mn:identifier" mode="update_xml_step1"/>
	<!-- <xsl:template match="mn:fmt-identifier" mode="update_xml_step1">
		<xsl:element name="identifier" namespace="{$namespace_full}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:element>
	</xsl:template> -->
	
	<xsl:template match="mn:concept" mode="update_xml_step1"/>
	
	<xsl:template match="mn:fmt-concept" mode="update_xml_step1">
		<xsl:apply-templates mode="update_xml_step1"/>
	</xsl:template>
	
	<xsl:template match="mn:eref" mode="update_xml_step1"/>
	
	<!-- <xsl:template match="mn:fmt-eref" mode="update_xml_step1">
		<xsl:element name="eref" namespace="{$namespace_full}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:element>
	</xsl:template> -->
  
	<xsl:template match="mn:xref" mode="update_xml_step1"/>
	
	<!-- <xsl:template match="mn:fmt-xref" mode="update_xml_step1">
		<xsl:element name="xref" namespace="{$namespace_full}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:element>
	</xsl:template> -->
  
	<xsl:template match="mn:link" mode="update_xml_step1"/>
	
	<!-- <xsl:template match="mn:fmt-link" mode="update_xml_step1">
		<xsl:element name="link" namespace="{$namespace_full}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:element>
	</xsl:template> -->
  
	<xsl:template match="mn:origin" mode="update_xml_step1"/>
	
	<!-- <xsl:template match="mn:fmt-origin" mode="update_xml_step1">
		<xsl:element name="origin" namespace="{$namespace_full}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:element>
	</xsl:template> -->
	
	<xsl:template match="mn:erefstack" mode="update_xml_step1"/>
	
	<xsl:template match="mn:svgmap" mode="update_xml_step1"/>
	
	<xsl:template match="mn:annotation-container" mode="update_xml_step1"/>
	
	<xsl:template match="mn:fmt-identifier[not(ancestor::*[local-name() = 'bibdata'])]//text()" mode="update_xml_step1">
		<xsl:element name="{$element_name_keep-together_within-line}" namespace="{$namespace_full}">
			<xsl:value-of select="."/>
		</xsl:element>
	</xsl:template>
  
	<xsl:template match="@semx-id | @anchor" mode="update_xml_step1"/>
	
	<!-- END: update new Presentation XML -->
	
	<!-- =========================================================================== -->
	<!-- END STEP1: update_xml_step1 -->
	<!-- =========================================================================== -->


	<!-- =========================================================================== -->
	<!-- STEP MOVE PAGEBREAK: move <pagebreak/> at top level under 'preface' and 'sections' -->
	<!-- =========================================================================== -->
	<xsl:template match="@*|node()" mode="update_xml_step_move_pagebreak">
		<xsl:param name="page_sequence_at_top">false</xsl:param>
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="update_xml_step_move_pagebreak">
				<xsl:with-param name="page_sequence_at_top" select="$page_sequence_at_top"/>
			</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>
	
	
	<!-- replace 'pagebreak' by closing tags + page_sequence and  opening page_sequence + tags -->
	<xsl:template match="mn:pagebreak[not(following-sibling::*[1][self::mn:pagebreak])]" mode="update_xml_step_move_pagebreak">	
		<xsl:param name="page_sequence_at_top"/>
		<!-- <xsl:choose>
			<xsl:when test="ancestor::mn:sections">
			
			</xsl:when>
			<xsl:when test="ancestor::mn:annex">
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="."/>
			</xsl:otherwise>
		</xsl:choose> -->
		
		<!-- determine pagebreak is last element before </fo:flow> or not -->
		<xsl:variable name="isLast">
			<xsl:for-each select="ancestor-or-self::*[ancestor::mn:preface or ancestor::mn:sections or ancestor-or-self::mn:annex]">
				<xsl:if test="following-sibling::*">false</xsl:if>
			</xsl:for-each>
		</xsl:variable>
	
		<xsl:if test="contains($isLast, 'false')">
	
			<xsl:variable name="orientation" select="normalize-space(@orientation)"/>
			
			<xsl:variable name="tree_">
				<xsl:call-template name="makeAncestorsElementsTree">
					<xsl:with-param name="page_sequence_at_top" select="$page_sequence_at_top"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="tree" select="xalan:nodeset($tree_)"/>
			
			<!-- close fo:page-sequence (closing preceding fo elements) -->
			<xsl:call-template name="insertClosingElements">
				<xsl:with-param name="tree" select="$tree"/>
			</xsl:call-template>
			
			<xsl:text disable-output-escaping="yes">&lt;/page_sequence&gt;</xsl:text>
			
			<!-- create a new page_sequence (opening elements) -->
			<xsl:text disable-output-escaping="yes">&lt;page_sequence xmlns="</xsl:text><xsl:value-of select="$namespace_full"/>"<xsl:if test="$orientation != ''"> orientation="<xsl:value-of select="$orientation"/>"</xsl:if><xsl:text disable-output-escaping="yes">&gt;</xsl:text>

			<xsl:call-template name="insertOpeningElements">
				<xsl:with-param name="tree" select="$tree"/>
			</xsl:call-template>
				
		</xsl:if>
	</xsl:template>	

	<xsl:template name="makeAncestorsElementsTree">
		<xsl:param name="page_sequence_at_top"/>
		
		<xsl:choose>
			<xsl:when test="$page_sequence_at_top = 'true'">
				<xsl:for-each select="ancestor::*[ancestor::mn:metanorma]">
					<element pos="{position()}">
						<xsl:copy-of select="@*[local-name() != 'id']"/>
						<xsl:value-of select="name()"/>
					</element>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="ancestor::*[ancestor::mn:preface or ancestor::mn:sections or ancestor-or-self::mn:annex]">
					<element pos="{position()}">
						<xsl:copy-of select="@*[local-name() != 'id']"/>
						<xsl:value-of select="name()"/>
					</element>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="insertClosingElements">
		<xsl:param name="tree"/>
		<xsl:for-each select="$tree//element">
			<xsl:sort data-type="number" order="descending" select="@pos"/>
			<xsl:text disable-output-escaping="yes">&lt;/</xsl:text>
				<xsl:value-of select="."/>
			<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
			<xsl:if test="$debug = 'true'">
				<xsl:message>&lt;/<xsl:value-of select="."/>&gt;</xsl:message>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template name="insertOpeningElements">
		<xsl:param name="tree"/>
		<xsl:param name="xmlns"/>
		<xsl:param name="add_continue">true</xsl:param>
		<xsl:for-each select="$tree//element">
			<xsl:text disable-output-escaping="yes">&lt;</xsl:text>
				<xsl:value-of select="."/>
				<xsl:for-each select="@*[local-name() != 'pos']">
					<xsl:text> </xsl:text>
					<xsl:value-of select="local-name()"/>
					<xsl:text>="</xsl:text>
					<xsl:value-of select="."/>
					<xsl:text>"</xsl:text>
				</xsl:for-each>
				<xsl:if test="position() = 1 and $add_continue = 'true'"> continue="true"</xsl:if>
				<xsl:if test="position() = 1 and $xmlns != ''"> xmlns="<xsl:value-of select="$xmlns"/>"</xsl:if>
			<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
			<xsl:if test="$debug = 'true'">
				<xsl:message>&lt;<xsl:value-of select="."/>&gt;</xsl:message>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<!-- move full page width figures, tables at top level -->
	<xsl:template match="*[self::mn:figure or self::mn:table][normalize-space(@width) != 'text-width']" mode="update_xml_step_move_pagebreak">
		<xsl:param name="page_sequence_at_top">false</xsl:param>
		<xsl:choose>
			<xsl:when test="$layout_columns != 1">
				
				<xsl:variable name="tree_">
					<xsl:call-template name="makeAncestorsElementsTree">
						<xsl:with-param name="page_sequence_at_top" select="$page_sequence_at_top"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="tree" select="xalan:nodeset($tree_)"/>
				
				<xsl:call-template name="insertClosingElements">
					<xsl:with-param name="tree" select="$tree"/>
				</xsl:call-template>
				
				<!-- <xsl:copy-of select="."/> -->
				<xsl:copy>
					<xsl:copy-of select="@*"/>
					<xsl:attribute name="top-level">true</xsl:attribute>
					<xsl:copy-of select="node()"/>
				</xsl:copy>
				
				<xsl:call-template name="insertOpeningElements">
					<xsl:with-param name="tree" select="$tree"/>
				</xsl:call-template>
				
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- =========================================================================== -->
	<!-- END STEP MOVE PAGEBREAK: move <pagebreak/> at top level under 'preface' and 'sections' -->
	<!-- =========================================================================== -->
	
	<xsl:if test="$namespace = 'ieee' or $namespace = 'iso' or $namespace = 'jis' or $namespace = 'plateau' or $namespace = 'bsi'">
		<!-- =========================================================================== -->
		<!-- STEP2: add 'fn' after 'eref' and 'origin', if referenced to bibitem with 'note' = Withdrawn.' or 'Cancelled and replaced...'  -->
		<!-- =========================================================================== -->
		<xsl:template match="@*|node()" mode="update_xml_step2">
			<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="update_xml_step2"/>
			</xsl:copy>
		</xsl:template>
		
		<xsl:variable name="localized_string_withdrawn">
			<xsl:call-template name="getLocalizedString">
				<xsl:with-param name="key">withdrawn</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="localized_string_cancelled_and_replaced">
			<xsl:variable name="str">
				<xsl:call-template name="getLocalizedString">
					<xsl:with-param name="key">cancelled_and_replaced</xsl:with-param>
				</xsl:call-template>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="contains($str, '%')"><xsl:value-of select="substring-before($str, '%')"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$str"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<!-- add 'fn' after eref and origin, to reference bibitem with note = 'Withdrawn.' or 'Cancelled and replaced...' -->
		<xsl:template match="mn:fmt-eref | mn:fmt-origin" mode="update_xml_step2">
			<xsl:copy-of select="."/>
			
			<xsl:variable name="bibitemid" select="@bibitemid"/>
			<xsl:variable name="local_name" select="local-name()"/>
			<xsl:variable name="position"><xsl:number count="*[local-name() = $local_name][@bibitemid = $bibitemid]" level="any"/></xsl:variable>
			<xsl:if test="normalize-space($position) = '1'">
				<xsl:variable name="fn_text">
					<!-- <xsl:copy-of select="key('bibitems', $bibitemid)[1]/mn:note[not(@type='Unpublished-Status')][normalize-space() = $localized_string_withdrawn or starts-with(normalize-space(), $localized_string_cancelled_and_replaced)]/node()" /> -->
					<xsl:copy-of select="$bibitems/mn:bibitem[@id = $bibitemid][1]/mn:note[not(@type='Unpublished-Status')][normalize-space() = $localized_string_withdrawn or starts-with(normalize-space(), $localized_string_cancelled_and_replaced)]/node()" />
				</xsl:variable>
				<xsl:if test="normalize-space($fn_text) != ''">
					<xsl:element name="fn" namespace="{$namespace_full}">
						<xsl:attribute name="reference">bibitem_<xsl:value-of select="$bibitemid"/></xsl:attribute>
						<xsl:element name="p" namespace="{$namespace_full}">
							<xsl:copy-of select="$fn_text"/>
						</xsl:element>
					</xsl:element>
				</xsl:if>
			</xsl:if>
		</xsl:template>
		
		<!-- add id for table without id (for autolayout algorithm) -->
		<!-- <xsl:template match="mn:table[not(@id)]" mode="update_xml_step2">
			<xsl:copy>
				<xsl:apply-templates select="@*" mode="update_xml_step2"/>
				<xsl:attribute name="id">_abc<xsl:value-of select="generate-id()"/></xsl:attribute>
				
				<xsl:apply-templates select="node()" mode="update_xml_step2"/>
			</xsl:copy>
		</xsl:template> -->
		
		<!-- add @reference for fn -->
		<xsl:template match="mn:fn[not(@reference)]" mode="update_xml_step2">
			<xsl:copy>
				<xsl:apply-templates select="@*" mode="update_xml_step2"/>
				<xsl:attribute name="reference"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
				<xsl:apply-templates select="node()" mode="update_xml_step2"/>
			</xsl:copy>
		</xsl:template>
		
		
		<!-- add @reference for bibitem/note, similar to fn/reference -->
		<!-- <xsl:template match="mn:bibitem/mn:note" mode="update_xml_step2">
			<xsl:copy>
				<xsl:apply-templates select="@*" mode="update_xml_step2"/>
				
				<xsl:attribute name="reference">
					<xsl:value-of select="concat('bibitem_', ../@id, '_', count(preceding-sibling::mn:note))"/>
				</xsl:attribute>
				
				<xsl:apply-templates select="node()" mode="update_xml_step2"/>
			</xsl:copy>
		</xsl:template> -->
		
		<!-- enclose sequence of 'char x' + 'combining char y' to <lang_none>xy</lang_none> -->
		<xsl:variable name="regex_combining_chars">(.[&#x300;-&#x36f;])</xsl:variable>
		<xsl:variable name="element_name_lang_none">lang_none</xsl:variable>
		<xsl:variable name="tag_element_name_lang_none_open">###<xsl:value-of select="$element_name_lang_none"/>###</xsl:variable>
		<xsl:variable name="tag_element_name_lang_none_close">###/<xsl:value-of select="$element_name_lang_none"/>###</xsl:variable>

		<xsl:template match="text()" mode="update_xml_step2">
			<xsl:variable name="text_" select="java:replaceAll(java:java.lang.String.new(.), $regex_combining_chars, concat($tag_element_name_lang_none_open,'$1',$tag_element_name_lang_none_close))"/>
			<xsl:call-template name="replace_text_tags">
				<xsl:with-param name="tag_open" select="$tag_element_name_lang_none_open"/>
				<xsl:with-param name="tag_close" select="$tag_element_name_lang_none_close"/>
				<xsl:with-param name="text" select="$text_"/>
			</xsl:call-template>
		</xsl:template>
		
		<xsl:template match="mn:fmt-stem | mn:image" mode="update_xml_step2">
			<xsl:copy-of select="."/>
		</xsl:template>
		
		<!-- =========================================================================== -->
		<!-- END STEP2: add 'fn' after 'eref' and 'origin', if referenced to bibitem with 'note' = Withdrawn.' or 'Cancelled and replaced...'  -->
		<!-- =========================================================================== -->
	</xsl:if>
	
	<!-- =========================================================================== -->
	<!-- XML UPDATE STEP: enclose standard's name into tag 'keep-together_within-line'  -->
	<!-- keep-together_within-line for: a/b, aaa/b, a/bbb, /b -->
	<!-- keep-together_within-line for: a.b, aaa.b, a.bbb, .b  in table's cell ONLY  -->
	<!-- =========================================================================== -->
	<!-- Example: <keep-together_within-line>ISO 10303-51</keep-together_within-line> -->
	<xsl:template match="@*|node()" mode="update_xml_enclose_keep-together_within-line">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="update_xml_enclose_keep-together_within-line"/>
		</xsl:copy>
	</xsl:template>
	
	
	<xsl:variable name="express_reference_separators">_.\</xsl:variable>
	<xsl:variable name="express_reference_characters" select="concat($upper,$lower,'1234567890',$express_reference_separators)"/>
	<xsl:variable name="regex_express_reference">(^([A-Za-z0-9_.\\]+)$)</xsl:variable>
		
	<xsl:variable name="element_name_keep-together_within-line">keep-together_within-line</xsl:variable>
	<xsl:variable name="tag_keep-together_within-line_open">###<xsl:value-of select="$element_name_keep-together_within-line"/>###</xsl:variable>
	<xsl:variable name="tag_keep-together_within-line_close">###/<xsl:value-of select="$element_name_keep-together_within-line"/>###</xsl:variable>
	
	<!-- \S matches any non-whitespace character (equivalent to [^\r\n\t\f\v ]) -->
	<!-- <xsl:variable name="regex_solidus_units">((\b((\S{1,3}\/\S+)|(\S+\/\S{1,3}))\b)|(\/\S{1,3})\b)</xsl:variable> -->
	<!-- add &lt; and &gt; to \S -->
	<xsl:variable name="regex_S">[^\r\n\t\f\v \&lt;&gt;\u3000-\u9FFF]</xsl:variable>
	<xsl:variable name="regex_solidus_units">((\b((<xsl:value-of select="$regex_S"/>{1,3}\/<xsl:value-of select="$regex_S"/>+)|(<xsl:value-of select="$regex_S"/>+\/<xsl:value-of select="$regex_S"/>{1,3}))\b)|(\/<xsl:value-of select="$regex_S"/>{1,3})\b)</xsl:variable>
	
	<xsl:variable name="non_white_space">[^\s\u3000-\u9FFF]</xsl:variable>
	<xsl:variable name="regex_dots_units">((\b((<xsl:value-of select="$non_white_space"/>{1,3}\.<xsl:value-of select="$non_white_space"/>+)|(<xsl:value-of select="$non_white_space"/>+\.<xsl:value-of select="$non_white_space"/>{1,3}))\b)|(\.<xsl:value-of select="$non_white_space"/>{1,3})\b)</xsl:variable>
	
	<xsl:template match="text()[not(ancestor::mn:bibdata or 
				ancestor::mn:fmt-link[not(contains(normalize-space(),' '))] or 
				ancestor::mn:sourcecode or 
				ancestor::*[local-name() = 'math'] or
				ancestor::*[local-name() = 'svg'] or
				ancestor::mn:name or ancestor::mn:fmt-name or
				starts-with(., 'http://') or starts-with(., 'https://') or starts-with(., 'www.') or normalize-space() = '' )]" name="keep_together_standard_number" mode="update_xml_enclose_keep-together_within-line">
	
		<xsl:variable name="parent" select="local-name(..)"/>
	
		
		<xsl:if test="1 = 2"> <!-- alternative variant -->
		
			<xsl:variable name="regexs">
				<!-- enclose standard's number into tag 'keep-together_within-line' -->
				<xsl:if test="not(ancestor::mn:table)"><regex><xsl:value-of select="$regex_standard_reference"/></regex></xsl:if>
				<!-- if EXPRESS reference -->
				<xsl:if test="$namespace = 'iso'">
					<xsl:if test="$parent = 'strong'"><regex><xsl:value-of select="$regex_express_reference"/></regex></xsl:if>
				</xsl:if>
				<!-- keep-together_within-line for: a/b, aaa/b, a/bbb, /b -->
				<regex><xsl:value-of select="$regex_solidus_units"/></regex>
				<!-- keep-together_within-line for: a.b, aaa.b, a.bbb, .b  in table's cell ONLY -->
				<xsl:if test="ancestor::*[self::mn:td or self::mn:th]">
					<regex><xsl:value-of select="$regex_dots_units"/></regex>
				</xsl:if>
			</xsl:variable>
			
			<xsl:variable name="regex_replacement"><xsl:text>(</xsl:text>
				<xsl:for-each select="xalan:nodeset($regexs)/regex">
					<xsl:value-of select="."/>
					<xsl:if test="position() != last()">|</xsl:if>
				</xsl:for-each>
				<xsl:text>)</xsl:text>
			</xsl:variable>
			
			<!-- regex_replacement='<xsl:value-of select="$regex_replacement"/>' -->
			
			<xsl:variable name="text_replaced" select="java:replaceAll(java:java.lang.String.new(.), $regex_replacement, concat($tag_keep-together_within-line_open,'$1',$tag_keep-together_within-line_close))"/>
			
			<!-- text_replaced='<xsl:value-of select="$text_replaced"/>' -->
			
			<xsl:call-template name="replace_text_tags">
				<xsl:with-param name="tag_open" select="$tag_keep-together_within-line_open"/>
				<xsl:with-param name="tag_close" select="$tag_keep-together_within-line_close"/>
				<xsl:with-param name="text" select="$text_replaced"/>
			</xsl:call-template>
		</xsl:if>
		
		
		<xsl:if test="1 = 1">
		
		<!-- enclose standard's number into tag 'keep-together_within-line' -->
		<xsl:variable name="text">
			<xsl:element name="text" namespace="{$namespace_full}">
				<xsl:choose>
					<xsl:when test="ancestor::mn:table"><xsl:value-of select="."/></xsl:when> <!-- no need enclose standard's number into tag 'keep-together_within-line' in table cells -->
					<xsl:otherwise>
						<xsl:variable name="text_" select="java:replaceAll(java:java.lang.String.new(.), $regex_standard_reference, concat($tag_keep-together_within-line_open,'$1',$tag_keep-together_within-line_close))"/>
						<!-- <xsl:value-of select="$text__"/> -->
						
						<xsl:call-template name="replace_text_tags">
							<xsl:with-param name="tag_open" select="$tag_keep-together_within-line_open"/>
							<xsl:with-param name="tag_close" select="$tag_keep-together_within-line_close"/>
							<xsl:with-param name="text" select="$text_"/>
						</xsl:call-template>
						
					</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
		</xsl:variable>
		
		
		<xsl:variable name="text2">
			<xsl:element name="text" namespace="{$namespace_full}">
				<xsl:for-each select="xalan:nodeset($text)/*[local-name() = 'text']/node()">
					<xsl:choose>
						
						<xsl:when test="$namespace = 'iso'">
							<xsl:choose>
								<!-- if EXPRESS reference -->
								<xsl:when test="self::text() and $parent = 'strong' and translate(., $express_reference_characters, '') = ''">
									<xsl:variable name="text_express" select="java:replaceAll(java:java.lang.String.new(.),$regex_express_reference,concat($tag_keep-together_within-line_open,'$1',$tag_keep-together_within-line_close))"/>
									
									<!-- <xsl:element name="{$element_name_keep-together_within-line}"><xsl:value-of select="."/></xsl:element> -->
									
									<xsl:call-template name="replace_text_tags">
										<xsl:with-param name="tag_open" select="$tag_keep-together_within-line_open"/>
										<xsl:with-param name="tag_close" select="$tag_keep-together_within-line_close"/>
										<xsl:with-param name="text" select="$text_express"/>
									</xsl:call-template>
									
									
								</xsl:when>
								<xsl:otherwise><xsl:copy-of select="."/></xsl:otherwise> <!-- copy 'as-is' for <fo:inline keep-together.within-line="always" ...  -->
							</xsl:choose>
						</xsl:when>
						
						<xsl:otherwise><xsl:copy-of select="."/></xsl:otherwise> <!-- copy 'as-is' for <fo:inline keep-together.within-line="always" ...  -->
					</xsl:choose>
				</xsl:for-each>
			</xsl:element>
		</xsl:variable>
		
		<!-- keep-together_within-line for: a/b, aaa/b, a/bbb, /b -->
		<xsl:variable name="text3">
			<xsl:element name="text" namespace="{$namespace_full}">
				<xsl:for-each select="xalan:nodeset($text2)/*[local-name() = 'text']/node()">
					<xsl:choose>
						<xsl:when test="self::text()">
							<xsl:variable name="text_units" select="java:replaceAll(java:java.lang.String.new(.),$regex_solidus_units,concat($tag_keep-together_within-line_open,'$1',$tag_keep-together_within-line_close))"/>
							<!-- <xsl:variable name="text_units">
								<xsl:element name="text" namespace="{$namespace_full}"> -->
									<xsl:call-template name="replace_text_tags">
										<xsl:with-param name="tag_open" select="$tag_keep-together_within-line_open"/>
										<xsl:with-param name="tag_close" select="$tag_keep-together_within-line_close"/>
										<xsl:with-param name="text" select="$text_units"/>
									</xsl:call-template>
								<!-- </xsl:element>
							</xsl:variable>
							<xsl:copy-of select="xalan:nodeset($text_units)/*[local-name() = 'text']/node()"/> -->
						</xsl:when>
						<xsl:otherwise><xsl:copy-of select="."/></xsl:otherwise> <!-- copy 'as-is' for <fo:inline keep-together.within-line="always" ...  -->
					</xsl:choose>
				</xsl:for-each>
			</xsl:element>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="ancestor::*[local-name() = 'td' or local-name() = 'th']">
				<!-- keep-together_within-line for: a.b, aaa.b, a.bbb, .b  in table's cell ONLY -->
				<xsl:for-each select="xalan:nodeset($text3)/*[local-name() = 'text']/node()">
					<xsl:choose>
						<xsl:when test="self::text()">
							<xsl:variable name="text_dots" select="java:replaceAll(java:java.lang.String.new(.),$regex_dots_units,concat($tag_keep-together_within-line_open,'$1',$tag_keep-together_within-line_close))"/>
							<!-- <xsl:variable name="text_dots">
								<xsl:element name="text" namespace="{$namespace_full}"> -->
									<xsl:call-template name="replace_text_tags">
										<xsl:with-param name="tag_open" select="$tag_keep-together_within-line_open"/>
										<xsl:with-param name="tag_close" select="$tag_keep-together_within-line_close"/>
										<xsl:with-param name="text" select="$text_dots"/>
									</xsl:call-template>
								<!-- </xsl:element>
							</xsl:variable>
							<xsl:copy-of select="xalan:nodeset($text_dots)/*[local-name() = 'text']/node()"/> -->
						</xsl:when>
						<xsl:otherwise><xsl:copy-of select="."/></xsl:otherwise> <!-- copy 'as-is' for <fo:inline keep-together.within-line="always" ...  -->
					</xsl:choose>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise><xsl:copy-of select="xalan:nodeset($text3)/*[local-name() = 'text']/node()"/></xsl:otherwise>
		</xsl:choose>
		</xsl:if>
	</xsl:template>
	
	
	<xsl:template match="mn:fmt-stem | mn:image" mode="update_xml_enclose_keep-together_within-line">
		<xsl:copy-of select="."/>
	</xsl:template>
	
	<xsl:template name="replace_text_tags">
		<xsl:param name="tag_open"/>
		<xsl:param name="tag_close"/>
		<xsl:param name="text"/>
		<xsl:choose>
			<xsl:when test="contains($text, $tag_open)">
				<xsl:value-of select="substring-before($text, $tag_open)"/>
				<xsl:variable name="text_after" select="substring-after($text, $tag_open)"/>
				
				<xsl:element name="{substring-before(substring-after($tag_open, '###'),'###')}" namespace="{$namespace_full}">
					<xsl:value-of select="substring-before($text_after, $tag_close)"/>
				</xsl:element>
				
				<xsl:call-template name="replace_text_tags">
					<xsl:with-param name="tag_open" select="$tag_open"/>
					<xsl:with-param name="tag_close" select="$tag_close"/>
					<xsl:with-param name="text" select="substring-after($text_after, $tag_close)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="$text"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- ===================================== -->
	<!-- END XML UPDATE STEP: enclose standard's name into tag 'keep-together_within-line'  -->
	<!-- ===================================== -->
	
	<!-- Example:
	<metanorma>
		<preface>
			<page_sequence>
				<clause...
			</page_sequence>
			<page_sequence>
				<clause...
			</page_sequence>
		</preface>
		<sections>
			<page_sequence>
				<clause...
			</page_sequence>
			<page_sequence>
				<clause...
			</page_sequence>
		</sections>
		<page_sequence>
			<annex ..
		</page_sequence>
		<page_sequence>
			<annex ..
		</page_sequence>
	</metanorma>
	-->
	<xsl:template name="processPrefaceAndMainSectionsDefault_items">
	
		<xsl:variable name="updated_xml_step_move_pagebreak">
			<xsl:element name="{$root_element}" namespace="{$namespace_full}">
				<xsl:call-template name="copyCommonElements"/>
				<xsl:call-template name="insertPrefaceSectionsPageSequences"/>
				<xsl:call-template name="insertMainSectionsPageSequences"/>
			</xsl:element>
		</xsl:variable>
		
		<xsl:variable name="updated_xml_step_move_pagebreak_filename" select="concat($output_path,'_main_', java:getTime(java:java.util.Date.new()), '.xml')"/>
		
		<redirect:write file="{$updated_xml_step_move_pagebreak_filename}">
			<xsl:copy-of select="$updated_xml_step_move_pagebreak"/>
		</redirect:write>
		
		<xsl:copy-of select="document($updated_xml_step_move_pagebreak_filename)"/>
		
		<xsl:if test="$debug = 'true'">
			<redirect:write file="page_sequence_preface_and_main.xml">
				<xsl:copy-of select="$updated_xml_step_move_pagebreak"/>
			</redirect:write>
		</xsl:if>
		
		<xsl:call-template name="deleteFile">
			<xsl:with-param name="filepath" select="$updated_xml_step_move_pagebreak_filename"/>
		</xsl:call-template>
	</xsl:template> <!-- END: processPrefaceAndMainSectionsDefault_items -->
	
	
	<xsl:template name="insertPrefaceSectionsPageSequences">
		<xsl:element name="preface" namespace="{$namespace_full}"> <!-- save context element -->
			<xsl:element name="page_sequence" namespace="{$namespace_full}">
				<xsl:for-each select="/*/mn:preface/*[not(self::mn:note or self::mn:admonition)]">
					<xsl:sort select="@displayorder" data-type="number"/>
					<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak"/>
				</xsl:for-each>
			</xsl:element>
		</xsl:element>
	</xsl:template> <!-- END: insertPrefaceSectionsPageSequences -->
	
	<xsl:template name="insertMainSectionsPageSequences">
	
		<xsl:call-template name="insertSectionsInPageSequence"/>
	
		<xsl:element name="page_sequence" namespace="{$namespace_full}">
			<xsl:for-each select="/*/mn:annex">
				<xsl:sort select="@displayorder" data-type="number"/>
				<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak"/>
			</xsl:for-each>
		</xsl:element>
		
		<xsl:element name="page_sequence" namespace="{$namespace_full}">
			<xsl:element name="bibliography" namespace="{$namespace_full}"> <!-- save context element -->
				<xsl:for-each select="/*/mn:bibliography/*[not(@normative='true')] | 
										/*/mn:bibliography/mn:clause[mn:references[not(@normative='true')]]">
					<xsl:sort select="@displayorder" data-type="number"/>
					<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak"/>
				</xsl:for-each>
			</xsl:element>
		</xsl:element>
	</xsl:template> <!-- END: insertMainSectionsPageSequences -->
	
	<xsl:template name="insertSectionsInPageSequence">
		<xsl:element name="sections" namespace="{$namespace_full}"> <!-- save context element -->
			<xsl:element name="page_sequence" namespace="{$namespace_full}">
				<xsl:for-each select="/*/mn:sections/* | /*/mn:bibliography/mn:references[@normative='true']">
					<xsl:sort select="@displayorder" data-type="number"/>
					<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak"/>
					<xsl:if test="$namespace = 'm3d'">
						<xsl:if test="self::mn:clause and @type='scope'">
							<xsl:if test="/*/mn:bibliography/mn:references[@normative='true']">
								<fo:block break-after="page"/>
								<xsl:element name="pagebreak" namespace="{$namespace_full}"/>
							</xsl:if>
						</xsl:if>
					</xsl:if>
				</xsl:for-each>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	
	<xsl:template name="insertMainSectionsInSeparatePageSequences">
		<xsl:element name="sections" namespace="{$namespace_full}"> <!-- save context element -->
			<xsl:for-each select="/*/mn:sections/* | /*/mn:bibliography/mn:references[@normative='true']">
				<xsl:sort select="@displayorder" data-type="number"/>
				<xsl:element name="page_sequence" namespace="{$namespace_full}">
					<xsl:attribute name="main_page_sequence"/>
					<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak"/>
				</xsl:element>
			</xsl:for-each>
		</xsl:element>
		
		<xsl:call-template name="insertAnnexAndBibliographyInSeparatePageSequences"/>
		
		<!-- <xsl:call-template name="insertBibliographyInSeparatePageSequences"/> -->
		
		<!-- <xsl:call-template name="insertIndexInSeparatePageSequences"/> -->
	</xsl:template> <!-- END: insertMainSectionsInSeparatePageSequences -->
	
	
	<xsl:template name="insertAnnexAndBibliographyInSeparatePageSequences">
		<xsl:for-each select="/*/mn:annex | 
									/*/mn:bibliography/*[not(@normative='true')] | 
									/*/mn:bibliography/mn:clause[mn:references[not(@normative='true')]] |
									/*/mn:indexsect">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:choose>
				<xsl:when test="self::mn:annex or self::mn:indexsect">
					<xsl:element name="page_sequence" namespace="{$namespace_full}">
						<xsl:attribute name="main_page_sequence"/>
						<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak"/>
					</xsl:element>
				</xsl:when>
				<xsl:otherwise> <!-- bibliography -->
					<xsl:element name="bibliography" namespace="{$namespace_full}"> <!-- save context element -->
						<xsl:element name="page_sequence" namespace="{$namespace_full}">
							<xsl:attribute name="main_page_sequence"/>
							<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak"/>
						</xsl:element>
					</xsl:element>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>
  
	<xsl:template name="insertAnnexInSeparatePageSequences">
		<xsl:for-each select="/*/mn:annex">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:element name="page_sequence" namespace="{$namespace_full}">
				<xsl:attribute name="main_page_sequence"/>
				<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak"/>
			</xsl:element>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="insertBibliographyInSeparatePageSequences">
		<xsl:element name="bibliography" namespace="{$namespace_full}"> <!-- save context element -->
			<xsl:for-each select="/*/mn:bibliography/*[not(@normative='true')] | 
									/*/mn:bibliography/mn:clause[mn:references[not(@normative='true')]]">
				<xsl:sort select="@displayorder" data-type="number"/>
				<xsl:element name="page_sequence" namespace="{$namespace_full}">
					<xsl:attribute name="main_page_sequence"/>
					<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak"/>
				</xsl:element>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	<xsl:template name="insertIndexInSeparatePageSequences">
		<xsl:for-each select="/*/mn:indexsect">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:element name="page_sequence" namespace="{$namespace_full}">
				<xsl:attribute name="main_page_sequence"/>
				<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak"/>
			</xsl:element>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template name="processAllSectionsDefault_items">
		<xsl:variable name="updated_xml_step_move_pagebreak">
			<xsl:element name="{$root_element}" namespace="{$namespace_full}">
				<xsl:call-template name="copyCommonElements"/>
				<xsl:element name="page_sequence" namespace="{$namespace_full}">				
					<xsl:call-template name="insertPrefaceSections"/>
					<xsl:call-template name="insertMainSections"/>
				</xsl:element>
			</xsl:element>
		</xsl:variable>
		
		<xsl:variable name="updated_xml_step_move_pagebreak_filename" select="concat($output_path,'_preface_and_main_', java:getTime(java:java.util.Date.new()), '.xml')"/>
		<!-- <xsl:message>updated_xml_step_move_pagebreak_filename=<xsl:value-of select="$updated_xml_step_move_pagebreak_filename"/></xsl:message>
		<xsl:message>start write updated_xml_step_move_pagebreak_filename</xsl:message> -->
		<redirect:write file="{$updated_xml_step_move_pagebreak_filename}">
			<xsl:copy-of select="$updated_xml_step_move_pagebreak"/>
		</redirect:write>
		<!-- <xsl:message>end write updated_xml_step_move_pagebreak_filename</xsl:message> -->
		
		<xsl:copy-of select="document($updated_xml_step_move_pagebreak_filename)"/>
		
		<!-- TODO: instead of 
		<xsl:for-each select=".//mn:page_sequence[normalize-space() != '' or .//image or .//svg]">
		in each template, add removing empty page_sequence here
		-->
		
		<xsl:if test="$debug = 'true'">
			<redirect:write file="page_sequence_preface_and_main.xml">
				<xsl:copy-of select="$updated_xml_step_move_pagebreak"/>
			</redirect:write>
		</xsl:if>
		
		<!-- <xsl:message>start delete updated_xml_step_move_pagebreak_filename</xsl:message> -->
		<xsl:call-template name="deleteFile">
			<xsl:with-param name="filepath" select="$updated_xml_step_move_pagebreak_filename"/>
		</xsl:call-template>
		<!-- <xsl:message>end delete updated_xml_step_move_pagebreak_filename</xsl:message> -->
	</xsl:template> <!-- END: processAllSectionsDefault_items -->
	
	<xsl:template name="insertPrefaceSections">
		<xsl:element name="preface" namespace="{$namespace_full}"> <!-- save context element -->
			<xsl:for-each select="/*/mn:preface/*[not(self::mn:note or self::mn:admonition)]">
				<xsl:sort select="@displayorder" data-type="number"/>
				<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak">
					<xsl:with-param name="page_sequence_at_top">true</xsl:with-param>
				</xsl:apply-templates>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	
	<xsl:template name="insertMainSections">
		<xsl:element name="sections" namespace="{$namespace_full}"> <!-- save context element -->
		
			<xsl:for-each select="/*/mn:sections/* | /*/mn:bibliography/mn:references[@normative='true']">
				<xsl:sort select="@displayorder" data-type="number"/>
				<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak">
					<xsl:with-param name="page_sequence_at_top">true</xsl:with-param>
				</xsl:apply-templates>
				<xsl:if test="$namespace = 'm3d'">
					<xsl:if test="self::mn:clause and @type='scope'">
						<xsl:if test="/*/mn:bibliography/mn:references[@normative='true']">
							<fo:block break-after="page"/>
							<xsl:element name="pagebreak" namespace="{$namespace_full}"/>
						</xsl:if>
					</xsl:if>
				</xsl:if>
			</xsl:for-each>
		</xsl:element>

		<xsl:for-each select="/*/mn:annex">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak">
					<xsl:with-param name="page_sequence_at_top">true</xsl:with-param>
				</xsl:apply-templates>
		</xsl:for-each>

		<xsl:element name="bibliography" namespace="{$namespace_full}"> <!-- save context element -->
			<xsl:for-each select="/*/mn:bibliography/*[not(@normative='true')] | 
									/*/mn:bibliography/mn:clause[mn:references[not(@normative='true')]]">
				<xsl:sort select="@displayorder" data-type="number"/>
				<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak">
					<xsl:with-param name="page_sequence_at_top">true</xsl:with-param>
				</xsl:apply-templates>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	
</xsl:stylesheet>