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
	
	<!-- Index section styles -->
	<xsl:attribute-set name="indexsect-title-style">
		<xsl:attribute name="role">H1</xsl:attribute>
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="font-size">16pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="margin-bottom">84pt</xsl:attribute>
			<xsl:attribute name="margin-left">-18mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="font-size">18pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="margin-bottom">24pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="font-size">12pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="margin-bottom">84pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="font-size">16pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="margin-bottom">84pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jcgm'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="span">all</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'plateau'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="span">all</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- indexsect-title-style -->
	
	<xsl:template name="refine_indexsect-title-style">
	</xsl:template>
	
	<xsl:attribute-set name="indexsect-clause-title-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:if test="$namespace = 'bipm'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="margin-bottom">3pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bsi'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="margin-bottom">3pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="margin-bottom">3pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="margin-bottom">3pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jcgm'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="margin-left">25mm</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- indexsect-clause-title-style -->
	
	<xsl:template name="refine_indexsect-clause-title-style">
	</xsl:template>
	<!-- End Index section styles -->
	
	<!-- =================== -->
	<!-- Index section processing -->
	<!-- =================== -->

	<xsl:variable name="index" select="document($external_index)"/>
	
	<xsl:variable name="bookmark_in_fn">
		<xsl:for-each select="//mn:bookmark[ancestor::mn:fn]">
			<bookmark><xsl:value-of select="@id"/></bookmark>
		</xsl:for-each>
	</xsl:variable>

	<xsl:template match="@*|node()" mode="index_add_id">
		<xsl:param name="docid"/>
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="index_add_id">
				<xsl:with-param name="docid" select="$docid"/>
			</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="mn:xref" mode="index_add_id"/>
	<xsl:template match="mn:fmt-xref" mode="index_add_id">
		<xsl:param name="docid"/>
		<xsl:variable name="id">
			<xsl:call-template name="generateIndexXrefId">
				<xsl:with-param name="docid" select="$docid"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:copy> <!-- add id to xref -->
			<xsl:apply-templates select="@*" mode="index_add_id"/>
			<xsl:attribute name="id">
				<xsl:value-of select="$id"/>
			</xsl:attribute>
			<xsl:apply-templates mode="index_add_id">
				<xsl:with-param name="docid" select="$docid"/>
			</xsl:apply-templates>
		</xsl:copy>
		<!-- split <xref target="bm1" to="End" pagenumber="true"> to two xref:
		<xref target="bm1" pagenumber="true"> and <xref target="End" pagenumber="true"> -->
		<xsl:if test="@to">
			<xsl:value-of select="$en_dash"/>
			<xsl:copy>
				<xsl:copy-of select="@*"/>
				<xsl:attribute name="target"><xsl:value-of select="@to"/></xsl:attribute>
				<xsl:attribute name="id">
					<xsl:value-of select="$id"/><xsl:text>_to</xsl:text>
				</xsl:attribute>
				<xsl:apply-templates mode="index_add_id">
					<xsl:with-param name="docid" select="$docid"/>
				</xsl:apply-templates>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<xsl:template match="@*|node()" mode="index_update">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="index_update"/>
		</xsl:copy>
	</xsl:template>
	
	
	<xsl:template match="mn:indexsect//mn:li" mode="index_update">
		<xsl:copy>
			<xsl:apply-templates select="@*"  mode="index_update"/>
		<xsl:apply-templates select="node()[not(self::mn:fmt-name)][1]" mode="process_li_element"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="mn:indexsect//mn:li/node()" mode="process_li_element" priority="2">
		<xsl:param name="element" />
		<xsl:param name="remove" select="'false'"/>
		<xsl:param name="target"/>
		<!-- <node></node> -->
		<xsl:choose>
			<xsl:when test="self::text()  and (normalize-space(.) = ',' or normalize-space(.) = $en_dash) and $remove = 'true'">
				<!-- skip text (i.e. remove it) and process next element -->
				<!-- [removed_<xsl:value-of select="."/>] -->
				<xsl:apply-templates select="following-sibling::node()[1]" mode="process_li_element">
					<xsl:with-param name="target"><xsl:value-of select="$target"/></xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="self::text()">
				<xsl:value-of select="."/>
				<xsl:apply-templates select="following-sibling::node()[1]" mode="process_li_element"/>
			</xsl:when>
			<xsl:when test="self::* and local-name(.) = 'fmt-xref'">
				<xsl:variable name="id" select="@id"/>
				
				<xsl:variable name="id_next" select="following-sibling::mn:fmt-xref[1]/@id"/>
				<xsl:variable name="id_prev" select="preceding-sibling::mn:fmt-xref[1]/@id"/>
				
				<xsl:variable name="pages_">
					<xsl:for-each select="$index/index/item[@id = $id or @id = $id_next or @id = $id_prev]">
						<xsl:choose>
							<xsl:when test="@id = $id">
								<page><xsl:value-of select="."/></page>
							</xsl:when>
							<xsl:when test="@id = $id_next">
								<page_next><xsl:value-of select="."/></page_next>
							</xsl:when>
							<xsl:when test="@id = $id_prev">
								<page_prev><xsl:value-of select="."/></page_prev>
							</xsl:when>
						</xsl:choose>
					</xsl:for-each>
				</xsl:variable>
				<xsl:variable name="pages" select="xalan:nodeset($pages_)"/>
				
				<!-- <xsl:variable name="page" select="$index/index/item[@id = $id]"/> -->
				<xsl:variable name="page" select="$pages/page"/>
				<!-- <xsl:variable name="page_next" select="$index/index/item[@id = $id_next]"/> -->
				<xsl:variable name="page_next" select="$pages/page_next"/>
				<!-- <xsl:variable name="page_prev" select="$index/index/item[@id = $id_prev]"/> -->
				<xsl:variable name="page_prev" select="$pages/page_prev"/>
				
				<xsl:choose>
					<!-- 2nd pass -->
					<!-- if page is equal to page for next and page is not the end of range -->
					<xsl:when test="$page != '' and $page_next != '' and $page = $page_next and not(contains($page, '_to'))">  <!-- case: 12, 12-14 -->
						<!-- skip element (i.e. remove it) and remove next text ',' -->
						<!-- [removed_xref] -->
						
						<xsl:apply-templates select="following-sibling::node()[1]" mode="process_li_element">
							<xsl:with-param name="remove">true</xsl:with-param>
							<xsl:with-param name="target">
								<xsl:choose>
									<xsl:when test="$target != ''"><xsl:value-of select="$target"/></xsl:when>
									<xsl:otherwise><xsl:value-of select="@target"/></xsl:otherwise>
								</xsl:choose>
							</xsl:with-param>
						</xsl:apply-templates>
					</xsl:when>
					
					<xsl:when test="$page != '' and $page_prev != '' and $page = $page_prev and contains($page_prev, '_to')"> <!-- case: 12-14, 14, ... -->
						<!-- remove xref -->
						<xsl:apply-templates select="following-sibling::node()[1]" mode="process_li_element">
							<xsl:with-param name="remove">true</xsl:with-param>
						</xsl:apply-templates>
					</xsl:when>

					<xsl:otherwise>
						<xsl:apply-templates select="." mode="xref_copy">
							<xsl:with-param name="target" select="$target"/>
						</xsl:apply-templates>
						<xsl:apply-templates select="following-sibling::node()[1]" mode="process_li_element"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="self::* and local-name(.) = 'ul'">
				<!-- ul -->
				<xsl:apply-templates select="." mode="index_update"/>
			</xsl:when>
			<xsl:otherwise>
			 <xsl:apply-templates select="." mode="xref_copy">
					<xsl:with-param name="target" select="$target"/>
				</xsl:apply-templates>
				<xsl:apply-templates select="following-sibling::node()[1]" mode="process_li_element"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="@*|node()" mode="xref_copy">
		<xsl:param name="target"/>
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="xref_copy"/>
			<xsl:if test="$target != '' and not(xalan:nodeset($bookmark_in_fn)//bookmark[. = $target])">
				<xsl:attribute name="target"><xsl:value-of select="$target"/></xsl:attribute>
			</xsl:if>
			<xsl:apply-templates select="node()" mode="xref_copy"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template name="generateIndexXrefId">
		<xsl:param name="docid" />
		
		<xsl:variable name="level" select="count(ancestor::mn:ul)"/>
		
		<xsl:variable name="docid_curr">
			<xsl:value-of select="$docid"/>
			<xsl:if test="normalize-space($docid) = ''"><xsl:call-template name="getDocumentId"/></xsl:if>
		</xsl:variable>
		
		<xsl:variable name="item_number">
			<xsl:number count="mn:li[ancestor::mn:indexsect]" level="any" />
		</xsl:variable>
		<xsl:variable name="xref_number"><xsl:number count="mn:fmt-xref"/></xsl:variable>
		<xsl:value-of select="concat($docid_curr, '_', $item_number, '_', $xref_number)"/> <!-- $level, '_',  -->
	</xsl:template>

	<xsl:template match="mn:indexsect/mn:fmt-title | mn:indexsect/mn:title" priority="4">
		<fo:block xsl:use-attribute-sets="indexsect-title-style">
			<xsl:call-template name="refine_indexsect-title-style"/>
			<!-- Index -->
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:indexsect/mn:clause/mn:fmt-title | mn:indexsect/mn:clause/mn:title" priority="4">
		<!-- Letter A, B, C, ... -->
		<fo:block xsl:use-attribute-sets="indexsect-clause-title-style">
			<xsl:call-template name="refine_indexsect-clause-title-style"/>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:indexsect/mn:clause" priority="4">
		<xsl:apply-templates />
		<fo:block>
			<xsl:if test="following-sibling::mn:clause">
				<fo:block>&#xA0;</fo:block>
			</xsl:if>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="mn:indexsect//mn:ul" priority="4">
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="mn:indexsect//mn:li" priority="4">
		<xsl:variable name="level" select="count(ancestor::mn:ul)" />
		<fo:block start-indent="{5 * $level}mm" text-indent="-5mm">
			<xsl:if test="$namespace = 'bsi'">
				<xsl:if test="count(ancestor::mn:ul) = 1">
					<xsl:variable name="prev_first_char" select="java:toLowerCase(java:java.lang.String.new(substring(normalize-space(preceding-sibling::mn:li[1]), 1, 1)))"/>
					<xsl:variable name="curr_first_char" select="java:toLowerCase(java:java.lang.String.new(substring(normalize-space(), 1, 1)))"/>
					<xsl:if test="$curr_first_char != $prev_first_char and preceding-sibling::mn:li">
						<xsl:attribute name="space-before">12pt</xsl:attribute>
					</xsl:if>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$namespace = 'plateau'">
				<xsl:attribute name="space-after">12pt</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="mn:indexsect//mn:li/text()">
		<!-- to split by '_' and other chars -->
		<xsl:call-template name="add-zero-spaces-java"/>
	</xsl:template>
	
	<xsl:template match="mn:table/mn:bookmark" priority="2"/>
	
	<xsl:template match="mn:bookmark" name="bookmark">
		<xsl:variable name="bookmark_id" select="@id"/>
		<xsl:choose>
			<!-- Example:
				<fmt-review-start id="_7ef81cf7-3f6c-4ed4-9c1f-1ba092052bbd" source="_dda23915-8574-ef1e-29a1-822d465a5b97" target="_ecfb2210-3b1b-46a2-b63a-8b8505be6686" end="_dda23915-8574-ef1e-29a1-822d465a5b97" author="" date="2025-03-24T00:00:00Z"/>
				<bookmark id="_dda23915-8574-ef1e-29a1-822d465a5b97"/>
				<fmt-review-end id="_f336a8d0-08a8-4b7f-a1aa-b04688ed40c1" source="_dda23915-8574-ef1e-29a1-822d465a5b97" target="_ecfb2210-3b1b-46a2-b63a-8b8505be6686" start="_dda23915-8574-ef1e-29a1-822d465a5b97" author="" date="2025-03-24T00:00:00Z"/> -->
			<xsl:when test="1 = 2 and preceding-sibling::node()[self::mn:fmt-annotation-start][@source = $bookmark_id] and 
						following-sibling::node()[self::mn:fmt-annotation-end][@source = $bookmark_id]">
				<!-- skip here, see the template 'fmt-review-start' -->
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="parent::mn:example or parent::mn:termexample or parent::mn:note or parent::mn:termnote">
						<fo:block font-size="1pt" line-height="0.1">
							<xsl:call-template name="fo_inline_bookmark">
								<xsl:with-param name="bookmark_id" select="$bookmark_id"/>
							</xsl:call-template>
						</fo:block>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="fo_inline_bookmark">
							<xsl:with-param name="bookmark_id" select="$bookmark_id"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="fo_inline_bookmark">
		<xsl:param name="bookmark_id"/>
		<!-- <fo:inline id="{@id}" font-size="1pt"/> -->
		<fo:inline id="{@id}" font-size="1pt"><xsl:if test="preceding-sibling::node()[self::mn:fmt-annotation-start][@source = $bookmark_id] and 
				following-sibling::node()[self::mn:fmt-annotation-end][@source = $bookmark_id]"><xsl:attribute name="line-height">0.1</xsl:attribute></xsl:if><xsl:value-of select="$hair_space"/></fo:inline>
		<!-- we need to add zero-width space, otherwise this fo:inline is missing in IF xml -->
		<xsl:if test="not(following-sibling::node()[normalize-space() != ''])"><fo:inline font-size="1pt">&#xA0;</fo:inline></xsl:if>
	</xsl:template>
	<!-- =================== -->
	<!-- End of Index processing -->
	<!-- =================== -->
	
</xsl:stylesheet>