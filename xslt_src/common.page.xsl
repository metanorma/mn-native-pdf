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
	
	<!--
	<metanorma-extension>
		<presentation-metadata>
			<papersize>letter</papersize>
		</presentation-metadata>
	</metanorma-extension>
	-->
	
	<xsl:variable name="papersize" select="java:toLowerCase(java:java.lang.String.new(normalize-space(//mn:metanorma/mn:metanorma-extension/mn:presentation-metadata/mn:papersize)))"/>
	<xsl:variable name="papersize_width_">
		<xsl:choose>
			<xsl:when test="$papersize = 'letter'">215.9</xsl:when>
			<xsl:when test="$papersize = 'a4'">210</xsl:when>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="papersize_width" select="normalize-space($papersize_width_)"/>
	<xsl:variable name="papersize_height_">
		<xsl:choose>
			<xsl:when test="$papersize = 'letter'">279.4</xsl:when>
			<xsl:when test="$papersize = 'a4'">297</xsl:when>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="papersize_height" select="normalize-space($papersize_height_)"/>
	
	<!-- page width in mm -->
	<xsl:variable name="pageWidth_">
		<xsl:choose>
			<xsl:when test="$papersize_width != ''"><xsl:value-of select="$papersize_width"/></xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$namespace = 'csa' or $namespace = 'ieee' or $namespace = 'm3d' or $namespace = 'nist-cswp' or $namespace = 'nist-sp' or 
					$namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'rsd'">215.9</xsl:when> <!-- paper size letter -->
					<xsl:otherwise>210</xsl:otherwise> <!-- paper size A4 (default value) -->
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="pageWidth" select="normalize-space($pageWidth_)"/>
	
	<!-- page height in mm -->
	<xsl:variable name="pageHeight_">
		<xsl:choose>
			<xsl:when test="$papersize_height != ''"><xsl:value-of select="$papersize_height"/></xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$namespace = 'csa' or $namespace = 'ieee' or $namespace = 'm3d' or $namespace = 'nist-cswp' or $namespace = 'nist-sp' or 
					$namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'rsd'">279.4</xsl:when> <!-- paper size letter -->
					<xsl:otherwise>297</xsl:otherwise> <!-- paper size A4 (default value) -->
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="pageHeight" select="normalize-space($pageHeight_)"/>
	
	<!-- Page margins in mm (just digits, without 'mm')-->
	<!-- marginLeftRight1 and marginLeftRight2 - is left or right margin depends on odd/even page,
	for example, left margin on odd page and right margin on even page -->
	<xsl:variable name="marginLeftRight1_">
		<xsl:choose>
			<xsl:when test="$namespace = 'bipm'">31.7</xsl:when>
			<xsl:when test="$namespace = 'bsi'">15</xsl:when>
			<xsl:when test="$namespace = 'pas'">25</xsl:when>
			<xsl:when test="$namespace = 'csa'">25</xsl:when>
			<xsl:when test="$namespace = 'csd'">19</xsl:when>
			<xsl:when test="$namespace = 'gb'">25</xsl:when>
			<xsl:when test="$namespace = 'iec'">25</xsl:when>
			<xsl:when test="$namespace = 'ieee'">31.7</xsl:when>
			<xsl:when test="$namespace = 'iho'">24.5</xsl:when>
			<xsl:when test="$namespace = 'iso'">
				<xsl:choose>
					<xsl:when test="$layoutVersion = '1951'">36</xsl:when>
					<xsl:when test="$layoutVersion = '2024'">15.2</xsl:when>
					<xsl:otherwise>25</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$namespace = 'itu'">20</xsl:when>
			<xsl:when test="$namespace = 'jcgm'">25</xsl:when>
			<xsl:when test="$namespace = 'jis'">
				<xsl:choose>
					<xsl:when test="$vertical_layout = 'true'">19</xsl:when>
					<xsl:otherwise>22</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$namespace = 'm3d'">17.3</xsl:when>
			<xsl:when test="$namespace = 'mpfd'">19</xsl:when>
			<xsl:when test="$namespace = 'nist-cswp' or $namespace = 'nist-sp'">25.4</xsl:when>
			<xsl:when test="$namespace = 'ogc'">35</xsl:when>
			<xsl:when test="$namespace = 'ogc-white-paper'">25.4</xsl:when>
			<xsl:when test="$namespace = 'plateau'">
				<xsl:choose>
					<xsl:when test="$doctype = 'technical-report'">19.5</xsl:when>
					<xsl:otherwise>15.4</xsl:otherwise> <!-- handbook -->
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$namespace = 'rsd'">29</xsl:when>
			<xsl:when test="$namespace = 'unece'">40</xsl:when>
			<xsl:when test="$namespace = 'unece-rec'">40</xsl:when>
			<xsl:otherwise>25.4</xsl:otherwise> <!-- default value for page's left margin -->
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="marginLeftRight1" select="normalize-space($marginLeftRight1_)"/>
	

	<xsl:variable name="marginLeftRight2_">
		<xsl:choose>
			<xsl:when test="$namespace = 'bipm'">40</xsl:when>
			<xsl:when test="$namespace = 'bsi'">22</xsl:when>
			<xsl:when test="$namespace = 'pas'">14</xsl:when>
			<xsl:when test="$namespace = 'csa'">25</xsl:when>
			<xsl:when test="$namespace = 'csd'">19</xsl:when>
			<xsl:when test="$namespace = 'gb'">20</xsl:when>
			<xsl:when test="$namespace = 'iec'">25</xsl:when>
			<xsl:when test="$namespace = 'ieee'">31.7</xsl:when>
			<xsl:when test="$namespace = 'iho'">25</xsl:when>
			<xsl:when test="$namespace = 'iso'">
				<xsl:choose>
					<xsl:when test="$layoutVersion = '1951'">29</xsl:when>
					<xsl:when test="$layoutVersion = '2024'">15.2</xsl:when>
					<xsl:otherwise>12.5</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$namespace = 'itu'">20</xsl:when>
			<xsl:when test="$namespace = 'jcgm'">15</xsl:when>
			<xsl:when test="$namespace = 'jis'">
				<xsl:choose>
					<xsl:when test="$vertical_layout = 'true'">17</xsl:when>
					<xsl:otherwise>22</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$namespace = 'm3d'">17.3</xsl:when>
			<xsl:when test="$namespace = 'mpfd'">19</xsl:when>
			<xsl:when test="$namespace = 'nist-cswp' or $namespace = 'nist-sp'">25.4</xsl:when>
			<xsl:when test="$namespace = 'ogc'">17</xsl:when>
			<xsl:when test="$namespace = 'ogc-white-paper'">25.4</xsl:when>
			<xsl:when test="$namespace = 'plateau'">
				<xsl:choose>
					<xsl:when test="$doctype = 'technical-report'">18</xsl:when>
					<xsl:otherwise>15.4</xsl:otherwise> <!-- handbook -->
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$namespace = 'rsd'">29</xsl:when>
			<xsl:when test="$namespace = 'unece'">40</xsl:when>
			<xsl:when test="$namespace = 'unece-rec'">40</xsl:when>
			<xsl:otherwise>25.4</xsl:otherwise> <!-- default value for page's right margin -->
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="marginLeftRight2" select="normalize-space($marginLeftRight2_)"/>
	
	<xsl:variable name="marginTop_">
		<xsl:choose>
			<xsl:when test="$namespace = 'bipm'">25.4</xsl:when>
			<xsl:when test="$namespace = 'bsi'">27</xsl:when>
			<xsl:when test="$namespace = 'pas'">29.5</xsl:when>
			<xsl:when test="$namespace = 'csa'">25</xsl:when>
			<xsl:when test="$namespace = 'csd'">20.2</xsl:when>
			<xsl:when test="$namespace = 'gb'">35</xsl:when>
			<xsl:when test="$namespace = 'iec'">31</xsl:when>
			<xsl:when test="$namespace = 'ieee'">25.4</xsl:when>
			<xsl:when test="$namespace = 'iho'">25.4</xsl:when>
			<xsl:when test="$namespace = 'iso'">
				<xsl:choose>
					<xsl:when test="$layoutVersion = '2024'">23.5</xsl:when>
					<xsl:otherwise>27.4</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$namespace = 'itu'">20</xsl:when>
			<xsl:when test="$namespace = 'jcgm'">29.5</xsl:when>
			<xsl:when test="$namespace = 'jis'">
				<xsl:choose>
					<xsl:when test="$vertical_layout = 'true'">16</xsl:when> <!-- 9.4 -->
					<xsl:otherwise>30</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$namespace = 'm3d'">35</xsl:when>
			<xsl:when test="$namespace = 'mpfd'">16.5</xsl:when>
			<xsl:when test="$namespace = 'nist-cswp' or $namespace = 'nist-sp'">25.4</xsl:when>
			<xsl:when test="$namespace = 'ogc'">16.5</xsl:when>
			<xsl:when test="$namespace = 'ogc-white-paper'">25.4</xsl:when>
			<xsl:when test="$namespace = 'plateau'">
				<xsl:choose>
					<xsl:when test="$doctype = 'technical-report'">26</xsl:when>
					<xsl:otherwise>16</xsl:otherwise> <!-- handbook -->
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$namespace = 'rsd'">14</xsl:when>
			<xsl:when test="$namespace = 'unece'">30</xsl:when>
			<xsl:when test="$namespace = 'unece-rec'">30</xsl:when>
			<xsl:otherwise>25.4</xsl:otherwise> <!-- default value for page's top margin -->
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="marginTop" select="normalize-space($marginTop_)"/>
	
	<xsl:variable name="marginBottom_">
		<xsl:choose>
			<xsl:when test="$namespace = 'bipm'">22</xsl:when>
			<xsl:when test="$namespace = 'bsi'">22</xsl:when>
			<xsl:when test="$namespace = 'pas'">23</xsl:when>
			<xsl:when test="$namespace = 'csa'">21</xsl:when>
			<xsl:when test="$namespace = 'csd'">20.3</xsl:when>
			<xsl:when test="$namespace = 'gb'">20</xsl:when>
			<xsl:when test="$namespace = 'iec'">15</xsl:when>
			<xsl:when test="$namespace = 'ieee'">25.4</xsl:when>
			<xsl:when test="$namespace = 'iho'">25.4</xsl:when>
			<xsl:when test="$namespace = 'iso'">
				<xsl:choose>
					<xsl:when test="$layoutVersion = '1951'">25.5</xsl:when>
					<xsl:when test="$layoutVersion = '2024'">19.5</xsl:when>
					<xsl:otherwise>15</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$namespace = 'itu'">20</xsl:when>
			<xsl:when test="$namespace = 'jcgm'">23.5</xsl:when>
			<xsl:when test="$namespace = 'jis'">
				<xsl:choose>
					<xsl:when test="$vertical_layout = 'true'">15.2</xsl:when>
					<xsl:otherwise>24.5</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$namespace = 'm3d'">23</xsl:when>
			<xsl:when test="$namespace = 'mpfd'">10</xsl:when>
			<xsl:when test="$namespace = 'nist-cswp' or $namespace = 'nist-sp'">25.4</xsl:when>
			<xsl:when test="$namespace = 'ogc'">22.5</xsl:when>
			<xsl:when test="$namespace = 'ogc-white-paper'">25.4</xsl:when>
			<xsl:when test="$namespace = 'plateau'">
				<xsl:choose>
					<xsl:when test="$doctype = 'technical-report'">26</xsl:when>
					<xsl:otherwise>32</xsl:otherwise> <!-- handbook -->
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$namespace = 'rsd'">22</xsl:when>
			<xsl:when test="$namespace = 'unece'">40</xsl:when>
			<xsl:when test="$namespace = 'unece-rec'">34</xsl:when>
			<xsl:otherwise>25.4</xsl:otherwise> <!-- default value for page's bottom margin -->
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="marginBottom" select="normalize-space($marginBottom_)"/>
	
	<xsl:variable name="layout_columns_default">1</xsl:variable>
	<xsl:variable name="layout_columns_" select="normalize-space((//mn:metanorma)[1]/mn:metanorma-extension/mn:presentation-metadata/mn:layout-columns)"/>
	<xsl:variable name="layout_columns">
		<xsl:choose>
			<xsl:when test="$layout_columns_ != ''"><xsl:value-of select="$layout_columns_"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$layout_columns_default"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:attribute-set name="page-sequence-preface">
		<xsl:attribute name="format">i</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:template name="refine_page-sequence-preface">
		<xsl:param name="layoutVersion"/>
	</xsl:template>
	
	<xsl:attribute-set name="page-sequence-main">
	
	</xsl:attribute-set>
	
	<xsl:template name="refine_page-sequence-main">
		<xsl:param name="layoutVersion"/>
		<xsl:if test="$namespace = 'iso'">
			<xsl:if test="position() = 1">
				<xsl:attribute name="initial-page-number">1</xsl:attribute>
			</xsl:if>
			<xsl:if test="$layoutVersion = '1951'">
				<xsl:attribute name="initial-page-number">auto</xsl:attribute>
				<xsl:attribute name="force-page-count">end-on-even</xsl:attribute>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	
</xsl:stylesheet>