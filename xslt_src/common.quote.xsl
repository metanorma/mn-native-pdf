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
	
	<xsl:attribute-set name="quote-style">
		<xsl:attribute name="margin-left">12mm</xsl:attribute>
		<xsl:attribute name="margin-right">12mm</xsl:attribute>
		<xsl:if test="$namespace = 'csa' or $namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'rsd'">
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-left">13mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'bsi' or $namespace = 'pas' or $namespace = 'csd' or $namespace = 'gb' or $namespace = 'iso' or $namespace = 'm3d'">
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jcgm'">
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="font-style">italic</xsl:attribute>
			<xsl:attribute name="text-align">justify</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="margin-top">5pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">10pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iho'">			
			<xsl:attribute name="font-family">Calibri</xsl:attribute>
			<xsl:attribute name="margin-left">4.5mm</xsl:attribute>
			<xsl:attribute name="margin-right">9mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'itu'">
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:attribute name="margin-left">0mm</xsl:attribute>
			<xsl:attribute name="margin-right">0mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'mpfd'">
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="text-align">justify</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'plateau'">
			<xsl:attribute name="margin-left">0mm</xsl:attribute>
			<xsl:attribute name="margin-right">0mm</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- quote-style -->
	
	<xsl:template name="refine_quote-style">
		<xsl:if test="$namespace = 'iso'">
			<xsl:if test="$doctype = 'amendment' and (mn:note or mn:termnote)">
				<xsl:attribute name="margin-left">7mm</xsl:attribute>
				<xsl:attribute name="margin-right">0mm</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'jcgm'">
			<xsl:if test="ancestor::mn:boilerplate">
				<xsl:attribute name="margin-left">7mm</xsl:attribute>
				<xsl:attribute name="margin-right">7mm</xsl:attribute>
				<xsl:attribute name="font-style">normal</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$namespace = 'jis'">
			<xsl:if test="ancestor::mn:li">
				<xsl:attribute name="margin-left">7.5mm</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template> <!-- refine_quote-style -->

	<xsl:attribute-set name="quote-source-style">		
		<xsl:attribute name="text-align">right</xsl:attribute>
		<xsl:if test="$namespace = 'csa' or $namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'rsd'">
			<xsl:attribute name="margin-right">25mm</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iec'">
			<xsl:attribute name="margin-top">15pt</xsl:attribute>
			<xsl:attribute name="margin-left">12mm</xsl:attribute>
			<xsl:attribute name="margin-right">12mm</xsl:attribute>			 
		</xsl:if>		
	</xsl:attribute-set> <!-- quote-source-style -->
	
	<xsl:template name="refine_quote-source-style">
	</xsl:template>
	
	<xsl:attribute-set name="source-style">
		<xsl:if test="$namespace = 'plateau'">
			<xsl:attribute name="space-after">8pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set> <!-- source-style -->
	
	<xsl:template name="refine_source-style">
	
	</xsl:template> <!-- refine_source-style -->
	
	<!-- ====== -->
	<!-- quote -->	
	<!-- source -->	
	<!-- author  -->	
	<!-- ====== -->
	<xsl:template match="mn:quote">		
		<fo:block-container margin-left="0mm" role="SKIP">
		
			<xsl:call-template name="setBlockSpanAll"/>
			
			<xsl:if test="parent::mn:note">
				<xsl:if test="not(ancestor::mn:table)">
					<xsl:attribute name="margin-left">5mm</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$namespace = 'gb'">
				<xsl:attribute name="margin-left">0mm</xsl:attribute>
			</xsl:if>
			<xsl:if test="$namespace = 'jcgm'">
				<xsl:if test="not(*)">
					<xsl:attribute name="space-after">12pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<fo:block-container margin-left="0mm" role="SKIP">
				<fo:block-container xsl:use-attribute-sets="quote-style" role="SKIP">
				
					<xsl:call-template name="refine_quote-style"/>

					<fo:block-container margin-left="0mm" margin-right="0mm" role="SKIP">
						<fo:block role="BlockQuote">
							<xsl:apply-templates select="./node()[not(self::mn:author) and 
							not(self::mn:fmt-source) and 
							not(self::mn:attribution)]"/> <!-- process all nested nodes, except author and source -->
						</fo:block>
					</fo:block-container>
				</fo:block-container>
				<xsl:if test="mn:author or mn:fmt-source or mn:attribution">
					<fo:block xsl:use-attribute-sets="quote-source-style">
						<xsl:call-template name="refine_quote-source-style"/>
						<!-- — ISO, ISO 7301:2011, Clause 1 -->
						<xsl:apply-templates select="mn:author"/>
						<xsl:apply-templates select="mn:fmt-source"/>
						<!-- added for https://github.com/metanorma/isodoc/issues/607 -->
						<xsl:apply-templates select="mn:attribution/mn:p/node()"/>
					</fo:block>
				</xsl:if>
				
				<xsl:if test="$namespace = 'jis'">
					<!-- render footnotes after references -->
					<xsl:apply-templates select=".//mn:fn[generate-id(.)=generate-id(key('kfn',@reference)[1])]" mode="fn_after_element">
						<xsl:with-param name="ancestor">quote</xsl:with-param>
					</xsl:apply-templates>
				</xsl:if>
        
			</fo:block-container>
		</fo:block-container>
	</xsl:template>

	
	<xsl:template match="mn:fmt-source">
		<xsl:if test="../mn:author">
			<xsl:text>, </xsl:text>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="not(parent::quote)">
				<fo:block xsl:use-attribute-sets="source-style">
					<xsl:call-template name="refine_source-style"/>
					
					<xsl:call-template name="insert_basic_link">
						<xsl:with-param name="element">
							<fo:basic-link internal-destination="{@bibitemid}" fox:alt-text="{@citeas}">
								<xsl:apply-templates />
							</fo:basic-link>
						</xsl:with-param>
					</xsl:call-template>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="insert_basic_link">
					<xsl:with-param name="element">
						<fo:basic-link internal-destination="{@bibitemid}" fox:alt-text="{@citeas}">
							<xsl:apply-templates />
						</fo:basic-link>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="mn:author">
		<xsl:if test="local-name(..) = 'quote'"> <!-- for old Presentation XML, https://github.com/metanorma/isodoc/issues/607 -->
			<xsl:text>— </xsl:text>
		</xsl:if>
		<xsl:apply-templates />
	</xsl:template>
	
	<xsl:template match="mn:quote//mn:referenceFrom"/>
	<!-- ====== -->
	<!-- ====== -->
	
</xsl:stylesheet>