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
	
	<xsl:attribute-set name="link-style">
		<xsl:if test="$namespace = 'bsi' or $namespace = 'pas'">
			<xsl:attribute name="color">rgb(58,88,168)</xsl:attribute>
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee' or $namespace = 'iso' or $namespace = 'itu' or $namespace = 'csd' or $namespace = 'ogc-white-paper' or $namespace = 'm3d' or $namespace = 'iho' or $namespace = 'mpfd' or $namespace = 'bipm' or $namespace = 'jcgm'">
			<xsl:attribute name="color">blue</xsl:attribute>
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:attribute name="color"><xsl:value-of select="$color_blue"/></xsl:attribute>
			<xsl:attribute name="font-weight">300</xsl:attribute><!-- bold -->
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc'">
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'csa'">
			<xsl:attribute name="color">rgb(33, 94, 159)</xsl:attribute>
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>

	<xsl:template name="refine_link-style">
		<xsl:if test="$namespace = 'pas'">
			<xsl:attribute name="color">inherit</xsl:attribute>
			<xsl:attribute name="text-decoration">none</xsl:attribute>
			<xsl:if test="$doctype = 'flex-standard' and ancestor::mn:copyright-statement">
				<xsl:attribute name="color"><xsl:value-of select="$color_secondary_shade_1_PAS"/></xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'ieee'">
			<xsl:if test="$current_template = 'whitepaper' or $current_template = 'icap-whitepaper' or $current_template = 'industry-connection-report'">
				<xsl:attribute name="color"><xsl:value-of select="$color_blue"/></xsl:attribute>
				<xsl:attribute name="text-decoration">none</xsl:attribute>
			</xsl:if>
			<xsl:if test="$current_template = 'standard'">
				<xsl:attribute name="color"><xsl:value-of select="$color_blue"/></xsl:attribute>
				<xsl:attribute name="text-decoration">none</xsl:attribute>
				<xsl:if test="ancestor::mn:feedback-statement">
					<xsl:attribute name="text-decoration">underline</xsl:attribute>
				</xsl:if>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:if test="ancestor::*[self::mn:feedback-statement or self::mn:copyright-statement]">
				<xsl:attribute name="color">blue</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:variable name="layoutVersion">
				<xsl:call-template name="getVariable"><xsl:with-param name="variable">layoutVersion</xsl:with-param></xsl:call-template>
			</xsl:variable>
			<xsl:if test="(ancestor::mn:copyright-statement and contains(@target, 'mailto:')) or
							($layoutVersion = '2024' and ancestor::mn:fmt-termsource)">
				<xsl:attribute name="color">inherit</xsl:attribute>
				<xsl:attribute name="text-decoration">none</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:if test="@style = 'url'">
				<xsl:attribute name="font-family">Arial</xsl:attribute>
				<xsl:attribute name="font-size">8pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'rsd'">
			<xsl:if test="ancestor::mn:bibitem">
				<xsl:attribute name="color">black</xsl:attribute>
				<xsl:attribute name="text-decoration">none</xsl:attribute>
				<xsl:attribute name="font-weight">300</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template> <!-- refine_link-style -->

	<xsl:template match="mn:fmt-link" name="link">
		<xsl:variable name="target_normalized" select="translate(@target, '\', '/')"/>
		<xsl:variable name="target_attachment_name" select="substring-after($target_normalized, '_attachments/')"/>
		<xsl:variable name="isLinkToEmbeddedFile" select="normalize-space(@attachment = 'true' and $pdfAttachmentsList//attachment[@filename = current()/@target])"/>
		<xsl:variable name="target">
			<xsl:choose>
				<xsl:when test="@updatetype = 'true'">
					<xsl:value-of select="concat(normalize-space(@target), '.pdf')"/>
				</xsl:when>
				<!-- link to the PDF attachment -->
				<xsl:when test="$isLinkToEmbeddedFile = 'true'">
					<xsl:variable name="target_file" select="java:org.metanorma.fop.Util.getFilenameFromPath(@target)"/>
					<xsl:value-of select="concat('url(embedded-file:', $target_file, ')')"/>
				</xsl:when>
				<!-- <xsl:when test="starts-with($target_normalized, '_') and contains($target_normalized, '_attachments/') and $pdfAttachmentsList//attachment[@filename = $target_attachment_name]">
					<xsl:value-of select="concat('url(embedded-file:', $target_attachment_name, ')')"/>
				</xsl:when>
				<xsl:when test="contains(@target, concat('_', $inputxml_filename_prefix, '_attachments'))">
					<xsl:variable name="target_" select="translate(@target, '\', '/')"/>
					<xsl:variable name="target__" select="substring-after($target_, concat('_', $inputxml_filename_prefix, '_attachments', '/'))"/>
					<xsl:value-of select="concat('url(embedded-file:', $target__, ')')"/>
				</xsl:when> -->
				
				<!-- <xsl:when test="not(starts-with(@target, 'http:') or starts-with(@target, 'https') or starts-with(@target, 'www') or starts-with(@target, 'mailto') or starts-with(@target, 'ftp'))">
					<xsl:variable name="target_" select="translate(@target, '\', '/')"/>
					<xsl:variable name="filename">
						<xsl:call-template name="substring-after-last">
							<xsl:with-param name="value" select="$target_"/>
							<xsl:with-param name="delimiter" select="'/'"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:variable name="target_filepath" select="concat($inputxml_basepath, @target)"/>
					<xsl:variable name="file_exists" select="normalize-space(java:exists(java:java.io.File.new($target_filepath)))"/>
					<xsl:choose>
						<xsl:when test="$file_exists = 'true'">
							<xsl:value-of select="concat('url(embedded-file:', $filename, ')')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="normalize-space(@target)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when> -->
				
				<xsl:otherwise>
					<xsl:value-of select="normalize-space(@target)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="target_text">
			<xsl:choose>
				<xsl:when test="starts-with(normalize-space(@target), 'mailto:')">
					<xsl:value-of select="normalize-space(substring-after(@target, 'mailto:'))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space(@target)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<fo:inline xsl:use-attribute-sets="link-style">
			
			<xsl:if test="starts-with(normalize-space(@target), 'mailto:') and not(ancestor::*[local-name() = 'td'])">
				<xsl:attribute name="keep-together.within-line">always</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="$isLinkToEmbeddedFile = 'true'">
				<xsl:attribute name="color">inherit</xsl:attribute>
				<xsl:attribute name="text-decoration">none</xsl:attribute>
			</xsl:if>
			
			<xsl:call-template name="refine_link-style"/>
			
			<xsl:choose>
				<xsl:when test="$target_text = ''">
					<xsl:apply-templates />
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="alt_text">
						<xsl:call-template name="getAltText"/>
					</xsl:variable>
					<xsl:call-template name="insert_basic_link">
						<xsl:with-param name="element">
							<fo:basic-link external-destination="{$target}" fox:alt-text="{$alt_text}">
								<xsl:if test="$isLinkToEmbeddedFile = 'true'">
									<xsl:attribute name="role">Annot</xsl:attribute>
								</xsl:if>
								<xsl:choose>
									<xsl:when test="normalize-space(.) = ''">
										<xsl:call-template name="add-zero-spaces-link-java">
											<xsl:with-param name="text" select="$target_text"/>
										</xsl:call-template>
									</xsl:when>
									<xsl:otherwise>
										<!-- output text from <link>text</link> -->
										<xsl:choose>
											<xsl:when test="starts-with(., 'http://') or starts-with(., 'https://') or starts-with(., 'www.')">
												<xsl:call-template name="add-zero-spaces-link-java">
													<xsl:with-param name="text" select="."/>
												</xsl:call-template>
											</xsl:when>
											<xsl:otherwise>
												<xsl:apply-templates />
											</xsl:otherwise>
										</xsl:choose>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:if test="$isLinkToEmbeddedFile = 'true'">
									<!-- paper clip icon rendering moved here from
									org/apache/pdfbox/pdmodel/interactive/annotation/handlers/PDFileAttachmentAppearanceHandler.java drawPaperclip
									for https://github.com/metanorma/metanorma-pdfa/issues/71 -->
									<xsl:call-template name="drawPaperClip"/>
								</xsl:if>
							</fo:basic-link>
							<!-- <xsl:if test="$isLinkToEmbeddedFile = 'true'">
								<!- - reserve space at right for PaperClip icon - ->
								<fo:inline keep-with-previous.within-line="always">&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;</fo:inline>
							</xsl:if> -->
						</xsl:with-param>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</fo:inline>
	</xsl:template> <!-- link -->

	<xsl:template name="drawPaperClip">
		<fo:wrapper role="artifact">
			<fo:inline-container width="6mm" height="1mm" keep-with-previous.within-line="always" id="__internal_layout__attachment_{@target}_{generate-id()}">
				<!-- underline for paperclip icon -->
				<fo:block line-height="0.5">&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;</fo:block>
				<fo:block margin-top="-4mm" text-decoration="underline" font-size="1pt" text-align="center">
					<fo:instream-foreign-object content-height="3.8mm" scaling="uniform" fox:alt-text="PaperClip" fox:placement="Inline">
						<xsl:copy-of select="$paperClipImage"/>
					</fo:instream-foreign-object>
				</fo:block>
			</fo:inline-container>
		</fo:wrapper>
	</xsl:template>

	<xsl:variable name="paperClipImage">
		<!-- <svg width="17" height="17" xmlns="http://www.w3.org/2000/svg">
			<path style="transform-origin: center; transform: scale(1, -1);"
			d="M 13.574 9.301
			L 8.926 13.949
			C 7.648 15.227 5.625 15.227 4.426 13.949
			C 3.148 12.676 3.148 10.648 4.426 9.449
			L 10.426 3.449
			C 11.176 2.773 12.301 2.773 13.051 3.449
			C 13.801 4.199 13.801 5.398 13.051 6.074
			L 7.875 11.25
			C 7.648 11.477 7.273 11.477 7.051 11.25
			C 6.824 11.023 6.824 10.648 7.051 10.426
			L 10.875 6.602
			C 11.176 6.301 11.176 5.852 10.875 5.551
			C 10.574 5.25 10.125 5.25 9.824 5.551
			L 6 9.449
			C 5.176 10.273 5.176 11.551 6 12.375
			C 6.824 13.125 8.102 13.125 8.926 12.375
			L 14.102 7.199
			C 15.449 5.852 15.449 3.75 14.102 2.398
			C 12.75 1.051 10.648 1.051 9.301 2.398
			L 3.301 8.398
			C 2.398 9.301 1.949 10.5 1.949 11.699
			C 1.949 14.324 4.051 16.352 6.676 16.352
			C 7.949 16.352 9.074 15.824 9.977 15
			L 14.625 10.352
			C 14.926 10.051 14.926 9.602 14.625 9.301
			C 14.324 9 13.875 9 13.574 9.301"
			stroke="none" fill="black" />
			</svg> -->
		<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 13.16 14.96">
			<path d="m11.63,7.05c.3.3.75.3,1.05,0,.3-.3.3-.75,0-1.05L8.03,1.35c-.9-.82-2.03-1.35-3.3-1.35C2.1,0,0,2.03,0,4.65c0,1.2.45,2.4,1.35,3.3l6,6c1.35,1.35,3.45,1.35,4.8,0,1.35-1.35,1.35-3.45,0-4.8L6.98,3.98c-.82-.75-2.1-.75-2.93,0-.82.82-.82,2.1,0,2.93l3.82,3.9c.3.3.75.3,1.05,0s.3-.75,0-1.05l-3.82-3.82c-.23-.22-.23-.6,0-.82.22-.23.6-.23.82,0l5.18,5.18c.75.68.75,1.88,0,2.62-.75.68-1.88.68-2.62,0L2.48,6.9c-1.28-1.2-1.28-3.23,0-4.5,1.2-1.28,3.22-1.28,4.5,0l4.65,4.65" style="stroke-width: 0px;"/>
		</svg>
	</xsl:variable>

</xsl:stylesheet>