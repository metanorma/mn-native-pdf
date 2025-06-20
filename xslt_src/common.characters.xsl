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
	
	<!-- Characters -->
	<xsl:variable name="linebreak">&#x2028;</xsl:variable>
	<xsl:variable name="tab_zh">&#x3000;</xsl:variable>
	<xsl:variable name="non_breaking_hyphen">&#x2011;</xsl:variable>
	<xsl:variable name="thin_space">&#x2009;</xsl:variable>	
	<xsl:variable name="zero_width_space">&#x200B;</xsl:variable>
	<xsl:variable name="hair_space">&#x200A;</xsl:variable>
	<xsl:variable name="en_dash">&#x2013;</xsl:variable>
	<xsl:variable name="em_dash">&#x2014;</xsl:variable>
	<xsl:variable name="nonbreak_space_em_dash_space">&#xa0;— </xsl:variable>
	<xsl:variable name="cr">&#x0d;</xsl:variable>
	<xsl:variable name="lf">&#x0a;</xsl:variable>

	<xsl:variable name="lower">abcdefghijklmnopqrstuvwxyz</xsl:variable> 
	<xsl:variable name="upper">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>

	<xsl:variable name="en_chars" select="concat($lower,$upper,',.`1234567890-=~!@#$%^*()_+[]{}\|?/')"/>

</xsl:stylesheet>