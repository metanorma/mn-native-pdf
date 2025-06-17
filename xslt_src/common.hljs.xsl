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
	
	
	<!-- Highlight.js syntax GitHub styles -->
	<xsl:attribute-set name="hljs-doctag">
		<xsl:attribute name="color">#d73a49</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-keyword">
		<xsl:attribute name="color">#d73a49</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-meta_hljs-keyword">
		<xsl:attribute name="color">#d73a49</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-template-tag">
		<xsl:attribute name="color">#d73a49</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-template-variable">
		<xsl:attribute name="color">#d73a49</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-type">
		<xsl:attribute name="color">#d73a49</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-variable_and_language_">
		<xsl:attribute name="color">#d73a49</xsl:attribute>
	</xsl:attribute-set>
  
	<xsl:attribute-set name="hljs-title">
		<xsl:attribute name="color">#6f42c1</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-title_and_class_">
		<xsl:attribute name="color">#6f42c1</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-title_and_class__and_inherited__">
		<xsl:attribute name="color">#6f42c1</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-title_and_function_">
		<xsl:attribute name="color">#6f42c1</xsl:attribute>
	</xsl:attribute-set>
  
	<xsl:attribute-set name="hljs-attr">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-attribute">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-literal">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-meta">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-number">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-operator">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-variable">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-selector-attr">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-selector-class">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-selector-id">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
	</xsl:attribute-set>
  
	<xsl:attribute-set name="hljs-regexp">
		<xsl:attribute name="color">#032f62</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-string">
		<xsl:attribute name="color">#032f62</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-meta_hljs-string">
		<xsl:attribute name="color">#032f62</xsl:attribute>
	</xsl:attribute-set>
  
	<xsl:attribute-set name="hljs-built_in">
		<xsl:attribute name="color">#e36209</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-symbol">
		<xsl:attribute name="color">#e36209</xsl:attribute>
	</xsl:attribute-set>
  
	<xsl:attribute-set name="hljs-comment">
		<xsl:attribute name="color">#6a737d</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-code">
		<xsl:attribute name="color">#6a737d</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-formula">
		<xsl:attribute name="color">#6a737d</xsl:attribute>
	</xsl:attribute-set>
  
	<xsl:attribute-set name="hljs-name">
		<xsl:attribute name="color">#22863a</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-quote">
		<xsl:attribute name="color">#22863a</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-selector-tag">
		<xsl:attribute name="color">#22863a</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-selector-pseudo">
		<xsl:attribute name="color">#22863a</xsl:attribute>
	</xsl:attribute-set>
  
	<xsl:attribute-set name="hljs-subst">
		<xsl:attribute name="color">#24292e</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="hljs-section">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
	</xsl:attribute-set>
  
	<xsl:attribute-set name="hljs-bullet">
		<xsl:attribute name="color">#735c0f</xsl:attribute>
	</xsl:attribute-set>
  
	<xsl:attribute-set name="hljs-emphasis">
		<xsl:attribute name="color">#24292e</xsl:attribute>
		<xsl:attribute name="font-style">italic</xsl:attribute>
	</xsl:attribute-set>
  
	<xsl:attribute-set name="hljs-strong">
		<xsl:attribute name="color">#24292e</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
	</xsl:attribute-set>
  
	<xsl:attribute-set name="hljs-addition">
		<xsl:attribute name="color">#22863a</xsl:attribute>
		<xsl:attribute name="background-color">#f0fff4</xsl:attribute>
	</xsl:attribute-set>
  
	<xsl:attribute-set name="hljs-deletion">
		<xsl:attribute name="color">#b31d28</xsl:attribute>
		<xsl:attribute name="background-color">#ffeef0</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="hljs-char_and_escape_">
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-link">
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-params">
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-property">
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-punctuation">
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-tag">
	</xsl:attribute-set>
	<!-- End Highlight syntax styles -->
	
</xsl:stylesheet>