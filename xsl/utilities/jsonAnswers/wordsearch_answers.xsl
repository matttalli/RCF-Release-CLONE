<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:exsl="http://exslt.org/common"
	xmlns:str="http://exslt.org/strings"
	extension-element-prefixes="exsl str"
	xmlns:xalan="http://xml.apache.org/xalan"
	exclude-result-prefixes="xalan"
	>

	<xsl:template match="wordSearch[not(@example='y')] | fixedWordSearch[not(@example='y')]" mode="outputAnswers">
		<xsl:variable name="markType">
			<xsl:choose>
				<xsl:when test="not(@interactive='n') and not(@marked='n') and not(ancestor::activity/@marked='n')">item</xsl:when>
				<xsl:otherwise>unmarked</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="markedBy">
			<xsl:choose>
				<xsl:when test="$markType='unmarked'">nobody</xsl:when>
				<xsl:otherwise>engine</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		,
		{
			"elm": "<xsl:value-of select="@id"/>",
			"type": "list",
			"markType": "<xsl:value-of select="$markType"/>",
			"markedBy": "<xsl:value-of select="$markedBy"/>",
			"value": [
				<xsl:for-each select="words/word[not(@example='y')]">"<xsl:value-of select="translate(., $lowercase, $uppercase)"/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>
			]
		}
	</xsl:template>

</xsl:stylesheet>
