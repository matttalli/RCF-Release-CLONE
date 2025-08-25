<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:str="http://exslt.org/strings" exclude-result-prefixes="str"
	xmlns:exsl="http://xml.apache.org/xalan">

	<xsl:template match="typein | itemTypein | mlTypein" mode="longestItem">
		<xsl:variable name="longestItemAnswer">
			<xsl:choose>
				<xsl:when test="not(@expandAnswers='y')">
					<xsl:for-each select="acceptable/item">
						<xsl:sort select="string-length(.)" data-type="number" order="descending"/>
						<xsl:if test="position()=1"><xsl:value-of select="."/></xsl:if>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="answers"><xsl:call-template name="expandAnswers"><xsl:with-param name="stringVal"><xsl:value-of select="acceptable/item[1]"/></xsl:with-param><xsl:with-param name="quoteAnswers" select="'n'"/></xsl:call-template></xsl:variable>
					<xsl:for-each select="str:tokenize(normalize-space($answers), '|')">
						<xsl:sort select="string-length(.)" data-type="number" order="descending"/>
						<xsl:if test="position()=1"><xsl:value-of select="."/></xsl:if>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="presetAnswer"><xsl:value-of select="preset/text()"/></xsl:variable>
		<xsl:choose>
			<xsl:when test="string-length($longestItemAnswer) &gt; string-length($presetAnswer)"><xsl:value-of select="$longestItemAnswer"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$presetAnswer"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="calculateResizeType">
		<xsl:param name="resize"/>
		<xsl:choose>
			<xsl:when test="$resize='content'">content</xsl:when>
			<xsl:otherwise>activity</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="text()" mode="longestItem"/>

	<xsl:template name="typeinAriaLabel">
		<xsl:param name="typeinElement"/>
		<xsl:variable name="enumeration"><xsl:value-of
				select="count(preceding::typein[not(@example='y')]) + count(preceding::mlTypein[not(@example='y')]) + count(preceding::textInput) + count(preceding::mlTextInput) + count(preceding::itemTypein) + 1" /></xsl:variable>
		<xsl:choose>
			<xsl:when test="$typeinElement/@example">[ interactions.typein.example ]</xsl:when>
			<xsl:otherwise>[ interactions.typein.standard ] <xsl:value-of select="$enumeration" /></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
