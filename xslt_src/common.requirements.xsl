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
	
	<xsl:attribute-set name="permission-style">
		<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>

	<xsl:attribute-set name="permission-name-style">
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>			
			<xsl:attribute name="padding-top">0.5mm</xsl:attribute>
			<xsl:attribute name="padding-bottom">1mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">1mm</xsl:attribute>
			<xsl:attribute name="background-color">rgb(165,165,165)</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>

	<xsl:attribute-set name="permission-label-style">
		<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>

	<xsl:attribute-set name="requirement-style">
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>

	<xsl:attribute-set name="requirement-name-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'iso'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>			
			<xsl:attribute name="margin-bottom">4pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>			
			<xsl:attribute name="padding-top">0.5mm</xsl:attribute>
			<xsl:attribute name="padding-bottom">1mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">1mm</xsl:attribute>
			<xsl:attribute name="background-color">rgb(165,165,165)</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>

	<xsl:attribute-set name="requirement-label-style">
		<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>

	<xsl:attribute-set name="subject-style">
	</xsl:attribute-set>
	
	<xsl:attribute-set name="inherit-style">
	</xsl:attribute-set>
	
	<xsl:attribute-set name="description-style">
	</xsl:attribute-set>
	
	<xsl:attribute-set name="specification-style">
	</xsl:attribute-set>
	
	<xsl:attribute-set name="measurement-target-style">
	</xsl:attribute-set>
	
	<xsl:attribute-set name="verification-style">
	</xsl:attribute-set>
	
	<xsl:attribute-set name="import-style">
	</xsl:attribute-set>
	
	<xsl:attribute-set name="component-style">
	</xsl:attribute-set>
	
	<xsl:attribute-set name="recommendation-style">
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="border">1pt solid black</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-sp'">
			<xsl:attribute name="margin-left">20mm</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="recommendation-name-style">
		<xsl:if test="$namespace = 'iho'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>			
			<xsl:attribute name="padding-top">0.5mm</xsl:attribute>
			<xsl:attribute name="padding-bottom">1mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">1mm</xsl:attribute>
			<xsl:attribute name="background-color">rgb(165,165,165)</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
		</xsl:if>
		<xsl:if test="$namespace = 'nist-sp'">
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="recommendation-label-style">
		<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		</xsl:if>
	</xsl:attribute-set>
	
	<!-- ========== -->
	<!-- permission -->	
	<!-- ========== -->		
	<xsl:template match="mn:permission">
		<xsl:call-template name="setNamedDestination"/>
		<fo:block id="{@id}" xsl:use-attribute-sets="permission-style">			
			<xsl:apply-templates select="mn:fmt-name" />
			<xsl:apply-templates select="node()[not(self::mn:fmt-name)]" />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="mn:permission/mn:fmt-name">
		<xsl:if test="normalize-space() != ''">
			<xsl:choose>
			
				<xsl:when test="$namespace = 'iho'">
					<fo:inline xsl:use-attribute-sets="permission-name-style">
						<xsl:apply-templates /><xsl:text>:</xsl:text>
					</fo:inline>
				</xsl:when>
				
				<xsl:otherwise>
					<fo:block xsl:use-attribute-sets="permission-name-style">
						<xsl:apply-templates />
						<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
							<xsl:text>:</xsl:text>
						</xsl:if>
					</fo:block>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="mn:permission/mn:label">
		<fo:block xsl:use-attribute-sets="permission-label-style">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	<!-- ========== -->
	<!-- ========== -->
	
	<!-- ========== -->
	<!-- requirement -->
	<!-- ========== -->
	<xsl:template match="mn:requirement">
		<xsl:call-template name="setNamedDestination"/>
		<fo:block id="{@id}" xsl:use-attribute-sets="requirement-style">			
			<xsl:apply-templates select="mn:fmt-name" />
			<xsl:apply-templates select="mn:label" />
			<xsl:apply-templates select="@obligation"/>
			<xsl:apply-templates select="mn:subject" />
			<xsl:apply-templates select="node()[not(self::mn:fmt-name) and not(self::mn:label) and not(self::mn:subject)]" />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="mn:requirement/mn:fmt-name">
		<xsl:if test="normalize-space() != ''">
			<xsl:choose>
			
				<xsl:when test="$namespace = 'iho'">
					<fo:inline xsl:use-attribute-sets="requirement-name-style">
						<xsl:apply-templates /><xsl:text>:</xsl:text>
					</fo:inline>
				</xsl:when>
				
				<xsl:otherwise>
		
					<fo:block xsl:use-attribute-sets="requirement-name-style">
						<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
							<xsl:if test="../@type = 'class'">
								<xsl:attribute name="background-color">white</xsl:attribute>
							</xsl:if>
						</xsl:if>
						<xsl:apply-templates />
						<xsl:if test="$namespace = 'iso' or $namespace = 'ogc' or $namespace = 'ogc-white-paper'">
							<xsl:text>:</xsl:text>
						</xsl:if>
					</fo:block>
					
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="mn:requirement/mn:label">
		<fo:block xsl:use-attribute-sets="requirement-label-style">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="mn:requirement/@obligation">
			<fo:block>
				<fo:inline padding-right="3mm">Obligation</fo:inline><xsl:value-of select="."/>
			</fo:block>
	</xsl:template>
	
	<xsl:template match="mn:requirement/mn:subject" priority="2">
		<fo:block xsl:use-attribute-sets="subject-style">
			<xsl:text>Target Type </xsl:text><xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<!-- ========== -->
	<!-- ========== -->
	
	<!-- ========== -->
	<!-- recommendation -->
	<!-- ========== -->
	<xsl:template match="mn:recommendation">
		<xsl:call-template name="setNamedDestination"/>
		<fo:block id="{@id}" xsl:use-attribute-sets="recommendation-style">
			<xsl:apply-templates select="mn:fmt-name" />
			<xsl:apply-templates select="node()[not(self::mn:fmt-name)]" />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="mn:recommendation/mn:fmt-name">
		<xsl:if test="normalize-space() != ''">
			<xsl:choose>
			
				<xsl:when test="$namespace = 'iho'">
					<fo:inline xsl:use-attribute-sets="recommendation-name-style">
						<xsl:apply-templates /><xsl:text>:</xsl:text>
					</fo:inline>
				</xsl:when>
				
				<xsl:otherwise>
				
					<fo:block xsl:use-attribute-sets="recommendation-name-style">
						<xsl:apply-templates />
						<xsl:if test="$namespace = 'nist-sp'">
							<xsl:text>:</xsl:text>
						</xsl:if>
					</fo:block>
					
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="mn:recommendation/mn:label">
		<fo:block xsl:use-attribute-sets="recommendation-label-style">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	<!-- ========== -->
	<!-- END recommendation -->
	<!-- ========== -->
	
	<!-- ========== -->
	<!-- ========== -->
	
	
	<xsl:template match="mn:subject">
		<fo:block xsl:use-attribute-sets="subject-style">
			<xsl:text>Target Type </xsl:text><xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="mn:div">
		<fo:block><xsl:apply-templates /></fo:block>
	</xsl:template>
	
	<xsl:template match="mn:inherit | mn:component[@class = 'inherit'] |
										mn:div[@type = 'requirement-inherit'] |
										mn:div[@type = 'recommendation-inherit'] |
										mn:div[@type = 'permission-inherit']">
		<fo:block xsl:use-attribute-sets="inherit-style">
			<xsl:text>Dependency </xsl:text><xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="mn:description | mn:component[@class = 'description'] |
										mn:div[@type = 'requirement-description'] |
										mn:div[@type = 'recommendation-description'] |
										mn:div[@type = 'permission-description']">
		<fo:block xsl:use-attribute-sets="description-style">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="mn:specification | mn:component[@class = 'specification'] |
										mn:div[@type = 'requirement-specification'] |
										mn:div[@type = 'recommendation-specification'] |
										mn:div[@type = 'permission-specification']">
		<fo:block xsl:use-attribute-sets="specification-style">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="mn:measurement-target | mn:component[@class = 'measurement-target'] |
										mn:div[@type = 'requirement-measurement-target'] |
										mn:div[@type = 'recommendation-measurement-target'] |
										mn:div[@type = 'permission-measurement-target']">
		<fo:block xsl:use-attribute-sets="measurement-target-style">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="mn:verification | mn:component[@class = 'verification'] |
										mn:div[@type = 'requirement-verification'] |
										mn:div[@type = 'recommendation-verification'] |
										mn:div[@type = 'permission-verification']">
		<fo:block xsl:use-attribute-sets="verification-style">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="mn:import | mn:component[@class = 'import'] |
										mn:div[@type = 'requirement-import'] |
										mn:div[@type = 'recommendation-import'] |
										mn:div[@type = 'permission-import']">
		<fo:block xsl:use-attribute-sets="import-style">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="mn:div[starts-with(@type, 'requirement-component')] |
										mn:div[starts-with(@type, 'recommendation-component')] |
										mn:div[starts-with(@type, 'permission-component')]">
		<fo:block xsl:use-attribute-sets="component-style">
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	<!-- ========== -->
	<!-- END  -->
	<!-- ========== -->
	
	<!-- ========== -->
	<!-- requirement, recommendation, permission table -->
	<!-- ========== -->
	<xsl:template match="mn:table[@class = 'recommendation' or @class='requirement' or @class='permission']">
		<fo:block-container margin-left="0mm" margin-right="0mm" margin-bottom="12pt" role="SKIP">
			<xsl:if test="ancestor::mn:table[@class = 'recommendation' or @class='requirement' or @class='permission']">
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			</xsl:if>
			<xsl:call-template name="setNamedDestination"/>
			<fo:block-container margin-left="0mm" margin-right="0mm" role="SKIP">
				<fo:table id="{@id}" table-layout="fixed" width="100%"> <!-- border="1pt solid black" -->
					<xsl:if test="ancestor::mn:table[@class = 'recommendation' or @class='requirement' or @class='permission']">
						<!-- <xsl:attribute name="border">0.5pt solid black</xsl:attribute> -->
					</xsl:if>
					<xsl:variable name="simple-table">	
						<xsl:call-template name="getSimpleTable">
							<xsl:with-param name="id" select="@id"/>
						</xsl:call-template>
					</xsl:variable>					
					<xsl:variable name="cols-count" select="count(xalan:nodeset($simple-table)//mn:tr[1]/mn:td)"/>
					<xsl:if test="$cols-count = 2 and not(ancestor::*[local-name()='table'])">
						<fo:table-column column-width="30%"/>
						<fo:table-column column-width="70%"/>
					</xsl:if>
					<xsl:apply-templates mode="requirement"/>
				</fo:table>
				<!-- fn processing -->
				<xsl:if test=".//mn:fn">
					<xsl:for-each select="mn:tbody">
						<fo:block font-size="90%" border-bottom="1pt solid black">
							<xsl:call-template name="table_fn_display" />
						</fo:block>
					</xsl:for-each>
				</xsl:if>
			</fo:block-container>
		</fo:block-container>
	</xsl:template>
	
	<xsl:template match="*[local-name()='thead']" mode="requirement">		
		<fo:table-header>			
			<xsl:apply-templates mode="requirement"/>
		</fo:table-header>
	</xsl:template>
	
	<xsl:template match="*[local-name()='tbody']" mode="requirement">		
		<fo:table-body>
			<xsl:apply-templates mode="requirement"/>
		</fo:table-body>
	</xsl:template>
	
	<xsl:template match="*[local-name()='tr']" mode="requirement">
		<fo:table-row height="7mm" border-bottom="0.5pt solid grey">
		
			<xsl:if test="parent::*[local-name()='thead'] or starts-with(*[local-name()='td' or local-name()='th'][1], 'Requirement ') or starts-with(*[local-name()='td' or local-name()='th'][1], 'Recommendation ')">
				<xsl:attribute name="font-weight">bold</xsl:attribute>
				
				<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
					<xsl:attribute name="font-weight">normal</xsl:attribute>
					<xsl:if test="parent::*[local-name()='thead']"> <!-- and not(ancestor::mn:table[@class = 'recommendation' or @class='requirement' or @class='permission']) -->
						<xsl:attribute name="background-color"><xsl:value-of select="$color_table_header_row"/></xsl:attribute>
					</xsl:if>
					<xsl:if test="starts-with(*[local-name()='td'][1], 'Requirement ')">
						<xsl:attribute name="background-color">rgb(252, 246, 222)</xsl:attribute>
					</xsl:if>
					<xsl:if test="starts-with(*[local-name()='td'][1], 'Recommendation ')">
						<xsl:attribute name="background-color">rgb(233, 235, 239)</xsl:attribute>
					</xsl:if>
				</xsl:if>
			</xsl:if>
			
			<xsl:apply-templates mode="requirement"/>
		</fo:table-row>
	</xsl:template>
	
	
	<xsl:template match="*[local-name()='th']" mode="requirement">
		<fo:table-cell text-align="{@align}" display-align="center" padding="1mm" padding-left="2mm"> <!-- border="0.5pt solid black" -->
			<xsl:call-template name="setTextAlignment">
				<xsl:with-param name="default">left</xsl:with-param>
			</xsl:call-template>
			
			<xsl:call-template name="setTableCellAttributes"/>
			
			<fo:block role="SKIP">
				<xsl:apply-templates />
			</fo:block>
		</fo:table-cell>
	</xsl:template>
	
	
	<xsl:template match="*[local-name()='td']" mode="requirement">
		<fo:table-cell text-align="{@align}" display-align="center" padding="1mm" padding-left="2mm" > <!-- border="0.5pt solid black" -->
			<xsl:if test="mn:table[@class = 'recommendation' or @class='requirement' or @class='permission']">
				<xsl:attribute name="padding">0mm</xsl:attribute>
				<xsl:attribute name="padding-left">0mm</xsl:attribute>
			</xsl:if>
			<xsl:call-template name="setTextAlignment">
				<xsl:with-param name="default">left</xsl:with-param>
			</xsl:call-template>
			
			<xsl:if test="following-sibling::*[local-name()='td'] and not(preceding-sibling::*[local-name()='td'])">
				<xsl:attribute name="font-weight">bold</xsl:attribute>
			</xsl:if>
			
			<xsl:call-template name="setTableCellAttributes"/>
			
			<fo:block role="SKIP">			
				<xsl:apply-templates />
			</fo:block>			
		</fo:table-cell>
	</xsl:template>
	
	<xsl:template match="mn:p[@class='RecommendationTitle' or @class = 'RecommendationTestTitle']" priority="2">
		<fo:block font-size="11pt">
			<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
				<!-- <xsl:attribute name="color"><xsl:value-of select="$color_design"/></xsl:attribute> -->
				<xsl:attribute name="color">white</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'p2'][ancestor::mn:table[@class = 'recommendation' or @class='requirement' or @class='permission']]">
		<fo:block>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>
	<!-- ========== -->
	<!-- END requirement, recommendation, permission table -->
	<!-- ========== -->
	
	
</xsl:stylesheet>