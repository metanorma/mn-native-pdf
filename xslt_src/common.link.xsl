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
							</fo:basic-link>
							<xsl:if test="$isLinkToEmbeddedFile = 'true'">
								<!-- reserve space at right for PaperClip icon -->
								<fo:inline keep-with-previous.within-line="always">&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;</fo:inline>
							</xsl:if>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</fo:inline>
	</xsl:template> <!-- link -->

</xsl:stylesheet>