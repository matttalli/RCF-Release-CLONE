<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:exsl="http://exslt.org/common"
	xmlns:str="http://exslt.org/strings"
	extension-element-prefixes="exsl str"
	xmlns:xalan="http://xml.apache.org/xalan"
	exclude-result-prefixes="xalan"
>
<!--
	handles the answer json generation for all *sentenceBuilder* style interactions :

		<sentenceBuilder>
		<itemSentenceBuilder>

-->

	<!-- match against non-example sentenceBuilder or itemSentenceBuilder in the xml for answers generation -->
	<xsl:template match="sentenceBuilder[not(@example='y')] | itemSentenceBuilder[not(@example='y')]" mode="outputAnswers">
		<xsl:variable name="markType">
			<xsl:choose>
				<xsl:when test="@marked='n' or (ancestor::activity/@marked='n')">unmarked</xsl:when>
				<xsl:otherwise>list</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="markedBy">
			<xsl:choose>
				<xsl:when test="$markType='unmarked'">nobody</xsl:when>
				<xsl:otherwise>engine</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!--
			need to escape all answers for quotes, cr+lf and backslashes (mathjax)
		-->
		<xsl:variable name="prefixValue"><xsl:apply-templates select="items/prefix" mode="outputSentenceBuilderAnswer"/></xsl:variable>
		<xsl:variable name="suffixValue"><xsl:apply-templates select="items/suffix" mode="outputSentenceBuilderAnswer"/></xsl:variable>
		<xsl:variable name="itemsValue"><xsl:apply-templates select="items/item" mode="outputSentenceBuilderAnswer"/></xsl:variable>
		<xsl:variable name="defaultAnswer"><xsl:value-of select="concat($prefixValue, $itemsValue, $suffixValue)"/></xsl:variable>
		<xsl:variable name="trimmedAnswer"><xsl:value-of select="translate(translate($defaultAnswer, ' ', ''), $uppercase, $lowercase)"/></xsl:variable>
		<xsl:variable name="escapedAnswer"><xsl:call-template name="escapeQuote"><xsl:with-param name="pText" select="$trimmedAnswer"/></xsl:call-template></xsl:variable>
		,
		{
			"elm": "<xsl:value-of select="@id"/>",
			"type": "choice",
			"markType": "<xsl:value-of select="$markType"/>",
			"markedBy": "<xsl:value-of select="$markedBy"/>",
			"items": [
				<xsl:for-each select="items/item">"<xsl:value-of select="@id"/>"<xsl:if test="not(position()=last())">,</xsl:if></xsl:for-each>
			],
			"value": [
				"<xsl:value-of select="$escapedAnswer"/>"
				<xsl:if test="alternativeAnswers">,
					<xsl:apply-templates select="alternativeAnswers/item" mode="outputSentenceBuilderAnswer"/>
				</xsl:if>
			]
		}
	</xsl:template>

	<xsl:template match="sentenceBuilder[count(items/item[@fixed='y']) = count(items/item)]" mode="detectInvalidAnswers">
		,{
			"error" : "Error ! all items are set to fixed=y in this sentence builder interaction: '<xsl:value-of select="@id"/>'"
		}
	</xsl:template>

	<xsl:template match="itemSentenceBuilder[count(items/item[@fixed='y']) = count(items/item)]" mode="detectInvalidAnswers">
		,{
			"error" : "Error ! all items are set to fixed=y in this item based sentence builder interaction: '<xsl:value-of select="@id"/>'"
		}
	</xsl:template>

	<!-- match against any child items/item, items/prefix or items/suffix element with the expected mode -->
	<xsl:template match="items/item | items/prefix | items/suffix" mode="outputSentenceBuilderAnswer">
		<xsl:variable name="textValue"><xsl:apply-templates select="." mode="outputSentenceBuilderAnswerText"/></xsl:variable>
		<xsl:variable name="escapedValue">
			<xsl:call-template name="str:replace">
				<xsl:with-param name="string" select="$textValue"/>
				<xsl:with-param name="search" select="'\'"/>
				<xsl:with-param name="replace" select="'\\'"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:value-of select="translate(translate($escapedValue, ' &#10;&#13;', ''), $uppercase, $lowercase)"/>
	</xsl:template>

	<xsl:template match="alternativeAnswers/item" mode="outputSentenceBuilderAnswer">
		<xsl:variable name="textValue"><xsl:copy-of select="."/></xsl:variable>
		<xsl:variable name="escapedValue">
			<xsl:call-template name="str:replace">
				<xsl:with-param name="string" select="$textValue"/>
				<xsl:with-param name="search" select="'\'"/>
				<xsl:with-param name="replace" select="'\\'"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="trimmedTextValue"><xsl:value-of select="translate($escapedValue, ' ', '')"/></xsl:variable>
		<xsl:variable name="escapedQuotedValue"><xsl:call-template name="escapeQuote"><xsl:with-param name="pText" select="$trimmedTextValue"/></xsl:call-template></xsl:variable>
		"<xsl:value-of select="translate(translate($escapedQuotedValue, ' &#10;&#13;', ''), $uppercase, $lowercase)"/>"
		<xsl:if test="count(following-sibling::item)>0">,</xsl:if>
	</xsl:template>

	<xsl:template match="text()" mode="outputSentenceBuilderAnswerText">
		<xsl:copy/>
	</xsl:template>

</xsl:stylesheet>
