<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:exsl="http://exslt.org/common"
	xmlns:str="http://exslt.org/strings"
	extension-element-prefixes="exsl str"
	xmlns:xalan="http://xml.apache.org/xalan"
	exclude-result-prefixes="xalan"
	>

	<!--
		process <typein>, <mlTypein> and <itemTypein> interaction answers here ... but....

		DO NOT GENERATE ANSWERS FOR : ...

			<typein example="y">
		or
			<mlTypein example="y">
		or
			<itemTypein example="y">
		or
			<locating>
				<typein>
		or
			<typeinGroup example="y">
				<typein ...>
		or
			<typeinGroup>
				<typein example="y">
		or
			<itemTypeinGroup example="y">
				<itemTypein>
		or
			<itemTypeinGroup>
				<itemTypein example="y">
	-->

	<xsl:template match="
		typein[not (ancestor::locating) and not (@example='y') and not (ancestor::typeinGroup[@example='y'])]
		| mlTypein[not (@example='y') ]
		| itemTypein[not (@example='y') and not(ancestor::itemTypeinGroup[@example='y'])]
	" mode="outputAnswers">
		<xsl:variable name="markType">
			<xsl:choose>
				<xsl:when test="@marked='n' or (ancestor::activity/@marked='n')">unmarked</xsl:when>
				<xsl:otherwise>item</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="markedBy">
			<xsl:choose>
				<xsl:when test="$markType='unmarked'">nobody</xsl:when>
				<xsl:otherwise>engine</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="jsonType">
			<xsl:choose>
				<xsl:when test="@expandAnswers='y' and (contains(acceptable/item[1],'{'))">choice</xsl:when>
				<xsl:when test="count(acceptable/item)>1">choice</xsl:when>
				<xsl:otherwise>simple</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="not(ancestor::typeinGroup) and not(ancestor::itemTypeinGroup)">
			,
		</xsl:if>
		{
			"elm": "<xsl:value-of select="@id"/>",
			"type": "<xsl:value-of select="$jsonType"/>",
			"markType": "<xsl:value-of select="$markType"/>",
			"markedBy": "<xsl:value-of select="$markedBy"/>",
			<xsl:if test="not(@caseSensitive='y') and (@caseSensitive='n' or ancestor::typeinGroup/@caseSensitive='n' or ancestor::itemTypeinGroup/@caseSensitive='n')">
			"caseSensitive": "n",
			</xsl:if>
			<xsl:if test="@ignorePunctuation='y'">
			"ignorePunctuation": "y",
			</xsl:if>
			"value":
			<xsl:choose>
				<xsl:when test="not(@expandAnswers='y')">
					<xsl:choose>
						<xsl:when test="$jsonType='simple'">
							"<xsl:call-template name="escapeQuote"><xsl:with-param name="pText" select="acceptable/item"/></xsl:call-template>"
						</xsl:when>
						<xsl:otherwise>
						[
							<xsl:for-each select="acceptable/item">
								"<xsl:call-template name="escapeQuote"/>"<xsl:if test="position()!=last()">,</xsl:if>
							</xsl:for-each>
						]
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<!-- expand the answers into a tokenizable variable -->
					<xsl:variable name="answers">
						<xsl:for-each select="acceptable/item">
							<xsl:call-template name="expandAnswers">
								<xsl:with-param name="stringVal"><xsl:value-of select="."/></xsl:with-param>
							</xsl:call-template>
							<xsl:if test="position()!=last()">|</xsl:if>
						</xsl:for-each>
					</xsl:variable>

					<xsl:choose>
						<xsl:when test="count(str:tokenize($answers, '|'))>1">
							[
								<xsl:for-each select="str:tokenize($answers, '|')">
									<xsl:value-of select="."/><xsl:if test="position()!=last()">,</xsl:if>
								</xsl:for-each>
							]
						</xsl:when>
						<xsl:otherwise>
							<!-- remove the first '|' character that the 'expandAnswers' template inserts -->
							<xsl:value-of select="substring($answers, 1, string-length($answers))"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		}
	</xsl:template>

	<!--
		template matching typein / mlTypein / itemTypein with expandableAnswers='y' for the MODE detectInvalidAnswers
		- should return :

			, { "error": " ... description of the error, hopefully with some useful information ... " }

		- returns a *COMMA* first because we insert a placeholder as the first item, then don't need to worry about / do expensive xslt lookups
		  to see if there are any following interactions of this type (not even sure if that can be done tbh !)
	-->
	<xsl:template match="
		typein[@expandAnswers='y' and (not (ancestor::locating) and not (@example='y') and not (ancestor::typeinGroup[@example='y']))]
		| mlTypein[@expandAnswers='y' and not (@example='y') ]
		| itemTypein[@expandAnswers='y' and not (@example='y') and not(ancestor::itemTypeinGroup[@example='y'])]
	" mode="detectInvalidAnswers">
		<xsl:variable name="containerName">
			<xsl:choose>
				<xsl:when test="ancestor::activity">activity</xsl:when>
				<xsl:when test="ancestor::itemList">items file</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:for-each select="acceptable/item">
			<xsl:variable name="leftCount"><xsl:value-of select="count(str:tokenize(concat(' ', ., ' '), '{'))"/></xsl:variable>
			<xsl:variable name="rightCount"><xsl:value-of select="count(str:tokenize(concat(' ', ., ' '), '}'))"/></xsl:variable>
			<xsl:if test="$leftCount != $rightCount">
				,{ "error": "ERROR ! Expandable answers in <xsl:value-of select="$containerName"/> (<xsl:value-of select="name(../..)"/> id='<xsl:value-of select="../../@id"/>) - Brackets are not correctly paired ! item id='<xsl:value-of select="@id"/>' : '<xsl:value-of select="."/>'" }
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

</xsl:stylesheet>
