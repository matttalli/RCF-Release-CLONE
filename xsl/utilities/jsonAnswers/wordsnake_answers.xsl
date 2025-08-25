<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:exsl="http://exslt.org/common"
	xmlns:str="http://exslt.org/strings"
	extension-element-prefixes="exsl str"
	xmlns:xalan="http://xml.apache.org/xalan"
	exclude-result-prefixes="xalan"
	>

	<xsl:template match="wordSnake[not(@example='y')]" mode="outputAnswers">
		<xsl:variable name="markType">
			<xsl:choose>
				<xsl:when test="@marked='n' or(@interactive='n') or (ancestor::activity/@marked='n')">unmarked</xsl:when>
				<xsl:otherwise>item</xsl:otherwise>
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
				<xsl:for-each select="words/word[not(@example='y') and not(@distractor='y')]"><xsl:variable name="precedingWordString"><xsl:for-each select="preceding-sibling::word"><xsl:value-of select="."/></xsl:for-each></xsl:variable>"<xsl:call-template name="letters"><xsl:with-param name="text" select="."/><xsl:with-param name="letterCount" select="string-length($precedingWordString)+1"/><xsl:with-param name="wordSnakeID" select="ancestor::wordSnake/@id"/><xsl:with-param name="wordID" select="@id"/></xsl:call-template>"
					<xsl:if test="position()!=last()">,</xsl:if>
				</xsl:for-each>
			]
		}
	</xsl:template>

	<xsl:template name="letters">
		<xsl:param name="text" />
		<xsl:param name="letterCount" select="'1'"/>
		<xsl:param name="wordSnakeID" />
		<xsl:param name="wordID"/>
		<xsl:param name="wordExample"/>
		<xsl:if test="$text!=''">
			<xsl:variable name="letter" select="substring($text, 1, 1)"/>
			<xsl:value-of select="$wordSnakeID"/>_L<xsl:value-of select="$letterCount"/><xsl:if test="substring-after($text, $letter)!=''">,</xsl:if>
 			<xsl:call-template name="letters">
				<xsl:with-param name="text" select="substring-after($text, $letter)"/>
				<xsl:with-param name="wordSnakeID" select="$wordSnakeID"/>
				<xsl:with-param name="wordID" select="$wordID"/>
				<xsl:with-param name="wordExample" select="$wordExample"/>
				<xsl:with-param name="letterCount" select="$letterCount+1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>