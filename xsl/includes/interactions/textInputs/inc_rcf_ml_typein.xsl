<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:str="http://exslt.org/strings" exclude-result-prefixes="str"
                xmlns:exsl="http://xml.apache.org/xalan"
                version="1.0">
    <!-- HTML for multilined typein / textarea -->
	<xsl:template match="mlTypein">
		<xsl:variable name="longestItem"><xsl:apply-templates select="." mode="longestItem"/></xsl:variable>
		<xsl:variable name="exampleClass"><xsl:if test="@example='y'">example</xsl:if></xsl:variable>
		<xsl:variable name="ariaLabel">
			<xsl:call-template name="typeinAriaLabel">
				<xsl:with-param name="typeinElement" select="."/>
			</xsl:call-template>
		</xsl:variable>

		<!-- RCF-11369 - mlTypein can be output inside a p, but it needs to be inside span elements and not divs -->
		<xsl:variable name="containerElement">
			<xsl:choose>
				<xsl:when test="ancestor::p">span</xsl:when>
				<xsl:otherwise>div</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:element name="{$containerElement}">
			<xsl:attribute name="data-rcfid"><xsl:value-of select="@id"/></xsl:attribute>
			<xsl:attribute name="data-rcfinteraction">markedTextInput</xsl:attribute>
			<xsl:attribute name="data-longestItem"><xsl:value-of select="string-length($longestItem)"/></xsl:attribute>
			<xsl:attribute name="class"><xsl:value-of select="normalize-space(concat('mlTypein', ' ', $exampleClass, ' ', @class))"/></xsl:attribute>

			<xsl:if test="preset"><xsl:attribute name="data-preset-answer"><xsl:value-of select="preset/text()"/></xsl:attribute></xsl:if>
			<xsl:if test="$authoring='Y'"><xsl:attribute name="data-rcfxlocation"><xsl:call-template name="genPath"/></xsl:attribute></xsl:if>

			 <xsl:element name="{$containerElement}">
			 	<xsl:attribute name="class">markable dev-markable-container</xsl:attribute>

				<textarea
					autocomplete="off"
					autocapitalize="off"
					spellcheck="false"
					autocorrect="off"
					class="mlTypein {$exampleClass} rcfTextArea markedTextInput"
					data-rcfTranslate=""
					aria-label="{$ariaLabel}"
				>
					<xsl:if test="@caseSensitive">
						<xsl:attribute name="data-casesensitive"><xsl:value-of select="@caseSensitive"/></xsl:attribute>
					</xsl:if>
					<xsl:if test="@ignorePunctuation">
						<xsl:attribute name="data-ignorepunctuation"><xsl:value-of select="@ignorePunctuation"/></xsl:attribute>
					</xsl:if>
					<xsl:if test="preset"><xsl:attribute name="data-preset-answer"><xsl:value-of select="preset/text()"/></xsl:attribute></xsl:if>
					<xsl:if test="@example='y'">
						<xsl:attribute name="readonly"/>
						<xsl:copy-of select="acceptable/item[1]/text()"/>
					</xsl:if>
				</textarea>
				<span class="mark">&#160;&#160;&#160;&#160;</span>
			</xsl:element>
		</xsl:element>
	</xsl:template>

	<xsl:template match="mlTypein/preset"/>

	<!-- rcf_typein -->
	<xsl:template match="mlTypein" mode="getRcfClassName">
		rcfTypein
	</xsl:template>

</xsl:stylesheet>
